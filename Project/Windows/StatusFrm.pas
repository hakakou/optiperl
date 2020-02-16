unit StatusFrm; //modeless

interface

uses Windows, Forms,sysutils, jclfileutils,hakafile, runperl,variants,
     Classes, Controls, StdCtrls, hakageneral,OptGeneral,
     OptOptions, HyperStr, DIPcre, AppEvnts,OptForm,OptProcs,
     ErrorCheckMdl, JvxCtrls;

type
  TStatusForm = class(TOptiForm)
   StatusBox: TjvTextListBox;
   ApplicationEvents: TApplicationEvents;
   procedure StatusBoxDblClick(Sender: TObject);
    procedure StatusBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ApplicationEventsShowHint(var HintStr: String;
      var CanShow: Boolean; var HintInfo: THintInfo);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  protected
   procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer); override;
  Private
   TempErrors : TStringList;
  public
   ErrorCheck : TErrorCheckMOd;
   Procedure UpdateError(const script : String; Expand : Boolean = false);
  end;

var
  StatusForm: TStatusForm;

implementation

{$R *.DFM}

procedure TStatusForm.StatusBoxDblClick(Sender: TObject);
var
 s:string;
begin
 with statusbox do
  s:=ExtFileFromErrorLine(Items[ItemIndex]);
 if length(s)=0 then
  s:=ErrorCheck.FileName;
 with statusbox do
  PR_UpdateLine(s,integer(items.Objects[itemindex]),true);
end;

procedure TStatusForm.StatusBoxMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
 p:TPoint;
 i:integer;
 s:string;
begin
 p.x:=x;
 p.y:=y;
 i:=StatusBox.ItemAtPos(p,true);
 if (i=-1)
  then
   StatusBox.ShowHint:=false
  else
   begin
    s:=StatusBox.Items[i];
    if (statusbox.Canvas.TextWidth(s)>statusbox.Width-15)
     then
      begin
       Statusbox.hint:=trim(s);
       statusBox.ShowHint:=true;
      end
     else StatusBox.ShowHint:=false;
   end;
end;

procedure TStatusForm.ApplicationEventsShowHint(var HintStr: String;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
 if (hintinfo.HintControl=Statusbox) then
 with hintinfo do
 begin
   hintmaxwidth:=Screen.Width-hintpos.x;
   HideTimeout:=60000;
   ReshowTimeout:=200;
 end;
end;

procedure TStatusForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtBottom;
 Pix:=125;
 index:=InNone;
end;

procedure TStatusForm.FormCreate(Sender: TObject);
begin
 TempErrors:=TStringList.Create;
 ErrorCheck:=TErrorCheckMod.create(nil);
 ErrorCheck.CheckAutoOptions:=false;
 ErrorCheck.Errors:=TempErrors;
 ErrorCheck.ContainerForm:=Self;
end;

procedure TStatusForm.FormDestroy(Sender: TObject);
begin
 ErrorCheck.free;
 TempErrors.Free;
end;

procedure TStatusForm.UpdateError(const script: String; Expand: Boolean = false);
begin
 StatusBox.items.BeginUpdate;
 try
  ErrorCheck.UpdateError(Script,expand);
  StatusBox.Items.Assign(TempErrors);
 finally
  StatusBox.Items.EndUpdate;
  TempErrors.Clear;
 end;
end;

end.