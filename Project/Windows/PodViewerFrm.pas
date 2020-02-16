unit PodViewerFrm; //Modeless //VST //Splitter
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  VirtualTrees,hyperstr, ExtCtrls, StdCtrls, OleCtrls, SHDocVw, Optgeneral,
  ComCtrls, ToolWin, Mask, OPtFolders,HKWebBrowser,optoptions, OptProcs,
  HKComboInputForm, HakaMessageBox,hyperfrm,OptSearch,aqDockingBase,
  DIPcre, ActnList, ImgList,hakageneral,hakahyper,hakafile, BigWebFrm,
  AppEvnts, HKWebFind, jclfileutils,PBFolderDialog,OptForm, dxBar,
  CentralImageListMdl, JvPlacemnt, FindFile;

type
  PPodItem = ^TPodItem;
  TPodItem = Record
   Title : String;
   ss,sl : Integer;
  end;

  TPodViewerForm = class(TOptiForm)
    VST: TVirtualStringTree;
    Splitter: TSplitter;
    SearchFile: TFindFile;
    Pcre: TDIPcre;
    tagPcre: TDIPcre;
    ActionList: TActionList;
    FindAction: TAction;
    BackAction: TAction;
    ForwardAction: TAction;
    FindPodFilesAction: TAction;
    OpenFileAction: TAction;
    OpenDialog: TOpenDialog;
    FormStorage: TjvFormStorage;
    ApplicationEvents: TApplicationEvents;
    WebPanel: TPanel;
    BarManager: TdxBarManager;
    bOpen: TdxBarButton;
    bFindPodFiles: TdxBarButton;
    bBack: TdxBarButton;
    bForward: TdxBarButton;
    bFind: TdxBarButton;
    cbPods: TdxBarCombo;
    Refresh: TdxBarButton;
    RefreshAction: TAction;
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
    procedure VSTFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure VSTPaintText(Sender: TBaseVirtualTree; const Canvas: TCanvas;
      Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType);
    procedure BackActionExecute(Sender: TObject);
    procedure ForwardActionExecute(Sender: TObject);
    procedure FindActionExecute(Sender: TObject);
    procedure FindPodFilesActionExecute(Sender: TObject);
    procedure OpenFileActionExecute(Sender: TObject);
    procedure SearchFileEnded(Sender: TObject);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure WebPanelResize(Sender: TObject);
    procedure cbPodsCurChange(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
    procedure SearchFileFound(Sender: TObject; Folder: String;
      var FileInfo: TSearchRec);
    procedure RefreshActionExecute(Sender: TObject);
    procedure RefreshActionUpdate(Sender: TObject);
  private
    podmodified,LoadedOriginal:Boolean;
    TempFile : String;
    procedure SearchFileStart;
    function AddANode(title: string; Parent: PVirtualNode): PVirtualNode;
    function GoToAnchor(const anchor: string): boolean;
    procedure FindFocus;
    procedure FormatAnchor(var s: string);
    function IsOriginal: boolean;
    procedure WebBrowserCommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
    procedure WebBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
  protected
   procedure DoClickItem(var Msg: TMessage); message WM_USER + 1;
   Procedure AfterContainerShow(Sender: TObject); override;
   Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); override;
   procedure FirstShow(Sender: TObject); override;
   procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix, index: Integer); override;
  public
   WebBrowser : TWebBrowser;
   PodFile : String;
   PodFileStamp : Cardinal;
   Procedure ExtractPod(const Filename : String; UpdateBrowser : boolean = true);
  end;

var
  PodViewerForm: TPodViewerForm;

implementation

Function CreateHTML(const inpod,outhtml : string) : boolean;
var
 style,tempperl,hr,s,pr,pp:string;
const
 f1 = 'pod2htmd.x~~';
 f2 = 'pod2htmi.x~~';
begin
 pp:=GetCurrentDir;
 chdir(extractfilepath(outhtml));
 deletefile(outhtml);

 hr:=options.PathToPerl;
 hr:=excludetrailingbackslash(extractfilepath(hr));
 hr:=excludetrailingbackslash(extractfilepath(hr));
 hr:=hr+'\html\lib';
 if DirectoryExists(hr)
  then hr:='''--htmlroot='+hr+''','
  else hr:='';
 tempperl:=GetTempFile;
 style:=programpath+'Pod2Html.css';
 s:='infile';
 pr:=excludetrailingbackslash(extractfilepath(options.PathToPerl));
 pr:=excludetrailingbackslash(extractfilepath(pr));
 
