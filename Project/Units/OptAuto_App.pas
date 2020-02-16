{***************************************************************
 *
 * Unit Name: OptAuto_App
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptAuto_App;
{$I REG.INC}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, SysUtils, ComObj, ActiveX, AxCtrls, Classes, OptiPerl_TLB, StdVcl, ComServ,controls,
  variants,aqdocking,hakafile,HKActions,Forms,agPropUtils,ActnList,OptControl,HakaWin,hakageneral,
  EditorFrm, ScriptInfoUnit, ProjectFrm, MainFrm, OptProcs, ExplorerFrm,dxbar,aqDockingBase,
  PlugBase,WebBrowserFrm,OptAuto_Control,OptOptions, PlugCommon,PlugTypes,
  OptForm,PlugInFrm,OptAuto_Doc,OptAuto_Project,OptAuto_Nodes,ItemMdl;

type
  TApplication = class(TAutoObject, IConnectionPointContainer, IApplication)
  private
    { Private declarations }
    FConnectionPoints: TConnectionPoints;
    FConnectionPoint: TConnectionPoint;
    FEvents: IApplicationEvents;
    { note: FEvents maintains a *single* event sink. For access to more
      than one event sink, use FConnectionPoint.SinkList, and iterate
      through the list of sinks. }
  public
    ModalHandle : THandle;
    procedure Initialize; override;
    Destructor Destroy; Override;
  protected
    { Protected declarations }
    property ConnectionPoints: TConnectionPoints read FConnectionPoints
      implements IConnectionPointContainer;
    procedure EventSinkChanged(const EventSink: IUnknown); override;
    function Get_DocumentCount: Integer; safecall;
    function Get_ActiveDocument: OleVariant; safecall;
    function Get_Documents(Index: Integer): OleVariant; safecall;
    function Get_Project: OleVariant; safecall;
    function Get_CodeExplorer: OleVariant; safecall;
    procedure EndPlugIn(process: Integer); safecall;
    procedure OutputAddLine(const Text: WideString); safecall;
    procedure OutputClear; safecall;
    function Get_Windows(const Name: WideString): OleVariant; safecall;
    function RequestWindow(Process: Integer): OleVariant; safecall;
    function Get_Handle: Integer; safecall;
    procedure UpdateOptions(Everything: WordBool); safecall;
    procedure StatusBarRestore; safecall;
    procedure StatusBarText(const Text: WideString); safecall;
    procedure ExecuteAction(const Action: WideString); safecall;
    function Get_FocusedControl: OleVariant; safecall;
    procedure Set_FocusedControl(Value: OleVariant); safecall;
    function Get_EditorControl: OleVariant; safecall;
    procedure DockWindow(Process, Handle: Integer; const Parent: IWindow);   safecall;
    function GetOpt(const Name: WideString): OleVariant; safecall;
    procedure SetOpt(const Name: WideString; Value: OleVariant); safecall;
    function Get_Self: Integer; safecall;
    function OpenDocument(const Filename: WideString): OleVariant; safecall;
    function NewDocument(const Filename: WideString): OleVariant; safecall;
    procedure CloseDocument; safecall;
    procedure QuickSave; safecall;
    function Get_ToolBarLinks(Process: Integer): OleVariant; safecall;
    procedure UpdateToolBars(Process: Integer); safecall;
    function CreateToolItem(Process: Integer;
      const ClassName: WideString): OleVariant; safecall;
    procedure DestroyWindow(Process: Integer; const Window: IWindow); safecall;
    procedure GrabWindow(Process: Integer; Enable: WordBool; Handle: Integer);
      safecall;
    procedure ProcessMessages; safecall;
    function GetWindowHandle(const Window: IWindow): Integer; safecall;
    procedure ToolBarVisible(Process: Integer; Visible: WordBool); safecall;
    function GetColor(const Name: WideString): WideString; safecall;
    procedure SetColor(const Name, Value: WideString); safecall;
    function MessageBox(const Caption, Prompt: WideString;
      Flags: Integer): Integer; safecall;
    function InputBox(const Caption, Prompt, Default: WideString): WideString;
      safecall;
    procedure CloseDocumentIndex(Index: Integer); safecall;
  end;

implementation

uses
  Dialogs;
Var
 App : TApplication;

procedure TApplication.EventSinkChanged(const EventSink: IUnknown);
begin
  FEvents := EventSink as IApplicationEvents;
end;

procedure TApplication.Initialize;
begin
  inherited Initialize;
  App:=self;
  FConnectionPoints := TConnectionPoints.Create(Self);
  if AutoFactory.EventTypeInfo <> nil then
    FConnectionPoint := FConnectionPoints.CreateConnectionPoint(
      AutoFactory.EventIID, ckSingle, EventConnect)
  else FConnectionPoint := nil;
end;

function TApplication.Get_DocumentCount: Integer;
begin
 result:=EditorForm.MFH.FileList.Count;
end;

function TApplication.Get_Documents(Index: Integer): OleVariant;
begin
 result:=GetDocument(TScriptInfo(EditorForm.MFH.FileList.Objects[index]));
end;

function TApplication.Get_ActiveDocument: OleVariant;
begin
 result:=GetDocument(ActiveScriptInfo);
end;

function TApplication.Get_Project: OleVariant;
begin
 result:=GetProject(projectForm);
end;

function TApplication.Get_CodeExplorer: OleVariant;
begin
 result:=GetTreeView;
end;

procedure TApplication.EndPlugIn(process: Integer);
begin
 PostMessage(Application.mainform.handle,HK_P_Terminate,Process,0)
end;

procedure TApplication.OutputAddLine(const Text: WideString);
begin
 WebBrowserForm.memOutput.Lines.Add(text);
end;

procedure TApplication.OutputClear;
begin
 WebBrowserForm.memOutput.Lines.Clear;
end;

function TApplication.Get_Windows(const Name: WideString): OleVariant;
var
 i:integer;
begin
 with optiMainform.DockingManager.Items do
  for i:=0 to count-1 do
   if AnsiCompareText(copyFromToEnd(items[i].Name,3),name)=0 then
    if Items[i].Tag<>0 then
    begin
     result:=GetWindow(TOptiForm(Items[i].Tag));
     exit;
    end;
end;

procedure TApplication.DockWindow(Process, Handle: Integer;
  const Parent: IWindow);
var
 Plug : TBasePlugIn;
begin
 Plug:=TBasePlugIn(Process);
 if not assigned(Plug) then exit;
 if not (plug is TPerlPrPlugIn) then exit;
 if handle<99
  then handle:=FindWindow(nil,pchar(inttostr(handle)))
  else handle:=GetParent(handle);
 TPerlPrPlugIn(Plug).ole.dockWindow(handle,TWindow(Parent.self).Panel.Handle);
end;

procedure TApplication.DestroyWindow(Process: Integer;
  const Window: IWindow);
var
 Plug : TBasePlugIn;
 form : TOptiForm;
 i:integer;
begin
 Plug:=TBasePlugIn(Process);
 if not assigned(Plug) then exit;
 Form:=TWindow(Window.self).Form;
 with optiMainForm do
 for i:=0 to high(plugWindows)-1 do
  if PlugWindows[i].Tag=Integer(form) then
  begin
   PlugWindows[i].Tag:=0;
   Break;
  end;
 Form.Free;
end;

function TApplication.GetWindowHandle(const Window: IWindow): Integer;
var
 aq : TaqCustomDockingControl;
begin
 result:=0;
 if assigned(window) then
 begin
  aq:=TWindow(Window.self).Form.DockControl;
  result:=aqDockingbase.GetDockingParentForm(aq).handle;
 end;
end;

procedure TApplication.GrabWindow(Process: Integer; Enable: WordBool; Handle: Integer);
var
 pi : TBasePlugin absolute process;
begin
 GrabbedHandle:=0;
 ModalHandle:=0;
 if Enable then
  begin
   DisableApplication;
   GrabbedHandle:=Handle;
  end
 else
  EnableApplication;

 if assigned(pi) and (pi is TPerlPrPlugIN) then
  TPerlPrPlugIN(pi).ole.Grab(enable,Handle);
end;

function TApplication.RequestWindow(Process: Integer): OleVariant;
var
 Plug : TBasePlugIn;
 i : integer;
begin
 Plug:=TBasePlugIn(Process);
 if not assigned(Plug) then exit;
 i:=0;
 with OptiMainForm do
 begin
  while (i<length(PlugWIndows)) and (PlugWIndows[i].Tag<>0) do
   inc(i);
  if i=length(PlugWIndows) then
  begin
   result:=Unassigned;
   exit;
  end;

  PlugWIndows[i].tag:=Integer(TPlugInForm.CreateNamed(application,'PlugIn_'+inttostr(i)));
  result:=GetWindow(TPlugInForm(PlugWIndows[i].tag));
 end;
end;

/// DESTRUCTORS AND GETTERS

destructor TApplication.Destroy;
begin
 App:=nil;
 inherited;
end;

///////////////////////////////////////////////////////////////////////
/////// EVENTS
///////////////////////////////////////////////////////////////////////

Type
 TLaunchEvent = Procedure(AppEvents : IApplicationEvents; Const Data : Array of Const);

Procedure DoEvent(LaunchEvent : TLaunchEvent; Const Data : Array of Const);
var
   cp : IConnectionPoint;
   Enum : IEnumConnections;
   Fetched : Longint;
   ConnectData : TConnectData;
begin
 if not assigned(App) or not assigned(App.FConnectionPoint) then exit;

 try
  {Get the IConnectionPoint}
  cp := App.FConnectionPoint as IConnectionPoint;

  {Get the Enum interface}
  if (not SUCCEEDED(cp.EnumConnections(Enum))) then
  begin
    cp := nil;
    Exit;
  end;

  {For every connected client do}
  while(Enum.Next(1, ConnectData, @Fetched) = S_OK) do
  begin
   {Get the IConnectServerEvents interface and fire the event}
   LaunchEvent(ConnectData.pUnk as IApplicationEvents, Data);
   {Done}
   ConnectData.pUnk := nil;
  end;
 except on exception do
 end;
end;

function TApplication.Get_Handle: Integer;
begin
 result:=Application.Handle;
end;

function TApplication.GetOpt(const Name: WideString): OleVariant;
begin
 result:=GetProperty(options,name);
end;

procedure TApplication.SetOpt(const Name: WideString; Value: OleVariant);
begin
 SetProperty(options,name,value);
end;

function TApplication.GetColor(const Name: WideString): WideString;
var
 i:integer;
begin
 i:=GetProperty(options,name);
 result:=ColorToHTML(i);
end;

procedure TApplication.SetColor(const Name, Value: WideString);
var
 i:integer;
begin
 i:=HTMLToColor(value);
 SetProperty(options,name,i);
end;


procedure TApplication.UpdateOptions(Everything: WordBool);
var i:integer;
begin
 if everything
  then i:=HKO_LiteVisible
  else i:=HKO_Lite;
 PC_OptionsUpdated(i);
end;

procedure TApplication.StatusBarRestore;
begin
 EditorForm.StatusBar.SimplePanel:=false;
 EditorForm.IsSimpleBar:=false;
end;

procedure TApplication.StatusBarText(const Text: WideString);
begin
 EditorForm.StatusBar.SimplePanel:=true;
 EditorForm.StatusBar.SimpleText:=text;
 EditorForm.IsSimpleBar:=true;
end;

procedure TApplication.ExecuteAction(const Action: WideString);
var
 i,j : Integer;
 ac : TCustomAction;
begin
 with itemmod do
  for i:=0 to high(ActionArray) do
   for j:=0 to ActionArray[i].actioncount-1 do
   begin
    ac:=TAction(ActionArray[i].Actions[j]);
    if ansicomparetext(ac.name,action)=0 then
    begin
     if ac is THKAction
      then THKAction(Ac).SimpleExecute
      else ac.Execute;
    end;
   end;
end;

function TApplication.Get_FocusedControl: OleVariant;
begin
 result:=GetControl(screen.ActiveControl,nil);
end;

procedure TApplication.Set_FocusedControl(Value: OleVariant);
var
 form : TCustomForm;
 ctr : TWinControl;
begin
 ctr:=TWinControl(integer(Value.self));
 if ctr=nil then exit;
 form:=ValidParentForm(ctr);
 if form is TOptiForm then
  TOptiForm(Form).Show;
end;

function TApplication.Get_EditorControl: OleVariant;
begin
 result:=GetControl(EditorForm.memEditor,nil);
end;

function TApplication.Get_Self: Integer;
begin
 result:=Integer(self);
end;

function TApplication.OpenDocument(const Filename: WideString): OleVariant;
begin
 if fileexists(Filename) then
 begin
  if EditorForm.MFH.OpenFile(Filename) then
   result:=GetDocument(ActiveScriptInfo);
 end;
end;

function TApplication.NewDocument(const Filename: WideString): OleVariant;
begin
 with editorForm do
 begin
  NewFilename:=Filename;
  NewTemplate:='';
  MFH.New;
  activescriptinfo.ms.Clear;
  result:=GetDocument(ActiveScriptInfo);
 end;
end;

procedure TApplication.CloseDocument;
begin
 ActiveScriptInfo.IsModified:=false;
 EditorForm.CloseAction.simpleexecute;
end;

procedure TApplication.CloseDocumentIndex(Index: Integer);
begin
 EditorForm.MFH.closebyindex(index);
end;

procedure TApplication.QuickSave;
begin
 PR_QuickSave;
end;

function TApplication.Get_ToolBarLinks(Process: Integer): OleVariant;
begin
 result:=GetToolLinks(TDxBar(TBasePlugIn(Process).maintoolbar).ItemLinks);
end;

procedure TApplication.ToolBarVisible(Process: Integer; Visible: WordBool);
var
 pi : TBasePlugin absolute process;
begin
 if not assigned(pi) then exit;
 if visible then
  TdxBar(pi.maintoolbar).Row:=16;
 TdxBar(pi.maintoolbar).Visible:=visible;
end;

procedure TApplication.UpdateToolBars(Process: Integer);
var
 pi : TBasePlugin absolute process;
begin
 if not assigned(pi) then exit;
 with TdxBar(pi.maintoolbar) do
  if visible then
  begin
   ProcessPaintMessages;
   visible:=false;
   ProcessPaintMessages;
   visible:=true;
   ProcessPaintMessages;
  end;
end;

function TApplication.CreateToolItem(Process: Integer;
  const ClassName: WideString): OleVariant;
var
 Item : TdxBarItem;
 s:string;
 form : TCustomForm;
begin
 Form:=Application.MainForm;
 s:=Lowercase(classname);
 if s='button' then
  Item:=TdxBarButton.create(Form)
 else
 if s='menu' then
  item:=tdxBarSubItem.Create(form)
 else
  exit;
 Item.Data:=TEvents.Create(Item,TBasePlugIn(process));
 result:=gettoolitem(item);
end;

procedure TApplication.ProcessMessages;
begin
 Forms.Application.ProcessMessages;
end;

function TApplication.MessageBox(const Caption, Prompt: WideString;
  Flags: Integer): Integer;
var
 c,p : String;
begin
 Forms.Application.ProcessMessages;
 c:=Caption; p:=Prompt;
 result:=Forms.Application.MessageBox(Pchar(P),Pchar(C),Flags);
end;

function TApplication.InputBox(const Caption, Prompt,
  Default: WideString): WideString;
var
 s:string;
begin
 Forms.Application.ProcessMessages;
 s:=Default;
 if inputQuery(Caption,Prompt,s)
  then result:=s
  else result:='';
end;

initialization
 TAutoObjectFactory.Create(ComServer, TApplication, Class_Application, ciMultiInstance, tmSingle);
end.
