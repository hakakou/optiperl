{-------------------------------------------------------------------------------
 
 Copyright (c) 1999-2003 The Delphi Inspiration - Ralf Junker
 Internet: http://www.zeitungsjunge.de/delphi/
 E-Mail:   delphi@zeitungsjunge.de

-------------------------------------------------------------------------------}

unit DIPcreApi;

{$I DI.inc}

interface

const

  MATCH_LIMIT = 10000000;

  PCRE_CASELESS = $0001;
  PCRE_MULTILINE = $0002;
  PCRE_DOTALL = $0004;
  PCRE_EXTENDED = $0008;
  PCRE_ANCHORED = $0010;
  PCRE_DOLLAR_ENDONLY = $0020;
  PCRE_EXTRA = $0040;
  PCRE_NOTBOL = $0080;
  PCRE_NOTEOL = $0100;
  PCRE_UNGREEDY = $0200;
  PCRE_NOTEMPTY = $0400;
  PCRE_UTF8 = $0800;
  PCRE_NO_AUTO_CAPTURE = $1000;
  PCRE_NO_UTF8_CHECK = $2000;

  PCRE_ERROR_NOMATCH = -1;

  PCRE_ERROR_NULL = -2;

  PCRE_ERROR_BADOPTION = -3;

  PCRE_ERROR_BADMAGIC = -4;

  PCRE_ERROR_UNKNOWN_NODE = -5;

  PCRE_ERROR_NOMEMORY = -6;

  PCRE_ERROR_NOSUBSTRING = -7;

  PCRE_ERROR_MATCHLIMIT = -8;

  PCRE_ERROR_CALLOUT = -9;

  PCRE_ERROR_BADUTF8 = -10;

  PCRE_ERROR_BADUTF8_OFFSET = -11;

  PCRE_INFO_OPTIONS = 0;

  PCRE_INFO_SIZE = 1;

  PCRE_INFO_CAPTURECOUNT = 2;

  PCRE_INFO_BACKREFMAX = 3;

  PCRE_INFO_FIRSTBYTE = 4;

  PCRE_INFO_FIRSTCHAR = 4;

  PCRE_INFO_FIRSTTABLE = 5;

  PCRE_INFO_LASTLITERAL = 6;

  PCRE_INFO_NAMEENTRYSIZE = 7;

  PCRE_INFO_NAMECOUNT = 8;

  PCRE_INFO_NAMETABLE = 9;

  PCRE_INFO_STUDYSIZE = 10;

  PCRE_CONFIG_UTF8 = 0;

  PCRE_CONFIG_NEWLINE = 1;

  PCRE_CONFIG_LINK_SIZE = 2;

  PCRE_CONFIG_POSIX_MALLOC_THRESHOLD = 3;

  PCRE_CONFIG_MATCH_LIMIT = 4;

  PCRE_CONFIG_STACKRECURSE = 5;

  PCRE_EXTRA_STUDY_DATA = $0001;
  PCRE_EXTRA_MATCH_LIMIT = $0002;
  PCRE_EXTRA_CALLOUT_DATA = $0004;

  MAGIC_NUMBER = $50435245;

  ctype_space = $01;
  ctype_letter = $02;
  ctype_digit = $04;
  ctype_xdigit = $08;
  ctype_word = $10;

  ctype_meta = $80;

type

  PInteger = ^Integer;

  PPAnsiChar = ^PAnsiChar;

  TPcre_Callout_Block = packed record
    Version: Integer;

    Callout_Number: Integer;
    offset_vector: PInteger;
    Subject: PAnsiChar;
    subject_length: Integer;
    start_match: Integer;
    current_position: Integer;
    capture_top: Integer;
    capture_last: Integer;
    Callout_Data: Pointer;

  end;

  PPcre_Callout_Block = ^TPcre_Callout_Block;

var
  _pcre_callout: function(const pcre_callout_block: PPcre_Callout_Block): Integer = nil;

