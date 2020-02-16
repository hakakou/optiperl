unit SplashFrm;
{$I REG.INC}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, AppEvnts;

{$IFDEF SPLASHFORM}
type
  TSplashForm = class(TForm)
    Memo: TMemo;
    Image1: TImage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
   Deb : Boolean;
  protected
   procedure CreateParams(var Params: TCreateParams); override;
  public
   Procedure SplashText(const Text : String);
   Procedure Debug(Num : Integer);
  end;

var
  SplashForm: TSplashForm;
{$ENDIF}

implementation

{$IFDEF SPLASHFORM}

{$R *.dfm}

{ TSplashForm }

procedure TSplashForm.SplashText(const Text: String);
begin
 memo.Lines.Add('> '+text);
end;

procedure TSplashForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
 SplashForm:=nil;
end;

procedure TSplashForm.Debug(Num : Integer);
begin
 if Deb then exit;
 if num=255 then deb:=true;
 WindowState:=wsMaximized;
 if FindWindow('Shell_TrayWnd',nil)>0
  then memo.Lines.Add('Y '+Inttostr(num))
  else memo.Lines.Add('N '+Inttostr(num));
end;

{$ENDIF}

procedure TSplashForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(params);
  params.ExStyle:=params.ExStyle + WS_EX_TOOLWINDOW;
end;

end.