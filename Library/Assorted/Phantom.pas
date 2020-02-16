{

  TPhantom 7.0

  programming by Roland Gruber (delphi@rolandgruber.de)
                               (http://www.rolandgruber.de)

  You can use this component in commercial and noncommercial
  programms as long as you mention the author(i.g. in an infobox).

  The use of this component is at your own risk.
  I do not take any responsibility for any damages.

  If you improve this component I would be happy if you
  sent me a copy of the source code and if you have
  suggestions how to improve the component just send
  me an e-mail.
  (delphi@rolandgruber.de)

  PAY ATTENTION!!! This component does not work with Win NT!

  How to use this component:

  Visible: defines if your form is visible or not
           Set this property at run-time (for example at Form.OnActivate)
  Serviceprocess: hides the program from the taskmanager(CTRL+ALT+DEL)
  Iconfile: filename of the .ico-file for the taskbar icon
  Iconvisibility: defines if the taskbar icon is visible
  Popupright: name of the popup window that appears when
               the user right clicks on the taskbar icon
  Popupleft:  the same as above on left click
  Leftclick:  what happens if the user left clicks on
               the taskbar icon
  Rightclick: same as above on a right click
  Doubleclick: same as above on a double click
  Tip: Text that is shown when cursor is over taskbar icon
  Flash: flashes the button in the taskbar
         (!!! returns to false immediately after being set to true (after one flashing)!!!)
  FlashTime: time(ms) of flashing
  Priority: Priority of the application
  MousePosX: Position of cursor on x-axis
  MousePosY: Position of cursor on y-axis
  MouseRightClick: simulates click of the right mouse button
  MouseLeftClick: simulates click of the left mouse button
  MouseMiddleClick: simulates click of the middle mouse button
  SendString: simulates the input of a string by keyboard
              ( supported characters: ABCDEFGHIJKLMNOPQRSTUVWXYZ
                                      abcdefghijklmnopqrstuvwxyz
                                      1234567890!"§$%&/()=
                                      ,.-;:_ +* )
  LockInput: this locks the mouse and keyboard: if set to liNormal the user is able to unlock
             both by pressing Ctrl+Alt+Del, if set to liHard he has no chance
  }
 unit Phantom;

interface

uses
  Windows, wintypes, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  menus, shellapi, extctrls;

  const
  TASKBAREVENT: PChar = 'NewTNIMessage_20';

type

  TPriority = (Idle, Normal, Hoch, Realtime);
  TLock = (liHard, liNormal, liNone);
  TPhantom = class(TComponent)
  private
    fIconDatei: Ticon;
    ftip:string  ;
    fSichtbar: Boolean ;
    fServiceprocess: Boolean ;
    fLinksKlick: TNotifyEvent;
    fRechtsKlick: TNotifyEvent;
    fDoppelKlick: TNotifyEvent;
    fIconSichtbarkeit: boolean;
    fPopupRechts: TPopupMenu;
    fPopupLinks: TPopupMenu;
    fblinken:boolean;
    fblinkdauer:integer;
    fprioritaet: TPriority;
    fcursor: TPoint;
    kerneldll:THandle;
    userdll: THandle;
    fkeycode: string;
    feingabesperre:TLock;
    { Private-Deklarationen }
    procedure PWsichtbarkeit(value:boolean);
    procedure PWserviceprocess(value:boolean);
    procedure sichtbarmachen;
    procedure unsichtbarmachen;
    procedure WPopRechts;
    procedure WPopLinks;
    procedure CreateIcon;
    procedure ChangeIcon;
    procedure DeleteIcon;
    procedure settip(value:string);
    procedure Wicondatei(value:Ticon);
    procedure WIconSichtbarkeit(value:boolean);
    procedure blink(value:boolean);
    procedure prioritaetsetzen(value:TPriority);
    function  getposx:integer;
    function  getposy:integer;
    procedure setposx(value:integer);
    procedure setposy(value:integer);
    procedure setsendstring(value:string);
    procedure SetSperre(value:TLock);
  protected
    { Protected-Deklarationen }
    procedure serviceprocessEin;
    procedure serviceprocessAus;
    procedure WRechtsklick; virtual;
    procedure WLinksklick; virtual;
    procedure WDoppelklick; virtual;
    procedure WndProc(var Msg: TMessage);
    procedure Notification(Component: TComponent; Operation: TOperation); override;
  public
    { Public-Deklarationen }
      procedure loaded;override;
      destructor Destroy; override;
      constructor Create(AOwner: TComponent); override;
   published
    { Published-Deklarationen }
    procedure MouseRightClick;
    procedure MouseLeftClick;
    procedure MouseMiddleClick;
    property Visible: Boolean read fsichtbar write PWsichtbarkeit;
    property Serviceprocess: Boolean read fserviceprocess write PWserviceprocess;
    property Iconfile: Ticon read fIconDatei write Wicondatei;
    property Iconvisibility: boolean read fIconSichtbarkeit write WIconSichtbarkeit;
    property Leftclick: TNotifyEvent read fLinksKlick write flinksklick;
    property Rightclick: TNotifyEvent read fRechtsKlick write fRechtsklick;
    property Doublelick: TNotifyEvent read fDoppelKlick write fDoppelklick;
    property PopupRight: TPopupMenu read fPopupRechts write fPopuprechts;
    property PopupLeft: TPopupMenu read fPopupLinks write fPopuplinks;
    property Tip: string read FTip write SetTip;
    property Flash: boolean read fblinken write blink;
    property FlashTime: integer read fblinkdauer write fblinkdauer;
    property Priority: TPriority  read fprioritaet write prioritaetsetzen;
    property MousePosX: integer read getposx write setposx;
    property MousePosY: integer read getposy write setposy;
    property SendString: string read fkeycode write setsendstring;
    property LockInput: TLock read feingabesperre write SetSperre;
  end;

procedure Register;

implementation

var ficonmessage: UINT;
    FWnd: HWnd;

constructor tphantom.Create(AOwner: TComponent) ;
begin
inherited Create(AOwner);
ficonmessage := RegisterWindowMessage(TASKBAREVENT);
FWnd := AllocateHWnd(WndProc);
FIcondatei := TIcon.Create;
iconvisibility:=false ;
visible:=true;
serviceprocess:=false;
fblinken:=false;
fblinkdauer:=300;
priority:=normal;
kerneldll:=LoadLibrary('kernel32.dll');
userdll:=Loadlibrary('user32.dll');
LockInput:=liNone;
end;

destructor TPhantom.Destroy;
begin
  if Ficonsichtbarkeit then deleteIcon;
  FIcondatei.Free;
  DeallocateHWnd(FWnd);
  FreeLibrary(kerneldll);
  Freelibrary(userdll);
  inherited destroy;
end;

procedure TPhantom.WndProc(var Msg: TMessage);
begin
  with Msg do begin
    if Msg = ficonmessage then
      case LParamLo of
        WM_LBUTTONDOWN:   WLinksKlick;
        WM_RBUTTONDOWN:   WRechtsKlick;
        WM_LBUTTONDBLCLK: WDoppelKlick;
      end
    else
      Result := DefWindowProc(FWnd, Msg, wParam, lParam);
  end;
end;

procedure TPhantom.Notification(Component: TComponent; Operation: TOperation);
begin
  inherited Notification(Component, Operation);
  if Operation = opRemove then begin
    if Component = FPopuprechts then FPopuprechts := nil;
    if Component = FPopuplinks then FPopuplinks := nil;
  end;
end;

procedure TPhantom.PWsichtbarkeit(value:boolean);
begin
fsichtbar:=value;
if (csDesigning in ComponentState) then exit;
if visible=true then sichtbarmachen;
if visible=false then unsichtbarmachen;
end;

procedure TPhantom.PWserviceprocess(value:boolean);
begin
fserviceprocess:=value;
if serviceprocess then serviceprocessEin;
if not serviceprocess then serviceprocessAus;
end;

procedure TPhantom.serviceprocessEin;
type Tregisterservice = function(dwProcessId,dwType:dword): Integer;stdcall;
var registerserviceprocess:Tregisterservice;
begin
  if (csDesigning in ComponentState) then exit;
  @registerserviceprocess:=GetProcAddress(kerneldll, 'RegisterServiceProcess');
  if @registerserviceprocess=nil then exit;
  RegisterServiceProcess(GetCurrentProcessID,1);
end;

procedure TPhantom.serviceprocessAus;
type Tregisterservice = function(dwProcessId,dwType:dword): Integer;stdcall;
var registerserviceprocess:Tregisterservice;
begin
  if (csDesigning in ComponentState) then exit;
  @registerserviceprocess:=GetProcAddress(kerneldll, 'RegisterServiceProcess');
  if @registerserviceprocess=nil then exit;
  RegisterServiceProcess(GetCurrentProcessID,0);
end;

procedure TPhantom.sichtbarmachen;
begin
if (csDesigning in ComponentState) then exit;
showwindow(FindWindow(nil, @Application.Title[1]),SW_RESTORE)
end;

procedure TPhantom.unsichtbarmachen;
var handle:HWND;
begin
if (csDesigning in ComponentState) then exit;
handle:=FindWindow(nil, @Application.Title[1]);
showwindow(handle,SW_MINIMIZE);
showwindow(handle,SW_HIDE) ;
end;

procedure TPhantom.WRechtsklick;
begin
if Assigned(FPopuprechts) then WPoprechts
  else if Assigned(FRechtsKlick) then
    FRechtsKlick(Self);
end;

procedure TPhantom.WLinksklick;
begin
if Assigned(FPopuplinks) then WPoplinks
  else if Assigned(FLinksKlick) then
    FLinksKlick(Self);
end;

procedure TPhantom.WDoppelklick;
begin
if Assigned(Fdoppelklick)then FDoppelKlick(Self);
end;

procedure TPhantom.WPopRechts;
var punkt:Tpoint;
begin
GetCursorPos(Punkt);
SetForeGroundWindow(FWnd);
FPopuprechts.Popup(Punkt.X, Punkt.Y);
end;

procedure TPhantom.WPopLinks;
var punkt:Tpoint;
begin
GetCursorPos(Punkt);
SetForeGroundWindow(FWnd);
FPopuplinks.Popup(Punkt.X, Punkt.Y);
end;

procedure TPhantom.CreateIcon;
var icon: TNOTIFYICONDATA;
begin
with icon do begin
    cbSize := SizeOf(TNOTIFYICONDATA);
    Wnd := FWnd;
    uID := 1;
    uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    uCallbackMessage :=ficonMessage;
    hIcon := FIcondatei.Handle;
    StrCopy(szTip, PChar(FTip));
    Shell_NotifyIcon(NIM_ADD, @icon);
  end;
ficonsichtbarkeit:=true;
end;

procedure TPhantom.ChangeIcon;
var icon: TNOTIFYICONDATA;
begin
with icon do begin
    cbSize := SizeOf(TNOTIFYICONDATA);
    Wnd := FWnd;
    uID := 1;
    uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    uCallbackMessage := ficonMessage;
    hIcon := FIcondatei.Handle;
    StrCopy(szTip, PChar(FTip));
    Shell_NotifyIcon(NIM_MODIFY, @icon);
  end;
ficonsichtbarkeit:=true;
end;

procedure TPhantom.DeleteIcon;
var icon: TNOTIFYICONDATA;
begin
with icon do begin
    cbSize := SizeOf(TNOTIFYICONDATA);
    Wnd := FWnd;
    uID := 1;
    uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    uCallbackMessage := ficonmessage;
    hIcon := FIcondatei.Handle;
    StrCopy(szTip, PChar(FTip));
    Shell_NotifyIcon(NIM_DELETE, @icon);
  end;
ficonsichtbarkeit:=false;
end;

procedure TPhantom.settip(value:string);
begin
if FTip <> value then begin
    FTip := value;
    changeicon;
  end;
end;

procedure TPhantom.Wicondatei(value:Ticon);
begin
if ficondatei<>value then begin
      ficondatei.assign(value);
      if (csDesigning in ComponentState) then exit;
      if ficonsichtbarkeit then changeicon else createicon;
      if ficondatei.empty then deleteicon;
  end;
end;

procedure TPhantom.WIconSichtbarkeit(value:boolean);
begin
ficonsichtbarkeit:=value;
if not (csDesigning in ComponentState) then begin
   if ficonsichtbarkeit then createicon;
   if not ficonsichtbarkeit then deleteicon;
   end;
end;

procedure TPhantom.Loaded;
begin
  inherited Loaded;
  if Ficonsichtbarkeit and not FIcondatei.Empty then begin
    createIcon;
  end;
end;

procedure TPhantom.blink(value:boolean);
begin
fblinken:=value;
if fblinken=false then exit;
flashwindow(application.handle,true);
sleep(fblinkdauer);
flashwindow(application.handle,true);
fblinken:=false;
end;

procedure TPhantom.prioritaetsetzen(value:TPriority);
begin
fprioritaet:=value;
if (csdesigning in componentstate) then exit;
case value of Idle : setpriorityclass(GetCurrentProcess(), IDLE_PRIORITY_CLASS);
              Normal : setpriorityclass(GetCurrentProcess(), NORMAL_PRIORITY_CLASS);
              Hoch : setpriorityclass(GetCurrentProcess(), HIGH_PRIORITY_CLASS);
              Realtime : setpriorityclass(GetCurrentProcess(), REALTIME_PRIORITY_CLASS);
   end;
end;

procedure TPhantom.MouseRightClick;
begin
mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,0);
mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,0);
end;

