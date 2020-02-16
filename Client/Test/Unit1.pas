unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OptiClient_TLB, StdCtrls,PerlAPI, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    p : TPerlEvents;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  OLE : array[1..1000] of IOptiPerlClient;
 i:integer =1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
 Ole[i] := CoOptiPerlClient.create;
 Ole[i].InitOptions('c:\perl 58\bin\perl58.dll',1,'c:\1.cgi',0);
 Listbox1.Items.text:=Ole[i].Subroutines;
 Ole[i].Start;
 inc(i);
end;

procedure TForm1.Button2Click(Sender: TObject);
var i : Integer;
begin
 for i:=1 to 1000 do
  Ole[i]:=nil;
end;

end.
