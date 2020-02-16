unit PerlPrinterFrm;  //Modeless

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OPtGeneral,hyperstr, OptFolders,hakacontrols,OptForm,OptProcs,
  jvSpin, ExtCtrls,httpapp, JvPlacemnt, JvEdit, Mask, JvMaskEdit;

type
  TPerlPrinterForm = class(TOptiForm)
    btnInsert: TButton;
    btnOpen: TButton;
    gbInput: TGroupBox;
    gbOutput: TGroupBox;
    memInput: TMemo;
    memOutput: TMemo;
    FormStorage: TjvFormStorage;
    OpenDialog: TOpenDialog;
    GroupBox: TGroupBox;
    cbStart: TComboBox;
    rbHere: TRadioButton;
    rbLine: TRadioButton;
    cbHere: TComboBox;
    cbEnd: TComboBox;
    Label1: TLabel;
    cbEncode: TCheckBox;
    edIndent: TjvSpinEdit;
    Label2: TLabel;
    Bevel: TBevel;
    Timer: TTimer;
    cbSmart: TCheckBox;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure memInputChange(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure rbLineClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    Making : Boolean;
    procedure MakePrints;
    function GetInputLine(line : Integer) : string;
    procedure FixEnabled;
  protected
    procedure FirstShow(Sender: TObject); override;
    procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer); override;
  end;

var
  PerlPrinterForm: TPerlPrinterForm;

implementation

{$R *.DFM}

procedure TPerlPrinterForm.FirstShow(Sender: TObject);
begin
 SetConstraints(GroupBox.Width+btnInsert.Width+20,GroupBox.height+btnInsert.height+20);
 FixEnabled;
 Constraints.MinWidth:=GroupBox.Width+btnInsert.Width+23;
 Bevel.Width:=GroupBox.Width-2;
 Bevel.Left:=1;
end;

procedure TPerlPrinterForm.FormResize(Sender: TObject);
begin
 gbInput.Width:=ClientWidth div 2 - 7;
 gboutput.Width:=ClientWidth div 2 - 7;
 gbOutput.Left:=ClientWidth div 2 + 4;
end;

procedure TPerlPrinterForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 HandleComboBox(cbEnd);
 HandleComboBox(cbStart);
 HandleComboBox(cbHere);
 Action:=caFree;
 PerlPrinterForm:=nil;
end;

procedure TPerlPrinterForm.MakePrints;
var
 s,qc,outp:string;
 i,idn:integer;
 sl:TStringList;
begin
 if making then exit;
 making:=true;
 sl:=TStringList.create;
 memoutput.Lines.Clear;
 idn:=edIndent.AsInteger;

 if rbHere.Checked then
 begin
  sl.add(StringOfChar(' ',idn)+'<<'+cbHere.Text+';');
  for i:=0 to meminput.Lines.Count -1 do
  begin
   s:=GetInputLine(i);
   if (cbSmart.Checked) and (not cbEncode.checked) then
   begin
    replaceSC(s,'\','\\',False);
    replaceSC(s,'@','\@',False);
    replaceSC(s,'$','\$',False);
    replaceSC(s,'%','\%',False);
   end;
   sl.add(s);
  end;
  sl.add(cbHere.Text);
 end;

 if rbLine.Checked then
 begin
  if length(cbStart.text)>0
   then qc:=cbStart.text[length(cbStart.text)]
   else qc:='';

   for i:=0 To memInput.Lines.Count -1 do
   begin
    s:=getinputline(i);

    if cbsmart.Checked then
    begin
     replaceSC(s,'\','\\',False);
     if (qc<>'''') and (not cbencode.checked) then
     begin
      replaceSC(s,'@','\@',False);
      replaceSC(s,'$','\$',False);
      replaceSC(s,'%','\%',False);
     end;
     if (Length(qc)=1) and (not cbEncode.Checked) then
      replaceSC(s,qc,'\'+qc,False);
    end;

    sl.add(StringOfChar(' ',idn)+Outp+cbStart.Text+s+cbEnd.text);
   end;
 end;

 memoutput.Lines.Assign(sl);
 sl.free;
 making:=false;
end;

Procedure TPerlPrinterForm.FixEnabled;
begin
 cbHere.Enabled:=rbHere.checked;
 cbStart.Enabled:=rbLine.checked;
 cbEnd.enabled:=rbLine.checked;
 cbSmart.Enabled:=not cbEncode.checked;
end;

procedure TPerlPrinterForm.memInputChange(Sender: TObject);
begin
 Timer.Enabled:=true;
 cbSmart.Enabled:=not cbEncode.checked;
end;

function TPerlPrinterForm.GetInputLine(line: Integer): string;
begin
 Result:=meminput.Lines[line];
 if cbEncode.Checked
  then Result:=HTTPEncode(Result);
end;

procedure TPerlPrinterForm.btnOpenClick(Sender: TObject);
begin
 if OpenDialog.Execute then
  memInput.Lines.LoadFromFile(OpenDialog.FileName);
end;

procedure TPerlPrinterForm.btnInsertClick(Sender: TObject);
begin
 PR_InsertTextAtCursor(memOutput.Lines.Text);
end;

procedure TPerlPrinterForm.rbLineClick(Sender: TObject);
begin
 FixEnabled;
 Timer.Enabled:=true;
end;

procedure TPerlPrinterForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtTop;
 Pix:=0;
 Index:=InTools;
end;

procedure TPerlPrinterForm.TimerTimer(Sender: TObject);
begin
 Timer.Enabled:=false;
 MakePrints;
end;

end.