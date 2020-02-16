unit HttpProxy; //Unit

interface

uses
  Windows, Messages, SysUtils, Classes, ScktComp, wininet,
  IdTCPClient, IdTCPServer, IdMappedPortTCP, IdGlobal, IdStack,
  DIPcre;


type
  TConnectionStatus = (csNoHostYet, csHostFound);

  TOnProxyLog = Procedure(Sender : TObject; Const Log : String) of object;

  THKMappedPortTCPData = class
  public
    OutboundClient: TIdTCPClient;
    ReadList: TList;
    HeaderDone : Boolean;
    PageData: string;
    ConnectionStatus: TConnectionStatus;
    constructor Create;
    destructor Destroy; override;
  end;


  THKMappedPortTCP = class(TIdTCPServer)
  private
    PCre : TDIPcre;
    function GetHostFromHeader(header: string): string;
  protected
    FMappedPort: integer;
    FMappedHost: string;
    FOnLog : TOnProxyLog;
    procedure DoConnect(AThread : TIdPeerThread); override;
    function DoExecute(AThread : TIdPeerThread): boolean; override;
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
  published
    property MappedHost: string read FMappedHost write FMappedHost;
    property MappedPort: integer read FMappedPort write FMappedPort;
  end;

  Procedure SetHTTPProxy(Enable : Boolean; OnLog: TOnProxyLog);
  Function IsHTTPProxyEnabled : Boolean;

implementation
var
 Mapped : THKMappedPortTCP = nil;

Function IsHTTPProxyEnabled : Boolean;
begin
 result:=(assigned(Mapped) and (mapped.active));
end;

Procedure SetHTTPProxy(Enable : Boolean; OnLog: TOnProxyLog);
var
  inf: INTERNET_PROXY_INFO;
begin
 if Enable then
 begin
  // this block of code redirects the browser to point to a proxy
  // server on port 8081.
  inf.dwAccessType := INTERNET_OPEN_TYPE_PROXY;
  inf.lpszProxy := 'localhost:8081';
  inf.lpszProxyBypass := nil;
  InternetSetOption(nil, INTERNET_OPTION_PROXY, @inf, sizeof(inf));
  if not assigned(mapped) then
  begin
   mapped:=THKMappedPortTCP.Create(nil);
   Mapped.FonLog:=OnLog;
   mapped.DefaultPort:=8081;
   mapped.MappedPort:=8080;
   mapped.Active:=true;
  end;
 end
  else
 begin
  inf.dwAccessType := INTERNET_OPEN_TYPE_DIRECT;
  inf.lpszProxy := nil;
  inf.lpszProxyBypass := nil;
  InternetSetOption(nil, INTERNET_OPTION_PROXY, @inf, sizeof(inf));
  if assigned(mapped) then
  begin
   mapped.Active:=false;
   FreeAndNil(mapped);
  end;
 end;
end;


{ THKMappedPortTCP }

constructor THKMappedPortTCP.Create(AOwner: TComponent);
begin
 inherited Create(Aowner);
 Pcre:=TDIPCre.Create(nil);
 Pcre.MatchPattern:='(?:\x0a|\x0d)Host:\s+([^\s\x0d\x0a]+)'
end;

destructor THKMappedPortTCP.Destroy;
begin
 pcre.free;
 inherited;
end;

procedure THKMappedPortTCP.DoConnect(AThread: TIdPeerThread);
var
  LData: THKMappedPortTCPData;
begin
  inherited;
  LData := THKMappedPortTCPData.Create;
  AThread.Data := LData;
  LData.OutboundClient := TIdTCPClient.Create(nil);
  LData.ConnectionStatus := csNoHostYet;
  LData.OutboundClient.Port := MappedPort;
  LData.HeaderDone:=false;
end;

function THKMappedPortTCP.DoExecute(AThread : TIdPeerThread): boolean;
var
  LData: THKMappedPortTCPData;
  host: string;
  Port : Integer;
  buffer,temp: string;
  i:integer;
  obj : TObject;
