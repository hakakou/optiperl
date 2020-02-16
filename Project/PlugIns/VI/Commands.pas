unit Commands;

interface

uses sysutils, diPcre, classes, OptiPerl_TLB, windows;

type
 TMode = (nNormal,nInsert,nOverwrite);

var
 Com : TStringList;

 TodoCount : Integer;
 TodoWhenGoNormalAndNil,
 TodoWhenGoNormalAndFull : Procedure;
 DidAnEdit : Boolean;
 InsertStart,InsertEnd : Tpoint;

 PCRE : TDIPcre;
 Auto : IApplication;
 Mode : TMode = nNormal;
 Doc : OleVariant;

Procedure PopulateCommands;

implementation

const
 CtrlA = #$01;  CtrlB = #$02;  CtrlC = #$03;  CtrlD = #$04;
 CtrlE = #$05;  CtrlF = #$06;  CtrlG = #$07;  CtrlH = #$08;
 CtrlI = #$09;  CtrlJ = #$0a;  CtrlK = #$0b;  CtrlL = #$0c;
 CtrlM = #$0d;  CtrlN = #$0e;  CtrlO = #$0f;  CtrlP = #$10;
 CtrlQ = #$11;  CtrlR = #$12;  CtrlS = #$13;  CtrlT = #$14;
 CtrlU = #$15;  CtrlV = #$16;  CtrlW = #$17;  CtrlX = #$18;
 CtrlY = #$19;  CtrlZ = #$1a;

procedure TWGNAN_MoveCharLeft;
begin
 doc.CursorLeft;
end;

Procedure T_AfterInsert;
var
 i,j,c:integer;
 s:string;
begin
 c:=Insertend.Y-1;
 for i:=2 to TodoCount do
  for j:=InsertStart.y to InsertEnd.Y-1 do
  begin
   doc.insert(c,doc.lines[j]);
   inc(c);
  end;
 doc.CursorPosX:=InsertEnd.x-1;
 doc.CursorPosY:=c+1;
end;

Procedure TWGNAF_CopyLines;
begin

end;

Procedure EditProc;
var
 c:char;
 i:integer;
begin
 TodoCount:=StrToIntDef(pcre.SubStr(1),1);
 c:=pcre.SubStr(2)[1];
 for i:=1 to TodoCount do
  case c of
   'h' : Doc.CursorLeft;
   'l' : Doc.CursorRight;
   'j',
 CtrlM : Doc.CursorDown;
   'k' : Doc.CursorUp;
   'x' : Auto.ExecuteAction('DelCharRightVIAction');
   'J' : Auto.ExecuteAction('DeleteLineBreakAction');
   'u' : Auto.ExecuteAction('UndoAction');
 CtrlR : Auto.ExecuteAction('RedoAction');
  end;
end;

Procedure InsertProc;
var
 c:char;
 i,n:integer;
begin
 TodoCount:=StrToIntDef(pcre.SubStr(1),1);
 c:=pcre.SubStr(2)[1];
  case c of
   'i' : begin
//          TodoWhenGoNormalAndNil:=TWGNAN_MoveCharLeft;
//          TodoWhenGoNormalAndFull:=TWGNAN_MoveCharLeft;
         end;
   'o' : Auto.ExecuteAction('InsertNewLineAction');
   'O' : begin
          doc.cursorup;
          Auto.ExecuteAction('InsertNewLineAction');
         end;
   'a' : begin
          doc.cursorRight;
//          TodoWhenGoNormalAndNil:=TWGNAN_MoveCharLeft;
//          TodoWhenGoNormalAndFull:=TWGNAN_MoveCharLeft;
         end;
  end;
 Mode:=nInsert;
 TodoWhenGoNormalAndNil:=T_AfterInsert;
 TodoWhenGoNormalAndFull:=T_AfterInsert;
end;


Procedure PopulateCommands;
begin
 Com.addobject('^(\d*)(h|j|\x0d|k|l|x|J|u|\x12)$',@EditProc);
 Com.addobject('^(\d*)(i|o|O|a)$',@InsertProc);
end;

initialization
 Com:=TStringList.create;
 PCRE:=TDIPcre.Create(nil);
 PCRE.CompileOptions:=PCRE.CompileOptions - [coCaseless];
finalization
 PCRE.free;
 Com.free;
end.