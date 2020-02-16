unit WorkingFrm; //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TWorkingForm = class(TForm)
    Label1: TLabel;
    btnTerminate: TButton;
    procedure btnTerminateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    Terminate : Boolean;
  end;

var
  WorkingForm: TWorkingForm;

implementation

{$R *.dfm}

procedure TWorkingForm.btnTerminateClick(Sender: TObject);
begin
 Terminate:=true;
end;

procedure TWorkingForm.FormCreate(Sender: TObject);
begin
 Screen.Cursor:=crHourGlass;
 Terminate:=false;
end;

procedure TWorkingForm.FormDestroy(Sender: TObject);
begin
 Screen.Cursor:=crDefault;
 WorkingForm:=nil;
end;

end.