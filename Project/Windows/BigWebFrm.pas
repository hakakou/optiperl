unit BigWebFrm; //Modeless

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, OleCtrls, ActiveX, AppEvnts, HKWebFind, SHDocVw;

type
   TBigWebForm = class(TForm)
    WebBrowser: TWebBrowser;
    procedure FormShow(Sender: TObject);
   protected
    Procedure CreateParams(var Params: TCreateParams); override;
    Procedure WMActivate(var msg : TWMActivate); message WM_Activate;
   public
    Function WebFocused : Boolean;
   end;

var
  MainWebForm,PodWebForm : TBigWebForm;

implementation
{$R *.dfm}

procedure TBigWebForm.CreateParams(var Params: TCreateParams);
begin
 inherited;
 params.Style:=params.Style+WS_CHILd;
end;

function TBigWebForm.WebFocused: Boolean;
begin
 result:=GetForegroundWindow=handle;
end;

procedure TBigWebForm.WMActivate(var msg: TWMActivate);
begin
 with msg do
 if (ActiveWindow=0) then
 //If the app was inactive
 begin
  if (Active=WA_ACTIVE) or (Active=WA_ClickACTIVE) then
   SetForegroundWindow(Application.mainform.Handle);
 end;
 inherited;
end;

procedure TBigWebForm.FormShow(Sender: TObject);
var
 wh : THandle;
begin
 //Re: Properties Dialog Looses Focus
 OnShow:=nil;
 wh := GetWindowLong(Handle, GWL_STYLE);
 wh := wh and not WS_CAPTION and not WS_THICKFRAME;
 SetWindowLong(Handle, GWL_STYLE, wh);
 SetWindowPos(Handle, 0, 0, 0, 0, 0,
  SWP_FRAMECHANGED or SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
end;

{
initialization
//Q: Paste works fine, but Cut and Copy won't work. What's the problem?
//  OleInitialize(nil);
finalization
//  OleUninitialize;
}

end.
