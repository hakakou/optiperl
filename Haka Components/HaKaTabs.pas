unit HaKaTabs;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ComCtrls,Forms,CommCtrl,
  graphics,ExtCtrls,Dialogs;

type
  TPaintEvent = procedure(Sender: TObject; Canvas : TCanvas) of object;

  THKTabcontrol = class(TTabControl)
  private
    Igoto,Imoving : Integer;
    FOnPaint : TPaintEvent;
    FBorderStyle : Forms.TBorderStyle;
    function IsContainedControl: Boolean;
    procedure MOUSEWHEEL(var msg : TWMMOUSEWHEEL); message WM_MOUSEWHEEL;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    procedure ChangeTab(ANext: boolean);
    constructor Create(AOwner : TComponent); override;
    function GetTabIndex(x, y: Integer): Integer;
  published
    property BorderStyle : Forms.TBorderStyle read FBorderStyle write FBorderStyle default bsNone;
    property OnPaint : TPaintEvent read FOnPaint write FOnPaint;
  end;

  THKPageControl = class(TPageControl)
  private
    FBorderStyle : Forms.TBorderStyle;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create( AOwner : TComponent ); override;
    function GetTabIndex(x, y: Integer): Integer;
  published
    property BorderStyle : Forms.TBorderStyle read FBorderStyle write FBorderStyle;
  end;

  THKColorBox = class(TCustomColorBox)
  Private
   FColorDialog : TColorDialog;
   FColorWasSet : Boolean;
  protected
   function PickCustomColor: Boolean; override;
   procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
   procedure Select; override;
   procedure CreateWnd; override;
  public
   constructor Create(AOwner: TComponent); override;
   Procedure PopulateWithOffice;
  published
   property ColorDialog : TColorDialog read FColorDialog write FColorDialog;
   property AutoComplete;
   property AutoDropDown;
   property Selected;
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnCloseUp;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('haka', [THKTabcontrol,THKPagecontrol,THKColorBox]);
end;
{
procedure THKTabcontrol.DrawTab(TabIndex: Integer; const Rect: TRect;
  Active: Boolean);
begin
 inherited;
 with rect,canvas do
 begin
  canvas.pen.color:=clBlack;

  MoveTo(right-5,top-5);
  lineto(right,bottom);
  MoveTo(right,top-5);
  lineto(right,bottom);
 end;
end;
}
procedure THKTabcontrol.MOUSEWHEEL(var msg: TWMMOUSEWHEEL);
begin
 ScrollTabs(msg.WheelDelta);
end;

procedure ThkTabControl.ChangeTab(ANext: boolean);
var
  i: integer;
  TabCount: integer;
begin
    TabCount := Tabs.Count;
    i := TabIndex;
    if ANext then
    begin
      inc(i);
      if i >= TabCount then
        i := 0;
    end
    else
    begin
      dec(i);
      if i < 0 then
        i := TabCount - 1;
    end;

    TabIndex := i;
end;

Function ThkTabControl.GetTabIndex(x,y : Integer) : Integer;
var i:integer;
begin
 i:=0;
 while (I<Tabs.count) do
 begin
  if PtInRect(TabRect(i),point(x,y)) then break;
  inc(i);
 end;
 if i>=tabs.Count
  then result:=-1
  else result:=i;
end;

function ThkTabControl.IsContainedControl: Boolean;
var
  Control: TControl;
begin
  Control := GetParentForm(Self).ActiveControl;
  while (Control <> nil) and (Control <> Self) do
    Control := Control.Parent;
  Result := Control <> nil;
end;

constructor THKTabcontrol.Create(AOwner: TComponent);
begin
 FBorderStyle:=bsNone;
 inherited;
end;

procedure THKTabcontrol.WndProc(var Message: TMessage);
begin
 if (Message.Msg=TCM_ADJUSTRECT) and (FBorderStyle=Forms.bsNone) then
  begin
   Inherited WndProc(Message);
   PRect(Message.LParam)^.Left:=0+1;
   PRect(Message.LParam)^.Right:=ClientWidth-1;
   PRect(Message.LParam)^.Bottom:=ClientHeight;
  end
 else
  Inherited WndProc(Message);
end;

{ THKPageControl }

constructor THKPageControl.Create(AOwner: TComponent);
begin
 FBorderStyle:=bsSingle;
 inherited;
