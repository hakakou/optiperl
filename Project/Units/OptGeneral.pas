{***************************************************************
 *
 * Unit Name: OptGeneral
 * Date     : 17/12/2000 4:30:58 μμ
 * Purpose  : General - Purpose routines only for OptiPerl
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}


unit OptGeneral;       //Unit
{$I REG.INC}

interface
uses sysutils,controls,classes,hyperstr,stdctrls,jvvclutils,windows,forms,Dialogs,
     hyperfrm,hakawin,jclfileutils,optfolders,hakageneral,
     hakacontrols,DIPcre,Registry, jclSecurity,ShellApi, ShlObj, hakafile, hakasync,
     OptOptions,syncobjs,HKDebug,hakapipes;

const
 OptiEditorBmp = 'OptiEditor.bmp';
 OptiExplorerBmp = 'OptiExplorer.bmp';
 OptiMainBmp = 'OptiMain.bmp';
 OptiStartpage = 'Startpage.htm';
 OptiMinSplitterAdd = 50;

 RegSoftKey = '\SOFTWARE\Xarka\OptiPerl';
 OptiLayoutExt =  '.lyt';

type
 TGetDeclarationProc = Function(const Str : String) : String of object;


//function OptiTitle(withver : Boolean) : string;
function OptiVersion : string;
function DeSafeStr(const s:string) : string;
function GetComSpec : string;
Function EncryptKey(const Key : String) : string;
Function DecryptKey(const EncryptedKey : String)  : string;
Function GetTempFile : String;
Function HandleComboBox(CB : TComboBox) : Boolean;
procedure SmartStringsAdd(sl : TStrings; const text : string);
procedure TextToHtml(var s:string);
Function QuoteStr(const Str : String) : String;
Function UnQuoteStr(const Str : String) : String;
function FilenameQuote(const FIlename:string) : string;
function PipeExeToFile(const Application,Command,WorkDir,OutPipeFile,Env : string;
                       var ProcessInfo : TProcessInformation;
                       const InPipeFile : string = '') : Integer;
function ExtractWordFromText(const Text:string) : string;
Procedure DeleteDebugPrompt(var text : string);
Function HasDebugPrompt(const text : string) : boolean;
Function FileReadOnly(Const Filename : String) : Boolean;
Function ParseHttpConf(Out DocRoot,Aliases,ErrorLog,AccessLog : String) : Boolean;

procedure DoPerlDBReg(const Value,CompName : String; Add : Boolean);
procedure DoPerlDBEnv(const Value : string; Add : Boolean);
Function HasPerlDBReg : String;
Function ExtFileFromErrorLine(const Line:string) : String;

procedure DoPerl5DBVal;
Function HasPerlDBEnv : String;
Function PopulateLayoutList(Items : TStrings) : Integer;
procedure AddDeclaration(var Res : String; const Expr : string; GetDecProc : TGetDeclarationProc);
Function Get16ByteName(const Name : String) : String;
Function SearchTag(const Str : String; out Tag,Value : String; Out Index,Length : Integer) : Boolean;

var
 ThreadsSleep : integer = 50;
 HintLineSplitter : String;
 TerminateChecking : Boolean = true;
 ExplorerUpdating : Boolean = false;
 NoMemoSource : Boolean = true;
 OptiSplitterWidth : Integer = 7;

 CSLineUpdate_r : TRTLCriticalSection;
 CSLineUpdate_m : Cardinal;
 CSEditorRTL : Boolean;

 CSEntireCode,CSEntireExplorer : Cardinal;

 TicksNextCode : Cardinal = 0;
 TicksNextExplorer : Cardinal = 0;
 TicksTimeout : Cardinal = 10000;

 EventStartCode,EventStartExplorer : Cardinal;

 CodeGetCodeSkip : Boolean = false;
 CodeGetExplorerSkip : Boolean = false;

 IsLoadingLayout : boolean = false;
 OptiTitleName : String = 'OptiPerl';
 OptiTitleProject : String = '';
 OptiTitleFile : String = '';

 Procedure GetRegInformation;

