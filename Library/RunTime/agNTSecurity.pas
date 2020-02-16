{*******************************************************}
{                                                       }
{       Alex Ghost Library                              }
{                                                       }
{       Copyright (c) 1999,2000 Alexey Popov            }
{                                                       }
{*******************************************************}

{$I AG.INC}
{$A-}

unit agNTSecurity;

interface

uses Windows, Classes;

type
  TWellKnown = dword;

  TAccessItem = class(TObject)
  public
    AceType: byte;
    AceFlags: byte;
    AceMask: dword;
    SID: PSID;
    function AccountName: string;
    function WellKnown: TWellKnown;
  end;

  TAccess = record
    AccType: byte;
    Dirs,Files: dword;
    UseFiles: boolean;
  end;

  TAccessList = class(TList)
  private
    function Get(const Index: integer): TAccessItem;
  public
    destructor Destroy; override;
    property Items[const Index: integer]: TAccessItem read Get; default;
    function IndexOfSID(SID: PSID): integer;
    function AddItemSID(AType, AFlags: byte; AMask: dword; ASID: PSID): integer;
    function AddItemWellKnown(AType, AFlags: byte; AMask: dword; WK: TWellKnown): integer;
    function AddItemName(AType, AFlags: byte; AMask: dword; const Name: string): integer;
    procedure AddSID(Access: TAccess; SID: PSID; CheckDup: boolean);
    procedure AddWellKnown(Access: TAccess; WK: TWellKnown; CheckDup: boolean);
    procedure AddName(Access: TAccess; const Name: string; CheckDup: boolean);
    procedure AddNames(Access: TAccess; Names: TStrings; CheckDup: boolean);
  end;

  TSubAuthoritiesArray = array [0..7] of dword;

  TSetPermsCallback = procedure(Path: string; StartOp, Failed: boolean;
    var Cancel: boolean);

