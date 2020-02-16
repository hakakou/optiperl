unit VirtualShellTypes;

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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  ImgList, ShlObj, ShellAPI, ActiveX, ComObj;


  { Some stuff to make BCB5 Happy }

(*$HPPEMIT 'namespace Virtualshellutilities { class TNamespace; }'*)
{$HPPEMIT 'typedef DelphiInterface<IDropTarget>   _di_IDropTarget;'}
{$HPPEMIT 'typedef DelphiInterface<IQueryInfo>    _di_IQueryInfo;'}
{$HPPEMIT '//If you have undefined "IQueryInfo" on the previous line, add NO_WIN32_LEAN_AND_MEAN to defined conditionals'}
{$HPPEMIT 'typedef DelphiInterface<IContextMenu3> _di_IContextMenu3;'}
{$HPPEMIT 'typedef DelphiInterface<IEnumString> _di_IEnumString;'}
{$HPPEMIT 'typedef DelphiInterface<IAutoComplete> _di_IAutoComplete;'}
{$HPPEMIT 'typedef DelphiInterface<IAutoComplete2> _di_IAutoComplete2;'}
{$HPPEMIT 'typedef DelphiInterface<IACList> _di_IACList;'}
{$HPPEMIT 'typedef DelphiInterface<IACList2> _di_IACList2;'}
{$HPPEMIT 'typedef DelphiInterface<ICurrentWorkingDirectory> _di_ICurrentWorkingDirectory;'}
{$HPPEMIT 'typedef DelphiInterface<IShellIconOverlay> _di_IShellIconOverlay;'}
{$HPPEMIT '#include "comcat.h";'}
(*$HPPEMIT 'namespace Activex { typedef DelphiInterface<IEnumGUID> _di_IEnumGUID; }'*)

//------------------------------------------------------------------------------
// Missing Windows Message definitions
//------------------------------------------------------------------------------

{$IFDEF COMPILER_4}
type
  TWMContextMenu = packed record
    Msg: Cardinal;
    hWnd: HWND;
    case Integer of
      0: (
        XPos: Smallint;
        YPos: Smallint);
      1: (
        Pos: TSmallPoint;
        Result: Longint);
  end;
{$ENDIF}

{$IFNDEF DELPHI_7_UP}
type
  TWMPrint = packed record
    Msg: Cardinal;
    DC: HDC;
    Flags: Cardinal;
    Result: Integer;
  end;

  TWMPrintClient = TWMPrint;
{$ENDIF}

//------------------------------------------------------------------------------
// New ImageList styles
//------------------------------------------------------------------------------

const
  {$EXTERNALSYM ILD_PRESERVEALPHA}
  ILD_PRESERVEALPHA = $00001000;

//------------------------------------------------------------------------------
// Some new magic extended Listview Styles
//------------------------------------------------------------------------------
const
  LVS_EX_DOUBLEBUFFER = $00010000;

//------------------------------------------------------------------------------
// Undocumented SHChangeNotifier Registration Constants and Types
//------------------------------------------------------------------------------
const
  {$EXTERNALSYM SHCNF_ACCEPT_INTERRUPTS}
  SHCNF_ACCEPT_INTERRUPTS     = $0001;
  {$EXTERNALSYM SHCNF_ACCEPT_NON_INTERRUPTS}
  SHCNF_ACCEPT_NON_INTERRUPTS = $0002;
  {$EXTERNALSYM SHCNF_NO_PROXY}
  SHCNF_NO_PROXY              = $8000;

type
  // Structures for the undocumented ChangeNotify handler
  TNotifyRegister = packed record // Structure that is passed to the SHChangeNotifyRegister Function
    ItemIDList: PItemIDList;
    bWatchSubTree: Bool;
  end;

  PDWordItemID = ^TDWordItemID; // Structure is what is passed in the wParam of the notify message when the notification is FreeSpace, ImageUpdate or anything with the SHCNF_DWORD flag.
  TDWordItemID = packed record
    cb: Word; { Size of Structure }
    dwItem1: DWORD;
    dwItem2: DWORD;
  end;

  PShellNotifyRec = ^TShellNotifyRec; // Structure is what is passed in the wParam of the notify message when the notification is anything with the SHCNF_IDLIST flag.
  TShellNotifyRec = packed record
    PIDL1,                           // Most ne_xxxx Notifications
    PIDL2: PItemIDList;
  end;

//------------------------------------------------------------------------------
// IContextMenu interfaces redefined to take advanatage of the Unicode Support
//------------------------------------------------------------------------------
type
  {$EXTERNALSYM IContextMenu}
  IContextMenu = interface(IUnknown)
    [SID_IContextMenu]
    function QueryContextMenu(Menu: HMENU;
      indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfoEx): HResult; stdcall;
    function GetCommandString(idCmd, uType: UINT; pwReserved: PUINT;
      pszName: LPSTR; cchMax: UINT): HResult; stdcall;
  end;

  {$EXTERNALSYM IContextMenu2}
  IContextMenu2 = interface(IContextMenu)
    [SID_IContextMenu2]
    function HandleMenuMsg(uMsg: UINT; WParam, LParam: Integer): HResult; stdcall;
  end;

  {$EXTERNALSYM IContextMenu3}
  IContextMenu3 = interface(IContextMenu2)
  [SID_IContextMenu3]
    function HandleMenuMsg2(uMsg: UINT; wParam, lParam: Integer;
      var lpResult: Integer): HResult; stdcall;
  end;

  {$EXTERNALSYM IShellIconOverlay}
  IShellIconOverlay = interface(IUnknown)
  [SID_IShellIconOverlay]
    function GetOverlayIndex(pidl: PItemIDList; var pIndex): HResult; stdcall;
    function GetOverlayIconIndex(pidl: PItemIDList; var pIconIndex): HResult; stdcall;
  end;


//------------------------------------------------------------------------------
// Button Constants
//------------------------------------------------------------------------------
const
  {$EXTERNALSYM MK_ALT}
  MK_ALT = $0020;
  {$EXTERNALSYM MK_BUTTON}
  MK_BUTTON = MK_LBUTTON or MK_RBUTTON or MK_MBUTTON;

//------------------------------------------------------------------------------
// Listview Column Constants
//------------------------------------------------------------------------------
const
  {$EXTERNALSYM LVCFMT_LEFT}
  LVCFMT_LEFT             = $0000;
  {$EXTERNALSYM LVCFMT_RIGHT}
  LVCFMT_RIGHT            = $0001;
  {$EXTERNALSYM LVCFMT_CENTER}
  LVCFMT_CENTER           = $0002;
  {$EXTERNALSYM LVCFMT_COL_HAS_IMAGES}
  LVCFMT_COL_HAS_IMAGES   = $8000;

