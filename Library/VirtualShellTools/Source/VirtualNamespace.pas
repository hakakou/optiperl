unit VirtualNamespace;

// Version 1.5.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------

interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ImgList, ShlObj,
  ShellAPI, ActiveX, VirtualPIDLTools, VirtualUtilities, VirtualDataObject,
  VirtualShellTypes, VirtualWideStrings, VirtualShellContainers,
  {$IFDEF COMPILER_5_UP}
  Contnrs,
  {$ENDIF}
  VirtualShellNotifier;

type
  TFolderAttribute = (
     faCanCopy,     // The object can be copied to a different location
     faDelete,      // The object can be deleted
     faCanLink,     // The object can create a link (shortcut) to itself
     faCanMoniker,  // The object can have a moniker
     faCanMove,     // The object can be moved to a new location
     faCanRename,   // The object name can be changed
     faDropTarget,  // The object can be a drop target
     faHasPropSheet, // The object has a Property Sheet (Get IPropertySheet through IShellFolder: GetUIObjectOf);
     faGhosted,     // The object UI should be ghosted (i.e. hidden file)
     faLink,        // The object is a link (shortcut)
     faReadOnly,    // The object is read only (like a read only CD)
     faShare,       // The object is a shared resource
     faHasSubFolder,  // The object has subfolder, it MAY be expandable
     faBrowsable,   // The object is browsable in place (like Zip files in WinXP)
     faCompressed,  // The object is compressed (like compressed files on NTFS)
     faFileSystem,  // The object represents a physical file on disk
     faFileSysAncestor,  // The object contains physical file objects (this was buggy up to Win2k was only true for root drives)
     faFolder,      // The object is a folder
     faNewContent,  // The object contains new content, as defined by the namespace
     faNonEnumerated,  // The object is a non enumerated object
     faRemovable,   // The object is removeable (like a floppy disk or ZIP drive)
     faValidate     // If set flush any cached information in the PIDL and load data from the source
  );
  TFolderAttributes = set of TFolderAttribute;

  TFolderEnumFlag = (
    fefFolders,       // Enumerate Folders
    fefNonFolder,     // Enumerate NonFolders (file)
    fefHidden         // Enumerate Hidden
  );
  TFolderEnumFlags = set of TFolderEnumFlag;

  TSetNameFlag = (
    snfFolders,       // Enumerate Folders
    snfNonFolder,     // Enumerate NonFolders (file)
    snfHidden         // Enumerate Hidden
  );
  TSetNameFlags = set of TSetNameFlag;

  TDisplayNameFlag = (
    dnfNormal,               // Normal name relative to Desktop
    dnfInFolder,             // Normal name relative to parent folder
    dnfIncludeNonFileSys,    // If not included non file sys calls will fail
    dnfForAddressBar,        // For address bar (in explorer) (new for Win2k allows a ForParsing that special namespaces return a name instead of a GUID string)
    dnfForParsing            // Parsing Path name  (In Win2k + this returns the GUID of the specialnamespace)
  );
  TDisplayNameFlags = set of TDisplayNameFlag;

  TVirtualIconFlag = (
    ifShell,                // Large icons
    ifOpen                  // selected "open" icon
  );
  TVirtualIconFlags = set of TVirtualIconFlag;

  TVirtualDropEffect = (
    vdeNone,                   // No Drop effect, the "NO" cursor
    vdeCopy,                   // Copy drop on target
    vdeMove,                   // Move drop on target
    vdeLink                    // Link drop on target
  );
  TVirtualDropEffects = set of TVirtualDropEffect;

  TVirtualDropKeyState = (
    vdksControl,        // Control key down
    vdksShift,          // Shift key down
    vdksAlt,            // Alt key down
    vdksButton,         // Any Mouse Button is down
    vdksLeftButton,     // Left button is down
    vdksMiddleButton,   // Middle button is down
    vdksRightButton    // Right button is down
  );
  TVirtualDropKeyStates = set of TVirtualDropKeyState;

  TSupportedInterface = (
    siIDropTarget,      // Set drop target in the Attributes method
    siIContextMenu,     // namespace supports a context menu
    siIContextMenu2,    // namespace supports a context menu with owner draw extensions
    siIContextMenu3,    // namespace supports a context menu with short cut handlers
    siIDataObject,      // namespace can create an IDataObject of its contents
    siIExtractIconA,    // namespace can extract a custom icon for itself ASCII version
    siIExtractIconW,    // namespace can extract a custom icon for itself Uniode version
    siIQueryInfo,        // namespace supports the "popup" hint windows
    siIShellDetails     // Column Details
  );
  TSupportedInterfaces = set of TSupportedInterface;

  TDataObjectType = (
    dotDragDrop,        // The data Object is for dragging the object
    dotClipboard        // The data Object is for placing on the clipboard
  );

  TVirtualColumnAlignment = (
    vcaCenter,          // Details view ColumnAlignment is center aligned
    vcaLeft,            // Details view ColumnAlignment is left aligned
    vcaRight            // Details view ColumnAlignment is right aligned
  );

  TContextMenuFlag = (
    cmDefaultOnly,    // Only the the default item to the menu, normally indicated by a bold font in the menu
    cmExplore,        // Sent if Explorer is requesting the Menu, normally ignored
    cmNormal,         // Add any menu items the handler normally adds
    cmVerbsOnly,      // Normally used for ShortCuts
    cmCanRename,      // Add a "Rename" item to the list if the object supports being renamed
    cmExtendedVerbs,  // Add the "extra" items when the SHIFT key is down when showing the context menu
    cmIncludeStatic,  // Only browsers should use this in Explorer VNSE can use it for anything
    cmNoDefault,      // Opposite of DefaultOnly, don't add the Default item to the menu
    cmNoVerbs        // This flag used for displaying Send To menu only
  );
  TContextMenuFlags = set of TContextMenuFlag;

  TCommandStringType = (
    csHelpTextA,     // Ansi string with a help on the command
    csHelpTextW,     // Unicode String with a help on the command
    csValidate,      // Return S_OK if the item id is a valid id
    csVerbA,         // Ansi verb associated with the command id
    csVerbW          // Unicode Verb associated with the command id
  );
type
  TVirtualInterfacedPersistent = class(TPersistent, IUnknown)
  protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;
    property RefCount: Integer read FRefCount;
  end;

type
  TBaseVirtualNamespaceExtension = class;  // Forward


  TItemID = class
  private
    FVersion: LongWord;         // User definable Version of the ItemID that is written to the PIDL
    FClassID: TGUID;            // Class ID that will be written to the PIDL
    FInFolderNameASCII: string; // The ASCII InfolderName that is normally stored in the PIDL, used by TStrRet return of GetDisplayNameOf
    function GetItemID: PItemIDList;
    procedure SetItemID(const Value: PItemIDList); // Retrieve the PIDL that is generated from the properties

  protected
    procedure LoadPIDLStream(S: TStream); virtual;
    procedure SavePIDLStream(S: TStream); virtual;

  public
    constructor Create(AClassID: TGUID); virtual;
    destructor Destroy; override;

    procedure Clear; virtual;
    procedure WriteString(Str: string; S: TStream);
    procedure WriteWideString(Str: WideString; S: TStream);
    function ReadString(S: TStream): string;
    function ReadWideString(S: TStream): WideString;

    property ClassID: TGUID read FClassID write FClassID;
    property InFolderNameASCII: string read FInFolderNameASCII write FInFolderNameASCII;
    property ItemID: PItemIDList read GetItemID write SetItemID;
    property Version: LongWord read FVersion write FVersion;
  end;

  // Implmenentation of the enumerator that will call TBaseVirtualNamespaceExtension
  // when VET wants to EnumObjects the object. This is how the child nodes get created
  // It is very basic and only implements what is necessary, no more
  TVirtualNamespaceEnum = class(TInterfacedObject, IEnumIDList)
  private
    FOwner: TBaseVirtualNamespaceExtension;
    FIndex: integer;
    FFlags: TFolderEnumFlags;
  protected
    function Next(celt: ULONG; out rgelt: PItemIDList; var pceltFetched: ULONG): HResult; stdcall;
    function Skip(celt: ULONG): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumIDList): HResult; stdcall;

    property Flags: TFolderEnumFlags read FFlags write FFlags;
    property Index: integer read FIndex write FIndex;
    property Owner: TBaseVirtualNamespaceExtension read FOwner write FOwner;
  public
    constructor Create(AnOwner: TBaseVirtualNamespaceExtension; EnumFlags: TFolderEnumFlags);
    destructor Destroy; override;
  end;

  TVirtualUIObjects = class(TInterfacedObject)
  private
    FParentPIDL: PItemIDList;
    FChildPIDLs: TPIDLList;
  public
    constructor Create(AParentPIDL: PItemIDList; APIDLs: TPIDLList); virtual;
    destructor Destroy; override;

    property ParentPIDL: PItemIDList read FParentPIDL write FParentPIDL;
    property ChildPIDLs: TPIDLList read FChildPIDLs write FChildPIDLs;
  end;

// ******************************************************************************
// IShellDetails implementation
// ******************************************************************************
  // Override this class and return it in the TBaseVirtualNamespaceExtension.CreateIShellDetails
  // method to implement IShellDetails for columns in details view in your VNSE
  TVirtualIShellDetails = class(TInterfacedObject, {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF})
  protected
    function GetDetailsOf(PIDL: PItemIDList; iColumn: LongWord; var data: TShellDetails): HResult; stdcall;
    function ColumnClick(iColumn: LongWord): HResult; stdcall;
  public
    function GetColumnAlignment(ColumnIndex: integer): TVirtualColumnAlignment; virtual;
    function GetColumnCount: Cardinal; virtual;
    function GetColumnDetails(ChildPIDL: PItemIDList; ColumnIndex: integer): WideString; virtual;
    function GetColumnTitle(ColumnIndex: integer): WideString; virtual;
  end;
// ******************************************************************************
// END IShellDetails
// ******************************************************************************

// ******************************************************************************
// IContextMenu implementation
// ******************************************************************************
  TVirtualContextMenuItem = class
  private
    FCommandID: Longword;
    FHelp: WideString;
    FVerb: WideString;
  public
    property CommandID: Longword read FCommandID write FCommandID;
    property Verb: WideString read FVerb write FVerb;
    property Help: WideString read FHelp write FHelp;
  end;

  // Override this class and return it in the TBaseVirtualNamespaceExtension.CreateIContextMenu
  // method to implement IContextMenu for Context Menu Support in VNSE
  TVirtualIContextMenu = class(TVirtualUIObjects, IContextMenu, IContextMenu2, IContextMenu3)
  private
    FMenuItemList: TObjectList;
  protected
    // IContextMenu
    function QueryContextMenu(Menu: HMENU;
      indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfoEx): HResult; stdcall;
    function GetCommandString(idCmd, uType: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
    // IContextMenu2
    function HandleMenuMsg(uMsg: UINT; WParam, LParam: Integer): HResult; stdcall;
    // IContextMenu3
    function HandleMenuMsg2(uMsg: UINT; wParam, lParam: Integer;
      var lpResult: Integer): HResult; stdcall;

    function CMF_ToContextMenuFlags(Flags: Longword): TContextMenuFlags;
    function GSC_ToCommandStringType(Flag: Integer): TCommandStringType;

    property MenuItemList: TObjectList read FMenuItemList write FMenuItemList;
  public
    constructor Create(AParentPIDL: PItemIDList; APIDLs: TPIDLList); override;
    destructor Destroy; override;

    procedure AddMenuItem(Menu: HMenu; CommandID: Longword; Text, Verb, Help: WideString);
    procedure AddMenuItemDivider(Menu: HMenu);
    function FillMenu(Menu: HMenu; FirstItemIndex, ItemIdFirst, ItemIDLast: Longword; MenuFlags: TContextMenuFlags): Boolean; virtual;
    function FindMenuItemByCommandID(CommandID: Longword): TVirtualContextMenuItem;
    function FindMenuItemByVerb(Verb: WideString): TVirtualContextMenuItem;
    function FindMenuItemByInvokeInfo(InvokeInfo: TCMInvokeCommandInfoEx;
      var InvokedByVerb: Boolean): TVirtualContextMenuItem;
    function Invoke(Window: HWnd; InvokeInfo: TCMInvokeCommandInfoEx): Boolean; virtual;
    function CommandString(CommandID: Longword; CommandStringType: TCommandStringType; var Command: WideString): Boolean; virtual;
  end;
// ******************************************************************************
// END IContextMenu
// ******************************************************************************

// ******************************************************************************
// IDropTarget implementation
// ******************************************************************************

  // Override this class and return it in the TBaseVirtualNamespaceExtension.CreateIDropTarget
  // method to implement IDropTarget for DragDrop Support in VNSE
  TVirtualIDropTarget = class(TVirtualUIObjects, IDropTarget)
  private
    FDataObject: IDataObject;
  protected
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
      pt: TPoint; var dwEffect: Longint): HResult; stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
  public
    procedure Drag_Enter(const DataObject: IDataObject; KeyState: TVirtualDropKeyStates;
      Point: TPoint; var DropEffect: TVirtualDropEffects); virtual;
    procedure Drag_Leave; virtual;
    procedure Drag_Over(KeyState: TVirtualDropKeyStates; Point: TPoint;
      var DropEffect: TVirtualDropEffects); virtual;
    procedure Drag_Drop(const DataObject: IDataObject; KeyState: TVirtualDropKeyStates;
      Point: TPoint; var DropEffect: TVirtualDropEffects); virtual;

    property DataObject: IDataObject read FDataObject write FDataObject;
  end;
