unit HKDXBar;

interface
 uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,dialogs,
  Hakafile, StdCtrls, dxBar,ShellApi;

 type
  TDxScanFolder = Class
  private
   Menu : TdxBarSubItem;
   Parent : TComponent;
   Folder : String;
   FMsg : Integer;
   FItemClick : TNotifyEvent;
   procedure SubItemClick(Sender: TObject);
   procedure SubItemCloseUp(Sender: TObject);
   Function SetMaxSize(Const s:String) : string;
  public
   ShowExtension : Boolean;
   MaxSize : Integer;
   procedure DoReleaseSubMenu(Submenu: Integer);
   Constructor Create(Const AFolder : String; AMenu : TdxBarSubItem; OnItemClick : TNotifyEvent; Msg : Integer);
   Destructor Destroy; Override;
  end;

implementation

Procedure SetGlyphWithExeIcon(Const Filename : String; Glyph: TBitmap);
var
 Attrs : Cardinal;
 SFI: TSHFileInfo;
 Icon : TIcon;
begin
  icon:=TIcon.Create;
  Attrs:=0;
  try
   SHGetFileInfo(PChar(ExcludeTrailingBackSlash(Filename)), Attrs, SFI, SizeOf(TSHFileInfo),
                 SHGFI_ICON or SHGFI_SMALLICON);
   Icon.Transparent:=false;
   Icon.Handle:=sfi.hIcon;

   if sfi.hIcon>0 then
   begin
    Glyph.Width:=16;
    Glyph.height:=16;
    glyph.Canvas.Draw(0,0,icon);
   end;
  finally
   icon.free;
  end;
end;

constructor TDxScanFolder.Create(const AFolder: String; AMenu: TdxBarSubItem; OnItemClick : TNotifyEvent; Msg : Integer);
begin
 FMSG:=MSG;
 Folder:=IncludeTrailingBackSlash(AFolder);
 FItemClick:=OnItemClick;
 Menu:=AMenu;
 Menu.OnClick:=SubItemClick;
 Menu.OnCloseUp:=SubItemCloseUp;
 menu.Hint:=Folder;
 Parent:=Menu.BarManager.MainForm;
 ShowExtension:=false;
 MaxSize:=50;
end;

destructor TDxScanFolder.Destroy;
begin
 inherited Destroy;
end;

Function TDxScanFolder.SetMaxSize(Const s:String) : string;
begin
 if length(s)>maxsize
  then result:=copy(s,1,maxsize-3)+'...'
  else result:=s;
end;

procedure TDxScanFolder.SubItemCloseUp(Sender: TObject);
begin
 PostMessage(Application.MainForm.Handle,FMSG,integer(sender),0);
end;

procedure TDxScanFolder.DoReleaseSubMenu(Submenu : Integer);
var
 i:integer;
 This : TdxBarSubItem absolute SubMenu;
begin
 for i:=this.ItemLinks.Count-1 downto 0 do
  This.ItemLinks.Items[i].Item.Free;
 this.ItemLinks.Clear;
end;

procedure TDxScanFolder.SubItemClick(Sender: TObject);
var
 sl:TStringList;
 This,SubMenu : TdxBarSubItem;
 Item : TdxBarButton;
 i,added:integer;
begin
 if menu.BarManager.IsCustomizing then exit;
 This:=TdxBarSubItem(sender);
 sl:=TStringList.Create;
 sl.Sorted:=true;
 try
  GetFileList(this.Hint,'*.*',false,faAnyFile,sl);

  i:=0;
  added:=0;

  while i<sl.Count do
  begin
   if ((integer(sl.Objects[i]) and faDirectory)<>0) then
   begin
    if (sl[i][1]<>'.') then
    begin
     SubMenu:=TdxBarSubItem.Create(Parent);
     submenu.OnClick:=subitemclick;
     SubMenu.OnCloseUp:=SubItemCloseUp;
     SubMenu.Caption:=SetMaxSize(sl[i]);
     submenu.Hint:=IncludeTrailingBackSlash(this.Hint+sl[i]);
     SetGlyphWithExeIcon(submenu.Hint,submenu.Glyph);
     this.ItemLinks.Add.Item:=submenu;
     inc(added);
    end;
    sl.Delete(i);
   end
    else
    inc(i);
  end;

  for i:=0 to sl.Count-1 do
   if (integer(sl.Objects[i]) and faArchive)<>0 then
   begin
    Item:=TDxBarButton.Create(parent);
    if ShowExtension
     then item.Caption:=SetMaxSize(sl[i])
     else item.Caption:=SetMaxSize(ExtractFileNoExt(sl[i]));
    Item.Hint:=this.Hint+sl[i];
    SetGlyphWithExeIcon(item.Hint,item.Glyph);
    this.ItemLinks.Add.item:=item;
    item.OnClick:=FItemClick;
    inc(added);
   end;

   if added=0 then
   begin
    Item:=TdxBarButton.Create(parent);
    item.Caption:='(none)';
    Item.Enabled:=false;
    this.ItemLinks.Add.item:=item;
   end;

 finally
  sl.Free;
 end;
end;


end.
