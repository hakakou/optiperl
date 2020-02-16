unit PlugInFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,OptForm, dxBar, ExtCtrls, aqDockingBase, hakawin;

type
  TPlugInForm = class(TOptiForm)
    BarManager: TdxBarManager;
    Panel: TPanel;
    siPopUpLinks: TdxBarSubItem;
    procedure PanelResize(Sender: TObject);
  private
    FChildHandle:THandle;
  Public
    Procedure WebShow(show : Boolean);
    Procedure PaintChild;
    Function ChildHandle : THandle;
  protected
    Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); Override;
  end;


implementation

{$R *.dfm}

{ TPlugInForm }

function TPlugInForm.ChildHandle: THandle;
begin
 if FChildHandle=0 then
  FChildHandle:=GetTopWindow(panel.Handle);
 result:=FChildHandle;
end;

procedure TPlugInForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=SiPopUpLinks.ItemLinks;
end;
{
procedure TPlugInForm.OnDestroyForm(Sender: TObject);
var
 h : THandle;
begin
 hakawin.DisableApplication;
 try
  while GetTopWindow(panel.Handle)<>0 do
  begin
//   PlugIn.TellToExitLoop;
   application.ProcessMessages;
  end;
  Free;
 finally
  hakawin.EnableApplication;
 end;
end;

procedure TPlugInForm.OnShowForm(Sender: TObject);
begin
 Show;
 PanelResize(sender);
end;
}
procedure TPlugInForm.PaintChild;
var h:THandle;
begin
 h:=ChildHandle;
 if h<>0 then
  begin
   SetWindowPos(h,0,0,0,panel.Width+1,panel.Height,SWP_NOACTIVATE	or SWP_NOZORDER);
   SetWindowPos(h,0,0,0,panel.Width-1,panel.Height,SWP_NOACTIVATE	or SWP_NOZORDER);
  end;
end;

procedure TPlugInForm.PanelResize(Sender: TObject);
var h:THandle;
begin
 h:=ChildHandle;
 if h<>0 then
  SetWindowPos(h,0,0,0,panel.Width,panel.Height,SWP_NOACTIVATE	or SWP_NOZORDER);
end;

procedure TPlugInForm.WebShow(show: Boolean);
begin
 if DockControl.DockState<>dcsHidden then
 begin
  if ChildHandle<>0 then
  begin
   if show then
    begin
     Windows.SetParent(ChildHandle,Panel.Handle);
     ShowWindow(ChildHandle,SW_SHOWNOACTIVATE);
    end
   else
    begin
     ShowWindow(ChildHandle,SW_HIDE);
     Windows.SetParent(ChildHandle,0);
    end;
  end;

 end;
end;

end.