// ******************************************************************************
// END IDropTarget
// ******************************************************************************

// ******************************************************************************
// IQueryInfo implementation
// ******************************************************************************

  // Override this class and return it in the TBaseVirtualNamespaceExtension.CreateIQueryInfo
  // method to implement IQueryInfo for Query Info Tip Support in VNSE
  TVirtualIQueryInfo = class(TVirtualUIObjects, IQueryInfo)
  protected
    // IQueryInfo
    function GetInfoTip(dwFlags: DWORD; var ppwszTip: PWideChar): HResult; stdcall;
    function GetInfoFlags(out pdwFlags: DWORD): HResult; stdcall;
  public
    function GetQueryInfoTip: WideString; virtual;
  end;
// ******************************************************************************
// END IQueryInfo
// ******************************************************************************

// ******************************************************************************
// IExtractIconA implementation
// ******************************************************************************

  // Override this class and return it in the TBaseVirtualNamespaceExtension.CreateIExtractIconA
  // method to implement IExtractIconA for Extract Icon Support in VNSE
  TVirtualIExtractIconA = class(TVirtualUIObjects, IExtractIconA)
  protected
    function GetIconLocation(uFlags: UINT; szIconFile: PAnsiChar; cchMax: UINT;
      out piIndex: Integer; out pwFlags: UINT): HResult; stdcall;
    function Extract(pszFile: PAnsiChar; nIconIndex: UINT;
      out phiconLarge, phiconSmall: HICON; nIconSize: UINT): HResult; stdcall;
  public
  end;
// ******************************************************************************
// END IExtractIconA
// ******************************************************************************

// ******************************************************************************
// IExtractIconW implementation
// ******************************************************************************

  // Override this class and return it in the TBaseVirtualNamespaceExtension.CreateIExtractIconW
  // method to implement IExtractIconW for Extract Icon Support in VNSE
  TVirtualIExtractIconW = class(TVirtualUIObjects, IExtractIconW)
  protected
    function GetIconLocation(uFlags: UINT; szIconFile: PWideChar; cchMax: UINT;
      out piIndex: Integer; out pwFlags: UINT): HResult; stdcall;
    function Extract(pszFile: PWideChar; nIconIndex: UINT;
      out phiconLarge, phiconSmall: HICON; nIconSize: UINT): HResult; stdcall;
  public
  end;
// ******************************************************************************
// END IExtractIconW
// ******************************************************************************

  TBaseVirtualNamespaceExtension = class(TVirtualInterfacedPersistent, IPersistFolder,
    IShellFolder, IShellIcon)
  private
    FDataObject: IDataObject;
    FSupportedInterfaces: TSupportedInterfaces;
    FDropTargetPIDL: PItemIDList;
  private
    FAbsolutePIDL: PItemIDList;  // Where we are in the shell hierarchy
    FItemID: TItemID;            // Instance if the TItemID that will help manage a single level Custom PIDL

    function GetClassID(out classID: TCLSID): HResult; stdcall;
    function Initialize(pidl: PItemIDList): HResult; stdcall;
    function ParseDisplayName(hwndOwner: HWND;
      pbcReserved: Pointer; lpszDisplayName: POLESTR; out pchEaten: ULONG;
      out ppidl: PItemIDList; var dwAttributes: ULONG): HResult; stdcall;
    function EnumObjects(hwndOwner: HWND; grfFlags: DWORD;
      out EnumIDList: IEnumIDList): HResult; stdcall;
    function BindToObject(pidl: PItemIDList; pbcReserved: Pointer;
      const riid: TIID; out ppvOut{$IFNDEF COMPILER_5_UP}: Pointer{$ENDIF}): HResult; stdcall;
    function BindToStorage(pidl: PItemIDList; pbcReserved: Pointer;
      const riid: TIID; out ppvObj{$IFNDEF COMPILER_5_UP}: Pointer{$ENDIF}): HResult; stdcall;
    function CompareIDs(lParam: LPARAM;
      pidl1, pidl2: PItemIDList): HResult; stdcall;
    function CreateViewObject(hwndOwner: HWND; const riid: TIID;
      out ppvOut{$IFNDEF COMPILER_5_UP}: Pointer{$ENDIF}): HResult; stdcall;
    function GetAttributesOf(cidl: UINT; var apidl: PItemIDList;
      var rgfInOut: UINT): HResult; stdcall;
    function GetUIObjectOf(hwndOwner: HWND; cidl: UINT; var apidl: PItemIDList;
      const riid: TIID; prgfInOut: Pointer; out ppvOut{$IFNDEF COMPILER_5_UP}: Pointer{$ENDIF}): HResult; stdcall;
    function GetDisplayNameOf(pidl: PItemIDList; uFlags: DWORD;
      var lpName: TStrRet): HResult; stdcall;
    function SetNameOf(hwndOwner: HWND; pidl: PItemIDList; lpszName: POLEStr;
      uFlags: DWORD; var ppidlOut: PItemIDList): HResult; stdcall;
    // IShellIcon
    function GetIconOf(pidl: PItemIDList; flags: UINT; out IconIndex: Integer): HResult; stdcall;

    function GetInFolderNameASCII_Offset: integer;

    property SupportedInterfaces: TSupportedInterfaces read FSupportedInterfaces write FSupportedInterfaces;

  protected
    function Attributes(ChildPIDLList: TPIDLList; Attribs: TFolderAttributes): TFolderAttributes; virtual;
    function CompareItems(ColumnToCompare: integer; ChildPIDL1, ChildPIDL2: PItemIDList): ShortInt; virtual;
    function CreateIContextMenu(ChildPIDLs: TPIDLList): IContextMenu; virtual;
    function CreateIDataObject(ChildPIDLs: TPIDLList; ObjectRequestor: TDataObjectType): IDataObject; virtual;
    function CreateIDropTarget(ChildPIDLs: TPIDLList): IDropTarget; overload; virtual;
    function CreateIDropTarget: IDropTarget; overload; virtual;
    function CreateIExtractIconA(ChildPIDLs: TPIDLList): IExtractIconA; virtual;
    function CreateIExtractIconW(ChildPIDLs: TPIDLList): IExtractIconW; virtual;
    function CreateIShellDetails(ChildPIDL: PItemIDList): {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF}; virtual;
    function CreateIQueryInfo(ChildPIDLs: TPIDLList): IQueryInfo; virtual;
    function CreateItemID: TItemID; virtual; abstract;  // Must be overriden and a TItemID and decendant returned
    procedure DisplayName(ChildPIDL: PItemIDList; NameType: TDisplayNameFlags; var StrRet: TStrRet); virtual;
    function EnumFirstChild(EnumFlags: TFolderEnumFlags): PItemIDList; virtual;
    function EnumNextChild(EnumFlags: TFolderEnumFlags): PItemIDList; virtual;
    function GetSupportedInterfaces: TSupportedInterfaces; virtual;
    procedure IconIndex(ChildPIDL: PItemIDList; IconStyle: TVirtualIconFlags; var IconIndex: integer); virtual;
    function InitializeNamespace(var StoreParentPIDL: Boolean): Boolean; virtual;
    function RetrieveClassID: TCLSID; virtual; abstract;
    function SetName(ChildPIDL: PItemIDList; NewName: WideString; ObjectType: TSetNameFlags; var NewPIDL: PItemIDList): Boolean; virtual;

    property InFolderNameASCII_Offset: integer read GetInFolderNameASCII_Offset;
    property ItemID: TItemID read FItemID;
    property AbsolutePIDL: PItemIDList read FAbsolutePIDL;

  public
    constructor Create; virtual;
    destructor Destroy; override;

    property DataObject: IDataObject read FDataObject write FDataObject;
    property DropTargetPIDL: PItemIDList read FDropTargetPIDL;
  end;
  TBaseVirtualNamespaceExtensionClass = class of TBaseVirtualNamespaceExtension;

  // NamespaceFactory objects

  THookedPIDLItem = class
  private
    FPIDLIDCount: Integer;
    FPIDL: PItemIDList;
    FNamespaceExtClassID: TGUID;
    FHardHooked: Boolean;    // This mean that only Virtual Children will be shown
                             // The real namespace will show a user defined
                             // Details view (if defined)
  public
    constructor Create(APIDL: PItemIDList; ANamespaceExtClassID: TGUID; IsHardHooked: Boolean);
    destructor Destroy; override;

    property HardHooked: Boolean read FHardHooked write FHardHooked;
    property PIDL: PItemIDList read FPIDL write FPIDL;
    property PIDLIDCount: Integer read FPIDLIDCount write FPIDLIDCount;
    property NamespaceExtClassID: TGUID read FNamespaceExtClassID write FNamespaceExtClassID;
  end;

  // The class represents a registered namspace type.  It is characterized by a
  // unique GUID that is used to create a new instance of the NamespaceExtClass
  // when called upon.  The registered items are stored in the TNamespaceExtensionFactory
  // class and any manipulation should be done through its methods.
  TNamespaceFactoryItem = class
  private
    FNamespaceExtClass: TBaseVirtualNamespaceExtensionClass; // The class to create that is associated with the GUID
    FNamespaceExtClassID: TGUID;  // The GUID of the VirtualVamespace
    FRootHookClassID: TGUID;      // The GUID of the "virtual" parent of the Root Namespace
    FRootHookClass: TBaseVirtualNamespaceExtensionClass; // The class to create that is associated with the Hook GUID

    function GetRootHookFolder: IShellFolder;

  protected
    procedure SaveToStream(S: TStream);
    procedure LoadFromStream(S: TStream);
  public
    function CreateClass: TBaseVirtualNamespaceExtension;
    property NamespaceExtClass: TBaseVirtualNamespaceExtensionClass read FNamespaceExtClass write FNamespaceExtClass;
    property NamespaceExtClassID: TGUID read FNamespaceExtClassID write FNamespaceExtClassID;
    property RootHookClass: TBaseVirtualNamespaceExtensionClass read FRootHookClass write FRootHookClass;
    property RootHookClassID: TGUID read FRootHookClassID write FRootHookClassID;
    property RootHookFolder: IShellFolder read GetRootHookFolder;
  end;

  // Class Factory that stores registered Custom namespace types. Any Custom namespace
  // types must be registered with the factory.  The factory class is also responsible
  // for creating instances of the namespace objects through the CreateNamespaceExtension
  // method.
  TNamespaceExtensionFactory = class
  private
    FNSExtList: TList;        // List of registered VirtualNamespace Extenstions
    FDesktop: IShellFolder;
    FLock: TRTLCriticalSection;
    FHookedPIDLItems: TObjectList; // Any Real Namespace PIDLs that are hooked with this VirtualNamespace
    function GetNamespaceItems(Index: integer): TNamespaceFactoryItem;
  protected
    procedure ClearExtensions;

    property Desktop: IShellFolder read FDesktop write FDesktop;
    property HookedPIDLItems: TObjectList read FHookedPIDLItems write FHookedPIDLItems;
    property NSExtList: TList read FNSExtList write FNSExtList;
    property Lock: TRTLCriticalSection read FLock write FLock;
  public
    constructor Create;
    destructor Destroy; override;

    function BindToVirtualObject(AbsolutePIDL: PItemIDList): IShellFolder;
    function BindToVirtualParentObject(AbsolutePIDL: PItemIDList): IShellFolder;
    procedure ChangeNotify(NotifyType: Longword; PIDL1, PIDL2: PItemIDList);
    function CreateNamespaceExtension(NamespaceExtClassID: TGUID): IShellFolder;
    function ExtractVirtualGUID(PIDL: PItemIDList; var GUID: TGUID): Boolean; overload;
    function ExtractVirtualGUID(PIDL: PItemIDList): TGUID; overload;
    function FindNamespaceItem(NamespaceExtClassID: TGUID; var Index: integer): TNamespaceFactoryItem;
    procedure HookPIDL(PIDL: PItemIDList; NamespaceExtClassID: TGUID; HardHooked: Boolean);
    function IsHardHookedPIDL(AbsolutePIDL: PItemIDList): Boolean;
    function IsHookedPIDL(AbsolutePIDL: PItemIDList; var Index: Integer): Boolean; overload;
    function IsHookedPIDL(AbsolutePIDL: PItemIDList): Boolean; overload;
    function IsRootVirtualPIDL(AbsolutePIDL: PItemIDList): Boolean;
    function IsVirtualPIDL(PIDL: PItemIDList): Boolean;
    procedure LoadFromStream(S: TStream);
    procedure RegisterNamespaceExtension(NamespaceExtClass: TBaseVirtualNamespaceExtensionClass;
      NamespaceExtClassID: TGUID; RootHookClass: TBaseVirtualNamespaceExtensionClass; RootHookClassID: TGUID);
    function RootVirtualNamespaceHookPIDL(PIDL: PItemIDList): PItemIDList;
    procedure SaveToStream(S: TStream);
    procedure UnHookPIDL(PIDL: PItemIDList);
    procedure UnRegisterNamespaceExtension(NamespaceExtClassID: TGUID);
    function VirtualHook(AbsolutePIDL: PItemIDList): IShellFolder; overload;
    function VirtualHook(NamespaceExtClassID: TGUID): IShellFolder; overload; {11.14.02}
    function RegisteredGUID(AGUID: TGUID): Boolean;

    property NamespaceItems[Index: integer]: TNamespaceFactoryItem read GetNamespaceItems;
  end;


