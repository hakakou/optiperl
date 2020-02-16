unit HKTransferSFTP;

interface
uses Windows,sysutils,classes,HKTransfer,DIPcre,forms,hyperstr,hakapipes,hakageneral,
     Dialogs,controls,HKModeSelectForm,hyperfrm;

type
  TSFTPTransfer = class(TBaseTransfer)
  Private
   CurDirPcre : TDiPCre;
   List1Pcre : TDiPcre;
   List2Pcre : TDiPcre;
   List3Pcre : TDiPcre;
   KeyPcre : TDiPcre;

   GUI : THKGui;
   FBusy : Boolean;
   FAborted : Boolean;
   FConnected : Boolean;
   FPort : Integer;
   FUsername : String;
   FPassword : String;
   FHost : String;
   FTextTransfer : Boolean;
   Function WaitForText(const Text: String) : Boolean;
   function WaitPrompt: Boolean;
   procedure DoCommand(const Comm: String);
   procedure GUIRead(Sender: TObject; const Text: String);
   Procedure CheckSymLink(var Item: TItemData);
   function FixPath(const Path: String): String;
   procedure SetCmdLine;
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
   Procedure IntChangeDirUp; Override;
   Procedure IntGet(Const RemoteFile,LocalFile : String); override;
   Procedure IntPut(Const LocalFile,RemoteFile : String); override;
   Procedure IntCustom(Const Text : String); Override;
   Procedure IntRename(const OldFile,NewFile : String); override;
   Procedure IntConnect; override;
   Procedure IntAbort; Override;
   Procedure IntDisconnect; override;
   Function IntGetCurrectDirectory : String; override;
   Procedure IntUpdateFileList; override;
   procedure IntDoDumbCommand; override;
   Procedure UpdateConnectedFromLastError(CloseOnAnyError : Boolean); Override;
  public
   Constructor Create;
   Destructor Destroy; Override;
  end;


implementation

{ TSFTPTransfer }

// CREATE & DESTROY

constructor TSFTPTransfer.Create;
begin
 Inherited Create;
 GUI:=THKGui.Create;
 GUI.OnRead:=GUIRead;

 CurDirPcre:=TDIPcre.Create(nil);
 CurDirPcre.MatchPattern:='Remote directory is (?:|now )([^\x0d\x0a]+)';

 List1Pcre:=TDIPcre.Create(nil);
 List1Pcre.MatchPattern:='[\x0d\x0a]+(\d+)-(\d+)-(\d+)\s+(\d+):(\d+)(pm|am|)\s+(\S+)\s+([^\x0d\x0a]+)';

 List2Pcre:=TDIPcre.Create(nil);
 List2Pcre.matchPattern:='[\x0d\x0a]+(\d+)(\d{3})\s+\d+\s+\d+\s+(\d+)\s+(\d+)\s([^\x0d\x0a]+)';

 List3Pcre:=TDIPcre.Create(nil);
// List3Pcre.MatchPattern:='[\x0d\x0a]+(\S*)([rwxt-]{9})[^\x0d\x0a]*(\d+)\s+(\w{3})\s+(\d+)\s+(\d+|\d+:\d+)\s([^\x0d\x0a]+)';

 List3Pcre.MatchPattern:='[\x0d\x0a]+'+
 '(\S)([rwxts-]{8,9})\s+\d+\s+\w+\s+\w+\s+(\d+)\s+(\w{3})\s+(\d+)\s+(\d+|\d+:\d+)\s([^\x0d\x0a]+)';

 KeyPcre:=TDIPcre.Create(nil);
 KeyPcre.MatchPattern:='The server''s .*key fingerprint is:[\s\x0d\x0a]+([^\x0d\x0a]+)';
end;

destructor TSFTPTransfer.Destroy;
begin
 Inherited;
 FreeAndNil(GUI);
 CurDirPcre.Free;
 List1Pcre.Free;
 List2Pcre.Free;
 List3Pcre.Free;
 KeyPcre.Free;
end;

//EVENTS

procedure TSFTPTransfer.GUIRead(Sender: TObject; const Text: String);
begin
 if stringEndsWith('psftp> ',text)
  then addstatus(copy(text,1,length(text)-7))
  else addstatus(text);
end;


Function TSFTPTransfer.FixPath(Const Path : String) : String;
begin
 result:=path;
 replaceSC(result,'"','""',false);
 result:='"'+result+'"';
end;

Function TSFTPTransfer.WaitPrompt : Boolean;
begin
 result:=WaitForText('psftp> ');
end;

