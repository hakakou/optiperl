{*******************************************************}
{                                                       }
{       Alex Ghost Library                              }
{                                                       }
{       Copyright (c) 1999,2000 Alexey Popov            }
{                                                       }
{*******************************************************}

{$I AG.INC}

unit agFileUtils;

interface

uses Windows;

function agFileOpen(const FileName: string; AccessMode,ShareMode,CreationDistribution,
  FlagsAndAttributes: integer): integer;
procedure agFileClose(var FileHandle: integer);
procedure agFileReadln(FileHandle: integer; var S: string);
procedure agFileWriteln(FileHandle: integer; S: string);
function agFileGetPointer(FileHandle: integer): integer;
function agFileEOF(FileHandle: integer): boolean;

function UniqueFileNameInDir(Path: string): string;
function DirExists(Name: string): Boolean;
function DirectoryExists(Name: string): Boolean;
function ExpandRelativePath(const Path, RelPath: string): string;
function IsEqualFileTime(T1,T2: TFileTime): boolean;
function DiskFreeSpaceKB(const Path: string): dword;
function DeleteFileSure(const FileName: string): boolean;
procedure DeleteFileDelayed(const FileName: string);
procedure ReplaceFileDelayed(const SrcFile,DstFile: string);

// functions from RxLib (http://www.rxlib.com)

{$IFDEF D4}
function GetFileSize(const FileName: string): Int64;
{$ELSE}
function GetFileSize(const FileName: string): Longint;
{$ENDIF}
function FileDateTime(const FileName: string): TDateTime;
function HasAttr(const FileName: string; Attr: Integer): Boolean;
function ClearDir(const Path: string; Delete: Boolean): Boolean;
function NormalDir(Dir: string): string;
function RemoveBackSlash(const DirName: string): string;
procedure ForceDirectories(Dir: string);

function ShortToLongFileName(const ShortName: string): string;
function ShortToLongPath(const ShortName: string): string;
function LongToShortFileName(const LongName: string): string;
function LongToShortPath(const LongName: string): string;

implementation

uses SysUtils, agStrUtils, agDateUtils, agArithm, agUtils, agRegIni;

function agFileOpen(const FileName: string; AccessMode,ShareMode,CreationDistribution,
  FlagsAndAttributes: Integer): Integer;
begin
  Result := CreateFile(PChar(FileName), AccessMode, ShareMode, nil, CreationDistribution,
    FlagsAndAttributes, 0);
end;

procedure agFileClose(var FileHandle: integer);
begin
  FileClose(FileHandle);
  FileHandle:=0;
end;

function agFileGetPointer(FileHandle: integer): integer;
begin
  Result:=SetFilePointer(FileHandle,0,nil,FILE_CURRENT);
end;

function agFileEOF(FileHandle: integer): boolean;
begin
  if DWORD(agFileGetPointer(FileHandle)) < Windows.GetFileSize(FileHandle,nil) then
    Result:=false
  else
    Result:=true;
end;

procedure agFileReadln(FileHandle: integer; var S: string);
const
  MaxLen = 100;
var
  Buf,s1: string;
  n: integer;