Procedure EditorEnterCS;
Procedure EditorLeaveCS(ThreadsSkipCode : Boolean);
Procedure EditorInitCS(init : Boolean);

Procedure ThreadEnterSafeCS;
Procedure ThreadLeaveSafeCS;

procedure NotifyState(Const Msg : String; WithError : Boolean);
Function IsAdmin : Boolean;

implementation

var
 ExtractWordFromTextPattern : string;
 PrPcre : TDIPcre;
 TagPcre : TDIPcre;

Const
 PerlDBNameStr = 'PERLDB_OPTS';

type
  TOKEN_INFORMATION_CLASS = (
    TokenICPad, // dummy padding element
    TokenUser,
    TokenGroups,
    TokenPrivileges,
    TokenOwner,
    TokenPrimaryGroup,
    TokenDefaultDacl,
    TokenSource,
    TokenType,
    TokenImpersonationLevel,
    TokenStatistics,
    TokenRestrictedSids,
    TokenSessionId,
    TokenGroupsAndPrivileges,
    TokenSessionReference,
    TokenSandBoxInert,
    TokenAuditPolicy,
    TokenOrigin,
    TokenElevationType,
    TokenLinkedToken,
    TokenElevation,
    TokenHasRestrictions,
    TokenAccessInformation,
    TokenVirtualizationAllowed,
    TokenVirtualizationEnabled,
    TokenIntegrityLevel,
    TokenUIAccess,
    TokenMandatoryPolicy,
    TokenLogonSid,
    MaxTokenInfoClass  // MaxTokenInfoClass should always be the last enum
  );

  TOKEN_ELEVATION = packed record
    TokenIsElevated: DWORD;
  end;

Function IsElevated : Boolean;
var
  Token: THandle;
  Elevation: TOKEN_ELEVATION;
  Dummy: cardinal;
begin
  Result := False;
  if OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, Token) then
  begin
    Dummy := 0;
    if GetTokenInformation(Token, TTokenInformationClass(TokenElevation),
      @Elevation, SizeOf(TOKEN_ELEVATION), Dummy) then
      Result := (Elevation.TokenIsElevated <> 0);
    CloseHandle(Token);
  end;
end;

function RequiresElevation: boolean;
var
  Info: TOSVersionInfo;
begin
  Info.dwOSVersionInfoSize := SizeOf(Info);
  GetVersionEx(Info);

  if Info.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then
    Result := False

  else
  if (Info.dwMajorVersion >= 6) and (IsElevated) then
    Result := False

  else
  if (Info.dwMajorVersion >= 6) then
    Result := True

  else
    Result := not IsAdministrator;
end;

Function IsAdmin : Boolean;
begin
 result:=not RequiresElevation;
end;

procedure NotifyState(Const Msg : String; WithError : Boolean);
begin
end;

Procedure ThreadEnterSafeCS;
var
 c,h:Cardinal;
 i: Integer;
begin
 for i:=1 to 2 do
 begin
  c:=GetTickCount+TicksTimeout+5000;
  case i of
   1: h:=CSEntireExplorer;
   2: h:=CSEntireCode;
  end;

  while WaitForSingleObject(h,1)=WAIT_TIMEOUT do
  begin
   Application.ProcessMessages;
   if GetTickCount>c then
   begin
    NotifyState('TimeoutCase'+inttostr(i),true);
    break;
   end;
  end;

 end;
end;

Procedure ThreadLeaveSafeCS;
begin
 releaseMutex(CSEntireCode);
 releaseMutex(CSEntireExplorer);
end;

Procedure EditorEnterCS;
var
 c:cardinal;