//------------------------------------------------------------------------------
// New IShellFolder Constants and Types
//------------------------------------------------------------------------------
  {$EXTERNALSYM SFGAO_CANMONIKER}
  SFGAO_CANMONIKER = $400000;      // Defunct
  {$EXTERNALSYM SFGAO_HASSTORAGE}
  SFGAO_HASSTORAGE = $400000;      // Defunct
  {$EXTERNALSYM SFGAO_ENCRYPTED}
  SFGAO_ENCRYPTED = $2000;
  {$EXTERNALSYM SFGAO_ISSLOW}
  SFGAO_ISSLOW = $4000;
  {$EXTERNALSYM SFGAO_STORAGE}
  SFGAO_STORAGE = $0008;          // supports BindToObject(IID_IStorage)
  {$EXTERNALSYM SFGAO_STORAGEANCESTOR}
  SFGAO_STORAGEANCESTOR = $800000;// may contain children with SFGAO_STORAGE or SFGAO_STREAM
  {$EXTERNALSYM SFGAO_STREAM}
  SFGAO_STREAM = $400000;         // supports BindToObject(IID_IStream)



//------------------------------------------------------------------------------
// IShellIcon Constants and Types
//------------------------------------------------------------------------------
const
  // Constants for IShellIcon interface
  ICON_BLANK = 0;           // Unassocaiated file
  ICON_DATA  = 1;           // With data
  ICON_APP   = 2;           // Application, bat file etc
  ICON_FOLDER = 3;          // Plain folder
  ICON_FOLDEROPEN = 4;      // Open Folder

//------------------------------------------------------------------------------
// Drag Drop Image Helper Interfaces
//------------------------------------------------------------------------------

const
  {$EXTERNALSYM CLSID_NewMenu}
  CLSID_NewMenu: TGUID = (
    D1:$D969A300; D2:$E7FF; D3:$11d0; D4:($A9,$3B,$00,$A0,$C9,$0F,$27,$19));

  {$EXTERNALSYM IID_IDropTargetHelper}
  IID_IDropTargetHelper: TGUID = (
    D1:$4657278B; D2:$411B; D3:$11d2; D4:($83,$9A,$00,$C0,$4F,$D9,$18,$D0));
  {$EXTERNALSYM IID_IDragSourceHelper}
  IID_IDragSourceHelper: TGUID = (
    D1:$DE5BF786; D2:$477A; D3:$11d2; D4:($83,$9D,$00,$C0,$4F,$D9,$18,$D0));
  {$EXTERNALSYM CLSID_DragDropHelper}
  CLSID_DragDropHelper: TGUID = (
    D1:$4657278A; D2:$411B; D3:$11d2; D4:($83,$9A,$00,$C0,$4F,$D9,$18,$D0));

  {$EXTERNALSYM SID_IDropTargetHelper}
  SID_IDropTargetHelper = '{4657278B-411B-11d2-839A-00C04FD918D0}';
  {$EXTERNALSYM SID_IDragSourceHelper}
  SID_IDragSourceHelper = '{DE5BF786-477A-11d2-839D-00C04FD918D0}';
  {$EXTERNALSYM SID_IDropTarget}
  SID_IDropTarget = '{00000122-0000-0000-C000-000000000046}';

type
  {$EXTERNALSYM IDropTargetHelper}
  IDropTargetHelper = interface(IUnknown)
    [SID_IDropTargetHelper]
    function DragEnter(hwndTarget: HWND; pDataObject: IDataObject; var ppt: TPoint; dwEffect: Integer): HRESULT; stdcall;
    function DragLeave: HRESULT; stdcall;
    function DragOver(var ppt: TPoint; dwEffect: Integer): HRESULT; stdcall;
    function Drop(pDataObject: IDataObject; var ppt: TPoint; dwEffect: Integer): HRESULT; stdcall;
    function Show(fShow: Boolean): HRESULT; stdcall;
  end;

  PSHDragImage = ^TSHDragImage;
  TSHDragImage = packed record
    sizeDragImage: TSize;
    ptOffset: TPoint;
    hbmpDragImage: HBITMAP;
    ColorRef: TColorRef;
  end;

  {$EXTERNALSYM IDragSourceHelper}
  IDragSourceHelper = interface(IUnknown)
    [SID_IDragSourceHelper]
    function InitializeFromBitmap(var SHDragImage: TSHDragImage; pDataObject: IDataObject): HRESULT; stdcall;
    function InitializeFromWindow(Window: HWND; var ppt: TPoint; pDataObject: IDataObject): HRESULT; stdcall;
  end;
  
//------------------------------------------------------------------------------
// IExtractImage definitions.
//------------------------------------------------------------------------------

const
  {$EXTERNALSYM SID_IExtractImage}
  SID_IExtractImage = '{BB2E617C-0920-11d1-9A0B-00C04FC2D6C1}';
  {$EXTERNALSYM SID_IExtractImage2}
  SID_IExtractImage2 = '{953BB1EE-93B4-11d1-98A3-00C04FB687DA}';
  {$EXTERNALSYM IID_IExtractImage}
  IID_IExtractImage: TGUID = SID_IExtractImage;
  {$EXTERNALSYM IID_IExtractImage2}
  IID_IExtractImage2: TGUID = SID_IExtractImage2;

type
  IExtractImage = interface(IUnknown)
    [SID_IExtractImage]
    function GetLocation(Buffer: PWideChar;
                         BufferSize: DWORD;
                         var Priority: DWORD;
                         var Size: TSize;
                         ColorDepth: DWORD;
                         var Flags: DWORD ): HResult; stdcall;
    function Extract(var BmpImage: HBITMAP): HResult; stdcall;
  end;

  IExtractImage2 = interface(IExtractImage)
    [SID_IExtractImage2]
    function GetTimeStamp(var DateStamp: TFILETIME): HResult; stdcall;
  end;

const
  {$EXTERNALSYM IEI_PRIORITY_MAX}
  IEI_PRIORITY_MAX     = $0002;
  {$EXTERNALSYM IEI_PRIORITY_MIN}
  IEI_PRIORITY_MIN     = $0001;
  {$EXTERNALSYM IEI_PRIORITY_NORMAL}
  IEI_PRIORITY_NORMAL  = $0000;

  {$EXTERNALSYM IEIFLAG_ASYNC}
  IEIFLAG_ASYNC    = $0001;     // ask the extractor if it supports ASYNC extract (free threaded)
  {$EXTERNALSYM IEIFLAG_CACHE}
  IEIFLAG_CACHE    = $0002;     // returned from the extractor if it does NOT cache the thumbnail
  {$EXTERNALSYM IEIFLAG_ASPECT}
  IEIFLAG_ASPECT   = $0004;     // passed to the extractor to beg it to render to the aspect ratio of the supplied rect
  {$EXTERNALSYM IEIFLAG_OFFLINE}
  IEIFLAG_OFFLINE  = $0008;     // if the extractor shouldn't hit the net to get any content neede for the rendering
  {$EXTERNALSYM IEIFLAG_GLEAM}
  IEIFLAG_GLEAM    = $0010;     // does the image have a gleam ? this will be returned if it does
  {$EXTERNALSYM IEIFLAG_SCREEN}
  IEIFLAG_SCREEN   = $0020;     // render as if for the screen  (this is exlusive with IEIFLAG_ASPECT )
  {$EXTERNALSYM IEIFLAG_ORIGSIZE}
  IEIFLAG_ORIGSIZE = $0040;     // render to the approx size passed, but crop ifneccessary



//------------------------------------------------------------------------------
// IShellLink definitions.
//------------------------------------------------------------------------------

