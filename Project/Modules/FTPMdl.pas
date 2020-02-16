unit FTPMdl;       //Module
{$I REG.INC}

interface
uses
  Windows,SysUtils, Classes, DB, kbmMemTable, kbmMemCSVStreamFormat,HKTransfer,
  HKTransferFTP,HKTransferSFTP,hyperfrm,
  HyperStr,OptFolders,PasswordEntryFrm,dialogs,ComCtrls,Forms, HakaFile,
  ScriptInfoUnit,FTPUploadFrm,janXMLTree,CommConvUnit,OptGeneral,HakaGeneral,hakawin,
  OptProcs, IdAntiFreeze, ImgList, Controls, IdBaseComponent,ShellAPI,hakahyper,
  IdAntiFreezeBase, HKCSVParser, OptOptions, DIPcre;

type
  TFTPMod = class(TDataModule)
    TransTable: TkbmMemTable;
    TransTablePort: TIntegerField;
    TransTableUsername: TStringField;
    TransTablePassword: TStringField;
    TransTableShebang: TStringField;
    TransSource: TDataSource;
    TransTableNotes: TMemoField;
    TransTablePassive: TBooleanField;
    TransTableSession: TStringField;
    TransTableProxyPort: TIntegerField;
    TransTableProxyPassword: TStringField;
    TransTableProxyServer: TStringField;
    TransTableServer: TStringField;
    TransTableProxyUsername: TStringField;
    TransTableVersionConvert: TBooleanField;
    TransTableSavePassword: TBooleanField;
    TransTableLinksTo: TStringField;
    TransTableLastFolder: TStringField;
    TransTableAccount: TStringField;
    TransTableChangeShebang: TBooleanField;
    TransTableProxyType: TStringField;
    TransTableAliases: TStringField;
    TransTableDocRoot: TStringField;
    AntiFreeze: TIdAntiFreeze;
    SysImages: TImageList;
    TransTableType: TStringField;
    CSV: THKCSVParser;
    TransTableFavorites: TMemoField;
    ModePcre: TDIPcre;
    procedure DataModuleCreate(Sender: TObject);
    procedure TransTableDirectoryChange(Sender: TField);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TransTableAfterUpdate(DataSet: TDataSet);
    procedure TransTableBeforeEdit(DataSet: TDataSet);
    function CSVReadNewLine(Sender: TObject; var Line: String;
      LineNum: Integer): Boolean;
    procedure CSVSetData(Sender: TObject; const Data: array of String);
    procedure TransSpecialChange(Sender: TField);
  Private
    Modified: boolean;
    RecommendedModes : TStringList;
    Procedure CheckSession(const Name: String);
    function GetPasswords(const Session: String): Boolean;
  public
    Sessions : TStringList;
    Procedure GetRecommendedMode(const filename : string; Out Text : Boolean; Out Mode : Integer);
    procedure UpdateRecommendedModes;
    procedure SessionDestroy(sender: TObject);
    procedure GetFavorites(const Session: String; Fav: TStrings);
    procedure SetFavorites(const Session: String; Fav: TStrings);
    procedure TerminateSessions;
    procedure LoadFile;
    procedure SaveFile;
    Function GetSafeSessionName(Const Host : String) : String;
    procedure CloseSession(var Trans: TBaseTransfer);
    Procedure OpenSession(const name : String; Var Trans : TBaseTransfer; AutoList : Boolean;
                       OnFileListUpdated : TNotifyEvent; OnStatus : TStatusEvent;
                       Const InitialOverride : String);
    Procedure SetLastFolder(const Session : String; Trans : TBaseTransfer);
    Procedure GetSessions(Strings : TStrings; Expanded : Boolean = false);
    Procedure UploadActive;
    Function GetLocalFile(const Session,Path,Name : String) : String;
    Procedure DoFileDownload(Const Session,LocalPath,RemoteFile : String; Trans : TBaseTransfer);
    function DoFilePreProcess(const Session, LocalPath: String;
       out TempFile: String; Text: Boolean): Boolean;
    procedure DownloadFile(const Sess, RemotePath, RemoteFile, LocalTarget: String);
  end;