begin
 if CSEditorRTL then
  begin
   if not TryEnterCriticalSection(CSLineUpdate_r) then
   begin
    sleep(1);
    c:=GetTickCount+1000;
    while not TryEnterCriticalSection(CSLineUpdate_r) do
    begin
     sleep(1);
     if GetTickCount>c then
     begin
      Assert(false,'LOG RESTART LineUpdate');
      EditorInitCS(false);
      EditorInitCS(true);
     end;
    end;
   end;
  end

 else
  begin
   if WaitForSingleObject(CSLineUpdate_m,1)=WAIT_TIMEOUT	then
   begin
    c:=GetTickCount+1000;
    while WaitForSingleObject(CSLineUpdate_m,1)=WAIT_TIMEOUT do
    begin
     if GetTickCount>c then
     begin
      Assert(false,'LOG RESTART LineUpdate');
      EditorInitCS(false);
      EditorInitCS(true);
     end;
    end;
   end;
  end

end;

Procedure EditorInitCS(init : Boolean);
begin
 if init then
  begin
   if CSEditorRTL
    then InitializeCriticalSection(CSLineUpdate_r)
    else CSLineUpdate_m:=CreateMutex(nil,false,nil);
  end
 else
  begin
   if CSEditorRTL
    then DeleteCriticalSection(CSLineUpdate_r)
    else CloseHandle(CSLineUpdate_m);
  end;
end;

Procedure EditorLeaveCS(ThreadsSkipCode : Boolean);
begin
 if ThreadsSkipCode then
 begin
  CodeGetCodeSkip:=true;
  CodeGetExplorerSkip:=true;
 end;

 if CSEditorRTL
  then LeaveCriticalSection(CSLineUpdate_r)
  else ReleaseMutex(CSLineUpdate_m);
end;

Function SearchTag(const Str : String; out Tag,Value : String; Out Index,Length : Integer) : Boolean;
const
 EndTag = '>%';
var
 sp,ep,i : Integer;
begin
 result:=false;
 if not assigned(TagPcre) then
 begin
  TagPcre:=TDIPcre.Create(nil);
  TagPcre.MatchPattern:='%(toggle|set|f|o|n)<';
 end;
 TagPcre.SetSubjectStr(str);

 i:=1;
 repeat
  ep:=ScanFF(str,endtag,i);
  dec(ep);
  if ep<0 then exit;
  sp:=0;
  while (TagPcre.match(sp)>0) do
  begin
   if tagpcre.MatchedStrFirstCharPos>ep then break;
   sp:=tagpcre.MatchedStrAfterLastCharPos;

   index:=tagpcre.MatchedStrFirstCharPos+1;
   Tag:=lowercase(tagpcre.SubStr(1));
   value:=copy(str,sp+1,(ep-sp));
   length:=tagpcre.MatchedStrLength+(ep-sp)+system.length(EndTag);

   result:=true;
  end;
  inc(i,system.length(endtag));
 until result;
end;

Function Get16ByteName(const Name : String) : String;
begin
 result:=name;
 if length(result)>=16
  then delete(result,1,length(result)-16)
  else insert(stringofchar('_',16-length(result)),result,1);
end;

procedure AddDeclaration(var Res : String; const Expr : string; GetDecProc : TGetDeclarationProc);
var
 Temp : String;
begin
 try
  temp:=GetDecProc(Expr);
 except
  temp:='';
 end;
 if length(temp)=0 then exit;
 if length(res)>0
  then res:=res+HintLineSplitter+temp
  else res:=temp;
end;

Function PopulateLayoutList(Items : TStrings) : Integer;
var i:integer;
begin
  items.Clear;
  GetFileList(folders.UserFolder,'*'+OptiLayoutExt,false,faArchive,items);
  for i:=0 to items.Count-1 do
   items[i]:=ExtractFileNoExt(items[i]);
  if items.IndexOf(OptiLastLayout)<0 then
   items.Add(OptiLastLayout);
  result:=items.indexof(options.layout);
end;

Function HasPerlDBEnv : String;
begin
 result:=GetEnvironmentVariable(PerlDBNameStr);
end;

Function HasPerlDBReg : String;
var
 Reg: TRegistry;
begin
  result:='';
  Reg := TRegistry.Create;
  try
   Reg.RootKey := HKEY_LOCAL_MACHINE;
   if (Reg.OpenKey('\Software\Perl', false)) and
      (reg.ValueExists(PerlDBNameStr)) then
    result:=reg.ReadString(PerlDBNameStr);
  finally
   reg.free;
  end;
