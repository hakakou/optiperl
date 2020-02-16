{***************************************************************
 *
 * Unit Name: OptBackup
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptBackup;
{$I REG.INC}

interface
uses HKDebug,Hakafile,Sysutils,classes,OptProcs,OptOptions,hyperstr,ScriptInfoUnit,
     ZipMstr,hakageneral;

type
 TOptiBackup = Class
 private
  SI : TScriptInfo;
  ZIP : TZipMaster;
  FEnable,FZip : Boolean;
  FScheme : String;
  FFolder,FZipFile,FFilename : String;
  FFolderRE,FZipFileRE,FFilenameRE : String;
  Function MakeBackupName(Const Str : String; RE,OnlyDat : Boolean) : String;
  function MakeSafeREChars(const Str: String): String;
 public
  NotValidReason : String;
  Valid : Boolean;
  Constructor Create;
  Destructor Destroy; override;
  Function GetTestString : String;
  procedure Update(Re, Description: Boolean);
  Procedure Backup;
  Procedure SetBackupOpts(Const Scheme : String; Enable,zip : Boolean; Script : TScriptInfo);
 end;


Procedure BackupScript(SI : TScriptInfo);

var
 OptiBackup : TOptibackup;

implementation

Procedure BackupScript(SI : TScriptInfo);
var s:string;
begin
  with options do
  begin
   if PR_IsFileInProject(si.path)
    then s:=backupprjname
    else s:=backupname;
   OptiBackup.SetBackupOpts(s,BackupEnable,BackupZip,SI);
  end;
  OptiBackup.Update(false,false);
  OptiBackup.backup;
end;

{ TOptiBackup }

Function TOptiBackup.MakeSafeREChars(Const Str : String) : String;
var i:integer;
begin
 result:='';
 i:=1;
 while i<=length(Str) do
 begin
  if Str[i] in ['A'..'Z','a'..'z','0'..'9',' ','%',#1] then
   result:=result+Str[i]
  else
   result:=result+'\'+Str[i];
  inc(i);
 end;
end;

Function TOptiBackup.MakeBackupName(Const Str : String; RE,OnlyDat : Boolean) : String;
var
 dy,dm,dd,th,tm,ts,tms : Word;

  Function GetDat(c : Char) : String;
  begin
   case c of
   '0' : result:=ProjOpt.Data0;
   '1' : result:=ProjOpt.Data1;
   '2' : result:=ProjOpt.Data2;
   '3' : result:=ProjOpt.Data3;
   '4' : result:=ProjOpt.Data4;
   '5' : result:=ProjOpt.Data5;
   '6' : result:=ProjOpt.Data6;
   '7' : result:=ProjOpt.Data7;
   '8' : result:=ProjOpt.Data8;
   '9' : result:=ProjOpt.Data9;
   else result:='%'+c;
   end;
  end;

  Function GetTag(c : char) : String;
  begin
   case Upcase(c) of
   'F' : result:=extractFileNoExt(si.path);
   'E' : result:=GetFileExt(si.path);
   'P' : result:=ExtractFileNoExt(PR_GetProjectName);
   'J' : result:=ExcludeTrailingBackSlash(ExtractFilePath(PR_GetProjectName));
   'Y' : result:=Format('%.4d',[dy]);
   'M' : result:=Format('%.2d',[dm]);
   'D' : result:=Format('%.2d',[dd]);
   'H' : result:=Format('%.2d',[th]);
   'N' : result:=Format('%.2d',[tm]);
   'S' : result:=Format('%.2d',[ts]);
   else result:='%'+c;
   end;
 end;

  Function GetRE(c : char) : String;
  begin
   case Upcase(c) of
   'F','E','P','J','0'..'9' : result:=GetTag(c);
   'Y' : result:=#1'd'#1'd'#1'd'#1'd';
   'M','D','H','N','S' : result:=#1'd'#1'd';
   else result:='%'+c;
   end;
 end;


var
 i:integer;

begin
 if Not RE then
 begin
  DecodeDate(now,dy,dm,dd);
  DecodeTime(now,th,tm,ts,tms);
 end;
 i:=1;
 result:='';

 while i<=length(str) do
 begin
  if str[i]<>'%' then
   result:=result+str[i]
  else
   begin
    inc(i);
    if i>length(str) then
    begin
     result:=result+'%';
     break;
    end;
    if onlyDat then
     begin
      result:=result+GetDat(str[i]);
     end
    else
     begin
      if Re
       then result:=result+getRE(str[i])
       else result:=result+gettag(str[i]);
     end;
   end;
  inc(i);
 end;
 if RE then
 begin
  result:=MakeSafeREChars(result);
  replaceC(result,#1,'\');
 end;
end;

constructor TOptiBackup.Create;
begin
 Zip:=TZipMaster.Create(nil);
 Zip.AddCompLevel:=6;
end;

procedure TOptiBackup.SetBackupOpts(const Scheme: String; Enable, zip: Boolean; Script : TScriptInfo);
begin
 FScheme:=Scheme;
 FEnable:=Enable;
 FZip:=Zip;
 SI:=Script;
end;

Procedure TOptiBackup.Update(Re,Description : Boolean);
var
 s:string;
begin
 Valid:=(FEnable) and (assigned(si));
 NotValidReason:='';
 if not valid then
 begin
  if Description then
   NotValidReason:='Backing up not enabled';
  exit;
 end;

 Valid:=false;
 FScheme:=MakeBackupName(FScheme,false,true);

 FFolder:=ExtractFilePath(FScheme);
 if FFolder<>'\' then
  FFolder:=ExcludeTrailingAnySlash(FFolder);
 if FZIP then
  begin
   FZIPFile:=ExtractFilename(FFolder);
   FFolder:=ExtractFilepath(FFolder);
  end
 else
  FZipFile:='';
 if FFolder<>'' then
   FFolder:=IncludeTrailingPathDelimiter(FFolder);

 FFilename:=ExtractFilename(FScheme);

 if FZIP and (length(FZipFile)=0) then
 begin
  if Description then
   NotValidReason:='Cannot find zip filename in scheme';
  exit;
 end;

 if FZIP and (UpFileExt(FZipFile)<>'ZIP') then
 begin
  if Description then
   NotValidReason:='Zip filename must have a .zip extension';
  exit;
 end;

 if FZIP and (not ValidSafeFilename(FZipFile)) then
 begin
  if Description then
   NotValidReason:='Invalid characters in zip filename';
  exit;
 end;

 if (FFolder<>'') and (trim(FFolder)='') then
 begin
  if Description then
   NotValidReason:='Invalid directory';
  exit;
 end;

 if (not ValidSafeFilename(FFilename)) then
 begin
  if Description then
   NotValidReason:='Invalid filename';
  exit;
 end;

 if ((FFolder='') or (FFolder='./') or (FFolder='.\')) and
    (not FZip) and (uppercase(FFilename)='%F.%E') then
 begin
  if Description then
   NotValidReason:='Cannot save to file to itself';
  exit;
 end;

 s:=extractFilepath(si.path);
 if not stringstartswithcase('%j',FFolder) then
  FFolder:=HakaFile.GetAbsolutePath(s,FFolder);

 if Re then
 begin
  FFolderRE:=FFolder;
  FZipFileRE:=FZipFile;
  FFilenameRE:=FFilename;
 end;

 FFolder:=MakeBackupName(FFolder,false,false);
 FZipFile:=MakeBackupName(FZipFile,false,false);
 FFilename:=MakeBackupName(FFilename,false,false);

 if Re then
 begin
  FFolderRE:=MakeBackupName(FFolderRE,true,false);
  FZipFileRE:=MakeBackupName(FZipFileRE,true,false);
  FFilenameRE:=MakeBackupName(FFilenameRE,true,false);
 end;

 Valid:=true;
end;

function TOptiBackup.GetTestString: String;
begin
 if Valid then
  begin
   if FZip then
    result:=Format(
    'File "%s" will be added in zip archive "%s". This archive will be created in folder "%s"',
    [FFilename,FZipFile,FFolder])
   else
    result:=Format(
    'File "%s" will be written in folder "%s"',
    [FFilename,FFolder]);

   // result:=result+Format(' - %s - %s - %s',[FFolderRE,FZipFileRE,FFilenameRE]);
  end
 else
  result:=NotValidReason;
end;

destructor TOptiBackup.Destroy;
begin
 Zip.free;
end;

procedure TOptiBackup.Backup;
begin
 if not valid then exit;
 if not si.backup then exit;

 try
  ForceDirectories(FFolder);
 except
  on exception do
  begin
   si.backup:=false;
   exit;
  end;
 end;

 try
  if FZip then
   begin
    ZIP.ZipFileName:=FFolder+FZipFile;
    Zip.ZipStream.Clear;
    si.ms.SaveToStream(zip.ZipStream);
    Zip.AddStreamToFile(FFilename);
   end
  else
   begin
    si.ms.SaveToFile(FFolder+FFilename);
   end;
 except
  on exception do si.backup:=false;
 end;
end;

initialization
 HKLog('Backup Start');
 OptiBackup:=TOptiBackup.Create;
 HKLog;
finalization
 OptiBackup.free;
end.