unit HakaThread;
{.$DEFINE DEBUG}

interface
uses classes,windows,sysutils,syncobjs,forms,extctrls;

 const MaxT = 10;

 type
  THKThreadList = class;
  THKThread = class;

  TOnThreadStatus =
   procedure(Thread: THKThread; const status : string) of object;

  THKThread = class(TThread)
  private
   FID : Integer;
   FThreadList : THKThreadList;
   FNextUpdate:string;
   procedure DoUpdate;
   procedure UpdateStatus(const Status: string);
  protected
   procedure Execute; override;
   Procedure TheJob(data : Pointer); Virtual;
   Constructor Create(AThreadList : THKThreadList; AID : Integer);
  public
   procedure DoSync(Method: TThreadMethod);
  published
   property ThreadList : THKThreadList read FThreadList;
   property ThreadID : Integer read FID;
   property Status : String read FNextUpdate write UpdateStatus;
  end;

  THKThreadList = class(TList)
  Private
   FOnThreadStatus : TOnThreadStatus;
   Procedure SetMax(max : Integer);
  protected
   TheMax : Integer;
   queue : TList;
   Function CreateThreadClass(AThreadList : THKThreadList; AID : Integer) : THKThread ; Virtual;
  public
   constructor Create(OnThreadStatus : TOnThreadStatus);
   Destructor Destroy; override;
   procedure Start;
   procedure Stop;
   Procedure AddJob(Data: Pointer);
  published
   property MaxThreads : Integer read TheMax write SetMax;
  end;

var
 CSJob : TCriticalSection;

implementation

procedure THKThreadList.AddJob(Data: Pointer);
begin
 queue.Add(data);
end;

Procedure THKThreadList.Start;
var
 i:integer;
begin
 for i:=0 to count-1 do
  THKThread(items[i]).Resume;
end;

Procedure THKThreadList.Stop;
var
 i:integer;
begin
 for i:=0 to count-1 do
  THKThread(Items[i]).Suspend;
end;


constructor THKThreadList.Create(OnThreadStatus : TOnThreadStatus);
var
 i:integer;
begin
 inherited create;
 CSJob:=TCriticalSection.Create;
 TheMax:=MaxT;
 Queue:=TList.Create;
 FOnThreadStatus:=OnThreadStatus;
 for i:=0 to TheMax-1 do
  add(CreateThreadClass(self,i));
end;

destructor THKThreadList.Destroy;
var i:integer;
begin
 queue.Free;
 CSJob.free;
 inherited destroy;
end;

{ THKThread }

constructor THKThread.Create(AThreadList: THKThreadList; AID : Integer);
begin
 FreeOnTerminate:=true;
 FID:=AID;
 FThreadList:=AThreadList;
 inherited create(true);
end;

procedure THKThread.Execute;
var
 Data : Pointer;
begin
 repeat
  CSJob.Enter;
  if FThreadList.queue.Count>0 then
  begin
   data:=FThreadList.queue.Items[0];
   FThreadList.queue.Delete(0);
   CSJob.Leave;
   try
    Thejob(data);
   except
    on exception do
   end;
  end
   else
    CSJob.Leave;
  sleep(5);
 until (FThreadList.TheMax-1<Fid);

 CSJob.Enter;
 while FId <> FThreadList.Count -1 do
 begin
  CSJob.Leave;
  sleep(5);
  csjob.Enter;
 end;
 FThreadList.Delete(FID);
 csjob.Leave;

end;

procedure THKThreadList.SetMax(max: Integer);
var i:integer;
begin
 if Themax=max then exit;
 if Max>count then
  for i:=1 to max-count do
   add(createThreadClass(self,count-1));
 TheMax:=Max;
end;

procedure THKThread.UpdateStatus(const Status: string);
begin
 FNextUpdate:=Status;
 synchronize(doUpdate);
end;

procedure THKThread.DoUpdate;
begin
 if assigned(FThreadList.FOnThreadStatus) then
  FThreadList.FOnThreadStatus(self,FNextUpdate);
end;


procedure THKThread.DoSync(Method: TThreadMethod);
begin
 Synchronize(method);
end;

procedure THKThread.TheJob(Data : Pointer);
begin
 //enter job
end;

function THKThreadList.CreateThreadClass(AThreadList: THKThreadList;
  AID: Integer): THKThread;
begin
 result:=THKThread.Create(AThreadList,AID);
 //replace the above with new class
end;

end.
