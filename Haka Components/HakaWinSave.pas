unit HakaWinSave;

interface
uses classes,sysutils,Forms,hkStreams,windows,hakageneral,COntrols,HakaWin;

type

 TOnLoadScreenDimension = Procedure(Sender : TObject; Width,Height : Integer) of object;
 TOnLoadForm = Procedure(Sender : TObject; Form : TForm; LastPPI : Integer; Var Proceed : Boolean) of object;
 TOnAfterLoadForm = Procedure(Sender : TObject; Form : TForm) of object;
 TOnStream = Procedure(Sender : TObject; Stream : TStream) of object;
 TOnCannotFindForm = Procedure(Sender : TObject; Const FormName : String) of object;

 TFormPosSaver = Class(TComponent)
 Private
  FOnBeforeLoadStream: TOnStream;
  FOnBeforeSaveStream: TOnStream;
  FOnLoadStream: TOnStream;
  FOnSaveStream: TOnStream;
  FOnLoadScreenDimension: TOnLoadScreenDimension;
  FOnLoadForm: TOnLoadForm;
  FOnAfterLoadForm : TOnAfterLoadForm;
  FOnCannotFindForm: TOnCannotFindForm;
 public
  LastLoadedVersion : Integer;
  Version : Integer;
  Procedure SaveToStream(Stream : TStream);
  Procedure LoadFromStream(Stream : TStream);
  Function LoadFromFile(Const Filename : String) : Boolean;
  Procedure SaveToFile(Const Filename : String);
  Constructor Create(AOwner : TComponent); override;
  Function WasCorrectVersion : Boolean;
 published
  property OnBeforeLoadStream: TOnStream read FOnBeforeLoadStream write FOnBeforeLoadStream;
  property OnBeforeSaveStream: TOnStream read FOnBeforeSaveStream write FOnBeforeSaveStream;

  property OnLoadStream: TOnStream read FOnLoadStream write FOnLoadStream;
  property OnSaveStream: TOnStream read FOnSaveStream write FOnSaveStream;
  property OnLoadScreenDimension: TOnLoadScreenDimension read FOnLoadScreenDimension write FOnLoadScreenDimension;
  property OnAfterLoadForm: TOnAfterLoadForm read FOnAfterLoadForm write FOnAfterLoadForm;
  property OnLoadForm: TOnLoadForm read FOnLoadForm write FOnLoadForm;
  property OnCannotFindForm: TOnCannotFindForm read FOnCannotFindForm write FOnCannotFindForm;
 end;

Procedure TopRestoreWindows;

procedure Register;

implementation
var
 Zeta : Integer = 1000;

Const
 MagicHeader = 'HWS';

{ TFormPosArray }

Procedure TopRestoreWindows;
var i:integer;
begin
 for i:=0 to screen.CustomFormCount-1 do
  screen.CustomForms[i].Top:=screen.CustomForms[i].Top+Zeta;
end;

Function TFormPosSaver.WasCorrectVersion : Boolean;
begin
 result:=LastLoadedVersion=Version;
end;

procedure TFormPosSaver.SaveToStream(Stream: TStream);
var
 i,ver:integer;
 ARect : TRect;
 sl : TStringList;
begin
 Ver:=Version;
 writeVar(MagicHeader,stream);
 WriteVar(ver,stream);
 if assigned(FOnBeforeSaveStream) then
  FOnBeforeSaveStream(self,stream);
 WriteVar(screen.Width,stream);
 WriteVar(screen.Height,stream);
 writevar(screen.formcount,stream);
 WriteVar(screen.ActiveForm.Name,stream);
 WriteVar(0,stream);
 WriteVar(0,stream);
 sl:=TStringList.Create;
 for i:=screen.FormCount-1 downto 0 do
  sl.AddObject(Screen.Forms[i].Name,Screen.Forms[i]);
 i:=sl.IndexOf(application.MainForm.Name);
 if i<>0 then sl.Move(i,0);

 for i:=0 to sl.Count-1 do
 with sl.Objects[i] as TForm do
 begin
  WriteVar(name,stream);
  ARect:=BoundsRect;
  stream.Write(Arect,sizeof(Trect));
  writevar(visible,stream);
  stream.Write(WindowState,sizeof(TwindowState));
  writevar(PixelsPerInch,stream);
  WriteVar(Floating,Stream);
  Stream.Write(FormStyle,sizeof(TFormStyle));
  Stream.Write(DragKind,sizeof(TDragKind));
  WriteVar(0,stream);
  WriteVar(0,stream);
 end;
 sl.free;
 if assigned(FOnSaveStream) then
  FOnSaveStream(self,stream);
