{***************************************************************
 *
 * Unit Name: OptFolders
 * Date     : 17/12/2000 4:30:33 μμ
 * Purpose  : This is used by all units that need the filenames of data files
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptFolders; //Unit
{$I REG.INC}

interface
uses filectrl,sysutils,HakaMessageBox,hyperfrm,hakageneral,Controls,inifiles,dialogs,
     hyperstr,classes,jclfileutils,windows,registry,HakaWin,HKDebug,
     HakaFile,jvAppUtils,jclRegistry,OptProcs;

const
 OptiRegKey = '\Software\Xarka\OptiPerl\';
 OptiRegKey_OneInstance = 'OneInstance';
 OptiRegKey_UserFolder = 'UserFolder';

 Type
  TFolders = Record
   UserFolder,AppDataFolder : String;
   TemplateFile,SnippetFile,TransSessFile,IniFile,ToolFile,OptFile,
   PodHistoryFile,HtmlHelpFile,ApacheHelpFile,FTPFolder,PluginFolder,
   DebOutput,RDebOutput,LoadFile,IncludePath,BarLayout,
   ParsersFile,ShortcutFile : string;
   RemoteFolder : string;
   CookiesFolder : String;
  end;

var
 Folders : TFolders;

Procedure ResetFolders;
procedure SetLoadFile(Files : TStrings);

implementation

procedure SetLoadFile(Files : TStrings);
var
 l:integer;
 s:string;
begin
 for l:=0 to files.Count-1 do
  if UpFileExt(files[l])='OP' then
  begin
   s:=files[l];
   setlength(s,length(s)-3);
   files[l]:=s;
  end;
 if files.Count>0 then
  Files.SaveToFile(folders.LoadFile);
end;

Procedure HandleRemoteFolder(var folder : string);
begin
 try
  if not DirectoryExists(folder) then MkDir(folder);
 except
  on exception do MessageDlg('Could not create user folder.', mtError, [mbOK], 0);
 end;
end;

Procedure GetCookie;
var
 reg : TRegistry;
begin
 folders.CookiesFolder:='';
 reg:=TRegistry.create(KEY_READ);
 try
  reg.RootKey:=HKEY_CURRENT_USER;
  try
   reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',false);
   folders.CookiesFolder:=IncludeTrailingBackSlash(reg.ReadString('Cookies'));
  except on exception do end;
 finally
  reg.free;
 end;
 if not directoryexists(folders.CookiesFolder) then
  folders.CookiesFolder:='';
end;

Procedure ResetFolders;
begin
 with Folders do begin
  GetCookie;
  AppDataFolder:=RegReadStringDef(HKEY_CURRENT_USER,OptiRegKey,OptiRegKey_UserFolder,'-');
  if not DirectoryExists(AppDataFolder) then
  begin
   AppDataFolder:=GetAppDataFolder(true,false,'OptiPerl');
   try
    RegWriteString(HKEY_CURRENT_USER,OptiRegKey,OptiRegKey_UserFolder,IncludeTrailingBackSlash(AppDataFolder));
   except end;
  end;
  UserFolder:=AppDataFolder+'Settings\';
  HandleRemoteFolder(UserFolder);
  RemoteFolder:=AppDataFolder+'Debug\';
  HandleRemoteFolder(RemoteFolder);
  FTPFolder:=AppDataFolder+'Sessions\';
  HandleRemoteFolder(FTPFolder);
  PluginFolder:=ProgramPath+'Plug-Ins\';
  IniFile:=UserFolder+'Options.ini';
  OptFile:=UserFolder+'Settings.ini';
  TemplateFile:=UserFolder+'Perl Templates.txt';
  SnippetFile:=UserFolder+'Code Librarian.zip';
  BarLayout:=userfolder+'Menus.ini';
  ToolFile:=UserFolder+'Tools.csv';
  TransSessFile:=UserFolder+'Sessions.csv';
  PodHistoryFile:=UserFolder+'Pod Files.txt';
  HtmlHelpFile:=ProgramPath+'Perl.chm';
  ApacheHelpFile:=ProgramPath+'Apache.chm';
  {$IFDEF DEVELOP}
   HtmlHelpFile:='c:\delphi7\haka projects\optiperl\perl.chm';
   ApacheHelpFile:='c:\delphi7\projects\optiperl\apache.chm';
  {$ENDIF}
  ParsersFile:=ProgramPath+'Parsers.xml';
  LoadFile:=UserFolder+'LoadFile.dat';
  ShortCutFile:=UserFolder+'Options.ohk';
  DebOutput:='';
  IncludePath:=ProgramPath+'library';
 end;
end;

function GetDefaultIniName : string;
begin
 result:=folders.IniFile;
end;

initialization
 HKLOG('Folder Start');
 ResetFolders;
 OnGetDefaultIniName:=GetDefaultIniName;
 HKLog;
end.
