unit HakaFile;

interface
uses sysutils,classes,hyperstr,registry,windows,
     hakageneral,variants,DateUtils,jclFileUtils;

Function ExtractPathNoExt(const path : string) : string;
Function GetAbovePath(Const AbsPath : string) : String;

Function GetRelativePath(const Mainpath,FindPath : String) : string;
Function GetAbsolutePath(const Mainpath,FindPath : String) : string;
Function GetRelativeFile(const Mainpath,FindPath : String) : string;
Function GetAbsoluteFile(const Mainpath,FindPath : String) : string;
Function IncludeTrailingSlash(const Path : String) : String;
Function IncludeTrailingAnySlash(const Path : String; DefSlash : Char) : String;
Function ExcludeTrailingSlash(const Path : String) : String;
Function ExcludeTrailingAnySlash(const Path : String) : String;

function ExtractFileNoExt(const f:string) : string;
Function GetDirDiff(const basic,bigger : string) : string;
function IsSubDir(dir,testdir : string) : boolean;
function UpFileExt(const FileName : string) : string;
function GetFileExt(const FileName : string) : string;
Function IsUNCPath(const path : string) : Boolean;
Function ExtractLongPathName(const path : string) : string;
Function IsSameFile(const f1,f2 : String) : Boolean;
Function IsSameFileFast(const f1,f2 : String) : Boolean;
Function FixToSlash(const path : string) : string;
Function FixToBackSlash(const path : string) : string;

Function GetAssociatedEXE(const ext : string; out desc,path : String) : string;
Procedure SetAssociatedEXE(const ext,desc,path : string);
Function GetDriveLetters(SearchType : cardinal) : string;
Function GetCurrentDir : String;

Function GetNetShareInformation(Share : string; out Path,Remark : String) : Boolean;
Procedure GetNTNetShareInformation(const Server,Share : string; out Path,Remark : String);
Function GetEnvironment : String;

Procedure GetFileList(const Folder,Wildcard : string; Recursive : Boolean; Attr : Integer; FileList: TStrings);
Function IsPathRelative(const Path : String) : boolean;
Procedure DelTree(Const Folder : String);
Function DirExistsOrEmpty(const Path : String) : boolean;
Function DirContainsFilesOrFolders(const Path : String) : boolean;

Function ChangeFileExtension(const filename,ext : string) : String;

type
  TFileSearch = class
   private
    procedure DoTheSearch(path,wildCard : string);
    procedure FindAllFiles(const path,wildcard : string);
   public
    Terminated : Boolean;
    Attr : Integer;
    SaveFolderToo,Recursive : boolean;
    FileList : TStrings;
    OnFoundFile: procedure(const Path : string; const Sr : TSearchRec) of object;
    procedure DoSearch(path,wildCard : string);
    constructor create;
  end;

function GetFileHandle(const FileName: string): THandle;
//After the handle is opened, it must be closed with findclose(handle)

Function SetFileDateTime(const Filename : string; DateTime : TDateTime) : Integer;
Function ValidSafeFilename(Const Filename : String) : Boolean;
Function GetSafeFilename(Const Filename : String) : String;
Function GetFolderDateTime(Const Folder : String) : TDateTime;
function FileStartsWith(const Starts,str : string) : Boolean;
function FileEndsWith(const Ends,str : string) : Boolean;
function CustomFileSort(List: TStringList; Index1, Index2: Integer): Integer;
function HasAttr(const FileName: string; Attr: Integer): Boolean;
Function GetSerializedFilename(const Path, AFormat : String) : String;
//Example 'Mixaz - Untitled%.4d.wmv'

implementation

Function GetSerializedFilename(const Path, AFormat : String) : String;
var
 i:integer;
 p,f,s:string;
 sr:TsearchRec;
 found : boolean;