const
 {$EXTERNALSYM CLSID_ShellLinkW}
  CLSID_ShellLinkW: TGUID = (
    D1:$000214F9; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  { IShellLink HotKey Mofifiers }
  {$EXTERNALSYM HOTKEYF_SHIFT}
  HOTKEYF_SHIFT =       $01;
  {$EXTERNALSYM HOTKEYF_CONTROL}
  HOTKEYF_CONTROL =     $02;
  {$EXTERNALSYM HOTKEYF_ALT}
  HOTKEYF_ALT =         $04;
  {$EXTERNALSYM HOTKEYF_EXT}
  HOTKEYF_EXT =         $08;


{$IFNDEF DELPHI_7_UP}
// D7 defines this right, D5 and D6 do not
// _FILEGROUPDESCRIPTORW Corrected definitions.
type
  PFileGroupDescriptorW = ^TFileGroupDescriptorW;
  {$EXTERNALSYM _FILEGROUPDESCRIPTORW}
  _FILEGROUPDESCRIPTORW = record
    cItems: UINT;
    fgd: array[0..0] of TFileDescriptorW;
  end;
  TFileGroupDescriptorW = _FILEGROUPDESCRIPTORW;
{$ENDIF}

// IShellLinkW Corrected definitions.
type
  {$EXTERNALSYM IShellLinkW}
  IShellLinkW = interface(IUnknown) { sl }
    [SID_IShellLinkW]
    function GetPath(pszFile: PWideChar; cchMaxPath: Integer;
      var pfd: TWin32FindDataW; fFlags: DWORD): HResult; stdcall;
    function GetIDList(var ppidl: PItemIDList): HResult; stdcall;
    function SetIDList(pidl: PItemIDList): HResult; stdcall;
    function GetDescription(pszName: PWideChar; cchMaxName: Integer): HResult; stdcall;
    function SetDescription(pszName: PWideChar): HResult; stdcall;
    function GetWorkingDirectory(pszDir: PWideChar; cchMaxPath: Integer): HResult; stdcall;
    function SetWorkingDirectory(pszDir: PWideChar): HResult; stdcall;
    function GetArguments(pszArgs: PWideChar; cchMaxPath: Integer): HResult; stdcall;
    function SetArguments(pszArgs: PWideChar): HResult; stdcall;
    function GetHotkey(var pwHotkey: Word): HResult; stdcall;
    function SetHotkey(wHotkey: Word): HResult; stdcall;
    function GetShowCmd(out piShowCmd: Integer): HResult; stdcall;
    function SetShowCmd(iShowCmd: Integer): HResult; stdcall;
    function GetIconLocation(pszIconPath: PWideChar; cchIconPath: Integer;
      out piIcon: Integer): HResult; stdcall;
    function SetIconLocation(pszIconPath: PWideChar; iIcon: Integer): HResult; stdcall;
    function SetRelativePath(pszPathRel: PWideChar; dwReserved: DWORD): HResult; stdcall;
    function Resolve(Wnd: HWND; fFlags: DWORD): HResult; stdcall;
    function SetPath(pszFile: PWideChar): HResult; stdcall;
  end;

//------------------------------------------------------------------------------
// IShellDetails definitions.
//------------------------------------------------------------------------------

const
  {$EXTERNALSYM SID_IShellDetails}
  SID_IShellDetails = '{000214EC-0000-0000-C000-000000000046}';
  {$EXTERNALSYM IID_IShellDetails}
  IID_IShellDetails: TGUID = SID_IShellDetails;

type
  PShellDetails=^TShellDetails;
  tagSHELLDETAILS = packed record
    Fmt: Integer;
    cxChar: Integer;
    str: TStrRet;
  end;
  TShellDetails = tagSHELLDETAILS;

  {$IFNDEF CPPB_6_UP}
  IShellDetails=interface(IUnknown)
  {$ELSE}
  IShellDetailsBCB6=interface(IUnknown)
  {$ENDIF CPPB_6_UP}
    [SID_IShellDetails]
    function GetDetailsOf(PIDL: PItemIDList; iColumn: LongWord; var data: TShellDetails): HResult; stdcall;
    function ColumnClick(iColumn: LongWord): HResult; stdcall;
  end;

//------------------------------------------------------------------------------
// IShellFolder2 definitions.
//------------------------------------------------------------------------------

const
  {$EXTERNALSYM IID_IEnumExtraSearch}
  IID_IEnumExtraSearch: TGUID = (
    D1:$0E700BE1; D2:$9DB6; D3:$11D1; D4:($A1,$CE,$00,$00,$4F,$D7,$5D,$13));
  {$EXTERNALSYM IID_IShellFolder2}
  IID_IShellFolder2: TGUID = (
    D1:$93F2F68C; D2:$1D1B; D3:$11D3; D4:($A3,$0E,$00,$C0,$4F,$79,$AB,$D1));
  {$EXTERNALSYM IID_ITaskbarList}
  IID_ITaskbarList: TGUID = (
    D1:$56FDF342; D2:$FD6D; D3:$11D0; D4:($95,$8A,$00,$60,$97,$C9,$A0,$90));
  {$EXTERNALSYM IID_IDropTarget}
  IID_IDropTarget: TGUID = (
    D1:$00000122; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));
  {$EXTERNALSYM IID_IColumnProvider}
  IID_IColumnProvider: TGUID = (
    D1:$E8025004; D2:$1C42; D3:$11D2; D4:($BE,$2C,$00,$A0,$C9,$A8,$3D,$A1));

  CLSID_TaskbarList: TGUID = (
    D1:$56FDF344; D2:$FD6D; D3:$11D0; D4:($95,$8A,$00,$60,$97,$C9,$A0,$90));

  {$EXTERNALSYM SID_IShellFolder2}
  SID_IShellFolder2     = '{93F2F68C-1D1B-11D3-A30E-00C04F79ABD1}';
  {$EXTERNALSYM SID_IEnumExtraSearch}
  SID_IEnumExtraSearch  = '{0E700BE1-9DB6-11D1-A1CE-00004FD75D13}';
  {$EXTERNALSYM CLSID_TaskbarList}

const
  {$EXTERNALSYM SHCOLSTATE_TYPE_STR}
  SHCOLSTATE_TYPE_STR     = $00000001;
  {$EXTERNALSYM SHCOLSTATE_TYPE_INT}
  SHCOLSTATE_TYPE_INT     = $00000002;
  {$EXTERNALSYM SHCOLSTATE_TYPE_DATE}
  SHCOLSTATE_TYPE_DATE    = $00000003;
  {$EXTERNALSYM SHCOLSTATE_TYPEMASK}
  SHCOLSTATE_TYPEMASK     = $0000000F;
  {$EXTERNALSYM SHCOLSTATE_ONBYDEFAULT}
  SHCOLSTATE_ONBYDEFAULT  = $00000010;   // should on by default in details view
  {$EXTERNALSYM SHCOLSTATE_TYPE_SLOW}
  SHCOLSTATE_TYPE_SLOW    = $00000020;   // will be slow to compute, do on a background thread
 {$EXTERNALSYM SHCOLSTATE_EXTENDED}
  SHCOLSTATE_EXTENDED     = $00000040;   // provided by a handler, not the folder
 {$EXTERNALSYM SHCOLSTATE_SECONDARYUI}
  SHCOLSTATE_SECONDARYUI  = $00000080;   // not displayed in context menu, but listed in the "More..." dialog
 {$EXTERNALSYM SHCOLSTATE_HIDDEN}
  SHCOLSTATE_HIDDEN       = $00000100;   // not displayed in the UI

