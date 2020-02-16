unit OPerformanceFrm;  //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OptProtoFrm, StdCtrls, jvSpin, Mask, JvMaskEdit;

type
  TOPerformanceForm = class(TOptProtoForm)
    GroupBox1: TGroupBox;
    btnClose: TButton;
    CheckUpdateLag: TjvSpinEdit;
    Label1: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    ExplorerUpdateLag: TjvSpinEdit;
    MaxSearchResults: TjvSpinEdit;
    Label3: TLabel;
    UndoLevel: TjvSpinEdit;
    Label5: TLabel;
    LineLookAhead: TjvSpinEdit;
    Label6: TLabel;
    BoxLookAhead: TjvSpinEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OPerformanceForm: TOPerformanceForm;

implementation

{$R *.dfm}

procedure TOPerformanceForm.Button1Click(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT,7680);
end;

end.