const

  // ACE types
  atAllowed = 0;
  atDenied  = 1;

  // Standard access rights
  amNoAccess: TAccess   = (AccType: atDenied;
                           Dirs: GENERIC_ALL;
                           Files: GENERIC_ALL;
                           UseFiles: true);

  amList: TAccess       = (AccType: atAllowed;
                           Dirs: GENERIC_READ or GENERIC_EXECUTE;
                           Files: 0;
                           UseFiles: false);

  amRead: TAccess       = (AccType: atAllowed;
                           Dirs: GENERIC_READ or GENERIC_EXECUTE;
                           Files: GENERIC_READ or GENERIC_EXECUTE;
                           UseFiles: true);

  amAdd: TAccess        = (AccType: atAllowed;
                           Dirs: GENERIC_WRITE or GENERIC_EXECUTE;
                           Files: 0;
                           UseFiles: false);

  amReadWrite: TAccess  = (AccType: atAllowed;
                           Dirs: GENERIC_READ or GENERIC_WRITE or GENERIC_EXECUTE;
                           Files: GENERIC_READ or GENERIC_EXECUTE;
                           UseFiles: true);

  amChange: TAccess     = (AccType: atAllowed;
                           Dirs: GENERIC_READ or GENERIC_WRITE or GENERIC_EXECUTE or _DELETE;
                           Files: GENERIC_READ or GENERIC_WRITE or GENERIC_EXECUTE or _DELETE;
                           UseFiles: true);

  amFullAccess: TAccess = (AccType: atAllowed;
                           Dirs: GENERIC_ALL;
                           Files: GENERIC_ALL;
                           UseFiles: true);

  // ACE flags
  OBJECT_INHERIT_ACE         = 1;
  CONTAINER_INHERIT_ACE      = 2;
  NO_PROPAGATE_INHERIT_ACE   = 4;
  INHERIT_ONLY_ACE           = 8;
  VALID_INHERIT_FLAGS        = 15;

  // some ACE flags combinations
  afDirectories = CONTAINER_INHERIT_ACE;
  afFiles       = INHERIT_ONLY_ACE or OBJECT_INHERIT_ACE;

  // well-known SIDs
  wkNull                  = 0;
  wkWorld                 = 1;
  wkLocal                 = 2;
  wkCreatorOwner          = 3;
  wkCreatorGroup          = 3 + $100;
  wkNonUnique             = 4;

  wkNTAuthority           = 5;
  wkDialup                = 5 + $100;
  wkNetwork               = 5 + $200;
  wkBatch                 = 5 + $300;
  wkInteractive           = 5 + $400;
  wkService               = 5 + $600;
  wkAnonymous             = 5 + $700;

  wkLogon                 = 5 + $500;

  wkLocalSystem           = 5 + $1200;

  wkNTNonUnique           = 5 + $1500;

  wkBuiltInDomain         = 5 + $2000;

  wkDomainUserAdmin       = 5 + $2000 + $1f40000; // domain controller only
  wkDomainUserGuest       = 5 + $2000 + $1f50000; // domain controller only

  wkDomainGroupAdmins     = 5 + $2000 + $2000000; // domain controller only
  wkDomainGroupUsers      = 5 + $2000 + $2010000; // domain controller only
  wkDomainGroupGuests     = 5 + $2000 + $2020000; // domain controller only

  wkDomainAliasAdmins     = 5 + $2000 + $2200000;
  wkDomainAliasUsers      = 5 + $2000 + $2210000;
  wkDomainAliasGuests     = 5 + $2000 + $2220000;
  wkDomainAliasPowerUsers = 5 + $2000 + $2230000;
  wkDomainAliasAccountOps = 5 + $2000 + $2240000;
  wkDomainAliasSystemOps  = 5 + $2000 + $2250000;
  wkDomainAliasPrintOps   = 5 + $2000 + $2260000;
  wkDomainAliasBackupOps  = 5 + $2000 + $2270000;
  wkDomainAliasReplicator = 5 + $2000 + $2280000;

  // current ACL revision
  ACL_REVISION = 2;

  WellKnownNameMark: char = '*';

function CreateSID(IdAuthority: TSIDIdentifierAuthority; SubAuthorityCount: byte;
  SubAuthorities: TSubAuthoritiesArray): PSID;

function CreateWellKnownSID(AWK: TWellKnown): PSID;

function MakeAccess(AccType: byte; Dirs, Files: cardinal; UseFiles: boolean): TAccess;

function GetFileAccess(Path: string; AccessList: TAccessList): boolean;
function SetFileAccess(Path: string; AccessList: TAccessList): boolean;

function SetPermissions(Path: string; AccessList: TAccessList;
  ChangeFilePerms, RecursDirs: boolean; CallbackProc: TSetPermsCallback): boolean;

function IsAdminRights: boolean;

implementation

uses SysUtils, agFileFind, agFileUtils;

