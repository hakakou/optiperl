unit VirtualUnicodeControls;

// Version 1.5.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// Much of this unit is based on Troy Wolbrinks Unicode Controls package
// http://home.ccci.org/wolbrink/tntmpd/delphi_unicode_controls_project.htm
// Thanks to Troy for making this possible.
// ----------------------------------------------------------------------------

// 10-04
//   Fixed Bug in TWideCaptionHolder.Notification
//        Added WideCaptionHolders.Remove(Self);

interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, ActiveX, ComCtrls, Commctrl, ImgList,
  {$IFDEF COMPILER_5_UP}
  Contnrs,
  {$ELSE}
  VirtualShellContainers,
  {$ENDIF}
  VirtualWideStrings, VirtualShellUtilities, VirtualUtilities;

type
  TSetAnsiStrEvent = procedure(const Value: AnsiString) of object;

type
  TCustomWideEdit = class(TCustomEdit{TNT-ALLOW TCustomEdit})
  private
    function GetSelText: WideString; reintroduce;
    procedure SetSelText(const Value: WideString);
    function GetText: WideString;
    procedure SetText(const Value: WideString);
//    function GetHint: WideString;
//    procedure SetHint(const Value: WideString);
//    function IsHintStored: Boolean;
  protected
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure SelectText(FirstChar, LastChar: integer);
  public
    property SelText: WideString read GetSelText write SetSelText;
    property Text: WideString read GetText write SetText;
  published
 //   property Hint: WideString read GetHint write SetHint stored IsHintStored;
  end;

  TWideEdit = class(TCustomWideEdit)
  published
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    {$ifdef COMPILER_5_UP}
    property OnContextPopup;
    {$endif}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

  procedure TntCustomEdit_CreateWindowHandle(Edit: TCustomEdit; const Params: TCreateParams);
  function TntCustomEdit_GetSelText(Edit: TCustomEdit): WideString;
  procedure TntCustomEdit_SetSelText(Edit: TCustomEdit; const Value: WideString);

  // register/create window
  procedure SubClassUnicodeControl(Control: TWinControl; Params_Caption: PAnsiChar; IDEWindow: Boolean = False);
  procedure RegisterUnicodeClass(Params: TCreateParams; out WideWinClassName: WideString; IDEWindow: Boolean = False);
  procedure CreateUnicodeHandle(Control: TWinControl; const Params: TCreateParams; const SubClass: WideString; IDEWindow: Boolean = False);

  // caption/text management
  function TntControl_IsCaptionStored(Control: TControl): Boolean;
  function TntControl_GetStoredText(Control: TControl; const Default: WideString): WideString;
  function TntControl_GetText(Control: TControl): WideString;
  procedure TntControl_SetText(Control: TControl; const Text: WideString);
  function Tnt_SetWindowTextW(hWnd: HWND; lpString: PWideChar): BOOL;

  // "synced" wide string
  function GetSyncedWideString(var WideStr: WideString; const AnsiStr: AnsiString): WideString;
  procedure SetSyncedWideString(const Value: WideString; var WideStr: WideString; const AnsiStr: AnsiString; SetAnsiStr: TSetAnsiStrEvent);

  // text/char message
  function IsTextMessage(Msg: UINT): Boolean;
  procedure MakeWMCharMsgSafeForAnsi(var Message: TMessage);
  procedure RestoreWMCharMsg(var Message: TMessage);
  function GetWideCharFromWMCharMsg(Message: TWMChar): WideChar;
  procedure SetWideCharForWMCharMsg(var Message: TWMChar; Ch: WideChar);

  function Tnt_Is_IntResource(ResStr: LPCWSTR): Boolean;
  
implementation

uses {$IFDEF COMPILER_5_UP}
     VirtualShellContainers,
     {$ENDIF}
     Imm;

type
  TAccessWinControl = class(TWinControl);
  TAccessControlActionLink = class(TControlActionLink);
  TAccessControl = class(TControl);

  TWndProc = function(HWindow: HWnd; Message, WParam, LParam: Longint): Longint; stdcall;

