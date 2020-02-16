{*******************************************************}
{                                                       }
{       Alex Ghost Library                              }
{                                                       }
{       Copyright (c) 1999,2000 Alexey Popov            }
{                                                       }
{*******************************************************}

// The most part of this string functions is taken from RxLib
//  http://www.rxlib.com

{$I AG.INC}

unit agStrUtils;

interface

uses SysUtils, Windows;

type
{$IFNDEF D4}
  TSysCharSet = set of char;
{$ENDIF}
  TCharSet = TSysCharSet;

// AnsiToOemStr translates a string from the Windows character set into the
//  OEM character set.
function AnsiToOemStr(const AnsiStr: string): string;

// OemToAnsiStr translates a string from the OEM character set into the
//  Windows character set.
function OemToAnsiStr(const OemStr: string): string;

// Returns string with every occurrence of Srch string replaced with
//  Replace string.
function ReplaceStr(const S, Srch, Replace: string): string;

// DelSpace return a string with all white spaces removed.
function DelSpace(const S: string): string;

// DelChars return a string with all Chr characters removed.
function DelChars(const S: string; Chr: Char): string;

// DelSpace1 return a string with all non-single white spaces removed.
function DelSpace1(const S: string): string;

// Tab2Space converts any tabulation character in the given string to the
//  Numb spaces characters.
function Tab2Space(const S: string; Numb: Byte): string;

// NPos searches for a N-th position of substring C in a given string.
function NPos(const C: string; S: string; N: Integer): Integer;

// AddCharL return a string left-padded to length N with characters C.
function AddCharL(C: Char; const S: string; N: Integer): string;

// AddCharR return a string right-padded to length N with characters C.
function AddCharR(C: Char; const S: string; N: Integer): string;

// Copy2Symb returns a substring of a string S from begining to first
//  character Symb.
function Copy2Symb(const S: string; Symb: Char): string;

// Copy2SymbDel returns a substring of a string S from begining to first
//  character Symb and removes this substring from S.
function Copy2SymbDel(var S: string; Symb: Char): string;

// WordCount given a set of word delimiters, return number of words in S.
function WordCount(const S: string; const WordDelims: TCharSet): Integer;

// Given a set of word delimiters, return start position of N'th word in S.
function WordPosition(const N: Integer; const S: string;
  const WordDelims: TCharSet): Integer;

// GetWord, GetWordPos and GetWordDelim given a set of word delimiters,
// return the N'th word in S.
function GetWord(N: Integer; const S: string; const WordDelims: TCharSet): string;
function GetWordPos(N: Integer; const S: string; const WordDelims: TCharSet;
  var Pos: Integer): string;
function GetWordDelim(N: Integer; const S: string; const Delims: TCharSet): string;

// IsWordPresent given a set of word delimiters, return True if word W is
//  present in string S.
function IsWordPresent(const W, S: string; const WordDelims: TCharSet;
  CaseSensitive: boolean): Boolean;

// ExtractQuotedStr removes the Quote characters from the beginning and
//  end of a quoted string, and reduces pairs of Quote characters within
//  the quoted string to a single character.
function ExtractQuotedStr(const S: string; Quote: Char): string;

// FindPart compares a string with '?' and another, returns the position of
//  HelpWilds in InputStr.
function FindPart(const HelpWilds, InputStr: string): Integer;

// IsWild compare InputString with WildCard string and return True
//  if corresponds.
function IsWild(InputStr, Wilds: string; IgnoreCase: Boolean): Boolean;

{ ** Command line routines ** }

{$IFNDEF D4}
function FindCmdLineSwitch(const Switch: string; SwitchChars: TCharSet;
  IgnoreCase: Boolean): Boolean;
{$ENDIF}
function FindSwitch(const Switch: string): Boolean;
function GetCmdLineArg(const Switch: string; SwitchChars: TCharSet): string;
procedure SplitCommandLine(const CmdLine: string; var ExeName, Params: string);

{ ** Numeric string handling routines ** }

// Dec2Hex converts the given value to a hexadecimal string representation
//  with the minimum number of digits (A) specified.
function Dec2Hex(N: Longint; A: Byte): string;

