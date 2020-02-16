unit PerlTidyFrm; //Modal //memo 2 //Splitter
{$I REG.INC}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dcstring, dcsystem, dcparser, dccommon, dcmemo, StdCtrls,optgeneral,ParsersMdl,
  jvSpin,OptFolders, OptOptions,hakageneral,hyperstr,
  hakahyper,hyperfrm,jclfileutils, ExtCtrls, JvPlacemnt, JvEdit, Mask,
  JvMaskEdit;

type
  TPerltidyForm = class(TForm)
    MemoSource: TMemoSource;
    btnCLose: TButton;
    btnSave: TButton;
    btnPreview: TButton;
    cbBackup: TCheckBox;
    Label1: TLabel;
    edIndentColumns: TjvSpinEdit;
    edTightness: TjvSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    edContIndent: TjvSpinEdit;
    cbIndBlockCom: TCheckBox;
    edMaxLine: TjvSpinEdit;
    Label4: TLabel;
    cbMangle: TCheckBox;
    cbCuddledElse: TCheckBox;
    btnDefaults: TButton;
    Label5: TLabel;
    edOptions: TEdit;
    FormStorage: TjvFormStorage;
    Panel: TPanel;
    memOut: TDCMemo;
    edLog: TDCMemo;
    Splitter: TSplitter;
    cbLog: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnDefaultsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure edMaxLineChange(Sender: TObject);
    procedure OptChanged(Sender: TObject);
    procedure memOutSelectionChange(Sender: TObject);
    procedure cbLogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    OptStr : string;
    TmpTidy : string;
    Changed:Boolean;
    procedure CreateTidy;
    procedure MakeOptions;
  public
    FileName : string;
    Output : string;
  end;

var
  PerltidyForm: TPerltidyForm;

{
 Instructions

 Create Form. Must set  FIlename right
 after creating.

 ModalResult is mrOK if Save pressed, or mrCancel with Cancel
 if OK then output in Output.
 }


implementation

{$R *.DFM}

procedure TPerltidyForm.FormCreate(Sender: TObject);
begin
 Splitter.Height:=OptiSplitterWidth;
 memosource.SyntaxParser:=ParsersMod.Perl;
 setmemo(memout,[msModal]);
 SetMemo(edLog,[msModal]);
 panel.Height:=clientheight-btnDefaults.Top-btnDefaults.Height-3;
 Constraints.MinWidth:=btnPreview.Left+btnPreview.Width+15;
 TmpTidy:=OptGeneral.GetTempFile;
 Changed:=True;
end;

procedure TPerltidyForm.btnDefaultsClick(Sender: TObject);
begin
 cbBackup.Checked:=True;
 edIndentColumns.Value:=4;
 edTightness.Value:= 1;
 edContIndent.Value := 2;
 cbIndBlockCom.Checked := True;
 edMaxLine.Value := 80;
 cbMangle.Checked:=False;
 cbCuddledElse.Checked:=False;
 edOptions.Text:='';
 Changed:=True;
end;

procedure TPerltidyForm.btnSaveClick(Sender: TObject);
begin
 {$IFDEF PERLTIDYCRIPPLE}
   ShowDisabledMessage;
   modalresult:=mrCancel;
   exit;
 {$ELSE}
   CreateTidy;
   if not btnSave.Enabled then Exit;
   if cbBackup.Checked then
    Windows.CopyFIle(PChar(FileName),PChar(CreateBackupName(FileName)),False);
   Output:=memOut.Text;
 {$ENDIF}
end;

procedure TPerltidyForm.MakeOptions;
const
 indBlockStr : array[False..True] of string = (' -nibc',' -ibc');
 CudElseStr : array[False..True] of string = ('',' -ce');
 LogStr : array[False..True] of string = ('',' -log');
