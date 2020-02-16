unit VirtualDataObject;

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
  ActiveX, ShlObj, ShellAPI, AxCtrls, VirtualPIDLTools, VirtualShellTypes,
  VirtualWideStrings;

const
  CFSTR_LOGICALPERFORMEDDROPEFFECT = 'Logical Performed DropEffect';
  CFSTR_PREFERREDDROPEFFECT = 'Preferred DropEffect';
  CFSTR_PERFORMEDDROPEFFECT = 'Performed DropEffect';
  CFSTR_PASTESUCCEEDED = 'Paste Succeeded';
  CFSTR_INDRAGLOOP = 'InShellDragLoop';
  CFSTR_SHELLIDLISTOFFSET = 'Shell Object Offsets';

type
  PPerformedDropEffect = ^TPerformedDropEffect;
  TPerformedDropEffect = (
    effectNone,    // No Operation (DROPEFFECT_NONE)
    effectCopy,    // Operation was a copy (DROPEFFECT_COPY)
    effectMove,    // Operation was a move (DROPEFFECT_MOVE)
    effectLink     // Operation was a link (DROPEFFECT_LINK)
  );

type
  TFormatEtcArray = array of TFormatEtc;

  TDataObjectInfo = record
    FormatEtc: TFormatEtc;
    StgMedium: TStgMedium;
    OwnedByDataObject: Boolean
  end;

  TDataObjectInfoArray = array of TDataObjectInfo;

//------------------------------------------------------------------------------
// TEnumFormatEtc :
//       Implements the IEnumFormatEtc interface for the IDataObject
// implementation.  This interface is called by a potential droptarget to see it
// the IDataObject contains data that the target knows how to handle and would
// like a shot at accepting it.
//-------------------------------------------------------------------------------

  TEnumFormatEtc = class(TInterfacedObject, IEnumFormatEtc)
  private
    FInternalIndex: integer;
    FFormats: TFormatEtcArray;
  protected
    { IEnumFormatEtc }
    function Next(celt: Longint; out elt; pceltFetched: PLongint): HResult; stdcall;
    function Skip(celt: Longint): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out Enum: IEnumFormatEtc): HResult; stdcall;

    property InternalIndex: integer read FInternalIndex write FInternalIndex;
  public
    constructor Create;
    destructor Destroy; override;

    property Formats: TFormatEtcArray read FFormats write FFormats;
  end;

//-------------------------------------------------------------------------------}
// TVirtualDataObject :                                                                 }
//       Implements the IDataObject interface.  This interface is called by a    }
// potential droptarget to see it the IDataObject contains data that the target  }
// knows how to handle and would like a shot at accepting it.                    }
//-------------------------------------------------------------------------------}

  IVirtualDataObject = interface(IDataObject)
    ['{E274AC17-CCB4-417C-A866-9D83DD7576C0}']
    function AssignDragImage(Image: TBitmap; HotSpot: TPoint; TransparentColor: TColor): Boolean;
    function SaveGlobalBlock(Format: TClipFormat; MemoryBlock: Pointer; MemoryBlockSize: integer): Boolean;
    function LoadGlobalBlock(Format: TClipFormat; var MemoryBlock: Pointer): Boolean;
  end;

  TGetDataEvent = procedure(Sender: TObject; const FormatEtcIn: TFormatEtc; var Medium: TStgMedium; var Handled: Boolean) of object;
  TQueryGetDataEvent = procedure(Sender: TObject; const FormatEtcIn: TFormatEtc; var FormatAvailable: Boolean; var Handled: Boolean) of object;

  TVirtualDataObject = class(TInterfacedObject, IDataObject, IVirtualDataObject)
  private
    FAdviseHolder: IDataAdviseHolder;
    FOnGetData: TGetDataEvent;
    FOnQueryGetData: TQueryGetDataEvent;  // Reference to an OLE supplied implementation for advising.
  protected
    FFormats: TDataObjectInfoArray;

    function CanonicalIUnknown(TestUnknown: IUnknown): IUnknown;
    function DAdvise(const formatetc: TFormatEtc; advf: Longint; const advSink: IAdviseSink;
      out dwConnection: Longint): HResult; virtual; stdcall;
    function DUnadvise(dwConnection: Longint): HResult; virtual; stdcall;
    function EnumDAdvise(out enumAdvise: IEnumStatData): HResult;virtual; stdcall;
    function EnumFormatEtc(dwDirection: Longint;
      out enumFormatEtc: IEnumFormatEtc): HResult;virtual; stdcall;
    function EqualFormatEtc(FormatEtc1, FormatEtc2: TFormatEtc): Boolean;
    function FindFormatEtc(TestFormatEtc: TFormatEtc): integer;
    function GetCanonicalFormatEtc(const formatetc: TFormatEtc;
      out formatetcOut: TFormatEtc): HResult;virtual; stdcall;
    function GetData(const FormatEtcIn: TFormatEtc; out Medium: TStgMedium): HResult;virtual; stdcall;
    function GetDataHere(const formatetc: TFormatEtc; out medium: TStgMedium): HResult;virtual; stdcall;
    function HGlobalClone(HGlobal: THandle): THandle;
    function QueryGetData(const formatetc: TFormatEtc): HResult;virtual; stdcall;
    function SetData(const formatetc: TFormatEtc; var medium: TStgMedium;
      fRelease: BOOL): HResult;virtual; stdcall;

    procedure DoOnGetData(const FormatEtcIn: TFormatEtc; var Medium: TStgMedium; var Handled: Boolean); virtual;
    procedure DoOnQueryGetData(const FormatEtcIn: TFormatEtc; var FormatAvailable: Boolean;
      var Handled: Boolean); virtual;

    function RetrieveOwnedStgMedium(Format: TFormatEtc; var StgMedium: TStgMedium): HRESULT;
    function StgMediumIncRef(const InStgMedium: TStgMedium; var OutStgMedium: TStgMedium;
       CopyInMedium: Boolean): HRESULT;

    property AdviseHolder: IDataAdviseHolder read FAdviseHolder;
    property Formats: TDataObjectInfoArray read FFormats write FFormats;
  public
    constructor Create;
    destructor Destroy; override;
    function AssignDragImage(Image: TBitmap; HotSpot: TPoint; TransparentColor: TColor): Boolean;
    function GetUserData(Format: TFormatEtc; var StgMedium: TStgMedium): Boolean; virtual;
    function LoadGlobalBlock(Format: TClipFormat; var MemoryBlock: Pointer): Boolean;
    function SaveGlobalBlock(Format: TClipFormat; MemoryBlock: Pointer; MemoryBlockSize: integer): Boolean;

    property OnGetData: TGetDataEvent read FOnGetData write FOnGetData;
    property OnQueryGetData: TQueryGetDataEvent read FOnQueryGetData write FOnQueryGetData;
  end;

type
  TClipboardFormat = class
  protected
    function GetFormatEtc: TFormatEtc; virtual;
  public
    function LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; virtual;
    function LoadFromDataObject(DataObject: IDataObject): Boolean; virtual; abstract;
    function SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; virtual;
    function SaveToDataObject(DataObject: IDataObject): Boolean; virtual; abstract;
  end;


// Simpifies dealing with the CF_HDROP format
  THDrop = class(TClipboardFormat)
  private
    FDropFiles: PDropFiles;
    FStructureSize: integer;
    FFileCount: integer;
    procedure SetDropFiles(const Value: PDropFiles);
    function GetHDropStruct: THandle;
  protected
    procedure AllocStructure(Size: integer);
    function CalculateDropFileStructureSizeA(Value: PDropFiles): integer;
    function CalculateDropFileStructureSizeW(Value: PDropFiles): integer;
    function FileCountA: Integer;
    function FileCountW: Integer;
    function FileNameA(Index: integer): string;
    function FileNameW(Index: integer): WideString;
    procedure FreeStructure; // Frees memory allocated
    function GetFormatEtc: TFormatEtc; override;

    property HDropStruct: THandle read GetHDropStruct;
  public
    procedure AssignFiles(FileList: TStrings; ClearList: Boolean = False);
    procedure AssignFilesW(FileList: TWideStringList; ClearList: Boolean = False);
    function AssignFromClipboard: Boolean;
    destructor Destroy; override;
    function LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; override;
    function LoadFromDataObject(DataObject: IDataObject): Boolean; override;
    function FileCount: integer;
    function FileName(Index: integer): WideString;
    procedure FileNames(FileList: TStrings);
    function SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; override;
    function SaveToDataObject(DataObject: IDataObject): Boolean; override;
    property StructureSize: integer read FStructureSize;
    property DropFiles: PDropFiles read FDropFiles write SetDropFiles;
  end;


