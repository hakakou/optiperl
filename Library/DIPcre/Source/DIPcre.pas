{-------------------------------------------------------------------------------
 
 Copyright (c) 1999-2003 The Delphi Inspiration - Ralf Junker
 Internet: http://www.zeitungsjunge.de/delphi/
 E-Mail:   delphi@zeitungsjunge.de

-------------------------------------------------------------------------------}

unit DIPcre;

{$I DI.inc}

interface

uses
  {$IFNDEF DI_No_Pcre_Component}
  Classes,
  {$ENDIF}
  {$IFNDEF DI_No_Pcre_Range_Checking}
  SysUtils,
  {$ENDIF}
  DIPcreApi,
  DIUtils;

type

  TDIPcreCallOutEvent = procedure(const pcre_callout_block: PPcre_Callout_Block; var Result: Integer) of object;

  TDIPcreOption = (

    poAutoStudy,

    poCaptureSubstrings,

    poUserLocale);

  TDIPcreOptions = set of TDIPcreOption;

const

  DEFAULT_OPTIONS = [poAutoStudy, poCaptureSubstrings];

  DEFAULT_COMPILE_OPTION_BITS = PCRE_CASELESS or PCRE_DOTALL;

  DEFAULT_MATCH_OPTION_BITS = 0;

type

  PDIPcreVector = ^TDIPcreVector;

  TDIPcreVector = packed record
    FirstCharPos: Integer;
    AfterLastCharPos: Integer;
  end;

  TDIPcreVectorArray = array[0..MaxInt div SizeOf(TDIPcreVector) - 1] of TDIPcreVector;

  PDIPcreVectorArray = ^TDIPcreVectorArray;

  TDIPcreCompileOption = (

    coAnchored,

    coCaseless,

    coDollarEndOnly,

    coDotAll,

    coExtended,

    coExtra,

    coMultiline,

    coUnGreedy,

    coUtf8,

    coNoAutoCapture,

    coNoUtf8Check);

  TDIPcreCompileOptions = set of TDIPcreCompileOption;

  TDIPcreMatchOption = (

    moAnchored,

    moNotBol,

    moNotEol,

    moNotEmpty,

    moNoUtf8Check);

  TDIPcreMatchOptions = set of TDIPcreMatchOption;

  TDICustomPcre = class{$IFNDEF DI_No_Pcre_Component}(TComponent){$ENDIF}
  private

    FCode: PRealPcre;

    FExtra: PPcre_Extra;

    FVector: PDIPcreVectorArray;

    FVectorSize: Cardinal;

    FTables: Pointer;

    FMatchPattern: AnsiString;

    FSubjectPointer: PAnsiChar;
    FSubjectLength: Cardinal;

    FSubStrCount: Integer;

    FErrorMessage: PAnsiChar;
    FErrorOffset: Integer;

    FOptions: TDIPcreOptions;
    FCompileOptionBits: Cardinal;
    FMatchOptionBits: Cardinal;

    FFormatPattern: AnsiString;
    FReplacementCode: Pointer;
    FMatchLimit: Cardinal;

    FOnCallOut: TDIPcreCallOutEvent;

    function CompileOptionsBitsToSet(const ACompileBits: Cardinal): TDIPcreCompileOptions;
    function CompileOptionsSetToBits(const ACompileOptions: TDIPcreCompileOptions): Cardinal;

    procedure SetOptions(const NewOptions: TDIPcreOptions);

    function GetCompileOptions: TDIPcreCompileOptions;
    procedure SetCompileOptions(const AValue: TDIPcreCompileOptions);

    function GetMatchOptions: TDIPcreMatchOptions;
    procedure SetMatchOptions(const AValue: TDIPcreMatchOptions);

    procedure InternalFormat(var s: AnsiString; var InUse: Cardinal; const AVector: PDIPcreVectorArray);

    procedure SetCaptureSubStrings(const AValue: Boolean);
    procedure SetFormatPattern(const NewFormatPattern: AnsiString);
    procedure SetMatchPattern(const NewMatchPattern: AnsiString);
  protected

    procedure CompileFormatPattern;

    property CompileOptionBits: Cardinal read FCompileOptionBits write FCompileOptionBits default DEFAULT_COMPILE_OPTION_BITS;

    property CompileOptions: TDIPcreCompileOptions read GetCompileOptions write SetCompileOptions stored False;

    property ErrorMessage: PAnsiChar read FErrorMessage;

    property ErrorOffset: Integer read FErrorOffset;

    property FormatPattern: AnsiString read FFormatPattern write SetFormatPattern;

    property MatchLimit: Cardinal read FMatchLimit write FMatchLimit default MATCH_LIMIT;

    property MatchOptionBits: Cardinal read FMatchOptionBits write FMatchOptionBits default DEFAULT_MATCH_OPTION_BITS;

    property MatchOptions: TDIPcreMatchOptions read GetMatchOptions write SetMatchOptions stored False;

    property MatchPattern: AnsiString read FMatchPattern write SetMatchPattern;
    property OnCallOut: TDIPcreCallOutEvent read FOnCallOut write FOnCallOut;

    property Options: TDIPcreOptions read FOptions write SetOptions default DEFAULT_OPTIONS;

    procedure SetVersion(const AValue: AnsiString);
  public

    constructor Create{$IFNDEF DI_No_Pcre_Component}(AOwner: TComponent); override{$ENDIF};

    destructor Destroy; override;

    procedure Clear;
    {$IFNDEF DI_No_Pcre_Range_Checking}

    class procedure Error(const ResStringRec: PResStringRec; const Args: array of const);
    {$ENDIF}

    function CompileMatchPattern: Boolean; overload;

    function CompileMatchPattern(const AMatchPattern: AnsiString): Boolean; overload;

    function CompileMatchPattern(const AMatchPattern: AnsiString; const ACompileOptionBits: Cardinal): Boolean; overload;

    class function GetVersion: AnsiString;

    function InfoBackRefMax(out ABackRefMax: Integer): Integer;

    function InfoCaptureCount(out ACaptureCount: Integer): Integer;

    function InfoFirstByte(out AFirstByte: Integer): Integer;

    function InfoNameTable(out ANameTable: PAnsiChar): Integer;

    function InfoOptionBits(out ACompileOptionBits: Cardinal): Integer;

    function InfoOptions(out ACompileOptions: TDIPcreCompileOptions): Integer;

    function InfoSize(out ASize: Cardinal): Integer;

    function InfoStudySize(out AStudySize: Cardinal): Integer;

    function List(StartOffSet: Cardinal = 0; Limit: Integer = -1): AnsiString;

    function Match(const AStartOffSet: Cardinal = 0): Integer;

    function MatchBuf(const ASubjectBuffer; const ASubjectBufferSize: Cardinal; const AStartOffSet: Cardinal = 0): Integer;

    function MatchedStr: AnsiString;

    function MatchedStrLength: Integer;

    function MatchedStrFirstCharPos: Integer;

    function MatchedStrAfterLastCharPos: Integer;

    function MatchNext: Integer;

    function MatchStr(const ASubjectString: AnsiString; const AStartOffSet: Cardinal = 1): Integer;

    function NamedSubStrByIdx(const AIndex: Integer): AnsiString;

    function NamedSubStrByName(const SubStringName: AnsiString): AnsiString;

    function NamedSubStrCount: Integer;

    function NamedSubStrNameByIdx(const AIndex: Integer): AnsiString;

    function NamedSubStrNumByIdx(const AIndex: Integer): Integer;

    function NamedSubStrNumByName(const SubStrName: AnsiString): Integer;

    function Study: Boolean;

    function SubStr(const AIndex: Integer): AnsiString;

    property SubStrCount: Integer read FSubStrCount;

    function SubStrLength(const AIndex: Integer): Integer;

    function SubStrFirstCharPos(const AIndex: Integer): Integer;

    function SubStrAfterLastCharPos(const AIndex: Integer): Integer;

    procedure SetSubjectStr(const ASubjectString: AnsiString);

    procedure SetSubjectBuf(const ASubjectBuffer; const ASubjectBufferSize: Cardinal);

    function Replace(StartOffSet: Cardinal = 0; Limit: Integer = -1): AnsiString;

    function Format: AnsiString;
  end;

  TDIPcre = class(TDICustomPcre)
  public

    property ErrorMessage;

    property ErrorOffset;

    property FormatPattern;
  published

    property CompileOptions;

    property CompileOptionBits;

    property MatchLimit;

    property MatchOptionBits;

    property MatchOptions;

    property Options;

    property OnCallOut;

    property MatchPattern;

    property Version: AnsiString read GetVersion write SetVersion stored False;
  end;

  {$IFNDEF DI_No_Pcre_Range_Checking}

  EDIPcreError = Exception;
  {$ENDIF}

