unit HKGraphics;

interface
uses windows,graphics,controls,types,math,HakaGeneral;

type
 TButtonState = (dbsNormal, dbsHot, dbsPressed, dbsDisabled);
 TButtonBmp = Array[TButtonState] of TBitmap;

 TRectF = Packed Record
  case Integer of
   0 : (Left,Top,Right,Bottom : Single);
   1 : (Data : Array[1..4] of Single);
 end;

Procedure BlendFromImageList(
 Source : TImageList; Index : Integer; Target : TCanvas; TR : TRect);
procedure BlendCanvas(Source : TBitmap; Target : TCanvas; TR : TRect);
procedure Stretch(NewWidth, NewHeight: Cardinal; Source: TBitmap);
Procedure MakeCoolImageList(ImageList,TargetList : TImageList; Buttons : TButtonBMP; TargetRect : TRect);
Procedure MakeBlendBitmap(Source,TargetShot : TBitmap; Target : TCanvas; TR : TRect);

function HSLRangeToRGB (H, S, L : integer): TColor;
procedure RGBtoHSLRange (RGB: TColor; Out H, S, L : integer);

Function CalcThumbNail(Original,FitIn : TPoint; Crop : Boolean) : TRect;
Procedure ModifyToAspect(Asp : Single; var Width,Height : Integer);

Function RectF(Left,Top,Right,Bottom : Single) : TRectF;
Procedure CheckRearrargeRectF(var RectF : TRectF);
Function ConvertToRectF(Rect : TRect; Size : TPoint) : TRectF;
Function ConvertToRect(RectF : TRectF; Size : TPoint) : TRect;

function GetBitmapSizeFromInfoHeader(Header: PBitmapInfoHeader): DWORD;
function GetDIBSizeFromInfoHeader(bi: PBITMAPINFOHEADER): DWORD;


implementation

Function ConvertToRectF(Rect : TRect; Size : TPoint) : TRectF;
begin
 result.Left:=Rect.Left / Size.X;
 result.Top:=Rect.Top / Size.Y;
 result.Right:=Rect.Right / Size.X;
 result.Bottom:=Rect.Bottom / Size.Y;
end;

Function ConvertToRect(RectF : TRectF; Size : TPoint) : TRect;
begin
 result.Left:=Round(RectF.Left * Size.X);
 result.Top:=Round(RectF.Top * Size.Y);
 result.Right:=Round(RectF.Right * Size.X);
 result.Bottom:=Round(RectF.Bottom * Size.Y);
end;

Function RectF(Left,Top,Right,Bottom : Single) : TRectF;
begin
 result.Left:=left;
 result.Top:=Top;
 result.Right:=Right;
 result.Bottom:=bottom;
end;

Procedure CheckRearrargeRectF(var RectF : TRectF);
begin
 with RectF do
 begin
  if Left>Right then Exchange(left,right);
  if Top>Bottom then Exchange(Top,Bottom);
 end;
end;

Procedure ModifyToAspect(Asp : Single; var Width,Height : Integer);
begin
 if asp>1 then
  Width:=Round( height*asp )
 else
  height:=Round(Width/Asp);
end;

Function CalcThumbNail(Original,FitIn : TPoint; Crop : Boolean) : TRect;
var
 w,h : Integer;
 zo,zf : single;
begin
 zo:=Original.X / Original.y;
 zf:=FitIn.X / FitIn.y;
 if ((Crop) and (zo<zf)) or
    ((not Crop) and (zo>zf)) then
  begin
   w:=FitIn.X;
   h:=round(w/zo);
  end
 else
  begin
   h:=FitIn.Y;
   w:=round(h*zo);
  end;

 result.Left:=(FitIn.X-w) div 2;
 result.Right:=result.Left+w;
 result.Top:=(FitIn.Y-h) div 2;
 result.Bottom:=result.Top+h;
end;

Procedure MakeBlendBitmap(Source,TargetShot : TBitmap; Target : TCanvas; TR : TRect);
begin
 targetshot.Width:=tr.Right-tr.Left;
 targetshot.height:=tr.Bottom-tr.Top;
 targetshot.Canvas.CopyRect(rect(0,0,targetshot.Width,targetshot.height),target,tr);
 BlendCanvas(source,targetshot.Canvas,tr);
end;

Procedure MakeCoolImageList(ImageList,TargetList : TImageList; Buttons : TButtonBMP; TargetRect : TRect);
var
 bs : TButtonState;
 i:integer;
 bmp : TBitmap;
