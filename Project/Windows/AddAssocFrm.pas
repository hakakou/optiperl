unit AddAssocFrm; //Modal

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, JvToolEdit, Mask;

type
  TAddAssocForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edExt: TEdit;
    edProgram: TJvFilenameEdit;
    procedure edProgramChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Function Execute(var Ext,Prog : String) : Boolean;

implementation
{$R *.DFM}

Function Execute(var Ext,Prog : String) : Boolean;
var
  AddAssocForm: TAddAssocForm;
begin
 AddAssocForm:=TAddAssocForm.Create(application);
 with AddAssocForm do
 try
  edExt.Text:=ext;
  edProgram.FileName:=prog;
  result:=showmodal=mrok;
  if result then
  begin
   ext:=edExt.Text;
   if (ext<>'') and (ext[1]='.')
    then delete(ext,1,1);
   prog:=edProgram.FileName;
  end;
 finally
  AddAssocForm.free;
 end;
end;

procedure TAddAssocForm.edProgramChange(Sender: TObject);
begin
 btnOK.Enabled:=(fileexists(edProgram.filename));
end;

procedure TAddAssocForm.FormCreate(Sender: TObject);
begin
 EdProgramChange(sender);
end;

end.