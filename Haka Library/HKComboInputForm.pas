unit HKComboInputForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  jvPlacemnt, StdCtrls,hakageneral;

type
  TComboInputForm = class(TForm)
    lblText: TLabel;
    Button1: TButton;
    Button2: TButton;
    edInput: TComboBox;
    FormStorage: TjvFormStorage;
    lblStatus: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;


Function ComboInput(Var Input : String; Const IniSection : String;
                    Const Caption:string = 'Input Box';
                    Const Text:string = 'Enter text:';
                    HelpContext : Integer = 0;
                    LittleStatus : string = '') : Boolean;

var MaxComboItems : integer = 15;

implementation

{$R *.DFM}

Function ComboInput;
var
 CI: TComboInputForm;
begin
 CI:=TComboInputForm.Create(Application);
 Ci.lblText.Caption:=text;
 ci.Caption:=caption;
 ci.FormStorage.Active:=(iniSection<>'');
 CI.FormStorage.IniSection:=IniSection;
 ci.FormStorage.RestoreFormPlacement;
 ci.HelpContext:=Helpcontext;
 ci.lblStatus.Caption:=LittleStatus;
 if input<>'' then ci.edInput.text:=input;
 result:=ci.ShowModal=mrOk;
 input:=ci.edInput.text;
 Ci.Free;
end;

procedure TComboInputForm.Button1Click(Sender: TObject);
begin
 with edInput do begin
  if items.IndexOf(text)=-1 then
   items.Insert(0,text);
  if items.count>MaxComboItems then
  repeat
   items.Delete(MaxComboItems);
  until items.count=MaxComboItems;
 end;
end;


procedure TComboInputForm.Button2Click(Sender: TObject);
begin
 FormStorage.Active:=false;
end;

end.