begin
 For i:=Targetlist.Count-1 downto 0 do
  TargetList.Delete(i);
 TargetList.Width:=buttons[dbsNormal].Width;
 TargetList.Height:=buttons[dbsNormal].Height;
 TargetList.Masked:=false;

 bmp:=TBitmap.create;
 try
  for i:=0 to ImageList.count-1 do
  begin
   for bs:=low(TButtonState) to high(TButtonState) do
   begin
    bmp.Assign(buttons[bs]);
    blendFromImageList(imagelist,ord(i),bmp.Canvas,TargetRect);
    Targetlist.Add(bmp,nil);
   end;
  end;
 finally
  bmp.free;
 end;
end;

Procedure BlendFromImageList(
 Source : TImageList; Index : Integer; Target : TCanvas; TR : TRect);
var
 bmp : TBitmap;
begin
 bmp:=TBitmap.Create;
 try
  Source.GetBitmap(index,bmp);
  blendCanvas(bmp,target,tr);
 finally
  bmp.free;
 end;
end;

procedure BlendCanvas(Source : TBitmap; Target : TCanvas; TR : TRect);
var
 x,y,x1,y1 : INteger;
 c,d:Cardinal;
begin
  if (source.Width<>(tr.Right-tr.Left)) or
     (source.Height<>(tr.Bottom-tr.Top)) then
   Stretch(tr.Right-tr.Left,tr.Bottom-tr.Top,Source);

  x1:=tr.Left; y1:=tr.Top;
  for x:=0 to source.Width do
  begin
   for y:=0 to source.Height do
   begin
    c:=GetPixel(Source.Canvas.Handle,x,y);
    d:=GetPixel(target.Handle,x1,y1);
//    c:=Source.Canvas.Pixels[x,y];
//    d:=target.Pixels[x1,y1];

    //calc intensity
{    c:= Byte(c)       * 61 shr 8 +
        Byte(c shr 8) * 174 shr 8 +
        Byte(c shr 16)* 21 shr 8 ;}

    //make darker with spagetti!
//    c:=(((Byte(d) * c) shr 8) or (((Byte(d shr 8) * c) shr 8) shl 8) or (((Byte(d shr 16)* c) shr 8) shl 16));

    c:=(((Byte(d) * Byte(c)) shr 8) or (((Byte(d shr 8) * byte(c shr 8)) shr 8) shl 8) or
       (((Byte(d shr 16)* Byte(c shr 16)) shr 8) shl 16));
//    target.Pixels[x1,y1]:=c;
    SetPixel(target.Handle,x1,y1,c);
    inc(y1);
   end;
   inc(x1);
   y1:=tr.Top;
  end;
end;

//////////////////////////////////////////////////////////////////////////////////////////
//Stretch

type
  TRGBInt = record
    R: Integer;
    G: Integer;
    B: Integer;
  end;

  PBGR = ^TBGR;
  TBGR = packed record
    B: Byte;
    G: Byte;
    R: Byte;
  end;

  PPixelArray = ^TPixelArray;
  TPixelArray = array [0..0] of TBGR;

  TBitmapFilterFunction = function (Value: Single): Single;

  PContributor = ^TContributor;
  TContributor = record
   Weight: Integer; // Pixel Weight
   Pixel: Integer;  // Source Pixel
  end;

  TContributors = array of TContributor;

  // list of source pixels contributing to a destination pixel
  TContributorEntry = record
   N: Integer;
   Contributors: TContributors;
  end;

  TContributorList = array of TContributorEntry;


function IntToByte(Value: Integer): Byte;
begin
  Result := Math.Max(0, Math.Min(255, Value));
end;

