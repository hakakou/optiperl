unit HKNetwork;

interface
uses winsock,sysutils,registry,windows,classes;

function HasTcp:Boolean;
function AddrInet(i: DWORD): string;
function MyIpAddress:String;
Function GetNetworkComputers(Sl : TStrings) : Boolean;


implementation
/////////////////////////
function EnumResources(sl : TStrings; ResScope, ResType, ResUsage: DWORD; hNetEnum: THandle): UINT; forward;

function OpenEnum(const NetContainerToOpen: PNetResource;
                         ResScope, ResType, ResUsage: DWORD): THandle;
var
  hNetEnum: THandle;
begin
  Result := 0;
  if (NO_ERROR <> WNetOpenEnum(ResScope, ResType, ResUsage,
                               NetContainerToOpen, hNetEnum)) then
    exit
  else
    Result := hNetEnum;
end;

Function Open_Do_Close_Enum(const sl : TStrings;
                                    ResScope, ResType, ResUsage: DWORD;
                                    const NetContainerToOpen: PNetResource) : boolean;
var
  hNetEnum: THandle;
begin
  result:=false;
  hNetEnum := OpenEnum(NetContainerToOpen, ResScope, ResType, ResUsage);
  if (hNetEnum = 0) then exit;
  EnumResources(sl, ResScope, ResType, ResUsage, hNetEnum);
  if (NO_ERROR <> WNetCloseEnum(hNetEnum)) then exit;
  result:=true;
end;

function EnumResources(sl : TStrings; ResScope, ResType, ResUsage: DWORD; hNetEnum: THandle): UINT;
const
  RESOURCE_BUF_ENTRIES = 2000;
var
  ResourceBuffer: array[1..RESOURCE_BUF_ENTRIES] of TNetResource;
  i,
  ResourceBuf,
  EntriesToGet: DWORD;
  s:string;
begin
  Result := 0;
  while TRUE do begin
    ResourceBuf := sizeof(ResourceBuffer);
    EntriesToGet := RESOURCE_BUF_ENTRIES;

    if (NO_ERROR <> WNetEnumResource(hNetEnum,
                                     EntriesToGet,
                                     @ResourceBuffer,
                                     ResourceBuf)) then begin
      case GetLastError() of
        NO_ERROR:
          // Drop out of the switch, walk the buffer
          break;
        ERROR_NO_MORE_ITEMS:
          // Return with 0 code because this only happens when we got
          //   RESOURCE_BUF_ENTRIES entries on the previous call to
          //   WNetEnumResource, and there were coincidentally exactly
          //   RESOURCE_BUF_ENTRIES entries total in the enum at the time of
          //   that previous call
          exit;
      else
        Result := 1;
        exit;
      end;
    end;

    for i := 1 to EntriesToGet do
    begin
     s:=string(TNetResource(ResourceBuffer[i]).lpRemoteName);
     if (pos('//',s)=1) or (pos('\\',s)=1) then
      sl.add(s);
      if (ResourceBuffer[i].dwUsage and RESOURCEUSAGE_CONTAINER) <> 0 then
        Open_Do_Close_Enum(sl, ResScope, ResType, ResUsage, @ResourceBuffer[i]);
    end;

  end;
end;

Function GetNetworkComputers(Sl : TStrings) : Boolean;
var
  ResScope,
  ResType,
  ResUsage: DWORD;
begin
 ResScope := RESOURCE_GLOBALNET;
 //RESOURCE_REMEMBERED;
 //RESOURCE_CONNECTED;
 ResType := RESOURCETYPE_DISK;
 //RESOURCETYPE_ANY;
 //RESOURCETYPE_PRINT;
 ResUsage := RESOURCEUSAGE_CONTAINER;
 //RESOURCEUSAGE_CONNECTABLE;

 result:=Open_Do_Close_Enum(sl,ResScope, ResType, ResUsage, NIL);
end;

//////////////////////////

function AddrInet(i: DWORD): string;
var
  r: record a, b, c, d: Byte end absolute i;
begin
  Result := InttoStr(r.a)+'.'+InttoStr(r.b)+'.'+InttoStr(r.c)+'.'+InttoStr(r.d);
end;

function MyIpAddress:String;
const
  bufsize=255;
var
  buf: pointer;
  ip : DWORD;
  RemoteHost : PHostEnt; (* No, don't free it! *)
begin
  buf:=NIL;
  try
    getmem(buf,bufsize);
    try
     winsock.gethostname(buf,bufsize);   (* this one maybe without domain *)
     RemoteHost:=Winsock.GetHostByName(buf);
    except
     on exception do RemoteHost:=nil;
    end;
    if RemoteHost=NIL then
      ip:=winsock.htonl($07000001)  (* 127.0.0.1 *)
    else
      ip:=longint(pointer(RemoteHost^.h_addr_list^)^);
  finally
    if buf<>NIL then  freemem(buf,bufsize);
  end;
  result:=AddrInet((ip));
end;


function HasTcp:Boolean;
var
 Registro      : TRegistry;
 Lista         : TStrings;
begin
 Result := FALSE;
 Registro         := TRegistry.Create(KEY_QUERY_VALUE);
 Lista            := TStringList.Create;
 try
  Registro.RootKey := HKEY_LOCAL_MACHINE;
  try
   if Registro.OpenKey('\Enum\Network\MSTCP',FALSE) then
   begin
    Registro.GetKeyNames(Lista);
    Result:=(Lista.Count > 0);
   end;
  except
  end;
 finally
  Lista.Free;
  Registro.Free;
 end;
end;


end.
 