unit PrintFrm; //modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,OptOptions,EditorFrm, OptFolders, ExtCtrls,OptProcs,
  Printers,dcMemo,StdCtrls,hakageneral, Buttons, jvSpin,
  ExplorerFrm,ScriptInfoUnit,hyperstr,agproputils,parsersmdl, JvPlacemnt,
  JvEdit, Mask, JvMaskEdit;

type
  TPrintForm = class(TForm)
    PrinterSetupDialog: TPrinterSetupDialog;
    ScrollBox: TScrollBox;
    Image: TImage;
    SaveDialog: TSaveDialog;
    GroupBox1: TGroupBox;
    edEndLine: TjvSpinEdit;
    edStartLine: TjvSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    lblPages: TLabel;
    GroupBox2: TGroupBox;
    btnPreview: TButton;
    edPrevPage: TjvSpinEdit;
    Label3: TLabel;
    btnExport: TButton;
    PrintBox: TGroupBox;
    btnSetup: TButton;
    btnPrint: TButton;
    btnCancel: TButton;
    btnPrintPage: TButton;
    lblStatus: TLabel;
    FormStorage: TjvFormStorage;
    cbSelection: TCheckBox;
    procedure btnSetupClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnExportClick(Sender: TObject);
    procedure edStartLineChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnPrintPageClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure cbSelectionClick(Sender: TObject);
  private
    PPI,PageWidth,PageHeight : Integer;
    NoPrinter : Boolean;
    SelStart,SelEnd : Integer;
    CancelPress : Boolean;
    firstResize:boolean;
    TempOptions : TOptiOptions;
    OldBS : TBorderStyle;
    RealLines,MaxPage,RealBottom : Integer;
    FirstPage : Boolean;
    mem : TDCMemo;
    PrintRect : TRect;
    procedure ScaleMemo;
    procedure Preview(Page: Integer);
    procedure CenterImage;
    procedure CalcMaxPage;
    procedure Print(Page: Integer);
    function WBPosition(Y: Integer): Integer;
    procedure SetStartWinPos(Page: Integer);
    function PageStr(Page: Integer): String;
    procedure UpdateAll;
  public
    procedure Initialize;
    procedure DeInitialize;
  end;

var
  PrintForm: TPrintForm;

implementation

{$R *.dfm}

procedure TPrintForm.Initialize;
var
 i:integer;
const
 cbstr : array[boolean] of string = ('Selection','All');
begin
 EditorForm.Visible:=false;
 OldBS:=EditorForm.memEditor.BorderStyle;
 EditorForm.memEditor.BorderStyle:=bsNone;
 EditorForm.Parent:=nil;
 EditorForm.Top:=0;
 EditorForm.Left:=0;
 NoPrinter:=Printer.Printers.Count=0;
 lblStatus.Caption:='';
 firstResize:=true;
 Constraints.MinHeight:=PrintBox.Top+printbox.Height+60;
 mem:=EditorForm.memEditor;
 cbSelection.Caption:=cbStr[mem.sellength=0];
 TempOptions:=TOptiOptions.Create;
 TempOptions.Assign(Options);
 i:=mem.Lines.Count;
 mem.WinLinePos:=0;
 mem.WinCharPos:=0;

 edStartline.MaxValue:=i;
 edEndline.MaxValue:=i;
 edEndLine.Value:=i;
 edStartLine.Value:=1;

 if mem.SelLength>0 then
  begin
   SelStart:=mem.MemoSource.SelectionRect.Top+1;
   SelEnd:=mem.MemoSource.SelectionRect.Bottom+1;
   if mem.MemoSource.SelectionRect.right=0 then
    dec(selEnd);
  end
 else
  begin
   selStart:=0;
   selend:=i;
  end;
 mem.MemoSource.SelectionRect:=rect(0,0,0,0);
 UpdateAll;
end;

procedure TPrintForm.UpdateAll;
var
 i:integer;
