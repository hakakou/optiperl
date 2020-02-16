unit ComboBoxX;

{
    This software is provided 'as-is', without any express or implied warranty.
    In no event shall the author be held liable for any damages arising from the
    use of this software.

    Liscence: Freeware, free to use and distribute as long as the original source stays intact.
                        free to modify as long as all modifications are sent back to me.  :)

    ComboBoxX
    Copyright © 1999 ahmoy law
    e-mail:  ahmoy_law@hotmail.com
             ahmoy_law@yahoo.com
    Version: 1.10

    Any suggestions, modifications, bugs or anything! kindly please send an email to me :)
    p/s: hidup oghe kelate!!!


bugs list
---------
26 may 2001
    - unnecessary input characters when user pressed enter key in editbox bug (solved)
    - popdown list selection using keyboard bug (solved)
28 may 2001
    - ItemIndex cannot modify the Text property (solved)
    - dropdown text changed if listbox is closed (solved)


enhancements list
-----------------
26 may 2001
    - item will be highlighted if one of items is subset to the Text property
    - the paint code for popup form is moved into PopupFormPaint virtual function and other
      small modifications to support flat gui style
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  ExtCtrls, Mask;

const
    CBX_BORDER_WIDTH = 2;

    CBX_SCROLL_RANGE = 4;
    CBX_TIMER_MAX    = 500;
    CBX_TIMER_MIN    = 100;
    CBX_TIMER_DEC    = 50;
    CBX_LINE_WIDTH   = 2;
    CBX_PANEL_OFFSET = 1;
    CBX_PANEL_HEIGHT = 14;
    CBX_FORM_FRAME   = 1;

    CBX_BUTTON_OFFSET = 1;
    CBX_BUTTON_WIDTH  = 15;
    CBX_BUTTON_HEIGHT = 13;

    CBX_BUTTON_MAX  = 6;
    CBX_BUTTON_EDIT = 0;
    CBX_BUTTON_NEW  = 1;
    CBX_BUTTON_DEL  = 2;
    CBX_BUTTON_UP   = 3;
    CBX_BUTTON_DOWN = 4;
    CBX_BUTTON_PINS = 5;

    CBX_NEWITEM_CAPTION = 'NewItem';


type
  TCBXInplaceEditActionType = ( ieaAccept, ieaCancel, ieaClear );
  TCBXInplaceEditEvent = procedure ( Sender: TObject; Action: TCBXInplaceEditActionType ) of object;

  TCustomComboBoxX = class;

  {TCBXInplaceEdit}
  TCBXInplaceEdit = class(TMaskEdit)
  private
    { Private declarations }
    FCBXControl: TCustomComboBoxX;
    FOnAction: TCBXInplaceEditEvent;
  protected
    { Protected declarations }
    FTextObject: TObject;

    procedure CBXWMActivateEnable ( Value: boolean );

    procedure ClientChanged; virtual;
    procedure CreateParams ( var Params: TCreateParams ); override;

    procedure WMSize ( var Message: TWMSize ); message WM_SIZE;
    procedure WMKillFocus (var Message: TWMKillFocus ); message WM_KILLFOCUS;
    procedure CMVisibleChanged (var Message: TMessage ); message CM_VISIBLECHANGED;
    procedure KeyPress ( var Key: Char ); override;

    procedure PerformAction ( Action: TCBXInplaceEditActionType ); virtual;
    function  CanAccept: boolean; virtual;
    function  CanCancel: boolean; virtual;
    function  CanClear:  boolean; virtual;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;

    // parent will call these functions
    function  QueryCancel: boolean;
    function  QueryAccept: boolean;
    function  QueryClear: boolean;

    procedure Open ( aCBX: TCustomComboBoxX ); virtual;
    procedure Close;  virtual;

    property TextObject: TObject read FTextObject write FTextObject;
    property OnAction: TCBXInplaceEditEvent read FOnAction write FOnAction;
  end;


  TCBXDropDownEvent = procedure ( Sender: TObject; var Enabled: boolean ) of object;
  TCBXItemEvent = procedure ( Sender: TObject; var Enabled: boolean ) of object;
  TCBXEditEvent = procedure ( Sender: TObject; var Text: string; var TextObject: TObject;
                              var InplaceEditor: TCBXInplaceEdit; var Enabled: boolean ) of object;
  TCBXItemObjectEvent = procedure ( Sender: TObject; var Text: string; var TextObject: TObject; var Enabled: boolean ) of object;
  TCBXButton = ( cbxbEdit, cbxbNew, cbxbDelete, cbxbUp, cbxbDown, cbxbPin );
  TCBXButtons = set of TCBXButton;


  {TCustomComboBoxX}
  TCustomComboBoxX = class(TCustomEdit)
  private
    { Private declarations }
    // -------- Edit ----------
    FButtonRect: TRect;
    FEditMouseDown: boolean;
    FEditMouseIn: boolean;

    // -------- ComboBox ----------
    FDrawListBox: boolean;
    FStyle: TComboBoxStyle;
    FWMActivateEnabled: boolean;  // disable the WM_ACTIVATE

    FCBXButtons: TCBXButtons;
    FDropDownCount: integer;
    FPopupListWidth: integer;
    FVisibleLines: integer;

    FPinDown: boolean;
    FDragEnable: boolean;
    FAutoScroll: boolean;
    FAutoSelect: boolean; // runtime
    FScrollUp: boolean;   // runtime

    FPrevDirty: boolean;
    FDirty: boolean;
    FDirtyIndex: integer;

    FDownIndex: integer;
    FMouseDown: boolean;
    FMouseIn: boolean;

    FTimer: TTimer;
    FButtons: array [0..CBX_BUTTON_MAX-1] of TSpeedButton;

    FFormWindowProc: TWndMethod;
    FListBoxWindowProc: TWndMethod;

    FCurrInplaceEdit,
    FInplaceEdit: TCBXInplaceEdit;
    FInplaceEditVisibled: boolean;

    FOnDropDown: TCBXDropDownEvent;
    FOnDropUp: TNotifyEvent;
    FOnEditItem: TCBXEditEvent;
    FOnNewItem,
    FOnModifiedItem: TCBXItemObjectEvent;
    FOnDeleteItem,
    FOnMoveUpItem,
    FOnMoveDownItem: TCBXItemEvent;

    FDrawItemEvent: TDrawItemEvent;
    FMeasureItemEvent: TMeasureItemEvent;

    // ---------- Edit ---------------
    function  GetMinHeight: Integer;
    function  GetEditRect: TRect;
    function  GetCanvas: TCanvas;

    procedure SetEditText ( aClosed: boolean );

    // --------- ComboBox -------------
    procedure SetStyle ( Value: TComboBoxStyle );

    procedure SetItems ( Value: TStrings );
    function  GetItems: TStrings;
    function  GetItemIndex: integer;
    procedure SetItemIndex ( Value: Integer );
    function  GetSelCount: Integer;
    function  GetSelected ( Index: Integer ): boolean;
    procedure SetSelected ( Index: Integer; Value: boolean );
    function  GetTopIndex: integer;
    procedure SetTopIndex ( Value: integer );

    procedure SetItemHeight ( Value: Integer );
    function  GetItemHeight: Integer;
    function  GetMultiSelect: boolean;
    procedure SetMultiSelect ( Value: boolean );

    procedure SetButtons ( Value: TCBXButtons );
    function  GetDropDown: boolean;
    procedure SetDropDown ( Value: boolean );
    function  GetButtonHint: string;
    procedure SetButtonHint ( const Value: string );
    function  GetShowHint: boolean;
    procedure SetShowHint ( Value: boolean );
    function  GetText: string;
    procedure SetText ( const Value: string );

    function  GetTotalButtonWidth: integer;
    procedure LocateButtons;
    procedure UpdateButtonsStatus;
    procedure EnableButtonNew ( Value: boolean );
    procedure EnableButtonDel ( Value: boolean );

    procedure InitPopupWindow;  // size and pos
    procedure InitItemList;

    procedure DirtyLine ( Dirty: boolean );
    procedure DrawDirtyLine ( aIndex: integer );

    procedure InplaceEditClose;

    procedure FormWindowProcHook (var Message: TMessage);
    procedure FormKeyPressHook (Sender: TObject; var Key: Char);
    procedure ListBoxWindowProcHook (var Message: TMessage);
    procedure TimerEvent ( Sender: TObject );
    procedure InplaceEditEvent ( Sender: TObject; Action: TCBXInplaceEditActionType );
    procedure ItemEditEvent ( Sender: TObject );
    procedure ItemNewEvent ( Sender: TObject );
    procedure ItemDeleteEvent ( Sender: TObject );
    procedure ItemUpEvent ( Sender: TObject );
    procedure ItemDownEvent ( Sender: TObject );
    procedure PinChangedEvent ( Sender: TObject );

    procedure ListBoxMouseDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
    procedure ListBoxMouseMove(Sender: TObject; Shift: TShiftState;
              X, Y: Integer);
    procedure ListBoxMouseUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
    procedure ListBoxDblClick(Sender: TObject);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure ListBoxMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);

  protected
    { Protected declarations }
    FEditCanvas: TCanvas;
    FListBox: TListBox;
    FPanel: TPanel;
    FForm: TForm;

    // ----------- ComboBox -------------
    { date: 26 may 2001.
      description: to support frame bigger than 1 unit for the popup window
    }
    FFormFrameWidth: integer;

    // ----------- ComboBox -------------
    procedure DropDown; virtual;
    procedure DropUp; virtual;

    procedure NCDrawFrame; virtual;
    procedure NCDrawButton; virtual;
    procedure DrawEditWindow; virtual;

    procedure Notification ( AComponent: TComponent; Operation: TOperation ); override;

    // ---------- Edit --------------
    {  date: 26 may 2001.
       descriptions: unnecessary input characters when user pressed enter key in editbox bug
       procedure CreateParams (var Params: TCreateParams);  override;
    }
    procedure SetBiDiMode ( Value: TBiDiMode ); override;
    function  GetClientRect: TRect; override;
    function  GetDeviceContext ( var WindowHandle: HWnd ): HDC; override;

    // ----------- ComboBox -------------
    { date: 26 may 2001.
      description: the paint code for popup form is moved into PopupFormPaint virtual function
    }
    procedure PopupFormPaint; virtual;

    // ---------- Edit --------------
    procedure WMNCHitTest ( var Message: TWMNCHitTest ); message WM_NCHITTEST;
    procedure WMNCLButtonDown ( var Message: TWMNCLButtonDown ); message WM_NCLBUTTONDOWN;
    procedure WMSize ( var Message: TWMSize ); message WM_SIZE;
    procedure WMSetFocus ( var Message: TMessage ); message WM_SETFOCUS;
    procedure WMKillFocus ( var Message: TMessage ); message WM_KILLFOCUS;
    procedure WMNCCalcSize (var Message: TWMNCCalcSize); message WM_NCCALCSIZE;
    procedure WMNCPaint ( var Message: TWMNCPaint ); message WM_NCPAINT;
    procedure WMPaint ( var Message: TWMPaint ); message WM_PAINT;
    procedure CMColorChanged ( var Message: TMessage ); message CM_COLORCHANGED;
    procedure CMFontChanged ( var Message: TMessage ); message CM_FONTCHANGED;
    procedure CMEnabledChanged ( var Message: TMessage ); message CM_ENABLEDCHANGED;

    // ----------- Edit -----------------
    property  Canvas: TCanvas read GetCanvas;

    // ----------- ComboBox -------------
    property  DroppedDown: boolean read GetDropDown write SetDropDown;
    property  ItemIndex: Integer read GetItemIndex write SetItemIndex;
    property  SelCount: Integer read GetSelCount;
    property  Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property  TopIndex: Integer read GetTopIndex write SetTopIndex;

    property Style: TComboBoxStyle read FStyle write SetStyle;
    property Items: TStrings read GetItems write SetItems;
    property PinDown: boolean read FPinDown write FPinDown default FALSE;
    property ItemDrag: boolean read FDragEnable write FDragEnable default TRUE;
    property AutoScroll: boolean read FAutoScroll write FAutoScroll default TRUE;
    property ItemHeight: integer read GetItemHeight write SetItemHeight;
    property DropDownCount: integer read FDropDownCount write FDropDownCount;
    property MultiSelect: boolean read GetMultiSelect write SetMultiSelect;
    property PopupListWidth: integer read FPopupListWidth write FPopupListWidth;
    property Buttons: TCBXButtons read FCBXButtons write SetButtons;
    property ButtonHint: string read GetButtonHint write SetButtonHint;
    property ShowHint: boolean read GetShowHint write SetShowHint;
    property Text: string read GetText write SetText;
    property OnDropUp: TNotifyEvent read FOnDropUp write FOnDropUp;
    property OnDropDown: TCBXDropDownEvent read FOnDropDown write FOnDropDown;
    property OnDrawItem: TDrawItemEvent read FDrawItemEvent write FDrawItemEvent;
    property OnMeasureItem: TMeasureItemEvent read FMeasureItemEvent write FMeasureItemEvent;
    property OnEditItem: TCBXEditEvent read FOnEditItem write FOnEditItem;
    property OnNewItem: TCBXItemObjectEvent read FOnNewItem write FOnNewItem;
    property OnModifiedItem: TCBXItemObjectEvent read FOnModifiedItem write FOnModifiedItem;
    property OnDeleteItem: TCBXItemEvent read FOnDeleteItem write FOnDeleteItem;
    property OnMoveUpItem: TCBXItemEvent read FOnMoveUpItem write FOnMoveUpItem;
    property OnMoveDownItem: TCBXItemEvent read FOnMoveDownItem write FOnMoveDownItem;

  public
    { Public declarations }
    constructor Create ( AOwner: TComponent ); override;
    destructor Destroy; override;

    // ----------- ComboBox -------------
    procedure SeleteAll;
    procedure DeselectAll;
    procedure InverseSelection;
  end;


  {TComboBoxX}
  TComboBoxX = class(TCustomComboBoxX)
  public
    // ----------- Edit -----------------
    property  Canvas;

    // ----------- ComboBox -------------
    property  DroppedDown;
    property  ItemIndex;
    property  SelCount;
    property  Selected;
    property  TopIndex;

  published
    { Published declarations }
    property Style;
    property Items;
    property PinDown;
    property ItemDrag;
    property AutoScroll;
    property ItemHeight;
    property DropDownCount;
    property MultiSelect;
    property PopupListWidth;
    property Buttons;
    property ButtonHint;
    property ShowHint;
    property Text;
    property OnDropUp;
    property OnDropDown;
    property OnDrawItem;
    property OnMeasureItem;
    property OnEditItem;
    property OnNewItem;
    property OnModifiedItem;
    property OnDeleteItem;
    property OnMoveUpItem;
    property OnMoveDownItem;

    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnChange;
    property OnClick;
    property OnContextPopup;
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
    property OnStartDock;
    property OnStartDrag;
  end; // TComboBoxX


