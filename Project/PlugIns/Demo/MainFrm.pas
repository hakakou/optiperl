unit MainFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    LogBox: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

Procedure AddLog(Const Text : String);

implementation
{$R *.dfm}

Procedure AddLog(Const Text : String);
begin
 if assigned(MainForm) then
  with MainForm.LogBox do
  begin
   Items.add(text);
   ItemIndex:=Items.Count-1;
  end;
end;


end.
