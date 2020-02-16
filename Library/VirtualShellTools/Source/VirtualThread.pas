unit VirtualThread;

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, VirtualUtilities;

type
  TVirtualThread = class
  private
    FFreeOnTerminate: Boolean;
    FHandle: THandle;
    FThreadID: THandle;
    FStub: pointer;
    FTerminated: Boolean;
    FSuspended: Boolean;
    FFinished: Boolean;
    FEvent: THandle;
    FCriticalSectionInitialized: Boolean;
    FCriticalSection: TRTLCriticalSection;
    FRefCount: Integer;
    function GetPriority: TThreadPriority;
    procedure SetPriority(const Value: TThreadPriority);
    procedure SetSuspended(const Value: Boolean);
    procedure ExecuteStub;  stdcall;
    function GetTriggerEvent: THandle;
    function GetLock: TRTLCriticalSection;
  protected
    procedure Execute; virtual; abstract;

    procedure FinalizeThread; virtual;
    procedure InitializeThread; virtual;
    property CriticalSectionInitialized: Boolean read FCriticalSectionInitialized write FCriticalSectionInitialized;
    property Event: THandle read FEvent write FEvent;
    property Stub: pointer read FStub write FStub;
    property Terminated: Boolean read FTerminated;

  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;

    procedure AddRef;
    procedure Release;
    procedure Resume;
    procedure SetTriggerEvent;
    procedure Terminate; virtual;

    property Finished: Boolean read FFinished;
    property FreeOnTerminate: Boolean read FFreeOnTerminate write FFreeOnTerminate;
    property Handle: THandle read FHandle;
    property Lock: TRTLCriticalSection read GetLock;
    property Priority: TThreadPriority read GetPriority write SetPriority;
    property RefCount: Integer read FRefCount write FRefCount;
    property Suspended: Boolean read FSuspended write SetSuspended;
    property ThreadID: THandle read FThreadID;
    property TriggerEvent: THandle read GetTriggerEvent;
  end;

implementation

{ TVirtualThread }

procedure TVirtualThread.AddRef;
begin
  InterlockedIncrement(FRefCount);
end;

constructor TVirtualThread.Create(CreateSuspended: Boolean);
var
  Flags: DWORD;
begin
  IsMultiThread := True;
  Stub := CreateStub(Self, @TVirtualThread.ExecuteStub);
  Flags := 0;
  if CreateSuspended then
  begin
    Flags := CREATE_SUSPENDED;
    FSuspended := True
  end;
  FHandle := CreateThread(nil, 0, Stub, nil, Flags, FThreadID);  
end;

destructor TVirtualThread.Destroy;
begin
  DisposeStub(Stub);
  if Handle <> 0 then
    CloseHandle(Handle);
  if Event <> 0 then
    CloseHandle(Event);
  if CriticalSectionInitialized then
    DeleteCriticalSection(FCriticalSection);
  inherited; 
end;

procedure TVirtualThread.ExecuteStub;
// Called in the context of the thread 
begin
  try
    InitializeThread;
    try
      Execute
    except
    end
  finally
    FinalizeThread;
    FFinished := True;
    if FreeOnTerminate then
      Free;
    ExitThread(0);
  end
end;

function TVirtualThread.GetLock: TRTLCriticalSection;
begin
  if not CriticalSectionInitialized then
    InitializeCriticalSection(FCriticalSection);
  Result := FCriticalSection
end;

function TVirtualThread.GetPriority: TThreadPriority;
var
  P: Integer;
begin
  Result := tpNormal;
  P := GetThreadPriority(FHandle);
  case P of
    THREAD_PRIORITY_IDLE:          Result := tpIdle;
    THREAD_PRIORITY_LOWEST:        Result := tpLowest;
    THREAD_PRIORITY_BELOW_NORMAL:  Result := tpLower;
    THREAD_PRIORITY_NORMAL:        Result := tpNormal;
    THREAD_PRIORITY_HIGHEST:       Result := tpHigher;
    THREAD_PRIORITY_ABOVE_NORMAL:  Result := tpHighest;
    THREAD_PRIORITY_TIME_CRITICAL: Result := tpTimeCritical;
  end
end;

function TVirtualThread.GetTriggerEvent: THandle;
begin
  if Event = 0 then
    Event := CreateEvent(nil, True, False, nil);
  Result := Event;
end;

procedure TVirtualThread.FinalizeThread;
begin

end;

procedure TVirtualThread.InitializeThread;
begin

end;

procedure TVirtualThread.Release;
begin
  InterlockedDecrement(FRefCount);
end;

procedure TVirtualThread.Resume;
begin
  Suspended := False
end;

procedure TVirtualThread.SetPriority(const Value: TThreadPriority);
begin
begin
  case Value of
    tpIdle        : SetThreadPriority(Handle,  THREAD_PRIORITY_IDLE);
    tpLowest      : SetThreadPriority(Handle, THREAD_PRIORITY_LOWEST);
    tpLower       : SetThreadPriority(Handle, THREAD_PRIORITY_BELOW_NORMAL);
    tpNormal      : SetThreadPriority(Handle, THREAD_PRIORITY_NORMAL);
    tpHigher      : SetThreadPriority(Handle, THREAD_PRIORITY_HIGHEST);
    tpHighest     : SetThreadPriority(Handle, THREAD_PRIORITY_ABOVE_NORMAL);
    tpTimeCritical: SetThreadPriority (Handle, THREAD_PRIORITY_TIME_CRITICAL);
  end
end;
end;

procedure TVirtualThread.SetSuspended(const Value: Boolean);
begin
  if FSuspended <> Value then
  begin
    if Handle <> 0 then
    begin
      if Value then
        SuspendThread(FHandle)
      else
        ResumeThread(FHandle);
      FSuspended := Value;
    end
  end
end;

procedure TVirtualThread.SetTriggerEvent;
begin
  SetEvent(TriggerEvent);
end;

procedure TVirtualThread.Terminate;
begin
  FTerminated := True
end;

end.
