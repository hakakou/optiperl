unit GetHeaderFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls,MailChecker;

type
  TGetHeaderForm = class(TForm)
    Button1: TButton;
    ProgressBar: TProgressBar;
    Timer: TTimer;
    Label1: TLabel;
    Label3: TLabel;
    lblMess: TLabel;
    lblgot: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GetHeaderForm: TGetHeaderForm;

implementation

{$R *.dfm}

procedure TGetHeaderForm.TimerTimer(Sender: TObject);
begin
 ProgressBar.Min:=0;
 ProgressBar.Max:=TotalCOunt;
 ProgressBar.Position:=TotalRetrieved;
 if TotalCount>0 then
 begin
  lblmess.Caption:=inttostr(TotalCOunt)+' ('+inttostr(TotalBytes div 1024)+'kb)';
  lblgot.caption:=Inttostr(TotalRetrieved)+' ('+inttostr(TotalRetrieved*100 div TotalCOunt)+'%)';
 end
  else
 begin
  lblmess.Caption:='-';
  lblgot.caption:='-';
 end;
end;

procedure TGetHeaderForm.FormShow(Sender: TObject);
begin
 ProgressBar.Position:=0;
end;

procedure TGetHeaderForm.Button1Click(Sender: TObject);
begin
 threadcommand:=tcCancel;
 Close;
end;

procedure TGetHeaderForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 GetHEaderForm:=nil;
end;

end.
