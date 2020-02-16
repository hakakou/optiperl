{
********************************************************************************
Módulo:        DrawComboBox
Versión:       1.0
Descripción:   Conjunto de ComboBox con opciones para dibujo. FREEWARE
Autor:         Favio E. Ugalde Corral
Creación:      10 de diciembre  de 1996
Modificación:  18 de septiembre de 1997
E-Mail:        fugalde@geocities.com
URL:           "Delphi en Español" http://www.geocities.com/~fugalde
Observaciones: ninguna
********************************************************************************
}

unit DrawComboBox;

interface

uses  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
      StdCtrls;

type

  { TFillStyleComboBox }

  TFillStyleComboBox = class(TCustomComboBox)
  private
    FFillStyle: TBrushStyle;
    FMaxFillStyle: TBrushStyle;
  protected
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Click; override;
    procedure BuildList; virtual;
    function  GetFillStyle: TBrushStyle;
    procedure SetFillStyle(Value: TBrushStyle);
    procedure SetMaxFillStyle(Value: TBrushStyle);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Color;
    property Ctl3D;
    property Enabled;
    property Height default 23;
    property ItemHeight default 17;
    property BrushStyle: TBrushStyle read GetFillStyle write SetFillStyle
             default bsSolid;
    property MaxFillStyle: TBrushStyle read FMaxFillStyle write SetMaxFillStyle
             default bsDiagCross;
    property ParentColor;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  { TLineStyleComboBox }

  TLineStyleComboBox = class(TCustomComboBox)
  private
    FLineStyle: TPenStyle;
    FMaxLineStyle: TPenStyle;
  protected
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Click; override;
    procedure BuildList; virtual;
    function  GetLineStyle: TPenStyle;
    procedure SetLineStyle(Value: TPenStyle);
    procedure SetMaxLineStyle(Value: TPenStyle);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Color;
    property Ctl3D;
    property Enabled;
    property Height default 23;
    property ItemHeight default 17;
    property PenStyle: TPenStyle read GetLineStyle write SetLineStyle
             default psDot;
    property MaxLineStyle: TPenStyle read FMaxLineStyle write SetMaxLineStyle
             default psInsideFrame;
    property ParentColor;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  { TLineWidthComboBox }

  TLineWidthComboBox = class(TCustomComboBox)
  private
    FLineWidth: Integer;
    FMaxLineWidth: Integer;
  protected
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Click; override;
    procedure BuildList; virtual;
    function  GetLineWidth: Integer;
    procedure SetLineWidth(Value: Integer);
    procedure SetMaxLineWidth(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Color;
    property Ctl3D;
    property Enabled;
    property Height default 23;
    property ItemHeight default 17;
    property Value: Integer read GetLineWidth write SetLineWidth
             default 1;
    property MaxValue: Integer read FMaxLineWidth write SetMaxLineWidth
             default 10;
    property ParentColor;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

  { TColorComboBoxEx }

  TShowStyle = (ssOnlyColor, ssOnlyText, ssColorAndText);

  TColorComboBoxEx = class(TCustomComboBox)
  private
    FColorValue: TColor;
    FShowStyle: TShowStyle;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    function  IndexOfColor(Value: TColor): Integer;
    procedure SetColorValue(NewValue: TColor);
    procedure ResetItemHeight;
  protected
    FOnChange: TNotifyEvent;
    procedure CreateWnd; override;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
    procedure Click; override;
    procedure BuildList; virtual;
    procedure Change; override;
    procedure SetShowStyle(Value: TShowStyle);
  public
    constructor Create(AOwner: TComponent); override;
    procedure AddColor(ColorValue: TColor; ColorText: string);
    property Text;
  published
    property ColorValue: TColor read FColorValue write SetColorValue
             default clBlack;
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property Enabled;
    property Font;
    property Height default 23;
    property ItemHeight default 17;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property ShowStyle: TShowStyle read FShowStyle write SetShowStyle
             default ssOnlyColor;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;

procedure Register;


implementation

{ TFillStyleComboBox }

constructor TFillStyleComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Propiedades por omisión
  Style := csOwnerDrawFixed;
  ItemHeight := 17;
  Height := 23;
  FFillStyle := bsSolid;
  FMaxFillStyle := bsDiagCross;
end;

function  TFillStyleComboBox.GetFillStyle: TBrushStyle;
begin
  Result := FFillStyle;
end;

procedure TFillStyleComboBox.SetFillStyle(Value: TBrushStyle);
begin
  if Value <= FMaxFillStyle then
    begin
    FFillStyle := Value;
    ItemIndex := Integer(FFillStyle);
    end;
end;

procedure TFillStyleComboBox.SetMaxFillStyle(Value: TBrushStyle);
var
  OldFillStyle: TBrushStyle;
begin
  OldFillStyle := BrushStyle;

  FMaxFillStyle := Value;
  // Carga la lista de ashurados
  BuildList;

  BrushStyle := OldFillStyle;
end;

procedure TFillStyleComboBox.BuildList;
var
  I: integer;
begin
  Items.Clear;
  for I:= 0 to Integer(bsDiagCross) do
    Items.Add('Ashurado ' + IntToStr(I + 1));
end;

procedure TFillStyleComboBox.CreateWnd;
begin
  inherited CreateWnd;
  // Carga la lista de ashurados
  BuildList;
  // Estilo de relleno seleccionado por omisión
  SetFillStyle(FFillStyle);
end;

procedure TFillStyleComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Y: integer;
begin
  with Canvas do
    begin
    // Borra el cuadro de selección con el color actual
    FillRect(Rect);
    // El próximo cuadro del elemento será con contorno gris
    Pen.Color := clGray;
    // Borra el cuadro del elemento con el color del fondo
    Brush.Color := Color;
    with Rect do
      Rectangle(Left + 4, Top + 2, Right - 4, Bottom - 2);
    // De acuerdo al tipo de ashurado
    case TBrushStyle(Index) of
      bsHorizontal:    // Con líneas horizontales
        // Dibuja dos líneas horizontales sobre el cuadro del elemento
        with Rect do
          begin
          Y := (Bottom - Top - 4) div 3;
          Rectangle(Left + 4, Top + 2 + Y, Right - 4, Top + 3 + Y * 2);
          end;
      bsCross:         // Con dibujos a cuadros
        begin
        // Dibuja dos líneas horizontales sobre el cuadro del elemento
        with Rect do
          begin
          Y := (Bottom - Top - 4) div 3;
          Rectangle(Left + 4, Top + 2 + Y, Right - 4, Top + 3 + Y * 2);
          end;
        // El próximo cuadro del elemento será con relleno gris
        Brush.Color := clGray;
        // Dibuja el cuadro del elemento con líneas verticales
        Brush.Style := bsVertical;
        with Rect do
          Rectangle(Left + 4, Top + 2, Right - 4, Bottom - 2);
        end;
      else             // El resto de los ashurados
        begin
        // El próximo cuadro del elemento será con relleno gris
        Brush.Color := clGray;
        // Dibuja el cuadro del elemento con el ashurado indicado en "Index"
        Brush.Style := TBrushStyle(Index);
        with Rect do
          Rectangle(Left + 4, Top + 2, Right - 4, Bottom - 2);
        end;
    end;
    end;
end;

procedure TFillStyleComboBox.Click;
begin
  // Guarda el estilo de relleno seleccionado
  if ItemIndex >= 0 then
    FFillStyle := TBrushStyle(ItemIndex);

  inherited Click;
end;

{ TLineStyleComboBox }

constructor TLineStyleComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Propiedades por omisión
  Style := csOwnerDrawFixed;
  ItemHeight := 17;
  Height := 23;
  FLineStyle := psDot;
  FMaxLineStyle := psInsideFrame;
end;

function  TLineStyleComboBox.GetLineStyle: TPenStyle;
begin
  Result := FLineStyle;
end;

procedure TLineStyleComboBox.SetLineStyle(Value: TPenStyle);
begin
  if Value <= FMaxLineStyle then
    begin
    FLineStyle := Value;
    ItemIndex := Integer(FLineStyle);
    end;
end;

procedure TLineStyleComboBox.SetMaxLineStyle(Value: TPenStyle);
var
  OldLineStyle: TPenStyle;
begin
  OldLineStyle := PenStyle;

  FMaxLineStyle := Value;
  // Carga la lista de tipos de línea
  BuildList;

  PenStyle := OldLineStyle;
end;

procedure TLineStyleComboBox.BuildList;
var
  I: integer;
begin
  Items.Clear;
  for I:= 0 to Integer(FMaxLineStyle) do
    Items.Add('Ancho ' + IntToStr(I + 1));
end;

procedure TLineStyleComboBox.CreateWnd;
begin
  inherited CreateWnd;
  // Carga la lista de tipos de línea
  BuildList;
  // Estilo de línea seleccionado por omisión
  SetLineStyle(FLineStyle);
end;

procedure TLineStyleComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  X, Y: integer;
begin
  with Canvas do
    begin
    // Borra el cuadro de selección con el color actual
    FillRect(Rect);

    // Se utiliza una pluma gris y contínua
    with Pen do
      begin
      Style := psSolid;
      Color := clGray;
      end;

    // Borra el cuadro del elemento con el color del fondo
    Brush.Color := Color;
    with Rect do
      Rectangle(Left + 4, Top + 2, Right - 4, Bottom - 2);

    // Dibuja una línea al centro del cuadro con el tipo especificado en "Index"
    Pen.Style := TPenStyle(Index);
    with Rect do
      begin
      X := Left + 7;
      Y := Top + (Bottom - Top) div 2;
      MoveTo(X, Y);
      X := Right - 7;
      LineTo(X, Y);
      end;
  end;
end;

procedure TLineStyleComboBox.Click;
begin
  // Guarda el estilo de línea seleccionado
  if ItemIndex >= 0 then
    FLineStyle := TPenStyle(ItemIndex);

  inherited Click;
end;

{ TLineWidthComboBox }

constructor TLineWidthComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Propiedades por omisión
  Style := csOwnerDrawFixed;
  ItemHeight := 17;
  Height := 23;
  FLineWidth := 1;
  FMaxLineWidth := 10;
end;

function  TLineWidthComboBox.GetLineWidth: Integer;
begin
  Result := FLineWidth;
end;

procedure TLineWidthComboBox.SetLineWidth(Value: Integer);
begin
  FLineWidth := Value;
  ItemIndex := FLineWidth - 1;
end;

procedure TLineWidthComboBox.SetMaxLineWidth(Value: Integer);
var
  OldLineWidth: Integer;
begin
  OldLineWidth := Value;

  FMaxLineWidth := Value;
  // Carga la lista de anchos de línea
  BuildList;

  Value := OldLineWidth;
end;

procedure TLineWidthComboBox.BuildList;
var
  I: integer;
begin
  Items.Clear;
  for I:= 1 to FMaxLineWidth do
    Items.Add('Ancho ' + IntToStr(I));
end;

procedure TLineWidthComboBox.CreateWnd;
begin
  inherited CreateWnd;
  // Carga la lista de anchos de línea
  BuildList;
  // Estilo de línea seleccionado por omisión
  SetLineWidth(FLineWidth);
end;

procedure TLineWidthComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  X, Y: integer;
begin
  with Canvas do
    begin
    // Borra el cuadro de selección con el color actual
    FillRect(Rect);

    // Se utiliza una pluma gris del ancho por omisión
    with Pen do
      begin
      Width := 0;
      Color := clGray;
      end;

    // Borra el cuadro del elemento con el color del fondo
    Brush.Color := Color;
    with Rect do
      Rectangle(Left + 4, Top + 2, Right - 4, Bottom - 2);

    // Dibuja una línea al centro del cuadro con el ancho especificado en "Index"
    Pen.Width := Index + 1;
    with Rect do
      begin
      X := Left + 6 + Pen.Width;
      Y := Top + (Bottom - Top) div 2;
      MoveTo(X, Y);
      X := Right - 6 - Pen.Width;
      LineTo(X, Y);
      end;
    end;
end;

procedure TLineWidthComboBox.Click;
begin
  // Guarda el ancho de línea seleccionado
  if ItemIndex >= 0 then
    FLineWidth := ItemIndex + 1;

  inherited Click;
end;

{ Utilerías }

// Obtiene la altura de la fuente
function GetItemHeight(Font: TFont): Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  try
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;
  Result := Metrics.tmHeight + 2;
end;

{ TColorComboBoxEx }

const
  ColorsInList = 16;
  ColorValues: array [1..ColorsInList] of TColor = (
    clBlack,
    clMaroon,
    clGreen,
    clOlive,
    clNavy,
    clPurple,
    clTeal,
    clGray,
    clSilver,
    clRed,
    clLime,
    clYellow,
    clBlue,
    clFuchsia,
    clAqua,
    clWhite);

constructor TColorComboBoxEx.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Propiedades por omisión
  Style := csOwnerDrawFixed;
  ItemHeight := 17;
  Height := 23;
  // Por omisión selecciona el color negro
  FColorValue := clBlack;
  // Por omisión muestra sólo el color
  FShowStyle := ssOnlyColor;
end;

procedure TColorComboBoxEx.AddColor(ColorValue: TColor; ColorText: string);
begin
  // Si no existe ya el color se adiciona
  if IndexOfColor(ColorValue) = -1 then
    Items.AddObject(ColorText, TObject(ColorValue));
end;

// Carga la lista de colores por omisión
procedure TColorComboBoxEx.BuildList;
var
  I: Integer;
  ColorName: string;
begin
  Clear;
  for I := 1 to ColorsInList do
    begin
    // Elimina del nombre el prefijo "cl"
    ColorName := Copy(ColorToString(ColorValues[I]), 3, 30);
    Items.AddObject(ColorName, TObject(ColorValues[I]));
    end;
end;

// Obtiene el índice del elemento al que corresponde "Value"
function  TColorComboBoxEx.IndexOfColor(Value: TColor): Integer;
var
  nItem: Integer;
begin
  for nItem := Items.Count - 1 downto 0 do
    if TColor(Items.Objects[nItem]) = Value then
        Break;
  Result := nItem;
end;

procedure TColorComboBoxEx.SetColorValue(NewValue: TColor);
var
  Item: Integer;
begin
  // Si el color nuevo es diferente del actual
  if (ItemIndex < 0) or (NewValue <> FColorValue) then
    begin
    // Obtiene el índice del elemento al que corresponde el valor nuevo
    Item := IndexOfColor(NewValue);
    // Si lo encontró
    if Item >= 0 then
      begin
      FColorValue := NewValue;
      if ItemIndex <> Item then
        ItemIndex := Item;
      Change;
      end;
    end;
end;

procedure TColorComboBoxEx.CreateWnd;
begin
  inherited CreateWnd;
  // Carga la lista de colores por omisión
  BuildList;
  // Color seleccionado por omisión
  SetColorValue(FColorValue);
end;

procedure TColorComboBoxEx.DrawItem(Index: Integer; Rect: TRect;
                                  State: TOwnerDrawState);
const
  ColorWidth = 22;
var
  DrawColor: TColor;
  ARect: TRect;
begin
  // De acuerdo a la forma de mostrar los colores
  if FShowStyle = ssOnlyText then     // Mostrar sólo texto
    inherited
  else
    begin
    // Color del elemento
    DrawColor := TColor(Items.Objects[Index]);
    // Rectángulo de color
    ARect := Rect;
    Inc(ARect.Top, 2);
    Inc(ARect.Left, 4);
    Dec(ARect.Bottom, 2);
    // Borra el cuadro de selección con el color actual
    Canvas.FillRect(Rect);
    if FShowStyle = ssOnlyColor then  // Mostrar sólo color
      Dec(ARect.Right, 4)
    else                              // Mostrar color y texto
      begin
      ARect.Right := ARect.Left + ColorWidth;
      Canvas.TextOut(ARect.Right + 8, ARect.Top, Items[Index]);
      end;
    // Dibuja el cuadro del elemento con el color especificado en "Index"
    with Canvas do
      begin
      Brush.Color := DrawColor;
      with ARect do
        Rectangle(Left, Top, Right, Bottom);
      end;
    end;
end;

procedure TColorComboBoxEx.Click;
begin
  // Guarda el color seleccionado
  if ItemIndex >= 0 then
    ColorValue := TColor(Items.Objects[ItemIndex]);

  inherited Click;
end;

procedure TColorComboBoxEx.CMFontChanged(var Message: TMessage);
begin
  inherited;
  // Si se muestra el color y texto
  if FShowStyle = ssColorAndText then
    begin
    // Recalcula el alto de la fuente
    ResetItemHeight;
    // Crea nuevamente el control
    RecreateWnd;
    end;
end;

procedure TColorComboBoxEx.ResetItemHeight;
var
  nuHeight: Integer;
begin
  // Establece un alto mínimo de 9 pixeles
  nuHeight := GetItemHeight(Font);
  if nuHeight < 9 then
     nuHeight := 9;
  ItemHeight := nuHeight;
end;

procedure TColorComboBoxEx.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TColorComboBoxEx.SetShowStyle(Value: TShowStyle);
begin
  if FShowStyle <> Value then
    begin
    FShowStyle := Value;
    Refresh;
    end;
end;

procedure Register;
begin
  RegisterComponents('Additional', [TFillStyleComboBox, TLineStyleComboBox,
	                                   TLineWidthComboBox, TColorComboBoxEx]);
end;

end.