type
  tagEXTRASEARCH = record
    guidSearch: TGUID;
    wszFriendlyName: array[0..79] of WideChar;
    wszUrl: array[0..2083] of WideChar;
  end;
  PExtraSearch = ^TExtraSearch;
  TExtraSearch = tagEXTRASEARCH;

  {$EXTERNALSYM IEnumExtraSearch}
  IEnumExtraSearch = interface(IUnknown)
    [SID_IEnumExtraSearch]
    function Next(celt: ULONG; out rgElt: tagEXTRASEARCH; out pceltFetched: ULONG): HRESULT; stdcall;
    function Skip(celt: ULONG): HRESULT; stdcall;
    function Reset: HRESULT; stdcall;
    function Clone(out ppEnum: IEnumExtraSearch): HRESULT; stdcall;
  end;

const
  {$EXTERNALSYM MAX_COLUMN_NAME_LEN}
  MAX_COLUMN_NAME_LEN = 80;    // Windows Defined
  {$EXTERNALSYM MAX_COLUMN_DESC_LEN}
  MAX_COLUMN_DESC_LEN = 128;   // Windows Defined

  // These are the possibilites for the TSHColumnInfo structure
  {$EXTERNALSYM FMTID_Storage}
  FMTID_Storage: TGUID = (
    D1:$B725F130; D2:$47EF; D3:$101A; D4:($A5,$F1,$02,$60,$8C,$9E,$EB,$AC));
  {$EXTERNALSYM PID_STG_NAME}
  PID_STG_NAME = 10;        // The object's display name VT_BSTR
  {$EXTERNALSYM PID_STG_STORAGETYPE}
  PID_STG_STORAGETYPE = 4;  // The object's type VT_BSTR
  {$EXTERNALSYM PID_STG_SIZE}
  PID_STG_SIZE = 12;        // The object's size VT_BSTR
  {$EXTERNALSYM PID_STG_WRITETIME}
  PID_STG_WRITETIME = 14;   // The object's modified attribute VT_BSTR
  {$EXTERNALSYM PID_STG_ATTRIBUTES}
  PID_STG_ATTRIBUTES = 13;  // The object's attributes VT_BSTR

  {$EXTERNALSYM FMTID_ShellDetails}
  FMTID_ShellDetails: TGUID = (
    D1:$28636AA6; D2:$953D; D3:$11D2; D4:($B5,$D6,$00,$C0,$4F,$D9,$18,$D0));
  {$EXTERNALSYM PID_FINDDATA}
  PID_FINDDATA = 0;         // A WIN32_FIND_DATAW structure. VT_ARRAY | VT_UI1
  {$EXTERNALSYM PID_NETRESOURCE}
  PID_NETRESOURCE = 1;      // A NETRESOURCE structure. VT_ARRAY | VT_UI1
  {$EXTERNALSYM PID_DESCRIPTIONID}
  PID_DESCRIPTIONID = 2;    // A SHDESCRIPTIONID structure. VT_ARRAY | VT_UI1

  {$EXTERNALSYM FMTID_Displaced}
  FMTID_Displaced: TGUID = (
    D1:$9B174B33; D2:$40FF; D3:$11D2; D4:($A2,$7E,$00,$C0,$4F,$C3,$08,$71));
  {$EXTERNALSYM PID_DISPLACED_FROM}
  PID_DISPLACED_FROM = 2;
  {$EXTERNALSYM PID_DISPLACED_DATE}
  PID_DISPLACED_DATE = 3;

  {$EXTERNALSYM FMTID_Misc}
  FMTID_Misc: TGUID = (
    D1:$9B174B35; D2:$40FF; D3:$11D2; D4:($A2,$7E,$00,$C0,$4F,$C3,$08,$71));
  {$EXTERNALSYM PID_MISC_STATUS}
  PID_MISC_STATUS = 2;           // The synchronization status.
  {$EXTERNALSYM PID_MISC_ACCESSCOUNT}
  PID_MISC_ACCESSCOUNT = 3;      // Not used.
  {$EXTERNALSYM PID_MISC_OWNER}
  PID_MISC_OWNER = 4;            // Ownership of the file (for the NTFS file system).
         
  {$EXTERNALSYM FMTID_Volume}
  FMTID_Volume: TGUID = (
    D1:$49691C90; D2:$7E17; D3:$101A; D4:($A9,$1C,$08,$00,$2B,$2E,$CD,$A9));
  {$EXTERNALSYM PID_VOLUME_FREE}
  PID_VOLUME_FREE = 2;           // The amount of free space.

  {$EXTERNALSYM FMTID_Query}
  FMTID_Query: TGUID = (
    D1:$49691C90; D2:$7E17; D3:$101A; D4:($A9,$1C,$08,$00,$2B,$2E,$CD,$A9));
  {$EXTERNALSYM PID_QUERY_RANK}
  PID_QUERY_RANK = 2;            // The rank of the file.

  {$EXTERNALSYM FMTID_SummaryInformation}
  FMTID_SummaryInformation: TGUID = (
    D1:$F29F85E0; D2:$4FF9; D3:$1068; D4:($AB,$91,$08,$00,$2B,$27,$B3,$D9));
  {$EXTERNALSYM PIDSI_TITLE}
  PIDSI_TITLE         = 2;   // VT_LPSTR
  {$EXTERNALSYM PIDSI_SUBJECT}
  PIDSI_SUBJECT       = 3;   // VT_LPSTR
  {$EXTERNALSYM PIDSI_AUTHOR}
  PIDSI_AUTHOR        = 4;   // VT_LPSTR
  {$EXTERNALSYM PIDSI_KEYWORDS}
  PIDSI_KEYWORDS      = 5;   // VT_LPSTR
  {$EXTERNALSYM PIDSI_COMMENTS}
  PIDSI_COMMENTS      = 6;   // VT_LPSTR
  {$EXTERNALSYM PIDSI_TEMPLATE}
  PIDSI_TEMPLATE      = 7;   // VT_LPSTR
  {$EXTERNALSYM PIDSI_LASTAUTHOR}
  PIDSI_LASTAUTHOR    = 8;   // VT_LPSTR
  {$EXTERNALSYM PIDSI_REVNUMBER}
  PIDSI_REVNUMBER     = 9;   // VT_LPSTR
  {$EXTERNALSYM PIDSI_EDITTIME}
  PIDSI_EDITTIME      = 10;  // VT_FILETIME (UTC)
  {$EXTERNALSYM PIDSI_LASTPRINTED}
  PIDSI_LASTPRINTED   = 11;  // VT_FILETIME (UTC)
  {$EXTERNALSYM PIDSI_CREATE_DTM}
  PIDSI_CREATE_DTM    = 12;  // VT_FILETIME (UTC)
  {$EXTERNALSYM PIDSI_LASTSAVE_DTM}
  PIDSI_LASTSAVE_DTM  = 13;  // VT_FILETIME (UTC)
  {$EXTERNALSYM PIDSI_PAGECOUNT}
  PIDSI_PAGECOUNT     = 14;  // VT_I4
  {$EXTERNALSYM PIDSI_WORDCOUNT}
  PIDSI_WORDCOUNT     = 15;  // VT_I4
  {$EXTERNALSYM PIDSI_CHARCOUNT}
  PIDSI_CHARCOUNT     = 16;  // VT_I4
  {$EXTERNALSYM PIDSI_THUMBNAIL}
  PIDSI_THUMBNAIL     = 17;  // VT_CF
  {$EXTERNALSYM PIDSI_APPNAME}
  PIDSI_APPNAME       = 18;  // VT_LPSTR
  {$EXTERNALSYM PIDSI_DOC_SECURITY}
  PIDSI_DOC_SECURITY  = 19;  // VT_I4

