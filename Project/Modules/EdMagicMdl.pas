unit EdMagicMdl;  //Module
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dcstring, dccommon, dcmemo, StdCtrls,hyperstr, VirtualTrees,DIPcre,
  ExtCtrls,hakafile,hakageneral,hakahyper,hkClasses, ExplorerFrm, EditorFrm,
  ScriptInfoUnit, ImgList, OptOptions,AgPropUtils,OptMessage,
  OptGeneral,HKDebug,OptProcs;

Const
 MaxLines = 6;
 MaxHighLights = 4;

type
  TLineData = record
   Visible: Boolean;
   Color : TColor;
   Width : Byte;
   Style : TPenStyle;
  end;

  TBoxData = record
   Visible : Boolean;
   Color : TColor;
   Brush : TBrushStyle;
   CX,CY : Integer;
  end;

  TEdMagicMod = class(TDataModule)
    ImageList: TImageList;
    procedure DataModuleCreate(Sender: TObject);
  private
    OldPColor,OldBColor : TColor;
    OldBStyle : TBrushStyle;
    OldPStyle:TPenStyle;
    OldPWidth : Integer;
    OldPMode:TPenMode;

    FoldPrevious : Array of Integer;
    FoldProcess : Set of TFoldType;
    FoldCollState : Array[TFoldType] of Boolean;
    BoxNonMonoWidth : Integer;
    RealWidthStart,WidthStart,WidthEnd,ViewStart : Integer;
    Canvas : TCanvas;

    AdvancedDisp,DoInverse : Boolean;

    mem : TDCMemo;
    LastWinLine : Integer;
    LinesInView : Integer;
    FirstLine: Integer;

    procedure memViewChange(Sender: TObject);
    procedure memPaintExpandCollapse(Canvas: TCanvas; X, Y, ASize, AIndent,
      ForLine: Integer; Value: Boolean);
    procedure DumbPaintExpandCollapse(Canvas: TCanvas; X, Y, ASize,
      AIndent, ForLine: Integer; Value: Boolean);
    procedure memCollapseStateChanging(Sender: TObject; LinePos: Integer;
      ACollapsed: Boolean; var Handled: Boolean);
    procedure memBeforePaint(Sender: TObject; Canvas: TCanvas; Rect: TRect);
    procedure memAfterPaint(Sender: TObject; Canvas: TCanvas; Rect: TRect);

    function FoldingOK: Boolean;
    procedure SetOptions(AlsoUpdate : Boolean);
    procedure DoFolders(St,En : Integer; DoUpdate : Boolean);
    procedure DoCollapseStateChanging(LinePos: Integer; ACollapsed: Boolean);
    procedure DoViewChange;
    function GoodCheck: Boolean;
    procedure DoRoundRect(Canvas: TCanvas; x1, y1, x2, y2, Cx, Cy: Integer);
    procedure GetOldValues;
    procedure RestoreOldValues;

    procedure PaintBoxes;
    procedure PaintLines;
    procedure PaintTabs;
    procedure PaintHighlight;
    procedure PaintErrorLines;
    procedure SelectMode;
  protected
    procedure _GoodFolderUpdate;
    procedure _FinishedExplorer;
    procedure _OptionsUpdated(level: Integer);
    Procedure _SetPattern(Num : integer; Const Pat : String; CaseSensitive : Boolean);
  public
    HighPcre : Array[0..MaxHighLights-1] of TDIPcre;
    LineData : Array[1..maxLines] of TLineData;
    BoxProcess : Set of TFoldType;
    BoxData :  Array[TFoldType,1..maxLines] of TBoxData;
    procedure SetVals(DoSet: Boolean);
  end;

var
  EdMagicMod: TEdMagicMod;

implementation
{$R *.dfm}

const
 C_Mode : array[boolean] of TPenMode = (pmCopy,pmMask);
 MinusImg = 11;
 PlusImg = 12;
 FoldingImg : array[false..true] of integer = (MinusImg,PlusImg);
 HighColor : Array[0..MaxHighLights-1] of TColor = (clGreen,clRed,clBlue,$00DD00DD);

procedure TEdMagicMod.SetOptions(AlsoUpdate : Boolean);
var
 i:integer;
 s:string;
const
 MaxColor= 100;