end;

function THKPageControl.GetTabIndex(x, y: Integer): Integer;
var i:integer;
begin
 i:=0;
 while (I<Tabs.count) do
 begin
  if PtInRect(TabRect(i),point(x,y)) then break;
  inc(i);
 end;
 if i>=tabs.Count
  then result:=-1
  else result:=i;
end;

procedure THKPageControl.WndProc(var Message: TMessage);
begin
 if (Message.Msg=TCM_ADJUSTRECT) and (FBorderStyle=Forms.bsNone) then
 begin
    Inherited WndProc(Message);
    PRect(Message.LParam)^.Left:=0+1;
    PRect(Message.LParam)^.Right:=ClientWidth-1;
//    PRect(Message.LParam)^.Top:=PRect(Message.LParam)^.Top-4;
    PRect(Message.LParam)^.Bottom:=ClientHeight;
  end
   else Inherited WndProc(Message);
end;

procedure THKTabcontrol.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
 inherited;
 if not MultiLine
  then imoving:=GetTabIndex(x,y)
  else imoving:=-1;
 igoto:=-1;
end;

procedure THKTabcontrol.MouseMove(Shift: TShiftState; X, Y: Integer);
var
 l : Integer;
 rect : Trect;
 orect : TRect;
begin
 inherited;
 if (imoving=-1) or (not (ssLeft in Shift)) then exit;

  Igoto:=GetTabIndex(x,y);
  if Igoto=-1 then Igoto:=tabs.Count-1;
  if (abs(Igoto-imoving)<=1) then exit;
  orect:=TabRect(imoving);
  rect:=tabrect(Igoto);
  if (orect.top=rect.top) then
  begin
   if orect.Left>rect.Left
    then inc(Igoto);
   rect:=tabrect(Igoto);
   if orect.Left<rect.Left
    then dec(Igoto);
  end;
  rect.right:=rect.Left+2;
  dec(rect.left,2);
  canvas.Brush.Color:=clBlack;
  canvas.Brush.Style:=bsSolid;
  canvas.FillRect(rect);

end;

procedure THKTabcontrol.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
 inherited;
 if (imoving<>-1) and (igoto<>-1) then
 begin
  Tabs.Move(imoving,igoto);
  igoto:=-1; imoving:=-1;
 end;
end;

{procedure THKTabcontrol.WMPaint(var Message: TWMPaint);
begin
 inherited;
 if assigned(FonPaint) then
  FOnPaint(self,canvas);
end;
}

{ THKColorBox }


constructor THKColorBox.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
end;

procedure THKColorBox.CreateWnd;
begin
 inherited;
 Style:=[cbPrettyNames,cbCustomColor,cbStandardColors];
 PopulateWithOffice;
end;

procedure THKColorBox.DrawItem(Index: Integer; Rect: TRect;
  State: TOwnerDrawState);

  function ColorToBorderColor(AColor: TColor): TColor;
  type
    TColorQuad = record
      Red,
      Green,
      Blue,
      Alpha: Byte;
    end;
  begin
    if (TColorQuad(AColor).Red > 192) or
       (TColorQuad(AColor).Green > 192) or
       (TColorQuad(AColor).Blue > 192) then
      Result := clBlack
    else if odSelected in State then
      Result := clWhite
    else
      Result := AColor;
  end;

var
  LRect: TRect;
  LBackground: TColor;
  s:string;
begin
  with Canvas do
  begin
    FillRect(Rect);
    LBackground := Brush.Color;

    LRect := Rect;
    LRect.Right := LRect.Bottom - LRect.Top + LRect.Left;

    if (index=0) then
    begin
     if state=[] then
      items.Objects[0]:=TObject(Selected);
     if (odComboBoxEdit in state) then
      lrect.Right:=rect.Right;
    end;

    InflateRect(LRect, -1, -1);
    Brush.Color := Colors[Index];
    if Brush.Color = clDefault then
      Brush.Color := DefaultColorColor
    else if Brush.Color = clNone then
      Brush.Color := NoneColorColor;
    FillRect(LRect);
    Brush.Color := ColorToBorderColor(ColorToRGB(Brush.Color));
    FrameRect(LRect);

    Brush.Color := LBackground;
    Rect.Left := LRect.Right + 5;

    s:=Items[index];
    if (index=0) and (not (odComboBoxEdit in State))
    then
     canvas.Font.Style:=[fsBold]
    else
      canvas.Font.Style:=[];

    if not ((index=0) and (odComboBoxEdit in State))
    then
     TextRect(Rect, Rect.Left,
       Rect.Top + (Rect.Bottom - Rect.Top - TextHeight(Items[Index])) div 2,
       s);
  end;
