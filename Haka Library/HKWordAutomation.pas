unit HKWordAutomation;

interface
uses comobj;

const
 wdReplaceAll = 2;
 wdFindContinue = 1;


procedure InitWord(var App : OleVariant; MakeVisible : Boolean);
Procedure OpenDocument(App : OleVariant; const Path : string);
Procedure FindReplaceAll(App : OleVariant; Const Find,Replace : string);
Procedure PrintPreview(App : OleVariant);
Procedure SaveAsDocument(App : OleVariant; const Path : string);

implementation

Procedure SaveAsDocument(App : OleVariant; const Path : string);
begin
 app.ActiveDocument.SaveAs(path);
end;

Procedure PrintPreview(App : OleVariant);
begin
 if not app.PrintPreview
  then app.ActiveDocument.PrintPreview;
end;

Procedure FindReplaceAll(App : OleVariant; Const Find,Replace : string);
var f:Olevariant;
begin
 f:=app.Selection.find;
 f.clearformatting;
 f.Replacement.ClearFormatting;
 f.execute(find,true,false,false,false,false,true,wdFindContinue,false,
           replace,wdReplaceAll,false,false,false,false);
end;

procedure InitWord(var App : OleVariant; MakeVisible : Boolean);
var v:Olevariant;
begin
 v:=createoleobject('Word.Application');
 App:=v.application;
 app.visible:=Makevisible;
end;

Procedure OpenDocument(App : OleVariant; const Path : string);
begin
 app.documents.open(path);
end;




end.



    ChangeFileOpenDirectory "C:\unzip\"
    Documents.Open FileName:="TestTem.dot", ConfirmConversions:=False, _
        ReadOnly:=False, AddToRecentFiles:=False, PasswordDocument:="", _
        PasswordTemplate:="", Revert:=False, WritePasswordDocument:="", _
        WritePasswordTemplate:="", Format:=wdOpenFormatAuto
    Selection.TypeParagraph
    Selection.TypeParagraph
    Selection.MoveUp Unit:=wdLine, Count:=2
    Selection.TypeText Text:="test"
    Selection.Find.ClearFormatting
    Selection.Find.Replacement.ClearFormatting
    With Selection.Find
        .Text = "%F%"
        .Replacement.Text = "test"
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With
    Selection.Find.Execute Replace:=wdReplaceAll



    =----------------


        Selection.Find.ClearFormatting
    With Selection.Find
        .Text = "%F%"
        .Replacement.Text = ""
        .Forward = True
        .Wrap = wdFindContinue
        .Format = False
        .MatchCase = False
        .MatchWholeWord = False
        .MatchWildcards = False
        .MatchSoundsLike = False
        .MatchAllWordForms = False
    End With
    Selection.Find.Execute
    Selection.ConvertToTable Separator:=wdSeparateByParagraphs, NumColumns:=1, _
         NumRows:=1, Format:=wdTableFormatNone, ApplyBorders:=True, ApplyShading _
        :=True, ApplyFont:=True, ApplyColor:=True, ApplyHeadingRows:=True, _
        ApplyLastRow:=False, ApplyFirstColumn:=True, ApplyLastColumn:=False, _
        AutoFit:=True, AutoFitBehavior:=wdAutoFitFixed
    Selection.MoveRight Unit:=wdCharacter, Count:=1
    Selection.TypeParagraph
    Selection.TypeParagraph
    ActiveDocument.Tables.Add Range:=Selection.Range, NumRows:=5, NumColumns:= _
        5, DefaultTableBehavior:=wdWord9TableBehavior, AutoFitBehavior:= _
        wdAutoFitFixed
    Selection.TypeText Text:="COL1"
    Selection.MoveRight Unit:=wdCell
    Selection.TypeText Text:="COL2"
    Selection.MoveRight Unit:=wdCell
    Selection.TypeText Text:="COL3"
    Selection.MoveRight Unit:=wdCell
    Selection.TypeText Text:="COL4"
    Selection.MoveRight Unit:=wdCell
    Selection.TypeText Text:="COL5"