implementation

uses

  {$IFDEF DI_No_Pcre_Range_Checking}
  SysUtils,
  {$ENDIF}
  {$IFDEF DI_Check_Free}
  DICheckFree,
  {$ENDIF DI_Check_Free}
  {$IFNDEF DI_No_Pcre_Range_Checking}
  DIConsts,
  {$ENDIF}
  DITypes;

constructor TDICustomPcre.Create{$IFNDEF DI_No_Pcre_Component}(AOwner: TComponent){$ENDIF};
begin
  {$IFDEF DI_Check_Free}RegisterObjectCreate(Self); {$ENDIF}
  inherited Create{$IFNDEF DI_No_Pcre_Component}(AOwner){$ENDIF};
  FMatchLimit := MATCH_LIMIT;
  FOptions := DEFAULT_OPTIONS;

  FCompileOptionBits := DEFAULT_COMPILE_OPTION_BITS;
  FMatchOptionBits := DEFAULT_MATCH_OPTION_BITS;
  FSubStrCount := PCRE_ERROR_NOMATCH;
end;

destructor TDICustomPcre.Destroy;
begin
  FreeMem(FReplacementCode);

  FreeMem(FCode);
  FreeMem(FExtra);
  FreeMem(FVector);
  FreeMem(FTables);
  inherited Destroy;
  {$IFDEF DI_Check_Free}RegisterObjectFree(Self); {$ENDIF}
end;

procedure TDICustomPcre.Clear;
var
  n: Pointer;
