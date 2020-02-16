{-------------------------------------------------------------------------------

  The contents of this file are subject to the Mozilla Public License
  Version 1.1 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
  License for the specific language governing rights and limitations
  under the License.

  The Original Code is DITypes.pas.

  The Initial Developer of the Original Code is Ralf Junker <delphi@zeitungsjunge.de>.

  All Rights Reserved.

-------------------------------------------------------------------------------}

unit DITypes;

{$I DI.inc}

interface

type
  {$IFDEF FLOAT_EXTENDED_PRECISION}

  Float = Extended; {$ENDIF}
  {$IFDEF FLOAT_DOUBLE_PRECISION}

  Float = Double; {$ENDIF}
  {$IFDEF FLOAT_SINGLE_PRECISION}

  Float = Single; {$ENDIF}

  PBase01 = ^TBase01;

  TBase01 = Byte;

  PBase02 = ^TBase02;

  TBase02 = Word;

  PBase04 = ^TBase04;

  TBase04 = Cardinal;

  PBase08 = ^TBase08;

  TBase08 = packed record
    One: TBase04;
    Two: TBase04;
  end;

  PBase12 = ^TBase12;

  TBase12 = packed record
    One: TBase04;
    Two: TBase04;
    Three: TBase04;
  end;

  PBase16 = ^TBase16;

  TBase16 = packed record
    One: TBase04;
    Two: TBase04;
    Three: TBase04;
    Four: TBase04;
  end;

  PPointer = ^Pointer;

  PPointer2 = ^TPointer2;
  TPointer2 = packed record
    Ptr: Pointer;
    Ptr2: Pointer;
  end;

  PPointer2Array = ^TPointer2Array;
  TPointer2Array = array[0..MaxInt div SizeOf(TPointer2) - 1] of TPointer2;

  PBoolean = ^Boolean;

  PByte = ^Byte;
  PDIByteArray = ^TDIByteArray;
  TDIByteArray = array[0..MaxInt div SizeOf(Byte) - 1] of Byte;

  PWord = ^Word;
  PWordArray = ^TWordArray;
  TWordArray = array[0..MaxInt div SizeOf(Word) - 1] of Word;

  PWordRec = ^TWordRec;
  TWordRec = packed record
    Lo, Hi: Byte;
  end;

  PInteger = ^Integer;
  PIntegerArray = ^TIntegerArray;
  TIntegerArray = array[0..MaxInt div SizeOf(Integer) - 1] of Integer;

  PIntegerBase01 = ^TIntegerBase01;
  TIntegerBase01 = packed record
    Number: Integer;
    Base01: TBase01;
  end;

  PIntegerBase04 = ^TIntegerBase04;
  TIntegerBase04 = packed record
    Number: Integer;
    Base04: TBase04;
  end;

  PIntegerPointer = ^TIntegerPointer;
  TIntegerPointer = packed record
    Number: Integer;
    Ptr: Pointer;
  end;

  PInteger2 = ^TInteger2;
  TInteger2 = packed record
    Number: Integer;
    Number2: Integer;
  end;

  PInteger2Base01 = ^TInteger2Base01;
  TInteger2Base01 = packed record
    Number: Integer;
    Number2: Integer;
    Base01: TBase01;
  end;

  PInteger3 = ^TInteger3;
  TInteger3 = packed record
    Number: Integer;
    Number2: Integer;
    Number3: Integer;
  end;

  PCardinal = ^Cardinal;
  PCardinalArray = ^TCardinalArray;
  TCardinalArray = array[0..MaxInt div SizeOf(Cardinal) - 1] of Cardinal;

  PCardinalRec = ^TCardinalRec;
  TCardinalRec = packed record
    Lo, Hi: Word;
  end;

  PCardinalBase01 = ^TCardinalBase01;
  TCardinalBase01 = packed record
    Number: Cardinal;
    Base01: TBase01;
  end;

  PCardinalBase04 = ^TCardinalBase04;
  TCardinalBase04 = packed record
    Number: Cardinal;
    Base04: TBase04;
  end;

  PCardinal2 = ^TCardinal2;
  TCardinal2 = packed record
    Number: Cardinal;
    Number2: Cardinal;
  end;

  PCardinal2Array = ^TCardinal2Array;
  TCardinal2Array = array[0..MaxInt div SizeOf(TCardinal2) - 1] of TCardinal2;

  PCardinal2Base01 = ^TCardinal2Base01;
  TCardinal2Base01 = packed record
    Number: Cardinal;
    Number2: Cardinal;
    Base01: TBase01;
  end;

  PCardinal2Base01Array = ^TCardinal2Base01Array;
  TCardinal2Base01Array = array[0..MaxInt div SizeOf(TCardinal2Base01) - 1] of TCardinal2Base01;

  PSingle = ^Single;

  PSingleArray = ^TSingleArray;

  TSingleArray = array[0..MaxInt div SizeOf(Single) - 1] of Single;

  PDouble = ^Double;

  PDoubleArray = ^TDoubleArray;

  TDoubleArray = array[0..MaxInt div SizeOf(Double) - 1] of Double;

  PObject = ^TObject;

  PObject2 = ^TObject2;

  TObject2 = packed record
    Obj: TObject;
    Obj2: TObject;
  end;

  PAnsiCharArray = ^TAnsiCharArray;

  TAnsiCharArray = array[0..MaxInt div SizeOf(AnsiChar) - 1] of AnsiChar;

  PAnsiStringArray = ^TAnsiStringArray;

  TAnsiStringArray = array[0..MaxInt div SizeOf(AnsiString) - 1] of AnsiString;

  PAnsiStringBase01 = ^TAnsiStringBase01;

  TAnsiStringBase01 = packed record
    Name: AnsiString;
    Data1: TBase01;
  end;

  PAnsiStringBase04 = ^TAnsiStringBase04;

  TAnsiStringBase04 = packed record
    Name: AnsiString;
    Data1: TBase04;
  end;

  PAnsiStringBase08 = ^TAnsiStringBase08;

  TAnsiStringBase08 = packed record
    Name: AnsiString;
    Data1: TBase04;
    Data2: TBase04;
  end;

  PAnsiStringInteger = ^TAnsiStringInteger;

  TAnsiStringInteger = packed record
    Name: AnsiString;
    Number: Integer;
  end;

  PAnsiStringIntegerBase01 = ^TAnsiStringIntegerBase01;

  TAnsiStringIntegerBase01 = packed record
    Name: AnsiString;
    Number: Integer;
    Base01: TBase01;
  end;

  PAnsiStringInteger2 = ^TAnsiStringInteger2;

  TAnsiStringInteger2 = packed record
    Name: AnsiString;
    Number: Integer;
    Number2: Integer;
  end;

  PAnsiStringInteger2Base01 = ^TAnsiStringInteger2Base01;

  TAnsiStringInteger2Base01 = packed record
    Name: AnsiString;
    Number: Integer;
    Number2: Integer;
    Base01: TBase01;
  end;

  PAnsiStringCardinal = ^TAnsiStringCardinal;

  TAnsiStringCardinal = packed record
    Name: AnsiString;
    Number: Cardinal;
  end;

  PAnsiStringCardinalBase01 = ^TAnsiStringCardinalBase01;

  TAnsiStringCardinalBase01 = packed record
    Name: AnsiString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PAnsiStringCardinal2 = ^TAnsiStringCardinal2;

  TAnsiStringCardinal2 = packed record
    Name: AnsiString;
    Number: Cardinal;
    Number2: Cardinal;
  end;

  PAnsiStringObject = ^TAnsiStringObject;

  TAnsiStringObject = packed record
    Name: AnsiString;
    Obj: TObject;
  end;

  PAnsiStringPointer = ^TAnsiStringPointer;

  TAnsiStringPointer = packed record
    Name: AnsiString;
    Ptr: Pointer;
  end;

  PAnsiString2 = ^TAnsiString2;

  TAnsiString2 = packed record
    Name: AnsiString;
    Value: AnsiString;
  end;

  PAnsiString2Base01 = ^TAnsiString2Base01;

  TAnsiString2Base01 = packed record
    Name: AnsiString;
    Value: AnsiString;
    Base01: TBase01;
  end;

  PAnsiString2Base04 = ^TAnsiString2Base04;

  TAnsiString2Base04 = packed record
    Name: AnsiString;
    Value: AnsiString;
    Base04: TBase04;
  end;

  PAnsiString2Cardinal = ^TAnsiString2Cardinal;

  TAnsiString2Cardinal = packed record
    Name: AnsiString;
    Value: AnsiString;
    Number: Cardinal;
  end;

  PAnsiString2CardinalBase01 = ^TAnsiString2CardinalBase01;

  TAnsiString2CardinalBase01 = packed record
    Name: AnsiString;
    Value: AnsiString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PWideStringArray = ^TWideStringArray;

  TWideStringArray = array[0..MaxInt div SizeOf(WideString) - 1] of WideString;

  PWideStringBase01 = ^TWideStringBase01;

  TWideStringBase01 = packed record
    Name: WideString;
    Base01: TBase01;
  end;

  PWideStringBase04 = ^TWideStringBase04;

  TWideStringBase04 = packed record
    Name: WideString;
    Base04: TBase04;
  end;

  PWideStringInteger = ^TWideStringInteger;

  TWideStringInteger = packed record
    Name: WideString;
    Number: Integer;
  end;

  PWideStringIntegerBase01 = ^TWideStringIntegerBase01;

  TWideStringIntegerBase01 = packed record
    Name: WideString;
    Number: Integer;
    Base01: TBase01;
  end;

  PWideStringCardinal = ^TWideStringCardinal;

  TWideStringCardinal = packed record
    Name: WideString;
    Number: Cardinal;
  end;

  PWideStringCardinalBase01 = ^TWideStringCardinalBase01;

  TWideStringCardinalBase01 = packed record
    Name: WideString;
    Number: Cardinal;
    Base01: TBase01;
  end;

  PWideStringObject = ^TWideStringObject;

  TWideStringObject = packed record
    Name: WideString;
    Obj: TObject;
  end;

  PWideString2 = ^TWideString2;

  TWideString2 = packed record
    Name: WideString;
    Value: WideString;
  end;

  PWideString2Base01 = ^TWideString2Base01;

  TWideString2Base01 = packed record
    Name: WideString;
    Value: WideString;
    Base01: TBase01;
  end;

  PWideString2Base04 = ^TWideString2Base04;

  TWideString2Base04 = packed record
    Name: WideString;
    Value: WideString;
    Base04: TBase04;
  end;

  PWideString2Cardinal = ^TWideString2Cardinal;

  TWideString2Cardinal = packed record
    Name: WideString;
    Value: WideString;
    Number: Cardinal;
  end;

  PWideString2CardinalBase01 = ^TWideString2CardinalBase01;

  TWideString2CardinalBase01 = packed record
    Name: WideString;
    Value: WideString;
    Number: Cardinal;
    Base01: TBase01;
  end;

implementation

end.

