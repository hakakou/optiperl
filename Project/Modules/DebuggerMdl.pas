unit DebuggerMdl;  //Module

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CustDebMdl, DIPcre, ExtCtrls, optgeneral,OptProcs, OptQuery, OptMessage,
  ConsoleIO,OptOptions,jclfileutils,hakageneral,hakafile,optfolders,hakamessagebox,
  hyperstr,RunPerl,ScriptInfoUnit;

type
  TLDebMod = class(TCustDebMod)
    GUI: TGUI2Console;
    procedure GUILine(Sender: TObject; const Line: String);
    procedure GUIPrompt(Sender: TObject; const Line: String);
    procedure GUIPreTerminate(Sender: TObject);
    procedure GUIStart(Sender: TObject; const Command: String);
    procedure GUIDone(Sender: TObject);
    procedure GUITimeOut(Sender: TObject; var Kill: Boolean);
    procedure DataModuleCreate(Sender: TObject);
    procedure GUIError(Sender: TObject; const Error: String);
  private
    PostData : String;
    ErrorLoading:String;
  protected
    Procedure CheckAndAddBreakpoints(const querriedfile : string = ''); override;
    procedure SendCommand(const s: string; Run: BOolean); override;
  public
    Procedure SendConIn(const ConIn : string); override;
    function Start: Boolean; override;
    procedure Stop; override;
  end;

var
  LDebMod: TLDebMod;

implementation
{$R *.dfm}

procedure TLDebMod.Stop;
begin
 StopPressed:=true;
 screen.cursor:=crAppStart;
 try
  gui.Stop;
  StartTimer;
  repeat
   application.ProcessMessages;
  until (status=stNotRunning) or (TimeOut);
  ChangeStatus(stNotRunning);
  Loaded:=False;
 finally
  screen.cursor:=crDefault;
 end;
end;


Function TLDebMod.Start : Boolean;
var
 p : integer;
 fname,buf,params,folder : string;
 PrTimer:Cardinal;
 sl : TStringList;
