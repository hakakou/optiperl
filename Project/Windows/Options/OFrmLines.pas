unit OFrmLines;  //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OptProtoFrm, StdCtrls, ExtCtrls, HaKaTabs,
  DrawComboBox;

type
  TOFormLines = class(TOptProtoForm)
    LineGroup: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Line1Pen: TLineStyleComboBox;
    Line1Width: TLineWidthComboBox;
    Line1Visible: TCheckBox;
    Line2Visible: TCheckBox;
    Line2Width: TLineWidthComboBox;
    Line2Pen: TLineStyleComboBox;
    Line3Visible: TCheckBox;
    Line3Width: TLineWidthComboBox;
    Line3Pen: TLineStyleComboBox;
    Line4Visible: TCheckBox;
    Line4Width: TLineWidthComboBox;
    Line4Pen: TLineStyleComboBox;
    Line5Visible: TCheckBox;
    Line5Width: TLineWidthComboBox;
    Line5Pen: TLineStyleComboBox;
    Line6Visible: TCheckBox;
    Line6Width: TLineWidthComboBox;
    Line6Pen: TLineStyleComboBox;
    Line1Color: THKColorBox;
    Line2Color: THKColorBox;
    Line3Color: THKColorBox;
    Line4Color: THKColorBox;
    Line5Color: THKColorBox;
    Line6Color: THKColorBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  OFormLines: TOFormLines;

implementation

{$R *.dfm}

procedure TOFormLines.FormCreate(Sender: TObject);
begin
 inherited;
 Line1Color.ColorDialog:=ColorDialog;
 Line2Color.ColorDialog:=ColorDialog;
 Line3Color.ColorDialog:=ColorDialog;
 Line4Color.ColorDialog:=ColorDialog;
 Line5Color.ColorDialog:=ColorDialog;
 Line6Color.ColorDialog:=ColorDialog;
end;

end.