// s:='use Pod::Html;'+#13#10+
//  'pod2html('+hr+'''--'+s+'='+inpod+''',''--css='+style+
//          ''',''--noindex'',''--quiet'',''--recurse'',''--podpath=lib:site'',''--outfile='+outhtml+''''+
//          ',''--podroot='+pr+''');'+#13#10;

 s:='use Pod::Html;'+#13#10+
  'pod2html('+hr+'''--'+s+'='+inpod+''',''--css='+style+
          ''',''--noindex'',''--quiet'',''--outfile='+outhtml+''');'+#13#10;
 savestr(s,tempperl);
 s:='"'+Options.pathtoperl+'" "'+tempperl+'"';
 WaitExec(s,SW_HIDE);
 if folders.DebOutput='' then
 begin
  deletefile(tempperl);
  deletefile(f1);
  deletefile(f2);
 end;
 result:=fileexists(outhtml);
 chdir(pp);
end;

{$R *.DFM}

procedure TPodViewerForm.FirstShow(Sender: TObject);
begin
 WebBrowser:=PodWebForm.WebBrowser;
 webbrowser.OnDocumentComplete:=WebBrowserDocumentComplete;
 webbrowser.OnCommandStateChange:=WebBrowserCommandStateChange;
 WebBrowser.Tag:=Integer(DockControl);

 VST.NodeDataSize:=sizeof(TPodItem);
 HKWebBrowser.LoadAboutHTMLString(WebBrowser,'blank');
 if FileExists(FOlders.PodHistoryFile) then
  cbPods.Items.LoadFromFile(FOlders.PodHistoryFile);
 TempFile:=includetrailingbackslash(gettmpdir)+'podxtrc.htm';
end;

procedure TPodViewerForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
var
 pi:PPoditem;
begin
 pi:=Sender.GetNodeData(node);
 text:=pi.title;
end;

Function TPodViewerForm.IsOriginal : boolean;
var
 url : string;
 i:integer;
begin
 try
  url:=WebBrowser.OleObject.document.URL;
  url:=URLDecode(url);
  i:=pos('#',url);
  if i<>0 then setlength(url,i-1);
  Url:=FileUrlToPath(url);
 except on exception do end;
 result:=issamefile(url,tempfile);
end;

Function TPodViewerForm.GoToAnchor(const anchor : string) : boolean;
begin
 if not isoriginal then
  webbrowser.Navigate(tempfile);
 WaitToFinish(webbrowser,10);
 result:=ScrollToAnchor(webbrowser,anchor);
end;

Procedure TPodViewerForm.FormatAnchor(Var s:string);
begin
 replacesc(s,'-','',false);
 replacesc(s,'?','',false);
 replacesc(s,'"','',false);
 replacesc(s,'  ',' ',false);
 replacesc(s,'  ',' ',false);
 replacesc(s,'  ',' ',false);
 replacesc(s,'  ',' ',false);
 replacesc(s,'  ',' ',false);
 replacesc(s,'  ',' ',false);
end;

procedure TPodViewerForm.VSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
 pi:PPoditem;
 s,s2:string;
begin
 WaitToFinish(webbrowser,10);
 pi:=Sender.GetNodeData(node);
 if not assigned(pi) then exit;

 s:=Lowercase(pi.title);
 s2:=s;
 replaceSC(s2,' ','_',false);

 if GoToAnchor(s) then exit;
 if GoToAnchor(s2) then exit;
 FormatAnchor(s);
 if GoToAnchor(s) then exit;
end;


procedure TPodViewerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 CloseWebFindDialog;
end;

procedure TPodViewerForm.FormDestroy(Sender: TObject);
begin
 if podmodified then
  cbPods.Items.SaveToFile(FOlders.PodHistoryFile);
 deleteFile(tempfile);
end;

procedure TPodViewerForm.SearchFileFound(Sender: TObject; Folder: String;
  var FileInfo: TSearchRec);
var
 ext,path : string;
 Pod : TStringList;
 l : Integer;
begin
 Application.ProcessMessages;
 path:=includeTrailingBackSlash(folder)+fileinfo.name;
 ext:=uppercase(ExtractFileExt(path));
 if (ext='.POD') or (ext='.CGI') or (ext='.PM') or (ext='.PL') then
 begin
  pod:=TStringList.Create;
  try
   pod.LoadFromFile(path);

   for l:=0 to pod.Count-1 do begin
    if ScanF(pod[l],'=head?',1)=1 then
    begin
     cbPods.Items.Add(path);
     break;
    end;
   end;

  finally
   pod.Free;
  end;
 end;
