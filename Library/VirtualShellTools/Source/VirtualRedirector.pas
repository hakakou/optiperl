unit VirtualRedirector;

// Version 1.5.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------

interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, Classes, VirtualShellTypes,
  {$IFNDEF COMPILER_6_UP}
  Forms,
  {$ENDIF}
  VirtualThread;


resourcestring
  STR_CREATE_PIPE_ERROR = 'Unable to Create Pipe';
  STR_ERRORREADINGERRORPIPE = 'Error reading from pipe';
  STR_ERRORWRITINGINPIPE = 'Error writing to the pipe';
  STR_SHELLPROCESSTERMINATEERROR = 'Unable to Terminate Process';
  STR_SHELLPROCESSCREATEERROR = 'Unable to Create Process';
  STR_INVALIDAPPLICATIONFILE = 'Unable to locate the application: ';
  STR_CHILDPROCESSNOTRUNNING = 'Child process not running';
  STR_XCOPYRUNERROR = 'XCopy must be run as a separate redirected process';

const
  WM_NEWINPUT = WM_APP + 111;
  WM_CHILDPROCESSCLOSE = WM_NEWINPUT + 1;

  LineFeed =  #10#13;

type
  TRedirectorInputEvent = procedure(Sender: TObject; NewInput: string) of object;
  TRedirectorChildProcessEndEvent = procedure(Sender: TObject) of object;

  TPipeThread = class(TVirtualThread)
  private
    FMessageWnd: hWnd;
    FPipeIn: THandle;
    FPipeErrorIn: THandle;
  protected
    procedure Execute; override;

    property PipeIn: THandle read FPipeIn write FPipeIn;
    property PipeErrorIn: THandle read FPipeErrorIn write FPipeErrorIn;
    property MessageWnd: hWnd read FMessageWnd write FMessageWnd;
  public
    procedure Terminate; override;
  end;

  TProcessTerminateThread = class(TVirtualThread)
  private
    FChildProcess: THandle;
    FMessageWnd: hWnd;
  protected
     procedure Execute; override;

     property ChildProcess: THandle read FChildProcess write FChildProcess;
     property MessageWnd: hWnd read FMessageWnd write FMessageWnd;
  end;

  TCustomVirtualRedirector = class(TComponent)
  private
    FRunning: Boolean;
    FPipeIn: THandle;     // With respect to this process, Pipe input from child process
    FPipeOut: THandle;    // With respect to this process, Pipe output to child process
    FPipeErrorIn: THandle; // With respect to this process, Pipe input from child process
    FProcessInfo: TProcessInformation;
    FOnInput: TRedirectorInputEvent;
    FOnErrorInput: TRedirectorInputEvent;
    FOnChildProcessEnd: TRedirectorChildProcessEndEvent;
    FHelperWnd: HWnd;
    FPipeThread: TPipeThread;
    FProcessTerminateThread: TProcessTerminateThread;
    function GetChildProcessHandle: THandle;
    function GetChildProcessThread: THandle;
    function GetChildProcessID: Longword;
    function GetChildThreadID: Longword;
  protected
    procedure CloseAndZeroHandle(var Handle: THandle);
    procedure CloseHandles;
    procedure DoErrorInput(NewErrorInput: string); virtual;
    procedure DoInput(NewInput: string); virtual;
    procedure DoChildProcessEnd; virtual;
    procedure HelperWndProc(var Message: TMessage);
    procedure KillThreads;

    property HelperWnd: HWnd read FHelperWnd write FHelperWnd;
    property OnErrorInput: TRedirectorInputEvent read FOnErrorInput write FOnErrorInput;
    property OnInput: TRedirectorInputEvent read FOnInput write FOnInput;
    property OnChildProcessEnd: TRedirectorChildProcessEndEvent read FOnChildProcessEnd write FOnChildProcessEnd;
    property PipeOut: THandle read FPipeOut write FPipeOut;
    property PipeIn: THandle read FPipeIn write FPipeIn;
    property PipeErrorIn: THandle read FPipeErrorIn write FPipeErrorIn;
    property PipeThread: TPipeThread read FPipeThread write FPipeThread;
    property ProcessTerminateThread: TProcessTerminateThread read FProcessTerminateThread write FProcessTerminateThread;
    property ProcessInfo: TProcessInformation read FProcessInfo write FProcessInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Run(FileName, InitialDirectory: WideString; Parameters: WideString = ''): Boolean;
    procedure Kill;
    procedure Write(Command: string); virtual;

    property ChildProcessHandle: THandle read GetChildProcessHandle;
    property ChildProcessID: Longword read GetChildProcessID;
    property ChildProcessThread: THandle read GetChildProcessThread;
    property ChildThreadID: Longword read GetChildThreadID;
    property Running: Boolean read FRunning;
  end;

  TVirtualRedirector = class(TCustomVirtualRedirector)
  published
    property OnErrorInput;
    property OnInput;
    property OnChildProcessEnd;
  end;

  // ******************
  TRedirectorChangeDir = procedure(Sender: TObject; NewDir: string; var Allow: Boolean) of object;

  TVirtualCommandLineRedirector = class(TCustomVirtualRedirector)
  private
    FOnDirChange: TRedirectorChangeDir;
  protected
    procedure DoChangeDir(NewDir: string; var Allow: Boolean); virtual;
  public
    procedure CarrageReturn;
    procedure ChangeDir(NewDir: string);
    function FormatData(Data: string): string;
    procedure Write(Command: string); override;
  published
    property OnChildProcessEnd;
    property OnDirChange: TRedirectorChangeDir read FOnDirChange write FOnDirChange;
    property OnErrorInput;
    property OnInput;
  end;