begin
  result := true;
  LData := THKMappedPortTCPData(AThread.Data);
  try
    with LData.ReadList do begin
      Clear;
      Add(TObject(AThread.Connection.Socket.Binding.Handle));
      if assigned(LData.OutboundClient.Socket) then
       if LData.OutboundClient.Socket.Binding.Handle > 0 then
        Add(TObject(LData.OutboundClient.Socket.Binding.Handle));

      if GStack.WSSelect(LData.ReadList, nil, nil, IdTimeoutInfinite) > 0 then begin
        //TODO Make a select list that also has a function to check of handles
        if IndexOf(TObject(AThread.Connection.Socket.Binding.Handle)) > -1 then
        begin
          buffer := AThread.Connection.CurrentReadBuffer;

          temp:=Trim(buffer);
          if (temp<>'') and (assigned(FOnLog)) then
           FOnLog(self,'*REQUEST*'+#13#10+trim(temp)+#13#10#13#10);

          // Buffer the outgoing request until we see a Host: mydomain.com line.
          // Once we have that, then we can tell the outgoing client where
          // to send the request.
          if LData.ConnectionStatus = csNoHostYet then
          begin
            LData.PageData := LData.PageData + buffer;

            host := GetHostFromHeader(LData.PageData);
            i:=Pos(':',host);
            if i>0 then
             begin
              port:=StrToIntDef(copy(host,i+1,length(host)),80);
              setlength(host,i-1);
             end
            else
             port:=80;

            if host <> '' then
            begin
              mapped.MappedPort:=port;
              LData.OutboundClient.Host := host;
              LData.OutboundClient.Port:=port;

              {TODO Handle connect failures}
              try
               LData.OutboundClient.Connect;
              except
               on exception do
               begin
                if assigned(FOnLog) then
                 FOnLog(self,'*RESPONSE from '+host+'*'#13#10+'<Cannot connect to '+host+'>'+#13#10#13#10#13#10);
                //raise;
                abort;
               end;
              end;
              LData.OutboundClient.Write(LData.PageData);
              LData.ConnectionStatus := csHostFound;
              LData.PageData := '';
            end;
          end
          else
            LData.OutboundClient.Write(buffer);
        end;

        try
         obj:=TObject(LData.OutboundClient.Socket.Binding.Handle);
         //al.ortiz@bcms.org.txt
        except
         obj:=nil;
        end;

        if IndexOf(obj) >= 0 then
        begin
         buffer:=LData.OutboundClient.CurrentReadBuffer;
         AThread.Connection.Write(buffer);

          if not LData.headerDone then
          begin
           i:=Pos(#13#10#13#10,buffer);
           if i=0 then i:=Pos(#10#10,buffer);
           if i=0 then i:=Pos(#10#13#10#13,buffer);
           if i=0 then i:=Pos(#13#13,buffer);
           if i=0 then i:=length(buffer);
           dec(i);
           if i>=0 then setLength(buffer,i);
           if assigned(FOnLog) then
            FOnLog(self,'*RESPONSE from '+LData.OutboundClient.Host+'*'+#13#10+buffer+#13#10#13#10#13#10);
           LData.HeaderDone:=true;
          end;
        end;

      end;
    end;

  finally
    if (not LData.OutboundClient.Connected) and (LData.ConnectionStatus <> csNoHostYet) then begin
      AThread.Connection.Disconnect;
    end;
  end;
end;

// Extract the host name from the header sent by the browser.
function ThkMappedPortTCP.GetHostFromHeader(header: string): string;
begin
 if Pcre.MatchStr(header)=2
  then result:=trim(pcre.SubStr(1))
  else result:='';
end;

{ THKMappedPortTCPData }

constructor THKMappedPortTCPData.Create;
begin
  ReadList := TList.Create;
end;

destructor THKMappedPortTCPData.Destroy;
begin
  FreeAndNil(ReadList);
  FreeAndNil(OutboundClient);
  inherited;
end;

end.