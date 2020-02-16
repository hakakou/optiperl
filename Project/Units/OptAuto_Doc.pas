{***************************************************************
 *
 * Unit Name: OptAuto_Doc
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptAuto_Doc;
{$I REG.INC}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Sysutils, ComObj, ActiveX, OptiPerl_TLB, StdVcl, ComServ, classes, dcstring,
  ScriptInfoUnit,EditorFrm,PlugBase;

type
  TDocument = class(TAutoObject, IDocument)
  Public
    SI : TScriptInfo;
    Destructor Destroy; Override;
  protected
    function Get_LineCount: Integer; safecall;
    function Get_Lines(Index: Integer): WideString; safecall;
    procedure Set_Lines(Index: Integer; const Value: WideString); safecall;
    function Get_ColorData(Index: Integer): WideString; safecall;
    procedure Set_ColorData(Index: Integer; const Value: WideString); safecall;
    procedure Add(const text: WideString); safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Insert(Index: Integer; const Text: WideString); safecall;
    function Get_CursorPosX: Integer; safecall;
    function Get_CursorPosY: Integer; safecall;
    function Get_Selection: WideString; safecall;
    procedure Set_CursorPosX(Value: Integer); safecall;
    procedure Set_CursorPosY(Value: Integer); safecall;
    procedure Set_Selection(const Value: WideString); safecall;
    procedure TempHightlightLine(Index: Integer); safecall;
    procedure CursorDown; safecall;
    procedure CursorLeft; safecall;
    procedure CursorRight; safecall;
    procedure CursorUp; safecall;
    function Get_Self: Integer; safecall;
    function Get_Filename: WideString; safecall;
    function Get_Modified: WordBool; safecall;
    procedure Set_Modified(Value: WordBool); safecall;
  end;


Function GetDocument(SI : TScriptInfo) : OleVariant;

implementation

{ TDocument }

procedure TDocument.Add(const text: WideString);
begin
 si.ms.Lines.Add(text);
end;

procedure TDocument.Delete(Index: Integer);
begin
 si.ms.Lines.Delete(index);
end;

function TDocument.Get_ColorData(Index: Integer): WideString;
begin
 result:=si.ms.StringItem[index].ColorData;
end;

function TDocument.Get_LineCount: Integer;
begin
 with TScriptInfo(si) do
  result:=ms.Lines.Count;
end;

function TDocument.Get_Lines(Index: Integer): WideString;
begin
 result:=si.ms.StringItem[index].StrData;
end;

function TDocument.Get_Selection: WideString;
var i:integer;
begin
 result:='';
 with si.ms do
  for i:=SelectionRect.Top to SelectionRect.bottom do
   if (i<lines.count) and (i>=0) then
     result:=result+StringItem[i].StrData+#10;
 i:=length(result);
 if i>0 then
  setlength(result,i-1);
end;

procedure TDocument.Insert(Index: Integer; const text: WideString);
begin
 si.ms.Lines.Insert(index,text);
end;

procedure TDocument.Set_ColorData(Index: Integer; const Value: WideString);
begin
 with si.ms do
  if length(stringitem[index].StrData)=length(value) then
   StringItem[index].ColorData:=value;
end;

procedure TDocument.Set_Lines(Index: Integer; const Value: WideString);
begin
 si.ms.StringItem[index].StrData:=value;
end;

procedure TDocument.Set_Selection(const Value: WideString);
var
 i:integer;
 sl:TStringList;
begin
 sl:=TStringList.create;
 with TScriptInfo(si).ms do
 try
  sl.text:=value;
  BeginUpdate(acStringsUpdate);
  for i:=0 to sl.Count-1 do
   if i+selectionrect.Top<lines.Count then
    Lines[i+SelectionRect.Top]:=sl[i];
  EndUpdate;
 finally
  sl.free;
 end;
end;

function TDocument.Get_CursorPosX: Integer;
begin
 result:=si.ms.CaretPoint.X;
end;

function TDocument.Get_CursorPosY: Integer;
begin
 result:=si.ms.CaretPoint.Y;
end;

procedure TDocument.Set_CursorPosX(Value: Integer);
begin
 with si do
  ms.SetCaretPoint(point(value,ms.CaretPoint.Y));
end;

procedure TDocument.Set_CursorPosY(Value: Integer);
begin
 with si do
  ms.SetCaretPoint(point(ms.CaretPoint.x,value));
end;

procedure TDocument.TempHightlightLine(Index: Integer);
begin
 with si do
 begin
  ms.JumpToLine(index);
  EditorForm.memEditor.CenterScreenOnLine;
  ms.TempHighlightLine(index,15);
 end;
end;


/// DESTRUCTORS AND GETTERS

Function GetDocument(SI : TScriptInfo) : OleVariant;
var
 Doc : TDocument;
begin
 if assigned(SI) then
 begin
  doc:=si.oleobject;
  if doc=nil then
  begin
   Doc:=TDocument.Create;
   doc.SI:=si;
   si.OleObject:=doc;
  end;
  result:=doc as IDispatch;
 end;
end;

destructor TDocument.Destroy;
begin
 si.OleObject:=nil;
 si:=nil;
 inherited;
end;

procedure TDocument.CursorDown;
begin
 si.ms.CursorDown
end;

procedure TDocument.CursorLeft;
begin
 if si.ms.CaretPoint.x>0 then
  si.ms.CursorLeft;
end;

procedure TDocument.CursorRight;
begin
 if si.ms.CaretPoint.x<length(si.ms.Lines[si.ms.CaretPoint.Y]) then
  si.ms.CursorRight
end;

procedure TDocument.CursorUp;
begin
 si.ms.CursorUp;
end;

function TDocument.Get_Self: Integer;
begin
 result:=Integer(self);
end;


function TDocument.Get_Filename: WideString;
begin
 result:=si.path;
end;

function TDocument.Get_Modified: WordBool;
begin
 result:=si.IsModified;
end;

procedure TDocument.Set_Modified(Value: WordBool);
begin
 if value
  then si.Modified
  else si.IsNewFile:=false;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TDocument, Class_Document,ciSingleInstance);
end.