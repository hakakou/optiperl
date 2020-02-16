library VIEmulator;


uses
  SysUtils,
  windows,
  Classes,
  variants,
  controls,
  OptiPerl_TLB in '..\..\OptiPerl_TLB.pas',
  Commands in 'Commands.pas';


const
 ModeStr : Array[tmode] of string = ('-- NORMAL --','-- INSERT --','-- OVERWRITE --');

var
 Buffer : String = '';
 Line : String = '';
 NulInsert : Boolean;
 Editor : TWinControl;

{$E opp}

{$R *.res}
Procedure GetPlugInData(var Name,Description,Button : PChar); cdecl;
begin
 Name:=pchar('VI Emulator');
 Description:=pchar('VI Emulator Plug-In');
 Button:=nil;
end;

Procedure UpdateStatusBar;
begin
 Auto.StatusBarText(ModeStr[mode]+'              '+buffer);
end;

Procedure _Initialization(APlugID : Cardinal); cdecl;
var
 ed : OleVariant;
begin
 PopulateCommands;
 Auto:=CoApplication.Create;
 Auto.Option['GroupUndo']:=false;
 Auto.UpdateOptions(false);
 ed:=auto.EditorControl;
 Editor:=TWinControl(integer(ed.self));
 UpdateStatusBar;
end;

Procedure _Finalization; cdecl;
begin
 Auto.StatusBarRestore;
end;

Function OnKeyboardEvent(WParam, LParam : Cardinal) : Boolean; cdecl;
var
 c:char;
 I:integer;
 KS : TKeyboardState;
 buf : PAnsiChar;
 Proc : Procedure;
begin
 result:=true;
// if varisempty(auto.focusedcontrol) then exit;
// if auto.FocusedControl.self<>integer(Editor) then exit;

 if GetAsyncKeyState(VK_MENU) < 0 then Exit;

 Doc:=Auto.ActiveDocument;

 if not GetKeyboardState(ks) then exit;

 i:=TOAscII(WParam,LParam,KS,buf,0);
 if i<>1 then exit;

 if ((lParam shr 31) and 1 = 1) then
  exit;

 buffer:=buffer+copy(buf,1,1);
 c:=buffer[length(buffer)];

 if c=#27 then
 begin
  result:=false;
  buffer:='';
  mode:=nNormal;
  InsertEnd.x:=doc.CursorPosX;
  InsertEnd.y:=doc.CursorPosY;
  if (DidAnEdit) and assigned(TodoWhenGoNormalAndFull) then
   TodoWhenGoNormalAndFull;
  if (not DidAnEdit) and assigned(TodoWhenGoNormalAndNil) then
   TodoWhenGoNormalAndNil;
  TodoWhenGoNormalAndFull:=nil;
  TodoWhenGoNormalAndNil:=nil;
  UpdateStatusBar;
  exit;
 end;

 if (mode=nInsert) then
  DidAnEdit:=true;

 if mode=nNormal then
 begin
  result:=false;
  TodoWhenGoNormalAndNil:=nil;
  TodoWhenGoNormalAndFull:=nil;
  DidAnEdit:=false;
  
  for i:=0 to Com.Count-1 do
  begin
   pcre.Pattern:=com[i];
   if pcre.Match(buffer)>0 then
   begin
    @proc:=com.Objects[i];
    proc;
    buffer:='';
    break;
   end;
  end;

  if mode=nInsert then
  begin
   InsertStart.x:=doc.CursorPosX;
   InsertStart.y:=doc.CursorPosY;
  end;
 end;

 UpdateStatusBar;
end;

exports
 GetPlugInData,
 OnKeyboardEvent,
 _Initialization name 'Initialization',
 _Finalization name 'Finalization';
end.
