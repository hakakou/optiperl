unit PacketSniffer;

interface
uses messages,sysutils,jwaWinSock2,WinSock,windows;


type
 TSessionAvailable = procedure (Sender: TObject; Socket: TSocket) of object;
 TSessionConnected = procedure (Sender: TObject; Socket: TSocket) of object;
 TDataAvailable = procedure (Sender: TObject; Socket: TSocket) of object;
 TSessionClosed = procedure (Sender: TObject; Socket: TSocket) of object;

 TPacketSniffer = Class
 private
  FHandle : THandle;
  FDataAvailable: TDataAvailable;
  FSessionClosed: TSessionClosed;
  FSessionAvailable: TSessionAvailable;
  FSessionConnected: TSessionConnected;
  RawSocket: TSocket;
 public
  Sniffing : Boolean;
  constructor create(MessageHandle : THandle);
  Procedure Sniff(const AIP : String);
  Procedure ProcessAsyncSelectMessage(var msg: TMessage);
  Procedure Stop;
 public
  property OnSessionAvailable: TSessionAvailable read FSessionAvailable write FSessionAvailable;
  property OnSessionConnected : TSessionConnected read FSessionConnected write FSessionConnected;
  property OnDataAvailable : TDataAvailable read FDataAvailable write FDataAvailable;
  property OnSessionClosed : TSessionClosed read FSessionClosed write FSessionClosed;
 end;

const
  WM_ASYNCSELECT = WM_USER + 0;

implementation

const
  IP_HDRINCL = 2;
  SIO_RCVALL = $98000001;

{ TPacketSniffer }

constructor TPacketSniffer.create(MessageHandle : THandle);
begin
 FHandle:=MessageHandle;
end;

procedure TPacketSniffer.ProcessAsyncSelectMessage(var msg: TMessage);
begin
  case LoWord(msg.lParam) of
    FD_READ:
     if Assigned(FDataAvailable) then  FDataAvailable(Self,msg.wParam);
    FD_CLOSE:
      if Assigned(FSessionClosed) then   FSessionClosed(Self,msg.wParam);
    FD_ACCEPT:
      if Assigned(FSessionAvailable) then   FSessionAvailable(Self,msg.wParam);
    FD_CONNECT:
      if Assigned(FSessionConnected) then  FSessionConnected(Self,msg.wParam);
  end;
end;

procedure TPacketSniffer.Sniff(const AIP: String);
Var
  WSAData: TWSAData;
  rcvtimeo, result: Integer;
  sHost:string;
  hostent: Phostent;
  ip: ^integer;
  sa: TSockAddr;
  dwBufferInLen, dwBytesReturned, dwBufferOutLen: DWORD;
Begin
  Sniffing:=false;
  WSAStartup(MakeWord(2, 2), WSAData);

  Try
    RawSocket := socket(AF_INET, SOCK_RAW, IPPROTO_IP);

    If RawSocket = INVALID_SOCKET Then
      Raise Exception.Create('INVALID_SOCKET');

    rcvtimeo := 5000;
    result := setsockopt(RawSocket, SOL_SOCKET, SO_RCVTIMEO, pchar(@rcvtimeo), sizeof(rcvtimeo));
    If result = SOCKET_ERROR Then
      Raise Exception.Create('SetSocket failed');

    shost:=AIP;
    hostent := gethostbyname(pchar(shost));
    ip := @hostent.h_addr_list^[0];

    sa.sin_family := AF_INET;
    sa.sin_port := htons(7000);
    sa.sin_addr.s_addr := ip^;


    result := bind(RawSocket, sa, sizeof(sa));
    If result = SOCKET_ERROR Then
      Raise Exception.Create('bind failed');

    dwBufferInLen:=1;
    dwBufferOutLen:=0;
    result := WSAIoctl(RawSocket, SIO_RCVALL, @dwBufferInLen,
      sizeof(dwBufferInLen), @dwBufferOutLen, sizeof(dwBufferOutLen),
      dwBytesReturned, Nil, Nil);
    If result <> SOCKET_ERROR Then
    begin
     result := WSAASyncSelect(RawSocket,Fhandle,WM_ASYNCSELECT,FD_READ);
     if result <> 0 then
      begin
       closesocket(RawSocket);
       WSACleanup;
      end
     else
      Sniffing:=true;
    end;
  Except
    closesocket(RawSocket);
    WSACleanup;
  End;
end;

procedure TPacketSniffer.Stop;
begin
 Sniffing:=false;
 WSAASyncSelect(RawSocket,FHandle,WM_ASYNCSELECT,0);
 WSACleanUp;
end;

end.