begin
 i:=1;
 p:=IncludeTrailingBackSlash(path);
 f:=p+ChangeFileExtension(aformat,'.*');
 repeat
  result:=p+format(AFormat,[i]);
  s:=Format(f,[i]);
  found:=findfirst(s,faAnyFile,sr)=0;
  SysUtils.FindClose(sr);
  inc(i);
 until not found;
end;

Function DirExistsOrEmpty(const Path : String) : boolean;
begin
 result:=(length(path)=0) or (directoryExists(path));
end;

function HasAttr(const FileName: string; Attr: Integer): Boolean;
var
  FileAttr: Integer;
begin
  FileAttr := FileGetAttr(FileName);
  Result := (FileAttr >= 0) and (FileAttr and Attr = Attr);
end;

Function GetCurrentDir : String;
begin
 getdir(0,result);
end;

Function GetFolderDateTime(Const Folder : String) : TDateTime;
var
 sr : TSearchRec;
 st : TSystemTime;
begin
 result:=0;
 if (FindFirst(ExcludeTrailingBackSlash(Folder),faDirectory,sr)=0) and
    (FileTimeToSystemTime(sr.FindData.ftCreationTime,st)) then
  result:=EncodeDateTime(st.wYear,st.wMonth,st.wDay,st.wHour,st.wMinute,st.wSecond,st.wMilliseconds);
end;

function CustomFileSort(List: TStringList; Index1,
  Index2: Integer): Integer;
var
 i:integer;
 s:string;
