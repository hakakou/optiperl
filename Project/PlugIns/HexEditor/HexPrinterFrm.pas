unit HexPrinterFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  THexPrinterForm = class(TForm)
    Image: TImage;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  HexPrinterForm: THexPrinterForm;

implementation

{$R *.DFM}

end.