procedure DoStretch(Filter: TBitmapFilterFunction; Radius: Single; Source, Target: TBitmap);
var
  ScaleX, ScaleY: Single; // Zoom scale factors
  I, J, K, N: Integer;    // Loop variables
  Center: Single;         // Filter calculation variables
  Width: Single;
  Weight: Integer;        // Filter calculation variables
  Left, Right: Integer;   // Filter calculation variables
  Work: TBitmap;
  ContributorList: TContributorList;
  SourceLine, DestLine: PPixelArray;
  DestPixel: PBGR;
  Delta, DestDelta: Integer;
  SourceHeight, SourceWidth: Integer;
  TargetHeight, TargetWidth: Integer;

  CurrentLineR: array of Integer;
  CurrentLineG: array of Integer;
  CurrentLineB: array of Integer;

 function ApplyContributors(N: Integer; Contributors: TContributors): TBGR;
 var
  J: Integer;
  RGB: TRGBInt;
  Total,
  Weight: Integer;
  Pixel: Cardinal;
  Contr: ^TContributor;
 begin
  RGB.R := 0;
  RGB.G := 0;
  RGB.B := 0;
  Total := 0;
  Contr := @Contributors[0];
  for J := 0 to N - 1 do
  begin
    Weight := Contr.Weight;
    Inc(Total, Weight);
    Pixel := Contr.Pixel;
    Inc(RGB.R, CurrentLineR[Pixel] * Weight);
    Inc(RGB.G, CurrentLineG[Pixel] * Weight);
    Inc(RGB.B, CurrentLineB[Pixel] * Weight);
    Inc(Contr);
  end;

  if Total = 0 then
  begin
    Result.R := IntToByte(RGB.R shr 8);
    Result.G := IntToByte(RGB.G shr 8);
    Result.B := IntToByte(RGB.B shr 8);
  end
  else
  begin
    Result.R := IntToByte(RGB.R div Total);
    Result.G := IntToByte(RGB.G div Total);
    Result.B := IntToByte(RGB.B div Total);
  end;
 end;

 procedure FillLineCache(N, Delta: Integer; Line: Pointer);
 var
  I: Integer;
  Run: PBGR;
 begin
  Run := Line;
  for I := 0 to N - 1 do
  begin
    CurrentLineR[I] := Run.R;
    CurrentLineG[I] := Run.G;
    CurrentLineB[I] := Run.B;
    Inc(PByte(Run), Delta);
  end;
 end;