begin
 Screen.Cursor:=crAppStart;
 try
  result:=false;
  StopPressed:=false;
  Terminated:=false;
  isevaluating:=False;
  Buffer.clear;
  ErrorLoading:='';
  StartPath:=ActiveScriptInfo.path;

  if options.StartPath<>''
   then folder:=options.StartPath
   else folder:=ExtractFilePath(script);
  chdir(folder);

  params:=ActiveScriptInfo.Query.ActiveQuery[qmCMDLine];
  if trim(params)='' then
   params:='';

  GUI.Command:='"'+Options.PathToPerl+'" -I"'+folders.includepath+'"'+
     DeSafeStr(#137#23#37#126#229#21#141#163#126#42#129#112#235)+  //' -d:perl5db "'
     script+
     DeSafeStr(#201#155#219#126#190#5#202#114#95#204)+      //'" -emacs '
     params;

  GUI.Environment:='PERL5LIB='+GetLibPath(fname)+#0+
    ActiveScriptInfo.Query.GetZeroDelEnv(ActiveScriptInfo.path,PostData);

  WriteDebLine('[START]');

  GUI.Prompt:='(> |\[1m)$';

  if Status=StNotRunning then
   GUI.start;

  loaded:=true;

  prtimer:=GetTickCount+12000;
  repeat
   application.ProcessMessages;
   buf:=buffer.text;

   if ((pos('aborted due to compilation errors.',Buf)<>0) or
       (pos('syntax error at ',buf)<>0) or
       (pos('compilation aborted at ',buf)<>0) or
       (pos('Can''t find string terminator ',buf)<>0)) and
      (scanF(buf,#13#10'Content-type',-1)=0)
   then
   begin
    screen.cursor:=crDefault;
    PR_DoErrorChecking;
    result:=false;
    exit;
   end;

   if Length(ErrorLoading)>0 then
   begin
    screen.cursor:=crDefault;
    MessageDlg(ErrorLoading, mtError, [mbOK], 0);
    exit;
   end;

  until (status=stStopped) or (GetTickCount>prTimer) or (stoppressed);

  if (GetTickCount>prTimer)
   then begin
    WriteDebLine('[C1:PROB]');
    if folders.DebOutput='' then
     MessageDlgMemo('A timeout occured while starting the debugger.'+#13+#10+''+#13+#10+'Please make sure that executing "perl -d scriptname.pl"'+#13+#10+'from the console does start the debugger normally.', mtError, [mbOK], 0,2200);
   end
   else WriteDebLine('[C1:OK]');

  if loaded then
   begin
    sendcommand('.',false);
    WriteDebLine('[C2:OK]');
    result:=true;
    PR_NewSession;

    sl:=TStringList.create;
    sl.text:=buf;
    for p:=0 to 3 do
     if sl.Count>0 then sl.Delete(0);
    for p:=0 to sl.count-1 do
      PR_PerlOutput(sl[p]);
    sl.free;

    CheckAndAddBreakPoints('');
    WriteDebLine('[C3:OK]');
   end
  else
   result:=false;

 finally
  screen.cursor:=crDefault;
 end;
end;


Procedure TLDebMod.CheckAndAddBreakpoints(const querriedfile : string = '');
var
 p,i:integer;
 f,fname:string;
 bi : PBreakInfo;
begin
 if (Status in [stStopped]) or (querriedfile<>'') then
 begin
  if QuerriedFile='' then
  begin
   sendcommand('B *',false); //new version of perl5db
   if pos('Deleting all',buffer.text)=0 then
    sendcommand('D',false);
  end;
  f:='';
  isevaluating:=true;
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
   end else p:=0;

   if p=0 then
   begin
    buffer.clear;
    if Querriedfile<>'' then
     begin
      SleepAndProcess(50);
      GUI.WriteLN('b '+inttostr(bi.line+1)+' '+bi.Condition);
     end
    else
     sendcommand('b '+IntToStr(bi.line+1)+' '+bi.Condition,false);
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

procedure TLDebMod.SendCommand(const s: string; Run: BOolean);
begin
 if not run then
  screen.cursor:=crAppStart;
 try
  buffer.clear;
  if (run) and (Terminated) then exit;
  if run
   then ChangeStatus(stRunning)
   else ChangeStatus(stProcessing);
  GUI.WriteLN(s);
  if not run then writedebline('COM:['+s+']');
  WaitTillPrompt;
  if run then
  begin
   EvaluateWatches;
   EvaluateCallStack;
  end; 
 finally
  if not run then
   screen.cursor:=crDefault;
 end;
end;


Procedure TLDebMod.SendConIn(const ConIn: string);
begin
 GUI.Writeln(ConIn);
end;

procedure TLDebMod.GUITimeOut(Sender: TObject; var Kill: Boolean);
begin
 if (status=stRunning) and (not flashing) then
 begin
  if PostData<>'' then
   begin
    GUI.Write(PostData);
    PostData:='';
   end
  else
   begin
    PR_WaitingForInput(true);
    flashing:=true;
   end;
 end;
end;

procedure TLDebMod.GUIPrompt(Sender: TObject; const Line: String);
var
 f,l:integer;
 ALine : String;
begin
 f:=1;
 WriteDebLine('PR:['+line+']');
 ALine:=Line;
 ReplaceSC(ALine,#27+'[4;m','',false);
 ReplaceSC(ALine,#27+'[1m'+#27+'[0m','',false);
 l:=ScanW(Aline,'  DB<*#*> ',f);
 if (f>=1)  ///was =1
  then
   begin
{    if f>1 then
     RequestAction(HK_PerlOutput,Aline);}
    ChangeStatus(stStopped);
   end
  else
   if (status=stRunning) then begin
    delete(Aline,f,l);
    PR_PerlOutput(ALine);
   end;
end;

procedure TLDebMod.GUILine(Sender: TObject; const Line: String);
var
 f,l:integer;
 q0,bo,bc : Integer;
 sv,pline,lline:string;
begin
 WriteDebLine('OUT:['+line+']');
 f:=1;
 if not terminated then
  terminated:=pos('Debugged program terminated. ',line)>0;
//terminated:=pos('Use `q'' to quit or `R'' to restart.  `h q'' for details.',line)>0;

 //Find if it stoped on a load breakpoint
 bo:=1;
 q0:=ScanW(line,'''*?'' loaded...',bo);
 if q0<>0 then
 begin
 //it is!
  breakload:=CopyFromTo(line,bo+1,q0+bo-12);
  exit;
 end;

 q0:=scanF(line,#26#26,f);
 if q0=0
  then pline:=line
  else pline:=Copy(line,1,q0-1);

 if (q0>0) then begin
  fillchar(perlline,sizeof(perlline),0);
  bo:=Pos('[',line);
  bc:=Pos(']',line);
  if (bo>0) and (bc>0) and (bc>bo) and (q0<bo)
   then lline:=CopyFromTo(line,bo+1,bc-1)+':0'
   //do this      '  DB<3> '#$1A#$1A'(eval 7)[C:\Perl\lib/CGI.pm:780]:5:0'
   //but not this '  DB<2> [j]'#$1A#$1A'C:\Unzip\agk.pl:2:0'

   else lline:=copyFromToEnd(line,q0+2);
   //'  DB<3> '#$1A#$1A'C:\Perl\lib/CGI.pm:624:0'

  bc:=scanb(lline,':',Length(lline));
  if bc<>0 then Delete(lline,bc,Length(lline));

  bc:=scanb(lline,':',Length(lline));
  PerlLine.FileName:=copyFromTo(lline,1,bc-1);
  val(copyFromToEnd(lline,bc+1),perlline.line,l);

  if not terminated then
   Terminated:=(scanf(perlline.FileName,'perl5db.pm',-1)<>0);
  if (not terminated) and (not IsEvaluating) then
   with PerlLine do
    PR_UpdateLine(filename,line,false);
 end;

 if Length(pline)>0 then
 begin
  f:=1;
  replacesc(pline,'[4m','',false);
  replacesc(pline,'[m[1m[0;10m','',false);
  l:=ScanW(pline,'  DB<*#*> ',f);
  if f=1
   then sv:=copy(pline,l+1,length(pline))
   else sv:=pline;
  Buffer.add(sv);
  repeat
   f:=1;
   l:=ScanW(sv,'DB<*#*>',f);
   delete(sv,f,l);
  until l=0;
  if (sv<>'') and (status=stRunning) then
   PR_PerlOutput(sv);
 end;

 if breakload<>'' then
 begin
  CheckAndAddBreakpoints(breakload);
  SleepAndProcess(50);
  if not isbreakpoint then GUI.WriteLN('c');
  WriteDebLine('[CONT]');
  BreakLoad:='';
 end;
end;

procedure TLDebMod.GUIPreTerminate(Sender: TObject);
begin
 GUI.Write(#4'C');
 GUI.WriteLN('q');
 GUI.Write(#4'C');
 GUI.WriteLN('q');
 GUI.Write(#4'C');
 GUI.WriteLN('q');
end;

procedure TLDebMod.GUIStart(Sender: TObject; const Command: String);
begin
 ChangeStatus(stProcessing);
end;

procedure TLDebMod.GUIDone(Sender: TObject);
begin
 ChangeStatus(stNotRunning);
 loaded:=false;
 CheckAndAddBreakpoints;
end;

procedure TLDebMod.DataModuleCreate(Sender: TObject);
begin
 inherited;

 PC_LDeb_Terminating:=Terminating;
 PC_LDeb_PerlInput:=SendConIn;
 PC_LDeb_BreakpointsChanged:=BreakpointsChanged;
 PC_LDeb_PerlExpressionResult:=PerlExpressionResult;
 PC_LDeb_DebuggerRunning:=_DebuggerRunning;

 if folders.DebOutput<>'' then
 begin
  assignfile(outlog,folders.DebOutput);
  rewrite(outlog);
 end;
end;

procedure TLDebMod.GUIError(Sender: TObject; const Error: String);
begin
 ErrorLoading:=Error;
end;

end.