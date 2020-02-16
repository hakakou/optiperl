{*******************************************************}
{                                                       }
{       Alex Ghost Library                              }
{                                                       }
{       Copyright (c) 1999,2000 Alexey Popov            }
{                                                       }
{*******************************************************}

{$I AG.INC}

unit agRegIni;

interface

uses Windows, Classes, agUtils;

// ini read functions
function IniReadStr(const IniFile,Section,Key,DefValue: string): string;
function IniReadInt(const IniFile,Section,Key: string; DefValue: integer): integer;
function IniReadBool(const IniFile,Section,Key: string; DefValue: boolean): boolean;
function IniReadColor(const IniFile,Section,Key: string; DefValue: TColor): TColor;
procedure IniReadSections(const IniFile: string; Strings: TStrings);
procedure IniReadSection(const IniFile,Section: string; Strings: TStrings);
procedure IniReadSectionValues(const IniFile,Section: string; Strings: TStrings);
// ini write functions
function IniWriteStr(const IniFile,Section,Key,Value: string): boolean;
function IniWriteInt(const IniFile,Section,Key: string; Value: integer): boolean;
function IniWriteBool(const IniFile,Section,Key: string; Value: boolean): boolean;
function IniWriteColor(const IniFile,Section,Key: string; Value: TColor): boolean;

// registry get functions
function RegGetData(const Path: string; DataType: integer; Data: pointer;
  var DataSize: integer): boolean;
function RegGetStr(const Path,DefValue: string): string;
function RegGetInt(const Path: string; DefValue: integer): integer;
function RegGetBool(const Path: string; DefValue: boolean): boolean;
function RegGetColor(const Path: string; DefValue: TColor): TColor;
procedure RegGetKeys(const Path: string; KeysList: TStrings);
procedure RegGetParams(const Path: string; ParamsList: TStrings);
procedure RegGetParamsValues(const Path: string; ParamsList: TStrings);
// registry set functions
function RegSetData(const Path: string; DataType: integer; Data: pointer;
  DataSize: integer): boolean;
function RegSetStr(const Path,Value: string): boolean;
function RegSetInt(const Path: string; Value: integer): boolean;
function RegSetBool(const Path: string; Value: boolean): boolean;
function RegSetColor(const Path: string; Value: TColor): boolean;
// other registry functions
procedure RegSplitPath(const Path: string; var Root: HKEY; var Key,Param: string);
function RegKeyExists(const Path: string): boolean;
function RegParamExists(const Path: string): boolean;
function RegDeleteParam(const Path: string): boolean;
function RegDeleteKey(const Path: string): boolean;
function RegDelete(const Path: string): boolean;
function RegHasSubKeys(const Path: string): boolean;
function RegHasParams(const Path: string): boolean;


implementation

uses SysUtils, agFileUtils;

// ini functions

var
  BoolSignStr: array [Boolean] of string = ('0','1');
  BoolSignInt: array [Boolean] of integer = (0,1);

function IniReadStr(const IniFile,Section,Key,DefValue: string): string;
begin
  SetLength(Result,1024);
  SetLength(Result,GetPrivateProfileString(PChar(Section),PChar(Key),PChar(DefValue),
    PChar(Result),length(Result),PChar(IniFile)));
end;

function IniReadInt(const IniFile,Section,Key: string; DefValue: integer): integer;
var
  err: integer;
begin
  val(IniReadStr(IniFile,Section,Key,IntToStr(DefValue)),Result,err);
  if err <> 0 then Result:=DefValue;
end;

function IniReadBool(const IniFile,Section,Key: string; DefValue: boolean): boolean;
begin
  Result:=(IniReadStr(IniFile,Section,Key,BoolSignStr[DefValue]) = BoolSignStr[true]);
end;

function IniReadColor(const IniFile,Section,Key: string; DefValue: TColor): TColor;
begin
  Result:=IniReadInt(IniFile,Section,Key,DefValue);