begin
 AdvancedDisp:=(Win32MajorVersion>4);
 if (not AdvancedDisp) and (Win32MajorVersion=4) then
 begin
  case Win32MinorVersion of
   0: AdvancedDisp:=false;// Windows 95
   10: AdvancedDisp:=false; // Windows 98
   90: AdvancedDisp:=true; // Windows ME';
  else
   if Win32Platform=VER_PLATFORM_WIN32_NT
    then AdvancedDisp:=true //Windows NT 4.0
    else AdvancedDisp:=false; //unknown
  end;
 end;

 i:=ColorToRGB(options.EditorColor);
 i:=(GetRValue(i)+getGValue(i)+getBValue(i)) div 3;
 DoInverse:=i<100;

 BoxNonMonoWidth:=mem.gutterwidth+17;
 if (not options.WordWrap) and (options.FoldEnable) then
  inc(BoxNonMonoWidth,mem.LineHeight+3);

 with options do
 begin
  FoldProcess:=[];
  if FoldBrackets then include(FoldProcess,ftBracket);
  if FoldParenthesis then include(FoldProcess,ftParen);
  if FoldHereDoc then include(FoldProcess,ftHereDoc);
  if FoldPod then include(FoldProcess,ftPod);

  FoldCollState[ftBracket]:=FoldDefBrackets;
  FoldCollState[ftParen]:=FoldDefParenthesis;
  FoldCollState[ftHereDoc]:=FoldDefHereDoc;
  FoldCollState[ftPod]:=FoldDefPod;
 end;

 s:='Line';
 For i:=1 to maxlines do
  with LineData[i] do
  begin
   Visible:=GetBoolProperty(options,s+inttostr(i)+'Visible');
   Color:=GetIntProperty(options,s+inttostr(i)+'Color');
   Width:=GetIntProperty(options,s+inttostr(i)+'Width');
  end;
 LineData[1].Style:=options.Line1Pen;
 LineData[2].Style:=options.Line2Pen;
 LineData[3].Style:=options.Line3Pen;
 LineData[4].Style:=options.Line4Pen;
 LineData[5].Style:=options.Line5Pen;
 LineData[6].Style:=options.Line6Pen;

 if Options.SCDecIdent
  then EditorForm.memEditor.OnRealTimeColor:=EditorForm.memRealTimeColor
  else EditorForm.memEditor.OnRealTimeColor:=nil;

 FillChar(BoxData,sizeof(boxdata),0);

 s:='BoxBr';
 For i:=1 to maxlines do
  with BoxData[ftBracket,i] do
  begin
   Visible:=GetBoolProperty(options,s+inttostr(i)+'Visible');
   Color:=GetIntProperty(options,s+inttostr(i)+'Color');
   Cx:=GetIntProperty(options,s+inttostr(i)+'Curve');
   Cy:=cx;
  end;
 BoxData[ftBracket,1].Brush:=options.BoxBr1Brush;
 BoxData[ftBracket,2].Brush:=options.BoxBr2Brush;
 BoxData[ftBracket,3].Brush:=options.BoxBr3Brush;
 BoxData[ftBracket,4].Brush:=options.BoxBr4Brush;
 BoxData[ftBracket,5].Brush:=options.BoxBr5Brush;
 BoxData[ftBracket,6].Brush:=options.BoxBr6Brush;

 s:='BoxPar';
 For i:=1 to maxlines do
  with BoxData[ftParen,i] do
  begin
   Visible:=GetBoolProperty(options,s+inttostr(i)+'Visible');
   Color:=GetIntProperty(options,s+inttostr(i)+'Color');
   Cx:=GetIntProperty(options,s+inttostr(i)+'Curve');
   Cy:=cx;
  end;
 BoxData[ftParen,1].Brush:=options.BoxPar1Brush;
 BoxData[ftParen,2].Brush:=options.BoxPar2Brush;
 BoxData[ftParen,3].Brush:=options.BoxPar3Brush;
 BoxData[ftParen,4].Brush:=options.BoxPar4Brush;
 BoxData[ftParen,5].Brush:=options.BoxPar5Brush;
 BoxData[ftParen,6].Brush:=options.BoxPar6Brush;

 with BoxData[ftHereDoc,1] do
 begin
   Visible:=true;
   Color:=Options.BoxHereDocColor;
   Brush:=options.BoxHereDocBrush;
   CX:=10;   CY:=10;
 end;

 with BoxData[ftPod,1] do
 begin
   Visible:=true;
   Color:=Options.BoxPodColor;
   Brush:=options.BoxPodBrush;
   CX:=10;   CY:=10;
 end;

 BoxProcess:=[];
 if options.BoxBrackets then include(boxProcess,ftBracket);
 if options.BoxParen then include(boxProcess,ftParen);
 if options.BoxPod then include(boxProcess,ftPod);
 if options.BoxHereDoc then include(boxProcess,ftHeredoc);

 if (AlsoUpdate) and assigned(PR_UpdateCodeExplorer) then
  PR_UpdateCodeExplorer;