begin
 Options.printingNow:=true;
 Options.FontAliased:=true;
 Options.UseMonoFont:=false;
 options.SyntaxHighlight:=options.PrintSyntax;
 options.LineLookAhead:=5000;
 options.BoxLookAhead:=5000;
 Options.FontName:=options.PrintFontName;
 if options.PrintOvLines then
 with options do
 begin
  i:=PrintOvLinesWidth;
  Line1Width:=i;
  Line2Width:=i;
  Line3Width:=i;
  Line4Width:=i;
  Line5Width:=i;
  Line6Width:=i;
  Line1Pen:=psSolid;
  Line2Pen:=psSolid;
  Line3Pen:=psSolid;
  Line4Pen:=psSolid;
  Line5Pen:=psSolid;
  Line6Pen:=psSolid;
 end;

 with options do
 if PrintOnlySolid then
  begin
   BoxBr1Brush:=bsSolid;
   BoxBr2Brush:=bsSolid;
   BoxBr3Brush:=bsSolid;
   BoxBr4Brush:=bsSolid;
   BoxBr5Brush:=bsSolid;
   BoxBr6Brush:=bsSolid;
   BoxPar1Brush:=bsSolid;
   BoxPar2Brush:=bsSolid;
   BoxPar3Brush:=bsSolid;
   BoxPar4Brush:=bsSolid;
   BoxPar5Brush:=bsSolid;
   BoxPar6Brush:=bsSolid;
   BoxPodBrush:=bsSolid;
   BoxHereDocBrush:=bsSolid;
  end
 else
  begin
   BoxBr1Brush:=bsClear;
   BoxBr2Brush:=bsClear;
   BoxBr3Brush:=bsClear;
   BoxBr4Brush:=bsClear;
   BoxBr5Brush:=bsClear;
   BoxBr6Brush:=bsClear;
   BoxPar1Brush:=bsClear;
   BoxPar2Brush:=bsClear;
   BoxPar3Brush:=bsClear;
   BoxPar4Brush:=bsClear;
   BoxPar5Brush:=bsClear;
   BoxPar6Brush:=bsClear;
   BoxPodBrush:=bsClear;
   BoxHereDocBrush:=bsClear;
  end;

 OPtions.EditorColor:=clWhite;
 Options.GutterColor:=clWhite;
 options.FoldGutColor:=clWhite;
 Options.LineEnable:=false;
 options.BoxEnable:=false;

 PC_optionsUpdated(HKO_BigVisible);
 Options.LineEnable:=options.PrintLines;
 options.BoxEnable:=options.PrintBoxes;

 with EditorForm do
 begin
  memEditor.ScrollBars:=ssNone;
  memEditor.Options:=memEditor.Options-[moDrawGutter];
  memEditor.Options:=memEditor.Options-[moLineNumbersOnGutter];
  memEditor.Options:=memEditor.Options-[moHideInvisibleLines];
  memEditor.Options:=memEditor.Options-[moDrawMargin];
  memEditor.Options:=memEditor.Options-[moBreakWordAtMargin];
  if options.PrintLineNumbers
   then memEditor.Options:=memEditor.Options+[moLineNumbers]
   else memEditor.Options:=memEditor.Options-[moLineNumbers];

  memEditor.LineHighlight.Visible:=false;
  memEditor.WordWrap:=true;
  memEditor.Background.FreeImage;
 end;
 RealLines:=0;
 ScaleMemo;
end;

Function TPrintForm.WBPosition(Y : Integer) : Integer;
var
 tp : TPoint;
begin
 tp:=mem.GetWBPosition(point(0,y));
 result:=tp.y;
end;

procedure TPrintForm.DeInitialize;
begin
 Options.Assign(TempOptions);
 options.PrintingNow:=false;
 TempOptions.Free;
 with EditorForm do
  memEditor.ScrollBars:=ssBoth;
 PC_optionsUpdated(HKO_BigVisible);
 EditorForm.memEditor.BorderStyle:=OldBS;
 EditorForm.loadBMP;
 EditorForm.Parent:=EditorForm.DockControl;
 EditorForm.Visible:=true;
end;

Procedure TPrintForm.CalcMaxPage;
var h:integer;
begin
 if reallines=0 then exit;
 h:=WBPosition(edEndLine.AsInteger) -
    WBPosition(edStartLine.AsInteger-1) +1 ;
 if h<=0 then exit;
 MaxPage:=h div RealLines;
 h:=h mod reallines;
 if h<>0 then
  inc(maxPage);
 if maxpage<=0 then maxpage:=1;
 if EdPrevPage.Value>maxpage then
  edPrevPage.Value:=maxpage;
 EdPrevPage.MaxValue:=maxpage;
 EdPrevPage.MInValue:=1;
 edPrevPage.enabled:=maxPage>1;
 lblPages.caption:=InttOstr(MaxPage)+' total page(s)';