{$IFNDEF T2H}
type
  TWinControlTrap = class(TComponent)
  private
    WinControl_ObjectInstance: Pointer;
    ObjectInstance: Pointer;
    DefObjectInstance: Pointer;
    function IsInSubclassChain(Control: TWinControl): Boolean;
    procedure SubClassWindowProc;
  private
    FControl: TAccessWinControl;
    Handle: THandle;
    PrevWin32Proc: Pointer;
    PrevDefWin32Proc: Pointer;
    PrevWindowProc: TWndMethod;
  private
    LastWin32Msg: UINT;
    Win32ProcLevel: Integer;
    IDEWindow: Boolean;
    DestroyTrap: Boolean;
    TestForNull: Boolean;
    FoundNull: Boolean;
    {$IFDEF TNT_VERIFY_WINDOWPROC}
    LastVerifiedWindowProc: TWndMethod;
    {$ENDIF}
    procedure Win32Proc(var Message: TMessage);
    procedure DefWin32Proc(var Message: TMessage);
    procedure WindowProc(var Message: TMessage);
  private
    procedure SubClassControl(Params_Caption: PAnsiChar);
    procedure UnSubClassUnicodeControl;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

type
  TWideCaptionHolder = class(TComponent)
  private
    FControl: TControl;
    FWideCaption: WideString;
    FWideHint: WideString;
    procedure SetAnsiText(const Value: AnsiString);
//    procedure SetAnsiHint(const Value: AnsiString);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TControl); reintroduce;
    property WideCaption: WideString read FWideCaption;
    property WideHint: WideString read FWideHint;
  end;

const
  ANSI_UNICODE_HOLDER = $FF;

var
  PendingRecreateWndTrapList: TObjectList = nil;

  WindowAtom: TAtom;
  ControlAtom: TAtom;
  WindowAtomString: AnsiString;
  ControlAtomString: AnsiString;

  UnicodeCreationControl: TWinControl = nil;
  WideCaptionHolders: TObjectList = nil;

  Finalized: Boolean; { If any tnt controls are still around after finalization it must be due to a memory leak.
                        Windows will still try to send a WM_DESTROY, but we will just ignore it if we're finalized. }

  _IsShellProgramming: Boolean = False;

// Local Procedures
// -----------------------------------------------------------------------------

function Win32PlatformIsUnicode: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT
end;

function Win32PlatformIsXP: Boolean;
begin
  Result := ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1))
                    or  (Win32MajorVersion > 5);
end;

procedure RaiseLastOperatingSystemError;
begin
  {$IFDEF COMPILER_6_UP}
  RaiseLastOSError
  {$ELSE}
  RaiseLastWin32Error
  {$ENDIF}
end;

procedure RestoreWMCharMsg(var Message: TMessage);
begin
  with TWMChar(Message) do begin
    Assert(Message.Msg = WM_CHAR);
    if (Unused > 0)
    and (CharCode = ANSI_UNICODE_HOLDER) then
      CharCode := Unused;
    Unused := 0;
  end;
end;

function SameWndMethod(A, B: TWndMethod): Boolean;
begin
  Result := @A = @B;
end;

function WideCompareStr(const W1, W2: WideString): Integer;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := CompareStringW(LOCALE_USER_DEFAULT, 0,
      PWideChar(W1), Length(W1), PWideChar(W2), Length(W2)) - 2
  else
    Result := AnsiCompareStr(W1, W2);
end;

function WideSameStr(const W1, W2: WideString): Boolean;
begin
  Result := WideCompareStr(W1, W2) = 0;
end;

function FindWideCaptionHolder(Control: TControl; CreateIfNotFound: Boolean = True): TWideCaptionHolder;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to WideCaptionHolders.Count - 1 do begin
    if (TWideCaptionHolder(WideCaptionHolders[i]).FControl = Control) then begin
      Result := TWideCaptionHolder(WideCaptionHolders[i]);
      exit; // found it!
    end;
  end;
  if (Result = nil) and CreateIfNotFound then begin
    Result := TWideCaptionHolder.Create(Control);
  end;
end;

procedure SetWideStoredText(Control: TControl; const Value: WideString);
begin
  FindWideCaptionHolder(Control).FWideCaption := Value
end;

procedure InitControls;

  procedure InitAtomStrings_D5_D6_D7;
  begin
    WindowAtomString := Format('Delphi%.8X',[GetCurrentProcessID]);
    ControlAtomString := Format('ControlOfs%.8X%.8X', [HInstance, GetCurrentThreadID]);
  end;

  {$IFDEF VER120}
  procedure InitAtomStrings; // Delphi 4
  begin
    InitAtomStrings_D5_D6_D7;
  end;
  {$ENDIF}

  {$IFDEF VER130}
  procedure InitAtomStrings; // Delphi 5
  begin
    InitAtomStrings_D5_D6_D7;
  end;
  {$ENDIF}

  {$IFDEF VER140}
  procedure InitAtomStrings; // Delphi 6
  begin
    InitAtomStrings_D5_D6_D7;
  end;
  {$ENDIF}

  {$IFDEF VER150}
  procedure InitAtomStrings; // Delphi 7
  begin
    InitAtomStrings_D5_D6_D7;
  end;
  {$ENDIF}

  {$IFDEF VER170}
  procedure InitAtomStrings; // Delphi 2005
  begin
    InitAtomStrings_D5_D6_D7;
  end;
  {$ENDIF}

  {$IFDEF VER180}
  procedure InitAtomStrings; // Delphi 2006
  begin
    InitAtomStrings_D5_D6_D7;
  end;
  {$ENDIF}

