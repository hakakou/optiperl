unit CustDebMdl;   //Module
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ImgList, HyperStr, runperl,Optoptions,hakageneral,HakaRandom,
  ExtCtrls,jclfileutils,Hakafile, variants,OptProcs, OptMessage,
  OptGeneral,registry,OptFolders,DIPcre,HKDebug;

type
  TPerlLine = Record
   filename : string;
   line,reserved : integer;
  end;

  PWatch = ^Twatch;
  TWatch = Record
   Expression,Value : String;
  end;

  TStatus = (stRunning,stStopped,stTerminated,stProcessing,stNotRunning);
  TDebAction = (debSingleStep,debNextStep,debReturnFromSub,
                   debContinueScript,debListSubNames,debPackageVars,
                   debEvaluateVars,debMethodsCall,debStop,debRestart,debStart,
                   debToggleBreakpoint,debStepConsole,debCallStack);

  TDebActions = Set of TDebAction;

  TCustDebMod = class(TDataModule)
    Timer: TTimer;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    perl5db : string;
    //If true will not send commands to editor to change line
    ExprResPattern : string;
    function ValOKToEvaluate(const v: String): Boolean;
  protected
    outlog : Text;
    PerlLine : TPerlLine;
    BreakLoad : String;
    IsEvaluating: Boolean;
    Buffer : TStringList;
    Terminated:boolean;
    Loaded:boolean;
    StopPressed:boolean;
    Flashing,timeOut:Boolean;
    StartPath : String;
    procedure PerlExpressionResult(var s: string);
    function _DebuggerRunning: Boolean;
    Procedure WaitTillPrompt; virtual;
    Procedure EnableActions;
    procedure BreakpointsChanged;
    Procedure ProcessEvalBuffer;
    function IsBreakPoint: boolean;
    Procedure ChangeStatus(ToStatus : TStatus);
    procedure StartTimer;
    Procedure SendCommand(const s:string; Run : BOolean); virtual;
    Procedure CheckAndAddBreakpoints(const querriedfile : string = ''); virtual;
    Procedure Terminating; virtual;
  public
    DebActions : TDebActions;
    OnStatusChange : TNotifyEvent;
    Status : TStatus;
    Script : string;

    Function FindBreakIndex(Line : Integer; Path : string) : Integer;
    Procedure EvaluateWatches;
    procedure EvaluateCallStack;
    Procedure SendConIn(const ConIn : string); virtual;
    Function ListSubNames(const Pattern : String) : String;
    Function PackageVars(const pkg,vars : string ) : string;
    Function EvaluateVar(Vars : string) : string; virtual;
    Function TestBreakpoint(line : integer; const condition : string) : boolean;
    Function MethodsCall(const aclass : string) : string;
    procedure Stop; virtual;
    Function Start : Boolean; virtual;
    procedure ContinueScript;
    procedure SingleStep;
    procedure NextStep;
    procedure ReturnFromSub;
    Procedure Restart;
    Procedure WriteDebLine(const S : String);
    procedure WatchValueChange(Watch : PWatch);
  end;

 const
  StatusStr : array[Tstatus] of string =('Running','Stopped','Terminated','Processing','Not Running');

var
  LastWatchTime : Cardinal = 0;
  LastWatchText : String = '';
  DebMod : TCustDebMod;
  WatchList : TList;
  CallStack : TStringList;

implementation

{$R *.DFM}

Procedure TCustDebMod.WriteDebLine(const S : String);
begin
 if folders.DebOutput<>'' then
  writeln(outlog,s);
end;

procedure TCustDebMod.DataModuleCreate(Sender: TObject);
begin
 Buffer:=TStringList.Create;
 ChangeStatus(stNotRunning);
 ExprResPattern:=MakePattern('^[0-9][0-9]*  ');
end;

procedure TCustDebMod.DataModuleDestroy(Sender: TObject);
begin
 Buffer.free;

 if folders.DebOutput<>''
  then closefile(outlog);
 debmod:=nil;
end;

function TCustDebMod.ValOKToEvaluate(Const v : String) : Boolean;
begin
 result:=not (
  (v='exit') or (v='die')
 );
end;

function TCustDebMod.EvaluateVar(Vars: string): string;
var
 i,l : integer;
