unit FileMenuHdl;

{
----------------------------------------------------------------
TFileMenuHandler v1.0 by Harry Kakoulidis 11/1999
kcm@mailbox.gr
http://kakoulidis.homepage.com

Component for handling Recent files list and Open, Save,
Save As, Exit Commands. Uses a ini file for the recent
list. Read FileMenuHdl.txt form more information.

This is Freeware. Please copy FilMen10.zip unchanged.
If you find bugs, have options etc. Please send at my e-mail.

The use of this component is at your own risk.
I do not take any responsibility for any damages.
----------------------------------------------------------------
}

interface
uses forms, classes, dialogs, menus, sysutils, windows, controls;

type
  TIOFunction = function(const Filename: string): boolean of object;
  TSetCaption = procedure(const FileName: string) of object;

type
  TFileMenuHandler = class(TComponent)
  private
    FFileName: string;
    Fopendialog: TOpenDialog;
    Fsavedialog: TSaveDialog;
    FDefaultFileName: string;
    FMaxList: Integer;
    FFileMenu: TMenuItem;
    FNotFoundStr,
      FFileChangedCaption, FFileChangedStr: string;
    FSeparator: TMenuItem;
    FOnNew, FOnOpen, FOnSave: TIOFunction;
    FOnSetCaption: TSetCaption;
    FAddShortCut: Boolean;
    FEnableMenuList: boolean;
    FEnabled: boolean;
    FLoadStart, FMoveToTop, FIsNew: Boolean;
    FParamCount, FNewItemImageIndex: Integer;
    FDirectSave,FSaveAsCancel:boolean;

    POnShow: TNotifyEvent;
    POnCloseQuery: TCloseQueryEvent;
    procedure FMHCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FMHShow(Sender: TObject);

    Procedure SaveAsProc;
    procedure SetMaxItems(m: integer);
    procedure FileItemClick(Sender: Tobject);
    procedure UpdateList;
    function SaveQuery: boolean;
    procedure LoadRecentList;
    procedure InsertFilename;
    procedure SetEnableMenuList(e: boolean);
    procedure NotFoundDialog(const f: string);
  public
    RecentList: TStringList;
    IsDirty: boolean;
    procedure OpenFile(const f: string);
    constructor create(AOwner: TComponent); override;
    destructor destroy; override;
    procedure New;
    procedure Save;
    procedure SaveAs;
    procedure Open;
    procedure Exit(var CanClose: boolean);
    property Filename: string read FFilename;
    property IsNew: Boolean read FIsNew;
  published
    property SaveDialog: TSaveDialog read FSaveDialog write
      FSaveDialog;
    property OpenDialog: TOpenDialog read FOpenDialog write
      FOpenDialog;
    property MaxList: Integer read FMaxList write SetMaxItems;
    property DefaultFileName: string read FDefaultFilename write
      FDefaultFilename;
    property FileMenu: TMenuitem read FFileMenu write FFilemenu;
    property NotFoundString: string read FNotFoundStr write
      FNotFoundStr;
    property FileChangedString: string read FFileChangedStr write
      FFileChangedStr;
    property FileChangedCaption: string read FFileChangedCaption write
      FFileChangedCaption;
    property OnOpen: TIOFunction read FOnOpen write FOnOpen;
    property OnSave: TIOFunction read FOnSave write FOnSave;
    property OnNew: TIOFunction read FOnNew write FOnNew;
    property OnNewFormCaption: TSetCaption read FOnSetCaption write
      FOnSetCaption;
    property AddShortcut: Boolean read FAddShortcut write
      FAddShortcut;
    property NewItemImageIndex: integer read FNewItemImageIndex write
      FNewItemImageIndex;
    property EnableMenuList: boolean read FEnableMenuList write
      SetEnableMenuList;
    property MoveToTop: boolean read FMoveToTop write
      FMoveToTop;
    property ParamCountLook: Integer read FParamCount write
      FParamCount;
    property LoadNewOnStart: Boolean read FLoadStart write
      FLoadStart;
  end;

procedure Register;

implementation

function ShortToLongFileName(const ShortName: string): string; {FROM RX-LIB}
var
  Temp: TWin32FindData;
  SearchHandle: THandle;
begin
  SearchHandle := FindFirstFile(PChar(ShortName), Temp);
  if SearchHandle <> INVALID_HANDLE_VALUE then begin
    Result := string(Temp.cFileName);
    if Result = '' then Result := string(Temp.cAlternateFileName);
  end
  else Result := '';
  Windows.FindClose(SearchHandle);
end;

function ShortToLongPath(const ShortName: string): string; {FROM RX-LIB}
var
  LastSlash: PChar;
  TempPathPtr: PChar;