end;

procedure IniReadSections(const IniFile: string; Strings: TStrings);
const
  BufSize = 16384;
var
  Buffer, P: PChar;
begin
  GetMem(Buffer, BufSize);
  try
    Strings.BeginUpdate;
    try
      Strings.Clear;
      if GetPrivateProfileString(nil, nil, nil, Buffer, BufSize,
        PChar(IniFile)) <> 0 then
      begin
        P := Buffer;
        while P^ <> #0 do
        begin
          Strings.Add(P);
          Inc(P, StrLen(P) + 1);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  finally
    FreeMem(Buffer, BufSize);
  end;
end;

procedure IniReadSection(const IniFile,Section: string; Strings: TStrings);
const
  BufSize = 16384;
var
  Buffer, P: PChar;
begin
  GetMem(Buffer, BufSize);
  try
    Strings.BeginUpdate;
    try
      Strings.Clear;
      if GetPrivateProfileString(PChar(Section), nil, nil, Buffer, BufSize,
        PChar(IniFile)) <> 0 then
      begin
        P := Buffer;
        while P^ <> #0 do
        begin
          Strings.Add(P);
          Inc(P, StrLen(P) + 1);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  finally
    FreeMem(Buffer, BufSize);
  end;
end;

procedure IniReadSectionValues(const IniFile,Section: string; Strings: TStrings);
var
  KeyList: TStringList;
  i: integer;
  s: string;
begin
  KeyList:=TStringList.Create;
  try
    IniReadSection(IniFile,Section,KeyList);
    with Strings do begin
      BeginUpdate;
      try
        for i:=0 to KeyList.Count-1 do begin
          s:=KeyList[i];
          if IndexOfName(s) = -1 then
            Add(s+'='+IniReadStr(IniFile,Section,s,''))
          else
            Values[s]:=IniReadStr(IniFile,Section,s,'');
        end;
      finally
        EndUpdate;
      end;
    end;
  finally
    KeyList.Free;
  end;
end;

function IniWriteStr(const IniFile,Section,Key,Value: string): boolean;
begin
  Result:=WritePrivateProfileString(PChar(Section),PChar(Key),PChar(Value),PChar(IniFile));
end;

function IniWriteInt(const IniFile,Section,Key: string; Value: integer): boolean;
begin
  Result:=IniWriteStr(IniFile,Section,Key,IntToStr(Value));
end;

function IniWriteBool(const IniFile,Section,Key: string; Value: boolean): boolean;
begin
  Result:=IniWriteStr(IniFile,Section,Key,BoolSignStr[Value]);
end;

function IniWriteColor(const IniFile,Section,Key: string; Value: TColor): boolean;
begin
  Result:=IniWriteStr(IniFile,Section,Key,ColorToStr(Value));
end;


// registry functions

const
  HKCR = HKEY_CLASSES_ROOT;
  HKCU = HKEY_CURRENT_USER;
  HKLM = HKEY_LOCAL_MACHINE;

procedure RegSplitPath(const Path: string; var Root: HKEY; var Key,Param: string);
var
  s: string;
begin
  Key:=RemoveBackSlash(ExtractFilePath(Path));
  Param:=ExtractFileName(Path);
  s:=Copy(Key,1,5);
  Delete(Key,1,5);
  if s = 'HKCR\' then Root:=HKCR else
    if s = 'HKCU\' then Root:=HKCU else
      if s = 'HKLM\' then Root:=HKLM else exit;
end;

function RegGetData(const Path: string; DataType: integer; Data: pointer;
  var DataSize: integer): boolean;
var
  Key,Param: string;
  Root: HKEY;
  phk: HKEY;
begin
  Result:=false;
  RegSplitPath(Path,Root,Key,Param);
  if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then
    try
      Result:=(RegQueryValueEx(phk,PChar(Param),nil,@DataType,Data,@DataSize)
        = ERROR_SUCCESS);
    finally
      RegCloseKey(phk);
    end;
