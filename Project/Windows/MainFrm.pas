unit MainFrm; //Modeless
{$I REG.INC}

interface
                                 
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  actnlist, ExtCtrls, AppEvnts, dxBar, ScktComp, dcstring, Buttons, SecEditFrm, HKVST,
  HKActions, StdCtrls, hakageneral, CentralImageListMdl, StrUtils, HKTransfer,
  editorfrm, ProjectFrm, ConfToolFrm, QueryFrm, HKDXBar, HKIniFiles, Variants, HKComboInputForm,
  OptOptions, HyperFrm, OptTest, OptProcs, UXTheme, OptMessage, OptQuery, HakaHyper,
  ScriptInfoUnit, OptGeneral, OptFolders, hakafile, agproputils, LibrarianFrm,
  dcmemo, aboutfrm, HKRegistry, OptControl, SplashFrm, DateUtils,
  OptAssociations, hakamessagebox, jclfileutils, hyperstr, HakaWin, ComObj,
  dxBarExtItems, WebBrowserFrm, ExplorerFrm, PodViewerFrm, HKDebug, UIThemed,
  {$IFDEF OLE}PlugMdl, PlugInFrm, PlugBase, PlugCommon, plugtypes, PerlAPI, {$ENDIF}
  ParsersMdl, SendMailFrm, edMagicMdl, HKWebBrowser, ImgList, HKGraphics, Themes,
  aqDockingBase, aqDocking, aqDockingUtils, aqDockingUI, uiHelpers, OptForm, BigWebFrm,
  JvPlacemnt, JvComponent, JvTrayIcon, JvBaseDlg, JvTipOfDay, FTPSelectFrm, //HakaArm,
  JvDataEmbedded;

