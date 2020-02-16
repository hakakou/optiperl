unit ColorSelector;

interface

uses
  Windows, Messages, SysUtils, Classes, dialogs,Graphics, Controls,
  Menus, forms,colorform,buttons;

type
  Mode = (Down,Up);
  TColorSelector = class(TCustomControl)
  private
    FCustom: TStrings;
  protected
    FChangeColor: TNotifyEvent;
    FColor: TColor;
    Frame:TRect;
    HasMouse,KeybDown,ButDown,IsFocused:Boolean;
    FRaiseContens: boolean;
    FDropDownMenu: TPopUpMenu;
    procedure SetColor(Value: TColor);
    //when the color changes in the selector form
    procedure  SelectColor(Sender: TObject; NewColor: TColor);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Click; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    //IDE Events
    Procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    //Mouse Events
    procedure CMMouseEnter(var Msg: TMessage); message CM_MOUSEENTER; //Detect Mouse
    procedure CMMouseLeave(var Msg: TMessage); message CM_MOUSELEAVE; //Detect Mouse

    //Window Events
    procedure WMSETFOCUS (var Msg: TMessage); message  WM_SETFOCUS;
    procedure WMKILLFOCUS (var Msg: TMessage); message WM_KILLFOCUS;


    procedure WMERASEBKGND(var message: TWMERASEBKGND); message WM_ERASEBKGND;

    procedure DrawFrame(Stade:Mode);
  public
    procedure Paint; Override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Color: TColor read FColor write SetColor;
    property OnChangeColor: TNotifyEvent read FChangeColor write FChangeColor;
    property Cursor;
    property Enabled;
    property Height;
    property HelpContext;
    property Hint;
    property Left;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Tag;
    property Top;
    property Visible;
    property Width;

    property OnEnter;
    property OnExit;

    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

  var
  ColorWindow: tcolorform;

procedure Register;

implementation

{$R ColorSelector.RES}

procedure Register;
begin
  RegisterComponents('UcSoft', [TColorSelector]);
end;

(* Utility Functions *)

procedure Frame3D(Canvas: TCanvas; var Rect: TRect; TopColor, BottomColor: TColor;
  Width: Integer);

  procedure DoRect;
  var
    TopRight, BottomLeft: TPoint;
  begin
    with Canvas, Rect do
    begin
      TopRight.X := Right;
      TopRight.Y := Top;
      BottomLeft.X := Left;
      BottomLeft.Y := Bottom;
      Pen.Color := TopColor;
      PolyLine([BottomLeft, TopLeft, TopRight]);
      Pen.Color := BottomColor;
      Dec(BottomLeft.X);
      PolyLine([TopRight, BottomRight, BottomLeft]);
    end;
  end;

begin
  Canvas.Pen.Width := 1;
  Dec(Rect.Bottom); Dec(Rect.Right);
  while Width > 0 do
  begin
    Dec(Width);
    DoRect;
    InflateRect(Rect, -1, -1);
  end;
  Inc(Rect.Bottom); Inc(Rect.Right);
end;

procedure CreatePopMark(Canvas: TCanvas; X, Y: Integer) ;
var
    Pts:array[1..3] of TPoint;
    OldBColor, OldPenColor: TColor;
begin
     OldBColor := Canvas.Brush.Color;
     OldPenColor := Canvas.Pen.Color;

     Canvas.brush.color := clBlack;
     Canvas.pen.color:=clBlack;

     pts[1]:=point(x,y);
     pts[2]:=point(x+4,y);
     pts[3]:=point(x+2,y+2);
     Canvas.polygon(pts);

     Canvas.brush.Color := OldBColor;
     Canvas.pen.color := OldPenColor;
end;

constructor TColorSelector.Create(aOwner: TComponent);
begin
     inherited Create(aOwner);
     Width := 42;
     Height := 21;
     TabStop := True;
     Color := clBlack;
     FCustom:=TStringList.Create;
end;

