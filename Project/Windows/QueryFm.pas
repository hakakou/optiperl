unit QueryFm; //Modeless

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, Hyperstr, Menus, ScriptInfoUnit, hkclasses,
  optQuery,HakaControls, OptProcs;

type
  TQueryFrame = class(TFrame)
    vlQuery: TStringGrid;
    edManual: TEdit;
    lblManual: TLabel;
    procedure edManualChange(Sender: TObject);
    procedure vlQueryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FrameResize(Sender: TObject);
    procedure vlQuerySetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
  public
    IsQuery : TQueryTypes;
    MyHeight : Integer;
    procedure CreateFrame;
    procedure UpdateFrame;
    Procedure GridChange;
    Procedure InsertFilename(const f:string);
  end;

implementation

Const
 MaxRows = 40;

{$R *.dfm}

procedure TQueryFrame.edManualChange(Sender: TObject);
begin
 if not TCustomEdit(sender).focused then exit;
 with Sender as TCustomEdit do
  ActiveScriptInfo.Query.ActiveQuery[IsQuery]:=text;
 PC_QueryChanged;
end;

Procedure TQueryFrame.CreateFrame;
begin
 with vlQuery do
 begin
  RowCount:=MaxRows;
  Cells[0,0]:='Name';
  Cells[1,0]:='Value';
 end;
end;

Procedure TQueryFrame.UpdateFrame;
var
 i : integer;
 hl : THashList;
begin
 with vlQuery do
 begin
  Cols[0].Clear;
  Cols[1].Clear;
  Cells[0,0]:='Name';
  Cells[1,0]:='Value';
 end;
 edManual.Text:='';
 hl:=THashList.Create(false,false,dupAccept);
 if Isquery=qmCookie then hl.LineDel:=';';
 hl.Text:=ActiveScriptInfo.Query.activequery[isQuery];
 if Not hl.LastParseWasGood
  then edManual.Text:=ActiveScriptInfo.Query.activequery[isQuery]
  else
   begin
    For i:=0 to imin(hl.Count-1,MaxRows-2) do
    begin
     vlQuery.Cells[0,i+1]:=hl.Strings[i];
     vlQuery.Cells[1,i+1]:=hl.ValueAt(i);
    end;
   end;
 hl.Free
end;

procedure TQueryFrame.vlQueryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=vk_Delete) and (not vlQuery.EditorMode) then
  with vlQuery do
   Cells[Col,row]:='';
end;

procedure TQueryFrame.InsertFilename(const f: string);
var s:string;
begin
 if edManual.Focused then
  begin
   s:=edmanual.Text;
   insert(f,s,edmanual.SelStart);
   edmanual.Text:=s;
  end
 else
  with vlQuery do
  begin
   cells[selection.Left,selection.Top]:=f;
   GridChange;
  end;
end;

procedure TQueryFrame.GridChange;
var
 i:integer;
 hl : THashList;
 s1,s2 : string;
begin
 if not assigned(ActiveScriptInfo) then exit;
 
 hl:=THashList.Create(false,false,dupAccept);
 if Isquery=qmCookie then hl.LineDel:=';';
 with vlQuery do
  for i:=1 to rowcount-1 do
  begin
   s1:=cells[0,i];
   s2:=cells[1,i];
   if (s1<>'') or (s2<>'') then hl.Add(s1,s2);
  end;

 ActiveScriptInfo.Query.ActiveQuery[IsQuery]:=hl.text;
 PC_QueryChanged;
 hl.free;
end;

procedure TQueryFrame.FrameResize(Sender: TObject);
begin
 with vlQuery do
 begin
  ColWidths[0]:=imin(ColWidths[0],ClientWidth div 2);
  ColWidths[1]:=ClientWidth-ColWidths[0]-3;
  vlquery.LeftCol:=0;
 end;
end;

procedure TQueryFrame.vlQuerySetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
 GridChange;
end;

end.