end;

Function TEdMagicMod.GoodCheck : Boolean;
begin
 try
  result:=(not NoMemoSource) and
          assigned(ActiveScriptInfo) and
          assigned(ActiveScriptInfo.ms) and
          assigned(ActiveScriptInfo.ms.lines);
 except
  on exception do result:=false;
 end;
end;

procedure TEdMagicMod.DoFolders(St,En : Integer; DoUpdate : Boolean);
Const
 BoolToState : array[boolean] of TCollapseState = (csExpanded,csCollapsed);
var
 ft : TFoldType;
 linepos : integer;
 OK,ll : boolean;
begin
 if (st>=en) or (not GoodCheck) then exit;
 if not options.FoldEnable then exit;
 ll:=options.FoldLastLine;

 with ActiveScriptInfo.ms,ExplorerForm do
 begin
  if length(folding)<>lines.Count then exit;
  SetLength(FoldPrevious,lines.count);
  BeginUpdate(0);

  try
   for linepos:=st to en do
   with folding[linepos] do
   begin
    //remove old
    OK:=false;
    for ft:=low(TFoldType) to high(TFoldType) do
    if (ft in folders) and (ft in FoldProcess) and (data[ft].FoldPos=fpStart) then
    begin
     OK:=true;
     break;
    end;

    //remove old stuff
    if (collapsestate[linepos]<>csNone) and (not OK) then
    begin
     if collapseState[linepos]=csCollapsed then
     begin
      DoCollapseStateChanging(linepos,true);
     end;
     collapsestate[linepos]:=csNone;
     linevisible[linepos]:=true;
    end;

    //add new
    if OK then
     begin
      FoldPrevious[linepos]:=data[ft].Le;
      if not ll then dec(FoldPrevious[linepos]);
      if DoUpdate then
       begin
        CollapseState[linepos]:=BoolToState[FoldCollState[ft]];
        if foldcollstate[ft] then
         DoCollapseStateChanging(linepos,false);
       end
      else
       begin
        if collapsestate[linepos]=csNone
         then CollapseState[linepos]:=csExpanded;
       end;
     end
    else
     FoldPrevious[linepos]:=-1;
   end;
  finally
   endupdate;
  end;
 end;
end;

procedure TEdMagicMod.DumbPaintExpandCollapse(Canvas: TCanvas; X, Y, ASize,
  AIndent, ForLine: Integer; Value: Boolean);
begin
end;

procedure TEdMagicMod.memPaintExpandCollapse(Canvas: TCanvas; X, Y, ASize,
  AIndent, ForLine: Integer; Value: Boolean);
const
 ValToInt : array[boolean] of byte = (1,0);
var
 ft : TFoldType;
begin
 if not FoldingOK then exit;
 for ft:=low(TFoldType) to high(TFoldType) do
  with ExplorerForm.folding[ForLine] do
   if (ft in folders) and (data[ft].FoldPos=fpStart) then
   begin
    if (options.FoldLastLine) or (data[ft].Le-forline>1) then
     imagelist.Draw(canvas,x,y,ValToInt[value]+ord(ft)*2);
    exit;
   end;
end;

procedure TEdMagicMod.memCollapseStateChanging(Sender: TObject;
  LinePos: Integer; ACollapsed: Boolean; var Handled: Boolean);
begin
 handled:=true;
 ActiveScriptINfo.ms.BeginUpdate(0);
 DoCollapseStateChanging(LinePos,ACollapsed);
 ActiveScriptINfo.ms.EndUpdate;
 mem.Invalidate;
