unit OptProtoFrm; //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,OptOptions;

type
  TOptProtoForm = class(TForm)
  protected
    SelfOptions : TOptiOptions;
    ColorDialog : TColorDialog;
  public
    constructor Create(AOptions : TOptiOptions; AColorDialog : TColorDialog); reintroduce;
    Destructor Destroy; Override;
    Procedure SetToForm;
    Procedure GetFromForm;
  end;

implementation

{$R *.dfm}
{ TOptProtoForm }

constructor TOptProtoForm.Create(AOptions: TOptiOptions; AColorDialog : TColorDialog);
begin
 SelfOptions:=AOptions;
 ColorDialog:=AColorDialog;
 inherited Create(Application);
 SelfOptions.setToForm(self);
end;

destructor TOptProtoForm.Destroy;
begin
 SelfOptions.getfromForm(self);
 inherited Destroy;
end;

procedure TOptProtoForm.GetFromForm;
begin
 SelfOptions.getfromForm(self);
end;

procedure TOptProtoForm.SetToForm;
begin
 SelfOptions.SetToForm(self);
end;

end.