begin
  // shortcut variables
  SourceHeight := Source.Height;
  SourceWidth := Source.Width;
  TargetHeight := Target.Height;
  TargetWidth := Target.Width;
  // create intermediate image to hold horizontal zoom
  Work := TBitmap.Create;
  try
    Work.PixelFormat := pf24Bit;
    Work.Height := SourceHeight;
    Work.Width := TargetWidth;
    if SourceWidth = 1 then
      ScaleX := TargetWidth / SourceWidth
    else
      ScaleX := (TargetWidth - 1) / (SourceWidth - 1);
    if SourceHeight = 1 then
      ScaleY := TargetHeight / SourceHeight
    else
      ScaleY := (TargetHeight - 1) / (SourceHeight - 1);

    // pre-calculate filter contributions for a row
    SetLength(ContributorList, TargetWidth);
    // horizontal sub-sampling
    if ScaleX < 1 then
    begin
      // scales from bigger to smaller Width
      Width := Radius / ScaleX;
      for I := 0 to TargetWidth - 1 do
      begin
        ContributorList[I].N := 0;
        Center := I / ScaleX;
        Left := Math.Floor(Center - Width);
        Right := Math.Ceil(Center + Width);
        SetLength(ContributorList[I].Contributors, Right - Left + 1);
        for J := Left to Right do
        begin
          Weight := Round(Filter((Center - J) * ScaleX) * ScaleX * 256);
          if Weight <> 0 then
          begin
            if J < 0 then
              N := -J
            else
              if J >= SourceWidth then
                N := SourceWidth - J + SourceWidth - 1
              else
                N := J;
            K := ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel := N;
            ContributorList[I].Contributors[K].Weight := Weight;
          end;
        end;
      end;
    end
    else
    begin
      // horizontal super-sampling
      // scales from smaller to bigger Width
      for I := 0 to TargetWidth - 1 do
      begin
        ContributorList[I].N := 0;
        Center := I / ScaleX;
        Left := Math.Floor(Center - Radius);
        Right := Math.Ceil(Center + Radius);
        SetLength(ContributorList[I].Contributors, Right - Left + 1);
        for J := Left to Right do
        begin
          Weight := Round(Filter(Center - J) * 256);
          if Weight <> 0 then
          begin
            if J < 0 then
              N := -J
            else
              if J >= SourceWidth then
                N := SourceWidth - J + SourceWidth - 1
              else
                N := J;
            K := ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel := N;
            ContributorList[I].Contributors[K].Weight := Weight;
          end;
        end;
      end;
    end;

    // now apply filter to sample horizontally from Src to Work

    SetLength(CurrentLineR, SourceWidth);
    SetLength(CurrentLineG, SourceWidth);
    SetLength(CurrentLineB, SourceWidth);
    for K := 0 to SourceHeight - 1 do
    begin
      SourceLine := Source.ScanLine[K];
      FillLineCache(SourceWidth, 3, SourceLine);
      DestPixel := Work.ScanLine[K];
      for I := 0 to TargetWidth - 1 do
        with ContributorList[I] do
        begin
          DestPixel^ := ApplyContributors(N, ContributorList[I].Contributors);
          // move on to next column
          Inc(DestPixel);
        end;
    end;

    // free the memory allocated for horizontal filter weights, since we need
    // the structure again
    for I := 0 to TargetWidth - 1 do
      ContributorList[I].Contributors := nil;
    ContributorList := nil;

    // pre-calculate filter contributions for a column
    SetLength(ContributorList, TargetHeight);
    // vertical sub-sampling
    if ScaleY < 1 then
    begin
      // scales from bigger to smaller height
      Width := Radius / ScaleY;
      for I := 0 to TargetHeight - 1 do
      begin
        ContributorList[I].N := 0;
        Center := I / ScaleY;
        Left := Math.Floor(Center - Width);
        Right := Math.Ceil(Center + Width);
        SetLength(ContributorList[I].Contributors, Right - Left + 1);
        for J := Left to Right do
        begin
          Weight := Round(Filter((Center - J) * ScaleY) * ScaleY * 256);
          if Weight <> 0 then
          begin
            if J < 0 then
              N := -J
            else
              if J >= SourceHeight then
                N := SourceHeight - J + SourceHeight - 1
              else
                N := J;
            K := ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel := N;
            ContributorList[I].Contributors[K].Weight := Weight;
          end;
        end;
      end;
    end
    else
    begin
      // vertical super-sampling
      // scales from smaller to bigger height
      for I := 0 to TargetHeight - 1 do
      begin
        ContributorList[I].N := 0;
        Center := I / ScaleY;
        Left := Math.Floor(Center - Radius);
        Right := Math.Ceil(Center + Radius);
        SetLength(ContributorList[I].Contributors, Right - Left + 1);
        for J := Left to Right do
        begin
          Weight := Round(Filter(Center - J) * 256);
          if Weight <> 0 then
          begin
            if J < 0 then
              N := -J
            else
            if J >= SourceHeight then
              N := SourceHeight - J + SourceHeight - 1
            else
              N := J;
            K := ContributorList[I].N;
            Inc(ContributorList[I].N);
            ContributorList[I].Contributors[K].Pixel := N;
            ContributorList[I].Contributors[K].Weight := Weight;
          end;
        end;
      end;
    end;

    // apply filter to sample vertically from Work to Target
    SetLength(CurrentLineR, SourceHeight);
    SetLength(CurrentLineG, SourceHeight);
    SetLength(CurrentLineB, SourceHeight);

    SourceLine := Work.ScanLine[0];
    Delta := Integer(Work.ScanLine[1]) - Integer(SourceLine);
    DestLine := Target.ScanLine[0];
    DestDelta := Integer(Target.ScanLine[1]) - Integer(DestLine);
    for K := 0 to TargetWidth - 1 do
    begin
      DestPixel := Pointer(DestLine);
      FillLineCache(SourceHeight, Delta, SourceLine);
      for I := 0 to TargetHeight - 1 do
        with ContributorList[I] do
        begin
          DestPixel^ := ApplyContributors(N, ContributorList[I].Contributors);
          Inc(Integer(DestPixel), DestDelta);
        end;
      Inc(SourceLine);
      Inc(DestLine);
    end;

    // free the memory allocated for vertical filter weights
    for I := 0 to TargetHeight - 1 do
      ContributorList[I].Contributors := nil;
    // this one is done automatically on exit, but is here for completeness
    ContributorList := nil;

  finally
    Work.Free;
    CurrentLineR := nil;
    CurrentLineG := nil;
    CurrentLineB := nil;
    Target.Modified := True;
  end;
end;

function BitmapHermiteFilter(Value: Single): Single;
begin
  if Value < 0.0 then
    Value := -Value;
  if Value < 1 then
    Result := (2 * Value - 3) * Sqr(Value) + 1
  else
    Result := 0;
end;

procedure Stretch(NewWidth, NewHeight: Cardinal; Source: TBitmap);
var
  Temp: TBitmap;
  Radius: Single;