// Hex2Dec converts the given hexadecimal string to the corresponding integer
//  value.
function Hex2Dec(const S: string): Longint;

// Dec2Numb converts the given value to a string representation with the
//  base equal to B and with the minimum number of digits (A) specified.
function Dec2Numb(N: Longint; A, B: Byte): string;

// Numb2Dec converts the given B-based numeric string to the corresponding
//  integer value.
function Numb2Dec(S: string; B: Byte): Longint;

function LeftStr(const S: string; N: Integer): string;
function RightStr(const S: string; N: Integer): string;

function LeftPart(const S: string; C: char): string;
function RightPart(const S: string; C: char): string;

function IniLeftPart(const S: string): string;
function IniRightPart(const S: string): string;

function TextSize(Wnd: HWnd; const Text: string): TSize;
function TextSizeDC(DC: HDC; const Text: string): TSize;
function TextToLines(Wnd: HWnd; const Text: string; MaxLen: integer): string;
function TextToLinesDC(DC: HDC; const Text: string; MaxLen: integer): string;
function MinimizeText(Wnd: HWnd; const Text: string; MaxWidth: Integer): string;
function MinimizeTextDC(DC: HDC; const Text: string; MaxWidth: Integer): string;

function GetWordParam(N: Integer; const S: string; const WordDelims: TCharSet): string;

