unit SelectFolderFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, bsutils,
  Dialogs, bsSkinShellCtrls, StdCtrls, Mask, bsSkinBoxCtrls, bsSkinCtrls, HakaWin,
  JvAppStorage;


type
  TSpecialFolderItem = record
    DisplayName: string;
    Path: string;
    IconIndex: Integer;
  end;

  TSelectFolderFrame = class(TFrame)
    cbFolders: TbsSkinComboBox;
    btnBrowse: TbsSkinButton;
    edFilename: TbsSkinEdit;
    SkinSelectDirectoryDialog: TbsSkinSelectDirectoryDialog;
    lblSelFile: TbsSkinStdLabel;
    lblSelFolder: TbsSkinStdLabel;
    procedure btnBrowseClick(Sender: TObject);
    procedure cbFoldersListBoxDrawItem(Cnvs: TCanvas; Index, ItemWidth,
      ItemHeight: Integer; TxtRect: TRect; State: TOwnerDrawState);
  private
    function GetRealPath(index: Integer): string;
    function GetFilename: string;
    function DisplayNameFromRealPath(const Path: string): String;
  public
    SpecialFolders: array of TSpecialFolderItem;
    procedure LoadFromStorage(Storage: TJvCustomAppStorage);
    procedure SaveToStorage(Storage: TJvCustomAppStorage);
    procedure AddFolderToList(const Path: String);
    procedure AddSpecialFolderToList(const ADisplayName, ARegName: string; CurrentUser: Boolean; Index: Integer);
    property Filename: string read GetFilename;
  end;


implementation

{$R *.dfm}

function TSelectFolderFrame.DisplayNameFromRealPath(const Path: string): String; {}
var
  i: integer;
begin
  for i := 0 to length(specialFolders) - 1 do
   if AnsiCompareFileName(SpecialFolders[i].Path, path) = 0 then
   begin
     result := SpecialFolders[i].DisplayName;
     exit;
   end;
  result := Path;
end;

procedure TSelectFolderFrame.btnBrowseClick(Sender: TObject); {}
begin
  SkinSelectDirectoryDialog.directory := GetRealPath(cbFolders.ItemIndex);

  if SkinSelectDirectoryDialog.Execute and
   directoryExists(SkinSelectDirectoryDialog.Directory) then
    AddFolderToList(SkinSelectDirectoryDialog.Directory);
end;

procedure TSelectFolderFrame.AddFolderToList(const Path : String);
var
 s: string;
 i:integer;
begin
 s := IncludeTrailingPathDelimiter(SkinSelectDirectoryDialog.Directory);
 i := cbFolders.Items.IndexOf(s);
 if I < 0 then
 begin
  cbFolders.Items.insert(0, s);
  i:=0;
 end;
 cbFolders.ItemIndex := i;
end;

procedure TSelectFolderFrame.AddSpecialFolderToList(const ADisplayName, ARegName:string;
  CurrentUser: Boolean; Index: Integer);
var
  f: string;
begin
  f := GetSpecialFolder(ARegName, CurrentUser);
  if not directoryExists(f) then
    f := GetSpecialFolder('Personal', true);

  f:=IncludeTrailingPathDelimiter(f);
  if cbFolders.items.indexof(f)>=0 then exit;

  SetLength(SpecialFolders, length(SpecialFolders) + 1);
  with SpecialFolders[length(SpecialFolders) - 1] do
  begin
    DisplayName := ADisplayName;
    IconIndex := index;
    Path := f;
  end;
  cbFolders.Items.AddObject(f, TObject(index));
end;

function TSelectFolderFrame.GetRealPath(index: Integer): string;
var
  i: Integer;
begin
 if (index < 0) or (index>=cbFolders.Items.Count) then
 begin
   getdir(0, result);
   result:=IncludeTrailingPathDelimiter(result);
   exit;
 end;

 result := cbFolders.Items[index];
end;

procedure TSelectFolderFrame.cbFoldersListBoxDrawItem(Cnvs: TCanvas; Index,
  ItemWidth, ItemHeight: Integer; TxtRect: TRect; State: TOwnerDrawState);
var
  IIndex, IX, IY: Integer;
begin
  with cbFolders do
  begin
    IIndex := Integer(items.Objects[index]);
    IX := TxtRect.Left;
    IY := TxtRect.Top + (TxtRect.Bottom - TxtRect.top) div 2 - Images.Height div 2;
    Images.Draw(Cnvs, IX, IY, IIndex);
    Inc(TxtRect.Left, Images.Width + 2);
    BSDrawText2(Cnvs, DisplayNameFromRealPath(Items[Index]), TxtRect);
  end;
end;

procedure TSelectFolderFrame.LoadFromStorage(Storage: TJvCustomAppStorage);
var
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  Storage.ReadStringList(Name, sl);

  for i := sl.Count - 1 downto 0 do
    if not directoryExists(sl[i]) then
      sl.Delete(i);
  for i := 0 to sl.Count - 1 do
   if cbFolders.Items.IndexOf(sl[i])<0 then
    cbFolders.Items.Insert(i, sl[i]);

  i := Storage.ReadInteger(Name + '\Selected', -1);

  if (i>=0) and (i < cbFolders.Items.Count)
   then cbFolders.ItemIndex := i
   else cbFolders.ItemIndex := sl.count;

  sl.free;
end;

procedure TSelectFolderFrame.SaveToStorage(Storage: TJvCustomAppStorage);
var
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  for i := 0 to min(cbFolders.Items.Count - 1, 14) do
    if cbFolders.Items.Objects[i] = nil then
      sl.Add(cbFolders.Items[i]);
  Storage.WriteStringList(Name, sl);
  Storage.WriteInteger(Name + '\Selected', cbFolders.ItemIndex);
  sl.free;
end;

function TSelectFolderFrame.GetFilename: string;
begin
  result := GetRealPath(cbFolders.ItemIndex) + edFilename.Text;
end;

end.

