unit ColorForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,stdctrls;

type
  TSelectColor = procedure (Sender: TObject; NewColor: TColor) of object;
  TColorForm = class(tform)
  private
    FSelectColor: TSelectColor;
    FCurentColor: TColor;
    MouseInSquare: TPoint;
    HasExtraColor: Boolean;
    procedure WMKILLFOCUS(var message: TWMKILLFOCUS); message WM_KILLFOCUS;
    procedure WMERASEBKGND(var message: TWMERASEBKGND); message WM_ERASEBKGND;
  protected
    procedure Paint; override;
    procedure DoShow; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property CurentColor: TColor read FCurentColor write FCurentColor;
  published
    //i believe that this is the best way to pass the selected color to TColorSelector.
//if you have a better idea please let me know
    property OnSelectColor: TSelectColor read FSelectColor write FSelectColor;
  end;

(*const
    GridColors: array[1..5{lines},1..4{colums}] of TColor = ( (clWhite,clBlack,clSilver,clGray),
                                                                 (clRed,clMaroon,clYellow,clOlive),
                                                                 (clLime,clGreen,clAqua,clTeal),
                                                                 (clBlue,clNavy,clFuchsia,clPurple),
                                                                 ($00C0DCC0,$00F0CAA6,$00F0FBFF,$00A4A0A0) );
*)
const
    GridColors: array[1..6{lines},1..5{colums}] of TColor = ( (clWhite,clBlack,clSilver,clGray,clGray),
                                                                 (clRed,clMaroon,clYellow,clOlive,clGray),
                                                                 (clLime,clGreen,clAqua,clTeal,clGray),
                                                                 (clBlue,clNavy,clFuchsia,clPurple,clGray),
                                                                 (clBlue,clNavy,clFuchsia,clPurple,clGray),
                                                                 ($00C0DCC0,$00F0CAA6,$00F0FBFF,$00A4A0A0,clGray) );


implementation

{$R ColorForm.Dfm}

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

//i know that this is not the best way of doing this.
//but it works for now.
//if you want to improve it fell free to do so
procedure DrawSunkenSquare(Canvas: TCanvas; ARect: TRect);
begin
     //don't change this line.
     //before i wrote this function i used DrawFrameControl to draw the frame. now this is needed to
     //make the image correct
     ARect := Rect(ARect.Left,ARect.Top,ARect.Right-1,ARect.Bottom-1);

     Canvas.Pen.color := clgray;
     canvas.moveto(ARect.left,ARect.top);
     canvas.lineto(ARect.right,ARect.top);
     canvas.moveto(ARect.left,ARect.top);
     canvas.lineto(ARect.left,ARect.bottom);
     canvas.pen.color := clwhite;
    canvas.moveto(ARect.left,ARect.bottom);
     canvas.lineto(ARect.right,ARect.bottom);
     canvas.moveto(ARect.right,ARect.bottom);
     canvas.lineto(ARect.right,ARect.top-1);

     InflateRect(ARect,-1,-1);
     Canvas.Pen.color := clblack;
     canvas.moveto(ARect.left,ARect.top);
     canvas.lineto(ARect.right,ARect.top);
     canvas.moveto(ARect.left,ARect.top);
     canvas.lineto(ARect.left,ARect.bottom);
     canvas.pen.color := $00DFDFDF;
     canvas.moveto(ARect.left,ARect.bottom);
     canvas.lineto(ARect.right,ARect.bottom);
     canvas.moveto(ARect.right,ARect.bottom);
     canvas.lineto(ARect.right,ARect.top-1);
end;

//draw the selected color rect
procedure DrawSelectedColorRect(Canvas: TCanvas; ARect: TRect);
var
   Frame: TRect;
begin
     Frame := Rect(ARect.Left-1,ARect.Top-1,ARect.Right+1,ARect.Bottom+1);
     Canvas.Brush.Color := clBlack;
     Canvas.FrameRect(Frame);
     Frame := Rect(ARect.Left,ARect.Top,ARect.Right,ARect.Bottom);
     Canvas.Brush.Color := clWhite;
     Canvas.FrameRect(Frame);
     Frame := Rect(ARect.Left+1,ARect.Top+1,ARect.Right-1,ARect.Bottom-1);
     Canvas.Brush.Color := clBlack;
     Canvas.FrameRect(Frame);
