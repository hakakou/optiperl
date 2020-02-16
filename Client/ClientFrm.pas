unit ClientFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls;

type
  TClientForm = class(TForm)
    TerminateTimer: TTimer;
    procedure TerminateTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;

implementation

{$R *.dfm}

procedure TClientForm.TerminateTimerTimer(Sender: TObject);
begin
 Application.Terminate;
end;

end.