begin
  n := nil;

  FreeMem(FCode);
  FCode := n;

  FreeMem(FExtra);
  FExtra := n;

  FreeMem(FVector);
  FVector := n;
  FVectorSize := 0;

  FreeMem(FTables);
  FTables := n;

  FMatchPattern := '';
  FSubStrCount := PCRE_ERROR_NOMATCH;

  FreeMem(FReplacementCode);
  FReplacementCode := n;

  FFormatPattern := '';
end;

function TDICustomPcre.CompileMatchPattern: Boolean;
label
  Fail;
begin
  FSubStrCount := PCRE_ERROR_NOMATCH;

  FreeMem(FExtra);
  FExtra := nil;

  FreeMem(FReplacementCode);
  FReplacementCode := nil;

  FreeMem(FCode);
  FCode := pcre_compile(PAnsiChar(FMatchPattern), FCompileOptionBits, @FErrorMessage, @FErrorOffset, FTables);

  if FCode = nil then goto Fail;

  if poAutoStudy in FOptions then
    begin
      FExtra := Pcre_Study(FCode, 0, @FErrorMessage);
      if FErrorMessage <> nil then goto Fail;
    end;

  if (FMatchLimit <> MATCH_LIMIT) or Assigned(FOnCallOut) then
    begin
      if FExtra = nil then
        begin

          GetMem(FExtra, SizeOf(FExtra^));
          with FExtra^ do
            begin
              Flags := 0;
              Study_Data := nil;
              MATCH_LIMIT := 0;
              Callout_Data := nil;
            end;
        end;

      if FMatchLimit <> MATCH_LIMIT then
        begin
          FExtra^.MATCH_LIMIT := FMatchLimit;
          FExtra^.Flags := FExtra^.Flags or PCRE_EXTRA_MATCH_LIMIT;
        end;

      if Assigned(FOnCallOut) then
        begin
          FExtra^.Callout_Data := Self;
          FExtra^.Flags := FExtra^.Flags or PCRE_EXTRA_CALLOUT_DATA;
        end;

    end;

  SetCaptureSubStrings(poCaptureSubstrings in FOptions);

  Result := True;
  Exit;

  Fail:
  Result := False;
end;

function TDICustomPcre.CompileMatchPattern(const AMatchPattern: AnsiString): Boolean;
begin
  FMatchPattern := AMatchPattern;
  Result := CompileMatchPattern;
end;

function TDICustomPcre.CompileMatchPattern(const AMatchPattern: AnsiString; const ACompileOptionBits: Cardinal): Boolean;
begin
  FMatchPattern := AMatchPattern;
  FCompileOptionBits := ACompileOptionBits;
  Result := CompileMatchPattern;
end;

function TDICustomPcre.CompileOptionsBitsToSet(const ACompileBits: Cardinal): TDIPcreCompileOptions;
begin
  Result := [];
  if ACompileBits and PCRE_CASELESS <> 0 then Include(Result, coCaseless);
  if ACompileBits and PCRE_MULTILINE <> 0 then Include(Result, coMultiline);
  if ACompileBits and PCRE_DOTALL <> 0 then Include(Result, coDotAll);
  if ACompileBits and PCRE_EXTENDED <> 0 then Include(Result, coExtended);
  if ACompileBits and PCRE_ANCHORED <> 0 then Include(Result, coAnchored);
  if ACompileBits and PCRE_DOLLAR_ENDONLY <> 0 then Include(Result, coDollarEndOnly);
  if ACompileBits and PCRE_EXTRA <> 0 then Include(Result, coExtra);
  if ACompileBits and PCRE_UNGREEDY <> 0 then Include(Result, coUnGreedy);
  if ACompileBits and PCRE_UTF8 <> 0 then Include(Result, coUtf8);
  if ACompileBits and PCRE_NO_AUTO_CAPTURE <> 0 then Include(Result, coNoAutoCapture);
  if ACompileBits and PCRE_NO_UTF8_CHECK <> 0 then Include(Result, coNoUtf8Check);
end;

function TDICustomPcre.CompileOptionsSetToBits(const ACompileOptions: TDIPcreCompileOptions): Cardinal;
begin
  Result := 0;
  if coCaseless in ACompileOptions then Result := Result or PCRE_CASELESS;
  if coMultiline in ACompileOptions then Result := Result or PCRE_MULTILINE;
  if coDotAll in ACompileOptions then Result := Result or PCRE_DOTALL;
  if coExtended in ACompileOptions then Result := Result or PCRE_EXTENDED;
  if coAnchored in ACompileOptions then Result := Result or PCRE_ANCHORED;
  if coDollarEndOnly in ACompileOptions then Result := Result or PCRE_DOLLAR_ENDONLY;
  if coExtra in ACompileOptions then Result := Result or PCRE_EXTRA;
  if coUnGreedy in ACompileOptions then Result := Result or PCRE_UNGREEDY;
  if coUtf8 in ACompileOptions then Result := Result or PCRE_UTF8;
  if coNoAutoCapture in ACompileOptions then Result := Result or PCRE_NO_AUTO_CAPTURE;
  if coNoUtf8Check in ACompileOptions then Result := Result or PCRE_NO_UTF8_CHECK;
end;

{$IFNDEF DI_No_Pcre_Range_Checking}
class procedure TDICustomPcre.Error(const ResStringRec: PResStringRec; const Args: array of const);
  function ReturnAddr: Pointer;
  asm
    mov eax, [ebp + 4]
  end;
