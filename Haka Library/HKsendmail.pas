unit HKSendMail;

interface

uses
  sysutils,Classes,Psock, NMsmtp,forms,windows;

type

  TOnCanSendNextMail =
   function(PostMessage:TPostMessage; var SmtpTag : Integer) : Boolean of object;

  TOnThreadStatus =
   procedure(Sender : TObject; const status : string) of object;

  TOnThreadFinished =
   procedure(Sender : TObject) of object;

  TSendMailThread = class(TThread)
  private
    LastStatus : string;
    procedure SendStatus;
    procedure OnSMTPStatus(Sender: TComponent; Status: String);
  protected
    procedure Execute; override;
  public
    smtp : TNMSMTP;
    FOnCanSendNextMail : TOnCanSendNextMail;
    FOnStatus : TOnThreadStatus;
    FOnThreadFinished : TOnThreadFinished;
    constructor Create(const Host,UserID : string;
                       OnCanSendNextMail : TOnCanSendNextMail;
                       OnStatus : TOnThreadStatus;
                       OnThreadFinished : TOnThreadFinished);
    destructor Destroy; override;
  end;

  TGetEmailNum = function(var EmailNum : Integer; PostMessage : TPostMessage): Boolean of object;
  TOnSetResult = procedure(EmailNum : Integer;  Success : Boolean; const SMTP : TNMSMTP) of object;

  TMassMailer = Class
  private
   TickStart : Cardinal;
   FOnEmail : Integer;
   FGetEmailNum : TGetEmailNum;
   FOnSetResult : TOnSetResult;
   procedure OnStatus(Sender : TObject; const Status: string);
   function OnNewMail(PostMessage: TPostMessage;
         var SmtpTag: Integer): Boolean;
   procedure OnThreadFinished(Sender : TObject);
   procedure OnSuccess(Sender : TObject);
   procedure OnFailure(Sender : TObject);
  public
   MSecPerEmail : Real;
   SendThreads : TStrings;
   constructor Create(GetEmailNum : TGetEmailNum; OnSetResult : TOnSetResult);
   Destructor Destroy; override;
   procedure AddMailer(const Host,UserId : string);
   procedure RemoveMailer;
  end;

implementation

var
 CS : TRTLCriticalSection;

constructor TSendMailThread.Create;
begin
 inherited Create(true);
 FOnCanSendNextMail:=OnCanSendNextMail;
 FOnStatus:=OnStatus;
 FOnThreadFinished:=OnThreadFinished;
 FreeOnTerminate:=True;
 Smtp:=TNMSMTP.Create(nil);
 SMTP.UserID:=UserID;
 SMTP.host:=Host;
 SMTP.OnStatus:=OnSMTPStatus;
 SMtp.reportlevel:=2;
end;

destructor TSendMailThread.Destroy;
begin
 EnterCriticalSection(CS);
 if SMTP.Connected then
  SMTP.Disconnect;
 SMTP.Free;
 if Assigned(FOnThreadFinished) then FOnThreadFinished(Self);
 inherited Destroy;
 Sleep(50);
 LeaveCriticalSection(CS);
end;

procedure TSendMailThread.OnSMTPStatus(Sender: TComponent; Status: String);
begin
 LastStatus:=Trim(Status)+' - '+IntToStr(SMTP.Tag);
 Synchronize(SendStatus);
end;

procedure TSendMailThread.Execute;
var
 t:integer;
begin
 smtp.Connect;
 repeat
  if not Assigned(FOnCanSendNextMail) then Exit;

  EnterCriticalSection(CS);
  if FOnCanSendNextMail(SMTP.PostMessage,t) then
  begin
   SMTP.Tag:=t;
   Sleep(10);
   LeaveCriticalSection(CS);
   SMTP.SendMail;
  end
   else
  begin
   Sleep(10);
   LeaveCriticalSection(CS);
   break;
  end;

 until Terminated;
end;

procedure TSendMailThread.SendStatus;
begin
 if Assigned(FOnStatus) then FOnStatus(Self,LastStatus);
end;


{ TMassMailer }

procedure TMassMailer.AddMailer(const Host, UserId: string);
var
 tm : TSendMailThread;
begin
 Tm:=TSendMailThread.Create(host,userid,OnNewMail,
                          OnStatus,OnThreadFinished);
 tm.smtp.OnSuccess:=OnSuccess;
 tm.smtp.OnFailure:=OnFailure;
 Tm.Resume;
 SendThreads.AddObject('Initializing...',tm);
end;

constructor TMassMailer.Create;
begin
 inherited Create;
 FGetEmailNum:=GetEmailNum;
 FOnEmail:=1;
 FOnSetResult:=OnSetResult;
 TickStart:=GetTickCount;
 MSecPerEmail:=0;
 initializeCriticalSection(CS);
end;

destructor TMassMailer.Destroy;
begin
 DeleteCriticalSection(CS);
 inherited Destroy;
end;

procedure TMassMailer.OnFailure(Sender: TObject);
begin
 if Assigned(FOnSetResult)
  then FONSetResult(TNMSMTP(Sender).Tag,False,TNMSMTP(Sender));
end;

procedure TMassMailer.OnSuccess(Sender: TObject);
begin
 MSecPerEmail:=(GetTickCount-TickStart) / FonEmail;
 if Assigned(FOnSetResult)
  then FONSetResult(TNMSMTP(Sender).Tag,True,TNMSMTP(Sender));
end;

function TMassMailer.OnNewMail(PostMessage: TPostMessage;
  var SmtpTag: Integer): Boolean;
begin
 Inc(FOnEmail);
 if Assigned(FGetEmailNum)
  then Result:=FGetEmailNUm(SmtpTag,PostMessage)
  else Result:=False;
end;

procedure TMassMailer.OnStatus(Sender : TObject; const Status: String);
var i:integer;
begin
 i:=SendThreads.IndexOfObject(Sender);
 if i<>-1 then SendThreads[i]:=Status;
end;


procedure TMassMailer.OnThreadFinished(Sender : TObject);
var i:integer;
begin
 i:=SendThreads.IndexOfObject(Sender);
 if i<>-1 then SendThreads.Delete(i);
end;

procedure TMassMailer.RemoveMailer;
begin
 with SendThreads do
  TSendMailThread(SendThreads[Count-1]).terminate;
end;

end.
