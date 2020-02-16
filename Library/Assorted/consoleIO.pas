unit ConsoleIO;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SyncObjs,hyperstr, DIPCre;

const
      CR = #13;
      LF = #10;
   Space = ' ';
    CRLF = #13#10;

type

 TProcessState = (psRunning,psTimeOut,psFinished);
 TBufferSize = (bs256,bs512,bs1k,bs2k,bs4k,bs8k);
 TPipeSize = (ps1k,ps2k,ps4k,ps8k,ps16k,ps32k,ps64k,ps96K,ps128k,ps256k);
 TABufferSize = array[bs256..bs8K] of Cardinal;
 TAPipeSize = array[ps1k..ps256k] of Cardinal;
 //Delay in msec
 TTimeOutDelay = 10..10000;
 TBuffer = array[0..0] of char;
 pTBuffer = ^TBuffer;

type
  TGUI2Console = class;
  TAppType = (at16bit,at32bit,atDontCare);
  TStartEvent = procedure(Sender : TObject; const Command : String) of object;
  TDoneEvent = procedure(Sender : TObject) of object;
  TSendLine = procedure(Sender : TObject; const Line : String) of object;
  TError = procedure(Sender: TObject; const Error : String) of object;
  TTimeOut = procedure(Sender : TObject; var Kill : Boolean) of object;
  TPromptEvent = procedure(Sender : TObject; const Line : String) of object;
  TStatusEvent = procedure(Sender : TObject; const Status : String) of object;
  TPreTerminateEvent = procedure(Sender : TObject) of object;

 TConsoleProperties = record
   FTimeOutDelay : TTimeOutDelay;
   FPipeSize : TPipeSize;
   FBufferSize : TBufferSize;
   FAutoTerminate : Boolean;
   FLogFile : String;
   FEnvironment : String;
   FApp: String;
   FAppType : TAppType;
   FCommand : String;
   FPrompt : String;
   FHomeDir : String;
   FPriority : TThreadPriority;
   FSendNillLines : Boolean;
 end;

 TConsoleEvents = record
   FStart : TStartEvent;
   FDone : TDoneEvent;
   FSendLine : TSendLine;
   FError : TError;
   FStatus : TStatusEvent;
   FTimeOut : TTimeOut;
   FAppType : TAppType;
   FPromptEvent : TPromptEvent;
   FPreTerminate : TPreTerminateEvent;
 end;

TLogFile = class(TFileStream)
public
 procedure WriteString(const Str : String);
end;

TLineStream = class(TMemoryStream)
protected
 function GetChar(Index :Integer):char;
 procedure SetChar(Index : Integer; C : Char);
public
 property Chr[Index : Integer]:char read GetChar write SetChar;
end;

TConsoleThread = class(TThread)
 private
 //Member Objects
 //CriticalSection : TCriticalSection;
 //member variables
  FCP : TConsoleProperties;
  FCE : TConsoleEvents;
  FCO : TObject;
  FAtPrompt : Boolean;
  hInputRead, hInputWrite  : THANDLE;
  hOutputRead, hOutputWrite  : THANDLE;
  pi : TPROCESSINFORMATION;
  FStream : TLineStream;
  List : TStringList;
  FLine,FLast : String;
  sd : TSECURITYDESCRIPTOR;
  sa : TSECURITYATTRIBUTES;
  lpsa : PSECURITYATTRIBUTES;
  si : TSTARTUPINFO;
  Timer : integer;
  FBuffer : pTBuffer;
  Flag : DWORD;
  FLogFile : TLogFile;
  FFreed : Boolean;
  //procedures and functions
  function WaitForSingleObject(Handle : THandle): DWORD;
  procedure CheckSecurity;
  procedure CreateProcess;
  procedure CloseHandles;
  procedure RunPipe;
  procedure TerminateProcess(const Msg : String);