const
  DigitChars = ['0'..'9'];
  Brackets = ['(',')','[',']','{','}'];
  StdWordDelims = [#0..' ',',','.',';','/','\',':','''','"','`'] + Brackets;

implementation

uses Messages, agArithm;

function AnsiToOemStr(const AnsiStr: string): string;
begin
  SetLength(Result, Length(AnsiStr));
  if Length(Result) > 0 then
    CharToOemBuff(PChar(AnsiStr), PChar(Result), Length(Result));
end;

function OemToAnsiStr(const OemStr: string): string;
begin
  SetLength(Result, Length(OemStr));
  if Length(Result) > 0 then
    OemToCharBuff(PChar(OemStr), PChar(Result), Length(Result));
end;

function ReplaceStr(const S, Srch, Replace: string): string;
var
  I: Integer;
  Source: string;
begin
  Source := S;
  Result := '';
  repeat
    I := Pos(Srch, Source);
    if I > 0 then begin
      Result := Result + Copy(Source, 1, I - 1) + Replace;
      Source := Copy(Source, I + Length(Srch), System.MaxInt);
    end
    else Result := Result + Source;
  until I <= 0;
end;

function DelSpace(const S: String): string;
begin
  Result := DelChars(S, ' ');
end;

function DelChars(const S: string; Chr: Char): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 1 do begin
    if Result[I] = Chr then Delete(Result, I, 1);
  end;
end;

function DelSpace1(const S: string): string;
var
  I: Integer;
begin
  Result := S;
  for I := Length(Result) downto 2 do begin
    if (Result[I] = ' ') and (Result[I - 1] = ' ') then
      Delete(Result, I, 1);
  end;
end;

function Tab2Space(const S: string; Numb: Byte): string;
var
  I: Integer;
begin
  I := 1;
  Result := S;
  while I <= Length(Result) do begin
    if Result[I] = Chr(9) then begin
      Delete(Result, I, 1);
      Insert(StringOfChar(' ', Numb), Result, I);
      Inc(I, Numb);
    end
    else Inc(I);
  end;
end;

function NPos(const C: string; S: string; N: Integer): Integer;
var
  I, P, K: Integer;
begin
  Result := 0;
  K := 0;
  for I := 1 to N do begin
    P := Pos(C, S);
    Inc(K, P);
    if (I = N) and (P > 0) then begin
      Result := K;
      Exit;
    end;
    if P > 0 then Delete(S, 1, P)
    else Exit;
  end;
end;

function AddCharL(C: Char; const S: string; N: Integer): string;
begin
  if Length(S) < N then
    Result := StringOfChar(C, N - Length(S)) + S
  else Result := S;
end;

function AddCharR(C: Char; const S: string; N: Integer): string;
begin
  if Length(S) < N then
    Result := S + StringOfChar(C, N - Length(S))
  else Result := S;
end;

function LeftStr(const S: string; N: Integer): string;
begin
  Result:=Copy(S,1,N);
end;

function RightStr(const S: string; N: Integer): string;
begin
  Result:=Copy(S,length(S)-N+1,N);
end;

function Copy2Symb(const S: string; Symb: Char): string;
var
  P: Integer;
begin
  P := Pos(Symb, S);
  if P = 0 then P := Length(S) + 1;
  Result := Copy(S, 1, P - 1);
end;

function Copy2SymbDel(var S: string; Symb: Char): string;
begin
  Result := Copy2Symb(S, Symb);
  S := Copy(S, Length(Result) + 1, Length(S));
end;

function WordCount(const S: string; const WordDelims: TCharSet): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do begin
    while (I <= SLen) and (S[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(Result);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
end;

function WordPosition(const N: Integer; const S: string;
  const WordDelims: TCharSet): Integer;
var
  Count, I: Integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do begin
    { skip over delimiters }
    while (I <= Length(S)) and (S[I] in WordDelims) do Inc(I);
    { if we're not beyond end of S, we're at the start of a word }
    if I <= Length(S) then Inc(Count);
    { if not finished, find the end of the current word }
    if Count <> N then
      while (I <= Length(S)) and not (S[I] in WordDelims) do Inc(I)
    else Result := I;
  end;
end;

function GetWord(N: Integer; const S: string; const WordDelims: TCharSet): string;
var
  I: Integer;
  Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and not(S[I] in WordDelims) do begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

function GetWordPos(N: Integer; const S: string; const WordDelims: TCharSet;
  var Pos: Integer): string;
var
  I, Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  Pos := I;
  if I <> 0 then
    { find the end of the current word }
    while (I <= Length(S)) and not(S[I] in WordDelims) do begin
      { add the I'th character to result }
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  SetLength(Result, Len);
end;

function GetWordDelim(N: Integer; const S: string; const Delims: TCharSet): string;
var
  CurWord: Integer;
  I, Len, SLen: Integer;
begin
  CurWord := 0;
  I := 1;
  Len := 0;
  SLen := Length(S);
  SetLength(Result, 0);
  while (I <= SLen) and (CurWord <> N) do begin
    if S[I] in Delims then Inc(CurWord)
    else begin
      if CurWord = N - 1 then begin
        Inc(Len);
        SetLength(Result, Len);
        Result[Len] := S[I];
      end;
    end;
    Inc(I);
  end;
end;

function IsWordPresent(const W, S: string; const WordDelims: TCharSet;
  CaseSensitive: boolean): Boolean;
var
  Count, I: Integer;
  s1: string;
begin
  Result := False;
  Count := WordCount(S, WordDelims);
  for I := 1 to Count do begin
    s1 := GetWord(I, S, WordDelims);
    if CaseSensitive then begin
      if AnsiCompareStr(s1,W) = 0 then begin
        Result := True;
        Exit;
      end;
    end else
      if AnsiCompareText(s1,W) = 0 then begin
        Result := True;
        Exit;
      end;
  end;
end;

function ExtractQuotedStr(const S: string; Quote: Char): string;
var
  P: PChar;
begin
  P := PChar(S);
  if P^ = Quote then Result := AnsiExtractQuotedStr(P, Quote)
  else Result := S;
end;

function Dec2Hex(N: LongInt; A: Byte): string;
begin
  Result := IntToHex(N, A);
end;

function Hex2Dec(const S: string): Longint;
var
  HexStr: string;
begin
  if Pos('$', S) = 0 then HexStr := '$' + S
  else HexStr := S;
  Result := StrToIntDef(HexStr, 0);
end;

function Dec2Numb(N: Longint; A, B: Byte): string;
var
  C: Integer;
{$IFDEF D4}
  Number: Cardinal;
{$ELSE}
  Number: Longint;
{$ENDIF}
begin
  if N = 0 then Result := '0'
  else begin
{$IFDEF D4}
    Number := Cardinal(N);
{$ELSE}
    Number := N;
{$ENDIF}
    Result := '';
    while Number > 0 do begin
      C := Number mod B;
      if C > 9 then C := C + 55
      else C := C + 48;
      Result := Chr(C) + Result;
      Number := Number div B;
    end;
  end;
  if Result <> '' then Result := AddCharL('0', Result, A);
end;

function Numb2Dec(S: string; B: Byte): Longint;
var
  I, P: Longint;
begin
  I := Length(S);
  Result := 0;
  S := UpperCase(S);
  P := 1;
  while (I >= 1) do begin
    if S[I] > '@' then Result := Result + (Ord(S[I]) - 55) * P
    else Result := Result + (Ord(S[I]) - 48) * P;
    Dec(I);
    P := P * B;
  end;
end;

function FindPart(const HelpWilds, InputStr: string): Integer;
var
  I, J: Integer;
  Diff: Integer;
begin
  I := Pos('?', HelpWilds);
  if I = 0 then begin
    { if no '?' in HelpWilds }
    Result := Pos(HelpWilds, InputStr);
    Exit;
  end;
  { '?' in HelpWilds }
  Diff := Length(InputStr) - Length(HelpWilds);
  if Diff < 0 then begin
    Result := 0;
    Exit;
  end;
  { now move HelpWilds over InputStr }
  for I := 0 to Diff do begin
    for J := 1 to Length(HelpWilds) do begin
      if (InputStr[I + J] = HelpWilds[J]) or
        (HelpWilds[J] = '?') then
      begin
        if J = Length(HelpWilds) then begin
          Result := I + 1;
          Exit;
        end;
      end
      else Break;
    end;
  end;
  Result := 0;
end;

function IsWild(InputStr, Wilds: string; IgnoreCase: Boolean): Boolean;

 function SearchNext(var Wilds: string): Integer;
 { looking for next *, returns position and string until position }
 begin
   Result := Pos('*', Wilds);
   if Result > 0 then Wilds := Copy(Wilds, 1, Result - 1);
 end;

var
  CWild, CInputWord: Integer; { counter for positions }
  I, LenHelpWilds: Integer;
  MaxInputWord, MaxWilds: Integer; { Length of InputStr and Wilds }
  HelpWilds: string;
begin
  if IgnoreCase then begin { upcase all letters }
    InputStr := AnsiUpperCase(InputStr);
    Wilds := AnsiUpperCase(Wilds);
  end;
  if Wilds = InputStr then begin
    Result := True;
    Exit;
  end;
  repeat { delete '**', because '**' = '*' }
    I := Pos('**', Wilds);
    if I > 0 then
      Wilds := Copy(Wilds, 1, I - 1) + '*' + Copy(Wilds, I + 2, System.MaxInt);
  until I = 0;
  if Wilds = '*' then begin { for fast end, if Wilds only '*' }
    Result := True;
    Exit;
  end;
  MaxInputWord := Length(InputStr);
  MaxWilds := Length(Wilds);
  if (MaxWilds = 0) or (MaxInputWord = 0) then begin
    Result := False;
    Exit;
  end;
  CInputWord := 1;
  CWild := 1;
  Result := True;
  repeat
    if InputStr[CInputWord] = Wilds[CWild] then begin { equal letters }
      { goto next letter }
      Inc(CWild);
      Inc(CInputWord);
      Continue;
    end;
    if Wilds[CWild] = '?' then begin { equal to '?' }
      { goto next letter }
      Inc(CWild);
      Inc(CInputWord);
      Continue;
    end;
    if Wilds[CWild] = '*' then begin { handling of '*' }
      HelpWilds := Copy(Wilds, CWild + 1, MaxWilds);
      I := SearchNext(HelpWilds);
      LenHelpWilds := Length(HelpWilds);
      if I = 0 then begin
        { no '*' in the rest, compare the ends }
        if HelpWilds = '' then Exit; { '*' is the last letter }
        { check the rest for equal Length and no '?' }
        for I := 0 to LenHelpWilds - 1 do begin
          if (HelpWilds[LenHelpWilds - I] <> InputStr[MaxInputWord - I]) and
            (HelpWilds[LenHelpWilds - I]<> '?') then
          begin
            Result := False;
            Exit;
          end;
        end;
        Exit;
      end;
      { handle all to the next '*' }
      Inc(CWild, 1 + LenHelpWilds);
      I := FindPart(HelpWilds, Copy(InputStr, CInputWord, System.MaxInt));
      if I= 0 then begin
        Result := False;
        Exit;
      end;
      CInputWord := I + LenHelpWilds;
      Continue;
    end;
    Result := False;
    Exit;
  until (CInputWord > MaxInputWord) or (CWild > MaxWilds);
  { no completed evaluation }
  if CInputWord <= MaxInputWord then Result := False;
  if (CWild <= MaxWilds) and (Wilds[MaxWilds] <> '*') then Result := False;
end;

{$IFNDEF D4}
function FindCmdLineSwitch(const Switch: string; SwitchChars: TCharSet;
  IgnoreCase: Boolean): Boolean;
var
  I: Integer;
  S: string;
begin
  for I := 1 to ParamCount do begin
    S := ParamStr(I);
    if (SwitchChars = []) or ((S[1] in SwitchChars) and (Length(S) > 1)) then
    begin
      S := Copy(S, 2, System.MaxInt);
      if IgnoreCase then begin
        if (AnsiCompareText(S, Switch) = 0) then begin
          Result := True;
          Exit;
        end;
      end
      else begin
        if (AnsiCompareStr(S, Switch) = 0) then begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;
  Result := False;
end;
{$ENDIF}

function GetCmdLineArg(const Switch: string; SwitchChars: TCharSet): string;
var
  I: Integer;
  S: string;
begin
  I := 1;
  while I <= ParamCount do begin
    S := ParamStr(I);
    if (SwitchChars = []) or ((S[1] in SwitchChars) and (Length(S) > 1)) then
    begin
      if (AnsiCompareText(Copy(S, 2, System.MaxInt), Switch) = 0) then begin
        Inc(I);
        if I <= ParamCount then begin
          Result := ParamStr(I);
          Exit;
        end;
      end;
    end;
    Inc(I);
  end;
  Result := '';
end;

function GetParamStr(P: PChar; var Param: string): PChar;
var
  Len: Integer;
  Buffer: array[Byte] of Char;
begin
  while True do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do Inc(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  while P[0] > ' ' do
    if P[0] = '"' then
    begin
      Inc(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Buffer[Len] := P[0];
        Inc(Len);
        Inc(P);
      end;
      if P[0] <> #0 then Inc(P);
    end else
    begin
      Buffer[Len] := P[0];
      Inc(Len);
      Inc(P);
    end;
  SetString(Param, Buffer, Len);
  Result := P;
end;

function ParamCountFromCommandLine(CmdLine: PChar): Integer;
var
  S: string;
  P: PChar;
begin
  P := CmdLine;
  Result := 0;
  while True do
  begin
    P := GetParamStr(P, S);
    if S = '' then Break;
    Inc(Result);
  end;
end;

function ParamStrFromCommandLine(CmdLine: PChar; Index: Integer): string;
var
  P: PChar;
begin
  P := CmdLine;
  while True do
  begin
    P := GetParamStr(P, Result);
    if (Index = 0) or (Result = '') then Break;
    Dec(Index);
  end;
end;

procedure SplitCommandLine(const CmdLine: string; var ExeName, Params: string);
var
  Buffer: PChar;
  Cnt, I: Integer;
  S: string;
begin
  ExeName := '';
  Params := '';
  Buffer := StrAlloc(Length(CmdLine) + 1);
  StrPCopy(Buffer, CmdLine);
  try
    Cnt := ParamCountFromCommandLine(Buffer);
    if Cnt > 0 then begin
      ExeName := ParamStrFromCommandLine(Buffer, 0);
      for I := 1 to Cnt - 1 do begin
        S := ParamStrFromCommandLine(Buffer, I);
        if Pos(' ', S) > 0 then S := '"' + S + '"';
        Params := Params + S;
        if I < Cnt - 1 then Params := Params + ' ';
      end;
    end;
  finally
    StrDispose(Buffer);
  end;
end;

function FindSwitch(const Switch: string): Boolean;
begin
  Result := FindCmdLineSwitch(Switch, ['-', '/'], True);
end;

function LeftPart(const S: string; C: char): string;
begin
  Result:=Copy2Symb(S,C);
end;

function RightPart(const S: string; C: char): string;
var
  i: integer;
begin
  i:=Pos(C,S);
  if i > 0 then
    Result:=Copy(S,i+1,length(S)-i)
  else
    Result:='';
end;

function IniLeftPart(const S: string): string;
begin
  Result:=LeftPart(S,'=');
end;

function IniRightPart(const S: string): string;
begin
  Result:=RightPart(S,'=');
end;

function TextSizeDC(DC: HDC; const Text: string): TSize;
begin
  GetTextExtentPoint32(DC,PChar(Text),length(Text),Result);
end;

function TextSize(Wnd: HWnd; const Text: string): TSize;
var
  fnt,fnt_org: HFont;
  DC: HDC;
begin
  fnt:=SendMessage(Wnd,WM_GETFONT,0,0);
  DC:=GetDC(Wnd);
  try
    fnt_org:=SelectObject(DC,fnt);
    Result:=TextSizeDC(DC,Text);
    SelectObject(DC,fnt_org);
  finally
    ReleaseDC(Wnd,DC);
  end;
end;

function TextToLinesDC(DC: HDC; const Text: string; MaxLen: integer): string;
var
  i: integer;
  s,w,CurStr: string;
begin
  Result:=''; s:=''; CurStr:='';
  for i:=1 to WordCount(Text,[' ']) do begin
    w:=GetWord(i,Text,[' ']);
    s:=CurStr+iif(length(CurStr)>0,' ','')+w;
    if length(CurStr) > 0 then
      if TextSizeDC(DC,s).cx > MaxLen then begin
        if length(Result) > 0 then Result:=Result+#13#10;
        Result:=Result+CurStr;
        CurStr:=w;
        continue;
      end;
    CurStr:=s;
  end;
  if length(CurStr) > 0 then begin
    if length(Result) > 0 then Result:=Result+#13#10;
    Result:=Result+CurStr;
  end;
end;

function TextToLines(Wnd: HWnd; const Text: string; MaxLen: integer): string;
var
  fnt,fnt_org: HFont;
  DC: HDC;
begin
  fnt:=SendMessage(Wnd,WM_GETFONT,0,0);
  DC:=GetDC(Wnd);
  try
    fnt_org:=SelectObject(DC,fnt);
    Result:=TextToLinesDC(DC,Text,MaxLen);
    SelectObject(DC,fnt_org);
  finally
    ReleaseDC(Wnd,DC);
  end;
end;

function GetWordParam(N: Integer; const S: string; const WordDelims: TCharSet): string;
const
  QChar = '"';
var
  i,k: Integer;
  Len: Integer;
  q: boolean;
begin
  Len := 0;
  i:=1; k:=1; q:=false;
  while (i <= Length(S)) and (k < N) do begin
    if s[i] = QChar then q:=not(q);
    if not(q) and (S[i] in WordDelims) then inc(k);
    inc(i);
  end;
  q:=false;
  { find the end of the current word }
  while (I <= Length(S)) {and not(S[I] in WordDelims)} do begin
    if s[i] = QChar then q:=not(q);
    if not(q) and (S[i] in WordDelims) then break;
    { add the I'th character to result }
    Inc(Len);
    SetLength(Result, Len);
    Result[Len] := S[I];
    Inc(I);
  end;
  SetLength(Result, Len);
end;

function MinimizeTextDC(DC: HDC; const Text: string; MaxWidth: Integer): string;
var
  i: Integer;
begin
  Result:=Text;
  i:=1;
  while (i <= Length(Text)) and (TextSizeDC(DC,Result).cx > MaxWidth) do begin
    inc(i);
    Result:=Copy(Text,1,MaxInt([0,Length(Text)-i]))+'...';
  end;
end;

function MinimizeText(Wnd: HWnd; const Text: string; MaxWidth: Integer): string;
var
  DC: HDC;
  fnt,fnt_org: HFont;
begin
  fnt:=SendMessage(Wnd,WM_GETFONT,0,0);
  DC:=GetDC(Wnd);
  try
    fnt_org:=SelectObject(DC,fnt);
    Result:=MinimizeTextDC(DC,Text,MaxWidth);
    SelectObject(DC,fnt_org);
  finally
    ReleaseDC(Wnd,DC);
  end;
end;

end.
