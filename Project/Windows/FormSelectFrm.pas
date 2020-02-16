unit FormSelectFrm; //Modal

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFormSelectForm = class(TForm)
    btnOK: TButton;
    Forms: TListBox;
    btnCancel: TButton;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

end.