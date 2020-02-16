{***************************************************************
 *
 * Unit Name: ItemMdl
 * Date     : 2/12/2000 7:18:13 μμ
 * Purpose  : General Actions of OPtiPerl except file actions
 * Author   : Harry Kakoulidis
 * History  :
 *
 ****************************************************************}

unit ItemMdl; //Module
{$I REG.INC}
interface

  uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,HKDebug,
  ExtCtrls,ActnList,ImgList,hakageneral,OptOptions,AppEvnts,CommConvUnit,SHDocVw,
  OptGeneral,CustDebmdl,debuggerMdl,scriptInfoUnit, HKComboInputForm,hyperstr,HKTransfer,
  editorfrm,PerlTemplatesFrm, LibrarianFrm, PerlInfoFrm,ConfToolFrm,FTPSelectFrm,
  QueryFrm,ExplorerFrm,AboutFrm,CheckForUpdateFrm,FTPSessionsFrm,dcString,
  StatusFrm, WebBrowserFrm,OptFolders,hakamessagebox,OptSearch,dcsystem,aqDockingBase,
  {$IFDEF OLE} PlugMdl, {$ENDIF}
  hyperfrm,OptionFrm,podViewerFrm,StringViewFrm,URLEncodeFrm,hakawin,VirtualTrees,
  hakafile,runperl,watchFrm,todofrm,RegExpTesterFrm,paramfrm,jclfileutils,ScktComp,
  PerlPrinterFrm,dcmemo,logfrm,hakahh,hkwebbrowser,ParsersMdl,SendMailAddFrm,
  PerlTidyFrm,SecEditFrm,FileCompareFrm,FileExploreFrm,shellapi,AutoViewFrm,
  projectfrm, evalExpFrm, HK_replunit, HKWebFind, ReplUnit, SearUnit,HTTPProxy,
  RdebMdl,ServerMdl,MainServerMdl,CentralImageListMdl,FTPMDl,PrintFrm,hakahyper,
  SubListFrm,SearchFIlesFrm,hkClasses,RemDebInfoFrm,OptControl,HKActions,OptMessage,
  PBFolderDialog,mainfrm,dxbar,dxBarExtItems,imm,HKActionCuts,BigWebFrm,
  OptProcs, ehshelprouter;


