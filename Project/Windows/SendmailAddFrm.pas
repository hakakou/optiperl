unit SendmailAddFrm;  //Modal
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,hyperstr, StdCtrls,hyperfrm,hakageneral,hakafile;

type
  TSendMailAddForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edMail: TEdit;
    edDrive: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    edDate: TEdit;
    btnHelp: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    procedure Install(const path, exe: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SendMailAddForm: TSendMailAddForm;

implementation

{$R *.dfm}

procedure TSendMailAddForm.FormCreate(Sender: TObject);
var
 i:integer;
 s:string;
begin
 s:=GetDrives;
 for i:=1 to length(s) do
 begin
  if upcase(s[i])=s[i] then
   edDrive.items.add(s[i]+':');
  if s[i]='C' then
   edDrive.ItemIndex:=edDrive.Items.Count-1;
 end;
end;

Procedure TSendMailAddForm.Install(const path,exe : string);
var s,f,c:string;
begin
 s:=path;
 replaceC(s,'/','\');
 s:=edDrive.Text+s;
 f:=extractFilename(s);
 s:=extractFilepath(s);
 if (f='') then
 begin
  MessageDlg('Path to '+extractFilenoExt(exe)+' does not make sence.', mtError, [mbOK], 0);
  exit;
 end;
 forcedirectories(s);
 c:=programPath+exe;
 if not fileexists(c) then
 begin
  MessageDlg('Cannot find '+exe+'. Please re-install.', mtError, [mbOK], 0);
  exit;
 end;
 copyFile(pchar(c),pchar(s+f+'.exe'),false);
 savestr('',s+f);
end;

procedure TSendMailAddForm.btnOKClick(Sender: TObject);
begin
 if trim(edmail.text)<>'' then Install(edMail.Text,'sendmail.exe');
 if trim(eddate.text)<>'' then Install(eddate.Text,'date.exe');
end;

procedure TSendMailAddForm.btnHelpClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT,6750);
end;

end.