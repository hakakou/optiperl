unit CTParser;
(*
  Syntax:
  0xABCD, 0ABCDh, $ABCD - Hex number
  0b0101, 01010b,       - Binary number
  90`15`2               - Degree
   Operators by priorities:
    {7  } () (BRACES)
    {  6} ** (POWER),
    {  5} ~ (INVERSE), ! (NOT),
    {  4} * (MUL), / (DIV), % (MOD), %% (PERSENT),
    {  3} + (ADD), - (SUB),
    {  2} < (LT), <= (LE), == (EQ), <> != (NE), >= (GE), > (GT),
    {  1} | (OR), ^ (XOR), & (AND),


  Single parameter double functions supported. ROUND, TRUNC, INT, FRAC,
  SIN, COS, TAN, ATAN, LN, EXP, SIGN, SGN, XSGN
  These functions take a double value as a parameter and return a double
  value.

  Single Parameter string functions supported. TRIM, LTRIM, RTRIM
  Thess functions take a string value as a parameter and return a string
  value

  Special functions supported. IF, EMPTY, LEN, AND, OR, CONCATENATE, REPL,
  LEFT, RIGHT, SUBSTR, COMPARE, ISNA, ROUND, NOT, EVALUATE
  Special functions use either a single parameter of type other than
  their return type, or work with multiple parameters).


*)

// Use of String in TNamedVar Structure
// Variables and functions are case sensitive

interface

uses SysUtils, Classes {$ifdef calctest}, Windows {$endif};

type
  TToken = (
    { } tkEOF, tkERROR, tkASSIGN,
    {7} tkLBRACE, tkRBRACE, tkNUMBER, tkIDENT, tkSEMICOLON,
    {6} tkPOW,
    {5} tkINV, tkNOT,
    {4} tkMUL, tkDIV, tkMOD, tkPER,
    {3} tkADD, tkSUB,
    {2} tkLT, tkLE, tkEQ, tkNE, tkGE, tkGT,
    {1} tkOR, tkXOR, tkAND, tkString
  );

  ECalculate = class(Exception);
  TCalcType = (ctGetValue, ctSetValue, ctFunction);
  TExpType = (etString, etDouble, etBoolean, etUnknown);

  TCalcNoIdentEvent = procedure (Sender: TObject; ctype: TCalcType;
    const S: String; var Value: Double; var Handled: Boolean) of Object;
  TCalcNoStrIdentEvent = procedure (Sender: TObject; ctype: TCalcType;
    const S: String; var StrValue: String; var Handled: Boolean) of Object;

  TCalcCBProc =  function(ctype: TCalcType; const S: String;
      var Value: Double): Boolean of Object;
  TCalcCBStrProc = function(ctype: TCalcType; const S: String;
      var Value: String): Boolean of Object;

  PEvalResult = ^TEvalResult;
  TEvalResult = record
    Val,
    Res: Double;
    LogOp: String;
  end;

  PNamedVar = ^TNamedVar;
  TNamedVar = record
    Value: Double;
    Name: String;
    IsNA: Boolean;
    Dep: TList;
  end;

  PExpVal = ^TExpVal;
  TExpVal = record
    Exp: String;
    Val: Double;
  end;

  PContext = ^TContext;
  TContext = record
    // For saving and restoring context
    OldPtr: PChar;
    OldLN: Integer;
    OldExp,
    OldSValue: String;
    OldToken: TToken;
  end;

  PNamedStrVar = ^TNamedStrVar;
  TNamedStrVar = record
    Value,
    Name: String;
    IsNA: Boolean;
    Dep: TList;
  end;

  TKAParser = class;

  TFormula = class
  private
    FExp,
    FName: String;
    FIsNA: Boolean;
    FValue: Double;
    FStrValue: String;
    FValid: Boolean;
    FEvaluated: Boolean;
    FCalc: TKAParser;
    // A parser can be dependent on both, double as well as
    // string variables.
    FDep,
    FStrDep,
    FFormDep: TList;
    function GetValue: Double;
    function GetStrValue: String;
  public
    constructor Create(Calc: TKAParser);
    destructor Destroy; override;
    property Exp: String read FExp write FExp;
    property Name: String read FName write FName;
    property IsNA: Boolean read FIsNA write FIsNA;
    property Value: Double read GetValue;
    property StrValue: String read GetStrValue;
  end;

  TKAParser = class(TComponent)
  private
    {$ifdef CALCTEST}
    T: TextFile;
    Line: Integer;
    {$endif}
    {$ifdef friendlymode}
    T2: TextFile;
    {$endif}
    ptr: PChar;
    lineno: Word;
    fvalue: Double;
    svalue : String;
    token: TToken;
    CalcProc: TCalcCBProc;
    StrCalcProc: TCalcCBStrProc;
    FMaxExpCache: Word;
    FRecFormula: TList;
    FRecording: Boolean;
    FOnNoIdent: TCalcNoIdentEvent;
    FOnNoStrIdent: TCalcNoStrIdentEvent;
    FExpression: String;
    FVars,
    FStrVars,
    FFormulae: TList;
    FSpecialFunctions: TStringList;
    FExpCache: TList;
    FEvalList: TList;
    FDefaultStrVar,
    FDefaultVar,
    FDummyCalc: Boolean;
    FDefaultStrVarAs: String;
    FDefaultVarAs: Double;

    // property access methods
    function  GetResult: Double;
    function GetStrResult: String;
    function  _GetVar(const Name: String): Double;
    function  GetVar(const Name: String): Double;
    function _GetStrVar(const Name: String): String;
    function GetStrVar(const Name: String): String;
    procedure SetVar(const Name: String; value: Double);
    procedure SetStrVar(const Name, value: String);
    function GetVarCount: Integer;
    function GetStrVarCount: Integer;
    function GetFormula(const Name: String): String;
    function GetFormulaeCount: Integer;
    procedure SetFormula(const Name, Value: String);
    procedure RaiseError(const Msg: String);
    function tofloat(B: Boolean): Double;
    // Lexical parser functions
    procedure lex;
    procedure start(var R: Double);
    procedure term (var R: Double);
    procedure expr6(var R: Double);
    procedure expr5(var R: Double);
    procedure expr4(var R: Double);
    procedure expr3(var R: Double);
    procedure expr2(var R: Double);
    procedure expr1(var R: Double);
    procedure ExpStr(var R: String);
    procedure StrTerm(var R: String);
    procedure StrStart(var R: String);
    function SaveContext: PContext;
    procedure RestoreContext(P: PContext);
    function ExecFunc(FuncName: String; ParamList: TStringList): Double;
    function ExecStrFunc(FuncName: String; ParamList: TStringList): String;
    function IsSpecialFunction(FN: String): Boolean;

    procedure RecordVar(const Name: String);
    procedure RecordStrVar(const Name: String);
    procedure DelFormDep(Formula: TFormula);
    // Sledgehammer deletes for use from Destroy only!
    procedure DeleteVars;
    procedure DeleteStrVars;
    procedure DeleteFormulae;
    // Formula and variable access methods
    function GetFormulaObj(const Name: String; var Index: Integer): TFormula;
    function GetVarObj(const Name: String; var Index: Integer): PNamedVar;
    function GetStrVarObj(const Name: String; var Index: Integer): PNamedStrVar;
    {$ifdef demo}
    procedure Nag;
    {$endif}
    // vk:10/03/99
    function GetEvalVal(Eval: Double): Double;
    procedure DeleteEvals;
  protected
    // Default identifier handling for float calculations
    function DefCalcProc(ctype: TCalcType; const S: String;
      var V: Double): Boolean; virtual;
    // Default identifier handling for string calculations
    function DefStrCalcProc(ctype: TCalcType; const S: String;
      var V: String): Boolean; virtual;
    function IdentValue(ctype: TCalcType;
              const Name: String; var Res: Double): Boolean; virtual;
    function IdentStrValue(ctype: TCalcType;
              const Name: String; var Res: String): Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function  NameOfVar(Index: Word): String;
    function  NameOfStrVar(Index: Word): String;
    function NameOfFormula(Index: Word): String;
    function GetFormulaValue(const Name: String): Double;
    function GetFormulaStrValue(const Name: String): String;
    procedure DeleteVar(const Name: String);
    procedure DeleteStrVar(const Name: String);
    procedure DeleteFormula(const Name: String);
    procedure SetVarNA(const Name: String; Val: Boolean);
    procedure SetStrVarNA(const Name: String; Val: Boolean);
    procedure SetFormulaNA(const Name: String; Val: Boolean);
    function IsVarNA(const Name: String): Boolean;
    function IsStrVarNA(const Name: String): Boolean;
    function IsFormulaNA(const Name: String): Boolean;
    // function GetExpType(Exp: String): TExpType;
    // String calculations
    function StrCalculate(const Formula: String;
      var R: String; Proc: TCalcCBStrProc): Boolean;
    // Float calculations
    function Calculate(const Formula: String;
      var R: Double; Proc: TCalcCBProc): Boolean;
    {$ifdef CALCTEST}
    procedure GetFormDep(const Name: String; Dep: TStringList);
    {$endif}
    // Added in support of the new Evaluate function vk:10/03/99
    procedure AddEvaluation(LogOp: String; Val, Res: Double);
    procedure RemoveEvaluation(LogOp: String; Val: Double);
    // End new
    procedure GetFormulaVarDep(const Name: String; Dep: TStringList);
    procedure GetFormulaStrVarDep(const Name: String; Dep: TStringList);
    procedure GetFormulaFormDep(const Name: String; Dep: TStringList);
    procedure GetVarDep(const Name: String; Dep: TStringList);
    procedure GetStrVarDep(const Name: String; Dep: TStringList);
    property Vars[const Name: String]: Double Read GetVar Write SetVar;
    property StrVars[const Name: String]: String Read GetStrVar Write SetStrVar;
    property Formula[const Name: String]: String read GetFormula write SetFormula;
    property VarCount: Integer read GetVarCount;
    property StrVarCount: Integer read GetStrVarCount;
    property FormulaeCount: Integer read GetFormulaeCount;
    property Result: Double Read GetResult;
    property StrResult: String Read GetStrResult;
  published
    // Properties
    property Expression: String Read FExpression Write FExpression;
    property OnNoIdent: TCalcNoIdentEvent read FOnNoIdent write FOnNoIdent;
    property OnNoStrIdent: TCalcNoStrIdentEvent read FOnNoStrIdent
      write FOnNoStrIdent;
    property DefaultVar: Boolean read FDefaultVar write FDefaultVar
      default False;
    property DefaultStrVar: Boolean read FDefaultStrVar
      write FDefaultStrVar default False;
    property DefaultVarAs: Double read FDefaultVarAs
      write FDefaultVarAs;
    property DefaultStrVarAs: String read FDefaultStrVarAs
      write FDefaultStrVarAs;
    property MaxExpCache: Word read FMaxExpCache
      write FMaxExpCache default 100;
  end;