end;

function RegGetStr(const Path,DefValue: string): string;
var
  size: integer;
begin
  SetLength(Result,1024);
  size:=length(Result);
  if RegGetData(Path,REG_SZ,@Result[1],size) then
    SetLength(Result,size-1)
  else
    Result:=DefValue;
end;

function RegGetInt(const Path: string; DefValue: integer): integer;
var
  size: integer;
begin
  size:=SizeOf(DWORD);
  if not RegGetData(Path,REG_DWORD,@Result,size) then
    Result:=DefValue;
end;

function RegGetBool(const Path: string; DefValue: boolean): boolean;
begin
  Result:=(RegGetInt(Path,BoolSignInt[DefValue]) = BoolSignInt[true]);
end;

function RegGetColor(const Path: string; DefValue: TColor): TColor;
begin
  Result:=RegGetInt(Path,DefValue);
end;

procedure RegGetKeys(const Path: string; KeysList: TStrings);
var
  Key,Param: string;
  Root,phk: HKEY;
  KeyBuf: array [1..1024] of char;
  i,res,size: dword;
begin
  RegSplitPath(NormalDir(Path),Root,Key,Param);
  KeysList.BeginUpdate;
  try
    KeysList.Clear;
    if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then
      try
        i:=0;
        repeat
          size:=1024;
          res:=RegEnumKeyEx(phk,i,@KeyBuf,size,nil,nil,nil,nil);
          if res = ERROR_SUCCESS then begin
            KeysList.Add(PChar(@KeyBuf[1]));
            inc(i);
          end;
        until res <> ERROR_SUCCESS;
      finally
        RegCloseKey(phk);
      end;
  finally
    KeysList.EndUpdate;
  end;
end;

procedure RegGetParams(const Path: string; ParamsList: TStrings);
var
  Key,Param: string;
  Root,phk: HKEY;
  ValBuf: array [1..1024] of char;
  i,res,size: dword;
begin
  RegSplitPath(NormalDir(Path),Root,Key,Param);
  ParamsList.BeginUpdate;
  try
    ParamsList.Clear;
    if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then
      try
        i:=0;
        repeat
          size:=1024;
          res:=RegEnumValue(phk,i,@ValBuf,size,nil,nil,nil,nil);
          if res = ERROR_SUCCESS then begin
            ParamsList.Add(PChar(@ValBuf[1]));
            inc(i);
          end;
        until res <> ERROR_SUCCESS;
      finally
        RegCloseKey(phk);
      end;
  finally
    ParamsList.EndUpdate;
  end;
end;

procedure RegGetParamsValues(const Path: string; ParamsList: TStrings);
var
  Key,Param: string;
  Root,phk: HKEY;
  NameBuf,ValBuf: array [1..1024] of char;
  i,res,nsize,vsize,typ: dword;
begin
  RegSplitPath(NormalDir(Path),Root,Key,Param);
  ParamsList.BeginUpdate;
  try
    ParamsList.Clear;
    if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then
      try
        i:=0;
        repeat
          nsize:=1024;
          res:=RegEnumValue(phk,i,@NameBuf,nsize,nil,nil,nil,nil);
          if res = ERROR_SUCCESS then begin
            vsize:=1024;
            if RegQueryValueEx(phk,@NameBuf,nil,@typ,@ValBuf,@vsize) = ERROR_SUCCESS then begin
              if typ = REG_DWORD then
                ParamsList.Add(Format('%s=%d',[PChar(@NameBuf[1]),integer(ValBuf[1])]));
              if typ = REG_SZ then
                ParamsList.Add(Format('%s=%s',[PChar(@NameBuf[1]),PChar(@ValBuf[1])]));
              inc(i);
            end;
          end;
        until res <> ERROR_SUCCESS;
      finally
        RegCloseKey(phk);
      end;
  finally
    ParamsList.EndUpdate;
  end;
end;

