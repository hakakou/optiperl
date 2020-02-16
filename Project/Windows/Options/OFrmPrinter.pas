unit OFrmPrinter; //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OptProtoFrm, StdCtrls, jvSpin, JvCombobox, JvColorCombo, JvEdit,
  Mask, JvMaskEdit;

type
  TOFormPrinter = class(TOptProtoForm)
    GroupBox10: TGroupBox;
    Label67: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Label71: TLabel;
    Label68: TLabel;
    Label72: TLabel;
    PrintMarginTop: TjvSpinEdit;
    PrintMarginBottom: TjvSpinEdit;
    PrintMarginLeft: TjvSpinEdit;
    PrintMarginRight: TjvSpinEdit;
    PrintSyntax: TCheckBox;
    PrintLines: TCheckBox;
    PrintBoxes: TCheckBox;
    PrintOvLinesWidth: TjvSpinEdit;
    PrintOvLines: TCheckBox;
    PrintLinesPerPage: TjvSpinEdit;
    PrintOnlySolid: TCheckBox;
    Label1: TLabel;
    EditFontLbl: TLabel;
    PrintFontName: TjvFontComboBox;
    PrintComp: TCheckBox;
    PrintFooter: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OFormPrinter: TOFormPrinter;

implementation

{$R *.dfm}

end.