implementation

uses
  SysUtils;

{ TCustomVirtualRedirector }

procedure TCustomVirtualRedirector.CloseAndZeroHandle(var Handle: THandle);
begin
  if Handle <> 0 then
  try
    CloseHandle(Handle);
  finally
    Handle := 0;
  end
end;

procedure TCustomVirtualRedirector.CloseHandles;
begin
  CloseAndZeroHandle(FPipeIn);
  CloseAndZeroHandle(FPipeErrorIn);
  CloseAndZeroHandle(FPipeOut);
end;

constructor TCustomVirtualRedirector.Create(AOwner: TComponent);
begin
  inherited;
  {$IFNDEF COMPILER_6_UP}
  HelperWnd :=Forms.AllocateHWnd(HelperWndProc);
  {$else}
  HelperWnd :=Classes.AllocateHWnd(HelperWndProc);
  {$ENDIF}
end;

destructor TCustomVirtualRedirector.Destroy;
begin
  if Running then
  begin
    Kill;
    KillThreads;
  end;
  {$IFNDEF COMPILER_6_UP}
  Forms.DeAllocateHWnd(HelperWnd);
  {$else}
  Classes.DeAllocateHWnd(HelperWnd);
  {$ENDIF}
  inherited;
end;

procedure TCustomVirtualRedirector.DoChildProcessEnd;
begin
  if Assigned(FOnChildProcessEnd) then
    OnChildProcessEnd(Self)
end;

procedure TCustomVirtualRedirector.DoErrorInput(NewErrorInput: string);
begin
  if Assigned(FOnErrorInput) then
    FOnErrorInput(Self, NewErrorInput)
end;

procedure TCustomVirtualRedirector.DoInput(NewInput: string);
begin
  if Assigned(FOnInput) then
    FOnInput(Self, NewInput)
end;

function TCustomVirtualRedirector.GetChildProcessHandle: THandle;
begin
  Result := FProcessInfo.hProcess
end;

function TCustomVirtualRedirector.GetChildProcessID: Longword;
begin
  Result := FProcessInfo.dwProcessId
end;

