{-------------------------------------------------------------------------------

  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is DIUtils.pas.

  The Initial Developer of the Original Code is Ralf Junker.

  E-Mail:    delphi@zeitungsjunge.de
  Internet:  http://www.zeitungsjunge.de/delphi/

  All Rights Reserved.

-------------------------------------------------------------------------------}

unit DIUtils;

{$I DI.inc}

interface

uses
  {$IFDEF MSWINDOWS}
  Windows,
  ShlObj;
{$ENDIF}
{$IFDEF LINUX}
Libc;
{$ENDIF}

const

  CRLF = #$0D#$0A;

  AC_NULL = AnsiChar(#$00);
  AC_TAB = AnsiChar(#$09);
  AC_SPACE = AnsiChar(#$20);

  AC_EXCLAMATION_MARK = AnsiChar(#$21);

  AC_QUOTATION_MARK = AnsiChar(#$22);

  AC_NUMBER_SIGN = AnsiChar(#$23);

  AC_DOLLAR_SIGN = AnsiChar(#$24);

  AC_PERCENT_SIGN = AnsiChar(#$25);

  AC_AMPERSAND = AnsiChar(#$26);

  AC_APOSTROPHE = AnsiChar(#$27);

  AC_ASTERISK = AnsiChar(#$2A);

  AC_PLUS_SIGN = AnsiChar(#$2B);

  AC_COMMA = AnsiChar(#$2C);

  AC_HYPHEN_MINUS = AnsiChar(#$2D);

  AC_FULL_STOP = AnsiChar(#$2E);

  AC_SOLIDUS = AnsiChar(#$2F);

  AC_DIGIT_ZERO = AnsiChar(#$30);

  AC_DIGIT_ONE = AnsiChar(#$31);

  AC_DIGIT_TWO = AnsiChar(#$32);

  AC_DIGIT_THREE = AnsiChar(#$33);

  AC_DIGIT_FOUR = AnsiChar(#$34);

  AC_DIGIT_FIVE = AnsiChar(#$35);

  AC_DIGIT_SIX = AnsiChar(#$36);

  AC_DIGIT_SEVEN = AnsiChar(#$37);

  AC_DIGIT_EIGHT = AnsiChar(#$38);

  AC_DIGIT_NINE = AnsiChar(#$39);

  AC_COLON = AnsiChar(#$3A);

  AC_SEMICOLON = AnsiChar(#$3B);

  AC_LESS_THAN_SIGN = AnsiChar(#$3C);

  AC_EQUALS_SIGN = AnsiChar(#$3D);

  AC_GREATER_THAN_SIGN = AnsiChar(#$3E);

  AC_QUESTION_MARK = AnsiChar(#$3F);

  AC_COMMERCIAL_AT = AnsiChar(#$40);

  AC_REVERSE_SOLIDUS = AnsiChar(#$5C);

  AC_LOW_LINE = AnsiChar(#$5F);

  AC_SOFT_HYPHEN = AnsiChar(#$AD);

  AC_CAPITAL_A = AnsiChar(#$41);
  AC_CAPITAL_B = AnsiChar(#$42);
  AC_CAPITAL_C = AnsiChar(#$43);
  AC_CAPITAL_D = AnsiChar(#$44);
  AC_CAPITAL_E = AnsiChar(#$45);
  AC_CAPITAL_F = AnsiChar(#$46);
  AC_CAPITAL_R = AnsiChar(#$52);
  AC_CAPITAL_S = AnsiChar(#$53);
  AC_CAPITAL_Z = AnsiChar(#$5A);

  AC_GRAVE_ACCENT = AnsiChar(#$60);

  AC_SMALL_A = AnsiChar(#$61);
  AC_SMALL_B = AnsiChar(#$62);
  AC_SMALL_C = AnsiChar(#$63);
  AC_SMALL_D = AnsiChar(#$64);
  AC_SMALL_E = AnsiChar(#$65);
  AC_SMALL_F = AnsiChar(#$66);
  AC_SMALL_R = AnsiChar(#$72);
  AC_SMALL_S = AnsiChar(#$73);
  AC_SMALL_Z = AnsiChar(#$7A);

  AC_NO_BREAK_SPACE = AnsiChar(#$A0);

  AC_DRIVE_DELIMITER = AC_COLON;

  AC_DOS_PATH_DELIMITER = AC_REVERSE_SOLIDUS;

  AC_UNIX_PATH_DELIMITER = AC_SOLIDUS;

  AC_PATH_DELIMITER =
    {$IFDEF MSWINDOWS}AC_DOS_PATH_DELIMITER{$ENDIF}
  {$IFDEF LINUX}AC_UNIX_PATH_DELIMITER{$ENDIF};

  AS_CRLF = AnsiString(#$0D#$0A);

  AS_DIGITS = [
    AC_DIGIT_ZERO..AC_DIGIT_NINE];

  AS_HEX_DIGITS = [
    AC_DIGIT_ZERO..AC_DIGIT_NINE,
    AC_CAPITAL_A..AC_CAPITAL_F,
    AC_SMALL_A, AC_SMALL_F];

  AS_WHITE_SPACE = [
    AC_NULL..AC_SPACE];

  AS_WORD_SEPARATORS = [
    AC_NULL..AC_SPACE,
    AC_DIGIT_ZERO..AC_DIGIT_NINE,
    AC_FULL_STOP, AC_COMMA, AC_COLON, AC_SEMICOLON,
    AC_QUOTATION_MARK, AC_HYPHEN_MINUS, AC_SOLIDUS, AC_AMPERSAND];

  AA_HEX_TO_NUM: array[#$00..#$FF] of Byte = (
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $0A, $0B, $0C, $0D, $0E, $0F, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $0A, $0B, $0C, $0D, $0E, $0F, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF,
    $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF);

  AA_NUM_TO_HEX: array[0..$F] of AnsiChar = (
    AC_DIGIT_ZERO,
    AC_DIGIT_ONE,
    AC_DIGIT_TWO,
    AC_DIGIT_THREE,
    AC_DIGIT_FOUR,
    AC_DIGIT_FIVE,
    AC_DIGIT_SIX,
    AC_DIGIT_SEVEN,
    AC_DIGIT_EIGHT,
    AC_DIGIT_NINE,
    AC_CAPITAL_A,
    AC_CAPITAL_B,
    AC_CAPITAL_C,
    AC_CAPITAL_D,
    AC_CAPITAL_E,
    AC_CAPITAL_F);

  WC_NULL = WideChar(#$0000);
  WC_0001 = WideChar(#$0001);
  WC_0008 = WideChar(#$0008);

  WC_TAB = WideChar(#$0009);

  WC_LF = WideChar(#$000A);
  WC_000B = WideChar(#$000B);
  WC_000C = WideChar(#$000C);

  WC_CR = WideChar(#$000D);
  WC_000E = WideChar(#$000E);

  WC_SPACE = WideChar(#$0020);

  WC_EXCLAMATION_MARK = WideChar(#$0021);

  WC_QUOTATION_MARK = WideChar(#$0022);

  WC_NUMBER_SIGN = WideChar(#$0023);

  WC_DOLLAR_SIGN = WideChar(#$0024);

  WC_PERCENT_SIGN = WideChar(#$0025);

  WC_AMPERSAND = WideChar(#$0026);

  WC_APOSTROPHE = WideChar(#$0027);

  WC_LEFT_PARENTHESIS = WideChar(#$0028);

  WC_RIGHT_PARENTHESIS = WideChar(#$0029);

  WC_ASTERISK = WideChar(#$002A);

  WC_PLUS_SIGN = WideChar(#$002B);

  WC_COMMA = WideChar(#$002C);

  WC_HYPHEN_MINUS = WideChar(#$002D);

  WC_FULL_STOP = WideChar(#$002E);

  WC_SOLIDUS = WideChar(#$002F);

  WC_DIGIT_ZERO = WideChar(#$0030);

  WC_DIGIT_ONE = WideChar(#$0031);

  WC_DIGIT_TWO = WideChar(#$0032);

  WC_DIGIT_THREE = WideChar(#$0033);

  WC_DIGIT_FOUR = WideChar(#$0034);

  WC_DIGIT_FIVE = WideChar(#$0035);

  WC_DIGIT_SIX = WideChar(#$0036);

  WC_DIGIT_SEVEN = WideChar(#$0037);

  WC_DIGIT_EIGHT = WideChar(#$0038);

  WC_DIGIT_NINE = WideChar(#$0039);

  WC_COLON = WideChar(#$003A);

  WC_SEMICOLON = WideChar(#$003B);

  WC_LESS_THAN_SIGN = WideChar(#$003C);

  WC_EQUALS_SIGN = WideChar(#$003D);

  WC_COMMERCIAL_AT = WideChar(#$0040);

  WC_GREATER_THAN_SIGN = WideChar(#$003E);

  WC_QUESTION_MARK = WideChar(#$003F);

  WC_SOFT_HYPHEN = WideChar(#$00AD);

  WC_CAPITAL_A = WideChar(#$0041);
  WC_CAPITAL_B = WideChar(#$0042);
  WC_CAPITAL_C = WideChar(#$0043);
  WC_CAPITAL_D = WideChar(#$0044);
  WC_CAPITAL_E = WideChar(#$0045);
  WC_CAPITAL_F = WideChar(#$0046);
  WC_CAPITAL_G = WideChar(#$0047);
  WC_CAPITAL_H = WideChar(#$0048);
  WC_CAPITAL_I = WideChar(#$0049);
  WC_CAPITAL_J = WideChar(#$004A);
  WC_CAPITAL_K = WideChar(#$004B);
  WC_CAPITAL_L = WideChar(#$004C);
  WC_CAPITAL_M = WideChar(#$004D);
  WC_CAPITAL_N = WideChar(#$004E);
  WC_CAPITAL_O = WideChar(#$004F);
  WC_CAPITAL_P = WideChar(#$0050);
  WC_CAPITAL_Q = WideChar(#$0051);
  WC_CAPITAL_R = WideChar(#$0052);
  WC_CAPITAL_S = WideChar(#$0053);
  WC_CAPITAL_T = WideChar(#$0054);
  WC_CAPITAL_U = WideChar(#$0055);
  WC_CAPITAL_V = WideChar(#$0056);
  WC_CAPITAL_W = WideChar(#$0057);
  WC_CAPITAL_X = WideChar(#$0058);
  WC_CAPITAL_Y = WideChar(#$0059);
  WC_CAPITAL_Z = WideChar(#$005A);

  WC_LEFT_SQUARE_BRACKET = WideChar(#$005B);

  WC_REVERSE_SOLIDUS = WideChar(#$005C);

  WC_RIGHT_SQUARE_BRACKET = WideChar(#$005D);

  WC_CIRCUMFLEX_ACCENT = WideChar(#$005E);

  WC_LOW_LINE = WideChar(#$005F);

  WC_GRAVE_ACCENT = WideChar(#$0060);

  WC_SMALL_A = WideChar(#$0061);
  WC_SMALL_B = WideChar(#$0062);
  WC_SMALL_C = WideChar(#$0063);
  WC_SMALL_D = WideChar(#$0064);
  WC_SMALL_E = WideChar(#$0065);
  WC_SMALL_F = WideChar(#$0066);
  WC_SMALL_G = WideChar(#$0067);
  WC_SMALL_H = WideChar(#$0068);
  WC_SMALL_I = WideChar(#$0069);
  WC_SMALL_J = WideChar(#$006A);
  WC_SMALL_K = WideChar(#$006B);
  WC_SMALL_L = WideChar(#$006C);
  WC_SMALL_M = WideChar(#$006D);
  WC_SMALL_N = WideChar(#$006E);
  WC_SMALL_O = WideChar(#$006F);
  WC_SMALL_P = WideChar(#$0070);
  WC_SMALL_Q = WideChar(#$0071);
  WC_SMALL_R = WideChar(#$0072);
  WC_SMALL_S = WideChar(#$0073);
  WC_SMALL_T = WideChar(#$0074);
  WC_SMALL_U = WideChar(#$0075);
  WC_SMALL_V = WideChar(#$0076);
  WC_SMALL_W = WideChar(#$0077);
  WC_SMALL_X = WideChar(#$0078);
  WC_SMALL_Y = WideChar(#$0079);
  WC_SMALL_Z = WideChar(#$007A);

  WC_LEFT_CURLY_BRACKET = WideChar(#$007B);

  WC_RIGHT_CURLY_BRACKET = WideChar(#$007D);

  WC_TILDE = WideChar(#$007E);

  WC_NO_BREAK_SPACE = WideChar(#$00A0);
  WC_EN_DASH = WideChar(#$2013);
  WC_REPLACEMENT_CHARACTER = WideChar(#$FFFD);

  WC_DRIVE_DELIMITER = WC_COLON;

  WC_DOS_PATH_DELIMITER = WC_REVERSE_SOLIDUS;
  WC_UNIX_PATH_DELIMITER = WC_SOLIDUS;
  WC_PATH_DELIMITER =
    {$IFDEF MSWINDOWS}WC_DOS_PATH_DELIMITER{$ENDIF}
  {$IFDEF LINUX}WC_UNIX_PATH_DELIMITER{$ENDIF};

  WS_CRLF = WideString(#$000D#$000A);

  {$IFDEF DI_Use_Wide_Char_Set_Consts}

  WS_DIGITS = [
    WC_DIGIT_ZERO..WC_DIGIT_NINE];

  WS_HEX_DIGITS = [
    WC_DIGIT_ZERO..WC_DIGIT_NINE,
    WC_CAPITAL_A..WC_CAPITAL_F,
    WC_SMALL_A..WC_SMALL_F];

  WS_WHITE_SPACE = [
    WC_NULL..WC_SPACE];
  {$ENDIF}

  WA_NUM_TO_HEX: array[0..$F] of WideChar = (
    WC_DIGIT_ZERO,
    WC_DIGIT_ONE,
    WC_DIGIT_TWO,
    WC_DIGIT_THREE,
    WC_DIGIT_FOUR,
    WC_DIGIT_FIVE,
    WC_DIGIT_SIX,
    WC_DIGIT_SEVEN,
    WC_DIGIT_EIGHT,
    WC_DIGIT_NINE,
    WC_CAPITAL_A,
    WC_CAPITAL_B,
    WC_CAPITAL_C,
    WC_CAPITAL_D,
    WC_CAPITAL_E,
    WC_CAPITAL_F);

  HANGUL_SBase = $AC00;

  HANGUL_LBase = $1100;

  HANGUL_VBase = $1161;

  HANGUL_TBase = $11A7;

  HANGUL_LCount = 19;
  HANGUL_VCount = 21;
  HANGUL_TCount = 28;

  HANGUL_nCount = HANGUL_VCount * HANGUL_TCount;

  HANGUL_SCount = HANGUL_LCount * HANGUL_nCount;

  MT19937_N = 624;

  MT19937_M = 397;

type

  PCardinal = ^Cardinal;

  TAnsiCharSet = set of AnsiChar;

  TIsoDate = Cardinal;

  TJulianDate = Integer;

  PJulianDate = ^TJulianDate;

  TCharDecompositionW = packed record
    Count: Byte;
    Data: array[0..17] of WideChar;
  end;
  PCharDecompositionW = ^TCharDecompositionW;

  {$IFNDEF COMPILER_6_UP}
  TMethod = record
    Code, Data: Pointer;
  end;
  {$ENDIF}

  TProcedureEvent = procedure of object;

  TDIValidateWideCharFunc = function(const Char: WideChar): Boolean;

  TMT19937 = class(TObject)
  private
    FState: array[0..MT19937_N - 1] of Cardinal;
    FLeft: Integer;
    FInit: Boolean;
    FNext: PCardinal;
    procedure next_state;
  public

    constructor Create(const Seed: Cardinal); overload;

    constructor Create(const Seeds: array of Cardinal); overload;

    constructor Create(const Seed: AnsiString); overload;

    procedure init_genrand(const Seed: Cardinal);

    procedure init_by_array(const Seeds: array of Cardinal);

    procedure init_by_StrA(const Seed: AnsiString);

    function genrand_int32: Cardinal;

    function genrand_int31: Integer;

    function genrand_int64: Int64;

    function genrand_int63: Int64;

    function genrand_real1: Double;

    function genrand_real2: Double;

    function genrand_real3: Double;

    function genrand_res53: Double;
  end;

  TWideStrBuf = class
  private
    FBuf, FPos, FEnd: PWideChar;
    procedure GrowBuffer(const Count: Cardinal);
    function GetAsStr: WideString;
    function GetCount: Cardinal;
  public
    destructor Destroy; override;
    procedure AddBuf(const Buf: PWideChar; const Count: Cardinal);
    procedure AddChar(const c: WideChar);
    procedure AddCrLf;
    procedure AddStr(const s: WideString);
    property AsStr: WideString read GetAsStr;
    property Buf: PWideChar read FBuf;
    procedure Clear;
    property Count: Cardinal read GetCount;
    function IsEmpty: Boolean;
    function IsNotEmpty: Boolean;
    procedure Reset;
  end;

  function CharIsLetterW(const c: WideChar): Boolean;
function CharIsLetterCommonW(const c: WideChar): Boolean;
function CharIsLetterUpperCaseW(const c: WideChar): Boolean;
function CharIsLetterLowerCaseW(const c: WideChar): Boolean;
function CharIsLetterTitleCaseW(const c: WideChar): Boolean;
function CharIsLetterModifierW(const c: WideChar): Boolean;
function CharIsLetterOtherW(const c: WideChar): Boolean;
function CharIsMarkW(const c: WideChar): Boolean;
function CharIsMarkNon_SpacingW(const c: WideChar): Boolean;
function CharIsMarkSpacing_CombinedW(const c: WideChar): Boolean;
function CharIsMarkEnclosingW(const c: WideChar): Boolean;
function CharIsNumberW(const c: WideChar): Boolean;
function CharIsNumber_DecimalW(const c: WideChar): Boolean;
function CharIsNumber_LetterW(const c: WideChar): Boolean;
function CharIsNumber_OtherW(const c: WideChar): Boolean;
function CharIsPunctuationW(const c: WideChar): Boolean;
function CharIsPunctuation_ConnectorW(const c: WideChar): Boolean;
function CharIsPunctuation_DashW(const c: WideChar): Boolean;
function CharIsPunctuation_OpenW(const c: WideChar): Boolean;
function CharIsPunctuation_CloseW(const c: WideChar): Boolean;
function CharIsPunctuation_InitialQuoteW(const c: WideChar): Boolean;
function CharIsPunctuation_FinalQuoteW(const c: WideChar): Boolean;
function CharIsPunctuation_OtherW(const c: WideChar): Boolean;
function CharIsSymbolW(const c: WideChar): Boolean;
function CharIsSymbolMathW(const c: WideChar): Boolean;
function CharIsSymbolCurrencyW(const c: WideChar): Boolean;
function CharIsSymbolModifierW(const c: WideChar): Boolean;
function CharIsSymbolOtherW(const c: WideChar): Boolean;
function CharIsSeparatorW(const c: WideChar): Boolean;
function CharIsSeparatorSpaceW(const c: WideChar): Boolean;
function CharIsSeparatorLineW(const c: WideChar): Boolean;
function CharIsSeparatorParagraphW(const c: WideChar): Boolean;
function CharIsOtherW(const c: WideChar): Boolean;
function CharIsOtherControlW(const c: WideChar): Boolean;
function CharIsOtherFormatW(const c: WideChar): Boolean;
function CharIsOtherSurrogateW(const c: WideChar): Boolean;
function CharIsOtherPrivateUseW(const c: WideChar): Boolean;

function BitClear(const Bits, BitNo: Integer): Integer;

function BitSet(const Bits, BitIndex: Integer): Integer;

function BitSetTo(const Bits, BitIndex: Integer; const Value: Boolean): Integer;

function BitTest(const Bits, BitIndex: Integer): Boolean;

function BSwap(const Value: Cardinal): Cardinal; Overload;

function BSwap(const Value: Integer): Integer; Overload;

function BufEncodeUtf8(p: PWideChar; l: Cardinal): AnsiString;

function BufPosA(const Search: AnsiString; const Buf: PAnsiChar; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): Pointer;

function BufPosW(const ASearch: WideString; const ABuffer: PWideChar; const ABufferCharCount: Cardinal; const AStartPos: Cardinal = 0): PWideChar;

function BufPosIA(const Search: AnsiString; const Buf: Pointer; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): Pointer;

function BufPosIW(const ASearch: WideString; const ABuffer: PWideChar; const ABufferCharCount: Cardinal; const AStartPos: Cardinal = 0): PWideChar;

function BufSame(const Buf1, Buf2: Pointer; const BufByteCount: Cardinal): Boolean;

function BufSameIA(const Buf1, Buf2: Pointer; const BufCharCount: Cardinal): Boolean;

function BufPosCharsA(const Buf: PAnsiChar; const BufCharCount: Cardinal; const Search: TAnsiCharSet; const Start: Cardinal = 0): Integer;

function BufStrSameA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; const s: AnsiString): Boolean;

function BufStrSameW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: WideString): Boolean;

function BufStrSameIA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; const s: AnsiString): Boolean;

function BufStrSameIW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: WideString): Boolean;

function ChangeFileExtW(const FileName, Extension: WideString): WideString;

function CharDecomposeCanonicalW(const Char: WideChar): PCharDecompositionW;

function CharDecomposeCanonicalStrW(const Char: WideChar): WideString;

function CharDecomposeCompatibleW(const Char: WideChar): PCharDecompositionW;

function CharDecomposeCompatibleStrW(const Char: WideChar): WideString;

function CharCanonicalCombiningClassW(const Char: WideChar): Cardinal;

function CharToCaseFoldW(const Char: WideChar): WideChar;

function CharToLowerW(const Char: WideChar): WideChar;

function CharToUpperW(const Char: WideChar): WideChar;

function CharToTitleW(const Char: WideChar): WideChar;

procedure ConCatBufA(const Buffer: Pointer; const AnsiCharCount: Cardinal; var d: AnsiString; var InUse: Cardinal);

procedure ConCatBufW(const Buffer: Pointer; const WideCharCount: Cardinal; var d: WideString; var InUse: Cardinal);

procedure ConCatCharA(const c: AnsiChar; var d: AnsiString; var InUse: Cardinal);

procedure ConCatCharW(const c: WideChar; var d: WideString; var InUse: Cardinal);

procedure ConCatStrA(const s: AnsiString; var d: AnsiString; var InUse: Cardinal);

procedure ConCatStrW(const w: WideString; var d: WideString; var InUse: Cardinal);

function CountBitsSet(const x: Cardinal): Byte;

function Crc32OfBuf(const Buffer; const BufferSize: Cardinal): Cardinal;

function Crc32OfStrA(const s: AnsiString): Cardinal;

function Crc32OfStrW(const w: WideString): Cardinal;

function CurrentDay: Word;
function CurrentMonth: Word;
function CurrentQuarter: Word;
function CurrentYear: Integer;

function CurrentJulianDate: TJulianDate;

function DayOfJulianDate(const JulianDate: TJulianDate): Word;

function DayOfWeek(const JulianDate: TJulianDate): Word; Overload;
function DayOfWeek(const Year: Integer; const Month, Day: Word): Word; Overload;

function DaysInMonth(const Year: Integer; const Month: Word): Word; Overload;
function DaysInMonth(const JulianDate: TJulianDate): Word; Overload;

procedure DecDay(var Year: Integer; var Month, Day: Word); Overload;
procedure DecDay(var Year: Integer; var Month, Day: Word; const Days: Integer); Overload;

{$IFDEF MSWINDOWS}

function DeleteDirectoryW(Dir: WideString; const DeleteItself: Boolean = True): Boolean;

function DeleteDirectoryA(Dir: AnsiString; const DeleteItself: Boolean = True): Boolean;
{$ENDIF}

function DirectoryExistsA(const Dir: AnsiString): Boolean; Overload;
{$IFDEF MSWINDOWS}

function DirectoryExistsW(const Dir: WideString): Boolean; Overload;
{$ENDIF}

{$IFDEF MSWINDOWS}

function DiskFreeA(const Dir: AnsiString): Int64;

function DiskFreeW(const Dir: WideString): Int64;
{$ENDIF}

function EasterSunday(const Year: Integer): TJulianDate; Overload;
procedure EasterSunday(const Year: Integer; out Month, Day: Word); Overload;

procedure ExcludeTrailingPathDelimiterA(var s: AnsiString);

procedure ExcludeTrailingPathDelimiterW(var s: WideString);

function ExtractFileDriveA(const FileName: AnsiString): AnsiString;

function ExtractFileDriveW(const FileName: WideString): WideString;

function ExtractFileExtW(const FileName: WideString): WideString;

function ExtractFileNameA(const FileName: AnsiString): AnsiString;

function ExtractFileNameW(const FileName: WideString): WideString;

function ExtractFilePathA(const FileName: AnsiString): AnsiString;

function ExtractFilePathW(const FileName: WideString): WideString;

function ExtractNextWordA(const s: AnsiString; const Delimiters: TAnsiCharSet; var StartIndex: Integer): AnsiString;

function ExtractWordA(const Number: Cardinal; const s: AnsiString; const Delimiters: TAnsiCharSet = AS_WHITE_SPACE): AnsiString;

function ExtractWordStartsA(const s: AnsiString; const MaxCharCount: Cardinal; const WordSeparators: TAnsiCharSet = AS_WHITE_SPACE): AnsiString;

function ExtractWordStartsW(const s: WideString; const MaxCharCount: Cardinal; const IsWordSep: TDIValidateWideCharFunc): WideString;

{$IFDEF MSWINDOWS}

function FileExistsA(const FileName: AnsiString): Boolean;

function FileExistsW(const FileName: WideString): Boolean;
{$ENDIF}

function FirstDayOfWeek(const JulianDate: TJulianDate): TJulianDate; Overload;

procedure FirstDayOfWeek(var Year: Integer; var Month, Day: Word); Overload;

function FirstDayOfMonth(const Julian: TJulianDate): TJulianDate; Overload;

procedure FirstDayOfMonth(const Year: Integer; const Month: Word; out Day: Word); Overload;

{$IFDEF MSWINDOWS}

function ForceDirectoriesA(Dir: AnsiString): Boolean;

function ForceDirectoriesW(Dir: WideString): Boolean;
{$ENDIF}

{$IFNDEF COMPILER_5_UP}

procedure FreeAndNil(var Obj);
{$ENDIF}

function GCD(const x, y: Cardinal): Cardinal;

{$IFDEF MSWINDOWS}

function GetCurrentFolderA: AnsiString;

function GetCurrentFolderW: WideString;

procedure SetCurrentFolderA(const NewFolder: AnsiString);

procedure SetCurrentFolderW(const NewFolder: WideString);

function GetDesktopFolderA: AnsiString;

function GetDesktopFolderW: WideString;

function GetDesktopDirectoryFolderA: AnsiString;

function GetDesktopDirectoryFolderW: WideString;

function GetPersonalFolderA: AnsiString;

function GetPersonalFolderW: WideString;

function GetSpecialFolderA(const SpecialFolder: Integer): AnsiString;

function GetSpecialFolderW(const SpecialFolder: Integer): WideString;
{$ENDIF}

{$IFDEF MSWINDOWS}

function GetTempFolderA: AnsiString;

function GetTempFolderW: WideString;
{$ENDIF}

{$IFDEF MSWINDOWS}

function GetUserNameA(out UserNameA: AnsiString): Boolean;

function GetUserNameW(out UserNameW: WideString): Boolean;
{$ENDIF}

function HashBuf(const Buffer; const BufferSize: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;

function HashBufIA(const Buffer; const AnsiCharCount: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;

function HashBufIW(const Buffer; const WideCharCount: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;

function HashStrA(const s: AnsiString; const PreviousHash: Cardinal = 0): Cardinal;

function HashStrW(const w: WideString; const PreviousHash: Cardinal = 0): Cardinal;

function HashStrIA(const s: AnsiString; const PreviousHash: Cardinal = 0): Cardinal;

function HashStrIW(const w: WideString; const PreviousHash: Cardinal = 0): Cardinal;

function HexToIntA(const s: AnsiString): Integer;

function HexToIntW(const w: WideString): Integer;

procedure IncMonth(var Year: Integer; var Month, Day: Word); Overload;

procedure IncMonth(var Year: Integer; var Month, Day: Word; const NumberOfMonths: Integer); Overload;

procedure IncDay(var Year: Integer; var Month, Day: Word); Overload;

procedure IncDay(var Year: Integer; var Month, Day: Word; const Days: Integer); Overload;

procedure IncludeTrailingPathDelimiterByRef(var s: AnsiString); Overload;

procedure IncludeTrailingPathDelimiterByRef(var w: WideString); Overload;

function IntToHexA(Value: Int64; Digits: Integer): AnsiString;

function IntToHexW(Value: Int64; Digits: Integer): WideString;

function IntToStrA(const i: Integer): AnsiString; Overload;

function IntToStrA(const i: Int64): AnsiString; Overload;

function IntToStrW(const i: Integer): WideString; Overload;

function IntToStrW(const i: Int64): WideString; Overload;

function IsCharAlphaW(const c: WideChar): Boolean;

function CharDecomposeHangulW(const c: WideChar): WideString;

function CharIsAlphaNumW(const c: WideChar): Boolean;

function CharIsDigitW(const c: WideChar): Boolean;

function CharIsHangulW(const Char: WideChar): Boolean;

function CharIsHexDigitW(const c: WideChar): Boolean;

function IsDateValid(const Year: Integer; const Month, Day: Word): Boolean;

function IsHolidayInGermany(const Year: Integer; const Month, Day: Word): Boolean; Overload;

function IsHolidayInGermany(const Julian: TJulianDate): Boolean; Overload;

function IsLeapYear(const Year: Integer): Boolean;

function IsPathDelimiterA(const s: AnsiString; const Index: Cardinal): Boolean;

function IsPathDelimiterW(const w: WideString; const Index: Cardinal): Boolean;

{$IFDEF MSWINDOWS}

function IsPointInRect(const Point: TPoint; const Rect: TRect): Boolean;
{$ENDIF}

function ISODateToJulianDate(const ISODate: TIsoDate): TJulianDate;

procedure ISODateToYmd(const ISODate: TIsoDate; out Year: Integer; out Month, Day: Word);

function IsCharLowLineW(const c: WideChar): Boolean;

function IsCharQuoteW(const c: WideChar): Boolean;

{$IFDEF MSWINDOWS}

function IsShiftKeyDown: Boolean;
{$ENDIF}

function CharIsWhiteSpaceW(const c: WideChar): Boolean;

function IsCharWhiteSpaceOrAmpersandW(const c: WideChar): Boolean;

function IsCharWhiteSpaceOrNoBreakSpaceW(const c: WideChar): Boolean;

function IsCharWhiteSpaceOrColonW(const c: WideChar): Boolean;

function CharIsWhiteSpaceGtW(const c: WideChar): Boolean;

function CharIsWhiteSpaceLtW(const c: WideChar): Boolean;

function CharIsWhiteSpaceHyphenW(const c: WideChar): Boolean;

function CharIsWhiteSpaceHyphenGtW(const c: WideChar): Boolean;

function StrIsEmptyA(const s: AnsiString): Boolean;

function StrIsEmptyW(const w: WideString): Boolean;

function IsCharWordSeparatorW(const c: WideChar): Boolean;

function ISOWeekNumber(const JulianDate: TJulianDate): Word; Overload;

function ISOWeekNumber(const Year: Integer; const Month, Day: Word): Word; Overload;

function ISOWeekToJulianDate(const Year: Integer; const WeekOfYear, DayOfWeek: Word): TJulianDate;

function JulianDateToIsoDate(const Julian: TJulianDate): TIsoDate;

function JulianDateToIsoDateA(const Julian: TJulianDate): AnsiString;

function JulianDateToIsoDateW(const Julian: TJulianDate): WideString;

procedure JulianDateToYmd(const JulianDate: TJulianDate; out Year: Integer; out Month, Day: Word);

function LastDayOfMonth(const JulianDate: TJulianDate): TJulianDate; Overload;

procedure LastDayOfMonth(const Year: Integer; const Month: Word; out Day: Word); Overload;

function LastDayOfWeek(const JulianDate: TJulianDate): TJulianDate; Overload;

procedure LastDayOfWeek(var Year: Integer; var Month, Day: Word); Overload;

{$IFDEF MSWINDOWS}

function LastSysErrorMessageA: AnsiString;

function LastSysErrorMessageW: WideString;
{$ENDIF}

function LeftMostBit(const Value: Cardinal): Integer;

function MakeMethod(const AData, ACode: Pointer): TMethod;

function Max(const a, b: Integer): Integer; Overload;

function Max(const a, b: Cardinal): Cardinal; Overload;

function Min(const a, b: Integer): Integer; Overload;

function Min(const a, b: Cardinal): Cardinal; Overload;

function MonthOfJulianDate(const JulianDate: TJulianDate): Word;

function PadLeftA(const Source: AnsiString; const Count: Cardinal; const c: AnsiChar = AC_SPACE): AnsiString;

function PadLeftW(const Source: WideString; const Count: Cardinal; const c: WideChar = WC_SPACE): WideString;

function PadRightA(const Source: AnsiString; const Count: Cardinal; const c: AnsiChar = AC_SPACE): AnsiString;

function PadRightW(const Source: WideString; const Count: Cardinal; const c: WideChar = WC_SPACE): WideString;

function ProperCaseA(const s: AnsiString): AnsiString; Overload;

function ProperCaseW(const w: WideString): WideString; Overload;

procedure ProperCaseByRef(var s: AnsiString); Overload;

procedure ProperCaseByRef(var w: WideString); Overload;

{$IFDEF MSWINDOWS}

function RegReadRegisteredOrganizationA: AnsiString;

function RegReadRegisteredOrganizationW: WideString;

function RegReadRegisteredOwnerA: AnsiString;

function RegReadRegisteredOwnerW: WideString;
{$ENDIF}

{$IFDEF MSWINDOWS}

function RegReadStrDefA(const Key: HKEY; const SubKey, ValueName, Default: AnsiString): AnsiString;

function RegReadStrDefW(const Key: HKEY; const SubKey, ValueName, Default: WideString): WideString;
{$ENDIF}

function StrDecodeUrl(const Value: AnsiString): AnsiString;

function StrEncodeUrl(const Value: AnsiString): AnsiString;

procedure StrRemoveFromToIA(var Source: AnsiString; const FromString, ToString: AnsiString);

procedure StrRemoveFromToIW(var Source: WideString; const FromString, ToString: WideString);

procedure StrRemoveSpacing(var s: AnsiString; const SpaceChars: TAnsiCharSet = AS_WHITE_SPACE; const ReplaceChar: AnsiChar = AC_SPACE); Overload;

procedure StrRemoveSpacing(var w: WideString; IsSpaceChar: TDIValidateWideCharFunc = nil; const ReplaceChar: WideChar = WC_SPACE); Overload;

procedure StrReplaceCharA(var Source: AnsiString; const SearchChar, ReplaceChar: AnsiChar);

function StrReplaceA(const Source, Search, Replace: AnsiString): AnsiString;

function StrReplaceW(const Source, Search, Replace: WideString): WideString;

function StrReplaceIA(const Source, Search, Replace: AnsiString): AnsiString;

function StrReplaceIW(const Source, Search, Replace: WideString): WideString;

function StrReplaceLoopA(const Source, Search, Replace: AnsiString): AnsiString;

function StrReplaceLoopW(const Source, Search, Replace: WideString): WideString;

function StrReplaceLoopIA(const Source, Search, Replace: AnsiString): AnsiString;

function StrReplaceLoopIW(const Source, Search, Replace: WideString): WideString;

function RightMostBit(const Value: Cardinal): Integer;

function LoadStrFromFileA(const FileName: AnsiString; var s: AnsiString): Boolean; Overload;

function LoadStrFromFileA(const FileName: AnsiString; var s: WideString): Boolean; Overload;

{$IFDEF MSWINDOWS}

function LoadStrFromFileW(const FileName: WideString; var s: AnsiString): Boolean; Overload;

function LoadStrFromFileW(const FileName: WideString; var s: WideString): Boolean; Overload;
{$ENDIF}

{$IFDEF MSWINDOWS}

function SaveBufToFile(const Buffer; const BufferSize: Cardinal; const FileHandle: THandle): Boolean;

function SaveBufToFileA(const Buffer; const BufferSize: Cardinal; const FileName: AnsiString): Boolean;

function SaveBufToFileW(const Buffer; const BufferSize: Cardinal; const FileName: WideString): Boolean;

function SaveStrAToFileA(const s: AnsiString; const FileName: AnsiString): Boolean;

function SaveStrAToFileW(const s: AnsiString; const FileName: WideString): Boolean;

function SaveStrWToFileA(const w: WideString; const FileName: AnsiString): Boolean;

function SaveStrWToFileW(const w: WideString; const FileName: WideString): Boolean;
{$ENDIF}

function StrPosCharA(const Source: AnsiString; const c: AnsiChar; const Start: Cardinal = 1): Cardinal;

function StrPosCharW(const Source: WideString; const c: WideChar; const Start: Cardinal = 1): Cardinal;

function StrPosCharsA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 1): Cardinal;

function StrPosCharsW(const Source: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Cardinal;

function StrPosCharBackA(const Source: AnsiString; const c: AnsiChar; const Start: Cardinal = 0): Cardinal;

function StrPosCharBackW(const Source: WideString; const c: WideChar; const Start: Cardinal = 0): Cardinal;

function StrPosCharsBackA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 0): Cardinal;

function StrPosNotCharsA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 1): Cardinal;

function StrPosNotCharsW(const Source: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Cardinal;

function StrPosNotCharsBackA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 0): Cardinal;

{$IFDEF MSWINDOWS}

function SetFileDate(const FileHandle: THandle; const Year: Integer; const Month, Day: Word): Boolean;

function SetFileDateA(const FileName: AnsiString; const JulianDate: TJulianDate): Boolean; Overload;

function SetFileDateA(const FileName: AnsiString; const Year: Integer; const Month, Day: Word): Boolean; Overload;

function SetFileDateW(const FileName: WideString; const JulianDate: TJulianDate): Boolean; Overload;

function SetFileDateW(const FileName: WideString; const Year: Integer; const Month, Day: Word): Boolean; Overload;
{$ENDIF}

function StrCompA(const s1, s2: AnsiString): Integer;

function StrCompW(const s1, s2: WideString): Integer;

function StrCompIA(const s1, s2: AnsiString): Integer;

function StrCompIW(const s1, s2: WideString): Integer;

function StrContainsCharA(const s: AnsiString; const c: AnsiChar; const Start: Cardinal = 1): Boolean;

function StrContainsCharsA(const s: AnsiString; const Chars: TAnsiCharSet; const Start: Cardinal = 1): Boolean;

function StrContainsCharW(const w: WideString; const c: WideChar; const Start: Cardinal = 1): Boolean;

function StrContainsCharsW(const w: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Boolean;

function StrConsistsOfW(const w: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Boolean;

function StrSameA(const s1, s2: AnsiString): Boolean;

function StrSameW(const s1, s2: WideString): Boolean;

function StrSameIA(const s1, s2: AnsiString): Boolean;

function StrSameIW(const s1, s2: WideString): Boolean;

function StrSameStartA(const s1, s2: AnsiString): Boolean;

function StrSameStartW(const w1, w2: WideString): Boolean;

function StrSameStartIA(const s1, s2: AnsiString): Boolean;

function StrSameStartIW(const w1, w2: WideString): Boolean;

function StrContainsA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;

function StrContainsW(const ASearch, ASource: WideString; const AStartPos: Cardinal = 1): Boolean;

function StrContainsIW(const ASearch, ASource: WideString; const AStartPos: Cardinal = 1): Boolean;

function StrCountCharA(const Source: AnsiString; const c: AnsiChar; const StartIndex: Cardinal = 1): Cardinal;

function StrCountCharW(const Source: WideString; const c: WideChar; const StartIndex: Cardinal = 1): Cardinal;

function StrToLowerA(const s: AnsiString): AnsiString;

function StrMatchesA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;

function StrMatchesIA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;

function StrMatchWildA(const Source, Mask: AnsiString; const WildChar: AnsiChar = AC_ASTERISK; const MaskChar: AnsiChar = AC_QUESTION_MARK): Boolean;

function StrMatchWildIA(const Source, Mask: AnsiString; const WildChar: AnsiChar = AC_ASTERISK; const MaskChar: AnsiChar = AC_QUESTION_MARK): Boolean;

function StrMatchWildIW(const Source, Mask: WideString; const WildChar: WideChar = AC_ASTERISK; const MaskChar: WideChar = AC_QUESTION_MARK): Boolean;

function StrPosA(const Search, Source: AnsiString; const Start: Cardinal = 1): Cardinal;

function StrPosW(const ASearch, ASource: WideString; const AStartPos: Cardinal = 1): Cardinal;

function StrPosIA(const Search, Source: AnsiString; const StartPos: Cardinal = 1): Cardinal;

function StrPosIW(const ASearch, ASource: WideString; const AStartPos: Cardinal = 1): Cardinal;

function StrPosBackA(const Search, Source: AnsiString; Start: Cardinal = 0): Cardinal;

function StrPosBackIA(const Search, Source: AnsiString; Start: Cardinal = 0): Cardinal;

function StrToIntDefW(const w: WideString; const Default: Integer): Integer;

function StrToInt64DefW(const w: WideString; const Default: Int64): Int64;

function StrToUpperA(const s: AnsiString): AnsiString;

function StrToUpperW(const s: WideString): WideString;
procedure StrToUpperInPlaceW(var s: WideString);

function StrToLowerW(const s: WideString): WideString;
procedure StrToLowerInPlaceW(var s: WideString);

procedure StrTimUriFragmentA(var Value: AnsiString);

procedure StrTrimUriFragmentW(var Value: WideString);

function BufCountUtf8Chars(p: PAnsiChar; l: Cardinal; const BytesToCount: Cardinal = $FFFFFFFF): Cardinal;

function StrCountUtf8Chars(const Value: AnsiString; const BytesToCount: Cardinal = $FFFFFFFF): Cardinal;

function StrDecodeUtf8(const Value: AnsiString): WideString;

function StrEncodeUtf8(const Value: WideString): AnsiString;

{$IFDEF MSWINDOWS}

function SysErrorMessageA(const MessageID: Cardinal): AnsiString;

function SysErrorMessageW(const MessageID: Cardinal): WideString;
{$ENDIF}

{$IFDEF MSWINDOWS}

function TextHeightW(const DC: HDC; const Text: WideString): Integer;

function TextWidthW(const DC: HDC; const Text: WideString): Integer;
{$ENDIF}

function TrimA(const Source: AnsiString): AnsiString; Overload;

function TrimA(const Source: AnsiString; const CharToTrim: AnsiChar): AnsiString; Overload;

function TrimA(const Source: AnsiString; const CharsToTrim: TAnsiCharSet): AnsiString; Overload;

function TrimW(const w: WideString): WideString; Overload;

function TrimW(const w: WideString; const IsCharToTrim: TDIValidateWideCharFunc): WideString; Overload;

procedure TrimLeftByRefA(var s: AnsiString; const Chars: TAnsiCharSet);

function TrimRightA(const Source: AnsiString; const s: TAnsiCharSet): AnsiString;

procedure TrimRightByRefA(var Source: AnsiString; const s: TAnsiCharSet);

procedure TrimCompress(var s: AnsiString; const TrimCompressChars: TAnsiCharSet = AS_WHITE_SPACE; const ReplaceChar: AnsiChar = AC_SPACE); Overload;

procedure TrimCompress(var w: WideString; Validate: TDIValidateWideCharFunc = nil; const ReplaceChar: WideChar = WC_SPACE); Overload;

procedure TrimRightByRefW(var w: WideString; Validate: TDIValidateWideCharFunc = nil);

function TryStrToIntW(const w: WideString; out Value: Integer): Boolean;

function TryStrToInt64W(const w: WideString; out Value: Int64): Boolean;

function UpdateCrc32OfBuf(const Crc32: Cardinal; const Buffer; const BufferSize: Cardinal): Cardinal;

function UpdateCrc32OfStrA(const Crc32: Cardinal; const s: AnsiString): Cardinal;

function UpdateCrc32OfStrW(const Crc32: Cardinal; const w: WideString): Cardinal;

{$IFDEF MSWINDOWS}

function WBufToAStr(const Buffer: PWideChar; const WideCharCount: Cardinal; const CodePage: Word = CP_ACP): AnsiString;

function WStrToAStr(const s: WideString; const CodePage: Word = CP_ACP): AnsiString;
{$ENDIF}

function ValIntW(const w: WideString; out Code: Integer): Integer;

function ValInt64W(const w: WideString; out Code: Integer): Int64;

function YearOfJuilanDate(const JulianDate: TJulianDate): Integer;

function YmdToIsoDate(const Year: Integer; const Month, Day: Word): TIsoDate;

function YmdToIsoDateA(const Year: Integer; const Month, Day: Word): AnsiString;

function YmdToIsoDateW(const Year: Integer; const Month, Day: Word): WideString;

function YmdToJulianDate(const Year: Integer; const Month, Day: Word): TJulianDate;

procedure ZeroMem(const Buffer; const Size: Cardinal);

type

  PDIDayTable = ^TDIDayTable;
  TDIDayTable = array[1..12] of Word;

  PDIMonthTable = ^TDIMonthTable;
  TDIMonthTable = array[1..12] of Word;

  PDIQuarterTable = ^TDIQuarterTable;
  TDIQuarterTable = array[1..4] of Word;

const
  ISO_MONDAY = 0;
  ISO_TUESDAY = 1;
  ISO_WEDNESDAY = 2;
  ISO_THURSDAY = 3;
  ISO_FRIDAY = 4;
  ISO_SATURDAY = 5;
  ISO_SUNDAY = 6;

  SHORT_DAY_NAMES_GERMAN_A: array[0..6] of AnsiString =
  ('Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So');
  SHORT_DAY_NAMES_GERMAN_W: array[0..6] of WideString =
  ('Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So');

  DAYS_IN_MONTH: array[Boolean] of TDIDayTable = (
    (31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31),
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31));
  QUARTER_OF_MONTH: TDIMonthTable =
  (1, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4);
  HALF_YEAR_OF_MONTH: TDIMonthTable =
  (1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2);
  HALF_YEAR_OF_QUARTER: TDIQuarterTable =
  (1, 1, 2, 2);

  ANSI_LOWER_CHAR_TABLE: array[#0..#255] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #091, #092, #093, #094, #095,
    #096, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #154, #139, #156, #141, #158, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #154, #155, #156, #157, #158, #255,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #215, #248, #249, #250, #251, #252, #253, #254, #223,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #247, #248, #249, #250, #251, #252, #253, #254, #255);

  ANSI_UPPER_CHAR_TABLE: array[#0..#255] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #091, #092, #093, #094, #095,
    #096, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #138, #139, #140, #141, #142, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #138, #155, #140, #157, #142, #159,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #215, #216, #217, #218, #219, #220, #221, #222, #223,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #247, #216, #217, #218, #219, #220, #221, #222, #159);

  ANSI_REVERSE_CHAR_TABLE: array[#0..#255] of AnsiChar = (
    #000, #001, #002, #003, #004, #005, #006, #007, #008, #009, #010, #011, #012, #013, #014, #015,
    #016, #017, #018, #019, #020, #021, #022, #023, #024, #025, #026, #027, #028, #029, #030, #031,
    #032, #033, #034, #035, #036, #037, #038, #039, #040, #041, #042, #043, #044, #045, #046, #047,
    #048, #049, #050, #051, #052, #053, #054, #055, #056, #057, #058, #059, #060, #061, #062, #063,
    #064, #097, #098, #099, #100, #101, #102, #103, #104, #105, #106, #107, #108, #109, #110, #111,
    #112, #113, #114, #115, #116, #117, #118, #119, #120, #121, #122, #091, #092, #093, #094, #095,
    #096, #065, #066, #067, #068, #069, #070, #071, #072, #073, #074, #075, #076, #077, #078, #079,
    #080, #081, #082, #083, #084, #085, #086, #087, #088, #089, #090, #123, #124, #125, #126, #127,
    #128, #129, #130, #131, #132, #133, #134, #135, #136, #137, #154, #139, #156, #141, #158, #143,
    #144, #145, #146, #147, #148, #149, #150, #151, #152, #153, #138, #155, #140, #157, #142, #255,
    #160, #161, #162, #163, #164, #165, #166, #167, #168, #169, #170, #171, #172, #173, #174, #175,
    #176, #177, #178, #179, #180, #181, #182, #183, #184, #185, #186, #187, #188, #189, #190, #191,
    #224, #225, #226, #227, #228, #229, #230, #231, #232, #233, #234, #235, #236, #237, #238, #239,
    #240, #241, #242, #243, #244, #245, #246, #215, #248, #249, #250, #251, #252, #253, #254, #223,
    #192, #193, #194, #195, #196, #197, #198, #199, #200, #201, #202, #203, #204, #205, #206, #207,
    #208, #209, #210, #211, #212, #213, #214, #247, #216, #217, #218, #219, #220, #221, #222, #159);

  CRC_32_INIT = $FFFFFFFF;

  CRC_32_TABLE: array[Byte] of Cardinal = (
    $000000000, $077073096, $0EE0E612C, $0990951BA, $0076DC419, $0706AF48F,
    $0E963A535, $09E6495A3, $00EDB8832, $079DCB8A4, $0E0D5E91E, $097D2D988,
    $009B64C2B, $07EB17CBD, $0E7B82D07, $090BF1D91, $01DB71064, $06AB020F2,
    $0F3B97148, $084BE41DE, $01ADAD47D, $06DDDE4EB, $0F4D4B551, $083D385C7,
    $0136C9856, $0646BA8C0, $0FD62F97A, $08A65C9EC, $014015C4F, $063066CD9,
    $0FA0F3D63, $08D080DF5, $03B6E20C8, $04C69105E, $0D56041E4, $0A2677172,
    $03C03E4D1, $04B04D447, $0D20D85FD, $0A50AB56B, $035B5A8FA, $042B2986C,
    $0DBBBC9D6, $0ACBCF940, $032D86CE3, $045DF5C75, $0DCD60DCF, $0ABD13D59,
    $026D930AC, $051DE003A, $0C8D75180, $0BFD06116, $021B4F4B5, $056B3C423,
    $0CFBA9599, $0B8BDA50F, $02802B89E, $05F058808, $0C60CD9B2, $0B10BE924,
    $02F6F7C87, $058684C11, $0C1611DAB, $0B6662D3D, $076DC4190, $001DB7106,
    $098D220BC, $0EFD5102A, $071B18589, $006B6B51F, $09FBFE4A5, $0E8B8D433,
    $07807C9A2, $00F00F934, $09609A88E, $0E10E9818, $07F6A0DBB, $0086D3D2D,
    $091646C97, $0E6635C01, $06B6B51F4, $01C6C6162, $0856530D8, $0F262004E,
    $06C0695ED, $01B01A57B, $08208F4C1, $0F50FC457, $065B0D9C6, $012B7E950,
    $08BBEB8EA, $0FCB9887C, $062DD1DDF, $015DA2D49, $08CD37CF3, $0FBD44C65,
    $04DB26158, $03AB551CE, $0A3BC0074, $0D4BB30E2, $04ADFA541, $03DD895D7,
    $0A4D1C46D, $0D3D6F4FB, $04369E96A, $0346ED9FC, $0AD678846, $0DA60B8D0,
    $044042D73, $033031DE5, $0AA0A4C5F, $0DD0D7CC9, $05005713C, $0270241AA,
    $0BE0B1010, $0C90C2086, $05768B525, $0206F85B3, $0B966D409, $0CE61E49F,
    $05EDEF90E, $029D9C998, $0B0D09822, $0C7D7A8B4, $059B33D17, $02EB40D81,
    $0B7BD5C3B, $0C0BA6CAD, $0EDB88320, $09ABFB3B6, $003B6E20C, $074B1D29A,
    $0EAD54739, $09DD277AF, $004DB2615, $073DC1683, $0E3630B12, $094643B84,
    $00D6D6A3E, $07A6A5AA8, $0E40ECF0B, $09309FF9D, $00A00AE27, $07D079EB1,
    $0F00F9344, $08708A3D2, $01E01F268, $06906C2FE, $0F762575D, $0806567CB,
    $0196C3671, $06E6B06E7, $0FED41B76, $089D32BE0, $010DA7A5A, $067DD4ACC,
    $0F9B9DF6F, $08EBEEFF9, $017B7BE43, $060B08ED5, $0D6D6A3E8, $0A1D1937E,
    $038D8C2C4, $04FDFF252, $0D1BB67F1, $0A6BC5767, $03FB506DD, $048B2364B,
    $0D80D2BDA, $0AF0A1B4C, $036034AF6, $041047A60, $0DF60EFC3, $0A867DF55,
    $0316E8EEF, $04669BE79, $0CB61B38C, $0BC66831A, $0256FD2A0, $05268E236,
    $0CC0C7795, $0BB0B4703, $0220216B9, $05505262F, $0C5BA3BBE, $0B2BD0B28,
    $02BB45A92, $05CB36A04, $0C2D7FFA7, $0B5D0CF31, $02CD99E8B, $05BDEAE1D,
    $09B64C2B0, $0EC63F226, $0756AA39C, $0026D930A, $09C0906A9, $0EB0E363F,
    $072076785, $005005713, $095BF4A82, $0E2B87A14, $07BB12BAE, $00CB61B38,
    $092D28E9B, $0E5D5BE0D, $07CDCEFB7, $00BDBDF21, $086D3D2D4, $0F1D4E242,
    $068DDB3F8, $01FDA836E, $081BE16CD, $0F6B9265B, $06FB077E1, $018B74777,
    $088085AE6, $0FF0F6A70, $066063BCA, $011010B5C, $08F659EFF, $0F862AE69,
    $0616BFFD3, $0166CCF45, $0A00AE278, $0D70DD2EE, $04E048354, $03903B3C2,
    $0A7672661, $0D06016F7, $04969474D, $03E6E77DB, $0AED16A4A, $0D9D65ADC,
    $040DF0B66, $037D83BF0, $0A9BCAE53, $0DEBB9EC5, $047B2CF7F, $030B5FFE9,
    $0BDBDF21C, $0CABAC28A, $053B39330, $024B4A3A6, $0BAD03605, $0CDD70693,
    $054DE5729, $023D967BF, $0B3667A2E, $0C4614AB8, $05D681B02, $02A6F2B94,
    $0B40BBE37, $0C30C8EA1, $05A05DF1B, $02D02EF8D
    );

  BitTable: array[Byte] of Byte = (
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7,
    3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8);

  {$IFDEF MSWINDOWS}
  {$IFNDEF DI_No_Win_9X_Support}
var
  IsUnicode: Boolean;
  {$ENDIF}
  {$ENDIF}

implementation

{$IFDEF MSWINDOWS}
uses
  ActiveX, ShellAPI;
{$ENDIF}

function CharIsLetterW(const c: WideChar): Boolean;
begin
  case c of
    #$0041..#$005A, #$0061..#$007A, #$00AA, #$00B5, #$00BA,
    #$00C0..#$00D6, #$00D8..#$00F6, #$00F8..#$0236, #$0250..#$02C1,
    #$02C6..#$02D1, #$02E0..#$02E4, #$02EE, #$037A, #$0386,
    #$0388..#$038A, #$038C, #$038E..#$03A1, #$03A3..#$03CE,
    #$03D0..#$03F5, #$03F7..#$03FB, #$0400..#$0481, #$048A..#$04CE,
    #$04D0..#$04F5, #$04F8..#$04F9, #$0500..#$050F, #$0531..#$0556,
    #$0559, #$0561..#$0587, #$05D0..#$05EA, #$05F0..#$05F2,
    #$0621..#$063A, #$0640..#$064A, #$066E..#$066F, #$0671..#$06D3,
    #$06D5, #$06E5..#$06E6, #$06EE..#$06EF, #$06FA..#$06FC,
    #$06FF, #$0710, #$0712..#$072F, #$074D..#$074F, #$0780..#$07A5,
    #$07B1, #$0904..#$0939, #$093D, #$0950, #$0958..#$0961,
    #$0985..#$098C, #$098F..#$0990, #$0993..#$09A8, #$09AA..#$09B0,
    #$09B2, #$09B6..#$09B9, #$09BD, #$09DC..#$09DD, #$09DF..#$09E1,
    #$09F0..#$09F1, #$0A05..#$0A0A, #$0A0F..#$0A10, #$0A13..#$0A28,
    #$0A2A..#$0A30, #$0A32..#$0A33, #$0A35..#$0A36, #$0A38..#$0A39,
    #$0A59..#$0A5C, #$0A5E, #$0A72..#$0A74, #$0A85..#$0A8D,
    #$0A8F..#$0A91, #$0A93..#$0AA8, #$0AAA..#$0AB0, #$0AB2..#$0AB3,
    #$0AB5..#$0AB9, #$0ABD, #$0AD0, #$0AE0..#$0AE1, #$0B05..#$0B0C,
    #$0B0F..#$0B10, #$0B13..#$0B28, #$0B2A..#$0B30, #$0B32..#$0B33,
    #$0B35..#$0B39, #$0B3D, #$0B5C..#$0B5D, #$0B5F..#$0B61,
    #$0B71, #$0B83, #$0B85..#$0B8A, #$0B8E..#$0B90, #$0B92..#$0B95,
    #$0B99..#$0B9A, #$0B9C, #$0B9E..#$0B9F, #$0BA3..#$0BA4,
    #$0BA8..#$0BAA, #$0BAE..#$0BB5, #$0BB7..#$0BB9, #$0C05..#$0C0C,
    #$0C0E..#$0C10, #$0C12..#$0C28, #$0C2A..#$0C33, #$0C35..#$0C39,
    #$0C60..#$0C61, #$0C85..#$0C8C, #$0C8E..#$0C90, #$0C92..#$0CA8,
    #$0CAA..#$0CB3, #$0CB5..#$0CB9, #$0CBD, #$0CDE, #$0CE0..#$0CE1,
    #$0D05..#$0D0C, #$0D0E..#$0D10, #$0D12..#$0D28, #$0D2A..#$0D39,
    #$0D60..#$0D61, #$0D85..#$0D96, #$0D9A..#$0DB1, #$0DB3..#$0DBB,
    #$0DBD, #$0DC0..#$0DC6, #$0E01..#$0E30, #$0E32..#$0E33,
    #$0E40..#$0E46, #$0E81..#$0E82, #$0E84, #$0E87..#$0E88,
    #$0E8A, #$0E8D, #$0E94..#$0E97, #$0E99..#$0E9F, #$0EA1..#$0EA3,
    #$0EA5, #$0EA7, #$0EAA..#$0EAB, #$0EAD..#$0EB0, #$0EB2..#$0EB3,
    #$0EBD, #$0EC0..#$0EC4, #$0EC6, #$0EDC..#$0EDD, #$0F00,
    #$0F40..#$0F47, #$0F49..#$0F6A, #$0F88..#$0F8B, #$1000..#$1021,
    #$1023..#$1027, #$1029..#$102A, #$1050..#$1055, #$10A0..#$10C5,
    #$10D0..#$10F8, #$1100..#$1159, #$115F..#$11A2, #$11A8..#$11F9,
    #$1200..#$1206, #$1208..#$1246, #$1248, #$124A..#$124D,
    #$1250..#$1256, #$1258, #$125A..#$125D, #$1260..#$1286,
    #$1288, #$128A..#$128D, #$1290..#$12AE, #$12B0, #$12B2..#$12B5,
    #$12B8..#$12BE, #$12C0, #$12C2..#$12C5, #$12C8..#$12CE,
    #$12D0..#$12D6, #$12D8..#$12EE, #$12F0..#$130E, #$1310,
    #$1312..#$1315, #$1318..#$131E, #$1320..#$1346, #$1348..#$135A,
    #$13A0..#$13F4, #$1401..#$166C, #$166F..#$1676, #$1681..#$169A,
    #$16A0..#$16EA, #$1700..#$170C, #$170E..#$1711, #$1720..#$1731,
    #$1740..#$1751, #$1760..#$176C, #$176E..#$1770, #$1780..#$17B3,
    #$17D7, #$17DC, #$1820..#$1877, #$1880..#$18A8, #$1900..#$191C,
    #$1950..#$196D, #$1970..#$1974, #$1D00..#$1D6B, #$1E00..#$1E9B,
    #$1EA0..#$1EF9, #$1F00..#$1F15, #$1F18..#$1F1D, #$1F20..#$1F45,
    #$1F48..#$1F4D, #$1F50..#$1F57, #$1F59, #$1F5B, #$1F5D,
    #$1F5F..#$1F7D, #$1F80..#$1FB4, #$1FB6..#$1FBC, #$1FBE,
    #$1FC2..#$1FC4, #$1FC6..#$1FCC, #$1FD0..#$1FD3, #$1FD6..#$1FDB,
    #$1FE0..#$1FEC, #$1FF2..#$1FF4, #$1FF6..#$1FFC, #$2071,
    #$207F, #$2102, #$2107, #$210A..#$2113, #$2115, #$2119..#$211D,
    #$2124, #$2126, #$2128, #$212A..#$212D, #$212F..#$2131,
    #$2133..#$2139, #$213D..#$213F, #$2145..#$2149, #$3005..#$3006,
    #$3031..#$3035, #$303B..#$303C, #$3041..#$3096, #$309D..#$309F,
    #$30A1..#$30FA, #$30FC..#$30FF, #$3105..#$312C, #$3131..#$318E,
    #$31A0..#$31B7, #$31F0..#$31FF, #$3400, #$4DB5, #$4E00,
    #$9FA5, #$A000..#$A48C, #$AC00, #$D7A3, #$F900..#$FA2D,
    #$FA30..#$FA6A, #$FB00..#$FB06, #$FB13..#$FB17, #$FB1D,
    #$FB1F..#$FB28, #$FB2A..#$FB36, #$FB38..#$FB3C, #$FB3E,
    #$FB40..#$FB41, #$FB43..#$FB44, #$FB46..#$FBB1, #$FBD3..#$FD3D,
    #$FD50..#$FD8F, #$FD92..#$FDC7, #$FDF0..#$FDFB, #$FE70..#$FE74,
    #$FE76..#$FEFC, #$FF21..#$FF3A, #$FF41..#$FF5A, #$FF66..#$FFBE,
    #$FFC2..#$FFC7, #$FFCA..#$FFCF, #$FFD2..#$FFD7, #$FFDA..#$FFDC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterCommonW(const c: WideChar): Boolean;
begin
  case c of
    #$0041..#$005A, #$0061..#$007A, #$00AA, #$00B5, #$00BA,
    #$00C0..#$00D6, #$00D8..#$00F6, #$00F8..#$01BA, #$01BC..#$01BF,
    #$01C4..#$0236, #$0250..#$02AF, #$0386, #$0388..#$038A,
    #$038C, #$038E..#$03A1, #$03A3..#$03CE, #$03D0..#$03F5,
    #$03F7..#$03FB, #$0400..#$0481, #$048A..#$04CE, #$04D0..#$04F5,
    #$04F8..#$04F9, #$0500..#$050F, #$0531..#$0556, #$0561..#$0587,
    #$10A0..#$10C5, #$1D00..#$1D2B, #$1D62..#$1D6B, #$1E00..#$1E9B,
    #$1EA0..#$1EF9, #$1F00..#$1F15, #$1F18..#$1F1D, #$1F20..#$1F45,
    #$1F48..#$1F4D, #$1F50..#$1F57, #$1F59, #$1F5B, #$1F5D,
    #$1F5F..#$1F7D, #$1F80..#$1FB4, #$1FB6..#$1FBC, #$1FBE,
    #$1FC2..#$1FC4, #$1FC6..#$1FCC, #$1FD0..#$1FD3, #$1FD6..#$1FDB,
    #$1FE0..#$1FEC, #$1FF2..#$1FF4, #$1FF6..#$1FFC, #$2071,
    #$207F, #$2102, #$2107, #$210A..#$2113, #$2115, #$2119..#$211D,
    #$2124, #$2126, #$2128, #$212A..#$212D, #$212F..#$2131,
    #$2133..#$2134, #$2139, #$213D..#$213F, #$2145..#$2149,
    #$FB00..#$FB06, #$FB13..#$FB17, #$FF21..#$FF3A, #$FF41..#$FF5A:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterUpperCaseW(const c: WideChar): Boolean;
begin
  case c of
    #$0041..#$005A, #$00C0..#$00D6, #$00D8..#$00DE, #$0100,
    #$0102, #$0104, #$0106, #$0108, #$010A, #$010C, #$010E,
    #$0110, #$0112, #$0114, #$0116, #$0118, #$011A, #$011C,
    #$011E, #$0120, #$0122, #$0124, #$0126, #$0128, #$012A,
    #$012C, #$012E, #$0130, #$0132, #$0134, #$0136, #$0139,
    #$013B, #$013D, #$013F, #$0141, #$0143, #$0145, #$0147,
    #$014A, #$014C, #$014E, #$0150, #$0152, #$0154, #$0156,
    #$0158, #$015A, #$015C, #$015E, #$0160, #$0162, #$0164,
    #$0166, #$0168, #$016A, #$016C, #$016E, #$0170, #$0172,
    #$0174, #$0176, #$0178..#$0179, #$017B, #$017D, #$0181..#$0182,
    #$0184, #$0186..#$0187, #$0189..#$018B, #$018E..#$0191,
    #$0193..#$0194, #$0196..#$0198, #$019C..#$019D, #$019F..#$01A0,
    #$01A2, #$01A4, #$01A6..#$01A7, #$01A9, #$01AC, #$01AE..#$01AF,
    #$01B1..#$01B3, #$01B5, #$01B7..#$01B8, #$01BC, #$01C4,
    #$01C7, #$01CA, #$01CD, #$01CF, #$01D1, #$01D3, #$01D5,
    #$01D7, #$01D9, #$01DB, #$01DE, #$01E0, #$01E2, #$01E4,
    #$01E6, #$01E8, #$01EA, #$01EC, #$01EE, #$01F1, #$01F4,
    #$01F6..#$01F8, #$01FA, #$01FC, #$01FE, #$0200, #$0202,
    #$0204, #$0206, #$0208, #$020A, #$020C, #$020E, #$0210,
    #$0212, #$0214, #$0216, #$0218, #$021A, #$021C, #$021E,
    #$0220, #$0222, #$0224, #$0226, #$0228, #$022A, #$022C,
    #$022E, #$0230, #$0232, #$0386, #$0388..#$038A, #$038C,
    #$038E..#$038F, #$0391..#$03A1, #$03A3..#$03AB, #$03D2..#$03D4,
    #$03D8, #$03DA, #$03DC, #$03DE, #$03E0, #$03E2, #$03E4,
    #$03E6, #$03E8, #$03EA, #$03EC, #$03EE, #$03F4, #$03F7,
    #$03F9..#$03FA, #$0400..#$042F, #$0460, #$0462, #$0464,
    #$0466, #$0468, #$046A, #$046C, #$046E, #$0470, #$0472,
    #$0474, #$0476, #$0478, #$047A, #$047C, #$047E, #$0480,
    #$048A, #$048C, #$048E, #$0490, #$0492, #$0494, #$0496,
    #$0498, #$049A, #$049C, #$049E, #$04A0, #$04A2, #$04A4,
    #$04A6, #$04A8, #$04AA, #$04AC, #$04AE, #$04B0, #$04B2,
    #$04B4, #$04B6, #$04B8, #$04BA, #$04BC, #$04BE, #$04C0..#$04C1,
    #$04C3, #$04C5, #$04C7, #$04C9, #$04CB, #$04CD, #$04D0,
    #$04D2, #$04D4, #$04D6, #$04D8, #$04DA, #$04DC, #$04DE,
    #$04E0, #$04E2, #$04E4, #$04E6, #$04E8, #$04EA, #$04EC,
    #$04EE, #$04F0, #$04F2, #$04F4, #$04F8, #$0500, #$0502,
    #$0504, #$0506, #$0508, #$050A, #$050C, #$050E, #$0531..#$0556,
    #$10A0..#$10C5, #$1E00, #$1E02, #$1E04, #$1E06, #$1E08,
    #$1E0A, #$1E0C, #$1E0E, #$1E10, #$1E12, #$1E14, #$1E16,
    #$1E18, #$1E1A, #$1E1C, #$1E1E, #$1E20, #$1E22, #$1E24,
    #$1E26, #$1E28, #$1E2A, #$1E2C, #$1E2E, #$1E30, #$1E32,
    #$1E34, #$1E36, #$1E38, #$1E3A, #$1E3C, #$1E3E, #$1E40,
    #$1E42, #$1E44, #$1E46, #$1E48, #$1E4A, #$1E4C, #$1E4E,
    #$1E50, #$1E52, #$1E54, #$1E56, #$1E58, #$1E5A, #$1E5C,
    #$1E5E, #$1E60, #$1E62, #$1E64, #$1E66, #$1E68, #$1E6A,
    #$1E6C, #$1E6E, #$1E70, #$1E72, #$1E74, #$1E76, #$1E78,
    #$1E7A, #$1E7C, #$1E7E, #$1E80, #$1E82, #$1E84, #$1E86,
    #$1E88, #$1E8A, #$1E8C, #$1E8E, #$1E90, #$1E92, #$1E94,
    #$1EA0, #$1EA2, #$1EA4, #$1EA6, #$1EA8, #$1EAA, #$1EAC,
    #$1EAE, #$1EB0, #$1EB2, #$1EB4, #$1EB6, #$1EB8, #$1EBA,
    #$1EBC, #$1EBE, #$1EC0, #$1EC2, #$1EC4, #$1EC6, #$1EC8,
    #$1ECA, #$1ECC, #$1ECE, #$1ED0, #$1ED2, #$1ED4, #$1ED6,
    #$1ED8, #$1EDA, #$1EDC, #$1EDE, #$1EE0, #$1EE2, #$1EE4,
    #$1EE6, #$1EE8, #$1EEA, #$1EEC, #$1EEE, #$1EF0, #$1EF2,
    #$1EF4, #$1EF6, #$1EF8, #$1F08..#$1F0F, #$1F18..#$1F1D,
    #$1F28..#$1F2F, #$1F38..#$1F3F, #$1F48..#$1F4D, #$1F59,
    #$1F5B, #$1F5D, #$1F5F, #$1F68..#$1F6F, #$1FB8..#$1FBB,
    #$1FC8..#$1FCB, #$1FD8..#$1FDB, #$1FE8..#$1FEC, #$1FF8..#$1FFB,
    #$2102, #$2107, #$210B..#$210D, #$2110..#$2112, #$2115,
    #$2119..#$211D, #$2124, #$2126, #$2128, #$212A..#$212D,
    #$2130..#$2131, #$2133, #$213E..#$213F, #$2145, #$FF21..#$FF3A:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterLowerCaseW(const c: WideChar): Boolean;
begin
  case c of
    #$0061..#$007A, #$00AA, #$00B5, #$00BA, #$00DF..#$00F6,
    #$00F8..#$00FF, #$0101, #$0103, #$0105, #$0107, #$0109,
    #$010B, #$010D, #$010F, #$0111, #$0113, #$0115, #$0117,
    #$0119, #$011B, #$011D, #$011F, #$0121, #$0123, #$0125,
    #$0127, #$0129, #$012B, #$012D, #$012F, #$0131, #$0133,
    #$0135, #$0137..#$0138, #$013A, #$013C, #$013E, #$0140,
    #$0142, #$0144, #$0146, #$0148..#$0149, #$014B, #$014D,
    #$014F, #$0151, #$0153, #$0155, #$0157, #$0159, #$015B,
    #$015D, #$015F, #$0161, #$0163, #$0165, #$0167, #$0169,
    #$016B, #$016D, #$016F, #$0171, #$0173, #$0175, #$0177,
    #$017A, #$017C, #$017E..#$0180, #$0183, #$0185, #$0188,
    #$018C..#$018D, #$0192, #$0195, #$0199..#$019B, #$019E,
    #$01A1, #$01A3, #$01A5, #$01A8, #$01AA..#$01AB, #$01AD,
    #$01B0, #$01B4, #$01B6, #$01B9..#$01BA, #$01BD..#$01BF,
    #$01C6, #$01C9, #$01CC, #$01CE, #$01D0, #$01D2, #$01D4,
    #$01D6, #$01D8, #$01DA, #$01DC..#$01DD, #$01DF, #$01E1,
    #$01E3, #$01E5, #$01E7, #$01E9, #$01EB, #$01ED, #$01EF..#$01F0,
    #$01F3, #$01F5, #$01F9, #$01FB, #$01FD, #$01FF, #$0201,
    #$0203, #$0205, #$0207, #$0209, #$020B, #$020D, #$020F,
    #$0211, #$0213, #$0215, #$0217, #$0219, #$021B, #$021D,
    #$021F, #$0221, #$0223, #$0225, #$0227, #$0229, #$022B,
    #$022D, #$022F, #$0231, #$0233..#$0236, #$0250..#$02AF,
    #$0390, #$03AC..#$03CE, #$03D0..#$03D1, #$03D5..#$03D7,
    #$03D9, #$03DB, #$03DD, #$03DF, #$03E1, #$03E3, #$03E5,
    #$03E7, #$03E9, #$03EB, #$03ED, #$03EF..#$03F3, #$03F5,
    #$03F8, #$03FB, #$0430..#$045F, #$0461, #$0463, #$0465,
    #$0467, #$0469, #$046B, #$046D, #$046F, #$0471, #$0473,
    #$0475, #$0477, #$0479, #$047B, #$047D, #$047F, #$0481,
    #$048B, #$048D, #$048F, #$0491, #$0493, #$0495, #$0497,
    #$0499, #$049B, #$049D, #$049F, #$04A1, #$04A3, #$04A5,
    #$04A7, #$04A9, #$04AB, #$04AD, #$04AF, #$04B1, #$04B3,
    #$04B5, #$04B7, #$04B9, #$04BB, #$04BD, #$04BF, #$04C2,
    #$04C4, #$04C6, #$04C8, #$04CA, #$04CC, #$04CE, #$04D1,
    #$04D3, #$04D5, #$04D7, #$04D9, #$04DB, #$04DD, #$04DF,
    #$04E1, #$04E3, #$04E5, #$04E7, #$04E9, #$04EB, #$04ED,
    #$04EF, #$04F1, #$04F3, #$04F5, #$04F9, #$0501, #$0503,
    #$0505, #$0507, #$0509, #$050B, #$050D, #$050F, #$0561..#$0587,
    #$1D00..#$1D2B, #$1D62..#$1D6B, #$1E01, #$1E03, #$1E05,
    #$1E07, #$1E09, #$1E0B, #$1E0D, #$1E0F, #$1E11, #$1E13,
    #$1E15, #$1E17, #$1E19, #$1E1B, #$1E1D, #$1E1F, #$1E21,
    #$1E23, #$1E25, #$1E27, #$1E29, #$1E2B, #$1E2D, #$1E2F,
    #$1E31, #$1E33, #$1E35, #$1E37, #$1E39, #$1E3B, #$1E3D,
    #$1E3F, #$1E41, #$1E43, #$1E45, #$1E47, #$1E49, #$1E4B,
    #$1E4D, #$1E4F, #$1E51, #$1E53, #$1E55, #$1E57, #$1E59,
    #$1E5B, #$1E5D, #$1E5F, #$1E61, #$1E63, #$1E65, #$1E67,
    #$1E69, #$1E6B, #$1E6D, #$1E6F, #$1E71, #$1E73, #$1E75,
    #$1E77, #$1E79, #$1E7B, #$1E7D, #$1E7F, #$1E81, #$1E83,
    #$1E85, #$1E87, #$1E89, #$1E8B, #$1E8D, #$1E8F, #$1E91,
    #$1E93, #$1E95..#$1E9B, #$1EA1, #$1EA3, #$1EA5, #$1EA7,
    #$1EA9, #$1EAB, #$1EAD, #$1EAF, #$1EB1, #$1EB3, #$1EB5,
    #$1EB7, #$1EB9, #$1EBB, #$1EBD, #$1EBF, #$1EC1, #$1EC3,
    #$1EC5, #$1EC7, #$1EC9, #$1ECB, #$1ECD, #$1ECF, #$1ED1,
    #$1ED3, #$1ED5, #$1ED7, #$1ED9, #$1EDB, #$1EDD, #$1EDF,
    #$1EE1, #$1EE3, #$1EE5, #$1EE7, #$1EE9, #$1EEB, #$1EED,
    #$1EEF, #$1EF1, #$1EF3, #$1EF5, #$1EF7, #$1EF9, #$1F00..#$1F07,
    #$1F10..#$1F15, #$1F20..#$1F27, #$1F30..#$1F37, #$1F40..#$1F45,
    #$1F50..#$1F57, #$1F60..#$1F67, #$1F70..#$1F7D, #$1F80..#$1F87,
    #$1F90..#$1F97, #$1FA0..#$1FA7, #$1FB0..#$1FB4, #$1FB6..#$1FB7,
    #$1FBE, #$1FC2..#$1FC4, #$1FC6..#$1FC7, #$1FD0..#$1FD3,
    #$1FD6..#$1FD7, #$1FE0..#$1FE7, #$1FF2..#$1FF4, #$1FF6..#$1FF7,
    #$2071, #$207F, #$210A, #$210E..#$210F, #$2113, #$212F,
    #$2134, #$2139, #$213D, #$2146..#$2149, #$FB00..#$FB06,
    #$FB13..#$FB17, #$FF41..#$FF5A:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterTitleCaseW(const c: WideChar): Boolean;
begin
  case c of
    #$01C5, #$01C8, #$01CB, #$01F2, #$1F88..#$1F8F, #$1F98..#$1F9F,
    #$1FA8..#$1FAF, #$1FBC, #$1FCC, #$1FFC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterModifierW(const c: WideChar): Boolean;
begin
  case c of
    #$02B0..#$02C1, #$02C6..#$02D1, #$02E0..#$02E4, #$02EE,
    #$037A, #$0559, #$0640, #$06E5..#$06E6, #$0E46, #$0EC6,
    #$17D7, #$1843, #$1D2C..#$1D61, #$3005, #$3031..#$3035,
    #$303B, #$309D..#$309E, #$30FC..#$30FE, #$FF70, #$FF9F:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsLetterOtherW(const c: WideChar): Boolean;
begin
  case c of
    #$01BB, #$01C0..#$01C3, #$05D0..#$05EA, #$05F0..#$05F2,
    #$0621..#$063A, #$0641..#$064A, #$066E..#$066F, #$0671..#$06D3,
    #$06D5, #$06EE..#$06EF, #$06FA..#$06FC, #$06FF, #$0710,
    #$0712..#$072F, #$074D..#$074F, #$0780..#$07A5, #$07B1,
    #$0904..#$0939, #$093D, #$0950, #$0958..#$0961, #$0985..#$098C,
    #$098F..#$0990, #$0993..#$09A8, #$09AA..#$09B0, #$09B2,
    #$09B6..#$09B9, #$09BD, #$09DC..#$09DD, #$09DF..#$09E1,
    #$09F0..#$09F1, #$0A05..#$0A0A, #$0A0F..#$0A10, #$0A13..#$0A28,
    #$0A2A..#$0A30, #$0A32..#$0A33, #$0A35..#$0A36, #$0A38..#$0A39,
    #$0A59..#$0A5C, #$0A5E, #$0A72..#$0A74, #$0A85..#$0A8D,
    #$0A8F..#$0A91, #$0A93..#$0AA8, #$0AAA..#$0AB0, #$0AB2..#$0AB3,
    #$0AB5..#$0AB9, #$0ABD, #$0AD0, #$0AE0..#$0AE1, #$0B05..#$0B0C,
    #$0B0F..#$0B10, #$0B13..#$0B28, #$0B2A..#$0B30, #$0B32..#$0B33,
    #$0B35..#$0B39, #$0B3D, #$0B5C..#$0B5D, #$0B5F..#$0B61,
    #$0B71, #$0B83, #$0B85..#$0B8A, #$0B8E..#$0B90, #$0B92..#$0B95,
    #$0B99..#$0B9A, #$0B9C, #$0B9E..#$0B9F, #$0BA3..#$0BA4,
    #$0BA8..#$0BAA, #$0BAE..#$0BB5, #$0BB7..#$0BB9, #$0C05..#$0C0C,
    #$0C0E..#$0C10, #$0C12..#$0C28, #$0C2A..#$0C33, #$0C35..#$0C39,
    #$0C60..#$0C61, #$0C85..#$0C8C, #$0C8E..#$0C90, #$0C92..#$0CA8,
    #$0CAA..#$0CB3, #$0CB5..#$0CB9, #$0CBD, #$0CDE, #$0CE0..#$0CE1,
    #$0D05..#$0D0C, #$0D0E..#$0D10, #$0D12..#$0D28, #$0D2A..#$0D39,
    #$0D60..#$0D61, #$0D85..#$0D96, #$0D9A..#$0DB1, #$0DB3..#$0DBB,
    #$0DBD, #$0DC0..#$0DC6, #$0E01..#$0E30, #$0E32..#$0E33,
    #$0E40..#$0E45, #$0E81..#$0E82, #$0E84, #$0E87..#$0E88,
    #$0E8A, #$0E8D, #$0E94..#$0E97, #$0E99..#$0E9F, #$0EA1..#$0EA3,
    #$0EA5, #$0EA7, #$0EAA..#$0EAB, #$0EAD..#$0EB0, #$0EB2..#$0EB3,
    #$0EBD, #$0EC0..#$0EC4, #$0EDC..#$0EDD, #$0F00, #$0F40..#$0F47,
    #$0F49..#$0F6A, #$0F88..#$0F8B, #$1000..#$1021, #$1023..#$1027,
    #$1029..#$102A, #$1050..#$1055, #$10D0..#$10F8, #$1100..#$1159,
    #$115F..#$11A2, #$11A8..#$11F9, #$1200..#$1206, #$1208..#$1246,
    #$1248, #$124A..#$124D, #$1250..#$1256, #$1258, #$125A..#$125D,
    #$1260..#$1286, #$1288, #$128A..#$128D, #$1290..#$12AE,
    #$12B0, #$12B2..#$12B5, #$12B8..#$12BE, #$12C0, #$12C2..#$12C5,
    #$12C8..#$12CE, #$12D0..#$12D6, #$12D8..#$12EE, #$12F0..#$130E,
    #$1310, #$1312..#$1315, #$1318..#$131E, #$1320..#$1346,
    #$1348..#$135A, #$13A0..#$13F4, #$1401..#$166C, #$166F..#$1676,
    #$1681..#$169A, #$16A0..#$16EA, #$1700..#$170C, #$170E..#$1711,
    #$1720..#$1731, #$1740..#$1751, #$1760..#$176C, #$176E..#$1770,
    #$1780..#$17B3, #$17DC, #$1820..#$1842, #$1844..#$1877,
    #$1880..#$18A8, #$1900..#$191C, #$1950..#$196D, #$1970..#$1974,
    #$2135..#$2138, #$3006, #$303C, #$3041..#$3096, #$309F,
    #$30A1..#$30FA, #$30FF, #$3105..#$312C, #$3131..#$318E,
    #$31A0..#$31B7, #$31F0..#$31FF, #$3400, #$4DB5, #$4E00,
    #$9FA5, #$A000..#$A48C, #$AC00, #$D7A3, #$F900..#$FA2D,
    #$FA30..#$FA6A, #$FB1D, #$FB1F..#$FB28, #$FB2A..#$FB36,
    #$FB38..#$FB3C, #$FB3E, #$FB40..#$FB41, #$FB43..#$FB44,
    #$FB46..#$FBB1, #$FBD3..#$FD3D, #$FD50..#$FD8F, #$FD92..#$FDC7,
    #$FDF0..#$FDFB, #$FE70..#$FE74, #$FE76..#$FEFC, #$FF66..#$FF6F,
    #$FF71..#$FF9D, #$FFA0..#$FFBE, #$FFC2..#$FFC7, #$FFCA..#$FFCF,
    #$FFD2..#$FFD7, #$FFDA..#$FFDC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsMarkW(const c: WideChar): Boolean;
begin
  case c of
    #$0300..#$0357, #$035D..#$036F, #$0483..#$0486, #$0488..#$0489,
    #$0591..#$05A1, #$05A3..#$05B9, #$05BB..#$05BD, #$05BF,
    #$05C1..#$05C2, #$05C4, #$0610..#$0615, #$064B..#$0658,
    #$0670, #$06D6..#$06DC, #$06DE..#$06E4, #$06E7..#$06E8,
    #$06EA..#$06ED, #$0711, #$0730..#$074A, #$07A6..#$07B0,
    #$0901..#$0903, #$093C, #$093E..#$094D, #$0951..#$0954,
    #$0962..#$0963, #$0981..#$0983, #$09BC, #$09BE..#$09C4,
    #$09C7..#$09C8, #$09CB..#$09CD, #$09D7, #$09E2..#$09E3,
    #$0A01..#$0A03, #$0A3C, #$0A3E..#$0A42, #$0A47..#$0A48,
    #$0A4B..#$0A4D, #$0A70..#$0A71, #$0A81..#$0A83, #$0ABC,
    #$0ABE..#$0AC5, #$0AC7..#$0AC9, #$0ACB..#$0ACD, #$0AE2..#$0AE3,
    #$0B01..#$0B03, #$0B3C, #$0B3E..#$0B43, #$0B47..#$0B48,
    #$0B4B..#$0B4D, #$0B56..#$0B57, #$0B82, #$0BBE..#$0BC2,
    #$0BC6..#$0BC8, #$0BCA..#$0BCD, #$0BD7, #$0C01..#$0C03,
    #$0C3E..#$0C44, #$0C46..#$0C48, #$0C4A..#$0C4D, #$0C55..#$0C56,
    #$0C82..#$0C83, #$0CBC, #$0CBE..#$0CC4, #$0CC6..#$0CC8,
    #$0CCA..#$0CCD, #$0CD5..#$0CD6, #$0D02..#$0D03, #$0D3E..#$0D43,
    #$0D46..#$0D48, #$0D4A..#$0D4D, #$0D57, #$0D82..#$0D83,
    #$0DCA, #$0DCF..#$0DD4, #$0DD6, #$0DD8..#$0DDF, #$0DF2..#$0DF3,
    #$0E31, #$0E34..#$0E3A, #$0E47..#$0E4E, #$0EB1, #$0EB4..#$0EB9,
    #$0EBB..#$0EBC, #$0EC8..#$0ECD, #$0F18..#$0F19, #$0F35,
    #$0F37, #$0F39, #$0F3E..#$0F3F, #$0F71..#$0F84, #$0F86..#$0F87,
    #$0F90..#$0F97, #$0F99..#$0FBC, #$0FC6, #$102C..#$1032,
    #$1036..#$1039, #$1056..#$1059, #$1712..#$1714, #$1732..#$1734,
    #$1752..#$1753, #$1772..#$1773, #$17B6..#$17D3, #$17DD,
    #$180B..#$180D, #$18A9, #$1920..#$192B, #$1930..#$193B,
    #$20D0..#$20EA, #$302A..#$302F, #$3099..#$309A, #$FB1E,
    #$FE00..#$FE0F, #$FE20..#$FE23:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsMarkNon_SpacingW(const c: WideChar): Boolean;
begin
  case c of
    #$0300..#$0357, #$035D..#$036F, #$0483..#$0486, #$0591..#$05A1,
    #$05A3..#$05B9, #$05BB..#$05BD, #$05BF, #$05C1..#$05C2,
    #$05C4, #$0610..#$0615, #$064B..#$0658, #$0670, #$06D6..#$06DC,
    #$06DF..#$06E4, #$06E7..#$06E8, #$06EA..#$06ED, #$0711,
    #$0730..#$074A, #$07A6..#$07B0, #$0901..#$0902, #$093C,
    #$0941..#$0948, #$094D, #$0951..#$0954, #$0962..#$0963,
    #$0981, #$09BC, #$09C1..#$09C4, #$09CD, #$09E2..#$09E3,
    #$0A01..#$0A02, #$0A3C, #$0A41..#$0A42, #$0A47..#$0A48,
    #$0A4B..#$0A4D, #$0A70..#$0A71, #$0A81..#$0A82, #$0ABC,
    #$0AC1..#$0AC5, #$0AC7..#$0AC8, #$0ACD, #$0AE2..#$0AE3,
    #$0B01, #$0B3C, #$0B3F, #$0B41..#$0B43, #$0B4D, #$0B56,
    #$0B82, #$0BC0, #$0BCD, #$0C3E..#$0C40, #$0C46..#$0C48,
    #$0C4A..#$0C4D, #$0C55..#$0C56, #$0CBC, #$0CBF, #$0CC6,
    #$0CCC..#$0CCD, #$0D41..#$0D43, #$0D4D, #$0DCA, #$0DD2..#$0DD4,
    #$0DD6, #$0E31, #$0E34..#$0E3A, #$0E47..#$0E4E, #$0EB1,
    #$0EB4..#$0EB9, #$0EBB..#$0EBC, #$0EC8..#$0ECD, #$0F18..#$0F19,
    #$0F35, #$0F37, #$0F39, #$0F71..#$0F7E, #$0F80..#$0F84,
    #$0F86..#$0F87, #$0F90..#$0F97, #$0F99..#$0FBC, #$0FC6,
    #$102D..#$1030, #$1032, #$1036..#$1037, #$1039, #$1058..#$1059,
    #$1712..#$1714, #$1732..#$1734, #$1752..#$1753, #$1772..#$1773,
    #$17B7..#$17BD, #$17C6, #$17C9..#$17D3, #$17DD, #$180B..#$180D,
    #$18A9, #$1920..#$1922, #$1927..#$1928, #$1932, #$1939..#$193B,
    #$20D0..#$20DC, #$20E1, #$20E5..#$20EA, #$302A..#$302F,
    #$3099..#$309A, #$FB1E, #$FE00..#$FE0F, #$FE20..#$FE23:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsMarkSpacing_CombinedW(const c: WideChar): Boolean;
begin
  case c of
    #$0903, #$093E..#$0940, #$0949..#$094C, #$0982..#$0983,
    #$09BE..#$09C0, #$09C7..#$09C8, #$09CB..#$09CC, #$09D7,
    #$0A03, #$0A3E..#$0A40, #$0A83, #$0ABE..#$0AC0, #$0AC9,
    #$0ACB..#$0ACC, #$0B02..#$0B03, #$0B3E, #$0B40, #$0B47..#$0B48,
    #$0B4B..#$0B4C, #$0B57, #$0BBE..#$0BBF, #$0BC1..#$0BC2,
    #$0BC6..#$0BC8, #$0BCA..#$0BCC, #$0BD7, #$0C01..#$0C03,
    #$0C41..#$0C44, #$0C82..#$0C83, #$0CBE, #$0CC0..#$0CC4,
    #$0CC7..#$0CC8, #$0CCA..#$0CCB, #$0CD5..#$0CD6, #$0D02..#$0D03,
    #$0D3E..#$0D40, #$0D46..#$0D48, #$0D4A..#$0D4C, #$0D57,
    #$0D82..#$0D83, #$0DCF..#$0DD1, #$0DD8..#$0DDF, #$0DF2..#$0DF3,
    #$0F3E..#$0F3F, #$0F7F, #$102C, #$1031, #$1038, #$1056..#$1057,
    #$17B6, #$17BE..#$17C5, #$17C7..#$17C8, #$1923..#$1926,
    #$1929..#$192B, #$1930..#$1931, #$1933..#$1938:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsMarkEnclosingW(const c: WideChar): Boolean;
begin
  case c of
    #$0488..#$0489, #$06DE, #$20DD..#$20E0, #$20E2..#$20E4:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsNumberW(const c: WideChar): Boolean;
begin
  case c of
    #$0030..#$0039, #$00B2..#$00B3, #$00B9, #$00BC..#$00BE,
    #$0660..#$0669, #$06F0..#$06F9, #$0966..#$096F, #$09E6..#$09EF,
    #$09F4..#$09F9, #$0A66..#$0A6F, #$0AE6..#$0AEF, #$0B66..#$0B6F,
    #$0BE7..#$0BF2, #$0C66..#$0C6F, #$0CE6..#$0CEF, #$0D66..#$0D6F,
    #$0E50..#$0E59, #$0ED0..#$0ED9, #$0F20..#$0F33, #$1040..#$1049,
    #$1369..#$137C, #$16EE..#$16F0, #$17E0..#$17E9, #$17F0..#$17F9,
    #$1810..#$1819, #$1946..#$194F, #$2070, #$2074..#$2079,
    #$2080..#$2089, #$2153..#$2183, #$2460..#$249B, #$24EA..#$24FF,
    #$2776..#$2793, #$3007, #$3021..#$3029, #$3038..#$303A,
    #$3192..#$3195, #$3220..#$3229, #$3251..#$325F, #$3280..#$3289,
    #$32B1..#$32BF, #$FF10..#$FF19:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsNumber_DecimalW(const c: WideChar): Boolean;
begin
  case c of
    #$0030..#$0039, #$0660..#$0669, #$06F0..#$06F9, #$0966..#$096F,
    #$09E6..#$09EF, #$0A66..#$0A6F, #$0AE6..#$0AEF, #$0B66..#$0B6F,
    #$0BE7..#$0BEF, #$0C66..#$0C6F, #$0CE6..#$0CEF, #$0D66..#$0D6F,
    #$0E50..#$0E59, #$0ED0..#$0ED9, #$0F20..#$0F29, #$1040..#$1049,
    #$1369..#$1371, #$17E0..#$17E9, #$1810..#$1819, #$1946..#$194F,
    #$FF10..#$FF19:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsNumber_LetterW(const c: WideChar): Boolean;
begin
  case c of
    #$16EE..#$16F0, #$2160..#$2183, #$3007, #$3021..#$3029,
    #$3038..#$303A:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsNumber_OtherW(const c: WideChar): Boolean;
begin
  case c of
    #$00B2..#$00B3, #$00B9, #$00BC..#$00BE, #$09F4..#$09F9,
    #$0BF0..#$0BF2, #$0F2A..#$0F33, #$1372..#$137C, #$17F0..#$17F9,
    #$2070, #$2074..#$2079, #$2080..#$2089, #$2153..#$215F,
    #$2460..#$249B, #$24EA..#$24FF, #$2776..#$2793, #$3192..#$3195,
    #$3220..#$3229, #$3251..#$325F, #$3280..#$3289, #$32B1..#$32BF:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuationW(const c: WideChar): Boolean;
begin
  case c of
    #$0021..#$0023, #$0025..#$002A, #$002C..#$002F, #$003A..#$003B,
    #$003F..#$0040, #$005B..#$005D, #$005F, #$007B, #$007D,
    #$00A1, #$00AB, #$00B7, #$00BB, #$00BF, #$037E, #$0387,
    #$055A..#$055F, #$0589..#$058A, #$05BE, #$05C0, #$05C3,
    #$05F3..#$05F4, #$060C..#$060D, #$061B, #$061F, #$066A..#$066D,
    #$06D4, #$0700..#$070D, #$0964..#$0965, #$0970, #$0DF4,
    #$0E4F, #$0E5A..#$0E5B, #$0F04..#$0F12, #$0F3A..#$0F3D,
    #$0F85, #$104A..#$104F, #$10FB, #$1361..#$1368, #$166D..#$166E,
    #$169B..#$169C, #$16EB..#$16ED, #$1735..#$1736, #$17D4..#$17D6,
    #$17D8..#$17DA, #$1800..#$180A, #$1944..#$1945, #$2010..#$2027,
    #$2030..#$2043, #$2045..#$2051, #$2053..#$2054, #$2057,
    #$207D..#$207E, #$208D..#$208E, #$2329..#$232A, #$23B4..#$23B6,
    #$2768..#$2775, #$27E6..#$27EB, #$2983..#$2998, #$29D8..#$29DB,
    #$29FC..#$29FD, #$3001..#$3003, #$3008..#$3011, #$3014..#$301F,
    #$3030, #$303D, #$30A0, #$30FB, #$FD3E..#$FD3F, #$FE30..#$FE52,
    #$FE54..#$FE61, #$FE63, #$FE68, #$FE6A..#$FE6B, #$FF01..#$FF03,
    #$FF05..#$FF0A, #$FF0C..#$FF0F, #$FF1A..#$FF1B, #$FF1F..#$FF20,
    #$FF3B..#$FF3D, #$FF3F, #$FF5B, #$FF5D, #$FF5F..#$FF65:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_ConnectorW(const c: WideChar): Boolean;
begin
  case c of
    #$005F, #$203F..#$2040, #$2054, #$30FB, #$FE33..#$FE34,
    #$FE4D..#$FE4F, #$FF3F, #$FF65:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_DashW(const c: WideChar): Boolean;
begin
  case c of
    #$002D, #$058A, #$1806, #$2010..#$2015, #$301C, #$3030,
    #$30A0, #$FE31..#$FE32, #$FE58, #$FE63, #$FF0D:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_OpenW(const c: WideChar): Boolean;
begin
  case c of
    #$0028, #$005B, #$007B, #$0F3A, #$0F3C, #$169B, #$201A,
    #$201E, #$2045, #$207D, #$208D, #$2329, #$23B4, #$2768,
    #$276A, #$276C, #$276E, #$2770, #$2772, #$2774, #$27E6,
    #$27E8, #$27EA, #$2983, #$2985, #$2987, #$2989, #$298B,
    #$298D, #$298F, #$2991, #$2993, #$2995, #$2997, #$29D8,
    #$29DA, #$29FC, #$3008, #$300A, #$300C, #$300E, #$3010,
    #$3014, #$3016, #$3018, #$301A, #$301D, #$FD3E, #$FE35,
    #$FE37, #$FE39, #$FE3B, #$FE3D, #$FE3F, #$FE41, #$FE43,
    #$FE47, #$FE59, #$FE5B, #$FE5D, #$FF08, #$FF3B, #$FF5B,
    #$FF5F, #$FF62:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_CloseW(const c: WideChar): Boolean;
begin
  case c of
    #$0029, #$005D, #$007D, #$0F3B, #$0F3D, #$169C, #$2046,
    #$207E, #$208E, #$232A, #$23B5, #$2769, #$276B, #$276D,
    #$276F, #$2771, #$2773, #$2775, #$27E7, #$27E9, #$27EB,
    #$2984, #$2986, #$2988, #$298A, #$298C, #$298E, #$2990,
    #$2992, #$2994, #$2996, #$2998, #$29D9, #$29DB, #$29FD,
    #$3009, #$300B, #$300D, #$300F, #$3011, #$3015, #$3017,
    #$3019, #$301B, #$301E..#$301F, #$FD3F, #$FE36, #$FE38,
    #$FE3A, #$FE3C, #$FE3E, #$FE40, #$FE42, #$FE44, #$FE48,
    #$FE5A, #$FE5C, #$FE5E, #$FF09, #$FF3D, #$FF5D, #$FF60,
    #$FF63:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_InitialQuoteW(const c: WideChar): Boolean;
begin
  case c of
    #$00AB, #$2018, #$201B..#$201C, #$201F, #$2039:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_FinalQuoteW(const c: WideChar): Boolean;
begin
  case c of
    #$00BB, #$2019, #$201D, #$203A:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsPunctuation_OtherW(const c: WideChar): Boolean;
begin
  case c of
    #$0021..#$0023, #$0025..#$0027, #$002A, #$002C, #$002E..#$002F,
    #$003A..#$003B, #$003F..#$0040, #$005C, #$00A1, #$00B7,
    #$00BF, #$037E, #$0387, #$055A..#$055F, #$0589, #$05BE,
    #$05C0, #$05C3, #$05F3..#$05F4, #$060C..#$060D, #$061B,
    #$061F, #$066A..#$066D, #$06D4, #$0700..#$070D, #$0964..#$0965,
    #$0970, #$0DF4, #$0E4F, #$0E5A..#$0E5B, #$0F04..#$0F12,
    #$0F85, #$104A..#$104F, #$10FB, #$1361..#$1368, #$166D..#$166E,
    #$16EB..#$16ED, #$1735..#$1736, #$17D4..#$17D6, #$17D8..#$17DA,
    #$1800..#$1805, #$1807..#$180A, #$1944..#$1945, #$2016..#$2017,
    #$2020..#$2027, #$2030..#$2038, #$203B..#$203E, #$2041..#$2043,
    #$2047..#$2051, #$2053, #$2057, #$23B6, #$3001..#$3003,
    #$303D, #$FE30, #$FE45..#$FE46, #$FE49..#$FE4C, #$FE50..#$FE52,
    #$FE54..#$FE57, #$FE5F..#$FE61, #$FE68, #$FE6A..#$FE6B,
    #$FF01..#$FF03, #$FF05..#$FF07, #$FF0A, #$FF0C, #$FF0E..#$FF0F,
    #$FF1A..#$FF1B, #$FF1F..#$FF20, #$FF3C, #$FF61, #$FF64:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolW(const c: WideChar): Boolean;
begin
  case c of
    #$0024, #$002B, #$003C..#$003E, #$005E, #$0060, #$007C,
    #$007E, #$00A2..#$00A9, #$00AC, #$00AE..#$00B1, #$00B4,
    #$00B6, #$00B8, #$00D7, #$00F7, #$02C2..#$02C5, #$02D2..#$02DF,
    #$02E5..#$02ED, #$02EF..#$02FF, #$0374..#$0375, #$0384..#$0385,
    #$03F6, #$0482, #$060E..#$060F, #$06E9, #$06FD..#$06FE,
    #$09F2..#$09F3, #$09FA, #$0AF1, #$0B70, #$0BF3..#$0BFA,
    #$0E3F, #$0F01..#$0F03, #$0F13..#$0F17, #$0F1A..#$0F1F,
    #$0F34, #$0F36, #$0F38, #$0FBE..#$0FC5, #$0FC7..#$0FCC,
    #$0FCF, #$17DB, #$1940, #$19E0..#$19FF, #$1FBD, #$1FBF..#$1FC1,
    #$1FCD..#$1FCF, #$1FDD..#$1FDF, #$1FED..#$1FEF, #$1FFD..#$1FFE,
    #$2044, #$2052, #$207A..#$207C, #$208A..#$208C, #$20A0..#$20B1,
    #$2100..#$2101, #$2103..#$2106, #$2108..#$2109, #$2114,
    #$2116..#$2118, #$211E..#$2123, #$2125, #$2127, #$2129,
    #$212E, #$2132, #$213A..#$213B, #$2140..#$2144, #$214A..#$214B,
    #$2190..#$2328, #$232B..#$23B3, #$23B7..#$23D0, #$2400..#$2426,
    #$2440..#$244A, #$249C..#$24E9, #$2500..#$2617, #$2619..#$267D,
    #$2680..#$2691, #$26A0..#$26A1, #$2701..#$2704, #$2706..#$2709,
    #$270C..#$2727, #$2729..#$274B, #$274D, #$274F..#$2752,
    #$2756, #$2758..#$275E, #$2761..#$2767, #$2794, #$2798..#$27AF,
    #$27B1..#$27BE, #$27D0..#$27E5, #$27F0..#$2982, #$2999..#$29D7,
    #$29DC..#$29FB, #$29FE..#$2B0D, #$2E80..#$2E99, #$2E9B..#$2EF3,
    #$2F00..#$2FD5, #$2FF0..#$2FFB, #$3004, #$3012..#$3013,
    #$3020, #$3036..#$3037, #$303E..#$303F, #$309B..#$309C,
    #$3190..#$3191, #$3196..#$319F, #$3200..#$321E, #$322A..#$3243,
    #$3250, #$3260..#$327D, #$327F, #$328A..#$32B0, #$32C0..#$32FE,
    #$3300..#$33FF, #$4DC0..#$4DFF, #$A490..#$A4C6, #$FB29,
    #$FDFC..#$FDFD, #$FE62, #$FE64..#$FE66, #$FE69, #$FF04,
    #$FF0B, #$FF1C..#$FF1E, #$FF3E, #$FF40, #$FF5C, #$FF5E,
    #$FFE0..#$FFE6, #$FFE8..#$FFEE, #$FFFD:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolMathW(const c: WideChar): Boolean;
begin
  case c of
    #$002B, #$003C..#$003E, #$007C, #$007E, #$00AC, #$00B1,
    #$00D7, #$00F7, #$03F6, #$2044, #$2052, #$207A..#$207C,
    #$208A..#$208C, #$2140..#$2144, #$214B, #$2190..#$2194,
    #$219A..#$219B, #$21A0, #$21A3, #$21A6, #$21AE, #$21CE..#$21CF,
    #$21D2, #$21D4, #$21F4..#$22FF, #$2308..#$230B, #$2320..#$2321,
    #$237C, #$239B..#$23B3, #$25B7, #$25C1, #$25F8..#$25FF,
    #$266F, #$27D0..#$27E5, #$27F0..#$27FF, #$2900..#$2982,
    #$2999..#$29D7, #$29DC..#$29FB, #$29FE..#$2AFF, #$FB29,
    #$FE62, #$FE64..#$FE66, #$FF0B, #$FF1C..#$FF1E, #$FF5C,
    #$FF5E, #$FFE2, #$FFE9..#$FFEC:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolCurrencyW(const c: WideChar): Boolean;
begin
  case c of
    #$0024, #$00A2..#$00A5, #$09F2..#$09F3, #$0AF1, #$0BF9,
    #$0E3F, #$17DB, #$20A0..#$20B1, #$FDFC, #$FE69, #$FF04,
    #$FFE0..#$FFE1, #$FFE6:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolModifierW(const c: WideChar): Boolean;
begin
  case c of
    #$005E, #$0060, #$00A8, #$00AF, #$00B4, #$00B8, #$02C2..#$02C5,
    #$02D2..#$02DF, #$02E5..#$02ED, #$02EF..#$02FF, #$0374..#$0375,
    #$0384..#$0385, #$1FBD, #$1FBF..#$1FC1, #$1FCD..#$1FCF,
    #$1FDD..#$1FDF, #$1FED..#$1FEF, #$1FFD..#$1FFE, #$309B..#$309C,
    #$FF3E, #$FF40, #$FFE3:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSymbolOtherW(const c: WideChar): Boolean;
begin
  case c of
    #$00A6..#$00A7, #$00A9, #$00AE, #$00B0, #$00B6, #$0482,
    #$060E..#$060F, #$06E9, #$06FD..#$06FE, #$09FA, #$0B70,
    #$0BF3..#$0BF8, #$0BFA, #$0F01..#$0F03, #$0F13..#$0F17,
    #$0F1A..#$0F1F, #$0F34, #$0F36, #$0F38, #$0FBE..#$0FC5,
    #$0FC7..#$0FCC, #$0FCF, #$1940, #$19E0..#$19FF, #$2100..#$2101,
    #$2103..#$2106, #$2108..#$2109, #$2114, #$2116..#$2118,
    #$211E..#$2123, #$2125, #$2127, #$2129, #$212E, #$2132,
    #$213A..#$213B, #$214A, #$2195..#$2199, #$219C..#$219F,
    #$21A1..#$21A2, #$21A4..#$21A5, #$21A7..#$21AD, #$21AF..#$21CD,
    #$21D0..#$21D1, #$21D3, #$21D5..#$21F3, #$2300..#$2307,
    #$230C..#$231F, #$2322..#$2328, #$232B..#$237B, #$237D..#$239A,
    #$23B7..#$23D0, #$2400..#$2426, #$2440..#$244A, #$249C..#$24E9,
    #$2500..#$25B6, #$25B8..#$25C0, #$25C2..#$25F7, #$2600..#$2617,
    #$2619..#$266E, #$2670..#$267D, #$2680..#$2691, #$26A0..#$26A1,
    #$2701..#$2704, #$2706..#$2709, #$270C..#$2727, #$2729..#$274B,
    #$274D, #$274F..#$2752, #$2756, #$2758..#$275E, #$2761..#$2767,
    #$2794, #$2798..#$27AF, #$27B1..#$27BE, #$2800..#$28FF,
    #$2B00..#$2B0D, #$2E80..#$2E99, #$2E9B..#$2EF3, #$2F00..#$2FD5,
    #$2FF0..#$2FFB, #$3004, #$3012..#$3013, #$3020, #$3036..#$3037,
    #$303E..#$303F, #$3190..#$3191, #$3196..#$319F, #$3200..#$321E,
    #$322A..#$3243, #$3250, #$3260..#$327D, #$327F, #$328A..#$32B0,
    #$32C0..#$32FE, #$3300..#$33FF, #$4DC0..#$4DFF, #$A490..#$A4C6,
    #$FDFD, #$FFE4, #$FFE8, #$FFED..#$FFEE, #$FFFD:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSeparatorW(const c: WideChar): Boolean;
begin
  case c of
    #$0020, #$00A0, #$1680, #$180E, #$2000..#$200B, #$2028..#$2029,
    #$202F, #$205F, #$3000:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSeparatorSpaceW(const c: WideChar): Boolean;
begin
  case c of
    #$0020, #$00A0, #$1680, #$180E, #$2000..#$200B, #$202F,
    #$205F, #$3000:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSeparatorLineW(const c: WideChar): Boolean;
begin
  case c of
    #$2028:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsSeparatorParagraphW(const c: WideChar): Boolean;
begin
  case c of
    #$2029:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherW(const c: WideChar): Boolean;
begin
  case c of
    #$0000..#$001F, #$007F..#$009F, #$00AD, #$0600..#$0603,
    #$06DD, #$070F, #$17B4..#$17B5, #$200C..#$200F, #$202A..#$202E,
    #$2060..#$2063, #$206A..#$206F, #$D800, #$DB7F..#$DB80,
    #$DBFF..#$DC00, #$DFFF..#$E000, #$F8FF, #$FEFF, #$FFF9..#$FFFB:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherControlW(const c: WideChar): Boolean;
begin
  case c of
    #$0000..#$001F, #$007F..#$009F:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherFormatW(const c: WideChar): Boolean;
begin
  case c of
    #$00AD, #$0600..#$0603, #$06DD, #$070F, #$17B4..#$17B5,
    #$200C..#$200F, #$202A..#$202E, #$2060..#$2063, #$206A..#$206F,
    #$FEFF, #$FFF9..#$FFFB:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherSurrogateW(const c: WideChar): Boolean;
begin
  case c of
    #$D800, #$DB7F..#$DB80, #$DBFF..#$DC00, #$DFFF:
      Result := True;
  else
    Result := False;
  end;
end;

function CharIsOtherPrivateUseW(const c: WideChar): Boolean;
begin
  case c of
    #$E000, #$F8FF:
      Result := True;
  else
    Result := False;
  end;
end;

function CharCanonicalCombiningClassW(const Char: WideChar): Cardinal;
const
  CHAR_CANONICAL_COMBINING_CLASS_1: array[$0000..$07FF] of Byte = (
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $01, $02, $03, $04, $00, $00, $00, $00,
    $00, $00, $00, $00, $05, $00, $00, $00,
    $00, $00, $00, $00, $06, $07, $08, $00,
    $09, $00, $0A, $0B, $00, $00, $0C, $0D,
    $0E, $0F, $10, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $11, $12, $00, $00, $13, $14, $00,
    $00, $15, $16, $00, $00, $17, $18, $00,
    $00, $19, $1A, $00, $00, $00, $1B, $00,
    $00, $00, $1C, $00, $00, $1D, $1E, $00,
    $00, $00, $1F, $00, $00, $00, $20, $00,
    $00, $21, $22, $00, $00, $23, $24, $00,
    $25, $26, $00, $27, $28, $00, $29, $00,

    $00, $2A, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $2B, $2C, $00, $00, $00, $00, $2D, $00,

    $00, $00, $00, $00, $00, $2E, $00, $00,
    $00, $2F, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $30, $31,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $32, $00, $00, $33, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $34, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $35, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00);
  CHAR_CANONICAL_COMBINING_CLASS_2: array[$0000..$0034, $0000..$001F] of Byte = (

    ($E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E8, $DC, $DC,
    $DC, $DC, $E8, $D8, $DC, $DC, $DC, $DC),

    ($DC, $CA, $CA, $DC, $DC, $DC, $DC, $CA,
    $CA, $DC, $DC, $DC, $DC, $DC, $DC, $DC,
    $DC, $DC, $DC, $DC, $01, $01, $01, $01,
    $01, $DC, $DC, $DC, $DC, $E6, $E6, $E6),

    ($E6, $E6, $E6, $E6, $E6, $F0, $E6, $DC,
    $DC, $DC, $E6, $E6, $E6, $DC, $DC, $00,
    $E6, $E6, $E6, $DC, $DC, $DC, $DC, $E6,
    $00, $00, $00, $00, $00, $EA, $EA, $E9),

    ($EA, $EA, $E9, $E6, $E6, $E6, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $E6, $E6, $E6,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $E6, $E6, $E6, $E6, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $DC, $E6, $E6, $E6, $E6, $DC, $E6,
    $E6, $E6, $DE, $DC, $E6, $E6, $E6, $E6),

    ($E6, $E6, $00, $DC, $DC, $DC, $DC, $DC,
    $E6, $E6, $DC, $E6, $E6, $DE, $E4, $E6,
    $0A, $0B, $0C, $0D, $0E, $0F, $10, $11,
    $12, $13, $00, $14, $15, $16, $00, $17),

    ($00, $18, $19, $00, $E6, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $E6, $E6, $E6, $E6, $E6, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $1B, $1C, $1D, $1E, $1F,
    $20, $21, $22, $E6, $E6, $DC, $DC, $E6,
    $E6, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $23, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $E6, $E6,
    $E6, $E6, $E6, $E6, $E6, $00, $00, $E6),

    ($E6, $E6, $E6, $DC, $E6, $00, $00, $E6,
    $E6, $00, $DC, $E6, $E6, $DC, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $24, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $DC, $E6, $E6, $DC, $E6, $E6, $DC,
    $DC, $DC, $E6, $DC, $DC, $E6, $DC, $E6),

    ($E6, $E6, $DC, $E6, $DC, $E6, $DC, $E6,
    $DC, $E6, $E6, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $E6, $DC, $E6, $E6, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $54, $5B, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $07, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $09, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $09, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $67, $67, $09, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $6B, $6B, $6B, $6B, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $76, $76, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $7A, $7A, $7A, $7A, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $DC, $DC, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $DC, $00, $DC,
    $00, $D8, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $81, $82, $00, $84, $00, $00, $00,
    $00, $00, $82, $82, $82, $82, $00, $00),

    ($82, $00, $E6, $E6, $09, $00, $E6, $E6,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $DC, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $07,
    $00, $09, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $09, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $09, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $09, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $E6, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $E4, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $DE, $E6, $DC, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $E6, $E6, $01, $01, $E6, $E6, $E6, $E6,
    $01, $01, $01, $E6, $E6, $00, $00, $00),

    ($00, $E6, $00, $00, $00, $01, $01, $E6,
    $DC, $E6, $01, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $DA, $E4, $E8, $DE, $E0, $E0,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $08, $08, $00, $00, $00, $00, $00),

    ($00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $1A, $00),

    ($E6, $E6, $E6, $E6, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00));
  CHAR_CANONICAL_COMBINING_CLASS_SIZE = 32;
begin
  Result := CHAR_CANONICAL_COMBINING_CLASS_1[Ord(Char) div CHAR_CANONICAL_COMBINING_CLASS_SIZE];
  if Result <> 0 then
    begin
      Dec(Result);
      Result := CHAR_CANONICAL_COMBINING_CLASS_2[Result, Ord(Char) and (CHAR_CANONICAL_COMBINING_CLASS_SIZE - 1)];
    end;
end;

function CharDecomposeCanonicalW(const Char: WideChar): PCharDecompositionW;
const
  CHAR_CANONICAL_DECOMPOSITION_1: array[$0000..$07FF] of Byte = (
    $00, $00, $00, $00, $00, $00, $01, $02,
    $03, $04, $05, $06, $00, $07, $08, $09,
    $0A, $0B, $00, $00, $00, $00, $00, $00,
    $00, $00, $0C, $0D, $0E, $0F, $10, $00,
    $11, $12, $13, $14, $00, $00, $15, $16,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $17, $00, $00, $00, $00, $18, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $19, $1A, $00, $00, $00, $1B, $00,
    $00, $1C, $1D, $00, $00, $00, $00, $00,
    $00, $00, $1E, $00, $1F, $00, $20, $00,
    $00, $00, $21, $00, $00, $00, $22, $00,
    $00, $00, $23, $00, $00, $00, $24, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $25, $26, $27, $28, $00, $00,

    $00, $29, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $2A, $2B, $2C, $2D, $2E, $2F, $30, $31,
    $32, $33, $34, $35, $36, $37, $38, $39,

    $3A, $00, $00, $00, $00, $00, $00, $00,
    $00, $3B, $00, $00, $3C, $3D, $3E, $00,
    $3F, $40, $41, $42, $43, $44, $00, $45,
    $00, $46, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $47, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $48, $49, $4A, $4B, $4C, $4D,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $4E, $4F, $50, $51, $52, $53, $54, $55,
    $56, $57, $58, $59, $00, $00, $00, $00,
    $5A, $5B, $5C, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00);
  CHAR_CANONICAL_DECOMPOSITION_2: array[$0000..$005B, $0000..$001F] of Word = (

    ($0001, $0006, $000B, $0010, $0015, $001A, $0000, $001F,
    $0024, $0029, $002E, $0033, $0038, $003D, $0042, $0047,
    $0000, $004C, $0051, $0056, $005B, $0060, $0065, $0000,
    $0000, $006A, $006F, $0074, $0079, $007E, $0000, $0000),

    ($0083, $0088, $008D, $0092, $0097, $009C, $0000, $00A1,
    $00A6, $00AB, $00B0, $00B5, $00BA, $00BF, $00C4, $00C9,
    $0000, $00CE, $00D3, $00D8, $00DD, $00E2, $00E7, $0000,
    $0000, $00EC, $00F1, $00F6, $00FB, $0100, $0000, $0105),

    ($010A, $010F, $0114, $0119, $011E, $0123, $0128, $012D,
    $0132, $0137, $013C, $0141, $0146, $014B, $0150, $0155,
    $0000, $0000, $015A, $015F, $0164, $0169, $016E, $0173,
    $0178, $017D, $0182, $0187, $018C, $0191, $0196, $019B),

    ($01A0, $01A5, $01AA, $01AF, $01B4, $01B9, $0000, $0000,
    $01BE, $01C3, $01C8, $01CD, $01D2, $01D7, $01DC, $01E1,
    $01E6, $0000, $0000, $0000, $01EB, $01F0, $01F5, $01FA,
    $0000, $01FF, $0204, $0209, $020E, $0213, $0218, $0000),

    ($0000, $0000, $0000, $021D, $0222, $0227, $022C, $0231,
    $0236, $0000, $0000, $0000, $023B, $0240, $0245, $024A,
    $024F, $0254, $0000, $0000, $0259, $025E, $0263, $0268,
    $026D, $0272, $0277, $027C, $0281, $0286, $028B, $0290),

    ($0295, $029A, $029F, $02A4, $02A9, $02AE, $0000, $0000,
    $02B3, $02B8, $02BD, $02C2, $02C7, $02CC, $02D1, $02D6,
    $02DB, $02E0, $02E5, $02EA, $02EF, $02F4, $02F9, $02FE,
    $0303, $0308, $030D, $0312, $0317, $031C, $0321, $0000),

    ($0326, $032B, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0330,
    $0335, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $033A, $033F, $0344,
    $0349, $034E, $0353, $0358, $035D, $0362, $0369, $0370,
    $0377, $037E, $0385, $038C, $0393, $0000, $039A, $03A1),

    ($03A8, $03AF, $03B6, $03BB, $0000, $0000, $03C0, $03C5,
    $03CA, $03CF, $03D4, $03D9, $03DE, $03E5, $03EC, $03F1,
    $03F6, $0000, $0000, $0000, $03FB, $0400, $0000, $0000,
    $0405, $040A, $040F, $0416, $041D, $0422, $0427, $042C),

    ($0431, $0436, $043B, $0440, $0445, $044A, $044F, $0454,
    $0459, $045E, $0463, $0468, $046D, $0472, $0477, $047C,
    $0481, $0486, $048B, $0490, $0495, $049A, $049F, $04A4,
    $04A9, $04AE, $04B3, $04B8, $0000, $0000, $04BD, $04C2),

    ($0000, $0000, $0000, $0000, $0000, $0000, $04C7, $04CC,
    $04D1, $04D6, $04DB, $04E2, $04E9, $04F0, $04F7, $04FC,
    $0501, $0508, $050F, $0514, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0519, $051C, $0000, $051F, $0522, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0527, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $052A, $0000),

    ($0000, $0000, $0000, $0000, $0000, $052D, $0532, $0537,
    $053A, $053F, $0544, $0000, $0549, $0000, $054E, $0553,
    $0558, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $055F, $0564, $0569, $056E, $0573, $0578,
    $057D, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0584, $0589, $058E, $0593, $0598, $0000,
    $0000, $0000, $0000, $059D, $05A2, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($05A7, $05AC, $0000, $05B1, $0000, $0000, $0000, $05B6,
    $0000, $0000, $0000, $0000, $05BB, $05C0, $05C5, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $05CA, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $05CF, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $05D4, $05D9, $0000, $05DE, $0000, $0000, $0000, $05E3,
    $0000, $0000, $0000, $0000, $05E8, $05ED, $05F2, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $05F7, $05FC,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0601, $0606, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $060B, $0610, $0615, $061A, $0000, $0000, $061F, $0624,
    $0000, $0000, $0629, $062E, $0633, $0638, $063D, $0642),

    ($0000, $0000, $0647, $064C, $0651, $0656, $065B, $0660,
    $0000, $0000, $0665, $066A, $066F, $0674, $0679, $067E,
    $0683, $0688, $068D, $0692, $0697, $069C, $0000, $0000,
    $06A1, $06A6, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $06AB, $06B0, $06B5, $06BA, $06BF, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($06C4, $0000, $06C9, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $06CE, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $06D3, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $06D8, $0000, $0000, $06DD, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $06E2, $06E7, $06EC, $06F1, $06F6, $06FB, $0700, $0705),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $070A, $070F, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0714, $0719, $0000, $071E),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0723, $0000, $0000, $0728, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $072D, $0732, $0737, $0000, $0000, $073C, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0741, $0000, $0000, $0746, $074B, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0750, $0755, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $075A, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $075F, $0764, $0769, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $076E, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0773, $0000, $0000, $0000, $0000, $0000, $0000, $0778,
    $077D, $0000, $0782, $0787, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $078E, $0793, $0798, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $079D, $0000, $07A2, $07A7, $07AE, $0000),

    ($0000, $0000, $0000, $07B3, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $07B8, $0000, $0000,
    $0000, $0000, $07BD, $0000, $0000, $0000, $0000, $07C2,
    $0000, $0000, $0000, $0000, $07C7, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $07CC, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $07D1, $0000, $07D6, $07DB, $0000,
    $07E0, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $07E5, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $07EA, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $07EF, $0000, $0000),

    ($0000, $0000, $07F4, $0000, $0000, $0000, $0000, $07F9,
    $0000, $0000, $0000, $0000, $07FE, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0803, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0808, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($080D, $0812, $0817, $081C, $0821, $0826, $082B, $0830,
    $0835, $083C, $0843, $0848, $084D, $0852, $0857, $085C,
    $0861, $0866, $086B, $0870, $0875, $087C, $0883, $088A,
    $0891, $0896, $089B, $08A0, $08A5, $08AC, $08B3, $08B8),

    ($08BD, $08C2, $08C7, $08CC, $08D1, $08D6, $08DB, $08E0,
    $08E5, $08EA, $08EF, $08F4, $08F9, $08FE, $0903, $090A,
    $0911, $0916, $091B, $0920, $0925, $092A, $092F, $0934,
    $0939, $0940, $0947, $094C, $0951, $0956, $095B, $0960),

    ($0965, $096A, $096F, $0974, $0979, $097E, $0983, $0988,
    $098D, $0992, $0997, $099C, $09A1, $09A8, $09AF, $09B6,
    $09BD, $09C4, $09CB, $09D2, $09D9, $09DE, $09E3, $09E8,
    $09ED, $09F2, $09F7, $09FC, $0A01, $0A08, $0A0F, $0A14),

    ($0A19, $0A1E, $0A23, $0A28, $0A2D, $0A34, $0A3B, $0A42,
    $0A49, $0A50, $0A57, $0A5C, $0A61, $0A66, $0A6B, $0A70,
    $0A75, $0A7A, $0A7F, $0A84, $0A89, $0A8E, $0A93, $0A98,
    $0A9D, $0AA4, $0AAB, $0AB2, $0AB9, $0ABE, $0AC3, $0AC8),

    ($0ACD, $0AD2, $0AD7, $0ADC, $0AE1, $0AE6, $0AEB, $0AF0,
    $0AF5, $0AFA, $0AFF, $0B04, $0B09, $0B0E, $0B13, $0B18,
    $0B1D, $0B22, $0B27, $0B2C, $0B31, $0B36, $0B3B, $0B40,
    $0B45, $0B4A, $0000, $0B4F, $0000, $0000, $0000, $0000),

    ($0B54, $0B59, $0B5E, $0B63, $0B68, $0B6F, $0B76, $0B7D,
    $0B84, $0B8B, $0B92, $0B99, $0BA0, $0BA7, $0BAE, $0BB5,
    $0BBC, $0BC3, $0BCA, $0BD1, $0BD8, $0BDF, $0BE6, $0BED,
    $0BF4, $0BF9, $0BFE, $0C03, $0C08, $0C0D, $0C12, $0C19),

    ($0C20, $0C27, $0C2E, $0C35, $0C3C, $0C43, $0C4A, $0C51,
    $0C58, $0C5D, $0C62, $0C67, $0C6C, $0C71, $0C76, $0C7B,
    $0C80, $0C87, $0C8E, $0C95, $0C9C, $0CA3, $0CAA, $0CB1,
    $0CB8, $0CBF, $0CC6, $0CCD, $0CD4, $0CDB, $0CE2, $0CE9),

    ($0CF0, $0CF7, $0CFE, $0D05, $0D0C, $0D11, $0D16, $0D1B,
    $0D20, $0D27, $0D2E, $0D35, $0D3C, $0D43, $0D4A, $0D51,
    $0D58, $0D5F, $0D66, $0D6B, $0D70, $0D75, $0D7A, $0D7F,
    $0D84, $0D89, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0D8E, $0D93, $0D98, $0D9F, $0DA6, $0DAD, $0DB4, $0DBB,
    $0DC2, $0DC7, $0DCC, $0DD3, $0DDA, $0DE1, $0DE8, $0DEF,
    $0DF6, $0DFB, $0E00, $0E07, $0E0E, $0E15, $0000, $0000,
    $0E1C, $0E21, $0E26, $0E2D, $0E34, $0E3B, $0000, $0000),

    ($0E42, $0E47, $0E4C, $0E53, $0E5A, $0E61, $0E68, $0E6F,
    $0E76, $0E7B, $0E80, $0E87, $0E8E, $0E95, $0E9C, $0EA3,
    $0EAA, $0EAF, $0EB4, $0EBB, $0EC2, $0EC9, $0ED0, $0ED7,
    $0EDE, $0EE3, $0EE8, $0EEF, $0EF6, $0EFD, $0F04, $0F0B),

    ($0F12, $0F17, $0F1C, $0F23, $0F2A, $0F31, $0000, $0000,
    $0F38, $0F3D, $0F42, $0F49, $0F50, $0F57, $0000, $0000,
    $0F5E, $0F63, $0F68, $0F6F, $0F76, $0F7D, $0F84, $0F8B,
    $0000, $0F92, $0000, $0F97, $0000, $0F9E, $0000, $0FA5),

    ($0FAC, $0FB1, $0FB6, $0FBD, $0FC4, $0FCB, $0FD2, $0FD9,
    $0FE0, $0FE5, $0FEA, $0FF1, $0FF8, $0FFF, $1006, $100D,
    $1014, $0569, $1019, $056E, $101E, $0573, $1023, $0578,
    $1028, $058E, $102D, $0593, $1032, $0598, $0000, $0000),

    ($1037, $103E, $1045, $104E, $1057, $1060, $1069, $1072,
    $107B, $1082, $1089, $1092, $109B, $10A4, $10AD, $10B6,
    $10BF, $10C6, $10CD, $10D6, $10DF, $10E8, $10F1, $10FA,
    $1103, $110A, $1111, $111A, $1123, $112C, $1135, $113E),

    ($1147, $114E, $1155, $115E, $1167, $1170, $1179, $1182,
    $118B, $1192, $1199, $11A2, $11AB, $11B4, $11BD, $11C6,
    $11CF, $11D4, $11D9, $11E0, $11E5, $0000, $11EC, $11F1,
    $11F8, $11FD, $1202, $0532, $1207, $0000, $120C, $0000),

    ($0000, $120F, $1214, $121B, $1220, $0000, $1227, $122C,
    $1233, $053A, $1238, $053F, $123D, $1242, $1247, $124C,
    $1251, $1256, $125B, $0558, $0000, $0000, $1262, $1267,
    $126E, $1273, $1278, $0544, $0000, $127D, $1282, $1287),

    ($128C, $1291, $1296, $057D, $129D, $12A2, $12A7, $12AC,
    $12B3, $12B8, $12BD, $054E, $12C2, $12C7, $052D, $12CC,
    $0000, $0000, $12CF, $12D6, $12DB, $0000, $12E2, $12E7,
    $12EE, $0549, $12F3, $0553, $12F8, $12FD, $0000, $0000),

    ($1300, $1303, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $1306, $0000,
    $0000, $0000, $1309, $001A, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $130C, $1311, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $1316, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $131B, $1320, $1325,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $132A, $0000, $0000, $0000,
    $0000, $132F, $0000, $0000, $1334, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $1339, $0000, $133E, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $1343, $0000, $0000, $1348, $0000, $0000, $134D,
    $0000, $1352, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($1357, $0000, $135C, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $1361, $1366, $136B,
    $1370, $1375, $0000, $0000, $137A, $137F, $0000, $0000,
    $1384, $1389, $0000, $0000, $0000, $0000, $0000, $0000),

    ($138E, $1393, $0000, $0000, $1398, $139D, $0000, $0000,
    $13A2, $13A7, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $13AC, $13B1, $13B6, $13BB,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($13C0, $13C5, $13CA, $13CF, $0000, $0000, $0000, $0000,
    $0000, $0000, $13D4, $13D9, $13DE, $13E3, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $13E8, $13EB, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $13EE, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $13F3, $0000, $13F8, $0000,
    $13FD, $0000, $1402, $0000, $1407, $0000, $140C, $0000,
    $1411, $0000, $1416, $0000, $141B, $0000, $1420, $0000),

    ($1425, $0000, $142A, $0000, $0000, $142F, $0000, $1434,
    $0000, $1439, $0000, $0000, $0000, $0000, $0000, $0000,
    $143E, $1443, $0000, $1448, $144D, $0000, $1452, $1457,
    $0000, $145C, $1461, $0000, $1466, $146B, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $1470, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $1475, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $147A, $0000, $147F, $0000,
    $1484, $0000, $1489, $0000, $148E, $0000, $1493, $0000,
    $1498, $0000, $149D, $0000, $14A2, $0000, $14A7, $0000),

    ($14AC, $0000, $14B1, $0000, $0000, $14B6, $0000, $14BB,
    $0000, $14C0, $0000, $0000, $0000, $0000, $0000, $0000,
    $14C5, $14CA, $0000, $14CF, $14D4, $0000, $14D9, $14DE,
    $0000, $14E3, $14E8, $0000, $14ED, $14F2, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $14F7, $0000, $0000, $14FC,
    $1501, $1506, $150B, $0000, $0000, $0000, $1510, $0000),

    ($1515, $1518, $151B, $151E, $1521, $1524, $1527, $152A,
    $152A, $152D, $1530, $1533, $1536, $1539, $153C, $153F,
    $1542, $1545, $1548, $154B, $154E, $1551, $1554, $1557,
    $155A, $155D, $1560, $1563, $1566, $1569, $156C, $156F),

    ($1572, $1575, $1578, $157B, $157E, $1581, $1584, $1587,
    $158A, $158D, $1590, $1593, $1596, $1599, $159C, $159F,
    $15A2, $15A5, $15A8, $15AB, $15AE, $15B1, $15B4, $15B7,
    $15BA, $15BD, $15C0, $15C3, $15C6, $15C9, $15CC, $15CF),

    ($15D2, $15D5, $15D8, $15DB, $15DE, $15E1, $15E4, $15E7,
    $15EA, $15ED, $15F0, $15F3, $15F6, $15F9, $15FC, $15FF,
    $1602, $1605, $1608, $160B, $160E, $1611, $1614, $1617,
    $161A, $161D, $1620, $1623, $154E, $1626, $1629, $162C),

    ($162F, $1632, $1635, $1638, $163B, $163E, $1641, $1644,
    $1647, $164A, $164D, $1650, $1653, $1656, $1659, $165C,
    $165F, $1662, $1665, $1668, $166B, $166E, $1671, $1674,
    $1677, $167A, $167D, $1680, $1683, $1686, $1689, $168C),

    ($168F, $1692, $1695, $1698, $169B, $169E, $16A1, $16A4,
    $16A7, $16AA, $16AD, $16B0, $16B3, $16B6, $16B9, $16BC,
    $16BF, $16C2, $16C5, $16C8, $16CB, $16CE, $16D1, $16D4,
    $16D7, $16DA, $16DD, $16E0, $16E3, $16E6, $16E9, $16EC),

    ($16EF, $165C, $16F2, $16F5, $16F8, $16FB, $16FE, $1701,
    $1704, $1707, $162C, $170A, $170D, $1710, $1713, $1716,
    $1719, $171C, $171F, $1722, $1725, $1728, $172B, $172E,
    $1731, $1734, $1737, $173A, $173D, $1740, $1743, $154E),

    ($1746, $1749, $174C, $174F, $1752, $1755, $1758, $175B,
    $175E, $1761, $1764, $1767, $176A, $176D, $1770, $1773,
    $1776, $1779, $177C, $177F, $1782, $1785, $1788, $178B,
    $178E, $1791, $1794, $1632, $1797, $179A, $179D, $17A0),

    ($17A3, $17A6, $17A9, $17AC, $17AF, $17B2, $17B5, $17B8,
    $17BB, $17BE, $17C1, $17C4, $17C7, $17CA, $17CD, $17D0,
    $17D3, $17D6, $17D9, $17DC, $17DF, $17E2, $17E5, $17E8,
    $17EB, $17EE, $17F1, $17F4, $17F7, $17FA, $17FD, $1800),

    ($1803, $1806, $1809, $180C, $180F, $1812, $1815, $1818,
    $181B, $181E, $1821, $1824, $1827, $182A, $0000, $0000,
    $182D, $0000, $1830, $0000, $0000, $1833, $1836, $1839,
    $183C, $183F, $1842, $1845, $1848, $184B, $184E, $0000),

    ($1851, $0000, $1854, $0000, $0000, $1857, $185A, $0000,
    $0000, $0000, $185D, $1860, $1863, $1866, $0000, $0000,
    $1869, $186C, $186F, $1872, $1875, $1878, $187B, $187E,
    $1881, $1884, $1887, $188A, $188D, $1890, $1893, $1896),

    ($1899, $189C, $189F, $18A2, $18A5, $18A8, $18AB, $18AE,
    $18B1, $18B4, $18B7, $18BA, $18BD, $18C0, $18C3, $18C6,
    $18C9, $18CC, $18CF, $18D2, $18D5, $18D8, $18DB, $16D1,
    $18DE, $18E1, $18E4, $18E7, $18EA, $18ED, $18ED, $18F0),

    ($18F3, $18F6, $18F9, $18FC, $18FF, $1902, $1905, $1857,
    $1908, $190B, $190E, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $1911, $0000, $1916),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $191B, $1920, $1925, $192C, $1933, $1938,
    $193D, $1942, $1947, $194C, $1951, $1956, $195B, $0000,
    $1960, $1965, $196A, $196F, $1974, $0000, $1979, $0000),

    ($197E, $1983, $0000, $1988, $198D, $0000, $1992, $1997,
    $199C, $19A1, $19A6, $19AB, $19B0, $19B5, $19BA, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000));
  CHAR_CANONICAL_DECOMPOSITION_SIZE = 32;
  CHAR_CANONICAL_DECOMPOSITION_DATA: array[$0000..$19BE] of Byte = (
    $00, $02, $41, $00, $00, $03, $02, $41,
    $00, $01, $03, $02, $41, $00, $02, $03,
    $02, $41, $00, $03, $03, $02, $41, $00,
    $08, $03, $02, $41, $00, $0A, $03, $02,
    $43, $00, $27, $03, $02, $45, $00, $00,
    $03, $02, $45, $00, $01, $03, $02, $45,
    $00, $02, $03, $02, $45, $00, $08, $03,
    $02, $49, $00, $00, $03, $02, $49, $00,

    $01, $03, $02, $49, $00, $02, $03, $02,
    $49, $00, $08, $03, $02, $4E, $00, $03,
    $03, $02, $4F, $00, $00, $03, $02, $4F,
    $00, $01, $03, $02, $4F, $00, $02, $03,
    $02, $4F, $00, $03, $03, $02, $4F, $00,
    $08, $03, $02, $55, $00, $00, $03, $02,
    $55, $00, $01, $03, $02, $55, $00, $02,
    $03, $02, $55, $00, $08, $03, $02, $59,

    $00, $01, $03, $02, $61, $00, $00, $03,
    $02, $61, $00, $01, $03, $02, $61, $00,
    $02, $03, $02, $61, $00, $03, $03, $02,
    $61, $00, $08, $03, $02, $61, $00, $0A,
    $03, $02, $63, $00, $27, $03, $02, $65,
    $00, $00, $03, $02, $65, $00, $01, $03,
    $02, $65, $00, $02, $03, $02, $65, $00,
    $08, $03, $02, $69, $00, $00, $03, $02,

    $69, $00, $01, $03, $02, $69, $00, $02,
    $03, $02, $69, $00, $08, $03, $02, $6E,
    $00, $03, $03, $02, $6F, $00, $00, $03,
    $02, $6F, $00, $01, $03, $02, $6F, $00,
    $02, $03, $02, $6F, $00, $03, $03, $02,
    $6F, $00, $08, $03, $02, $75, $00, $00,
    $03, $02, $75, $00, $01, $03, $02, $75,
    $00, $02, $03, $02, $75, $00, $08, $03,

    $02, $79, $00, $01, $03, $02, $79, $00,
    $08, $03, $02, $41, $00, $04, $03, $02,
    $61, $00, $04, $03, $02, $41, $00, $06,
    $03, $02, $61, $00, $06, $03, $02, $41,
    $00, $28, $03, $02, $61, $00, $28, $03,
    $02, $43, $00, $01, $03, $02, $63, $00,
    $01, $03, $02, $43, $00, $02, $03, $02,
    $63, $00, $02, $03, $02, $43, $00, $07,

    $03, $02, $63, $00, $07, $03, $02, $43,
    $00, $0C, $03, $02, $63, $00, $0C, $03,
    $02, $44, $00, $0C, $03, $02, $64, $00,
    $0C, $03, $02, $45, $00, $04, $03, $02,
    $65, $00, $04, $03, $02, $45, $00, $06,
    $03, $02, $65, $00, $06, $03, $02, $45,
    $00, $07, $03, $02, $65, $00, $07, $03,
    $02, $45, $00, $28, $03, $02, $65, $00,

    $28, $03, $02, $45, $00, $0C, $03, $02,
    $65, $00, $0C, $03, $02, $47, $00, $02,
    $03, $02, $67, $00, $02, $03, $02, $47,
    $00, $06, $03, $02, $67, $00, $06, $03,
    $02, $47, $00, $07, $03, $02, $67, $00,
    $07, $03, $02, $47, $00, $27, $03, $02,
    $67, $00, $27, $03, $02, $48, $00, $02,
    $03, $02, $68, $00, $02, $03, $02, $49,

    $00, $03, $03, $02, $69, $00, $03, $03,
    $02, $49, $00, $04, $03, $02, $69, $00,
    $04, $03, $02, $49, $00, $06, $03, $02,
    $69, $00, $06, $03, $02, $49, $00, $28,
    $03, $02, $69, $00, $28, $03, $02, $49,
    $00, $07, $03, $02, $4A, $00, $02, $03,
    $02, $6A, $00, $02, $03, $02, $4B, $00,
    $27, $03, $02, $6B, $00, $27, $03, $02,

    $4C, $00, $01, $03, $02, $6C, $00, $01,
    $03, $02, $4C, $00, $27, $03, $02, $6C,
    $00, $27, $03, $02, $4C, $00, $0C, $03,
    $02, $6C, $00, $0C, $03, $02, $4E, $00,
    $01, $03, $02, $6E, $00, $01, $03, $02,
    $4E, $00, $27, $03, $02, $6E, $00, $27,
    $03, $02, $4E, $00, $0C, $03, $02, $6E,
    $00, $0C, $03, $02, $4F, $00, $04, $03,

    $02, $6F, $00, $04, $03, $02, $4F, $00,
    $06, $03, $02, $6F, $00, $06, $03, $02,
    $4F, $00, $0B, $03, $02, $6F, $00, $0B,
    $03, $02, $52, $00, $01, $03, $02, $72,
    $00, $01, $03, $02, $52, $00, $27, $03,
    $02, $72, $00, $27, $03, $02, $52, $00,
    $0C, $03, $02, $72, $00, $0C, $03, $02,
    $53, $00, $01, $03, $02, $73, $00, $01,

    $03, $02, $53, $00, $02, $03, $02, $73,
    $00, $02, $03, $02, $53, $00, $27, $03,
    $02, $73, $00, $27, $03, $02, $53, $00,
    $0C, $03, $02, $73, $00, $0C, $03, $02,
    $54, $00, $27, $03, $02, $74, $00, $27,
    $03, $02, $54, $00, $0C, $03, $02, $74,
    $00, $0C, $03, $02, $55, $00, $03, $03,
    $02, $75, $00, $03, $03, $02, $55, $00,

    $04, $03, $02, $75, $00, $04, $03, $02,
    $55, $00, $06, $03, $02, $75, $00, $06,
    $03, $02, $55, $00, $0A, $03, $02, $75,
    $00, $0A, $03, $02, $55, $00, $0B, $03,
    $02, $75, $00, $0B, $03, $02, $55, $00,
    $28, $03, $02, $75, $00, $28, $03, $02,
    $57, $00, $02, $03, $02, $77, $00, $02,
    $03, $02, $59, $00, $02, $03, $02, $79,

    $00, $02, $03, $02, $59, $00, $08, $03,
    $02, $5A, $00, $01, $03, $02, $7A, $00,
    $01, $03, $02, $5A, $00, $07, $03, $02,
    $7A, $00, $07, $03, $02, $5A, $00, $0C,
    $03, $02, $7A, $00, $0C, $03, $02, $4F,
    $00, $1B, $03, $02, $6F, $00, $1B, $03,
    $02, $55, $00, $1B, $03, $02, $75, $00,
    $1B, $03, $02, $41, $00, $0C, $03, $02,

    $61, $00, $0C, $03, $02, $49, $00, $0C,
    $03, $02, $69, $00, $0C, $03, $02, $4F,
    $00, $0C, $03, $02, $6F, $00, $0C, $03,
    $02, $55, $00, $0C, $03, $02, $75, $00,
    $0C, $03, $03, $55, $00, $08, $03, $04,
    $03, $03, $75, $00, $08, $03, $04, $03,
    $03, $55, $00, $08, $03, $01, $03, $03,
    $75, $00, $08, $03, $01, $03, $03, $55,

    $00, $08, $03, $0C, $03, $03, $75, $00,
    $08, $03, $0C, $03, $03, $55, $00, $08,
    $03, $00, $03, $03, $75, $00, $08, $03,
    $00, $03, $03, $41, $00, $08, $03, $04,
    $03, $03, $61, $00, $08, $03, $04, $03,
    $03, $41, $00, $07, $03, $04, $03, $03,
    $61, $00, $07, $03, $04, $03, $02, $C6,
    $00, $04, $03, $02, $E6, $00, $04, $03,

    $02, $47, $00, $0C, $03, $02, $67, $00,
    $0C, $03, $02, $4B, $00, $0C, $03, $02,
    $6B, $00, $0C, $03, $02, $4F, $00, $28,
    $03, $02, $6F, $00, $28, $03, $03, $4F,
    $00, $28, $03, $04, $03, $03, $6F, $00,
    $28, $03, $04, $03, $02, $B7, $01, $0C,
    $03, $02, $92, $02, $0C, $03, $02, $6A,
    $00, $0C, $03, $02, $47, $00, $01, $03,

    $02, $67, $00, $01, $03, $02, $4E, $00,
    $00, $03, $02, $6E, $00, $00, $03, $03,
    $41, $00, $0A, $03, $01, $03, $03, $61,
    $00, $0A, $03, $01, $03, $02, $C6, $00,
    $01, $03, $02, $E6, $00, $01, $03, $02,
    $D8, $00, $01, $03, $02, $F8, $00, $01,
    $03, $02, $41, $00, $0F, $03, $02, $61,
    $00, $0F, $03, $02, $41, $00, $11, $03,

    $02, $61, $00, $11, $03, $02, $45, $00,
    $0F, $03, $02, $65, $00, $0F, $03, $02,
    $45, $00, $11, $03, $02, $65, $00, $11,
    $03, $02, $49, $00, $0F, $03, $02, $69,
    $00, $0F, $03, $02, $49, $00, $11, $03,
    $02, $69, $00, $11, $03, $02, $4F, $00,
    $0F, $03, $02, $6F, $00, $0F, $03, $02,
    $4F, $00, $11, $03, $02, $6F, $00, $11,

    $03, $02, $52, $00, $0F, $03, $02, $72,
    $00, $0F, $03, $02, $52, $00, $11, $03,
    $02, $72, $00, $11, $03, $02, $55, $00,
    $0F, $03, $02, $75, $00, $0F, $03, $02,
    $55, $00, $11, $03, $02, $75, $00, $11,
    $03, $02, $53, $00, $26, $03, $02, $73,
    $00, $26, $03, $02, $54, $00, $26, $03,
    $02, $74, $00, $26, $03, $02, $48, $00,

    $0C, $03, $02, $68, $00, $0C, $03, $02,
    $41, $00, $07, $03, $02, $61, $00, $07,
    $03, $02, $45, $00, $27, $03, $02, $65,
    $00, $27, $03, $03, $4F, $00, $08, $03,
    $04, $03, $03, $6F, $00, $08, $03, $04,
    $03, $03, $4F, $00, $03, $03, $04, $03,
    $03, $6F, $00, $03, $03, $04, $03, $02,
    $4F, $00, $07, $03, $02, $6F, $00, $07,

    $03, $03, $4F, $00, $07, $03, $04, $03,
    $03, $6F, $00, $07, $03, $04, $03, $02,
    $59, $00, $04, $03, $02, $79, $00, $04,
    $03, $01, $00, $03, $01, $01, $03, $01,
    $13, $03, $02, $08, $03, $01, $03, $01,
    $B9, $02, $01, $3B, $00, $02, $A8, $00,
    $01, $03, $02, $91, $03, $01, $03, $01,
    $B7, $00, $02, $95, $03, $01, $03, $02,

    $97, $03, $01, $03, $02, $99, $03, $01,
    $03, $02, $9F, $03, $01, $03, $02, $A5,
    $03, $01, $03, $02, $A9, $03, $01, $03,
    $03, $B9, $03, $08, $03, $01, $03, $02,
    $99, $03, $08, $03, $02, $A5, $03, $08,
    $03, $02, $B1, $03, $01, $03, $02, $B5,
    $03, $01, $03, $02, $B7, $03, $01, $03,
    $02, $B9, $03, $01, $03, $03, $C5, $03,

    $08, $03, $01, $03, $02, $B9, $03, $08,
    $03, $02, $C5, $03, $08, $03, $02, $BF,
    $03, $01, $03, $02, $C5, $03, $01, $03,
    $02, $C9, $03, $01, $03, $02, $D2, $03,
    $01, $03, $02, $D2, $03, $08, $03, $02,
    $15, $04, $00, $03, $02, $15, $04, $08,
    $03, $02, $13, $04, $01, $03, $02, $06,
    $04, $08, $03, $02, $1A, $04, $01, $03,

    $02, $18, $04, $00, $03, $02, $23, $04,
    $06, $03, $02, $18, $04, $06, $03, $02,
    $38, $04, $06, $03, $02, $35, $04, $00,
    $03, $02, $35, $04, $08, $03, $02, $33,
    $04, $01, $03, $02, $56, $04, $08, $03,
    $02, $3A, $04, $01, $03, $02, $38, $04,
    $00, $03, $02, $43, $04, $06, $03, $02,
    $74, $04, $0F, $03, $02, $75, $04, $0F,

    $03, $02, $16, $04, $06, $03, $02, $36,
    $04, $06, $03, $02, $10, $04, $06, $03,
    $02, $30, $04, $06, $03, $02, $10, $04,
    $08, $03, $02, $30, $04, $08, $03, $02,
    $15, $04, $06, $03, $02, $35, $04, $06,
    $03, $02, $D8, $04, $08, $03, $02, $D9,
    $04, $08, $03, $02, $16, $04, $08, $03,
    $02, $36, $04, $08, $03, $02, $17, $04,

    $08, $03, $02, $37, $04, $08, $03, $02,
    $18, $04, $04, $03, $02, $38, $04, $04,
    $03, $02, $18, $04, $08, $03, $02, $38,
    $04, $08, $03, $02, $1E, $04, $08, $03,
    $02, $3E, $04, $08, $03, $02, $E8, $04,
    $08, $03, $02, $E9, $04, $08, $03, $02,
    $2D, $04, $08, $03, $02, $4D, $04, $08,
    $03, $02, $23, $04, $04, $03, $02, $43,

    $04, $04, $03, $02, $23, $04, $08, $03,
    $02, $43, $04, $08, $03, $02, $23, $04,
    $0B, $03, $02, $43, $04, $0B, $03, $02,
    $27, $04, $08, $03, $02, $47, $04, $08,
    $03, $02, $2B, $04, $08, $03, $02, $4B,
    $04, $08, $03, $02, $27, $06, $53, $06,
    $02, $27, $06, $54, $06, $02, $48, $06,
    $54, $06, $02, $27, $06, $55, $06, $02,

    $4A, $06, $54, $06, $02, $D5, $06, $54,
    $06, $02, $C1, $06, $54, $06, $02, $D2,
    $06, $54, $06, $02, $28, $09, $3C, $09,
    $02, $30, $09, $3C, $09, $02, $33, $09,
    $3C, $09, $02, $15, $09, $3C, $09, $02,
    $16, $09, $3C, $09, $02, $17, $09, $3C,
    $09, $02, $1C, $09, $3C, $09, $02, $21,
    $09, $3C, $09, $02, $22, $09, $3C, $09,

    $02, $2B, $09, $3C, $09, $02, $2F, $09,
    $3C, $09, $02, $C7, $09, $BE, $09, $02,
    $C7, $09, $D7, $09, $02, $A1, $09, $BC,
    $09, $02, $A2, $09, $BC, $09, $02, $AF,
    $09, $BC, $09, $02, $32, $0A, $3C, $0A,
    $02, $38, $0A, $3C, $0A, $02, $16, $0A,
    $3C, $0A, $02, $17, $0A, $3C, $0A, $02,
    $1C, $0A, $3C, $0A, $02, $2B, $0A, $3C,

    $0A, $02, $47, $0B, $56, $0B, $02, $47,
    $0B, $3E, $0B, $02, $47, $0B, $57, $0B,
    $02, $21, $0B, $3C, $0B, $02, $22, $0B,
    $3C, $0B, $02, $92, $0B, $D7, $0B, $02,
    $C6, $0B, $BE, $0B, $02, $C7, $0B, $BE,
    $0B, $02, $C6, $0B, $D7, $0B, $02, $46,
    $0C, $56, $0C, $02, $BF, $0C, $D5, $0C,
    $02, $C6, $0C, $D5, $0C, $02, $C6, $0C,

    $D6, $0C, $02, $C6, $0C, $C2, $0C, $03,
    $C6, $0C, $C2, $0C, $D5, $0C, $02, $46,
    $0D, $3E, $0D, $02, $47, $0D, $3E, $0D,
    $02, $46, $0D, $57, $0D, $02, $D9, $0D,
    $CA, $0D, $02, $D9, $0D, $CF, $0D, $03,
    $D9, $0D, $CF, $0D, $CA, $0D, $02, $D9,
    $0D, $DF, $0D, $02, $42, $0F, $B7, $0F,
    $02, $4C, $0F, $B7, $0F, $02, $51, $0F,

    $B7, $0F, $02, $56, $0F, $B7, $0F, $02,
    $5B, $0F, $B7, $0F, $02, $40, $0F, $B5,
    $0F, $02, $71, $0F, $72, $0F, $02, $71,
    $0F, $74, $0F, $02, $B2, $0F, $80, $0F,
    $02, $B3, $0F, $80, $0F, $02, $71, $0F,
    $80, $0F, $02, $92, $0F, $B7, $0F, $02,
    $9C, $0F, $B7, $0F, $02, $A1, $0F, $B7,
    $0F, $02, $A6, $0F, $B7, $0F, $02, $AB,

    $0F, $B7, $0F, $02, $90, $0F, $B5, $0F,
    $02, $25, $10, $2E, $10, $02, $41, $00,
    $25, $03, $02, $61, $00, $25, $03, $02,
    $42, $00, $07, $03, $02, $62, $00, $07,
    $03, $02, $42, $00, $23, $03, $02, $62,
    $00, $23, $03, $02, $42, $00, $31, $03,
    $02, $62, $00, $31, $03, $03, $43, $00,
    $27, $03, $01, $03, $03, $63, $00, $27,

    $03, $01, $03, $02, $44, $00, $07, $03,
    $02, $64, $00, $07, $03, $02, $44, $00,
    $23, $03, $02, $64, $00, $23, $03, $02,
    $44, $00, $31, $03, $02, $64, $00, $31,
    $03, $02, $44, $00, $27, $03, $02, $64,
    $00, $27, $03, $02, $44, $00, $2D, $03,
    $02, $64, $00, $2D, $03, $03, $45, $00,
    $04, $03, $00, $03, $03, $65, $00, $04,

    $03, $00, $03, $03, $45, $00, $04, $03,
    $01, $03, $03, $65, $00, $04, $03, $01,
    $03, $02, $45, $00, $2D, $03, $02, $65,
    $00, $2D, $03, $02, $45, $00, $30, $03,
    $02, $65, $00, $30, $03, $03, $45, $00,
    $27, $03, $06, $03, $03, $65, $00, $27,
    $03, $06, $03, $02, $46, $00, $07, $03,
    $02, $66, $00, $07, $03, $02, $47, $00,

    $04, $03, $02, $67, $00, $04, $03, $02,
    $48, $00, $07, $03, $02, $68, $00, $07,
    $03, $02, $48, $00, $23, $03, $02, $68,
    $00, $23, $03, $02, $48, $00, $08, $03,
    $02, $68, $00, $08, $03, $02, $48, $00,
    $27, $03, $02, $68, $00, $27, $03, $02,
    $48, $00, $2E, $03, $02, $68, $00, $2E,
    $03, $02, $49, $00, $30, $03, $02, $69,

    $00, $30, $03, $03, $49, $00, $08, $03,
    $01, $03, $03, $69, $00, $08, $03, $01,
    $03, $02, $4B, $00, $01, $03, $02, $6B,
    $00, $01, $03, $02, $4B, $00, $23, $03,
    $02, $6B, $00, $23, $03, $02, $4B, $00,
    $31, $03, $02, $6B, $00, $31, $03, $02,
    $4C, $00, $23, $03, $02, $6C, $00, $23,
    $03, $03, $4C, $00, $23, $03, $04, $03,

    $03, $6C, $00, $23, $03, $04, $03, $02,
    $4C, $00, $31, $03, $02, $6C, $00, $31,
    $03, $02, $4C, $00, $2D, $03, $02, $6C,
    $00, $2D, $03, $02, $4D, $00, $01, $03,
    $02, $6D, $00, $01, $03, $02, $4D, $00,
    $07, $03, $02, $6D, $00, $07, $03, $02,
    $4D, $00, $23, $03, $02, $6D, $00, $23,
    $03, $02, $4E, $00, $07, $03, $02, $6E,

    $00, $07, $03, $02, $4E, $00, $23, $03,
    $02, $6E, $00, $23, $03, $02, $4E, $00,
    $31, $03, $02, $6E, $00, $31, $03, $02,
    $4E, $00, $2D, $03, $02, $6E, $00, $2D,
    $03, $03, $4F, $00, $03, $03, $01, $03,
    $03, $6F, $00, $03, $03, $01, $03, $03,
    $4F, $00, $03, $03, $08, $03, $03, $6F,
    $00, $03, $03, $08, $03, $03, $4F, $00,

    $04, $03, $00, $03, $03, $6F, $00, $04,
    $03, $00, $03, $03, $4F, $00, $04, $03,
    $01, $03, $03, $6F, $00, $04, $03, $01,
    $03, $02, $50, $00, $01, $03, $02, $70,
    $00, $01, $03, $02, $50, $00, $07, $03,
    $02, $70, $00, $07, $03, $02, $52, $00,
    $07, $03, $02, $72, $00, $07, $03, $02,
    $52, $00, $23, $03, $02, $72, $00, $23,

    $03, $03, $52, $00, $23, $03, $04, $03,
    $03, $72, $00, $23, $03, $04, $03, $02,
    $52, $00, $31, $03, $02, $72, $00, $31,
    $03, $02, $53, $00, $07, $03, $02, $73,
    $00, $07, $03, $02, $53, $00, $23, $03,
    $02, $73, $00, $23, $03, $03, $53, $00,
    $01, $03, $07, $03, $03, $73, $00, $01,
    $03, $07, $03, $03, $53, $00, $0C, $03,

    $07, $03, $03, $73, $00, $0C, $03, $07,
    $03, $03, $53, $00, $23, $03, $07, $03,
    $03, $73, $00, $23, $03, $07, $03, $02,
    $54, $00, $07, $03, $02, $74, $00, $07,
    $03, $02, $54, $00, $23, $03, $02, $74,
    $00, $23, $03, $02, $54, $00, $31, $03,
    $02, $74, $00, $31, $03, $02, $54, $00,
    $2D, $03, $02, $74, $00, $2D, $03, $02,

    $55, $00, $24, $03, $02, $75, $00, $24,
    $03, $02, $55, $00, $30, $03, $02, $75,
    $00, $30, $03, $02, $55, $00, $2D, $03,
    $02, $75, $00, $2D, $03, $03, $55, $00,
    $03, $03, $01, $03, $03, $75, $00, $03,
    $03, $01, $03, $03, $55, $00, $04, $03,
    $08, $03, $03, $75, $00, $04, $03, $08,
    $03, $02, $56, $00, $03, $03, $02, $76,

    $00, $03, $03, $02, $56, $00, $23, $03,
    $02, $76, $00, $23, $03, $02, $57, $00,
    $00, $03, $02, $77, $00, $00, $03, $02,
    $57, $00, $01, $03, $02, $77, $00, $01,
    $03, $02, $57, $00, $08, $03, $02, $77,
    $00, $08, $03, $02, $57, $00, $07, $03,
    $02, $77, $00, $07, $03, $02, $57, $00,
    $23, $03, $02, $77, $00, $23, $03, $02,

    $58, $00, $07, $03, $02, $78, $00, $07,
    $03, $02, $58, $00, $08, $03, $02, $78,
    $00, $08, $03, $02, $59, $00, $07, $03,
    $02, $79, $00, $07, $03, $02, $5A, $00,
    $02, $03, $02, $7A, $00, $02, $03, $02,
    $5A, $00, $23, $03, $02, $7A, $00, $23,
    $03, $02, $5A, $00, $31, $03, $02, $7A,
    $00, $31, $03, $02, $68, $00, $31, $03,

    $02, $74, $00, $08, $03, $02, $77, $00,
    $0A, $03, $02, $79, $00, $0A, $03, $02,
    $7F, $01, $07, $03, $02, $41, $00, $23,
    $03, $02, $61, $00, $23, $03, $02, $41,
    $00, $09, $03, $02, $61, $00, $09, $03,
    $03, $41, $00, $02, $03, $01, $03, $03,
    $61, $00, $02, $03, $01, $03, $03, $41,
    $00, $02, $03, $00, $03, $03, $61, $00,

    $02, $03, $00, $03, $03, $41, $00, $02,
    $03, $09, $03, $03, $61, $00, $02, $03,
    $09, $03, $03, $41, $00, $02, $03, $03,
    $03, $03, $61, $00, $02, $03, $03, $03,
    $03, $41, $00, $23, $03, $02, $03, $03,
    $61, $00, $23, $03, $02, $03, $03, $41,
    $00, $06, $03, $01, $03, $03, $61, $00,
    $06, $03, $01, $03, $03, $41, $00, $06,

    $03, $00, $03, $03, $61, $00, $06, $03,
    $00, $03, $03, $41, $00, $06, $03, $09,
    $03, $03, $61, $00, $06, $03, $09, $03,
    $03, $41, $00, $06, $03, $03, $03, $03,
    $61, $00, $06, $03, $03, $03, $03, $41,
    $00, $23, $03, $06, $03, $03, $61, $00,
    $23, $03, $06, $03, $02, $45, $00, $23,
    $03, $02, $65, $00, $23, $03, $02, $45,

    $00, $09, $03, $02, $65, $00, $09, $03,
    $02, $45, $00, $03, $03, $02, $65, $00,
    $03, $03, $03, $45, $00, $02, $03, $01,
    $03, $03, $65, $00, $02, $03, $01, $03,
    $03, $45, $00, $02, $03, $00, $03, $03,
    $65, $00, $02, $03, $00, $03, $03, $45,
    $00, $02, $03, $09, $03, $03, $65, $00,
    $02, $03, $09, $03, $03, $45, $00, $02,

    $03, $03, $03, $03, $65, $00, $02, $03,
    $03, $03, $03, $45, $00, $23, $03, $02,
    $03, $03, $65, $00, $23, $03, $02, $03,
    $02, $49, $00, $09, $03, $02, $69, $00,
    $09, $03, $02, $49, $00, $23, $03, $02,
    $69, $00, $23, $03, $02, $4F, $00, $23,
    $03, $02, $6F, $00, $23, $03, $02, $4F,
    $00, $09, $03, $02, $6F, $00, $09, $03,

    $03, $4F, $00, $02, $03, $01, $03, $03,
    $6F, $00, $02, $03, $01, $03, $03, $4F,
    $00, $02, $03, $00, $03, $03, $6F, $00,
    $02, $03, $00, $03, $03, $4F, $00, $02,
    $03, $09, $03, $03, $6F, $00, $02, $03,
    $09, $03, $03, $4F, $00, $02, $03, $03,
    $03, $03, $6F, $00, $02, $03, $03, $03,
    $03, $4F, $00, $23, $03, $02, $03, $03,

    $6F, $00, $23, $03, $02, $03, $03, $4F,
    $00, $1B, $03, $01, $03, $03, $6F, $00,
    $1B, $03, $01, $03, $03, $4F, $00, $1B,
    $03, $00, $03, $03, $6F, $00, $1B, $03,
    $00, $03, $03, $4F, $00, $1B, $03, $09,
    $03, $03, $6F, $00, $1B, $03, $09, $03,
    $03, $4F, $00, $1B, $03, $03, $03, $03,
    $6F, $00, $1B, $03, $03, $03, $03, $4F,

    $00, $1B, $03, $23, $03, $03, $6F, $00,
    $1B, $03, $23, $03, $02, $55, $00, $23,
    $03, $02, $75, $00, $23, $03, $02, $55,
    $00, $09, $03, $02, $75, $00, $09, $03,
    $03, $55, $00, $1B, $03, $01, $03, $03,
    $75, $00, $1B, $03, $01, $03, $03, $55,
    $00, $1B, $03, $00, $03, $03, $75, $00,
    $1B, $03, $00, $03, $03, $55, $00, $1B,

    $03, $09, $03, $03, $75, $00, $1B, $03,
    $09, $03, $03, $55, $00, $1B, $03, $03,
    $03, $03, $75, $00, $1B, $03, $03, $03,
    $03, $55, $00, $1B, $03, $23, $03, $03,
    $75, $00, $1B, $03, $23, $03, $02, $59,
    $00, $00, $03, $02, $79, $00, $00, $03,
    $02, $59, $00, $23, $03, $02, $79, $00,
    $23, $03, $02, $59, $00, $09, $03, $02,

    $79, $00, $09, $03, $02, $59, $00, $03,
    $03, $02, $79, $00, $03, $03, $02, $B1,
    $03, $13, $03, $02, $B1, $03, $14, $03,
    $03, $B1, $03, $13, $03, $00, $03, $03,
    $B1, $03, $14, $03, $00, $03, $03, $B1,
    $03, $13, $03, $01, $03, $03, $B1, $03,
    $14, $03, $01, $03, $03, $B1, $03, $13,
    $03, $42, $03, $03, $B1, $03, $14, $03,

    $42, $03, $02, $91, $03, $13, $03, $02,
    $91, $03, $14, $03, $03, $91, $03, $13,
    $03, $00, $03, $03, $91, $03, $14, $03,
    $00, $03, $03, $91, $03, $13, $03, $01,
    $03, $03, $91, $03, $14, $03, $01, $03,
    $03, $91, $03, $13, $03, $42, $03, $03,
    $91, $03, $14, $03, $42, $03, $02, $B5,
    $03, $13, $03, $02, $B5, $03, $14, $03,

    $03, $B5, $03, $13, $03, $00, $03, $03,
    $B5, $03, $14, $03, $00, $03, $03, $B5,
    $03, $13, $03, $01, $03, $03, $B5, $03,
    $14, $03, $01, $03, $02, $95, $03, $13,
    $03, $02, $95, $03, $14, $03, $03, $95,
    $03, $13, $03, $00, $03, $03, $95, $03,
    $14, $03, $00, $03, $03, $95, $03, $13,
    $03, $01, $03, $03, $95, $03, $14, $03,

    $01, $03, $02, $B7, $03, $13, $03, $02,
    $B7, $03, $14, $03, $03, $B7, $03, $13,
    $03, $00, $03, $03, $B7, $03, $14, $03,
    $00, $03, $03, $B7, $03, $13, $03, $01,
    $03, $03, $B7, $03, $14, $03, $01, $03,
    $03, $B7, $03, $13, $03, $42, $03, $03,
    $B7, $03, $14, $03, $42, $03, $02, $97,
    $03, $13, $03, $02, $97, $03, $14, $03,

    $03, $97, $03, $13, $03, $00, $03, $03,
    $97, $03, $14, $03, $00, $03, $03, $97,
    $03, $13, $03, $01, $03, $03, $97, $03,
    $14, $03, $01, $03, $03, $97, $03, $13,
    $03, $42, $03, $03, $97, $03, $14, $03,
    $42, $03, $02, $B9, $03, $13, $03, $02,
    $B9, $03, $14, $03, $03, $B9, $03, $13,
    $03, $00, $03, $03, $B9, $03, $14, $03,

    $00, $03, $03, $B9, $03, $13, $03, $01,
    $03, $03, $B9, $03, $14, $03, $01, $03,
    $03, $B9, $03, $13, $03, $42, $03, $03,
    $B9, $03, $14, $03, $42, $03, $02, $99,
    $03, $13, $03, $02, $99, $03, $14, $03,
    $03, $99, $03, $13, $03, $00, $03, $03,
    $99, $03, $14, $03, $00, $03, $03, $99,
    $03, $13, $03, $01, $03, $03, $99, $03,

    $14, $03, $01, $03, $03, $99, $03, $13,
    $03, $42, $03, $03, $99, $03, $14, $03,
    $42, $03, $02, $BF, $03, $13, $03, $02,
    $BF, $03, $14, $03, $03, $BF, $03, $13,
    $03, $00, $03, $03, $BF, $03, $14, $03,
    $00, $03, $03, $BF, $03, $13, $03, $01,
    $03, $03, $BF, $03, $14, $03, $01, $03,
    $02, $9F, $03, $13, $03, $02, $9F, $03,

    $14, $03, $03, $9F, $03, $13, $03, $00,
    $03, $03, $9F, $03, $14, $03, $00, $03,
    $03, $9F, $03, $13, $03, $01, $03, $03,
    $9F, $03, $14, $03, $01, $03, $02, $C5,
    $03, $13, $03, $02, $C5, $03, $14, $03,
    $03, $C5, $03, $13, $03, $00, $03, $03,
    $C5, $03, $14, $03, $00, $03, $03, $C5,
    $03, $13, $03, $01, $03, $03, $C5, $03,

    $14, $03, $01, $03, $03, $C5, $03, $13,
    $03, $42, $03, $03, $C5, $03, $14, $03,
    $42, $03, $02, $A5, $03, $14, $03, $03,
    $A5, $03, $14, $03, $00, $03, $03, $A5,
    $03, $14, $03, $01, $03, $03, $A5, $03,
    $14, $03, $42, $03, $02, $C9, $03, $13,
    $03, $02, $C9, $03, $14, $03, $03, $C9,
    $03, $13, $03, $00, $03, $03, $C9, $03,

    $14, $03, $00, $03, $03, $C9, $03, $13,
    $03, $01, $03, $03, $C9, $03, $14, $03,
    $01, $03, $03, $C9, $03, $13, $03, $42,
    $03, $03, $C9, $03, $14, $03, $42, $03,
    $02, $A9, $03, $13, $03, $02, $A9, $03,
    $14, $03, $03, $A9, $03, $13, $03, $00,
    $03, $03, $A9, $03, $14, $03, $00, $03,
    $03, $A9, $03, $13, $03, $01, $03, $03,

    $A9, $03, $14, $03, $01, $03, $03, $A9,
    $03, $13, $03, $42, $03, $03, $A9, $03,
    $14, $03, $42, $03, $02, $B1, $03, $00,
    $03, $02, $B5, $03, $00, $03, $02, $B7,
    $03, $00, $03, $02, $B9, $03, $00, $03,
    $02, $BF, $03, $00, $03, $02, $C5, $03,
    $00, $03, $02, $C9, $03, $00, $03, $03,
    $B1, $03, $13, $03, $45, $03, $03, $B1,

    $03, $14, $03, $45, $03, $04, $B1, $03,
    $13, $03, $00, $03, $45, $03, $04, $B1,
    $03, $14, $03, $00, $03, $45, $03, $04,
    $B1, $03, $13, $03, $01, $03, $45, $03,
    $04, $B1, $03, $14, $03, $01, $03, $45,
    $03, $04, $B1, $03, $13, $03, $42, $03,
    $45, $03, $04, $B1, $03, $14, $03, $42,
    $03, $45, $03, $03, $91, $03, $13, $03,

    $45, $03, $03, $91, $03, $14, $03, $45,
    $03, $04, $91, $03, $13, $03, $00, $03,
    $45, $03, $04, $91, $03, $14, $03, $00,
    $03, $45, $03, $04, $91, $03, $13, $03,
    $01, $03, $45, $03, $04, $91, $03, $14,
    $03, $01, $03, $45, $03, $04, $91, $03,
    $13, $03, $42, $03, $45, $03, $04, $91,
    $03, $14, $03, $42, $03, $45, $03, $03,

    $B7, $03, $13, $03, $45, $03, $03, $B7,
    $03, $14, $03, $45, $03, $04, $B7, $03,
    $13, $03, $00, $03, $45, $03, $04, $B7,
    $03, $14, $03, $00, $03, $45, $03, $04,
    $B7, $03, $13, $03, $01, $03, $45, $03,
    $04, $B7, $03, $14, $03, $01, $03, $45,
    $03, $04, $B7, $03, $13, $03, $42, $03,
    $45, $03, $04, $B7, $03, $14, $03, $42,

    $03, $45, $03, $03, $97, $03, $13, $03,
    $45, $03, $03, $97, $03, $14, $03, $45,
    $03, $04, $97, $03, $13, $03, $00, $03,
    $45, $03, $04, $97, $03, $14, $03, $00,
    $03, $45, $03, $04, $97, $03, $13, $03,
    $01, $03, $45, $03, $04, $97, $03, $14,
    $03, $01, $03, $45, $03, $04, $97, $03,
    $13, $03, $42, $03, $45, $03, $04, $97,

    $03, $14, $03, $42, $03, $45, $03, $03,
    $C9, $03, $13, $03, $45, $03, $03, $C9,
    $03, $14, $03, $45, $03, $04, $C9, $03,
    $13, $03, $00, $03, $45, $03, $04, $C9,
    $03, $14, $03, $00, $03, $45, $03, $04,
    $C9, $03, $13, $03, $01, $03, $45, $03,
    $04, $C9, $03, $14, $03, $01, $03, $45,
    $03, $04, $C9, $03, $13, $03, $42, $03,

    $45, $03, $04, $C9, $03, $14, $03, $42,
    $03, $45, $03, $03, $A9, $03, $13, $03,
    $45, $03, $03, $A9, $03, $14, $03, $45,
    $03, $04, $A9, $03, $13, $03, $00, $03,
    $45, $03, $04, $A9, $03, $14, $03, $00,
    $03, $45, $03, $04, $A9, $03, $13, $03,
    $01, $03, $45, $03, $04, $A9, $03, $14,
    $03, $01, $03, $45, $03, $04, $A9, $03,

    $13, $03, $42, $03, $45, $03, $04, $A9,
    $03, $14, $03, $42, $03, $45, $03, $02,
    $B1, $03, $06, $03, $02, $B1, $03, $04,
    $03, $03, $B1, $03, $00, $03, $45, $03,
    $02, $B1, $03, $45, $03, $03, $B1, $03,
    $01, $03, $45, $03, $02, $B1, $03, $42,
    $03, $03, $B1, $03, $42, $03, $45, $03,
    $02, $91, $03, $06, $03, $02, $91, $03,

    $04, $03, $02, $91, $03, $00, $03, $02,
    $91, $03, $45, $03, $01, $B9, $03, $02,
    $A8, $00, $42, $03, $03, $B7, $03, $00,
    $03, $45, $03, $02, $B7, $03, $45, $03,
    $03, $B7, $03, $01, $03, $45, $03, $02,
    $B7, $03, $42, $03, $03, $B7, $03, $42,
    $03, $45, $03, $02, $95, $03, $00, $03,
    $02, $97, $03, $00, $03, $02, $97, $03,

    $45, $03, $02, $BF, $1F, $00, $03, $02,
    $BF, $1F, $01, $03, $02, $BF, $1F, $42,
    $03, $02, $B9, $03, $06, $03, $02, $B9,
    $03, $04, $03, $03, $B9, $03, $08, $03,
    $00, $03, $02, $B9, $03, $42, $03, $03,
    $B9, $03, $08, $03, $42, $03, $02, $99,
    $03, $06, $03, $02, $99, $03, $04, $03,
    $02, $99, $03, $00, $03, $02, $FE, $1F,

    $00, $03, $02, $FE, $1F, $01, $03, $02,
    $FE, $1F, $42, $03, $02, $C5, $03, $06,
    $03, $02, $C5, $03, $04, $03, $03, $C5,
    $03, $08, $03, $00, $03, $02, $C1, $03,
    $13, $03, $02, $C1, $03, $14, $03, $02,
    $C5, $03, $42, $03, $03, $C5, $03, $08,
    $03, $42, $03, $02, $A5, $03, $06, $03,
    $02, $A5, $03, $04, $03, $02, $A5, $03,

    $00, $03, $02, $A1, $03, $14, $03, $02,
    $A8, $00, $00, $03, $01, $60, $00, $03,
    $C9, $03, $00, $03, $45, $03, $02, $C9,
    $03, $45, $03, $03, $C9, $03, $01, $03,
    $45, $03, $02, $C9, $03, $42, $03, $03,
    $C9, $03, $42, $03, $45, $03, $02, $9F,
    $03, $00, $03, $02, $A9, $03, $00, $03,
    $02, $A9, $03, $45, $03, $01, $B4, $00,

    $01, $02, $20, $01, $03, $20, $01, $A9,
    $03, $01, $4B, $00, $02, $90, $21, $38,
    $03, $02, $92, $21, $38, $03, $02, $94,
    $21, $38, $03, $02, $D0, $21, $38, $03,
    $02, $D4, $21, $38, $03, $02, $D2, $21,
    $38, $03, $02, $03, $22, $38, $03, $02,
    $08, $22, $38, $03, $02, $0B, $22, $38,
    $03, $02, $23, $22, $38, $03, $02, $25,

    $22, $38, $03, $02, $3C, $22, $38, $03,
    $02, $43, $22, $38, $03, $02, $45, $22,
    $38, $03, $02, $48, $22, $38, $03, $02,
    $3D, $00, $38, $03, $02, $61, $22, $38,
    $03, $02, $4D, $22, $38, $03, $02, $3C,
    $00, $38, $03, $02, $3E, $00, $38, $03,
    $02, $64, $22, $38, $03, $02, $65, $22,
    $38, $03, $02, $72, $22, $38, $03, $02,

    $73, $22, $38, $03, $02, $76, $22, $38,
    $03, $02, $77, $22, $38, $03, $02, $7A,
    $22, $38, $03, $02, $7B, $22, $38, $03,
    $02, $82, $22, $38, $03, $02, $83, $22,
    $38, $03, $02, $86, $22, $38, $03, $02,
    $87, $22, $38, $03, $02, $A2, $22, $38,
    $03, $02, $A8, $22, $38, $03, $02, $A9,
    $22, $38, $03, $02, $AB, $22, $38, $03,

    $02, $7C, $22, $38, $03, $02, $7D, $22,
    $38, $03, $02, $91, $22, $38, $03, $02,
    $92, $22, $38, $03, $02, $B2, $22, $38,
    $03, $02, $B3, $22, $38, $03, $02, $B4,
    $22, $38, $03, $02, $B5, $22, $38, $03,
    $01, $08, $30, $01, $09, $30, $02, $DD,
    $2A, $38, $03, $02, $4B, $30, $99, $30,
    $02, $4D, $30, $99, $30, $02, $4F, $30,

    $99, $30, $02, $51, $30, $99, $30, $02,
    $53, $30, $99, $30, $02, $55, $30, $99,
    $30, $02, $57, $30, $99, $30, $02, $59,
    $30, $99, $30, $02, $5B, $30, $99, $30,
    $02, $5D, $30, $99, $30, $02, $5F, $30,
    $99, $30, $02, $61, $30, $99, $30, $02,
    $64, $30, $99, $30, $02, $66, $30, $99,
    $30, $02, $68, $30, $99, $30, $02, $6F,

    $30, $99, $30, $02, $6F, $30, $9A, $30,
    $02, $72, $30, $99, $30, $02, $72, $30,
    $9A, $30, $02, $75, $30, $99, $30, $02,
    $75, $30, $9A, $30, $02, $78, $30, $99,
    $30, $02, $78, $30, $9A, $30, $02, $7B,
    $30, $99, $30, $02, $7B, $30, $9A, $30,
    $02, $46, $30, $99, $30, $02, $9D, $30,
    $99, $30, $02, $AB, $30, $99, $30, $02,

    $AD, $30, $99, $30, $02, $AF, $30, $99,
    $30, $02, $B1, $30, $99, $30, $02, $B3,
    $30, $99, $30, $02, $B5, $30, $99, $30,
    $02, $B7, $30, $99, $30, $02, $B9, $30,
    $99, $30, $02, $BB, $30, $99, $30, $02,
    $BD, $30, $99, $30, $02, $BF, $30, $99,
    $30, $02, $C1, $30, $99, $30, $02, $C4,
    $30, $99, $30, $02, $C6, $30, $99, $30,

    $02, $C8, $30, $99, $30, $02, $CF, $30,
    $99, $30, $02, $CF, $30, $9A, $30, $02,
    $D2, $30, $99, $30, $02, $D2, $30, $9A,
    $30, $02, $D5, $30, $99, $30, $02, $D5,
    $30, $9A, $30, $02, $D8, $30, $99, $30,
    $02, $D8, $30, $9A, $30, $02, $DB, $30,
    $99, $30, $02, $DB, $30, $9A, $30, $02,
    $A6, $30, $99, $30, $02, $EF, $30, $99,

    $30, $02, $F0, $30, $99, $30, $02, $F1,
    $30, $99, $30, $02, $F2, $30, $99, $30,
    $02, $FD, $30, $99, $30, $01, $48, $8C,
    $01, $F4, $66, $01, $CA, $8E, $01, $C8,
    $8C, $01, $D1, $6E, $01, $32, $4E, $01,
    $E5, $53, $01, $9C, $9F, $01, $51, $59,
    $01, $D1, $91, $01, $87, $55, $01, $48,
    $59, $01, $F6, $61, $01, $69, $76, $01,

    $85, $7F, $01, $3F, $86, $01, $BA, $87,
    $01, $F8, $88, $01, $8F, $90, $01, $02,
    $6A, $01, $1B, $6D, $01, $D9, $70, $01,
    $DE, $73, $01, $3D, $84, $01, $6A, $91,
    $01, $F1, $99, $01, $82, $4E, $01, $75,
    $53, $01, $04, $6B, $01, $1B, $72, $01,
    $2D, $86, $01, $1E, $9E, $01, $50, $5D,
    $01, $EB, $6F, $01, $CD, $85, $01, $64,

    $89, $01, $C9, $62, $01, $D8, $81, $01,
    $1F, $88, $01, $CA, $5E, $01, $17, $67,
    $01, $6A, $6D, $01, $FC, $72, $01, $CE,
    $90, $01, $86, $4F, $01, $B7, $51, $01,
    $DE, $52, $01, $C4, $64, $01, $D3, $6A,
    $01, $10, $72, $01, $E7, $76, $01, $01,
    $80, $01, $06, $86, $01, $5C, $86, $01,
    $EF, $8D, $01, $32, $97, $01, $6F, $9B,

    $01, $FA, $9D, $01, $8C, $78, $01, $7F,
    $79, $01, $A0, $7D, $01, $C9, $83, $01,
    $04, $93, $01, $7F, $9E, $01, $D6, $8A,
    $01, $DF, $58, $01, $04, $5F, $01, $60,
    $7C, $01, $7E, $80, $01, $62, $72, $01,
    $CA, $78, $01, $C2, $8C, $01, $F7, $96,
    $01, $D8, $58, $01, $62, $5C, $01, $13,
    $6A, $01, $DA, $6D, $01, $0F, $6F, $01,

    $2F, $7D, $01, $37, $7E, $01, $4B, $96,
    $01, $D2, $52, $01, $8B, $80, $01, $DC,
    $51, $01, $CC, $51, $01, $1C, $7A, $01,
    $BE, $7D, $01, $F1, $83, $01, $75, $96,
    $01, $80, $8B, $01, $CF, $62, $01, $FE,
    $8A, $01, $39, $4E, $01, $E7, $5B, $01,
    $12, $60, $01, $87, $73, $01, $70, $75,
    $01, $17, $53, $01, $FB, $78, $01, $BF,

    $4F, $01, $A9, $5F, $01, $0D, $4E, $01,
    $CC, $6C, $01, $78, $65, $01, $22, $7D,
    $01, $C3, $53, $01, $5E, $58, $01, $01,
    $77, $01, $49, $84, $01, $AA, $8A, $01,
    $BA, $6B, $01, $B0, $8F, $01, $88, $6C,
    $01, $FE, $62, $01, $E5, $82, $01, $A0,
    $63, $01, $65, $75, $01, $AE, $4E, $01,
    $69, $51, $01, $C9, $51, $01, $81, $68,

    $01, $E7, $7C, $01, $6F, $82, $01, $D2,
    $8A, $01, $CF, $91, $01, $F5, $52, $01,
    $42, $54, $01, $73, $59, $01, $EC, $5E,
    $01, $C5, $65, $01, $FE, $6F, $01, $2A,
    $79, $01, $AD, $95, $01, $6A, $9A, $01,
    $97, $9E, $01, $CE, $9E, $01, $9B, $52,
    $01, $C6, $66, $01, $77, $6B, $01, $62,
    $8F, $01, $74, $5E, $01, $90, $61, $01,

    $00, $62, $01, $9A, $64, $01, $23, $6F,
    $01, $49, $71, $01, $89, $74, $01, $CA,
    $79, $01, $F4, $7D, $01, $6F, $80, $01,
    $26, $8F, $01, $EE, $84, $01, $23, $90,
    $01, $4A, $93, $01, $17, $52, $01, $A3,
    $52, $01, $BD, $54, $01, $C8, $70, $01,
    $C2, $88, $01, $C9, $5E, $01, $F5, $5F,
    $01, $7B, $63, $01, $AE, $6B, $01, $3E,

    $7C, $01, $75, $73, $01, $E4, $4E, $01,
    $F9, $56, $01, $BA, $5D, $01, $1C, $60,
    $01, $B2, $73, $01, $69, $74, $01, $9A,
    $7F, $01, $46, $80, $01, $34, $92, $01,
    $F6, $96, $01, $48, $97, $01, $18, $98,
    $01, $8B, $4F, $01, $AE, $79, $01, $B4,
    $91, $01, $B8, $96, $01, $E1, $60, $01,
    $86, $4E, $01, $DA, $50, $01, $EE, $5B,

    $01, $3F, $5C, $01, $99, $65, $01, $CE,
    $71, $01, $42, $76, $01, $FC, $84, $01,
    $7C, $90, $01, $8D, $9F, $01, $88, $66,
    $01, $2E, $96, $01, $89, $52, $01, $7B,
    $67, $01, $F3, $67, $01, $41, $6D, $01,
    $9C, $6E, $01, $09, $74, $01, $59, $75,
    $01, $6B, $78, $01, $10, $7D, $01, $5E,
    $98, $01, $6D, $51, $01, $2E, $62, $01,

    $78, $96, $01, $2B, $50, $01, $19, $5D,
    $01, $EA, $6D, $01, $2A, $8F, $01, $8B,
    $5F, $01, $44, $61, $01, $17, $68, $01,
    $86, $96, $01, $29, $52, $01, $0F, $54,
    $01, $65, $5C, $01, $13, $66, $01, $4E,
    $67, $01, $A8, $68, $01, $E5, $6C, $01,
    $06, $74, $01, $E2, $75, $01, $79, $7F,
    $01, $CF, $88, $01, $E1, $88, $01, $CC,

    $91, $01, $E2, $96, $01, $3F, $53, $01,
    $BA, $6E, $01, $1D, $54, $01, $D0, $71,
    $01, $98, $74, $01, $FA, $85, $01, $A3,
    $96, $01, $57, $9C, $01, $9F, $9E, $01,
    $97, $67, $01, $CB, $6D, $01, $E8, $81,
    $01, $CB, $7A, $01, $20, $7B, $01, $92,
    $7C, $01, $C0, $72, $01, $99, $70, $01,
    $58, $8B, $01, $C0, $4E, $01, $36, $83,

    $01, $3A, $52, $01, $07, $52, $01, $A6,
    $5E, $01, $D3, $62, $01, $D6, $7C, $01,
    $85, $5B, $01, $1E, $6D, $01, $B4, $66,
    $01, $3B, $8F, $01, $4C, $88, $01, $4D,
    $96, $01, $8B, $89, $01, $D3, $5E, $01,
    $40, $51, $01, $C0, $55, $01, $5A, $58,
    $01, $74, $66, $01, $DE, $51, $01, $2A,
    $73, $01, $CA, $76, $01, $3C, $79, $01,

    $5E, $79, $01, $65, $79, $01, $8F, $79,
    $01, $56, $97, $01, $BE, $7C, $01, $BD,
    $7F, $01, $12, $86, $01, $F8, $8A, $01,
    $38, $90, $01, $FD, $90, $01, $EF, $98,
    $01, $FC, $98, $01, $28, $99, $01, $B4,
    $9D, $01, $AE, $4F, $01, $E7, $50, $01,
    $4D, $51, $01, $C9, $52, $01, $E4, $52,
    $01, $51, $53, $01, $9D, $55, $01, $06,

    $56, $01, $68, $56, $01, $40, $58, $01,
    $A8, $58, $01, $64, $5C, $01, $6E, $5C,
    $01, $94, $60, $01, $68, $61, $01, $8E,
    $61, $01, $F2, $61, $01, $4F, $65, $01,
    $E2, $65, $01, $91, $66, $01, $85, $68,
    $01, $77, $6D, $01, $1A, $6E, $01, $22,
    $6F, $01, $6E, $71, $01, $2B, $72, $01,
    $22, $74, $01, $91, $78, $01, $3E, $79,

    $01, $49, $79, $01, $48, $79, $01, $50,
    $79, $01, $56, $79, $01, $5D, $79, $01,
    $8D, $79, $01, $8E, $79, $01, $40, $7A,
    $01, $81, $7A, $01, $C0, $7B, $01, $09,
    $7E, $01, $41, $7E, $01, $72, $7F, $01,
    $05, $80, $01, $ED, $81, $01, $79, $82,
    $01, $57, $84, $01, $10, $89, $01, $96,
    $89, $01, $01, $8B, $01, $39, $8B, $01,

    $D3, $8C, $01, $08, $8D, $01, $B6, $8F,
    $01, $E3, $96, $01, $FF, $97, $01, $3B,
    $98, $02, $D9, $05, $B4, $05, $02, $F2,
    $05, $B7, $05, $02, $E9, $05, $C1, $05,
    $02, $E9, $05, $C2, $05, $03, $E9, $05,
    $BC, $05, $C1, $05, $03, $E9, $05, $BC,
    $05, $C2, $05, $02, $D0, $05, $B7, $05,
    $02, $D0, $05, $B8, $05, $02, $D0, $05,

    $BC, $05, $02, $D1, $05, $BC, $05, $02,
    $D2, $05, $BC, $05, $02, $D3, $05, $BC,
    $05, $02, $D4, $05, $BC, $05, $02, $D5,
    $05, $BC, $05, $02, $D6, $05, $BC, $05,
    $02, $D8, $05, $BC, $05, $02, $D9, $05,
    $BC, $05, $02, $DA, $05, $BC, $05, $02,
    $DB, $05, $BC, $05, $02, $DC, $05, $BC,
    $05, $02, $DE, $05, $BC, $05, $02, $E0,

    $05, $BC, $05, $02, $E1, $05, $BC, $05,
    $02, $E3, $05, $BC, $05, $02, $E4, $05,
    $BC, $05, $02, $E6, $05, $BC, $05, $02,
    $E7, $05, $BC, $05, $02, $E8, $05, $BC,
    $05, $02, $E9, $05, $BC, $05, $02, $EA,
    $05, $BC, $05, $02, $D5, $05, $B9, $05,
    $02, $D1, $05, $BF, $05, $02, $DB, $05,
    $BF, $05, $02, $E4, $05, $BF, $05);
var
  i: Cardinal;
begin
  i := CHAR_CANONICAL_DECOMPOSITION_1[Ord(Char) div CHAR_CANONICAL_DECOMPOSITION_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      i := CHAR_CANONICAL_DECOMPOSITION_2[i, Ord(Char) and (CHAR_CANONICAL_DECOMPOSITION_SIZE - 1)];
      if i <> 0 then
        begin
          Result := Pointer(@CHAR_CANONICAL_DECOMPOSITION_DATA[i]);
          Exit;
        end;
    end;
  Result := nil;
end;

function CharDecomposeCompatibleW(const Char: WideChar): PCharDecompositionW;
const
  CHAR_COMPATIBLE_DECOMPOSITION_1: array[$0000..$07FF] of Byte = (
    $00, $00, $00, $00, $00, $01, $00, $00,
    $00, $02, $03, $04, $00, $00, $05, $06,
    $00, $00, $00, $00, $00, $07, $08, $09,
    $00, $00, $00, $0A, $0B, $00, $0C, $0D,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $0E, $00, $00, $00,
    $00, $00, $00, $0F, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $10, $00, $00, $00, $11, $12, $00,
    $13, $00, $00, $14, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $15, $16, $17, $00, $00, $00, $00,
    $00, $00, $00, $00, $18, $00, $00, $00,
    $00, $00, $00, $00, $00, $19, $1A, $1B,

    $1C, $1D, $1E, $1F, $20, $21, $00, $00,
    $22, $23, $24, $25, $00, $00, $00, $00,
    $00, $26, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $27, $28, $29, $2A, $2B,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $2C, $00, $00, $2D, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $2E, $00, $00, $2F,
    $30, $31, $32, $33, $34, $35, $36, $00,

    $37, $38, $00, $00, $39, $00, $00, $3A,
    $00, $3B, $3C, $3D, $3E, $00, $00, $00,
    $3F, $40, $41, $42, $43, $44, $45, $46,
    $47, $48, $49, $4A, $4B, $4C, $4D, $4E,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $4F, $50, $51, $52, $53, $54, $55, $56,
    $57, $58, $59, $5A, $5B, $5C, $5D, $5E,
    $5F, $60, $61, $62, $63, $64, $65, $66,
    $00, $67, $68, $69, $6A, $6B, $6C, $6D,
    $6E, $6F, $70, $71, $72, $73, $74, $75);
  CHAR_COMPATIBLE_DECOMPOSITION_2: array[$0000..$0074, $0000..$001F] of Word = (

    ($0001, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0004, $0000, $0009, $0000, $0000, $0000, $0000, $000C,
    $0000, $0000, $0011, $0014, $0017, $001C, $0000, $0000,
    $001F, $0024, $0027, $0000, $002A, $0031, $0038, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $003F, $0044, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0049),

    ($004E, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0053, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0058),

    ($0000, $0000, $0000, $0000, $005B, $0062, $0069, $0070,
    $0075, $007A, $007F, $0084, $0089, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $008E, $0093, $0098, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $009D, $00A0, $00A3, $00A6, $00A9, $00AC, $00AF, $00B2,
    $00B5, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $00B8, $00BD, $00C2, $00C7, $00CC, $00D1, $0000, $0000),

    ($00D6, $00D9, $0058, $00DC, $00DF, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $00E2, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0017, $00E7, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $00EE, $00F1, $00F4, $00F7, $00FC, $0101, $0104, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0107, $010A, $010D, $0000, $0110, $0113, $0000, $0000,
    $0000, $0116, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0119,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $011E, $0123, $0128,
    $012D, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0132, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0137, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $013C, $0141, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0146, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0149,
    $0000, $0150, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0157, $015A, $015D, $0000,
    $0160, $0163, $0166, $0169, $016C, $016F, $0172, $0175,
    $0178, $017B, $017E, $0000, $0181, $0184, $0187, $018A),

    ($018D, $0190, $0193, $0009, $0196, $0199, $019C, $019F,
    $01A2, $01A5, $01A8, $01AB, $01AE, $01B1, $0000, $01B4,
    $01B7, $01BA, $0027, $01BD, $01C0, $01C3, $01C6, $01C9,
    $01CC, $01CF, $01D2, $01D5, $01D8, $00EE, $01DB, $01DE),

    ($0101, $01E1, $01E4, $00A6, $01CC, $01D5, $00EE, $01DB,
    $010A, $0101, $01E1, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $01E7, $01EC, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $01F1, $0000, $01F1),

    ($01F6, $01FB, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0202, $0209, $0210,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0217, $021E, $0225),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $022C, $00E7, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0017, $0233, $0000),

    ($0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001,
    $0001, $0001, $0001, $0000, $0000, $0000, $0000, $0000,
    $0000, $0238, $0000, $0000, $0000, $0000, $0000, $023B,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0240, $0243, $0248, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0001,
    $0000, $0000, $0000, $024F, $0254, $0000, $025B, $0260,
    $0000, $0000, $0000, $0000, $0267, $0000, $026C, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0271,
    $0276, $027B, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0280,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0001),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0289, $01E4, $0000, $0000, $028C, $028F, $0292, $0295,
    $0298, $029B, $029E, $02A1, $02A4, $02A7, $02AA, $02AD),

    ($0289, $0024, $0011, $0014, $028C, $028F, $0292, $0295,
    $0298, $029B, $029E, $02A1, $02A4, $02A7, $02AA, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $02B0, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($02B5, $02BC, $02C3, $02C6, $0000, $02CB, $02D2, $02D9,
    $0000, $02DC, $01B1, $016C, $016C, $016C, $009D, $02E1,
    $016F, $016F, $0178, $00D9, $0000, $017E, $02E4, $0000,
    $0000, $0187, $02E9, $018A, $018A, $018A, $0000, $0000),

    ($02EC, $02F1, $02F8, $0000, $02FD, $0000, $0000, $0000,
    $02FD, $0000, $0000, $0000, $015D, $02C3, $0000, $01A5,
    $0163, $0300, $0000, $017B, $0027, $0303, $0306, $0309,
    $030C, $01E4, $0000, $030F, $0000, $01DB, $0316, $0319),

    ($031C, $0000, $0000, $0000, $0000, $0160, $01A2, $01A5,
    $01E4, $00A3, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $031F, $0326, $032D, $0334, $033B,
    $0342, $0349, $0350, $0357, $035E, $0365, $036C, $0373),

    ($016F, $0378, $037D, $0384, $0389, $038C, $0391, $0398,
    $03A1, $03A6, $03A9, $03AE, $0178, $02C3, $0160, $017B,
    $01E4, $03B5, $03BA, $03C1, $01D5, $03C6, $03CB, $03D2,
    $03DB, $00DC, $03E0, $03E5, $00D9, $03EC, $01A2, $01B7),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $03EF, $03F4, $0000, $03FB,
    $0400, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0024, $0011, $0014, $028C, $028F, $0292, $0295, $0298,
    $029B, $0407, $040C, $0411, $0416, $041B, $0420, $0425,
    $042A, $042F, $0434, $0439, $043E, $0445, $044C, $0453,
    $045A, $0461, $0468, $046F, $0476, $047D, $0486, $048F),

    ($0498, $04A1, $04AA, $04B3, $04BC, $04C5, $04CE, $04D7,
    $04E0, $04E5, $04EA, $04EF, $04F4, $04F9, $04FE, $0503,
    $0508, $050D, $0514, $051B, $0522, $0529, $0530, $0537,
    $053E, $0545, $054C, $0553, $055A, $0561, $0568, $056F),

    ($0576, $057D, $0584, $058B, $0592, $0599, $05A0, $05A7,
    $05AE, $05B5, $05BC, $05C3, $05CA, $05D1, $05D8, $05DF,
    $05E6, $05ED, $05F4, $05FB, $0602, $0609, $0157, $015D,
    $02C3, $0160, $0163, $0300, $0169, $016C, $016F, $0172),

    ($0175, $0178, $017B, $017E, $0181, $0187, $02E9, $018A,
    $0610, $018D, $0190, $0389, $0193, $03A6, $0613, $02FD,
    $0009, $019F, $03EC, $01A2, $01A5, $0616, $01B1, $009D,
    $01E4, $00A3, $01B4, $00D9, $01B7, $02AD, $0027, $01C6),

    ($0619, $00A6, $0058, $01C9, $01CC, $01D5, $00B2, $00DC,
    $00B5, $061C, $0289, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $061F, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0628, $062F, $0634, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $063B),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $063E, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0641, $0644, $0647, $064A, $064D, $0650, $0653, $0656,
    $0659, $065C, $065F, $0662, $0665, $0668, $066B, $066E,
    $0671, $0674, $0677, $067A, $067D, $0680, $0683, $0686,
    $0689, $068C, $068F, $0692, $0695, $0698, $069B, $069E),

    ($06A1, $06A4, $06A7, $06AA, $06AD, $06B0, $06B3, $06B6,
    $06B9, $06BC, $06BF, $06C2, $06C5, $06C8, $06CB, $06CE,
    $06D1, $06D4, $06D7, $06DA, $06DD, $06E0, $06E3, $06E6,
    $06E9, $06EC, $06EF, $06F2, $06F5, $06F8, $06FB, $06FE),

    ($0701, $0704, $0707, $070A, $070D, $0710, $0713, $0716,
    $0719, $071C, $071F, $0722, $0725, $0728, $072B, $072E,
    $0731, $0734, $0737, $073A, $073D, $0740, $0743, $0746,
    $0749, $074C, $074F, $0752, $0755, $0758, $075B, $075E),

    ($0761, $0764, $0767, $076A, $076D, $0770, $0773, $0776,
    $0779, $077C, $077F, $0782, $0785, $0788, $078B, $078E,
    $0791, $0794, $0797, $079A, $079D, $07A0, $07A3, $07A6,
    $07A9, $07AC, $07AF, $07B2, $07B5, $07B8, $07BB, $07BE),

    ($07C1, $07C4, $07C7, $07CA, $07CD, $07D0, $07D3, $07D6,
    $07D9, $07DC, $07DF, $07E2, $07E5, $07E8, $07EB, $07EE,
    $07F1, $07F4, $07F7, $07FA, $07FD, $0800, $0803, $0806,
    $0809, $080C, $080F, $0812, $0815, $0818, $081B, $081E),

    ($0821, $0824, $0827, $082A, $082D, $0830, $0833, $0836,
    $0839, $083C, $083F, $0842, $0845, $0848, $084B, $084E,
    $0851, $0854, $0857, $085A, $085D, $0860, $0863, $0866,
    $0869, $086C, $086F, $0872, $0875, $0878, $087B, $087E),

    ($0881, $0884, $0887, $088A, $088D, $0890, $0893, $0896,
    $0899, $089C, $089F, $08A2, $08A5, $08A8, $08AB, $08AE,
    $08B1, $08B4, $08B7, $08BA, $08BD, $08C0, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0001, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $08C3, $0000,
    $0686, $08C6, $08C9, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $08CC, $08D1, $0000, $0000, $08D6),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $08DB),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $08E0, $08E3, $08E6, $08E9, $08EC, $08EF, $08F2,
    $08F5, $08F8, $08FB, $08FE, $0901, $0904, $0907, $090A),

    ($090D, $0910, $0913, $0916, $0919, $091C, $091F, $0922,
    $0925, $0928, $092B, $092E, $0931, $0934, $0937, $093A,
    $093D, $0940, $0943, $0946, $0949, $094C, $094F, $0952,
    $0955, $0958, $095B, $095E, $0961, $0964, $0967, $096A),

    ($096D, $0970, $0973, $0976, $0979, $097C, $097F, $0982,
    $0985, $0988, $098B, $098E, $0991, $0994, $0997, $099A,
    $099D, $09A0, $09A3, $09A6, $09A9, $09AC, $09AF, $09B2,
    $09B5, $09B8, $09BB, $09BE, $09C1, $09C4, $09C7, $09CA),

    ($09CD, $09D0, $09D3, $09D6, $09D9, $09DC, $09DF, $09E2,
    $09E5, $09E8, $09EB, $09EE, $09F1, $09F4, $09F7, $0000,
    $0000, $0000, $0641, $0653, $09FA, $09FD, $0A00, $0A03,
    $0A06, $0A09, $064D, $0A0C, $0A0F, $0A12, $0A15, $0659),

    ($0A18, $0A1F, $0A26, $0A2D, $0A34, $0A3B, $0A42, $0A49,
    $0A50, $0A57, $0A5E, $0A65, $0A6C, $0A73, $0A7A, $0A83,
    $0A8C, $0A95, $0A9E, $0AA7, $0AB0, $0AB9, $0AC2, $0ACB,
    $0AD4, $0ADD, $0AE6, $0AEF, $0AF8, $0B01, $0B10, $0000),

    ($0B1D, $0B24, $0B2B, $0B32, $0B39, $0B40, $0B47, $0B4E,
    $0B55, $0B5C, $0B63, $0B6A, $0B71, $0B78, $0B7F, $0B86,
    $0B8D, $0B94, $0B9B, $0BA2, $0BA9, $0BB0, $0BB7, $0BBE,
    $0BC5, $0BCC, $0BD3, $0BDA, $0BE1, $0BE8, $0BEF, $0BF6),

    ($0BFD, $0C04, $0C0B, $0C12, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0C19, $0C20, $0C25, $0C2A, $0C2F, $0C34, $0C39, $0C3E,
    $0C43, $0C48, $0C4D, $0C52, $0C57, $0C5C, $0C61, $0C66),

    ($08E0, $08E9, $08F2, $08F8, $0910, $0913, $091C, $0922,
    $0925, $092B, $092E, $0931, $0934, $0937, $0C6B, $0C70,
    $0C75, $0C7A, $0C7F, $0C84, $0C89, $0C8E, $0C93, $0C98,
    $0C9D, $0CA2, $0CA7, $0CAC, $0CB1, $0CBC, $0000, $0000),

    ($0641, $0653, $09FA, $09FD, $0CC5, $0CC8, $0CCB, $0662,
    $0CCE, $0686, $071C, $0740, $073D, $071F, $0833, $069E,
    $0716, $0CD1, $0CD4, $0CD7, $0CDA, $0CDD, $0CE0, $0CE3,
    $0CE6, $0CE9, $0CEC, $06B0, $0CEF, $0CF2, $0CF5, $0CF8),

    ($0CFB, $0CFE, $0D01, $0D04, $0A00, $0A03, $0A06, $0D07,
    $0D0A, $0D0D, $0D10, $0D13, $0D16, $0D19, $0D1C, $0D1F,
    $0D22, $0D25, $0D2A, $0D2F, $0D34, $0D39, $0D3E, $0D43,
    $0D48, $0D4D, $0D52, $0D57, $0D5C, $0D61, $0D66, $0D6B),

    ($0D70, $0D75, $0D7A, $0D7F, $0D84, $0D89, $0D8E, $0D93,
    $0D98, $0D9D, $0DA4, $0DAB, $0DB2, $0DB7, $0DBE, $0DC3,
    $0DCA, $0DCD, $0DD0, $0DD3, $0DD6, $0DD9, $0DDC, $0DDF,
    $0DE2, $0DE5, $0DE8, $0DEB, $0DEE, $0DF1, $0DF4, $0DF7),

    ($0DFA, $0DFD, $0E00, $0E03, $0E06, $0E09, $0E0C, $0E0F,
    $0E12, $0E15, $0E18, $0E1B, $0E1E, $0E21, $0E24, $0E27,
    $0E2A, $0E2D, $0E30, $0E33, $0E36, $0E39, $0E3C, $0E3F,
    $0E42, $0E45, $0E48, $0E4B, $0E4E, $0E51, $0E54, $0000),

    ($0E57, $0E62, $0E6B, $0E76, $0E7D, $0E88, $0E8F, $0E96,
    $0EA3, $0EAC, $0EB3, $0EBA, $0EC1, $0ECA, $0ED3, $0EDC,
    $0EE5, $0EEE, $0EF7, $0F00, $0F0D, $0F12, $0F1F, $0F2C,
    $0F37, $0F40, $0F4D, $0F5A, $0F63, $0F6A, $0F71, $0F7A),

    ($0F83, $0F8E, $0F99, $0FA0, $0FA7, $0FB0, $0FB7, $0FBE,
    $0FC3, $0FC8, $0FCF, $0FD6, $0FE3, $0FEC, $0FF7, $1004,
    $100D, $1014, $101B, $1028, $1031, $103E, $1045, $1050,
    $1057, $1060, $1067, $1070, $107B, $1084, $108F, $1098),

    ($109D, $10A8, $10AF, $10B6, $10BF, $10C6, $10CD, $10D4,
    $10DF, $10E8, $10ED, $10FA, $1101, $110C, $1115, $111E,
    $1125, $112C, $1135, $113A, $1143, $114E, $1153, $1160,
    $1167, $116C, $1171, $1176, $117B, $1180, $1185, $118A),

    ($118F, $1194, $1199, $11A0, $11A7, $11AE, $11B5, $11BC,
    $11C3, $11CA, $11D1, $11D8, $11DF, $11E6, $11ED, $11F4,
    $11FB, $1202, $1209, $120E, $1213, $121A, $121F, $1224,
    $1229, $1230, $1237, $123C, $1241, $1246, $124B, $1250),

    ($1259, $125E, $1263, $1268, $126D, $1272, $1277, $127C,
    $1281, $1288, $1291, $1296, $129B, $12A0, $12A5, $12AA,
    $12AF, $12B4, $12BB, $12C2, $12C9, $12D0, $12D5, $12DA,
    $12DF, $12E4, $12E9, $12EE, $12F3, $12F8, $12FD, $1302),

    ($1309, $1310, $1315, $131C, $1323, $132A, $132F, $1336,
    $133D, $1346, $134B, $1352, $1359, $1360, $1367, $1372,
    $137F, $1384, $1389, $138E, $1393, $1398, $139D, $13A2,
    $13A7, $13AC, $13B1, $13B6, $13BB, $13C0, $13C5, $13CA),

    ($13CF, $13D4, $13D9, $13E2, $13E7, $13EC, $13F1, $13FA,
    $1401, $1406, $140B, $1410, $1415, $141A, $141F, $1424,
    $1429, $142E, $1433, $143A, $143F, $1444, $144B, $1452,
    $1457, $1460, $1467, $146C, $1471, $1476, $147B, $1482),

    ($1489, $148E, $1493, $1498, $149D, $14A2, $14A7, $14AC,
    $14B1, $14B6, $14BD, $14C4, $14CB, $14D2, $14D9, $14E0,
    $14E7, $14EE, $14F5, $14FC, $1503, $150A, $1511, $1518,
    $151F, $1526, $152D, $1534, $153B, $1542, $1549, $1550),

    ($1557, $155C, $1561, $1566, $156D, $1574, $1574, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $1579, $157E, $1583, $1588, $158D,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($1592, $0303, $030C, $1595, $1598, $159B, $159E, $15A1,
    $15A4, $029E, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $15A7,
    $15AC, $15AC, $15AF, $15AF, $15AF, $15AF, $15B2, $15B2,
    $15B2, $15B2, $15B5, $15B5, $15B5, $15B5, $15B8, $15B8),

    ($15B8, $15B8, $15BB, $15BB, $15BB, $15BB, $15BE, $15BE,
    $15BE, $15BE, $15C1, $15C1, $15C1, $15C1, $15C4, $15C4,
    $15C4, $15C4, $15C7, $15C7, $15C7, $15C7, $15CA, $15CA,
    $15CA, $15CA, $15CD, $15CD, $15CD, $15CD, $15D0, $15D0),

    ($15D0, $15D0, $15D3, $15D3, $15D6, $15D6, $15D9, $15D9,
    $15DC, $15DC, $15DF, $15DF, $15E2, $15E2, $15E5, $15E5,
    $15E5, $15E5, $15E8, $15E8, $15E8, $15E8, $15EB, $15EB,
    $15EB, $15EB, $15EE, $15EE, $15EE, $15EE, $15F1, $15F1),

    ($15F4, $15F4, $15F4, $15F4, $15F7, $15F7, $15FC, $15FC,
    $15FC, $15FC, $15FF, $15FF, $15FF, $15FF, $1602, $1602,
    $1605, $1605, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $160A, $160A, $160A, $160A, $160D,
    $160D, $1610, $1610, $1613, $1613, $0128, $1616, $1616),

    ($1619, $1619, $161C, $161C, $161F, $161F, $161F, $161F,
    $1622, $1622, $1625, $1625, $162C, $162C, $1633, $1633,
    $163A, $163A, $1641, $1641, $1648, $1648, $164F, $164F,
    $164F, $1656, $1656, $1656, $165D, $165D, $165D, $165D),

    ($1660, $1667, $166E, $1656, $1675, $167C, $1681, $1686,
    $168B, $1690, $1695, $169A, $169F, $16A4, $16A9, $16AE,
    $16B3, $16B8, $16BD, $16C2, $16C7, $16CC, $16D1, $16D6,
    $16DB, $16E0, $16E5, $16EA, $16EF, $16F4, $16F9, $16FE),

    ($1703, $1708, $170D, $1712, $1717, $171C, $1721, $1726,
    $172B, $1730, $1735, $173A, $173F, $1744, $1749, $174E,
    $1753, $1758, $175D, $1762, $1767, $176C, $1771, $1776,
    $177B, $1780, $1785, $178A, $178F, $1794, $1799, $179E),

    ($17A3, $17A8, $17AD, $17B2, $17B7, $17BC, $17C1, $17C6,
    $17CB, $17D0, $17D5, $17DA, $17DF, $17E4, $17E9, $17EE,
    $17F3, $17F8, $17FD, $1802, $1807, $180C, $1811, $1816,
    $181B, $1820, $1825, $182A, $182F, $1834, $1839, $1840),

    ($1847, $184E, $1855, $185C, $1863, $186A, $166E, $1871,
    $1656, $1675, $1878, $187D, $168B, $1882, $1690, $1695,
    $1887, $188C, $16A9, $1891, $16AE, $16B3, $1896, $189B,
    $16BD, $18A0, $16C2, $16C7, $1758, $175D, $176C, $1771),

    ($1776, $178A, $178F, $1794, $1799, $17AD, $17B2, $17B7,
    $18A5, $17CB, $18AA, $18AF, $17E9, $18B4, $17EE, $17F3,
    $1834, $18B9, $18BE, $181B, $18C3, $1820, $1825, $1660,
    $1667, $18C8, $166E, $18CF, $167C, $1681, $1686, $168B),

    ($18D6, $169A, $169F, $16A4, $16A9, $18DB, $16BD, $16CC,
    $16D1, $16D6, $16DB, $16E0, $16EA, $16EF, $16F4, $16F9,
    $16FE, $1703, $18E0, $1708, $170D, $1712, $1717, $171C,
    $1721, $172B, $1730, $1735, $173A, $173F, $1744, $1749),

    ($174E, $1753, $1762, $1767, $177B, $1780, $1785, $178A,
    $178F, $179E, $17A3, $17A8, $17AD, $18E5, $17BC, $17C1,
    $17C6, $17CB, $17DA, $17DF, $17E4, $17E9, $18EA, $17F8,
    $17FD, $18EF, $180C, $1811, $1816, $181B, $18F4, $166E),

    ($18CF, $168B, $18D6, $16A9, $18DB, $16BD, $18F9, $16FE,
    $18FE, $1903, $1908, $178A, $178F, $17AD, $17E9, $18EA,
    $181B, $18F4, $190D, $1914, $191B, $1922, $1927, $192C,
    $1931, $1936, $193B, $1940, $1945, $194A, $194F, $1954),

    ($1959, $195E, $1963, $1968, $196D, $1972, $1977, $197C,
    $1981, $1986, $198B, $1990, $1903, $1995, $199A, $199F,
    $19A4, $1922, $1927, $192C, $1931, $1936, $193B, $1940,
    $1945, $194A, $194F, $1954, $1959, $195E, $1963, $1968),

    ($196D, $1972, $1977, $197C, $1981, $1986, $198B, $1990,
    $1903, $1995, $199A, $199F, $19A4, $1986, $198B, $1990,
    $1903, $18FE, $1908, $1726, $16EF, $16F4, $16F9, $1986,
    $198B, $1990, $1726, $172B, $19A9, $19A9, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $19AE, $19B5, $19B5, $19BC, $19C3, $19CA, $19D1, $19D8,
    $19DF, $19DF, $19E6, $19ED, $19F4, $19FB, $1A02, $1A09),

    ($1A09, $1A10, $1A17, $1A17, $1A1E, $1A1E, $1A25, $1A2C,
    $1A2C, $1A33, $1A3A, $1A3A, $1A41, $1A41, $1A48, $1A4F,
    $1A4F, $1A56, $1A56, $1A5D, $1A64, $1A6B, $1A72, $1A72,
    $1A79, $1A80, $1A87, $1A8E, $1A95, $1A95, $1A9C, $1AA3),

    ($1AAA, $1AB1, $1AB8, $1ABF, $1ABF, $1AC6, $1AC6, $1ACD,
    $1ACD, $1AD4, $1ADB, $1AE2, $1AE9, $1AF0, $1AF7, $1AFE,
    $0000, $0000, $1B05, $1B0C, $1B13, $1B1A, $1B21, $1B28,
    $1B28, $1B2F, $1B36, $1B3D, $1B44, $1B44, $1B4B, $1B52),

    ($1B59, $1B60, $1B67, $1B6E, $1B75, $1B7C, $1B83, $1B8A,
    $1B91, $1B98, $1B9F, $1BA6, $1BAD, $1BB4, $1BBB, $1BC2,
    $1BC9, $1BD0, $1BD7, $1BDE, $1A9C, $1AAA, $1BE5, $1BEC,
    $1BF3, $1BFA, $1C01, $1C08, $1C01, $1BF3, $1C0F, $1C16),

    ($1C1D, $1C24, $1C2B, $1C08, $1A6B, $1A25, $1C32, $1C39,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $1C40, $1C47, $1C4E, $1C57, $1C60, $1C69, $1C72, $1C7B,
    $1C84, $1C8D, $1C94, $1CB9, $1CCA, $0000, $0000, $0000),

    ($0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0243, $1CD3, $1CD6, $1CD9, $1CD9, $02A7, $02AA, $1CDC,
    $1CDF, $1CE2, $1CE5, $1CE8, $1CEB, $1CEE, $1CF1, $1CF4),

    ($1CF7, $1CFA, $1CFD, $1D00, $1D03, $0000, $0000, $1D06,
    $1D09, $026C, $026C, $026C, $026C, $1CD9, $1CD9, $1CD9,
    $1D0C, $1D0F, $0240, $0000, $1D12, $1D15, $1D18, $1D1B,
    $1CD3, $02A7, $02AA, $1CDC, $1CDF, $1CE2, $1CE5, $1D1E),

    ($1D21, $1D24, $029E, $1D27, $1D2A, $1D2D, $02A4, $0000,
    $1D30, $1D33, $1D36, $1D39, $0000, $0000, $0000, $0000,
    $1D3C, $1D41, $1D46, $0000, $1D4B, $0000, $1D50, $1D55,
    $1D5A, $1D5F, $1D64, $1D69, $1D6E, $1D73, $1D78, $1D7D),

    ($1D82, $1D85, $1D85, $1D8A, $1D8A, $1D8F, $1D8F, $1D94,
    $1D94, $1D99, $1D99, $1D99, $1D99, $1D9E, $1D9E, $1DA1,
    $1DA1, $1DA1, $1DA1, $1DA4, $1DA4, $1DA7, $1DA7, $1DA7,
    $1DA7, $1DAA, $1DAA, $1DAA, $1DAA, $1DAD, $1DAD, $1DAD),

    ($1DAD, $1DB0, $1DB0, $1DB0, $1DB0, $1DB3, $1DB3, $1DB3,
    $1DB3, $1DB6, $1DB6, $1DB9, $1DB9, $1DBC, $1DBC, $1DBF,
    $1DBF, $1DC2, $1DC2, $1DC2, $1DC2, $1DC5, $1DC5, $1DC5,
    $1DC5, $1DC8, $1DC8, $1DC8, $1DC8, $1DCB, $1DCB, $1DCB),

    ($1DCB, $1DCE, $1DCE, $1DCE, $1DCE, $1DD1, $1DD1, $1DD1,
    $1DD1, $1DD4, $1DD4, $1DD4, $1DD4, $1DD7, $1DD7, $1DD7,
    $1DD7, $1DDA, $1DDA, $1DDA, $1DDA, $1DDD, $1DDD, $1DDD,
    $1DDD, $1DE0, $1DE0, $1DE0, $1DE0, $1DE3, $1DE3, $1DE3),

    ($1DE3, $1DE6, $1DE6, $1DE6, $1DE6, $1DE9, $1DE9, $1DE9,
    $1DE9, $1DEC, $1DEC, $1DEC, $1DEC, $1DEF, $1DEF, $1622,
    $1622, $1DF2, $1DF2, $1DF2, $1DF2, $1DF5, $1DF5, $1DFC,
    $1DFC, $1E03, $1E03, $1E0A, $1E0A, $0000, $0000, $0000),

    ($0000, $1D1B, $1E0F, $1D1E, $1D33, $1D36, $1D21, $1E12,
    $02A7, $02AA, $1D24, $029E, $1D0C, $1D27, $0240, $1E15,
    $0289, $0024, $0011, $0014, $028C, $028F, $0292, $0295,
    $0298, $029B, $1D15, $1D12, $1D2A, $02A4, $1D2D, $1D18),

    ($1D39, $0157, $015D, $02C3, $0160, $0163, $0300, $0169,
    $016C, $016F, $0172, $0175, $0178, $017B, $017E, $0181,
    $0187, $02E9, $018A, $0610, $018D, $0190, $0389, $0193,
    $03A6, $0613, $02FD, $1D06, $1D30, $1D09, $1E18, $1CD9),

    ($1E1B, $0009, $019F, $03EC, $01A2, $01A5, $0616, $01B1,
    $009D, $01E4, $00A3, $01B4, $00D9, $01B7, $02AD, $0027,
    $01C6, $0619, $00A6, $0058, $01C9, $01CC, $01D5, $00B2,
    $00DC, $00B5, $061C, $1CDC, $1E1E, $1CDF, $1E21, $1E24),

    ($1E27, $1E2A, $1CFA, $1CFD, $1D0F, $1E2D, $0E54, $1E30,
    $1E33, $1E36, $1E39, $1E3C, $1E3F, $1E42, $1E45, $1E48,
    $1E4B, $0DCA, $0DCD, $0DD0, $0DD3, $0DD6, $0DD9, $0DDC,
    $0DDF, $0DE2, $0DE5, $0DE8, $0DEB, $0DEE, $0DF1, $0DF4),

    ($0DF7, $0DFA, $0DFD, $0E00, $0E03, $0E06, $0E09, $0E0C,
    $0E0F, $0E12, $0E15, $0E18, $0E1B, $0E1E, $0E21, $0E24,
    $0E27, $0E2A, $0E2D, $0E30, $0E33, $0E36, $0E39, $0E3C,
    $0E3F, $0E42, $0E45, $0E48, $0E4B, $1E4E, $1E51, $1E54),

    ($0979, $08E0, $08E3, $08E6, $08E9, $08EC, $08EF, $08F2,
    $08F5, $08F8, $08FB, $08FE, $0901, $0904, $0907, $090A,
    $090D, $0910, $0913, $0916, $0919, $091C, $091F, $0922,
    $0925, $0928, $092B, $092E, $0931, $0934, $0937, $0000),

    ($0000, $0000, $093A, $093D, $0940, $0943, $0946, $0949,
    $0000, $0000, $094C, $094F, $0952, $0955, $0958, $095B,
    $0000, $0000, $095E, $0961, $0964, $0967, $096A, $096D,
    $0000, $0000, $0970, $0973, $0976, $0000, $0000, $0000),

    ($1E57, $1E5A, $1E5D, $000C, $1E60, $1E63, $1E66, $0000,
    $1E69, $1E6C, $1E6F, $1E72, $1E75, $1E78, $1E7B, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000,
    $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000));
  CHAR_COMPATIBLE_DECOMPOSITION_SIZE = 32;
  CHAR_COMPATIBLE_DECOMPOSITION_DATA: array[$0000..$1E7D] of Byte = (
    $00, $01, $20, $00, $02, $20, $00, $08,
    $03, $01, $61, $00, $02, $20, $00, $04,
    $03, $01, $32, $00, $01, $33, $00, $02,
    $20, $00, $01, $03, $01, $BC, $03, $02,
    $20, $00, $27, $03, $01, $31, $00, $01,
    $6F, $00, $03, $31, $00, $44, $20, $34,
    $00, $03, $31, $00, $44, $20, $32, $00,
    $03, $33, $00, $44, $20, $34, $00, $02,

    $49, $00, $4A, $00, $02, $69, $00, $6A,
    $00, $02, $4C, $00, $B7, $00, $02, $6C,
    $00, $B7, $00, $02, $BC, $02, $6E, $00,
    $01, $73, $00, $03, $44, $00, $5A, $00,
    $0C, $03, $03, $44, $00, $7A, $00, $0C,
    $03, $03, $64, $00, $7A, $00, $0C, $03,
    $02, $4C, $00, $4A, $00, $02, $4C, $00,
    $6A, $00, $02, $6C, $00, $6A, $00, $02,

    $4E, $00, $4A, $00, $02, $4E, $00, $6A,
    $00, $02, $6E, $00, $6A, $00, $02, $44,
    $00, $5A, $00, $02, $44, $00, $7A, $00,
    $02, $64, $00, $7A, $00, $01, $68, $00,
    $01, $66, $02, $01, $6A, $00, $01, $72,
    $00, $01, $79, $02, $01, $7B, $02, $01,
    $81, $02, $01, $77, $00, $01, $79, $00,
    $02, $20, $00, $06, $03, $02, $20, $00,

    $07, $03, $02, $20, $00, $0A, $03, $02,
    $20, $00, $28, $03, $02, $20, $00, $03,
    $03, $02, $20, $00, $0B, $03, $01, $63,
    $02, $01, $6C, $00, $01, $78, $00, $01,
    $95, $02, $02, $20, $00, $45, $03, $03,
    $20, $00, $08, $03, $01, $03, $01, $B2,
    $03, $01, $B8, $03, $01, $A5, $03, $02,
    $A5, $03, $01, $03, $02, $A5, $03, $08,

    $03, $01, $C6, $03, $01, $C0, $03, $01,
    $BA, $03, $01, $C1, $03, $01, $C2, $03,
    $01, $98, $03, $01, $B5, $03, $01, $A3,
    $03, $02, $65, $05, $82, $05, $02, $27,
    $06, $74, $06, $02, $48, $06, $74, $06,
    $02, $C7, $06, $74, $06, $02, $4A, $06,
    $74, $06, $02, $4D, $0E, $32, $0E, $02,
    $CD, $0E, $B2, $0E, $02, $AB, $0E, $99,

    $0E, $02, $AB, $0E, $A1, $0E, $01, $0B,
    $0F, $03, $B2, $0F, $71, $0F, $80, $0F,
    $03, $B3, $0F, $71, $0F, $80, $0F, $01,
    $41, $00, $01, $C6, $00, $01, $42, $00,
    $01, $44, $00, $01, $45, $00, $01, $8E,
    $01, $01, $47, $00, $01, $48, $00, $01,
    $49, $00, $01, $4A, $00, $01, $4B, $00,
    $01, $4C, $00, $01, $4D, $00, $01, $4E,

    $00, $01, $4F, $00, $01, $22, $02, $01,
    $50, $00, $01, $52, $00, $01, $54, $00,
    $01, $55, $00, $01, $57, $00, $01, $50,
    $02, $01, $51, $02, $01, $02, $1D, $01,
    $62, $00, $01, $64, $00, $01, $65, $00,
    $01, $59, $02, $01, $5B, $02, $01, $5C,
    $02, $01, $67, $00, $01, $6B, $00, $01,
    $6D, $00, $01, $4B, $01, $01, $54, $02,

    $01, $16, $1D, $01, $17, $1D, $01, $70,
    $00, $01, $74, $00, $01, $75, $00, $01,
    $1D, $1D, $01, $6F, $02, $01, $76, $00,
    $01, $25, $1D, $01, $B3, $03, $01, $B4,
    $03, $01, $C7, $03, $01, $69, $00, $02,
    $61, $00, $BE, $02, $02, $73, $00, $07,
    $03, $02, $20, $00, $13, $03, $02, $20,
    $00, $42, $03, $03, $20, $00, $08, $03,

    $42, $03, $03, $20, $00, $13, $03, $00,
    $03, $03, $20, $00, $13, $03, $01, $03,
    $03, $20, $00, $13, $03, $42, $03, $03,
    $20, $00, $14, $03, $00, $03, $03, $20,
    $00, $14, $03, $01, $03, $03, $20, $00,
    $14, $03, $42, $03, $03, $20, $00, $08,
    $03, $00, $03, $02, $20, $00, $14, $03,
    $01, $10, $20, $02, $20, $00, $33, $03,

    $01, $2E, $00, $02, $2E, $00, $2E, $00,
    $03, $2E, $00, $2E, $00, $2E, $00, $02,
    $32, $20, $32, $20, $03, $32, $20, $32,
    $20, $32, $20, $02, $35, $20, $35, $20,
    $03, $35, $20, $35, $20, $35, $20, $02,
    $21, $00, $21, $00, $02, $20, $00, $05,
    $03, $02, $3F, $00, $3F, $00, $02, $3F,
    $00, $21, $00, $02, $21, $00, $3F, $00,

    $04, $32, $20, $32, $20, $32, $20, $32,
    $20, $01, $30, $00, $01, $34, $00, $01,
    $35, $00, $01, $36, $00, $01, $37, $00,
    $01, $38, $00, $01, $39, $00, $01, $2B,
    $00, $01, $12, $22, $01, $3D, $00, $01,
    $28, $00, $01, $29, $00, $01, $6E, $00,
    $02, $52, $00, $73, $00, $03, $61, $00,
    $2F, $00, $63, $00, $03, $61, $00, $2F,

    $00, $73, $00, $01, $43, $00, $02, $B0,
    $00, $43, $00, $03, $63, $00, $2F, $00,
    $6F, $00, $03, $63, $00, $2F, $00, $75,
    $00, $01, $90, $01, $02, $B0, $00, $46,
    $00, $01, $27, $01, $02, $4E, $00, $6F,
    $00, $01, $51, $00, $02, $53, $00, $4D,
    $00, $03, $54, $00, $45, $00, $4C, $00,
    $02, $54, $00, $4D, $00, $01, $5A, $00,

    $01, $46, $00, $01, $D0, $05, $01, $D1,
    $05, $01, $D2, $05, $01, $D3, $05, $03,
    $46, $00, $41, $00, $58, $00, $01, $93,
    $03, $01, $A0, $03, $01, $11, $22, $03,
    $31, $00, $44, $20, $33, $00, $03, $32,
    $00, $44, $20, $33, $00, $03, $31, $00,
    $44, $20, $35, $00, $03, $32, $00, $44,
    $20, $35, $00, $03, $33, $00, $44, $20,

    $35, $00, $03, $34, $00, $44, $20, $35,
    $00, $03, $31, $00, $44, $20, $36, $00,
    $03, $35, $00, $44, $20, $36, $00, $03,
    $31, $00, $44, $20, $38, $00, $03, $33,
    $00, $44, $20, $38, $00, $03, $35, $00,
    $44, $20, $38, $00, $03, $37, $00, $44,
    $20, $38, $00, $02, $31, $00, $44, $20,
    $02, $49, $00, $49, $00, $03, $49, $00,

    $49, $00, $49, $00, $02, $49, $00, $56,
    $00, $01, $56, $00, $02, $56, $00, $49,
    $00, $03, $56, $00, $49, $00, $49, $00,
    $04, $56, $00, $49, $00, $49, $00, $49,
    $00, $02, $49, $00, $58, $00, $01, $58,
    $00, $02, $58, $00, $49, $00, $03, $58,
    $00, $49, $00, $49, $00, $02, $69, $00,
    $69, $00, $03, $69, $00, $69, $00, $69,

    $00, $02, $69, $00, $76, $00, $02, $76,
    $00, $69, $00, $03, $76, $00, $69, $00,
    $69, $00, $04, $76, $00, $69, $00, $69,
    $00, $69, $00, $02, $69, $00, $78, $00,
    $02, $78, $00, $69, $00, $03, $78, $00,
    $69, $00, $69, $00, $01, $63, $00, $02,
    $2B, $22, $2B, $22, $03, $2B, $22, $2B,
    $22, $2B, $22, $02, $2E, $22, $2E, $22,

    $03, $2E, $22, $2E, $22, $2E, $22, $02,
    $31, $00, $30, $00, $02, $31, $00, $31,
    $00, $02, $31, $00, $32, $00, $02, $31,
    $00, $33, $00, $02, $31, $00, $34, $00,
    $02, $31, $00, $35, $00, $02, $31, $00,
    $36, $00, $02, $31, $00, $37, $00, $02,
    $31, $00, $38, $00, $02, $31, $00, $39,
    $00, $02, $32, $00, $30, $00, $03, $28,

    $00, $31, $00, $29, $00, $03, $28, $00,
    $32, $00, $29, $00, $03, $28, $00, $33,
    $00, $29, $00, $03, $28, $00, $34, $00,
    $29, $00, $03, $28, $00, $35, $00, $29,
    $00, $03, $28, $00, $36, $00, $29, $00,
    $03, $28, $00, $37, $00, $29, $00, $03,
    $28, $00, $38, $00, $29, $00, $03, $28,
    $00, $39, $00, $29, $00, $04, $28, $00,

    $31, $00, $30, $00, $29, $00, $04, $28,
    $00, $31, $00, $31, $00, $29, $00, $04,
    $28, $00, $31, $00, $32, $00, $29, $00,
    $04, $28, $00, $31, $00, $33, $00, $29,
    $00, $04, $28, $00, $31, $00, $34, $00,
    $29, $00, $04, $28, $00, $31, $00, $35,
    $00, $29, $00, $04, $28, $00, $31, $00,
    $36, $00, $29, $00, $04, $28, $00, $31,

    $00, $37, $00, $29, $00, $04, $28, $00,
    $31, $00, $38, $00, $29, $00, $04, $28,
    $00, $31, $00, $39, $00, $29, $00, $04,
    $28, $00, $32, $00, $30, $00, $29, $00,
    $02, $31, $00, $2E, $00, $02, $32, $00,
    $2E, $00, $02, $33, $00, $2E, $00, $02,
    $34, $00, $2E, $00, $02, $35, $00, $2E,
    $00, $02, $36, $00, $2E, $00, $02, $37,

    $00, $2E, $00, $02, $38, $00, $2E, $00,
    $02, $39, $00, $2E, $00, $03, $31, $00,
    $30, $00, $2E, $00, $03, $31, $00, $31,
    $00, $2E, $00, $03, $31, $00, $32, $00,
    $2E, $00, $03, $31, $00, $33, $00, $2E,
    $00, $03, $31, $00, $34, $00, $2E, $00,
    $03, $31, $00, $35, $00, $2E, $00, $03,
    $31, $00, $36, $00, $2E, $00, $03, $31,

    $00, $37, $00, $2E, $00, $03, $31, $00,
    $38, $00, $2E, $00, $03, $31, $00, $39,
    $00, $2E, $00, $03, $32, $00, $30, $00,
    $2E, $00, $03, $28, $00, $61, $00, $29,
    $00, $03, $28, $00, $62, $00, $29, $00,
    $03, $28, $00, $63, $00, $29, $00, $03,
    $28, $00, $64, $00, $29, $00, $03, $28,
    $00, $65, $00, $29, $00, $03, $28, $00,

    $66, $00, $29, $00, $03, $28, $00, $67,
    $00, $29, $00, $03, $28, $00, $68, $00,
    $29, $00, $03, $28, $00, $69, $00, $29,
    $00, $03, $28, $00, $6A, $00, $29, $00,
    $03, $28, $00, $6B, $00, $29, $00, $03,
    $28, $00, $6C, $00, $29, $00, $03, $28,
    $00, $6D, $00, $29, $00, $03, $28, $00,
    $6E, $00, $29, $00, $03, $28, $00, $6F,

    $00, $29, $00, $03, $28, $00, $70, $00,
    $29, $00, $03, $28, $00, $71, $00, $29,
    $00, $03, $28, $00, $72, $00, $29, $00,
    $03, $28, $00, $73, $00, $29, $00, $03,
    $28, $00, $74, $00, $29, $00, $03, $28,
    $00, $75, $00, $29, $00, $03, $28, $00,
    $76, $00, $29, $00, $03, $28, $00, $77,
    $00, $29, $00, $03, $28, $00, $78, $00,

    $29, $00, $03, $28, $00, $79, $00, $29,
    $00, $03, $28, $00, $7A, $00, $29, $00,
    $01, $53, $00, $01, $59, $00, $01, $66,
    $00, $01, $71, $00, $01, $7A, $00, $04,
    $2B, $22, $2B, $22, $2B, $22, $2B, $22,
    $03, $3A, $00, $3A, $00, $3D, $00, $02,
    $3D, $00, $3D, $00, $03, $3D, $00, $3D,
    $00, $3D, $00, $01, $CD, $6B, $01, $9F,

    $9F, $01, $00, $4E, $01, $28, $4E, $01,
    $36, $4E, $01, $3F, $4E, $01, $59, $4E,
    $01, $85, $4E, $01, $8C, $4E, $01, $A0,
    $4E, $01, $BA, $4E, $01, $3F, $51, $01,
    $65, $51, $01, $6B, $51, $01, $82, $51,
    $01, $96, $51, $01, $AB, $51, $01, $E0,
    $51, $01, $F5, $51, $01, $00, $52, $01,
    $9B, $52, $01, $F9, $52, $01, $15, $53,

    $01, $1A, $53, $01, $38, $53, $01, $41,
    $53, $01, $5C, $53, $01, $69, $53, $01,
    $82, $53, $01, $B6, $53, $01, $C8, $53,
    $01, $E3, $53, $01, $D7, $56, $01, $1F,
    $57, $01, $EB, $58, $01, $02, $59, $01,
    $0A, $59, $01, $15, $59, $01, $27, $59,
    $01, $73, $59, $01, $50, $5B, $01, $80,
    $5B, $01, $F8, $5B, $01, $0F, $5C, $01,

    $22, $5C, $01, $38, $5C, $01, $6E, $5C,
    $01, $71, $5C, $01, $DB, $5D, $01, $E5,
    $5D, $01, $F1, $5D, $01, $FE, $5D, $01,
    $72, $5E, $01, $7A, $5E, $01, $7F, $5E,
    $01, $F4, $5E, $01, $FE, $5E, $01, $0B,
    $5F, $01, $13, $5F, $01, $50, $5F, $01,
    $61, $5F, $01, $73, $5F, $01, $C3, $5F,
    $01, $08, $62, $01, $36, $62, $01, $4B,

    $62, $01, $2F, $65, $01, $34, $65, $01,
    $87, $65, $01, $97, $65, $01, $A4, $65,
    $01, $B9, $65, $01, $E0, $65, $01, $E5,
    $65, $01, $F0, $66, $01, $08, $67, $01,
    $28, $67, $01, $20, $6B, $01, $62, $6B,
    $01, $79, $6B, $01, $B3, $6B, $01, $CB,
    $6B, $01, $D4, $6B, $01, $DB, $6B, $01,
    $0F, $6C, $01, $14, $6C, $01, $34, $6C,

    $01, $6B, $70, $01, $2A, $72, $01, $36,
    $72, $01, $3B, $72, $01, $3F, $72, $01,
    $47, $72, $01, $59, $72, $01, $5B, $72,
    $01, $AC, $72, $01, $84, $73, $01, $89,
    $73, $01, $DC, $74, $01, $E6, $74, $01,
    $18, $75, $01, $1F, $75, $01, $28, $75,
    $01, $30, $75, $01, $8B, $75, $01, $92,
    $75, $01, $76, $76, $01, $7D, $76, $01,

    $AE, $76, $01, $BF, $76, $01, $EE, $76,
    $01, $DB, $77, $01, $E2, $77, $01, $F3,
    $77, $01, $3A, $79, $01, $B8, $79, $01,
    $BE, $79, $01, $74, $7A, $01, $CB, $7A,
    $01, $F9, $7A, $01, $73, $7C, $01, $F8,
    $7C, $01, $36, $7F, $01, $51, $7F, $01,
    $8A, $7F, $01, $BD, $7F, $01, $01, $80,
    $01, $0C, $80, $01, $12, $80, $01, $33,

    $80, $01, $7F, $80, $01, $89, $80, $01,
    $E3, $81, $01, $EA, $81, $01, $F3, $81,
    $01, $FC, $81, $01, $0C, $82, $01, $1B,
    $82, $01, $1F, $82, $01, $6E, $82, $01,
    $72, $82, $01, $78, $82, $01, $4D, $86,
    $01, $6B, $86, $01, $40, $88, $01, $4C,
    $88, $01, $63, $88, $01, $7E, $89, $01,
    $8B, $89, $01, $D2, $89, $01, $00, $8A,

    $01, $37, $8C, $01, $46, $8C, $01, $55,
    $8C, $01, $78, $8C, $01, $9D, $8C, $01,
    $64, $8D, $01, $70, $8D, $01, $B3, $8D,
    $01, $AB, $8E, $01, $CA, $8E, $01, $9B,
    $8F, $01, $B0, $8F, $01, $B5, $8F, $01,
    $91, $90, $01, $49, $91, $01, $C6, $91,
    $01, $CC, $91, $01, $D1, $91, $01, $77,
    $95, $01, $80, $95, $01, $1C, $96, $01,

    $B6, $96, $01, $B9, $96, $01, $E8, $96,
    $01, $51, $97, $01, $5E, $97, $01, $62,
    $97, $01, $69, $97, $01, $CB, $97, $01,
    $ED, $97, $01, $F3, $97, $01, $01, $98,
    $01, $A8, $98, $01, $DB, $98, $01, $DF,
    $98, $01, $96, $99, $01, $99, $99, $01,
    $AC, $99, $01, $A8, $9A, $01, $D8, $9A,
    $01, $DF, $9A, $01, $25, $9B, $01, $2F,

    $9B, $01, $32, $9B, $01, $3C, $9B, $01,
    $5A, $9B, $01, $E5, $9C, $01, $75, $9E,
    $01, $7F, $9E, $01, $A5, $9E, $01, $BB,
    $9E, $01, $C3, $9E, $01, $CD, $9E, $01,
    $D1, $9E, $01, $F9, $9E, $01, $FD, $9E,
    $01, $0E, $9F, $01, $13, $9F, $01, $20,
    $9F, $01, $3B, $9F, $01, $4A, $9F, $01,
    $52, $9F, $01, $8D, $9F, $01, $9C, $9F,

    $01, $A0, $9F, $01, $12, $30, $01, $44,
    $53, $01, $45, $53, $02, $20, $00, $99,
    $30, $02, $20, $00, $9A, $30, $02, $88,
    $30, $8A, $30, $02, $B3, $30, $C8, $30,
    $01, $00, $11, $01, $01, $11, $01, $AA,
    $11, $01, $02, $11, $01, $AC, $11, $01,
    $AD, $11, $01, $03, $11, $01, $04, $11,
    $01, $05, $11, $01, $B0, $11, $01, $B1,

    $11, $01, $B2, $11, $01, $B3, $11, $01,
    $B4, $11, $01, $B5, $11, $01, $1A, $11,
    $01, $06, $11, $01, $07, $11, $01, $08,
    $11, $01, $21, $11, $01, $09, $11, $01,
    $0A, $11, $01, $0B, $11, $01, $0C, $11,
    $01, $0D, $11, $01, $0E, $11, $01, $0F,
    $11, $01, $10, $11, $01, $11, $11, $01,
    $12, $11, $01, $61, $11, $01, $62, $11,

    $01, $63, $11, $01, $64, $11, $01, $65,
    $11, $01, $66, $11, $01, $67, $11, $01,
    $68, $11, $01, $69, $11, $01, $6A, $11,
    $01, $6B, $11, $01, $6C, $11, $01, $6D,
    $11, $01, $6E, $11, $01, $6F, $11, $01,
    $70, $11, $01, $71, $11, $01, $72, $11,
    $01, $73, $11, $01, $74, $11, $01, $75,
    $11, $01, $60, $11, $01, $14, $11, $01,

    $15, $11, $01, $C7, $11, $01, $C8, $11,
    $01, $CC, $11, $01, $CE, $11, $01, $D3,
    $11, $01, $D7, $11, $01, $D9, $11, $01,
    $1C, $11, $01, $DD, $11, $01, $DF, $11,
    $01, $1D, $11, $01, $1E, $11, $01, $20,
    $11, $01, $22, $11, $01, $23, $11, $01,
    $27, $11, $01, $29, $11, $01, $2B, $11,
    $01, $2C, $11, $01, $2D, $11, $01, $2E,

    $11, $01, $2F, $11, $01, $32, $11, $01,
    $36, $11, $01, $40, $11, $01, $47, $11,
    $01, $4C, $11, $01, $F1, $11, $01, $F2,
    $11, $01, $57, $11, $01, $58, $11, $01,
    $59, $11, $01, $84, $11, $01, $85, $11,
    $01, $88, $11, $01, $91, $11, $01, $92,
    $11, $01, $94, $11, $01, $9E, $11, $01,
    $A1, $11, $01, $09, $4E, $01, $DB, $56,

    $01, $0A, $4E, $01, $2D, $4E, $01, $0B,
    $4E, $01, $32, $75, $01, $19, $4E, $01,
    $01, $4E, $01, $29, $59, $01, $30, $57,
    $03, $28, $00, $00, $11, $29, $00, $03,
    $28, $00, $02, $11, $29, $00, $03, $28,
    $00, $03, $11, $29, $00, $03, $28, $00,
    $05, $11, $29, $00, $03, $28, $00, $06,
    $11, $29, $00, $03, $28, $00, $07, $11,

    $29, $00, $03, $28, $00, $09, $11, $29,
    $00, $03, $28, $00, $0B, $11, $29, $00,
    $03, $28, $00, $0C, $11, $29, $00, $03,
    $28, $00, $0E, $11, $29, $00, $03, $28,
    $00, $0F, $11, $29, $00, $03, $28, $00,
    $10, $11, $29, $00, $03, $28, $00, $11,
    $11, $29, $00, $03, $28, $00, $12, $11,
    $29, $00, $04, $28, $00, $00, $11, $61,

    $11, $29, $00, $04, $28, $00, $02, $11,
    $61, $11, $29, $00, $04, $28, $00, $03,
    $11, $61, $11, $29, $00, $04, $28, $00,
    $05, $11, $61, $11, $29, $00, $04, $28,
    $00, $06, $11, $61, $11, $29, $00, $04,
    $28, $00, $07, $11, $61, $11, $29, $00,
    $04, $28, $00, $09, $11, $61, $11, $29,
    $00, $04, $28, $00, $0B, $11, $61, $11,

    $29, $00, $04, $28, $00, $0C, $11, $61,
    $11, $29, $00, $04, $28, $00, $0E, $11,
    $61, $11, $29, $00, $04, $28, $00, $0F,
    $11, $61, $11, $29, $00, $04, $28, $00,
    $10, $11, $61, $11, $29, $00, $04, $28,
    $00, $11, $11, $61, $11, $29, $00, $04,
    $28, $00, $12, $11, $61, $11, $29, $00,
    $04, $28, $00, $0C, $11, $6E, $11, $29,

    $00, $07, $28, $00, $0B, $11, $69, $11,
    $0C, $11, $65, $11, $AB, $11, $29, $00,
    $06, $28, $00, $0B, $11, $69, $11, $12,
    $11, $6E, $11, $29, $00, $03, $28, $00,
    $00, $4E, $29, $00, $03, $28, $00, $8C,
    $4E, $29, $00, $03, $28, $00, $09, $4E,
    $29, $00, $03, $28, $00, $DB, $56, $29,
    $00, $03, $28, $00, $94, $4E, $29, $00,

    $03, $28, $00, $6D, $51, $29, $00, $03,
    $28, $00, $03, $4E, $29, $00, $03, $28,
    $00, $6B, $51, $29, $00, $03, $28, $00,
    $5D, $4E, $29, $00, $03, $28, $00, $41,
    $53, $29, $00, $03, $28, $00, $08, $67,
    $29, $00, $03, $28, $00, $6B, $70, $29,
    $00, $03, $28, $00, $34, $6C, $29, $00,
    $03, $28, $00, $28, $67, $29, $00, $03,

    $28, $00, $D1, $91, $29, $00, $03, $28,
    $00, $1F, $57, $29, $00, $03, $28, $00,
    $E5, $65, $29, $00, $03, $28, $00, $2A,
    $68, $29, $00, $03, $28, $00, $09, $67,
    $29, $00, $03, $28, $00, $3E, $79, $29,
    $00, $03, $28, $00, $0D, $54, $29, $00,
    $03, $28, $00, $79, $72, $29, $00, $03,
    $28, $00, $A1, $8C, $29, $00, $03, $28,

    $00, $5D, $79, $29, $00, $03, $28, $00,
    $B4, $52, $29, $00, $03, $28, $00, $E3,
    $4E, $29, $00, $03, $28, $00, $7C, $54,
    $29, $00, $03, $28, $00, $66, $5B, $29,
    $00, $03, $28, $00, $E3, $76, $29, $00,
    $03, $28, $00, $01, $4F, $29, $00, $03,
    $28, $00, $C7, $8C, $29, $00, $03, $28,
    $00, $54, $53, $29, $00, $03, $28, $00,

    $6D, $79, $29, $00, $03, $28, $00, $11,
    $4F, $29, $00, $03, $28, $00, $EA, $81,
    $29, $00, $03, $28, $00, $F3, $81, $29,
    $00, $03, $50, $00, $54, $00, $45, $00,
    $02, $32, $00, $31, $00, $02, $32, $00,
    $32, $00, $02, $32, $00, $33, $00, $02,
    $32, $00, $34, $00, $02, $32, $00, $35,
    $00, $02, $32, $00, $36, $00, $02, $32,

    $00, $37, $00, $02, $32, $00, $38, $00,
    $02, $32, $00, $39, $00, $02, $33, $00,
    $30, $00, $02, $33, $00, $31, $00, $02,
    $33, $00, $32, $00, $02, $33, $00, $33,
    $00, $02, $33, $00, $34, $00, $02, $33,
    $00, $35, $00, $02, $00, $11, $61, $11,
    $02, $02, $11, $61, $11, $02, $03, $11,
    $61, $11, $02, $05, $11, $61, $11, $02,

    $06, $11, $61, $11, $02, $07, $11, $61,
    $11, $02, $09, $11, $61, $11, $02, $0B,
    $11, $61, $11, $02, $0C, $11, $61, $11,
    $02, $0E, $11, $61, $11, $02, $0F, $11,
    $61, $11, $02, $10, $11, $61, $11, $02,
    $11, $11, $61, $11, $02, $12, $11, $61,
    $11, $05, $0E, $11, $61, $11, $B7, $11,
    $00, $11, $69, $11, $04, $0C, $11, $6E,

    $11, $0B, $11, $74, $11, $01, $94, $4E,
    $01, $6D, $51, $01, $03, $4E, $01, $5D,
    $4E, $01, $2A, $68, $01, $09, $67, $01,
    $3E, $79, $01, $0D, $54, $01, $79, $72,
    $01, $A1, $8C, $01, $5D, $79, $01, $B4,
    $52, $01, $D8, $79, $01, $37, $75, $01,
    $69, $90, $01, $2A, $51, $01, $70, $53,
    $01, $E8, $6C, $01, $05, $98, $01, $11,

    $4F, $01, $99, $51, $01, $63, $6B, $01,
    $E6, $5D, $01, $F3, $53, $01, $3B, $53,
    $01, $97, $5B, $01, $66, $5B, $01, $E3,
    $76, $01, $01, $4F, $01, $C7, $8C, $01,
    $54, $53, $01, $1C, $59, $02, $33, $00,
    $36, $00, $02, $33, $00, $37, $00, $02,
    $33, $00, $38, $00, $02, $33, $00, $39,
    $00, $02, $34, $00, $30, $00, $02, $34,

    $00, $31, $00, $02, $34, $00, $32, $00,
    $02, $34, $00, $33, $00, $02, $34, $00,
    $34, $00, $02, $34, $00, $35, $00, $02,
    $34, $00, $36, $00, $02, $34, $00, $37,
    $00, $02, $34, $00, $38, $00, $02, $34,
    $00, $39, $00, $02, $35, $00, $30, $00,
    $02, $31, $00, $08, $67, $02, $32, $00,
    $08, $67, $02, $33, $00, $08, $67, $02,

    $34, $00, $08, $67, $02, $35, $00, $08,
    $67, $02, $36, $00, $08, $67, $02, $37,
    $00, $08, $67, $02, $38, $00, $08, $67,
    $02, $39, $00, $08, $67, $03, $31, $00,
    $30, $00, $08, $67, $03, $31, $00, $31,
    $00, $08, $67, $03, $31, $00, $32, $00,
    $08, $67, $02, $48, $00, $67, $00, $03,
    $65, $00, $72, $00, $67, $00, $02, $65,

    $00, $56, $00, $03, $4C, $00, $54, $00,
    $44, $00, $01, $A2, $30, $01, $A4, $30,
    $01, $A6, $30, $01, $A8, $30, $01, $AA,
    $30, $01, $AB, $30, $01, $AD, $30, $01,
    $AF, $30, $01, $B1, $30, $01, $B3, $30,
    $01, $B5, $30, $01, $B7, $30, $01, $B9,
    $30, $01, $BB, $30, $01, $BD, $30, $01,
    $BF, $30, $01, $C1, $30, $01, $C4, $30,

    $01, $C6, $30, $01, $C8, $30, $01, $CA,
    $30, $01, $CB, $30, $01, $CC, $30, $01,
    $CD, $30, $01, $CE, $30, $01, $CF, $30,
    $01, $D2, $30, $01, $D5, $30, $01, $D8,
    $30, $01, $DB, $30, $01, $DE, $30, $01,
    $DF, $30, $01, $E0, $30, $01, $E1, $30,
    $01, $E2, $30, $01, $E4, $30, $01, $E6,
    $30, $01, $E8, $30, $01, $E9, $30, $01,

    $EA, $30, $01, $EB, $30, $01, $EC, $30,
    $01, $ED, $30, $01, $EF, $30, $01, $F0,
    $30, $01, $F1, $30, $01, $F2, $30, $05,
    $A2, $30, $CF, $30, $9A, $30, $FC, $30,
    $C8, $30, $04, $A2, $30, $EB, $30, $D5,
    $30, $A1, $30, $05, $A2, $30, $F3, $30,
    $D8, $30, $9A, $30, $A2, $30, $03, $A2,
    $30, $FC, $30, $EB, $30, $05, $A4, $30,

    $CB, $30, $F3, $30, $AF, $30, $99, $30,
    $03, $A4, $30, $F3, $30, $C1, $30, $03,
    $A6, $30, $A9, $30, $F3, $30, $06, $A8,
    $30, $B9, $30, $AF, $30, $FC, $30, $C8,
    $30, $99, $30, $04, $A8, $30, $FC, $30,
    $AB, $30, $FC, $30, $03, $AA, $30, $F3,
    $30, $B9, $30, $03, $AA, $30, $FC, $30,
    $E0, $30, $03, $AB, $30, $A4, $30, $EA,

    $30, $04, $AB, $30, $E9, $30, $C3, $30,
    $C8, $30, $04, $AB, $30, $ED, $30, $EA,
    $30, $FC, $30, $04, $AB, $30, $99, $30,
    $ED, $30, $F3, $30, $04, $AB, $30, $99,
    $30, $F3, $30, $DE, $30, $04, $AD, $30,
    $99, $30, $AB, $30, $99, $30, $04, $AD,
    $30, $99, $30, $CB, $30, $FC, $30, $04,
    $AD, $30, $E5, $30, $EA, $30, $FC, $30,

    $06, $AD, $30, $99, $30, $EB, $30, $BF,
    $30, $99, $30, $FC, $30, $02, $AD, $30,
    $ED, $30, $06, $AD, $30, $ED, $30, $AF,
    $30, $99, $30, $E9, $30, $E0, $30, $06,
    $AD, $30, $ED, $30, $E1, $30, $FC, $30,
    $C8, $30, $EB, $30, $05, $AD, $30, $ED,
    $30, $EF, $30, $C3, $30, $C8, $30, $04,
    $AF, $30, $99, $30, $E9, $30, $E0, $30,

    $06, $AF, $30, $99, $30, $E9, $30, $E0,
    $30, $C8, $30, $F3, $30, $06, $AF, $30,
    $EB, $30, $BB, $30, $99, $30, $A4, $30,
    $ED, $30, $04, $AF, $30, $ED, $30, $FC,
    $30, $CD, $30, $03, $B1, $30, $FC, $30,
    $B9, $30, $03, $B3, $30, $EB, $30, $CA,
    $30, $04, $B3, $30, $FC, $30, $DB, $30,
    $9A, $30, $04, $B5, $30, $A4, $30, $AF,

    $30, $EB, $30, $05, $B5, $30, $F3, $30,
    $C1, $30, $FC, $30, $E0, $30, $05, $B7,
    $30, $EA, $30, $F3, $30, $AF, $30, $99,
    $30, $03, $BB, $30, $F3, $30, $C1, $30,
    $03, $BB, $30, $F3, $30, $C8, $30, $04,
    $BF, $30, $99, $30, $FC, $30, $B9, $30,
    $03, $C6, $30, $99, $30, $B7, $30, $03,
    $C8, $30, $99, $30, $EB, $30, $02, $C8,

    $30, $F3, $30, $02, $CA, $30, $CE, $30,
    $03, $CE, $30, $C3, $30, $C8, $30, $03,
    $CF, $30, $A4, $30, $C4, $30, $06, $CF,
    $30, $9A, $30, $FC, $30, $BB, $30, $F3,
    $30, $C8, $30, $04, $CF, $30, $9A, $30,
    $FC, $30, $C4, $30, $05, $CF, $30, $99,
    $30, $FC, $30, $EC, $30, $EB, $30, $06,
    $D2, $30, $9A, $30, $A2, $30, $B9, $30,

    $C8, $30, $EB, $30, $04, $D2, $30, $9A,
    $30, $AF, $30, $EB, $30, $03, $D2, $30,
    $9A, $30, $B3, $30, $03, $D2, $30, $99,
    $30, $EB, $30, $06, $D5, $30, $A1, $30,
    $E9, $30, $C3, $30, $C8, $30, $99, $30,
    $04, $D5, $30, $A3, $30, $FC, $30, $C8,
    $30, $06, $D5, $30, $99, $30, $C3, $30,
    $B7, $30, $A7, $30, $EB, $30, $03, $D5,

    $30, $E9, $30, $F3, $30, $05, $D8, $30,
    $AF, $30, $BF, $30, $FC, $30, $EB, $30,
    $03, $D8, $30, $9A, $30, $BD, $30, $04,
    $D8, $30, $9A, $30, $CB, $30, $D2, $30,
    $03, $D8, $30, $EB, $30, $C4, $30, $04,
    $D8, $30, $9A, $30, $F3, $30, $B9, $30,
    $05, $D8, $30, $9A, $30, $FC, $30, $B7,
    $30, $99, $30, $04, $D8, $30, $99, $30,

    $FC, $30, $BF, $30, $05, $DB, $30, $9A,
    $30, $A4, $30, $F3, $30, $C8, $30, $04,
    $DB, $30, $99, $30, $EB, $30, $C8, $30,
    $02, $DB, $30, $F3, $30, $05, $DB, $30,
    $9A, $30, $F3, $30, $C8, $30, $99, $30,
    $03, $DB, $30, $FC, $30, $EB, $30, $03,
    $DB, $30, $FC, $30, $F3, $30, $04, $DE,
    $30, $A4, $30, $AF, $30, $ED, $30, $03,

    $DE, $30, $A4, $30, $EB, $30, $03, $DE,
    $30, $C3, $30, $CF, $30, $03, $DE, $30,
    $EB, $30, $AF, $30, $05, $DE, $30, $F3,
    $30, $B7, $30, $E7, $30, $F3, $30, $04,
    $DF, $30, $AF, $30, $ED, $30, $F3, $30,
    $02, $DF, $30, $EA, $30, $06, $DF, $30,
    $EA, $30, $CF, $30, $99, $30, $FC, $30,
    $EB, $30, $03, $E1, $30, $AB, $30, $99,

    $30, $05, $E1, $30, $AB, $30, $99, $30,
    $C8, $30, $F3, $30, $04, $E1, $30, $FC,
    $30, $C8, $30, $EB, $30, $04, $E4, $30,
    $FC, $30, $C8, $30, $99, $30, $03, $E4,
    $30, $FC, $30, $EB, $30, $03, $E6, $30,
    $A2, $30, $F3, $30, $04, $EA, $30, $C3,
    $30, $C8, $30, $EB, $30, $02, $EA, $30,
    $E9, $30, $04, $EB, $30, $D2, $30, $9A,

    $30, $FC, $30, $05, $EB, $30, $FC, $30,
    $D5, $30, $99, $30, $EB, $30, $02, $EC,
    $30, $E0, $30, $06, $EC, $30, $F3, $30,
    $C8, $30, $B1, $30, $99, $30, $F3, $30,
    $03, $EF, $30, $C3, $30, $C8, $30, $02,
    $30, $00, $B9, $70, $02, $31, $00, $B9,
    $70, $02, $32, $00, $B9, $70, $02, $33,
    $00, $B9, $70, $02, $34, $00, $B9, $70,

    $02, $35, $00, $B9, $70, $02, $36, $00,
    $B9, $70, $02, $37, $00, $B9, $70, $02,
    $38, $00, $B9, $70, $02, $39, $00, $B9,
    $70, $03, $31, $00, $30, $00, $B9, $70,
    $03, $31, $00, $31, $00, $B9, $70, $03,
    $31, $00, $32, $00, $B9, $70, $03, $31,
    $00, $33, $00, $B9, $70, $03, $31, $00,
    $34, $00, $B9, $70, $03, $31, $00, $35,

    $00, $B9, $70, $03, $31, $00, $36, $00,
    $B9, $70, $03, $31, $00, $37, $00, $B9,
    $70, $03, $31, $00, $38, $00, $B9, $70,
    $03, $31, $00, $39, $00, $B9, $70, $03,
    $32, $00, $30, $00, $B9, $70, $03, $32,
    $00, $31, $00, $B9, $70, $03, $32, $00,
    $32, $00, $B9, $70, $03, $32, $00, $33,
    $00, $B9, $70, $03, $32, $00, $34, $00,

    $B9, $70, $03, $68, $00, $50, $00, $61,
    $00, $02, $64, $00, $61, $00, $02, $41,
    $00, $55, $00, $03, $62, $00, $61, $00,
    $72, $00, $02, $6F, $00, $56, $00, $02,
    $70, $00, $63, $00, $02, $64, $00, $6D,
    $00, $03, $64, $00, $6D, $00, $32, $00,
    $03, $64, $00, $6D, $00, $33, $00, $02,
    $49, $00, $55, $00, $02, $73, $5E, $10,

    $62, $02, $2D, $66, $8C, $54, $02, $27,
    $59, $63, $6B, $02, $0E, $66, $BB, $6C,
    $04, $2A, $68, $0F, $5F, $1A, $4F, $3E,
    $79, $02, $70, $00, $41, $00, $02, $6E,
    $00, $41, $00, $02, $BC, $03, $41, $00,
    $02, $6D, $00, $41, $00, $02, $6B, $00,
    $41, $00, $02, $4B, $00, $42, $00, $02,
    $4D, $00, $42, $00, $02, $47, $00, $42,

    $00, $03, $63, $00, $61, $00, $6C, $00,
    $04, $6B, $00, $63, $00, $61, $00, $6C,
    $00, $02, $70, $00, $46, $00, $02, $6E,
    $00, $46, $00, $02, $BC, $03, $46, $00,
    $02, $BC, $03, $67, $00, $02, $6D, $00,
    $67, $00, $02, $6B, $00, $67, $00, $02,
    $48, $00, $7A, $00, $03, $6B, $00, $48,
    $00, $7A, $00, $03, $4D, $00, $48, $00,

    $7A, $00, $03, $47, $00, $48, $00, $7A,
    $00, $03, $54, $00, $48, $00, $7A, $00,
    $02, $BC, $03, $6C, $00, $02, $6D, $00,
    $6C, $00, $02, $64, $00, $6C, $00, $02,
    $6B, $00, $6C, $00, $02, $66, $00, $6D,
    $00, $02, $6E, $00, $6D, $00, $02, $BC,
    $03, $6D, $00, $02, $6D, $00, $6D, $00,
    $02, $63, $00, $6D, $00, $02, $6B, $00,

    $6D, $00, $03, $6D, $00, $6D, $00, $32,
    $00, $03, $63, $00, $6D, $00, $32, $00,
    $02, $6D, $00, $32, $00, $03, $6B, $00,
    $6D, $00, $32, $00, $03, $6D, $00, $6D,
    $00, $33, $00, $03, $63, $00, $6D, $00,
    $33, $00, $02, $6D, $00, $33, $00, $03,
    $6B, $00, $6D, $00, $33, $00, $03, $6D,
    $00, $15, $22, $73, $00, $04, $6D, $00,

    $15, $22, $73, $00, $32, $00, $02, $50,
    $00, $61, $00, $03, $6B, $00, $50, $00,
    $61, $00, $03, $4D, $00, $50, $00, $61,
    $00, $03, $47, $00, $50, $00, $61, $00,
    $03, $72, $00, $61, $00, $64, $00, $05,
    $72, $00, $61, $00, $64, $00, $15, $22,
    $73, $00, $06, $72, $00, $61, $00, $64,
    $00, $15, $22, $73, $00, $32, $00, $02,

    $70, $00, $73, $00, $02, $6E, $00, $73,
    $00, $02, $BC, $03, $73, $00, $02, $6D,
    $00, $73, $00, $02, $70, $00, $56, $00,
    $02, $6E, $00, $56, $00, $02, $BC, $03,
    $56, $00, $02, $6D, $00, $56, $00, $02,
    $6B, $00, $56, $00, $02, $4D, $00, $56,
    $00, $02, $70, $00, $57, $00, $02, $6E,
    $00, $57, $00, $02, $BC, $03, $57, $00,

    $02, $6D, $00, $57, $00, $02, $6B, $00,
    $57, $00, $02, $4D, $00, $57, $00, $02,
    $6B, $00, $A9, $03, $02, $4D, $00, $A9,
    $03, $04, $61, $00, $2E, $00, $6D, $00,
    $2E, $00, $02, $42, $00, $71, $00, $02,
    $63, $00, $63, $00, $02, $63, $00, $64,
    $00, $04, $43, $00, $15, $22, $6B, $00,
    $67, $00, $03, $43, $00, $6F, $00, $2E,

    $00, $02, $64, $00, $42, $00, $02, $47,
    $00, $79, $00, $02, $68, $00, $61, $00,
    $02, $48, $00, $50, $00, $02, $69, $00,
    $6E, $00, $02, $4B, $00, $4B, $00, $02,
    $4B, $00, $4D, $00, $02, $6B, $00, $74,
    $00, $02, $6C, $00, $6D, $00, $02, $6C,
    $00, $6E, $00, $03, $6C, $00, $6F, $00,
    $67, $00, $02, $6C, $00, $78, $00, $02,

    $6D, $00, $62, $00, $03, $6D, $00, $69,
    $00, $6C, $00, $03, $6D, $00, $6F, $00,
    $6C, $00, $02, $50, $00, $48, $00, $04,
    $70, $00, $2E, $00, $6D, $00, $2E, $00,
    $03, $50, $00, $50, $00, $4D, $00, $02,
    $50, $00, $52, $00, $02, $73, $00, $72,
    $00, $02, $53, $00, $76, $00, $02, $57,
    $00, $62, $00, $03, $56, $00, $15, $22,

    $6D, $00, $03, $41, $00, $15, $22, $6D,
    $00, $02, $31, $00, $E5, $65, $02, $32,
    $00, $E5, $65, $02, $33, $00, $E5, $65,
    $02, $34, $00, $E5, $65, $02, $35, $00,
    $E5, $65, $02, $36, $00, $E5, $65, $02,
    $37, $00, $E5, $65, $02, $38, $00, $E5,
    $65, $02, $39, $00, $E5, $65, $03, $31,
    $00, $30, $00, $E5, $65, $03, $31, $00,

    $31, $00, $E5, $65, $03, $31, $00, $32,
    $00, $E5, $65, $03, $31, $00, $33, $00,
    $E5, $65, $03, $31, $00, $34, $00, $E5,
    $65, $03, $31, $00, $35, $00, $E5, $65,
    $03, $31, $00, $36, $00, $E5, $65, $03,
    $31, $00, $37, $00, $E5, $65, $03, $31,
    $00, $38, $00, $E5, $65, $03, $31, $00,
    $39, $00, $E5, $65, $03, $32, $00, $30,

    $00, $E5, $65, $03, $32, $00, $31, $00,
    $E5, $65, $03, $32, $00, $32, $00, $E5,
    $65, $03, $32, $00, $33, $00, $E5, $65,
    $03, $32, $00, $34, $00, $E5, $65, $03,
    $32, $00, $35, $00, $E5, $65, $03, $32,
    $00, $36, $00, $E5, $65, $03, $32, $00,
    $37, $00, $E5, $65, $03, $32, $00, $38,
    $00, $E5, $65, $03, $32, $00, $39, $00,

    $E5, $65, $03, $33, $00, $30, $00, $E5,
    $65, $03, $33, $00, $31, $00, $E5, $65,
    $03, $67, $00, $61, $00, $6C, $00, $02,
    $66, $00, $66, $00, $02, $66, $00, $69,
    $00, $02, $66, $00, $6C, $00, $03, $66,
    $00, $66, $00, $69, $00, $03, $66, $00,
    $66, $00, $6C, $00, $02, $73, $00, $74,
    $00, $02, $74, $05, $76, $05, $02, $74,

    $05, $65, $05, $02, $74, $05, $6B, $05,
    $02, $7E, $05, $76, $05, $02, $74, $05,
    $6D, $05, $01, $E2, $05, $01, $D4, $05,
    $01, $DB, $05, $01, $DC, $05, $01, $DD,
    $05, $01, $E8, $05, $01, $EA, $05, $02,
    $D0, $05, $DC, $05, $01, $71, $06, $01,
    $7B, $06, $01, $7E, $06, $01, $80, $06,
    $01, $7A, $06, $01, $7F, $06, $01, $79,

    $06, $01, $A4, $06, $01, $A6, $06, $01,
    $84, $06, $01, $83, $06, $01, $86, $06,
    $01, $87, $06, $01, $8D, $06, $01, $8C,
    $06, $01, $8E, $06, $01, $88, $06, $01,
    $98, $06, $01, $91, $06, $01, $A9, $06,
    $01, $AF, $06, $01, $B3, $06, $01, $B1,
    $06, $01, $BA, $06, $01, $BB, $06, $02,
    $D5, $06, $54, $06, $01, $C1, $06, $01,

    $BE, $06, $01, $D2, $06, $02, $D2, $06,
    $54, $06, $01, $AD, $06, $01, $C7, $06,
    $01, $C6, $06, $01, $C8, $06, $01, $CB,
    $06, $01, $C5, $06, $01, $C9, $06, $01,
    $D0, $06, $01, $49, $06, $03, $4A, $06,
    $54, $06, $27, $06, $03, $4A, $06, $54,
    $06, $D5, $06, $03, $4A, $06, $54, $06,
    $48, $06, $03, $4A, $06, $54, $06, $C7,

    $06, $03, $4A, $06, $54, $06, $C6, $06,
    $03, $4A, $06, $54, $06, $C8, $06, $03,
    $4A, $06, $54, $06, $D0, $06, $03, $4A,
    $06, $54, $06, $49, $06, $01, $CC, $06,
    $03, $4A, $06, $54, $06, $2C, $06, $03,
    $4A, $06, $54, $06, $2D, $06, $03, $4A,
    $06, $54, $06, $45, $06, $03, $4A, $06,
    $54, $06, $4A, $06, $02, $28, $06, $2C,

    $06, $02, $28, $06, $2D, $06, $02, $28,
    $06, $2E, $06, $02, $28, $06, $45, $06,
    $02, $28, $06, $49, $06, $02, $28, $06,
    $4A, $06, $02, $2A, $06, $2C, $06, $02,
    $2A, $06, $2D, $06, $02, $2A, $06, $2E,
    $06, $02, $2A, $06, $45, $06, $02, $2A,
    $06, $49, $06, $02, $2A, $06, $4A, $06,
    $02, $2B, $06, $2C, $06, $02, $2B, $06,

    $45, $06, $02, $2B, $06, $49, $06, $02,
    $2B, $06, $4A, $06, $02, $2C, $06, $2D,
    $06, $02, $2C, $06, $45, $06, $02, $2D,
    $06, $2C, $06, $02, $2D, $06, $45, $06,
    $02, $2E, $06, $2C, $06, $02, $2E, $06,
    $2D, $06, $02, $2E, $06, $45, $06, $02,
    $33, $06, $2C, $06, $02, $33, $06, $2D,
    $06, $02, $33, $06, $2E, $06, $02, $33,

    $06, $45, $06, $02, $35, $06, $2D, $06,
    $02, $35, $06, $45, $06, $02, $36, $06,
    $2C, $06, $02, $36, $06, $2D, $06, $02,
    $36, $06, $2E, $06, $02, $36, $06, $45,
    $06, $02, $37, $06, $2D, $06, $02, $37,
    $06, $45, $06, $02, $38, $06, $45, $06,
    $02, $39, $06, $2C, $06, $02, $39, $06,
    $45, $06, $02, $3A, $06, $2C, $06, $02,

    $3A, $06, $45, $06, $02, $41, $06, $2C,
    $06, $02, $41, $06, $2D, $06, $02, $41,
    $06, $2E, $06, $02, $41, $06, $45, $06,
    $02, $41, $06, $49, $06, $02, $41, $06,
    $4A, $06, $02, $42, $06, $2D, $06, $02,
    $42, $06, $45, $06, $02, $42, $06, $49,
    $06, $02, $42, $06, $4A, $06, $02, $43,
    $06, $27, $06, $02, $43, $06, $2C, $06,

    $02, $43, $06, $2D, $06, $02, $43, $06,
    $2E, $06, $02, $43, $06, $44, $06, $02,
    $43, $06, $45, $06, $02, $43, $06, $49,
    $06, $02, $43, $06, $4A, $06, $02, $44,
    $06, $2C, $06, $02, $44, $06, $2D, $06,
    $02, $44, $06, $2E, $06, $02, $44, $06,
    $45, $06, $02, $44, $06, $49, $06, $02,
    $44, $06, $4A, $06, $02, $45, $06, $2C,

    $06, $02, $45, $06, $2D, $06, $02, $45,
    $06, $2E, $06, $02, $45, $06, $45, $06,
    $02, $45, $06, $49, $06, $02, $45, $06,
    $4A, $06, $02, $46, $06, $2C, $06, $02,
    $46, $06, $2D, $06, $02, $46, $06, $2E,
    $06, $02, $46, $06, $45, $06, $02, $46,
    $06, $49, $06, $02, $46, $06, $4A, $06,
    $02, $47, $06, $2C, $06, $02, $47, $06,

    $45, $06, $02, $47, $06, $49, $06, $02,
    $47, $06, $4A, $06, $02, $4A, $06, $2C,
    $06, $02, $4A, $06, $2D, $06, $02, $4A,
    $06, $2E, $06, $02, $4A, $06, $45, $06,
    $02, $4A, $06, $49, $06, $02, $4A, $06,
    $4A, $06, $02, $30, $06, $70, $06, $02,
    $31, $06, $70, $06, $02, $49, $06, $70,
    $06, $03, $20, $00, $4C, $06, $51, $06,

    $03, $20, $00, $4D, $06, $51, $06, $03,
    $20, $00, $4E, $06, $51, $06, $03, $20,
    $00, $4F, $06, $51, $06, $03, $20, $00,
    $50, $06, $51, $06, $03, $20, $00, $51,
    $06, $70, $06, $03, $4A, $06, $54, $06,
    $31, $06, $03, $4A, $06, $54, $06, $32,
    $06, $03, $4A, $06, $54, $06, $46, $06,
    $02, $28, $06, $31, $06, $02, $28, $06,

    $32, $06, $02, $28, $06, $46, $06, $02,
    $2A, $06, $31, $06, $02, $2A, $06, $32,
    $06, $02, $2A, $06, $46, $06, $02, $2B,
    $06, $31, $06, $02, $2B, $06, $32, $06,
    $02, $2B, $06, $46, $06, $02, $45, $06,
    $27, $06, $02, $46, $06, $31, $06, $02,
    $46, $06, $32, $06, $02, $46, $06, $46,
    $06, $02, $4A, $06, $31, $06, $02, $4A,

    $06, $32, $06, $02, $4A, $06, $46, $06,
    $03, $4A, $06, $54, $06, $2E, $06, $03,
    $4A, $06, $54, $06, $47, $06, $02, $28,
    $06, $47, $06, $02, $2A, $06, $47, $06,
    $02, $35, $06, $2E, $06, $02, $44, $06,
    $47, $06, $02, $46, $06, $47, $06, $02,
    $47, $06, $70, $06, $02, $4A, $06, $47,
    $06, $02, $2B, $06, $47, $06, $02, $33,

    $06, $47, $06, $02, $34, $06, $45, $06,
    $02, $34, $06, $47, $06, $03, $40, $06,
    $4E, $06, $51, $06, $03, $40, $06, $4F,
    $06, $51, $06, $03, $40, $06, $50, $06,
    $51, $06, $02, $37, $06, $49, $06, $02,
    $37, $06, $4A, $06, $02, $39, $06, $49,
    $06, $02, $39, $06, $4A, $06, $02, $3A,
    $06, $49, $06, $02, $3A, $06, $4A, $06,

    $02, $33, $06, $49, $06, $02, $33, $06,
    $4A, $06, $02, $34, $06, $49, $06, $02,
    $34, $06, $4A, $06, $02, $2D, $06, $49,
    $06, $02, $2D, $06, $4A, $06, $02, $2C,
    $06, $49, $06, $02, $2C, $06, $4A, $06,
    $02, $2E, $06, $49, $06, $02, $2E, $06,
    $4A, $06, $02, $35, $06, $49, $06, $02,
    $35, $06, $4A, $06, $02, $36, $06, $49,

    $06, $02, $36, $06, $4A, $06, $02, $34,
    $06, $2C, $06, $02, $34, $06, $2D, $06,
    $02, $34, $06, $2E, $06, $02, $34, $06,
    $31, $06, $02, $33, $06, $31, $06, $02,
    $35, $06, $31, $06, $02, $36, $06, $31,
    $06, $02, $27, $06, $4B, $06, $03, $2A,
    $06, $2C, $06, $45, $06, $03, $2A, $06,
    $2D, $06, $2C, $06, $03, $2A, $06, $2D,

    $06, $45, $06, $03, $2A, $06, $2E, $06,
    $45, $06, $03, $2A, $06, $45, $06, $2C,
    $06, $03, $2A, $06, $45, $06, $2D, $06,
    $03, $2A, $06, $45, $06, $2E, $06, $03,
    $2C, $06, $45, $06, $2D, $06, $03, $2D,
    $06, $45, $06, $4A, $06, $03, $2D, $06,
    $45, $06, $49, $06, $03, $33, $06, $2D,
    $06, $2C, $06, $03, $33, $06, $2C, $06,

    $2D, $06, $03, $33, $06, $2C, $06, $49,
    $06, $03, $33, $06, $45, $06, $2D, $06,
    $03, $33, $06, $45, $06, $2C, $06, $03,
    $33, $06, $45, $06, $45, $06, $03, $35,
    $06, $2D, $06, $2D, $06, $03, $35, $06,
    $45, $06, $45, $06, $03, $34, $06, $2D,
    $06, $45, $06, $03, $34, $06, $2C, $06,
    $4A, $06, $03, $34, $06, $45, $06, $2E,

    $06, $03, $34, $06, $45, $06, $45, $06,
    $03, $36, $06, $2D, $06, $49, $06, $03,
    $36, $06, $2E, $06, $45, $06, $03, $37,
    $06, $45, $06, $2D, $06, $03, $37, $06,
    $45, $06, $45, $06, $03, $37, $06, $45,
    $06, $4A, $06, $03, $39, $06, $2C, $06,
    $45, $06, $03, $39, $06, $45, $06, $45,
    $06, $03, $39, $06, $45, $06, $49, $06,

    $03, $3A, $06, $45, $06, $45, $06, $03,
    $3A, $06, $45, $06, $4A, $06, $03, $3A,
    $06, $45, $06, $49, $06, $03, $41, $06,
    $2E, $06, $45, $06, $03, $42, $06, $45,
    $06, $2D, $06, $03, $42, $06, $45, $06,
    $45, $06, $03, $44, $06, $2D, $06, $45,
    $06, $03, $44, $06, $2D, $06, $4A, $06,
    $03, $44, $06, $2D, $06, $49, $06, $03,

    $44, $06, $2C, $06, $2C, $06, $03, $44,
    $06, $2E, $06, $45, $06, $03, $44, $06,
    $45, $06, $2D, $06, $03, $45, $06, $2D,
    $06, $2C, $06, $03, $45, $06, $2D, $06,
    $45, $06, $03, $45, $06, $2D, $06, $4A,
    $06, $03, $45, $06, $2C, $06, $2D, $06,
    $03, $45, $06, $2C, $06, $45, $06, $03,
    $45, $06, $2E, $06, $2C, $06, $03, $45,

    $06, $2E, $06, $45, $06, $03, $45, $06,
    $2C, $06, $2E, $06, $03, $47, $06, $45,
    $06, $2C, $06, $03, $47, $06, $45, $06,
    $45, $06, $03, $46, $06, $2D, $06, $45,
    $06, $03, $46, $06, $2D, $06, $49, $06,
    $03, $46, $06, $2C, $06, $45, $06, $03,
    $46, $06, $2C, $06, $49, $06, $03, $46,
    $06, $45, $06, $4A, $06, $03, $46, $06,

    $45, $06, $49, $06, $03, $4A, $06, $45,
    $06, $45, $06, $03, $28, $06, $2E, $06,
    $4A, $06, $03, $2A, $06, $2C, $06, $4A,
    $06, $03, $2A, $06, $2C, $06, $49, $06,
    $03, $2A, $06, $2E, $06, $4A, $06, $03,
    $2A, $06, $2E, $06, $49, $06, $03, $2A,
    $06, $45, $06, $4A, $06, $03, $2A, $06,
    $45, $06, $49, $06, $03, $2C, $06, $45,

    $06, $4A, $06, $03, $2C, $06, $2D, $06,
    $49, $06, $03, $2C, $06, $45, $06, $49,
    $06, $03, $33, $06, $2E, $06, $49, $06,
    $03, $35, $06, $2D, $06, $4A, $06, $03,
    $34, $06, $2D, $06, $4A, $06, $03, $36,
    $06, $2D, $06, $4A, $06, $03, $44, $06,
    $2C, $06, $4A, $06, $03, $44, $06, $45,
    $06, $4A, $06, $03, $4A, $06, $2D, $06,

    $4A, $06, $03, $4A, $06, $2C, $06, $4A,
    $06, $03, $4A, $06, $45, $06, $4A, $06,
    $03, $45, $06, $45, $06, $4A, $06, $03,
    $42, $06, $45, $06, $4A, $06, $03, $46,
    $06, $2D, $06, $4A, $06, $03, $39, $06,
    $45, $06, $4A, $06, $03, $43, $06, $45,
    $06, $4A, $06, $03, $46, $06, $2C, $06,
    $2D, $06, $03, $45, $06, $2E, $06, $4A,

    $06, $03, $44, $06, $2C, $06, $45, $06,
    $03, $43, $06, $45, $06, $45, $06, $03,
    $2C, $06, $2D, $06, $4A, $06, $03, $2D,
    $06, $2C, $06, $4A, $06, $03, $45, $06,
    $2C, $06, $4A, $06, $03, $41, $06, $45,
    $06, $4A, $06, $03, $28, $06, $2D, $06,
    $4A, $06, $03, $33, $06, $2E, $06, $4A,
    $06, $03, $46, $06, $2C, $06, $4A, $06,

    $03, $35, $06, $44, $06, $D2, $06, $03,
    $42, $06, $44, $06, $D2, $06, $04, $27,
    $06, $44, $06, $44, $06, $47, $06, $04,
    $27, $06, $43, $06, $28, $06, $31, $06,
    $04, $45, $06, $2D, $06, $45, $06, $2F,
    $06, $04, $35, $06, $44, $06, $39, $06,
    $45, $06, $04, $31, $06, $33, $06, $48,
    $06, $44, $06, $04, $39, $06, $44, $06,

    $4A, $06, $47, $06, $04, $48, $06, $33,
    $06, $44, $06, $45, $06, $03, $35, $06,
    $44, $06, $49, $06, $12, $35, $06, $44,
    $06, $49, $06, $20, $00, $27, $06, $44,
    $06, $44, $06, $47, $06, $20, $00, $39,
    $06, $44, $06, $4A, $06, $47, $06, $20,
    $00, $48, $06, $33, $06, $44, $06, $45,
    $06, $08, $2C, $06, $44, $06, $20, $00,

    $2C, $06, $44, $06, $27, $06, $44, $06,
    $47, $06, $04, $31, $06, $CC, $06, $27,
    $06, $44, $06, $01, $14, $20, $01, $13,
    $20, $01, $5F, $00, $01, $7B, $00, $01,
    $7D, $00, $01, $14, $30, $01, $15, $30,
    $01, $10, $30, $01, $11, $30, $01, $0A,
    $30, $01, $0B, $30, $01, $08, $30, $01,
    $09, $30, $01, $0C, $30, $01, $0D, $30,

    $01, $0E, $30, $01, $0F, $30, $01, $5B,
    $00, $01, $5D, $00, $01, $2C, $00, $01,
    $01, $30, $01, $3B, $00, $01, $3A, $00,
    $01, $3F, $00, $01, $21, $00, $01, $23,
    $00, $01, $26, $00, $01, $2A, $00, $01,
    $2D, $00, $01, $3C, $00, $01, $3E, $00,
    $01, $5C, $00, $01, $24, $00, $01, $25,
    $00, $01, $40, $00, $02, $20, $00, $4B,

    $06, $02, $40, $06, $4B, $06, $02, $20,
    $00, $4C, $06, $02, $20, $00, $4D, $06,
    $02, $20, $00, $4E, $06, $02, $40, $06,
    $4E, $06, $02, $20, $00, $4F, $06, $02,
    $40, $06, $4F, $06, $02, $20, $00, $50,
    $06, $02, $40, $06, $50, $06, $02, $20,
    $00, $51, $06, $02, $40, $06, $51, $06,
    $02, $20, $00, $52, $06, $02, $40, $06,

    $52, $06, $01, $21, $06, $02, $27, $06,
    $53, $06, $02, $27, $06, $54, $06, $02,
    $48, $06, $54, $06, $02, $27, $06, $55,
    $06, $02, $4A, $06, $54, $06, $01, $27,
    $06, $01, $28, $06, $01, $29, $06, $01,
    $2A, $06, $01, $2B, $06, $01, $2C, $06,
    $01, $2D, $06, $01, $2E, $06, $01, $2F,
    $06, $01, $30, $06, $01, $31, $06, $01,

    $32, $06, $01, $33, $06, $01, $34, $06,
    $01, $35, $06, $01, $36, $06, $01, $37,
    $06, $01, $38, $06, $01, $39, $06, $01,
    $3A, $06, $01, $41, $06, $01, $42, $06,
    $01, $43, $06, $01, $44, $06, $01, $45,
    $06, $01, $46, $06, $01, $47, $06, $01,
    $48, $06, $01, $4A, $06, $03, $44, $06,
    $27, $06, $53, $06, $03, $44, $06, $27,

    $06, $54, $06, $03, $44, $06, $27, $06,
    $55, $06, $02, $44, $06, $27, $06, $01,
    $22, $00, $01, $27, $00, $01, $2F, $00,
    $01, $5E, $00, $01, $60, $00, $01, $7C,
    $00, $01, $7E, $00, $01, $85, $29, $01,
    $86, $29, $01, $02, $30, $01, $FB, $30,
    $01, $A1, $30, $01, $A3, $30, $01, $A5,
    $30, $01, $A7, $30, $01, $A9, $30, $01,

    $E3, $30, $01, $E5, $30, $01, $E7, $30,
    $01, $C3, $30, $01, $FC, $30, $01, $F3,
    $30, $01, $99, $30, $01, $9A, $30, $01,
    $A2, $00, $01, $A3, $00, $01, $AC, $00,
    $01, $A6, $00, $01, $A5, $00, $01, $A9,
    $20, $01, $02, $25, $01, $90, $21, $01,
    $91, $21, $01, $92, $21, $01, $93, $21,
    $01, $A0, $25, $01, $CB, $25);
var
  i: Cardinal;
begin
  i := CHAR_COMPATIBLE_DECOMPOSITION_1[Ord(Char) div CHAR_COMPATIBLE_DECOMPOSITION_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      i := CHAR_COMPATIBLE_DECOMPOSITION_2[i, Ord(Char) and (CHAR_COMPATIBLE_DECOMPOSITION_SIZE - 1)];
      if i <> 0 then
        begin
          Result := Pointer(@CHAR_COMPATIBLE_DECOMPOSITION_DATA[i]);
          Exit;
        end;
    end;
  Result := CharDecomposeCanonicalW(Char);
end;

function CharToCaseFoldW(const Char: WideChar): WideChar;
const
  CHAR_TO_CASE_FOLD_1: array[$0000..$03FF] of Byte = (
    $00, $01, $02, $03, $04, $05, $06, $07,
    $08, $00, $00, $00, $00, $09, $0A, $0B,
    $0C, $0D, $0E, $0F, $10, $11, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $12, $13, $14, $15, $16, $17, $18, $19,

    $00, $00, $00, $00, $1A, $1B, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $1C, $1D, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $1E, $00, $00, $00);
  CHAR_TO_CASE_FOLD_2: array[$0000..$001D, $0000..$003F] of WideChar = (

    (#$0040, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067,
    #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
    #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077,
    #$0078, #$0079, #$007A, #$005B, #$005C, #$005D, #$005E, #$005F,
    #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067,
    #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
    #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077,
    #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F),

    (#$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087,
    #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
    #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097,
    #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
    #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7,
    #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
    #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$03BC, #$00B6, #$00B7,
    #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF),

    (#$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7,
    #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
    #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00D7,
    #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00DF,
    #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7,
    #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
    #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00F7,
    #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00FF),

    (#$0101, #$0101, #$0103, #$0103, #$0105, #$0105, #$0107, #$0107,
    #$0109, #$0109, #$010B, #$010B, #$010D, #$010D, #$010F, #$010F,
    #$0111, #$0111, #$0113, #$0113, #$0115, #$0115, #$0117, #$0117,
    #$0119, #$0119, #$011B, #$011B, #$011D, #$011D, #$011F, #$011F,
    #$0121, #$0121, #$0123, #$0123, #$0125, #$0125, #$0127, #$0127,
    #$0129, #$0129, #$012B, #$012B, #$012D, #$012D, #$012F, #$012F,
    #$0130, #$0131, #$0133, #$0133, #$0135, #$0135, #$0137, #$0137,
    #$0138, #$013A, #$013A, #$013C, #$013C, #$013E, #$013E, #$0140),

    (#$0140, #$0142, #$0142, #$0144, #$0144, #$0146, #$0146, #$0148,
    #$0148, #$0149, #$014B, #$014B, #$014D, #$014D, #$014F, #$014F,
    #$0151, #$0151, #$0153, #$0153, #$0155, #$0155, #$0157, #$0157,
    #$0159, #$0159, #$015B, #$015B, #$015D, #$015D, #$015F, #$015F,
    #$0161, #$0161, #$0163, #$0163, #$0165, #$0165, #$0167, #$0167,
    #$0169, #$0169, #$016B, #$016B, #$016D, #$016D, #$016F, #$016F,
    #$0171, #$0171, #$0173, #$0173, #$0175, #$0175, #$0177, #$0177,
    #$00FF, #$017A, #$017A, #$017C, #$017C, #$017E, #$017E, #$0073),

    (#$0180, #$0253, #$0183, #$0183, #$0185, #$0185, #$0254, #$0188,
    #$0188, #$0256, #$0257, #$018C, #$018C, #$018D, #$01DD, #$0259,
    #$025B, #$0192, #$0192, #$0260, #$0263, #$0195, #$0269, #$0268,
    #$0199, #$0199, #$019A, #$019B, #$026F, #$0272, #$019E, #$0275,
    #$01A1, #$01A1, #$01A3, #$01A3, #$01A5, #$01A5, #$0280, #$01A8,
    #$01A8, #$0283, #$01AA, #$01AB, #$01AD, #$01AD, #$0288, #$01B0,
    #$01B0, #$028A, #$028B, #$01B4, #$01B4, #$01B6, #$01B6, #$0292,
    #$01B9, #$01B9, #$01BA, #$01BB, #$01BD, #$01BD, #$01BE, #$01BF),

    (#$01C0, #$01C1, #$01C2, #$01C3, #$01C6, #$01C6, #$01C6, #$01C9,
    #$01C9, #$01C9, #$01CC, #$01CC, #$01CC, #$01CE, #$01CE, #$01D0,
    #$01D0, #$01D2, #$01D2, #$01D4, #$01D4, #$01D6, #$01D6, #$01D8,
    #$01D8, #$01DA, #$01DA, #$01DC, #$01DC, #$01DD, #$01DF, #$01DF,
    #$01E1, #$01E1, #$01E3, #$01E3, #$01E5, #$01E5, #$01E7, #$01E7,
    #$01E9, #$01E9, #$01EB, #$01EB, #$01ED, #$01ED, #$01EF, #$01EF,
    #$01F0, #$01F3, #$01F3, #$01F3, #$01F5, #$01F5, #$0195, #$01BF,
    #$01F9, #$01F9, #$01FB, #$01FB, #$01FD, #$01FD, #$01FF, #$01FF),

    (#$0201, #$0201, #$0203, #$0203, #$0205, #$0205, #$0207, #$0207,
    #$0209, #$0209, #$020B, #$020B, #$020D, #$020D, #$020F, #$020F,
    #$0211, #$0211, #$0213, #$0213, #$0215, #$0215, #$0217, #$0217,
    #$0219, #$0219, #$021B, #$021B, #$021D, #$021D, #$021F, #$021F,
    #$019E, #$0221, #$0223, #$0223, #$0225, #$0225, #$0227, #$0227,
    #$0229, #$0229, #$022B, #$022B, #$022D, #$022D, #$022F, #$022F,
    #$0231, #$0231, #$0233, #$0233, #$0234, #$0235, #$0236, #$0237,
    #$0238, #$0239, #$023A, #$023B, #$023C, #$023D, #$023E, #$023F),

    (#$0340, #$0341, #$0342, #$0343, #$0344, #$03B9, #$0346, #$0347,
    #$0348, #$0349, #$034A, #$034B, #$034C, #$034D, #$034E, #$034F,
    #$0350, #$0351, #$0352, #$0353, #$0354, #$0355, #$0356, #$0357,
    #$0358, #$0359, #$035A, #$035B, #$035C, #$035D, #$035E, #$035F,
    #$0360, #$0361, #$0362, #$0363, #$0364, #$0365, #$0366, #$0367,
    #$0368, #$0369, #$036A, #$036B, #$036C, #$036D, #$036E, #$036F,
    #$0370, #$0371, #$0372, #$0373, #$0374, #$0375, #$0376, #$0377,
    #$0378, #$0379, #$037A, #$037B, #$037C, #$037D, #$037E, #$037F),

    (#$0380, #$0381, #$0382, #$0383, #$0384, #$0385, #$03AC, #$0387,
    #$03AD, #$03AE, #$03AF, #$038B, #$03CC, #$038D, #$03CD, #$03CE,
    #$0390, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7,
    #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF,
    #$03C0, #$03C1, #$03A2, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7,
    #$03C8, #$03C9, #$03CA, #$03CB, #$03AC, #$03AD, #$03AE, #$03AF,
    #$03B0, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7,
    #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF),

    (#$03C0, #$03C1, #$03C3, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7,
    #$03C8, #$03C9, #$03CA, #$03CB, #$03CC, #$03CD, #$03CE, #$03CF,
    #$03B2, #$03B8, #$03D2, #$03D3, #$03D4, #$03C6, #$03C0, #$03D7,
    #$03D9, #$03D9, #$03DB, #$03DB, #$03DD, #$03DD, #$03DF, #$03DF,
    #$03E1, #$03E1, #$03E3, #$03E3, #$03E5, #$03E5, #$03E7, #$03E7,
    #$03E9, #$03E9, #$03EB, #$03EB, #$03ED, #$03ED, #$03EF, #$03EF,
    #$03BA, #$03C1, #$03F2, #$03F3, #$03B8, #$03B5, #$03F6, #$03F8,
    #$03F8, #$03F2, #$03FB, #$03FB, #$03FC, #$03FD, #$03FE, #$03FF),

    (#$0450, #$0451, #$0452, #$0453, #$0454, #$0455, #$0456, #$0457,
    #$0458, #$0459, #$045A, #$045B, #$045C, #$045D, #$045E, #$045F,
    #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437,
    #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F,
    #$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447,
    #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F,
    #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437,
    #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F),

    (#$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447,
    #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F,
    #$0450, #$0451, #$0452, #$0453, #$0454, #$0455, #$0456, #$0457,
    #$0458, #$0459, #$045A, #$045B, #$045C, #$045D, #$045E, #$045F,
    #$0461, #$0461, #$0463, #$0463, #$0465, #$0465, #$0467, #$0467,
    #$0469, #$0469, #$046B, #$046B, #$046D, #$046D, #$046F, #$046F,
    #$0471, #$0471, #$0473, #$0473, #$0475, #$0475, #$0477, #$0477,
    #$0479, #$0479, #$047B, #$047B, #$047D, #$047D, #$047F, #$047F),

    (#$0481, #$0481, #$0482, #$0483, #$0484, #$0485, #$0486, #$0487,
    #$0488, #$0489, #$048B, #$048B, #$048D, #$048D, #$048F, #$048F,
    #$0491, #$0491, #$0493, #$0493, #$0495, #$0495, #$0497, #$0497,
    #$0499, #$0499, #$049B, #$049B, #$049D, #$049D, #$049F, #$049F,
    #$04A1, #$04A1, #$04A3, #$04A3, #$04A5, #$04A5, #$04A7, #$04A7,
    #$04A9, #$04A9, #$04AB, #$04AB, #$04AD, #$04AD, #$04AF, #$04AF,
    #$04B1, #$04B1, #$04B3, #$04B3, #$04B5, #$04B5, #$04B7, #$04B7,
    #$04B9, #$04B9, #$04BB, #$04BB, #$04BD, #$04BD, #$04BF, #$04BF),

    (#$04C0, #$04C2, #$04C2, #$04C4, #$04C4, #$04C6, #$04C6, #$04C8,
    #$04C8, #$04CA, #$04CA, #$04CC, #$04CC, #$04CE, #$04CE, #$04CF,
    #$04D1, #$04D1, #$04D3, #$04D3, #$04D5, #$04D5, #$04D7, #$04D7,
    #$04D9, #$04D9, #$04DB, #$04DB, #$04DD, #$04DD, #$04DF, #$04DF,
    #$04E1, #$04E1, #$04E3, #$04E3, #$04E5, #$04E5, #$04E7, #$04E7,
    #$04E9, #$04E9, #$04EB, #$04EB, #$04ED, #$04ED, #$04EF, #$04EF,
    #$04F1, #$04F1, #$04F3, #$04F3, #$04F5, #$04F5, #$04F6, #$04F7,
    #$04F9, #$04F9, #$04FA, #$04FB, #$04FC, #$04FD, #$04FE, #$04FF),

    (#$0501, #$0501, #$0503, #$0503, #$0505, #$0505, #$0507, #$0507,
    #$0509, #$0509, #$050B, #$050B, #$050D, #$050D, #$050F, #$050F,
    #$0510, #$0511, #$0512, #$0513, #$0514, #$0515, #$0516, #$0517,
    #$0518, #$0519, #$051A, #$051B, #$051C, #$051D, #$051E, #$051F,
    #$0520, #$0521, #$0522, #$0523, #$0524, #$0525, #$0526, #$0527,
    #$0528, #$0529, #$052A, #$052B, #$052C, #$052D, #$052E, #$052F,
    #$0530, #$0561, #$0562, #$0563, #$0564, #$0565, #$0566, #$0567,
    #$0568, #$0569, #$056A, #$056B, #$056C, #$056D, #$056E, #$056F),

    (#$0570, #$0571, #$0572, #$0573, #$0574, #$0575, #$0576, #$0577,
    #$0578, #$0579, #$057A, #$057B, #$057C, #$057D, #$057E, #$057F,
    #$0580, #$0581, #$0582, #$0583, #$0584, #$0585, #$0586, #$0557,
    #$0558, #$0559, #$055A, #$055B, #$055C, #$055D, #$055E, #$055F,
    #$0560, #$0561, #$0562, #$0563, #$0564, #$0565, #$0566, #$0567,
    #$0568, #$0569, #$056A, #$056B, #$056C, #$056D, #$056E, #$056F,
    #$0570, #$0571, #$0572, #$0573, #$0574, #$0575, #$0576, #$0577,
    #$0578, #$0579, #$057A, #$057B, #$057C, #$057D, #$057E, #$057F),

    (#$1E01, #$1E01, #$1E03, #$1E03, #$1E05, #$1E05, #$1E07, #$1E07,
    #$1E09, #$1E09, #$1E0B, #$1E0B, #$1E0D, #$1E0D, #$1E0F, #$1E0F,
    #$1E11, #$1E11, #$1E13, #$1E13, #$1E15, #$1E15, #$1E17, #$1E17,
    #$1E19, #$1E19, #$1E1B, #$1E1B, #$1E1D, #$1E1D, #$1E1F, #$1E1F,
    #$1E21, #$1E21, #$1E23, #$1E23, #$1E25, #$1E25, #$1E27, #$1E27,
    #$1E29, #$1E29, #$1E2B, #$1E2B, #$1E2D, #$1E2D, #$1E2F, #$1E2F,
    #$1E31, #$1E31, #$1E33, #$1E33, #$1E35, #$1E35, #$1E37, #$1E37,
    #$1E39, #$1E39, #$1E3B, #$1E3B, #$1E3D, #$1E3D, #$1E3F, #$1E3F),

    (#$1E41, #$1E41, #$1E43, #$1E43, #$1E45, #$1E45, #$1E47, #$1E47,
    #$1E49, #$1E49, #$1E4B, #$1E4B, #$1E4D, #$1E4D, #$1E4F, #$1E4F,
    #$1E51, #$1E51, #$1E53, #$1E53, #$1E55, #$1E55, #$1E57, #$1E57,
    #$1E59, #$1E59, #$1E5B, #$1E5B, #$1E5D, #$1E5D, #$1E5F, #$1E5F,
    #$1E61, #$1E61, #$1E63, #$1E63, #$1E65, #$1E65, #$1E67, #$1E67,
    #$1E69, #$1E69, #$1E6B, #$1E6B, #$1E6D, #$1E6D, #$1E6F, #$1E6F,
    #$1E71, #$1E71, #$1E73, #$1E73, #$1E75, #$1E75, #$1E77, #$1E77,
    #$1E79, #$1E79, #$1E7B, #$1E7B, #$1E7D, #$1E7D, #$1E7F, #$1E7F),

    (#$1E81, #$1E81, #$1E83, #$1E83, #$1E85, #$1E85, #$1E87, #$1E87,
    #$1E89, #$1E89, #$1E8B, #$1E8B, #$1E8D, #$1E8D, #$1E8F, #$1E8F,
    #$1E91, #$1E91, #$1E93, #$1E93, #$1E95, #$1E95, #$1E96, #$1E97,
    #$1E98, #$1E99, #$1E9A, #$1E61, #$1E9C, #$1E9D, #$1E9E, #$1E9F,
    #$1EA1, #$1EA1, #$1EA3, #$1EA3, #$1EA5, #$1EA5, #$1EA7, #$1EA7,
    #$1EA9, #$1EA9, #$1EAB, #$1EAB, #$1EAD, #$1EAD, #$1EAF, #$1EAF,
    #$1EB1, #$1EB1, #$1EB3, #$1EB3, #$1EB5, #$1EB5, #$1EB7, #$1EB7,
    #$1EB9, #$1EB9, #$1EBB, #$1EBB, #$1EBD, #$1EBD, #$1EBF, #$1EBF),

    (#$1EC1, #$1EC1, #$1EC3, #$1EC3, #$1EC5, #$1EC5, #$1EC7, #$1EC7,
    #$1EC9, #$1EC9, #$1ECB, #$1ECB, #$1ECD, #$1ECD, #$1ECF, #$1ECF,
    #$1ED1, #$1ED1, #$1ED3, #$1ED3, #$1ED5, #$1ED5, #$1ED7, #$1ED7,
    #$1ED9, #$1ED9, #$1EDB, #$1EDB, #$1EDD, #$1EDD, #$1EDF, #$1EDF,
    #$1EE1, #$1EE1, #$1EE3, #$1EE3, #$1EE5, #$1EE5, #$1EE7, #$1EE7,
    #$1EE9, #$1EE9, #$1EEB, #$1EEB, #$1EED, #$1EED, #$1EEF, #$1EEF,
    #$1EF1, #$1EF1, #$1EF3, #$1EF3, #$1EF5, #$1EF5, #$1EF7, #$1EF7,
    #$1EF9, #$1EF9, #$1EFA, #$1EFB, #$1EFC, #$1EFD, #$1EFE, #$1EFF),

    (#$1F00, #$1F01, #$1F02, #$1F03, #$1F04, #$1F05, #$1F06, #$1F07,
    #$1F00, #$1F01, #$1F02, #$1F03, #$1F04, #$1F05, #$1F06, #$1F07,
    #$1F10, #$1F11, #$1F12, #$1F13, #$1F14, #$1F15, #$1F16, #$1F17,
    #$1F10, #$1F11, #$1F12, #$1F13, #$1F14, #$1F15, #$1F1E, #$1F1F,
    #$1F20, #$1F21, #$1F22, #$1F23, #$1F24, #$1F25, #$1F26, #$1F27,
    #$1F20, #$1F21, #$1F22, #$1F23, #$1F24, #$1F25, #$1F26, #$1F27,
    #$1F30, #$1F31, #$1F32, #$1F33, #$1F34, #$1F35, #$1F36, #$1F37,
    #$1F30, #$1F31, #$1F32, #$1F33, #$1F34, #$1F35, #$1F36, #$1F37),

    (#$1F40, #$1F41, #$1F42, #$1F43, #$1F44, #$1F45, #$1F46, #$1F47,
    #$1F40, #$1F41, #$1F42, #$1F43, #$1F44, #$1F45, #$1F4E, #$1F4F,
    #$1F50, #$1F51, #$1F52, #$1F53, #$1F54, #$1F55, #$1F56, #$1F57,
    #$1F58, #$1F51, #$1F5A, #$1F53, #$1F5C, #$1F55, #$1F5E, #$1F57,
    #$1F60, #$1F61, #$1F62, #$1F63, #$1F64, #$1F65, #$1F66, #$1F67,
    #$1F60, #$1F61, #$1F62, #$1F63, #$1F64, #$1F65, #$1F66, #$1F67,
    #$1F70, #$1F71, #$1F72, #$1F73, #$1F74, #$1F75, #$1F76, #$1F77,
    #$1F78, #$1F79, #$1F7A, #$1F7B, #$1F7C, #$1F7D, #$1F7E, #$1F7F),

    (#$1F80, #$1F81, #$1F82, #$1F83, #$1F84, #$1F85, #$1F86, #$1F87,
    #$1F80, #$1F81, #$1F82, #$1F83, #$1F84, #$1F85, #$1F86, #$1F87,
    #$1F90, #$1F91, #$1F92, #$1F93, #$1F94, #$1F95, #$1F96, #$1F97,
    #$1F90, #$1F91, #$1F92, #$1F93, #$1F94, #$1F95, #$1F96, #$1F97,
    #$1FA0, #$1FA1, #$1FA2, #$1FA3, #$1FA4, #$1FA5, #$1FA6, #$1FA7,
    #$1FA0, #$1FA1, #$1FA2, #$1FA3, #$1FA4, #$1FA5, #$1FA6, #$1FA7,
    #$1FB0, #$1FB1, #$1FB2, #$1FB3, #$1FB4, #$1FB5, #$1FB6, #$1FB7,
    #$1FB0, #$1FB1, #$1F70, #$1F71, #$1FB3, #$1FBD, #$03B9, #$1FBF),

    (#$1FC0, #$1FC1, #$1FC2, #$1FC3, #$1FC4, #$1FC5, #$1FC6, #$1FC7,
    #$1F72, #$1F73, #$1F74, #$1F75, #$1FC3, #$1FCD, #$1FCE, #$1FCF,
    #$1FD0, #$1FD1, #$1FD2, #$1FD3, #$1FD4, #$1FD5, #$1FD6, #$1FD7,
    #$1FD0, #$1FD1, #$1F76, #$1F77, #$1FDC, #$1FDD, #$1FDE, #$1FDF,
    #$1FE0, #$1FE1, #$1FE2, #$1FE3, #$1FE4, #$1FE5, #$1FE6, #$1FE7,
    #$1FE0, #$1FE1, #$1F7A, #$1F7B, #$1FE5, #$1FED, #$1FEE, #$1FEF,
    #$1FF0, #$1FF1, #$1FF2, #$1FF3, #$1FF4, #$1FF5, #$1FF6, #$1FF7,
    #$1F78, #$1F79, #$1F7C, #$1F7D, #$1FF3, #$1FFD, #$1FFE, #$1FFF),

    (#$2100, #$2101, #$2102, #$2103, #$2104, #$2105, #$2106, #$2107,
    #$2108, #$2109, #$210A, #$210B, #$210C, #$210D, #$210E, #$210F,
    #$2110, #$2111, #$2112, #$2113, #$2114, #$2115, #$2116, #$2117,
    #$2118, #$2119, #$211A, #$211B, #$211C, #$211D, #$211E, #$211F,
    #$2120, #$2121, #$2122, #$2123, #$2124, #$2125, #$03C9, #$2127,
    #$2128, #$2129, #$006B, #$00E5, #$212C, #$212D, #$212E, #$212F,
    #$2130, #$2131, #$2132, #$2133, #$2134, #$2135, #$2136, #$2137,
    #$2138, #$2139, #$213A, #$213B, #$213C, #$213D, #$213E, #$213F),

    (#$2140, #$2141, #$2142, #$2143, #$2144, #$2145, #$2146, #$2147,
    #$2148, #$2149, #$214A, #$214B, #$214C, #$214D, #$214E, #$214F,
    #$2150, #$2151, #$2152, #$2153, #$2154, #$2155, #$2156, #$2157,
    #$2158, #$2159, #$215A, #$215B, #$215C, #$215D, #$215E, #$215F,
    #$2170, #$2171, #$2172, #$2173, #$2174, #$2175, #$2176, #$2177,
    #$2178, #$2179, #$217A, #$217B, #$217C, #$217D, #$217E, #$217F,
    #$2170, #$2171, #$2172, #$2173, #$2174, #$2175, #$2176, #$2177,
    #$2178, #$2179, #$217A, #$217B, #$217C, #$217D, #$217E, #$217F),

    (#$2480, #$2481, #$2482, #$2483, #$2484, #$2485, #$2486, #$2487,
    #$2488, #$2489, #$248A, #$248B, #$248C, #$248D, #$248E, #$248F,
    #$2490, #$2491, #$2492, #$2493, #$2494, #$2495, #$2496, #$2497,
    #$2498, #$2499, #$249A, #$249B, #$249C, #$249D, #$249E, #$249F,
    #$24A0, #$24A1, #$24A2, #$24A3, #$24A4, #$24A5, #$24A6, #$24A7,
    #$24A8, #$24A9, #$24AA, #$24AB, #$24AC, #$24AD, #$24AE, #$24AF,
    #$24B0, #$24B1, #$24B2, #$24B3, #$24B4, #$24B5, #$24D0, #$24D1,
    #$24D2, #$24D3, #$24D4, #$24D5, #$24D6, #$24D7, #$24D8, #$24D9),

    (#$24DA, #$24DB, #$24DC, #$24DD, #$24DE, #$24DF, #$24E0, #$24E1,
    #$24E2, #$24E3, #$24E4, #$24E5, #$24E6, #$24E7, #$24E8, #$24E9,
    #$24D0, #$24D1, #$24D2, #$24D3, #$24D4, #$24D5, #$24D6, #$24D7,
    #$24D8, #$24D9, #$24DA, #$24DB, #$24DC, #$24DD, #$24DE, #$24DF,
    #$24E0, #$24E1, #$24E2, #$24E3, #$24E4, #$24E5, #$24E6, #$24E7,
    #$24E8, #$24E9, #$24EA, #$24EB, #$24EC, #$24ED, #$24EE, #$24EF,
    #$24F0, #$24F1, #$24F2, #$24F3, #$24F4, #$24F5, #$24F6, #$24F7,
    #$24F8, #$24F9, #$24FA, #$24FB, #$24FC, #$24FD, #$24FE, #$24FF),

    (#$FF00, #$FF01, #$FF02, #$FF03, #$FF04, #$FF05, #$FF06, #$FF07,
    #$FF08, #$FF09, #$FF0A, #$FF0B, #$FF0C, #$FF0D, #$FF0E, #$FF0F,
    #$FF10, #$FF11, #$FF12, #$FF13, #$FF14, #$FF15, #$FF16, #$FF17,
    #$FF18, #$FF19, #$FF1A, #$FF1B, #$FF1C, #$FF1D, #$FF1E, #$FF1F,
    #$FF20, #$FF41, #$FF42, #$FF43, #$FF44, #$FF45, #$FF46, #$FF47,
    #$FF48, #$FF49, #$FF4A, #$FF4B, #$FF4C, #$FF4D, #$FF4E, #$FF4F,
    #$FF50, #$FF51, #$FF52, #$FF53, #$FF54, #$FF55, #$FF56, #$FF57,
    #$FF58, #$FF59, #$FF5A, #$FF3B, #$FF3C, #$FF3D, #$FF3E, #$FF3F));
  CHAR_TO_CASE_FOLD_SIZE = 64;
var
  i: Integer;
begin
  Result := Char;
  i := CHAR_TO_CASE_FOLD_1[Ord(Result) div CHAR_TO_CASE_FOLD_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      Result := CHAR_TO_CASE_FOLD_2[i, Ord(Result) and (CHAR_TO_CASE_FOLD_SIZE - 1)];
    end;
end;

function CharToUpperW(const Char: WideChar): WideChar;
const
  CHAR_TO_UPPER_1: array[$0000..$03FF] of Byte = (
    $00, $01, $02, $03, $04, $05, $06, $07,
    $08, $09, $0A, $00, $00, $0B, $0C, $0D,
    $0E, $0F, $10, $11, $12, $13, $14, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $15, $16, $17, $18, $19, $1A, $1B, $1C,

    $00, $00, $00, $00, $00, $1D, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $1E, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $1F, $00, $00);
  CHAR_TO_UPPER_2: array[$0000..$001E, $0000..$003F] of WideChar = (

    (#$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047,
    #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
    #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057,
    #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
    #$0060, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047,
    #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
    #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057,
    #$0058, #$0059, #$005A, #$007B, #$007C, #$007D, #$007E, #$007F),

    (#$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087,
    #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
    #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097,
    #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
    #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7,
    #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
    #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$039C, #$00B6, #$00B7,
    #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF),

    (#$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7,
    #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
    #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7,
    #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
    #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7,
    #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
    #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00F7,
    #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$0178),

    (#$0100, #$0100, #$0102, #$0102, #$0104, #$0104, #$0106, #$0106,
    #$0108, #$0108, #$010A, #$010A, #$010C, #$010C, #$010E, #$010E,
    #$0110, #$0110, #$0112, #$0112, #$0114, #$0114, #$0116, #$0116,
    #$0118, #$0118, #$011A, #$011A, #$011C, #$011C, #$011E, #$011E,
    #$0120, #$0120, #$0122, #$0122, #$0124, #$0124, #$0126, #$0126,
    #$0128, #$0128, #$012A, #$012A, #$012C, #$012C, #$012E, #$012E,
    #$0130, #$0049, #$0132, #$0132, #$0134, #$0134, #$0136, #$0136,
    #$0138, #$0139, #$0139, #$013B, #$013B, #$013D, #$013D, #$013F),

    (#$013F, #$0141, #$0141, #$0143, #$0143, #$0145, #$0145, #$0147,
    #$0147, #$0149, #$014A, #$014A, #$014C, #$014C, #$014E, #$014E,
    #$0150, #$0150, #$0152, #$0152, #$0154, #$0154, #$0156, #$0156,
    #$0158, #$0158, #$015A, #$015A, #$015C, #$015C, #$015E, #$015E,
    #$0160, #$0160, #$0162, #$0162, #$0164, #$0164, #$0166, #$0166,
    #$0168, #$0168, #$016A, #$016A, #$016C, #$016C, #$016E, #$016E,
    #$0170, #$0170, #$0172, #$0172, #$0174, #$0174, #$0176, #$0176,
    #$0178, #$0179, #$0179, #$017B, #$017B, #$017D, #$017D, #$0053),

    (#$0180, #$0181, #$0182, #$0182, #$0184, #$0184, #$0186, #$0187,
    #$0187, #$0189, #$018A, #$018B, #$018B, #$018D, #$018E, #$018F,
    #$0190, #$0191, #$0191, #$0193, #$0194, #$01F6, #$0196, #$0197,
    #$0198, #$0198, #$019A, #$019B, #$019C, #$019D, #$0220, #$019F,
    #$01A0, #$01A0, #$01A2, #$01A2, #$01A4, #$01A4, #$01A6, #$01A7,
    #$01A7, #$01A9, #$01AA, #$01AB, #$01AC, #$01AC, #$01AE, #$01AF,
    #$01AF, #$01B1, #$01B2, #$01B3, #$01B3, #$01B5, #$01B5, #$01B7,
    #$01B8, #$01B8, #$01BA, #$01BB, #$01BC, #$01BC, #$01BE, #$01F7),

    (#$01C0, #$01C1, #$01C2, #$01C3, #$01C4, #$01C4, #$01C4, #$01C7,
    #$01C7, #$01C7, #$01CA, #$01CA, #$01CA, #$01CD, #$01CD, #$01CF,
    #$01CF, #$01D1, #$01D1, #$01D3, #$01D3, #$01D5, #$01D5, #$01D7,
    #$01D7, #$01D9, #$01D9, #$01DB, #$01DB, #$018E, #$01DE, #$01DE,
    #$01E0, #$01E0, #$01E2, #$01E2, #$01E4, #$01E4, #$01E6, #$01E6,
    #$01E8, #$01E8, #$01EA, #$01EA, #$01EC, #$01EC, #$01EE, #$01EE,
    #$01F0, #$01F1, #$01F1, #$01F1, #$01F4, #$01F4, #$01F6, #$01F7,
    #$01F8, #$01F8, #$01FA, #$01FA, #$01FC, #$01FC, #$01FE, #$01FE),

    (#$0200, #$0200, #$0202, #$0202, #$0204, #$0204, #$0206, #$0206,
    #$0208, #$0208, #$020A, #$020A, #$020C, #$020C, #$020E, #$020E,
    #$0210, #$0210, #$0212, #$0212, #$0214, #$0214, #$0216, #$0216,
    #$0218, #$0218, #$021A, #$021A, #$021C, #$021C, #$021E, #$021E,
    #$0220, #$0221, #$0222, #$0222, #$0224, #$0224, #$0226, #$0226,
    #$0228, #$0228, #$022A, #$022A, #$022C, #$022C, #$022E, #$022E,
    #$0230, #$0230, #$0232, #$0232, #$0234, #$0235, #$0236, #$0237,
    #$0238, #$0239, #$023A, #$023B, #$023C, #$023D, #$023E, #$023F),

    (#$0240, #$0241, #$0242, #$0243, #$0244, #$0245, #$0246, #$0247,
    #$0248, #$0249, #$024A, #$024B, #$024C, #$024D, #$024E, #$024F,
    #$0250, #$0251, #$0252, #$0181, #$0186, #$0255, #$0189, #$018A,
    #$0258, #$018F, #$025A, #$0190, #$025C, #$025D, #$025E, #$025F,
    #$0193, #$0261, #$0262, #$0194, #$0264, #$0265, #$0266, #$0267,
    #$0197, #$0196, #$026A, #$026B, #$026C, #$026D, #$026E, #$019C,
    #$0270, #$0271, #$019D, #$0273, #$0274, #$019F, #$0276, #$0277,
    #$0278, #$0279, #$027A, #$027B, #$027C, #$027D, #$027E, #$027F),

    (#$01A6, #$0281, #$0282, #$01A9, #$0284, #$0285, #$0286, #$0287,
    #$01AE, #$0289, #$01B1, #$01B2, #$028C, #$028D, #$028E, #$028F,
    #$0290, #$0291, #$01B7, #$0293, #$0294, #$0295, #$0296, #$0297,
    #$0298, #$0299, #$029A, #$029B, #$029C, #$029D, #$029E, #$029F,
    #$02A0, #$02A1, #$02A2, #$02A3, #$02A4, #$02A5, #$02A6, #$02A7,
    #$02A8, #$02A9, #$02AA, #$02AB, #$02AC, #$02AD, #$02AE, #$02AF,
    #$02B0, #$02B1, #$02B2, #$02B3, #$02B4, #$02B5, #$02B6, #$02B7,
    #$02B8, #$02B9, #$02BA, #$02BB, #$02BC, #$02BD, #$02BE, #$02BF),

    (#$0340, #$0341, #$0342, #$0343, #$0344, #$0399, #$0346, #$0347,
    #$0348, #$0349, #$034A, #$034B, #$034C, #$034D, #$034E, #$034F,
    #$0350, #$0351, #$0352, #$0353, #$0354, #$0355, #$0356, #$0357,
    #$0358, #$0359, #$035A, #$035B, #$035C, #$035D, #$035E, #$035F,
    #$0360, #$0361, #$0362, #$0363, #$0364, #$0365, #$0366, #$0367,
    #$0368, #$0369, #$036A, #$036B, #$036C, #$036D, #$036E, #$036F,
    #$0370, #$0371, #$0372, #$0373, #$0374, #$0375, #$0376, #$0377,
    #$0378, #$0379, #$037A, #$037B, #$037C, #$037D, #$037E, #$037F),

    (#$0380, #$0381, #$0382, #$0383, #$0384, #$0385, #$0386, #$0387,
    #$0388, #$0389, #$038A, #$038B, #$038C, #$038D, #$038E, #$038F,
    #$0390, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397,
    #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F,
    #$03A0, #$03A1, #$03A2, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7,
    #$03A8, #$03A9, #$03AA, #$03AB, #$0386, #$0388, #$0389, #$038A,
    #$03B0, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397,
    #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F),

    (#$03A0, #$03A1, #$03A3, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7,
    #$03A8, #$03A9, #$03AA, #$03AB, #$038C, #$038E, #$038F, #$03CF,
    #$0392, #$0398, #$03D2, #$03D3, #$03D4, #$03A6, #$03A0, #$03D7,
    #$03D8, #$03D8, #$03DA, #$03DA, #$03DC, #$03DC, #$03DE, #$03DE,
    #$03E0, #$03E0, #$03E2, #$03E2, #$03E4, #$03E4, #$03E6, #$03E6,
    #$03E8, #$03E8, #$03EA, #$03EA, #$03EC, #$03EC, #$03EE, #$03EE,
    #$039A, #$03A1, #$03F9, #$03F3, #$03F4, #$0395, #$03F6, #$03F7,
    #$03F7, #$03F9, #$03FA, #$03FA, #$03FC, #$03FD, #$03FE, #$03FF),

    (#$0400, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407,
    #$0408, #$0409, #$040A, #$040B, #$040C, #$040D, #$040E, #$040F,
    #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417,
    #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F,
    #$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427,
    #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
    #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417,
    #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F),

    (#$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427,
    #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
    #$0400, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407,
    #$0408, #$0409, #$040A, #$040B, #$040C, #$040D, #$040E, #$040F,
    #$0460, #$0460, #$0462, #$0462, #$0464, #$0464, #$0466, #$0466,
    #$0468, #$0468, #$046A, #$046A, #$046C, #$046C, #$046E, #$046E,
    #$0470, #$0470, #$0472, #$0472, #$0474, #$0474, #$0476, #$0476,
    #$0478, #$0478, #$047A, #$047A, #$047C, #$047C, #$047E, #$047E),

    (#$0480, #$0480, #$0482, #$0483, #$0484, #$0485, #$0486, #$0487,
    #$0488, #$0489, #$048A, #$048A, #$048C, #$048C, #$048E, #$048E,
    #$0490, #$0490, #$0492, #$0492, #$0494, #$0494, #$0496, #$0496,
    #$0498, #$0498, #$049A, #$049A, #$049C, #$049C, #$049E, #$049E,
    #$04A0, #$04A0, #$04A2, #$04A2, #$04A4, #$04A4, #$04A6, #$04A6,
    #$04A8, #$04A8, #$04AA, #$04AA, #$04AC, #$04AC, #$04AE, #$04AE,
    #$04B0, #$04B0, #$04B2, #$04B2, #$04B4, #$04B4, #$04B6, #$04B6,
    #$04B8, #$04B8, #$04BA, #$04BA, #$04BC, #$04BC, #$04BE, #$04BE),

    (#$04C0, #$04C1, #$04C1, #$04C3, #$04C3, #$04C5, #$04C5, #$04C7,
    #$04C7, #$04C9, #$04C9, #$04CB, #$04CB, #$04CD, #$04CD, #$04CF,
    #$04D0, #$04D0, #$04D2, #$04D2, #$04D4, #$04D4, #$04D6, #$04D6,
    #$04D8, #$04D8, #$04DA, #$04DA, #$04DC, #$04DC, #$04DE, #$04DE,
    #$04E0, #$04E0, #$04E2, #$04E2, #$04E4, #$04E4, #$04E6, #$04E6,
    #$04E8, #$04E8, #$04EA, #$04EA, #$04EC, #$04EC, #$04EE, #$04EE,
    #$04F0, #$04F0, #$04F2, #$04F2, #$04F4, #$04F4, #$04F6, #$04F7,
    #$04F8, #$04F8, #$04FA, #$04FB, #$04FC, #$04FD, #$04FE, #$04FF),

    (#$0500, #$0500, #$0502, #$0502, #$0504, #$0504, #$0506, #$0506,
    #$0508, #$0508, #$050A, #$050A, #$050C, #$050C, #$050E, #$050E,
    #$0510, #$0511, #$0512, #$0513, #$0514, #$0515, #$0516, #$0517,
    #$0518, #$0519, #$051A, #$051B, #$051C, #$051D, #$051E, #$051F,
    #$0520, #$0521, #$0522, #$0523, #$0524, #$0525, #$0526, #$0527,
    #$0528, #$0529, #$052A, #$052B, #$052C, #$052D, #$052E, #$052F,
    #$0530, #$0531, #$0532, #$0533, #$0534, #$0535, #$0536, #$0537,
    #$0538, #$0539, #$053A, #$053B, #$053C, #$053D, #$053E, #$053F),

    (#$0540, #$0541, #$0542, #$0543, #$0544, #$0545, #$0546, #$0547,
    #$0548, #$0549, #$054A, #$054B, #$054C, #$054D, #$054E, #$054F,
    #$0550, #$0551, #$0552, #$0553, #$0554, #$0555, #$0556, #$0557,
    #$0558, #$0559, #$055A, #$055B, #$055C, #$055D, #$055E, #$055F,
    #$0560, #$0531, #$0532, #$0533, #$0534, #$0535, #$0536, #$0537,
    #$0538, #$0539, #$053A, #$053B, #$053C, #$053D, #$053E, #$053F,
    #$0540, #$0541, #$0542, #$0543, #$0544, #$0545, #$0546, #$0547,
    #$0548, #$0549, #$054A, #$054B, #$054C, #$054D, #$054E, #$054F),

    (#$0550, #$0551, #$0552, #$0553, #$0554, #$0555, #$0556, #$0587,
    #$0588, #$0589, #$058A, #$058B, #$058C, #$058D, #$058E, #$058F,
    #$0590, #$0591, #$0592, #$0593, #$0594, #$0595, #$0596, #$0597,
    #$0598, #$0599, #$059A, #$059B, #$059C, #$059D, #$059E, #$059F,
    #$05A0, #$05A1, #$05A2, #$05A3, #$05A4, #$05A5, #$05A6, #$05A7,
    #$05A8, #$05A9, #$05AA, #$05AB, #$05AC, #$05AD, #$05AE, #$05AF,
    #$05B0, #$05B1, #$05B2, #$05B3, #$05B4, #$05B5, #$05B6, #$05B7,
    #$05B8, #$05B9, #$05BA, #$05BB, #$05BC, #$05BD, #$05BE, #$05BF),

    (#$1E00, #$1E00, #$1E02, #$1E02, #$1E04, #$1E04, #$1E06, #$1E06,
    #$1E08, #$1E08, #$1E0A, #$1E0A, #$1E0C, #$1E0C, #$1E0E, #$1E0E,
    #$1E10, #$1E10, #$1E12, #$1E12, #$1E14, #$1E14, #$1E16, #$1E16,
    #$1E18, #$1E18, #$1E1A, #$1E1A, #$1E1C, #$1E1C, #$1E1E, #$1E1E,
    #$1E20, #$1E20, #$1E22, #$1E22, #$1E24, #$1E24, #$1E26, #$1E26,
    #$1E28, #$1E28, #$1E2A, #$1E2A, #$1E2C, #$1E2C, #$1E2E, #$1E2E,
    #$1E30, #$1E30, #$1E32, #$1E32, #$1E34, #$1E34, #$1E36, #$1E36,
    #$1E38, #$1E38, #$1E3A, #$1E3A, #$1E3C, #$1E3C, #$1E3E, #$1E3E),

    (#$1E40, #$1E40, #$1E42, #$1E42, #$1E44, #$1E44, #$1E46, #$1E46,
    #$1E48, #$1E48, #$1E4A, #$1E4A, #$1E4C, #$1E4C, #$1E4E, #$1E4E,
    #$1E50, #$1E50, #$1E52, #$1E52, #$1E54, #$1E54, #$1E56, #$1E56,
    #$1E58, #$1E58, #$1E5A, #$1E5A, #$1E5C, #$1E5C, #$1E5E, #$1E5E,
    #$1E60, #$1E60, #$1E62, #$1E62, #$1E64, #$1E64, #$1E66, #$1E66,
    #$1E68, #$1E68, #$1E6A, #$1E6A, #$1E6C, #$1E6C, #$1E6E, #$1E6E,
    #$1E70, #$1E70, #$1E72, #$1E72, #$1E74, #$1E74, #$1E76, #$1E76,
    #$1E78, #$1E78, #$1E7A, #$1E7A, #$1E7C, #$1E7C, #$1E7E, #$1E7E),

    (#$1E80, #$1E80, #$1E82, #$1E82, #$1E84, #$1E84, #$1E86, #$1E86,
    #$1E88, #$1E88, #$1E8A, #$1E8A, #$1E8C, #$1E8C, #$1E8E, #$1E8E,
    #$1E90, #$1E90, #$1E92, #$1E92, #$1E94, #$1E94, #$1E96, #$1E97,
    #$1E98, #$1E99, #$1E9A, #$1E60, #$1E9C, #$1E9D, #$1E9E, #$1E9F,
    #$1EA0, #$1EA0, #$1EA2, #$1EA2, #$1EA4, #$1EA4, #$1EA6, #$1EA6,
    #$1EA8, #$1EA8, #$1EAA, #$1EAA, #$1EAC, #$1EAC, #$1EAE, #$1EAE,
    #$1EB0, #$1EB0, #$1EB2, #$1EB2, #$1EB4, #$1EB4, #$1EB6, #$1EB6,
    #$1EB8, #$1EB8, #$1EBA, #$1EBA, #$1EBC, #$1EBC, #$1EBE, #$1EBE),

    (#$1EC0, #$1EC0, #$1EC2, #$1EC2, #$1EC4, #$1EC4, #$1EC6, #$1EC6,
    #$1EC8, #$1EC8, #$1ECA, #$1ECA, #$1ECC, #$1ECC, #$1ECE, #$1ECE,
    #$1ED0, #$1ED0, #$1ED2, #$1ED2, #$1ED4, #$1ED4, #$1ED6, #$1ED6,
    #$1ED8, #$1ED8, #$1EDA, #$1EDA, #$1EDC, #$1EDC, #$1EDE, #$1EDE,
    #$1EE0, #$1EE0, #$1EE2, #$1EE2, #$1EE4, #$1EE4, #$1EE6, #$1EE6,
    #$1EE8, #$1EE8, #$1EEA, #$1EEA, #$1EEC, #$1EEC, #$1EEE, #$1EEE,
    #$1EF0, #$1EF0, #$1EF2, #$1EF2, #$1EF4, #$1EF4, #$1EF6, #$1EF6,
    #$1EF8, #$1EF8, #$1EFA, #$1EFB, #$1EFC, #$1EFD, #$1EFE, #$1EFF),

    (#$1F08, #$1F09, #$1F0A, #$1F0B, #$1F0C, #$1F0D, #$1F0E, #$1F0F,
    #$1F08, #$1F09, #$1F0A, #$1F0B, #$1F0C, #$1F0D, #$1F0E, #$1F0F,
    #$1F18, #$1F19, #$1F1A, #$1F1B, #$1F1C, #$1F1D, #$1F16, #$1F17,
    #$1F18, #$1F19, #$1F1A, #$1F1B, #$1F1C, #$1F1D, #$1F1E, #$1F1F,
    #$1F28, #$1F29, #$1F2A, #$1F2B, #$1F2C, #$1F2D, #$1F2E, #$1F2F,
    #$1F28, #$1F29, #$1F2A, #$1F2B, #$1F2C, #$1F2D, #$1F2E, #$1F2F,
    #$1F38, #$1F39, #$1F3A, #$1F3B, #$1F3C, #$1F3D, #$1F3E, #$1F3F,
    #$1F38, #$1F39, #$1F3A, #$1F3B, #$1F3C, #$1F3D, #$1F3E, #$1F3F),

    (#$1F48, #$1F49, #$1F4A, #$1F4B, #$1F4C, #$1F4D, #$1F46, #$1F47,
    #$1F48, #$1F49, #$1F4A, #$1F4B, #$1F4C, #$1F4D, #$1F4E, #$1F4F,
    #$1F50, #$1F59, #$1F52, #$1F5B, #$1F54, #$1F5D, #$1F56, #$1F5F,
    #$1F58, #$1F59, #$1F5A, #$1F5B, #$1F5C, #$1F5D, #$1F5E, #$1F5F,
    #$1F68, #$1F69, #$1F6A, #$1F6B, #$1F6C, #$1F6D, #$1F6E, #$1F6F,
    #$1F68, #$1F69, #$1F6A, #$1F6B, #$1F6C, #$1F6D, #$1F6E, #$1F6F,
    #$1FBA, #$1FBB, #$1FC8, #$1FC9, #$1FCA, #$1FCB, #$1FDA, #$1FDB,
    #$1FF8, #$1FF9, #$1FEA, #$1FEB, #$1FFA, #$1FFB, #$1F7E, #$1F7F),

    (#$1F88, #$1F89, #$1F8A, #$1F8B, #$1F8C, #$1F8D, #$1F8E, #$1F8F,
    #$1F88, #$1F89, #$1F8A, #$1F8B, #$1F8C, #$1F8D, #$1F8E, #$1F8F,
    #$1F98, #$1F99, #$1F9A, #$1F9B, #$1F9C, #$1F9D, #$1F9E, #$1F9F,
    #$1F98, #$1F99, #$1F9A, #$1F9B, #$1F9C, #$1F9D, #$1F9E, #$1F9F,
    #$1FA8, #$1FA9, #$1FAA, #$1FAB, #$1FAC, #$1FAD, #$1FAE, #$1FAF,
    #$1FA8, #$1FA9, #$1FAA, #$1FAB, #$1FAC, #$1FAD, #$1FAE, #$1FAF,
    #$1FB8, #$1FB9, #$1FB2, #$1FBC, #$1FB4, #$1FB5, #$1FB6, #$1FB7,
    #$1FB8, #$1FB9, #$1FBA, #$1FBB, #$1FBC, #$1FBD, #$0399, #$1FBF),

    (#$1FC0, #$1FC1, #$1FC2, #$1FCC, #$1FC4, #$1FC5, #$1FC6, #$1FC7,
    #$1FC8, #$1FC9, #$1FCA, #$1FCB, #$1FCC, #$1FCD, #$1FCE, #$1FCF,
    #$1FD8, #$1FD9, #$1FD2, #$1FD3, #$1FD4, #$1FD5, #$1FD6, #$1FD7,
    #$1FD8, #$1FD9, #$1FDA, #$1FDB, #$1FDC, #$1FDD, #$1FDE, #$1FDF,
    #$1FE8, #$1FE9, #$1FE2, #$1FE3, #$1FE4, #$1FEC, #$1FE6, #$1FE7,
    #$1FE8, #$1FE9, #$1FEA, #$1FEB, #$1FEC, #$1FED, #$1FEE, #$1FEF,
    #$1FF0, #$1FF1, #$1FF2, #$1FFC, #$1FF4, #$1FF5, #$1FF6, #$1FF7,
    #$1FF8, #$1FF9, #$1FFA, #$1FFB, #$1FFC, #$1FFD, #$1FFE, #$1FFF),

    (#$2140, #$2141, #$2142, #$2143, #$2144, #$2145, #$2146, #$2147,
    #$2148, #$2149, #$214A, #$214B, #$214C, #$214D, #$214E, #$214F,
    #$2150, #$2151, #$2152, #$2153, #$2154, #$2155, #$2156, #$2157,
    #$2158, #$2159, #$215A, #$215B, #$215C, #$215D, #$215E, #$215F,
    #$2160, #$2161, #$2162, #$2163, #$2164, #$2165, #$2166, #$2167,
    #$2168, #$2169, #$216A, #$216B, #$216C, #$216D, #$216E, #$216F,
    #$2160, #$2161, #$2162, #$2163, #$2164, #$2165, #$2166, #$2167,
    #$2168, #$2169, #$216A, #$216B, #$216C, #$216D, #$216E, #$216F),

    (#$24C0, #$24C1, #$24C2, #$24C3, #$24C4, #$24C5, #$24C6, #$24C7,
    #$24C8, #$24C9, #$24CA, #$24CB, #$24CC, #$24CD, #$24CE, #$24CF,
    #$24B6, #$24B7, #$24B8, #$24B9, #$24BA, #$24BB, #$24BC, #$24BD,
    #$24BE, #$24BF, #$24C0, #$24C1, #$24C2, #$24C3, #$24C4, #$24C5,
    #$24C6, #$24C7, #$24C8, #$24C9, #$24CA, #$24CB, #$24CC, #$24CD,
    #$24CE, #$24CF, #$24EA, #$24EB, #$24EC, #$24ED, #$24EE, #$24EF,
    #$24F0, #$24F1, #$24F2, #$24F3, #$24F4, #$24F5, #$24F6, #$24F7,
    #$24F8, #$24F9, #$24FA, #$24FB, #$24FC, #$24FD, #$24FE, #$24FF),

    (#$FF40, #$FF21, #$FF22, #$FF23, #$FF24, #$FF25, #$FF26, #$FF27,
    #$FF28, #$FF29, #$FF2A, #$FF2B, #$FF2C, #$FF2D, #$FF2E, #$FF2F,
    #$FF30, #$FF31, #$FF32, #$FF33, #$FF34, #$FF35, #$FF36, #$FF37,
    #$FF38, #$FF39, #$FF3A, #$FF5B, #$FF5C, #$FF5D, #$FF5E, #$FF5F,
    #$FF60, #$FF61, #$FF62, #$FF63, #$FF64, #$FF65, #$FF66, #$FF67,
    #$FF68, #$FF69, #$FF6A, #$FF6B, #$FF6C, #$FF6D, #$FF6E, #$FF6F,
    #$FF70, #$FF71, #$FF72, #$FF73, #$FF74, #$FF75, #$FF76, #$FF77,
    #$FF78, #$FF79, #$FF7A, #$FF7B, #$FF7C, #$FF7D, #$FF7E, #$FF7F));
  CHAR_TO_UPPER_SIZE = 64;
var
  i: Integer;
begin
  Result := Char;
  i := CHAR_TO_UPPER_1[Ord(Result) div CHAR_TO_UPPER_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      Result := CHAR_TO_UPPER_2[i, Ord(Result) and (CHAR_TO_UPPER_SIZE - 1)];
    end;
end;

function CharToLowerW(const Char: WideChar): WideChar;
const
  CHAR_TO_LOWER_1: array[$0000..$03FF] of Byte = (
    $00, $01, $00, $02, $03, $04, $05, $06,
    $07, $00, $00, $00, $00, $00, $08, $09,
    $0A, $0B, $0C, $0D, $0E, $0F, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $10, $11, $12, $13, $14, $15, $16, $17,

    $00, $00, $00, $00, $18, $19, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $1A, $1B, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $1C, $00, $00, $00);
  CHAR_TO_LOWER_2: array[$0000..$001B, $0000..$003F] of WideChar = (

    (#$0040, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067,
    #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
    #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077,
    #$0078, #$0079, #$007A, #$005B, #$005C, #$005D, #$005E, #$005F,
    #$0060, #$0061, #$0062, #$0063, #$0064, #$0065, #$0066, #$0067,
    #$0068, #$0069, #$006A, #$006B, #$006C, #$006D, #$006E, #$006F,
    #$0070, #$0071, #$0072, #$0073, #$0074, #$0075, #$0076, #$0077,
    #$0078, #$0079, #$007A, #$007B, #$007C, #$007D, #$007E, #$007F),

    (#$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7,
    #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
    #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00D7,
    #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00DF,
    #$00E0, #$00E1, #$00E2, #$00E3, #$00E4, #$00E5, #$00E6, #$00E7,
    #$00E8, #$00E9, #$00EA, #$00EB, #$00EC, #$00ED, #$00EE, #$00EF,
    #$00F0, #$00F1, #$00F2, #$00F3, #$00F4, #$00F5, #$00F6, #$00F7,
    #$00F8, #$00F9, #$00FA, #$00FB, #$00FC, #$00FD, #$00FE, #$00FF),

    (#$0101, #$0101, #$0103, #$0103, #$0105, #$0105, #$0107, #$0107,
    #$0109, #$0109, #$010B, #$010B, #$010D, #$010D, #$010F, #$010F,
    #$0111, #$0111, #$0113, #$0113, #$0115, #$0115, #$0117, #$0117,
    #$0119, #$0119, #$011B, #$011B, #$011D, #$011D, #$011F, #$011F,
    #$0121, #$0121, #$0123, #$0123, #$0125, #$0125, #$0127, #$0127,
    #$0129, #$0129, #$012B, #$012B, #$012D, #$012D, #$012F, #$012F,
    #$0069, #$0131, #$0133, #$0133, #$0135, #$0135, #$0137, #$0137,
    #$0138, #$013A, #$013A, #$013C, #$013C, #$013E, #$013E, #$0140),

    (#$0140, #$0142, #$0142, #$0144, #$0144, #$0146, #$0146, #$0148,
    #$0148, #$0149, #$014B, #$014B, #$014D, #$014D, #$014F, #$014F,
    #$0151, #$0151, #$0153, #$0153, #$0155, #$0155, #$0157, #$0157,
    #$0159, #$0159, #$015B, #$015B, #$015D, #$015D, #$015F, #$015F,
    #$0161, #$0161, #$0163, #$0163, #$0165, #$0165, #$0167, #$0167,
    #$0169, #$0169, #$016B, #$016B, #$016D, #$016D, #$016F, #$016F,
    #$0171, #$0171, #$0173, #$0173, #$0175, #$0175, #$0177, #$0177,
    #$00FF, #$017A, #$017A, #$017C, #$017C, #$017E, #$017E, #$017F),

    (#$0180, #$0253, #$0183, #$0183, #$0185, #$0185, #$0254, #$0188,
    #$0188, #$0256, #$0257, #$018C, #$018C, #$018D, #$01DD, #$0259,
    #$025B, #$0192, #$0192, #$0260, #$0263, #$0195, #$0269, #$0268,
    #$0199, #$0199, #$019A, #$019B, #$026F, #$0272, #$019E, #$0275,
    #$01A1, #$01A1, #$01A3, #$01A3, #$01A5, #$01A5, #$0280, #$01A8,
    #$01A8, #$0283, #$01AA, #$01AB, #$01AD, #$01AD, #$0288, #$01B0,
    #$01B0, #$028A, #$028B, #$01B4, #$01B4, #$01B6, #$01B6, #$0292,
    #$01B9, #$01B9, #$01BA, #$01BB, #$01BD, #$01BD, #$01BE, #$01BF),

    (#$01C0, #$01C1, #$01C2, #$01C3, #$01C6, #$01C6, #$01C6, #$01C9,
    #$01C9, #$01C9, #$01CC, #$01CC, #$01CC, #$01CE, #$01CE, #$01D0,
    #$01D0, #$01D2, #$01D2, #$01D4, #$01D4, #$01D6, #$01D6, #$01D8,
    #$01D8, #$01DA, #$01DA, #$01DC, #$01DC, #$01DD, #$01DF, #$01DF,
    #$01E1, #$01E1, #$01E3, #$01E3, #$01E5, #$01E5, #$01E7, #$01E7,
    #$01E9, #$01E9, #$01EB, #$01EB, #$01ED, #$01ED, #$01EF, #$01EF,
    #$01F0, #$01F3, #$01F3, #$01F3, #$01F5, #$01F5, #$0195, #$01BF,
    #$01F9, #$01F9, #$01FB, #$01FB, #$01FD, #$01FD, #$01FF, #$01FF),

    (#$0201, #$0201, #$0203, #$0203, #$0205, #$0205, #$0207, #$0207,
    #$0209, #$0209, #$020B, #$020B, #$020D, #$020D, #$020F, #$020F,
    #$0211, #$0211, #$0213, #$0213, #$0215, #$0215, #$0217, #$0217,
    #$0219, #$0219, #$021B, #$021B, #$021D, #$021D, #$021F, #$021F,
    #$019E, #$0221, #$0223, #$0223, #$0225, #$0225, #$0227, #$0227,
    #$0229, #$0229, #$022B, #$022B, #$022D, #$022D, #$022F, #$022F,
    #$0231, #$0231, #$0233, #$0233, #$0234, #$0235, #$0236, #$0237,
    #$0238, #$0239, #$023A, #$023B, #$023C, #$023D, #$023E, #$023F),

    (#$0380, #$0381, #$0382, #$0383, #$0384, #$0385, #$03AC, #$0387,
    #$03AD, #$03AE, #$03AF, #$038B, #$03CC, #$038D, #$03CD, #$03CE,
    #$0390, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7,
    #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF,
    #$03C0, #$03C1, #$03A2, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7,
    #$03C8, #$03C9, #$03CA, #$03CB, #$03AC, #$03AD, #$03AE, #$03AF,
    #$03B0, #$03B1, #$03B2, #$03B3, #$03B4, #$03B5, #$03B6, #$03B7,
    #$03B8, #$03B9, #$03BA, #$03BB, #$03BC, #$03BD, #$03BE, #$03BF),

    (#$03C0, #$03C1, #$03C2, #$03C3, #$03C4, #$03C5, #$03C6, #$03C7,
    #$03C8, #$03C9, #$03CA, #$03CB, #$03CC, #$03CD, #$03CE, #$03CF,
    #$03D0, #$03D1, #$03D2, #$03D3, #$03D4, #$03D5, #$03D6, #$03D7,
    #$03D9, #$03D9, #$03DB, #$03DB, #$03DD, #$03DD, #$03DF, #$03DF,
    #$03E1, #$03E1, #$03E3, #$03E3, #$03E5, #$03E5, #$03E7, #$03E7,
    #$03E9, #$03E9, #$03EB, #$03EB, #$03ED, #$03ED, #$03EF, #$03EF,
    #$03F0, #$03F1, #$03F2, #$03F3, #$03B8, #$03F5, #$03F6, #$03F8,
    #$03F8, #$03F2, #$03FB, #$03FB, #$03FC, #$03FD, #$03FE, #$03FF),

    (#$0450, #$0451, #$0452, #$0453, #$0454, #$0455, #$0456, #$0457,
    #$0458, #$0459, #$045A, #$045B, #$045C, #$045D, #$045E, #$045F,
    #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437,
    #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F,
    #$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447,
    #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F,
    #$0430, #$0431, #$0432, #$0433, #$0434, #$0435, #$0436, #$0437,
    #$0438, #$0439, #$043A, #$043B, #$043C, #$043D, #$043E, #$043F),

    (#$0440, #$0441, #$0442, #$0443, #$0444, #$0445, #$0446, #$0447,
    #$0448, #$0449, #$044A, #$044B, #$044C, #$044D, #$044E, #$044F,
    #$0450, #$0451, #$0452, #$0453, #$0454, #$0455, #$0456, #$0457,
    #$0458, #$0459, #$045A, #$045B, #$045C, #$045D, #$045E, #$045F,
    #$0461, #$0461, #$0463, #$0463, #$0465, #$0465, #$0467, #$0467,
    #$0469, #$0469, #$046B, #$046B, #$046D, #$046D, #$046F, #$046F,
    #$0471, #$0471, #$0473, #$0473, #$0475, #$0475, #$0477, #$0477,
    #$0479, #$0479, #$047B, #$047B, #$047D, #$047D, #$047F, #$047F),

    (#$0481, #$0481, #$0482, #$0483, #$0484, #$0485, #$0486, #$0487,
    #$0488, #$0489, #$048B, #$048B, #$048D, #$048D, #$048F, #$048F,
    #$0491, #$0491, #$0493, #$0493, #$0495, #$0495, #$0497, #$0497,
    #$0499, #$0499, #$049B, #$049B, #$049D, #$049D, #$049F, #$049F,
    #$04A1, #$04A1, #$04A3, #$04A3, #$04A5, #$04A5, #$04A7, #$04A7,
    #$04A9, #$04A9, #$04AB, #$04AB, #$04AD, #$04AD, #$04AF, #$04AF,
    #$04B1, #$04B1, #$04B3, #$04B3, #$04B5, #$04B5, #$04B7, #$04B7,
    #$04B9, #$04B9, #$04BB, #$04BB, #$04BD, #$04BD, #$04BF, #$04BF),

    (#$04C0, #$04C2, #$04C2, #$04C4, #$04C4, #$04C6, #$04C6, #$04C8,
    #$04C8, #$04CA, #$04CA, #$04CC, #$04CC, #$04CE, #$04CE, #$04CF,
    #$04D1, #$04D1, #$04D3, #$04D3, #$04D5, #$04D5, #$04D7, #$04D7,
    #$04D9, #$04D9, #$04DB, #$04DB, #$04DD, #$04DD, #$04DF, #$04DF,
    #$04E1, #$04E1, #$04E3, #$04E3, #$04E5, #$04E5, #$04E7, #$04E7,
    #$04E9, #$04E9, #$04EB, #$04EB, #$04ED, #$04ED, #$04EF, #$04EF,
    #$04F1, #$04F1, #$04F3, #$04F3, #$04F5, #$04F5, #$04F6, #$04F7,
    #$04F9, #$04F9, #$04FA, #$04FB, #$04FC, #$04FD, #$04FE, #$04FF),

    (#$0501, #$0501, #$0503, #$0503, #$0505, #$0505, #$0507, #$0507,
    #$0509, #$0509, #$050B, #$050B, #$050D, #$050D, #$050F, #$050F,
    #$0510, #$0511, #$0512, #$0513, #$0514, #$0515, #$0516, #$0517,
    #$0518, #$0519, #$051A, #$051B, #$051C, #$051D, #$051E, #$051F,
    #$0520, #$0521, #$0522, #$0523, #$0524, #$0525, #$0526, #$0527,
    #$0528, #$0529, #$052A, #$052B, #$052C, #$052D, #$052E, #$052F,
    #$0530, #$0561, #$0562, #$0563, #$0564, #$0565, #$0566, #$0567,
    #$0568, #$0569, #$056A, #$056B, #$056C, #$056D, #$056E, #$056F),

    (#$0570, #$0571, #$0572, #$0573, #$0574, #$0575, #$0576, #$0577,
    #$0578, #$0579, #$057A, #$057B, #$057C, #$057D, #$057E, #$057F,
    #$0580, #$0581, #$0582, #$0583, #$0584, #$0585, #$0586, #$0557,
    #$0558, #$0559, #$055A, #$055B, #$055C, #$055D, #$055E, #$055F,
    #$0560, #$0561, #$0562, #$0563, #$0564, #$0565, #$0566, #$0567,
    #$0568, #$0569, #$056A, #$056B, #$056C, #$056D, #$056E, #$056F,
    #$0570, #$0571, #$0572, #$0573, #$0574, #$0575, #$0576, #$0577,
    #$0578, #$0579, #$057A, #$057B, #$057C, #$057D, #$057E, #$057F),

    (#$1E01, #$1E01, #$1E03, #$1E03, #$1E05, #$1E05, #$1E07, #$1E07,
    #$1E09, #$1E09, #$1E0B, #$1E0B, #$1E0D, #$1E0D, #$1E0F, #$1E0F,
    #$1E11, #$1E11, #$1E13, #$1E13, #$1E15, #$1E15, #$1E17, #$1E17,
    #$1E19, #$1E19, #$1E1B, #$1E1B, #$1E1D, #$1E1D, #$1E1F, #$1E1F,
    #$1E21, #$1E21, #$1E23, #$1E23, #$1E25, #$1E25, #$1E27, #$1E27,
    #$1E29, #$1E29, #$1E2B, #$1E2B, #$1E2D, #$1E2D, #$1E2F, #$1E2F,
    #$1E31, #$1E31, #$1E33, #$1E33, #$1E35, #$1E35, #$1E37, #$1E37,
    #$1E39, #$1E39, #$1E3B, #$1E3B, #$1E3D, #$1E3D, #$1E3F, #$1E3F),

    (#$1E41, #$1E41, #$1E43, #$1E43, #$1E45, #$1E45, #$1E47, #$1E47,
    #$1E49, #$1E49, #$1E4B, #$1E4B, #$1E4D, #$1E4D, #$1E4F, #$1E4F,
    #$1E51, #$1E51, #$1E53, #$1E53, #$1E55, #$1E55, #$1E57, #$1E57,
    #$1E59, #$1E59, #$1E5B, #$1E5B, #$1E5D, #$1E5D, #$1E5F, #$1E5F,
    #$1E61, #$1E61, #$1E63, #$1E63, #$1E65, #$1E65, #$1E67, #$1E67,
    #$1E69, #$1E69, #$1E6B, #$1E6B, #$1E6D, #$1E6D, #$1E6F, #$1E6F,
    #$1E71, #$1E71, #$1E73, #$1E73, #$1E75, #$1E75, #$1E77, #$1E77,
    #$1E79, #$1E79, #$1E7B, #$1E7B, #$1E7D, #$1E7D, #$1E7F, #$1E7F),

    (#$1E81, #$1E81, #$1E83, #$1E83, #$1E85, #$1E85, #$1E87, #$1E87,
    #$1E89, #$1E89, #$1E8B, #$1E8B, #$1E8D, #$1E8D, #$1E8F, #$1E8F,
    #$1E91, #$1E91, #$1E93, #$1E93, #$1E95, #$1E95, #$1E96, #$1E97,
    #$1E98, #$1E99, #$1E9A, #$1E9B, #$1E9C, #$1E9D, #$1E9E, #$1E9F,
    #$1EA1, #$1EA1, #$1EA3, #$1EA3, #$1EA5, #$1EA5, #$1EA7, #$1EA7,
    #$1EA9, #$1EA9, #$1EAB, #$1EAB, #$1EAD, #$1EAD, #$1EAF, #$1EAF,
    #$1EB1, #$1EB1, #$1EB3, #$1EB3, #$1EB5, #$1EB5, #$1EB7, #$1EB7,
    #$1EB9, #$1EB9, #$1EBB, #$1EBB, #$1EBD, #$1EBD, #$1EBF, #$1EBF),

    (#$1EC1, #$1EC1, #$1EC3, #$1EC3, #$1EC5, #$1EC5, #$1EC7, #$1EC7,
    #$1EC9, #$1EC9, #$1ECB, #$1ECB, #$1ECD, #$1ECD, #$1ECF, #$1ECF,
    #$1ED1, #$1ED1, #$1ED3, #$1ED3, #$1ED5, #$1ED5, #$1ED7, #$1ED7,
    #$1ED9, #$1ED9, #$1EDB, #$1EDB, #$1EDD, #$1EDD, #$1EDF, #$1EDF,
    #$1EE1, #$1EE1, #$1EE3, #$1EE3, #$1EE5, #$1EE5, #$1EE7, #$1EE7,
    #$1EE9, #$1EE9, #$1EEB, #$1EEB, #$1EED, #$1EED, #$1EEF, #$1EEF,
    #$1EF1, #$1EF1, #$1EF3, #$1EF3, #$1EF5, #$1EF5, #$1EF7, #$1EF7,
    #$1EF9, #$1EF9, #$1EFA, #$1EFB, #$1EFC, #$1EFD, #$1EFE, #$1EFF),

    (#$1F00, #$1F01, #$1F02, #$1F03, #$1F04, #$1F05, #$1F06, #$1F07,
    #$1F00, #$1F01, #$1F02, #$1F03, #$1F04, #$1F05, #$1F06, #$1F07,
    #$1F10, #$1F11, #$1F12, #$1F13, #$1F14, #$1F15, #$1F16, #$1F17,
    #$1F10, #$1F11, #$1F12, #$1F13, #$1F14, #$1F15, #$1F1E, #$1F1F,
    #$1F20, #$1F21, #$1F22, #$1F23, #$1F24, #$1F25, #$1F26, #$1F27,
    #$1F20, #$1F21, #$1F22, #$1F23, #$1F24, #$1F25, #$1F26, #$1F27,
    #$1F30, #$1F31, #$1F32, #$1F33, #$1F34, #$1F35, #$1F36, #$1F37,
    #$1F30, #$1F31, #$1F32, #$1F33, #$1F34, #$1F35, #$1F36, #$1F37),

    (#$1F40, #$1F41, #$1F42, #$1F43, #$1F44, #$1F45, #$1F46, #$1F47,
    #$1F40, #$1F41, #$1F42, #$1F43, #$1F44, #$1F45, #$1F4E, #$1F4F,
    #$1F50, #$1F51, #$1F52, #$1F53, #$1F54, #$1F55, #$1F56, #$1F57,
    #$1F58, #$1F51, #$1F5A, #$1F53, #$1F5C, #$1F55, #$1F5E, #$1F57,
    #$1F60, #$1F61, #$1F62, #$1F63, #$1F64, #$1F65, #$1F66, #$1F67,
    #$1F60, #$1F61, #$1F62, #$1F63, #$1F64, #$1F65, #$1F66, #$1F67,
    #$1F70, #$1F71, #$1F72, #$1F73, #$1F74, #$1F75, #$1F76, #$1F77,
    #$1F78, #$1F79, #$1F7A, #$1F7B, #$1F7C, #$1F7D, #$1F7E, #$1F7F),

    (#$1F80, #$1F81, #$1F82, #$1F83, #$1F84, #$1F85, #$1F86, #$1F87,
    #$1F80, #$1F81, #$1F82, #$1F83, #$1F84, #$1F85, #$1F86, #$1F87,
    #$1F90, #$1F91, #$1F92, #$1F93, #$1F94, #$1F95, #$1F96, #$1F97,
    #$1F90, #$1F91, #$1F92, #$1F93, #$1F94, #$1F95, #$1F96, #$1F97,
    #$1FA0, #$1FA1, #$1FA2, #$1FA3, #$1FA4, #$1FA5, #$1FA6, #$1FA7,
    #$1FA0, #$1FA1, #$1FA2, #$1FA3, #$1FA4, #$1FA5, #$1FA6, #$1FA7,
    #$1FB0, #$1FB1, #$1FB2, #$1FB3, #$1FB4, #$1FB5, #$1FB6, #$1FB7,
    #$1FB0, #$1FB1, #$1F70, #$1F71, #$1FB3, #$1FBD, #$1FBE, #$1FBF),

    (#$1FC0, #$1FC1, #$1FC2, #$1FC3, #$1FC4, #$1FC5, #$1FC6, #$1FC7,
    #$1F72, #$1F73, #$1F74, #$1F75, #$1FC3, #$1FCD, #$1FCE, #$1FCF,
    #$1FD0, #$1FD1, #$1FD2, #$1FD3, #$1FD4, #$1FD5, #$1FD6, #$1FD7,
    #$1FD0, #$1FD1, #$1F76, #$1F77, #$1FDC, #$1FDD, #$1FDE, #$1FDF,
    #$1FE0, #$1FE1, #$1FE2, #$1FE3, #$1FE4, #$1FE5, #$1FE6, #$1FE7,
    #$1FE0, #$1FE1, #$1F7A, #$1F7B, #$1FE5, #$1FED, #$1FEE, #$1FEF,
    #$1FF0, #$1FF1, #$1FF2, #$1FF3, #$1FF4, #$1FF5, #$1FF6, #$1FF7,
    #$1F78, #$1F79, #$1F7C, #$1F7D, #$1FF3, #$1FFD, #$1FFE, #$1FFF),

    (#$2100, #$2101, #$2102, #$2103, #$2104, #$2105, #$2106, #$2107,
    #$2108, #$2109, #$210A, #$210B, #$210C, #$210D, #$210E, #$210F,
    #$2110, #$2111, #$2112, #$2113, #$2114, #$2115, #$2116, #$2117,
    #$2118, #$2119, #$211A, #$211B, #$211C, #$211D, #$211E, #$211F,
    #$2120, #$2121, #$2122, #$2123, #$2124, #$2125, #$03C9, #$2127,
    #$2128, #$2129, #$006B, #$00E5, #$212C, #$212D, #$212E, #$212F,
    #$2130, #$2131, #$2132, #$2133, #$2134, #$2135, #$2136, #$2137,
    #$2138, #$2139, #$213A, #$213B, #$213C, #$213D, #$213E, #$213F),

    (#$2140, #$2141, #$2142, #$2143, #$2144, #$2145, #$2146, #$2147,
    #$2148, #$2149, #$214A, #$214B, #$214C, #$214D, #$214E, #$214F,
    #$2150, #$2151, #$2152, #$2153, #$2154, #$2155, #$2156, #$2157,
    #$2158, #$2159, #$215A, #$215B, #$215C, #$215D, #$215E, #$215F,
    #$2170, #$2171, #$2172, #$2173, #$2174, #$2175, #$2176, #$2177,
    #$2178, #$2179, #$217A, #$217B, #$217C, #$217D, #$217E, #$217F,
    #$2170, #$2171, #$2172, #$2173, #$2174, #$2175, #$2176, #$2177,
    #$2178, #$2179, #$217A, #$217B, #$217C, #$217D, #$217E, #$217F),

    (#$2480, #$2481, #$2482, #$2483, #$2484, #$2485, #$2486, #$2487,
    #$2488, #$2489, #$248A, #$248B, #$248C, #$248D, #$248E, #$248F,
    #$2490, #$2491, #$2492, #$2493, #$2494, #$2495, #$2496, #$2497,
    #$2498, #$2499, #$249A, #$249B, #$249C, #$249D, #$249E, #$249F,
    #$24A0, #$24A1, #$24A2, #$24A3, #$24A4, #$24A5, #$24A6, #$24A7,
    #$24A8, #$24A9, #$24AA, #$24AB, #$24AC, #$24AD, #$24AE, #$24AF,
    #$24B0, #$24B1, #$24B2, #$24B3, #$24B4, #$24B5, #$24D0, #$24D1,
    #$24D2, #$24D3, #$24D4, #$24D5, #$24D6, #$24D7, #$24D8, #$24D9),

    (#$24DA, #$24DB, #$24DC, #$24DD, #$24DE, #$24DF, #$24E0, #$24E1,
    #$24E2, #$24E3, #$24E4, #$24E5, #$24E6, #$24E7, #$24E8, #$24E9,
    #$24D0, #$24D1, #$24D2, #$24D3, #$24D4, #$24D5, #$24D6, #$24D7,
    #$24D8, #$24D9, #$24DA, #$24DB, #$24DC, #$24DD, #$24DE, #$24DF,
    #$24E0, #$24E1, #$24E2, #$24E3, #$24E4, #$24E5, #$24E6, #$24E7,
    #$24E8, #$24E9, #$24EA, #$24EB, #$24EC, #$24ED, #$24EE, #$24EF,
    #$24F0, #$24F1, #$24F2, #$24F3, #$24F4, #$24F5, #$24F6, #$24F7,
    #$24F8, #$24F9, #$24FA, #$24FB, #$24FC, #$24FD, #$24FE, #$24FF),

    (#$FF00, #$FF01, #$FF02, #$FF03, #$FF04, #$FF05, #$FF06, #$FF07,
    #$FF08, #$FF09, #$FF0A, #$FF0B, #$FF0C, #$FF0D, #$FF0E, #$FF0F,
    #$FF10, #$FF11, #$FF12, #$FF13, #$FF14, #$FF15, #$FF16, #$FF17,
    #$FF18, #$FF19, #$FF1A, #$FF1B, #$FF1C, #$FF1D, #$FF1E, #$FF1F,
    #$FF20, #$FF41, #$FF42, #$FF43, #$FF44, #$FF45, #$FF46, #$FF47,
    #$FF48, #$FF49, #$FF4A, #$FF4B, #$FF4C, #$FF4D, #$FF4E, #$FF4F,
    #$FF50, #$FF51, #$FF52, #$FF53, #$FF54, #$FF55, #$FF56, #$FF57,
    #$FF58, #$FF59, #$FF5A, #$FF3B, #$FF3C, #$FF3D, #$FF3E, #$FF3F));
  CHAR_TO_LOWER_SIZE = 64;
var
  i: Integer;
begin
  Result := Char;
  i := CHAR_TO_LOWER_1[Ord(Result) div CHAR_TO_LOWER_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      Result := CHAR_TO_LOWER_2[i, Ord(Result) and (CHAR_TO_LOWER_SIZE - 1)];
    end;
end;

function CharToTitleW(const Char: WideChar): WideChar;
const
  CHAR_TO_TITLE_1: array[$0000..$03FF] of Byte = (
    $00, $01, $02, $03, $04, $05, $06, $07,
    $08, $09, $0A, $00, $00, $0B, $0C, $0D,
    $0E, $0F, $10, $11, $12, $13, $14, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $15, $16, $17, $18, $19, $1A, $1B, $1C,

    $00, $00, $00, $00, $00, $1D, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $1E, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,

    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $00, $00, $00,
    $00, $00, $00, $00, $00, $1F, $00, $00);
  CHAR_TO_TITLE_2: array[$0000..$001E, $0000..$003F] of WideChar = (

    (#$0040, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047,
    #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
    #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057,
    #$0058, #$0059, #$005A, #$005B, #$005C, #$005D, #$005E, #$005F,
    #$0060, #$0041, #$0042, #$0043, #$0044, #$0045, #$0046, #$0047,
    #$0048, #$0049, #$004A, #$004B, #$004C, #$004D, #$004E, #$004F,
    #$0050, #$0051, #$0052, #$0053, #$0054, #$0055, #$0056, #$0057,
    #$0058, #$0059, #$005A, #$007B, #$007C, #$007D, #$007E, #$007F),

    (#$0080, #$0081, #$0082, #$0083, #$0084, #$0085, #$0086, #$0087,
    #$0088, #$0089, #$008A, #$008B, #$008C, #$008D, #$008E, #$008F,
    #$0090, #$0091, #$0092, #$0093, #$0094, #$0095, #$0096, #$0097,
    #$0098, #$0099, #$009A, #$009B, #$009C, #$009D, #$009E, #$009F,
    #$00A0, #$00A1, #$00A2, #$00A3, #$00A4, #$00A5, #$00A6, #$00A7,
    #$00A8, #$00A9, #$00AA, #$00AB, #$00AC, #$00AD, #$00AE, #$00AF,
    #$00B0, #$00B1, #$00B2, #$00B3, #$00B4, #$039C, #$00B6, #$00B7,
    #$00B8, #$00B9, #$00BA, #$00BB, #$00BC, #$00BD, #$00BE, #$00BF),

    (#$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7,
    #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
    #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00D7,
    #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$00DF,
    #$00C0, #$00C1, #$00C2, #$00C3, #$00C4, #$00C5, #$00C6, #$00C7,
    #$00C8, #$00C9, #$00CA, #$00CB, #$00CC, #$00CD, #$00CE, #$00CF,
    #$00D0, #$00D1, #$00D2, #$00D3, #$00D4, #$00D5, #$00D6, #$00F7,
    #$00D8, #$00D9, #$00DA, #$00DB, #$00DC, #$00DD, #$00DE, #$0178),

    (#$0100, #$0100, #$0102, #$0102, #$0104, #$0104, #$0106, #$0106,
    #$0108, #$0108, #$010A, #$010A, #$010C, #$010C, #$010E, #$010E,
    #$0110, #$0110, #$0112, #$0112, #$0114, #$0114, #$0116, #$0116,
    #$0118, #$0118, #$011A, #$011A, #$011C, #$011C, #$011E, #$011E,
    #$0120, #$0120, #$0122, #$0122, #$0124, #$0124, #$0126, #$0126,
    #$0128, #$0128, #$012A, #$012A, #$012C, #$012C, #$012E, #$012E,
    #$0130, #$0049, #$0132, #$0132, #$0134, #$0134, #$0136, #$0136,
    #$0138, #$0139, #$0139, #$013B, #$013B, #$013D, #$013D, #$013F),

    (#$013F, #$0141, #$0141, #$0143, #$0143, #$0145, #$0145, #$0147,
    #$0147, #$0149, #$014A, #$014A, #$014C, #$014C, #$014E, #$014E,
    #$0150, #$0150, #$0152, #$0152, #$0154, #$0154, #$0156, #$0156,
    #$0158, #$0158, #$015A, #$015A, #$015C, #$015C, #$015E, #$015E,
    #$0160, #$0160, #$0162, #$0162, #$0164, #$0164, #$0166, #$0166,
    #$0168, #$0168, #$016A, #$016A, #$016C, #$016C, #$016E, #$016E,
    #$0170, #$0170, #$0172, #$0172, #$0174, #$0174, #$0176, #$0176,
    #$0178, #$0179, #$0179, #$017B, #$017B, #$017D, #$017D, #$0053),

    (#$0180, #$0181, #$0182, #$0182, #$0184, #$0184, #$0186, #$0187,
    #$0187, #$0189, #$018A, #$018B, #$018B, #$018D, #$018E, #$018F,
    #$0190, #$0191, #$0191, #$0193, #$0194, #$01F6, #$0196, #$0197,
    #$0198, #$0198, #$019A, #$019B, #$019C, #$019D, #$0220, #$019F,
    #$01A0, #$01A0, #$01A2, #$01A2, #$01A4, #$01A4, #$01A6, #$01A7,
    #$01A7, #$01A9, #$01AA, #$01AB, #$01AC, #$01AC, #$01AE, #$01AF,
    #$01AF, #$01B1, #$01B2, #$01B3, #$01B3, #$01B5, #$01B5, #$01B7,
    #$01B8, #$01B8, #$01BA, #$01BB, #$01BC, #$01BC, #$01BE, #$01F7),

    (#$01C0, #$01C1, #$01C2, #$01C3, #$01C5, #$01C5, #$01C5, #$01C8,
    #$01C8, #$01C8, #$01CB, #$01CB, #$01CB, #$01CD, #$01CD, #$01CF,
    #$01CF, #$01D1, #$01D1, #$01D3, #$01D3, #$01D5, #$01D5, #$01D7,
    #$01D7, #$01D9, #$01D9, #$01DB, #$01DB, #$018E, #$01DE, #$01DE,
    #$01E0, #$01E0, #$01E2, #$01E2, #$01E4, #$01E4, #$01E6, #$01E6,
    #$01E8, #$01E8, #$01EA, #$01EA, #$01EC, #$01EC, #$01EE, #$01EE,
    #$01F0, #$01F2, #$01F2, #$01F2, #$01F4, #$01F4, #$01F6, #$01F7,
    #$01F8, #$01F8, #$01FA, #$01FA, #$01FC, #$01FC, #$01FE, #$01FE),

    (#$0200, #$0200, #$0202, #$0202, #$0204, #$0204, #$0206, #$0206,
    #$0208, #$0208, #$020A, #$020A, #$020C, #$020C, #$020E, #$020E,
    #$0210, #$0210, #$0212, #$0212, #$0214, #$0214, #$0216, #$0216,
    #$0218, #$0218, #$021A, #$021A, #$021C, #$021C, #$021E, #$021E,
    #$0220, #$0221, #$0222, #$0222, #$0224, #$0224, #$0226, #$0226,
    #$0228, #$0228, #$022A, #$022A, #$022C, #$022C, #$022E, #$022E,
    #$0230, #$0230, #$0232, #$0232, #$0234, #$0235, #$0236, #$0237,
    #$0238, #$0239, #$023A, #$023B, #$023C, #$023D, #$023E, #$023F),

    (#$0240, #$0241, #$0242, #$0243, #$0244, #$0245, #$0246, #$0247,
    #$0248, #$0249, #$024A, #$024B, #$024C, #$024D, #$024E, #$024F,
    #$0250, #$0251, #$0252, #$0181, #$0186, #$0255, #$0189, #$018A,
    #$0258, #$018F, #$025A, #$0190, #$025C, #$025D, #$025E, #$025F,
    #$0193, #$0261, #$0262, #$0194, #$0264, #$0265, #$0266, #$0267,
    #$0197, #$0196, #$026A, #$026B, #$026C, #$026D, #$026E, #$019C,
    #$0270, #$0271, #$019D, #$0273, #$0274, #$019F, #$0276, #$0277,
    #$0278, #$0279, #$027A, #$027B, #$027C, #$027D, #$027E, #$027F),

    (#$01A6, #$0281, #$0282, #$01A9, #$0284, #$0285, #$0286, #$0287,
    #$01AE, #$0289, #$01B1, #$01B2, #$028C, #$028D, #$028E, #$028F,
    #$0290, #$0291, #$01B7, #$0293, #$0294, #$0295, #$0296, #$0297,
    #$0298, #$0299, #$029A, #$029B, #$029C, #$029D, #$029E, #$029F,
    #$02A0, #$02A1, #$02A2, #$02A3, #$02A4, #$02A5, #$02A6, #$02A7,
    #$02A8, #$02A9, #$02AA, #$02AB, #$02AC, #$02AD, #$02AE, #$02AF,
    #$02B0, #$02B1, #$02B2, #$02B3, #$02B4, #$02B5, #$02B6, #$02B7,
    #$02B8, #$02B9, #$02BA, #$02BB, #$02BC, #$02BD, #$02BE, #$02BF),

    (#$0340, #$0341, #$0342, #$0343, #$0344, #$0399, #$0346, #$0347,
    #$0348, #$0349, #$034A, #$034B, #$034C, #$034D, #$034E, #$034F,
    #$0350, #$0351, #$0352, #$0353, #$0354, #$0355, #$0356, #$0357,
    #$0358, #$0359, #$035A, #$035B, #$035C, #$035D, #$035E, #$035F,
    #$0360, #$0361, #$0362, #$0363, #$0364, #$0365, #$0366, #$0367,
    #$0368, #$0369, #$036A, #$036B, #$036C, #$036D, #$036E, #$036F,
    #$0370, #$0371, #$0372, #$0373, #$0374, #$0375, #$0376, #$0377,
    #$0378, #$0379, #$037A, #$037B, #$037C, #$037D, #$037E, #$037F),

    (#$0380, #$0381, #$0382, #$0383, #$0384, #$0385, #$0386, #$0387,
    #$0388, #$0389, #$038A, #$038B, #$038C, #$038D, #$038E, #$038F,
    #$0390, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397,
    #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F,
    #$03A0, #$03A1, #$03A2, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7,
    #$03A8, #$03A9, #$03AA, #$03AB, #$0386, #$0388, #$0389, #$038A,
    #$03B0, #$0391, #$0392, #$0393, #$0394, #$0395, #$0396, #$0397,
    #$0398, #$0399, #$039A, #$039B, #$039C, #$039D, #$039E, #$039F),

    (#$03A0, #$03A1, #$03A3, #$03A3, #$03A4, #$03A5, #$03A6, #$03A7,
    #$03A8, #$03A9, #$03AA, #$03AB, #$038C, #$038E, #$038F, #$03CF,
    #$0392, #$0398, #$03D2, #$03D3, #$03D4, #$03A6, #$03A0, #$03D7,
    #$03D8, #$03D8, #$03DA, #$03DA, #$03DC, #$03DC, #$03DE, #$03DE,
    #$03E0, #$03E0, #$03E2, #$03E2, #$03E4, #$03E4, #$03E6, #$03E6,
    #$03E8, #$03E8, #$03EA, #$03EA, #$03EC, #$03EC, #$03EE, #$03EE,
    #$039A, #$03A1, #$03F9, #$03F3, #$03F4, #$0395, #$03F6, #$03F7,
    #$03F7, #$03F9, #$03FA, #$03FA, #$03FC, #$03FD, #$03FE, #$03FF),

    (#$0400, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407,
    #$0408, #$0409, #$040A, #$040B, #$040C, #$040D, #$040E, #$040F,
    #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417,
    #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F,
    #$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427,
    #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
    #$0410, #$0411, #$0412, #$0413, #$0414, #$0415, #$0416, #$0417,
    #$0418, #$0419, #$041A, #$041B, #$041C, #$041D, #$041E, #$041F),

    (#$0420, #$0421, #$0422, #$0423, #$0424, #$0425, #$0426, #$0427,
    #$0428, #$0429, #$042A, #$042B, #$042C, #$042D, #$042E, #$042F,
    #$0400, #$0401, #$0402, #$0403, #$0404, #$0405, #$0406, #$0407,
    #$0408, #$0409, #$040A, #$040B, #$040C, #$040D, #$040E, #$040F,
    #$0460, #$0460, #$0462, #$0462, #$0464, #$0464, #$0466, #$0466,
    #$0468, #$0468, #$046A, #$046A, #$046C, #$046C, #$046E, #$046E,
    #$0470, #$0470, #$0472, #$0472, #$0474, #$0474, #$0476, #$0476,
    #$0478, #$0478, #$047A, #$047A, #$047C, #$047C, #$047E, #$047E),

    (#$0480, #$0480, #$0482, #$0483, #$0484, #$0485, #$0486, #$0487,
    #$0488, #$0489, #$048A, #$048A, #$048C, #$048C, #$048E, #$048E,
    #$0490, #$0490, #$0492, #$0492, #$0494, #$0494, #$0496, #$0496,
    #$0498, #$0498, #$049A, #$049A, #$049C, #$049C, #$049E, #$049E,
    #$04A0, #$04A0, #$04A2, #$04A2, #$04A4, #$04A4, #$04A6, #$04A6,
    #$04A8, #$04A8, #$04AA, #$04AA, #$04AC, #$04AC, #$04AE, #$04AE,
    #$04B0, #$04B0, #$04B2, #$04B2, #$04B4, #$04B4, #$04B6, #$04B6,
    #$04B8, #$04B8, #$04BA, #$04BA, #$04BC, #$04BC, #$04BE, #$04BE),

    (#$04C0, #$04C1, #$04C1, #$04C3, #$04C3, #$04C5, #$04C5, #$04C7,
    #$04C7, #$04C9, #$04C9, #$04CB, #$04CB, #$04CD, #$04CD, #$04CF,
    #$04D0, #$04D0, #$04D2, #$04D2, #$04D4, #$04D4, #$04D6, #$04D6,
    #$04D8, #$04D8, #$04DA, #$04DA, #$04DC, #$04DC, #$04DE, #$04DE,
    #$04E0, #$04E0, #$04E2, #$04E2, #$04E4, #$04E4, #$04E6, #$04E6,
    #$04E8, #$04E8, #$04EA, #$04EA, #$04EC, #$04EC, #$04EE, #$04EE,
    #$04F0, #$04F0, #$04F2, #$04F2, #$04F4, #$04F4, #$04F6, #$04F7,
    #$04F8, #$04F8, #$04FA, #$04FB, #$04FC, #$04FD, #$04FE, #$04FF),

    (#$0500, #$0500, #$0502, #$0502, #$0504, #$0504, #$0506, #$0506,
    #$0508, #$0508, #$050A, #$050A, #$050C, #$050C, #$050E, #$050E,
    #$0510, #$0511, #$0512, #$0513, #$0514, #$0515, #$0516, #$0517,
    #$0518, #$0519, #$051A, #$051B, #$051C, #$051D, #$051E, #$051F,
    #$0520, #$0521, #$0522, #$0523, #$0524, #$0525, #$0526, #$0527,
    #$0528, #$0529, #$052A, #$052B, #$052C, #$052D, #$052E, #$052F,
    #$0530, #$0531, #$0532, #$0533, #$0534, #$0535, #$0536, #$0537,
    #$0538, #$0539, #$053A, #$053B, #$053C, #$053D, #$053E, #$053F),

    (#$0540, #$0541, #$0542, #$0543, #$0544, #$0545, #$0546, #$0547,
    #$0548, #$0549, #$054A, #$054B, #$054C, #$054D, #$054E, #$054F,
    #$0550, #$0551, #$0552, #$0553, #$0554, #$0555, #$0556, #$0557,
    #$0558, #$0559, #$055A, #$055B, #$055C, #$055D, #$055E, #$055F,
    #$0560, #$0531, #$0532, #$0533, #$0534, #$0535, #$0536, #$0537,
    #$0538, #$0539, #$053A, #$053B, #$053C, #$053D, #$053E, #$053F,
    #$0540, #$0541, #$0542, #$0543, #$0544, #$0545, #$0546, #$0547,
    #$0548, #$0549, #$054A, #$054B, #$054C, #$054D, #$054E, #$054F),

    (#$0550, #$0551, #$0552, #$0553, #$0554, #$0555, #$0556, #$0587,
    #$0588, #$0589, #$058A, #$058B, #$058C, #$058D, #$058E, #$058F,
    #$0590, #$0591, #$0592, #$0593, #$0594, #$0595, #$0596, #$0597,
    #$0598, #$0599, #$059A, #$059B, #$059C, #$059D, #$059E, #$059F,
    #$05A0, #$05A1, #$05A2, #$05A3, #$05A4, #$05A5, #$05A6, #$05A7,
    #$05A8, #$05A9, #$05AA, #$05AB, #$05AC, #$05AD, #$05AE, #$05AF,
    #$05B0, #$05B1, #$05B2, #$05B3, #$05B4, #$05B5, #$05B6, #$05B7,
    #$05B8, #$05B9, #$05BA, #$05BB, #$05BC, #$05BD, #$05BE, #$05BF),

    (#$1E00, #$1E00, #$1E02, #$1E02, #$1E04, #$1E04, #$1E06, #$1E06,
    #$1E08, #$1E08, #$1E0A, #$1E0A, #$1E0C, #$1E0C, #$1E0E, #$1E0E,
    #$1E10, #$1E10, #$1E12, #$1E12, #$1E14, #$1E14, #$1E16, #$1E16,
    #$1E18, #$1E18, #$1E1A, #$1E1A, #$1E1C, #$1E1C, #$1E1E, #$1E1E,
    #$1E20, #$1E20, #$1E22, #$1E22, #$1E24, #$1E24, #$1E26, #$1E26,
    #$1E28, #$1E28, #$1E2A, #$1E2A, #$1E2C, #$1E2C, #$1E2E, #$1E2E,
    #$1E30, #$1E30, #$1E32, #$1E32, #$1E34, #$1E34, #$1E36, #$1E36,
    #$1E38, #$1E38, #$1E3A, #$1E3A, #$1E3C, #$1E3C, #$1E3E, #$1E3E),

    (#$1E40, #$1E40, #$1E42, #$1E42, #$1E44, #$1E44, #$1E46, #$1E46,
    #$1E48, #$1E48, #$1E4A, #$1E4A, #$1E4C, #$1E4C, #$1E4E, #$1E4E,
    #$1E50, #$1E50, #$1E52, #$1E52, #$1E54, #$1E54, #$1E56, #$1E56,
    #$1E58, #$1E58, #$1E5A, #$1E5A, #$1E5C, #$1E5C, #$1E5E, #$1E5E,
    #$1E60, #$1E60, #$1E62, #$1E62, #$1E64, #$1E64, #$1E66, #$1E66,
    #$1E68, #$1E68, #$1E6A, #$1E6A, #$1E6C, #$1E6C, #$1E6E, #$1E6E,
    #$1E70, #$1E70, #$1E72, #$1E72, #$1E74, #$1E74, #$1E76, #$1E76,
    #$1E78, #$1E78, #$1E7A, #$1E7A, #$1E7C, #$1E7C, #$1E7E, #$1E7E),

    (#$1E80, #$1E80, #$1E82, #$1E82, #$1E84, #$1E84, #$1E86, #$1E86,
    #$1E88, #$1E88, #$1E8A, #$1E8A, #$1E8C, #$1E8C, #$1E8E, #$1E8E,
    #$1E90, #$1E90, #$1E92, #$1E92, #$1E94, #$1E94, #$1E96, #$1E97,
    #$1E98, #$1E99, #$1E9A, #$1E60, #$1E9C, #$1E9D, #$1E9E, #$1E9F,
    #$1EA0, #$1EA0, #$1EA2, #$1EA2, #$1EA4, #$1EA4, #$1EA6, #$1EA6,
    #$1EA8, #$1EA8, #$1EAA, #$1EAA, #$1EAC, #$1EAC, #$1EAE, #$1EAE,
    #$1EB0, #$1EB0, #$1EB2, #$1EB2, #$1EB4, #$1EB4, #$1EB6, #$1EB6,
    #$1EB8, #$1EB8, #$1EBA, #$1EBA, #$1EBC, #$1EBC, #$1EBE, #$1EBE),

    (#$1EC0, #$1EC0, #$1EC2, #$1EC2, #$1EC4, #$1EC4, #$1EC6, #$1EC6,
    #$1EC8, #$1EC8, #$1ECA, #$1ECA, #$1ECC, #$1ECC, #$1ECE, #$1ECE,
    #$1ED0, #$1ED0, #$1ED2, #$1ED2, #$1ED4, #$1ED4, #$1ED6, #$1ED6,
    #$1ED8, #$1ED8, #$1EDA, #$1EDA, #$1EDC, #$1EDC, #$1EDE, #$1EDE,
    #$1EE0, #$1EE0, #$1EE2, #$1EE2, #$1EE4, #$1EE4, #$1EE6, #$1EE6,
    #$1EE8, #$1EE8, #$1EEA, #$1EEA, #$1EEC, #$1EEC, #$1EEE, #$1EEE,
    #$1EF0, #$1EF0, #$1EF2, #$1EF2, #$1EF4, #$1EF4, #$1EF6, #$1EF6,
    #$1EF8, #$1EF8, #$1EFA, #$1EFB, #$1EFC, #$1EFD, #$1EFE, #$1EFF),

    (#$1F08, #$1F09, #$1F0A, #$1F0B, #$1F0C, #$1F0D, #$1F0E, #$1F0F,
    #$1F08, #$1F09, #$1F0A, #$1F0B, #$1F0C, #$1F0D, #$1F0E, #$1F0F,
    #$1F18, #$1F19, #$1F1A, #$1F1B, #$1F1C, #$1F1D, #$1F16, #$1F17,
    #$1F18, #$1F19, #$1F1A, #$1F1B, #$1F1C, #$1F1D, #$1F1E, #$1F1F,
    #$1F28, #$1F29, #$1F2A, #$1F2B, #$1F2C, #$1F2D, #$1F2E, #$1F2F,
    #$1F28, #$1F29, #$1F2A, #$1F2B, #$1F2C, #$1F2D, #$1F2E, #$1F2F,
    #$1F38, #$1F39, #$1F3A, #$1F3B, #$1F3C, #$1F3D, #$1F3E, #$1F3F,
    #$1F38, #$1F39, #$1F3A, #$1F3B, #$1F3C, #$1F3D, #$1F3E, #$1F3F),

    (#$1F48, #$1F49, #$1F4A, #$1F4B, #$1F4C, #$1F4D, #$1F46, #$1F47,
    #$1F48, #$1F49, #$1F4A, #$1F4B, #$1F4C, #$1F4D, #$1F4E, #$1F4F,
    #$1F50, #$1F59, #$1F52, #$1F5B, #$1F54, #$1F5D, #$1F56, #$1F5F,
    #$1F58, #$1F59, #$1F5A, #$1F5B, #$1F5C, #$1F5D, #$1F5E, #$1F5F,
    #$1F68, #$1F69, #$1F6A, #$1F6B, #$1F6C, #$1F6D, #$1F6E, #$1F6F,
    #$1F68, #$1F69, #$1F6A, #$1F6B, #$1F6C, #$1F6D, #$1F6E, #$1F6F,
    #$1FBA, #$1FBB, #$1FC8, #$1FC9, #$1FCA, #$1FCB, #$1FDA, #$1FDB,
    #$1FF8, #$1FF9, #$1FEA, #$1FEB, #$1FFA, #$1FFB, #$1F7E, #$1F7F),

    (#$1F88, #$1F89, #$1F8A, #$1F8B, #$1F8C, #$1F8D, #$1F8E, #$1F8F,
    #$1F88, #$1F89, #$1F8A, #$1F8B, #$1F8C, #$1F8D, #$1F8E, #$1F8F,
    #$1F98, #$1F99, #$1F9A, #$1F9B, #$1F9C, #$1F9D, #$1F9E, #$1F9F,
    #$1F98, #$1F99, #$1F9A, #$1F9B, #$1F9C, #$1F9D, #$1F9E, #$1F9F,
    #$1FA8, #$1FA9, #$1FAA, #$1FAB, #$1FAC, #$1FAD, #$1FAE, #$1FAF,
    #$1FA8, #$1FA9, #$1FAA, #$1FAB, #$1FAC, #$1FAD, #$1FAE, #$1FAF,
    #$1FB8, #$1FB9, #$1FB2, #$1FBC, #$1FB4, #$1FB5, #$1FB6, #$1FB7,
    #$1FB8, #$1FB9, #$1FBA, #$1FBB, #$1FBC, #$1FBD, #$0399, #$1FBF),

    (#$1FC0, #$1FC1, #$1FC2, #$1FCC, #$1FC4, #$1FC5, #$1FC6, #$1FC7,
    #$1FC8, #$1FC9, #$1FCA, #$1FCB, #$1FCC, #$1FCD, #$1FCE, #$1FCF,
    #$1FD8, #$1FD9, #$1FD2, #$1FD3, #$1FD4, #$1FD5, #$1FD6, #$1FD7,
    #$1FD8, #$1FD9, #$1FDA, #$1FDB, #$1FDC, #$1FDD, #$1FDE, #$1FDF,
    #$1FE8, #$1FE9, #$1FE2, #$1FE3, #$1FE4, #$1FEC, #$1FE6, #$1FE7,
    #$1FE8, #$1FE9, #$1FEA, #$1FEB, #$1FEC, #$1FED, #$1FEE, #$1FEF,
    #$1FF0, #$1FF1, #$1FF2, #$1FFC, #$1FF4, #$1FF5, #$1FF6, #$1FF7,
    #$1FF8, #$1FF9, #$1FFA, #$1FFB, #$1FFC, #$1FFD, #$1FFE, #$1FFF),

    (#$2140, #$2141, #$2142, #$2143, #$2144, #$2145, #$2146, #$2147,
    #$2148, #$2149, #$214A, #$214B, #$214C, #$214D, #$214E, #$214F,
    #$2150, #$2151, #$2152, #$2153, #$2154, #$2155, #$2156, #$2157,
    #$2158, #$2159, #$215A, #$215B, #$215C, #$215D, #$215E, #$215F,
    #$2160, #$2161, #$2162, #$2163, #$2164, #$2165, #$2166, #$2167,
    #$2168, #$2169, #$216A, #$216B, #$216C, #$216D, #$216E, #$216F,
    #$2160, #$2161, #$2162, #$2163, #$2164, #$2165, #$2166, #$2167,
    #$2168, #$2169, #$216A, #$216B, #$216C, #$216D, #$216E, #$216F),

    (#$24C0, #$24C1, #$24C2, #$24C3, #$24C4, #$24C5, #$24C6, #$24C7,
    #$24C8, #$24C9, #$24CA, #$24CB, #$24CC, #$24CD, #$24CE, #$24CF,
    #$24B6, #$24B7, #$24B8, #$24B9, #$24BA, #$24BB, #$24BC, #$24BD,
    #$24BE, #$24BF, #$24C0, #$24C1, #$24C2, #$24C3, #$24C4, #$24C5,
    #$24C6, #$24C7, #$24C8, #$24C9, #$24CA, #$24CB, #$24CC, #$24CD,
    #$24CE, #$24CF, #$24EA, #$24EB, #$24EC, #$24ED, #$24EE, #$24EF,
    #$24F0, #$24F1, #$24F2, #$24F3, #$24F4, #$24F5, #$24F6, #$24F7,
    #$24F8, #$24F9, #$24FA, #$24FB, #$24FC, #$24FD, #$24FE, #$24FF),

    (#$FF40, #$FF21, #$FF22, #$FF23, #$FF24, #$FF25, #$FF26, #$FF27,
    #$FF28, #$FF29, #$FF2A, #$FF2B, #$FF2C, #$FF2D, #$FF2E, #$FF2F,
    #$FF30, #$FF31, #$FF32, #$FF33, #$FF34, #$FF35, #$FF36, #$FF37,
    #$FF38, #$FF39, #$FF3A, #$FF5B, #$FF5C, #$FF5D, #$FF5E, #$FF5F,
    #$FF60, #$FF61, #$FF62, #$FF63, #$FF64, #$FF65, #$FF66, #$FF67,
    #$FF68, #$FF69, #$FF6A, #$FF6B, #$FF6C, #$FF6D, #$FF6E, #$FF6F,
    #$FF70, #$FF71, #$FF72, #$FF73, #$FF74, #$FF75, #$FF76, #$FF77,
    #$FF78, #$FF79, #$FF7A, #$FF7B, #$FF7C, #$FF7D, #$FF7E, #$FF7F));
  CHAR_TO_TITLE_SIZE = 64;
var
  i: Integer;
begin
  Result := Char;
  i := CHAR_TO_TITLE_1[Ord(Result) div CHAR_TO_TITLE_SIZE];
  if i <> 0 then
    begin
      Dec(i);
      Result := CHAR_TO_TITLE_2[i, Ord(Result) and (CHAR_TO_TITLE_SIZE - 1)];
    end;
end;

constructor TMT19937.Create(const Seed: Cardinal);
begin
  inherited Create;
  init_genrand(Seed);
end;

constructor TMT19937.Create(const Seeds: array of Cardinal);
begin
  inherited Create;
  init_by_array(Seeds);
end;

constructor TMT19937.Create(const Seed: AnsiString);
begin
  inherited Create;
  init_by_StrA(Seed);
end;

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
procedure TMT19937.init_genrand(const Seed: Cardinal);
var
  j: Cardinal;
begin
  FState[0] := Seed ;
  j := 1;
  while j < MT19937_N do
    begin
      FState[j] := (1812433253 * (FState[j - 1] xor (FState[j - 1] shr 30)) + j);

      Inc(j);
    end;
  FLeft := 1;
  FInit := True;
end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
procedure TMT19937.init_by_array(const Seeds: array of Cardinal);
var
  i, j, key_length: Cardinal;
  k: Integer;
begin
  init_genrand(19650218);
  i := 1;
  j := 0;

  key_length := High(Seeds) - Low(Seeds);
  k := key_length;
  if k < MT19937_N then k := MT19937_N;

  while k > 0 do
    begin
      Dec(k);
      FState[i] := (FState[i] xor ((FState[i - 1] xor (FState[i - 1] shr 30)) * 1664525)) + Seeds[j] + j;

      Inc(i);
      Inc(j);
      if i >= MT19937_N then
        begin
          FState[0] := FState[MT19937_N - 1];
          i := 1;
        end;
      if j > key_length then
        j := 0;
    end;

  k := MT19937_N - 1;
  while k > 0 do
    begin
      Dec(k);
      FState[i] := (FState[i] xor ((FState[i - 1] xor (FState[i - 1] shr 30)) * 1566083941)) - i;

      Inc(i);
      if i >= MT19937_N then
        begin
          FState[0] := FState[MT19937_N - 1];
          i := 1;
        end;
    end;

  FState[0] := $80000000;
  FLeft := 1;
  FInit := True;
end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
procedure TMT19937.init_by_StrA(const Seed: AnsiString);
var
  i, j, key_length: Cardinal;
  k: Integer;
begin
  init_genrand(19650218);
  i := 1;
  j := 0;

  key_length := Length(Seed);
  k := key_length;
  if k < MT19937_N then k := MT19937_N;

  while k > 0 do
    begin
      Dec(k);
      FState[i] := (FState[i] xor ((FState[i - 1] xor (FState[i - 1] shr 30)) * 1664525)) + Ord(Seed[j]) + j;

      Inc(i);
      Inc(j);
      if i >= MT19937_N then
        begin
          FState[0] := FState[MT19937_N - 1];
          i := 1;
        end;
      if j > key_length then
        j := 0;
    end;

  k := MT19937_N - 1;
  while k > 0 do
    begin
      Dec(k);
      FState[i] := (FState[i] xor ((FState[i - 1] xor (FState[i - 1] shr 30)) * 1566083941)) - i;

      Inc(i);
      if i >= MT19937_N then
        begin
          FState[0] := FState[MT19937_N - 1];
          i := 1;
        end;
    end;

  FState[0] := $80000000;
  FLeft := 1;
  FInit := True;
end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

procedure TMT19937.next_state;
type
  TMT19937Array = array[-MT19937_N..MT19937_N] of Cardinal;
  PMT19937Array = ^TMT19937Array;
const
  UMASK = $80000000;
  LMASK = $7FFFFFFF;
  MATRIX_A = $9908B0DF;
var
  p: PMT19937Array;
  j, x: Cardinal;
begin
  if not FInit then init_genrand(5489);

  p := PMT19937Array(@FState);
  Dec(Cardinal(p), MT19937_N * 4);

  FLeft := MT19937_N;
  FNext := Pointer(@FState);

  j := MT19937_N - MT19937_M;
  repeat
    x := p^[MT19937_M] xor (((p^[0] and UMASK) or (p^[1] and LMASK)) shr 1);
    if p^[1] and 1 <> 0 then
      p^[0] := x xor MATRIX_A
    else
      p^[0] := x xor 0;
    Inc(Cardinal(p), 4);
    Dec(j);
  until j = 0;

  j := MT19937_M - 1;
  repeat
    x := p^[MT19937_M - MT19937_N] xor (((p^[0] and UMASK) or (p^[1] and LMASK)) shr 1);
    if p^[1] and 1 <> 0 then
      p^[0] := x xor MATRIX_A
    else
      p^[0] := x xor 0;
    Inc(Cardinal(p), 4);
    Dec(j);
  until j = 0;

  x := p^[MT19937_M - MT19937_N] xor (((p^[0] and UMASK) or (p^[1] and LMASK)) shr 1);
  if FState[0] and 1 <> 0 then
    p^[0] := x xor MATRIX_A
  else
    p^[0] := x xor 0;
end;

function TMT19937.genrand_int32: Cardinal;
begin
  Dec(FLeft);
  if FLeft = 0 then next_state;
  Result := FNext^;
  Inc(FNext);
  Result := Result xor (Result shr 11);
  Result := Result xor ((Result shl 7) and $9D2C5680);
  Result := Result xor ((Result shl 15) and $EFC60000);
  Result := Result xor (Result shr 18);
end;

function TMT19937.genrand_int31: Integer;
begin
  Result := genrand_int32 shr 1;
end;

function TMT19937.genrand_int64: Int64;
type
  TInt64Rec = packed record Lo, Hi: Cardinal; end;
begin
  with TInt64Rec(Result) do
    begin
      Lo := genrand_int32;
      Hi := genrand_int32;
    end;
end;

function TMT19937.genrand_int63: Int64;
type
  TInt64Rec = packed record Lo, Hi: Cardinal; end;
begin
  with TInt64Rec(Result) do
    begin
      Lo := genrand_int32;
      Hi := genrand_int32 shr 1;
    end;
end;

function TMT19937.genrand_real1: Double;
begin
  Result := genrand_int32 / 4294967295;
end;

function TMT19937.genrand_real2: Double;
begin
  Result := genrand_int32 / 4294967296;
end;

function TMT19937.genrand_real3: Double;
begin
  Result := (genrand_int32 + 0.5) / 4294967296;
end;

function TMT19937.genrand_res53;
var
  a, b: Cardinal;
begin
  a := genrand_int32 shr 5;
  b := genrand_int32 shr 6;
  Result := (a * 67108864 + b) / 9007199254740992;
end;

const
  ALLOC_INCREMENT = 4096;

destructor TWideStrBuf.Destroy;
begin
  FreeMem(FBuf);
  inherited;
end;

function TWideStrBuf.GetAsStr: WideString;
begin
  SetString(Result, FBuf, FPos - FBuf);
end;

function TWideStrBuf.GetCount: Cardinal;
begin
  Result := FPos - FBuf;
end;

procedure TWideStrBuf.GrowBuffer(const Count: Cardinal);
var
  PosOffset, Size, NewSize: Cardinal;
begin
  PosOffset := FPos - FBuf;
  Size := FEnd - FBuf;
  NewSize := Size + Count + ALLOC_INCREMENT;
  ReallocMem(FBuf, NewSize);
  FPos := FBuf + PosOffset;
  FEnd := FBuf + NewSize;
end;

procedure TWideStrBuf.AddBuf(const Buf: PWideChar; const Count: Cardinal);
begin
  if Buf = nil then Exit;
  if (Cardinal(FEnd) - Cardinal(FPos)) shr 1 <= Count then GrowBuffer(Count);
  Move(Buf^, FPos^, Count * 2);
  Inc(FPos, Count);
end;

procedure TWideStrBuf.AddChar(const c: WideChar);
begin
  if FPos >= FEnd then GrowBuffer(1);
  FPos^ := c;
  Inc(FPos, 1);
end;

procedure TWideStrBuf.AddStr(const s: WideString);
var
  ByteCount: Cardinal;
begin
  ByteCount := Cardinal(s);
  if ByteCount = 0 then Exit;
  ByteCount := PCardinal(ByteCount - 4)^;
  if Cardinal(FEnd) - Cardinal(FPos) <= ByteCount then GrowBuffer(ByteCount shr 1);
  Move(Pointer(s)^, FPos^, ByteCount);
  Inc(Cardinal(FPos), ByteCount);
end;

procedure TWideStrBuf.AddCrLf;
begin
  if FEnd - FPos <= 2 then GrowBuffer(2);
  FPos^ := WC_CR;
  FPos[1] := WC_LF;
  Inc(FPos, 2);
end;

procedure TWideStrBuf.Clear;
begin
  FreeMem(FBuf);
  FBuf := nil;
  FEnd := nil;
  FPos := nil;
end;

function TWideStrBuf.IsEmpty: Boolean;
begin
  Result := FPos = FBuf;
end;

function TWideStrBuf.IsNotEmpty: Boolean;
begin
  Result := FPos > FBuf;
end;

procedure TWideStrBuf.Reset;
begin
  FPos := FBuf;
  FEnd := FBuf;
end;

{$IFDEF MSWINDOWS}
function InternalGetDiskSpaceW(Drive: WideChar; var TotalSpace, FreeSpaceAvailable: Int64): BOOL;
var
  RootPath: array[0..3] of WideChar;
  RootPtr: PWideChar;
begin
  RootPtr := nil;
  if Drive > WC_NULL then
    begin
      RootPath[0] := Drive;
      RootPath[1] := WC_COLON;
      RootPath[2] := WC_PATH_DELIMITER;
      RootPath[3] := WC_NULL;
      RootPtr := RootPath;
    end;
  Result := GetDiskFreeSpaceExW(RootPtr, FreeSpaceAvailable, TotalSpace, nil);
end;
{$ENDIF}

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function InternalPosW(Search: PWideChar; lSearch: Cardinal; const Source: PWideChar; LSource: Cardinal; const StartPos: Cardinal): Cardinal;

label
  Zero, One, Two, Three, Match, Fail, Success;
var
  PSource, pSearchTemp, PSourceTemp: PWideChar;
  lSearchTemp: Cardinal;
  c: WideChar;
begin
  if lSearch > LSource then goto Fail;

  Dec(lSearch);
  Dec(LSource, lSearch);
  if LSource <= StartPos then goto Fail;

  Dec(LSource, StartPos);

  PSource := Source;
  Inc(PSource, StartPos);

  c := Search^;
  Inc(Search);

  while LSource > 0 do
    begin

      while LSource >= 4 do
        begin
          if PSource^ = c then goto Zero;
          if PSource[1] = c then goto One;
          if PSource[2] = c then goto Two;
          if PSource[3] = c then goto Three;
          Inc(PSource, 4);
          Dec(LSource, 4);
        end;

      if LSource = 0 then Break;
      if PSource^ = c then goto Zero;
      if LSource = 1 then Break;
      if PSource[1] = c then goto One;
      if LSource = 2 then Break;
      if PSource[2] = c then goto Two;
      Break;

      Three:
      Inc(PSource, 4);
      Dec(LSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3);
      Dec(LSource, 2);
      goto Match;

      One:
      Inc(PSource, 2);
      Dec(LSource, 1);
      goto Match;

      Zero:
      Inc(PSource);

      Match:

      PSourceTemp := PSource;
      pSearchTemp := Search;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (PCardinal(PSourceTemp)^ = PCardinal(pSearchTemp)^) and
        (PCardinal(@PSourceTemp[2])^ = PCardinal(@pSearchTemp[2])^) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      if lSearchTemp = 0 then goto Success;
      if PSourceTemp^ = pSearchTemp^ then
        begin
          if lSearchTemp = 1 then goto Success;
          if PSourceTemp[1] = pSearchTemp[1] then
            begin
              if lSearchTemp = 2 then goto Success;
              if PSourceTemp[2] = pSearchTemp[2] then
                begin
                  if lSearchTemp = 3 then goto Success;
                end;
            end;
        end;

      Dec(LSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := (Cardinal(PSource) - Cardinal(Source)) shr 1;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function InternalPosIW(Search: PWideChar; lSearch: Cardinal; const Source: PWideChar; LSource: Cardinal; const StartPos: Cardinal): Cardinal;

label
  Zero, One, Two, Three, Match, Fail, Success;
var
  PSource, pSearchTemp, PSourceTemp: PWideChar;
  lSearchTemp: Cardinal;
  c: WideChar;
begin
  if lSearch > LSource then goto Fail;

  Dec(lSearch);
  Dec(LSource, lSearch);
  if LSource <= StartPos then goto Fail;

  Dec(LSource, StartPos);

  PSource := Source;
  Inc(PSource, StartPos);

  c := CharToCaseFoldW(Search^);
  Inc(Search);

  while LSource > 0 do
    begin

      while LSource >= 4 do
        begin
          if CharToCaseFoldW(PSource^) = c then goto Zero;
          if CharToCaseFoldW(PSource[1]) = c then goto One;
          if CharToCaseFoldW(PSource[2]) = c then goto Two;
          if CharToCaseFoldW(PSource[3]) = c then goto Three;
          Inc(PSource, 4);
          Dec(LSource, 4);
        end;

      if LSource = 0 then Break;
      if CharToCaseFoldW(PSource^) = c then goto Zero;
      if LSource = 1 then Break;
      if CharToCaseFoldW(PSource[1]) = c then goto One;
      if LSource = 2 then Break;
      if CharToCaseFoldW(PSource[2]) = c then goto Two;
      Break;

      Three:
      Inc(PSource, 4);
      Dec(LSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3);
      Dec(LSource, 2);
      goto Match;

      One:
      Inc(PSource, 2);
      Dec(LSource, 1);
      goto Match;

      Zero:
      Inc(PSource);

      Match:

      PSourceTemp := PSource;
      pSearchTemp := Search;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^)) and
        (CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1])) and
        (CharToCaseFoldW(PSourceTemp[2]) = CharToCaseFoldW(pSearchTemp[2])) and
        (CharToCaseFoldW(PSourceTemp[3]) = CharToCaseFoldW(pSearchTemp[3])) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      if lSearchTemp = 0 then goto Success;
      if CharToCaseFoldW(PSourceTemp^) = CharToCaseFoldW(pSearchTemp^) then
        begin
          if lSearchTemp = 1 then goto Success;
          if CharToCaseFoldW(PSourceTemp[1]) = CharToCaseFoldW(pSearchTemp[1]) then
            begin
              if lSearchTemp = 2 then goto Success;
              if CharToCaseFoldW(PSourceTemp[2]) = CharToCaseFoldW(pSearchTemp[2]) then
                begin
                  if lSearchTemp = 3 then goto Success;
                end;
            end;
        end;

      Dec(LSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := (Cardinal(PSource) - Cardinal(Source)) shr 1;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

function BitClear(const Bits, BitNo: Integer): Integer;
begin
  Result := Bits and not (1 shl BitNo);
end;

function BitSet(const Bits, BitIndex: Integer): Integer;
begin
  Result := Bits or (1 shl BitIndex);
end;

function BitSetTo(const Bits, BitIndex: Integer; const Value: Boolean): Integer;
begin
  if Value then
    Result := Bits or (1 shl BitIndex)
  else
    Result := Bits and not (1 shl BitIndex);
end;

function BitTest(const Bits, BitIndex: Integer): Boolean;
begin
  Result := (Bits and (1 shl BitIndex)) <> 0;
end;

function BSwap(const Value: Cardinal): Cardinal;
asm
  BSWAP EAX
end;

function BSwap(const Value: Integer): Integer;
asm
  BSWAP EAX
end;

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function BufPosA(const Search: AnsiString; const Buf: PAnsiChar; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): Pointer;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, LSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Buf;
  if PSource = nil then goto Fail;

  lSearch := PCardinal(pSearch - 4)^;
  LSource := BufCharCount;

  if lSearch > LSource then goto Fail;
  Dec(lSearch);
  Dec(LSource, lSearch);

  if StartPos >= LSource then goto Fail;
  Dec(LSource, StartPos);
  Inc(PSource, StartPos);

  c := pSearch^;
  Inc(pSearch);

  while LSource > 0 do
    begin

      while LSource >= 4 do
        begin
          if (PSource^ = c) then goto Zero;
          if (PSource[1] = c) then goto One;
          if (PSource[2] = c) then goto Two;
          if (PSource[3] = c) then goto Three;
          Inc(PSource, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[1] = c) then goto One;
            if (PSource[2] = c) then goto Two;
          end;
        2:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[1] = c) then goto One;
          end;
        1:
          begin
            if (PSource^ = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4);
      Dec(LSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3);
      Dec(LSource, 2);
      goto Match;

      One:
      Inc(PSource, 2);
      Dec(LSource, 1);
      goto Match;

      Zero:
      Inc(PSource);

      Match:

      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and (PCardinal(PSourceTemp)^ = PCardinal(pSearchTemp)^) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if PSourceTemp^ = pSearchTemp^ then goto Success;
        2: if PWord(PSourceTemp)^ = PWord(pSearchTemp)^ then goto Success;
        3: if (PWord(PSourceTemp)^ = PWord(pSearchTemp)^) and (PSourceTemp[2] = pSearchTemp[2]) then goto Success;
      end;

      Dec(LSource);
    end;

  Fail:
  Result := nil;
  Exit;

  Success:
  Result := PSource - 1;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function BufPosIA(const Search: AnsiString; const Buf: Pointer; const BufCharCount: Cardinal; const StartPos: Cardinal = 0): Pointer;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, LSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Buf;
  if PSource = nil then goto Fail;

  lSearch := PCardinal(pSearch - 4)^;
  LSource := BufCharCount;

  if lSearch > LSource then goto Fail;
  Dec(lSearch);
  Dec(LSource, lSearch);

  if StartPos >= LSource then goto Fail;
  Dec(LSource, StartPos);
  Inc(PSource, StartPos);

  c := ANSI_UPPER_CHAR_TABLE[pSearch^];
  Inc(pSearch);

  while LSource > 0 do
    begin

      while LSource >= 4 do
        begin
          if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
          if (ANSI_UPPER_CHAR_TABLE[PSource[2]] = c) then goto Two;
          if (ANSI_UPPER_CHAR_TABLE[PSource[3]] = c) then goto Three;
          Inc(PSource, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
            if (ANSI_UPPER_CHAR_TABLE[PSource[2]] = c) then goto Two;
          end;
        2:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
          end;
        1:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4);
      Dec(LSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3);
      Dec(LSource, 2);
      goto Match;

      One:
      Inc(PSource, 2);
      Dec(LSource, 1);
      goto Match;

      Zero:
      Inc(PSource);

      Match:

      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[3]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[3]]) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^] then
            goto Success;
        2: if (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
          (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) then
            goto Success;
        3: if (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
          (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
            (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) then
            goto Success;
      end;

      Dec(LSource);
    end;

  Fail:
  Result := nil;
  Exit;

  Success:
  Result := PSource - 1;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

function BufPosW(const ASearch: WideString; const ABuffer: PWideChar; const ABufferCharCount: Cardinal; const AStartPos: Cardinal = 0): PWideChar;
begin
  if (Pointer(ASearch) <> nil) and (ABuffer <> nil) then
    begin
      Result := Pointer(InternalPosW(
        Pointer(ASearch), PCardinal(Cardinal(ASearch) - 4)^ shr 1,
        ABuffer, ABufferCharCount,
        AStartPos));
      if Result <> nil then
        Result := ABuffer + (Cardinal(Result) - 1);
    end
  else
    Result := nil;
end;

function BufPosIW(const ASearch: WideString; const ABuffer: PWideChar; const ABufferCharCount: Cardinal; const AStartPos: Cardinal = 0): PWideChar;
begin
  if (Pointer(ASearch) <> nil) and (ABuffer <> nil) then
    begin
      Result := Pointer(InternalPosIW(
        Pointer(ASearch), PCardinal(Cardinal(ASearch) - 4)^ shr 1,
        ABuffer, ABufferCharCount,
        AStartPos));
      if Result <> nil then
        Result := ABuffer + (Cardinal(Result) - 1);
    end
  else
    Result := nil;
end;

function BufSame(const Buf1, Buf2: Pointer; const BufByteCount: Cardinal): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l: Cardinal;
begin
  p1 := Buf1;
  p2 := Buf2;
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l := BufByteCount;

  while l >= 4 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function BufSameIA(const Buf1, Buf2: Pointer; const BufCharCount: Cardinal): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l: Cardinal;
begin
  p1 := Buf1;
  p2 := Buf2;
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l := BufCharCount;
  while l >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
        (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
          (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Fail; end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto Fail;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function BufPosCharsA(const Buf: PAnsiChar; const BufCharCount: Cardinal; const Search: TAnsiCharSet; const Start: Cardinal = 0): Integer;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Buf;
  if (p = nil) or (Start > BufCharCount) then goto Fail;

  Inc(p, Start);
  l := BufCharCount - Start;

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[1] in Search then goto One;
      if p[2] in Search then goto Two;
      if p[3] in Search then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
        if (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := -1;
  Exit;

  Zero:
  Result := Integer(p) - Integer(Buf);
  Exit;

  One:
  Result := Integer(p) - Integer(Buf) + 1;
  Exit;

  Two:
  Result := Integer(p) - Integer(Buf) + 2;
  Exit;

  Three:
  Result := Integer(p) - Integer(Buf) + 3;
end;

function BufStrSameA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; const s: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l2: Cardinal;
begin
  if (Buffer = nil) or (Pointer(s) = nil) then goto Fail;

  l2 := PCardinal(Cardinal(Pointer(s)) - 4)^;

  if AnsiCharCount <> l2 then goto Fail;

  p1 := Buffer;
  p2 := Pointer(s);

  while l2 >= 4 do
    begin
      if (p1^ <> p2^) then goto Fail;
      if (p1[1] <> p2[1]) then goto Fail;
      if (p1[2] <> p2[2]) then goto Fail;
      if (p1[3] <> p2[3]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l2, 4);
    end;

  case l2 of
    3:
      begin
        if (p1^ <> p2^) then goto Fail;
        if (p1[1] <> p2[1]) then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) then goto Fail;
        if (p1[1] <> p2[1]) then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function BufStrSameIA(const Buffer: PAnsiChar; const AnsiCharCount: Cardinal; const s: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l2: Cardinal;
begin
  if (Buffer = nil) or (Pointer(s) = nil) then goto Fail;

  l2 := PCardinal(Cardinal(s) - 4)^;

  if AnsiCharCount <> l2 then goto Fail;

  p1 := Buffer;
  p2 := Pointer(s);

  while l2 >= 4 do
    begin
      if (p1^ <> p2^) and (p1^ <> ANSI_REVERSE_CHAR_TABLE[p2^]) then goto Fail;
      if (p1[1] <> p2[1]) and (p1[1] <> ANSI_REVERSE_CHAR_TABLE[p2[1]]) then goto Fail;
      if (p1[2] <> p2[2]) and (p1[2] <> ANSI_REVERSE_CHAR_TABLE[p2[2]]) then goto Fail;
      if (p1[3] <> p2[3]) and (p1[3] <> ANSI_REVERSE_CHAR_TABLE[p2[3]]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l2, 4);
    end;

  case l2 of
    3:
      begin
        if (p1^ <> p2^) and (p1^ <> ANSI_REVERSE_CHAR_TABLE[p2^]) then goto Fail;
        if (p1[1] <> p2[1]) and (p1[1] <> ANSI_REVERSE_CHAR_TABLE[p2[1]]) then goto Fail;
        if (p1[2] <> p2[2]) and (p1[2] <> ANSI_REVERSE_CHAR_TABLE[p2[2]]) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) and (p1^ <> ANSI_REVERSE_CHAR_TABLE[p2^]) then goto Fail;
        if (p1[1] <> p2[1]) and (p1[1] <> ANSI_REVERSE_CHAR_TABLE[p2[1]]) then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) and (p1^ <> ANSI_REVERSE_CHAR_TABLE[p2^]) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function BufStrSameW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: WideString): Boolean;
label
  Fail;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Buffer;
  l1 := WideCharCount;

  p2 := Pointer(w);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^ shr 1;

  if l1 <> l2 then goto Fail;

  while l1 >= 2 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 2);
      Inc(p2, 2);
      Dec(l1, 2);
    end;

  if (l1 = 1) and (p1^ <> p2^) then goto Fail;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function BufStrSameIW(const Buffer: PWideChar; const WideCharCount: Cardinal; const w: WideString): Boolean;
label
  Fail;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Buffer;
  l1 := WideCharCount;

  p2 := Pointer(w);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^ shr 1;

  if l1 <> l2 then goto Fail;

  while l1 >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      end;
  end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function ChangeFileExtW(const FileName, Extension: WideString): WideString;
label
  NoExtension;
var
  p: PWideChar;
  i, l: Cardinal;
begin
  p := Pointer(FileName);
  if p <> nil then
    begin
      l := PCardinal(p - 2)^ shr 1;
      if l > 0 then
        begin
          i := l;
          Inc(p, i);
          repeat
            Dec(i);
            Dec(p);
            if p^ = WC_FULL_STOP then Break;
            if i = 0 then goto NoExtension;
            if p^ = WC_PATH_DELIMITER then goto NoExtension;
            if p^ = WC_DRIVE_DELIMITER then goto NoExtension;
          until False;
          Result := Copy(FileName, 1, i) + Extension;
          Exit;
        end;
    end;

  NoExtension:
  Result := FileName + Extension;
end;

function CharDecomposeCanonicalStrW(const Char: WideChar): WideString;
var
  p: PCharDecompositionW;
begin
  if CharIsHangulW(Char) then
    Result := CharDecomposeHangulW(Char)
  else
    begin
      p := CharDecomposeCanonicalW(Char);
      if p <> nil then
        SetString(Result, PWideChar(@p^.Data), p^.Count)
      else
        Result := Char;
    end;
end;

function CharDecomposeCompatibleStrW(const Char: WideChar): WideString;
var
  p: PCharDecompositionW;
begin
  if CharIsHangulW(Char) then
    Result := CharDecomposeHangulW(Char)
  else
    begin
      p := CharDecomposeCompatibleW(Char);
      if p <> nil then
        SetString(Result, PWideChar(@p^.Data), p^.Count)
      else
        Result := Char;
    end;
end;

procedure ConCatBufA(const Buffer: Pointer; const AnsiCharCount: Cardinal; var d: AnsiString; var InUse: Cardinal);
var
  PAnsiCharS, PAnsiCharD: PAnsiChar;
  lS, lD, NewInUse: Cardinal;
begin
  PAnsiCharS := Buffer;
  if PAnsiCharS = nil then Exit;

  lS := AnsiCharCount;
  if lS = 0 then Exit;

  PAnsiCharD := Pointer(d);
  lD := Cardinal(PAnsiCharD);
  if lD <> 0 then lD := PCardinal(lD - 4)^;

  NewInUse := InUse + lS;

  if NewInUse > lD then
    begin
      SetLength(d, (NewInUse + (NewInUse shr 1) + 3) and $FFFFFFFC);
      PAnsiCharD := Pointer(d);
    end;

  Inc(PAnsiCharD, InUse);
  while lS >= 4 do
    begin
      Cardinal(Pointer(PAnsiCharD)^) := Cardinal(Pointer(PAnsiCharS)^);
      Inc(PAnsiCharD, SizeOf(Cardinal));
      Inc(PAnsiCharS, SizeOf(Cardinal));
      Dec(lS, SizeOf(Cardinal));
    end;

  case lS of
    3:
      begin
        PWord(PAnsiCharD)^ := PWord(PAnsiCharS)^;
        PAnsiCharD[2] := PAnsiCharS[2];
      end;
    2:
      begin
        PWord(PAnsiCharD)^ := PWord(PAnsiCharS)^;
      end;
    1:
      begin
        PAnsiCharD^ := PAnsiCharS^;
      end;
  end;

  InUse := NewInUse;
end;

procedure ConCatBufW(const Buffer: Pointer; const WideCharCount: Cardinal; var d: WideString; var InUse: Cardinal);
var
  PSource, PDest: PWideChar;
  LSource, lDest, NewInUse: Cardinal;
begin
  PSource := Buffer;
  if PSource = nil then Exit;

  LSource := WideCharCount;
  if LSource = 0 then Exit;

  PDest := Pointer(d);
  lDest := Cardinal(PDest);
  if lDest <> 0 then lDest := PCardinal(lDest - 4)^ shr 1;

  NewInUse := InUse + LSource;

  if NewInUse > lDest then
    begin
      SetLength(d, (NewInUse + (NewInUse shr 1) + 3) and $FFFFFFFC);
      PDest := Pointer(d);
    end;

  Inc(PDest, InUse);
  while LSource >= 4 do
    begin
      PInt64(PDest)^ := PInt64(PSource)^;
      Inc(PDest, 4);
      Inc(PSource, 4);
      Dec(LSource, 4);
    end;

  case LSource of
    3:
      begin
        PCardinal(PDest)^ := PCardinal(PSource)^;
        PDest[2] := PSource[2];
      end;
    2:
      begin
        PCardinal(PDest)^ := PCardinal(PSource)^;
      end;
    1:
      begin
        PDest^ := PSource^;
      end;
  end;

  InUse := NewInUse;
end;

procedure ConCatCharA(const c: AnsiChar; var d: AnsiString; var InUse: Cardinal);
var
  Dest: PAnsiChar;
  lDest: Cardinal;
begin
  Dest := Pointer(d);
  lDest := Cardinal(Dest);
  if lDest <> 0 then lDest := PCardinal(lDest - 4)^;

  if InUse + 1 > lDest then
    begin
      SetLength(d, (InUse + 1 + (InUse + 1 shr 1) + 3) and $FFFFFFFC);
      Dest := Pointer(d);
    end;

  Dest[InUse] := c;
  Inc(InUse);
end;

procedure ConCatCharW(const c: WideChar; var d: WideString; var InUse: Cardinal);
var
  Dest: PWideChar;
  lDest: Cardinal;
begin
  Dest := Pointer(d);
  lDest := Cardinal(Dest);
  if lDest <> 0 then lDest := PCardinal(lDest - 4)^ shr 1;

  if InUse + 1 > lDest then
    begin
      SetLength(d, (InUse + 1 + (InUse + 1 shr 1) + 3) and $FFFFFFFC);
      Dest := Pointer(d);
    end;

  Dest[InUse] := c;

  InUse := InUse + 1;
end;

procedure ConCatStrA(const s: AnsiString; var d: AnsiString; var InUse: Cardinal);
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l = 0 then Exit;
  l := PCardinal(l - 4)^;
  if l = 0 then Exit;
  ConCatBufA(Pointer(s), l, d, InUse);
end;

procedure ConCatStrW(const w: WideString; var d: WideString; var InUse: Cardinal);
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l = 0 then Exit;
  l := PCardinal(l - 4)^;
  if l = 0 then Exit;
  ConCatBufW(Pointer(w), l shr 1, d, InUse);
end;

function CountBitsSet(const x: Cardinal): Byte;
type
  TC4 = packed record
    c1, c2, c3, c4: Byte;
  end;
begin
  Result := BitTable[TC4(x).c4] + BitTable[TC4(x).c3] + BitTable[TC4(x).c2] + BitTable[TC4(x).c1];
end;

function Crc32OfBuf(const Buffer; const BufferSize: Cardinal): Cardinal;
begin
  Result := not UpdateCrc32OfBuf(CRC_32_INIT, Buffer, BufferSize);
end;

function Crc32OfStrA(const s: AnsiString): Cardinal;
begin
  Result := CRC_32_INIT;
  if s <> '' then
    Result := UpdateCrc32OfBuf(Result, Pointer(s)^, PCardinal(Cardinal(s) - 4)^);
  Result := not Result;
end;

function Crc32OfStrW(const w: WideString): Cardinal;
begin
  Result := CRC_32_INIT;
  if Pointer(w) <> nil then
    Result := UpdateCrc32OfBuf(Result, Pointer(w)^, PCardinal(Cardinal(w) - 4)^);
  Result := not Result;
end;

function CurrentDay: Word;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wDay;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  t: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  t := TV.tv_sec;
  localtime_r(@t, UT);
  Result := UT.tm_mday;
end;
{$ENDIF}

function CurrentMonth: Word;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wMonth;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  t: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  t := TV.tv_sec;
  localtime_r(@t, UT);
  Result := UT.tm_mon;
end;
{$ENDIF}

function CurrentQuarter: Word;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := QUARTER_OF_MONTH[SystemTime.wMonth]
end;
{$ENDIF}
{$IFDEF LINUX}
var
  t: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  t := TV.tv_sec;
  localtime_r(@t, UT);
  Result := QUARTER_OF_MONTH[UT.tm_mon];
end;
{$ENDIF}

function CurrentYear: Integer;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  Result := SystemTime.wYear;
end;
{$ENDIF}
{$IFDEF LINUX}
var
  t: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  t := TV.tv_sec;
  localtime_r(@t, UT);
  Result := UT.tm_year + 1900;
end;
{$ENDIF}

function CurrentJulianDate: TJulianDate;
{$IFDEF MSWINDOWS}
var
  SystemTime: TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
    Result := YmdToJulianDate(wYear, wMonth, wDay);
end;
{$ENDIF}
{$IFDEF LINUX}
var
  t: TTime_T;
  TV: TTimeVal;
  UT: TUnixTime;
begin
  gettimeofday(TV, nil);
  t := TV.tv_sec;
  localtime_r(@t, UT);
  with UT do
    Result := YmdToJulianDate(tm_year + 1900, tm_mon, tm_mday);
end;
{$ENDIF}

function DayOfJulianDate(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Month: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Result);
end;

function DayOfWeek(const JulianDate: TJulianDate): Word;

begin
  Result := JulianDate mod 7;
end;

function DayOfWeek(const Year: Integer; const Month, Day: Word): Word;

begin
  Result := YmdToJulianDate(Year, Month, Day) mod 7;
end;

function DaysInMonth(const Year: Integer; const Month: Word): Word;
begin
  Result := DAYS_IN_MONTH[IsLeapYear(Year)][Month];
end;

function DaysInMonth(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := DAYS_IN_MONTH[IsLeapYear(Year)][Month];
end;

procedure DecDay(var Year: Integer; var Month, Day: Word);
begin
  Dec(Day);
  if Day < 1 then
    begin
      Dec(Month);
      if Month < 1 then
        begin
          Month := 12;
          Dec(Year);
        end;
      Day := DaysInMonth(Year, Month);
    end;
end;

procedure DecDay(var Year: Integer; var Month, Day: Word; const Days: Integer);
var
  JulianDate: TJulianDate;
begin
  JulianDate := YmdToJulianDate(Year, Month, Day);
  Dec(JulianDate, Days);
  JulianDateToYmd(JulianDate, Year, Month, Day);
end;

{$IFDEF MSWINDOWS}
function DeleteDirectoryA(Dir: AnsiString; const DeleteItself: Boolean = True): Boolean;
var
  FileOpStruct: TSHFileOpStructA;
begin
  if DeleteItself then
    ExcludeTrailingPathDelimiterA(Dir)
  else
    begin
      IncludeTrailingPathDelimiterByRef(Dir);
      Dir := Dir + AC_ASTERISK;
    end;

  Dir := Dir + WC_NULL;

  ZeroMem(FileOpStruct, SizeOf(FileOpStruct));

  FileOpStruct.wFunc := FO_DELETE;
  FileOpStruct.PFrom := Pointer(Dir);
  FileOpStruct.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;

  Result := SHFileOperationA(FileOpStruct) = 0;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function DeleteDirectoryW(Dir: WideString; const DeleteItself: Boolean = True): Boolean;
var
  FileOpStruct: TSHFileOpStructW;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if DeleteItself then
        ExcludeTrailingPathDelimiterW(Dir)
      else
        begin
          IncludeTrailingPathDelimiterByRef(Dir);
          Dir := Dir + WC_ASTERISK;
        end;

      Dir := Dir + WC_NULL;

      ZeroMem(FileOpStruct, SizeOf(FileOpStruct));

      FileOpStruct.wFunc := FO_DELETE;
      FileOpStruct.PFrom := Pointer(Dir);
      FileOpStruct.fFlags := FOF_SILENT or FOF_NOCONFIRMATION;

      Result := SHFileOperationW(FileOpStruct) = 0;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DeleteDirectoryA(Dir, DeleteItself);
  {$ENDIF}
end;
{$ENDIF}

function DirectoryExistsA(const Dir: AnsiString): Boolean;
{$IFDEF MSWINDOWS}
var
  Code: Cardinal;
begin
  Code := GetFileAttributesA(Pointer(Dir));
  Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY <> 0);
end;
{$ENDIF}
{$IFDEF LINUX}
var
  st: TStatBuf;
begin
  Result := (Stat(PAnsiChar(Dir), st) = 0) and (st.st_mode and __S_IFDIR = __S_IFDIR);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function DirectoryExistsW(const Dir: WideString): Boolean;
var
  Code: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Code := GetFileAttributesW(Pointer(Dir));
      Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY <> 0);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DirectoryExistsA(Dir);
  {$ENDIF}
end;
{$ENDIF}

procedure ExcludeTrailingPathDelimiterA(var s: AnsiString);
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^;
      if (l > 0) and (s[l] = AC_PATH_DELIMITER) then
        SetLength(s, l - 1);
    end;
end;

procedure ExcludeTrailingPathDelimiterW(var s: WideString);
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ shr 1;
      if (l > 0) and (s[l] = WC_PATH_DELIMITER) then
        SetLength(s, l - 1);
    end;
end;

{$IFDEF MSWINDOWS}
function DiskFreeA(const Dir: AnsiString): Int64;
var
  Kernel: THandle;
  GetDFSExA: function(
    const lpDirectoryName: PAnsiChar;
    out lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes: TLargeInteger;
    const lpTotalNumberOfFreeBytes: PLargeInteger): BOOL; stdcall;
  SpC, BpS, NoFC, TNoC: Cardinal;
  Temp: Int64;
begin

  Kernel := GetModuleHandle(Windows.Kernel32);
  if Kernel <> 0 then
    begin
      @GetDFSExA := GetProcAddress(Kernel, 'GetDiskFreeSpaceExA');
      if Assigned(GetDFSExA) then
        begin
          if not GetDFSExA(PAnsiChar(Dir), Result, Temp, nil) then
            Result := -1;
          Exit;
        end;
    end;

  if GetDiskFreeSpaceA(PAnsiChar(Dir), SpC, BpS, NoFC, TNoC) then
    begin
      Temp := SpC * BpS;
      Result := Temp * NoFC;
    end
  else
    Result := -1;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function DiskFreeW(const Dir: WideString): Int64;
var
  Temp: Int64;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if not GetDiskFreeSpaceExW(PWideChar(Dir), Result, Temp, nil) then
        Result := -1;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := DiskFreeA(Dir);
  {$ENDIF}
end;
{$ENDIF}

function EasterSunday(const Year: Integer): TJulianDate;
var
  d, x: Integer;
begin
  d := (234 - 11 * (Year mod 19)) mod 30 + 21;
  if d > 48 then
    x := 1
  else
    x := 0;
  Result := YmdToJulianDate(Year, 3, 1);
  Inc(Result, d - x + 6 - ((Year + (Year div 4) + d - x + 1) mod 7));
end;

procedure EasterSunday(const Year: Integer; out Month, Day: Word);
var
  DummyYear: Integer;
begin
  JulianDateToYmd(EasterSunday(Year), DummyYear, Month, Day);
end;

function ExtractFileDriveA(const FileName: AnsiString): AnsiString;
var
  i, j, l: Integer;
begin
  l := Length(FileName);
  if (l >= 2) and (FileName[2] = AC_DRIVE_DELIMITER) then
    Result := FileName[1] + AC_DRIVE_DELIMITER + AC_PATH_DELIMITER
  else
    if (l >= 2) and (FileName[1] = AC_PATH_DELIMITER) and (FileName[2] = AC_PATH_DELIMITER) then
      begin
        j := 2;
        i := 3;
        while i <= l do
          begin
            if FileName[i] = AC_PATH_DELIMITER then
              begin
                Dec(j);
                if j = 0 then Break;
              end;
            Inc(i);
          end;
        if i > l then i := l;
        SetString(Result, PAnsiChar(FileName), i);
        if Result[i] <> AC_PATH_DELIMITER then Result := Result + AC_PATH_DELIMITER;
      end
    else
      Result := '';
end;

function ExtractFileDriveW(const FileName: WideString): WideString;
var
  i, j, l: Integer;
begin
  l := Length(FileName);
  if (l >= 2) and (FileName[2] = WC_DRIVE_DELIMITER) then
    Result := WideString(FileName[1]) + WC_DRIVE_DELIMITER + WC_PATH_DELIMITER
  else
    if (l >= 2) and (FileName[1] = WC_PATH_DELIMITER) and (FileName[2] = WC_PATH_DELIMITER) then
      begin
        j := 2;
        i := 3;
        while i <= l do
          begin
            if FileName[i] = WC_PATH_DELIMITER then
              begin
                Dec(j);
                if j = 0 then Break;
              end;
            Inc(i);
          end;
        if i > l then i := l;
        SetString(Result, PWideChar(FileName), i);
        if Result[i] <> WC_PATH_DELIMITER then Result := Result + WC_PATH_DELIMITER;
      end
    else
      Result := '';
end;

function ExtractFileExtW(const FileName: WideString): WideString;
label
  NoExtension;
var
  p: PWideChar;
  i, l: Cardinal;
begin
  p := Pointer(FileName);
  if p <> nil then
    begin
      l := PCardinal(p - 2)^ shr 1;
      if l > 0 then
        begin
          i := l;
          Inc(p, i);
          repeat
            Dec(i);
            Dec(p);
            if p^ = WC_FULL_STOP then Break;
            if i = 0 then goto NoExtension;
            if (p^ = WC_PATH_DELIMITER) then goto NoExtension;
            if (p^ = WC_DRIVE_DELIMITER) then goto NoExtension;
          until False;
          SetString(Result, p, l - i);
          Exit;
        end;
    end;

  NoExtension:
  Result := '';
end;

function ExtractFileNameA(const FileName: AnsiString): AnsiString;
var
  l, Start: Cardinal;
begin
  l := Cardinal(FileName);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^;
      Start := l;
      while (Start > 0) and (FileName[Start] <> AC_PATH_DELIMITER) and (FileName[Start] <> AC_COLON) do
        Dec(Start);
      SetString(Result, PAnsiChar(FileName) + Start, l - Start);
    end
  else
    Result := '';
end;

function ExtractFileNameW(const FileName: WideString): WideString;
var
  l, Start: Cardinal;
begin
  l := Cardinal(FileName);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ shr 1;
      Start := l;
      while (Start > 0) and (FileName[Start] <> AC_PATH_DELIMITER) and (FileName[Start] <> AC_COLON) do
        Dec(Start);
      SetString(Result, PWideChar(FileName) + Start, l - Start);
    end
  else
    Result := '';
end;

function ExtractFilePathA(const FileName: AnsiString): AnsiString;
var
  l: Cardinal;
begin
  l := Cardinal(FileName);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^;
      while (l > 0) and (FileName[l] <> AC_PATH_DELIMITER) and (FileName[l] <> AC_COLON) do
        Dec(l);
    end;
  SetString(Result, PAnsiChar(FileName), l);
end;

function ExtractFilePathW(const FileName: WideString): WideString;
var
  l: Cardinal;
begin
  l := Cardinal(FileName);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ shr 1;
      while (l > 0) and (FileName[l] <> WC_PATH_DELIMITER) and (FileName[l] <> WC_COLON) do
        Dec(l);
    end;
  SetString(Result, PWideChar(FileName), l);
end;

function ExtractNextWordA(const s: AnsiString; const Delimiters: TAnsiCharSet; var StartIndex: Integer): AnsiString;
label
  Fail;
var
  p, pStart: PAnsiChar;
  l: Integer;
begin
  p := Pointer(s);
  if p = nil then goto Fail;
  l := PCardinal(Cardinal(p) - 4)^;

  if (StartIndex < 1) or (StartIndex - 1 > l) then goto Fail;

  Dec(l, StartIndex - 1);
  Inc(p, StartIndex - 1);
  pStart := p;

  while (l > 0) and not (p^ in Delimiters) do
    begin
      Inc(p);
      Dec(l);
    end;

  SetString(Result, pStart, p - pStart);
  if l <= 0 then
    StartIndex := 0
  else
    Inc(StartIndex, p - pStart + 1);

  Exit;

  Fail:
  StartIndex := -1;
end;

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function ExtractWordA(const Number: Cardinal; const s: AnsiString; const Delimiters: TAnsiCharSet = AS_WHITE_SPACE): AnsiString;
label
  ReturnEmptyString, Success;
var
  l, n: Cardinal;
  p, PWordStart: PAnsiChar;
begin
  n := Number;
  if n = 0 then goto ReturnEmptyString;

  p := Pointer(s);
  if p = nil then goto ReturnEmptyString;

  l := PCardinal(Cardinal(p) - 4)^;
  if l = 0 then goto ReturnEmptyString;

  repeat
    Dec(n);
    if n = 0 then goto Success;

    while (l > 0) and not (p^ in Delimiters) do
      begin
        Inc(p); Dec(l);
      end;

    if l < 1 then goto ReturnEmptyString;
    Inc(p); Dec(l);
  until False;

  ReturnEmptyString:
  Result := '';
  Exit;

  Success:
  PWordStart := p;
  while (l > 0) and not (p^ in Delimiters) do
    begin
      Inc(p); Dec(l);
    end;
  SetString(Result, PWordStart, p - PWordStart);
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

function ExtractWordStartsA(const s: AnsiString; const MaxCharCount: Cardinal; const WordSeparators: TAnsiCharSet = AS_WHITE_SPACE): AnsiString;
var
  i, l, LengthResult: Cardinal;
  p: PAnsiChar;
begin
  Result := '';
  if MaxCharCount = 0 then Exit;

  p := Pointer(s);
  l := Cardinal(p);
  if l = 0 then Exit;
  l := PCardinal(l - 4)^;

  if l > 0 then
    begin
      LengthResult := 0;

      repeat

        while (l > 0) and (p^ in WordSeparators) do
          begin
            Inc(p);
            Dec(l);
          end;

        i := MaxCharCount;
        while (l > 0) and (i > 0) and not (p^ in WordSeparators) do
          begin
            ConCatCharA(p^, Result, LengthResult);
            Inc(p);
            Dec(i);
            Dec(l);
          end;

        while (l > 0) and not (p^ in WordSeparators) do
          begin
            Inc(p);
            Dec(l);
          end;

      until l = 0;

      SetLength(Result, LengthResult);
    end;
end;

function ExtractWordStartsW(const s: WideString; const MaxCharCount: Cardinal; const IsWordSep: TDIValidateWideCharFunc): WideString;
var
  i, l, LengthResult: Cardinal;
  p: PWideChar;
begin
  Result := '';
  if MaxCharCount = 0 then Exit;

  p := Pointer(s);
  l := Cardinal(p);
  if l = 0 then Exit;
  l := PCardinal(l - 4)^ shr 1;

  if l > 0 then
    begin
      LengthResult := 0;

      repeat

        while (l > 0) and IsWordSep(p^) do
          begin
            Inc(p);
            Dec(l);
          end;

        i := MaxCharCount;
        while (l > 0) and (i > 0) and not IsWordSep(p^) do
          begin
            ConCatCharW(p^, Result, LengthResult);
            Inc(p);
            Dec(i);
            Dec(l);
          end;

        while (l > 0) and not IsWordSep(p^) do
          begin
            Inc(p);
            Dec(l);
          end;

      until l = 0;

      SetLength(Result, LengthResult);
    end;
end;

function FileExistsA(const FileName: AnsiString): Boolean;
{$IFDEF MSWINDOWS}
var
  Code: Cardinal;
  {$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Code := GetFileAttributesA(Pointer(FileName));
  Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY = 0);
  {$ENDIF}

  {$IFDEF LINUX}
  Result := euidaccess(PChar(FileName), F_OK) = 0;
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}
function FileExistsW(const FileName: WideString): Boolean;
var
  Code: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Code := GetFileAttributesW(Pointer(FileName));
      Result := (Code <> $FFFFFFFF) and (Code and FILE_ATTRIBUTE_DIRECTORY = 0);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := FileExistsA(FileName);
  {$ENDIF}
end;
{$ENDIF}

function FirstDayOfMonth(const Julian: TJulianDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, 1);
end;

procedure FirstDayOfMonth(const Year: Integer; const Month: Word; out Day: Word);
begin
  Day := 1;
end;

function FirstDayOfWeek(const JulianDate: TJulianDate): TJulianDate;
begin
  Result := JulianDate;
  Dec(Result, Result mod 7);
end;

procedure FirstDayOfWeek(var Year: Integer; var Month, Day: Word);
var
  Julian: TJulianDate;
begin
  Julian := YmdToJulianDate(Year, Month, Day);
  Dec(Julian, Julian mod 7);
  JulianDateToYmd(Julian, Year, Month, Day);
end;

{$IFDEF MSWINDOWS}
function ForceDirectoriesA(Dir: AnsiString): Boolean;
var
  l: Integer;
  UpDir: AnsiString;
begin
  Result := True;
  if DirectoryExistsA(Dir) then Exit;
  ExcludeTrailingPathDelimiterA(Dir);
  l := Length(Dir);
  if l < 3 then Exit;
  UpDir := ExtractFilePathA(Dir);
  if l = Length(UpDir) then Exit;
  Result := ForceDirectoriesA(UpDir) and CreateDirectoryA(Pointer(Dir), nil);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function ForceDirectoriesW(Dir: WideString): Boolean;
var
  l: Integer;
  UpDir: WideString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Result := True;
      if DirectoryExistsW(Dir) then Exit;
      ExcludeTrailingPathDelimiterW(Dir);
      l := Length(Dir);
      if l < 3 then Exit;
      UpDir := ExtractFilePathW(Dir);
      if l = Length(UpDir) then Exit;
      Result := ForceDirectoriesW(UpDir) and CreateDirectoryW(Pointer(Dir), nil);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := ForceDirectoriesA(Dir);
  {$ENDIF}
end;
{$ENDIF}

function GCD(const x, y: Cardinal): Cardinal; assembler;

asm
     JMP  @01
@00:
     MOV  ECX, EDX
     XOR  EDX, EDX
     DIV  ECX
     MOV  EAX, ECX
@01:
     TEST EDX, EDX
     JNE  @00
end;

{$IFDEF MSWINDOWS}
function GetCurrentFolderA: AnsiString;
var
  Required: Cardinal;
begin
  Required := GetCurrentDirectoryA(0, nil);
  if Required > 0 then
    begin
      SetString(Result, nil, Required - 1);
      GetCurrentDirectoryA(Required, Pointer(Result));
    end
  else
    Result := '';
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetCurrentFolderW: WideString;
var
  Required: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Required := GetCurrentDirectoryW(0, nil);
      if Required > 0 then
        begin
          SetString(Result, nil, Required - 1);
          GetCurrentDirectoryW(Required, Pointer(Result));
        end
      else
        Result := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetCurrentFolderA;
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure SetCurrentFolderA(const NewFolder: AnsiString);
begin
  SetCurrentDirectoryA(PAnsiChar(NewFolder));
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure SetCurrentFolderW(const NewFolder: WideString);
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    {$ENDIF}
    SetCurrentDirectoryW(PWideChar(NewFolder))
      {$IFNDEF DI_No_Win_9X_Support}
  else
    SetCurrentFolderA(NewFolder);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetDesktopFolderA: AnsiString;
begin
  Result := GetSpecialFolderA(CSIDL_Desktop);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetDesktopFolderW: WideString;
begin
  Result := GetSpecialFolderW(CSIDL_Desktop);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetDesktopDirectoryFolderA: AnsiString;
begin
  Result := GetSpecialFolderA(CSIDL_DESKTOPDIRECTORY);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetDesktopDirectoryFolderW: WideString;
begin
  Result := GetSpecialFolderW(CSIDL_DESKTOPDIRECTORY);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetPersonalFolderA: AnsiString;
begin
  Result := GetSpecialFolderA(CSIDL_PERSONAL);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetPersonalFolderW: WideString;
begin
  Result := GetSpecialFolderW(CSIDL_PERSONAL);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetSpecialFolderA(const SpecialFolder: Integer): AnsiString;
var
  ItemIDList: PItemIDList;
  Buffer: array[0..MAX_PATH - 1] of AnsiChar;
  Malloc: IMalloc;
begin
  if SHGetSpecialFolderLocation(0, SpecialFolder, ItemIDList) = NOERROR then
    begin
      if SHGetPathFromIDListA(ItemIDList, Buffer) then
        begin
          Result := Buffer;
          IncludeTrailingPathDelimiterByRef(Result);
        end
      else
        Result := '';
      if (SHGetMalloc(Malloc) = NOERROR) and (Malloc.DidAlloc(ItemIDList) > 0) then
        Malloc.Free(ItemIDList);
    end
  else
    Result := '';
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetSpecialFolderW(const SpecialFolder: Integer): WideString;
var
  ItemIDList: PItemIDList;
  Buffer: array[0..MAX_PATH - 1] of WideChar;
  Malloc: IMalloc;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if SHGetSpecialFolderLocation(0, SpecialFolder, ItemIDList) = NOERROR then
        begin
          if SHGetPathFromIDListW(ItemIDList, Buffer) then
            begin
              Result := Buffer;
              IncludeTrailingPathDelimiterByRef(Result);
            end
          else
            Result := '';
          if (SHGetMalloc(Malloc) = NOERROR) and (Malloc.DidAlloc(ItemIDList) > 0) then
            Malloc.Free(ItemIDList);
        end
      else
        Result := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetSpecialFolderA(SpecialFolder);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetTempFolderA: AnsiString;
var
  Required: Cardinal;
begin
  Result := '';
  Required := GetTempPathA(0, nil);
  SetString(Result, nil, Required - 1);
  GetTempPathA(Required, Pointer(Result));
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetTempFolderW: WideString;
var
  Required: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Result := '';
      Required := GetTempPathW(0, nil);
      SetString(Result, nil, Required - 1);
      GetTempPathW(Required, Pointer(Result));
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := GetTempFolderA;
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetUserNameA(out UserNameA: AnsiString): Boolean;
var
  Size: DWORD;
begin
  Size := 256 + 1;
  SetString(UserNameA, nil, Size);
  Result := Windows.GetUserNameA(Pointer(UserNameA), Size);
  if Result then
    SetLength(UserNameA, Size - 1)
  else
    UserNameA := '';
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function GetUserNameW(out UserNameW: WideString): Boolean;
var
  Size: DWORD;
  {$IFNDEF DI_No_Win_9X_Support}
  UserNameA: AnsiString;
  {$ENDIF}
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      Size := 256 + 1;
      SetString(UserNameW, nil, Size);
      Result := Windows.GetUserNameW(Pointer(UserNameW), Size);
      if Result then
        SetLength(UserNameW, Size - 1)
      else
        UserNameW := '';
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    begin
      Result := GetUserNameA(UserNameA);
      UserNameW := UserNameA;
    end;
  {$ENDIF}
end;
{$ENDIF}

function StrContainsCharA(const s: AnsiString; const c: AnsiChar; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(s);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;

  l := PCardinal(Cardinal(p) - 4)^;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if (p^ = c) or (p[1] = c) or (p[2] = c) or (p[3] = c) then goto Match;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3: if (p^ = c) or (p[1] = c) or (p[2] = c) then goto Match;
    2: if (p^ = c) or (p[1] = c) then goto Match;
    1: if (p^ = c) then goto Match;
  end;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

function StrContainsCharsA(const s: AnsiString; const Chars: TAnsiCharSet; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(s);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if (p^ in Chars) or (p[1] in Chars) or (p[2] in Chars) or (p[3] in Chars) then goto Match;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3: if (p^ in Chars) or (p[1] in Chars) or (p[2] in Chars) then goto Match;
    2: if (p^ in Chars) or (p[1] in Chars) then goto Match;
    1: if p^ in Chars then goto Match;
  end;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

function StrContainsCharW(const w: WideString; const c: WideChar; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(w);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 2)^ shr 1;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if (p^ = c) or (p[1] = c) or (p[2] = c) or (p[3] = c) then goto Match;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3: if (p^ = c) or (p[1] = c) or (p[2] = c) then goto Match;
    2: if (p^ = c) or (p[1] = c) then goto Match;
    1: if (p^ = c) then goto Match;
  end;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

function StrContainsCharsW(const w: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(w);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 2)^ shr 1;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if Validate(p^) or Validate(p[1]) or Validate(p[2]) or Validate(p[3]) then goto Match;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3: if Validate(p^) or Validate(p[1]) or Validate(p[2]) then goto Match;
    2: if Validate(p^) or Validate(p[1]) then goto Match;
    1: if Validate(p^) then goto Match;
  end;

  Fail:
  Result := False;
  Exit;

  Match:
  Result := True;
end;

function StrConsistsOfW(const w: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Boolean;
label
  Fail, Match;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(w);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 2)^ shr 1;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if not Validate(p^) or not Validate(p[1]) or not Validate(p[2]) or not Validate(p[3]) then goto Fail;
      Inc(p, 4); Dec(l, 4);
    end;

  case l of
    3: if not Validate(p^) or not Validate(p[1]) or not Validate(p[2]) then goto Fail;
    2: if not Validate(p^) or not Validate(p[1]) then goto Fail;
    1: if not Validate(p^) then goto Fail;
  end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function HashBuf(const Buffer; const BufferSize: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;
type
  TCardinal3 = packed record
    c1, c2, c3: Cardinal;
  end;
  PCardinal3 = ^TCardinal3;
var
  p: PCardinal3;
  a, b, l: Cardinal;
begin
  a := $9E3779B9;
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := BufferSize;

  while l >= 12 do
    begin
      Inc(a, p^.c1);
      Inc(b, p^.c2);
      Inc(Result, p^.c3);

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

      Inc(p);
      Dec(l, 12);
    end;

  Inc(Result, BufferSize);
  case l of
    11:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);

        Inc(Result, p^.c3 and $FFFFFF shl 8);
      end;
    10:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);

        Inc(Result, p^.c3 and $FFFF shl 8);
      end;
    9:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);

        Inc(Result, p^.c3 and $FF shl 8);
      end;
    8:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2);
      end;
    7:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FFFFFF);
      end;
    6:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FFFF);
      end;
    5:
      begin
        Inc(a, p^.c1);
        Inc(b, p^.c2 and $FF);
      end;
    4:
      begin
        Inc(a, p^.c1);
      end;
    3:
      begin
        Inc(a, p^.c1 and $FFFFFF);
      end;
    2:
      begin
        Inc(a, p^.c1 and $FFFF);
      end;
    1:
      begin
        Inc(a, p^.c1 and $FF);
      end;
  end;

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function HashBufIA(const Buffer; const AnsiCharCount: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;
label
  l0, l1, l2, l3, l4, l5, l6, l7, l8, l9, l10, l11, l12;
type
  TAnsiChar4 = packed record
    case Boolean of
      True: (n: Cardinal);
      False: (c1, c2, c3, c4: AnsiChar);
  end;
  TAnsiChar12 = packed record
    c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12: AnsiChar;
  end;
  PAnsiChar12 = ^TAnsiChar12;
var
  p: PAnsiChar12;
  x: TAnsiChar4;
  a, b: Cardinal;
  l: Cardinal;
begin
  a := $9E3779B9;
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := AnsiCharCount;

  while l >= 12 do
    begin
      x.c1 := ANSI_UPPER_CHAR_TABLE[p^.c1];
      x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c2];
      x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c3];
      x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c4];
      Inc(a, x.n);

      x.c1 := ANSI_UPPER_CHAR_TABLE[p^.c5];
      x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c6];
      x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c7];
      x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c8];
      Inc(b, x.n);

      x.c1 := ANSI_UPPER_CHAR_TABLE[p^.c9];
      x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c10];
      x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c11];
      x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c12];
      Inc(Result, x.n);

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

      Inc(p);
      Dec(l, 12);
    end;

  Inc(Result, AnsiCharCount);

  x.n := 0;
  case l of
    11: goto l11;
    10: goto l10;
    9: goto l9;
    8: goto l8;
    7: goto l7;
    6: goto l6;
    5: goto l5;
    4: goto l4;
    3: goto l3;
    2: goto l2;
    1: goto l1;
  else
    goto l0;
  end;

  l11:
  x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c11];
  l10:
  x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c10];
  l9:
  x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c9];

  Inc(Result, x.n);

  l8:
  x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c8];
  l7:
  x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c7];
  l6:
  x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c6];
  l5:
  x.c1 := ANSI_UPPER_CHAR_TABLE[p^.c5];
  Inc(b, x.n);

  l4:
  x.c4 := ANSI_UPPER_CHAR_TABLE[p^.c4];
  l3:
  x.c3 := ANSI_UPPER_CHAR_TABLE[p^.c3];
  l2:
  x.c2 := ANSI_UPPER_CHAR_TABLE[p^.c2];
  l1:
  x.c1 := ANSI_UPPER_CHAR_TABLE[p^.c1];
  Inc(a, x.n);

  l0:

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function HashBufIW(const Buffer; const WideCharCount: Cardinal; const PreviousHash: Cardinal = 0): Cardinal;
label
  l0, l1, l2, l3, l4, l5;
type
  TWideChar2 = packed record
    case Boolean of
      True: (n: Cardinal);
      False: (c1, c2: WideChar);
  end;
  TWideChar6 = packed record
    c1, c2, c3, c4, c5, c6: WideChar;
  end;
  PWideChar6 = ^TWideChar6;
var
  p: PWideChar6;
  x: TWideChar2;
  a, b: Cardinal;
  l: Cardinal;
begin
  a := $9E3779B9;
  b := a;
  Result := PreviousHash;

  p := @Buffer;
  l := WideCharCount;

  while l >= 6 do
    begin
      x.c1 := CharToCaseFoldW(p^.c1);
      x.c2 := CharToCaseFoldW(p^.c2);
      Inc(a, x.n);

      x.c1 := CharToCaseFoldW(p^.c3);
      x.c2 := CharToCaseFoldW(p^.c4);
      Inc(b, x.n);

      x.c1 := CharToCaseFoldW(p^.c5);
      x.c2 := CharToCaseFoldW(p^.c6);
      Inc(Result, x.n);

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

      Inc(p);
      Dec(l, 6);
    end;

  Inc(Result, WideCharCount);

  x.n := 0;
  case l of
    5: goto l5;
    4: goto l4;
    3: goto l3;
    2: goto l2;
    1: goto l1;
  else
    goto l0;
  end;

  l5:
  x.c2 := CharToCaseFoldW(p^.c5);

  Inc(b, x.n);

  l4:
  x.c2 := CharToCaseFoldW(p^.c4);
  l3:
  x.c1 := CharToCaseFoldW(p^.c3);
  l2:
  x.c2 := CharToCaseFoldW(p^.c2);
  l1:
  x.c1 := CharToCaseFoldW(p^.c1);
  Inc(a, x.n);

  l0:

Dec(a, b); Dec(a, Result); a := a xor (Result shr 13);
Dec(b, Result); Dec(b, a); b := b xor (a shl 8);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 13);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 12);
Dec(b, Result); Dec(b, a); b := b xor (a shl 16);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 5);
Dec(a, b); Dec(a, Result); a := a xor (Result shr 3);
Dec(b, Result); Dec(b, a); b := b xor (a shl 10);
Dec(Result, a); Dec(Result, b); Result := Result xor (b shr 15);

end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}

function HashStrA(const s: AnsiString; const PreviousHash: Cardinal = 0): Cardinal;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    l := PCardinal(l - 4)^;
  Result := HashBuf(Pointer(s)^, l, PreviousHash);
end;

function HashStrW(const w: WideString; const PreviousHash: Cardinal = 0): Cardinal;
var
  p: PWideChar;
  l: Cardinal;
begin
  p := Pointer(w);
  l := Cardinal(p);
  if l <> 0 then
    l := PCardinal(l - 4)^;
  Result := HashBuf(Pointer(w)^, l, PreviousHash);
end;

function HashStrIA(const s: AnsiString; const PreviousHash: Cardinal = 0): Cardinal;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    l := PCardinal(l - 4)^;
  Result := HashBufIA(Pointer(s)^, l, PreviousHash);
end;

function HashStrIW(const w: WideString; const PreviousHash: Cardinal = 0): Cardinal;
var
  p: PWideChar;
  l: Cardinal;
begin
  p := Pointer(w);
  l := Cardinal(p);
  if l <> 0 then
    l := PCardinal(l - 4)^ shr 1;
  Result := HashBufIW(Pointer(w)^, l, PreviousHash);
end;

function HexToIntA(const s: AnsiString): Integer;
var
  c: Integer;
  l: Cardinal;
  p: PByte;
begin
  Result := 0;
  p := Pointer(s);
  if p = nil then Exit;
  l := Cardinal(p);
  l := PCardinal(l - 4)^;
  while l > 0 do
    begin
      c := p^;
      Dec(c, $30);
      if c > $09 then
        begin
          Dec(c, $11);
          if c > $05 then
            begin
              Dec(c, $20);
              if c > $05 then Break;
            end;
          if c < 0 then Break;
          Inc(c, $0A);
        end
      else
        if c < 0 then Break;
      Result := Result shl 4 or c;

      Inc(p);
      Dec(l);
    end;
end;

function HexToIntW(const w: WideString): Integer;
var
  c: Integer;
  l: Cardinal;
  p: PWord;
begin
  Result := 0;
  p := Pointer(w);
  if p = nil then Exit;
  l := Cardinal(p);
  l := PCardinal(l - 4)^ shr 1;
  while l > 0 do
    begin
      c := p^;
      Dec(c, $30);
      if c > $09 then
        begin
          Dec(c, $11);
          if c > $05 then
            begin
              Dec(c, $20);
              if c > $05 then Break;
            end;
          if c < 0 then Break;
          Inc(c, $0A);
        end
      else
        if c < 0 then Break;
      Result := Result shl 4 or c;

      Inc(p);
      Dec(l);
    end;
end;

procedure IncludeTrailingPathDelimiterByRef(var s: AnsiString);
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^;
      if (l > 0) and (s[l] = AC_PATH_DELIMITER) then Exit;
    end;
  s := s + AC_PATH_DELIMITER;
end;

procedure IncludeTrailingPathDelimiterByRef(var w: WideString);
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ shr 1;
      if (l > 0) and (w[l] = WC_PATH_DELIMITER) then Exit;
    end;
  w := w + WC_PATH_DELIMITER;
end;

function IsLeapYear(const Year: Integer): Boolean;
begin
  Result := (Year and 3 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0));
end;

function ISODateToJulianDate(const ISODate: TIsoDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  ISODateToYmd(ISODate, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, Day);
end;

procedure ISODateToYmd(const ISODate: TIsoDate; out Year: Integer; out Month, Day: Word);
var
  i: TIsoDate;
begin
  i := ISODate;
  Year := i div 10000;
  Dec(i, Year * 10000);
  Month := i div 100;
  Day := i - Month * 100;
end;

function IsCharLowLineW(const c: WideChar): Boolean;
begin
  Result := c = WC_LOW_LINE;
end;

function IsCharQuoteW(const c: WideChar): Boolean;
begin
  Result := c in [WC_APOSTROPHE, WC_QUOTATION_MARK];
end;

{$IFDEF MSWINDOWS}
function IsShiftKeyDown: Boolean;
begin
  Result := (GetAsyncKeyState(VK_LSHIFT) < 0) or (GetAsyncKeyState(VK_RSHIFT) < 0);
end;
{$ENDIF}

function CharIsWhiteSpaceW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE;
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE];
  {$ENDIF}
end;

function IsCharWhiteSpaceOrAmpersandW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_AMPERSAND];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_AMPERSAND];
  {$ENDIF}
end;

function IsCharWhiteSpaceOrColonW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_COLON];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_COLON];
  {$ENDIF}
end;

function CharIsWhiteSpaceGtW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_GREATER_THAN_SIGN];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_GREATER_THAN_SIGN];
  {$ENDIF}
end;

function CharIsWhiteSpaceLtW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_LESS_THAN_SIGN];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_LESS_THAN_SIGN];
  {$ENDIF}
end;

function CharIsWhiteSpaceHyphenW(const c: WideChar): Boolean;
begin
  Result := c in [
    WC_NULL..WC_SPACE,
    WC_GREATER_THAN_SIGN,
    WC_HYPHEN_MINUS];
end;

function CharIsWhiteSpaceHyphenGtW(const c: WideChar): Boolean;
begin
  Result := c in [
    WC_NULL..WC_SPACE,
    WC_GREATER_THAN_SIGN,
    WC_HYPHEN_MINUS];
end;

function IsCharWhiteSpaceOrNoBreakSpaceW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_WHITE_SPACE + [WC_NO_BREAK_SPACE];
  {$ELSE}
  Result := c in [WC_NULL..WC_SPACE, WC_NO_BREAK_SPACE];
  {$ENDIF}
end;

function IsCharAlphaW(const c: WideChar): Boolean;
begin
  Result := c in [WC_CAPITAL_A..WC_CAPITAL_Z, WC_SMALL_A..WC_SMALL_Z];
end;

function CharDecomposeHangulW(const c: WideChar): WideString;
var
  SIndex, Rest: Cardinal;
begin
  SIndex := Ord(c) - HANGUL_SBase;
  Rest := SIndex mod HANGUL_TCount;
  if Rest = 0 then
    begin
      SetString(Result, nil, 2);
      PWideChar(Pointer(Result))^ := WideChar(HANGUL_LBase + SIndex div HANGUL_nCount);
      PWideChar(Pointer(Result))[1] := WideChar(HANGUL_VBase + SIndex mod HANGUL_nCount div HANGUL_TCount);
    end
  else
    begin
      SetString(Result, nil, 3);
      PWideChar(Pointer(Result))^ := WideChar(HANGUL_LBase + SIndex div HANGUL_nCount);
      PWideChar(Pointer(Result))[1] := WideChar(HANGUL_VBase + SIndex mod HANGUL_nCount div HANGUL_TCount);
      PWideChar(Pointer(Result))[2] := WideChar(HANGUL_TBase + Rest);
    end;
end;

function CharIsAlphaNumW(const c: WideChar): Boolean;
begin
  Result := c in [WC_DIGIT_ZERO..WC_DIGIT_NINE, WC_CAPITAL_A..WC_CAPITAL_Z, WC_SMALL_A..WC_SMALL_Z];
end;

function CharIsDigitW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_DIGITS;
  {$ELSE}
  Result := c in [WC_DIGIT_ZERO..WC_DIGIT_NINE];
  {$ENDIF}
end;

function CharIsHangulW(const Char: WideChar): Boolean;
begin
  Result := (Char >= #$AC00) and (Char <= #$D7FF);
end;

function CharIsHexDigitW(const c: WideChar): Boolean;
begin
  {$IFDEF DI_Use_Wide_Char_Set_Consts}
  Result := c in WS_HEX_DIGITS;
  {$ELSE}
  Result := c in [WC_DIGIT_ZERO..WC_DIGIT_NINE, WC_CAPITAL_A..WC_CAPITAL_F, WC_SMALL_A..WC_SMALL_F];
  {$ENDIF}
end;

procedure IncDay(var Year: Integer; var Month, Day: Word);
begin
  Inc(Day);
  if Day > DaysInMonth(Year, Month) then
    begin
      Day := 1;
      Inc(Month);
      if Month > 12 then
        begin
          Month := 1;
          Inc(Year);
        end;
    end;
end;

procedure IncDay(var Year: Integer; var Month, Day: Word; const Days: Integer);
var
  JulianDate: TJulianDate;
begin
  JulianDate := YmdToJulianDate(Year, Month, Day);
  Inc(JulianDate, Days);
  JulianDateToYmd(JulianDate, Year, Month, Day);
end;

procedure IncMonth(var Year: Integer; var Month, Day: Word);
var
  d: Word;
begin
  Inc(Month);
  if Month > 12 then
    begin
      Month := 1;
      Inc(Year);
    end;
  d := DaysInMonth(Year, Month);
  if Day > d then
    Day := d;
end;

procedure IncMonth(var Year: Integer; var Month, Day: Word; const NumberOfMonths: Integer);
var
  IMonth: Integer;
begin
  IMonth := Month + NumberOfMonths;
  if IMonth > 12 then
    begin
      Inc(Year, (IMonth - 1) div 12);
      IMonth := IMonth mod 12;
      if IMonth = 0 then
        IMonth := 12;
    end
  else
    if IMonth < 1 then
      begin
        Inc(Year, (IMonth div 12) - 1);
        IMonth := 12 + IMonth mod 12;
      end;
  Month := IMonth;
  IMonth := DaysInMonth(Year, Month);
  if Day > IMonth then
    Day := IMonth;
end;

function IntToHexA(Value: Int64; Digits: Integer): AnsiString;
var
  p: PAnsiChar;
begin
  SetString(Result, nil, Digits);
  p := Pointer(Result);
  while (Value <> 0) and (Digits > 0) do
    begin
      Dec(Digits);
      p[Digits] := AA_NUM_TO_HEX[Value and $000F];
      Value := Value shr 4;
    end;
  while Digits > 0 do
    begin
      Dec(Digits);
      p[Digits] := AC_DIGIT_ZERO;
    end;
end;

function IntToHexW(Value: Int64; Digits: Integer): WideString;
var
  p: PWideChar;
begin
  SetString(Result, nil, Digits);
  p := Pointer(Result);
  while (Value <> 0) and (Digits > 0) do
    begin
      Dec(Digits);
      p[Digits] := WA_NUM_TO_HEX[Value and $000F];
      Value := Value shr 4;
    end;
  while Digits > 0 do
    begin
      Dec(Digits);
      p[Digits] := WC_DIGIT_ZERO;
    end;
end;

function IntToStrA(const i: Integer): AnsiString;
begin
  Str(i, Result);
end;

function IntToStrW(const i: Integer): WideString;
begin
  Str(i, Result);
end;

function IntToStrA(const i: Int64): AnsiString;
begin
  Str(i, Result);
end;

function IntToStrW(const i: Int64): WideString;
begin
  Str(i, Result);
end;

{$IFNDEF COMPILER_5_UP}
procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;
{$ENDIF}

function IsDateValid(const Year: Integer; const Month, Day: Word): Boolean;
begin
  Result := (Month in [1..12]) and (Day > 0) and (Day <= DaysInMonth(Year, Month));
end;

function StrIsEmptyA(const s: AnsiString): Boolean;
label
  Fail;
var
  p: PAnsiChar;
  l: Cardinal;
begin
  p := Pointer(s);
  if p <> nil then
    begin
      l := PCardinal(p - 4)^;

      while l >= 4 do
        begin
          if (p^ > AC_SPACE) or (p[1] > AC_SPACE) or (p[2] > AC_SPACE) or (p[3] > AC_SPACE) then goto Fail;
          Inc(p, 4); Dec(l, 4);
        end;

      case l of
        3:
          if (p^ > AC_SPACE) or (p[1] > AC_SPACE) or (p[2] > AC_SPACE) then goto Fail;
        2:
          if (p^ > AC_SPACE) or (p[1] > AC_SPACE) then goto Fail;
        1:
          if (p^ > AC_SPACE) then goto Fail;
      end;
    end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrIsEmptyW(const w: WideString): Boolean;
label
  Fail;
var
  p: PWideChar;
  l: Cardinal;
begin
  p := Pointer(w);
  if p <> nil then
    begin
      l := PCardinal(p - 2)^ shr 1;

      while l >= 4 do
        begin
          if (p^ > WC_SPACE) or (p[1] > WC_SPACE) or (p[2] > WC_SPACE) or (p[3] > WC_SPACE) then goto Fail;
          Inc(p, 4); Dec(l, 4);
        end;

      case l of
        3:
          if (p^ > WC_SPACE) or (p[1] > WC_SPACE) or (p[2] > WC_SPACE) then goto Fail;
        2:
          if (p^ > WC_SPACE) or (p[1] > WC_SPACE) then goto Fail;
        1:
          if (p^ > WC_SPACE) then goto Fail;
      end;
    end;

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function IsHolidayInGermany(const Julian: TJulianDate; const Year: Integer; const Month, Day: Word): Boolean; overload;
label
  Success;
var
  ES: TJulianDate;
begin
  if DayOfWeek(Julian) = ISO_SUNDAY then goto Success;

  case Month of
    1:
      begin
        case Day of
          1: goto Success;
        end;
      end;
    2:
      begin
      end;
    3:
      begin
      end;
    5:
      begin
        case Day of
          1: goto Success;
        end;
      end;
    6:
      begin
      end;
    8:
      begin
      end;
    9:
      begin
      end;
    10:
      begin
        case Day of
          3: goto Success;
        end;
      end;
    11:
      begin
      end;
    12:
      begin
        case Day of
          24: goto Success;
          25: goto Success;
          26: goto Success;
          31: goto Success;
        end;
      end;
  end;

  ES := EasterSunday(Year);

  if Julian = ES - 2 then goto Success;
  if Julian = ES + 1 then goto Success;
  if Julian = ES + 39 then goto Success;
  if Julian = ES + 50 then goto Success;

  Result := False;
  Exit;

  Success:
  Result := True;
end;

function IsHolidayInGermany(const Year: Integer; const Month, Day: Word): Boolean;
begin
  Result := IsHolidayInGermany(YmdToJulianDate(Year, Month, Day), Year, Month, Day);
end;

function IsHolidayInGermany(const Julian: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := IsHolidayInGermany(Julian, Year, Month, Day);
end;

function IsPathDelimiterA(const s: AnsiString; const Index: Cardinal): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := (Index > 0) and (Index <= l) and (s[Index] = AC_PATH_DELIMITER)
end;

function IsPathDelimiterW(const w: WideString; const Index: Cardinal): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l <> 0 then l := PCardinal(l - 4)^ shr 1;
  Result := (Index > 0) and (Index <= l) and (w[Index] = WC_PATH_DELIMITER)
end;

{$IFDEF MSWINDOWS}
function IsPointInRect(const Point: TPoint; const Rect: TRect): Boolean;
begin
  with Point, Rect do
    Result := (x >= Left) and (x <= Right) and (y >= Top) and (y <= Bottom);
end;
{$ENDIF}

function IsCharWordSeparatorW(const c: WideChar): Boolean;
begin
  Result := c in [
    WC_NULL..WC_SPACE,
  WC_DIGIT_ZERO..WC_DIGIT_NINE,
  WC_FULL_STOP, WC_COMMA, WC_COLON, WC_SEMICOLON,
  WC_QUOTATION_MARK, WC_HYPHEN_MINUS, WC_SOLIDUS, WC_AMPERSAND];
end;

function ISOWeekNumber(const JulianDate: TJulianDate): Word;
var
  D4, l: TJulianDate;
begin

  D4 := (JulianDate + 31741 - JulianDate mod 7) mod 146097 mod 36524 mod 1461;
  l := D4 div 1460;
  Result := ((D4 - l) mod 365 + l) div 7 + 1
end;

function ISOWeekNumber(const Year: Integer; const Month, Day: Word): Word;
begin
  Result := ISOWeekNumber(YmdToJulianDate(Year, Month, Day));
end;

function ISOWeekToJulianDate(const Year: Integer; const WeekOfYear, DayOfWeek: Word): TJulianDate;
begin
  Result := YmdToJulianDate(Year, 1, 4);
  Inc(Result, (WeekOfYear - 1) * 7 - Result mod 7 + DayOfWeek);
end;

procedure JulianDateToYmd(const JulianDate: TJulianDate; out Year: Integer; out Month, Day: Word);
{$IFDEF Calender_FAQ}
var
  a, b, c, d, e, m: Integer;
begin
  a := JulianDate + 32044;
  b := (4 * a + 3) div 146097;
  c := a - (b * 146097) div 4;
  d := (4 * c + 3) div 1461;
  e := c - (1461 * d) div 4;
  m := (5 * e + 2) div 153;
  Day := e - (153 * m + 2) div 5 + 1;
  Month := m + 3 - 12 * (m div 10);
  Year := b * 100 + d - 4800 + m div 10;
end;
{$ELSE}
var
  l, n, i, j: Integer;
begin
  l := JulianDate + 68569;
  n := 4 * l div 146097;
  l := l - (146097 * n + 3) div 4;
  i := 4000 * (l + 1) div 1461001;
  l := l - 1461 * i div 4 + 31;
  j := 80 * l div 2447;
  Day := l - 2447 * j div 80;
  l := j div 11;
  Month := j + 2 - 12 * l;
  Year := 100 * (n - 49) + i + l;
end;
{$ENDIF}

function JulianDateToIsoDate(const Julian: TJulianDate): TIsoDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDate(Year, Month, Day);
end;

function JulianDateToIsoDateA(const Julian: TJulianDate): AnsiString;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDateA(Year, Month, Day);
end;

function JulianDateToIsoDateW(const Julian: TJulianDate): WideString;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(Julian, Year, Month, Day);
  Result := YmdToIsoDateW(Year, Month, Day);
end;

function LastDayOfMonth(const JulianDate: TJulianDate): TJulianDate;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := YmdToJulianDate(Year, Month, DaysInMonth(Year, Month));
end;

procedure LastDayOfMonth(const Year: Integer; const Month: Word; out Day: Word);
begin
  Day := DaysInMonth(Year, Month);
end;

function LastDayOfWeek(const JulianDate: TJulianDate): TJulianDate;
begin
  Result := JulianDate;
  Inc(Result, 6 - (Result mod 7));
end;

procedure LastDayOfWeek(var Year: Integer; var Month, Day: Word);
var
  Julian: TJulianDate;
begin
  Julian := YmdToJulianDate(Year, Month, Day);
  Inc(Julian, 6 - (Julian mod 7));
  JulianDateToYmd(Julian, Year, Month, Day);
end;

{$IFDEF MSWINDOWS}
function LastSysErrorMessageA: AnsiString;
begin
  Result := SysErrorMessageA(GetLastError);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function LastSysErrorMessageW: WideString;
begin
  Result := SysErrorMessageW(GetLastError);
end;
{$ENDIF}

function LeftMostBit(const Value: Cardinal): Integer;
asm
  MOV ECX, EAX
  MOV EAX, -1
  BSR EAX, ECX
end;

function MakeMethod(const AData, ACode: Pointer): TMethod;
begin
  with Result do begin Data := AData; Code := ACode; end;
end;

function Min(const a, b: Integer): Integer;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

function Min(const a, b: Cardinal): Cardinal;
begin
  if a < b then
    Result := a
  else
    Result := b;
end;

function Max(const a, b: Integer): Integer;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

function Max(const a, b: Cardinal): Cardinal;
begin
  if a > b then
    Result := a
  else
    Result := b;
end;

function MonthOfJulianDate(const JulianDate: TJulianDate): Word;
var
  Year: Integer;
  Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Result, Day);
end;

function PadLeftA(const Source: AnsiString; const Count: Cardinal; const c: AnsiChar = AC_SPACE): AnsiString;
var
  i, l: Cardinal;
  p1, p2: PAnsiChar;
begin

  p1 := Pointer(Source);
  l := Cardinal(p1);
  if l <> 0 then l := PCardinal(l - 4)^;

  if Count > l then
    begin

      SetString(Result, nil, Count);
      p2 := Pointer(Result);
      i := Count - l;
      repeat
        Dec(i);
        p2[i] := c;
      until i = 0;

      if l > 0 then
        begin

          Inc(p2, Count - l);
          repeat
            Dec(l);
            p2[l] := p1[l];
          until l = 0;
        end;
    end
  else

    Result := Source;
end;

function PadLeftW(const Source: WideString; const Count: Cardinal; const c: WideChar = WC_SPACE): WideString;
var
  i, l: Cardinal;
  p1, p2: PWideChar;
begin

  p1 := Pointer(Source);
  l := Cardinal(p1);
  if l <> 0 then l := PCardinal(l - 4)^ shr 1;

  if Count > l then
    begin

      SetString(Result, nil, Count);
      p2 := Pointer(Result);
      i := Count - l;
      repeat
        Dec(i);
        p2[i] := c;
      until i = 0;

      if l > 0 then
        begin

          Inc(p2, Count - l);
          repeat
            Dec(l);
            p2[l] := p1[l];
          until l = 0;
        end;
    end
  else

    Result := Source;
end;

function PadRightA(const Source: AnsiString; const Count: Cardinal; const c: AnsiChar = AC_SPACE): AnsiString;
var
  i, l: Cardinal;
  p1, p2: PAnsiChar;
begin

  p1 := Pointer(Source);
  l := Cardinal(p1);
  if l <> 0 then l := PCardinal(l - 4)^;

  if Count > l then
    begin
      SetString(Result, nil, Count);
      p2 := Pointer(Result);

      i := l;
      while i > 0 do
        begin
          Dec(i);
          p2[i] := p1[i];
        end;

      Inc(p2, l);
      i := Count - l;
      repeat
        Dec(i);
        p2[i] := c;
      until i = 0;
    end
  else

    Result := Source;
end;

function PadRightW(const Source: WideString; const Count: Cardinal; const c: WideChar = WC_SPACE): WideString;
var
  i, l: Cardinal;
  p1, p2: PWideChar;
begin

  p1 := Pointer(Source);
  l := Cardinal(p1);
  if l <> 0 then l := PCardinal(l - 4)^ shr 1;

  if Count > l then
    begin
      SetString(Result, nil, Count);
      p2 := Pointer(Result);

      i := l;
      while i > 0 do
        begin
          Dec(i);
          p2[i] := p1[i];
        end;

      Inc(p2, l);
      i := Count - l;
      repeat
        Dec(i);
        p2[i] := c;
      until i = 0;
    end
  else

    Result := Source;
end;

function ProperCaseA(const s: AnsiString): AnsiString;
begin
  Result := s;
  ProperCaseByRef(Result);
end;

function ProperCaseW(const w: WideString): WideString;
begin
  Result := w;
  ProperCaseByRef(Result);
end;

procedure ProperCaseByRef(var s: AnsiString);
var
  l: Cardinal;
  p: PAnsiChar;
  LastWasSeparator: Boolean;
begin
  p := Pointer(s);
  if p = nil then Exit;
  l := PCardinal(p - 4)^;
  if l > 0 then
    begin
      UniqueString(s);
      LastWasSeparator := True;
      repeat

        if p^ = AC_APOSTROPHE then

        else
          if p^ in AS_WORD_SEPARATORS then
            LastWasSeparator := True
          else
            if LastWasSeparator then
              begin
                p^ := ANSI_UPPER_CHAR_TABLE[p^];
                LastWasSeparator := False;
              end
            else
              p^ := ANSI_LOWER_CHAR_TABLE[p^];
        Inc(p);
        Dec(l);
      until l = 0;
    end;
end;

procedure ProperCaseByRef(var w: WideString);
var
  l: Cardinal;
  p: PWideChar;
  LastWasSeparator: Boolean;
begin
  p := Pointer(w);
  if p = nil then Exit;
  l := PCardinal(p - 2)^ shr 1;
  if l > 0 then
    begin
      {$IFDEF Linux}
      UniqueString(w);
      {$ENDIF}
      LastWasSeparator := True;
      repeat

        if p^ = WC_APOSTROPHE then

        else
          if IsCharWordSeparatorW(p^) then
            LastWasSeparator := True
          else
            if LastWasSeparator then
              begin
                p^ := CharToTitleW(p^);
                LastWasSeparator := False;
              end
            else
              p^ := CharToLowerW(p^);
        Inc(p);
        Dec(l);
      until l = 0;
    end;
end;

{$IFDEF MSWINDOWS}
function RegReadStrDefA(const Key: HKEY; const SubKey, ValueName, Default: AnsiString): AnsiString;
label
  Fail;
var
  ResultKey: HKEY;
  ValueType: DWORD;
  DataSize: DWORD;
begin
  if RegOpenKeyExA(Key, Pointer(SubKey), 0, KEY_READ, ResultKey) <> ERROR_SUCCESS then goto Fail;
  if (RegQueryValueExA(ResultKey, Pointer(ValueName), nil, @ValueType, nil, @DataSize) = ERROR_SUCCESS) and
    (ValueType in [REG_EXPAND_SZ, REG_SZ]) then
    begin
      SetString(Result, nil, DataSize - 1);
      if RegQueryValueExA(ResultKey, Pointer(ValueName), nil, nil, Pointer(Result), @DataSize) = ERROR_SUCCESS then
        begin
          RegCloseKey(ResultKey);
          Exit;
        end;
    end;
  RegCloseKey(ResultKey);
  Fail:
  Result := Default;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function RegReadStrDefW(const Key: HKEY; const SubKey, ValueName, Default: WideString): WideString;
label
  Fail;
var
  ResultKey: HKEY;
  ValueType: DWORD;
  DataSize: DWORD;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      if RegOpenKeyExW(Key, Pointer(SubKey), 0, KEY_READ, ResultKey) <> ERROR_SUCCESS then goto Fail;
      if (RegQueryValueExW(ResultKey, Pointer(ValueName), nil, @ValueType, nil, @DataSize) = ERROR_SUCCESS) and
        (ValueType in [REG_EXPAND_SZ, REG_SZ]) then
        begin
          SetString(Result, nil, DataSize - 1);
          if RegQueryValueExW(ResultKey, Pointer(ValueName), nil, nil, Pointer(Result), @DataSize) = ERROR_SUCCESS then
            begin
              RegCloseKey(ResultKey);
              Exit;
            end;
        end;
      RegCloseKey(ResultKey);
      Fail:
      Result := Default;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    RegReadStrDefA(Key, SubKey, ValueName, Default);
  {$ENDIF}
end;
{$ENDIF}

const
  HKLM_CURRENT_VERSION_NT = 'Software\Microsoft\Windows NT\CurrentVersion';
  HKLM_CURRENT_VERSION_WINDOWS = 'Software\Microsoft\Windows\CurrentVersion';

  {$IFDEF MSWINDOWS}
function RegReadRegisteredOrganizationA: AnsiString;
begin
  Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOrganization', '');
  if Result = '' then
    Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_WINDOWS, 'RegisteredOrganization', '');
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function RegReadRegisteredOrganizationW: WideString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    {$ENDIF}
    Result := RegReadStrDefW(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOrganization', '')
      {$IFNDEF DI_No_Win_9X_Support}
  else
    Result := RegReadRegisteredOrganizationA;
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function RegReadRegisteredOwnerA: AnsiString;
begin
  Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOwner', '');
  if Result = '' then
    Result := RegReadStrDefA(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_WINDOWS, 'RegisteredOwner', '');
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function RegReadRegisteredOwnerW: WideString;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    {$ENDIF}
    Result := RegReadStrDefW(HKEY_LOCAL_MACHINE, HKLM_CURRENT_VERSION_NT, 'RegisteredOwner', '')
      {$IFNDEF DI_No_Win_9X_Support}
  else
    Result := RegReadRegisteredOwnerA;
  {$ENDIF}
end;
{$ENDIF}

function StrDecodeUrl(const Value: AnsiString): AnsiString;
var
  PSrc: PAnsiChar;
  LSrc: Cardinal;
  PDest: PAnsiChar;
  b1, b2: Byte;
begin
  PSrc := Pointer(Value);
  if PSrc = nil then Exit;
  LSrc := PCardinal(Cardinal(PSrc) - 4)^;
  if LSrc = 0 then Exit;

  SetString(Result, nil, LSrc * 3);
  PDest := Pointer(Result);

  while LSrc > 0 do
    begin
      case PSrc^ of
        AC_PERCENT_SIGN:
          begin
            if LSrc > 1 then
              begin
                b1 := AA_HEX_TO_NUM[PSrc[1]];
                if (b1 <> $FF) and (LSrc > 2) then
                  begin
                    b2 := AA_HEX_TO_NUM[PSrc[2]];
                    if b2 <> $FF then
                      begin
                        PDest^ := AnsiChar((b1 shl 4) or b2);
                        Inc(PDest);
                        Inc(PSrc, 3); Dec(LSrc, 3);
                        Continue;
                      end;
                  end;
              end;

            PDest^ := AC_PERCENT_SIGN;
          end;
        AC_PLUS_SIGN:
          PDest^ := AC_SPACE;
      else
        PDest^ := PSrc^;
      end;

      Inc(PDest);
      Inc(PSrc); Dec(LSrc);
    end;

  SetLength(Result, Cardinal(PDest) - Cardinal(Result));
end;

function StrEncodeUrl(const Value: AnsiString): AnsiString;

var
  PSrc: PAnsiChar;
  LSrc: Cardinal;
  PDest: PAnsiChar;
begin
  PSrc := Pointer(Value);
  if PSrc = nil then Exit;
  LSrc := PCardinal(Cardinal(PSrc) - 4)^;
  if LSrc = 0 then Exit;

  SetString(Result, nil, LSrc * 3);
  PDest := Pointer(Result);

  while LSrc > 0 do
    begin
      case PSrc^ of
        AC_ASTERISK,
          AC_HYPHEN_MINUS,
          AC_FULL_STOP,
          AC_DIGIT_ZERO..AC_DIGIT_NINE,
          AC_COMMERCIAL_AT,
          AC_CAPITAL_A..AC_CAPITAL_Z,
          AC_LOW_LINE,
          AC_SMALL_A..AC_SMALL_Z:
          begin
            PDest^ := PSrc^;
            Inc(PDest);
          end;
        AC_SPACE:
          begin
            PDest^ := AC_PLUS_SIGN;
            Inc(PDest);
          end;
      else
        PDest^ := AC_PERCENT_SIGN;
        PDest[1] := AA_NUM_TO_HEX[Byte(PSrc^) shr 4];
        PDest[2] := AA_NUM_TO_HEX[Byte(PSrc^) and $0F];
        Inc(PDest, 3);
      end;

      Inc(PSrc); Dec(LSrc);
    end;

  SetLength(Result, Cardinal(PDest) - Cardinal(Result));
end;

procedure StrRemoveFromToIA(var Source: AnsiString; const FromString, ToString: AnsiString);
var
  l, lFromString, lToString: Cardinal;
  Dest, a2, b1, b2: Cardinal;
begin
  Dest := StrPosIA(FromString, Source);
  if Dest = 0 then Exit;

  if Pointer(FromString) = nil
    then
    lFromString := 0
  else
    lFromString := PCardinal(Cardinal(FromString) - 4)^;

  b1 := StrPosIA(ToString, Source, Dest + lFromString);
  if b1 = 0 then Exit;

  if Pointer(ToString) = nil
    then
    lToString := 0
  else
    lToString := PCardinal(Cardinal(ToString) - 4)^;
  Inc(b1, lToString);

  UniqueString(Source);

  while True do
    begin
      a2 := StrPosIA(FromString, Source, b1);
      if a2 = 0 then Break;

      b2 := StrPosIA(ToString, Source, a2 + lFromString);
      if b2 = 0 then Break;
      Inc(b2, lToString);

      System.Move(Source[b1], Source[Dest], a2 - b1);
      Inc(Dest, a2 - b1);
      b1 := b2;
    end;

  l := PCardinal(Cardinal(Source) - 4)^ - b1;

  System.Move(Source[b1], Source[Dest], l + 1);
  SetLength(Source, Dest + l);
end;

procedure StrRemoveFromToIW(var Source: WideString; const FromString, ToString: WideString);
var
  l, lFromString, lToString: Cardinal;
  Dest, a2, b1, b2: Cardinal;
begin
  Dest := StrPosIW(FromString, Source);
  if Dest = 0 then Exit;

  lFromString := Cardinal(FromString);
  if lFromString <> 0 then lFromString := PCardinal(lFromString - 4)^ shr 1;

  b1 := StrPosIW(ToString, Source, Dest + lFromString);
  if b1 = 0 then Exit;

  lToString := Cardinal(ToString);
  if lToString <> 0 then lToString := PCardinal(lToString - 4)^ shr 1;

  Inc(b1, lToString);

  while True do
    begin
      a2 := StrPosIW(FromString, Source, b1);
      if a2 = 0 then Break;

      b2 := StrPosIW(ToString, Source, a2 + lFromString);
      if b2 = 0 then Break;
      Inc(b2, lToString);

      System.Move(Source[b1], Source[Dest], (a2 - b1) * SizeOf(WideChar));
      Inc(Dest, a2 - b1);
      b1 := b2;
    end;

  l := PCardinal(Cardinal(Source) - 4)^ shr 1 - b1;

  System.Move(Source[b1], Source[Dest], (l + 1) * SizeOf(WideChar));
  SetLength(Source, Dest + l);
end;

procedure StrRemoveSpacing(var s: AnsiString; const SpaceChars: TAnsiCharSet = AS_WHITE_SPACE; const ReplaceChar: AnsiChar = AC_SPACE);
var
  i, l: Cardinal;
  PRead, PWrite: PAnsiChar;
begin
  PRead := Pointer(s);
  if PRead = nil then Exit;
  l := PCardinal(PRead - 4)^;

  i := l;

  while (i > 0) and not (PRead^ in SpaceChars) do
    begin
      Inc(PRead);
      Dec(i);
    end;

  if i = 0 then Exit;

  UniqueString(s);
  PRead := Pointer(Cardinal(s) + l - i);
  PWrite := PRead;

  while i > 0 do
    begin

      Inc(PRead);
      Dec(i);

      if PRead^ in SpaceChars then
        begin

          PWrite^ := ReplaceChar;
          Inc(PWrite);

          while (i > 0) and (PRead^ in SpaceChars) do
            begin
              Inc(PRead);
              Dec(i);
            end;
        end;

      while (i > 0) and not (PRead^ in SpaceChars) do
        begin
          PWrite^ := PRead^;
          Inc(PWrite);
          Inc(PRead);
          Dec(i);
        end;

    end;

  SetLength(s, Cardinal(PWrite) - Cardinal(s));
end;

procedure StrRemoveSpacing(var w: WideString; IsSpaceChar: TDIValidateWideCharFunc = nil; const ReplaceChar: WideChar = WC_SPACE);
var
  i, l: Cardinal;
  PRead, PWrite: PWideChar;
begin
  PRead := Pointer(w);
  if PRead = nil then Exit;
  l := PCardinal(PRead - 2)^ shr 1;

  if not Assigned(IsSpaceChar) then
    IsSpaceChar := CharIsWhiteSpaceW;

  i := l;

  while (i > 0) and not IsSpaceChar(PRead^) do
    begin
      Inc(PRead);
      Dec(i);
    end;

  if i = 0 then Exit;

  PWrite := PRead;

  while i > 0 do
    begin

      Inc(PRead);
      Dec(i);

      if IsSpaceChar(PRead^) then
        begin

          PWrite^ := ReplaceChar;
          Inc(PWrite);

          while (i > 0) and IsSpaceChar(PRead^) do
            begin
              Inc(PRead);
              Dec(i);
            end;
        end;

      while (i > 0) and not IsSpaceChar(PRead^) do
        begin
          PWrite^ := PRead^;
          Inc(PWrite);
          Inc(PRead);
          Dec(i);
        end;

    end;

  SetLength(w, (Cardinal(PWrite) - Cardinal(w)) shr 1);
end;

procedure StrReplaceCharA(var Source: AnsiString; const SearchChar, ReplaceChar: AnsiChar);
label
  One, Two, Three, Found;
var
  p: PAnsiChar;
  l, i: Cardinal;
begin
  p := Pointer(Source);
  if p = nil then Exit;
  l := PCardinal(p - 4)^;

  i := l;
  while i >= 4 do
    begin
      if p^ = SearchChar then goto Found;
      if p[1] = SearchChar then goto One;
      if p[2] = SearchChar then goto Two;
      if p[3] = SearchChar then goto Three;
      Inc(p, 4);
      Dec(i, 4);
    end;

  case i of
    3:
      begin
        if (p^ = SearchChar) then goto Found;
        if (p[1] = SearchChar) then goto One;
        if (p[2] = SearchChar) then goto Two;
      end;
    2:
      begin
        if (p^ = SearchChar) then goto Found;
        if (p[1] = SearchChar) then goto One;
      end;
    1:
      if (p^ = SearchChar) then goto Found;
  end;

  Exit;

  One:
  Dec(i);
  goto Found;

  Two:
  Dec(i, 2);
  goto Found;

  Three:
  Dec(i, 3);
  goto Found;

  Found:

  UniqueString(Source);
  p := Pointer(Source);
  if p = nil then Exit;
  Inc(p, l - i);

  p^ := ReplaceChar;
  Inc(p);
  Dec(i);

  while i >= 4 do
    begin
      if p^ = SearchChar then p^ := ReplaceChar;
      if p[1] = SearchChar then p[1] := ReplaceChar;
      if p[2] = SearchChar then p[2] := ReplaceChar;
      if p[3] = SearchChar then p[3] := ReplaceChar;
      Inc(p, 4);
      Dec(i, 4);
    end;

  case i of
    3:
      begin
        if p^ = SearchChar then p^ := ReplaceChar;
        if p[1] = SearchChar then p[1] := ReplaceChar;
        if p[2] = SearchChar then p[2] := ReplaceChar;
      end;
    2:
      begin
        if p^ = SearchChar then p^ := ReplaceChar;
        if p[1] = SearchChar then p[1] := ReplaceChar;
      end;
    1:
      begin
        if p^ = SearchChar then p^ := ReplaceChar;
      end;
  end;
end;

function StrReplaceA(const Source, Search, Replace: AnsiString): AnsiString;
label
  Zero, One, Two, Three, Four, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: AnsiChar;
  PSource, pSearch, pReplace, PResult, pTemp, pTempSource: PAnsiChar;
  lSearch, LSource, lReplace, lTemp: Cardinal;
begin

  PSource := Pointer(Source);
  if PSource = nil then goto ReturnEmptyString;

  pSearch := Pointer(Search);
  if pSearch = nil then goto ReturnSourceString;

  LSource := PCardinal(Cardinal(PSource) - 4)^;
  lSearch := PCardinal(Cardinal(pSearch) - 4)^;

  if lSearch > LSource then goto ReturnSourceString;

  pReplace := Pointer(Replace);
  lReplace := Cardinal(pReplace);
  if lReplace <> 0 then lReplace := PCardinal(lReplace - 4)^;

  if lSearch > lReplace then
    SetLength(Result, LSource)
  else
    SetLength(Result, (LSource div lSearch) * lReplace + LSource mod lSearch);
  PResult := Pointer(Result);

  Dec(lSearch);

  while LSource > lSearch do
    begin

      c := pSearch^;
      while LSource >= 4 do
        begin
          if PSource^ = c then goto Zero;
          if PSource[1] = c then goto One;
          if PSource[2] = c then goto Two;
          if PSource[3] = c then goto Three;
          Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
          Inc(PSource, 4);
          Inc(PResult, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            if PSource[2] = c then goto Two;
            Word(Pointer(PResult)^) := Word(Pointer(PSource)^); PResult[2] := PSource[2];
            Inc(PResult, 3);
            Dec(LSource, 3);
          end;
        2:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
            Inc(PResult, 2);
            Dec(LSource, 2);
          end;
        1:
          begin
            if PSource^ = c then goto Zero;
            PResult^ := PSource^;
            Inc(PResult);
            Dec(LSource);
          end;
      end;

      Break;

      Three:
      Word(Pointer(PResult)^) := Word(Pointer(PSource)^); PResult[2] := PSource[2];
      Inc(PSource, 4);
      Inc(PResult, 3);
      Dec(LSource, 4);
      goto Match;

      Two:
      Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
      Inc(PSource, 3);
      Inc(PResult, 2);
      Dec(LSource, 3);
      goto Match;

      One:
      PResult^ := PSource^;
      Inc(PSource, 2);
      Inc(PResult);
      Dec(LSource, 2);
      goto Match;

      Zero:
      Inc(PSource);
      Dec(LSource);

      Match:

      pTempSource := PSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (pTempSource^ = pTemp^) and
        (pTempSource[1] = pTemp[1]) and
        (pTempSource[2] = pTemp[2]) and
        (pTempSource[3] = pTemp[3]) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if ((lTemp = 1) and (pTempSource^ = pTemp^)) then goto Copy;
      if ((lTemp = 2) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1])) then goto Copy;
      if ((lTemp = 3) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) and (pTempSource[2] = pTemp[2])) then goto Copy;

      PResult^ := pSearch^;
      Inc(PResult);

      Continue;

      Copy:

      lTemp := lReplace;
      pTemp := pReplace;
      while lTemp >= 4 do
        begin
          Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
          Inc(PResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Word(Pointer(PResult)^) := Word(Pointer(pTemp)^);
            PResult[2] := pTemp[2];
            Inc(PResult, 3)
          end;
        2:
          begin
            Word(Pointer(PResult)^) := Word(Pointer(pTemp)^);
            Inc(PResult, 2);
          end;
        1:
          begin
            PResult^ := pTemp^;
            Inc(PResult);
          end;
      end;

      Inc(PSource, lSearch);
      Dec(LSource, lSearch);
    end;

  while LSource >= 4 do
    begin
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      Inc(PResult, 4);
      Inc(PSource, 4);
      Dec(LSource, 4);
    end;
  case LSource of
    3:
      begin
        Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
        PResult[2] := PSource[2];
        Inc(PResult, 3)
      end;
    2:
      begin
        Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
        Inc(PResult, 2);
      end;
    1:
      begin
        PResult^ := PSource^;
        Inc(PResult);
      end;
  end;

  SetLength(Result, Cardinal(PResult) - Cardinal(Result));
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrReplaceW(const Source, Search, Replace: WideString): WideString;
label
  Zero, One, Two, Three, Four, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: WideChar;
  PSource, pSearch, pReplace, PResult, pTemp, pTempSource: PWideChar;
  lSearch, LSource, lReplace, lTemp: Cardinal;
begin

  PSource := Pointer(Source);
  LSource := Cardinal(PSource);
  if LSource = 0 then goto ReturnEmptyString;

  pSearch := Pointer(Search);
  lSearch := Cardinal(pSearch);
  if lSearch = 0 then goto ReturnSourceString;

  LSource := PCardinal(LSource - 4)^ shr 1;
  lSearch := PCardinal(lSearch - 4)^ shr 1;

  if lSearch > LSource then goto ReturnSourceString;

  pReplace := Pointer(Replace);
  lReplace := Cardinal(pReplace);
  if lReplace <> 0 then lReplace := PCardinal(lReplace - 4)^ shr 1;

  if lSearch >= lReplace then
    SetString(Result, nil, LSource)
  else
    SetLength(Result, (LSource div lSearch) * lReplace + LSource mod lSearch);
  PResult := Pointer(Result);

  Dec(lSearch);

  while LSource > lSearch do
    begin

      c := pSearch^;
      while LSource >= 4 do
        begin
          if PSource^ = c then goto Zero;
          if PSource[1] = c then goto One;
          if PSource[2] = c then goto Two;
          if PSource[3] = c then goto Three;
          Int64(Pointer(PResult)^) := Int64(Pointer(PSource)^);
          Inc(PSource, 4);
          Inc(PResult, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            if PSource[2] = c then goto Two;
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
            PResult[2] := PSource[2];
            Inc(PResult, 3);
            Dec(LSource, 3);
          end;
        2:
          begin
            if PSource^ = c then goto Zero;
            if PSource[1] = c then goto One;
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
            Inc(PResult, 2);
            Dec(LSource, 2);
          end;
        1:
          begin
            if PSource^ = c then goto Zero;
            PResult^ := PSource^;
            Inc(PResult);
            Dec(LSource);
          end;
      end;

      Break;

      Three:
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      PResult[2] := PSource[2];
      Inc(PSource, 4);
      Inc(PResult, 3);
      Dec(LSource, 4);
      goto Match;

      Two:
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      Inc(PSource, 3);
      Inc(PResult, 2);
      Dec(LSource, 3);
      goto Match;

      One:
      PResult^ := PSource^;
      Inc(PSource, 2);
      Inc(PResult);
      Dec(LSource, 2);
      goto Match;

      Zero:
      Inc(PSource);
      Dec(LSource);

      Match:

      pTempSource := PSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (pTempSource^ = pTemp^) and
        (pTempSource[1] = pTemp[1]) and
        (pTempSource[2] = pTemp[2]) and
        (pTempSource[3] = pTemp[3]) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if (lTemp = 1) and (pTempSource^ = pTemp^) then goto Copy;
      if (lTemp = 2) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) then goto Copy;
      if (lTemp = 3) and (pTempSource^ = pTemp^) and (pTempSource[1] = pTemp[1]) and (pTempSource[2] = pTemp[2]) then goto Copy;

      PResult^ := PSource[-1];
      Inc(PResult);

      Continue;

      Copy:

      lTemp := lReplace;
      pTemp := pReplace;
      while lTemp >= 4 do
        begin
          Int64(Pointer(PResult)^) := Int64(Pointer(pTemp)^);
          Inc(PResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
            PResult[2] := pTemp[2];
            Inc(PResult, 3)
          end;
        2:
          begin
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
            Inc(PResult, 2);
          end;
        1:
          begin
            PResult^ := pTemp^;
            Inc(PResult);
          end;
      end;

      Inc(PSource, lSearch);
      Dec(LSource, lSearch);
    end;

  while LSource >= 4 do
    begin
      Int64(Pointer(PResult)^) := Int64(Pointer(PSource)^);
      Inc(PResult, 4);
      Inc(PSource, 4);
      Dec(LSource, 4);
    end;
  case LSource of
    3:
      begin
        Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
        PResult[2] := PSource[2];
        Inc(PResult, 3)
      end;
    2:
      begin
        Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
        Inc(PResult, 2);
      end;
    1:
      begin
        PResult^ := PSource^;
        Inc(PResult);
      end;
  end;

  SetLength(Result, (Cardinal(PResult) - Cardinal(Result)) shr 1);
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrReplaceIA(const Source, Search, Replace: AnsiString): AnsiString;
label
  Zero, One, Two, Three, Four, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: AnsiChar;
  PSource, pSearch, pReplace, PResult, pTemp, pTempSource: PAnsiChar;
  lSearch, LSource, lReplace, lTemp: Cardinal;
begin

  PSource := Pointer(Source);
  if PSource = nil then goto ReturnEmptyString;

  pSearch := Pointer(Search);
  if pSearch = nil then goto ReturnSourceString;

  LSource := PCardinal(Cardinal(PSource) - 4)^;
  lSearch := PCardinal(Cardinal(pSearch) - 4)^;

  if lSearch > LSource then goto ReturnSourceString;

  pReplace := Pointer(Replace);
  lReplace := Cardinal(pReplace);
  if lReplace <> 0 then lReplace := PCardinal(lReplace - 4)^;

  if lSearch > lReplace then
    SetLength(Result, LSource)
  else
    SetLength(Result, (LSource div lSearch) * lReplace + LSource mod lSearch);
  PResult := Pointer(Result);

  Dec(lSearch);

  while LSource > lSearch do
    begin

      c := ANSI_UPPER_CHAR_TABLE[pSearch^];
      while LSource >= 4 do
        begin
          if ANSI_UPPER_CHAR_TABLE[PSource^] = c then goto Zero;
          if ANSI_UPPER_CHAR_TABLE[PSource[1]] = c then goto One;
          if ANSI_UPPER_CHAR_TABLE[PSource[2]] = c then goto Two;
          if ANSI_UPPER_CHAR_TABLE[PSource[3]] = c then goto Three;
          Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
          Inc(PSource, 4);
          Inc(PResult, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if ANSI_UPPER_CHAR_TABLE[PSource^] = c then goto Zero;
            if ANSI_UPPER_CHAR_TABLE[PSource[1]] = c then goto One;
            if ANSI_UPPER_CHAR_TABLE[PSource[2]] = c then goto Two;
            Word(Pointer(PResult)^) := Word(Pointer(PSource)^); PResult[2] := PSource[2];
            Inc(PResult, 3);
            Dec(LSource, 3);
          end;
        2:
          begin
            if ANSI_UPPER_CHAR_TABLE[PSource^] = c then goto Zero;
            if ANSI_UPPER_CHAR_TABLE[PSource[1]] = c then goto One;
            Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
            Inc(PResult, 2);
            Dec(LSource, 2);
          end;
        1:
          begin
            if ANSI_UPPER_CHAR_TABLE[PSource^] = c then goto Zero;
            PResult^ := PSource^;
            Inc(PResult);
            Dec(LSource);
          end;
      end;

      Break;

      Three:
      Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
      PResult[2] := PSource[2];
      Inc(PSource, 4);
      Inc(PResult, 3);
      Dec(LSource, 4);
      goto Match;

      Two:
      Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
      Inc(PSource, 3);
      Inc(PResult, 2);
      Dec(LSource, 3);
      goto Match;

      One:
      PResult^ := PSource^;
      Inc(PSource, 2);
      Inc(PResult);
      Dec(LSource, 2);
      goto Match;

      Zero:
      Inc(PSource);
      Dec(LSource);

      Match:

      pTempSource := PSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and
        ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]])) and
        ((pTempSource[2] = pTemp[2]) or (pTempSource[2] = ANSI_REVERSE_CHAR_TABLE[pTemp[2]])) and
        ((pTempSource[3] = pTemp[3]) or (pTempSource[3] = ANSI_REVERSE_CHAR_TABLE[pTemp[3]])) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if ((lTemp = 1) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^]))) then goto Copy;
      if ((lTemp = 2) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]]))) then goto Copy;
      if ((lTemp = 3) and ((pTempSource^ = pTemp^) or (pTempSource^ = ANSI_REVERSE_CHAR_TABLE[pTemp^])) and ((pTempSource[1] = pTemp[1]) or (pTempSource[1] = ANSI_REVERSE_CHAR_TABLE[pTemp[1]])) and ((pTempSource[2] = pTemp[2]) or (pTempSource[2] = ANSI_REVERSE_CHAR_TABLE[pTemp[2]]))) then goto Copy;

      PResult^ := PSource[-1];
      Inc(PResult);

      Continue;

      Copy:

      lTemp := lReplace;
      pTemp := pReplace;
      while lTemp >= 4 do
        begin
          Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
          Inc(PResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Word(Pointer(PResult)^) := Word(Pointer(pTemp)^);
            PResult[2] := pTemp[2];
            Inc(PResult, 3)
          end;
        2:
          begin
            Word(Pointer(PResult)^) := Word(Pointer(pTemp)^);
            Inc(PResult, 2);
          end;
        1:
          begin
            PResult^ := pTemp^;
            Inc(PResult);
          end;
      end;

      Inc(PSource, lSearch);
      Dec(LSource, lSearch);
    end;

  while LSource >= 4 do
    begin
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      Inc(PResult, 4);
      Inc(PSource, 4);
      Dec(LSource, 4);
    end;
  case LSource of
    3:
      begin
        Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
        PResult[2] := PSource[2];
        Inc(PResult, 3)
      end;
    2:
      begin
        Word(Pointer(PResult)^) := Word(Pointer(PSource)^);
        Inc(PResult, 2);
      end;
    1:
      begin
        PResult^ := PSource^;
        Inc(PResult);
      end;
  end;

  SetLength(Result, Cardinal(PResult) - Cardinal(Result));
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrReplaceIW(const Source, Search, Replace: WideString): WideString;
label
  Zero, One, Two, Three, Four, Match, Copy, ReturnSourceString, ReturnEmptyString;
var
  c: WideChar;
  PSource, pSearch, pReplace, PResult, pTemp, pTempSource: PWideChar;
  lSearch, LSource, lReplace, lTemp: Cardinal;
begin

  PSource := Pointer(Source);
  LSource := Cardinal(PSource);
  if LSource = 0 then goto ReturnEmptyString;

  pSearch := Pointer(Search);
  lSearch := Cardinal(pSearch);
  if lSearch = 0 then goto ReturnSourceString;

  LSource := PCardinal(LSource - 4)^ shr 1;
  lSearch := PCardinal(lSearch - 4)^ shr 1;

  if lSearch > LSource then goto ReturnSourceString;

  pReplace := Pointer(Replace);
  lReplace := Cardinal(pReplace);
  if lReplace <> 0 then lReplace := PCardinal(lReplace - 4)^ shr 1;

  if lSearch >= lReplace then
    SetString(Result, nil, LSource)
  else
    SetLength(Result, (LSource div lSearch) * lReplace + LSource mod lSearch);
  PResult := Pointer(Result);

  Dec(lSearch);

  while LSource > lSearch do
    begin

      c := CharToCaseFoldW(pSearch^);
      while LSource >= 4 do
        begin
          if CharToCaseFoldW(PSource^) = c then goto Zero;
          if CharToCaseFoldW(PSource[1]) = c then goto One;
          if CharToCaseFoldW(PSource[2]) = c then goto Two;
          if CharToCaseFoldW(PSource[3]) = c then goto Three;
          Int64(Pointer(PResult)^) := Int64(Pointer(PSource)^);
          Inc(PSource, 4);
          Inc(PResult, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
            if CharToCaseFoldW(PSource[1]) = c then goto One;
            if CharToCaseFoldW(PSource[2]) = c then goto Two;
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
            PResult[2] := PSource[2];
            Inc(PResult, 3);
            Dec(LSource, 3);
          end;
        2:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
            if CharToCaseFoldW(PSource[1]) = c then goto One;
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
            Inc(PResult, 2);
            Dec(LSource, 2);
          end;
        1:
          begin
            if CharToCaseFoldW(PSource^) = c then goto Zero;
            PResult^ := PSource^;
            Inc(PResult);
            Dec(LSource);
          end;
      end;

      Break;

      Three:
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      PResult[2] := PSource[2];
      Inc(PSource, 4);
      Inc(PResult, 3);
      Dec(LSource, 4);
      goto Match;

      Two:
      Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
      Inc(PSource, 3);
      Inc(PResult, 2);
      Dec(LSource, 3);
      goto Match;

      One:
      PResult^ := PSource^;
      Inc(PSource, 2);
      Inc(PResult);
      Dec(LSource, 2);
      goto Match;

      Zero:
      Inc(PSource);
      Dec(LSource);

      Match:

      pTempSource := PSource;
      pTemp := pSearch + 1;
      lTemp := lSearch;

      while (lTemp >= 4) and
        (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and
        (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) and
        (CharToCaseFoldW(pTempSource[2]) = CharToCaseFoldW(pTemp[2])) and
        (CharToCaseFoldW(pTempSource[3]) = CharToCaseFoldW(pTemp[3])) do
        begin
          Inc(pTempSource, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      if (lTemp = 0) then goto Copy;
      if (lTemp = 1) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) then goto Copy;
      if (lTemp = 2) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) then goto Copy;
      if (lTemp = 3) and (CharToCaseFoldW(pTempSource^) = CharToCaseFoldW(pTemp^)) and (CharToCaseFoldW(pTempSource[1]) = CharToCaseFoldW(pTemp[1])) and (CharToCaseFoldW(pTempSource[2]) = CharToCaseFoldW(pTemp[2])) then goto Copy;

      PResult^ := PSource[-1];
      Inc(PResult);

      Continue;

      Copy:

      lTemp := lReplace;
      pTemp := pReplace;
      while lTemp >= 4 do
        begin
          Int64(Pointer(PResult)^) := Int64(Pointer(pTemp)^);
          Inc(PResult, 4);
          Inc(pTemp, 4);
          Dec(lTemp, 4);
        end;

      case lTemp of
        3:
          begin
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
            PResult[2] := pTemp[2];
            Inc(PResult, 3)
          end;
        2:
          begin
            Cardinal(Pointer(PResult)^) := Cardinal(Pointer(pTemp)^);
            Inc(PResult, 2);
          end;
        1:
          begin
            PResult^ := pTemp^;
            Inc(PResult);
          end;
      end;

      Inc(PSource, lSearch);
      Dec(LSource, lSearch);
    end;

  while LSource >= 4 do
    begin
      Int64(Pointer(PResult)^) := Int64(Pointer(PSource)^);
      Inc(PResult, 4);
      Inc(PSource, 4);
      Dec(LSource, 4);
    end;
  case LSource of
    3:
      begin
        Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
        PResult[2] := PSource[2];
        Inc(PResult, 3)
      end;
    2:
      begin
        Cardinal(Pointer(PResult)^) := Cardinal(Pointer(PSource)^);
        Inc(PResult, 2);
      end;
    1:
      begin
        PResult^ := PSource^;
        Inc(PResult);
      end;
  end;

  SetLength(Result, (Cardinal(PResult) - Cardinal(Result)) shr 1);
  Exit;

  ReturnSourceString:
  Result := Source;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function StrReplaceLoopA(const Source, Search, Replace: AnsiString): AnsiString;
begin
  Result := Source;
  while StrPosA(Search, Result) > 0 do
    Result := StrReplaceA(Result, Search, Replace);
end;

function StrReplaceLoopW(const Source, Search, Replace: WideString): WideString;
begin
  Result := Source;
  while StrPosW(Search, Result) > 0 do
    Result := StrReplaceW(Result, Search, Replace);
end;

function StrReplaceLoopIA(const Source, Search, Replace: AnsiString): AnsiString;
begin
  Result := Source;
  while StrPosIA(Search, Result) > 0 do
    Result := StrReplaceIA(Result, Search, Replace);
end;

function StrReplaceLoopIW(const Source, Search, Replace: WideString): WideString;
begin
  Result := Source;
  while StrPosIW(Search, Result) > 0 do
    Result := StrReplaceIW(Result, Search, Replace);
end;

function RightMostBit(const Value: Cardinal): Integer;
asm
  MOV ECX, EAX
  MOV EAX, -1
  BSF EAX, ECX
end;

function StrSameA(const s1, s2: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  p2 := Pointer(s2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 4)^;
  l2 := PCardinal(p2 - 4)^;

  if l1 <> l2 then goto Fail;

  while l1 >= 4 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrSameW(const s1, s2: WideString): Boolean;
label
  Fail, Match;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  p2 := Pointer(s2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 2)^;
  l2 := PCardinal(p2 - 2)^;

  if l1 <> l2 then goto Fail;

  l1 := l1 shr 1;
  while l1 >= 2 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 2);
      Inc(p2, 2);
      Dec(l1, 2);
    end;

  if (l1 = 1) and (p1^ <> p2^) then goto Fail;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrSameIA(const s1, s2: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  p2 := Pointer(s2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 4)^;
  l2 := PCardinal(p2 - 4)^;

  if l1 <> l2 then goto Fail;

  while l1 >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
        (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
          (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Fail;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto Fail;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrSameIW(const s1, s2: WideString): Boolean;
label
  Fail, Match;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  p2 := Pointer(s2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 2)^;
  l2 := PCardinal(p2 - 2)^;

  if l1 <> l2 then goto Fail;

  l1 := l1 shr 1;
  while l1 >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrSameStartA(const s1, s2: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  p2 := Pointer(s2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 4)^;
  l2 := PCardinal(p2 - 4)^;

  if l1 > l2 then l1 := l2;

  while l1 >= 4 do
    begin
      if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if PWord(p1)^ <> PWord(p2)^ then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrSameStartW(const w1, w2: WideString): Boolean;
label
  Fail, Match;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(w1);
  p2 := Pointer(w2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 2)^;
  l2 := PCardinal(p2 - 2)^;

  if l1 > l2 then l1 := l2;

  l1 := l1 shr 1;
  while l1 >= 4 do
    begin
      if PInt64(p1)^ <> PInt64(p2)^ then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
        if (p1[2] <> p2[2]) then goto Fail;
      end;
    2:
      begin
        if PCardinal(p1)^ <> PCardinal(p2)^ then goto Fail;
      end;
    1:
      begin
        if (p1^ <> p2^) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrSameStartIA(const s1, s2: AnsiString): Boolean;
label
  Fail, Match;
var
  p1, p2: PAnsiChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  p2 := Pointer(s2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 4)^;
  l2 := PCardinal(p2 - 4)^;

  if l1 > l2 then l1 := l2;

  while l1 >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
        (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) or
        (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) or
          (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Fail;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) or
          (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto Fail;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Fail;
      end;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrSameStartIW(const w1, w2: WideString): Boolean;
label
  Fail, Match;
var
  p1, p2: PWideChar;
  l1, l2: Cardinal;
begin
  p1 := Pointer(w1);
  p2 := Pointer(w2);
  if p1 = p2 then goto Match;

  if p1 = nil then goto Fail;
  if p2 = nil then goto Fail;

  l1 := PCardinal(p1 - 2)^;
  l2 := PCardinal(p2 - 2)^;

  if l1 > l2 then l1 := l2;

  l1 := l1 shr 1;
  while l1 >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto Fail;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l1, 4);
    end;

  case l1 of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto Fail;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto Fail;
      end;
    1:
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto Fail;
  end;

  Match:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

{$IFDEF MSWINDOWS}
function LoadStrFromFile(const FileHandle: THandle; var s: AnsiString): Boolean; overload;
var
  FileSize, NumberOfBytesRead: DWORD;
begin
  FileSize := GetFileSize(FileHandle, nil);
  if FileSize <> $FFFFFFFF then
    begin
      SetLength(s, FileSize);
      Result := ReadFile(FileHandle, Pointer(s)^, FileSize, NumberOfBytesRead, nil) and
        (FileSize = NumberOfBytesRead);
      if not Result then SetLength(s, NumberOfBytesRead);
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF LINUX}
function LoadStrFromFile(const FileHandle: Integer; var s: AnsiString): Boolean; overload;
var
  StatBuffer: _stat;
  FileSize, NumberOfBytesRead: Integer;
begin
  if fstat(FileHandle, StatBuffer) = 0 then
    begin
      FileSize := StatBuffer.st_size;
      SetLength(s, FileSize);
      NumberOfBytesRead := __read(FileHandle, Pointer(s)^, FileSize);
      Result := FileSize = NumberOfBytesRead;
      if not Result then
        SetLength(s, NumberOfBytesRead);
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function LoadStrFromFileA(const FileName: AnsiString; var s: AnsiString): Boolean; overload;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := LoadStrFromFile(FileHandle, s);
      Result := Result and CloseHandle(FileHandle);
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF LINUX}
function LoadStrFromFileA(const FileName: AnsiString; var s: AnsiString): Boolean; overload;
var
  FileHandle: Integer;
begin
  FileHandle := open(PAnsiChar(FileName), O_RDONLY or F_RDLCK, FileAccessRights);
  if FileHandle <> -1 then
    begin
      Result := LoadStrFromFile(FileHandle, s);
      Result := Result and (__Close(FileHandle) = 0);
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function LoadStrFromFileW(const FileName: WideString; var s: AnsiString): Boolean; overload;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := LoadStrFromFile(FileHandle, s);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := LoadStrFromFileA(FileName, s);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function LoadStrFromFile(const FileHandle: THandle; var s: WideString): Boolean; overload;
label
  ReturnFalse;
var
  FileSize, NumberOfBytesRead: DWORD;
begin
  FileSize := GetFileSize(FileHandle, nil);
  if FileSize <> $FFFFFFFF then
    begin
      FileSize := FileSize and not 1;
      SetLength(s, FileSize shr 1);
      Result := ReadFile(FileHandle, Pointer(s)^, FileSize, NumberOfBytesRead, nil) and
        (FileSize = NumberOfBytesRead);
      if not Result then SetLength(s, NumberOfBytesRead shr 1);
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF LINUX}
function LoadStrFromFile(const FileHandle: Integer; var s: WideString): Boolean; overload;
var
  StatBuffer: _stat;
  FileSize, NumberOfBytesRead: Integer;
begin
  if fstat(FileHandle, StatBuffer) = 0 then
    begin
      FileSize := StatBuffer.st_size and not 1;
      SetLength(s, FileSize shr 1);
      NumberOfBytesRead := __read(FileHandle, Pointer(s)^, FileSize);
      Result := FileSize = NumberOfBytesRead;
      if not Result then
        SetLength(s, NumberOfBytesRead);
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function LoadStrFromFileA(const FileName: AnsiString; var s: WideString): Boolean; overload;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := LoadStrFromFile(FileHandle, s);
      Result := CloseHandle(FileHandle) and Result;
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF LINUX}
function LoadStrFromFileA(const FileName: AnsiString; var s: WideString): Boolean; overload;
var
  FileHandle: Integer;
begin
  FileHandle := open(PAnsiChar(FileName), O_RDONLY or F_RDLCK, FileAccessRights);
  if FileHandle <> -1 then
    begin
      Result := LoadStrFromFile(s, FileHandle);
      Result := Result and (__Close(FileHandle) = 0);
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function LoadStrFromFileW(const FileName: WideString; var s: WideString): Boolean; overload;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := LoadStrFromFile(FileHandle, s);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := LoadStrFromFileA(FileName, s);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SaveBufToFile(const Buffer; const BufferSize: Cardinal; const FileHandle: THandle): Boolean;
var
  NumberOfBytesWritten: DWORD;
begin
  Result := WriteFile(FileHandle, Buffer, BufferSize, NumberOfBytesWritten, nil) and (BufferSize = NumberOfBytesWritten);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SaveBufToFileA(const Buffer; const BufferSize: Cardinal; const FileName: AnsiString): Boolean;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
  if FileHandle <> INVALID_HANDLE_VALUE then
    begin
      Result := SaveBufToFile(Buffer, BufferSize, FileHandle);
      Result := CloseHandle(FileHandle) and Result;
    end
  else
    Result := False;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SaveBufToFileW(const Buffer; const BufferSize: Cardinal; const FileName: WideString): Boolean;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL or FILE_FLAG_SEQUENTIAL_SCAN, 0);
      if FileHandle <> INVALID_HANDLE_VALUE then
        begin
          Result := SaveBufToFile(Buffer, BufferSize, FileHandle);
          Result := CloseHandle(FileHandle) and Result;
        end
      else
        Result := False;
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SaveBufToFileA(Buffer, BufferSize, FileName);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SaveStrAToFileA(const s: AnsiString; const FileName: AnsiString): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := SaveBufToFileA(Pointer(s)^, l, FileName);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SaveStrAToFileW(const s: AnsiString; const FileName: WideString): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := SaveBufToFileW(Pointer(s)^, l, FileName);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SaveStrWToFileA(const w: WideString; const FileName: AnsiString): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := SaveBufToFileA(Pointer(w)^, l, FileName);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SaveStrWToFileW(const w: WideString; const FileName: WideString): Boolean;
var
  l: Cardinal;
begin
  l := Cardinal(w);
  if l <> 0 then l := PCardinal(l - 4)^;
  Result := SaveBufToFileW(Pointer(w)^, l, FileName);
end;
{$ENDIF}

function StrPosCharA(const Source: AnsiString; const c: AnsiChar; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  l := Cardinal(p);
  if l = 0 then goto Fail;
  l := PCardinal(l - 4)^;
  if (Start = 0) or (Start > l) then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[1] = c then goto One;
      if p[2] = c then goto Two;
      if p[3] = c then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[1] = c) then goto One;
        if (p[2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source) + 2;
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) + 3;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) + 4;
end;

function StrPosCharW(const Source: WideString; const c: WideChar; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(Source);
  l := Cardinal(p);
  if l = 0 then goto Fail;
  l := PCardinal(l - 4)^ shr 1;
  if (Start = 0) or (Start > l) then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[1] = c then goto One;
      if p[2] = c then goto Two;
      if p[3] = c then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ = c then goto Zero;
        if p[1] = c then goto One;
        if p[2] = c then goto Two;
      end;
    2:
      begin
        if p^ = c then goto Zero;
        if p[1] = c then goto One;
      end;
    1:
      if p^ = c then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 1;
  Exit;

  One:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 2;
  Exit;

  Two:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 3;
  Exit;

  Three:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 4;
end;

function StrPosCharBackA(const Source: AnsiString; const c: AnsiChar; const Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;

  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  if Start <> 0 then l := Start;

  Inc(p, l - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[-1] = c then goto One;
      if p[-2] = c then goto Two;
      if p[-3] = c then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
        if (p[-2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source);
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) - 1;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) - 2;
end;

function StrPosCharBackW(const Source: WideString; const c: WideChar; const Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;
  l := PCardinal(p - 2)^ shr 1;
  if Start > l then goto Fail;
  if Start <> 0 then l := Start;

  Inc(p, l - 1);

  while l >= 4 do
    begin
      if p^ = c then goto Zero;
      if p[-1] = c then goto One;
      if p[-2] = c then goto Two;
      if p[-3] = c then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
        if (p[-2] = c) then goto Two;
      end;
    2:
      begin
        if (p^ = c) then goto Zero;
        if (p[-1] = c) then goto One;
      end;
    1:
      if (p^ = c) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 1;
  Exit;

  One:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1;
  Exit;

  Two:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 - 1;
  Exit;

  Three:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 - 2;
end;

function StrPosCharsA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  l := Cardinal(p);
  if l = 0 then goto Fail;
  l := PCardinal(l - 4)^;
  if (Start = 0) or (Start > l) then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[1] in Search then goto One;
      if p[2] in Search then goto Two;
      if p[3] in Search then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
        if (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source) + 2;
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) + 3;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) + 4;
end;

function StrPosCharsW(const Source: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(Source);
  l := Cardinal(p);
  if l = 0 then goto Fail;
  l := PCardinal(l - 4)^ shr 1;
  if (Start = 0) or (Start > l) then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if Validate(p^) then goto Zero;
      if Validate(p[1]) then goto One;
      if Validate(p[2]) then goto Two;
      if Validate(p[3]) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if Validate(p^) then goto Zero;
        if Validate(p[1]) then goto One;
        if Validate(p[2]) then goto Two;
      end;
    2:
      begin
        if Validate(p^) then goto Zero;
        if Validate(p[1]) then goto One;
      end;
    1:
      if Validate(p^) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 1;
  Exit;

  One:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 2;
  Exit;

  Two:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 3;
  Exit;

  Three:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 4;
end;

function StrPosCharsBackA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;

  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  if Start <> 0 then l := Start;

  Inc(p, l - 1);

  while l >= 4 do
    begin
      if p^ in Search then goto Zero;
      if p[-1] in Search then goto One;
      if p[-2] in Search then goto Two;
      if p[-3] in Search then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p^ in Search) then goto Zero;
        if (p[-1] in Search) then goto One;
        if (p[-2] in Search) then goto Two;
      end;
    2:
      begin
        if (p^ in Search) then goto Zero;
        if (p[-1] in Search) then goto One;
      end;
    1:
      if (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source);
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) - 1;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) - 2;
end;

function StrPosNotCharsA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if not (p^ in Search) then goto Zero;
      if not (p[1] in Search) then goto One;
      if not (p[2] in Search) then goto Two;
      if not (p[3] in Search) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[1] in Search) then goto One;
        if not (p[2] in Search) then goto Two;
      end;
    2:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[1] in Search) then goto One;
      end;
    1:
      if not (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source) + 2;
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) + 3;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) + 4;
end;

function StrPosNotCharsW(const Source: WideString; const Validate: TDIValidateWideCharFunc; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;
  if Start = 0 then goto Fail;
  l := PCardinal(p - 2)^ shr 1;
  if Start > l then goto Fail;

  Inc(p, Start - 1);
  Dec(l, Start - 1);

  while l >= 4 do
    begin
      if not Validate(p^) then goto Zero;
      if not Validate(p[1]) then goto One;
      if not Validate(p[2]) then goto Two;
      if not Validate(p[3]) then goto Three;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not Validate(p^) then goto Zero;
        if not Validate(p[1]) then goto One;
        if not Validate(p[2]) then goto Two;
      end;
    2:
      begin
        if not Validate(p^) then goto Zero;
        if not Validate(p[1]) then goto One;
      end;
    1:
      if not Validate(p^) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 1;
  Exit;

  One:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 2;
  Exit;

  Two:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 3;
  Exit;

  Three:
  Result := (Cardinal(p) - Cardinal(Source)) shr 1 + 4;
end;

function StrPosNotCharsBackA(const Source: AnsiString; const Search: TAnsiCharSet; const Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Fail;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto Fail;

  l := PCardinal(p - 4)^;
  if Start > l then goto Fail;

  if Start <> 0 then l := Start;

  Inc(p, l - 1);

  while l >= 4 do
    begin
      if not (p^ in Search) then goto Zero;
      if not (p[-1] in Search) then goto One;
      if not (p[-2] in Search) then goto Two;
      if not (p[-3] in Search) then goto Three;
      Dec(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[-1] in Search) then goto One;
        if not (p[-2] in Search) then goto Two;
      end;
    2:
      begin
        if not (p^ in Search) then goto Zero;
        if not (p[-1] in Search) then goto One;
      end;
    1:
      if not (p^ in Search) then goto Zero;
  end;

  Fail:
  Result := 0;
  Exit;

  Zero:
  Result := Cardinal(p) - Cardinal(Source) + 1;
  Exit;

  One:
  Result := Cardinal(p) - Cardinal(Source);
  Exit;

  Two:
  Result := Cardinal(p) - Cardinal(Source) - 1;
  Exit;

  Three:
  Result := Cardinal(p) - Cardinal(Source) - 2;
end;

{$IFDEF MSWINDOWS}
function SetFileDate(const FileHandle: THandle; const Year: Integer; const Month, Day: Word): Boolean;
var
  SystemTime: TSystemTime;
  FileTime: TFileTime;
begin
  with SystemTime do
    begin
      wYear := Year;
      wMonth := Month;
      wDay := Day;
      wHour := 12;
      wMinute := 0;
      wSecond := 0;
      wMilliSeconds := 0;
    end;
  Result :=
    SystemTimeToFileTime(SystemTime, FileTime) and
    SetFileTime(FileHandle, @FileTime, @FileTime, @FileTime);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SetFileDateA(const FileName: AnsiString; const JulianDate: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := SetFileDateA(FileName, Year, Month, Day);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SetFileDateA(const FileName: AnsiString; const Year: Integer; const Month, Day: Word): Boolean;
var
  FileHandle: THandle;
begin
  FileHandle := CreateFileA(PAnsiChar(FileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (FileHandle <> INVALID_HANDLE_VALUE) and
    SetFileDate(FileHandle, Year, Month, Day) and
    CloseHandle(FileHandle);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SetFileDateW(const FileName: WideString; const JulianDate: TJulianDate): Boolean;
var
  Year: Integer;
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Year, Month, Day);
  Result := SetFileDateW(FileName, Year, Month, Day);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SetFileDateW(const FileName: WideString; const Year: Integer; const Month, Day: Word): Boolean;
var
  FileHandle: THandle;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      FileHandle := CreateFileW(PWideChar(FileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      Result := (FileHandle <> INVALID_HANDLE_VALUE) and
        SetFileDate(FileHandle, Year, Month, Day) and
        CloseHandle(FileHandle);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SetFileDateA(FileName, Year, Month, Day);
  {$ENDIF}
end;
{$ENDIF}

function StrCompA(const s1, s2: AnsiString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PAnsiChar;
  l, l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^;

  p2 := Pointer(s2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^;

  if l1 > l2 then
    l := l2
  else
    l := l1;

  while l >= 4 do
    begin
      if p1^ <> p2^ then goto 0;
      if p1[1] <> p2[1] then goto 1;
      if p1[2] <> p2[2] then goto 2;
      if p1[3] <> p2[3] then goto 3;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
        if p1[2] <> p2[2] then goto 2;
      end;
    2:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
      end;
    1:
      begin
        if p1^ <> p2^ then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(p1^) - Ord(p2^);
  Exit;

  1:
  Result := Ord(p1[1]) - Ord(p2[1]);
  Exit;

  2:
  Result := Ord(p1[2]) - Ord(p2[2]);
  Exit;

  3:
  Result := Ord(p1[3]) - Ord(p2[3]);
end;

function StrCompIA(const s1, s2: AnsiString): Integer;
label
  Zero, One, Two, Three, Match;
var
  p1, p2: PAnsiChar;
  l, l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^;

  p2 := Pointer(s2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^;

  if l1 > l2 then
    l := l2
  else
    l := l1;

  while l >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
      if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
      if (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Two;
      if (ANSI_UPPER_CHAR_TABLE[p1[3]] <> ANSI_UPPER_CHAR_TABLE[p2[3]]) then goto Three;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
        if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
        if (ANSI_UPPER_CHAR_TABLE[p1[2]] <> ANSI_UPPER_CHAR_TABLE[p2[2]]) then goto Two;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
        if (ANSI_UPPER_CHAR_TABLE[p1[1]] <> ANSI_UPPER_CHAR_TABLE[p2[1]]) then goto One;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[p1^] <> ANSI_UPPER_CHAR_TABLE[p2^]) then goto Zero;
      end;
  end;

  if l1 > l2 then
    Result := 1
  else
    if l1 = l2 then
      Result := 0
    else
      Result := -1;

  Exit;

  Match:
  Result := 0;
  Exit;

  Zero:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1^]) - Ord(ANSI_UPPER_CHAR_TABLE[p2^]);
  Exit;

  One:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[1]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[1]]);
  Exit;

  Two:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[2]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[2]]);
  Exit;

  Three:
  Result := Ord(ANSI_UPPER_CHAR_TABLE[p1[3]]) - Ord(ANSI_UPPER_CHAR_TABLE[p2[3]]);
end;

function StrCompW(const s1, s2: WideString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PWideChar;
  l, l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^;

  p2 := Pointer(s2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^;

  if l1 > l2 then
    l := l2
  else
    l := l1;

  l := l shr 1;
  while l >= 4 do
    begin
      if p1^ <> p2^ then goto 0;
      if p1[1] <> p2[1] then goto 1;
      if p1[2] <> p2[2] then goto 2;
      if p1[3] <> p2[3] then goto 3;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
        if p1[2] <> p2[2] then goto 2;
      end;
    2:
      begin
        if p1^ <> p2^ then goto 0;
        if p1[1] <> p2[1] then goto 1;
      end;
    1:
      begin
        if p1^ <> p2^ then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(p1^) - Ord(p2^);
  Exit;

  1:
  Result := Ord(p1[1]) - Ord(p2[1]);
  Exit;

  2:
  Result := Ord(p1[2]) - Ord(p2[2]);
  Exit;

  3:
  Result := Ord(p1[3]) - Ord(p2[3]);
end;

function StrCompIW(const s1, s2: WideString): Integer;
label
  0, 1, 2, 3;
var
  p1, p2: PWideChar;
  l, l1, l2: Cardinal;
begin
  p1 := Pointer(s1);
  l1 := Cardinal(p1);
  if l1 <> 0 then l1 := PCardinal(l1 - 4)^;

  p2 := Pointer(s2);
  l2 := Cardinal(p2);
  if l2 <> 0 then l2 := PCardinal(l2 - 4)^;

  if l1 > l2 then
    l := l2
  else
    l := l1;

  l := l shr 1;
  while l >= 4 do
    begin
      if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
      if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
      if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto 2;
      if (p1[3] <> p2[3]) and (CharToCaseFoldW(p1[3]) <> CharToCaseFoldW(p2[3])) then goto 3;
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
        if (p1[2] <> p2[2]) and (CharToCaseFoldW(p1[2]) <> CharToCaseFoldW(p2[2])) then goto 2;
      end;
    2:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
        if (p1[1] <> p2[1]) and (CharToCaseFoldW(p1[1]) <> CharToCaseFoldW(p2[1])) then goto 1;
      end;
    1:
      begin
        if (p1^ <> p2^) and (CharToCaseFoldW(p1^) <> CharToCaseFoldW(p2^)) then goto 0;
      end;
  end;

  Result := l1 - l2;
  Exit;

  0:
  Result := Ord(CharToCaseFoldW(p1^)) - Ord(CharToCaseFoldW(p2^));
  Exit;

  1:
  Result := Ord(CharToCaseFoldW(p1[1])) - Ord(CharToCaseFoldW(p2[1]));
  Exit;

  2:
  Result := Ord(CharToCaseFoldW(p1[2])) - Ord(CharToCaseFoldW(p2[2]));
  Exit;

  3:
  Result := Ord(CharToCaseFoldW(p1[3])) - Ord(CharToCaseFoldW(p2[3]));
end;

function StrContainsA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;
begin
  Result := StrPosA(Search, Source, Start) <> 0;
end;

function StrContainsW(const ASearch, ASource: WideString; const AStartPos: Cardinal = 1): Boolean;
begin
  Result := (Pointer(ASearch) <> nil) and (Pointer(ASource) <> nil) and (AStartPos <> 0) and (
    InternalPosW(
    Pointer(ASearch), PCardinal(Cardinal(ASearch) - 4)^ shr 1,
    Pointer(ASource), PCardinal(Cardinal(ASource) - 4)^ shr 1,
    AStartPos - 1) <> 0);
end;

function StrContainsIW(const ASearch, ASource: WideString; const AStartPos: Cardinal = 1): Boolean;
begin
  Result := (Pointer(ASearch) <> nil) and (Pointer(ASource) <> nil) and (AStartPos <> 0) and (
    InternalPosIW(
    Pointer(ASearch), PCardinal(Cardinal(ASearch) - 4)^ shr 1,
    Pointer(ASource), PCardinal(Cardinal(ASource) - 4)^ shr 1,
    AStartPos - 1) <> 0);
end;

function StrCountCharA(const Source: AnsiString; const c: AnsiChar; const StartIndex: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three;
var
  l: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  Result := 0;
  if p = nil then Exit;

  if StartIndex = 0 then Exit;

  l := PCardinal(Cardinal(p) - 4)^;
  if StartIndex > l then Exit;

  Inc(p, StartIndex - 1);
  Dec(l, StartIndex - 1);

  while l >= 4 do
    begin
      if p^ = c then Inc(Result);
      if p[1] = c then Inc(Result);
      if p[2] = c then Inc(Result);
      if p[3] = c then Inc(Result);
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ = c then Inc(Result);
        if p[1] = c then Inc(Result);
        if p[2] = c then Inc(Result);
      end;
    2:
      begin
        if p^ = c then Inc(Result);
        if p[1] = c then Inc(Result);
      end;
    1:
      if p^ = c then Inc(Result);
  end;
end;

function StrCountCharW(const Source: WideString; const c: WideChar; const StartIndex: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three;
var
  l: Cardinal;
  p: PWideChar;
begin
  p := Pointer(Source);
  Result := 0;
  if p = nil then Exit;

  if StartIndex = 0 then Exit;

  l := PCardinal(p - 2)^ shr 1;
  if StartIndex > l then Exit;

  Inc(p, StartIndex - 1);
  Dec(l, StartIndex - 1);

  while l >= 4 do
    begin
      if p^ = c then Inc(Result);
      if p[1] = c then Inc(Result);
      if p[2] = c then Inc(Result);
      if p[3] = c then Inc(Result);
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ = c then Inc(Result);
        if p[1] = c then Inc(Result);
        if p[2] = c then Inc(Result);
      end;
    2:
      begin
        if p^ = c then Inc(Result);
        if p[1] = c then Inc(Result);
      end;
    1:
      if p^ = c then Inc(Result);
  end;
end;

function StrMatchesA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;
label
  Fail, Success;
var
  pSearch, PSource: PAnsiChar;
  lSearch, LSource: Cardinal;
begin
  if Start = 0 then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;
  LSource := Cardinal(Pointer(PSource - 4)^);
  if Start > LSource then goto Fail;

  pSearch := Pointer(Search);
  if pSearch = nil then goto Success;
  lSearch := Cardinal(Pointer(pSearch - 4)^);

  Dec(LSource, Start - 1);
  if LSource < lSearch then goto Fail;

  Inc(PSource, Start - 1);

  while lSearch >= 4 do
    begin
      if PCardinal(pSearch)^ <> PCardinal(PSource)^ then goto Fail;
      Inc(pSearch, 4);
      Inc(PSource, 4);
      Dec(lSearch, 4);
    end;

  case lSearch of
    3:
      begin
        if PWord(pSearch)^ <> PWord(PSource)^ then goto Fail;
        if pSearch[2] <> PSource[2] then goto Fail;
      end;
    2:
      begin
        if PWord(pSearch)^ <> PWord(PSource)^ then goto Fail;
      end;
    1:
      begin
        if pSearch^ <> PSource^ then goto Fail;
      end;
  end;

  Success:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrMatchesIA(const Search, Source: AnsiString; const Start: Cardinal = 1): Boolean;
label
  Fail, Success;
var
  pSearch, PSource: PAnsiChar;
  lSearch, LSource: Cardinal;
begin
  if Start = 0 then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;
  LSource := PCardinal(PSource - 4)^;

  if Start > LSource then goto Fail;

  pSearch := Pointer(Search);
  if pSearch = nil then goto Success;
  lSearch := PCardinal(pSearch - 4)^;

  Dec(LSource, Start - 1);
  if LSource < lSearch then goto Fail;

  Inc(PSource, Start - 1);

  while lSearch >= 4 do
    begin
      if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[PSource^]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[1]] <> ANSI_UPPER_CHAR_TABLE[PSource[1]]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[2]] <> ANSI_UPPER_CHAR_TABLE[PSource[2]]) or
        (ANSI_UPPER_CHAR_TABLE[pSearch[3]] <> ANSI_UPPER_CHAR_TABLE[PSource[3]]) then goto Fail;
      Inc(pSearch, 4);
      Inc(PSource, 4);
      Dec(lSearch, 4);
    end;

  case lSearch of
    3:
      begin
        if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[PSource^]) or
          (ANSI_UPPER_CHAR_TABLE[pSearch[1]] <> ANSI_UPPER_CHAR_TABLE[PSource[1]]) or
          (ANSI_UPPER_CHAR_TABLE[pSearch[2]] <> ANSI_UPPER_CHAR_TABLE[PSource[2]]) then goto Fail;
      end;
    2:
      begin
        if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[PSource^]) or
          (ANSI_UPPER_CHAR_TABLE[pSearch[1]] <> ANSI_UPPER_CHAR_TABLE[PSource[1]]) then goto Fail;
      end;
    1:
      begin
        if (ANSI_UPPER_CHAR_TABLE[pSearch^] <> ANSI_UPPER_CHAR_TABLE[PSource^]) then goto Fail;
      end;
  end;

  Success:
  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function StrMatchWildA(const Source, Mask: AnsiString; const WildChar: AnsiChar = AC_ASTERISK; const MaskChar: AnsiChar = AC_QUESTION_MARK): Boolean;

label
  Failure, Success, BackTrack;
var
  c: AnsiChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PAnsiChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source);
  SourceLength := Cardinal(SourcePtr);
  if SourceLength <> 0 then SourceLength := PCardinal(SourceLength - 4)^;

  MaskPtr := Pointer(Mask);
  MaskLength := Cardinal(MaskPtr);
  if MaskLength <> 0 then MaskLength := PCardinal(MaskLength - 4)^;

  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (c <> SourcePtr^)) then Break;
      Inc(MaskPtr);
      Inc(SourcePtr);
      Dec(MaskLength);
      Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat

            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr);
                Dec(MaskLength);
              end;

            if MaskLength = 0 then goto Success;

            LastWild := MaskPtr;

            BackTrack:

            c := MaskPtr^;
            while (SourceLength > 0) and (c <> MaskChar) and (c <> SourcePtr^) do
              begin
                Inc(SourcePtr);
                Dec(SourceLength);
              end;

            if SourceLength = 0 then goto Failure;

            Inc(SourcePtr);
            Dec(SourceLength);

            LastSource := SourcePtr;

            Inc(MaskPtr);
            Dec(MaskLength);

            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (c <> SourcePtr^)) then Break;
                Inc(MaskPtr);
                Inc(SourcePtr);
                Dec(MaskLength);
                Dec(SourceLength);
              end;

            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          if SourceLength = 0 then goto Success;

          MaskLength := MaskPtr - LastWild;

          MaskPtr := LastWild;
          Inc(SourcePtr, SourceLength - MaskLength);

          while (MaskLength > 0) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (c <> SourcePtr^) then Break;
              Inc(MaskPtr);
              Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

function StrMatchWildIA(const Source, Mask: AnsiString; const WildChar: AnsiChar = AC_ASTERISK; const MaskChar: AnsiChar = AC_QUESTION_MARK): Boolean;

label
  Failure, Success, BackTrack;
var
  c: AnsiChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PAnsiChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source);
  SourceLength := Cardinal(SourcePtr);
  if SourceLength <> 0 then SourceLength := PCardinal(SourceLength - 4)^;

  MaskPtr := Pointer(Mask);
  MaskLength := Cardinal(MaskPtr);
  if MaskLength <> 0 then MaskLength := PCardinal(MaskLength - 4)^;

  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^])) then Break;
      Inc(MaskPtr);
      Inc(SourcePtr);
      Dec(MaskLength);
      Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat

            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr);
                Dec(MaskLength);
              end;

            if MaskLength = 0 then goto Success;

            LastWild := MaskPtr;

            BackTrack:

            c := ANSI_UPPER_CHAR_TABLE[MaskPtr^];
            while (SourceLength > 0) and (c <> MaskChar) and (c <> ANSI_UPPER_CHAR_TABLE[SourcePtr^]) do
              begin
                Inc(SourcePtr);
                Dec(SourceLength);
              end;

            if SourceLength = 0 then goto Failure;

            Inc(SourcePtr);
            Dec(SourceLength);

            LastSource := SourcePtr;

            Inc(MaskPtr);
            Dec(MaskLength);

            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^])) then Break;
                Inc(MaskPtr);
                Inc(SourcePtr);
                Dec(MaskLength);
                Dec(SourceLength);
              end;

            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          if SourceLength = 0 then goto Success;

          MaskLength := MaskPtr - LastWild;

          MaskPtr := LastWild;
          Inc(SourcePtr, SourceLength - MaskLength);

          while (MaskLength > 0) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (ANSI_UPPER_CHAR_TABLE[c] <> ANSI_UPPER_CHAR_TABLE[SourcePtr^]) then Break;
              Inc(MaskPtr);
              Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

function StrMatchWildIW(const Source, Mask: WideString; const WildChar: WideChar = WC_ASTERISK; const MaskChar: WideChar = WC_QUESTION_MARK): Boolean;

label
  Failure, Success, BackTrack;
var
  c: WideChar;
  SourcePtr, MaskPtr, LastWild, LastSource: PWideChar;
  SourceLength, MaskLength: Cardinal;
begin
  SourcePtr := Pointer(Source);
  SourceLength := Cardinal(SourcePtr);
  if SourceLength <> 0 then SourceLength := PCardinal(SourceLength - 4)^ shr 1;

  MaskPtr := Pointer(Mask);
  MaskLength := Cardinal(MaskPtr);
  if MaskLength <> 0 then MaskLength := PCardinal(MaskLength - 4)^ shr 1;

  while (SourceLength > 0) and (MaskLength > 0) do
    begin
      c := MaskPtr^;
      if (c = WildChar) or ((c <> MaskChar) and (CharToCaseFoldW(c) <> CharToCaseFoldW(SourcePtr^))) then Break;
      Inc(MaskPtr);
      Inc(SourcePtr);
      Dec(MaskLength);
      Dec(SourceLength);
    end;

  if MaskLength > 0 then
    begin
      if MaskPtr^ = WildChar then
        begin

          repeat

            while (MaskLength > 0) and (MaskPtr^ = WildChar) do
              begin
                Inc(MaskPtr);
                Dec(MaskLength);
              end;

            if MaskLength = 0 then goto Success;

            LastWild := MaskPtr;

            BackTrack:

            c := CharToCaseFoldW(MaskPtr^);
            while (SourceLength > 0) and (c <> MaskChar) and (c <> CharToCaseFoldW(SourcePtr^)) do
              begin
                Inc(SourcePtr);
                Dec(SourceLength);
              end;

            if SourceLength = 0 then goto Failure;

            Inc(SourcePtr);
            Dec(SourceLength);

            LastSource := SourcePtr;

            Inc(MaskPtr);
            Dec(MaskLength);

            while (SourceLength > 0) and (MaskLength > 0) do
              begin
                c := MaskPtr^;
                if (c = WildChar) or ((c <> MaskChar) and (CharToCaseFoldW(c) <> CharToCaseFoldW(SourcePtr^))) then Break;
                Inc(MaskPtr);
                Inc(SourcePtr);
                Dec(MaskLength);
                Dec(SourceLength);
              end;

            if (MaskLength > 0) and (MaskPtr^ <> WildChar) then
              begin
                Inc(MaskLength, MaskPtr - LastWild);
                MaskPtr := LastWild;

                Inc(SourceLength, SourcePtr - LastSource);
                SourcePtr := LastSource;

                goto BackTrack;
              end;

          until MaskLength = 0;

          if SourceLength = 0 then goto Success;

          MaskLength := MaskPtr - LastWild;

          MaskPtr := LastWild;
          Inc(SourcePtr, SourceLength - MaskLength);

          while (MaskLength > 0) do
            begin
              c := MaskPtr^;
              if (c <> MaskChar) and (CharToCaseFoldW(c) <> CharToCaseFoldW(SourcePtr^)) then Break;
              Inc(MaskPtr);
              Inc(SourcePtr);
              Dec(MaskLength);
            end;

          if MaskLength = 0 then goto Success;
        end;
    end
  else
    if SourceLength = 0 then
      goto Success;

  Failure:
  Result := False;
  Exit;

  Success:
  Result := True;
end;

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosA(const Search, Source: AnsiString; const Start: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, LSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  if Start = 0 then goto Fail;

  lSearch := PCardinal(pSearch - 4)^;
  LSource := PCardinal(PSource - 4)^;

  if lSearch > LSource then goto Fail;

  Dec(lSearch);
  Dec(LSource, lSearch);

  if LSource <= Start - 1 then goto Fail;
  Dec(LSource, Start - 1);
  Inc(PSource, Start - 1);

  c := pSearch^;
  Inc(pSearch);

  while LSource > 0 do
    begin

      while LSource >= 4 do
        begin
          if (PSource^ = c) then goto Zero;
          if (PSource[1] = c) then goto One;
          if (PSource[2] = c) then goto Two;
          if (PSource[3] = c) then goto Three;
          Inc(PSource, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[1] = c) then goto One;
            if (PSource[2] = c) then goto Two;
          end;
        2:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[1] = c) then goto One;
          end;
        1:
          begin
            if (PSource^ = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4);
      Dec(LSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3);
      Dec(LSource, 2);
      goto Match;

      One:
      Inc(PSource, 2);
      Dec(LSource, 1);
      goto Match;

      Zero:
      Inc(PSource);

      Match:

      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and (PCardinal(PSourceTemp)^ = PCardinal(pSearchTemp)^) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if PSourceTemp^ = pSearchTemp^ then goto Success;
        2: if PWord(PSourceTemp)^ = PWord(pSearchTemp)^ then goto Success;
        3: if (PWord(PSourceTemp)^ = PWord(pSearchTemp)^) and (PSourceTemp[2] = pSearchTemp[2]) then goto Success;
      end;

      Dec(LSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := Cardinal(PSource) - Cardinal(Source);
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

function StrPosW(const ASearch, ASource: WideString; const AStartPos: Cardinal = 1): Cardinal;
begin
  if (Pointer(ASearch) <> nil) and (Pointer(ASource) <> nil) and (AStartPos <> 0) then
    Result := InternalPosW(
      Pointer(ASearch), PCardinal(Cardinal(ASearch) - 4)^ shr 1,
      Pointer(ASource), PCardinal(Cardinal(ASource) - 4)^ shr 1,
      AStartPos - 1)
  else
    Result := 0;
end;

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosIA(const Search, Source: AnsiString; const StartPos: Cardinal = 1): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, LSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  if StartPos = 0 then goto Fail;

  lSearch := PCardinal(pSearch - 4)^;
  LSource := PCardinal(PSource - 4)^;

  if lSearch > LSource then goto Fail;

  Dec(lSearch);
  Dec(LSource, lSearch);

  if LSource <= StartPos - 1 then goto Fail;
  Dec(LSource, StartPos - 1);
  Inc(PSource, StartPos - 1);

  c := ANSI_UPPER_CHAR_TABLE[pSearch^];
  Inc(pSearch);

  while LSource > 0 do
    begin

      while LSource >= 4 do
        begin
          if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
          if (ANSI_UPPER_CHAR_TABLE[PSource[2]] = c) then goto Two;
          if (ANSI_UPPER_CHAR_TABLE[PSource[3]] = c) then goto Three;
          Inc(PSource, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
            if (ANSI_UPPER_CHAR_TABLE[PSource[2]] = c) then goto Two;
          end;
        2:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[1]] = c) then goto One;
          end;
        1:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Inc(PSource, 4);
      Dec(LSource, 3);
      goto Match;

      Two:
      Inc(PSource, 3);
      Dec(LSource, 2);
      goto Match;

      One:
      Inc(PSource, 2);
      Dec(LSource, 1);
      goto Match;

      Zero:
      Inc(PSource);

      Match:

      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) and
        (ANSI_UPPER_CHAR_TABLE[PSourceTemp[3]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[3]]) do
        begin
          Inc(PSourceTemp, 4);
          Inc(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      case lSearchTemp of
        0: goto Success;
        1: if ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^] then
            goto Success;
        2: if (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
          (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) then
            goto Success;
        3: if (ANSI_UPPER_CHAR_TABLE[PSourceTemp^] = ANSI_UPPER_CHAR_TABLE[pSearchTemp^]) and
          (ANSI_UPPER_CHAR_TABLE[PSourceTemp[1]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[1]]) and
            (ANSI_UPPER_CHAR_TABLE[PSourceTemp[2]] = ANSI_UPPER_CHAR_TABLE[pSearchTemp[2]]) then
            goto Success;
      end;

      Dec(LSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := Cardinal(PSource) - Cardinal(Source);
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

function StrPosIW(const ASearch, ASource: WideString; const AStartPos: Cardinal = 1): Cardinal;
begin
  if (Pointer(ASearch) <> nil) and (Pointer(ASource) <> nil) and (AStartPos <> 0) then
    Result := InternalPosIW(
      Pointer(ASearch), PCardinal(Cardinal(ASearch) - 4)^ shr 1,
      Pointer(ASource), PCardinal(Cardinal(ASource) - 4)^ shr 1,
      AStartPos - 1)
  else
    Result := 0;
end;

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosBackA(const Search, Source: AnsiString; Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, LSource: Cardinal;
  c: AnsiChar;
begin
  if Start = 0 then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  lSearch := Cardinal(Pointer(pSearch - 4)^);
  LSource := Cardinal(Pointer(PSource - 4)^);

  if LSource > Start then LSource := Start;

  if LSource < lSearch then goto Fail;

  Inc(PSource, LSource - 1);

  Dec(lSearch);
  Dec(LSource, lSearch);

  Inc(pSearch, lSearch);
  c := pSearch^;
  Dec(pSearch);

  while LSource > 0 do
    begin

      while LSource >= 4 do
        begin
          if (PSource^ = c) then goto Zero;
          if (PSource[-1] = c) then goto One;
          if (PSource[-2] = c) then goto Two;
          if (PSource[-3] = c) then goto Three;
          Dec(PSource, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[-1] = c) then goto One;
            if (PSource[-2] = c) then goto Two;
          end;
        2:
          begin
            if (PSource^ = c) then goto Zero;
            if (PSource[-1] = c) then goto One;
          end;
        1:
          begin
            if (PSource^ = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Dec(PSource, 4);
      Dec(LSource, 3);
      goto Match;

      Two:
      Dec(PSource, 3);
      Dec(LSource, 2);
      goto Match;

      One:
      Dec(PSource, 2);
      Dec(LSource, 1);
      goto Match;

      Zero:
      Dec(PSource);

      Match:

      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        (PSourceTemp^ = pSearchTemp^) and
        (PSourceTemp[-1] = pSearchTemp[-1]) and
        (PSourceTemp[-2] = pSearchTemp[-2]) and
        (PSourceTemp[-3] = pSearchTemp[-3]) do
        begin
          Dec(PSourceTemp, 4);
          Dec(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      if (lSearchTemp = 0) then goto Success;
      if ((lSearchTemp = 1) and
        (PSourceTemp^ = pSearchTemp^)) then goto Success;
      if ((lSearchTemp = 2) and
        (PSourceTemp^ = pSearchTemp^) and
        (PSourceTemp[-1] = pSearchTemp[-1])) then goto Success;
      if ((lSearchTemp = 3) and
        (PSourceTemp^ = pSearchTemp^) and
        (PSourceTemp[-1] = pSearchTemp[-1]) and
        (PSourceTemp[-2] = pSearchTemp[-2])) then goto Success;

      Dec(LSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := Cardinal(PSource) - Cardinal(Source) - lSearch + 2;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
function StrPosBackIA(const Search, Source: AnsiString; Start: Cardinal = 0): Cardinal;
label
  Zero, One, Two, Three, Match, Fail, Success;
var
  pSearch, pSearchTemp, PSource, PSourceTemp: PAnsiChar;
  lSearch, lSearchTemp, LSource: Cardinal;
  c: AnsiChar;
begin
  pSearch := Pointer(Search);
  if pSearch = nil then goto Fail;

  PSource := Pointer(Source);
  if PSource = nil then goto Fail;

  LSource := PCardinal(PSource - 4)^;

  if Start > LSource then goto Fail;
  if Start <> 0 then LSource := Start;

  lSearch := PCardinal(pSearch - 4)^;

  if LSource < lSearch then goto Fail;

  Inc(PSource, LSource - 1);

  Dec(lSearch);
  Dec(LSource, lSearch);

  Inc(pSearch, lSearch);
  c := ANSI_UPPER_CHAR_TABLE[pSearch^];
  Dec(pSearch);

  while LSource > 0 do
    begin

      while LSource >= 4 do
        begin
          if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          if (ANSI_UPPER_CHAR_TABLE[PSource[-1]] = c) then goto One;
          if (ANSI_UPPER_CHAR_TABLE[PSource[-2]] = c) then goto Two;
          if (ANSI_UPPER_CHAR_TABLE[PSource[-3]] = c) then goto Three;
          Dec(PSource, 4);
          Dec(LSource, 4);
        end;

      case LSource of
        3:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[-1]] = c) then goto One;
            if (ANSI_UPPER_CHAR_TABLE[PSource[-2]] = c) then goto Two;
          end;
        2:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
            if (ANSI_UPPER_CHAR_TABLE[PSource[-1]] = c) then goto One;
          end;
        1:
          begin
            if (ANSI_UPPER_CHAR_TABLE[PSource^] = c) then goto Zero;
          end;
      end;

      Break;

      Three:
      Dec(PSource, 4);
      Dec(LSource, 3);
      goto Match;

      Two:
      Dec(PSource, 3);
      Dec(LSource, 2);
      goto Match;

      One:
      Dec(PSource, 2);
      Dec(LSource, 1);
      goto Match;

      Zero:
      Dec(PSource);

      Match:

      PSourceTemp := PSource;
      pSearchTemp := pSearch;
      lSearchTemp := lSearch;

      while (lSearchTemp >= 4) and
        ((PSourceTemp^ = pSearchTemp^) or (PSourceTemp^ = ANSI_REVERSE_CHAR_TABLE[pSearchTemp^])) and
        ((PSourceTemp[-1] = pSearchTemp[-1]) or (PSourceTemp[-1] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-1]])) and
        ((PSourceTemp[-2] = pSearchTemp[-2]) or (PSourceTemp[-2] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-2]])) and
        ((PSourceTemp[-3] = pSearchTemp[-3]) or (PSourceTemp[-3] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-3]])) do
        begin
          Dec(PSourceTemp, 4);
          Dec(pSearchTemp, 4);
          Dec(lSearchTemp, 4);
        end;

      if (lSearchTemp = 0) then goto Success;
      if (lSearchTemp = 1) and
        ((PSourceTemp^ = pSearchTemp^) or (PSourceTemp^ = ANSI_REVERSE_CHAR_TABLE[pSearchTemp^])) then goto Success;
      if (lSearchTemp = 1) and
        ((PSourceTemp^ = pSearchTemp^) or (PSourceTemp^ = ANSI_REVERSE_CHAR_TABLE[pSearchTemp^])) and
        ((PSourceTemp[-1] = pSearchTemp[-1]) or (PSourceTemp[-1] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-1]])) then goto Success;
      if (lSearchTemp = 3) and
        ((PSourceTemp^ = pSearchTemp^) or (PSourceTemp^ = ANSI_REVERSE_CHAR_TABLE[pSearchTemp^])) and
        ((PSourceTemp[-1] = pSearchTemp[-1]) or (PSourceTemp[-1] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-1]])) and
        ((PSourceTemp[-2] = pSearchTemp[-2]) or (PSourceTemp[-2] = ANSI_REVERSE_CHAR_TABLE[pSearchTemp[-2]])) then goto Success;

      Dec(LSource);
    end;

  Fail:
  Result := 0;
  Exit;

  Success:
  Result := Cardinal(PSource) - Cardinal(Source) - lSearch + 2;
end;
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

function StrToIntDefW(const w: WideString; const Default: Integer): Integer;
var
  e: Integer;
begin
  Result := ValIntW(w, e);
  if e <> 0 then Result := Default;
end;

function StrToInt64DefW(const w: WideString; const Default: Int64): Int64;
var
  e: Integer;
begin
  Result := ValInt64W(w, e);
  if e <> 0 then Result := Default;
end;

function StrToLowerA(const s: AnsiString): AnsiString;
var
  p1, p2: PAnsiChar;
  l: Cardinal;
begin
  if s = '' then Exit;

  p1 := Pointer(s);
  l := PCardinal(Cardinal(p1) - 4)^;

  SetString(Result, nil, l);
  p2 := Pointer(Result);

  while l >= 4 do
    begin
      p2^ := ANSI_LOWER_CHAR_TABLE[p1^];
      p2[1] := ANSI_LOWER_CHAR_TABLE[p1[1]];
      p2[2] := ANSI_LOWER_CHAR_TABLE[p1[2]];
      p2[3] := ANSI_LOWER_CHAR_TABLE[p1[3]];
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        p2^ := ANSI_LOWER_CHAR_TABLE[p1^];
        p2[1] := ANSI_LOWER_CHAR_TABLE[p1[1]];
        p2[2] := ANSI_LOWER_CHAR_TABLE[p1[2]];
      end;
    2:
      begin
        p2^ := ANSI_LOWER_CHAR_TABLE[p1^];
        p2[1] := ANSI_LOWER_CHAR_TABLE[p1[1]];
      end;
    1:
      begin
        p2^ := ANSI_LOWER_CHAR_TABLE[p1^];
      end;
  end;
end;

function StrToUpperA(const s: AnsiString): AnsiString;
var
  p1, p2: PAnsiChar;
  l: Cardinal;
begin
  if s = '' then Exit;

  p1 := Pointer(s);
  l := PCardinal(Cardinal(p1) - 4)^;

  SetString(Result, nil, l);
  p2 := Pointer(Result);

  while l >= 4 do
    begin
      p2^ := ANSI_UPPER_CHAR_TABLE[p1^];
      p2[1] := ANSI_UPPER_CHAR_TABLE[p1[1]];
      p2[2] := ANSI_UPPER_CHAR_TABLE[p1[2]];
      p2[3] := ANSI_UPPER_CHAR_TABLE[p1[3]];
      Inc(p1, 4);
      Inc(p2, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        p2^ := ANSI_UPPER_CHAR_TABLE[p1^];
        p2[1] := ANSI_UPPER_CHAR_TABLE[p1[1]];
        p2[2] := ANSI_UPPER_CHAR_TABLE[p1[2]];
      end;
    2:
      begin
        p2^ := ANSI_UPPER_CHAR_TABLE[p1^];
        p2[1] := ANSI_UPPER_CHAR_TABLE[p1[1]];
      end;
    1:
      begin
        p2^ := ANSI_UPPER_CHAR_TABLE[p1^];
      end;
  end;
end;

procedure BufToUpperW(p1, p2: PWideChar; l: Cardinal);
begin
  while l >= 4 do
    begin
      p2^ := CharToUpperW(p1^);
      p2[1] := CharToUpperW(p1[1]);
      p2[2] := CharToUpperW(p1[2]);
      p2[3] := CharToUpperW(p1[3]);
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  if l = 0 then Exit;
  p2^ := CharToUpperW(p1^);
  if l = 1 then Exit;
  p2[1] := CharToUpperW(p1[1]);
  if l = 2 then Exit;
  p2[2] := CharToUpperW(p1[2]);
end;

procedure BufToLowerW(p1, p2: PWideChar; l: Cardinal);
begin
  while l >= 4 do
    begin
      p2^ := CharToLowerW(p1^);
      p2[1] := CharToLowerW(p1[1]);
      p2[2] := CharToLowerW(p1[2]);
      p2[3] := CharToLowerW(p1[3]);
      Inc(p1, 4); Inc(p2, 4); Dec(l, 4);
    end;

  if l = 0 then Exit;
  p2^ := CharToLowerW(p1^);
  if l = 1 then Exit;
  p2[1] := CharToLowerW(p1[1]);
  if l = 2 then Exit;
  p2[2] := CharToLowerW(p1[2]);
end;

function StrToUpperW(const s: WideString): WideString;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    l := PCardinal(l - 4)^ shr 1;
  SetString(Result, nil, l);
  BufToUpperW(Pointer(s), Pointer(Result), l);
end;

procedure StrToUpperInPlaceW(var s: WideString);
var
  l: Cardinal;
begin
  {$IFDEF Linux}
  UniqueString(s);
  {$ENDIF}
  l := Cardinal(s);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ shr 1;
      BufToUpperW(Pointer(s), Pointer(s), l);
    end;
end;

function StrToLowerW(const s: WideString): WideString;
var
  l: Cardinal;
begin
  l := Cardinal(s);
  if l <> 0 then
    l := PCardinal(l - 4)^ shr 1;
  SetString(Result, nil, l);
  BufToLowerW(Pointer(s), Pointer(Result), l);
end;

procedure StrToLowerInPlaceW(var s: WideString);
var
  l: Cardinal;
begin
  {$IFDEF Linux}
  UniqueString(s);
  {$ENDIF}
  l := Cardinal(s);
  if l <> 0 then
    begin
      l := PCardinal(l - 4)^ shr 1;
      BufToLowerW(Pointer(s), Pointer(s), l);
    end;
end;

procedure StrTimUriFragmentA(var Value: AnsiString);
var
  i: Cardinal;
begin
  i := StrPosCharA(Value, AC_NUMBER_SIGN);
  if i > 0 then
    SetLength(Value, i - 1);
end;

procedure StrTrimUriFragmentW(var Value: WideString);
var
  i: Cardinal;
begin
  i := StrPosCharW(Value, WC_NUMBER_SIGN);
  if i > 0 then
    SetLength(Value, i - 1);
end;

function BufCountUtf8Chars(p: PAnsiChar; l: Cardinal; const BytesToCount: Cardinal = $FFFFFFFF): Cardinal;
label
  Success;
var
  b, b1, b2, b3: Byte;
begin
  Result := 0;
  if p = nil then Exit;
  if l = 0 then Exit;

  if (BytesToCount <> $FFFFFFFF) and (l > BytesToCount) then
    l := BytesToCount;

  while l > 0 do
    begin
      b := Byte(p^);
      Inc(p); Dec(l);

      if b < $80 then
        goto Success
      else
        if b < $C0 then
          goto Success
        else
          if l > 0 then
            begin
              b1 := Byte(p^);
              if b1 and $C0 <> $80 then
                goto Success;
              Inc(p); Dec(l);

              if b and $E0 <> $E0 then
                goto Success
              else
                if l > 0 then
                  begin
                    b2 := Byte(p^);
                    if b2 and $C0 <> $80 then
                      goto Success;
                    Inc(p); Dec(l);

                    if b and $F0 <> $F0 then
                      goto Success
                    else
                      if l > 0 then
                        begin
                          b3 := Byte(p^);
                          if b3 and $C0 <> $80 then
                            goto Success;
                          Inc(p); Dec(l);

                          if b and $F8 <> $F8 then
                            goto Success
                          else
                            if l > 0 then
                              begin
                                b3 := Byte(p^);
                                if b3 and $C0 <> $80 then
                                  goto Success;
                                Inc(p); Dec(l);

                                if b and $FC <> $FC then
                                  goto Success
                                else
                                  if l > 0 then
                                    begin
                                      b3 := Byte(p^);
                                      if b3 and $C0 <> $80 then
                                        goto Success;
                                      Inc(p); Dec(l);

                                      goto Success;
                                    end;
                              end;
                        end;
                  end;
            end;

      Break;

      Success:
      Inc(Result);
    end;
end;

function StrCountUtf8Chars(const Value: AnsiString; const BytesToCount: Cardinal = $FFFFFFFF): Cardinal;
begin
  if Pointer(Value) <> nil then
    Result := BufCountUtf8Chars(Pointer(Value), PCardinal(Cardinal(Value) - 4)^, BytesToCount)
  else
    Result := 0;
end;

function StrDecodeUtf8(const Value: AnsiString): WideString;
label
  0, Success;
var
  LSrc: Cardinal;
  PSrc: PByte;
  PDest: PWideChar;
  b, b1, b2, b3: Byte;
  c: WideChar;
begin
  PSrc := Pointer(Value);
  if PSrc = nil then Exit;
  LSrc := PCardinal(Cardinal(PSrc) - 4)^;
  if LSrc = 0 then Exit;

  SetString(Result, nil, LSrc);
  PDest := Pointer(Result);

  while LSrc > 0 do
    begin
      b := PSrc^;
      Inc(PSrc); Dec(LSrc);

      if b < $80 then
        begin
          PDest^ := WideChar(b);
          goto Success;
        end
      else
        if b < $C0 then
          goto 0
        else
          if LSrc > 0 then
            begin
              b1 := PSrc^;
              if b1 and $C0 <> $80 then
                goto 0;
              Inc(PSrc); Dec(LSrc);

              if b and $E0 <> $E0 then
                begin
                  c := WideChar((b and $1F shl 6) or (b1 and $3F));

                  if c < #$0080 then
                    goto 0;
                  PDest^ := c;
                  goto Success;
                end
              else
                if LSrc > 0 then
                  begin
                    b2 := PSrc^;
                    if b2 and $C0 <> $80 then
                      goto 0;
                    Inc(PSrc); Dec(LSrc);

                    if b and $F0 <> $F0 then
                      begin
                        c := WideChar((b and $0F shl 12) or (b1 and $3F shl 6) or (b2 and $3F));

                        if c < #$0800 then
                          goto 0;
                        PDest^ := c;
                        goto Success;
                      end
                    else
                      if LSrc > 0 then
                        begin
                          b3 := PSrc^;
                          if b3 and $C0 <> $80 then
                            goto 0;
                          Inc(PSrc); Dec(LSrc);

                          if b and $F8 <> $F8 then
                            goto 0
                          else
                            if LSrc > 0 then
                              begin
                                b3 := PSrc^;
                                if b3 and $C0 <> $80 then
                                  goto 0;
                                Inc(PSrc); Dec(LSrc);

                                if b and $FC <> $FC then
                                  goto 0
                                else
                                  if LSrc > 0 then
                                    begin
                                      b3 := PSrc^;
                                      if b3 and $C0 <> $80 then
                                        goto 0;
                                      Inc(PSrc); Dec(LSrc);

                                      goto 0;
                                    end;
                              end;
                        end;
                  end;
            end;

      Break;

      0:

      PDest^ := WC_REPLACEMENT_CHARACTER;
      Success:
      Inc(PDest);
    end;

  SetLength(Result, (Cardinal(PDest) - Cardinal(Result)) shr 1);
end;

function BufEncodeUtf8(p: PWideChar; l: Cardinal): AnsiString;
label
  1, 2, 3, 4, 5, 6;
var
  PDest: PAnsiChar;
  c: Word;
begin
  if p = nil then Exit;
  if l = 0 then Exit;

  SetString(Result, nil, l * 3);
  PDest := Pointer(Result);

  while l > 0 do
    begin
      c := Word(p^);
      if c < $0080 then
        begin
          PDest^ := AnsiChar(c);
          Inc(PDest);
        end
      else
        if c < $0800 then
          begin
            PDest^ := AnsiChar($C0 or (c shr 6));
            PDest[1] := AnsiChar($80 or (c and $3F));
            Inc(PDest, 2);
          end
        else
          begin
            PDest^ := AnsiChar($E0 or (c shr 12));
            PDest[1] := AnsiChar($80 or ((c shr 6) and $3F));
            PDest[2] := AnsiChar($80 or (c and $3F));
            Inc(PDest, 3);
          end;

      Inc(p); Dec(l);
    end;

  SetLength(Result, Cardinal(PDest) - Cardinal(Result));
end;

function StrEncodeUtf8(const Value: WideString): AnsiString;
begin
  if Pointer(Value) <> nil then
    Result := BufEncodeUtf8(Pointer(Value), PCardinal(Cardinal(Value) - 4)^ shr 1)
  else
    Result := '';
end;

{$IFDEF MSWINDOWS}
function SysErrorMessageA(const MessageID: Cardinal): AnsiString;
const
  BUFFER_SIZE = $0100;
var
  l: Cardinal;
begin
  SetString(Result, nil, BUFFER_SIZE);
  l := FormatMessageA(FORMAT_MESSAGE_FROM_SYSTEM, nil, MessageID, 0, Pointer(Result), BUFFER_SIZE, nil);
  while (l > 0) and (Result[l] in [AC_NULL..AC_SPACE, AC_FULL_STOP]) do
    Dec(l);
  SetLength(Result, l);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function SysErrorMessageW(const MessageID: Cardinal): WideString;
const
  BUFFER_SIZE = $0100;
var
  l: Cardinal;
begin
  {$IFNDEF DI_No_Win_9X_Support}
  if IsUnicode then
    begin
      {$ENDIF}
      SetString(Result, nil, BUFFER_SIZE);
      l := FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM, nil, MessageID, 0, Pointer(Result), BUFFER_SIZE, nil);
      while (l > 0) and (Result[l] in [WC_NULL..WC_SPACE, WC_FULL_STOP]) do
        Dec(l);
      SetLength(Result, l);
      {$IFNDEF DI_No_Win_9X_Support}
    end
  else
    Result := SysErrorMessageA(MessageID);
  {$ENDIF}
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function TextHeightW(const DC: HDC; const Text: WideString): Integer;
var
  Size: TSize;
begin
  Result := Integer(Text);
  if Result <> 0 then
    begin
      Result := PInteger(Result - 4)^ shr 1;
      GetTextExtentPoint32W(DC, Pointer(Text), Result, Size);
      Result := Size.cy;
    end;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function TextWidthW(const DC: HDC; const Text: WideString): Integer;
var
  Size: TSize;
begin
  Result := Integer(Text);
  if Result <> 0 then
    begin
      Result := PInteger(Result - 4)^ shr 1;
      GetTextExtentPoint32W(DC, Pointer(Text), Result, Size);
      Result := Size.cx;
    end;
end;
{$ENDIF}

function TrimA(const Source: AnsiString): AnsiString;
begin
  Result := TrimA(Source, AS_WHITE_SPACE);
end;

function TrimA(const Source: AnsiString; const CharToTrim: AnsiChar): AnsiString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Length: Cardinal;
  p, e: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto ReturnEmptyString;

  Length := PCardinal(Cardinal(p) - 4)^;
  if Length = 0 then goto ReturnEmptyString;

  l := Length;
  e := p + l - 1;

  while l >= 4 do
    begin
      if p^ <> CharToTrim then goto BeginZero;
      if p[1] <> CharToTrim then goto BeginOne;
      if p[2] <> CharToTrim then goto BeginTwo;
      if p[3] <> CharToTrim then goto BeginThree;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if p^ <> CharToTrim then goto BeginZero;
        if p[1] <> CharToTrim then goto BeginOne;
        if p[2] <> CharToTrim then goto BeginTwo;
        Inc(p, 3);
      end;
    2:
      begin
        if p^ <> CharToTrim then goto BeginZero;
        if p[1] <> CharToTrim then goto BeginOne;
        Inc(p, 2);
      end;
    1:
      begin
        if p^ <> CharToTrim then goto BeginZero;
        Inc(p);
      end;
  end;

  goto BeginZero;

  BeginThree:
  Inc(p, 3);
  goto BeginZero;

  BeginTwo:
  Inc(p, 2);
  goto BeginZero;

  BeginOne:
  Inc(p);

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if e^ <> CharToTrim then goto EndZero;
      if e[-1] <> CharToTrim then goto EndOne;
      if e[-2] <> CharToTrim then goto EndTwo;
      if e[-3] <> CharToTrim then goto EndThree;
      Dec(e, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if e^ <> CharToTrim then goto EndZero;
        if e[-1] <> CharToTrim then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if e^ <> CharToTrim then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Length then
    Result := Source
  else
    begin
      SetString(Result, nil, l);
      e := Pointer(Result);

      while l >= 4 do
        begin
          PCardinal(e)^ := PCardinal(p)^;
          Inc(e, 4);
          Inc(p, 4);
          Dec(l, 4);
        end;

      case l of
        3:
          begin
            PWord(e)^ := PWord(p)^;
            e[2] := p[2];
          end;
        2:
          begin
            PWord(e)^ := PWord(p)^;
          end;
        1:
          begin
            e^ := p^;
          end;
      end;
    end;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function TrimA(const Source: AnsiString; const CharsToTrim: TAnsiCharSet): AnsiString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Length: Cardinal;
  p, e: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto ReturnEmptyString;

  Length := PCardinal(p - 4)^;
  if Length = 0 then goto ReturnEmptyString;

  l := Length;
  e := p + l - 1;

  while l >= 4 do
    begin
      if not (p^ in CharsToTrim) then goto BeginZero;
      if not (p[1] in CharsToTrim) then goto BeginOne;
      if not (p[2] in CharsToTrim) then goto BeginTwo;
      if not (p[3] in CharsToTrim) then goto BeginThree;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        if not (p[1] in CharsToTrim) then goto BeginOne;
        if not (p[2] in CharsToTrim) then goto BeginTwo;
        Inc(p, 3);
      end;
    2:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        if not (p[1] in CharsToTrim) then goto BeginOne;
        Inc(p, 2);
      end;
    1:
      begin
        if not (p^ in CharsToTrim) then goto BeginZero;
        Inc(p);
      end;
  end;

  goto BeginZero;

  BeginThree:
  Inc(p, 3);
  goto BeginZero;

  BeginTwo:
  Inc(p, 2);
  goto BeginZero;

  BeginOne:
  Inc(p);

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if not (e^ in CharsToTrim) then goto EndZero;
      if not (e[-1] in CharsToTrim) then goto EndOne;
      if not (e[-2] in CharsToTrim) then goto EndTwo;
      if not (e[-3] in CharsToTrim) then goto EndThree;
      Dec(e, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not (e^ in CharsToTrim) then goto EndZero;
        if not (e[-1] in CharsToTrim) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (e^ in CharsToTrim) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Length then
    Result := Source
  else
    begin
      SetLength(Result, l);
      e := Pointer(Result);

      while l >= 4 do
        begin
          PCardinal(e)^ := PCardinal(p)^;
          Inc(e, 4);
          Inc(p, 4);
          Dec(l, 4);
        end;

      case l of
        3:
          begin
            PWord(e)^ := PWord(p)^;
            e[2] := p[2];
          end;
        2:
          begin
            PWord(e)^ := PWord(p)^;
          end;
        1:
          begin
            e^ := p^;
          end;
      end;
    end;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function TrimW(const w: WideString): WideString;
begin
  Result := TrimW(w, CharIsWhiteSpaceW);
end;

function TrimW(const w: WideString; const IsCharToTrim: TDIValidateWideCharFunc): WideString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, Length: Cardinal;
  p, e: PWideChar;
begin
  p := Pointer(w);
  if p = nil then goto ReturnEmptyString;

  Length := PCardinal(p - 2)^ shr 1;
  if Length = 0 then goto ReturnEmptyString;

  l := Length;
  e := p + l - 1;

  while l >= 4 do
    begin
      if not IsCharToTrim(p^) then goto BeginZero;
      if not IsCharToTrim(p[1]) then goto BeginOne;
      if not IsCharToTrim(p[2]) then goto BeginTwo;
      if not IsCharToTrim(p[3]) then goto BeginThree;
      Inc(p, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        if not IsCharToTrim(p[1]) then goto BeginOne;
        if not IsCharToTrim(p[2]) then goto BeginTwo;
        Inc(p, 3);
      end;
    2:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        if not IsCharToTrim(p[1]) then goto BeginOne;
        Inc(p, 2);
      end;
    1:
      begin
        if not IsCharToTrim(p^) then goto BeginZero;
        Inc(p);
      end;
  end;

  goto BeginZero;

  BeginThree:
  Inc(p, 3);
  goto BeginZero;

  BeginTwo:
  Inc(p, 2);
  goto BeginZero;

  BeginOne:
  Inc(p);

  BeginZero:

  l := e - p + 1;
  if l = 0 then goto ReturnEmptyString;

  while l >= 4 do
    begin
      if not IsCharToTrim(e^) then goto EndZero;
      if not IsCharToTrim(e[-1]) then goto EndOne;
      if not IsCharToTrim(e[-2]) then goto EndTwo;
      if not IsCharToTrim(e[-3]) then goto EndThree;
      Dec(e, 4);
      Dec(l, 4);
    end;

  case l of
    3:
      begin
        if not IsCharToTrim(e^) then goto EndZero;
        if not IsCharToTrim(e[-1]) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not IsCharToTrim(e^) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(l, 3);
  goto EndZero;

  EndTwo:
  Dec(l, 2);
  goto EndZero;

  EndOne:
  Dec(l);

  EndZero:

  if l = Length then
    Result := w
  else
    begin
      SetString(Result, nil, l);
      e := Pointer(Result);

      while l >= 4 do
        begin
          PInt64(e)^ := PInt64(p)^;
          Inc(e, 4);
          Inc(p, 4);
          Dec(l, 4);
        end;

      case l of
        3:
          begin
            PCardinal(e)^ := PCardinal(p)^;
            e[2] := p[2];
          end;
        2:
          begin
            PCardinal(e)^ := PCardinal(p)^;
          end;
        1:
          begin
            e^ := p^;
          end;
      end;
    end;
  Exit;

  ReturnEmptyString:
  Result := '';
end;

procedure TrimLeftByRefA(var s: AnsiString; const Chars: TAnsiCharSet);
label
  BeginZero, BeginOne, BeginTwo, BeginThree, ReturnEmptyString;
var
  i, l: Cardinal;
  PRead, PWrite: PAnsiChar;
begin
  PRead := Pointer(s);
  if PRead = nil then Exit;
  l := PCardinal(PRead - 4)^;

  if (l = 0) or not (PRead^ in Chars) then Exit;

  Inc(PRead);
  i := l - 1;

  while i >= 4 do
    begin
      if not (PRead^ in Chars) then goto BeginZero;
      if not (PRead[1] in Chars) then goto BeginOne;
      if not (PRead[2] in Chars) then goto BeginTwo;
      if not (PRead[3] in Chars) then goto BeginThree;
      Inc(PRead, 4);
      Dec(i, 4);
    end;

  case l of
    3:
      begin
        if not (PRead^ in Chars) then goto BeginZero;
        if not (PRead[1] in Chars) then goto BeginOne;
        if not (PRead[2] in Chars) then goto BeginTwo;
        Dec(i, 3);
      end;
    2:
      begin
        if not (PRead^ in Chars) then goto BeginZero;
        if not (PRead[1] in Chars) then goto BeginOne;
        Dec(i, 2);
      end;
    1:
      begin
        if not (PRead^ in Chars) then goto BeginZero;
        Dec(i);
      end;
  end;

  goto BeginZero;

  BeginThree:
  Dec(i, 3);
  goto BeginZero;

  BeginTwo:
  Dec(i, 2);
  goto BeginZero;

  BeginOne:
  Dec(i);

  BeginZero:

  if i = 0 then goto ReturnEmptyString;

  UniqueString(s);
  PWrite := Pointer(s);
  PRead := PWrite + l - i;
  l := i;

  while i >= 4 do
    begin
      PCardinal(PWrite)^ := PCardinal(PRead)^;
      Inc(PWrite, 4);
      Inc(PRead, 4);
      Dec(i, 4);
    end;

  case i of
    3:
      begin
        PWord(PWrite)^ := PWord(PRead)^;
        PWrite[2] := PRead[2];
      end;
    2:
      PWord(PWrite)^ := PWord(PRead)^;
    1:
      PWrite^ := PRead^;
  end;

  SetLength(s, l);
  Exit;

  ReturnEmptyString:
  s := '';
end;

function TrimRightA(const Source: AnsiString; const s: TAnsiCharSet): AnsiString;
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree,
    ReturnEmptyString;
var
  l, lNew: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then goto ReturnEmptyString;

  l := PCardinal(p - 4)^;
  if l = 0 then goto ReturnEmptyString;

  lNew := l;
  Inc(p, lNew - 1);

  while lNew >= 4 do
    begin
      if not (p^ in s) then goto EndZero;
      if not (p[-1] in s) then goto EndOne;
      if not (p[-2] in s) then goto EndTwo;
      if not (p[-3] in s) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not (p^ in s) then goto EndZero;
        if not (p[-1] in s) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (p^ in s) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:

  Result := Source;
  if lNew <> l then SetLength(Result, lNew);
  Exit;

  ReturnEmptyString:
  Result := '';
end;

procedure TrimCompress(var s: AnsiString; const TrimCompressChars: TAnsiCharSet = AS_WHITE_SPACE; const ReplaceChar: AnsiChar = AC_SPACE);
label
  ReturnEmptyString, SetLengthWrite;
var
  i, j, l: Cardinal;
  PRead, PWrite: PAnsiChar;
begin
  PRead := Pointer(s);
  if PRead = nil then Exit;
  l := PCardinal(PRead - 4)^;
  if l = 0 then Exit;

  i := l;
  if PRead^ in TrimCompressChars then
    begin

      repeat
        Dec(i);
        if i = 0 then goto ReturnEmptyString;
        Inc(PRead);
      until not (PRead^ in TrimCompressChars);

      UniqueString(s);
      PWrite := Pointer(s);
      PRead := PWrite + l - i;
    end
  else
    begin

      repeat

        repeat
          Dec(i);
          if i = 0 then Exit;
          Inc(PRead);
        until PRead^ in TrimCompressChars;

        PWrite := PRead;

        repeat
          Dec(i);
          if i = 0 then goto SetLengthWrite;
          Inc(PRead);
        until not (PRead^ in TrimCompressChars);

        j := PRead - PWrite;
      until (j > 1) or (PRead[-1] <> ReplaceChar); ;

      UniqueString(s);
      PRead := Pointer(Cardinal(s) + l - i);
      PWrite := PRead - j;
      PWrite^ := ReplaceChar;

      if j = 1 then
        repeat

          repeat
            Dec(i);
            if i = 0 then Exit;
            Inc(PRead);
          until PRead^ in TrimCompressChars;

          PWrite := PRead;

          repeat
            Dec(i);
            if i = 0 then goto SetLengthWrite;
            Inc(PRead);
          until not (PRead^ in TrimCompressChars);

          PWrite^ := ReplaceChar;

          j := PRead - PWrite;
        until (j > 1) or (PRead[-1] <> ReplaceChar); ;

      Inc(PWrite);
    end;

  repeat

    repeat
      PWrite^ := PRead^;
      Inc(PWrite);
      Dec(i);
      if i = 0 then goto SetLengthWrite;
      Inc(PRead);
    until PRead^ in TrimCompressChars;

    repeat
      Dec(i);
      if i = 0 then goto SetLengthWrite;
      Inc(PRead);
    until not (PRead^ in TrimCompressChars);

    PWrite^ := ReplaceChar;
    Inc(PWrite);

  until False;

  SetLengthWrite:
  SetLength(s, Cardinal(PWrite) - Cardinal(s));
  Exit;

  ReturnEmptyString:
  s := '';
end;

procedure TrimCompress(var w: WideString; Validate: TDIValidateWideCharFunc = nil; const ReplaceChar: WideChar = WC_SPACE);
label
  ReturnEmptyString, SetLengthWrite;
var
  i, j, l: Cardinal;
  PRead, PWrite: PWideChar;
begin
  PRead := Pointer(w);
  if PRead = nil then Exit;
  l := PCardinal(PRead - 2)^ shr 1;
  if l = 0 then Exit;

  if not Assigned(Validate) then
    Validate := CharIsWhiteSpaceW;

  i := l;
  if Validate(PRead^) then
    begin

      repeat
        Dec(i);
        if i = 0 then goto ReturnEmptyString;
        Inc(PRead);
      until not Validate(PRead^);

      PWrite := Pointer(w);
      PRead := PWrite + l - i;
    end
  else
    begin

      repeat

        repeat
          Dec(i);
          if i = 0 then Exit;
          Inc(PRead);
        until Validate(PRead^);

        PWrite := PRead;

        repeat
          Dec(i);
          if i = 0 then goto SetLengthWrite;
          Inc(PRead);
        until not Validate(PRead^);

        j := PRead - PWrite;
      until (j > 1) or (PRead[-1] <> ReplaceChar); ;

      PRead := Pointer(w);
      Inc(PRead, l - i);
      PWrite := PRead - j;
      PWrite^ := ReplaceChar;

      if j = 1 then
        repeat

          repeat
            Dec(i);
            if i = 0 then Exit;
            Inc(PRead);
          until Validate(PRead^);

          PWrite := PRead;

          repeat
            Dec(i);
            if i = 0 then goto SetLengthWrite;
            Inc(PRead);
          until not Validate(PRead^);

          PWrite^ := ReplaceChar;

          j := PRead - PWrite;
        until (j > 1) or (PRead[-1] <> ReplaceChar); ;

      Inc(PWrite);
    end;

  repeat

    repeat
      PWrite^ := PRead^;
      Inc(PWrite);
      Dec(i);
      if i = 0 then goto SetLengthWrite;
      Inc(PRead);
    until Validate(PRead^);

    repeat
      Dec(i);
      if i = 0 then goto SetLengthWrite;
      Inc(PRead);
    until not Validate(PRead^);

    PWrite^ := ReplaceChar;
    Inc(PWrite);

  until False;

  SetLengthWrite:
  SetLength(w, (Cardinal(PWrite) - Cardinal(w)) shr 1);
  Exit;

  ReturnEmptyString:
  w := '';
end;

procedure TrimRightByRefA(var Source: AnsiString; const s: TAnsiCharSet);
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree;
var
  l, lNew: Cardinal;
  p: PAnsiChar;
begin
  p := Pointer(Source);
  if p = nil then Exit;

  l := PCardinal(p - 4)^;
  if l = 0 then Exit;

  lNew := l;
  Inc(p, lNew - 1);

  while lNew >= 4 do
    begin
      if not (p^ in s) then goto EndZero;
      if not (p[-1] in s) then goto EndOne;
      if not (p[-2] in s) then goto EndTwo;
      if not (p[-3] in s) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not (p^ in s) then goto EndZero;
        if not (p[-1] in s) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not (p^ in s) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:
  if lNew <> l then SetLength(Source, lNew);
end;

procedure TrimRightByRefW(var w: WideString; Validate: TDIValidateWideCharFunc = nil);
label
  BeginZero, BeginOne, BeginTwo, BeginThree,
    EndZero, EndOne, EndTwo, EndThree;
var
  l, lNew: Cardinal;
  p: PWideChar;
begin
  p := Pointer(w);
  if p = nil then Exit;
  l := PCardinal(p - 2)^ shr 1;
  if l = 0 then Exit;

  lNew := l;
  Inc(p, lNew - 1);

  if not Assigned(Validate) then
    Validate := CharIsWhiteSpaceW;

  while lNew >= 4 do
    begin
      if not Validate(p^) then goto EndZero;
      if not Validate(p[-1]) then goto EndOne;
      if not Validate(p[-2]) then goto EndTwo;
      if not Validate(p[-3]) then goto EndThree;
      Dec(p, 4);
      Dec(lNew, 4);
    end;

  case lNew of
    3:
      begin
        if not Validate(p^) then goto EndZero;
        if not Validate(p[-1]) then goto EndOne;
        goto EndTwo;
      end;
    2:
      begin
        if not Validate(p^) then goto EndZero;
        goto EndOne;
      end;
  end;

  goto EndZero;

  EndThree:
  Dec(lNew, 3);
  goto EndZero;

  EndTwo:
  Dec(lNew, 2);
  goto EndZero;

  EndOne:
  Dec(lNew);

  EndZero:
  if lNew <> l then
    SetLength(w, lNew);
end;

function TryStrToIntW(const w: WideString; out Value: Integer): Boolean;
var
  e: Integer;
begin
  Value := ValIntW(w, e);
  Result := e = 0;
end;

function TryStrToInt64W(const w: WideString; out Value: Int64): Boolean;
var
  e: Integer;
begin
  Value := ValInt64W(w, e);
  Result := e = 0;
end;

function UpdateCrc32OfBuf(const Crc32: Cardinal; const Buffer; const BufferSize: Cardinal): Cardinal;

type
  PByte4 = ^TByte4;
  TByte4 = packed record
    b1: Byte;
    b2: Byte;
    b3: Byte;
    b4: Byte;
  end;

var
  p: PByte4;
  b: Cardinal;
  l: Cardinal;
begin
  Result := Crc32;
  p := @Buffer;
  l := BufferSize;

  while l >= 4 do
    begin
      b := Result xor p^.b1;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[Byte(b)];

      b := Byte(Result) xor p^.b2;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[b];

      b := Byte(Result) xor p^.b3;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[b];

      b := Byte(Result) xor p^.b4;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[b];

      Inc(p);
      Dec(l, 4);
    end;

  while l > 0 do
    begin
      b := Byte(Result) xor p^.b1;
      Result := Result shr 8;
      Result := Result xor CRC_32_TABLE[b];

      Inc(Cardinal(p));
      Dec(l);
    end;
end;

function UpdateCrc32OfStrA(const Crc32: Cardinal; const s: AnsiString): Cardinal;
begin
  Result := Crc32;
  if s <> '' then
    Result := UpdateCrc32OfBuf(Result, Pointer(s)^, PCardinal(Cardinal(s) - 4)^)
end;

function UpdateCrc32OfStrW(const Crc32: Cardinal; const w: WideString): Cardinal;
begin
  Result := Crc32;
  if Pointer(w) <> nil then
    Result := UpdateCrc32OfBuf(Result, Pointer(w)^, PCardinal(Cardinal(w) - 4)^);
end;

{$IFDEF MSWINDOWS}
function WBufToAStr(const Buffer: PWideChar; const WideCharCount: Cardinal; const CodePage: Word = CP_ACP): AnsiString;
label
  Fail;
var
  OutputLength: Cardinal;
begin
  if (Buffer = nil) or (WideCharCount = 0) then goto Fail;
  OutputLength := WideCharToMultiByte(CodePage, 0, Buffer, WideCharCount, nil, 0, nil, nil);
  SetString(Result, nil, OutputLength);
  WideCharToMultiByte(CodePage, 0, Buffer, WideCharCount, PAnsiChar(Result), OutputLength, nil, nil);
  Exit;

  Fail:
  Result := '';
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function WStrToAStr(const s: WideString; const CodePage: Word = CP_ACP): AnsiString;
var
  InputLength, OutputLength: Integer;
begin
  InputLength := Length(s);
  OutputLength := WideCharToMultiByte(CodePage, 0, PWideChar(s), InputLength, nil, 0, nil, nil);
  SetLength(Result, OutputLength);
  WideCharToMultiByte(CodePage, 0, PWideChar(s), InputLength, PAnsiChar(Result), OutputLength, nil, nil);
end;
{$ENDIF}

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function ValIntW(const w: WideString; out Code: Integer): Integer;

label
  Error, Fail, Hex;
var
  Negative: Boolean;
  l: Integer;
  p: PWord;
  c: Integer;
begin
  p := Pointer(w);
  if p = nil then goto Fail;
  l := PCardinal(Cardinal(p) - 4)^ div 2;

  Code := l;

  while (l > 0) and (p^ <= Ord(WC_SPACE)) do
    begin
      Inc(p); Dec(l);
    end;

  if l = 0 then goto Fail;

  if p^ = Ord(WC_HYPHEN_MINUS) then
    begin
      Negative := True;
      Inc(p); Dec(l);
    end
  else
    begin
      Negative := False;
      if p^ = Ord(WC_PLUS_SIGN) then
        begin
          Inc(p); Dec(l);
        end;
    end;

  if l = 0 then goto Fail;

  case p^ of
    Ord(WC_DOLLAR_SIGN), Ord(WC_CAPITAL_X), Ord(WC_SMALL_X):
      goto Hex;
    Ord(WC_DIGIT_ZERO):
      begin
        Inc(p); Dec(l);
        if (l > 0) and ((p^ = Ord(WC_CAPITAL_X)) or (p^ = Ord(WC_SMALL_X))) then goto Hex;
      end;
  end;

  Result := 0;

  if Negative then
    while l > 0 do
      begin
        c := p^;
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 - c;
        if Result > 0 then goto Error;
        Inc(p); Dec(l);
      end
  else
    while l > 0 do
      begin
        c := p^;
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 + c;
        if Result < 0 then goto Error;
        Inc(p); Dec(l);
      end;

  Code := 0;
  Exit;

  Hex:
  Inc(p);  Dec(l);
  if l = 0 then goto Fail;

  Result := 0;

  repeat
    c := p^;
    Dec(c, $30);
    if c > $09 then
      begin
        Dec(c, $11);
        if c > $05 then
          begin
            Dec(c, $20);
            if c > $05 then goto Error;
          end;
        if c < 0 then goto Error;
        Inc(c, $0A);
      end
    else
      if c < 0 then goto Error;

    if Result and $F0000000 <> 0 then goto Error;

    Result := Result shl 4 or c;

    Inc(p);
    Dec(l);
  until l = 0;

  if Negative then Result := -Result;
  Code := 0;
  Exit;

  Error:
  Dec(Code, l - 1);
  Exit;

  Fail:
  Code := -1;

end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

{$IFNDEF DI_Show_Warnings}{$WARNINGS OFF}{$ENDIF}
{$IFOPT Q+}{$DEFINE Q_Temp}{$Q-}{$ENDIF}
function ValInt64W(const w: WideString; out Code: Integer): Int64;

label
  Error, Fail, Hex;
var
  Negative: Boolean;
  l: Integer;
  p: PWord;
  c: Integer;
begin
  p := Pointer(w);
  if p = nil then goto Fail;
  l := PCardinal(Cardinal(p) - 4)^ div 2;

  Code := l;

  while (l > 0) and (p^ <= Ord(WC_SPACE)) do
    begin
      Inc(p); Dec(l);
    end;

  if l = 0 then goto Fail;

  if p^ = Ord(WC_HYPHEN_MINUS) then
    begin
      Negative := True;
      Inc(p); Dec(l);
    end
  else
    begin
      Negative := False;
      if p^ = Ord(WC_PLUS_SIGN) then
        begin
          Inc(p); Dec(l);
        end;
    end;

  if l = 0 then goto Fail;

  case p^ of
    Ord(WC_DOLLAR_SIGN), Ord(WC_CAPITAL_X), Ord(WC_SMALL_X):
      goto Hex;
    Ord(WC_DIGIT_ZERO):
      begin
        Inc(p); Dec(l);
        if (l > 0) and ((p^ = Ord(WC_CAPITAL_X)) or (p^ = Ord(WC_SMALL_X))) then goto Hex;
      end;
  end;

  Result := 0;

  if Negative then
    while l > 0 do
      begin
        c := p^;
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 - c;
        if Result > 0 then goto Error;
        Inc(p); Dec(l);
      end
  else
    while l > 0 do
      begin
        c := p^;
        Dec(c, $30);
        if (c < 0) or (c > $09) then goto Error;
        Result := Result * 10 + c;
        if Result < 0 then goto Error;
        Inc(p); Dec(l);
      end;

  Code := 0;
  Exit;

  Hex:
  Inc(p);  Dec(l);
  if l = 0 then goto Fail;

  Result := 0;

  repeat
    c := p^;
    Dec(c, $30);
    if c > $09 then
      begin
        Dec(c, $11);
        if c > $05 then
          begin
            Dec(c, $20);
            if c > $05 then goto Error;
          end;
        if c < 0 then goto Error;
        Inc(c, $0A);
      end
    else
      if c < 0 then goto Error;

    if Result and $F000000000000000 <> 0 then goto Error;

    Result := Result shl 4 or c;

    Inc(p);
    Dec(l);
  until l = 0;

  if Negative then Result := -Result;
  Code := 0;
  Exit;

  Error:
  Dec(Code, l - 1);
  Exit;

  Fail:
  Code := -1;

end;
{$IFDEF Q_Temp}{$UNDEF Q_Temp}{$Q+}{$ENDIF}
{$IFNDEF DI_Show_Warnings}{$WARNINGS ON}{$ENDIF}

function YearOfJuilanDate(const JulianDate: TJulianDate): Integer;
var
  Month, Day: Word;
begin
  JulianDateToYmd(JulianDate, Result, Month, Day);
end;

function YmdToIsoDate(const Year: Integer; const Month, Day: Word): TIsoDate;
begin
  Result := Year * 10000 + Month * 100 + Day;
end;

function YmdToIsoDateA(const Year: Integer; const Month, Day: Word): AnsiString;
begin
  Result := PadLeftA(IntToStrA(Year * 10000 + Month * 100 + Day), 8, AC_DIGIT_ZERO);
end;

function YmdToIsoDateW(const Year: Integer; const Month, Day: Word): WideString;
begin
  Result := PadLeftW(IntToStrW(Year * 10000 + Month * 100 + Day), 8, WC_DIGIT_ZERO);
end;

function YmdToJulianDate(const Year: Integer; const Month, Day: Word): TJulianDate;
{$IFDEF Calender_FAQ}
var
  a, y, m: Integer;
begin
  a := (14 - Month) div 12;
  y := Year + 4800 - a;
  m := Month + 12 * a - 3;
  Result := Day + (153 * m + 2) div 5 + y * 365 + y div 4 - y div 100 + y div 400 - 32045;
end;
{$ELSE}
begin
  Result := (1461 * (Year + 4800 + (Month - 14) div 12)) div 4 +
    (367 * (Month - 2 - 12 * ((Month - 14) div 12))) div 12 -
    (3 * ((Year + 4900 + (Month - 14) div 12) div 100)) div 4 +
    Day - 32075;
end;
{$ENDIF}

procedure ZeroMem(const Buffer; const Size: Cardinal);

asm
        PUSH    EDI
        MOV     ECX,EAX
        XOR     EAX,EAX
        MOV     EDI,ECX
        NEG     ECX
        AND     ECX,7
        SUB     EDX,ECX
        JMP     DWORD PTR @@bV[ECX*4]
@@bV:   DD      @@bu00, @@bu01, @@bu02, @@bu03
        DD      @@bu04, @@bu05, @@bu06, @@bu07
@@bu07: MOV     [EDI+06],AL
@@bu06: MOV     [EDI+05],AL
@@bu05: MOV     [EDI+04],AL
@@bu04: MOV     [EDI+03],AL
@@bu03: MOV     [EDI+02],AL
@@bu02: MOV     [EDI+01],AL
@@bu01: MOV     [EDI],AL
        ADD     EDI,ECX
@@bu00: MOV     ECX,EDX
        AND     EDX,3
        SHR     ECX,2
        REP     STOSD
        JMP     DWORD PTR @@tV[EDX*4]
@@tV:   DD      @@tu00, @@tu01, @@tu02, @@tu03
@@tu03: MOV     [EDI+02],AL
@@tu02: MOV     [EDI+01],AL
@@tu01: MOV     [EDI],AL
@@tu00: POP     EDI
end;

{$IFDEF MSWINDOWS}
{$IFNDEF DI_No_Win_9X_Support}
procedure Init;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  IsUnicode := GetVersionEx(OSVersionInfo) and (OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT);
end;
{$ENDIF}
{$ENDIF}

{$IFDEF MSWINDOWS}
{$IFNDEF DI_No_Win_9X_Support}
initialization
  Init;
  {$ENDIF}
  {$ENDIF}

end.

