unit PlugMdl;
{$I REG.INC}

{$IFNDEF OLE}
Invalid !!
{$ENDIF}

interface

uses
  Windows,messages,SysUtils, Classes, aqDockingBase, aqDocking, ExtCtrls, CentralImageListMdl,
  ActnList, dxBar,HakaFile, HKDebug,OptFolders, HKActions, HakaHyper, Hakageneral,HyperStr,
  DIPcre,optOptions,OptProcs,hakawin,forms,PerlAPI,OptForm, AppEvnts,hyperfrm,dialogs,
  PlugBase,PlugTypes,PlugCommon;

type

  TPlugAction = Class(THKAction)
  Private
   Fbtn : TdxBarButton;
   FFilename,FPlugName,FIcon,FButton : String;
   FNewProcess : Boolean;
   FStartup : Boolean;
   Procedure OnPlugDestroyed(sender : TObject);
   procedure UpdateData;
   procedure ActionExecute(Sender: TObject);
   Function GetPlugInData : Boolean;
   procedure OnWorkingToggle(Sender: TObject; Status: TPlugStatus);
  public
   ValidLoad : Boolean;
   PlugIn : TBasePlugIn;
   constructor Create(Const Filename : String); reintroduce;
   Destructor Destroy; Override;
  end;

  TPlugMod = class(TDataModule)
   ActionList: TActionList;
   UpdatePluginAction: THKAction;
   procedure UpdatePluginActionExecute(Sender: TObject);
   procedure DataModuleCreate(Sender: TObject);
   procedure DataModuleDestroy(Sender: TObject);
  public
   procedure UpdateItemLinks;
   Procedure UpdateTools;
   Procedure StartupPlugins;
  public
   Procedure TerminateAll;
   procedure OnParseEnd;
   procedure OnParseStart;
   procedure OnActiveDocumentChange;
   Procedure OnDocumentClose(const Path : String);
   Function OnDocumentOpen(Const Action : String) : Boolean;
   Function OnBeforeAction(Const Action : String) : Boolean;
   Procedure OnAfterAction(Const Action : String);
   Function OnKeyEvent(WParam, LParam : Cardinal) : Boolean;
   Function OnCanTerminate : Boolean;
 end;

var
  PlugMod: TPlugMod;
  PlugCat : Integer;
  PlugInMenu : TdxBarSubItem;
  PlugInButton : TdxBarButton;
  MainBarMan : TDxBarManager;

implementation
{$R *.dfm}
var
 KeyboardHookHandle: HHOOK;
const
 piprefix = 'pi_';

function KeyboardHook(Code: Integer; wParam: WParam; lParam: LParam): LRESULT; stdcall;
begin
 if PlugMod.OnKeyEvent(WParam,LParam)
 then
  Result := CallNextHookEx(KeyboardHookHandle, Code, wParam, lParam)
 else
  result:=1;
end;

procedure TPlugAction.OnPlugDestroyed(sender: TObject);
begin
 PlugIn:=nil;
end;

Procedure TPlugAction.OnWorkingToggle(Sender : TObject; Status : TPlugStatus);
const
 BChecked : array[TPlugStatus] of boolean = (true,true,true,false);
 BEnabled : array[TPlugStatus] of boolean = (false,true,false,true);
//(psLoading,psRunning,psTerminating,psTerminated);
begin
 enabled:=BEnabled[status];
 checked:=BChecked[status];
 FBtn.Down:=checked;
 FBtn.Enabled:=Enabled;
end;

procedure TPlugAction.ActionExecute(Sender: TObject);
var
 ext : String;
 tb : TdxBar;
begin
 hakawin.StartNonAnimatedWindows;
 try
  if not assigned(PlugIn) then
   begin
    tb:=MainBarMan.Bars.Add;
    tb.Name:=inttostr(integer(plugin));
    tb.Caption:=FPlugName;
    tb.DockingStyle:=dsTop;
    tb.DockedDockingStyle:=dsTop;

    try
     Ext:=UpFileExt(FFIlename);
     if (ext='CGI') or (ext='PL') then
      begin
       If FNewProcess
        then Plugin:=TPerlPRPlugIn.Create(FFilename,OnWorkingToggle,tb)
        else Plugin:=TPerlEmbPlugIn.Create(FFilename,OnWorkingToggle,tb);
      end
     else
     if (ext='OPP') then
      Plugin:=TDllPlugIn.Create(FFilename,OnWorkingToggle,tb);
     if assigned(PlugIn) then
      PlugIn.OnDestroyed:=OnPlugDestroyed;
    except
     PlugIn:=nil;
     raise;
    end;
   end

  else
   begin
    PostMessage(Application.mainform.handle,HK_P_Terminate,Integer(PlugIn),0);
   end;

 finally
  hakawin.EndNonAnimatedWindows;
 end;