begin
  InitAtomStrings;
  WindowAtom := GlobalAddAtom(PAnsiChar(WindowAtomString));
  ControlAtom := GlobalAddAtom(PAnsiChar(ControlAtomString));
end;

procedure DoneControls;
begin
  GlobalDeleteAtom(ControlAtom);
  ControlAtomString := '';
  GlobalDeleteAtom(WindowAtom);
  WindowAtomString := '';
end;

function FindOrCreateWinControlTrap(Control: TWinControl): TWinControlTrap;
var
  i: integer;
begin
  // find or create trap object
  Result := nil;
  for i := PendingRecreateWndTrapList.Count - 1 downto 0 do begin
    if TWinControlTrap(PendingRecreateWndTrapList[i]).FControl = Control then begin
      Result := TWinControlTrap(PendingRecreateWndTrapList[i]);
      PendingRecreateWndTrapList.Delete(i);
      break; { found it }
    end;
  end;
  if Result = nil then
    Result := TWinControlTrap.Create(Control);
end;

function InitWndProcW(HWindow: HWnd; Message, WParam, LParam: Longint): Longint; stdcall;

    function GetObjectInstance(Control: TWinControl): Pointer;
    var
      WinControlTrap: TWinControlTrap;
    begin
      WinControlTrap := FindOrCreateWinControlTrap(Control);
      PendingRecreateWndTrapList.Add(WinControlTrap);
      Result := WinControlTrap.WinControl_ObjectInstance;
    end;

var
  ObjectInstance: Pointer;
begin
  TAccessWinControl(CreationControl).WindowHandle := HWindow;
  ObjectInstance := GetObjectInstance(CreationControl);
  {Controls.InitWndProc converts control to ANSI here by calling SetWindowLongA()!}
  SetWindowLongW(HWindow, GWL_WNDPROC, Longint(ObjectInstance));
  if  (GetWindowLongW(HWindow, GWL_STYLE) and WS_CHILD <> 0)
  and (GetWindowLongW(HWindow, GWL_ID) = 0) then
    SetWindowLongW(HWindow, GWL_ID, HWindow);
  SetProp(HWindow, MakeIntAtom(ControlAtom), THandle(CreationControl));
  SetProp(HWindow, MakeIntAtom(WindowAtom), THandle(CreationControl));
  CreationControl := nil;
  Result := TWndProc(ObjectInstance)(HWindow, Message, WParam, lParam);
end;

function IsUnicodeCreationControl(Handle: HWND): Boolean;
begin
  Result := (UnicodeCreationControl <> nil)
        and (UnicodeCreationControl.HandleAllocated)
        and (UnicodeCreationControl.Handle = Handle);
end;

function WMNotifyFormatResult(FromHandle: HWND): Integer;
begin
  if (Win32Platform = VER_PLATFORM_WIN32_NT)
  and (IsWindowUnicode(FromHandle) or IsUnicodeCreationControl(FromHandle)) then
    Result := NFR_UNICODE
  else
    Result := NFR_ANSI;
end;

{$ENDIF T2H}

// Exported Procedure
// -----------------------------------------------------------------------------
procedure TntCustomEdit_CreateWindowHandle(Edit: TCustomEdit; const Params: TCreateParams);
var
  P: TCreateParams;
begin
  if SysLocale.FarEast
  and not(Win32Platform = VER_PLATFORM_WIN32_NT)
  and ((Params.Style and ES_READONLY) <> 0) then begin
    // Work around Far East Win95 API/IME bug.
    P := Params;
    P.Style := P.Style and (not ES_READONLY);
    CreateUnicodeHandle(Edit, P, 'EDIT');
    if Edit.HandleAllocated then
      SendMessage(Edit.Handle, EM_SETREADONLY, Ord(True), 0);
  end else
    CreateUnicodeHandle(Edit, Params, 'EDIT');
end;