var
  FTPMod: TFTPMod;

implementation
{$R *.dfm}

const
 key = 'awE#5w4v';

Type
 TMode = Packed Record
  Mode : Word;  // 1000=Dont Change
  Text : Byte;  // 1=text 0=binary 2=Dont Change
  Dumb : Byte;  // Future
 end;

Procedure TFTPMod.UpdateRecommendedModes;
var
 i : Integer;
 sl : TStringList;
 s : String;
 m : TMode;
begin
 sl:=TStringList.Create;
 try
  sl.LoadFromFile(ProgramPath+'Default Modes.txt');
  RecommendedModes.Clear;
  for i:=0 to sl.Count-1 do
   if Modepcre.MatchStr(sl[i])>0 then
   begin
    m.Dumb:=0;
    m.Mode:=StrToIntDef(ModePcre.SubStr(2),1000);
    s:=UpperCase(ModePcre.SubStr(3));
    if s='TEXT' then m.Text:=1   else
    if s='BINARY' then m.Text:=0 else
     m.Text:=2;
    s:=ModePcre.SubStr(1);
    RecommendedModes.AddObject(s,TObject(m));
   end;
 finally
  sl.free;
 end;
end;

Procedure TFTPMod.GetRecommendedMode(const filename : string; Out Text : Boolean; Out Mode : Integer);
var
 i:integer;
 m:TMode;
 f:string;
begin
 text:=true;
 Mode:=755;
 f:=ExtractFilename(filename);
 if pos('.',f)=0 then
  f:=f+'.';

 for i:=0 to RecommendedModes.count-1 do
  if IsFileinMask(f,RecommendedModes[i]) then
  begin
   m:=TMode(RecommendedModes.objects[i]);
   if m.Mode<>1000 then
    mode:=m.Mode;
   case m.Text of
    0 : text:=false;
    1 : Text:=true;
   end;
 end;
end;

Function TFTPMod.GetPasswords(Const Session : String) : Boolean;
var
 pass : string;
 FWAlso : Boolean;
begin
 result:=false;
 if not TransTable.FindKey([Session]) then exit;

 result:=true;
 if TransTableSavePassword.AsBoolean then exit;

 if TransTablePassword.Value='' then
 begin
  pass:='';
  result:=false;
  if (not (passwordEntryFrm.Execute(pass,0,'Enter password for session '+TransTableSession.Value,'Password input')))
   then exit;
  TransTable.Edit;
  TransTablePassword.Value:=pass;
  TransTable.Post;
  result:=true;
 end;

 FWAlso:=uppercase(TransTableProxyType.Value)='SITE';

 if (result) and (FWAlso) and (TransTableProxyPassword.Value='')  then
 begin
  pass:='';
  result:=false;
   if (not (passwordEntryFrm.Execute(pass,0,'Enter password for proxy server '+TransTableProxyServer.Value,'Password input')))
    then exit;
  TransTable.Edit;
  TransTableProxyPassword.Value:=pass;
  TransTable.Post;
  result:=true;
 end;
end;

procedure TFTPMod.CheckSession(const Name : String);
var
 i:integer;
 bt : TBaseTransfer;
begin
 i:=sessions.IndexOf(name);
 if i<0 then exit;
 bt:=TBaseTransfer(sessions.Objects[i]);
 if not bt.busy
  then //xxx bt.recheckconnect
  else raise EFTPError.Create('Session '+name+' is in use.');
end;

Procedure TFTPMod.CloseSession(Var Trans : TBaseTransfer);
begin
 if not assigned(trans) then exit;
 trans.OnStatus:=nil;
 trans.OnFileListUpdated:=nil;
 trans.BeingUsed:=false;
 if not options.KeepSessionsAlive
  then FreeAndNil(trans)
  else
   if assigned(PR_ReLinkSession) then PR_ReLinkSession(trans,false);
