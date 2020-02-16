unit SysFloatMenu;

interface

uses
  Windows, Messages, SysUtils, Classes,forms, dialogs,controls;

type
  TSysFloatMenu = class(TComponent)
  private
   MenuHandle : THandle;
   Form : TForm;
   OrgFormStyle : TFormStyle;
   procedure AppendToSystemMenu(Item: string; ItemID: word);
   Function SetCheck(ItemID : Word; Checked : Boolean) : Boolean;
    procedure SetChecks;
  protected
   Procedure WMSysCommand(var msg : TWMSysCommand); message WM_SYSCOMMAND;
  public
    Constructor Create(AOwner : TComponent); override;
    Destructor Destroy; Override;
  published
    { Published declarations }
  end;

procedure Register;

implementation
const
 DockItem = 99;
 StayTopItem = 100;


Procedure TSysFloatMenu.AppendToSystemMenu (Item: string; ItemID: word);
var
   NormalSysMenu, MinimizedMenu: HMenu;
   AItem: array[0..255] of Char;
   PItem: PChar;
begin
//   NormalSysMenu := GetSystemMenu(Form.Handle, false);
//   MinimizedMenu := GetSystemMenu(Application.Handle, false);
   if Item = '-' then
   begin
     AppendMenu(MenuHandle, MF_SEPARATOR, 0, nil);
   end
   else
   begin
     PItem := StrPCopy(@AItem, Item);
     AppendMenu(MenuHandle, MF_STRING, ItemID, PItem);
   end
end; {AppendToSystemMenu}

procedure Register;
begin
  RegisterComponents('haka', [TSysFloatMenu]);
end;

constructor TSysFloatMenu.Create(AOwner: TComponent);
begin
 Inherited Create(aowner);
 if ComponentState=[] then
 begin
  Form:=TForm(Owner);
  OrgFormStyle:=form.FormStyle;
  MenuHandle:=GetSystemMenu(Form.Handle,false);
  AppendToSystemMenu('-',0);
  AppendToSystemMenu('Stay on top',StayTopItem);
  AppendToSystemMenu('Dockable',DockItem);
  SetChecks;
 end;
end;

destructor TSysFloatMenu.Destroy;
begin
 inherited;
end;

procedure TSysFloatMenu.SetChecks;
begin
 SetCheck(StayTopItem,form.FormStyle=fsStayOnTop);
 SetCheck(DockItem,form.DragKind=dkDock);
end;

function TSysFloatMenu.SetCheck(ItemID: Word; Checked: Boolean): Boolean;
var c:cardinal;
begin
 if checked
  then c:=MF_CHECKED or MF_BYCOMMAND
  else c:=MF_UNCHECKED or MF_BYCOMMAND;
 result:=CheckMenuItem(MenuHandle,itemID,c)=MF_CHECKED;
end;

procedure TSysFloatMenu.WMSysCommand(var msg: TWMSysCommand);
begin
 showmessage('d');
 inherited;
 case msg.CmdType of
  DockItem :
   begin
    if Form.DragKind=dkDrag then
     begin
      Form.DragKind:=dkDock;
      form.DragMode:=dmAutomatic;
     end
    else
     begin
      Form.DragKind:=dkDrag;
      form.DragMode:=dmManual;
     end;
    setchecks;
   end;
  StayTopItem :
   begin
    if form.FormStyle=fsStayOnTop
     then Form.FormStyle:=OrgFormStyle
     else form.FormStyle:=fsStayOnTop;
    setchecks;
   end;

 end; //case
end;

end.
