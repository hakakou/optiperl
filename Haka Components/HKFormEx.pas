unit HKFormEx;
{
 * The NC menu items are only shown if the form is not modal
 * Called:
 1) OnShow
 2) OnFirstShow
 3) OnActivate
 4) OnFirstAfterShow
}


interface

uses
  Windows, Classes, Forms, Controls, messages, sysutils, Graphics, inifiles,
  hakawin;

type
  TNCMenuItems = (ncDockable,ncStayOnTop,ncTaskBarWindow);
  TNCMenuItemSet = Set of TNCMenuItems;

  TFormEx = class(TForm)
  private
   FNCMenuSet : TNCMenuItemSet;
   FTaskBar : Boolean;
   FAfterShow : TNotifyEvent;
   FFirstShow : TNotifyEvent;
   procedure InsertToSysMenu(Item: string; AfterID, ItemID: word);
   Function SetCheck(ItemID : Word; Checked : Boolean) : Boolean;
   procedure SetChecks;
   Procedure WMSysCommand(var msg : TWMSysCommand); message WM_SYSCOMMAND;
   Procedure WMCreate(var msg : TWMCreate); message WM_CREATE;
   Procedure WMActivate(var msg : TWMActivate); message WM_Activate;
   Procedure WMShowWindow(var msg : TWMShowWindow); message WM_ShowWindow;
   procedure RecreateMenus;
   Procedure SetMenus(Menus : TNCMenuItemSet);
   procedure SetTaskBarWindow(Value : Boolean);
  protected
   Procedure CreateParams(var Params: TCreateParams); override;
  private
   MenuHandle : THandle;
   FFormShown : Boolean;
   FDoRecreateMenu : Boolean;
  public
   constructor Create(AOwner: TComponent); override;
   Destructor Destroy; Override;
  Published
   Property NCMenuItems : TNCMenuItemSet read FNCMenuSet write SetMenus;
   Property TaskBarWindow : Boolean read FTaskBar write SetTaskBarWindow;
   Property OnFirstAfterShow : TNotifyEvent read FAfterShow write FAfterShow;
   Property OnFirstShow : TNotifyEvent read FFirstShow write FFirstShow;
  end;

Var
 IniFileName : String = '';
 TaskWindowsOpen : Integer = 0;
 OnTaskWindowsModified : TNotifyEvent = nil;

implementation

const
 BoolStr : array[boolean] of char = ('0','1');
 WinSectionStr = 'WindowStates';
 DockItem = 99;
 StayTopItem = 100;
// TaskBarItem = 101;
 SepItem = 102;

Procedure TFormEx.InsertToSysMenu(Item: string; AfterID,ItemID: word);
var
 mi:MENUITEMINFO;
begin
 fillchar(mi,sizeof(mi),0);
 mi.cbSize:=sizeof(mi);
 mi.fMask:=MIIM_DATA or MIIM_ID or MIIM_TYPE;
 mi.wID:=itemID;
 if item<>'-' then
  begin
   mi.fType:=MFT_STRING;
   mi.dwTypeData:=pchar(item);
   mi.cch:=length(item);
  end
 else
  begin
   mi.fType:=MFT_SEPARATOR;
  end;
 InsertMenuItem(menuhandle,AfterID,false,mi);
end;

procedure TFormEx.RecreateMenus;
var
 l : Integer;
begin
 if (menuhandle>0) and (not (fsModal in formstate)) then
 begin
  l:=0;
  if (FNCMenuSet=[]) then
   DeleteMenu(MenuHandle,SepItem,MF_BYCOMMAND)
  else
   begin
    InsertToSysMenu('-',SC_Close,SepItem);
    l:=SepItem;
   end;

  if ncStayOnTop in FNCMenuSet then
   begin
    InsertToSysMenu('Stay on top',l,StayTopItem);
    l:=StayTopItem;
   end
  else
   DeleteMenu(MenuHandle,StayTopItem,MF_BYCOMMAND);

  if ncDockable in FNCMenuSet then
   begin
    InsertToSysMenu('Dockable',l,DockItem);
    l:=DockItem;
   end
  else
   DeleteMenu(MenuHandle,DockItem,MF_BYCOMMAND);
{
  if ncTaskBarWindow in FNCMenuSet then
   begin
    InsertToSysMenu('Task bar window',l,TaskBarItem);
   end
  else
   DeleteMenu(MenuHandle,TaskBarItem,MF_BYCOMMAND);
}
 end;
 FDoRecreateMenu:=false;
 SetChecks;
end;

procedure TFormEx.WMCreate(var msg: TWMCreate);
begin
 inherited;
 MenuHandle:=GetSystemMenu(Handle,false);
 FDoRecreateMenu:=true;
