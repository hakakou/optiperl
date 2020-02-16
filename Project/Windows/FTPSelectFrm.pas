unit FTPSelectFrm;   //Modeless //StatusBar //Splitter //VST

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ActiveX,HKVST,
  Dialogs,FTPMdl, Buttons, StdCtrls,hakageneral,FTPSessionsFrm, ComCtrls,Hakawin, ToolWin,
  CentralImageListMdl, ScriptInfoUnit,ActnList, HKModeSelectForm,OptFolders,
  ExtCtrls,hyperFrm,OptForm, OptOptions,StringViewFrm,HKTransfer,PBFolderDialog,OptProcs,
  OptGeneral, dxBar, VirtualTrees, Menus, DropSource;

type
  TFTPDialogType = (dtOpen,dtSave,dtNone);

  TFTPSelectForm = class(TOptiForm)
    StatusBar: TStatusBar;
    ActionList: TActionList;
    OKAction: TAction;
    CancelAction: TAction;
    ConnectAction: TAction;
    SessionsAction: TAction;
    NewFolderAction: TAction;
    RefreshAction: TAction;
    UpLevelAction: TAction;
    AbortAction: TAction;
    DisconnectAction: TAction;
    chModAction: TAction;
    DelAction: TAction;
    Panel: TPanel;
    PopupMenu: TPopupMenu;
    NewFolder1: TMenuItem;
    Refresh1: TMenuItem;
    CHMod1: TMenuItem;
    Delete1: TMenuItem;
    CustomAction: TAction;
    N2: TMenuItem;
    Sendcustomcommand1: TMenuItem;
    RenameAction: TAction;
    Rename1: TMenuItem;
    OpenAction: TAction;
    N3: TMenuItem;
    Abort1: TMenuItem;
    LogAction: TAction;
    OpenSymDir: TAction;
    N4: TMenuItem;
    Openineditorasfile2: TMenuItem;
    BarManager: TdxBarManager;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    dxBarButton14: TdxBarButton;
    cbSession: TdxBarCombo;
    BotPanel: TPanel;
    lblFilename: TLabel;
    edFilename: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    VST: TVirtualStringTree;
    siFavorites: TdxBarSubItem;
    AddFavAction: TAction;
    RemFavAction: TAction;
    liFavorites: TdxBarListItem;
    dxBarButton15: TdxBarButton;
    dxBarButton16: TdxBarButton;
    DownloadAction: TAction;
    dxBarButton17: TdxBarButton;
    DropFileSource: TDropFileSource;
    NewFileAction: TAction;
    dxBarButton18: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OKActionExecute(Sender: TObject);
    procedure ConnectActionExecute(Sender: TObject);
    procedure SessionsActionExecute(Sender: TObject);
    procedure NewFolderActionExecute(Sender: TObject);
    procedure UpLevelActionExecute(Sender: TObject);
    procedure AbortActionExecute(Sender: TObject);
    procedure CancelActionExecute(Sender: TObject);
    procedure ConnectedAndBusyUpdate(Sender: TObject);
    procedure ConnectedAndNotBusyUpdate(Sender: TObject);
    procedure DisconnectActionExecute(Sender: TObject);
    procedure DelActionExecute(Sender: TObject);
    procedure chModActionExecute(Sender: TObject);
    procedure CustomActionExecute(Sender: TObject);
    procedure RenameActionExecute(Sender: TObject);
    procedure OpenActionExecute(Sender: TObject);
    procedure NotBusyUpdate(Sender: TObject);
    procedure NotConnectedUpdate(Sender: TObject);
    procedure ConnectedUpdate(Sender: TObject);
    procedure ConnectedNotbusySelectedUpdate(Sender: TObject);
    procedure OpenUpdate(Sender: TObject);
    procedure OKActionUpdate(Sender: TObject);
    procedure FormExDestroy(Sender: TObject);
    procedure LogActionExecute(Sender: TObject);
    procedure SymLinkUpdate(Sender: TObject);
    procedure OpenSymFileExecute(Sender: TObject);
    procedure OpenSymDirExecute(Sender: TObject);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VSTGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTDblClick(Sender: TObject);
    procedure VSTClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure RefreshActionExecute(Sender: TObject);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure VSTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ConnectActionUpdate(Sender: TObject);
    procedure liFavoritesGetData(Sender: TObject);
    procedure liFavoritesClick(Sender: TObject);
    procedure RemFavActionExecute(Sender: TObject);
    procedure AddFavActionExecute(Sender: TObject);
    procedure DownloadActionExecute(Sender: TObject);
    procedure VSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure cbSessionCurChange(Sender: TObject);
    procedure cbSessionDropDown(Sender: TObject);
    procedure DisconnectActionUpdate(Sender: TObject);
    procedure VSTDragAllowed(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VSTDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VSTCreateDataObject(Sender: TBaseVirtualTree;
      out IDataObject: IDataObject);
    procedure NewFileActionExecute(Sender: TObject);
    procedure VSTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
    procedure VSTCreateDragManager(Sender: TBaseVirtualTree;
      out DragManager: IVTDragManager);
  private
    mFTP : TBaseTransfer;
    DialType : TFTPDialogType;
    LogForm : TStringViewForm;
    PrevFolder : String;
    LastBad,DoingConnect : Boolean;
    Session : String;
    LastPath : String;
    SelTemp : TStringList;
    procedure DoOpen;
    procedure DoSave;
    procedure DoDownload;
    procedure ForceOpen(const name: String);
    procedure OnFileListUpdated(Sender: TObject);
    Procedure OnStatus(Sender : TObject; Const Status : String);
    Procedure GetList(Items : TItemTypes);
    procedure DoSetCaption;
    Procedure ChangeSession(var msg : TMessage); message WM_USER+1;
    Function POnQueryDrag(Sender : TObject) : Boolean;
  protected
    procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix, index: Integer); override;
    Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); override;
    procedure _ReLinkSession(sess: TObject; Kill : Boolean);
    procedure _LinkSession(sess: TObject);
  public
    Constructor Create(AOwner: TComponent; DialogType : TFTPDialogType); reintroduce;
  end;

