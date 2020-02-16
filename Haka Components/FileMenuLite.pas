unit FileMenuLite;

interface
uses forms, classes, dialogs, menus, sysutils, windows,
  Controls;

type
  TIOFunction = function(const Filename: string): boolean of object;
  TSetCaption = procedure(const FileName: string) of object;
  TQueryTOSaveDialog = function(const Str: string): Integer of object;
  TOpenSaveDialogExecute = Function(var Filename : String; Const InitialDir : String) : Boolean of Object;

type
  TFileMenuLite = class(TComponent)
  private
    FOnOpendialog,FOnSaveDialog: TOpenSaveDialogExecute;
    FFileName,FDefaultFileName: string;
    FMaxList: Integer;
    FOnNew, FOnOpen, FOnSave : TIOFunction;
    FOnQueryToSaveDialog:TQueryToSaveDialog;
    FOnNotFoundDialog : TSetCaption;
    FOnSetCaption: TSetCaption;
    FEnabled: boolean;
    FIsNew: Boolean;
    SaveOK : Boolean;
    FRecent: TStrings;

    procedure SetMaxItems(m: integer);
    procedure AddRecent;
    function SaveQuery: boolean;
    procedure SetStrings(Value: TStrings);
    procedure FixRecentMaxItems;
    procedure SaveFile(WithDialog : Boolean);
    procedure OpenFileNoCheck(const Filename: String);
  public
    Dirty: boolean;
    Function CanClose : Boolean;
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure New;
    procedure Save;
    procedure SaveAs;
    procedure Open;
    procedure OpenFile(const Filename : String);
    property Filename: string read FFilename write FFilename;
    property IsNew: Boolean read FIsNew write FIsNew;
 published
    property Recent: TStrings read FRecent write SetStrings;
    property OnSaveDialog: TOpenSaveDialogExecute read FOnSaveDialog write FOnSaveDialog;
    property OnOpenDialog: TOpenSaveDialogExecute read FOnOpenDialog write FOnOpenDialog;
    property MaxList: Integer read FMaxList write SetMaxItems;
    property DefaultFileName: string read FDefaultFilename write FDefaultFilename;
    property OnQueryToSaveDialog: TQueryToSaveDialog read FOnQueryToSaveDialog write FOnQueryToSaveDialog;
    property OnNotFoundDialog: TSetCaption read FOnNotFoundDialog write FOnNotFoundDialog;
    property OnOpen: TIOFunction read FOnOpen write FOnOpen;
    property OnSave: TIOFunction read FOnSave write FOnSave;
    property OnNew: TIOFunction read FOnNew write FOnNew;
    property OnNewFormCaption: TSetCaption read FOnSetCaption write FOnSetCaption;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Haka', [TFileMenuLite]);
end;

procedure TFileMenuLite.SetStrings(Value: TStrings);
begin
 FRecent.Assign(Value);
end;

constructor TFileMenuLite.create(AOwner: TComponent);
begin
  FEnabled := not (csDesigning in ComponentState);
  FMaxList := 10;

//  FNotFoundStr := 'File %s not found.';
//  FileChangedString := 'File %s has changed. Save Changes?';
//  FileChangedCaption := 'Save changes';
//    case MessageDlg(Format(FFileChangedStr, [FFilename]),
//         mtConfirmation, [mbYes,mbNo,mbCancel], 0) of
//   application.MessageBox(pchar(Format(FNotFoundStr, [F])), nil, MB_OK
//    + MB_ICONERROR);

  FRecent:=TStringList.Create;
  dirty:=false;
  SaveOK:=true;
  inherited create(AOwner);
end;

destructor TFileMenuLite.destroy;
begin
 if assigned(FRecent) then FRecent.Free;
 inherited Destroy;
end;

procedure TFileMenuLite.New;
begin
  if savequery then
    if assigned(OnNew) then
      if OnNew(filename) then
      begin
        FFilename := FDefaultFilename;
        FIsNew := true; Dirty := false;
        if assigned(FOnSetCaption) then FOnSetCaption(FFilename);
      end;
end;

procedure TFileMenuLite.Open;
var f : string;
begin
  if not assigned(FOnOpenDialog) then exit;

  if (savequery) and (SaveOK) then
  begin
   f:='';
   if not FOnOpenDialog(f,'') then exit;
   OpenFileNoCheck(f);
  end;
end;

procedure TFileMenuLite.Save;
begin
 SaveFile(FIsNew);
end;

procedure TFileMenuLite.SaveAs;
begin
 SaveFile(true);
end;

function TFileMenuLite.SaveQuery: Boolean;
begin
 result := true;
 SaveOK:=true;
 if not assigned(FOnQueryToSaveDialog) then exit;
 if (Dirty) then
  case FOnQueryToSaveDialog(FFilename) of
    mrCancel:
      begin
       result := false;
       exit;
      end;
    mrYes: save;
  end;
end;

procedure TFileMenuLite.AddRecent;
var
  i: integer;
begin
  i := FRecent.IndexOf(FFilename);
  if i = -1 then FRecent.Insert(0, FFilename) else
    FRecent.Move(i, 0);
end;

procedure TFileMenuLite.SetMaxItems(m: integer);
begin
 FMaxList := m;
 FixRecentMaxItems;
end;

Procedure TFileMenuLite.FixRecentMaxItems;
var
 c:integer;
begin
  if FEnabled then
   for c := FRecent.count - 1 downto FMaxList do
    FRecent.Delete(c);
end;

function TFileMenuLite.CanClose: Boolean;
begin
 Canclose := (SaveQuery=true) and (SaveOK);
end;

procedure TFileMenuLite.SaveFile(WithDialog : Boolean);
var f,filename:string;
begin
  if (not Assigned(onSave)) or (not assigned(FOnSaveDialog)) then exit;
  filename:=ExtractFilename(FFileName);
  f:=FFileName;
  if (WithDialog) then
   begin
    SaveOK:=FOnSaveDialog(filename,ExtractFilePath(FFilename));
    F:=filename;
   end
  else
   SaveOK:=true;
  if (saveOK) and (OnSave(F)) then
  begin
    Dirty := false;
    FFilename := F;
    FIsNew := false;
    if assigned(FOnSetCaption) then FOnSetCaption(F);
    AddRecent;
  end;
end;

Procedure TFileMenuLite.OpenFileNoCheck(const Filename: String);
begin
   if not assigned(FOnOpen) then exit;
   if not FileExists(filename) then
   begin
    if assigned(FOnNotFoundDialog) then
     FOnNotFoundDialog(filename);
    exit;
   end;
   if not FOnOpen(Filename) then exit;
   FFilename := FileName;
   Dirty := false;
   AddRecent;
   FIsNew := false;
   if assigned(FOnSetCaption) then FOnSetCaption(FFilename);
end;

procedure TFileMenuLite.OpenFile(const Filename: String);
begin
  if (savequery) and (SaveOK) then
   OPenFileNoCheck(Filename);
end;

end.

