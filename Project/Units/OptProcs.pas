{***************************************************************
 *
 * Unit Name: OptProcs
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptProcs;
{$I REG.INC}

interface
uses classes,sysutils;

type
  TEmptyProc = Procedure of object;
  TEmptyProc_ = Procedure;
  TStringProc = Procedure(const Str: String) of object;
  TBoolProc  = Procedure(Bool: Boolean) of object;
  T2BoolProc  = Procedure(Bool1,Bool2: Boolean) of object;
  TObjProc  = Procedure(Sender : TObject) of object;
  TIntegerProc  = Procedure(Int : Integer) of object;
  TIntegerProc_  = Procedure(Int : Integer);
  TIntegerFunc  = Function(Int : Integer) : Boolean of object;
  TStr2BoolFunc = Function(const Str: String) : Boolean of object;
  TNil2StringFunc  = Function : String of object;
  TNil2BoolFunc = Function : Boolean of object;
  TNil2IntFunc = Function : Integer of object;
  TUpdateSyntaxErrorsProc = Procedure(Errors : TStrings; Status : Integer) of object;
  THighLightSubProc = Procedure(line : Integer; Focus : Boolean) of object;
  TSyncScroll = Procedure(CharPos,LinePos : Integer; Const Path : String; Sender : TObject) of object;
  TPipeTool = procedure (Command : Integer; SL : TStringList; Active : TObject) of object;


const
  //OptionsUpdated valud
  HKO_Lite = 0;  //Simple, fast & no code that should be done in an automation method
  HKO_LiteVisible = 1; //As above but all memos also
  HKO_Big = 2; //Simple
  HKO_BigVisible = 3; //Everything

  //Pipe Tool
  HKP_SEND_FILE = 1;
  HKP_GET_FILE = 2;
  HKP_SEND_PROJECT = 3;
  HKP_GET_PROJECT = 4;
  HKP_SEND_SELECTION = 5;
  HKP_GET_SELECTION = 6;


var
 /////////////////////////////
 // PROCS
 /////////////////////////////

 // MainFrm
 Pr_LoadLayout : TStringProc;
 Pr_ArrangeWindows : TIntegerProc;
 Pr_SetTitle : TEmptyProc;
 Pr_IsBigWinNormal :  TIntegerFunc;
 Pr_DoBigWinNormal : TIntegerProc;
 Pr_DoNextWin : TEmptyProc;
 Pr_ShowWebs : TBOolProc;
 PR_DrawSplitter : TObjProc;
 PR_ToolsUpdating :  T2BoolProc;
 PR_UpdatePlugIns : TEmptyProc;
 PC_ActiveScriptAndQueryChanged : TEmptyProc;
 PR_HandleActiveURL : TStringProc;
 PR_ActiveURL : TNil2StringFunc;
 PC_MainForm_OptionsUpdated : TIntegerProc;
 PC_MainForm_Terminating : TEmptyProc;
 PR_GetActiveServer : TNil2IntFunc;
 PR_AddButtonLinkFromString :  Procedure (Const Str : String; Btn : TObject) of object;

 //WebBrowserFrm
 PR_PerlOutput : TStringProc;
 PR_OpenURL : TStringProc;
 PR_NewSession : TEmptyProc;
 PR_OpenURLQuery: TStringProc;
 PR_RunScriptExternal: TEmptyProc;
 PR_RunScriptExtSec: TEmptyProc;
 PR_RunScriptInternal: TEmptyProc;
 PR_WaitingForInput : TBoolProc;
 PC_WebBrowser_OptionsUpdated : TIntegerProc;
 PR_GetWebCookie:TNil2StringFunc;
 PR_WebBrowserData:TNil2StringFunc;

 //EdMagicMdl
 Pr_FinishedExplorer : TEmptyProc;
 PR_GoodFolderUpdate : TEmptyProc;
 PC_EdMagicMod_OptionsUpdated : TIntegerProc;
 PR_SetPattern : Procedure(Num : integer; Const Pat : String; CaseSensitive : Boolean) of object;

 //EditorFrm
// PR_UpdateErrorLineStorage : TEmptyProc;
 PR_DoErrorThreadDone : TEmptyProc;
 PR_UpdateLine : Procedure(const Filename : String; Line : integer; NoHigh : Boolean) of object;
 PR_QuickSave: TEmptyProc;
 PR_FocusEditor: TEmptyProc;
 PR_SaveAllInfos: TEmptyProc;
 PR_ReloadAllInfos: TEmptyProc;
 PR_UpdateBreakpoints:TBoolProc;
 PR_TemplatesUpdated : Procedure(PerlTemplates : TOBject) of object;
 PR_GotoLine : Procedure(const Filename : String; Line : Integer) of object;
 PR_OpenFileGeneral : TStringProc;
 PR_OpenFile : TStringProc;
 PR_OpenTempFile : TStr2BoolFunc;
 PR_RemoveRemoteFiles: TEmptyProc;
 PC_Editor_ClearRecentList : TEmptyProc;
 PC_Editor_TagConvert : Procedure(var tag : String) of object;
 PC_Editor_OptionsUpdated : TIntegerProc;
 PC_Editor_SyncScroll : TSyncScroll;
 PR_InsertTextAtCursor : TStringProc;
 PR_ExtToolRan : TEmptyProc;
 PR_SelectedBlock:TNil2StringFunc;
 PR_WordUnderCarret:TNil2StringFunc;
 PR_ForceReloadAll:TEmptyProc;
 PR_ReloadActive:TEmptyProc;
 PR_HighLightLineByPos : Procedure(const Filename : String; I : Integer) of object;
 PC_Editor_PipeTool : TPipeTool;
 PR_ModifyForRemote : TemptyProc;
 PR_GetOpenRemoteHost : TNil2StringFunc;
 PR_CloseActiveFile: TemptyProc;
 PR_GetFindText : Function(Advanced : Boolean) : String of object;
 PR_ReUpdateLastOpen:TBoolProc;
 PR_SetLastOpen:TBoolProc;

 //ExplorerFrm
 Pr_UpdateSyntaxErrors : TUpdateSyntaxErrorsProc = nil;
 PR_UpdateCodeExplorer : TEmptyProc;
 Pr_HighLightSub : THighLightSubProc;
 PR_UpdateSearchResult : TEmptyProc;
 PR_FindDeclaration : TStringProc;
 PR_OneSaved : TStringProc; 
 PC_Explorer_GetDeclarationHint : Procedure(Const Declaration : String; Var Result : String) of object;
 PC_Explorer_OptionsUpdated : TIntegerProc;
 PR_GetSubList : Procedure(Data : TStringList) of object;

 //FTPSessionsFrm !!!!!!!!!!!!
 PR_UpdateSessionTree : TEmptyProc;
 PR_SessionEditMode : TBoolProc;

 //TODO !!!!
 PC_Todo_ActiveScriptChanged : TEmptyProc;

 //ProjectFrm
 PR_GetProjectName : TNil2StringFunc;
 PR_IsFileInProject : TStr2BoolFunc;
 PR_ResetFileAges : TStringProc;
 PR_ProjectModified : TemptyProc;
 PR_RequestInfoFile : Function(const Path : String) : Pointer of object;

 PC_Project_ClearRecentList : TemptyProc;
 PC_Project_TagConvert : Procedure(var tag : String) of object;
 PC_Project_PipeTool : TPipeTool;
 PR_GetLibInfo : TNil2StringFunc;

 //ItemMdl
 PR_RootServerUpdated : TEmptyProc;
 PR_OpenInPodViewer : TStringProc;
 PR_DoOldTodo : Procedure(ms: TMemoryStream; Sl : TStrings) of object;
 PC_ItemMod_OptionsUpdated : TIntegerProc;
 PC_ItemMod_Terminating : TEmptyProc;
 PR_SearchForWord :TStringProc;
 PR_DoErrorChecking: TEmptyProc;
 PR_DoBreakConditions : TEmptyProc;
 PR_BeforeCustomize : TEmptyProc;
 PR_ActiveHTTPAddress: TNil2StringFunc;
 PR_BreakpointsEnabled:TNil2BoolFunc;
 PR_InternalServerRunning:TNil2BoolFunc;
 PR_ShowOptions : Procedure(ColorIndex,PageIndex : Integer) of object;
 PR_UpdateCallStack : TEmptyProc;
 PR_ShouldUpdateCallStack : TNil2BoolFunc;
 PR_GetServerPort : function (Internal: Boolean; out folder : String): Integer of object;

 //queryFrm
 PC_Query_ActiveScriptChanged : TEmptyProc;

 //Watch Form !!!!!!
 PR_UpdateWatchList : TEmptyProc;
 PR_UpdateNearLines : TEmptyProc;
 PR_GetWatchList : TEmptyProc;

 //Remote Explorer !!!
 PR_ReLinkSession : Procedure(Session : TObject; Kill : Boolean) of object;
 PR_LinkSession : Procedure(Session : TObject) of object;

 //code complete form
 PC_CodeComplete_GetDeclarationHint : Procedure(Const Declaration : String; Var Result : String) of object;

 //seceditFrm  !!!!!!!!!!!
type
 TSecEditForms = Record
  Window : TObject;
  OneClosed : Procedure(si : TObject) of object;
  OptionsUpdated : TIntegerProc;
  SyncScroll : TSyncScroll;
 end;

var
 SecEditForms : Array[0..3] of TSecEditForms;

 //RDebMod
 PC_RDeb_Terminating : TEmptyProc;
 PC_RDeb_PerlInput : TStringProc;
 PC_RDeb_BreakpointsChanged : TEmptyProc;
 PC_RDeb_PerlExpressionResult : Procedure(Var s:string) Of Object;
 PC_RDeb_DebuggerRunning : TNil2BoolFunc;
 PR_MakeRemoteFilename : Function(Path : String) : String Of Object;

 //LDebMod
 PC_LDeb_Terminating : TEmptyProc;
 PC_LDeb_PerlInput : TStringProc;
 PC_LDeb_BreakpointsChanged : TEmptyProc;
 PC_LDeb_PerlExpressionResult : Procedure(Var s:string) Of Object;
 PC_LDeb_DebuggerRunning : TNil2BoolFunc;

 //General Debugger set by procedure below
 PC_Debug_Terminating : TEmptyProc;
 PC_PerlInput : TStringProc;
 PC_BreakpointsChanged : TEmptyProc;
 PC_PerlExpressionResult : Procedure(Var s:string) Of Object;
 PC_DebuggerRunning : TNil2BoolFunc;

Procedure PC_PipeTool(Command : Integer; SL : TStringList; Active : TObject);

Procedure PC_OneClosed(si : TObject);
Procedure PC_SyncScroll(CharPos,LinePos : Integer; Const Path : String; Sender : TObject);

Procedure PC_ClearRecentList;
Procedure PC_TagConvert(Var Tag : String);
Procedure PC_GetDeclarationHint(Const Declaration : String; Var Result : String);
Procedure PC_OptionsUpdated(Level : Integer);
Procedure PC_Terminating;

Procedure PC_ActiveScriptChanged;
Procedure PC_QueryChanged;

Procedure PV_SetDebuggerProcs(Local : Boolean);

implementation

Procedure PC_PipeTool(Command : Integer; SL : TStringList; Active : TObject);
begin
 PC_Project_PipeTool(Command,sl,Active);
 PC_Editor_PipeTool(Command,sl,Active);
end;

Procedure PV_SetDebuggerProcs(Local : Boolean);
begin
 if Local then
  begin
   PC_Debug_Terminating:=PC_LDeb_Terminating;
   PC_PerlInput:=PC_LDeb_PerlInput;
   PC_BreakpointsChanged:=PC_LDeb_BreakpointsChanged;
   PC_PerlExpressionResult:=PC_LDeb_PerlExpressionResult;
   PC_DebuggerRunning:=PC_LDeb_DebuggerRunning;
  end
 else
  begin
   PC_Debug_Terminating:=PC_RDeb_Terminating;
   PC_PerlInput:=PC_RDeb_PerlInput;
   PC_BreakpointsChanged:=PC_RDeb_BreakpointsChanged;
   PC_PerlExpressionResult:=PC_RDeb_PerlExpressionResult;
   PC_DebuggerRunning:=PC_RDeb_DebuggerRunning;
  end
end;

Procedure PC_Terminating;
begin
 PC_Debug_Terminating;
 PC_MainForm_Terminating;
 PC_ItemMod_Terminating;
end;

Procedure PC_ActiveScriptChanged;
begin
 PC_ActiveScriptAndQueryChanged;
 PC_Query_ActiveScriptChanged;
 if assigned(PC_Todo_ActiveScriptChanged) then
  PC_Todo_ActiveScriptChanged;
end;

Procedure PC_QueryChanged;
begin
 PC_ActiveScriptAndQueryChanged;
end;

Procedure PC_OneClosed(si : TObject);
var i:integer;
begin
 For i:=0 to 3 do
  if assigned(SecEditForms[i].Window) then
   SecEditForms[i].OneClosed(si)
end;

Procedure PC_SyncScroll(CharPos,LinePos : Integer; Const Path : String; Sender : TObject);
var
 i:integer;
 done : Boolean;
begin
 Done:=false;
 For i:=0 to 3 do
  if assigned(SecEditForms[i].Window) then
  begin
   SecEditForms[i].SyncScroll(charpos,linepos,path,sender);
   done:=true;
  end;
 if (done) and assigned(PC_Editor_SyncScroll) then
  PC_Editor_SyncScroll(charpos,linepos,path,sender);
end;

Procedure PC_OptionsUpdated(Level : Integer);
var i:integer;
begin
 For i:=0 to 3 do
  if assigned(SecEditForms[i].Window) then
   SecEditForms[i].OptionsUpdated(level);
 if assigned(PC_EdMagicMod_OptionsUpdated) then
  PC_EdMagicMod_OptionsUpdated(level);
 if assigned(PC_Explorer_OptionsUpdated) then
  PC_Explorer_OptionsUpdated(level);
 if assigned(PC_ItemMod_OptionsUpdated) then
  PC_ItemMod_OptionsUpdated(level);
 if assigned(PC_MainForm_OptionsUpdated) then
  PC_MainForm_OptionsUpdated(Level);
 if assigned(PC_WebBrowser_OptionsUpdated) then
  PC_WebBrowser_OptionsUpdated(Level);
 if assigned(PC_Editor_OptionsUpdated) then
  PC_Editor_OptionsUpdated(level);
end;

Procedure PC_GetDeclarationHint(Const Declaration : String; Var Result : String);
begin
 PC_Explorer_GetDeclarationHint(Declaration,result);
 PC_CodeComplete_GetDeclarationHint(Declaration,result);
 result:=trim(result);
end;

Procedure PC_TagConvert(Var Tag : String);
begin
 PC_Editor_TagConvert(tag);
 PC_Project_TagConvert(tag);
end;

Procedure PC_ClearRecentList;
begin
 if assigned(PC_Editor_ClearRecentList) then PC_Editor_ClearRecentList;
 if assigned(PC_Project_ClearRecentList) then PC_Project_ClearRecentList;
end;

end.