function TCustomVirtualRedirector.GetChildProcessThread: THandle;
begin
  Result := FProcessInfo.hThread
end;

function TCustomVirtualRedirector.GetChildThreadID: Longword;
begin
  Result := FProcessInfo.dwThreadId
end;

procedure TCustomVirtualRedirector.HelperWndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_NCCREATE:
      Message.Result := 1;
    WM_NEWINPUT:
      begin
        DoInput(string(PChar(Message.wParam)));
        FreeMem(PChar(Message.wParam))
      end;
    WM_CHILDPROCESSCLOSE:
      begin
        FillChar(FProcessInfo, SizeOf(ProcessInfo), #0);
        KillThreads;
        CloseHandles;
        FRunning := False;
        DoChildProcessEnd;
      end;
  end
end;

procedure TCustomVirtualRedirector.Kill;
begin
  // NOTE:  Calling Kill forces the Process to die using TerminateProcess.
  //        In Win9x this usually leaves the 16 bit wrapper "WinOldApp" running
  //        in the task list.  If this process is orphaned Win9x will not shut
  //        down.  It is best to use the correct input to the child process to
  //        cause it to terminate itself
  if Running and (FProcessInfo.hProcess <> 0) then
    TerminateProcess(FProcessInfo.hProcess, 0);
end;

procedure TCustomVirtualRedirector.KillThreads;
begin
  if Assigned(PipeThread) then
    if not PipeThread.Terminated then
    begin
      PipeThread.Terminate;
      while not PipeThread.Finished do
        Sleep(100);
      PipeThread.Free;
      PipeThread := nil;
    end;

  if Assigned(ProcessTerminateThread) then
  begin
    if not ProcessTerminateThread.Finished then
    begin
      ProcessTerminateThread.SetTriggerEvent;
      while not ProcessTerminateThread.Finished do
        Sleep(100);
    end;
      ProcessTerminateThread.Free;
      ProcessTerminateThread := nil;
  end
end;

function TCustomVirtualRedirector.Run(FileName, InitialDirectory: WideString; Parameters: WideString = ''): Boolean;
var
  StartupInfoA: _STARTUPINFOA;
  StartupInfoW: _STARTUPINFOW;
  szDirectoryA: PChar;
  szDirectoryW: PWideChar;
  SecAttr: TSecurityAttributes;
  PipeChildIn, PipeChildOut, PipeChildErrorOut: THandle;
  FileNameA, InitialDirectoryA, ParametersA: string;
  TempWideCharFile, TempWideCharParams: PWideChar;
  TempCharFile, TempCharParams: PChar;
begin
  Result := False;
  if not Running then
  begin
    if FileExists(FileName) then
    begin
      PipeChildIn := 0;
      PipeChildOut := 0;
      try
        FillChar(StartupInfoW, SizeOf(StartupInfoW), #0);
        FillChar(StartupInfoA, SizeOf(StartupInfoA), #0);
        StartupInfoW.cb := SizeOf(StartupInfoW);
        StartupInfoA.cb := SizeOf(StartupInfoA);

        FillChar(FProcessInfo, SizeOf(ProcessInfo), #0);

        StartupInfoW.wShowWindow := SW_HIDE;    // Don't show the service on the screen

        // Create the Pipe handes as inheritable so we can give them to the
        // child process and we can close them
        SecAttr.nLength := SizeOf(SecAttr);
        SecAttr.lpSecurityDescriptor := nil;
        SecAttr.bInheritHandle := True;

        // Create output Pipe to the Child Process
        if not CreatePipe(PipeChildIn, FPipeOut, @SecAttr, 0) then
          raise Exception.Create(STR_CREATE_PIPE_ERROR);

        // Create the input Pipe from the Child Process
        if not CreatePipe(FPipeIn, PipeChildOut, @SecAttr, 0) then
          raise Exception.Create(STR_CREATE_PIPE_ERROR);

        // Create the input Error Pipe from the Child Process
        if not CreatePipe(FPipeErrorIn, PipeChildErrorOut, @SecAttr, 0) then
          raise Exception.Create(STR_CREATE_PIPE_ERROR);


        StartupInfoW.hStdOutput := PipeChildOut;
        StartupInfoW.hStdInput := PipeChildIn;
        StartupInfoW.hStdError := PipeChildErrorOut;
        StartupInfoW.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;

        if Win32Platform = VER_PLATFORM_WIN32_NT then
        begin
          if InitialDirectory = '' then
            szDirectoryW := nil
          else
            szDirectoryW := PWideChar( InitialDirectory);

          // Sending a nil is NOT equal to sending PWideChar(FileName) if FileName = '';
          if FileName = '' then
            TempWideCharFile := nil
          else
            TempWideCharFile := PWideChar( FileName);

          if Parameters = '' then
            TempWideCharParams := nil
          else
            TempWideCharParams := PWideChar( Parameters);

          // Note that fInheritHandles must be true so the process is just
          // increasing the reference count to the passed handles.  That mean we
          // must close them here to release our count on them.
          if not CreateProcessW(TempWideCharFile, TempWideCharParams, nil, nil, True, 0,
            nil, szDirectoryW, StartupInfoW, FProcessInfo)
          then
            raise Exception.Create(STR_SHELLPROCESSCREATEERROR);
        end else
        begin
          StartupInfoA.hStdInput := StartupInfoW.hStdInput;
          StartupInfoA.hStdOutput := StartupInfoW.hStdOutput;
          StartupInfoA.hStdError := StartupInfoW.hStdError;
          StartupInfoA.wShowWindow := StartupInfoW.wShowWindow;
          StartupInfoA.dwFlags := StartupInfoW.dwFlags;

          InitialDirectoryA := InitialDirectory;
          ParametersA := Parameters;
          FileNameA := FileName;

          if InitialDirectoryA = '' then
            szDirectoryA := nil
          else
            szDirectoryA := PChar(InitialDirectoryA);

          // Sending a nil is NOT equal to sending PWideChar(FileName) if FileName = '';
          if FileNameA = '' then
            TempCharFile := nil
          else
            TempCharFile := PChar( FileNameA);

          if ParametersA = '' then
            TempCharParams := nil
          else
            TempCharParams := PChar( ParametersA);

          // Note that fInheritHandles must be true so the process is just
          // increasing the reference count to the passed handles.  That mean we
          // must close them here to release our count on them.
          if not CreateProcess(TempCharFile, TempCharParams, nil, nil, True, 0,
            nil, szDirectoryA, StartupInfoA, FProcessInfo)
          then
            raise Exception.Create(STR_SHELLPROCESSCREATEERROR);
        end;

        // We can now close our references to the ends of the pipe the child owns
        CloseAndZeroHandle(PipeChildIn);
        CloseAndZeroHandle(PipeChildOut);
        CloseAndZeroHandle(PipeChildErrorOut);

        PipeThread := TPipeThread.Create(True);
        PipeThread.PipeIn := PipeIn;
        PipeThread.PipeErrorIn := PipeErrorIn;
        PipeThread.MessageWnd := HelperWnd;
        PipeThread.Resume;
        ProcessTerminateThread := TProcessTerminateThread.Create(True);
        ProcessTerminateThread.MessageWnd := HelperWnd;
        ProcessTerminateThread.ChildProcess := ChildProcessHandle;
        ProcessTerminateThread.Resume;

        FRunning := True
      except
        CloseHandles;
        CloseAndZeroHandle(PipeChildOut);
        CloseAndZeroHandle(PipeChildIn);
        CloseAndZeroHandle(PipeChildErrorOut);
      end
    end else
      raise Exception.Create(STR_INVALIDAPPLICATIONFILE + FileName);
  end
end;

procedure TCustomVirtualRedirector.Write(Command: string);
var
  BytesWritten, BytesToWrite: Cardinal;
begin
  if Running then
  begin
    if Length(Command) > 2 then
    begin
      if (Command[Length(Command)-1] <> #10) and (Command[Length(Command)] <> #13) then
        Command := Command + LineFeed
    end;
    BytesToWrite := Length(Command);
    WriteFile(PipeOut, PChar(Command)^, BytesToWrite, BytesWritten, nil);
    if BytesWritten <> BytesToWrite then
      raise Exception.Create(STR_ERRORWRITINGINPIPE);
  end
end;

{ TVirtualCommandLineRedirector }

procedure TVirtualCommandLineRedirector.CarrageReturn;
begin
  Write(LineFeed);
end;

procedure TVirtualCommandLineRedirector.ChangeDir(NewDir: string);
var
  Allow: Boolean;
begin
  Allow := True;
  DoChangeDir(NewDir, Allow);
  if Allow then
  begin
    Write('cd ' + NewDir + LineFeed);
  end;
end;

procedure TVirtualCommandLineRedirector.DoChangeDir(NewDir: string; var Allow: Boolean);
begin
  if Assigned(FOnDirChange) then
    FOnDirChange(Self, NewDir, Allow)
end;

function TVirtualCommandLineRedirector.FormatData(Data: string): string;
begin
  if Data <> '' then
  begin
    // The ANSI convert will be the same size buffer
    OEMToChar(PChar(Data), PChar(Data));
    Trim( string(Data));
    Result := AdjustLineBreaks( string(Data));
  end else
    Result := ''
end;

procedure TVirtualCommandLineRedirector.Write(Command: string);
begin
  // We need watch for some special commands that we must handle differently
  if Pos('xcopy', LowerCase(Command)) > 0 then
  begin
  // xcopy is a separate executable that the command shell will launch.  The
  // redirection doess not work well with child new processes launched from our
  // child process so do it ourselves.
    raise Exception.Create(STR_XCOPYRUNERROR);
  end else
    inherited Write(Command);
end;

{ TProcessTeminateThread }

procedure TProcessTerminateThread.Execute;
var
  Handles: TWOHandleArray;
begin
  try
    try
      Handles[0] := TriggerEvent;
      Handles[1] := ChildProcess;
      WaitForMultipleObjects(2, @Handles, False, INFINITE)
    finally
      PostMessage(MessageWnd, WM_CHILDPROCESSCLOSE, 0, 0);
    end
  except
    // don't let any exceptions escape the thread
  end
end;

{ TPipeThread }

procedure TPipeThread.Execute;
var
  AvailableBytes, BytesRead: Cardinal;
  Mem: PChar;
begin
  while not Terminated do
  try
    Sleep(250);
    if PeekNamedPipe(PipeIn, nil, 0, nil, @AvailableBytes, nil) then
    begin
      if PeekNamedPipe(PipeIn, nil, 0, nil, @AvailableBytes, nil) then
      begin
        if AvailableBytes > 0 then
        begin
          Mem := AllocMem(AvailableBytes + 1);
          if ReadFile(PipeIn, Mem^, AvailableBytes, BytesRead, nil) then
            PostMessage(MessageWnd, WM_NEWINPUT, Integer(Mem), 0);
        end
      end;
      if PeekNamedPipe(PipeErrorIn, nil, 0, nil, @AvailableBytes, nil) then
      begin
        if AvailableBytes > 0 then
        begin
          Mem := AllocMem(AvailableBytes + 1);
          if ReadFile(PipeErrorIn, Mem^, AvailableBytes, BytesRead, nil) then
            PostMessage(MessageWnd, WM_NEWINPUT, Integer(Mem), 0);
        end
      end
    end
  except
    // don't let any exceptions escape the thread
  end
end;

procedure TPipeThread.Terminate;
begin
  inherited Terminate;
  SetTriggerEvent;
end;

end.