end;

procedure TPodViewerForm.VSTPaintText(Sender: TBaseVirtualTree;
  const Canvas: TCanvas; Node: PVirtualNode; column: TColumnIndex;
  TextType: TVSTTextType);
begin
 if ((Node.Parent=vst.Rootnode) and (Node.ChildCount>1))
   then Canvas.Font.Style:=[fsBold]
   else Canvas.Font.Style:=[];
end;

Function TPodViewerForm.AddANode(title: string; Parent : PVirtualNode) : PVirtualNode;
var
 pi:PPoditem;
 i:integer;
begin
 Smartcase(title);
 if parent=nil
  then result:=vst.AddChild(vst.rootnode)
  else result:=vst.AddChild(parent);
 if assigned(result) then
 begin
  pi:=vst.GetNodeData(result);
  while tagPCRE.MatchStr(title)=2 do
  begin
   i:=tagPcre.SubStrFirstCharPos(1);
   delete(title,i-1,2);
   delete(title,tagpcre.SubStrAfterLastCharPos(1)-1,1);
  end;
  pi.Title:=title;
 end;
end;

Procedure TPodViewerForm.ExtractPod(const Filename : String; UpdateBrowser : boolean = true);
var
 sl:TStringList;
 Node : PVirtualNode;
 i:integer;
 level : integer;
begin
 CloseEnabled(false);
 PodFile:='';
 level:=-1;
 screen.Cursor:=crHourGlass;
 vst.Enabled:=false;
 vst.beginupdate;
 OPenFileAction.Enabled:=false;
 try
  if createHTML(filename,tempfile) then
  begin
   podfile:=filename;
   PodFileStamp:=fileage(filename);
   node:=nil;
   vst.Clear;
   if UpdateBrowser then
    WebBrowser.Navigate(tempfile);
   sl:=TStringList.create;
   sl.loadfromfile(filename);
   for i:=0 to sl.count-1 do
    if pcre.MatchStr(sl[i])=3 then
    begin
     try
      level:=strtoint(pcre.SubStr(1));
     except
      on exception do level:=1;
     end;
     if level=1 then node:=AddANode(pcre.SubStr(2),nil);
     if level>1 then AddANode(pcre.SubStr(2),node);
    end;
   sl.free;
  end;
  if level<>-1 then
  begin
   i:=cbpods.Items.IndexOf(podfile);
   if i<0 then begin
    podmodified:=true;
    cbpods.Items.add(podfile);
    i:=cbpods.Items.IndexOf(podfile);
   end;
   cbpods.ItemIndex:=i;
  end;
 finally
  vst.Enabled:=true;
  vst.EndUpdate;
  OPenFileAction.Enabled:=true;
  screen.Cursor:=crDefault;
  CloseEnabled(true);
 end;
end;

procedure TPodViewerForm.WebBrowserCommandStateChange(Sender: TObject;
  Command: Integer; Enable: WordBool);
begin
 try
  if command=CSC_NAVIGATEFORWARD then
   ForwardAction.Enabled:=Enable;
  if command=CSC_NAVIGATEBACK then
   BackAction.Enabled:=Enable;
 except
 end;
end;

procedure TPodViewerForm.BackActionExecute(Sender: TObject);
begin
 WebBrowser.GoBack
end;

procedure TPodViewerForm.ForwardActionExecute(Sender: TObject);
begin
 WebBrowser.GoForward;
end;

procedure TPodViewerForm.FindFocus;
var
 r,body : Olevariant;
 pi:PPoditem;
 Node : PVirtualNode;
 s,s2,t:string;
 i : integer;
begin
 body:=webbrowser.OleObject.document.body;
 r:=body.createTextRange;
 r.movetopoint(0,0);
 r.movestart('character',-700);
 s:=uppercase(r.htmltext);
 i:=scanR(s,'<A NAME=',0);
 if i=0 then exit;
 s:=copy(s,i+8,200);
 if length(s)=0 then exit;
 i:=pos('>',s);
 setlength(s,i-1);
 s:=removequotes(s,'"');
 s2:=s;
 replaceSC(s2,'_',' ',false);
 if length(s)=0 then exit;
 node:=VST.GetFirst;
 while assigned(node) do
 begin
  pi:=vst.GetNodeData(node);
  t:=uppercase(pi.Title);
  if t=s then break;
  if t=s2 then break;
  formatanchor(t);
  if t=s then break;
  if t=s2 then break;
  node:=VST.GetNext(node);
 end;
 if assigned(node) then
 begin
  vst.ScrollIntoView(node,true);
  vst.Selected[node]:=true;
  vst.FocusedNode:=node;
 end;