begin

 OptStr:=Format('-i=%d -pt=%d -bt=%d -sbt=%d -ci=%d -l=%d',
 [edIndentColumns.AsInteger,edTightness.AsInteger,
  edTightness.AsInteger,edTightness.AsInteger,
  edContIndent.AsInteger,edMaxLine.asinteger]);

 OptStr:=OptStr+indBlockStr[cbIndBlockCom.Checked];
 OptStr:=OptStr+CudElseStr[cbCuddledElse.Checked];

 if cbMangle.Checked then
  OptStr:='-mangle';

 OptStr:=OptStr+LogStr[cbLog.checked]+' -q';
 OptStr:=OptStr+' '+EdOptions.Text;
end;

procedure TPerltidyForm.CreateTidy;
var
 s,log,err,everror:string;
 prev : Integer;
 sl : TStringList;
 i:integer;
 perl : string;
begin
 if not changed then Exit;
 deletefile(tmptidy);
 screen.cursor:=crHourglass;
 try
  MakeOptions;
  prev:=memOut.WinLinePos;
  log:=tmptidy+'.log';
  err:=tmptidy+'.err';
  perl:=GetTempFile;
  try
   s:=Format(
     'use Perl::Tidy;'+#13#10+
     'Perl::Tidy::perltidy('+#13#10+
     'source      => ''%s'','+#13#10+
     'destination => ''%s'','+#13#10+
     'argv        => ''%s'','+#13#10+
     'perltidyrc  => ''%s'','+#13#10+
     'logfile     => ''%s'','+#13#10+
     'errorfile   => ''%s'','+#13#10+
     ');'+#13#10,[Filename,tmptidy,optstr,programpath+'library\perl\.perltidyrc',log,err]);

   saveStr(s,perl);
   s:='"'+Options.pathtoperl+'" -I"'+folders.IncludePath+'" "'+perl+'"';
   WaitExec(s,SW_HIDE);
  finally
   deletefile(perl);
  end;

  edlog.MemoSource.BeginUpdate(0);
  edLog.Lines.Clear;

  if fileexists(Log) then
  begin
   edlog.LoadFromFile(log);
   deletefile(log);
  end;

  if length(evError)>0 then
   edLog.Lines.Insert(0,everror);

  if fileexists(err) then
  begin
   sl:=TStringList.Create;
   sl.LoadFromFile(err);
   deleteFile(err);
   edLog.Lines.Add('Errors');
   edLog.Lines.Add(dupchr('-',60));
   for i:=0 to sl.Count-1 do
    edlog.Lines.add(sl[i]);
   sl.free;
  end;

  edlog.MemoSource.EndUpdate;

  if fileexists(tmptidy)
  then
   begin
    memosource.LoadFromFile(tmptidy);
    deletefile(tmptidy);
    memOut.WinLinePos:=prev;
    btnSave.Enabled:=true;
    Changed:=False;
   end
  else
   begin
    memosource.Lines.Clear;
    memosource.Lines.Add('Error in custom options!');
    btnSave.Enabled:=False;
    Changed:=true;
   end;
 finally
  screen.cursor:=crDefault;
 end;
 {$IFDEF PERLTIDYCRIPPLE}
  height:=height+1;
  height:=height-1;
 {$ENDIF}
end;

procedure TPerltidyForm.btnPreviewClick(Sender: TObject);
begin
 CreateTidy;
end;

procedure TPerltidyForm.edMaxLineChange(Sender: TObject);
begin
 memOut.MarginPos:=edMaxLine.AsInteger;
 Changed:=True;
end;

procedure TPerltidyForm.OptChanged(Sender: TObject);
begin
 Changed:=True;
end;

procedure TPerltidyForm.memOutSelectionChange(Sender: TObject);
begin
 {$IFDEF PERLTIDYCRIPPLE}
   memout.MemoSource.SetSelection(stNotSelected,0,0,0,0);
 {$ENDIF}
end;

procedure TPerltidyForm.cbLogClick(Sender: TObject);
begin
 Changed:=True;
 edLog.Visible:=cbLog.Checked;
 Splitter.Visible:=cbLog.Checked;
end;

procedure TPerltidyForm.FormShow(Sender: TObject);
begin
 cbLogClick(sender);
end;

end.