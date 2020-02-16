unit HKNetUses;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Mailslot,hyperstr;

type
  THKNetUses = class(TComponent)
  private
   FCounter : Integer;
   FMaxInstances : Integer;
   FOverrideInstances : TNotifyEvent;
   MyUniqueID : String;
   Timer:TTimer;
   Function GetUniqueId : string;
   procedure serverNewMessage(Sender: TObject);
  protected
   server: TMailslotServer;
   client: TMailslotClient;
  public
   Constructor Create(AOwner: TComponent); override;
   Destructor Destroy; override;
   procedure OnTimer(Sender: TObject);
  published
   property MaxInstances : integer read FMaxInstances write FMaxInstances;
   property OnOverrideInstances : TNotifyEvent read FOverrideInstances write FOverrideInstances;
  end;

procedure Register;

implementation

const RequestRunning = '*c*';

procedure THKNetUses.serverNewMessage(Sender: TObject);
var
 s : string;
 i:integer;
begin
 s:='';
 i:=Server.MessageSize;
 while i>0 do
 begin
  SetLength(s,i);
  server.ReadMessage(s[1],i);

  if (s=requestRunning)
   then timer.enabled:=true;
   else Inc(FCounter);

  if (FCounter>FMaxInstances) and (assigned(FOverrideInstances)) then
   FOverrideInstances(self);
 end;

end;

Function THKNetUses.GetUniqueId : string;
begin
 result:='\'+GetComputer+'\'+floattostr(Now);
end;

Constructor THKNetUses.Create(AOwner: TComponent);
var s:String;
begin
 inherited create(AOwner);
 FMaxInstances:=1;
 FCounter:=0;
 MyUniqueId:=GetUniqueID;
 if ComponentState=[] then
 begin
  Server:=TMailslotServer.Create(nil);
  server.OnNewMessage:=serverNewMessage;
  Server.MailslotName:='xar\file';
  server.Interval:=1000;
  server.InheritHandle:=false;
  server.MaxMessageSize:=0;
  server.MessagePolling:=true;
  server.ThreadPriority:=tpNormal;
  Client:=TMailSlotClient.Create(nil);
  client.MailslotName:='xar\file';
  Client.Receiver := rcPrimaryDomain;
  s:=requestRunning;
  Client.WriteMessage(s[1],length(s));
  timer:=TTimer.create(nil);
  Timer.enabled:=false;
  Timer.ontimer:=OnTimer;
 end;
end;

Destructor THKNetUses.Destroy;
begin
 if ComponentState=[] then
 begin
  Server.Free;
  Client.free;
  Timer.free;
 end;
 inherited destroy;
end;

procedure Register;
begin
  RegisterComponents('Haka', [THKNetUses]);
end;

procedure THKNetUses.OnTimer(Sender: TObject);
var s:string;
begin
 Timer.enabled:=false;
 s:=GetUniqueId;
 client.WriteMessage(s[1],length(s));
end;

end.
