unit HKTransferFTP;

interface
uses sysutils,classes,idFTP,idFTPList,IdFTPCommon,IdException,IdLogEvent,HKTransfer,
     IdComponent,hakageneral,agpropUtils;

Type
  TFTPTransfer = class(TBaseTransfer)
  Private
   FTP : TidFTP;
   FTPLogEvent : TIdLogEvent;
   FAccount : String;
   FBusy : Boolean;
   FDoingConnection : Boolean;
   procedure FTPLogReceive(ASender: TComponent; const AText,AData: string);
   procedure FTPLogSend(ASender: TComponent; const AText,AData: string);
  protected
   Function GetConnected : Boolean; Override;
   Function GetBusy : Boolean; Override;
   Procedure SetUsername(Const Text:String); override;
   Function GetUsername : String; override;
   Procedure SetPassword(Const Text:String); override;
   Function GetPassword : String; override;
   Procedure SetHost(Const Text:String); override;
   Function GetHost : String; override;
   Procedure SetPort(Port : integer); override;
   Function GetPort : Integer; override;
   Function GetLoginMessage : String; Override;

   Function GetTextTranfer : boolean; override;
   Procedure SetTextTransfer(Text : boolean); override;

   Procedure IntCHMod(const FileName : String; Mode : Integer); Override;
   procedure IntDeleteFile(const Filename: String); override;
   Procedure IntCreateDirectory(Const Dir : String); override;
   Procedure IntChangeDirectory(Const Dir : String); override;
   Procedure IntRemoveDirectory(Const Dir : String); override;
   Procedure IntGet(Const RemoteFile,LocalFile : String); override;
   Procedure IntPut(Const LocalFile,RemoteFile : String); override;
   Procedure IntChangeDirUp; Override;
   Procedure IntCustom(Const Text : String); Override;
   Procedure IntRename(const OldFile,NewFile : String); override;
   Procedure IntConnect; override;
   Procedure IntDisconnect; override;
   Procedure IntAbort; Override;
   Function IntGetCurrectDirectory : String; override;
   Procedure IntUpdateFileList; override;
   procedure IntDoDumbCommand; override;
   Procedure UpdateConnectedFromLastError(CloseOnAnyError : Boolean); Override;
  public
   Constructor Create;
   Destructor Destroy; Override;
   Procedure SetProp(Prop : TTransferFields; Val : Variant); Override;
  end;

implementation

{ TFTPTransfer }

//Create & Destroy

constructor TFTPTransfer.Create;
begin
 Inherited Create;
 FTP:=TidFTP.Create(nil);
 FTPLogEvent:=TIDLogEvent.Create(nil);
 FTP.Intercept:=FTPLogEvent;
 FTPLogEvent.OnSent:=FTPLogSend;
 FTPLogEvent.OnReceived:=FTPLogReceive;
 FTPLogEvent.Active:=true;
 FTPLogEvent.LogTime:=false;
 FTPLogEvent.ReplaceCRLF:=false;
end;

destructor TFTPTransfer.Destroy;
begin
 inherited;
 FTP.Free;
 FTPLogEvent.Free;
end;

//INT Methods

procedure TFTPTransfer.IntUpdateFileList;
var
 i:integer;
 sl : TStringList;
begin
 FBusy:=true;
 sl:=TStringList.create;
 try
  // test
  //sl.LoadFromFile('f:\tests\Transfer.log');
  //ftp.DirectoryListing.LoadList(sl);
  //
  ftp.List(sl);
  //
  for i:=0 to sl.Count-1 do
   AddStatus(sl[i]);
 finally
  FBusy:=false;
  sl.free;
 end;

 with ftp.DirectoryListing do
 begin
  setlength(Filelist,Count);
  for i:=0 to Count-1 do
  begin
   FileList[i].Filename:=items[i].FileName;
   FileList[i].Size:=items[i].Size;
   filelist[i].Modified:=items[i].ModifiedDate;
   filelist[i].ItemType:=TItemType(items[i].ItemType);
   filelist[i].Attributes:=items[i].OwnerPermissions+
    items[i].GroupPermissions+items[i].UserPermissions;
  end;
 end;

end;

procedure TFTPTransfer.IntConnect;
var
 i:integer;
begin
 FBusy:=true;
 i:=0;
 try
  FDoingConnection:=true;

  while (i<6) and (not FTP.Connected) do
  try
   inc(i);
   FTP.Connect;
  except on
   EIdConnClosedGracefully do
   begin
    FTP.Disconnect;
    LastError:='Could not connect.';
   end;
  end;

  if (Faccount<>'') and (FTP.Connected) then
   FTP.Account(FAccount);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
 FDoingConnection:=false;
end;

procedure TFTPTransfer.IntCustom(const Text: String);
begin
 FBusy:=true;
 try
  FTP.SendCmd(Text);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntChangeDirUp;
begin
 FBusy:=true;
 try
  FTP.ChangeDirUp;
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntDoDumbCommand;
begin
 //'PWD', 'CWD .', 'SYST', 'FEAT', and 'NOOP'.
 IntGetCurrectDirectory;
end;

