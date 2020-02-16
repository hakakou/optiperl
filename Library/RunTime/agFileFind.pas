{*******************************************************}
{                                                       }
{       Alex Ghost Library                              }
{                                                       }
{       Copyright (c) 1999,2000 Alexey Popov            }
{                                                       }
{*******************************************************}

{$I AG.INC}

unit agFileFind;

interface

uses SysUtils, Windows;

const
  faNotFiles = faDirectory or faVolumeID;

type
  TSearchRecEx = record
    Time: Integer;    Size: Integer;    Attr: Integer;    Name: TFileName;    IncludeAttr: Integer;    ExcludeAttr: Integer;    FindHandle: THandle;    FindData: TWin32FindData;  end;

function agFindFirst(const Path: string; Attr: Integer; var F: TSearchRec): Integer;
function agFindNext(var F: TSearchRec): Integer;
procedure agFindClose(var F: TSearchRec);

function FindFirstEx(const Path: string; IncludeAttr, ExcludeAttr: Integer;
  var F: TSearchRecEx): Integer;
function FindNextEx(var F: TSearchRecEx): Integer;
procedure FindCloseEx(var F: TSearchRecEx);

implementation

function agFindFirst(const Path: string; Attr: Integer; var F: TSearchRec): Integer;
begin
  Result:=SysUtils.FindFirst(Path,Attr,F);
  if (F.FindHandle <> INVALID_HANDLE_VALUE) and (Result <> 0) then
    F.FindHandle:=INVALID_HANDLE_VALUE;
end;

function agFindNext(var F: TSearchRec): Integer;
begin
  Result:=SysUtils.FindNext(F);
end;

procedure agFindClose(var F: TSearchRec);
begin
  SysUtils.FindClose(F);
  F.FindHandle:=INVALID_HANDLE_VALUE;
end;

function FindMatchingFileProc(var F: TSearchRecEx): Integer;
var
  LocalFileTime: TFileTime;
  bRec: boolean;
begin
  with F do begin
    repeat
      if (FindData.dwFileAttributes and IncludeAttr) <> 0 then bRec:=true else bRec:=false;
      if (FindData.dwFileAttributes and ExcludeAttr) <> 0 then bRec:=false;
      if  (FindData.cFileName = string('.')) or (FindData.cFileName = '..') then bRec:=false;
      if not bRec then
        if not FindNextFile(FindHandle, FindData) then begin
          Result := GetLastError;
          Exit;
        end;
    until bRec;
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,
      LongRec(Time).Lo);
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

function FindFirstEx(const Path: string; IncludeAttr, ExcludeAttr: Integer;
  var F: TSearchRecEx): Integer;
begin
  if IncludeAttr = 0 then IncludeAttr:=faAnyFile;
  F.IncludeAttr := IncludeAttr;
  F.ExcludeAttr := ExcludeAttr;
  F.FindHandle := FindFirstFile(PChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then begin
    Result := FindMatchingFileProc(F);
    if Result <> 0 then begin
      FindCloseEx(F);
      F.FindHandle:=INVALID_HANDLE_VALUE;
    end;
  end else
    Result := GetLastError;
end;

function FindNextEx(var F: TSearchRecEx): Integer;
begin
  if FindNextFile(F.FindHandle, F.FindData) then
    Result := FindMatchingFileProc(F) else
    Result := GetLastError;
end;

procedure FindCloseEx(var F: TSearchRecEx);
begin
  if F.FindHandle <> INVALID_HANDLE_VALUE then
    Windows.FindClose(F.FindHandle);
end;

end.