end;

procedure TFormEx.SetChecks;
begin
 SetCheck(StayTopItem,FormStyle=fsStayOnTop);
 SetCheck(DockItem,DragKind=dkDock);
// SetCheck(TaskBarItem,TaskBarWindow);
end;

function TFormEx.SetCheck(ItemID: Word; Checked: Boolean): Boolean;
var c:cardinal;
begin
 if checked
  then c:=MF_CHECKED or MF_BYCOMMAND
  else c:=MF_UNCHECKED or MF_BYCOMMAND;
 result:=CheckMenuItem(MenuHandle,itemID,c)=MF_CHECKED;
end;

procedure TFormEx.WMSysCommand(var msg: TWMSysCommand);
begin
 case msg.CmdType of
  DockItem :
   begin
    if DragKind=dkDrag then
     begin
      DragKind:=dkDock;
      DragMode:=dmAutomatic;
     end
    else
     begin
      DragKind:=dkDrag;
      DragMode:=dmManual;
     end;
    setchecks;
   end;

  StayTopItem :
   begin
    if FormStyle<>fsStayOnTop
     then FormStyle:=fsStayOnTop
     Else FormStyle:=fsNormal;
    setchecks;
   end;

{
  TaskBarItem :
   begin
    TaskBarWindow:=not TaskBarWindow;
    SetChecks;
   end;
}
  else
   inherited;
 end;
end;

procedure TFormEx.WMActivate(var msg: TWMActivate);
begin
 inherited;
 if (msg.Active=WA_ACTIVE) and (not (csDesigning in ComponentState)) then
 begin
  SetChecks;
  if (Not FFormShown) then
  begin
   FFormShown:=true;
   if assigned(FAfterShow) then
    FAfterShow(self);
  end;
 end;
end;

procedure TFormEx.SetMenus(Menus: TNCMenuItemSet);
begin
 FNCMenuSet:=Menus;
 if (not (csDesigning in ComponentState)) then
  RecreateMenus;
end;

procedure TFormEx.WMShowWindow(var msg: TWMShowWindow);
begin
 inherited;
 if (msg.Show) and (not (csDesigning in ComponentState)) then
 begin
  if FDoRecreateMenu then
   RecreateMenus;
  if (not FFormShown) and (assigned(FFirstShow)) then
   FFirstShow(self);
 end;
end;

procedure TFormEx.CreateParams(var Params: TCreateParams);
begin
 inherited;
{
 if (FTaskBar) and (not (csDesigning in ComponentState)) then
  Params.ExStyle:=Params.ExStyle+WS_EX_APPWINDOW;
}  
end;

procedure TFormEx.SetTaskBarWindow(Value: Boolean);
begin
 FTaskBar := Value;
{
 if FTaskBar <> Value then
 begin
  if not (csDesigning in ComponentState) then DestroyHandle;
  FTaskBar := Value;
  if FTaskBar
   then inc(TaskWindowsOpen)
   else dec(TaskWindowsOpen);
  if assigned(OnTaskWindowsModified) then
   OnTaskWindowsModified(self);
  if not (csDesigning in ComponentState) then UpdateControlState;
 end;
 }
end;

constructor TFormEx.Create(AOwner: TComponent);
var
 inifile : Tinifile;
 s:string;
begin
 inherited;
 if (inifilename='') or (csDesigning in ComponentState) then exit;
 IniFile:=TIniFile.Create(inifilename);
 try
  s:=inifile.ReadString(WinSectionStr,name,'');
  if length(s)=3 then
  begin
   if s[1]='1'
    then FormStyle:=fsStayOnTop
    Else FormStyle:=fsNormal;

   if s[2]='1' then
    begin
     DragKind:=dkDock;
     DragMode:=dmAutomatic;
    end
   else
    begin
     DragKind:=dkDrag;
     DragMode:=dmManual;
    end;

   if s[3]='1'
    then TaskBarWindow:=true
    Else TaskBarWindow:=false;
  end;
 finally
  inifile.free;
 end;
end;

destructor TFormEx.Destroy;
var
 inifile : Tinifile;
begin
 if (inifilename='') or (csDesigning in ComponentState) then
 begin
  inherited;
  exit;
 end;

 IniFile:=TIniFile.Create(inifilename);
 try
  inifile.WriteString(WinSectionStr,name,
   boolstr[FormStyle=fsStayOnTop]+
   boolstr[DragKind=dkDock]+
   boolstr[TaskBarWindow]);
 finally
  inifile.free;
  inherited;
 end;
end;

end.