procedure TFTPTransfer.IntCreateDirectory(const Dir: String);
begin
 FBusy:=true;
 try
  FTP.MakeDir(dir);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntChangeDirectory(const Dir: String);
begin
 FBusy:=true;
 try
  FTP.ChangeDir(dir);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntDisconnect;
begin
 FBusy:=true;
 try
  FTP.Disconnect;
 except on E:exception do
  if not (e is EIdConnClosedGracefully) then
   LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntGet(const RemoteFile, LocalFile: String);
begin
 FBusy:=true;
 try
  FTP.Get(RemoteFile,LocalFile,true,false);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntDeleteFile(const Filename: String);
begin
 FBusy:=true;
 try
  FTP.Delete(Filename);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntCHMod(const FileName: String; Mode: Integer);
begin
 FBusy:=true;
 try
  FTP.SendCmd('SITE CHMOD '+inttostr(Mode)+' '+Filename);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

Function TFTPTransfer.IntGetCurrectDirectory : String;
begin
 FBusy:=true;
 try
  result:=ftp.RetrieveCurrentDir;
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntAbort;
begin
 FBusy:=true;
 try
  ftp.Abort;
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntPut(const LocalFile, RemoteFile: String);
begin
 FBusy:=true;
 try
  FTP.Put(localfile,remotefile,false);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntRemoveDirectory(const Dir: String);
begin
 FBusy:=true;
 try
  FTP.RemoveDir(dir);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

procedure TFTPTransfer.IntRename(const OldFile, NewFile: String);
begin
 FBusy:=true;
 try
  FTP.Rename(Oldfile,newfile);
 except on E:exception do
  LastError:=E.Message;
 end;
 FBusy:=false;
end;

// EVENTS

procedure TFTPTransfer.FTPLogSend(ASender: TComponent; const AText,AData: string);
const
 pass = 'PASS ';
begin
 if StringStartsWith(pass,adata) then
  AddStatus('> '+pass+'********')
 else
 AddStatus('> '+AData);
end;

procedure TFTPTransfer.FTPLogReceive(ASender: TComponent; const AText,AData: string);
begin
 AddStatus(AData);
end;

// GET & Set

procedure TFTPTransfer.SetHost(const Text: String);
begin
 FTP.Host:=text;
end;

procedure TFTPTransfer.SetPassword(const Text: String);
begin
 FTP.Password:=text;
end;

procedure TFTPTransfer.SetPort(Port: integer);
begin
 FTP.Port:=port;
end;

procedure TFTPTransfer.SetTextTransfer(Text: boolean);
begin
 if text
  then FTP.TransferType:=ftASCII
  else FTP.TransferType:=ftBinary;
end;

procedure TFTPTransfer.SetUsername(const Text: String);
begin
 FTP.Username:=text;
end;

function TFTPTransfer.GetConnected: Boolean;
begin
 try //2004-01 steve.dunning@mayples.co.uk.elf
  result:=FTP.Connected and (not FDoingConnection);
 except
  result:=false;
 end;
end;

function TFTPTransfer.GetBusy: Boolean;
begin
 Result:=FBusy;
end;

function TFTPTransfer.GetHost: String;
begin
 result:=FTP.Host;
end;

function TFTPTransfer.GetLoginMessage: String;
begin
 result:=trim(ftp.LoginMsg.Text.Text);
end;

function TFTPTransfer.GetPassword: String;
begin
 result:=ftp.Password;
end;

function TFTPTransfer.GetPort: Integer;
begin
 result:=FTP.Port;
end;

function TFTPTransfer.GetTextTranfer: boolean;
begin
 result:=FTP.TransferType=ftASCII;
end;

function TFTPTransfer.GetUsername: String;
begin
 result:=ftp.Username;
end;

procedure TFTPTransfer.UpdateConnectedFromLastError(CloseOnAnyError : Boolean);
begin
 if ( (not CloseOnAnyError) and (StringStartsWithCase('Socket Error #',LastError)) ) or
    ( (CloseOnAnyError) and (Trim(LastError)<>'') ) then
  FTP.Disconnect;
end;

procedure TFTPTransfer.SetProp(Prop : TTransferFields; Val: Variant);
var
 s:string;
begin
 case prop of
  tfPassive: ftp.Passive:=val;
  tfAccount: FAccount:=val;
  tfProxyHost:  FTP.ProxySettings.Host:=val;
  tfProxyUsername:  FTP.ProxySettings.UserName:=val;
  tfProxyPassword:  FTP.ProxySettings.Password:=val;
  tfProxyPort:  FTP.ProxySettings.Port:=val;
  tfProxyType:
  begin
   s:=uppercase(val);
   if s='OPEN' then
    FTP.ProxySettings.ProxyType:=fpcmOpen
   else if s='SITE' then
    FTP.ProxySettings.ProxyType:=fpcmSite
   else if s='USER' then
    FTP.ProxySettings.ProxyType:=fpcmUserSite
   else if s='USERPASS' then
    FTP.ProxySettings.ProxyType:=fpcmUserPass
   else if s='TRANSPARENT' then
    FTP.ProxySettings.ProxyType:=fpcmTRANSPARENT
   else
    FTP.ProxySettings.ProxyType:=fpcmNone;
  end;

 end;
end;

end.