end;

procedure TEdMagicMod.DoCollapseStateChanging(LinePos: Integer; ACollapsed: Boolean);
var
 ft : TFoldType;
 i,j,st,en:integer;
 ll,OK,tv : boolean;
begin
 if not foldingOK then exit;
 ll:=options.FoldLastLine;
 with ExplorerForm.folding[linepos],ActiveScriptInfo.ms do
 begin
  //Find what kind of folder it is
  OK:=false;
  ft:=low(TFoldType);
  while (ft<=high(TFoldType)) do
  begin
   if (ft in folders) and (data[ft].FoldPos=fpStart) then
    begin
     OK:=true;
     break;
    end;
    inc(ft);
  end;

  if OK then
   begin
    st:=data[ft].LS+1;
    en:=data[ft].le;
    if not ll then
     dec(en);
   end
  else
   begin
    st:=linepos+1;
    en:=st+1;
    while not linevisible[en] do inc(en);
   end;
 end;

 i:=st;
 with ActiveScriptINfo.ms do
  while (i<=en) do
  begin
   //are we expanding but also the next lines are collapsed?
   if (ACollapsed) and (CollapseState[i]=csCollapsed) then
    begin
    //find it in ft
     ok:=false;
     for ft:=low(TFoldType) to high(TFoldType) do
      with ExplorerForm do
      if (ft in folding[i].folders) and (folding[i].data[ft].FoldPos=fpStart) then
        begin
         LineVisible[i]:=true;
         tv:=collapsestate[i]=csExpanded;
         j:=folding[i].data[ft].le;
         if not ll then dec(j);
         ok:=true;
         while (i<j) do
         begin
          inc(i);
          linevisible[i]:=tv;
         end;
         inc(i);
         break;
        end;

       if not ok then exit;
      end
     else
      begin
       LineVisible[i]:=ACollapsed;
       inc(i);
      end;
  end;

end;

Function TEdMagicMod.FoldingOK : Boolean;
begin
 try
  with ExplorerForm,ActiveScriptInfo do
   result:=(ActiveScriptInfo<>nil) and
           (Showing=ms) and
           (ms.Lines<>nil) and
           (length(folding)=ms.Lines.Count);
 except
  on exception do result:=false;
 end;
end;

procedure TEdMagicMod._GoodFolderUpdate;
var
 i:integer;
begin
 i:=mem.MemoSource.FTempHighlightStr;
 DoFolders(0,length(ExplorerForm.folding)-1,true);
 mem.CenterScreenOnLine;
 if i>0 then
  mem.MemoSource.TempHighlightLine(i-1,15);
end;

procedure TEdMagicMod.DataModuleCreate(Sender: TObject);
var
 i :integer;
begin
 Pr_FinishedExplorer:=_FinishedExplorer;
 PR_GoodFolderUpdate:=_GoodFolderUpdate;
 PR_SetPattern:=_SetPattern;
 PC_EdMagicMod_OptionsUpdated:=_OptionsUpdated;

 for i:=0 to MaxHighLights-1 do
  HighPcre[i]:=TDIPcre.create(self);

 LastWinLine:=-1;
 EditorForm.IsDeclaration:=ExplorerForm.IsDeclaration;
 SetVals(true);
 mem:=EditorForm.memEditor;
 SetOptions(true);
end;

procedure TEdMagicMod._FinishedExplorer;
begin
 LastWinLine:=-1;
 memViewChange(self);
 mem.Invalidate;
end;

procedure TEdMagicMod._OptionsUpdated(level : Integer);
begin
 SetOptions((Level=HKO_Big) or (Level=HKO_BigVisible));
end;

procedure TEdMagicMod.SetVals(DoSet : Boolean);
begin
 if assigned(EditorForm) then
  with EditorForm.memEditor do
  if DoSet then
   begin
    {$IFDEF ALTDRAW}
    OnBeforePaint:=memBeforePaint;
    {$ENDIF}
    OnPaintExpandCollapse:=memPaintExpandCollapse;
    onAfterPaint:=memAfterPaint;
    OnCollapseStateChanging:=memCollapseStateChanging;
    OnMemoViewChange:=memViewChange;
   end
  else
   begin
    OnBeforePaint:=nil;
    onAfterPaint:=nil;
    OnPaintExpandCollapse:=DumbPaintExpandCollapse;
    OnCollapseStateChanging:=nil;
    OnMemoViewChange:=nil;
   end;