protected
  Message : String;
  procedure DoStart;
  procedure DoDone;
  procedure DoPreTerminate;
  procedure SendLine;
  procedure DoError;
  procedure DoTimeOut;
  procedure DoStatus;
  procedure DoPrompt;
  procedure WriteBuffer(Count : Integer);
  function  Cmd: String;
 public
  constructor CreateConsole(Console : TGUI2Console);
  procedure Execute; override;
  destructor Destroy; override;
 end;

 TGUI2Console = class(TComponent)
  private
   FCP : TConsoleProperties;
   FCE : TConsoleEvents;
   FConsoleThread : TConsoleThread;
   PCRE : TDIPCre;
   procedure Terminate(Sender : TObject);
   procedure SetPrompt(P : String);
 public
   procedure Start;
   constructor Create(AOwner : TComponent); override;
   destructor Destroy; override;
   procedure Stop;
   procedure Write(Buffer : String);
   procedure WriteLN(Buffer : String);
 published
   //Properties
   property Application : String read FCP.FApp write FCP.FApp;
   property AppType : TAppType read FCP.FAppType write FCP.FAppType;
   property Environment : String read FCP.FEnvironment write FCP.FEnvironment;
   property Command : String read FCP.FCommand write FCP.FCommand;
   property HomeDirectory : String read FCP.FHomeDir write FCP.FHomeDir;
   property LogFile : String read FCP.FLogFile write FCP.FLogFile;
   property Prompt : String read FCP.FPrompt write SetPrompt;
   property AutoTerminate : Boolean read FCP.FAutoTerminate write FCP.FAutoTerminate;
   property PipeSize : TPipeSize read FCP.FPipeSize write FCP.FPipeSize;
   property BufferSize : TBufferSize read FCP.FBufferSize write FCP.FBufferSize;
   property TimeOutDelay : TTimeOutDelay read FCP.FTimeOutDelay write FCP.FTimeOutDelay;
   property Priority : TThreadPriority read FCP.FPriority write FCP.FPriority;
   property SendNillLines : boolean read FCP.FSendNillLines write FCP.FSendNillLines;
   //Events
   property OnStart : TStartEvent read FCE.FStart write FCE.FStart;
   property OnDone : TDoneEvent read FCE.FDone write FCE.FDone;
   property OnLine : TSendLine read FCE.FSendLine write FCE.FSendLine;
   property OnError : TError read FCE.FError write FCE.FError;
   property OnTimeOut : TTimeOut read FCE.FTimeOut write FCE.FTimeOut;
   property OnStatus : TStatusEvent read FCE.FStatus Write FCE.FStatus;
   property OnPrompt : TPromptEvent read FCE.FPromptEvent Write FCE.FPromptEvent;
   property OnPreTerminate : TPreTerminateEvent read FCE.FPreTerminate Write FCE.FPreTerminate;
end;



procedure Register;

implementation

var CriticalSection : TCriticalSection;

const

            ErrCode = ' Error Code :%0d';
       ErrSecurity  = 'Error Setting Security';
      TerminateUser = 'Terminated By User';
     InvalidConsole = 'Console Information Is Null';
       ProcessError = 'Process Error'+ErrCode;
     ConsoleTimeOut = 'Console Time Out';
                EOS = 'End of Stream';
   ErrorOpeningPipe = 'Error Opening Pipe'+ErrCode;
 ErrCreatingProcess = 'Error Creating Process';
      KillOnDestroy = 'Process Terminated On Objects Destruction';
     ProcessRunning = 'Process Already Running';
  NormalTermination = 'Normal Thread Termination';
          ErrorCode =  '%0s '+ ErrCode;
          uSecDelay = 5;
DefaultTimeOutDelay = 50;
SECURITY_DESCRIPTOR_REVISION = 1;

const
 BufferSizes  : TABufferSize = (256,512,1024,2048,4096,8192);
 PipeSizes : TAPipeSize = (1024,2048,4096,8192,16384,32768,65536,98304,131072,262144);


