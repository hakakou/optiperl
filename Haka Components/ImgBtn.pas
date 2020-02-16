unit ImgBtn;

//* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *//
//*  ImgBtn. Delphi 3, 4
//*
//* This component turns 3 images to button with 3 states : normal, MouseOver
//* and Pressed. I've also added some importent events.
//*
//* Writen by Paul Krestol.
//* For contacts e-mail me to : paul@mediasonic.co.il
//* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ *//


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,HKGraphics,JanFX;

type
  TOnMouseEvent = procedure( Msg: TWMMouse ) of object;

  TPaintStatus = (psNormal,psDown,psUp);

  TImgBtn = class( TGraphicControl )
  protected
    procedure WMMouseEnter( var Msg : TWMMouse ); message CM_MOUSEENTER;
    procedure WMMouseLeave( var Msg : TWMMouse ); message CM_MOUSELEAVE;
    procedure WMLButtonUp( var Msg : TWMLButtonUp ); message WM_LBUTTONUP;
    procedure WMLButtonDown( var Msg : TWMLButtonUp ); message WM_LBUTTONDOWN;
  private
    FPaintStatus : TPaintStatus;
    FEntered : boolean;
    FDown : boolean;
    FOnMouseEnter : TOnMouseEvent;
    FOnMouseLeave : TOnMouseEvent;
    FOnMouseDown  : TOnMouseEvent;
    FOnMouseUp    : TOnMouseEvent;
    FPic : TPicture;
    FPicDown : TPicture;
    FPicUp : TPicture;
    FSupported : boolean;
    procedure SetPicture(Value: TPicture);
    Procedure SetPaintStatus(Ps : TPaintStatus);
    procedure PictureChanged(Sender: TObject);
  protected
    procedure Paint; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Picture: TPicture read FPic write SetPicture;
    Property PaintStatus : TPaintStatus read FPaintStatus write SetPaintStatus;
    //** Events **//
    property OnMouseDown : TOnMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseEnter : TOnMouseEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave : TOnMouseEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseUp : TOnMouseEvent read FOnMouseUp write FOnMouseUp;
    property Supported : boolean read FSupported write FSupported;
  end;

procedure Register;

implementation
{$R *.RES}

(*******************************************************************************)
procedure Register;
begin
  RegisterComponents( 'Haka', [ TImgBtn ] );
end;

(*******************************************************************************)
constructor TImgBtn.Create;
begin
  inherited;
  ControlStyle := ControlStyle + [csReplicatable];
  Height := 105;
  Width := 105;

  FPic := TPicture.Create;
  FPic.OnChange := PictureChanged;
  FPicUp := TPicture.Create;
  FPicDown := TPicture.Create;
  FEntered := False;
  FDown := False;
  FSupported := True;
  FPaintStatus:=psNormal;
end;

procedure TImgBtn.Paint;
begin
 case FPaintStatus of
  psNormal :  canvas.Draw(0,0,FPic.Bitmap);
  psDown :  canvas.Draw(0,0,FPicDown.Bitmap);
  psUp :  canvas.Draw(0,0,FPicUp.Bitmap);
 end;
end;


procedure TImgBtn.PictureChanged(Sender: TObject);
begin
end;

(*******************************************************************************)
destructor TImgBtn.Destroy;
begin
  FPic.Free;
  FPicDown.Free;
  FPicUp.Free;
  inherited;
end;

(*******************************************************************************)
procedure TImgBtn.WMMouseEnter( var Msg: TWMMouse );
begin
  if not FSupported then Exit;
  FEntered := True;
  if FDown then PaintStatus:=psDown else PaintStatus:=psUp;
  if Assigned( FOnMouseEnter ) then FOnMouseEnter( Msg );
end;

(*******************************************************************************)
procedure TImgBtn.WMMouseLeave( var Msg: TWMMouse );
begin
  if not FSupported then Exit;
  FEntered := False;
  PaintStatus:=psNormal;
  if Assigned( FOnMouseLeave ) then FOnMouseLeave( Msg );
end;

(*******************************************************************************)
procedure TImgBtn.WMLButtonDown(var Msg: TWMMouse);
begin
  inherited;
  if not FSupported then Exit;
  FDown := True;
  if FEntered then PaintStatus:=psDown;
  if Assigned( FOnMouseDown ) then FOnMouseDown( Msg );
end;

(*******************************************************************************)
procedure TImgBtn.WMLButtonUp(var Msg: TWMMouse);
begin
  inherited;
  if not FSupported then Exit;
  FDown := False;
  if FEntered then paintStatus:=psUp;
  if Assigned( FOnMouseUp ) then FOnMouseUp( Msg );
end;

procedure TImgBtn.SetPicture(Value: TPicture);
var w,h : Integer;
begin
 FPic.Assign(Value);
 FPicUp.Assign(Value);
 FPicDown.Assign(Value);
// Contrast(FPic.bitmap,100);
// Buttonize(FPic.Bitmap,1,2);
 exit;
 w:=FPic.Width;
 h:=FPic.Height;
 FPicUp.Bitmap.Width:=w;
 FPicUp.Bitmap.Height:=h;
 FPicUp.Bitmap.Canvas.Draw(1,1,Value.Bitmap);

 FPicDown.Bitmap.Width:=w;
 FPicDown.Bitmap.Height:=h;
 FPicDown.Bitmap.Canvas.Draw(0,0,value.Bitmap);
end;

procedure TImgBtn.SetPaintStatus(Ps: TPaintStatus);
begin
 if FPaintStatus<>PS then
 begin
  FPaintStatus:=ps;
  invalidate;
 end;
end;

end.