function ExtractGUID_FromPIDL(PIDL: PItemIDList): TGUID;
function NamespaceExtensionFactory: TNamespaceExtensionFactory;

implementation

uses
  VirtualShellUtilities;

type
  PPIDLRawArray = ^TPIDLRawArray;
  TPIDLRawArray = array[0..0] of PItemIDList;

var
  PIDLManager: TPIDLManager;
  NamespaceExtFactory: TNamespaceExtensionFactory = nil;

function NamespaceExtensionFactory: TNamespaceExtensionFactory;
begin
  if not Assigned(NamespaceExtFactory) then
    NamespaceExtFactory := TNamespaceExtensionFactory.Create;
  Result := NamespaceExtFactory
end;

function ExtractGUID_FromPIDL(PIDL: PItemIDList): TGUID;
var
  PIDLHelper: TItemID;
begin
  if PIDL.mkid.cb > SizeOf(TGUID) then
  begin
    PIDLHelper := TItemID.Create(GUID_NULL);
    PIDLHelper.ItemID := PIDL;
    Result := PIDLHelper.ClassID;
    PIDLHelper.Free;
  end else
    Result := GUID_NULL
end;

function SFGAO_ToFolderAttributes(SFGAO_Flags: LongWord): TFolderAttributes;
begin
  Result := [];
  if SFGAO_Flags and SFGAO_CANCOPY <> 0 then
    Include(Result, faCanCopy);
  if SFGAO_Flags and SFGAO_CANDELETE <> 0 then
    Include(Result, faDelete);
  if SFGAO_Flags and SFGAO_CANLINK <> 0 then
    Include(Result, faCanLink);
  if SFGAO_Flags and SFGAO_CANMONIKER <> 0 then
    Include(Result, faCanMoniker);
  if SFGAO_Flags and SFGAO_CANMOVE <> 0 then
    Include(Result, faCanMove);
  if SFGAO_Flags and SFGAO_CANRENAME <> 0 then
    Include(Result, faCanRename);
  if SFGAO_Flags and SFGAO_DROPTARGET <> 0 then
    Include(Result, faDropTarget);
  if SFGAO_Flags and SFGAO_HASPROPSHEET <> 0 then
    Include(Result, faHasPropSheet);
  if SFGAO_Flags and SFGAO_GHOSTED <> 0 then
    Include(Result, faGhosted);
  if SFGAO_Flags and SFGAO_LINK <> 0 then
    Include(Result, faLink);
  if SFGAO_Flags and SFGAO_READONLY <> 0 then
    Include(Result, faReadOnly);
  if SFGAO_Flags and SFGAO_SHARE <> 0 then
    Include(Result, faShare);
  if SFGAO_Flags and SFGAO_HASSUBFOLDER <> 0 then
    Include(Result, faHasSubFolder);
  if SFGAO_Flags and SFGAO_BROWSABLE <> 0 then
    Include(Result, faBrowsable);
  if SFGAO_Flags and SFGAO_COMPRESSED <> 0 then
    Include(Result, faCompressed);
  if SFGAO_Flags and SFGAO_FILESYSTEM <> 0 then
    Include(Result, faFileSystem);
  if SFGAO_Flags and SFGAO_FILESYSANCESTOR <> 0 then
    Include(Result, faFileSysAncestor);
  if SFGAO_Flags and SFGAO_FOLDER <> 0 then
    Include(Result, faFolder);
  if SFGAO_Flags and SFGAO_NEWCONTENT <> 0 then
    Include(Result, faNewContent);
  if SFGAO_Flags and SFGAO_NONENUMERATED <> 0 then
    Include(Result, faNonEnumerated);
  if SFGAO_Flags and SFGAO_REMOVABLE <> 0 then
    Include(Result, faRemovable);
  if SFGAO_Flags and SFGAO_VALIDATE <> 0 then
    Include(Result, faValidate);
end;

function SHGDN_ToDisplayNameFlags(SHGDN_Flags: LongWord): TDisplayNameFlags;
begin
  Result := [];
  if SHGDN_Flags and SHGDN_INFOLDER <> 0 then
    Include(Result, dnfInFolder);
  if SHGDN_Flags and SHGDN_INCLUDE_NONFILESYS <> 0 then
    Include(Result, dnfIncludeNonFileSys);
  if SHGDN_Flags and SHGDN_FORADDRESSBAR <> 0 then
    Include(Result, dnfForAddressBar);
  if SHGDN_Flags and SHGDN_FORPARSING <> 0 then
    Include(Result, dnfForParsing);
  if Result = [] then
    Include(Result, dnfNormal);
end;

function FolderAttributesTo_SFGAO(Attributes: TFolderAttributes): LongWord;
begin
  Result := 0;
  if faCanCopy in Attributes then
    Result := Result or SFGAO_CANCOPY;
  if faDelete in Attributes then
    Result := Result or SFGAO_CANDELETE;
  if faCanLink in Attributes then
    Result := Result or SFGAO_CANLINK;
  if faCanMoniker in Attributes then
    Result := Result or SFGAO_CANMONIKER;
  if faCanMove in Attributes then
    Result := Result or SFGAO_CANMOVE;
  if faCanRename in Attributes then
    Result := Result or SFGAO_CANRENAME;
  if faDropTarget in Attributes then
    Result := Result or SFGAO_DROPTARGET;
  if faHasPropSheet in Attributes then
    Result := Result or SFGAO_HASPROPSHEET;
  if faGhosted in Attributes then
    Result := Result or SFGAO_GHOSTED;
  if faLink in Attributes then
    Result := Result or SFGAO_LINK;
  if faReadOnly in Attributes then
    Result := Result or SFGAO_READONLY;
  if faShare in Attributes then
    Result := Result or SFGAO_SHARE;
  if faHasSubFolder in Attributes then
    Result := Result or SFGAO_HASSUBFOLDER;
  if faBrowsable in Attributes then
    Result := Result or SFGAO_BROWSABLE;
  if faCompressed in Attributes then
    Result := Result or SFGAO_COMPRESSED;
  if faFileSystem in Attributes then
    Result := Result or SFGAO_FILESYSTEM;
  if faFileSysAncestor in Attributes then
    Result := Result or SFGAO_FILESYSANCESTOR;
  if faFolder in Attributes then
    Result := Result or SFGAO_FOLDER;
  if faNewContent in Attributes then
    Result := Result or SFGAO_NEWCONTENT;
  if faNonEnumerated in Attributes then
    Result := Result or SFGAO_NONENUMERATED;
  if faRemovable in Attributes then
    Result := Result or SFGAO_REMOVABLE;
  if faValidate in Attributes then
    Result := Result or SFGAO_VALIDATE;
end;

function SHCONTF_ToFolderEnumFlags(Flags: LongWord): TFolderEnumFlags;
begin
  Result := [];
  if SHCONTF_FOLDERS and Flags <> 0 then
    Include(Result, fefFolders);
  if SHCONTF_NONFOLDERS and Flags <> 0 then
    Include(Result, fefNonFolder);
  if SHCONTF_INCLUDEHIDDEN and Flags <> 0 then
    Include(Result, fefHidden);
end;

function SHCONTF_ToSetNameFlags(Flags: LongWord): TSetNameFlags;
begin
  Result := [];
  if SHCONTF_FOLDERS and Flags <> 0 then
    Include(Result, snfFolders);
  if SHCONTF_NONFOLDERS and Flags <> 0 then
    Include(Result, snfNonFolder);
  if SHCONTF_INCLUDEHIDDEN and Flags <> 0 then
    Include(Result, snfHidden);
end;

function KeyStateToKeyStateType(KeyState: LongWord):  TVirtualDropKeyStates;
begin
  Result := [];
  if MK_CONTROL and KeyState <> 0 then
    Include(Result, vdksControl);
  if MK_SHIFT and KeyState <> 0 then
    Include(Result, vdksShift);
  if MK_ALT and KeyState <> 0 then
    Include(Result, vdksAlt);
  if MK_BUTTON and KeyState <> 0 then
    Include(Result, vdksButton);
  if MK_LBUTTON and KeyState <> 0 then
    Include(Result, vdksLeftButton);
  if MK_MBUTTON and KeyState <> 0 then
    Include(Result, vdksMiddleButton);
  if MK_RBUTTON and KeyState <> 0 then
    Include(Result, vdksRightButton);
end;