Function TSFTPTransfer.WaitForText(const Text : String) : Boolean;
begin
 FBusy:=true;
 result:=true;
 repeat
  GUI.Read;
  Application.ProcessMessages;
  if FAborted then break;
  if GUI.pipeStatus<>psNormal then
  begin
   AddStatus(GUI.LastError);
   result:=false;
   Break;
  end;
 until StringEndsWith(text,GUI.Output);
 FBusy:=false;
end;

procedure TSFTPTransfer.DoCommand(Const Comm : String);
begin
 If (FConnected) and (not FBusy) then
 begin
  GUI.ClearOutput;
  GUI.WriteLN(Comm);
  AddStatus('> '+comm);
  WaitPrompt;
 end;
end;

// PROCEDURES

procedure TSFTPTransfer.IntAbort;
begin
 FAborted:=true;
 GUI.Stop;
 FConnected:=false;
 FBusy:=false;
end;

procedure TSFTPTransfer.IntChangeDirectory(const Dir: String);
begin
 DoCommand('cd '+fixpath(dir));
 if assigned(GUI) then
  if pos('Remote directory is now',GUI.Output)=0 then
   LastError:='Could not change directory.';
end;

procedure TSFTPTransfer.IntDoDumbCommand;
begin
 DoCommand('pwd');
 if (not assigned(GUI)) or (pos('Remote directory is',GUI.Output)=0) then
  LastError:='Connection closed.';
end;

procedure TSFTPTransfer.IntChangeDirUp;
begin
 IntChangeDirectory('..');
end;

procedure TSFTPTransfer.IntCHMod(const FileName: String; Mode: Integer);
begin
 DoCommand('chmod '+inttostr(mode)+' '+fixpath(filename));
 if assigned(GUI) then
  if scanf(GUI.Output,'no such file',-1)>0 then
   LastError:='No such file or directory.';
end;

procedure TSFTPTransfer.SetCmdLine;
var
 p : integer;
begin
 p:=FPort;
 if p=21 then p:=22;
 GUI.appname:=ProgramPath+'psftp.exe';
 GUI.CmdLine:='-P '+inttostr(p)+' -l "'+FUsername+'" -pw "'+FPassword+'" '+FHost;
end;

procedure TSFTPTransfer.IntConnect;
var
 s:string;
