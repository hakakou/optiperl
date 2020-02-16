unit VirtualWideStrings;

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

// This unit contains Unicode functions and classes.  They will work
// in Win9x-ME and WinNT.  The fundamental function is Unicode but if it is not
// running in an Unicode enviroment it will convert to ASCI call the ASCI function
// then convert back to Unicode. (The opposite of what happens in NT with a
// Delphi program, convert from ASCI to Unicode then back to ASCI)
// It borrows a lot of functions from Mike Lischke's Unicode collection:
//   http://www.lischke-online.de/Unicode.html
// It also borrows a few ideas from Troy Wolbrink's TNT Unicode VCL controls
//  http://home.ccci.org/wolbrink/tnt/delphi_unicode_controls.htm
//
//
//      Issues:
//        7.13.02
//              -ShortenStringEx needs to implmement RTL languages once I understand
//                 it better.


interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses SysUtils, Windows, Classes,
  {$ifdef COMPILER_6_UP}
  RTLConsts
  {$else}
  Consts
  {$endif},
  ActiveX, ShellAPI, ShlObj, Graphics, VirtualResources, VirtualUtilities,
  VirtualUnicodeDefines;


const
  // definitions of frequently used characters:
  // Note: Use them only for tests of a certain character not to determine character
  //       classes (like white spaces) as in Unicode are often many code points defined
  //       being in a certain class.
  WideNull = WideChar(#0);
  WideTabulator = WideChar(#9);
  WideSpace = WideChar(#32);

  // logical line breaks
  WideLF = WideChar(#10);
  WideLineFeed = WideChar(#10);
  WideVerticalTab = WideChar(#11);
  WideFormFeed = WideChar(#12);
  WideCR = WideChar(#13);
  WideCarriageReturn = WideChar(#13);
  WideCRLF: WideString = #13#10;
  WideLineSeparator = WideChar($2028);
  WideParagraphSeparator = WideChar($2029);

  //From Mike's Unicode library
  // byte order marks for strings
  // Unicode text files should contain $FFFE as first character to identify such a file clearly. Depending on the system
  // where the file was created on this appears either in big endian or little endian style.
  BOM_LSB_FIRST = WideChar($FEFF); // this is how the BOM appears on x86 systems when written by a x86 system
  BOM_MSB_FIRST = WideChar($FFFE);

type
  TWideFileStream = class(THandleStream)
  public
    constructor Create(const FileName: WideString; Mode: Word);
    destructor Destroy; override;
  end;

  procedure SaveWideString(S: TStream; Str: WideString);
  procedure LoadWideString(S: TStream; var Str: WideString);

type
  TShortenStringEllipsis = (
    sseEnd,            // Ellipsis on end of string
    sseFront,          // Ellipsis on begining of string
    sseMiddle,         // Ellipsis in middle of string
    sseFilePathMiddle  // Ellipsis is in middle of string but tries to show the entire filename
  );

type
  TWideStringList = class;    // forward

  PWideStringItem = ^TWideStringItem;
  TWideStringItem = record
    FWideString: WideString;
    FObject: TObject;
  end;

  PWideStringItemList = ^TWideStringItemList;
  TWideStringItemList = array[0..MaxListSize] of TWideStringItem;
  TWideStringListSortCompare = function(List: TWideStringList; Index1, Index2: Integer): Integer;

{*******************************************************************************}
{ TWideStringList                                                               }
{      A simple reincarnation of TStringList that can deal with Unicode or ANSI.}
{ It will work on NT or 9x-ME.                                                  }
{*******************************************************************************}
  TWideStringList = class(TPersistent)
  private
    FList: PWideStringItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FOnChange: TNotifyEvent;
    FOnChanging: TNotifyEvent;
    FOwnsObjects: Boolean;
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure Grow;
    procedure QuickSort(L, R: Integer; SCompare: TWideStringListSortCompare);
    procedure InsertItem(Index: Integer; const S: WideString; AObject: TObject);
    procedure SetSorted(Value: Boolean);
    function GetName(Index: Integer): WideString;
    function GetTextStr: WideString;
    function GetValue(const Name: WideString): WideString;
    function GetValueFromIndex(Index: Integer): WideString;
    procedure SetTextStr(const Value: WideString);
    procedure SetValue(const Name, Value: WideString);
    procedure SetValueFromIndex(Index: Integer; const Value: WideString);
    function GetCommaText: WideString;
    procedure SetCommaText(const Value: WideString);
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure Changed; virtual;
    procedure Changing; virtual;
    procedure Error(const Msg: String; Data: Integer);
    function Get(Index: Integer): WideString; virtual;
    function GetCapacity: Integer; virtual;
    function GetCount: Integer; virtual;
    function GetObject(Index: Integer): TObject; virtual;
    procedure Put(Index: Integer; const S: WideString); virtual;
    procedure PutObject(Index: Integer; AObject: TObject); virtual;
    procedure SetCapacity(NewCapacity: Integer); virtual;
    procedure SetUpdateState(Updating: Boolean); virtual;
  public
    destructor Destroy; override;
    function Add(const S: WideString): Integer; virtual;
    function AddObject(const S: WideString; AObject: TObject): Integer; virtual;
    procedure AddStrings(Strings: TWideStringList); overload; virtual;
    procedure AddStrings(Strings: TStrings); overload; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;
    procedure CustomSort(Compare: TWideStringListSortCompare); virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Exchange(Index1, Index2: Integer); virtual;
    function Find(const S: WideString; var Index: Integer): Boolean; virtual;
    function IndexOf(const S: WideString): Integer; virtual;
    function IndexOfName(const Name: WideString): Integer;
    function IndexOfObject(AObject: TObject): Integer;
    procedure Insert(Index: Integer; const S: WideString); virtual;
    procedure Sort; virtual;
    procedure LoadFromFile(const FileName: WideString); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: WideString); virtual;
    procedure SaveToStream(Stream: TStream); virtual;

    property CommaText: WideString read GetCommaText write SetCommaText;
    property Count: Integer read GetCount;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Names[Index: Integer]: WideString read GetName;
    property Sorted: Boolean read FSorted write SetSorted;
    property Strings[Index: Integer]: WideString read Get write Put; default;
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnChanging: TNotifyEvent read FOnChanging write FOnChanging;
    property OwnsObjects: Boolean read FOwnsObjects write FOwnsObjects;
    property Text: WideString read GetTextStr write SetTextStr;
    property Values[const Name: WideString]: WideString read GetValue write SetValue;
    property ValueFromIndex[Index: Integer]: WideString read GetValueFromIndex write SetValueFromIndex;
  end;

// functions involving null-terminated strings
// NOTE: PWideChars as well as WideStrings are NOT managed by reference counting under Win32.
//       In Kylix this is different. WideStrings are reference counted there, just like ANSI strings.
function StrLenW(Str: PWideChar): Cardinal;
function StrEndW(Str: PWideChar): PWideChar;
function StrMoveW(Dest, Source: PWideChar; Count: Cardinal): PWideChar;
function StrCopyW(Dest, Source: PWideChar): PWideChar;
function StrECopyW(Dest, Source: PWideChar): PWideChar;
function StrLCopyW(Dest, Source: PWideChar; MaxLen: Cardinal): PWideChar;
function StrPCopyW(Dest: PWideChar; const Source: string): PWideChar;
function StrPLCopyW(Dest: PWideChar; const Source: string; MaxLen: Cardinal): PWideChar;
function StrCatW(Dest, Source: PWideChar): PWideChar;
function StrLCatW(Dest, Source: PWideChar; MaxLen: Cardinal): PWideChar;
function StrCompW(Str1, Str2: PWideChar): Integer;
function StrICompW(Str1, Str2: PWideChar): Integer;
function StrLCompW(Str1, Str2: PWideChar; MaxLen: Cardinal): Integer;
function StrLICompW(Str1, Str2: PWideChar; MaxLen: Cardinal): Integer;
function StrLowerW(Str: PWideChar): PWideChar;
function StrNScanW(S1, S2: PWideChar): Integer;
function StrRNScanW(S1, S2: PWideChar): Integer;
function StrScanW(Str: PWideChar; Chr: WideChar): PWideChar; overload;
function StrScanW(Str: PWideChar; Chr: WideChar; StrLen: Cardinal): PWideChar; overload;
function StrRScanW(Str: PWideChar; Chr: WideChar): PWideChar;
function StrPosW(Str, SubStr: PWideChar): PWideChar;
function StrAllocW(Size: Cardinal): PWideChar;
function StrBufSizeW(Str: PWideChar): Cardinal;
function StrNewW(Str: PWideChar): PWideChar;
procedure StrDisposeW(Str: PWideChar);
procedure StrSwapByteOrder(Str: PWideChar);
function StrUpperW(Str: PWideChar): PWideChar;

// functions involving Delphi wide strings
function WideAdjustLineBreaks(const S: WideString): WideString;
function WideCharPos(const S: WideString; const Ch: WideChar; const Index: Integer): Integer;  //az
function WideExtractQuotedStr(var Src: PWideChar; Quote: WideChar): WideString;
function WideLowerCase(const S: WideString): WideString;
function WideQuotedStr(const S: WideString; Quote: WideChar): WideString;
function WideStringOfChar(C: WideChar; Count: Cardinal): WideString;
function WideUpperCase(const S: WideString): WideString;

// Utilities
function AddCommas(NumberString: WideString): WideString;
function CalcuateFolderSize(FolderPath: WideString; Recurse: Boolean): Int64;
function CreateDirW(const DirName: WideString): Boolean;
function DirExistsW(const FileName: WideString): Boolean; overload;
function DirExistsW(const FileName: PWideChar): Boolean;  overload;
function DiskInDrive(C: Char): Boolean;
{$IFDEF DELPHI_5}
function ExcludeTrailingPathDelimiter(const S: string): string;
{$ENDIF}
function ExtractFileDirW(const FileName: WideString): WideString;
function ExtractFileDriveW(const FileName: WideString): WideString;
function ExtractFileExtW(const FileName: WideString): WideString;
function ExtractFileNameW(const FileName: WideString): WideString;
function ExtractRemoteComputerW(const UNCPath: WideString): WideString;
function ExpandFileNameW(const FileName: WideString): WideString;
function FileCreateW(const FileName: WideString): Integer;
function FileExistsW(const FileName: WideString): Boolean;
function ShortFileName(const FileName: WideString): WideString;
{$IFDEF DELPHI_5}
function IncludeTrailingPathDelimiter(const S: string): string;
{$ENDIF}
function IncludeTrailingBackslashW(const S: WideString): WideString;
procedure InsertW(Source: WideString; var S: WideString; Index: Integer);
function IntToStrW(Value: integer): WideString;
function IsDriveW(Drive: WideString): Boolean;
function IsFloppyW(FileFolder: WideString): boolean;
function IsFTPPath(Path: WideString): Boolean;
function IsPathDelimiterW(const S: WideString; Index: Integer): Boolean;
function IsTextTrueType(DC: HDC): Boolean; overload;
function IsTextTrueType(Canvas: TCanvas): Boolean; overload;
function IsUNCPath(const Path: WideString): Boolean;
function MessageBoxWide(Window: HWND; ACaption, AMessage: WideString; uType: integer): integer;
function NewFolderNameW(ParentFolder: WideString; SuggestedFolderName: WideString = ''): WideString;
function ShortenStringEx(DC: HDC; const S: WideString; Width: Integer; RTL: Boolean;
  EllipsisPlacement: TShortenStringEllipsis): WideString;
procedure ShowWideMessage(Window: HWND; ACaption, AMessage: WideString);
function StripExtW(AFile: WideString): WideString;
function StripRemoteComputerW(const UNCPath: WideString): WideString;
function StripTrailingBackslashW(const S: WideString; Force: Boolean = False): WideString;
function StrRetToStr(StrRet: TStrRet; APIDL: PItemIDList): WideString;
function SystemDirectory: WideString;
function TextExtentW(Text: WideString; Font: TFont): TSize; overload;
function TextExtentW(Text: WideString; Canvas: TCanvas): TSize; overload;
function TextExtentW(Text: PWideChar; Canvas: TCanvas): TSize; overload;
function TextExtentW(Text: PWideChar; DC: hDC): TSize; overload;
function TextTrueExtentsW(Text: WideString; DC: HDC): TSize;
function UniqueFileName(const AFilePath: WideString): WideString;
function UniqueDirName(const ADirPath: WideString): WideString;
function WindowsDirectory: WideString;
function ModuleFileName: WideString;
procedure WriteStringToStream(S: TStream; Caption: string);
function ReadStringFromStream(S: TStream): string;
procedure WriteWideStringToStream(S: TStream; Caption: WideString);
function ReadWideStringFromStream(S: TStream): WideString;

//From Troy's TntClasses:
function WideFileCreate(const FileName: WideString): Integer;
function WideFileOpen(const FileName: WideString; Mode: LongWord): Integer;

implementation

uses
  VirtualShellUtilities;

// Internal Helper Functions

type
  TABCArray = array of TABC;

function TextTrueExtentsW(Text: WideString; DC: HDC): TSize;
var
  ABC: TABC;
  TextMetrics: TTextMetric;
  S: string;
  i: integer;
begin
   // Get the Height at least
   GetTextExtentPoint32W(DC, PWideChar(Text), Length(Text), Result);

   GetTextMetrics(DC, TextMetrics);
   if TextMetrics.tmPitchAndFamily and TMPF_TRUETYPE <> 0 then
   begin
     Result.cx := 0;
     // Is TrueType
     if Win32Platform = VER_PLATFORM_WIN32_NT then
     begin
       for i := 1 to Length(Text) do
       begin
         GetCharABCWidthsW_VST(DC, Ord(Text[i]), Ord(Text[i]), ABC);
         Result.cx := Result.cx + ABC.abcA + integer(ABC.abcB) + ABC.abcC;
       end
     end else
     begin
       S := Text;
       for i := 1 to Length(S) do
       begin
         GetCharABCWidthsA(DC, Ord(S[i]), Ord(S[i]), ABC);
         Result.cx := Result.cx + ABC.abcA + integer(ABC.abcB) + ABC.abcC;
       end
     end;
   end
end;

function InternalTextExtentW(Text: PWideChar; DC: HDC): TSize;
var
  S: string;
begin
  if IsUnicode then
    GetTextExtentPoint32W(DC, PWideChar(Text), Length(Text), Result)
  else begin
    S := WideString( Text);
    GetTextExtentPoint32(DC, PChar(S), Length(S), Result)
  end;
end;

procedure SumFolder(FolderPath: WideString; Recurse: Boolean; var Size: Int64);
{ Returns the size of all files within the passed folder, including all         }
{ sub-folders. This is recurcive don't initialize Size to 0 in the function!    }
var
  Info: TWin32FindData;
  InfoW: TWin32FindDataW;
  FHandle: THandle;
  FolderPathA: string;
begin
  if IsUnicode then
  begin
    FHandle := FindFirstFileW_VST(PWideChar( FolderPath + '\*.*'), InfoW);
    if FHandle <> INVALID_HANDLE_VALUE then
    try
      if Recurse and (InfoW.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) then
      begin
        if (lstrcmpiW_VST(InfoW.cFileName, '.') <> 0) and (lstrcmpiW_VST(InfoW.cFileName, '..') <> 0) then
          SumFolder(FolderPath + '\' + InfoW.cFileName, Recurse, Size)
      end else
        Size := Size + InfoW.nFileSizeHigh * MAXDWORD + InfoW.nFileSizeLow;
      while FindNextFileW(FHandle, InfoW) do
      begin
        if Recurse and (InfoW.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) then
        begin
          if (lstrcmpiW_VST(InfoW.cFileName, '.') <> 0) and (lstrcmpiW_VST(InfoW.cFileName, '..') <> 0) then
           SumFolder(FolderPath + '\' + InfoW.cFileName, Recurse, Size)
        end else
         Size := Size + InfoW.nFileSizeHigh * MAXDWORD + InfoW.nFileSizeLow;
      end;
    finally
      Windows.FindClose(FHandle)
    end
  end else
  begin
    FolderPathA := FolderPath;
    FHandle := FindFirstFile(PChar( FolderPathA + '\*.*'), Info);
    if FHandle <> INVALID_HANDLE_VALUE then
    try
      if Recurse and (Info.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) then
      begin
        if (lstrcmpi(Info.cFileName, '.') <> 0) and (lstrcmpi(Info.cFileName, '..') <> 0) then
          SumFolder(FolderPathA + '\' + Info.cFileName, Recurse, Size)
      end else
        Size := Size + Info.nFileSizeHigh * MAXDWORD + Info.nFileSizeLow;
      while FindNextFile(FHandle, Info) do
      begin
        if Recurse and (Info.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY <> 0) then
        begin
          if (lstrcmpi(Info.cFileName, '.') <> 0) and (lstrcmpi(Info.cFileName, '..') <> 0) then
            SumFolder(FolderPathA + '\' + Info.cFileName, Recurse, Size)
        end else
          Size := Size + Info.nFileSizeHigh * MAXDWORD + Info.nFileSizeLow;
      end;
    finally
      Windows.FindClose(FHandle)
    end
  end
end;

// Exported Functions

function FindRootToken(const Path: WideString): PWideChar;
const
  RootToken = WideString(':\');
begin
  Result := StrPosW(PWideChar(Path), RootToken);
end;
//----------------- functions for null terminated strings --------------------------------------------------------------

function StrLenW(Str: PWideChar): Cardinal;

// returns number of characters in a string excluding the null terminator

asm
       MOV     EDX, EDI
       MOV     EDI, EAX
       MOV     ECX, 0FFFFFFFFH
       XOR     AX, AX
       REPNE   SCASW
       MOV     EAX, 0FFFFFFFEH
       SUB     EAX, ECX
       MOV     EDI, EDX

end;

//----------------------------------------------------------------------------------------------------------------------

function StrEndW(Str: PWideChar): PWideChar;

// returns a pointer to the end of a null terminated string

asm
       MOV     EDX, EDI
       MOV     EDI, EAX
       MOV     ECX, 0FFFFFFFFH
       XOR     AX, AX
       REPNE   SCASW
       LEA     EAX, [EDI - 2]
       MOV     EDI, EDX

end;

//----------------------------------------------------------------------------------------------------------------------

function StrMoveW(Dest, Source: PWideChar; Count: Cardinal): PWideChar;

// Copies the specified number of characters to the destination string and returns Dest
// also as result. Dest must have enough room to store at least Count characters.

asm
       PUSH    ESI
       PUSH    EDI
       MOV     ESI, EDX
       MOV     EDI, EAX
       MOV     EDX, ECX
       CMP     EDI, ESI
       JG      @@1
       JE      @@2
       SHR     ECX, 1
       REP     MOVSD
       MOV     ECX, EDX
       AND     ECX, 1
       REP     MOVSW
       JMP     @@2

@@1:
       LEA     ESI, [ESI + 2 * ECX - 2]
       LEA     EDI, [EDI + 2 * ECX - 2]
       STD
       AND     ECX, 1
       REP     MOVSW
       SUB     EDI, 2
       SUB     ESI, 2
       MOV     ECX, EDX
       SHR     ECX, 1
       REP     MOVSD
       CLD
@@2:
       POP EDI
       POP ESI

end;

//----------------------------------------------------------------------------------------------------------------------

function StrCopyW(Dest, Source: PWideChar): PWideChar;

// copies Source to Dest and returns Dest

asm
       PUSH    EDI
       PUSH    ESI
       MOV     ESI, EAX
       MOV     EDI, EDX
       MOV     ECX, 0FFFFFFFFH
       XOR     AX, AX
       REPNE   SCASW
       NOT     ECX
       MOV     EDI, ESI
       MOV     ESI, EDX
       MOV     EDX, ECX
       MOV     EAX, EDI
       SHR     ECX, 1
       REP     MOVSD
       MOV     ECX, EDX
       AND     ECX, 1
       REP     MOVSW
       POP     ESI
       POP     EDI

end;

//----------------------------------------------------------------------------------------------------------------------

function StrECopyW(Dest, Source: PWideChar): PWideChar;

// copies Source to Dest and returns a pointer to the null character ending the string

asm
       PUSH    EDI
       PUSH    ESI
       MOV     ESI, EAX
       MOV     EDI, EDX
       MOV     ECX, 0FFFFFFFFH
       XOR     AX, AX
       REPNE   SCASW
       NOT     ECX
       MOV     EDI, ESI
       MOV     ESI, EDX
       MOV     EDX, ECX
       SHR     ECX, 1
       REP     MOVSD
       MOV     ECX, EDX
       AND     ECX, 1
       REP     MOVSW
       LEA     EAX, [EDI - 2]
       POP     ESI
       POP     EDI

end;

//----------------------------------------------------------------------------------------------------------------------

function StrLCopyW(Dest, Source: PWideChar; MaxLen: Cardinal): PWideChar;

// copies a specified maximum number of characters from Source to Dest

asm
       PUSH    EDI
       PUSH    ESI
       PUSH    EBX
       MOV     ESI, EAX
       MOV     EDI, EDX
       MOV     EBX, ECX
       XOR     AX, AX
       TEST    ECX, ECX
       JZ      @@1
       REPNE   SCASW
       JNE     @@1
       INC     ECX
@@1:
       SUB     EBX, ECX
       MOV     EDI, ESI
       MOV     ESI, EDX
       MOV     EDX, EDI
       MOV     ECX, EBX
       SHR     ECX, 1
       REP     MOVSD
       MOV     ECX, EBX
       AND     ECX, 1
       REP     MOVSW
       STOSW
       MOV     EAX, EDX
       POP     EBX
       POP     ESI
       POP     EDI

end;

//----------------------------------------------------------------------------------------------------------------------

function StrPCopyW(Dest: PWideChar; const Source: string): PWideChar;

// copies a Pascal-style string to a null-terminated wide string

begin
  Result := StrPLCopyW(Dest, Source, Length(Source));
  Result[Length(Source)] := WideNull;
end;

//----------------------------------------------------------------------------------------------------------------------

function StrPLCopyW(Dest: PWideChar; const Source: string; MaxLen: Cardinal): PWideChar;

// copies characters from a Pascal-style string into a null-terminated wide string

asm
       PUSH    EDI
       PUSH    ESI
       MOV     EDI, EAX
       MOV     ESI, EDX
       MOV     EDX, EAX
       XOR     AX, AX
@@1:
       LODSB
       STOSW
       DEC     ECX
       JNZ     @@1
       MOV     EAX, EDX
       POP     ESI
       POP     EDI

end;

//----------------------------------------------------------------------------------------------------------------------

function StrCatW(Dest, Source: PWideChar): PWideChar;

// appends a copy of Source to the end of Dest and returns the concatenated string

begin
  StrCopyW(StrEndW(Dest), Source);
  Result := Dest;
end;

//----------------------------------------------------------------------------------------------------------------------

function StrLCatW(Dest, Source: PWideChar; MaxLen: Cardinal): PWideChar;

// appends a specified maximum number of WideCharacters to string

asm
       PUSH    EDI
       PUSH    ESI
       PUSH    EBX
       MOV     EDI, Dest
       MOV     ESI, Source
       MOV     EBX, MaxLen
       SHL     EBX, 1
       CALL    StrEndW
       MOV     ECX, EDI
       ADD     ECX, EBX
       SUB     ECX, EAX
       JBE     @@1
       MOV     EDX, ESI
       SHR     ECX, 1
       CALL    StrLCopyW
@@1:
       MOV     EAX, EDI
       POP     EBX
       POP     ESI
       POP     EDI

end;

//----------------------------------------------------------------------------------------------------------------------

const
  // data used to bring UTF-16 coded strings into correct UTF-32 order for correct comparation
  UTF16Fixup: array[0..31] of Word = (
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    $2000, $F800, $F800, $F800, $F800
  );

function StrCompW(Str1, Str2: PWideChar): Integer;

// Binary comparation of Str1 and Str2 with surrogate fix-up.
// Returns < 0 if Str1 is smaller in binary order than Str2, = 0 if both strings are
// equal and > 0 if Str1 is larger than Str2.
//
// This code is based on an idea of Markus W. Scherer (IBM).
// Note: The surrogate fix-up is necessary because some single value code points have
//       larger values than surrogates which are in UTF-32 actually larger.

var
  C1, C2: Word;
  Run1,
  Run2: PWideChar;

begin

//  Assert(True = False,  'StrCompW: I have seen this function fail while sorting a directory.  I would not use it');

  Run1 := Str1;
  Run2 := Str2;
  repeat
    C1 := Word(Run1^);
    C1 := Word(C1 + UTF16Fixup[C1 shr 11]);
    C2 := Word(Run2^);
    C2 := Word(C2 + UTF16Fixup[C2 shr 11]);

    // now C1 and C2 are in UTF-32-compatible order
    Result := Integer(C1) - Integer(C2);
    if(Result <> 0) or (C1 = 0) or (C2 = 0) then
      Break;
    Inc(Run1);
    Inc(Run2);
  until False;

  // If the strings have different lengths but the comparation returned equity so far
  // then adjust the result so that the longer string is marked as the larger one.
  if Result = 0 then
    Result := (Run1 - Str1) - (Run2 - Str2);
end;

//----------------------------------------------------------------------------------------------------------------------

function StrICompW(Str1, Str2: PWideChar): Integer;

// Insensitive case comparison
var
  S1, S2: string;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := lstrcmpiW_VST(Str1, Str2)
  else begin
    S1 := Str1;
    S2 := Str2;
    Result := lstrcmpi(PChar(S1), PChar(S2))
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function StrLCompW(Str1, Str2: PWideChar; MaxLen: Cardinal): Integer;

// compares strings up to MaxLen code points
// see also StrCompW

var
  C1, C2: Word;

begin
  if MaxLen > 0 then
  begin
    repeat
      C1 := Word(Str1^);
      C1 := Word(C1 + UTF16Fixup[C1 shr 11]);
      C2 := Word(Str2^);
      C2 := Word(C2 + UTF16Fixup[C2 shr 11]);

      // now C1 and C2 are in UTF-32-compatible order
      // TODO: surrogates take up 2 words and are counted twice here, count them only once
      Result := Integer(C1) - Integer(C2);
      Dec(MaxLen);
      if(Result <> 0) or (C1 = 0) or (C2 = 0) or (MaxLen = 0) then
        Break;
      Inc(Str1);
      Inc(Str2);
    until False;
  end
  else
    Result := 0;
end;

function StrLICompW(Str1, Str2: PWideChar; MaxLen: Cardinal): Integer;
// Insensitive case comparison
var
  S1, S2: string;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := lstrcmpiW_VST(Str1, Str2)
  else begin
    S1 := Str1;
    S2 := Str2;
    Result := lstrcmpi(PChar(S1), PChar(S2))
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function StrLowerW(Str: PWideChar): PWideChar;

//  Returns the string in Str converted to lower case

var
  S: string;
  WS: WideString;

begin
  Result := Str;
  if IsUnicode then
    CharLowerBuffW_VST(Str, StrLenW(Str))
  else begin
    S := Str;
    CharLowerBuff(PChar(S), Length(S));
    WS := S;
    { WS is a string index from 1, Result is PWideChar index from 0 }
    Move(WS[1], Result[0], Length(WS));
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function StrNScanW(S1, S2: PWideChar): Integer;

// Determines where (in S1) the first time one of the characters of S2 appear.
// The result is the length of a string part of S1 where none of the characters of
// S2 do appear (not counting the trailing #0 and starting with position 0 in S1).

var
  Run: PWideChar;

begin
  Result := -1;
  if (S1 <> nil) and (S2 <> nil) then
  begin
    Run := S1;
    while (Run^ <> #0) do
    begin
      if StrScanW(S2, Run^) <> nil then
        Break;
      Inc(Run);
    end;
    Result := Run - S1;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function StrRNScanW(S1, S2: PWideChar): Integer;

// This function does the same as StrRNScanW but uses S1 in reverse order. This
// means S1 points to the last character of a string, is traversed reversely
// and terminates with a starting #0. This is useful for parsing strings stored
// in reversed macro buffers etc.

var
  Run: PWideChar;

begin
  Result := -1;
  if (S1 <> nil) and (S2 <> nil) then
  begin
    Run := S1;
    while (Run^ <> #0) do
    begin
      if StrScanW(S2, Run^) <> nil then
        Break;
      Dec(Run);
    end;
    Result := S1 - Run;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function StrScanW(Str: PWideChar; Chr: WideChar): PWideChar;

// returns a pointer to first occurrence of a specified character in a string

asm
        PUSH    EDI
        PUSH    EAX
        MOV     EDI, Str
        MOV     ECX, 0FFFFFFFFH
        XOR     AX, AX
        REPNE   SCASW
        NOT     ECX
        POP     EDI
        MOV     AX, Chr
        REPNE   SCASW
        MOV     EAX, 0
        JNE     @@1
        MOV     EAX, EDI
        SUB     EAX, 2
@@1:
        POP     EDI

end;

//----------------------------------------------------------------------------------------------------------------------

function StrScanW(Str: PWideChar; Chr: WideChar; StrLen: Cardinal): PWideChar;

// Returns a pointer to first occurrence of a specified character in a string
// or nil if not found.
// Note: this is just a binary search for the specified character and there's no
//       check for a terminating null. Instead at most StrLen characters are
//       searched. This makes this function extremly fast.
//
// on enter EAX contains Str, EDX contains Chr and ECX StrLen
// on exit EAX contains result pointer or nil

asm
       TEST    EAX, EAX
       JZ      @@Exit        // get out if the string is nil or StrLen is 0
       JCXZ    @@Exit
@@Loop:
       CMP     [EAX], DX     // this unrolled loop is actually faster on modern processors
       JE      @@Exit        // than REP SCASW
       ADD     EAX, 2
       DEC     ECX
       JNZ     @@Loop
       XOR     EAX, EAX

@@Exit:
end;

//----------------------------------------------------------------------------------------------------------------------

function StrRScanW(Str: PWideChar; Chr: WideChar): PWideChar;

// returns a pointer to the last occurance of Chr in Str

asm
       PUSH    EDI
       MOV     EDI, Str
       MOV     ECX, 0FFFFFFFFH
       XOR     AX, AX
       REPNE   SCASW
       NOT     ECX
       STD
       SUB     EDI, 2
       MOV     AX, Chr
       REPNE   SCASW
       MOV     EAX, 0
       JNE     @@1
       MOV     EAX, EDI
       ADD     EAX, 2
@@1:
       CLD
       POP     EDI

end;

//----------------------------------------------------------------------------------------------------------------------

function StrPosW(Str, SubStr: PWideChar): PWideChar;

// returns a pointer to the first occurance of SubStr in Str

asm
       PUSH    EDI
       PUSH    ESI
       PUSH    EBX
       OR      EAX, EAX
       JZ      @@2
       OR      EDX, EDX
       JZ      @@2
       MOV     EBX, EAX
       MOV     EDI, EDX
       XOR     AX, AX
       MOV     ECX, 0FFFFFFFFH
       REPNE   SCASW
       NOT     ECX
       DEC     ECX
       JZ      @@2
       MOV     ESI, ECX
       MOV     EDI, EBX
       MOV     ECX, 0FFFFFFFFH
       REPNE   SCASW
       NOT     ECX
       SUB     ECX, ESI
       JBE     @@2
       MOV     EDI, EBX
       LEA     EBX, [ESI - 1]
@@1:
       MOV     ESI, EDX
       LODSW
       REPNE   SCASW
       JNE     @@2
       MOV     EAX, ECX
       PUSH    EDI
       MOV     ECX, EBX
       REPE    CMPSW
       POP     EDI
       MOV     ECX, EAX
       JNE     @@1
       LEA     EAX, [EDI - 2]
       JMP     @@3

@@2:
       XOR     EAX, EAX
@@3:
       POP     EBX
       POP     ESI
       POP     EDI
end;

//----------------------------------------------------------------------------------------------------------------------

function StrAllocW(Size: Cardinal): PWideChar;

// Allocates a buffer for a null-terminated wide string and returns a pointer
// to the first character of the string.

begin
  Size := SizeOf(WideChar) * Size + SizeOf(Cardinal);
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
  Cardinal(Pointer(Result)^) := Size;
  Inc(Result, SizeOf(Cardinal) div SizeOf(WideChar));
end;

//----------------------------------------------------------------------------------------------------------------------

function StrBufSizeW(Str: PWideChar): Cardinal;

// Returns max number of wide characters that can be stored in a buffer
// allocated by StrAllocW.

begin
  Dec(Str, SizeOf(Cardinal) div SizeOf(WideChar));
  Result := (Cardinal(Pointer(Str)^) - SizeOf(Cardinal)) div 2;
end;

//----------------------------------------------------------------------------------------------------------------------

function StrNewW(Str: PWideChar): PWideChar;

// Duplicates the given string (if not nil) and returns the address of the new string.

var
  Size: Cardinal;

begin
  if Str = nil then
    Result := nil
  else
  begin
    Size := StrLenW(Str) + 1;
    Result := StrMoveW(StrAllocW(Size), Str, Size);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure StrDisposeW(Str: PWideChar);

// releases a string allocated with StrNew

begin
  if Str <> nil then
  begin
    Dec(Str, SizeOf(Cardinal) div SizeOf(WideChar));
    FreeMem(Str, Cardinal(Pointer(Str)^));
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure StrSwapByteOrder(Str: PWideChar);

// exchanges in each character of the given string the low order and high order
// byte to go from LSB to MSB and vice versa.
// EAX contains address of string

asm
       PUSH    ESI
       PUSH    EDI
       MOV     ESI, EAX
       MOV     EDI, ESI
       XOR     EAX, EAX // clear high order byte to be able to use 32bit operand below
@@1:
       LODSW
       OR      EAX, EAX
       JZ      @@2
       XCHG    AL, AH
       STOSW
       JMP     @@1


@@2:
       POP     EDI
       POP     ESI
end;

//----------------------------------------------------------------------------------------------------------------------

function StrUpperW(Str: PWideChar): PWideChar;

//  Returns the string in Str converted to Upper case

var
  S: string;
  WS: WideString;

begin
  Result := Str;
  if IsUnicode then
    CharUpperBuffW(Str, StrLenW(Str))
  else begin
    S := Str;
    CharUpperBuff(PChar(S), Length(S));
    WS := S;
    { WS is a string index from 1, Result is PWideChar index from 0 }
    Move(WS[1], Result[0], Length(WS));
  end;
end;


//----------------------------------------------------------------------------------------------------------------------

function WideAdjustLineBreaks(const S: WideString): WideString;

var
  Source,
  SourceEnd,
  Dest: PWideChar;
  Extra: Integer;

begin
  Source := Pointer(S);
  SourceEnd := Source + Length(S);
  Extra := 0;
  while Source < SourceEnd do
  begin
    case Source^ of
      WideLF:
        Inc(Extra);
      WideCR:
        if Source[1] = WideLineFeed then
          Inc(Source)
        else
          Inc(Extra);
    end;
    Inc(Source);
  end;

  Source := Pointer(S);
  SetString(Result, nil, SourceEnd - Source + Extra);
  Dest := Pointer(Result);
  while Source < SourceEnd do
  begin
    case Source^ of
      WideLineFeed:
        begin
          Dest^ := WideLineSeparator;
          Inc(Dest);
          Inc(Source);
        end;
      WideCarriageReturn:
        begin
          Dest^ := WideLineSeparator;
          Inc(Dest);
          Inc(Source);
          if Source^ = WideLineFeed then
            Inc(Source);
        end;
    else
      Dest^ := Source^;
      Inc(Dest);
      Inc(Source);
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function WideQuotedStr(const S: WideString; Quote: WideChar): WideString;

// works like QuotedStr from SysUtils.pas but can insert any quotation character

var
  P, Src,
  Dest: PWideChar;
  AddCount: Integer;

begin
  AddCount := 0;
  P := StrScanW(PWideChar(S), Quote);
  while (P <> nil) do
  begin
    Inc(P);
    Inc(AddCount);
    P := StrScanW(P, Quote);
  end;

  if AddCount = 0 then
    Result := Quote + S + Quote
  else
  begin
    SetLength(Result, Length(S) + AddCount + 2);
    Dest := PWideChar(Result);
    Dest^ := Quote;
    Inc(Dest);
    Src := PWideChar(S);
    P := StrScanW(Src, Quote);
    repeat
      Inc(P);
      Move(Src^, Dest^, 2 * (P - Src));
      Inc(Dest, P - Src);
      Dest^ := Quote;
      Inc(Dest);
      Src := P;
      P := StrScanW(Src, Quote);
    until P = nil;
    P := StrEndW(Src);
    Move(Src^, Dest^, 2 * (P - Src));
    Inc(Dest, P - Src);
    Dest^ := Quote;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function WideExtractQuotedStr(var Src: PWideChar; Quote: WideChar): WideString;

// extracts a string enclosed in quote characters given by Quote

var
  P, Dest: PWideChar;
  DropCount: Integer;

begin
  Result := '';
  if (Src = nil) or (Src^ <> Quote) then
    Exit;

  Inc(Src);
  DropCount := 1;
  P := Src;
  Src := StrScanW(Src, Quote);

  while Src <> nil do   // count adjacent pairs of quote chars
  begin
    Inc(Src);
    if Src^ <> Quote then
      Break;
    Inc(Src);
    Inc(DropCount);
    Src := StrScanW(Src, Quote);
  end;

  if Src = nil then
    Src := StrEndW(P);
  if (Src - P) <= 1 then
    Exit;

  if DropCount = 1 then
    SetString(Result, P, Src - P - 1)
  else
  begin
    SetLength(Result, Src - P - DropCount);
    Dest := PWideChar(Result);
    Src := StrScanW(P, Quote);
    while Src <> nil do
    begin
      Inc(Src);
      if Src^ <> Quote then
        Break;
      Move(P^, Dest^, 2 * (Src - P));
      Inc(Dest, Src - P);
      Inc(Src);
      P := Src;
      Src := StrScanW(Src, Quote);
    end;
    if Src = nil then
      Src := StrEndW(P);
    Move(P^, Dest^, 2 * (Src - P - 1));
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function WideLowerCase(const S: WideString): WideString;
var
  Str: string;
begin
  if IsUnicode then
  begin
    Result := S;
    CharLowerBuffW_VST(PWideChar(Result), Length(Result))
  end else
  begin
    Str := S;
    CharLowerBuff(PChar(Str), Length(Str));
    Result := Str
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function WideStringOfChar(C: WideChar; Count: Cardinal): WideString;

// returns a string of Count characters filled with C

var
  I: Integer;

begin
  SetLength(Result, Count);
  for I := 1 to Count do
    Result[I] := C;
end;

//----------------------------------------------------------------------------------------------------------------------

function WideUpperCase(const S: WideString): WideString;
var
  Str: string;
begin
  if IsUnicode then
  begin
    Result := S;
    CharUpperBuffW(PWideChar(Result), Length(Result))
  end else
  begin
    Str := S;
    CharUpperBuff(PChar(Str), Length(Str));
    Result := Str
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function WideCharPos(const S: WideString; const Ch: WideChar; const Index: Integer): Integer;

// returns the index of character Ch in S, starts searching at index Index
// Note: This is a quick memory search. No attempt is made to interpret either
// the given charcter nor the string (ligatures, modifiers, surrogates etc.)
// Code from Azret Botash.

asm
       TEST    EAX,EAX        // make sure we are not null
       JZ      @@StrIsNil
       DEC     ECX            // make index zero based
       JL      @@IdxIsSmall
       PUSH    EBX
       PUSH    EDI
       MOV     EDI, EAX       // EDI := S
       XOR     EAX, EAX
       MOV     AX, DX         // AX := Ch
       MOV     EDX, [EDI - 4] // EDX := Length(S) * 2
       SHR     EDX, 1         // EDX := EDX div 2
       MOV     EBX, EDX       // save the length to calc. result
       SUB     EDX, ECX       // EDX = EDX - Index = # of chars to scan
       JLE     @@IdxIsBig
       SHL     ECX, 1         // two bytes per char
       ADD     EDI, ECX       // point to index'th char
       MOV     ECX, EDX       // loop counter
       REPNE   SCASW
       JNE     @@NoMatch
       MOV     EAX, EBX       // result := saved length -
       SUB     EAX, ECX       // loop counter value
       POP     EDI
       POP     EBX
       RET

@@IdxIsBig:
@@NoMatch:
       XOR     EAX,EAX
       POP     EDI
       POP     EBX
       RET

@@IdxIsSmall:
       XOR     EAX, EAX
@@StrIsNil:

end;

//----------------------------------------------------------------------------------------------------------------------

function AddCommas(NumberString: WideString): WideString;
var
//  i: integer;
  BufferA: array[0..128] of Char;
  BufferW: array[0..128] of WideChar;
begin
  // Make the number format based on the local not the US 3 digit comma format
  if Assigned(GetNumberFormatW_VST) then
  begin
    GetNumberFormatW_VST(LOCALE_USER_DEFAULT, 0, PWideChar(NumberString), nil, BufferW, SizeOf(BufferW));
    Result := BufferW;
  end
  else begin
    GetNumberFormatA(LOCALE_USER_DEFAULT, 0, PChar(string(NumberString)), nil, BufferA, SizeOf(BufferA));
    Result := BufferA
  end;

  { Trimming white space in Unicode is tough don't pass any }
 { i := Length(NumberString) mod 3;
  if i = 0 then
    i := 3;
  while i < Length(NumberString) do
  begin
    InsertW(ThousandSeparator, NumberString, i);
    Inc(i, 4);
  end;
  Result := NumberString   }
end;

//----------------------------------------------------------------------------------------------------------------------

function CalcuateFolderSize(FolderPath: WideString; Recurse: Boolean): Int64;

// Recursivly gets the size of the folder and subfolders
var
  S: string;
  FreeSpaceAvailable, TotalSpace: Int64;
  SectorsPerCluster,
  BytesPerSector,
  FreeClusters,
  TotalClusters: DWORD;
begin
  Result := 0;
  if Recurse and IsDriveW(FolderPath) then
  begin
    if IsUnicode and Assigned(GetDiskFreeSpaceExW_VST) then
    begin
      if GetDiskFreeSpaceExW_VST(PWideChar(FolderPath), FreeSpaceAvailable, TotalSpace, nil) then
      Result := TotalSpace - FreeSpaceAvailable
    end else
    if not IsWin95_SR1 and Assigned(GetDiskFreeSpaceExA_VST) then
    begin
      S := FolderPath;
      if GetDiskFreeSpaceExA_VST(PChar(S), FreeSpaceAvailable, TotalSpace, nil) then
        Result := TotalSpace - FreeSpaceAvailable;
    end else
    begin
      GetDiskFreeSpaceA(PChar( S), SectorsPerCluster, BytesPerSector, FreeClusters,
        TotalClusters);
      Result := SectorsPerCluster * BytesPerSector * TotalClusters
    end;
  end else
    SumFolder(FolderPath, Recurse, Result);
end;

//----------------------------------------------------------------------------------------------------------------------

function CreateDirW(const DirName: WideString): Boolean;
var
  S: string;
  PIDL: PItemIDList;
begin
  if IsUnicode then
    Result := CreateDirectoryW_VST(PWideChar( DirName), nil)
  else begin
    S := DirName;
    Result := CreateDirectory(PChar( S), nil);
  end;
  if Result then
  begin
    PIDL := PathToPIDL(DirName);
    SHChangeNotify(SHCNE_MKDIR, SHCNF_IDLIST, PIDL, PIDL);
    PIDLMgr.FreePIDL(PIDL)
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function DirExistsW(const FileName: WideString): Boolean;
begin
  Result := DirExistsW(PWideChar(FileName));
end;

//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------

function DirExistsW(const FileName: PWideChar): Boolean;
var
  ErrorCode: LongWord;
  S: string;
begin
  if FileName <> '' then
  begin
    if (Win32Platform = VER_PLATFORM_WIN32_NT) then
      ErrorCode := GetFileAttributesW_VST(FileName)
    else begin
      S := FileName;
      ErrorCode := GetFileAttributes(PChar(S))
    end;
    Result := (Integer(ErrorCode) <> -1) and (FILE_ATTRIBUTE_DIRECTORY and ErrorCode <> 0);
  end else
    Result := False
end;

//----------------------------------------------------------------------------------------------------------------------

function DiskInDrive(C: Char): Boolean;
var
  OldErrorMode: Integer;
begin
  C := UpCase(C);
  if C in ['A'..'Z'] then
  begin
    OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
    Result :=  DiskFree(Ord(C) - Ord('A') + 1) > -1;
    SetErrorMode(OldErrorMode);
  end else
    Result := False
end;
{$IFDEF DELPHI_5}
function ExcludeTrailingPathDelimiter(const S: string): string;
begin
  Result := ExcludeTrailingBackSlash(S)
end;
{$ENDIF}

//----------------------------------------------------------------------------------------------------------------------

function ExtractFileDirW(const FileName: WideString): WideString;
var
  WP: PWideChar;
begin
  Result := '';
  if (Length(FileName) < 3) and (Length(FileName) > 0) then
  begin
    if (((FileName[1] >= 'A') and (FileName[1] >= 'Z')) or
    ((FileName[1] >= 'a') and (FileName[1] >= 'z'))) then
    begin
      Result := WideString(FileName[1]) + ':\';
    end
  end else
  begin
    WP := FindRootToken(FileName);
    if Assigned(WP) then
    begin
      { Find the last '\' }
      WP := StrRScanW(PWideChar( FileName), WideChar( '\'));
      if Assigned(WP) then
      begin
        { The stripped file name leaves just the root directory }
        if (Length(FileName) > 1) and ( (WP - 1)^ = ':') then
          WP := WP + 1;  // Tack on the '\'
        SetLength(Result, WP - @FileName[1]);
        StrMoveW(PWideChar(Result), PWideChar(FileName), WP - @FileName[1]);
      end
    end
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function ExtractFileDriveW(const FileName: WideString): WideString;
var
  WP: PWideChar;
begin
  Result := '';
  WP := FindRootToken(FileName);
  if Assigned(WP) then
  begin
    Inc(WP, 1);
    SetLength(Result, WP - @FileName[1]);
    StrMoveW(PWideChar(Result), PWideChar(FileName), WP - @FileName[1]);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function ExtractFileExtW(const FileName: WideString): WideString;

// Returns the extension of the file

var
  WP: PWideChar;
begin
  Result := '';
  WP := StrRScanW(PWideChar(FileName), WideChar('.'));
  if Assigned(WP) then
    Result := WP;
end;
//----------------------------------------------------------------------------------------------------------------------

function ExtractRemoteComputerW(const UNCPath: WideString): WideString;
var
  Head: PWideChar;
begin
  Result := '';
  if IsUNCPath(UNCPath) then
  begin
    Result := UNCPath;
    Head := @Result[1];
    Head := Head + 2;    // Skip past the '\\'
    Head := StrScanW(Head, WideChar('\'));
    if Assigned(Head) then
      Head^ := WideChar(#0);
    SetLength(Result, StrLenW(PWideChar(Result)));
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function ExtractFileNameW(const FileName: WideString): WideString;

// Returns the file name of the path
// WARNING MAKES NO ASSUMPTIONS ABOUT IF IT HAS JUST STRIPPED OFF A FILE OR
// A FOLDER!!!!!!

var
  WP: PWideChar;
begin
  Result := '';
  if Length(FileName) > 3 then
  begin
    WP := StrRScanW(PWideChar(FileName), WideChar('\'));
    if Assigned(WP) then
      Result := WP + 1;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function ExpandFileNameW(const FileName: WideString): WideString;
var
  Name: PWideChar;
  Buffer: array[0..MAX_PATH - 1] of WideChar;
begin
  if IsUnicode then
  begin
    if GetFullPathNameW_VST(PWideChar(FileName), Length(Buffer), @Buffer[0], Name) > 0 then
    begin
      SetLength(Result, StrLenW(Buffer));
      Move(Buffer, Result[1], StrLenW(Buffer)*2);
    end;
  end else
    Result := ExpandFileName(FileName);  // Use the ANSI version in the VCL
end;

//----------------------------------------------------------------------------------------------------------------------

function FileCreateW(const FileName: WideString): Integer;
var
  s: string;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := Integer(CreateFileW_VST(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE,
      0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0))
  else begin
    s := FileName;
    Result := Integer(CreateFile(PChar(s), GENERIC_READ or GENERIC_WRITE,
      0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0))
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function FileExistsW(const FileName: WideString): Boolean;
var
  Handle: THandle;
  FindData: TWin32FindData;
  FindDataW: TWin32FindDataW;
  FileNameA: string;
begin
  Result := True;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Handle := FindFirstFileW_VST(PWideChar(FileName), FindDataW)
  else begin
    FileNameA := FileName;
    Handle := FindFirstFile(PChar(FileNameA), FindData)
  end;
  if Handle <> INVALID_HANDLE_VALUE then
    Windows.FindClose(Handle)
  else
    Result := False;
end;
{$IFDEF DELPHI_5}
function IncludeTrailingPathDelimiter(const S: string): string;
begin
  Result := IncludeTrailingBackslash(S)
end;
{$ENDIF}

function ShortFileName(const FileName: WideString): WideString;
var
  S: string;
  BufferA: array[0..MAX_PATH] of char;
  BufferW: array[0..MAX_PATH] of WideChar;
begin
  if IsUnicode then
  begin
    if GetShortPathNameW(PWideChar(FileName), BufferW, SizeOf(BufferW)) > 0 then
      Result := BufferW
  end else
  begin
    S := FileName;
    if GetShortPathNameA(PChar(S), BufferA, SizeOf(BufferA)) > 0 then
      Result := BufferA
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function IncludeTrailingBackslashW(const S: WideString): WideString;
begin
  Result := S;
  if not IsPathDelimiterW(Result, Length(Result)) then Result := Result + '\';
end;

//----------------------------------------------------------------------------------------------------------------------

procedure InsertW(Source: WideString; var S: WideString; Index: Integer);
{ It appears there is a WideString Insert in the VCL already but since mine     }
{ looks better and is simpler and I spent my time I will use mine <g>           }
{  _WStrInsert in System through compiler magic.                                }
var
  OriginalLen: integer;
begin
  if (Index < Length(S) + 1) and (Index > - 1)  then
  begin
    OriginalLen := Length(S);
    SetLength(S, Length(Source) + Length(S));
    { We are correct up to Index }
    { Slide to end of new string leaving space for insert }
    Move(S[Index + 1], S[Index + 1 + Length(Source)], (OriginalLen - Index) * 2);
    Move(Source[1], S[Index + 1], Length(Source) * 2);
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function IntToStrW(Value: integer): WideString;
{ Need to find a way to do this in Unicode. }
begin
    Result := IntToStr(Value);
end;

//----------------------------------------------------------------------------------------------------------------------
function IsDriveW(Drive: WideString): Boolean;
begin
  if Length(Drive) = 3 then
    Result := (LowerCase(Drive[1]) >= 'a') and (LowerCase(Drive[1]) <= 'z') and (Drive[2] = ':') and (Drive[3] = '\')
  else
  if Length(Drive) = 2 then
    Result := (LowerCase(Drive[1]) >= 'a') and (LowerCase(Drive[1]) <= 'z') and (Drive[2] = ':')
  else
    Result := False
end;
//----------------------------------------------------------------------------------------------------------------------

function IsFloppyW(FileFolder: WideString): boolean;
begin
  if Length(FileFolder) > 0 then
    Result := IsDriveW(FileFolder) and (Char(FileFolder[1]) in ['A', 'a', 'B', 'b'])
  else
    Result := False
end;

function IsFTPPath(Path: WideString): Boolean;
begin
  if Length(Path) > 3 then
  begin
    Path := UpperCase(Path);
    Result := (Path[1] = 'F') and (Path[2] = 'T') and (Path[3] = 'P')
  end else
    Result := False
end;

//----------------------------------------------------------------------------------------------------------------------

function IsPathDelimiterW(const S: WideString; Index: Integer): Boolean;
begin
  Result := (Index > 0) and (Index <= Length(S)) and (S[Index] = '\');
end;
//----------------------------------------------------------------------------------------------------------------------

function IsTextTrueType(DC: HDC): Boolean;
var
    TextMetrics: TTextMetric;
begin
   GetTextMetrics(DC, TextMetrics);
   Result := TextMetrics.tmPitchAndFamily and TMPF_TRUETYPE <>  0
end;
//----------------------------------------------------------------------------------------------------------------------

function IsTextTrueType(Canvas: TCanvas): Boolean;
begin
  Result := IsTextTrueType(Canvas.Handle);
end;
//----------------------------------------------------------------------------------------------------------------------

function IsUNCPath(const Path: WideString): Boolean;
begin
  Result :=  ((Path[1] = '\') and (Path[2] = '\')) and (DirExistsW(Path) or FileExistsW(Path))
end;

//----------------------------------------------------------------------------------------------------------------------
function MessageBoxWide(Window: HWND; ACaption, AMessage: WideString; uType: integer): integer;
var
  TextA, CaptionA: string;
begin
  if IsUnicode then
    Result := MessageBoxW(Window, PWideChar( AMessage), PWideChar( ACaption), uType)
  else begin
    TextA := AMessage;
    CaptionA := ACaption;
    Result := MessageBoxA(Window, PChar( TextA), PChar( CaptionA), uType)
  end
end;

//----------------------------------------------------------------------------------------------------------------------
function NewFolderNameW(ParentFolder: WideString; SuggestedFolderName: WideString = ''): WideString;
var
  i: integer;
  TempFoldername: String;
begin
  ParentFolder := StripTrailingBackslashW(ParentFolder, True); // Strip even if a root folder
  i := 1;
  if SuggestedFolderName = '' then
    Begin
      Result := ParentFolder + '\' + STR_NEWFOLDER;
      TempFoldername := STR_NEWFOLDER;
    end
  else
    Begin
      Result := ParentFolder + '\' + SuggestedFolderName;
      Tempfoldername := SuggestedFolderName;
    End;
  while DirExistsW(Result) and (i <= 20) do
  begin
    Result := ParentFolder + '\' + Tempfoldername + ' (' + IntToStr(i) + ')';
    Inc(i);
  end;
  if i > 20 then
    Result := '';
end;

function ShortenStringEx(DC: HDC; const S: WideString; Width: Integer; RTL: Boolean;
  EllipsisPlacement: TShortenStringEllipsis): WideString;
// Shortens the passed string and inserts ellipsis "..." in the requested place.
// This is not a fast function but it is clear how it works.  Also the RTL implmentation
// is still being understood.
var
  Len: Integer;
  EllipsisWidth: Integer;
  TargetString: WideString;
  Tail, Head, Middle: PWideChar;
  L, ResultW: integer;
begin
  Len := Length(S);
  if (Len = 0) or (Width <= 0) then
    Result := ''
  else begin
    // Determine width of triple point using the current DC settings
    TargetString := '...';
    EllipsisWidth := TextExtentW(PWideChar(TargetString), DC).cx;

    if Width <= EllipsisWidth then
      Result := ''
    else begin
      TargetString := S;
      Head := PWideChar(TargetString);
      Tail := Head;
      Inc(Tail, StrLenW(PWideChar(TargetString)));
      case EllipsisPlacement of
        sseEnd:
          begin
            L := EllipsisWidth + TextExtentW(PWideChar(TargetString), DC).cx;
            while (L > Width) do
            begin
              Dec(Tail);
              Tail^ := WideNull;
              L := EllipsisWidth + TextExtentW(PWideChar(TargetString), DC).cx;
            end;
            Result := PWideChar(TargetString) + '...';
          end;
        sseFront:
          begin
            L := EllipsisWidth + TextExtentW(PWideChar(TargetString), DC).cx;
            while (L > Width) do
            begin
              Inc(Head);
              L := EllipsisWidth + TextExtentW(PWideChar(Head), DC).cx;
            end;
            Result := '...' + PWideChar(Head);
          end;
        sseMiddle:
          begin
            L := EllipsisWidth + TextExtentW(PWideChar(TargetString), DC).cx;
            while (L > Width div 2 - EllipsisWidth div 2) do
            begin
              Dec(Tail);
              Tail^ := WideNull;
              L := TextExtentW(PWideChar(TargetString), DC).cx;
            end;
            Result := PWideChar(TargetString) + '...';
            ResultW := TextExtentW(PWideChar(Result), DC).cx;

            TargetString := S;
            Head := PWideChar(TargetString);
            Middle := Head;
            Inc(Middle, StrLenW(PWideChar(Result)) - 3); // - 3 for ellipsis letters
            Tail := Head;
            Inc(Tail, StrLenW(PWideChar(TargetString)));
            Head := Tail - 1;

            L := ResultW + TextExtentW(Head, DC).cx;
            while (L < Width) and (Head >= Middle) do
            begin
              Dec(Head);
              L := ResultW + TextExtentW(PWideChar(Head), DC).cx;
            end;
            Inc(Head);

            Result := Result + Head;
          end;
        sseFilePathMiddle:
          begin
            Head := Tail - 1;
            L := EllipsisWidth + TextExtentW(Head, DC).cx;
            while (Head^ <> '\') and (Head <> @TargetString[1]) and (L < Width) do
            begin
              Dec(Head);
              L := EllipsisWidth + TextExtentW(Head, DC).cx;
            end;
            if Head^ <> '\' then
              Inc(Head);
            Result := '...' + Head;

            ResultW := TextExtentW(PWideChar(Result), DC).cx;

            Head^ := WideNull;
            SetLength(TargetString, StrLenW(PWideChar(TargetString)));

            Head := PWideChar(TargetString);
            Tail := Head;
            Inc(Tail, StrLenW(Head));

            L := ResultW + TextExtentW(PWideChar(TargetString), DC).cx;
            while (L > Width) and (Tail > @TargetString[1]) do
            begin
              Dec(Tail);
              Tail^ := WideNull;
              L := ResultW + TextExtentW(PWideChar(TargetString), DC).cx;
            end;

            Result := Head + Result;
          end;
      end;

      // Windows 2000 automatically switches the order in the string. For every other system we have to take care.
 {     if IsWin2000 or not RTL then
        Result := Copy(S, 1, N - 1) + '...'
      else
        Result := '...' + Copy(S, 1, N - 1);       }
    end;
  end;
end;

procedure ShowWideMessage(Window: HWND; ACaption, AMessage: WideString);
var
  TextA, CaptionA: string;
begin
  if IsUnicode then
    MessageBoxW(Window, PWideChar( AMessage), PWideChar( ACaption), MB_ICONEXCLAMATION or MB_OK)
  else begin
    TextA := AMessage;
    CaptionA := ACaption;
    MessageBoxA(Window, PChar( TextA), PChar( CaptionA), MB_ICONEXCLAMATION or MB_OK)
  end          
end;

//----------------------------------------------------------------------------------------------------------------------
function StripExtW(AFile: WideString): WideString;

{ Strips the extenstion off a file name }

var
  i: integer;
  Done: Boolean;
begin
  i := Length(AFile);
  Done := False;
  Result := AFile;
  while (i > 0) and not Done do
  begin
    if AFile[i] = '.' then
    begin
      Done := True;
      SetLength(Result, i - 1);
    end;
    Dec(i);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function StripRemoteComputerW(const UNCPath: WideString): WideString;
  // Strips the \\RemoteComputer\ part of an UNC path
var
  Head: PWideChar;
begin
  Result := '';
  if IsUNCPath(UNCPath) then
  begin
    Result := '';
    if IsUNCPath(UNCPath) then
    begin
      Result := UNCPath;
      Head := @Result[1];
      Head := Head + 2;    // Skip past the '\\'
      Head := StrScanW(Head, WideChar('\'));
      if Assigned(Head) then
      begin
        Head := Head + 1;
        Move(Head[0], Result[1], (StrLenW(Head) + 1) * 2);
      end;
      SetLength(Result, StrLenW(PWideChar(Result)));
    end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function StripTrailingBackslashW(const S: WideString; Force: Boolean = False): WideString;
begin
  Result := S;
  if Result <> '' then
  begin
    // Works with FilePaths and FTP Paths
    if Result[ Length(Result)] in [WideChar('/'), WideChar('\')] then
      if not IsDriveW(Result) or Force then // Don't strip off if is a root drive
        SetLength(Result, Length(Result) - 1);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function StrRetToStr(StrRet: TStrRet; APIDL: PItemIDList): WideString;
{ Extracts the string from the StrRet structure.                                }
var
  P: PChar;
//  S: string;
begin
  case StrRet.uType of
    STRRET_CSTR:
      begin
        SetString(Result, StrRet.cStr, lStrLen(StrRet.cStr));
    //    Result := S
      end;
    STRRET_OFFSET:
      begin
        if Assigned(APIDL) then
        begin
          {$R-}
          P := PChar(@(APIDL).mkid.abID[StrRet.uOffset - SizeOf(APIDL.mkid.cb)]);
          {$R+}
          SetString(Result, P, StrLen(P));
       //   Result := S;
        end else
          Result := '';
      end;
    STRRET_WSTR:
    begin
      Result := StrRet.pOleStr;
      if Assigned(StrRet.pOleStr) then
        PIDLMgr.FreeOLEStr(StrRet.pOLEStr);
     end;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function SystemDirectory: WideString;
var
  Len: integer;
  S: string;
begin
  Result := '';
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Len := GetSystemDirectoryW_VST(PWideChar(Result), 0)
  else
    Len := GetSystemDirectoryA(PChar(S), 0);
  if Len > 0 then
  begin
    if Win32Platform = VER_PLATFORM_WIN32_NT then
    begin
      SetLength(Result, Len - 1);
      GetSystemDirectoryW_VST(PWideChar(Result), Len);
    end else
    begin
      SetLength(S, Len - 1);
      GetSystemDirectoryA(PChar(S), Len);
      Result := S
    end
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function TextExtentW(Text: WideString; Font: TFont): TSize;
var
  Canvas: TCanvas;
begin
  FillChar(Result, SizeOf(Result), #0);
  if Text <> '' then
  begin
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := GetDC(0);
      Canvas.Lock;
      Canvas.Font.Assign(Font);
      Result := InternalTextExtentW(PWideChar(Text), Canvas.Handle);
    finally
      if Assigned(Canvas) and (Canvas.Handle <> 0) then
        ReleaseDC(0, Canvas.Handle);
      Canvas.Unlock;
      Canvas.Free
    end
  end
end;

//----------------------------------------------------------------------------------------------------------------------

function TextExtentW(Text: WideString; Canvas: TCanvas): TSize;
begin
  FillChar(Result, SizeOf(Result), #0);
  if Assigned(Canvas) and (Text <> '') then
  begin
    Canvas.Lock;
    Result := InternalTextExtentW(PWideChar(Text), Canvas.Handle);
    Canvas.Unlock;
  end;
end;

function TextExtentW(Text: PWideChar; Canvas: TCanvas): TSize;
begin
  FillChar(Result, SizeOf(Result), #0);
  if Assigned(Canvas) and (Assigned(Text)) then
  begin
    Canvas.Lock;
    Result := InternalTextExtentW(Text, Canvas.Handle);
    Canvas.Unlock;
  end;
end;

function TextExtentW(Text: PWideChar; DC: hDC): TSize;
begin
  FillChar(Result, SizeOf(Result), #0);
  if (DC <> 0) and (Assigned(Text)) then
    Result := InternalTextExtentW(Text, DC);
end;

//----------------------------------------------------------------------------------------------------------------------

function UniqueFileName(const AFilePath: WideString): WideString;

{ Creates a unique file name in based on other files in the passed path         }

var
  i: integer;
  WP: PWideChar;
begin
  Result := AFilePath;
  i := 2;
  while FileExistsW(Result) and (i < 20) do
  begin
    Result := AFilePath;
    WP := StrRScanW(PWideChar( Result), '.');
    if Assigned(WP) then
      InsertW( ' (' + IntToStrW(i) + ')', Result, PWideChar(WP) - PWideChar(Result))
    else begin
      Result := '';
      Break;
    end;
    Inc(i)
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function UniqueDirName(const ADirPath: WideString): WideString;
var
  i: integer;
begin
  Result := ADirPath;
  i := 2;
  while DirExistsW(Result) and (i < 20) do
  begin
    Result := ADirPath;
    InsertW( ' (' + IntToStrW(i) + ')', Result, Length(Result));
    Inc(i)
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function WindowsDirectory: WideString;
var
  Len: integer;
  S: string;
begin
  Result := '';
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Len := GetWindowsDirectoryW_VST(PWideChar(Result), 0)
  else
    Len := GetWindowsDirectoryA(PChar(S), 0);
  if Len > 0 then
  begin
    if IsUnicode then
    begin
      SetLength(Result, Len - 1);
      GetWindowsDirectoryW_VST(PWideChar(Result), Len);
    end else
    begin
      SetLength(S, Len - 1);
      GetWindowsDirectoryA(PChar(S), Len);
      Result := S
    end
  end
end;

function ModuleFileName: Widestring;
var
  BufferA: array[0..MAX_PATH] of Char;
  BufferW: array[0..MAX_PATH] of WideChar;
begin
  if IsUnicode then
  begin
    FillChar(BufferW, SizeOf(BufferW), #0);
    if GetModuleFileNameW(0, BufferW, SizeOf(BufferW)) > 0 then
      Result := ExtractFileDirW(BufferW)
  end else
  begin
    FillChar(BufferA, SizeOf(BufferA), #0);
    if GetModuleFileNameA(0 , BufferA, SizeOf(BufferA)) > 0 then
      Result := ExtractFileDirW(BufferA);
  end
end;

procedure WriteStringToStream(S: TStream; Caption: string);
var
  Len: Integer;
begin
  Len := Length(Caption);
  S.WriteBuffer(Len, SizeOf(Len));
  S.WriteBuffer(PChar(Caption)^, Len);
end;

function ReadStringFromStream(S: TStream): string;
var
  Len: Integer;
begin
  S.ReadBuffer(Len, SizeOf(Len));
  SetLength(Result, Len);
  S.ReadBuffer(PChar(Result)^, Len)
end;

procedure WriteWideStringToStream(S: TStream; Caption: WideString);
var
  Len: Integer;
begin
  S.WriteBuffer(Len, SizeOf(Len));
  S.WriteBuffer(PWideChar(Caption)^, Len*2);
end;

function ReadWideStringFromStream(S: TStream): WideString;
var
  Len: Integer;
begin
  S.ReadBuffer(Len, SizeOf(Len));
  SetLength(Result, Len);
  S.ReadBuffer(PWideChar(Result)^, Len*2)
end;


//----------------------------------------------------------------------------------------------------------------------

{ TWideStringList }

function TWideStringList.Add(const S: WideString): Integer;
begin
  Result := AddObject(S, nil);
end;

function TWideStringList.AddObject(const S: WideString; AObject: TObject): Integer;
begin
  if not Sorted then
    Result := FCount
  else
    if Find(S, Result) then
      case Duplicates of
        dupIgnore: Exit;
        dupError: Error(SDuplicateString, 0);
      end;
  InsertItem(Result, S, AObject);
end;

procedure TWideStringList.AddStrings(Strings: TWideStringList);
var
  I: Integer;
begin
  for I := 0 to Strings.Count - 1 do
    AddObject(Strings[I], Strings.Objects[I]);
end;

procedure TWideStringList.AddStrings(Strings: TStrings);
var
  I: Integer;
begin
  for I := 0 to Strings.Count - 1 do
    AddObject(Strings[I], Strings.Objects[I]);
end;

procedure TWideStringList.Assign(Source: TPersistent);
begin
  if Source is TWideStringList then
  begin
    Clear;
    AddStrings(TWideStringList(Source));
  end else
    if Source is TStrings then
    begin
      Clear;
      AddStrings(TStrings(Source));
    end else
      inherited;
end;

procedure TWideStringList.AssignTo(Dest: TPersistent);
var
  I: Integer;
begin
  if Dest is TWideStringList then
    Dest.Assign(Self)
  else
    if Dest is TStrings then
    begin
      TStrings(Dest).Clear;
      for I := 0 to Count - 1 do
        TStrings(Dest).AddObject(Strings[I], Objects[I]);
    end else
      inherited;
end;

procedure TWideStringList.Changed;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TWideStringList.Changing;
begin
  if Assigned(FOnChanging) then
    FOnChanging(Self);
end;

procedure TWideStringList.Clear;
begin
  if FCount <> 0 then
  begin
    Changing;
    while FCount > 0 do
      Delete(0);
    SetCapacity(0);
    Changed;
  end;
end;

procedure TWideStringList.CustomSort(Compare: TWideStringListSortCompare);
begin
  if not Sorted and (FCount > 1) then
  begin
    Changing;
    QuickSort(0, FCount - 1, Compare);
    Changed;
  end;
end;

procedure TWideStringList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Changing;
  if OwnsObjects then
    if Assigned(Objects[Index]) then begin
      Objects[Index].Free;
      Objects[Index] := nil;
    end;
  Finalize(FList^[Index]);
  Dec(FCount);
  if Index < FCount then
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TWideStringItem));
  Changed;
end;

destructor TWideStringList.Destroy;
begin
  FOnChange := nil;
  FOnChanging := nil;
  Clear;
  inherited Destroy;
  SetCapacity(0);
end;

procedure TWideStringList.Error(const Msg: String; Data: Integer);

  function ReturnAddr: Pointer;
  asm
    MOV EAX, [EBP + 4]
  end;

begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure TWideStringList.Exchange(Index1, Index2: Integer);
begin
  if (Index1 < 0) or (Index1 >= FCount) then
    Error(SListIndexError, Index1);
  if (Index2 < 0) or (Index2 >= FCount) then
    Error(SListIndexError, Index2);
  Changing;
  ExchangeItems(Index1, Index2);
  Changed;
end;

procedure TWideStringList.ExchangeItems(Index1, Index2: Integer);
var
  Temp: Integer;
  Item1, Item2: PWideStringItem;
begin
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  Temp := Integer(Item1^.FWideString);
  Integer(Item1^.FWideString) := Integer(Item2^.FWideString);
  Integer(Item2^.FWideString) := Temp;
  Temp := Integer(Item1^.FObject);
  Integer(Item1^.FObject) := Integer(Item2^.FObject);
  Integer(Item2^.FObject) := Temp;
end;

function TWideStringList.Find(const S: WideString;
  var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    if Win32Platform = VER_PLATFORM_WIN32_NT then
      C := lstrcmpiW_VST(PWideChar( FList^[I].FWideString), PWideChar( S))
    else
      C := AnsiCompareText(FList^[I].FWideString, S);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function TWideStringList.Get(Index: Integer): WideString;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Result := FList^[Index].FWideString;
end;

function TWideStringList.GetCapacity: Integer;
begin
  Result := FCapacity;
end;

function TWideStringList.GetCommaText: WideString;
var
  S: WideString;
  P: PWideChar;
  I,
  Count: Integer;
begin
  Count := GetCount;
  if (Count = 1) and (Get(0) = '') then Result := '""'
                                   else
  begin
    Result := '';
    for I := 0 to Count - 1 do
    begin
      S := Get(I);
      P := PWideChar(S);
      while not (P^ in [WideNull..WideSpace, WideChar('"'), WideChar(',')]) do Inc(P);
      if (P^ <> WideNull) then S := WideQuotedStr(S, '"');
      Result := Result + S + ',';
    end;
    System.Delete(Result, Length(Result), 1);
  end;
end;

function TWideStringList.GetCount: Integer;
begin
  Result := FCount;
end;

function TWideStringList.GetName(Index: Integer): WideString;
var
  P: Integer;
begin
  Result := Get(Index);
  P := Pos('=', Result);
  if P > 0 then SetLength(Result, P - 1)
           else Result := '';
end;

function TWideStringList.GetObject(Index: Integer): TObject;
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Result := FList^[Index].FObject;
end;

function TWideStringList.GetTextStr: WideString;
var
  I, L,
  Size,
  Count: Integer;
  P: PWideChar;
  S: WideString;
begin
  Count := GetCount;
  Size := 0;
  for I := 0 to Count - 1 do Inc(Size, Length(Get(I)) + 2);
  SetLength(Result, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := Get(I);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, 2 * L);
      Inc(P, L);
    end;
    P^ := WideCarriageReturn;
    Inc(P);
    P^ := WideLineFeed;
    Inc(P);
  end;
end;

function TWideStringList.GetValue(const Name: WideString): WideString;
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if I >= 0 then Result := Copy(Get(I), Length(Name) + 2, MaxInt)
            else Result := '';
end;

function TWideStringList.GetValueFromIndex(Index: Integer): WideString;
var
  S: WideString;
begin
  Result := '';
  if Index >= 0 then
  begin
    S := Names[Index];
    if S <> '' then
      Result := Copy(Get(Index), Length(S) + 2, MaxInt);
  end;
end;

procedure TWideStringList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 64 then Delta := FCapacity div 4 else
    if FCapacity > 8 then Delta := 16 else
      Delta := 4;
  SetCapacity(FCapacity + Delta);
end;

function TWideStringList.IndexOf(const S: WideString): Integer;
begin
  if not Sorted then
  begin
    for Result := 0 to GetCount - 1 do
    begin
      if Win32Platform = VER_PLATFORM_WIN32_NT then
      begin
        if lstrcmpiW_VST(PWideChar( Get(Result)), PWideChar(S)) = 0 then
          Exit
      end else
      begin
        if AnsiCompareText(Get(Result), S) = 0 then
          Exit;
      end
    end;
    Result := -1;
  end else
    if not Find(S, Result) then
      Result := -1;
end;

function TWideStringList.IndexOfName(const Name: WideString): Integer;
var
  P: Integer;
  S: WideString;
  SA, NameA: string;
begin
  for Result := 0 to GetCount - 1 do
  begin
    S := Get(Result);
    P := Pos('=', S);
    if P > 0 then
      if Win32Platform = VER_PLATFORM_WIN32_NT then
        begin
          if lstrcmpiW_VST(PWideChar(Copy(S, 1, P - 1)), PWideChar(Name)) = 0 then
            Exit;
        end else
        begin
          SA := S;
          NameA := Name;
          if lstrcmpi(PChar(Copy(SA, 1, P - 1)), PChar(NameA)) = 0 then
            Exit;
        end
     end;
  Result := -1;
end;

function TWideStringList.IndexOfObject(AObject: TObject): Integer;
begin
  for Result := 0 to GetCount - 1 do
    if GetObject(Result) = AObject then Exit;
  Result := -1;
end;

procedure TWideStringList.Insert(Index: Integer; const S: WideString);
begin
  if Sorted then
    Error(SSortedListError, 0);
  if (Index < 0) or (Index > FCount) then
    Error(SListIndexError, Index);
  InsertItem(Index, S, nil);
end;

procedure TWideStringList.InsertItem(Index: Integer; const S: WideString; AObject: TObject);
begin
  Changing;
  if FCount = FCapacity then Grow;
  if Index < FCount then
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TWideStringItem));
  with FList^[Index] do
  begin
    Pointer(FWideString) := nil;
    FObject := AObject;
    FWideString := S;
  end;
  Inc(FCount);
  Changed;
end;

procedure TWideStringList.LoadFromFile(const FileName: WideString);
var
  Stream: TStream;
begin
  try
    Stream := TWideFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
    try
      LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
  except
{$IFNDEF COMPILER_6_UP}
    RaiseLastWin32Error;
{$ELSE}
    RaiseLastOSError;
{$ENDIF}
  end;
end;

procedure TWideStringList.LoadFromStream(Stream: TStream);
var
  Size,
  BytesRead: Integer;
  Order: WideChar;
  SW: WideString;
  SA: String;
begin
  Size := Stream.Size - Stream.Position;
  BytesRead := Stream.Read(Order, 2);
  if (Order = BOM_LSB_FIRST) or (Order = BOM_MSB_FIRST) then
  begin
    SetLength(SW, (Size - 2) div 2);
    Stream.Read(PWideChar(SW)^, Size - 2);
    if Order = BOM_MSB_FIRST then StrSwapByteOrder(PWideChar(SW));
    SetTextStr(SW);
  end
  else
  begin
    // without byte order mark it is assumed that we are loading ANSI text
    Stream.Seek(-BytesRead, soFromCurrent);
    SetLength(SA, Size);
    Stream.Read(PChar(SA)^, Size);
    SetTextStr(SA);
  end;
end;

procedure TWideStringList.Put(Index: Integer; const S: WideString);
begin
  if Sorted then
    Error(SSortedListError, 0);
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Changing;
  FList^[Index].FWideString := S;
  Changed;
end;

procedure TWideStringList.PutObject(Index: Integer; AObject: TObject);
begin
  if (Index < 0) or (Index >= FCount) then
    Error(SListIndexError, Index);
  Changing;
  FList^[Index].FObject := AObject;
  Changed;
end;

procedure TWideStringList.QuickSort(L, R: Integer;
  SCompare: TWideStringListSortCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(Self, I, P) < 0 do Inc(I);
      while SCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TWideStringList.SaveToFile(const FileName: WideString);
var
  Stream: TStream;
  L: TStringList;
begin
  // the strings were saved as Unicode, even on W9x
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    Stream := TWideFileStream.Create(FileName, fmCreate);
    try
      SaveToStream(Stream);
    finally
      Stream.Free;
    end;
  end
  else begin
    L := TStringList.Create;
    try
      AssignTo(L);
      L.SaveToFile(Filename);
    finally
      L.free;
    end;
  end;
end;

procedure TWideStringList.SaveToStream(Stream: TStream);
//The strings will allways be saved as Unicode.
var
  SW, BOM: WideString;
begin
  SW := GetTextStr;
  BOM := BOM_LSB_FIRST;
  Stream.WriteBuffer(PWideChar(BOM)^, 2);
  Stream.WriteBuffer(PWideChar(SW)^, 2 * Length(SW));
end;

procedure TWideStringList.SetCapacity(NewCapacity: Integer);
begin
  if (NewCapacity < FCount) or (NewCapacity > MaxListSize) then
    Error(SListCapacityError, NewCapacity);
  if NewCapacity <> FCapacity then
  begin
    ReallocMem(FList, NewCapacity * SizeOf(TWideStringItem));
    FCapacity := NewCapacity;
  end;
end;

procedure TWideStringList.SetCommaText(const Value: WideString);
var
  P, P1: PWideChar;
  S: WideString;
begin
  Clear;
  P := PWideChar(Value);
  while P^ in [WideChar(#1)..WideSpace] do Inc(P);
  while P^ <> WideNull do
  begin
    if P^ = '"' then  S := WideExtractQuotedStr(P, '"')
                else
    begin
      P1 := P;
      while (P^ > WideSpace) and (P^ <> ',') do Inc(P);
      SetString(S, P1, P - P1);
    end;
    Add(S);

    while P^ in [WideChar(#1)..WideSpace] do Inc(P);
    if P^ = ',' then
      repeat
        Inc(P);
      until not (P^ in [WideChar(#1)..WideSpace]);
  end;
end;

procedure TWideStringList.SetSorted(Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort;
    FSorted := Value;
  end;
end;

procedure TWideStringList.SetTextStr(const Value: WideString);
var
  Head,
  Tail: PWideChar;
  S: WideString;
begin
  Clear;
  Head := PWideChar(Value);
  while Head^ <> WideNull do
  begin
    Tail := Head;
    while not (Tail^ in [WideNull, WideLineFeed, WideCarriageReturn, WideVerticalTab, WideFormFeed]) and
          (Tail^ <> WideLineSeparator) and
          (Tail^ <> WideParagraphSeparator) do Inc(Tail);
    SetString(S, Head, Tail - Head);
    Add(S);
    Head := Tail;
    if Head^ <> WideNull then
    begin
      Inc(Head);
      if (Tail^ = WideCarriageReturn) and
         (Head^ = WideLineFeed) then Inc(Head);
    end;
  end;
end;

procedure TWideStringList.SetUpdateState(Updating: Boolean);
begin
  if Updating then
    Changing
  else
  Changed;
end;

procedure TWideStringList.SetValue(const Name, Value: WideString);
var
  I : Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    Put(I, Name + '=' + Value);
  end
  else
    if I >= 0 then Delete(I);
end;

procedure TWideStringList.SetValueFromIndex(Index: Integer; const Value: WideString);
begin
  if Value <> '' then
  begin
    if Index < 0 then Index := Add('');
    Put(Index, Names[Index] + '=' + Value);
  end
  else
    if Index >= 0 then Delete(Index);
end;

function WideStringListCompare(List: TWideStringList; Index1, Index2: Integer): Integer;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := lstrcmpiW_VST(PWideChar( List.FList^[Index1].FWideString),
                        PWideChar( List.FList^[Index2].FWideString))
  else
    Result := AnsiCompareText(List.FList^[Index1].FWideString,
                              List.FList^[Index2].FWideString);
end;

procedure TWideStringList.Sort;
begin
  CustomSort(WideStringListCompare);
end;

{ TWideFileStream }

constructor TWideFileStream.Create(const FileName: WideString; Mode: Word);
var
  CreateHandle: Integer;
begin
  if Mode = fmCreate then
  begin
    CreateHandle := WideFileCreate(FileName);
    if CreateHandle < 0 then
     {$IFNDEF COMPILER_5_UP}
      raise EFCreateError.Create('Can not create file: ' + FileName);
     {$ELSE}
     raise EFCreateError.CreateResFmt(PResStringRec(@SFCreateError), [FileName]);
     {$ENDIF COMPILER_5_UP}
  end else
  begin
    CreateHandle := WideFileOpen(FileName, Mode);
    if CreateHandle < 0 then
     {$IFNDEF COMPILER_5_UP}
      raise EFCreateError.Create('Can not create file: ' + FileName);
     {$ELSE}
     raise EFCreateError.CreateResFmt(PResStringRec(@SFCreateError), [FileName]);
     {$ENDIF COMPILER_5_UP}
  end;
  inherited Create(CreateHandle);
end;

destructor TWideFileStream.Destroy;
begin
  if Handle >= 0 then FileClose(Handle);
  inherited Destroy;
end;

function WideFileCreate(const FileName: WideString): Integer;
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := Integer(CreateFileW(PWideChar(FileName), GENERIC_READ or GENERIC_WRITE, 0,
      nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0))
  else
    Result := Integer(CreateFileA(PAnsiChar(AnsiString(PWideChar(FileName))), GENERIC_READ or GENERIC_WRITE, 0,
      nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
end;

function WideFileOpen(const FileName: WideString; Mode: LongWord): Integer;
const
  AccessMode: array[0..2] of LongWord = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of LongWord = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := Integer(CreateFileW(PWideChar(FileName), AccessMode[Mode and 3], ShareMode[(Mode and $F0) shr 4],
      nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0))
  else
    Result := Integer(CreateFileA(PAnsiChar(AnsiString(FileName)), AccessMode[Mode and 3], ShareMode[(Mode and $F0) shr 4],
      nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0));
end;

procedure LoadWideString(S: TStream; var Str: WideString);
var
  Count: Integer;
begin
  S.Read(Count, SizeOf(Integer));
  SetLength(Str, Count);
  S.Read(PWideChar(Str)^, Count * 2)
end;

procedure SaveWideString(S: TStream; Str: WideString);
var
  Count: Integer;
begin
  Count := Length(Str);
  S.Write(Count, SizeOf(Integer));
  S.Write(PWideChar(Str)^, Count * 2)
end;

end.
