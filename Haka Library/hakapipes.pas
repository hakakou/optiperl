unit HakaPipes;

interface
uses SysUtils,Windows,Messages,classes,hyperstr;

Type
 TPipeStatus = (psNormal,psTimeout,psError,psTerminated,psException);
 TReadEvent = Procedure(Sender : TObject; Const Text : String) of object;

procedure GetEnvironmentList(environment : TStrings);
function WinExecAndWait(const CmdLine,RunPath: string;
                          const Environment : String;
                          var ProcessInfo : TProcessInformation;
                          Visibility: integer; TimeOut : Cardinal = INFINITE): Integer;

Function PipeSTDAndWait(Const AppName,CMDLine,Environment,HomeDir,STDInput : String;
                        TimeOut,Priority : Cardinal; var PipeStatus : TPipeStatus) : String;
//returns
// #0 on error starting
// #1 on timeout

function IsWindowsNT: boolean;
Function GetEnvironmentString : String;

Type
 THKGUI = Class
 private
  lpsa : PSECURITYATTRIBUTES;
  pi : TPROCESSINFORMATION;
  hInputRead, hInputWrite  : THANDLE;
  hOutputRead, hOutputWrite  : THANDLE;
  Fclosedhandles : boolean;

  FBuffer : String;
  procedure CheckSecurity;
  procedure CloseHandles;
  function DoCreateProcess: Boolean;
  procedure ProcessError;
 public
  Output : String;
  LastError : String;
  ExitCode : Cardinal;
  Priority : Cardinal;
  hProcess : Cardinal;
  LastUpdate : Cardinal;
  PipeStatus : TPipeStatus;
  Delimiter : String;
  CmdLine : String;
  HomeDir : String;
  AppName : String;
  Environment : String;
  OnRead : TReadEvent;
  Constructor Create;
  Destructor Destroy; override;
  Procedure Start;
  Procedure Stop;
  Procedure Read;
  Procedure ClearOutput;
  Procedure Write(Const S : String);
  Procedure WriteLN(Const S : String);
 end;

implementation

Function PipeSTDAndWait(Const AppName,CMDLine,Environment,HomeDir,STDInput : String;
                        TimeOut,Priority : Cardinal; var PipeStatus : TPipeStatus) : String;
var
 GUI : THKGUI;
 EndTime : Cardinal;
 ForceTerminate : Boolean;
begin
 GUI:=THKGUI.Create;
 try
  GUI.CmdLine:=CMDLine;
  GUI.AppName:=AppName;
  GUI.Environment:=Environment;
  GUI.HomeDir:=homedir;
  GUI.Priority:=Priority;
  EndTime:=GetTickCount+Timeout;
  GUI.Start;
  if length(STDInput)>0 then
   GUI.Write(STDInput);
  repeat
   GUI.Read;
   ForceTerminate:=GetTickcount>EndTime;
  until ForceTerminate or (GUI.PipeStatus=psError) or
        (WaitForSingleObject(GUI.hProcess,5)=WAIT_OBJECT_0);
  GUI.Read;
  PipeStatus:=GUI.PipeStatus;
  if ForceTerminate then
  begin
   PipeStatus:=psTimeout;
   GUI.Stop;
  end;
  result:=GUI.Output;
 finally
  GUI.Free;
 end;
end;

procedure DoTerminateProcess(PI : TProcessInformation);
var
 ps : THandle;
begin
 ps := OpenProcess(1,false,pi.dwProcessID);
 if ps <> 0 then
  TerminateProcess(ps,cardinal(-9));
end;

function IsWindowsNT: boolean;
var
 osv : TOSVersionInfo;
begin
 osv.dwOSVersionInfoSize := sizeof(osv);
 GetVersionEx(osv);
 Result := Bool(osv.dwPlatformId = VER_PLATFORM_WIN32_NT);
end;

{ THKGUI }

procedure THKGUI.CheckSecurity;
var
   sa: SECURITY_ATTRIBUTES;
   sd: SECURITY_DESCRIPTOR;
