[Setup]

AppName=OptiPerl
AppVerName=OptiPerl 5.5.62
AppVersion=5.5.62
OutputBaseFilename=OptiPerl-5.5.62-Free
;Change the build number also in the registry section below
;and in OptOptions.pas and AboutFrm.pas

AppPublisher=Harry Kakoulidis
AppSupportURL=https://github.com/hakakou/optiperl
DefaultDirName={pf}\OptiPerl
DefaultGroupName=OptiPerl 5
SolidCompression=yes
ChangesAssociations=yes
MinVersion=4,4
UninstallDisplayIcon={app}\OptiPerl.exe,0
AllowRootDirectory = yes
WizardImageFile = Project\WizModernImage.bmp
Compression=lzma

[Tasks]
Name: associate; Description: "&Associate Perl extensions with OptiPerl"; GroupDescription: "File Associations:";
Name: iconCurrent; Description: "Create a &desktop icon"; GroupDescription: "Icons:";
Name: quicklaunchicon; Description: "Create a &Quick Launch icon"; GroupDescription: "Additional icons:"; Flags: unchecked;

[Files]
Source: "exe\*.*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion; Excludes: "*.map"
Source: "dist_user\*.*"; DestDir: "{code:OptiUserFolder|}"; Flags: recursesubdirs onlyifdoesntexist;

[Icons]
Name: "{group}\OptiPerl 5"; Filename: "{app}\OptiPerl.exe"; Comment: "OptiPerl Visual Environment"
Name: "{group}\Introduction"; Filename: "{app}\Introduction.html"; Comment: "Introduction to OptiPerl"
Name: "{group}\Optiperl Help"; Filename: "{app}\OptiPerl.chm"; Comment: "OptiPerl Help"
Name: "{group}\Perl Core and Module Documentation"; Filename: "{app}\Perl.chm"
Name: "{group}\OptiPerl Homepage"; Filename: "{app}\OptiPerl Homepage.url"
Name: "{userdesktop}\OptiPerl 5"; Filename: "{app}\OptiPerl.exe"; Comment: "OptiPerl Visual Environment"; Tasks: IconCurrent;
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\OptiPerl"; Filename: "{app}\OptiPerl.exe"; Comment: "OptiPerl Visual Environment"; Tasks: QuickLaunchIcon;

[InstallDelete]
Type: files; Name: "{app}\runperl.bat"
Type: files; Name: "{app}\Register.txt"
Type: files; Name: "{group}\OptiPerl 3.lnk";
Type: files; Name: "{group}\OptiPerl 4.lnk";
Type: files; Name: "{group}\Register OptiPerl.lnk";
Type: files; Name: "{group}\Buy Now OptiPerl 4.lnk";
Type: files; Name: "{group}\Buy Now OptiPerl.lnk";

[UninstallDelete]
Type: files; Name: "{code:OptiUserFolder|}\OptiPerl.elf"

[Run]
Filename: "{app}\uninsOpti.exe";  Parameters: "optin i";
Filename: "{app}\uninsOpti.exe";  Parameters: "optin p"; Tasks: associate;
Filename: "{app}\OptiPerl.exe"; Parameters: "/regserver";
Filename: "{app}\OptiClient.exe"; Parameters: "/regserver";
Filename: "{app}\OptiPerl.exe"; Description: "Launch OptiPerl"; Flags: postinstall nowait

[UninstallRun]
Filename: "{app}\OptiPerl.exe"; Parameters: "/unregserver";
Filename: "{app}\OptiClient.exe"; Parameters: "/unregserver";
Filename: "{app}\uninsOpti.exe";  Parameters: "optin u ""{userappdata}\OptiPerl\""";

[INI]
Filename: "{code:OptiUserFolder|}Options.ini"; Section: "RecentFiles"; Key: "0"; String: "{app}\webroot\test.htm"; Flags: createkeyifdoesntexist;
Filename: "{code:OptiUserFolder|}Options.ini"; Section: "RecentFiles"; Key: "1"; String: "{app}\webroot\cgi-bin\test-form.cgi"; Flags: createkeyifdoesntexist;
Filename: "{code:OptiUserFolder|}Options.ini"; Section: "RecentFiles"; Key: "2"; String: "{app}\webroot\cgi-bin\counter.cgi"; Flags: createkeyifdoesntexist;
Filename: "{code:OptiUserFolder|}Options.ini"; Section: "RecentFiles"; Key: "3"; String: "{app}\webroot\cgi-bin\hello.cgi"; Flags: createkeyifdoesntexist;
Filename: "{code:OptiUserFolder|}Options.ini"; Section: "RecentFiles"; Key: "4"; String: "{app}\webroot\cgi-bin\customize.cgi"; Flags: createkeyifdoesntexist;
Filename: "{code:OptiUserFolder|}Options.ini"; Section: "RecentFiles"; Key: "5"; String: "{app}\webroot\cgi-bin\save_state.cgi"; Flags: createkeyifdoesntexist;
Filename: "{code:OptiUserFolder|}Options.ini"; Section: "RecentFiles"; Key: "6"; String: "{app}\webroot\cgi-bin\cookie.cgi"; Flags: createkeyifdoesntexist;
Filename: "{code:OptiUserFolder|}Options.ini"; Section: "RecentFiles"; Key: "7"; String: "{app}\webroot\cgi-bin\monty.cgi"; Flags: createkeyifdoesntexist;

[Registry]
Root: HKLM; Subkey: "Software\Xarka"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Xarka\OptiPerl"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Xarka\OptiPerl"; ValueType: dword; ValueName: "Build"; ValueData: 62;
Root: HKLM; Subkey: "Software\Xarka\OptiPerl"; ValueType: string; ValueName: "Path"; ValueData: "{app}"
Root: HKLM; Subkey: "Software\Xarka\OptiPerl"; ValueType: dword; ValueName: "Associations"; ValueData: 0;
Root: HKLM; Subkey: "Software\Xarka\OptiPerl"; ValueType: dword; ValueName: "Associations"; ValueData: 1; Tasks: associate;
Root: HKCU; Subkey: "Software\Xarka\OptiPerl"; ValueType: string; ValueName: "UserFolder"; ValueData: "{userappdata}\OptiPerl\"; flags: createvalueifdoesntexist;

[Code]
function OptiUserFolder(Default: String): String;
var ex : boolean;
begin
 ex:=RegQueryStringValue(HKEY_CURRENT_USER,'Software\Xarka\OptiPerl','UserFolder',result);
 if ex
  then result:=AddBackslash(result)+'Settings\'
  else result:=ExpandConstant('{userappdata}')+'\OptiPerl\Settings\';
end;

function InitializeSetup(): Boolean;
var
 s:string;
 a:integer;
begin
 s:='';
 if (RegQueryStringValue(HKEY_LOCAL_MACHINE,'Software\Microsoft\Internet Explorer','Version',s)) and
    (length(s)>0) and (StrToIntDef(copy(s,1,1),0)>=5) then
  result:=true
 else
  begin
   result:=false;
   msgbox('OptiPerl requires Internet Explorer 5 or above to function.'+#13+#10+
          'Please install first before running program.', mbError, MB_OK);
  end;
end;