begin
  raise EDIPcreError.CreateFmt(LoadResString(ResStringRec), Args)At ReturnAddr;
end;
{$ENDIF}

function TDICustomPcre.Match(const AStartOffSet: Cardinal = 0): Integer;
begin
  Result := pcre_exec(FCode, FExtra, FSubjectPointer, FSubjectLength, AStartOffSet, FMatchOptionBits, Pointer(FVector), FVectorSize);
  FSubStrCount := Result;

end;

function TDICustomPcre.MatchStr(const ASubjectString: AnsiString; const AStartOffSet: Cardinal = 1): Integer;
begin

  FSubjectPointer := PAnsiChar(ASubjectString);

  FSubjectLength := Cardinal(ASubjectString);
  if FSubjectLength <> 0 then FSubjectLength := PCardinal(FSubjectLength - 4)^;

  Result := pcre_exec(FCode, FExtra, FSubjectPointer, FSubjectLength, AStartOffSet - 1, FMatchOptionBits, Pointer(FVector), FVectorSize);
  FSubStrCount := Result;
end;

function TDICustomPcre.MatchBuf(const ASubjectBuffer; const ASubjectBufferSize: Cardinal; const AStartOffSet: Cardinal = 0): Integer;
begin

  FSubjectPointer := @ASubjectBuffer;
  FSubjectLength := ASubjectBufferSize;

  Result := pcre_exec(FCode, FExtra, FSubjectPointer, FSubjectLength, AStartOffSet, FMatchOptionBits, Pointer(FVector), FVectorSize);

  FSubStrCount := Result;
end;

function TDICustomPcre.MatchNext: Integer;
begin
  if FSubStrCount > 0 then
    begin

      Result := pcre_exec(FCode, FExtra, FSubjectPointer, FSubjectLength, FVector^[0].AfterLastCharPos, FMatchOptionBits, Pointer(FVector), FVectorSize);
    end
  else
    Result := PCRE_ERROR_NOSUBSTRING;
  FSubStrCount := Result;
end;

procedure TDICustomPcre.SetSubjectBuf(const ASubjectBuffer; const ASubjectBufferSize: Cardinal);
begin
  FSubjectPointer := @ASubjectBuffer;

  FSubjectLength := ASubjectBufferSize;
  FSubStrCount := PCRE_ERROR_NOMATCH;
end;

procedure TDICustomPcre.SetSubjectStr(const ASubjectString: AnsiString);
begin
  FSubjectPointer := PAnsiChar(ASubjectString);
  FSubjectLength := Cardinal(ASubjectString);

  if FSubjectLength <> 0 then
    FSubjectLength := PCardinal(FSubjectLength - 4)^;
  FSubStrCount := PCRE_ERROR_NOMATCH;
end;

function TDICustomPcre.Study: Boolean;
begin
  if FCode = nil then
    Result := False
  else
    begin
      FreeMem(FExtra);
      FExtra := Pcre_Study(FCode, 0, @FErrorMessage);
      Result := FErrorMessage = nil;
    end;
end;

procedure TDICustomPcre.SetCaptureSubStrings(const AValue: Boolean);
var
  NewVectorSize: Cardinal;
begin
  if AValue then
    begin

      NewVectorSize := FCode^.top_bracket;

      NewVectorSize := (NewVectorSize + 1) * 3 * 2;
      if NewVectorSize <> FVectorSize then
        begin
          FreeMem(FVector);
          GetMem(FVector, NewVectorSize * SizeOf(Cardinal));
          FVectorSize := NewVectorSize;
        end;
    end
  else
    begin
      FreeMem(FVector);
      FVector := nil;
      FVectorSize := 0;
    end;
end;

procedure TDICustomPcre.SetMatchPattern(const NewMatchPattern: AnsiString);
begin
  FMatchPattern := NewMatchPattern;

  CompileMatchPattern
end;

class function TDICustomPcre.GetVersion: AnsiString;
begin
  Result := Pcre_Version;
end;

procedure TDICustomPcre.SetVersion(const AValue: AnsiString);
begin

end;

procedure TDICustomPcre.SetOptions(const NewOptions: TDIPcreOptions);
var
  ToBeSet, ToBeCleared: TDIPcreOptions;
begin
  if FOptions = NewOptions then Exit;
  ToBeSet := NewOptions - FOptions;
  ToBeCleared := FOptions - NewOptions;
  FOptions := NewOptions;

  if FCode <> nil then
    if poAutoStudy in ToBeSet then
      Study
    else
      if poCaptureSubstrings in (ToBeSet + ToBeCleared) then
        SetCaptureSubStrings(poCaptureSubstrings in NewOptions);

  if poUserLocale in (ToBeSet + ToBeCleared) then
    if poUserLocale in NewOptions then
      FTables := pcre_maketables
    else
      begin
        FreeMem(FTables);
        FTables := nil;
      end;
end;

function TDICustomPcre.GetCompileOptions: TDIPcreCompileOptions;
begin
  Result := CompileOptionsBitsToSet(FCompileOptionBits);
end;

procedure TDICustomPcre.SetCompileOptions(const AValue: TDIPcreCompileOptions);
begin
  FCompileOptionBits := CompileOptionsSetToBits(AValue);
end;