end;

function THKColorBox.PickCustomColor: Boolean;
begin
 if not assigned(FColorDialog) then exit;
  with FColorDialog do
    Begin
      if not FColorWasSet
       then color:=TColor(items.Objects[0])
       else color:=selected;
      Result := Execute;
      if Result then
      begin
        Items.Objects[0] := TObject(Color);
        Self.Invalidate;
      end;
    end;
end;

procedure THKColorBox.PopulateWithOffice;
type TColorEntry = record
       Name: PChar;
       case Boolean of
         True: (R, G, B, reserved: Byte);
         False: (Color: COLORREF);
     end;

const DefaultColorCount = 41;
      // these colors are the same as used in Office 97/2000
      DefaultColors : array[0..DefaultColorCount - 1] of TColorEntry = (
        (Name: 'Black'; Color: $000000),
        (Name: 'Brown'; Color: $003399),
        (Name: 'Olive Green'; Color: $003333),
        (Name: 'Dark Green'; Color: $003300),
        (Name: 'Dark Teal'; Color: $663300),
        (Name: 'Dark blue'; Color: $800000),
        (Name: 'Indigo'; Color: $993333),
        (Name: 'Gray-80%'; Color: $333333),

        (Name: 'Dark Red'; Color: $000080),
        (Name: 'Orange'; Color: $0066FF),
        (Name: 'Dark Yellow'; Color: $008080),
        (Name: 'Green'; Color: $008000),
        (Name: 'Teal'; Color: $808000),
        (Name: 'Blue'; Color: $FF0000),
        (Name: 'Blue-Gray'; Color: $996666),
        (Name: 'Gray-50%'; Color: $808080),

        (Name: 'Red'; Color: $0000FF),
        (Name: 'Light Orange'; Color: $0099FF),
        (Name: 'Lime'; Color: $00CC99),
        (Name: 'Sea Green'; Color: $669933),
        (Name: 'Aqua'; Color: $CCCC33),
        (Name: 'Light Blue'; Color: $FF6633),
        (Name: 'Violet'; Color: $800080),
        (Name: 'Grey-40%'; Color: $969696),

        (Name: 'Pink'; Color: $FF00FF),
        (Name: 'Gold'; Color: $00CCFF),
        (Name: 'Yellow'; Color: $00FFFF),
        (Name: 'Bright Green'; Color: $00FF00),
        (Name: 'Turquoise'; Color: $FFFF00),
        (Name: 'Sky Blue'; Color: $FFCC00),
        (Name: 'Plum'; Color: $663399),
        (Name: 'Gray-25%'; Color: $C0C0C0),

        (Name: 'Rose'; Color: $CC99FF),
        (Name: 'Tan'; Color: $99CCFF),
        (Name: 'Light Yellow'; Color: $99FFFF),
        (Name: 'Light Green'; Color: $CCFFCC),
        (Name: 'Light Turquoise'; Color: $FFFFCC),
        (Name: 'Pale Blue'; Color: $FFCC99),
        (Name: 'Lavender'; Color: $FF99CC),
        (Name: 'Window'; Color: COLORREF(clWindow)),
        (Name: 'White'; Color: $FFFFFF)
      );
var
 i,p:integer;
begin
 if HandleAllocated then
 begin
  p:=TColor(Items.Objects[itemindex]);
  Items.BeginUpdate;
  items.Clear;
  items.Add('Select...');
  for i:=DefaultColorCount - 1 downto 0 do
   items.AddObject(DefaultColors[i].Name,TObject(DefaultColors[i].Color));
  Items.EndUpdate;
  selected:=p;
 end;
end;

procedure THKColorBox.Select;
begin
 inherited Select;
 if assigned(FColorDialog) then
 begin
  FColorDialog.Color:=Selected;
  FColorWasSet:=true;
 end;
end;

end.