function TVirtualColumnAlignmentToLVCFMT(Format: TVirtualColumnAlignment): LongWord;
begin
  Result := LVCFMT_LEFT;  // Left is default
  if Format = vcaCenter then
    Result := Result and LVCFMT_CENTER;
  if Format = vcaRight then
    Result := Result and LVCFMT_RIGHT;
end;

{function KeyStateTypeToKeyState(KeyState: TVirtualDropKeyStates): LongWord;
begin
  Result := 0;
  if vdksControl in KeyState then
    Result := Result or MK_CONTROL;
  if vdksShift in KeyState then
    Result := Result or MK_SHIFT;
  if vdksAlt in KeyState then
    Result := Result or MK_ALT;
  if vdksButton in KeyState then
    Result := Result or MK_BUTTON;
  if vdksLeftButton in KeyState then
    Result := Result or MK_LBUTTON;
  if vdksMiddleButton in KeyState then
    Result := Result or MK_MBUTTON;
  if vdksRightButton in KeyState then
    Result := Result or MK_RBUTTON;
end; }

function DropEffectToDropEffectType(DropEffect: LongInt): TVirtualDropEffects;
begin
  Result := [];
  if DropEffect or DROPEFFECT_COPY <> 0 then
    Include(Result, vdeCopy);
  if DropEffect or DROPEFFECT_MOVE <> 0 then
    Include(Result, vdeMove);
  if DropEffect or DROPEFFECT_LINK <> 0 then
    Include(Result, vdeLink);
end;

function DropEffectTypeToDropEffect(DropEffect: TVirtualDropEffects): LongInt;
begin
  Result := DROPEFFECT_NONE;
  if vdeCopy in DropEffect then
    Result := Result or DROPEFFECT_COPY;
  if vdeMove in DropEffect then
    Result := Result or DROPEFFECT_MOVE;
  if vdeLink in DropEffect then
    Result := Result or DROPEFFECT_LINK;
end;


{ TBaseVirtualNamespaceExtension }

function TBaseVirtualNamespaceExtension.Attributes(ChildPIDLList: TPIDLList; Attribs: TFolderAttributes): TFolderAttributes;
begin
  // Asks for a test of what attributes the object has if the bit is set entering the
  // the function then that test is requested.  If the attribute is true then that bit
  // is set on exit of the method else it is not set
  // Note this is the attributes are of the child referenced by the passed PIDL
  Result := [];  // Default no attributes are set
end;

function TBaseVirtualNamespaceExtension.BindToObject(pidl: PItemIDList;
  pbcReserved: Pointer; const riid: TIID; out ppvOut{$IFNDEF COMPILER_5_UP}: Pointer{$ENDIF}): HResult;
begin
  Result := E_NOTIMPL
end;

function TBaseVirtualNamespaceExtension.BindToStorage(pidl: PItemIDList;
  pbcReserved: Pointer; const riid: TIID; out ppvObj{$IFNDEF COMPILER_5_UP}: Pointer{$ENDIF}): HResult;
begin
  Result := E_NOTIMPL
end;

function TBaseVirtualNamespaceExtension.CompareIDs(lParam: LPARAM; pidl1,
  pidl2: PItemIDList): HResult;
begin
  Result := MAKE_HRESULT(SEVERITY_SUCCESS, FACILITY_NULL, Word((CompareItems(lParam, pidl1, pidl2))))
end;

function TBaseVirtualNamespaceExtension.CompareItems(
  ColumnToCompare: integer; ChildPIDL1,
  ChildPIDL2: PItemIDList): ShortInt;
// Override this method to sort the custom items in the naemspace
begin
// Result defined as:
// Less than zero     :  The first item should precede the second (RelativePIDL1 < RelativePIDL2).
// Greater than zero  : The first item should follow the second (RelativePIDL1 > RelativePIDL2)
// Zero                : The two items are the same (RelativePIDL1 = RelativePIDL2).
  Result := 0;
end;

constructor TBaseVirtualNamespaceExtension.Create;
begin
  inherited Create;
  FItemID := CreateItemID;
  FSupportedInterfaces := GetSupportedInterfaces;
end;

function TBaseVirtualNamespaceExtension.CreateIContextMenu(
  ChildPIDLs: TPIDLList): IContextMenu;
begin
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.CreateIDataObject(
  ChildPIDLs: TPIDLList; ObjectRequestor: TDataObjectType): IDataObject;
begin
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.CreateIDropTarget(
  ChildPIDLs: TPIDLList): IDropTarget;
begin
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.CreateIDropTarget: IDropTarget;
begin
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.CreateIExtractIconA(
  ChildPIDLs: TPIDLList): IExtractIconA;
begin
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.CreateIExtractIconW(
  ChildPIDLs: TPIDLList): IExtractIconW;
begin
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.CreateIQueryInfo(
  ChildPIDLs: TPIDLList): IQueryInfo;
begin
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.CreateIShellDetails(ChildPIDL: PItemIDList): {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF};
begin
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.CreateViewObject(hwndOwner: HWND;
  const riid: TIID; out ppvOut{$IFNDEF COMPILER_5_UP}: Pointer{$ENDIF}): HResult;
begin
  if IsEqualGUID(riid, IDropTarget) then
  begin
    IDropTarget(ppvOut) := CreateIDropTarget as IDropTarget;
    Result := S_OK
  end else
    Result := E_NOINTERFACE
end;

destructor TBaseVirtualNamespaceExtension.Destroy;
begin
  FItemID.Free;
  PIDLManager.FreeAndNilPIDL(FDropTargetPIDL);
  inherited;
end;

procedure TBaseVirtualNamespaceExtension.DisplayName(ChildPIDL: PItemIDList;
  NameType: TDisplayNameFlags; var StrRet: TStrRet);
begin
  // Returns the display name of the namespace.  Note that for ANSI versions the
  // name is stored in the ItemID and an offset is passed back
  // Note this is the display name of the child referenced by the passed PIDL
end;

function TBaseVirtualNamespaceExtension.EnumFirstChild(EnumFlags: TFolderEnumFlags): PItemIDList;
begin
// The Extenstion will call this method to retrive the child objects as they are being requested
// The extension should keep a list of the child objects as VET will ask this extension
// to get information about the child items in some instances, such as attributes and names
  Result := nil
end;

function TBaseVirtualNamespaceExtension.EnumNextChild(EnumFlags: TFolderEnumFlags): PItemIDList;
begin
// The Extenstion will call this method to retrive the child objects as they are being requested
// The extension should keep a list of the child objects as VET will ask this extension
// to get information about the child items in some instances, such as attributes and names
  Result := nil;
end;

function TBaseVirtualNamespaceExtension.EnumObjects(hwndOwner: HWND;
  grfFlags: DWORD; out EnumIDList: IEnumIDList): HResult;
begin
  EnumIDList := TVirtualNamespaceEnum.Create(Self, SHCONTF_ToFolderEnumFlags(grfFlags)) as IEnumIDList;
  if Assigned(EnumIDList) then
    Result := NOERROR
  else
    Result := E_OUTOFMEMORY
end;

function TBaseVirtualNamespaceExtension.GetAttributesOf(cidl: UINT;
  var apidl: PItemIDList; var rgfInOut: UINT): HResult;
// Retrieves the attributes for child objects of a namespace.  THESE MUST BE
// SINGLE LEVEL PIDLS.  It can't be expected that a namespace can figure out the
// attributes of a child several levels down.
var
  PIDLList: TPIDLList;
  Flags: TFolderAttributes;
begin
  PIDLList := TPIDLList.Create;
  PIDLManager.ParsePIDL(apidl, PIDLList, False);
  Flags := SFGAO_ToFolderAttributes(rgfInOut);
  rgfInOut := FolderAttributesTo_SFGAO( Attributes(PIDLList, Flags));
  PIDLList.Free;
  Result := NOERROR
end;

function TBaseVirtualNamespaceExtension.GetClassID(out classID: TCLSID): HResult;
begin
  classID := RetrieveClassID;
  Result := NOERROR
end;

function TBaseVirtualNamespaceExtension.GetDisplayNameOf(pidl: PItemIDList;
  uFlags: DWORD; var lpName: TStrRet): HResult;
begin
  DisplayName(pidl, SHGDN_ToDisplayNameFlags(uFlags), lpName);
  Result := NOERROR
end;

function TBaseVirtualNamespaceExtension.GetIconOf(pidl: PItemIDList;
  flags: UINT; out IconIndex: Integer): HResult;
var
  IconFlags: TVirtualIconFlags;
begin
  IconIndex := -1;
  IconFlags := [];
  if flags and GIL_FORSHELL <> 0 then
    Include(IconFlags, ifShell);  // Large Icon
  if flags and GIL_OPENICON <> 0 then
    Include(IconFlags, ifOpen);  // Open Icon
  Self.IconIndex(pidl, IconFlags, IconIndex);
  if IconIndex > -1 then
    Result := NOERROR
  else
    Result := E_NOTIMPL
end;

function TBaseVirtualNamespaceExtension.GetInFolderNameASCII_Offset: integer;
begin
  // Equals the size of the the TPItemIdList.mk.cb field for the PIDL + GUID + Version integer + count for the size of the string
  Result := SizeOf(Word) + SizeOf(TGUID) + {SizeOf(Byte) + }SizeOf(LongWord) +  SizeOf(integer)
end;

function TBaseVirtualNamespaceExtension.GetSupportedInterfaces: TSupportedInterfaces;
begin
  // Override to return the supported interfaces the extension will handle
  Result := [];
end;

function TBaseVirtualNamespaceExtension.GetUIObjectOf(hwndOwner: HWND; cidl: UINT;
  var apidl: PItemIDList; const riid: TIID; prgfInOut: Pointer;
  out ppvOut{$IFNDEF COMPILER_5_UP}: Pointer{$ENDIF}): HResult;
var
  PIDLList: TPIDLList;
  PIDLRawArray: PPIDLRawArray;
  i: Integer;
begin
  Result := E_NOTIMPL;
  Pointer(ppvOut) := nil;
  PIDLList := TPIDLList.Create;
  Pointer(PIDLRawArray) := @apidl;
  for i := 0 to cidl - 1 do
  begin
    if Assigned(apidl) then
      PIDLList.Add(PIDLRawArray^[i]);
  end;

  if IsEqualGUID(riid, IDropTarget) then
  begin
    // Only one PIDL makes any sense here
    if PIDLList.Count = 1 then
      IDropTarget(ppvOut) := CreateIDropTarget(PIDLList) as IDropTarget;
  end;
  if (siIShellDetails in SupportedInterfaces) and IsEqualGUID(riid, IID_IShellDetails) then
  begin
    // Only one PIDL makes any sense here
    if (PIDLList.Count < 2) then
      {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF}(ppvOut) := CreateIShellDetails(apidl);
  end;
  if (siIContextMenu in SupportedInterfaces) and IsEqualGUID(riid, IContextMenu) then
  begin
    IContextMenu(ppvOut) := CreateIContextMenu(PIDLList) as IContextMenu;
  end;
  if (siIContextMenu2 in SupportedInterfaces) and IsEqualGUID(riid, IContextMenu2) then
  begin
    IContextMenu2(ppvOut) := CreateIContextMenu(PIDLList) as IContextMenu2;
  end;
  if (siIContextMenu3 in SupportedInterfaces) and IsEqualGUID(riid, IContextMenu3) then
  begin
    IContextMenu3(ppvOut) := CreateIContextMenu(PIDLList) as IContextMenu3;
  end;
  if (siIDataObject in SupportedInterfaces) and IsEqualGUID(riid, IDataObject) then
  begin
    IDataObject(ppvOut) := CreateIDataObject(PIDLList, dotDragDrop) as IDataObject;
  end;
  if (siIExtractIconA in SupportedInterfaces) and IsEqualGUID(riid, IExtractIconA) then
  begin
    // Only one PIDL makes any sense here
    if PIDLList.Count = 1 then
      IExtractIconA(ppvOut) := CreateIExtractIconA(PIDLList) as IExtractIconA;
  end;
  if (siIExtractIconW in SupportedInterfaces) and IsEqualGUID(riid, IExtractIconW) then
  begin
    // Only one PIDL makes any sense here
    if PIDLList.Count = 1 then
      IExtractIconW(ppvOut) := CreateIExtractIconW(PIDLList) as IExtractIconW;
  end;
  if (siIQueryInfo in SupportedInterfaces) and IsEqualGUID(riid, IQueryInfo) then
  begin
    // Only one PIDL makes any sense here
    if PIDLList.Count = 1 then
      IQueryInfo(ppvOut) := CreateIQueryInfo(PIDLList) as IQueryInfo;
  end;
  PIDLList.Free;
  if Pointer(ppvOut) <> nil then
    Result := NOERROR
