unit VirtualShellUtilities;

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
//
//  Credits for valuable information and code gathered from newsgroups and
//  websites:
//      Angus Johnson for his GetDiskFreeSpaceFAT32 function from UNDO
//
//----------------------------------------------------------------------------
//
//      THINGS TODO:
//      - The children of History will show up as "MSHist0133435509090" type Strings
//        when using IShellDetails or IShellFolder2, don't know why.
//      - There are a few areas that are not Unicode compliant they include the following
//        functions:
//            ConvertLocalStrToTFileTime();
//            ConvertTFileTimeToLocalStr();
//            Format
//            AnsiUpperCase
//        The main place these exist are if details are being used in VETColumns or
//        User defined columns.  The ShellColumns mode get the details from the shell
//        so they are already Unicode (if running under NT)
//        Case conversion requires a lot of overhead to be pulled in from Mikes Unicode
//        unit so that is why it is not been inplemented.
//      - Implement a "Quiet" flag so context menu actions can be done without the confimation dialogs (CMInvokeCommandInfoEx)
//
// History
//
// 08.31.02
//      - Going to try to allow the Parent to persist if the namespace creates it itself.
//        This is called a LOT more than I though expecially for the ExplorerListview
//
// 7.05.02
//      - Dymamiclly loaded SHGetDataFromIDListW for Win95 compatibility
//
// 2.07.02
//      - Changed the name of the System property to SystemFile do to strange conficts
//        with the "System" unit
//
// 1.23.02
//      - Cleaned up the unit, added more comments, orginized the interface section
//        better.  Eliminated rarely used cache entries for a 30% decrease in
//        a total instance size of TNamespace.
//      - Moved the ShellLink object into the unit to be used in TNamespace to reduce
//        size of TNamespace
//
// 1.22.02
//      - Removed 6 Boolean fields in TNamespace and converted them to a set.
//        Reduces the footprint of a TNamespace object by 4 bytes x 5 fields = 20 bytes!
//
// 12.08.01
//      - Added XP to the special check when enumerating the Scanners and Cameras
//        namespace.  It appears M$ took this directly from ME, bugs and all.
//
// 12.04.01
//      - Updated symbols with the $EXTERNALSYM directive to help out BCB users
//
// 11.09.01
//      - Moved TStreamableClass from VirtualExplorerTree.pas to VirtualShellUtilities.pas
//
// 10.28.01
//      - Added full support for the IShellLink methods to TNamespace
//
// 10.15.01
//      - Moved the ThreadNotifyThread and associated classes to VirtualShellUtilities.
//        This move allows other components to use the Thread, such as the
//        TShellToolbar, and TDriveToolbar. Reworked the registration and
//        creation/deletion aspects of it.  Now to register a window (not just a VET)
//        with it use the new global function in Shell Utilities:
//           procedure RegisterShellNotifyControl(Control: TWinControl);
//           procedure UnRegisterShellNotifyControl(Control: TWinControl);
//        then respond to the WM_SHELLNOTIFY message.
//
//----------------------------------------------------------------------------


interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ImgList, ShlObj, ShellAPI, ActiveX, Registry, Menus,
  {$IFDEF COMPILER_6_UP}
  Variants,
  {$ENDIF}
  VirtualResources, VirtualUtilities, VirtualShellTypes,
  {$IFDEF VIRTUALNAMESPACES} VirtualNamespace, {$ENDIF}
  VirtualPIDLTools, VirtualUnicodeDefines;

const
  DefaultDetailColumns = 5;

  ID_TIMER_NOTIFY = 100;
  ID_TIMER_ENUMBKGND = 101;
  ID_TIMER_AUTOSCROLL = 102;
  ID_TIMER_SHELLNOTIFY = 103;


  {$EXTERNALSYM SHCONTF_INIT_ON_FIRST_NEXT}
  SHCONTF_INIT_ON_FIRST_NEXT = $0100;   // allow EnumObject() to return before validating enum")
  {$EXTERNALSYM SHCONTF_NETPRINTERSRCH}
  SHCONTF_NETPRINTERSRCH     = $0200;   // hint that client is looking for printers")
  {$EXTERNALSYM SHCONTF_SHAREABLE}
  SHCONTF_SHAREABLE          = $0400;   // hint that client is looking sharable resources (remote shares)")
  {$EXTERNALSYM SHCONTF_STORAGE}
  SHCONTF_STORAGE            = $0800;   // include all items with accessible storage and their ancestors")

  {$EXTERNALSYM SFGAO_CAPABILITYMASK}
  SFGAO_CAPABILITYMASK = $00000177;
  {$EXTERNALSYM SFGAO_DISPLAYATTRMASK}
  SFGAO_DISPLAYATTRMASK =  $000FC000;
  {$EXTERNALSYM SFGAO_CONTENTSMASK}
  SFGAO_CONTENTSMASK = $80000000;
  {$EXTERNALSYM SFGAO_STORAGECAPMASK}
  SFGAO_STORAGECAPMASK = $70C50008;

  SHORTCUT_ICON_INDEX = 29;  // This is cheezy crappy stupid and dumb but
                             // I can't find a way to get the link index

  SHELL_NAMESPACE_ID = -1;   // ID of a basic Shell Namespace based TNamespace

  SHGDN_FOREDITING = $1000;

  DEFAULTPIDLARRAYSIZE = 8192;     // Default size for the TPIDLArray

  STREAM_VERSION_DEFAULT = -1;  // Default Stream version for TStreamableClass.LoadFromStream
                                // if this value is seen the LoadFromStream method should read the version
                                // from the stream else it should use the passed version in the method

  STR_IMAGE_THREAD_EVENT = 'jdkImageThreadEvent';

  VET_DEFAULT_COLUMNWIDTHS: array[0..36] of integer = (
    180,                // Name
    96,                 // Size
    120,                // Type
    120,                // Modified
    60,                 // Attributes
    180,                // Comment
    120,                // Created
    120,                // Accessed
    120,                // Owner
    120,                // Author
    120,                // Title
    120,                // Subject
    120,                // Catagory
    60,                 // Pages
    120,                // Copywrite
    120,                // Company Name
    120,                // Module Description
    120,                // Module Version
    120,                // Product Name
    120,                // Product Version
    72,                 // Sender Name
    90,                 // Recipient Name
    102,                // Recipient Number
    30,                 // Csid
    30,                 // Tsid
    108,                // Transmission Time
    60,                 // Caller ID
    48,                 // Routing
    180,                // Audio Format
    180,                // Sample Rate
    180,                // Audio Sample Size
    180,                // Channels
    180,                // Play Length
    180,                // Frame Count
    180,                // Frame Rate
    180,                // Video Sample Size
    180                 // Video Compression
  );

  VET_DEFAULT_DRIVES_COLUMNWIDTHS: array[0..3] of integer = (
    180,                // Name
    120,                // Type
    96,                 // Total Size
    96                  // Free Space
  );

  VET_DEFAULT_CONTROLPANEL_COLUMNWIDTHS: array[0..1] of integer = (
    180,                // Name
    300                 // Description
  );

  VET_DEFAULT_NETWORK_COLUMNWIDTHS: array[0..1] of integer = (
    180,                // Name
    300                 // Description
  );


{-------------------------------------------------------------------------------}
{ Custom enumerated types                                                       }
{-------------------------------------------------------------------------------}

type
  TDefaultFolderIcon = (
    diNormalFolder,        // Retrieve the index for a normal file folder icon
    diOpenFolder,          // Retrieve the index for a normal file folder icon in the open state
    diUnknownFile,         // Retrieve the index for an icon for a file that has no association
    diLink,                // Retrieve the index for link overlay icon
    diMyDocuments          // Index of MyDocuments icon
  );

type
  TNamespaceState = (
    nsFreePIDLOnDestroy,      // If true the object free the PIDL with the system allocator when freed
    nsIsRecycleBin,           // Recyclebin does not cooperate very well so we have do extra checks for various reasons so cache this
    nsRecycleBinChecked,      // Flag to see if above is valid.
    nsOwnsParent,             // If a namespace is created from a complex PIDL for some methods the parent is needed.  If so a Parent namespace is created so this instance owns it and must free it.
    nsShellDetailsSupported,  // Instead of a costly call to see if interface exists when it does not we only check once then cache the result
    nsShellFolder2Supported,  // Same idea as ShellDetailsSupported, if it does not exist don't waste time constantly checking
    nsShellOverlaySupported,  // Same idea as ShellDetailsSupported, if it does not exist don't waste time constantly checking
    nsThreadedIconLoaded,     // To keeping the threaded icon option fast and interuptable need to track if a thread it currently trying to extract an image index for the namespace, Threaded image is retrieved
    nsThreadedIconLoading,    // To keeping the threaded icon option fast and interuptable need to track if a thread it currently trying to extract an image index for the namespace, it is in the queue to be retieved
    nsThreadedImageLoaded,     // To keeping the threaded icon option fast and interuptable need to track if a thread it currently trying to extract an image index for the namespace, Threaded image is retrieved
    nsThreadedImageLoading,    // To keeping the threaded icon option fast and interuptable need to track if a thread it currently trying to extract an image index for the namespace, it is in the queue to be retieved
    nsThreadedTileInfoLoaded,   // To keeping the threaded Tile Info option fast and interuptable need to track if a thread it currently trying to extract Tile Info for the namespace, Threaded Tile Info is retrieved
    nsThreadedTileInfoLoading,  // To keeping the threaded Tile Info option fast and interuptable need to track if a thread it currently trying to extract Tile Info for the namespace, it is in the queue to be retieved
    nsIconIndexChanged        // Sets a flag to track when the IconIndex changed between calls to GetIconIndex.  Usually caused by a Thread Setting the icon index
  );
  TNamespaceStates = set of TNamespaceState;

  TWideStringDynArray = array of WideString;
  TIntegerDynArray = array of Integer;

type
  TSHLimitInputEdit = function(hWndEdit: HWND; psf: IShellFolder): HRESULT; stdcall;

  TShellCache = set of (     // Valid entries in the Namespace data cache
    scInFolderName,
    scNormalName,
    scParsedName,
    scSmallIcon,
    scSmallOpenIcon,
    scOverlayIndex,
    scCreationTime,
    scLastAccessTime,
    scLastWriteTime,
    scFileSize,
    scFileSizeKB,
    scFileSizeInt64,
    scFileType,
    scInvalidIDListData,   // If SHGetDataFromIDList fails flag it so we won't try again.
    scFileSystem,
    scFolder,
    scCanDelete,
    scCanRename,
    scGhosted,
    scCanCopy,
    scCanMove,
    scCanLink,
    scLink,
    scFileSysAncestor,
    scCompressed,
    scFileTimes,
    scSupportedColumns,
    scFolderSize,            // Recursivly calculated size of folder contents
    scVirtualHook,           // Namespace is the invisible parent of the RootVirtualNamespace
    scHookedNamespace,       // Namespace has custom sub items injected through SubFolderHook property
    scVirtualNamespace,      // Namespace is a virtual namespace
    scRootVirtualNamespace,  // Namespace is the Root of the Custom Namespace Branch. If a real NS is hooked it is the namespace under the caSubItemHook namespace
    scHardHookedNamespace    // Namespace is a hard hooked, this means it will show user defined details if defined instead of using the real namespaces parent to create the details
    );

{ This stores the state of the cached folder attribute.                         }
  TCacheAttributes = set of (
    caFileSystem,      // Namespace is part of the file system
    caFolder,          // Namespace is a Folder (not necessarily a directory)
    caCanDelete,       // Namespace can be deleted
    caCanRename,       // Namespace can be renamed
    caGhosted,         // Namespace is should display a ghosted icon
    caCanCopy,         // Namespace can be copied
    caCanMove,         // Namespace can be moved to a different location
    caCanLink,         // Namespace can create a link to itself
    caLink,            // Namespace *is* a link
    caFileSysAncestor, // Namespace is an ancestor of a file system namespace
    caCompressed,      // Namespace represents a compressed folder
    caVirtualHook,           // Namespace is the invisible parent of the RootVirtualNamespace
    caHookedNamespace,       // Namespace has custom sub items injected through SubFolderHook property
    caVirtualNamespace,      // Namespace is a virtual namespace
    caRootVirtualNamespace,  // Namespace is the Root of the Custom Namespace Branch. If a real NS is hooked it is the namespace under the caSubItemHook namespace
    caHardHookedNamespace    // Namespace is a hard hooked, this means it will show user defined details if defined instead of using the real namespaces parent to create the details
    );

  { Used in IShellFolder2.GetDefaultColumnState }
  TSHColumnState = (
    csTypeString,     // A string.
    csTypeInt,        // An integer.
    csTypeDate,       // A date.
    csOnByDefault,    // Should be shown by default in the Microsoft® Windows® Explorer Details view.
    csSlow,           // Extracting information about the column can be time consuming.
    csExtended,       // Provided by a handler, not the folder object.
    csSecondaryUI,    // Not displayed in the context menu, but listed in the More dialog box.
    csHidden          // Not displayed in the user interface.
  );
  TSHColumnStates = set of TSHColumnState;

  THotKeyModifier = (      // For IShellLink
    hkmAlt,                // HOTKEYF_ALT
    hkmControl,            // HOTKEYF_CONTROL
    hkmExtendedKey,        // HOTKEYF_EXT
    hkmShift               // HOTKEYF_SHIFT
  );
  THotKeyModifiers = set of THotKeyModifier;

  TCmdShow = (           // For IShellLink
    swHide,              // Hides the window and activates another window.
    swMaximize,          // Maximizes the specified window.
    swMinimize,          // Minimizes the specified window and activates the next top-level window in the Z order.
    swRestore,           // Activates and displays the window. If the window is minimized or maximized, Windows restores it to its original size and position. An application should specify this flag when restoring a minimized window.
    swShow,              // Activates the window and displays it in its current size and position.
    swShowDefault,       // Sets the show state based on the SW_ flag specified in the STARTUPINFO structure passed to the CreateProcess function by the program that started the application.
    swShowMinimized,     // Activates the window and displays it as a minimized window.
    swShowMinNoActive,   // Displays the window as a minimized window. The active window remains active.
    swShowNA,            // Displays the window in its current state. The active window remains active.
    swShowNoActive,      // Displays a window in its most recent size and position. The active window remains active.
    swShowNormal         // Activates and displays a window. If the window is minimized or maximized, Windows
  );                     //    restores it to its original size and position. An application should specify this flag
                         //    when displaying the window for the first time.

  TIconSize = (
    icSmall,             // Small Shell size icon, usually 16x16
    icLarge              // Large TListview size Icon, usually 32x32
  );

  TFileSort = (       // Used in the ShellSortHelper class
    fsFileType,       // Sort by the File Type name
    fsFileExtension   // Sort by the file extenstion
  );


  TObjectDescription = ( // Return from SHGetDataFromIDList with SHGDFIL_DESCRIPTIONID param
    odError,          // The call Failed for some reason
    odRootRegistered, // The item is a registered item on the desktop.
    odFile,           // The item is a file.
    odDirectory,      // The item is a folder.
    odUnidentifiedFileItem, // The item is an unidentified item in the file system.
    od35Floppy,       // The item is a 3.5-inch floppy drive.
    od525Floppy,      // The item is a 5.25-inch floppy drive.
    odRemovableDisk,  // The item is a removable disk drive.
    odFixedDrive,     // The item is a fixed disk drive.
    odMappedDrive,    // The item is a drive that is mapped to a network share.
    odCDROMDrive,     // The item is a CD-ROM drive.
    odRAMDisk,        // The item is a RAM disk.
    odUnidentifiedDevice, // The item is an unidentified system device.
    odNetworkDomain,  // The item is a network domain.
    odNetworkServer,  // The item is a network server.
    odNetworkShare,   // The item is a network share.
    odNetworkRestOfNet, // Not currently used.
    odUnidentifiedNetwork, // The item is an unidentified network resource.
    odComputerImaging, // Not currently used.
    odComputerAudio,   // Not currently used.
    odShareDocuments  // The item is the system shared documents folder.
  );

  TDetailsColumnTitleInfo = (
    tiCenterAlign,      // The header title is Center Aligned
    tiLeftAlign,        // The header title is Left Aligned
    tiRightAlign,       // The header title is Right Aligned
    tiContainsImage     // The header title is Contains an Image (were do you get the image???)
  );


 { Selects what type of namespaces are enumerated and displayed in VET.          }
  TFileObjects = set of (
    foFolders,
    foNonFolders,
    foHidden,
    foShareable,
    foNetworkPrinters
  );

{-------------------------------------------------------------------------------}


{-------------------------------------------------------------------------------}
{ Custom Data structures                                                        }
{-------------------------------------------------------------------------------}

type
  TNamespace = class;       // Forward
  TExtractImage = class;    // Forward

  TMenuItemIDArray = array of cardinal;

  TVisibleColumnIndexArray = array of Word; // Array of the column indexes that are currently visible for a namespace

{ Array that contains the cached information for the folder.                    }

  TCacheData = packed record
    Attributes: TCacheAttributes;  // Boolean attributes for the namespace are saved as bits
    SmallIcon,                     // Index in the ShellImageList of the normal icon
    SmallOpenIcon: integer;        // Index in the ShellImageList of the open or selected icon
    InFolderName,                  // InFolder display name for the namespace
    NormalName,                    // Normal display name for the namespace
    ParsedName,                    // The Path of the namespace if it is a file object, if not it is usually the same as NameNormal
    CreationTime,                  // String of the object creation time in details mode
    LastAccessTime,                // String of the last accessed time in details mode
    LastWriteTime,                 // String of the last write time in details mode
    FileSize,                      // String of the file size "23,0000"
    FileSizeKB,                    // String of the file size ala Explorer style i.e. "23 KB"
    FileType: WideString;          // @@@@ FileType shown in Explorer details mode
    FileSizeInt64: Int64;          // Actual File Size
    SupportedColumns: integer;     // Number of supported columns in details mode
    FolderSize: Int64;             // Recursivly calcuated size of folder contents
    OverlayIndex,                  // Cache the Index of the Overlay
    OverlayIconIndex: Integer      // Cache the Index of the Overlay Icon
  end;

{ Cache record tracks which information in the Data structure is valid with the }
{ ShellCacheFlags.                                                              }

  TShellCacheRec = packed record
    ShellCacheFlags: TShellCache;     // If flag is set the corresponding data stored in Data is valid
    Data: TCacheData;                 // Cached data for fast retrieval
  end;

  PSHGetFileInfoRec = ^TSHGetFileInfoRec;
  TSHGetFileInfoRec = packed record
    FileType: WideString;             // Holds the File Type column detail if not using ShellColumns (using VET or custom columns)
  end;

  TPIDLArray = array of PItemIDList;
  TRelativePIDLArray = TPIDLArray;
  TAbsolutePIDLArray = TPIDLArray;
  TNamespaceArray = array of TNamespace;

{-------------------------------------------------------------------------------}


// Custom Exceptions
  EVSTInvalidFileName = class(Exception)
  end;

{-------------------------------------------------------------------------------}
{ Persistent Storing and Recreating VET                                         }
{-------------------------------------------------------------------------------}

  TStreamableClass = class(TPersistent)
  private
    FStreamVersion: integer;
  public
    constructor Create;
    procedure LoadFromFile(FileName: WideString; Version: integer = 0; ReadVerFromStream: Boolean = False); virtual;
    procedure LoadFromStream(S: TStream; Version: integer = 0; ReadVerFromStream: Boolean = False); virtual;
    procedure SaveToFile(FileName: WideString; Version: integer = 0; ReadVerFromStream: Boolean = False); virtual;
    procedure SaveToStream(S: TStream; Version: integer = 0; WriteVerToStream: Boolean = False); virtual;

    property StreamVersion: integer read FStreamVersion;
  end;

  TStreamableList = class(TList)
  private
    FStreamVersion: integer;
  public
    constructor Create;
    procedure LoadFromFile(FileName: WideString; Version: integer = 0; ReadVerFromStream: Boolean = False); virtual;
    procedure LoadFromStream(S: TStream; Version: integer = 0; ReadVerFromStream: Boolean = False); virtual;
    procedure SaveToFile(FileName: WideString; Version: integer = 0; ReadVerFromStream: Boolean = False); virtual;
    procedure SaveToStream(S: TStream; Version: integer = 0; WriteVerToStream: Boolean = False); virtual;

    property StreamVersion: integer read FStreamVersion;
  end;
{-------------------------------------------------------------------------------}


{-------------------------------------------------------------------------------}
{ Our own COM like referenced classes                                           }
{-------------------------------------------------------------------------------}

  TReferenceCounted = class
  protected
    FRefCount: integer;
  public
    procedure AddRef;
    procedure Release;
  end;

{ Reference counted TList, much like a COM object but the compiler does not     }
{ add the AddRef and Release call automaticlly.                                 }
  TReferenceCountedList = class(TList)
  protected
    FRefCount: integer;
  public
    procedure AddRef;
    procedure Release;
    property RefCount: integer read FRefCount;
  end;

{-------------------------------------------------------------------------------}
{ Encapsulates IExtractImage, ASCI and Unicode                                  }
{-------------------------------------------------------------------------------}

  TExtractImage = class
  private
    FFlags: Longword;          // Sets how the image is to be handled see IEIFLAG_xxxx
    FPriority: Longword;       // Returns from GetLocation call the priority if IEIFLAG_ASYNC is used above
    FHeight: Longword;         // Desired image height
    FWidth: Longword;          // Desired image Width
    FColorDepth: Longword;     // Desired color depth
    FExtractImageInterface: IExtractImage;    // The interface
    FExtractImage2Interface: IExtractImage2;  // The interface for image2
    FOwner: TNamespace;                       // The Owner namespace
    FPathExtracted: Boolean;
    function GetImage: TBitmap;
    function GetImagePath: WideString;
    function GetExtractImageInterface: IExtractImage;
    function GetExtractImageInterface2: IExtractImage2;
  protected
    property PathExtracted: Boolean read FPathExtracted write FPathExtracted;
  public
    constructor Create;
    property ColorDepth: Longword read FColorDepth write FColorDepth;
    property ImagePath: WideString read GetImagePath;
    property Image: TBitmap read GetImage;
    property ExtractImageInterface: IExtractImage read GetExtractImageInterface;
    property ExtractImage2Interface: IExtractImage2 read GetExtractImageInterface2;
    property Flags: Longword read FFlags write FFlags;
    property Height: Longword read FHeight write FHeight;
    property Owner: TNamespace read FOwner write FOwner;
    property Priority: Longword read FPriority;
    property Width: Longword read FWidth write FWidth;
  end;
{-------------------------------------------------------------------------------}

{-------------------------------------------------------------------------------}
{ Encapsulates IShellLink, ASCI and Unicode                                     }
{-------------------------------------------------------------------------------}

  TVirtualShellLink = class(TComponent)
  private
    FFileName: WideString;            // File name of the lnk file
    FShellLinkA: IShellLink;           // ShellLink interface
    FShellLinkW: IShellLinkW;         // ShellLinkW interface
    FIconIndex: integer;              // Index of the icon to be used with the link
    FTargetIDList: PItemIDList;       // If the Target is a virtual object the PIDL is the only way to make the link
    FShowCmd: TCmdShow;               // How to show the window of the target application
    FHotKeyModifiers: THotKeyModifiers;  // The key modifiers for short cuts
    FTargetPath: WideString;          // The target that will be executed
    FArguments: WideString;           // Any arguments to be passed to the target
    FDescription: WideString;         // A description that will be shown in the properties dialog
    FWorkingDirectory: WideString;    // The directory the target application will have set as its current directory
    FIconLocation: WideString;        // The file that has the icon for the link
    FHotKey: Word;                    // The HotKey to execute the link, used with the FHotKeyModifiers
    FSilentWrite: Boolean;            // Do not check parameters before writing lnk file and show a warning
    function GetShellLinkAInterface: IShellLinkA;
    function GetShellLinkWInterface: IShellLinkW;
  protected
    procedure FreeTargetIDList;

  public
    destructor Destroy; override;
    function ReadLink(LinkFileName: WideString): Boolean;
    function WriteLink(LinkFileName: WideString): Boolean;

    property Arguments: WideString read FArguments write FArguments;
    property Description: WideString read FDescription write FDescription;
    property FileName: WideString read FFileName write FFileName;
    property HotKey: Word read FHotKey write FHotKey;
    property HotKeyModifiers: THotKeyModifiers read FHotKeyModifiers write FHotKeyModifiers;
    property IconIndex: integer read FIconIndex write FIconIndex;
    property IconLocation: WideString read FIconLocation write FIconLocation;
    property TargetIDList: PItemIDList read FTargetIDList write FTargetIDList;
    property ShellLinkAInterface: IShellLink read GetShellLinkAInterface;
    property ShellLinkWInterface: IShellLinkW read GetShellLinkWInterface;
    property ShowCmd: TCmdShow read FShowCmd write FShowCmd; // SW_XXXX contants
    property SilentWrite: Boolean read FSilentWrite write FSilentWrite;
    property TargetPath: WideString read FTargetPath write FTargetPath;
    property WorkingDirectory: WideString read FWorkingDirectory write FWorkingDirectory;
  end;
{-------------------------------------------------------------------------------}

  // General helper class to sort Shell related objects.  Uses mainly to sort
  // columns in details mode
  TShellSortHelper = class
  private
    FFileSort: TFileSort;  // Defines if SortType sorts by the type string or the file extension
  public
    function CompareIDSort(SortColumn: integer; NS1, NS2: TNamespace): Integer; virtual;
    function DiscriminateFolders(NS1, NS2: TNamespace): Integer; virtual;
    function SortFileSize(NS1, NS2: TNamespace): Integer; virtual;
    function SortFileTime(FT1, FT2: TFileTime; NS1, NS2: TNamespace): Integer; virtual;
    function SortString(S1, S2: WideString; NS1, NS2: TNamespace): Integer; virtual;
    function SortType(NS1, NS2: TNamespace): Integer; virtual;

    property FileSort: TFileSort read FFileSort write FFileSort;
  end;
{-------------------------------------------------------------------------------}
{ Function definitions                                                          }
{-------------------------------------------------------------------------------}

  // Return True if VT adds a node to the tree this keeps the item count returned
  // by TNamespace.EnumFolder correct.  To stop the enumeration set Terminate to true
  TEnumFolderCallback = function(MessageWnd: HWnd; APIDL: PItemIDList; AParent: TNamespace;
    Data: Pointer; var Terminate: Boolean): Boolean of object;

  TContextMenuCmdCallback = procedure(Namespace: TNamespace; Verb: WideString;
    MenuItemID: Integer;  var Handled: Boolean) of object;
  TContextMenuShowCallback = procedure(Namespace: TNamespace; Menu: hMenu;
    var Allow: Boolean) of object;
  TContextMenuAfterCmdCallback = procedure(Namespace: TNamespace; Verb: WideString;
    MenuItemID: Integer; Successful: Boolean) of object;
{-------------------------------------------------------------------------------}


