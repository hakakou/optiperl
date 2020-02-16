{-------------------------------------------------------------------------------
 
 Copyright (c) 1999-2003 The Delphi Inspiration - Ralf Junker
 Internet: http://www.zeitungsjunge.de/delphi/
 E-Mail:   delphi@zeitungsjunge.de

-------------------------------------------------------------------------------}

unit DIPcreUtils;

{$I DI.inc}

interface

function AnsiMatchPcreCS(const Pattern, Text: AnsiString; const StartOffSet: Cardinal = 1): Integer;

function AnsiMatchPcreCI(const Pattern, Text: AnsiString; const StartOffSet: Cardinal = 1): Integer;

function StrPosPcreA(const Pattern, Text: AnsiString; const StartOffSet: Cardinal = 1): Integer;

function StrPosPcreIA(const Pattern, Text: AnsiString; const StartOffSet: Cardinal = 1): Integer;

function StrPosPcreW(const Search, Source: WideString; const StartOffSet: Cardinal = 1): Integer;

function StrPosPcreIW(const Search, Source: WideString; const StartOffSet: Cardinal = 1): Integer;

function WildCardToPcre(const WildCardString: AnsiString): AnsiString;

implementation

uses
  DIPcreApi,
  DIUtils
  ;

type
  PCardinal = ^Cardinal;

function AnsiMatchPcreCS(const Pattern, Text: AnsiString; const StartOffSet: Cardinal = 1): Integer;
label
  Fail, StudyFail;
var
  Code: PRealPcre;
  Extra: PPcre_Extra;
  Error: PAnsiChar;
  ErrOffset: Integer;
begin
  Code := pcre_compile(PAnsiChar(Pattern), PCRE_MULTILINE or PCRE_ANCHORED, @Error, @ErrOffset, nil);
  if Code = nil then goto Fail;

  Extra := Pcre_Study(Code, 0, @Error);
  if Error <> nil then goto StudyFail;

  Result := pcre_exec(Code, Extra, PAnsiChar(Text), Length(Text), StartOffSet - 1, 0, nil, 0);

  FreeMem(Code);
  FreeMem(Extra);
  Exit;

  StudyFail:
  FreeMem(Code);
  Fail:
  Result := PCRE_ERROR_NOMATCH;
end;

function AnsiMatchPcreCI(const Pattern, Text: AnsiString; const StartOffSet: Cardinal = 1): Integer;
label
  Fail, StudyFail;
var
  Code: PRealPcre;
  Extra: PPcre_Extra;
  Error: PAnsiChar;
  ErrOffset: Integer;
begin
  Code := pcre_compile(PAnsiChar(Pattern), PCRE_CASELESS or PCRE_MULTILINE or PCRE_ANCHORED, @Error, @ErrOffset, nil);
  if Code = nil then goto Fail;

  Extra := Pcre_Study(Code, 0, @Error);
  if Error <> nil then goto StudyFail;

  Result := pcre_exec(Code, Extra, PAnsiChar(Text), Length(Text), StartOffSet - 1, 0, nil, 0);

  FreeMem(Code);
  FreeMem(Extra);
  Exit;

  StudyFail:
  FreeMem(Code);
  Fail:
  Result := PCRE_ERROR_NOMATCH;
end;

function StrPosPcreA(const Pattern, Text: AnsiString; const StartOffSet: Cardinal = 1): Integer;
const
  VECTOR_SIZE = 16;
label
  Fail, StudyFail;
var
  Code: PRealPcre;
  Extra: PPcre_Extra;
  Error: PAnsiChar;
  ErrOffset: Integer;
  Vector: array[0..VECTOR_SIZE - 1] of Integer;
begin
  Code := pcre_compile(PAnsiChar(Pattern), PCRE_MULTILINE, @Error, @ErrOffset, nil);
  if Code = nil then goto Fail;

  Extra := Pcre_Study(Code, 0, @Error);
  if Error <> nil then goto StudyFail;

  Result := pcre_exec(Code, Extra, PAnsiChar(Text), Length(Text), StartOffSet - 1, 0, Pointer(@Vector), VECTOR_SIZE);
  if Result >= 0 then Result := Vector[0] + 1;

  FreeMem(Code);
  FreeMem(Extra);
  Exit;

  StudyFail:
  FreeMem(Code);
  Fail:
  Result := PCRE_ERROR_NOMATCH;
end;

function StrPosPcreIA(const Pattern, Text: AnsiString; const StartOffSet: Cardinal = 1): Integer;
const
  VECTOR_SIZE = 16;
label
  Fail, StudyFail;
var
  Code: PRealPcre;
  Extra: PPcre_Extra;
  Error: PAnsiChar;
  ErrOffset: Integer;
  Vector: array[0..VECTOR_SIZE - 1] of Integer;