type
  tagSHCOLUMNID = record
    fmtid: TGUID;
    pid: Cardinal;
  end;
  PSHColumnID = ^TSHColumnID;
  TSHColumnID = tagSHCOLUMNID;

  {$EXTERNALSYM IShellFolder2}
  IShellFolder2 = interface(IShellFolder)
    [SID_IShellFolder2]
    function GetDefaultSearchGUID(out pguid: TGUID): HRESULT; stdcall;
    function EnumSearches(out ppEnum: IEnumExtraSearch): HRESULT; stdcall;
    function GetDefaultColumn (dwRes: DWORD; out pSort: ULONG; out pDisplay: ULONG): HRESULT; stdcall;
    function GetDefaultColumnState(iColumn: UINT; out pcsFlags: DWORD): HRESULT; stdcall;
    function GetDetailsEx(pidl: PItemIDList; const pscid: TSHCOLUMNID; out pv: OleVariant): HRESULT; stdcall;
    function GetDetailsOf(pidl: PItemIDList; iColumn: UINT; out psd: tagSHELLDETAILS): HRESULT; stdcall;
    function MapColumnToSCID(iColumn: UINT; out pscid: tagSHCOLUMNID): HRESULT; stdcall;
  end;

//------------------------------------------------------------------------------
// SpecialFolder constants
//------------------------------------------------------------------------------

const
  {$EXTERNALSYM CSIDL_COMMON_ADMINTOOLS}
  CSIDL_COMMON_ADMINTOOLS = $002f;     // All Users\Start Menu\Programs\Administrative Tools
  {$EXTERNALSYM CSIDL_ADMINTOOLS}
  CSIDL_ADMINTOOLS      = $0030;
  {$EXTERNALSYM CSIDL_LOCAL_APPDATA}
  CSIDL_LOCAL_APPDATA   = $001C;      // non roaming, user\Local Settings\Application Data
  {$EXTERNALSYM CSIDL_COOKIES}
  CSIDL_COOKIES         = $0021;
  {$EXTERNALSYM CSIDL_COMMON_APPDATA}
  CSIDL_COMMON_APPDATA  = $0023;      // All Users\Application Data
  {$EXTERNALSYM CSIDL_COMMON_TEMPLATES}
  CSIDL_COMMON_TEMPLATES = $002D;
  {$EXTERNALSYM CSIDL_WINDOWS}
  CSIDL_WINDOWS         = $0024;      // GetWindowsDirectory()
  {$EXTERNALSYM CSIDL_SYSTEM}
  CSIDL_SYSTEM          = $0025;      // GetSystemDirectory()
  {$EXTERNALSYM CSIDL_PROFILE}
  CSIDL_PROFILE         = $0028;      // USERPROFILE
  {$EXTERNALSYM CSIDL_PROGRAM_FILES}
  CSIDL_PROGRAM_FILES   = $0026;      // C:\Program Files
  {$EXTERNALSYM CSIDL_MYPICTURES}
  CSIDL_MYPICTURES      = $0027;      // My Pictures, new for Win2K
  {$EXTERNALSYM CSIDL_PROGRAM_FILES_COMMON}
  CSIDL_PROGRAM_FILES_COMMON = $002b; // C:\Program Files\Common
  {$EXTERNALSYM CSIDL_COMMON_DOCUMENTS}
  CSIDL_COMMON_DOCUMENTS = $002E;

//------------------------------------------------------------------------------
// AutoComplete definitions
//------------------------------------------------------------------------------