begin
  if Source.Empty then
    Exit;               // do nothing

  Radius:=1;

  Temp := TBitmap.Create;
  try
    // To allow Source = Target, the following assignment needs to be done initially
    Temp.Assign(Source);
    Temp.PixelFormat := pf24Bit;

    source.FreeImage;
    source.PixelFormat := pf24Bit;
    source.Width := NewWidth;
    source.Height := NewHeight;

    if not source.Empty then
      DoStretch(BitmapHermiteFilter, Radius, Temp, Source);
  finally
    Temp.Free;
  end;
end;

{
procedure HSLToRGB(const H, S, L: Single; out R, G, B: Single);
var
  M1, M2: Single;

  function HueToColorValue(Hue: Single): Single;
  begin
    Hue := Hue - Floor(Hue);

    if 6 * Hue < 1 then
      Result := M1 + (M2 - M1) * Hue * 6
    else
    if 2 * Hue < 1 then
      Result := M2
    else
    if 3 * Hue < 2 then
      Result := M1 + (M2 - M1) * (2 / 3 - Hue) * 6
    else
      Result := M1;
  end;
    
begin
  if S = 0 then
  begin
    R := L;
    G := R;
    B := R;
  end
  else
  begin
    if L <= 0.5 then
      M2 := L * (1 + S)
    else
      M2 := L + S - L * S;
    M1 := 2 * L - M2;
    R := HueToColorValue(H - 1 / 3);
    G := HueToColorValue(H);
    B := HueToColorValue(H + 1 / 3)
  end;
end;

//--------------------------------------------------------------------------------------------------

procedure RGBToHSL(const R, G, B: Single; out H, S, L: Single);
var
  D, Cmax, Cmin: Single;
begin
  Cmax := Max(R, Max(G, B));
  Cmin := Min(R, Min(G, B));
  L := (Cmax + Cmin) / 2;

  if Cmax = Cmin then
  begin
    H := 0;
    S := 0
  end
  else
  begin
    D := Cmax - Cmin;
    if L < 0.5 then
      S := D / (Cmax + Cmin)
    else
      S := D / (2 - Cmax - Cmin);
    if R = Cmax then
      H := (G - B) / D
    else
      if G = Cmax then
        H := 2 + (B - R) / D
      else
        H := 4 + (R - G) / D;
    H := H / 6;
    if H < 0 then
      H := H + 1;
  end;
end;

Function HSLToColor(H, S, L: Single) : TColor;
var r,g,b : Single;
begin
 if h<0 then h:=0;
 if s<0 then s:=0;
 if l<0 then l:=0;

 if h>240 then h:=240;
 if s>240 then s:=240;
 if l>240 then l:=240;

 HSLTORGB(h/240,s/240,l/240,r,g,b);
 result:=RGB(round(r*255),round(g*255),round(b*255));
end;

Procedure ColorToHSL(Color : TColor; out H, S, L: Single);
begin
 color:=ColorToRgb(color);
 RGBTOHSL(GetRValue(color)/255,getGValue(color)/255,GetBValue(color)/255,h,s,l);
 h:=h*240;
 s:=s*240;
 l:=l*240;
end;
}

// convert a HSL value into a RGB in a TColor
// HSL values are 0.0 to 1.0 double
function HSLtoRGB (H, S, L: double): TColor;
var
  M1,
  M2: double;

  function HueToColourValue (Hue: double) : byte;
  var
    V : double;
  begin
    if Hue < 0 then
      Hue := Hue + 1
    else
      if Hue > 1 then
        Hue := Hue - 1;

    if 6 * Hue < 1 then
      V := M1 + (M2 - M1) * Hue * 6
    else
      if 2 * Hue < 1 then
        V := M2
      else
        if 3 * Hue < 2 then
          V := M1 + (M2 - M1) * (2/3 - Hue) * 6
        else
          V := M1;
    Result := round (255 * V)
  end;

var
  R,
  G,
  B: byte;
begin
  if S = 0 then
  begin
    R := round (255 * L);
    G := R;
    B := R
  end else begin
    if L <= 0.5 then
      M2 := L * (1 + S)
    else
      M2 := L + S - L * S;
    M1 := 2 * L - M2;
    R := HueToColourValue (H + 1/3);
    G := HueToColourValue (H);
    B := HueToColourValue (H - 1/3)
  end;

  Result := RGB (R, G, B)
end;

// convert a RGB value (as TColor) into HSL
// HSL values are 0.0 to 1.0 double

// Convert RGB value (0-255 range) into HSL value (0-1 values)

