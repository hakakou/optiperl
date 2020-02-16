unit HKMultiFileHandler;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IniFiles,HKInifiles;

type
  TFileInfo = Class  {A Class to describe each loaded data file}
  public
   path : string;
   IsNewFile : Boolean;
   IsModified : Boolean;
   TimeStamp : Integer;
   NoToReload : Boolean;
   DontCheckReload : Boolean;
   IsVeryNewFile : Boolean;
     {New file with no changes? This is closed if user opens another file}
     {Do not change}
   Procedure GetInfo; virtual; {Get Information about file from user window}
   Procedure SetInfo; virtual; {Set Information about file to user window}
   Function DisplayName : string; virtual;
   Function GetReadOnly : boolean; 
   Procedure Modified; virtual;
  end;

  TOnSaveEvent = Procedure(sender : TObject; FileInfo : TFileInfo) of object;
  TOnOpenEvent = Function(sender : TObject; const filename : string) : TFileInfo of object;
  TOnNewEvent = Function(sender : TObject) : TFileInfo of object;
  TOnGetActiveIndex = Function(sender : TObject) : Integer of object;
  TOnGoToIndex = Procedure(sender : TObject; Index : Integer) of Object;
  TOnBeforeOpen = Function(Sender : TObject; const Filename : String) : Boolean of Object;

  TMultiFileHandler = class(TComponent)
  private
    FOnOpen : TOnOpenEvent;
    FOnSave : TOnSaveEvent;
    FOnNew : TOnNewEvent;
    FOpenDialog : TOpenDialog;
    FSaveDialog : TOpenDialog;
    FDefaultName : String;
    FMRUCount : Integer;
    FIniPath : string;
    inifile : TInifile;
    FOnAllClosed : TNotifyEvent;
    FOnOneOpened : TNotifyEvent;
    FOnOneClosed : TOnSaveEvent;
    FOnGotoIndex : TOnGotoIndex;
    FOnSaveCancel : TOnSaveEvent;
    FOnTabChanged : TNotifyEvent;
    FOnBeforeOpen : TOnBeforeOpen;
    FOnModifyUpdate,FOnReloadActive : TNotifyEvent;
    ActiveIndex : TOnGetActiveIndex;
    ModalResult : Integer;
    CheckingNow : Boolean;
    FReservedAccent : String;
    FAddAccents : Boolean;
    IsDoingCloseAll : Boolean;
    Function QuerySave(Const Filename : string; WithYesToAll : Boolean) : Integer;
    Procedure TruncMruList;
    Procedure SetDefaultName(const f : String);
    Function GetActiveFileInfo : TFileInfo;
    Procedure SetMruCount(mru : Integer);
    Procedure SetReservedAccents(s : string);
    Procedure PutAccent(var dn:string);
    function RemoveAccent(const dn: string): string;
  public
    MRUList : TStringList;
    FileList : TStrings;
    ShowRefreshDialog : Boolean;
    procedure AddMruList(const f: string);
    function CloseEnabled : Boolean;
    function SaveEnabled : Boolean;
    function CloseAllEnabled : Boolean;
    function SaveAllEnabled : Boolean;
    Constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    Function CloseAppOK : BOolean;
    Procedure OnChanging;
    Procedure OnChange;
    Procedure Open;
    Procedure Close;
    Procedure CloseAll;
    Procedure Save;
    Procedure SaveAs;
    Procedure SaveAll;
    Procedure New;
    function IsFileOpen(f: String): Boolean;
    Function OpenFile(filename : string) : Boolean;
    Procedure OpenFileBlind(filename: string);
    Procedure LoadMRU;
    Procedure Modified;
    procedure CloseByIndex(Index : Integer);
    procedure SelectByIndex(Index : Integer);
    procedure CheckFileAges;
    procedure ForceReloadAll;
    Property ActiveFileInfo : TFileInfo read GetActiveFileInfo;
  published
    Property OnOpen : TOnOpenEvent read FonOpen write FOnOpen;
    Property OnSave : TOnSaveEvent read Fonsave write FOnsave;
    Property OnNew : TOnNewEvent read FonNew write FOnNew;
    Property OnSaveCancel : TOnSaveEvent read FOnSaveCancel write FOnSaveCancel;
    property OpenDialog :TOpenDialog read FOpenDialog write FOpenDialog;
    property SaveDialog :TOpenDialog read FSaveDialog write FSaveDialog;
    Property MRUCount : Integer read FMRUCount write SetMruCount;
    Property IniPath : string read FIniPath write FIniPath;
    Property DefaultName : string read FDefaultName write SetDefaultName;
    property ReservedAccents : String read FReservedAccent write SetReservedAccents;
    property AddAccents : boolean read FAddAccents write FAddAccents;
    Property OnGetActiveIndex : TOnGetActiveIndex read ActiveIndex write ActiveIndex;
    Property OnGoToIndex : TOnGoToIndex read FOnGotoIndex write FOnGotoIndex;
    Property OnAllClosed : TNotifyEvent read FOnAllClosed write FOnAllClosed;
    property OnOneClosed : TOnSaveEvent read FOnOneClosed write FOnOneClosed;
    Property OnOneOpened : TNotifyEvent read FOnOneOpened write FOnOneOpened;
    Property OnTabChanged : TNotifyEvent read FOnTabChanged write FOnTabChanged;
    property OnModifyUpdate : TNotifyEvent read FOnModifyUpdate write FOnModifyUpdate;
    property OnReloadActive : TNotifyEvent read FOnReloadActive write FOnReloadActive;
    property OnBeforeOpen : TOnBeforeOpen read FOnBeforeOpen write FOnBeforeOpen;
  end;

