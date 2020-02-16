unit FTPUploadFrm;  //Modal
{$I REG.INC}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,  ExtCtrls, HKTransfer, HakaWin, AppEvnts;

type
  TFTPUploadForm = class(TForm)
    Image: TImage;
    lblStatus: TLabel;
    btnClose: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    Trans : TBaseTransfer;
    CancelPress : ^Boolean;
    procedure OnStatus(Sender: TObject; const Status: String);
  end;

var
  FTPUploadForm: TFTPUploadForm;

implementation

{$R *.dfm}

{ TFTPUploadForm }

Procedure TFTPUploadForm.OnStatus(Sender : TObject; Const Status : String);
begin
 lblStatus.Caption:=Status;
end;

procedure TFTPUploadForm.FormDestroy(Sender: TObject);
begin
 EnableApplication(true);
 FTPUploadForm:=nil;
end;

procedure TFTPUploadForm.btnCloseClick(Sender: TObject);
begin
 if assigned(CancelPress) then
  CancelPress^:=true;
 if assigned(trans)
  then Trans.Abort;
end;

procedure TFTPUploadForm.FormCreate(Sender: TObject);
begin
 DisableApplication;
end;

end.