end;

function IsColorInArray(Color: TColor): Boolean;
var i,j: integer;
begin
     Result := false;
     for i := 1 to 5 do
        for j := 1 to 4 do
        begin
             if Color = GridColors[i,j] then
                begin
                     Result := true;
                     exit;
                end;
        end;
end;

constructor TColorForm.Create(AOwner: TComponent);
begin
     inherited;
     BorderIcons := [];
     BorderStyle := bsnone;
     FormStyle := FsStayOnTop;
     HasExtraColor := False;
end;

destructor TColorForm.Destroy;
begin
     inherited;
end;

//just before we show the window we check is color is selected an select it
procedure TColorForm.DoShow;
var
   i,j:integer;
begin
     for i := 1 to 5 do
         for j := 1 to 4 do
         begin
              if GridColors[i,j] = CurentColor then
                 begin
                      MouseInSquare.x := j;
                      MouseInSquare.y := i;
                      exit;
                 end;
         end;
     //if we get this far then the color must be diferent from the list.
     //so its at the left side of the "other" button
     MouseInSquare.x := 4;
     MouseInSquare.y := 6;
     HasExtraColor := not IsColorInArray(CurentColor);
end;

procedure TColorForm.paint;
var frame: trect;
    i,j: integer;
    BufferBit: TBitmap;// the doblebuffering bitmap