end;

procedure TFormPosSaver.LoadFromStream(Stream: TStream);
var
 i,temp:integer;
 cf : TForm;
 w,h : Integer;
 AcForm,s : string;
 Arect : TRect;
 Vis,float,proceed : Boolean;
 WinState : TWindowState;
 PPI : Integer;
 fs : TFormStyle;
 dk : TDragKind;
begin
 ReadVar(s,Stream);
 if s<>MagicHeader then exit;

  ReadVar(LastLoadedVersion,stream);
  if assigned(FOnBeforeLoadStream) then
   FOnBeforeLoadStream(self,stream);
  if LastLoadedVersion=Version then
  begin
   ReadVar(w,stream);
   readVar(h,stream);
   if assigned(FOnLoadScreenDimension) then
    FOnLoadScreenDimension(self,w,h);
   readvar(i,stream);
   readVar(AcForm,stream);
   ReadVar(temp,stream);
   ReadVar(temp,stream);
   temp:=i;
   for i:=0 to temp-1 do
   begin
    ReadVar(s,stream);
    stream.Read(Arect,sizeof(Trect));

    Readvar(vis,stream);
    stream.Read(WinState,sizeof(TwindowState));
    Readvar(PPI,stream);
    readvar(float,stream);

    Stream.read(Fs,sizeof(TFormStyle));
    Stream.read(Dk,sizeof(TDragKind));

    ReadVar(temp,stream);
    ReadVar(temp,stream);

    cf:=TForm(GetFormByName(s));
    if (not assigned(cf)) then
    begin
     if (assigned(FOnCannotFindForm)) then
      begin
       FOnCannotFindForm(self,s);
       cf:=TForm(GetFormByName(s));
       if not assigned(cf) then continue;
      end
     else
      Continue;
    end;

    proceed:=true;
     if assigned(FOnLoadForm) then
     FOnLoadForm(self,cf,ppi,proceed);
    if not proceed then continue;

    if (dk=dkDrag) then //and (cf.floating) then
     begin
      if not cf.Floating then
       cf.ManualFloat(ARect);
      cf.DragKind:=dkDrag;
      cf.DragMode:=dmManual;
     end
    else
     begin
      if float then
       cf.ManualFloat(ARect);
      cf.DragKind:=dkDock;
      cf.DragMode:=dmAutomatic;
     end;

    cf.FormStyle:=fs;

    if float then
    begin
     if Vis
      then cf.show
      else cf.Close;

     if winstate<>wsMaximized then
      if cf.BorderStyle in [bsSizeable,bsSizeToolWin]
      then
        cf.BoundsRect:=ARect
      else
       begin
        cf.Top:=arect.Top;
        cf.Left:=arect.Left;
       end

     else
      if cf.WindowState=wsMaximized then
         cf.WindowState:=wsNormal;

     cf.WindowState:=WinState;
    end;

    if assigned(FOnAfterLoadForm) then
     FOnAfterLoadForm(self,cf);
   end;

   if assigned(FOnLoadStream) then
   FOnLoadStream(self,stream);
  end;
end;

procedure Register;
begin
  RegisterComponents('Haka', [TFormPosSaver]);
end;

Function TFormPosSaver.LoadFromFile(const Filename: String) : Boolean;
var
 fs : TFileStream;
begin
 result:=false;
 if not fileexists(Filename) then exit;
 fs:=TFileStream.Create(Filename,fmShareDenyNone+fmOpenRead);
 try
  LoadFromStream(fs);
  result:=true;
 finally
  fs.free;
 end;
end;

procedure TFormPosSaver.SaveToFile(const Filename: String);
var
 fs : TFileStream;
begin
 fs:=TFileStream.Create(Filename,fmCreate);
 try
  SaveToStream(fs);
 finally
  fs.free;
 end;
end;

constructor TFormPosSaver.Create(AOwner: TComponent);
begin
 Inherited;
 Version:=2;
end;

end.
