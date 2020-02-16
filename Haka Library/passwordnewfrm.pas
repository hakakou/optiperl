unit PasswordNewFrm;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons;

type
  TPasswordNewForm = class(TForm)
    lblPass: TLabel;
    Pass: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    PassRe: TEdit;
    lblPassReenter: TLabel;
    procedure btnOKClick(Sender: TObject);
  public
   Aminchars : integer;
   ANotSameStr,ANotMinCharsStr : string;
  end;

function Execute(var password : string; Minchars,HelpCTX : integer;
          const EnterCaption    : string = 'Enter Password:';
          const ReEnterCaption  : string = 'Reenter Password:';
          const FormCaption     : string = 'Password';
          const NotSameStr      : string = 'Passwords do not match. Please retry.';
          const NotMinCharsStr  : string = 'Password needs %d minimum characters'
         ) : Boolean;

function ExecuteGR(var password : string; Minchars,HelpCTX : integer;
          const  EnterCaption    : string = 'Εισαγωγή κωδικού:';
          const  ReEnterCaption  : string = 'Επαναεισαγωγή κωδικού:';
          const  FormCaption     : string = 'Κωδικός';
          const  NotSameStr      : string = 'Οι κωδικοί δεν ταυτίζονται. Ξαναδοκιμάστε.';
          const  NotMinCharsStr  : string = 'Ο κωδικός χρειάζεται τουλάχιστον %d χαρακτήρες'
         ) : Boolean;


implementation

var
 PasswordNewForm: TPasswordNewForm;
 CancelStr : string ='Cancel';
 OKStr : string ='OK';

function Execute;
begin
 result:=false;
 if not assigned(passwordnewform) then
  PasswordNewForm:=TPasswordNewform.Create(application);
 try
  with passwordnewform do
  begin
   HelpContext:=HelpCTX;
   lblpass.Caption:=EnterCaption;
   lblpassReenter.Caption:=ReEnterCaption;
   caption:=formcaption;
   btnOk.caption:=OKstr;
   btnCancel.Caption:=Cancelstr;
   AMinChars:=minchars;
   ANotSameStr:=NotSameStr;
   ANotMinCharsStr:=NotMinCharsStr;
   pass.text:=password;
   passre.text:=password; 
   if showmodal = mrok then begin
    password:=pass.Text;
    result:=true;
   end;
  end;
 finally
  PasswordNewForm.Release;
  PasswordNewForm:=nil;
 end;
end;

function ExecuteGR;
begin
 CancelStr:='’κυρο';
 result:=Execute(password,minchars,HelpCTX,EnterCaption,ReEnterCaption,
 FormCaption,NotSameStr,NotMinCharsStr);
end;

{$R *.DFM}

procedure TPasswordNewForm.btnOKClick(Sender: TObject);
begin
 if (length(pass.text)>0) and (length(pass.text)<AMinChars) then
 begin
  application.MessageBox(pchar(format(ANotmincharsstr,[AMinchars])),pchar(caption),MB_OK+MB_ICONERROR);
  pass.SetFocus;
  modalresult:=0;
  exit;
 end;
 if (pass.text<>passre.text) then
 begin
  application.MessageBox(pchar(ANotSamestr),pchar(caption),MB_OK+MB_ICONERROR);
  pass.SetFocus;
  modalresult:=0;
 end;
end;

end.