begin
     //i use doblebuffering here because it prevents the flikering because it draw
     //the whole image in the window,not step by step
     BufferBit := TBitmap.Create;
     BufferBit.Width := Self.Width;
     BufferBit.Height := Self.Height;
     //the background 3d rect
     DrawFrameControl(BufferBit.Canvas.Handle,clientrect,DFC_BUTTON,DFCS_BUTTONPUSH);
     //the square
     for i := 1 to 5 do
         for j := 1 to 4 do
         begin
              //o frame
              frame := Rect(4+(18*(j-1)),4+(18*(i-1)),(4+(18*(j-1)))+16,(4+(18*(i-1)))+16);
              DrawSunkenSquare(BufferBit.Canvas,Frame);
              //Explicação:
              {
                  left = 4[1st margin]+(18[space betwin the previous left anterior and the next right]*(j[current pos]-1[so it will be correct))
                  Top =  4[1st margin]+(18[space betwin the previous left anterior and the next right]*(i[current pos]-1[so it will be correct))
                  right = 4[1st margin]+(18[space betwin the previous left anterior and the next right]*(i[current pos]-1[so it will be correct))+16[width]
                  bottom = 4[1st margin]+(18[space betwin the previous left anterior and the next right]*(i[current pos]-1[so it will be correct))+16[height]
              }
              //the colors
              BufferBit.Canvas.Brush.Color := GridColors[i,j];
              InflateRect(Frame,-2,-2);
              BufferBit.Canvas.FillRect(Frame);
         end;
     //draw an extra square is the curent color is not in the gridcolors array
     if not IsColorInArray(FCurentColor) then
        begin
             frame := Rect(Width-4-16,Height-4-16,Width-4,Height-4);
              DrawSunkenSquare(BufferBit.Canvas,Frame);
              BufferBit.Canvas.Brush.Color := CurentColor;
              InflateRect(Frame,-2,-2);
              BufferBit.Canvas.FillRect(Frame);
        end;

     // the dividing line
     Frame := Rect(4,Height-24,Width-4,Height-24);
     Frame3D(BufferBit.Canvas,Frame,clWhite,clGray,1);
     //draw the "other colors" button
     if IsColorInArray(FCurentColor) then //if the curent color is not in the array draw a smaller button
        Frame := Rect(3,Height-24+3,62+3,18+Height-24+3)
     else
         Frame := Rect(3,Height-24+3,56,18+Height-24+3);
     DrawFrameControl(BufferBit.Canvas.Handle,Frame,DFC_BUTTON,DFCS_BUTTONPUSH);
     BufferBit.Canvas.Brush.Color := clBtnFace;
     DrawText(BufferBit.Canvas.Handle,PChar('&Other...'),Length('&Other...'),Frame,dt_SingleLine or Dt_VCenter or DT_CENTER);

     if ((MouseInSquare.X <> 0) and (MouseInSquare.y <> 0)) and  (not ((MouseInSquare.X = 4) and (MouseInSquare.y = 6))) then begin//if the color in the standard colors
     //Draw the color selector
     //j=x   i=y
      Frame := Rect(4+(18*(MouseInSquare.x-1)),4+(18*(MouseInSquare.y-1)),(4+(18*(MouseInSquare.x-1)))+16,(4+(18*(MouseInSquare.y-1)))+16);
      DrawSelectedColorRect(BufferBit.Canvas,Frame);
     end;

     //if it's a diferent color
     if ((MouseInSquare.X = 4) and (MouseInSquare.y = 6)) and (not IsColorInArray(CurentColor)) then
         begin
              DrawSelectedColorRect(BufferBit.Canvas,Rect(Width-4-16,Height-4-16,Width-4,Height-4));
         end;
     //After we fineshed all the draing we copy the final image to the form's canvas
     BitBlt(Canvas.Handle,0,0,Width,Height,BufferBit.Canvas.Handle,0,0,SRCCOPY	);

end;

procedure TColorForm.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   ColorDialog: TColorDialog;
begin
     //if we've clicked on a color then close
     if (MouseInSquare.x <> 0) and (MouseInSquare.y <> 0) then
        begin
             //if we clicked on 'extra colors' and we actualy have one there so selected if not exit
             if ((MouseInSquare.x = 4) and (MouseInSquare.y = 6)) then
                begin
                     if not HasExtraColor then exit;
                     FSelectColor(Self,CurentColor);
                end
             else
                 FSelectColor(Self,GridColors[MouseInSquare.y][MouseInSquare.x]);
             Close;
        end;
     //if in the buton rect
     if ((X >=3) and (X <= 62+3) and (Y >= Height-24+3) and (Y <= 18+Height-24+3)) then
        begin
             ColorDialog := TColorDialog.Create(nil);
             ColorDialog.Options := [cdFullOpen];
             ColorDialog.Color := CurentColor;
             if ColorDialog.Execute then
                FSelectColor(Self,ColorDialog.Color);
             ColorDialog.Destroy;
        end;
end;

procedure TColorForm.MouseMove(Shift: TShiftState; X, Y: Integer);
  function PointInRect(APoint: TPoint; ARect: TRect): Boolean;
  begin
       Result := False;
       if ((Apoint.X > ARect.Left) and (APoint.X < ARect.Right)) and ((APoint.Y > ARect.Top) and (APoint.Y < ARect.Bottom)) then
          Result := True;
  end;

  function GetMouseSquare(APoint: TPoint): TPoint;
  var i,j: integer;
      Frame: TRect;
  begin
       for i := 1 to 5 do
         for j := 1 to 4 do
         begin
              Frame := Rect(4+(18*(j-1)),4+(18*(i-1)),(4+(18*(j-1)))+16,(4+(18*(i-1)))+16);
              //inflaterect so the rects are beggier o cover the margins also
              InflateRect(Frame,2,2);
              if PointInRect(APoint,Frame) then
                 begin
                      Result.X := j;
                      Result.Y := i;
                      Exit;
                 end;
              //if we get this far then the mouse is outside the color area, so return (0,0) so we don't repaint
              Result.X := 0;
              Result.Y := 0;
         end;
       //if we get this far the mouse might be in the diferent color rect. So see if it is
       Frame := Rect(Width-4-16,Height-4-16,Width-4,Height-4);
       if PointInRect(APoint,Frame) then
          begin
               Result.X := 4;
               Result.Y := 6;
               Exit;
          end;
  end;

var
   NewSquare: TPoint;
begin
     NewSquare := GetMouseSquare(Point(X,Y));
     //if new square is diferent from old then repaint
     //if we are outside the color area the square is always (0,0) so we don't repaint
     if (MouseInSquare.X <> NewSquare.X) or (MouseInSquare.Y <> NewSquare.Y) then
        begin
             MouseInSquare := NewSquare;
             Invalidate;//repaint with the new sqaure
        end;
end;

//when the window loses the focus kills it self
procedure TColorForm.WMKILLFOCUS(var message: TWMKILLFOCUS);
begin
     Self.Close;
end;

//if we down't erase the backGround we save lots of time and prevent flikering
//bisedes there is no need to erase the backgorund since we are going to paint over it
procedure TColorForm.WMERASEBKGND(var message: TWMERASEBKGND);
begin
     message.Result := 1;
end;

end.