begin
  S:='';
  repeat
    SetLength(Buf,MaxLen);
    n:=FileRead(FileHandle,Buf[1],MaxLen);
    if n = 0 then exit;
    SetLength(Buf,n);
    s1:=Copy2Symb(Buf,#13);
    S:=S+DelChars(s1,#10);
  until length(s1) < n;
  SetFilePointer(FileHandle,length(s1)-n+1,nil,FILE_CURRENT);
end;

procedure agFileWriteln(FileHandle: integer; S: string);
begin
  S:=S+#13#10;
  FileWrite(FileHandle,S[1],length(S));
end;

function FileDateTime(const FileName: string): System.TDateTime;
var
  Age: Longint;
begin
  Age := FileAge(FileName);
  if Age = -1 then
    Result := 0
  else
    Result := FileDateToDateTime(Age);
end;

function HasAttr(const FileName: string; Attr: Integer): Boolean;
var
  FileAttr: Integer;
begin
  FileAttr := FileGetAttr(FileName);
  Result := (FileAttr >= 0) and (FileAttr and Attr = Attr);
end;

function UniqueFileNameInDir(Path: string): string;
var
  s,fn: string;
  SystemTime: TSystemTime;
  i,iDay,iDate,iTime: integer;
begin
  if Path[length(Path)] <> '\' then Path:=Path+'\';
  repeat
    GetLocalTime(SystemTime);
    with SystemTime do begin
      iDay:=wDay;
      for i:=1 to wMonth - 1 do Inc(iDay,MonthDays[IsLeapYear(wYear),wMonth]);
      i:=wYear mod 10;
      iDate:=i*365 + i div 4 + iDay;
      iTime:=wHour*360000 + wMinute*6000 + wSecond*100 + wMilliSeconds div 10;
    end;
    s:=Dec2Numb(iDate,3,32)+Dec2Numb(iTime,5,32);
    fn:=Format('%s%s',[Path,s]);
  until not(FileExists(fn));
  Result:=s;
end;

function DirectoryExists(Name: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function DirExists(Name: string): Boolean;
begin
  Result:=DirectoryExists(Name);
end;

{$I-}
function ClearDir(const Path: string; Delete: Boolean): Boolean;
const
  FileNotFound = 18;
var
  FileInfo: TSearchRec;
  DosCode: Integer;
begin
  Result := DirectoryExists(Path);
  if not Result then Exit;
  DosCode := FindFirst(NormalDir(Path) + '*.*', faAnyFile, FileInfo);
  try
    while DosCode = 0 do begin
      if (FileInfo.Name[1] <> '.') and (FileInfo.Attr <> faVolumeID) then
      begin
        if (FileInfo.Attr and faDirectory = faDirectory) then
          Result := ClearDir(NormalDir(Path) + FileInfo.Name, Delete) and Result
        else if (FileInfo.Attr and faVolumeID <> faVolumeID) then begin
          if (FileInfo.Attr and faReadOnly = faReadOnly) then
            FileSetAttr(NormalDir(Path) + FileInfo.Name, faArchive);
          Result := DeleteFileSure(NormalDir(Path) + FileInfo.Name) and Result;
        end;
      end;
      DosCode := FindNext(FileInfo);
    end;
  finally
    FindClose(FileInfo);
  end;
  if Delete and Result and (DosCode = FileNotFound) and
    not ((Length(Path) = 2) and (Path[2] = ':')) then
  begin
    RmDir(Path);
    Result := (IOResult = 0) and Result;
  end;
end;
{$I+}

function NormalDir(Dir: string): string;
begin
  if length(Dir) > 0 then
    if Dir[length(Dir)] <> '\' then Dir:=Dir+'\';
  Result:=Dir;
end;

{$IFDEF D4}
function GetFileSize(const FileName: string): Int64;
var
  Handle: THandle;
  FindData: TWin32FindData;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      Int64Rec(Result).Lo := FindData.nFileSizeLow;
      Int64Rec(Result).Hi := FindData.nFileSizeHigh;
      Exit;
    end;
  end;
  Result := -1;
end;
{$ELSE}
function GetFileSize(const FileName: string): Longint;
var
  SearchRec: TSearchRec;
begin
  if FindFirst(ExpandFileName(FileName), faAnyFile, SearchRec) = 0 then
    Result := SearchRec.Size
  else Result := -1;
  FindClose(SearchRec);
end;
{$ENDIF}

function RemoveBackSlash(const DirName: string): string;
begin
  Result := DirName;
  if (Length(Result) > 1) and (AnsiLastChar(Result)^ = '\') then begin
    if not ((Length(Result) = 3) and (UpCase(Result[1]) in ['A'..'Z']) and
      (Result[2] = ':')) then
      Delete(Result, Length(Result), 1);
  end;
end;

procedure ForceDirectories(Dir: string);
begin
  if Length(Dir) = 0 then Exit;
  if (AnsiLastChar(Dir) <> nil) and (AnsiLastChar(Dir)^ = '\') then
    Delete(Dir, Length(Dir), 1);
  if (Length(Dir) < 3) or DirectoryExists(Dir) or
    (ExtractFilePath(Dir) = Dir) then Exit;
  ForceDirectories(ExtractFilePath(Dir));
  CreateDir(Dir);
end;

function ShortToLongFileName(const ShortName: string): string;
var
  Temp: TWin32FindData;
  SearchHandle: THandle;
begin
  SearchHandle := FindFirstFile(PChar(ShortName), Temp);
  if SearchHandle <> INVALID_HANDLE_VALUE then begin
    Result := string(Temp.cFileName);
    if Result = '' then Result := string(Temp.cAlternateFileName);
  end
  else Result := '';
  Windows.FindClose(SearchHandle);
end;

function LongToShortFileName(const LongName: string): string;
var
  Temp: TWin32FindData;
  SearchHandle: THandle;
begin
  SearchHandle := FindFirstFile(PChar(LongName), Temp);
  if SearchHandle <> INVALID_HANDLE_VALUE then begin
    Result := string(Temp.cAlternateFileName);
    if Result = '' then Result := string(Temp.cFileName);
  end
  else Result := '';
  Windows.FindClose(SearchHandle);
end;

function ShortToLongPath(const ShortName: string): string;
var
  LastSlash: PChar;
  TempPathPtr: PChar;
begin
  Result := '';
  TempPathPtr := PChar(ShortName);
  LastSlash := StrRScan(TempPathPtr, '\');
  while LastSlash <> nil do begin
    Result := '\' + ShortToLongFileName(TempPathPtr) + Result;
    if LastSlash <> nil then begin
      LastSlash^ := char(0);
      LastSlash := StrRScan(TempPathPtr, '\');
    end;
  end;
  Result := TempPathPtr + Result;
end;

function LongToShortPath(const LongName: string): string;
var
  LastSlash: PChar;
  TempPathPtr: PChar;
begin
  Result := '';
  TempPathPtr := PChar(LongName);
  LastSlash := StrRScan(TempPathPtr, '\');
  while LastSlash <> nil do begin
    Result := '\' + LongToShortFileName(TempPathPtr) + Result;
    if LastSlash <> nil then begin
      LastSlash^ := char(0);
      LastSlash := StrRScan(TempPathPtr, '\');
    end;
  end;
  Result := TempPathPtr + Result;
end;

function ExpandRelativePath(const Path, RelPath: string): string;
var
  s: string;
begin
  s:=Path;
  if length(ExtractFileDrive(s)) = 0 then begin
    while (Copy(s,1,1) = '\') or (Copy(s,1,1) = '/') do Delete(s,1,1);
    s:=NormalDir(RelPath)+s;
  end;
  Result:=s;
end;

function IsEqualFileTime(T1,T2: TFileTime): boolean;
begin
  if (T1.dwLowDateTime = T2.dwLowDateTime) and (T1.dwHighDateTime = T2.dwHighDateTime) then
    Result:=true
  else
    Result:=false;
end;

function DiskFreeSpaceKB(const Path: string): dword;

  function DiskFreeSpace95(const Path: string): dword;
  var
    SectorsPerCluster,
    BytesPerSector,
    NumberOfFreeClusters,
    TotalNumberOfClusters: dword;
  begin
    Result:=0;
    if GetDiskFreeSpace(PChar(Path),SectorsPerCluster,BytesPerSector,
      NumberOfFreeClusters,TotalNumberOfClusters)
      then Result:=Round(((BytesPerSector*SectorsPerCluster)/1024)*NumberOfFreeClusters);
  end;

type
  TGetDiskFreeSpaceEx = function(lpDirectoryName: PChar;
    lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes,
    lpTotalNumberOfFreeBytes: PInt64): BOOL; stdcall;

var
  Lib: HModule;
  GetFreeSpaceProc: TGetDiskFreeSpaceEx;
  FreeBytesAvailableToCaller,
  TotalNumberOfBytes,
  TotalNumberOfFreeBytes: Int64;
begin
  Result:=0;
  if not DirExists(Path) then exit;
  if (OSVersion.Platform in [plWin32s,plWin95]) and (OSVersion.Build < 1111) then
    Result:=DiskFreeSpace95(Path)
  else begin
    Lib:=LoadLibrary('kernel32.dll');
    if Lib <> 0 then
      try
        GetFreeSpaceProc:=GetProcAddress(Lib,'GetDiskFreeSpaceExA');
        if Assigned(GetFreeSpaceProc) then
          if GetFreeSpaceProc(PChar(Path),@FreeBytesAvailableToCaller,
            @TotalNumberOfBytes,@TotalNumberOfFreeBytes) then
            {$IFDEF D4}
            Result:=(FreeBytesAvailableToCaller shr 10);
            {$ELSE}
            Result:=(FreeBytesAvailableToCaller.Hi shl 22) or
            (FreeBytesAvailableToCaller.Lo shr 10);
            {$ENDIF}
      finally
        FreeLibrary(Lib);
      end;
  end;
end;

function DeleteFileSure(const FileName: string): boolean;
begin
  SetFileAttributes(PChar(FileName),FILE_ATTRIBUTE_NORMAL);
  Result:=DeleteFile(FileName);
end;

procedure DeleteFileDelayed(const FileName: string);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    MoveFileEx(PChar(FileName),nil,MOVEFILE_DELAY_UNTIL_REBOOT)
  else
    IniWriteStr(NormalDir(GetWindowsDir)+'wininit.ini','Rename','NUL',FileName);
end;

procedure ReplaceFileDelayed(const SrcFile,DstFile: string);
var
  Ini: string;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    MoveFileEx(PChar(DstFile),nil,MOVEFILE_DELAY_UNTIL_REBOOT);
    MoveFileEx(PChar(SrcFile),PChar(DstFile),MOVEFILE_DELAY_UNTIL_REBOOT);
  end else begin
    Ini:=NormalDir(GetWindowsDir)+'wininit.ini';
    IniWriteStr(Ini,'Rename','NUL',DstFile);
    IniWriteStr(Ini,'Rename',DstFile,SrcFile);
  end;
end;

end.