type

  TOptiModes = (omEdit,omDebug,omRun);

  TItemMod = class(TDataModule)
    ItemList: TActionList;
    UndoAction: THKAction;
    RedoAction: THKAction;
    CutAction: THKAction;
    CopyAction: THKAction;
    DeleteAction: THKAction;
    SelectAllAction: THKAction;
    ForwardAction: THKAction;
    FindAction: THKAction;
    AboutAction: THKAction;
    OpenBrowserWindowAction: THKAction;
    ExitAction: THKAction;
    StopDebAction: THKAction;
    SingleStepAction: THKAction;
    StepOverAction: THKAction;
    ReturnFromSubAction: THKAction;
    ContinueAction: THKAction;
    ListSubAction: THKAction;
    PackageVarsAction: THKAction;
    MethodsCallAction: THKAction;
    EvaluateVarAction: THKAction;
    OptionsAction: THKAction;
    TemplateFormAction: THKAction;
    ShowTemplatesAction: THKAction;
    GoToLineAction: THKAction;
    SearchAgainAction: THKAction;
    ReplaceAction: THKAction;
    CodeLibAction: THKAction;
    PerlInfoAction: THKAction;
    OpenEditorAction: THKAction;
    EditorBigAction: THKAction;
    BrowserBigAction: THKAction;
    RunBrowserAction: THKAction;
    RunExtBrowserAction: THKAction;
    PrRunInConsoleAction: THKAction;
    OpenCodeExplorerAction: THKAction;
    CheckForUpdateAction: THKAction;
    BackAction: THKAction;
    RefreshAction: THKAction;
    OpenURLAction: THKAction;
    StopAction: THKAction;
    TestErrorExpAction: THKAction;
    ShowHelpAction: THKAction;
    PatternSearchAction: THKAction;
    ConfToolsAction: THKAction;
    InternalServerAction: THKAction;
    OpenErrorLogsAction: THKAction;
    OpenAccessLogsAction: THKAction;
    ChangeRootAction: THKAction;
    RunWithServerAction: THKAction;
    ToggleBreakAction: THKAction;
    PodExtractorAction: THKAction;
    RemoteSessionsAction: THKAction;
    URLEncodeAction: THKAction;
    PerlDocAction: THKAction;
    OpenWatchesAction: THKAction;
    OpenTodoListAction: THKAction;
    PerlPrinterAction: THKAction;
    AutoEvaluationAction: THKAction;
    HaulBrowserAction: THKAction;
    AddToWatchAction: THKAction;
    RegExpTesterAction: THKAction;
    PasteAction: THKAction;
    MatchBracketAction: THKAction;
    PerlTidyAction: THKAction;
    NewEditWinAction: THKAction;
    ProfilerAction: THKAction;
    FindDeclarationAction: THKAction;
    FileCompareAction: THKAction;
    InternetOptionsAction: THKAction;
    FileExplorerAction: THKAction;
    CommentToggleAction: THKAction;
    RunSecBrowserAction: THKAction;
    SyncScrollAction: THKAction;
    EditShortCutAction: THKAction;
    FindSubAction: THKAction;
    ApplicationEvents: TApplicationEvents;
    ScrollTabAction: THKAction;
    TestErrorAction: THKAction;
    IndentAction: THKAction;
    OutdentAction: THKAction;
    CommentInAction: THKAction;
    CommentOutAction: THKAction;
    StartRemDebAction: THKAction;
    SearchDocsAction: THKAction;
    Goto2BookmarkAction: THKAction;
    Goto3BookmarkAction: THKAction;
    Goto4BookmarkAction: THKAction;
    Goto5BookmarkAction: THKAction;
    Goto6BookmarkAction: THKAction;
    Goto7BookmarkAction: THKAction;
    Goto0BookmarkAction: THKAction;
    Goto8BookmarkAction: THKAction;
    Goto1BookmarkAction: THKAction;
    Goto9BookmarkAction: THKAction;
    Tog0BookmarkAction: THKAction;
    Tog1BookmarkAction: THKAction;
    Tog2BookmarkAction: THKAction;
    Tog3BookmarkAction: THKAction;
    Tog4BookmarkAction: THKAction;
    Tog5BookmarkAction: THKAction;
    Tog6BookmarkAction: THKAction;
    Tog7BookmarkAction: THKAction;
    Tog8BookmarkAction: THKAction;
    Tog9BookmarkAction: THKAction;
    SwapVersionAction: THKAction;
    SameAsScriptPathAction: THKAction;
    SaveLayoutAction: THKAction;
    DeleteLayoutAction: THKAction;
    SelectStartPathAction: THKAction;
    OpenURLQueryAction: THKAction;
    ProxyEnableAction: THKAction;
    TextStyle1: THKAction;
    TextStyle2: THKAction;
    TextStyle3: THKAction;
    TextStyle4: THKAction;
    TextStyle5: THKAction;
    OpenRemoteAction: THKAction;
    SaveRemoteAction: THKAction;
    SaveRemoteActionAs: THKAction;
    RemoteExplorerAction: THKAction;
    DelWordLeft: THKAction;
    DelWordRight: THKAction;
    ExportCodeExplorerAction: THKAction;
    PrintAction: THKAction;
    SendMailAction: THKAction;
    CustToolsAction: THKAction;
    OpenZipAction: THKAction;
    ZIPOpenDialog: TOpenDialog;
    LoadEditLayoutAction: THKAction;
    SubListAction: THKAction;
    ApacheDocAction: THKAction;
    RunInConsoleAction: THKAction;
    RemDebSetupAction: THKAction;
    OpenCacheAction: THKAction;
    ReloadRemoteAction: THKAction;
    SaveAllRemoteAction: THKAction;
    ToggleIMEAction: THKAction;
    OpenAutoViewAction: THKAction;
    WinCascadeAction: THKAction;
    WinTileAction: THKAction;
    NextWindowAction: THKAction;
    HelpRouter: THelpRouter;
    EditColorAction: THKAction;
    DelCharLeftAction: THKAction;
    DelCharRightAction: THKAction;
    DelCharRightVIAction: THKAction;
    DelWholeLineAction: THKAction;
    DeleteLineBreakAction: THKAction;
    InsertNewLineAction: THKAction;
    DuplicateLineActon: THKAction;
    SelectLineAction: THKAction;
    DeleteToEOLAction: THKAction;
    DeleteToStartAction: THKAction;
    DeleteWordAction: THKAction;
    ToggleSelOptionAction: THKAction;
    AutoSynCheckAction: THKAction;
    AutoSynCheckStrippedAction: THKAction;
    MatchBracketSelectAction: THKAction;
    CallStackAction: THKAction;
    HighDeclarationAction: THKAction;
    BreakConditionAction: THKAction;
    NextSearchAction: THKAction;
    PrevSearchAction: THKAction;
    SearchNextAction: THKAction;
    Goto6GlobalAction: THKAction;
    Goto5GlobalAction: THKAction;
    Goto7GlobalAction: THKAction;
    Goto3GlobalAction: THKAction;
    Goto4GlobalAction: THKAction;
    Goto0GlobalAction: THKAction;
    Goto8GlobalAction: THKAction;
    Goto9GlobalAction: THKAction;
    Goto1GlobalAction: THKAction;
    Goto2GlobalAction: THKAction;
    RedOutputAction: THKAction;
    ActiveScriptDebAction: TAction;
    procedure DataModuleDestroy(Sender: TObject);
    procedure OpenBrowserWindowActionExecute(Sender: TObject);
    procedure StopDebActionUpdate(Sender: TObject);
    procedure SingleStepActionUpdate(Sender: TObject);
    procedure StepOverActionUpdate(Sender: TObject);
    procedure ReturnFromSubActionUpdate(Sender: TObject);
    procedure ContinueActionUpdate(Sender: TObject);
    procedure ListSubActionUpdate(Sender: TObject);
    procedure PackageVarsActionUpdate(Sender: TObject);
    procedure MethodsCallActionUpdate(Sender: TObject);
    procedure StopDebActionExecute(Sender: TObject);
    procedure SingleStepActionExecute(Sender: TObject);
    procedure StepOverActionExecute(Sender: TObject);
    procedure ReturnFromSubActionExecute(Sender: TObject);
    procedure ContinueActionExecute(Sender: TObject);
    procedure TemplateFormActionExecute(Sender: TObject);
    procedure ShowTemplatesActionExecute(Sender: TObject);
    procedure GoToLineActionExecute(Sender: TObject);
    procedure ReplaceActionExecute(Sender: TObject);
    procedure FindActionExecute(Sender: TObject);
    procedure SearchAgainActionExecute(Sender: TObject);
    procedure ExitActionExecute(Sender: TObject);
    procedure CodeLibActionExecute(Sender: TObject);
    procedure PerlInfoActionExecute(Sender: TObject);
    procedure OpenEditorActionExecute(Sender: TObject);
    procedure OpenCodeExplorerActionExecute(Sender: TObject);
    procedure AboutActionExecute(Sender: TObject);
    procedure CheckForUpdateActionExecute(Sender: TObject);
    procedure ForwardActionExecute(Sender: TObject);
    procedure BackActionExecute(Sender: TObject);
    procedure RefreshActionExecute(Sender: TObject);
    procedure StopActionExecute(Sender: TObject);
    procedure OpenURLActionExecute(Sender: TObject);
    procedure TestErrorExpActionExecute(Sender: TObject);
    procedure ShowHelpActionExecute(Sender: TObject);
    procedure ForwardActionUpdate(Sender: TObject);
    procedure BackActionUpdate(Sender: TObject);
    procedure WinBigActionExecute(Sender: TObject);
    procedure RunBrowserActionExecute(Sender: TObject);
    procedure RunExtBrowserActionExecute(Sender: TObject);
    procedure PrRunInConsoleActionExecute(Sender: TObject);
    procedure PatternSearchActionExecute(Sender: TObject);
    procedure ConfToolsActionExecute(Sender: TObject);
    procedure ChangeRootActionExecute(Sender: TObject);
    procedure InternalServerActionExecute(Sender: TObject);
    procedure RunWithServerActionExecute(Sender: TObject);
    procedure RunWithServerActionUpdate(Sender: TObject);
    procedure OptionsActionExecute(Sender: TObject);
    procedure ToggleBreakActionExecute(Sender: TObject);
    procedure PodExtractorActionExecute(Sender: TObject);
    procedure ListSubActionExecute(Sender: TObject);
    procedure PackageVarsActionExecute(Sender: TObject);
    procedure MethodsCallActionExecute(Sender: TObject);
    procedure EvaluateVarActionExecute(Sender: TObject);
    procedure RemoteSessionsActionExecute(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
    procedure URLEncodeActionExecute(Sender: TObject);
    procedure RefreshActionUpdate(Sender: TObject);
    procedure OpenWatchesActionExecute(Sender: TObject);
    procedure OpenTodoListActionExecute(Sender: TObject);
    procedure ToggleBreakActionUpdate(Sender: TObject);
    procedure PerlPrinterActionExecute(Sender: TObject);
    procedure ChangeRootActionUpdate(Sender: TObject);
    procedure OpenAccessLogsActionExecute(Sender: TObject);
    procedure OpenErrorLogsActionExecute(Sender: TObject);
    procedure TrueIfActivePerlActionUpdate(Sender: TObject);
    procedure PerlDocActionExecute(Sender: TObject);
    procedure AutoEvaluationActionExecute(Sender: TObject);
    procedure HaulBrowserActionExecute(Sender: TObject);
    procedure AddToWatchActionExecute(Sender: TObject);
    procedure RegExpTesterActionExecute(Sender: TObject);
    procedure MatchBracketActionExecute(Sender: TObject);
    procedure PerlTidyActionExecute(Sender: TObject);
    procedure NewEditWinActionExecute(Sender: TObject);
    procedure ProfilerActionExecute(Sender: TObject);
    procedure FindDeclarationActionExecute(Sender: TObject);
    procedure FileCompareActionExecute(Sender: TObject);
    procedure InternetOptionsActionExecute(Sender: TObject);
    procedure FileExplorerActionExecute(Sender: TObject);
    procedure CommentToggleActionUpdate(Sender: TObject);
    procedure CommentToggleActionExecute(Sender: TObject);
    procedure RunSecBrowserActionExecute(Sender: TObject);
    procedure RunSecBrowserActionUpdate(Sender: TObject);
    procedure SyncScrollActionExecute(Sender: TObject);
    procedure SyncScrollActionUpdate(Sender: TObject);
    procedure RunBrowserActionUpdate(Sender: TObject);
    procedure EditShortCutActionExecute(Sender: TObject);
    procedure FindSubActionExecute(Sender: TObject);
    procedure TestErrorActionUpdate(Sender: TObject);
    procedure ScrollTabActionExecute(Sender: TObject);
    procedure TestErrorActionExecute(Sender: TObject);
    procedure ApplicationEventsMessage(var Msg: tagMSG;
      var Handled: Boolean);
    procedure IndentActionExecute(Sender: TObject);
    procedure OutdentActionExecute(Sender: TObject);
    procedure CommentInActionExecute(Sender: TObject);
    procedure CommentOutActionExecute(Sender: TObject);
    procedure CommentInActionUpdate(Sender: TObject);
    procedure CommentOutActionUpdate(Sender: TObject);
    procedure StartRemDebActionUpdate(Sender: TObject);
    procedure StartRemDebActionExecute(Sender: TObject);
    procedure SearchDocsActionExecute(Sender: TObject);
    procedure TogBookmarkActionExecute(Sender: TObject);
    procedure GotoBookmarkActionExecute(Sender: TObject);
    procedure SelectStartPathActionExecute(Sender: TObject);
    procedure SameAsScriptPathActionExecute(Sender: TObject);
    procedure SameAsScriptPathActionUpdate(Sender: TObject);
    procedure SwapVersionActionExecute(Sender: TObject);
    procedure SaveLayoutActionExecute(Sender: TObject);
    procedure DeleteLayoutActionExecute(Sender: TObject);
    procedure SwapVersionActionUpdate(Sender: TObject);
    procedure ProxyEnableActionUpdate(Sender: TObject);
    procedure ProxyEnableActionExecute(Sender: TObject);
    procedure OpenURLQueryActionExecute(Sender: TObject);
    procedure TextStyleExecute(Sender: TObject);
    procedure TextStyleUpdate(Sender: TObject);
    procedure OpenRemoteActionExecute(Sender: TObject);
    procedure IsRemoteActionUpdate(Sender: TObject);
    procedure SaveRemoteActionAsExecute(Sender: TObject);
    procedure SaveRemoteActionExecute(Sender: TObject);
    procedure RemoteExplorerActionExecute(Sender: TObject);
    procedure DelWordLeftExecute(Sender: TObject);
    procedure DelWordRightExecute(Sender: TObject);
    procedure ExportCodeExplorerActionExecute(Sender: TObject);
    procedure PrintActionExecute(Sender: TObject);
    procedure SendMailActionExecute(Sender: TObject);
    procedure CustToolsActionExecute(Sender: TObject);
    procedure OpenZipActionExecute(Sender: TObject);
    procedure LoadEditLayoutActionExecute(Sender: TObject);
    procedure SubListActionExecute(Sender: TObject);
    procedure ApacheDocActionExecute(Sender: TObject);
    procedure RunInConsoleActionExecute(Sender: TObject);
    procedure RemDebSetupActionExecute(Sender: TObject);
    procedure OpenCacheActionExecute(Sender: TObject);
    procedure EnIFMainMemoEnabled(Sender: TObject);
    procedure BookmarkActionUpdate(Sender: TObject);
    procedure EnIFAnyMemoActive(Sender: TObject);
    procedure AutoEvaluationActionUpdate(Sender: TObject);
    procedure ToggleIMEActionExecute(Sender: TObject);
    procedure OpenAutoViewActionExecute(Sender: TObject);
    procedure WinArrangeActionExecute(Sender: TObject);
    procedure WinBigUpdate(Sender: TObject);
    procedure NextWindowActionExecute(Sender: TObject);
    procedure ReloadRemoteActionExecute(Sender: TObject);
    procedure SaveAllRemoteActionExecute(Sender: TObject);
    procedure EditColorActionExecute(Sender: TObject);
    procedure DelCharLeftActionExecute(Sender: TObject);
    procedure DelCharRightActionExecute(Sender: TObject);
    procedure DelCharRightVIActionExecute(Sender: TObject);
    procedure DelWholeLineActionExecute(Sender: TObject);
    procedure DeleteLineBreakActionExecute(Sender: TObject);
    procedure InsertNewLineActionExecute(Sender: TObject);
    procedure DuplicateLineActonExecute(Sender: TObject);
    procedure SelectLineActionExecute(Sender: TObject);
    procedure DeleteToEOLActionExecute(Sender: TObject);
    procedure DeleteToStartActionExecute(Sender: TObject);
    procedure DeleteWordActionExecute(Sender: TObject);
    procedure ToggleSelOptionActionExecute(Sender: TObject);
    procedure ToggleSelOptionActionUpdate(Sender: TObject);
    procedure NewEditWinActionUpdate(Sender: TObject);
    procedure CodeLibActionUpdate(Sender: TObject);
    procedure AutoSynCheckActionUpdate(Sender: TObject);
    procedure AutoSynCheckActionExecute(Sender: TObject);
    procedure AddToWatchActionUpdate(Sender: TObject);
    procedure AutoSynCheckStrippedActionExecute(Sender: TObject);
    procedure AutoSynCheckStrippedActionUpdate(Sender: TObject);
    procedure MatchBracketSelectActionExecute(Sender: TObject);
    procedure CallStackActionExecute(Sender: TObject);
    procedure HighDeclarationActionExecute(Sender: TObject);
    procedure BreakConditionActionExecute(Sender: TObject);
    procedure BreakConditionActionUpdate(Sender: TObject);
    procedure NextPrevSearchActionExecute(Sender: TObject);
    procedure SearchNextActionExecute(Sender: TObject);
    procedure GotoGlobalActionExecute(Sender: TObject);
    procedure RedOutputActionExecute(Sender: TObject);
    procedure RedOutputActionUpdate(Sender: TObject);
    procedure ActiveScriptDebActionExecute(Sender: TObject);
    procedure ActiveScriptDebActionUpdate(Sender: TObject);
  private
    LastOptiMode : TOptiModes;
    Procedure RenewDebActions;
    Procedure DoTestErrors(Exp : boolean);
    procedure LoadWindow;
    procedure SetTextStyleCaptions;
    Procedure SetOptiMode(OM : TOptiModes);
    procedure UploadIfDirty;
    procedure OnFindClose(sender: TObject);
    procedure OnPositionItemClick(Sender : TObject; Const Pat : String; CaseSens : Boolean; Index : Integer);

    function GetLocalHTTPAddress: String;
    function GetRemoteHTTPAddress(Const Session : String): String;
    procedure RunInConsole(Params: string; LeaveOpen: Boolean);
    procedure UpdateAllMemos;
    procedure PutActions;
    procedure WebOnRequest(Sender : TObject; const Status: string);
    procedure WebOnResponse(Sender : TObject; const Status: string);
    Procedure WebOnProxyLog(Sender : TObject; Const Log : String);
    procedure StartDeb;
    Function StartDebAllow : Boolean;
    procedure RestartDeb;
  protected
    function _GetServerPort(Internal: Boolean; out folder : String): Integer;
    procedure _BeforeCustomize;
    procedure _DoBreakConditions;
    function _ShouldUpdateCallStack: Boolean;
    procedure _UpdateCallStack;
    procedure _ShowOptions(ColorIndex,PageIndex: Integer);
    function _ActiveHTTPAddress: String;
    procedure _SearchForWord(const Data: String);
    procedure _DoErrorChecking;
    procedure _DoOldTodo(ms: TMemoryStream; Sl : TStrings);
    procedure _OpenInPodViewer(const Data: String);
    procedure _RootServerUpdated;
    procedure _OptionsUpdated(Level: Integer);
    procedure _Terminating;
    function _BreakpointsEnabled: Boolean;
    function _InternalServerRunning: Boolean;
  public
    ActionArray : TActionArray;
  end;

var
  ItemMod: TItemMod;

implementation

{$R *.DFM}

var
 HintFontOrgName : String;
 HintFontOrgSize : Integer;

procedure TItemMod.DataModuleDestroy(Sender: TObject);
begin
 itemmod:=nil;
{$IFDEF DEVELOP}
 SendDebug('Destroyed: ItemMod');
{$ENDIF}
end;

procedure TItemMod.OpenBrowserWindowActionExecute(Sender: TObject);
begin
 WebBrowserForm.Show;
end;

procedure TItemMod.StopDebActionUpdate(Sender: TObject);
begin
 StopDebAction.Enabled:=assigned(debMod) and (debStop in debmod.debactions);
end;

procedure TItemMod.StepOverActionUpdate(Sender: TObject);
begin
 StepOverAction.enabled:=assigned(debMod) and (debNextStep in debmod.debactions);
end;

procedure TItemMod.ReturnFromSubActionUpdate(Sender: TObject);
begin
 ReturnFromSubAction.enabled:=assigned(debMod) and (debReturnFromSub in debmod.debactions);
end;

procedure TItemMod.ListSubActionUpdate(Sender: TObject);
begin
 ListSubAction.enabled:=assigned(debMod) and (debListSubNames in debmod.debactions);
end;

procedure TItemMod.PackageVarsActionUpdate(Sender: TObject);
begin
 PackageVarsAction.enabled:=assigned(debMod) and (debPackageVars in debmod.debactions);
end;

procedure TItemMod.MethodsCallActionUpdate(Sender: TObject);
begin
 MethodsCallAction.enabled:=assigned(debMod) and (debMethodsCall in debmod.debactions);
end;

Procedure TItemMod.RenewDebActions;
var i:integer;
begin
 with itemlist do
  for i:=0 to actioncount -1 do
   if actions[i].Category='Debug' then
    ItemList.actions[i].Update;
end;

procedure TItemMod.StartRemDebActionUpdate(Sender: TObject);
begin
 startremdebaction.Enabled:=assigned(debMod) and (debStart in debmod.DebActions);
end;

procedure TItemMod.StartRemDebActionExecute(Sender: TObject);
begin
  if OptiRel=orStan then exit;
  debmod:=Rdebmod;
  PV_SetDebuggerProcs(false);

  ServerMdl.PutPerlDBOpt:=True;
  ServerMdl.TimeOut:=0;
  ServerMdl.DoFeed:=options.IntServerFeed;

  if options.IntServerFeed then
   PR_NewSession;
  if options.CheckSyntax then
   TestErrorAction.SimpleExecute;
  if (Options.incgutter) and (editorForm.memeditor.GutterWidth<>38) then
   editorForm.memeditor.GutterWidth:=38;

  PR_QuickSave;
  EditorForm.ResyncBreakpoints;

  if FileExists(Editorform.mfh.ActiveFileinfo.path) then
  begin
   DebMod.Script:=EditorForm.MFH.ActiveFileInfo.path;
   if DebMod.Start then
    begin
     DoPerl5DBVal;
     RenewDebActions;
     SetOptiMode(omDebug);
    end
   else
    DebMod:=LDebMod;
  end;
end;

procedure TItemMod.RestartDeb;
begin
  if OptiRel=orStan then exit;
  EditorForm.ClearAllRunLines;
  debmod.Restart;
  RenewDebActions;
end;

Function TItemMod.StartDebAllow;
begin
 result:=
  (assigned(ActiveScriptInfo)) and (assigned(debmod)) and
  (debStart in debmod.DebActions) and
  (ActiveScriptInfo.IsPerl) and
  (debmod=LDebmod);
end;

procedure TItemMod.StartDeb;
var
 s:string;
begin
  if OptiRel=orStan then exit;

  debmod:=Ldebmod;
  PV_SetDebuggerProcs(true);

  if options.CheckSyntax
   then TestErrorAction.SimpleExecute;

  if (Options.incgutter) and (editorForm.memeditor.GutterWidth<>38) then
   editorForm.memeditor.GutterWidth:=38;
  PR_QuickSave;

  EditorForm.ResyncBreakpoints;

  if FileExists(OPtions.ActiveDebScript)
   then s:=OPtions.ActiveDebScript
   else s:=ActiveScriptInfo.path;

  if FileExists(s) then
  begin
   DebMod.Script:=s;
   PR_OpenFile(s);
   DebMod.Start;
  end;

  RenewDebActions;
  SetOptiMode(omDebug);
end;

procedure TItemMod.StopDebActionExecute(Sender: TObject);
begin
 if OptiRel=orStan then exit;
  debmod.Stop;
  ServerMdl.TimeOut:=Options.RunTimeOut;
  ServerMdl.PutPerlDBOpt:=false;
  ServerMdl.DoFeed:=false;

  //The following must be done to handle breakpoints when
  //the debugger is off
  debmod:=ldebmod;
  PV_SetDebuggerProcs(true);

  EditorForm.ClearAllRunLines;
  if (Options.incgutter) and (editorForm.memeditor.GutterWidth<>options.GutterWidth) then
   editorForm.memeditor.GutterWidth:=options.GutterWidth;
 RenewDebActions;
 SetOptiMode(omEdit);
end;

procedure TItemMod.StepOverActionExecute(Sender: TObject);
begin
 debmod.NextStep;
end;

procedure TItemMod.ReturnFromSubActionExecute(Sender: TObject);
begin
 debmod.ReturnFromSub;
end;

procedure TItemMod.ContinueActionExecute(Sender: TObject);
begin
 if not (debContinueScript in debmod.debactions) then
  StartDeb;
 debmod.ContinueScript;
end;

procedure TItemMod.ContinueActionUpdate(Sender: TObject);
begin
 ContinueAction.enabled:=assigned(debMod) and
  (StartDebAllow or (debContinueScript in debmod.debactions))
end;

procedure TItemMod.SingleStepActionExecute(Sender: TObject);
begin
 if not (debSingleStep in debmod.debactions)
  then StartDeb
  else debmod.SingleStep;
end;

procedure TItemMod.SingleStepActionUpdate(Sender: TObject);
begin
 SingleStepAction.enabled:=assigned(debMod) and
  (StartDebAllow or (debSingleStep in debmod.debactions));
end;

procedure TItemMod.TemplateFormActionExecute(Sender: TObject);
begin
 TemplateForm:=TTemplateForm.Create(application);
 TemplateForm.showmodal;
 TemplateForm.Free;
end;

procedure TItemMod.ShowTemplatesActionExecute(Sender: TObject);
begin
 ActiveEdit.MainMemo.ShowCodeTemplates;
end;

procedure TItemMod.GoToLineActionExecute(Sender: TObject);
begin
 ActiveEdit.Memo.memosource.ShowGoToLineDialog;
 if activeedit.IsMainActive then
  ActiveEdit.MainMemo.SetFocus;
 // when debugging
 // RDebMod.output.socket.Connections[0].SendText('TEST'#13#10);
end;

procedure TItemMod.ReplaceActionExecute(Sender: TObject);
begin
 if activeEdit.IsMainActive
  then ExecuteFindReplace(ActiveEdit.memo.memosource,1,7160)
  else ActiveEdit.Memo.memosource.ShowReplaceDialog;
end;

procedure TItemMod.FindActionExecute(Sender: TObject);
begin
 if (MainWebForm.WebFocused) then
  ShowWebFindDialog(mainWebForm.webBrowser)
 else
 if (PodWebForm.WebFocused) then
  ShowWebFindDialog(PodWebForm.webBrowser)
 else
 if assigned(activeEdit.memo) then
  if activeEdit.IsMainActive
   then ExecuteFindReplace(ActiveEdit.memo.memosource,0,7160)
   else ActiveEdit.Memo.memosource.ShowSearchDialog;
end;

procedure TItemMod.SearchNextActionExecute(Sender: TObject);
begin
 with activeEdit.memo.MemoSource do
 begin
  if IsRectEmpty(FoundRect) then
   SearchOptions.TextToFind:=PR_GetFindText(false);
  SearchOptions.FirstSearch:=false;
  if length(SearchOptions.TextToFind)>0 then
  begin
   CurrentOptions.SearchText:=SearchOptions.TextToFind;
   CurrentOptions.ReplText:='';
   CurrentOptions.CaseSensitive:=false;
   CurrentOptions.WholeWords:=false;
   FindNext;
  end;
 end;
end;

procedure TItemMod.SearchAgainActionExecute(Sender: TObject);
begin
 with ActiveEdit.Memo.memosource do
 if length(SearchOptions.TextToFind)>0 then
  begin
   FindNext;
   if activeEdit.IsMainActive then
    FixDialogPos;
  end
 else
  begin
   FindAction.SimpleExecute;
  end;
end;

procedure TItemMod.ExitActionExecute(Sender: TObject);
begin
 Application.MainForm.Close;
end;

procedure TItemMod.CodeLibActionExecute(Sender: TObject);
begin
 CreateLibrarian(folders.SnippetFile);
end;

procedure TItemMod.OpenZipActionExecute(Sender: TObject);
begin
 if ZipOpenDialog.Execute then
  CreateLibrarian(ZipOpenDialog.Filename);
end;

procedure TItemMod.CodeLibActionUpdate(Sender: TObject);
begin
 TAction(sender).Enabled:=LibrarianAvailable;
end;

procedure TItemMod.PerlInfoActionExecute(Sender: TObject);
begin
 if not assigned(perlInfoForm)
  then PerlInfoForm:=TPerlInfoForm.create(Application);
 PerlInfoForm.show;
end;

procedure TItemMod.OpenEditorActionExecute(Sender: TObject);
begin
 EditorForm.show;
end;

procedure TItemMod.OpenCodeExplorerActionExecute(Sender: TObject);
begin
 ExplorerForm.show;
end;

procedure TItemMod.AboutActionExecute(Sender: TObject);
begin
 OpenModalForm(TAboutForm);
end;

procedure TItemMod.CheckForUpdateActionExecute(Sender: TObject);
begin
 CheckUpdateForm:=TCheckUpdateForm.create(application);
 CheckUpdateForm.ShowModal;
 CheckUpdateForm.free;
end;

procedure TItemMod.ForwardActionExecute(Sender: TObject);
begin
 WebBrowserForm.WebBrowser.GoForward;
end;

procedure TItemMod.BackActionExecute(Sender: TObject);
begin
 WebBrowserForm.WebBrowser.GoBack;
end;

procedure TItemMod.RefreshActionExecute(Sender: TObject);
begin
 WebBrowserForm.WebBrowser.Refresh;
end;

procedure TItemMod.StopActionExecute(Sender: TObject);
begin
 WebBrowserForm.WebBrowser.Stop;
end;

procedure TItemMod.OpenURLActionExecute(Sender: TObject);
var url : string;
begin
 URL:=PR_ActiveURL;
 if URL<>'' then
 begin
  PR_OpenURL(Url);
  PR_HandleActiveURL(URL);
 end;
end;

procedure TItemMod.OpenURLQueryActionExecute(Sender: TObject);
var url : string;
begin
 URL:=PR_ActiveURL;
 if URL<>'' then
 begin
  PR_OpenURLQuery(Url);
  PR_HandleActiveURL(URL);
 end;
end;


Procedure TItemMod.DoTestErrors(Exp : boolean);
var SI : TScriptInfo;
begin
 Si:=ActiveScriptInfo;
 if not assigned(StatusForm) then
  begin
   StatusForm:=TStatusForm.create(Application);
   StatusForm.show;
  end
 else
  StatusForm.show;
 if Assigned(si) then
 begin
  PR_QuickSave;
  StatusForm.UpdateError(si.path,exp);
 end;
end;

procedure TItemMod.TestErrorActionExecute(Sender: TObject);
begin
 DoTestErrors(false);
end;

procedure TItemMod.TestErrorExpActionExecute(Sender: TObject);
begin
 DoTestErrors(true);
end;

procedure TItemMod.ShowHelpActionExecute(Sender: TObject);
begin
 HelpRouter.HelpContent;
end;

procedure TItemMod.ForwardActionUpdate(Sender: TObject);
begin
 ForwardAction.enabled:=assigned(WebBrowserForm) and (WebBrowserForm.ForwardEnable);
end;

procedure TItemMod.BackActionUpdate(Sender: TObject);
begin
 BAckAction.enabled:=assigned(WebBrowserForm) and (WebBrowserForm.BackEnable);
end;

procedure TItemMod.WinBigUpdate(Sender: TObject);
const
 StrS : Array[boolean] of string = ('Restore ','Maximize ');
 StrN : Array[0..1] of string = ('Editor','Web browser');
begin
 if assigned(PR_IsBigWinNormal) then
  with TAction(sender) do
   caption:=StrS[PR_ISBigWinNormal(tag)]+StrN[tag];
end;

procedure TItemMod.WinBigActionExecute(Sender: TObject);
begin
 Pr_DoBigWinNormal(TAction(sender).Tag);
end;

procedure TItemMod.RunBrowserActionUpdate(Sender: TObject);
begin
 runbrowseraction.Enabled:=assigned(WebBrowserForm) and (not WebBrowserForm.RunningOffline);
end;

procedure TItemMod.RunBrowserActionExecute(Sender: TObject);
begin
 UploadIfDirty;
 PR_RunScriptInternal;
 SetOptiMode(omRun);
end;


procedure TItemMod.RunExtBrowserActionExecute(Sender: TObject);
begin
 UploadIfDirty;
 PR_RunScriptExternal;
end;

procedure TItemMod.RunInConsoleActionExecute(Sender: TObject);
var
 params : string;
 LOpen : Boolean;
begin
 if isUNCPath(ActiveScriptInfo.path) then
 begin
  MessageDlg('Cannot run in console a remote file.', mtError, [mbOK], 0);
  exit;
 end;

 paramform:=TParamForm.create(Application,ptRun);
 try
  paramform.FormStorage.IniSection:='ConsoleRun';
  ParamForm.FormStorage.RestoreFormPlacement;
  params:=paramform.edParams.text;
  LOpen:=paramform.cbLeaveOpen.Checked;
 finally
  ParamForm.free;
 end;
 RunInConsole(params,LOpen);
end;

procedure TItemMod.RunInConsole(Params : string; LeaveOpen : Boolean);
var
 folder,p : string;
begin
 PR_QuickSave;
 if options.StartPath<>''
  then folder:=options.StartPath
  else folder:=ExtractFilePath(ActiveScriptInfo.path);

 PC_TagConvert(params);
 if params=#0 then exit;
 if ActiveScriptInfo.IsPerl then
  begin
   if not LeaveOpen then
    begin
     ShellExecute(application.Handle,'open',pchar(options.PathToPerl),
     pchar(params),pchar(folder),SW_SHOW)
    end
   else
    begin
     p:='/k '+extractshortpathname(options.PathToPerl)+' '+params;
     ShellExecute(Application.handle, 'open',PChar(getcomspec),PChar(p),pchar(folder),SW_SHOW);
    end;
  end
 else
  ShellExecute(Application.handle,pchar('open'),
      pchar(ActiveScriptInfo.path),
      pchar(params),
      pchar(folder),SW_SHOW);
end;

procedure TItemMod.PrRunInConsoleActionExecute(Sender: TObject);
var
 params : string;
 DoRun : Boolean;
 LOpen : Boolean;
begin
 if isUNCPath(ActiveScriptInfo.path) then
 begin
  MessageDlg('Cannot run in console a remote file.', mtError, [mbOK], 0);
  exit;
 end;

 paramform:=TParamForm.create(Application,ptRun);
 try
  paramform.FormStorage.IniSection:='ConsoleRun';
  paramform.edParams.ShowHint:=true;
  paramform.btnDefault.Visible:=true;
  paramform.caption:='Run in Console';

  doRun:=ParamForm.ShowModal=mrOK;

  params:=paramform.edParams.text;
  LOpen:=paramform.cbLeaveOpen.Checked;
 finally
  ParamForm.Free;
 end;

 if DoRun then
  RunInConsole(params,LOpen);
end;

procedure TItemMod.PatternSearchActionExecute(Sender: TObject);
var
 SearchFilesForm : TSearchFilesForm;
 sl : TStringList;
 i:integer;
begin
 PR_QuickSave;
 sl:=TStringList.Create;
 with editorform do
  for i:=0 to MFH.FileList.Count-1 do
   sl.add(TScriptInfo(MFH.FileList.Objects[i]).path);
 sl.Move(EditorForm.TabControl.TabIndex,0);
 
 SearchFilesForm:=TSearchFIlesForm.create(application,sdActive,sl,PR_GetFindText(true));
  try
   SearchFilesForm.showmodal;
  finally
   SearchFIlesForm.free;
   sl.free;
  End;
end;

procedure TItemMod.ConfToolsActionExecute(Sender: TObject);
begin
 ConfToolForm.Showmodal;
end;

procedure TItemMod.ChangeRootActionExecute(Sender: TObject);
var
 sl : TStringList;
 s:string;
begin
 s:=options.RootDir;
 if not BrowseForFolder('Select root folder:',true,s) then exit;
 Sl:=TStringList.Create;
 try
  sl.Text:=Options.ROotDirList;
  SmartStringsAdd(sl,s);
  Options.RootDirList:=sl.Text;
  Options.rootdir:=s;
 finally
  sl.Free;
 end;
 PR_RootServerUpdated;
end;

procedure TItemMod.InternalServerActionExecute(Sender: TObject);
begin
 InternalServerAction.Checked:=not InternalServerAction.checked;
 if InternalServerAction.Checked then
  begin
   ServerMdl.ServerName:='OptiPerl/'+optgeneral.OptiVersion;
   ServerMdl.webroot:=Options.RootDir;
   MainServerMod.Server.Port:=options.ServerPort;
   if (debMod=RDebMod)
    then ServerMdl.TimeOut:=0
    else ServerMdl.TimeOut:=OPtions.RunTimeOut;
   ServerMdl.ProgAssociations:=Options.AssocList;
   ServerMdl.Rewrite:='';

   MainServerMod.Start;
   InternalServerAction.checked:=MainServerMod.Running;
  end
 else
  begin
   FTPMod.terminatesessions;
   MainServerMod.stop;
  end;
end;

procedure TItemMod.RunWithServerActionExecute(Sender: TObject);
begin
 Options.RunWIthServer:=not Options.runwithserver;
end;

procedure TItemMod.RunWithServerActionUpdate(Sender: TObject);
begin
 RunWithServerAction.Checked:=Options.runwithserver;
end;

procedure TItemMod._ShowOptions(ColorIndex,PageIndex : Integer);
begin
 if Assigned(OptionForm) then
  OptionForm.free;

 OptionForm:=TOptionForm.Create(Application);
 OptionForm.Startcolorindex:=ColorIndex;
 OptionForm.startindex:=pageindex;
 try
  if OptionForm.ShowModal=mrOK then
  begin
   Options.SaveToFile(folders.OptFile);
   Options.checkImportant;
   PC_OptionsUpdated(HKO_BigVisible);
  end;
 finally
  FreeAndNil(OptionForm);
 end;
end;

procedure TItemMod.OptionsActionExecute(Sender: TObject);
begin
 PR_ShowOptions(-1,-1);
 FTPMod.UpdateRecommendedModes;
end;

procedure TItemMod.ToggleBreakActionExecute(Sender: TObject);
begin
 EditorForm.ToggleBreakPoint;
end;

procedure TItemMod.PodExtractorActionExecute(Sender: TObject);
var
 SI : TScriptInfo;
begin
 Si:=ActiveScriptInfo;
 if not assigned(PodViewerForm) then
  PodViewerForm:=TPodViewerForm.create(Application);
 PodViewerForm.show;
 if assigned(si) then 
  podViewerForm.ExtractPod(si.path);
end;

procedure TItemMod.ListSubActionExecute(Sender: TObject);
var s:string;
begin
 if ComboInput(s,'ListSub','List subroutines',
              'Enter search pattern:',510) then
 begin
  s:=Debmod.ListSubNames(s);
  if s<>'' then VIewStringForm(s,'List Subroutine Names','ListSubNames');
 end;
end;

procedure TItemMod.PackageVarsActionExecute(Sender: TObject);
var s:string;
begin
 if ComboInput(s,'PackVars','Package Variables',
              'Enter package:',510) then
 begin
  s:=Debmod.PackageVars(s,'');
  if s<>'' then VIewStringForm(s,'Package Variables','PackVariables');
 end;
end;

procedure TItemMod.MethodsCallActionExecute(Sender: TObject);
var s:string;
begin
 if ComboInput(s,'MethodsCall','Methods Callable',
              'Enter class:',510) then
 begin
  s:=Debmod.MethodsCall(s);
  if s<>'' then VIewStringForm(s,'Methods Callable','MethodsCall');
 end;
end;

procedure TItemMod.EvaluateVarActionExecute(Sender: TObject);
begin
 if  not assigned(EvalExpForm) then
  EvalExpForm:=TEvalExpForm.create(Application);
 EvalExpForm.show;
end;

procedure TItemMod.RemoteSessionsActionExecute(Sender: TObject);
begin
 FTPSessionsForm:=TFTPSessionsForm.Create(Application);
 try
  FTPSessionsForm.ShowModal;
 finally
  FTPSessionsForm.Free;
 end;
end;

procedure TItemMod.PutActions;
var
 i,j:integer;
 s:string;
 sl:TStringList;
begin
 sl:=TStringList.create;
 sl.Sorted:=true;
 sl.CaseSensitive:=false;
 sl.Duplicates:=dupError;

 with ItemMod.ItemList do
  for i:=0 to actioncount-1 do
   sl.addobject(actions[i].Name,actions[i]);

 with ProjectForm.ActionList do
 for i:=0 to actioncount-1 do
  sl.addobject(actions[i].Name,actions[i]);

 with EditorForm.FileActionList do
 for i:=0 to actioncount-1 do
  sl.addobject(actions[i].Name,actions[i]);

 with QueryForm.ActionList do
 for i:=0 to actioncount-1 do
  sl.addobject(actions[i].Name,actions[i]);

 {$IFDEF OLE}
 sl.AddObject(plugmod.ActionList.Actions[0].name,plugmod.ActionList.Actions[0]);
 //add the "update plug-in" action. Nothing else!
 {$ENDIF}


 with OptiMainForm.barmanager do
 begin
  Generallockupdate:=true;
  for i:=0 to ItemCount -1 do
   if ((items[i] is TdxBarButton) or (items[i] is TDxBarStatic)) and
       (not StringStartsWith('Tool',items[i].Name)) and
       (not StringStartsWith('bpi_',items[i].Name)) then
  begin
   try
    s:=copyFromToEnd(items[i].Name,2);
    j:=sl.IndexOf(s);
    if j>=0 then
     begin
      items[i].Action:=TAction(sl.Objects[j]);
      sl.Delete(j);
     end
    else
     showmessage('Problem: '+s);
   except on exception do
    showmessage('Could not load action '+s);
   end;
  end;
  GeneralLockUpdate:=false;
 end;
 if sl.Count>0 then
  showmessage(sl.text);
 sl.free;

 with OptiMainForm.barmanager do
 begin
  for i:=0 to ItemCount -1 do
   if assigned(items[i].action) then
    Items[i].Description:=TAction(items[i].Action).Hint;
 end;
end;

procedure TItemMod.DataModuleCreate(Sender: TObject);
var
 i : Integer;
{$IFDEF SAVEDEBUGFILES}
 sl : TStringList;
 j : Integer;
 {$ENDIF}
begin
 PR_DoErrorChecking:=_DoErrorChecking;
 PR_GetServerPort:=_GetServerPort;
 PR_BeforeCustomize:=_BeforeCustomize;
 PR_UpdateCallStack:=_UpdateCallStack;
 PR_ShouldUpdateCallStack:=_ShouldUpdateCallStack;
 PR_RootServerUpdated:=_RootServerUpdated;
 PR_ShowOptions:=_ShowOptions;
 PR_DoBreakConditions:=_DoBreakConditions;
 PR_OpenInPodViewer:=_OpenInPodViewer;
 PC_ItemMod_OptionsUpdated:=_OptionsUpdated;
 PR_DoOldTodo:=_DoOldTodo;
 PC_ItemMod_Terminating:=_Terminating;
 PR_SearchForWord:=_SearchForWord;
 PR_ActiveHTTPAddress:=_ActiveHTTPAddress;
 PR_BreakpointsEnabled:=_BreakpointsEnabled;
 PR_InternalServerRunning:=_InternalServerRunning;

 PV_SetDebuggerProcs(true);

 DebMod:=LDebMod;

 HelpRouter.Helpfile:=Application.HelpFile;

 ActiveEdit.actions[eaCopy]:=CopyAction;
 ActiveEdit.actions[eaPaste]:=PasteAction;
 ActiveEdit.actions[eaCut]:=CutAction;
 ActiveEdit.actions[eaSelectAll]:=SelectAllAction;
 ActiveEdit.actions[eaUndo]:=UndoAction;
 ActiveEdit.actions[eaRedo]:=RedoAction;
 ActiveEdit.actions[edDelete]:=DeleteAction;

 LoadWindow;
 LastOptiMode:=omEdit;
 SetTextStyleCaptions;
 mainServerMod.OnServerStatus:=EditorForm.OnServerStatus;
 mainServerMod.OnClientRequest:=WebOnRequest;
 mainServerMod.OnServerResponse:=WebOnResponse;
 WebBrowserForm.memOutput.TextStyles.Assign(editorForm.memEditor.TextStyles);
 dcsystem.RegistryKey:='Software\Xarka\OptiPerl';
 HK_ReplUnit.OnFindClose:=OnFindClose;
 HK_ReplUnit.OnPositionItemClick:=OnPositionItemClick;

 SearUnit.inifile:=Folders.IniFile;
 ReplUnit.inifile:=Folders.IniFile;

 LDebMod.OnStatusChange:=EditorForm.onStat;
 RDebMod.OnStatusChange:=EditorForm.onStat;
 EditorForm.OnStat(sender);

 if OptiRel=orStan then
 begin
  AddToWatchAction.Enabled:=False;
  AddToWatchAction.Visible:=False;
  with ItemList do
   for i:=0 to ActionCount -1 do
    if Actions[i].Category='Debug' then
    begin
     THKAction(Actions[i]).Enabled:=false;
     THKAction(Actions[i]).visible:=false;
    end;
 end;

 if paramstr(1)<>'/e6' then
 begin
  LoadHTMLHelp;
  ApacheDocAction.Enabled:=
   Fileexists(folders.ApacheHelpFile) and (HHVersionOK);
  PerlDocAction.Enabled:=
   Fileexists(folders.HTMLHelpFile) and (HHVersionOK);
  SearchDocsAction.Enabled:=PerlDocAction.Enabled;
 end; 

 {$IFDEF UNREG}
  ApacheDocAction.Enabled:=false;
 {$ENDIF}

 EditorBigAction.Enabled:=true;
 BrowserBigAction.Enabled:=true;

 ToggleIMEAction.Visible:=Screen.Imes.Count>0;

 setlength(ActionArray,5);
 ActionArray[2]:=editorForm.FileActionList;
 ActionArray[1]:=ProjectForm.ActionList;
 ActionArray[0]:=ItemList;
 ActionArray[3]:=ConfToolForm.ToolsList;
 ActionArray[4]:=QueryForm.ActionList;
 {$IFDEF OLE}
 setlength(ActionArray,6);
 ActionArray[5]:=PlugMod.ActionList;
 {$ENDIF}

 {$IFDEF SAVEDEBUGFILES}
  sl:=TStringList.Create;
  for i:=0 to high(ActionArray) do
   for j:=0 to ActionArray[i].actioncount-1 do
    with TAction(ActionArray[i].Actions[j]) do
     sl.add(ActionArray[i].Name+'.'+name+#9+caption+#9+classname+#9+boolToStr(visible));
  sl.SaveToFile('c:\OptiActions.txt');
  sl.free;
 {$ENDIF}

 GetDefaultShortcuts(ActionArray);
 LoadShortCuts(ActionArray,folders.ShortcutFile);

 {Load code templates}
 TemplateForm:=TTemplateform.create(Application);
 TemplateForm.free;

 PutActions;
end;

procedure TItemMod.URLEncodeActionExecute(Sender: TObject);
begin
 if not assigned(URLEncodeForm)
  then URLEncodeForm:=TURLEncodeForm.create(Application)
  else URLEncodeForm.updateText;
 URLEncodeForm.show;
end;

procedure TItemMod._RootServerUpdated;
begin
  ServerMdl.webroot:=Options.rootdir;
  ServerMdl.Alias:=options.IntServerAliases;
end;

procedure TItemMod._OpenInPodViewer(Const Data : String);
begin
  if not assigned(PodViewerForm) then
   PodViewerForm:=TPodViewerForm.create(Application);
  PodViewerForm.show;
  podViewerForm.extractpod(data);
end;

procedure TItemMod._OptionsUpdated(Level : Integer);
var
 i:integer;
begin
  with screen do
  if OPtions.HintEditorFont then
   begin
    HintFont.Name:=options.FontName;
    HintFont.Size:=options.FontSize;
   end
  else
   begin
    HintFont.Name:=HintFontOrgName;
    HintFont.Size:=HintFontOrgSize;
   end;
  OPtions.FindOutSimpleMemo;
  UpdateModSearchPaths;

  for i:=0 to FTPMod.Sessions.Count-1 do
   with TBaseTransfer(FTPMod.sessions.Objects[i]) do
   begin
    KeepAliveTimer.Enabled:=options.SessionKeepAliveInterval>0;
    KeepAliveTimer.Interval:=options.SessionKeepAliveInterval*1000;
   end;
   
  PR_RootServerUpdated;
  HKWebFind.MaxItems:=options.RecentItems;
  HK_replunit.MaxItems:=options.RecentItems;
  SetTextStyleCaptions;
  if (level=HKO_BigVisible) or (level=HKO_LiteVisible) then
   UpdateAllMemos;
end;

procedure TItemMod._Terminating;
begin
 WebBrowserForm.TermBrowser;
 mainServerMod.OnServerStatus:=nil;
 mainServerMod.OnClientRequest:=nil;
 mainServerMod.OnServerResponse:=nil;
 if InternalServerAction.Checked then
 begin
  HKWebBrowser.WebBrowserPanic:=True;
  MainServerMod.Stop;
 end;
 HTTPProxy.SetHTTPProxy(false,nil);
 SaveShortCuts(ActionArray,folders.ShortcutFile);
end;

procedure TItemMod._SearchForWord(Const Data : String);
begin
 if Length(string(data))>0
  then DIsplayIndex(folders.htmlhelpfile+'>Favorites',data)
  else PerlDocAction.SimpleExecute;
end;

procedure TItemMod._DoErrorChecking;
begin
 DoTestErrors(false);
end;

procedure TItemMod._DoBreakConditions;
begin
 BreakConditionAction.SimpleExecute;
end;

procedure TItemMod._DoOldTodo(ms: TMemoryStream; Sl : TStrings);
var
 todo : TTodoForm;
begin
 Todo:=TTodoForm.create(Application);
 todo.VST.Clear;
 ms.Position:=0;
 todo.VST.LoadFromStream(ms);
 todo.DoSaveList(sl);
 todo.free;
end;

procedure TItemMod.SetTextStyleCaptions;
begin
 TextStyle1.caption:=Options.ts[0].name;
 TextStyle2.caption:=Options.ts[1].name;
 TextStyle3.caption:=Options.ts[2].name;
 TextStyle4.caption:=Options.ts[3].name;
 TextStyle5.caption:=Options.ts[4].name;
end;

procedure TItemMod.LoadWindow;
begin
 with OptiMainForm.WindowList do
 begin
  addobject('PerlInfoForm',PerlInfoAction);
  addobject('URLEncodeForm',URLEncodeAction);
  addobject('WatchForm',OpenWatchesAction);
  addobject('TodoForm',OpenTodoListAction);
  addobject('PerlPrinterForm',PerlPrinterAction);
  addobject('AccessLogForm',OpenAccessLogsAction);
  addobject('ErrorLogForm',OpenErrorLogsAction);
  addobject('RegExpTesterForm',RegExpTesterAction);

  addobject('SecEditForm0',NewEditWinAction);
  addobject('SecEditForm1',nil);
  addobject('SecEditForm2',nil);
  addobject('SecEditForm3',nil);

  addobject('FileCompareForm',FileCompareAction);
  addobject('FileExploreForm',FileExplorerAction);
  addobject('EvalExpForm',EvaluateVarAction);
  addobject('FTPSelectForm',RemoteExplorerAction);
  addobject('AutoViewForm',OpenAutoViewAction);
  addobject('CallStack',CallStackAction);
 end;
end;

procedure TItemMod.CallStackActionExecute(Sender: TObject);
begin
 if assigned(debMod) and (debCallStack in debmod.debactions) then
  DebMod.EvaluateCallStack;
 VIewStringForm(CustDebMdl.CallStack.Text,'Call Stack','CallStack');
end;

procedure TItemMod._UpdateCallStack;
begin
 UpdateStringForm(CustDebMdl.CallStack.Text,'CallStack');
end;

Function TItemMod._ShouldUpdateCallStack : Boolean;
begin
 result:=OptiMainForm.dcCallStack.Tag<>0;
end;

procedure TItemMod.RefreshActionUpdate(Sender: TObject);
begin
 RefreshAction.Enabled:=assigned(WebBrowserForm) and WebBrowserForm.RefreshEnable;
end;

procedure TItemMod.OpenWatchesActionExecute(Sender: TObject);
begin
 if OptiRel=orStan then exit;
 if not assigned(WatchForm) then
  WatchForm:=TWatchForm.create(Application);
 WatchForm.show;
 Debmod.EvaluateWatches;
end;

procedure TItemMod.OpenTodoListActionExecute(Sender: TObject);
begin
 if not Assigned(TodoForm) then
  TodoForm:=TTodoForm.Create(Application);
 TodoForm.show;
end;

procedure TItemMod.ToggleBreakActionUpdate(Sender: TObject);
begin
 ToggleBreakAction.Enabled:=assigned(DebMod) and (debToggleBreakpoint in Debmod.debactions)
  and assigned(ActiveScriptInfo) and (ActiveScriptInfo.IsPerl);
end;

procedure TItemMod.PerlPrinterActionExecute(Sender: TObject);
begin
 if not Assigned(PerlPrinterForm) then
  PerlPrinterForm:=TPerlPrinterForm.Create(Application);
 PerlPrinterForm.show;
end;

Function TItemMod._BreakpointsEnabled : Boolean;
begin
 ToggleBreakAction.Update;
 result:=ToggleBreakAction.enabled;
end;

Function TItemMod._InternalServerRunning : Boolean;
begin
 InternalServerAction.Update;
 result:=(InternalServerAction.Enabled) and (InternalServerAction.Checked);
end;

procedure TItemMod.ChangeRootActionUpdate(Sender: TObject);
begin
 ChangeRootAction.Enabled:=InternalServerAction.Enabled;
end;

procedure TItemMod.OpenAccessLogsActionExecute(Sender: TObject);
begin
 OpenLogWindow(ltAccess);
end;

procedure TItemMod.OpenErrorLogsActionExecute(Sender: TObject);
begin
 OpenLogWindow(ltError);
end;

procedure TItemMod.TrueIfActivePerlActionUpdate(Sender: TObject);
begin
 if Sender is THKAction then
  THKAction(Sender).Enabled:=(assigned(ActiveScriptInfo)) and ActiveScriptInfo.isPerl;
end;

procedure TItemMod.PerlDocActionExecute(Sender: TObject);
begin
 if fileexists(Folders.htmlhelpfile) then
  DisplayTOC(Folders.HtmlHelpFile+'>Favorites');
end;

procedure TItemMod.AutoEvaluationActionUpdate(Sender: TObject);
begin
 AutoEvaluationAction.Checked:=OPtions.autoevaluation;
end;

procedure TItemMod.AutoEvaluationActionExecute(Sender: TObject);
begin
 OPtions.autoevaluation:=not OPtions.autoevaluation;
end;

procedure TItemMod.HaulBrowserActionExecute(Sender: TObject);
begin
 try
  screen.cursor:=crHourGlass;
  try
   webBrowserForm.FlashTimer.Enabled:=false;
   WebBrowserForm.Timer.Enabled:=false;
   HKWebBrowser.WebBrowserPanic:=True;
   WebBrowserForm.WebBrowser.Stop;

   KillAllExeNames(extractfilename(Options.pathtoperl));

   Pr_ShowWebs(false);
   try
    WebBrowserForm.TermBrowser;
    FreeAndNil(WebBrowserForm);
    WebBrowserForm:=TWebBrowserForm.Create(Application);
   finally
    pr_ShowWebs(true);
   end;
  finally
   screen.cursor:=crDefault;
  end;
 except end; //local.mail@lyl-canbys.de2.elf
end;

procedure TItemMod.AddToWatchActionExecute(Sender: TObject);
var w:string;
begin
 if OptiRel=orStan then exit;

 w:=PR_WordUnderCarret;
 if w='' then Exit;

 if not assigned(WatchForm) then
  WatchForm:=TWatchForm.create(Application);
 WatchForm.show;

 WatchForm.AddUser(w,true,True);
end;

procedure TItemMod.RegExpTesterActionExecute(Sender: TObject);
begin
 if not assigned(RegExpForm) then
  RegExpForm:=TRegExpTesterForm.create(application);
 RegExpForm.show;
end;

procedure TItemMod.MatchBracketActionExecute(Sender: TObject);
begin
 EditorForm.getmatching(false);
end;

procedure TItemMod.MatchBracketSelectActionExecute(Sender: TObject);
begin
 EditorForm.getmatching(true);
end;

procedure TItemMod.PerlTidyActionExecute(Sender: TObject);
begin
 if isUNCPath(ActiveScriptInfo.path) then
 begin
  MessageDlg('Filename must be local, cannot continue.', mtError, [mbOK], 0);
  exit;
 end;

 PR_QuickSave;
 PerlTidyForm:=TPerlTidyForm.Create(Application);
 PerlTidyForm.memOut.TextStyles:=editorform.memeditor.TextStyles;
 with PerlTidyForm do begin
  FileName:=ActiveScriptInfo.path;
  if ShowModal=mrOK then
   if ActiveScriptInfo.GetReadonly
    then MessageDlg('Cannot modify read only file.', mtError, [mbOK], 0)
    else editorFOrm.memEditor.Lines.Text:=Output;
  Free;
 end;
end;

procedure TItemMod.NewEditWinActionExecute(Sender: TObject);
begin
 CreateSecEdit;
end;

procedure TItemMod.NewEditWinActionUpdate(Sender: TObject);
begin
 NewEditWinAction.enabled:=SecEditAvailable;
end;

procedure TItemMod.ProfilerActionExecute(Sender: TObject);
begin
 //TODO -cImplement: Implement profiler
end;

procedure TItemMod.FindDeclarationActionExecute(Sender: TObject);
begin
 PR_FindDeclaration(PR_WordUnderCarret);
end;

procedure TItemMod.FileCompareActionExecute(Sender: TObject);
begin
 if not assigned(FileCompareForm) then
  FileCompareForm:=TFileCompareForm.create(Application);
 FilecompareForm.show;
end;

procedure TItemMod.InternetOptionsActionExecute(Sender: TObject);
begin
 ControlPanelOpen('shell32.dll,Control_RunDLL inetcpl.cpl,,0');
end;

procedure TItemMod.FileExplorerActionExecute(Sender: TObject);
begin
 if not assigned(FileExploreForm) then
  FileExploreForm:=tFileExploreForm.Create(application);
 FileExploreForm.sHOW;
end;

procedure TItemMod.CommentToggleActionUpdate(Sender: TObject);
const
 caption : array [false..true] of string = ('Line','Block');
begin
 CommentToggleAction.Caption:='&Toggle Comment on '+caption[not EditorFOrm.memEditor.MemoSource.IsSelectionEmpty];
 CommentToggleAction.Enabled:=(assigned(ActiveScriptInfo)) and ActiveEdit.IsMainActive and (not activescriptinfo.ms.ReadOnly);
end;

procedure TItemMod.CommentToggleActionExecute(Sender: TObject);
begin
 EditorForm.DoComment(ccToggle);
end;

procedure TItemMod.RunSecBrowserActionExecute(Sender: TObject);
begin
 UploadIfDirty;
 PR_RunScriptExtSec;
end;

procedure TItemMod.RunSecBrowserActionUpdate(Sender: TObject);
begin
 with Options do begin
  RunSecBrowserAction.Visible:=SecondBrowser<>'';
  if SecondBrowser<>'' then
   runSecBrowserAction.caption:=
    'Run in '+FirstCase(ExtractFileNoExt(SecondBrowser));
 end;
end;

procedure TItemMod.SyncScrollActionExecute(Sender: TObject);
begin
 Options.SyncScroll:=not Options.SyncScroll;
end;

procedure TItemMod.SyncScrollActionUpdate(Sender: TObject);
begin
 SyncScrollAction.Checked:=options.SyncScroll;
end;

procedure TItemMod.EditShortCutActionExecute(Sender: TObject);
begin
 PR_BeforeCustomize;
 EditActionShortcuts(ActionArray,6650);
end;

procedure TItemMod.FindSubActionExecute(Sender: TObject);
begin
 ExplorerForm.Show;
 Pr_HighLightSub(editorForm.memEditor.MemoSource.CaretPoint.y,true);
end;

procedure TItemMod.TestErrorActionUpdate(Sender: TObject);
var b:boolean;
begin
 b:=(assigned(ActiveScriptInfo)) and (ActiveScriptInfo.IsPerl);
 if (b) and (assigned(statusForm)) then
  b:=(not StatusForm.ErrorCheck.Checking);
 THKAction(Sender).Enabled:=b;
end;

procedure TItemMod.ScrollTabActionExecute(Sender: TObject);
begin
 with WebBrowserForm do
  if Visible then
   PageControl.SelectNextPage(true);
end;

procedure TItemMod.ApplicationEventsMessage(var Msg: tagMSG;
  var Handled: Boolean);
begin
 //Disable Ctrl-F ...
 if (msg.message=WM_KEYDOWN) and
    (msg.wParam and $FFFF = 70) and
    ( (GetKeyState(VK_CONTROL) and not $7FFF) <> 0) and
    (
    (mainWebForm.WebFocused) or (PodWebForm.WebFocused) or
    ((assigned(CheckUpdateForm)) and (CheckUpdateForm.active))
    )
 then
  handled:=true;
end;

procedure TItemMod.IndentActionExecute(Sender: TObject);
begin
 ActiveEdit.Memo.MemoSource.IndentBlock;
end;

procedure TItemMod.OutdentActionExecute(Sender: TObject);
begin
 ActiveEdit.Memo.MemoSource.OutdentBlock;
end;


procedure TItemMod.CommentInActionExecute(Sender: TObject);
begin
 editorForm.DoComment(ccAdd);
end;

procedure TItemMod.CommentOutActionExecute(Sender: TObject);
begin
 editorForm.DoComment(ccRemove);
end;

procedure TItemMod.CommentInActionUpdate(Sender: TObject);
const
 caption : array [false..true] of string = ('Line','Block');
begin
 CommentInAction.Caption:='&Add Comment to '+caption[not EditorFOrm.memEditor.MemoSource.isselectionEmpty];
 CommentInAction.Enabled:=(assigned(ActiveScriptInfo)) and ActiveEdit.IsMainActive and (not activescriptinfo.ms.ReadOnly);
end;

procedure TItemMod.CommentOutActionUpdate(Sender: TObject);
const
 caption : array [false..true] of string = ('Line','Block');
begin
 CommentoutAction.Caption:='&Remove Comment from '+caption[not EditorFOrm.memEditor.MemoSource.isselectionEmpty];
 CommentOutAction.Enabled:=(assigned(ActiveScriptInfo)) and ActiveEdit.IsMainActive and (not activescriptinfo.ms.ReadOnly);
end;

procedure TItemMod.SearchDocsActionExecute(Sender: TObject);
begin
 PR_searchForWord(PR_WordUnderCarret);
end;

procedure TItemMod.TogBookmarkActionExecute(Sender: TObject);
var
 y,n : integer;
begin
 n:=(sender as THKAction).tag;
 EditorForm.memEditor.MemoSource.ToggleBookMark(n);
 y:=EditorForm.memEditor.MemoSource.CaretPoint.Y;
 if EditorForm.memEditor.MemoSource.BookMark[y]>0 then
  ExplorerForm.AddBookmark(activescriptinfo.path,y,n);
end;

procedure TItemMod.GotoBookmarkActionExecute(Sender: TObject);
begin
 EditorForm.memEditor.MemoSource.GoToBookmark((sender as THKAction).tag);
end;

procedure TItemMod.SelectStartPathActionExecute(Sender: TObject);
var
 sl : TStringList;
 s:string;
begin
 MessageDlgMemo('Changing the starting path might render useless any'+#13+#10+'relative paths to files. If you are having any problems,'+#13+#10+'please select the the option "same as script".', mtWarning, [mbOK], 0,2000);
 s:=options.StartPath;
 if not BrowseForFolder('Select Starting path:',true,s) then exit;
 Sl:=TStringList.Create;
 try
  sl.Text:=Options.StartPathList;
  SmartStringsAdd(sl,s);
  Options.StartPathList:=sl.Text;
  Options.StartPath:=s;
 finally
  sl.Free;
 end;
end;

procedure TItemMod.SameAsScriptPathActionExecute(Sender: TObject);
begin
 Options.StartPath:='';
end;

procedure TItemMod.SameAsScriptPathActionUpdate(Sender: TObject);
begin
 SameAsScriptPathAction.Checked:=Options.StartPath='';
end;

Function TItemMod._GetServerPort(Internal : Boolean; out folder : String) : Integer;
begin
 if (Internal) and (InternalServerAction.checked) then
  begin
   result:=options.ServerPort;
   folder:=options.RootDir;
  end
 else
 if (not internal) then
  begin
   result:=options.ExtServerPort;
   folder:=options.ExtServerRoot;
  end
 else
  result:=0;
end;

procedure TItemMod.SaveLayoutActionExecute(Sender: TObject);
var
 n : string;
begin
 n:=options.Layout;
 if inputquery('Save layout','Enter name',n) then
 begin
  options.Layout:=n;
  OptiMainForm.SaveLayout(n);
 end;
end;

procedure TItemMod.DeleteLayoutActionExecute(Sender: TObject);
begin
  DeleteFile(includetrailingbackslash(folders.UserFolder)+
   options.Layout+OptiLayoutExt);
end;


procedure TItemMod.SwapVersionActionExecute(Sender: TObject);
begin
 if ActiveScriptInfo.Getreadonly
  then begin
   MessageDlg('Cannot modify read only file.', mtError, [mbOK], 0);
   exit;
  end;
 Screen.Cursor:=crHourGlass;
 try
  if not SwapVersions(ActiveEdit.Memo.Lines) then
   MessageDlgMemo('No version converter tags found'+#13#10+
                  'Please press F1 for more information.', mtInformation, [mbOK], 580,2500);
 finally
  Screen.Cursor:=crDefault;
 end;
end;

procedure TItemMod.SwapVersionActionUpdate(Sender: TObject);
var
 s:String;
begin
 SwapVersionAction.Enabled:=ActiveEdit.IsMainActive;
 s:=EditorForm.ActiveVersion;
 if s=''
  then SwapVersionAction.Caption:='Swap version (now: none found)'
  else SwapVersionAction.caption:='Swap version (now: '+s+')';
end;

procedure TItemMod.ProxyEnableActionUpdate(Sender: TObject);
begin
 ProxyEnableAction.Checked:=HTTPProxy.IsHTTPProxyEnabled;
end;

procedure TItemMod.ProxyEnableActionExecute(Sender: TObject);
begin
 HTTPProxy.SetHTTPProxy(not HTTPProxy.IsHTTPProxyEnabled,WebOnProxyLog);
end;

procedure TItemMod.UpdateAllMemos;
var
 List : TList;
 i:integer;
begin
 List:=TList.Create;
 try
  GetAllActiveControls('TDCMemo',list);
  for i:=0 to list.Count-1 do
   Options.ApplyStyle(TDCMemo(list[i]));
 finally
  list.free;
 end;
end;

procedure TItemMod.TextStyleExecute(Sender: TObject);
begin
 OPtions.ActiveTextStyle:=THKAction(sender).tag;
 ParsersMod.SetSyntax(options);
 UpdateAllMemos;
end;

procedure TItemMod.TextStyleUpdate(Sender: TObject);
begin
 THKAction(Sender).Checked:=THKAction(sender).tag=OPtions.ActiveTextStyle;
end;

procedure TItemMod.OpenRemoteActionExecute(Sender: TObject);
begin
 FTPselectForm:=TFTPSelectForm.Create(application,dtOpen);
 try
  FTPselectForm.ShowModal;
 finally
  FTPSelectForm.Free;
 end;
end;

procedure TItemMod.IsRemoteActionUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled:=(Assigned(ActiveScriptInfo)) and
             (ActiveScriptInfo.GetFTPSession<>'');
end;

procedure TItemMod.SaveRemoteActionAsExecute(Sender: TObject);
begin
 PR_QuickSave;
 FTPselectForm:=TFTPSelectForm.Create(application,dtSave);
 try
  FTPselectForm.ShowModal;
 finally
  FTPSelectForm.Free;
 end;
end;

procedure TItemMod.UploadIfDirty;
begin
 if (options.RunRemUpload) and (options.RunWithServer) and
    (assigned(ActiveScriptInfo)) and
    (activeScriptInfo.GetFTPSession<>'') and
    (activeScriptInfo.FTPModified) then
 begin
  FTPMod.UploadActive;
  EditorForm.SaveAction.SimpleExecute;
 end;
end;

procedure TItemMod.SaveRemoteActionExecute(Sender: TObject);
begin
 FTPMod.UploadActive;
 EditorForm.SaveAction.SimpleExecute;
end;

procedure TItemMod.RemoteExplorerActionExecute(Sender: TObject);
begin
 if not assigned(FTPBrowseForm) then
  FTPBrowseForm:=TFTPSelectForm.create(application,dtNone);
 FTPBrowseForm.show;
end;

procedure TItemMod.DelWordLeftExecute(Sender: TObject);
begin
 ActiveEdit.Memo.MemoSource.DeleteWordLeft;
end;

procedure TItemMod.DelWordRightExecute(Sender: TObject);
begin
 ActiveEdit.Memo.MemoSource.DeleteWordRight;
end;

procedure TItemMod.ExportCodeExplorerActionExecute(Sender: TObject);
var sl:TStringList;
begin
 sl:=TStringList.Create;
 try
  ExplorerForm.ExportCode(sl);
  EditorForm.CreateWithName(ExtractFileNoExt(ActiveScriptInfo.path)+'.txt');
  EditorForm.memEditor.Lines.assign(sl);
 finally
  sl.free;
 end;
end;

procedure TItemMod.PrintActionExecute(Sender: TObject);
begin
 PrintForm:=TPrintForm.create(application);
 try
  PrintForm.Initialize;
  try
   PrintForm.ShowModal;
  finally
   printForm.deInitialize;
  end;
 finally
  PrintForm.free;
 end;
end;

procedure TItemMod.SendMailActionExecute(Sender: TObject);
begin
 SendMailAddForm:=TSendMailAddForm.Create(Application);
 try
  SendMailAddForm.ShowModal;
 finally
  SendMailAddForm.Free;
 end;
end;

procedure TItemMod.CustToolsActionExecute(Sender: TObject);
begin
 OptiMainForm.BarManager.Customizing(true);
end;

procedure TItemMod.SetOptiMode(OM: TOptiModes);
const
 OMFiles : array[TOptiModes] of string = ('Edit','Debug','Run');
begin
 if (not options.StandardLayouts) or (GetKeyState(VK_PAUSE) < 0) then
  exit;

 if LastOptiMode<>OM then
 begin
  if (OM=omRun) and (debmod=rdebmod) then exit;
  Pr_LoadLayout(OMFiles[OM]);
  if OM=omEdit then
   SafeFocus(EditorForm.memEditor);
  LastOptiMode:=OM;
 end;

 With optimainform do
 begin
  BarManager.BarByName('Layout').Visible:=OM<>omEdit;
  Updateheight;
 end;
end;

procedure TItemMod.LoadEditLayoutActionExecute(Sender: TObject);
begin
 SetOptiMode(omEdit);
end;

procedure TItemMod.SubListActionExecute(Sender: TObject);
begin
 SubListForm:=TSubListForm.Create(Application);
 try
  SubListForm.showmodal;
 finally
  SubListForm.free;
  PR_FocusEditor;
 end;
end;

Function TItemMod.GetLocalHTTPAddress : String;
var
 i,p,Aport:integer;
 aliases : THashList;
 ARoot,AAdd,Path,AHost,s:string;
begin
 Aliases:=THashList.Create(false,false,dupIgnore);
 Path:=ActiveScriptInfo.path;
 AAdd:='';

 try
   i:=PR_GetActiveServer;
   if i=1 then
    begin
     ParsePeriodAndEqual(Options.ExtServerAliases,Aliases);
     ARoot:=Options.ExtServerRoot;
     APort:=options.ExtServerPort;
    end
   else
    begin
     ParsePeriodAndEqual(options.IntServerAliases,Aliases);
     Aroot:=Options.RootDir;
     APort:=options.ServerPort;
    end;

   i:=0;
   while (i<aliases.count) do
   begin
    s:=aliases.ValueAt(i);
    if trim(aliases.Strings[i])<>'' then
     if FileStartsWith(s,path) then break;
    inc(i);
   end;

   if i<aliases.count then
   begin
    Aroot:=Aliases.ValueAt(i);
    AAdd:=Aliases.Strings[i];
   end;

   replaceC(AAdd,'\','/');

   if isUNCPath(aroot)
    then ARoot:=IncludeTrailingAnySlash(Aroot,'/')
    else ARoot:=IncludeTrailingAnySlash(Aroot,'\');

   if AAdd<>'' then
    AAdd:=IncludeTrailingAnySlash(AAdd,'/');

   AHost:=IncludeTrailingAnySlash(options.Host,'/');
   p:=pos('://',AHost);
   if (p>0) then
   begin
    inc(p,3);
    i:=scanC(AHost,':',p);
    if (i=0) and (APort<>80) then
    begin
     i:=scanC(AHost,'/',p);
     insert(':'+INtToStr(Aport),Ahost,i);
    end;
   end;

    //now Aroot has the correct rootdir
    //and AAdd has what should be after the http://sss/Addd/

   ARoot:=FixToBackSlash(Aroot);
   path:=FixToBackSlash(path);
   result:=GetDirDiff(ARoot,path);

   result:=Ahost+AAdd+result;
   replaceC(result,'\','/');
   replaceSC(result,'//','/',false);
   replaceSC(result,':/','://',false);
 finally
  aliases.free;
 end;
end;

Function TItemMod.GetRemoteHTTPAddress(Const Session : String) : String;
var
 i:integer;
 aliases : THashList;
 Path,AHost,s:string;
begin
 Path:=ActiveScriptInfo.path;
 Aliases:=THashList.Create(false,false,dupIgnore);

 try
  ParsePeriodAndEqual(FTPMod.TransTableAliases.Value,aliases);
  Aliases.Add(FTPMod.TransTableDocRoot.Value,FTPMod.TransTableLinksTo.Value);
  i:=0;
  while (i<aliases.count) do
  begin
   s:=Aliases.Strings[i];
   if trim(s)<>'' then
   begin
    replaceC(s,'/','\');
    s:=ExcludeTrailingBackSlash(s);
    if (s='') or (s[1]<>'\') then
     s:='\'+s;
    s:=Folders.ftpfolder+session+s;
    if FileStartsWith(s,path) then break;
   end;
   inc(i);
  end;

  if i>=aliases.Count
   then s:=folders.FTPFolder+session;

  delete(path,1,length(excludeTrailingBackSlash(s))+1);

  if i<aliases.count
   then AHost:=aliases.ValueAt(i)
   else AHost:=FTPMod.TransTableLinksTo.value;

  AHost:=IncludeTrailingSlash(AHost);
  result:=AHost+path;
  replaceC(result,'\','/');
  replaceSC(result,'//','/',false);
  replaceSC(result,':/','://',false);
 finally
  aliases.free;
 end;
end;

Function TItemMod._ActiveHTTPAddress : String;
var
 Session:string;
begin
 Session:=ActiveScriptInfo.GetFTPSession;
 if (session='') or (not FTPMod.TransTable.FindKey([session]))
  then result:=GetLocalHTTPAddress
  else result:=GetRemoteHttpAddress(session);
end;

procedure TItemMod.ApacheDocActionExecute(Sender: TObject);
begin
 if fileexists(Folders.Apachehelpfile) then
  DisplayTOC(Folders.ApacheHelpFile+'>Favorites');
end;

procedure TItemMod.RemDebSetupActionExecute(Sender: TObject);
begin
 RemDebInfoForm:=TRemDebInfoForm.create(Application);
 RemDebInfoForm.loaded:=not startremdebaction.Enabled;
 try
  RemDebInfoForm.showmodal;
 finally
  RemDebInfoForm.free;
 end;
end;

procedure TItemMod.OpenCacheActionExecute(Sender: TObject);
var s:string;
begin
 if directoryexists(folders.FTPFolder) then
 begin
  s:=EditorForm.OpenDialog.InitialDir;
  EditorForm.OpenDialog.FileName:='';
  EditorForm.OpenDialog.InitialDir:=folders.FTPFolder;
  EditorForm.OpenAction.SimpleExecute;
  EditorForm.OpenDialog.InitialDir:=s;
 end;
end;

procedure TItemMod.EnIFMainMemoEnabled(Sender: TObject);
begin
 THKAction(Sender).enabled:=ActiveEdit.IsMainActive;
end;

procedure TItemMod.BookmarkActionUpdate(Sender: TObject);
begin
 THKAction(Sender).Enabled:=ActiveEdit.IsMainActive;
end;

procedure TItemMod.EnIFAnyMemoActive(Sender: TObject);
begin
 THKAction(Sender).Enabled:=ActiveEdit.IsMemoActive;
end;

procedure TItemMod.OnFindClose(sender: TObject);
begin
 PR_FocusEditor;
end;

procedure TItemMod.OnPositionItemClick(Sender : TObject; Const Pat : String; CaseSens : Boolean; Index : Integer);
begin
 PR_setPattern(index,pat,CaseSens);
end;

procedure TItemMod.ToggleIMEActionExecute(Sender: TObject);
var
 H: hImc;
 en : boolean;
begin
 h:=ImmGetContext(Application.Handle);
 en:=not ImmGetOpenStatus(h);
 ImmSetOpenStatus(H,en);
 ImmReleaseContext(Application.Handle,H);
end;

procedure TItemMod.WebOnProxyLog(Sender: TObject; const Log: String);
begin
 if assigned(WebBrowserForm) then
  WebBrowserForm.OnProxyLog(Sender,log);
end;

procedure TItemMod.WebOnRequest(Sender: TObject; const Status: string);
begin
 if assigned(WebBrowserForm) then
  WebBrowserForm.OnRequest(Sender,Status);
end;

procedure TItemMod.WebOnResponse(Sender: TObject; const Status: string);
begin
 if assigned(WebBrowserForm) then
  WebBrowserForm.OnResponse(Sender,Status);
end;

procedure TItemMod.OpenAutoViewActionExecute(Sender: TObject);
begin
 if not assigned(AutoViewForm) then
  AutoViewForm:=TAutoViewForm.create(Application);
 AutoViewForm.show;
end;

procedure TItemMod.WinArrangeActionExecute(Sender: TObject);
begin
 PR_ArrangeWindows(TAction(sender).Tag);
end;

procedure TItemMod.NextWindowActionExecute(Sender: TObject);
begin
 PR_DoNextWin;
end;

procedure TItemMod.ReloadRemoteActionExecute(Sender: TObject);
begin
 if ActiveScriptInfo.FTPModified then
  if (mrYes<>MessageDlg('This function will reload the file from the remote server.'+#13+#10+'Changes on the local file will be lost. Proceed?', mtConfirmation, [mbYes, mbCancel], 0))
    then exit;

 FTPMod.DownloadFile(ActiveScriptInfo.GetFTPSession,ActiveScriptInfo.GetFTPFolder,
  ExtractFilename(ActiveScriptINfo.path),ActiveScriptINfo.path);

 PR_ReloadActive;
end;

procedure TItemMod.SaveAllRemoteActionExecute(Sender: TObject);
begin
 //TODO -cImplement: Implement Saving all remote files
end;

procedure TItemMod.EditColorActionExecute(Sender: TObject);
var
 c:integer;
 s:string;
 p : TPoint;
begin
 if assigned(activeScriptInfo) and assigned(activeScriptInfo.ms) then
 begin
  p:=activeScriptInfo.ms.CaretPoint;
  s:=activeScriptInfo.ms.StringItem[p.y].ColorData;
  inc(p.x);
  if length(s)>=p.X
   then c:=ord(s[p.x])
   else c:=0;
  PR_ShowOptions(c,-1);
 end; 
end;

procedure TItemMod.DelCharLeftActionExecute(Sender: TObject);
begin
 ActiveEdit.Memo.MemoSource.DeleteCharLeft;
end;

procedure TItemMod.DelCharRightActionExecute(Sender: TObject);
begin
 ActiveEdit.Memo.MemoSource.DeleteCharRight;
end;

procedure TItemMod.DelCharRightVIActionExecute(Sender: TObject);
var l : Integer;
begin
 with ActiveEdit.Memo.MemoSource do
 begin
  l:=length(lines[caretpoint.y]);
  if l=0 then exit;
  if caretpoint.X+1>l
   then DeleteCharLeft
   else DeleteCharRight
 end;
end;

procedure TItemMod.DelWholeLineActionExecute(Sender: TObject);
begin
 ActiveEdit.Memo.MemoSource.DeleteLine;
end;

procedure TItemMod.DeleteLineBreakActionExecute(Sender: TObject);
begin
 ActiveEdit.Memo.memosource.JoinLines2;
end;

procedure TItemMod.InsertNewLineActionExecute(Sender: TObject);
begin
 activeedit.Memo.MemoSource.InsertLine2;
end;

procedure TItemMod.DuplicateLineActonExecute(Sender: TObject);
begin
 activeedit.Memo.MemoSource.DuplicateLineAbove;
end;

procedure TItemMod.SelectLineActionExecute(Sender: TObject);
begin
 with activeedit.Memo.memosource do
  SetSelection(stStreamSel,0,caretpoint.y,0,caretpoint.y+1);
end;

procedure TItemMod.DeleteToEOLActionExecute(Sender: TObject);
begin
 activeedit.Memo.memosource.DeleteToLineEnd;
end;

procedure TItemMod.DeleteToStartActionExecute(Sender: TObject);
begin
 activeedit.Memo.memosource.DeleteToLineBegin;
end;

procedure TItemMod.DeleteWordActionExecute(Sender: TObject);
begin
 activeedit.Memo.memosource.DeleteWord;
end;

procedure TItemMod.ToggleSelOptionActionExecute(Sender: TObject);
begin
 with activeedit.memo.MemoSource do
  if BlockOption=bkBlockSel
   then BlockOption:=bkBoth
   else BlockOption:=bkBlockSel;
end;

procedure TItemMod.ToggleSelOptionActionUpdate(Sender: TObject);
begin
 with THKAction(Sender) do
 begin
  Enabled:=ActiveEdit.IsMemoActive;
  Checked:=(Enabled) and (activeedit.memo.MemoSource.BlockOption=bkBlockSel);
 end;
end;

procedure TItemMod.AutoSynCheckActionUpdate(Sender: TObject);
begin
 AutoSynCheckAction.Enabled:=assigned(ActiveScriptInfo) and ActiveScriptInfo.IsPerl;
 AutoSynCheckAction.Checked:=AutoSynCheckAction.Enabled and ActiveScriptInfo.DoErrorCheck;
end;

procedure TItemMod.AutoSynCheckStrippedActionExecute(Sender: TObject);
begin
 ActiveScriptInfo.DoCheckStripped:=not ActiveScriptInfo.DoCheckStripped;
end;

procedure TItemMod.AutoSynCheckStrippedActionUpdate(Sender: TObject);
begin
 AutoSynCheckStrippedAction.Enabled:=assigned(ActiveScriptInfo) and ActiveScriptInfo.IsPerl and ActiveScriptInfo.DoErrorCheck;
 AutoSynCheckStrippedAction.Visible:=AutoSynCheckStrippedAction.Enabled;
 AutoSynCheckStrippedAction.Checked:=AutoSynCheckStrippedAction.Enabled and ActiveScriptInfo.DoCheckStripped;
end;

procedure TItemMod.RedOutputActionExecute(Sender: TObject);
begin
 options.InOutRedirect:=not options.InOutRedirect;
 if (debMod=RDebMod) and (debSingleStep in debmod.DebActions) then
 begin
  if options.InOutRedirect
   then RDebMod.StartOutputCommand
   else RDebMOd.StopOutputCommand;
 end;
end;

procedure TItemMod.RedOutputActionUpdate(Sender: TObject);
begin
 RedOutputAction.Checked:=options.InOutRedirect;
end;


procedure TItemMod.AutoSynCheckActionExecute(Sender: TObject);
begin
 ActiveScriptInfo.DoErrorCheck:=not ActiveScriptInfo.DoErrorCheck;
end;

procedure TItemMod.AddToWatchActionUpdate(Sender: TObject);
begin
 AddToWatchAction.Enabled:=assigned(debmod) and (debmod.Status in [stStopped,stNotRunning])
end;

procedure TItemMod.HighDeclarationActionExecute(Sender: TObject);
var s:string;
begin
 s:=SimpleToRegExpPattern(PR_WordUnderCarret,true);
 if (length(s)>=2) and (s[2] in ['%','$','@']) then
 begin
  delete(s,1,2);
  insert('[\$@%]',s,1);
 end;
 PR_SetPattern(0,s,true);
end;

procedure TItemMod.BreakConditionActionExecute(Sender: TObject);
var
 bi : PBreakInfo;
 s:string;
begin
 bi:=PbreakInfo(ActiveScriptInfo.ms.stringItem[ActiveScriptInfo.ms.CaretPoint.Y].ObjData);
 if assigned(bi) then
 begin
  s:=bi.Condition;
  if ComboInput(s,'BreakCondition','Breakpoint Condition',
             'Enter breakpoint condition:',0) then
  begin
   bi.Condition:=s;
   PC_BreakpointsChanged;
  end;
 end;
end;

procedure TItemMod.BreakConditionActionUpdate(Sender: TObject);
var
 b:boolean;
 i:integer;
begin
 b:=ActiveEdit.IsMainActive and assigned(ActiveScriptInfo) and assigned(ActiveScriptInfo.ms);
 if b then
  with ActiveScriptInfo.ms do
  begin
   i:=CaretPoint.Y;
   if i<lines.Count then
    b:=assigned(stringItem[i].ObjData);
  end;
 BreakConditionAction.Visible:=b;
 BreakConditionAction.Enabled:=b;
end;

procedure TItemMod._BeforeCustomize;
begin
 if OptiRel<>orStan then
  BreakConditionAction.visible:=true;
end;

procedure TItemMod.NextPrevSearchActionExecute(Sender: TObject);
begin
 ExplorerForm.DoGoNext(TAction(sender).Tag=1);
end;

procedure TItemMod.GotoGlobalActionExecute(Sender: TObject);
begin
 ExplorerForm.GotoBookmark((sender as THKAction).tag);
end;

procedure TItemMod.ActiveScriptDebActionExecute(Sender: TObject);
begin
 if IsSameFile(ActiveScriptInfo.path,Options.ActiveDebScript)
  then Options.ActiveDebScript:=''
  else Options.ActiveDebScript:=ActiveScriptInfo.path;
end;

procedure TItemMod.ActiveScriptDebActionUpdate(Sender: TObject);
begin
 if Options.ActiveDebScript=''
  then ActiveScriptDebAction.Caption:='Set Current as Active Script'
  else ActiveScriptDebAction.Caption:='Active: <'+extractfilenoext(Options.ActiveDebScript)+'>';
end;

initialization
 HintFontOrgName:=screen.HintFont.name;
 HintFontOrgSize:=screen.HintFont.Size;
end.