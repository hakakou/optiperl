unit OFrmBoxPar;  //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OptProtoFrm, StdCtrls, ExtCtrls, HaKaTabs, jvSpin,
  DrawComboBox, JvEdit, Mask, JvMaskEdit;

type
  TOFormBoxPar = class(TOptProtoForm)
    BoxParGroup: TGroupBox;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Bevel11: TBevel;
    Bevel12: TBevel;
    BoxPar1Curve: TjvSpinEdit;
    BoxPar1Visible: TCheckBox;
    BoxPar2Visible: TCheckBox;
    BoxPar2Curve: TjvSpinEdit;
    BoxPar3Visible: TCheckBox;
    BoxPar3Curve: TjvSpinEdit;
    BoxPar4Visible: TCheckBox;
    BoxPar4Curve: TjvSpinEdit;
    BoxPar5Visible: TCheckBox;
    BoxPar5Curve: TjvSpinEdit;
    BoxPar6Visible: TCheckBox;
    BoxPar6Curve: TjvSpinEdit;
    BoxPar1Brush: TFillStyleComboBox;
    BoxPar2Brush: TFillStyleComboBox;
    BoxPar3Brush: TFillStyleComboBox;
    BoxPar4Brush: TFillStyleComboBox;
    BoxPar5Brush: TFillStyleComboBox;
    BoxPar6Brush: TFillStyleComboBox;
    BoxPar1Color: THKColorBox;
    BoxPar2Color: THKColorBox;
    BoxPar3Color: THKColorBox;
    BoxPar4Color: THKColorBox;
    BoxPar5Color: THKColorBox;
    BoxPar6Color: THKColorBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OFormBoxPar: TOFormBoxPar;

implementation

{$R *.dfm}

procedure TOFormBoxPar.FormCreate(Sender: TObject);
begin
 inherited;
 BoxPar1Color.ColorDialog:=ColorDialog;
 BoxPar2Color.ColorDialog:=ColorDialog;
 BoxPar3Color.ColorDialog:=ColorDialog;
 BoxPar4Color.ColorDialog:=ColorDialog;
 BoxPar5Color.ColorDialog:=ColorDialog;
 BoxPar6Color.ColorDialog:=ColorDialog;
end;

end.