end;

procedure TBaseVirtualNamespaceExtension.IconIndex(ChildPIDL: PItemIDList;
  IconStyle: TVirtualIconFlags; var IconIndex: integer);
begin
  IconIndex := ICON_BLANK;
  // Returns the index of the icon in the system image list
  // The constants are defined by the system:
  //  ICON_BLANK = 0;           // Unassocaiated file
  //  ICON_DATA  = 1;           // With data
  //  ICON_APP   = 2;           // Application, bat file etc
  //  ICON_FOLDER = 3;          // Plain folder
  //  ICON_FOLDEROPEN = 4;      // Open Folder
end;

function TBaseVirtualNamespaceExtension.Initialize(pidl: PItemIDList): HResult;
var
  StorePIDL: Boolean;
begin
  StorePIDL := True;
  if InitializeNamespace(StorePIDL) then
  begin
    FAbsolutePIDL := PIDLManager.CopyPIDL(pidl);
    if Assigned(FAbsolutePIDL) then
      Result := NOERROR
    else
      Result := E_OUTOFMEMORY
  end else
    Result := E_FAIL
end;

function TBaseVirtualNamespaceExtension.InitializeNamespace(
  var StoreParentPIDL: Boolean): Boolean;
// Called when the namespace is being intialized (BindToObject is being called)
// If the namespace cares where it is in the shell tree then save the Full PIDL
// path to the root folder of the tree.  If the namespace can not be initialized
// for any reason and the object should not be created return false
begin
  StoreParentPIDL := True;
  Result := True
end;

function TBaseVirtualNamespaceExtension.ParseDisplayName(hwndOwner: HWND;
  pbcReserved: Pointer; lpszDisplayName: POLESTR; out pchEaten: ULONG;
  out ppidl: PItemIDList; var dwAttributes: ULONG): HResult;
begin
  Result := E_NOTIMPL
end;

function TBaseVirtualNamespaceExtension.SetName(ChildPIDL: PItemIDList;
  NewName: WideString; ObjectType: TSetNameFlags; var NewPIDL: PItemIDList): Boolean;
begin
  // This is how you change the name of an object.  Create a new PIDL based on the
  // new passed name and return it
  NewPIDL := nil;
  Result := False;
end;

function TBaseVirtualNamespaceExtension.SetNameOf(hwndOwner: HWND;
  pidl: PItemIDList; lpszName: POLEStr; uFlags: DWORD;
  var ppidlOut: PItemIDList): HResult;
begin
  if SetName(pidl, WideString(lpszName), SHCONTF_ToSetNameFlags(uFlags), ppidlOut) then
    Result := NOERROR
  else
    Result := E_FAIL
end;


{ TNamespaceExtensionFactory }

function TNamespaceExtensionFactory.BindToVirtualObject(AbsolutePIDL: PItemIDList): IShellFolder;
// Call this instead of IShellFolder.BindToObject directly to allow VET to bind
// to Custom Namespaces as well as regular shell namespaces
// ParentFolder can be nil where as PIDL must be an absolute PIDL to bind to shell objects
// This can be called from image threads etc so needs to make the factory thread safe
// Namespace is optional and can greatly increase the execution time for the function since
// the TNamespace carries information of what is the right way to bind to the PIDL
var
  Folder: IShellFolder;
  LastPIDL: PItemIdList;
begin
  Result := nil;
  EnterCriticalSection(FLock);
  try
    Result := nil;

    if Assigned(AbsolutePIDL) then
    begin
      if IsVirtualPIDL(AbsolutePIDL) then
      begin
        LastPIDL := PIDLManager.GetPointerToLastID(AbsolutePIDL);
        Result := CreateNamespaceExtension(PGUID( @LastPIDL.mkid.abID)^);
        if Assigned(Result) then
         (Result as IPersistFolder).Initialize(AbsolutePIDL);
      end else
      begin
        // Ok lets try a Shell Binding
        SHGetDesktopFolder(Folder);
        // If it is the desktop then we are done
        // else bind from the desktop to the PIDL
        if AbsolutePIDL.mkid.cb = 0 then
          Result := Folder
        else
          Folder.BindToObject(AbsolutePIDL, nil, IShellFolder, Pointer(Result));

        // There are instances where we are hooking a file and the shell does not
        // concider files as objects, they are children of a folder that is an
        // object.  In those cases the AbsolutePIDL is not a VirtualPIDL and it
        // is not a bindable shell folder so we must fake it here with the hook
    //    if not Assigned(Result) then
    //      Result := VirtualHook(AbsolutePIDL);
           /// NOTE:  This causes problems with Hard vs Soft hooking.  It is better
           //         to *instist* that hooking of non-Folder objects be required to
           //         use HardHooking, period.  This is not a big deal since there
           //         is no such thing as Soft Hooking a non-Folder object since
           //         it can't enumerate any sub objects anyway.
      end
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.BindToVirtualParentObject(
  AbsolutePIDL: PItemIDList): IShellFolder;
// Call this instead of IShellFolder.BindToObject directly to allow VET to bind
// to Custom Namespaces as well as regular shell namespaces
// ParentFolder can be nil where as PIDL must be an absolute PIDL to bind to shell objects
// This can be called from image threads etc so needs to make the factory thread safe
// Namespace is optional and can greatly increase the execution time for the function since
// the TNamespace carries information of what is the right way to bind to the PIDL
var
  Folder: IShellFolder;
  LastPIDL, Tail: PItemIdList;
  OldCB: Word;
  Hook: Boolean;
begin
  Result := nil;
  OldCB := 0;
  EnterCriticalSection(FLock);
  try
    Hook := IsRootVirtualPIDL(AbsolutePIDL);

    Result := nil;
    LastPIDL := PIDLManager.GetPointerToLastID(AbsolutePIDL);
    try
      OldCB := LastPIDL.mkid.cb;
      LastPIDL.mkid.cb := 0;

      if Hook then
        Result := VirtualHook(AbsolutePIDL)
      else begin
        if Assigned(AbsolutePIDL) then
        begin
          if IsVirtualPIDL(AbsolutePIDL) then
          begin
            Tail := PIDLManager.GetPointerToLastID(AbsolutePIDL);
            Result := CreateNamespaceExtension(PGUID( @Tail.mkid.abID)^);
            if Assigned(Result) then
             (Result as IPersistFolder).Initialize(AbsolutePIDL);
          end else
          begin
            if not Assigned(Result) then
            begin
              // Ok lets try a Shell Binding
              SHGetDesktopFolder(Folder);
              // If it is the desktop then we are done
              // else bind from the desktop to the PIDL
              if AbsolutePIDL.mkid.cb = 0 then
                Result := Folder
              else
                Folder.BindToObject(AbsolutePIDL, nil, IShellFolder, Pointer(Result))
            end
          end
        end
      end
    finally
      if Assigned(LastPIDL) then
        LastPIDL.mkid.cb := OldCB;
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

procedure TNamespaceExtensionFactory.ChangeNotify(NotifyType: Longword; PIDL1, PIDL2: PItemIDList);
begin
  ChangeNotifier.PostShellNotifyEvent(NotifyType, PIDL1, PIDL2);
end;

procedure TNamespaceExtensionFactory.ClearExtensions;
// Frees the TNamespaceFactoryItem objects stored in the list and empties the
// list
var
  i: integer;
begin
  EnterCriticalSection(FLock);
  try
    for i := 0 to NSExtList.Count - 1 do
      NamespaceItems[i].Free;
    NSExtList.Clear
  finally
    LeaveCriticalSection(FLock)
  end
end;

constructor TNamespaceExtensionFactory.Create;
begin
  FNSExtList := TList.Create;
  FHookedPIDLItems := TObjectList.Create;
  SHGetDesktopFolder(FDesktop);
  InitializeCriticalSection(FLock);
end;

function TNamespaceExtensionFactory.CreateNamespaceExtension(NamespaceExtClassID: TGUID): IShellFolder;
// Creates a new instance of the Namespace Extension that is registered with the
// ClassID, if it exists
var
  Item: TNamespaceFactoryItem;
  Index: integer;
begin
  EnterCriticalSection(FLock);
  try
    Result := nil;
    Item := FindNamespaceItem(NamespaceExtClassID, Index);
    if Assigned(Item) then
      Result := Item.NamespaceExtClass.Create as IShellfolder;
  finally
    LeaveCriticalSection(FLock)
  end
end;

destructor TNamespaceExtensionFactory.Destroy;
begin
  EnterCriticalSection(FLock);
  try
    ClearExtensions;
    FNSExtList.Free;
    FHookedPIDLItems.Free;
  finally
    LeaveCriticalSection(FLock);
  end;
  DeleteCriticalSection(FLock);
  inherited;
end;

function TNamespaceExtensionFactory.ExtractVirtualGUID(PIDL: PItemIDList;
  var GUID: TGUID): Boolean;
var
  LastPIDL: PItemIdList;
begin
  EnterCriticalSection(FLock);
  try
    Result := False;
    GUID := GUID_NULL;
    if Assigned(PIDL) then
      if IsVirtualPIDL(PIDL) then
      begin
        // no need to check for lenght as IsCustomPIDL did it all
        LastPIDL := PIDLManager.GetPointerToLastID(PIDL);
        Result := RegisteredGUID(PGUID( @LastPIDL.mkid.abID)^);
        if Result then
          GUID := PGUID( @LastPIDL.mkid.abID)^
      end
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.ExtractVirtualGUID(PIDL: PItemIDList): TGUID;
var
  LastPIDL: PItemIdList;
begin
  EnterCriticalSection(FLock);
  try
    Result := GUID_NULL;
    if Assigned(PIDL) then
      if IsVirtualPIDL(PIDL) then
      begin
        // no need to check for lenght as IsCustomPIDL did it all
        LastPIDL := PIDLManager.GetPointerToLastID(PIDL);
        if RegisteredGUID(PGUID( @LastPIDL.mkid.abID)^) then
          Result := PGUID( @LastPIDL.mkid.abID)^
      end
   finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.FindNamespaceItem(
  NamespaceExtClassID: TGUID; var Index: integer): TNamespaceFactoryItem;
var
  i: integer;
  Found: Boolean;
begin
  EnterCriticalSection(FLock);
  try
    Result := nil;
    Index := -1;
    Found := False;
    i := 0;
    while (i < FNSExtList.Count) and not Found do
    begin
      Found := IsEqualGUID(NamespaceExtClassID, NamespaceItems[i].NamespaceExtClassID);
      if Found then
      begin
        Result := NamespaceItems[i];
        Index := i
      end;
      Inc(i);
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.GetNamespaceItems(Index: integer): TNamespaceFactoryItem;
begin
  EnterCriticalSection(FLock);
  try
    if (Index > -1) and (Index < NSExtList.Count) then
      Result := NSExtList[Index]
    else
      Result := nil
  finally
    LeaveCriticalSection(FLock)
  end
