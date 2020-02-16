unit HKThemes;

interface
uses Themes,Graphics,types,jclGraphics,uxTheme,VirtualTrees,hakahyper;

Function DrawExplorerBar(Canvas : TCanvas; R : TRect; teb : TThemedExplorerBar) : Boolean; overload;
Function DrawExplorerBar(Bmp : TBitmap; R:Trect; teb : TThemedExplorerBar) : Boolean; overload;
Function DrawButton(Canvas : TCanvas; R : TRect; But : TThemedButton) : Boolean;
Procedure SetVirtualTree(VST : TVirtualStringTree);

var
 ExplorerBarStartGrad : TColor = $00E7A684;
 ExplorerBarEndGrad : TCOlor = $00D7692F;

implementation

Procedure SetVirtualTree(VST : TVirtualStringTree);
var
 exp : TThemedExplorerBar;
 Details: TThemedElementDetails;
 c : Cardinal;
begin
 DrawExplorerBar(vst.Background.Bitmap,vst.ClientRect,tebExplorerBarRoot);
 vst.TreeOptions.PaintOptions:=vst.TreeOptions.PaintOptions + [toShowBackGround];
 if themeservices.ThemesEnabled then
  begin
   exp:=tebExplorerBarRoot;
   details:=themeservices.GetElementDetails(exp);
   GetThemeColor(ThemeServices.Theme[teExplorerBar],details.Part,details.State,TMT_GRADIENTCOLOR2,c);
  end
 else
  c:=ExplorerBarStartGrad;

 vst.Colors.FocusedSelectionColor:=LighterColor(c,-50,50,200);
 vst.Colors.FocusedSelectionBorderColor:=LighterColor(c,-25,50,200);
 vst.Colors.UnFocusedSelectionColor:=vst.Colors.FocusedSelectionColor;
 vst.Colors.UnFocusedSelectionBorderColor:=vst.Colors.FocusedSelectionBorderColor;
end;

Function DrawButton(Canvas : TCanvas; R : TRect; But : TThemedButton) : Boolean;
var
 Details: TThemedElementDetails;
begin
 result:=themeServices.ThemesEnabled;
 if result then
  begin
   details:=themeservices.GetElementDetails(But);
   ThemeServices.DrawElement(canvas.Handle,details,r);
  end
 else
  case But of
   tbPushButtonNormal : FillGradient(canvas.Handle,r,100,ExplorerBarStartGrad,ExplorerBarEndGrad,gdHorizontal);
  end;
end;

Function DrawExplorerBar(Canvas : TCanvas; R : TRect; teb : TThemedExplorerBar) : Boolean;
var
 Details: TThemedElementDetails;
begin
 result:=themeServices.ThemesEnabled;
 if result then
  begin
   details:=themeservices.GetElementDetails(teb);
   ThemeServices.DrawElement(canvas.Handle,details,r);
  end
 else
  case teb of
   tebExplorerBarRoot : FillGradient(canvas.Handle,r,100,ExplorerBarStartGrad,ExplorerBarEndGrad,gdVertical);
   tebHeaderBackgroundNormal : FillGradient(canvas.Handle,r,100,ExplorerBarStartGrad,ExplorerBarEndGrad,gdVertical);
  end;
end;



Function DrawExplorerBar(Bmp : TBitmap; R:Trect; teb : TThemedExplorerBar) : Boolean;
begin
 bmp.Width:=r.Right-r.Left;
 bmp.Height:=r.Bottom-r.Top;
 result:=DrawExplorerBar(bmp.Canvas,bmp.Canvas.ClipRect,teb);
end;


end.