function TDICustomPcre.GetMatchOptions: TDIPcreMatchOptions;
var
  LocalMatchOptionBits: Cardinal;
begin
  Result := [];
  LocalMatchOptionBits := FMatchOptionBits;
  if LocalMatchOptionBits and PCRE_ANCHORED <> 0 then Include(Result, moAnchored);
  if LocalMatchOptionBits and PCRE_NOTBOL <> 0 then Include(Result, moNotBol);
  if LocalMatchOptionBits and PCRE_NOTEOL <> 0 then Include(Result, moNotEol);
  if LocalMatchOptionBits and PCRE_NOTEMPTY <> 0 then Include(Result, moNotEmpty);
  if LocalMatchOptionBits and PCRE_NO_UTF8_CHECK <> 0 then Include(Result, moNoUtf8Check);
end;

procedure TDICustomPcre.SetMatchOptions(const AValue: TDIPcreMatchOptions);
var
  LocalMatchOptionBits: Cardinal;
begin
  LocalMatchOptionBits := 0;
  if moAnchored in AValue then LocalMatchOptionBits := LocalMatchOptionBits or PCRE_ANCHORED;
  if moNotBol in AValue then LocalMatchOptionBits := LocalMatchOptionBits or PCRE_NOTBOL;
  if moNotEol in AValue then LocalMatchOptionBits := LocalMatchOptionBits or PCRE_NOTEOL;
  if moNotEmpty in AValue then LocalMatchOptionBits := LocalMatchOptionBits or PCRE_NOTEMPTY;
  if moNoUtf8Check in AValue then LocalMatchOptionBits := LocalMatchOptionBits or PCRE_NO_UTF8_CHECK;
  FMatchOptionBits := LocalMatchOptionBits;
end;

function TDICustomPcre.MatchedStr: AnsiString;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if FSubStrCount <= 0 then Error(PResStringRec(@SDIPcreSubStringIndexError), [FSubStrCount]);
  {$ENDIF}
  with FVector^[0] do
    SetString(Result, FSubjectPointer + FirstCharPos, AfterLastCharPos - FirstCharPos);

end;

function TDICustomPcre.MatchedStrLength: Integer;
begin

  {$IFNDEF DI_No_Pcre_Range_Checking}
  if FSubStrCount <= 0 then Error(PResStringRec(@SDIPcreSubStringIndexError), [FSubStrCount]);
  {$ENDIF}
  with FVector^[0] do
    Result := AfterLastCharPos - FirstCharPos;
end;

function TDICustomPcre.MatchedStrFirstCharPos: Integer;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if FSubStrCount <= 0 then Error(PResStringRec(@SDIPcreSubStringIndexError), [FSubStrCount]);
  {$ENDIF}
  Result := FVector^[0].FirstCharPos;

end;

function TDICustomPcre.MatchedStrAfterLastCharPos: Integer;
begin

  {$IFNDEF DI_No_Pcre_Range_Checking}
  if FSubStrCount <= 0 then Error(PResStringRec(@SDIPcreSubStringIndexError), [FSubStrCount]);
  {$ENDIF}
  Result := FVector^[0].AfterLastCharPos;
end;

function TDICustomPcre.NamedSubStrByName(const SubStringName: AnsiString): AnsiString;
var
  i: Integer;
begin
  i := NamedSubStrNumByName(SubStringName);
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if i <= 0 then Error(PResStringRec(@SDIPcreUnknownSubStringName), [SubStringName]);
  {$ENDIF}
  Result := SubStr(i);
end;

function TDICustomPcre.NamedSubStrByIdx(const AIndex: Integer): AnsiString;
begin
  Result := SubStr(NamedSubStrNumByIdx(AIndex));
end;

function TDICustomPcre.NamedSubStrCount: Integer;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if FCode = nil then Error(PResStringRec(@SDIPcreCodeNilError), []);
  if FCode^.MAGIC_NUMBER <> MAGIC_NUMBER then Error(PResStringRec(@SDIPcreBadMagicError), []);
  {$ENDIF}
  Result := FCode^.Name_Count;
end;

function TDICustomPcre.NamedSubStrNameByIdx(const AIndex: Integer): AnsiString;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if (AIndex < 0) or (AIndex >= NamedSubStrCount) then Error(PResStringRec(@SDIPcreNamedSubStringIndexError), [AIndex]);
  {$ENDIF}
  with FCode^ do
    Result := PAnsiChar(@Name_Table_1st_Name) + Name_Entry_Size * AIndex;
end;

function TDICustomPcre.NamedSubStrNumByIdx(const AIndex: Integer): Integer;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if (AIndex < 0) or (AIndex >= NamedSubStrCount) then Error(PResStringRec(@SDIPcreNamedSubStringIndexError), [AIndex]);
  {$ENDIF}
  with FCode^,
    PWordRec(Cardinal(@Name_Table_1st_Number) + Name_Entry_Size * Cardinal(AIndex))^ do
    Result := Lo shl 8 + Hi;
end;

