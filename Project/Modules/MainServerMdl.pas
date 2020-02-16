unit MainServerMdl;  //Module

interface

uses
  SysUtils,Classes,ScktComp, hyperstr,windows,ServerMdl,hakawin, hakageneral,
  DIPcre;

type

  TStatusEvent = procedure(Sender : TObject; const Status : String) of object;

  TServerThread = class(TServerClientThread)
  private
    Function DoRequest(Stream : TWinSocketStream) : boolean;
  protected
    FStr : String;
    FEvent : TStatusEvent;
    Procedure Sync;
    procedure ClientExecute; override;
  public
    CLPcre : TDIPcre;
    srv : TServerMod;
    Procedure DoSync(const str : String; Event : TStatusEvent);
    destructor Destroy; override;
  end;


  TMainServerMod = class(TDataModule)
    Server: TServerSocket;
    procedure ServerGetThread(Sender: TObject;
      ClientSocket: TServerClientWinSocket;
      var SocketThread: TServerClientThread);
    procedure ServerClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    Progs : TStringList;
    procedure KillProgs;
  public
    OnServerStatus : TStatusEvent;
    OnClientRequest,OnServerResponse : TStatusEvent;
    Procedure Start;
    Procedure Stop;
    Function Running : Boolean;
  end;

var
  MainServerMod: TMainServerMod;

implementation

uses
  Dialogs;

{$R *.dfm}

{ TServerThread }

Function TServerThread.DoRequest(Stream : TWinSocketStream) : Boolean;
const
 buf = 128;
var
  Buffer : string;
  s:string;
  i,cl,j:integer;
  en : boolean;
  sl : TStringList;
begin
 s:='';
 setlength(buffer,buf);
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
   else
    inc(j,3);

   cl:=1;

   if j<>0 then
   begin
    //found end of header
    if clPcre.MatchStr(s)<>2 then
     break;

    //no content length? we are finished
    cl:=StrToInt(clPcre.SubStr(1));
    cl:=cl-(length(s)-j);
    //content length=written - what we already have
    if cl<=0 then break;

    repeat
     if clientSocket.Connected then
      j:=Stream.Read(Buffer[1], buf)
     else
      begin
       cl:=-1;
       break;
      end;
     dec(cl,j);
     s:=s+copy(buffer,1,j);
    until (cl<=0) or (not Stream.WaitForData(5000));

   end;

 until (cl<=0) or (not Stream.WaitForData(5000));

 if (result) and (ClientSocket.Connected) then
  srv.ServerClientRead(s,ClientSocket);
end;

procedure TServerThread.ClientExecute;
var
  Stream : TWinSocketStream;
  Error : Boolean;
  s:string;
  i:integer;
begin
  Error:=false;
  while (not Terminated) and ClientSocket.Connected and (not error) do
  begin
    try
      Stream := TWinSocketStream.Create(ClientSocket, 10000);
      try
       if Stream.WaitForData(10000)
        then DoRequest(stream);
      finally
       clientsocket.Close;
       Stream.Free;
      end;
    except
      on exception do
       Error:=true;
    end;
  end;
end;

destructor TServerThread.Destroy;
begin
 Srv.Free;
 CLPcre.Free;
 inherited Destroy;
end;


procedure TMainServerMod.ServerGetThread(Sender: TObject;
  ClientSocket: TServerClientWinSocket;
  var SocketThread: TServerClientThread);
begin
 socketthread:=TServerThread.Create(true,ClientSocket);
 with SocketThread as TServerThread do
 begin
  CLPcre:=TDIPcre.Create(nil);
  CLPcre.MatchPattern:='content-length:\s+(\d+)';
  srv:=TServerMod.create(nil);
  srv.OnServerStatus:=OnServerStatus;
  srv.OnClientRequest:=OnClientRequest;
  srv.OnServerResponse:=OnServerResponse;
  srv.Refresh;
  Srv.thread:=SocketThread;
  resume;
 end;
end;

function TMainServerMod.Running: Boolean;
begin
 result:=Server.Active;
end;

procedure TMainServerMod.Start;
begin
 try
  Server.open;
 except
  on exception do
  begin
   KillProgs;
   try
    server.Open;
   except
    on exception do
     MessageDlg('Could not start internal server.'+#13+#10+'Make sure that no other web servers are running on port '+inttostr(server.Port)+'.', mtError, [mbOK], 0);
   end;
  end;
 end;
 if assigned(OnServerStatus) then OnServerStatus(nil,'Ready');
end;

procedure TMainServerMod.Stop;
begin
 try
  server.Close;
 except end; // admin@approvedsparks.co.uk.elf
 if assigned(OnServerStatus) then OnServerStatus(nil,'Stopped');
end;

procedure TMainServerMod.ServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
 if assigned(OnServerStatus) then
  OnServerStatus(self,'Error: '+inttostr(ErrorCode));
 ErrorCode:=0;
end;

procedure TMainServerMod.DataModuleCreate(Sender: TObject);
var i,j:integer;
begin
 Rewrite:='';
 ServerName:='OptiPerl/4';
 Timeout:=5;
 IniFile:=ProgramPath+'Server.ini';
 ProgAssociations:='cgi=c:\perl\bin\perl.exe'+#13#10+
                   'pl=c:\perl\bin\perl.exe'+#13#10+
                   'plx=c:\perl\bin\perl.exe'+#13#10;

 Progs:=TStringList.create;
 Progs.Text:=ProgAssociations;
 for i:=0 to Progs.Count-1 do
 begin
  j:=pos('=',Progs[i]);
  Progs[i]:=extractfilename(copyfromtoend(progs[i],j+1));
 end;
end;

procedure TServerThread.DoSync(const str: String; Event: TStatusEvent);
begin
 FStr:=str;
 FEvent:=Event;
 try
  Synchronize(sync);
 except on exception do end;
end;

procedure TServerThread.Sync;
begin
 if assigned(FEvent) then FEvent(self,FStr);
end;

procedure TMainServerMod.KillProgs;
var i:integer;
begin
 for i:=0 to progs.count-1 do
  killallexenames(progs[i]);
end;

procedure TMainServerMod.DataModuleDestroy(Sender: TObject);
begin
 Stop;
 Progs.free;
end;

end.