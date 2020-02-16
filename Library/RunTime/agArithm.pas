{*******************************************************}
{                                                       }
{       Alex Ghost Library                              }
{                                                       }
{       Copyright (c) 1999,2000 Alexey Popov            }
{                                                       }
{*******************************************************}

{$I AG.INC}

unit agArithm;

interface

uses Windows;

{$IFNDEF D4}
type
  PInt64 = ^Int64;
  Int64 = packed record
    Lo,Hi: dword;
  end;
{$ENDIF}


// max, min

function MaxInt(const Values: array of Integer): Integer;
function MinInt(const Values: array of Integer): Integer;

function MaxInt64(const Values: array of Int64): Int64;
function MinInt64(const Values: array of Int64): Int64;

function MaxFloat(const Values: array of Extended): Extended;
function MinFloat(const Values: array of Extended): Extended;

function MaxDateTime(const Values: array of TDateTime): TDateTime;
function MinDateTime(const Values: array of TDateTime): TDateTime;

function MaxVar(const Values: array of Variant): Variant;
function MinVar(const Values: array of Variant): Variant;

// swap
procedure SwapInt(var A, B: Integer);
procedure SwapInt64(var A, B: Int64);
procedure SwapFloat(var A, B: extended);
procedure SwapDateTime(var A, B: TDateTime);
procedure SwapVar(var A, B: Variant);

{$IFDEF D4}
function Sgn(Number: integer): integer; overload;
function Sgn(Number: extended): integer; overload;
{$ELSE}
function Sgn(Number: extended): integer;
{$ENDIF}

function iif(Expr: boolean; v1,v2: variant): variant;

implementation

function MaxInt(const Values: array of Integer): Integer;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] > Result then Result := Values[I];
end;

function MinInt(const Values: array of Integer): Integer;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;

function MaxInt64(const Values: array of Int64): Int64;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
{$IFDEF D4}
    if Values[I] > Result then Result := Values[I];
{$ELSE}
    if (Values[I].Hi > Result.Hi) or
      ((Values[I].Hi = Result.Hi) and (Values[I].Lo > Result.Lo))
      then Result := Values[I];
{$ENDIF}
end;

function MinInt64(const Values: array of Int64): Int64;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
{$IFDEF D4}
    if Values[I] < Result then Result := Values[I];
{$ELSE}
    if (Values[I].Hi < Result.Hi) or
      ((Values[I].Hi = Result.Hi) and (Values[I].Lo < Result.Lo))
      then Result := Values[I];
{$ENDIF}
end;

function MaxFloat(const Values: array of Extended): Extended;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] > Result then Result := Values[I];
end;

function MinFloat(const Values: array of Extended): Extended;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;

function MaxDateTime(const Values: array of TDateTime): TDateTime;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;

function MinDateTime(const Values: array of TDateTime): TDateTime;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;

function MaxVar(const Values: array of Variant): Variant;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] > Result then Result := Values[I];
end;

function MinVar(const Values: array of Variant): Variant;
var
  I: Cardinal;
begin
  Result := Values[0];
  for I := 0 to High(Values) do
    if Values[I] < Result then Result := Values[I];
end;

procedure SwapInt(var A, B: Integer);
var
  I: Integer;
begin
  I := A; A := B; B := I;
end;

procedure SwapVar(var A, B: Variant);
var
  V: Variant;
begin
  V := A; A := B; B := V;
end;

procedure SwapInt64(var A, B: Int64);
var
  I: Int64;
begin
  I := A; A := B; B := I;
end;

procedure SwapFloat(var A, B: extended);
var
  I: extended;
begin
  I := A; A := B; B := I;
end;

procedure SwapDateTime(var A, B: TDateTime);
var
  D: TDateTime;
begin
  D := A; A := B; B := D;
end;

{$IFDEF D4}
function Sgn(Number: integer): integer;
begin
  if Number > 0
    then Result:=1
    else if Number < 0 then Result:=-1 else Result:=0;
end;
{$ENDIF}

function Sgn(Number: extended): integer;
begin
  if Number > 0
    then Result:=1
    else if Number < 0 then Result:=-1 else Result:=0;
end;

function iif(Expr: boolean; v1,v2: variant): variant;
begin
  if Expr then Result:=v1 else Result:=v2;
end;

end.