function TntCustomEdit_GetSelText(Edit: TCustomEdit{TNT-ALLOW TCustomEdit}): WideString;
begin
  if Win32PlatformIsUnicode then
    Result := Copy(TntControl_GetText(Edit), Edit.SelStart + 1, Edit.SelLength)
  else
    Result := Edit.SelText
end;

procedure TntCustomEdit_SetSelText(Edit: TCustomEdit{TNT-ALLOW TCustomEdit}; const Value: WideString);
begin
  if Win32PlatformIsUnicode then
    SendMessageW(Edit.Handle, EM_REPLACESEL, 0, Longint(PWideChar(Value)))
  else
    Edit.SelText := Value;
end;

procedure SubClassUnicodeControl(Control: TWinControl; Params_Caption: PAnsiChar; IDEWindow: Boolean = False);
var
  WinControlTrap: TWinControlTrap;
begin
  if not IsWindowUnicode(Control.Handle) then
    raise Exception.Create('TNT Internal Error: SubClassUnicodeControl.Control is not Unicode.');

  WinControlTrap := FindOrCreateWinControlTrap(Control);
  WinControlTrap.SubClassControl(Params_Caption);
  WinControlTrap.IDEWindow := IDEWindow;
end;

procedure RegisterUnicodeClass(Params: TCreateParams; out WideWinClassName: WideString; IDEWindow: Boolean = False);
const
  UNICODE_CLASS_EXT = '.UnicodeClass';
var
  TempClass: TWndClassW;
  WideClass: TWndClassW;
  ClassRegistered: Boolean;
  InitialProc: TFNWndProc;
begin
  if IDEWindow then
    InitialProc := @InitWndProc
  else
    InitialProc := @InitWndProcW;

  with Params do begin
    WideWinClassName := WinClassName + UNICODE_CLASS_EXT;
    ClassRegistered := GetClassInfoW(WindowClass.hInstance, PWideChar(WideWinClassName), TempClass);
    if (not ClassRegistered) or (TempClass.lpfnWndProc <> InitialProc)
    then begin
      if ClassRegistered then Windows.UnregisterClassW(PWideChar(WideWinClassName), WindowClass.hInstance);
      // Prepare a TWndClassW record
      WideClass := TWndClassW(WindowClass);
      WideClass.lpfnWndProc := InitialProc;
      if not Tnt_Is_IntResource(PWideChar(WindowClass.lpszMenuName)) then begin
        WideClass.lpszMenuName := PWideChar(WideString(WindowClass.lpszMenuName));
      end;
      WideClass.lpszClassName := PWideChar(WideWinClassName);

      // Register the UNICODE class
      if RegisterClassW(WideClass) = 0 then RaiseLastOperatingSystemError;
    end;
  end;
end;

procedure CreateUnicodeHandle(Control: TWinControl; const Params: TCreateParams; const SubClass: WideString; IDEWindow: Boolean = False);
var
  TempSubClass: TWndClassW;
  WideWinClassName: WideString;
  Handle: THandle;
begin
    if not (Win32Platform = VER_PLATFORM_WIN32_NT) then begin
    with Params do
      TAccessWinControl(Control).WindowHandle := CreateWindowEx(ExStyle, WinClassName,
        Caption, Style, X, Y, Width, Height, WndParent, 0, WindowClass.hInstance, Param);
  end else begin
    // SubClass the unicode version of this control by getting the correct DefWndProc
    if (SubClass <> '')
    and GetClassInfoW(Params.WindowClass.hInstance, PWideChar(SubClass), TempSubClass) then
      TAccessWinControl(Control).DefWndProc := TempSubClass.lpfnWndProc
    else
      TAccessWinControl(Control).DefWndProc := @DefWindowProcW;

    // make sure Unicode window class is registered
    RegisterUnicodeClass(Params, WideWinClassName, IDEWindow);

    // Create UNICODE window handle
    UnicodeCreationControl := Control;
    try
      with Params do
        Handle := CreateWindowExW(ExStyle, PWideChar(WideWinClassName), nil,
          Style, X, Y, Width, Height, WndParent, 0, WindowClass.hInstance, Param);
      if Handle = 0 then
        RaiseLastOperatingSystemError;
      TAccessWinControl(Control).WindowHandle := Handle;
      if IDEWindow then
        SetWindowLongW(Handle, GWL_WNDPROC, GetWindowLong(Handle, GWL_WNDPROC));
    finally
      UnicodeCreationControl := nil;
    end;

    SubClassUnicodeControl(Control, Params.Caption, IDEWindow);
  end;
end;
function TntControl_IsCaptionStored(Control: TControl): Boolean;
begin
  with TAccessControl(Control) do
    Result := (ActionLink = nil) or not TAccessControlActionLink(ActionLink).IsCaptionLinked;
