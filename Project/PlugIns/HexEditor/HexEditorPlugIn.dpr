library HexEditorPlugIn;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,ComObj,
  Windows,Forms,Variants,
  HexEditConvFrm in 'HexEditConvFrm.pas' {HexEditConvForm},
  HexPrinterFrm in 'HexPrinterFrm.pas' {HexPrinterForm},
  HexEditFrm in 'HexEditFrm.pas' {HexEditForm};

{$E opp}

var
 PlugID : Cardinal;
 Handle : THandle = 0;
 win : Variant;

Procedure GetPlugInData(var Name,Description,Button,Extensions : PChar); stdcall;
begin
 Name:=pchar('Hex Editor');
 Description:=pchar('Hex Editor Plug-In');
 Button:=nil;
 Extensions:=nil;
end;

Procedure _Initialization(APlugID : Cardinal); stdcall;
begin
 OptiPerl:=createoleobject('OptiPerl.Application');
 Forms.application.handle:=OptiPerl.handle;
 win:=OptiPerl.RequestWindow(APlugID);
 Win.Show;
 handle:=win.MainControl.handle;

 if not assigned(HexEditForm) then
  HexEditForm:=THexEditForm.Create(Forms.application);

 SetParent(HexEditForm.handle,handle);
 HexEditForm.Show;
 Win.Redraw;

 win.Title:='Hex Editor';
 PlugID:=APlugID;
end;

Function OnCanTerminate : Boolean; stdcall;
begin
 result:=true;
 if assigned(HexEditForm) then
  result:=HexEditForm.checkchanges;
end;

Procedure _Finalization; stdcall;
begin
 Forms.Application.handle:=0;
 if assigned(HexEditForm) then
 begin
  HexEditForm.free;
  OptiPerl.DestroyWindow(PlugID,win);
  win.Hide;
 end;
end;

{$R *.res}

exports
 GetPlugInData,
 OnCanTerminate,
 _Initialization name 'Initialization',
 _Finalization name 'Finalization';
end.
