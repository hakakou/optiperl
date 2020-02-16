unit ProxyMdl;

interface

uses
  SysUtils, Classes, ScktComp,DIPcre,HyperStr,syncobjs,hakageneral;

type
  TOnRequest = Procedure(sender : TObject; Var header : String) of object;
  TOnResponse = Procedure(sender : TObject; Var Header,CustomResponse : String) of object;

  TServerThread = class(TServerClientThread)
  Private
    HostPcre,CLPcre : TDIPcre;
    Request : String;
    Client : TClientSocket;
    Procedure ProcessRequest;
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketWrite(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientLookup(Sender: TObject; Socket: TCustomWinSocket);
  protected
    FOnRequest : TOnRequest;
    FOnResponse : TOnResponse;
    procedure ClientExecute; override;
  public
    constructor Create(CreateSuspended: Boolean; ASocket: TServerClientWinSocket);
    destructor Destroy; override;
  end;

  TProxyMod = class(TDataModule)
    Server: TServerSocket;
    procedure ServerGetThread(Sender: TObject;
      ClientSocket: TServerClientWinSocket;
      var SocketThread: TServerClientThread);
  public
    OnRequest : TOnRequest;
    OnResponse : TOnResponse;
  end;

var
  ProxyMod: TProxyMod;

implementation
{$R *.dfm}

var
 CS : TCriticalSection;

{ TServerThread }

procedure TServerThread.ClientExecute;
const
 buf = 100;
var
  Stream : TWinSocketStream;
  Buffer : string;
  s:string;
  i,cl,j:integer;
begin
  while (not Terminated) and ClientSocket.Connected do
  begin
    try
      Stream := TWinSocketStream.Create(ClientSocket, 10000);
      try
        s:='';
        setlength(buffer,buf);
        if Stream.WaitForData(60000) then
        begin
         cl:=1;
         repeat
          i:=Stream.Read(Buffer[1], buf);
          if i = 0 then
          begin
           ClientSocket.Close;
           break;
          end;
          s:=s+copy(buffer,1,i);

          j:=pos(#13#10#13#10,s);
          if j=0 then
          begin
           j:=pos(#10#10,s);
           if j<>0 then inc(j,1);
          end
           else inc(j,3);

          cl:=1;

          if j<>0 then
          begin
           //found end of header
           if clPcre.Match(s)<>2 then break;
           //no content length? we are finished
           cl:=StrToInt(clPcre.SubStrings[1]);
           cl:=cl-(length(s)-j);
           //content length=written - what we already have
           if cl<=0 then break;
           repeat
            j:=Stream.Read(Buffer[1], buf);
            dec(cl,j);
            s:=s+copy(buffer,1,j);
           until (cl<=0) or (not Stream.WaitForData(5000));
          end;
         until (cl<=0) or (not Stream.WaitForData(2000));

         if (ClientSocket.Connected) then
         begin
           Request:=s;
           try
            if not terminated then
             ProcessRequest;
           except on exception do
            if ClientSocket.Connected then ClientSocket.Close;
           end;

          end;
        end
        else
          ClientSocket.Close; { if client doesn't start, close }
      finally
        Stream.Free;
      end;
    except
      HandleException;
    end;
  end;
end;

constructor TServerThread.Create(CreateSuspended: Boolean;
  ASocket: TServerClientWinSocket);
begin
 inherited Create(CreateSuspended,ASocket);
 CLPcre:=TDIPcre.CreateWithPattern(nil,'content-length:\s+(\d+)');
 HostPcre:=TDIPcre.CreateWithPattern(nil,'Host:\s+([^\x0d\x0a]+)');

 Client:=TClientSocket.Create(nil);
// Client.OnRead:=ClientSocketRead;
// Client.OnWrite:=ClientSocketWrite;
// Client.OnDisconnect:=ClientSocketDisconnect;
// Client.OnLookup:=ClientLookup;
// Client.OnConnect:=ClientConnect;
 Client.OnError:=ClientSocketError;

 Client.Port:=80;
 client.ClientType:=ctBlocking;
end;

destructor TServerThread.Destroy;
begin
 CLPcre.Free;
 HostPcre.free;
 Client.Close;
 client.free;
 inherited Destroy;
end;

procedure TServerThread.ProcessRequest;
const
 buf = 100;
var
  Stream : TWinSocketStream;
  Buffer,temp : string;
  cl,i,j,p,s:integer;
  GotHeader : boolean;
  Header,custom : string;
begin
 if assigned(FOnRequest) then
 begin
  cs.Enter;
  FOnRequest(self,Request);
  cs.Leave;
 end;

 if terminated then exit;

 if hostPcre.Match(request)<>2 then
 begin
  if clientsocket.Connected then
   ClientSocket.SendText('HTTP/1.0 200 OK'+#13#10+'Content-type: text/html'+#13#10#13#10+'Cannot find host!');
  ClientSocket.Close;
  exit;
 end;

 if terminated then exit;

 j:=length(request);
 if j=0 then exit;
 p:=1;
 setlength(buffer,buf);

 Client.host:=hostpcre.SubStrings[1];
 Client.Open;
 if not client.Socket.Connected then exit;
 Stream:=TWinSocketStream.Create(Client.Socket,60000);
 Stream.TimeOut:=60000;
 try
  repeat
   if client.Socket.Connected
    then i:=stream.Write(request[p],imin(j,buf))
    else break;
   dec(j,i);
   inc(p,i);
  until (j<=0) or (terminated);

  GotHeader:=false;
  Header:='';
  cl:=-1;

  if Stream.WaitForData(60000) then
   repeat
    if client.Socket.Connected
     then i:=Stream.Read(Buffer[1], buf)
     else break;

    if not GotHeader then
    begin
     Header:=Header+copy(buffer,1,i);
     p:=pos(#13#10#13#10,Header); s:=4;
     if p=0 then begin s:=2; p:=pos(#10#10,header); end;
     if p=0 then begin s:=4; p:=pos(#10#13#10#13,Header); end;

     if p<>0 then
     begin
      GotHeader:=true;
      temp:=copyFromToEnd(header,p);
      SetLength(header,p-1);

      if CLPcre.Match(header)=2 then
      begin
       cl:=StrToInt(clpcre.SubStrings[1]);
       dec(cl,length(temp)-s);
      end;

      //Header:=Header+#13#10+'Proxy-connection: Close';
      if assigned(FOnResponse) then
      begin
       custom:='';
       cs.Enter;
       FOnResponse(self,Header,custom);
       cs.Leave;
      end;
      if custom=''
       then
        begin
         if clientsocket.Connected then clientsocket.SendText(header+temp)
        end
       else
        begin
         if clientsocket.Connected then ClientSocket.SendText(custom);
         break;
        end;
     end;
    end
     else
      begin
       if clientsocket.Connected then ClientSocket.SendText(copy(buffer,1,i));
       dec(cl,i);
      end;
    sleep(1);
   until ((cl<=0) and (i=0)) or (terminated);
 finally
  stream.free;
  if client.Socket.Connected then
   Client.Close;
 end;

 if clientsocket.Connected then
  ClientSocket.Close;
end;

procedure TServerThread.ClientSocketWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
end;

procedure TServerThread.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
end;

procedure TServerThread.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 ErrorCode:=0;
end;

procedure TServerThread.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
end;

procedure TServerThread.ClientLookup(Sender: TObject; Socket: TCustomWinSocket);
begin
end;

procedure TServerThread.ClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
end;

procedure TProxyMod.ServerGetThread(Sender: TObject;
  ClientSocket: TServerClientWinSocket;
  var SocketThread: TServerClientThread);
begin
 socketthread:=TServerThread.Create(true,ClientSocket);
 with SocketThread as TServerThread do
 begin
  FOnRequest:=OnRequest;
  FOnResponse:=OnResponse;
  resume;
 end;
end;

initialization
 CS:=TCriticalSection.Create
finalization
 CS.Free;
end.