end;

procedure TPlugAction.UpdateData;
begin
 Caption:=FPlugName;
 if not assigned(fbtn) then exit;

 Fbtn.Description:=Hint;
 if Ficon<>'' then
   centralimagelistmod.GetGlyph(FFilename,Ficon,Fbtn.Glyph);
 with PlugInMenu.ItemLinks.Add do
  item:=Fbtn;
 if length(FButton)>0 then
  pr_AddButtonLinkFromString(FButton,FBtn);
end;

constructor TPlugAction.Create(const Filename: String);
var
 i:integer;
 TName,TBName : String;
 TempAct : TPlugAction;
begin
 inherited create(PlugMod);

 KillAllExenames('OptiClient.exe');
 KillAllExenames('OptiCl~1.exe');

 ValidLoad:=false;
 FFilename:=Filename;

 if not FIleExists(FFilename)
  then exit;

 if not GetPlugInData then exit;

 Tname:=piprefix+SafeComponentName(ExtractFilename(FFilename));
 TBName:='b'+TName;

  for i:=0 to plugmod.ActionList.ActionCount-1 do
  if plugmod.actionlist.Actions[i] is TPlugAction then
  begin
   TempAct:=TPlugAction(plugmod.actionlist.Actions[i]);
   if TempAct.Name=TName then
   begin
    if TempAct.GetPlugInData
     then tempAct.UpdateData
     else tempact.Free;
    Exit;
   end;
  end;

 ValidLoad:=true;

 Category:='Plug-Ins';
 name:=TName;
 ActionList:=PlugMod.ActionList;
 OnExecute:=ActionExecute;
 ImageIndex:=DefToolIcon;

 Fbtn:=TdxBarButton.Create(Application.mainform);
 Fbtn.Caption:=FPlugName;
 Fbtn.name:=TBName;
 Fbtn.Category:=plugcat;
 Fbtn.ButtonStyle:=bsChecked;
 Fbtn.Action:=self;
 UpdateData;
end;

destructor TPlugAction.Destroy;
begin
 if assigned(FBtn) then
  FBtn.Free;
 inherited;
end;


Function TPlugAction.GetPlugInData : Boolean;
var
 desc : String;
 Ext : String;
begin
 result:=PlugTypes.GetPlugInData(FFilename,FPlugName,Desc,FIcon,FButton,Ext);
 if result then
 begin
  hint:=desc;
  FNewProcess:=ScanF(Ext,'newprocess',-1)>0;
  FStartup:=ScanF(Ext,'startup',-1)>0;
 end;
end;

////////////  PLUG MOD

procedure TPlugMod.StartupPlugins;
var i:integer;
begin
 for i:=ActionList.ActionCount-1 downto 0 do
  if actionlist.Actions[i] is TPlugAction then
   with TPlugAction(ActionList.Actions[i]) do
    if FStartup then
    begin
     Execute;
     Application.ProcessMessages;
    end;
end;

procedure TPlugMod.TerminateAll;
var i:integer;
begin
 for i:=running.Count-1 downto 0 do
  with TBasePlugIn(Running[i]) do
   PostMessage(Application.mainform.handle,HK_P_Terminate,Integer(Running[i]),0);
 while Running.Count>0 do
  application.HandleMessage;
end;

procedure TPlugMod.UpdateItemLinks;
var
 i:integer;
begin
 while PlugInMenu.ItemLinks.Count>0 do
  PlugInMenu.ItemLinks.Delete(0);

 for i:=0 to ActionList.ActionCount-1 do
  if actionlist.Actions[i] is TPlugAction then
   with TPlugAction(ActionList.Actions[i]) do
   begin
    with PlugInMenu.ItemLinks.add do
     item:=fBtn;
    if length(FButton)>0 then
     pr_AddButtonLinkFromString(FButton,FBtn);
   end;
 with PlugInMenu.ItemLinks.add do
 begin
  item:=PlugInButton;
  BeginGroup:=true;
 end;