function TDICustomPcre.NamedSubStrNumByName(const SubStrName: AnsiString): Integer;
var
  Bot, Mid, Top: Integer;
  entrysize: Integer;
  PSubStrName, nametable, Entry: PAnsiChar;
  c: Integer;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if FCode = nil then Error(PResStringRec(@SDIPcreCodeNilError), []);
  if FCode^.MAGIC_NUMBER <> DIPcreApi.MAGIC_NUMBER then Error(PResStringRec(@SDIPcreBadMagicError), []);
  {$ENDIF}

  nametable := Pointer(@FCode^.Name_Table_1st_Name);
  entrysize := FCode^.Name_Entry_Size;
  PSubStrName := PAnsiChar(SubStrName);

  Top := FCode^.Name_Count;
  Bot := 0;

  while Top > Bot do
    begin
      Mid := (Top + Bot) shr 1;
      Entry := nametable + entrysize * Mid;
      c := StrComp(PSubStrName, Entry);
      if c > 0 then
        Bot := Mid + 1
      else
        if c < 0 then
          Top := Mid
        else
          with PWordRec(Entry - 2)^ do
            begin
              Result := Lo shl 8 + Hi;
              Exit;
            end
    end;
  Result := PCRE_ERROR_NOSUBSTRING;
end;

function TDICustomPcre.SubStr(const AIndex: Integer): AnsiString;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if (AIndex < 0) or (AIndex >= FSubStrCount) then Error(PResStringRec(@SDIPcreSubStringIndexError), [AIndex]);
  {$ENDIF}

  with FVector^[AIndex] do
    SetString(Result, FSubjectPointer + FirstCharPos, AfterLastCharPos - FirstCharPos);
end;

function TDICustomPcre.SubStrAfterLastCharPos(const AIndex: Integer): Integer;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if (AIndex < 0) or (AIndex >= FSubStrCount) then Error(PResStringRec(@SDIPcreSubStringIndexError), [AIndex]);
  {$ENDIF}
  Result := FVector^[AIndex].AfterLastCharPos;

end;

function TDICustomPcre.SubStrFirstCharPos(const AIndex: Integer): Integer;
begin

  {$IFNDEF DI_No_Pcre_Range_Checking}
  if (AIndex < 0) or (AIndex >= FSubStrCount) then Error(PResStringRec(@SDIPcreSubStringIndexError), [AIndex]);
  {$ENDIF}
  Result := FVector^[AIndex].FirstCharPos;
end;

function TDICustomPcre.SubStrLength(const AIndex: Integer): Integer;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if (AIndex < 0) or (AIndex >= FSubStrCount) then Error(PResStringRec(@SDIPcreSubStringIndexError), [AIndex]);
  {$ENDIF}
  with FVector^[AIndex] do
    Result := AfterLastCharPos - FirstCharPos;

end;

function TDICustomPcre.InfoNameTable(out ANameTable: PAnsiChar): Integer;
begin
  Result := pcre_fullinfo(FCode, FExtra, PCRE_INFO_NAMETABLE, @ANameTable);
end;

function TDICustomPcre.InfoSize(out ASize: Cardinal): Integer;
begin
  Result := pcre_fullinfo(FCode, FExtra, PCRE_INFO_SIZE, @ASize);
end;

function TDICustomPcre.InfoOptions(out ACompileOptions: TDIPcreCompileOptions): Integer;
var
  OptionBits: Cardinal;
begin
  Result := pcre_fullinfo(FCode, FExtra, PCRE_INFO_OPTIONS, @OptionBits);
  if Result = 0 then ACompileOptions := CompileOptionsBitsToSet(OptionBits)
end;

function TDICustomPcre.InfoOptionBits(out ACompileOptionBits: Cardinal): Integer;
begin
  Result := pcre_fullinfo(FCode, FExtra, PCRE_INFO_OPTIONS, @ACompileOptionBits);
end;

function TDICustomPcre.InfoCaptureCount(out ACaptureCount: Integer): Integer;
begin
  Result := pcre_fullinfo(FCode, FExtra, PCRE_INFO_CAPTURECOUNT, @ACaptureCount);
end;

function TDICustomPcre.InfoBackRefMax(out ABackRefMax: Integer): Integer;
begin
  Result := pcre_fullinfo(FCode, FExtra, PCRE_INFO_BACKREFMAX, @ABackRefMax);
end;

function TDICustomPcre.InfoFirstByte(out AFirstByte: Integer): Integer;
begin
  Result := pcre_fullinfo(FCode, FExtra, PCRE_INFO_FIRSTBYTE, @AFirstByte);
end;

function TDICustomPcre.InfoStudySize(out AStudySize: Cardinal): Integer;
begin
  Result := pcre_fullinfo(FCode, FExtra, PCRE_INFO_STUDYSIZE, @AStudySize);
end;

type
  TReplacementToken = (rtLiteralString, rtSubString, rtEOf);
  PReplacementToken = ^TReplacementToken;

procedure TDICustomPcre.CompileFormatPattern;
var
  l: Cardinal;
  p: PAnsiChar;
  n: Integer;

  CodePtr: Pointer;
  CodeLength: Cardinal;

  LiteralStringLengthPtr: PCardinal;

  procedure BeginLiteralString;
  begin
    if LiteralStringLengthPtr = nil then
      begin
        PReplacementToken(CodePtr)^ := rtLiteralString;
        Inc(Cardinal(CodePtr), SizeOf(TReplacementToken));
        LiteralStringLengthPtr := CodePtr;
        Inc(Cardinal(CodePtr), SizeOf(Cardinal));
      end;
  end;

  procedure EndLiteralString;
  begin
    if LiteralStringLengthPtr <> nil then
      begin
        LiteralStringLengthPtr^ := Cardinal(CodePtr) - Cardinal(LiteralStringLengthPtr) - SizeOf(Cardinal);
        LiteralStringLengthPtr := nil;
      end;
  end;