type

EEndOfStream = class(EAbort);
ETerminate = class(EAbort);
EConsoleIOError = class(EABort);
EProcessCreate = class(EConsoleIOError);
EPipeCreate = class(EConsoleIOError);
EWaitError = class(EConsoleIOError);
EProcessRunning = class(EConsoleIOError);


procedure AssertPipe(const B : BOOL);
 begin
  if not B then
   raise EPipeCreate.CreateFMT(ErrorOpeningPipe,[GetLastError]);
 end;

function IsWindowsNT: boolean;
var
 osv : TOSVersionInfo;
begin
 osv.dwOSVersionInfoSize := sizeof(osv);
 GetVersionEx(osv);
 Result := Bool(osv.dwPlatformId = VER_PLATFORM_WIN32_NT);
end;

procedure Register;
begin
  RegisterComponents('REDsys', [TGUI2Console]);
end;

function IncTimer(var X: Integer;N : Integer):LongInt;
begin
  System.Inc(X,N);
  Result := X;
end;

function Buf2Str(const Buffer; const length : integer):String;
var S : String;
begin
 SetString(S,Pchar(Buffer),Length);
 Result := S;
end;

//******************************************************************************
//****** TLogFile
//******************************************************************************
procedure TLogFile.WriteString(const Str : String);
begin
  Write(Str[1],length(Str));
end;

//******************************************************************************
//****** TConsoleThread
//******************************************************************************

constructor TConsoleThread.CreateConsole(Console : TGUI2Console);
begin
 FCP := Console.FCP;
 FCE := Console.FCE;
 FCO := Console;
 FAtPrompt := False;
 FStream := TLineStream.Create;
 List := TStringList.Create;
 Create(True);
 Priority  := FCP.FPriority;
 FLogFile := nil;
 FFreed := False;
 if FCP.FLogFile <> '' then
 try
 FLogFile := TLogFile.Create(FCP.FLogFile,fmCreate or fmShareExclusive);
 except
   on E : exception do
     begin
       Message := E.Message;
       Synchronize(DoError);
     end;
 end;
end;

destructor TConsoleThread.Destroy;
begin
 try
  FStream.Free;
  List.Free;
  //CriticalSection.Free;
  FLogFile.Free;
 finally
  inherited;
 end;
end;

function TConsoleThread.WaitForSingleObject(Handle : THandle):DWORD;
begin
 Result := Windows.WaitForSingleObject(Handle,uSecDelay);
 if Result = $ffffff then
  raise EWaitError.CreateFmt(ProcessError,[GetLastError]);
end;