end;

function TntControl_GetStoredText(Control: TControl; const Default: WideString): WideString;
var
  WideCaptionHolder: TWideCaptionHolder;
begin
  WideCaptionHolder := FindWideCaptionHolder(Control, False);
  if WideCaptionHolder <> nil then
    Result := WideCaptionHolder.WideCaption
  else
    Result := Default;
end;

procedure TntControl_SetStoredText(Control: TControl; const Value: WideString);
begin
  FindWideCaptionHolder(Control).FWideCaption := Value;
  TAccessControl(Control).Text := Value;
end;

function TntControl_GetText(Control: TControl): WideString;
var
  WideCaptionHolder: TWideCaptionHolder;
begin
  if (not Win32PlatformIsUnicode)
  or ((Control is TWinControl) and TWinControl(Control).HandleAllocated and (not IsWindowUnicode(TWinControl(Control).Handle))) then
    // Win9x / non-unicode handle
    Result := TAccessControl(Control).Text
  else if (not (Control is TWinControl)) then begin
    // non-windowed TControl
    WideCaptionHolder := FindWideCaptionHolder(Control, False);
    if WideCaptionHolder = nil then
      Result := TAccessControl(Control).Text
    else
      Result := GetSyncedWideString(WideCaptionHolder.FWideCaption, TAccessControl(Control).Text);
  end else if (not TWinControl(Control).HandleAllocated) then begin
    // NO HANDLE
    Result := TntControl_GetStoredText(Control, TAccessControl(Control).Text)
  end else begin
    // UNICODE & HANDLE
    SetLength(Result, GetWindowTextLengthW(TWinControl(Control).Handle) + 1);
    GetWindowTextW(TWinControl(Control).Handle, PWideChar(Result), Length(Result));
    SetLength(Result, Length(Result) - 1);
  end;
end;

procedure TntControl_SetText(Control: TControl; const Text: WideString);
begin
  if (not Win32PlatformIsUnicode)
  or ((Control is TWinControl) and TWinControl(Control).HandleAllocated and (not IsWindowUnicode(TWinControl(Control).Handle))) then
    // Win9x / non-unicode handle
    TAccessControl(Control).Text := Text
  else if (not (Control is TWinControl)) then begin
    // non-windowed TControl
    with FindWideCaptionHolder(Control) do
      SetSyncedWideString(Text, FWideCaption, TAccessControl(Control).Text, SetAnsiText)
  end else if (not TWinControl(Control).HandleAllocated) then begin
    // NO HANDLE
    TntControl_SetStoredText(Control, Text);
  end else if TntControl_GetText(Control) <> Text then begin
    // UNICODE & HANDLE
    Tnt_SetWindowTextW(TWinControl(Control).Handle, PWideChar(Text));
    Control.Perform(CM_TEXTCHANGED, 0, 0);
  end;
end;

function Tnt_SetWindowTextW(hWnd: HWND; lpString: PWideChar): BOOL;
begin
  if Win32PlatformIsUnicode then
    Result := SetWindowTextW{TNT-ALLOW SetWindowTextW}(hWnd, lpString)
  else
    Result := SetWindowTextA{TNT-ALLOW SetWindowTextA}(hWnd, PAnsiChar(AnsiString(lpString)));
end;

function GetSyncedWideString(var WideStr: WideString; const AnsiStr: AnsiString): WideString;
begin
  if AnsiString(WideStr) <> (AnsiStr) then begin
    WideStr := AnsiStr; {AnsiStr changed.  Keep WideStr in sync.}
  end;
  Result := WideStr;
end;

procedure SetSyncedWideString(const Value: WideString; var WideStr: WideString;
  const AnsiStr: AnsiString; SetAnsiStr: TSetAnsiStrEvent);
begin
  if Value <> GetSyncedWideString(WideStr, AnsiStr) then
  begin
    if (not WideSameStr(Value, AnsiString(Value))) {unicode chars lost in conversion}
    and (AnsiStr = AnsiString(Value))  {AnsiStr is not going to change}
    then begin
      SetAnsiStr(''); {force the change}
    end;
    WideStr := Value;
    SetAnsiStr(Value);
  end;
end;

function IsTextMessage(Msg: UINT): Boolean;
begin
  // WM_CHAR is omitted because of the special handling it receives
  Result := (Msg = WM_SETTEXT)
         or (Msg = WM_GETTEXT)
         or (Msg = WM_GETTEXTLENGTH);
end;