var
  FTPSelectForm: TFTPSelectForm;
  FTPBrowseForm: TFTPSelectForm;

implementation
const
 CaptionStr : array[TFTPDialogType] of string =
 ('Select file','Save file','Remote Explorer');

{$R *.dfm}

procedure TFTPSelectForm.VSTCreateDragManager(Sender: TBaseVirtualTree;
  out DragManager: IVTDragManager);
begin
  DragManager := THKVTDragManager.Create(sender, POnQueryDrag, nil);
end;

procedure TFTPSelectForm.FormCreate(Sender: TObject);
var i:integer;
begin
 VST.Header.SortColumn:=0;
 vst.header.sortdirection:=sdAscending;

 SelTemp:=TStringList.Create;
 LogForm:=TStringViewForm.CreateNormal(Application);

 with LogForm do
 begin
  Caption:='Transfer Log';
  OnClose:=nil;
  Listbox.Font.Name:=HakaWin.DefMonospaceFontName;
 end;

 FTPMod.GetSessions(cbSession.Items,options.KeepSessionsAlive);
 i:=cbSession.Items.IndexOf(options.LastFTPSelect);
 if i>=0 then
  cbSession.CurItemIndex:=i;

 lblFilename.Visible:=(dialType=dtSave);
 edFilename.Visible:=(dialType=dtSave);
 if dialType=dtNone then
  begin
   PR_ReLinkSession:=_ReLinkSession;
   PR_LinkSession:=_LinkSession;
   BotPanel.Visible:=false;
   HelpContext:=6730;
  end
 else
  begin
   BorderStyle:=bsSizeable;
   HelpContext:=6710;
  end;
 if (dialType=dtSave) then
  edFilename.Text:=ExtractFilename(ActiveScriptInfo.path);
 Setcaption(CaptionStr[DialType]);
end;

procedure TFTPSelectForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if assigned(mftp) and (mftp.Connected) then
 begin
  if mftp.Busy then
   mftp.Abort;
   
  if (modalresult=mrOK) or (self=FTPBrowseForm) then
   FTPMod.SetLastFolder(Session,mFTP);
 end;

 if self=FTPBrowseForm then
 begin
  Action:=caFree;
  FTPBrowseForm:=nil;
 end;

 options.LastFTPSelect:=cbSession.CurText;
end;

procedure TFTPSelectForm.VSTDblClick(Sender: TObject);
var
 Item : PItemData;
begin
 if assigned(vst.FocusedNode) and assigned(mftp) and (mFTP.Connected) and (Not mFTp.Busy) then
 begin
  Item:=vst.GetNodeData(vst.FocusedNode);
  if item.ItemType in [itDirectory,itSymbolicLink]
   then mFTP.ChangeDirectory(item.Filename)
   else OKAction.Execute;
 end;