// Simpifies dealing with the CFSTR_FILEGROUPDESCRIPTOR format
// Beta - untested and unfinished
type
  TDescriptorAArray = array of TFileDescriptorA;
  TDescriptorWArray = array of TFileDescriptorW;

  TFileGroupDescriptorA = class(TClipboardFormat)
  private
    FStream: TStream;
    function GetDescriptorCount: Integer;
    function GetFileDescriptorA(Index: Integer): TFileDescriptorA;
    procedure SetFileDescriptor(Index: Integer;
      const Value: TFileDescriptorA);
  protected
    FFileDescriptors: TDescriptorAArray;

    function GetFormatEtc: TFormatEtc; override;

    property Stream: TStream read FStream write FStream;
  public
    procedure AddFileDescriptor(FileDescriptor: TFileDescriptorA);
    procedure DeleteFileDescriptor(Index: integer);
    function FillDescriptor(FileName: string): TFileDescriptorA;
    function GetFileStream(const DataObject: IDataObject; FileIndex: Integer): TStream;
    procedure LoadFileGroupDestriptor(FileGroupDiscriptor: PFileGroupDescriptorA);
    function LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; override;
    function LoadFromDataObject(DataObject: IDataObject): Boolean; override;
    function SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; override;
    function SaveToDataObject(DataObject: IDataObject): Boolean; override;

    property DescriptorCount: Integer read GetDescriptorCount;
    property FileDescriptor[Index: Integer]: TFileDescriptorA read GetFileDescriptorA write SetFileDescriptor;
  end;

  TFileGroupDescriptorW = class(TClipboardFormat)
  private
    FStream: TStream;
    function GetDescriptorCount: Integer;
    function GetFileDescriptorW(Index: Integer): TFileDescriptorW;
    procedure SetFileDescriptor(Index: Integer;
      const Value: TFileDescriptorW);
  protected
    FFileDescriptors: TDescriptorWArray;

    function GetFormatEtc: TFormatEtc; override;

    property Stream: TStream read FStream write FStream;
  public
    procedure AddFileDescriptor(FileDescriptor: TFileDescriptorW);
    procedure DeleteFileDescriptor(Index: integer);
    function FillDescriptor(FileName: WideString): TFileDescriptorW;
    function GetFileStream(const DataObject: IDataObject; FileIndex: Integer): TStream;
    procedure LoadFileGroupDestriptor(FileGroupDiscriptor: PFileGroupDescriptorW);
    function LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; override;
    function LoadFromDataObject(DataObject: IDataObject): Boolean; override;
    function SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; override;
    function SaveToDataObject(DataObject: IDataObject): Boolean; override;

    property DescriptorCount: Integer read GetDescriptorCount;
    property FileDescriptor[Index: Integer]: TFileDescriptorW read GetFileDescriptorW write SetFileDescriptor;
  end;


// Simpifies dealing with the CFSTR_SHELLIDLIST format
type
  TShellIDList = class(TClipboardFormat)
  private
    FCIDA: PIDA;
    function GetCIDASize: integer;
    function InternalChildPIDL(Index: integer): PItemIDList;
    function InternalParentPIDL: PItemIDList;
    procedure SetCIDA(const Value: PIDA);
  protected
    function GetFormatEtc: TFormatEtc; override;
  public
    function AbsolutePIDL(Index: integer): PItemIDList;
    procedure AbsolutePIDLs(APIDLList: TPIDLList);
    procedure AssignPIDLs(APIDLList: TPIDLList);
    destructor Destroy; override;
    function LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; override;
    function LoadFromDataObject(DataObject: IDataObject): Boolean; override;
    function ParentPIDL: PItemIDList;
    function PIDLCount: integer;
    function RelativePIDL(Index: integer): PItemIDList;
    procedure RelativePIDLs(APIDLList: TPIDLList);
    function SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean; override;
    function SaveToDataObject(DataObject: IDataObject): Boolean; override;

    property CIDA: PIDA read FCIDA write SetCIDA;
    property CIDASize: integer read GetCIDASize;
  end;

  // Simpilies dealing with the CFSTR_LOGICALPERFORMEDDROPEFFECT format
  TLogicalPerformedDropEffect = class(TClipboardFormat)
  private
    FAction: TPerformedDropEffect;
  protected
    function GetFormatEtc: TFormatEtc; override;
  public
    function LoadFromDataObject(DataObject: IDataObject): Boolean; override;
    function SaveToDataObject(DataObject: IDataObject): Boolean; override;

    property Action: TPerformedDropEffect read FAction write FAction;
  end;

  TPreferredDropEffect = class(TLogicalPerformedDropEffect)
  protected
    function GetFormatEtc: TFormatEtc; override;
  end;

  function FillFormatEtc(cfFormat: Word; ptd: PDVTargetDevice = nil;
    dwAspect: Longint = DVASPECT_CONTENT; lindex: Longint = -1; tymed: Longint = TYMED_HGLOBAL): TFormatEtc;
  function HDropFormat: TFormatEtc;
  function ShellIDListFormat: TFormatEtc;

  {$ifdef COMPILER_4}
  procedure FreeAndNil(var Obj);
  function Supports(const Instance: IUnknown; const Intf: TGUID; out Inst): Boolean;
  {$endif}


var
  CF_SHELLIDLIST,
  CF_LOGICALPERFORMEDDROPEFFECT,
  CF_PREFERREDDROPEFFECT,
  CF_FILECONTENTS,
  CF_FILEDESCRIPTORA,
  CF_FILEDESCRIPTORW: TClipFormat;

implementation

var
  PIDLMgr: TPIDLManager = nil;

function FillFormatEtc(cfFormat: Word; ptd: PDVTargetDevice = nil;
  dwAspect: Longint = DVASPECT_CONTENT; lindex: Longint = -1; tymed: Longint = TYMED_HGLOBAL): TFormatEtc;
begin
  Result.cfFormat := cfFormat;
  Result.ptd := ptd;
  Result.dwAspect := dwAspect;
  Result.lindex := lindex;
  Result.tymed := tymed
end;

function HDropFormat: TFormatEtc;
begin
  Result.cfFormat := CF_HDROP; // This guy is always registered for all applications
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL
end;

function ShellIDListFormat: TFormatEtc;
begin
  Result.cfFormat := CF_SHELLIDLIST;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL;
end;

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

{ TEnumFormatEtc }

function TEnumFormatEtc.Clone(out Enum: IEnumFormatEtc): HResult;
// Creates a exact copy of the current object.
var
  EnumFormatEtc: TEnumFormatEtc;
begin
  Result := S_OK;   // Think positive
  EnumFormatEtc := TEnumFormatEtc.Create;      // Does not increase COM reference
  if Assigned(EnumFormatEtc) then
  begin
    SetLength(EnumFormatEtc.FFormats, Length(Formats));
    // Make copy of Format info
    Move(FFormats[0], EnumFormatEtc.FFormats[0], Length(Formats) * SizeOf(TFormatEtc));
    EnumFormatEtc.InternalIndex := InternalIndex;
    Enum := EnumFormatEtc as IEnumFormatEtc;   // Sets COM reference to 1
  end else
    Result := E_UNEXPECTED
end;

constructor TEnumFormatEtc.Create;
begin
  inherited Create;
  InternalIndex := 0;
end;

destructor TEnumFormatEtc.Destroy;
begin
  inherited;
end;

function TEnumFormatEtc.Next(celt: Integer; out elt; pceltFetched: PLongint): HResult;
// Another EnumXXXX function.  This function returns the number of objects
// requested by the caller in celt.  The return buffer, elt, is a pointer to an}
// array of, in this case, TFormatEtc structures.  The total number of
// structures returned is placed in pceltFetched.  pceltFetched may be nil if
// celt is only asking for one structure at a time.
type
  TeltArray = array[0..255] of TFormatEtc;
var
  i: integer;
begin
  if Assigned(Formats) then
  begin
    i := 0;
    while (i < celt) and (InternalIndex < Length(Formats)) do
    begin
      TeltArray( elt)[i] := Formats[InternalIndex];
      inc(i);
      inc(FInternalIndex);
    end; // while
    if assigned(pceltFetched) then
      pceltFetched^ := i;
    if i = celt then
      Result := S_OK
    else
      Result := S_FALSE
  end else
    Result := E_UNEXPECTED
end;

function TEnumFormatEtc.Reset: HResult;
begin
  InternalIndex := 0;
  Result := S_OK
end;

function TEnumFormatEtc.Skip(celt: Integer): HResult;
// Allows the caller to skip over unwanted TFormatEtc structures.  Simply adds
// celt to the index as long as it does not skip past the last structure in
// the list.
begin
  if Assigned(Formats) then
  begin
    if InternalIndex + celt < Length(Formats) then
    begin
      InternalIndex := InternalIndex + celt;
      Result := S_OK
    end else
      Result := S_FALSE
  end else
    Result := E_UNEXPECTED
