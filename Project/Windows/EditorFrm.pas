unit EditorFrm; //Modeless //memo 1 //StatusBar //Tabs
{$I REG.INC}

interface

uses Windows, Forms, Controls, variants, dccommon, dcmemo, ComCtrls, dcsystem,hakafile,
     dcparser, dcstring, Classes, dccdes, runperl,sysutils,ScriptInfoUnit, OptQuery,
     Menus, Dialogs, HKMultiFileHandler,hakageneral,hyperfrm,printers,PlugMdl,
     ActnList, StdCtrls, OptMessage, Optfolders,hyperstr,aqDockingBase,
     OptOptions, graphics, ImgList,CommConvUnit,hakamessageBox,Hakawin,
     AppEvnts,OptGeneral, ExtCtrls,hakahyper, messages,shellapi,HKComboInputForm,
     stdactns, Buttons, ProjectFrm,HK_replunit,parsersmdl,TemSelectFrm,
     CustDebMdl, HaKaTabs,CodeCompFrm,CentralImageListMdl, dxBar,FTPMdl,
     ErrorCheckMdl,HTMLElements,HKPerlParser,OptControl, DIPcre,ActiveX,
     HKActions,PerlTemplatesFrm,OptForm,HKDebug, DropSource, DropTarget,
     OptProcs,OptBackup;

