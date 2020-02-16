unit LogFrm; //modeless

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,variants,
  StdCtrls, OptFolders, OptProcs, ExtCtrls,OptOptions,jclfileutils, hyperstr, Menus, DIPcre,
  hakafile,OptForm, JvxCtrls, HakaControls;

type
  TLogFormTypes = (ltError,ltAccess);

  TLogForm = class(TOptiForm)
    ListBox: TjvTextListBox;
    Timer: TTimer;
    FPcre: TDIPcre;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
  private
    Updating : Boolean;
    LastSize : Int64;
    LastUpdated : TDateTime;
    function LastUpdatedAgo : string;
  protected
    procedure SetDockPosition(var Alignment: TRegionType;
      var Form: TDockingControl; var Pix, index: Integer); override;
  public
    LogType : TLogFormTypes;
    constructor Create(AOwner: TComponent; Lt : TLogFormTypes); reintroduce;
  end;

procedure OpenLogWindow(lt : TLogFormTypes);


implementation
var
  LogForms: array [ltError..ltAccess] of TLogForm;
const
  LogFormStr : array [ltError..ltAccess] of string =
   ('Error Log','Access Log');
  LogFormName : array [ltError..ltAccess] of string =
   ('ErrorLogForm','AccessLogForm');

{$R *.DFM}

procedure OpenLogWindow(lt : TLogFormTypes);
begin
 if not Assigned(LogForms[lt]) then
  LogForms[lt]:=TLogForm.Create(Application,lt);
 LogForms[lt].Show;
end;

procedure TLogForm.FormCreate(Sender: TObject);
begin
 SetCaption(LogFormStr[LogType]);
 LastUpdated:=0;
 Updating:=False;
end;

procedure TLogForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=CaFree;
 LogForms[LogType]:=nil;
end;

constructor TLogForm.Create(AOwner: TComponent; Lt: TLogFormTypes);
begin
 LogType:=lt;
 inherited CreateNamed(AOwner,LogFormName[lt]);
end;

procedure TLogForm.TimerTimer(Sender: TObject);
var
 f : string;
 s: int64;
begin
 if Updating then Exit;

 Updating:=True;

 case logtype of
  ltaccess : f:=Options.AccessLogFile;
  ltError :  f:=Options.ErrorLogFile;
 end;

 if fileexists(f) then
 try
  s:=FileGetSize(f);
  if s<>LastSize then
  begin

   listbox.Items.BeginUpdate;
   try
    SafeLoadFileInListBox(f,listbox.Items,iMax(0,s-Options.MaxReadFromLogs));
   finally
    listbox.Items.EndUpdate;
   end;

   if listbox.Items.Count>0 then
    listbox.Items.Delete(0);
   LastUpdated:=now;

   if ListBox.Items.Count>0 then
    ListBox.ItemIndex:=Listbox.Items.Count-1;

   timer.Tag:=10; 
  end;
  LastSize:=s;
 except
  ListBox.Items.Clear;
  listbox.Items.Add('Cannot open file '+f);
 end;

 if timer.Tag=10 then
 begin
  SetCaption(LogFormStr[LogType]+' - '+
    IntToStr(listbox.Items.Count)+' lines - '+LastUpdatedAgo);
  Timer.Tag:=0;
 end;
 timer.Tag:=timer.Tag+1;

 Updating:=False;
end;

function TLogForm.LastUpdatedAgo: string;
begin
 if LastUpdated<>0
  then DateTimeToString(Result,'n:ss',Now-LastUpdated)
  else result:='Problem';
end;

procedure TLogForm.ListBoxDblClick(Sender: TObject);
var
 s:string;
 l,c:integer;
begin
 with listbox do
  s:=items[itemindex];
 with FPcre do
 begin
  SetSubjectStr(s);
  if Match(0) >= 0 then
  begin
   s:=SubStr(1);
   val(SubStr(2),l,c);
   if c<>0 then l:=0;
   PR_GotoLine(s,l);
  end;
 end;
end;

procedure TLogForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doWebbrowser];
 Alignment:=drtInside;
 Pix:=0;
 Index:=inLogs;
end;


end.