procedure MakeWMCharMsgSafeForAnsi(var Message: TMessage);
begin
  with TWMChar(Message) do begin
    Assert(Msg = WM_CHAR);
    //Assert(Unused = 0);
    // JH: when a Unicode control is embedded under non-Delphi Unicode window
    // something strange happens
    if (Unused <> 0) then begin
      CharCode := (Unused SHL 8) OR CharCode;
    end;
    if (CharCode > Word(High(AnsiChar))) then begin
      Unused := CharCode;
      CharCode := ANSI_UNICODE_HOLDER;
    end;
  end;
end;


{
procedure MakeWMCharMsgSafeForAnsi(var Message: TMessage);
begin
  with TWMChar(Message) do begin
    Assert(Msg = WM_CHAR);
    Assert(Unused = 0);
    if (CharCode > Word(High(AnsiChar))) then begin
      Unused := CharCode;
      CharCode := ANSI_UNICODE_HOLDER;
    end;
  end;
end;
 }

function GetWideCharFromWMCharMsg(Message: TWMChar): WideChar;
begin
  if (Message.CharCode = ANSI_UNICODE_HOLDER)
  and (Message.Unused <> 0) then
    Result := WideChar(Message.Unused)
  else
    Result := WideChar(Message.CharCode);
end;

procedure SetWideCharForWMCharMsg(var Message: TWMChar; Ch: WideChar);
begin
  Message.CharCode := Word(Ch);
  Message.Unused := 0;
  MakeWMCharMsgSafeForAnsi(TMessage(Message));
end;

function Tnt_Is_IntResource(ResStr: LPCWSTR): Boolean;
begin
  Result := HiWord(Cardinal(ResStr)) = 0;
end;

{ TWinControlTrap }

constructor TWinControlTrap.Create(AOwner: TComponent);
begin
  FControl := TAccessWinControl(AOwner as TWinControl);
  inherited Create(nil);
  FControl.FreeNotification(Self);

  {$IFNDEF DELPHI_6_UP}
  WinControl_ObjectInstance := Forms.MakeObjectInstance(FControl.MainWndProc);
  ObjectInstance := Forms.MakeObjectInstance(Win32Proc);
  DefObjectInstance := Forms.MakeObjectInstance(DefWin32Proc);
  {$ELSE}
  WinControl_ObjectInstance := Classes.MakeObjectInstance(FControl.MainWndProc);
  ObjectInstance := Classes.MakeObjectInstance(Win32Proc);
  DefObjectInstance := Classes.MakeObjectInstance(DefWin32Proc);
 {$ENDIF}
end;

destructor TWinControlTrap.Destroy;
begin
  {$IFNDEF DELPHI_6_UP}
  Forms.FreeObjectInstance(ObjectInstance);
  Forms.FreeObjectInstance(DefObjectInstance);
  Forms.FreeObjectInstance(WinControl_ObjectInstance);
  {$ELSE}
  Classes.FreeObjectInstance(ObjectInstance);
  Classes.FreeObjectInstance(DefObjectInstance);
  Classes.FreeObjectInstance(WinControl_ObjectInstance);
  {$ENDIF}
  inherited;
end;

procedure TWinControlTrap.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (AComponent = FControl) and (Operation = opRemove) then begin
    FControl := nil;
    if Win32ProcLevel = 0 then
      Free
    else
      DestroyTrap := True;
  end;
end;

function TWinControlTrap.IsInSubclassChain(Control: TWinControl): Boolean;
var
  Message: TMessage;
begin
  if SameWndMethod(Control.WindowProc, TAccessWinControl(Control).WndProc) then
    Result := False { no subclassing }
  else if SameWndMethod(Control.WindowProc, Self.WindowProc) then
    Result := True { directly subclassed }
  else begin
    TestForNull := True;
    FoundNull := False;
    ZeroMemory(@Message, SizeOf(Message));
    Message.Msg := WM_NULL;
    Control.WindowProc(Message);
    Result := FoundNull; { indirectly subclassed }
  end;
end;

procedure TWinControlTrap.SubClassWindowProc;
begin
  if not IsInSubclassChain(FControl) then begin
    PrevWindowProc := FControl.WindowProc;
    FControl.WindowProc := Self.WindowProc;
  end;
  {$IFDEF TNT_VERIFY_WINDOWPROC}
  LastVerifiedWindowProc := FControl.WindowProc;
  {$ENDIF}
end;

