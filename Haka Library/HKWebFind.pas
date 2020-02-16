unit HKWebFind;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DIPcre, SHDocVw, OleCtrls, hakacontrols, ExtCtrls, JvPlacemnt;

type
  TWebFindForm = class(TForm)
    cbFind: TComboBox;
    btnFindNext: TButton;
    btnClose: TButton;
    Pcre: TDIPcre;
    FormStorage: TjvFormStorage;
    Label1: TLabel;
    procedure btnFindNextClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure cbFindChange(Sender: TObject);
    procedure cbFindKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    WB : TWebBrowser;
    body,range,Document : OleVariant;
    LastLen : Integer;
    LastText : string;
    doone : boolean;
  end;

Procedure ShowWebFindDialog(Wb : TWebBrowser);
Procedure ResetWebFindDialog(Wb : TWebBrowser);
Procedure CloseWebFindDialog;

var
 MaxItems : integer = 15;
 OnComboTextEnter : TNotifyEvent = nil;

implementation
{$R *.DFM}

var
  Dialog: TWebFindForm = nil;

Procedure CloseWebFindDialog;
begin
 if assigned(dialog) then Dialog.close;
end;

Procedure ResetWebFindDialog(Wb : TWebBrowser);
begin
 if assigned(dialog) then
 begin
  dialog.wb:=wb;
  dialog.body:=wb.OleObject.document.body;
  dialog.Document:=wb.OleObject.document;
  dialog.DoOne:=false;
 end;
end;

Procedure ShowWebFindDialog(Wb : TWebBrowser);
begin
 if not assigned(dialog) then
  dialog:=TWebFindForm.create(application);
 resetWebFindDialog(wb);
 dialog.show;
end;

procedure TWebFindForm.btnFindNextClick(Sender: TObject);
var
 text,temp : string;
 i:integer;
 sel,r : OleVariant;
begin
try
 HandleComboBoxText(cbFind,MaxItems);
 sel:=Document.selection;
 r:=sel.createRange;
 temp:=r.text;
 if DoOne then
  DoOne:= temp = LastText;
 if doone
 then
  begin
   range.moveend('character',10000000);
   range.movestart('character',lastlen);
  end
 else
  begin
   range:=body.createTextRange;
   range.movetopoint(0,0);
   range.moveend('character',10000000);
  end;
 text:=range.text;
 pcre.MatchPattern:=cbFind.Text;
 i:=pcre.MatchStr(text);
 if i>0 then
 begin
  lastlen:=length(pcre.MatchedStr);
  range.findtext(pcre.MatchedStr,10000000,0);
  range.scrollintoview(true);
  range.select;
  sel:=Document.selection;
  r:=sel.createRange;
  LastText:=r.text;
  doone:=true;
 end
  else MessageDlg('Pattern not found.', mtInformation, [mbOK], 0);
except on exception do end;
end;

procedure TWebFindForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 Dialog:=nil;
end;

procedure TWebFindForm.btnCloseClick(Sender: TObject);
begin
 close;
end;

procedure TWebFindForm.cbFindChange(Sender: TObject);
begin
 doone:=false;
 btnFindNext.Enabled:=length(cbFind.text)>0;
end;

procedure TWebFindForm.cbFindKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if assigned(OnComboTextEnter) then
  OnComboTextEnter(sender);
end;

procedure TWebFindForm.FormShow(Sender: TObject);
begin
 cbFind.SetFocus;
end;

end.
