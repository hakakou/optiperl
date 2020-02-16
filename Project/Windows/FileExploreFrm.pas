unit FileExploreFrm; //Modeless

{
 For some reason when the option VETMiscOptions/toChangeNotifierThread is
 true then the program locks
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees, VirtualExplorerTree,HyperStr, optFOlders,CentralImageListMdl,
  jclfileutils, Menus,OptOptions,OptGeneral,optprocs,
  ComCtrls, inifiles, FindFile,SearchFilesFrm, ImgList,scriptinfounit,ActiveX,
  hakageneral, dxBar, OptForm;

type
  TFileExploreForm = class(TOptiForm)
    RecentMenu: TPopupMenu;
    AddtoRecentItem: TMenuItem;
    VET: TVirtualExplorerTreeview;
    N1: TMenuItem;
    RemoveFromFavoritesItem: TMenuItem;
    BarManager: TdxBarManager;
    siFavorites: TdxBarSubItem;
    btnDesktop: TdxBarButton;
    btnNetwork: TdxBarButton;
    btnCurrent: TdxBarButton;
    btnProject: TdxBarButton;
    btnZoom: TdxBarButton;
    btnUp: TdxBarButton;
    btnFolder: TdxBarButton;
    btnRefresh: TdxBarButton;
    btnSearch: TdxBarButton;
    liDrives: TdxBarListItem;
    liFavorites: TdxBarListItem;
    btnAddFav: TdxBarButton;
    btnRemoveFav: TdxBarButton;
    siDrives: TdxBarSubItem;
    procedure btnDesktopClick(Sender: TObject);
    procedure btnNetworkClick(Sender: TObject);
    procedure btnCurrentClick(Sender: TObject);
    procedure btnAddFavClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnZoomClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnProjectClick(Sender: TObject);
    procedure btnFolderClick(Sender: TObject);
    procedure btnRemoveFavClick(Sender: TObject);
    procedure liDrivesClick(Sender: TObject);
    procedure liFavoritesClick(Sender: TObject);
    procedure liFavoritesGetData(Sender: TObject);
    procedure liDrivesGetData(Sender: TObject);
    procedure VETRootChange(Sender: TCustomVirtualExplorerTree);
  private
    ini : TInifile;
    LastRemove : String;
  protected
   Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); override;
   procedure FirstShow(Sender: TObject); override;
   procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix, index: Integer); override;
  public
    Procedure SetFolder(const folder : string);
  end;

var
  FileExploreForm: TFileExploreForm;

implementation
Const
 iniSection = 'TFileExploreForm';
 iniType = 'Type';
 iniRoot = 'Root';

{$R *.DFM}

Procedure TFileExploreForm.SetFolder(const folder : string);
begin
 VET.RootFolderCustomPath:=folder;
end;

procedure TFileExploreForm.liDrivesGetData(Sender: TObject);
var
 s:string;
 i:integer;
begin
 if liDrives.Items.Count=0 then
 begin
  s:=GetDrives;
  for i:=1 to length(s) do
   liDrives.Items.AddObject('Drive '+upcase(s[i]),TObject(s[i]));
 end;  
end;

procedure TFileExploreForm.liDrivesClick(Sender: TObject);
var
 s:string;
begin
 with TDxBarListItem(sender) do
  s:=chr(byte(Items.Objects[ItemIndex]))+':\';
 if directoryexists(s) then
  VET.RootFolderCustomPath:=s;
end;

procedure TFileExploreForm.btnDesktopClick(Sender: TObject);
begin
 vet.RootFolder:=rfDesktop;
end;

procedure TFileExploreForm.btnNetworkClick(Sender: TObject);
begin
 vet.RootFolder:=rfNetWork;
end;

procedure TFileExploreForm.btnCurrentClick(Sender: TObject);
var s:string;
begin
 s:=ActiveScriptInfo.path;
 s:=ExtractFilePath(s);
 if directoryexists(s) then
  VET.RootFolderCustomPath:=s;
end;

procedure TFileExploreForm.btnRemoveFavClick(Sender: TObject);
begin
 if LastRemove<>'' then
  Options.ExplorerRecentList:=
   SingleTStringRemove(Options.ExplorerRecentList,LastRemove);
end;

procedure TFileExploreForm.btnAddFavClick(Sender: TObject);
var
 s:string;
begin
 s:=VET.SelectedPath;
 if not directoryexists(s) then
  s:=ExtractFilePath(s);
 if not directoryexists(s) then Exit;
 s:=IncludeTrailingBackSlash(s);
 Options.ExplorerRecentList:=SingleTStringAdd(Options.ExplorerRecentList,s);
end;

procedure TFileExploreForm.liFavoritesGetData(Sender: TObject);
var
 s:string;
