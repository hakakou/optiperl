unit PerlInfoFrm; //Modeless  //memo 1

interface

uses Sysutils, Windows, Forms, Controls, ComCtrls, Classes, OptFOlders,HakaPipes,
     dccommon, dcmemo,clipbrd, OptForm,OptOptions,
     dxBar,CentralImageListMdl;

type
  TPerlInfoForm = class(TOptiForm)
    memInfo: TDCMemo;
    BarManager: TdxBarManager;
    dxDetInfo: TdxBarButton;
    dxCopyToClipboard: TdxBarButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure dxDetInfoClick(Sender: TObject);
    procedure dxCopyToClipboardClick(Sender: TObject);
  Private
    Procedure DoPerlInfo(detailed : Boolean);
  protected
    procedure SetDockPosition(var Alignment: TRegionType;
      var Form: TDockingControl; var Pix, index: Integer); override;
    Procedure FirstShow(Sender: TObject); Override;
    Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); override;
  end;

var
  PerlInfoForm: TPerlInfoForm;

implementation

{$R *.DFM}

procedure TPerlInfoForm.DoPerlInfo(detailed: Boolean);
Const
 detailstr : array[false..true] of char = ('v','V');
var
 ps : TPipeStatus;
begin
 memInfo.Lines.Text:=PipeSTDAndWait(options.PathToPerl,' -'+detailstr[detailed],'',
  '','',5000,NORMAL_PRIORITY_CLASS,ps);
 if (ps<>psTerminated) then
  memInfo.Lines.Text:='Error getting information.';
end;

procedure TPerlInfoForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 PerlInfoForm:=nil;
end;

procedure TPerlInfoForm.FormCreate(Sender: TObject);
begin
 SetMemo(memInfo,[]);
end;

procedure TPerlInfoForm.dxDetInfoClick(Sender: TObject);
begin
 DoPerlInfo(dxDetInfo.Down);
end;

procedure TPerlInfoForm.dxCopyToClipboardClick(Sender: TObject);
begin
 Clipboard.astext:=meminfo.text;
end;

procedure TPerlInfoForm.FirstShow(Sender: TObject);
begin
 DoPerlInfo(false);
end;

Procedure TPerlInfoForm.GetPopupLinks(Popup: TDxBarPopupMenu; MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=barmanager.Bars[0].ItemLinks;
end;

procedure TPerlInfoForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtInside;
 Pix:=0;
 Index:=InNone;
end;

end.