{-------------------------------------------------------------------------------
 
 Copyright (c) 1999-2003 The Delphi Inspiration - Ralf Junker
 Internet: http://www.zeitungsjunge.de/delphi/
 E-Mail:   delphi@zeitungsjunge.de

-------------------------------------------------------------------------------}

unit DICHelpers;

{$I DI.inc}

interface

function _malloc(const Size: Cardinal): Pointer; cdecl;
function _calloc(const NItems: Cardinal; const Size: Cardinal): Pointer; cdecl;
function _alloca(const Size: Cardinal): Pointer; cdecl;
procedure _free(const p: Pointer); cdecl;
function _realloc(const p: Pointer; const Size: Cardinal): Pointer; cdecl;

function _memcmp(const s1: Pointer; const s2: Pointer; const n: Cardinal): Integer; cdecl;
function _memcpy(Dest: Pointer; const Src: Pointer; n: Cardinal): Pointer; cdecl;
function _memmove(const Destination, Source: Pointer; const Count: Cardinal): Pointer; cdecl;
function _memset(const s: Pointer; const c: Integer; const n: Cardinal): Pointer; cdecl;

function _isalnum(const c: AnsiChar): Boolean; cdecl;
function _isalpha(const c: AnsiChar): Boolean; cdecl;
function _iscntrl(const c: AnsiChar): Boolean; cdecl;
function _isdigit(const c: AnsiChar): Boolean; cdecl;
function _isgraph(const c: AnsiChar): Boolean; cdecl;
function _islower(const c: AnsiChar): Boolean; cdecl;
function _isprint(const c: AnsiChar): Boolean; cdecl;
function _ispunct(const c: AnsiChar): Boolean; cdecl;
function _isspace(const c: AnsiChar): Boolean; cdecl;
function _isupper(const c: AnsiChar): Boolean; cdecl;
function _isxdigit(const c: AnsiChar): Boolean; cdecl;
function __ltolower(const c: AnsiChar): AnsiChar; cdecl;
function __ltoupper(const c: AnsiChar): AnsiChar; cdecl;

function _strchr(const s: PAnsiChar; const c: AnsiChar): PAnsiChar; cdecl;
function _strlen(const s: PAnsiChar): Cardinal; cdecl;
function _strncmp(const s1, s2: PAnsiChar; const MaxLen: Cardinal): Integer; cdecl;
function _strncpy(const Dest: PAnsiChar; const Src: PAnsiChar; const MaxLen: Cardinal): PAnsiChar; cdecl;

procedure __llushr;

implementation

uses
  Windows,
  SysUtils;

function _malloc(const Size: Cardinal): Pointer; cdecl;
begin
  GetMem(Result, Size);
end;

function _calloc(const NItems: Cardinal; const Size: Cardinal): Pointer; cdecl;
begin
  GetMem(Result, NItems * Size);
end;

function _alloca(const Size: Cardinal): Pointer; cdecl;
begin
  GetMem(Result, Size);
end;

procedure _free(const p: Pointer); cdecl;
begin
  FreeMem(p);
end;

function _realloc(const p: Pointer; const Size: Cardinal): Pointer; cdecl;
begin
  Result := p;
  ReallocMem(Result, Size);
end;

function _memcmp(const s1: Pointer; const s2: Pointer; const n: Cardinal): Integer; cdecl;
label
  Success;
type
  TByte4 = packed record
    b0, b1, b2, b3: Byte;
  end;
  PByte4 = ^TByte4;
var
  p1, p2: PByte4;
  b1, b2: Byte;
  l: Cardinal;
begin
  p1 := s1;
  p2 := s2;
  if p1 = p2 then goto Success;
  l := n;

  repeat
    if l = 0 then goto Success;
    b1 := p1^.b0; b2 := p2^.b0;
    if b1 <> b2 then Break;
    Dec(l);

    if l = 0 then goto Success;
    b1 := p1^.b1; b2 := p2^.b1;
    if b1 <> b2 then Break;
    Dec(l);

    if l = 0 then goto Success;
    b1 := p1^.b2; b2 := p2^.b2;
    if b1 <> b2 then Break;
    Dec(l);

    if l = 0 then goto Success;
    b1 := p1^.b3; b2 := p2^.b3;
    if b1 <> b2 then Break;

    Inc(p1);
    Inc(p2);
    Dec(l);
  until False;

  Result := b1 - b2;
  Exit;

  Success:
  Result := 0;