end;

procedure TFTPSelectForm.DoSave;
var
 mode : Integer;
 dumbtext : Boolean;
 TempFile,d,s : String;
begin
 FTPMOd.GetRecommendedMode(activeScriptInfo.path,dumbtext,mode);
 if not FTPMod.DoFilePreProcess(session,activeScriptInfo.path,tempfile,true) then exit;
 try
  mFTP.TextTransfer:=true;
  mftp.AutoGetFileList:=false;
  d:=mFTP.CurrentDirectory;
  mFTP.Put(TempFile,edFilename.Text);
  mftp.AutoGetFileList:=true;
  mFTP.CHMod(edFilename.Text,mode);

  s:=FTPMod.GetLocalFile(Session,d,edFilename.Text);
  try
   copyfile(pchar(tempfile),pchar(s),false);
  except end; 
  if Fileexists(s) then
   PR_OpenFile(s);
 finally
  if activeScriptInfo.path<>tempfile then
   deleteFile(tempfile);
 end;  
end;

procedure TFTPSelectForm.DownloadActionExecute(Sender: TObject);
begin
 DoDownload;
end;

procedure TFTPSelectForm.DoDownload;
var
 d:string;
 i:integer;
begin
 GetList(ItemTypeFiles);
 if seltemp.Count=0 then exit;
 mFTP.TextTransfer:=false;

 d:=PrevFolder;
 if not BrowseForFolder('Select folder to download files:',true,d) then exit;
 prevfolder:=IncludeTrailingBackslash(d);

 mftp.BeginUpdate;
 try
  for i:=0 to seltemp.Count-1 do
   mftp.Get(seltemp[i],prevfolder+seltemp[i]);
 finally
  mftp.EndUpdate;
 end;
end;

procedure TFTPSelectForm.ForceOpen(Const name : String);
var d,s:string;
begin
 d:=mFTP.CurrentDirectory;
 s:=FTPMod.GetLocalFile(Session,d,name);
 if (Fileexists(s)) and (not DeleteFile(s)) then
  Showmessage('Could not delete file')
 else
  begin
   LastBad:=false;
   FTPMod.DoFileDownload(session,s,name,mFTP);
   if LastBad then DeleteFile(s);
   if fileexists(s) then
    PR_OpenFile(s);
  end;
end;

procedure TFTPSelectForm.DoOpen;
var
 i:integer;
begin
 GetList(ItemTypeFiles);
 if seltemp.Count=0 then exit;
 mFTP.TextTransfer:=false;
 mftp.BeginUpdate;
 try
  for i:=0 to seltemp.Count-1 do
   ForceOpen(seltemp[i]);
 finally
  mftp.EndUpdate(false);
 end;
end;

constructor TFTPSelectForm.Create(AOwner: TComponent; DialogType : TFTPDialogType);
begin
 DialType:=DialogType;
 if DialogType=dtNone
  then inherited Create(AOwner)
  else Inherited CreateNormal(AOwner);
end;

procedure TFTPSelectForm.VSTClick(Sender: TObject);
var
 Item : PItemData;
begin
 if (DialType=dtSave) and
    (assigned(vst.FocusedNode)) then
 begin
  item:=vst.GetNodeData(vst.FocusedNode);
  if item.ItemType=itFile then
   edFilename.Text:=Item.Filename;
 end;
end;

procedure TFTPSelectForm.OKActionExecute(Sender: TObject);
begin
 ModalResult:=mrOK;
 case dialtype of
  dtOpen,dtNone : DoOpen;
  dtSave : DoSave;
 end;
end;

procedure TFTPSelectForm.ConnectActionExecute(Sender: TObject);
var
 ts : String;
 temp : TBaseTransfer;