function TConsoleThread.Cmd: String;
begin
  if FCP.FApp = '' then
   Result := FCP.FCommand
  else
   if FCP.FCommand <> ''
   then Result := FCP.FApp + Space + FCP.FCommand
   else Result := FCP.FCommand;
 end;

 procedure TConsoleThread.Execute;
 begin
 try
   try
    GetMem(FBuffer,BufferSizes[FCP.FBufferSize]);
    Synchronize(DoStart);
    CheckSecurity;
    CreateProcess;
    RunPipe;
    Synchronize(DoPreTerminate);
    TerminateProcess(NormalTermination);
   except
     on E : exception do
      begin
        Message := E.Message;
        Synchronize(DoError);
      end;
   end;
  finally
   CloseHandles;
   FreeMem(FBuffer);
   Synchronize(DoDone);
  end;
 end;

 procedure TConsoleThread.TerminateProcess(const Msg : String);
 var ps : THandle;
 begin
  Message := Msg;
  Synchronize(DoStatus);
  ps := OpenProcess(1,false,pi.dwProcessID);
  if ps <> 0 then
   Windows.TerminateProcess(ps,cardinal(-9));
 end;

 procedure TConsoleThread.CheckSecurity;
 begin
    if IsWindowsNT then
     begin
        InitializeSecurityDescriptor(@sd,SECURITY_DESCRIPTOR_REVISION);
        Assert(SetSecurityDescriptorDacl(@sd, true, nil, false),ErrSecurity);
        sa.nLength := sizeof(TSECURITYATTRIBUTES);
        sa.bInheritHandle := true;
        sa.lpSecurityDescriptor := @sd;
        lpsa := @sa;
      end else lpsa := nil;
 end;

 procedure TConsoleThread.CreateProcess;
 var CP : THandle;
  hDupInputWrite, hDupOutputRead: THANDLE;
  lpApp,lpCmd,lpEnv,lpHome : PChar;
  sCmd : String;

  function MakelpChar(var S : String) : PChar;
  begin
    if S <> '' then
     Result := @S[1]
     else Result := nil;
  end;

 begin
 try
  AssertPipe(CreatePipe( hInputRead, hInputWrite, lpsa, PipeSizes[FCP.FPipeSize]));
  AssertPipe(CreatePipe( hOutputRead, hOutputWrite, lpsa, PipeSizes[FCP.FPipeSize]));

  CP := GetCurrentProcess;

  // First pipe for Console -> GUI
  AssertPipe(DuplicateHandle( CP, hInputWrite, CP, @hDupInputWrite, 0, TRUE,
                              DUPLICATE_CLOSE_SOURCE or DUPLICATE_SAME_ACCESS ));

  //  and a second for GUI -> console
  AssertPipe(DuplicateHandle(CP, hOutputRead, CP, @hDupOutputRead, 0, TRUE,
                             DUPLICATE_CLOSE_SOURCE or DUPLICATE_SAME_ACCESS ));


  // initialize STARTUPINFO struct

   FillChar(si, sizeof(TSTARTUPINFO),0);
   si.cb := sizeof(TSTARTUPINFO);
   si.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
   si.wShowWindow := SW_HIDE;
   si.hStdOutput := hDupInputWrite; //  Redirect command line to GUI
   si.hStdError := hDupInputWrite;
   si.hStdInput := hDupOutputRead;  //  and send stuff from here to command line


  if FCP.FAppType = at16Bit
  then Flag := CREATE_SEPARATE_WOW_VDM
  else Flag := CREATE_NEW_PROCESS_GROUP;

  Flag := Flag or NORMAL_PRIORITY_CLASS;

  sCmd := Cmd;
  lpCmd := MakeLPChar(sCmd);

  lpApp := MakeLPChar(FCP.FApp);
  lpEnv := MakeLPChar(FCP.FEnvironment);
  lpHome := MakeLPChar(FCP.FHomeDir);

 if not Windows.CreateProcess(lpApp,lpCmd,nil,nil,TRUE,Flag,lpEnv,lpHome,si,pi)
 then raise EProcessCreate.CreateFmt(ErrorCode,[ErrCreatingProcess,GetLastError]);

 finally
  CloseHandle( hDupInputWrite );               //  Close duplicates so GUI end
  CloseHandle( hDupOutputRead );               //  can use the pipes
 end;
end;

procedure TConsoleThread.CloseHandles;
begin
  CloseHandle(hInputRead);
  CloseHandle(hOutputWrite);
  CloseHandle(pi.hThread);
  CloseHandle(pi.hProcess);
  hInputRead := 0;
  hOutputWrite := 0;
end;

procedure TConsoleThread.RunPipe;
var
 Test,BytesRead,BytesTotal,BytesLeft : Cardinal;

procedure CheckTimer;
 begin
   If IncTimer(Timer,uSecDelay) < FCP.FTimeOutDelay
    then Exit;
   Timer := 0;
   if FAtPrompt then
    begin
     //Synchronize(SendLine);
     Synchronize(DoPrompt);
     FAtPrompt := False;
     //FLine := '';
    end else
    begin
     If FCP.FAutoTerminate
     then Terminate
     else Synchronize(DoTimeOut);
    end;
