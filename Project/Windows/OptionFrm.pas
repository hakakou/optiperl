unit OptionFrm; //Modal //VST
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,OptOptions,dcmemo, jvSpin, hakahyper,Hyperstr,
  dccommon, Mask, OptFolders, hakafile, HakaControls, PerlHelpers,
  Buttons,hyperfrm,OptGeneral,hakaMessageBOx,PerlApi,jclRegistry,
  HKRegistry, OptAssociations,addassocfrm,hakageneral,AppDataFrm,
  ExtCtrls,agPropUtils,jclfileutils, VirtualTrees,OptBackup,ScriptInfoUnit,
  AppEvnts, HaKaTabs, ParsersMdl, ehsbase, ehswhatsthis, ehscontextmap,
  OptProtoFrm,OfrmLines,ofrmBoxBr,ofrmBoxPar,ofrmPrinter,ofrmBVisual,
  jvCtrls, OptControl, OPerformanceFrm, DrawComboBox,OptProcs,hkgraphics,
  PBFolderDialog, dcstdctl, JvPlacemnt, JvxCtrls, JvCombobox, JvColorCombo,
  JvEdit, JvToolEdit, JvGradient, JvGradientCaption, Themes,HKThemes,uxTheme,
  JvMaskEdit;

type
  TOptionForm = class(TForm)
    btnCancel: TButton;
    btnDefault: TButton;
    btnOK: TButton;
    FormStorage: TjvFormStorage;
    btnApply: TButton;
    VST: TVirtualStringTree;
    Notebook: TNotebook;
    AGroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label12: TLabel;
    btnFindPerl: TSpeedButton;
    btnGuess: TSpeedButton;
    RunTimeOut: TjvSpinEdit;
    PerlSearchDir: TEdit;
    AGroupBox7: TGroupBox;
    btnResetMessages: TSpeedButton;
    cbOneInstance: TCheckBox;
    ShowTipsStartup: TCheckBox;
    TrayBarIcon: TCheckBox;
    KeybExtended: TCheckBox;
    AGroupBox10: TGroupBox;
    btnClearRecent: TSpeedButton;
    Label18: TLabel;
    RecentItems: TjvSpinEdit;
    AGroupBox6: TGroupBox;
    Label14: TLabel;
    lblRegStatus: TLabel;
    btnRestoreReg: TSpeedButton;
    btnSetReg: TSpeedButton;
    cbCheckAssociations: TCheckBox;
    gbDebugger: TGroupBox;
    Label20: TLabel;
    CheckSyntax: TCheckBox;
    IncGutter: TCheckBox;
    LiveEvalDelay: TjvSpinEdit;
    grpInternalServer: TGroupBox;
    Label10: TLabel;
    btnRootDir: TSpeedButton;
    Label13: TLabel;
    btnAddAssoc: TSpeedButton;
    btnRemoveAssoc: TSpeedButton;
    btnEdit: TSpeedButton;
    btnDef: TSpeedButton;
    RootDir: TComboBox;
    AssocList: TjvTextListBox;
    AGroupBox3: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    AccessLogFile: TJvFilenameEdit;
    ErrorLogFile: TJvFilenameEdit;
    EditOptGroup: TGroupBox;
    PersistentBlock: TCheckBox;
    OverwriteBlock: TCheckBox;
    DblClickEdit: TCheckBox;
    FindText: TCheckBox;
    OverCaret: TCheckBox;
    DisableDrag: TCheckBox;
    ShowLineNum: TCheckBox;
    ShowLineNumGut: TCheckBox;
    GroupUndo: TCheckBox;
    CursorEof: TCheckBox;
    BeyondEol: TCheckBox;
    SelectEol: TCheckBox;
    WordWrap: TCheckBox;
    AGroupBox9: TGroupBox;
    ElementLbl: TLabel;
    ForeColorLbl: TLabel;
    BoldChk: TCheckBox;
    ItalicChk: TCheckBox;
    UnderLineChk: TCheckBox;
    Elements: TListBox;
    AGroupBox4: TGroupBox;
    Label4: TLabel;
    Label22: TLabel;
    DefaultScriptFolder: TJvDirectoryEdit;
    DefaultScript: TJvFilenameEdit;
    AGroupBox5: TGroupBox;
    Label5: TLabel;
    Label23: TLabel;
    DefaultHtmlFolder: TJvDirectoryEdit;
    DefaultHtml: TJvFilenameEdit;
    AGroupBox8: TGroupBox;
    Label3: TLabel;
    Host: TEdit;
    DefaultLineEnd: TRadioGroup;
    ShowSpecialSymbols: TCheckBox;
    FoldGroup: TGroupBox;
    Label21: TLabel;
    FoldEnable: TCheckBox;
    GroupBox1: TGroupBox;
    EditFontLbl: TLabel;
    EditorColorLbl: TLabel;
    SizeLbl: TLabel;
    FontName: TjvFontComboBox;
    FontSize: TjvSpinEdit;
    UseMonoFont: TCheckBox;
    cbFontBack: TCheckBox;
    GroupBox4: TGroupBox;
    LineEnable: TCheckBox;
    BoxGroup: TGroupBox;
    BoxEnable: TCheckBox;
    BoxBrackets: TCheckBox;
    BoxParen: TCheckBox;
    BoxPod: TCheckBox;
    BoxHereDoc: TCheckBox;
    btnBrackets: TSpeedButton;
    btnParen: TSpeedButton;
    BoxHereDocBrush: TFillStyleComboBox;
    BoxPodBrush: TFillStyleComboBox;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    GroupBox6: TGroupBox;
    DoBracketSearch: TCheckBox;
    DoBracketMouseSearch: TCheckBox;
    GroupBox7: TGroupBox;
    SyntaxHighlight: TCheckBox;
    ActiveTextStyle: TRadioGroup;
    btnEditStyle: TSpeedButton;
    btnResetStyles: TSpeedButton;
    Label63: TLabel;
    edStyleName: TEdit;
    btnCopyThis: TSpeedButton;
    btnApplyStyle: TSpeedButton;
    EnableHHHEEE: TCheckBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    SmartTab: TCheckBox;
    TabStopLbl: TLabel;
    TabStopsEdit: TEdit;
    TabCharacter: TCheckBox;
    CursorOnTabs: TCheckBox;
    EditorColor: THKColorBox;
    FoldGutColor: THKColorBox;
    ForeColor: THKColorBox;
    BackColor: THKColorBox;
    BoxHereDocColor: THKColorBox;
    BoxPodColor: THKColorBox;
    ColorDialog: TColorDialog;
    WhatsThis: TWhatsThis;
    btnWT: TSpeedButton;
    GroupBox11: TGroupBox;
    CodeComEnable: TCheckBox;
    CodeComHints: TCheckBox;
    GroupBox13: TGroupBox;
    Label73: TLabel;
    RemDebPort: TjvSpinEdit;
    GroupBox15: TGroupBox;
    StandardLayouts: TCheckBox;
    btnHelp: TButton;
    Warnings: TRadioGroup;
    GroupBox12: TGroupBox;
    SHEditorErrors: TCheckBox;
    SHExplorerErrors: TCheckBox;
    SHExplorerWarnings: TCheckBox;
    SHEditorWarnings: TCheckBox;
    SHWarningColor: THKColorBox;
    SHErrorColor: THKColorBox;
    SHErrorStyle: TLineStyleComboBox;
    SHWarningStyle: TLineStyleComboBox;
    Label75: TLabel;
    Label76: TLabel;
    Label77: TLabel;
    Label78: TLabel;
    Label79: TLabel;
    DefPerlExtension: TEdit;
    GroupBox16: TGroupBox;
    RunRemHost: TCheckBox;
    RunRemUpload: TCheckBox;
    GroupBox17: TGroupBox;
    Label80: TLabel;
    Label81: TLabel;
    CodeExplorerFontSize: TjvSpinEdit;
    CodeExplorerFontName: TjvFontComboBox;
    OLinePanel: TDCFormPanel;
    OBoxBrPanel: TDCFormPanel;
    OBoxParPanel: TDCFormPanel;
    OPrinterPanel: TDCFormPanel;
    OVisualPanel: TDCFormPanel;
    Label15: TLabel;
    IntServerAliases: TEdit;
    btnHttpConf: TButton;
    ExtServerRoot: TJvDirectoryEdit;
    Label16: TLabel;
    Label9: TLabel;
    ExtServerAliases: TEdit;
    OpenDialog: TOpenDialog;
    GroupBox2: TGroupBox;
    TemplateFolder: TJvDirectoryEdit;
    PathToPerl: TJvFilenameEdit;
    CommonFolder: TJvDirectoryEdit;
    Label11: TLabel;
    Label17: TLabel;
    SCDecIdent: TCheckBox;
    btnSynPreviewFile: TSpeedButton;
    btnPreviewBox: TSpeedButton;
    HighLightURL: TCheckBox;
    CodeComHTML: TCheckBox;
    GroupBox5: TGroupBox;
    BrowserFocus: TCheckBox;
    SecondBrowser: TJvFilenameEdit;
    Label19: TLabel;
    btnPerformance: TSpeedButton;
    DispFullExtension: TCheckBox;
    FoldLastLine: TCheckBox;
    GroupBox3: TGroupBox;
    FoldBrackets: TCheckBox;
    FoldParenthesis: TCheckBox;
    FoldHereDoc: TCheckBox;
    FoldPod: TCheckBox;
    FoldDefBrackets: TCheckBox;
    FoldDefParenthesis: TCheckBox;
    FoldDefHereDoc: TCheckBox;
    FoldDefPod: TCheckBox;
    FontAliased: TCheckBox;
    btnAppData: TSpeedButton;
    GroupBox10: TGroupBox;
    CodeLibPrompt: TCheckBox;
    Label24: TLabel;
    SelBackColor: THKColorBox;
    Label25: TLabel;
    SelColor: THKColorBox;
    SHPathDisable: TEdit;
    Label26: TLabel;
    HintEditorFont: TCheckBox;
    EditorDelimiters: TEdit;
    Label27: TLabel;
    SCVarDiff: TCheckBox;
    CloseTabDoubleClick: TCheckBox;
    GroupBox14: TGroupBox;
    DockingStyle: TRadioGroup;
    DockInvertCtrl: TCheckBox;
    DockCapHeight: TjvSpinEdit;
    Label28: TLabel;
    DockShowButtons: TCheckBox;
    DockShowTaskBar: TCheckBox;
    DockContextMenu: TCheckBox;
    Status: TLabel;
    GroupBox18: TGroupBox;
    BackupEnable: TCheckBox;
    BackupName: TEdit;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Bevel1: TBevel;
    Label34: TLabel;
    BackupZip: TCheckBox;
    BakPreview: TMemo;
    btnSuggest: TSpeedButton;
    Label35: TLabel;
    PerlDLL: TEdit;
    Label36: TLabel;
    BackupPrjName: TEdit;
    Bevel2: TBevel;
    Label37: TLabel;
    Label38: TLabel;
    MultiLineTabs: TCheckBox;
    BlockIndentLbl: TLabel;
    BlockIndent: TJvSpinEdit;
    GroupBox19: TGroupBox;
    KeepSessionsAlive: TCheckBox;
    Label43: TLabel;
    SessionKeepAliveInterval: TJvSpinEdit;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    TabVisible: TCheckBox;
    TabStyle: TLineStyleComboBox;
    TabColor: THKColorBox;
    TabWidth: TLineWidthComboBox;
    BackUnindent: TCheckBox;
    AutoIndent: TCheckBox;
    TrimWhiteSpace: TRadioGroup;
    PerlDBOptslbl: TLabel;
    PerlDBOpts: TEdit;
    Label44: TLabel;
    ServerPort: TJvSpinEdit;
    ExtServerPort: TJvSpinEdit;
    Label8: TLabel;
    Label45: TLabel;
    InOutPort: TJvSpinEdit;
    StartupLastOpen: TCheckBox;
    Label46: TLabel;
    NavDelimiters: TEdit;
    procedure ElementsClick(Sender: TObject);
    procedure ForeColorChange(Sender: TObject);
    procedure BackColorChange(Sender: TObject);
    procedure BoldChkClick(Sender: TObject);
    procedure ItalicChkClick(Sender: TObject);
    procedure UnderLineChkClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnRootDirClick(Sender: TObject);
    procedure btnResetMessagesClick(Sender: TObject);
    procedure UseMonoFontClick(Sender: TObject);
    procedure TabCharacterClick(Sender: TObject);
    procedure SmartTabClick(Sender: TObject);
    procedure btnRestoreRegClick(Sender: TObject);
    procedure btnSetRegClick(Sender: TObject);
    procedure cbCheckAssociationsClick(Sender: TObject);
    procedure btnAddAssocClick(Sender: TObject);
    procedure btnRemoveAssocClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDefClick(Sender: TObject);
    procedure btnClearRecentClick(Sender: TObject);
    procedure btnGuessClick(Sender: TObject);
    procedure edRootFolderExit(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure VSTChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure btnFindPerlClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbFontBackClick(Sender: TObject);
    procedure FoldBracketsClick(Sender: TObject);
    procedure FoldHereDocClick(Sender: TObject);
    procedure FoldParenthesisClick(Sender: TObject);
    procedure FoldPodClick(Sender: TObject);
    procedure FoldEnableClick(Sender: TObject);
    procedure btnBracketsParClick(Sender: TObject);
    procedure BoxEnableClick(Sender: TObject);
    procedure NotebookPageChanged(Sender: TObject);
    procedure btnResetStylesClick(Sender: TObject);
    procedure btnEditStyleClick(Sender: TObject);
    procedure edStyleNameChange(Sender: TObject);
    procedure btnCopyThisClick(Sender: TObject);
    procedure btnApplyStyleClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnHttpConfClick(Sender: TObject);
    procedure btnSynPreviewFileClick(Sender: TObject);
    procedure btnPreviewBoxClick(Sender: TObject);
    procedure btnPerformanceClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnAppDataClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormPaint(Sender: TObject);
    procedure BackupNameChange(Sender: TObject);
    procedure BackupEnableClick(Sender: TObject);
    procedure btnSuggestClick(Sender: TObject);
    procedure btnLightSatClick(Sender: TObject);
    procedure cbOneInstanceClick(Sender: TObject);
  private
    AdminRights : Boolean;
    TempOptions,OrgOptions : TOptiOptions;
    GoodHeight,NowStyle : Integer;
    ActiveProto : TOptProtoForm;
    TheNodes : Array[0..25] of PVIrtualNode;
    Procedure PutValues;
    Procedure GetValues;
    Function checkexistsExt(const ext : string) : boolean;
    Function AddNode(Sheet,help: Integer; Parent : PVirtualNode = nil; Style : Integer = -1) : PVirtualNode;
    procedure Initialize(Full : Boolean);
    procedure FreeProtos;
    procedure FontAliasedClick(Sender: TObject);
  public
    StartIndex,Startcolorindex : Integer;
  end;

var
  OptionForm: TOptionForm;

implementation
{$R *.DFM}

const
 reg: array[false..true] of string = ('Problems','OK');

type
  PData = ^TData;
  TData = Record
   Sheet : Integer;
   Help : Integer;
   Style : Integer;
  end;

{ TOptionForm }

procedure TOptionForm.edStyleNameChange(Sender: TObject);
begin
 if NowStyle=-1 then exit;
 TempOptions.TS[NowStyle].Name:=edStyleName.text;
end;

procedure TOptionForm.ElementsClick(Sender: TObject);
begin
 if NowStyle=-1 then exit;
 with TempOptions.TS[NowStyle] do
 begin
  BackColor.Selected:=Data[Elements.ItemIndex].BackColor;
  BackColor.Invalidate;
  ForeColor.Selected:=Data[Elements.ItemIndex].ForeColor;
  ForeColor.Invalidate;
  BoldChk.Checked:=Data[Elements.ItemIndex].Bold;
  ItalicChk.Checked:=Data[Elements.ItemIndex].Italic;
  UnderLineChk.Checked:=Data[Elements.ItemIndex].UnderLine;
  cbFontBack.Checked:=Data[Elements.ItemIndex].HasBackGround;
  BackColor.Enabled:=cbFontBack.Checked;
  edStyleName.Text:=name;
 end;
end;

procedure TOptionForm.btnApplyStyleClick(Sender: TObject);
begin
 btnCancel.ModalResult:=mrOK;
 TempOptions.ActiveTextStyle:=NowStyle;
 ActiveTextStyle.ItemIndex:=NowStyle;
 TempOptions.ApplyStyle(ActiveEdit.MainMemo);
 ParsersMod.SetSyntax(TempOptions);
end;

procedure TOptionForm.cbFontBackClick(Sender: TObject);
begin
 if NowStyle=-1 then exit;
 BackColor.enabled:=cbFontback.checked;
 TempOptions.ts[nowstyle].data[Elements.ItemIndex].HasBackGround:=cbFontback.checked;
end;

procedure TOptionForm.ForeColorChange(Sender: TObject);
begin
 if NowStyle=-1 then exit;
 TempOptions.ts[nowstyle].data[Elements.ItemIndex].ForeColor:=ForeColor.Selected;
end;

procedure TOptionForm.BackColorChange(Sender: TObject);
begin
 if NowStyle=-1 then exit;
 TempOptions.ts[nowstyle].data[Elements.ItemIndex].BackColor:=BackColor.Selected;
end;

procedure TOptionForm.BoldChkClick(Sender: TObject);
begin
 if NowStyle=-1 then exit;
 TempOptions.ts[nowstyle].data[Elements.ItemIndex].Bold:=BoldChk.Checked;
end;

procedure TOptionForm.ItalicChkClick(Sender: TObject);
begin
 if NowStyle=-1 then exit;
 TempOptions.ts[nowstyle].data[Elements.ItemIndex].Italic:=ItalicChk.Checked;
end;

procedure TOptionForm.UnderLineChkClick(Sender: TObject);
begin
 if NowStyle=-1 then exit;
 TempOptions.ts[nowstyle].data[Elements.ItemIndex].UnderLine:=UnderLineChk.Checked;
end;

procedure TOptionForm.GetValues;
begin
 TempOptions.GetFromForm(self);
 if assigned(ActiveProto) then
  ActiveProto.GetFromForm;
 Tempoptions.RootDirList:=rootdir.Items.Text;
end;

procedure TOptionForm.PutValues;
begin
 TempOptions.SetToForm(self);
 if assigned(ActiveProto) then
  ActiveProto.SetToForm;
 rootdir.Items.Text:=TempOptions.RootDirList;
end;

procedure TOptionForm.Initialize(Full : Boolean);
begin
 if full then PutValues;
 Elements.ItemIndex:=0;
 ElementsClick(self);
 UseMonoFontClick(self);
 FoldBracketsClick(self);
 FoldHereDocClick(self);
 FoldParenthesisClick(self);
 FoldPodClick(self);
 FoldEnableClick(self);
 BoxEnableClick(self);
 BackupEnableClick(self);
 BackupNameChange(self);
 FontAliased.onclick:=FontAliasedClick;
 try
  cbCheckAssociations.Checked:=ShouldCheckAssocs(RegSoftKey);
  cbOneInstance.checked:=RegReadBoolDef(HKEY_LOCAL_MACHINE,OptiRegKey,OptiRegKey_OneInstance,true);
 except
  SetGroupEnable([cbCheckAssociations,cbOneInstance],false);
  AdminRights:=false;
 end;
end;

procedure TOptionForm.FormShow(Sender: TObject);
var
 i:integer;
 node,n2 : PVirtualNode;
 Data : PData;
begin
 GoodHeight:=PerlSearchDir.Height;
 Initialize(true);
 vst.Clear;
 addNode(0,6860);  //perl
 addNode(1,6790);  //env
 addNode(2,6790);  //env 2
 addNode(3,7870);  //windows
 if OptiRel<>orStan then
  addNode(4,6800);  //debugger

 addNode(5,6920);  //Error Testing
 addNode(6,7130);  //running
 addNode(7,6810);  //internal
 addNode(8,6810);  //external
 addNode(9,6830); //printer
 addNode(10,7880); //backups
 node:=addNode(11,6820); //editor
 addNode(12,6820,node);  //folding
 addNode(13,6820,node);  //Tabs
 addNode(14,6890,node);  //behavior
 addNode(15,6900,node); //visual
 addNode(16,6910,node); //defaults
 node:=addNode(17,6840); //syntax coding
 n2:=node;
 for i:=0 to MaxStyles-1 do
 begin
  ActiveTextStyle.Items.Objects[i]:=
    TObject(Addnode(18,6840,Node,i));
 end;

 node:=addNode(19,6850);  //level coding
 addNode(20,6850,node);  //lines
 BtnBrackets.tag:=Integer(addNode(21,6850,node));  //bracket boxes
 BtnParen.tag:=Integer(addNode(22,6850,node));  //Paren boxes

 if OptiRel=orCom then
  addNode(23,7410); //multi user

 if Startcolorindex>=0 then
 begin
  Status.Caption:=TempOPtions.ts[tempoptions.activetextstyle].Name;
  if Elements.Count>Startcolorindex then
   Elements.ItemIndex:=Startcolorindex;
 end;

 if StartIndex>=0 then
  Status.Caption:=Notebook.Pages[StartIndex];

 Node:=VST.GetFirst;
 while assigned(node) do
 begin
  data:=VST.GetNodeData(node);
  if ((notebook.Pages[data.sheet]=status.Caption)) or
     ((data.Style>=0) and (TempOPtions.ts[data.style].Name=Status.Caption))
       then break;
  node:=VST.GetNext(node);
 end;

 if assigned(node)
  then VST.FocusedNode:=node
  else VST.FocusedNode:=vst.GetFirst;

 ActiveProto:=nil;
 VST.Selected[vst.FocusedNode]:=true;

 if assigned(node) then
  NotebookPageChanged(self);

 VST.FullExpand;
 vst.Expanded[n2]:=VST.FocusedNode.Parent=n2;
 NormalizeControl(self,GoodHeight);
end;

procedure TOptionForm.FreeProtos;
begin
 if assigned(ActiveProto) then
 begin
  OLinePanel.Form:=nil;
  OBoxBrPanel.Form:=nil;
  OBoxParPanel.Form:=nil;
  OPrinterPanel.form:=nil;
  OVisualPanel.Form:=nil;
  FreeAndNil(ActiveProto);
 end;
end;

procedure TOptionForm.NotebookPageChanged(Sender: TObject);
var i:integer;
begin
 FreeProtos;

 if Notebook.ActivePage = 'Lines'
 then begin
  OFormLines:=TOFormLines.Create(TempOptions,ColorDialog);
  with OFormLines do
   for i:=0 to LineGroup.ControlCount-1 do
    SetBoolProperty(LineGroup.Controls[i],'Enabled',
     LineEnable.checked);
  OLinePanel.Form:=OFormLines;
  ActiveProto:=OFormLines;
 end

 else
 if Notebook.ActivePage = 'Bracket Boxing'
 then begin
  OFormBoxBr:=TOFormBoxBr.Create(TempOptions,ColorDialog);
  with OFormBoxBr do
  for i:=0 to BoxBrGroup.ControlCount-1 do
   SetBoolProperty(BoxBrGroup.Controls[i],'Enabled',
    BoxBrackets.checked and BoxEnable.checked);
  OBoxBrPanel.Form:=OFormBoxBr;
  ActiveProto:=OFormBoxBr;
 end

 else
 if Notebook.ActivePage = 'Parenthesis Boxing'
 then begin
  OFormBoxPar:=TOFormBoxPar.Create(TempOptions,ColorDialog);
  with OFormBoxPar do
  for i:=0 to BoxParGroup.ControlCount-1 do
   SetBoolProperty(BoxParGroup.Controls[i],'Enabled',
    BoxParen.checked and BoxEnable.checked);
  OBoxParPanel.Form:=OFormBoxPar;
  ActiveProto:=OFormBoxPar;
 end

 else
 if Notebook.ActivePage = 'Printer'
 then begin
  OFormPrinter:=TOFormPrinter.Create(TempOptions,ColorDialog);
  OPrinterPanel.Form:=OFormPrinter;
  ActiveProto:=OFormPrinter;
 end

 else
 if Notebook.ActivePage = 'Visual'
 then begin
  OFormVisual:=TOFormVisual.Create(TempOptions,ColorDialog);
  OVisualPanel.Form:=OFormVisual;
  ActiveProto:=OFormVisual;
 end

 else
 if NOteBook.ActivePage = 'Syntax Coding' then
  for i:=0 to maxstyles-1 do
   ActiveTextStyle.Items[i]:=TempOptions.ts[i].Name;

 if assigned(ActiveProto) then
  NormalizeControl(ActiveProto,GoodHeight);
end;


Function TOptionForm.AddNode(Sheet,Help : Integer; Parent : PVirtualNode = nil; Style : Integer = -1) : PVirtualNode;
var
 data : PData;
begin
 if parent=nil then
  parent:=vst.rootnode;
 result:=vst.AddChild(parent);
 data:=vst.GetNodeData(result);
 data.Sheet:=sheet;
 data.Help:=help;
 data.Style:=style;
 TheNodes[data.Style]:=result;
end;

procedure TOptionForm.FormCreate(Sender: TObject);
begin
 if OptiRel=orStan then
 begin
  PerlDBOpts.Visible:=false;
  PerlDBOptsLbl.Visible:=false;
 end;
 OLinePanel.Align:=alClient;
 OBoxBrPanel.Align:=alClient;
 OBoxParPanel.Align:=alClient;
 OPrinterPanel.Align:=alClient;
 OVisualPanel.Align:=alClient;
 TempOptions:=TOptiOptions.Create;
 TempOptions.Assign(Options);
 OrgOptions:=TOptiOptions.Create;
 OrgOptions.Assign(Options);

 VST.NodeDataSize:=sizeof(TData);
 NoteBook.ActivePage:=notebook.Pages[0];
 lblRegStatus.Caption:=reg[CheckOptiAssociations];

 AdminRights:=IsAdmin;
 SetGroupEnable([cbCheckAssociations,cbOneInstance],AdminRights);
 SetVirtualTree(vst);
end;

procedure TOptionForm.btnRootDirClick(Sender: TObject);
var s:string;
begin
 s:=RootDir.Text;
 if BrowseForFolder('Select server root:',true,s) then
 begin
  RootDir.Text:=s;
  handlecombobox(ROotDir);
 end;
end;

procedure TOptionForm.btnResetMessagesClick(Sender: TObject);
begin
 if MessageDlg('Are you sure you would like all message boxes to display again?', mtConfirmation, [mbYes, mbCancel], 0)=mrYes
  then HakaMessageBox.ResetMessageDlgsMemo;
end;

procedure TOptionForm.UseMonoFontClick(Sender: TObject);
var fo : TJvFontComboOptions;
begin
 fo:=FontName.Options;
 if UseMonoFont.Checked
  then include(fo,foFixedPitchOnly)
  else exclude(fo,foFixedPitchOnly);
 FontName.Options:=fo;
end;

procedure TOptionForm.TabCharacterClick(Sender: TObject);
begin
 if (SmartTab.Checked) and (TabCharacter.Checked) then
  SmartTab.Checked:=False;
end;

procedure TOptionForm.SmartTabClick(Sender: TObject);
begin
 if (SmartTab.Checked) and (TabCharacter.Checked) then
  TabCharacter.Checked:=False;
end;

procedure TOptionForm.btnRestoreRegClick(Sender: TObject);
begin
 if not AdminRights then
  MessageDlg('You must have administrator privileges to select this option.', mtError, [mbOK], 0)
 else
  RemovePerlAssociation;
 lblRegStatus.Caption:=reg[CheckOptiAssociations];
end;

procedure TOptionForm.btnSetRegClick(Sender: TObject);
begin
 if not AdminRights then
  MessageDlg('You must have administrator privileges to select this option.', mtError, [mbOK], 0)
 else
 begin
  AddPerlAssociations;
  AddOptiAssociations;
 end;
 lblRegStatus.Caption:=reg[CheckOptiAssociations];
end;

procedure TOptionForm.cbCheckAssociationsClick(Sender: TObject);
begin
 SetShouldCheckAssocs(regsoftkey,cbCheckAssociations.Checked)
end;

procedure TOptionForm.btnAddAssocClick(Sender: TObject);
var ext,prog : string;
begin
 ext:='';
 prog:='';
 if execute(ext,prog) then
 begin
  if checkexistsExt(ext) then
  begin
   MessageDlg('Extension already exists.', mtError, [mbOK], 0);
   exit;
  end;
  AssocList.Items.add(ext+'='+prog);
 end;
end;

Function TOptionForm.checkexistsExt(const ext : string) : boolean;
var Aext,prog : string;
 i:integer;
begin
 result:=false;
 with assocList do
 begin
  for i:=0 to items.count-1 do
  begin
   ParseWithEqual(items[i],Aext,prog);
   result:=(uppercase(ext)=uppercase(Aext));
   if result then exit;
  end;
 end;
end;

procedure TOptionForm.btnRemoveAssocClick(Sender: TObject);
begin
 if assocList.itemindex<0 then exit;
 if MessageDlg('Are you sure you want to remove association?', mtConfirmation, [mbYes, mbCancel], 0) = mrYes then
 with assocList do
  Items.Delete(itemindex);
end;

procedure TOptionForm.btnEditClick(Sender: TObject);
var ext,prog : string;
begin
 with assocList do
 begin
  if itemindex<0 then exit;
  ParseWithEqual(items[itemindex],ext,prog);
  if execute(ext,prog) then
  begin
   Items[itemindex]:=ext+'='+prog;
  end;
 end;
end;

procedure TOptionForm.btnFindPerlClick(Sender: TObject);
var s:String;
begin
 s:=FindPerlPath;
 if fileexists(s)
  then begin
   PathToPerl.Text:=s;
   PerlSearchDir.Text:=FastFindINCPath(PathToPerl.Text)
  end
  else
   MessageDlg('Could not find perl.'+#13+#10+'Make sure you have installed it.'+#13+#10+''+#13+#10+'For more information, refer to the "Setting Up"'+#13+#10+'section in the help file.', mtWarning, [mbOK], 0);
end;

procedure TOptionForm.btnDefClick(Sender: TObject);
var path : string;
begin
 path:=PathToPerl.Text;
 if (not fileexists(path)) and
    (MessageDlg('Path to perl is invalid.'+#13+#10+'Continue?', mtWarning, [mbYes, mbCancel], 0)=mrCancel)
 then exit;
 assocList.Items.text:=
   'pl='+path+#13#10+
   'cgi='+path+#13#10+
   'plx='+path;
end;

procedure TOptionForm.btnClearRecentClick(Sender: TObject);
begin
 with options do
 begin
  StartPathList:='';
  RootDirList:='';
 end;
 PC_ClearRecentList;
end;

procedure TOptionForm.btnGuessClick(Sender: TObject);
begin
 PerlSearchDir.Text:=FindINCPath(PathToPerl.Text);
 PerlDll.Text:=FindDLLPath(PathToPerl.Text);
end;

procedure TOptionForm.edRootFolderExit(Sender: TObject);
begin
 RootDir.text:=includetrailingbackslash(RootDir.text);

 if isUNCPath(RootDir.text) then
 begin
  MessageDlg('Must be a local folder.', mtError, [mbOK], 0);
  RootDir.Text:=TempOptions.RootDir;
  exit;
 end;

 if not directoryexists(RootDir.text) then
 begin
  MessageDlg('Folder does not exists.', mtError, [mbOK], 0);
  RootDir.Text:=TempOptions.RootDir;
  exit;
 end;

end;

procedure TOptionForm.btnOKClick(Sender: TObject);
begin
 GetValues;
 Options.Assign(TempOPtions);
end;

procedure TOptionForm.btnApplyClick(Sender: TObject);
begin
 btnCancel.ModalResult:=mrOK;
 GetValues;
 Options.Assign(TempOptions);
 PC_OptionsUpdated(HKO_BigVisible);
end;

procedure TOptionForm.btnCopyThisClick(Sender: TObject);
begin
 TempOptions.TS[nowstyle]:=tempOptions.ts[0];
 ElementsClick(Sender);
end;

procedure TOptionForm.btnDefaultClick(Sender: TObject);
var
 top : TOptiOptions;
 i:integer;
begin
 i:=MessageDlg('Reset options on this page only? '+#13+#10+'No will reset all options of OptiPerl.', mtConfirmation, [mbYes,mbNo,mbCancel], 0);
 if i=mrCancel then exit;
 if (i=mrNo) or (NoteBook.PageIndex=1) then
  if AdminRights then
   RegWriteBool(HKEY_LOCAL_MACHINE,OptiRegKey,OptiRegKey_OneInstance,true);

 if i=mrNo then
  begin
   TempOptions.SetDefaults;
   Initialize(true);
  end
 else
  begin

   if nowstyle<>-1 then
    begin
     TempOptions.SetDefTextStyle(NowStyle);
     ElementsClick(Sender);
    end
   else
    begin
     Top:=TOptiOptions.Create;

     if assigned(ActiveProto) then
       top.SetToForm(ActiveProto)
     else
      for i:=0 to notebook.ControlCount-1 do
       if (TControl(notebook.Controls[i]).ClassName='TPage') and
          (TControl(notebook.Controls[i]).Visible) then
       begin
        top.SetToForm(TCustomForm(notebook.Controls[i]));
        TempOptions.GetFromForm(self);
        break;
       end;

     Top.Free;
     Initialize(false);
    end;

  end;

end;

procedure TOptionForm.btnCancelClick(Sender: TObject);
begin
 if btnCancel.ModalResult=mrOK then
  options.Assign(OrgOptions);
end;

procedure TOptionForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var data : PData;
begin
 data:=VST.GetNodeData(Node);
 if data.Style=-1
  then celltext:=Notebook.Pages[data.sheet]
  else celltext:=TempOPtions.ts[data.style].Name;
end;

procedure TOptionForm.VSTChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var data : PData;
begin
 if not assigned(node) then exit;
 data:=VST.GetNodeData(Node);
 if assigned(data) then
 begin
  try
   Notebook.ActivePage:=notebook.Pages[data.sheet];
  except on  exception do end;
  Status.Tag:=data.Sheet;
  NowStyle:=data.Style;
  if data.Style=-1
   then Status.Caption:=notebook.Pages[data.sheet]
   else
    begin
     Status.Caption:=TempOPtions.ts[data.style].Name;
     ElementsClick(Sender);
    end;
 end;
end;

procedure TOptionForm.FormDestroy(Sender: TObject);
begin
 TempOptions.Free;
 OrgOptions.Free;
end;

procedure TOptionForm.FoldBracketsClick(Sender: TObject);
begin
 FoldDefBrackets.Enabled:=FoldBrackets.Checked;
end;

procedure TOptionForm.FoldHereDocClick(Sender: TObject);
begin
 FoldDefHereDoc.Enabled:=FoldHereDoc.Checked;
end;

procedure TOptionForm.FoldParenthesisClick(Sender: TObject);
begin
 FoldDefParenthesis.Enabled:=FoldParenthesis.Checked;
end;

procedure TOptionForm.FoldPodClick(Sender: TObject);
begin
 FoldDefPod.Enabled:=FoldPod.Checked;
end;

procedure TOptionForm.FoldEnableClick(Sender: TObject);
var i:integer;
begin
 for i:=0 to FoldGroup.ControlCount-1 do
  if FoldGroup.Controls[i]<>FoldEnable then
   AgPropUtils.SetBoolProperty(FoldGroup.Controls[i],'Enabled',FoldEnable.checked);
end;

procedure TOptionForm.btnBracketsParClick(Sender: TObject);
begin
 Vst.FocusedNode:=PVirtualNode(TComponent(sender).Tag);
 vst.Selected[PVirtualNode(TComponent(sender).Tag)]:=true;
end;

procedure TOptionForm.BoxEnableClick(Sender: TObject);
var i:integer;
begin
 for i:=0 to BoxGroup.ControlCount-1 do
  if BoxGroup.Controls[i]<>BoxEnable then
  begin
   AgPropUtils.SetBoolProperty(BoxGroup.Controls[i],'Enabled',BoxEnable.checked);
  end;
end;


procedure TOptionForm.btnResetStylesClick(Sender: TObject);
var i:integer;
begin
 if MessageDlg('Are you sure you want to reset all styles?', mtConfirmation, [mbOK,mbCancel], 0) = mrOk then
 begin
  for i:=0 to MaxStyles-1 do
   TempOptions.SetDefTextStyle(i);
 end;
end;

procedure TOptionForm.btnEditStyleClick(Sender: TObject);
var p:PVirtualNode;
begin
 p:=PVirtualNode(ActiveTextStyle.Items.Objects[ActiveTextStyle.ItemIndex]);
 Vst.FocusedNode:=PVirtualNode(p);
 vst.Selected[PVirtualNode(p)]:=true;
end;

procedure TOptionForm.btnHelpClick(Sender: TObject);
var
 p:Pdata;
 i:integer;
begin
 p:=VST.getnodedata(vst.FocusedNode);
 if assigned(p)
  then i:=p.Help
  else i:=6960;

 Application.HelpCommand(HELP_CONTEXT,i);
end;

procedure TOptionForm.btnHttpConfClick(Sender: TObject);
var DocRoot,Aliases,ErrorLog,AccessLog : string;
begin
 if ParseHttpConf(DocRoot,Aliases,ErrorLog,AccessLog) then
 begin
  extserverroot.Text:=docroot;
  extserveraliases.Text:=aliases;
  errorlogfile.text:=errorlog;
  accesslogfile.Text:=accesslog;
 end;
end;

procedure TOptionForm.btnSynPreviewFileClick(Sender: TObject);
begin
 PR_OpenFile(programPath+'Syntax Parser Elements.pl');
 SetFocus;
end;

procedure TOptionForm.btnPreviewBoxClick(Sender: TObject);
begin
 PR_OpenFile(programPath+'Box - Line Coding.pl');
 SetFocus;
end;

procedure TOptionForm.btnPerformanceClick(Sender: TObject);
begin
 OPerformanceForm:=tOPerformanceForm.Create(TempOptions,ColorDialog);
 OPerformanceForm.ShowModal;
 OPerformanceForm.Free;
end;

procedure TOptionForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 FreeProtos;
end;

procedure TOptionForm.btnAppDataClick(Sender: TObject);
begin
 if MessageDlg('This will change the application data folder of OptiPerl.'+#13+#10+'Continue?', mtConfirmation, [mbOK,mbCancel], 0) <>mrOK then exit;
 AppDataForm:=TAppDataForm.Create(Application);
 with AppDataForm do
 try
  showmodal;
 finally
  free;
 end;
end;

procedure TOptionForm.FontAliasedClick(Sender: TObject);
begin
 if (not OPtions.Streaming) and (FontAliased.Checked) and (Win32MajorVersion>4) then
  MessageDlg('Using aliased fonts may slow down the redrawing of the editor,'+#13#10+'with an unappealing result. If you have this problem, please deselect this option.', mtWarning, [mbOK], 0);
end;

procedure TOptionForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (not vst.Focused) and ((key=VK_NEXT) or (key=vk_PRIOR)) then
 begin
  if key=VK_Next
   then PostMessage(VST.Handle, WM_KEYDOWN, VK_Down, 0)
   else PostMessage(VST.Handle, WM_KEYDOWN, VK_UP, 0);
  key:=0;
 end;
end;

procedure TOptionForm.FormPaint(Sender: TObject);
begin
 DrawButton(canvas,rect(Notebook.Left+9,4,notebook.Width+notebook.Left-8,notebook.Top),tbPushButtonNormal);
end;

procedure TOptionForm.BackupNameChange(Sender: TObject);
var
 bk : TOptiBackup;
 s:string;
const
 Desc : Array[0..1] of string = ('','For files in project: ');
begin
 if BackupEnable.Checked then
  begin
   bk:=TOptiBackup.create;
   try
    if TControl(Sender).Tag=0
     then s:=backupname.Text
     else s:=BackupPrjName.Text;
    bk.SetBackupOpts(s,true,BackupZip.checked,ActiveScriptInfo);
    bk.Update(true,true);
    bakPreview.text:=Desc[TControl(Sender).Tag]+bk.getteststring;
   finally
    bk.free;
   end;
  end
 else
  BakPreview.Text:='';
end;

procedure TOptionForm.BackupEnableClick(Sender: TObject);
begin
 BackupName.Enabled:=BackupEnable.Checked;
 BackupPrjName.Enabled:=BackupEnable.Checked;
 BackupZip.Enabled:=BackupEnable.Checked;
end;

procedure TOptionForm.btnSuggestClick(Sender: TObject);
var
 i,itemindex,c:integer;
 h,s,l,tempS,tempL : Integer;
 Vals : Array of Integer;
begin
 itemindex:=Elements.ItemIndex;
 if (NowStyle=-1) or (itemindex=-1) then exit;

 with TempOptions.TS[NowStyle] do
 begin

  c:=0;
  TempS:=0; TempL:=0;
  for i:=low(data)+1 to high(data) do
   if (i<>itemindex) and (not data[i].HasBackGround) then
   begin
    inc(c);
    RGBToHSLRange(data[i].ForeColor,h,s,l);
    tempS:=tempS+s;
    TempL:=TempL+L;
    SetLength(Vals,c);
    vals[c-1]:=h;
   end;

  //Get average saturation and lum
  TempL:=TempL div c;
  TempS:=TempS div c;

  ISortA(vals,-1);
  s:=0;
  h:=-1;
  for i:=0 to length(vals)-2 do
  begin
   l:=vals[i+1]-vals[i];
   if l>s then
   begin
    h:=i;
    s:=l;
   end;
  end;

  if h>=0
   then h:=(vals[h+1]+vals[h]) div 2
   else h:=Random(240);

  data[Elements.ItemIndex].ForeColor:=HSLRangeToRGB(h,temps,templ);
 end;
 ElementsClick(nil);
end;

procedure TOptionForm.btnLightSatClick(Sender: TObject);
const
 Dif = 10;
var
 i:integer;
 h,s,l : Integer;
begin
 if (NowStyle=-1) or (Elements.itemindex=-1) then exit;
 with TempOptions.TS[NowStyle] do
  for i:=low(data) to high(data) do
   begin
    RGBToHSLRange(data[i].ForeColor,h,s,l);
    case TSpeedButton(sender).Tag of
     0 : l:=imid(l+dif,0,240);
     1 : l:=imid(l-dif,0,240);
     2 : s:=imid(s+dif,0,240);
     3 : s:=imid(s-dif,0,240);
    end;
    Data[i].ForeColor:=HSLRangeToRGB(h,s,l);

    if data[i].HasBackGround then
    begin
     RGBToHSLRange(data[i].BackColor,h,s,l);
     case TSpeedButton(sender).Tag of
      0 : l:=imid(l-dif,0,240);
      1 : l:=imid(l+dif,0,240);
      2 : s:=imid(s-dif,0,240);
      3 : s:=imid(s+dif,0,240);
     end;
     Data[i].BackColor:=HSLRangeToRGB(h,s,l);
    end;
   end;
 ElementsClick(nil);
end;

procedure TOptionForm.cbOneInstanceClick(Sender: TObject);
begin
 RegWriteBool(HKEY_LOCAL_MACHINE,OptiRegKey,OptiRegKey_OneInstance,cbOneInstance.checked);
end;

end.