resourcestring
  SSyntaxError = 'Syntax error.';
  SFunctionError = 'Unknown function or variable';
  SInvalidDegree = 'Invalid degree %s';
  SInvalidString = 'Invalid string';
  SCannotDelete = 'Cannot delete a variable with formula dependencies!';
  SWrongParamCount = 'Incorrect parameter count for function!';

// Utility math functions
function fmod(x, y: extended): extended;
function power(x, y: Double): Double;
function DegreeToStr(Angle: Extended): String;
function StrToDegree(const S: String): Extended;

implementation

uses Dialogs ;

function fmod(x, y: extended): extended;
begin
  Result := x - Int(x / y) * y;
end;

function power(x, y: Double): Double;
begin
  if (x = 0)
  then power := 1.0
  else power := Exp(Ln(x)*y);
end;

function DegreeToStr(Angle: extended): String;
var
  ang, min, sec: LongInt;
begin
  Result := '';
  if Abs(Angle) < 1E-20 then Angle := 0.;
  if Angle < 0 then begin
    Result := '-';
    Angle := -Angle;
  end;
  Angle := Angle * 180.0 / Pi; ang := Trunc(Angle+5E-10);
  Angle := (Angle - ang) * 60; min := Trunc(Angle+5E-10);
  Angle := (Angle - min) * 60; sec := Trunc(Angle+5E-10);
  Result := Result + IntToStr(ang)+'`';
  if min <> 0 then Result := Result + IntToStr(min);
  if sec <> 0 then Result := Result + '`' + IntToStr(sec);
end;

function StrToDegree(const S: String): Extended;
var
  ptr: PChar;
  frac, sign: Extended;
begin
  ptr := PChar(S);
  sign := 1;
  if (ptr^ in ['-', '+']) then begin
    if (ptr^ = '-') then sign := -sign;
    Inc(ptr);
  end;
  if not(ptr^ in ['0', '9'])
    then EConvertERROR.CreateFmt(SInvalidDegree, [S]);
  frac := 0;
  while (ptr^ in ['0'..'9']) do begin
    frac := frac * 10 + (Ord(ptr^) - Ord('0'));
    Inc(ptr);
  end;
  Result := frac;
  if (ptr^ = '`') then begin
  Result := Result * Pi / 180.0;
  Inc(ptr); frac := 0;
  while (ptr^ in ['0'..'9']) do begin
    frac := frac * 10 + (Ord(ptr^) - Ord('0'));
    Inc(ptr);
  end;
  Result := Result + (frac * Pi / 180.0 / 60);
  if (ptr^ = '`') then begin
  Inc(ptr); frac := 0;
  while (ptr^ in ['0'..'9']) do begin
    frac := frac * 10 + (Ord(ptr^) - Ord('0'));
    Inc(ptr);
  end;
  Result := Result + (frac * Pi / 180.0 / 60 / 60);
  end;
  end;
  Result := Sign * fmod(Result, 2*Pi);
end;

{-------------------------- TFormula ----------------------- }

constructor TFormula.Create(Calc: TKAParser);
begin
  inherited Create;
  FDep := TList.Create;
  FStrDep := TList.Create;
  FFormDep := TList.Create;
  FCalc := Calc;
end;

destructor TFormula.Destroy;
begin
  FDep.Clear;
  FDep.Free;
  FStrDep.Free;
  FFormDep.Clear;
  FFormDep.Free;
  inherited Destroy;
end;

function TFormula.GetValue: Double;
var
  SavedContext: PContext;
  WasRecording: Boolean;
  I: Integer;
begin
  if FValid then
  begin
    if FCalc.FRecording then
    begin
      // Add this formula as a dependency of the formula(e) being parsed.
      for I := 0 to FCalc.FRecFormula.Count - 1 do
        TFormula(FCalc.FRecFormula[I]).FFormDep.Add(Self);
      // Add the formula's dependencies to those of the formulae
      // being evaluated
      for I := 0 to FDep.Count - 1 do
        FCalc.RecordVar(PNamedVar(FDep[I]).Name);
      for I := 0 to FStrDep.Count - 1 do
        FCalc.RecordStrVar(PNamedStrVar(FStrDep[I]).Name);
    end;
    Result := FValue;
  end
  else
  begin
    if not FEvaluated then
    begin
      WasRecording := FCalc.FRecording;
      // if this formula participates in another formula's expression
      // add it to the formula dependency list of the other formula
      if WasRecording then
        for I := 0 to FCalc.FRecFormula.Count - 1 do
          TFormula(FCalc.FRecFormula[I]).FFormDep.Add(Self);
      FCalc.FRecording := True;
      FCalc.FRecFormula.Add(Self);
      SavedContext := FCalc.SaveContext;
      FCalc.FExpression := FExp;
      FValue := FCalc.Result;
      FEvaluated := True;
      FCalc.RestoreContext(SavedContext);
      FValid := True;
      Result := FValue;
      if not WasRecording then
        FCalc.FRecording := False;
      FCalc.FRecFormula.Delete(FCalc.FRecFormula.Count - 1);
    end
    else
    begin
      SavedContext := FCalc.SaveContext;
      FCalc.FExpression := FExp;
      FValue := FCalc.Result;
      FValid := True;
      FCalc.RestoreContext(SavedContext);
      Result := FValue;
 //    if FCalc.FDoRecalc then
 //    FCalc.FDoRecalc := False;
    end;
  end;
end;

function TFormula.GetStrValue: String;
var
  SavedContext: PContext;
  WasRecording: Boolean;
  I: Integer;
begin
  if FValid then
  begin
    if FCalc.FRecording then
    begin
      // Add this formula as a dependency of the formula(e) being parsed.
      for I := 0 to FCalc.FRecFormula.Count - 1 do
        TFormula(FCalc.FRecFormula[I]).FFormDep.Add(Self);
      // Add the formula's dependencies to those of the formulae
      // being evaluated
      for I := 0 to FDep.Count - 1 do
        FCalc.RecordVar(PNamedVar(FDep[I]).Name);
      for I := 0 to FStrDep.Count - 1 do
        FCalc.RecordStrVar(PNamedStrVar(FStrDep[I]).Name);
    end;
    Result := FStrValue;
  end
  else
  begin
    if not FEvaluated then
    begin
      WasRecording := FCalc.FRecording;
      // if this formula participates in another formula's expression
      // add it to the formula dependency list of the other formula
      if WasRecording then
        for I := 0 to FCalc.FRecFormula.Count - 1 do
          TFormula(FCalc.FRecFormula[I]).FFormDep.Add(Self);
      FCalc.FRecording := True;
      FCalc.FRecFormula.Add(Self);
      SavedContext := FCalc.SaveContext;
      FCalc.FExpression := FExp;
      FStrValue := FCalc.StrResult;
      FCalc.RestoreContext(SavedContext);
      Result := FStrValue;
      FValid := True;
      FEvaluated := True;
      if not WasRecording then
        FCalc.FRecording := False;
      FCalc.FRecFormula.Delete(FCalc.FRecFormula.Count - 1);
    end
    else
    begin
      SavedContext := FCalc.SaveContext;
      FCalc.FExpression := FExp;
      FStrValue := FCalc.StrResult;
      FValid := True;
      FCalc.RestoreContext(SavedContext);
      Result := FStrValue;
    end;
  end;
end;


{------------------------- TKAParser ----------------------- }


function TKAParser.ExecFunc(FuncName: String; ParamList: TStringList): Double;
var
  I: Integer;
  SavedContext: PContext;
  Temp: String;