end;

procedure PeekAndRead;
begin
 Windows.PeekNamedPipe(hInputRead, FBuffer,1, @BytesRead,@BytesTotal,@BytesLeft);
 if (BytesRead > 0 ) then
  begin
   Timer := 0;
   if Windows.ReadFile(hInputRead, FBuffer[0], BufferSizes[FCP.FBufferSize], BytesRead, nil)
   then WriteBuffer(BytesRead);

 end else CheckTimer;
end;

begin
  Timer := 0;
  FStream.Seek(0,soFromBeginning);
  repeat
    PeekAndRead;
    Test := WaitForSingleObject(pi.hProcess);
  until (Test = WAIT_OBJECT_0) or Terminated;

  if Not Terminated then
    repeat
     PeekAndRead;
    until (BytesRead < BufferSizes[FCP.FBufferSize]) or Terminated;
    if (not terminated) and (FLast<>'') then
    begin
      Fline:=FLast;
      Synchronize(SendLine);
    end;
end;

procedure TConsoleThread.WriteBuffer(Count : Integer);
 var   Last,SLen,I : integer;
       S : String;

function IsAtPrompt(var L : String):Boolean;
//var LL : Integer;
//    p : String;
begin
 if length(FCP.FPrompt)=0
  then Result := False
  else result:=TGUI2Console(FCO).PCRE.MatchStr(L)>0;

{ if FCP.FPromptLength = 0 then Exit;
 LL := Length(L);
  if LL >= FCP.FPromptLength then
   begin
    p := Copy(FLine,LL-FCP.FPromptLength+1,FCP.FPromptLength);
    Result := (P = FCP.FPrompt);
   end;}
end;

begin
   FStream.Write(FBuffer[0],Count);
   SetString(S,PChar(FStream.Memory),FStream.Position);
   SLen := Length(S);

   Last := LastDelimiter(CRLF,S); 
   FLast:=copy(s,last+length(CRLF)-1,length(s));
   FStream.Seek(0,soFromBeginning);
   If Last < SLen then FStream.Write(S[Last+1],SLen-Last);

