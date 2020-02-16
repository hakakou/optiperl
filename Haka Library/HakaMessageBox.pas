unit HakaMessageBox;

interface

uses
  classes,Forms,Dialogs,inifiles,StdCtrls,sysutils,ExtCtrls,jvAppUtils;

function MessageDlgMemo(const Msg: string;
                        DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
                        HelpCtx,MessageID : Longint;
                        const QuestionText : string = 'Do not show this message again.') : Word;

function MessageDlgButtonTimer(const Msg: string;
                        DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
                        HelpCtx,MilliSecs : Longint) : Word;


Procedure ResetMessageDlgsMemo;

implementation

const
 MessageSec = 'Messages';

type
 TDumbClass = Class
 private
  Form : TForm;
  Timer : TTimer;
  Procedure OnTimer(Sender : TObject);
 end;

Procedure ResetMessageDlgsMemo;
var
 ini : TIniFile;
begin
 ini:=TIniFile.Create(GetDefaultIniName);
 ini.EraseSection(MessageSec);
 ini.free;
end;

{ TDumbClass }

procedure TDumbClass.OnTimer(Sender: TObject);
var i:integer;
begin
 Timer.Enabled:=false;
 for i:=0 to form.ControlCount-1 do
  form.Controls[i].Enabled:=true;
end;

function MessageDlgButtonTimer(const Msg: string;
                        DlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
                        HelpCtx,MilliSecs : Longint) : Word;
var
 dlg: TForm;
 DC : TDumbClass;
 i:integer;
begin
 dlg:=CreateMessageDialog(msg, dlgtype, Buttons);
 dc:=TDumbClass.Create;
 try
  dlg.HelpContext:=helpctx;
  dlg.BorderIcons:=[];
  dc.Form:=dlg;
  dc.Timer:=TTimer.Create(nil);
  dc.Timer.Interval:=MilliSecs;
  dc.Timer.enabled:=true;
  dc.Timer.OnTimer:=dc.OnTimer;
  for i:=0 to dlg.ControlCount-1 do
   if dlg.Controls[i] is TButton then
    dlg.Controls[i].Enabled:=false;
  result:=dlg.showmodal;
 finally
  dlg.Free;
  dc.Timer.Free;
  dc.Free;
 end;
end;


Function MessageDlgMemo;
var
 ini : TIniFile;
 dlg: TForm;
 cb: TCheckBox;
 mytop,i,min,max: Integer;
 lab:TLabel;
begin
 try
  ini:=TIniFile.Create(GetDefaultIniName);
 except
  on exception do begin
   result:=MessageDlg(msg,dlgtype,buttons,helpctx);
   exit;
  end;
 end;
 result:=ini.ReadInteger(MessageSec,inttostr(MessageID),0);
 if result=0 then begin

   dlg:=CreateMessageDialog(msg, dlgtype, Buttons);
   dlg.HelpContext:=helpctx;
   cb:=TCheckBox.Create(dlg);
   lab:=TLabel.Create(dlg);

   lab.Parent:=dlg;
   lab.Visible:=false;
   lab.Caption:=QuestionText;

   cb.Caption:=QuestionText;
   cb.Parent:=dlg;
   cb.Checked:=false;
   cb.Width:=lab.Width+30;

   mytop:=0;
   max:=0;
   min:=50000;
   // Position checkbox above buttons.
   for i:=0 to dlg.ControlCount-1 do
    begin
     if dlg.Controls[i] is TButton then
       begin
         mytop:=dlg.Controls[i].Top+5;
         dlg.Controls[i].Top:=dlg.Controls[i].Top+cb.Height+17;
         if dlg.Controls[i].Left+dlg.Controls[i].Width>max then
          max:=dlg.Controls[i].Left+dlg.Controls[i].Width;
         if dlg.Controls[i].left<min then
          min:=dlg.Controls[i].left;
       end;
    end;

    cb.Top:=mytop+1;
    dlg.Height:=dlg.Height+cb.Height+15;

    if dlg.Width<cb.Width then
     dlg.Width:=cb.Width+50;

    cb.Left:=dlg.ClientWidth div 2-cb.Width div 2;

    max:=(dlg.ClientWidth - (max - min)) div 2 - min;

    for i:=0 to dlg.ControlCount-1 do
     begin
      if dlg.Controls[i] is TButton then
       dlg.Controls[i].Left:=dlg.Controls[i].Left+max;
     end;

    result:=dlg.showmodal;
    if cb.Checked then
      ini.WriteInteger(MessageSec,inttostr(MessageID),result);
    dlg.free;
  end;
 ini.free;
end;

end.
