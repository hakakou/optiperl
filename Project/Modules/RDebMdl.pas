unit RDebMdl; //Module
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,HakaRandom,
  Dialogs, CustDebMdl, DIPcre, ExtCtrls, optgeneral, OptProcs, OptMessage,hakawin,
  OptOptions,jclfileutils,hakageneral,hakafile, optfolders,hkdebug,HKNetwork,
  hyperstr, ScktComp, RemoteDebFrm, ScriptInfoUnit, HakaMessageBox;

type
  TGetFile = (gfNo,gfLines,gfRaw,gfDumb);

  TRDebMod = class(TCustDebMod)
    Server: TServerSocket;
    Pcre: TDIPcre;
    LinePcre: TDIPcre;
    Pcre2: TDIPcre;
    GLpcre: TDIPcre;
    Pcre3: TDIPcre;
    EvalTimer: TTimer;
    LineEndPcre: TDIPcre;
    PodPcre: TDIPcre;
    Output: TServerSocket;
    procedure ServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure DataModuleCreate(Sender: TObject);
    procedure ServerAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ServerClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ServerClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure EvalTimerTimer(Sender: TObject);
    procedure OutputClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure OutputClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure OutputClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure OutputClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    NoOuts,NextCheckCache : TStringList;
    ActivePod : Byte;
    FirstLineCheck,DoneOutputCommand : Boolean;
    remoteaddr : string;
    RemoteForm : TRemoteDebForm;
    GettingFile : TGetFile;
    GoLine,HasLines,Checking,SendingCommand : BOolean;
    PromptNum,prevline : Integer;
    FileBuffer : TStringList;
    LinesVar : string;
    Started : Boolean;
    procedure OnLine(const Line: String);
    function MakeRemFilename(F: String): String;
    procedure CheckForNewFile;
    procedure addFileBuffer(const str: string; line: integer);
    procedure LoadFile(RN: String);
    Function CheckForChangedFile : boolean;
    procedure SendData(const s: string);
    procedure DoPrompt;
  protected
    function _MakeRemoteFilename(f: String): String;
    Procedure WaitTillPrompt; override;
    Procedure Terminating; Override;
    Procedure CheckAndAddBreakpoints(const querriedfile : string = ''); override;
  public
    procedure StartOutputCommand;
    procedure StopOutputCommand;
    procedure ForceReloadFile;
    procedure SendPush;
    function EvaluateVar(Vars: string): string; override;
    Procedure SendConIn(const ConIn : string); override;
    procedure SendCommand(const s: string; Run: BOolean); override;
    function Start: Boolean; override;
    procedure Stop; override;
  end;

var
  RDebMod: TRDebMod;

implementation

{$R *.dfm}

{ TRDebMod }

procedure TRDebMod.OnLine(const Line : String);
var
 q0,bo,i : Integer;
 S,P:String;
