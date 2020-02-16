unit AboutFrm; //Modal
{$I REG.INC}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, x2000la, ExtCtrls, Buttons, OptGeneral, OptFolders, OptOptions,
  hyperstr, shellapi, JvAppearingLabel, JvLabel, jvTypes;

type
  TAboutForm = class(TForm)
    CTimer: TTimer;
    PanMain: TPanel;
    PanOK: TPanel;
    Bevel4: TBevel;
    BtnOK: TButton;
    Image2: TImage;
    lblURL: TLabel2000X;
    Label1: TLabel;
    lblVersion: TLabel;
    procedure CTimerTimer(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  end;

implementation
var
  TimerDone : Boolean = false;

{$R *.DFM}

procedure TAboutForm.CTimerTimer(Sender: TObject);
begin
 BtnOK.Enabled:=True;
 CTimer.Enabled:=False;
end;

procedure TAboutForm.BtnOKClick(Sender: TObject);
begin
  close;
end;

end.


