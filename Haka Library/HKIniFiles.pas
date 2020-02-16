unit HKIniFiles;

interface

uses Windows, SysUtils, Classes, IniFiles, hakahyper, hakageneral;

Procedure WriteINIStrings(const filename,section : string; Strings: TStrings);
Procedure ReadINIStrings(const filename,section : string; Strings: TStrings);

Procedure ReadTStrings(Inifile : TiniFile; const Section, Ident : String; Value : TStrings);
procedure WriteTStrings(Inifile : TiniFile; const Section, Ident : String; Value: TStrings);

Implementation

Procedure ReadTStrings(Inifile : TiniFile; const Section, Ident : String; Value : TStrings);
var
 i:integer;
 s1,s2:string;
begin
 value.Clear;
 inifile.ReadSectionValues(section,value);
 for i:=value.Count-1 downto 0 do
  if ( (ident='') or
       (stringstartswithcase(ident,value[i]))
     )
     and
     (ParseWithEqual(value[i],s1,s2)) then
   value[i]:=s2
  else
   value.Delete(i);
end;

procedure WriteTStrings(Inifile : TiniFile; const Section, Ident : String; Value: TStrings);
var i:integer;
begin
 for i:=0 to value.Count-1 do
  inifile.WriteString(section,ident+inttostr(i),(value[i]));
end;

Procedure WriteINIStrings(const filename,section : string; Strings: TStrings);
var
 ini : TInifile;
begin
 if filename='' then exit;
 ini:=TInifile.Create(filename);
 try
  WriteTStrings(ini,section,'',strings);
 finally
  ini.free;
 end;
end;

Procedure ReadINIStrings(const filename,section : string; Strings: TStrings);
var
 ini : TInifile;
begin
 if filename='' then exit;
 ini:=TInifile.Create(filename);
 try
  ReadTStrings(ini,section,'',strings);
 finally
  ini.free;
 end;
end;


end.