begin
 IsEvaluating:=True;
 vars:=trim(vars);

 if not ValOKToEvaluate(vars) then
 begin
  Result:='OptiPerl: Evaluation of "'+vars+'" aborted';
  IsEvaluating:=false;
  Exit;
 end;

 SendCommand('x '+vars,false);
 WriteDebLine('EVAL:['+vars+']');
 processEvalBuffer;
 i:=Length(Buffer.Text);
 if (i>=2) and (Buffer.Text[i-1]=#13) and (Buffer.Text[i]=#10)
  then Result:=Copy(Buffer.Text,1,i-2)
  else Result:=Buffer.Text;
 ReplaceC(Result,#9,' ');
 ReplaceSC(Result,'Use `q'' to quit or `R'' to restart.  `h q'' for details.','',True);
 i:=1;
 if Scanf(result,'perl5db.pm',-1)>0 then
 begin
  i:=Pos(' at ',Result);
  if i>0 then Result:=Copy(Result,1,i-1);
 end;

 repeat
  i:=1;
  l:=ScanW(result,'DB<*#*>',i);
  if l<=8 then
   delete(result,i,l);
 until l=0;

 IsEvaluating:=false;
end;

function TCustDebMod.ListSubNames(const Pattern: String): String;
begin
 SendCommand('S '+Pattern,false);
 Result:=buffer.text;
end;

function TCustDebMod.PackageVars(const pkg, vars: string): string;
begin
 SendCommand('V '+Pkg+' '+vars,false);
 Result:=buffer.text;
end;

procedure TCustDebMod.SendConIn(const ConIn: string);
begin
end;

procedure TCustDebMod.EnableActions;
begin
 if status in [StRunning,stProcessing] then
  debActions:=[debStop,debRestart];

 if status=stStopped then
  DebActions:=[debSingleStep,debNextStep,debReturnFromSub,
                   debContinueScript,debListSubNames,debPackageVars,
                   debEvaluateVars,debMethodsCall,debStop,debRestart,
                   debToggleBreakpoint,debStepConsole,debCallStack];

 if status=stTerminated then
  DebActions:=[debListSubNames,debPackageVars,
                  debEvaluateVars,debMethodsCall,debStop,debRestart];

 if status=stNotRunning then
  DebActions:=[debStart,debToggleBreakpoint];
end;

procedure TCustDebMod.ChangeStatus(ToStatus: TStatus);
begin
 If (Tostatus=stStopped) and (Terminated) then ToStatus:=stTerminated;
 Status:=ToStatus;
 if assigned(OnStatusChange) then OnStatusChange(self);
 EnableActions;
end;

procedure TCustDebMod.SendCommand(const s: string; Run: BOolean);
begin
end;

Procedure TCustDebMod.CheckAndAddBreakpoints(const querriedfile : string = '');
begin
end;

Function TCustDebMod.IsBreakPoint : boolean;
var
 i:integer;
 bi: PBreakInfo;
begin
 result:=false;
 for i:=0 to breakpoints.Count-1 do
 begin
  bi:=pointer(breakpoints.Objects[i]);
  if (ExtractFilename(breakpoints[i])=perlline.filename) and
     (bi^.line = perlline.Line-1) then
  begin
   result:=true;
   exit;
  end;
 end;
end;

procedure TCustDebMod.WaitTillPrompt;
var
 PrTimer:Cardinal;
 PStat : TStatus;
begin
 if not loaded then exit;
 prtimer:=GetTickCount+10000;

 PStat:=Status;
 Flashing:=false;

 While  (Status=stRunning) or
        ((status=stProcessing) and (GetTickCount<prTimer)) do
  begin
   application.ProcessMessages;
  end; //do

 if flashing then
  PR_WaitingForInput(false);

 if ((pStat=StProcessing) and (GetTickCount>=prTimer)) or
    ((Status=stRunning))
 then
  ChangeStatus(stStopped);

end;

function TCustDebMod.TestBreakpoint(line: integer; const condition : string): boolean;
begin
 sendcommand('b '+inttostr(line)+' '+condition,false);
 result:=buffer.Count=0;
 sendcommand('D',false);
end;

function TCustDebMod.MethodsCall(const aclass: string): string;
begin
 sendcommand('m '+Aclass,false);
 result:=buffer.Text;
end;

procedure TCustDebMod.EvaluateCallStack;
begin
 if PR_ShouldUpdateCallStack then
 begin
  SendCommand('T',false);
  CallStack.Assign(Buffer);
  PR_UpdateCallStack;
 end;
end;

procedure TCustDebMod.EvaluateWatches;
var
 s,t:string;
 i,l:integer;
 Watch : PWatch;
 c : cardinal;
 divid  : String;
begin
 if Status<>stStopped then exit;
 divid:='_'+RandomCharacters(2)+'_'+RandomCharacters(2);
 IsEvaluating:=true;

 LastWatchTime:=0;
 LastWatchText:='';

 if assigned(PR_UpdateNearLines) then
  PR_UpdateNearLines;

 if assigned(PR_GetWatchList)
  then PR_GetWatchList
  else watchList.Clear;

 if watchList.Count=0 then
 begin
  if assigned(PR_UpdateWatchList) then
   PR_UpdateWatchList;
  IsEvaluating:=false;
  exit;
 end;

 c:=GetTickCount;
 s:='';
 for i:=0 to watchList.Count-1 do
 begin
  watch:=WatchList[i];
  if ValOKToEvaluate(watch.Expression)
   then s:=s+watch.Expression+','+divid+','
   else s:=s+'0,'+divid+','
 end;

 SendCommand('x '+s,false);

 i:=0;
 if (buffer.Count=0) or (pos('syntax',buffer[0])=1) then
  begin
   while i<watchList.Count do
   begin
    Watch:=WatchList[i];
    watch.Value:='';
    inc(i);
   end;
   if buffer.Count>0
    then LastWatchText:=Buffer[0]
    else LastWatchText:='';
  end

 else
  begin
   ProcessEvalBuffer;
   t:='';
   i:=-1;
   for l:=0 to buffer.count-1 do
   begin
    if pos(divid,buffer[l])<>0 then
    begin
     delete(t,length(t)-1,2);
     inc(i);
     if i<watchlist.Count then
     begin
      watch:=watchList[i];
      watch.Value:=t;
     end;
     t:='';
     continue;
    end;
    t:=t+buffer[l]+#13#10;
   end;
  end;

 LastWatchTime:=GetTickCount-c;

 if assigned(PR_UpdateWatchList) then
  PR_UpdateWatchList;

 IsEvaluating:=false;
end;

procedure TCustDebMod.ProcessEvalBuffer;
var
 f1,f2,l : integer;
 b : string;
begin
 b:=buffer.text;
 replaceSC(b,'\\',#2,false);
 replaceSC(b,'\''',#1,false);
 f1:=1;
 f2:=1;

 repeat

  f1:=scanFF(b,'''',f1);
  if f1=0 then break;
  f2:=scanFF(b,'''',f1+1);
  if f2=0 then break;

  for l:=f1 to f2 do begin
   if b[l]=#13 then b[l]:='\';
   if b[l]=#10 then b[l]:='n';
  end;

  f1:=f2+1;

 until (f1=0) or (f2=0);
 replaceSC(b,#1,'''',false);
 replaceSC(b,#2,'\\',false);
 buffer.text:=b;
 for l:=0 to buffer.count -1 do
 begin
  f2:=1;
  f1:=ScanRX(Buffer[l],ExprResPattern,f2);
  if (f2=1)
   then Buffer[l]:=copyFromToEnd(Buffer[l],f1+1);
 end;
end;

procedure TCustDebMod.ContinueScript;
begin
 SendCOmmand('c',true);
end;

procedure TCustDebMod.NextStep;
begin
 screen.Cursor:=crDefault;
 SendCOmmand('n',true);
end;

procedure TCustDebMod.ReturnFromSub;
begin
 screen.Cursor:=crDefault;
 sendcommand('r',true);
end;

procedure TCustDebMod.SingleStep;
begin
 screen.Cursor:=crDefault;
 SendCommand('s',true);
end;

Function TCustDebMod.Start : Boolean;
begin
end;

procedure TCustDebMod.Stop;
begin
end;

procedure TCustDebMod.BreakpointsChanged;
begin
 CheckAndAddBreakpoints;
end;

procedure TCustDebMod.PerlExpressionResult(var s:string);
begin
 if (Length(s)=0) or (not (status in [stStopped,stTerminated]))
  then s:=''
  else s:=EvaluateVar(s);
end;

procedure TCustDebMod.Restart;
var prtimer:Cardinal;
begin
 Stop;

 if fileexists(StartPath) then
  PR_OpenFile(StartPath);

 prtimer:=GetTickCount+1000;
 repeat
  application.ProcessMessages;
 until (GetTickCount>prTimer);
 Start;
end;

procedure TCustDebMod.TimerTimer(Sender: TObject);
begin
 TimeOut:=True;
 Timer.Enabled:=False;
end;

procedure TCustDebMod.StartTimer;
begin
 TimeOut:=False;
 Timer.Enabled:=false;
 Timer.Enabled:=True;
end;

function TCustDebMod.FindBreakIndex(Line: Integer; Path: string): Integer;
var
 i:integer;
 bi : ^TBreakInfo;
begin
 result:=-1;
 i:=0;
 while (i<breakpoints.Count) do
 begin
  bi:=pointer(breakpoints.objects[i]);
  if (bi^.line=line) and (breakpoints[i]=path) then
  begin
   result:=i;
   exit;
  end;
  inc(i);
 end;
end;

Function TCustDebMod._DebuggerRunning : Boolean;
begin
 result:=Status<>stNotRunning;
end;

procedure TCustDebMod.WatchValueChange(Watch : PWatch);
var
 s:string;
begin
 if (Status=stStopped) then
 begin
  s:=Watch.value;
  if s<>'' then
  begin
   replaceSC(s,#13#10,'\n',false);
   replaceSC(s,#9,'\t',false);
   s:=Watch.Expression+'='+s;
   EvaluateVar(s);
  end;
 end;
end;

procedure TCustDebMod.Terminating;
begin
 if (status<>stNotRunning) then stop;
end;

initialization
 WatchList:=TList.Create;
 CallStack:=TStringList.Create;
finalization
 WatchList.Free;
 CallStack.free;
end.