//   S := Copy(S,0,Last)+ #0; //why this?
   setLength(s,Last);
   replaceSC(s,#13#13#10,#13#10,false);
     If S <> '' then
      begin
       List.Clear;
       List.SetText(Pchar(S));
        i := 0;
        while not Terminated and (I < List.Count) do
         begin
           FLine :=  List[i];
           if (FLine <> '') or (FCP.FSendNillLines) then
             begin
               Synchronize(SendLine);
               FAtPrompt := IsAtPrompt(FLine);
              end;
          Inc(i);
        end;
      end;
   FLine := '';
   //Now Check rest of data to see if by chance, it contains a prompt
   if FStream.Position > 0 then
    begin
     SetString(FLine,PChar(FStream.Memory),FStream.Position);
     FAtPrompt := IsAtPrompt(FLine);
    //FStream.Seek(0,soFromBeginning);
    end;
end;


procedure TConsoleThread.DoStart;
begin
 if FFreed then Exit;
 If  Assigned(FCE.FStart)
  then FCE.FStart(FCO, Cmd);
end;

procedure TConsoleThread.DoDone;
begin
 if FFreed then Exit;
 If Assigned(FCE.FDone) then
  FCE.FDone(FCO);
end;

procedure TConsoleThread.DoPreTerminate;
begin
 if FFreed then Exit;
 If Assigned(FCE.FPreTerminate) then
  FCE.FPreTerminate(FCO);
end;

procedure TConsoleThread.SendLine;
begin
 if FFreed then Exit;
  if Assigned(FCE.FSendLine) then
   begin
    if Assigned(FLogFile) then
     FLogFile.WriteString(FLine+CRLF);
    FCE.FSendLine(FCO,FLine);
   end;
end;

procedure TConsoleThread.DoPrompt;
begin
 if FFreed then Exit;
 if Assigned(FCE.FPromptEvent)
  then FCE.FPromptEvent(FCO,FLine);
end;

procedure TConsoleThread.DoStatus;
begin
 if FFreed then Exit;
 if Assigned(FCE.FStatus) then
  FCE.FStatus(FCO,Message);
end;

procedure TConsoleThread.DoError;
begin
 if FFreed then Exit;
 if Assigned(FCE.Ferror) then
  FCE.FError(FCO,Message);
end;

procedure TConsoleThread.DoTimeOut;
var Kill : Boolean;
begin
 if FFreed then Exit;
 Kill := False;
 If Assigned(FCE.FTimeOut) then
  begin
   FCE.FTimeOut(FCO,Kill);
   If Kill then
     Terminate;
  end;
end;

//******************************************************************************
//****** TGUI2Console
//******************************************************************************

procedure TGUI2Console.Start;
begin
try
 CriticalSection.Enter;
  if FConsoleThread = nil then
  begin
   FConsoleThread := TConsoleThread.CreateConsole(Self);
   FConsoleThread.Priority := tpLower;
   FConsoleThread.OnTerminate := Terminate;
   FConsoleThread.FreeOnTerminate := True;
   FConsoleThread.Resume;
  end else
     if Assigned(FCE.FError) then
       FCE.FError(Self,ProcessRunning);
 finally
  CriticalSection.Leave;
 end;
end;

procedure TGUI2Console.Stop;
begin
 If (FConsoleThread <> nil) then
  FConsoleThread.Terminate;
end;

procedure TGUI2Console.Write(Buffer : String);
var NumBytes : Cardinal;
begin
try
 CriticalSection.Enter;
 If Assigned(FConsoleThread) and not FConsoleThread.FFreed and not FConsoleThread.Terminated then
    Windows.WriteFile( FConsoleThread.hOutputWrite, Buffer[1], length(Buffer), NumBytes, nil);
finally
 CriticalSection.Leave;
end;
end;

procedure TGUI2Console.WriteLN(Buffer : String);
begin
 Write(Buffer+CRLF);
end;

procedure TGUI2Console.SetPrompt(P : String);
begin
 FCP.FPrompt := P;
 PCRE.MatchPattern:=P;
end;

procedure TGUI2Console.Terminate(Sender : TObject);
begin
 FConsoleThread := nil;
end;

constructor TGUI2Console.Create(AOwner : TComponent);
begin
 PCRE:=TDIPCre.Create(nil);
 FCP.FPipeSize := ps128K;
 FCP.FBufferSize := bs1K;
 FCP.FTimeOutDelay := DefaultTimeOutDelay;
 FCP.FAppType := at32bit;
 FCP.FAutoTerminate := False;
 FCP.FPriority := tpNormal;
 FCP.FSendNillLines:=false;
 FConsoleThread := nil;
 inherited;
end;

destructor TGUI2Console.Destroy;
var i : integer;
begin
 try
  if Assigned(FConsoleThread) then
  begin
   FConsoleThread.FFreed := True;
   if not FConsoleThread.Terminated then
   begin
    FConsoleThread.Terminate;
    i := 0;
    while (FConsoleThread <> nil) and (I<10000) do
    begin
     Forms.Application.ProcessMessages;
     Inc(i);
    end;
   end;
  end;
 finally
  PCRE.Free;
  inherited;
 end; 
end;


//*****************************************************************************

procedure TLineStream.SetChar(Index : Integer; C : Char);
begin
 Char(Pointer(LongInt(Memory)+Index)^):= C;
end;


function TLineStream.GetChar(Index :Integer):char;
begin
 Result := Char(Pointer(LongInt(Memory)+Index)^);
end;

initialization
 CriticalSection := TCriticalSection.Create;
finalization
 CriticalSection.Free;
end.

