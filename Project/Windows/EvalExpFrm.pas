unit EvalExpFrm; //Modeless //memo

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dccommon, dcmemo, StdCtrls, OptFolders,Buttons, optgeneral,Custdebmdl,OptForm,OptOptions,
  JvPlacemnt;

type
  TEvalExpForm = class(TOptiForm)
    edEval: TComboBox;
    memOutPut: TDCMemo;
    btnEval: TSpeedButton;
    btnClear: TSpeedButton;
    FormStorage: TjvFormStorage;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnEvalClick(Sender: TObject);
    procedure edEvalChange(Sender: TObject);
    procedure edEvalKeyPress(Sender: TObject; var Key: Char);
  private
    sl : TStringList;
    procedure jumptoend;
  Protected
    procedure FirstShow(Sender: TObject); override;
    procedure SetDockPosition(var Alignment: TRegionType;
      var Form: TDockingControl; var Pix, index: Integer); override;
  end;

var
  EvalExpForm: TEvalExpForm;

implementation

{$R *.DFM}

procedure TEvalExpForm.FirstShow(Sender: TObject);
begin
 sl:=TStringList.create;
 setmemo(memOutPut,[]);
 edEvalChange(sender);
end;

procedure TEvalExpForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 action:=cafree;
 evalExpForm:=nil;
end;

procedure TEvalExpForm.FormDestroy(Sender: TObject);
begin
 sl.free;
end;

procedure TEvalExpForm.btnClearClick(Sender: TObject);
begin
 memoutput.lines.clear;
end;

procedure TEvalExpForm.jumptoend;
var p : tpoint;
begin
 memoutput.SetFocus;
 p.x:=0;
 p.y:=memoutput.lines.count-1;
 memoutput.MemoSource.SetCaretPoint(p);
end;

procedure TEvalExpForm.btnEvalClick(Sender: TObject);
var
 s,e:string;
begin
 if not (debmod.status in [stStopped,stTerminated]) then
 begin
  memoutput.lines.add('Debugger must be available.');
  jumptoend;
  exit;
 end;
 HandleComboBox(edEval);
 s:='Evaluating '+edEval.text+'...';
 memoutput.lines.add(s);
 jumptoend;
 screen.Cursor:=crHourglass;
 btnEval.Enabled:=false;
 sl.clear;
 try
  e:=Debmod.EvaluateVar(edEval.Text);
  sl.text:=e;
 finally
  screen.cursor:=snormal;
  btnEval.Enabled:=true;
 end;
 with memoutput.lines do
 begin
  strings[memoutput.lines.count-1]:=s+' Finished.';
  AddStrings(sl);
  jumptoend;
  add('');
 end;
end;

procedure TEvalExpForm.edEvalChange(Sender: TObject);
begin
 btnEval.Enabled:=length(edEval.text)>0;
end;

procedure TEvalExpForm.edEvalKeyPress(Sender: TObject; var Key: Char);
begin
 if (key=#13) and (btnEval.enabled) then
 begin
  key:=#0;
  btnevalClick(sender);
 end;
end;

procedure TEvalExpForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=nil;
 Alignment:=drtNone;
 Pix:=0;
 Index:=InDebugs;
end;

end.