type
  TAceHeader = record
    AceType: byte;
    AceFlags: byte;
    AceSize: word;
  end;

  PAce = ^TAce;
  TAce = record
    Header: TAceHeader;
    Mask: ACCESS_MASK;
    SidStart: dword;
  end;

  TWellKnownRec = record
    WK: TWellKnown;
    Name: string;
  end;

  TAllocateAndInitializeSid = function(const pIdentifierAuthority: TSIDIdentifierAuthority;
    nSubAuthorityCount: Byte; nSubAuthority0, nSubAuthority1: DWORD;
    nSubAuthority2, nSubAuthority3, nSubAuthority4: DWORD;
    nSubAuthority5, nSubAuthority6, nSubAuthority7: DWORD;
    var pSid: Pointer): BOOL; stdcall;

  TLookupAccountSid = function(lpSystemName: PChar; Sid: PSID;
    Name: PChar; var cbName: DWORD; ReferencedDomainName: PChar;
    var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL; stdcall;

  TGetSidIdentifierAuthority = function(pSid: Pointer): PSIDIdentifierAuthority; stdcall;

  TGetSidSubAuthority = function(pSid: Pointer; nSubAuthority: DWORD): PDWORD; stdcall;

  TGetSidSubAuthorityCount = function(pSid: Pointer): PUCHAR; stdcall;

  TEqualSid = function(pSid1, pSid2: Pointer): BOOL; stdcall;

  TGetLengthSid = function(pSid: Pointer): DWORD; stdcall;

  TCopySid = function(nDestinationSidLength: DWORD;
    pDestinationSid, pSourceSid: Pointer): BOOL; stdcall;

  TLookupAccountName = function(lpSystemName, lpAccountName: PChar;
    Sid: PSID; var cbSid: DWORD; ReferencedDomainName: PChar;
    var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL; stdcall;

  TGetFileSecurity = function(lpFileName: PChar; RequestedInformation: SECURITY_INFORMATION;
    pSecurityDescriptor: PSecurityDescriptor; nLength: DWORD;
    var lpnLengthNeeded: DWORD): BOOL; stdcall;

  TGetSecurityDescriptorDacl = function(pSecurityDescriptor: PSecurityDescriptor;
    var lpbDaclPresent: BOOL; var pDacl: PACL; var lpbDaclDefaulted: BOOL): BOOL; stdcall;

  TGetAce = function(const pAcl: TACL; dwAceIndex: DWORD; var pAce: Pointer): BOOL; stdcall;

  TInitializeAcl = function(var pAcl: TACL; nAclLength, dwAclRevision: DWORD): BOOL; stdcall;

  TAddAce = function(var pAcl: TACL; dwAceRevision, dwStartingAceIndex: DWORD;
    pAceList: Pointer; nAceListLength: DWORD): BOOL; stdcall;

  TInitializeSecurityDescriptor = function(pSecurityDescriptor: PSecurityDescriptor;
    dwRevision: DWORD): BOOL; stdcall;

  TSetSecurityDescriptorDacl = function(pSecurityDescriptor: PSecurityDescriptor;
    bDaclPresent: BOOL; pDacl: PACL; bDaclDefaulted: BOOL): BOOL; stdcall;

  TSetFileSecurity = function(lpFileName: PChar; SecurityInformation: SECURITY_INFORMATION;
    pSecurityDescriptor: PSecurityDescriptor): BOOL; stdcall;

  TOpenProcessToken = function(ProcessHandle: THandle; DesiredAccess: DWORD;
    var TokenHandle: THandle): BOOL; stdcall;

  TGetTokenInformation = function(TokenHandle: THandle;
    TokenInformationClass: TTokenInformationClass; TokenInformation: Pointer;
    TokenInformationLength: DWORD; var ReturnLength: DWORD): BOOL; stdcall;

  TFreeSid = function(pSid: Pointer): Pointer; stdcall;

var
  AllocateAndInitializeSidProc: TAllocateAndInitializeSid;
  LookupAccountSidProc: TLookupAccountSid;
  GetSidIdentifierAuthorityProc: TGetSidIdentifierAuthority;
  GetSidSubAuthorityProc: TGetSidSubAuthority;
  GetSidSubAuthorityCountProc: TGetSidSubAuthorityCount;
  EqualSidProc: TEqualSid;
  GetLengthSidProc: TGetLengthSid;
  CopySidProc: TCopySid;
  LookupAccountNameProc: TLookupAccountName;
  GetFileSecurityProc: TGetFileSecurity;
  GetSecurityDescriptorDaclProc: TGetSecurityDescriptorDacl;
  GetAceProc: TGetAce;
  InitializeAclProc: TInitializeAcl;
  AddAceProc: TAddAce;
  InitializeSecurityDescriptorProc: TInitializeSecurityDescriptor;
  SetSecurityDescriptorDaclProc: TSetSecurityDescriptorDacl;
  SetFileSecurityProc: TSetFileSecurity;
  OpenProcessTokenProc: TOpenProcessToken;
  GetTokenInformationProc: TGetTokenInformation;
  FreeSidProc: TFreeSid;

const
  AdvApi32Lib: THandle = 0;

  WellKnownArray: array [1..26] of TWellKnownRec = (
    (WK: wkWorld; Name: 'Everyone'),
    (WK: wkLocal; Name: 'Local'),
    (WK: wkCreatorOwner; Name: 'CreatorOwner'),
    (WK: wkCreatorGroup; Name: 'CreatorGroup'),
    (WK: wkDialup; Name: 'Dialup'),
    (WK: wkNetwork; Name: 'Network'),
    (WK: wkBatch; Name: 'Batch'),
    (WK: wkInteractive; Name: 'Interactive'),
    (WK: wkService; Name: 'Service'),
    (WK: wkAnonymous; Name: 'Anonymous'),
    (WK: wkLogon; Name: 'Logon'),
    (WK: wkLocalSystem; Name: 'System'),
    (WK: wkDomainUserAdmin; Name: 'Admin'),
    (WK: wkDomainUserGuest; Name: 'Guest'),
    (WK: wkDomainGroupAdmins; Name: 'DomainAdmins'),
    (WK: wkDomainGroupUsers; Name: 'DomainUsers'),
    (WK: wkDomainGroupGuests; Name: 'DomainGuests'),
    (WK: wkDomainAliasAdmins; Name: 'Admins'),
    (WK: wkDomainAliasUsers; Name: 'Users'),
    (WK: wkDomainAliasGuests; Name: 'Guests'),
    (WK: wkDomainAliasPowerUsers; Name: 'PowerUsers'),
    (WK: wkDomainAliasAccountOps; Name: 'AccountOps'),
    (WK: wkDomainAliasSystemOps; Name: 'SystemOps'),
    (WK: wkDomainAliasPrintOps; Name: 'PrintOps'),
    (WK: wkDomainAliasBackupOps; Name: 'BackupOps'),
    (WK: wkDomainAliasReplicator; Name: 'Replicator')
    );

{$IFNDEF D4}
  SECURITY_DESCRIPTOR_REVISION = 1;
{$ENDIF}


function CreateSID(IdAuthority: TSIDIdentifierAuthority; SubAuthorityCount: byte;
  SubAuthorities: TSubAuthoritiesArray): PSID;
begin
  Result:=nil;
  if AdvApi32Lib = 0 then exit;
  if not AllocateAndInitializeSidProc(IdAuthority,SubAuthorityCount,SubAuthorities[0],
    SubAuthorities[1],SubAuthorities[2],SubAuthorities[3],SubAuthorities[4],
    SubAuthorities[5],SubAuthorities[6],SubAuthorities[7],Result) then Result:=nil;
end;

function CreateWellKnownSID(AWK: TWellKnown): PSID;
var
  IdAuthority: TSIDIdentifierAuthority;
  SubAuthorityCount: byte;
  SubAuthorities: TSubAuthoritiesArray;
begin
  FillChar(SubAuthorities,SizeOf(SubAuthorities),0);
  FillChar(IdAuthority,SizeOf(IdAuthority),0);
  IdAuthority.Value[5]:=LoByte(LoWord(AWK));
  SubAuthorityCount:=1;
  SubAuthorities[0]:=HiByte(LoWord(AWK));
  SubAuthorities[1]:=HiWord(AWK);
  if SubAuthorities[1] <> 0 then inc(SubAuthorityCount);
  Result:=CreateSID(IdAuthority,SubAuthorityCount,SubAuthorities);
end;

function MakeAccess(AccType: byte; Dirs,Files: cardinal; UseFiles: boolean): TAccess;
begin
  Result.AccType:=AccType;
  Result.Dirs:=Dirs;
  Result.Files:=Files;
  Result.UseFiles:=UseFiles;
end;

function NameToWellKnown(const AName: string): TWellKnown;
var
  i: integer;
  s: string;
begin
  Result:=wkNull;
  i:=Pos(WellKnownNameMark,AName);
  if i > 0 then begin
    s:=Copy(AName,i+1,length(AName)-i);
    for i:=1 to High(WellKnownArray) do
      if CompareText(WellKnownArray[i].Name,s) = 0 then begin
        Result:=WellKnownArray[i].WK;
        break;
      end;
  end;
end;

{ TAccessItem }

function TAccessItem.AccountName: string;
var
  User,Dom: string;
  us,ds,use: dword;
begin
  Result:='';
  if AdvApi32Lib = 0 then exit;
  us:=0; ds:=0;
  LookupAccountSidProc(nil,SID,nil,us,nil,ds,use);
  SetLength(User,us);
  SetLength(Dom,ds);
  if LookupAccountSidProc(nil,SID,PChar(User),us,PChar(Dom),ds,use) then begin
    SetLength(User,us);
    SetLength(Dom,ds);
    Result:=Format('%s\%s',[Dom,User]);;
  end;
end;

function TAccessItem.WellKnown: TWellKnown;
var
  auth: PSIDIdentifierAuthority;
begin
  Result:=0;
  if AdvApi32Lib = 0 then exit;
  auth:=GetSidIdentifierAuthorityProc(SID);
  Result:=auth^.Value[5]+(GetSidSubAuthorityProc(SID,0)^ shl 8);
  if (Result = wkBuiltInDomain) and (GetSidSubAuthorityCountProc(SID)^ > 1) then
    inc(Result,(GetSidSubAuthorityProc(SID,1)^ shl 16));
end;

{ TAccessList }

destructor TAccessList.Destroy;
var
  i: integer;
begin
  for i:=Count-1 downto 0 do begin
//    FreeSidProc(Items[i].SID);
    freemem(Items[i].SID);
    Items[i].Free;
  end;
  inherited Destroy;
end;

function TAccessList.Get(const Index: integer): TAccessItem;
begin
  Result:=inherited Items[Index];
end;

function TAccessList.IndexOfSID(SID: PSID): integer;
var
  i: integer;
begin
  Result:=-1;
  if AdvApi32Lib = 0 then exit;
  for i:=0 to Count-1 do
    if EqualSidProc(Items[i].SID,SID) then begin
      Result:=i;
      break;
    end;
end;

function TAccessList.AddItemSID(AType, AFlags: byte; AMask: dword; ASID: PSID): integer;
var
  ai: TAccessItem;
  sidsize: integer;
begin
  Result:=-1;
  if AdvApi32Lib = 0 then exit;
  ai:=TAccessItem.Create;
  with ai do begin
    AceType:=AType;
    AceFlags:=AFlags;
    AceMask:=AMask;
    sidsize:=GetLengthSidProc(ASID);
    getmem(SID,sidsize);
    if not CopySidProc(sidsize,SID,ASID) then exit;
  end;
  Result:=Add(ai);
end;

function TAccessList.AddItemName(AType, AFlags: byte; AMask: dword;
  const Name: string): integer;
var
  ss,ds,use: dword;
  sid: PSID;
  Dom: string;
  wk: TWellKnown;
begin
  Result:=-1;
  if AdvApi32Lib = 0 then exit;
  wk:=NameToWellKnown(Name);
  if wk <> wkNull then
    Result:=AddItemWellKnown(AType,AFlags,AMask,wk)
  else begin
    ss:=0; ds:=0;
    LookupAccountNameProc(nil,PChar(Name),nil,ss,nil,ds,use);
    getmem(sid,ss);
    try
      SetLength(Dom,ds);
      if LookupAccountNameProc(nil,PChar(Name),sid,ss,PChar(Dom),ds,use) then
        Result:=AddItemSID(AType,AFlags,AMask,sid);
    finally
      freemem(sid);
    end;
  end;
end;

function TAccessList.AddItemWellKnown(AType, AFlags: byte; AMask: dword;
  WK: TWellKnown): integer;
var
  sid: PSID;
begin
  sid:=CreateWellKnownSID(WK);
  try
    Result:=AddItemSID(AType,AFlags,AMask,sid);
  finally
    FreeSidProc(sid);
  end;
end;

procedure TAccessList.AddSID(Access: TAccess; SID: PSID; CheckDup: boolean);
begin
  if CheckDup then
    if IndexOfSID(SID) <> -1 then exit;
  AddItemSID(Access.AccType,afDirectories,Access.Dirs,SID);
  if Access.UseFiles then
    AddItemSID(Access.AccType,afFiles,Access.Files,SID);
end;

procedure TAccessList.AddName(Access: TAccess; const Name: string; CheckDup: boolean);
var
  ss,ds,use: dword;
  sid: PSID;
  Dom: string;
  wk: TWellKnown;
begin
  if AdvApi32Lib = 0 then exit;
  wk:=NameToWellKnown(Name);
  if wk <> wkNull then
    AddWellKnown(Access,wk,CheckDup)
  else begin
    ss:=0; ds:=0;
    LookupAccountNameProc(nil,PChar(Name),nil,ss,nil,ds,use);
    getmem(sid,ss);
    try
      SetLength(Dom,ds);
      if LookupAccountNameProc(nil,PChar(Name),sid,ss,PChar(Dom),ds,use) then begin
        if CheckDup then
          if IndexOfSID(sid) <> -1 then exit;
        AddItemSID(Access.AccType,afDirectories,Access.Dirs,sid);
        if Access.UseFiles then
          AddItemSID(Access.AccType,afFiles,Access.Files,sid);
      end;
    finally
      freemem(sid);
    end;
  end;
end;

procedure TAccessList.AddNames(Access: TAccess; Names: TStrings; CheckDup: boolean);
var
  i: integer;
begin
  for i:=0 to Names.Count-1 do
    AddName(Access,Names[i],CheckDup);
end;

procedure TAccessList.AddWellKnown(Access: TAccess; WK: TWellKnown; CheckDup: boolean);
var
  sid: PSID;
begin
  sid:=CreateWellKnownSID(WK);
  try
    if CheckDup then
      if IndexOfSID(sid) <> -1 then exit;
    AddItemSID(Access.AccType,afDirectories,Access.Dirs,sid);
    if Access.UseFiles then
      AddItemSID(Access.AccType,afFiles,Access.Files,sid);
  finally
    FreeSidProc(sid);
  end;
end;

{ GetFileAccess }

function GetFileAccess(Path: string; AccessList: TAccessList): boolean;
var
  sd: pointer;
  size: dword;
  acl: PACL;
  ace: PAce;
  DaclPresent,DaclDef: LongBool;
  i: integer;
  serv: string;
begin
  Result:=false;
  if AdvApi32Lib = 0 then exit;
  AccessList.Clear;
  // find name of a remote computer
  serv:=ExpandUNCFileName(Path);
  if Copy(serv,1,2) = '\\' then begin
    Delete(serv,1,2);
    serv:=Copy(serv,1,Pos('\',serv)-1);
  end else
    serv:='';
  // get file security descriptor size
  GetFileSecurityProc(PChar(Path),DACL_SECURITY_INFORMATION,nil,0,size);
  getmem(sd,size);
  try
    // get file security information (DACL)
    if not GetFileSecurityProc(PChar(Path),DACL_SECURITY_INFORMATION,sd,size,size) then exit;
    // get DACL from security descriptor
    if not GetSecurityDescriptorDaclProc(sd,DaclPresent,acl,DaclDef) then exit;
    if not DaclPresent then exit;
    if Assigned(acl) then
      // add information from ACEs to AccessList
      for i:=0 to acl^.AceCount-1 do
        if GetAceProc(acl^,i,pointer(ace)) then
          with ace^ do
            AccessList.AddItemSID(Header.AceType,Header.AceFlags,Mask,@SidStart);
    Result:=true;
  finally
    freemem(sd);
  end;
end;

{ SetFileAccess }

function SetFileAccess(Path: string; AccessList: TAccessList): boolean;
var
  sd: PSecurityDescriptor;
  acl: PACL;
  aclsize,acesize: cardinal;
  ace: PAce;
  i: integer;
begin
  Result:=false;
  if AdvApi32Lib = 0 then exit;
  // calculate ACL size
  aclsize:=sizeof(TACL);
  for i:=0 to AccessList.Count-1 do
    inc(aclsize,sizeof(TACE)+GetLengthSidProc(AccessList[i].SID)-sizeof(DWORD));
  // create new ACL
  getmem(acl,aclsize);
  // create new security descriptor
  new(sd);
  try
    // init ACL
    if not InitializeAclProc(acl^,aclsize,ACL_REVISION) then exit;
    // fill ACL 
    for i:=0 to AccessList.Count-1 do
      with AccessList[i] do begin
        // create ACE
        acesize:=sizeof(TACE)+GetLengthSidProc(SID)-sizeof(DWORD);
        getmem(ace,acesize);
        try
          with PAce(ace)^ do begin
            // fill ACE
            Header.AceType:=AceType;
            Header.AceFlags:=AceFlags;
            Header.AceSize:=acesize;
            Mask:=AceMask;
            if not CopySidProc(GetLengthSidProc(SID),@SidStart,SID) then exit;
          end;
          // add ACE to ACL
          if not AddAceProc(acl^,ACL_REVISION,0,ace,acesize) then exit;
        finally
          freemem(ace);
        end;
      end;
    // init security descriptor
    if not InitializeSecurityDescriptorProc(sd,SECURITY_DESCRIPTOR_REVISION) then exit;
    // fill security descriptor (set DACL)
    if not SetSecurityDescriptorDaclProc(sd,true,acl,false) then exit;
    // set file security information (DACL from security descriptor)
    if not SetFileSecurityProc(PChar(Path),DACL_SECURITY_INFORMATION,sd) then exit;
    Result:=true;
  finally
    dispose(sd);
    freemem(acl);
  end;
end;

function SetPermissions(Path: string; AccessList: TAccessList;
  ChangeFilePerms, RecursDirs: boolean; CallbackProc: TSetPermsCallback): boolean;
var
  sr: TSearchRecEx;
  i: integer;
  Cancel: boolean;
begin
  Result:=false;
  if AdvApi32Lib = 0 then exit;

  Path:=RemoveBackSlash(Path);

  // start directory processing callback
  if Assigned(CallbackProc) then begin
    Cancel:=false;
    CallbackProc(Path,true,false,Cancel);
    if Cancel then begin
      Result:=false;
      exit;
    end;
  end;

  // set permissions to directory Path
  Result:=SetFileAccess(Path,AccessList);

  if Result and ChangeFilePerms then begin
    // process files
    i:=FindFirstEx(Path+'\*.*',0,faNotFiles,sr);
    try
      while i = 0 do begin
        Result:=SetFileAccess(Path+'\'+sr.Name,AccessList);
        if not Result then break;
        i:=FindNextEx(sr);
      end;
    finally
      FindCloseEx(sr);
    end;
  end;

  // end directory processing callback
  if Assigned(CallbackProc) then begin
    Cancel:=false;
    CallbackProc(Path,false,not(Result),Cancel);
    if Cancel then Result:=false;
  end;

  if Result and RecursDirs then begin
    // process subdirectories
    i:=FindFirstEx(Path+'\*.*',faDirectory,0,sr);
    try
      while i = 0 do begin
        Result:=SetPermissions(Path+'\'+sr.Name,AccessList,ChangeFilePerms,
          RecursDirs,CallbackProc);
        if not Result then break;
        i:=FindNextEx(sr);
      end;
    finally
      FindCloseEx(sr);
    end;
  end;
end;

function IsAdminRights: boolean;
var
  hProcess,hToken: THandle;
  InfoBuffer: PTokenGroups;
  Size: dword;
  i: integer;
  AdminsSid: PSID;
begin
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then Result:=true else Result:=false;
  if AdvApi32Lib = 0 then exit;

  hProcess:=GetCurrentProcess;
  if not OpenProcessTokenProc(hProcess,TOKEN_READ,hToken) then exit;
  GetTokenInformationProc(hToken,TokenGroups,nil,0,Size);
  getmem(InfoBuffer,Size);
  AdminsSid:=CreateWellKnownSID(wkDomainAliasAdmins);
  try
    if not GetTokenInformationProc(hToken,TokenGroups,InfoBuffer,Size,Size) then exit;
    for i:=0 to InfoBuffer^.GroupCount-1 do
      if EqualSidProc(InfoBuffer^.Groups[i].Sid,AdminsSid) then begin
        Result:=true;
        break;
      end;
  finally
    FreeSidProc(AdminsSid);
    freemem(InfoBuffer);
  end;
end;

procedure LoadAdvApi32Dll;
begin
  if Win32Platform in [VER_PLATFORM_WIN32s,VER_PLATFORM_WIN32_WINDOWS] then exit;
  AdvApi32Lib:=LoadLibrary('advapi32.dll');
  if AdvApi32Lib <> 0 then begin
    AllocateAndInitializeSidProc:=GetProcAddress(AdvApi32Lib,'AllocateAndInitializeSid');
    LookupAccountSidProc:=GetProcAddress(AdvApi32Lib,'LookupAccountSidA');
    GetSidIdentifierAuthorityProc:=GetProcAddress(AdvApi32Lib,'GetSidIdentifierAuthority');
    GetSidSubAuthorityProc:=GetProcAddress(AdvApi32Lib,'GetSidSubAuthority');
    GetSidSubAuthorityCountProc:=GetProcAddress(AdvApi32Lib,'GetSidSubAuthorityCount');
    EqualSidProc:=GetProcAddress(AdvApi32Lib,'EqualSid');
    GetLengthSidProc:=GetProcAddress(AdvApi32Lib,'GetLengthSid');
    CopySidProc:=GetProcAddress(AdvApi32Lib,'CopySid');
    LookupAccountNameProc:=GetProcAddress(AdvApi32Lib,'LookupAccountNameA');
    GetFileSecurityProc:=GetProcAddress(AdvApi32Lib,'GetFileSecurityA');
    GetSecurityDescriptorDaclProc:=GetProcAddress(AdvApi32Lib,'GetSecurityDescriptorDacl');
    GetAceProc:=GetProcAddress(AdvApi32Lib,'GetAce');
    InitializeAclProc:=GetProcAddress(AdvApi32Lib,'InitializeAcl');
    AddAceProc:=GetProcAddress(AdvApi32Lib,'AddAce');
    InitializeSecurityDescriptorProc:=GetProcAddress(AdvApi32Lib,'InitializeSecurityDescriptor');
    SetSecurityDescriptorDaclProc:=GetProcAddress(AdvApi32Lib,'SetSecurityDescriptorDacl');
    SetFileSecurityProc:=GetProcAddress(AdvApi32Lib,'SetFileSecurityA');
    OpenProcessTokenProc:=GetProcAddress(AdvApi32Lib,'OpenProcessToken');
    GetTokenInformationProc:=GetProcAddress(AdvApi32Lib,'GetTokenInformation');
    FreeSidProc:=GetProcAddress(AdvApi32Lib,'FreeSid');
  end;
end;

initialization
  LoadAdvApi32Dll;

finalization
  if AdvApi32Lib <> 0 then FreeLibrary(AdvApi32Lib);

end.
