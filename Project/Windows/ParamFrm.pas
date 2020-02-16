unit ParamFrm;  //Modal
{$I Reg.Inc}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,HakaWin,
  OptFolders, StdCtrls,OptGeneral, ComCtrls,OptProcs,
  hyperstr, JvPlacemnt, Mask, JvToolEdit;

type
  TParamType = (ptRun,ptParams);

  TParamForm = class(TForm)
    FormStorage: TjvFormStorage;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    edParams: TComboBox;
    ListView: TListView;
    btnDefault: TButton;
    StartBox: TGroupBox;
    edStartDir: TJvDirectoryEdit;
    cbLeaveOpen: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure edParamsChange(Sender: TObject);
  private
    LastInsert : Integer;
  public
    Constructor Create(AOwner : TComponent; ParamType : TParamType); reintroduce;
  end;

var
  ParamForm: TParamForm;

implementation

{$R *.DFM}

procedure TParamForm.FormCreate(Sender: TObject);
begin
 edParams.Font.Name:=hakawin.DefMonospaceFontName;
 LastInsert:=1;
end;

procedure TParamForm.Button1Click(Sender: TObject);
begin
 SmartStringsAdd(edParams.Items,edParams.text);
end;

procedure TParamForm.ListViewDblClick(Sender: TObject);
begin
 if assigned(listview.selected) then
  edParams.Text:=edParams.Text+' '+listview.Selected.caption
end;

procedure TParamForm.FormShow(Sender: TObject);
var
 i:integer;
 s:string;
 sl : TStringList;
begin
 listview.Left:=edParams.Left;
 listview.Top:=edParams.Top+edParams.Height+9;
 listview.Width:=edParams.Width;
 listview.Height:=GroupBox1.Height-edParams.Height-edparams.top-18;
 s:='';
 with listview do
  for i:=0 to Items.Count-1 do
   s:=s+items[i].Caption+#13#10;

 replacesc(s,'%queryBox%','(prompt user)',true);
 PC_TagConvert(s);

 sl:=TStringList.create;
 sl.text:=s;
 try
  with listview do
   for i:=0 to Items.Count-1 do
    if i<sl.count then
     items[i].SubItems.add(sl[i]);
 finally
  sl.free;
 end;

 edParamsChange(sender);
end;

procedure TParamForm.btnDefaultClick(Sender: TObject);
begin
 edParams.text:='%pathsn% %ARGV%';
end;

procedure TParamForm.edParamsChange(Sender: TObject);
var s:String;
begin
 s:=edParams.text;
 while scanf(s,'%queryBox%',-1)<>0 do
  replacesc(s,'%queryBox%','%(prompt user)%',true);
 while scanf(s,'%n<',-1)<>0 do
  replaceSC(s,'%n<','%<new file:',true);
 while scanf(s,'%o<',-1)<>0 do
  replaceSC(s,'%o<','%<open file:',true);
 while scanf(s,'%toggle<',-1)<>0 do
  replaceSC(s,'%toggle<','%<toggle option:',true);
 while scanf(s,'%set<',-1)<>0 do
  replaceSC(s,'%set<','%<set option:',true);

 PC_TagConvert(s);
 edparams.Hint:=s;
end;

constructor TParamForm.Create(AOwner: TComponent; ParamType: TParamType);
begin
 Inherited Create(AOwner);
 if ParamType=ptRun then
 begin
  StartBox.Visible:=false;
  ClientHeight:=ClientHeight-StartBox.Height-3;
  btnDefaultClick(nil);
 end;
end;

end.