unit PasswordEntryFrm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons;

type
  TPasswordEntryForm = class(TForm)
    lblPass: TLabel;
    Pass: TEdit;
    btnOK: TButton;
    Button1: TButton;
  public
  end;

function Execute(var password : string; HelpCTX : Integer;
          const EnterCaption    : string = 'Enter Password:';
          const FormCaption     : string = 'Password'
         ) : Boolean;

function ExecuteGR(var password : string; HelpCTX : Integer;
          const  EnterCaption    : string = 'Εισαγωγή κωδικού:';
          const  FormCaption     : string = 'Κωδικός'
         ) : Boolean;

implementation

var
 PasswordEntryForm: TPasswordEntryForm;

function Execute;
begin
 result:=false;
 if not assigned(passwordentryform) then
  PasswordEntryForm:=TPasswordentryform.Create(application);
 try
  with passwordentryform do
  begin
   HelpContext:=HelpCTX;
   lblpass.Caption:=EnterCaption;
   caption:=formcaption;
   pass.text:=password;
   if showmodal = mrok then begin
    password:=pass.Text;
    result:=true;
   end;
  end;
 finally
  PasswordentryForm.Release;
  PasswordentryForm:=nil;
 end;
end;

function ExecuteGR;
begin
 result:=Execute(password,HelpCTX,EnterCaption,FormCaption);
end;

{$R *.DFM}

end.

