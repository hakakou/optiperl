unit HKRegistry;

interface
uses registry,windows,classes,sysutils,ShlObj,agNTSecurity;

type
 TAssociation = Record
  SubKey : String;
  Extension : String;
  DefaultIcon : Integer;
  ExeName : String;
  Command : String;
  CommandDescription : String;
  ExtensionDesc : String;
  Parameters : String;
  FriendlyName : String;
  ShellNew : boolean;
 end;

Function ShouldCheckAssocs(const regpath: string) : Boolean;
// \SOFTWARE\Xarka\OptiPerl

Procedure SetShouldCheckAssocs(const regpath: string; Check : Boolean);

Function CheckAssociation(assoc : TAssociation) : Boolean;
//Returns whether the association is valid

Function RemoveAssociation(Assoc : TAssociation) : Boolean;
// True if success

Function AddAssociation(Assoc : TAssociation; Reset : boolean) : Boolean;
// True if success

Function AddOpenWithList(Assoc : TAssociation) : Boolean;

Function RemoveOpenWithList(Assoc : TAssociation) : Boolean;


implementation


function ExtractFileNoExt(const f:string) : string;
var a:integer;
begin
 result:=extractfilename(f);
 a:=length(result);
 while (a>0) and (result[a]<>'.') do dec(a);
 if a<>0 then result:=copy(result,1,a-1);
end;

function GetBackValue(const exename : string) : string;
begin
 result:=ExtractFileNoExt(ExeName)+'_back'
end;

Function ShouldCheckAssocs(const regpath: string) : Boolean;
var
 reg:TRegistry;
begin
 reg:=TRegistry.Create(KEY_READ);
 try
  reg.rootkey:=HKEY_LOCAL_MACHINE;
  reg.OpenKeyreadonly(regpath);
  result:=(reg.ValueExists('Associations')) and
          (reg.ReadInteger('Associations')=1);
 finally
  reg.free;
 end;
end;

Procedure SetShouldCheckAssocs(const regpath: string; Check : Boolean);
var
 reg:TRegistry;
 i : integer;
begin
 if not IsAdminRights then exit;
 if check
  then i:=1
  else i:=0;
 reg:=TRegistry.Create;
 try
  reg.rootkey:=HKEY_LOCAL_MACHINE;
  reg.OpenKey(regpath,true);
  reg.WriteInteger('Associations',i);
 finally
  reg.free;
 end;
end;

Function AddOpenWithList(Assoc : TAssociation) : Boolean;
var
 reg:TRegistry;
