unit HakaGDIPlus;

interface

uses Windows,Graphics,Types,GDIPUTIL,GDIPAPI,GDIPOBJ,HKGraphics;

Function ImageToHBitmap(Image: TGPImage) : TBitmap;
procedure DrawHBitmap(Graphics : TGPGraphics; BMP : TBitmap);
Procedure ResizeGPImage(var Image: TGPImage; NewWidth,NewHeight : Cardinal);
Procedure ResizeFitGPImage(var Image: TGPImage; NewWidth,NewHeight : Cardinal; R : TGPRect);
// Destroys old image, replaces with new !

implementation

Procedure ResizeFitGPImage(var Image: TGPImage; NewWidth,NewHeight : Cardinal; R : TGPRect);
var
 Temp : TGPBitmap;
 G : TGPGraphics;
begin
 Temp:=TGPBitmap.Create(NewWidth,NewHeight,Image.GetPixelFormat);
 G:=TGPGraphics.Create(Temp);
 g.DrawImage(image,r);
// G.SetInterpolationMode(InterpolationModeHighQualityBicubic);
// G.SetInterpolationMode(InterpolationModeLowQuality);
 g.free;
 Image.Free;
 Image:=Temp;
end;


Procedure ResizeGPImage(var Image: TGPImage; NewWidth,NewHeight : Cardinal);
var
 Temp : TGPBitmap;
 G : TGPGraphics;
begin
 Temp:=TGPBitmap.Create(NewWidth,NewHeight,Image.GetPixelFormat);
 G:=TGPGraphics.Create(Temp);
// G.SetInterpolationMode(InterpolationModeHighQualityBicubic);
// G.SetInterpolationMode(InterpolationModeLowQuality);
 G.DrawImage(Image,0,0,NewWidth,NewHeight);
 g.free;
 Image.Free;
 Image:=Temp;
end;

procedure DrawHBitmap(Graphics : TGPGraphics; BMP : TBitmap);
var
 Temp : TGPBitmap;
begin
 temp:=TGPBitmap.Create(Bmp.Handle,0);
 try
  Graphics.DrawImage(Temp,0,0);
 finally
  temp.free;
 end;
end;

Function ImageToHBitmap(Image: TGPImage) : TBitmap;
var
 bmp : TGPBitmap;
 handle : HBitmap;
begin
 if Image is TGPBitmap then
  bmp:=TGPBitmap(Image)
 else
  begin
   bmp:=nil;
   assert(false,'Not Implemented');
  end;

 result:=TBitmap.Create;
 if assigned(bmp) then
  bmp.GetHBITMAP(0,handle);
 result.Handle:=handle;
 result.PixelFormat:=pf24bit;
end;

end.