end;

{ TVirtualDataObject }

function TVirtualDataObject.AssignDragImage(Image: TBitmap;
  HotSpot: TPoint; TransparentColor: TColor): Boolean;
var
  DragSourceHelper: IDragSourceHelper;
  SHDragImage: TSHDragImage;
begin
  Result := False;
  if Succeeded(CoCreateInstance(CLSID_DragDropHelper, nil, CLSCTX_INPROC_SERVER, IID_IDragSourceHelper, DragSourceHelper)) then
  begin
    FillChar(SHDragImage, SizeOf(SHDragImage), #0);

    SHDragImage.sizeDragImage.cx := Image.Width;
    SHDragImage.sizeDragImage.cy := Image.Height;
    SHDragImage.ptOffset := HotSpot;
    SHDragImage.ColorRef := ColorToRGB(TransparentColor);
    SHDragImage.hbmpDragImage := CopyImage(Image.Handle, IMAGE_BITMAP, Image.Width,
      Image.Height, LR_COPYRETURNORG);
    if SHDragImage.hbmpDragImage <> 0 then
      if Succeeded(DragSourceHelper.InitializeFromBitmap(SHDragImage, Self as IDataObject)) then
        Result := True
      else
        DeleteObject(SHDragImage.hbmpDragImage);
  end
end;

function TVirtualDataObject.CanonicalIUnknown(TestUnknown: IUnknown): IUnknown;
// Uses COM object identity: An explicit call to the IUnknown::QueryInterface
// method, requesting the IUnknown interface, will always return the same
// pointer.
begin
  if Assigned(TestUnknown) then
  begin
    if Supports(TestUnknown, IUnknown, Result) then
      IUnknown(Result)._Release // Don't actually need it just need the pointer value
    else
      Result := TestUnknown
  end else
    Result := TestUnknown
end;

constructor TVirtualDataObject.Create;
begin

end;

function TVirtualDataObject.DAdvise(const formatetc: TFormatEtc; advf: Integer;
  const advSink: IAdviseSink; out dwConnection: Integer): HResult;
begin
  if not Assigned(AdviseHolder) then
    CreateDataAdviseHolder(FAdviseHolder);
  if Assigned(FAdviseHolder) then
    Result := AdviseHolder.Advise(Self as IDataObject, formatetc, advf, advSink, dwConnection)
  else
    Result := OLE_E_ADVISENOTSUPPORTED;
end;

destructor TVirtualDataObject.Destroy;
begin
  inherited;
end;

procedure TVirtualDataObject.DoOnGetData(const FormatEtcIn: TFormatEtc;
  var Medium: TStgMedium; var Handled: Boolean);
begin
  if Assigned(FOnGetData) then
    OnGetData(Self, FormatEtcIn, Medium, Handled);
end;

procedure TVirtualDataObject.DoOnQueryGetData(
  const FormatEtcIn: TFormatEtc; var FormatAvailable: Boolean; var Handled: Boolean);
begin
  if Assigned(FOnQueryGetData) then
    OnQueryGetData(Self, FormatEtcIn, FormatAvailable, Handled);
end;

function TVirtualDataObject.DUnadvise(dwConnection: Integer): HResult;
begin
  if Assigned(AdviseHolder) then
    Result := AdviseHolder.Unadvise(dwConnection)
  else
    Result := OLE_E_ADVISENOTSUPPORTED;
end;

function TVirtualDataObject.EnumDAdvise(out enumAdvise: IEnumStatData): HResult;
begin
  if Assigned(AdviseHolder) then
    Result := AdviseHolder.EnumAdvise(enumAdvise)
  else
    Result := OLE_E_ADVISENOTSUPPORTED;
end;

function TVirtualDataObject.EnumFormatEtc(dwDirection: Integer;
  out enumFormatEtc: IEnumFormatEtc): HResult;
// Called when DoDragDrop wants to know what clipboard formats are supported
// by Enumerating the TFormatEtc array through an IEnumFormatEtc object.
var
  LocalEnumFormatEtc: TEnumFormatEtc;
  i: integer;
begin
  if Assigned(Formats) then
  begin
    Result := S_OK;
    if dwDirection = DATADIR_GET then
    begin
      LocalEnumFormatEtc := TEnumFormatEtc.Create;

      // Copy the supported Formats for the EnumFormatEtc
      SetLength(LocalEnumFormatEtc.FFormats, Length(Formats));
      for i := 0 to Length(Formats) - 1 do
        LocalEnumFormatEtc.Formats[i] := Formats[i].FormatEtc;

      // Get the reference count in sync
      enumFormatEtc := LocalEnumFormatEtc as IEnumFormatEtc;
      if not Assigned(enumFormatEtc) then
        Result := E_OUTOFMEMORY
    end else
    begin
      enumFormatEtc := nil;
      Result := E_NOTIMPL;
    end;
  end else
    Result := E_UNEXPECTED;
end;

function TVirtualDataObject.EqualFormatEtc(FormatEtc1, FormatEtc2: TFormatEtc): Boolean;
begin
  Result := (FormatEtc1.cfFormat = FormatEtc2.cfFormat) and
            (FormatEtc1.ptd = FormatEtc2.ptd) and
            (FormatEtc1.dwAspect = FormatEtc2.dwAspect) and
            (FormatEtc1.lindex = FormatEtc2.lindex) and
            (FormatEtc1.tymed = FormatEtc2.tymed)
end;

function TVirtualDataObject.FindFormatEtc(TestFormatEtc: TFormatEtc): integer;
var
  i: integer;
  Found: Boolean;
begin
  i := 0;
  Found := False;
  Result := -1;
  while (i < Length(FFormats)) and not Found do
  begin
    Found := EqualFormatEtc(Formats[i].FormatEtc, TestFormatEtc);
    if Found then
      Result := i;
    Inc(i);
  end
end;

function TVirtualDataObject.GetCanonicalFormatEtc(const formatetc: TFormatEtc;
  out formatetcOut: TFormatEtc): HResult;
// Since we do not have two TFormatEtcs that return the same type of data we can
// ingore this function.  It is only for TFormatEtc structures that will return
// the exact same data if each is called.  This could happen if the data is
// target dependant and the target can handle both types of data.  This keeps
// the target from asking for redundant information.
begin
  formatetcOut.ptd := nil;
  Result := E_NOTIMPL;
end;

function TVirtualDataObject.GetData(const FormatEtcIn: TFormatEtc;
  out Medium: TStgMedium): HResult;
// This is the workhorse of the functions.  It looks at the clipboard format
// the IDropTarget wants, makes sure we can support it.  If supported then see
// if it is owned by the object or the program will supply the data.
var
  Handled: Boolean;
begin
  Result := E_UNEXPECTED;
  Handled := False;
  DoOnGetData(FormatEtcIn, Medium, Handled);
  if not Handled then
  begin
  if Assigned(Formats) then
    begin
      { Do we support this type of Data? }
      Result := QueryGetData(FormatEtcIn);
      if Result = S_OK then
      begin
        // If the data is owned by the IDataObject just retrieve and return it.
        if RetrieveOwnedStgMedium(FormatEtcIn, Medium) = E_INVALIDARG then
        { This data is defined by the Object Inspector or a custom format need to }
        { Retrive it from the DragSourceManager                                   }
          if not GetUserData(FormatEtcIn, Medium) then
            Result := E_UNEXPECTED
      end
    end
  end else
    Result := S_OK
end;

function TVirtualDataObject.GetDataHere(const formatetc: TFormatEtc;
  out medium: TStgMedium): HResult;
begin
  Result := E_NOTIMPL;
end;

function TVirtualDataObject.GetUserData(Format: TFormatEtc; var StgMedium: TStgMedium): Boolean;
begin
  Result := False;
end;

function TVirtualDataObject.HGlobalClone(HGlobal: THandle): THandle;
// Returns a global memory block that is a copy of the passed memory block.
var
  Size: LongWord;
  Data, NewData: PChar;
begin
  Size := GlobalSize(HGlobal);
  Result := GlobalAlloc(GPTR, Size);
  Data := GlobalLock(hGlobal);
  try
    NewData := GlobalLock(Result);
    try
      Move(Data, NewData, Size);
    finally
      GlobalUnLock(Result);
    end
  finally
    GlobalUnLock(hGlobal)
  end
end;

function TVirtualDataObject.LoadGlobalBlock(Format: TClipFormat;
  var MemoryBlock: Pointer): Boolean;
var
  FormatEtc: TFormatEtc;
  StgMedium: TStgMedium;
  GlobalObject: Pointer;
begin
  Result := False;

  FormatEtc.cfFormat := Format;
  FormatEtc.ptd := nil;
  FormatEtc.dwAspect := DVASPECT_CONTENT;
  FormatEtc.lindex := -1;
  FormatEtc.tymed := TYMED_HGLOBAL;

  if Succeeded(QueryGetData(FormatEtc)) and Succeeded(GetData(FormatEtc, StgMedium)) then
  begin
    MemoryBlock := AllocMem( GlobalSize(StgMedium.hGlobal));
    GlobalObject := GlobalLock(StgMedium.hGlobal);
    try
      if Assigned(MemoryBlock) and Assigned(GlobalObject) then
      begin
        Move(GlobalObject^, MemoryBlock^, GlobalSize(StgMedium.hGlobal));
      end
    finally
      GlobalUnLock(StgMedium.hGlobal);
    end
  end;
end;

function TVirtualDataObject.QueryGetData(const formatetc: TFormatEtc): HResult;
// This function allows the IDragTarget to see if we can possibly support some
// type of data transfer.
var
  i: integer;
  FormatAvailable, Handled: Boolean;
begin
  Handled := False;
  FormatAvailable := False;
  DoOnQueryGetData(FormatEtc, FormatAvailable, Handled);
  if Handled then
  begin
    if FormatAvailable then
      Result := S_OK
    else
      Result := DV_E_FORMATETC
  end else
  begin
    if not FormatAvailable then
    begin
      if Assigned(Formats) then
      begin
        i := 0;
        Result := DV_E_FORMATETC;
        while (i < Length(Formats)) and (Result = DV_E_FORMATETC)  do
        begin
          if Formats[i].FormatEtc.cfFormat = formatetc.cfFormat then
          begin
            if (Formats[i].FormatEtc.dwAspect = formatetc.dwAspect) then
            begin
              if (Formats[i].FormatEtc.tymed and formatetc.tymed <> 0) then
                Result := S_OK
              else
                Result := DV_E_TYMED;
            end else
              Result := DV_E_DVASPECT;
          end else
            Result := DV_E_FORMATETC;
          Inc(i)
        end
      end else
        Result := E_UNEXPECTED;
    end else
      Result := S_OK
  end
end;

function TVirtualDataObject.RetrieveOwnedStgMedium(Format: TFormatEtc; var StgMedium: TStgMedium): HRESULT;
var
  i: integer;
begin
  Result := E_INVALIDARG;
  i := FindFormatEtc(Format);
  if (i > -1) and Formats[i].OwnedByDataObject then
    Result := StgMediumIncRef(Formats[i].StgMedium, StgMedium, False)
end;

function TVirtualDataObject.SaveGlobalBlock(Format: TClipFormat;
  MemoryBlock: Pointer; MemoryBlockSize: integer): Boolean;
var
  FormatEtc: TFormatEtc;
  StgMedium: TStgMedium;
  GlobalObject: Pointer;
begin
  FormatEtc.cfFormat := Format;
  FormatEtc.ptd := nil;
  FormatEtc.dwAspect := DVASPECT_CONTENT;
  FormatEtc.lindex := -1;
  FormatEtc.tymed := TYMED_HGLOBAL;

  StgMedium.tymed := TYMED_HGLOBAL;
  StgMedium.unkForRelease := nil;
  StgMedium.hGlobal := GlobalAlloc(GHND or GMEM_SHARE, MemoryBlockSize);
  GlobalObject := GlobalLock(StgMedium.hGlobal);
  try
    try
      Move(MemoryBlock^, GlobalObject^, MemoryBlockSize);
      Result := Succeeded( SetData(FormatEtc, StgMedium, True))
    except
      Result := False;
    end
  finally
    GlobalUnLock(StgMedium.hGlobal);
  end
end;

function TVirtualDataObject.SetData(const formatetc: TFormatEtc; var medium: TStgMedium; fRelease: BOOL): HResult;
// Allows dynamic adding to the IDataObject during its existance.  Most noteably
// it is used to implement IDropSourceHelper in win2k
var
  Index: integer;
begin
  // See if we already have a format of that type available.
  Index := FindFormatEtc(FormatEtc);
  if Index > - 1 then
  begin
    // Yes we already have that format type stored.  Just use the TClipboardFormat
    // in the List after releasing the data
    ReleaseStgMedium(Formats[Index].StgMedium);
    FillChar(Formats[Index].StgMedium, SizeOf(Formats[Index].StgMedium), #0);
  end else
  begin
    // It is a new format so create a new TDataObjectInfo record and store it in
    // the Format array
    SetLength(FFormats, Length(Formats) + 1);
    Formats[Length(Formats) - 1].FormatEtc := FormatEtc;
    Index := Length(Formats) - 1;
  end;
  // The data is owned by the TClipboardFormat object
  Formats[Index].OwnedByDataObject := True;

  if fRelease then
  begin
    // We are simply being given the data and we take control of it.
    Formats[Index].StgMedium := Medium;
    Result := S_OK
  end else
    // We need to reference count or copy the data and keep our own references
    // to it.
    Result := StgMediumIncRef(Medium, Formats[Index].StgMedium, True);

    // Can get a circular reference if the client calls GetData then calls
    // SetData with the same StgMedium.  Because the unkForRelease and for
    // the IDataObject can be marshalled it is necessary to get pointers that
    // can be correctly compared.
    // See the IDragSourceHelper article by Raymond Chen at MSDN.
    if Assigned(Formats[Index].StgMedium.unkForRelease) then
    begin
      if CanonicalIUnknown(Self) =
        CanonicalIUnknown(IUnknown( Formats[Index].StgMedium.unkForRelease)) then
      begin
        IUnknown( Formats[Index].StgMedium.unkForRelease)._Release;
        Formats[Index].StgMedium.unkForRelease := nil
      end;
    end;
  // Tell all registered advice sinks about the data change.
  if Assigned(AdviseHolder) then
    AdviseHolder.SendOnDataChange(Self as IDataObject, 0, 0);
end;

function TVirtualDataObject.StgMediumIncRef(const InStgMedium: TStgMedium;
  var OutStgMedium: TStgMedium; CopyInMedium: Boolean): HRESULT;
// This function increases the reference count of the passed StorageMedium in a
// variety of ways depending on the value of CopyInMedium.
// InStgMedium is the data that is requested a copy of, OutStgMedium is the data that
// we are to return either a copy of or increase the IDataObject's reference and
// send ourselves back as the data (unkForRelease). The InStgMedium is usually
// the result of a call to find a particular FormatEtc that has been stored
// locally through a call to SetData.     If CopyInMedium is not true we
// already have a local copy of the data when the SetData function was called
// (during that call the CopyInMedium must be true).  Then as the caller asks
// for the data through GetData we do not have to make copy of the data for the
// caller only to have them destroy it then need us to copy it again if
// necessary.  This way we increase the reference count to ourselves and pass
// the STGMEDIUM structure initially stored in SetData.  This way when the
// caller frees the structure it sees the unkForRelease is not nil and calls
// Release on the object instead of destroying the actual data.
begin
  Result := S_OK;
  // Simply copy all fields to start with.
  OutStgMedium := InStgMedium;
  case InStgMedium.tymed of
    TYMED_HGLOBAL:
      begin
        if CopyInMedium then
        begin
          // Generate a unique copy of the data passed
          OutStgMedium.hGlobal := HGlobalClone(InStgMedium.hGlobal);
          if OutStgMedium.hGlobal = 0 then
            Result := E_OUTOFMEMORY
        end else
          // Don't generate a copy just use ourselves and the copy previoiusly saved
          OutStgMedium.unkForRelease := Pointer(Self as IDataObject) // Does increase RefCount
      end;
    TYMED_FILE:
      begin
        if CopyInMedium then
        begin
          OutStgMedium.lpszFileName := CoTaskMemAlloc(lstrLenW(InStgMedium.lpszFileName));
          StrCopyW(PWideChar(OutStgMedium.lpszFileName), PWideChar(InStgMedium.lpszFileName))
        end else
          OutStgMedium.unkForRelease := Pointer(Self as IDataObject) // Does increase RefCount
      end;
    TYMED_ISTREAM:
      // Simply increase the reference so the stream object
      // Note here stm is a pointer to the auto reference counting won't work and
      // we have to call _AddRef explicitly
      IUnknown( OutStgMedium.stm)._AddRef;
    TYMED_ISTORAGE:
      // Simply increase the reference so the storage object
      // Note here stm is a pointer to the auto reference counting won't work and
      // we have to call _AddRef explicitly
      IUnknown( OutStgMedium.stg)._AddRef;
    TYMED_GDI:
      if not CopyInMedium then
      // Don't generate a copy just use ourselves and the copy previoiusly saved data
        OutStgMedium.unkForRelease := Pointer(Self as IDataObject) // Does not increase RefCount
     else
       Result := DV_E_TYMED; // Don't know how to copy GDI objects right now
    TYMED_MFPICT:
      if not CopyInMedium then
        OutStgMedium.unkForRelease := Pointer(Self as IDataObject) // Does not increase RefCount
      else
        Result := DV_E_TYMED; // Don't know how to copy MetaFile objects right now
    TYMED_ENHMF:
      if not CopyInMedium then
        { Don't generate a copy just use ourselves and the copy previoiusly saved data }
        OutStgMedium.unkForRelease := Pointer(Self as IDataObject) // Does not increase RefCount
      else
        Result := DV_E_TYMED; // Don't know how to copy enhanced metafiles objects right now
  else
    Result := DV_E_TYMED
  end;

  // I still have to do this. The Compiler will call _Release on the above Self as IDataObject
  // casts which is not what is necessary.  The DataObject is released correctly.
  if Assigned(OutStgMedium.unkForRelease) and (Result = S_OK) then
    IUnknown(OutStgMedium.unkForRelease)._AddRef
end;


{ TShellIDList }

function TShellIDList.AbsolutePIDL(Index: integer): PItemIDList;
{ Appends the single ItemID with the Parent folder to create an Absolute PIDL }
begin
  if Assigned(FCIDA) then
  begin
    Result := PIDLMgr.AppendPIDL(InternalParentPIDL, InternalChildPIDL(Index));
  end else
    Result := nil
end;

procedure TShellIDList.AbsolutePIDLs(APIDLList: TPIDLList);
var
  i: integer;
begin
  if Assigned(APIDLList) and Assigned(FCIDA) then
  begin
    for i := 0 to PIDLCount - 1 do
      APIDLList.Add( PIDLMgr.AppendPIDL(InternalParentPIDL, InternalChildPIDL(i)))
  end;
end;

procedure TShellIDList.AssignPIDLs(APIDLList: TPIDLList);
{ PIDLs[0] must be the Absolute Parent PIDL and the rest single ItemID children }
var
  Count: Integer;
  i: Integer;
  Head: Pointer;
  PIDLLength: Integer;
begin
  Count := 0;
  if Assigned(APIDLList) then
  begin
    { Free previously assigned CIDA }
    if Assigned(FCIDA) then
      FreeMem(FCIDA, CIDASize);
    FCIDA := nil;
    Inc(Count, SizeOf(FCIDA.cidl));
    Inc(Count, SizeOf(FCIDA.aoffset) * (APIDLList.Count));
    for i := 0 to APIDLList.Count - 1 do
      Inc(Count, PIDLMgr.PIDLSize( APIDLList[i]));
    GetMem(FCIDA, Count);
    Head := FCIDA;
    { Head points to the position of the first PIDL }
    Inc(PChar(Head),  SizeOf(FCIDA.cidl) + (SizeOf(FCIDA.aoffset) * APIDLList.Count));
    { Don't count the absolute parent PIDL }
    FCIDA.cidl := APIDLList.Count - 1;
    for i := 0 to APIDLList.Count - 1 do
    begin
      { Set up the array index to point to the actual PIDL data }
      FCIDA.aoffset[i] := LongWord(Head-PChar( CIDA));
      PIDLLength := PIDLMgr.PIDLSize(APIDLList[i]);
      Move(APIDLList[i]^, Head^, PIDLLength);
      Inc(PChar(Head), PIDLLength);
    end;
  end;
end;

destructor TShellIDList.Destroy;
begin
  { Free previously assigned CIDA }
  if Assigned(FCIDA) then
    FreeMem(FCIDA, CIDASize);
  inherited;
end;

function TShellIDList.GetCIDASize: integer;
var
  Count: integer;
  i: integer;
begin
  Count := 0;
  if Assigned(FCIDA) then
  begin
    Inc(Count, SizeOf( FCIDA.cidl));
    Inc(Count, SizeOf( FCIDA.aoffset) * (PIDLCount + 1)); // Does't count [0]
    Inc(Count, PIDLMgr.PIDLSize(InternalParentPIDL));
    for i := 0 to PIDLCount - 1 do
      Inc(Count, PIDLMgr.PIDLSize(InternalChildPIDL(i)));
  end;
  Result := Count;
end;

function TShellIDList.GetFormatEtc: TFormatEtc;
begin
  Result := ShellIDListFormat
end;

function TShellIDList.InternalChildPIDL(Index: integer): PItemIDList;
{ Remember PIDLCount does not count index [0] where the Absolute Parent is     }
begin
  if Assigned(FCIDA) and (Index > -1) and (Index < PIDLCount) then
    Result := PItemIDList( PChar(FCIDA) + PDWORD(PChar(@FCIDA^.aoffset)+sizeof(FCIDA^.aoffset[0])*(1+Index))^)
  else
    Result := nil
end;

function TShellIDList.InternalParentPIDL: PItemIDList;
{ Remember PIDLCount does not count index [0] where the Absolute Parent is     }
begin
  if Assigned(FCIDA) then
      Result :=  PItemIDList( PChar(FCIDA) + FCIDA^.aoffset[0])
  else
    Result := nil
end;

function TShellIDList.LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
var
  Handle: THandle;
  Ptr: PIDA;
begin
  Result := True;
  Handle := 0;
  if not ClipboardAlreadyOpen then
    Result := OpenClipboard(Application.Handle);
  if Result then
  begin
    try
      try
        Handle := GetClipboardData(CF_SHELLIDLIST);
        if Handle <> 0 then
        begin
          Ptr := GlobalLock(Handle);
          if Assigned(Ptr) then
          begin
            CIDA := Ptr;
            Result := True;
          end;
        end;
      except
        Result := False;
        raise;
      end;
    finally
      if not ClipboardAlreadyOpen then
        CloseClipboard;
      GlobalUnLock(Handle);
    end;
  end
end;

function TShellIDList.LoadFromDataObject(DataObject: IDataObject): Boolean;
var
  Ptr: PIDA;
  StgMedium: TStgMedium;
begin
  Result := False;
  if Assigned(DataObject) then
  begin
    FillChar(StgMedium, SizeOf(StgMedium), #0);
    if Succeeded(DataObject.GetData(GetFormatEtc, StgMedium)) then
    try
      Ptr := GlobalLock(StgMedium.hGlobal);
      try
        if Assigned(Ptr) then
        begin
          CIDA := Ptr;
          Result := True;
        end;
      finally
        GlobalUnLock(StgMedium.hGlobal);
      end;
    finally
      ReleaseStgMedium(StgMedium)
    end
  end
end;

function TShellIDList.ParentPIDL: PItemIDList;
begin
  Result := PIDLMgr.CopyPIDL( InternalParentPIDL)
end;

function TShellIDList.PIDLCount: integer;
{ indexing is a bit weird.  Index 0 is the Absolute Parent PIDL but it is not }
{ counted in the first byte of the structure.                                 }
begin
  if Assigned(FCIDA) then
    Result := FCIDA^.cidl
  else
    Result := 0
end;

function TShellIDList.RelativePIDL(Index: integer): PItemIDList;
{ Retrieves the single ItemID child by index                                    }
begin
  Result := PIDLMgr.CopyPIDL( InternalChildPIDL(Index))
end;

procedure TShellIDList.RelativePIDLs(APIDLList: TPIDLList);
{ Loads APIDLList with PIDL's stored in the CIDA. ReturnCopy flags if the       }
{ contents will be the origionals or copies created by the PIDLMgr.             }
var
  i: integer;
begin
  if Assigned(APIDLList) and Assigned(FCIDA) then
  begin
    APIDLList.CopyAdd( InternalParentPIDL);
    for i := 0 to PIDLCount - 1 do
      APIDLList.CopyAdd( InternalChildPIDL(i))
  end;
end;

function TShellIDList.SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
begin
  // NOt implemented yet
  Result := False;
end;

function TShellIDList.SaveToDataObject(DataObject: IDataObject): Boolean;
var
  StgMedium: TStgMedium;
  Ptr: PIDA;
begin
  FillChar(StgMedium, SizeOf(StgMedium), #0);

  StgMedium.hGlobal := GlobalAlloc(GPTR, GetCIDASize);
  Ptr := GlobalLock(StgMedium.hGlobal);
  try
    StgMedium.tymed := TYMED_HGLOBAL;
    CopyMemory(Ptr, CIDA, GetCIDASize);
    Result := Succeeded(DataObject.SetData(GetFormatEtc, StgMedium, True))
  finally
    GlobalUnLock(StgMedium.hGlobal);
  end;
end;

procedure TShellIDList.SetCIDA(const Value: PIDA);
var
  TempSize: integer;
begin
  { Free previously assigned CIDA }
  if Assigned(FCIDA) then
  begin
    FreeMem(FCIDA, CIDASize);
    FCIDA := nil;
  end;
  if Value <> nil then
  begin
    { Temporally assign the passed PIDA to the object }
    FCIDA := Value;
    { Get the size of the passed PIDA }
    TempSize := CIDASize;
    { Get memory to make a copy of the passed PIDA }
    GetMem(FCIDA, TempSize);
    { Copy the passed PIDA }
    Move(Value^, FCIDA^, TempSize);
  end;
end;

{ TClipboardFormat }

function TClipboardFormat.GetFormatEtc: TFormatEtc;
begin
  FillChar(Result, SizeOf(Result), #0);
end;

function TClipboardFormat.LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
begin
  Result := False;
end;

function TClipboardFormat.SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
begin
  Result := False;
end;

{ TLogicalPerformedDropEffect }

function TLogicalPerformedDropEffect.GetFormatEtc: TFormatEtc;
begin
  Result.cfFormat := CF_LOGICALPERFORMEDDROPEFFECT;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL
end;

function TLogicalPerformedDropEffect.LoadFromDataObject(DataObject: IDataObject): Boolean;
var
  Ptr: PPerformedDropEffect;
  StgMedium: TStgMedium;
begin
  Result := False;
  FillChar(StgMedium, SizeOf(StgMedium), #0);

  if Succeeded(DataObject.GetData(GetFormatEtc, StgMedium)) then
  try
    Ptr := GlobalLock(StgMedium.hGlobal);
    try
      if Assigned(Ptr) then
      begin
        FAction := Ptr^;
        Result := True;
      end;
    finally
      GlobalUnLock(StgMedium.hGlobal);
    end
  finally
    ReleaseStgMedium(StgMedium)
  end
end;

function TLogicalPerformedDropEffect.SaveToDataObject(DataObject: IDataObject): Boolean;
var
  Ptr: PPerformedDropEffect;
  StgMedium: TStgMedium;
begin
  FillChar(StgMedium, SizeOf(StgMedium), #0);

  StgMedium.hGlobal := GlobalAlloc(GPTR, SizeOf(FAction));
  Ptr := GlobalLock(StgMedium.hGlobal);
  try
    Ptr^ := FAction;
    StgMedium.tymed := TYMED_HGLOBAL;
    Result := Succeeded(DataObject.SetData(GetFormatEtc, StgMedium, True))
  finally
    GlobalUnLock(StgMedium.hGlobal);
  end
end;

{ THDrop }

procedure THDrop.AllocStructure(Size: integer);
begin
  FreeStructure;
  GetMem(FDropFiles, Size);
  FStructureSize := Size;
  FillChar(FDropFiles^, Size, #0);
end;

procedure THDrop.AssignFiles(FileList: TStrings; ClearList: Boolean = False);
var
  i: Integer;
  Size: integer;
  Path: PChar;
begin
  if Assigned(FileList) then
  begin
    if ClearList then
      FileList.Clear;
    FreeStructure;
    Size := 0;
    for i := 0 to FileList.Count - 1 do
      Inc(Size, Length(FileList[i]) + + SizeOf(Byte)); // add spot for the null
    Inc(Size, SizeOf(TDropFiles));
    Inc(Size, SizeOf(Byte)); // room for the terminating null
    AllocStructure(Size);
    DropFiles.pFiles := SizeOf(TDropFiles);
    DropFiles.pt.x := 0;
    DropFiles.pt.y := 0;
    DropFiles.fNC := False;
    DropFiles.fWide := False;  // Don't support wide char let NT convert it
    Path := PChar(FDropFiles) + FDropFiles.pFiles;
    for i := 0 to FileList.Count - 1 do
    begin
      MoveMemory(Path, Pointer(FileList[i]), Length(FileList[i]));
      Inc(Path, Length(FileList[i]) + 1); // skip over the single null #0
    end
  end
end;

function THDrop.AssignFromClipboard: Boolean;
var
  Handle: THandle;
  Ptr: PDropFiles;
begin
  Result := False;
  Handle := 0;
  OpenClipboard(Application.Handle);
  try
    Handle := GetClipboardData(CF_HDROP);
    if Handle <> 0 then
    begin
      Ptr := GlobalLock(Handle);
      if Assigned(Ptr) then
      begin
        DropFiles := Ptr;
        Result := True;
      end;
    end;
  finally
    CloseClipboard;
    GlobalUnLock(Handle);
  end;
end;

function THDrop.CalculateDropFileStructureSizeA(
  Value: PDropFiles): integer;
var
  Head: PChar;
  Len: integer;
begin
  if Assigned(Value) then
  begin
    Result := Value^.pFiles;
    Head := PChar( Value) + Value^.pFiles;
    Len := lstrlen(Head);
    while Len > 0 do
    begin
      Result := Result + Len + 1;
      Head := Head + Len + 1;
       Len := lstrlen(Head);
    end;
    Inc(Result, 1); // Add second null
  end else
    Result := 0
end;

function THDrop.CalculateDropFileStructureSizeW(
  Value: PDropFiles): integer;
var
  Head: PChar;
  Len: integer;
begin
  if Assigned(Value) then
  begin
    Result := Value^.pFiles;
    Head := PChar( Value) + Value^.pFiles;
    Len := 2 * (lstrlenW(PWideChar( Head)));
    while Len > 0 do
    begin
      Result := Result + Len + 2;
      Head := Head + Len + 2;
       Len := 2 * (lstrlenW(PWideChar( Head)));
    end;
    Inc(Result, 2); // Add second null
  end else
    Result := 0
end;

destructor THDrop.Destroy;
begin
  FreeStructure;
  inherited;
end;

function THDrop.FileCount: integer;
begin
  if Assigned(DropFiles) then
  begin
    if FFileCount = 0 then
    begin
      if DropFiles.fWide then
        Result := FileCountW
      else
        Result := FileCountA;
       FFileCount := Result;
    end;
  end else
   FFileCount := 0;
  Result := FFileCount
end;

function THDrop.FileCountA: Integer;
var
  Head: PChar;
  Len: integer;
begin
  Result := 0;
  if Assigned(DropFiles) then
  begin
    Head := PChar( DropFiles) + DropFiles^.pFiles;
    Len := lstrlen(Head);
    while Len > 0 do
    begin
      Head := Head + Len + 1;
      Inc(Result);
      Len := lstrlen(Head);
    end
  end
end;

function THDrop.FileCountW: Integer;
var
  Head: PChar;
  Len: integer;
begin
  Result := 0;
  if Assigned(DropFiles) then
  begin
    Head := PChar( DropFiles) + DropFiles^.pFiles;
    Len := 2 * (lstrlenW(PWideChar( Head)));
    while Len > 0 do
    begin
      Head := Head + Len + 2;
      Inc(Result);
      Len := 2 * (lstrlenW(PWideChar( Head)));
    end
  end;
end;

function THDrop.FileName(Index: integer): WideString;
begin
  if Assigned(DropFiles) then
  begin
    if DropFiles.fWide then
      Result := FileNameW(Index)
    else
      Result := FileNameA(Index)
  end
end;

function THDrop.FileNameA(Index: integer): string;
var
  Head: PChar;
  PathNameCount: integer;
  Done: Boolean;
  Len: integer;
begin
  PathNameCount := 0;
  Done := False;
  if Assigned(DropFiles) then
  begin
    Head := PChar( DropFiles) + DropFiles^.pFiles;
    Len := lstrlen(Head);
    while (not Done) and (PathNameCount < FileCount) do
    begin
      if PathNameCount = Index then
      begin
        SetLength(Result, Len + 1);
        CopyMemory(@Result[1], Head, Len + 1); // Include the NULL
        Done := True;
      end;
      Head := Head + Len + 1;
      Inc(PathNameCount);
      Len := lstrlen(Head);
    end
  end
end;

procedure THDrop.AssignFilesW(FileList: TWideStringList; ClearList: Boolean = False);
var
  i: Integer;
  Size: integer;
  Path: PChar;
begin
  if Assigned(FileList) then
  begin
    if ClearList then
      FileList.Clear;
    FreeStructure;
    Size := 0;
    for i := 0 to FileList.Count - 1 do
      Inc(Size, (Length(FileList[i]) + SizeOf(Byte))*2); // add spot for the null
    Inc(Size, SizeOf(TDropFiles));
    Inc(Size, SizeOf(Byte)*2); // room for the terminating null
    AllocStructure(Size);
    DropFiles.pFiles := SizeOf(TDropFiles);
    DropFiles.pt.x := 0;
    DropFiles.pt.y := 0;
    DropFiles.fNC := False;
    DropFiles.fWide := True;
    Path := PChar(FDropFiles) + FDropFiles.pFiles;
    for i := 0 to FileList.Count - 1 do
    begin
      MoveMemory(Path, Pointer(FileList[i]), Length(FileList[i])*2);
      Inc(Path, (Length(FileList[i]) + 1)*2); // skip over the single null #0
    end
  end
end;

procedure THDrop.FileNames(FileList: TStrings);
var
  i: integer;
begin
  if Assigned(FileList) then
  begin
    for i := 0 to FileCount - 1 do
      FileList.Add(FileName(i));
  end;
end;

function THDrop.FileNameW(Index: integer): WideString;
var
  Head: PChar;
  PathNameCount: integer;
  Done: Boolean;
  Len: integer;
begin
  PathNameCount := 0;
  Done := False;
  if Assigned(DropFiles) then
  begin
    Head := PChar( DropFiles) + DropFiles^.pFiles;
    Len := 2 * (lstrlenW(PWideChar( Head)));
    while (not Done) and (PathNameCount < FileCount) do
    begin
      if PathNameCount = Index then
      begin
        SetLength(Result, (Len + 1) div 2);
        CopyMemory(@Result[1], Head, Len + 2); // Include the NULL
        Done := True;
      end;
      Head := Head + Len + 2;
      Inc(PathNameCount);
      Len := 2 * (lstrlenW(PWideChar( Head)));
    end
  end
end;

procedure THDrop.FreeStructure;
begin
  FFileCount := 0;
  if Assigned(FDropFiles) then
    FreeMem(FDropFiles, FStructureSize);
  FDropFiles := nil;
  FStructureSize := 0;
end;

function THDrop.GetFormatEtc: TFormatEtc;
begin
  Result := HDropFormat
end;

function THDrop.GetHDropStruct: THandle;
var
  Files: PDropFiles;
begin
  Result := GlobalAlloc(GHND, StructureSize);
  Files := GlobalLock(Result);
  try
    MoveMemory(Files, FDropFiles, StructureSize);
  finally
    GlobalUnlock(Result)
  end;
end;

function THDrop.LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;

    function PlaceOnClipboard: Boolean;
    var
      Handle: THandle;
      Ptr: PDropFiles;
    begin
      Result := False;
      Handle := GetClipboardData(CF_HDROP);
      if Handle <> 0 then
      begin
        Ptr := GlobalLock(Handle);
        try
          DropFiles := Ptr;
          Result := True;
        finally
          GlobalUnLock(Handle);
        end;
      end      
    end;

begin
  Result := False;
  if ClipboardAlreadyOpen then
    Result := PlaceOnClipboard
  else begin
    if OpenClipboard(Application.Handle) then
    begin
      try
        Result := PlaceOnClipboard
      finally
        CloseClipboard;
      end
    end
  end
end;

function THDrop.LoadFromDataObject(DataObject: IDataObject): Boolean;
var
  Medium: TStgMedium;
  Files: PDropFiles;
begin
  Result := False;
  if Assigned(DataObject) then
  begin
    if Succeeded(DataObject.GetData(GetFormatEtc, Medium)) then
    try
      Files := GlobalLock(Medium.hGlobal);
      try
        DropFiles := Files
      finally
        GlobalUnlock(Medium.hGlobal)
      end
    finally
      ReleaseStgMedium(Medium)
    end;
    Result := Assigned(DropFiles)
  end
end;

function THDrop.SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
begin
  Result := False;
  if ClipboardAlreadyOpen then
  begin
    Result := SetClipboardData(CF_HDROP, HDropStruct) <> 0
  end else
  begin
    if OpenClipboard(Application.Handle) then
    begin
      try
        Result := SetClipboardData(CF_HDROP, HDropStruct) <> 0
      finally
        CloseClipboard;
      end
    end
  end
end;

function THDrop.SaveToDataObject(DataObject: IDataObject): Boolean;
var
  Medium: TStgMedium;
begin
  Result := False;
  FillChar(Medium, SizeOf(Medium), #0);
  Medium.tymed := TYMED_HGLOBAL;
  Medium.hGlobal := HDropStruct;
  // Give the block to the DataObject
  if Succeeded(DataObject.SetData(GetFormatEtc, Medium, True)) then
    Result := True
  else
    GlobalFree(Medium.hGlobal)
end;

procedure THDrop.SetDropFiles(const Value: PDropFiles);
begin
  FreeStructure;
  if Assigned(Value) then
  begin
    if Value.fWide then
      FStructureSize := CalculateDropFileStructureSizeW(Value)
    else
      FStructureSize := CalculateDropFileStructureSizeA(Value);
    AllocStructure(StructureSize);
    CopyMemory(FDropFiles, Value, StructureSize);
  end;
end;

{ TPreferredDropEffect }

function TPreferredDropEffect.GetFormatEtc: TFormatEtc;
begin
  Result.cfFormat := CF_PREFERREDDROPEFFECT;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL
end;

{ TFileGroupDescriptorA }

procedure TFileGroupDescriptorA.AddFileDescriptor(
  FileDescriptor: TFileDescriptorA);
begin
  SetLength(FFileDescriptors, Length(FFileDescriptors) + 1);
  FFileDescriptors[Length(FFileDescriptors) - 1] := FileDescriptor;
end;

procedure TFileGroupDescriptorA.DeleteFileDescriptor(Index: integer);
var
  i: Integer;
begin
  for i := Index to Length(FFileDescriptors) - 1 do
    FileDescriptor[i] := FileDescriptor[i+1];
  SetLength(FFileDescriptors, Length(FFileDescriptors) - 1);
end;

function TFileGroupDescriptorA.FillDescriptor(FileName: string): TFileDescriptorA;
begin
  FillChar(Result, SizeOf(Result), #0);
  StrCopy(Result.cFileName, PChar(FileName));
end;

function TFileGroupDescriptorA.GetDescriptorCount: Integer;
begin
  Result := Length(FFileDescriptors)
end;

function TFileGroupDescriptorA.GetFileDescriptorA(Index: Integer): TFileDescriptorA;
begin
  FillChar(Result, SizeOf(Result), #0);
  if (Index > -1) and (Index < Length(FFileDescriptors)) then
    Result := FFileDescriptors[Index]
end;

function TFileGroupDescriptorA.GetFileStream(const DataObject: IDataObject;
  FileIndex: Integer): TStream;
var
  Format: TFormatEtc;
  Medium: TStgMedium;
begin
  if Assigned(Stream) then
    FreeAndNil(FStream);

  if Assigned(DataObject) and (FileIndex > 0) and (FileIndex < DescriptorCount) then
  begin
    Format.cfFormat := CF_FILECONTENTS;
    Format.ptd := nil;
    Format.dwAspect := DVASPECT_CONTENT;
    Format.lindex := FileIndex;
    Format.tymed := TYMED_ISTREAM;
    if Succeeded(DataObject.GetData(Format, Medium)) then
    begin
      Stream := TOLEStream.Create(IStream(Medium.stm));
      ReleaseStgMedium(Medium);
    end
  end;
  Result := Stream;
end;

function TFileGroupDescriptorA.GetFormatEtc: TFormatEtc;
begin
  Result.cfFormat := CF_FILEDESCRIPTORA;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL
end;

procedure TFileGroupDescriptorA.LoadFileGroupDestriptor(FileGroupDiscriptor: PFileGroupDescriptorA);
var
  i: Cardinal;
begin
  if Assigned(FileGroupDiscriptor) then
  begin
    SetLength(FFileDescriptors, FileGroupDiscriptor.cItems);
    for i := 0 to FileGroupDiscriptor.cItems - 1 do
    begin
      FFileDescriptors[i] := FileGroupDiscriptor.fgd[i]
    end
  end else
    FFileDescriptors := nil;
end;

function TFileGroupDescriptorA.LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
var
  DataObject: IDataObject;
begin
  Result := False;
  if Succeeded(OleGetClipboard(DataObject)) then
    Result := LoadFromDataObject(DataObject);
end;

function TFileGroupDescriptorA.LoadFromDataObject(DataObject: IDataObject): Boolean;
var
  GroupDescriptor: PFileGroupDescriptorA;
  Medium: TStgMedium;
  i: Integer;
begin
  Result := False;
  if Succeeded(DataObject.GetData(GetFormatEtc, Medium)) then
  begin
    GroupDescriptor := GlobalLock(Medium.hGlobal);
    try
      for i := 0 to GroupDescriptor^.cItems - 1 do
        AddFileDescriptor(GroupDescriptor^.fgd[i])
    finally
      GlobalUnlock(Medium.hGlobal);
      ReleaseStgMedium(Medium);
      Result := True
    end
  end
end;

function TFileGroupDescriptorA.SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
var
  DataObject: IDataObject;
begin
  Result := False;
  DataObject := TVirtualDataObject.Create;
  if SaveToDataObject(DataObject) then
    Result := Succeeded(OleSetClipboard(DataObject))
end;

function TFileGroupDescriptorA.SaveToDataObject(DataObject: IDataObject): Boolean;
var
  Mem: THandle;
  GroupDescriptor: PFileGroupDescriptorA;
  Medium: TStgMedium;
  Format: TFormatEtc;
begin
  Result := False;
  if Assigned(DataObject) and (DescriptorCount > 0) then
  begin
    Mem := GlobalAlloc(GHND, DescriptorCount * SizeOf(TFileDescriptorA) + SizeOf(GroupDescriptor.cItems));
    GroupDescriptor := GlobalLock(Mem);
    try
      GroupDescriptor.cItems := DescriptorCount;
      CopyMemory(@GroupDescriptor^.fgd[0], @FFileDescriptors[0], DescriptorCount * SizeOf(TFileDescriptorA));
    finally
      GlobalUnlock(Mem)
    end;
    FillChar(Medium, SizeOf(Medium), #0);
    Medium.tymed := TYMED_HGLOBAL;
    Medium.hGlobal := Mem;

    DataObject.SetData(GetFormatEtc, Medium, True);

    Medium.tymed := TYMED_ISTREAM;
    Medium.stm := nil;

    Format.cfFormat := CF_FILECONTENTS;
    Format.ptd := nil;
    Format.dwAspect := DVASPECT_CONTENT;
    Format.lindex := -1;
    Format.tymed := TYMED_ISTREAM;
    DataObject.SetData(Format, Medium, True);
  end
end;

procedure TFileGroupDescriptorA.SetFileDescriptor(Index: Integer; const Value: TFileDescriptorA);
begin
  if (Index > -1) and (Index < Length(FFileDescriptors)) then
    FFileDescriptors[Index] := Value
end;

{ TFileGroupDescriptorW }

procedure TFileGroupDescriptorW.AddFileDescriptor(
  FileDescriptor: TFileDescriptorW);
begin
  SetLength(FFileDescriptors, Length(FFileDescriptors) + 1);
  FFileDescriptors[Length(FFileDescriptors) - 1] := FileDescriptor;
end;

procedure TFileGroupDescriptorW.DeleteFileDescriptor(Index: integer);
var
  i: Integer;
begin
  for i := Index to Length(FFileDescriptors) - 1 do
    FileDescriptor[i] := FileDescriptor[i+1];
  SetLength(FFileDescriptors, Length(FFileDescriptors) - 1);
end;

function TFileGroupDescriptorW.FillDescriptor(FileName: WideString): TFileDescriptorW;
begin
  FillChar(Result, SizeOf(Result), #0);
  StrCopyW(Result.cFileName, PWideChar(FileName));
end;

function TFileGroupDescriptorW.GetDescriptorCount: Integer;
begin
  Result := Length(FFileDescriptors)
end;

function TFileGroupDescriptorW.GetFileDescriptorW(Index: Integer): TFileDescriptorW;
begin
  FillChar(Result, SizeOf(Result), #0);
  if (Index > -1) and (Index < Length(FFileDescriptors)) then
    Result := FFileDescriptors[Index]
end;

function TFileGroupDescriptorW.GetFileStream(const DataObject: IDataObject; FileIndex: Integer): TStream;
var
  Format: TFormatEtc;
  Medium: TStgMedium;
begin
  if Assigned(Stream) then
    FreeAndNil(FStream);

  if Assigned(DataObject) and (FileIndex > -1) and (FileIndex < DescriptorCount) then
  begin
    Format.cfFormat := CF_FILECONTENTS;
    Format.ptd := nil;
    Format.dwAspect := DVASPECT_CONTENT;
    Format.lindex := FileIndex;
    Format.tymed := TYMED_ISTREAM;
    if Succeeded(DataObject.GetData(Format, Medium)) then
    begin
      Stream := TOLEStream.Create(IStream(Medium.stm));
      ReleaseStgMedium(Medium);
    end;
  end;
  Result := Stream;
end;

function TFileGroupDescriptorW.GetFormatEtc: TFormatEtc;
begin
  Result.cfFormat := CF_FILEDESCRIPTORW;
  Result.ptd := nil;
  Result.dwAspect := DVASPECT_CONTENT;
  Result.lindex := -1;
  Result.tymed := TYMED_HGLOBAL
end;

procedure TFileGroupDescriptorW.LoadFileGroupDestriptor(FileGroupDiscriptor: PFileGroupDescriptorW);
var
  i: Cardinal;
begin
  if Assigned(FileGroupDiscriptor) then
  begin
    SetLength(FFileDescriptors, FileGroupDiscriptor.cItems);
    for i := 0 to FileGroupDiscriptor.cItems - 1 do
    begin
      FFileDescriptors[i] := FileGroupDiscriptor.fgd[i]
    end
  end else
    FFileDescriptors := nil;
end;

function TFileGroupDescriptorW.LoadFromClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
var
  DataObject: IDataObject;
begin
  Result := False;
  if Succeeded(OleGetClipboard(DataObject)) then
    Result := LoadFromDataObject(DataObject);
end;

function TFileGroupDescriptorW.LoadFromDataObject(DataObject: IDataObject): Boolean;
var
  GroupDescriptor: PFileGroupDescriptorW;
  Medium: TStgMedium;
  i: Integer;
begin
  Result := False;
  if Succeeded(DataObject.GetData(GetFormatEtc, Medium)) then
  begin
    GroupDescriptor := GlobalLock(Medium.hGlobal);
    try
      for i := 0 to GroupDescriptor^.cItems - 1 do
        AddFileDescriptor(GroupDescriptor^.fgd[i])
    finally
      GlobalUnlock(Medium.hGlobal);
      ReleaseStgMedium(Medium);
      Result := True;
    end
  end
end;

function TFileGroupDescriptorW.SaveToClipboard(ClipboardAlreadyOpen: Boolean = False): Boolean;
var
  DataObject: IDataObject;
begin
  Result := False;
  DataObject := TVirtualDataObject.Create;
  if SaveToDataObject(DataObject) then
    Result := Succeeded(OleSetClipboard(DataObject))
end;

function TFileGroupDescriptorW.SaveToDataObject(DataObject: IDataObject): Boolean;
var
  Mem: THandle;
  GroupDescriptor: PFileGroupDescriptorW;
  Medium: TStgMedium;
  Format: TFormatEtc;
begin
  Result := False;
  if Assigned(DataObject) and (DescriptorCount > 0) then
  begin
    Mem := GlobalAlloc(GHND, DescriptorCount * SizeOf(TFileDescriptorW) + SizeOf(GroupDescriptor.cItems));
    GroupDescriptor := GlobalLock(Mem);
    try
      GroupDescriptor.cItems := DescriptorCount;
      CopyMemory(@GroupDescriptor^.fgd[0], @FFileDescriptors[0], DescriptorCount * SizeOf(TFileDescriptorW));
    finally
      GlobalUnlock(Mem)
    end;
    FillChar(Medium, SizeOf(Medium), #0);
    Medium.tymed := TYMED_HGLOBAL;
    Medium.hGlobal := Mem;

    DataObject.SetData(GetFormatEtc, Medium, True);

    Medium.tymed := TYMED_ISTREAM;
    Medium.stm := nil;

    Format.cfFormat := CF_FILECONTENTS;
    Format.ptd := nil;
    Format.dwAspect := DVASPECT_CONTENT;
    Format.lindex := -1;
    Format.tymed := TYMED_ISTREAM;
    DataObject.SetData(Format, Medium, True);
  end
end;

procedure TFileGroupDescriptorW.SetFileDescriptor(Index: Integer; const Value: TFileDescriptorW);
begin
  if (Index > -1) and (Index < Length(FFileDescriptors)) then
    FFileDescriptors[Index] := Value
end;

initialization
  PIDLMgr := TPIDLManager.Create;
  CF_SHELLIDLIST := RegisterClipboardFormat(CFSTR_SHELLIDLIST);
  CF_LOGICALPERFORMEDDROPEFFECT := RegisterClipboardFormat(CFSTR_LOGICALPERFORMEDDROPEFFECT);
  CF_PREFERREDDROPEFFECT := RegisterClipboardFormat(CFSTR_PREFERREDDROPEFFECT);
  CF_FILECONTENTS := RegisterClipboardFormat(CFSTR_FILECONTENTS);
  CF_FILEDESCRIPTORA := RegisterClipboardFormat(CFSTR_FILEDESCRIPTORA);
  CF_FILEDESCRIPTORW := RegisterClipboardFormat(CFSTR_FILEDESCRIPTORW);

finalization
  PIDLMgr.Free;

end.
