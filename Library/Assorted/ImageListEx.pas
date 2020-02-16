(******************************************************************************

  TImageListEx: Combined system image list and user image list.

  Usage. Add icons as usual during design time. If system icons are needed
  in run time use provided public methods to get their index. Do not add
  additional images manually in run time after the first system image has
  been requested.

  The component is currently only capable of small images (16x16) although this
  is never checked. Large images can easily be implemented by an additional
  property.

 ******************************************************************************)

Unit ImageListEx;

Interface

Uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ImgList;

Type
  TImageListEx = Class(TImageList)
  Protected
    BaseCount: integer;
    SystemImages: TImageList;
    IndexTranslation: TList;
    Procedure Loaded; Override;
    Procedure InitSystemImages;
    Function GetTranslatedIndex(SystemIndex: integer): integer;
    Function AppendSystemImage(SystemIndex: integer): integer;
  Public
    Destructor Destroy; Override;
    // Get*Index methods: use these methods to find system image index which
    // are only valid for this imagelist.
    Function GetOpenFolderIndex: integer;
    Function GetClosedFolderIndex: integer;
    Function GetSystemIconIndex(Filename: String): integer; Overload;
    Function GetSystemIconIndex(Filename: String; Flags: Cardinal): integer; Overload;
    Function GetVirtualFileSystemIconIndex(Filename: String): integer; // Virtual = Filename does not need to exist.
  End;

Procedure Register;

Implementation

Uses
  ShellAPI;

Procedure Register;
Begin
  RegisterComponents('Extra', [TImageListEx]);
End;

// Transforms the given ImageList into the system imagelist.

Procedure TurnIntoSystemImageList(ImageList: TImageList; SmallImages: boolean = true);
Const
  IconSizes: Array[boolean] Of UINT = (SHGFI_LARGEICON, SHGFI_SMALLICON);
Var
  SFI: TSHFileInfo;
Begin
  ImageList.Handle := SHGetFileInfo('', 0, SFI, SizeOf(SFI), SHGFI_SYSICONINDEX Or IconSizes[SmallImages]);
  ImageList.ShareImages := true;
End;

// Returns the index of the system icon for the given file object with custom flags.

Function GetIconIndex(Name: String; Flags: Cardinal): integer; Overload;
Var
  SFI: TSHFileInfo;
Begin
  If SHGetFileInfo(PChar(Name), 0, SFI, SizeOf(TSHFileInfo), Flags) = 0 Then result := -1
  Else result := SFI.iIcon;
End;

// Returns the index of the system icon for the given file object.

Function GetIconIndex(Name: String; Small: boolean = true): integer; Overload;
Const
  IconSizes: Array[boolean] Of UINT = (SHGFI_LARGEICON, SHGFI_SMALLICON);
Begin
  result := GetIconIndex(Name, SHGFI_SYSICONINDEX Or IconSizes[Small]);
End;

// Returns the system icon index for Name. File object Name does not need to exist.

Function GetVirtualFileIconIndex(Name: String): Integer;
Var
  SFI: TSHFileInfo;
Begin
  If SHGetFileInfo(PChar(Name), FILE_ATTRIBUTE_NORMAL, SFI, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX Or SHGFI_SMALLICON Or SHGFI_USEFILEATTRIBUTES) = 0 Then result := -1
  Else result := SFI.iIcon;
End;

{ TImageListEx }

Destructor TImageListEx.Destroy;
Begin
  FreeAndNil(IndexTranslation);
  Inherited;
End;

Procedure TImageListEx.Loaded;
Begin
  Inherited;
  BaseCount := Count;
End;

Function TImageListEx.AppendSystemImage(SystemIndex: integer): integer;
Var
  Icon: TIcon;
Begin
  Icon := TIcon.Create;
  Try
    SystemImages.GetIcon(SystemIndex, Icon);
    result := AddIcon(Icon);
  Finally
    Icon.Free;
  End;
End;

Function TImageListEx.GetTranslatedIndex(SystemIndex: integer): integer;
Begin
  result := -1;
  If (SystemIndex < 0) Then exit;

  InitSystemImages;

  // Find SystemIndex in current list and return local list index if found.
  result := IndexTranslation.IndexOf(pointer(SystemIndex));
  If (result >= 0) Then Begin
    inc(result, BaseCount);
    exit;
  End;

  // Not found: append image to local list and return local index.
  result := AppendSystemImage(SystemIndex);
  If (result >= 0) Then IndexTranslation.Add(pointer(SystemIndex));
End;

Procedure TImageListEx.InitSystemImages;
Begin
  If (SystemImages <> Nil) Then exit;

  SystemImages := TImageList.Create(self);
  With SystemImages Do Begin
    Width := self.Width;
    Height := self.Height;
  End;
  TurnIntoSystemImageList(SystemImages, Width = 16);

  IndexTranslation := TList.Create;
End;

Function TImageListEx.GetClosedFolderIndex: integer;
Const
  Index: integer = -1;
Var
  SFI: TSHFileInfo;
Begin
  result := GetTranslatedIndex(Index);
  If (result >= 0) Then exit;

  SHGetFileInfo('tutu', FILE_ATTRIBUTE_DIRECTORY, SFI, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX Or SHGFI_SMALLICON Or SHGFI_USEFILEATTRIBUTES);
  index := SFI.iIcon;
  result := GetTranslatedIndex(index);
End;

Function TImageListEx.GetOpenFolderIndex: integer;
Const
  Index: integer = -1;
Var
  SFI: TSHFileInfo;
Begin
  result := GetTranslatedIndex(Index);
  If (result >= 0) Then exit;

  SHGetFileInfo('tutu', FILE_ATTRIBUTE_DIRECTORY, SFI, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX Or SHGFI_SMALLICON Or SHGFI_USEFILEATTRIBUTES Or SHGFI_OPENICON);
  index := SFI.iIcon;
  result := GetTranslatedIndex(index);
End;

Function TImageListEx.GetSystemIconIndex(Filename: String; Flags: Cardinal): integer;
Begin
  result := GetTranslatedIndex(GetIconIndex(Filename, Flags));
End;

Function TImageListEx.GetSystemIconIndex(Filename: String): integer;
Begin
  result := GetTranslatedIndex(GetIconIndex(Filename));
End;

Function TImageListEx.GetVirtualFileSystemIconIndex(Filename: String): integer;
Begin
  result := GetTranslatedIndex(GetVirtualFileIconIndex(Filename));
End;

End.

