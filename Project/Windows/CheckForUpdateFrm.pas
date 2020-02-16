unit CheckForUpdateFrm; //Modal
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,OptOptions, OptGeneral,OleCtrls, SHDocVw, HyperStr, OptFolders;

type
  TCheckUpdateForm = class(TForm)
    btnClose: TButton;
    lblStatus: TLabel;
    WebBrowser: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure WebBrowserDocumentComplete(Sender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  CheckUpdateForm: TCheckUpdateForm;

implementation

{$R *.DFM}

procedure TCheckUpdateForm.FormCreate(Sender: TObject);
var
 v,s:string;
 d,u : String;
begin
 WebBrowser.Navigate('https://raw.githubusercontent.com/hakakou/optiperl/master/LatestVersion.txt');
end;

procedure TCheckUpdateForm.WebBrowserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
 lblStatus.Caption:='';
end;

procedure TCheckUpdateForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 CheckUpdateForm:=nil;
end;

procedure TCheckUpdateForm.FormShow(Sender: TObject);
begin
 WebBrowser.Width:=clientwidth-16;
 webbrowser.Height:=btnClose.top-16;
 webbrowser.Left:=8;
 WebBrowser.top:=8;
end;

end.