end;

procedure TEdMagicMod.PaintErrorLines;
var
 en,i : integer;
 pt1,pt2 : TPoint;
begin
 if (not options.SHEditorErrors) and (not options.SHEditorWarnings) then exit;
 if not ActiveScriptInfo.isperl then exit;

 En:=iMin(ActiveScriptInfo.ms.Lines.Count-1,FirstLine+LinesInView);

 with canvas do
 begin
  Pen.Width:=1;
  brush.Color:=options.EditorColor;
 end;

 for i:=0 to length(CurErrorsLines)-1 do
  with CurErrorsLines[i],canvas do
   if (Line>=FirstLine) and (line<=en) and
      (CurErrorsShowing=ActiveScriptInfo) and
      (ActiveScriptInfo.ms.LineVisible[line]) then
   begin
    if CurErrorsStatus=1 then
     begin
      if not options.SHEditorWarnings then continue;
      pen.Color:=options.SHWarningColor;
      pen.Style:=options.SHWarningStyle;
     end
    else
    if CurErrorsStatus=2 then
     begin
      if not options.SHEditorErrors then continue;
      pen.Color:=options.SHErrorColor;
      pen.Style:=options.SHErrorStyle;
     end;

    pt1.X:=0;
    pt1.Y:=line;
    pt2.x:=0;
    pt2.Y:=line+1;
    pt1:=mem.texttopixelpoint(pt1);
    pt2:=mem.texttopixelpoint(pt2);
    pt1.X:=RealWidthStart;
    pt2.X:=WidthEnd;

    MoveTo(pt1.X,pt1.Y);
    LineTo(pt2.X,pt1.Y);
    MoveTo(pt1.X,pt2.Y);
    LineTo(pt2.X,pt2.Y);
   end;
end;

procedure TEdMagicMod.GetOldValues;
begin
 with Canvas.Brush do
 begin
  OldBColor:=Color;
  OldBStyle:=Style;
 end;
 with Canvas.Pen do
 begin
  OldPWidth:=Width;
  OldPStyle:=Style;
  OldPColor:=Color;
  OldPMode:=Mode;
 end;

 RealWidthStart:=mem.getpaintx+1;
 ViewStart:=mem.WinCharPos*mem.CharWidth;
 WidthStart:=RealWidthStart-ViewStart;
 WidthEnd:=mem.ClientWidth-1;
 if options.PrintingNow then
  dec(widthStart,5);
end;

procedure TEdMagicMod.RestoreOldValues;
begin
 with Canvas.Brush do
 begin
  Color:=OldBColor;
  Style:=OldBStyle;
 end;
 with Canvas.Pen do
 begin
  Width:=OldPWidth;
  Style:=OldPStyle;
  Color:=OldPColor;
  mode:=OldPMode;
 end;
end;

procedure TEdMagicMod.memAfterPaint(Sender: TObject; Canvas: TCanvas; Rect: TRect);
begin
 {$IFDEF ALTDRAW}
 if not options.SimpleMemo then exit;
 {$ENDIF}
 if not goodcheck then exit;

 Self.Canvas:=Canvas;
 GetOldValues;

 if DoInverse
  then canvas.Pen.Mode:=pmMerge
 else
  canvas.Pen.Mode:=pmMask;

 //Get Lines
 with mem do
 begin
  FirstLine:=mem.FirstLinePos;
  LinesInView:=ClientHeight div LineHeight+FirstLine;
  mem.checkvisibleIndex(LinesInView,false);
  dec(linesInView,firstLine);
 end;

 //Do Job
 if options.TabVisible then
  PaintTabs;
 PaintErrorLines;
 PaintHighLight;

 if (FoldingOK) then
 begin
  if options.PrintingNow and Options.BoxEnable then
   PaintBoxes;
  if Options.LineEnable then
   PaintLines;
 end;

 RestoreOldValues;
end;

