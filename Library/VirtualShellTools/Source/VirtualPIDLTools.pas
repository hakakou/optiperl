unit VirtualPIDLTools;

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
// This unit implements two classes to simplify the handling of PItemIDLists.  They
// are:
//      TPIDLManager - Exposes numerous methods to handle the details of
//                     manipulting and comparing PIDLs
//      TPIDLList    - A TList decendant that is tailored to store PIDLs
//
//  USAGE:
//    This unit is compiled with WeakPackaging because it is used in several
// different packages and Delphi does not allow this without WeakPackaging.
// A WeakPackaged unit can not have initialization or Finalization sections so
// due to this fact this unit must implement a "load on demand" for the undocumented
// PIDL functions.
//
// Jim Kueneman
// 2/20/02
// *****************************************************************************
//
// Software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
// either express or implied.
//
// *****************************************************************************

interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Controls, ShlObj, ShellAPI,
  {$IFNDEF COMPILER_5_UP}
  VirtualUtilities,
  {$ENDIF COMPILER_5_UP}
  ActiveX,
  VirtualWideStrings;

type

  TPIDLManager = class;  // forward
  TPIDLList = class;     // forward

  TPIDLList = class(TList)
  private
    FSharePIDLs: Boolean;    // If true the class will not free the PIDL's automaticlly when destroyed
    FPIDLMgr: TPIDLManager;
    FDestroying: Boolean;  // Instance of a PIDLManager used to easily deal with the PIDL's
    function GetPIDL(Index: integer): PItemIDList;
    function GetPIDLMgr: TPIDLManager;

  protected
    property Destroying: Boolean read FDestroying;
    property PIDLMgr: TPIDLManager read GetPIDLMgr;
  public
    destructor Destroy; override;

    procedure Clear; override;
    procedure CloneList(PIDLList: TPIDLList);
    function CopyAdd(PIDL: PItemIDList): Integer;
    function FindPIDL(TestPIDL: PItemIDList): Integer;
    function LoadFromFile(FileName: WideString): Boolean;
    function LoadFromStream( Stream: TStream): Boolean; virtual;
    function SaveToFile(FileName: WideString): Boolean;
    function SaveToStream( Stream: TStream): Boolean; virtual;

    property SharePIDLs: Boolean read FSharePIDLs write FSharePIDLs;
  end;

