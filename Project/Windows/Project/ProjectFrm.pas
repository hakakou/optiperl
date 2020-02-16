unit  ProjectFrm; //modeless //VST
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, OptOptions, FTPMdl, hyperfrm,OptProcs,VirtualWideStrings,ActiveX,HKVST,
  ImgList, OptFolders, OptGeneral,HakaGeneral,HakaMessageBOx,FTPUploadFrm,HKDebug,
  ScriptInfoUnit, FileMenuLite, ProjOptFrm, HakaHyper,PBFolderDialog,Variants,
  Menus,HKModeSelectForm, hyperstr, hakafile,StringViewFrm,
  commconvunit,HKComboInputForm,PasswordEntryFrm,OptSearch,IniFiles,ImportFolderFrm,
  DIPcre,CentralImageListMdl,OptForm, VirtualTrees, ComCtrls,hakawin,
  ExtCtrls,SearchFilesFrm,jclfileutils, HKActions, dxBar,RunPerl, HKTransfer,
  JvPlacemnt, DropSource;

type
  TProjectForm = class(TOptiForm)
    OpenDialog: TOpenDialog;
    ActionList: TActionList;
    AddToProjectAction: THKAction;
    RemoveFromProjectAction: THKAction;
    NewProjectAction: THKAction;
    SaveProjectAction: THKAction;
    PublishProjectAction: THKAction;
    OpenProjectAction: THKAction;
    ProjectOptionsAction: THKAction;
    SaveDialog: TSaveDialog;
    AddDialog: TOpenDialog;
    AddCurrentToProjectAction: THKAction;
    FMH: TFileMenuLite;
    SaveProjectAsAction: THKAction;
    ShowManagerAction: THKAction;
    PopupMenu: TPopupMenu;
    miChangeMode: TMenuItem;
    N1: TMenuItem;
    miPublish: TMenuItem;
    N2: TMenuItem;
    miText: TMenuItem;
    miBinary: TMenuItem;
    N3: TMenuItem;
    miPubAgain: TMenuItem;
    SearchInProjectAction: THKAction;
    LibPcre: TDIPcre;
    VST: TVirtualStringTree;
    ImageList: TImageList;
    ViewProjLogAction: THKAction;
    PublishAllAgainAction: THKAction;
    PublishToItem: TMenuItem;
    ImportFolderAction: THKAction;
    BarManager: TdxBarManager;
    siMain: TdxBarSubItem;
    FormStorage: TJvFormStorage;
    ProjOpenRemoteAction: THKAction;
    DropFileSource: TDropFileSource;
    OpenasRemoteItem1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure AddCurrentToProjectActionExecute(Sender: TObject);
    procedure FMHNewFormCaption(const FileName: String);
    function FMHSave(const Filename: String): Boolean;
    procedure NewProjectActionExecute(Sender: TObject);
    procedure SaveProjectActionExecute(Sender: TObject);
    procedure OpenProjectActionExecute(Sender: TObject);
    procedure ProjectOptionsActionExecute(Sender: TObject);
    procedure AddToProjectActionExecute(Sender: TObject);
    procedure RemoveFromProjectActionExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function FMHNew(const Filename: String): Boolean;
    procedure SaveProjectAsActionExecute(Sender: TObject);
    procedure ShowManagerActionExecute(Sender: TObject);
    procedure RemoveFromProjectActionUpdate(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure miChangeModeClick(Sender: TObject);
    procedure miPublishClick(Sender: TObject);
    procedure miTextBinaryClick(Sender: TObject);
    procedure PublishProjectActionExecute(Sender: TObject);
    procedure SearchInProjectActionExecute(Sender: TObject);
    procedure SearchInProjectActionUpdate(Sender: TObject);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VSTDblClick(Sender: TObject);
    function FMHOpen(const Filename: String): Boolean;
    procedure ViewProjLogActionUpdate(Sender: TObject);
    procedure ViewLogProjActionExecute(Sender: TObject);
    procedure PublishAllAgainActionExecute(Sender: TObject);
    procedure PublishToItemClick(Sender: TObject);
    procedure ImportFolderActionExecute(Sender: TObject);
    procedure VSTKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ProjOpenRemoteActionExecute(Sender: TObject);
    procedure miPubAgainClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VSTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VSTDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VSTCreateDataObject(Sender: TBaseVirtualTree;
      out IDataObject: IDataObject);
    procedure VSTDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
    function FMHOpenDialog(var Filename: String;
      const InitialDir: String): Boolean;
    function FMHSaveDialog(var Filename: String;
      const InitialDir: String): Boolean;
    function FMHQueryToSaveDialog(const Str: String): Integer;
    procedure ProjOpenRemoteActionUpdate(Sender: TObject);
    procedure VSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
  protected
    Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); override;
    procedure _ResetFileAges(const session : string);
    procedure _ProjectModified;
    function _GetProjectName: String;
    procedure _Project_TagConvert(var Str: String);
    function _GetLibInfo: String;
    Function _RequestInfoFile(const Path : String) : Pointer;
    procedure _Project_ClearRecentList;
    function _IsFileInProject(const Filename: String): Boolean;
    procedure _Pipetool(Command: Integer; SL : TStringList; Active : TObject);
  public
   {$IFDEF OLE}
   OleObject: Pointer;
   {$ENDIF}
    function CanCloseProject: Boolean;
    procedure DoSetCaption(Filename : String = '');
    Function AddFile(const path:string)  : PVirtualNode;
    procedure AddFolder(const Path, Wildcard: String);
    procedure GetFlatFileList(var List: TNodeList);
    procedure UpdateOptions(FoldersToo : Boolean);
    function FindFile(const FullPath: string): PVirtualNode;
  private
    UploadLog : TStringList;
    CancelPress: Boolean;
    LastTextMode : Integer;
    LastCurrentDir : String;
    RealInitial : String;
    NonPublished : PVirtualNode;
    mFTP : TBaseTransfer;
    SelList : TList;
    procedure mFTPStatus(ASender: TObject; const Status: String);
    Function ForceDirectory(Const path : string; Abs : Boolean) : Boolean;
    function GetFilename(Node : PVirtualNode) : string;
    procedure GetFileList(Var List: TPrItemList);
    function GetFolder(const FullPath: string): PVirtualNode;
    function FindFolder(Name: String; Parent: PVirtualNode): PVirtualNode;
    procedure SetGlobalOptions;
    procedure Reorganize;
    procedure ClearTree;
    procedure SetPrItem(Source: TPrItem);
    procedure SetAbsPathMode(const Folder,PublishTo: String; Mode: Integer);
    function GetFolderFromNode(Node : PVirtualNode; out Abs : Boolean; ForPublishing : Boolean) : String;
    procedure PublishFileNode(Node: PVirtualNode);
    function GetNodeByPath(Const Path : String; Parent : PVirtualNode) : PVirtualNode;
    procedure RemoveNode(ANode: PVirtualNode; Prompt: Boolean);
  end;

