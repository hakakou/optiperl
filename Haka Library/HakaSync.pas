unit HakaSync;

interface
uses sysutils,Windows,Messages,classes;

Const
 SYNC_TIMEOUT = -1;
 SYNC_WAKEMASK = -2;

type
  TEventsSync = Class
  Private
   FCount : Integer;
   FEvents : array of Cardinal;
   FHandles : TWOHandleArray;
   FMutex : Cardinal;
  public
   Valid : Boolean;
   Constructor Create(Count : Integer; DoCreate,MutexAlso : Boolean; Const Prefix : String);
   Destructor Destroy; override;
   Procedure SetEvent(Index : Integer);
   Procedure ResetEvent(Index : Integer);
   Function EnterMutex(TimeOut : Cardinal) : Boolean;
   Procedure LeaveMutex;
   Function WaitAnyEvent(WaitFor : Array of Integer;
     TimeOut : Cardinal; WakeMask : Cardinal = 0) : Integer;
  end;

  
 TMainThreadExec = Class(TThread)
 private
  FMethod : TThreadMethod;
  FEvent : Cardinal;
 public
  Constructor Create(Method : TThreadMethod; out SignalEvent : Cardinal);
  Procedure Execute; override;
 end;

implementation

{ TMainThreadExec }

constructor TMainThreadExec.Create(Method: TThreadMethod; out SignalEvent: Cardinal);
begin
 FMethod:=Method;
 FEvent:=CreateEvent(Nil,false,false,PAnsiChar('XarkaSync'+inttostr(Integer(Self))));
 SignalEvent:=FEvent;
 FreeOnTerminate:=true;
 inherited create(false);
end;

procedure TMainThreadExec.Execute;
begin
 try
  Synchronize(FMethod);
 finally
  SetEvent(FEvent);
 end;
end;

constructor TEventsSync.Create(Count: Integer; DoCreate,MutexAlso: Boolean; Const Prefix : String);
var i:integer;
begin
 inherited create;
 FCount:=Count;
 SetLength(FEvents,FCount);

 If MutexAlso then
 begin
  if DoCreate
   then FMutex:=CreateMutex(nil,false,pchar(prefix))
   else FMutex:=OpenMutex(MUTEX_ALL_ACCESS,false,pchar(prefix));
  if FMutex=0 then
  begin
   valid:=false;
   exit;
  end;
 end;

 For i:=0 to FCount-1 do
  if DoCreate
   then FEvents[i]:=CreateEvent(Nil,false,false,Pchar(prefix+inttostr(i)))
   else FEvents[i]:=OpenEvent(EVENT_ALL_ACCESS,false,Pchar(prefix+inttostr(i)));

 Valid:=true;
 for i:=0 to FCount-1 do
  if FEvents[i]=0 then
   begin
    valid:=false;
    break;
   end;
end;

destructor TEventsSync.Destroy;
var
 i:integer;
begin
 for i:=0 to FCount-1 do
  if FEvents[i]<>0 then
   CloseHandle(FEvents[i]);
 if FMutex<>0 then
  CloseHandle(FMutex);
 inherited destroy;
end;

Function TEventsSync.EnterMutex(TimeOut : Cardinal) : Boolean;
begin
 result:=(FMutex=0) or (WaitForSingleObject(FMutex,Timeout) = WAIT_OBJECT_0);
end;

procedure TEventsSync.LeaveMutex;
begin
 if FMutex<>0 then
  releaseMutex(FMutex);
end;

procedure TEventsSync.ResetEvent(Index: Integer);
begin
 Windows.ResetEvent(FEvents[index]);
end;

procedure TEventsSync.SetEvent(Index: Integer);
begin
 Windows.SetEvent(FEvents[index]);
end;

function TEventsSync.WaitAnyEvent(WaitFor: array of Integer;
  TimeOut: Cardinal; WakeMask : Cardinal = 0): Integer;
var
 i:iNTEGER;
begin
 for i:=0 to length(waitfor)-1 do
  Fhandles[i]:=Fevents[waitfor[i]];
 if WakeMask=0
 then
  i:=WaitForMultipleObjects(length(waitfor),@FHandles,false,timeout)
 else
  i:=MsgWaitForMultipleObjects(length(waitfor),FHandles,false,timeout,WakeMask);

 if i=WAIT_TIMEOUT
  then result:=SYNC_TIMEOUT
 else
 if i=WAIT_OBJECT_0 + length(WaitFor) then
  result:=SYNC_WAKEMASK
 else
 if I<length(waitFor) then
  result:=waitfor[i]
 else
  begin
   i:=i-WAIT_ABANDONED_0;
   result:=waitfor[i];
  end;
end;


end.