destructor TColorSelector.Destroy;
begin
     FCustom.Free;
     inherited Destroy;
end;

procedure TColorSelector.Paint;
begin
     if (ButDown and HasMouse) or (ButDown and KeybDown) then
        DrawFrame(Down)
     else
         DrawFrame(Up);
     //after i draw want i want call the rest of the objects paint code
     inherited;
end;


procedure TColorSelector.DrawFrame(Stade:Mode);
var
   DrawLineWPos,
   DrawLineTopPos,
   DrawLineBottomPos, PopMarkTopPos, PopMarkWPos:  integer;
   oldcolor: tcolor;
begin
     Frame:=GetClientRect;
     case Stade of
          Down:
               begin
                    //Draw the frame
                    DrawFrameControl(Canvas.Handle,Frame,DFC_BUTTON,DFCS_BUTTONPUSH+DFCS_PUSHED);
                     //The line
                     DrawLineWPos := Width - (Width div 4) + 1 - 1;//-1 para dar igual ao outro
                     DrawLineTopPos := 4;
                     DrawLineBottomPos := Height - 2;
                     Frame := Rect(DrawLineWPos,DrawLineTopPos,DrawLineWPos,DrawLineBottomPos);
                     Frame3D(Canvas,Frame,clWhite,clGray,1);
                     //Draw in ColorRect
                     oldcolor :=canvas.Brush.color;
                     Frame := Rect(6,DrawLineTopPos+1,DrawLineWPos-4,DrawLineBottomPos-1);
                     canvas.Brush.color := clblack;
                     Canvas.FillRect(frame);
                     Frame := Rect(6+1,DrawLineTopPos+1+1,DrawLineWPos-4 -1,DrawLineBottomPos-1-1);
                     canvas.Brush.color := Color;
                     Canvas.FillRect(frame);
                     canvas.Brush.color := oldcolor;
                     //the popup mark
                     PopMarkTopPos := (Height div 2) - 1 +1;//o -1 é metade da altura da pop mark;
                     PopMarkWPos := (Width - (Width div 4)) + ((Width div 4) div 2) -3+1-1;//posicão do traco + metade da largura do traco ao fim - a width da marca -1 para a justar a perspectiva
                     CreatePopMark(Canvas, PopMarkWPos, PopMarkTopPos);
                      //Draw The focus rect
                      Frame := GetClientRect;
                      if IsFocused then
                         begin
                              Frame := Rect(Frame.Left+4,Frame.Top+4,Frame.Right-2,Frame.Bottom-2);
                              Canvas.DrawFocusRect(Frame);
                         end;
               end;
          Up:
             begin
                  //draw the frame
                  DrawFrameControl(Canvas.Handle,Frame,DFC_BUTTON,DFCS_BUTTONPUSH);
                  //The line
                  DrawLineWPos := Width - (Width div 4) - 1;//-1 para dar igual ao outro
                  DrawLineTopPos := 3;
                  DrawLineBottomPos := Height - 3;
                  Frame := Rect(DrawLineWPos,DrawLineTopPos,DrawLineWPos,DrawLineBottomPos);
                  Frame3D(Canvas,Frame,clWhite,clGray,1);
                  //Draw in ColorRect
                  oldcolor :=canvas.Brush.color;
                  Frame := Rect(5,DrawLineTopPos+1,DrawLineWPos-4,DrawLineBottomPos-1);
                  canvas.Brush.color := clblack;
                  Canvas.FillRect(frame);
                  Frame := Rect(5+1,DrawLineTopPos+1+1,DrawLineWPos-4 -1,DrawLineBottomPos-1-1);
                  canvas.Brush.color := Color;
                  Canvas.FillRect(frame);
                  canvas.Brush.color := oldcolor;

                  //the popup mark
                  PopMarkTopPos := (Height div 2) - 1;//o -1 é metade da altura da pop mark;
                  PopMarkWPos := (Width - (Width div 4)) + ((Width div 4) div 2) -3-1;//posicão do traco + metade da largura do traco ao fim - a width da marca -1 para a justar a perspectiva
                  CreatePopMark(Canvas, PopMarkWPos, PopMarkTopPos);
                  //draw the focus rect
                  Frame := GetClientRect;
                  if IsFocused then
                     begin
                          InflateRect(Frame, -3, -3);
                          Canvas.DrawFocusRect(Frame);
                     end;
             end;
     end;
