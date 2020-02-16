{***************************************************************
 *
 * Unit Name: OptAssociations
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptAssociations;  //Unit

interface
uses HKRegistry,sysutils;

Function CheckOptiAssociations : Boolean;
Procedure AddPerlAssociations;
Procedure RemovePerlAssociation;
Procedure AddOptiAssociations;
Procedure RemoveOptiAssociation;

const
 FriendlyName = 'OptiPerl Visual Environment';


implementation

var
 OptiAssocs : array[1..7] of TAssociation = (
 (SubKey:'optiperl.cgi'; Extension:'.cgi'; DefaultIcon:1;
  ExeName:''; Command:'Edit'; CommandDescription : '&Edit';
  ExtensionDesc:'OptiPerl CGI Script'; Parameters:'"%1"';
  FriendlyName:FriendlyName; ShellNew : true),

 (SubKey:'optiperl.pl'; Extension:'.pl'; DefaultIcon:2;
  ExeName:''; Command:'Edit'; CommandDescription : '&Edit';
  ExtensionDesc:'OptiPerl Script'; Parameters:'"%1"';
  FriendlyName:FriendlyName; ShellNew : true),

 (SubKey:'optiperl.pm'; Extension:'.pm'; DefaultIcon:3;
  ExeName:''; Command:'Edit'; CommandDescription : '&Edit';
  ExtensionDesc:'OptiPerl Module'; Parameters:'"%1"';
  FriendlyName:FriendlyName; ShellNew : true),

 (SubKey:'optiperl.plx'; Extension:'.plx'; DefaultIcon:4;
  ExeName:''; Command:'Edit'; CommandDescription : '&Edit';
  ExtensionDesc:'OptiPerl PLX Script'; Parameters:'"%1"';
  FriendlyName:FriendlyName; ShellNew : true),

 (SubKey:'optiperl.pod'; Extension:'.pod'; DefaultIcon:5;
  ExeName:''; Command:'Open'; CommandDescription : '&Open';
  ExtensionDesc:'OptiPerl POD Document'; Parameters:'"%1"';
  FriendlyName:FriendlyName; ShellNew : true),

 (SubKey:'optiperl.opj'; Extension:'.opj'; DefaultIcon:0;
  ExeName:''; Command:'Open'; CommandDescription : '&Open';
  ExtensionDesc:'OptiPerl Project'; Parameters:'"%1"';
  FriendlyName:FriendlyName; ShellNew : false),

 (SubKey:'optiperl.op'; Extension:'.op'; DefaultIcon:0;
  ExeName:''; Command:'Open'; CommandDescription : '&Open';
  ExtensionDesc:'OptiPerl Script Information File'; Parameters:'"%1"';
  FriendlyName:FriendlyName; ShellNew : false));

procedure SetExename;
var i:integer;
begin
 for i:=1 to length(OptiAssocs) do
  OptiAssocs[i].exename:=ExtractFilePath(paramstr(0))+'OptiPerl.exe';
end;

Function CheckOptiAssociations : Boolean;
var
 i:integer;
begin
 result:=true;
 for i:=1 to length(OptiAssocs) do
  if not checkAssociation(OptiAssocs[i]) then
  begin
   result:=false;
   exit;
  end;
end;

Procedure AddPerlAssociations;
var
 i:integer;
begin
 for i:=1 to 5 do
 AddAssociation(OptiAssocs[i],false);
end;

Procedure RemovePerlAssociation;
var
 i:integer;
begin
 for i:=1 to 5 do
 RemoveAssociation(OptiAssocs[i]);
end;

Procedure AddOptiAssociations;
var
 i:integer;
begin
 for i:=1 to 5 do
  AddOpenWithList(OptiAssocs[i]);
 for i:=6 to 7 do
  AddAssociation(OptiAssocs[i],false);
end;

Procedure RemoveOptiAssociation;
var
 i:integer;
begin
 for i:=1 to 5 do
  RemoveOpenWithList(OptiAssocs[i]);
 for i:=6 to 7 do
 RemoveAssociation(OptiAssocs[i]);
end;

initialization
 SetExeName;
end.