procedure TWinControlTrap.SubClassControl(Params_Caption: PAnsiChar);
begin
  // initialize trap object
  Handle := FControl.Handle;
  PrevWin32Proc := Pointer(GetWindowLongW(FControl.Handle, GWL_WNDPROC));
  PrevDefWin32Proc := FControl.DefWndProc;

  // subclass Window Procedures
  SetWindowLongW(FControl.Handle, GWL_WNDPROC, Integer(ObjectInstance));
  FControl.DefWndProc := DefObjectInstance;
  SubClassWindowProc;

  // For some reason, caption gets garbled after calling SetWindowLongW(.., GWL_WNDPROC).
  TntControl_SetText(FControl, TntControl_GetStoredText(FControl, Params_Caption));
end;

procedure TWinControlTrap.Win32Proc(var Message: TMessage);
begin
  if (not Finalized) then begin
    Inc(Win32ProcLevel);
    try
      with Message do begin
        {$IFDEF TNT_VERIFY_WINDOWPROC}
        if not SameWndMethod(FControl.WindowProc, LastVerifiedWindowProc) then begin
          SubClassWindowProc;
          LastVerifiedWindowProc := FControl.WindowProc;
        end;
        {$ENDIF}
        LastWin32Msg := Msg;
        Result := CallWindowProcW(PrevWin32Proc, Handle, Msg, wParam, lParam);
      end;
    finally
      Dec(Win32ProcLevel);
    end;
    if (Win32ProcLevel = 0) and (DestroyTrap) then
      Free;
  end else if (Message.Msg = WM_DESTROY) then
    FControl.WindowHandle := 0
end;

procedure TWinControlTrap.DefWin32Proc(var Message: TMessage);

  function IsChildEdit(AHandle: HWND): Boolean;
  var
    AHandleClass: WideString;
  begin
    Result := False;
    if (FControl.Handle = GetParent(Handle)) then begin
      // child control
      SetLength(AHandleClass, 255);
      SetLength(AHandleClass, GetClassNameW(AHandle, PWideChar(AHandleClass), Length(AHandleClass)));
      Result := StrICompW(PWideChar(AHandleClass), 'EDIT') = 0;
    end;
  end;

