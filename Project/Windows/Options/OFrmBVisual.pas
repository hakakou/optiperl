unit OFrmBVisual; //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OptProtoFrm, StdCtrls, ExtCtrls, HaKaTabs, jvSpin,
  DrawComboBox, Mask, JvMaskEdit;

type
  TOFormVisual = class(TOptProtoForm)
    EditMarginGroup: TGroupBox;
    ColorLbl: TLabel;
    StyleMarginLbl: TLabel;
    WitdhMarginLbl: TLabel;
    PositionLbl: TLabel;
    MarginVisible: TCheckBox;
    MarginStyle: TLineStyleComboBox;
    MarginWidth: TLineWidthComboBox;
    MarginPos: TjvSpinEdit;
    MarginColor: THKColorBox;
    EditGutterGroup: TGroupBox;
    ColorGutterLbl: TLabel;
    StyleLbl: TLabel;
    WidthLbl: TLabel;
    GutterVisible: TCheckBox;
    GutterStyle: TFillStyleComboBox;
    GutterWidth: TjvSpinEdit;
    GutterColor: THKColorBox;
    GroupBox2: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    LineSeparator: TCheckBox;
    LineSepWidth: TLineWidthComboBox;
    LineSepStyle: TLineStyleComboBox;
    LineSepColor: THKColorBox;
    GroupBox5: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    LHVisible: TCheckBox;
    LHWidth: TLineWidthComboBox;
    LHLineStyle: TLineStyleComboBox;
    LHBackStyle: TFillStyleComboBox;
    LHLineColor: THKColorBox;
    LHBackColor: THKColorBox;
    WordWrapMargin: TCheckBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OFormVisual: TOFormVisual;

implementation

{$R *.dfm}

procedure TOFormVisual.FormCreate(Sender: TObject);
begin
 inherited;
 MarginColor.ColorDialog:=ColorDialog;
 GutterColor.ColorDialog:=ColorDialog;
 LineSepColor.ColorDialog:=ColorDialog;
 LHLineColor.ColorDialog:=ColorDialog;
 LHBackColor.ColorDialog:=ColorDialog;
end;

end.