end;

Procedure TPrintForm.ScaleMemo;
var
 y,H,ppiW,ppiH : Integer;
begin
 try
  ppiW:=GetDeviceCaps(printer.Handle,LOGPIXELSX);
  ppi:=ppiW;
  ppiH:=GetDeviceCaps(printer.Handle,LOGPIXELSY);
  PageWidth:=printer.PageWidth;
  PageHeight:=printer.PageHeight;
  NoPrinter:=false;
 except
  on exception do
  begin
   NoPrinter:=true;
   btnPrint.Enabled:=false;
   btnPrintPage.Enabled:=false;
   btnSetup.Enabled:=false;
   MessageDlg('Could not find printer.', mtError, [mbOK], 0);
   ppiW:=300; ppiH:=300;
   Pagewidth:=round(8.5*PPIW);
   Pageheight:=round(11*PPIH);
  end;
 end;

 try
  PrintRect.Top:=Round(options.PrintMarginTop*ppih);
  PrintRect.Left:=Round(options.PrintMarginLeft*ppiw);
  PrintRect.Right:=Round(Pagewidth-options.PrintMarginRight*ppiw);
  PrintRect.Bottom:=Round(Pageheight-options.PrintMarginBottom*ppih);
  RealBottom:=PrintRect.Bottom;
  y:=PrintRect.Bottom-PrintRect.Top;
  h:=round((printrect.bottom-printrect.top)/Options.PrintLinesPerPage);

  mem.Font.Size:=round(-h * 72/mem.Font.PixelsPerInch);
  options.FontSize:=mem.Font.Size;

  ParsersMod.SetSyntax(options);

  reallines:=y div mem.LineHeight;
  PrintRect.Bottom:=printrect.Top+mem.LineHeight;

  with EditorForm do
  begin
   width:=(width-mem.ClientWidth)+ (PrintRect.Right-PrintRect.Left);
   height:=(height-mem.ClientHeight)+ (printrect.Bottom-printrect.Top);

   h:=(mem.ClientHeight div mem.LineHeight);
   height:=(height-(mem.ClientHeight-h*mem.LineHeight));

   h:=mem.ClientWidth div mem.CharWidth;
   Width:=(Width-(mem.ClientWidth-h*mem.CharWidth));
  end;
  mem.MarginPos:=mem.ClientWidth div mem.CharWidth - 1;

  calcMaxPage;

  mem.WinLinePos:=0;
  mem.WinCharPos:=0;
  ExplorerForm.UpdateRightNow;
  while ExplorerForm.Showing=nil do
   application.ProcessMessages;
 except on exception do
  MessageDlg('Cannot Preview.', mtError, [mbOK], 0);
 end;
end;

Procedure TPrintForm.CenterImage;
var gotop : boolean;
begin
 gotop:=false;
 if (image.Picture.Bitmap.Height=0) or
    (image.Picture.Bitmap.Width=0) then exit;

 Image.Width:=
  round( (image.Height/image.Picture.Bitmap.Height)*Image.Picture.Bitmap.Width );
 if image.Width<Scrollbox.ClientWidth
  then Image.Left:=(ScrollBox.ClientWidth - Image.Width) div 2
  else GoTop:=true;
 if image.Height<Scrollbox.ClientHeight
  then Image.Top:=(ScrollBox.ClientHeight - Image.Height) div 2
  else GoTop:=true;
 if GoTop then
 begin
  ScrollBOx.HorzScrollBar.Position:=0;
  ScrollBOx.VertScrollBar.Position:=0;
  image.Left:=5;
  image.Top:=5;
  ScrollBox.HorzScrollBar.Range:=image.Width+10;
  ScrollBox.VertScrollBar.Range:=image.Height+10;
 end;
end;