end;

procedure TNamespaceExtensionFactory.HookPIDL(PIDL: PItemIDList;
  NamespaceExtClassID: TGUID; HardHooked: Boolean);
var
  Index: Integer;
begin
  EnterCriticalSection(FLock);
  try
    if not IsHookedPIDL(PIDL, Index) then
      HookedPIDLItems.Add(THookedPIDLItem.Create(PIDL, NamespaceExtClassID, HardHooked))
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.IsHardHookedPIDL(
  AbsolutePIDL: PItemIDList): Boolean;
var
  i, TestIDCount: Integer;
  Done: Boolean;
begin
  Result := False;
  EnterCriticalSection(FLock);
  try
    Done := False;
    i := 0;
    TestIDCount := PIDLManager.IDCount(AbsolutePIDL);
    while not Result and (i < HookedPIDLItems.Count) do
    begin
      if TestIDCount = THookedPIDLItem(HookedPIDLItems[i]).PIDLIDCount then
        Done := ILIsEqual(AbsolutePIDL, THookedPIDLItem(HookedPIDLItems[i]).PIDL);
      if Done then
        Result := THookedPIDLItem(HookedPIDLItems[i]).HardHooked;
      Inc(i)
    end;
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.IsHookedPIDL(AbsolutePIDL: PItemIDList;
  var Index: Integer): Boolean;
var
  i, TestIDCount: Integer;
begin
  EnterCriticalSection(FLock);
  try
    Index := -1;
    Result := False;
    i := 0;
    TestIDCount := PIDLManager.IDCount(AbsolutePIDL);
    while not Result and (i < HookedPIDLItems.Count) do
    begin
      if TestIDCount = THookedPIDLItem(HookedPIDLItems[i]).PIDLIDCount then
        Result := ILIsEqual(AbsolutePIDL, THookedPIDLItem(HookedPIDLItems[i]).PIDL);
      Inc(i)
    end;
    if Result then
      Index := i - 1
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.IsHookedPIDL(AbsolutePIDL: PItemIDList): Boolean;
var
  i: Integer;
begin
  Result := IsHookedPIDL(AbsolutePIDL, i);
end;

function TNamespaceExtensionFactory.IsRootVirtualPIDL(AbsolutePIDL: PItemIDList): Boolean;
var
  i, j: Integer;
  PIDL: PItemIDList;
begin
  EnterCriticalSection(FLock);
  try
    Result := False;
    PIDL := PIDLManager.GetPointerToLastID(AbsolutePIDL);
    if RegisteredGUID(PGUID( @PIDL.mkid.abID)^) then
    begin
      PIDL := AbsolutePIDL;
      j := PIDLManager.IDCount(PIDL);
      if j = 1 then
        Result := True // It is a Virtual PIDL under the desktop
      else begin
        for i := 0 to j - 3 do
          PIDL := PIDLManager.NextID(PIDL);
        Result := not RegisteredGUID(PGUID( @PIDL.mkid.abID)^)
      end
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.IsVirtualPIDL(PIDL: PItemIDList): Boolean;
// If RootCustomPIDL is true then the method will only be true if the PIDL is a custom
// PIDL AND it is the first Custom PIDL in the AbsolutePIDL
var
  LastPIDL: PItemIdList;
begin
  EnterCriticalSection(FLock);
  try
    Result := False;
    if Assigned(PIDL) then
    begin
      LastPIDL := PIDLManager.GetPointerToLastID(PIDL);
      if LastPIDL.mkid.cb > SizeOf(TGUID) then
        Result := RegisteredGUID(PGUID( @LastPIDL.mkid.abID)^);
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

procedure TNamespaceExtensionFactory.LoadFromStream(S: TStream);
// Reads the TNamespaceFactoryItems to a stream
var
  i, Size: integer;
  NewItem: TNamespaceFactoryItem;
begin
  EnterCriticalSection(FLock);
  try
    ClearExtensions;
    Size := S.Read(Size, SizeOf(Size));
    for i := 0 to Size - 1 do
    begin
      NewItem := TNamespaceFactoryItem.Create;
      NewItem.LoadFromStream(S);
      FNSExtList.Add(NewItem)
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.RegisteredGUID(AGUID: TGUID): Boolean;
// Sees if the passed GUID is registered with the Factory
var
  i: integer;
begin
  EnterCriticalSection(FLock);
  try
    i := 0;
    Result := False;
    while not Result and (i < NSExtList.Count) do
    begin
      Result := IsEqualGUID(AGUID, TNamespaceFactoryItem(NSExtList[i]).NamespaceExtClassID);
      Inc(i)
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

procedure TNamespaceExtensionFactory.RegisterNamespaceExtension(
  NamespaceExtClass: TBaseVirtualNamespaceExtensionClass;
  NamespaceExtClassID: TGUID;
  RootHookClass: TBaseVirtualNamespaceExtensionClass;
  RootHookClassID: TGUID);
// Registers a new Namespace Extension type with the Class Factory.
//
// Parameters:
//    NamespaceExtClass:
//        This is the type of class of the derived from TBaseVirtualNamespaceExtenstion
//        It is the Junction Point between the Real and Virtual Namespaces.
//        Typically it will be the Virtual Child of a real namespace, it
//        is currently possible to create a VirtualNamespace as a sibling
//        of real namespaces but not all functionallty of VET is maintained
//    NamespaceExtClassID:
//        Every VirtualNamespace class must have unique GUID assigned to it (press
//        CTL-SHIFT-G in the editor to create a unique GUID) and this GUID must
//        be returned in the overridden abstract RetrieveClassID method of the class
//    RootHookClass:
//        This is the type of class that again is derived from TBaseVirtualNamespaceExtenstion.
//        It is the special hidden namespace that acts as the true parent of the
//        visible Junction Point VirtualNamespace since the real namespace has no
//        idea that it has a virtual child.  The class is called to retrieve the
//        Display Name of the NamespaceExtClass, retrieve the details of the NamespaceExtClass,
//        and any operation that IShellFolder asks the parent of a namespace to
//        supply for it children.
//    RootHookClassID:
//        Again every VirtualNamespace class must have unique GUID assigned to it (press
//        CTL-SHIFT-G in the editor to create a unique GUID) and this GUID must
//        be returned in the overridden abstract RetrieveClassID method of the class
//    RootHeaderHookClass:
//        The Real Hooked namespace will query its parent to show the header column
//        info.  We need to override that behavior so again create a decendant of
//        TBaseVirtualNamespaceExtenstion and handle all the Column Details methods
//    RootHeaderHookClassID:
//        Again every VirtualNamespace class must have unique GUID assigned to it (press
//        CTL-SHIFT-G in the editor to create a unique GUID) and this GUID must
//        be returned in the overridden abstract RetrieveClassID method of the class

var
  NewItem: TNamespaceFactoryItem;
begin
  EnterCriticalSection(FLock);
  try
    // First we need to make sure the class is registered with Delphi.  This is
    // so the streaming system knows it exists so we can create an instance through
    // the class name.  Also the class must be derived from TPersistent for Delphi's
    // streaming to work
    if GetClass(NamespaceExtClass.ClassName) = nil then
      RegisterClass(NamespaceExtClass);

    // Create a new item, populate it and add to list
    NewItem := TNamespaceFactoryItem.Create;
    NewItem.NamespaceExtClass := NamespaceExtClass;
    NewItem.NamespaceExtClassID := NamespaceExtClassID;
    NewItem.RootHookClass := RootHookClass;
    NewItem.RootHookClassID := RootHookClassID;
    NSExtList.Add(NewItem)
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.RootVirtualNamespaceHookPIDL(
  PIDL: PItemIDList): PItemIDList;
// Returns simple single level PIDL of the Hook Parent of the passed PIDL. It assumes
// that the Passed PIDL *IS* a RootVirtualNamespace.
var
  Index: Integer;
  Item: TNamespaceFactoryItem;
  ItemID: TItemID;
begin
  EnterCriticalSection(FLock);
  try
    Result := nil;
    Item := FindNamespaceItem(ExtractVirtualGUID(PIDL), Index);
    if Assigned(Item) then
    begin
      ItemID := TItemID.Create(Item.RootHookClassID);
      ItemID.InFolderNameASCII := 'VSTools VirtualNamespace Hook';
      Result := ItemID.ItemID;
      ItemID.Free
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

procedure TNamespaceExtensionFactory.SaveToStream(S: TStream);
// Writes the TNamespaceFactoryItems to a stream
var
  i, Size: integer;
begin
  EnterCriticalSection(FLock);
  try
    Size := FNSExtList.Count;
    S.Write(Size, SizeOf(Size));
    for i := 0 to Size - 1 do
      NamespaceItems[i].SaveToStream(S)
  finally
    LeaveCriticalSection(FLock)
  end
end;

procedure TNamespaceExtensionFactory.UnHookPIDL(PIDL: PItemIDList);
var
  Index: Integer;
  Item: THookedPIDLItem;
begin
  EnterCriticalSection(FLock);
  try
    if IsHookedPIDL(PIDL, Index) then
    begin
      Item := THookedPIDLItem( HookedPIDLItems[Index]);
      HookedPIDLItems.Delete(Index);
      Item.Free
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

procedure TNamespaceExtensionFactory.UnRegisterNamespaceExtension(NamespaceExtClassID: TGUID);
// Unregisters the Extension with the Extension Factory

var
  Item: TNamespaceFactoryItem;
  Index: integer;
begin
  EnterCriticalSection(FLock);
  try
    Item := FindNamespaceItem(NamespaceExtClassID, Index);
    if Assigned(Item) then
    begin
      NamespaceItems[Index].Free;
      FNSExtList.Delete(Index)
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.VirtualHook(AbsolutePIDL: PItemIDList): IShellFolder;
// If the PIDL is hooked then this returns the IShellFolder of the invisible Hook Namespace
var
  Index: Integer;
  Item: TNamespaceFactoryItem;
begin
  Result := nil;
  EnterCriticalSection(FLock);
  try
  if IsHookedPIDL(AbsolutePIDL, Index) then
    begin
      Item := FindNamespaceItem(THookedPIDLItem(HookedPIDLItems[Index]).NamespaceExtClassID, Index);
      if Assigned(Item) then
        Result := Item.RootHookFolder;
      if Assigned(Result) then
       (Result as IPersistFolder).Initialize(AbsolutePIDL);
    end
  finally
    LeaveCriticalSection(FLock)
  end
end;

function TNamespaceExtensionFactory.VirtualHook(NamespaceExtClassID: TGUID): IShellFolder;
// Returns an IShellFolder object associated with the hook namespace of the passed
// Root Namespace.  This is a special case when the Hook is not associated with
// a real namespace, for instance when a virtual namespace is wanted as a sibling
// of real namespaces
var
  Index: Integer;
  Item: TNamespaceFactoryItem;
begin
  Result := nil;
  Item := FindNamespaceItem(NamespaceExtClassID, Index);
  if Assigned(Item) then
    Result := Item.RootHookFolder;
  if Assigned(Result) then
    (Result as IPersistFolder).Initialize(nil);
end;

{ TNamespaceFactoryItem }

function TNamespaceFactoryItem.CreateClass: TBaseVirtualNamespaceExtension;
begin
  Result := NamespaceExtClass.Create;
end;

function TNamespaceFactoryItem.GetRootHookFolder: IShellFolder;
begin
  Result := nil;
  // Only valid if Item is the Junction Point between a Real and Virtual Namespace
  // with all the children of the Real being Virtual Namespace
  Result := FRootHookClass.Create;
end;

procedure TNamespaceFactoryItem.LoadFromStream(S: TStream);
var
  Size: integer;
  ClassName: string;
  P: PChar;