begin
   if IsWindowsNT then
   begin
      InitializeSecurityDescriptor(@sd,SECURITY_DESCRIPTOR_REVISION);
      SetSecurityDescriptorDacl(@sd, true, nil, false);
      sa.nLength := sizeof(TSECURITYATTRIBUTES);
      sa.bInheritHandle := true;
      sa.lpSecurityDescriptor := @sd;
      lpsa := @sa;
    end
  else
   lpsa := nil;
end;

Function THKGUI.DoCreateProcess : Boolean;
var
   si : TSTARTUPINFO;
   CP : THandle;
   hDupInputWrite, hDupOutputRead: THANDLE;
   Flag : Cardinal;
   PipeSize : Cardinal;
   ACmd : String;
   Env : Pchar;
   HD : PChar;
begin
   PipeSize:=0;
   hDupInputWrite:=0;
   hDupOutputRead:=0;
   result:=CreatePipe( hInputRead, hInputWrite, lpsa, PipeSize);
   if result then
    CreatePipe( hOutputRead, hOutputWrite, lpsa, PipeSize);
   CP := GetCurrentProcess;
   if result then
    result:=DuplicateHandle( CP, hInputWrite, CP, @hDupInputWrite, 0, TRUE,
                   DUPLICATE_CLOSE_SOURCE or DUPLICATE_SAME_ACCESS );
   if result then
    result:=DuplicateHandle(CP, hOutputRead, CP, @hDupOutputRead, 0, TRUE,
                   DUPLICATE_CLOSE_SOURCE or DUPLICATE_SAME_ACCESS );

   FillChar(si, sizeof(TSTARTUPINFO),0);
   si.cb := sizeof(TSTARTUPINFO);
   si.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
   si.wShowWindow := SW_HIDE;
   si.hStdOutput := hDupInputWrite; //  Redirect command line to GUI
   si.hStdError := hDupInputWrite;
   si.hStdInput := hDupOutputRead;  //  and send stuff from here to command line
   Flag := CREATE_NEW_PROCESS_GROUP or Priority;

   if length(cmdLine)>0
    then ACMD:='"'+Appname+'" '+CmdLine
    else Acmd:='"'+AppName+'"';

   if length(Environment)=0
    then Env:=nil
    else Env:=pchar(Environment);

   if length(HomeDir)=0
    Then hd:=nil
    else HD:=pchar(HomeDir);

   if result then
    result:=CreateProcess(Pchar(AppName),Pchar(ACmd),nil,nil,TRUE,Flag,env,hd,si,pi);

   if result
   then
    hprocess:=pi.hProcess
   else
    fillchar(pi,sizeof(pi),0);

   if hDupInputWrite>0 then
    CloseHandle( hDupInputWrite );               //  Close duplicates so GUI end
   if hDupOutputRead>0 then
    CloseHandle( hDupOutputRead );               //  can use the pipes
end;


procedure THKGUI.CloseHandles;
begin
 if not Fclosedhandles then
 begin
  if hInputRead>0 then
   CloseHandle(hInputRead);
  if hOutputWrite>0 then
   CloseHandle(hOutputWrite);
  if pi.hThread>0 then
   CloseHandle(pi.hThread);
  if pi.hProcess>0 then
   CloseHandle(pi.hProcess);
  Fclosedhandles:=true;
 end;
end;

procedure THKGUI.ClearOutput;
begin
 SetLength(Output,0);
end;

constructor THKGUI.Create;
begin
 Delimiter:=#13#10;
 SetLength(FBuffer,1024);
 Priority:=NORMAL_PRIORITY_CLASS;
end;

destructor THKGUI.Destroy;
begin
 Stop;
 CloseHandles;
 Inherited Destroy;
end;

procedure THKGUI.Read;
var
 BytesRead,BytesTotal,BytesLeft : Cardinal;
begin
 repeat
  PeekNamedPipe(hInputRead, @FBuffer[1],1,@BytesRead,@BytesTotal,@BytesLeft);
  if (BytesRead > 0 ) then
  begin
   if ReadFile(hInputRead, FBuffer[1], length(Fbuffer), BytesRead, nil) then
    begin
     OutPut:=OutPUt+copy(Fbuffer,1,BytesRead);
     if assigned(OnRead) then
      OnRead(self,copy(Fbuffer,1,BytesRead));
    end
   else
    begin
     ProcessError;
     if PipeStatus<>psNormal then break;
    end;
  end;
  LastUpdate:=GetTickCount;
 until BytesRead=0;
 ProcessError;