begin
 if gettingfile in [gfNo,gfDumb] then
  begin
   if pos('Loading DB routines from perl5db',line)=1 then
    Loaded:=true;

   RemoteForm.StatusBox.Items.Add(copy(line,1,255));
   WriteDebLine('OUT:['+line+']');
   if not terminated then
    terminated:=pos('Debugged program terminated. ',line)>0;

   //Find if it stoped on a load breakpoint
   bo:=1;
   q0:=ScanW(line,'''*?'' loaded...',bo);
   if q0<>0 then
   begin
   //it is!
    breakload:=CopyFromTo(line,bo+1,q0+bo-12);
    exit;
   end;

   with glpcre do
   if MatchStr(line)=4 then
   begin
    HasLines:=true;
    NextCheckCache.AddObject(SubStr(3),TObject(strtoint(SubStr(1))));
   end;

   if checking then
   begin
    gettingfile:=gfNo;
    exit;
   end;

   if (GoLine) and (not isevaluating) then
   begin
    if (pcre.MatchStr(line)=3) then
    begin
     perlline.filename:=pcre.SubStr(1);
     perlline.line:=StrToInt(pcre.SubStr(2));
     goline:=false;
    end;

    if (pcre2.MatchStr(line)=3) then
    begin
     perlline.filename:=pcre2.SubStr(1);
     perlline.line:=StrToInt(pcre2.SubStr(2));
     goline:=false;
    end;

    if (pcre3.MatchStr(line)=4) then
    begin
     perlline.filename:=pcre3.SubStr(1);
     perlline.line:=StrToInt(pcre3.SubStr(3));
     goline:=false;
    end
   end;

   if not terminated
    then Terminated:=pos('Debugged program terminated.',line)<>0;

   if hasdebugprompt(line) then
    DoPrompt;
  end

 else
  begin
   if (gettingfile=gfLines) and (linepcre.MatchStr(line)=4) then
   begin
    s:=linepcre.SubStr(3);
    i:=strtoint(linepcre.SubStr(1));

    case ActivePod of
     0 :
      begin
       addfilebuffer(s,i);
       if PodPcre.MatchStr(s)>0 then
        ActivePod:=1;
      end;

     1 : Inc(ActivePod);

     2 :
      begin
       addfilebuffer('=cut',i-1);
       addfilebuffer(s,i);
       if PodPcre.MatchStr(s)>0
        then ActivePod:=1
        else ActivePod:=0;
      end;
    end; //case

   end;

   if hasdebugprompt(line) then
    GettingFile:=gfNo;

   if (gettingfile=gfRaw) then
    filebuffer.add(line);
  end;
 buffer.Add(line);
end;

Function TRDebMod.MakeRemFilename(F : String) : String;
var
 d:string;
begin
 replaceC(f,'/','\');
 d:=folders.RemoteFolder+RemoteAddr+'\';
 if not directoryexists(d) then mkdir(d);
 result:=d+extractfilename(f);
end;

Function TRDebMod._MakeRemoteFilename(f : String) : String;
var
 d:string;
begin
 replaceC(f,'/','\');
 d:=folders.RemoteFolder+RemoteAddr+'\';
 result:=d+extractfilename(f);
end;

Procedure TRDebMod.LoadFile(RN : String);
begin
 filebuffer.clear;
 ActivePod:=0;
 changeStatus(stProcessing);
 GettingFile:=gfLines;
 if server.Socket.ActiveConnections>=1 then
 begin
  SendData('l 1-999999');
  repeat
   application.ProcessMessages;
   if filebuffer.Count mod 10 = 0 then
    try
     RemoteForm.lblStat.Caption:='Getting line '+inttostr(filebuffer.Count)+' of file '+perlline.filename;
    except end;
   sleep(5);
  until gettingfile=gfNo;

  if filebuffer.Count=0 then //linux?
  begin
   GettingFile:=gfRaw;
   senddata('print $DB::OUT @'+linesvar+';');
   repeat
    application.ProcessMessages;
    if filebuffer.Count mod 10 = 0 then
    try
     RemoteForm.lblStat.Caption:='Getting line '+inttostr(filebuffer.Count)+' of file '+perlline.filename;
    except end;
    sleep(5);
   until gettingfile=gfNo;
  end;

 end;
 FileBuffer.SaveToFile(rn);
 filebuffer.Clear;
 changeStatus(stStopped);
end;

Procedure TRDebMod.ForceReloadFile;
var
 RN : String;
begin
 if (Status in [stStopped]) and (server.Socket.ActiveConnections>=1) then
 begin
  RN:=MakeRemFilename(perlline.filename);
  loadfile(rn);
  if IsSameFile(ActiveScriptInfo.path,rn) then
  begin
   ActiveScriptInfo.ms.Lines.LoadFromFile(rn);
   ActiveScriptInfo.IsModified:=false;
   ActiveScriptInfo.TimeStamp:=FileAge(rn);
  end;
 end;
end;

Function TRDebMod.CheckForChangedFile : boolean;

  Function GetRawLine(const Line : String) : String;
  var b:integer;
  begin
   result:=trim(line);
   b:=scanB(result,'#',0);
   if b<>0 then
    setlength(result,b-1);
   result:=trim(result);
  end;

var
 RN : String;
 SL : TStrings;
 i,l:integer;
 c1,c2 : string;
begin
  FirstLineCheck:=false;
  RN:=MakeRemFilename(perlline.filename);
  result:=false;
  sl:=ActiveScriptInfo.ms.Lines;
  if not assigned(sl) then exit;
  i:=-1;
  repeat
   inc(i);
   if i>=nextcheckcache.Count then break;
   l:=integer(nextcheckCache.Objects[i])-1;
   if l>=sl.Count then
   begin
    i:=0;
    break;
   end;
//   c1:=GetRawLine(sl[l]);
   c1:=GetRawLine(ActiveScriptInfo.ms.StringItem[l].StrData);
   c2:=GetRawLine(NextCheckCache[i]);
  until c1 <> c2;

  l:=NextCheckCache.count;
  if (i<l) and
     (MessageDlgMemo('The file being debugged seems different than'+#13+#10+'the cached copy. Reload?', mtWarning, [mbYes,mbCancel], 0,4000) = mrYes)
   then
    begin
     try
      ForceReloadFile;
      result:=true;
     except
      assert(false,'LOG Exception');
     end;
    end;

end;

Procedure TRDebMod.CheckForNewFile;
var
 RN : String;
begin
 RN:=MakeRemFilename(perlline.filename);
 if not fileexists(rn)
  then LoadFile(rn)
end;

procedure TRDebMod.ServerClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 LineList : TStringList;
 line : string;
 c:integer;
begin
 if not FirstLineCheck then
  NextCheckCache.clear;
 LineList:=TStringList.Create;
 RemoteForm.StatusBox.Items.BeginUpdate;
 line:='';
 try
  while socket.ReceiveLength>0 do
   line:=line+socket.ReceiveText;
  LineList.Text:=line;
 except on exception do linelist.Text:='';
 end;

 for c:=0 to linelist.Count-1 do
 begin
  line:=linelist[c];
  OnLine(line);
 end;

 with remoteform.StatusBox do
 begin
  while items.Count>1000 do
   Items.Delete(0);
  itemindex:=items.Count-1;
  Items.EndUpdate;
 end;
 LineList.free;

 if (not DoneOutputCommand) and (options.InOutRedirect) then
  StartOutputCommand;
end;

procedure TRDebMod.DataModuleCreate(Sender: TObject);
begin
 inherited;

 PC_RDeb_Terminating:=Terminating;
 PC_RDeb_PerlInput:=SendConIn;
 PC_RDeb_BreakpointsChanged:=BreakpointsChanged;
 PC_RDeb_PerlExpressionResult:=PerlExpressionResult;
 PC_RDeb_DebuggerRunning:=_DebuggerRunning;
 PR_MakeRemoteFilename:=_MakeRemoteFilename;

 if folders.DebOutput<>'' then
 begin
  assignfile(outlog,folders.RDebOutput);
  rewrite(outlog);
 end;
 NoOuts:=TStringList.Create;
 NoOuts.Sorted:=true;
 GoLine:=true;
 FileBuffer:=TStringList.create;
 NextCheckCache:=TStringList.create;
end;

procedure TRDebMod.addFileBuffer(const str : string; line : integer);
begin
 with filebuffer do
 begin
  while count<=line
   do Add('');
  if line>0 then
   Strings[line-1]:=str;
 end;
end;

function TRDebMod.Start: Boolean;
begin
 result:=false;
 SendingCommand:=false;
 StartPath:='';
 try
  Server.Port:=OPtions.remDebPort;
  Server.active:=true;
 except
  MessageDlg('Could not start server for remote debugger.'+#13#10+
   'Make sure that no other servers are running on port '+inttostr(options.remDebPort)+'.', mtError, [mbOK], 0);
  exit;
 end;
 RemoteForm:=TRemoteDebForm.create(Application);
 RemoteForm.show;
 result:=true;
 debActions:=[debStop,debRestart];
end;

procedure TRDebMod.Stop;
begin
 screen.cursor:=crAppStart;
 try
  StopPressed:=true;
  sendcommand('q',false);
  ChangeStatus(stNotRunning);
  Server.Active:=false;
  PR_RemoveRemoteFiles;
  FreeAndNil(RemoteForm);
 finally
  screen.cursor:=crDefault;
 end;
end;

Procedure TRDebMod.StopOutputCommand;
begin
 sendcommand(
  'x if ($OUTxOpti) { '+
  'open(STDOUT,">&O_STDOT_B"); open(STDIN,"<&O_STDIN_B"); '+
  'close(O_STDOT_B); close(O_STDIN_B); }',false);
end;

Procedure TRDebMod.StartOutputCommand;
var
 s:String;
begin
 try
  DoneOutputCommand:=true;

  if Output.Port<>Options.InOutPort then
  begin
   Output.Active:=false;
   Output.Port:=Options.InOutPort;
  end;

  if not Output.Active then
   Output.Active:=true;

  if (server.Socket.ActiveConnections>0)
   then s:=server.socket.Connections[0].LocalAddress
   else s:=MyIpAddress;

  s:=s+':'+inttostr(output.Port);

  sendcommand(
   'x require IO::Socket; '+
   '$OUTxOpti=new IO::Socket::INET(Timeout=>"10",PeerAddr=>"127.0.0.1:9020", Proto=>"tcp"); '+
   'if ($OUTxOpti) { $OUTxOpti->autoflush(1); $|=1; my $fd=$OUTxOpti->fileno; '+
   'open(O_STDOT_B,">&STDOUT"); open(O_STDIN_B,"<&STDIN"); '+
   'open(STDOUT,">&$fd"); open(STDIN,"<&$fd"); } ',false);
 except
  if assigned(RemoteForm) then
   RemoteForm.StatusBox.Items.Add('Error while trying to redirect output!');
 end;
end;

Procedure TRDebMod.SendPush;
begin
 sendcommand('x print "\n<!--", " " x 8192, "-->\n"',false);
end;

procedure TRDebMod.SendConIn(const ConIn: string);
begin
 case status of
  stStopped :
   if (ConIn<>'') and (server.Socket.ActiveConnections>0) then
    server.socket.Connections[0].SendText(ConIn+#10);
  stRunning:
   if (ConIn<>'') and (output.Socket.ActiveConnections>0) then
    output.socket.Connections[0].SendText(ConIn+#10);
 end;
 writedebline('CONIN:['+conin+']');
end;

procedure TRDebMod.SendData(const s: string);
begin
 WriteDebLine('DATA:['+s+']');
 if server.Socket.ActiveConnections<=0 then exit;
 server.socket.Connections[0].SendText(s+#10);
end;

procedure TRDebMod.EvalTimerTimer(Sender: TObject);
begin
 EvalTimer.Enabled:=false;
 try
  EvaluateWatches;
  EvaluateCallStack;
 except end;
end;

procedure TRDebMod.SendCommand(const s: string; Run: BOolean);
begin
 if SendingCommand then exit;
 SendingCommand:=true;

 if run
  then writedebline('RUN:['+s+']')
  else writedebline('COM:['+s+']');

 if (server.Socket.ActiveConnections<=0) or
    (not loaded) then
  begin
   SendingCommand:=false;
   exit;
  end;

 if not run then
  screen.cursor:=crAppStart;

 try
  buffer.clear;
  if (run) and (Terminated) then
  begin
   SendingCommand:=false;
   exit;
  end;
  if run
   then ChangeStatus(stRunning)
   else ChangeStatus(stProcessing);

  server.socket.Connections[0].SendText(s+#10);

  try
   WaitTillPrompt;
  except
   Showmessage('Error 102. Please report to author.');
  end;

  if run then
  begin
   EvalTimer.Enabled:=false;
   EvalTimer.Enabled:=true;
  end;
 finally
  if not run then screen.cursor:=crDefault;
  SendingCommand:=false;
 end;
end;

procedure TRDebMod.ServerAccept(Sender: TObject; Socket: TCustomWinSocket);
begin
 FirstLineCheck:=true;
 DoneOutputCommand:=false;
 NextCheckCache.clear;
 NoOuts.clear;
 gettingfile:=gfDumb;
 linesVar:=RandomString(10);
 PromptNum:=0;
 FileBuffer.Clear;
 Buffer.clear;
 loaded:=false;
 Terminated:=false;
 isevaluating:=false;
 ChangeStatus(stProcessing);

 remoteaddr:=socket.RemoteAddress;
 RemoteForm.StatusBox.Items.Add('Connected to '+remoteaddr);
 loaded:=true;
 Checking:=false;
 prevline:=-1;
end;

procedure TRDebMod.DataModuleDestroy(Sender: TObject);
begin
 NoOuts.Free;
 FileBuffer.free;
 NextCheckCache.free;
 inherited;
end;

procedure TRDebMod.WaitTillPrompt;
begin
 inherited;
end;

procedure TRDebMod.DoPrompt;
var s:string;
begin
  inc(promptNum);
  GoLine:=true;
  CheckForNewFile;

  if promptNum=1 then
  begin
   checking:=true;
   HasLines:=false;
   gettingfile:=gfDumb;
   SendData('.');
   repeat
    application.ProcessMessages;
   until gettingfile=gfNo;

   if not haslines then
   begin
    senddata('open 0 and @'+linesvar+'=<0>;');
    NoOuts.Add(perlline.filename);
   end;
   checking:=false;
  end;

  ChangeStatus(StStopped);

  if promptNum=1 then
   CheckAndAddBreakPoints;

  if breakload<>'' then
  begin
   s:=breakload;
   BreakLoad:='';
   CheckAndAddBreakpoints(breakload);
   SleepAndProcess(50);
   if (not isbreakpoint) and (server.Socket.ActiveConnections>0) then
    senddata('c');
   WriteDebLine('[CONT]');
  end;

  if (not terminated) and (not IsEvaluating) then
  begin
   with perlline do
    PR_UpdateLine(MakeRemFilename(filename),line,false);

   if checkForChangedFile then
    with perlline do
     PR_UpdateLine(MakeRemFilename(filename),line,false);

   PR_ModifyForRemote;
  end;

  if (NoOuts.IndexOf(perlline.filename)>=0) and (prevline<>perlline.line) then
  begin
   prevline:=perlline.line;
   senddata('print $DB::OUT "$DB::line:\t $'+linesvar+'[$DB::line-1]"');
  end;

  if (terminated) and (server.Socket.ActiveConnections>0) then
   senddata('q');
end;

procedure TRDebMod.ServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 ErrorCode:=0;
end;

procedure TRDebMod.CheckAndAddBreakpoints(const querriedfile: string);
var
 p,i:integer;
 f,fname:string;
 bi : PBreakInfo;
begin
 if (Status in [stStopped]) or (querriedfile<>'') then
 begin
  isevaluating:=true;
  if QuerriedFile='' then
  begin
   sendcommand('B *',false); //new version of perl5db
   if pos('Deleting all',buffer.text)=0 then
    sendcommand('D',false);
  end;
  f:='';
  for i:=0 to breakpoints.Count-1 do
  begin
   bi:=PBreakInfo(breakpoints.Objects[i]);
   if (querriedfile<>'') and (bi.Done) then continue;
   if (querriedfile<>'') and (querriedfile<>extractfilename(breakpoints[i]))
    then continue;
   if (f<>breakpoints[i]) then
    begin
     fname:=extractfilename(Breakpoints[i]);
     buffer.Clear;
     if querriedfile='' then
     begin
       sendcommand('f '+fname,false);
       p:=pos('No file matching `'+fname+''' is loaded.',buffer.text);
       if (p=1) then
       begin
        bi.BreakStatus:=bsGeneral;
        sendcommand('b load '+fname,false);
        bi.Done:=false;
       end;
       f:=breakpoints[i];
     end;
    end
   else
    p:=0;

   if p=0 then
   begin
    buffer.clear;
    if Querriedfile<>'' then
     begin
      SleepAndProcess(50);
      if server.Socket.ActiveConnections>0 then
       senddata('b '+inttostr(bi.line+1)+' '+bi.Condition);
     end
      else sendcommand('b '+IntToStr(bi.line+1)+' '+bi.Condition,false);
    p:=Pos('Line '+inttostr(bi.line+1)+' not breakable.',buffer.text);
    if p<>0
     then bi.BreakStatus:=bsInvalid
     else bi.BreakStatus:=bsOK;
    bi.Done:=true;
   end;
  end; //for loop
  IsEvaluating:=false;
 end

  else

 if Status=StNotRunning then
 begin
  for i:=0 to breakpoints.Count-1 do
  begin
   bi:=PBreakInfo(breakpoints.Objects[i]);
   bi.BreakStatus:=bsGeneral;
   bi.Done:=false;
  end;
 end;

 PR_UpdateBreakpoints(false);
end;

function TRDebMod.EvaluateVar(Vars: string): string;
begin
 result:=trim(inherited EvaluateVar(vars));
end;

procedure TRDebMod.ServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 RemoteForm.lblStat.Caption:='Connected to '+socket.RemoteAddress;
end;

procedure TRDebMod.ServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 RemoteForm.lblstat.Caption:='Disconnected';
 loaded:=false;
end;

procedure TRDebMod.Terminating;
begin
 if (status<>stNotRunning) then
 begin
  Stop;
  Server.Active:=false;
  PR_RemoveRemoteFiles;
  RemoteForm.free;
 end;
end;

procedure TRDebMod.OutputClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var
 S:String;
begin
 if ErrorCode=10053
  then s:='Input/Output stream closed.'
  else s:='Error '+inttostr(ErrorCode)+'.';
 ErrorCode:=0;
 if assigned(RemoteForm) then
  RemoteForm.StatusBox.Items.Add(s);
end;

procedure TRDebMod.OutputClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 PR_NewSession;
 if assigned(RemoteForm) then
  RemoteForm.StatusBox.Items.Add('Input/Output stream connected to '+socket.RemoteAddress);
end;

procedure TRDebMod.OutputClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
 if assigned(RemoteForm) then
  RemoteForm.StatusBox.Items.Add('Input/Output stream Disconected.');
end;

procedure TRDebMod.OutputClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
 line : string;
begin
 line:='';
 while socket.ReceiveLength>0 do
  line:=line+socket.ReceiveText;
 PR_PerlOutput(line);
end;

end.