var
  ProjectForm: TProjectForm;

implementation
{$R *.DFM}

const
 colPath = 0;
 colMode = 1;
 colPublish = 2;
 colTransfer = 3;
 colStatus = 4;
 DefFolderMode = 755;
 iniDirs = '*Directories*';

Procedure TProjectForm.GetFlatFileList(var List : TNodeList);
var
 Node : PVirtualNode;
 PrItem : PPrItem;
 Count,index:integer;
begin
 Node:=VST.GetFirst;
 index:=-1;
 Count:=vst.RootNodeCount*10;
 SetLength(List,Count);
 while assigned(node) do
 begin
  PrItem:=VST.GetNodeData(node);
  if not PrItem.IsFolder then
  begin
   inc(index);
   if index>=count then
   begin
    count:=count+50;
    setlength(List,count);
   end;
   List[index]:=Node;
  end;
  node:=VST.GetNext(node);
 end;
 inc(index);
 setlength(list,index);
end;

Procedure TProjectForm.GetFileList(var List : TPrItemList);
var
 Node : PVirtualNode;
 PrItem : PPrItem;
 Count,index:integer;
begin
 Node:=VST.GetFirst;
 index:=-1;
 Count:=vst.RootNodeCount*10;
 SetLength(List,Count);
 while assigned(node) do
 begin
  PrItem:=VST.GetNodeData(node);
  if not PrItem.IsFolder then
  begin
   inc(index);
   if index>=count then
   begin
    count:=count+50;
    setlength(List,count);
   end;
   List[index]:=PrItem^;
  end;
  node:=VST.GetNext(node);
 end;
 inc(index);
 setlength(list,index);
end;

Function TProjectForm._GetLibInfo : String;
var
 i,j : Integer;
 f,dir,s,w,tlib:string;
 List : TPrItemList;