end;

procedure TPodViewerForm.FindActionExecute(Sender: TObject);
begin
 ShowWebFindDialog(webBrowser);
end;

procedure TPodViewerForm.FindPodFilesActionExecute(Sender: TObject);
var
 s:string;
begin
 MessageDlgMemo('This function will do a recursive search on folders for files containing '+
             #13+#10+'POD data, and create a history list for easy access.'+
             #13+#10+'It is recommended to start the search in your \perl\lib folder.',
             mtInformation, [mbOK], 0,300);
 s:='';
 if BrowseForFolder('Select a starting path',false,s) then
 begin
  SearchFileStart;
  SearchFile.location:=s;
  SearchFile.Execute;
 end;
end;

procedure TPodViewerForm.OpenFileActionExecute(Sender: TObject);
begin
 if OpenDialog.Execute then
  ExtractPod(opendialog.filename);
end;

procedure TPodViewerForm.SearchFileStart;
begin
 CloseEnabled(false);
 FindPodFilesAction.Enabled:=false;
 cbPods.Enabled:=False;
 cbPods.Items.Clear;
 podmodified:=true;
 screen.cursor:=crAppStart;
end;

procedure TPodViewerForm.SearchFileEnded(Sender: TObject);
begin
 FindPodFilesAction.Enabled:=true;
 cbPods.Enabled:=true;
 screen.cursor:=crDefault;
 if cbPods.Items.Count>0 then
  cbPods.Text:=cbpods.Items[0];
 CloseEnabled(true);
end;

procedure TPodViewerForm.WebBrowserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
 s : string;
 i:integer;
begin
 s:=url;
 i:=pos('#',s);
 if i<>0 then setlength(s,i-1);
 if pos('file:',s)=1 then
  s:=FileUrlToPath(s);
 if issamefile(s,tempfile)
  then s:=podfile;
 if not fileexists(s) then s:='';
 if s=''
  then Setcaption('Pod XTractor')
  else Setcaption(s+' - Pod XTractor');
 resetWebFindDialog(webBrowser);
 LoadedOriginal:=IsOriginal;
end;

procedure TPodViewerForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 p : PPodItem;
begin
 p:=VST.GetNodeData(node);
 Setlength(p.Title,0);
end;

procedure TPodViewerForm.WebPanelResize(Sender: TObject);
begin
 PodWebForm.Width:=WebPanel.ClientWidth;
 PodWebForm.Height:=WebPanel.ClientHeight;
end;

procedure TPodViewerForm.AfterContainerShow(Sender: TObject);
begin
 Windows.SetParent(PodWebForm.Handle,WebPanel.Handle);
 PodWebForm.Top:=0;
 PodWebForm.Left:=0;
 PodWebForm.visible:=true;
end;

procedure TPodViewerForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=BarManager.Bars[0].ItemLinks;
end;

procedure TPodViewerForm.DoClickItem(var Msg: TMessage);
begin
 if vst.Enabled then
  ExtractPod(cbPods.curText);
end;

procedure TPodViewerForm.cbPodsCurChange(Sender: TObject);
begin
 PostMessage(handle,WM_USER+1,0,0);
end;

procedure TPodViewerForm.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
 if (assigned(WebBrowser)) and
    (msg.message=32) and
    (not vst.Focused) and
    (IsDialogMessage(WebBrowser.Handle, Msg)) then
  begin
   vst.OnFocusChanged:=nil;
   try
    FindFocus;
   except
   end;
   vst.OnFocusChanged:=VSTFocusChanged;
  end;
end;

procedure TPodViewerForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtBottom;
 Pix:=0;
 Index:=InNone;
end;

procedure TPodViewerForm.RefreshActionExecute(Sender: TObject);
//var
// r,body : Olevariant;
// Y : Integer;
begin
 PR_quickSave;
 if fileexists(PodFile) and vst.Enabled then
 try
//  body:=webbrowser.OleObject.document.body;
//  r:=body.createTextRange;
//  Y:=r.boundingTop;
  ExtractPod(PodFile);
//  WaitToFinish(webbrowser,10);
//  body:=webbrowser.OleObject.document.body;
//  r:=body.createTextRange;
//  r.moveToPoint(0,Y);
//  r.scrollintoview(true);
 except
 end;
end;

procedure TPodViewerForm.RefreshActionUpdate(Sender: TObject);
begin
 RefreshAction.enabled:=(vst.Enabled) and (length(PodFile)>0);
end;

end.