type
  TCommentChangeType = (ccToggle,ccAdd,ccRemove);
  TIsDeclaration = Function(const Declaration : String) : Boolean of object;

  TEditorForm = class(TOptiForm)
    TabControl: THKTabcontrol;
    MFH: TMultiFileHandler;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    FileActionList: TActionList;
    OpenAction: THKAction;
    NewAction: THKAction;
    SaveAction: THKAction;
    SaveAsAction: THKAction;
    SaveAllAction: THKAction;
    CloseAllAction: THKAction;
    CloseAction: THKAction;
    NewHtmlFileAction: THKAction;
    ExportHTMLAction: THKAction;
    ExportHtmlDialog: TSaveDialog;
    ApplicationEvents: TApplicationEvents;
    BrowseBackAction: THKAction;
    ExportRTFAction: THKAction;
    ExportRTFDialog: TSaveDialog;
    HighlightTimer: TTimer;
    NewTemplateAction: THKAction;
    StatusBar: TStatusBar;
    UnixFormatAction: THKAction;
    WindowsFormatAction: THKAction;
    MacFormatAction: THKAction;
    CodeCompAction: THKAction;
    CommPcre: TDIPcre;
    MouseTimer: TTimer;
    ReloadAction: THKAction;
    ResetPermAction: THKAction;
    Timer: TTimer;
    DropFileTarget: TDropFileTarget;
    DropMenu: TPopupMenu;
    InsertfileatcursorItem: TMenuItem;
    OpenFileItem: TMenuItem;
    N1: TMenuItem;
    Cancel1: TMenuItem;
    BarManager: TdxBarManager;
    memEditor: TDCMemo;
    HistoryPcre: TDIPcre;
    ClearHighlightsAction: THKAction;
    procedure TabControlChanging(Sender: TObject; var AllowChange: Boolean);
    procedure TabControlChange(Sender: TObject);
    procedure memEditorStateChange(Sender: TObject; State: TMemoStates);
    procedure MFHAllClosed(Sender: TObject);
    function MFHGetActiveIndex(sender: TObject): Integer;
    procedure MFHGoToIndex(sender: TObject; Index: Integer);
    procedure MFHOneOpened(Sender: TObject);
    procedure MFHSave(sender: TObject; FileInfo: TFileInfo);
    function MFHNew(sender: TObject): TFileInfo;
    function MFHOpen(sender: TObject; const filename: String): TFileInfo;
    procedure OpenActionExecute(Sender: TObject);
    procedure NewActionExecute(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure SaveActionUpdate(Sender: TObject);
    procedure SaveAsActionExecute(Sender: TObject);
    procedure SaveAllActionExecute(Sender: TObject);
    procedure SaveAllActionUpdate(Sender: TObject);
    procedure CloseAllActionExecute(Sender: TObject);
    procedure CloseAllActionUpdate(Sender: TObject);
    procedure CloseActionExecute(Sender: TObject);
    procedure CloseActionUpdate(Sender: TObject);
    procedure MFHTabChanged(Sender: TObject);
    procedure MFHModifyUpdate(Sender: TObject);
    procedure PerlCodeDesignerShowSource(Sender: TObject; x, y: Integer);
    procedure XFormCreate(Sender: TObject);
    procedure MFHSaveCancel(sender: TObject; FileInfo: TFileInfo);
    procedure NewHtmlFileActionExecute(Sender: TObject);
    procedure ExportHTMLActionExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEventsShowHint(var HintStr: String;
      var CanShow: Boolean; var HintInfo: THintInfo);
    procedure memEditorMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ExportRTFActionExecute(Sender: TObject);
    procedure memEditorKeyPress(Sender: TObject; var Key: Char);
    procedure OpenDialogCanClose(Sender: TObject; var CanClose: Boolean);
    procedure memEditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MFHReloadActive(Sender: TObject);
    procedure OpenDialogClose(Sender: TObject);
    procedure SaveDialogClose(Sender: TObject);
    procedure MFHOneClosed(sender: TObject; FileInfo: TFileInfo);
    procedure memEditorMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure memEditorGetColorStyle(Sender: TObject; APoint: TPoint;
      var AStyle: Integer);
    procedure memEditorKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure memEditorMemoScroll(Sender: TObject;
      ScrollStyle: TScrollStyle; Delta: Integer);
    procedure HighlightTimerTimer(Sender: TObject);
    procedure NewTemplateActionExecute(Sender: TObject);
    procedure memEditorHintPopup(Sender: TObject; Strings: TStrings;
      var AllowPopup: Boolean; var PopupType: TPopupType);
    procedure memEditorHintInsert(Sender: TObject; var s: String);
    procedure WindowsFormatActionExecute(Sender: TObject);
    procedure UnixFormatActionExecute(Sender: TObject);
    procedure MacFormatActionExecute(Sender: TObject);
    procedure TabControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure memEditorClickGutter(Sender: TObject; LinePos,
      ImageIndex: Integer; Shift: TShiftState);
    procedure CodeCompActionExecute(Sender: TObject);
    procedure memEditorJumpToUrl(Sender: TObject; const s: String;
      var Handled: Boolean);
    procedure ExportHTMLActionUpdate(Sender: TObject);
    procedure ExportRTFActionUpdate(Sender: TObject);
    procedure MouseTimerTimer(Sender: TObject);
    procedure memEditorDblClick(Sender: TObject);
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    procedure memEditorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ReloadActionUpdate(Sender: TObject);
    procedure ReloadActionExecute(Sender: TObject);
    procedure ResetPermActionExecute(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure TabControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure InsertfileatcursorItemClick(Sender: TObject);
    procedure OpenFileItemClick(Sender: TObject);
    procedure DropFileTargetDrop(Sender: TObject; ShiftState: TShiftState;
      Point: TPoint; var Effect: Integer);
    procedure DropFileTargetDragOver(Sender: TObject;
      ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
    procedure FormatUpdate(Sender: TObject);
    procedure BrowseBackActionUpdate(Sender: TObject);
    procedure BrowseBackActionExecute(Sender: TObject);
    procedure ClearHighlightsActionExecute(Sender: TObject);
    procedure memEditorCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure StatusBarDblClick(Sender: TObject);
    function MFHBeforeOpen(Sender: TObject; Const Filename: String): Boolean;
  private
    InsertHTMLItem,MouseOnTab : Boolean;
    errorthread : Terrorthread;
    ForceHTMLComment : Boolean;
    NextMoveMustInvalidateLine : Integer;
    TempFileList : TStringList;
    PrevMousePos : Tpoint;
    CharPressMode : Boolean;
    StartDragLine : Integer;
    MouseTimerGoDec : String;
    BracketPoint : TPoint;
    LastOpenFilterIndex, LastSaveFilterIndex : integer;
    PrevHintExpression,PrevHintText : string;
    LastActiveLine : Integer;
    LastKeyNav : Integer; //0=none, 1=home, 2=end
    function MemoHintText(const Text:string) : string;
    procedure ShowAndSetFocus;
    function GetBracketPos(var mp: TPoint; SmartMove,LargeBuf  : Boolean): Boolean;
    function GetOpenScriptInfo(const Path : string) : TScriptInfo;
    procedure CheckForErrorLine(Y: Integer);
    procedure SetDefExtensions;
    Procedure SaveFile(Si : TScriptInfo; SaveOriginal : Boolean);
    procedure DoCommentAdd(var S: string; Line: Integer);
    procedure DoCommentRemove(var S: string; Line: Integer);
    procedure DoCommentTogle(var S: string; Line: Integer);
    function IsHtmlLine(Line: Integer): Boolean;
    procedure WMHelp(var Message: TWMHelp); message WM_HELP;
    function FindErrorLine(y: Integer): Integer;
    function GetCorrOther(const Path: string): TScriptInfo;
    function IsRemoteFile(const Path: String): Boolean;
  protected
    procedure _ReloadActive;
    procedure _ReloadAllInfos;
    procedure _SetLastOpen(main: Boolean);
    procedure _ReUpdateLastOpen(main : Boolean);
    procedure _CloseActiveFile;
    procedure _SaveAllInfos;
    function _OpenTempFile(const Str: String): Boolean;
    function _GetOpenRemoteHost: String;
    procedure _ModifyForRemote;
    procedure _pipetool(Command: Integer; SL : TStringList; Active : TObject);
    procedure _HighLightLineByPos(const F : String; Start: Integer);
    function _SelectedBlock: String;
    function _WordUnderCarret: String;
    procedure _InsertTextAtCursor(const Data: String);
    procedure _SyncScroll(CharPos, LinePos: Integer; const Path: String; Sender: TObject);
    procedure _OptionsUpdated(Level: Integer);
    procedure _RemoveRemoteFiles;
    Procedure _DoErrorThreadDone;
    procedure _UpdateLine(const Filename: String; Line: integer; NoHigh: Boolean);
    procedure _TemplatesUpdated(PerlTemplates : TOBject);
    Procedure _QuickSave;
    Function  _GetFindText(Advanced : Boolean) : String;
    procedure _UpdateBreakpoints(RemAlso: Boolean);
    procedure _GotoLine(const Filename: String; Line: Integer);
    procedure _OpenFile(const Data: String);
    procedure _OpenFileGeneral(const Path: String);
    procedure _Editor_ClearRecentList;
    procedure _FocusEditor;
    procedure _Editor_TagConvert(var Str: String);
    Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); Override;
  public
    NewFilename,NewTemplate : String;
    siTabPop,siEditorPop: TdxBarSubItem;
    PerlSource : TMemoSource;
    IsDeclaration : TIsDeclaration;
    IsSimpleBar : Boolean;
    HistoryList : String;
    procedure HistoryListGoto;
    Function HistoryListCurrent : String;

    procedure UpdateCaption;
    procedure RestartThread;
    procedure SetParserActive(Data : TObject);
    procedure ClearAllRunLines;
    procedure ResyncBreakpoints;
    procedure LoadBMP;
    procedure ToggleBreakPoint;
    procedure CreateWithName(const Filename: String);
    procedure OnStat(Sender: TObject);
    procedure OnServerStatus(Sender : TObject; const Status: string);
    procedure GetMatching(SelectAlso : Boolean);
    function ActiveVersion: String;
    procedure DoComment(comm: TCommentChangeType);
    Procedure memRealTimeColor(Sender : TObject; Line : integer);
    function CanCloseEditor: Boolean;
    procedure Startup(OnlyLoadFile : Boolean);
  end;

var
  EditorForm: TEditorForm;

const
  NewScriptName = 'newscript%d.cgi';
  NewHTMLName = 'newhtml%d.htm';

implementation
{$R *.DFM}

procedure TEditorForm.TabControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
 MFH.OnChanging;
end;

procedure TEditorForm.TabControlChange(Sender: TObject);
begin
 MFH.OnChange;
end;

Procedure TEditorForm.ResyncBreakpoints;
var
 i,j: integer;
 si : TScriptInfo;
 bi : ^TBreakInfo;
 StrInfo : dcstring.TStringItem;
begin
 for i:=0 to mfh.FileList.Count-1 do
 begin
  si:=TScriptInfo(MFH.Filelist.Objects[i]);
  for j:=0 to si.ms.lines.count-1 do
  begin
   strinfo:=si.ms.StringItem[j];
   bi:=pointer(strinfo.ObjData);
   if assigned(bi) then
    if bi^.line<>j then bi^.line:=j;
  end;
 end;
end;

procedure TEditorForm.memEditorClickGutter(Sender: TObject; LinePos,
  ImageIndex: Integer; Shift: TShiftState);
var
 bi : ^TBreakInfo;
 si : TScriptInfo;
 StrInfo : dcstring.TStringItem;
 i:integer;
 s:String;
begin
 if (ssright in Shift) or (linepos>=memeditor.lines.count) or (not PR_BreakpointsEnabled) then
  exit;

 si:=TScriptInfo(mfh.ActiveFileInfo);
 strinfo:=si.ms.stringItem[linepos];
 if not assigned(strinfo) then exit;
 bi:=pointer(strinfo.ObjData);

 if not assigned(bi) then
  begin
   new(bi);
   breakpoints.addobject(mfh.ActiveFileInfo.path,tobject(bi));
   bi^.Condition:='';
   bi^.done:=false;
   bi^.BreakStatus:=bsGeneral;
   bi^.line:=linepos;
   strinfo.objdata:=tobject(bi);
  end
 else
  begin
   strinfo.ObjData:=nil;
   i:=breakpoints.IndexOfObject(tobject(bi));
   if i>=0 then
   begin
    bi^.BreakStatus:=bsNone;
    bi^.Line:=linepos;
    si:=GetOpenScriptinfo(Breakpoints[i]);
    if assigned(si) then
     si.SetBreakPoint(bi^);
   end;
   dispose(bi);
   if i>=0 then
    breakpoints.Delete(i);
  end;

 PC_BreakpointsChanged;
end;

procedure TEditorForm.memEditorStateChange(Sender: TObject; State: TMemoStates);
const
 OverwriteStr : array[false..true] of string = ('Insert','Overwrite');
var
 y : integer;
begin

 if MsEdited in state then
 begin
  TScriptInfo(mfh.ActiveFileInfo).QuickSaveModified:=True;
  mfh.Modified;
  ActiveScriptInfo.FTPModified:=true;
  PR_UpdateCodeExplorer;
  Timer.Enabled:=false;
  if not TerminateChecking then
   timer.Enabled:=true;
 end;

 if MsPositionChanged in state then
  begin
   StatusBar.Panels[0].Text:=memeditor.CurPosText;
   statusbar.SimplePanel:=IsSimpleBar;
   y:=memEditor.MemoSource.GetCaretPoint.y;
   if LastActiveLine<>y then
   begin
    LastActiveLine:=y;
    try
     Pr_HighLightSub(y,false);
    except end; 
    CheckForErrorLine(y);
    if NextMoveMustInvalidateLine>=0 then
    begin
     memEditor.InvalidateLines(NextMoveMustInvalidateLine,NextMoveMustInvalidateLine,false);
     NextMoveMustInvalidateLine:=-1;
    end;
   end;
  end;

 if MsInsState in state then
 begin
  StatusBar.Panels[2].Text:=OverWriteStr[PerlSource.overwrite];
  statusbar.SimplePanel:=IsSimpleBar;
 end;

end;


procedure TEditorForm.MFHAllClosed(Sender: TObject);
begin
 memEditor.Visible:=false;
 ActiveScriptInfo:=nil;
 PerlSource:=nil;
end;

function TEditorForm.MFHGetActiveIndex(sender: TObject): Integer;
begin
 result:=TabControl.TabIndex;
end;

procedure TEditorForm.MFHGoToIndex(sender: TObject; Index: Integer);
begin
 if Index>=0 then
  TabControl.TabIndex:=index;
end;

procedure TEditorForm.MFHOneOpened(Sender: TObject);
begin
 memEditor.Visible:=true;
end;

procedure TEditorForm.SaveFile(Si : TScriptInfo; SaveOriginal : Boolean);
begin
 if (not options.RunTest) and (not options.CBTTest) then
 begin
   Assert(false,'LOG Saving '+si.path);
   si.ms.SaveToFile(si.path);
   PR_OneSaved(si.path);
  end;

 if SaveOriginal then
 begin
  si.Original:=si.ms.Lines.Text;
  if si.GetFTPFolder='' then
   BackupScript(si);
 end;
end;

procedure TEditorForm.MFHSave(sender: TObject; FileInfo: TFileInfo);
var
 si : TScriptInfo;
begin
 si:=TScriptInfo(fileInfo);
 SaveFile(si,true);
end;

Procedure TEditorForm._ReUpdateLastOpen(main : Boolean);
var
 i :integer;
 sl : TStringList;
 s:String;
begin
 if (not main) and (not projOpt.RestoreFiles) then exit;

 if main
  then s:=options.LastOpenFiles
  else s:=projopt.LastOpenFiles;

 sl:=TStringList.Create;
 try
  sl.Text:=s;
  with mfh.FileList do
   for i:=Count-1 downto 0 do
    if sl.IndexOf(TScriptInfo(Objects[i]).path)<0 then
     mfh.CloseByIndex(i);

  for i:=0 to sl.count-1 do
   PR_OPenFIle(sl[i]);
 finally
  sl.free;
 end;

 if main
  then s:=options.LastOpenFile
  else s:=projopt.LastOpenFile;
 PR_OPenFIle(s);

 if MFH.FileList.Count=0 then
  NewAction.SimpleExecute;
end;

Procedure TEditorForm.Startup(OnlyLoadFile : Boolean);
var
 i :integer;
 sl : TStringList;
begin
 if not OnlyLoadFile then
 begin
  NewAction.SimpleExecute;
  if options.StartupLastOpen then
   PR_ReUpdateLastOpen(true);
  if dockcontrol.DockState<>dcsHidden then
   memEditor.SetFocus;
 end;

 if not fileexists(Folders.loadfile) then exit;

 if not IsWindowEnabled(application.MainForm.Handle) then
 begin
  DeleteFile(pchar(folders.loadfile));
  exit;
 end;

 sl:=TStringList.Create;
 try
  sl.LoadFromFile(folders.loadfile);
  for i:=0 to sl.Count-1 do
   PR_OpenFileGeneral(sl[i]);
  DeleteFile(pchar(folders.loadfile));
 finally
  sl.free;
 end;

end;


function TEditorForm.MFHNew(sender: TObject): TFileInfo;
var
 si : TScriptInfo;
 ext,dp : string;
begin
 EditorEnterCS;
 try
  MFH.Defaultname:=NewFilename;
  ext:=ExtractFileExt(NewFilename);
  si:=TScriptInfo.Create('');
  si.IsPerl:=parsersmod.isPerl(NewFilename);
  si.ms.Delimeters:=parsersmod.GetDefaultDelimiters(ext);
  si.ms.SyntaxParser:=parsersmod.GetParser(ext);

  if not fileexists(newtemplate) then
   begin
    if si.IsPerl then
     begin
      if fileexists(Options.DefaultScript)
        then dp:=LoadStr(Options.DefaultScript)
        else dp:='';
     end
    else
     begin
       if fileexists(Options.DefaultHTML)
        then dp:=LoadStr(Options.DefaultHTML)
        else dp:='';
     end;
    si.Original:=dp;
    si.ms.Lines.Text:=dp;
   end
  else
   begin
    si.Original:=loadstr(newtemplate);
    si.Ms.Lines.Text:=si.Original;
   end;
  NewTemplate:='';
  NewFilename:=NewScriptName;
  case options.DefaultLineEnd of
   0 : si.ms.OutFormat:=ofWindows;
   1 : si.ms.OutFormat:=ofUnix;
   2 : si.ms.OutFormat:=ofMac;
  end;
  result:=si;

 finally
  NoMemoSource:=False;
  EditorLeaveCS(true);
 end;
end;

procedure TEditorForm.ReloadActionExecute(Sender: TObject);
begin
 with ActiveScriptInfo do
 begin
  if (IsModified) and
     (MessageDlg('You have made changes to this file that have not been saved.'+#13+#10+'All modifications will be lost. Continue?', mtConfirmation, [mbOK,mbCancel], 0)<>mrOK) then
   exit;
   MFHReloadActive(nil);
   timestamp:=fileage(path);
   JustLoaded:=true;
   MFHModifyUpdate(nil);
 end;
end;

procedure TEditorForm._ReloadActive;
begin
 MFHReloadActive(nil);
 MFHModifyUpdate(nil);
end;

procedure TEditorForm.MFHReloadActive(Sender: TObject);
var
 si:TScriptInfo;
 s:string;
 w : integer;
begin
 w:=memEditor.WinLinePos;
 EditorEnterCS;
 try
  si:=TScriptInfo(MFH.ActiveFileInfo);
  si.ms.LoadFromFile(si.path);
  si.Original:=si.ms.lines.text;
  si.QuickSaveModified:=false;
  si.IsModified:=False;
  memEditor.WinLinePos:=w;
 finally
  EditorLeaveCS(true);
 end;
end;

function TEditorForm.MFHOpen(sender: TObject;
  const filename: String): TFileInfo;
var
 si : TScriptInfo;
 sl : TStringList;
 i:integer;
 bi : ^TbreakInfo;
 s:string;
begin
 result:=nil;
 si:=TScriptInfo.Create(Filename);
 try
  s:=LoadStr(filename);
  i:=GetEOLCharacter(s);
  si.ms.Lines.Text:=s;
  NoMemoSource:=false;

  if i<0 then i:=options.DefaultLineEnd;
  if i=0 then
   si.ms.OutFormat:=ofWindows
  else if i=1 then
   si.Ms.OutFormat:=ofUnix
  else if i=2 then
   si.ms.OutFormat:=ofMac;
 except
  begin
   si.Free;
   exit;
  end;
 end;

 si.Original:=si.ms.lines.text;
 result:=si;

 //update breakpoints
 sl:=OptMessage.BreakPoints;

 if assigned(sl) then
  for i:=0 to sl.Count-1 do
   if sl[i]=filename then
   begin
    bi:=pointer(sl.objects[i]);
    si.SetBreakPoint(bi^);
   end;
end;

procedure TEditorForm.OpenActionExecute(Sender: TObject);
begin
 opendialog.filterindex:=LastOpenFilterIndex;
 MFH.Open;
 with OpenDialog do
 begin
  if FileName<>'' then
   InitialDir:=extractfilepath(FileName);
  FileName:='';
 end;
end;

procedure TEditorForm.NewTemplateActionExecute(Sender: TObject);
begin
 TemSelectForm:=TTemSelectForm.Create(Application);
 with temselectform do
 begin
  Memo.TextStyles.Assign(memeditor.TextStyles);
  if ShowModal=mrOK then
  begin
   NewTemplate:=vet.SelectedPath;
   NewFileName:=ExtractFilename(NewTemplate);
   MFH.New;
  end;
  Free;
 end;
end;

procedure TEditorForm.NewHtmlFileActionExecute(Sender: TObject);
begin
 NewFilename:=NewHTMLName;
 NewTemplate:='';
 MFH.New;
end;

procedure TEditorForm.NewActionExecute(Sender: TObject);
begin
 NewFilename:=NewScriptName;
 NewTemplate:='';
 MFH.New;
end;

procedure TEditorForm.SaveActionExecute(Sender: TObject);
begin
 Savedialog.filterindex:=LastSaveFilterIndex;
 MFH.Save;
 with SaveDialog do
 begin
  if FileName<>'' then
   InitialDir:=extractfilepath(FileName);
  FileName:='';
 end;
end;

procedure TEditorForm.SaveActionUpdate(Sender: TObject);
begin
  SaveAction.enabled:=MFH.SaveEnabled;
end;

procedure TEditorForm.SaveAsActionExecute(Sender: TObject);
begin
 Savedialog.filterindex:=LastSaveFilterIndex;
 MFH.SaveAs;
 with TScriptInfo(MFH.ActiveFileInfo) do
 begin
  ms.ReadOnly:=Getreadonly;
  ms.syntaxparser:=parsersmod.getparser(extractfileext(path));
 end;
end;

procedure TEditorForm.SaveAllActionExecute(Sender: TObject);
var s:string;
begin
 Savedialog.filterindex:=LastSaveFilterIndex;
 MFH.SaveAll;
end;

procedure TEditorForm.SaveAllActionUpdate(Sender: TObject);
begin
 SaveAllAction.Enabled:=MFH.SaveAllEnabled;
end;

procedure TEditorForm.CloseAllActionExecute(Sender: TObject);
begin
 MFH.CloseAll;
 if MFH.FileList.Count=0 then
  NewAction.SimpleExecute;
end;

procedure TEditorForm.CloseAllActionUpdate(Sender: TObject);
begin
 CloseAllAction.Enabled:=MFH.CloseAllEnabled;
end;

procedure TEditorForm.CloseActionExecute(Sender: TObject);
begin
 Savedialog.filterindex:=LastSaveFilterIndex;
 MFH.Close;
 if MFH.FileList.Count=0 then
  NewAction.SimpleExecute;
end;

procedure TEditorForm.CloseActionUpdate(Sender: TObject);
begin
 CloseAction.Enabled:=MFH.CloseEnabled;
end;

procedure TEditorForm.UpdateCaption;
var
 s:string;
begin
 if assigned(ActiveScriptInfo) then
 begin
  s:=ActiveScriptInfo.GetCaption;
  OptiTitleFile:=s;
  Setcaption(s+' - Editor');
  PR_SetTitle;
 end;
end;

procedure TEditorForm.MFHTabChanged(Sender: TObject);
begin
 EditorEnterCS;
 try
  PerlSource:=TScriptInfo(mfh.ActiveFileInfo).ms;
  ActiveScriptInfo:=mfh.ActiveFileInfo as TScriptInfo;
  NoMemoSource:=true;
  memEditor.MemoSource:=PerlSource;
 finally
  NoMemoSource:=false;
  EditorLeaveCS(true);
 end;

 UpdateCaption;
 SetNewMemo(memeditor.memosource);
 if assigned(PR_UpdateCodeExplorer) then
  PR_UpdateCodeExplorer;
 Timer.Enabled:=false;
 if not TerminateChecking then
  timer.Enabled:=true;
 if (assigned(Pr_UpdateSyntaxErrors)) and
    ( (not activeScriptInfo.IsPerl) or
      (not activeScriptinfo.DoErrorCheck) ) then
  Pr_UpdateSyntaxErrors(nil,0);
 PC_ActiveScriptChanged;
 bracketpoint.x:=-1;
 PlugMod.OnActiveDocumentChange;
end;

Procedure TEditorForm._OpenFileGeneral(const Path:string);
begin
 if not fileexists(path) then exit;

 if UpFileExt(path)='OPJ' then
  begin
   ProjectForm.FMH.OpenFile(path);
   if mfh.FileList.Count=0
    then mfh.New;
   ProjectForm.Show;
  end

 else
 if UpFileExt(path)='POD' then
  begin
   PR_OpenInPodViewer(path);
  end

 else
  begin
   mfh.OpenFile(Path);
   ShowAndSetFocus;
  end;
end;

procedure TEditorForm.MFHModifyUpdate(Sender: TObject);
const
 ModifiedStr : Array[false..true] of string = ('','Modified');
var
 s:string;
begin
 StatusBar.Panels[1].Text:=ModifiedStr[MFH.ActiveFileInfo.ismodified];
 statusbar.SimplePanel:=IsSimpleBar;

 // add a star if needed in the tabcontrol
 with tabcontrol do
  s:=Tabs[TabIndex];
 if (length(s)>0) and (s[length(s)]='*') then
  SetLength(s,length(s)-1);
 if MFH.ActiveFileInfo.ismodified then s:=s+'*';

 with tabcontrol do
  //only update if needed because of flicker problem
  if tabs[tabindex]<>s then
   Tabs[TabIndex]:=s;
end;

procedure TEditorForm.PerlCodeDesignerShowSource(Sender: TObject; x,
  y: Integer);
begin
 PerlSource.JumpTo(x,y-2);
 ShowAndSetFocus;
end;

procedure TEditorForm.LoadBMP;
begin
 {$IFDEF REG}
  if FIleExists(programPath+OptiEditorBmp) then
   memEditor.Background.LoadFromFile(programPath+OptiEditorBmp);
 {$ENDIF}
end;

procedure TEditorForm.XFormCreate(Sender: TObject);
begin
 PR_ReloadActive:=_ReloadActive;
 PR_ReloadAllInfos:=_ReloadAllInfos;
 PR_SaveAllInfos:=_SaveAllInfos;
 PR_ReUpdateLastOpen:=_ReUpdateLastOpen;
 PR_SetLastOpen:=_SetLastOpen;
 PR_GetFindText:=_GetFindText;
 PR_DoErrorThreadDone:=_DoErrorThreadDone;
 PR_CloseActiveFile:=_CloseActiveFile;
 PR_UpdateLine:=_UpdateLine;
 PR_QuickSave:=_QuickSave;
 PR_FocusEditor:=_FocusEditor;
 PR_UpdateBreakpoints:=_UpdateBreakpoints;
 PR_TemplatesUpdated:=_TemplatesUpdated;
 PR_GotoLine:=_GotoLine;
 PR_OpenFileGeneral:=_OpenFileGeneral;
 PR_OpenFile:=_OpenFile;
 PR_OpenTempFile:=_OpenTempFile;
 PR_RemoveRemoteFiles:=_RemoveRemoteFiles;
 PC_Editor_ClearRecentList:=_Editor_ClearRecentList;
 PC_Editor_TagConvert:=_Editor_TagConvert;
 PC_Editor_OptionsUpdated:=_OptionsUpdated;
 PC_Editor_SyncScroll:=_SyncScroll;
 PR_InsertTextAtCursor:=_InsertTextAtCursor;
 PR_ExtToolRan:=MFH.CheckFileAges;
 PR_SelectedBlock:=_SelectedBlock;
 PR_WordUnderCarret:=_WordUnderCarret;
 PR_ForceReloadAll:=MFH.ForceReloadAll;
 PR_HighLightLineByPos:=_HighLightLineByPos;
 PC_Editor_Pipetool:=_Pipetool;
 PR_ModifyForRemote:=_ModifyForRemote;
 PR_GetOpenRemoteHost:=_GetOpenRemoteHost;

 ShowMenuWhenDocked:=false;
 dcString.tokURL:=32;
 StartDragLine:=-1;
 LinksAtEnd:=true;
 dcMemo.PopupOKKeys:=['A'..'Z','a'..'z','0'..'9','_',':'];
 MouseTimer.Interval:=GetDoubleClickTime;
 PopupCloseAndOKKeys:=['>'];
 ActiveEdit.mainMemo:=memEditor;
 TempFileList:=TStringList.Create;
 LoadBMP;
 NewFilename:=NewScriptName;
 MFH.IniPath:=Folders.iniFile;
 mfh.FileList:=TabControl.Tabs;
 MFH.MRUCount:=options.RecentItems;
 MFH.LoadMRU;
 OpenDialog.InitialDir:=Options.DefaultScriptFolder;
 SaveDialog.InitialDir:=Options.DefaultScriptFolder;
 BracketPoint.x:=-1;
 BracketPoint.y:=-1;
 NextMoveMustInvalidateLine:=-1;
 if OptiRel=orStan then
 begin
  StatusBar.panels[3].Width:=0;
  statusbar.SimplePanel:=IsSimpleBar;
 end;
 ErrorThread:=TErrorThread.create;
end;

procedure TEditorForm.RestartThread;
begin
 TerminateThread(ErrorThread.Handle,1);
 EditorInitCS(false);
 EditorInitCS(true);
 Closehandle(CSEntireCode);
 CSEntireCode:=CreateMutex(nil,false,nil);
 ErrorThread:=TErrorThread.Create;
end;

Procedure TEditorForm.SetDefExtensions;
const
 str='|HTML Documents (*.htm; *.html;*.shtml)|*.htm;*.html;*.shtml|XLM Documents (*.xml)|*.xml|Configuration files (*.cfg;*.conf)|*.cfg;*.conf|All Files (*.*)|*.*';
 defext : array[0..3] of string = ('pl','cgi','pm','plx');
var
 i,j:integer;
 s:String;
begin
 i:=0;
 while (i<=high(defExt)) and
       (Uppercase(defext[i])<>uppercase(Options.DefPerlExtension)) do
  inc(i);
 s:='*.'+Options.DefPerlExtension+';';
 for j:=0 to high(defExt) do
  if i<>j then s:=s+'*.'+defext[j]+';';
 SetLength(s,length(s)-1);
 savedialog.filter:='Perl Scripts ('+s+')|'+s+str;
 OpenDialog.filter:=savedialog.filter;
 OpenDialog.DefaultExt:=OPtions.DefPerlExtension;
 SaveDialog.DefaultExt:=OPtions.DefPerlExtension;
end;

Procedure TEditorForm._HighLightLineByPos(const F : String; Start : Integer);
var i,l,p:integer;
begin
 if not fileexists(f) then exit;
 if not MFH.openfile(f) then exit;
 memeditor.WinCharPos:=0;
 p:=0;
 i:=0;
 while (i<memeditor.Lines.Count) do
 begin
  l:=length(memEditor.memosource.StringItem[i].StrData)+1+p;
  if l>start then break;
  p:=l;
  inc(i);
 end;
 PerlSource.JumpToLine(i);
 memEditor.CenterScreenOnLine;
 PerlSource.TempHighlightLine(i,15);
end;

procedure TEditorForm._UpdateLine(const Filename : String; Line : integer; NoHigh : Boolean);
begin
   if (fileexists(Filename)) and (mfh.OpenFile(Filename)) then
    begin
     if NoHigh then
      begin
       if Line-1>=0 then
       begin
        PerlSource.JumpToLine(Line-1);
        memEditor.CenterScreenOnLine;
        PerlSource.TempHighlightLine(Line-1,13);
       end;
      end
      else
       TScriptInfo(mfh.ActiveFileInfo).runline:=Line-1
    end
   else
    begin
     MessageDlgMemo('Could not find '+filename+':'+inttostr(line), mtError, [mbOK], 0,3300);
     if not NoHigh
      then TScriptInfo(mfh.ActiveFileInfo).runline:=-1;
    end;
end;

Procedure TEditorForm._QuickSave;
var
 i:integer;
 si : TScriptInfo;
begin
 if not assigned(MFH.activefileinfo) then exit;

  for i:=0 to MFH.FileList.Count-1 do
  begin
   si:=TScriptInfo(MFH.FileList.Objects[i]);
   if si.IsNewFile then
   begin
    si.IsVeryNewFile:=false;
    if si.isPerl
     then si.path:=IncludeTrailingBackSlash(Options.DefaultScriptFolder)+extractFilename(si.path)
     else si.path:=IncludeTrailingBackSlash(Options.DefaultHtmlFolder)+extractFilename(si.path);
   end;
   try
    if si.QuickSaveModified then
    begin
     saveFile(si,false);
     si.QuickSaveModified:=False;
     si.TimeStamp:=fileage(si.path);
    end;
   Except on  exception do end;
  end;
end;

procedure TEditorForm._TemplatesUpdated(PerlTemplates : TOBject);
var
 i:integer;
 si : TScriptInfo;
begin
  for i:=0 to mfh.FileList.Count-1 do
  begin
   si:=TScriptInfo(MFH.Filelist.Objects[i]);
   si.ms.CodeTemplates.Assign(tpersistent(PerlTemplates));
  end;
end;

procedure TEditorForm._UpdateBreakpoints(RemAlso: Boolean);
var
 si : TScriptInfo;
 j:integer;
 bi : ^TBreakInfo;
begin
  for j:=0 to Breakpoints.Count-1 do
  begin
   bi:=pointer(Breakpoints.objects[j]);
   si:=GetOpenScriptinfo(Breakpoints[j]);
   if assigned(si) then
    si.SetBreakPoint(bi^);
  end;
end;

Function TEditorForm.IsRemoteFile(Const Path : String) : Boolean;
begin
 result:=stringstartswithcase(folders.RemoteFolder,path);
end;

Function TEditorForm.GetCorrOther(const Path : string) : TScriptInfo;
var
 i:integer;
 p:String;
 IsRemote : Boolean;
begin
 p:=ExtractFilename(path);
 IsRemote:=IsRemoteFile(path);
 for i:=0 to MFH.FileList.Count-1 do
 begin
  result:=TScriptInfo(MFH.FileList.Objects[i]);
  if AnsiSameText(ExtractFilename(result.Path),p) and
     (IsRemoteFile(result.path) <> IsRemote) then
   exit;
 end;
 result:=nil;
end;

Function TEditorForm.GetOpenScriptInfo(const Path : string) : TScriptInfo;
var
 i:integer;
begin
 for i:=0 to MFH.FileList.Count-1 do
 begin
  result:=TScriptInfo(MFH.FileList.Objects[i]);
  if result.path=path then exit;
 end;
 result:=nil;
end;

procedure TEditorForm._FocusEditor;
begin
 ShowAndSetFocus;
end;

procedure TEditorForm._CloseActiveFile;
begin
 CloseAction.simpleExecute;
end;

procedure TEditorForm._OpenFile(Const Data:String);
begin
 if fileexists(data) then
  MFH.OpenFile(data);
end;

Function TEditorForm._OpenTempFile(const Str: String) : Boolean;
var
 i:integer;
begin
 result:=false;
 for i:=mfh.FileList.Count-1 downto 0 do
  if IsSameFile(TScriptInfo(mfh.FileList.Objects[i]).path,str) then
  begin
   result:=true;
   break;
  end;
 _OpenFile(str);
end;

Procedure TEditorForm._Editor_ClearRecentList;
begin
 MFH.MRUList.Clear;
end;

procedure TEditorForm._SaveAllInfos;
var
 i:integer;
begin
 with mfh.FileList do
  for i:=0 to Count-1 do
   TScriptInfo(Objects[i]).writeInfoFile;
end;

procedure TEditorForm._ReloadAllInfos;
var
 i:integer;
begin
 with mfh.FileList do
 begin
  for i:=0 to Count-1 do
   TScriptInfo(Objects[i]).GetINfoFile(TScriptInfo(Objects[i]).path);
  if Count>0 then
   PC_ActiveScriptChanged;
 end;
end;

Procedure TEditorForm._RemoveRemoteFiles;
var
 i:integer;
begin
 for i:=mfh.FileList.Count-1 downto 0 do
  if stringstartswith(folders.RemoteFolder,mfh.ActiveFileInfo.path) then
   mfh.CloseByIndex(i);
 if mfh.FileList.Count=0 then
  NewAction.SimpleExecute;
end;

procedure TEditorForm._OptionsUpdated(Level : Integer);
var
 i:integer;
begin
 ThreadEnterSafeCS;
 try
  if (level=HKO_BigVisible) or (level=HKO_LiteVisible) then
  begin
   SetMemo(memEditor,[msPrimary]);
   ParsersMod.SetSyntax(options);
  end;
  MFH.ShowRefreshDialog:=options.ShowRefreshDialog;
  ParsersMod.Perl.VarDiff:=options.SCVarDiff;
  TabControl.MultiLine:=options.MultiLineTabs;
  SetDefExtensions;
  for i:=0 to mfh.FileList.Count-1 do
   SetMemoSource(TScriptInfo(MFH.Filelist.Objects[i]).ms);
  OpenDialog.FileName:='';
  OpenDialog.InitialDir:=Options.DefaultScriptFolder;
  SaveDialog.FileName:='';
  SaveDialog.InitialDir:=Options.DefaultScriptFolder;
  MFH.MRUCount:=Options.RecentItems;
  Timer.Interval:=options.CheckUpdateLag;
 finally
  ThreadLeaveSafeCS;
 end;
end;

procedure TEditorForm._InsertTextAtCursor(const Data : String);
begin
    with memeditor.memosource do
    begin
     BeginUpdate(acInsert);
     InsertString(data);
     EndUpdate;
    end;
end;


procedure TEditorForm._SyncScroll(CharPos,LinePos : Integer; Const Path : String; Sender : TObject);
begin
 if (assigned(MFH.ActiveFileInfo)) and
    (Path=MFH.ActiveFileInfo.path) and
    (Sender<>self) then
 begin
  memEditor.OnMemoScroll:=nil;
  memeditor.WinCharPos:=CharPos;
  memeditor.WinLinePos:=LinePos;
  memEditor.OnMemoScroll:=memEditorMemoScroll;
 end;
end;

procedure TEditorForm.SetParserActive(Data : TObject);
var
 si : TScriptInfo;
begin
 si:=TScriptInfo(mfh.ActiveFileInfo);
 si.ms.SyntaxParser:=TSimpleParser(data);
 si.isperl:=si.ms.SyntaxParser.Name='Perl';
 Pr_UpdateSyntaxErrors(nil,0);
 if assigned(PR_UpdateCodeExplorer) then PR_UpdateCodeExplorer;
 timer.Enabled:=true;
end;

procedure TEditorForm._ModifyForRemote;
var
 si : TScriptInfo;
begin
  si:=TScriptInfo(mfh.ActiveFileInfo);
  si.ms.ReadOnly:=true;
  si.IsModified:=false;
  si.IsNewFile:=false;
  si.IsVeryNewFile:=false;
  si.TimeStamp:=FileAge(si.path);
end;

procedure TEditorForm.ToggleBreakPoint;
begin
 memEditorClickGutter(self,TScriptInfo(mfh.activefileinfo).ms.CaretPoint.y,0,[]);
end;

procedure TEditorForm.CreateWithName(const Filename : String);
begin
 NewTemplate:='';
 MFH.DefaultName:=Filename;
 NewFilename:=MFH.DefaultName;
 mfh.New;
end;

procedure TEditorForm._Editor_TagConvert(var str : String);
var
  Prop,Abort : Boolean;

  Procedure DoStandard;
  var
   i:integer;
   s:string;
  begin
   s:=mfh.ActiveFileInfo.path;
   replaceSC(str,'%Path%',s,true);
   replaceSC(str,'%PathSN%',ExtractShortPathName(s),true);
   replaceSC(str,'%FileNoExt%',ExtractFileNoExt(s),true);
   replaceSC(str,'%Folder%',ExcludeTrailingBackslash(extractfilepath(s)),true);
   replaceSC(str,'%File%',extractfilename(s),true);
   replaceSC(str,'%Word%',memeditor.MemoSource.TextAtCursor,true);
   replaceSC(str,'%Url%',PR_ActiveHTTPAddress,true);
   replaceSC(str,'%Get%',ActiveScriptInfo.Query.activequery[qmGet],true);
   replaceSC(str,'%Post%',ActiveScriptInfo.Query.activequery[qmPost],true);
   replaceSC(str,'%Cookie%',ActiveScriptInfo.Query.activequery[qmCookie],true);
   replaceSC(str,'%Pathinfo%',ActiveScriptInfo.Query.activequery[qmPathinfo],true);
   replaceSC(str,'%argv%',ActiveScriptInfo.Query.activequery[qmCMDLine],true);

   i:=scanf(str,'%Selection%',-1);
   if i>0 then
   begin
    s:=MemEditor.SelText;
    for i:=1 to length(s) do
     if ord(s[i])<32 then s[i]:=' ';
    replaceSC(str,'%Selection%',s,true);
   end;

   i:=scanf(str,'%queryBOX%',-1);
   if (i>0) then
   begin
    s:='';
    if inputquery('Query box','Enter text:',s)
     then replaceSC(str,'%Querybox%',s,true)
     else abort:=true;
   end;
  end;

var
 Index,Len : Integer;
 Tag,Value : String;
 s:string;
begin
 prop:=false;
 abort:=false;
 DoStandard;
 while SearchTag(str,tag,value,index,len) do
 begin
  delete(str,index,len);
  if tag='toggle' then
   if options.ToggleBoolOption(value) then prop:=true;

  if tag='set' then
   if options.SetAnOption(value) then prop:=true;

  if tag='f' then
   if value<>'filename' then
   begin
    if fileexists(value)
     then s:=LoadStr(value)
     else s:='Cannot find file '+value;
    insert(s,str,index);
   end;

  if tag='o' then
   if (value<>'filename') and (fileexists(value)) then //filename is the name used in preview
    MFH.OpenFile(value);

  if tag='n' then
   if value<>'filename' then //filename is the name used in preview
    CreateWithName(value);
 end; //with

 if Abort then
  str:=#0

 else
 if prop then
 begin
  str:=#0;
  PC_OptionsUpdated(HKO_BigVisible);
 end;

end;

procedure TEditorForm._pipetool(Command : Integer; SL : TStringList; Active : TObject);
var
 i:integer;
begin
 case command of
  HKP_SEND_FILE :
   with TScriptInfo(Active).ms do
    begin
     for i:=0 to StrCount-1 do
      sl.Add(StringItem[i].StrData)
    end;
  HKP_SEND_SELECTION :
   with TScriptInfo(Active).ms do
    begin
     for i:=SelectionRect.Top to SelectionRect.bottom do
      if (i<lines.count) and (i>=0) then
       sl.Add(StringItem[i].StrData)
    end;
  HKP_GET_FILE :
   with memeditor.MemoSource do
   begin
    BeginUpdate(acStringsUpdate);
    lines.Clear;
    for i:=0 to sl.Count-1 do
     lines.add(sl[i]);
    EndUpdate;
   end;
  HKP_GET_SELECTION :
   with memeditor.MemoSource do
    begin
     BeginUpdate(acStringsUpdate);
     for i:=0 to sl.Count-1 do
      if i+selectionrect.Top<lines.Count then
       Lines[i+SelectionRect.Top]:=sl[i];
     EndUpdate;
    end;
 end;
end;

procedure TEditorForm.ClearAllRunLines;
var
 si:TScriptInfo;
 I:Integer;
begin
 for i:=0 to MFH.FileList.Count-1 do
 begin
  si:=TScriptInfo(MFH.FileList.Objects[i]);
  if Assigned(si) then si.ClearAllRunLines;
 end;
end;

procedure TEditorForm.MFHSaveCancel(sender: TObject; FileInfo: TFileInfo);
begin
 if assigned(FileInfo) then
  with FileInfo as TScriptInfo do
   if not IsNewFile then
    begin

     ms.Lines.Text:=Original;
     try
      SaveFile(FileInfo as TScriptInfo,false);
     except
      on Exception do 
     end;

    end
   else
    begin
     if fileexists(path) then deletefile(path);
    end;
end;

Function TEditorForm.ActiveVersion : String;
var
 sl:TStringList;
begin
 begin
   sl:=TStringList.create;
   try
    GetVersionLabels(memEditor.lines,sl);
    if sl.count>0
     then result:=sl[0]
     else result:='';
   finally
    sl.free;
   end;
 end;
end;

Function TEditorForm._GetOpenRemoteHost : String;
begin
 result:=ActiveScriptInfo.GetFTPSession;
 if result='' then exit;
 with FTPMod do
 begin
  if not TransTable.FindKey([result]) then exit;
  result:=TransTableLinksTo.value;
 end;
end;

Function TEditorForm._WordUnderCarret : String;
var
 mp : TPoint;
begin
  mp:=memEditor.CaretPoint;
  if memEditor.MemoSource.IsPosInBlock2(mp.x,mp.y)
   then result:=memEditor.MemoSource.SelStrings.Text
   else result:=ExtractWordFromText(PerlSource.textatcursor);
  result:=trim(result);
end;

Function TEditorForm._SelectedBlock : String;
begin
 result:=MemEditor.SelText;
end;

procedure TEditorForm.ExportHTMLActionExecute(Sender: TObject);
var pr : boolean;
begin
 {$IFDEF EXPORTCRIPPLE}
  ShowDisabledMessage;
 {$ELSE}
 if (ExportHtmlDialog.Execute) then
 begin
  pr:=options.FontAliased;

  if not pr then
  begin
   options.FontAliased:=true;
   options.ApplyStyle(ActiveEdit.Memo);
  end;

  ActiveEdit.Memo.ExportToHtmlFile(ExportHtmlDialog.FileName);

  if not pr then
  begin
   options.FontAliased:=false;
   options.ApplyStyle(ActiveEdit.Memo);
  end;

  if MessageDlgMemo('Source exported. Would you like to preview?',
                  mtConfirmation, [mbYes, mbCancel], 0,100)=mryes
   then   ShellExecute(ValidParentForm(Self).Handle,'open',
               PChar(ExportHtmlDialog.FileName),NIL,NIL,SW_SHOWNORMAL);
 end;
 {$ENDIF}
end;

procedure TEditorForm.FormDestroy(Sender: TObject);
begin
 TempFileList.free;
 EditorForm:=nil;
 {$IFDEF DEVELOP}
  SendDebug('Destroyed: '+name);
 {$ENDIF}
end;

Function TEditorForm.CanCloseEditor : Boolean;
begin
 try
  PR_SetLastOpen(true);
  result:=EditorForm.MFH.CloseAppOK;
 except
  result:=true;
 end;
end;

Procedure TEditorForm._SetLastOpen(main : Boolean);
var
 si : TScriptInfo;
 s:string;
 i:integer;
begin
 s:='';
 try
  for i:=0 to MFH.FileList.Count-1 do
  begin
   si:=TScriptInfo(MFH.FileList.Objects[i]);
   s:=s+si.path+#13#10;
  end;
 except
  s:='';
 end;

 if main then
  begin
   options.LastOpenFiles:=s;
   if assigned(ActiveScriptInfo) then
    Options.lastOpenFile:=ActiveScriptInfo.path;
  end
 else
  begin
   ProjOpt.LastOpenFiles:=s;
   if assigned(ActiveScriptInfo) then
    ProjOpt.lastOpenFile:=ActiveScriptInfo.path;
  end;
end;

function TEditorForm.GetBracketPos(var  mp : TPoint; SmartMove,LargeBuf : Boolean) : Boolean;
const
 MaxVis : array [boolean] of integer = (100,5000);
var
 DMax,DMove : Integer;
 hidlines : integer;
 SingleLine : Boolean;

 Function GetRealChar(mp : TPoint) : Char;
 var
  s:string;
  i:integer;
 begin
  with memEditor.MemoSource do
  begin
   i:=mp.x+1;
   s:=GetRealColorData(mp.Y);
   if (i<=length(s)) and (ord(s[i])=tokDelimiters) then
    Result:=memeditor.Lines[mp.y][mp.x+1]
   else
    result:=#1;
  end;
 end;

 function GetNextChar(incr : Integer; var mp : TPOint) : char;
 begin
  Inc(mp.x,incr);
  while (mp.x<0) or (mp.x+1>Length(memEditor.Lines[mp.y])) do
  begin
    if SingleLine then
    begin
     result:=#0;
     exit;
    end;
    Inc(mp.y,incr);
    if memEditor.MemoSource.LineVisible[mp.Y] then
     inc(dMove,1)
    else
     begin
      inc(hidlines);
      if hidlines>MaxVis[LargeBuf] then
       inc(dmove,1);
     end;
    if (mp.y<0) or (mp.y>memeditor.Lines.Count-1) or (dMove>DMax) then
    begin
     Result:=#0;
     Exit;
    end;
    if incr=1
     then mp.x:=0
     else mp.x:=Length(memEditor.Lines[mp.y])-1;
  end;
  result:=GetRealChar(mp);
 end;

var
 Br,SBr,c,c2 : char;
 s : string;
 i,BrLevel : integer;
 Incr:shortInt;
 mp2 : TPoint;
 justmove : boolean;

const
 maxpairs = 5;
 pairs : array[1..2] of string[maxpairs] = ('{([''"','})]''"');
 GoodChars : set of char = ['{','(','[','''','"',']','}',')'];
 //also repeated in onkeyup

begin
  if SmartMove then
   DMax:=memEditor.Lines.Count
  else
   begin
    s:=memeditor.Lines[mp.y];
    i:=mp.X;
    inc(i);
    result:=(i>=1) and (i<=length(s)) and (s[i] in GoodChars);
    if not result then exit;
    DMax:=memEditor.ClientHeight div MemEditor.LineHeight + 1;
   end;
  DMove:=0;
  hidlines:=0;
  SingleLine:=false;
  result:=false;
  if (mp.y<0) or (mp.x<0) or (mp.y>memeditor.Lines.Count-1) then
   Exit;
  s:=memeditor.Lines[mp.y];
  if (mp.x+1)>Length(s)
   then br:=#0
   else br:=getRealChar(mp);

  if (not smartmove) and (br in [#1,#0]) then  exit;

  // find if char is a bracket and which is its counter part. Also direction to
  // move for finding.
  SBr:=#0;
  justmove:=false;

  repeat
   for i:=1 to maxpairs do
   begin
     if br=pairs[1][i] then
     begin
      Incr:=1;
      SBr:=pairs[2][i];
      break;
     end;
     if br=pairs[2][i] then
     begin
      Incr:=-1;
      SBr:=pairs[1][i];
      break;
     end;
   end;
   if (sbr=#0) then
   begin
    if (smartMove) then
     begin
      justmove:=true;
      br:=getnextchar(1,mp);
      if br=#0 then exit;
     end
    else
      exit;
   end;
  until sbr<>#0;
  SingleLine:=(br in ['"','''']);

  if justmove then begin
   result:=true;
   exit;
  end;

  if SBr=#0 then begin
   Result:=False;
   exit;
  end;

  //now to find where the opening or closing is.

  if br<>sbr then
  begin
   BrLevel:=1;
   repeat
    c:=GetNextChar(incr,mp);
    if c=#0 then break
     else
    if c=SBr then Dec(brLevel)
     else
    if c=br then Inc(BrLevel)
   until brlevel=0;
   Result:=c<>#0;
  end
   else

  begin
   mp2:=mp;
   Result:=False;
   repeat
    c:=GetNextChar(1,mp);
    c2:=getnextchar(-1,mp2);
    if (c=#0) and (c2=#0) then Exit;
   until (c=br) or (c2=br);
   Result:=True;
   if c2=br then mp:=mp2;
  end;
end;

procedure TEditorForm.GetMatching(SelectAlso : Boolean);
var
 Otp,tp,cp : TPoint;
 OrgLarger : Boolean;
begin
 otp:=memeditor.MemoSource.GetCaretPoint;
 tp:=otp;
 if not GetBracketPos(tp,true,true) then exit;

 if SelectAlso then
  begin
   OrgLarger:=(otp.Y>tp.Y) or ((otp.Y=tp.Y) and (otp.x>tp.X));
   if OrgLarger
    then cp:=otp
    else cp:=tp;
   memeditor.CaretPos:=cp;
   if OrgLarger
    then memEditor.MemoSource.SetSelection(stStreamSel,tp.X+1,tp.Y,otp.X,otp.Y)
    else memEditor.MemoSource.SetSelection(stStreamSel,otp.X+1,otp.Y,tp.X,tp.Y);
  end
 else
  memeditor.CaretPos:=Tp;
end;

procedure TEditorForm.memEditorMouseMove(Sender: TObject;
 Shift: TShiftState; X, Y: Integer);
var
 tp : tpoint;
begin
 if (shift=[ssRight]) and (x<=memEditor.GutterWidth) and
    (options.GutterVisible) then
 begin
  tp:=memEditor.ConvertMousePosEx(x,y,True);
  if StartDragLine=-1 then
   StartDragLine:=tp.Y;
  memEditor.MemoSource.SetLinesSelection(tp.y,startdragline);
  exit;
 end;

 if (Options.DoBracketMouseSearch) and (shift = [ssCtrl]) then
  begin
   tp:=memEditor.ConvertMousePosEx(x,y,True);
   if GetBracketPos(tp,false,true)
    then
    begin
     inc(tp.x);
     if (tp.x<>bracketpoint.x) or (tp.y<>bracketpoint.y) then
     begin
      memEditor.InvalidateLines(bracketpoint.y,bracketpoint.Y,false);
      bracketpoint:=tp;
      memEditor.InvalidateLines(bracketpoint.y,bracketpoint.Y,false);
     end;
    end
   else
    begin
     if BracketPoint.x<>-1 then
     begin
      memEditor.InvalidateLines(bracketpoint.y,bracketpoint.Y,false);
      BracketPoint.x:=-1;
      memEditor.InvalidateLines(bracketpoint.y,bracketpoint.Y,false);
     end;
    end;
  end
 else
  begin
   HighLightTimer.OnTimer(sender);
  end;
end;

procedure TEditorForm.ExportRTFActionExecute(Sender: TObject);
var pr : Boolean;
begin
 {$IFDEF EXPORTCRIPPLE}
  ShowDisabledMessage;
 {$ELSE}
 if (ExportRTFDialog.Execute) then
 begin

  pr:=options.FontAliased;

  if not pr then
  begin
   options.FontAliased:=true;
   options.ApplyStyle(ActiveEdit.Memo);
  end;

  ActiveEdit.Memo.ExportToRtfFile(ExportRTFDialog.FileName);

  if not pr then
  begin
   options.FontAliased:=false;
   options.ApplyStyle(ActiveEdit.Memo);
  end;

  if MessageDlgMemo('RTF exported. Would you like to preview?',
                  mtConfirmation, [mbYes, mbCancel], 0,200)=mryes
   then   ShellExecute(ValidParentForm(Self).Handle,'open',
               PChar(ExportRTFDialog.FileName),NIL,NIL,SW_SHOWNORMAL);
 end;
 {$ENDIF}
end;

procedure TEditorForm.memEditorKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var tp:tpoint;
begin
 if key=93 then
 begin
  buttonclick;
  exit;
 end;
 if not Options.DoBracketSearch then exit;
 tp:=memeditor.CaretPos;
 if CharPressMode then
  dec(tp.x);
 if (key<>VK_Control) and (getbracketpos(tp,false,false)) then
  begin
   inc(tp.x);
   memEditor.InvalidateLines(bracketpoint.y,bracketpoint.Y,false);
   bracketpoint:=tp;
   memEditor.InvalidateLines(bracketpoint.y,bracketpoint.Y,false);
   HighLightTimer.enabled:=false;
   HighLightTimer.enabled:=true;
  end
end;

procedure TEditorForm.memEditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 memEditor.HidePopupHint;
 CharPressMode:=false;

 if (ssCtrl in shift) and (key=vk_tab) and (tabcontrol.tabs.Count>1) then
 begin
  MFH.OnChanging;
  tabcontrol.changetab(not (ssShift in Shift));
  MFH.OnChange;
 end;

 if options.EnableHHHEEE then
 begin
  if (shift=[]) and (key=vk_home) and (lastKeyNav=1) then
  begin
   memeditor.MemoSource.JumpToLine(0);
   LastKeyNav:=0;
   exit;
  end;
  if (shift=[]) and (key=vk_end) and (lastKeyNav=2) then
  begin
   memeditor.MemoSource.JumpToLine(memeditor.lines.count-1);
   LastKeyNav:=0;
   exit;
  end;
  if (shift=[]) and (key=vk_home) and (memeditor.CaretPos.x=0) then
  begin
   memeditor.JumpToScreentop;
   LastKeyNav:=1;
   exit;
  end;
  if (shift=[]) and (key=vk_end) and
     (memeditor.CaretPos.x=length(memeditor.Lines[memeditor.CaretPos.y])) then
  begin
   memeditor.JumpToScreenBottom;
   LastKeyNav:=2;
   exit;
  end;
 end;
 LastKeyNav:=0;
end;

procedure TEditorForm.memEditorKeyPress(Sender: TObject; var Key: Char);
begin
 CharPressMode:=not (key in [#9,#8,#13]);
 HighLightTimer.OnTimer(self);
end;

procedure TEditorForm.OpenDialogCanClose(Sender: TObject;
  var CanClose: Boolean);
var
 fs : TFileStream;
 i : Integer;
begin
 canclose:=True;
 with OpenDialog do
 for i:=0 to Files.Count-1 do
 begin

 try
  fs:=TFileStream.Create(files[i],fmOpenRead or fmShareDenyWrite);
  fs.Free;
 except
  on Exception do
  begin
   canclose:=False;
   MessageDlg('Could not open '+files[i]+'.'+#13+#10+'Make sure you have read/write access to the file.'+#13+#10+''+#13+#10+'If this script is being used right now as cgi on your '+#13+#10+'server, please make a copy of it first.', mtError, [mbOK], 0);
  end;
 end;

 end;
end;

procedure TEditorForm.ShowAndSetFocus;
begin
 Show;
 memEditor.SetFocus;
end;

procedure TEditorForm.OpenDialogClose(Sender: TObject);
begin
 with OPenDialog do
  LastOpenFilterIndex:=opendialog.FilterIndex
end;

procedure TEditorForm.SaveDialogClose(Sender: TObject);
begin
 with SaveDialog do
  LastSaveFilterIndex:=Savedialog.FilterIndex
end;

procedure TEditorForm.MFHOneClosed(sender: TObject; FileInfo: TFileInfo);
var
 i:integer;
 bi : ^TbreakInfo;
 r:trect;
begin
 try
  PlugMod.OnDocumentClose(fileinfo.path);
 finally
  PC_OneClosed(fileinfo);
  for i:=breakpoints.count-1 downto 0 do
  begin
   if fileinfo.path=breakpoints[i] then
   begin
    bi:=pointer(breakpoints.Objects[i]);
    dispose(bi);
    breakpoints.Delete(i);
   end;
  end;
  i:=tabcontrol.TabIndex-1;
  if i>0 then
  repeat
   r:=tabcontrol.TabRect(i);
   if r.right<10
    then tabcontrol.ScrollTabs(-1)
    else break;
  until false;
 end;
end;

procedure TEditorForm.MouseTimerTimer(Sender: TObject);
begin
 MouseTimer.Enabled:=false;
 MouseTimer.Tag:=0;
 if mousetimergodec<>'' then
 begin
  PR_FindDeclaration(mouseTimerGoDec);
  memEditor.memosource.SetSelection(stNotSelected,0,0,0,0);
 end;
end;

procedure TEditorForm.memEditorDblClick(Sender: TObject);
begin
 MouseTimer.Enabled:=false;
 MouseTimer.Tag:=1;
end;

procedure TEditorForm.memEditorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (Button = mbRight) and (options.GutterVisible) and (x<=memEditor.GutterWidth) then
  StartDragLine:=-1;
end;

procedure TEditorForm.memEditorMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 tp : TPoint;
 w:String;
 HasBP : boolean;
begin
 if Button = mbRight then
 begin
   if (options.GutterVisible) and (x<=memEditor.GutterWidth) then
    begin
     if startDragLine=-1 then
      begin
       tp:=memEditor.ConvertMousePosEx(x,y,True);
       memEditor.MemoSource.SetLinesSelection(tp.y,tp.y);
       try
        HasBP:=breakpoints.IndexOfObject(tobject(
         memEditor.MemoSource.StringItem[tp.y].ObjData))>=0;
       except
        exit;
       end;  
       if HasBP
        then PR_DoBreakConditions
        else memEditor.MemoSource.SetLinesSelection(tp.y,tp.y);
      end
     else
      StartDragLine:=-1;
    end
   else
    begin
     MouseOnTab:=false;
     ButtonClick;
    end;
   exit;
 end;

 if (ssCtrl in shift) and (mouseTimer.tag=0) then
  begin
   tp.x:=x;
   tp.y:=y;
   w:=ExtractWordFromText(memEditor.TextAtMousePoint(tp));
   if length(w)=0 then Exit;
   mouseTimerGoDec:=w;
   MouseTimer.Enabled:=true;
  end
 else
  mouseTimer.tag:=0;
end;

procedure TEditorForm._DoErrorThreadDone;
begin
 memEditor.invalidate;
 PR_UpdateSyntaxErrors(CurErrors,CurErrorsStatus);
 CheckForErrorLine(memEditor.MemoSource.CaretPoint.Y);
end;

Function TEditorForm.FindErrorLine(y : Integer) : Integer;
var i:integer;
begin
 if (CurErrorsShowing=ActiveScriptInfo) and (activescriptinfo.isperl) then
 begin
  for i:=0 to length(CurErrorsLines)-1 do
   if CurErrorsLines[i].Line=y then
   begin
    result:=CurErrorsLines[i].Index;
    exit;
   end;
 end;
 result:=-1;
end;

Procedure TEditorForm.CheckForErrorLine(Y : Integer);
begin
 y:=FindErrorLine(y);
 if y>=0 then
  begin
   if not IsSimpleBar then
    begin
     StatusBar.SimplePanel:=true;
     StatusBar.SimpleText:=CurErrors[y];
    end;
  end
 else
  StatusBar.SimplePanel:=IsSimpleBar;
end;

procedure TEditorForm.memEditorGetColorStyle(Sender: TObject;
  APoint: TPoint; var AStyle: Integer);
begin
 with bracketpoint do
  if (apoint.x=x) and (apoint.y=y)
   then AStyle:=16;
end;

Function TEditorForm.IsHtmlLine(Line : Integer) : Boolean;
var
 j:integer;
begin
 result:=scanf(extractfileext(activescriptinfo.path),'htm',-1)<>0;
 if activescriptinfo.IsPerl then
  result:=false;
 if not result then
 begin
  j:=(TPerlStorage(memEditor.memosource.StringItem[Line].ParserState).State and $F0) shr 4;
  result:=j in [psHTMLQString,psHTMLString,psSQHtml];
 end;
end;

procedure TEditorForm.DoCommentTogle(var S : string; Line : Integer);
var
 i : integer;
begin
 if S = '' then exit;
 i:=commpcre.MatchStr(s);
 if (i>2) then
  s:=commpcre.SubStr(1)+commpcre.SubStr(i-1)
 else
  begin
   if ForceHTMLComment and IsHtmlLine(line)
    then s:='<!-- '+s+' -->'
    else s:='#'+s;
  end;
end;

procedure TEditorForm.DoCommentAdd(var S : string; Line : Integer);
begin
 if S = '' then exit;
 if ForceHTMLComment and IsHTMLLine(line)
  then s:='<!-- '+s+' -->'
  else s:='#'+s;
end;

procedure TEditorForm.DoCommentRemove(var S : string; Line : Integer);
var
 i : integer;
begin
 if S = '' then exit;
 i:=commPcre.matchStr(s);
 if i>1 then
  s:=commpcre.SubStr(i-1);
end;

Procedure TEditorForm.DoComment(comm : TCommentChangeType);
begin
 ForceHTMLComment:=IsHTMLLine(memEditor.MemoSource.SelectionRect.Top);

 with memEditor.MemoSource do
  case comm of
    ccToggle : DoWithBlockStr(acIndentBlock,DoCommentTogle,true);
    ccAdd : DoWithBlockStr(acIndentBlock,DoCommentAdd,true);
    ccRemove : DoWithBlockStr(acIndentBlock,DoCommentRemove,true);
  end;
end;

procedure TEditorForm.memEditorMemoScroll(Sender: TObject;
  ScrollStyle: TScrollStyle; Delta: Integer);
begin
 if OPtions.SyncScroll then
  PC_SyncScroll(memEditor.winCharPos,memEditor.firstLinePos,
     MFH.activefileinfo.path,self);
end;

procedure TEditorForm.HighlightTimerTimer(Sender: TObject);
begin
 if bracketpoint.x<>-1 then
 begin
  memEditor.InvalidateLines(bracketpoint.y,bracketpoint.Y,false);
  bracketpoint.x:=-1;
 end;
 HighLightTimer.Enabled:=false;
end;

procedure TEditorForm.OnServerStatus(Sender : TObject; const Status: string);
begin
 StatusBar.Panels[4].Text:='Server: '+status;
 StatusBar.SimplePanel:=IsSimpleBar;
end;

procedure TEditorForm.OnStat(Sender: TObject);
begin
 if assigned(debmod) then
  StatusBar.Panels[3].Text:='Debugger: '+StatusStr[debmod.status];
 StatusBar.SimplePanel:=IsSimpleBar;
end;

procedure TEditorForm.ApplicationEventsShowHint(var HintStr: String;
  var CanShow: Boolean; var HintInfo: THintInfo);
var
 s:string;
 mp,cp : TPoint;
 bi : PBreakInfo;
begin
 if (hintinfo.HintControl=memEditor) and (options.autoevaluation) then
 begin
  CanShow:=True;
  cp:=memeditor.ScreentoClient(mouse.CursorPos);
  mp:=memEditor.ConvertMousePosEx(cp.x,cp.y,true);

  if Cp.x<memEditor.GutterWidth then
   begin
    try
     bi:=PBreakInfo(memEditor.MemoSource.stringItem[mp.y].ObjData);
    except
     bi:=nil;
    end;

    if assigned(bi) then
     begin
      HintStr:='Condition: '+bi.Condition;
      s:='Breakpoint';
     end
    else
     begin
      HintStr:='';
      s:='';
     end;
   end

  else
   begin
    if memEditor.MemoSource.IsPosInBlock(mp.x,mp.y)
     then s:=memEditor.MemoSource.SelStrings.Text
     else s:=ExtractWordFromText(memEditor.TextAtMousePoint(cp));
    if PrevHintExpression<>S
     then HintStr:=MemoHintText(s)
     else HintStr:=PrevHintText;
   end;


  if (length(s)=0) or (length(HintStr)=0) then
   begin
    Application.HideHint;
    PrevHintExpression:='';
    PrevHintText:='';
   end
  else
   with hintinfo do
    begin
     HideTimeout:=60000;
     ReshowTimeout:=options.LiveEvalDelay;
     PrevHintExpression:=s;
     PrevHintText:=HintStr;
    end;

 end;
end;

function TEditorForm.MemoHintText(const Text: string): string;
var s:string;
begin
 Result:=Text;
 PC_PerlExpressionResult(Result);
 result:=trim(result);

 s:='';
 if options.CodeComHints then
  PC_GetDeclarationHint(text,s);

 if (length(result)=0) and (length(s)>0) then
  result:=s
 else
 if (length(result)>0) and (length(s)=0) then
 //nothing
 else
 if (length(result)>0) and (length(s)>0) then
  result:=result+HintLineSplitter+s
 else
 result:='';
end;

procedure TEditorForm.CodeCompActionExecute(Sender: TObject);
var
 Sl: TStringList;
 AllowPopup: Boolean;
 PopupType: TPopupType;
 pt:TPoint;
begin
 sl:=TStringList.create;
 try
  AllowPopup:=false;
  memEditorHintPopup(nil,sl,allowpopup,popuptype);
  if AllowPopup then
  begin
   if PopupType = ptListBox
    then memeditor.ShowPopupListBox(sl)
   else
    begin
     Pt := ClientToScreen(memeditor.TextToPixelPoint(memEditor.CaretPoint));
     memEditor.ShowPopupHint(sl.Text,pt,true);
    end;
  end;
 finally
  sl.free;
 end;
end;

procedure TEditorForm.memEditorHintPopup(Sender: TObject;
  Strings: TStrings; var AllowPopup: Boolean; var PopupType: TPopupType);
var
 s,r:string;
 x,y,i : integer;
 AllowList : Boolean;
 AllowHint : Boolean;
begin
 AllowList:=((sender=nil) or (options.CodeComEnable)) and (not memEditor.ReadOnly);
 AllowHint:=(sender=nil) or (options.CodeComHints);
 InsertHTMLItem:=false;

 x:=memeditor.MemoSource.CaretPoint.x;
 y:=memeditor.MemoSource.CaretPoint.y;
 s:=memeditor.Lines[y];

 if s='' then
 begin
  if AllowList then
  begin
   popuptype:=ptListBox;
   allowpopup:=true;
   for i:=0 to high(PerlTags) do
   strings.Add(PerlTags[i]);
  end;
  exit;
 end;

 if (x<0) or (x>length(s)) then exit;

 if (s[x]='<') AND (options.CodeComHTML) and (isHTMLLine(y)) then
 begin
  popuptype:=ptListBox;
  InsertHTMLItem:=true;
  allowpopup:=true;
  for i:=0 to high(HTMLTags) do
   strings.Add(HTMLTags[i].Name+' - '+copy(htmltags[i].Comment,1,60));
  exit;
 end;

 if not (s[x] in ['>','''',':']) then
 begin
  if AllowHint then
  begin
   s:=memeditor.MemoSource.TextAtCursor;
   r:='';
   PC_GetDeclarationHint(s,r);
   allowpopup:=r<>'';
   popuptype:=ptHint;
   strings.Add(r);
  end;
  exit;
 end;

 if allowList then
 begin
  CodeComplete.LoadDeb(memEditor.Lines,Strings,MFH.ActiveFileInfo.path,s,x);
  popuptype:=ptListBox;
  AllowPopup:=Strings.Count>0;
 end; 
end;

procedure TEditorForm.memEditorHintInsert(Sender: TObject; var s: String);
var p:integer;
begin
 p:=1;
 s:=FirstWord(s,p);
 DeleteStartsWith('~',s);
 DeleteStartsWith('$',s);
 DeleteStartsWith('%',s);
 DeleteStartsWith('@',s);
 if inserthtmlitem then
  s:=s+'></'+s+'>';
end;

procedure TEditorForm.UnixFormatActionExecute(Sender: TObject);
begin
 memEditor.MemoSource.OutFormat:=ofUnix;
 MFH.ActiveFileInfo.Modified;
end;

procedure TEditorForm.WindowsFormatActionExecute(Sender: TObject);
begin
 memEditor.MemoSource.OutFormat:=ofWindows;
 MFH.ActiveFileInfo.Modified;
end;

procedure TEditorForm.MacFormatActionExecute(Sender: TObject);
begin
 memEditor.MemoSource.OutFormat:=ofMac;
 MFH.ActiveFileInfo.Modified;
end;

procedure TEditorForm.FormatUpdate(Sender: TObject);
begin
 TAction(sender).Checked:=ord(memEditor.MemoSource.OutFormat)=TAction(sender).Tag;
end;

procedure TEditorForm.TabControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 i:integer;
begin
 if Button = mbRight then
 begin
  i:=TabControl.GetTabIndex(x,y);
  MFH.SelectByIndex(i);
  MouseOnTab:=true;
  ButtonClick;
 end;
end;

procedure TEditorForm.memRealTimeColor(Sender: TObject; Line: integer);
const
 tokIdentifier = 3;
 tokDeclared = 27;
 tokVariables = 31;
 tokFunWord = 28;
var
 i,j,l,p:integer;
 w:string;
 s,colors : String;
 modif : boolean;
 si : dcstring.TStringItem;
begin
 si:=memEditor.MemoSource.stringitem[line];
 if not assigned(si) then exit;
 if (not memEditor.UseMonoFont) and
    (line=memEditor.MemoSource.CaretPoint.Y) then
 begin
  NextMoveMustInvalidateLine:=line;
  exit;
 end;

 modif:=false;
 with si do
 begin
  s:=StrData;
  colors:=ColorData;
 end;

 i:=1;
 l:=length(colors);
 while (i<=l) do
 begin
  if ord(Colors[i]) in [tokDeclared] then
  begin
   j:=1;
   p:=j+i;
   while (p<=l) and (ord(colors[p])=tokDeclared) do
   begin
    inc(j);
    inc(p);
   end;
   w:=copy(s,i,j);
   if not IsDeclaration(w) then
   begin
    modif:=true;
    break;
   end;
   inc(i,j);
  end;
  inc(i);
 end;

 if modif then
 begin
  si.ItemState:=si.ItemState - [isWasParsed];
  memEditor.MemoSource.ParseStrings(line,line,true);
  colors:=si.ColorData;
  modif:=false;
 end;

 i:=1;
 l:=length(colors);

 while (i<=l) do
 begin
  if ord(Colors[i]) in [tokIdentifier,tokVariables,tokFunWord] then
  begin
   j:=1;
   p:=j+i;
   while (p<=l) and (colors[p]=colors[i]) do
   begin
    inc(j);
    inc(p);
   end;
   w:=copy(s,i,j);
   if IsDeclaration(w) then
   begin
    fillchar(colors[i],j,tokDeclared);
    modif:=true;
   end;
   inc(i,j);
  end;
  inc(i);
 end;
 if modif then
  si.ColorData:=colors;
end;

procedure TEditorForm.memEditorJumpToUrl(Sender: TObject; const s: String;
  var Handled: Boolean);
begin
//Should be empty for default action
end;

procedure TEditorForm.ExportHTMLActionUpdate(Sender: TObject);
begin
 ExportHTMLAction.Enabled:=ActiveEdit.IsMemoActive;
end;

procedure TEditorForm.ExportRTFActionUpdate(Sender: TObject);
begin
 ExportRTFAction.Enabled:=ActiveEdit.IsMemoActive;
end;

procedure TEditorForm.ApplicationEventsIdle(Sender: TObject;
  var Done: Boolean);
var
 mp : TPoint;
begin
 if application.Active then
 begin
  mp:=mouse.CursorPos;
  if (mp.X<>prevMousePos.X) or (mp.y<>prevMousePos.y) then
  begin
   if (FindVCLWindow(mouse.CursorPos)=memeditor)
    then application.HintPause:=options.LiveEvalDelay
    else application.HintPause:=500;
   PrevMousePos:=mouse.CursorPos;
  end;
 end;
end;

procedure TEditorForm.ReloadActionUpdate(Sender: TObject);
begin
 ReloadAction.Enabled:=(assigned(ActiveScriptInfo)) and
  (not ActiveScriptInfo.IsNewFile) and
  (length(ActiveScriptInfo.GetFTPSession)=0);
end;

procedure TEditorForm.ResetPermActionExecute(Sender: TObject);
var i:integer;
begin
 for i:=0 to MFH.FileList.Count-1 do
 with MFH.FileList.Objects[i] as TScriptInfo do
 begin
  if fileexists(path) then
   ms.ReadOnly:=FileReadOnly(path);
 end;
 MFHTabChanged(nil);
end;

procedure TEditorForm.TimerTimer(Sender: TObject);
begin
 Timer.Enabled:=false;
 if (TicksNextCode<>0) and (GetTickCount>TicksNextCode) then
 begin
  Assert(false,'LOG RESTART ERROR CHECK');
  TicksNextCode:=0;
  RestartThread;
 end;
 SetEvent(EventStartCode);
end;

procedure TEditorForm.TabControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if (ssDouble in shift) and (options.CloseTabDoubleClick) and
    (CloseAction.Enabled) then
  CloseAction.SimpleExecute;
end;


procedure TEditorForm.InsertfileatcursorItemClick(Sender: TObject);
var
 i:integer;
 f:string;
begin
 with TempFileList do
  for i:=0 to count-1 do
   if fileexists(strings[i]) then
    f:=f+loadstr(strings[i]);
 memEditor.MemoSource.insertstring(f);
end;

procedure TEditorForm.OpenFileItemClick(Sender: TObject);
var
 i:integer;
begin
 with TempFileList do
  for i:=0 to count-1 do
  begin
   PR_OPenFile(Strings[i]);
   MFH.AddMruList(Strings[i]);
  end;
end;

procedure TEditorForm.DropFileTargetDrop(Sender: TObject;
  ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
var
 i:integer;
begin
 TempFileList.Clear;
 TempFileList.Assign(DropFileTarget.Files);

 if tabcontrol.GetTabIndex(point.X,point.y)<0
  then DropMenu.Popup(mouse.CursorPos.X,mouse.CursorPos.y)
  else OpenFileItem.Click;
end;

procedure TEditorForm.DropFileTargetDragOver(Sender: TObject;
  ShiftState: TShiftState; Point: TPoint; var Effect: Integer);
var
 cp : TPoint;
 i:integer;
begin
 i:=tabcontrol.GetTabIndex(point.X,point.y);
 if i>=0 then
  begin
   if tabcontrol.TabIndex<>i then
    MFH.SelectByIndex(i);
  end
 else
  with memEditor Do
  begin
   dec(point.x,Left);
   dec(point.Y,Top);
   i:=GutterWidth;
   cp:=ConvertMousePosEx(point.x,point.y,false);
   if (point.x<i) or (point.x>clientWidth) or (point.y>clientheight) or (point.y<0) then
    Effect:=DROPEFFECT_NONE
   else
    begin
     SetFocus;
     CaretPos:=cp;
    end;
 end;
end;

procedure TEditorForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 if MouseOnTab then
  begin
   popup.ItemLinks:=siTabPop.itemLinks;
   popup.tag:=1000;
  end
 else
  begin
   popup.ItemLinks:=siEditorPop.itemLinks;
   popup.tag:=0;
  end;
end;

procedure TEditorForm.WMHelp(var Message: TWMHelp);
var
 s:string;
begin
  s:=ExtractWordFromText(EditorForm.memEditor.MemoSource.TextAtCursor);
  PR_SearchForWord(s);
end;

function TEditorForm._GetFindText(Advanced: Boolean): String;
begin
 if (options.FindText or not Advanced)
  then result:=PR_WordUnderCarret
  else result:=memEditor.MemoSource.SelStrings.Text;
end;

Function TEditorForm.HistoryListCurrent : String;
var
 pt : TPoint;
begin
 pt:=memEditor.MemoSource.CaretPoint;
 Result:=Format('%s - %d:%d',[ActiveScriptInfo.path,pt.X,pt.Y]);
end;

Procedure TEditorForm.HistoryListGoto;
var i:integer;
begin
 if historyPcre.MatchStr(historyList)<3 then exit;
 i:=0;
 while (i<MFH.FileList.Count) do
  if TScriptInfo(MFH.FileList.Objects[i]).path=historyPcre.SubStr(1) then
   begin
    MFH.SelectByIndex(i);
    break;
   end
  else
   inc(i);

 if (i=MFH.FileList.Count) then
  if (not fileexists(historyPcre.SubStr(1))) or
     (not MFH.OpenFile(historyPcre.SubStr(1))) then exit;

 memEditor.MemoSource.CaretPoint:=point(
  StrToInt(historyPcre.SubStr(2)),StrToInt(historyPcre.SubStr(3)));
 memEditor.CenterScreenOnLine;
end;

procedure TEditorForm._GotoLine(const Filename : String; Line : Integer);
begin
 HistoryList:=HistoryListCurrent;

 if (Filename='') or (MFH.OpenFile(Filename)) then
 begin
  memEditor.memosource.JumpToLine(line);
  ShowAndSetFocus;
  memEditor.CenterScreenOnLine;
  PerlSource.TempHighlightLine(line,15);
 end;
end;

procedure TEditorForm.BrowseBackActionExecute(Sender: TObject);
var s:String;
begin
 s:=HistoryListCurrent;
 HistoryListGoto;
 HistoryList:=s;
end;

procedure TEditorForm.BrowseBackActionUpdate(Sender: TObject);
begin
 BrowseBackAction.Enabled:=ActiveEdit.IsMainActive and (length(HistoryList)>0);
end;

procedure TEditorForm.ClearHighlightsActionExecute(Sender: TObject);
var i:integer;
begin
 for i:=0 to 3 do
  PR_SetPattern(i,'',false);
end;

procedure TEditorForm.memEditorCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
 if (options.WordWrap) and (not options.WordWrapMargin) and (not options.PrintingNow) then
  with memEditor do
   if OptOptions.options.UseMonoFont
    then MarginPos:=imax(GetMaxCaretChar+1,30)
    else MarginPos:=imax(Round(GetMaxCaretChar * 0.70),30);
end;

procedure TEditorForm.StatusBarDblClick(Sender: TObject);
var pt : TPoint;
begin
 if (not assigned(ActiveEdit)) or (not assigned(activeEdit.memo)) then exit;
 pt:=StatusBar.ScreenToClient(mouse.CursorPos);
 if pt.X<StatusBar.Panels[0].Width then
 begin
  ActiveEdit.Memo.memosource.ShowGoToLineDialog;
  if activeedit.IsMainActive then
   ActiveEdit.MainMemo.SetFocus;
 end;
end;

function TEditorForm.MFHBeforeOpen(Sender: TObject; Const Filename: String): Boolean;
begin
 result:=PlugMod.OnDocumentOpen(filename);
end;

end.