end;

procedure THKGUI.Start;
begin
 Output:='';
 PipeStatus:=psError;
 CheckSecurity;
 if not DoCreateProcess then exit;
 PipeStatus:=psNormal;
end;

procedure THKGUI.Stop;
begin
 if pipestatus=psNormal then
 begin
  DoTerminateProcess(pi);
  pipestatus:=psTerminated;
 end; 
end;

procedure THKGUI.ProcessError;
var
 Error : Cardinal;
 P : Pchar;
begin
 if pipestatus<>psNormal then exit;

 if (not GetExitCodeProcess(pi.hProcess,ExitCode)) then
 begin
  PipeStatus:=psException;
  ExitCode:=0;
  exit;
 end;

 if (ExitCode<>STILL_ACTIVE) then
 begin
  pipeStatus:=psTerminated;
  if ExitCode>=STATUS_ACCESS_VIOLATION then
   PipeStatus:=psException;

  Error:=GetLastError;   //  if error in [0,232,109] then
  if Error>0 then
  begin
   FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_ALLOCATE_BUFFER,nil,Error,0,@p,0,nil);
   LastError:=trim(p);
  end;
 end;

end;

procedure THKGUI.Write(const S: String);
var
 BytesTotal,BytesRead : Cardinal;
begin
 BytesTotal:=length(S);
 while BytesTotal>0 do
 begin
  if not WriteFile(hOutputWrite,s[1],length(S), BytesRead, nil) then
  begin
   ProcessError;
   if PipeStatus<>psNormal then break;
  end;
  dec(BytesTotal,BytesRead);
 end;
end;

procedure THKGUI.WriteLN(const S: String);
begin
 Write(s+Delimiter);
end;


Function GetEnvironmentString : String;
var
 CurEnv : pchar;
 var i:integer;
begin
 CurEnv:=getEnvironmentStrings;
 try
  i:=-1;
  repeat
   inc(i);
  until ((curenv[i]=#0) and (curEnv[i+1]=#0)) or (i>60000);
  inc(i,2);
  setlength(result,i);
  move(curenv[0],result[1],i);
 finally
  FreeEnvironmentStrings(curenv);
 end;
end;

procedure GetEnvironmentList(environment : TStrings);
var
  env,w : String;
  i : Integer;
begin
 env:=GetEnvironmentString;
 I := 1;
 repeat
  W := Parse(env,#0,I);
  if length(w)>0 then
   Environment.Add(w);
 until (I<1) or (I>Length(env));
end;

function WinExecAndWait(const CmdLine,RunPath: string;
                          const Environment : String;
                          var ProcessInfo : TProcessInformation;
                          Visibility: integer; TimeOut : Cardinal = INFINITE): Integer;
 { returns -1 if the Exec failed, otherwise returns the process' exit
   code when the process terminates }
var
  StartupInfo: TStartupInfo;
  Env : Pchar;
begin
  if Environment=''
   then env:=nil
   else env:=pchar(environment);
  FillChar(StartupInfo, Sizeof(StartupInfo), #0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
   if not CreateProcess(nil,pchar(cmdline),
    nil, { pointer to process security attributes }
    nil, { pointer to thread security attributes }
    false, { handle inheritance flag }
    CREATE_NEW_CONSOLE or { creation flags }
    NORMAL_PRIORITY_CLASS,
    Env, { pointer to new environment block }
    PChar(runpath), { pointer to current directory name }
    StartupInfo, { pointer to STARTUPINFO }
    ProcessInfo) { pointer to PROCESS_INF }
    then
     Result := -1
  else
  begin
    WaitforSingleObject(ProcessInfo.hProcess, TimeOut);
    GetExitCodeProcess(ProcessInfo.hProcess, Cardinal(Result));
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
  end;
end;


end.