// TPIDL Manager is a class the encapsulates PIDLs and makes them easier to
// handle.
  TPIDLManager = class
  private
  protected
    FMalloc: IMalloc;  // The global Memory allocator
  public
    constructor Create;
    destructor Destroy; override;

    function AllocStrGlobal(SourceStr: WideString): POleStr;
    function AppendPIDL(DestPIDL, SrcPIDL: PItemIDList): PItemIDList;
    function CopyPIDL(APIDL: PItemIDList): PItemIDList;
    function EqualPIDL(PIDL1, PIDL2: PItemIDList): Boolean;
    procedure FreeAndNilPIDL(var PIDL: PItemIDList);
    procedure FreeOLEStr(OLEStr: LPWSTR);
    procedure FreePIDL(PIDL: PItemIDList);
    function CopyLastID(IDList: PItemIDList): PItemIDList;
    function GetPointerToLastID(IDList: PItemIDList): PItemIDList;
    function IDCount(APIDL: PItemIDList): integer;
    function IsDesktopFolder(APIDL: PItemIDList): Boolean;
    function IsSubPIDL(FullPIDL, SubPIDL: PItemIDList): Boolean;
    function NextID(APIDL: PItemIDList): PItemIDList;
    function PIDLSize(APIDL: PItemIDList): integer;
    function PIDLToString(APIDL: PItemIDList): string;
    function LoadFromFile(FileName: WideString): PItemIDList;
    function LoadFromStream(Stream: TStream): PItemIDList;
    procedure ParsePIDL(AbsolutePIDL: PItemIDList; var PIDLList: TPIDLList; AllAbsolutePIDLs: Boolean);
    function StringToPIDL(PIDLStr: string): PItemIDList;
    function StripLastID(IDList: PItemIDList): PItemIDList; overload;
    function StripLastID(IDList: PItemIDList; var Last_CB: Word; var LastID: PItemIDList): PItemIDList; overload;
    procedure SaveToFile(FileName: WideString; FileMode: Word; PIDL: PItemIdList);
    procedure SaveToStream(Stream: TStream; PIDL: PItemIdList);

    property Malloc: IMalloc read FMalloc;
  end;

  function ILIsEqual(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool;
  function ILIsParent(PIDL1: PItemIDList; PIDL2: PItemIDList; ImmediateParent: LongBool): LongBool;

  function GetMyDocumentsVirtualFolder: PItemIDList;

// Don't use the following functions, they are only here because with Weakpackaging
// on we can't use initializaiton and finialzation sections.  Because of that we
// have to load the Shell 32 functions on demand, but if the package that uses
// this unit does not calls these functions the compiler gives us a "The unit
// does not use or export the function XXXX"  This keeps the compiler quiet.
type
  TShellILIsParent = function(PIDL1: PItemIDList; PIDL2: PItemIDList;
    ImmediateParent: LongBool): LongBool; stdcall;
  TShellILIsEqual = function(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool; stdcall;
  procedure LoadShell32Functions;

var
  ShellILIsParent: TShellILIsParent = nil;
  ShellILIsEqual: TShellILIsEqual = nil;

implementation

{$IFDEF VIRTUALNAMESPACES}
uses
  VirtualNamespace;
{$ENDIF}

var
  PIDLManager: TPIDLManager;

// -----------------------------------------------------------------------------
procedure LoadShell32Functions;
var
  ShellDLL: HMODULE;
begin
  ShellDLL := GetModuleHandle(PChar(Shell32));
//  ShellDLL := LoadLibrary(PChar(Shell32));
  if ShellDll <> 0 then
  begin
    ShellILIsEqual := GetProcAddress(ShellDLL, PChar(21));
    ShellILIsParent := GetProcAddress(ShellDLL, PChar(23));
  end
end;
// -----------------------------------------------------------------------------

function ILIsEqual(PIDL1: PItemIDList; PIDL2: PItemIDList): LongBool;
// Wrapper around undocumented ILIsEqual function.  It can't take nil parameters
{$IFDEF VIRTUALNAMESPACES}
var
  OldPIDL: PItemIDList;
  OldCB: Word;
  Desktop, Folder: IShellFolder;
  IsVirtual1,
  IsVirtual2: Boolean;
{$ENDIF}
begin
  if not Assigned(ShellILIsEqual) then
    LoadShell32Functions;
  if Assigned(PIDL1) and Assigned(PIDL2) then
  {$IFDEF VIRTUALNAMESPACES}
  begin          
    Result := False;
    IsVirtual1 := NamespaceExtensionFactory.IsVirtualPIDL(PIDL1);
    IsVirtual2 := NamespaceExtensionFactory.IsVirtualPIDL(PIDL2);
    if (IsVirtual1 and IsVirtual2) then
    begin
      if PIDLManager.IDCount(PIDL1) = PIDLManager.IDCount(PIDL2) then
      begin
        Folder := NamespaceExtensionFactory.BindToVirtualParentObject(PIDL1);
        OldPIDL := PIDLManager.GetPointerToLastID(PIDL1);
        if Assigned(Folder) then
          Result := Folder.CompareIDs(0, OldPIDL, PIDLManager.GetPointerToLastID(PIDL2)) = 0
      end
    end else
    if not IsVirtual1 and not IsVirtual2 then
    begin
   //   Result := ShellILIsEqual(PIDL1, PIDL2)
      // Believe it or not MY routine is faster than the M$ version!!!!
      if PIDLManager.IDCount(PIDL1) = PIDLManager.IDCount(PIDL2) then
      begin
        if PIDLManager.IDCount(PIDL1) > 1 then
        begin
          PIDLManager.StripLastID(PIDL1, OldCB, OldPIDL);
          SHGetDesktopFolder(Desktop);
          if Succeeded(Desktop.BindToObject(PIDL1, nil, IID_IShellFolder, Folder)) then
          begin
            OldPIDL.mkid.cb := OldCB;
            OldPIDL := PIDLManager.GetPointerToLastID(PIDL1);
            Result := Folder.CompareIDs(0, OldPIDL, PIDLManager.GetPointerToLastID(PIDL2)) = 0
          end else
            OldPIDL.mkid.cb := OldCB;
        end else
        begin
          SHGetDesktopFolder(Folder);
          Result := Folder.CompareIDs(0, PIDL1, PIDL2) = 0
        end
      end
    end
  end
  {$ELSE}
    Result := ShellILIsEqual(PIDL1, PIDL2)
  {$ENDIF}
  else
   Result := False
end;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
function ILIsParent(PIDL1: PItemIDList; PIDL2: PItemIDList; ImmediateParent: LongBool): LongBool;
// Wrapper around undocumented ILIsParent function.  It can't take nil parameters
{$IFDEF VIRTUALNAMESPACES}
const
  AllObjects = SHCONTF_FOLDERS or SHCONTF_NONFOLDERS or SHCONTF_INCLUDEHIDDEN;
var
  Folder: IShellFolder;
  TailPIDL1, TailPIDL2: PItemIDList;
  OldCB: Word;
  OldPIDL: PItemIDList;
  i, Count1, Count2: Integer;
{$ENDIF}
begin
  if not Assigned(ShellILIsParent) then
    LoadShell32Functions;
  if Assigned(PIDL1) and Assigned(PIDL2) then
  {$IFDEF VIRTUALNAMESPACES}
  begin
    Result := False;
    if NamespaceExtensionFactory.IsVirtualPIDL(PIDL1) or NamespaceExtensionFactory.IsVirtualPIDL(PIDL2) then
    begin
      Count1 := PIDLManager.IDCount(PIDL1);
      Count2 := PIDLManager.IDCount(PIDL2);
      // The Parent must have less PIDLs to be a parent!
      if Count1 < Count2 then
      begin
        // Desktop is a special case
        if (PIDL1.mkid.cb = 0) and (PIDL2.mkid.cb > 0) then
        begin
          if ImmediateParent then
          begin
            if PIDLManager.IDCount(PIDL2) = 1 then
              Result := True
          end else
            Result := True
        end else
        begin
          // If looking for the immediate parent and the second pidl is different
          // than one greater than it can't be true
          if ImmediateParent and (Count1 + 1 <> Count2) then
            Exit;


          Folder := NamespaceExtensionFactory.BindToVirtualParentObject(PIDL1);

          TailPIDL1 := PIDLManager.GetPointerToLastID(PIDL1);
          TailPIDL2 := PIDL2;
          for i := 0 to PIDLManager.IDCount(PIDL1) - 2 do
            TailPIDL2 := PIDLManager.NextID(TailPIDL2);
          OldPIDL := PIDLManager.NextID(TailPIDL2);
          OldCB := OldPIDL.mkid.cb;
          OldPIDL.mkid.cb := 0;
          try
            Result := Folder.CompareIDs(0, TailPIDL1, TailPIDL2) = 0;
          finally
            OldPIDL.mkid.cb := OldCB
          end;
        end
      end
    end else
     Result := ShellILIsParent(PIDL1, PIDL2, ImmediateParent)
  end
  {$ELSE}
    Result := ShellILIsParent(PIDL1, PIDL2, ImmediateParent)
  {$ENDIF}
  else
    Result := False
end;
// -----------------------------------------------------------------------------


function GetMyDocumentsVirtualFolder: PItemIDList;

const
  MYCOMPUTER_GUID = WideString('::{450d8fba-ad25-11d0-98a8-0800361b1103}');

var
  dwAttributes, pchEaten: ULONG;
  Desktop: IShellFolder;
begin
  Result := nil;
  dwAttributes := 0;
  SHGetDesktopFolder(Desktop);
  pchEaten := Length(MYCOMPUTER_GUID);
  if not Succeeded(Desktop.ParseDisplayName(0, nil,
    PWideChar(MYCOMPUTER_GUID), pchEaten, Result, dwAttributes))
  then
    Result := nil
end;



{ TPIDLList }

// -----------------------------------------------------------------------------
// Specialized TList that handles PIDLs
// -----------------------------------------------------------------------------

procedure TPIDLList.Clear;
var
  i: integer;
begin
 // if (not Destroying) then
  begin
    if not SharePIDLs and Assigned(PIDLMgr)then
      for i := 0 to Count - 1 do
        PIDLMgr.FreePIDL( PItemIDList( Items[i]));
  end;
  inherited;
end;

procedure TPIDLList.CloneList(PIDLList: TPIDLList);
var
  i: Integer;
begin
  if Assigned(PIDLList) then
    for i := 0 to Count - 1 do
      PIDLList.CopyAdd(Items[i])
end;

function TPIDLList.CopyAdd(PIDL: PItemIDList): integer;
// Adds a Copy of the passed PIDL to the list
begin
  Result := Add( PIDLMgr.CopyPIDL(PIDL));
end;

destructor TPIDLList.Destroy;
begin
  FDestroying := True;
  inherited;
  FreeAndNil(FPIDLMgr);
end;

function TPIDLList.FindPIDL(TestPIDL: PItemIDList): Integer;
// Finds the index of the PIDL that is equivalent to the passed PIDL.  This is not
// the same as an byte for byte equivalent comparison
var
  i: Integer;
begin
  i := 0;
  Result := -1;
  while (i < Count) and (Result < 0) do
  begin
    if PIDLMgr.EqualPIDL(TestPIDL, GetPIDL(i)) then
      Result := i;
    Inc(i);
  end;
end;

function TPIDLList.GetPIDL(Index: integer): PItemIDList;
begin
  Result := PItemIDList( Items[Index]);
end;

function TPIDLList.GetPIDLMgr: TPIDLManager;
begin
  if not Assigned(FPIDLMgr) then
    FPIDLMgr := TPIDLManager.Create;
  Result := FPIDLMgr
end;

function TPIDLList.LoadFromFile(FileName: WideString): Boolean;
// Loads the PIDL list from a file
var
  FileStream: TWideFileStream;
begin
  FileStream := nil;
  try
    try
      FileStream := TWideFileStream.Create(FileName, fmOpenRead or fmShareExclusive);
      Result := LoadFromStream(FileStream);
    except
      Result := False;
    end;
  finally
    FileStream.Free
  end;
end;

function TPIDLList.LoadFromStream(Stream: TStream): Boolean;
// Loads the PIDL list from a stream
var
  PIDLCount, i: integer;
begin
  Result := True;
  try
    Stream.ReadBuffer(PIDLCount, SizeOf(Integer));
    for i := 0 to PIDLCount - 1 do
      Add( PIDLMgr.LoadFromStream(Stream));
  except
    Result := False;
  end;
end;

function TPIDLList.SaveToFile(FileName: WideString): Boolean;
// Saves the PIDL list to a File
var
  FileStream: TWideFileStream;
begin
  FileStream := nil;
  try
    try
      FileStream := TWideFileStream.Create(FileName, fmCreate or fmShareExclusive);
      Result := SaveToStream(FileStream);
    except
      Result := False;
    end;
  finally
    FileStream.Free
  end;
end;

function TPIDLList.SaveToStream(Stream: TStream): Boolean;
// Saves the PIDL list to a stream
var
  i: integer;
begin
  Result := True;
  try
    Stream.WriteBuffer(Count, SizeOf(Count));
    for i := 0 to Count - 1 do
      PIDLMgr.SaveToStream(Stream, Items[i]);
  except
    Result := False;
  end;
end;

{ TPIDLManager }

// Routines to do most anything you would want to do with a PIDL

function TPIDLManager.AppendPIDL(DestPIDL, SrcPIDL: PItemIDList): PItemIDList;
// Returns the concatination of the two PIDLs. Neither passed PIDLs are
// freed so it is up to the caller to free them.
var
  DestPIDLSize, SrcPIDLSize: integer;
begin
  DestPIDLSize := 0;
  SrcPIDLSize := 0;
  // Appending a PIDL to the DesktopPIDL is invalid so don't allow it.
  if Assigned(DestPIDL) then
    if not IsDesktopFolder(DestPIDL) then
      DestPIDLSize := PIDLSize(DestPIDL) - SizeOf(DestPIDL^.mkid.cb);

  if Assigned(SrcPIDL) then
    SrcPIDLSize := PIDLSize(SrcPIDL);

  Result := FMalloc.Alloc(DestPIDLSize + SrcPIDLSize);
  if Assigned(Result) then
  begin
    if Assigned(DestPIDL) then
      CopyMemory(Result, DestPIDL, DestPIDLSize);
    if Assigned(SrcPIDL) then
      CopyMemory(Pchar(Result) + DestPIDLSize, SrcPIDL, SrcPIDLSize);
  end;
end;

function TPIDLManager.CopyPIDL(APIDL: PItemIDList): PItemIDList;
// Copies the PIDL and returns a newly allocated PIDL. It is not associated
// with any instance of TPIDLManager so it may be assigned to any instance.
var
  Size: integer;
begin
  if Assigned(APIDL) then
  begin
    Size := PIDLSize(APIDL);
    Result := FMalloc.Alloc(Size);
    if Result <> nil then
      CopyMemory(Result, APIDL, Size);
  end else
    Result := nil
end;

constructor TPIDLManager.Create;
begin
  inherited Create;
  if SHGetMalloc(FMalloc) = E_FAIL then
    fail
end;

destructor TPIDLManager.Destroy;
begin
  FMalloc := nil;
  inherited
end;

function TPIDLManager.EqualPIDL(PIDL1, PIDL2: PItemIDList): Boolean;
begin
  Result := Boolean( ILIsEqual(PIDL1, PIDL2))
end;

procedure TPIDLManager.FreeOLEStr(OLEStr: LPWSTR);
// Frees an OLE string created by the Shell; as in StrRet
begin
  FMalloc.Free(OLEStr)
end;

procedure TPIDLManager.FreePIDL(PIDL: PItemIDList);
// Frees the PIDL using the shell memory allocator
begin
  if Assigned(PIDL) then
    FMalloc.Free(PIDL)
end;

function TPIDLManager.CopyLastID(IDList: PItemIDList): PItemIDList;
// Returns a copy of the last PID in the list
var
  Count, i: integer;
  PIDIndex: PItemIDList;
begin
  PIDIndex := IDList;
  Count := IDCount(IDList);
  if Count > 1 then
    for i := 0 to Count - 2 do
     PIDIndex := NextID(PIDIndex);
  Result := CopyPIDL(PIDIndex);
end;

function TPIDLManager.GetPointerToLastID(IDList: PItemIDList): PItemIDList;
// Return a pointer to the last PIDL in the complex PIDL passed to it.
// Useful to overlap an Absolute complex PIDL with the single level
// Relative PIDL.
var
  Count, i: integer;
  PIDIndex: PItemIDList;
begin
  if Assigned(IDList) then
  begin
    PIDIndex := IDList;
    Count := IDCount(IDList);
    if Count > 1 then
      for i := 0 to Count - 2 do
       PIDIndex := NextID(PIDIndex);
    Result := PIDIndex;
  end else
    Result := nil
end;

function TPIDLManager.IDCount(APIDL: PItemIDList): integer;
// Counts the number of Simple PIDLs contained in a Complex PIDL.
var
  Next: PItemIDList;
begin
  Result := 0;
  Next := APIDL;
  if Assigned(Next) then
  begin
    while Next^.mkid.cb <> 0 do
    begin
      Inc(Result);
      Next := NextID(Next);
    end
  end
end;

function TPIDLManager.IsDesktopFolder(APIDL: PItemIDList): Boolean;
// Tests the passed PIDL to see if it is the root Desktop Folder
begin
  if Assigned(APIDL) then
    Result := APIDL.mkid.cb = 0
  else
    Result := False
end;

function TPIDLManager.NextID(APIDL: PItemIDList): PItemIDList;
// Returns a pointer to the next Simple PIDL in a Complex PIDL.
begin
  Result := APIDL;
  Inc(PChar(Result), APIDL^.mkid.cb);
end;

function TPIDLManager.PIDLSize(APIDL: PItemIDList): integer;
// Returns the total Memory in bytes the PIDL occupies.
begin
  Result := 0;
  if Assigned(APIDL) then
  begin
    Result := SizeOf( Word);  // add the null terminating last ItemID
    while APIDL.mkid.cb <> 0 do
    begin
      Result := Result + APIDL.mkid.cb;
      APIDL := NextID(APIDL);
    end;
  end;
end;

function TPIDLManager.PIDLToString(APIDL: PItemIDList): string;
var
  Size: integer;
  P: PChar;
begin
  Size := PIDLSize(APIDL);
  SetLength(Result, PIDLSize(APIDL));
  P := @Result[1];
  Move(APIDL^, P^, Size);
end;

function TPIDLManager.LoadFromFile(FileName: WideString): PItemIDList;
// Loads the PIDL from a File
var
  S: TWideFileStream;
begin
  S := TWideFileStream.Create(FileName, fmOpenRead);
  try
    Result := LoadFromStream(S);
  finally
    S.Free;
  end;
end;

function TPIDLManager.LoadFromStream(Stream: TStream): PItemIDList;
// Loads the PIDL from a Stream
var
  Size: integer;
begin
  Result := nil;
  if Assigned(Stream) then
  begin
    Stream.ReadBuffer(Size, SizeOf(Integer));
    if Size > 0 then
    begin
      Result := FMalloc.Alloc(Size);
      Stream.ReadBuffer(Result^, Size);
    end
  end
end;

function TPIDLManager.StringToPIDL(PIDLStr: string): PItemIDList;
var
  P: PChar;
begin
  Result := FMalloc.Alloc(Length(PIDLStr));
  P := @PIDLStr[1];
  Move(P^, Result^, Length(PIDLStr));
end;

function TPIDLManager.StripLastID(IDList: PItemIDList): PItemIDList;
// Removes the last PID from the list. Returns the same, shortened, IDList passed
// to the function
var
  MarkerID: PItemIDList;
begin
  Result := IDList;
  MarkerID := IDList;
  if Assigned(IDList) then
  begin
    while IDList.mkid.cb <> 0 do
    begin
      MarkerID := IDList;
      IDList := NextID(IDList);
    end;
    MarkerID.mkid.cb := 0;
  end;
end;

procedure TPIDLManager.SaveToFile(FileName: WideString; FileMode: Word;
  PIDL: PItemIdList);
// Saves the PIDL from a File
var
  S: TWideFileStream;
begin
  S := TWideFileStream.Create(FileName, FileMode);
  try
    SaveToStream(S, PIDL);
  finally
    S.Free;
  end;
end;

procedure TPIDLManager.SaveToStream(Stream: TStream; PIDL: PItemIdList);
// Saves the PIDL from a Stream
var
  Size: Integer;
begin
  Size := PIDLSize(PIDL);
  Stream.WriteBuffer(Size, SizeOf(Size));
  Stream.WriteBuffer(PIDL^, Size);
end;



function TPIDLManager.StripLastID(IDList: PItemIDList; var Last_CB: Word;
  var LastID: PItemIDList): PItemIDList;
// Strips the last ID but also returns the pointer to where the last CB was and the
// value that was there before setting it to 0 to shorten the PIDL.  All that is necessary
// is to do a LastID^ := Last_CB.mkid.cb to return the PIDL to its previous state.  Used to
// temporarily strip the last ID of a PIDL
var
  MarkerID: PItemIDList;
begin
  Last_CB := 0;
  LastID := nil;
  Result := IDList;
  MarkerID := IDList;
  if Assigned(IDList) then
  begin
    while IDList.mkid.cb <> 0 do
    begin
      MarkerID := IDList;
      IDList := NextID(IDList);
    end;
    Last_CB := MarkerID.mkid.cb;
    LastID := MarkerID;
    MarkerID.mkid.cb := 0;
  end;
end;

function TPIDLManager.IsSubPIDL(FullPIDL, SubPIDL: PItemIDList): Boolean;
// Tests to see if the SubPIDL can be expanded into the passed FullPIDL
var
  i, PIDLLen, SubPIDLLen: integer;
  PIDL: PItemIDList;
  OldCB: Word;
begin
  Result := False;
  if Assigned(FullPIDL) and Assigned(SubPIDL) then
  begin
    SubPIDLLen := IDCount(SubPIDL);
    PIDLLen := IDCount(FullPIDL);
    if SubPIDLLen <= PIDLLen then
    begin
      PIDL := FullPIDL;
      for i := 0 to SubPIDLLen - 1 do
        PIDL := NextID(PIDL);
      OldCB := PIDL.mkid.cb;
      PIDL.mkid.cb := 0;
      try
        Result := ILIsEqual(FullPIDL, SubPIDL);
      finally
        PIDL.mkid.cb := OldCB
      end
    end
  end
end;

procedure TPIDLManager.FreeAndNilPIDL(var PIDL: PItemIDList);
var
  OldPIDL: PItemIDList;
begin
  OldPIDL := PIDL;
  PIDL := nil;
  FreePIDL(OldPIDL)
end;

function TPIDLManager.AllocStrGlobal(SourceStr: WideString): POleStr;
begin
  Result := Malloc.Alloc((Length(SourceStr) + 1) * 2); // Add the null
  if Result <> nil then
    CopyMemory(Result, PWideChar(SourceStr), (Length(SourceStr) + 1) * 2);
end;

procedure TPIDLManager.ParsePIDL(AbsolutePIDL: PItemIDList; var PIDLList: TPIDLList;
  AllAbsolutePIDLs: Boolean);
// Parses the AbsolutePIDL in to its single level PIDLs, if AllAbsolutePIDLs is true
// then each item is not a single level PIDL but an AbsolutePIDL but walking from the
// Desktop up to the passed AbsolutePIDL
var
  OldCB: Word;
  Head, Tail: PItemIDList;
begin
  Head := AbsolutePIDL;
  Tail := Head;
  if Assigned(PIDLList) and Assigned(Head) then
  begin
    while Tail.mkid.cb <> 0 do
    begin
      Tail := NextID(Tail);
      OldCB := Tail.mkid.cb;
      try
        Tail.mkid.cb := 0;
        PIDLList.Add(CopyPIDL(Head));
      finally
        Tail.mkid.cb := OldCB;
      end;
      if not AllAbsolutePIDLs then
        Head := Tail
    end
  end
end;

initialization
  PIDLManager := TPIDLManager.Create;

finalization
  FreeAndNil(PIDLManager);

end.