end;

procedure TFTPMod.TerminateSessions;
var i:integer;
begin
 for i:=sessions.Count-1 downto 0 do
  TBaseTransfer(sessions.Objects[i]).Free;
end;

procedure TFTPMod.SessionDestroy(sender : TObject);
var
 i:integer;
begin
 i:=sessions.IndexOfObject(sender);
 if i>=0 then
 begin
  sessions.Delete(i);
  if options.KeepSessionsAlive and assigned(PR_ReLinkSession) then
   PR_ReLinkSession(sender,true)
 end;
end;

procedure TFTPMod.GetFavorites(Const Session : String; Fav : TStrings);
var s:string;
begin
 if TransTable.FindKey([Session])
  then s:=TransTableFavorites.AsString
  else s:='';
 fav.Text:=DecodeIni(s);
end;

procedure TFTPMod.SetFavorites(Const Session : String; Fav : TStrings);
begin
 if not TransTable.FindKey([Session]) then exit;
 transtable.Edit;
 TransTableFavorites.AsString:=EncodeIni(fav.Text);
 transtable.post;
end;

Procedure TFTPMod.OpenSession(const name : String; Var Trans : TBaseTransfer; AutoList : Boolean;
                               OnFileListUpdated : TNotifyEvent; OnStatus : TStatusEvent;
                               Const InitialOverride : String);
var
 s,dir:string;
 i:integer;
begin
 Trans:=nil;
 if not TransTable.FindKey([name]) then
  raise EFtpError.Create('Could not find session '+Name);

 if not GetPasswords(name) then
  raise EFTPError.Create('Invalid password');

 s:=trim(uppercase(TransTableType.Value));

 if not options.KeepSessionsAlive then
  i:=-1
 else
  begin
   CheckSession(name);
   i:=Sessions.IndexOf(name);
  end;

 if i<0 then
  begin
   if (s = '') or (s = 'FTP') then
    Trans:=TFTPTransfer.Create
   else
   if (s = 'SECURE FTP') then
    Trans:=TSFTPTransfer.Create
   else
    raise EFTPError.Create('Could not create "'+s+'" type session');
  end
 else
  begin
   trans:=TBaseTransfer(sessions.objects[i]);
   if assigned(PR_LinkSession) then
    PR_LinkSession(trans);
   if trans.BeingUsed then
    raise EFTPError.Create('Session is being used by another window. Cannot continue');
  end;

 Trans.OnStatus:=OnStatus;
 Trans.AutoGetFileList:=AutoList;
 trans.OnFileListUpdated:=OnFileListUpdated;
 trans.OnDisconnected:=SessionDestroy;

 if initialoverride=#0 then
 begin
  if TransTableLastFolder.Value<>''
   then s:=TransTableLastFolder.Value
   else s:=TransTableDocRoot.Value;
 end
  else
   s:=initialoverride;

 dir:=s;

 Trans.port:=TransTablePort.Value;
 Trans.Host:=TransTableServer.Value;
 Trans.UserName:=TransTableUsername.Value;
 Trans.Password:=TransTablePassWord.Value;

 trans.SetProp(tfPassive,TransTablePassive.AsBoolean);
 trans.SetProp(tfAccount,TransTableAccount.AsString);
 trans.SetProp(tfProxyHost,TransTableProxyServer.AsString);
 trans.SetProp(tfProxyUsername,TransTableProxyUsername.AsString);
 trans.SetProp(tfProxyPassword,TransTableProxyPassword.AsString);
 trans.SetProp(tfProxyPort,TransTableProxyPort.AsInteger);
 trans.SetProp(tfProxyType,TransTableProxyType.AsString);

 try
  if i<0 then
   begin
    trans.beingused:=true;
    Trans.Connect(dir);
    if options.KeepSessionsAlive then
     sessions.AddObject(name,trans);
   end
  else
   begin
    if dir=''
     then trans.ChangeDirectory(trans.PathOnConnect)
     else trans.ChangeDirectory(dir);
   end;
  trans.KeepAliveTimer.enabled:=options.SessionKeepAliveInterval>0;
  trans.KeepAliveTimer.Interval:=options.SessionKeepAliveInterval*1000;
 except
  if assigned(Trans) then
   FreeAndNil(trans);
  raise;
 end;
