unit HakaReg;

interface
uses registry,hyperstr,windows,sysutils,agNTSecurity,dialogs;

var                         {EXAMPLES}
 ProgGUID : String;       {['{6CF24364-D9E9-11D3-8802-20C14DC10000}
 OldProgGUID : string = '';//will be deleted if not empty
 TrialDays : String;      {30}
 ProgramExpired : String;  {Your 30 day trial has expired! }
 ProgramNotExpired : String; {Your are on day %d of evaluation period of 30}
 TrialCaption : String; {Trial Version}
 SecurityKey : String;  {#1#55#223#2#66#88#14}
 UserName : String = '';
 IsRegistered : Boolean = true;
 SerialNumber : Cardinal = 0;
 FirstRun : Boolean = false;
 FirstRunDate : Integer = 0;
 EndRunDate : Integer = 0;

Procedure InsertGetDates;
Function IsExpired : Boolean;
Function FindIfReg : Boolean;
Function FindIfReg2 : Boolean;
Function NagString : string;
function DeSQZ(const Bfr:AnsiString):AnsiString;
function PaSQZ(const Bfr:AnsiString):AnsiString;
Procedure WaitTicks(ms : Integer);

implementation

type
 tRdate = packed record
  s,e : integer;
end;

const
 RegKey1 = #186#159#15#229#82#0#144#112#186#190#96#61#213#95#224#152#15#184#12#26#64;
          {\Software\CLASSES\CLSID\}
 RegKey2 = #186#169#122#35#221#125#254#12#252#222#91#44#137#63#8;
          {\InprocServer32}
 Explorerstr = #98#205#227#219#7#55#85#191#229#22#8;
          {EXPLORER.EXE}
 ThreadStr =   #170#149#102#183#8#37#117#39#23#78#179#79#1#2;
          {ThreadingModel}

Procedure WaitTicks(ms : Integer);
var i:integer;
begin
 i:=gettickcount+ms;
 repeat
 until gettickcount>i;
end;

Function FindIfReg : Boolean;
var s:string; c:cardinal;
begin
 s:=SecurityKey+UserName;
 inisqz;
 s:=Sqz(s,0);
 Crypt(s,SecurityKey);
 c:=hash(s);
 IsRegistered:=c=SerialNumber;
 result:=c=SerialNumber;
end;

Function FindIfReg2 : Boolean;
var s:string; c:cardinal;
begin
 s:=SecurityKey+UserName;
 inisqz;
 s:=Sqz(s,0);
 Crypt(s,SecurityKey);
 c:=hash(s);
 IsRegistered:=c=SerialNumber;
 result:=c=SerialNumber;
end;

Function IsExpired : Boolean;
begin
 result:=(Trunc(date)<FirstRunDate) or (Trunc(date)>EndRunDate);
end;

Function NagString : string;
var a:integer;
begin
 a:=Trunc(date)-FirstRunDate+1;
 if (Trunc(date)<FirstRunDate) or (Trunc(date)>EndRunDate)
  then result:=ProgramExpired
  else result:=Format(ProgramNotExpired,[a]);
end;

function DeSQZ(const Bfr:AnsiString):AnsiString;
begin
 iniSQZ;
 result:=UnSQZ(bfr,0);
end;

function PaSQZ(const Bfr:AnsiString):AnsiString;
begin
 iniSQZ;
 result:=SQZ(bfr,0);
end;

Procedure InsertGetDates;
var
 Reg: TRegistry;
 today,exp : integer;
 Key : String;
 OldKey : string;
 Rdate : TRDate;
begin
 today:=trunc(date);
 key:=DeSQZ(RegKey1) + ProgGuid + DeSQZ(RegKey2);
 if OldProgGuid<>'' then
  OldKey:=DeSQZ(RegKey1) + OldProgGuid;

 //is first run??

 try
  Reg:=TRegistry.Create(KEY_READ);
  try
   Reg.RootKey := HKEY_LOCAL_MACHINE;
   FirstRun:=not Reg.KeyExists(key);
  finally
   reg.free;
  end;
 except on exception do end;

 //if first run then add data
 If (FirstRun) and (not IsAdminRights) then
 begin
  MessageDlg('OptiPerl must be run by an administrator'+#13+#10+'the first time it loads.', mtError, [mbOK], 0);
  exit;
 end;

 try
  if (firstrun) then
  begin
   Reg:=TRegistry.Create;
   try
    Reg.RootKey:=HKEY_LOCAL_MACHINE;
    if (oldkey<>'') and (reg.KeyExists(oldkey)) then
    try
     REG.DeleteKey(oldkey);
    except on exception do end;

    Reg.OpenKey(key, TRUE);
    FirstRunDate:=Today;
    Exp:=FirstRunDate+strToInt(trialDays)-1;
    EndRunDate:=Exp;
    Reg.WriteString('',uppercase(getwindir)+'\'+DeSQZ(Explorerstr));
    Rdate.s:=FirstRunDate;
    RDate.e:=exp;
    Reg.WriteBinaryData(DeSQZ(ThreadStr),RDate,sizeof(Rdate));
   finally
    Reg.Free;
   end;
  end;
 except on exception do end;

 //Now Load data

 try
  Reg:=TRegistry.Create(KEY_READ);
  try
   Reg.RootKey := HKEY_LOCAL_MACHINE;
   Reg.OpenKey(key, false);
   Fillchar(RDate,Sizeof(RDate),0);
   reg.ReadBinaryData(DeSQZ(ThreadStr),Rdate,sizeof(RDate));
   FirstRunDate:=RDate.s;
   EndRunDate:=RDate.e;
  Finally
   reg.free;
  end;
 except on exception do end;

end;



end.
