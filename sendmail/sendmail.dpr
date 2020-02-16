program sendmail;
{$APPTYPE CONSOLE}
uses
  SysUtils,windows,messages;

var
 text : String;

const
 HK_SendMail = WM_User + $3023;

procedure SaveStr(Source,FileName:AnsiString);
var
  F:File;
  SaveMode:Integer;
begin
  AssignFile(F,FileName);
  SaveMode:=FileMode;
  FileMode:=1;            //always set this regardless of what docs say
  try
    Rewrite(F,1);
    try
      BlockWrite(F,Source[1],Length(Source));
    finally
      CloseFile(F);
    end;
  except
    on EInOutError do raise Exception.Create('Error writing to '+Filename);
  end;
  FileMode:=SaveMode;
end;

Function GetStrRegValue(RK : HKEY; Const Path,Name : String) : String;
var
 h : HKEY;
 buff : string;
 l : cardinal;
 p  : Integer;
begin
 result:=#0;
 l:=1000;
 setlength(buff,l);
 if RegOpenKeyEx(RK,pchar(path),0,KEY_READ,h)=ERROR_SUCCESS then
 begin
  if ERROR_SUCCESS=RegQueryValueEx(h,pchar(name),nil,@p,pbyte(@buff[1]),@l) then
  begin
   SetLength(buff,l-1);
   result:=buff;
  end;
  RegCloseKey(h);
 end
end;

procedure readtext;
var
 s:string;
begin
 text:='';
 while not eof do
 begin
  readln(input,s);
  text:=text+s+#13#10;
 end;
// writeln('-----'+#13#10+text+#13#10+'======');
end;


Procedure SendText;
var
 opti : THandle;
 s:string;
 i:integer;
begin
 opti:=FindWindow('TOptiMainForm',Nil);
 if Opti=0 then exit;
 Randomize;
 i:=random(999999);
 s:=GetStrRegValue(HKEY_CURRENT_USER,'Software\Xarka\OptiPerl','UserFolder');
 s:=IncludeTrailingBackSlash(s)+'Settings\';
 if (not directoryExists(s)) then
 begin
  MessageBox(0,pchar('Could not find OptiPerl''s Application Data Folder.'+#13+#10+'Please re-install.'),pchar('OptiPerl'),MB_OK or MB_ICONERROR);
  exit;
 end;
 s:=s+'sm'+inttostr(i)+'.txt';
 try
  saveStr(text,s);
  SendMessage(opti,HK_SendMail,i,0);
 except on exception do end;
 deleteFile(pchar(s));
end;

begin
 try
  readtext;
  SendText;
 except on exception do end;
end.
