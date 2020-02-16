unit HKModeSelectForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TModeSelectForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    edManual: TEdit;
    procedure CheckBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edManualChange(Sender: TObject);
  private
    Procedure PutCheckBOxes;
    procedure GetCheckBoxes;
  public
    { Public declarations }
  end;

Function CHModeSelect(var mode : Integer) : Boolean;
Function StrToPermissions(Str : String) : Integer;
Function PermissionsToStr(Mode : Integer) : String;

implementation
{$R *.DFM}

Function PermissionsToStr(Mode : Integer) : String;
begin
 result:=StringOfChar('-',9);
 if mode>=400 then begin result[1]:='r'; dec(mode,400); end; //OwnerRead
 if mode>=200 then begin result[2]:='w'; dec(mode,200); end; //OwnerWrite
 if mode>=100 then begin result[3]:='x'; dec(mode,100); end; //OwnerExecute

 if mode>=40 then begin result[4]:='r'; dec(mode,40); end; //GroupRead
 if mode>=20 then begin result[5]:='w'; dec(mode,20); end; //GroupWrite
 if mode>=10 then begin result[6]:='x'; dec(mode,10); end; //GroupExecute

 if mode>=4 then begin result[7]:='r'; dec(mode,4); end; //PublicRead
 if mode>=2 then begin result[8]:='w'; dec(mode,2); end; //PublicWrite
 if mode>=1 then begin result[9]:='x'; dec(mode,1); end; //PublicExecute
end;

Function StrToPermissions(Str : String) : Integer;
begin
 str:=Uppercase(trim(str));
 result:=-1;
 if (length(str)=0) then exit;
 if str[1]='D' then delete(str,1,1);
 if (length(str)<>9) then exit;
 result:=0;
 if str[1]='R' then Inc(result, 400); //OwnerRead
 if str[2]='W' then Inc(result, 200); //OwnerWrite
 if Str[3]='X' then Inc(result, 100); //OwnerExecute
 if str[4]='R' then Inc(result, 40); //GroupRead
 if str[5]='W' then Inc(result, 20); //GroupWrite
 if str[6]='X' then Inc(result, 10); //GroupExecute
 if str[7]='R' then Inc(result, 4); //PublicRead
 if str[8]='W' then Inc(result, 2); //PublicWrite
 if str[9]='X' then Inc(result); //PublicExecute
end;

Function CHModeSelect(var mode : Integer) : Boolean;
var
 ModeSelectForm: TModeSelectForm;
begin
  ModeSelectForm:=TModeSelectForm.Create(Application);
 with ModeSelectForm do
 try
  begin
   edManual.text:=IntToStr(mode);
   Result:=Showmodal=mrOK;
   if result then
    mode:=StrToInt(edManual.Text);
  end;
 finally
  Free;
 end;
end;

{ TModeSelectForm }

procedure TModeSelectForm.GetCheckBoxes;
var
 i,j:integer;
const
 Dec : array[1..3] of integer = (100,10,1);
begin
 j:=0;
 for i:=0 to ComponentCount -1 do
  if (Components[i] is TCheckBox) then
   with Components[i] as TCheckbox do
    if Checked then
     j:=j+(Tag)*Dec[helpcontext];
 edManual.Text:=IntToStr(j);
end;

procedure TModeSelectForm.PutCheckBOxes;
var
 i,j,c:integer;
 valid : Boolean;
 n:string;
 cb : TCheckBOx;
begin
 val(edManual.Text,j,i);
 valid:=(i=0) and (j>=0) and (j<=777);

 for i:=0 to ComponentCount -1 do
  if (Components[i] is TCheckBox) then
  begin
   TCheckBox(Components[i]).Enabled:=valid;
   TCheckBox(Components[i]).Checked:=False;
  end;

 btnOK.Enabled:=valid;
 if not valid then Exit;

 n:=edManual.Text;

 while Length(n)<3 do n:='0'+n;

 for c:=1 to Length(n) do
 begin
  j:=StrToInt(n[c]);
  for i:=0 to ComponentCount -1 do
   if (Components[i] is TCheckBox) then
    begin
     cb:=TCheckBox(Components[i]);
     if cb.helpcontext=c then
      cb.checked:=(j AND cb.tag) = cb.Tag;
    end;
 end;
 if valid then
end;

procedure TModeSelectForm.CheckBox1Click(Sender: TObject);
begin
 if TWinControl(Sender).focused then GetCheckBoxes;
end;

procedure TModeSelectForm.FormShow(Sender: TObject);
begin
 PutCheckBoxes;
end;

procedure TModeSelectForm.edManualChange(Sender: TObject);
begin
 if edManual.focused then PutCheckBoxes;
end;

end.
