library OppDemo;

uses
  SysUtils,
  Classes,ComObj,Forms,Windows,dialogs,
  MainFrm in 'MainFrm.pas' {MainForm};

var
 Handle : THandle = 0;
 PlugID : Cardinal;
 win : Variant;
 OptiPerl : Variant;

{$E opp}
{$R *.res}

Procedure DoMainMenu;
var btn,menu,tbl : Variant;
begin
 menu:=OptiPerl.CreateToolItem(PlugID,'menu');
 menu.SetOptions('Menu','','','','');

 btn:=OptiPerl.CreateToolItem(PlugID,'button');
 btn.SetOptions('Test','Test button','%opti%tools.icl,117','Alt+F10','TestButton');
 menu.ToolLinks.Add(btn,0);

 btn:=OptiPerl.CreateToolItem(PlugID,'button');
 btn.SetOptions('Exit','Exit Plug-In','','','ExitButton');
 menu.ToolLinks.Add(btn,1);

 Win.MainBarLinks.add(menu,0);
 Win.PopUpLinks.AssignLinks(Menu.ToolLinks);
 tbl:=OptiPerl.ToolBarLinks[PlugID];    // use brackets for properties
 tbl.AssignLinks(Menu.ToolLinks);     
 OptiPerl.UpdateToolBars(PlugID);
 OptiPerl.ToolBarVisible(PlugID,1);
end;

Procedure TestButton; stdcall;
begin
 MessageDlg('Test', mtInformation, [mbOK], 0);
end;

Procedure ExitButton; stdcall;
begin
 OptiPerl.EndPlugIn(PlugID);
end;

Procedure _Initialization(APlugID : Cardinal); stdcall;
begin
 OptiPerl:=createoleobject('OptiPerl.Application');
 PlugID:=APlugID;
 Forms.application.handle:=OptiPerl.handle;
 win:=OptiPerl.RequestWindow(APlugID);
 Win.Show;
 handle:=win.MainControl.handle;

 if not assigned(MainForm) then
  MainForm:=TMainForm.Create(Forms.application);

 SetParent(MainForm.handle,handle);
 MainForm.Show;
 DoMainMenu;
 Win.Redraw;
 win.Title:='OPP Test';
end;

Procedure _Finalization; stdcall;
begin
 Forms.Application.handle:=0;
 if assigned(MainForm) then
 begin
  FreeAndNil(Mainform);
  OptiPerl.DestroyWindow(PlugID,win);
  win.Hide;
 end;
end;

Procedure OnParseStart; stdcall;
begin
 AddLog('OnParseStart');
end;

Procedure OnActiveDocumentChange; stdcall;
begin
 AddLog('OnActiveDocumentChange');
end;

Procedure OnParseEnd; stdcall;
begin
 AddLog('OnParseEnd');
end;

Function OnCanTerminate : Boolean; stdcall;
begin
 result:=true;
 AddLog('OnCanTerminate');
end;

Function OnKeyEvent(WParam, LParam : Cardinal) : Boolean; stdcall;
begin
 result:=true;
 AddLog('OnKeyEvent '+inttostr(WParam)+' '+InttoStr(LParam));
end;

Function OnBeforeAction(const Action : String) : Boolean; stdcall;
begin
 result:=true;
 AddLog('OnBeforeAction '+Action);
end;

Procedure OnAfterAction(const Action : String); stdcall;
begin
 AddLog('OnAfterAction '+Action);
end;

Procedure OnDocumentClose(const Path : String); stdcall;
begin
 AddLog('OnDocumentClose '+path);
end;

Procedure GetPlugInData(var Name,Description,Button,Extensions : PChar); stdcall;
begin
 Name:=pchar('OPP Demo');
 Description:=pchar('OPP Demo Plug-In');
 Button:=nil;
 Extensions:=nil;
end;

exports
 _Initialization name 'Initialization',
 _Finalization name 'Finalization',
 OnParseStart,
 OnActiveDocumentChange,
 OnParseEnd,
 OnCanTerminate,
 OnKeyEvent,
 OnBeforeAction,
 OnAfterAction,
 OnDocumentClose,
 GetPlugInData,
 ExitButton,
 TestButton;
end.