end;

procedure TFTPMod.LoadFile;
begin
 TransTable.EmptyTable;
 CopyFile(pchar(Folders.UserFolder+'FTP Sessions.csv'),pchar(folders.TransSessFile),true);
 if fileexists(folders.TransSessFile) then
  csv.LoadFromFile(folders.TransSessFile);
end;

procedure TFTPMod.DataModuleCreate(Sender: TObject);
var
 ShInfo: TSHFileInfo;
begin
 Sessions:=TStringList.Create;
 Sessions.Sorted:=true;
 sessions.Duplicates:=dupError;
 RecommendedModes:=TStringList.Create;
 UpdateRecommendedModes;

 with SysImages do
 begin
  ShareImages := True;
  Handle := SHGetFileInfo('', 0, ShInfo, SizeOf(TSHFileInfo),
             SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
 end;

 try
  LoadFile;
 except
  on exception do TransTable.Cancel;
 end;
end;

procedure TFTPMod.GetSessions(Strings: TStrings; Expanded : Boolean = false);
var
 c : Integer;
 s:string;
 AdCon,AdDis : Boolean;
begin
 if Expanded then
 begin
  AdCon:=false;
  AdDis:=false;
  Strings.Add('---- Connected ----');
  Strings.Add('--- Disconnected ---');
  c:=1;
 end;

 TransTable.First;
 while not TransTable.Eof do
 begin
  s:=TransTableSession.AsString;
  if not expanded then
   Strings.Add(s)
  else
   begin
    if Sessions.IndexOf(s)>=0 then
     begin
      strings.insert(c,s);
      AdCon:=true;
      inc(c);
     end
    else
     begin
      strings.add(s);
      AdDis:=true;
     end;
   end;
  TransTable.Next;
 end;
 TransTable.First;

 if Expanded then
 begin
  if not adcon then Strings.Delete(0);
  if not adDis then strings.Delete(strings.Count-1);
 end;
end;

function TFTPMod.GetLocalFile(const Session, Path, Name: String): String;
var d:string;
begin
 result:='';
 if (session='') or (name='') then exit;
 if not TransTable.FindKey([Session]) then exit;
 d:=path;
 replaceC(d,'/','\');
 replaceSC(d,':','%DRV%',false);
 d:=IncludeTrailingBackSlash(d);
 if (d<>'') and (d[1]='\') then delete(d,1,1);
 d:=folders.FTPFolder+session+'\'+d;
 if ForceDirectories(d)
  then result:=d+name
  else raise EFTPError.Create('Could not create folder'+#13#10+d);
end;

procedure TFTPMod.SetLastFolder(const Session: String; Trans : TBaseTransfer);
begin
 if not TransTable.FindKey([Session]) then exit;
 if not assigned(trans) then exit;
 TransTable.Edit;
 TransTableLastFolder.Value:=Trans.CurrentDirectory;
 TransTable.Post;
 Modified:=true;
end;

procedure TFTPMod.TransTableDirectoryChange(Sender: TField);
begin
 TransTableLastFolder.Value:='';
end;

procedure TFTPMod.DataModuleDestroy(Sender: TObject);
begin;
 TerminateSessions;
 Sessions.Free;
 RecommendedModes.Free;
 if modified then SaveFile;
end;

procedure TFTPMod.DownloadFile(const Sess, RemotePath, RemoteFile, LocalTarget: String);
var
 Trans : TBaseTransfer;
 tempfile : string;
begin
 if (not assigned(ActiveScriptInfo)) then exit;
 if (sess='') then exit;

 FTPUploadForm:=TFTPUploadForm.Create(Application);
 FTPUploadForm.Show;
 try
  OpenSession(sess,Trans,false,nil,
   FTPUploadForm.onstatus,RemotePath);
  FTPUploadForm.Trans:=Trans;
  DoFileDownload(sess,LocalTarget,RemoteFile,trans);
 finally
  FTPMod.CloseSession(trans);
  FTPUploadForm.Free;
 end;
end;

procedure TFTPMod.UploadActive;
var
 Trans : TBaseTransfer;
 sess : String;
 tempfile : string;
begin
 if (not assigned(ActiveScriptInfo)) then exit;

 sess:=ActiveScriptInfo.GetFTPSession;
 if (sess='') then exit;

 FTPUploadForm:=TFTPUploadForm.Create(Application);
 FTPUploadForm.Show;
 try
  OpenSession(sess,Trans,false,nil,
   FTPUploadForm.onstatus,ActiveScriptInfo.GetFTPFolder);

  FTPUploadForm.Trans:=Trans;
  PR_QuickSave;

  FTPUploadForm.btnClose.Enabled:=true;
  if DoFilePreProcess(ActiveScriptInfo.GetFTPSession,
         ActiveScriptINfo.path,tempfile,true) then
  begin
   Trans.TextTransfer:=true;
   Trans.Put(tempfile,ExtractFilename(ActiveScriptINfo.path));
   if ActiveScriptINfo.path<>tempfile then
    deletefile(tempfile);
   ActiveScriptInfo.FTPModified:=false;
  end;
 finally
  FTPMod.CloseSession(trans);
  FTPUploadForm.Free;
 end;
end;

procedure TFTPMod.DoFileDownload(const Session, LocalPath,
  RemoteFile: String; Trans : TBaseTransfer);
var
 eol : Integer;
 s:string;
 sl:TStringList;
begin
 if not TransTable.FindKey([Session]) then exit;
 trans.TextTransfer:=false;
 trans.Get(remotefile,localpath);
 if TransTableVersionConvert.Value then
 begin
  sl:=TStringList.Create;
  try
   s:=LoadStr(localPath);
   eol:=GetEOLCharacter(s);
   sl.Text:=s;
   MakeVersion(sl,'LOCAL');
   SaveFileWithEOlChar(sl,eol,localpath);
  finally
   sl.Free;
  end;
 end;

end;

Function TFTPMod.DoFilePreProcess(const Session, LocalPath: String;
                  Out TempFile : String; Text : Boolean) : Boolean;
var
 sl:TStringList;
 s:string;
 i:integer;
begin
 result:=false;
 if not TransTable.FindKey([Session]) then exit;
 if not FileExists(LocalPath) then exit;
 if Text then
  begin
   TempFile:=GetTempFile;
   sl:=TStringList.Create;

   try
    s:=LoadStr(localPath);
    i:=GetEOLCharacter(s);
    if i>=0 then
     begin
      sl.Text:=s;
      if TransTableVersionConvert.Value then
       MakeVersion(sl,'SERVER');
      if TransTableChangeShebang.Value then
       SetSheBang(sl,TransTableShebang.Value);
      SaveFileWithEOlChar(sl,i,tempfile);
     end
    else
     saveStr(s,tempfile);
    result:=true;
   finally
    sl.free;
   end;
  end
 else
  begin
   TempFile:=LocalPath;
   result:=true;
  end;
end;

function TFTPMod.GetSafeSessionName(const Host: String): String;
var i:integer;
begin
 i:=0;
 result:=Host;
 while TransTable.FindKey([result]) do
 begin
  inc(i);
  result:=host+inttostr(i);
 end;
end;

procedure TFTPMod.TransTableAfterUpdate(DataSet: TDataSet);
begin
 if assigned(PR_UpdateSessionTree) then
  PR_UpdateSessionTree;
 if assigned(PR_SessionEditMode) then
  PR_SessionEditMode(false);
end;

procedure TFTPMod.TransTableBeforeEdit(DataSet: TDataSet);
begin
 if assigned(PR_SessionEditMode) then
  PR_SessionEditMode(true);
end;

function TFTPMod.CSVReadNewLine(Sender: TObject; var Line: String;
  LineNum: Integer): Boolean;
begin
 result:=not StringStartsWithCase('"Session","Server","Port"',line);
end;

procedure TFTPMod.CSVSetData(Sender: TObject; const Data: array of String);
var up : string;
begin
 try
 if length(data)>=21 then
 begin
  TRansTable.Append;
  TRansTableSession.asstring:=data[0];
  TRansTableServer.asstring:=data[1];
  TRansTablePort.AsString:=data[2];
  TRansTableUsername.asstring:=data[3];
  try
   up:=decodestr(data[4]);
   crypt(up,key);
  except on exception do up:=''; end;
  TRansTablePassword.asstring:=up;
  TRansTableAccount.asstring:=data[5];
  TRansTablePassive.asstring:=data[6];
  TRansTableDocRoot.asstring:=data[7];
  TRansTableLinksTo.asstring:=data[8];
  TRansTableAliases.asstring:=data[9];
  TRansTableProxyServer.asstring:=data[10];
  TRansTableProxyPort.asstring:=data[11];
  TRansTableProxyType.asstring:=data[12];
  TRansTableProxyUsername.asstring:=data[13];
  try
   up:=decodestr(data[14]);
   crypt(up,key);
  except on exception do up:=''; end;
  TRansTableProxyPassword.asstring:=up;
  TRansTableLastFolder.asstring:=data[15];
  TRansTableVersionConvert.asstring:=data[16];
  TRansTableSheBang.asstring:=data[17];
  TRansTableChangeShebang.asstring:=data[18];
  TRansTableNotes.asstring:=data[19];
  TRansTableSavePassword.asstring:=data[20];
  TRansTableType.asstring:='FTP';
 end;
 if length(data)>=23 then
 begin
  TRansTableType.Value:=data[21];
  TransTableFavorites.AsString:=data[22];
 end;
 TransTable.post;
 except on exception do
  transtable.Cancel;
 end;
end;

procedure TFTPMod.SaveFile;
var
 up,fp : string;
begin
 TransTable.First;
 CSV.Lines.Clear;
 while not transtable.Eof do
 begin
  if TRansTableSavePassword.AsBoolean then
   begin
    up:=TRansTablePassword.asstring;
    crypt(up,key);
    up:=encodeStr(up);

    fp:=TRansTableProxyPassword.asstring;
    crypt(fp,key);
    fp:=encodeStr(fp);
   end
  else
   begin
    up:=''; fp:='';
   end;

  csv.AddData([
  TRansTableSession.asstring,
  TRansTableServer.asstring,
  TRansTablePort.asstring,
  TRansTableUsername.asstring,
  up,
  TRansTableAccount.asstring,
  TRansTablePassive.asstring,
  TRansTableDocRoot.asstring,
  TRansTableLinksTo.asstring,
  TRansTableAliases.asstring,
  TRansTableProxyServer.asstring,
  TRansTableProxyPort.asstring,
  TRansTableProxyType.asstring,
  TRansTableProxyUsername.asstring,
  fp,
  TRansTableLastFolder.asstring,
  TRansTableVersionConvert.asstring,
  TRansTableSheBang.asstring,
  TRansTableChangeShebang.asstring,
  TRansTableNotes.asstring,
  TRansTableSavePassword.asstring,
  TRansTableType.asstring,
  TRansTableFavorites.asstring
  ]);
  transtable.Next;
 end;
 CSV.SaveToFile(folders.TransSessFile);
 Modified:=false;
end;

procedure TFTPMod.TransSpecialChange(Sender: TField);
begin
 if TransTableSession.AsString<>'' then
  PR_ResetFileAges(TransTableSession.AsString);
end;


end.