function RegSetData(const Path: string; DataType: integer; Data: pointer;
  DataSize: integer): boolean;
var
  Key,Param: string;
  Root,phk: HKEY;
begin
  RegSplitPath(Path,Root,Key,Param);
  if RegCreateKey(Root,PChar(Key),phk) = ERROR_SUCCESS then
    try
      Result:=(RegSetValueEx(phk,PChar(Param),0,DataType,Data,DataSize) = ERROR_SUCCESS);
    finally
      RegCloseKey(phk);
    end
  else
    Result:=false;
end;

function RegSetStr(const Path,Value: string): boolean;
begin
  Result:=RegSetData(Path,REG_SZ,@Value[1],length(Value));
end;

function RegSetInt(const Path: string; Value: integer): boolean;
begin
  Result:=RegSetData(Path,REG_DWORD,@Value,SizeOf(DWORD));
end;

function RegSetBool(const Path: string; Value: boolean): boolean;
begin
  Result:=RegSetInt(Path,BoolSignInt[Value]);
end;

function RegSetColor(const Path: string; Value: TColor): boolean;
begin
  Result:=RegSetInt(Path,Value);
end;

function RegKeyExists(const Path: string): boolean;
var
  Key,Param: string;
  Root,phk: HKEY;
begin
  RegSplitPath(NormalDir(Path),Root,Key,Param);
  if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then begin
    RegCloseKey(phk);
    Result:=true;
  end else
    Result:=false;
end;

function RegParamExists(const Path: string): boolean;
var
  Key,Param: string;
  Root,phk: HKEY;
begin
  RegSplitPath(Path,Root,Key,Param);
  if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then begin
    Result:=(RegQueryValueEx(phk,PChar(Param),nil,nil,nil,nil) = ERROR_SUCCESS);
    RegCloseKey(phk);
  end else
    Result:=false;
end;

function RegDeleteParam(const Path: string): boolean;
var
  Key,Param: string;
  Root,phk: HKEY;
begin
  Result:=false;
  RegSplitPath(Path,Root,Key,Param);
  if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then begin
    Result:=(RegDeleteValue(phk,PChar(Param)) = ERROR_SUCCESS);
    RegCloseKey(phk);
  end;
end;

function RegDeleteKey(const Path: string): boolean;
var
  Key,Param: string;
  Root,phk: HKEY;
begin
  Result:=false;
  RegSplitPath(Path,Root,Key,Param);
  if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then begin
    Result:=(Windows.RegDeleteKey(phk,PChar(Param)) = ERROR_SUCCESS);
    RegCloseKey(phk);
  end;
end;

function RegDelete(const Path: string): boolean;
begin
  Result:=false;
  if RegParamExists(Path) then
    Result:=RegDeleteParam(Path)
  else
    if RegKeyExists(Path) then
      Result:=RegDeleteKey(Path);
end;

function RegHasSubKeys(const Path: string): boolean;
var
  Key,Param: string;
  Root,phk: HKEY;
  SubKeys: dword;
begin
  Result:=false;
  RegSplitPath(NormalDir(Path),Root,Key,Param);
  if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then begin
    if RegQueryInfoKey(phk,nil,nil,nil,@SubKeys,nil,nil,nil,nil,nil,nil,nil) = ERROR_SUCCESS
      then Result:=(SubKeys > 0);
    RegCloseKey(phk);
  end;
end;

function RegHasParams(const Path: string): boolean;
var
  Key,Param: string;
  Root,phk: HKEY;
  Params: dword;
begin
  Result:=false;
  RegSplitPath(NormalDir(Path),Root,Key,Param);
  if RegOpenKey(Root,PChar(Key),phk) = ERROR_SUCCESS then begin
    if RegQueryInfoKey(phk,nil,nil,nil,nil,nil,nil,@Params,nil,nil,nil,nil) = ERROR_SUCCESS
      then Result:=(Params > 0);
    RegCloseKey(phk);
  end;
end;

end.