begin
  Result := 0.0;
  // We will handle iif, empty, and, or, len,
  if FuncName = 'IF' then
  begin
    if ParamList.Count <> 3 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Result := Self.Result;
    if Result >= 1.0 then
    begin
      FExpression := ParamList.Strings[1];
      Result := Self.Result;
      // Ensure dependency list gets built correctly
      if FRecording then
      begin
        FExpression := ParamList.Strings[2];
        FDummyCalc := True;
        try
          Self.Result;
        finally
          FDummyCalc := False;
        end;
      end;
    end
    else
    begin
      FExpression := ParamList.Strings[2];
      Result := Self.Result;
      // Ensure dependency list gets built correctly
      if FRecording then
      begin
        FExpression := ParamList.Strings[1];
        Self.Result;
      end;
    end;
    RestoreContext(SavedContext);
  end
  else if FuncName = 'LEN' then
  begin
    if ParamList.Count <> 1 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Result := Length(Self.StrResult);
    RestoreContext(SavedContext);
  end
  else if FuncName = 'EMPTY' then
  begin
    if ParamList.Count <> 1 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    {ECO: the whole word could be spaces...}
    if Length(Trim(StrResult)) > 0 then
      Result := 0.0
    else
      Result := 1.0;
    RestoreContext(SavedContext);
  end
  else if FuncName = 'COMPARE' then
  begin
    if ParamList.Count <> 2 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Temp := StrResult;
    FExpression := ParamList.Strings[1];
    if CompareStr(Temp, StrResult) = 0 then
      Result := 1.0
    else
      Result := 0.0;
    RestoreContext(SavedContext);
  end
  // vk:10/03/99
  else if FuncName = 'EVALUATE' then
  begin
    if ParamList.Count <> 1 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Result := GetEvalVal(Self.Result);
    RestoreContext(SavedContext);
  end
  else if FuncName = 'AND' then
  // Returns a 0.0 for false and a value greater than 1.0 for True;
  begin
    if ParamList.Count < 2 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    Result := 1.0;
    for I := 0 to ParamList.Count - 1 do
    begin
      FExpression := ParamList.Strings[I];
      Result := Result * Self.Result;
    end;
    if Result > 0.0 then
      Result := 1.0;
    RestoreContext(SavedContext);
  end
  else if FuncName = 'OR' then
  // Returns a 0.0 for false and a value greater than 1.0 for true;
  begin
    if ParamList.Count < 2 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    Result := 0.0;
    for I := 0 to ParamList.Count - 1 do
    begin
      FExpression := ParamList.Strings[I];
      Result := Result + Self.Result;
    end;
    if Result > 0.0 then
      Result := 1.0;
    RestoreContext(SavedContext);
  end
  else if FuncName = 'ROUND' then
  begin
    if ParamList.Count <> 2 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Result := Self.Result;
    FExpression := ParamList.Strings[1];
    I := Round(Self.Result);
    Result := StrToFloat(Format('%.*f', [I, Result]));
    RestoreContext(SavedContext);
  end
  else if FuncName = 'ISVARNA' then
  begin
    if ParamList.Count <> 1 then
      raiseerror(SWrongParamCount);
    if IsVarNA(ParamList.Strings[0]) then
      Result := 1.0
    else
      Result := 0.0;
  end
  else if FuncName = 'ISSTRVARNA' then
  begin
    if ParamList.Count <> 1 then
      raiseerror(SWrongParamCount);
    if IsStrVarNA(ParamList.Strings[0]) then
      Result := 1.0
    else
      Result := 0.0;
  end
  else if FuncName = 'ISFORMULANA' then
  begin
    if ParamList.Count <> 1 then
      raiseerror(SWrongParamCount);
    if IsFormulaNA(ParamList.Strings[0]) then
      Result := 1.0
    else
      Result := 0.0;
  end
  {ECO: added a not function... }
  else if FuncName = 'NOT' then
  begin
    if ParamList.Count <> 1 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    if Trunc(Self.Result) = 0 then
      Result := 1.0
    else
      Result := 0.0;
    RestoreContext(SavedContext);
  end ;
end;

function TKAParser.ExecStrFunc(FuncName: String; ParamList: TStringList): String;
var
  I: Integer;
  J: Double;
  SavedContext: PContext;
  Temp: String;
begin
  // We will handle iif, empty, and, or, len,
  if FuncName = 'IF' then
  begin
    if ParamList.Count <> 3 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    if Self.Result >= 1.0 then
    begin
      FExpression := ParamList.Strings[1];
      Result := Self.StrResult;
      // Ensure dependency list gets built correctly
      if FRecording then
      begin
        FExpression := ParamList.Strings[2];
        Self.StrResult;
      end;
    end
    else
    begin
      FExpression := ParamList.Strings[2];
      Result := Self.StrResult;
      // Ensure dependency list gets built correctly
      if FRecording then
      begin
        FExpression := ParamList.Strings[1];
        Self.StrResult;
      end;
    end;
    RestoreContext(SavedContext);
  end
  else if FuncName = 'REPL' then
  begin
    if ParamList.Count <> 2 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Result := Self.StrResult;
    Temp := Result;
    FExpression := ParamList.Strings[1];
    J := Self.Result;
    for I := 1 to Round(J) do
      Result := Result + Temp;
    RestoreContext(SavedContext);
  end
  else if FuncName = 'CONCATENATE' then
  begin
    if ParamList.Count < 2 then
      raiseerror(SWrongParamCount);
    Result := '';
    SavedContext := SaveContext;
    for I := 0 to ParamList.Count - 1 do
    begin
      FExpression := ParamList.Strings[I];
      Result := Result + Self.StrResult;
    end;
    RestoreContext(SavedContext);
  end
  else if FuncName = 'LEFT' then
  begin
    if ParamList.Count <> 2 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Result := Self.StrResult;
    FExpression := ParamList.Strings[1];
    Result := Copy(Result, 1, Round(Self.Result));
    RestoreContext(SavedContext);
  end
  else if FuncName = 'RIGHT' then
  begin
    if ParamList.Count <> 2 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Temp := StrResult;
    FExpression := ParamList.Strings[1];
    Result := Copy(Temp, Length(Temp) - Round(Self.Result) + 1, Length(Temp));
    RestoreContext(SavedContext);
  end
  else if FuncName = 'SUBSTR' then
  begin
    if ParamList.Count <> 3 then
      raiseerror(SWrongParamCount);
    SavedContext := SaveContext;
    FExpression := ParamList.Strings[0];
    Temp := StrResult;
    FExpression := ParamList.Strings[1];
    J := Self.Result;
    FExpression := ParamList.Strings[2];
    Result := Copy(Temp, Round(J), Round(Self.Result));
    RestoreContext(SavedContext);
  end
end;


function TKAParser.SaveContext: PContext;
begin
  New(Result);
  Result.OldPtr := Ptr;
  Result.OldLN := Lineno;
  Result.OldSValue := SValue;
  Result.OldExp := FExpression;
  Result.OldToken := Token;
end;

procedure TKAParser.RestoreContext(P: PContext);
begin
  Ptr := P.OldPtr;
  Lineno := P.OldLN;
  SValue := P.OldSValue;
  FExpression := P.OldExp;
  Token := P.OldToken;
  Dispose(P);
end;

function TKAParser.IsSpecialFunction(FN: String): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FSpecialFunctions.Count - 1 do
    if FSpecialFunctions[I] = FN then
    begin
      Result := True;
      Exit;
    end;
end;