begin
  S.Read(FNamespaceExtClassID, SizeOf(FNamespaceExtClassID));
  S.Read(Size, SizeOf(Size));
  SetLength(ClassName, Size);
  P := PChar(ClassName);
  S.Read(P^, Size);
  NamespaceExtClass := TBaseVirtualNamespaceExtensionClass( GetClass(ClassName))
end;

procedure TNamespaceFactoryItem.SaveToStream(S: TStream);
var
  Size: integer;
  ClassName: string;
  P: PChar;
begin
  S.Write(FNamespaceExtClassID, SizeOf(FNamespaceExtClassID));
  ClassName := NamespaceExtClass.ClassName;
  Size := Length(ClassName);
  S.Write(Size, SizeOf(Size));
  P := PChar(ClassName);
  S.Write(P^, Size);
end;

//{$IFNDEF DELPHI_6_UP}

{ TVirtualInterfacedPersistent }

function TVirtualInterfacedPersistent._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TVirtualInterfacedPersistent._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

procedure TVirtualInterfacedPersistent.AfterConstruction;
begin
 // Release the constructor's implicit refcount
  InterlockedDecrement(FRefCount);
end;

procedure TVirtualInterfacedPersistent.BeforeDestruction;
begin
  Assert(RefCount = 0, 'TVirtualInterfacedPersistent object destroyed with RefCount <> 0');
end;

class function TVirtualInterfacedPersistent.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TVirtualInterfacedPersistent(Result).FRefCount := 1;
end;

function TVirtualInterfacedPersistent.QueryInterface(const IID: TGUID;
  out Obj): HResult;
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

//{$ENDIF}

{ TItemID }

procedure TItemID.Clear;
begin
  InFolderNameASCII := '';
  Version := 0;
end;

constructor TItemID.Create(AClassID: TGUID);
// The Root is defined as the first level after the shell object that is shown in
// the control.  It will be the PIDLs that the HookClass creates for its children
begin
  ClassID := AClassID;
end;

destructor TItemID.Destroy;
begin
  inherited;
end;

function TItemID.GetItemID: PItemIDList;
// Creates the PIDL from the class properties though the WritePIDLStream method
// The result is a GLOBAL memory block that must be released through the IMalloc
// global memory manager
var
  MemStream: TMemoryStream;
  Src: PChar;
  cb: Word;
begin
  MemStream := TMemoryStream.Create;
  try
    MemStream.Write(cb, SizeOf(cb));  // Reserve cb
    SavePIDLStream(MemStream);
    PSHItemID(MemStream.Memory).cb := MemStream.Size;
    MemStream.SetSize(MemStream.Size + SizeOf(Word)); // Add terminating ItemID
    Src := PChar(MemStream.Memory);
    Inc(Src, PSHItemID(Src).cb);
    PSHItemID(Src).cb := 0;
    PSHItemID(Src).abID[0] := 0;
    // PSHItemID is just as special case of PItemIDList but Delphi compains
    // Make a global memory block for our PIDL
    Result := PIDLManager.CopyPIDL( PItemIDList(MemStream.Memory));
  finally
    MemStream.Free
  end;
end;

procedure TItemID.LoadPIDLStream(S: TStream);
// Reads the PIDL to the stream
begin
  S.Read(FClassID, SizeOf(ClassID));
  S.Read(FVersion, SizeOf(FVersion));

  FInFolderNameASCII := ReadString(S);
end;

function TItemID.ReadString(S: TStream): string;
var
  Count: LongWord;
begin
  S.Read(Count, SizeOf(Count));
  SetLength(Result, Count - SizeOf(Char)); // Delphi will add the nulls for us
  S.Read(PChar(Result)^, Count - SizeOf(Char));
  S.read(Count, SizeOf(Char)); // Read the Nulls we wrote
end;

function TItemID.ReadWideString(S: TStream): WideString;
var
  Count: LongWord;
begin
  S.Read(Count, SizeOf(Count));
  SetLength(Result, Count - SizeOf(Char)); // Delphi will add the nulls for us
  S.Read(PWideChar(Result)^, Count * 2 - SizeOf(Char));
  S.read(Count, SizeOf(Char)); // Read the Nulls we wrote
end;

procedure TItemID.SavePIDLStream(S: TStream);
// Reads the PIDL from the stream
begin
  S.Write(ClassID, SizeOf(ClassID));
  S.Write(FVersion, SizeOf(FVersion));

  WriteString(InFolderNameASCII, S);
end;

procedure TItemID.SetItemID(const Value: PItemIDList);
var
  MemStream: TMemoryStream;
  PIDL: PItemIdList;
begin
  Clear;
  PIDL := PIDLManager.GetPointerToLastID(Value);
  if Assigned(PIDL) then
  begin
    if PIDL.mkid.cb > SizeOf(TGUID) then
    begin
      if IsEqualGUID(FClassID, PGUID(@PIDL.mkid.abID)^) then
      begin
        MemStream := TMemoryStream.Create;
        try
          // Set the mem stream to the same size as the last PIDL in the Fully qualified PIDL
          MemStream.Size := PIDLManager.PIDLSize(PIDL);
          CopyMemory(MemStream.Memory, PIDL, MemStream.Size);
          MemStream.Position := SizeOf(Word);  // skip over the PItemIDList.mkid.cb word
          LoadPIDLStream(MemStream);
        finally
          MemStream.Free
        end
      end
    end
  end
end;

procedure TItemID.WriteString(Str: string; S: TStream);
var
  Count: Longword;
begin
  Count := Length(Str) + SizeOf(Char);  // Add the Null because this must be a real string embedded in the PIDL
  S.Write(Count, SizeOf(Count));
  S.Write(PChar(Str)^, Count);
end;

procedure TItemID.WriteWideString(Str: WideString; S: TStream);
var
  Count: Longword;
begin
  Count := Length(Str) + SizeOf(Char);  // Add the Null because this must be a real string embedded in the PIDL
  S.Write(Count, SizeOf(Count));
  S.Write(PWideChar(Str)^, Count * 2);
end;

{ TVirtualNamespaceEnum }

function TVirtualNamespaceEnum.Clone(out ppenum: IEnumIDList): HResult;
begin
  Result := E_NOTIMPL
end;

constructor TVirtualNamespaceEnum.Create(AnOwner: TBaseVirtualNamespaceExtension;
  EnumFlags: TFolderEnumFlags);
begin
  Owner := AnOwner;
  Flags := EnumFlags
end;

destructor TVirtualNamespaceEnum.Destroy;
begin
  inherited;
end;

function TVirtualNamespaceEnum.Next(celt: ULONG; out rgelt: PItemIDList;
  var pceltFetched: ULONG): HResult;
begin
  if celt > 1 then
    Result := E_FAIL
  else begin
    if Index = 0 then
      rgelt := Owner.EnumFirstChild(Flags)
    else
      rgelt := Owner.EnumNextChild(Flags);

    if Assigned(rgelt) then
    begin
      Inc(FIndex);
      pceltFetched := 1;
      Result := NOERROR
    end else
      Result := S_FALSE
  end
end;

function TVirtualNamespaceEnum.Reset: HResult;
begin
  Result := E_NOTIMPL
end;

function TVirtualNamespaceEnum.Skip(celt: ULONG): HResult;
begin
  Result := E_NOTIMPL
end;

{ THookedPIDLItem }

constructor THookedPIDLItem.Create(APIDL: PItemIDList;
  ANamespaceExtClassID: TGUID; IsHardHooked: Boolean);
begin
  PIDL := PIDLManager.CopyPIDL(APIDL);
  PIDLIDCount := PIDLManager.IDCount(PIDL);
  NamespaceExtClassID := ANamespaceExtClassID;
  HardHooked := IsHardHooked
end;

destructor THookedPIDLItem.Destroy;
begin
  PIDLManager.FreeAndNilPIDL(FPIDL);
  inherited;
end;

{ TVirtualIShellDetails }

function TVirtualIShellDetails.ColumnClick(iColumn: LongWord): HResult;
begin
  Result := E_NOTIMPL
end;

function TVirtualIShellDetails.GetColumnAlignment(
  ColumnIndex: integer): TVirtualColumnAlignment;
begin
  // Return the Alignment of the Details column
  Result := vcaLeft
end;

function TVirtualIShellDetails.GetColumnCount: Cardinal;
begin
  // This is called when the tree needs to display columns in details mode.  The
  // PARENT is called asking how many columns does it children need for details mode
  Result := 1;  // Always have the Name
end;

function TVirtualIShellDetails.GetColumnDetails(ChildPIDL: PItemIDList;
  ColumnIndex: integer): WideString;
begin
  // Return the details for the passed column for the specified child object
  Result := '';
end;

function TVirtualIShellDetails.GetColumnTitle(
  ColumnIndex: integer): WideString;
begin
  // Return the title of the column
  Result := ''
end;

function TVirtualIShellDetails.GetDetailsOf(PIDL: PItemIDList;
  iColumn: LongWord; var data: TShellDetails): HResult;