var
  pStart: PAnsiChar;
  lStart: Cardinal;
  s: AnsiString;
begin
  {$IFNDEF DI_No_Pcre_Range_Checking}
  if FCode = nil then Error(PResStringRec(@SDIPcreCodeNilError), []);
  if FCode^.MAGIC_NUMBER <> DIPcreApi.MAGIC_NUMBER then Error(PResStringRec(@SDIPcreBadMagicError), []);
  {$ENDIF}

  p := Pointer(FFormatPattern);
  l := Cardinal(p);
  if l <> 0 then
    l := PCardinal(l - 4)^;

  CodeLength := l + StrCountCharA(FFormatPattern, AC_DOLLAR_SIGN) * 10 + 6;
  GetMem(FReplacementCode, CodeLength);
  CodePtr := FReplacementCode;

  if l > 0 then
    begin
      LiteralStringLengthPtr := nil;
      repeat
        if p^ = AC_DOLLAR_SIGN then
          begin
            Inc(p); Dec(l);
            pStart := p; lStart := l;

            if l > 0 then
              if p^ in AS_DIGITS then
                begin
                  n := 0;
                  repeat
                    n := n * 10 + Ord(p^) - Ord(AC_DIGIT_ZERO);
                    Inc(p); Dec(l);
                  until (l = 0) or not (p^ in AS_DIGITS);

                  if (n >= 0) and (n <= PRealPcre(FCode)^.top_bracket) then
                    begin
                      EndLiteralString;
                      PReplacementToken(CodePtr)^ := rtSubString;
                      Inc(Cardinal(CodePtr), SizeOf(TReplacementToken));
                      PCardinal(CodePtr)^ := n;
                      Inc(Cardinal(CodePtr), SizeOf(Cardinal));
                      Continue;
                    end;
                end
              else
                if p^ = AC_LESS_THAN_SIGN then
                  begin
                    Inc(p); Dec(l);
                    while (l > 0) and (p^ <> AC_GREATER_THAN_SIGN) do
                      begin
                        Inc(p); Dec(l);
                      end;
                    if (l > 0) and (p^ = AC_GREATER_THAN_SIGN) then
                      begin
                        SetString(s, pStart + 1, p - pStart - 1);
                        n := NamedSubStrNumByName(s);

                        if n > 0 then
                          begin
                            Inc(p); Dec(l);
                            EndLiteralString;
                            PReplacementToken(CodePtr)^ := rtSubString;
                            Inc(Cardinal(CodePtr), SizeOf(TReplacementToken));
                            PCardinal(CodePtr)^ := n;
                            Inc(Cardinal(CodePtr), SizeOf(Cardinal));
                            Continue;
                          end;
                      end;
                  end;

            BeginLiteralString;
            PAnsiChar(CodePtr)^ := AC_DOLLAR_SIGN;
            Inc(Cardinal(CodePtr), SizeOf(p^));
            p := pStart; l := lStart;
          end
        else
          begin
            BeginLiteralString;

            repeat
              if p^ = AC_REVERSE_SOLIDUS then
                begin
                  Inc(p); Dec(l);
                  if l = 0 then
                    begin
                      PAnsiChar(CodePtr)^ := AC_REVERSE_SOLIDUS;
                      Inc(Cardinal(CodePtr), SizeOf(p^));
                      Break;
                    end
                end;

              PAnsiChar(CodePtr)^ := p^;
              Inc(Cardinal(CodePtr), SizeOf(p^));

              Inc(p); Dec(l);
            until (l = 0) or (p^ = AC_DOLLAR_SIGN);
          end;

      until l = 0;
    end;

  EndLiteralString;

  PReplacementToken(CodePtr)^ := rtEOf;
end;

procedure TDICustomPcre.SetFormatPattern(const NewFormatPattern: AnsiString);
begin
  if FFormatPattern <> NewFormatPattern then
    begin
      FFormatPattern := NewFormatPattern;
      FreeMem(FReplacementCode);
      FReplacementCode := nil;
    end;
end;

procedure TDICustomPcre.InternalFormat(var s: AnsiString; var InUse: Cardinal; const AVector: PDIPcreVectorArray);
var
  p: Pointer;
  l: Cardinal;
begin
  p := FReplacementCode;

  repeat
    case PReplacementToken(p)^ of
      rtLiteralString:
        begin
          Inc(Cardinal(p), SizeOf(TReplacementToken));
          l := PCardinal(p)^;
          Inc(Cardinal(p), SizeOf(Cardinal));
          ConCatBufA(p, l, s, InUse);
          Inc(Cardinal(p), l);
        end;
      rtSubString:
        begin
          Inc(Cardinal(p), SizeOf(TReplacementToken));
          l := PCardinal(p)^;
          Inc(Cardinal(p), SizeOf(Cardinal));
          {$IFNDEF DI_No_Pcre_Range_Checking}
          if l > PRealPcre(FCode)^.top_bracket then Error(PResStringRec(@SDIPcreSubStringIndexError), [l]);
          {$ENDIF}
          with AVector^[l] do
            ConCatBufA(FSubjectPointer + FirstCharPos, AfterLastCharPos - FirstCharPos, s, InUse);
        end;
    else
      Break;
    end;
  until False;

