unit TemSelectFrm; //modal  //memo 1 //Splitter

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,OptFolders, VirtualTrees, VirtualExplorerTree, dcstring,OptGeneral,
  dccommon, dcmemo,parsersmdl, ExtCtrls, StdCtrls, OptOptions;

type
  TTemSelectForm = class(TForm)
    MemoSource: TMemoSource;
    Panel: TPanel;
    Splitter: TSplitter;
    Memo: TDCMemo;
    VET: TVirtualExplorerTree;
    btnCreate: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VETDblClick(Sender: TObject);
    procedure VETChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    procedure SetImages;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TemSelectForm: TTemSelectForm;

implementation

{$R *.dfm}


procedure TTemSelectForm.VETChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 f:string;
begin
 f:=vet.SelectedPath;
 if fileexists(f) then
 begin
  memosource.SyntaxParser:=parsersmod.GetParser(extractfileext(f));
  memo.LoadFromFile(f);
  btnCreate.Enabled:=true;
 end
 else
  begin
   memosource.Lines.clear;
   btnCreate.Enabled:=false;
  end;
end;

procedure TTemSelectForm.SetImages;
begin
 vet.Active:=false;
 vet.DefaultNodeHeight:=32;
 vet.Active:=true;
end;

procedure TTemSelectForm.FormShow(Sender: TObject);
begin
 Panel.Height:=clientheight-btnCreate.Height-10;
 btncreate.Top:=Panel.Height+5;
 btnCancel.Top:=Panel.Height+5;

 if (not directoryexists(options.templatefolder)) then
 begin
  MessageDlg('Could not find folder '+options.templatefolder, mtError, [mbOK], 0);
  exit;
 end;
 Vet.RootFolderCustomPath:=options.templatefolder;
 vet.BrowseTo(ExcludeTrailingBackSlash(options.TemplateFolder)+'\Perl',true,true,true,true);
end;

procedure TTemSelectForm.FormCreate(Sender: TObject);
begin
 Splitter.Width:=OptiSplitterWidth;
 SetMemo(memo,[msModal]);
end;

procedure TTemSelectForm.VETDblClick(Sender: TObject);
begin
 if fileexists(vet.SelectedPath) then
  modalresult:=mrOK;
end;



end.