{
function TKAParser.GetExpType(Exp: String): TExpType;
var
  SavedContext: PContext;
begin
  Result := etUnknown;
  // look for quotes
  if Pos('''', Exp) > 0 then
    Result := etString
  else
  begin
    SavedContext := SaveContext;
    FExpression := Exp;
    try
      Ptr := PChar(FExpression);
      Lineno := 1;
      Token := tkError;
      while Token <> tkEOF do
      begin
        lex;
        Inc(Ptr);
        if Token = tkIdent then
        begin
          try
            _GetStrVar(SValue);
          except
            break;
          end;
          Result := etString;
          Exit;
        end;
      end;
      Result := etDouble;
    finally
      RestoreContext(SavedContext);
    end;
  end;
end;
}

function TKAParser.DefCalcProc(ctype: TCalcType; const S: String;
  var V: Double): Boolean;
begin
  Result := TRUE;
  case ctype of
    ctGetValue: begin
      if S = 'PI' then V := Pi else
      if S = 'E' then V := 2.718281828 else
      if S = 'TRUE' then V := 1.0 else
      if S = 'FALSE' then V := 0.0 else
      Result := FALSE;
    end;
    ctSetValue: begin
      Result := FALSE;
    end;
    ctFunction: begin
//      if S = 'ROUND'  then V := Round(V) else
      if S = 'TRUNC'  then V := Trunc(V) else
      if S = 'INT'  then V := Int(V) else
      if S = 'FRAC'  then V := Frac(V) else
      if S = 'SIN'  then V := sin(V) else
      if S = 'COS'  then V := cos(V) else
      if S = 'TAN'  then V := sin(V)/cos(V) else
      if S = 'ATAN' then V := arctan(V) else
      if S = 'LN'   then V := ln(V) else
      if S = 'EXP'  then V := exp(V) else
      if S = 'SIGN' then begin if (V>0) then V := 1 else if(V<0) then V := -1 end else
      if S = 'SGN' then begin if (V>0) then V := 1 else if(V<0) then V := 0 end else
      if S = 'XSGN' then begin if(V<0) then V := 0 end else
      Result := FALSE;
    end;
  end;
end;

function TKAParser.DefStrCalcProc(ctype: TCalcType; const S: String;
  var V: String): Boolean;
begin
  Result := FALSE;
  case ctype of
    ctGetValue:;
    ctSetValue:;
    ctFunction:
    begin
      Result := TRUE;
      if S = 'TRIM' then
         V := Trim(V)
       else if S = 'LTRIM' then     // added code from here
         V := TrimLeft(V)
       else if S = 'RTRIM' then
         V := TrimRight(V)
       else
         Result := FALSE;
     end;
  end;
end;



procedure TKAParser.RaiseError(const Msg: String);
begin
  raise ECalculate.Create(Msg);
end;

function TKAParser.tofloat(B: Boolean): Double;
begin
  if (B) then tofloat := 1.0 else tofloat := 0.0;
end;

{ yylex like function }

procedure TKAParser.lex;
label
  Error;
var
  c, sign: char;
  frac: Double;
  exp: LongInt;
  s_pos: PChar;

  function ConvertNumber(first, last: PChar; base: Word): boolean;
  var
    c: Byte;
  begin
    fvalue := 0;
    while first < last do begin
      c := Ord(first^) - Ord('0');
      if (c > 9) then begin
        Dec(c, Ord('A') - Ord('9') - 1);
        if (c > 15) then Dec(c, Ord('a') - Ord('A'));
      end;
      if (c >= base) then break;
      fvalue := fvalue * base + c;
      Inc(first);
    end;
    Result := (first = last);
  end;

begin
  { skip blanks }
  while ptr^ <> #0 do begin
    if (ptr^ = #13) then Inc(lineno)
    else if (ptr^ > ' ') then break;
    Inc(ptr);
  end;

  { check EOF }
  token := tkEOF;
  if (ptr^ = #0) then Exit;

  s_pos := ptr;
  token := tkNUMBER;

  { match pascal like hex number }
  if (ptr^ = '$') then begin
    Inc(ptr);
    while (ptr^ in ['0'..'9', 'A'..'H', 'a'..'h']) do Inc(ptr);
    if not ConvertNumber(s_pos, ptr, 16) then goto Error;
    Exit;
  end;

  { match numbers }
  if (ptr^ in ['0'..'9']) then begin

    { C like mathing }
    if (ptr^ = '0') then begin
      Inc(ptr);

      { match C like hex number }
      if (ptr^ in ['x', 'X']) then begin
        Inc(ptr);
        s_pos := ptr;
        while (ptr^ in ['0'..'9', 'A'..'H', 'a'..'h']) do Inc(ptr);
        if not ConvertNumber(s_pos, ptr, 16) then goto Error;
        Exit;
      end;

      { match C like binary number }
      if (ptr^ in ['b', 'B']) then begin
        Inc(ptr);
        s_pos := ptr;
        while (ptr^ in ['0'..'1']) do Inc(ptr);
        if not ConvertNumber(s_pos, ptr, 2) then goto Error;
        Exit;
      end;
    end;

    while (ptr^ in ['0'..'9', 'A'..'F', 'a'..'f']) do Inc(ptr);

    { match assembler like hex number }
    if (ptr^ in ['H', 'h']) then begin
      if not ConvertNumber(s_pos, ptr, 16) then goto Error;
      Inc(ptr);
      Exit;
    end;

    { match assembler like binary number }
    if (ptr^ in ['B', 'b']) then begin
      if not ConvertNumber(s_pos, ptr, 2) then goto Error;
      Inc(ptr);
      Exit;
    end;

    { match simple decimal number }
    if not ConvertNumber(s_pos, ptr, 10) then goto Error;

    { match degree number }
    if (ptr^ = '`') then begin
      fvalue := fvalue * Pi / 180.0;
      Inc(ptr); frac := 0;
      while (ptr^ in ['0'..'9']) do begin
        frac := frac * 10 + (Ord(ptr^) - Ord('0'));
        Inc(ptr);
      end;
      fvalue := fvalue + (frac * Pi / 180.0 / 60);
      if (ptr^ = '`') then begin
      Inc(ptr); frac := 0;
      while (ptr^ in ['0'..'9']) do begin
        frac := frac * 10 + (Ord(ptr^) - Ord('0'));
        Inc(ptr);
      end;
      fvalue := fvalue + (frac * Pi / 180.0 / 60 / 60);
      end;
      fvalue := fmod(fvalue, 2*Pi);
      Exit;
    end;

    { match float numbers }
    if (ptr^ = '.') then begin Inc(ptr);
      frac := 1;
      while (ptr^ in ['0'..'9']) do begin
        frac := frac / 10;
        fvalue := fvalue + frac * (Ord(ptr^) - Ord('0'));
        Inc(ptr);
      end;
    end;

    if (ptr^ in ['E', 'e']) then begin Inc(ptr);
      exp := 0;
      sign := ptr^;
      if (ptr^ in ['+', '-']) then Inc(ptr);
      if not (ptr^ in ['0'..'9']) then goto Error;
      while (ptr^ in ['0'..'9']) do begin
        exp := exp * 10 + Ord(ptr^) - Ord('0');
        Inc(ptr);
      end;
      if (exp = 0)
      then fvalue := 1.0
      else if (sign = '-')
      then while exp > 0 do begin fvalue := fvalue * 10; Dec(exp); end
      else while exp > 0 do begin fvalue := fvalue / 10; Dec(exp); end
    end;
    Exit;
  end;

  {VK : match string }
  if (ptr^ = '''') then
  begin
    svalue := ptr^;
    Inc(ptr);
    while True do
    //    while (Length(svalue) < sizeof(svalue) - 1) do
    begin
      case ptr^ of
        #0, #10, #13:
          RaiseError(SInvalidString);
        '''':
          begin
            Inc(ptr);
            if ptr^ <> '''' then
              break;
          end;
      end;
      svalue := svalue + ptr^;
      Inc(ptr);
    end;
    token := tkString;
    Exit;
  end;

  { match identifiers }
  if (ptr^ in ['A'..'Z','a'..'z','_']) then begin
    svalue := ptr^;
    Inc(ptr);
    while (ptr^ in ['A'..'Z','a'..'z','0'..'9','_']) do
    begin
      svalue := svalue + ptr^;
      Inc(ptr);
    end;
    token := tkIDENT;
    Exit;
  end;

  { match operators }
  c := ptr^; Inc(ptr);
  case c of
    '=': begin token := tkASSIGN;
      if (ptr^ = '=') then begin Inc(ptr); token := tkEQ; end;
    end;
    '+': begin token := tkADD; end;
    '-': begin token := tkSUB; end;
    '*': begin token := tkMUL;
      if (ptr^ = '*') then begin Inc(ptr); token := tkPOW; end;
    end;
    '/': begin token := tkDIV; end;
    '%': begin token := tkMOD;
      if (ptr^ = '%') then begin Inc(ptr); token := tkPER; end;
    end;
    '~': begin token := tkINV; end;
    '^': begin token := tkXOR; end;
    '&': begin token := tkAND; end;
    '|': begin token := tkOR; end;
    '<': begin token := tkLT;
      if (ptr^ = '=') then begin Inc(ptr); token := tkLE; end else
      if (ptr^ = '>') then begin Inc(ptr); token := tkNE; end;
    end;
    '>': begin token := tkGT;
      if (ptr^ = '=') then begin Inc(ptr); token := tkGE; end else
      if (ptr^ = '<') then begin Inc(ptr); token := tkNE; end;
    end;
    '!': begin token := tkNOT;
      if (ptr^ = '=') then begin Inc(ptr); token := tkNE; end;
    end;
    '(': begin token := tkLBRACE; end;
    ')': begin token := tkRBRACE; end;
    ';': begin token := tkSEMICOLON end;
    else begin token := tkERROR; dec(ptr); end;
  end;
  Exit;

Error:
  token := tkERROR;
end;

(*
// LL grammatic for calculator, priorities from down to up
//
// start: expr6;
// expr6: expr5 { & expr5 | ^ expr5 | & expr5 }*;
// expr5: expr4 { < expr4 | > expr4 | <= expr4 | >= expr4 | != expr4 | == expr4 }*;
// expr4: expr3 { + expr3 | - expr3 }*;
// expr3: expr2 { * expr2 | / expr2 | % expr2 | %% expr2 }*;
// expr2: expr1 { ! expr1 | ~ expr1 | - expr1 | + expr1 };
// expr1: term ** term
// term: tkNUMBER | tkIDENT | (start) | tkIDENT(start) | tkIDENT = start;
//
*)

procedure TKAParser.term(var R: Double); var S: String;
var
  P1, P2: PChar;
  ParamStr: String;
  ParamList: TStringList;
  Ctr: Integer;
begin
  case token of
    tkNUMBER: begin
      R := fvalue;
      lex;
    end;
    tkLBRACE: begin lex;
      expr6(R);
      if (token = tkRBRACE)
        then lex
        else RaiseError(SSyntaxError);
    end;
    tkIDENT: begin
      S := UpperCase(svalue);
      lex;
      if token = tkLBRACE then
      begin
        // if the enclosed expression has commas then we assume it is
        // a multiple parameter function call
        // We call ExecFunc passing it the name of the function and
        // the parameters in a stringlist.
        if IsSpecialFunction(S) then
        begin
          P1 := Ptr;
          Ctr := 1;
          while (P1^ <> #0) do
          begin
            if P1^ = '(' then
              Inc(Ctr)
            else if P1^ = ')' then
              Dec(Ctr);
            if Ctr = 0 then
              break
            else
              Inc(P1);
          end;
          if (P1^ <> ')') then
            RaiseError(SFunctionError+' "'+s+'".');
          SetLength(ParamStr, P1 - Ptr);
          StrLCopy(PChar(ParamStr), Ptr, P1 - Ptr);
          // Set Ptr to one past the brace
          Ptr := P1 + 1;
          ParamList := TStringList.Create;
          try
            P1 := PChar(ParamStr);
            P2 := PChar(ParamStr);
            Ctr := 0;
            while (P1^ <> #0) do
            begin
              if P1^ = '(' then
                Inc(Ctr)
              else  if P1^ = ')' then
                Dec(Ctr);
              if (P1^ = ',') and (Ctr = 0) then
              begin
                ParamList.Add(Trim(Copy(ParamStr, P2 - PChar(ParamStr) + 1, P1 - P2)));
                P2 := P1 + 1;
              end;
              Inc(P1);
            end;
            ParamList.Add(Trim(Copy(ParamStr, P2 - PChar(ParamStr) + 1, P1 - P2)));
            R := ExecFunc(s, ParamList);
          finally
            ParamList.Free;
          end;
          lex;
        end
        else
        begin
          lex;
          expr6(R);
          if (token = tkRBRACE) then lex
            // vk 11/19/99
            else RaiseError(SFunctionError + ' "' + s + '".');
          if not CalcProc(ctFunction, s, R)
            then RaiseError(SFunctionError+' "'+s+'".');
        end;
      end
      else if (token = tkASSIGN) then begin
        lex; expr6(R);
        if not calcProc(ctSetValue, s, R)
          then RaiseError(SFunctionError+' "'+s+'".');
      end else
      if not CalcProc(ctGetValue, s, R)
        then RaiseError(SFunctionError+' "'+s+'".');
    end;
    else {case}
      RaiseError('Syntax error.');
  end;
end;

procedure TKAParser.expr1(var R: Double); var V: Double;
begin
  term(R);
  if (token = tkPOW) then begin
    lex; term(V);
    R := power(R, V);
  end;
end;

procedure TKAParser.expr2(var R: Double);
var oldt: TToken;
begin
  if (token in [tkNOT, tkINV, tkADD, tkSUB]) then
  begin
    oldt := token;
    lex;
    expr2(R);
    case oldt of
      tkNOT:
        if Trunc(R) = 0 then
          R := 1.0
        else
          R := 0.0;
      tkINV: R := (not Trunc(R));
      tkADD: ;
      tkSUB: R := -R;
    end;
  end
  else
    expr1(R);
end;

procedure TKAParser.expr3(var R: Double); var V: Double; oldt: TToken;
begin
  expr2(R);
  while token in [tkMUL, tkDIV, tkMOD, tkPER] do begin
    oldt := token; lex; expr2(V);
    case oldt of
      tkMUL: R := R * V;
      tkDIV: R := R / V;
      tkMOD: R := Trunc(R) mod Trunc(V);
      tkPER: R := R * V / 100.0;
    end;
  end;
end;

procedure TKAParser.expr4(var R: Double); var V: Double; oldt: TToken;
begin
  expr3(R);
  while token in [tkADD, tkSUB] do begin
    oldt := token; lex; expr3(V);
    case oldt of
      tkADD: R := R + V;
      tkSUB: R := R - V;
    end;
  end;
end;

procedure TKAParser.expr5(var R: Double); var V: Double; oldt: TToken;
begin
  expr4(R);
  while token in [tkLT, tkLE, tkEQ, tkNE, tkGE, tkGT] do begin
    oldt := token; lex; expr4(V);
    case oldt of
      tkLT: R := tofloat(R < V);
      tkLE: R := tofloat(R <= V);
      tkEQ: R := tofloat(R = V);
      tkNE: R := tofloat(R <> V);
      tkGE: R := tofloat(R >= V);
      tkGT: R := tofloat(R > V);
    end;
  end;
end;

procedure TKAParser.expr6(var R: Double); var V: Double; oldt: TToken;
begin
  expr5(R);
  while token in [tkOR, tkXOR, tkAND] do begin
    oldt := token; lex; expr5(V);
    case oldt of
      tkOR : R := Trunc(R) or  Trunc(V);
      tkAND: R := Trunc(R) and Trunc(V);
      tkXOR: R := Trunc(R) xor Trunc(V);
    end;
  end;
end;

procedure TKAParser.start(var R: Double);
begin
  expr6(R);
  while (token = tkSEMICOLON) do begin lex; expr6(R); end;
  if not (token = tkEOF) then RaiseError(SSyntaxError);
end;


procedure TKAParser.StrTerm(var R: String);
var
  S: String;
  P1, P2: PChar;
  ParamStr: String;
  ParamList: TStringList;
  Ctr: Integer;
begin
  case token of
    tkString:
      begin
        // Strip out the enclosing commas
        R := Copy(svalue, 2, Length(svalue) - 1);
        lex;
      end;
    tkLBrace:
      begin
        lex;
        ExpStr(R);
        if (token = tkRBrace) then
          lex
        else
          RaiseError(SSyntaxError);
      end;
    tkIDENT:
      begin
        S := UpperCase(svalue);
        lex;
        if token = tkLBRACE then
        begin
          // Special Functions either use non string parameters or have
          // more than one paramenter
          // We call ExecFunc passing it the name of the function and
          // the parameters in a stringlist.
          if IsSpecialFunction(S) then
          begin
            // Extract the parameter(s) string
            P1 := Ptr;
            Ctr := 1;
            while (P1^ <> #0) do
            begin
              if P1^ = '(' then
                Inc(Ctr)
              else if P1^ = ')' then
                Dec(Ctr);
              if Ctr = 0 then
                break
              else
                Inc(P1);
            end;
            if (P1^ <> ')') then
              RaiseError(SFunctionError+' "'+s+'".');
            SetLength(ParamStr, P1 - Ptr);
            StrLCopy(PChar(ParamStr), Ptr, P1 - Ptr);
            // Set Ptr to one past the brace
            Ptr := P1 + 1;
            ParamList := TStringList.Create;
            try
              // Parse the parameters
              P1 := PChar(ParamStr);
              P2 := PChar(ParamStr);
              Ctr := 0;
              while (P1^ <> #0) do
              begin
                if P1^ = '(' then
                  Inc(Ctr)
                else  if P1^ = ')' then
                  Dec(Ctr);
                if (P1^ = ',') and (Ctr = 0) then
                begin
                  ParamList.Add(Trim(Copy(ParamStr, P2 - PChar(ParamStr) + 1, P1 - P2)));
                  P2 := P1 + 1;
                end;
                Inc(P1);
              end;
              ParamList.Add(Trim(Copy(ParamStr, P2 - PChar(ParamStr) + 1, P1 - P2)));
              R := ExecStrFunc(s, ParamList);
            finally
              ParamList.Free;
            end;
            lex;
          end
          else
          begin
            lex;
            ExpStr(R);
            if (token = tkRBRACE) then lex
              else RaiseError(SFunctionError+' "' + s + '".');
            if not StrCalcProc(ctFunction, s, R)
              then RaiseError(SFunctionError+' "'+s+'".');
          end;
        end
        else if (token = tkAssign) then
        begin
          lex;
          ExpStr(R);
          if not StrCalcProc(ctSetValue, S, R) then
            RaiseError(SFunctionError + ' "' + S + '".');
        end
        else if not StrCalcProc(ctGetValue, S, R) then
            RaiseError(SFunctionError + ' "' + S + '".');
      end;
    else
      RaiseError(SSyntaxError);
  end;
end;

procedure TKAParser.ExpStr(var R: String);
var
  V: String;
begin
  StrTerm(R);
  while token = tkAdd do
  begin
    lex;
    StrTerm(V);
    R := R + V;
  end;
end;

procedure TKAParser.StrStart(var R: String);
begin
  ExpStr(R);
  while (token = tkSEMICOLON) do
  begin
    lex; ExpStr(R);
  end;
  if not (token = tkEOF) then RaiseError(SSyntaxError);
end;

function TKAParser.Calculate(const Formula: String;
  var R: Double; Proc: TCalcCBProc): Boolean;
begin
  Result := FALSE;
  if (@Proc = Nil) then
    CalcProc := DefCalcProc
  else
    CalcProc := Proc;
  ptr := PChar(Formula);
  lineno := 1;
  lex;
  start(R);
  Result := TRUE;
end;

function TKAParser.StrCalculate(const Formula: String;
  var R: String; Proc: TCalcCBStrProc): Boolean;
begin
  Result := FALSE;
  if (@Proc = Nil) then
    StrCalcProc := DefStrCalcProc
  else
    StrCalcProc := Proc;
  ptr := PChar(Formula);
  lineno := 1;
  lex;
  StrStart(R);
  Result := TRUE;
end;

constructor TKAParser.Create(AOwner: TComponent);
begin
  {$ifdef CALCTEST}
  AssignFile(T, 'CalcTest.dat');
  Rewrite(T);
  Append(T);
  {$endif}
  {$ifdef friendlymode}
  AssignFile(T2, 'FM' + IntToStr(Random(10000)) + '.dat');
  Rewrite(T2);
  Append(T2);
  {$endif}
  inherited Create(AOwner);
  FVars := TList.Create;
  FStrVars := TList.Create;
  FFormulae := TList.Create;
  FSpecialFunctions := TStringList.Create;
  FExpCache := TList.Create;
  FRecFormula := TList.Create;
  // vk:10/03/99
  FEvalList := TList.Create;
  // Methods that return a double value but can use non double params.
  with FSpecialFunctions do
  begin
    Add('IF');
    Add('EMPTY');
    Add('LEN');
    Add('AND');
    Add('OR');
    Add('CONCATENATE');
    Add('REPL');
    Add('LEFT');
    Add('RIGHT');
    Add('SUBSTR');
    Add('COMPARE');
    Add('ROUND');
    Add('ISVARNA');
    Add('ISSTRVARNA');
    Add('ISFORMULANA');
    Add('NOT');
    //vk:10/03/99
    Add('EVALUATE');
  end;
  FDefaultStrVar := False;
  FDefaultVar := False;
  FDefaultStrVarAs := '';
  FDefaultVarAs := 1;
  FMaxExpCache := 100;

end;

destructor TKAParser.Destroy;
var
  I: Integer;
begin
  {$ifdef CALCTEST}
    CloseFile(T);
  {$endif}
  {$ifdef friendlymode}
    WriteLn(T2, 'Total Variables : ' + IntToStr(VarCount));
    WriteLn(T2, 'Total String Variables : ' + IntToStr(StrVarCount));
    Flush(T2);
    CloseFile(T2);
  {$endif}
  DeleteFormulae;
  DeleteVars;
  DeleteStrVars;
  DeleteEvals;
  FVars.Free;
  FStrVars.Free;
  FFormulae.Free;
  FSpecialFunctions.Free;
  FRecFormula.Free;
  FEvalList.Free;
  for I := 0 to FExpCache.Count - 1 do
    Dispose(PExpVal(FExpCache[I]));
  FExpCache.Free;
  inherited Destroy;
end;

procedure TKAParser.SetVar(const Name: String; value: Double);
var
  i: SmallInt;
  V: PNamedVar;
begin
  V := nil;
  i := 0;
  while (i < FVars.Count) do begin
    V := FVars[i];
    if CompareStr(V^.Name, UpperCase(Name)) = 0 then Break;
    Inc(i);
  end;
  if (i >= FVars.Count) then begin
    New(V);
    V^.Name := UpperCase(Name);
    V^.IsNA := False ;
    V^.Dep := TList.Create;
    FVars.Add(V);
  end;
  if Assigned(V) then
  begin
    V^.Value := Value;
    for I := 0 to V^.Dep.Count - 1 do
      TFormula(V^.Dep[I]).FValid := False;
  end;
  // Ivalidate and destroy the cache.
  // We kill the entire cache. The complextity of a selective killing algorithm
  // probably outweigh the benifits. A simiple POS search with the variable name
  // will not do since we could leave out the formulas that depend on the variable.
  for I := FExpCache.Count - 1 downto 0 do
  begin
    Dispose(PExpVal(FExpCache[I]));
    FExpCache.Delete(I);
  end;
end;

procedure TKAParser.SetStrVar(const Name, Value: String);
var
  i: SmallInt;
  V: PNamedStrVar;
begin
  V := nil;
  i := 0;
  while (i < FStrVars.Count) do begin
    V := FStrVars[i];
    if CompareStr(V^.Name, UpperCase(Name)) = 0 then Break;
    Inc(i);
  end;
  if (i >= FStrVars.Count) then begin
    New(V);
    V^.Name := UpperCase(Name);
    V^.IsNA := False ;
    V^.Dep := TList.Create;
    FStrVars.Add(V);
  end;
  if Assigned(V) then
  begin
    V^.Value := Value;
  // Ivalidate all associated formulae
    for I := 0 to V^.Dep.Count - 1 do
      TFormula(V^.Dep[I]).FValid := False;
  end;
  // Ivalidate and destroy the cache
  // We kill the entire cache. The complextity of a selective killing algorithm
  // probably outweigh the benifits. A simiple POS search with the variable name
  // will not do since we could leave out the formulas that depend on the variable.
  for I := FExpCache.Count - 1 downto 0 do
  begin
    Dispose(PExpVal(FExpCache[I]));
    FExpCache.Delete(I);
  end;

end;

function TKAParser._GetVar(const Name: String): Double;
var
  i: SmallInt;
  V: PNamedVar;
begin
  for i := 0 to FVars.Count-1 do begin
    V := FVars[i];
    if CompareStr(V^.Name, Name) = 0 then begin
      Result := V^.Value;
      Exit;
    end;
  end;
  raise Ecalculate.Create(SFunctionError+' "'+name+'".');
end;

function TKAParser.GetVar(const Name: String): Double;
begin
  {$ifdef demo}
  if Random(10) = 7 then
    Nag;
  {$endif}
  Result :=  _GetVar(UpperCase(Name));
end;

function TKAParser._GetStrVar(const Name: String): String;
var
  i: SmallInt;
  V: PNamedStrVar;
begin
  for i := 0 to FStrVars.Count-1 do begin
    V := FStrVars[i];
    if CompareStr(V^.Name, Name) = 0 then begin
      Result := V^.Value;
      Exit;
    end;
  end;
  raise Ecalculate.Create(SFunctionError+' "'+name+'".');
end;

function TKAParser.GetStrVar(const Name: String): String;
begin
  Result := _GetStrVar(UpperCase(Name));
end;

function TKAParser.GetResult: Double;
var
   I: Integer;
   P: PExpVal;
   InCache: Boolean;
begin
  InCache := False;
  if FMaxExpCache > 0 then
    for I := FExpCache.Count - 1 downto 0 do
      if PExpVal(FExpCache[I])^.Exp = FExpression then
      begin
        if not FRecording then
        begin
          Result := PExpVal(FExpCache[I])^.Val;
          {$ifdef CALCTEST}
          WriteLn(T, IntToStr(Line) + ' : ' + FExpression + ' - From Cache');
          Inc(Line);
          Flush(T);
          {$endif}
          Exit;
        end
        else
        begin
          InCache := True;
          break;
        end;
      end;
  {$ifdef CALCTEST}
  WriteLn(T, IntToStr(Line) + ' : ' + FExpression + ' : ' + IntToStr(GetTickCount));
  Inc(Line);
  Flush(T);
  {$endif}
  calculate(FExpression, Result, IdentValue);
  {$ifdef CALCTEST}
  WriteLn(T, IntToStr(GetTickCount));
  Flush(T);
  {$endif}
  if InCache then
    Exit;
  // Add the expression and result to the cache
  if FMaxExpCache > 0 then
  begin
    New(P);
    P^.Exp := FExpression;
    P^.Val := Result;
    FExpCache.Add(P);
    if FExpCache.Count > FMaxExpCache  then
    begin
      Dispose(PExpVal(FExpCache[0]));
      FExpCache[0] := nil;
      FExpCache.Delete(0);
    end;
  end;
end;

function TKAParser.IdentValue(ctype: TCalcType;
  const Name: String; var Res: Double): Boolean;
 var
//  SavedContext: PContext;
  I : Integer ;
  Handled: Boolean;
begin

  Result := False;
  try
    Result := DefCalcProc(ctype, name, Res);
  except
  end;

  if Result then Exit;
  Result := TRUE;

  case ctype of
    ctGetValue:
      try

        Res := _GetVar(Name);
        if FRecording then
        begin
          // The flage DummyCalc is set to avoid a div by zero in
          // an if expression. It is essential for an IF exression
          // that returns a zero incase the denominator is zero.
          if FDummyCalc then
            Res := 1;
          RecordVar(Name);
        end;
      except
        On ECalculate do
        try
          Res := GetFormulaObj(Name, I).Value;
        except
          On E:ECalculate do
          begin
            {$ifdef friendlymode}
            WriteLn(T2, 'Variable ' + Name + ' assigned default value');
            Flush(T2);
            if not DefaultVar then
            begin
              Vars[Name] := 1;
              Res := 1;
            end
            else
            begin
              Vars[Name] := DefaultVarAs;
              Res := DefaultVarAs;
            end;
            if FRecording then
              for I := 0 to FRecFormula.Count - 1 do
                WriteLn(T2, TFormula(FRecFormula[I]).Name, ', ',
                  TFormula(FRecFormula[I]).Exp);
            WriteLn(T2, ' ');
            Flush(T2);
            {$endif}
            // See if the calling code has the value of the identifier
            // It is not a good idea to have variables that participate
            // in formula definitions to be assigned values in the calling
            // code since it will compromise the working of dependency
            // lists
            { vk: 10/23/99 }
            if Assigned(FOnNoIdent) then
            begin
              Handled := False;
              FOnNoIdent(Self, ctGetValue, Name, Res, Handled);
              if Not Handled then
              begin
                // Pretty hopeless situation...
                FRecFormula.Clear;
                raise;
              end;
            end
            else
            begin
              // Pretty hopeless situation...
              FRecFormula.Clear;
              raise;
            end;
          end;
        end;
      end;
    ctSetValue: Vars[Name] := Res;
    ctFunction:
      if Assigned(FOnNoIdent) then
      begin
        Handled := False;
        FOnNoIdent(Self, ctGetValue, Name, Res, Handled);
        Result := Handled;
        if not Result then
          RaiseError(SFunctionError + ' "' + Name + '".');
      end
      else
      begin
        RaiseError(SFunctionError + ' "' + Name + '".');
        Result := FALSE;
      end;
  end;
end;

function TKAParser.IdentStrValue(ctype: TCalcType;
  const Name: String; var Res: String): Boolean;
var
  I: Integer;
  Handled: Boolean;
begin
  Result := False;
  try
    Result := DefStrCalcProc(ctype, name, Res);
  except
  end;
  if Result then Exit;

  Result := TRUE;
  case ctype of
    ctGetValue:
      try
        Res := _GetStrVar(Name);
        if FRecording then
          RecordStrVar(Name);
      except
        On ECalculate do
        try
          Res := GetFormulaObj(Name, I).StrValue;
        except
          On E:ECalculate do
          begin
            {$ifdef friendlymode}
            WriteLn(T2, 'String Variable ' + Name + ' assigned default value');
            if not DefaultVar then
            begin
              StrVars[Name] := '';
              Res := '';
            end
            else
            begin
              StrVars[Name] := DefaultStrVarAs;
              Res := DefaultStrVarAs;
            end;
            if FRecording then
              for I := 0 to FRecFormula.Count - 1 do
                WriteLn(T2, TFormula(FRecFormula[I]).Name, ', ',
                  TFormula(FRecFormula[I]).Exp);
            WriteLn(T2, ' ');
            Flush(T2);
            {$endif}
            // See if the calling code has the value of the identifier
            // It is not a good idea to have variables that participate
            // in formula definitions to be assigned values in the calling
            // code since it will compromise the working of dependency
            // lists
            if Assigned(FOnNoStrIdent) then
            begin
              Handled := False;
              FOnNoStrIdent(Self, ctGetValue, Name, Res, Handled);
              if not Handled then
              begin
                FRecFormula.Clear;
                raise;
              end;
            end
            else
            begin
              FRecFormula.Clear;
              raise;
            end;
          end;
        end;
      end;
    ctSetValue: StrVars[Name] := Res;
    ctFunction:
      if Assigned(FOnNoStrIdent) then
      begin
        Handled := False;
        FOnNoStrIdent(Self, ctFunction, Name, Res, Handled);
        Result := Handled;
        if not Result then
          RaiseError(SFunctionError + ' "' + Name + '".');
      end
      else
      begin
        Result := FALSE;
        RaiseError(SFunctionError + ' "' + Name + '".');
      end;
  end;
end;

function TKAParser.NameOfVar(Index: Word): String;
begin
  Result := PNamedVar(FVars[Index])^.Name;
end;

function TKAParser.NameOfStrVar(Index: Word): String;
begin
  Result := PNamedStrVar(FStrVars[Index])^.Name;
end;

function TKAParser.NameOfFormula(Index: Word): String;
begin
  Result := TFormula(FFormulae[Index]).Name;
end;

// Sledgehammer delete! To be called only from Destroy
procedure TKAParser.DeleteVars;
var
  i: Integer;
  V: PNamedVar;
begin
  for i := FVars.Count-1 downto 0 do begin
    V := FVars[i];
    V^.Dep.Free;
    Dispose(V);
    FVars[i] := Nil;
  end;
  FVars.Clear;
end;

// Sledgehammer delete! To be called only from Destroy
procedure TKAParser.DeleteStrVars;
var
  i: Integer;
  V: PNamedStrVar;
begin
  for i := FStrVars.Count-1 downto 0 do begin
    V := FStrVars[i];
    V^.Dep.Free;
    Dispose(V);
    FStrVars[i] := Nil;
  end;
  FStrVars.Clear;
end;

// Sledgehammer delete! To be called only from Destroy
procedure TKAParser.DeleteFormulae;
var
  i: Integer;
  V: TFormula;
begin
  for i := FFormulae.Count-1 downto 0 do begin
    V := FFormulae[i];
    V.Free;
    FFormulae[i] := Nil;
  end;
  FFormulae.Clear;
end;

procedure TKAParser.DeleteEvals;
var
  i: Integer;
  V: PEvalResult;
begin
  for i := FEvalList.Count-1 downto 0 do begin
    V := FEvalList[i];
    Dispose(V);
    FEvalList[i] := Nil;
  end;
  FEvalList.Clear;
end;

// Property access method
function TKAParser.GetStrResult: String;
begin
  StrCalculate(FExpression, Result, IdentStrValue);
end;

function TKAParser.GetVarCount: Integer;
begin
  Result := FVars.Count;
end;


function TKAParser.GetStrVarCount: Integer;
begin
  Result := FStrVars.Count;
end;

function TKAParser.GetFormulaeCount: Integer;
begin
  Result := FFormulae.Count;
end;

function TKAParser.GetFormula(const Name: String): String;
var
  I: Integer;
  V: TFormula;
begin
  for I := 0 to FFormulae.Count - 1 do
  begin
    V := FFormulae[I];
    if CompareStr(V.Name, UpperCase(Name)) = 0 then
    begin
      Result := V.Exp;
      Exit;
    end;
  end;
  RaiseError(SFunctionError + ' "' + Name + '".');
end;

procedure TKAParser.SetFormula(const Name, Value: String);
var
  i: SmallInt;
  V: TFormula;
//  SavedContext: PContext;
begin
  V := nil;
  i := 0;
  while (i < FFormulae.Count) do begin
    V := FFormulae[i];
    if CompareStr(V.Name, UpperCase(Name)) = 0 then
    begin
      DelFormDep(V);
      Break;
    end;
    Inc(i);
  end;
  if (i = FFormulae.Count) then begin
    V := TFormula.Create(Self);
    V.Name := UpperCase(Name);
    V.IsNA := False;
    FFormulae.Add(V);
  end;
  if Assigned(V) then
  begin
    V.FEvaluated := False;
    V.FValid := False;
    V.Exp := Value;
  end;
end;



procedure TKAParser.SetVarNA(const Name: String; Val: Boolean);
var
  I: Integer;
  P: Pointer;
begin
  for I := 0 to FVars.Count - 1 do
  begin
    P := FVars[I];
    if CompareStr(PNamedVar(P)^.Name, UpperCase(Name)) = 0 then
    begin
      PNamedVar(P)^.IsNA := Val;
      Exit;
    end;
  end;
end;

procedure TKAParser.SetStrVarNA(const Name: String; Val: Boolean);
var
  I: Integer;
  P: Pointer;
begin
  for I := 0 to FStrVars.Count - 1 do
  begin
    P := FStrVars[I];
    if CompareStr(PNamedStrVar(P)^.Name, UpperCase(Name)) = 0 then
    begin
      PNamedStrVar(P)^.IsNA := Val;
      Exit;
    end;
  end;
end;

procedure TKAParser.SetFormulaNA(const Name: String; Val: Boolean);
var
  I: Integer;
  P: Pointer;
begin
  for I := 0 to FFormulae.Count - 1 do
  begin
    P := FFormulae[I];
    if CompareStr(TFormula(P).Name, UpperCase(Name)) = 0 then
    begin
      TFormula(P).IsNA := Val;
      Exit;
    end;
  end;
  RaiseError(SFunctionError + ' "' + Name + '".');
end;


function TKAParser.IsVarNA(const Name: String): Boolean;
var
  I: Integer;
  P: Pointer;
begin
  Result := False;
  for I := 0 to FVars.Count - 1 do
  begin
    P := FVars[I];
    if CompareStr(PNamedVar(P)^.Name, UpperCase(Name)) = 0 then
    begin
      if FRecording then
        RecordVar(Name);
      Result := PNamedVar(P)^.IsNA;
      Exit;
    end;
  end;
  RaiseError(SFunctionError + ' "' + Name + '".');
end;

function TKAParser.IsStrVarNA(const Name: String): Boolean;
var
  I: Integer;
  P: Pointer;
begin
  Result := False;
  for I := 0 to FStrVars.Count - 1 do
  begin
    P := FStrVars[I];
    if CompareStr(PNamedStrVar(P)^.Name, UpperCase(Name)) = 0 then
    begin
      if FRecording then
        RecordStrVar(Name);
      Result := PNamedStrVar(P)^.IsNA;
      Exit;
    end;
  end;
  RaiseError(SFunctionError + ' "' + Name + '".');
end;

function TKAParser.IsFormulaNA(const Name: String): Boolean;
var
  I: Integer;
  P: Pointer;
  SavedContext: PContext;
begin
  Result := False;
  for I := 0 to FFormulae.Count - 1 do
  begin
    P := FFormulae[I];
    if CompareStr(TFormula(P).Name, UpperCase(Name)) = 0 then
    begin
      if FRecording then
      begin
        SavedContext := SaveContext;
        FExpression := UpperCase(Name);
        Self.Result;
        RestoreContext(SavedContext);
      end;
      Result := TFormula(P).IsNA;
      Exit;
    end;
  end;
  RaiseError(SFunctionError + ' "' + Name + '".');
end;

procedure TKAParser.DeleteVar(const Name: String);
var
  V: PNamedVar;
  I: Integer;
begin
  V := GetVarObj(Name, I);
  if V^.Dep.Count > 0 then
    RaiseError(SCannotDelete);
  V^.Dep.Free;
  Dispose(V);
  FVars.Delete(I);
  Exit;
end;

procedure TKAParser.DeleteStrVar(const Name: String);
var
  V: PNamedStrVar;
  I: Integer;
begin
  V := GetStrVarObj(Name, I);
  if V^.Dep.Count > 0 then
    RaiseError(SCannotDelete);
  V^.Dep.Free;
  Dispose(V);
  FVars.Delete(I);
  Exit;
end;

procedure TKAParser.DeleteFormula(const Name: String);
var
  I: Integer;
  V: TFormula;
begin
  V := GetFormulaObj(Name, I);
  DelFormDep(V);
  FFormulae.Delete(I);
  Exit;
end;


function TKAParser.GetFormulaObj(const Name: String; var Index: Integer): TFormula;
var
  I: Integer;
  V: TFormula;
begin
  Result := nil;
  for I := 0 to FFormulae.Count - 1 do
  begin
    V := FFormulae[I];
    if CompareStr(V.Name, UpperCase(Name)) = 0 then
    begin
      Result := V;
      Index := I;
      Exit;
    end;
  end;
  RaiseError(SFunctionError + ' "' + Name + '".');
end;

function TKAParser.GetVarObj(const Name: String; var Index: Integer): PNamedVar;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FVars.Count - 1 do
  begin
    Result := PNamedVar(FVars[I]);
    if CompareStr(Result.Name, UpperCase(Name)) = 0 then
    begin
      Index := I;
      Exit;
    end;
  end;
  RaiseError(SFunctionError + ' "' + Name + '".');
end;

function TKAParser.GetStrVarObj(const Name: String; var Index: Integer): PNamedStrVar;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to FStrVars.Count - 1 do
  begin
    Result := PNamedStrVar(FStrVars[I]);
    if CompareStr(Result.Name, UpperCase(Name)) = 0 then
    begin
      Index := I;
      Exit;
    end;
  end;
  RaiseError(SFunctionError + ' "' + Name + '".');
end;


// Mechanism for building dependency lists. Adds the variable passed as a
// parameter to the dependency list(s) of the formula(e) being parsed.
procedure TKAParser.RecordVar(const Name: String);
var
  I, J, K: Integer;
  V: PNamedVar;
begin
  V := GetVarObj(Name, I);
  // For each formula that is being currently evaluated
  for J := 0 to FRecFormula.Count - 1 do
  begin
    // if the variable already has this formula in its dependency list
    // then break
    for K := 0 to V^.Dep.Count - 1 do
      if TFormula(V^.Dep[K]).Name = TFormula(FRecFormula[J]).Name then
        break;
    // Otherwise, add it.
    if K >= V^.Dep.Count then
      V^.Dep.Add(FRecFormula[J]);
    // The formula that has been added to the variable's dependency list must
    // in turn must have the variable in its dependency list!
    // If the variable is already there in the formula depency list
    // then break
    for K := 0 to TFormula(FRecFormula[J]).FDep.Count - 1 do
      if TFormula(FRecFormula[J]).FDep[K] = V then
        break;
    // Otherwise, add it.
    if (K >= TFormula(FRecFormula[J]).FDep.Count) then
      TFormula(FRecFormula[J]).FDep.Add(V);
  end;
end;

procedure TKAParser.RecordStrVar(const Name: String);
var
  I, J, K: Integer;
  V: PNamedStrVar;
begin
  V := GetStrVarObj(Name, I);
  // For each formula that is being currently evaluated
  for J := 0 to FRecFormula.Count - 1 do
  begin
    for K := 0 to V^.Dep.Count - 1 do
      if TFormula(V^.Dep[K]).Name = TFormula(FRecFormula[J]).Name then
        break;
    // if the formula is not already in the variable's dep list add it.
    if K >= V^.Dep.Count then
      V^.Dep.Add(FRecFormula[J]);
    for K := 0 to TFormula(FRecFormula[J]).FStrDep.Count - 1 do
      if TFormula(FRecFormula[J]).FStrDep[K] = V then
        break;
    // if the formula does not have the variable in its string dep
    // list add it.
    if  (K >= TFormula(FRecFormula[J]).FStrDep.Count) then
      TFormula(FRecFormula[J]).FStrDep.Add(V);
  end;
end;

procedure TKAParser.DelFormDep(Formula: TFormula);
var
  I, J: Integer;
begin
  for I := Formula.FDep.Count - 1 downto 0 do
    for J := PNamedVar(Formula.FDep[I]).Dep.Count - 1 downto 0 do
      if PNamedVar(Formula.FDep[I])^.Dep[J] = Formula then
        PNamedVar(Formula.FDep[I])^.Dep.Delete(J);
  Formula.FDep.Clear;

  for I := Formula.FStrDep.Count - 1 downto 0 do
    for J := PNamedStrVar(Formula.FDep[I]).Dep.Count - 1 downto 0 do
      if PNamedStrVar(Formula.FStrDep[I])^.Dep[J] = Formula then
        PNamedStrVar(Formula.FStrDep[I])^.Dep.Delete(J);
  Formula.FStrDep.Clear;

end;

{$ifdef CALCTEST}
procedure TKAParser.GetFormDep(const Name: String; Dep: TStringList);
var
  Form: TFormula;
  DepCount: Integer;
  I,K: Integer;
  VarType: String;

begin
  Form := nil;
  DepCount := 0;
  try
    Form := GetFormulaObj(Name, I);
  except
  end;
  if Form <> nil then
  begin
    for I := 0 to Form.FDep.Count - 1 do
      Dep.Add(PNamedVar(Form.FDep[I])^.Name);
    if Dep.Count > 0 then
    begin
      VarType := 'Double Formula';
      DepCount := Dep.Count;
    end
    else
    begin
      for I := 0 to Form.FStrDep.Count - 1 do
        Dep.Add(PNamedStrVar(Form.FStrDep[I])^.Name);
      if Dep.Count > 0 then
      begin
        VarType := 'String Formula';
        DepCount := Dep.Count;
      end;
    end;
  end
  else
  begin
    for I := 0 to FVars.Count - 1 do
      if PNamedVar(FVars[I])^.Name = Name then
      begin
        for K := 0 to PNamedVar(FVars[I]).Dep.Count - 1 do
          Dep.Add(TFormula(PNamedVar(FVars[I]).Dep[K]).Name);
        Break;
      end;
    if Dep.Count > 0 then
    begin
      VarType := 'Double Variable';
      DepCount := Dep.Count;
    end
    else
    begin
      for I := 0 to FStrVars.Count - 1 do
        if PNamedStrVar(FStrVars[I])^.Name = Name then
        begin
          for K := 0 to PNamedStrVar(FStrVars[I]).Dep.Count - 1 do
            Dep.Add(TFormula(PNamedStrVar(FStrVars[I]).Dep[K]).Name);
          Break;
        end;
      if Dep.Count > 0 then
      begin
        VarType := 'String Variable';
        DepCount := Dep.Count;
      end;
    end;
  end;
  if DepCount = 0 then
  begin
    Dep.Add('No such Variable / Formula');
    Exit;
  end;
  Dep.Add('Type : ' + VarType);
  if Assigned(Form) then
  begin
    Dep.Add('Exp : ' + Form.Exp);
    if Form.FEvaluated then
      Dep.Add('Formula has been evaluated.')
    else
      Dep.Add('Formula yet to be evaluated.');
    if Form.FValid then
      Dep.Add('Formula is valid.')
    else
      Dep.Add('Formula is Invalid.');
  end;
  Dep.Add('Count of Dep : ' + IntToStr(DepCount));
end;
{$endif}

procedure TKAParser.GetFormulaVarDep(const Name: String; Dep: TStringList);
var
  Form: TFormula;
  I: Integer;

begin
  Form := GetFormulaObj(Name, I);
  if not Form.FEvaluated then
  try
    Form.Value;
  except
    Form.StrValue;
  end;
  for I := 0 to Form.FDep.Count - 1 do
    Dep.Add(PNamedVar(Form.FDep[I])^.Name)
end;

procedure TKAParser.GetFormulaStrVarDep(const Name: String; Dep: TStringList);
var
  Form: TFormula;
  I: Integer;

begin
  Form := GetFormulaObj(Name, I);
  if not Form.FEvaluated then
  try
    Form.Value;
  except
    Form.StrValue;
  end;
  for I := 0 to Form.FStrDep.Count - 1 do
    Dep.Add(PNamedStrVar(Form.FStrDep[I])^.Name)
end;

procedure TKAParser.GetFormulaFormDep(const Name: String; Dep: TStringList);
var
  Form: TFormula;
  I: Integer;

begin
  Form := GetFormulaObj(Name, I);
  if not Form.FEvaluated then
    Form.Value;
  for I := 0 to Form.FFormDep.Count - 1 do
      Dep.Add(TFormula(Form.FFormDep[I]).Name)
end;


procedure TKAParser.GetVarDep(const Name: String; Dep: TStringList);
var
  I, K: Integer;
begin
  {$ifdef demo}
  if Random(20) = 7 then
    Nag;
  {$endif}
  for I := 0 to FVars.Count - 1 do
    if PNamedVar(FVars[I])^.Name = Name then
    begin
      for K := 0 to PNamedVar(FVars[I]).Dep.Count - 1 do
        Dep.Add(TFormula(PNamedVar(FVars[I]).Dep[K]).Name);
      Break;
    end;
end;

procedure TKAParser.GetStrVarDep(const Name: String; Dep: TStringList);
var
  I, K: Integer;
begin
  GetStrVarObj(Name, I);
  for K := 0 to PNamedStrVar(FStrVars[I]).Dep.Count - 1 do
    Dep.Add(TFormula(PNamedStrVar(FStrVars[I]).Dep[K]).Name);
end;

function TKAParser.GetFormulaValue(const Name: String): Double;
var
  I: Integer;
begin
  Result := GetFormulaObj(Name, I).Value;
end;

function TKAParser.GetFormulaStrValue(const Name: String): String;
var
  I: Integer;
begin
  Result := GetFormulaObj(Name, I).StrValue;
end;

{$ifdef demo}
procedure TKAParser.Nag;
begin
  ShowMessage('Demo Version TKAParser Ver 1.0'#10#13 +
    'To register contact Vijainder K Thakur at vkt@pobox.com');
end;
{$endif}
//vk:10/03/99
procedure TKAParser.AddEvaluation(LogOp: String; Val, Res: Double);
var
  I: Integer;
  V: PEvalResult;
begin
  For I := 0 to FEvalList.Count - 1 do
  begin
    V := FEvalList[I];
    if (V^.Val = Val) and (V^.LogOp = LogOp) then
    begin
      if V^.Res <> Res then
        V^.Res := Res;
      Exit;
    end;
  end;
  New(V);
  V^.LogOp := LogOp;
  V^.Val := Val;
  V^.Res := Res;
  FEvalList.Add(V);
end;

function TKAParser.GetEvalVal(Eval: Double): Double;
var
  I: Integer;
  V: PEvalResult;
begin
  For I := 0 to FEvalList.Count - 1 do
  begin
    V := FEvalList[I];
    FExpression := FloatToStr(Eval) + V^.LogOp + FloatToStr(V^.Val);
    if Self.Result >= 1.0 then
    begin
      GetEvalVal := V^.Res;
      Exit;
    end;
  end;
  GetEvalVal := Eval;
end;

procedure TKAParser.RemoveEvaluation(LogOp: String; Val: Double);
var
  I: Integer;
  V: PEvalResult;
begin
  For I := 0 to FEvalList.Count - 1 do
  begin
    V := FEvalList[I];
    if (V^.Val = Val) and (V^.LogOp = LogOp) then
    begin
      Dispose(V);
      FEvalList.Delete(I);
      Exit;
    end;
  end;
end;

end.