begin
  FillChar(data, SizeOf(data), #0);
  if not Assigned(PIDL) then
  begin
    if iColumn < GetColumnCount then
    begin
      data.str.uType := STRRET_WSTR;
      data.str.pOleStr := PIDLManager.AllocStrGlobal( GetColumnTitle(iColumn));
      data.cxChar := Length(WideString(data.cxChar));
      data.Fmt := TVirtualColumnAlignmentToLVCFMT( GetColumnAlignment(iColumn));
      Result := NOERROR
    end else
      Result := E_FAIL  // out of columns
  end else
  if iColumn < GetColumnCount then
  begin
    data.str.uType := STRRET_WSTR;
    data.str.pOleStr := PIDLManager.AllocStrGlobal( GetColumnDetails(PIDL, iColumn));
    data.cxChar := Length(GetColumnTitle(iColumn));
    data.Fmt := TVirtualColumnAlignmentToLVCFMT( GetColumnAlignment(iColumn));
    Result := NOERROR
  end else
    Result := E_FAIL  // out of columns
end;

{ TVirtualIContextMenu }

procedure TVirtualIContextMenu.AddMenuItem(Menu: HMenu;
  CommandID: Longword; Text, Verb, Help: WideString);
var
  MenuItem: TVirtualContextMenuItem;
  s: string;
begin
  MenuItem := TVirtualContextMenuItem.Create;
  MenuItem.CommandID := CommandID;
  MenuItem.Verb := Verb;
  MenuItem.Help := Help;
  MenuItemList.Add(MenuItem);
  if IsUnicode then
    InsertMenuW(Menu, 0, MF_BYPOSITION or MF_STRING, CommandID, PWideChar(Text))
  else begin
    s := Text;
    InsertMenuA(Menu, 0, MF_BYPOSITION or MF_STRING, CommandID, PChar(s));
  end;
end;

procedure TVirtualIContextMenu.AddMenuItemDivider(Menu: HMenu);
begin
 if IsUnicode then
    InsertMenuW(Menu, 0, MF_BYPOSITION or MF_SEPARATOR, Longword(-1), '')
  else
    InsertMenuA(Menu, 0, MF_BYPOSITION or MF_SEPARATOR, Longword(-1), '')

end;

function TVirtualIContextMenu.CMF_ToContextMenuFlags(
  Flags: Longword): TContextMenuFlags;
begin
  Result := [];
  if CMF_CANRENAME and Flags <> 0 then
    Include(Result, cmCanRename);
  if CMF_DEFAULTONLY and Flags <> 0 then
    Include(Result, cmDefaultOnly);
  if CMF_EXPLORE and Flags <> 0 then
    Include(Result, cmExplore);
  if CMF_EXTENDEDVERBS and Flags <> 0 then
    Include(Result, cmExtendedVerbs);
  if CMF_INCLUDESTATIC and Flags <> 0 then
    Include(Result, cmIncludeStatic);
  if CMF_NODEFAULT and Flags <> 0 then
    Include(Result, cmNoDefault);
  if CMF_NORMAL and Flags <> 0 then
    Include(Result, cmNormal);
  if CMF_NORMAL and Flags <> 0 then
    Include(Result, cmNormal);
  if CMF_NOVERBS and Flags <> 0 then
    Include(Result, cmNoVerbs);
  if CMF_VERBSONLY and Flags <> 0 then
    Include(Result, cmVerbsOnly);
end;

function TVirtualIContextMenu.CommandString(CommandID: Longword;
  CommandStringType: TCommandStringType; var Command: WideString): Boolean;
var
  Item: TVirtualContextMenuItem;
begin
  Result := False;
  if CommandStringType in [csVerbA, csVerbW] then
  begin
    Item := FindMenuItemByCommandID(CommandID);
    if Assigned(Item) then
    begin
      Command := Item.Verb;
      Result := True
    end
  end else
  if CommandStringType in [csHelpTextA, csHelpTextW] then
  begin
    Item := FindMenuItemByCommandID(CommandID);
    if Assigned(Item) then
    begin
      Command := Item.Help;
      Result := True
    end
  end
end;

constructor TVirtualIContextMenu.Create(AParentPIDL: PItemIDList; APIDLs: TPIDLList);
begin
  inherited;
  MenuItemList := TObjectList.Create;
end;

destructor TVirtualIContextMenu.Destroy;
begin
  MenuItemList.Free;
  inherited;
end;

function TVirtualIContextMenu.FillMenu(Menu: HMenu; FirstItemIndex, ItemIdFirst,
  ItemIDLast: Longword; MenuFlags: TContextMenuFlags): Boolean;
begin
  Result := False;
end;

function TVirtualIContextMenu.FindMenuItemByCommandID(
  CommandID: Longword): TVirtualContextMenuItem;
var
  i: Integer;
begin
  Result := nil;
  i := 0;
  while not Assigned(Result) and (i < MenuItemList.Count) do
  begin
    if CommandID = TVirtualContextMenuItem(MenuItemList[i]).CommandID then
      Result := TVirtualContextMenuItem(MenuItemList[i]);
    Inc(i)
  end
end;

function TVirtualIContextMenu.FindMenuItemByInvokeInfo(
  InvokeInfo: TCMInvokeCommandInfoEx; var InvokedByVerb: Boolean): TVirtualContextMenuItem;
begin
  InvokedByVerb := False;
  if InvokeInfo.fMask and CMIC_MASK_UNICODE <> 0 then
  begin
    // The handler may use MakeIntResource on the Command ID so we need to see
    // if it is the command or a real verb string
    if HiWord( Longword(InvokeInfo.lpVerbW)) <> 0 then
    begin
      Result := FindMenuItemByVerb(InvokeInfo.lpVerbW);
      InvokedByVerb := True
    end else
      Result := FindMenuItemByCommandID(Cardinal(InvokeInfo.lpVerbW) + 1);
  end else
  begin
    if HiWord( Longword(InvokeInfo.lpVerb)) = 0 then
    begin
      Result := FindMenuItemByVerb(InvokeInfo.lpVerb);
      InvokedByVerb := True
    end else
      Result := FindMenuItemByCommandID(Cardinal(InvokeInfo.lpVerb) + 1);
  end;
end;

function TVirtualIContextMenu.FindMenuItemByVerb(
  Verb: WideString): TVirtualContextMenuItem;
var
  i: Integer;
begin
  Result := nil;
  i := 0;
  while not Assigned(Result) and (i < MenuItemList.Count) do
  begin
    if Verb = TVirtualContextMenuItem(MenuItemList[i]).Verb then
      Result := TVirtualContextMenuItem(MenuItemList[i]);
    Inc(i)
  end
end;

function TVirtualIContextMenu.GetCommandString(idCmd, uType: UINT;
  pwReserved: PUINT; pszName: LPSTR; cchMax: UINT): HResult;
var
  CS: WideString;
  S: string;
begin
  CS := '';
  Inc(idCmd);  // Zero based
  Result := S_FALSE;
  if (uType = GCS_VALIDATEA) or (uType = GCS_VALIDATEW) then
  begin
    if CommandString(idCmd, GSC_ToCommandStringType(uType), CS) then
      Result := S_OK
  end else
  begin
    if CommandString(idCmd, GSC_ToCommandStringType(uType), CS) then
    begin
      if (uType = GCS_HELPTEXTW) or (uType = GCS_VERBW) then
        StrLCopyW(PWideChar(pszName), PWideChar(CS), cchMax)
      else begin
        S := CS;
        StrLCopy(PChar(pszName), PChar(S), cchMax)
      end;
      Result := NOERROR
    end
  end
end;

function TVirtualIContextMenu.GSC_ToCommandStringType(
  Flag: Integer): TCommandStringType;
begin
  Result := csVerbA;  // 0 is GCS_VERBA
  if Flag = GCS_HELPTEXTA then
    Result := csHelpTextA
  else
  if Flag = GCS_HELPTEXTW then
    Result := csHelpTextW
  else
  if Flag = GCS_VALIDATEA then
    Result := csValidate
  else
  if Flag = GCS_VALIDATEW then
    Result := csValidate
  else
  if Flag = GCS_VERBW then
    Result := csVerbW
end;

function TVirtualIContextMenu.HandleMenuMsg(uMsg: UINT; WParam,
  LParam: Integer): HResult;
begin
  // Needs to be implemented
  Result := E_NOTIMPL
end;

function TVirtualIContextMenu.HandleMenuMsg2(uMsg: UINT; wParam,
  lParam: Integer; var lpResult: Integer): HResult;
begin
  // Needs to be implemented
  Result := E_NOTIMPL
end;

function TVirtualIContextMenu.Invoke(Window: HWnd; InvokeInfo: TCMInvokeCommandInfoEx): Boolean;
begin
  Result := False;
end;

function TVirtualIContextMenu.InvokeCommand(var lpici: TCMInvokeCommandInfoEx): HResult;
var
  Success: Boolean;
begin
  if lpici.fMask and CMIC_MASK_UNICODE <> 0 then
    Success := Invoke(lpici.hwnd, lpici)
  else
    Success := Invoke(lpici.hwnd, lpici);
  if Success then
    Result := NOERROR
  else
    Result := S_FALSE
end;

function TVirtualIContextMenu.QueryContextMenu(Menu: HMENU; indexMenu,
  idCmdFirst, idCmdLast, uFlags: UINT): HResult;
begin
  if FillMenu(Menu, indexMenu, idCmdFirst, idCmdLast, CMF_ToContextMenuFlags(uFlags)) then
    Result := NOERROR
  else
    Result := E_NOTIMPL
end;

{ TVirtualUIObjects }

constructor TVirtualUIObjects.Create(AParentPIDL: PItemIDList;
  APIDLs: TPIDLList);
begin
  ParentPIDL := PIDLManager.CopyPIDL(AParentPIDL);
  ChildPIDLs := TPIDLList.Create;
  if Assigned(APIDLs) then
    APIDLs.CloneList(ChildPIDLs);
end;

destructor TVirtualUIObjects.Destroy;
begin
  ChildPIDLs.Free;
  PIDLManager.FreeAndNilPIDL(FParentPIDL);
  inherited;
end;

{ TVirtualIDropTarget }

function TVirtualIDropTarget.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  Effect: TVirtualDropEffects;
begin
  DataObject := dataObj;
  Effect := DropEffectToDropEffectType(dwEffect);
  Drag_Enter(DataObj, KeyStateToKeyStateType(grfKeyState), Pt, Effect);
  dwEffect := DropEffectTypeToDropEffect(Effect);
  Result := S_OK
end;

function TVirtualIDropTarget.DragLeave: HResult;
begin
  Drag_Leave;
  DataObject := nil;
  Result := S_OK
end;

function TVirtualIDropTarget.DragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
var
  Effect: TVirtualDropEffects;
begin
  Effect := DropEffectToDropEffectType(dwEffect);
  Drag_Over(KeyStateToKeyStateType(grfKeyState), Pt, Effect);
  dwEffect := DropEffectTypeToDropEffect(Effect);
  Result := S_OK
end;

procedure TVirtualIDropTarget.Drag_Drop(const DataObject: IDataObject;
  KeyState: TVirtualDropKeyStates; Point: TPoint;
  var DropEffect: TVirtualDropEffects);
begin
// This is the point where the OLE subsystem drops the IDataObject onto the
// namespace. Return what occured in the DropEffecct parameter.
// Point is in screen coordinates
  DropEffect := [vdeNone];
end;

procedure TVirtualIDropTarget.Drag_Enter(const DataObject: IDataObject;
  KeyState: TVirtualDropKeyStates; Point: TPoint;
  var DropEffect: TVirtualDropEffects);
begin
// This is the entry point into the namespace when something is dragged over the
// namespace.  You can see if the DataObject contains any useful data to the
// namespace and return what can be allowed in the DropEffecct parameter.
// Point is in screen coordinates
  DropEffect := [vdeNone];
end;

procedure TVirtualIDropTarget.Drag_Leave;
begin
// This is called when the cursor leave the namespace area
end;

procedure TVirtualIDropTarget.Drag_Over(KeyState: TVirtualDropKeyStates;
  Point: TPoint; var DropEffect: TVirtualDropEffects);
begin
// This is called as the cursor is dragged over the namespace. It is called
// many times so don't do a lot of processing here.  Return what occured in the
// DropEffecct parameter. Point is in screen coordinates
// If you need access to the data object that was passed on the Drag_Enter method
// it is stored in the DataObject property during the drag life time
  DropEffect := [vdeNone];
end;

function TVirtualIDropTarget.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  Effect: TVirtualDropEffects;
begin
  Effect := DropEffectToDropEffectType(dwEffect);
  Drag_Drop(DataObj, KeyStateToKeyStateType(grfKeyState), Pt, Effect);
  dwEffect := DropEffectTypeToDropEffect(Effect);
  DataObject := nil;
  Result := S_OK
end;

{ TVirtualIQueryInfo }

function TVirtualIQueryInfo.GetInfoFlags(out pdwFlags: DWORD): HResult;
begin
  // Not currently used
  Result := E_NOTIMPL
end;

function TVirtualIQueryInfo.GetInfoTip(dwFlags: DWORD;
  var ppwszTip: PWideChar): HResult;
begin
  ppwszTip := PWideChar(GetQueryInfoTip);
  Result := NOERROR
end;

function TVirtualIQueryInfo.GetQueryInfoTip: WideString;
begin
// Return the string to be displayed in the popup hint windows in Win98 and up.
  Result := '';
end;

{ TVirtualIExtractIconW }

function TVirtualIExtractIconW.Extract(pszFile: PWideChar;
  nIconIndex: UINT; out phiconLarge, phiconSmall: HICON;
  nIconSize: UINT): HResult;
begin
  Result := S_FALSE
end;

function TVirtualIExtractIconW.GetIconLocation(uFlags: UINT;
  szIconFile: PWideChar; cchMax: UINT; out piIndex: Integer;
  out pwFlags: UINT): HResult;
begin
  Result := S_FALSE
end;

{ TVirtualIExtractIconA }

function TVirtualIExtractIconA.Extract(pszFile: PAnsiChar;
  nIconIndex: UINT; out phiconLarge, phiconSmall: HICON;
  nIconSize: UINT): HResult;
begin
  Result := S_FALSE
end;

function TVirtualIExtractIconA.GetIconLocation(uFlags: UINT;
  szIconFile: PAnsiChar; cchMax: UINT; out piIndex: Integer;
  out pwFlags: UINT): HResult;
begin
  Result := S_FALSE
end;

initialization
  PIDLManager := TPIDLManager.Create;

finalization
  NamespaceExtFactory.Free;
  PIDLManager.Free;

end.