{-------------------------------------------------------------------------------}
{ TNamespace, encapsulates the Windows Shell Namespace                          }
{-------------------------------------------------------------------------------}

  { TNamespace is a class that encapsulates the IShellFolder interface.  It     }
  { simplifies shell interfaces by hiding the overhead of PIDLs and COM.        }
  { Most properties and methods have a direct corrolation to the functions      }
  { exposed by IShellFolder.                                                    }

  TNamespace = class
  private
    FAbsolutePIDL: PItemIDList;            // The Absolute PIDL of that represents the namespace
    FCurrentContextMenu: IContextMenu;     // The basic interface to create a shell context menu, need to save because of ownerdraw callbacks (maybe this one is not necessary IContextMenu2 only supports this)
    FCurrentContextMenu2: IContextMenu2;   // Extends the context menu interface to include ownerdraw items, need to save because of ownerdraw callbacks
    FDropTargetInterface: IDropTarget;     // Interface to handle a drag Drop on the namespace
    FExtractImage: TExtractImage;          // Encapsulate the seldom used IExtractImage inteface saving memory allocation in the TNamespace when not used
    FImage: TBitmap;                       // The image extracted from the IExtractImage interface
    FNamespaceID: integer;                 // ID of the namespace. Used to pick out any custom namespace objects from real shell supplied ones
    FOldWndProcForContextMenu: TWndMethod; // OldWndProc of the ContextMenu owner used in InternalShowContextMenu
    FParent: TNameSpace;                   // The parent of this namespace, may be owned by this decenant see OwnsParent property
    FRelativePIDL: PItemIDList;            // The relative PILD that can be used the the ParentNamespace.  It is a pointer to the last ID of of AbsolutePILD so *don't* free it
    FShellDetailsInterface: {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF}; // Interface to deal with the information in the columns in details view (superceded by IShellFolder2 )
    FShellFolder: IShellFolder;            // IShellFolder is the building block interface that defines the namespaces attributes
    FShellFolder2: IShellFolder2;          // Expands IShellFolder handling the column details in Details mode, only works on Win2k-WinMe and up
    FShellIconInterface: IShellIcon;       // Interface to extract only the index of the icon in the system imagelist
    FShellLink: TVirtualShellLink;         // Object to read and write attributes to shortcut namespaces (files)
    FSHGetFileInfoRec: PSHGetFileInfoRec;  // Stores cached info from a call to SHGetFileInfo(A or W)
    FStates: TNamespaceStates;             // Dynamic state of the TNamespace
    FTag: integer;
    FTileDetail: TIntegerDynArray; //
    FQueryInfoInterface: IQueryInfo;       // Interface for the popup InfoTips on folders in Win2k-WinME and up
    FWin32FindDataA: PWin32FindDataA;      // pointer to an allocated structure for an ASCI window file information if is is a file object
    FWin32FindDataW: PWin32FindDataW;      // pointer to an allocated structure for an Unicode window file information if is is a file object
    FSystemIsSuperHidden: Boolean;         // Holds the result of if the system has the SuperHiddenFile flag set in the registry
    FShellIconOverlayInterface: IShellIconOverlay;
    FCategoryProviderInterface: ICategoryProvider;
    FBrowserFrameOptionsInterface: IBrowserFrameOptions;
    FQueryAssociationsInterface: IQueryAssociations;

    {$IFDEF VIRTUALNAMESPACES}
    FShellFolderHook: IShellFolder;
    function GetIsHookedNamespace: Boolean;
    function GetIsRootVirtualNamespace: Boolean;
    function GetIsVirtualHook: Boolean;
    function GetIsVirtualNamespace: Boolean;
    function GetIsHardHookedNamespace: Boolean;
    {$ENDIF}

    function GetBrowsable: Boolean;
    function GetCLSID: TGUID;
    function GetContextMenuInterface: IContextMenu;
    function GetContextMenu2Interface: IContextMenu2;
    function GetContextMenu3Interface: IContextMenu3;
    function GetCreationDateTime: TDateTime;
    function GetDataObjectInterface: IDataObject;
    function GetDescription: TObjectDescription;
    function GetDetailsSupported: Boolean;
    function GetDropTargetInterface: IDropTarget;
    function GetExtractIconAInterface: IExtractIconA;
    function GetExtractIconWInterface: IExtractIconW;
    function GetExtractImage: TExtractImage;
    function GetFreePIDLOnDestroy: Boolean;
    function GetIconIndexChanged: Boolean;
    function GetLastAccessDateTime: TDateTime;
    function GetLastWriteDateTime: TDateTime;
    function GetParentShellDetailsInterface: {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF};
    function GetParentShellFolder2: IShellFolder2;
    function GetQueryInfoInterface: IQueryInfo;
    function GetShellDetailsInterface: {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF};
    function GetShellIconInterface: IShellIcon;
    function GetShellFolder: IShellFolder;
    function GetShellFolder2: IShellFolder2;
    function GetShellLink: TVirtualShellLink;
    function GetSubFolders: Boolean;
    function GetThreadedIconLoaded: Boolean;
    function GetThreadIconLoading: Boolean;
    procedure SetFreePIDLOnDestroy(const Value: Boolean);
    procedure SetIconIndexChanged(const Value: Boolean);
    procedure SetThreadIconLoading(const Value: Boolean);
    function GetThreadedImageLoaded: Boolean;
    function GetThreadedImageLoading: Boolean;
    procedure SetThreadImageLoading(const Value: Boolean);
    function GetShellIconOverlayInterface: IShellIconOverlay;
    function GetOverlayIconIndex: Integer;
    function GetOverlayIndex: Integer;
    function GetCanMoniker: Boolean;
    function GetEncrypted: Boolean;
    function GetHasStorage: Boolean;
    function GetIsSlow: Boolean;
    function GetStorage: Boolean;
    function GetStorageAncestor: Boolean;
    function GetStream: Boolean;
    function GetCategoryProviderInterface: ICategoryProvider;
    function GetCategoryAlphabetical: ICategorizer;
    function GetCategoryDriveSize: ICategorizer;
    function GetCategoryDriveType: ICategorizer;
    function GetCategoryFreeSpace: ICategorizer;
    function GetCategorySize: ICategorizer;
    function GetCategoryTime: ICategorizer;
    function GetBrowserFrameOptionsInterface: IBrowserFrameOptions;
    function GetQueryAssociationsInterface: IQueryAssociations;
    function GetValid: Boolean;

  protected
    { Make the Cache Data and property getters available to decendants. This    }
    { will allow decendants of TNamespace to be created so "virtual namespaces" }
    { can be created.  It is possible to create a "namespace extension" without }
    { really doing it!                                                          }
    { None of interface properties are here because they only make sense for    }
    { actual COM namespaces.                                                    }
    FShellCache: TShellCacheRec;

    { Virtual Property Setters }
    function GetArchive: Boolean; virtual;
    function GetAttributesString: WideString; virtual;
    function GetCanCopy: Boolean; virtual;
    function GetCanDelete: Boolean; virtual;
    function GetCanLink: Boolean; virtual;
    function GetCanMove: Boolean; virtual;
    function GetCanRename: Boolean; virtual;
    function GetCompressed: Boolean; virtual;
    function GetCreationTime: WideString; virtual;
    function GetCreationTimeRaw: TFileTime; virtual;
    function GetDirectory: Boolean; virtual;
    function GetDropTarget: Boolean; virtual;
    function GetExtension: WideString; virtual;
    function GetFileName: WideString; virtual;
    function GetFileSysAncestor: Boolean; virtual;
    function GetFileSystem: Boolean; virtual;
    function GetFileType: WideString; virtual;
    function GetFolder: Boolean; virtual;
    function GetGhosted: Boolean; virtual;
    function GetHasPropSheet: Boolean; virtual;
    function GetHasSubFolder: Boolean; virtual;
    function GetHidden: Boolean; virtual;
    function GetInfoTip: WideString; virtual;
    function GetLastAccessTime: WideString; virtual;
    function GetLastAccessTimeRaw: TFileTime; virtual;
    function GetLastWriteTime: WideString; virtual;
    function GetLastWriteTimeRaw: TFileTime; virtual;
    function GetLink: Boolean; virtual;
    function GetNameAddressbar: WideString; virtual;
    function GetNameAddressbarInFolder: WideString; virtual;
    function GetNameForEditing: WideString; virtual;
    function GetNameForEditingInFolder: WideString; virtual;
    function GetNameForParsing: WideString; virtual;
    function GetNameForParsingInFolder: WideString; virtual;
    function GetNameInFolder: WideString; virtual;
    function GetNameNormal: WideString; virtual;
    function GetNameParseAddress: WideString; virtual;
    function GetNameParseAddressInFolder: WideString; virtual;
    function GetNewContent: Boolean; virtual;
    function GetNonEnumerated: Boolean; virtual;
    function GetNormal: Boolean; virtual;
    function GetOffLine: Boolean; virtual;
    function GetParentShellFolder: IShellFolder; virtual;
    function GetReadOnly: Boolean; virtual;
    function GetReadOnlyFile: Boolean; virtual;
    function GetRemovable: Boolean; virtual;
    function GetSizeOfFile: WideString; virtual;
    function GetSizeOfFileDiskUsage: WideString; virtual;
    function GetSizeOfFileInt64: Int64; virtual;
    function GetSizeOfFileKB: WideString; virtual;
    function GetShare: Boolean; virtual;
    function GetShortFileName: WideString; virtual;
    function GetSubItems: Boolean; virtual;
    function GetSystem: Boolean; virtual;
    function GetTemporary: Boolean; virtual;

    function CreateCategory(GUID: TGUID): ICategorizer;
    function ExplorerStyleAttributeStringList(CapitalLetters: Boolean): WideString;
    function DisplayNameOf(Flags: Longword): WideString;
    procedure GetDataFromIDList;
    procedure GetFileTimes;
    procedure GetSHFileInfo;
    function InjectCustomSubMenu(Menu: HMenu; Caption: string; PopupMenu: TPopupMenu; var SubMenu: HMenu): TMenuItemIDArray;
    function InternalGetContextMenuInterface(PIDLArray: TRelativePIDLArray): IContextMenu;
    function InternalGetDataObjectInterface(PIDLArray: TRelativePIDLArray): IDataObject;
    function InternalShowContextMenu(Owner: TWinControl; ContextMenuCmdCallback: TContextMenuCmdCallback;
      ContextMenuShowCallback: TContextMenuShowCallback; ContextMenuAfterCmdCallback: TContextMenuAfterCmdCallback;
      PIDLArray: TRelativePIDLArray; Position: PPoint;
      CustomShellSubMenu: TPopupMenu; CustomSubMenuCaption: WideString;
      ForceFromDesktop: Boolean): Boolean;
    function InternalSubItems(Flags: Longword): Boolean;
    function VerifyPIDLRelationship(NamespaceArray: TNamespaceArray): Boolean;
    procedure WindowProcForContextMenu(var Message: TMessage);

    property CurrentContextMenu2: IContextMenu2 read FCurrentContextMenu2 write FCurrentContextMenu2;
    property CurrentContextMenu: IContextMenu read FCurrentContextMenu write FCurrentContextMenu;
    property ShellCache: TShellCacheRec read FShellCache write FShellCache;
    property SystemIsSuperHidden: Boolean read FSystemIsSuperHidden write FSystemIsSuperHidden;

  public
    constructor Create(PIDL: PItemIdList; AParent: TNamespace);
    destructor Destroy; override;

    constructor CreateCustomNamespace(CustomID: Integer; AParent: TNamespace);
    constructor CreateFromFileName(FileName: WideString);
    function CanCopyAll(NamespaceArray: TNamespaceArray): Boolean;
    function CanCutAll(NamespaceArray: TNamespaceArray): boolean;
    function CanDeleteAll(NamespaceArray: TNamespaceArray): Boolean;
    function CanPasteToAll(NamespaceArray: TNamespaceArray): Boolean;
    function CanShowPropertiesOfAll(NamespaceArray: TNamespaceArray): Boolean;
    function Clone(ReleasePIDLOnDestroy: Boolean): TNameSpace; virtual;
    function ComparePIDL(PIDLToCompare: PItemIDList; IsAbsolutePIDL: Boolean; Column: Integer = 0): ShortInt;
    function ContextMenuItemHelp(MenuItemID: LongWord): WideString;
    function ContextMenuVerb(MenuItemID: LongWord): WideString;
    function Copy(NamespaceArray: TNamespaceArray): Boolean;
    function Cut(NamespaceArray: TNamespaceArray): Boolean;
    function DataObjectMulti(NamespaceArray: TNamespaceArray): IDataObject;
    function Delete(NamespaceArray: TNamespaceArray): Boolean;
    function DetailsAlignment(ColumnIndex: Integer): TAlignment;
    function DetailsColumnTitle(ColumnIndex: integer): WideString;
    function DetailsColumnTitleInfo(ColumnIndex: Integer): TDetailsColumnTitleInfo;
    function DetailsDefaultColumnTitle(ColumnIndex: integer): WideString; virtual;
    function DetailsDefaultOf(ColumnIndex: integer): WideString; virtual;
    function DetailsDefaultSupportedColumns: integer; virtual;
    function DetailsGetDefaultColumnState(ColumnIndex: integer): TSHColumnStates;
    function DetailsOf(ColumnIndex: integer): WideString;
    function DetailsOfEx(ColumnIndex: integer): WideString;
    function DetailsSupportedColumns: integer;
    function DetailsSupportedVisibleColumns: TVisibleColumnIndexArray;
    function DetailsValidIndex(DetailsIndex: integer): Boolean;
    function DragEffect(grfKeyState: integer): HRESULT;
    function DragEnter(const dataObj: IDataObject; grfKeyState: Integer;
      pt: TPoint; var dwEffect: Integer): HResult;
    function DragLeave: HResult;
    function DragOver(grfKeyState: Integer; pt: TPoint;
      var dwEffect: Integer): HResult;
    function Drop(const dataObj: IDataObject; grfKeyState: Integer;
      pt: TPoint; var dwEffect: Integer): HResult;
    function EnumerateFolder(MessageWnd: HWnd; Folders, NonFolders, IncludeHidden: Boolean;
      EnumFunc: TEnumFolderCallback; UserData: pointer): integer;
    function EnumerateFolderEx(MessageWnd: HWnd; FileObjects: TFileObjects;
      EnumFunc: TEnumFolderCallback; UserData: pointer): integer;
    {$IFDEF VIRTUALNAMESPACES}
    function EnumerateFolderHook(Folders, NonFolders, IncludeHidden: Boolean;
      EnumFunc: TEnumFolderCallback; UserData: pointer): Integer;
    {$ENDIF}
    function ExecuteContextMenuVerb(AVerb: WideString; APIDLArray: TRelativePIDLArray; MessageWindowParent: HWnd = 0): Boolean;
    function FolderSize(Invalidate: Boolean; RecurseFolder: Boolean = False): Int64;
    function GetIconIndex(OpenIcon: Boolean; IconSize: TIconSize; ForceLoad: Boolean = True): integer; virtual;
    function GetImage: TBitmap;
    procedure HandleContextMenuMsg(Msg, wParam, lParam: Longint; var Result: LRESULT);
    procedure InvalidateCache;
    procedure InvalidateNamespace(RefreshIcon: Boolean = True);
    procedure InvalidateRelativePIDL(FileObjects: TFileObjects);
    procedure InvalidateThumbImage;
    function IsChildByNamespace(TestNamespace: TNamespace; Immediate: Boolean): Boolean;
    function IsChildByPIDL(TestPIDL: PItemIDList; Immediate: Boolean): Boolean;
    function IsChildOfRemovableDrive: Boolean;
    function IsControlPanel: Boolean;
    function IsControlPanelChildFolder: Boolean;
    function IsDesktop: Boolean;

    function IsMyComputer: Boolean;
    function IsNetworkNeighborhood: Boolean;
    function IsNetworkNeighborhoodChild: Boolean;
    function IsParentByNamespace(TestNamespace: TNamespace; Immediate: Boolean): Boolean;
    function IsParentByPIDL(TestPIDL: PItemIDList; Immediate: Boolean): Boolean;

    function IsRecycleBin: Boolean;

    function ParseDisplayName: PItemIDList;  overload;
    function ParseDisplayName(Path: WideString): PItemIDList; overload;
    function Paste(NamespaceArray: TNamespaceArray; AsShortCut: Boolean = False): Boolean;
    procedure SetIconIndexByThread(IconIndex: Integer; ClearThreadLoading: Boolean);
    procedure SetImageByThread(Bitmap: TBitmap; ClearThreadLoading: Boolean);
    function SetNameOf(NewName: WideString): Boolean;
    function ShellExecuteNamespace(WorkingDir, CmdLineArguments: WideString; ExecuteFolder: Boolean = False;
      ExecuteFolderShortCut: Boolean = False): Boolean;
    function ShowContextMenu(Owner: TWinControl;
      ContextMenuCmdCallback: TContextMenuCmdCallback; ContextMenuShowCallback: TContextMenuShowCallback;
      ContextMenuAfterCmdCallback: TContextMenuAfterCmdCallback; Position: PPoint = nil;
      CustomShellSubMenu: TPopupMenu = nil; CustomSubMenuCaption: WideString = ''): Boolean;
    function ShowContextMenuMulti(Owner: TWinControl; ContextMenuCmdCallback: TContextMenuCmdCallback;
      ContextMenuShowCallback: TContextMenuShowCallback; ContextMenuAfterCmdCallback: TContextMenuAfterCmdCallback;
      NamespaceArray: TNamespaceArray; Position: PPoint = nil; CustomShellSubMenu: TPopupMenu = nil;
      CustomSubMenuCaption: WideString = ''; ForceFromDesktop: Boolean = False): Boolean;
    procedure ShowPropertySheet;
    procedure ShowPropertySheetMulti(NamespaceArray: TNamespaceArray);
    function SubFoldersEx(Flags: Longword = SHCONTF_FOLDERS): Boolean;
    function SubItemsEx(Flags: Longword = SHCONTF_NONFOLDERS): Boolean;
    function TestAttributesOf(Flags: Longword; FlushCache: Boolean; SoftFlush: Boolean = False): Boolean;

    property AbsolutePIDL: PItemIDList read FAbsolutePIDL;
    property AdvDetailsSupported: Boolean read GetDetailsSupported;
    property Browsable: Boolean read GetBrowsable;
    property BrowserFrameOptionsInterface: IBrowserFrameOptions read GetBrowserFrameOptionsInterface;
    property CanCopy: Boolean read GetCanCopy;
    property CanDelete: Boolean read GetCanDelete;
    property CanLink: Boolean read GetCanLink;
    property CanMoniker: Boolean read GetCanMoniker;
    property CanMove: Boolean read GetCanMove;
    property CanRename: Boolean read GetCanRename;

    property CategoryProviderInterface: ICategoryProvider read GetCategoryProviderInterface;
    property CategoryAlphabetical: ICategorizer read GetCategoryAlphabetical;
    property CategoryDriveSize: ICategorizer read GetCategoryDriveSize;
    property CategoryDriveType: ICategorizer read GetCategoryDriveType;
    property CategoryFreeSpace: ICategorizer read GetCategoryFreeSpace;
    property CategorySize: ICategorizer read GetCategorySize;
    property CategoryTime: ICategorizer read GetCategoryTime;

    property CLSID: TGUID read GetCLSID;
    property ContextMenuInterface: IContextMenu read GetContextMenuInterface;
    property ContextMenu2Interface: IContextMenu2 read GetContextMenu2Interface;
    property ContextMenu3Interface: IContextMenu3 read GetContextMenu3Interface;
    property DataObjectInterface: IDataObject read GetDataObjectInterface;
    property Description: TObjectDescription read GetDescription;
    property DropTarget: Boolean read GetDropTarget;
    property DropTargetInterface: IDropTarget read GetDropTargetInterface;
    property Encrypted: Boolean read GetEncrypted;
    property ExtractImage: TExtractImage read GetExtractImage;
    property ExtractIconAInterface: IExtractIconA read GetExtractIconAInterface;
    property ExtractIconWInterface: IExtractIconW read GetExtractIconWInterface;
    property FileSystem: Boolean read GetFileSystem;
    property FileSysAncestor: Boolean read GetFileSysAncestor;
    property Folder: Boolean read GetFolder;
    property FreePIDLOnDestroy: Boolean read GetFreePIDLOnDestroy write SetFreePIDLOnDestroy;
    property Ghosted: Boolean read GetGhosted;
    property HasPropSheet: Boolean read GetHasPropSheet;
    property HasStorage: Boolean read GetHasStorage;
    property HasSubFolder: Boolean read GetHasSubFolder;
    property IconIndexChanged: Boolean read GetIconIndexChanged write SetIconIndexChanged;
    property IsSlow: Boolean read GetIsSlow;
    {$IFDEF VIRTUALNAMESPACES}
    property IsVirtualNamespace: Boolean read GetIsVirtualNamespace;
    property IsRootVirtualNamespace: Boolean read GetIsRootVirtualNamespace;
    property IsHardHookedNamespace: Boolean read GetIsHardHookedNamespace;
    property IsHookedNamespace: Boolean read GetIsHookedNamespace;
    property IsVirtualHook: Boolean read GetIsVirtualHook;
    {$ENDIF}
    property Link: Boolean read GetLink;
    property InfoTip: WideString read GetInfoTip;
    property NameAddressbar: WideString read GetNameAddressbar;
    property NameAddressbarInFolder: WideString read GetNameAddressbarInFolder;
    property NameForEditing: WideString read GetNameForEditing;
    property NameForEditingInFolder: WideString read GetNameForEditingInFolder;
    property NameForParsing: WideString read GetNameForParsing;
    property NameForParsingInFolder: WideString read GetNameForParsingInFolder;
    property NameInFolder: WideString read GetNameInFolder;
    property NameNormal: WideString read GetNameNormal;
    property NameParseAddress: WideString read GetNameParseAddress;
    property NameParseAddressInFolder: WideString read GetNameParseAddressInFolder;
    property NamespaceID: integer read FNamespaceID;
    property NewContent: Boolean read GetNewContent;
    property NonEnumerated: Boolean read GetNonEnumerated;
    property Parent: TNamespace read FParent;
    property ParentShellFolder: IShellFolder read GetParentShellFolder;
    property ParentShellFolder2: IShellFolder2 read GetParentShellFolder2;
    property ParentShellDetailsInterface: {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF} read GetParentShellDetailsInterface;
    property QueryAssociationsInterface: IQueryAssociations read GetQueryAssociationsInterface;
    property ReadOnly: Boolean read GetReadOnly;
    property RelativePIDL: PItemIDList read FRelativePIDL;  // Single Item ID of this namespace
    property Removable: Boolean read GetRemovable;
    property Share: Boolean read GetShare;
    property ShellFolder: IShellFolder read GetShellFolder;
    property ShellFolder2: IShellFolder2 read GetShellFolder2;
    property ShellDetailsInterface: {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF} read GetShellDetailsInterface;
    property ShellLink: TVirtualShellLink read GetShellLink;
    property ShellIconInterface: IShellIcon read GetShellIconInterface;
    property ShellIconOverlayInterface: IShellIconOverlay read GetShellIconOverlayInterface;
    property ShortFileName: WideString read GetShortFileName;
    property States: TNamespaceStates read FStates write FStates;
    property Storage: Boolean read GetStorage;
    property StorageAncestor: Boolean read GetStorageAncestor;
    property Stream: Boolean read GetStream;
    property SubFolders: Boolean read GetSubFolders;
    property SubItems: Boolean read GetSubItems;
    property Tag: integer read FTag write FTag;
    property ThreadedIconLoaded: Boolean read GetThreadedIconLoaded;
    property ThreadIconLoading: Boolean read GetThreadIconLoading write SetThreadIconLoading;
    property ThreadImageLoaded: Boolean read GetThreadedImageLoaded;
    property ThreadImageLoading: Boolean read GetThreadedImageLoading write SetThreadImageLoading;
    property TileDetail: TIntegerDynArray read FTileDetail write FTileDetail;
    property QueryInfoInterface: IQueryInfo read GetQueryInfoInterface;
    property Win32FindDataA: PWin32FindDataA read FWin32FindDataA;
    property Win32FindDataW: PWin32FindDataW read FWin32FindDataW;
    { Information on namespaces that are actual files.                          }
    property AttributesString: WideString read GetAttributesString; // Explorer type 'RHSA'
    property Archive: Boolean read GetArchive;
    property Compressed: Boolean read GetCompressed;
    property CreationTime: WideString read GetCreationTime;
    property CreationDateTime: TDateTime read GetCreationDateTime;
    property CreationTimeRaw: TFileTime read GetCreationTimeRaw;
    property Directory: Boolean read GetDirectory;
    property Extension: WideString read GetExtension;
    property FileName: WideString read GetFileName;
    property FileType: WideString read GetFileType;
    property Hidden: Boolean read GetHidden;
    property LastAccessTime: WideString read GetLastAccessTime;
    property LastAccessDateTime: TDateTime read GetLastAccessDateTime;
    property LastAccessTimeRaw: TFileTime read GetLastAccessTimeRaw;
    property LastWriteTime: WideString read GetLastWriteTime;
    property LastWriteDateTime: TDateTime read GetLastWriteDateTime;
    property LastWriteTimeRaw: TFileTime read GetLastWriteTimeRaw;
    property Normal: Boolean read GetNormal;
    property OffLine: Boolean read GetOffLine;
    property OverlayIndex: Integer read GetOverlayIndex;
    property OverlayIconIndex: Integer read GetOverlayIconIndex;
    property ReadOnlyFile: Boolean read GetReadOnlyFile;
    property SizeOfFile: WideString read GetSizeOfFile;
    property SizeOfFileInt64: Int64 read GetSizeOfFileInt64;
    property SizeOfFileKB: WideString read GetSizeOfFileKB;
    property SizeOfFileDiskUsage: WideString read GetSizeOfFileDiskUsage;
    property SystemFile: Boolean read GetSystem;
    property Temporary: Boolean read GetTemporary;
    property Valid: Boolean read GetValid;
 end;
{-------------------------------------------------------------------------------}


{-------------------------------------------------------------------------------}
{ Exported Functions                                                            }
{-------------------------------------------------------------------------------}

  // Rectange Functions
  function RectWidth(ARect: TRect): integer;
  function RectHeight(ARect: TRect): integer;

  // PIDL Functions
  function NamespaceToAbsolutePIDLArray(Namespaces: TNamespaceArray): TAbsolutePIDLArray;
  function NamespaceToRelativePIDLArray(Namespaces: TNamespaceArray): TRelativePIDLArray;
  function PathToPIDL(APath: WideString): PItemIDList;
  function PIDLToPath(APIDL: PItemIDList): WideString;
  function DirExistsVET(APath: WideString; ShowSystemMessages: Boolean): Boolean; overload;
  function DirExistsVET(NS: TNamespace; ShowSystemMessages: Boolean): Boolean; overload;

  // Time Conversions
  //** NOTE these are not WideString functions they will use ANSI strings internally
  function ConvertLocalStrToTFileTime(LocalStr: WideString; var FileTime: TFileTime): Boolean;
  function ConvertTFileTimeToLocalStr(AFileTime: TFILETIME): WideString;
  function ConvertFileTimetoDateTime(AFileTime : TFileTime): TDateTime;

  // Various Functions
  function CreateSpecialNamespace(FolderID: integer): TNamespace;
  function DefaultSystemImageIndex(FolderType: TDefaultFolderIcon): integer;
  function FileIconInit(FullInit: BOOL): BOOL; stdcall;
  function IENamespaceShown(PerUser: Boolean): Boolean;

// IShellLink (ShortCut) helpers
  function CreateShellLink(
                           ALnkFilePath,
                           ATargetFilePath: WideString;
                           AnArguments: WideString = '';
                           AWorkingDir: WideString = '';
                           ADescription: WideString = '';
                           AShowCmd: TCmdShow = swShowNormal;
                           AHotKey: Word = 0;
                           AHotKeyModifier: THotKeyModifiers = [];
                           AnIconLocation: WideString = '';
                           AnIconIndex: integer = 0
                         ): Boolean;
  function HotKeyModifiersToStr(HotKeyMod: THotKeyModifiers): WideString;
  function PotentialMappedDrive(NS: TNamespace): Boolean;
  function FileObjectsToFlags(FileObjects: TFileObjects): DWORD;

  {$ifdef COMPILER_4}
  procedure FreeAndNil(var Obj);
  function Supports(const Instance: IUnknown; const Intf: TGUID; out Inst): Boolean;
  {$endif}

var
 { A few global common Namespaces to be used for various purposes.               }
  PIDLMgr: TPIDLManager;
  DesktopFolder,
  RecycleBinFolder,
  PhysicalDesktopFolder,
  DrivesFolder,
  HistoryFolder,
  PrinterFolder,
  ControlPanelFolder,
  NetworkNeighborHoodFolder,
  TemplatesFolder,
  MyDocumentsFolder,
  FavoritesFolder: TNamespace;
  SHLimitInputEdit: TSHLimitInputEdit;

  AnimateWindow: function(Wnd: HWND; dwTime: Cardinal; dwFlags: Cardinal): WordBool; stdcall;

implementation

uses
  VirtualWideStrings;

