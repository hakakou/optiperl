unit FileCompareFrm; //Modeless

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OptFolders, rmDiff, StdCtrls, ToolWin, ComCtrls,ScriptInfoUnit,
  OptForm,hakawin, JvPlacemnt;

type
  TFileCompareForm = class(TOptiForm)
    DiffEngine: TrmDiffEngine;
    rmDiffMap: TrmDiffMap;
    DiffViewer: TrmDiffViewer;
    FormStorage: TjvFormStorage;
    ToolBar1: TToolBar;
    btnCompare: TToolButton;
    btnFile2: TToolButton;
    btnFile1: TToolButton;
    OpenDialog: TOpenDialog;
    ToolButton1: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCompareClick(Sender: TObject);
    procedure btnFile1Click(Sender: TObject);
    procedure btnFile2Click(Sender: TObject);
  private
    File1,file2 : string;
  protected
    procedure SetDockPosition(var Alignment: TRegionType;
      var Form: TDockingControl; var Pix, index: Integer); override;
  public
    { Public declarations }
  end;

var
  FileCompareForm: TFileCompareForm;

implementation

{$R *.DFM}

procedure TFileCompareForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 FileCompareForm:=nil;
end;

procedure TFileCompareForm.FormCreate(Sender: TObject);
begin
 DiffViewer.Font.Name:=hakawin.DefMonospaceFontName;
 if assigned(ActiveScriptInfo) then
  File1:=ActiveScriptInfo.path;
 btnFile1.Hint:=file1;
end;

procedure TFileCompareForm.btnCompareClick(Sender: TObject);
begin
 DiffViewer.SetSourceLabel1(extractFilename(File1));
 DiffViewer.SetSourceLabel2(extractFilename(File2));
 DiffEngine.CompareFiles(File1,File2);
end;

procedure TFileCompareForm.btnFile1Click(Sender: TObject);
begin
 if fileexists(file1) then
  OpenDialog.InitialDir:=extractfilepath(file1);
 if OpenDialog.execute then
 begin
  File1:=OpenDialog.FileName;
  btnFile1.Hint:=file1;
  btnCompare.Enabled:=Fileexists(File1) and fileexists(File2);
  OpenDialog.InitialDir:=extractfilepath(file1);
 end;
end;

procedure TFileCompareForm.btnFile2Click(Sender: TObject);
begin
 if fileexists(file2) then
  OpenDialog.InitialDir:=extractfilepath(file2);
 if OpenDialog.execute then
 begin
  File2:=OpenDialog.FileName;
  btnFile2.Hint:=file2;
  btnCompare.Enabled:=Fileexists(File1) and fileexists(File2);
  OpenDialog.InitialDir:=extractfilepath(file2);
 end;
end;

procedure TFileCompareForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtTop;
 Pix:=0;
 Index:=InTools;
end;


end.