end;

procedure DoPerl5DBVal;
Const
 NameStr = 'PERL5DB';
var
 Reg: TRegistry;
 s:string;
begin
 SetEnvironmentVariable(pchar(NameStr),nil);
 if not IsAdmin then exit;
 reg:=TRegistry.Create;
 try
  reg.RootKey:=HKEY_LOCAL_MACHINE;
  if reg.OpenKey('SOFTWARE\Perl',false) and
     reg.ValueExists(NameStr) then
  begin
   s:=reg.ReadString(NameStr);
   reg.DeleteValue(NameStr);
   reg.WriteString(';'+NameStr,s);
  end;
 finally
  reg.free;
 end;
end;

procedure DoPerlDBEnv(const Value : string; Add : Boolean);
begin
 if add
  then SetEnvironmentVariable(pchar(PerlDBNameStr),pchar(value))
  else SetEnvironmentVariable(pchar(PerlDBNameStr),nil);
end;

procedure DoPerlDBReg(const Value,CompName : String; Add : Boolean);
Const
 NameStr = 'PERLDB_OPTS';
var
 Reg: TRegistry;
 good : boolean;
begin
  good:=false;
  Reg := TRegistry.Create;
  try
    try
     Reg.RootKey := HKEY_LOCAL_MACHINE;
     if (compname<>'') then
     begin
      if not reg.RegistryConnect(Compname) then
      begin
       MessageDlg('Could not connect to remote registry.'+#13+#10+'Make sure both computers are connected to the '+#13+#10+'network and are running the remote registry service.', mtWarning, [mbOK], 0);
       exit;
      end;
     end;
     if (Reg.OpenKey('\Software\Perl',add)) then
      begin
       if (add) then reg.WriteString(PerlDBNameStr,value);
       if (not add) then reg.DeleteValue(PerlDBNameStr);
       Reg.CloseKey;
       good:=true;
      end;
    except
     on Exception do begin end;
    end;
  finally
    Reg.Free;
  end;
  if not good then
   MessageDlg('Could not change registry.', mtError, [mbOK], 0);
end;


Procedure GetRegInformation;
var
 i:integer;
begin
end;

Function ParseHttpConf(Out DocRoot,Aliases,ErrorLog,AccessLog : string) : Boolean;
var
 sl:TStringList;
 Pcre : TDIPcre;

  Function GetFirst(Const Pat : string; out Ref1,ref2 : string;
                          var StartLine : Integer) : Boolean;
  var
   i:integer;
  begin
   pcre.MatchPattern:=pat;
   result:=false;
   for i:=startline to sl.Count-1 do
    if pcre.MatchStr(sl[i])>0 then
    begin
     result:=true;
     if pcre.SubStrCount>1 then
      Ref1:=pcre.SubStr(1);
     if pcre.SubStrCount>2 then
      Ref2:=pcre.SubStr(2);
     StartLine:=i+1;
     break;
    end;
  end;

  Function FixPath(const p : string) : String;
  begin
   result:=removequotes(p,'"');
   result:=IncludeTrailingAnySlash(result,'\');
   result:=FixToBackSlash(result);
  end;

var
 open : TOpenDialog;
 path,serverroot : string;
 i:integer;
 r1,r2 : string;
begin
 result:=false;
 Open:=TOpenDialog.Create(nil);
 Open.DefaultExt:='conf';
 open.Title:='Select httpd.conf file';
 open.Filter:='Configuration files (*.conf)|*.conf';
 if open.Execute
  then path:=open.FileName
  else path:='';
 Open.Free;
 result:=Fileexists(path);
 if not result then exit;

 sl:=TStringList.create;
 sl.LoadFromFile(path);
 pcre:=TDiPcre.Create(nil);
 try
  i:=0;
  if not GetFirst('^\s*ServerRoot\s+([^#]+)',ServerRoot,r2,i)
   then ServerRoot:=''
   else ServerRoot:=FixPath(serverroot);
  if not GetFirst('^\s*DocumentRoot\s+([^#]+)',DocRoot,r2,i) then
   DocRoot:='Could not find "DocumentRoot"'
   else
    begin
     DocRoot:=FixPath(docroot);
     i:=0;
     if not GetFirst('^\s*ErrorLog\s+([^#]+)',ErrorLog,r2,i)
      then ErrorLog:=''
      else begin
       ErrorLog:=ExcludeTrailingBackSlash(FixPath(ErrorLog));
       if ispathrelative(errorlog) then
        ErrorLog:=ServerRoot+ErrorLog;
      end;
     i:=0;
     if not GetFirst('^\s*CustomLog\s+([^#]+)\s+COMMON',AccessLog,r2,i)
      then AccessLog:=''
      else begin
       AccessLog:=ExcludeTrailingBackSlash(FixPath(AccessLog));
       if ispathRelative(Accesslog) then
        AccessLog:=ServerRoot+AccessLog;
      end;
    end;
  i:=0;
  Aliases:='';
  while GetFirst('^\s*(?:alias|scriptalias)\s+(\S+)\s+"([^"]+)"',r1,r2,i)
   do Aliases:=Aliases+r1+'='+r2+';';
  //DocumentRoot "C:/Apache/htdocs"
  //ScriptAlias /cgi-bin/ "C:/Apache/cgi-bin/"
 finally
  sl.free;
  pcre.free;
 end;
end;

Function FileReadOnly(Const Filename : String) : Boolean;
begin
 result:=HasAttr(Filename,faReadOnly);
end;

Function HasDebugPrompt(const text : string) : boolean;
begin
 result:=prpcre.MatchStr(text)>0;
end;

Procedure DeleteDebugPrompt(var text : string);
begin
 with prpcre do
  if MatchStr(text)>0 then
   delete(text,MatchedStrFirstCharPos+1,MatchedStrLength);
end;


function ExtractWordFromText(const Text:string) : string;
var
 l,p:integer;
begin
 Result:='';
 p:=1;
 l:=ScanRX(text,ExtractWordFromTextPattern,p);
 if l>0 then
  Result:=Copy(text,p,l);
end;
(*
function OptiTitle(withver : Boolean) : string;
const
 Opti = #7#171#222#237#137#100#40#225#37;
 Ver = #161#221#151#230;    {4.0}
begin
 Result:=DeSafeStr(Opti);
 if withver then Result:=Result+' '+desafestr(ver);
end;
*)

function OptiVersion : string;
begin
 case OptiRel of
  orStan : Result:=DeSafeStr(#39#139#84#31#104#1#141#142#100);
  orPro :  Result:=DeSafeStr(#135#235#234#59#31#94#252#49#147#217#102);
  orUnreg : Result:=DeSafeStr(#103#211#16#24#36#134#88#212#23#225#54);
  orCom :  Result:=DeSafeStr(#47#47#78#110#3#213#24#47#96#252);
 end;
end;

function DeSafeStr(const S:string) : string;
begin
 Result:=s;
 Crypt(result,'#dss65w(dv');
 inisqz;
 result:=unSQZ(result,0);
end;


function FilenameQuote(const FIlename:string) : string;
begin
 Result:=FileName;
 if (Length(Result)>0) and (Result[1]<>'"') then
  Result:='"'+Result+'"';
end;

function GetComSpec : string;
begin
 Result:=GetEnvVar('Comspec');
end;

function PipeExeToFile(const Application,Command,WorkDir,OutPipeFile,Env : string;
                       var ProcessInfo : TProcessInformation;
                       const InPipeFile : string = '') : Integer;
var
 s,ip:string;
begin
 if (InPipeFile<>'') and (FileExists(inpipefile))
  then ip:=' < '+FilenameQuote(InPipeFile)
  else ip:='';
 s:=extractfilename(getcomspec)+' /c '+ Application+' '+command+
    ip+' > '+FilenameQuote(OutPipefile);
 if folders.DebOutput<>'' then ShowMessage(s);
 Result:=WinExecAndWait(s,workdir,Env,ProcessInfo,SW_HIDE,
 //SW_SHOWMINIMIZED does not flash screen but does show box in taskbar
                        options.runtimeout*1000);
end;

Function UnQuoteStr(const Str : String) : String;
begin
 result:=URLDEcode(str);
 result:=Copy(result,2,length(result)-2);
end;

Function QuoteStr(const Str : String) : String;
begin
 result:=URLEncode(str);
 result:='"'+result+'"';
end;

procedure TextToHtml(var s:string);
var
 i,j:integer;
begin
 ReplaceSC(s,'&','&amp;',false);
 replaceSC(s,'<','&lt;',false);
 replaceSC(s,'>','&gt;',false);
 i:=0;
 ReplaceSC(s,#9,'     ',false);
 repeat
  inc(i);
 until (i>length(s)) or (s[i]<>' ');
 dec(i);
 delete(s,1,i);
 for j:=1 to i do
 s:='&nbsp;'+s;
end;

procedure SmartStringsAdd(sl : TStrings; const text : string);
begin
 if text<>'' then
  smartTStringsAdd(sl,text,options.recentItems);
end;

Function HandleComboBox(CB : TComboBox) : Boolean;
begin
 HandleComboBoxText(cb,options.recentitems);
end;

Function GetTempFile : String;
begin
 result:=gettmpfile(GetTmpDir,'OP');
end;

const
 PassKey1 = 'jd$%32!Adg@';
 PassKey2 = 'd33476GHV';

Function EncryptKey(const key : String) : string;
begin
 result:=key;
 Crypt(result,Passkey1);
 Crypt(result,Passkey2);
 result:=EncodeStr(result);
end;

Function DecryptKey(const EncryptedKey : String) : string;
begin
 result:=Decodestr(EncryptedKey);
 Crypt(result,PassKey2);
 Crypt(result,PassKey1);
end;

Function ExtFileFromErrorLine(const Line:string) : String;
var
 l,p:integer;
begin
 p:=1;
 l:=ScanW(line,'at line #',p);
 if l>0 then
  result:=''
 else
  begin
   p:=1;
   l:=ScanW(line,'at * line #',p);
   if l<>0
    then result:=Copy(line,p+3,l-10)
    else result:='';
  end;
end;


initialization
 HKLog('General Start');
 IsMultiThread:=true;
 Randomize;

 if not directoryExists(GetTmpDir) then
 try
  mkdir(GetTmpDir)
 except
  MessageDlg('Could not create temporary directory '+GetTmpDir, mtError, [mbOK], 0);
 end;

 HintLineSplitter:=#13#10+StringOfChar('_',65)+#13#10;

 ExtractWordFromTextPattern:=makepattern('[0-9,A-Z,a-z,_,@,$,%,&][0-9,A-Z,a-z,_]*');
 //was [0-9,A-Z,a-z,_,@,$,%,&][0-9,A-Z,a-z,_,-]*

 prPcre:=TDiPcre.Create(nil);
 prPcre.MatchPattern:=DeSafeStr(#137#123#130#91#245#112#125#196#106#219#125#31);
 //   '  DB<+\d+>+ '
 //used for remote debugging

 CSEditorRTL:=Win32Platform=VER_PLATFORM_WIN32_NT;

 EditorInitCS(true);

 CSEntireCode:=CreateMutex(nil,false,nil);
 CSEntireExplorer:=CreateMutex(nil,false,nil);

 EventStartCode:=CreateEvent(Nil,false,false,nil);
 EventStartExplorer:=CreateEvent(Nil,false,false,nil);

 if OptOptions.CPUSpeed<1000 then
  TicksTimeout:=TicksTimeout+(10000-CPUSpeed*10);
 HKLog;

 OptiRel:=orCom;
finalization
 HkLog('General End');
 EditorInitCS(False);

 CloseHandle(CSEntireCode);
 Closehandle(CSEntireExplorer);

 CloseHandle(EventStartCode);
 Closehandle(EventStartExplorer);

 PrPcre.free;
 if assigned(TagPcre) then
  TagPcre.Free;
 HKLog;
end.