procedure RGBtoHSL (RGB: TColor; var H, S, L : double);

  function Max (a, b : double): double;
  begin
    if a > b then
      Result := a
    else
      Result := b
  end;

  function Min (a, b : double): double;
  begin
    if a < b then
      Result := a
    else
      Result := b
  end;

var
  R,
  G,
  B,
  D,
  Cmax,
  Cmin: double;

begin
  R := GetRValue (RGB) / 255;
  G := GetGValue (RGB) / 255;
  B := GetBValue (RGB) / 255;
  Cmax := Max (R, Max (G, B));
  Cmin := Min (R, Min (G, B));

// calculate luminosity
  L := (Cmax + Cmin) / 2;

  if Cmax = Cmin then  // it's grey
  begin
    H := 0; // it's actually undefined
    S := 0
  end else begin
    D := Cmax - Cmin;

// calculate Saturation
    if L < 0.5 then
      S := D / (Cmax + Cmin)
    else
      S := D / (2 - Cmax - Cmin);

// calculate Hue
    if R = Cmax then
      H := (G - B) / D
    else
      if G = Cmax then
        H  := 2 + (B - R) /D
      else
        H := 4 + (R - G) / D;

    H := H / 6;
    if H < 0 then
      H := H + 1
  end
end;

Const
  HSLRange : integer = 240;

function HSLRangeToRGB (H, S, L : integer): TColor;
begin
  Result := HSLToRGB ((H-1) / (HSLRange-1), S / HSLRange, L / HSLRange)
end;

procedure RGBtoHSLRange (RGB: TColor; Out H, S, L : integer);
var
  Hd,
  Sd,
  Ld: double;
begin
  RGBtoHSL (RGB, Hd, Sd, Ld);
  H := round (Hd * (HSLRange-1)) + 1;
  S := round (Sd * HSLRange);
  L := round (Ld * HSLRange);
end;

function WIDTHBYTES(bits: DWORD): DWORD;
begin
  result := DWORD((bits+31) and (not 31)) div 8;
end;

function DIBWIDTHBYTES(bi: PBITMAPINFOHEADER): DWORD;
begin
  result := DWORD(WIDTHBYTES(DWORD(bi.biWidth) * DWORD(bi.biBitCount)));
end;

function GetDIBSizeFromInfoHeader(bi: PBITMAPINFOHEADER): DWORD;
begin
   result := DIBWIDTHBYTES(bi) * DWORD(bi.biHeight);
end;

function GetBitmapSizeFromInfoHeader(Header: PBitmapInfoHeader): DWORD;
begin
 if (Header.biHeight < 0) then result := -1 * GetDIBSizeFromInfoHeader(Header)
 else result := GetDIBSizeFromInfoHeader(Header);
end;


end.


{
Function ColorExists(bmp : TBitmap; Color : TColor): Boolean;
var x,y : Integer;
begin
 result:=true;
 for x:=0 to bmp.Width-1 do
  for y:=0 to bmp.Height-1 do
   if bmp.Canvas.Pixels[x,y]=Color then exit;
 result:=false;
end;


Procedure ConvertFileToGlyph(Const InputFile : String; Size : Integer; OutBmp : TBitmap);
var
 IsIco : Boolean;
 Ico : TIcon;
 BMP,Mask : TBitmap;
 x,y,i : Integer;
 MaskColor : TColor;
begin
 IsIco:=Uppercase(ExtractFileExt(inputfile))='.ICO';

 BMP:=TBitmap.Create;
 Mask:=TBitmap.Create;
 try

  OutBmp.Width:=Size;
  OutBmp.Height:=size;

  if IsIco then
   begin
    Ico:=TIcon.Create;
    Ico.LoadFromFile(InputFile);
    Mask.Width:=size;
    Mask.Height:=size;
    bmp.Width:=ico.Width;
    bmp.Height:=ico.Height;

    DrawIconEx(bmp.Canvas.Handle,0,0,Ico.Handle,ico.Width,ico.Height,0,0,DI_NORMAL);
    DrawIconEx(Mask.canvas.Handle,0,0,Ico.Handle,size,size,0,0,DI_MASK);

    Ico.free;
   end
  else
   begin
    bmp.LoadFromFile(inputfile);
    mask.Handle:=bmp.MaskHandle;
   end;

  Stretch(size,size,bmp);
  Outbmp.Canvas.Draw(0,0,bmp);

  repeat
   MaskColor

  mask.Mask(clred);


 finally
  BMP.free;
  Mask.free;
 end;
end;