type
  TOptiMainForm = class(TForm)
    TrayIcon: TJvTrayIcon;
    FormStorage: TjvFormStorage;
    BarManager: TdxBarManager;
    siFile: TdxBarSubItem;
    siEdit: TdxBarSubItem;
    siSearch: TdxBarSubItem;
    siProject: TdxBarSubItem;
    siDebug: TdxBarSubItem;
    siRun: TdxBarSubItem;
    siTools: TdxBarSubItem;
    siBrowser: TdxBarSubItem;
    siServer: TdxBarSubItem;
    siWindows: TdxBarSubItem;
    siHelp: TdxBarSubItem;
    siQuery: TdxBarSubItem;
    siNewFile: TdxBarSubItem;
    siRecentScripts: TdxBarSubItem;
    siRecentFiles: TdxBarSubItem;
    siViewAsLanguage: TdxBarSubItem;
    mruProject: TdxBarMRUListItem;
    siRecentProjects: TdxBarSubItem;
    siStartingPath: TdxBarSubItem;
    siRecentServerWebroots: TdxBarSubItem;
    siLayouts: TdxBarSubItem;
    bCloseAction: TdxBarButton;
    bCloseAllAction: TdxBarButton;
    bExportHTMLAction: TdxBarButton;
    bExportRTFAction: TdxBarButton;
    bNewAction: TdxBarButton;
    bNewHtmlFileAction: TdxBarButton;
    bNewTemplateAction: TdxBarButton;
    bOpenAction: TdxBarButton;
    bPrintAction: TdxBarButton;
    bSaveAction: TdxBarButton;
    bSaveAllAction: TdxBarButton;
    bSaveAsAction: TdxBarButton;
    bExitAction: TdxBarButton;
    bUnixFormatAction: TdxBarButton;
    mruRecentScripts: TdxBarMRUListItem;
    mruRecentFiles: TdxBarMRUListItem;
    bWindowsFormatAction: TdxBarButton;
    liOtherLanguages: TdxBarListItem;
    liDefaultLanguages: TdxBarListItem;
    bUndoAction: TdxBarButton;
    bRedoAction: TdxBarButton;
    bCutAction: TdxBarButton;
    bPasteAction: TdxBarButton;
    bDeleteAction: TdxBarButton;
    bSelectAllAction: TdxBarButton;
    bCommentInAction: TdxBarButton;
    bCommentOutAction: TdxBarButton;
    bCommentToggleAction: TdxBarButton;
    bShowTemplatesAction: TdxBarButton;
    bTemplateFormAction: TdxBarButton;
    bOpenTodoListAction: TdxBarButton;
    bNewEditWinAction: TdxBarButton;
    bSyncScrollAction: TdxBarButton;
    bOpenEditorAction: TdxBarButton;
    bEditorBigAction: TdxBarButton;
    bFindDeclarationAction: TdxBarButton;
    bIndentAction: TdxBarButton;
    bOutdentAction: TdxBarButton;
    bAboutAction: TdxBarButton;
    bPerlInfoAction: TdxBarButton;
    bCheckForUpdateAction: TdxBarButton;
    bShowHelpAction: TdxBarButton;
    bPerlDocAction: TdxBarButton;
    bForwardAction: TdxBarButton;
    bBackAction: TdxBarButton;
    bRefreshAction: TdxBarButton;
    bStopAction: TdxBarButton;
    bHaulBrowserAction: TdxBarButton;
    bOpenURLAction: TdxBarButton;
    bInternetOptionsAction: TdxBarButton;
    bOpenBrowserWindowAction: TdxBarButton;
    bScrollTabAction: TdxBarButton;
    bBrowserBigAction: TdxBarButton;
    bStartRemDebAction: TdxBarButton;
    bStopDebAction: TdxBarButton;
    bSingleStepAction: TdxBarButton;
    bStepOverAction: TdxBarButton;
    bReturnFromSubAction: TdxBarButton;
    bContinueAction: TdxBarButton;
    bListSubAction: TdxBarButton;
    bPackageVarsAction: TdxBarButton;
    bMethodsCallAction: TdxBarButton;
    bEvaluateVarAction: TdxBarButton;
    bToggleBreakAction: TdxBarButton;
    bOpenWatchesAction: TdxBarButton;
    bAutoEvaluationAction: TdxBarButton;
    bAddToWatchAction: TdxBarButton;
    bNewProjectAction: TdxBarButton;
    bOpenProjectAction: TdxBarButton;
    bSaveProjectAction: TdxBarButton;
    bSaveProjectAsAction: TdxBarButton;
    bAddCurrentToProjectAction: TdxBarButton;
    bRemoveFromProjectAction: TdxBarButton;
    bShowManagerAction: TdxBarButton;
    bSearchInProjectAction: TdxBarButton;
    bProjectOptionsAction: TdxBarButton;
    bPublishProjectAction: TdxBarButton;
    bFindAction: TdxBarButton;
    bSearchAgainAction: TdxBarButton;
    bReplaceAction: TdxBarButton;
    bGoToLineAction: TdxBarButton;
    bOpenCodeExplorerAction: TdxBarButton;
    bPatternSearchAction: TdxBarButton;
    bMatchBracketAction: TdxBarButton;
    bFindSubAction: TdxBarButton;
    bSwapVersionAction: TdxBarButton;
    bRunBrowserAction: TdxBarButton;
    bRunExtBrowserAction: TdxBarButton;
    bRunSecBrowserAction: TdxBarButton;
    bRunInConsoleAction: TdxBarButton;
    bOpenQueryEditorAction: TdxBarButton;
    bTestErrorAction: TdxBarButton;
    bTestErrorExpAction: TdxBarButton;
    bOptionsAction: TdxBarButton;
    bEditShortCutAction: TdxBarButton;
    bFileExplorerAction: TdxBarButton;
    bCodeLibAction: TdxBarButton;
    bPodExtractorAction: TdxBarButton;
    bURLEncodeAction: TdxBarButton;
    bPerlPrinterAction: TdxBarButton;
    bRegExpTesterAction: TdxBarButton;
    bRemoteSessionsAction: TdxBarButton;
    bPerlTidyAction: TdxBarButton;
    bFileCompareAction: TdxBarButton;
    bProfilerAction: TdxBarButton;
    bConfToolsAction: TdxBarButton;
    bInternalServerAction: TdxBarButton;
    bOpenErrorLogsAction: TdxBarButton;
    bOpenAccessLogsAction: TdxBarButton;
    bChangeRootAction: TdxBarButton;
    bRunWithServerAction: TdxBarButton;
    liRecentServerWebroots: TdxBarListItem;
    bSaveLayoutAction: TdxBarButton;
    bDeleteLayoutAction: TdxBarButton;
    liLayouts: TdxBarListItem;
    bCopyAction: TdxBarButton;
    bAddToProjectAction: TdxBarButton;
    liStartingPath: TdxBarListItem;
    bSameAsScriptPathAction: TdxBarButton;
    liOpenWindows: TdxBarListItem;
    siOpenWindows: TdxBarSubItem;
    bTog0BookmarkAction: TdxBarButton;
    bTog1BookmarkAction: TdxBarButton;
    bTog2BookmarkAction: TdxBarButton;
    bTog3BookmarkAction: TdxBarButton;
    bTog4BookmarkAction: TdxBarButton;
    bTog5BookmarkAction: TdxBarButton;
    bTog6BookmarkAction: TdxBarButton;
    bTog7BookmarkAction: TdxBarButton;
    bTog8BookmarkAction: TdxBarButton;
    bTog9BookmarkAction: TdxBarButton;
    bGoto0BookmarkAction: TdxBarButton;
    bGoto1BookmarkAction: TdxBarButton;
    bGoto2BookmarkAction: TdxBarButton;
    bGoto3BookmarkAction: TdxBarButton;
    bGoto4BookmarkAction: TdxBarButton;
    bGoto5BookmarkAction: TdxBarButton;
    bGoto6BookmarkAction: TdxBarButton;
    bGoto7BookmarkAction: TdxBarButton;
    bGoto8BookmarkAction: TdxBarButton;
    bGoto9BookmarkAction: TdxBarButton;
    siToggleBookmarks: TdxBarSubItem;
    siGotoBookmarks: TdxBarSubItem;
    bSearchDocsAction: TdxBarButton;
    siEditorPop: TdxBarSubItem;
    TrayPopup: TdxBarPopupMenu;
    bMacFormatAction: TdxBarButton;
    bSelectStartPathAction: TdxBarButton;
    siDefLanguages: TdxBarSubItem;
    siCustom3: TdxBarSubItem;
    siCustom1: TdxBarSubItem;
    siCustom2: TdxBarSubItem;
    bEnGetAction: TdxBarButton;
    bEnPostAction: TdxBarButton;
    bEnPathInfoAction: TdxBarButton;
    bEnCookieAction: TdxBarButton;
    bImportFileAction: TdxBarButton;
    bImportWebAction: TdxBarButton;
    bSaveShotAction: TdxBarButton;
    bDelShotAction: TdxBarButton;
    cbGet: TdxBarCombo;
    cbPost: TdxBarCombo;
    cbPathInfo: TdxBarCombo;
    cbCookie: TdxBarCombo;
    siArguments: TdxBarSubItem;
    cbArguments: TdxBarCombo;
    bCopyGetAction: TdxBarButton;
    bCopyPostAction: TdxBarButton;
    bCopyPathInfoAction: TdxBarButton;
    bPreviewAction: TdxBarButton;
    bOpenURLQueryAction: TdxBarButton;
    cbUrls: TdxBarCombo;
    bProxyEnableAction: TdxBarButton;
    siFavorites: TdxBarSubItem;
    bTextStyle1: TdxBarButton;
    bTextStyle2: TdxBarButton;
    bTextStyle3: TdxBarButton;
    bTextStyle4: TdxBarButton;
    bTextStyle5: TdxBarButton;
    siTextStyles: TdxBarSubItem;
    bOpenRemoteAction: TdxBarButton;
    bSaveRemoteAction: TdxBarButton;
    bSaveRemoteActionAs: TdxBarButton;
    memTimer: TTimer;
    bRemoteExplorerAction: TdxBarButton;
    bDelWordLeft: TdxBarButton;
    bDelWordRight: TdxBarButton;
    bExportCodeExplorerAction: TdxBarButton;
    bSendMailAction: TdxBarButton;
    bViewProjLogAction: TdxBarButton;
    bPublishAllAgainAction: TdxBarButton;
    bCodeCompAction: TdxBarButton;
    siTrayIconMenu: TdxBarSubItem;
    StandardGroup: TdxBarGroup;
    bCustToolsAction: TdxBarButton;
    bOpenZipAction: TdxBarButton;
    bLoadEditLayoutAction: TdxBarButton;
    siToolBars: TdxBarToolbarsListItem;
    siCustom4: TdxBarSubItem;
    siCustom5: TdxBarSubItem;
    siCustom6: TdxBarSubItem;
    bSubListAction: TdxBarButton;
    ApplicationEvents: TApplicationEvents;
    bApacheDocAction: TdxBarButton;
    bprRunInConsoleAction: TdxBarButton;
    siCustom7: TdxBarSubItem;
    siCustom8: TdxBarSubItem;
    siCustom9: TdxBarSubItem;
    siCustom10: TdxBarSubItem;
    siUserTools: TdxBarSubItem;
    siCVS: TdxBarSubItem;
    bImportFolderAction: TdxBarButton;
    bRemDebSetupAction: TdxBarButton;
    bOpenCacheAction: TdxBarButton;
    bSaveAllRemoteAction: TdxBarButton;
    bReloadRemoteAction: TdxBarButton;
    bToggleIMEAction: TdxBarButton;
    bReloadAction: TdxBarButton;
    bResetPermAction: TdxBarButton;
    bQuerySelectFileAction: TdxBarButton;
    DockingManager: TaqDockingManager;
    DockingSite: TaqDockingSite;
    dcEditorForm: TaqDockingControl;
    dcExplorerForm: TaqDockingControl;
    dcProjectForm: TaqDockingControl;
    StyleManager: TaqStyleManager;
    dcPerlInfoForm: TaqDockingControl;
    bOpenAutoViewAction: TdxBarButton;
    dcAutoViewForm: TaqDockingControl;
    dcWebBrowserForm: TaqDockingControl;
    dcPodViewerForm: TaqDockingControl;
    dcLibrarianForm0: TaqDockingControl;
    dcLibrarianForm1: TaqDockingControl;
    dcLibrarianForm2: TaqDockingControl;
    dcLibrarianForm3: TaqDockingControl;
    dcQueryForm: TaqDockingControl;
    dcFTPSelectForm: TaqDockingControl;
    dcURLEncodeForm: TaqDockingControl;
    dcFileExploreForm: TaqDockingControl;
    dcStatusForm: TaqDockingControl;
    dcListSubNames: TaqDockingControl;
    dcPackVariables: TaqDockingControl;
    dcMethodsCall: TaqDockingControl;
    dcWatchForm: TaqDockingControl;
    dcTodoForm: TaqDockingControl;
    dcErrorLogForm: TaqDockingControl;
    dcAccessLogForm: TaqDockingControl;
    dcFileCompareForm: TaqDockingControl;
    dcEvalExpForm: TaqDockingControl;
    dcPerlPrinterForm: TaqDockingControl;
    dcRegExpTesterForm: TaqDockingControl;
    dcRemoteDebForm: TaqDockingControl;
    TipDlg: TJvTipOfDay;
    bWinCascadeAction: TdxBarButton;
    bWinTileAction: TdxBarButton;
    bNextWindowAction: TdxBarButton;
    IconList: TImageList;
    RunImageList: TImageList;
    bProjOpenRemoteAction: TdxBarButton;
    bEditColorAction: TdxBarButton;
    DataEmbedded: TJvDataEmbedded;
    dcPlugIn_0: TaqDockingControl;
    dcPlugIn_1: TaqDockingControl;
    dcPlugIn_2: TaqDockingControl;
    dcPlugIn_3: TaqDockingControl;
    dcPlugIn_4: TaqDockingControl;
    dcPlugIn_5: TaqDockingControl;
    dcPlugIn_6: TaqDockingControl;
    dcPlugIn_7: TaqDockingControl;
    dcPlugIn_8: TaqDockingControl;
    dcPlugIn_9: TaqDockingControl;
    bUpdatePluginAction: TdxBarButton;
    siPlugins: TdxBarSubItem;
    liPlugWins: TdxBarListItem;
    bDelCharLeftAction: TdxBarButton;
    bDelCharRightAction: TdxBarButton;
    bDelCharRightVIAction: TdxBarButton;
    bDelWholeLineAction: TdxBarButton;
    bDeleteLineBreakAction: TdxBarButton;
    bInsertNewLineAction: TdxBarButton;
    bDuplicateLineActon: TdxBarButton;
    bSelectLineAction: TdxBarButton;
    bDeleteToEOLAction: TdxBarButton;
    bDeleteToStartAction: TdxBarButton;
    bDeleteWordAction: TdxBarButton;
    bToggleSelOptionAction: TdxBarButton;
    dcSecEditForm0: TaqDockingControl;
    dcSecEditForm1: TaqDockingControl;
    dcSecEditForm2: TaqDockingControl;
    dcSecEditForm3: TaqDockingControl;
    bAutoSynCheckAction: TdxBarButton;
    bAutoSynCheckStrippedAction: TdxBarButton;
    bMatchBracketSelectAction: TdxBarButton;
    bCallStackAction: TdxBarButton;
    dcCallStack: TaqDockingControl;
    liHighlights: TdxBarListItem;
    siHighlights: TdxBarSubItem;
    bBrowseBackAction: TdxBarButton;
    bClearHighlightsAction: TdxBarButton;
    bIncExtVariablesAction: TdxBarButton;
    liOpenFiles: TdxBarListItem;
    siTabPop: TdxBarSubItem;
    siOpenFiles: TdxBarSubItem;
    bHighDeclarationAction: TdxBarButton;
    bBreakConditionAction: TdxBarButton;
    bPrevSearchAction: TdxBarButton;
    bNextSearchAction: TdxBarButton;
    bSearchNextAction: TdxBarButton;
    liServerStatus: TdxBarListItem;
    bGoto0GlobalAction: TdxBarButton;
    bGoto1GlobalAction: TdxBarButton;
    bGoto2GlobalAction: TdxBarButton;
    bGoto3GlobalAction: TdxBarButton;
    bGoto4GlobalAction: TdxBarButton;
    bGoto5GlobalAction: TdxBarButton;
    bGoto6GlobalAction: TdxBarButton;
    bGoto7GlobalAction: TdxBarButton;
    bGoto8GlobalAction: TdxBarButton;
    bGoto9GlobalAction: TdxBarButton;
    bRedOutputAction: TdxBarButton;
    bActiveScriptDebAction: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrayIconClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BarDockControlResize(Sender: TObject);
    procedure BarManagerDocking(Sender: TdxBar; Style: TdxBarDockingStyle;
      DockControl: TdxDockControl; var CanDocking: Boolean);
    procedure mruRecentScriptsGetData(Sender: TObject);
    procedure mruRecentFilesGetData(Sender: TObject);
    procedure mruRecentScriptsClick(Sender: TObject);
    procedure mruProjectGetData(Sender: TObject);
    procedure mruProjectClick(Sender: TObject);
    procedure liLanguagesClick(Sender: TObject);
    procedure liStartingPathGetData(Sender: TObject);
    procedure liStartingPathClick(Sender: TObject);
    procedure liRecentServerWebrootsGetData(Sender: TObject);
    procedure liRecentServerWebrootsClick(Sender: TObject);
    procedure liLayoutsGetData(Sender: TObject);
    procedure liLayoutsClick(Sender: TObject);
    procedure liWindowsClick(Sender: TObject);
    procedure liOpenWindowsGetData(Sender: TObject);
    procedure liDefaultLanguagesGetData(Sender: TObject);
    procedure liOtherLanguagesGetData(Sender: TObject);
    procedure BarManagerBarAfterReset(Sender: TdxBarManager; ABar: TdxBar);
    procedure cbArgumentsChange(Sender: TObject);
    procedure cbGetDropDown(Sender: TObject);
    procedure cbPostDropDown(Sender: TObject);
    procedure cbPathInfoDropDown(Sender: TObject);
    procedure cbCookieDropDown(Sender: TObject);
    procedure cbArgumentsDropDown(Sender: TObject);
    procedure cbGetCurChange(Sender: TObject);
    procedure cbPostCurChange(Sender: TObject);
    procedure cbPathInfoCurChange(Sender: TObject);
    procedure cbCookieCurChange(Sender: TObject);
    procedure cbBoxCloseUp(Sender: TObject);
    procedure memTimerTimer(Sender: TObject);
    procedure siHelpClick(Sender: TObject);
    procedure BarManagerBarVisibleChange(Sender: TdxBarManager;
      ABar: TdxBar);
    procedure cbKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApplicationEventsDeactivate(Sender: TObject);
    procedure ApplicationEventsActivate(Sender: TObject);
    procedure BarManagerHideCustomizingForm(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DockingManagerRegister(Sender: TaqCustomDockingManager;
      Control: TaqCustomDockingControl);
    procedure ApplicationEventsSettingChange(Sender: TObject;
      Flag: Integer; const Section: string; var Result: Integer);
    procedure dcEditorFormShow(Sender: TObject);
    procedure DockingManagerPopupMenuCreate(
      Sender: TaqCustomDockingManager; Control: TaqCustomDockingControl;
      AMenu: TaqDockMenu; Flags: Cardinal);
    procedure DockingManagerUpdateActions(Sender: TaqCustomDockingManager;
      Control: TaqCustomDockingControl);
    procedure BarManagerClickItem(Sender: TdxBarManager;
      ClickedItem: TdxBarItem);
    procedure BarManagerShowCustomizingForm(Sender: TObject);
    procedure liPlugWinsGetData(Sender: TObject);
    procedure liPlugWinsClick(Sender: TObject);
    procedure liHighlightsGetData(Sender: TObject);
    procedure liHighlightsClick(Sender: TObject);
    procedure liOpenFilesGetData(Sender: TObject);
    procedure liOpenFilesClick(Sender: TObject);
    procedure liServerStatusGetData(Sender: TObject);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
  public
    WindowList: TStringList;
    PlugWindows: array of TaqCustomDockingControl;
    procedure SaveLayout(const Name: string);
    procedure UpdateHeight;
  protected
    procedure _LoadLayout(const Name: string);
    procedure _SetTitle;
    procedure _OptionsUpdated(Level: Integer);
    procedure _HandleActiveURL(const data: string);
    procedure _ArrangeWindows(How: Integer);
    function _IsBigWinNormal(Int: Integer): Boolean;
    procedure _DoBigWinNormal(Int: Integer);
    procedure _DoNextWin;
    procedure _ShowWebs(bool: BOolean);
    procedure _terminating;
    procedure _DrawSplitter(sender: TObject);
    procedure _ToolsUpdating(Start, OnlyImages: Boolean);
    procedure _UpdatePlugIns;
    procedure _AddButtonLinkFromString(const Str: string; ABtn: TObject);
    function _ActiveURL: string;
    procedure _ActiveScriptAndQueryChanged;
    function _GetActiveServer: integer;

    procedure CMShowingChanged(var Message: TMessage); message CM_SHOWINGCHANGED;
    procedure DoDockingEvent(var Msg: TMessage); message HK_DockingEvent;
    procedure FocusBarForm(var Msg: TMessage); message WM_USER + 1;
    procedure FavoriteUpdateMessage(var Msg: TMessage); message WM_USER + 2;
    procedure LayoutClickMessage(var Msg: TMessage); message WM_USER + 3;
    procedure ForceTerminate(var Msg: TMessage); message WM_USER + 5;
    procedure SendMailMessage(var Msg: TMessage); message HK_SendMail;
    procedure HKLoadFile(var Msg: TMessage); message HK_LoadFile;

    procedure WMDoTerminated(var msg: TMessage); message HK_P_Terminate;
    procedure OnQUERYENDSESSION(var msg: TWMQUERYENDSESSION); message WM_QUERYENDSESSION;
//    procedure CreateParams(var Params: TCreateParams); override;
//    procedure WMSyscommand(var Message: TWmSysCommand); message WM_SYSCOMMAND;
  private
    LastMax: Integer;
    IsQUERYENDSESSION: Boolean;
    OldWndProc, NewWndProc: TFarProc;
    ThemedSplitters: Boolean;
    OldHeap: THeapStatus;
    OrgShowTaskBar: Boolean;
    DidShow: boolean;
    NextBigUpdateHeight: Integer;
    DockControlTop, DockControlBottom: TDxDockControl;
    BigWins: array[0..1] of TaqDockingControl;
    ScanFolder: TDxScanFolder;
{$IFDEF EXPIREBYMINUTES}
    ExpireTime: TDateTime;
{$ENDIF}
    procedure OnFavoriteClick(Sender: TObject);
    procedure dcWindowCreate(Sender: TObject);
    procedure firstActivate;
    procedure UpdateTools(Domm, DoToolbar: Boolean);
    procedure ProcessQueryDropDown(cb: TdxBarCombo; Method: TQueryTypes);
    function BeforeActionEvent(Sender: TObject): Boolean;
    procedure AfterActionEvent(Sender: TObject);
    procedure CustomActionHandler(Sender: TObject);

    procedure OnDockTabChange(Sender: TaqCustomDockingControl; Before: Boolean);
    procedure OnDockEvent(Sender: TaqCustomDockingControl; Before: Boolean);
    procedure OnControlClose(Sender: TaqCustomDockingControl; Before: Boolean);
    procedure OnFloatingContainerClose(Sender: TaqCustomDockingControl; Before: Boolean);
    procedure DoWebShow(Show: Boolean);
    procedure DoFloatingContainerClose(Sender: TaqCustomDockingControl);
    procedure UpdateAllMenus;
    function CalcGoodHeight: Integer;
    function OnUpdateMover(Sender: TaqCustomMover; Coords: TPoint): TaqCustomDockingControl;
    procedure UpdateAllVisible;
    procedure UpdateAllNonVisible;
    procedure MenuItemToggleMenu(Sender: TObject);
    function DockTabClick(Sender: TaqCustomDockingControl; Shift: TShiftState): Boolean;
    procedure ClickHideInsideContainder(Sender: TObject);
    procedure ClickUndockInsideContainder(Sender: TObject);
    procedure MakeWinList(List: TList);
    procedure MakeIconList;
    procedure DefLayout;
    function GetPlugNum(aq: TaqCustomDockingControl): Integer;
    procedure AddButtonLinkFromString(const Str: string; Btn: TdxBarButton; BarMan: TdxBarManager);
    procedure RemoveUnusedAfterLoad;
    procedure MainWndProc(var Message: TMessage);
    procedure CheckForEmpty;
  end;

var
  OptiMainForm: TOptiMainForm;

implementation
{$R *.DFM}
{$R Icons.RES}
{$R Manifest.asInvoker.RES}

{.$R Test.RES}

const
  ToggleMenuActionID = 100;

  dumb = '';
//+'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
//+'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
//+'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';

var
  CBT_Hook: HHook = 0;
  MainFormHandle: THandle = 0;
  ApplicationHandle: THandle = 0;

procedure TOptiMainForm.MainWndProc(var Message: TMessage);
begin
  with Message do
    Result := CallWindowProc(OldWndProc, ClientHandle, Msg, wParam, lParam);
{  if (OrgShowTaskBar) and
    (message.Msg=WM_ACTIVATEAPP) and
    (not TWMActivateApp(Message).Active) and
    (isWindowEnabled(MainFormHandle)) then
  SetActiveWindow(handle);}
end;

function CBTProc(Code: Integer; wParam: WParam; lParam: LParam): LRESULT; stdcall;
var
  act: CBTACTIVATESTRUCT absolute LParam;
  i: integer;
{$IFDEF DEVELOP}
  p: PChar;
{$ENDIF}
begin
  if (code = HCBT_ACTIVATE) then
  begin
  //xxx
    if (wparam <> MainFormHandle) and (wparam <> ApplicationHandle) and
      (not isWindowEnabled(MainFormHandle)) then
    begin
{$IFDEF DEVELOP}
      p := StrAlloc(100);
      GetWindowText(WParam, p, 100);
      assert(false, 'LOG Activated: ' + p);
{$ENDIF}

      if isWindowEnabled(WParam) then
      begin
        SetWindowPos(WParam, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
        for i := 0 to screen.CustomFormCount - 1 do
          if TForm(screen.CustomForms[i]).FormStyle = fsStayOnTop then
            SetWindowPos(screen.CustomForms[i].Handle, WParam, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
      end
      else
      begin
        result := 1;
        exit;
      end;
    end;
  //xxx
    if (GrabbedHandle <> 0) and (act.fMouse) and (not isWindowEnabled(WParam)) then
    begin
      SetActiveWindow(GrabbedHandle);
      SetWindowPos(GrabbedHandle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
    end

  end;
  Result := CallNextHookEx(CBT_Hook, Code, wParam, lParam);
end;

procedure TOptiMainForm.CMShowingChanged(var Message: TMessage);
begin
  HKLOG('FA 10');
  inherited;
  if DidShow then exit;
  DidShow := true;
  HKLOG('FA 11');

  if (Options.ShowTipsStartup) and (not options.runtest) and (not options.cbttest) then
  begin
    if TipDlg.Tips.Count = 0 then
      MessageDlg('Could not find the Tips.txt file. Please re-install.', mtError, [mbOK], 0)
    else
    begin
      TipDlg.Options := [toShowOnStartUp];
      TipDlg.Execute;
      Options.showtipsStartup := toShowOnStartUp in TipDlg.Options;
      TipDlg.Options := [];
    end;
  end;
  HKLOG('FA 12');
end;

procedure TOptiMainForm.firstActivate;
var
  i: integer;
begin
  if paramstr(1) = '/e2' then exit;

  if fileexists(options.lastopenproject) then
    projectform.FMH.OpenFile(options.lastopenproject);

  for i := dockingmanager.Items.Count - 1 downto 0 do
    if dockingmanager.Items[i].tag <> 0 then
      with TOptiform(dockingmanager.Items[i].tag) do
        if assigned(BarMan) then
        begin
          barman.LockUpdate := true;
          barman.LockUpdate := false;
        end;
  QueryForm.PageControlChange(nil);

  if EditorForm.MFH.FileList.Count = 0 then
    EditorForm.Startup(false);
  EditorForm.UpdateCaption;

 // add project manager menu bar
  ProjectForm.siMain.itemlinks := siProject.ItemLinks;
  with projectform.BarManager.Bars[0].ItemLinks do
  begin
    with add do
    begin
      Item := bNewProjectAction;
      begingroup := true;
    end;
    add.Item := bOpenProjectAction;
    add.Item := siRecentProjects;
    add.Item := bSaveProjectAction;
    with add do
    begin
      item := bAddCurrentToProjectAction;
      begingroup := true;
    end;
    add.Item := bRemoveFromProjectAction;
    with add do
    begin
      item := bAddToProjectAction;
      begingroup := true;
    end;
    with add do
    begin
      item := bSearchInProjectAction;
      begingroup := true;
    end;
    add.Item := bProjectOptionsAction;
    with add do
    begin
      item := bPublishProjectAction;
      begingroup := true;
    end;
  end;
  projectform.UpdateMenu;

 //update web browser
  Pr_ShowWebs(false);
  Pr_ShowWebs(true);
  with WebBrowserForm do
  begin
    PageControl.SelectNextPage(true);
    PageControl.SelectNextPage(false);
  end;

{$IFDEF SPLASHFORM}
  SplashForm.Close;
{$ENDIF}

 // Check Associations
  if (ShouldCheckAssocs(RegSoftKey) and (not CheckOptiAssociations)) and
    (not Options.RunTest)
    then
  begin
    if not IsAdmin then
      MessageDlgMemo('OptiPerl is not associated with perl' + #39 + 's file types.' + #13 + #10 + 'Please contact an administrator to fix this problem.', mtWarning, [mbOK], 0, 1600)
    else
    begin
      if MessageDlg('OptiPerl is not associated with perl' + #39 + 's file types.' + #13 + #10 + 'Would you like to associate now?' + #13 + #10 + '' + #13 + #10 + 'To turn-off automatic checking, please go to the options dialog.', mtConfirmation, [mbYes, mbCancel], 0) = mrYes
        then begin
        AddPerlAssociations;
        AddOptiAssociations;
      end;
    end;
  end;

  //if (not Admin) and (not options.RunTest) then
  //  MessageDlgmemo('Since OptiPerl is being used in a multiuser environment,' + #13 + #10 + 'please make sure that you have read and write privileges' + #13 + #10 + 'for the folders and files you will use.' + #13 + #10 + '' + #13 + #10 + 'Some functions of OptiPerl will not behave correctly' + #13 + #10 + 'if the files you are editing are in a read only folder.', mtInformation, [mbOK], 0, 1800);

{$IFDEF UNREG}
{$IFNDEF DEBUG}
  if (not options.RunTest) and (not options.cbttest) then
    OpenModalForm(TAboutForm);
{$ENDIF}
{$ENDIF}

  HKLOG('FA 1');
  TerminateChecking := false;

  HKLOG('FA 2');
  PR_UpdateCodeExplorer;
  HKLOG('FA 3');
  HKActions.GlobalBeforeActionEvent := BeforeActionEvent;
  HKActions.GlobalAfterActionEvent := AfterActionEvent;

  HKLOG('FA 4');
  PlugMod.StartupPlugins;
  HKLOG('FA 5');

  if options.RunTest then
    OptTest.TTRunTest;
  if options.CBTTest then
    OptTest.TTLoadTestLayout;
  if options.MemTrace then
    OldHeap := GetHeapStatus;
end;

procedure TOptiMainForm.FormCreate(Sender: TObject);
var
  s: string;
  i, c: integer;
begin
  if paramstr(1) = '/e1' then exit;
  MainFormHandle := handle;

  OldWndProc := Pointer(GetWindowLong(application.Handle, GWL_WNDPROC));
  NewWndProc := MakeObjectInstance(MainWndProc);
  SetWindowLong(application.Handle, GWL_WNDPROC, Integer(NewWndProc));

  Pr_LoadLayout := _LoadLayout;
  Pr_ArrangeWindows := _ArrangeWindows;
  Pr_SetTitle := _SetTitle;
  PR_GetActiveServer := _GetActiveServer;
  Pr_IsBigWinNormal := _IsBigWinNormal;
  Pr_DoBigWinNormal := _DoBigWinNormal;
  Pr_DoNextWin := _DoNextWin;
  PR_ShowWebs := _ShowWebs;
  pr_DrawSplitter := _DrawSplitter;
  PR_ToolsUpdating := _ToolsUpdating;
  PR_UpdatePlugIns := _UpdatePlugIns;
  PC_ActiveScriptAndQueryChanged := _ActiveScriptAndQueryChanged;
  PR_HandleActiveURL := _HandleActiveURL;
  PR_ActiveURL := _ActiveURL;
  PC_MainForm_OptionsUpdated := _OptionsUpdated;
  PC_MainForm_Terminating := _Terminating;
  PR_AddButtonLinkFromString := _AddButtonLinkFromString;

{$IFNDEF OLE}
  siPlugINs.Free;
  bUpdatePluginAction.free;
  with BarManager.Categories do
    Delete(IndexOf('Plug-Ins'));
{$ELSE}
  with dockingmanager.Items do
    for i := 0 to Count - 1 do
    begin
      c := GetPlugNum(items[i]);
      if c >= 0 then
      begin
        if length(PlugWindows) <= c then
          setlength(PlugWindows, c + 1);
        PlugWindows[c] := items[i];
      end;
    end;
{$ENDIF}

  BigWins[0] := dcEditorForm;
  BigWins[1] := dcWebBrowserForm;

  OptForm.IniFileName := folders.UserFolder + 'Windows.ini';
  OptForm.DockingManager := DockingManager;
  OptForm.BarManager := BarManager;

{$IFDEF OLE}
  Plugmdl.PlugCat := BarManager.Categories.IndexOf('Plug-Ins');
  Plugmdl.PlugInMenu := siPlugIns;
  PlugMdl.PlugInButton := bUpdatePluginAction;
  PlugMdl.MainBarMan := BarManager;
{$ENDIF}

  OptForm.stanDocks[doNone] := nil;
  OptForm.stanDocks[doEditor] := dcEditorForm;
  OptForm.stanDocks[doWebbrowser] := dcWebBrowserForm;
  OptForm.stanDocks[doCodeExplorer] := dcExplorerForm;

  MainWebForm := TBigWebForm.create(Application);
  PodWebForm := TBigWebForm.create(Application);
  WindowList := TStringList.Create;
  WindowList.Sorted := true;
  WindowList.CaseSensitive := false;

  StyleManager.Items.StyleByName['Gradient'].splitterwidth := OptiSplitterWidth;
  StyleManager.Items.StyleByName['Themed'].splitterwidth := OptiSplitterWidth;
  StyleManager.Items.StyleByName['Gradient'].splitterwidth := OptiSplitterWidth;
  StyleManager.Items.StyleByName['Gradient'].splitterheight := OptiSplitterWidth;
  StyleManager.Items.StyleByName['Themed'].splitterheight := OptiSplitterWidth;
  StyleManager.Items.StyleByName['Gradient'].splitterheight := OptiSplitterWidth;

  DockingManager.OnDoDock := OnDockEvent;
  DockingManager.OnTabChanged := OnDockTabChange;
  DockingManager.OnContainerFloat := OnDockEvent;
  DockingManager.OnFloatSetParams := OnDockEvent;
  DockingManager.OnContainerClose := OnFloatingContainerClose;
  DockingManager.OnDockContainerClose := OnDockEvent;
  DockingManager.OnMoverEvent := OnUpdateMover;
  DockingManager.OnControlClose := OnControlClose;
  DockingManager.ontabclick := DockTabClick;
  OrgShowTaskBar := options.DockShowTaskBar;
  aqDockingBase.AddTaskBarButton := OrgShowTaskBar;

  DockingManager.Style := StyleManager.Items.Items[options.dockingstyle];
  TaqThemedUIStyle(StyleManager.Items.Items[1]).CaptionButtons.CustomButton.partIndex := bwSpinRight;

  if not DirectoryExists(Options.DefaultHTMLFolder) then
    Options.DefaultHtmlFolder := Programpath + 'webroot\';

  if not DirectoryExists(Options.DefaultScriptFolder) then
    OPtions.DefaultScriptFolder := OPtions.DefaultHtmlFolder + 'cgi-bin\';

  s := programPath + 'Tips.txt';
  if FileExists(s) then
    TipDlg.Tips.LoadFromFile(s);

  if not Options.MemTrace
    then memTimer.Free
  else MemTimer.Enabled := true;

  Application.HelpFile := ProgramPath + 'OptiPerl.chm';

  Top := 0;
  Left := 0;
  Width := Screen.Width;
  NextBigUpdateHeight := -1;

  with barmanager do
    for i := 0 to DockControlCount - 1 do
      with DockControls[i] do
      begin
        if (Name = '') and (DockingStyle = dsBottom) then
          DockControlBottom := DockControls[i];
        if (Name = '') and (DockingStyle = dsTop) then
          DockControlTop := DockControls[i];
      end;

  Caption := 'OptiPerl ' + OptiVersion;

  if paramstr(1) <> '/e5' then
  try
    CBT_Hook := setWindowsHookEx(WH_CBT, CBTProc, 0, GetCurrentThreadID);
  except
    CBT_Hook := 0;
  end;

  Left := screen.DesktopLeft - Width - 20;
end;

procedure TOptiMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  assert(false, 'LOG Mainform request for close');
  canclose := false;
  if ExplorerUpdating then exit;

  ThreadEnterSafeCS;
  TerminateChecking := true;
  EdMagicMod.SetVals(false);
  ThreadLeaveSafeCS;

  if PlugMod.OnCanTerminate then
    if ProjectForm.CanCloseProject then
      if EditorForm.CanCloseEditor then
        canclose := true;

  assert(false, 'LOG Mainform Request for Terminate');

  if canclose then
  begin
{$IFDEF UNREG}
    if (GetModalForm = nil) and (RegDaysInstalled >= 10) then
{
OptiPerl is not free! Register now and:

- Enable editing, debugging and running of unlimited sized scripts.
- Receive with priority technical support on OptiPerl.
- Receive full searchable documentation including a huge amount of Perl modules and Apache.
- Download free all future upgrades.

Thank you for evaluating OptiPerl!
}
      MessageDlgButtonTimer('OptiPerl is not free! Register now and:' + #13 + #10 + '' + #13 + #10 + '- Enable editing, debugging and running of unlimited ' + #13 + #10 + 'sized scripts.' + #13 + #10 + '- Receive with priority technical support on OptiPerl.' + #13 + #10 + '- Receive full searchable documentation including a huge ' + #13 + #10 + 'amount of Perl modules and Apache.' + #13 + #10 + '- Download free all future upgrades.' + #13 + #10 + '' + #13 + #10 + 'Thank you for evaluating OptiPerl!',
        mtInformation, [mbOK], 0, 5000);
{$ENDIF}

{$IFDEF OLE}
    PlugMod.TerminateAll;
{$ENDIF}
    HKActions.GlobalBeforeActionEvent := nil;
    ApplicationEvents.OnDeactivate := nil;
    ApplicationEvents.OnActivate := nil;
    Screen.OnActiveControlChange := nil;
    Screen.OnActiveFormChange := nil;
    DockingManager.OnDockContainerClose := nil;
    DoWebShow(false);
    PC_Terminating;

    if dcFileExploreForm.tag <> 0 then
   // For some reason this needs to be done, or else problems occur
    begin
      dcFileExploreForm.RemoveFromDocking(true);
      Application.ProcessMessages;
    end;

    dcWebBrowserForm.RemoveFromDocking(true);
   // For some reason this needs to be done also, because an error occurs
   // when teminating and the user had used halt browser

    DockingManager.OnDoDock := nil;

    if IsQUERYENDSESSION then
    begin
      OnCloseQuery := nil;
      Close;
    end;

  end
  else
  begin
    TerminateChecking := false;
    EdMagicMod.SetVals(true);
  end;
end;

procedure TOptiMainForm._SetTitle;
var s: string;
begin
  s := OptiTitleName;
  if length(OptiTitleProject) > 0 then
    s := s + ' - ' + OptiTitleProject;
  application.Title := s;
  if (length(OptiTitleFile) > 0) then
    s := s + ' - ' + OptiTitleFile;
  Caption := s;
end;

procedure TOptiMainForm._OptionsUpdated(Level: Integer);
begin
  TrayIcon.active := options.TrayBarIcon;
  DockingManager.Style := StyleManager.Items.Items[options.dockingstyle];
  ThemedSplitters := (options.dockingstyle = 1) and (themeServices.ThemesEnabled);
  aqDockingBase.InvertControlButton := options.DockInvertCtrl;
  StyleManager.Items.Items[0].CaptionButtonSize := options.DockCapHeight;
  StyleManager.Items.Items[1].CaptionButtonSize := options.DockCapHeight;
  StyleManager.Items.Items[2].CaptionButtonSize := options.DockCapHeight;
  MakeIconList;
  if options.DockShowButtons
    then
    DockingManager.CaptionButtons := [dbiHide, dbiUndock, dbiMaximizeRestore, dbiCustom]
  else
    DockingManager.CaptionButtons := [];

  if not options.StandardLayouts then
  begin
    BarManager.BarByName('Layout').Visible := false;
    Updateheight;
  end;
end;

procedure TOptiMainForm._ActiveScriptAndQueryChanged;
var
  si: TScriptInfo;
begin
  si := ActiveScriptInfo;
  cbGet.Text := si.Query.Activequery[qmGet];
  cbPost.Text := si.Query.Activequery[qmPost];
  cbArguments.Text := si.Query.Activequery[qmCMDLine];
  cbCookie.Text := si.Query.Activequery[qmCookie];
  cbPathInfo.Text := si.Query.Activequery[qmPathInfo];
end;

procedure TOptiMainForm.ForceTerminate(var Msg: TMessage);
begin
  repeat
    Close
  until TerminateChecking;
end;

procedure TOptiMainForm._terminating;
var i: integer;
begin
  for i := barmanager.Bars.Count - 1 downto 0 do
    if StrToIntDef(barmanager.Bars.Items[i].Name, -1) > 0 then
      barmanager.Bars.Delete(i);
  BarManager.savetoiniFile(folders.BarLayout);
  SaveLayout(OptiLastLayout);
end;

procedure TOptiMainForm._HandleActiveURL(const data: string);
begin
  SmartStringsAdd(cbURLS.Items, Data);
end;

procedure TOptiMainForm.BarManagerBarAfterReset(Sender: TdxBarManager;
  ABar: TdxBar);
begin
  if (Abar.Name = 'Main menu') then
    UpdateTools(true, false)
  else
    if (ABar.name = 'User tools') then
      UpdateTools(false, true);
end;

procedure TOptiMainForm.UpdateTools(Domm, DoToolbar: Boolean);
var
  i, c: integer;
  isNew: Boolean;
  btn: TdxBarButton;
  bar: TDXBar;
  Action: TAction;
  list: TList;
begin
  c := BarManager.Categories.IndexOf('User tools');
  bar := barmanager.BarByName('User tools');
  with ConfToolForm.ToolsList do
  begin

    for i := 0 to ActionCount - 1 do
    begin
      Action := TAction(Actions[i]);
      btn := TdxBarButton(BarManager.GetItemByName(Action.Name));
      if assigned(btn) then
      begin
        isNew := false;
        if (not doMM) and (not doToolbar) then continue;
      end
      else
      begin
        btn := TdxBarButton.Create(self);
        btn.Name := Action.name;
        btn.Action := actions[i];
        btn.Category := c;
        IsNew := true;
      end;

      if (DoMM) or (isNew) then
      begin
        if (StringStartsWithCase(ToolHeader + 'CVS_', btn.Name)) and
          (not sicvs.ItemLinks.HasItem(btn))
          then siCVS.ItemLinks.add.item := btn

        else
          if (not siUserTools.ItemLinks.HasItem(btn)) then
            siUserTools.ItemLinks.add.item := btn;
      end;

      if (DoToolbar) or (isNew) then
      begin
        if assigned(bar) and (not bar.ItemLinks.HasItem(btn)) and
          (bar.ItemLinks.Count < 10) then
          with bar, itemlinks do
          begin
            lockupdate := true;
            with add do
            begin
              item := btn;
              index := bar.ItemLinks.Count - 1;
              BringToTopInRecentList(true);
            end;
            lockupdate := false;
          end;
      end;

    end;

  //delete old items
    list := TList.Create;
    BarManager.GetAllItemsByCategory(c, list);
    i := list.IndexOf(bConfToolsAction);
    if i >= 0 then list.Delete(i);
    for i := 0 to list.Count - 1 do
    begin
      btn := TdxBarButton(list.Items[i]);
      Action := TAction(btn.Action);
      if ConfToolForm.getActionIndex(Action) < 0 then
        btn.free;
    end;

  end; //with
end;

procedure TOptiMainForm.TrayIconClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not IsWindowEnabled(application.MainForm.Handle) then
    exit;
  if button = mbLeft then
  begin
    Application.ProcessMessages;
    SetForegroundWindow(self.Handle);
    Application.ProcessMessages;
    Application.Restore;
    try
      TrayPopup.ItemLinks := siTrayIconMenu.ItemLinks;
      TrayPopup.PopupFromCursorPos;
    except end;
  end;
  if button = mbRight then
  begin
    Application.ProcessMessages;
    SetForegroundWindow(self.Handle);
    Application.ProcessMessages;
    Application.Restore;
  end;
end;

procedure TOptiMainForm.FormDestroy(Sender: TObject);
begin
 {there was once a problem here when the barmanager
  destroyed liOpenWindows - the program just waited forever.
  Seemed to be solved by changing the position of liOpenWindows
  in the windows category of barmanager}
  SetWindowLong(application.Handle, GWL_WNDPROC, Integer(OldWndProc));
  if CBT_Hook <> 0 then
    Unhookwindowshookex(CBT_Hook);
  ScanFolder.free;
  WindowList.free;
  assert(false, 'LOG Mainform Destroy');
end;

procedure TOptiMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #27) and (enabled) then
    PR_FocusEditor;
end;

procedure TOptiMainForm.BarDockControlResize(Sender: TObject);
begin
  Updateheight;
end;

procedure TOptiMainForm.BarManagerDocking(Sender: TdxBar;
  Style: TdxBarDockingStyle; DockControl: TdxDockControl;
  var CanDocking: Boolean);
begin
  Updateheight;
end;

procedure TOptiMainForm.mruRecentScriptsGetData(Sender: TObject);
var
  i: integer;
begin
  mruRecentScripts.Items.Clear;

  with EditorForm.MFH.mrulist do
    for i := 0 to Count - 1 do
      if scanf(ExtractFileExt(strings[i]), 'h', -1) = 0
        then mruRecentScripts.Items.Add(strings[i]);
end;

procedure TOptiMainForm.mruRecentFilesGetData(Sender: TObject);
var
  i: integer;
begin
  mruRecentFiles.Items.Clear;
  with EditorForm.MFH.mrulist do
    for i := 0 to Count - 1 do
      if scanf(ExtractFileExt(strings[i]), 'h', -1) <> 0
        then mruRecentFiles.Items.Add(strings[i]);
end;

procedure TOptiMainForm.mruRecentScriptsClick(Sender: TObject);
begin
  with Sender as TdxBarMRUListItem do
    EditorForm.MFH.OpenFile(items[itemindex]);
end;

procedure TOptiMainForm.mruProjectGetData(Sender: TObject);
var
  i: integer;
begin
  mruProject.Items.Clear;
  with ProjectForm.FMH.Recent do
    for i := 0 to Count - 1 do
      mruProject.Items.Add(strings[i]);
end;

procedure TOptiMainForm.mruProjectClick(Sender: TObject);
begin
  if assigned(PR_SaveAllInfos) then
    PR_SaveAllInfos;
  with Sender as TdxBarMRUListItem do
    ProjectForm.FMH.OpenFile(items[itemindex]);
end;

procedure TOptiMainForm.liLanguagesClick(Sender: TObject);
begin
  with Sender as TdxBarListItem do
    editorForm.SetParserActive(items.Objects[itemindex]);
end;

procedure TOptiMainForm.liStartingPathGetData(Sender: TObject);
begin
  with LiStartingPath do
  begin
    Items.Text := options.StartPathList;
    if options.StartPath <> ''
      then itemindex := Items.IndexOf(options.StartPath)
    else ItemIndex := -1;
  end;
end;

procedure TOptiMainForm.liStartingPathClick(Sender: TObject);
begin
  with LiStartingPath do
    options.StartPath := items[itemindex]
end;

procedure TOptiMainForm.liRecentServerWebrootsGetData(Sender: TObject);
begin
  with liRecentServerWebroots do
  begin
    Items.text := Options.RootDirList;
    itemindex := items.IndexOf(options.RootDir);
  end;
end;

procedure TOptiMainForm.liRecentServerWebrootsClick(Sender: TObject);
begin
  with liRecentServerWebroots do
    Options.RootDir := items[itemindex];
  PR_RootServerUpdated;
end;

procedure TOptiMainForm.liLayoutsGetData(Sender: TObject);
var i: integer;
begin
  i := PopulateLayoutList(LiLayouts.Items);
  liLayouts.ItemIndex := i;
end;

procedure TOptiMainForm.LayoutClickMessage(var Msg: TMessage);
begin
  with liLayouts do
    PR_LoadLayout(Items[itemindex]);
end;

procedure TOptiMainForm.liLayoutsClick(Sender: TObject);
begin
  PostMessage(handle, WM_USER + 3, 0, 0);
end;

procedure TOptiMainForm.liOpenWindowsGetData(Sender: TObject);
var
  i: integer;
  s: string;
const
  maxlen = 120;
begin
  liOpenWindows.Items.clear;
  for i := 0 to Screen.CustomFormCount - 1 do
    if screen.CustomForms[i] is TaqFloatingForm then
    begin
      s := screen.CustomForms[i].Caption;
      if (length(s) > maxlen) then
      begin
        setlength(s, maxlen);
        s := s + '...';
      end;
      liOpenWindows.Items.AddObject(s, Screen.CustomForms[i])
    end;
end;

procedure TOptiMainForm.liWindowsClick(Sender: TObject);
var cf: TCustomForm;
begin
  with Sender as TdxBarListItem do
    cf := TCustomForm(items.objects[itemindex]);
  cf.show;
end;

procedure TOptiMainForm.liDefaultLanguagesGetData(Sender: TObject);
var
  Current: TObject;
begin
  with liDefaultLanguages do
  begin
    items.Clear;
    current := parsersmod.GetLanguageList(items, true);
    itemindex := items.IndexOfObject(current);
  end;
end;

procedure TOptiMainForm.liOtherLanguagesGetData(Sender: TObject);
var
  Current: TObject;
begin
  with liOtherLanguages do
  begin
    items.Clear;
    current := parsersmod.GetLanguageList(items, false);
    itemindex := items.IndexOfObject(current);
  end;
end;

procedure TOptiMainForm.cbArgumentsChange(Sender: TObject);
begin
  ActiveScriptInfo.Query.Activequery[qmCMDLine] := cbArguments.text;
end;

procedure TOptiMainForm.ProcessQueryDropDown(cb: TdxBarCombo; Method: TQueryTypes);
var
  i: integer;
begin
  i := cb.CurItemIndex;
  cb.Items.Clear;
  cb.Items.Assign(ActiveScriptInfo.Query.queryLists[method]);
  if i >= cb.Items.Count then
    cb.CurItemIndex := -1;
end;

procedure TOptiMainForm.cbPostDropDown(Sender: TObject);
begin
  ProcessQueryDropDown(cbPost, qmPost);
end;

procedure TOptiMainForm.cbPathInfoDropDown(Sender: TObject);
begin
  ProcessQueryDropDown(cbPathInfo, qmPathInfo);
end;

procedure TOptiMainForm.cbGetDropDown(Sender: TObject);
begin
  ProcessQueryDropDown(cbGet, qmGet);
end;

procedure TOptiMainForm.cbCookieDropDown(Sender: TObject);
begin
  ProcessQueryDropDown(cbCookie, qmCookie);
end;

procedure TOptiMainForm.cbArgumentsDropDown(Sender: TObject);
begin
  ProcessQueryDropDown(cbArguments, qmCMDLine);
end;

procedure TOptiMainForm.cbGetCurChange(Sender: TObject);
begin
  ActiveScriptInfo.Query.ActiveQuery[qmGet] := TDxBarCombo(sender).CurText;
  QueryForm.UpdateAll;
end;

procedure TOptiMainForm.cbPostCurChange(Sender: TObject);
begin
  ActiveScriptInfo.Query.ActiveQuery[qmPost] := TDxBarCombo(sender).CurText;
  QueryForm.UpdateAll;
end;

procedure TOptiMainForm.cbPathInfoCurChange(Sender: TObject);
begin
  ActiveScriptInfo.Query.ActiveQuery[qmPathInfo] := TDxBarCombo(sender).CurText;
  QueryForm.UpdateAll;
end;

procedure TOptiMainForm.cbCookieCurChange(Sender: TObject);
begin
  ActiveScriptInfo.Query.ActiveQuery[qmCookie] := TDxBarCombo(sender).CurText;
  QueryForm.UpdateAll;
end;

procedure TOptiMainForm.cbBoxCloseUp(Sender: TObject);
begin
  PostMessage(Handle, WM_USER + 1, Integer(TdxBarControl(TdxBarCombo(Sender).FocusedItemLink.Control.Parent).Bar), 0);
end;

procedure TOptiMainForm.FocusBarForm(var Msg: TMessage);
var
  ABar: TObject;
  AForm: TWinControl;
begin
  ABar := TObject(Msg.WParam);
  if ABar is TdxBar then
    with TdxBar(ABar) do
    begin
      AForm := nil;
      if (DockControl <> nil) then
        AForm := DockControl.Parent;
      if AForm <> nil then
      begin
        while not (AForm is TForm) do
          AForm := AForm.Parent;
        if BarManager.Owner <> AForm then
          AForm.SetFocus;
      end;
    end;
end;

function TOptiMainForm._ActiveURL: string;
begin
  result := cbURLS.Text;
end;

procedure TOptiMainForm.FavoriteUpdateMessage(var Msg: TMessage);
begin
  ScanFolder.DoReleaseSubMenu(msg.Wparam);
end;

procedure TOptiMainForm.OnFavoriteClick(Sender: TObject);
var s: string;
begin
  s := GetAddressFromURLFile(TDXBarButton(sender).Hint);
  if s <> '' then
    PR_OpenURL(s);
end;

procedure TOptiMainForm.memTimerTimer(Sender: TObject);
begin
  try
    caption := IntToStr(mainWebForm.Handle) + ' ' + IntToStr(GetForegroundWindow) + ' ' + Inttostr(GetFocus) + ' ' + GetHeapString(OldHeap);
  except on exception do
      caption := '';
  end;
end;

procedure TOptiMainForm._ArrangeWindows(How: Integer);
var
  Win: array[0..100] of Cardinal;
  c, i: Integer;
begin
  c := 0;
  begin
    Win[c] := handle;
    inc(c);
  end;

  for i := 0 to Screen.CustomFormCount - 1 do
    if screen.CustomForms[i] is TaqFloatingForm then
    begin
      win[c] := screen.CustomForms[i].Handle;
      inc(c);
    end;

  case how of
    0: Windows.cascadeWindows(0, 0, nil, c, @Win);
    1: Windows.TileWindows(0, MDITILE_HORIZONTAL, nil, c, @Win);
    2: Windows.TileWindows(0, MDITILE_VERTICAL, nil, c, @Win);
  end;
end;

procedure TOptiMainForm.siHelpClick(Sender: TObject);
begin
  if options.MemTrace then OldHeap := GetHeapStatus;
  if options.CBTTest then optTest.TTToggleRecord;

 // raise EAccessViolation.create('d');
 // tag:=GetTickCount+80000;
 // repeat
 // until GetTickCount>tag;
 // Editorform.restartThread;
 // EnterCriticalSection(CSLineUpdate);
end;

procedure TOptiMainForm.SendMailMessage(var Msg: TMessage);
begin
  TSendmailForm.create(application, msg.msg, msg.wparam, msg.lparam);
end;

procedure TOptiMainForm.BarManagerBarVisibleChange(Sender: TdxBarManager;
  ABar: TdxBar);
begin
  UpdateHeight;
end;

procedure TOptiMainForm.cbKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ActiveEdit.ActiveWindowClosed;
end;

procedure TOptiMainForm.AfterActionEvent(Sender: TObject);
begin
  plugmod.OnAfterAction(TAction(sender).Name);
{$IFDEF EXPIREBYMINUTES}
  if Now > ExpireTime then
  begin
    MessageDlg('Each evaluation session is limited to 3 hours.' + #13 + #10 + 'This is a limitation of the trial version.' + #13 + #10 + 'The application will now terminate.' + #13#10#13#10 + 'Please Register!', mtWarning, [mbOK], 0);
    PostMessage(self.handle, WM_USER + 5, 0, 0);
  end;
{$ENDIF}
end;

function TOptiMainForm.BeforeActionEvent(Sender: TObject): Boolean;
var
  form: TCustomForm;
begin
  result := plugmod.OnBeforeAction(TAction(sender).Name);
  if not result then exit;
  if assigned(ActiveEdit.Control)
    then Form := GetParentForm(ActiveEdit.Control)
  else Exit;
  if (form <> self) and (checkform(form)) then
    SafeFocus(form);
end;

function TOptiMainForm.GetPlugNum(aq: TaqCustomDockingControl): Integer;
begin
  if StringStartsWith('dcPlugIn_', aq.Name) then
  begin
    result := pos('_', aq.Name) + 1;
    result := StrToInt(copyFromToEnd(aq.name, result));
  end
  else
    result := -1;
end;

procedure TOptiMainForm.FormShow(Sender: TObject);
var
  i: integer;
begin
  OnShow := nil;
  if paramstr(1) = '/e3' then exit;

  ScanFolder := TDxScanFolder.Create(
    GetSpecialFolder('Favorites', true), siFavorites, OnFavoriteClick, WM_USER + 2);

  PC_OptionsUpdated(HKO_BigVisible);
  ActiveEdit.initactions;
  EditorForm.siEditorPop := siEditorPop;
  EditorForm.siTabPop := siTabPop;

  for i := 0 to DockingManager.Items.Count - 1 do
    if (DockingManager.Items[i].Tag = 0) and
      (DockingManager.Items[i] <> dcRemoteDebForm) and
      (not StringStartsWith('dcPlugIn', DockingManager.Items[i].Name)) then
      TAqDockingControl(DockingManager.Items[i]).OnEnter := dcWindowCreate;

  DoWebShow(true);

  if length(options.FileFilters) > 0 then
    with editorform do
    begin
      Opendialog.Filter := options.FileFilters;
      Savedialog.Filter := options.FileFilters;
    end;
  options.ApplyStyle(editorform.memEditor);
  cbGet.Width := options.ComboBarWidths;
  cbPost.Width := options.ComboBarWidths;
  cbPathInfo.Width := options.ComboBarWidths;
  cbCookie.Width := options.ComboBarWidths;
  cbArguments.Width := options.ComboBarWidths;

  QueryForm.QueryCombos[0] := cbGet;
  QueryForm.QueryCombos[1] := cbPost;
  QueryForm.QueryCombos[2] := cbPathInfo;
  QueryForm.QueryCombos[3] := cbCookie;

  if (not options.RunTest) and (not options.CBTTest) then
  begin
    if (options.Version < options.CurrentVersion) then
    begin
      SetForegroundWindow(Application.MainForm.Handle);
      if MessageDlg('New commands added will not show up unless you reset ' + #13 + #10 + 'the main menu and toolbars to their default.' + #13 + #10 + '' + #13 + #10 + 'Alternatively, you can manually add the new commands' + #13 + #10 + 'from the "Customize Toolbars" window, to your modified ' + #13 + #10 + 'menus and toolbars.' + #13 + #10 + '' + #13 + #10 + 'Reset toolbars?', mtWarning, [mbOK, mbCancel], 0)
        = mrCancel then
        BarManager.LoadFrominiFile(folders.BarLayout);
    end
    else
      BarManager.LoadFrominiFile(folders.BarLayout);
  end;

  if OptiRel = orStan then
  begin
    with BarManager.BarByName('Debugger') do
    begin
      Visible := false;
      Hidden := True;
    end;
    siDebug.Visible := ivNever;
    siDebug.Enabled := false;
    StandardGroup.Visible := ivNever;
    with barmanager do
      CategoryVisible[Categories.IndexOf('Debug')] := false;
  end;

  GetRegInformation;

  dxBar.GeneralLockUpdate := true;
  try
    PR_LoadLayout(Options.Layout);
  finally
    dxBar.GeneralLockUpdate := false;
  end;

{$IFDEF OLE}
  PlugMod.UpdateItemLinks;
  UpdateAllMenus;
{$ENDIF}

  PR_SetTitle;

  for i := 0 to barwinlist.Count - 1 do
    with TOptiForm(barwinlist[i]) do
    begin
      LinkBar.AllowReset := LinkBar.Visible;
      LinkBar.Visible := false;
      OrgBar.Visible := true;

      LinkBar.ItemLinks := OrgBar.ItemLinks;

      LinkBar.Visible := LinkBar.AllowReset;
      LinkBar.AllowReset := false;
      OrgBar.Visible := false;

      UpdateMenu;
    end;

  HKLog('FA 0');
  firstactivate;
end;

procedure TOptiMainForm.DefLayout;
begin
  DockingManager.LoadFromStream(dataembedded.Data);
end;

procedure TOptiMainForm.CheckForEmpty;
var
  i: integer;
begin
  for i := screen.CustomFormCount - 1 downto 0 do
    if screen.CustomForms[i] is TAqFloatingForm then
      with screen.CustomForms[i] do
        if (controlcount = 0) or
          ((controls[0] is TAqFloatingSite) and
          (TAqFloatingSite(controls[0]).controlcount = 0)) then
          free;
end;

procedure TOptiMainForm._LoadLayout(const Name: string);
var
  s: string;
begin
  if IsLoadingLayout then exit;
  if name = '(none)' then exit;
  assert(false, 'LOG Load layout: ' + name);
  constraints.MinHeight := 0;
  constraints.MaxHeight := 0;
  DoWebShow(false);
  IsLoadingLayout := true;
  try
    s := includeTrailingBackSlash(folders.UserFolder) + name + OptiLayoutExt;
    if fileexists(s) then
    begin
      try
        Barmanager.LockUpdate := true;
        DockingManager.LoadFromFile(s);
        CheckForEmpty;
        Barmanager.LockUpdate := false;
      except on exception do
          DefLayout;
      end;
      options.Layout := name;
    end
    else
    begin
      Options.Layout := OptiLastLayout;
      DefLayout;
    end;
  finally
    IsLoadingLayout := false;
    OnDockEvent(nil, false);
    UpdateAllNonVisible;
    UpdateAllVisible;
    UpdateAllMenus;

    IsLoadingLayout := true;
    try
      RemoveUnusedAfterLoad;
    finally
      IsLoadingLayout := false;
    end;

    EditorForm.showIfVisible;
    EditorForm.UpdateCaption;
    with ProjectForm do
    begin
      DoSetCaption;
      SetHeaderWidths(vst, dockcontrol.UserData);
    end;
    with WebBrowserForm do
      SetHeaderWidths(vst, dockcontrol.UserData);
  end;
end;

procedure TOptiMainForm.SaveLayout(const Name: string);
begin
  with ProjectForm do
  try
    DockControl.UserData := GetHeaderWidths(vst);
  except
    DockControl.UserData := '';
  end;

  with WebBrowserForm do
  try
    DockControl.UserData := GetHeaderWidths(vst);
  except
    DockControl.UserData := '';
  end;

  DockingManager.SaveToFile(
    includeTrailingBackSlash(folders.UserFolder) + name + OptiLayoutExt);
end;

procedure TOptiMainForm.CustomActionHandler(Sender: TObject);
var
  Control: TaqCustomDockingControl;
  Form: TOptiForm;
begin
  Control := TaqCustomDockingControl(TaqCustomDockAction(Sender).Owner);

  while (control is TaqInsideContainer) do
    control := TaqInsideContainer(control).CurrentPage;

  Form := TOptiForm(Control.tag);
  if assigned(form) then
    Form.ButtonClick;
end;

procedure TOptiMainForm.DockingManagerRegister(
  Sender: TaqCustomDockingManager; Control: TaqCustomDockingControl);
var
  CustomAction: TaqCustomDockAction;
begin
  CustomAction := Control.Actions[idactCustom];
  CustomAction.Hint := 'Menu';
  CustomAction.OnExecute := CustomActionHandler;
end;

procedure TOptiMainForm.ApplicationEventsSettingChange(Sender: TObject;
  Flag: Integer; const Section: string; var Result: Integer);
begin
  UpdateHeight;
end;

procedure TOptiMainForm.UpdateAllVisible;
var
  i: integer;
begin
  for i := dockingmanager.Items.Count - 1 downto 0 do
  begin
    with TaqDockingControl(dockingmanager.Items[i]) do
      if (assigned(onEnter)) and (dockstate <> dcsHidden) then
        OnEnter(OptiMainForm.dockingmanager.Items[i]);
  end;
end;

procedure TOptiMainForm.UpdateAllNonVisible;
var
  i: integer;
begin
  for i := dockingmanager.Items.Count - 1 downto 0 do
  begin
    with TaqDockingControl(dockingmanager.Items[i]) do
      if (assigned(onEnter)) and (dockstate = dcsHidden) then
        OnControlClose(OptiMainForm.dockingmanager.Items[i], false);
  end;
end;

procedure TOptiMainForm.UpdateAllMenus;
var
  i: integer;
  form: TOptiForm;
begin
  for i := 0 to dockingmanager.Items.Count - 1 do
    with dockingmanager.Items[i] do
      if (DockClass = tAQDockingControl) and
        (Tag <> 0) then
      begin
        form := pointer(tag);
        form.updatemenu;
      end;
end;

procedure TOptiMainForm.DoWebShow(Show: Boolean);
var
  ActH: THandle;

  procedure DoPlugs;
  var i: integer;
  begin
    for i := 0 to length(PlugWindows) - 1 do
      if PlugWindows[i].Tag <> 0 then
        TPLuginForm(PlugWindows[i].Tag).webshow(show);
  end;

begin
  if Running.Count > 0 then
    ActH := GetActiveWindow;
  if show then
  begin
    if (dcWebBrowserForm.DockState <> dcsHidden) then
    begin
    //Main web browser
      Windows.SetParent(MainWebForm.Handle, WebBrowserForm.WebSheet.Handle);
      MainWebForm.Top := 0;
      MainWebForm.Left := 0;
      MainWebForm.Visible := true;
    end;
    if (dcPodViewerForm.DockState <> dcsHidden) then
    begin
    //Pod web browser
      Windows.SetParent(PodWebForm.Handle, PodViewerForm.WebPanel.Handle);
      PodWebForm.Top := 0;
      PodWebForm.Left := 0;
      PodWebForm.Visible := true;
    end;
{$IFDEF OLE}
    DoPlugs;
{$ENDIF}
  end
  else
  begin
    if (dcWebBrowserForm.DockState <> dcsHidden) then
    begin
    //Main web browser
      MainWebForm.Visible := false;
      Windows.SetParent(MainWebForm.Handle, 0);
    end;
    if (dcPodViewerForm.DockState <> dcsHidden) then
    begin
    //Pod web browser
      PodWebForm.Visible := false;
      Windows.SetParent(PodWebForm.Handle, 0);
    end;
{$IFDEF OLE}
    DoPlugs;
{$ENDIF}
  end;

  if Running.Count > 0 then
    SetActiveWindow(ActH);
end;

procedure TOptiMainForm.OnDockEvent(Sender: TaqCustomDockingControl; Before: Boolean);
begin
  if not Isloadinglayout then
  begin
    DoWebShow(not before);
    if not before then
    begin
      UpdateAllMenus;
      UpdateHeight;
    end;
  end;
  LastMax := -1;
end;

procedure TOptiMainForm.DoFloatingContainerClose(Sender: TaqCustomDockingControl);
var i: integer;
begin
  if sender = dcWebBrowserForm then
  begin
    MainWebForm.Visible := false;
    Windows.SetParent(MainWebForm.Handle, 0);
  end;
  if sender = dcPodViewerForm then
  begin
    PodWebForm.Visible := false;
    Windows.SetParent(PodWebForm.Handle, 0);
  end;
  for i := 0 to sender.ChildCount - 1 do
    DoFloatingContainerClose(sender.Children[i]);
end;

procedure TOptiMainForm.OnFloatingContainerClose(Sender: TaqCustomDockingControl; Before: Boolean);
begin
  DoFloatingContainerClose(sender);
end;

procedure TOptiMainForm.RemoveUnusedAfterLoad;
var
  aq: TAQDockingControl;
  i: integer;
begin
  with dockingmanager do
    for i := 0 to Items.Count - 1 do
      if assigned(TAqDockingControl(items[i]).OnEnter) and (items[i].Tag = 0) then
        items[i].RemoveFromDocking;
end;

procedure TOptiMainForm.dcWindowCreate(Sender: TObject);
var
  s: string;
  aq: TAQDockingControl absolute sender;
  i: integer;
  Hk: THKAction;
begin
  if aq.tag <> 0 then exit;
  s := aq.Name;
  delete(s, 1, 2);

  if StringStartsWith('LibrarianForm', s) then
  begin
    i := StrToInt(rightstr(s, 1));
    IniCreateLibrarian(i);
  end
  else
    if StringStartsWith('SecEditForm', s) then
    begin
      i := StrToInt(rightstr(s, 1));
      IniCreateSecEdit(i);
    end
    else
    begin
      i := WindowList.IndexOf(s);
      if i >= 0 then
      begin
        hk := THKAction(windowlist.Objects[i]);
        if assigned(hk) then
          hk.SimpleExecute;
      end;
    end;
end;

function TOptiMainForm.CalcGoodHeight: Integer;
begin
  if assigned(DockControlBottom) and
    assigned(DockControlTop) then
    result := DockControlBottom.ClientHeight + DockControlTop.ClientHeight
  else
    result := clientheight;
end;

procedure TOptiMainForm.UpdateHeight;
begin
 //makes the main form unsizable if no controls are in it.
  if not assigned(DockingSite.mainitem) then
    ConstraintSetHeight(self, CalcGoodHeight)
  else
  begin
    constraints.MinHeight := 0;
    constraints.MaxHeight := 0;
  end;
  if NextBigUpdateHeight <> -1 then
  begin
    if self.WindowState = wsMaximized then
    begin
      StartNonAnimatedWindows;
      try
        WindowState := wsNormal;
        WindowState := wsMaximized;
      finally
        EndNonAnimatedWindows;
      end;
    end
    else
      height := imin(screen.WorkAreaHeight - top, NextBigUpdateHeight + CalcGoodHeight + height - clientheight);
    NextBigUpdateHeight := -1;
  end;
end;

function TOptiMainForm.OnUpdateMover(Sender: TaqCustomMover; Coords: TPoint): TaqCustomDockingControl;
begin
 //used while docking
  result := nil;
  NextBigUpdateHeight := -1;
  if (constraints.MinHeight = 0) then exit;

  if (ptInRect(self.BoundsRect, coords)) then
  begin
    result := DockingSite.DummyControl;
    ConstraintSetHeight(self, CalcGoodHeight + 30);
    with Sender.DragItem.ScreenRect do
      NextBigUpdateHeight := bottom - top + 2;
  end
  else
    ConstraintSetHeight(self, CalcGoodHeight);
end;

procedure TOptiMainForm.OnControlClose(Sender: TaqCustomDockingControl;
  Before: Boolean);
var
  aq: TAQDockingControl absolute sender;
begin
  if (not IsLoadingLayout) then
  begin
    if (aq.Tag <> 0) then
      TOptiForm(aq.tag).Close;
  end;
end;

procedure TOptiMainForm.dcEditorFormShow(Sender: TObject);
begin
  if assigned(EditorForm) then
  begin
    EditorForm.DropFileTarget.Unregister;
    EditorForm.DropFileTarget.Register(nil);
    EditorForm.DropFileTarget.Register(editorForm.TabControl);
  end;
end;

procedure TOptiMainForm.DockingManagerPopupMenuCreate(
  Sender: TaqCustomDockingManager; Control: TaqCustomDockingControl;
  AMenu: TaqDockMenu; Flags: Cardinal);
var
  Action: TaqCustomDockAction;
begin
  if (control is TaqDockingControl) or
    (control is TaqInsideContainer) then
  begin
    Action := TaqCustomDockAction.Create(Control);
    Action.Caption := 'Toggle menu';
    Action.Hint := 'Toggles display of menu when window is docked';
    Action.Enabled := True;
    Control.RegisterAction(ToggleMenuActionID, Action);
    AMenu.AddSeparator(idactDefaultGroup);
    AMenu.AddAction(ToggleMenuActionID);
    Action.OnExecute := MenuItemToggleMenu;
  end;

  if (control is TaqInsideContainer) then
  begin
    AMenu.AddSeparator(idactDefaultGroup);

    AMenu.AddAction(idactHide);
    action := control.Actions[idactHide];
    action.OnExecute := ClickHideInsideContainder;

    AMenu.AddAction(idactUndock);
    action := control.Actions[idactUndock];
    action.OnExecute := ClickUndockInsideContainder;

    AMenu.AddAction(idactMaximize);
    AMenu.AddAction(idactRestore);
  end;
end;

procedure TOptiMainForm._ShowWebs(bool: BOolean);
begin
  DoWebShow(bool);
end;

procedure TOptiMainForm.ClickHideInsideContainder(Sender: TObject);
var
  ac: TaqInsideContainer;
begin
  ac := TaqInsideContainer(TaqCustomDockAction(sender).owner);
  if GetKeyState(VK_CONTROL) < 0 then
    ac.removeFromDocking
  else
    if ac.PageCount > 0 then
      PostMessage(self.Handle, HK_DockingEvent, 0, integer(ac.CurrentPage));
end;

procedure TOptiMainForm.ClickUndockInsideContainder(Sender: TObject);
var
  ac: TaqInsideContainer;
begin
  ac := TaqInsideContainer(TaqCustomDockAction(sender).owner);
  if GetAsyncKeyState(VK_CONTROL) < 0 then
    ac.MakeFloating(ac.ScreenRect)
  else
    if ac.PageCount > 0 then
      PostMessage(self.Handle, HK_DockingEvent, 1, integer(ac.CurrentPage));
end;

procedure TOptiMainForm.MenuItemToggleMenu(Sender: TObject);
var
  Form: TOptiForm;
  ad: TaqCustomDockAction absolute sender;
  aq: TaqCustomDockingControl;
begin
  aq := nil;
  if ad.Owner is TaqDockingControl then
    aq := ad.owner;
  if ad.Owner is TaqInsideContainer then
    aq := TaqInsideContainer(ad.Owner).CurrentPage;
  if assigned(aq) and (aq.tag <> 0) then
  begin
    form := TOptiForm(aq.tag);
    form.ShowMenuWhenDocked := not form.ShowMenuWhenDocked;
    UpdateAllMenus;
  end;
end;

procedure TOptiMainForm.DockingManagerUpdateActions(
  Sender: TaqCustomDockingManager; Control: TaqCustomDockingControl);
var
  Action: TaqCustomDockAction;
  Form: TOptiForm;
begin
  if (control.tag = 0) and (not (control is TaqInsideContainer)) then exit;

  action := control.Actions[ToggleMenuActionID];
  if (control is TaqDockingControl) and (control.Tag <> 0) then
    Form := TOptiForm(Control.Tag);
  if (control is TaqInsideContainer) and
    (TaqInsideContainer(control).PageCount > 0) then
    form := TOptiForm(TaqInsideContainer(control).CurrentPage.Tag);

  action.Enabled := (assigned(form)) and (assigned(Form.barman)) and
    ((control.DockState = dcsDocked) or (control is TaqInsideContainer));
  action.Checked := assigned(form) and form.ShowMenuWhenDocked;

  if (control = dcEditorForm) or (control = dcFileExploreForm) or
    (control = dcLibrarianForm0) or (control = dcLibrarianForm1) or
    (control = dcLibrarianForm2) or (control = dcLibrarianForm2) or
    (control = dcFTPSelectForm) or (control = dcRemoteDebForm) or
    (control = dcSecEditForm0) or (control = dcSecEditForm1) or
    (control = dcSecEditForm2) or (control = dcSecEditForm3) or
    (control = dcPodViewerForm) then
  begin
    Action := control.Actions[idactRename];
    Action.Enabled := false;
  end;

  if (control is TaqInsideContainer) then
  begin
    Action := control.Actions[idactUndock];
    action.Enabled := true;
    action.Hint := 'Undock active tab'#13#10'Hold down Ctrl to undock entire container';

    Action := control.Actions[idactHide];
    action.Enabled := true;
    action.Hint := 'Close active tab'#13#10'Hold down Ctrl to close entire container';
  end;
end;

function TOptiMainForm.DockTabClick(Sender: TaqCustomDockingControl; Shift: TShiftState): Boolean;
var
  Form: TOptiForm;
  aq: TaqInsideContainer absolute sender;
begin
  if (sender is TaqInsideContainer) and (aq.PageCount > 0) and
    (aq.CurrentPage.Tag <> 0) then
    form := TOptiForm(aq.CurrentPage.Tag)
  else
    if (sender.Tag <> 0) then
      form := TOptiForm(sender.Tag)
    else
    begin
      result := true;
      exit;
    end;

  result := (ssCtrl in shift);
  if not options.DockContextMenu then
    result := not result;

  if (not result) and (not form.ButtonClick) then
    result := true;
end;

{procedure TOptiMainForm.CMShowingChanged(var Message: TMessage);
begin
 inherited;
 if not DidShow then
 begin
  DidShow:=true;
//  firstactivate;
 end;
end;
}

procedure TOptiMainForm.BarManagerClickItem(Sender: TdxBarManager;
  ClickedItem: TdxBarItem);
begin
  with ActiveEdit do
    if GetTickCount - LastTime < 100 then
    begin
      Control := LastControl;
      try
        if assigned(control) and
          (control is TDCMemo) then
          Memo := TDCMemo(control);
      except on exception do end;
    end;
end;

procedure TOptiMainForm.BarManagerShowCustomizingForm(Sender: TObject);
var
  i: integer;
  f: TOptiForm;
  p: TPoint;
begin
  aqDockingBase.AddTaskBarButton := false;
  PR_BeforeCustomize;
  for i := 0 to barwinlist.Count - 1 do
  begin
    f := TOptiForm(barwinlist[i]);
    if f.DockControl.DockState = dcsHidden then continue;
    f.LinkBar.AllowReset := f.LinkBar.Visible;
    f.OrgBar.DockingStyle := dsNone;
    p.X := f.LinkBar.DockedLeft;
    p.Y := f.LinkBar.DockedTop;
    p := f.ClientToScreen(p);
    f.OrgBar.FloatLeft := p.X;
    f.OrgBar.FloatTop := p.Y;
    f.OrgBar.FloatClientWidth := 100;
    f.LinkBar.Visible := false;
    f.OrgBar.Visible := true;
  end;
end;

procedure TOptiMainForm.BarManagerHideCustomizingForm(Sender: TObject);
var
  i: integer;
  f: TOptiForm;
begin
  for i := 0 to barwinlist.Count - 1 do
  begin
    f := TOptiForm(barwinlist[i]);
    if f.DockControl.DockState = dcsHidden then continue;
    f.LinkBar.ItemLinks := f.OrgBar.ItemLinks;
    f.LinkBar.Visible := f.LinkBar.AllowReset;
    f.LinkBar.AllowReset := false;
    f.OrgBar.Visible := false;
    f.UpdateMenu;
  end;
  UpdateHeight;
  aqDockingBase.AddTaskBarButton := OrgShowTaskBar;
  SetForegroundWindow(handle);
end;

function ModWindowsEnumProc(hwnd: THandle; LPARAM: INteger): Boolean; stdcall;
begin
  if (WS_EX_APPWINDOW = WS_EX_APPWINDOW and GetWindowLong(hwnd, GWL_EXSTYLE)) then
    DefWindowProc(hwnd, WM_SYSCOMMAND, LPARAM, 0);
  result := true;
end;

procedure TOptiMainForm.ApplicationEventsDeactivate(Sender: TObject);
begin
  BarManager.HideAll;
end;

procedure TOptiMainForm.ApplicationEventsActivate(Sender: TObject);
begin
  if paramstr(1) = '/e4' then exit;
  if assigned(EditorForm) then
    EditorForm.MFH.CheckFileAges;
end;

function TOptiMainForm._IsBigWinNormal(Int: Integer): Boolean;
var
  aq: TaqCustomDockingControl;
begin
  aq := BigWins[int];
  if aq.DockState = dcsHidden then
  begin
    result := true;
    exit;
  end;
  if LastMax = -1 then
  begin
    if (assigned(aq.ParentItem)) and (aq.ParentItem is TaqInsideContainer) then
      aq := aq.ParentItem;
    result := aq.PanelState <> dpsMaximized;
  end
  else
    result := LastMax <> int;
end;

procedure TOptiMainForm._DoBigWinNormal(Int: Integer);
var
  f1, f2: TCustomForm;
  aq: TaqCustomDockingControl;
begin
  aq := BigWins[int];
  if aq.DockState = dcsHidden then
  begin
    aq.ForceVisible;
    exit;
  end;

  f1 := GetDockingParentForm(BigWins[1]);
  f2 := GetDockingParentForm(BigWins[0]);

  if (f1 = f2) or (not assigned(f1)) or (not assigned(f2)) then
  begin
    if (assigned(aq.ParentItem)) and (aq.ParentItem is TaqInsideContainer) then
      aq := aq.ParentItem;
    if assigned(aq.ParentItem) then
      if aq.PanelState <> dpsMaximized
        then aq.ParentItem.MaximizeChild(aq)
      else aq.parentitem.RestoreChildren;
  end

  else
  begin
    if (HKCanRestoreWindows) and (LastMax = Int) then
    begin
      HKRestoreWindows;
      LastMax := -1;
    end
    else
    begin
      if assigned(f1) and assigned(f2) then
      begin
        HKSaveWindows;
        HKSizeWindows(f1, f2, int = 1, 4);
        LastMax := int;
      end;
    end;
  end;
end;

procedure TOptiMainForm.MakeIconList;
const
  scr: array[TButtonState] of TThemedScrollBar =
  (tsThumbBtnHorzNormal, tsThumbBtnHorzHot, tsThumbBtnHorzPressed, tsThumbBtnHorzDisabled);
var
  Details: TThemedElementDetails;
  btn: TButtonState;
  buttons: TButtonBmp;
  h: Integer;
begin
  if not themeservices.ThemesEnabled then exit;
  h := DockingManager.Style[uidsCaptionButtonSize];

  for btn := low(TButtonState) to high(TButtonState) do
  begin
    if ThemeServices.ThemesEnabled then
    begin
      details := ThemeServices.GetElementDetails(scr[btn]);
      buttons[btn] := TBitmap.Create;
      buttons[btn].Height := h;
      buttons[btn].Width := h;
      themeservices.drawelement(buttons[btn].canvas.Handle, details, rect(0, 0, h, h));
    end;
  end;
  MakeCoolImageList(IconList, RunImageList, buttons, rect(2, 2, h - 2, h - 2));
end;

procedure TOptiMainForm.MakeWinList(List: TList);
var
  i: integer;
begin
  List.Clear;
  for i := 0 to Screen.CustomFormCount - 1 do
    if screen.CustomForms[i] is TaqFloatingForm then
      List.Add(screen.CustomForms[i]);
  if assigned(DockingSite.mainitem) then
    List.Add(self);
end;

procedure TOptiMainForm._DoNextWin;
begin
  HKSelectNextWindow(MakeWinList);
end;

procedure TOptiMainForm._DrawSplitter(sender: TObject);
const
  Edge: array[TAlign] of Cardinal =
  (0, BF_TOP or BF_BOTTOM, BF_TOP or BF_BOTTOM,
    BF_LEFT or BF_RIGHT, BF_LEFT or BF_RIGHT, 0, 0);
const
  Borders: array[TAlign] of TEdgeBorders =
  ([], [ebTop, ebBottom], [ebTop, ebBottom],
    [ebLeft, ebRight], [ebLeft, ebRight], [], []);
var
  sp: TSplitter absolute sender;
  r: trect;
  details: TThemedElementDetails;
  win: TThemedWindow;
begin
  r := sp.Canvas.ClipRect;
  win := twWindowDontCare;
  if (ThemedSplitters) and (ThemeServices.ThemesEnabled) then
  begin
    details := ThemeServices.GetElementDetails(win);
    themeservices.DrawEdge(sp.Canvas.Handle, details, r, BDR_SUNKENOUTER, Edge[sp.align]);
  end
  else
    DrawEdge(sp.Canvas, R, esLowered, esNone, Borders[sp.align]);
end;

procedure TOptiMainForm.DoDockingEvent(var Msg: TMessage);
begin
  with TAQcustomDockingControl(integer(msg.LParam)) do
    case msg.WParam of
      0: removefromdocking;
      1: MakeFloating(ScreenRect);
    end;
end;

procedure TOptiMainForm._ToolsUpdating(Start, OnlyImages: Boolean);
begin
  if (not Start) and (not onlyimages) then
    UpdateTools(false, false);
  Barmanager.LockUpdate := start;
end;

procedure TOptiMainForm.AddButtonLinkFromString(const Str: string; Btn: TdxBarButton; BarMan: TdxBarManager);

  function SameCaption(s1, s2: string): Boolean;
  begin
    replaceSC(s1, '&', '', false);
    replaceSC(s2, '&', '', false);
    result := Ansicomparetext(s1, s2) = 0;
  end;

var
  i, j: Integer;
  w: string;
  bar: TObject;
  IL: TdxBarItemLinks;
begin
  if not assigned(BarMan) then exit;
  Bar := nil;

  I := 1;
  repeat
    W := Trim(Parse(Str, '/', I));
    if length(w) = 0 then continue;

    if not assigned(bar) then
    begin
      for j := 0 to BarMan.Bars.Count - 1 do
        if SameCaption(BarMan.Bars[j].name, w) then
        begin
          bar := BarMan.Bars[j];
          break;
        end;
    end

    else
    begin
      IL := GetClassProperty(bar, 'ItemLinks');
      for j := 0 to il.Count - 1 do
        if SameCaption(il.Items[j].Item.Caption, w) then
        begin
          Bar := il.Items[j].Item;
          break;
        end;

    end;
  until (I < 1) or (I > Length(Str));

  if assigned(bar) then
  begin
    IL := GetClassProperty(bar, 'ItemLinks');
    if assigned(il) then
    begin
      i := 0;
      while (i < il.Count) and (il.Items[i].Item <> btn) do
        inc(i);
      if i >= il.Count then
        with il.Add do
        begin
          item := btn;
          begingroup := true;
        end;
    end;
  end;

end;

procedure TOptiMainForm._AddButtonLinkFromString(const Str: string; ABtn: TObject);
var
  i: integer;
  s: string;
  btn: TdxBarButton absolute ABtn;
  BarMan: TdxBarManager;
begin
  s := Trim(copy(str, 1, pos('/', str) - 1));
  if ansicomparetext(s, 'main') = 0 then
    BarMan := BarManager
  else
  begin
    BarMan := nil;
    with optiMainform.DockingManager.Items do
      for i := 0 to count - 1 do
        if scanf(items[i].Name, s, -1) > 0 then
          if items[i].Tag <> 0 then
          begin
            BarMan := TOptiForm(items[i].Tag).BarMan;
            if assigned(BarMan) then break;
          end;
  end;

  if assigned(BarMan) then
    AddButtonLinkFromString(str, Btn, barman);
end;

procedure TOptiMainForm.liPlugWinsGetData(Sender: TObject);
var i: integer;
begin
  with liPlugWins do
  begin
    items.Clear;
    for i := 0 to length(PlugWindows) - 1 do
      if PlugWindows[i].Tag <> 0 then
        items.AddObject(
          TPLuginForm(PlugWindows[i].Tag).DockControl.Caption, TObject(i));
  end;
end;

procedure TOptiMainForm.liPlugWinsClick(Sender: TObject);
begin
  with TPLuginForm(PlugWindows[liPlugWins.ItemIndex].Tag) do
    show;
end;

procedure TOptiMainForm._UpdatePlugIns;
var i: integer;
begin
  for i := 0 to length(PlugWindows) - 1 do
    if PlugWindows[i].Tag <> 0 then
      TPLuginForm(PlugWindows[i].Tag).Panel.OnResize(nil);
end;

procedure TOptiMainForm.WMDoTerminated(var msg: TMessage);
begin
  if msg.wParam <> 0 then
    if running.IndexOf(Pointer(msg.wParam)) >= 0 then
      TbasePlugIn(msg.wParam).free;
end;

procedure TOptiMainForm.OnDockTabChange(Sender: TaqCustomDockingControl;
  Before: Boolean);
begin
  if (sender.tag <> 0) and (TObject(Sender.tag) is TPlugInForm) then
    TPlugInForm(Sender.tag).PaintChild;
end;

procedure TOptiMainForm.HKLoadFile(var Msg: TMessage);
begin
  Assert(false, 'LOG Message for Loadfile');
  Application.Restore;
  Application.ProcessMessages;
  EditorForm.Startup(true);
  SetForegroundWindow(application.mainform.Handle);
end;

procedure TOptiMainForm.OnQUERYENDSESSION(var msg: TWMQUERYENDSESSION);
begin
  IsQUERYENDSESSION := true;
  inherited;
end;

procedure TOptiMainForm.liHighlightsGetData(Sender: TObject);
const
  Str: array[boolean] of string = ('Disabled', 'Enabled');
var
  i: integer;
begin
  liHighlights.Items.Clear;

  with EdMagicMod do
    for i := 0 to MaxHighLights - 1 do
      liHighlights.Items.Add(
        Str[HighPcre[i].tag > 0] + ': /' + HighPcre[i].MatchPattern + '/');
end;

procedure TOptiMainForm.liHighlightsClick(Sender: TObject);
var
  s: string;
begin
  with EdMagicMod.HighPcre[liHighlights.ItemIndex] do
  begin
    if tag = 1 then
      tag := 0
    else
    begin
      s := MatchPattern;
      if (s = '')
        then bFindAction.Click
      else tag := 1;
    end;
  end;
  editorForm.memEditor.Invalidate;
end;

procedure TOptiMainForm.liOpenFilesGetData(Sender: TObject);
var
  s: string;
  i: integer;
begin
  liOpenFiles.Items.Clear;
  with EditorForm.TabControl.Tabs do
    for i := 0 to count - 1 do
    begin
      liOpenFiles.Items.Add(Strings[i] + ' - ' + TScriptInfo(objects[i]).path + ' - ' +
        IntToStr(TScriptInfo(objects[i]).ms.Lines.Count) + ' lines');
      if objects[i] = activescriptinfo then
        liOPenFiles.ItemIndex := i;
    end;
end;

procedure TOptiMainForm.liOpenFilesClick(Sender: TObject);
begin
  EditorForm.MFH.SelectByIndex(liOpenFiles.ItemIndex);
end;

function TOptiMainForm._GetActiveServer: integer;
begin
  result := liServerStatus.ItemIndex;
end;

procedure TOptiMainForm.liServerStatusGetData(Sender: TObject);
var
  i: integer;
  f: string;
begin
  f := '';
  i := PR_GetServerPort(true, f);
  if i = 0
    then f := '(Internal server not loaded)'
  else f := '(Internal:' + inttostr(i) + ') ' + f;
  liServerStatus.Items.Strings[0] := f;

  i := PR_GetServerPort(false, f);
  if i = 0
    then f := '(External server not loaded)'
  else f := '(External:' + inttostr(i) + ') ' + f;
  liServerStatus.Items.Strings[1] := f;
  liServerStatus.Items.Objects[1] := Tobject(i);
end;

function IsExceptionBad(E: Exception): Boolean;
begin
  result := (E is EExternal) or (e is EThread) or
    (e is EInvalidOperation) or (E is EHeapException) or
    (e is EListError) or (e is EStringListError) or
    (E is EVariantError) or (e is EConvertError);
end;

procedure TOptiMainForm.ApplicationEventsException(Sender: TObject;
  E: Exception);
begin
  if IsExceptionBad(e)
    then
{$IFDEF DEVELOP}
    SendDebug(E.Classname + ': ' + E.message)
{$ENDIF}
  else
    MessageDlg(E.Message, mtError, [mbOK], 0);
end;

initialization
 copy(dumb,1,1);
end.