const

  cbit_space = 0;

  cbit_xdigit = 32;

  cbit_digit = 64;

  cbit_upper = 96;

  cbit_lower = 128;

  cbit_word = 160;

  cbit_graph = 192;

  cbit_print = 224;

  cbit_punct = 256;

  cbit_cntrl = 288;

  cbit_length = 320;

  lcc_offset = 0;
  fcc_offset = 256;
  cbits_offset = 512;
  ctypes_offset = cbits_offset + cbit_length;
  tables_length = ctypes_offset + 256;

type

  TRealPcre = packed record
    MAGIC_NUMBER: Cardinal;
    Size: Cardinal;
    Tables: PAnsiChar;
    Options: Cardinal;
    top_bracket: Word;
    top_backref: Word;
    first_char: Word;
    req_char: Word;
    Name_Entry_Size: Word;
    Name_Count: Word;
    Name_Table_1st_Number: Word;
    Name_Table_1st_Name: record end;
  end;

  PRealPcre = ^TRealPcre;

  TPcre_Extra = packed record
    Flags: Cardinal;
    Study_Data: Pointer;
    MATCH_LIMIT: Cardinal;
    Callout_Data: Pointer;
  end;
  PPcre_Extra = ^TPcre_Extra;

function pcre_compile(
  const Pattern: PAnsiChar;
  Options: Integer;
  const ErrPtr: PPAnsiChar;
  ErrOffset: PInteger;
  const TablePtr: PAnsiChar): PRealPcre;

function pcre_config(
  What: Integer;
  Where: Pointer): Integer;

function pcre_copy_substring(
  const Subject: PAnsiChar;
  OVector: PInteger;
  stringcount: Integer;
  stringnumber: Integer;
  Buffer: PAnsiChar;
  Size: Integer): Integer;

function pcre_exec(
  const Code: PRealPcre;
  const Extra: PPcre_Extra;
  const Subject: PAnsiChar;
  Length: Integer;
  StartOffSet: Integer;
  Options: Integer;
  OVector: PInteger;
  OVecSize: Integer): Integer;

function pcre_fullinfo(
  const Code: PRealPcre;
  const Extra: PPcre_Extra;
  What: Integer;
  Where: Pointer): Integer;

function pcre_info(
  const Code: PRealPcre;
  optptr: PInteger;
  firstcharptr: PInteger): Integer;

function pcre_maketables: PAnsiChar;

function pcre_get_named_substring(
  const Code: PRealPcre;
  const Subject: PAnsiChar;
  OVector: PInteger;
  stringcount: Integer;
  const stringname: PAnsiChar;
  const stringptr: PPAnsiChar): Integer;

function pcre_get_substring(
  const Subject: PAnsiChar;
  OVector: PInteger;
  stringcount: Integer;
  stringnumber: Integer;
  const stringptr: PPAnsiChar): Integer;

function pcre_get_stringnumber(
  const Code: PRealPcre;
  const Name: PAnsiChar): Integer;

function Pcre_Study(
  const Code: PRealPcre;
  Options: Integer;
  ErrPtr: PPAnsiChar): PPcre_Extra;

function Pcre_Version: PAnsiChar;

function dftables: AnsiString;

implementation

uses

  SysUtils,
  DICHelpers;

{$L get.obj}
{$L pcre.obj}
{$L study.obj}
{$L maketables.obj}

function dftables: AnsiString;
type
  TByteArray = array[0..MaxInt div SizeOf(Byte) - 1] of Byte;
  PByteArray = ^TByteArray;
var
  i: Integer;
  Tables: PByteArray;
begin
  Tables := Pointer(pcre_maketables);
  try

    Result := 'static unsigned char pcre_default_tables[] = {'#13#10;
    for i := 0 to tables_length - 1 do
      begin
        Result := Result + IntToStr(Tables[i]);
        if i <> tables_length - 1 then Result := Result + ',';
        if (i + 1) mod 8 = 0 then Result := Result + #13#10;
      end;
    Result := Result + '};';
  finally
    FreeMem(Tables);
  end;
end;

function pcre_compile; external;
function pcre_config; external;
function pcre_copy_substring; external;
function pcre_exec; external;
function pcre_fullinfo; external;
function pcre_get_named_substring; external;
function pcre_get_stringnumber; external;
function pcre_get_substring; external;
function pcre_info; external;
function pcre_maketables; external;
function Pcre_Study; external;
function Pcre_Version; external;

end.

