program OleTest;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  OptiClient_TLB in '..\OptiClient_TLB.pas';

{$R *.res}
             
begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