procedure TEdMagicMod.SelectMode;
begin
 if DoInverse
  then canvas.Pen.Mode:=pmMerge
 else
  if AdvancedDisp then
   canvas.Pen.Mode:=pmMask;
end;

procedure TEdMagicMod.memBeforePaint(Sender: TObject; Canvas: TCanvas;
  Rect: TRect);
begin
 if not goodcheck then exit;
 If options.SimpleMemo then exit;

 Self.Canvas:=Canvas;
 GetOldValues;

 with mem do
 begin
  FirstLine:=mem.FirstLinePos;
  LinesInView:=ClientHeight div LineHeight+FirstLine;
  mem.checkvisibleIndex(LinesInView,false);
  dec(linesInView,firstLine);
 end;

 canvas.pen.Mode:=pmCopy;

 if (FoldingOK) then
 begin
  if Options.BoxEnable then
   PaintBoxes;
  if Options.LineEnable then
  begin
   SelectMode;
   PaintLines;
  end;
 end;

 SelectMode;
 if options.TabVisible then
  PaintTabs;
 PaintErrorLines;
 PaintHighLight;

 RestoreOldValues;
end;

procedure TEdMagicMod.PaintLines;
var
 tp,pt1,pt2,pt3,pt4 : TPoint;
 apos,offs,i : Integer;
 St,En : Integer;
 RealLevel : Integer;
begin
 i:=options.LineLookAhead;
 St:=iMax(0,FirstLine-i);
 En:=iMin(ActiveScriptInfo.ms.Lines.Count-1,FirstLine+LinesInView+i);
 if length(ExplorerForm.folding)<=en then exit;

 with canvas do
 begin
  Brush.Style:=bsSolid;
  if not options.PrintingNow then
  brush.color:=options.EditorColor;
 end;
 offs:=mem.CharWidth;

 for i:=st to en do
 with ExplorerForm.Folding[i] do
 BEGIN
  if (ftBracket in Folders) and
     (Data[ftBracket].FoldPos=fpStart) and
     (ActiveScriptInfo.ms.LineVisible[i+1]) then
  with Data[ftBracket] do
   begin
   if (ls<FirstLine) and (le<FirstLine) then continue;
   if (le>FirstLine+LinesInView) and (ls>FirstLine+LinesInView) then
    continue;
   tp.X:=InS;
   tp.Y:=LS;
   pt1:=mem.texttopixelpoint(tp);
   inc(pt1.Y,offs);
   pt2:=pt1;
   tp.X:=InE;
   tp.Y:=LE;
   pt4:=mem.texttopixelpoint(tp);
   inc(pt4.Y,offs);
   pt3:=pt4;

   apos:=(pt4.Y-pt1.Y);
   apos:=apos div 5;

   pt3.x:=mem.ClientWidth-Level*20;
   pt2.x:=mem.ClientWidth-Level*20;
   pt2.y:=pt2.y+apos;
   pt3.Y:=pt3.Y-apos;

   RealLevel:=iMin(maxLines,Level);
   if (pt1.Y<>pt4.Y) and (LineData[realLevel].Visible) then
   begin
    with LineData[RealLevel],canvas do
    begin
     Pen.Style:=Style;
     pen.Width:=Width;
     Pen.Color:=Color;
    end; 

    if pt1.X<RealWidthStart then
     pt1.X:=RealWidthStart;
    if pt4.X<RealWidthStart then
     pt4.X:=RealWidthStart;

    if (not Options.SimpleMemo) and mem.WordWrap then
    begin
     Dec(pt2.x,ViewStart);
     Dec(pt3.X,viewStart);
    end;

    canvas.PolyBezier([pt1,pt2,pt3,pt4]);
   end;

  end;
 END;
end;

procedure TEdMagicMod.PaintTabs;
var
 pt: TPoint;
 s:string;
 ind,i,j,p,rp,en : integer;