begin
  with Message do begin
    if Msg = WM_NOTIFYFORMAT then
      Result := WMNotifyFormatResult(Message.wParam)
    else begin
      if (Msg = WM_CHAR) then begin
        RestoreWMCharMsg(Message)
      end;
      if (Msg = WM_IME_CHAR) and (not _IsShellProgramming) and (not Win32PlatformIsXP) then
      begin
        { In Windows XP, DefWindowProc handles WM_IME_CHAR fine for VCL windows. }
        { Before XP, DefWindowProc will sometimes produce incorrect, non-Unicode WM_CHAR. }
        { Also, using PostMessageW on Windows 2000 didn't always produce the correct results. }
        Message.Result := SendMessageW(Handle, WM_CHAR, wParam, lParam)
      end else if (Msg = WM_IME_CHAR) and (_IsShellProgramming) then begin
        { When a Tnt control is hosted by a non-delphi control, DefWindowProc doesn't always work even on XP. }
        if IsChildEdit(Handle) then
          Message.Result := Integer(PostMessageW(Handle, WM_CHAR, wParam, lParam)) // native edit child control
        else
          Message.Result := SendMessageW(Handle, WM_CHAR, wParam, lParam);
      end else begin
        if (Msg = WM_DESTROY) then begin
          UnSubClassUnicodeControl; {The reason for doing this in DefWin32Proc is because in D9, TWinControl.WMDestroy() does a perform(WM_TEXT) operation. }
        end;
        { Normal DefWindowProc }
        Result := CallWindowProcW(PrevDefWin32Proc, Handle, Msg, wParam, lParam);
      end;
    end;
  end;
end;

procedure TWinControlTrap.WindowProc(var Message: TMessage);
var
  CameFromWindows: Boolean;
begin
  if TestForNull and (Message.Msg = WM_NULL) then
    FoundNull := True;

  if (not FControl.HandleAllocated) then
    FControl.WndProc(Message)
  else begin
    CameFromWindows := LastWin32Msg <> WM_NULL;
    LastWin32Msg := WM_NULL;
    with Message do begin
  {    if Msg = CM_HINTSHOW then
        ProcessCMHintShowMsg(Message);    }
      if (not CameFromWindows)
      and (IsTextMessage(Msg)) then
        Result := SendMessageA(Handle, Msg, wParam, lParam)
      else begin
        if (Msg = WM_CHAR) then begin
          MakeWMCharMsgSafeForAnsi(Message);
        end;
        PrevWindowProc(Message)
      end;
    end;
  end;
end;

procedure TWinControlTrap.UnSubClassUnicodeControl;
begin
  // remember caption for future window creation
  if not (csDestroying in FControl.ComponentState) then
    TntControl_SetStoredText(FControl, TntControl_GetText(FControl));

  // restore window procs (restore WindowProc only if we are still the direct subclass)
  if SameWndMethod(FControl.WindowProc, Self.WindowProc) then
    FControl.WindowProc := PrevWindowProc;
  TAccessWinControl(FControl).DefWndProc := PrevDefWin32Proc;
  SetWindowLongW(FControl.Handle, GWL_WNDPROC, Integer(PrevWin32Proc));

  if IDEWindow then
    DestroyTrap := True
  else if not (csDestroying in FControl.ComponentState) then
    // control not being destroyed, probably recreating window
    PendingRecreateWndTrapList.Add(Self);
end;

{ TWideCaptionHolder }

type
  TListTargetCompare = function (Item, Target: Pointer): Integer;

function FindSortedListByTarget(List: TList; TargetCompare: TListTargetCompare;
  Target: Pointer; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := List.Count - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := TargetCompare(List[i], Target);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

function CompareCaptionHolderToTarget(Item, Target: Pointer): Integer;
begin
  if Integer(TWideCaptionHolder(Item).FControl) < Integer(Target) then
    Result := -1
  else if Integer(TWideCaptionHolder(Item).FControl) > Integer(Target) then
    Result := 1
  else
    Result := 0;
end;

function FindWideCaptionHolderIndex(Control: TControl; var Index: Integer): Boolean;
begin
  // find control in sorted wide caption list (list is sorted by TWideCaptionHolder.FControl)
  Result := FindSortedListByTarget(WideCaptionHolders, CompareCaptionHolderToTarget, Control, Index);
end;

constructor TWideCaptionHolder.Create(AOwner: TControl);
var
  Index: Integer;
begin
  inherited Create(nil);
  FControl := AOwner;
  FControl.FreeNotification(Self);

  // insert into list according sort
  FindWideCaptionHolderIndex(FControl, Index);
  WideCaptionHolders.Insert(Index, Self);
end;

procedure TWideCaptionHolder.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if (AComponent = FControl) and (Operation = opRemove) then begin
    FControl := nil;
    // JIM 10/04
    // BUG Added to fix problem with MDI Apps
    WideCaptionHolders.Remove(Self);
    Free;
  end;
end;

procedure TWideCaptionHolder.SetAnsiText(const Value: AnsiString);
begin
  TAccessControl(FControl).Text := Value;
end;

//procedure TWideCaptionHolder.SetAnsiHint(const Value: AnsiString);
//begin
//  FControl.Hint := Value;
//end;

{ TCustomWideEdit }

procedure TCustomWideEdit.CreateWindowHandle(const Params: TCreateParams);
begin
  TntCustomEdit_CreateWindowHandle(Self, Params);
end;

procedure TCustomWideEdit.DefineProperties(Filer: TFiler);
begin
  inherited;
//  Only need this if we want to have the IDE show wide string (Published) at design time
//  To include it we need Mikes Unicode package and that is too much overhead
//  DefineWideProperties(Filer, Self);
end;

function TCustomWideEdit.GetSelText: WideString;
begin
  Result := TntCustomEdit_GetSelText(Self);
end;

function TCustomWideEdit.GetText: WideString;
begin
  Result := TntControl_GetText(Self);
end;

procedure TCustomWideEdit.SelectText(FirstChar, LastChar: integer);
begin
  if IsWindowUnicode(Handle) then
    PostMessageW(Handle, EM_SETSEL, FirstChar, LastChar)
  else
    PostMessage(Handle, EM_SETSEL, FirstChar, LastChar)
end;

procedure TCustomWideEdit.SetSelText(const Value: WideString);
begin
  TntCustomEdit_SetSelText(Self, Value);
end;

procedure TCustomWideEdit.SetText(const Value: WideString);
begin
  TntControl_SetText(Self, Value);
end;

initialization

  WideCaptionHolders := TObjectList.Create(False);
  PendingRecreateWndTrapList := TObjectList.Create(False);
  InitControls;

{
  if  (Win32Platform = VER_PLATFORM_WIN32_NT)
  and (Win32MajorVersion >= 5) then
    DefFontData.Name := 'MS Shell Dlg 2'
  else
    DefFontData.Name := 'MS Shell Dlg';
}

finalization
  WideCaptionHolders.Free;
  PendingRecreateWndTrapList.Free;
  DoneControls;

end.