begin
  Code := pcre_compile(PAnsiChar(Pattern), PCRE_CASELESS or PCRE_MULTILINE, @Error, @ErrOffset, nil);
  if Code = nil then goto Fail;

  Extra := Pcre_Study(Code, 0, @Error);
  if Error <> nil then goto StudyFail;

  Result := pcre_exec(Code, Extra, PAnsiChar(Text), Length(Text), StartOffSet - 1, 0, Pointer(@Vector), VECTOR_SIZE);
  if Result >= 0 then Result := Vector[0] + 1;

  FreeMem(Code);
  FreeMem(Extra);
  Exit;

  StudyFail:
  FreeMem(Code);
  Fail:
  Result := PCRE_ERROR_NOMATCH;
end;

function StrPosPcreIW(const Search, Source: WideString; const StartOffSet: Cardinal = 1): Integer;
const
  VECTOR_SIZE = 16;
label
  Fail, StudyFail;
var
  Search8, Source8: AnsiString;
  Code: PRealPcre;
  Extra: PPcre_Extra;
  Error: PAnsiChar;
  ErrOffset: Integer;
  Vector: array[0..VECTOR_SIZE - 1] of Integer;
begin
  Search8 := StrEncodeUtf8(Search);
  Code := pcre_compile(PAnsiChar(Search8), PCRE_CASELESS or PCRE_MULTILINE or PCRE_UTF8 or PCRE_NO_UTF8_CHECK, @Error, @ErrOffset, nil);
  if Code = nil then goto Fail;

  Extra := Pcre_Study(Code, 0, @Error);
  if Error <> nil then goto StudyFail;

  Source8 := StrEncodeUtf8(Source);
  Result := pcre_exec(Code, Extra, PAnsiChar(Source8), Length(Source8), StartOffSet - 1, PCRE_NO_UTF8_CHECK, Pointer(@Vector), VECTOR_SIZE);
  if Result >= 0 then Result := Vector[0] + 1;

  FreeMem(Code);
  FreeMem(Extra);
  Exit;

  StudyFail:
  FreeMem(Code);
  Fail:
  Result := PCRE_ERROR_NOMATCH;
end;

function StrPosPcreW(const Search, Source: WideString; const StartOffSet: Cardinal = 1): Integer;
const
  VECTOR_SIZE = 16;
label
  Fail, StudyFail;
var
  Search8, Source8: AnsiString;
  Code: PRealPcre;
  Extra: PPcre_Extra;
  Error: PAnsiChar;
  ErrOffset: Integer;
  Vector: array[0..VECTOR_SIZE - 1] of Integer;
begin
  Search8 := StrEncodeUtf8(Search);
  Code := pcre_compile(PAnsiChar(Search8), PCRE_MULTILINE or PCRE_UTF8 or PCRE_NO_UTF8_CHECK, @Error, @ErrOffset, nil);
  if Code = nil then goto Fail;

  Extra := Pcre_Study(Code, 0, @Error);
  if Error <> nil then goto StudyFail;

  Source8 := StrEncodeUtf8(Source);
  Result := pcre_exec(Code, Extra, PAnsiChar(Source8), Length(Source8), StartOffSet - 1, PCRE_NO_UTF8_CHECK, Pointer(@Vector), VECTOR_SIZE);
  if Result >= 0 then Result := Vector[0] + 1;

  FreeMem(Code);
  FreeMem(Extra);
  Exit;

  StudyFail:
  FreeMem(Code);
  Fail:
  Result := PCRE_ERROR_NOMATCH;
end;

function WildCardToPcre(const WildCardString: AnsiString): AnsiString;
var
  PSource, PDest: PAnsiChar;
  l: Cardinal;
  c: AnsiChar;
begin
  PSource := Pointer(WildCardString);
  if PSource = nil then Exit;

  l := PCardinal(PSource - 4)^;
  if l = 0 then Exit;

  SetLength(Result, l * 2 + 2);
  PDest := Pointer(Result);

  PDest^ := '^';
  Inc(PDest);

  while l > 0 do
    begin
      c := PSource^;
      Inc(PSource);
      Dec(l);
      case c of
        '*':
          begin
            PDest^ := '.';
            PDest[1] := '*';
            Inc(PDest, 2);
          end;
        '?':
          begin
            PDest^ := '.';
            PDest[1] := '?';
            Inc(PDest, 2);
          end;
        '\', '^', '$', '.', '[', '|', '(', ')', '+', '{':
          begin
            PDest^ := '\';
            PDest[1] := c;
            Inc(PDest, 2);
          end;
      else
        PDest^ := c;
        Inc(PDest);
      end;
    end;

  PDest^ := '$';
  Inc(PDest);

  SetLength(Result, Cardinal(PDest) - Cardinal(Result));
end;

initialization

end.