const
  {$EXTERNALSYM CLSID_AutoComplete}
  CLSID_AutoComplete: TGUID = (
    D1:$00BB2763; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM CLSID_ACLHistory}
  CLSID_ACLHistory: TGUID = (
    D1:$00BB2764; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM CLSID_ACListISF}
  CLSID_ACListISF: TGUID = (
    D1:$03C036F1; D2:$A186; D3:$11D0; D4:($82,$4A,$00,$AA,$00,$5B,$43,$83));
  {$EXTERNALSYM CLSID_ACLMRU}
  CLSID_ACLMRU: TGUID = (
    D1:$6756a641; D2:$DE71; D3:$11D0; D4:($83,$1B,$00,$AA,$00,$5B,$43,$83));
  {$EXTERNALSYM CLSID_ACLMulti}
  CLSID_ACLMulti: TGUID = (
    D1:$00BB2765; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));

  {$EXTERNALSYM IID_IAutoComplete}
  IID_IAutoComplete: TGUID = (
    D1:$00BB2762; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM IID_IAutoComplete2}
  IID_IAutoComplete2: TGUID = (
    D1:$EAC04BC0; D2:$3791; D3:$11D2; D4:($BB,$95,$00,$60,$97,$7B,$46,$4C));
  {$EXTERNALSYM IID_IAutoCompList}
  IID_IAutoCompList: TGUID = (
    D1:$00BB2760; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM IID_IObjMgr}
  IID_IObjMgr: TGUID = (
    D1:$00BB2761; D2:$6A77; D3:$11D0; D4:($A5,$35,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM IID_IACList}
  IID_IACList: TGUID = (
    D1:$77A130B0; D2:$94FD; D3:$11D0; D4:($A5,$44,$00,$C0,$4F,$D7,$D0,$62));
  {$EXTERNALSYM IID_IACList2}
  IID_IACList2: TGUID = (
    D1:$470141A0; D2:$5186; D3:$11D2; D4:($BB,$B6,$00,$60,$97,$7B,$46,$4C));
  {$EXTERNALSYM IID_ICurrentWorkingDirectory}
  IID_ICurrentWorkingDirectory: TGUID = (
    D1:$91956d21; D2:$9276; D3:$11D1; D4:($92,$1A,$00,$60,$97,$DF,$5B,$D4));
  {$EXTERNALSYM IID_IEnumString}
  IID_IEnumString: TGUID = (
    D1:$00000101; D2:$0000; D3:$0000; D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  {$EXTERNALSYM SID_IEmumString}
  SID_IEmumString              = '{00000101-0000-0000-C000-000000000046}';
  {$EXTERNALSYM SID_IAutoComplete}
  SID_IAutoComplete            = '{00BB2762-6A77-11D0-A535-00C04FD7D062}';
  {$EXTERNALSYM SID_IAutoComplete2}
  SID_IAutoComplete2           = '{EAC04BC0-3791-11D2-BB95-0060977B464C}';
  {$EXTERNALSYM SID_IACList}
  SID_IACList                  = '{77A130B0-94FD-11D0-A544-00C04FD7d062}';
  {$EXTERNALSYM SID_IACList2}
  SID_IACList2                 = '{470141A0-5186-11D2-BBB6-0060977B464C}';
  {$EXTERNALSYM SID_ICurrentWorkingDirectory}
  SID_ICurrentWorkingDirectory = '{91956D21-9276-11D1-921A-006097DF5BD4}';
  {$EXTERNALSYM SID_IObjMgr}
  SID_IObjMgr                  = '{00BB2761-6A77-11D0-A535-00C04FD7D062}';

  { AutoComplete2 Options }
  {$EXTERNALSYM ACO_NONE}
  ACO_NONE           = $0000;
  {$EXTERNALSYM ACO_AUTOSUGGEST}
  ACO_AUTOSUGGEST   = $0001;
  {$EXTERNALSYM ACO_AUTOAPPEND}
  ACO_AUTOAPPEND   = $0002;
  {$EXTERNALSYM ACO_SEARCH}
  ACO_SEARCH           = $0004;
  {$EXTERNALSYM ACO_FILTERPREFIXES}
  ACO_FILTERPREFIXES   = $0008;
  {$EXTERNALSYM ACO_USETAB}
  ACO_USETAB           = $0010;
  {$EXTERNALSYM ACO_UPDOWNKEYDROPSLIST}
  ACO_UPDOWNKEYDROPSLIST = $0020;
  {$EXTERNALSYM ACO_RTLREADING}
  ACO_RTLREADING   = $0040;

  // ACList2 Options
  {$EXTERNALSYM ACLO_NONE}
  ACLO_NONE            = $0000;    // don't enumerate anything
  {$EXTERNALSYM ACLO_CURRENTDIR}
  ACLO_CURRENTDIR      = $0001;    // enumerate current directory
  {$EXTERNALSYM ACLO_MYCOMPUTER}
  ACLO_MYCOMPUTER      = $0002;    // enumerate MyComputer
  {$EXTERNALSYM ACLO_DESKTOP}
  ACLO_DESKTOP         = $0004;    // enumerate Desktop Folder
  {$EXTERNALSYM ACLO_FAVORITES}
  ACLO_FAVORITES       = $0008;    // enumerate Favorites Folder
  {$EXTERNALSYM ACLO_FILESYSONLY}
  ACLO_FILESYSONLY     = $0010;   // enumerate only the file system
  {$EXTERNALSYM ACLO_FILESYSDIRS}
  ACLO_FILESYSDIRS     = $0020;   // Enumerate only the file system directories, Universal Naming Convention (UNC) shares, and UNC servers.


  ACLO_ALLOBJECTS = ACLO_CURRENTDIR or ACLO_MYCOMPUTER or ACLO_DESKTOP or ACLO_FAVORITES;

type
  {$EXTERNALSYM IAutoComplete}
  IAutoComplete = interface(IUnknown)
    [SID_IAutoComplete]
    function Init( hWndEdit: HWND; punkACL: IUnknown; RegKeyPath, QuickComplete: POleStr): HRESULT; stdcall;
    function Enabled(fEnable: BOOL): HRESULT; stdcall;
  end;

  {$EXTERNALSYM IAutoComplete2}
  IAutoComplete2 = interface(IAutoComplete)
    ['{EAC04BC0-3791-11d2-BB95-0060977B464C}']
    function SetOptions(dwFlag: DWORD): HRESULT; stdcall;
    function GetOptions(out pdwFlag: DWORD): HRESULT; stdcall;
  end;

  {$EXTERNALSYM IACList}
  IACList = interface(IUnknown)
    [SID_IACList]
    function Expand(pazExpand: LPCWSTR): HRESULT; stdcall;
  end;

  {$EXTERNALSYM IACList2}
  IACList2 = interface(IACList)
    [SID_IACList2]
    function SetOptions(pdwFlag: DWORD): HRESULT; stdcall;
    function GetOptions(var pdwFlag: DWORD): HRESULT; stdcall;
  end;

  {$EXTERNALSYM ICurrentWorkingDirectory}
  ICurrentWorkingDirectory = interface(IUnknown)
    [SID_ICurrentWorkingDirectory]
    function GetDirectory(pwzPath: LPCWSTR; cchSize: DWORD): HRESULT; stdcall;
    function SetDirectory(pwzPath: LPCWSTR): HRESULT; stdcall;
  end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Catagory Interfaces
//------------------------------------------------------------------------------

const
  {$EXTERNALSYM SID_ICategorizer}
  SID_ICategorizer = '{A3B14589-9174-49A8-89A3-06A1AE2B9BA7}';

  {$EXTERNALSYM SID_ICategoryProvider}
  SID_ICategoryProvider = '{9AF64809-5864-4C26-A720-C1F78C086EE3}';

  {$EXTERNALSYM IID_ICategorizer}
  IID_ICategorizer: TGUID = (
    D1:$A3B14589; D2:$9174; D3:$49A8; D4:($89,$A3,$06,$A1,$AE,$2B,$9B,$A7));
  {$EXTERNALSYM IID_ICategoryProvider}
  IID_ICategoryProvider: TGUID = (
    D1:$9AF64809; D2:$5864; D3:$4C26; D4:($A7,$20,$C1,$F7,$8C,$08,$6E,$E3));

  {$EXTERNALSYM CLSID_DefCategoryProvider}
  CLSID_DefCategoryProvider: TGUID = (
    D1:$B2F2E083; D2:$84FE; D3:$4a7e; D4:($80,$C3,$4B,$50,$D1,$0D,$64,$6E));
  {$EXTERNALSYM CLSID_AlphabeticalCategorizer}
  CLSID_AlphabeticalCategorizer: TGUID = (
    D1:$3C2654C6; D2:$7372; D3:$4F6B; D4:($B3,$10,$55,$D6,$12,$8F,$49,$D2));
  {$EXTERNALSYM CLSID_DriveSizeCategorizer}
  CLSID_DriveSizeCategorizer: TGUID = (
    D1:$94357B53; D2:$CA29; D3:$4B78; D4:($83,$AE,$E8,$FE,$74,$09,$13,$4F));
  {$EXTERNALSYM CLSID_DriveTypeCategorizer}
  CLSID_DriveTypeCategorizer: TGUID = (
    D1:$B0A8F3CF; D2:$4333; D3:$4BAB; D4:($88,$73,$1C,$CB,$1C,$AD,$A4,$8B));
  {$EXTERNALSYM CLSID_FreeSpaceCategorizer}
  CLSID_FreeSpaceCategorizer: TGUID = (
    D1:$B5607793; D2:$24AC; D3:$44C7; D4:($82,$E2,$83,$17,$26,$AA,$6C,$B7));
  {$EXTERNALSYM CLSID_SizeCategorizer}
  CLSID_SizeCategorizer: TGUID = (
    D1:$55D7B852; D2:$F6D1; D3:$42F2; D4:($AA,$75,$87,$28,$A1,$B2,$D2,$64));
  {$EXTERNALSYM CLSID_TimeCategorizer}
  CLSID_TimeCategorizer: TGUID = (
    D1:$3BB4118F; D2:$DDFD; D3:$4D30; D4:($A3,$48,$9F,$B5,$D6,$BF,$1A,$FE));
  {$EXTERNALSYM CLSID_MergedCategorizer}
  CLSID_MergedCategorizer: TGUID = (
    D1:$8E827C11; D2:$33E7; D3:$4BC1; D4:($B2,$42,$8C,$D9,$A1,$C2,$B3,$04));

  {$EXTERNALSYM CATINFO_NORMAL}
  CATINFO_NORMAL = $0000;
  {$EXTERNALSYM CATINFO_COLLAPSED}
  CATINFO_COLLAPSED = $00000001;
  {$EXTERNALSYM CATINFO_HIDDEN}
  CATINFO_HIDDEN = $00000002;

  {$EXTERNALSYM CATSORT_DEFAULT}
  CATSORT_DEFAULT = $00000000;
  {$EXTERNALSYM CATSORT_NAME}
  CATSORT_NAME = $00000001;

type
  {.$EXTERNALSYM TCategoryInfo}
  TCategoryInfo = packed record
    CategoryInfo: DWORD;  // a CATINFO_XXXX constant
    wscName: array[0..259] of WideChar;
  end;

  {.$EXTERNALSYM ICategorizer}
  ICategorizer = interface(IUnknown)
  [SID_ICategorizer]
    function GetDescription(pszDesc: LPWSTR; cch: UINT): HRESULT; stdcall;
    function GetCategory(cidl: UINT; apidl: PItemIDList; rgCategoryIds: TWordArray): HRESULT; stdcall;
    function GetCategoryInfo(dwCategoryId: DWORD; var pci: TCategoryInfo): HRESULT; stdcall;
    function CompareCategory(csfFlags: DWORD; dwCategoryId1, dwCategoryId2: DWORD): HRESULT; stdcall;
  end;

  {.$EXTERNALSYM ICategoryProvider}
  ICategoryProvider = interface(IUnknown)
  [SID_ICategoryProvider]
    function CanCategorizeOnSCID(var pscid: TSHColumnID): HRESULT; stdcall;
    function GetDefaultCategory(var pguid: TGUID; var pscid: TSHColumnID): HRESULT; stdcall;
    function GetCategoryForSCID(var pscid: TSHColumnID; var pguid: TGUID): HRESULT; stdcall;
    function EnumCategories(out penum: IEnumGUID): HRESULT; stdcall;
    function GetCategoryName(const pguid: TGUID; pszName: PWideChar; cch: UINT): HRESULT; stdcall;
    function CreateCategory(const pguid: TGUID; const riid: TGUID; out ppv: ICategorizer): HRESULT; stdcall;
  end;


const
  {$EXTERNALSYM IID_IBrowserFrameOptions}
  IID_IBrowserFrameOptions : TGUID = (
    D1:$10DF43C8; D2:$1DBE; D3:$11D3; D4:($8B,$34,$00,$60,$97,$DF,$5B,$D4));
  SID_IBrowserFrameOptions  = '{10DF43C8-1DBE-11D3-8B34-006097DF5BD4}';

  type
    TBrowserFrameOption = (
      bfoBrowserPersistSettings,
      bfoRenameFolderOptionsToInternet,
      bfoBothOptions,
      bfoPreferInternetShortcut,
      bfoBrowseNoInNewProcess,
      bfoEnableHyperlinkTracking,
      bfoUseIEOfflineSupport,
      bfoSubstituteInternetStartPage,
      bfoUseIELogoBanding,
      bfoAddIEToCaptionBar,
      bfoUseDialupRef,
      bfoUseIEToolbar,
      bfoNoParentFolderSupport,
      bfoNoReopenNextRestart,
      bfoGoHomePage,
      bfoPreferIEProcess,
      bfoShowNavigationCancelled
    );
  TBrowserFrameOptions = set of TBrowserFrameOption;

const
  bfoNone = [];
  bfoQueryAll  = [bfoBrowserPersistSettings..bfoShowNavigationCancelled];

type
  {.$EXTERNALSYM IBrowserFrameOptions}
  IBrowserFrameOptions = interface(IUnknown)
  [SID_IBrowserFrameOptions]
    function GetFrameOptions(dwRequested : DWORD; var pdwResult : DWORD) : HResult; stdcall;
  end;

const
  {$EXTERNALSYM IID_IQueryAssociations}
  IID_IQueryAssociations: TGUID = (
    D1:$C46CA590; D2:$3C3F; D3:$11D2; D4:($BE, $E6, $00, $00, $F8, $05, $CA, $57));
  {$EXTERNALSYM SID_IQueryAssociations}
  SID_IQueryAssociations = '{C46CA590-3C3F-11D2-BEE6-0000F805CA57}';


  {$EXTERNALSYM ASSOCF_INIT_NOREMAPCLSID}
  ASSOCF_INIT_NOREMAPCLSID    = $00000001;   //  do not remap clsids to progids
  {$EXTERNALSYM ASSOCF_INIT_BYEXENAME}
  ASSOCF_INIT_BYEXENAME       = $00000002;   //  executable is being passed in
  {$EXTERNALSYM ASSOCF_OPEN_BYEXENAME}
  ASSOCF_OPEN_BYEXENAME       = $00000002;   //  executable is being passed in
  {$EXTERNALSYM ASSOCF_INIT_DEFAULTTOSTAR}
  ASSOCF_INIT_DEFAULTTOSTAR   = $00000004;   //  treat "*" as theBaseClass
  {$EXTERNALSYM ASSOCF_INIT_DEFAULTTOFOLDER}
  ASSOCF_INIT_DEFAULTTOFOLDER = $00000008;   //  treat "Folder" as the BaseClass
  {$EXTERNALSYM ASSOCF_NOUSERSETTINGS}
  ASSOCF_NOUSERSETTINGS       = $00000010;   //  dont use HKCU
  {$EXTERNALSYM ASSOCF_NOTRUNCATE}
  ASSOCF_NOTRUNCATE           = $00000020;   //  dont truncate the return string
  {$EXTERNALSYM ASSOCF_VERIFY}
  ASSOCF_VERIFY               = $00000040;   //  verify data is accurate (DISK HITS)
  {$EXTERNALSYM ASSOCF_REMAPRUNDLL}
  ASSOCF_REMAPRUNDLL          = $00000080;   //  actually gets info about rundlls target if applicable
  {$EXTERNALSYM ASSOCF_NOFIXUPS}
  ASSOCF_NOFIXUPS             = $00000100;  //  attempt to fix errors if found
  {$EXTERNALSYM ASSOCF_IGNOREBASECLASS}
  ASSOCF_IGNOREBASECLASS      = $00000200;  //  dont recurse into the baseclass

  {$EXTERNALSYM ASSOCDATA_MSIDESCRIPTOR}
  ASSOCDATA_MSIDESCRIPTOR = 1;               //  Component Descriptor to pass to MSI
  {$EXTERNALSYM ASSOCDATA_NOACTIVATEHANDLER}
  ASSOCDATA_NOACTIVATEHANDLER = 2;           //  restrict attempts to activate window
  {$EXTERNALSYM ASSOCDATA_QUERYCLASSSTORE}
  ASSOCDATA_QUERYCLASSSTORE = 3;            //  should check with the NT Class Store
  {$EXTERNALSYM ASSOCDATA_HASPERUSERASSOC}
  ASSOCDATA_HASPERUSERASSOC = 4;            //  defaults to user specified association
  {$EXTERNALSYM ASSOCDATA_EDITFLAGS}
  ASSOCDATA_EDITFLAGS = 5;                  //  Edit flags.
  {$EXTERNALSYM ASSOCDATA_VALUE}
  ASSOCDATA_VALUE = 6;                      //  use pszExtra as the Value name
  {$EXTERNALSYM ASSOCDATA_MAX}
  ASSOCDATA_MAX = 6;                        //  last item in enum...

  {$EXTERNALSYM ASSOCKEY_SHELLEXECCLASS}
  ASSOCKEY_SHELLEXECCLASS = 1;     //  the key that should be passed to
  {$EXTERNALSYM ASSOCKEY_APP}
  ASSOCKEY_APP = 2;                //  the "Application" key for the
  {$EXTERNALSYM ASSOCKEY_CLASS}
  ASSOCKEY_CLASS = 3;              //  the progid or class key
  {$EXTERNALSYM ASSOCKEY_BASECLASS}
  ASSOCKEY_BASECLASS = 4;          //  the BaseClass key
  {$EXTERNALSYM ASSOCKEY_MAX}
  ASSOCKEY_MAX = 4;                //  last item in enum...


  {$EXTERNALSYM ASSOCSTR_COMMAND}
  ASSOCSTR_COMMAND = 1;              //  shell\verb\command string
  {$EXTERNALSYM ASSOCSTR_EXECUTABLE}
  ASSOCSTR_EXECUTABLE = 2;           //  the executable part of command string
  {$EXTERNALSYM ASSOCSTR_FRIENDLYDOCNAME}
  ASSOCSTR_FRIENDLYDOCNAME = 3;      //  friendly name of the document type
  {$EXTERNALSYM ASSOCSTR_FRIENDLYAPPNAME}
  ASSOCSTR_FRIENDLYAPPNAME = 4;     //  friendly name of executable
  {$EXTERNALSYM ASSOCSTR_NOOPEN}
  ASSOCSTR_NOOPEN = 5;              //  noopen value
  {$EXTERNALSYM ASSOCSTR_SHELLNEWVALUE}
  ASSOCSTR_SHELLNEWVALUE = 6;       //  query values under the shellnew key
  {$EXTERNALSYM ASSOCSTR_DDECOMMAND}
  ASSOCSTR_DDECOMMAND = 7;          //  template for DDE commands
  {$EXTERNALSYM ASSOCSTR_DDEIFEXEC}
  ASSOCSTR_DDEIFEXEC = 8;           //  DDECOMMAND to use if just create a process
  {$EXTERNALSYM ASSOCSTR_DDEAPPLICATION}
  ASSOCSTR_DDEAPPLICATION = 9;     //  Application name in DDE broadcast
  {$EXTERNALSYM ASSOCSTR_DDETOPIC}
  ASSOCSTR_DDETOPIC = 10;          //  Topic Name in DDE broadcast
  {$EXTERNALSYM ASSOCSTR_INFOTIP}
  ASSOCSTR_INFOTIP = 11;           //  info tip for an item, or list of
  {$EXTERNALSYM ASSOCSTR_QUICKTIP}
  ASSOCSTR_QUICKTIP = 13;          //  same as ASSOCSTR_INFOTIP, except, this
  {$EXTERNALSYM ASSOCSTR_TILEINFO}
  ASSOCSTR_TILEINFO = 14;          //  similar to ASSOCSTR_INFOTIP - lists important properties for tileview
  {$EXTERNALSYM ASSOCSTR_CONTENTTYPE}
  ASSOCSTR_CONTENTTYPE = 15;       //  MIME Content type
  {$EXTERNALSYM ASSOCSTR_DEFAULTICON}
  ASSOCSTR_DEFAULTICON = 16;       //  Default icon source
  {$EXTERNALSYM ASSOCSTR_SHELLEXTENSION}
  ASSOCSTR_SHELLEXTENSION = 17;    //  Guid string pointing to the Shellex\Shellextensionhandler Value.
  {$EXTERNALSYM ASSOCSTR_MAX}
  ASSOCSTR_MAX = 17;               //  last item in enum...


  {$EXTERNALSYM ASSOCSTR_DDETOPIC}
  ASSOCENUM_NONE = 1;

type
  {.$EXTERNALSYM IQueryAssociations}
  IQueryAssociations = interface(IUnknown)
  [SID_IQueryAssociations]
    function Init(flags: DWORD; pwszAssoc: LPCWSTR; hkProgid: HKEY; hwnd: HWND): HRESULT; stdcall;
    function GetString(flags: DWORD; str: DWORD; pwszExtra: LPCWSTR; pwszOut: LPWSTR; var pcchOut: DWORD): HRESULT; stdcall;
    function GetKey(flags: DWORD; key: DWORD; pwszExtra: LPCWSTR; var phkeyOut: HKEY): HRESULT; stdcall;
    function GetData(flags: DWORD; data: DWORD; pwszExtra: LPCWSTR; out pvOut: Pointer;
      var pcbOut: DWORD): HRESULT; stdcall;
    function GetEnum(flags: DWORD; assocenum: DWORD; pszExtra: LPCWSTR; const riid: TGUID; out ppvOut: Pointer): HRESULT; stdcall;
  end;

{$IFNDEF COMPILER_10_UP}
type
  PStartupInfoW = ^TStartupInfoW;
  _STARTUPINFOW = record
    cb: DWORD;
    lpReserved: PWideChar;
    lpDesktop: PWideChar;
    lpTitle: PWideChar;
    dwX: DWORD;
    dwY: DWORD;
    dwXSize: DWORD;
    dwYSize: DWORD;
    dwXCountChars: DWORD;
    dwYCountChars: DWORD;
    dwFillAttribute: DWORD;
    dwFlags: DWORD;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: PByte;
    hStdInput: THandle;
    hStdOutput: THandle;
    hStdError: THandle;
  end;
  {$EXTERNALSYM _STARTUPINFOW}
  TStartupInfoW = _STARTUPINFOW;
  STARTUPINFOW = _STARTUPINFOW;
  {$EXTERNALSYM STARTUPINFOW}
{$ENDIF}

//------------------------------------------------------------------------------
// Assorted definitions
//------------------------------------------------------------------------------
const
  {$EXTERNALSYM CMF_EXTENDEDVERBS}
  CMF_EXTENDEDVERBS    =  $0100;

  // Correct definition
  {$EXTERNALSYM SHGetFileInfoW}
  function SHGetFileInfoW(pszPath: PWideChar; dwFileAttributes: DWORD;
    var psfi: TSHFileInfoW; cbFileInfo, uFlags: UINT): DWORD; stdcall;
      external shell32 name 'SHGetFileInfoW';

  {$EXTERNALSYM CreateProcessW}
  function CreateProcessW(lpApplicationName: PWideChar; lpCommandLine: PWideChar;
    lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
    bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
    lpCurrentDirectory: PWideChar; const lpStartupInfo: TStartupInfoW;
    var lpProcessInformation: TProcessInformation): BOOL; stdcall;
      external kernel32 name 'CreateProcessW';
      
implementation

end.