begin
 with TDxBarListItem(sender) do
 begin
  items.Clear;
  s:=IncludeTrailingBackSlash(VET.RootFolderCustomPath);
  LastRemove:='';
  btnAddFav.Enabled:=DirectoryExists(s);
  items.Text:=options.ExplorerRecentList;
  itemindex:=items.IndexOf(s);
  btnRemoveFav.enabled:=itemindex>=0;
  if itemindex>=0 then
    LastRemove:=items[itemindex];
 end;
end;

procedure TFileExploreForm.liFavoritesClick(Sender: TObject);
var
 s:string;
begin
 with TDxBarListItem(sender) do
  s:=items[itemindex];
 if directoryexists(s)
  then VET.RootFolderCustomPath:=s
  else
   if MessageDlg('Cannot find folder. Remove from list?', mtWarning, [mbOK,mbCancel], 0) = mrOK then
    Options.ExplorerRecentList:=SingleTStringRemove(Options.ExplorerRecentList,s);
end;

procedure TFileExploreForm.btnSearchClick(Sender: TObject);
var
 i:integer;
 SearchFilesForm: TSearchFilesForm;
begin
 i:=VET.SelectedFiles.Count;
 if i<=0 then exit;
 SearchFIlesForm:=TSearchFIlesForm.create(application,sdFiles,VET.SelectedPaths,PR_GetFindText(true));
 try
  SearchFilesForm.showmodal;
 finally
  SearchFIlesForm.free;
 end;
end;

procedure TFileExploreForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 FileExploreForm:=nil;

 ini:=TInifile.Create(folders.IniFile);
 try
  ini.WriteString(iniSection,iniRoot,vet.RootFolderCustomPath);
  ini.WriteInteger(iniSection,iniType,integer(vet.RootFolder));
 finally
  ini.free;
 end;
end;

procedure TFileExploreForm.btnZoomClick(Sender: TObject);
var s:string;
begin
 s:=VET.SelectedPath;
 if not directoryexists(s) then
  s:=ExtractFilePath(s);
 if DirectoryExists(s) then
  VET.RootFolderCustomPath:=s;
end;

procedure TFileExploreForm.btnUpClick(Sender: TObject);
var s:string;
begin
 s:=includetrailingbackslash(VET.RootFolderCustomPath);
 if length(s)=3 then
 begin
  vet.RootFolder:=rfDesktop;
  exit;
 end;
 s:=ExtractFilePath(ExcludeTrailingBackSlash(ExtractFilePath(s)));
 if (DirectoryExists(s))
  then VET.RootFolderCustomPath:=s
  else vet.RootFolder:=rfDesktop;
end;

procedure TFileExploreForm.VETRootChange(
  Sender: TCustomVirtualExplorerTree);
var
 s:string;
begin
 case vet.RootFolder of
  rfDesktop : s:='Desktop';
  rfNetwork : s:='Network';
  else s:=VET.RootFolderCustomPath;
 end;
 SetCaption('File Explorer - '+s);
end;

procedure TFileExploreForm.btnRefreshClick(Sender: TObject);
begin
 VET.RebuildTree;
end;

procedure TFileExploreForm.btnProjectClick(Sender: TObject);
var s:string;
begin
 s:=OptOptions.ProjOpt.LocalPath;
 if DirectoryExists(s) then
  VET.RootFolderCustomPath:=s;
end;

procedure TFileExploreForm.FirstShow(Sender: TObject);
var s:string;
begin
  vet.TreeOptions.VETMiscOptions:=vet.TreeOptions.VETMiscOptions+[toChangeNotifierThread];
  ini:=TInifile.Create(folders.IniFile);
  try
   VET.RootFolder:=TRootFolder(
    ini.ReadInteger(iniSection,iniType,Integer(rfPersonal)) );
   if vet.RootFolder=rfCustom then
    vet.RootFolderCustomPath:=
     ini.ReadString(iniSection,iniRoot,'c:\');

   s:=VET.SelectedPath;
   if not DirectoryExists(s) then
    s:=vet.RootFolderCustomPath;
   if DirectoryExists(s) then
    Caption:=s+' - File Explorer';
  finally
   ini.free;
  end;
end;

procedure TFileExploreForm.btnFolderClick(Sender: TObject);
var s,n:string;
begin
 n:='';
 s:=VET.SelectedPath;
 if not DirectoryExists(s) then
  s:=ExtractFilePath(s);
 if (DirectoryExists(s)) and
    (InputQuery('New folder', 'Enter new folder name:', n)) and
    (n<>'') then
 begin
  n:=includetrailingbackslash(s)+n;
  mkdir(n);
  VET.RebuildTree;
 end;
end;

procedure TFileExploreForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=barmanager.Bars[0].ItemLinks;
end;

procedure TFileExploreForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=nil;
 Alignment:=drtNone;
 Pix:=0;
 Index:=InExplorers;
end;


end.