begin
 with options,canvas.Pen do
 begin
  Width:=TabWidth;
  Color:=TabColor;
  Style:=TabStyle;
 end;

 En:=iMin(ActiveScriptInfo.ms.Lines.Count-1,FirstLine+LinesInView);
 for i:=FirstLine to en do
 begin
  if not activescriptinfo.ms.LineVisible[i] then continue;
  s:=ActiveScriptInfo.ms.StringItem[i].StrData;
  j:=1;
  p:=0;
  rp:=0;
  while (j<=length(s)) do
  begin
   if s[j]=#9 then
   with mem.MemoSource.FTabStopList do
   begin
     ind:=mem.MemoSource.getvirtualTabStop(p);
     pt:=mem.TextToPixelPoint(point(ind,i));
     rp:=ind;
     if pt.X>RealWidthStart then
     begin
      canvas.MoveTo(pt.X,pt.y);
      canvas.LineTo(pt.X,pt.Y+mem.LineHeight);
     end;
     inc(p);
   end

   else
   if s[j]=' ' then
    with mem.MemoSource.FTabStopList do
    begin
     inc(rp);
     while (mem.MemoSource.getvirtualTabStop(p)<=rp) do
     inc(p);
    end
   else
    break;

   inc(j);
  end
 end;
end;


procedure TEdMagicMod.PaintHighlight;
var
 pt,pt2: TPoint;
 s:string;
 i,j,en,r,o : integer;
 Check : Boolean;
begin
 Check:=false;
 for i:=0 to MaxHighLights-1 do
  if HighPcre[i].Tag<>0 then
  begin
   Check:=true;
   break;
  end;

 if not check then exit;

 with options,canvas.Pen do
 begin
  Width:=1;
  Style:=psSolid;
 end;
 canvas.Brush.Style:=bsClear;

 En:=iMin(ActiveScriptInfo.ms.Lines.Count-1,FirstLine+LinesInView);
 for i:=FirstLine to en do
 begin
  if not activescriptinfo.ms.LineVisible[i] then continue;
  s:=mem.Lines[i];
  for j:=0 to MaxHighLights-1 do
   with HighPcre[j] do
    if Tag<>0 then
    begin
     SetSubjectStr(s);
     if Match(0) >= 0 then
     repeat
      pt:=mem.TextToPixelPoint(point(MatchedStrFirstCharPos,i));
      pt2:=mem.TextToPixelPoint(point(MatchedStrAfterLastCharPos,i));
      canvas.Pen.Color:=HighColor[j];
      r:=(MaxHighLights-j)*3;
      o:=MaxHighLights-2-j;
      canvas.RoundRect(pt.X,pt.Y+1-o  ,pt2.X, pt.y+mem.LineHeight+o  ,r,r);
     until MatchNext < 0
    end;
 end;
end;


procedure TEdMagicMod.PaintBoxes;
var
 reallevel,c,i,st,en,maxc,nmf : integer;
 pt1,pt2,tp1,tp2 : TPoint;
 ft : TFoldType;
begin
 canvas.pen.style:=psSolid;
 canvas.pen.Width:=1;
 St:=iMax(0,FirstLine-Options.BoxLookAhead);
 c:=ActiveScriptInfo.ms.Lines.Count-1;
 En:=iMin(c,FirstLine+LinesInView);
 if length(ExplorerForm.folding)<=en then exit;
 For i:=st to en do
  if ActiveScriptInfo.ms.LineVisible[i] then
   with ExplorerForm.folding[i] do
   begin
    for ft:=low(TFoldType) to high(TFoldType) do
     if (data[ft].Le>=firstline) and
        (ft in Folders) and (ft in boxProcess) and
        (data[ft].FoldPos=fpStart)
    then
     begin
      RealLevel:=imin(maxlines,data[ft].Level);
      if boxdata[ft,reallevel].Visible then
      with boxdata[ft,reallevel],data[ft] do
      begin
       if (ls<FirstLine) and (le<FirstLine) then continue;
       if (le>en) and (ls>En) then continue;

       tp1:=point(Level-1,Ls);
       if mem.WordWrap
        then maxc:=mem.MarginPos-2
        else maxc:=mem.GetMaxCaretChar;
        // minus because if wordwrap and we go over the margin
        //the returned y will be of the next line!

       tp2:=point(maxc-level+2,Le+1);
       pt1:=mem.TextToPixelPoint(point(0,tp1.y));
       pt2:=mem.TextToPixelPoint(point(0,tp2.y));
       nmf:=(level-1)*mem.CharWidth;
       pt1.X:=nmf+WidthStart;
       pt2.X:=WidthEnd-nmf;
       if mem.WordWrap then
        dec(pt2.x,ViewStart);

       if not options.PrintingNow then
       begin
        c:=mem.ClientHeight+cy+5;
        if pt2.y>c then
         pt2.Y:=c;
       end;

       canvas.brush.Style:=Brush;
       canvas.pen.Color:=Color;

       if brush<>bsClear then
        canvas.brush.Color:=Color;

       if options.printingNow then
        begin
         canvas.brush.Color:=Color;
         canvas.pen.Width:=options.PrintOvLinesWidth;
         if (brush=bsClear) and (not Options.PrintComp)
          Then canvas.brush.Color:=ClWhite;

         if Options.PrintComp
         then
          begin
           dec(pt2.X,canvas.Pen.Width);
           dec(pt2.Y,canvas.Pen.Width);
           for c:=0 to canvas.Pen.Width-1 do
            Canvas.FrameRect(Classes.rect(pt1.X-c,pt1.Y-c,pt2.X+c,pt2.Y+c))
          end
         else
          canvas.RoundRect(pt1.X,pt1.Y,pt2.X,pt2.Y,Cx,Cy);
        end

       else
        canvas.RoundRect(pt1.X,pt1.Y,pt2.X,pt2.Y,Cx,Cy);

      end;
     end;
   end;