procedure TPrintForm.SetStartWinPos(Page : Integer);
var i:integer;
begin
 i:=WBPosition(edStartLine.AsInteger-1);
 i:=i+page*realLines;
 mem.WinLinePos:=i;
end;

procedure TPrintForm.Print(Page : Integer);
var
 MetaFile : TMetafile;
 i,y,p,endline : integer;
begin
 SetStartWinPos(Page);
 endline:=WBPosition(edEndLine.AsInteger);

 with Image.Picture do
  Bitmap:=nil;

 lblStatus.Caption:='Sending page '+inttostr(page+1);
 Application.ProcessMessages;

 MetaFile:=TMetaFile.Create;
 MetaFile.Width:=printrect.Right-printrect.left;
 MetaFile.height:=mem.LineHeight;
 y:=0;

 try
  for i:=1 to reallines do
  begin
   mem.DrawToMetaFile(Metafile,0);
   Application.ProcessMessages;

   if not CancelPress then
    printer.Canvas.Draw(printrect.Left,printrect.Top+y,MetaFile);

   p:=mem.WinLinePos;
   mem.WinLinePos:=mem.WinLinePos+1;
   if mem.WinLinePos=p then break;
   if mem.WinLinePos>=endline then break;
   inc(y,EditorForm.memEditor.LineHeight-1); /// -1 !!!
  end;

  with printer.Canvas do
  begin
   brush.Color:=clWhite;
   y:=printrect.Top+y+EditorForm.memEditor.LineHeight+4;
   printer.Canvas.FillRect(rect(0,0,printer.PageWidth,printrect.Top-1));
   printer.Canvas.FillRect(rect(0,y,printer.PageWidth,printer.PageHeight));
  end;

  if options.PrintFooter then
  begin
    inc(y,EditorForm.memEditor.LineHeight);
    printer.Canvas.Font:=mem.Font;
    printer.Canvas.Font.Height:=round(EditorForm.memEditor.LineHeight*0.7);
    printer.Canvas.TextOut(printrect.Left,RealBottom,PageStr(page));
  end;

 finally
   Metafile.Free;
 end

end;

Function TPrintForm.PageStr(Page : Integer) : String;
begin
 result:=format('%s   -   Page %d of %d',[activescriptinfo.path,page+1,maxpage]);
end;

Procedure TPrintForm.Preview(Page : Integer);
var
 bmp : TBitmap;
 i,y,p,endline : integer;
 z : Real;
 r:trect;
begin
 SetStartWinPos(Page);
 endline:=WBPosition(edEndLine.AsInteger);

  with Image.Picture do
  begin
   try
    Bitmap:=nil;
    bitmap.PixelFormat:=pf16bit;
    Bitmap.Width:=imin(PageWidth,image.Width);
    z:=bitmap.Width / PageWidth;
    bitmap.Height:=round(Pageheight * z);
    r.Left:=round(printrect.Left*z);
    r.Right:=round(printrect.Right*z);
   except
    on exception do
    begin
     image.Picture.Bitmap:=nil;
     btnExport.Enabled:=false;
     lblStatus.Caption:='Non enough memory';
     exit;
    end;
   end;
  end;

  y:=0;
  bmp:=TBitmap.Create;
  try
   bmp.Width:=printrect.Right-printrect.left;
   bmp.height:=printrect.Bottom-printrect.Top;

   for i:=1 to reallines do
   begin
    EditorForm.memEditor.PaintTo(bmp.Canvas,0,0);
    r.Top:=round((printrect.Top+y)*z);
    r.Bottom:=r.Top+round(editorform.memeditor.lineheight*z);
    image.Picture.Bitmap.Canvas.StretchDraw(r,bmp);
    p:=mem.WinLinePos;
    mem.WinLinePos:=mem.WinLinePos+1;
    if mem.WinLinePos=p then break;
    if mem.WinLinePos>=endline then break;
    inc(y,EditorForm.memEditor.LineHeight);
   end;

   if options.PrintFooter then
   begin
    image.Canvas.Font:=mem.Font;
    image.Canvas.Font.height:=round(editorform.memeditor.lineheight*z*0.7);
    image.Canvas.Textout(r.Left,round(realbottom*z),pagestr(page));
   end;
  finally
   bmp.free;
  end;
end;