begin
 result:=0;

 s:=list[index1];
 for i:=1 to length(s) do
  if s[i] in ['\','/'] then inc(result);

 s:=list[index2];
 for i:=1 to length(s) do
  if s[i] in ['\','/'] then dec(result);
end;


Function FixToSlash(const path : string) : string;
begin
 result:=path;
 replaceC(result,'\','/');
 replaceSC(result,'//','/',false);
end;

Function FixToBackSlash(const path : string) : string;
begin
 result:=path;
 replaceC(result,'/','\');
 replaceSC(result,'\\','\',false);
end;

Function CompChar(c : Char) : Char;
//used for file starts with and ends with
begin
 if (c in ['/','\'])
  then result:='\'
  else result:=Upcase(c);
end;

function FileEndsWith(const Ends,str : string) : Boolean;
var i,j:integer;
begin
 Result:=Length(Str)>=Length(ends);
 if Result then
 begin
  i:=length(ends);
  j:=length(str);
  repeat
   if CompChar(ends[i])<>CompChar(str[j]) then
   begin
    Result:=False;
    Exit;
   end;
   dec(i);
   dec(j);
  until (i<=0);
 end;
end;

function FileStartsWith(const Starts,str : string) : Boolean;
var i:integer;
begin
 Result:=Length(Str)>=Length(starts);
 if Result then
 begin
  for i:=1 to Length(starts) do
  begin
   if CompChar(str[i])<>CompChar(starts[i]) then
   begin
    Result:=False;
    Exit;
   end;
  end;
 end;
end;


Function ValidSafeFilename(Const Filename : String) : Boolean;
var
 i:integer;
 s:string;
begin
 result:=false;
 for i:=1 to length(Filename) do
  if Filename[i] in ['/','\',':','*','?','"','<','>','|'] then
   exit;

 s:=trim(filename);
 if (s='') or (s='.') then exit;
 result:=true;
end;

Function GetSafeFilename(Const Filename : String) : String;
var i:integer;
begin
 {A file name can contain up to 215 characters, including spaces.
  However, it is not recommended that you create file names with 215
  characters. Most programs cannot interpret extremely long file names.
  File names cannot contain the following characters:
  \ / : * ? " < > |}
 result:=copy(filename,1,215);
 for i:=1 to length(result) do
  if result[i] in ['\','/',':','*','?','"','<','>','|'] then
   result[i]:='_';
 if result='' then result:='No Name'
end;

Procedure DelTree(Const Folder : String);

 function Sort(List: TStringList; Index1, Index2: Integer): Integer;
 var c1,c2:integer;
 begin
  c1:=countf(List[index1],'\',1);
  c2:=countf(List[index2],'\',1);
  result:=c1-c2;
 end;

var
 sl : TStringList;
 i:integer;
begin
 sl:=TStringList.Create;
 try
  GetFileList(folder,'*.*',true,faAnyFile,sl);
  for i:=sl.Count-1 downto 0 do
   if stringEndsWith('\..',sl[i]) then
    sl.Delete(i)
   else
   if stringEndsWith('\.',sl[i]) then
    sl.Delete(i)
   else
   if deleteFile(pchar(sl[i])) then
    sl.delete(i);

  sl.CustomSort(@Sort);

  for i:=sl.Count-1 downto 0 do
   removeDir(IncludeTrailingBackSlash(sl[i]));

  removeDir(folder);
 finally
  sl.Free;
 end;
end;

Function IncludeTrailingAnySlash(const Path : String; DefSlash : Char) : String;
begin
 result:=path;
 if (length(result)=0) or (
  (result[length(result)]<>'/') and
  (result[length(result)]<>'\')
 ) then
   result:=result+defSlash;
end;

Function IncludeTrailingSlash(const Path : String) : String;
begin
 result:=path;
 if (length(result)=0) or (result[length(result)]<>'/') then
   result:=result+'/';
end;

Function ExcludeTrailingAnySlash(const Path : String) : String;
begin
 result:=path;
 if (length(path)>0) and (
  (result[length(result)]='/') or
  (result[length(result)]='\')
 )
 then
  SetLength(result,length(result)-1);
end;

Function ExcludeTrailingSlash(const Path : String) : String;
begin
 result:=path;
 if (length(path)>0) and (result[length(result)]='/') then
  SetLength(result,length(result)-1);
end;

Function IsPathRelative(const Path : String) : boolean;
begin
 if length(path)=0 then result:=true
 else
 if (path[1]='\') or (path[1]='/') then result:=false
 else
 if (length(path)>=2) and (path[2]=':') then result:=false
 else
 result:=true;
end;

Procedure GetFileList(const Folder,Wildcard : string; Recursive : Boolean; Attr : Integer; FileList: TStrings);
var
 fs : TFileSearch;
begin
 fs:=TFileSearch.create;
 try
  fs.Recursive:=recursive;
  fs.Attr:=attr;
  fs.FileList:=FileList;
  fs.SaveFolderToo:=Recursive;
  fs.DoSearch(folder,wildcard);
 finally
  fs.free;
 end;
end;

Function GetEnvironment : String;
Type
 PByteArray = ^TByteArray;
 TByteArray = array[0..MaxLongInt-1] of Byte;
var
  p: PByteArray;
  j: Integer;
begin
 result := '';
 p := Pointer(GetEnvironmentStrings);
 j := 0; while (p^[j]<>0) or (p^[j+1]<>0) do Inc(j);
 SetLength(result, j);
 Move(p^, result[1], j);
 FreeEnvironmentStrings(Pointer(p));
end;

Function SetFileDateTime(const Filename : string; DateTime : TDateTime) : Integer;
var
 handle:thandle;
 age : Integer;
begin
 handle:=GetFileHandle(filename);
 try
  age:=DateTimeToFileDate(datetime);
  result:=FileSetDate(handle, Age);
 finally
  FindClose(handle);
 end;
end;

function GetFileHandle(const FileName: string): THandle;
var
  FindData: TWin32FindData;
begin
  result := FindFirstFile(PChar(FileName), FindData);
end;

Function IsSameFileFast(const f1,f2 : String) : Boolean;
var
 s1,s2 : string;
begin
 s1:=ExtractFilename(f1);
 s2:=ExtractFilename(f2);
 if length(s1)>5 then setlength(s1,5);
 if length(s2)>5 then setlength(s2,5);
 result:=ansicomparetext(s1,s2)=0;
 if result then
  result:=isSameFile(f1,f2);
end;

Function IsSameFile(const f1,f2 : String) : Boolean;
var
 share,cn,sn1,sn2,t : string;
 unc1,unc2 : boolean;
 p : integer;
begin
 unc1:=isUNCPath(f1);
 unc2:=isUNCPath(f2);

 if not unc1
  then sn1:=ansiuppercase(ExtractShortPathName(ExpandFilename(f1)))
  else sn1:=ansiuppercase(ExtractShortPathName(f1));

 if not unc2
  then sn2:=ansiuppercase(ExtractShortPathName(ExpandFilename(f2)))
  else sn2:=ansiuppercase(ExtractShortPathName(f2));

 replaceC(sn1,'/','\');
 replaceC(sn2,'/','\');

 if unc1=unc2 then
 begin
  result:=sn1=sn2;
  exit;
 end;
 //one is unc

 if unc2 then
 begin
  t:=sn1;
  sn1:=sn2;
  sn2:=t;
 end;
 //now sn1 has the unc name, sn2 is not unc

 cn:='\\'+uppercase(getcomputer)+'\';
 if not stringstartswith(cn,sn1) then
 begin
  result:=false;
  exit;
 end;
 delete(sn1,1,length(cn));

 p:=pos('\',sn1);
 share:=Copy(sn1,1,p-1);
 delete(sn1,1,p);
 if not GetNetShareInformation(share,t,cn) then
 begin
  t:='';
  delete(sn2,1,3);
 end;
 if t<>'' then
  sn1:=ansiuppercase(t+sn1);
 result:=sn1=sn2;
end;

function GetFileExt(const FileName : string) : string;
begin
 Result:=ExtractFileExt(FileName);
 if Length(Result)>0
  then Delete(Result,1,1);
end;

Function ChangeFileExtension(const filename,ext : string) : String;
var
 s:string;
begin
 s:=ExtractFileExt(filename);
 result:=ExtractPathNoExt(filename)+ext;
end;

function UpFileExt(const FileName : string) : string;
begin
 Result:=UpperCase(GetFileExt(Filename));
end;

Function ExtractLongPathName(const path : string) : string;
begin
 if isUNCPath(path)
  then result:=path
  else result:=PathGetLongName(path);
end;

Function IsUNCPath(const path : string) : Boolean;
begin
 result:=(length(path)>=4) and
         (  ((path[1]='\') and (path[2]='\')) or
            ((path[1]='/') and (path[2]='/'))
         )
end;

function IsSubDir(dir,testdir : string) : boolean;
var c,d:integer;
begin
 if (length(dir)=0) or (length(testdir)=0) then begin result:=false; exit; end;
 dir:=IncludeTrailingBackSlash(dir);
 Testdir:=IncludeTrailingBackSlash(Testdir);
 repeat
  c:=pos('\',dir);
  d:=pos('\',testdir);
  if (c=d) and (uppercase(copy(dir,1,c))=uppercase(copy(testdir,1,d))) then
   begin
    delete(dir,1,c);
    delete(testdir,1,d);
   end
  else
   break;
 until (c=0) or (d=0);
 result:=length(dir)=0;
end;

Function GetDirDiff(const basic,bigger : string) : string;
begin
 result:=ExtractRelativepath(basic,bigger);
end;

function ExtractFileNoExt(const f:string) : string;
var a:integer;
begin
 result:=extractfilename(f);
 a:=length(result);
 while (a>0) and (result[a]<>'.') do dec(a);
 if a<>0 then result:=copy(result,1,a-1);
end;


Function ExtractPathNoExt(const path : string) : string;
var p,s:integer;
begin
 p:=scanb(path,'.',0);
 s:=scanb(path,'\',0);
 if s<p
  then result:=copy(path,1,p-1)
  else result:=path;
end;

Function GetAbovePath(Const AbsPath : string) : String;
var i:integer;
begin
 result:=ExcludeTrailingBackSlash(Abspath);
 i:=ScanB(result,'\',0);
 if i=0
  then result:=result+'\'
  else setlength(result,i);
end;

Function GetRelativeFile(const Mainpath,FindPath : String) : string;
var f,d:string;
begin
 f:=ExtractFileName(findPath);
 d:=ExtractFilePath(findPath);
 result:=GetRelativePath(mainpath,d)+f;
end;

Function GetAbsoluteFile(const Mainpath,FindPath : String) : string;
var f,d:string;
begin
 f:=ExtractFileName(findPath);
 d:=ExtractFilePath(findPath);
 result:=GetAbsolutePath(mainpath,d)+f;
end;

Function GetAbsolutePath(const Mainpath,FindPath : String) : string;
var
 main : string;
 f:boolean;
begin
 if (length(mainpath)=0) then
 begin
  result:='';
  exit;
 end;
 if (length(findpath)=0) or (findpath='.') or (findpath='./') or (findpath='.\') then
 begin
  result:=IncludeTrailingBackSlash(mainpath);
  exit;
 end;
 main:=IncludeTrailingBackSlash(mainpath);
 replaceC(main,'/','\');
 result:=IncludeTrailingBackSlash(FindPath);
 replaceC(result,'/','\');
 if (not (result[1] in ['.','\'])) then
  if (length(result)<=2) or (result[2]<>':') then
 begin
  result:=IncludeTrailingBackSlash(main+result);
  exit;
 end;
 if StringStartsWith('.\',result) then
 begin
  delete(result,1,2);
  insert(main,result,1);
 end;
 f:=false;
 while StringStartsWith('..\',result) do
 begin
  f:=true;
  delete(result,1,3);
  main:=GetAbovePath(main);
 end;
 if f then insert(main,result,1);
 result:=IncludeTrailingBackSlash(result);
end;

function GetRelativePath(const Mainpath,FindPath : String) : string;
var main,sub : string;
a,c,d:integer;
begin
 result:='';
 if (length(mainpath)=0) or (length(findpath)=0) then exit;
 main:=IncludeTrailingBackSlash(mainpath);
 sub:=IncludeTrailingBackSlash(FindPath);
 repeat
  c:=pos('\',main);
  d:=pos('\',sub);
  if (c=d) and (uppercase(copy(main,1,c))=uppercase(copy(sub,1,d))) then begin
   delete(main,1,c);
   delete(sub,1,d);
  end else break;
 until (c=0) or (d=0);
 if length(main)=0 then begin result:=sub; exit; end;
 if (pos(':',main)<>0) or (pos(':',sub)<>0) then begin result:=sub; exit; end;
 a:=CountF(main,'\',1);
 for c:=1 to a do result:=result+'..\';
 result:=result+sub;
 if result[length(result)]<>'\' then result:=result+'\';
end;

Function GetDriveLetters(SearchType : cardinal) : string;
var c:integer;
    s:string;
begin
 try
  s:=GetDrives;
  for c:=1 to length(s) do
   if s[c] in ['A'..'Z'] then
    if GetDriveType(pchar(s[c]+':\'))=searchtype then
     result:=result+s[c];
 except
 end;
end;

Function GetAssociatedEXE(const ext : string; out desc,path : String) : string;
var
 reg : TRegistry;
 s:string;
 i:integer;
begin
 result:='';
 try
  reg:=TRegistry.create;
  try
   Reg.RootKey := HKEY_CLASSES_ROOT;
   reg.openkey('\.'+ext,false);
   desc:=reg.ReadString('');
   reg.openkey('\'+desc+'\shell\open\command',false);
   s:=reg.ReadString('');
   path:=s;
   s:=uppercase(s);
   setquotes('"','"');
   i:=1;
   result:=parse(s,' ',i);
   SetLength(result,DeleteC(result,#34));
  finally
   reg.free;
  end;
 except
 end;
end;

Procedure SetAssociatedEXE(const ext,desc,path : string);
var
 reg : TRegistry;
begin
 try
  reg:=TRegistry.create;
  try
   Reg.RootKey := HKEY_CLASSES_ROOT;
   reg.openkey('\.'+ext,true);
   reg.WriteString('',desc);
   reg.openkey('\'+desc+'\shell\open\command',true);
   reg.WriteString('',path);
  finally
   reg.free;
  end;
 except
 end;
end;

Function DirContainsFilesOrFolders(const Path : String) : boolean;
var
 sr:TsearchRec;
begin
 try
  result:=findfirst(includeTrailingBackSlash(Path)+'*.*',faAnyFile,sr)=0;
  while result and ((sr.Name='.') or (sr.Name='..')) do
   result:=FindNext(sr)=0;
 finally
  sysutils.FindClose(sr);
 end;
end;

constructor TFileSearch.create;
begin
 attr:=faArchive;
 Recursive:=true;
 OnFoundFile:=nil;
 Terminated:=false;
 inherited create;
end;

procedure TFileSearch.Findallfiles(const path,wildcard : string);
var sr:TsearchRec;
begin
 if findfirst(path + wildcard,Attr,sr) = 0 then
 try
  repeat
   if assigned(OnFoundFile) then OnFoundFile(path,sr);
   if assigned(FileList) then
   begin
    if SaveFolderToo
     then FileList.AddObject(path+sr.Name,TObject(sr.Attr))
     else FileList.AddObject(sr.Name,TObject(sr.Attr))
   end;
  until (findnext(sr)<>0) or Terminated;
 finally
  sysutils.FindClose(sr);
 end;
end;

procedure TFileSearch.DoSearch(path, wildCard: string);
begin
 path:=IncludeTrailingBackslash(path);
 findallfiles(path,wildcard);
 if recursive then DoTheSearch(Path,wildCard);
end;

procedure TFileSearch.DoTheSearch(path, wildCard: string);
var sr:TsearchRec;
begin
 if findfirst(path + '*.*',faDirectory,sr) = 0
 then
  try
   repeat
    if ((Sr.Attr and fadirectory)<>0)
       and (sr.name[1]<>'.') and (not Terminated) then
    begin
     findallfiles(Path+sr.name+'\',wildcard);
     doThesearch(path+sr.name+'\',wildcard);
    end;
   until (findnext(sr)<>0) or Terminated;
  finally
   sysutils.FindClose(sr);
  end;
end;
{
procedure WriteStr(S: String; Stream: TStream);
var
 i:LongWord;
begin
 i:=length(s);
 stream.Write(i,sizeof(i));
 stream.write(pchar(s)^,i);
end;

Procedure ReadStr(out S: String; Stream: TStream); overload;
var
 i:LongWord;
begin
 stream.Read(i,sizeof(i));
 if stream.Size-stream.Position>=i then
 begin
  setlength(s,i);
  stream.Read(pchar(s)^,i);
 end
  else s:='';
end;

Function ReadStr(Stream : TStream) : String; overload;
var
 i:LongWord;
begin
 stream.Read(i,sizeof(i));
 setlength(result,i);
 stream.Read(pchar(result)^,i);
end;


procedure WriteStr32(S: String; Stream: TStream);
var
 i:Word;
begin
 i:=length(s);
 stream.Write(i,sizeof(i));
 stream.write(pchar(s)^,i);
end;

Procedure ReadStr32(out S: String; Stream: TStream); overload;
var
 i:Word;
begin
 stream.Read(i,sizeof(i));
 setlength(s,i);
 stream.Read(pchar(s)^,i);
end;
}

Function GetNetShareInformation(Share : string; out Path,Remark : String) : Boolean;
var
  Reg: TRegistry;
  P : String;
  buf : array[1..1024] of char;
  l : integer;
begin
  result:=false;
  share:=Uppercase(share);
  Reg := TRegistry.Create;
  Reg.Access:=KEY_READ;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Network\LanMan\'+share,False) then
    //win95
    begin
     if reg.ValueExists('Path') then
     begin
      Path:=includetrailingBackSlash(Reg.ReadString('Path'));
      result:=true;
     end;
     if reg.ValueExists('Remark') then
      Remark:=Reg.ReadString('Remark');
    end
     else
    if reg.openkey('\SYSTEM\CurrentControlSet\Services\lanmanserver\Shares',false) then
    // WINNT
    begin
     if reg.ValueExists(Share) then
     begin
      l:=reg.ReadBinaryData(Share,buf,sizeof(buf));
      setlength(p,l);
      move(buf[1],p[1],l);
      delete(p,1,pos('Path=',p)+4);
      delete(p,pos(#0,p),length(p));
      path:=includetrailingBackSlash(p);
      result:=true;
     end;
    end;
  finally
   reg.free;
  end;
end;

////////////////////////////////////////////////////////////////////////
//Works only on win NT

Type
  PSHARE_INFO_2=^SHARE_INFO_2;
  _SHARE_INFO_2 = Record
   shi2_netname: PWideChar;
   shi2_type: DWORD;
   shi2_remark: PWideChar;
   shi2_permissions: DWORD;
   shi2_max_uses: Integer;
   shi2_current_uses: DWORD;
   shi2_path: PWideChar;
   shi2_passwd: PWideChar;
 End;

 SHARE_INFO_2 = _SHARE_INFO_2;

 TNetShareGetInfo =
   Function (servername:PWideChar; netname:PWideChar;
             level:DWORD; bufptr:Pointer): LongInt;

 TNetApiBufferFree =
  function (Buffer:Pointer):LongInt;

var
 NetShareGetInfo : TNetShareGetInfo;
 NetApiBufferFree : TNetApiBufferFree;
 NetApi:THandle = 0;

Procedure LoadNetApi;
begin
 NetApi:=LoadLibrary('netapi32.dll');
 if NetApi<>0 then
 begin
  NetShareGetInfo:=GetProcAddress(NetApi,'NetShareGetInfo');
  NetApiBufferFree:=GetProcAddress(NetApi,'NetApiBufferFree');
 end;
end;

Procedure FreeNetApi;
begin
 if NetApi<>0 then FreeLibrary(netApi);
end;

Procedure GetNTNetShareInformation(const Server,Share : string; out Path,Remark : String);
var
 buf: PSHARE_INFO_2;
 Size:Integer;
 ServerName:PWideChar;
 ShareName:PWideChar;
begin
 if NetApi=0 then LoadNetApi;
 if (not assigned(NetApiBufferFree)) or
    (not assigned(NetShareGetInfo)) then
 begin
  Path:='';
  Remark:='';
  exit;
 end;
 Size := SizeOf (WideChar) * 256;
 if server<>'' then GetMem (ServerName, Size);
 GetMem (ShareName, Size);
 if server<>''
  then StringToWideChar (Server, ServerName, Size)
  else ServerName:=nil;
 StringToWideChar (Share, ShareName, Size);
 GetMem(buf,SizeOf(Share_Info_2));
 try
  if NetShareGetInfo(ServerName,ShareName,2,@buf)=0
  then
   begin
    path:= buf^.shi2_path;
    remark:=buf^.shi2_remark
   end
  else
   begin
    path:='';
    remark:='';
   end;
 finally
  if server<>'' then FreeMem(ServerName);
  FreeMem(ShareName);
  if buf<>nil then NetApiBufferFree(buf);
 end;
end;


initialization

finalization
 if netapi<>0 then FreeNetApi;
end.

