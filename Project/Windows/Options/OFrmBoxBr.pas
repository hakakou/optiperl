unit OFrmBoxBr;    //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OptProtoFrm, StdCtrls, ExtCtrls, HaKaTabs, jvSpin,
  DrawComboBox, Mask, JvMaskEdit;

type
  TOFormBoxBr = class(TOptProtoForm)
    BoxBrGroup: TGroupBox;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    BoxBr1Curve: TjvSpinEdit;
    BoxBr1Visible: TCheckBox;
    BoxBr2Visible: TCheckBox;
    BoxBr2Curve: TjvSpinEdit;
    BoxBr3Visible: TCheckBox;
    BoxBr3Curve: TjvSpinEdit;
    BoxBr4Visible: TCheckBox;
    BoxBr4Curve: TjvSpinEdit;
    BoxBr5Visible: TCheckBox;
    BoxBr5Curve: TjvSpinEdit;
    BoxBr6Visible: TCheckBox;
    BoxBr6Curve: TjvSpinEdit;
    BoxBr1Brush: TFillStyleComboBox;
    BoxBr2Brush: TFillStyleComboBox;
    BoxBr3Brush: TFillStyleComboBox;
    BoxBr4Brush: TFillStyleComboBox;
    BoxBr5Brush: TFillStyleComboBox;
    BoxBr6Brush: TFillStyleComboBox;
    BoxBr1Color: THKColorBox;
    BoxBr2Color: THKColorBox;
    BoxBr3Color: THKColorBox;
    BoxBr4Color: THKColorBox;
    BoxBr5Color: THKColorBox;
    BoxBr6Color: THKColorBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OFormBoxBr: TOFormBoxBr;

implementation

{$R *.dfm}

procedure TOFormBoxBr.FormCreate(Sender: TObject);
begin
 inherited;
 BoxBr1Color.ColorDialog:=ColorDialog;
 BoxBr2Color.ColorDialog:=ColorDialog;
 BoxBr3Color.ColorDialog:=ColorDialog;
 BoxBr4Color.ColorDialog:=ColorDialog;
 BoxBr5Color.ColorDialog:=ColorDialog;
 BoxBr6Color.ColorDialog:=ColorDialog;
end;

end.