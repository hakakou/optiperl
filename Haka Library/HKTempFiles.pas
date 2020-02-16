unit HKTempFiles;

interface
uses classes,sysutils,hyperstr,hakafile;

Procedure SetTempOptions(Const Prefix : String; Numbers : Integer);
Procedure DeleteTempFiles;
Function CreateTempFile(Const folder,Extension : String) : String; Overload;
Function CreateTempFile(Const Extension : String) : String; Overload;

implementation
var
 UsedTempFiles : TStringList;
 MaxNumbers : Integer = 6;
 ThePrefix  : String = 'XF';

Function GetTempName(Const Ext : String) : String;
var i:integer;
begin
 result:=ThePrefix;
 setlength(result,length(ThePrefix)+MaxNumbers);
 for i:=length(thePrefix)+1 to length(result) do
  result[i]:=chr(random(10)+48);
 result:=result+Ext;
end;

Function CheckTempFile(const Filename : String) : Boolean;
var
 fs:TFileStream;
begin
 result:=false;
 try
  fs:=TFileStream.Create(Filename,fmCreate,fmShareDenyNone);
  try
   result:=true;
  finally
   fs.free;
  end;
 except
  on exception do
 end;
end;


Function CreateTempFile(Const folder,Extension : String) : String;
var s:string;
begin
 repeat
  result:=IncludeTrailingPathDelimiter(Folder)+GetTempName(Extension);
  if not fileexists(result) then break;
 until false;
 if CheckTempFile(result) then
  begin
   result:=ExtractShortPathName(result);
   UsedTempFiles.Add(result);
  end
 else
  begin
   result:=GetTmpFile(GetTmpDir,ThePrefix);
   s:=result+Extension;
   if CheckTempFile(s) then
   begin
    deletefile(result);
    result:=s;
   end;
   result:=ExtractShortPathName(result);
   UsedTempFiles.Add(result);
  end;
end;

Function CreateTempFile(Const Extension : String) : String;
begin
 result:=CreateTempFile(GetTmpDir,extension);
end;

Procedure DeleteTempFiles;
var i:integer;
begin
 for i:=0 to UsedTempFiles.Count-1 do
  DeleteFile(UsedTempFiles[i]);
 UsedTempFiles.Clear;
end;

Procedure SetTempOptions(Const Prefix : String; Numbers : Integer);
begin
 MaxNumbers:=Numbers;
 ThePrefix:=Prefix;
end;

initialization
 UsedTempFiles:=TStringList.Create;
 Randomize;
finalization
 DeleteTempFiles;
 UsedTempFiles.Free;
end.