end;

procedure TColorSelector.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     inherited MouseDown(Button,Shift,x,y);
     If Button = mbLeft then
        begin
             ButDown:=true;
             invalidate;
             SetFocus;
        end;
end;

procedure TColorSelector.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     inherited MouseUp(Button,Shift,x,y);
     If Button = mbLeft then
        begin
             ButDown:=false;
             invalidate;
        end;
end;

procedure  TColorSelector.SelectColor(Sender: TObject; NewColor: TColor);
begin
    if FColor <> NewColor then
        begin
             FColor :=  NewColor;
             invalidate; //repaint with the new color
             if assigned(FChangeColor) then //if FChangeColor is not assgned and we call it we get a runtime error
                FChangeColor(Self);
        end;
end;

procedure TColorSelector.Click;
var Pos: TPoint;
begin
     pos := ClientToScreen(Point(0, Height));
     ColorWindow := TColorform.create(Self);

     //Check and see if the form should be shown above the control ( if at the bottom of the screen )
     if( ( pos.Y + 120 ) > Screen.Height )then
       pos.Y := pos.Y - 120 - Height;
     //te previous two lines were added by: Robert Rehberg

     ColorWindow.Left := Pos.X;
     ColorWindow.Top := Pos.Y;
     ColorWindow.Width := 78;
     ColorWindow.Height := 120;
     ColorWindow.OnSelectColor := SelectColor;
     ColorWindow.CurentColor := FColor;
     ColorWindow.show;
     inherited Click;
end;

procedure TColorSelector.KeyDown(var Key: Word; Shift: TShiftState);
begin
     inherited KeyDown(Key,Shift);
     If (Key = VK_SPACE) and (not KeybDown)  then //if the space is already pressed there is no need to repaint the button
        begin
             ButDown := true;
             KeybDown := true;
             invalidate;
        end;
end;

procedure TColorSelector.KeyUp(var Key: Word; Shift: TShiftState);
begin
     inherited KeyUp(Key,Shift);
     If Key = VK_SPACE then
        begin
             ButDown := false;
             KeybDown := false;
             invalidate;
             //finally show the color menu
             Click;
        end;
end;

procedure TColorSelector.KeyPress(var Key: Char);
begin
     if (Key = #13){ or (Key = #32)} then
        Click;
     inherited;
end;


//IDE events
Procedure TColorSelector.CMEnabledChanged(var Message: TMessage);
Begin
    Inherited;
    Invalidate;  // Redraw the button.
end;

//Mouse Events
procedure TColorSelector.CMMouseEnter(var Msg: TMessage);
begin
     HasMouse:=True;
     Invalidate;    // Redraw the button.
end;

procedure TColorSelector.CMMouseLeave(var Msg: TMessage);
begin
     HasMouse:=False;
     Invalidate;     // Redraw the button.
end;

//window events

procedure TColorSelector.WMSETFOCUS (var Msg: TMessage);
begin
     IsFocused := true;
     Invalidate;
end;

procedure TColorSelector.WMKILLFOCUS (var Msg: TMessage);
begin
     IsFocused := false;
     Invalidate;
end;

//if we down't erase the backGround we save lots of time and prevent flikering
//bisedes there is no need to erase the backgorund since we are going to paint over it
procedure TColorSelector.WMERASEBKGND(var message: TWMERASEBKGND);
begin
     message.Result := 1;
end;

procedure TColorSelector.SetColor(Value: TColor);
begin
     if FColor <> Value then begin
        FColor := Value;
        Invalidate;
     end;
end;

end.