procedure Register;

implementation
uses
  hakageneral,hyperstr,hakafile,JclFileUtils;

procedure Register;
begin
  RegisterComponents('Haka', [TMultiFileHandler]);
end;

Procedure TMultiFileHandler.SetReservedAccents(s : string);
begin
 FReservedAccent:=Uppercase(s);
end;

Procedure TMultiFileHandler.SetMruCount(mru : Integer);
begin
 FMruCount:=mru;
 truncMruList;
end;

constructor TMultiFileHandler.Create(AOwner : TComponent);
begin
 ShowRefreshDialog:=true;
 FMRUCount:=5;
 CheckingNow:=False;
 FDefaultName:='New File %d.txt';
 MRUList:=TStringList.Create;
 FAddAccents:=false;
 inherited create(AOwner);
end;

destructor TMultiFileHandler.Destroy;
begin
 HKInifiles.WriteINIStrings(FIniPath,'RecentFiles',MRUList);
 MRUList.Free;
 inherited destroy;
end;

procedure TMultiFileHandler.Close;
var
 fi : TFileInfo;
 ai : Integer;
begin
 if filelist.Count=0 then exit;
 OnChanging;
 ai:=ActiveIndex(self);
 fi:=TFileInfo(FileList.Objects[ai]);

 if (not IsDoingCloseAll) or (modalresult<>mrYesToAll) then
 begin
  if fi.isModified then
   begin
    modalresult:=QuerySave(fi.path,IsDoingCloseAll);
    if (modalresult=mrNo) and Assigned(FOnSaveCancel) then
     FOnSaveCancel(self,fi);
   end
  else
   modalresult:=mrNo;
 end;

 if modalresult=mrCancel then
  exit;
 if (modalresult=mrYes) or ((IsDoingCloseAll) and (modalresult=mrYesToAll)) then
  Save;

 if Assigned(FOnOneClosed) then
  FOnOneCLosed(Self,fi);
 fi.Free;
 FileList.Delete(ai);
 if (filelist.Count=0) and (assigned(FOnAllClosed)) then
  FOnAllClosed(self);
 if assigned(FOnGotoIndex) then
 begin
  if ai<=0 then ai:=1;
  if ai>=filelist.Count-1 then ai:=FileList.count;
  if assigned(FOnGotoIndex) then
   FOnGotoIndex(self,ai-1);
  OnChange;
 end;
end;

