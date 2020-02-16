unit PerlHelpers;

interface
uses
 classes,sysutils,Windows,hyperfrm,HAkaPipes,HakaGeneral,HyperStr,hakafile,jclRegistry;

const
 PerlDLLBadStr = 'Perl DLL Not valid. Please install a new perl version.';

Function FindINCPath(Const PerlExe : String) : String;
Function FastFindINCPath(const PerlExe : string) : string;
Function FindDllPath(Const PerlExe : String) : String;
Function FindVersion(Const PerlExe : String) : String;
Function FindIfDLLOK(Const PerlDLL : String) : Boolean;
function FindPerlPath : string;

implementation
var
 PrevPerlExe : String;
 PrevIncPath : String;

Function FindIfDLLOK(Const PerlDLL : String) : Boolean;
var
 s:string;
begin
 result:=fileexists(perldll);
 if result then
 begin
  s:=LoadStr(perldll);
  result:=(pos('USE_ITHREADS',s)>0) and (pos('MULTIPLICITY',s)>0)
 end;
end;

Function FastFindINCPath(const PerlExe : string) : string;
begin
 if PerlExe<>PrevPerlExe then
 begin
  PrevIncPath:=FindIncPath(perlExe);
  PrevPerlExe:=PerlExe;
 end;
 result:=PrevIncPath;
end;

function FindPerlPath : string;
begin
 result:=RegReadStringDef(HKEY_LOCAL_MACHINE,'\Software\Perl','BinDir','c:\perl\bin\perl.exe');
end;

Function FindDllPath(Const PerlExe : String) : String;
var
 sl : TStringList;
 p : String;
 i,j:integer;
begin
 result:='';
 sl:=TStringList.Create;
 try
  p:=IncludeTrailingBackSlash(extractfilepath(PerlExe));
  GetFileList(p,'perl*.dll',false,faarchive,sl);
  for i:=0 to sl.Count-1 do
  begin
   j:=-1;
   scanw(sl[i],'perl##.dll',j);
   if j<=0 then
   begin
    j:=-1;
    scanw(sl[i],'perl###.dll',j);
   end;
   if j>0 then
   begin
    result:=ExtractFilepath(perlexe)+sl[i];
    break;
   end;
  end;
 finally
  sl.free;
 end;
end;

Function FindVersion(Const PerlExe : String) : String;
var
 ps : TPipeStatus;
begin
 result:=Trim(PipeSTDAndWait(perlexe,'-e "printf ''%vd'', $^V"','','','',2500,NORMAL_PRIORITY_CLASS,ps));
 if ps<>psTerminated then
  result:=''
end;

Function FindINCPath(Const PerlExe : String) : String;
var
 ps : TPipeStatus;
begin
 result:=Trim(PipeSTDAndWait(perlexe,'-e "foreach (@INC) {print qq($_\n)}"','','','',2500,NORMAL_PRIORITY_CLASS,ps));
 if ps<>psTerminated then
  result:=''
 else
  begin
   deleteEndsWith('.',result);
   result:=Trim(result);
   replaceSC(result,#13#10,';',false);
   replaceC(result,'/','\');
  end;
end;


end.