begin
 If not (FConnected) then
 begin
  FBusy:=True;
  SetCmdLine;
  GUI.Start;
  if GUI.PipeStatus=psError then
  begin
   LastError:=
   'Secure FTP support is based on PuTTY SSH client.'#13#10+
   'Please copy the file psftp.exe to the folder you installed OptiPerl.'#13#10+
   #13#10+
   'If you don''t have PuTTY, you can download it free.'#13#10+
   'See OptiPerl''s support page at http://www.xarka.com/optiperl/support.html';
   exit;
  end;

  repeat
   SleepAndProcess(50);
   GUI.Read;

   if GUI.pipeStatus<>psNormal then
   begin
    DeleteStartsWith('login as: ',gui.Output);
    AddStatus(GUI.LastError);
    LastError:=gui.Output;
    Exit;
   end;

   if KeyPcre.MatchStr(GUI.Output)>0 then
   begin
    if pos('WARNING',GUI.Output)>0 then
     s:=
      'WARNING - POTENTIAL SECURITY BREACH!'#13#10+
      'The server''s host key does not match the one cached in the registry. Register new key?'
    else
     s:=
      'The server''s host key is not cached in the registry. Register new key?';

    if not (MessageDlg(s+#13#10#13#10#13+#10+KeyPcre.SubStr(1), mtConfirmation, [mbYes,mbNo], 0) = mrYes)
      then GUI.WriteLN('n')
      else GUI.WriteLN('y');
    GUI.ClearOutput;
   end;

  until StringEndsWith('psftp> ',GUI.Output);

  FConnected:=true;
  FBusy:=false;
 end;
end;

procedure TSFTPTransfer.IntCreateDirectory(const Dir: String);
begin
 DoCommand('mkdir '+fixpath(dir));
 if assigned(GUI) then
  if scanf(GUI.Output,'failure',-1)>0 then
   LastError:='Could not create directory.';
end;

procedure TSFTPTransfer.IntCustom(const Text: String);
begin
 DoCommand(text);
end;

procedure TSFTPTransfer.IntDeleteFile(const Filename: String);
begin
 DoCommand('del '+fixpath(filename));
 if assigned(GUI) then
  if scanf(GUI.Output,'no such file',-1)>0 then
   LastError:='No such file or directory.';
end;

procedure TSFTPTransfer.IntDisconnect;
begin
 If (FConnected) and (not FBusy) then
 begin
  GUI.ClearOutput;
  GUI.WriteLN('quit');
  GUI.read;
  GUI.Stop;
  FConnected:=false;
 end;
end;

procedure TSFTPTransfer.IntGet(const RemoteFile, LocalFile: String);
begin
 DoCommand('get '+fixpath(remotefile)+' '+fixpath(localfile));
 if assigned(GUI) then
 begin
  if scanf(GUI.Output,'unable to open',-1)>0 then
   LastError:='Unable to open file.';
  if scanf(GUI.Output,'no such file',-1)>0 then
   LastError:='No such file.';
 end;
end;

function TSFTPTransfer.IntGetCurrectDirectory: String;
begin
 DoCommand('pwd');
 if assigned(GUI) then
 begin
  if CurDirPcre.MatchStr(GUI.Output)>0 then
   result:=CurDirPcre.SubStr(1)
  else
   begin
    result:='';
    LastError:='Could not parse remote directory';
   end;
 end;
end;

procedure TSFTPTransfer.IntPut(const LocalFile, RemoteFile: String);
var
 temp : string;
begin
 if not fileexists(localfile) then
 begin
  LastError:='Unable to open file '+localfile;
  exit;
 end;

 temp:=localfile;
 DoCommand('put '+fixpath(temp)+' '+fixpath(remotefile));

 if assigned(GUI) then
 begin
  if scanf(GUI.Output,'unable to open',-1)>0 then
   LastError:='Unable to open file.';
  if scanf(GUI.Output,'no such file',-1)>0 then
   LastError:='No such file.';
 end;
end;

procedure TSFTPTransfer.IntRemoveDirectory(const Dir: String);
begin
 DoCommand('rmdir '+fixpath(dir));
 if assigned(GUI) then
  if scanf(GUI.Output,'failure',-1)>0 then
   LastError:='Could not remove directory.';
end;

procedure TSFTPTransfer.IntRename(const OldFile, NewFile: String);
begin
 DoCommand('ren '+fixpath(OldFile)+' '+fixpath(newfile));
 if assigned(GUI) then
  if scanf(GUI.Output,'failure',-1)>0 then
   LastError:='Could not rename file or directory.';
end;

procedure TSFTPTransfer.IntUpdateFileList;
var
 dy,dm,dd,th,tm,ts : Word;
 i,j : Integer;
 p : int64;
 s:string;
 timestamp : TTimeStamp;
const
 StrMonth   : String = 'JanFebMarAprMayJunJulAugSepOctNovDec';
begin
 DoCommand('dir');
 if not assigned(GUI) then exit;
 i:=scanf(GUI.Output,'Listing directory',-1);
 if i<=0
  then exit
  else delete(GUI.Output,1,i+10);

// GUI.output:=loadstr('c:\Transfer-r.log');
 i:=0;

 //Windows parsing
 if Length(FileList)=0 then
  with List1Pcre do
   begin
    SetSubjectStr(GUI.Output);
    if Match(0) >= 1 then
    repeat
     if (SubStr(8)='.') then continue;
     setlength(FileList,i+1);
     dm:=StrToIntDef(SubStr(1),0);
     dd:=StrToIntDef(SubStr(2),0);
     dy:=StrToIntDef(SubStr(3),0);
     th:=StrToIntDef(SubStr(4),0);
     tm:=StrToIntDef(SubStr(5),0);
     ts:=0;
     s:=Uppercase(SubStr(6));
     if s='PM' then inc(th,12);

     s:=SubStr(7);
     ReplaceSC(s,'.','',false);
     ReplaceSC(s,',','',false);
     if pos('DIR',s)<>0
      then FileList[i].ItemType:=itDirectory
      else FileList[i].ItemType:=itFile;
     filelist[i].Size:=StrToIntDef(s,0);
     FileList[i].Filename:=SubStr(8);
     FileList[i].Modified:=EncodeDate(dy,dm,dd)+EncodeTime(th,tm,ts,0);
     FileList[i].Attributes:='';
     inc(i);
    until Match(MatchedStrAfterLastCharPos) <= 2;
   end;


 //unix parsing
 if Length(FileList)=0 then
  with List2Pcre do
   begin
    SetSubjectStr(GUI.Output);
    if Match(0) >= 1 then
    repeat
     if (SubStr(5)='.') then continue;
     setlength(FileList,i+1);
     s:=uppercase(SubStr(1));
     if s='0100' then FileList[i].ItemType:=itFile
     else
     if s='0120' then FileList[i].ItemType:=itSymbolicLink
     else
     if s='040' then FileList[i].ItemType:=itDirectory
     else
     //unknown
     FileList[i].ItemType:=itSymbolicLink;

     FileList[i].Attributes:=PermissionsToStr(StrToIntDef(SubStr(2),0));
     FileList[i].Size:=StrToIntDef(SubStr(3),0);

     p:=StrToIntDef(SubStr(4),0);
     timestamp.Time := (p mod 86400) * 1000;
     timestamp.Date := (p div 86400) + 719163;
     FileList[i].Modified:=TimeStampToDateTime(timestamp);

     s:=SubStr(5);
     FileList[i].Filename:=s;
     inc(i);
    until Match(MatchedStrAfterLastCharPos) <= 2;
   end;


 //unix parsing with dir
 if Length(FileList)=0 then
  with List3Pcre do
   begin
    SetSubjectStr(GUI.Output);
    if Match(0) >= 1 then
    repeat
     if (SubStr(7)='.') or (SubStr(7)='./') then continue;

     setlength(FileList,i+1);

     s:=uppercase(SubStr(1));
     if s='-' then FileList[i].ItemType:=itFile
     else
     if s='L' then FileList[i].ItemType:=itSymbolicLink
     else
     if s='D' then FileList[i].ItemType:=itDirectory
     else
     //unknown
     FileList[i].ItemType:=itSymbolicLink;

     FileList[i].Attributes:=SubStr(2);
     FileList[i].Size:=StrToIntDef(SubStr(3),0);

     DecodeDate(date,dy,dm,dd);
     dm:=(ScanF(StrMonth,SubStr(4),-1)+2) div 3;
     dd:=StrToIntDef(SubStr(5),0);
     ts:=0;  th:=12;  tm:=0;
     j:=pos(':',SubStr(6));
     if j>0 then
      begin
       th:=StrToIntDef(copy(SubStr(6),1,2),12);
       tm:=StrToIntDef(copy(SubStr(6),j+1,2),0);
      end
     else
      dy:=StrToIntDef(SubStr(6),1900);

     try
      FileList[i].Modified:=EncodeDate(dy,dm,dd)+EncodeTime(th,tm,ts,0);
     except
      FileList[i].Modified:=0;
     end;

     s:=SubStr(7);
     //xarka see joel_n_mokoetle@bankone.com.log
      if (length(s)>1) and (s[length(s)] in ['*','/']) then
       setlength(s,length(s)-1);
     //
     FileList[i].Filename:=s;
     CheckSymLink(FileList[i]);
     inc(i);
    until Match(MatchedStrAfterLastCharPos) <= 2;
   end;


 if (length(filelist)=0) and (pos('failure',GUI.Output)<>0) then
  LastError:='Could not get directory listing';
end;

Procedure TSFTPTransfer.CheckSymLink(var Item: TItemData);
var i:integer;
begin
 if Item.ItemType=itSymbolicLink then
 begin
  i:=pos(' -> ',item.Filename);
  if i>0 then
   begin
    Item.LinksTo:=copyFromToEnd(item.Filename,i+4);
    SetLength(Item.Filename,i-1);
   end;
 end;
end;

//properties

function TSFTPTransfer.GetBusy: Boolean;
begin
 result:=FBusy;
end;

function TSFTPTransfer.GetConnected: Boolean;
begin
 result:=FConnected;
end;

function TSFTPTransfer.GetHost: String;
begin
 result:=FHost;
end;

function TSFTPTransfer.GetLoginMessage: String;
begin
 result:='';
end;

function TSFTPTransfer.GetPassword: String;
begin
 result:=FPassword;
end;

function TSFTPTransfer.GetPort: Integer;
begin
 result:=FPort;
end;

function TSFTPTransfer.GetTextTranfer: boolean;
begin
 result:=FTextTransfer;
end;

function TSFTPTransfer.GetUsername: String;
begin
 result:=FUsername;
end;

procedure TSFTPTransfer.SetHost(const Text: String);
begin
 FHost:=text;
end;

procedure TSFTPTransfer.SetPassword(const Text: String);
begin
 FPassword:=text;
end;

procedure TSFTPTransfer.SetPort(Port: integer);
begin
 FPort:=port;
end;

procedure TSFTPTransfer.SetTextTransfer(Text: boolean);
begin
 FTextTransfer:=Text;
end;

procedure TSFTPTransfer.SetUsername(const Text: String);
begin
 FUsername:=Text;
end;

procedure TSFTPTransfer.UpdateConnectedFromLastError(CloseOnAnyError : Boolean);
begin
 if ( (not CloseOnAnyError) and (LastError='Connection closed.') ) or
    ( (CloseOnAnyError)     and (Trim(LastError)<>'') ) then
 begin
  GUI.ClearOutput;
  GUI.WriteLN('quit');
  GUI.read;
  GUI.Stop;
  FConnected:=false;
 end;
end;


end.