type
  TShellILIsParent = function(PIDL1: PItemIDList; PIDL2: PItemIDList;
    ImmediateParent: LongBool): LongBool; stdcall;
  TShellILIsEqual = function(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool; stdcall;

var
  ShellILIsParent: TShellILIsParent;
  ShellILIsEqual: TShellILIsEqual;

////////////////////////////////////////////////////////////////////////////////
// Global Functions
////////////////////////////////////////////////////////////////////////////////


// PIDL Functions

{ ----------------------------------------------------------------------------- }
function NamespaceToRelativePIDLArray(Namespaces: TNamespaceArray): TRelativePIDLArray;
var
  i: integer;
begin
  Result := nil;
  if Assigned(Namespaces) then
  begin
    SetLength(Result, Length(Namespaces));
    for i := 0 to Length(Namespaces) - 1 do
      Result[i] := Namespaces[i].RelativePIDL;
  end
end;

function NamespaceToAbsolutePIDLArray(Namespaces: TNamespaceArray): TAbsolutePIDLArray;
var
  i: integer;
begin
  Result := nil;
  if Assigned(Namespaces) then
  begin
    SetLength(Result, Length(Namespaces));
    for i := 0 to Length(Namespaces) - 1 do
      Result[i] := Namespaces[i].AbsolutePIDL;
  end
end;
{ ----------------------------------------------------------------------------- }

function PathToPIDL(APath: WideString): PItemIDList;
// Takes the passed Path and attempts to convert it to the equavalent PIDL
var
  Desktop: IShellFolder;
  pchEaten, dwAttributes: ULONG;
begin
  Result := nil;
  begin
    SHGetDesktopFolder(Desktop);
    dwAttributes := 0;
    if Assigned(Desktop) then
      Desktop.ParseDisplayName(0, nil, PWideChar(APath), pchEaten, Result, dwAttributes)
  end
end;
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
function PIDLToPath(APIDL: PItemIDList): WideString;
var
  Folder: TNamespace;
begin
  Result := '';
  Folder := TNamespace.Create(APIDL, nil);
  try
    Folder.FreePIDLOnDestroy := False;
    if Assigned(Folder) then
      Result := Folder.NameForParsing;
  finally
    Folder.Free
  end
end;
{ ----------------------------------------------------------------------------- }

function IENamespaceShown(PerUser: Boolean): Boolean;
var
  Reg: TRegistry;
begin
  Result := True;
  Reg := TRegistry.Create;
  try
    if PerUser then
      Reg.RootKey := HKEY_CURRENT_USER
    else
      Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel', False) then
    begin
      if Reg.ValueExists('{871C5380-42A0-1069-A2EA-08002B30309D}') then
      begin
        Result := Reg.ReadInteger('{871C5380-42A0-1069-A2EA-08002B30309D}') = 0;
      end
    end;
  finally
    Reg.Free
  end;
end;

{ ----------------------------------------------------------------------------- }
function DirExistsVET(APath: WideString; ShowSystemMessages: Boolean): Boolean; overload;
const
  FLAGS = SHCONTF_FOLDERS or SHCONTF_NONFOLDERS or SHCONTF_INCLUDEHIDDEN;
var
  Desktop, Folder: IShellFolder;
  TempPIDL, PIDL: PItemIDList;
  EnumIDList: IEnumIDList;
  hWndOwner: THandle;
  TempPath: WideString;
begin
  Result := False;
  if ShowSystemMessages then
    hWndOwner := Application.Handle
  else
    hWndOwner := 0;

  PIDL := nil;
  TempPath := ExtractFileDriveW(APath) + '\';
  // First make sure the drive is available, it may be a remoted password protected drive
  TempPIDL := PathToPIDL(TempPath);
  if Succeeded(SHGetDesktopFolder(Desktop)) then
    if Succeeded(Desktop.BindToObject(TempPIDL, nil, IShellFolder, Pointer(Folder))) then
      if Succeeded(Folder.EnumObjects(hWndOwner, FLAGS, EnumIDList)) then
      begin
        PIDL := PathToPIDL(APath);
        if Succeeded(Desktop.BindToObject(PIDL, nil, IShellFolder, Pointer(Folder))) then
          Result := Succeeded(Folder.EnumObjects(hWndOwner, FLAGS, EnumIDList))
      end;
  coTaskMemFree(TempPIDL);
  coTaskMemFree(PIDL);
end;
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
function DirExistsVET(NS: TNamespace; ShowSystemMessages: Boolean): Boolean; overload;
begin
  Result := DirExistsVET(NS.NameForParsing, ShowSystemMessages)
end;

{ ----------------------------------------------------------------------------- }
function RectWidth(ARect: TRect): integer;
begin
  Result := ARect.Right - ARect.Left
end;
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
function RectHeight(ARect: TRect): integer;
begin
  Result := ARect.Bottom - ARect.Top
end;
{ ----------------------------------------------------------------------------- }

function PotentialMappedDrive(NS: TNamespace): Boolean;
// A mapped drive will not return valid information, other then
// its display name under some conditions so always try it.
var
  DriveType: DWORD;
begin
  Result := False;
  if IsDriveW(NS.NameForParsing) then
  begin
    if Assigned(GetDriveTypeW_VST) then
      DriveType := GetDriveTypeW_VST(PWideChar(NS.NameForParsing))
    else
      DriveType := GetDriveType(PChar(string(NS.NameForParsing)));
    Result := (DriveType = DRIVE_NO_ROOT_DIR) or (DriveType = DRIVE_REMOTE)
  end
end;
{ ----------------------------------------------------------------------------- }

function FileObjectsToFlags(FileObjects: TFileObjects): DWORD;
begin
  Result := 0;
  if foFolders in FileObjects then
    Result := Result or SHCONTF_FOLDERS;
  if foNonFolders in FileObjects then
    Result := Result or SHCONTF_NONFOLDERS;
  if foHidden in FileObjects then
    Result := Result or SHCONTF_INCLUDEHIDDEN;
  if IsUnicode and not IsWinNT4 then
  begin
    if foShareable in FileObjects then
      Result := Result or SHCONTF_SHAREABLE;
    if foNetworkPrinters in FileObjects then
      Result := Result or SHCONTF_NETPRINTERSRCH;
  end;
end;

// Time Conversions

{ ----------------------------------------------------------------------------- }
// ANSI
function ConvertLocalStrToTFileTime(LocalStr: WideString;
  var FileTime: TFileTime): Boolean;
var
  SystemTime: TSystemTime;
begin
  Result := True;
  try
     DateTimeToSystemTime(StrToDateTime(LocalStr), SystemTime)
  except
    on EConvertError do Result := False;
  end;
  if Result then
    Result := SystemTimeToFileTime(SystemTime, FileTime);
end;
{ ----------------------------------------------------------------------------- }

function ValidFileTime(FileTime: TFileTime): Boolean;
begin
 Result := (FileTime.dwLowDateTime <> 0) or (FileTime.dwHighDateTime <> 0);
end;

{ ----------------------------------------------------------------------------- }
// Converts a TFileTime structure into a local Time/Date String.  This requires
// a check to make sure the TFileTime structure contains some info through
// the local function ValidFileTime then trying to convert the UTC time to Local
// UTC time.  Then finally changing the UTC time to System time.
// ANSI/
function ConvertTFileTimeToLocalStr(AFileTime: TFILETIME): WideString;
var
  SysTime: TSystemTime;
  LocalFileTime: TFILETIME;
begin
  if ValidFileTime(AFileTime)
  and FileTimeToLocalFileTime(AFileTime, LocalFileTime)
  and FileTimeToSystemTime(LocalFileTime, SysTime) then
  try
    Result := DateTimeToStr(SystemTimeToDateTime(SysTime))
  except
    Result := '';
  end
  else
     Result := '';
end;
{ ----------------------------------------------------------------------------- }

         
function ConvertFileTimetoDateTime(AFileTime : TFileTime): TDateTime;
var
  SysTime: TSystemTime;
  LocalFileTime: TFILETIME;
begin
  if ValidFileTime(AFileTime)
  and FileTimeToLocalFileTime(AFileTime, LocalFileTime)
  and FileTimeToSystemTime(LocalFileTime, SysTime) then
  try
    Result := SystemTimeToDateTime(SysTime);
  except
    Result := 0;
  end
  else
     Result := 0;
end;

  // Various Functions

{ ----------------------------------------------------------------------------- }
function CreateSpecialNamespace(FolderID: integer): TNamespace;
{ Creates a TNamespace based on the SpecialFolders defined by                   }
{ SHGetSpecialFolderLocation.                                                   }
var
  PIDL: PItemIDList;
  F: IShellFolder;
begin
  SHGetspecialFolderLocation(0, FolderID, PIDL);
  if Assigned(PIDL) then
  begin
    Result := TNamespace.Create(PIDL, nil);
    F := Result.ParentShellFolder // just force the namespace to have Parent
  end else
    Result := nil
end;
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
function DefaultSystemImageIndex(FolderType: TDefaultFolderIcon): integer;

{ Extracts the default Icon for the given folder type passed to it.             }

var
  FileInfoA: TSHFileInfo;
  FileInfoW: TSHFileInfoW;
  FileExampleW: WideString;
  FileExampleA: string;
  Attrib, Flags: DWORD;
  PIDL: PItemIDList;
  NS: TNamespace;
begin
  Result := -1;
  Attrib := 0;
  Flags := 0;
  case FolderType of
    diNormalFolder:
      begin
        FileExampleW := '*.*';
        Attrib := FILE_ATTRIBUTE_DIRECTORY;
        Flags := SHGFI_USEFILEATTRIBUTES or SHGFI_SHELLICONSIZE or SHGFI_SYSICONINDEX
      end;
    diOpenFolder:
      begin
        FileExampleW := '*.*';
        Attrib := FILE_ATTRIBUTE_DIRECTORY;
        Flags := SHGFI_USEFILEATTRIBUTES or SHGFI_SHELLICONSIZE or SHGFI_SYSICONINDEX or SHGFI_OPENICON
      end;
    diUnknownFile:
      begin
        FileExampleW := '*.zyxwv';
        Attrib := FILE_ATTRIBUTE_NORMAL;
        Flags := SHGFI_USEFILEATTRIBUTES or SHGFI_SHELLICONSIZE or SHGFI_SYSICONINDEX
      end;
    diLink:
      begin
        FileExampleW := '';
        Result := SHORTCUT_ICON_INDEX;
      end;
    diMyDocuments:
      begin
        if Assigned(DesktopFolder) then
        begin
          PIDL := DesktopFolder.ParseDisplayName('::{450d8fba-ad25-11d0-98a8-0800361b1103}');
          if Assigned(PIDL) then
          begin
            NS := TNamespace.Create(PIDL, nil);
            Result := NS.GetIconIndex(False, icSmall, True);
            NS.Free
          end
        end else
          Result := DefaultSystemImageIndex(diNormalFolder)
      end
  else
    FileExampleW := ''
  end;
  if FileExampleW <> '' then
  begin
    if IsUnicode then
    begin
      FillChar(FileInfoW, SizeOf(FileInfoW), #0);
      SHGetFileInfoW_VST(PWideChar(FileExampleW), Attrib, FileInfoW, SizeOf(TSHFileInfoW), Flags);
      Result := FileInfoW.iIcon;
    end else
    begin
      FileExampleA := FileExampleW;
      FillChar(FileInfoA, SizeOf(FileInfoA), #0);
      SHGetFileInfoA(PChar(FileExampleA), Attrib, FileInfoA, SizeOf(TSHFileInfoA), Flags);
      Result := FileInfoA.iIcon;
    end
  end
end;
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
// Forces the correct icons for the Common Program Groups on Windows NT 4.0.
// Borrowed from John T and GXExplorer <g>
function FileIconInit(FullInit: BOOL): BOOL; stdcall;
type
  TFileIconInit = function(FullInit: BOOL): BOOL; stdcall;
var
  ShellDLL: HMODULE;
  PFileIconInit: TFileIconInit;
begin
  Result := False;
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    ShellDLL := GetModuleHandle(PChar(Shell32));
 //   ShellDLL := LoadLibrary(PChar(Shell32));
    PFileIconInit := GetProcAddress(ShellDLL, PChar(660));
    if (Assigned(PFileIconInit)) then
      Result := PFileIconInit(FullInit);
  end;
end;
{ ----------------------------------------------------------------------------- }

// IShellLink (ShortCut) helpers
{ ----------------------------------------------------------------------------- }
function CreateShellLink(ALnkFilePath, ATargetFilePath: WideString; AnArguments: WideString = '';
 AWorkingDir: WideString = ''; ADescription: WideString = ''; AShowCmd: TCmdShow = swShowNormal;
 AHotKey: Word = 0; AHotKeyModifier: THotKeyModifiers = []; AnIconLocation: WideString = '';
 AnIconIndex: integer = 0): Boolean;
var
  ShellLink: TVirtualShellLink;
begin
  Result := True;
  ShellLink := TVirtualShellLink.Create(nil);
  if Assigned(ShellLink) then
  try
    try
      ShellLink.FileName := ALnkFilePath;
      ShellLink.TargetPath := ATargetFilePath;
      if AnArguments <> '' then
        ShellLink.Arguments := AnArguments;
      if AWorkingDir <> '' then
        ShellLink.WorkingDirectory := AWorkingDir;
      if ADescription <> '' then
        ShellLink.Description := ADescription;
      if AShowCmd <> swShowNormal then
        ShellLink.ShowCmd := AShowCmd;
      if (AHotKey <> 0) then
        ShellLink.HotKey := AHotKey;
      if AHotKeyModifier <> [] then
        ShellLink.HotKeyModifiers := AHotKeyModifier;
      if AnIconLocation <> '' then
        ShellLink.IconLocation := AnIconLocation;
      if AnIconIndex <> 0 then
        ShellLink.IconIndex := AnIconIndex;
      ShellLink.WriteLink(ShellLink.FileName);
    except
      Result := False;
      raise;
    end
  finally
    ShellLink.Free
  end
end;
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
function HotKeyModifiersToStr(HotKeyMod: THotKeyModifiers): WideString;
begin
  Result := '';
  if hkmAlt in HotKeyMod then
    Result := Result + ' Alt';
  if hkmControl in HotKeyMod then
    Result := Result + ' Control';
  if hkmExtendedKey in HotKeyMod then
    Result := Result + ' ExtendedKey';
  if hkmShift in HotKeyMod then
    Result := Result + ' Shift';
end;
{ ----------------------------------------------------------------------------- }

{ Some Stuff D4 lacks.
                                                }
{$ifdef COMPILER_4}
{ ----------------------------------------------------------------------------- }
procedure FreeAndNil(var Obj);
var
  P: TObject;
begin
  P := TObject(Obj);
  TObject(Obj) := nil;
  P.Free;
end;
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
function Supports(const Instance: IUnknown; const Intf: TGUID; out Inst): Boolean;
begin
  Result := (Instance <> nil) and (Instance.QueryInterface(Intf, Inst) = 0);
end;
{ ----------------------------------------------------------------------------- }
{$endif}


////////////////////////////////////////////////////////////////////////////////
// Local Functions
////////////////////////////////////////////////////////////////////////////////

{ ----------------------------------------------------------------------------- }
function RequestedDragEffect(grfKeyState: integer): HResult;
{ Looks at the KeyState during a IDragTarget notification. The return value}
{ is the expected behavior common in Windows. Note this does not mean that }
{ the DragSource is actually capable of this action.                       }
begin
  // Strip off the mouse button information keep only Ctrl and Shift information
  grfKeyState := grfKeyState and (MK_CONTROL or MK_SHIFT);
  // Standard Windows Shell behavior
  if grfKeyState = 0 then Result := DROPEFFECT_MOVE  // Windows default
  else
  if grfKeyState = MK_CONTROL then Result := DROPEFFECT_COPY
  else
  if grfKeyState = (MK_CONTROL or MK_SHIFT) then Result := DROPEFFECT_LINK
  else
  Result := DROPEFFECT_NONE;
end;
{ ----------------------------------------------------------------------------- }


{ ----------------------------------------------------------------------------- }
{ Thank you Angus Johnson for this article in UNDO          }
{-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
//Structures used in GetDiskFreeSpaceFAT32
{-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
type
  //DeviceIoControl registers structure...
  TDevIoCtl_Registers = packed record
    Reg_EBX   : DWord;
    Reg_EDX   : DWord;
    Reg_ECX   : DWord;
    Reg_EAX   : DWord;
    Reg_EDI   : DWord;
    Reg_ESI   : DWord;
    Reg_Flags : DWord;
  end;

  //Structure passed in Get_ExtFreeSpace ...
  TExtGetDskFreSpcStruc = packed record
    ExtFree_Size                      : Word;
    ExtFree_Level                     : Word;
    ExtFree_SectorsPerCluster         : Integer;
    ExtFree_BytesPerSector            : Integer;
    ExtFree_AvailableClusters         : Integer;
    ExtFree_TotalClusters             : Integer;
    ExtFree_AvailablePhysSectors      : Integer;
    ExtFree_TotalPhysSectors          : Integer;
    ExtFree_AvailableAllocationUnits  : Integer;
    ExtFree_TotalAllocationUnits      : Integer;
    ExtFree_Rsvd                      : array [0..1] of Integer;
  end;

{-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
//Angus Johnson's Delphi implimentation of - Int 21h Function 7303h Get_ExtFreeSpace (FAT32)
{-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-}
function GetDiskFreeSpaceFAT32(Drive: PChar; var SectorsperCluster,
  BytesperSector, FreeClusters, TotalClusters: DWORD): boolean;
const
  VWIN32_DIOC_DOS_IOCTL = 6;
var
  DevIoHandle         : THandle;
  BytesReturned       : DWord;
  Reg                 : TDevIoCtl_Registers;
  ExtGetDskFreSpcStruc: TExtGetDskFreSpcStruc;
begin
  result := false;
  FillChar(ExtGetDskFreSpcStruc, sizeof(TExtGetDskFreSpcStruc),0);
  FillChar(Reg, sizeof(TDevIoCtl_Registers),0);
  with Reg do begin
    reg_EAX :=  $7303;
    reg_EDX := DWord(Drive); //DS:DX
    Reg_EDI := DWord(@ExtGetDskFreSpcStruc); //ES:DI
    reg_ECX := sizeof(TExtGetDskFreSpcStruc);
    reg_Flags := 1; //set carry flag to assume error.
  end;

  if IsUnicode then
    DevIoHandle := CreateFileW_VST( '\\.\vwin32', Generic_Read,
      File_Share_Read or File_Share_Write, nil, Open_Existing, File_Attribute_Normal, 0)
  else
    DevIoHandle := CreateFile( '\\.\vwin32', Generic_Read,
      File_Share_Read or File_Share_Write, nil, Open_Existing, File_Attribute_Normal, 0);

  if DevIoHandle <> Invalid_Handle_Value then begin
    result := DeviceIoControl(DevIoHandle, VWIN32_DIOC_DOS_IOCTL,
        @Reg, SizeOf(Reg), @Reg, SizeOf(Reg), BytesReturned, nil);
    CloseHandle(DevIoHandle);
    if not result then
    begin
      exit //error
    end
    else if (Reg.reg_Flags and 1 <> 0) then begin
      result := false; //If carry flag not cleared then => error
      exit;
      end
    else with ExtGetDskFreSpcStruc do begin
      BytesperSector := ExtFree_BytesPerSector;
      SectorsperCluster := ExtFree_SectorsPerCluster;
      TotalClusters := ExtFree_TotalClusters;
      FreeClusters :=  ExtFree_AvailableClusters;
      result := true;
    end;
  end;
end; {GetDiskFreeSpaceFAT32}
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
function LoadShell32Functions: Boolean;
var
  ShellDLL: HMODULE;
begin
  { Don't see a point in making this all WideString compatible }
  ShellDLL := GetModuleHandle(PChar(Shell32));
//  ShellDLL := LoadLibrary(PChar(Shell32));
  if ShellDll <> 0 then
  begin
    AnimateWindow := GetProcAddress(GetModuleHandle('user32'), 'AnimateWindow');
    ShellILIsEqual := GetProcAddress(ShellDLL, PChar(21));
    ShellILIsParent := GetProcAddress(ShellDLL, PChar(23));
    SHLimitInputEdit := GetProcAddress(ShellDLL, PChar(747));
    Result := Assigned(ShellILIsEqual) and Assigned(ShellILIsParent)
  end else
    Result := False;
end;
{ ----------------------------------------------------------------------------- }


{ TNamespace }

function TNamespace.CanCopyAll(NamespaceArray: TNamespaceArray): Boolean;
var
  i: integer;
begin
  if Assigned(NamespaceArray) then
  begin
    Result := True;
    i := 0;
    while Result and (i < Length(NamespaceArray)) do
    begin
      Result := NamespaceArray[i].CanCopy;
      Inc(i)
    end
  end else
    Result := False
end;

function TNamespace.CanCutAll(NamespaceArray: TNamespaceArray): boolean;
begin
  Result := CanDeleteAll(NamespaceArray)
end;

function TNamespace.CanDeleteAll(NamespaceArray: TNamespaceArray): Boolean;
var
  i: integer;
begin
  if Assigned(NamespaceArray) then
  begin
    Result := True;
    i := 0;
    while Result and (i < Length(NamespaceArray)) do
    begin
      Result := NamespaceArray[i].CanDelete;
      Inc(i)
    end
  end else
    Result := False
end;

function TNamespace.CanPasteToAll(NamespaceArray: TNamespaceArray): Boolean;
begin
  Result := False;
  if Assigned(NamespaceArray) then
    if Length(NamespaceArray) > 0 then
      Result := True  // Can try to paste to anything?
end;

function TNamespace.CanShowPropertiesOfAll(NamespaceArray: TNamespaceArray): Boolean;
var
  i: integer;
begin
  if Assigned(NamespaceArray) then
  begin
    Result := True;
    i := 0;
    while Result and (i < Length(NamespaceArray)) do
    begin
      Result := NamespaceArray[i].HasPropSheet;
      Inc(i)
    end
  end else
    Result := False
end;

function TNamespace.Clone(ReleasePIDLOnDestroy: Boolean): TNameSpace;
begin
// This is not really a true clone since we don't copy the parent, but it is
// dangerous to do that.  Be careful using this function since things can
// potentially change in the shell.
  Result := TNamespace.Create(PIDLMgr.CopyPIDL(AbsolutePIDL), nil);
  Result.FreePIDLOnDestroy := ReleasePIDLOnDestroy;
end;

function TNamespace.ComparePIDL(PIDLToCompare: PItemIDList;
  IsAbsolutePIDL: Boolean; Column: Integer = 0): ShortInt;
// Encapsulation of the CompareID Function of IShellFolder
// Returns    > 0 if PIDLToCompare > RelativePIDL
//            0 if PIDLToCompare = RelativePIDL
//            < 0 if PIDLToCompare < RelativePIDL
var
  PIDL: PItemIDList;
  {$IFDEF VIRTUALNAMESPACES}
  PIDL1Virtual, PIDL2Virtual: Boolean;
  TempNS: TNamespace;
  TempPIDL: PItemIdList;
  {$ENDIF}
begin
  if Assigned(PIDLToCompare) then
  begin
    if Column < 0 then
      Column := 0;
    PIDL := PIDLMgr.GetPointerToLastID(PIDLToCompare);
    if Assigned(ParentShellFolder) then
    begin
      {$IFDEF VIRTUALNAMESPACES}
      // First check to see if the PIDLs are one of our own.  It is possible that
      // VET may try to compare Virtual with Real PIDL
      PIDL1Virtual := NamespaceExtensionFactory.IsVirtualPIDL(PIDL);
      PIDL2Virtual := NamespaceExtensionFactory.IsVirtualPIDL(RelativePIDL);
      if (PIDL1Virtual and PIDL2Virtual) or (not PIDL1Virtual and (not PIDL2Virtual)) then
        Result := ShortInt(ParentShellFolder.CompareIDs(Column, PIDL, RelativePIDL))
      else begin
        if Assigned(Parent) then
        begin
          // If here one is virtual and one is not
          TempPIDL := PIDLMgr.GetPointerToLastID(PIDLToCompare);
          TempNS := TNamespace.Create(PIDLMgr.AppendPIDL(Parent.AbsolutePIDL, TempPIDL), nil);
          if TempNS.Folder and not Folder then
            Result := -1
          else
          if Folder and not TempNS.Folder
          then
            Result := 1
          else begin
            if PIDL1Virtual then
              Result := 1
            else
              Result := -1;
          end;
          TempNS.Free;
        end else
          Result := -1;
      end;
      {$ELSE}
      //
      // Bug in Windows (XP at least)  A folder tree such as
      // Desktop\New Folder\NewFolder fails the CompareID test.  It says
      // Desktop\New Folder = Desktop\New Folder\NewFolder
      //
      if IsAbsolutePIDL then
      begin
        Result := -1;
        // First test is if the PIDL length is the same
        if PIDLMgr.IDCount(PIDLToCompare) = PIDLMgr.IDCount(AbsolutePIDL) then
        begin
          if Assigned(Parent) then
          begin
            // Desktop items won't have a valid parent
            if ILIsParent(Parent.AbsolutePIDL, PIDLToCompare, True) then
              Result := ShortInt(ParentShellFolder.CompareIDs(Column, PIDL, RelativePIDL))
          end else
            Result := ShortInt(ParentShellFolder.CompareIDs(Column, PIDL, RelativePIDL))
        end
      end else
        Result := ShortInt(ParentShellFolder.CompareIDs(Column, PIDL, RelativePIDL));
      {$ENDIF}
    end else
      Result := 0
  end else
    Result := -1 // If the pidl is not assigned then we clearly are greater!
end;

function TNamespace.ContextMenuItemHelp(MenuItemID: LongWord): WideString;
const
  BufferLen = 128;
var
  S: string;
  Found: Boolean;
  P: Pointer;
begin
  Found := False;
  if Assigned(CurrentContextMenu) and (MenuItemID <> $FFFFFFFF) and (MenuItemID > 0)then
  begin
    if IsUnicode then
    begin
      SetLength(Result, BufferLen);
      { Keep D6 from complaining about suspicious PChar cast }
      P := @Result[1];
      Found :=  CurrentContextMenu.GetCommandString(MenuItemID-1, GCS_HELPTEXTW, nil, PChar(P),
        BufferLen) = NOERROR
    end;
    if not Found then
    begin
      SetLength(S, BufferLen);
      if CurrentContextMenu.GetCommandString(MenuItemID-1, GCS_HELPTEXTA, nil, PChar(S),
        BufferLen) <> NOERROR
      then
        Result := ''
      else begin
        SetLength(S, StrLen( PChar(S)));
        Result := S
      end
    end else
      SetLength(Result,  lstrlenW(PWideChar( Result)))
  end;
end;

function TNamespace.ContextMenuVerb(MenuItemID: Longword): WideString;
{ Returns the cononical (or not) verb that is equal to the MenuItemID, which is }
{ the HMenu identifer for a menu item.                                          }
const
  BufferLen = 128;
var
  S: string;
  Found: Boolean;
  P: Pointer;
begin
  Found := False;
  if Assigned(CurrentContextMenu) and (MenuItemID <> $FFFFFFFF) and (MenuItemID > 0) then
  begin
    if IsUnicode then
    begin
      SetLength(Result, BufferLen);
     { Keep D6 from complaining about suspicious PChar cast }
      P := @Result[1];
      Found :=  CurrentContextMenu.GetCommandString(MenuItemID-1, GCS_VERBW, nil, PChar(P),
        BufferLen) = NOERROR
    end;
    if not Found then
    begin
      SetLength(S, BufferLen);
      if CurrentContextMenu.GetCommandString(MenuItemID-1, GCS_VERBA, nil, PChar(S),
        BufferLen) <> NOERROR
      then
        Result := ''
      else begin
        SetLength(S, StrLen( PChar(S)));
        Result := S
      end
    end else
      SetLength(Result,  lstrlenW(PWideChar( Result)))
  end;
end;

function TNamespace.Copy(NamespaceArray: TNamespaceArray): Boolean;
begin
  Result := False;
  if VerifyPIDLRelationship(NamespaceArray) then
    Result := ExecuteContextMenuVerb('copy', NamespaceToRelativePIDLArray(NamespaceArray))
end;

constructor TNamespace.Create(PIDL: PItemIdList; AParent: TNamespace);
{ Pass the PIDL of a Namespace Object Folder to create along with its parent    }
{ to create a new TNamespace.                                                   }
begin
  inherited Create;

  FParent := AParent;
  FShellCache.Data.SmallIcon := -1;
  FShellCache.Data.SmallOpenIcon := -1;
  FShellCache.Data.OverlayIndex := -1;
  FShellCache.Data.OverlayIconIndex := -1;
  Include(FStates, nsShellDetailsSupported);  // Be optomistic
  Include(FStates, nsShellFolder2Supported);  // Be optomistic
  Include(FStates, nsShellOverlaySupported);  // Be optomistic
  FreePIDLOnDestroy := True;
  FNamespaceID := SHELL_NAMESPACE_ID;
  { It is the Root Folder since it has no parent }
  if not Assigned(AParent) then
  begin
    { Either a nil for PID or if the PID is the Desktop PIDL means a full tree }
    if not Assigned(PIDL) or PIDLMgr.IsDesktopFolder(PIDL) then
    begin
      { If PID is already assigned then use it }
      if not Assigned(PIDL) then
        SHGetSpecialFolderLocation(Application.Handle, CSIDL_DESKTOP, FRelativePIDL)
      else
        FRelativePIDL := PIDL;
      FAbsolutePIDL := FRelativePIDL;
    end else
    { The PIDL is the Root PIDL but is NOT the Desktop namespace  it is a }
    { FULLY QUALIFIED PIDL to a namespace that is to be the Root.         }
    begin
      FAbsolutePIDL := PIDL;
      FRelativePIDL := PIDLMgr.GetPointerToLastID(FAbsolutePIDL);
    end;
  end else
  { If the folder is a child of the desktop special conditions apply see above }
  if PIDLMgr.IsDesktopFolder(AParent.AbsolutePIDL) then
  begin
    FRelativePIDL := PIDL;
    FAbsolutePIDL := PIDL;
  end else
  { Normal building of the PIDLs and Shells }
  begin
    FAbsolutePIDL := PIDLMgr.AppendPIDL(AParent.FAbsolutePIDL, PIDL);
    FRelativePIDL := PIDLMgr.GetPointerToLastID(FAbsolutePIDL);
    PIDLMgr.FreePIDL(PIDL);
  end;
end;

constructor TNamespace.CreateCustomNamespace(CustomID: Integer; AParent: TNamespace);
begin
  FShellCache.Data.SmallIcon := -1;
  FShellCache.Data.SmallOpenIcon := -1;
  Exclude(FStates, nsShellDetailsSupported);
  Exclude(FStates, nsShellFolder2Supported);
  FreePIDLOnDestroy := False;
  FNamespaceID := CustomID;
  FParent := AParent
end;

constructor TNamespace.CreateFromFileName(FileName: WideString);
var
  PIDL: PItemIDList;
begin
  PIDL := PathToPIDL(FileName);
  if Assigned(PIDL) then
    Create(PIDL, nil)
  else
    // This will be called often with the autocomplete component while debugging
    // in the IDE
    // To turn off exception break go to Tools>Debugger Options>Add and type in
    //  "EVSTInvalidFileName" without the quotes.  Make sure that is is checked.
    // This will keep delphi from breaking on this exception
    raise EVSTInvalidFileName.Create('Trying to create a TNamespace on a non existant File object');
end;

function TNamespace.Cut(NamespaceArray: TNamespaceArray): Boolean;
begin
  Result := False;
  if CanCutAll(NamespaceArray) and VerifyPIDLRelationship(NamespaceArray) then
    Result := ExecuteContextMenuVerb('cut', NamespaceToRelativePIDLArray(NamespaceArray))
end;

function TNamespace.DataObjectMulti(NamespaceArray: TNamespaceArray): IDataObject;
begin
  Result := InternalGetDataObjectInterface(NamespaceToRelativePIDLArray(NamespaceArray))
end;

function TNamespace.Delete(NamespaceArray: TNamespaceArray): Boolean;
begin
  Result := False;
  if CanDeleteAll(NamespaceArray) and VerifyPIDLRelationship(NamespaceArray) then
    Result := ExecuteContextMenuVerb('delete', NamespaceToRelativePIDLArray(NamespaceArray))
end;

destructor TNamespace.Destroy;
begin
  // Remember RelativePIDL points to end of AbsolutePIDL so only 1 actual PIDL.
  if FreePIDLOnDestroy and Assigned(PIDLMgr) then
    PIDLMgr.FreePIDL(FAbsolutePIDL);
  if IsUnicode then
  begin
    if Assigned(FWin32FindDataW) then
      FreeMem(FWin32FindDataW, SizeOf(TWin32FindDataW));
  end else
    if Assigned(FWin32FindDataA) then
      FreeMem(FWin32FindDataA, SizeOf(TWin32FindDataA));
  begin
  end;
  if Assigned(FSHGetFileInfoRec) then
  begin
    Finalize(FSHGetFileInfoRec^);
    FreeMem(FSHGetFileInfoRec, SizeOf(TSHGetFileInfoRec));
  end;
  if (nsOwnsParent in States) and Assigned(Parent) then
    Parent.Free;
  FreeAndNil(FExtractImage);
  FreeAndNil(FShellLink);
  FShellFolder := nil;
  FreeAndNIL(FImage);
  inherited;
end;

function TNamespace.DetailsAlignment(ColumnIndex: Integer): TAlignment;
{ Returns the text for the desired column (detail view in the listview in       }
{ Explorer) using IShellDetail or using information pulled from the namespace   }
{ by other means.                                                               }

{ Be careful of the reference point using DetailsXXXX functions.  This function }
{ gets the Details of the current namespace using its parent folder.            }
var
  Details: TShellDetails;
  OldError: Integer;
begin
  Result := taLeftJustify;
  OldError := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
  try
    { Force parent namespace creation if necessary }
    if Assigned(ParentShellFolder) and not IsDesktop then
    begin
      { The parent is responsible for the columns }
      if Parent.DetailsValidIndex(ColumnIndex) then
      begin
        FillChar(Details, SizeOf(Details), #0);
        if Assigned(ParentShellFolder2) then
        begin
         { DO NOT PASS A FREAKING UNINITALIZED TSHELLDETAIL STRUCTURE TO THIS FUNCTION }
         { IT WILL CAUSE THE RESULT TO BE CORRECT BUT INTERLACED WITH GARBAGE.         }
          if ParentShellFolder2.GetDetailsOf(RelativePIDL, UINT(ColumnIndex), Details) <> S_OK then
          begin
            if Assigned(ParentShellDetailsInterface) then
              if ParentShellDetailsInterface.GetDetailsOf(RelativePIDL, UINT(ColumnIndex), Details) = S_OK then
              begin
                if Details.Fmt = LVCFMT_RIGHT then
                  Result := taRightJustify
                else
                if Details.Fmt = LVCFMT_CENTER then
                  Result := taCenter;
              end
          end
        end else
        if Assigned(ParentShellDetailsInterface) then
        begin
          if ParentShellDetailsInterface.GetDetailsOf(RelativePIDL, UINT(ColumnIndex), Details) = S_OK then
            begin
              if Details.Fmt = LVCFMT_RIGHT then
                Result := taRightJustify
              else
              if Details.Fmt = LVCFMT_CENTER then
                Result := taCenter;
            end
        end
      end
    end
  finally
    SetErrorMode(OldError);
  end
end;

function TNamespace.DetailsColumnTitle(ColumnIndex: integer): WideString;
{ Returns the Text that is in the Header of the Explorer Listview based on what }
{ the folder in the Treeview is displaying.  Only implemented partially on      }
{ different versions of Windows.  It was undocumented until about Win98.        }
{ Win2k implements this using IShellFolder2                                     }

{ Be careful of the reference point using DetailsXXXX functions.  This method   }
{ get the header titles a folder will show for its children.                    }
var
  Details: TShellDetails;
  Found: Boolean;
begin
  FillChar(Details, SizeOf(Details), #0);
  Found := False;
  if DetailsValidIndex(ColumnIndex) then
  begin
    if Assigned(ShellFolder2) then
    { DO NOT PASS A FREAKING UNINITALIZED TSHELLDETAIL STRUCTURE TO THIS FUNCTION }
    { IT WILL CAUSE THE RESULT TO BE CORRECT BUT INTERLACED WITH GARBAGE.         }
      Found := ShellFolder2.GetDetailsOf(nil, UINT(ColumnIndex), Details) = S_OK;
    if not Found and Assigned(ShellDetailsInterface) then
      Found :=  ShellDetailsInterface.GetDetailsOf(nil, UINT(ColumnIndex), Details) = S_OK;
    if Found then
      Result := StrRetToStr(Details.str, RelativePIDL)
    else
      Result := DetailsDefaultColumnTitle(ColumnIndex)
  end else
    Result := ''
end;

function TNamespace.DetailsColumnTitleInfo(ColumnIndex: Integer): TDetailsColumnTitleInfo;
{ Returns the Text that is in the Header of the Explorer Listview based on what }
{ the folder in the Treeview is displaying.  Only implemented partially on      }
{ different versions of Windows.  It was undocumented until about Win98.        }
{ Win2k implements this using IShellFolder2                                     }

{ Be careful of the reference point using DetailsXXXX functions.  This method   }
{ get the header titles a folder will show for its children.                    }
var
  Details: TShellDetails;
  Found: Boolean;
begin
  // Default
  Result := tiLeftAlign;

  FillChar(Details, SizeOf(Details), #0);
  Found := False;
  if DetailsValidIndex(ColumnIndex) then
  begin
    if Assigned(ShellFolder2) then
    { DO NOT PASS A FREAKING UNINITALIZED TSHELLDETAIL STRUCTURE TO THIS FUNCTION }
    { IT WILL CAUSE THE RESULT TO BE CORRECT BUT INTERLACED WITH GARBAGE.         }
      Found := ShellFolder2.GetDetailsOf(nil, UINT(ColumnIndex), Details) = S_OK;
    if not Found and Assigned(ShellDetailsInterface) then
      Found :=  ShellDetailsInterface.GetDetailsOf(nil, UINT(ColumnIndex), Details) = S_OK;
    if Found then
    begin
      case Details.Fmt of
        LVCFMT_CENTER: Result := tiCenterAlign;
        LVCFMT_LEFT:   Result := tiLeftAlign;
        LVCFMT_RIGHT:  Result := tiRightAlign;
        LVCFMT_COL_HAS_IMAGES: Result := tiContainsImage
      end
    end
  end
end;

function TNamespace.DetailsDefaultColumnTitle(ColumnIndex: integer): WideString;
{ If IShellDetails is not implemented then these are returned for the Header    }
{ text as a default.  Can be overridden.                                        }
begin
  case ColumnIndex of
   -1, 0:  Result := VET_COLUMN_NAMES[0];
    1:  Result := VET_COLUMN_NAMES[1];
    2:  Result := VET_COLUMN_NAMES[2];
    3:  Result := VET_COLUMN_NAMES[3];
    4:  Result := VET_COLUMN_NAMES[4];
    5:  Result := VET_COLUMN_NAMES[5];
    6:  Result := VET_COLUMN_NAMES[6];
    7:  Result := VET_COLUMN_NAMES[7];
    8:  Result := VET_COLUMN_NAMES[8];
    9:  Result := VET_COLUMN_NAMES[9];
  end;
end;

function TNamespace.DetailsDefaultOf(ColumnIndex: integer): WideString;
{ If IShellDetail is not implemented the call to DetailsOf calls this and       }
{ returns what it can to mimic the values in columns for a plain file, Name,    }
{ size, type, date, attributes.                                                 }
var
  IsSystemFolder: Boolean;
begin
  Result := '';
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) then
      { This is totally undocumented. It works on Win98 will test on NT 4 soon }
      { Not a valid file so it has no size.  #8 appears to mean "System File" }
      IsSystemFolder := not ((FWin32FindDataW^.cFileName[0] = WideChar(#8)) or
                            (FWin32FindDataW^.cFileName[0] = WideChar(#0)) or
                             not FileSystem)
    else
      IsSystemFolder := False;
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) then
      { This is totally undocumented. It works on Win98 will test on NT 4 soon }
      { Not a valid file so it has no size.  #8 appears to mean "System File" }
      IsSystemFolder := not ((FWin32FindDataA^.cFileName[0] = #8) or
                            (FWin32FindDataA^.cFileName[0] = #0) or
                             not FileSystem)
    else
      IsSystemFolder := False;
  end;
  case ColumnIndex of
    -1, 0:  Result := NameInFolder;
    1:  Result := SizeOfFileKB;
    2:  if IsSystemFolder then
          Result := FileType
        else
          Result := STR_SYSTEMFOLDER;
    3:  Result := LastWriteTime;
    4:  Result := AttributesString;
  else
    Result := ''
  end;
end;

function TNamespace.DetailsDefaultSupportedColumns: integer;
{ If IShellDetail is not implemented the call to SupportedColumns calls this    }
{ and returns 5.  It mimics the titles in the header for a plain file, Name,    }
{ size, type, date, attributes.                                                 }
begin
  Result := DefaultDetailColumns;
end;

function TNamespace.DetailsGetDefaultColumnState(ColumnIndex: integer): TSHColumnStates;
{ Be careful of the reference point using DetailsXXXX functions.  This function }
{ gets the GetDefaultColumnState of the folder for its children if it exposes   }
{ IShellFolder2.  If it does not it returns csOnByDefault so it will be shown   }
var
  Flags: Longword;
begin
  Result := [];
  if DetailsValidIndex(ColumnIndex) then
  begin
    if Assigned(ShellFolder2) then
    begin
      Flags := 0;
      if ShellFolder2.GetDefaultColumnState(ColumnIndex, Flags) = NOERROR then
      begin
        if SHCOLSTATE_TYPE_STR and Flags <> 0 then Include(Result, csTypeString);
        if SHCOLSTATE_TYPE_INT and Flags <> 0 then Include(Result, csTypeInt);
        if SHCOLSTATE_TYPE_DATE and Flags <> 0 then Include(Result, csTypeDate);
        if SHCOLSTATE_ONBYDEFAULT and Flags <> 0 then Include(Result, csOnByDefault);
        if SHCOLSTATE_TYPE_SLOW and Flags <> 0 then Include(Result, csSlow);
        if SHCOLSTATE_EXTENDED and Flags <> 0 then Include(Result, csExtended);
        if SHCOLSTATE_SECONDARYUI and Flags <> 0 then Include(Result, csSecondaryUI);
        if SHCOLSTATE_HIDDEN and Flags <> 0 then Include(Result, csHidden);
      end else
        { Some of the old namespaces will expose ShellFolder2 but don't support    }
        { it completely.  These resort to IShellDetails so assume this is the case }
        Result := [csOnByDefault];
    end else
      { Some of the old namespaces don't expose ShellFolder2.  These resort to  }
      { IShellDetails so assume this is the case                                }
      Result := [csOnByDefault];
  end
end;

function TNamespace.DetailsOf(ColumnIndex: integer): WideString;
{ Returns the text for the desired column (detail view in the listview in       }
{ Explorer) using IShellDetail or using information pulled from the namespace   }
{ by other means.                                                               }

{ Be careful of the reference point using DetailsXXXX functions.  This function }
{ gets the Details of the current namespace using its parent folder.            }
var
  Details: TShellDetails;
  OldError: Integer;
begin
  Result := '';
  OldError := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
  try
    { Force parent namespace creation if necessary }
    if Assigned(ParentShellFolder) and not IsDesktop then
    begin
      { The parent is responsible for the columns }
      if Parent.DetailsValidIndex(ColumnIndex) then
      begin
        FillChar(Details, SizeOf(Details), #0);
        if Assigned(ParentShellFolder2) then
        begin
         { DO NOT PASS A FREAKING UNINITALIZED TSHELLDETAIL STRUCTURE TO THIS FUNCTION }
         { IT WILL CAUSE THE RESULT TO BE CORRECT BUT INTERLACED WITH GARBAGE.         }
          if ParentShellFolder2.GetDetailsOf(RelativePIDL, UINT(ColumnIndex), Details) <> S_OK then
          begin
            if Assigned(ParentShellDetailsInterface) then
              if ParentShellDetailsInterface.GetDetailsOf(RelativePIDL, UINT(ColumnIndex), Details) = S_OK then
                Result := StrRetToStr(Details.Str, RelativePIDL)
              else
                Result := DetailsDefaultOf(ColumnIndex)
          end else
            Result := StrRetToStr(Details.Str, RelativePIDL)
        end else
        if Assigned(ParentShellDetailsInterface) then
        begin
          if ParentShellDetailsInterface.GetDetailsOf(RelativePIDL, UINT(ColumnIndex), Details) = S_OK then
            Result := StrRetToStr(Details.Str, RelativePIDL);
        end else
          Result := DetailsDefaultOf(ColumnIndex)
      end
    end
  finally
    SetErrorMode(OldError);
  end
end;

function TNamespace.DetailsOfEx(ColumnIndex: integer): WideString;
var
  ColumnID: TSHColumnID;
  V: OLEVariant;
  ColState: TSHColumnStates;
//  Date: TDateTime;
begin
  Result := '';
  V := Null;   
  if Assigned(ShellFolder2) then
  begin
    ColState := Parent.DetailsGetDefaultColumnState(ColumnIndex);
    FillChar(ColumnID, SizeOf(ColumnID), #0);
    if ParentShellFolder2.MapColumnToSCID(ColumnIndex, ColumnID) = NOERROR then
      if ParentShellFolder2.GetDetailsEx(RelativePIDL, ColumnID, V) = NOERROR then
      begin
        if csTypeString in ColState then
          Result := WideString(V)
        else
        if csTypeInt in ColState then
          Result := IntToStr( Integer(V))
        else
        if csTypeInt in ColState then
          Result := IntToStr(V)
        else
    //    if csTypeDate in ColState then
    //       Date := V;
      end else
        Result := DetailsDefaultOf(ColumnIndex)
    else
      Result := DetailsDefaultOf(ColumnIndex)
  end
end;

function TNamespace.DetailsSupportedColumns: integer;
{ If IShellDetail or IShellFolder2 is implemented the call to                   }
{ DetailsSupportedColumns returns total number of columns the namespace         }
{ supports.  This allows the header to change dynamiclly.                       }

{ Be careful of the reference point using DetailsXXXX functions.  This function }
{ gets number of columns this folder will display for its children.             }
const
      { ShellFolder2 is broken on WinME for "Scanners and Cameras" folders.     }
      { It goes into an infinate loop.                                          }
      { WinXP is just as broken.                                                }
  COLUMNLIMIT = 200;  // Safely valve for namespaces that don't follow the rules
var
  Details: TShellDetails;
  Flags: DWord;
  Found: Boolean;
begin
  FillChar(Details, SizeOf(Details), #0);
  if not (scSupportedColumns in ShellCache.ShellCacheFlags) then
  begin
    FShellCache.Data.SupportedColumns := 0;
    if Assigned(ShellFolder2) then
    begin
      while (ShellFolder2.GetDefaultColumnState(FShellCache.Data.SupportedColumns, Flags) = NOERROR) and
        (FShellCache.Data.SupportedColumns < COLUMNLIMIT) do
        Inc(FShellCache.Data.SupportedColumns);

      // Error detected, the namespace does not follow the rules
      if FShellCache.Data.SupportedColumns = COLUMNLIMIT then
        FShellCache.Data.SupportedColumns := 0;

      Found := FShellCache.Data.SupportedColumns > 0;
    { Some folders support both methods but only work right with GetDetailsOf   }
      if not Found then
        while (ShellFolder2.GetDetailsOf(nil, UINT(ShellCache.Data.SupportedColumns), Details) = S_OK) and
          (FShellCache.Data.SupportedColumns < COLUMNLIMIT) do
          Inc(FShellCache.Data.SupportedColumns);

      // Error detected, the namespace does not follow the rules
      if FShellCache.Data.SupportedColumns = COLUMNLIMIT then
        FShellCache.Data.SupportedColumns := 0;
    end;

    { Some folders support both but only work right with IShellDetials          }
    { The History Folder is an example.                                         }
    Found := FShellCache.Data.SupportedColumns > 0;
    { DO NOT PASS A FREAKING UNINITALIZED TSHELLDETAIL STRUCTURE TO THIS FUNCTION }
    { IT WILL CAUSE THE RESULT TO BE CORRECT BUT INTERLACED WITH GARBAGE.         }
    if not Found and Assigned(ShellDetailsInterface) then
      while ShellDetailsInterface.GetDetailsOf(nil, UINT(ShellCache.Data.SupportedColumns), Details) = S_OK do
        Inc(FShellCache.Data.SupportedColumns);

    if ShellCache.Data.SupportedColumns = 0 then
      FShellCache.Data.SupportedColumns := DetailsDefaultSupportedColumns;

    Include(FShellCache.ShellCacheFlags, scSupportedColumns);
  end;
  Result := ShellCache.Data.SupportedColumns
end;

function TNamespace.DetailsSupportedVisibleColumns: TVisibleColumnIndexArray;
// Returns and array of currently visible columns in details mode.  Two bits of info
// are returned with this method.
// 1) The number of visible column:   Length(DetailsSupportedVisibleColumns)
// 2) The indicies of visible columns: [0, 2, 4, 6] Details index 0, 2, 4, 6 are shown\
var
  i: integer;
begin
  Result := nil;
  for i := 0 to DetailsSupportedColumns - 1 do
  begin
    if csOnByDefault in DetailsGetDefaultColumnState(i) then
    begin
      if DetailsColumnTitle(i) <> '' then
      begin
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) - 1] := i
      end
    end
  end;
end;

function TNamespace.DetailsValidIndex(DetailsIndex: integer): Boolean;
{ Test to see if the passed index is in the range of the number of detail       }
{ columns the namespace has.                                                    }
begin
  Result := (DetailsIndex > -1) and (DetailsIndex < DetailsSupportedColumns)
end;

function TNamespace.DragEffect(grfKeyState: integer): HRESULT;
{ Looks at the KeyState during a IDragDrop notification.  The return value }
{ is the Effect that is desired by the user, using the GetDesiredDragEffect}
{ function, and what Effects are supported by the IDragSource              }

  function AvailableEffects: LongInt;
  begin
    Result := DROPEFFECT_NONE;
    if CanMove then Result := DROPEFFECT_MOVE;
    if CanCopy then Result := Result or DROPEFFECT_COPY;
    if CanLink then Result := Result or DROPEFFECT_LINK;
  end;

var
  KeyEffect: HResult;
  ValidEffects: Longword;
begin
  // See what the user is requesting by looking at the key board
  KeyEffect := RequestedDragEffect(grfKeyState);
  // What effects do the namespace support?
  ValidEffects := AvailableEffects;
  // Let the users desires prevail
  if KeyEffect and ValidEffects > 0 then Result := KeyEffect
  else  // If the users desires are undo-able pick the first effect avaiable
  if ValidEffects and DROPEFFECT_MOVE > 1 then Result := DROPEFFECT_MOVE
  else  // Windows default is MOVE so check it first
  if ValidEffects and DROPEFFECT_COPY > 1 then Result := DROPEFFECT_COPY
  else
  if ValidEffects and DROPEFFECT_LINK > 1 then Result := DROPEFFECT_LINK
  else
    Result := DROPEFFECT_NONE;
end;

function TNamespace.DisplayNameOf(Flags: Longword): WideString;
var
  StrRet: TSTRRET;
begin
  if Assigned(ParentShellFolder) then
  begin
    if ParentShellFolder.GetDisplayNameOf(RelativePIDL, Flags, StrRet) = NOERROR
    then
      Result := StrRetToStr(StrRet, RelativePIDL)
    else
      Result := '';
  end else
    Result := ''
end;

function TNamespace.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
{ Called when there is a pending COM drop on the namespace.  The namespace will }
{ decide if it can handle the information passed.                               }
begin
  if DropTarget and Assigned(DropTargetInterface) then
    Result := DropTargetInterface.DragEnter(dataObj, grfKeyState, pt, dwEffect)
  else begin
    dwEffect := DROPEFFECT_NONE;
    Result := S_OK
  end
end;

function TNamespace.DragLeave: HResult;
{ Called when there is a pending COM drop on the namespace.  The namespace will }
{ decide if it can handle the information passed.                               }
begin
  if DropTarget and Assigned(DropTargetInterface) then
    Result := DropTargetInterface.DragLeave
  else
    Result := S_OK
end;

function TNamespace.DragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
{ Called when there is a pending COM drop on the namespace.  The namespace will }
{ decide if it can handle the information passed.                               }
begin
  if DropTarget and Assigned(DropTargetInterface) then
    Result := DropTargetInterface.DragOver(grfKeyState, pt, dwEffect)
  else begin
    dwEffect := DROPEFFECT_NONE;
    Result := S_OK
  end
end;

function TNamespace.Drop(const dataObj: IDataObject; grfKeyState: Integer;
  pt: TPoint; var dwEffect: Integer): HResult;
{ Called when there is a COM object is dropped on the namespace.  The namespace }
{ will handle the action as well.                                               }
begin
  if DropTarget and Assigned(DropTargetInterface) then
    Result := DropTargetInterface.Drop(dataObj, grfKeyState, pt, dwEffect)
  else begin
    dwEffect := DROPEFFECT_NONE;
    Result := S_OK
  end
end;

function TNamespace.EnumerateFolder(MessageWnd: HWnd; Folders, NonFolders,
  IncludeHidden: Boolean; EnumFunc: TEnumFolderCallback;
  UserData: Pointer): integer;
{ Enumerate a folder to get its subfolders.  For each subfolder the the         }
{ callback function is called so a new TNamespace may be created.               }
{ You have a choice to receive Folders, NonFolders (files), and Hidden          }
{ objects,  UserData is useful to pass info back to the callback function.      }
{ Encapsulates the IShellFolder.EnumObjects function                            }
{ The reciever of the Callback function is responsible for Freeing the PIDLs!   }
{ Returns the number of objects in the folder.                                  }
var
  Enum: IEnumIDList;
  Flags: Longword;
  Fetched: Longword;
  Item: PItemIDList;
  Terminate: Boolean;
  OldError: integer;
begin
  Result := 0;
  { This fixed a problem Rik Baker had:                                         }
  { "The error message is "C:\WINDOWS\SYSTEM\ODBCINST.DLL is not a valid        }
  { Windows Image", however the file appears fine and I've now seen the same    }
  { message on 9 different 2000 boxes spread across the country.                }

  OldError := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
  try
    if Assigned(ShellFolder) then
    begin
      if Assigned(EnumFunc) then
      begin
        Terminate := False;
        Flags := 0;
        if Folders then
          Flags := Flags or SHCONTF_FOLDERS;
        if NonFolders then
          Flags := Flags or SHCONTF_NONFOLDERS;
        if IncludeHidden then
          Flags := Flags or SHCONTF_INCLUDEHIDDEN;


        if Valid then
        begin
          // Right now you can't mix custom items and real shell items in the same folder
          ShellFolder.EnumObjects(MessageWnd, Flags, Enum);
          if Assigned(Enum) then
            while (Enum.Next(1, Item, Fetched) = NOERROR) and not Terminate do
            begin
              if EnumFunc(MessageWnd, Item, Self, UserData, Terminate) then
                Inc(Result)
            end
        end
      end
    end
  finally
    SetErrorMode(OldError);
  end
end;

function TNamespace.EnumerateFolderEx(MessageWnd: HWnd; FileObjects: TFileObjects;
      EnumFunc: TEnumFolderCallback; UserData: pointer): integer;
{ Enumerate a folder to get its subfolders.  For each subfolder the the         }
{ callback function is called so a new TNamespace may be created.               }
{ You have a choice to receive Folders, NonFolders (files), and Hidden          }
{ objects,  UserData is useful to pass info back to the callback function.      }
{ Encapsulates the IShellFolder.EnumObjects function                            }
{ The reciever of the Callback function is responsible for Freeing the PIDLs!   }
{ Returns the number of objects in the folder.                                  }
var
  Enum: IEnumIDList;
  Flags: Longword;
  Fetched: Longword;
  Item: PItemIDList;
  Terminate: Boolean;
  OldError: integer;
begin
  Result := 0;
  { This fixed a problem Rik Baker had:                                         }
  { "The error message is "C:\WINDOWS\SYSTEM\ODBCINST.DLL is not a valid        }
  { Windows Image", however the file appears fine and I've now seen the same    }
  { message on 9 different 2000 boxes spread across the country.                }    
  OldError := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
  try
    if Assigned(ShellFolder) then
    begin
      if Assigned(EnumFunc) then
      begin
        Flags := FileObjectsToFlags(FileObjects);
        Terminate := False;
        if Valid then
        begin
          // Right now you can't mix custom items and real shell items in the same folder
          ShellFolder.EnumObjects(MessageWnd, Flags, Enum);
          if Assigned(Enum) then
            while (Enum.Next(1, Item, Fetched) = NOERROR) and not Terminate do
            begin
              if EnumFunc(MessageWnd, Item, Self, UserData, Terminate) then
                Inc(Result)
          end
        end
      end
    end
  finally
    SetErrorMode(OldError);
  end
end;

{$IFDEF VIRTUALNAMESPACES}
function TNamespace.EnumerateFolderHook(Folders, NonFolders, IncludeHidden: Boolean;
  EnumFunc: TEnumFolderCallback; UserData: pointer): Integer;
var
  Enum: IEnumIDList;
  Flags: Longword;
  Fetched: Longword;
  Item: PItemIDList;
  Terminate: Boolean;
  OldError: integer;
  VHook: IShellFolder;
begin
  Result := 0;
  if IsHookedNamespace then
  begin
    { This fixed a problem Rik Baker had:                                         }
    { "The error message is "C:\WINDOWS\SYSTEM\ODBCINST.DLL is not a valid        }
    { Windows Image", however the file appears fine and I've now seen the same    }
    { message on 9 different 2000 boxes spread across the country.                }
    OldError := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
    try
      VHook := NamespaceExtensionFactory.VirtualHook(AbsolutePIDL);
      if Assigned(VHook) then
      begin
        if Assigned(EnumFunc) then
        begin
          Flags := 0;
          Terminate := False;
          if Folders then
            Flags := Flags or SHCONTF_FOLDERS;
          if NonFolders then
            Flags := Flags or SHCONTF_NONFOLDERS;
          if IncludeHidden then
            Flags := Flags or SHCONTF_INCLUDEHIDDEN;
          // Right now you can't mix custom items and real shell items in the same folder
          VHook.EnumObjects(0, Flags, Enum);
          if Assigned(Enum) then
            while (Enum.Next(1, Item, Fetched) = NOERROR) and not Terminate do
            begin
              if EnumFunc(Item, Self, UserData, Terminate) then
                Inc(Result)
          end
        end
      end
    finally
      SetErrorMode(OldError);
    end
  end
end;
{$ENDIF}

function TNamespace.ExecuteContextMenuVerb(AVerb: WideString;
  APIDLArray: TRelativePIDLArray; MessageWindowParent: HWnd = 0): Boolean;
const
  MaxVerbLen = 128;

var
  ContextMenu, ContextMenu2: IContextMenu;
  Menu: hMenu;
  InvokeInfo: TCMInvokeCommandInfoEx;
  i: integer;
  VerbA, AVerbA: string;
  VerbW: WideString;
  VerbFound, StrFound: Boolean;
  MenuID: LongWord;
  GenericVerb: Pointer;
begin
  if Assigned(ParentShellFolder) then
  begin
    if Assigned(APIDLArray) then
      ContextMenu := InternalGetContextMenuInterface(APIDLArray)
    else
      ContextMenu := ContextMenuInterface;

    if Assigned(ContextMenu) then
      ContextMenu.QueryInterface(IID_IContextMenu2, ContextMenu2);
    Menu := CreatePopupMenu;
    if Assigned(ContextMenu) or Assigned(ContextMenu2) then
    begin
      try
        if Assigned(ContextMenu2) then
          ContextMenu2.QueryContextMenu(Menu, 0, 1, $7FFF, CMF_NORMAL or CMF_EXPLORE)
        else
          ContextMenu.QueryContextMenu(Menu, 0, 1, $7FFF, CMF_NORMAL or CMF_EXPLORE);
        FillChar(InvokeInfo, SizeOf(InvokeInfo), #0);

        if IsUnicode then
        begin
          SetLength(VerbW, MaxVerbLen);
          GenericVerb := @VerbW[1];
        end
        else begin
          SetLength(VerbA, MaxVerbLen);
          GenericVerb := @VerbA[1];;
          AVerbA := AVerb
        end;

        VerbFound := False;
        i := 0;
        { The result of using the 'verb' string and the MakeIntResource is      }
        { different expecially on system folders.  This forces it to use        }
        { MakeIntResource if it can.                                            }
        while (i < GetMenuItemCount(Menu)) and not VerbFound do
        begin
          MenuID := GetMenuItemID(Menu, i);
          if (MenuID <> $FFFFFFFF) and (MenuID > 0) then
          begin
            FillChar(GenericVerb^, Length(VerbW) * 2, #0);
            if IsUnicode then
            begin
              if Assigned(ContextMenu2) then
                StrFound := Succeeded(ContextMenu2.GetCommandString(MenuID-1, GCS_VERBW, nil, GenericVerb, MaxVerbLen))
              else
                StrFound := Succeeded(ContextMenu.GetCommandString(MenuID-1, GCS_VERBW, nil, GenericVerb, MaxVerbLen));
              if StrFound then
              begin
                SetLength(VerbW, StrLenW(PWideChar( VerbW)));
                if lstrcmpiW_VST(PWideChar(VerbW), PWideChar(AVerb)) = 0 then
                begin
                  InvokeInfo.fMask := CMIC_MASK_UNICODE;
                  { For some reason the lpVerbW won't work }
                  InvokeInfo.lpVerb := MakeIntResourceA(MenuID-1);
                  InvokeInfo.lpVerbW := MakeIntResourceW(MenuID-1);
                  VerbFound := True
                end;
                SetLength(VerbW, MaxVerbLen);
              end
            end else
            begin
              if Assigned(ContextMenu2) then
                StrFound := Succeeded(ContextMenu2.GetCommandString(MenuID-1, GCS_VERB, nil, GenericVerb, MaxVerbLen))
              else
                StrFound := Succeeded(ContextMenu.GetCommandString(MenuID-1, GCS_VERB, nil, GenericVerb, MaxVerbLen));
              if StrFound then
              begin
                SetLength(VerbA, StrLen(PChar( VerbA)));
                if lstrcmpi(PChar( VerbA), PChar(AVerbA)) = 0 then
                begin
                  InvokeInfo.lpVerb := MakeIntResourceA(MenuID-1);
                  VerbFound := True
                end;
                SetLength(VerbA, MaxVerbLen);
              end
            end
          end;
          Inc(i)
        end;

        if not VerbFound then
        begin
          if IsUnicode then
          begin
            InvokeInfo.fMask := CMIC_MASK_UNICODE;
            InvokeInfo.lpVerbW := PWideChar( AVerb)
          end else
            InvokeInfo.lpVerb := PChar( AVerbA);
        end;

        if IsUnicode then
          InvokeInfo.cbSize := SizeOf(TCMInvokeCommandInfoEx)
        else
          InvokeInfo.cbSize := SizeOf(TCMInvokeCommandInfo);
        if MessageWindowParent = 0 then
          InvokeInfo.hWnd := Application.Handle
        else
          InvokeInfo.hWnd := MessageWindowParent;
        InvokeInfo.nShow := SW_SHOWNORMAL;
        if Assigned(ContextMenu2) then
          Result := Succeeded(ContextMenu2.InvokeCommand(InvokeInfo))
        else
          Result := Succeeded(ContextMenu.InvokeCommand(InvokeInfo))
      finally
        if Menu <> 0 then
          DestroyMenu(Menu);
      end;
    end else
      Result := False
  end else
    Result := False
end;

function TNamespace.FolderSize(Invalidate: Boolean; RecurseFolder: Boolean = False): Int64;
begin
  if not(scFolderSize in ShellCache.ShellCacheFlags) or Invalidate then
  begin
    if Folder and FileSystem then
      FShellCache.Data.FolderSize := CalcuateFolderSize(NameForParsing, RecurseFolder);
    Include(FShellCache.ShellCacheFlags, scFolderSize);
  end;
  Result := FShellCache.Data.FolderSize
end;

function TNamespace.ExplorerStyleAttributeStringList(CapitalLetters: Boolean): WideString;
begin
  Result := '';
  if Archive then
    Result := Result + STR_ARCHIVE;
  if Hidden then
    Result := Result + STR_HIDDEN;
  if ReadOnlyFile then
    Result := Result + STR_READONLY;
  if SystemFile then
    Result := Result + STR_SYSTEM;
  if Compressed then
    Result := Result + STR_COMPRESS;
  if not CapitalLetters then
    Result := AnsiLowerCase(Result)
end;

function TNamespace.GetArchive: Boolean;
{ GETTER: Does the file attributes contain Archive?                             }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_ARCHIVE <> 0
    else
      Result := False;
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_ARCHIVE <> 0
    else
      Result := False;
  end
end;

function TNamespace.GetAttributesString: WideString;
begin
  if FileSystem then
    Result := ExplorerStyleAttributeStringList(True)
  else
    Result := ''
end;

function TNamespace.GetBrowsable: Boolean;
begin
  Result := TestAttributesOf(SFGAO_BROWSABLE, False)
end;

function TNamespace.GetCanCopy: Boolean;
begin
  if not (scCanCopy in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_CANCOPY, False) then
      Include(FShellCache.Data.Attributes, caCanCopy);
    Include(FShellCache.ShellCacheFlags, scCanCopy);
  end;
  Result := caCanCopy in ShellCache.Data.Attributes
end;

function TNamespace.GetCanDelete: Boolean;
{ GETTER: Can we delete the namespace?                                          }
begin
  if not (scCanDelete in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_CANDELETE, False) then
      Include(FShellCache.Data.Attributes, caCanDelete);
    Include(FShellCache.ShellCacheFlags, scCanDelete);
  end;
  Result := caCanDelete in ShellCache.Data.Attributes
end;

function TNamespace.GetCanLink: Boolean;
begin
  if not (scCanLink in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_CANLINK, False) then
      Include(FShellCache.Data.Attributes, caCanLink);
    Include(FShellCache.ShellCacheFlags, scCanLink);
  end;
  Result := caCanLink in ShellCache.Data.Attributes
end;

function TNamespace.GetCanMove: Boolean;
begin
  if not (scCanMove in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_CANMOVE, False) then
      Include(FShellCache.Data.Attributes, caCanMove);
    Include(FShellCache.ShellCacheFlags, scCanMove);
  end;
  Result := caCanMove in ShellCache.Data.Attributes
end;

function TNamespace.GetCanRename: Boolean;
{ GETTER: Can we Rename the namespace?                                         }
begin
  if not (scCanRename in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_CANRENAME, False) then
      Include(FShellCache.Data.Attributes, caCanRename);
    Include(FShellCache.ShellCacheFlags, scCanRename);
  end;
  Result := caCanRename in ShellCache.Data.Attributes
end;

function TNamespace.GetCLSID: TGUID;
var
  DescriptionID: TSHDESCRIPTIONID;
  PersistFolder: IPersistFolder;
begin
  Result := GUID_NULL;
  if Assigned(ParentShellFolder) then
    if Succeeded(SHGetDataFromIDList(ParentShellFolder, RelativePIDL, SHGDFIL_DESCRIPTIONID, @DescriptionID, SizeOf(TSHDESCRIPTIONID))) then
      Result := DescriptionID.Id;
  if IsEqualGUID(Result, GUID_NULL) then
  begin
    if Succeeded(ShellFolder.QueryInterface(IPersistFolder, PersistFolder)) then
      if not Succeeded(PersistFolder.GetClassID(Result)) then
        Result := GUID_NULL;
  end;
end;

function TNamespace.GetCompressed: Boolean;
{ GETTER: Does the file attributes contain Compressed?                          }
begin
  if not (scCompressed in ShellCache.ShellCacheFlags) then
  begin
    if IsUnicode then
    begin
      if not Assigned(FWin32FindDataW) then
        GetDataFromIDList;
      if Assigned(FWin32FindDataW) and FileSystem then
        if FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_COMPRESSED <> 0 then
          Include(FShellCache.Data.Attributes, caCompressed)
    end else
    begin
      if not Assigned(FWin32FindDataA) then
        GetDataFromIDList;
      if Assigned(FWin32FindDataA) and FileSystem then
        if FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_COMPRESSED <> 0 then
          Include(FShellCache.Data.Attributes, caCompressed)
    end;
    Include(FShellCache.ShellCacheFlags, scCompressed);
  end;
  Result := caCompressed in ShellCache.Data.Attributes;
end;

function TNamespace.GetContextMenuInterface: IContextMenu;
var
  PIDLArray: TRelativePIDLArray;
begin
  if not Assigned(Result) then
  begin
    SetLength(PIDLArray, 1);
    PIDLArray[0] := RelativePIDL;
    Result := InternalGetContextMenuInterface(PIDLArray);
  end
end;

function TNamespace.GetContextMenu2Interface: IContextMenu2;
var
  Found: Boolean;
  ContextMenu: IContextmenu;
begin
  Found := False;
  ContextMenu := ContextMenuInterface;
  if Assigned(ContextMenu) then
  begin
    Found := ContextMenu.QueryInterface(IID_IContextMenu2, Pointer(Result)) <>  E_NOINTERFACE;
    CurrentContextMenu2 := Result
  end;
  if not Found then
    Result := nil
end;

function TNamespace.GetContextMenu3Interface: IContextMenu3;
var
  Found: Boolean;
  ContextMenu: IContextmenu;
begin
  Found := False;
  ContextMenu := ContextMenuInterface;
  if Assigned(ContextMenu) then
  begin
    Found := ContextMenu.QueryInterface(IContextMenu3, Pointer(Result)) <>  E_NOINTERFACE;
    CurrentContextMenu2 := Result
  end;
  if not Found then
    Result := nil
end;

function TNamespace.GetCreationTime: WideString;
{ GETTER: Creation time of the file.                                            }
begin
  if not (scCreationTime in ShellCache.ShellCacheFlags) then
  begin
    { Don't use Win32FindData cache, re-read the file times }
    GetFileTimes;

    if IsUnicode then
    begin
      if Assigned(FWin32FindDataW) and FileSystem then
        FShellCache.Data.CreationTime := ConvertTFileTimeToLocalStr(FWin32FindDataW^.ftCreationTime)
      else
        FShellCache.Data.CreationTime := '';
    end else
    begin
      if Assigned(FWin32FindDataA) and FileSystem then
        FShellCache.Data.CreationTime := ConvertTFileTimeToLocalStr(FWin32FindDataA^.ftCreationTime)
      else
        FShellCache.Data.CreationTime := '';
    end;
    Include(FShellCache.ShellCacheFlags, scCreationTime);
  end;
  Result := ShellCache.Data.CreationTime
end;

function TNamespace.GetCreationDateTime: TDateTime;
begin
  Result :=  ConvertFileTimetoDateTime(CreationTimeRaw)
end;

function TNamespace.GetCreationTimeRaw: TFileTime;
begin
  { Don't use Win32FindData cache, re-read the file times }
  GetFileTimes;

  if IsUnicode then
  begin
    if Assigned(FWin32FindDataW) then
      Result := FWin32FindDataW^.ftCreationTime
    else
      FillChar(Result, SizeOf(Result), #0);
  end else
  begin
    if Assigned(FWin32FindDataA) then
      Result := FWin32FindDataA^.ftCreationTime
    else
      FillChar(Result, SizeOf(Result), #0);
  end
end;

procedure TNamespace.GetDataFromIDList;
{ Retrieves and caches the Data stored by the shell PIDL.                       }
var
  Error: Boolean;
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) and not IsDesktop then
    begin
      if not (scInvalidIDListData in ShellCache.ShellCacheFlags) then
      begin
        Error := True;
        try
          if Assigned(ParentShellFolder) then
          begin
            GetMem(FWin32FindDataW, SizeOf(TWin32FindDataW));
            FillChar(FWin32FindDataW^, SizeOf(FWin32FindDataW^), #0);
            { Children of the Desktop won't work if accessed from the Desktop       }
            { ShellFolder, they must use the physical Desktop folder.               }
            if Assigned(Parent) and (Parent.IsDesktop) and Assigned(PhysicalDesktopFolder) then
            begin
              Error := SHGetDataFromIDListW_VST(PhysicalDesktopFolder.ShellFolder, RelativePIDL,
                SHGDFIL_FINDDATA, FWin32FindDataW, SizeOf(TWin32FindDataW)) <> NOERROR;
            end else
              Error := SHGetDataFromIDListW_VST(ParentShellFolder, RelativePIDL, SHGDFIL_FINDDATA,
                         FWin32FindDataW, SizeOf(TWin32FindDataW)) <> NOERROR;
          end
        finally
          if Error then
          begin
            if Assigned(FWin32FindDataW) then
              FreeMem(FWin32FindDataW, SizeOf(TWin32FindDataW));
            FWin32FindDataW := nil;
            Include(FShellCache.ShellCacheFlags, scInvalidIDListData)
          end
        end;
      end
    end
  end else
  begin
    if not Assigned(FWin32FindDataA) and not IsDesktop then
    begin
      if not (scInvalidIDListData in ShellCache.ShellCacheFlags) then
      begin
        Error := True;
        try
          if Assigned(ParentShellFolder) then
          begin
            GetMem(FWin32FindDataA, SizeOf(TWin32FindDataA));
            FillChar(FWin32FindDataA^, SizeOf(TWin32FindDataA), #0);
            { Children of the Desktop won't work if accessed from the Desktop       }
            { ShellFolder, they must use the physical Desktop folder.               }
            if Assigned(Parent) and (Parent.IsDesktop) and Assigned(PhysicalDesktopFolder) then
            begin
              Error := SHGetDataFromIDListA(PhysicalDesktopFolder.ShellFolder, RelativePIDL,
                SHGDFIL_FINDDATA, FWin32FindDataA, SizeOf(TWin32FindDataA)) <> NOERROR;
            end else
              Error := SHGetDataFromIDListA(ParentShellFolder, RelativePIDL, SHGDFIL_FINDDATA,
                         FWin32FindDataA, SizeOf(TWin32FindDataA)) <> NOERROR;
          end
        finally
          if Error then
          begin
            if Assigned(FWin32FindDataA) then
              FreeMem(FWin32FindDataA, SizeOf(TWin32FindDataA));
            FWin32FindDataA := nil;
            Include(FShellCache.ShellCacheFlags, scInvalidIDListData)
          end
        end;
      end
    end
  end
end;

function TNamespace.GetDataObjectInterface: IDataObject;
begin
  Result := InternalGetDataObjectInterface(nil)
end;

function TNamespace.GetDescription: TObjectDescription;
var
  DescriptionID: TSHDESCRIPTIONID;
begin
  Result := odError;
  if Assigned(ParentShellFolder) then
  begin
    if Succeeded(SHGetDataFromIDList(ParentShellFolder, RelativePIDL, SHGDFIL_DESCRIPTIONID, @DescriptionID, SizeOf(TSHDESCRIPTIONID))) then
      Result := TObjectDescription(DescriptionID.dwDescriptionId)
  end
end;

function TNamespace.GetDetailsSupported: Boolean;
begin
  { IShellDetails depends on the parent folder implementing the interface }
  if Assigned(Parent) then
    Result := Assigned(Parent.ShellFolder2) or Assigned(ParentShellDetailsInterface)
  else
    Result := False
end;

function TNamespace.GetDirectory: Boolean;
{ GETTER: Does the file attributes contain Directory?                           }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0
    else
      Result := False;
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0
    else
      Result := False;
  end
end;

function TNamespace.GetDropTarget: Boolean;
{ GETTER: Can we drop another object on this namespace?  Note the Desktop is    }
{ handled as a special case.  The IDropTarget is mapped to the physical folder  }
{ location in the DropTargetInterface property.                                 }
begin
  Result := TestAttributesOf(SFGAO_DROPTARGET, False) or
    PIDLMgr.IsDesktopFolder(RelativePIDL);
end;

function TNamespace.GetDropTargetInterface: IDropTarget;
var
  Found: Boolean;
  {$IFDEF VIRTUALNAMESPACES}
  Folder: IShellFolder;
  {$ENDIF}
begin
  if not Assigned(FDropTargetInterface) then
  begin
    {$IFDEF VIRTUALNAMESPACES}
    Found := False;
    if IsHookedNamespace then
    begin
      // Allow the VirtualNamespace to create a DropTarget on the Hooked namespace.
      Folder := NamespaceExtensionFactory.VirtualHook(AbsolutePIDL);
      Found := Succeeded(Folder.CreateViewObject(0, IID_IDropTarget, Pointer(FDropTargetInterface)));
    end;
    if not Found and Assigned(ParentShellFolder) then
      Found := ParentShellFolder.GetUIObjectOf(0, 1, FRelativePIDL,
        IID_IDropTarget, nil, Pointer(FDropTargetInterface)) = NOERROR;

    if not Found and IsDesktop then
      FDropTargetInterface := PhysicalDesktopFolder.DropTargetInterface;

    {$ELSE}
    Found := False;
    if Assigned(ParentShellFolder) then
    begin
      Found := ParentShellFolder.GetUIObjectOf(0, 1, FRelativePIDL,
        IID_IDropTarget, nil, Pointer(FDropTargetInterface)) = NOERROR;
    end;
    if not Found and IsDesktop then
      FDropTargetInterface := PhysicalDesktopFolder.DropTargetInterface;
    {$ENDIF}
  end;
  Result := FDropTargetInterface
end;

function TNamespace.GetExtension: WideString;
begin
  Result := ExtractFileExtW(NameForParsingInFolder);
end;

function TNamespace.GetExtractImage: TExtractImage;
begin
  if not Assigned(FExtractImage) then
  begin
    FExtractImage := TExtractImage.Create;
    FExtractImage.Owner := Self
  end;
  Result := FExtractImage
end;

function TNamespace.GetExtractIconAInterface: IExtractIcon;
var
  Found: Boolean;
begin
  if Assigned(ParentShellFolder) then
  begin
    Found := Succeeded(ParentShellFolder.GetUIObjectOf(0, 1, FRelativePIDL, IExtractIconA, nil, Pointer(Result)));
    if not Found and Assigned(ShellFolder) then
      Found := Succeeded(ShellFolder.CreateViewObject(0, IExtractIconA, Pointer(Result)));
    if not Found then
      Result := nil
  end
end;

function TNamespace.GetExtractIconWInterface: IExtractIconW;
var
  Found: Boolean;
begin
  if Assigned(ParentShellFolder) then
  begin
    Found := Succeeded(ParentShellFolder.GetUIObjectOf(0, 1, FRelativePIDL, IExtractIconW, nil, Pointer(Result)));
    if not Found and Assigned(ShellFolder) then
      Found := Succeeded(ShellFolder.CreateViewObject(0, IExtractIconW, Pointer(Result)));
    if not Found then
      Result := nil
  end
end;

function TNamespace.GetFileName: WideString;
{ GETTER: FileName from the file system (FindFirst)                             }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.cFileName
    else
      Result := '';
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.cFileName
    else
      Result := '';
  end
end;

function TNamespace.GetFileSysAncestor: Boolean;
// Only works reliablely on Win2k and above
begin
  if not (scFileSysAncestor in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_FILESYSANCESTOR, False) then
      Include(FShellCache.Data.Attributes, caFileSysAncestor);
    Include(FShellCache.ShellCacheFlags, scFileSysAncestor);
  end;
  Result := caFileSysAncestor in ShellCache.Data.Attributes
end;

function TNamespace.GetFileSystem: Boolean;
{ GETTER: Is the namespace part of the physical file system?                    }
begin
  if not (scFileSystem in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_FILESYSTEM, False) then
      Include(FShellCache.Data.Attributes, caFileSystem);
    Include(FShellCache.ShellCacheFlags, scFileSystem);
  end;
  Result := caFileSystem in ShellCache.Data.Attributes
end;

procedure TNamespace.GetFileTimes;
var
  Handle: THandle;
  FileDataA: TWin32FindData;
  FileDataW: TWin32FindDataW;
  S: string;
begin
  if not (scFileTimes in ShellCache.ShellCacheFlags) then
  begin
    if IsUnicode then
    begin
      if not Assigned(FWin32FindDataW) then
        GetDataFromIDList;
      if FileSystem and Assigned(FWin32FindDataW)  then
      begin
        FillChar(FileDataW, SizeOf(FileDataW), #0);
        Handle := FindFirstFileW_VST(PWideChar( NameParseAddress), FileDataW);
        if Handle <> INVALID_HANDLE_VALUE then
        begin
          Windows.FindClose(Handle); // There is no FindCloseW
          FWin32FindDataW.ftLastAccessTime := FileDataW.ftLastAccessTime;
          FWin32FindDataW.ftCreationTime := FileDataW.ftCreationTime;
          FWin32FindDataW.ftLastWriteTime := FileDataW.ftLastWriteTime
        end
      end;
    end else
    begin
      if not Assigned(FWin32FindDataA) then
        GetDataFromIDList;
      if FileSystem and Assigned(FWin32FindDataA)  then
      begin
        FillChar(FileDataA, SizeOf(FileDataA), #0);
        S := NameParseAddress;
        Handle := FindFirstFileA(PChar( S), FileDataA);
        if Handle <> INVALID_HANDLE_VALUE then
        begin
          Windows.FindClose(Handle);  // There is no ASCI and Wide version
          FWin32FindDataA.ftLastAccessTime := FileDataA.ftLastAccessTime;
          FWin32FindDataA.ftCreationTime := FileDataA.ftCreationTime;
          FWin32FindDataA.ftLastWriteTime := FileDataA.ftLastWriteTime
        end
      end;
    end;
    Include(FShellCache.ShellCacheFlags, scFileTimes)
  end;
end;

function TNamespace.GetFileType: WideString;
// File type string shown in column 3 of Explorer Listview
begin
  if not (scFileType in ShellCache.ShellCacheFlags) then
  begin
    if not Assigned(FSHGetFileInfoRec) then
      GetSHFileInfo;
    if Assigned(FSHGetFileInfoRec) then
    begin
      FShellCache.Data.FileType := FSHGetFileInfoRec^.FileType;
     { NT only half-assed supports the SHGetFileInfo...only if the ext is      }
     { associated with a program. So we build it ourselves                     }
      if FShellCache.Data.FileType = '' then
        FShellCache.Data.FileType := AnsiUpperCase(ExtractFileExtW(NameForParsing)) + STR_FILE;
    end else
      FShellCache.Data.FileType := '';
    Include(FShellCache.ShellCacheFlags, scFileType);
  end;
  Result := ShellCache.Data.FileType
end;

function TNamespace.GetFolder: Boolean;
// Ask the Folder if it is a Folder, as opposed to files.  Folders can  contain
// other objects.                                                        
begin
  if not (scFolder in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_FOLDER, False) then
      Include(FShellCache.Data.Attributes, caFolder);
    Include(FShellCache.ShellCacheFlags, scFolder);
  end;
  Result := caFolder in ShellCache.Data.Attributes;
end;

function TNamespace.GetFreePIDLOnDestroy: Boolean;
begin
  Result := nsFreePIDLOnDestroy in States
end;

function TNamespace.GetGhosted: Boolean;
// Ask the Folder if it is a ghosted file object. Partially encapsulates the
// IShellFolder.GetAttributesOf function.
begin
  if not (scGhosted in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_GHOSTED, False) then
      Include(FShellCache.Data.Attributes, caGhosted);
    Include(FShellCache.ShellCacheFlags, scGhosted);
  end;
  Result := caGhosted in ShellCache.Data.Attributes
end;

function TNamespace.GetHasPropSheet: Boolean;
begin
  Result := TestAttributesOf(SFGAO_HASPROPSHEET, False);
end;

function TNamespace.GetHasSubFolder: Boolean;
begin
  Result := TestAttributesOf(SFGAO_HASSUBFOLDER, False);
end;

function TNamespace.GetHidden: Boolean;
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN <> 0
    else
      Result := False;
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN <> 0
    else
      Result := False;
  end
end;

function TNamespace.GetIconIndexChanged: Boolean;
begin
  Result := nsIconIndexChanged in States
end;

function TNamespace.GetIconIndex(OpenIcon: Boolean; IconSize: TIconSize; ForceLoad: Boolean = True): integer;
{ Retrieve the Icon Index either selected or not selected (open folder or       }
{ closed folder)                                                                }

  function GetIconByIShellIcon(AnOpenIcon: Boolean; Size: TIconSize; var Index: integer): Boolean;
  var
    Flags: Longword;
  begin
    Result := False;
    if Assigned(ShellIconInterface) then
    begin
      Flags := 0;
      if Size = icLarge then
        Flags := GIL_FORSHELL;
      if AnOpenIcon then
        Flags := GIL_OPENICON or Flags;
      Result := ShellIconInterface.GetIconOf(RelativePIDL, Flags, Index) = NOERROR
    end
  end;

  procedure GetIconBySHGetFileInfo(AnOpenIcon: Boolean; Size: TIconSize; var Index: Integer);
  { A little undocumented trick.  If you use the SHGFI_USEFILEATTRIBUTES flags  }
  { the SHGetFileInfo function does not fully access the object and is much     }
  { faster.                                                                     }
  { UPDATE: Unfortunatly this does not work well in Win98 :^(                   }
  var
    Flags: integer;
    InfoA: TSHFileInfoA;
    InfoW: TSHFileInfoW;
  begin
    Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_SHELLICONSIZE;
    if IconSize = icLarge then
      Flags := Flags or SHGFI_LARGEICON
    else
      Flags := Flags or SHGFI_SMALLICON;
    if AnOpenIcon then
      Flags := Flags or SHGFI_OPENICON;
    if IsUnicode then
    begin
      FillChar(InfoW, SizeOf(InfoW), #0);
      if SHGetFileInfoW_VST(PWideChar(AbsolutePIDL), 0, InfoW, SizeOf(InfoW), Flags) <> 0 then
        Index := InfoW.iIcon
      else
        Index := 0
    end else
    begin
      FillChar(InfoA, SizeOf(InfoA), #0);
      if SHGetFileInfoA(PChar(AbsolutePIDL), 0, InfoA, SizeOf(InfoA), Flags) <> 0 then
        Index := InfoA.iIcon
      else
        Index := 0
    end
  end;

  function GetIcon(IsOpen: Boolean; IconSize: TIconSize): integer;
  begin
    if not GetIconByIShellIcon(IsOpen, IconSize, Result) then
      GetIconBySHGetFileInfo(IsOpen, IconSize, Result);
  end;

begin
  if not OpenIcon then
  begin
    if not (scSmallIcon in ShellCache.ShellCacheFlags) or ForceLoad then
    begin
      FShellCache.Data.SmallIcon := GetIcon(False, icSmall);
      Include(FShellCache.ShellCacheFlags, scSmallIcon);
    end;
    Result := ShellCache.Data.SmallIcon;
  end else
  begin
    if not (scSmallOpenIcon in ShellCache.ShellCacheFlags) or ForceLoad then
    begin
      { Some Control panel icons return 0 for open but have icons for not open }
      { and it looks bad to show the default icon when the item is selected.   }
      { In NT4 some ControlPanel icons are the Mouse icons when selected! }
      if Assigned(Parent) and Parent.IsControlPanel then
        FShellCache.Data.SmallOpenIcon := GetIcon(False, icSmall)
      else begin
        FShellCache.Data.SmallOpenIcon := GetIcon(True, icSmall);
        { If it is 0 then try the normal icon }
        if FShellCache.Data.SmallOpenIcon = 0 then
          FShellCache.Data.SmallOpenIcon := GetIcon(False, icSmall)
      end;

      Include(FShellCache.ShellCacheFlags, scSmallOpenIcon)
    end;
    Result := ShellCache.Data.SmallOpenIcon;
  end;
end;

function TNamespace.GetInfoTip: WideString;
{ Retrieves the text from the IInfoTip interface in Win2k.                      }
var
  Buffer: PWideChar;
begin
  Result := '';
  if Assigned(QueryInfoInterface) then
  begin
    if QueryInfoInterface.GetInfoTip(0, Buffer) = S_OK then
    begin
      Result := Buffer;
      PIDLMgr.FreeOLEStr(Buffer);
    end;
  end;
end;

function TNamespace.GetLastAccessTime: WideString;
{ GETTER: Last Access time of the file.                                         }
begin
  if not (scLastAccessTime in ShellCache.ShellCacheFlags) then
  begin
    { Don't use Win32FindData cache, re-read the file times }
    GetFileTimes;
    
    if IsUnicode then
    begin
      if Assigned(FWin32FindDataW) and FileSystem then
        FShellCache.Data.LastAccessTime := ConvertTFileTimeToLocalStr(FWin32FindDataW^.ftLastAccessTime)
      else
        FShellCache.Data.LastAccessTime := '';
    end else
    begin
      if Assigned(FWin32FindDataA) and FileSystem then
        FShellCache.Data.LastAccessTime := ConvertTFileTimeToLocalStr(FWin32FindDataA^.ftLastAccessTime)
      else
        FShellCache.Data.LastAccessTime := '';
    end;
    Include(FShellCache.ShellCacheFlags, scLastAccessTime);
  end;
  Result := FShellCache.Data.LastAccessTime
end;

function TNamespace.GetLastAccessDateTime: TDateTime;
begin
  Result := ConvertFileTimetoDateTime(LastAccessTimeRaw)
end;

function TNamespace.GetLastAccessTimeRaw: TFileTime;
begin
  { Don't use Win32FindData cache, re-read the file times }
  GetFileTimes;

  if IsUnicode then
  begin
    if Assigned(FWin32FindDataW) then
      Result := FWin32FindDataW^.ftLastAccessTime
    else
      FillChar(Result, SizeOf(Result), #0);
  end else
  begin
    if Assigned(FWin32FindDataA) then
      Result := FWin32FindDataA^.ftLastAccessTime
    else
      FillChar(Result, SizeOf(Result), #0);
  end
end;


function TNamespace.GetLastWriteTime: WideString;
{ GETTER: Last write time for the file.                                         }
begin
  if not (scLastWriteTime in ShellCache.ShellCacheFlags) then
  begin
    { Don't use Win32FindData cache, re-read the file times }
    GetFileTimes;

    if IsUnicode then
    begin
      if Assigned(FWin32FindDataW) and FileSystem then
        FShellCache.Data.LastWriteTime := ConvertTFileTimeToLocalStr(FWin32FindDataW^.ftLastWriteTime)
      else
        FShellCache.Data.LastWriteTime := '';
    end else
    begin
      if Assigned(FWin32FindDataA) and FileSystem then
        FShellCache.Data.LastWriteTime := ConvertTFileTimeToLocalStr(FWin32FindDataA^.ftLastWriteTime)
      else
        FShellCache.Data.LastWriteTime := '';
    end;
    Include(FShellCache.ShellCacheFlags, scLastWriteTime);
  end;
  Result := FShellCache.Data.LastWriteTime
end;

function TNamespace.GetLastWriteDateTime: TDateTime;
begin
  Result :=  ConvertFileTimetoDateTime(LastWriteTimeRaw)
end;

function TNamespace.GetLastWriteTimeRaw: TFileTime;
{ GETTER: Last Write time for the file in raw TFileTime format.                 }
begin
  { Don't use Win32FindData cache, re-read the file times }
  GetFileTimes;

  if IsUnicode then
  begin
    if Assigned(FWin32FindDataW) then
      Result := FWin32FindDataW^.ftLastWriteTime
    else
      FillChar(Result, SizeOf(Result), #0);
  end else
  begin
    if Assigned(FWin32FindDataA) then
      Result := FWin32FindDataA^.ftLastWriteTime
    else
      FillChar(Result, SizeOf(Result), #0);
  end
end;

function TNamespace.GetLink: Boolean;
begin
  if not (scLink in ShellCache.ShellCacheFlags) then
  begin
    if TestAttributesOf(SFGAO_LINK, False) then
      Include(FShellCache.Data.Attributes, caLink);
    Include(FShellCache.ShellCacheFlags, scLink);
  end;
  Result := caLink in ShellCache.Data.Attributes
end;

function TNamespace.GetNameAddressbar: WideString;
begin
  Result := DisplayNameOf(SHGDN_FORADDRESSBAR or SHGDN_NORMAL)
end;

function TNamespace.GetNameAddressbarInFolder: WideString;
begin
  Result := DisplayNameOf(SHGDN_INFOLDER or SHGDN_FORADDRESSBAR)
end;

function TNamespace.GetNameForEditing: WideString;
begin
  Result := DisplayNameOf(SHGDN_FOREDITING)
end;

function TNamespace.GetNameForEditingInFolder: WideString;
begin
  Result := DisplayNameOf(SHGDN_FOREDITING or SHGDN_INFOLDER)
end;

function TNamespace.GetNameForParsing: WideString;
begin
  // Early versions of Windows returned "Desktop" instead of the full path
  if IsDesktop then
    Result := PhysicalDesktopFolder.NameForParsing
  else
    Result := DisplayNameOf(SHGDN_FORPARSING or SHGDN_NORMAL)
end;

function TNamespace.GetNameForParsingInFolder: WideString;
begin
// Early versions of Windows returned "Desktop" instead of the full path
  if IsDesktop then
    Result := PhysicalDesktopFolder.NameForParsingInFolder
  else
  Result := DisplayNameOf(SHGDN_INFOLDER or SHGDN_FORPARSING)
end;

function TNamespace.GetNameInFolder: WideString;
begin
  if not (scInFolderName in ShellCache.ShellCacheFlags) then
  begin
    FShellCache.Data.InFolderName := DisplayNameOf(SHGDN_INFOLDER);
    Include(FShellCache.ShellCacheFlags, scInFolderName)
  end;
  Result := FShellCache.Data.InFolderName
end;

function TNamespace.GetNameNormal: WideString;
begin
  if not (scNormalName in ShellCache.ShellCacheFlags) then
  begin
    FShellCache.Data.NormalName := DisplayNameOf(SHGDN_NORMAL);
    Include(FShellCache.ShellCacheFlags, scNormalName)
  end;
  Result := FShellCache.Data.NormalName
end;

function TNamespace.GetNameParseAddress: WideString;
begin
  if not (scParsedName in ShellCache.ShellCacheFlags) then
  begin
    FShellCache.Data.ParsedName := DisplayNameOf(SHGDN_FORADDRESSBAR or SHGDN_FORPARSING);
    Include(FShellCache.ShellCacheFlags, scParsedName)
  end;
  Result := FShellCache.Data.ParsedName
end;

function TNamespace.GetNameParseAddressInFolder: WideString;
begin
  Result := DisplayNameOf(SHGDN_FORADDRESSBAR or SHGDN_FORPARSING or SHGDN_INFOLDER)
end;

function TNamespace.GetNewContent: Boolean;
{ GETTER: Does this namespace contain new content?                             }
begin
  Result := TestAttributesOf(SFGAO_NEWCONTENT, False);
end;

function TNamespace.GetNonEnumerated: Boolean;
{ GETTER: Is this namespace able to be enumerated?                              }
begin
  Result := TestAttributesOf(SFGAO_NONENUMERATED, False);
end;

function TNamespace.GetNormal: Boolean;
{ GETTER: Does the file attributes contain Normal?                             }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_NORMAL <> 0
    else
      Result := False;
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_NORMAL <> 0
    else
      Result := False;
  end
end;

function TNamespace.GetOffLine: Boolean;
{ GETTER: Does the file attributes contain OffLine?                             }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_OFFLINE <> 0
    else
      Result := False;
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_OFFLINE <> 0
    else
      Result := False;
  end
end;

function TNamespace.GetImage: TBitmap;
begin
 Result := FImage;
end;

procedure TNamespace.InvalidateThumbImage;
begin
  FreeAndNIL(FImage);
  Exclude(FStates, nsThreadedImageLoaded);
  Exclude(FStates, nsThreadedImageLoading);
end;

function TNamespace.SubFoldersEx(Flags: Longword = SHCONTF_FOLDERS): Boolean;
begin
  Result := InternalSubItems(Flags)
end;

function TNamespace.SubItemsEx(Flags: Longword = SHCONTF_NONFOLDERS): Boolean;
begin
  Result := InternalSubItems(Flags)
end;

function TNamespace.GetOverlayIconIndex: Integer;
begin
  if Assigned(Parent) then
  begin
    if Assigned(Parent.ShellIconOverlayInterface) then
    begin
      if FShellCache.Data.OverlayIconIndex < 0 then
      begin
        if Parent.ShellIconOverlayInterface.GetOverlayIconIndex(FRelativePIDL, FShellCache.Data.OverlayIconIndex) <> S_OK then
          FShellCache.Data.OverlayIconIndex := -1;
      end
    end
  end;
  Result := FShellCache.Data.OverlayIconIndex
end;

function TNamespace.GetOverlayIndex: Integer;
begin
  if Assigned(Parent) then
  begin
    if not (scOverlayIndex in FShellCache.ShellCacheFlags) then
    begin
      if Assigned(Parent.ShellIconOverlayInterface) then
      begin
        if FShellCache.Data.OverlayIndex < 0 then
        begin
          if Parent.ShellIconOverlayInterface.GetOverlayIndex(FRelativePIDL, FShellCache.Data.OverlayIndex) <> S_OK then
            FShellCache.Data.OverlayIndex := -1;
        end
      end;
      Include(FShellCache.ShellCacheFlags, scOverlayIndex)
    end
  end;
  Result := FShellCache.Data.OverlayIndex
end;

function TNamespace.GetCanMoniker: Boolean;
begin
  Result := TestAttributesOf(SFGAO_CANMONIKER, False)
end;

function TNamespace.GetEncrypted: Boolean;
begin
  Result := TestAttributesOf(SFGAO_ENCRYPTED, False)
end;

function TNamespace.GetHasStorage: Boolean;
begin
  Result := TestAttributesOf(SFGAO_HASSTORAGE, False)
end;

function TNamespace.GetIsSlow: Boolean;
begin
  Result := TestAttributesOf(SFGAO_ISSLOW, False)
end;

function TNamespace.GetStorage: Boolean;
begin
  Result := TestAttributesOf(SFGAO_STORAGE, False)
end;

function TNamespace.GetStorageAncestor: Boolean;
begin
  Result := TestAttributesOf(SFGAO_STORAGEANCESTOR, False)
end;

function TNamespace.GetStream: Boolean;
begin
  Result := TestAttributesOf(SFGAO_STREAM, False)
end;

function TNamespace.GetParentShellDetailsInterface: {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF};
begin
  { This forces the Parent to be created if necessary }
  if Assigned(ParentShellFolder) then
    Result := Parent.ShellDetailsInterface
  else
    Result := ShellDetailsInterface
end;

function TNamespace.GetParentShellFolder: IShellFolder;
var
  P: PItemIDList;
begin
  Result := nil;

  // 08.31.02
  // Going to try to allow the Parent to persist if the namespace creates it itself.
  // This is called a LOT more than I thought expecially for the ExplorerListview

  if Assigned(Parent) then
  begin
    {$IFDEF VIRTUALNAMESPACES}
    // If we are a RootNVS then we always get the Hook IShellFolder for the parent
    // else get the parents IShellFolder
    if IsRootVirtualNamespace then
    begin
      if not Assigned(Parent.FShellFolderHook) then
        Parent.FShellFolderHook := NamespaceExtensionFactory.VirtualHook(Parent.AbsolutePIDL);
      Result := Parent.FShellFolderHook
    end else
      Result := Parent.ShellFolder
    {$ELSE}
    Result := Parent.ShellFolder
    {$ENDIF}
  end else
  if not IsDesktop then
  begin
    if Assigned(Parent) then
      FreeAndNil(FParent);
    P := PIDLMgr.CopyPIDL(AbsolutePIDL);
    FParent := TNamespace.Create(PIDLMgr.StripLastID(P), nil);

    if Assigned(Parent) then
    begin
      {$IFDEF VIRTUALNAMESPACES}
      if IsRootVirtualNamespace then
      begin
        if not Assigned(Parent.FShellFolderHook) then
          Parent.FShellFolderHook := NamespaceExtensionFactory.VirtualHook(Parent.AbsolutePIDL);
        Result := Parent.FShellFolderHook
      end else
        Result := Parent.ShellFolder;
      {$ELSE}
      Result := Parent.ShellFolder;
      {$ENDIF}
      { Since we created the parent we own it in case we have to destroy it in  }
      { our destructor.                                                         }
      Include(FStates, nsOwnsParent);
    end
  end else
    Result := ShellFolder
end;

function TNamespace.GetParentShellFolder2: IShellFolder2;
begin
  { This flag keeps us from constantly trying to get FShellFolder2 if it is not }
  { supported by the namespace.                                                 }
  { This forces the Parent to be created if necessary }
  if Assigned(ParentShellFolder) then
    Result := Parent.ShellFolder2
  else
    Result := ShellFolder2
end;

function TNamespace.GetQueryInfoInterface: IQueryInfo;
var
  Found: Boolean;
begin
  if not Assigned(FQueryInfoInterface) then
  begin
    Found := False;
    if Assigned(ParentShellFolder) then
    begin
      Found := ParentShellFolder.GetUIObjectOf(0, 1, FRelativePIDL,
        IQueryInfo, nil, Pointer(FQueryInfoInterface)) = NOERROR;
    end;
    if not Found and Assigned(ShellFolder) then
    begin
      Found := ShellFolder.CreateViewObject(0, IQueryInfo,
        Pointer(FQueryInfoInterface)) = NOERROR;
    end;
    if not Found and IsDesktop then
      FQueryInfoInterface := PhysicalDesktopFolder.QueryInfoInterface;
  end;
  Result := FQueryInfoInterface
end;

function TNamespace.GetReadOnly: Boolean;
{ GETTER: Is this namespace ReadOnly?                                          }
begin
  Result := TestAttributesOf(SFGAO_READONLY, False);
end;

function TNamespace.GetReadOnlyFile: Boolean;
{ GETTER: Does the file attributes contain ReadOnly?                           }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_READONLY <> 0
    else
      Result := False;
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_READONLY <> 0
    else
      Result := False;
  end
end;

function TNamespace.GetRemovable: Boolean;
{  GETTER: Is this a removeable object?                                         }
begin
  Result := TestAttributesOf(SFGAO_REMOVABLE, False);
end;

function TNamespace.GetShellDetailsInterface: {$IFNDEF CPPB_6_UP}IShellDetails{$ELSE}IShellDetailsBCB6{$ENDIF};
var
  Found: Boolean;
  {$IFDEF VIRTUALNAMESPACES}
  Dummy: PItemIDList;
  Folder: IShellFolder;
  {$ENDIF}
begin
  { This flag keeps us from constantly trying to get IShellDetails if it is not }
  { supported by the namespace.                                                 }
  if (nsShellDetailsSupported in States) and not Assigned(FShellDetailsInterface) then
  begin
    Found := False;

    {$IFDEF VIRTUALNAMESPACES}
    // If the namespace (which is real) is Hard Hooked then we get the Details
    // interface from our VNS implmementation. It knows that it is the HardHooked
    // view by looking at the Child PIDL, it will be nil in this case
    if IsHardHookedNamespace then
    begin
      Folder := NamespaceExtensionFactory.VirtualHook(AbsolutePIDL);
      if Assigned(Folder) then
      begin
        Dummy := nil;
        Found := Folder.GetUIObjectOf(0, 1, Dummy, IID_IShellDetails, nil,
          Pointer(FShellDetailsInterface)) = NOERROR;
      end
    end;
    {$ENDIF}

    if not Found and Assigned(ShellFolder) then
      Found := ShellFolder.CreateViewObject(0, IID_IShellDetails, Pointer(FShellDetailsInterface)) = NOERROR;
    if not Found and Assigned(ParentShellFolder) then
      Found := ParentShellFolder.GetUIObjectOf(0, 1, FRelativePIDL, IID_IShellDetails, nil,
        Pointer(FShellDetailsInterface)) = NOERROR;
    if Found then
      Include(FStates, nsShellDetailsSupported)
    else
    begin
      Exclude(FStates, nsShellDetailsSupported);
      FShellDetailsInterface := nil
    end
  end;
  Result := FShellDetailsInterface;
end;

function TNamespace.GetShellIconInterface: IShellIcon;
var
  Found: Boolean;
begin
  if not Assigned(FShellIconInterface) then
  begin
    Found := False;
    if Assigned(ParentShellFolder) then
      Found :=  ParentShellFolder.QueryInterface(IID_IShellIcon,
        Pointer(FShellIconInterface)) <> E_NOINTERFACE;
    if not Found then
      FShellIconInterface := nil
  end;
  Result := FShellIconInterface
end;

function TNamespace.GetShellFolder: IShellFolder;
begin
  if not Assigned(FShellFolder) then
  begin
    if not Assigned(FShellFolder) then
    {$IFDEF VIRTUALNAMESPACES}
      FShellFolder := NamespaceExtensionFactory.BindToVirtualObject(AbsolutePIDL)
    {$ELSE}
      if PIDLMgr.IsDesktopFolder(AbsolutePIDL) then
        SHGetDesktopFolder(FShellFolder)
      else
      if Assigned(ParentShellFolder) then
      begin
        if not Succeeded(ParentShellFolder.BindToObject(FRelativePIDL, nil, IID_IShellFolder, Pointer(FShellFolder))) then
          FShellFolder := nil
      end else
        FShellFolder := nil
    {$ENDIF}
  end;
  Result := FShellFolder
end;

function TNamespace.GetShellFolder2: IShellFolder2;
begin
  { This flag keeps us from constantly trying to get FShellFolder2 if it is not }
  { supported by the namespace.                                                 }
  {$IFDEF VIRTUALNAMESPACES}
  if (nsShellFolder2Supported in States) and not Assigned(FShellFolder2) and not IsHardHookedNamespace then
  {$ELSE}
  if (nsShellFolder2Supported in States) and not Assigned(FShellFolder2) then
  {$ENDIF}
  begin
    if Assigned(ShellFolder) then
      if ShellFolder.QueryInterface(IID_IShellFolder2, Pointer(FShellFolder2)) = E_NOINTERFACE
    then begin
      FShellFolder2 := nil;
      Exclude(FStates, nsShellFolder2Supported)
    end else
      Include(FStates, nsShellFolder2Supported)
  end;
  Result := FShellFolder2;
end;

function TNamespace.GetShellLink: TVirtualShellLink;
begin
  if not Assigned(FShellLink) then
    FShellLink := TVirtualShellLink.Create(nil);
  FShellLink.ReadLink(NameParseAddress);
  Result := FShellLink
end;

function TNamespace.GetSizeOfFile: WideString;
{ GETTER: Get the size of the file in string format}
begin
  if not (scFileSize in ShellCache.ShellCacheFlags) then
  begin
    if not Folder then
    begin
      FShellCache.Data.FileSize := AddCommas(IntToStrW(SizeOfFileInt64));
      Include(FShellCache.ShellCacheFlags, scFileSize);
    end else
      FShellCache.Data.FileSize := ''
  end;
  Result := ShellCache.Data.FileSize
end;

function TNamespace.GetSizeOfFileDiskUsage: WideString;
var
  Size: Int64;
  Drive: string;
  DriveW: WideString;
  SectorsPerCluster,
  BytesPerSector,
  FreeClusters,
  TotalClusters,
  BytesPerCluster,
  i : DWORD;
  ValidData: Boolean;
begin
  if not Folder then
  begin
    Size := SizeOfFileInt64;
    DriveW := ExtractFileDriveW(Self.NameForParsing) + '\';
    Drive := DriveW;
    if DirExistsW(Drive) then
    begin
      if IsUnicode then
        ValidData := GetDiskFreeSpaceW(
          PWideChar( DriveW), SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters)
      else
      if not IsWin95_SR1 then
        ValidData := GetDiskFreeSpaceFAT32(
          PChar( Drive), SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters)
      else
        ValidData := GetDiskFreeSpaceA(
          PChar( Drive), SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters);

      if ValidData then
      begin
        BytesPerCluster := SectorsPerCluster * BytesPerSector;
        if BytesPerCluster <> 0 then
        begin
          { In the *rare* instance where the actual size is equal to multiple of  }
          { the sector size don't do the math :^)                                 }
          if Size mod BytesPerCluster <> 0 then
            i := 1
          else
            i := 0;
          Result := AddCommas(IntToStrW(BytesPerCluster *(Size div BytesPerCluster + i)))
        end else
          Result := SizeOfFile
      end else
        Result := SizeOfFile
    end else
      Result := SizeOfFile
  end;
end;

function TNamespace.GetSizeOfFileInt64: Int64;
var
  H: THandle;
  FindDataW: TWin32FindDataW;
  FindDataA: TWin32FindDataA;
{ GETTER: Get the file size in bytes.                                           }
// The PIDL does not store the file size for > 4G files, need to use FindFirstFile
begin
  if not (scFileSizeInt64 in ShellCache.ShellCacheFlags) then
  begin
    if FileSystem then
    begin
      if IsUnicode then
      begin
        H := FindFirstFileW_VST(PWideChar(NameForParsing), FindDataW);
        if H <> INVALID_HANDLE_VALUE then
        begin
          Windows.FindClose(H);
          FShellCache.Data.FileSizeInt64 := FindDataW.nFileSizeLow;
          if FShellCache.Data.FileSizeInt64 < 0 then
            FShellCache.Data.FileSizeInt64 := FShellCache.Data.FileSizeInt64 + 4294967296;
          if FindDataW.nFileSizeHigh > 0 then
              FShellCache.Data.FileSizeInt64 := FShellCache.Data.FileSizeInt64 + (FindDataW.nFileSizeHigh * 4294967296)
        end
      end else
      begin
        H := FindFirstFileA(PChar(string(NameForParsing)), FindDataA);
        if H <> INVALID_HANDLE_VALUE then
        begin
          Windows.FindClose(H);
          FShellCache.Data.FileSizeInt64 := FindDataA.nFileSizeLow;
          if FShellCache.Data.FileSizeInt64 < 0 then
            FShellCache.Data.FileSizeInt64 := FShellCache.Data.FileSizeInt64 + 4294967296;
          if FindDataA.nFileSizeHigh > 0 then
            FShellCache.Data.FileSizeInt64 := FShellCache.Data.FileSizeInt64 + (FindDataA.nFileSizeHigh * 4294967296)
        end
      end
    end;
    Include(FShellCache.ShellCacheFlags, scFileSizeInt64)
  end;
  Result := FShellCache.Data.FileSizeInt64
end;

function TNamespace.GetSizeOfFileKB: WideString;
{ GETTER: Get the file  size in Explorer KiloByte format.                       }
begin
  if not (scFileSizeKB in ShellCache.ShellCacheFlags) then
  begin
    if not Folder then
    begin
      FShellCache.Data.FileSizeKB := Format(STR_FILE_SIZE_IN_KB, [Int((SizeOfFileInt64) / 1024)]);
      if FShellCache.Data.FileSizeKB = STR_ZERO_KB then
        FShellCache.Data.FileSizeKB := STR_ONE_KB;
      Include(FShellCache.ShellCacheFlags, scFileSizeKB)
    end else
      FShellCache.Data.FileSizeKB := '';
  end;
  Result := FShellCache.Data.FileSizeKB;
end;

function TNamespace.GetShare: Boolean;
begin
  Result := TestAttributesOf(SFGAO_SHARE, False);
end;

procedure TNamespace.GetSHFileInfo;
{ Retrieves and caches the some information about the namespace with            }
{ ShGetFileInfo.                                                                }
var
  InfoA: TSHFileInfoA;
  InfoW: TSHFileInfoW;
begin
  if not Assigned(FSHGetFileInfoRec) then
  begin
    if IsUnicode then
    begin
      GetMem(FSHGetFileInfoRec, SizeOf(FSHGetFileInfoRec^));
      Initialize(FSHGetFileInfoRec^.FileType);
      if Assigned(FSHGetFileInfoRec) then
      begin
        SHGetFileInfoW_VST(PWideChar(AbsolutePIDL), 0, InfoW, SizeOf(InfoW), SHGFI_TYPENAME or SHGFI_PIDL);
        FSHGetFileInfoRec^.FileType := InfoW.szTypeName;
        { NT only half-assed supports the SHGetFileInfo...only if the ext is      }
        { associated with a program. So we build it ourselves                     }
        if FSHGetFileInfoRec^.FileType = '' then
          FSHGetFileInfoRec^.FileType := AnsiUpperCase(ExtractFileExtW(NameForParsing)) + STR_FILE;
      end
    end else
    begin
      GetMem(FSHGetFileInfoRec, SizeOf(FSHGetFileInfoRec^));
      Initialize(FSHGetFileInfoRec^.FileType);
      if Assigned(FSHGetFileInfoRec) then
      begin
        SHGetFileInfoA(PChar(AbsolutePIDL), 0, InfoA, SizeOf(InfoA), SHGFI_TYPENAME or SHGFI_PIDL);
        FSHGetFileInfoRec^.FileType := InfoA.szTypeName;
        { NT only half-assed supports the SHGetFileInfo...only if the ext is      }
        { associated with a program. So we build it ourselves                     }
        if FSHGetFileInfoRec^.FileType = '' then
          FSHGetFileInfoRec^.FileType := AnsiUpperCase(ExtractFileExtW(NameForParsing)) + STR_FILE;
      end
    end;
  end;
end;

function TNamespace.GetShortFileName: WideString;
{ GETTER: Get the 8:3 short file name (DOS)                                     }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
    begin
      Result := FWin32FindDataW^.cAlternateFileName;
      if Result = '' then
        Result := AnsiUpperCase(FWin32FindDataW^.CFileName)
    end else
      Result := '';
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
    begin
      Result := FWin32FindDataA^.cAlternateFileName;
      if Result = '' then
        Result := AnsiUpperCase(FWin32FindDataA^.CFileName)
    end else
      Result := '';
  end
end;

function TNamespace.GetSubFolders: Boolean;
{ Tests to see if a namespace is a true folder and has at least one             }
{ sub-namespace within it.                                                      }
begin
  Result := InternalSubItems(SHCONTF_FOLDERS or SHCONTF_INCLUDEHIDDEN)
end;

function TNamespace.GetSubItems: Boolean;
{ Tests to see if a namespace is a true folder and has at least one             }
{ sub-namespace within it.                                                      }
begin
  Result := InternalSubItems(SHCONTF_FOLDERS or SHCONTF_NONFOLDERS or SHCONTF_INCLUDEHIDDEN)
end;

function TNamespace.GetSystem: Boolean;
{ GETTER: Does the file attributes contain System?                             }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_SYSTEM <> 0
    else
      Result := False;
  end else
  begin
if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_SYSTEM <> 0
    else
      Result := False;
  end
end;

function TNamespace.GetTemporary: Boolean;
{ GETTER: Does the file attributes contain Temporary?                           }
begin
  if IsUnicode then
  begin
    if not Assigned(FWin32FindDataW) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataW) and FileSystem then
      Result := FWin32FindDataW^.dwFileAttributes and FILE_ATTRIBUTE_TEMPORARY <> 0
    else
      Result := False;
  end else
  begin
    if not Assigned(FWin32FindDataA) then
      GetDataFromIDList;
    if Assigned(FWin32FindDataA) and FileSystem then
      Result := FWin32FindDataA^.dwFileAttributes and FILE_ATTRIBUTE_TEMPORARY <> 0
    else
      Result := False;
  end
end;

function TNamespace.GetThreadedIconLoaded: Boolean;
begin
  Result := nsThreadedIconLoaded in States
end;

function TNamespace.GetThreadIconLoading: Boolean;
begin
  Result := nsThreadedIconLoading in States
end;

function TNamespace.GetShellIconOverlayInterface: IShellIconOverlay;
var
  Found: Boolean;
begin
  if (nsShellOverlaySupported in States) and not Assigned(FShellIconOverlayInterface) then
  begin
    Found := False;
    if Assigned(ShellFolder) then
      Found := ShellFolder.QueryInterface(IShellIconOverlay,
        Pointer(FShellIconOverlayInterface)) <> E_NOINTERFACE;
    if not Found then         // Here we have to check again
    begin
      IF Assigned(ParentShellFolder) then
        Found :=  ParentShellFolder.QueryInterface(IShellIconOverlay,
          Pointer(FShellIconOverlayInterface)) <> E_NOINTERFACE;
    end;
    if not Found then
    begin
      Exclude(FStates, nsShellOverlaySupported);
      FShellIconOverlayInterface := nil
    end
  end;
  Result := FShellIconOverlayInterface
end;

{$IFDEF VIRTUALNAMESPACES}
function TNamespace.GetIsHookedNamespace: Boolean;
var
  Index: Integer;
begin
  if not (scHookedNamespace in ShellCache.ShellCacheFlags) then
  begin
    if NamespaceExtensionFactory.IsHookedPIDL(AbsolutePIDL, Index) then
      Include(FShellCache.Data.Attributes, caHookedNamespace);
    Include(FShellCache.ShellCacheFlags, scHookedNamespace);
  end;
  Result := caHookedNamespace in ShellCache.Data.Attributes
end;

function TNamespace.GetIsRootVirtualNamespace: Boolean;
begin
  if not (scRootVirtualNamespace in ShellCache.ShellCacheFlags) then
  begin
    if NamespaceExtensionFactory.IsRootVirtualPIDL(AbsolutePIDL) then
      Include(FShellCache.Data.Attributes, caRootVirtualNamespace);
    Include(FShellCache.ShellCacheFlags, scRootVirtualNamespace);
  end;
  Result := caRootVirtualNamespace in ShellCache.Data.Attributes
end;

function TNamespace.GetIsVirtualHook: Boolean;
begin
  if not (scVirtualHook in ShellCache.ShellCacheFlags) then
  begin
    if NamespaceExtensionFactory.IsVirtualPIDL(RelativePIDL) then
      Include(FShellCache.Data.Attributes, caVirtualHook);
    Include(FShellCache.ShellCacheFlags, scVirtualHook);
  end;
  Result := caVirtualHook in ShellCache.Data.Attributes
end;

function TNamespace.GetIsVirtualNamespace: Boolean;
begin
  if not (scVirtualNamespace in ShellCache.ShellCacheFlags) then
  begin
    if NamespaceExtensionFactory.IsVirtualPIDL(RelativePIDL) then
      Include(FShellCache.Data.Attributes, caVirtualNamespace);
    Include(FShellCache.ShellCacheFlags, scVirtualNamespace);
  end;
  Result := caVirtualNamespace in ShellCache.Data.Attributes
end;

function TNamespace.GetIsHardHookedNamespace: Boolean;
begin
  if not (scHardHookedNamespace in ShellCache.ShellCacheFlags) then
  begin
    if NamespaceExtensionFactory.IsHardHookedPIDL(AbsolutePIDL) then
      Include(FShellCache.Data.Attributes, caHardHookedNamespace);
    Include(FShellCache.ShellCacheFlags, scHardHookedNamespace);
  end;
  Result := caHardHookedNamespace in ShellCache.Data.Attributes
end;


{$ENDIF}

procedure TNamespace.HandleContextMenuMsg(Msg, wParam, lParam: Longint; var Result: LRESULT);
{ This is called when the ContextMenu calls back to its owner window to ask     }
{ questions to implement the addition of icons to the menu.  The messages sent  }
{ to the owner window are:  WM_INITMENUPOPUP, WM_DRAWITEM, or WM_MEASUREITEM.   }
{ Which must be passed on to the ContextMenu2 interface to display items with   }
{ icons.                                                                        }
var
  ContextMenu3: IContextMenu3;
begin
  if Assigned(CurrentContextMenu2) then
    if CurrentContextMenu2.QueryInterface(IContextMenu3, ContextMenu3) <> E_NOINTERFACE then
      ContextMenu3.HandleMenuMsg2(Msg, wParam, lParam, Result)
    else
      CurrentContextMenu2.HandleMenuMsg(Msg, wParam, lParam);
end;


function TNamespace.InjectCustomSubMenu(Menu: HMenu; Caption: string; PopupMenu: TPopupMenu;
  var SubMenu: HMenu): TMenuItemIDArray;
const
  MENUMASK = MIIM_CHECKMARKS or MIIM_DATA or MIIM_ID or MIIM_STATE or MIIM_TYPE;


{ Searchs through the passed menu looking for an item identifer that is not   }
{ currently being used.                                                       }

  function FindUniqueMenuID(AMenu: HMenu; StartID: cardinal): cardinal;
  var
    ItemCount, i: integer;
    Duplicate, Done: Boolean;
  begin
    ItemCount := GetMenuItemCount(Menu);
    Duplicate := True;
    Result := StartID;
    while Duplicate do
    begin
      i := 0;
      Done := False;
      while (i < ItemCount) and not Done do
      begin
        Done := GetMenuItemID(Menu, i) = Result;
        Inc(i);
      end;
      Duplicate := Done;
      if Duplicate then
        Inc(Result)
    end;
  end;

var
  ItemCount, i: integer;
  ItemInfo: TMenuItemInfo;
  LastID: cardinal;
begin
  Result := nil;
  SubMenu := 0;
  LastID := 0;
  ItemCount := GetMenuItemCount(Menu);
  SubMenu := CreatePopupMenu;
  FillChar(ItemInfo, SizeOf(ItemInfo), #0);
  ItemInfo.cbSize := SizeOf(ItemInfo);
  ItemInfo.fmask := MIIM_TYPE;
  ItemInfo.fType := MFT_SEPARATOR;
  InsertMenuItem(Menu, ItemCount, True, ItemInfo);

  FillChar(ItemInfo, SizeOf(ItemInfo), #0);
  ItemInfo.cbSize := SizeOf(ItemInfo);
  ItemInfo.fmask := MIIM_SUBMENU or MIIM_TYPE;
  ItemInfo.hSubMenu := SubMenu;
  ItemInfo.dwTypeData := PChar(Caption);
  // Insert the Root Menu Item
  if InsertMenuItem(Menu, ItemCount + 1, True, ItemInfo) then
  begin
    SetLength(Result, PopupMenu.Items.Count);

    for i := PopupMenu.Items.Count - 1 downto 0 do
    begin
      FillChar(ItemInfo, SizeOf(ItemInfo), #0);

      ItemInfo.cbSize := SizeOf(ItemInfo);

      ItemInfo.fmask := MENUMASK;

      if PopupMenu.Items[i].Caption <> '-' then
        ItemInfo.fType := MFT_STRING
      else
        ItemInfo.fType := MFT_SEPARATOR;


      if PopupMenu.Items[i].RadioItem then
        ItemInfo.fType := ItemInfo.fType or MFT_RADIOCHECK;
      if PopupMenu.BiDiMode = bdRightToLeft then
        ItemInfo.fType := ItemInfo.fType or MFT_RIGHTJUSTIFY;
      if PopupMenu.Items[i].Break = mbBreak then
        ItemInfo.fType := ItemInfo.fType or MFT_MENUBREAK;
      if PopupMenu.Items[i].Break = mbBarBreak then
        ItemInfo.fType := ItemInfo.fType or MFT_MENUBARBREAK;

      if PopupMenu.Items[i].Checked then
        ItemInfo.fState := ItemInfo.fState or MFS_CHECKED
      else
        ItemInfo.fState := ItemInfo.fState or MFS_UNCHECKED;
      if PopupMenu.Items[i].Default then
        ItemInfo.fState := ItemInfo.fState or MFS_DEFAULT;
      if PopupMenu.Items[i].Enabled then
        ItemInfo.fState := ItemInfo.fState or MFS_ENABLED
      else
        ItemInfo.fState := ItemInfo.fState or MFS_DISABLED;

      ItemInfo.wID := FindUniqueMenuID(Menu, LastID + 1);
      LastID := ItemInfo.wID;
      Result[i] := ItemInfo.wID;

      // Store the TMenuItem so we can get it later
      ItemInfo.dwItemData := Cardinal( PopupMenu.Items[i]);

      if not( ItemInfo.fType and MFT_SEPARATOR <> 0) then
        ItemInfo.dwTypeData := PChar(PopupMenu.Items[i].Caption);

      InsertMenuItem(SubMenu, 0, True, ItemInfo)
    end
  end
end;

function TNamespace.InternalGetContextMenuInterface(PIDLArray: TRelativePIDLArray): IContextMenu;
var
  Found: Boolean;
begin
  Found := False;
  CurrentContextMenu2 := nil;  // Clear since not sure if it is avaiable yet
  if Assigned(PIDLArray) then
  begin
    if Assigned(ParentShellFolder)  then
    begin
      Found := Succeeded(ParentShellFolder.GetUIObjectOf(0,
        Length(PIDLArray), PItemIDList( PIDLArray[0]),
        IID_IContextMenu, nil, Pointer(Result)))
    end;
    if not Found and Assigned(ShellFolder) and (Length(PIDLArray) = 1) then
    begin
      Found := ShellFolder.CreateViewObject(0, IID_IContextMenu,
        Pointer(Result)) = NOERROR;
    end;
    if not Found then
      Result := nil
  end else
    Result := nil
end;

function TNamespace.InternalGetDataObjectInterface(PIDLArray: TRelativePIDLArray): IDataObject;
{ Creates an IDataObject using the passed relative PIDLs (actually siblings of }
{ the TNamespace) If a nil is passed for PIDLArray a single object based on    }
{ TNamespace is created.                                                       }
var
  Found: Boolean;
begin
  if not Assigned(PIDLArray) then
  begin
    SetLength(PIDLArray, 1);
    PIDLArray[0] := RelativePIDL
  end;
  Found := False;
  if Assigned(PIDLArray) then
  begin
    if Assigned(ParentShellFolder)  then
    begin
      Found := ParentShellFolder.GetUIObjectOf(0,
        Length(PIDLArray), PItemIDList( PIDLArray[0]),
        IDataObject, nil, Pointer(Result)) = NOERROR;
    end;
    if not Found and Assigned(ShellFolder) and (Length(PIDLArray) = 1) then
    begin
      Found := ShellFolder.CreateViewObject(0, IDataObject,
        Pointer(Result)) = NOERROR;
    end;
    if not Found then
      Result := nil
  end else
    Result := nil
end;

function TNamespace.InternalShowContextMenu(Owner: TWinControl;
  ContextMenuCmdCallback: TContextMenuCmdCallback;
  ContextMenuShowCallback: TContextMenuShowCallback;
  ContextMenuAfterCmdCallback: TContextMenuAfterCmdCallback;
  PIDLArray: TRelativePIDLArray; Position: PPoint; CustomShellSubMenu: TPopupMenu;
  CustomSubMenuCaption: WideString; ForceFromDesktop: Boolean): Boolean;
// Displays the ContextMenu of the namespace.
const
  MaxVerbLen = 128;
var
  Menu: hMenu;
  InvokeInfo: TCMInvokeCommandInfoEx;
  MenuCmd: Cardinal;
  x, y, i: integer;
  OldErrorMode: integer;
  VerbA: string;
  VerbW: WideString;
  GenericVerb: Pointer;
  Handled, AllowShow: Boolean;
  Flags: Longword;
  ContextMenu: IContextMenu;
  ContextMenu2: IContextMenu2;
  ContextMenu3: IContextMenu3;
  MenuIDs: TMenuItemIDArray;
  ItemInfo: TMenuItemInfo;
  SubMenu: HMenu;
  Desktop: IShellFolder;
  OldMode: UINT;
begin
  OldMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    MenuIDs := nil;
    Result := False;
    Assert(Assigned(Owner), 'To show a Context Menu using TNamespace you must pass a valid Owner TWinControl');
    if Assigned(Owner) then
    begin
      FOldWndProcForContextMenu := Owner.WindowProc;
      try
        // Hook the owner for the Window message for owner draw menus like
        // Send To..
        Owner.WindowProc := WindowProcForContextMenu;

        if Assigned(PIDLArray) then
        begin
          ContextMenu := nil;
          ContextMenu2 := nil;
          ContextMenu3 := nil;
          Result := False;
          if Assigned(Position) then
          begin
            x := Position.x;
            y := Position.y
          end else
          begin
            x := Mouse.CursorPos.X;  // Snag these fast. The mouse can move a fair amount
            y := Mouse.CursorPos.Y;  // before the popup menu is shown.
          end;
          FillChar(InvokeInfo, SizeOf(InvokeInfo), #0);
          Menu := CreatePopupMenu;
          OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);
          try
            { The application must handle a rename, rename makes no sense for more than 1 item }
            if Assigned(ContextMenuCmdCallback) and (Length(PIDLArray) = 1) then
              Flags :=  CMF_CANRENAME or CMF_NORMAL or CMF_EXPLORE
            else
              Flags := CMF_NORMAL or CMF_EXPLORE;

            if GetKeyState(VK_SHIFT) and $8000 <> 0 then
              Flags := Flags or CMF_EXTENDEDVERBS;

            if ForceFromDesktop then
            begin
              // In this case PIDLArray is AbsolutePIDLs
              SHGetDesktopFolder(Desktop);
              Desktop.GetUIObjectOf(0, Length(PIDLArray), PItemIDList(PIDLArray[0]), IID_IContextMenu, nil, Pointer(ContextMenu));
            end else
            begin
              if Assigned(PIDLArray) then
                ContextMenu := InternalGetContextMenuInterface(PIDLArray)
              else
                ContextMenu := ContextMenuInterface;
            end;

            CurrentContextMenu := ContextMenu;

            CurrentContextMenu2 := nil;  // not sure it is available yet
            if Assigned(ContextMenu) then
            begin
              if ContextMenu.QueryInterface(IContextMenu3, Pointer(ContextMenu3)) = E_NOINTERFACE then
              begin
                if ContextMenu.QueryInterface(IID_IContextMenu2, Pointer(ContextMenu2)) <> E_NOINTERFACE then
                  CurrentContextMenu2 := ContextMenu2;
              end else
                CurrentContextMenu2 := ContextMenu3;

              if Assigned(ContextMenu3) then
                ContextMenu3.QueryContextMenu(Menu, 0, 1, $7FFF, Flags)
              else
              if Assigned(ContextMenu2) then
                ContextMenu2.QueryContextMenu(Menu, 0, 1, $7FFF, Flags)
              else
              if Assigned(ContextMenu) then
                ContextMenu.QueryContextMenu(Menu, 0, 1, $7FFF, Flags);

              // Inject our custom menu item
              if Assigned(CustomShellSubMenu) then
                MenuIDs := InjectCustomSubMenu(Menu, CustomSubMenuCaption, CustomShellSubMenu, SubMenu);

              AllowShow := True;
              if Assigned(ContextMenuShowCallback) then
                ContextMenuShowCallback(Self, Menu, AllowShow);

              if AllowShow then
                MenuCmd := Cardinal( TrackPopupMenuEx(
                                     Menu,
                                     TPM_LEFTALIGN or TPM_RETURNCMD or TPM_RIGHTBUTTON,
                                     x, y, Owner.Handle, nil))
              else
                MenuCmd := 0;

              if MenuCmd <> 0 then
              begin
                if IsUnicode then
                begin
                  SetLength(VerbW, MaxVerbLen);
                  GenericVerb := @VerbW[1];
                  Flags := GCS_VERBW
                end else
                begin
                  SetLength(VerbA, MaxVerbLen);
                  GenericVerb := @VerbA[1];
                  Flags := GCS_VERBA
                end;
                if Assigned(ContextMenu3) then
                  Result := Succeeded(ContextMenu3.GetCommandString(MenuCmd-1, Flags, nil, GenericVerb, MaxVerbLen))
                else
                if Assigned(ContextMenu2) then
                  Result := Succeeded(ContextMenu2.GetCommandString(MenuCmd-1, Flags, nil, GenericVerb, MaxVerbLen))
                else
                if Assigned(ContextMenu) then
                  Result := Succeeded(ContextMenu.GetCommandString(MenuCmd-1, Flags, nil, GenericVerb, MaxVerbLen));

                if IsUnicode then
                  SetLength(VerbW, StrLenW(PWideChar( VerbW)))
                else begin
                  SetLength(VerbA, StrLen(PChar( VerbA)));
                  VerbW := VerbA
                end;

                if not Result then
                  VerbW := STR_UNKNOWNCOMMAN;

                Handled := False;
                for i := 0 to Length(MenuIDs) - 1 do
                begin
                  if MenuCmd = MenuIDs[i] then
                  begin
                    if SubMenu <> 0 then
                    begin
                      Handled := True;
                      FillChar(ItemInfo, SizeOf(ItemInfo), #0);
                      ItemInfo.cbSize := SizeOf(TMenuItemInfo);
                      ItemInfo.fMask := MIIM_DATA;
                      GetMenuItemInfo(SubMenu, i, True, ItemInfo);
                      if ItemInfo.dwItemData <> 0 then
                        TMenuItem(ItemInfo.dwItemData).Click
                    end
                  end
                end;

                if not Handled then
                  if Assigned(ContextMenuCmdCallback) then
                    ContextMenuCmdCallBack(Self, VerbW, MenuCmd, Handled);

                if not Handled then
                begin
                  FillChar(InvokeInfo, SizeOf(InvokeInfo), #0);
                  with InvokeInfo do
                  begin
                    { For some reason the lpVerbW won't work }
                    lpVerb := MakeIntResourceA(MenuCmd-1);
                    if IsUnicode then
                    begin
                      fMask := CMIC_MASK_UNICODE;
                      lpVerbW := MakeIntResourceW(MenuCmd-1)
                    end;
                    // Win95 get confused if size = TCMInvokeCommandInfoEx
                    if IsUnicode then
                      cbSize := SizeOf(TCMInvokeCommandInfoEx)
                    else
                      cbSize := SizeOf(TCMInvokeCommandInfo);

                    hWnd := Owner.Handle;
                    nShow := SW_SHOWNORMAL;
                  end;
                  if Assigned(ContextMenu3) then
                    Result := Succeeded(ContextMenu3.InvokeCommand(InvokeInfo))
                  else
                  if Assigned(ContextMenu2) then
                    Result := Succeeded(ContextMenu2.InvokeCommand(InvokeInfo))
                  else
                  if Assigned(ContextMenu) then
                    Result := Succeeded(ContextMenu.InvokeCommand(InvokeInfo));

                  if Assigned(ContextMenuAfterCmdCallback) then
                    ContextMenuAfterCmdCallback(Self, VerbW, MenuCmd, Result);
                end
              end
            end;
          finally
            { Don't access any properties or field of the object.  If the verb is     }
            { 'delete' the component using this class could have freed the instance   }
            { of the object through a ShellNotifyRegister or some other way.          }
            DestroyMenu(Menu);
            SetErrorMode(OldErrorMode);
            CurrentContextMenu := nil;
            CurrentContextMenu2 := nil;  // not sure it is available yet
          end
        end
      finally
        Owner.WindowProc := FOldWndProcForContextMenu;
        FOldWndProcForContextMenu := nil;
      end
    end
  finally
    SetErrorMode(OldMode)
  end
end;

function TNamespace.InternalSubItems(Flags: Longword): Boolean;
{ Tests to see if a namespace is a true folder and has at least one             }
{ sub-namespace within it.                                                      }
var
  Enum: IEnumIDList;
  Fetched: Longword;
  Item: PItemIDList;
begin
  Result := False;
  { The recycle bin enumerates slow if it is full.  VT will InitNode for various }
  { reasons eventhough the node is not expanded.  We will always assume there is }
  { is something in the bin.  If not when it is clicked it will clear the "+"    }
  if IsRecycleBin then
    Result := True
  else 
 // if ILIsParent(HistoryFolder.AbsolutePIDL, AbsolutePIDL, False) then
 //   Result := True
 // else
  begin
    if Folder and Assigned(ShellFolder) then
    begin
      Item := nil;
      ShellFolder.EnumObjects(0, Flags, Enum);
      if Assigned(Enum) then
        Result := Enum.Next(1, Item, Fetched) = NOERROR;
      if Assigned(Item) then
        PIDLMgr.FreePIDL(Item)
    end
  end
end;

procedure TNamespace.InvalidateCache;
{ Forces the class to reload any cached data the next time it is retrieved.     }
begin
  FShellCache.Data.InFolderName := '';
  FShellCache.Data.NormalName := '';
  FShellCache.Data.ParsedName := '';
  FShellCache.Data.SmallIcon := -1;
  FShellCache.Data.SmallOpenIcon := -1;
  FShellCache.Data.OverlayIndex := -1;
  FShellCache.Data.OverlayIconIndex := -1;
  FShellCache.Data.CreationTime := '';
  FShellCache.Data.LastAccessTime := '';
  FShellCache.Data.LastWriteTime := '';
  FShellCache.Data.FileSize := '';
  FShellCache.Data.FileSizeKB := '';
  FShellCache.Data.FileType := '';
  FShellCache.Data.FileSizeInt64 := 0;
  FShellCache.Data.SupportedColumns := 0;
  FShellCache.Data.Attributes := [];
  FShellCache.ShellCacheFlags := [];
  FreeAndNil(FExtractImage);
  FreeAndNil(FShellLink);
  InvalidateThumbImage
end;

procedure TNamespace.InvalidateNamespace(RefreshIcon: Boolean = True);
var
  Icon1, Icon2: integer;
  Icon1Initialized, Icon2Initialized: Boolean;
begin
  Icon1 := 0;
  Icon2 := 0;
  Icon1Initialized := False;
  Icon2Initialized := False;
  if not RefreshIcon then
  begin
    if scSmallIcon in FShellCache.ShellCacheFlags then
    begin
      Icon1Initialized := True;
      Icon1 := FShellCache.Data.SmallIcon;
    end;
    if scSmallOpenIcon in FShellCache.ShellCacheFlags then
    begin
      Icon2Initialized := True;
      Icon2 := FShellCache.Data.SmallOpenIcon;
    end;
  end else
  begin
    // Flush the thread state so the icon is reloaded by the thread
    States := States - [nsThreadedIconLoading];
    States := States - [nsThreadedIconLoaded];
  end;

  InvalidateCache;
  if nsOwnsParent in States then
  begin
    Parent.Free;
    FParent := nil;
  end;
  FDropTargetInterface := nil;
  FShellDetailsInterface := nil;
  FShellIconOverlayInterface := nil;
  FShellFolder := nil;
  if Assigned(Parent) then
    if Parent.IsDesktop then
      PhysicalDesktopFolder.InvalidateNamespace;
  if IsUnicode then
  begin
    if Assigned(FWin32FindDataW) then
      FreeMem(FWin32FindDataW, SizeOf(TWin32FindDataW));
    FWin32FindDataW := nil;
  end else
  begin
    if Assigned(FWin32FindDataA) then
      FreeMem(FWin32FindDataA, SizeOf(TWin32FindDataA));
    FWin32FindDataA := nil;
  end;
  if Assigned(FSHGetFileInfoRec) then
  begin
    Finalize(FSHGetFileInfoRec^);
    FreeMem(FSHGetFileInfoRec, SizeOf(TSHGetFileInfoRec));
  end;
  FSHGetFileInfoRec := nil;
  Include(FStates, nsShellDetailsSupported);  // Be optomistic
  Include(FStates, nsShellFolder2Supported);  // Be optomistic
  FQueryInfoInterface := nil;
  FShellIconInterface := nil;
  FCurrentContextMenu2 := nil;

  if not RefreshIcon then
  begin
    if Icon1Initialized then
    begin
      Include(FShellCache.ShellCacheFlags, scSmallIcon);
      FShellCache.Data.SmallIcon := Icon1;
    end;
    if Icon2Initialized then
    begin
      Include(FShellCache.ShellCacheFlags, scSmallOpenIcon);
      FShellCache.Data.SmallOpenIcon := Icon2;
    end;
  end;
end;

procedure TNamespace.InvalidateRelativePIDL(FileObjects: TFileObjects);
var
  Enum: IEnumIDList;
  Flags: Longword;
  Fetched: Longword;
  Item: PItemIDList;
  Done: Boolean;
begin
  if Assigned(ParentShellFolder) then
  begin
      Flags := FileObjectsToFlags(FileObjects);
      Done := False;
      ParentShellFolder.EnumObjects(0, Flags, Enum);
      if Assigned(Enum) then
        while (Enum.Next(1, Item, Fetched) = NOERROR) and not Done do
        begin
          if ComparePIDL(Item, False) = 0 then
          begin
            PIDLMgr.FreePIDL(FAbsolutePIDL);
            FAbsolutePIDL := PIDLMgr.AppendPIDL(Parent.AbsolutePIDL, Item);
            FRelativePIDL := PIDLMgr.GetPointerToLastID(FAbsolutePIDL);
            InvalidateNamespace;
            Done := True
          end;
          PIDLMgr.FreePIDL(Item)
        end
  end
end;

function TNamespace.IsChildByNamespace(TestNamespace: TNamespace;
  Immediate: Boolean): Boolean;
{ Returns True if the TestNamespace is a child of the namespace.  Immediate     }
{ forces function to be true only of the passed PIDL is the immidiate child     }
{ of the namespace.                                                             }
begin
  Result := Boolean( ILIsParent(FAbsolutePIDL, TestNamespace.FAbsolutePIDL, Immediate));
end;

function TNamespace.IsChildByPIDL(TestPIDL: PItemIDList;
  Immediate: Boolean): Boolean;
{ Returns True if the TestPIDL is a child of the namespace.  Immediate forces   }
{ function to be true only of the passed PIDL is the immidiate child of the     }
{ namespace.                                                                    }
begin
  Result := Boolean( ILIsParent(FAbsolutePIDL, TestPIDL, Immediate));
end;

function TNamespace.IsChildOfRemovableDrive: Boolean;
// Checks to see if the namespace is a child of a removable drive.  If the drive
// is removed then ILIsParent fails because the drive is no longer valid so any
// PIDL walking routines will fail and the PIDL is orphaned
var
  NS: TNamespace;
  PIDL, NewPIDL: PItemIDList;
  OldCB: Word;
begin
  Result := False;
  if PIDLMgr.IDCount(AbsolutePIDL) > 1 then
  begin
    PIDL := PIDLMgr.NextID(FAbsolutePIDL);
    PIDL := PIDLMgr.NextID(PIDL);  // Now we have the Drive
    PIDL := PIDLMgr.NextID(PIDL);  // Now we have the one past the Drive
    OldCb := PIDL.mkid.cb;
    PIDL.mkid.cb := 0;
    NewPIDL := PIDLMgr.CopyPIDL(FAbsolutePIDL);
    PIDL.mkid.cb := OldCB;
    // NS is now a TNamespace to the Drive
    NS := TNamespace.Create(NewPIDL, nil);
    Result := NS.Removable;
    NS.Free
  end
end;

function TNamespace.IsControlPanel: Boolean;
begin
  if Assigned(ControlPanelFolder) then
    Result := ILIsEqual(AbsolutePIDL, ControlPanelFolder.AbsolutePIDL)
  else
    Result := False
end;

function TNamespace.IsControlPanelChildFolder: Boolean;
begin
  if Assigned(ControlPanelFolder) then
    Result := ILIsParent(ControlPanelFolder.AbsolutePIDL, AbsolutePIDL, True)
  else
    Result := False
end;

function TNamespace.IsDesktop: Boolean;
begin
  Result := PIDLMgr.IsDesktopFolder(AbsolutePIDL)
end;

function TNamespace.IsMyComputer: Boolean;
begin
  if Assigned(DrivesFolder) then
    Result := ILIsEqual(DrivesFolder.AbsolutePIDL, AbsolutePIDL)
  else
    Result := False;
end;

function TNamespace.IsNetworkNeighborhood: Boolean;
begin
  if Assigned(NetworkNeighborHoodFolder) then
    Result := ILIsEqual(NetworkNeighborHoodFolder.AbsolutePIDL, AbsolutePIDL)
  else
    Result := False;
end;

function TNamespace.IsNetworkNeighborhoodChild: Boolean;
begin
  if Assigned(NetworkNeighborHoodFolder) then
    Result := ILIsParent(NetworkNeighborHoodFolder.AbsolutePIDL, AbsolutePIDL, False)
  else
    Result := False;
end;

function TNamespace.IsParentByNamespace(TestNamespace: TNamespace;
  Immediate: Boolean): Boolean;
{ Returns True if the TestNamespace is a parent of the namespace.  Immediate    }
{ forces function to be true only of the passed PIDL is the immidiate parent    }
{ of the namespace.                                                             }
begin
  Result := Boolean( ILIsParent(TestNamespace.FAbsolutePIDL, FAbsolutePIDL, Immediate));
end;

function TNamespace.IsParentByPIDL(TestPIDL: PItemIDList;
  Immediate: Boolean): Boolean;
{ Returns True if the TestPIDL is a parent of the namespace.  Immediate forces  }
{ function to be true only of the passed PIDL is the immidiate parent of the    }
{ namespace.                                                                    }
begin
   Result := Boolean( ILIsParent(TestPIDL, FAbsolutePIDL, Immediate));
end;

function TNamespace.IsRecycleBin: Boolean;
begin
  { RecycleBin may not be avaiable if System Administrator has removed it in Win2k at least }
  if Assigned(RecycleBinFolder) and not (nsRecycleBinChecked in States) then
  begin
    if ILIsEqual(AbsolutePIDL, RecycleBinFolder.AbsolutePIDL) then
      Include(FStates, nsIsRecycleBin)
    else
      Exclude(FStates, nsIsRecycleBin);
    Include(FStates, nsRecycleBinChecked);
  end;
  Result := nsIsRecycleBin in States;
end;

function TNamespace.ParseDisplayName: PItemIDList;
begin
  Result := ParseDisplayName(NameForParsing)
end;

function TNamespace.ParseDisplayName(Path: WideString): PItemIDList;
var
  chEaten: ULONG;
  Attrib: ULONG;
  Desktop: IShellFolder;
begin
  Result := nil;
  Attrib := 0;
  SHGetDesktopFolder(Desktop);
  if Assigned(Desktop) then
  begin
    if Desktop.ParseDisplayName(0, nil, PWideChar( Path),
      chEaten, Result, Attrib) <> NOERROR
    then
      Result := nil;
  end
end;

function TNamespace.Paste(NamespaceArray: TNamespaceArray; AsShortCut: Boolean = False): Boolean;
var
  NSA: TNamespaceArray;
  i: integer;
begin
  Result := False;
  if CanPasteToAll(NamespaceArray) then
  begin
    if IsDesktop then
    begin
      SetLength(NSA, Length(NamespaceArray));
      // Convert the virtual Desktop based TNamespaces to the Physical Desktop Folder based TNamespaces
      for i := 0 to Length(NSA) - 1 do
        NSA[i] := TNamespace.Create(PathToPIDL(NamespaceArray[i].NameForParsing), nil);
      Result := PhysicalDesktopFolder.Paste(NSA, AsShortCut);
    end else
    begin
      if VerifyPIDLRelationship(NamespaceArray) then
      begin
        if AsShortCut then
          Result := ExecuteContextMenuVerb('paste', NamespaceToRelativePIDLArray(NamespaceArray))
        else
          Result := ExecuteContextMenuVerb('pastelink', NamespaceToRelativePIDLArray(NamespaceArray))
      end
    end
  end
end;

procedure TNamespace.SetFreePIDLOnDestroy(const Value: Boolean);
begin
  if Value then
    Include(FStates, nsFreePIDLOnDestroy)
  else
    Exclude(FStates, nsFreePIDLOnDestroy)
end;

procedure TNamespace.SetIconIndexChanged(const Value: Boolean);
// Sets or resets if the index changed.  Currently the SetIconIndexByThread method sets
// this flag.  It is not reset automaticlly it is up to the application to reset then
// when it has detected and used it.
begin
  if Value then
    Include(FStates, nsIconIndexChanged)
  else
    Exclude(FStates, nsIconIndexChanged);
end;

procedure TNamespace.SetIconIndexByThread(IconIndex: Integer; ClearThreadLoading: Boolean);
begin
  Include(FStates, nsThreadedIconLoaded); // Small Normal Icon is now Cached
  FShellCache.Data.SmallIcon := IconIndex;
  Include(FShellCache.ShellCacheFlags, scSmallIcon);
  if ClearThreadLoading then
    Exclude(FStates, nsThreadedIconLoading);
  IconIndexChanged := True;
end;

procedure TNamespace.SetImageByThread(Bitmap: TBitmap;
  ClearThreadLoading: Boolean);
begin
  Include(FStates, nsThreadedImageLoaded); // Small Normal Icon is now Cached
  FImage := Bitmap;
  if ClearThreadLoading then
    Exclude(FStates, nsThreadedImageLoading);
end;

function TNamespace.SetNameOf(NewName: WideString): Boolean;
const
  ALL_FOLDERS = SHCONTF_FOLDERS or SHCONTF_NONFOLDERS or SHCONTF_INCLUDEHIDDEN;
var
  P, NewPIDL, NewAbsPIDL: PItemIDList;
  Oldcb: Word;
  OldCursor: TCursor;
begin
  Result := False;
  if CanRename and Assigned(ParentShellFolder) then
  begin
    OldCursor := Screen.Cursor;
    Screen.Cursor := crHourglass;
    try
    { The shell frees the PIDL so we need a copy }
      P := PIDLMgr.CopyPIDL(FRelativePIDL);
      NewPIDL := nil;
      if Succeeded(ParentShellFolder.SetNameOf(0, P, PWideChar(NewName), ALL_FOLDERS, NewPIDL)) then
      begin
        // Win98 will return success but never touch NewPIDL when trying to change name
        // of dialup connection.  Not sure how do it if this fails though??
        if Assigned(NewPIDL) then
        begin
          Result := True;
          { Temporary shortening of AbsolutePIDL }
          Oldcb := RelativePIDL.mkid.cb;
          RelativePIDL.mkid.cb := 0;
          NewAbsPIDL := PIDLMgr.AppendPIDL(AbsolutePIDL, NewPIDL);
          RelativePIDL.mkid.cb := Oldcb;
          PIDLMgr.FreePIDL(FAbsolutePIDL); // Remember Relative PIDL overlays AbsPIDL
          FAbsolutePIDL := NewAbsPIDL;
          FRelativePIDL := PIDLMgr.GetPointerToLastID(AbsolutePIDL);
        end
      end
    finally
      Screen.Cursor := OldCursor
    end
  end;
end;

procedure TNamespace.SetThreadIconLoading(const Value: Boolean);
begin
  if Value then
    Include(FStates, nsThreadedIconLoading)
  else
    Exclude(FStates, nsThreadedIconLoading)
end;

function TNamespace.GetThreadedImageLoaded: Boolean;
begin
  Result := nsThreadedImageLoaded in States
end;

function TNamespace.GetThreadedImageLoading: Boolean;
begin
  Result := nsThreadedImageLoading in States
end;

procedure TNamespace.SetThreadImageLoading(const Value: Boolean);
begin
  if Value then
    Include(FStates, nsThreadedImageLoading)
  else
    Exclude(FStates, nsThreadedImageLoading)
end;

function TNamespace.ShellExecuteNamespace(WorkingDir, CmdLineArguments: WideString;
  ExecuteFolder: Boolean = False; ExecuteFolderShortCut: Boolean = False): Boolean;
{ Attempts execute the object that the namespace is representing.  WorkingDir   }
{ is the directory that will be the current directory of the application that   }
{ is being executed.  If the directory does not exist the directory where the   }
{ file being executed resides.  CmdLineArguments are any switches or parameters }
{ that can be added to the file being executed.                                 }
{ ExecuteFolder stops the call from being performed if the namespace is a folder}
{ Doing so usually opens an explorer window to Explore the folder.              }
var
  ShellExecuteInfo: TShellExecuteInfo;
  ShellExecuteInfoW: TShellExecuteInfoW;
  ShortWorkingDir, ShortCmdLine: string;
  DoExecute: Boolean;
  ShellLink: TVirtualShellLink;
begin
  Result := False;
  DoExecute := True;

  if not ExecuteFolder then
    DoExecute := not Folder;

  if not ExecuteFolderShortCut and DoExecute then
  begin
    if Link then
    begin
      ShellLink := TVirtualShellLink.Create(nil);
      try
        ShellLink.ReadLink(NameParseAddress);
        DoExecute := not DirExistsW(ShellLink.TargetPath);
      finally
        ShellLink.Free
      end
    end
  end;

  if DoExecute then
  begin
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      FillChar(ShellExecuteInfoW, SizeOf(TShellExecuteInfoW), #0);
      if DirExistsW(WorkingDir) then
        ShellExecuteInfoW.lpDirectory := PWideChar(WorkingDir)
      else // This should always be a file not a folder so this is ok
        ShellExecuteInfoW.lpDirectory := PWideChar( ExtractFileDirW(NameParseAddress));
        ShellExecuteInfoW.cbSize := SizeOf(TShellExecuteInfoW);
        ShellExecuteInfoW.fMask := SEE_MASK_INVOKEIDLIST or SEE_MASK_NOCLOSEPROCESS;
        ShellExecuteInfoW.Wnd:= Application.Handle;
        ShellExecuteInfoW.nShow := SW_SHOWNORMAL;
        ShellExecuteInfoW.lpIDList:= AbsolutePIDL;
        ShellExecuteInfoW.lpParameters := PWideChar(CmdLineArguments);
        Result := ShellExecuteExW_VST(@ShellExecuteInfoW);
    end else
    begin
      FillChar(ShellExecuteInfo, SizeOf(TShellExecuteInfo), #0);
      if DirExistsW(WorkingDir) then
        ShortWorkingDir := WorkingDir
      else
        ShortWorkingDir := ExtractFileDir(NameParseAddress);
      ShellExecuteInfo.lpDirectory := PChar(ShortWorkingDir);
      ShellExecuteInfo.cbSize := SizeOf(TShellExecuteInfo);
      ShellExecuteInfo.fMask := SEE_MASK_INVOKEIDLIST or SEE_MASK_NOCLOSEPROCESS;
      ShellExecuteInfo.Wnd:= Application.Handle;
      ShellExecuteInfo.nShow := SW_SHOWNORMAL;
      ShellExecuteInfo.lpIDList:= AbsolutePIDL;
      ShortCmdLine := CmdLineArguments;
      ShellExecuteInfo.lpParameters := PChar(ShortCmdLine);
      Result := ShellExecuteEx(@ShellExecuteInfo);
    end
  end
end;

function TNamespace.ShowContextMenu(Owner: TWinControl;
  ContextMenuCmdCallback: TContextMenuCmdCallback;
  ContextMenuShowCallback: TContextMenuShowCallback;
  ContextMenuAfterCmdCallback: TContextMenuAfterCmdCallback;
  Position: PPoint = nil;
  CustomShellSubMenu: TPopupMenu = nil;
  CustomSubMenuCaption: WideString = ''): Boolean;
{ Displays the ContextMenu of the namespace.                                    }
var
  PIDLArray: TRelativePIDLArray;
begin
  SetLength(PIDLArray, 1);
  PIDLArray[0] := RelativePIDL;
  Result := InternalShowContextMenu(Owner, ContextMenuCmdCallback, ContextMenuShowCallback,
    ContextMenuAfterCmdCallback, PIDLArray, Position, CustomShellSubMenu, CustomSubMenuCaption,
    False);
end;

function TNamespace.ShowContextMenuMulti(Owner: TWinControl;
  ContextMenuCmdCallback: TContextMenuCmdCallback;
  ContextMenuShowCallback: TContextMenuShowCallback;
  ContextMenuAfterCmdCallback: TContextMenuAfterCmdCallback;
  NamespaceArray: TNamespaceArray;
  Position: PPoint = nil;
  CustomShellSubMenu: TPopupMenu = nil;
  CustomSubMenuCaption: WideString = '';
  ForceFromDesktop: Boolean = False): Boolean;
begin
  if ForceFromDesktop then
  begin
      Result := InternalShowContextMenu(Owner, ContextMenuCmdCallBack,
        ContextMenuShowCallback, ContextMenuAfterCmdCallback,
        NamespaceToAbsolutePIDLArray(NamespaceArray), Position, CustomShellSubMenu,
        CustomSubMenuCaption, ForceFromDesktop)
  end else
  begin
    // 12.5.02
    //   Let PIDLs be collected (although incorrectly) from various folders
    //   it is the apps responsiblity to parse out the right selection.
    //   See the FileFind demo
    //if VerifyPIDLRelationship(NamespaceArray) then
      Result := InternalShowContextMenu(Owner, ContextMenuCmdCallBack,
        ContextMenuShowCallback, ContextMenuAfterCmdCallback,
        NamespaceToRelativePIDLArray(NamespaceArray), Position, CustomShellSubMenu,
        CustomSubMenuCaption, ForceFromDesktop)
    //else
    //  Result := False
  end
end;

procedure TNamespace.ShowPropertySheet;
var
  NamespaceArray: TNamespaceArray;
begin
  if HasPropSheet then
  begin
    SetLength(NamespaceArray, 1);
    NamespaceArray[0] := Self;
    if VerifyPIDLRelationship(NamespaceArray) then
      ExecuteContextMenuVerb('properties', NamespaceToRelativePIDLArray(NamespaceArray))
  end
end;

procedure TNamespace.ShowPropertySheetMulti(NamespaceArray: TNamespaceArray);
var
  APIDLArray: TPIDLArray;
  IDO: IDataObject;
begin
  APIDLArray := nil;
  if CanShowPropertiesOfAll(NamespaceArray) then
    // Call SHMultiFileProperties_VST to show the property sheet when the
    // APIDLArray items are from different folders.
    // Minimum OS: Win2k
    if Assigned(SHMultiFileProperties_VST) then
    begin
      // APIDLArray to IDataObject, use the DesktopFolder!!!
      APIDLArray := NamespaceToAbsolutePIDLArray(NamespaceArray);
      if DesktopFolder.ShellFolder.GetUIObjectOf(0, Length(APIDLArray), PItemIDList(APIDLArray[0]),
        IDataObject, nil, Pointer(IDO)) = NOERROR then
      begin
        SHMultiFileProperties_VST(IDO, 0);
      end;
    end
    else
      if VerifyPIDLRelationship(NamespaceArray) then
        ExecuteContextMenuVerb('properties', NamespaceToRelativePIDLArray(NamespaceArray));
end;

function TNamespace.TestAttributesOf(Flags: Longword; FlushCache: Boolean; SoftFlush: Boolean = False): Boolean;
// Pass any of the flags for IShellFolder.GetAttributesOf to see if they exist
// for the Folder. FlushCache forces the shell to reload the information on the
// namespace.  Useful to handle the bug where the shell caches the icon for a
// CD drive and never changes it.  Flushing it will force it to reload the Index
// Note this is dangerous with 3rd party namespaces.  M$ suggests this method for
// their namespaces but at least Hummingbird network namespace crashes with this
// they apparently don't check for 0 PIDL's
// Soft Flush add the SFGAO_VALIDATE flag to get the fresh info
var
  x: Longword;
begin
  if Assigned(ParentShellFolder) then
  begin
    x := Flags;
    if FlushCache then
    begin
      x := x or SFGAO_VALIDATE;
      ParentShellFolder.GetAttributesOf(0, FRelativePIDL, x);
    end else
    if SoftFlush then
    begin
      x := x or SFGAO_VALIDATE;
      ParentShellFolder.GetAttributesOf(1, FRelativePIDL, x)
    end else
      ParentShellFolder.GetAttributesOf(1, FRelativePIDL, x);
    Result := Flags and x = Flags;
  end else
    Result := False;
end;

function TNamespace.VerifyPIDLRelationship(NamespaceArray: TNamespaceArray): Boolean;
var
  i: integer;
begin
  Result := True;
  i := 0;
  while (i < Length(NamespaceArray)) and Result do
  begin
    { TNamespace is based off using the parent to access the data so it is      }
    { correct to do the test for childPIDLs relative from the parent.           }
    if Assigned(Parent) then
      Result := ILIsParent(Parent.AbsolutePIDL, NamespaceArray[i].AbsolutePIDL, True)
    else begin
      if (Length(NamespaceArray) = 1) and NamespaceArray[0].IsDesktop then
        Result := True
      else
        Result := False;
    end;
    Inc(i)
  end;
  if not Result and not IsDesktop then
    ShowWideMessage(Application.Handle, S_ERROR, STR_ERR_BAD_PIDL_RELATIONSHIP);
end;

procedure TNamespace.WindowProcForContextMenu(var Message: TMessage);
begin
  FOldWndProcForContextMenu(Message); // Call the OldWindProc of the ContextMenu owner
  case Message.Msg of
    WM_DRAWITEM, WM_INITMENUPOPUP, WM_MEASUREITEM, WM_MENUCHAR:
      HandleContextMenuMsg(Message.Msg, Message.WParam, Message.LParam, Message.Result);
  end;
end;

function TNamespace.GetCategoryProviderInterface: ICategoryProvider;
begin
  if not Assigned(FCategoryProviderInterface) and Folder and Assigned(ShellFolder) then
  begin
    if not Succeeded(ShellFolder.CreateViewObject(0, IID_ICategoryProvider, Pointer(FCategoryProviderInterface))) then
      FCategoryProviderInterface := nil
  end;
  Result := FCategoryProviderInterface
end;

function TNamespace.GetCategoryAlphabetical: ICategorizer;
begin
  Result := CreateCategory(CLSID_AlphabeticalCategorizer)
end;

function TNamespace.GetCategoryDriveSize: ICategorizer;
begin
  Result := CreateCategory(CLSID_DriveSizeCategorizer)
end;

function TNamespace.GetCategoryDriveType: ICategorizer;
begin
  Result := CreateCategory(CLSID_DriveTypeCategorizer)
end;

function TNamespace.GetCategoryFreeSpace: ICategorizer;
begin
  Result := CreateCategory(CLSID_FreeSpaceCategorizer)
end;

function TNamespace.GetCategorySize: ICategorizer;
begin
  Result := CreateCategory(CLSID_SizeCategorizer)
end;

function TNamespace.GetCategoryTime: ICategorizer;
begin
  Result := CreateCategory(CLSID_TimeCategorizer)
end;

function TNamespace.CreateCategory(GUID: TGUID): ICategorizer;
begin
  Result := nil;
  if Assigned(CategoryProviderInterface) then
  begin
    if not Succeeded(CategoryProviderInterface.CreateCategory(GUID, IID_ICategorizer, Result)) then
      Result := nil;
  end
end;

function TNamespace.GetBrowserFrameOptionsInterface: IBrowserFrameOptions;
var
  Found: Boolean;
begin
  if not Assigned(FBrowserFrameOptionsInterface) then
  begin
    Found := False;
    if Assigned(Parent) then
    begin
       Found := Succeeded(Parent.ShellFolder.GetUIObjectOf(0, 1, FRelativePIDL, IBrowserFrameOptions, nil, Pointer(FBrowserFrameOptionsInterface)));
       if not Found and Folder then
       begin
           Found := Succeeded(ShellFolder.CreateViewObject(0, IBrowserFrameOptions, Pointer(FBrowserFrameOptionsInterface)));
         if not Found then
           Found := Succeeded(ShellFolder.QueryInterface(IBrowserFrameOptions, Pointer(FBrowserFrameOptionsInterface)))
       end
    end;
    if not Found then
      FBrowserFrameOptionsInterface := nil
  end;
  Result := FBrowserFrameOptionsInterface
end;

function TNamespace.GetQueryAssociationsInterface: IQueryAssociations;
var
  Found: Boolean;
begin
  if not Assigned(FQueryAssociationsInterface) then
  begin
    Found := False;
    if Assigned(Parent) then
    begin
       Found := Succeeded(Parent.ShellFolder.GetUIObjectOf(0, 1, FRelativePIDL, IQueryAssociations, nil, Pointer(FQueryAssociationsInterface)));
       if not Found and Folder then
       begin
           Found := Succeeded(ShellFolder.CreateViewObject(0, IQueryAssociations, Pointer(FQueryAssociationsInterface)));
         if not Found then
           Found := Succeeded(ShellFolder.QueryInterface(IQueryAssociations, Pointer(FQueryAssociationsInterface)))
       end
    end;
    if not Found then
      FQueryAssociationsInterface := nil
  end;
  Result := FQueryAssociationsInterface
end;

function TNamespace.GetValid: Boolean;
var
  rgfInOut: UINT;
begin
  // Does not work on floppy drives and such
  // password proctected network drives also return false regardless if they have
  // not been logged into yet so return true for those too.
  if (not Removable and (Assigned(ParentShellFolder))) and not PotentialMappedDrive(Self) then
  begin
    rgfInOut := SFGAO_VALIDATE;
    // This returns false on a password protected network folder
    Result := ParentShellFolder.GetAttributesOf(1, FRelativePIDL, rgfInOut) = NOERROR
  end else
    Result := True
end;

{ TExtractImage }

constructor TExtractImage.Create;
begin
  FWidth := 200;
  FHeight := 200;
  FColorDepth := 32;
  FFlags := IEIFLAG_SCREEN;
end;

function TExtractImage.GetImage: TBitmap;
var
  Bits: HBITMAP;

begin
  Bits := 0;
  Result := nil;
  if Assigned(ExtractImageInterface) then
    if Succeeded(ExtractImageInterface.Extract(Bits)) then
    begin
      Result := TBitmap.Create;
      Result.Handle := Bits;
    end
end;

function TExtractImage.GetExtractImageInterface2: IExtractImage2;
var
  Found: Boolean;
begin
  if not Assigned(FExtractImage2Interface) then
  begin
    Found := False;
    if Assigned(ExtractImageInterface) then
      Found :=  ExtractImageInterface.QueryInterface(IID_IExtractImage2,
        Pointer(FExtractImage2Interface)) <> E_NOINTERFACE;
    if not Found then
      FExtractImage2Interface := nil
  end;
  Result := FExtractImage2Interface
end;


function TExtractImage.GetExtractImageInterface: IExtractImage;
var
  Found: Boolean;
begin
  if not Assigned(FExtractImageInterface) then
  begin
    Found := False;
    if Assigned(Owner.ParentShellFolder) then
    begin
      Found := Owner.ParentShellFolder.GetUIObjectOf(0, 1, Owner.FRelativePIDL,
        IExtractImage, nil, Pointer(FExtractImageInterface)) = NOERROR;
    end;
    if not Found and Assigned(Owner.ShellFolder) then
    begin
      Found := Owner.ShellFolder.CreateViewObject(0, IExtractImage,
        Pointer(FExtractImageInterface)) = NOERROR;
    end;
    if not Found then
      FExtractImageInterface := nil
  end;
  Result := FExtractImageInterface

end;

function TExtractImage.GetImagePath: WideString;
var
  Size: TSize;
  Buffer: PWideChar;
begin
  if Assigned(ExtractImageInterface) then
  begin
    GetMem(Buffer, MAX_PATH * 4);
    try
      try
        Size.cx := Width;
        Size.cy := Height;
        if ExtractImageInterface.GetLocation(Buffer, MAX_PATH, FPriority, Size,
          ColorDepth, FFlags) = NOERROR then
        begin
          Result := Buffer;
          PathExtracted := True
        end else
          Result := '';
      finally
        FreeMem(Buffer);
      end except
      Result := ''
    end
  end;
end;



{ ----------------------------------------------------------------------------- }
{ Encapsulation of IShellLink                                                   }
{ ----------------------------------------------------------------------------- }

{ TVirtualShellLink }

destructor TVirtualShellLink.Destroy;
begin
  FreeTargetIDList;
  inherited;
end;

procedure TVirtualShellLink.FreeTargetIDList;
var
  Malloc: IMalloc;
  PIDL: PItemIDList;
begin
  if Assigned(TargetIDList) then
  begin
    PIDL := TargetIDLIst;
    TargetIDList := nil;
    SHGetMalloc(Malloc);
    Malloc.Free(PIDL);
  end;
end;

function TVirtualShellLink.GetShellLinkAInterface: IShellLink;
begin
  if not Assigned(FShellLinkA) then
  begin
    if not Succeeded(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
      IShellLinkA, FShellLinkA))
    then
      FShellLinkA := nil;
  end;
  Result := FShellLinkA
end;

function TVirtualShellLink.GetShellLinkWInterface: IShellLinkW;
begin   
  if not Assigned(FShellLinkW) then
  begin
    if not Succeeded(CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
      IShellLinkW, FShellLinkW))
    then
      FShellLinkW := nil
  end;
  Result := FShellLinkW
end;

function TVirtualShellLink.ReadLink(LinkFileName: WideString): Boolean;
const
  BUFFERSIZE = 1024;
var
  Success: Boolean;
  S: string;
  PersistFile: IPersistFile;
  pwHotKey: Word;
  Cmd: integer;
  FindData: WIN32_FIND_DATA;
  FindDataW: WIN32_FIND_DATAW;
begin
  Result := False;
  Success := False;
  if Assigned(ShellLinkWInterface) then
  begin
    if Supports(ShellLinkWInterface, IPersistFile, PersistFile) then
    begin
      FFileName := LinkFileName;
      Success := Succeeded(PersistFile.Load(PWideChar(FileName), STGM_READWRITE));
      if Success then
      begin
        Result := True;

        SetLength(FTargetPath, BUFFERSIZE);
        Success := Succeeded(ShellLinkWInterface.GetPath(PWideChar( FTargetPath), MAX_PATH, FindDataW, SLGP_UNCPRIORITY));
        if Success then
          SetLength(FTargetPath, lstrlenW(PWideChar( FTargetPath)));

        SetLength(FArguments, BUFFERSIZE);
        Success := Succeeded(ShellLinkWInterface.GetArguments(PWideChar( FArguments), BUFFERSIZE));
        if Success then
          SetLength(FArguments, lstrlenW(PWideChar( FArguments)));

        SetLength(FDescription, BUFFERSIZE);
        Success := Succeeded(ShellLinkWInterface.GetDescription(PWideChar( FDescription), BUFFERSIZE));
        if Success then
          SetLength(FDescription, lstrlenW(PWideChar( FDescription)));

        SetLength(FWorkingDirectory, BUFFERSIZE);
        Success := Succeeded(ShellLinkWInterface.GetWorkingDirectory(PWideChar( FWorkingDirectory), BUFFERSIZE));
        if Success then
          SetLength(FWorkingDirectory, lstrlenW(PWideChar( FWorkingDirectory)));

        SetLength(FIconLocation, BUFFERSIZE);
        Success := Succeeded(ShellLinkWInterface.GetIconLocation(PWideChar( FIconLocation), BUFFERSIZE, FIconIndex));
        if Success then
          SetLength(FIconLocation, lstrlenW(PWideChar( FIconLocation)));

        FreeTargetIDList;
        ShellLinkWInterface.GetIDList(FTargetIDList);

        Success := Succeeded(ShellLinkWInterface.GetHotKey(pwHotKey));
        if Success then
        begin
          FHotKey := LoByte(pwHotKey);
          FHotKeyModifiers := [];
          if HiByte(pwHotKey) and HOTKEYF_ALT <> 0 then Include(FHotKeyModifiers, hkmAlt);
          if HiByte(pwHotKey) and HOTKEYF_CONTROL <> 0 then Include(FHotKeyModifiers, hkmControl);
          if HiByte(pwHotKey) and HOTKEYF_EXT <> 0 then Include(FHotKeyModifiers, hkmExtendedKey);
          if HiByte(pwHotKey) and HOTKEYF_SHIFT <> 0 then Include(FHotKeyModifiers, hkmShift);
        end;

        Success := Succeeded(ShellLinkWInterface.GetShowCmd(Cmd));
        if Success then
        case Cmd of
          SW_HIDE:            ShowCmd := swHide;
          SW_MAXIMIZE:        ShowCmd := swMaximize;
          SW_MINIMIZE:        ShowCmd := swMinimize;
          SW_RESTORE:         ShowCmd := swRestore;
          SW_SHOW:            ShowCmd := swShow;
          SW_SHOWDEFAULT:     ShowCmd := swShowDefault;
          SW_SHOWMINIMIZED:   ShowCmd := swShowMinimized;
          SW_SHOWMINNOACTIVE: ShowCmd := swShowMinNoActive;
          SW_SHOWNA :         ShowCmd := swShowNA;
          SW_SHOWNOACTIVATE : ShowCmd := swShowNoActive;
          SW_SHOWNORMAL:      ShowCmd := swShowNormal;
        end;
 // Why was that here?  Removed 11.12.02
 //       PersistFile.Save(PWideChar(FileName), True)
      end else
        FFileName := ''
    end
  end;
  if not Success and Assigned(ShellLinkAInterface) then
  begin
    if Supports(ShellLinkAInterface, IPersistFile, PersistFile) then
    begin
      FFileName := LinkFileName;
      Success := Succeeded(PersistFile.Load(PWideChar(FileName), STGM_READWRITE));
      if Success then
      begin
        Result := True;

        SetLength(S, BUFFERSIZE);
        Success := Succeeded(ShellLinkAInterface.GetPath(PChar( S), MAX_PATH, FindData, SLGP_UNCPRIORITY));
        if Success then
        begin
          SetLength(S, lstrlen(PChar( S)));
          FTargetPath := S
        end;

        SetLength(S, BUFFERSIZE);
        Success := Succeeded(ShellLinkAInterface.GetArguments(PChar( S), BUFFERSIZE));
        if Success then
        begin
          SetLength(S, lstrlen(PChar( S)));
          FArguments := S
        end;

        SetLength(S, BUFFERSIZE);
        Success := Succeeded(ShellLinkAInterface.GetDescription(PChar( S), BUFFERSIZE));
        if Success then
        begin
          SetLength(S, lstrlen(PChar( S)));
          FDescription := S
        end;

        SetLength(S, BUFFERSIZE);
        Success := Succeeded(ShellLinkAInterface.GetWorkingDirectory(PChar( S), BUFFERSIZE));
        if Success then
        begin
          SetLength(S, lstrlen(PChar( S)));
          FWorkingDirectory := S
        end;

        SetLength(S, BUFFERSIZE);
        Success := Succeeded(ShellLinkAInterface.GetIconLocation(PChar( S), BUFFERSIZE, FIconIndex));
        if Success then
        begin
          SetLength(S, lstrlen(PChar( S)));
          FIconLocation := S
        end;

        FreeTargetIDList;
        ShellLinkAInterface.GetIDList(FTargetIDList);

        Success := Succeeded(ShellLinkAInterface.GetHotKey(pwHotKey));
        if Success then
        begin
          FHotKey := LoByte(pwHotKey);
          FHotKeyModifiers := [];
          if HiByte(pwHotKey) and HOTKEYF_ALT <> 0 then Include(FHotKeyModifiers, hkmAlt);
          if HiByte(pwHotKey) and HOTKEYF_CONTROL <> 0 then Include(FHotKeyModifiers, hkmControl);
          if HiByte(pwHotKey) and HOTKEYF_EXT <> 0 then Include(FHotKeyModifiers, hkmExtendedKey);
          if HiByte(pwHotKey) and HOTKEYF_SHIFT <> 0 then Include(FHotKeyModifiers, hkmShift);
        end;

        Success := Succeeded(ShellLinkAInterface.GetShowCmd(Cmd));
        if Success then
        case Cmd of
          SW_HIDE:            ShowCmd := swHide;
          SW_MAXIMIZE:        ShowCmd := swMaximize;
          SW_MINIMIZE:        ShowCmd := swMinimize;
          SW_RESTORE:         ShowCmd := swRestore;
          SW_SHOW:            ShowCmd := swShow;
          SW_SHOWDEFAULT:     ShowCmd := swShowDefault;
          SW_SHOWMINIMIZED:   ShowCmd := swShowMinimized;
          SW_SHOWMINNOACTIVE: ShowCmd := swShowMinNoActive;
          SW_SHOWNA :         ShowCmd := swShowNA;
          SW_SHOWNOACTIVATE : ShowCmd := swShowNoActive;
          SW_SHOWNORMAL:      ShowCmd := swShowNormal;
        end;

        PersistFile.Save(PWideChar(FileName), True)
      end else
        FFileName := '';
    end
  end
end;

function TVirtualShellLink.WriteLink(LinkFileName: WideString): Boolean;
var
  S: string;
  PersistFile: IPersistFile;
  pwHotKey, pwHotKeyHi: Word;
  KeyModifier: THotKeyModifiers;
  Cmd: integer;
begin
  Result := False;
  if (TargetPath = '') and not Assigned(TargetIDList) and not SilentWrite then
    ShowWideMessage(Application.Handle, S_NOTARGETDEFINED, S_ERROR)
  else begin
    if Assigned(ShellLinkWInterface) then
    begin
      if Supports(ShellLinkWInterface, IPersistFile, PersistFile) then
      begin
        FFileName := LinkFileName;
        ShellLinkWInterface.SetPath(PWideChar( FTargetPath));
        ShellLinkWInterface.SetArguments(PWideChar( FArguments));
        ShellLinkWInterface.SetDescription(PWideChar( FDescription));
        ShellLinkWInterface.SetPath(PWideChar( FTargetPath));
        ShellLinkWInterface.SetWorkingDirectory(PWideChar( FWorkingDirectory));
        ShellLinkWInterface.SetIconLocation(PWideChar( FIconLocation), FIconIndex);
        if Assigned(FTargetIDList) then
          ShellLinkWInterface.SetIDList(FTargetIDList);

        pwHotKey := HotKey;
        pwHotKeyHi := 0;
        KeyModifier := HotKeyModifiers;
        if hkmAlt in KeyModifier then pwHotKeyHi := pwHotKeyHi or HOTKEYF_ALT;
        if hkmControl in KeyModifier then pwHotKeyHi := pwHotKeyHi or HOTKEYF_CONTROL;
        if hkmExtendedKey in KeyModifier then pwHotKeyHi := pwHotKeyHi or HOTKEYF_EXT;
        if hkmShift in KeyModifier then pwHotKeyHi := pwHotKeyHi or HOTKEYF_SHIFT;

        pwHotKeyHi := pwHotKeyHi shl 8;     // Make lower 8 bits the upper 8 bits
        pwHotKeyHi := pwHotKeyHi and $FF00;  // Make sure lower 8 bits clear
        pwHotKey := pwHotKey or pwHotKeyHi;
        ShellLinkWInterface.SetHotkey(pwHotKey);

        case ShowCmd of
          swHide:             Cmd := SW_HIDE;
          swMaximize:         Cmd := SW_MAXIMIZE;
          swMinimize:         Cmd := SW_MINIMIZE;
          swRestore:          Cmd := SW_RESTORE;
          swShow:             Cmd := SW_SHOW;
          swShowDefault:      Cmd := SW_SHOWDEFAULT;
          swShowMinimized:    Cmd := SW_SHOWMINIMIZED;
          swShowMinNoActive:  Cmd := SW_SHOWMINNOACTIVE;
          swShowNA:           Cmd := SW_SHOWNA;
          swShowNoActive:     Cmd := SW_SHOWNOACTIVATE;
          swShowNormal:       Cmd := SW_SHOWNORMAL;
        else
          Cmd := SW_SHOWNORMAL
        end;
        ShellLinkWInterface.SetShowCmd(Cmd);

        Result := Succeeded(PersistFile.Save(PWideChar(FileName), True))
      end;
    end;
    if not Result and Assigned(ShellLinkAInterface) then
    begin
      if Supports(ShellLinkAInterface, IPersistFile, PersistFile) then
      begin
        FFileName := LinkFileName;
        S := FTargetPath;
        ShellLinkAInterface.SetPath(PChar( S));
        S := FArguments;
        ShellLinkAInterface.SetArguments(PChar(S));
        S := FDescription;
        ShellLinkAInterface.SetDescription(PChar( S));
        S := FTargetPath;
        ShellLinkAInterface.SetPath(PChar( S));
        S := FWorkingDirectory;
        ShellLinkAInterface.SetWorkingDirectory(PChar( S));
        S := FIconLocation;
        ShellLinkAInterface.SetIconLocation(PChar( S), FIconIndex);

        if Assigned(FTargetIDList) then
          ShellLinkAInterface.SetIDList(FTargetIDList);

        pwHotKey := HotKey;
        pwHotKeyHi := 0;
        KeyModifier := HotKeyModifiers;
        if hkmAlt in KeyModifier then pwHotKeyHi := pwHotKeyHi or HOTKEYF_ALT;
        if hkmControl in KeyModifier then pwHotKeyHi := pwHotKeyHi or HOTKEYF_CONTROL;
        if hkmExtendedKey in KeyModifier then pwHotKeyHi := pwHotKeyHi or HOTKEYF_EXT;
        if hkmShift in KeyModifier then pwHotKeyHi := pwHotKeyHi or HOTKEYF_SHIFT;

        pwHotKeyHi := pwHotKeyHi shl 8;     // Make lower 8 bits the upper 8 bits
        pwHotKeyHi := pwHotKeyHi and $FF00;  // Make sure lower 8 bits clear
        pwHotKey := pwHotKey or pwHotKeyHi;
        ShellLinkAInterface.SetHotkey(pwHotKey);

        case ShowCmd of
          swHide:             Cmd := SW_HIDE;
          swMaximize:         Cmd := SW_MAXIMIZE;
          swMinimize:         Cmd := SW_MINIMIZE;
          swRestore:          Cmd := SW_RESTORE;
          swShow:             Cmd := SW_SHOW;
          swShowDefault:      Cmd := SW_SHOWDEFAULT;
          swShowMinimized:    Cmd := SW_SHOWMINIMIZED;
          swShowMinNoActive:  Cmd := SW_SHOWMINNOACTIVE;
          swShowNA:           Cmd := SW_SHOWNA;
          swShowNoActive:     Cmd := SW_SHOWNOACTIVATE;
          swShowNormal:       Cmd := SW_SHOWNORMAL;
        else
          Cmd := SW_SHOWNORMAL
        end;
        ShellLinkAInterface.SetShowCmd(Cmd);

        Result := Succeeded(PersistFile.Save(PWideChar(FileName), True))
      end
    end
  end
end;




{ ----------------------------------------------------------------------------- }
{ TList that implements basic streaming                                         }
{ ----------------------------------------------------------------------------- }

{ TStreamableList }

constructor TStreamableList.Create;
begin
  FStreamVersion := STREAM_VERSION_DEFAULT
end;

procedure TStreamableList.LoadFromFile(FileName: WideString; Version: integer = 0;
  ReadVerFromStream: Boolean = False);
var
  FileStream: TWideFileStream;
begin
  FileStream := nil;
  try
    FileStream := TWideFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
    LoadFromStream(FileStream);
  finally
    FileStream.Free
  end;
end;

procedure TStreamableList.LoadFromStream(S: TStream; Version: integer;
  ReadVerFromStream: Boolean);
begin
  Clear;  
  if ReadVerFromStream then
    S.ReadBuffer(FStreamVersion, Sizeof(FStreamVersion))
  else
    FStreamVersion := Version;
end;

procedure TStreamableList.SaveToFile(FileName: WideString; Version: integer = 0;
  ReadVerFromStream: Boolean = False);
var
  FileStream: TWideFileStream;
begin
  FileStream := nil;
  try
    FileStream := TWideFileStream.Create(FileName, fmCreate or fmShareExclusive);
    SaveToStream(FileStream);
  finally
    FileStream.Free
  end;
end;

procedure TStreamableList.SaveToStream(S: TStream; Version: integer;
  WriteVerToStream: Boolean);
begin
  if WriteVerToStream then
    S.WriteBuffer(Version, Sizeof(Version));
  FStreamVersion := Version;
end;


{ ----------------------------------------------------------------------------- }
{ TClass that implements basic streaming                                        }
{ ----------------------------------------------------------------------------- }

{ TStreamableClass }

constructor TStreamableClass.Create;
begin
  FStreamVersion := STREAM_VERSION_DEFAULT
end;

procedure TStreamableClass.LoadFromFile(FileName: WideString; Version: integer = 0; ReadVerFromStream: Boolean = False);
var
  FileStream: TWideFileStream;
begin
  FileStream := nil;
  try
    FileStream := TWideFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
    LoadFromStream(FileStream, Version, ReadVerFromStream);
  finally
    FileStream.Free
  end;
end;

procedure TStreamableClass.LoadFromStream(S: TStream; Version: integer;
  ReadVerFromStream: Boolean);
begin
  if ReadVerFromStream then
    S.ReadBuffer(FStreamVersion, Sizeof(FStreamVersion))
  else
    FStreamVersion := Version;
end;

procedure TStreamableClass.SaveToFile(FileName: WideString; Version: integer = 0; ReadVerFromStream: Boolean = False);
var
  FileStream: TWideFileStream;
begin
  FileStream := nil;
  try
    FileStream := TWideFileStream.Create(FileName, fmCreate or fmShareExclusive);
    SaveToStream(FileStream, Version, ReadVerFromStream);
  finally
    FileStream.Free
  end;
end;

procedure TStreamableClass.SaveToStream(S: TStream; Version: integer;
  WriteVerToStream: Boolean);
begin
  if WriteVerToStream then
    S.WriteBuffer(Version, Sizeof(Version));
  FStreamVersion := Version;
end;


{ ----------------------------------------------------------------------------- }
{ Class that frees it self when the reference count goes to 0.  Like a com      }
{ object but the compiler does not inc/dec automaticlly                         }
{ ----------------------------------------------------------------------------- }

{ TReferenceCounted }

procedure TReferenceCounted.AddRef;
begin
  InterlockedIncrement(FRefCount)
end;

procedure TReferenceCounted.Release;
begin
  InterlockedDecrement (FRefCount);
  if FRefCount <= 0 then
    Free;
end;


{ ----------------------------------------------------------------------------- }
{ TList that frees it self when the reference count goes to 0.  Like a com      }
{ object but the compiler does not inc/dec automaticlly                         }
{ ----------------------------------------------------------------------------- }

{ TReferenceCountedList }

procedure TReferenceCountedList.AddRef;
begin
  InterlockedIncrement(FRefCount)
end;

procedure TReferenceCountedList.Release;
begin
  InterlockedDecrement (FRefCount);
  if FRefCount <= 0 then
    Free;
end;

{ TShellSortHelper }

function TShellSortHelper.CompareIDSort(SortColumn: integer; NS1,
  NS2: TNamespace): Integer;
begin
  if Assigned(NS1.ParentShellFolder) then
  begin
    {11.14.02}

 //   Result := ShortInt( NS1.ParentShellFolder.CompareIDs(
 //     SortColumn, NS1.RelativePIDL, NS2.RelativePIDL));

    Result := NS2.ComparePIDL(NS1.RelativePIDL, False, SortColumn);
    {11.14.02 END}
    { If we are not sorting the Name column then do a sub-sort on the name if   }
    { the items are equal.                                                      }
    if (SortColumn > 0) and (Result = 0) then
      Result := StrCompW(PWideChar( NS1.NameNormal), PWideChar( NS2.NameNormal))
  end else
    Result := 0;
end;

function TShellSortHelper.DiscriminateFolders(NS1,
  NS2: TNamespace): Integer;
begin
  Result := 0;
  if NS1.Folder xor NS2.Folder then
  begin
    if NS1.Folder and not NS2.Folder then
      Result := -1
    else
    if not NS1.Folder and NS2.Folder then
      Result := 1
  end
end;

function TShellSortHelper.SortFileSize(NS1, NS2: TNamespace): Integer;
begin
  Result := DiscriminateFolders(NS1, NS2);
  if Result = 0 then
  begin
    if NS1.SizeOfFileInt64 > NS2.SizeOfFileInt64 then
      Result := 1
    else
    if NS1.SizeOfFileInt64 < NS2.SizeOfFileInt64 then
      Result := -1
    else
       Result := CompareIDSort(0, NS1, NS2)
  end
end;

function TShellSortHelper.SortFileTime(FT1, FT2: TFileTime; NS1,
  NS2: TNamespace): Integer;
begin
  Result := DiscriminateFolders(NS1, NS2);
  if Result = 0 then
  begin
    Result := CompareFileTime(FT1, FT2);
    if Result = 0 then
       Result := CompareIDSort(0, NS1, NS2)
  end
end;

function TShellSortHelper.SortString(S1, S2: WideString; NS1,
  NS2: TNamespace): Integer;
begin
  Result := DiscriminateFolders(NS1, NS2);
  if Result = 0 then
  begin
    Result := StrCompW(PWideChar( S1), PWideChar(S2));
    if Result = 0 then
      Result := CompareIDSort(0, NS1, NS2)
  end
end;

function TShellSortHelper.SortType(NS1, NS2: TNamespace): Integer;
begin
  if FileSort = fsFileType then
    Result := SortString(NS1.FileType, NS2.FileType, NS1, NS2)
  else begin
    { Must be  fsFileExtension }
    Result := DiscriminateFolders(NS1, NS2);
    if Result = 0 then
    begin
      if NS1.FileSystem and NS2.FileSystem then
      begin
        Result := SortString(ExtractFileExt(NS1.NameParseAddress), ExtractFileExt(NS2.NameParseAddress), NS1, NS2);
        if Result = 0 then
          CompareIDSort(0, NS1, NS2);  // Secondary sort
      end;
    end
  end
end;

initialization
 // if IsWinNT4 then
    FileIconInit(True);  // This MUST be before the Namespaces are created or it won't work because the IconCache may have an icon in from the namespace
  if not LoadShell32Functions then
    Halt(0);
  PIDLMgr := TPIDLManager.Create;
  DesktopFolder := CreateSpecialNamespace(CSIDL_DESKTOP);
  RecycleBinFolder := CreateSpecialNamespace(CSIDL_BITBUCKET);
  PhysicalDesktopFolder := CreateSpecialNamespace(CSIDL_DESKTOPDIRECTORY);
  DrivesFolder := CreateSpecialNamespace(CSIDL_DRIVES);
  PrinterFolder := CreateSpecialNamespace(CSIDL_PRINTERS);
  HistoryFolder := CreateSpecialNamespace(CSIDL_HISTORY);
  ControlPanelFolder :=  CreateSpecialNamespace(CSIDL_CONTROLS);
  NetworkNeighborHoodFolder :=  CreateSpecialNamespace(CSIDL_NETWORK);
  TemplatesFolder := CreateSpecialNamespace(CSIDL_TEMPLATES);
  MyDocumentsFolder := CreateSpecialNamespace(CSIDL_PERSONAL);
  FavoritesFolder := CreateSpecialNamespace(CSIDL_FAVORITES);

finalization
  FreeAndNil(DesktopFolder);
  FreeAndNil(RecycleBinFolder);
  FreeAndNil(PhysicalDesktopFolder);
  FreeAndNil(DrivesFolder);
  FreeAndNil(HistoryFolder);
  FreeAndNil(PrinterFolder);
  FreeAndNil(ControlPanelFolder);
  FreeAndNil(NetworkNeighborHoodFolder);
  FreeAndNil(TemplatesFolder);
  FreeAndNil(MyDocumentsFolder);
  FreeAndNil(FavoritesFolder);
  FreeAndNil(PIDLMgr);
end.