begin
 result:='';
 GetFileList(list);
 for i:=0 to Length(List)-1 do
 with list[i] do
 if fileexists(Path) then
 begin
  f:=path;
  dir:=ExtractFilePath(f);
  tlib:='';
  s:=#13#10+LoadStr(f);
  if LibPcre.matchStr(s)=2 then
  begin
   s:=libPcre.SubStr(1);
   j:=1;
   repeat
    W := Trim(parse(S,',',j));
    w:=Removequotes(w,'''');
    if Length(W)=0 then continue;
    w:=GetAbsolutePath(dir,w);
    if directoryExists(w) then
     tlib:=tlib+w+';';
   until (j<1) or (j>Length(S));
  end;
  result:=result+tlib;
 end;

 {
 use lib ( './Data'   ,
          './Sources',
          './Skin'   ,
          './Languages',
          './',
        );
}

end;

procedure TProjectForm.FormCreate(Sender: TObject);
begin
 PC_Project_Pipetool:=_Pipetool;
 PC_Project_ClearRecentList:=_Project_ClearRecentList;
 PC_Project_TagConvert:=_Project_TagConvert;
 PR_ProjectModified:=_ProjectModified;
 PR_GetProjectName:=_GetProjectName;
 PR_IsFileInProject:=_IsFileInProject;
 PR_GetLibInfo:=_GetLibInfo;
 PR_ResetFileAges:=_ResetFileAges;
 PR_RequestInfoFile:=_RequestInfoFile;

 SelList:=TList.Create;
 UploadLog:=TStringList.Create;
 VST.NodeDataSize:=sizeof(TPrItem);
 FMH.New;
end;

procedure TProjectForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if not IsLoadingLayout then
  MessageDlgMemo('You closed the project manager. To show again, select'+#13+#10+'"Show Project Manager" from the Project menu.', mtInformation, [mbOK], 0, 1500);
end;

function TProjectForm.FindFolder(Name : String; Parent : PVirtualNode) : PVirtualNode;
var
 PrItem : PPrItem;
begin
 result:=vst.GetFirstChild(parent);
 while assigned(result) do
 begin
  pritem:=VST.GetNodeData(result);
  if ( (prItem.IsFolder) and (AnsiCompareText(Name,prItem.Path)=0) )
   then exit;
  result:=vst.GetNextSibling(result);
 end;
 result:=nil;
end;

function TProjectForm.GetFolderFromNode(Node : PVirtualNode; out Abs : Boolean; ForPublishing : Boolean) : String;
var
 PrItem : PPrItem;
begin
 result:='';
 abs:=false;
 pritem:=vst.GetNodeData(node);

 if (forPublishing) and (assigned(prItem)) and (prItem.PublishTo<>'') then
 begin
  result:=PrItem.PublishTo;
  abs:=true;
  exit;
 end;

 while node<>vst.RootNode do
 begin
  pritem:=vst.GetNodeData(node);
  result:=pritem.Path+'\'+result;
  node:=node.Parent;
 end;
end;

function TProjectForm.FindFile(const FullPath : string) : PVirtualNode;
var
 PrItem : PPrItem;
begin
 result:=vst.GetFirst;
 while assigned(result) do
 begin
  pritem:=VST.GetNodeData(result);
  if  (not prItem.IsFolder) and
      (AnsiCompareText(fullpath,prItem.Path)=0)
   then exit;
  result:=vst.GetNext(result);
 end;
 result:=nil;
end;

function TProjectForm.GetFolder(const FullPath : string) : PVirtualNode;
var
 PrItem : PPrItem;
 Node:PVirtualNode;
 w,path : String;
 i : Integer;
begin
 I := 1;
 path:=ExcludeTrailingBackSlash(fullpath);
 node:=VST.RootNode;
 result:=node;
 repeat
  W:=Parse(path,'\',I);
  if Length(W)=0 then Continue;
  result:=FindFolder(w,node);
  if result=nil then
  begin
   result:=VST.AddChild(node);
   prItem:=vst.GetNodeData(result);
   prItem.Path:=w;
   prItem.IsFolder:=true;
   prItem.PublishTo:='';
   prItem.Mode:=DefFolderMode;
  end;
  node:=result;
 until (I<1) or (I>Length(path));
end;

Procedure TProjectForm.ClearTree;
var
 PrItem : PPrItem;
begin
 VST.Clear;
 NonPublished:=VST.AddChild(vst.RootNode);
 prItem:=vst.GetNodeData(NonPublished);
 prItem.IsFolder:=true;
 prItem.Path:='Not Published';
 prItem.nonPublished:=true;
 NonPublished.States:=NonPublished.States - [vsVisible];
 VST.VisiblePath[NonPublished]:=false;
end;

Function TProjectForm.addFile(const path : string) : PVirtualNode;
var
 rel : string;
 pbl,Text:Boolean;
 Mode :Integer;
 PrItem : PPrItem;
begin
 Result:=nil;
 if findfile(path)<>nil then Exit;
 rel:=ExtractRelativePath(IncludeTrailingBackSlash(projOpt.LocalPath),path);
 FTPMod.GetRecommendedMode(path,text,mode);
 pbl:=false;
 if isPathRelative(rel) and not filestartswith('..\',rel) then
  result:=GetFolder(extractFilepath(rel))
 else
  begin
   pbl:=true;
   if ProjOpt.DisplayNonPublished then
    begin
     result:=NonPublished;
     NonPublished.States:=NonPublished.States + [vsVisible];
    end
   else
    result:=VST.RootNode
  end;
 result:=vst.AddChild(result);
 PrItem:=vst.GetNodeData(Result);
 prItem.Path:=path;
 prItem.IsFolder:=false;
 prItem.Mode:=mode;
 prItem.Publish:=true;
 prItem.Text:=text;
 prItem.Status:=stPublish;
 prItem.publishTo:='';
 prItem.Crc:=0;
 prItem.nonPublished:=pbl;
 prItem.FileAge:=0;
end;

procedure TProjectForm.AddCurrentToProjectActionExecute(Sender: TObject);
begin
 if assigned(ActiveScriptInfo) then
 begin
  if ActiveScriptInfo.IsNewFile then
  begin
   MessageDlg('Please save first.', mtError, [mbOK], 0);
   exit;
  end;
  addfile(ActiveScriptInfo.path);
  FMH.Dirty:=true;
 end;
end;

procedure TProjectForm.DoSetCaption(Filename : String = '');
begin
 if filename='' then
  filename:=FMH.Filename;
 SetCaption('Project '+extractFileNoExt(FileName));
end;

procedure TProjectForm.FMHNewFormCaption(const FileName: String);
begin
 DoSetCaption(Filename);
 OptiTitleProject:=ExtractFileNoExt(FileName);
 PR_SetTitle;
end;

procedure TProjectForm.NewProjectActionExecute(Sender: TObject);
begin
 if assigned(PR_SaveAllInfos) then
  PR_SaveAllInfos;
 FMH.New;
end;

procedure TProjectForm.SaveProjectActionExecute(Sender: TObject);
begin
 FMH.Save;
end;

procedure TProjectForm.OpenProjectActionExecute(Sender: TObject);
begin
 if assigned(PR_SaveAllInfos) then
  PR_SaveAllInfos;
 FMH.Open;
end;

procedure TProjectForm.UpdateOptions(FoldersToo : Boolean);
begin
  SetGlobalOptions;
  if FoldersToo then
  begin
   vst.BeginUpdate;
   try
    ReOrganize;
   finally
    vst.EndUpdate;
   end;
  end;
  FMH.Dirty:=true;
end;

procedure TProjectForm.ProjectOptionsActionExecute(Sender: TObject);
var
 PrLocal : String;
 PrDisp : boolean;
begin
 ProjOptForm:=TProjOptForm.Create(Application);
 try
  prLocal:=ProjOpt.LocalPath;
  prDisp:=projOpt.DisplayNonPublished;
  if ProjOptForm.ShowModal=mrOK then
   UpdateOptions((prDisp<>projOpt.DisplayNonPublished) or (prLocal<>projOpt.LocalPath));
 finally
  ProjOptForm.Free;
 end;
end;

procedure TProjectForm.Reorganize;
var
 List : TPrItemList;
 i:integer;
begin
 GetFileList(list);
 ClearTree;
 for i:=0 to length(list)-1 do
  SetPrItem(list[i]);
end;

procedure TProjectForm.SetPrItem(Source : TPrItem);
var
 node : PVirtualNode;
 PrItem : PPrItem;
 dis : Boolean;
begin
 node:=addFile(Source.Path);
 if assigned(node) then
 begin
  PrItem:=vst.GetNodeData(node);
  dis:=pritem.NonPublished;
  prItem^:=Source;
  prItem.NonPublished:=dis;
 end;
end;

procedure TProjectForm.SetGlobalOptions;
begin
 if assigned(PR_RootServerUpdated) then
  PR_RootServerUpdated;
 PC_OptionsUpdated(HKO_Lite);
 UpdateModSearchPaths;
 VST.Header.Columns[0].Text:='Relative to '+ProjOpt.localPath;
end;

procedure TProjectForm.AddToProjectActionExecute(Sender: TObject);
var
 i:integer;
begin
 if AddDialog.Execute then
 begin
  with AddDialog.Files do
   for i:=0 To Count-1 do
    AddFile(strings[i]);
  FMH.Dirty:=true;
 end;
end;

procedure TProjectForm.RemoveNode(ANode : PVirtualNode; Prompt : Boolean);
var
 prItem : PPrItem;
 Parent,node : PVirtualNode;
begin
  prItem:=vst.getnodedata(ANode);
  if Prompt then
   if (prItem.IsFolder) and
      (MessageDlg('Are you sure you want to remove the folder:'+#13#10+pritem.Path+#13#10'with all it''s files from the project?', mtConfirmation, [mbOK,mbCancel], 0) <> mrOk)
    then exit;
  parent:=ANode.parent;
  if ANode=nonPublished
   then VST.DeleteChildren(ANode)
   else VST.DeleteNode(ANode);

  node:=parent;
  if node<>nonPublished then
  begin
   while (node<>Vst.RootNode) and (node.ChildCount=0) do
   begin
    Parent:=node.Parent;
    VST.DeleteNode(Node);
    node:=parent;
   end;
  end;

  FMH.Dirty:=true;
  if NonPublished.ChildCount=0 then
   NonPublished.States:=NonPublished.States - [vsVisible];
  VST.Invalidate;
end;

procedure TProjectForm.RemoveFromProjectActionExecute(Sender: TObject);
var
 prItem : PPrItem;
 Parent,node : PVirtualNode;
 OK : Boolean;
 Count : Integer;
begin
 if not Assigned(VST.focusedNode) then exit;

 OK:=true;
 node:=vst.GetFirstSelected;
 parent:=node.Parent;
 count:=0;

 while assigned(node) do
 begin
  pritem:=vst.GetNodeData(node);
  if pritem.IsFolder then
  begin
   OK:=false;
   break;
  end;
  inc(count);
  node:=vst.GetNextSelected(node)
 end;

 if (OK) and (count>1) then
  begin
   if MessageDlg('Are you sure you want to remove '+inttostr(count)+' files?', mtConfirmation, [mbOK,mbCancel], 0)=mrOK then
   begin
    node:=vst.GetFirstSelected;
    while assigned(node) do
    begin
     RemoveNode(node,false);
     node:=vst.GetNextSelected(node)
    end;
   end;
  end

 else
  RemoveNode(Vst.FocusedNode,true);
end;

function TProjectForm.GetFilename(Node : PVirtualNode): string;
var prItem : PPrItem;
begin
 prItem:=vst.getnodedata(node);
 if assigned(prItem)
  then result:=prItem.Path
  else result:='';
end;

procedure TProjectForm.FormDestroy(Sender: TObject);
begin
 SelList.free;
 UploadLog.Free;
end;

function TProjectForm.FMHNew(const Filename: String): Boolean;
begin
 options.ActiveDebScript:='';
 ProjOpt.setdefaults;
 Result:=True;
 ClearTree;
 SetGlobalOptions;
 if assigned(PR_ReloadAllInfos) then
  PR_ReloadAllInfos;
end;

procedure TProjectForm.SaveProjectAsActionExecute(Sender: TObject);
begin
 FMH.SaveAs;
end;

procedure TProjectForm.ShowManagerActionExecute(Sender: TObject);
begin
 Show;
end;

procedure TProjectForm.RemoveFromProjectActionUpdate(Sender: TObject);
begin
 RemoveFromProjectAction.Enabled:=Assigned(VST.focusedNode);
end;

Function TProjectForm.CanCloseProject : Boolean;
begin
 PR_SaveAllInfos;
 result:=FMH.CanClose;
 if fmh.IsNew
  then options.LastOpenProject:=''
  else options.LastOpenProject:=fmh.Filename;
end;

procedure TProjectForm.PopupMenuPopup(Sender: TObject);
var
 i:integer;
 node : PVirtualNode;
 prItem : PPrItem;
 CountFold,CountPub,CountText,CountBin : Integer;
begin
 sellist.Clear;
 CountPub:=0;
 CountText:=0;
 CountBin:=0;
 CountFold:=0;

 node:=vst.GetFirstSelected;
 while assigned(node) do
 begin
  pritem:=vst.GetNodeData(node);
  if not pritem.NonPublished then
  begin
   sellist.Add(pritem);
   if pritem.IsFolder then
    inc(countFold)
   else
    begin
     if pritem.Publish then inc(CountPub);
     if pritem.Text
      then inc(counttext)
      else inc(countBin);
    end;
  end;
  node:=vst.GetNextSelected(node)
 end;


 for i:=0 to PopupMenu.Items.Count -1 do
  PopupMenu.Items[i].Enabled:=SelList.Count>0;

 miPublish.Checked:=CountPub=sellist.Count;
 miText.Checked:=CountText=sellist.Count;
 miBinary.Checked:=CountBin=sellist.Count;

 PublishToItem.Visible:=CountFold=sellist.Count;
 miText.Visible:=CountFold<>sellist.Count;
 miBinary.Visible:=CountFold<>sellist.Count;
 miPublish.Visible:=CountFold<>sellist.Count;
 miPubAgain.Visible:=CountFold<>sellist.Count;
end;

procedure TProjectForm.miChangeModeClick(Sender: TObject);
var
 prItem : PPrItem;
 m,i:integer;
begin
 prItem:=sellist[0];
 m:=prItem.Mode;
 if CHmodeselect(m) then
 begin
  for i:=0 to sellist.Count-1 do
  begin
   pritem:=sellist[i];
   prItem.Crc:=0;
   prItem.Mode:=m;
  end;
  fmh.Dirty:=True;
  VST.invalidate;
 end;
end;

procedure TProjectForm.miPubAgainClick(Sender: TObject);
var
 prItem : PPrItem;
 i:integer;
begin
 for i:=0 to sellist.Count-1 do
 begin
  prItem:=sellist[i];
  prItem.Status:=stPublish;
  prItem.Crc:=0;
  prItem.FileAge:=0;
 end;
 fmh.Dirty:=True;
 VST.invalidate;
end;

procedure TProjectForm.miPublishClick(Sender: TObject);
var
 prItem : PPrItem;
 i:integer;
begin
 for i:=0 to sellist.Count-1 do
 begin
  prItem:=sellist[i];
  prItem.Publish:=not miPublish.Checked;
 end;
 fmh.Dirty:=True;
 VST.invalidate;
end;

procedure TProjectForm.miTextBinaryClick(Sender: TObject);
var
 prItem : PPrItem;
 i:integer;
begin
 for i:=0 to sellist.Count-1 do
 begin
  prItem:=sellist[i];
  PrItem.Crc:=0;
  PrItem.Text:=TMenuItem(sender).Tag=0;
 end;
 fmh.Dirty:=True;
 VST.invalidate;
end;

Function TProjectForm.GetNodeByPath(Const Path : String; Parent : PVirtualNode) : PVirtualNode;
var
 node : PVirtualNode;
 prItem : PPrItem;
begin
 node:=vst.GetFirstChild(parent);
 result:=nil;
 while assigned(node) do
 begin
  prItem:=vst.GetNodeData(node);

  if (node<>nonPublished) and (node.Parent<>nonPublished) and (prItem.isFolder)
  then
  begin
   if prItem.Path=Path then
   begin
    result:=node;
    exit;
   end;
  end;

  node:=vst.GetNextSibling(node);
 end;
end;

Function TProjectForm.ForceDirectory(const path : string; Abs : Boolean) : Boolean;
var
 i:integer;
 w:string;
 tNode,node : PVirtualNode;
 prItem : PPrItem;
begin
 result:=true;

 try
  mFTP.ChangeDirectory(path);
  exit;
 except
  on exception do
 end;

 if (realInitial='/') or (realinitial='') or (Abs) then
  begin
   if path[1]='/' then mFTP.ChangeDirectory('/');
   I := 1;
  end
 else
  begin
   mFTP.ChangeDirectory(RealInitial);
   i:=length(realInitial)+1;
  end;

 node:=vst.RootNode;
 repeat
  W := Parse(path,'/',I);
  if Length(w)>0 then
  begin
   tnode:=getNodeByPath(w,node);
   if assigned(TNode) then
    begin
     node:=tnode;
     prItem:=vst.GetNodeData(node);
    end
   else
    prItem:=nil;

   try
    mFTP.ChangeDirectory(w);
   except
    on exception do
    begin
     //No directory? create it

     try
      mFTP.CreateDirectory(w);
     except
      on exception do
      begin
       result:=false;
       if assigned(prItem) then
        prItem.Status:=stError;
       exit;
      end;
     end;

     //CHange it's mod
     if assigned(prItem) then
     begin
       try
        mFTp.CHMod(w,prItem.Mode);
       except on exception do
        prItem.status:=stNotMode;
       end;
     end;

     //Enter it
     try
      mFTP.ChangeDirectory(w);
     except
      on exception do
      begin
       result:=false;
       if assigned(prItem) then
        prItem.Status:=stError;
       exit;
      end;
     end;

    end;
   end;

   if assigned(prItem) then
    prItem.Status:=stOk;

 end;
 until (I<1) or (I>Length(path));
end;

procedure TProjectForm._ResetFileAges(const session : string);
var
 node : PVirtualNode;
 prItem : PPrItem;
begin
 if session=projopt.Session then
 begin
  Assert(false,'LOG Reseting project file ages');
  node:=vst.GetFirst;
  while assigned(node) do
  begin
   pritem:=VST.GetNodeData(node);
   prItem.FileAge:=0;
   node:=vst.GetNext(node);
  end;
 end;
end;

procedure TProjectForm.PublishFileNode(Node : PVirtualNode);
var
 Dir,RemFile,TempFile : String;
 Text : Boolean;
 prItem : PPrItem;
 fa : Integer;
 abs : boolean;
 i:integer;
begin
 prItem:=vst.getnodedata(node);
 dir:=GetFolderFromNode(node.parent,abs,true);
 replaceC(dir,'\','/');
 if (dir<>'') and (dir[1]='/') then
  delete(dir,1,1);

 if abs then
  dir:='/'+dir;

 if not abs then
  dir:=RealInitial+dir;

 text:=prItem.Text;
 fa:=sysutils.FileAge(pritem.Path);

 if pritem.FileAge=fa then
 begin
  prItem.Status:=stNotChanged;
  exit;
 end;

 if not FTPMod.DoFilePreProcess(ProjOpt.Session,prItem.Path,TempFile,text) then
 begin
  prItem.Status:=stError;
  exit;
 end;

 if  FileGetsize(tempfile)<>0
  then i:=GetFileCrc32(TempFile)
  else i:=100;

 if i=prItem.Crc then
 begin
  prItem.Status:=stNotChanged;
  if prItem.Path<>TempFile then
   DeleteFile(tempFile);
  exit;
 end;

 if not assigned(mFTP) then exit;
 if (dir<>LastCurrentDir) then
 begin
  if (dir<>IncludeTrailingSlash(mFTP.CurrentDirectory)) and (not ForceDirectory(dir,abs)) then
  begin
   raise Exception.Create('Could not create directory '+dir);
   exit;
  end;
  LastCurrentDir:=dir;
 end;

 text:=prItem.Text;
 RemFile:=ExtractFileName(prItem.Path);

 if not assigned(mFTP) then exit;
 if ((text) and (LastTextMode<>0)) or ((not text) and (lastTextMode<>1)) then
 begin
   Mftp.TextTransfer:=text;
   if text
    then LastTextMode:=0
    else LastTextMode:=1;
 end;

 try
  mFTP.Put(TempFile,RemFile);
  PrItem.Crc:=i;
  prItem.FileAge:=fa;
  prItem.Status:=stOK;
 except
  on exception do prItem.status:=stError;
 end;

 try
  mFTP.CHMod(RemFile,prItem.mode);
 except
  on exception do prItem.Status:=stNotMode;
 end;

 if prItem.Path<>TempFile then
  DeleteFile(tempFile);
end;

procedure TProjectForm.PublishProjectActionExecute(Sender: TObject);
var
 List : TPrItemList;
 Node : PVirtualNode;
 prItem : PPrItem;
 DidSomething : Boolean;
 s:string;
begin
 PR_QuickSave;
 CancelPress:=false;
 DidSomething:=false;
 GetFileList(list);
 LastTextMode:=-1;
 LastCurrentDir:=#0;

 if length(list)=0 then
 begin
  MessageDlg('No files to publish!', mtError, [mbOK], 0);
  exit;
 end;

 if ProjOpt.Session='' then
 begin
  MessageDlg('Please enter a valid session in the '+#13+#10+'project options dialog.', mtError, [mbOK], 0);
  exit;
 end;

 UploadLog.Clear;
 FTPUploadForm:=TFTPUploadForm.Create(Application);
 FTPUploadForm.CancelPress:=@CancelPress;
 FTPUploadForm.Show;
 try
  FTPMod.OpenSession(ProjOpt.Session,mFTP,false,nil,mftpStatus,ProjOpt.RemotePath);
  FTPUploadForm.Trans:=mftp;
  FTPUploadForm.btnClose.Enabled:=true;

  s:=ProjOpt.RemotePath;
  replaceC(s,'\','/');
  replaceSC(s,'//','/',false);

  if Length(s)=0 then
   RealInitial:=IncludeTrailingSlash(mFTP.CurrentDirectory)
  else
   if (s[1] in ['/']) or ((length(s)>=3) and (s[2]=':') and (isAlphaChar(s[1]))) then
    realInitial:=IncludeTrailingSlash(s)
  else
   RealInitial:=IncludeTrailingSlash(mFTP.CurrentDirectory)+IncludeTrailingSlash(s);

  node:=VST.GetFirst;
  while assigned(node) do
  begin
     if CancelPress then break;
     if (node<>nonPublished) and (node.Parent<>nonPublished) then
     begin
      prItem:=VST.GetNodeData(node);
      if (not prItem.IsFolder) and (prItem.Publish) then
      begin
       DidSomething:=true;
       if FileExists(prItem.Path)
        then PublishFileNode(node)
        else prItem.Status:=stNotFound;
      end;
     end;
     node:=VST.GetNext(node);
  end;

 finally
   if DidSomething then
   fmh.Dirty:=True;
  VST.Invalidate;
  FTPMod.closeSession(mftp);
  FTPUploadForm.Free;
 end;
end;

procedure TProjectForm.SearchInProjectActionExecute(Sender: TObject);
var
 SearchFilesForm: TSearchFilesForm;
 sl:TStringList;
 List : TPrItemList;
 i:integer;
begin
 PR_QuickSave;

 sl:=TStringList.create;
 try
  GetFileList(list);
  for i:=0 to length(list)-1 do
    sl.add(list[i].Path);

  if sl.Count>0 then
  begin
   SearchFIlesForm:=TSearchFIlesForm.create(application,sdProject,sl,PR_GetFindText(true));
   try
    SearchFilesForm.showmodal;
   finally
    SearchFIlesForm.free;
   end;
  end;
 finally
  sl.Free;
 end;
end;

procedure TProjectForm.SearchInProjectActionUpdate(Sender: TObject);
begin
 SearchInProjectAction.Enabled:=vst.RootNodeCount>0;
end;

procedure TProjectForm._Project_ClearRecentList;
begin
 FMH.Recent.Clear;
end;

procedure TProjectForm._Project_TagConvert(var str : String);
begin
 replaceSC(str,'%data0%',projopt.Data0,true);
 replaceSC(str,'%data1%',projopt.Data1,true);
 replaceSC(str,'%data2%',projopt.Data2,true);
 replaceSC(str,'%data3%',projopt.Data3,true);
 replaceSC(str,'%data4%',projopt.Data4,true);
 replaceSC(str,'%data5%',projopt.Data5,true);
 replaceSC(str,'%data6%',projopt.Data6,true);
 replaceSC(str,'%data7%',projopt.Data7,true);
 replaceSC(str,'%data8%',projopt.Data8,true);
 replaceSC(str,'%data9%',projopt.Data9,true);
end;

procedure TProjectForm._pipetool(Command : Integer; SL : TStringList; Active : TObject);
var
 i:integer;
 List : TPrItemList;
begin
 case command of
  HKP_SEND_PROJECT:
  begin
   GetFileList(list);
   for i:=0 to length(list)-1 do
    sl.add(list[i].Path);
  end;

  HKP_GET_PROJECT:
  begin
   cleartree;
   for i:=0 to sl.count-1 do
    if fileexists(sl[i]) then
      addfile(sl[i]);
   FMH.Dirty:=true;
  end;

 end;
end;

procedure TProjectForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 PrItem : PPrItem;
begin
 PrItem:=vst.GetNodeData(node);
 SetLength(PrItem.Path,0);
 SetLength(PrItem.publishTo,0);
 SetLength(PrItem.Info,0);
end;

procedure TProjectForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
 PrItem : PPrItem;
const
 YesNo : array[Boolean] of string = ('False','True');
 TextStr : array[Boolean] of string = ('Binary','Text');
 StatusStr : array[TStatus] of string =
 ('Publish','OK','Not changed','Not found','Error','Permissions not set');
begin
 PrItem:=vst.GetNodeData(node);
 if not assigned(PrItem) then exit;

 if (prItem.NonPublished) then
 begin
  if column<>ColPath
   then celltext:=''
   else begin
    if node=NonPublished
     then cellText:=prItem.Path
     else CellText:=ExtractRelativePath(
      IncludeTrailingBackSlash(ProjOpt.localpath),prItem.Path);
   end;
  exit;
 end;

 if (prItem.IsFolder) then
  begin
   if column=ColPath
    then
     begin
      CellText:=prItem.Path;
      if pritem.PublishTo<>'' then CellText:=CellText+' -> '+prItem.PublishTo;
     end
   else
   if column=ColMode
    then CellText:=IntToStr(prItem.Mode)
   else
     CellText:='';
  end
 else
  case column of
   colPath : CellText:=ExtractFileName(PrItem.Path);
   colMode : CellText:=IntToStr(prItem.Mode);
   colPublish : CellText:=YesNo[prItem.publish];
   colTransfer : CellText:=TextStr[prItem.text];
   colStatus : begin
    if prItem.publish
     then CellText:=StatusStr[prItem.status]
     else CellText:='Don''t publish';
   end;
  end;
end;

procedure TProjectForm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
 PrItem : PPrItem;
begin
 if (column=0) and (Kind in [ikNormal,ikSelected]) then
 begin
  PrItem:=vst.GetNodeData(node);
  if PrItem.IsFolder
   then imageindex:=0
   else imageindex:=1;
 end;
end;

procedure TProjectForm.VSTDblClick(Sender: TObject);
begin
 if Assigned(VST.focusedNode) then
 begin
  PR_OPenFile(GetFilename(VST.focusedNode));
  PR_FocusEditor;
 end;
end;

Procedure TProjectForm.SetAbsPathMode(Const Folder,PublishTo : String; Mode : Integer);
var
 PrItem : PPrItem;
 node : PVirtualNode;
begin
 node:=GetFolder(Folder);
 if (node<>nil) and (node<>vst.RootNode) and (node<>nonPublished) then
 begin
  prItem:=VST.GetNodeData(node);
  prItem.PublishTo:=publishTo;
  prItem.Mode:=mode;
 end;
end;

function TProjectForm.FMHSave(const Filename: String): Boolean;
var
 s,t,v1,v2 : string;
 dumb : boolean;
 ini : TInifile;
 PrItem : PPrItem;
 Node : PVirtualNode;
 i:integer;
 SL : TStringList;
begin
 Result:=True;
 saveStr('',filename);
 SL:=TStringList.Create;
 ini:=TIniFile.Create(filename);
 ini.Clear;
 try
  PR_SetLastOpen(false);
  PR_SaveAllInfos;
  projOpt.SaveToIni(ini);
  node:=VST.GetFirst;
  while assigned(node) do
  begin
   if node<>nonPublished then
   begin
    prItem:=vst.GetNodeData(node);
    if prItem.IsFolder then
     begin
      s:=ExcludeTrailingBackSlash(GetFolderFromNode(node,dumb,false));
      t:=inttostr(prItem.Mode);
      if trim(pritem.PublishTo)<>''
       then t:=t+'='+pritem.PublishTo;
      ini.WriteString(iniDirs,EncodeIni(s),t);
     end
    else
     begin
      s:=GetRelativeFile(projOpt.LocalPath,prItem.Path);
      s:=EncodeIni(s);
      ini.WriteInteger(s,'Mode',prItem.Mode);
      ini.WriteBool(s,'Publish',prItem.Publish);
      ini.WriteBool(s,'Text',prItem.Text);
      ini.WriteInteger(s,'CRC',prItem.Crc);

      sl.Text:=prItem.Info;
      for i:=0 to sl.Count-1 do
       if parsewithequal(sl[i],v1,v2) then
        ini.WriteString(s,v1,v2);
     end;
   end;
   node:=vst.GetNext(node);
  end;
 finally
  sl.free;
  ini.free;
 end;
end;

function TProjectForm.FMHOpen(const Filename: String): Boolean;
type
 TFolder = Record
  Path : String;
  Mode : Integer;
  PublishTo : String;
 end;
var
 list : TPrItemList;
 ini : TiniFile;
 sl : TStringList;
 Folders : Array of TFolder;
 i,j:integer;
 NotFound,tl : TStringList;
 s1,s2,t : string;
 Node : PVirtualNode;
 Data : PPrItem;
begin
 NotFound:=TstringList.Create;
 result:=true;
 ClearTree;

 SetLength(Folders,0);
 SetLength(list,0);
 vst.BeginUpdate;
 try
  ini:=TIniFile.Create(filename);
  //XARKA INIFILE
  sl:=TStringList.create;
  try
   projOpt.LoadFromIni(ini);
   ini.ReadSections(sl);

   for i:=sl.Count-1 downto 0 do
    if StringStartsWith('*',sl[i]) then
     sl.Delete(i);

   setLength(list,sl.Count);
   for i:=0 to sl.Count-1 do
   begin
    s1:=DecodeIni(sl[i]);
    s2:=GetAbsoluteFile(projOpt.LocalPath,s1);
    list[i].Path:=s2;
    list[i].Mode:=ini.ReadInteger(sl[i],'Mode',DefFolderMode);
    list[i].Publish:=ini.ReadBool(sl[i],'Publish',true);
    list[i].Text:=ini.ReadBool(sl[i],'Text',true);
    list[i].Crc:=ini.ReadInteger(sl[i],'CRC',0);
    list[i].Status:=stPublish;
    list[i].IsFolder:=false;
    list[i].FileAge:=0;
    list[i].NonPublished:=false;

    tl:=TStringList.Create;
    ini.ReadSectionValues(sl[i],tl);
    for j:=TL.Count-1 downto 0 do
     if not StringStartsWith('_',tl[j]) then
      tl.Delete(j);
    List[i].Info:=tl.Text;
    tl.free;  
   end;

   sl.Clear;
   ini.ReadSectionValues(iniDirs,sl);
   SetLength(Folders,Sl.Count);
   for i:=0 to sl.Count-1 do
   if parseWithEqual(sl[i],s1,s2) then
   begin
    Folders[i].Path:=DecodeIni(s1);
    if ParseWithEqual(s2,s1,t) then
     begin
      Folders[i].Mode:=StrToIntDef(s1,DefFolderMode);
      Folders[i].PublishTo:=t;
     end
    else
      Folders[i].Mode:=StrToIntDef(s2,DefFolderMode);
   end;

  finally
   ini.free;
   sl.free;
  end;

  for i:=0 to length(list)-1 do
  begin
   if not fileexists(list[i].Path) then
    NotFound.Add(list[i].Path);
   SetPrItem(list[i]);
  end;
  for i:=0 to length(Folders)-1 do
   SetAbsPathMode(folders[i].Path,Folders[i].PublishTo,Folders[i].Mode);

 finally
  vst.EndUpdate;
 end;

 SetGlobalOptions;
 fmh.IsNew:=false;
 pr_LoadLayout(projOpt.Layout);
 PR_ReUpdateLastOpen(false);
 PR_ReloadAllInfos;

 if NotFound.Count>0 then
 begin                                    
  MessageDlgMemo(IntToStr(NotFound.count)+' file(s) in the project where not found. These have been marked with red color.', mtWarning, [mbOK], 0, 2300);
  for i:=0 to notfound.count-1 do
  begin
   node:=FindFile(notfound[i]);
   if assigned(node) then
   begin
    data:=vst.GetNodeData(node);
    data.Deleted:=true;
   end;
  end;
 end;
 NotFound.Free;
end;

procedure TProjectForm.ViewProjLogActionUpdate(Sender: TObject);
begin
 ViewProjLogAction.Enabled:=UploadLog.Count>0;
end;

procedure TProjectForm.ViewLogProjActionExecute(Sender: TObject);
begin
 VIewStringForm(UploadLog.text,'Upload Log','');
end;

procedure TProjectForm.PublishAllAgainActionExecute(Sender: TObject);
var
 PrItem : PPrItem;
 Node : PVirtualNode;
begin
 if MessageDlg('Are you sure you want to reset all files, and have them '+#13+#10+'uploaded next time you publish?', mtConfirmation, [mbOK,mbCancel], 0)<>mrOK then exit;
 Node:=vst.GetFirst;
 while assigned(Node) do
 begin
  pritem:=VST.GetNodeData(Node);
  if (not prItem.IsFolder) then
  begin
   prItem.status:=stPublish;
   prItem.Crc:=0;
   pritem.FileAge:=0;
  end;
  Node:=vst.GetNext(Node);
 end;
 VST.invalidate;
 FMH.Dirty:=true;
end;


procedure TProjectForm.PublishToItemClick(Sender: TObject);
var
 s:string;
 PrItem : PPrItem;
 i:integer;
begin
 prItem:=sellist[0];
 s:=prItem.PublishTo;
 if inputquery('Override remote destination path',
  'Enter a remote path, or leave empty to upload the folder were it appears now:',s) then
 begin
  s:=Trim(s);
  ReplaceC(s,'\','/');
  for i:=0 to sellist.Count-1 do
  begin
   pritem:=sellist[i];
   prItem.PublishTo:=s;
  end;
  FMH.Dirty:=true;
  VST.invalidate;
 end;
end;

procedure TProjectForm.ImportFolderActionExecute(Sender: TObject);
var
 ImportFolderForm: TImportFolderForm;
begin
 ImportFolderForm:=TImportFolderForm.Create(Application);
 try
  with ImportFolderForm do
   if (ShowModal=mrOK) and (directoryexists(edDirectory.Text)) then
    AddFolder(edDirectory.Text,edWild.Text);
 finally
  ImportFolderForm.Free;
 end;
end;

procedure TProjectForm.AddFolder(const Path,Wildcard : String);
var
 i:integer;
 sl : TStringList;
begin
  sl:=TStringList.Create;
  vst.BeginUpdate;
  try
   HakaFile.GetFileList(Path,'*.*',true,faAnyFile,sl);
   for i:=0 to sl.count-1 do
    if IsFileinMask(sl[i],wildcard) and
       (fileexists(sl[i])) and (not stringstartswith('.',sl[i])) then
     AddFile(sl[i]);
   FMH.Dirty:=true;
  finally
   sl.free;
   vst.EndUpdate;
  end;
end;

procedure TProjectForm.VSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=vk_Delete then
 begin
  key:=0;
  RemoveFromProjectAction.SimpleExecute;
 end;
end;

procedure TProjectForm.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
 data1,data2 : PPrItem;

 Function GetPath(Node: PVirtualNode; Data : PPrItem) : string;
 begin
  if Data.IsFolder
   then result:=' '+GetFilename(Node)
   else result:=ExtractFilename(GetFilename(node));
  if node=NonPublished then
   result:=' ';
  if data.NonPublished then
   result:='~'+data.Path;
 end;

 Function GetResult : Integer;
 begin
  result:=AnsiCompareStr(GetPath(node1,data1),GetPath(node2,data2));
 end;

begin
 result:=0;
 Data1:=Vst.GetNodeData(node1);
 Data2:=Vst.GetNodeData(node2);
 case column of
  colPath : Result:=GetResult;

  colMode :  begin
   result:=data1.mode - data2.Mode;
   if result=0 then result:=GetResult;
  end;

  colPublish : begin
   Result:=integer(data1.Publish)-integer(data2.Publish);
   if result=0 then result:=GetResult;
  end;

  colTransfer : begin
   Result:=integer(data1.Text)-integer(data2.Text);
   if result=0 then result:=GetResult;
  end;

  colStatus : begin
   Result:=integer(data1.Status)-integer(data2.status);
   if result=0 then result:=GetResult;
  end;
 end;

end;

procedure TProjectForm.VSTHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
 if vst.Header.SortDirection = sdAscending
  then vst.Header.SortDirection:=sdDescending
  else vst.Header.SortDirection:=sdAscending;
 VST.Header.SortColumn:=column;
 VST.SortTree(column,vst.header.sortdirection);
end;

Procedure TProjectForm.GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=siMain.ItemLinks;
end;

Function TProjectForm._GetProjectName : String;
begin
 result:=FMH.Filename;
end;

Function TProjectForm._IsFileInProject(Const Filename : String) : Boolean;
begin
 result:=(not FMH.IsNew) and Assigned(FindFile(filename))
end;

procedure TProjectForm.mFTPStatus(ASender: TObject; const Status: String);
begin
 UploadLog.Add(Status);
 if assigned(FTPUploadForm) then
  FTPUploadForm.OnStatus(Asender,status);
end;

procedure TProjectForm.ProjOpenRemoteActionExecute(Sender: TObject);
var
 fitem,prItem : PPrItem;
 node : PVirtualNode;
 Rem,RP,local:string;
 abs : Boolean;
begin
 Node:=VST.focusedNode;
 pritem:=vst.GetNodeData(node);
 fitem:=vst.getnodedata(node.parent);

 if assigned(fItem) and (fItem.PublishTo<>'')
  then RP:=fItem.PublishTo
  else RP:=IncludeTrailingAnySlash(ProjOpt.RemotePath,'/')+
          GetFolderFromNode(node.parent,abs,true);

 replaceC(RP,'\','/');
 RP:=IncludeTrailingAnySlash(RP,'/');
 Rem:=RP+ExtractFilename(PrItem.Path);

 local:=FtpMod.GetLocalFile(ProjOpt.Session,RP,ExtractFilename(PrItem.Path));

 FTPMod.downloadFile(ProjOpt.Session,rp,ExtractFilename(PrItem.Path),local);
 PR_OpenFile(local);
 PR_ReloadActive;
end;

procedure TProjectForm.ProjOpenRemoteActionUpdate(Sender: TObject);
var
 Item : PPrItem;
begin
 item:=vst.GetNodeData(VST.focusedNode);
 ProjOpenRemoteAction.Enabled:=assigned(item) and (not item.NonPublished) and (not item.IsFolder);
end;

procedure TProjectForm._ProjectModified;
begin
 FMH.Dirty:=true;
end;

function TProjectForm._RequestInfoFile(const Path : String) : Pointer;
var
 PrItem : PPrItem;
 Node:PVirtualNode;
begin
 result:=nil;
 if FMH.IsNew then exit;
 Node:=FindFile(path);
 if not assigned(node) then exit;
 prItem:=vst.getNodedata(node);
 result:=@prItem.Info;
end;

procedure TProjectForm.VSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
 Files: TStringList;
 i:Integer;
begin
 Files:=TStringList.Create;
 try
  GetDragDropFiles(files,DataObject,formats);
  for i:=0 to files.count-1 do
   if fileexists(files.Strings[i]) then
    addfile(files.Strings[i])
   else
   if DirectoryExists(files.Strings[i]) then
    AddFolder(files.Strings[i],'*.*');
  FMH.Dirty:=files.count>0;
 finally
  Files.Free;
 end;
end;

procedure TProjectForm.VSTDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
 data : PPrItem;
begin
 data:=vst.GetNodeData(node);
 Allowed:=assigned(data) and (not data.IsFolder);
end;

procedure TProjectForm.VSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
 Accept:=(Effect=DROPEFFECT_COPY) and (not vst.Dragging)
end;

procedure TProjectForm.VSTCreateDataObject(Sender: TBaseVirtualTree; out IDataObject: IDataObject);
var
 s:string;
 prItem : PPrItem;
 node : PVirtualNode;
begin
 DropFileSource.Files.clear;
 node:=vst.GetFirstSelected;
 while assigned(node) do
 begin
  pritem:=vst.GetNodeData(node);
  if (node<>NonPublished) and (not prItem.IsFolder) then
  begin
   s:=GetFilename(node);
   DropFileSource.Files.Add(s);
  end;
  node:=vst.GetNextSelected(node)
 end;

 if DropFileSource.Files.Count>0 then
  IDataObject:=DropFileSource;
end;

procedure TProjectForm.VSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
 prItem : PPrItem;
 dumb : boolean;
begin
 if (column<>0) or (node=NonPublished) then exit;
 PrItem:=vst.GetNodeData(node);
 if not assigned(prItem) then exit;
 if prItem.IsFolder
  then
   HintText:=GetAbsolutePath(projOpt.LocalPath,GetFolderFromNode(node,dumb,false))
  else
   HintText:=pritem.Path;
end;

function TProjectForm.FMHOpenDialog(var Filename: String;
  const InitialDir: String): Boolean;
begin
 OpenDialog.Filename:='';
 result:=OpenDialog.execute;
 Filename:=OpenDialog.Filename;
end;

function TProjectForm.FMHSaveDialog(var Filename: String;
  const InitialDir: String): Boolean;
begin
 SaveDialog.FileName:=Filename;
 SaveDialog.InitialDir:=InitialDir;
 result:=SaveDialog.Execute;
 Filename:=SaveDialog.Filename;
end;

function TProjectForm.FMHQueryToSaveDialog(const Str: String): Integer;
begin
 result:=MessageDlg(Format('File %s has changed. Save Changes?', [Str]),
           mtConfirmation, [mbYes,mbNo,mbCancel], 0);
end;

procedure TProjectForm.VSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
 data : PPrItem;
begin
 if not assigned(node) then exit;
 data:=vst.GetNodeData(node);
 if data.Deleted then
  TargetCanvas.Font.Color:=clRed;
end;

end.
{
procedure TProjectForm.VSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);

end;

procedure TProjectForm.VSTShortenString(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  const S: WideString; TextSpace: Integer; RightToLeft: Boolean;
  var Result: WideString; var Done: Boolean);
var
 data : PPrItem;
begin
 data:=vst.GetNodeData(node);
 if not assigned(data) then exit;
 if (data.NonPublished) then
 begin
  result:=ShortenStringEx(targetcanvas.Handle,data.path,textspace,false,sseFilePathMiddle);
  done:=true;
 end;
end;

