unit AutoViewFrm;    //modeless //memo

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,OptForm, ExtCtrls, dccommon, dcmemo, OptOptions,Jvfileutil,
  StdCtrls, Mask, JvToolEdit, HakaControls;

type
  TAutoViewForm = class(TOptiForm)
    memAuto: TDCMemo;
    UpdateTimer: TTimer;
    Panel: TPanel;
    edFileName: TJvFilenameEdit;
    procedure UpdateTimerTimer(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    LastDateTime : TDateTime;
    LastSize : Int64;
  Protected
    procedure FirstShow(Sender: TObject); override;
    procedure SetDockPosition(var Alignment: TRegionType;
      var Form: TDockingControl; var Pix, index: Integer); override;
  end;

var
  AutoViewForm: TAutoViewForm;

implementation

{$R *.dfm}

procedure TAutoViewForm.UpdateTimerTimer(Sender: TObject);
var
 LastXY,LastCXY : TPoint;
begin
 if not visible then exit;
 updatetimer.Enabled:=false;
 try
  if not FIleExists(edFilename.filename) then
  begin
   if memauto.Lines.Count>0 then
    memAUto.Lines.Clear;
   exit;
  end;
  if (LastDateTime<>FileDateTime(edFIleName.filename)) or
     (LastSize<>GetFileSize(edFileName.filename)) then
  begin
   LastXY.y:=memAuto.WinLinePos;
   LastXY.x:=memAuto.WinCharPos;
   LastCXy:=memauto.MemoSource.GetCaretPoint;
   lastsize:=GetFileSize(edFileName.filename);
   LastDateTime:=FileDateTime(edFIleName.filename);

   MemAuto.MemoSource.BeginUpdate(0);
   try
    SafeLoadFileInListBox(edFIlename.filename,Memauto.Lines);
   finally
    MemAuto.MemoSource.EndUpdate;
   end;

   memAuto.WinLinePos:=LastXY.y;
   memAuto.WinCharPos:=LastXY.x;
   memauto.MemoSource.CaretPoint:=lastcxy;
  end;
 finally
  updatetimer.Enabled:=true;
 end;
end;

procedure TAutoViewForm.edFileNameChange(Sender: TObject);
begin
 if FIleExists(edFilename.filename) then
  edFIlename.InitialDir:=extractfilepath(edFilename.filename);
end;

procedure TAutoViewForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 AutoViewForm:=nil;
end;

procedure TAutoViewForm.FirstShow(Sender: TObject);
begin
 SetMemo(memAuto,[]);
 panel.Height:=edFilename.Height;
end;

procedure TAutoViewForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doWebbrowser];
 Alignment:=drtInside;
 Pix:=0;
 Index:=inNone;
end;


end.