end;

function _memcpy(Dest: Pointer; const Src: Pointer; n: Cardinal): Pointer; cdecl;
begin
  Result := Dest;
  Move(Src^, Result^, n);
end;

function _memmove(const Destination, Source: Pointer; const Count: Cardinal): Pointer; cdecl;
begin
  Result := Destination;
  Move(Source^, Result^, Count);
end;

function _memset(const s: Pointer; const c: Integer; const n: Cardinal): Pointer; cdecl;
begin
  Result := s;
  FillChar(Result^, n, c);
end;

function _isalnum(const c: AnsiChar): Boolean; cdecl;
begin
  Result := IsCharAlphaNumericA(c);
end;

function _isalpha(const c: AnsiChar): Boolean; cdecl;
begin
  Result := IsCharAlphaA(c);
end;

function _iscntrl(const c: AnsiChar): Boolean; cdecl;
var
  CharType: Word;
begin
  GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @c, SizeOf(c), CharType);
  Result := (CharType and C1_CNTRL) <> 0;
end;

function _isdigit(const c: AnsiChar): Boolean; cdecl;
var
  CharType: Word;
begin
  GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @c, SizeOf(c), CharType);
  Result := Boolean(CharType and C1_DIGIT);
end;

function _isgraph(const c: AnsiChar): Boolean; cdecl;
begin
  Result := IsCharAlphaNumericA(c);
end;

function _islower(const c: AnsiChar): Boolean; cdecl;
begin
  Result := IsCharLowerA(c);
end;

function _isprint(const c: AnsiChar): Boolean; cdecl;
var
  CharType: Word;
begin
  GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @c, SizeOf(c), CharType);
  Result := (CharType and C1_CNTRL) = 0;
end;

function _ispunct(const c: AnsiChar): Boolean; cdecl;
var
  CharType: Word;
begin
  GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @c, SizeOf(c), CharType);
  Result := (CharType and C1_PUNCT) <> 0;
end;

function _isspace(const c: AnsiChar): Boolean; cdecl;
var
  CharType: Word;
begin
  GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @c, SizeOf(c), CharType);
  Result := (CharType and C1_SPACE) <> 0;
end;

function _isupper(const c: AnsiChar): Boolean; cdecl;
begin
  Result := IsCharUpperA(c);
end;

function _isxdigit(const c: AnsiChar): Boolean; cdecl;
var
  CharType: Word;
begin
  GetStringTypeExA(LOCALE_USER_DEFAULT, CT_CTYPE1, @c, SizeOf(c), CharType);
  Result := (CharType and C1_XDIGIT) <> 0;
end;

function __ltolower(const c: AnsiChar): AnsiChar; cdecl;
begin
  Result := c;
  CharLowerBuffA(@Result, SizeOf(Result));
end;

function __ltoupper(const c: AnsiChar): AnsiChar; cdecl;
begin
  Result := c;
  CharUpperBuffA(@Result, SizeOf(Result));
end;

function _strchr(const s: PAnsiChar; const c: AnsiChar): PAnsiChar; cdecl;
begin
  Result := StrScan(s, c);
end;

function _strlen(const s: PAnsiChar): Cardinal; cdecl;
begin
  Result := StrLen(s);
end;

function _strncmp(const s1, s2: PAnsiChar; const MaxLen: Cardinal): Integer; cdecl;
begin
  Result := StrLComp(s1, s2, MaxLen);
end;

function _strncpy(const Dest: PAnsiChar; const Src: PAnsiChar; const MaxLen: Cardinal): PAnsiChar; cdecl;
begin
  Result := Dest;
  StrLCopy(Result, Src, MaxLen);
end;

procedure __llushr;

asm
  cmp cl, 32
  jl  @__llushr@below32
  cmp cl, 64
  jl  @__llushr@below64
  xor edx, edx
  xor eax, eax
  ret

@__llushr@below64:
  mov eax, edx
  xor edx, edx
  shr eax, cl
  ret

@__llushr@below32:
  shrd  eax, edx, cl
  shr edx, cl
end;

end.