procedure Register;


//------------------------------------------------------------------------------

implementation

{$R RES_CBX.RES}

uses
    Math;

var
    FBmpEdit, FBmpNew, FBmpNewDis, FBmpDel, FBmpDelDis, FBmpUp, FBmpDown, FBmpPins: TBitmap;

// -----------------------------------------------------------------------------

constructor TCBXInplaceEdit.Create(AOwner: TComponent);
begin
inherited Create ( AOwner );

FCBXControl := NIL;
FOnAction   := NIL;
FTextObject := NIL;

ParentCtl3D := FALSE;
Ctl3D       := FALSE;
TabStop     := FALSE;
BorderStyle := bsNone;
end;


procedure TCBXInplaceEdit.CreateParams ( var Params: TCreateParams );
begin
inherited CreateParams(Params);
Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;


procedure TCBXInplaceEdit.WMSize ( var Message: TWMSize );
begin
inherited;
ClientChanged;
end;


procedure TCBXInplaceEdit.CBXWMActivateEnable ( Value: boolean );
begin
if ( FCBXControl <> NIL ) then
    FCBXControl.FWMActivateEnabled := Value;
end;


procedure TCBXInplaceEdit.WMKillFocus ( var Message: TWMKillFocus );
begin
inherited;
if ( CanCancel ) then PerformAction ( ieaCancel );
end;


procedure TCBXInplaceEdit.CMVisibleChanged (var Message: TMessage );
begin
inherited;
if ( Visible ) then begin
    ClientChanged;
    SendMessage ( Handle, EM_SETSEL, 0, -1 );
    SetFocus;
    end;
end;


