unit EditTodoItemFrm; //Modal

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jvSpin,OptFolders, JvPlacemnt, JvEdit, Mask, JvMaskEdit;

type

  PTodoRec = ^TTOdoRec;
  TTodoRec = Record
   Action : String;
   Priority : Byte;
   Owner : String;
   Category : String;
   Notes : String;
  end;

  TEditTodoItemForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    cbDone: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edCat: TComboBox;
    edOwner: TComboBox;
    edPriority: TjvSpinEdit;
    edAction: TEdit;
    Label5: TLabel;
    memNotes: TMemo;
    FormPlacement: TjvFormPlacement;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function Execute(var ti : TTodoRec; var Done : Boolean;
                 CatList,OwnerList : TStrings) : Boolean;


implementation
{$R *.DFM}

Function Execute;
var
 ETF: TEditTodoItemForm;
begin
 ETF:=TEditTodoItemForm.Create(Application);
 try
  with ETF Do Begin
   cbDone.Checked:=Done;
   edAction.Text:=ti.action;
   edCat.text:=ti.Category;
   memNotes.lines.Text:=ti.Notes;
   edPriority.Text:=inttostr(ti.Priority);
   edOwner.Text:=ti.Owner;
   edCat.Items.Assign(catlist);
   edOwner.Items.Assign(ownerList);
   result:=ShowModal=mrOK;
   if result then
   begin
    Done:=cbDone.Checked;
    ti.action:=edAction.Text;
    ti.Category:=edCat.text;
    ti.Priority:=integer(edPriority.AsInteger);
    ti.Notes:=memNotes.lines.Text;
    ti.Owner:=edOwner.Text;
   end;
  end;
 finally
  ETF.free;
 end;
end;


end.