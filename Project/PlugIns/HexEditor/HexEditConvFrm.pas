unit HexEditConvFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

  //
//  TTranslationType = (ttAnsi , ttDos8 , ttASCII , ttMac , ttEBCDIC );

type
  THexEditConvForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Button1: TButton;
    Button2: TButton;
    procedure ListBox1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  HexEditConvForm: THexEditConvForm;

implementation

{$R *.DFM}


procedure THexEditConvForm.ListBox1Click(Sender: TObject);
begin
     Button1.Enabled := (ListBox1.ItemIndex > -1 ) and
                        (ListBox2.ItemIndex > -1 ) and
                        (ListBox2.ItemIndex <> ListBox1.ItemIndex );
end;

end.