begin
 if (not options.KeepSessionsAlive) and (assigned(mftp)) then exit;
 LogForm.ListBox.Clear;

 DisableApplication;
 DoingConnect:=true;
 try
  ts:=cbSession.CurText;
  Temp:=mftp;
  try
   FTPMod.OpenSession(ts,mftp,true,OnFileListUpdated,OnStatus,#0);
   if assigned(temp) then
    FTPMod.CloseSession(temp);
  except
   mftp:=temp;
   cbSession.ItemIndex:=cbSession.Items.IndexOf(session);
   raise;
  end;
  Session:=ts;
  cbSession.Hint:=mftp.LoginMessage;
  DoSetCaption;
 finally
  DoingConnect:=false;
  EnableApplication;
 end;
end;

procedure TFTPSelectForm.DoSetCaption;
begin
 Setcaption(Session+' - '+mftp.CurrentDirectory+' - '+CaptionStr[dialtype]);
end;

procedure TFTPSelectForm.SessionsActionExecute(Sender: TObject);
begin
 FTPSessionsForm:=TFTPSessionsForm.Create(Application);
 try
  FTPSessionsForm.ShowModal;
  cbSession.Items.Clear;
  FTPMod.GetSessions(cbSession.Items,options.KeepSessionsAlive);
 finally
  FTPSessionsForm.Free;
 end;
end;

procedure TFTPSelectForm.NewFolderActionExecute(Sender: TObject);
var s:string;
begin
 s:='';
 if InputQuery('Remote Session', 'Enter directory name:', S) and (length(s)>0) then
  MFtp.CreateDirectory(S);
end;

procedure TFTPSelectForm.UpLevelActionExecute(Sender: TObject);
begin
 mFTP.ChangeDirUp;
end;

procedure TFTPSelectForm.AbortActionExecute(Sender: TObject);
begin
 mFTP.Abort;
end;

procedure TFTPSelectForm.CancelActionExecute(Sender: TObject);
begin
 ModalResult:=mrCancel;
end;

procedure TFTPSelectForm._LinkSession(sess : TObject);
begin
 if (mftp=sess) and assigned(mftp) then
  TBaseTransfer(sess).BeingUsed:=false;
end;

procedure TFTPSelectForm._ReLinkSession(sess : TObject; Kill : Boolean);
var t : TBaseTransfer absolute sess;
begin
 if kill then
  begin
   Session:='';
   VST.Clear;
   if DialType=dtNone then
    Setcaption(CaptionStr[dtNone]);
   mftp:=nil;
   liFavorites.ItemIndex:=-1;
  end
 else

 if (mftp=sess) and (assigned(sess)) then
 begin
  t.AutoGetFileList:=true;
  t.OnFileListUpdated:=OnFileListUpdated;
  t.OnStatus:=OnStatus;
  t.ChangeDirectory(LastPath);
 end;

 cbSessionDropDown(nil);
end;

procedure TFTPSelectForm.DisconnectActionExecute(Sender: TObject);
begin
 FTPMod.SetLastFolder(session,mftp);
 FreeAndNil(mftp);
 Session:='';
 VST.Clear;
 if DialType=dtNone then
  Setcaption(CaptionStr[dtNone]);
 mftp:=nil;
 liFavorites.ItemIndex:=-1;
end;

procedure TFTPSelectForm.DelActionExecute(Sender: TObject);
const
 str : Array[boolean] of string =
 ('file "%s"?','folder "%s" with all it''s contents?');
var
 Item : PItemData;
 i:integer;
 s:string;
begin
 GetList(itemtypeall);
 if SelTemp.Count=0 then exit;
 s:='Are you sure you want to delete'+#13+#10;
 if seltemp.Count=1
  then s:=s+'item '+seltemp[0]+'?'
  else s:=s+'selected items?';

 if MessageDlg(s, mtConfirmation, [mbOK,mbCancel], 0) <> mrOk
  then exit;

 mftp.BeginUpdate;
 try
  for i:=0 to seltemp.Count-1 do
  begin
   item:=PItemData(seltemp.Objects[i]);
   if item.itemtype=itFile
    then mFTP.DeleteFile(item.Filename)
    else mftp.DeleteFolder(item.Filename);
  end;
 finally
  mftp.EndUpdate;
 end;
end;

procedure TFTPSelectForm.chModActionExecute(Sender: TObject);
var
 Item : PItemData;
 mode : Integer;
 text : boolean;
 i:integer;
begin
 GetList(ItemTypeAll);
 if SelTemp.Count=0 then exit;

 item:=PItemData(seltemp.Objects[0]);
 mode:=StrToPermissions(item.Attributes);

 if mode=-1 then
  FTPMod.GetRecommendedMode(item.Filename,text,mode);

 mftp.BeginUpdate;
 try
  if (HKModeSelectForm.CHModeSelect(mode)) then
   for i:=0 to seltemp.Count-1 do
    mFTP.CHMod(seltemp[i],mode);
 finally
  mftp.EndUpdate;
 end;
end;

procedure TFTPSelectForm.CustomActionExecute(Sender: TObject);
var s:string;
begin
 s:='';
 if InputQuery(Session+' Session', 'Enter custom command:', S) then
 begin
  MFtp.Custom(s);
  MFTP.GetCurrectDirectory;
 end;
end;

procedure TFTPSelectForm.RenameActionExecute(Sender: TObject);
var
 s,o:string;
 Item : PItemData;
begin
 item:=vst.GetNodeData(vst.focusednode);
 s:=Item.Filename;
 o:=s;
 if InputQuery('FTP Session', 'Enter new name:', S) and (o<>s) then
  MFtp.Rename(o,s)
end;

procedure TFTPSelectForm.OpenActionExecute(Sender: TObject);
begin
 DoOpen;
end;

procedure TFTPSelectForm.FormExDestroy(Sender: TObject);
begin
 if dialtype=dtNone then
 begin
  PR_ReLinkSession:=nil;
  PR_LinkSession:=nil;
 end;

 if options.KeepSessionsAlive
   then FTPMod.CloseSession(mftp)
   else DisconnectAction.Execute;

 SelTemp.Free;

 if hakawin.FormExists(logform) then
 begin
  if options.FTPLog then
   LogForm.ListBox.Items.SaveToFile('c:\Transfer.log');
  logForm.Free;
 end;
end;

procedure TFTPSelectForm.LogActionExecute(Sender: TObject);
begin
 LogForm.show;
end;

procedure TFTPSelectForm.OpenSymFileExecute(Sender: TObject);
begin
 DoOpen;
end;

procedure TFTPSelectForm.OpenSymDirExecute(Sender: TObject);
var Item : PItemData;
begin
 item:=vst.GetNodeData(vst.FocusedNode);
 mftp.ChangeDirectory(item.Filename);
end;

procedure TFTPSelectForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=barmanager.Bars[0].ItemLinks;
end;

procedure TFTPSelectForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=nil;
 Alignment:=drtNone;
 Pix:=0;
 Index:=InExplorers;
end;


procedure TFTPSelectForm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
 Item : PItemData;
begin
 if (column=0) and (Kind in [ikNormal,ikSelected]) then
 begin
  item:=vst.GetNodeData(node);
  imageindex:=item.ImageIndex;
 end;
end;

procedure TFTPSelectForm.VSTGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
 NodeDataSize:=sizeof(TItemData);
end;

procedure TFTPSelectForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
 Item : PItemData;
begin
 Item:=vst.GetNodeData(node);
 case column of
  ColFilename : Celltext:=item.Filename;
  ColSize : Celltext:=inttostr(item.Size);
  ColModified : Celltext:=dateTimetostr(item.Modified);
  ColAttributes : Celltext:=item.Attributes;
  ColItemDesc : celltext:=item.Description;
 end;
end;

procedure TFTPSelectForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Item : PItemData;
begin
 Item:=vst.GetNodeData(node);
 setlength(item.Filename,0);
 setlength(item.Description,0);
 setlength(item.Attributes,0);
 setlength(item.LinksTo,0);
end;

procedure TFTPSelectForm.OnFileListUpdated(Sender: TObject);
var
 node : PVirtualNode;
 Item : PItemData;
 i:integer;
begin
 vst.Clear;
 if not assigned(mftp) then exit;
 LastPath:=mftp.CurrentDirectory;
 vst.BeginUpdate;
 try
  for i:=0 to length(mftp.filelist)-1 do
  begin
   node:=vst.AddChild(vst.RootNode);
   Item:=vst.GetNodeData(node);
   item^:=mftp.filelist[i];
  end;
  DoSetCaption;
  VST.Sort(nil,VST.Header.SortColumn,vst.header.sortdirection);
 finally
  vst.EndUpdate;
 end;
end;

procedure TFTPSelectForm.OnStatus(Sender: TObject; const Status: String);
var i:integer;
begin
 for i:=0 to ActionList.ActionCount-1 do
  actionlist.Actions[i].Update;

 if Status<>'' then
  with LogForm.ListBox do
  begin
   StatusBar.SimpleText:=Status;
   Items.add(status);
   ItemIndex:=Items.count-1;
  end;
end;

procedure TFTPSelectForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 try   //sfarber@anetgroup.com.elf
  CanClose:=not assigned(mFTP) or (not MFTP.Busy);
 except
  CanClose:=false;
 end;
// This is only used for the modal version (open and save remote file)
end;

procedure TFTPSelectForm.RefreshActionExecute(Sender: TObject);
begin
 mftp.UpdateFileList;
end;

procedure TFTPSelectForm.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
const
 SAdd : Array[TItemType] of string = (#33,'',#34);
 SSize : Array[TItemType] of Int64 = (low(int64),0,low(int64)+1);
var
 data1,data2 : PItemData;
 dx : TDateTime;
begin
 result:=0;
 Data1:=Vst.GetNodeData(node1);
 Data2:=Vst.GetNodeData(node2);

 case column of
  ColFilename :  begin
   Result:=AnsiCompareStr(SAdd[data1.itemtype]+data1.Filename,
                          SAdd[data2.itemtype]+data2.Filename);
   if data1.Filename='..' then result:=-1;
   if data2.Filename='..' then result:=1;
  end;

  ColSize : result:=(data1.Size+SSize[data1.itemtype])-
                    (data2.Size+SSize[data2.itemtype]);

  ColModified :
  begin
   dx:=(data1.modified+SSize[data1.itemtype]) -
       (data2.modified+SSize[data2.itemtype]);
   if dx=0 then result:=0;
   if dx>0 then result:=1;
   if dx<0 then result:=-1;
  end;

  ColAttributes : Result:=AnsiCompareStr(SAdd[data1.itemtype]+data1.Attributes,
                                         SAdd[data2.itemtype]+data2.Attributes);

  ColItemDesc : Result:=AnsiCompareStr(SAdd[data1.itemtype]+data1.Description,
                                       SAdd[data2.itemtype]+data2.Description);

 end;
end;

procedure TFTPSelectForm.VSTHeaderClick(Sender: TVTHeader;
  Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
 if VST.Header.SortColumn=column then
  if vst.Header.SortDirection = sdAscending
   then vst.Header.SortDirection:=sdDescending
   else vst.Header.SortDirection:=sdAscending;
 VST.Header.SortColumn:=column;
 VST.Sort(nil,column,vst.header.sortdirection);
end;

//////////////////////////////////////////////////////////////////////////////////////////
// UPDATE Actions
//////////////////////////////////////////////////////////////////////////////////////////

procedure TFTPSelectForm.ConnectedAndBusyUpdate(Sender: TObject);
begin
 Taction(sender).Enabled:=
  assigned(mftp) and mFTP.Connected and mFTP.Busy;
end;

procedure TFTPSelectForm.DisconnectActionUpdate(Sender: TObject);
begin
 DisconnectAction.Enabled:=(session<>'') and (not DoingConnect);
 if not DisconnectAction.Enabled then exit;
 
 if options.KeepSessionsAlive then
  DisconnectAction.Enabled:=
   (FTPMod.Sessions.IndexOf(cbSession.curtext)>=0) and
   (not stringstartswith('---',cbSession.curtext))
 else
  ConnectedAndNotBusyUpdate(DisconnectAction);
end;

procedure TFTPSelectForm.ConnectActionUpdate(Sender: TObject);
begin
 if options.KeepSessionsAlive then
  Taction(sender).Enabled:=(FTPMod.Sessions.IndexOf(cbSession.curtext)<0) and
   (not stringstartswith('---',cbSession.curtext))
 else
  Taction(sender).Enabled:=((not assigned(mftp)) or (not mftp.Connected)) and
   (cbSession.ItemIndex>=0);
end;

procedure TFTPSelectForm.SymLinkUpdate(Sender: TObject);
begin
 TAction(Sender).Visible:=
 (assigned(mFTP)) and mFTP.Connected and (Not mFTp.Busy) and
 (assigned(vst.FocusedNode)) and
 (PItemData(vst.GetNodeData(vst.FocusedNode)).ItemType=itSymbolicLink);
end;

procedure TFTPSelectForm.OpenUpdate(
  Sender: TObject);
begin
 try
  TAction(Sender).Enabled:=assigned(mFTP) and (mFTP.Connected) and (Not mFTp.Busy) and
   assigned(vst.FocusedNode) and
    (PItemData(vst.GetNodeData(vst.FocusedNode)).ItemType<>itDirectory);
 except
  TAction(Sender).Enabled:=false;
 end;
end;

procedure TFTPSelectForm.OKActionUpdate(Sender: TObject);
begin
 if DialType=dtSave
  then ConnectedAndNotBusyUpdate(Sender)
  else OpenUpdate(Sender);
end;

procedure TFTPSelectForm.ConnectedNotbusySelectedUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled:=assigned(mftp) and
 (mFTP.Connected) and (Not mFTp.Busy) and (assigned(vst.FocusedNode));
end;

procedure TFTPSelectForm.ConnectedUpdate(Sender: TObject);
begin
 Taction(sender).Enabled:=assigned(mftp) and mFTP.Connected;
end;

procedure TFTPSelectForm.NotConnectedUpdate(Sender: TObject);
begin
 try
  Taction(sender).Enabled:=(not assigned(mftp)) or (not mftp.Connected);
 except
  mftp:=nil;
 end;
end;

procedure TFTPSelectForm.NotBusyUpdate(Sender: TObject);
begin
 Taction(sender).Enabled:=(not assigned(mftp)) or (not mftp.Connected) or (not mFTP.Busy);
end;

procedure TFTPSelectForm.ConnectedAndNotBusyUpdate(Sender: TObject);
begin
 try
  TAction(Sender).Enabled:=assigned(Mftp) and (mFTP.Connected) and (Not mFTp.Busy);
 except
  mftp:=nil;
 end;
end;

procedure TFTPSelectForm.GetList(Items: TItemTypes);
var
 node : PVirtualNode;
 data : PItemData;
begin
 SelTemp.Clear;
 node:=vst.GetFirstSelected;
 while assigned(node) do
 begin
  data:=vst.GetNodeData(node);
  if data.ItemType in items then
   seltemp.AddObject(data.Filename,TObject(data));
  node:=vst.GetNextSelected(node);
 end;
end;

procedure TFTPSelectForm.liFavoritesGetData(Sender: TObject);
begin
 FTPMod.GetFavorites(trim(cbSession.CurText),liFavorites.Items);
 liFavorites.Enabled:=UpLevelAction.Enabled;
 if assigned(mftp) then
  liFavorites.ItemIndex:=lifavorites.Items.IndexOf(mftp.CurrentDirectory);
end;

procedure TFTPSelectForm.liFavoritesClick(Sender: TObject);
var dir:string;
begin
 if not UpLevelAction.Enabled then exit;
 dir:=liFavorites.Items[liFavorites.itemindex];
 mftp.ChangeDirectory(dir);
end;

procedure TFTPSelectForm.RemFavActionExecute(Sender: TObject);
begin
 with liFAvorites do
  if itemindex>=0 then
   items.Delete(itemindex);
 FTPMod.SetFavorites(session,liFavorites.Items);
end;

procedure TFTPSelectForm.AddFavActionExecute(Sender: TObject);
var i:integer;
begin
 with liFavorites do
 begin
  i:=items.IndexOf(mftp.CurrentDirectory);
  if i<0 then
  begin
   Items.Add(mftp.CurrentDirectory);
   FTPMod.SetFavorites(session,liFavorites.Items);
  end;
 end;
end;

procedure TFTPSelectForm.VSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
 data : PItemData;
begin
 if column<>0 then exit;
 data:=vst.GetNodeData(node);
 if data.ItemType=itSymbolicLink then
  TargetCanvas.Font.Style:=[fsItalic];
end;

procedure TFTPSelectForm.ChangeSession(var msg: TMessage);
begin
 FTPMod.SetLastFolder(session,mftp);
 ConnectActionExecute(nil);

{ DoingConnect:=true;
 try
  if assigned(mftp) then
   mftp.UpdateFileList;
 finally
  DoingConnect:=false;
 end;}
end;

procedure TFTPSelectForm.cbSessionCurChange(Sender: TObject);
begin
 if options.KeepSessionsAlive and (cbSession.CurText<>Session) and
    (FTPMod.Sessions.IndexOf(cbSession.CurText)>=0) then
  PostMessage(Handle,WM_USER+1,0,0);
end;

procedure TFTPSelectForm.cbSessionDropDown(Sender: TObject);
var s:string;
begin
 if options.KeepSessionsAlive then
 begin
  s:=cbSession.CurText;
  cbSession.Items.Clear;
  FTPMod.GetSessions(cbSession.Items,true);
  cbSession.ItemIndex:=cbSession.Items.IndexOf(s)
 end;
end;

/////////////////////////////////////////////////////////////////////////////
//Upload

procedure TFTPSelectForm.VSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
 data : PItemData;
begin
 data:=vst.GetNodeData(vst.DropTargetNode);
 Accept:=(Effect=DROPEFFECT_COPY) and (not vst.Dragging) and
         assigned(Mftp) and (mFTP.Connected) and (Not mFTp.Busy);
 if accept and assigned(data) and (Data.ItemType<>itDirectory) and (mode=dmOnNode) then
  accept:=false;
end;

procedure TFTPSelectForm.VSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
 Files: TStringList;
 i:Integer;
 chDir : String;
 data : PItemData;
begin
 Files:=TStringList.Create;
 try
  GetDragDropFiles(files,DataObject,formats);

  chDir:='';
  data:=vst.GetNodeData(vst.DropTargetNode);
  if assigned(data) and (mode=dmOnNode) and (data.ItemType=itDirectory) then
   chDir:=data.Filename;

  with files do
  if (files.count>0) and
     (MessageDlg('Upload '+inttostr(count)+' file(s) to folder '+lastPath+chdir+'?', mtConfirmation, [mbOK,mbCancel], 0)=mrOK) then
   begin
    if length(chDir)>0 then
     mFTP.ChangeDirectory(chdir);
    mftp.BeginUpdate;
    mFTP.TextTransfer:=false;
    try
     for i:=0 to count-1 do
      if fileexists(Strings[i]) then mftp.Put(Strings[i],ExtractFilename(Strings[i]))
      else
      if directoryExists(Strings[i]) then
       MessageDlg('Only files can be uploaded.', mtError, [mbOK], 0);
    finally
     mftp.EndUpdate;
    end;
   end;

 finally
  Files.free;
 end;
end;

//download
/////////////////////////////////////////////////////////////////////////////

procedure TFTPSelectForm.VSTCreateDataObject(Sender: TBaseVirtualTree;
  out IDataObject: IDataObject);
var
 s,d:string;
 Item : PItemData;
 node : PVirtualNode;
 i:integer;
begin
 GetList(ItemTypeFiles);
 if seltemp.Count=0 then exit;

 DropFileSource.Files.Clear;
 DropFileSource.MappedNames.Clear;

 d:=mFTP.CurrentDirectory;
 for i:=0 to seltemp.Count-1 do
 begin
  s:=FTPMod.GetLocalFile(Session,d,SelTemp[i]);
  if not fileexists(s) then
   saveStr('',s);
  DropFileSource.Files.Add(s);
  DropFileSource.MappedNames.Add(seltemp[i]);
 end;

 if DropFileSource.Files.Count>0 then
  IDataObject:=DropFileSource;
end;

procedure TFTPSelectForm.VSTDragAllowed(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
 data : PItemData;
begin
 data:=vst.GetNodeData(node);
 Allowed:=assigned(Mftp) and (mFTP.Connected) and (Not mFTp.Busy) and
          assigned(data) and (data.ItemType=itFile)
end;

function TFTPSelectForm.POnQueryDrag(Sender: TObject): Boolean;
var
 i:integer;
 s,n:string;
begin
 result:=
  assigned(Mftp) and (mFTP.Connected) and (Not mFTp.Busy) and
  (MessageDlg('Download '+inttostr(DropFileSOurce.Files.count)+' file(s) ?', mtConfirmation, [mbOK,mbCancel], 0)=mrOK);

 if not result then
  exit;

 mftp.BeginUpdate;
 mFTP.TextTransfer:=false;
 try
  for i:=0 to DropFileSource.Files.count-1 do
  begin
   s:=DropFileSource.Files[i];
   n:=DropFileSource.MappedNames[i];
   mftp.Get(n,s);
  end;
 finally
  mftp.EndUpdate(false);
 end;
end;

procedure TFTPSelectForm.NewFileActionExecute(Sender: TObject);
var
 f,s:string;
begin
 s:='';
 if InputQuery('Remote Session', 'Enter new filename:', S) and (length(s)>0) then
 begin
  f:=GetTempFile;
  saveStr('',f);
  mftp.Put(f,s);
  deletefile(f);
 end;
end;

procedure TFTPSelectForm.VSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
 data : PItemData;
begin
 if column<>0 then exit;
 data:=vst.GetNodeData(node);
 if length(data.LinksTo)>0 then
  HintText:='Links to '+data.LinksTo;
end;



end.