end;

function TDICustomPcre.Format: AnsiString;
var
  ResultLength: Cardinal;
begin
  Result := '';
  if FSubStrCount <= 0 then Exit;

  if FReplacementCode = nil then CompileFormatPattern;
  if FReplacementCode = nil then Exit;
  ResultLength := 0;
  InternalFormat(Result, ResultLength, FVector);
  SetLength(Result, ResultLength);
end;

function TDICustomPcre.Replace(StartOffSet: Cardinal = 0; Limit: Integer = -1): AnsiString;
label
  ReturnSubject;
var
  ResultLength: Cardinal;
  LocalMatchOptionBits: Cardinal;
  LocalVector: PDIPcreVectorArray;
  LocalVectorSize: Cardinal;
begin
  if FCode = nil then goto ReturnSubject;

  if FReplacementCode = nil then CompileFormatPattern;
  if FReplacementCode = nil then goto ReturnSubject;

  Result := '';
  ResultLength := 0;

  LocalMatchOptionBits := FMatchOptionBits or PCRE_NOTEMPTY;

  LocalVectorSize := PRealPcre(FCode)^.top_bracket;

  LocalVectorSize := (LocalVectorSize + 1) * 3 * 2;

  if Limit <> 0 then
    begin
      GetMem(LocalVector, LocalVectorSize * SizeOf(LocalVector[0]));
      try
        if pcre_exec(FCode, FExtra, FSubjectPointer, FSubjectLength, StartOffSet, LocalMatchOptionBits, Pointer(LocalVector), LocalVectorSize) > 0 then
          begin

            LocalMatchOptionBits := LocalMatchOptionBits or PCRE_NO_UTF8_CHECK;
            repeat
              ConCatBufA(PAnsiChar(FSubjectPointer + StartOffSet), Cardinal(LocalVector^[0].FirstCharPos) - StartOffSet, Result, ResultLength);
              InternalFormat(Result, ResultLength, LocalVector);
              StartOffSet := LocalVector^[0].AfterLastCharPos;
              if Limit > 0 then
                begin
                  Dec(Limit);
                  if Limit = 0 then Break;
                end;
            until pcre_exec(FCode, FExtra, FSubjectPointer, FSubjectLength, StartOffSet, LocalMatchOptionBits, Pointer(LocalVector), LocalVectorSize) <= 0;
          end;
      finally
        FreeMem(LocalVector, LocalVectorSize);
      end;
    end;

  ConCatBufA(Pointer(FSubjectPointer + StartOffSet), FSubjectLength - StartOffSet, Result, ResultLength);
  SetLength(Result, ResultLength);
  Exit;

  ReturnSubject:
  SetString(Result, FSubjectPointer, FSubjectLength);
end;

function TDICustomPcre.List(StartOffSet: Cardinal = 0; Limit: Integer = -1): AnsiString;
label
  ReturnEmptyString;
var
  ResultLength: Cardinal;
  LocalMatchOptionBits: Cardinal;
  LocalVector: PDIPcreVectorArray;
  LocalVectorSize: Cardinal;
begin
  if FCode = nil then goto ReturnEmptyString;

  if FReplacementCode = nil then CompileFormatPattern;
  if FReplacementCode = nil then goto ReturnEmptyString;

  Result := '';
  ResultLength := 0;

  LocalMatchOptionBits := FMatchOptionBits or PCRE_NOTEMPTY;

  LocalVectorSize := PRealPcre(FCode)^.top_bracket;

  LocalVectorSize := (LocalVectorSize + 1) * 3 * 2;

  if Limit <> 0 then
    begin
      GetMem(LocalVector, LocalVectorSize * SizeOf(LocalVector[0]));
      try
        if pcre_exec(FCode, FExtra, FSubjectPointer, FSubjectLength, StartOffSet, LocalMatchOptionBits, Pointer(LocalVector), LocalVectorSize) > 0 then
          begin
            LocalMatchOptionBits := LocalMatchOptionBits or PCRE_NO_UTF8_CHECK;
            repeat
              InternalFormat(Result, ResultLength, LocalVector);
              StartOffSet := LocalVector^[0].AfterLastCharPos;
              if Limit > 0 then
                begin
                  Dec(Limit);
                  if Limit = 0 then Break;
                end;
            until pcre_exec(FCode, FExtra, FSubjectPointer, FSubjectLength, StartOffSet, LocalMatchOptionBits, Pointer(LocalVector), LocalVectorSize) <= 0;
          end;
      finally
        FreeMem(LocalVector, LocalVectorSize);
      end;
    end;

  SetLength(Result, ResultLength);
  Exit;

  ReturnEmptyString:
  Result := '';
end;

function PcreCallOut(const pcre_callout_block: PPcre_Callout_Block): Integer;
begin
  Result := 0;
  with pcre_callout_block^ do
    if Callout_Data <> nil then
      TDICustomPcre(Callout_Data).FOnCallOut(pcre_callout_block, Result);
end;

initialization
  _pcre_callout := PcreCallOut;

end.