procedure TMultiFileHandler.CloseByIndex(Index : Integer);
var pi : Integer;
begin
 pi:=ActiveIndex(self);
 if assigned(FOnGotoIndex) then FOnGotoIndex(self,index);
 close;
 if (FileList.count>=pi) then pi:=FileList.count-1;
 if assigned(FOnGotoIndex) then FOnGotoIndex(Self,pi);
end;

procedure TMultiFileHandler.CloseAll;
var
 i:integer;
 fi : TFileInfo;
begin
 modalresult:=-1;
 IsDoingCloseAll:=true;
 for i:=FileList.count-1 downto 0 do
 begin
  if assigned(FOnGotoIndex) then FOnGotoIndex(self,i);
  fi:=TFileInfo(fileList.Objects[i]);
  if fi.IsModified then
   begin
    OnChanging;
    onChange;
    close;
   end
  else
   Close;
  if modalresult=mrCancel then
   break;
 end;
 IsDoingCloseAll:=false;
 modalresult:=-1;
end;

Function TMultiFileHandler.RemoveAccent(Const dn:string) : string;
begin
 result:=dn;
 replaceSC(result,'&&',#1,false);
 replaceSC(result,'&','',false);
 replaceSC(result,#1,'&',false);
end;

Procedure TMultiFileHandler.PutAccent(var dn:string);
var
 i,j:integer;
 r,s:string;
begin
 if (FAddAccents) and (length(dn)>0) then
 begin
  replaceSC(dn,'&','&&',false);
  r:=FReservedAccent+' !@#$%^&*()_+|}{":?><~';
  for j:=0 to filelist.count-1 do
  begin
   s:=filelist[j];
   i:=pos('&',s);
   if (i<>0) and (length(s)>i) then r:=r+upcase(s[i+1]);
  end;
  i:=1;
  while (pos(upcase(dn[i]),r)<>0) and (i<=length(dn)) do
   inc(i);
  if i<=length(dn) then insert('&',dn,i);
 end;
end;

procedure TMultiFileHandler.New;
var
 fi : TFileInfo;
 i,count,j:integer;
 found : boolean;
 path : string;
 dn,r,s : string;
begin
 If assigned(OnNew) then
 begin
  OnChanging;

  fi:=OnNew(self);
  fi.IsVeryNewFile:=true;
  fi.isNewFile:=true;
  fi.IsModified:=false;

  //get a good number
  count:=0;
  repeat
   inc(count);
   found:=false;
   for j:=0 to filelist.Count-1 do
   begin
    path:=format(FDefaultName,[count]);
    if TFileInfo(Filelist.objects[j]).path=path then
    begin
     found:=true;
     break;
    end;
   end;
  until (not found) or (count>filelist.count);

  fi.path:=format(FDefaultName,[Count]);
  dn:=fi.DisplayName;
  putaccent(dn);
  FileList.AddObject(dn,fi);
  if assigned(FOnGotoIndex)
   then FOnGotoIndex(self,FileList.count-1);
  if (assigned(FOnOneOpened))
   then FOnOneOpened(self);
  OnChange;
 end;
end;

procedure TMultiFileHandler.OnChange;
var
 fi : TFileInfo;
 tmod,tisvnew : Boolean;
begin
 if filelist.count>0 then
 begin
  fi:=TFileInfo(FileList.Objects[ActiveIndex(self)]);
  tmod:=fi.IsModified;
  tisvnew:=fi.IsVeryNewFile;
  fi.SetInfo;
  fi.IsModified:=tmod;
  fi.IsVeryNewFile:=TIsVNew;
  if assigned(FOnTabChanged) then FOnTabChanged(self);
  if assigned(FOnModifyUpdate) then FOnModifyUpdate(self);
 end;
end;

procedure TMultiFileHandler.OnChanging;
var fi : TFileInfo;
begin
 if (FileList.Count>0) then
 begin
  fi:=TFileInfo(FileList.Objects[ActiveIndex(self)]);
  if Assigned(fI) then fi.getinfo;
 end;
end;

procedure TMultiFileHandler.Open;
var
 i:integer;
 f:string;
begin
 if (assigned(FOpenDialog)) and (FOpenDialog.execute) then
 for i:=0 to FOpenDialog.Files.Count-1 do
 begin
  if (OpenFile(FOpenDialog.files[i])) then
   begin
    f:=GetActiveFileInfo.path;
    AddMRUList(f);
  end;
 end;

end;

function TMultiFileHandler.QuerySave(const Filename: string; WithYesToAll : Boolean): Integer;
const
 Btn : Array[boolean] of TmsgDlgButtons =
  ([mbYes,mbNo,mbCancel], [mbYes,mbNo,mbCancel,mbYesToAll]);
begin
 result:=MessageDlg('File '+filename+' has changed.'+#13+#10+'Save changes?', mtConfirmation, Btn[WithYesToAll], 0);
end;

procedure TMultiFileHandler.Save;
var fi : TFileInfo;
begin
 if filelist.Count=0 then exit;
 OnChanging;
 fi:=TFileInfo(FileList.Objects[ActiveIndex(self)]);

 if fi.IsNewFile then
 begin
  saveAs;
  exit;
 end;

 if fi.IsModified then begin
  If assigned(onSave) then OnSave(self,fi);
  fi.NoToReload:=False;
  fi.TimeStamp:=fileage(fi.path);
  fi.IsModified:=false;
  fi.IsNewFile:=false;
  fi.IsVeryNewFile:=false;
 end;

 if assigned(FOnModifyUpdate) then FOnModifyUpdate(self);
end;

procedure TMultiFileHandler.SaveAll;
var
 pr,i:integer;
begin
 modalresult:=-1;
 pr:=ActiveIndex(Self);
 for i:=FileList.count-1 downto 0 do
 begin
  OnChanging;
  if assigned(FOnGotoIndex) then FOnGotoIndex(self,i);
  OnChange;
  save;
  if modalresult=mrCancel then
   break;
 end;
 if modalresult<>mrCancel then
 begin
  OnChanging;
  if assigned(FOnGotoIndex) then FOnGotoIndex(Self,pr);
  OnChange;
 end;
 modalresult:=-1;
end;

procedure TMultiFileHandler.SaveAs;
var fi : TFileInfo;
begin
 if filelist.Count=0 then exit;
 OnChanging;
 modalresult:=mrOK;
 fi:=TFileInfo(FileList.Objects[ActiveIndex(self)]);
 FSaveDIalog.Title:='Save '+fi.DisplayName+' as...';

 if not fi.IsNewFile
  then FSaveDialog.FileName:=extractfilename(fi.path)
  else FSaveDialog.FileName:='';

 if assigned(FSaveDialog) and (FsaveDialog.execute) then
  begin
   fi.path:=FSaveDialog.filename;
   If assigned(onSave) then
    OnSave(self,fi);
   fi.NoToReload:=False;
   fi.TimeStamp:=fileage(fi.path);
   fi.IsModified:=false;
   if assigned(FOnModifyUpdate) then
    FOnModifyUpdate(self);
   FileList[ActiveIndex(self)]:=fi.DisplayName;
   fi.isnewfile:=false;
   fi.IsVeryNewFile:=False;
   AddMRUList(FSaveDialog.filename);
   if assigned(FOnTabChanged) then FOnTabChanged(self);
  end
 else
  modalresult:=mrCancel;
end;

function TMultiFileHandler.CloseAppOK: BOolean;
begin
 CloseAll;
 result:=filelist.Count=0;
end;

{ TFileInfo }

Function TFileInfo.GetReadOnly : boolean;
begin
 result:=HasAttr(path,faReadOnly);
end;

function TFileInfo.DisplayName: string;
begin
 result:=ExtractFileNoExt(path);
end;

procedure TFileInfo.GetInfo;
begin
end;

procedure TFileInfo.Modified;
begin
 IsVeryNewFile:=false;
 IsModified:=true;
end;

procedure TFileInfo.SetInfo;
begin
end;

function TMultiFileHandler.CloseAllEnabled: Boolean;
begin
 result:=filelist.Count>0;
end;

function TMultiFileHandler.CloseEnabled: Boolean;
begin
 result:=filelist.Count>0;
end;

function TMultiFileHandler.SaveAllEnabled: Boolean;
var i:integer;
begin
 result:=false;
 for i:=0 to filelist.count-1 do
  if TFileInfo(FileList.Objects[i]).ismodified then
   begin
    result:=true;
    exit;
   end;
end;

function TMultiFileHandler.SaveEnabled: Boolean;
begin
 if filelist.count>0 then
   begin
    if TFileInfo(FileList.Objects[ActiveIndex(self)]).isnewfile
    then
     result:=true
    else
     result:=TFileInfo(FileList.Objects[ActiveIndex(self)]).ismodified;
   end
  else
   result:=false;
end;

Function TMUltiFileHandler.IsFileOpen(f : String) : Boolean;
var t:integer;
begin
 replaceC(f,'/','\');
 t:=FileList.Count;
 repeat
  dec(t);
 until (t=-1) or (issamefile(TFileInfo(FileList.objects[t]).path,f));
 result:=t>=0;
end;

Procedure TMultiFileHandler.OpenFileBlind(filename: string);
var
 fi : TFileInfo;
 t:integer;
 dn:string;
begin
 replaceC(filename,'/','\');
 if fileexists(filename) then
 begin
  OpenFile(filename);
  exit;
 end;

 t:=FileList.Count;
 repeat
  dec(t);
 until (t=-1) or (issamefile(TFileInfo(FileList.objects[t]).path,filename));

 if t>=0 then begin
  if t=activeindex(self) then exit;
  OnChanging;
  if assigned(FOnGotoIndex) then
    FOnGotoIndex(self,t);
  if (assigned(FOnOneOpened)) then
    FOnOneOpened(self);
  OnChange;
  exit;
 end;

 If assigned(OnNew) then
 begin
  OnChanging;

  fi:=OnNew(self);
  fi.IsVeryNewFile:=False;
  fi.isNewFile:=false;
  fi.IsModified:=false;
  fi.path:=Filename;
  FileList.AddObject(fi.displayname,fi);
  if assigned(FOnGotoIndex)
   then FOnGotoIndex(self,FileList.count-1);
  if (assigned(FOnOneOpened))
   then FOnOneOpened(self);
  OnChange;
 end;
end;

Function TMultiFileHandler.OpenFile(filename: string) : boolean;
var
 fi : TFileInfo;
 t:integer;
 dn : string;
begin
 result:=false;
 if assigned(FOnBeforeOpen) and (not FOnBeforeOpen(self,filename)) then
  exit;

 replaceC(filename,'/','\');
 filename:=ExpandFilename(filename);
 filename:=ExtractlongPathname(filename);
 if not fileexists(filename) then
  begin
   MessageDlg('Cannot find the file '+filename, mtError, [mbOK], 0);
   exit;
  end;

 t:=FileList.Count;
 repeat
  dec(t);
 until (t=-1) or (issamefile(TFileInfo(FileList.objects[t]).path,filename));

 result:=true;

 if t>=0 then begin
  if t=activeindex(self) then exit;
  OnChanging;
  if assigned(FOnGotoIndex) then
    FOnGotoIndex(self,t);
  if (assigned(FOnOneOpened)) then
    FOnOneOpened(self);
  OnChange;
  exit;
 end;

 if (assigned(FOnOpen)) then
 begin
  fi:=OnOpen(self,filename);
  if not assigned(fi) then exit;

  if (filelist.Count=1)
  and TFileInfo(FileList.Objects[0]).isverynewfile then
   begin
    close;
   end;

  OnChanging;
  fi.path:=FileName;
  fi.notoreload:=False;
  fi.TimeStamp:=FileAge(fi.path);
  dn:=fi.displayName;
  PutAccent(dn);

  FileList.addobject(dn,fi);
  if assigned(FOnGotoIndex) then
    FOnGotoIndex(self,FileList.count-1);
  if (assigned(FOnOneOpened)) then
    FOnOneOpened(self);
  fi.IsModified:=false;
  OnChange;
 end;
end;

procedure TMultiFileHandler.AddMruList(const f:string);
begin
 if mrulist.IndexOf(f)<0 then
   mrulist.Insert(0,f);
 TruncMruList;
end;

procedure TMultiFileHandler.TruncMruList;
var i:integer;
begin
 for i:=MRUList.count-1 downto FMruCount  do
 MRUList.Delete(i);
end;

procedure TMultiFileHandler.LoadMRU;
begin
 HKInifiles.ReadINIStrings(FIniPath,'RecentFiles',MRUList);
 truncMRUList;
end;

function TMultiFileHandler.GetActiveFileInfo: TFileInfo;
begin
 if (assigned(filelist)) and (filelist.Count>0)
  then result:=TFileInfo(FileList.Objects[ActiveIndex(self)])
  else Result:=nil;
end;

procedure TMultiFileHandler.Modified;
var fi : TFileInfo;
begin
 fi:=ActiveFileInfo;
 if assigned(fi) then
 begin
  fi.Modified;
  if assigned(FOnModifyUpdate) then FOnModifyUpdate(self);
 end;
end;

Procedure TMultiFileHandler.ForceReloadAll;
var
 i,age:integer;
 fi : TFileInfo;
begin
 if checkingNow then Exit;
 checkingNow:=True;
 try
  if not assigned(FileList) then exit;
  for i:=0 to FileList.Count-1 do
  begin
   fi:=TFileInfo(FIleList.Objects[i]);
   if not (fileexists(fi.path)) then continue;
   age:=fileage(fi.path);
   if (fi.timestamp<>age) then
   begin
    OnChanging;
    if assigned(FOnGotoIndex) then FOnGotoIndex(self,i);
    if Assigned(FOnReloadActive) then FOnReloadActive(Self);
    fi.TimeStamp:=FileAge(fi.path);
    OnChange;
   end; 
  end;
 finally
  checkingNow:=False;
 end;
end;

procedure TMultiFileHandler.CheckFileAges;
var
 i,age,pr:integer;
 modif:boolean;
 fi : TFileInfo;
begin
 if checkingNow then Exit;
 checkingNow:=True;
 try
  if not assigned(FileList) then exit;
  pr:=ActiveIndex(Self);
  modif:=false;
  for i:=0 to FileList.Count-1 do
  begin
   fi:=TFileInfo(FIleList.Objects[i]);
   if not fi.DontCheckReload then
   if (not fi.IsNewFile) and (not fi.NoToReload) and (fileexists(fi.path)) then
   begin
    age:=fileage(fi.path);
    if (fi.timestamp<>age) then
    begin
     if (ShowRefreshDialog) or (fi.IsModified) then
      fi.NoToReload:=MessageDlg('File date/time for '+fi.path+#13+#10+'has changed. Reload?',
        mtConfirmation, [mbYes, mbNo], 0)=mrno
     else
      fi.NoToReload:=false;

     if fi.NoToReload then Exit;

     OnChanging;
     if assigned(FOnGotoIndex) then FOnGotoIndex(self,i);
     if Assigned(FOnReloadActive) then FOnReloadActive(Self);
     fi.TimeStamp:=FileAge(fi.path);
     OnChange;
     modif:=true;
    end;
   end;
  end;

  if modif then
  begin
   OnChanging;
   if assigned(FOnGotoIndex) then FOnGotoIndex(Self,pr);
   OnChange;
  end;

 finally
  checkingNow:=False;
 end;
end;

procedure TMultiFileHandler.SetDefaultName(const f: String);
var i:integer;
begin
 i:=pos('%d',f);
 if i=0 then
 begin
  fDefaultname:=ExtractFileNoExt(f)+'%d'+
                ExtractFileExt(f);
 end
  else
   FDefaultName:=f;
end;

procedure TMultiFileHandler.SelectByIndex(Index: Integer);
begin
 OnChanging;
 if assigned(FOnGotoIndex) then FOnGotoIndex(self,index);
 OnChange;
end;

end.