procedure TPhantom.MouseLeftClick;
begin
mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,0);
mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,0);
end;

procedure TPhantom.MouseMiddleClick;
begin
mouse_event(MOUSEEVENTF_MIDDLEDOWN,0,0,0,0);
mouse_event(MOUSEEVENTF_MIDDLEUP,0,0,0,0);
end;

procedure TPhantom.setposx(value:integer);
begin
getcursorpos(fcursor);
fcursor.x:=value;
setcursorpos(fcursor.x, fcursor.y);
end;

procedure TPhantom.setposy(value:integer);
begin
getcursorpos(fcursor);
fcursor.y:=value;
setcursorpos(fcursor.x, fcursor.y);
end;

function TPhantom.getposx:integer;
begin
getcursorpos(fcursor);
result:=fcursor.x;
end;

function TPhantom.getposy:integer;
begin
getcursorpos(fcursor);
result:=fcursor.y;
end;

procedure TPhantom.setsendstring(value:string);
var c:byte;
label fertig;
begin
fkeycode:=value;
if length(value)=0 then exit;
while length(value)<>0 do begin
c:=byte(value[1]);
if c>=33 then begin    
  if c<=41 then begin
  c:=(c+16);
  keybd_event(VK_SHIFT, 0, 0,0);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
  end;
 end;