end;

procedure TPlugMod.UpdateTools;
var
 sl : TStringList;
 i:integer;
 Action : TPlugAction;
begin
 if not directoryexists(folders.PluginFolder) then exit;
 sl:=TStringList.Create;
 sl.Sorted:=true;
 sl.CaseSensitive:=false;
 try
  //remote itemlinks
  while PlugInMenu.ItemLinks.Count>0 do
   PlugInMenu.ItemLinks.Delete(0);

  GetFileList(folders.PluginFolder,'*.*',false,faArchive,sl);

  for i:=sl.Count-1 downto 0 do
  begin
   Action:=TPlugAction.Create(folders.PluginFolder+sl[i]);
   if not action.ValidLoad then
    Action.Free;
  end;

  for i:=ActionList.ActionCount-1 downto 0 do
  if actionlist.Actions[i] is TPlugAction then
   with TPlugAction(ActionList.Actions[i]) do
    if sl.IndexOf(extractfilename(FFilename))<0 then
     free;

  with PlugInMenu.ItemLinks.add do
  begin
   item:=PlugInButton;
   BeginGroup:=true;
  end;

 finally
  sl.free;
 end;
end;

procedure TPlugMod.UpdatePluginActionExecute(Sender: TObject);
begin
 UpdateTools;
end;

procedure TPlugMod.DataModuleCreate(Sender: TObject);
begin
 PlugMod.UpdateTools;
 KeyboardHookHandle :=
   SetWindowsHookEx(WH_KEYBOARD, KeyboardHook, 0, GetCurrentThreadId);
end;

procedure TPlugMod.DataModuleDestroy(Sender: TObject);
begin
 if KeyboardHookHandle <> 0 then
  UnhookWindowsHookEx(KeyboardHookHandle);
end;

procedure TPlugMod.OnActiveDocumentChange;
var
 i:integer;
begin
 for i:=0 to running.Count-1  do
  with TBasePlugIn(Running[i]) do
   OnActiveDocumentChange;
end;

procedure TPlugMod.OnParseEnd;
var
 i:integer;
begin
 for i:=0 to running.Count-1  do
  with TBasePlugIn(Running[i]) do
   OnParseEnd;
end;

procedure TPlugMod.OnDocumentClose(const Path : String);
var
 i:integer;
begin
 for i:=0 to running.Count-1 do
  with TBasePlugIn(Running[i]) do
   OnDocumentClose(Path);
end;

procedure TPlugMod.OnParseStart;
var
 i:integer;
begin
 for i:=0 to running.Count-1 do
  with TBasePlugIn(Running[i]) do
   OnParseStart;
end;

procedure TPlugMod.OnAfterAction(const Action: String);
var
 i:integer;
begin
 for i:=0 to running.Count-1 do
  with TBasePlugIn(Running[i]) do
   OnAfterAction(Action);
end;

function TPlugMod.OnDocumentOpen(const Action: String): Boolean;
var
 i:integer;
begin
 result:=true;
 for i:=0 to running.Count-1 do
  with TBasePlugIn(Running[i]) do
   if result
    then result:=OnDocumentOpen(Action)
    else break;
end;

Function TPlugMod.OnBeforeAction(const Action: String) : Boolean;
var
 i:integer;
begin
 result:=true;
 for i:=0 to running.Count-1 do
  with TBasePlugIn(Running[i]) do
   if result
    then result:=OnBeforeAction(Action)
    else break;
end;

function TPlugMod.OnCanTerminate: Boolean;
var
 i:integer;
begin
 result:=true;
 if options.RunTest then exit;
 for i:=0 to running.Count-1 do
  with TBasePlugIn(Running[i]) do
   if result
    then result:=OnCanTerminate
    else break;
end;
       
function TPlugMod.OnKeyEvent(WParam, LParam: Cardinal): Boolean;
var
 i:integer;
begin
 result:=true;
 for i:=0 to running.Count-1 do
  if TBasePlugIn(Running[i]).HasOnKeyEvent then
   with TBasePlugIn(Running[i]) do
    if result
     then result:=OnKeyEvent(WParam,LParam)
     else break;
end;


end.
