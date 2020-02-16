program OptiClient;

uses
  ClientFrm in 'ClientFrm.pas' {ClientForm},
  OptiClient_TLB in 'OptiClient_TLB.pas',
  AutoClient in 'AutoClient.pas' {OptiPerlClient: CoClass},
  PlugCommon in '..\Project\Units\PlugCommon.pas',
  OptiPerl_TLB in '..\Project\Units\OptiPerl_TLB.pas',
  Forms;


{$R *.TLB}
{$R *.res}

begin
  //This is OPTI CLIENT
  Application.ShowMainForm:=false;
  Application.Initialize;
  Application.CreateForm(TClientForm, ClientForm);
  Application.Run;
end.
