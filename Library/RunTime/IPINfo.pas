{
  IPINFO v0.1

  Implements some classes to obtain informations
  about the network configuration and network adapters.
  Based on the work of http://www.whirlwater.com/

  This materia is provied "as is"
  without any warranty of any kind.

  By Leonardo Perria - 2003
  leoperria@tiscali.it

  Very poor implementation at the moment....be patient.
}

unit IPInfo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Contnrs, IPHelperDef;

  procedure GetNetworkParameters(Dest:TStrings);  // TODO: Da eliminare e integrare in TIPInfo

type

  TInfoIPAddress=class
  private
    FAddress:string;
    FNetmask:string;

  public
    constructor Create(Addr : PIPAddrString);
    destructor Destroy; override;
    property Address:string read FAddress;
    property Netmask:string read FNetmask;
    function asString() : string;
  end;


  TAdapter=class
  private
    FComboIndex: integer;
    FName: string;
    FDescription: string;
    FHWAddressLength : Integer;
    FHWAddress: string;
    FAIndex: integer;
    FAType: integer;  // see IPIfCons.H
    FDHCPEnabled: boolean;
    FCurrentIPAddress : TInfoIPAddress;
    FIPAddressList: TObjectList;
    FGatewayList : TObjectList;

    FDHCPServer : TInfoIPAddress;
    FHaveWINS : boolean;
    FPrimaryWINSServer : TInfoIPAddress;
    FSecondaryWINSServer : TInfoIPAddress;

//    LeaseObtained       : Integer;
//    LeaseExpires        : Integer;

    function GetIPAddress(index : integer) : TInfoIPAddress;
    function GetMaxIPAddresses() : integer;
    function GetGateway(index : integer) : TInfoIPAddress;
    function GetMaxGateways() : integer;

  public
    constructor Create(adapterInfo:PIPAdapterInfo);
    destructor Destroy; override;
    property Name: string read FName;
    property Description : string read FDescription;
    property ComboIndex : integer read FComboIndex;
    property HWAddressLength : Integer read FHWAddressLength;
    property HWAddress: string read FHWAddress;
    property AIndex: integer read FAIndex;
    property AType: integer read FAType;
    property DHCPEnabled: boolean read FDHCPEnabled;
    property CurrentIPAddress : TInfoIPAddress read FCurrentIPAddress;
    property IPAddresses[index : integer] : TInfoIPAddress read GetIPAddress;
    property MaxIPAddresses : integer read GetMaxIPAddresses;
    property Gateways[index : integer] : TInfoIPAddress read GetGateway;
    property MaxGateways : integer read GetMaxGateways;
    property DHCPServer : TInfoIPAddress read FDHCPServer;
    property HaveWINS : boolean read FHaveWINS;
    property PrimaryWINSServer : TInfoIPAddress read FPrimaryWINSServer;
    property SecondaryWINSServer : TInfoIPAddress read FSecondaryWINSServer;

  end;

  TIPInfo=class(TObject)
  private
    FAdapters: TObjectList;

    function getMaxAdapters(): integer;
    function GetAdapter(index:integer) : TAdapter;

  public
    Constructor Create;
    Destructor Destroy;override;
    property Adapters[index: Integer]: TAdapter read GetAdapter;
    property MaxAdapters:integer read getMaxAdapters;
  end;


implementation

constructor TInfoIPAddress.Create(Addr : PIPAddrString);
begin
  if Addr<>nil then begin
    FAddress:=Addr^.IPAddress;
    FNetmask:=Addr^.IPMask;
  end
  else begin
    FAddress:='';
    FNetmask:='';
  end;
end;

function TInfoIPAddress.asString() : string;
begin
  if (FAddress='') and (FNetmask='') then
    Result:=''
  else
    Result:=FAddress+'/'+FNetmask;
end;

destructor TInfoIPAddress.Destroy;
begin
  inherited;
end;


constructor TAdapter.Create(adapterInfo:PIPAdapterInfo);

  Function MACToStr(ByteArr : PByte; Len : Integer) : String;
  Begin
    Result := '';
    While (Len > 0) do Begin
      Result := Result+IntToHex(ByteArr^,2)+':';
      ByteArr := Pointer(Integer(ByteArr)+SizeOf(Byte));
      Dec(Len);
    End;
    SetLength(Result,Length(Result)-1); { remove last dash }
  End;

  procedure PopulateAddressList(Addr : PIPAddrString; List: TObjectList);
  begin
    List.Clear;
    While (Addr <> nil) do Begin
      List.Add(TInfoIPAddress.Create(Addr));
      Addr := Addr^.Next;
    End;
  end;

  { TODO: Implementare i LeaseTime

  Function TimeTToDateTimeStr(TimeT : Integer) : String;
  Const UnixDateDelta = 25569;
  Var
    DT  : TDateTime;
    TZ  : TTimeZoneInformation;
    Res : DWord;

  Begin
    If (TimeT = 0) Then Result := ''
    Else Begin

      DT := UnixDateDelta+(TimeT / (24*60*60));

      Res := GetTimeZoneInformation(TZ);
      If (Res = TIME_ZONE_ID_INVALID) Then RaiseLastOSError;
      If (Res = TIME_ZONE_ID_STANDARD) Then Begin
        DT := DT-((TZ.Bias+TZ.StandardBias) / (24*60));
        Result := DateTimeToStr(DT)+' '+WideCharToString(TZ.StandardName);
      End
      Else Begin
        DT := DT-((TZ.Bias+TZ.DaylightBias) / (24*60));
        Result := DateTimeToStr(DT)+' '+WideCharToString(TZ.DaylightName);
      End;
    End;
  End;
  }