if c>=48 then begin
  if c<=57 then begin
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
  end;
 end;
if c>=65 then begin
  if c<=90 then begin
  keybd_event(VK_SHIFT, 0, 0,0);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
  end;
 end;
if c>=97 then begin
  if c<=122 then begin
  c:=(c-32);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
 end;
end;
if c=58 then begin
  c:=190;
  keybd_event(VK_SHIFT, 0, 0,0);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
end;
if c=59 then begin
  c:=188;
  keybd_event(VK_SHIFT, 0, 0,0);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
end;
if c=95 then begin
  c:=189;
  keybd_event(VK_SHIFT, 0, 0,0);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
end;
if c=167 then begin
  c:=51;
  keybd_event(VK_SHIFT, 0, 0,0);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
end;
if c=61 then begin
  c:=48;
  keybd_event(VK_SHIFT, 0, 0,0);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
end;
if c=42 then begin
  c:=187;
  keybd_event(VK_SHIFT, 0, 0,0);
  keybd_event(c, 0, 0,0);
  keybd_event(c, 0, KEYEVENTF_KEYUP,0);
  keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP,0);
  goto fertig;
end;
if c=43 then c:=187;
if c=44 then c:=188;
if c=46 then c:=190;
if c=45 then c:=189;
 keybd_event(c, 0, 0,0);
 keybd_event(c, 0, KEYEVENTF_KEYUP,0);
fertig:
delete(value,1,1);
application.ProcessMessages;
end;
end;

procedure TPhantom.SetSperre(value:TLock);
type Tblockinput = function(value:boolean): Dword;stdcall;
var blockinput:Tblockinput;
    j:integer;
begin
  if (csDesigning in ComponentState) then begin
  feingabesperre:=value;
  exit;
  end;
  @blockinput:=GetProcAddress(userdll, 'BlockInput');
  if @blockinput=nil then begin
  feingabesperre:=value;
  exit;
  end;
  if value=liNone then begin
   blockinput(false);
   if feingabesperre=liHard then SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,@j,0);
  end
  else if value=liNormal then begin
   if feingabesperre=liHard then SystemParametersInfo(SPI_SCREENSAVERRUNNING,0,@j,0)
   else blockinput(true);
  end
  else if value=liHard then begin
   blockinput(true);
   SystemParametersInfo(SPI_SCREENSAVERRUNNING,1,@j,0);
  end;
feingabesperre:=value;
end;

procedure Register;
begin
  RegisterComponents('Roland', [TPhantom]);
end;

end.

 