end;

procedure TEdMagicMod.DoRoundRect(Canvas : TCanvas; x1,y1,x2,y2,Cx,Cy : Integer);

 Procedure Vertical;
 var i:integer;
 begin
   i:=x1;
   while i<=x2 do
   begin
    canvas.MoveTo(i,y1);
    canvas.LineTo(i,y2);
    inc(i,5);
   end;
 end;

 Procedure Horizontal;
 var i:integer;
 begin
   i:=y1;
   while i<=y2 do
   begin
    canvas.MoveTo(x1,i);
    canvas.LineTo(x2,i);
    inc(i,5);
   end;
 end;

begin
 canvas.Pen.Width:=1;
 case canvas.Brush.Style of
  bsSolid,bsclear : canvas.RoundRect(x1,y1,x2,y2,Cx,Cy);
  bsVertical : Vertical;
  bsHorizontal : Horizontal;
  bsCross : begin
   Vertical;
   Horizontal;
  end;
  bsBDiagonal : Vertical;
  bsFDiagonal : Horizontal;
  bsDiagCross : begin
   Vertical;
   Horizontal;
  end;
 end;
end;

procedure TEdMagicMod.memViewChange(Sender: TObject);
var
 TopLine : Integer;
begin
 topline:=mem.FirstLinePos;
 if TopLine<>LastWinLine then
 begin
  DoViewChange;
  LastWinLine:=TopLine;
 end;
end;

procedure TEdMagicMod.DoViewChange;
var
 TopLine,st,en : Integer;
 r : TRect;
begin
 if options.FoldEnable then
 begin
  r:=mem.MemoSource.FoundRect;
  topline:=mem.FirstLinePos;
  St:=iMax(0,TopLine);
  en:=mem.MemoSource.RealToVisibleIndex(st);
  en:=en+mem.GetMaxCaretLine(false);
  en:=mem.MemoSource.VisibleToRealIndex(en);
  En:=iMin(Length(ExplorerForm.folding)-1,en);
  //This line caused trouble! See TExplorerForm.InitializeUpdate

  DoFolders(st,en,false);
  if not IsRectEmpty(r) then
   mem.MemoSource.FoundRect:=r;
 end;
end;

procedure TEdMagicMod._SetPattern(Num : integer; Const Pat : String; CaseSensitive : Boolean);
begin
 if casesensitive
  then HighPcre[num].CompileOptions:=HighPcre[num].CompileOptions - [coCaseless]
  else HighPcre[num].CompileOptions:=HighPcre[num].CompileOptions + [coCaseless];

 if pat='' then
  HighPcre[num].Tag:=0
 else
  begin
   if pat=HighPcre[num].MatchPattern then
    begin
     HighPcre[num].MatchPattern:='';
     HighPcre[num].Tag:=0;
    end
   else
    begin
     HighPcre[num].MatchPattern:=pat;
     HighPcre[num].Tag:=1;
    end;
  end;
 mem.Invalidate;
end;

end.