begin
  FIPAddressList:=TObjectList.Create(True);
  FGatewayList:=TObjectList.Create(True);
  FName:=adapterInfo^.AdapterName;
  FDescription:=adapterInfo^.Description;
  FHWAddressLength:=adapterInfo^.AddressLength;
  FHWAddress:=MACToStr(@adapterInfo^.Address,adapterInfo^.AddressLength);
  FAIndex:=adapterInfo^.Index;
  FAType:=adapterInfo^._Type;
  if adapterInfo^.DHCPEnabled<>0 then FDHCPEnabled:=True else FDHCPEnabled:=False;
  FCurrentIPAddress:=TInfoIPAddress.Create(adapterInfo.CurrentIPAddress);
  PopulateAddressList(@adapterInfo^.IPAddressList,FIPAddressList);
  PopulateAddressList(@adapterInfo^.GatewayList,FGatewayList);
  FDHCPServer :=TInfoIPAddress.Create(@adapterInfo.DHCPServer);
  if adapterInfo^.HaveWINS then FHaveWINS:=True else FHaveWINS:=False;
  FPrimaryWINSServer:=TInfoIPAddress.Create(@adapterInfo.PrimaryWINSServer);
  FSecondaryWINSServer:=TInfoIPAddress.Create(@adapterInfo.SecondaryWINSServer);
end;

function TAdapter.GetIPAddress(index : integer) : TInfoIPAddress;
begin
  Result:=FIPAddressList.Items[index] as TInfoIPAddress;
end;

function TAdapter.GetMaxIPAddresses() : integer;
begin
  Result:=FIPAddressList.Count;
end;

function TAdapter.GetGateway(index : integer) : TInfoIPAddress;
begin
  Result:=FGatewayList.Items[index] as TInfoIPAddress;
end;

function TAdapter.GetMaxGateways() : integer;
begin
  Result:=FGatewayList.Count;
end;

destructor TAdapter.Destroy;
begin
  FCurrentIPAddress.Free;
  FIPAddressList.Free;
  FGatewayList.Free;
end;

constructor TIPInfo.Create;
Var
  AI,Work : PIPAdapterInfo;
  Size    : Integer;
  Res     : Integer;
  I       : Integer;
  adapter : TAdapter;
begin

  // Lista di adattatori
  FAdapters:=TObjectList.Create(True);
  Size := 5120;
  GetMem(AI,Size);
  Res := GetAdaptersInfo(AI,Size);
  If (Res <> ERROR_SUCCESS) Then Begin
    SetLastError(Res);
    RaiseLastOSError;
  End;
  Work := AI;
  Repeat
    adapter:=TAdapter.Create(Work);
    FAdapters.Add(adapter);
    Work := Work^.Next;
  Until (Work = nil);
  FreeMem(AI);

  inherited;
end;

destructor TIPInfo.Destroy;
begin
  FAdapters.Free;
  inherited;
end;

function TIPInfo.GetAdapter(index:integer) : TAdapter;
begin
  Result:=FAdapters.Items[index] as TAdapter;
end;

function TIPInfo.getMaxAdapters(): integer;
begin
  Result:=FAdapters.Count;
end;


procedure GetNetworkParameters(Dest:TStrings);
Var
  FI   : PFixedInfo;
  Size : Integer;
  Res  : Integer;
  I    : Integer;
  DNS  : PIPAddrString;

begin
  Size := 1024;
  GetMem(FI,Size);
  Res := GetNetworkParams(FI,Size);
  If (Res <> ERROR_SUCCESS) Then Begin
    SetLastError(Res);
    RaiseLastOSError;
  End;
  With Dest do Begin
    Clear;
    Add('Host name: '+FI^.HostName);
    Add('Domain name: '+FI^.DomainName);
    If (FI^.CurrentDNSServer <> nil) Then
      Add('Current DNS Server: '+FI^.CurrentDNSServer^.IPAddress)
    Else Add('Current DNS Server: (none)');
    I := 1;
    DNS := @FI^.DNSServerList;
    Repeat
      Add('DNS '+IntToStr(I)+': '+DNS^.IPAddress);
      Inc(I);
      DNS := DNS^.Next;
    Until (DNS = nil);
    Add('Scope ID: '+FI^.ScopeId);
    Add('Routing: '+IntToStr(FI^.EnableRouting));
    Add('Proxy: '+IntToStr(FI^.EnableProxy));
    Add('DNS: '+IntToStr(FI^.EnableDNS));
  End;
  FreeMem(FI);
end;

end.