begin
 result:=false;
 if not IsAdminRights then exit;
 reg:=TRegistry.Create;
 reg.rootkey:=HKEY_CLASSES_ROOT;
 try
  reg.openkey('\Applications\'+ExtractFilename(assoc.exename),true);
  reg.WriteString('FriendlyAppName',assoc.FriendlyName);
  reg.openkey('shell\open\command',true);
  reg.WriteString('','"'+assoc.Exename+'" '+assoc.parameters);

  reg.OpenKey('\'+assoc.extension+'\OpenWithList\'+ExtractFilename(assoc.exename),true);

  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_FLUSH, PChar(''), PChar(''));
 finally
  reg.free;
 end;
end;

Function RemoveOpenWithList(Assoc : TAssociation) : Boolean;
var
 reg:TRegistry;
 path : string;
begin
 result:=false;
 if not IsAdminRights then exit;
 reg:=TRegistry.Create;
 try
  reg.rootkey:=HKEY_CLASSES_ROOT;
  path:='\'+assoc.extension+'\OpenWithList\'+ExtractFilename(assoc.exename);
  if reg.KeyExists(path)
   then reg.DeleteKey(path);
  reg.OpenKey('\'+assoc.extension+'\OpenWithList',false);
  if not reg.HasSubKeys then
   reg.DeleteKey('\'+assoc.extension+'\OpenWithList');
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_FLUSH, PChar(''), PChar(''));
 finally
  reg.free;
 end;
end;


Function AddAssociation(Assoc : TAssociation; Reset : Boolean) : Boolean;
var
 reg:TRegistry;
 exefname,text : string;
begin
 result:=false;
 if not IsAdminRights then exit;
 reg:=TRegistry.Create;
 try
   exefname:=ExtractFilename(assoc.exename);
   reg.rootkey:=HKEY_CLASSES_ROOT;

   if reset then
   begin
    reg.DeleteKey(assoc.SubKey);
    reg.deletekey(assoc.Extension);
    reg.deletekey('Applications\'+exefname);
   end;

  //Write the subkey

   reg.OpenKey('\'+assoc.subkey,true);
   reg.WriteString('',assoc.ExtensionDesc);
   reg.OpenKey('\'+assoc.subkey+'\'+'DefaultIcon',true);
   reg.WriteString('',assoc.ExeName+','+inttostr(assoc.defaulticon));
   reg.OpenKey('\'+assoc.subkey+'\'+'shell',true);
   reg.writestring('',assoc.command);
   reg.openkey(assoc.command,true);
   if assoc.CommandDescription<>'' then
   reg.writestring('',assoc.CommandDescription);
   reg.openkey('command',true);
   reg.WriteString('','"'+assoc.Exename+'" '+assoc.parameters);

  //Write the extension
   reg.OpenKey('\'+assoc.extension,true);
   text:=reg.ReadString('');
   reg.WriteString('',assoc.SubKey);
   if (text<>'') and (text<>assoc.SubKey)
       and (not reg.ValueExists(GetBackValue(assoc.exename))) then
    reg.WriteString(GetBackValue(assoc.exename),text);


   //write the app
   reg.openkey('\Applications\'+exefname,true);
   reg.WriteString('FriendlyAppName',assoc.FriendlyName);

   if assoc.ShellNew then
   begin
    reg.OpenKey('\'+assoc.extension+'\ShellNew',true);
    reg.WriteString('NullFile','');
   end;

   SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_FLUSH, PChar(''), PChar(''));
   result:=true;
 finally
   reg.free;
 end;
end;

Function CheckAssociation(assoc : TAssociation) : Boolean;
var
 reg:TRegistry;
begin
 result:=false;
 reg:=TRegistry.Create(KEY_READ);
 try
  reg.rootkey:=HKEY_CLASSES_ROOT;
  if not reg.KeyExists(assoc.subkey) then exit;
  if not reg.KeyExists(assoc.extension) then exit;
  if not reg.OpenKeyReadOnly('\'+assoc.extension) then exit;
  if reg.GetDataType('')<>rdString then exit;
  if reg.ReadString('')<>assoc.SubKey then exit;
  if not reg.OpenKeyReadOnly('\'+assoc.subkey+'\'+'shell\'+assoc.Command+'\Command') then exit;
  if reg.GetDataType('')<>rdString then exit;
  if (AnsiCompareText(reg.readString(''),'"'+assoc.Exename+'" '+assoc.parameters)<>0) then exit;
  result:=true;
 finally
  reg.free;
 end;
end;

Function RemoveAssociation(Assoc : TAssociation) : Boolean;
var
 reg:TRegistry;
 text:string;
Begin
 result:=false;
 if not IsAdminRights then exit;
 reg:=TRegistry.Create;
 try
  reg.rootkey:=HKEY_CLASSES_ROOT;

  if reg.OpenKey('\'+assoc.extension,false) then
  begin

   if reg.ValueExists(GetBackValue(assoc.exename)) then
    begin
     text:=reg.ReadString(GetBackValue(assoc.exename));
     reg.DeleteValue(GetBackValue(assoc.exename));
    end
    else
     text:='';

   if text<>''
    then reg.WriteString('',text)
    else
     begin
      if reg.ReadString('')=assoc.SubKey then
       reg.DeleteKey('\'+assoc.extension);
     end;
   reg.DeleteKey('\'+assoc.SubKey);
   reg.deletekey('\Applications\'+ExtractFilename(assoc.exename));
  end;
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_FLUSH, PChar(''), PChar(''));
  result:=true;
 finally
  reg.free;
 end;
end;


end.