procedure TCBXInplaceEdit.KeyPress ( var Key: Char );
begin
if ( Key = #13 ) then begin
    if ( CanAccept ) then begin
        Key := #0;
        inherited KeyPress ( Key );
        PerformAction ( ieaAccept );
        exit;
        end;
    end // if
else
if ( Key = #27 ) then begin  // ESC KEY
    if ( CanCancel ) then begin
        Key := #0;
        inherited KeyPress ( Key );
        PerformAction ( ieaCancel );
        exit;
        end;
    end;

inherited KeyPress ( Key );
end;


procedure TCBXInplaceEdit.ClientChanged;
var
  aRect: TRect;
begin
  SendMessage ( Handle, EM_GETRECT, 0, LongInt ( @aRect ) );

  if ( IsRectEmpty ( aRect ) ) then
     exit; // control is invisible

  aRect.Left   := 3;
  aRect.Top    := 0;
  aRect.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  aRect.Right  := ClientWidth;
  SendMessage ( Handle, EM_SETRECT, 0, LongInt ( @aRect ) );
  SendMessage ( Handle, EM_GETRECT, 0, LongInt ( @aRect ) );  {debug}
end;


procedure TCBXInplaceEdit.PerformAction ( Action: TCBXInplaceEditActionType );
begin
if ( Assigned ( FOnAction ) ) then
    FOnAction ( Self, Action );
end;


function TCBXInplaceEdit.CanAccept: boolean;
begin
result := TRUE;
end;


function TCBXInplaceEdit.CanCancel: boolean;
begin
if ( not FCBXControl.FWMActivateEnabled ) then
    result := FALSE
else
    result := TRUE;
end;


function TCBXInplaceEdit.CanClear: boolean;
begin
result := TRUE;
end;


function TCBXInplaceEdit.QueryCancel: boolean;
begin
result := CanClear;
if ( result ) then PerformAction ( ieaCancel );
end;

function TCBXInplaceEdit.QueryAccept: boolean;
begin
result := CanAccept;
if ( result ) then PerformAction ( ieaAccept );
end;

function TCBXInplaceEdit.QueryClear: boolean;
begin
result := CanClear;
if ( result ) then PerformAction ( ieaClear );
end;

procedure TCBXInplaceEdit.Open ( aCBX: TCustomComboBoxX );
begin
FCBXControl := aCBX;
Parent := aCBX.FListBox;
end;

procedure TCBXInplaceEdit.Close;
begin
FOnAction := NIL;
FCBXControl := NIL;
end;

// -----------------------------------------------------------------------------


{TCustomComboBoxX}
constructor TCustomComboBoxX.Create ( AOwner: TComponent );
const
    aHints: array [0..CBX_BUTTON_MAX-1] of string[7] = ( 'Edit', 'New', 'Delete',
                                                         'Up', 'Down', 'Pin' );
var
    acounter: integer;
begin
inherited;

// ------- Edit -----------
FEditMouseDown := FALSE;
FEditMouseIn   := FALSE;
FEditCanvas := TControlCanvas.Create;
TControlCanvas(FEditCanvas).Control := Self;

// ------- ComboBox -----------
FWMActivateEnabled := TRUE;
FStyle := csDropDown;

FPopupListWidth := 0;
FDrawListBox := FALSE;
FVisibleLines := -1;
FCBXButtons := [cbxbEdit, cbxbNew, cbxbDelete, cbxbUp, cbxbDown, cbxbPin];
FDropDownCount := 7;

FPinDown    := FALSE;
FAutoScroll := TRUE;
//FAutoSelect := TRUE;  // need to set to FALSE is multiselect is true
FDragEnable := TRUE;  // need to set to FALSE is multiselect or sorted is true

FPrevDirty  := FALSE;
FDirty      := FALSE;
FDirtyIndex := -1;

FDownIndex  := -1;
FMouseIn    := FALSE;
FMouseDown  := FALSE;

{ date: 26 may 2001.
  description: to support frame bigger than 1 unit for the popup window
}
FFormFrameWidth := CBX_FORM_FRAME;

FForm := TForm.Create ( Self );
FFormWindowProc   := FForm.WindowProc;
FForm.WindowProc  := FormWindowProcHook;
FForm.OnKeyPress  := FormKeyPressHook;
FForm.KeyPreview  := TRUE;
FForm.BorderStyle := bsNone;
FForm.AutoScroll  := FALSE;
FForm.Color       := Color;

FListBox          := TListBox.Create ( Self );
FlistBox.Color    := Color;
FlistBox.Parent   := FForm;
FlistBox.Style    := lbStandard;
FlistBox.BiDiMode := BiDiMode;
FlistBox.BorderStyle := bsNone;
FListBox.MultiSelect := FALSE;
FListBox.ItemHeight  := 13;
FlistBox.OnMouseDown := ListBoxMouseDown;
FlistBox.OnMouseMove := ListBoxMouseMove;
FlistBox.OnMouseUp  := ListBoxMouseUp;
FlistBox.OnDblClick := ListBoxDblClick;
FlistBox.OnDrawItem := ListBoxDrawItem;
FlistBox.OnMeasureItem := ListBoxMeasureItem;

FPanel            := TPanel.Create ( Self );
FPanel.Caption    := '';
FPanel.Height     := CBX_PANEL_HEIGHT;
FPanel.BevelOuter := bvNone;
FPanel.Parent     := FForm;

for acounter := 1 to CBX_BUTTON_MAX do begin
    FButtons[acounter-1] := TSpeedButton.Create ( Self );
    with ( FButtons[acounter-1] ) do begin
        ShowHint := FALSE;
        Hint := aHints[acounter-1];
        AllowAllUp := TRUE;
        Flat := TRUE;
        Tag  := 1; // visible!
        Width := CBX_BUTTON_WIDTH;
        Height := CBX_BUTTON_HEIGHT;
        Top := 0;
        Parent := FPanel;
        end;
    end;

FButtons[CBX_BUTTON_EDIT].Glyph.Assign ( FBmpEdit );
FButtons[CBX_BUTTON_NEW].Glyph.Assign ( FBmpNew );
FButtons[CBX_BUTTON_DEL].Glyph.Assign ( FBmpDel );
FButtons[CBX_BUTTON_UP].Glyph.Assign ( FBmpUp );
FButtons[CBX_BUTTON_DOWN].Glyph.Assign ( FBmpDown );
FButtons[CBX_BUTTON_PINS].Glyph.Assign ( FBmpPins );

FButtons[CBX_BUTTON_PINS].NumGlyphs := 4;
FButtons[CBX_BUTTON_PINS].AllowAllUp := TRUE;  // to allow up and down!
FButtons[CBX_BUTTON_PINS].GroupIndex := 1000;

FButtons[CBX_BUTTON_EDIT].OnClick := ItemEditEvent;
FButtons[CBX_BUTTON_NEW].OnClick := ItemNewEvent;
FButtons[CBX_BUTTON_DEL].OnClick := ItemDeleteEvent;
FButtons[CBX_BUTTON_UP].OnClick := ItemUpEvent;
FButtons[CBX_BUTTON_DOWN].OnClick := ItemDownEvent;
FButtons[CBX_BUTTON_PINS].OnClick := PinChangedEvent;

FListBoxWindowProc   := FListBox.WindowProc;
FListBox.WindowProc  := ListBoxWindowProcHook;

FTimer := TTimer.Create ( Self );
FTimer.Enabled := FALSE;
FTimer.Interval := CBX_TIMER_MAX;
FTimer.OnTimer  := TimerEvent;

FCurrInplaceEdit := NIL;
FInplaceEditVisibled := FALSE;
FInplaceEdit := TCBXInplaceEdit.Create ( Self );
FInplaceEdit.Visible := FALSE;
FInplaceEdit.Parent := FListBox;

FOnEditItem := NIL;
FOnModifiedItem := NIL;
FOnNewItem := NIL;
FOnDeleteItem := NIL;
FOnMoveUpItem := NIL;
FOnMoveDownItem := NIL;

FDrawItemEvent := NIL;
FMeasureItemEvent := NIL;

// ------- Edit -----------
BorderStyle := bsNone;
Width := 145;
Height := 21;
end;


destructor TCustomComboBoxX.Destroy;
var
    acounter: integer;
begin
// -------- Edit ----------
FEditCanvas.Free;
// -------- ComboBox ---------
for acounter := 1 to CBX_BUTTON_MAX do
    FButtons[acounter-1].Free;

FPanel.Free;
FInplaceEdit.Free;
FForm.Free;
FTimer.Free;

inherited;
end;


{
date: 26 may 2001
descriptions: unnecessary input characters when user pressed
              enter key in editbox bug
note: ES_MULTILINE style will accept #10 and #13 as input characters

// -------- Edit ----------
procedure TCustomComboBoxX.CreateParams(var Params: TCreateParams);
begin
inherited CreateParams(Params);
Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;
}

// -------- Edit ----------
function TCustomComboBoxX.GetClientRect: TRect;
begin
if (  FStyle <> csDropDown ) then begin
    GetWindowRect ( Handle, Result );
    OffsetRect ( Result, -Result.Left, -Result.Top );
    InflateRect ( Result, -CBX_BORDER_WIDTH, -CBX_BORDER_WIDTH );
    dec ( Result.Right, GetSystemMetrics ( SM_CXVSCROLL ) );
    end
else
    result := inherited GetClientRect;
end;


// -------- Edit ----------
function TCustomComboBoxX.GetDeviceContext ( var WindowHandle: HWnd ): HDC;
begin
  if ( csDesigning in ComponentState ) then
     Result := GetDCEx ( Handle, 0, DCX_CACHE or DCX_CLIPSIBLINGS or DCX_WINDOW )
  else
     Result := GetWindowDC ( Handle );

  if ( Result = 0 ) then
    raise EOutOfResources.Create ( 'TCustomComboBoxX.GetDeviceContext: Out of resource' );

  WindowHandle := Handle;
end;


// -------- Edit ----------
procedure TCustomComboBoxX.WMNCCalcSize (var Message: TWMNCCalcSize);
var
    aWidth: integer;
    aButtonWidth: integer;
begin
inherited;
aButtonWidth := GetSystemMetrics(SM_CXVSCROLL);

// we cannot call GetWindowRect since the return value is obsoleted
with ( Message.CalcSize_Params^ ) do begin
      aWidth := rgrc[0].Right - rgrc[0].Left;
      SetRect ( FButtonRect, aWidth - aButtonWidth - 2, 2,
                             aWidth-2, rgrc[0].Bottom - rgrc[0].Top - 2 );

      if ( FStyle = csDropDown ) then begin
          InflateRect ( rgrc[0], -2, -2);
          inc ( rgrc[0].Top );
          inc ( rgrc[0].Left );
          dec ( rgrc[0].Right, aButtonWidth );
          end
      else
          SetRect ( rgrc[0],0,0,0,0 );
      end; // with
end;


// -------- Edit ----------
procedure TCustomComboBoxX.WMNCHitTest ( var Message: TWMNCHitTest );
begin
inherited;

if ( Message.Result = HTNOWHERE ) then
   Message.Result := HTBORDER;
end;


// -------- Edit ----------
procedure TCustomComboBoxX.WMNCLButtonDown ( var Message: TWMNCLButtonDown );
var
    aPoint: TPoint;
    aRect: TRect;
    aMouseIn: boolean;
    aMessage: TMsg;
begin
GetWindowRect ( Handle, aRect );
aPoint := Point ( Message.XCursor-aRect.Left, Message.YCursor-aRect.Top );
if ( PtInRect ( FButtonRect, aPoint ) ) then begin
    SetCapture ( Handle );

    // display the ListBox
    DropDown;

    FEditMouseDown := TRUE;
    FEditMouseIn   := TRUE;
    NCDrawButton;

    try
        while ( GetCapture = Handle ) do begin
          case ( Integer ( GetMessage ( aMessage, 0, 0, 0 ) ) ) of
              -1: break; // failed
               0: begin
                  PostQuitMessage ( aMessage.WParam ); // WM_QUIT
                  break;
                  end;
              end; // case

          case ( aMessage.Message ) of
              WM_KEYDOWN, WM_KEYUP,
              WM_MBUTTONDOWN, WM_MBUTTONUP, WM_MBUTTONDBLCLK,
              WM_RBUTTONDOWN, WM_RBUTTONUP, WM_RBUTTONDBLCLK:
                  begin
                  // do nothing
                  end;
              WM_LBUTTONDOWN, WM_LBUTTONDBLCLK:
                  break; // something wrong already happen...?

              WM_MOUSEMOVE: begin
                  GetCursorPos ( aPoint );
                  Dec ( aPoint.x, aRect.Left );
                  Dec ( aPoint.y, aRect.Top);

                  aMouseIn := PtInRect ( FButtonRect, aPoint );
                  if ( aMouseIn <> FEditMouseIn ) then begin
                      FEditMouseIn := aMouseIn;
                      NCDrawButton;
                      end;
                  end;
              WM_LBUTTONUP: begin
                  FEditMouseDown := FALSE;
                  NCDrawButton;
                  Break;
                end;

              else begin
                    TranslateMessage ( aMessage );
                    DispatchMessage ( aMessage );
                    end;
              end; // case
          end; // while

    finally
        FEditMouseDown := FALSE;
        FEditMouseIn   := FALSE;
        NCDrawButton;

        if ( GetCapture = Handle ) then
           ReleaseCapture;
        end; // finally

    end // if ( PtInRect ...
else begin
    if ( FStyle <> csDropDown ) and ( PtInRect ( GetEditRect, aPoint ) ) then
        DropDown;
    end;

inherited;
end;

// --------- ComboBox --------
procedure TCustomComboBoxX.Notification ( AComponent: TComponent; Operation: TOperation );
begin
inherited;
if ( Operation = opRemove ) then begin
    if ( ( AComponent <> NIL ) and ( AComponent = FCurrInplaceEdit ) ) then begin
        FCurrInplaceEdit := NIL;
        FInplaceEditVisibled := FALSE;
        end;
    end;
end;

// --------- Edit ------------
procedure TCustomComboBoxX.DropDown;
var
    aCanDropDown: boolean;
begin
aCanDropDown := TRUE;
if ( Assigned ( FOnDropDown ) ) then
    FOnDropDown ( Self, aCanDropDown );
if ( not aCanDropDown ) then exit;

SetFocus;
// Move caret to the end of the text
SendMessage ( Handle, EM_SETSEL, Length(Text), Length(Text) );

if ( FPinDown ) then begin
    FAutoSelect := FALSE;
    FButtons[CBX_BUTTON_PINS].Down := TRUE;
    end
else begin
     FAutoSelect := not MultiSelect;
     FButtons[CBX_BUTTON_PINS].Down := FALSE;
     end;

InitItemList;
//SetEditText;

UpdateButtonsStatus;
InitPopupWindow;
LocateButtons;

FForm.Color := Color;
FListBox.Color := Color;
FListBox.Font := Font;
FListBox.Visible := TRUE;

FForm.Show;
FPanel.SetFocus;
end;



// -------- Edit ----------
procedure TCustomComboBoxX.DropUp;
begin
FVisibleLines := -1;
InplaceEditClose;
FForm.Close;

if ( not FAutoSelect ) and ( FStyle in [csDropDown,csDropDownList] ) then
    SetEditText ( TRUE )
else
    InitItemList;

if ( Assigned ( FOnDropUp ) ) then
   FOnDropUp ( Self );
end;


// -------- Edit ----------
procedure TCustomComboBoxX.WMSize(var Message: TWMSize);
var
    MinHeight: Integer;
begin
inherited;

MinHeight := GetMinHeight;
if Height < MinHeight then
   Height := MinHeight;
end;


// -------- Edit ----------
function TCustomComboBoxX.GetMinHeight: Integer;
var
    DC: HDC;
    SaveFont: HFont;
    I: Integer;
    SysMetrics, Metrics: TTextMetric;
begin
if ( FStyle in [csOwnerDrawFixed, csOwnerDrawVariable] ) then
    result := FListBox.ItemHeight + CBX_BORDER_WIDTH*2
else  begin
      DC := GetDC(0);
      GetTextMetrics(DC, SysMetrics);
      SaveFont := SelectObject(DC, Font.Handle);
      GetTextMetrics(DC, Metrics);
      SelectObject(DC, SaveFont);
      ReleaseDC(0, DC);
      I := SysMetrics.tmHeight;
      if I > Metrics.tmHeight then I := Metrics.tmHeight;
      Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
      if ( Font.Size < 10 ) then inc ( Result );
      end;
end;


// -------- Edit ----------
function TCustomComboBoxX.GetEditRect: TRect;
var
    aRect: TRect;
begin
GetWindowRect ( Handle, aRect );
OffsetRect ( aRect, -aRect.Left, -aRect.Top );
InflateRect ( aRect, -2, -2 );
dec ( aRect.Right, GetSystemMetrics ( SM_CXVSCROLL ) );
result := aRect;
end;


// -------- Edit ----------
procedure TCustomComboBoxX.NCDrawFrame;
var
    aRect: TRect;
begin
SetRect ( aRect, 0, 0, FButtonRect.Right+2, FButtonRect.Bottom+2 );
DrawEdge ( FEditCanvas.Handle, aRect, EDGE_SUNKEN, BF_RECT );
end;


// -------- Edit ----------
procedure TCustomComboBoxX.NCDrawButton;
const
    FButtonState: array [boolean] of longint = ( DFCS_SCROLLCOMBOBOX,
                        DFCS_SCROLLCOMBOBOX + DFCS_PUSHED + DFCS_FLAT );
    FButtonEnable: array [boolean] of longint = ( DFCS_INACTIVE, 0 );
begin
DrawFrameControl ( FEditCanvas.Handle, FButtonRect, DFC_SCROLL,
                   FButtonState[(FEditMouseIn) and (FEditMouseDown)] or
                   FButtonEnable[Enabled] );
end;


// -------- Edit ----------
procedure TCustomComboBoxX.WMNCPaint ( var Message: TWMNCPaint );
begin
try
    // draw frame button
    NCDrawFrame;
    // draw button
    NCDrawButton;

    // draw the upper edit window frame (only one line please)
    if ( FStyle = csDropDown ) then begin
       FEditCanvas.Pen.Color := Color;
       FEditCanvas.MoveTo ( FButtonRect.Left, 2 );
       FEditCanvas.LineTo ( 2, 2 );
       FEditCanvas.LineTo ( 2, FButtonRect.Bottom );
       end;

    Message.Result := 0;
finally
    // since our client rect size is empty, Windows
    // will never post us a WM_PAINT;
    if ( FStyle <> csDropDown ) then
        PostMessage ( Handle, WM_PAINT, 0, 0 );
    end; // finally
end;


// -------- Edit ----------
procedure TCustomComboBoxX.DrawEditWindow;
var
    aRect: TRect;
begin
case ( FStyle ) of
    csDropDown: begin {do nothing...let the edit control do the rest} end;
    csDropDownList:
         begin
         aRect := ClientRect;
         FEditCanvas.Font := Font;
         FEditCanvas.Font.Color := clRed; // do not remove this!!!

         if ( Focused ) then begin
            FEditCanvas.Pen.Style := psSolid;
            FEditCanvas.Brush.Style := bsSolid;
            FEditCanvas.Brush.Color := clHighlight;
            FEditCanvas.Pen.Color   := Color;
            FEditCanvas.Rectangle ( aRect );
            InflateRect ( aRect, -1, -1 );
            // set brush to white color before calling the DrawFocusRect
            FEditCanvas.Brush.Color   := clWhite;
            FEditCanvas.DrawFocusRect ( aRect );
            FEditCanvas.Font.Color := clHighlightText;
            end
         else begin
              FEditCanvas.Brush.Color := Color;
              if ( Enabled ) then
                   FEditCanvas.Font.Color := Font.Color
              else
                 FEditCanvas.Font.Color := clGrayText;

              FEditCanvas.FillRect ( aRect );
              InflateRect ( aRect, -1, -1 );
              end; // else

         FEditCanvas.Brush.Style := bsClear;
         FEditCanvas.TextRect ( aRect, CBX_BORDER_WIDTH+1, CBX_BORDER_WIDTH+1, Text );
         end;
    else begin
         SendMessage ( Handle, EM_SETSEL, -1, -1 );

         if ( Assigned ( FDrawItemEvent ) ) then begin
            FDrawListBox := FALSE;
            if ( Focused ) and ( not DroppedDown ) then
                FDrawItemEvent ( Self, FListBox.ItemIndex, ClientRect, [odComboBoxEdit, odFocused] )
            else
                FDrawItemEvent ( Self, FListBox.ItemIndex, ClientRect, [odComboBoxEdit] );
            end; // if
         if ( csDesigning in ComponentState ) then begin
            FEditCanvas.Brush.Color := Color;
            FEditCanvas.FillRect ( ClientRect );
            end; // if
         end; // else
    end; // case
end;


// -------- Edit ----------
procedure TCustomComboBoxX.WMPaint ( var Message: TWMPaint );
var
    aDC: HDC;
begin
// if FStyle <> csDropDown then the inherited function draw nothing!
inherited;

aDC := FEditCanvas.Handle;
try
    if ( Message.DC <> 0 ) then
        FEditCanvas.Handle := Message.DC;

    if ( FStyle <> csDropDown ) then
        DrawEditWindow;
finally
    if ( Message.DC <> 0 ) then
        FEditCanvas.Handle := aDC;
    end;
end;


// -------- Edit ----------
procedure TCustomComboBoxX.CMColorChanged ( var Message: TMessage );
begin
SendMessage ( Handle, WM_NCPAINT, 0, 0 );
inherited;
end;


// -------- Edit ----------
procedure TCustomComboBoxX.CMEnabledChanged ( var Message: TMessage );
begin
inherited;
if ( not Enabled ) then
    DropUp;
FListBox.Font := Font;
SendMessage ( Handle, WM_NCPAINT, 0, 0 );
end;

// -------- Edit ----------
procedure TCustomComboBoxX.CMFontChanged (var Message: TMessage );
var
    aMinHeight: integer;
begin
inherited;

if ( FStyle in [csDropDown, csDropDownList] ) then begin
    aMinHeight := GetMinHeight;
    if ( Height < aMinHeight ) then
        Height := aMinHeight;

    FListBox.ItemHeight := aMinHeight - CBX_BORDER_WIDTH - 4;
    end;

Invalidate;

if ( DroppedDown ) then begin
    FListBox.Font := Font;
    FListBox.Invalidate;
    end;
end;

// -------- Edit ----------
procedure TCustomComboBoxX.WMSetFocus ( var Message: TMessage );
begin
inherited;
DrawEditWindow;
end;

// -------- Edit ----------
procedure TCustomComboBoxX.WMKillFocus ( var Message: TMessage );
begin
inherited;
DrawEditWindow;
end;

// -------- Edit ----------
procedure TCustomComboBoxX.SetEditText ( aClosed: boolean );
var
    aStrings: TStringList;
    aCounter, aCount: integer;
begin
if ( FListBox.MultiSelect ) then begin
    if ( Style = csDropDownList ) or ( not aClosed ) then begin
        if ( FListBox.SelCount > 0 ) then begin
            aStrings := TStringList.Create;
            try
                aCount := FListBox.SelCount;
                aCounter := 0;
                while ( aCount > 0 ) do begin
                    if ( FListBox.Selected[aCounter] ) then begin
                        aStrings.Add ( FListBox.Items[aCounter] );
                        dec ( aCount );
                        end; // if
                    inc ( aCounter );
                    end; // while

                Text := aStrings.CommaText;
            finally
                aStrings.Free;
                end; // finally
            end // if
        else
            Text := '';
        end; // if style = csDropDownList
    end
else begin
    {
    date: 28 may 2001
    description: dropdown text changed after list box is closed (solved)
    }
    if ( Style = csDropDownList ) or ( not aClosed ) then begin
        if ( FListBox.ItemIndex > -1 ) then
            Text := FListBox.Items[FListBox.ItemIndex]
        else
            Text := '';
        end; // if
    end;

DrawEditWindow;
end;


{
date: 26 may 2001.
description: the paint code is moved into this function so that the descendant can
            paint the popup window
}
// -------- ComboBox ----------
procedure TCustomComboBoxX.PopupFormPaint;
var
    Y: integer;
begin
with FForm.Canvas do begin
    Pen.Style := psSolid;
    Brush.Style := bsClear;

    Pen.Color := clWindowFrame;
    Rectangle ( FForm.ClientRect );

    if ( FPanel.Height > 0 ) then begin
        Pen.Color := clBtnHighlight;
        Y := FListBox.Top + FListBox.Height;
        MoveTo ( FFormFrameWidth, Y );
        LineTo ( FForm.ClientWidth - FFormFrameWidth - 1, Y );

        Pen.Color := clBtnShadow;
        LineTo ( FForm.ClientWidth - FFormFrameWidth - 1, FForm.ClientHeight - FFormFrameWidth );
        end; // if
    end; // with
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.FormWindowProcHook (var Message: TMessage);
begin
case ( Message.Msg ) of
    WM_PAINT: begin
        PopupFormPaint;
        {
        date: 26 may 2001.
        description: the paint code is moved into PopupFormPaint virtual function

        with FForm.Canvas do begin
            Pen.Style := psSolid;
            Brush.Style := bsClear;

            Pen.Color := clWindowFrame;
            Rectangle ( FForm.ClientRect );

            if ( FPanel.Height > 0 ) then begin
                Pen.Color := clBtnHighlight;
                Y := FListBox.Top + FListBox.Height;
                MoveTo ( 1, Y );
                LineTo ( FForm.ClientWidth - 2, Y );

                Pen.Color := clBtnShadow;
                LineTo ( FForm.ClientWidth - 2, FForm.ClientHeight - 1 );
                end; // if
            end; // with
        }
        Message.Result := 0;
        end;
    WM_MOUSEACTIVATE: begin
        Message.Result := MA_NOACTIVATE;
        SetWindowPos ( FForm.Handle, HWND_TOP, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

        if ( GetActiveWindow <> FForm.Handle ) then
            SetActiveWindow ( Parent.Handle );

        exit;
        end;
    WM_ACTIVATE: begin
        if ( (Parent.Handle = GetActiveWindow) <> boolean(TWMActivate(Message).Active) ) then
            SendMessage ( Parent.Handle, WM_NCACTIVATE, TWMActivate(Message).Active, 0 );

        if ( TWMActivate(Message).Active = WA_INACTIVE ) and ( FWMActivateEnabled ) then
            DropUp;
        end;

    end; // case

FFormWindowProc ( Message );
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.FormKeyPressHook (Sender: TObject; var Key: Char);
var
    temp: string;
begin
if ( FInplaceEditVisibled ) then
    exit;

if ( key in [#13, #27] ) then begin
    Dropup;
    exit;
    end;

if ( FStyle in [csDropDown, csDropDownlist] ) then begin
    temp := Text;
    SendMessage ( Handle, WM_CHAR, Integer(Key), 0 );
    if ( temp <> Text ) then
        InitItemList;
    if ( FStyle = csDropDownlist ) then
        SetEditText ( FALSE );
    end;
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.ListBoxWindowProcHook (var Message: TMessage);
begin
if ( Message.Msg = CM_MOUSEENTER ) then begin
    FMouseIn := TRUE;
    end
else
if ( Message.Msg = CM_MOUSELEAVE ) then begin
    FMouseIn := FALSE;

    if ( not FMouseDown ) then begin
        FTimer.Enabled := FALSE;
        FTimer.Interval := CBX_TIMER_MAX;
        end;
    end;

FListBoxWindowProc ( Message );
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.ListBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if ( not FForm.Visible ) then exit;

FPanel.SetFocus;
FMouseDown := TRUE;
Windows.SetCapture ( FListBox.Handle );

FDownIndex := FListBox.ItemAtPos ( Point ( X, Y ), TRUE );

if ( FDragEnable ) then begin
    if ( X >= 0 ) and ( X <= FListBox.ClientWidth ) then begin
        if ( Y < CBX_SCROLL_RANGE ) then begin
            FScrollUp := TRUE;
            FTimer.Enabled := TRUE;
            end
        else
        if ( Y > FListBox.Height - CBX_SCROLL_RANGE ) then begin
            FScrollUp := FALSE;
            FTimer.Enabled := TRUE;
            end
        else begin
            FTimer.Enabled  := FALSE;
            FTimer.Interval := CBX_TIMER_MAX;
            end;
        end; // if
    end;

SetEditText ( FALSE );
UpdateButtonsStatus;
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.ListBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
    aIndex: integer;
    aTopIndex: integer;
begin
FMouseDown := FALSE;
Windows.SetCapture ( 0 );
InplaceEditClose;

if ( FTimer.Enabled ) then begin
    FTimer.Enabled := FALSE;
    FTimer.Interval := CBX_TIMER_MAX;
    end;

// clean up the dirty line
if  ( FDragEnable) and ( FDirty ) then begin
    DirtyLine ( FALSE );
    DrawDirtyLine ( -1 );
    end;

if ( FDragEnable ) and ( FDownIndex > -1 ) then begin
    aIndex := FListBox.ItemAtPos ( Point ( X, Y ), TRUE );
    if ( aIndex > -1 ) and ( aIndex <> FDownIndex ) then begin
        aTopIndex := FListBox.TopIndex;
        FListBox.Items.Move ( FDownIndex, aIndex );
        FListBox.TopIndex := aTopIndex;

        if ( not FAutoSelect ) then
           FListBox.ItemIndex := aIndex;

        exit;
        end;
    end;

if ( not MultiSelect ) and ( not FPinDown ) then
    DropUp;
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.ListBoxDblClick(Sender: TObject);
begin
if ( FPinDown ) or ( MultiSelect ) then
    DropUp;
end;

// -------- ComboBox ----------
procedure TCustomComboBoxX.ListBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
    aIndex: integer;
begin
aIndex := FListBox.ItemAtPos ( Point ( X, Y ), TRUE );

if ( not FMouseDown ) and ( FAutoSelect ) then begin
  if ( aIndex > -1 ) then
     FListBox.ItemIndex := aIndex;
  end;

// draw the dirty line
if ( FDragEnable ) and ( FMouseDown ) then begin
    if ( aIndex <> FDownIndex ) then begin
        // aIndex can be negatif one if drag outside the clientrect
        if ( aIndex < 0 ) then begin
            if ( X >= 0 ) and ( X <= FListBox.ClientWidth ) then begin
                if ( FScrollUp ) then
                    aIndex := FListBox.TopIndex
                else
                    aIndex := min ( FListBox.Items.Count,
                                    FListBox.TopIndex + FDropDownCount ) - 1;
                end;
            end;

        DirtyLine ( TRUE );
        DrawDirtyLine ( aIndex );
        end
    else begin
         DirtyLine ( FALSE );
         DrawDirtyLine ( -1 );
         end;
    end; // if

if ( not FMouseDown ) and ( FAutoSelect ) then
    UpdateButtonsStatus;

if ( ( FAutoScroll ) and ( FMouseIn ) and ( not FMouseDown ) )
    or ( ( FMouseDown ) and ( FDragEnable ) ) then begin

    if ( X >= 0 ) and ( X <= FListBox.ClientWidth ) then begin
        if ( Y < CBX_SCROLL_RANGE ) then begin
            FScrollUp := TRUE;
            FTimer.Enabled := TRUE;
            end
        else
        if ( Y > FListBox.Height - CBX_SCROLL_RANGE ) then begin
            FScrollUp := FALSE;
            FTimer.Enabled := TRUE;
            end
        else begin
            FTimer.Enabled  := FALSE;
            FTimer.Interval := CBX_TIMER_MAX;
            end;
        end;
    end;  // if
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.ListBoxDrawItem ( Control: TWinControl; Index: Integer;
        Rect: TRect; State: TOwnerDrawState );
begin
FDrawListBox := TRUE;
try
    if ( Assigned ( FDrawItemEvent ) ) then
       FDrawItemEvent ( Self, Index, Rect, State );
finally
    FDrawListBox := FALSE;
    end;
end;

// -------- ComboBox ----------
procedure TCustomComboBoxX.ListBoxMeasureItem ( Control: TWinControl; Index: Integer;
        var Height: Integer );
begin
if ( Assigned ( FMeasureItemEvent ) ) then
    FMeasureItemEvent ( Self, Index, Height );
end;

// -------- ComboBox ----------
procedure TCustomComboBoxX.TimerEvent ( Sender: TObject );
var
    aIndex: Integer;
    aCurrPos: Integer;
    aPoint: TPoint;
begin
Windows.GetCursorPos ( aPoint );
aPoint := FListBox.ScreenToClient ( aPoint );
if ( aPoint.X < 0 ) or ( aPoint.X > FListBox.ClientWidth ) then begin
    FTimer.Enabled := FALSE;
    exit;
    end;

FDirty := FALSE;
DrawDirtyLine ( -1 );

if ( FTimer.Interval > CBX_TIMER_MIN ) then
    FTimer.Interval := FTimer.Interval - CBX_TIMER_DEC;

aCurrPos := GetScrollPos ( FListBox.Handle, SB_VERT );
if ( FScrollUp ) then begin
    SendMessage ( FListBox.Handle, WM_VSCROLL, MAKELONG(SB_LINEUP,0), 0 );
    SendMessage ( FListBox.Handle, WM_VSCROLL, MAKELONG(SB_ENDSCROLL,0), 0 );
    end
else begin
     SendMessage ( FListBox.Handle, WM_VSCROLL, MAKELONG(SB_LINEDOWN,0), 0 );
     SendMessage ( FListBox.Handle, WM_VSCROLL, MAKELONG(SB_ENDSCROLL,0), 0 );
     end;

aIndex := FListBox.ItemAtPos( aPoint, true);

if ( aCurrPos <> GetScrollPos ( FListBox.Handle, SB_VERT ) ) then begin
    if ( not FMouseDown ) and ( FAutoSelect ) then begin
        if ( aIndex >= 0 ) then
           FListBox.ItemIndex := aIndex;
        end;
    end
else begin
     FTimer.Enabled := FALSE;
     FTimer.Interval := CBX_TIMER_MAX;
     end;

if ( FPrevDirty ) then begin
    FDirty := TRUE;
    if ( aIndex < 0 ) then begin
        if ( FScrollUp ) then
            aIndex := FListBox.TopIndex
        else
            aIndex := min ( FListBox.Items.Count,
                            FListBox.TopIndex + FDropDownCount ) - 1;
        end;
    DrawDirtyLine ( aIndex );
    end;
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.DirtyLine ( Dirty: boolean );
begin
FDirty     := Dirty;
FPrevDirty := Dirty;
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.DrawDirtyLine ( aIndex: integer );
var
    aRect: TRect;
begin
if ( aIndex = FDirtyIndex ) then exit;

with ( FListBox.Canvas ) do begin
    Pen.Mode  := pmXor;
    Pen.Color := clGray;
    Pen.Width := CBX_LINE_WIDTH;

    // remove the previous dirty line
    if ( FDirtyIndex > -1 ) then begin
        aRect := FListBox.ItemRect ( FDirtyIndex );
        if ( FDownIndex > FDirtyIndex ) then begin
            MoveTo ( 0, aRect.Top + (CBX_LINE_WIDTH shr 1) );
            LineTo ( FListBox.ClientWidth, aRect.Top + (CBX_LINE_WIDTH shr 1) );
            end
        else begin
             MoveTo ( 0, aRect.Bottom - (CBX_LINE_WIDTH shr 1) );
             LineTo ( FListBox.ClientWidth, aRect.Bottom - (CBX_LINE_WIDTH shr 1) );
             end;
        end;

    FDirtyIndex := aIndex;

    if ( FDirtyIndex > -1 ) then begin
        aRect := FListBox.ItemRect ( FDirtyIndex );
        if ( FDownIndex > FDirtyIndex ) then begin
            MoveTo ( 0, aRect.Top + (CBX_LINE_WIDTH shr 1) );
            LineTo ( FListBox.ClientWidth, aRect.Top + (CBX_LINE_WIDTH shr 1) );
            end
        else begin
             MoveTo ( 0, aRect.Bottom - (CBX_LINE_WIDTH shr 1) );
             LineTo ( FListBox.ClientWidth, aRect.Bottom - (CBX_LINE_WIDTH shr 1) );
             end;
        end; // if

    end; // with ListBox.Canvas
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.InitPopupWindow;
var
    aPoint: TPoint;
    aLines: integer;
    aWidth: integer;
    aMinHeight: integer;
    aButtonsWidth: integer;
begin
aLines := Min ( FListBox.Items.Count, Max ( FDropDownCount, 1 ) );
if ( FVisibleLines = aLines ) then exit;
FVisibleLines := aLines;

if ( FPopupListWidth = 0 ) then
    aWidth := Width
else
    aWidth := FPopupListWidth;

aButtonsWidth := GetTotalButtonWidth;
// fit in all the buttons into the panel
if ( aButtonsWidth > 0 ) then
    aWidth := Max ( aWidth, aButtonsWidth + 2 + CBX_PANEL_OFFSET );

if ( FStyle in [csDropDown, csDropDownList] ) then begin
    aMinHeight := GetMinHeight;
    FListBox.ItemHeight := aMinHeight - CBX_BORDER_WIDTH*2 - 4;
    end;
FListBox.Height := aLines*FListBox.ItemHeight;
FListBox.Width := aWidth - FFormFrameWidth*2;
FListBox.Left := FFormFrameWidth;
FListBox.Top  := FFormFrameWidth;

if ( aButtonsWidth > 0 ) then begin
    FPanel.Width  := aWidth - FFormFrameWidth*2 - CBX_PANEL_OFFSET;
    FPanel.Height := 13;
    FPanel.Left   := FFormFrameWidth;
    FPanel.Top    := FListBox.Top + FListBox.Height + 1;
    end
else
    FPanel.Height := 0;

FForm.Width := aWidth;
if ( aButtonsWidth > 0 ) then
    FForm.Height  := FFormFrameWidth + FListBox.Height + 1 + FPanel.Height + FFormFrameWidth
else
    FForm.Height  := FFormFrameWidth + FListBox.Height + FFormFrameWidth;

aPoint := Point ( Left, Top + Height );
aPoint := Parent.ClientToScreen ( aPoint );

if ( aPoint.x + FForm.Width < Screen.Width ) then
    FForm.Left := aPoint.x
else
    FForm.Left := aPoint.x + Width - FForm.Width;

if ( aPoint.y + FForm.Height > Screen.Height ) then
    FForm.Top  := aPoint.y - Height - FForm.Height
else
    FForm.Top  := aPoint.y;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.InitItemList;
var
    aStrings: TStringList;
    aCount, aCounter: integer;
    aIndex: integer;
begin
aCount := FListBox.Items.Count - 1;

if ( FListBox.MultiSelect ) then begin
    aStrings := TStringList.Create;
    try
        aStrings.CommaText := Trim ( Text );
        for aCounter := aCount downto 0 do begin
            aIndex := aStrings.IndexOf ( FListBox.Items[aCounter] );
            if ( aIndex > -1 ) then begin
                FListBox.Selected[aCounter] := TRUE;
                aStrings.Delete ( aIndex );
                end
            else
                FListBox.Selected[aCounter] := FALSE;
            end; // for
    finally
        aStrings.Free;
        end; // finally  EM_SELECTALL

    if ( FListBox.SelCount <= 0 ) then begin
        for aCounter := 0 to aCount do begin
            if ( Pos ( Text, FListBox.Items[aCounter] ) = 1 ) then begin
                FListBox.Selected[aCounter] := TRUE;
                break;
                end;
            end; // for
        end;
    end
else begin
    aIndex := FListBox.Items.IndexOf ( Trim ( Text ) );
    FListBox.ItemIndex := aIndex;
    if ( FListBox.ItemIndex = -1 ) then begin
        for aCounter := 0 to aCount do begin
            if ( Pos ( FListBox.Items[aCounter], Text ) = 1 ) then begin
            {
            date: 26 may 2001.
            description: popdown list selection using keyboard bug
            note: function Pos(Substr: string; S: string): Integer;
            if ( Pos ( Text, FListBox.Items[aCounter] ) = 1 ) then begin
            }
                FListBox.ItemIndex := aCounter;
                break;
                end;
            end; // for
        end; // if

    {
    date: 26 may 2001.
    description: enhancement on csDropdown mode
    note 1: item will be highlighted if one of items is subset to the Text property
    note 2: function Pos(Substr: string; S: string): Integer;
    }
    if ( Style = csDropDown ) then begin
        if ( FListBox.ItemIndex = -1 ) then begin
            for aCounter := 0 to aCount do begin
                if ( Pos ( Text, FListBox.Items[aCounter] ) = 1 ) then begin
                    FListBox.ItemIndex := aCounter;
                    break;
                    end;
                end; // for
            end; // if
        end; // if

    end; // else
end;


// ---------- ComboBox ------------
function  TCustomComboBoxX.GetTotalButtonWidth: integer;
var
    acounter: integer;
begin
result := 0;

for acounter := (CBX_BUTTON_MAX-1) downto 0 do begin
    if ( FButtons[acounter].Tag = 1 ) then
        inc ( result, CBX_BUTTON_WIDTH );
    end; // for

if ( FButtons[CBX_BUTTON_EDIT].Tag = 1 ) then
    inc ( result, CBX_BUTTON_OFFSET );

if ( FButtons[CBX_BUTTON_PINS].Tag = 1 ) then
    inc ( result, CBX_BUTTON_OFFSET );
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.LocateButtons;
var
    acor, acounter: integer;
begin
if ( FPinDown ) then begin
    acor := FPanel.ClientWidth - CBX_BUTTON_WIDTH;

    for acounter := (CBX_BUTTON_MAX-1) downto 1 do begin
        if ( FButtons[acounter].Tag = 1 ) then begin
            FButtons[acounter].Visible := TRUE;
            FButtons[acounter].Left := acor;
            dec ( acor, CBX_BUTTON_WIDTH );
            if ( acounter = CBX_BUTTON_PINS ) then
                dec ( acor, CBX_BUTTON_OFFSET );
            end
        else
            FButtons[acounter].Visible := FALSE;
        end; // for

    FButtons[CBX_BUTTON_EDIT].Visible := ( FButtons[CBX_BUTTON_EDIT].Tag = 1 );
    FButtons[CBX_BUTTON_EDIT].Left := CBX_BUTTON_OFFSET;
end // if
else begin
     for acounter := 0 to (CBX_BUTTON_MAX-1) do
         FButtons[acounter].Visible := FALSE;

     if ( FButtons[CBX_BUTTON_PINS].Tag = 1 ) then
        FButtons[CBX_BUTTON_PINS].Visible := TRUE;

     FButtons[CBX_BUTTON_PINS].Left := FPanel.ClientWidth - CBX_BUTTON_WIDTH;
     end; // else
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.UpdateButtonsStatus;
var
    acount: integer;
begin
if ( FListBox.MultiSelect ) then
    acount := FListBox.SelCount
else begin
    if ( FListBox.ItemIndex > -1 ) then acount := 1
    else acount := 0;
    end;

if ( acount = 0 ) then begin
    FButtons[CBX_BUTTON_EDIT].Enabled := FALSE;
    EnableButtonNew ( TRUE );
    EnableButtonDel ( FALSE );
    FButtons[CBX_BUTTON_DEL].Enabled := FALSE;
    FButtons[CBX_BUTTON_UP].Enabled := FALSE;
    FButtons[CBX_BUTTON_DOWN].Enabled := FALSE;
    end
else
if ( acount = 1 ) then begin
    FButtons[CBX_BUTTON_EDIT].Enabled := TRUE;
    EnableButtonNew ( TRUE );
    EnableButtonDel ( TRUE );
    FButtons[CBX_BUTTON_UP].Enabled := TRUE;
    FButtons[CBX_BUTTON_DOWN].Enabled := TRUE;
    end
else begin // more than one
    FButtons[CBX_BUTTON_EDIT].Enabled := FALSE;
    EnableButtonNew ( TRUE );
    EnableButtonDel ( TRUE );
    FButtons[CBX_BUTTON_UP].Enabled := FALSE;
    FButtons[CBX_BUTTON_DOWN].Enabled := FALSE;
    end;

if ( FButtons[CBX_BUTTON_UP].Enabled ) then begin
    if ( FListBox.ItemIndex = 0 ) then
       FButtons[CBX_BUTTON_UP].Enabled := FALSE;
    end;

if ( FButtons[CBX_BUTTON_DOWN].Enabled ) then begin
    if ( FListBox.ItemIndex = FListBox.Items.Count - 1 ) then
       FButtons[CBX_BUTTON_DOWN].Enabled := FALSE;
    end;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.EnableButtonNew ( Value: boolean );
begin
if ( Value = FButtons[CBX_BUTTON_NEW].Enabled ) then exit;

if ( Value ) then begin
    FButtons[CBX_BUTTON_NEW].Enabled := TRUE;
    FButtons[CBX_BUTTON_NEW].Glyph := FBmpNew;
    end
else begin
    FButtons[CBX_BUTTON_NEW].Enabled := FALSE;
    FButtons[CBX_BUTTON_NEW].Glyph := FBmpNewDis;
    end;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.EnableButtonDel ( Value: boolean );
begin
if ( Value = FButtons[CBX_BUTTON_DEL].Enabled ) then exit;

if ( Value ) then begin
    FButtons[CBX_BUTTON_DEL].Enabled := TRUE;
    FButtons[CBX_BUTTON_DEL].Glyph := FBmpDel;
    end
else begin
    FButtons[CBX_BUTTON_DEL].Enabled := FALSE;
    FButtons[CBX_BUTTON_DEL].Glyph := FBmpDelDis;
    end;
end;

// ---------- ComboBox ------------
procedure TCustomComboBoxX.InplaceEditClose;
begin
if ( FCurrInplaceEdit = NIL ) or ( not FInplaceEditVisibled ) then exit;
FCurrInplaceEdit.Hide;
FCurrInplaceEdit.Close;
FInplaceEditVisibled := FALSE;
end;

// ---------- ComboBox ------------
procedure TCustomComboBoxX.ItemEditEvent ( Sender: TObject );
var
    aCanEdit: boolean;
    aIndex: integer;
    aRect: TRect;
    aText: string;
    aTextObject: TObject;
begin
if ( FInplaceEditVisibled ) then begin
    InplaceEditClose;
    exit;
    end;
    
aIndex:= FListBox.ItemIndex;

aCanEdit := TRUE;
aText := FListBox.Items[aIndex];
aTextObject := FListBox.Items.Objects[aIndex];
FInplaceEdit.Font := Font;
FInplaceEdit.Color := Color;
FCurrInplaceEdit := FInplaceEdit;
if ( Assigned ( FOnEditItem ) ) then
   FOnEditItem ( Self, aText, aTextObject, FCurrInplaceEdit, aCanEdit );
if ( not aCanEdit ) then exit;

aRect := FListBox.ItemRect ( aIndex );
FCurrInplaceEdit.Text := aText;
FCurrInplaceEdit.TextObject := aTextObject;
FCurrInplaceEdit.OnAction := InplaceEditEvent;
FCurrInplaceEdit.BoundsRect := aRect;
FCurrInplaceEdit.Name := 'ABCD';

FInplaceEditVisibled := TRUE;
FCurrInplaceEdit.Open ( self );
FCurrInplaceEdit.Show;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.ItemNewEvent ( Sender: TObject );
var
    aCanAdd: boolean;
    aNewName: string;
    aNewObject: TObject;
    aIndex: integer;
begin
aCanAdd := TRUE;
aNewName := CBX_NEWITEM_CAPTION;
aIndex := 1;
while ( FListBox.Items.IndexOf ( aNewName ) <> -1 ) do begin
    inc ( aIndex );
    aNewName := CBX_NEWITEM_CAPTION + IntToStr ( aIndex );
    end; // while

aNewObject := NIL;
if ( Assigned ( FOnNewItem ) ) then
   FOnNewItem ( Self, aNewName, aNewObject, aCanAdd );
if ( not aCanAdd ) then exit;

InplaceEditClose;
DeselectAll;

FListBox.Items.AddObject ( aNewName, aNewObject );
aIndex := FListBox.Items.IndexOf ( aNewName );  // maybe a sorted list!
FListBox.TopIndex := aIndex;

if ( FListBox.MultiSelect ) then
   FListBox.Selected[aIndex] := TRUE
else
    FListBox.ItemIndex := aIndex;

UpdateButtonsStatus;
InitPopupWindow;
SetEditText ( FALSE );

ItemEditEvent ( Self );
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.ItemDeleteEvent ( Sender: TObject );
var
    aCount, aCounter: integer;
    aCanDelete: boolean;
begin
aCanDelete := TRUE;
if ( Assigned ( FOnDeleteItem ) ) then
   FOnDeleteItem ( Self, aCanDelete );
if ( not aCanDelete ) then exit;

InplaceEditClose;

aCount := FListBox.Items.Count-1;
for acounter := aCount downto 0 do begin
    if ( FListBox.Selected[acounter] ) then
         FListBox.Items.Delete ( acounter );
    end; // for

UpdateButtonsStatus;
InitPopupWindow;
SetEditText ( FALSE );

if ( FListBox.Items.Count > 0 ) then begin
    if ( FListBox.TopIndex + FVisibleLines > FListBox.Items.Count ) then
       FListBox.TopIndex := FListBox.Items.Count - FVisibleLines;
    end;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.ItemUpEvent ( Sender: TObject );
var
    aIndex: integer;
    aCanMoveUp: boolean;
begin
aIndex := FListBox.ItemIndex;

aCanMoveUp := TRUE;
if ( Assigned ( FOnMoveUpItem ) ) then
   FOnMoveUpItem ( Self, aCanMoveUp );
if ( not aCanMoveUp ) then exit;

InplaceEditClose;
FListBox.Items.Exchange ( aIndex, aIndex-1 );

if ( FListBox.MultiSelect ) then begin
    FListBox.Selected[aIndex] := FALSE;
    FListBox.Selected[aIndex-1] := TRUE;
    end
else
    FListBox.ItemIndex := aIndex - 1;

UpdateButtonsStatus;
end;



// ---------- ComboBox ------------
procedure TCustomComboBoxX.ItemDownEvent ( Sender: TObject );
var
    aIndex: integer;
    aCanMoveDown: boolean;
begin
aIndex := FListBox.ItemIndex;

aCanMoveDown := TRUE;
if ( Assigned ( FOnMoveDownItem ) ) then
   FOnMoveDownItem ( Self, aCanMoveDown );
if ( not aCanMoveDown ) then exit;

InplaceEditClose;
FListBox.Items.Exchange ( aIndex, aIndex+1 );

if ( FListBox.MultiSelect ) then begin
    FListBox.Selected[aIndex] := FALSE;
    FListBox.Selected[aIndex+1] := TRUE;
    end
else
    FListBox.ItemIndex := aIndex + 1;

UpdateButtonsStatus;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.PinChangedEvent ( Sender: TObject );
begin
FPinDown := FButtons[CBX_BUTTON_PINS].Down;
if ( FPinDown ) then
    FAutoSelect := FALSE
else
    FAutoSelect := not MultiSelect;

LocateButtons;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.SeleteAll;
var
    acounter, acount: integer;
begin
if ( not FListBox.MultiSelect ) then exit;
if ( FListBox.SelCount = FListBox.Items.Count ) then exit;

acount := FListBox.Items.Count - 1;
for acounter := 0 to acount do
    FListBox.Selected[acounter] := TRUE;

Text := FListBox.Items.CommaText;
DrawEditWindow;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.DeselectAll;
var
    acounter, acount: integer;
begin
if ( FListBox.MultiSelect ) then begin
    if ( FListBox.SelCount = 0 ) then exit;

    acount := FListBox.Items.Count - 1;
    for acounter := 0 to acount do
        FListBox.Selected[acounter] := FALSE;
    end
else
    FListBox.ItemIndex := -1;

Text := '';
DrawEditWindow;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.InverseSelection;
begin
if ( not FListBox.MultiSelect ) then exit;
FListBox.Selected[-1] := TRUE;

Text := FListBox.Items.CommaText;
DrawEditWindow;
end;


// ---------- ComboBox ------------
procedure TCustomComboBoxX.InplaceEditEvent ( Sender: TObject; Action: TCBXInplaceEditActionType );
var
    aIndex: integer;
    aCanModify: boolean;
    aText: string;
    aTextObject: TObject;
begin
case ( Action ) of
    ieaAccept: begin
               aIndex := FListBox.ItemIndex;
               if ( aIndex > -1 ) then begin
                  aText := TCBXInplaceEdit(Sender).Text;
                  aTextObject := TCBXInplaceEdit(Sender).TextObject;
                  aCanModify := TRUE;

                  if ( Assigned ( FOnModifiedItem ) ) then
                     FOnModifiedItem ( Self, aText, aTextObject, aCanModify );

                  if ( aCanModify ) then begin
                      FListBox.Items[aIndex] := aText;
                      FListBox.Items.Objects[aIndex] := aTextObject;
                      if ( not FAutoSelect ) then begin
                          Text := aText;
                          if ( not MultiSelect ) then
                             FListBox.ItemIndex := aIndex
                          else
                              FListBox.Selected[aIndex] := TRUE;
                          end;
                      end; // if
                  end; // if

               InplaceEditClose;
               end;
    ieaCancel: begin
               InplaceEditClose;
               end;
    end; // case
end;


// -------- ComboBox ----------
procedure TCustomComboBoxX.SetStyle ( Value: TComboBoxStyle );
var
    aMinHeight: integer;
begin
if ( Value = FStyle ) or ( csSimple = value ) then exit;

FlistBox.OnMeasureItem := NIL;

FStyle := Value;
case ( FStyle ) of
    csDropDown:
        FListBox.Style := lbStandard;
    csDropDownList: begin
        FListBox.Style := lbStandard;
        InitItemList;
        SetEditText ( FALSE );
        end;
    csOwnerDrawFixed:
        FListBox.Style := lbOwnerDrawFixed;
    csOwnerDrawVariable: begin
        FListBox.Style := lbOwnerDrawVariable;
        FlistBox.OnMeasureItem := NIL;
        FlistBox.OnMeasureItem := ListBoxMeasureItem;
        end;
    end; // case

aMinHeight := GetMinHeight;
if ( csDesigning in ComponentState ) then
   Height := aMinHeight
else
if ( Height < aMinHeight ) then Height := aMinHeight;

SetWindowPos ( Handle, 0, 0, 0, 0, 0,
               SWP_FRAMECHANGED or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER );
end;


// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetItems ( Value: TStrings );
begin
FListBox.Items.Assign ( Value );
end;

// ----------- ComboBox -------------
function  TCustomComboBoxX.GetItems: TStrings;
begin
result := FListBox.Items;
end;

// ----------- ComboBox -------------
function  TCustomComboBoxX.GetMultiSelect: boolean;
begin
result := FListBox.MultiSelect;
end;

// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetMultiSelect ( Value: boolean );
begin
if ( FListBox.MultiSelect = Value ) then exit;

FListBox.MultiSelect := Value;
FDragEnable := not Value;   // need to set to FALSE is multiselect or sorted is true
//FAutoSelect := not Value;  // need to set to FALSE is multiselect is true
if ( FPinDown ) then
    FAutoSelect := FALSE
else
    FAutoSelect := not Value;

if ( FStyle <> csDropDown ) then begin
    InitItemList;
    SetEditText ( not Droppeddown );
    end;
end;

// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetItemHeight ( Value: Integer );
var
   aMinHeight: integer;
begin
if ( FListBox.ItemHeight = Value ) then exit;

if ( FStyle in [csOwnerDrawFixed, csOwnerDrawVariable] ) then begin
    FListBox.ItemHeight := Value;
    aMinHeight := GetMinHeight;
    if ( csDesigning in ComponentState ) then
        Height := aMinHeight
    else
    if ( Height < aMinHeight ) then Height := aMinHeight;
    end;
end;

// ----------- ComboBox -------------
function TCustomComboBoxX.GetItemHeight: Integer;
begin
result := FListBox.ItemHeight;
end;

// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetButtons ( Value: TCBXButtons );
var
   acounter: integer;
begin
if ( FCBXButtons = Value ) then exit;
FCBXButtons := Value;
// button's tag set to 1 if the button is visible
for acounter := 0 to CBX_BUTTON_MAX-1 do
    FButtons[acounter].Tag := Ord ( TCBXButton(acounter) in FCBXButtons );

//LocateButtons;
end;


// ----------- ComboBox -------------
function  TCustomComboBoxX.GetDropDown: boolean;
begin
result := FForm.Visible;
end;


// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetDropDown ( Value: boolean );
begin
if ( GetDropDown = Value ) then exit;

if ( Value ) then
    DropDown
else
    DropUp;
end;

// ----------- ComboBox -------------
function TCustomComboBoxX.GetButtonHint: string;
var
    aStrings: TStringList;
    counter: integer;
begin
result := '';
aStrings := TStringList.Create;
try
    for counter := 0 to CBX_BUTTON_MAX-1 do
        aStrings.Add ( FButtons[counter].Hint );

    result := aStrings.CommaText;
finally
    aStrings.Free;
    end;
end;


// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetButtonHint ( const Value: string );
var
    aStrings: TStringList;
    counter: integer;
begin
aStrings := TStringList.Create;
try
    aStrings.CommaText := Value;

    for counter := 0 to CBX_BUTTON_MAX-1 do
        FButtons[counter].Hint := '';

    for counter := 0 to aStrings.Count-1 do
        FButtons[counter].Hint := aStrings[counter];
finally
    aStrings.Free;
    end;
end;

// ----------- ComboBox -------------
function TCustomComboBoxX.GetShowHint: boolean;
begin
result := inherited ShowHint;
end;

// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetShowHint ( Value: boolean );
var
    counter: integer;
begin
if ( Inherited ShowHint = Value ) then exit;

Inherited ShowHint := Value;
for counter := 0 to CBX_BUTTON_MAX-1 do
    FButtons[counter].ShowHint := Value;
end;

// ----------- Edit -------------
function TCustomComboBoxX.GetCanvas: TCanvas;
begin
if ( FDrawListBox ) then
    result := FListBox.Canvas
else begin
     TControlCanvas(FEditCanvas).UpdateTextFlags;
     FEditCanvas.Font := Font;
     FEditCanvas.Brush.Color := Color;
     result := FEditCanvas;
     end;
end;

// ----------- Edit -------------
procedure TCustomComboBoxX.SetBiDiMode ( Value: TBiDiMode );
begin
inherited SetBidiMode ( Value );
FListBox.BiDiMode := Inherited BidiMode;
end;

// ----------- Edit -------------
function  TCustomComboBoxX.GetText: string;
begin
result := Inherited Text;
end;

// ----------- Edit -------------
procedure TCustomComboBoxX.SetText ( const Value: string );
begin
if ( inherited Text = Value ) then exit;

inherited Text := Value;
if ( FStyle <> csDropDown ) then begin
    InitItemList;
    SetEditText ( DroppedDown );
    end;
end;

// ----------- ComboBox -------------
function  TCustomComboBoxX.GetItemIndex: integer;
begin
result := FListBox.ItemIndex;
end;

// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetItemIndex ( Value: Integer );
begin
if ( FListBox.ItemIndex = Value ) then exit;

if ( FStyle <> csDropDown ) or ( not DroppedDown ) then begin
    if ( Value >= 0 ) and ( Value < FListBox.Items.Count ) then
        Text := FListBox.Items[Value]
    else
        Text := '';

    InitItemList;
    SetEditText ( DroppedDown );
    end;
{
date: 28 May 2001.
description: ItemIndex property bug (solve)
if ( FStyle <> csDropDown ) then begin
    InitItemList;
    SetEditText ( DroppedDown );
    end;
}
end;

// ----------- ComboBox -------------
function  TCustomComboBoxX.GetSelCount: Integer;
begin
result := FListBox.SelCount;
end;

// ----------- ComboBox -------------
function  TCustomComboBoxX.GetSelected ( Index: Integer ): boolean;
begin
result := FListBox.Selected[Index];
end;

// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetSelected ( Index: Integer; Value: boolean );
begin
if ( FListBox.Selected[index] = Value ) then exit;
FListBox.Selected[index] := Value;
if ( FStyle <> csDropDown ) then begin
    InitItemList;
    SetEditText ( DroppedDown );
    end;
end;

// ----------- ComboBox -------------
function  TCustomComboBoxX.GetTopIndex: integer;
begin
result := FListBox.TopIndex;
end;

// ----------- ComboBox -------------
procedure TCustomComboBoxX.SetTopIndex ( Value: integer );
begin
if ( FListBox.TopIndex = Value ) then exit;
FListBox.TopIndex := Value;
end;

// -----------------------------------------------------------------------------

procedure Register;
begin
  RegisterComponents ( 'Samples', [TComboBoxX] );
end;

// -----------------------------------------------------------------------------

initialization
FBmpEdit := TBitmap.Create;
FBmpNew  := TBitmap.Create;
FBmpNewDis := TBitmap.Create;
FBmpDel := TBitmap.Create;
FBmpDelDis := TBitmap.Create;
FBmpUp := TBitmap.Create;
FBmpDown := TBitmap.Create;
FBmpPins := TBitmap.Create;

FBmpEdit.LoadFromResourceName( HInstance, 'CBX_BMP_EDIT' );
FBmpNew .LoadFromResourceName( HInstance, 'CBX_BMP_NEW' );
FBmpNewDis.LoadFromResourceName( HInstance, 'CBX_BMP_NEW_D' );
FBmpDel.LoadFromResourceName( HInstance, 'CBX_BMP_DEL' );
FBmpDelDis.LoadFromResourceName( HInstance, 'CBX_BMP_DEL_D' );
FBmpUp.LoadFromResourceName( HInstance, 'CBX_BMP_UP' );
FBmpDown.LoadFromResourceName( HInstance, 'CBX_BMP_DOWN' );
FBmpPins.LoadFromResourceName( HInstance, 'CBX_BMP_PINS' );

finalization
FBmpEdit.Free;
FBmpNew .Free;
FBmpNewDis.Free;
FBmpDel.Free;
FBmpDelDis.Free;
FBmpUp.Free;
FBmpDown.Free;

end.