procedure TPrintForm.btnSetupClick(Sender: TObject);
begin
 if PrinterSetupDialog.Execute
  then ScaleMemo;
end;

procedure TPrintForm.btnPreviewClick(Sender: TObject);
begin
 btnExport.Enabled:=true;
 Preview(EdPrevPage.AsInteger-1);
 CenterImage;
end;

procedure TPrintForm.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
 scale:Real;
 w,h : integer;
begin
 with image.Picture.Bitmap do
  if (width=0) or (height=0) then exit;
 if button=mbLeft
  then scale:=1.45
 else
 if button=mbright
  then scale:=0.75
 else
  exit;

 w:=image.Picture.Bitmap.Width;
 h:=image.Picture.Bitmap.Height;

 image.width:=imid(scrollbox.Width div 4,round(Image.width*scale),2000);
 image.Height:=Round((h/w)*image.Width);
 CenterImage;
end;

procedure TPrintForm.btnExportClick(Sender: TObject);
begin
 if Image.Picture.Bitmap.Width=0 then exit;
 if SaveDialog.Execute then
  Image.Picture.Bitmap.SaveToFile(SaveDialog.FileName);
end;

procedure TPrintForm.edStartLineChange(Sender: TObject);
var ok : boolean;
begin
 CalcMaxPage;
 ok:=edStartLine.Value<=edEndLine.Value;
 SetGroupEnable([btnPrint,btnPrintPage,btnExport,btnPreview],ok);
 if (ok) and (NoPrinter) then
  SetGroupEnable([btnPrint,btnPrintPage],false);
end;

procedure TPrintForm.FormResize(Sender: TObject);
begin
 if FirstResize then
 begin
  image.Height:=scrollbox.Height-10;
  image.Width:=scrollbox.Width-10;
  firstResize:=false;
 end;
end;

procedure TPrintForm.btnPrintPageClick(Sender: TObject);
begin
 printer.Title:='OptiPerl - '+ExtractFilename(ActiveScriptInfo.path);
 try
  Printer.BeginDoc;
 except on exception do end;

 try
  if not printer.Printing then exit;
 except on exception do exit; end;

 try
  Print(EdPrevPage.AsInteger-1);
 except on exception do end;

 try
  if printer.Printing then
   printer.EndDoc;
 except on exception do end;

 lblStatus.Caption:='Finished';
end;

procedure TPrintForm.btnPrintClick(Sender: TObject);
var i:integer;
begin
 if not (MessageDlg('Start printing selected pages?', mtConfirmation, [mbYes,mbCancel], 0) = mrYes) then
 begin
  modalresult:=mrNone;
  exit;
 end;
 CalcMaxPage;
 btnPrint.Enabled:=false;
 btnPreview.Enabled:=false;
 edStartLine.Enabled:=false;
 edEndLine.Enabled:=false;
 btnExport.Enabled:=false;
 btnSetup.Enabled:=false;
 btnPrintPage.Enabled:=false;
 FirstPage:=true;
 printer.Title:='OptiPerl - '+ExtractFilename(ActiveScriptInfo.path);

 try
  Printer.BeginDoc;
 except on exception do end;

 try
  if not printer.Printing then exit;
 except on exception do exit; end;

 try
  for i:=0 to maxPage-1 do
  if not CancelPress then
  begin
   if not FirstPage
    then printer.NewPage
    else FirstPage:=false;
   if printer.Aborted then Exit;
   print(i);
  end;
 finally
  if (not CancelPress) and (printer.Printing) then
   printer.EndDoc;
 end;
end;

procedure TPrintForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=not printer.Printing;
end;

procedure TPrintForm.btnCancelClick(Sender: TObject);
begin
 CancelPress:=true;
 if printer.Printing then printer.Abort;
end;

procedure TPrintForm.cbSelectionClick(Sender: TObject);
begin
 edStartLine.Enabled:=not cbSelection.Checked;
 edEndLine.Enabled:=not cbSelection.Checked;
 if cbSelection.Checked then
  begin
   edStartLine.Value:=SelStart;
   edEndLine.Value:=SelEnd;
  end
 else
  begin
   edStartLine.Value:=1;
   edEndLine.Value:=mem.Lines.Count;
  end;
 CalcMaxPage;
end;

end.