begin
  Result := '';
  TempPathPtr := PChar(ShortName);
  LastSlash := StrRScan(TempPathPtr, '\');
  while LastSlash <> nil do begin
    Result := '\' + ShortToLongFileName(TempPathPtr) + Result;
    if LastSlash <> nil then begin
      LastSlash^ := char(0);
      LastSlash := StrRScan(TempPathPtr, '\');
    end;
  end;
  Result := TempPathPtr + Result;
end;

procedure Register;
begin
  RegisterComponents('Haka', [TFileMenuHandler]);
end;

constructor TFileMenuHandler.create(AOwner: TComponent);
begin
  FEnabled := not (csDesigning in ComponentState);
  FLoadStart := true;
  FAddShortCut := True;
  FEnableMenuList := true;
  MoveToTop := true;
  NewItemImageIndex := -1;
  FParamcount := 1;
  FDirectSave:=false;
  FSaveAsCancel:=false;
  FMaxList := 4;
  FNotFoundStr := 'File %s not found.';
  FileChangedString := 'File %s has changed. Save Changes?';
  FileChangedCaption := 'Save changes';
  RecentList:=TStringList.Create;
  inherited create(AOwner);
  if componentstate = []
   then with AOwner as TForm do begin
      POnCloseQuery := OnCloseQuery;
      POnShow := OnShow;
      OnCloseQuery := FMHCloseQuery;
      OnShow := FMHShow;
    end;
end;

destructor TFileMenuHandler.destroy;
var
  c: integer;
begin
  if assigned(Finifile) then
  try
    Finifile.EraseSection('RecentFiles');
    for c := 0 to RecentList.count - 1 do
      FIniFile.WriteString('RecentFiles', 'File' + inttostr(c),
        RecentList[c]);
    Finifile.free;
  Except
   on exception do Finifile.free;
  end;
  if assigned(RecentList) then RecentList.Free;
  inherited Destroy;
end;

procedure TFileMenuHandler.UpdateList;
var
  c: integer; sc: char;
  mi: tmenuitem;
begin
  if not assigned(FFileMenu) then system.exit;
  for c := RecentList.count - 1 downto FMaxList do
    RecentList.Delete(c);
  if FEnableMenuList then
  begin
    if not assigned(FSeparator) then begin
      FSeparator := TMenuitem.create(FFileMenu);
      FSeparator.caption := '-';
      FSeparator.Visible := false;
      FFilemenu.Add(FSeparator);
    end;
    FSeparator.Visible := RecentList.count > 0;
    for c := FFIleMenu.Count - 1 downto FFileMenu.IndexOf(FSeparator)
      + 1 do
      TMenuItem(FFileMenu.Items[c]).free;
    for c := 0 to RecentList.count - 1 do
    begin
      mi := tmenuitem.Create(FFileMenu);
      if c <= 8 then sc := '1' else sc := chr(ord('A') - 9);
      if FAddShortCut then mi.Caption := '&' + chr(c + ord(sc)) +
        ' ' + RecentList.Strings[c]
      else mi.caption := RecentList.Strings[c];
      mi.OnClick := FileItemClick;
      if FAddShortcut then
        mi.shortcut := shortcut(ord(chr(c + ord(sc))), [ssalt]);
      mi.ImageIndex := FNewItemImageIndex;
      FFilemenu.Add(mi);
    end;
  end;
end;

procedure TFileMenuHandler.Exit(var CanClose: boolean);
begin
  Canclose := (SaveQuery=true) and (not FSaveAsCancel);
  FSaveAsCancel:=false;
end;

procedure TFileMenuHandler.LoadRecentList;
var
  c: integer;
begin
  if (length(FIniFileName) > 0) then
  begin
   if not assigned(FIniFile) then
     FIniFile := TIniFile.Create(inipath + Finifilename);
   try
     RecentList.Clear;
     FIniFile.ReadSection('RecentFiles', RecentList);
     for c := 0 to RecentList.count - 1 do
       RecentList[c] := FIniFile.ReadString('RecentFiles', 'File' + inttostr(c), '');
     for c := RecentList.count - 1 downto 0 do
       if not FileExists(RecentList[c]) then RecentList.Delete(c);
     UpdateList;
   except
     on exception do
       if assigned(FIniFile) then
         begin FIniFile.Free; FiniFile := nil; end;
   end;
  end
  else

  begin
   for c := RecentList.count - 1 downto 0 do
    if not FileExists(RecentList[c]) then RecentList.Delete(c);
   UpdateList;
  end;
end;

procedure TFileMenuHandler.FileItemClick(Sender: Tobject);
var
  mi: TMenuItem; c: integer;
begin
  mi := Sender as TMenuItem;
  c := FFileMenu.IndexOf(mi) - FFileMenu.IndexOf(FSeparator) - 1;
  if SaveQuery then
    if fileexists(recentlist[c]) then
    begin
      if assigned(FOnOpen) then
        if FOnOpen(RecentList[c]) then
        begin
          FFilename := RecentList[c];
          IsDirty := false;
          if FMoveTotop then RecentList.Move(c, 0);
          UpdateList;
          FIsNew := false;
          if assigned(FOnSetCaption) then FOnSetCaption(FFilename);
        end;
    end else
    begin
      notfounddialog(Recentlist[c]);
      Recentlist.Delete(c);
      updatelist;
    end;
end;

procedure TFileMenuHandler.New;
begin
  if savequery then
    if assigned(OnNew) then
      if OnNew(filename) then
      begin
        FFilename := FDefaultFilename;
        FIsNew := true; IsDirty := false;
        if assigned(FOnSetCaption) then FOnSetCaption(FFilename);
      end;
end;

procedure TFileMenuHandler.Open;
begin
  if savequery then
   if not FSaveAsCancel then
   begin
    if FOpenDialog.Execute then
      if FileExists(FOpenDialog.filename) then
      begin
        if assigned(FOnOpen) then
          if FOnOpen(FOpenDialog.Filename) then
          begin
            FFilename := FOpenDialog.FileName;
            IsDirty := false;
            InsertFilename;
            UpdateList;
            FIsNew := false;
            if assigned(FOnSetCaption) then FOnSetCaption(FFilename);
          end;
      end else NotFoundDialog(FOpenDialog.FileName);
   end else FSaveAsCancel:=false;
end;

procedure TFileMenuHandler.OpenFile(const f:string);
begin
  if savequery then
   if not FSaveAsCancel then
   begin
      if FileExists(f) then
      begin
        if assigned(FOnOpen) then
          if FOnOpen(F) then
          begin
            FFilename := F;
            IsDirty := false;
            InsertFilename;
            UpdateList;
            FIsNew := false;
            if assigned(FOnSetCaption) then FOnSetCaption(FFilename);
          end;
      end else NotFoundDialog(F);
   end else FSaveAsCancel:=false;
end;


procedure TFileMenuHandler.Save;
begin
  if FIsNew then begin saveasproc; system.exit; end;
  if Assigned(onSave) then
    if OnSave(FFilename) then
    begin
      IsDirty := false;
      FIsNew := false;
    end;
end;

procedure TFileMenuHandler.SaveAsProc;
begin
  if Assigned(onSave) then
  begin
    FSaveDialog.Filename := FFileName;
    if FSaveDialog.Execute then
    begin
      if OnSave(FSaveDialog.FileName) then
      begin
        IsDirty := false;
        FFilename := FSaveDialog.Filename;
        FIsNew := false;
        if assigned(FOnSetCaption) then FOnSetCaption(FFilename);
        InsertFilename;
        UpdateList;
      end;
    end else if not FDirectSave then FSaveAsCancel:=true;
  end;
end;


procedure TFileMenuHandler.SaveAs;
begin
 FDirectSave:=true;
 SaveAsProc;
 FDirectSave:=false;
end;

function TFileMenuHandler.SaveQuery: Boolean;
begin
  result := true;
  if (IsDirty) then
    case application.messagebox(
      pchar(Format(FFileChangedStr, [FFilename])),
      pchar(FFileChangedCaption),
      MB_YESNOCANCEL + MB_ICONWARNING) of
      mrCancel: begin result := false; system.exit; end;
      mrYes: save;
    end;
end;

procedure TFileMenuHandler.InsertFilename;
var
  i: integer;
begin
  i := RecentList.IndexOf(FFilename);
  if i = -1 then RecentList.Insert(0, FFilename) else
    RecentList.Move(i, 0);
end;

procedure TFileMenuHandler.SetMaxItems(m: integer);
begin
  if (m > 9 + 26) then m := 9 + 26;
  FMaxList := m;
  if FEnabled then updatelist;
end;

procedure TFileMenuHandler.SetEnableMenuList(e: boolean);
var
  c: integer;
begin
  FEnableMenulist := e;
  if FEnabled then
  begin
    updatelist;
    if (not FEnableMenulist) and (assigned(FSeparator)) then
    begin
      for c := FFIleMenu.Count - 1 downto
        FFileMenu.IndexOf(FSeparator) do
        TMenuItem(FFileMenu.Items[c]).free;
      FSeparator := nil;
    end;
  end;
end;

procedure TFileMenuHandler.FMHCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  Exit(CanClose);
  if assigned(POnCloseQuery) then POnCloseQuery(Sender, CanClose);
end;

procedure TFileMenuHandler.FMHShow(Sender: TObject);
begin
  if assigned(POnShow) then POnShow(Sender);
  Loadrecentlist;
  if FParamcount <> 0 then
    if fileexists(Paramstr(FParamcount)) then
      if FOnOpen(Paramstr(FParamcount)) then
      begin
        FFilename := ShortToLongPath(Paramstr(FParamcount));
        IsDirty := false;
        InsertFilename;
        UpdateList;
        FIsNew := false;
        if assigned(FOnSetCaption) then FOnSetCaption(FFilename);
        system.exit;
      end;
  if FLoadStart then new;
end;

procedure TFileMenuHandler.NotFoundDialog(const f: string);
begin
  application.MessageBox(pchar(Format(FNotFoundStr, [F])), nil, MB_OK
    + MB_ICONERROR);
end;


end.

