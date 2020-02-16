{*********************************************************}
{* Borland Delphi 5.0 - 7.0 Runtime Library              *}
{* Copyright © 1992-2002 by Dimka Maslov                 *}
{*  E-mail:   mainbox@endimus.com                        *}
{*  Web-site: http://endimus.com                         *}
{*                                                       *}
{****         Licensed for free distribution          ****}
{*                                                       *}
{* Last Update: Jan. 27, 2002 (Release ID: 03.1)         *}
{*********************************************************}

unit Dim;

interface

uses Windows, SysUtils, ActiveX, ShlObj, Classes, ShellAPI;

const
// Useful constants declaration

  Nul                 = 0;
  MaxWord             = $FFFF;
  MaxInteger          = $7FFFFFFF;
  MaxFloat            = 1.7e308;
  MinFloat            = 5.0e-324;
  MaxExtended         = 1.1e4932;
  MinExtended         = 9.99e-4933;
  HalfCycle           = Pi;
  FullCycle           = 2*Pi;
  Quadrant            = Pi/2;

  chNull              = #0;
  chEOT               = #4;
  chBackspace         = #8;
  chTab               = #9;
  chLF                = #10;
  chEnter             = #13;
  chShiftTab          = #15;
  chEsc               = #27;
  chFS                = #28;
  chGS                = #29;
  chRS                = #30;
  chUS                = #31;
  chSpace             = #32;
  chComma             = ',';
  chPoint             = '.';
  chQuote             = '''';
  chDoubleQuote       = '"';
  chColon             = ':';
  chEqual             = '=';
  chMore              = '>';
  chLess              = '<';
  chLast              = #255;
  chPlus              = '+';
  chMinus             = '-';

  nTrue               = Integer(True);
  nFalse              = Integer(False);
  uTrue               = cardinal(True);
  uFalse              = cardinal(False);
  lTrue               = -1;
  lFalse              = 0;

// comparison result constants
  nMore               = 1;
  nLess               = -1;
  nEqual              = 0;

// virtual-key codes aliases;
  VK_Enter            = VK_Return;
  VK_Alt              = VK_Menu;
  VK_PageUp           = VK_Prior;
  VK_PageDown         = VK_Next;
  VK_PrintScreen      = VK_SnapShot;
  VK_Ctrl             = VK_Control;

  achCR               : array [0..1] of AnsiChar = #13#10;
  wCR                 = $0A0D;

// html colors
  clAliceBlue              = $FFF8F0;
  clAntiqueWhite           = $D7EBFA;
  clAqua                   = $FFFF00;
  clAquamarine             = $D4FF7F;
  clAzure                  = $FFFFF0;
  clBeige                  = $DCF5F5;
  clBisque                 = $C4E4FF;
  clBlack                  = $000000;
  clBlanchedAlmond         = $CDEBFF;
  clBlue                   = $FF0000;
  clBlueViolet             = $E22B8A;
  clBrown                  = $2A2AA5;
  clBurlyWood              = $87B8DE;
  clCadetBlue              = $A09E5F;
  clChartreuse             = $00FF7F;
  clChocolate              = $1E6902;
  clCoral                  = $507FFF;
  clCornflowerBlue         = $ED9564;
  clCornSilk               = $DCF8FF;
  clCrimson                = $3C14DC;
  clCyan                   = $FFFF00;
  clDarkBlue               = $8B0000;
  clDarkCyan               = $8B8B00;
  clDarkGoldenrod          = $0B86B8;
  clDarkGray               = $A9A9A9;
  clDarkGreen              = $006400;
  clDarkKhaki              = $6BB7BD;
  clDarkMagenta            = $8B008B;
  clDarkOliveGreen         = $2F6B55;
  clDarkOrange             = $008CFF;
  clDarkOrchid             = $CC3299;
  clDarkRed                = $000088;
  clDarkSalmon             = $7A96E9;
  clDarkSeaGreen           = $8FBC8F;
  clDarkSlateBlue          = $8B3D48;
  clDarkSlateGray          = $4F4F2F;
  clDarkTurquoise          = $D1CE00;
  clDarkViolet             = $030094;
  clDeepPink               = $9314FF;
  clDeepSkyBlue            = $FFBF00;
  clDimGray                = $696969;
  clDodgerBlue             = $FF901E;
  clFireBrick              = $2222B2;
  clFloralWhite            = $F0FAFF;
  clForestGreen            = $228B22;
  clFuchsia                = $FF00FF;
  clGhostWhite             = $FFF8F8;
  clGainsboro              = $DCDCDC;
  clGold                   = $00D7FF;
  clGoldenrod              = $20A5DA;
  clGray                   = $808080;
  clGreen                  = $008000;
  clGreenYellow            = $2FFFAD;
  clHoneyDew               = $F0FFF0;
  clHotPink                = $B469FF;
  clIndianRed              = $5C5CCD;
  clIndigo                 = $82004B;
  clIvory                  = $F0FFFF;
  clKhaki                  = $8CE6F0;
  clLavender               = $FAE6E6;
  clLavenderBlush          = $F5F0FF;
  clLawnGreen              = $00FC7C;
  clLemonChiffon           = $CDFAFF;
  clLightBlue              = $E6D8AD;
  clLightCoral             = $8080F0;
  clLightCyan              = $FFFFE0;
  clLightGoldenrodYellow   = $D2FAFA;
  clLightGreen             = $90EE90;
  clLightGrey              = $D3D3D3;
  clLightPink              = $C1B6FF;
  clLightSalmon            = $7AA0FF;
  clLightSeaGreen          = $AAB220;
  clLightSkyBlue           = $FACE87;
  clLightSlateGray         = $998877;
  clLightSteelBlue         = $DEC4B0;
  clLightYellow            = $E0FFFF;
  clLime                   = $00FF00;
  clLimeGreen              = $32CD32;
  clLinen                  = $E6F0FA;
  clMagenta                = $FF00FF;
  clMaroon                 = $000080;
  clMediumAquamarine       = $AACD66;
  clMediumBlue             = $CD0000;
  clMediumOrchid           = $D355BA;
  clMediumPurple           = $DB7093;
  clMediumSeaGreen         = $71B33C;
  clMediumSlateBlue        = $EE687B;
  clMediumSpringGreen      = $9AFA00;
  clMediumTurquoise        = $CCD148;
  clMediumVioletRed        = $851507;
  clMidnightBlue           = $701919;
  clMintCream              = $FAFFF5;
  clMistyRose              = $E1E4FF;
  clMoccasin               = $B5E4FF;
  clNavajoWhite            = $ADDEFF;
  clNavy                   = $800000;
  clOldLace                = $E6F5FD;
  clOlive                  = $008080;
  clOliveDrab              = $238E6B;
  clOrange                 = $00A5FF;
  clOrangered              = $0045FF;
  clOrchid                 = $D670DA;
  clPaleGoldenrod          = $AAE8EE;
  clPaleGreen              = $98FB98;
  clPaleTurquoise          = $EEEEAF;
  clPaleVioletRed          = $9370DB;
  clPapayaWhip             = $D5EFFF;
  clPeachPuff              = $B9DAFF;
  clPeru                   = $3F85CD;
  clPink                   = $CBC0FF;
  clPlum                   = $DDA0DD;
  clPowderBlue             = $E6E0B0;
  clPurple                 = $800080;
  clRed                    = $0000FF;
  clRosyBrown              = $8F8FBC;
  clRoyalBlue              = $E16941;
  clSaddleBrown            = $13458B;
  clSalmon                 = $7280FA;
  clSandyBrown             = $60A4F4;
  clSeaGreen               = $578B2E;
  clSeaShell               = $EEF5FF;
  clSienna                 = $2D52A0;
  clSilver                 = $C0C0C0;
  clSkyBlue                = $EBCE87;
  clSlateBlue              = $CD5A6A;
  clSlateGray              = $908070;
  clSnow                   = $FAFAFF;
  clSpringGreen            = $7FFF00;
  clSteelBlue              = $B48246;
  clTan                    = $8CB4D2;
  clTeal                   = $808000;
  clThistle                = $D8BFD8;
  clTomato                 = $4763FF;
  clTurquoise              = $D0E040;
  clViolet                 = $EE82EE;
  clWheat                  = $B3DEF5;
  clWhite                  = $FFFFFF;
  clWhiteSmoke             = $F5F5F5;
  clYellow                 = $00FFFF;
  clYellowGreen            = $32CD9A;

  clDimGreen               = $3C8000;


type
  PString=^TString;
  TString=type AnsiString;

  PAnsiStr=^TAnsiStr;
  TAnsiStr=array[0..259] of AnsiChar;

  PWideStr=^TWideStr;
  TWideStr=array[0..259] of WideChar;

  PShortStr=^TShortStr;
  TShortStr=type ShortString;

  PSetChar=^TSetChar;
  TSetChar=set of AnsiChar;

  PWideInt=^TWideInt;
  TWideInt=type Int64;

  TColorChannel = (ccRed, ccGreen, ccBlue, ccAlpha);
  TColorChannels = set of TColorChannel;

  PBoolean = ^Boolean;

{ The Hole function prevents allocating some variables
  inside CPU registers due an optimization }
function Hole(var A):Integer;

{ The Sync procedure prevents flickering while repainting windows.
 Provided for backward compatibility.
 Use TWinControl.DoubleBuffered property instead calling this procedure.
 This function has no action under Windows NT }
procedure Sync;

{ The KeyPressed function returns True if specified as VKey key is being pressed or
 False otherwise.  Use VK_xxx constants to specify required key }
function KeyPressed(VKey: Integer): LongBool;

{ The ScanCode function returns the scan code of a pressed or released key.
 lKeyData parameters must contain the LParam parameter of received WM_KEYDOWN or
 WM_KEYUP messages }
function ScanCode(lKeyData: Integer): Byte;

{ The RightKey function returns TRUE if received WM_KEYDOWN or WM_KEYUP messages
 caused by pressing RightShift or RightControl keys, or FALSE otherwise }
function RightKey(lKeyData: Integer): Boolean;

{ The EmulateKey procedure posts messages to a control to emulate a keystroke.
  The Wnd parameter specifies the window handle to a control.
  The VKey paremeter specifies a virtual key code (see VK_xxx constants)}
procedure EmulateKey(Wnd: HWND; VKey: Integer);

{ The Perspective procedure calculates 2D on-picture coordinates of a point.
 3D coordinates of a point must be specified as the X, Y and Z parameters.
 The HEIGHT parameter specifies the altitude of "observer".
 The BASIS parameter specifies the distance between "observer" and "picture".
 The result values will be placed at the YP and ZP coordinates }
procedure Perspective(const X, Y, Z, Height, Basis: Extended; var XP, YP: Extended);

{ The Interpolate function returns value of the linear function passing through the points
 (X1, Y1) and (X2, Y2) at the X coordinate }
function Interpolate(const X1, Y1, X2, Y2, X: Extended): Extended;

{ The Det function returns the determinant of a matrix described as
 a11 a12 a13
 a21 a22 a23
 a31 a32 a33 }
function Det(a11, a12, a13, a21, a22, a23, a31, a32, a33: Double): Double;

{ The SinCos procedure places values of sine and cosine functions of the THETA angle
 expressed in radians at the Sin and Cos variables respectively}
procedure SinCos(Theta: Extended; var Sin, Cos: Extended);

{ The Tan function returns tangent of an angle ALPHA }
function Tan(Alpha: Extended): Extended;

{ The GetLineEqn procedure places the equation parameters (A*y+B*z+C=0) of a line
 passing through the points (Y1, Z1) and (Y2, Z2) at the A, B and C variables }
procedure GetLineEqn(Y1, Z1, Y2, Z2: Extended; var A, B, C: Extended);

{ The LinesIntersection functions return TRUE if specified lines have the intersection
 point and places values of that point coordinates at Y and Z variables. If specified
 lines are parallel these functions return FALSE.
  The first of two functions described below receives equations of two lines specified
 as A1*y+B1*z+C1=0 and A2*y+B2*z+C2=0. The second function receives coordinates of
 points (Y1, Z1) and (Y2, Z2) where the first line passing through and coordinates
 of points (Y3, Z3) and (Y4, Z4) which belong to the second line }
function LinesIntersection(A1, B1, C1, A2, B2, C2: Extended; var Y, Z: Extended): Boolean; overload;
function LinesIntersection(Y1, Z1, Y2, Z2, Y3, Z3, Y4, Z4: Extended; var Y, Z: Extended): Boolean; overload;

{ The SegmentLength function returns the lengths of a segment passing through
 the (X1, Y1) and (X2, Y2) points. The value returned by this function
 calculated by the Pythagorean proposition }
function SegmentLength(const X1, Y1, X2, Y2: Extended): Extended;

{ The Rotate procedure calculates the coordinates of the point (X, Y) in
 cartesian coordinate system with the origin in the (X0, Y0) point
 and turned at the Alpha angle about initial coordinate system. This procedure
 places calculated values at the X1 and Y1 variables}
procedure Rotate(X, Y, X0, Y0, Alpha: Extended; var X1, Y1: Extended);

{  The GetAngle function returns the clockwise angle between the up direction and
  the vector sum of two vectors. The Num parameter specifies the vertical coordinate
  of the end of the first vector. The Den parameter specifies the horizontal coordinate
  of the end of the second vector }
function GetAngle(Num, Den: Double): Double;

{ The GetAlpha function returns the clockwise angle between two vectors in a right-hand
 cartesian coordinate system. The Y axis of that coordinate system is directed to up
 and the Z axis is directed to left.
  Both of two vectors have the common origin in the point (Y2, Z2). The first vector
 is directed to the point (Y1, Z1) and the second vector to the point (Y3, Z3) }
function GetAlpha(Y1, Z1, Y2, Z2, Y3, Z3: Double): Double;

{ The GetAlphaScr function returns the counterclockwise angle between two vectors in
 a left-hand cartesian coordinate system. The X axis of yhat coodinate system is
 directed to left and the Y axis is directed to bottom.
  Both of two vectors have the common origin in the point (X2, Y2). The first vector
 is directed to the point (X1, Y1) and the second vector to the point (X3, Y3) }
function GetAlphaScr(X1, Y1, X2, Y2, X3, Y3: Double): Double;

{ The RebuildRect procedure verifies that both of
 coodinates in the TopLeft field in the Rect variable are less than
 the corresponding coordinates in the BottomRight field, i.e. the
 TopLeft field really signs at the Top Left point of a rectangle }
procedure RebuildRect(var Rect: TRect);

{ The MoveRect procedure adds to the fields Left and Right of the
 Rect variable the value of DeltaX parameter and to the fields
 Top and Bottom the value of the DeltaY }
procedure MoveRect(var Rect: TRect; DeltaX, DeltaY: Integer);

{ The CopyRect procedure assigns to the fields of the Dest variable
 the values of the Source parameter }
procedure CopyRect(const Source: TRect; var Dest: TRect);

{ The DeltaRect procedure increases bounds of the Rect variable
  by the value of the Delta parameter, i.e. adds the Delta
  value to the Right and Bottom fields and subtracts that value
  from the Left and Top fields of a rectangle }
procedure DeltaRect(var Rect: TRect; Delta: Integer);

{ The IsEmptyRect function returns TRUE if each field of the
 Rect parameter has the zero value or FALSE otherwise }
function IsEmptyRect(const Rect: TRect): LongBool;

{ The RectInterscetion function calculates and returns bounds
 of the rectangle that consists of the area which belongs to
 both of Rect1 and Rect2 rectangles. If these rectangles have
 no common area this function places zero values to each field
 of its result }
function RectIntersection(const Rect1, Rect2: TRect): TRect;

{ The SamePoint function returns TRUE if the coordinates of the
 Point1 parameter are both equally to the coordinates of the
 Point2 parameter, or FALSE otherwise }
function SamePoint(const Point1, Point2: TPoint): LongBool;

{ The IsNullPoint function returns TRUE if both of coordinates of
 the Point1 have the zero value, or FALSE otherwise }
function IsNullPoint(const Point: TPoint): LongBool;

{ The ComparePointX function compares the coordinates of two
 points described in the Point1 and Point2 parameters. The
 X coordinates of those points have the advantage during the
 comparison.
  The function returns:
   the nLess constant value in the following cases:
    1: Point1.X < Point2.X
    2: (Point1.X = Point2.X) and (Point1.Y < Point2.Y);
   the nMore constant value in the subsequent cases:
    1: Point1.X > Point2.X
    2: (Point1.X = Point2.X) and (Point2.Y > Point2.Y);
   the nEqual constant value in case of each coordinate of
   Point1 are equal to the corresponding cooordinates of Point2 }
function ComparePointX(const Point1, Point2: TPoint): Integer;

{ The ComparePointY function compares the coordinates of two
 points described in the Point1 and Point2 parameters. The
 Y coordinates of those points have the advantage during the
 comparison.
  The function returns:
   the nLess constant value in the following cases:
    1: Point1.Y < Point2.Y
    2: (Point1.Y = Point2.Y) and (Point1.X < Point2.X);
   the nMore constant value in the subsequent cases:
    1: Point1.Y > Point2.Y
    2: (Point1.Y = Point2.Y) and (Point2.X > Point2.X);
   the nEqual constant value in case of each coordinate of
   Point1 are equal to the corresponding cooordinates of Point2 }
function ComparePointY(const Point1, Point2: TPoint): Integer;

{ The MovePoint procedure adds the values of the DispX and DispY parameters
 respectively to the X and Y fields of the Point variable }
procedure MovePoint(var Point: TPoint; DispX, DispY: Integer);

{ The CloseTo function returns TRUE if the coordinates of the Point2 differ
  from the corresponding coordinates of the Point1 on no more than the Distance
  parameter, or FALSE otherwise }
function CloseTo(const Point1, Point2: TPoint; Distance: Integer): LongBool;

{ The CenterPoint function returns the coordinates of the central point of a rectangle}
function CenterPoint(const Rect: TRect): TPoint;

{ The Max function has several overloaded versions. Each of these function returns
 the greater value of the two parameters but receives parameters of different types}
function Max(const R1, R2: Integer): Integer; overload;
function Max(const R1, R2: Extended):Extended; overload;

{ Unlike two functions Max this overloaded version receives additional optional
 parameter that specifies the function to compare coordinates of two points.
  If the CompareY parameter is FALSE (default value) comparison use ComparePointX
 function or ComparePointY function otherwise }
function Max(const P1, P2: TPoint; CompareY: LongBool = False): TPoint; overload;

{ The Min function has several overloaded version. Each of these function returns
 the smaller value of the two parameters but receives parameters of different types}
function Min(const R1, R2: Integer): Integer; overload;
function Min(const R1, R2: Extended):Extended; overload;

{ Unlike two functions Min this overloaded version receives additional optional
 parameter that specifies the function to compare coordinates of two points.
  If the CompareY parameter is FALSE (default value) comparison use ComparePointX
 function or ComparePointY function otherwise }
function Min(const P1, P2: TPoint; CompareY: LongBool = False): TPoint; overload;

{ The ArrangeMin procedure exchanges values of two parameters if the second parameter
 is smaller than the first }
procedure ArrangeMin(var R1, R2: Integer);

{ The ArrangeMax procedure exchanges value of two parameters if the second parameter
 is greater than the first}
procedure ArrangeMax(var R1, R2: Integer);

{ The Sign functions return -1 if the Value parameter is negative,
 1 if the parameter is positive and 0 if the parameter is equal to zero}
function Sign(const Value: Integer): Integer; overload;
function Sign(const Value: Extended): Extended; overload;

{ The Swap procedures exchange values of two parameters specified as R1 and R2}
procedure Swap(var R1, R2: Integer); overload;
procedure Swap(var R1, R2: Extended); overload;
procedure Swap(var R1, R2: Double); overload;
procedure Swap(var R1, R2: TString); overload;

{ The Inside functions return TRUE if the Value parameter is situated
 between the values of Down and Up parameters, or FALSE otherwise }
function Inside(Value, Down, Up: Integer): LongBool; overload;
function Inside(Value, Down, Up: Extended): LongBool; overload;

{ The Inside function (third version) returns TRUE if a point lies inside
 a rectangle. The coordinates of a point are specified in the Point parameter
 and a rectangle is defined in the Rect parameter }
function Inside(const Point: TPoint; const Rect: TRect): LongBool; overload;

{ The Center function returns the coordinate where it is needed to place the origin of a
 line segment to superpose its center with the center of another line segment.
  The Value parameter specifies the length of the first line segment.
  The HiValue parameter specifies the finish coordinate of the second segment.
  The LoValue optional parameter specifies the origin coordinate of the second segment }
function Center(Value: Integer; HiValue: Integer; LoValue: Integer = 0): Integer;

{ The IncPtr function returns the pointer that is greater than the initial pointer P
  by the Delta value }
function IncPtr(P: Pointer; Delta: Integer = 1): Pointer;

{ The DecPtr function returns the pointer that is smaller than the initial pointer P
  by the Delta value }
function DecPtr(P: Pointer; Delta: Integer = 1): Pointer;

{ The Join function places the LoWord value at the low-order word of a 32-bit integer
 number and the HiWord value at the high-order word of that number }
function Join(const LoWord, HiWord: Word): Integer; overload;

{ The SetValue procedure places the integer Value at specified address if the P parameter
 is not nil }
procedure SetValue(P: Pointer; Value: Integer);

{ The SetIntValue procedure has the same action as the previous procedure }
procedure SetIntValue(P: Pointer; Value: Integer);

{ The SetWordValue procedure places the word (16-bit) Value at specified address if
 the P parameter is not nil }
procedure SetWordValue(P: Pointer; Value: Word);

{ The SetByteValue procedure places the byte (8-bit) Value at specified address if
 the P parameter is not nil }
procedure SetByteValue(P: Pointer; Value: Byte);

{ The DecInt procedure decreases the N variable by the Delta parameter in case
 of N is not smaller or equal to the Lowest parameter }
procedure DecInt(var N: Integer; Delta: Integer = 1; Lowest: Integer = 0);

{ The IncInt procedure increases the N variable by the Delta parameter in case
 of N is not greater or equal to the Highest parameter }
procedure IncInt(var N: Integer; Delta: Integer = 1; Highest: Integer = MaxInt);

{ The RoundPrev function returns the greatest multiple of Divider that is
 smaller or equal than Value }
function RoundPrev(Value, Divider: Integer): Integer;

{ The RoundNext function returns the smallest multiple of Divider that is
 greater than Value }
function RoundNext(Value, Divider: Integer): Integer;

{ The BoolToSign function returns 1 if B is FALSE or -1 if B is TRUE }
function BoolToSign(B: LongBool): Integer;

{ The Among function returns TRUE if the N parameter is equal to
 one of Value array elements }
function Among(N: Integer; const Values: array of Integer): LongBool;

{ The Incr function increases the N value by one and returns the value
 assigned to the N variable }
function Incr(var N: Integer): Integer;

{ The Decr function decreaeses the N value by one adn returns the value
 assigned to the N variable }
function Decr(var N: Integer): Integer;

{ The HiLong function returns the highest long word of the N parameter
 of TWideInt (Int64) type }
function HiLong(const N: TWideInt): LongInt;

{ The LoLong function returns the lowest long word of the N parameter
 of TWideInt (Int64) type }
function LoLong(const N: TWideInt): LongInt;

{ The HiWord function returns the highest word of the integer N parameter}
function HiWord(N: Integer): word;

{ The LoWord function returns the lowest word of the integer N parameter}
function LoWord(N: Integer): word;

{ The HiByte function returns the highest byte of the word N parameter}
function HiByte(W: Word): Byte;

{ The LoByte function returns the lowest byte of the word N parameter}
function LoByte(W: Word): Byte;

{ The AbsSub function return the absolute value of the difference between
  values of the N1 and N2 parameters}
function AbsSub(N1, N2: Integer): Integer;

{ The Bit function returns True in case of the Value parameter bit with number defined as
 Index parameter is 1, or FALSE otherwise }
function Bit(Value, Index: Integer): Boolean;

{ The SwapWords function exchanges high order word with the low order
  word of a 32-bit integer value}
function SwapWords(Value: Integer): Integer;

{ The AbsInt function returns the absolute value of an integer}
function AbsInt(Value: Integer): Integer;

{ The DivMod function performs the integer division of two values specified
  by Numenator and Denominator. This function returns the quotient and
  places the remainder into the corresponding variable. }
function DivMod(Numenator, Denominator: Integer; out Remainder: Integer): Integer;

{ The FmtString function returns a formatted string based on a template string
  specified as the Str parameter and an open array of TString specified as the
  Value parameter. A template string should contain several occurences of
   %1, %2 etc. Each occurence of %n would be replaced with the corresponding item
   of the Values array }
function FmtString(const Str: TString; const Values: array of TString): TString;

{ The FindChars function searches a character from the Chars set inside a Source
  string. The CurrentPosition parameter specifies the originating position to search
  a character and the Direction parameter specifies the search direction. If Direction
  is less than zero, the function searches toward the first char, or toward the end of
  a string otherwise. This function returns the index of a found character }
function FindChars(const Source: TString; const Chars: TSetChar;
                   CurrentPosition: Integer = 1; Direction: Integer = 1): Integer;

{ The FindLastChar function returns the position of the last occurence of a character
  Ch in a string S }
function FindLastChar(const S: TString; Ch: Char = chSpace): Integer;

{ The LeftTrim function trims all characters from the first char of a string
  Str until the first character that is not equal to a character Chr}
function LeftTrim(const Str: TString; const Chr: Char = chSpace): TString; overload;

{ The LeftTrim function trims all characters from the first char of a string
  Str until the first character that is not an item of Chrs char set}
function LeftTrim(const Str: TString; const Chrs: TSetChar): TString; overload;

{ The RightTrim function trims all characters from the end of a string Str
  until the last character that is not equal to a character Chr}
function RightTrim(const Str: TString; const Chr: Char = chSpace): TString; overload;

{ The RightTrim function trims all characters from the end of a string Str
   until the last character that is not an item of Chrs char set}
function RightTrim(const Str: TString; const Chrs: TSetChar): TString; overload;

{ The LeftExpand function places Count characters Chr into the origin of
  a string Str}
function LeftExpand(const Str:TString; Count: Integer;
                    const Chr: Char = chSpace): TString;
{ The RightExpand function places Count characters Chr into the end of
  a string Str}
function RightExpand(const Str:TString; Count: Integer;
                     const Chr: Char = chSpace): TString;

{ The TrimStr function trims all characters that is equal to a character
  Chr from both ends of a string Str }
function TrimStr(const Str: TString; const Chr: Char = chSpace): TString;

{ The LeadTrim function trims Count characters from a string Str origin }
function LeadTrim(const Str: TString; Count: Integer = 1): TString;

{ The TrailTrim function trims Count characters form a string Str end }
function TrailTrim(const Str: TString; Count: Integer = 1): TString;

{ The GetSubStr function returns the substring that is
  delimited by N-1 and N occurences of the Separator character in
  a string Str }
function GetSubStr(const Str: TString; N: Byte; Separator: Char = chSpace): TString;

{ The ExtractStr function returns the substring that is delimited by
  N-1 and N occurences of several space characters}
function ExtractStr(const Str: TString; N : Byte): TString;

{ The ExtractStrings procedure places into a List all substrings those are delimited
  by occurences of the Separator character }
procedure ExtractStrings(Str: TString; List: TStrings; Separator: Char = chSpace);

{ The RemoveChars function removes all characters that belongs to a Chars set from
  a string Str }
function RemoveChars(const Str: TString; const Chars: TSetChar = [chSpace]): TString;

{ The ReplaceChar function replaces all characters OldChar with a NewChar in
  a string Str }
function ReplaceChar(const Str: TString; OldChar, NewChar: Char): TString;


{ The ReplaceStr function replaces the first occurence of a substring OldSubStr with
  a NewSubStr in a string Str }
function ReplaceStr(const Str: TString; const OldSubStr, NewSubStr: TString): TString;


{ The ReplaceStrAll function replaces all occurences of a substring OldSubStr with
 a NewSubStr in a string Str }
function ReplaceStrAll(const Str: TString; const OldSubStr, NewSubStr: TString): TString;


{ The CleanUp procedure trims all the characters behind the first zero character in a
  string Str }
procedure CleanUp(var Str: TString); overload;

{ The CleanUp procedure trims all the characters behind the first zero character in
  a string Str and deletes all the space characters from the both ends of the
  resulting string if the DoTrim parameters is True}
procedure CleanUp(var Str: TString; DoTrim: LongBool);overload;

{ The FillString function makes a string that consist of Count characters Chr }
function FillString(Chr: Char; Count: Integer): TString;

{ The UpString function converts all the characters of a string Str to uppercase}
function UpString(const Str: TString): TString;

{ The DnString function converts all the characters of a string Str to small letters}
function DnString(const Str: TString): TString;

{ The UpChar function converts a character to uppercase}
function UpChar(Ch: Char): Char;

{ The DnChar function converts a character to small letter}
function DnChar(Ch: Char): Char;

{ The GetChar function returns the character with Position index from a string
  Str. Unlike Str[Position] call this function verifies that a string is not
  empty and raises no exception}
function GetChar(const Str:TString; Position: Integer = 1): Char;

{ The ReadChar function returns the character that is placed in the process
  memory at Offset bytes from a pointer Ptr }
function ReadChar(Ptr: Pointer; Offset: Integer): Char;

{ The ReflectStr function returns a 'mirror reflection' of a specified string}
function ReflectStr(const Str: TString): TString;

{ The ReadSubStr function returns the substring from a string Str that
  is placed between characters with indices Head and Tail}
function ReadSubStr(const Str: TString; Head, Tail: Integer): TString;

{ The StrToFlt function converts a string Str to a number calling the Val procedure.
  This function places to the Code variable the index of the first offending
  character if it is unable to covert string, or 0 otherwise. The decimal separator
  in a string must always be the dot sign }
function StrToFlt(const Str: TString; var Code: Integer): Extended; overload;

{ The StrToFlt function converts a string Str to a number with no error finding. The
  decimal separator in a string must always be the dot sign }
function StrToFlt(const Str: TString): Extended; overload;

{ The FltToStr function converts a Value number into a string. The Precision
  parameter specifies the number of significant decimal digits in the resulting
  string. This function always use the dot character as a decimal separator }
function FltToStr(const Value: Extended; Precision: Integer = 5): TString;

{ The ValidInt function verifies that a string Value may be converted to an
  integer number }
function ValidInt(const Value: TString): LongBool;

{ The ValidFloat function verifies that a string Value may be converted to
  a double real number }
function ValidFloat(const Value: TString): LongBool;

{ The ValidFloatINF function verifies that a string Value may be converted to
 a double real number and resulting number does not exceed the range of that type}
function ValidFloatINF(const Value: TString): LongBool;

{ The ValidateFloat function changes the regional decimal separator to the
  dot sign in a string Value. This function returns the resulting string that
  may be converted to a double real value or empty string if not}
function ValidateFloat(const Value: TString): TString;

{ The Join function concatenates two strings }
function Join(const Str1, Str2: TString): TString; overload;

{ The AddString procedure adds a string Value to the variable Str }
procedure AddString(var Str: TString; const Value: TString);

{ The BreakStr function breaks a string Str (inserting CR-LF pairs) to several lines.
  Each line has only whole words and no more than Len value length. Each word in a
  line is delimited by space signs. If a word in a line has too many characters, the
  AltChar character would be used to delimit words }
function BreakStr(const Str: TString; Len:Integer = 64; AltChar: Char = '\'): TString;

{ The LastChar function returns the last char of a string Str }
function LastChar(const Str: TString): Char;

{ The NextChar function returns the character of a string Str, that stands
  after position specifed as Pos and is not equal to a character Passed }
function NextChar(const Str: TString; Pos: Integer;
                  Passed: Char = chSpace): Char; overload;

{ The PrevChar function returns the character of a string Str, that stands
  before position specified as Pos and is not equal to a character Passed }
function PrevChar(const Str: TString; Pos: Integer;
                  Passed: Char = chSpace): Char; overload;

{ The NextChar function returns the character of a string Str, that stands
  after position specified as Pos and is not equal to a character that
  belongs to a set Passed }
function NextChar(const Str: TString; Pos: Integer; Passed: TSetChar): Char; overload;

{ The PrevChar function returns the character of a string Str, that stands
  before position specified as Pos and is not equal to a character that
  belongs to a set Passed }
function PrevChar(const Str: TString; Pos: Integer; Passed: TSetChar): Char; overload;

{ The AdjustLength function verifies that a string Str is not less than Len
  characters long.  This function fills the deficiency of characters inserting
  several characters Chr before the string first character }
function AdjustLength(Str: TString; Len: Integer; Ch: Char = chSpace): TString;

{ The CharCount function returns the count of characters Ch in a string Str }
function CharCount(const Str: TString; Ch: Char): Integer;

{ The CopyToBuf procedure copies a string Source to a buffer Buf. The Size
  parameter specifies the length of a buffer. If s string length exceeds Size
  this function writes a null character to a buffer and returns False, otherwise
  this function copies a string and returns True}
function CopyToBuf(const Source: TString; Buf: PChar; Size: Integer): LongBool;


{ The MatchString function compares a string Str with items of an array Values.
  This function returns the index of the array item that is equal to Str or zero
  if there is no equal items. The optional CaseSensitive parameter specifies the
  comparison style }
function MatchString(const Str: TString; const Values: array of TString;
                            CaseSensitive: LongBool = False): Integer;

{ The MatchStringEx function works like the MatchString function but receives
  an array as the address of the first array item (Values parameter) and the
  count of array items (Count parameter) }
function MatchStringEx(const Str: TString; const Values: Pointer; Count: Integer;
                            CaseSensitive: LongBool = False): Integer;

{ The GetLength function returns the length between the first character in
  a string Str and then first null character}
function GetLength(const Str: TString): Integer;

{ The GetStrLen function returns assigned length of a string Str. This function
  works like the standard Length function }
function GetStrLen(const Str: TString): Integer;

{ The IsEmptyStr function returns True if a string Str is empty or False otherwise}
function IsEmptyStr(const Str: TString): LongBool;

{ The CharEntryPos function returns the position of an occurence of
  a character Ch in a string Str. The Entry parameter specifies the
  number of occurence }
function CharEntryPos(const Str: TString; Ch: Char; Entry: Integer): Integer;

{ The ReplaceText procedure removes a substring of Len characters long
  starting the Pos position and inserts the SubStr there }
procedure ReplaceText(const SubStr:TString;var Str: TString; Pos, Len: Integer);

{ The EqualText function compares two strings without case sensitivity }
function EqualText(const S1, S2: TString): LongBool;

{ The EqualStr function compares two strings with case sensitivity }
function EqualStr(const S1, S2: TString): LongBool;

{ The IntToStrLen function converts an integer N to a string and verifies
  that resulting string is not not less than Len characters long.
  This function fills the deficiency of characters inserting
  several '0' characters  before the result first character }
function IntToStrLen(N: Integer; Len: Integer = 0): TString;


{ The GetPos function returns the index value of the first character in a specified
 substring that occurs in a given string. The optional CaseSensitive parameter
 specifies the substring seacrhing style }
function GetPos(const SubStr, Str: TString; CaseSensitive: LongBool = True): Integer;


{ The HexToInt function converts a string with hexadecimal digits to an integer.
  This function places to the Code variable the index of the first offending
  character if it is unable to covert string, or 0 otherwise }
function HexToInt(const Hex: TString; var Code: Integer): Integer;


{ The UrlEncode function returns a string in which all alphanumeric characters
  and '_' sign have been unchanged, all spaces have been replaced with '+' and
  all others (unprintable) characters have been replaced with a percent '%'
  sign followed by two hex digits. This function is useful to make a http
  query using some national characters}
function UrlEncode(Str: TString): TString;


{ The UrlDecode function have the opposite action to the UrlEncode function.
  This function returns a string in which all '%HH' substrings (HH are two
  hexadecimal digits) have been decoded to the corresponding characters }
function UrlDecode(Str: TString): TString;

{ The ParseUrl procedure extracts Protocol, Host, Port, Path, and Hash substrings
  from an url written in 'protocol://host:port/path#hash' form. This procedure
  extracts empty strings for non-presented url members.  }
procedure ParseUrl(const Url: TString;
 out Protocol, Host, Port, Path, Hash: TString);


{ The UniteLists procedure adds to List1 all the items of List2 those are not
  equal to each item of List1}
procedure UniteLists(List1, List2: TStrings);

function Year: Word;         // returns the current year
function Month: Word;        // returns the current month
function Day: Word;          // returns the current day
function DayOfWeek: Word;    // returns the current day of the week;
                             // Sunday = 0, Monday = 1, etc.
function Hour: Word;         // returns the current hour
function Minute: Word;       // returns the current minute
function Second: Word;       // returns the current second
function Milliseconds: Word; // returns the current milliseonds
function Timer: Integer;     // returns the count of milliseconds passed since the last midnight
function LeapYear(Year: Word): Boolean; // returns TRUE if a specified Year is leap
                                        // or FALSE otherwise

function MonthLength(Month, Year: Word): Word; overload;// returns length of a Month of a Year
                                               // using the Gregorian calendar
function MonthLength: Word;  overload;// returns the length of a current Month


{ The GUIDToString function converts a GUID to a string }
function GUIDToString(const GUID: TGUID): TString;

{ The CreateGUID function creates a new GUID }
function CreateGUID(out GUID: TGUID): HResult; stdcall;

{ The GetLogicalDriveList procedure fills a string list specified in the List parameter
  with names of all the logical drives on a computer }
procedure GetLogicalDriveList(const List: TStrings);

{ The GetFixedDriveList procedure fills a string list specified in the List parameter
  with names of all the fixed (not removable, remote etc) drives on a computer}
procedure GetFixedDriveList(const List: TStrings);


{ The ChangeLayout function changes the active keyboard layout. The LANG parameters
  should be one of the LANG_xxxx constants, LANG_ENGLISH or LANG_RUSSIAN for
  example. This function returns True if a desired language layout found and
  activated, or False otherwise}
function ChangeLayout(LANG: Integer): Boolean;

{ The GetStringFileInfo function returns specified version information about a file.
  The FileName parameter specifies the name of the file of interest.
  The Key parameter specifies the name of a string version values. This parameter
  must be one of the sfiXXXX constants described below}
function GetStringFileInfo(const FileName: TString; const Key: TString): TString;
const
  sfiCompanyName       = 'CompanyName';
  sfiFileDescription   = 'FileDescription';
  sfiFileVersion       = 'FileVersion';
  sfiInternalName      = 'InternalName';
  sfiLegalCopyright    = 'LegalCopyright';
  sfiLegalTrademark    = 'LegalTrademark';
  sfiOriginalFileName  = 'OriginalFilename';
  sfiProductName       = 'ProductName';
  sfiProductVersion    = 'ProductVersion';
  sfiComments          = 'Comments';
  sfiPrivateBuild      = 'PrivateBuild';
  sfiSpecialBuild      = 'SpecialBuild';
  sfiLanguageName      = 'Language';
  sfiLanguageID        = 'LanguageID';

{ The LoadFile procedure copies data from a file into memory.
  The FileName parameter specifies the name of a file to load.
  This procedure returns address of the allocated memory in the Buffer variable,
  and size of the memory in the Size variable. The allocated memory should be freed
  exceptionally using the DeallocateMem function}
procedure LoadFile(const FileName: TString; out Buffer: Pointer; out Size: Integer);

{ The SaveFile procedure copies data form memory into a file.
   The FileName parameter specifies the name of a file to save.
   The Buffer parameter specifies address of the memory buffer.
   The Size parameter specifies the size of the memory buffer in bytes}
procedure SaveFile(const FileName: TString; Buffer: Pointer; Size: Integer);

{ The GetShortName function returns the short path form
  of a specified FileName parameter.}
function GetShortName(const FileName: TString): TString;

{ The GetLongName function converts the specified FileName to its long form.
  If no long path is found, this function simply returns the specified name.}
function GetLongName(const FileName: TString): TString;

{ The GetUserName function returns the current user name}
function GetUserName: TString;

{ The GetComputerName function returns the system computer name}
function GetComputerName: TString;

{ The PathExists function returns TRUE if a directory specified by
 Path parameter exists, or FALSE otherwise}
function PathExists(const Path: TString): Boolean;

{ The ExtractFolderName function returns the name of a folder
  where a file specified by FileName parameter is located.}
function ExtractFolderName(const FileName: TString): TString;

{ The ChangeFileExt function returns the FileName parameter with
  extension changes to the value of the NewExt parameter}
function ChangeFileExt(const FileName, NewExt: TString): TString;

{ The ForceDirectories function creates all the directories along a directory
 path if they do not already exist. }
function ForceDirectories(Dir: TString): Boolean;

{ The GetDiskFreeSize function returns the total amount of free space
  for a disk specified by its root directory }
function GetDiskFreeSize(Dir: TString): Int64;

{ The GetFileName function returns the name (without path and extension)
 of a file specified by FileName parameter}
function GetFileName(const FileName: TString): TString;

{ The GetAbsoluteFileName evaluates the absolute file name using
  directory name and relative file name. Here are examples of
  values returned by this function:

  1.  CurrentDir = 'c:\Dir\SubDir'  RelativeName = 'filename.ext'
            Return Value = 'c:\Dir\SubDir\filename.ext'
  2.  CurrentDir = 'c:\Dir\SubDir'  RelativeName = '..\filename.ext'
            Return Value = 'c:\Dir\filename.ext'
  3.  CurrentDir = 'c:\Dir\SubDir'  RelativeName = '..\..\filename.ext'
            Return Value = 'c:\filename.ext' }
function GetAbsoluteFileName(CurrentDir, RelativeName: TString): TString;


{ The LoadTextFile function loads entire text from a file specified by
  FileName parameter and places it to the Text variable. This function
  returns error code (the value returned by IOResult function
  after loading process completed) }
function LoadTextFile(const FileName: TString; var Text: TString): Integer;

{ The SaveTextFile function saves entire Text to a file specified by
  FileName parameter. This function returns error code (the value
  returned by IOResult function after saving process completed) }
function SaveTextFile(const FileName, Text: TString): Integer;

{ The LoadResStr functions return the value of a string resource
  specified by the ID parameters. The First of two functions
  loads resources from a module specified by the Instance parameter.
  The second function loads resources from the current module (using
  the global hInstance variable}
function LoadResStr(Instance: THandle; ID: Cardinal): TString; overload;
function LoadResStr(ID: Cardinal): TString; overload;

{ The GetTempDirectory function returns the path of the directory
  designated for temporary files.}
function GetTempDirectory: TString;

{ The GetTempFile function creates the name and the path of a temporary file.
  The initial three chars of the Prefix parametes specify prefix for the filename}
function GetTempFile(const Prefix: TString): TString;

{ The Parameters function returns the command line parameters passed to
  the current application }
function Parameters: TString;

{ The CheckAutomation function returns TRUE if an application is launched
  as an automation server, or FALSE otherwise }
function CheckAutomation: Boolean;

{ The ExeName function returns the file name of the current application }
function ExeName: TString;

{ The ExePath function returns the path to the current application }
function ExePath: TString;

{ The InstanceName function returns the file name of the current module (EXE or DLL)}
function InstanceName: TString;

{ The InstancePath function returns the path to the current module (EXE or DLL)}
function InstancePath: TString;

{ The ExeVersion function returns the version of the current application}
function ExeVersion: TString;

{ The ProgVersion function returns the project name and version which
  have been read from Version Info. If the version information
  is not included to a project, this function returns the name of
  executable file. }
function ProgVersion(Space: Char = ' '): TString;

{ The IsDebug function returns TRUE if an executable file specified
 by the FileName perameter exists and has the Debug Build flag
 selected in project options or FALSE otherwise }
function IsDebug(const FileName:  TString): LongBool; overload;

{ The IsDebug function returns TRUE if an application has the Debug Build
 flag specified in project options or FALSE otherwise }
function IsDebug: LongBool; overload;

{ The GetWindowSize procedure calculated size of a window specified
  by its handle and places result at the Size variable }
procedure GetWindowSize(Handle: HWND; var Size: TSize);

{ The GetWindowCenter procedure places values of the center of a window
 specified by its Handle at addresses specified by CenterX and CenterY
 parameters. If an address is NIL this function does not place corresponding
 value }
procedure GetWindowCenter(Handle: HWND; CenterX, CenterY: PInteger);

{ The PressKey procedure emulates a keystroke specified
 by the VKey parameter that must contain value of a VK_xxx constant}
procedure PressKey(VKey: Byte);

{ The GetAddress function returns a pointer to a place in program code
  where from this function has been called }
function GetAddress: Pointer;

type // File version record type
  PFileVersion = ^TFileVersion;
  TFileVersion = record
    HiVersion : Integer; // Major version number
    LoVersion : Integer; // Minor version number
    Release   : Integer;
    Build     : Integer;
  end;

{ The FileVersion function returns the version of an executable file
 specified by the FileName parameter }
function FileVersion(const FileName: TString = ''): TFileVersion;

{ The StringToVersion function converts a string with HiVersion.LoVersion.Release.Build
  format to a structure of TFileVersion record }
function StringToVersion(const Str: TString): TFileVersion;

{ The VersionToString function converts a structure of TFileVersion
 record to a string with HiVersion.LoVersion.Release.Build format. }
function VersionToString(const Ver: TFileVersion): TString;

{ The Version function creates a structure of TFileVersion record
  using corresponding parameters}
function Version(HiVersion, LoVersion: Integer;
  Release: Integer = 0; Build: Integer = 0): TFileVersion;

{ The CompareVersion function compares two parameters of the TFileVersion type.
  This function returns following values:
   nLess  : Version1 is older than Version2
   nEqual : Version1 is equal to Version2
   nMore  : Version1 is later than Version2 }
function CompareVersion(const Version1, Version2: TFileVersion): Integer;

{ The ComCtlVersion function returns the version of
 the COMCTL32.DLL currently used in a system }
function ComCtlVersion: TFileVersion;

{ The LoadDLL function calls the LoadLibrary API function }
function LoadDLL(const Path: TString):THandle;

{ The GetDLLProc function calls the GetProcAddress API function }
function GetDLLProc(Handle: THandle; const ProcName: TString):Pointer;

{ The WinNT function returns TRUE if a program runs under Windows NT or
  FALSE otherwise. }
function WinNT: Boolean;

{ The Win2K function returns TRUE if a program runs under Windows 2000 or
  FALSE otherwise. }
function Win2K: Boolean;

{ The WinME function returns TRUE if a program runs under Windows Millenium Edition or
  FALSE otherwise. }
function WinME: Boolean;

{ The WinXP function returns TRUE if a program runs under Windows XP or
  FALSE otherwise. }
function WinXP: Boolean;

type
  TOperatingSystem = (UndefinedWindows, Windows3x, Windows95, Windows98, WindowsME,
                  WindowsNT, Windows2000, WindowsXP);

{ The GetOperatingSystem function returns the type of the operating system
  an application runs under}
function GetOperatingSystem: TOperatingSystem;

{ The WindowsVersion function returns a string with information about the
  Windows platform and version. }
function WindowsVersion: TString;

{ The Sound procedure plays a tone with Frequency and Duration as
  specified in corresponding parameters. }
procedure Sound(Frequency, Duration: Integer);

{ The OpenCD procedure opens a CD-ROM door }
procedure OpenCD;

{ The CloseCD procedure closes a CD-ROM door }
procedure CloseCD;

{ The GetNCFontHandle function creates a system defined font specified in the NCFont
  parameter:
   popup hint font (SmCaptionFont parameter),
   form caption font (CaptionFont parameter),
   menu font (MenuFont parameter),
   message box text font (MessageFont parameter),
   status bar font (StatusFont parameter).
   This function returns a handle to the created font }
type
  TNCFont = (CaptionFont, MenuFont, MessageFont, SmCaptionFont, StatusFont);
function GetNCFontHandle(const NCFont: TNCFont):THandle;

{ The TrayWnd function returns the handle to Shell Tray Window }
function TrayWnd: HWND;

{ The GetDesktop function returns the coordinates of the Desktop
  area that is not overlapped by the Taskbar window. }
function GetDesktopRect: TRect;


{ The LangIDToCharset function returns the char code page
 for specified language identifier. If the LangID parameter is
 not specified the function uses the default system language identifier.}
function LangIDToCharset(LangID: Integer = 0): Byte;

{ The OpenShortcut function reads information about shortcut object
 from .LNK file specified by the FileName variable and places
 object name at the same variable. If FileName variable does
 not contain a .LNK file name or this file is corrupted this
 function does not change the passed variable.}
procedure OpenShortcut(var FileName: TString);

{ The GetLocale function returns the system locale identifier}
function GetLocale: Integer;

{ The ExitWindows function calls the ExitWindowsEx API function.
 Under NT this function enabled required privileges to shut down or reboot a system. }
function ExitWindows(uFlags: UINT): BOOL;

{ The RemoveDirectories procedure deletes all empty folders since a folder
 specified by the Path parameter}
procedure RemoveDirectories(const Path: TString);

{ The CreateInstance function calls the CoCreateInstance function
 to create an inproc-server object. This function calls a procedure with
 address specified by the CannotCreateInstance variable
 if CoCreateInstance function fails}
function CreateInstance(CLSID, IID: TGUID; out Instance): HResult;
type
 TCannotCreateInstanceProc = procedure (CLSID: TGUID);
var
 CannotCreateInstance : TCannotCreateInstanceProc = nil;

{ The Recycle function removes a file specified by the Name parameter to recycle bin.
 The optional Wnd parameter specifies the handle to the dialog box owning window.
 This function returns TRUE if a file is successfully deleted or FALSE otherwise.}
function Recycle(const Name: TString; Wnd: HWND = 0): Boolean;

{ The MapNetworkDrive function displays the Map Network Drive dialog box.
 The optional Wnd parameter specifies the handle to the dialog box owning window.
 See WNetConnectionDialog function to find information about return values}
function MapNetworkDrive(Wnd: HWND = 0): DWORD;

{ The DisconnectNetworkDrive function displays the Disconnect Network Drive dialog box.
 The optional Wnd parameter specifies the handle to the dialog box owning window.
 See WNetDisconnectDialog function to find information about return values}
function DisconnectNetworkDrive(Wnd: HWND = 0): DWORD;

{ The BitsPerPixel function returns the number of bits per a screen pixel }
function BitsPerPixel: Integer;

{ The RegWriteStr function writes a string value to the system registry. This function
 receives following parameters:
  RootKey - Handle to a currently open key or one of the predefined values
            (See HKEY_XXX constants);
  Key - a string specifying the name of a registry subkey;
  Name - a string containg the name of the value to set. If a value withh this name
         is not exist, the function creates it;
  Value - a string value to store it into the registry;

  This function returns TRUE if a value has been successfully written, or
   FALSE otherwise}
function RegWriteStr(RootKey: HKEY; Key, Name, Value: TString): Boolean;

{ The RegQueryStr function reads a string value from the system registry. This function
 receives following parameters:
  RootKey - Handle to a currently open key or one of the predefined values
            (See HKEY_XXX constants);
  Key - a string specifying the name of a registry subkey;

  Success - an optional parameter specifying the address of a boolean variable. If the
            function succeeds, the variable at specified address receives TRUE or FALSE
            otherwise.}
function RegQueryStr(RootKey: HKEY; Key, Name: TString; Success: PBoolean = nil): TString;

{ The RunApplication function runs a specified application.
   The Path parameter specifies the full file name of an application.
   The CmdLine parameter specifies the command line parameters for an application.
   The Dir parameter specifies the working directory for an application.
   The Wait parameter specifies the need to stop program flow until an application
    terminates.

   This function returns zero if it is unable to run an application. If succeed,
   function returns the handle to an application process, when Wait = False, or
   1 otherwise.

   This function does not work with 16-bit DOS applications }
function RunApplication(Path, CmdLine, Dir: TString; Wait: Boolean = False): Cardinal;

{ The following three constants may be used as the shorter aliases of HKEY_XXX constants}
const
 HCR = HKEY_CLASSES_ROOT;
 HCU = HKEY_CURRENT_USER;
 HLM = HKEY_LOCAL_MACHINE;


{ The AllocateMem function allocates a memory block from the heap. This function
  calculates the size of a block through the product of Count and RecSize}
function AllocateMem(Count: Integer; RecSize: Integer = 1): Pointer;

{ The DeallocateMem procedure frees a memory block allocated by the AllocateMem
  function}
procedure DeallocateMem(var Pointer);

{ The ReallocateMem procedure changes the size of a block allocated by
  the AllocateMem function. The new size of a block is calculated as
  in the AllocateMem function }
procedure ReallocateMem(var Pointer; Count: Integer; RecSize: Integer = 1);

{ The MemSize function returns the size of a memory block allocated by
  the AllocateMem function}
function MemSize(P: Pointer): Integer;

{ The MoveMem procedure copies Count bytes from Source variable into Dest.
  This function works fully like the Move function. }
procedure MoveMem(const Source; var Dest; Count: Integer);

{ The InvertMem procedure performs the NOT boolean operation for
  each byte originating the X variable. The Size parameter specifies
  the count of bytes to perfrom operation}
procedure InvertMem(var X; Size:Integer=1);

{ The XorMem procedure performs the XOR boolean operation for
  each byte originating the X variable. The Size parameters specifies
  the count of bytes to perform operation. The Value parameter
  specifies the second operand to the operation }
procedure XorMem(var X; Size: Integer; Value: Byte);

{ The XorMemW procedure performs the XOR boolean operation for
  each word originating the X variable. The Size parameters specifies
  the count of words (should be 'SizeOf(V) shr 1') to perform operation.
  The Value parameter specifies the second operand to the operation }
procedure XorMemW(var X; Count: Integer; Value: Word);

{ The XorMemL procedure performs the XOR boolean operation for
  each double word originating the X variable. The Size parameters specifies
  the count of double words (should be 'SizeOf(V) shr 2') to perform operation.
  The Value parameter specifies the second operand to the operation }
procedure XorMemL(var X; Count: Integer; Value: LongInt);

{ The FillMem procedure assigns the byte Value to each byte originating
  the X variable. The Size parameters specifies
  the count of bytes to perform operation. The Value parameter
  specifies the second operand to the operation }
procedure FillMem(var X; Size: Integer; Value: Byte = 0);

{ The FillMemW procedure assigns the word Value to each word originating
  the X variable. The Size parameters specifies the count of words
  should be 'SizeOf(V) shr 1') to perform operation. The Value parameter
  specifies the second operand to the operation }
procedure FillMemW(var X; Count: Integer; Value: Word = 0);

{ The FillMemL procedure assigns the double word Value to each double
  word originating the X variable.  The Size parameters specifies
  the count of double words (should be 'SizeOf(V) shr 2') to perform operation.
  The Value parameter specifies the second operand to the operation }
procedure FillMemL(var X; Count: Integer; Value: LongInt = 0);

{ The ClearMem procedure fills the Size bytes originating the X
  variable with Zero values}
procedure ClearMem(var X; Size: Integer);


{ The GetColor function translates a system color constant (clXXXX)
  into its color value }
function GetColor(Color: Integer): Integer; overload;

{ The GetColor value returns the color with the
  corresponding Red, Green and Blue values }
function GetColor(Red, Green, Blue: Integer): Integer; overload;

{ The IndexToRGB procedure places the Red, Green and Blue values
  from a color}
procedure IndexToRGB(Color: Integer; R, G, B : PByte);

{ The Line procedure draws a line in a display context specified
  with its handle (DC parameter) from point (X1, Y1) to point (X2, Y2) }
procedure Line(DC: HDC; X1, Y1, X2, Y2: Integer);

{ The clGradientActiveCaption function returns the color of the
  second color of window captions in Win98 and Win2K }
function clGradientActiveCaption: Integer;

type
  PIdentMapItem=^TIdentMapItem;
  TIdentMapItem=record
    Value             : Integer;
    Name              : TString;
  end;

{ The ValueToName function scans the Map array of TIdentMapItem to find specified
  Value and returns the corresponding Name field of the array item in which the
  Value is found, or Default otherwise. }
function ValueToName(Value: Integer; Map: array of TIdentMapItem;
                     Default: TString = ''): TString;

{ The NameToValue function scans the Map array of TIdentMapItem to find specified
  Name and returns the corresponding Value field of the array item in which the
  name is found, or Default otherwise. }
function NameToValue(Name: TString; Map: array of TIdentMapItem;
                     Default: Integer = 0): Integer;

{ The Arctan2 function returns the arctangent angle of a number specified
  as X/Y. The signs of X and Y parameters specify quadrant of an angle}
function Arctan2(X, Y: Extended): Extended;

{ The Int function returns the integral part of a number specified in
  the R parameter }
function Int(R: Extended): Extended;

{ The Frac function returns the fractional part of a number specified in
  the R parameter }
function Frac(R: Extended): Extended;

{ The Trunc function truncates an extended number into an integer}
function Trunc(R: Extended): Integer;

{The Round function rounds an extended number to a nearest integer value}
function Round(R: Extended): Integer;

{ The Floor function rounds a number toward the negative infinity}
function Floor(R: Extended): Extended;

{ The Ceil function rounds a number toward the positive infinity}
function Ceil(R: Extended): Extended;

{ The ClearFPUEx procedure clears the FPU exception flag }
procedure ClearFPUEx;

{ The Infinity function checks a number for an infinity value. This function returns
  -1 when R = -INF; 1 when R = +INF; 0 when R is a valid number }
function Infinity(R: Extended): Integer;

{ The NonAtNumber function returns True if the specified parameter is not a valid
  number and not an infinity }
function NonAtNumber(R: Extended): Boolean;

{ The first MimeEncode procedure performs the MIME (Base64) encoding for a memory
  buffer specified by the address (InBuf argument) and the size (InSize argument).
  The procedure allocates a new memory buffer to store results and places the
  address into OutBuf argumnent and the size into OutSize argumnent. Note that
  the resulting buffer must be freed by the DeallocateMem procedure. The CRLF
  optional argument specifies whether line breaks are inserted after each 76th
  byte inside the resulting memory buffer.
}
procedure MimeEncode(InBuf: Pointer; InSize: Cardinal;
  out OutBuf: Pointer; out OutSize: Cardinal; CRLF: Boolean = True); overload;

{ The 2nd MimeEncode function performs the MIME (Base64) encoding for a string
  represented by the Str argumnent. The CRLF optional argument specifies whether
  line breaks are inserted after each 76h character inside the resulting string.}
function MimeEncode(Str: TString;
 CRLF: Boolean = True): TString; overload;

{ The 3rd MimeEncode function performs the MIME (Base64) encodimg for a stream
  specifed by the InStream argument. The encoding result is placed into another
  stream represented by the OutStream argument. The CRLF optional parameter
  specifies whether line breaks are placed after each 76th byte written into
  the output stream. }
procedure MimeEncode(InStream, OutStream: TStream;
  CRLF: Boolean = True); overload;

{ The 1st MimeDecode procedure decodes mime encoded data for a memory buffer.
  The InBuf argument specifies the address of a buffer and the InSize argument
  is the size of a buffer. To store decoded data this procedure allocates a
  memory buffer and places the address into OutBuf argument and the size of
  decoded data into OutSize argument. Note that the OutBuf buffer must be freed
  by the DeallocateMem function. }
procedure MimeDecode(InBuf: Pointer; InSize: Cardinal;
  out OutBuf: Pointer; out OutSize: Cardinal); overload;

{ The 2nd MimeDecode function decodes mime encoded data for a string. }
function MimeDecode(Str: AnsiString): AnsiString; overload;

{ The 3rd MimeDecode procedure decodes mime encoded data for a stream.
  InStream is a stream that contains encoded data.
  OutStream is a stream that receives decoded data. }
procedure MimeDecode(InStream, OutStream: TStream); overload;


function LetterToNumber(const Letter: TString): Integer;
function NumberToLetter(Number: Integer): TString;
procedure SplitAlphanumericName(const Name: TString; var Alpha: TString;
 var Num: Integer; const AdditionalChars: TSetChar = []);

type

{ The TUnknown class is an implementation of the IUnknown interface. Unlike the
  TInterfacedObject class instances, objects of this class do not destroy
  themselves after RefCount falls to zero in the _Release method }
  TUnknown = class (TObject, IUnknown)
  protected
    FRefCount: Integer;
    function QueryInterface(const IID: TGUID; out Obj): HResult; virtual; stdcall;
    function _AddRef: Integer; virtual; stdcall;
    function _Release: Integer; virtual; stdcall;
  public
    function Unknown: IUnknown; overload;
    procedure Unknown(out Obj); overload;
  end;

  TObjectX = TUnknown;

type

{ TShellLink class encapsulates functions those work with shell link objects}
  EShellLinkError = class (Exception);

  TShellLink = class(TUnknown)
  private
    FResult: HRESULT;
    FShellLink: IShellLink;
    FPersistFile : IPersistFile;
    FTemp: WideString;
    FDesktopFolder: TString;
    FProgramsFolder: TString;
    FStartMenuFolder: TString;
    FStartUpFolder: TString;
    FMyDocsFolder: TString;
    function GetArguments: TString;
    function GetDescription: TString;
    function GetHotKey: word;
    function GetIconIndex: Integer;
    function GetIconLoc: TString;
    function GetPath: TString;
    function GetPIDL: PItemIDList;
    function GetShowCmd: Integer;
    function GetWorkDir: TString;
    procedure SetArguments(const Value: TString);
    procedure SetDescription(const Value: TString);
    procedure SetHotKey(const Value: word);
    procedure SetIconIndex(const Value: Integer);
    procedure SetIconLoc(const Value: TString);
    procedure SetPath(const Value: TString);
    procedure SetPIDL(const Value: PItemIDList);
    procedure SetShowCmd(const Value: Integer);
    procedure SetWorkDir(const Value: TString);
    procedure RunError(const Msg: TString; const Args: TString = '');
    function ResolveFileName(FileName: TString): PWideChar;
    function DesktopFolder: TString;
    function ProgramsFolder: TString;
    function StartMenuFolder: TString;
    function StartUpFolder: TString;
    function MyDocsFolder: TString;
  public
    property Path:TString read GetPath write SetPath;
      // path to the shell link reference object (i.e file or folder)
    property Description:TString read GetDescription write SetDescription;
      // description of a shell link object
    property WorkingDirectory:TString read GetWorkDir write SetWorkDir;
      // the working directory for the shell link reference object
    property Arguments:TString read GetArguments write SetArguments;
      // the command line arguments to launch the shell link reference object
    property IconLocation:TString read GetIconLoc write SetIconLoc;
      // the icon location path for the shell link reference object
    property IconIndex:Integer read GetIconIndex write SetIconIndex;
      // the icon index for the shell link reference object
    property HotKey:word read GetHotKey write SetHotKey;
      // the hot key to open shell link reference object in Windows Explorer
    property ShowCmd:Integer read GetShowCmd write SetShowCmd;
      // the show command (SW_SHOWNORMAL for example) to open the object
    property PIDL:PItemIDList read GetPIDL write SetPIDL;
      // the PIDL to the shell link refernce object

    { The LoadFromFile function reads information from a .lnk file }
    function LoadFromFile(FileName: TString): Boolean; virtual;

    { The SaveToFile function writes information to a .lnk file }
    function SaveToFile(FileName: TString): Boolean; virtual;

    (*******************************************************************
      The FileName string passed to LoadFromFile or SaveToFile functions
      may begin with a special folder alias that will be replaced with
      a special folder location. These are folder aliases:

        {$Desktop} - a shortcut on the Desktop is implied
        {$StartMenu} - a shortcut in the Start Menu
        {$Programs} - a shortcut in the Start Menu\Programs submenu
        {$StartUp} - a shortcut in the Start Menu\Programs\Startup submenu
        {$MyDocs} - a shortcut in the My Documents folder

      All these aliases are not case sensitive. For example, the following
      expression places a shortcut on the Desktop:

      SaveToFile('{$desktop}\MyShortcut.lnk');

      Note that the backslash placed after an alias is optional.
     *********************************************************************)


    { The SpecialFolder function returns location of a system folder. One
     of fidXXX constans should be used to specify system folder (see below).
     Except that, any ShlObj.CSIDL_xxx constant may used as the FolderID parameter}
    class function SpecialFolder(FolderID:Integer):TString;

    constructor Create;
    destructor Destroy;override;
  end;

const
 fidDesktop     = CSIDL_DESKTOP;
 fidFonts       = CSIDL_FONTS;
 fidNetHood     = CSIDL_NETHOOD;
 fidPersonal    = CSIDL_PERSONAL;
 fidPrograms    = CSIDL_PROGRAMS;
 fidRecent      = CSIDL_RECENT;
 fidSendTo      = CSIDL_SENDTO;
 fidStartUp     = CSIDL_STARTUP;
 fidTemplates   = CSIDL_TEMPLATES;

type

{ The TDynamicArray class encapsulates the dynamic arrays support }
  TForEachFunc = function (Tag: Integer; Index: Integer; var Item): Integer; register;
  EDynArray = class (Exception);

  TDynamicArray = class (TObjectX)
  private
    FHandle: hLocal;
    FData: Pointer;
    FItemSize: Cardinal;
    FCount: Cardinal;
    function AllocMem(ACount: Cardinal; var Handle: hLocal): pointer;
    procedure FreeMem(var Handle: hLocal);
    procedure _SetCount(const Value: Cardinal);
    procedure DoSizeChanged;
  protected
{ The GetFirstItem function returns the address of the first item of an array }
    function  GetFirstItem: Pointer;

{ The PutItem procedure places an item to an array }
    procedure PutItem(Index: Integer; const Item);

{ The GetItem procedure reads an item from an array }
    procedure GetItem(Index: Integer; out Item);

{ The Error function raises an exception when an index passed to one of methods
  exceeds range of items }
    procedure Error(Index: Integer);

{ Methods call the SizeChanged procedure when they changes the count of items }
    procedure SizeChanged; virtual;

{ The SetCount procedure sets the count of an array items }
    procedure SetCount(const Value: Cardinal); virtual;
  public

{ Use the Count property to set and get count of an array items }
    property Count: Cardinal read FCount write _SetCount;

{ Use the ItemSize property to determine the size of each array items }
    property ItemSize: Cardinal read FItemSize;

{ Use the FirstItem property to determine the address of the first array item }
    property FirstItem: Pointer read FData;

{ The Add function includes an item to an array and returns the index of included item }
    function Add: Integer; virtual;

{ The AddItem function includes an item to an array and assigns the item content }
    function AddItem(const Item): Integer; virtual;

{ The Insert procedure inserts an item to an array at specified position }
    procedure Insert(Index: Integer); virtual;

{ The InsertItem procedure inserts an item to an array at specified position
  and assigns the item content }
    procedure InsertItem(Index: Integer; const Item); virtual;

{ The Delete procedure deletes an item at specified position }
    procedure Delete(Index: Integer); virtual;

{ The DeleteItem procedure copies the content of an array item to the Item variable
  and deletes an item at specified position }
    procedure DeleteItem(Index: Integer; out Item); virtual;

{ The Extend procedure adds Count items to an array }
    procedure Extend(Count: Cardinal = 1); virtual;

{ The Trim procedure deletes Count items from the end of an array }
    procedure Trim(Count: Cardinal = 1); virtual;

{ The Swap procedure exchanges content of two array items }
    procedure Swap(Index1, Index2: Cardinal); virtual;

{ The ForEach function is used to perform some operation for each array item.
  The Tag parameter specified a user defined number that will be passed to a
  ForEachFunc function that does peform desired operation. This function
  continues processing while ForEachFunc function return zero. When a
  ForEachFunc returns non zero this function stops processing and returns
  received value. If no ForEachFunc call returns non zero, this function returns
  zero. }
    function ForEach(Tag: Integer; ForEachFunc: TForEachFunc): Integer; virtual;

{ The GetItemPtr function returns the address of an array item }
    function GetItemPtr(Index: Integer): Pointer;

{ The Create constructor creates an array and assigns initial count of items and
  an item size }
    constructor Create(ACount, AItemSize: Cardinal);
    destructor Destroy; override;
  end;

  TDynamicArrayClass = class of TDynamicArray;

  TForEachFuncEx = function (Tag, Index: Integer; Item: Pointer):
    Integer; register;
  TDynamicArrayExStatus = (dsNone, dsCreating, dsDestroying, dsInsertingItems,
   dsDeletingItems, dsLoading, dsSaving);

  { The TDynamicArrayEx class encapsulates the dynamic array support and
    this class has more features that TDynamicArray. }
  TDynamicArrayEx = class (TObjectX)
  private
    FBuffer: Pointer;
    FBufferSize: Integer;
    FItemSize: Integer;
    FCount: Integer;
    FCapacity: Integer;
    FTempItems: array[0..3] of Pointer;
    FStatus: TDynamicArrayExStatus;
    procedure AllocBuffer(ASize: Integer);
    procedure FreeBuffer;
    function Get(Index: Integer): Pointer;
    function DoInitItem(Index: Integer; var Item): Integer;
    function DoDoneItem(Index: Integer; var Item): Integer;
    function DoLoadItem(Index: Integer; var Item): Integer;
    function DoSaveItem(Index: Integer; var Item): Integer;
    procedure DoneItems;
    procedure SetCount(ACount: Integer);
    procedure Grow(ACount: Integer);
    procedure QuickSort(Low, High, Direction: Integer);
  protected
     procedure Error(Index: Integer);
   { The InitItem procedure is called to initialize an item. By default
      this function has no action and would be overriden in this class
      descendants. For example, if you this class descentant as an
      array of objects this procedure would be the following:

      procedure TDynamicArrayExDescendant.InitItem(Index: Integer;
        var Item); virtual;
      begin
       TObject(Item):=TObject.Create;
      end;
      }
    procedure InitItem(Index: Integer; var Item); virtual;

    { The DoneItem procedure is called to uninitialize an item. By default
      this function has no action and would be override in this class
      descendants. }
    procedure DoneItem(Index: Integer; var Item); virtual;

    { If you are going to use the Sort method use must override
      the CompareItems function, which compares two items.
      This function returns -1 if Item1 is less than Item2,
       0 when items are equal, and 1 if Item1 is more than Item2. }
    function CompareItems(var Item1, Item2): Integer; virtual;

    { The LoadItem procedure is called to read data of a stream and
       write it into an item. }
    procedure LoadItem(Stream: TStream; Index: Integer; var Item); virtual;

    { The SaveItem procedure is called to write an item data into a stream. }
    procedure SaveItem(Stream: TStream; Index: Integer; var Item); virtual;

    { The GetItem procedure places an item into an array. }
    procedure GetItem(Index: Integer; var Item);

    { The GetItem procedure reads an item from an array. }
    procedure PutItem(Index: Integer; const Item);

    { The Status property represents the current array status:
       creating, destroying, inserting items, deleting items,
       loading from a stream, saving to a stream or nothing. }
    property Status: TDynamicArrayExStatus read FStatus;
  public

    { The Count property represents the number of an array items. }
    property Count: Integer read FCount write SetCount;

    { The ItemSize property represents the size (in bytes) if an array item. }
    property ItemSize: Integer read FItemSize;

    { The Buffer property represents the address of the first item. }
    property Buffer: Pointer read FBuffer;

    { The Items property represents the array of items addresses. }
    property Items[Index: Integer]: Pointer read Get; default;

    { The Add function includes new item into an array and returns the
      number of included item. }
    function Add: Integer;

    { The Insert procedure interposes a group of items into an array.
      The AIndex parameter specifies the index of the first inserted
      item, the ACount parameter is the number of interposed items. }
    procedure Insert(AIndex: Integer; ACount: Integer = 1);

    { The Delete procedure removes several items from an array.
      The AIndex parameter specifies the index of the first deleted item,
      The ACount parameter is the number of removed items. }
    procedure Delete(AIndex: Integer; ACount: Integer = 1);

    { The Swap procedures exchanges two items specified by thier indices. }
    procedure Swap(Index1, Index2: Integer);

   { The ForEach function is used to perform some operation for each array item.
     The Tag parameter specified a user defined number that will be passed to a
     ForEachFunc function that does peform desired operation. This function
     continues processing while ForEachFunc function return zero. When a
     ForEachFunc returns non zero this function stops processing and returns
     received value. If no ForEachFunc call returns non zero, this function
     returns zero. }
    function ForEach(Tag: Integer; ForEachFunc: TForEachFuncEx): Integer;


    { The Sort procedure organizes the items of an array. The Direction
      parameter specifies the king of organizing: 1 means the first item
      would be the greatest, -1 means the first item would be the smallest.
      If you are going to use this method, you must override the
      CompareItems function. }
    procedure Sort(Direction: Integer = 1);

    { The Shuffle procedure randomly exchanges an array items. The Moves
      parameter specifies the number of items exchangings. }
    procedure Shuffle(Moves: Integer);

    { The LoadFromStream procedure reads data from a stream and writes
      it into an array. }
    procedure LoadFromStream(const Stream: TStream);

    { The SaveToStream procedure writes an array into a stream. }
    procedure SaveToStream(const Stream: TStream);

    { The LoadFromFile procedure reads data from a file and writes
      it into an array. }
    procedure LoadFromFile(const FileName: TString);

    { The SaveToStream procedure writes an array into a file. }
    procedure SaveToFile(const FileName: TString);

    { The Create constructor creates an array and assigns initial count of
      items and an item size }
    constructor Create(ACount, AItemSize: Integer);

    destructor Destroy; override;
  end;


type

  TFileStatus = (fsReading, fsWriting);

  EFileError = class (Exception);

const
  faReadOnly             = $00000001;
  faHidden               = $00000002;
  faSystem               = $00000004;
  faDirectory            = $00000010;
  faArchive              = $00000020;
  faEncrypted            = $00000040;
  faNormal               = $00000080;
  faTemporary            = $00000100;
  faSparceFile           = $00000200;
  faReparsePoint         = $00000400;
  faCompressed           = $00000800;
  faOffline              = $00001000;
  faNotContentIndexed    = $00002000;

type

{ The TFile class encapsulates a file input output operations }
  TFile = class (TObjectX)
  private
    FFileName: TString;
    FHandle: HFile;
    FStatus: TFileStatus;
    FDummy: LongWord;
    procedure CreateBackup;
    function GetSize: Integer;
    function GetCreationTime: TFileTime;
    function GetLastAccessTime: TFileTime;
    function GetLastWriteTime: TFileTime;
    procedure SetCreationTime(const Value: TFileTime);
    procedure SetLastAccessTime(const Value: TFileTime);
    procedure SetLastWriteTime(const Value: TFileTime);
    function GetAttributes: LongInt;
    procedure SetAttributes(const Value: LongInt);
  protected
{ The Error procedure raises an exception with specified error code }
    procedure Error(Code: Integer); dynamic;

{ The GetErrorMessage function is used to obtain error message for specified
  error code }
    function GetErrorMessage(Code: Integer): TString; dynamic;
  public
    property FileName: TString read FFileName;
             // the name of a file
    property Status: TFileStatus read FStatus;
             // the status of a file (reading or writing)
    property Handle: HFile read FHandle;
             // the handle to a file
    property Size: Integer read GetSize;
             // the size of a file
    property CreationTime: TFileTime read GetCreationTime write SetCreationTime;
             // a file creation time
    property LastAccessTime: TFileTime read GetLastAccessTime write SetLastAccessTime;
             // a file last access time
    property LastWriteTime: TFileTime read GetLastWriteTime write SetLastWriteTime;
             // a file last write time
    property Attributes: LongInt read GetAttributes write SetAttributes;
             // a file attributes

{ The Create constructor creates a new instance of this class and a new file to write
  data. If the Backup parameter is True and a file with specified file name already
  exist the old file will be renamed adding a ~ sign to its extension }
    constructor Create(AFileName: TString; Backup: Boolean);

{ The Write procedure writes data to a file }
    procedure Write(const Buffer; Size: Integer);

{ The Open constructor creates a new instance of this class and opens an existing file
  to read data }
    constructor Open(AFileName: TString);

{ The Read procedure reads data from a file }
    procedure Read(var Buffer; Size: Integer);

{ The Seek procedure sets the file pointer to desired position from the origin
  of a file }
    procedure Seek(Position: Integer);

{ The Close procedure closes a file and destroys an instance }
    procedure Close;

    destructor Destroy; override;

{ The DecodeDateTime procedure is used to obtain numerical date and time values from
  a value that is returned by CreateTime, LastAccessTime and LastWriteTime properties }
    class procedure DecodeDateTime(const DateTime: TFileTime;
     Year, Month, Day, Hour, Min, Sec: PWord);

{ The EncodeDateTime procedure is used to make a value to assign it to
  CreateTime, LastAccessTime and LastWriteTime properties }
    class function EncodeDateTime(Year, Month, Day, Hour, Min, Sec: Word): TFileTime;


{ The UserError procedure calls the protected Error method}
    procedure UserError(Code: Integer);
  end;


{ The TFileStrm class has the same destination as TFile class but inherited from
  TStream class for compatibility with descendants of that class}
  TFileStrm = class (TStream)
  private
    FHandle: HFile;
    FStatus: TFileStatus;
    FFileName: TString;
    procedure CreateBackup;
    function GetAttributes: LongInt;
    function GetCreationTime: TFileTime;
    function GetLastAccessTime: TFileTime;
    function GetLastWriteTime: TFileTime;
    procedure SetAttributes(const Value: LongInt);
    procedure SetCreationTime(const Value: TFileTime);
    procedure SetLastAccessTime(const Value: TFileTime);
    procedure SetLastWriteTime(const Value: TFileTime);
  protected
    procedure SetSize(NewSize: LongInt); override;
    procedure Error(Code: Integer); dynamic;
    function GetErrorMessage(Code: Integer): TString; dynamic;
  public
    property FileName: TString read FFileName;
    property Status: TFileStatus read FStatus;
    property Handle: HFile read FHandle;
    property CreationTime: TFileTime read GetCreationTime write SetCreationTime;
    property LastAccessTime: TFileTime read GetLastAccessTime write SetLastAccessTime;
    property LastWriteTime: TFileTime read GetLastWriteTime write SetLastWriteTime;
    property Attributes: LongInt read GetAttributes write SetAttributes;
    constructor Create(AFileName: TString; Backup: Boolean);
    constructor Open(AFileName: TString);
    function Write(const Buffer; Count: LongInt): LongInt; override;
    function Read(var Buffer; Count: LongInt): LongInt; override;
    function Seek(Offset: LongInt; Origin: Word): LongInt; override;
    procedure Close;
    destructor Destroy; override;

    class procedure DecodeDateTime(const DateTime: TFileTime;
     Year, Month, Day, Hour, Min, Sec: PWord);
    class function EncodeDateTime(Year, Month, Day, Hout, Min, Sec: Word): TFileTime;
    procedure UserError(Code: Integer);
  end;

  TBufferStream = class (TCustomMemoryStream)
  public
    constructor Create(ABuffer: Pointer; ASize: Integer);
    function Write(const Buffer; Count: Longint): Longint; override;
  end;


{ 2D dynamic array class declaration }
  EMatrixError = class (Exception);
  TMatrix = class;

  PMatrixRow = ^TMatrixRow;
  TMatrixRow = class (TDynamicArray)
  private
    FMatrix: TMatrix;
  public
    property Matrix: TMatrix read FMatrix;
    constructor Create(AColCount: Integer; AMatrix: TMatrix);
  end;

  TMatrixRows = class (TDynamicArray)
  private
    FWidth: Integer;
    FColIndex: Integer;
    function GetRow(Index: Integer): TMatrixRow;
    procedure SetRow(Index: Integer; const Value: TMatrixRow);
    procedure SetWidth(const Value: Integer);
    function SetWidthFunc(Index: Integer; var Row: TMatrixRow): Integer;
    function InsertColFunc(Index: Integer; var Row: TMatrixRow): Integer;
    function DeleteColFunc(Index: Integer; var Row: TMatrixRow): Integer;
  public
    property Width: Integer read FWidth write SetWidth;
    property Row[Index: Integer]: TMatrixRow read GetRow write SetRow; default;
    procedure InsertCol(Index: Integer);
    procedure DeleteCol(Index: Integer);
    constructor Create(AMatrix: TMatrix);
  end;

  TMatrix = class (TUnknown)
  private
    FItemSize : Cardinal;
    FRows: TMatrixRows;
    function GetColCount: Integer;
    function GetRowCount: Integer;
    procedure SetColCount(const Value: Integer);
    procedure SetRowCount(const Value: Integer);
    function GetRow(Index: Integer): TMatrixRow;
  protected
    function CreateRow: TMatrixRow; virtual;
  public
    procedure GetItem(ACol, ARow: Integer; out Item);
    procedure PutItem(ACol, ARow: Integer; const Item);
    procedure InsertRow(Index: Integer);
    procedure DeleteRow(Index: Integer);
    procedure InsertCol(Index: Integer);
    procedure DeleteCol(Index: Integer);
    function ForEachRow(Tag: Integer; ForEachRowFunc: TForEachFunc): Integer;
    property ColCount: Integer read GetColCount write SetColCount;
    property RowCount: Integer read GetRowCount write SetRowCount;
    property Row[Index: Integer]: TMatrixRow read GetRow;
    constructor Create(AColCount, ARowCount, AItemSize: Integer);
    destructor Destroy; override;
  end;

implementation

uses Consts, SysConst, DimConst;

type
  TLangIDItem = packed record
   LangID:  Byte;
   Charset: Byte;
  end;

const
  LangCount = 33;
  LangIDToCharsetInfo : array [0..LangCount] of TLangIDItem = (
   (LangID: $01; Charset: ARABIC_CHARSET),
   (LangID: $02; Charset: RUSSIAN_CHARSET),
   (LangID: $04; Charset: CHINESEBIG5_CHARSET),
   (LangID: $05; Charset: EASTEUROPE_CHARSET),
   (LangID: $06; Charset: ANSI_CHARSET),
   (LangID: $07; Charset: ANSI_CHARSET),
   (LangID: $08; Charset: GREEK_CHARSET),
   (LangID: $09; Charset: ANSI_CHARSET),
   (LangID: $0A; Charset: ANSI_CHARSET),
   (LangID: $0B; Charset: ANSI_CHARSET),
   (LangID: $0C; Charset: ANSI_CHARSET),
   (LangID: $0D; Charset: HEBREW_CHARSET),
   (LangID: $0E; Charset: EASTEUROPE_CHARSET),
   (LangID: $0F; Charset: ANSI_CHARSET),
   (LangID: $10; Charset: ANSI_CHARSET),
   (LangID: $13; Charset: ANSI_CHARSET),
   (LangID: $14; Charset: ANSI_CHARSET),
   (LangID: $15; Charset: EASTEUROPE_CHARSET),
   (LangID: $16; Charset: ANSI_CHARSET),
   (LangID: $18; Charset: EASTEUROPE_CHARSET),
   (LangID: $19; Charset: RUSSIAN_CHARSET),
   (LangID: $1A; Charset: EASTEUROPE_CHARSET),
   (LangID: $1B; Charset: EASTEUROPE_CHARSET),
   (LangID: $1C; Charset: EASTEUROPE_CHARSET),
   (LangID: $1D; Charset: ANSI_CHARSET),
   (LangID: $1E; Charset: THAI_CHARSET),
   (LangID: $1F; Charset: TURKISH_CHARSET),
   (LangID: $22; Charset: RUSSIAN_CHARSET),
   (LangID: $23; Charset: RUSSIAN_CHARSET),
   (LangID: $24; Charset: EASTEUROPE_CHARSET),
   (LangID: $25; Charset: BALTIC_CHARSET),
   (LangID: $26; Charset: BALTIC_CHARSET),
   (LangID: $27; Charset: BALTIC_CHARSET),
   (LangID: $2a; Charset: VIETNAMESE_CHARSET));

function Hole(var A):Integer;
asm
end;

procedure Sync;
asm
   call WinNT
   test eax, 1
   jz   @@10
   ret
@@10:
   mov   dx,3dah
@@wait:
   in    al,dx
   test  al,8
   jz    @@wait
end;

function KeyPressed(VKey: Integer): LongBool;
asm
   push  eax
   call  GetKeyState
   and   eax, 0080h
   shr   al, 7
end;

function ScanCode(lKeyData: Integer): Byte;
asm
   shr   eax, 16
   and   ax, 00FFh
end;

function RightKey(lKeyData: Integer): Boolean;
asm
   shr   eax, 24
   and   ax, 0001h
end;

procedure EmulateKey(Wnd: HWND; VKey: Integer);
asm
   push   0
   push   edx
   push   0101H  //WM_KEYUP
   push   eax
   push   0
   push   edx
   push   0100H  //WM_KEYDOWN
   push   eax
   call   PostMessage
   call   PostMessage
end;


procedure Perspective(const X, Y, Z, Height, Basis: Extended; var XP, YP: Extended);
var
 Den: Extended;
begin
 Den:=Y+Basis;
 if Abs(Den)<1e-100 then Den:=1e-100;
 XP:=Basis*X/Den;
 YP:=(Basis*Z+Height*Y)/Den;
end;

function Interpolate(const X1, Y1, X2, Y2, X: Extended): Extended;
begin
 if X1=X2 then Result:=(Y1+Y2)/2 else Result:=(Y1*(X2-X)+Y2*(X-X1))/(X2-X1);
end;

function Det(a11, a12, a13, a21, a22, a23, a31, a32, a33: Double): Double;
begin
 Result:=a11*a22*a33-a11*a23*a32+
         a12*a23*a31-a12*a21*a33+
         a13*a21*a32-a13*a22*a31;
end;

procedure SinCos(Theta: Extended; var Sin, Cos: Extended);
asm
   fld     Theta
   fsincos
   fstp    tbyte ptr [edx]
   fstp    tbyte ptr [eax]
   fwait
end;

function Tan(Alpha: Extended): Extended;
asm
   fld   Alpha
   fptan
   fstp  st(0)
   fwait
end;

procedure GetLineEqn(Y1, Z1, Y2, Z2: Extended; var A, B, C: Extended);
var
 DY, DZ: Extended;
const
 Eps = 1e-20;
begin
 DY:=Abs(Y1-Y2); DZ:=Abs(Z1-Z2);
 if DY <= eps then begin
  A:=1; B:=0; C:=-Y1;
  Exit;
 end;
 if DZ <= eps then begin
  A := 0; B := 1; C := -Z1;
  Exit;
 end;
 if (DY > DZ) then begin
  A:=1;
  B:=(Y2 - Y1)/(Z1 - Z2);
 end else begin
  B:=1;
  A:=(Z2 - Z1)/(Y1 - Y2);
 end;
 C:=-A*Y1-B*Z1;
end;

function LinesIntersection(A1, B1, C1, A2, B2, C2: Extended; var Y, Z: Extended): Boolean;
var
 Det: Extended;
begin
 Det:=A1*B2-A2*B1;
 Result:=Abs(Det)>1e-20;
 if Result then begin
  Y := (c2*b1-c1*b2)/det;
  Z := (a2*c1-a1*c2)/det;
 end;
end;

function SegmentLength(const X1, Y1, X2, Y2: Extended): Extended;
asm
   fld   X1
   fld   X2
   fsub
   fld   st(0)
   fmul
   fld   Y1
   fld   Y2
   fsub
   fld   st(0)
   fmul
   fadd
   fsqrt
   fwait
end;

procedure Rotate(X, Y, X0, Y0, Alpha: Extended; var X1, Y1: Extended);
var
 Sin, Cos: Extended;
 DX, DY: Extended;
begin
 SinCos(Alpha, Sin, Cos);
 DX:=(X-X0); DY:=(Y-Y0);
 X1:=DX*Cos+DY*Sin+X0;
 Y1:=DY*Cos-DX*Sin+Y0;
end;

function LinesIntersection(Y1, Z1, Y2, Z2, Y3, Z3, Y4, Z4: Extended; var Y, Z: Extended): Boolean; overload;
var
 A1, B1, C1, A2, B2, C2: Extended;
begin
 GetLineEqn(Y1, Z1, Y2, Z2, A1, B1, C1);
 GetLineEqn(Y3, Z3, Y4, Z4, A2, B2, C2);
 Result:=LinesIntersection(A1, B1, C1, A2, B2, C2, Y, Z);
end;

procedure RebuildRect(var Rect:TRect);
asm
   push  esi
   push  edx
   mov   esi, eax
   mov   eax, [esi]
   mov   edx, [esi+8]
   cmp   eax, edx
   jl    @@10
   mov   [esi+8], eax
   mov   [esi], edx
@@10:
   mov   eax, [esi+4]
   mov   edx, [esi+12]
   cmp   eax, edx
   jl    @@20
   mov   [esi+12], eax
   mov   [esi+4], edx
@@20:
   mov   eax, esi
   pop   edx
   pop   esi
end;

procedure MoveRect(var Rect: TRect; DeltaX, DeltaY: Integer);
asm
   add   [eax], edx
   add   [eax+8], edx
   add   [eax+4], ecx
   add   [eax+12], ecx
end;


procedure CopyRect(const Source: TRect; var Dest: TRect);
asm
   mov   ecx, 16
   call  MoveMem
end;

procedure DeltaRect(var Rect: TRect; Delta: Integer);
asm
   call  RebuildRect
   add   [eax].TRect.Right, edx
   add   [eax].TRect.Bottom, edx
   sub   [eax].TRect.Top, edx
   sub   [eax].TRect.Left, edx
end;

function IsEmptyRect(const Rect: TRect): LongBool;
asm
   push  esi
   push  edx
   mov   esi, eax
   xor   eax, eax
   mov   edx, [esi]
   test  edx, edx
   jnz   @@10
   mov   edx, [esi+4]
   test  edx, edx
   jnz   @@10
   mov   edx, [esi+8]
   test  edx, edx
   jnz   @@10
   mov   edx, [esi+12]
   test  edx, edx
   jnz   @@10
   not   eax
@@10:
   pop   edx
   pop   esi
end;

function RectIntersection(const Rect1, Rect2: TRect): TRect;
begin
 RebuildRect(PRect(@Rect1)^);
 RebuildRect(PRect(@Rect2)^);
 if Inside(Rect2.TopLeft, Rect1) then begin
  if Inside(Rect2.BottomRight, Rect1) then begin
   Result:=Rect2;
   Exit;
  end else begin
   Result.TopLeft:=Rect2.TopLeft;
   Result.BottomRight:=Rect1.BottomRight;
   Exit;
  end;
 end;
 if Inside(Rect2.BottomRight, Rect1) then begin
  if Inside(Rect2.TopLeft,Rect1) then begin
   Result:=Rect2;
   Exit;
  end else begin
   Result.TopLeft:=Rect1.TopLeft;
   Result.BottomRight:=Rect2.BottomRight;
   Exit;
  end;
 end;
 if Inside(Rect1.TopLeft, Rect2) then begin
  if Inside(Rect1.BottomRight, Rect2) then begin
   Result:=Rect1;
   Exit;
  end else begin
   Result.TopLeft:=Rect1.TopLeft;
   Result.BottomRight:=Rect2.BottomRight;
   Exit;
  end;
 end;
 if Inside(Rect1.BottomRight, Rect2) then begin
  if Inside(Rect1.TopLeft, Rect2) then begin
   Result:=Rect1;
   Exit;
  end else begin
   Result.TopLeft:=Rect2.TopLeft;
   Result.BottomRight:=Rect1.BottomRight;
   Exit;
  end;
 end;
 ClearMem(Result, SizeOf(Result));
end;

function SamePoint(const Point1,Point2: TPoint):LongBool;
begin
 Result:=TWideInt(Point1)=TWideInt(Point2);
end;

function IsNullPoint(const Point: TPoint): LongBool;
begin
 Result:=not LongBool(TWideInt(Point));
end;

function ComparePointX(const Point1, Point2: TPoint): Integer;
asm
   push  esi
   push  edi
   mov   esi, eax
   mov   edi, edx
   mov   eax, [esi]
   mov   edx, [edi]
   cmp   eax, edx
   jle   @@10
   mov   eax, nMore
   jmp   @@50
@@10:
   je    @@20
   mov   eax, nLess
   jmp   @@50
@@20:
   mov   eax, [esi+4]
   mov   edx, [edi+4]
   cmp   eax, edx
   jle   @@30
   mov   eax, nMore
   jmp   @@50
@@30:
   je    @@40
   mov   eax, nLess
   jmp   @@50
@@40:
   mov   eax, nEqual
@@50:
   pop   edi
   pop   esi
end;

function ComparePointY(const Point1, Point2: TPoint): Integer;
asm
   push  esi
   push  edi
   mov   esi, eax
   mov   edi, edx
   mov   eax, [esi+4]
   mov   edx, [edi+4]
   cmp   eax, edx
   jle   @@10
   mov   eax, nMore
   jmp   @@50
@@10:
   je    @@20
   mov   eax, nLess
   jmp   @@50
@@20:
   mov   eax, [esi]
   mov   edx, [edi]
   cmp   eax, edx
   jle   @@30
   mov   eax, nMore
   jmp   @@50
@@30:
   je    @@40
   mov   eax, nLess
   jmp   @@50
@@40:
   mov   eax, nEqual
@@50:
   pop   edi
   pop   esi
end;

procedure MovePoint(var Point: TPoint; DispX, DispY: Integer);
asm
   add    [eax], edx
   add    [eax+4], ecx
end;

function CloseTo(const Point1, Point2: TPoint; Distance: Integer): LongBool;
begin
 Result:=Inside(Point2, Rect(Point1.X-Distance, Point1.Y-Distance,
                             Point1.X+Distance, Point1.Y+Distance));
end;

function GetAngle(Num, Den:Double):Double;
begin
 if Den<>0 then begin
  Result:=arctan(Num/Den);
  if Den<0 then Result:=HalfCycle+Result else if Num<0 then Result:=FullCycle+Result;
 end else begin
  if Num>0 then Result:=Quadrant else Result:=3*Quadrant;
 end;
end;

function GetAlpha(Y1, Z1, Y2, Z2, Y3, Z3:Double):Double;
var A1, A2:Double;
begin
 A1:=GetAngle(Z1-Z2,Y2-Y1);
 A2:=GetAngle(Z3-Z2,Y2-Y3);
 if A2<A1 then A2:=FullCycle+A2;
 Result:=A2-A1;
end;

function GetAlphaScr(X1, Y1, X2, Y2, X3, Y3:Double):Double;
var A1, A2:Double;
begin
 A1:=GetAngle(X2-X1,Y1-Y2);
 A2:=GetAngle(X2-X3,Y3-Y2);
 if A2<A1 then A2:=FullCycle+A2;
 Result:=A2-A1;
end;

function CenterPoint(const Rect: TRect): TPoint;
asm
   push  esi
   mov   esi, eax
   mov   eax, [esi]
   add   eax, [esi+8]
   shr   eax, 1
   mov   [edx].TPoint.x, eax
   mov   eax, [esi+4]
   add   eax, [esi+12]
   shr   eax, 1
   mov   [edx].TPoint.y, eax
   pop   esi
end;

function Max(const R1,R2:Integer):Integer;overload;
asm
   cmp eax, edx
   jng @@10
   ret
@@10:
   mov eax, edx
end;

function Max(const R1,R2:Extended):Extended;overload;
begin
 if R1>R2 then Result:=R1 else Result:=R2;
end;

function Max(const P1, P2: TPoint; CompareY: LongBool=False): TPoint; overload;
var
 F: function (const Point1, Point2: TPoint): Integer;
begin
 if CompareY then F:=ComparePointY else F:=ComparePointX;
 if F(P1, P2) = nMore then Result:=P1 else Result:=P1;
end;

function Min(const R1,R2:Integer):Integer;overload;
asm
  cmp eax, edx
  jnl @@10
  ret
@@10:
  mov eax, edx
end;

function Min(const R1,R2:Extended):Extended;overload;
begin
 if R1<R2 then Result:=R1 else Result:=R2;
end;

function Min(const P1, P2: TPoint; CompareY: LongBool = False): TPoint;
var
 F: function (const Point1, Point2: TPoint): Integer;
begin
 if CompareY then F:=ComparePointY else F:=ComparePointX;
 if F(P1, P2) = nLess then Result:=P1 else Result:=P2;
end;

procedure ArrangeMin(var R1, R2: Integer);
asm
   mov   ecx, [eax]
   cmp   ecx, [edx]
   jl    @@10
   xchg  ecx, [edx]
   mov   [eax], ecx
@@10:
end;

procedure ArrangeMax(var R1, R2: Integer);
asm
   mov   ecx, [eax]
   cmp   ecx, [edx]
   jg    @@10
   xchg  ecx, [edx]
   mov   [eax], ecx
@@10:
end;

function Sign(const Value:Integer):Integer;overload;
asm
   test eax, eax
   jl   @@10
   jg   @@20
   ret
@@10:
   mov  eax, -1
   ret
@@20:
   mov  eax, 1
end;

function Sign(const Value:Extended):Extended;overload;
begin
 if Value<0 then Result:=-1.0 else
  if Value>0 then Result:=1.0 else Result:=0.0;
end;

procedure Swap(var R1, R2: Integer);overload;
asm
   mov  ecx, [eax]
   xchg ecx, [edx]
   mov  [eax], ecx
end;

procedure Swap(var R1, R2:Extended);overload;
var Temp:Extended;
begin
 Temp:=R1;
 R1:=R2;
 R2:=Temp;
end;

procedure Swap(var R1,R2:Double);overload;
asm
   mov  ecx, [eax]
   xchg ecx, [edx]
   mov  [eax], ecx
   mov  ecx, [eax+4]
   xchg ecx, [edx+4]
   mov  [eax+4], ecx
end;

procedure Swap(var R1,R2:TString);overload;
var Temp:TString;
begin
 Temp:=R1;
 R1:=R2;
 R2:=Temp;
end;

function Inside(Value,Down,Up:Integer):LongBool;overload;
asm
   cmp   edx, ecx
   jl    @@10
   xchg  ecx, edx
@@10:
   cmp   eax, edx
   jnl   @@20
   xor   eax, eax
   ret
@@20:
   cmp   eax, ecx
   setng al
   and   eax, 0FFH
end;

function Inside(Value,Down,Up:Extended):LongBool;overload;
var
 Mx,Mn:Extended;
begin
 Mx:=Max(Down,Up);
 Mn:=Min(Down,Up);
 Result:=(Value>=Mn) and (Value<=Mx);
end;

function Inside(const Point:TPoint;const Rect:TRect):LongBool;overload;
asm
   push  esi
   push  edi
   push  ebx
   mov   esi, eax
   mov   edi, edx
   mov   eax, [esi]
   mov   edx, [edi]
   mov   ecx, [edi+8]
   call  Inside
   mov   ebx, eax
   mov   eax, [esi+4]
   mov   edx, [edi+4]
   mov   ecx, [edi+12]
   call  Inside
   and   eax, ebx
   pop   ebx
   pop   edi
   pop   esi
end;

function Center(Value:Integer;HiValue:Integer;LoValue:Integer=0):Integer;
asm
   sub edx, ecx
   sub edx, eax
   shr edx, 1
   add ecx, edx
   mov eax, ecx
end;

function IncPtr(P:Pointer;Delta:Integer=1):Pointer;register;
asm
   add   eax, edx
end;

function DecPtr(P:Pointer;Delta:Integer=1):Pointer;register;
asm
   sub eax, edx
end;

function Join(const LoWord, HiWord:word):Integer;
asm
   shl   edx, 16
   and   eax, 0FFFFh
   or    eax, edx
end;

procedure SetValue(P: Pointer; Value: Integer); register;
asm
   test eax, eax
   jz   @@10
   mov  [eax], edx
@@10:
end;

procedure SetIntValue(P: Pointer; Value: Integer);
asm
   test eax, eax
   jz   @@10
   mov  [eax], edx
@@10:
end;

procedure SetWordValue(P: Pointer; Value: word);
asm
   test eax, eax
   jz   @@10
   mov  [eax], dx
@@10:
end;

procedure SetByteValue(P: Pointer; Value: byte);
asm
   test eax, eax
   jz   @@10
   mov  [eax], dl
@@10:
end;

procedure DecInt(var N: Integer; Delta: Integer = 1; Lowest: Integer = 0);
asm
   push   ebx
   mov    ebx, [eax]
   sub    ebx, edx
   cmp    ebx, ecx
   jl     @@10
   mov    [eax], ebx
   pop    ebx
   ret
@@10:
   mov    [eax], ecx
   pop    ebx
end;

procedure IncInt(var N: Integer; Delta: Integer = 1; Highest: Integer = MaxInt);
asm
   push   ebx
   mov    ebx, [eax]
   add    ebx, edx
   cmp    ebx, ecx
   jg     @@10
   mov    [eax], ebx
   pop    ebx
   ret
@@10:
   mov    [eax], ecx
   pop    ebx
end;

function RoundPrev(Value, Divider: Integer): Integer;
{begin
 Result:=(Value div Divider) * Divider;}
asm
   mov  ecx, edx
   cdq
   idiv ecx
   imul ecx
end;

function RoundNext(Value, Divider: Integer): Integer;
asm
   mov   ecx, edx
   cdq
   idiv  ecx
   imul  ecx
   add   eax, ecx
end;

function BoolToSign(B: LongBool): Integer;
asm
   test  eax, eax
   jz    @@10
   xor   eax, eax
   dec   eax
   ret
@@10:
   inc   eax
end;

function FmtString(const Str:TString;const Values:array of TString):TString;
var
 i:Integer;
begin
 Result:=Str;
 for i:=High(Values) downto Low(Values) do
   Result:=ReplaceStrAll(Result, '%'+IntToStr(i+1), Values[i]);
end;

function FindChars(const Source:TString;const Chars:TSetChar;CurrentPosition:Integer=1;Direction:Integer=1):Integer;
var
 i,len:Integer;
 Delta:Integer;
begin
 Result:=0;
 if Direction<0 then Delta:=-1 else Delta:=1;
 i:=CurrentPosition;
 len:=Length(Source);
 if Len=0 then Exit;
 repeat
  if Source[i] in Chars then begin
   Result:=i;
   Break;
  end;
  i:=i+Delta;
  if (i<1) or (i>len) then Break;
 until false;
end;

function FindLastChar(const S: TString; Ch: Char = chSpace): Integer;
asm
   test  eax, eax
   jz    @@30
   mov   ecx, [eax - 4]
   test  ecx, ecx
@@10:
   jz    @@30
   mov   dh, [eax + ecx]
   cmp   dl, dh
   jne   @@20
   mov   eax, ecx
   inc   eax
   ret
@@20:
   dec   ecx
   jmp   @@10
@@30:
   xor   eax, eax
   dec   eax
end;

function LeftTrim(const Str:TString;const Chr:Char=chSpace):TString;
var
 Count:Integer;
begin
 if Str <> '' then begin
  Result:=Str;
  Count:=0;
  while Result[Count+1] = Chr do Inc(Count);
  if Count<>0 then Delete(Result,1,Count);
 end;
end;

function LeftTrim(const Str: TString; const Chrs: TSetChar): TString; overload;
var
 Count:Integer;
begin
 if Str <> '' then begin
  Result:=Str;
  Count:=0;
  while Result[Count+1] in Chrs do Inc(Count);
  if Count<>0 then Delete(Result,1,Count);
 end;
end;


function RightTrim(const Str:TString;const Chr:Char=chSpace):TString;
var
 Count, Len:Integer;
begin
 if Str <> '' then begin
  Result:=Str;
  Count:=0;
  Len:=Length(Result);
  while Result[Len-Count] = Chr do Inc(Count);
  if Count<>0 then SetLength(Result,Length(Result)-Count);
 end; 
end;


function RightTrim(const Str: TString; const Chrs: TSetChar): TString; overload;
var
 Count, Len:Integer;
begin
 Result:=Str;
 Count:=0;
 Len:=Length(Result);
 while Result[Len-Count] in Chrs do Inc(Count);
 if Count<>0 then SetLength(Result,Length(Result)-Count);
end;

function LeftExpand(const Str:TString; Count: Integer; const Chr:Char=chSpace): TString;
var
 i:Integer;
 PS, PD: PChar;
begin
 if Count<0 then Count:=0;
 SetString(Result, nil, Length(Str)+Count);
 PS:=@Str[1];
 PD:=@Result[Count+1];
 for i:=1 to Count do Result[i]:=Chr;
 Move(PS^, PD^, Length(Str));
end;

function RightExpand(const Str:TString; Count: Integer; const Chr:Char=chSpace): TString;
var
 L: Integer;
begin
 if Count<0 then Count:=0;
 L:=GetLength(Str);
 SetString(Result, nil, L+Count);
 MoveMem(PChar(Str)^, PChar(Result)^, L);
 FillMem(PChar(@Result[L+1])^, Count, Byte(Chr));
end;

function TrimStr(const Str:TString;const Chr:Char=chSpace):TString;
begin
 if Str='' then Result:='' else Result:=LeftTrim(RightTrim(Str,Chr),Chr);
end;

function LeadTrim(const Str:TString; Count:Integer=1):TString;
begin
 if Count<0 then Count:=0;
 SetString(Result, PChar(IncPtr(PChar(Str), Count)), Length(Str)-Count);
end;

function TrailTrim(const Str:TString; Count:Integer=1):TString;
begin
 if Count<0 then Count:=0;
 SetString(Result, PChar(Str), Length(Str)-Count);
end;

function GetSubStr(const Str:TString;N:byte;Separator:Char=chSpace):TString;
var
 S: PChar;
 P1, P2: Integer;
begin
 P1:=CharEntryPos(Str, Separator, N-1);
 Inc(P1);
 S:=@Str[P1];
 P2:=CharEntryPos(S, Separator, 1);
 if P2=0 then P2:=Length(Str) else P2:=P1+P2-1;
 Result:=TrimStr(ReadSubStr(Str, P1, P2), Separator);
 if Result=Separator then Result:='';
end;

function ExtractStr(const Str:TString;N:byte):TString;
var
 P,I:Integer;
 S:TString;
begin
 S:=Str;
 for i:=1 to n-1 do begin
  P:=Pos(chSpace,S);
  S:=Copy(S,Succ(P),Length(S)-P);
  S:=LeftTrim(S);
 end;
 P:=Pos(chSpace,S);
 if P<>0 then Result:=Copy(S,1,Pred(P))
         else Result:=S;
end;

procedure ExtractStrings(Str: TString; List: TStrings; Separator: Char);
var
 P1, P2: PChar;
begin
 List.BeginUpdate;
 try
  List.Clear;
  P1:=PChar(Str);
  repeat
   P2:=StrScan(P1, Separator);
   SetByteValue(P2, 0);
   List.Add(P1);
   P1:=P2;
   Inc(P1);
  until P2 = nil;
 finally
  List.EndUpdate;
 end;
end;

function RemoveChars(const Str:TString;const Chars:TSetChar):TString;
var i:Integer;
begin
 Result:='';
 for i:=1 to Length(Str) do if not (Str[i] in Chars) then Result:=Result+Str[i];
end;

function ReplaceChar(const Str:TString;OldChar,NewChar:Char):TString;
var
 i:Integer;
begin
 Result:=Str;
 for i:=1 to Length(Result) do if Result[i]=OldChar then Result[i]:=NewChar;
end;

function ReplaceStr(const Str:TString;const OldSubStr,NewSubStr:TString):TString;
var
 P:Integer;
begin
 Result:=Str;
 P:=Pos(OldSubStr,Result);
 if P<>0 then begin
  Delete(Result,P,Length(OldSubStr));
  Insert(NewSubStr,Result,P);
 end;
end;

function __pos(SubStr, Str: TString; var P: Integer): Integer;
begin
 P:=Pos(SubStr, Str);
 Result:=P;
end;

function ReplaceStrAll(const Str: TString; const OldSubStr, NewSubStr: TString): TString;
var
 P: Integer;
 Len: Integer;
begin
 Result:=Str;
 Len:=Length(OldSubStr);
 while __pos(OldSubStr, Result, P)<>0 do begin
   Delete(Result, P, Len);
   Insert(NewSubStr, Result, P);
 end;
end;

procedure CleanUp(var Str: TString);
asm
   mov   eax, [eax]
   test  eax, eax
   jz    @@10
   push  eax
   call  GetLength
   mov   edx, eax
   pop   eax
   mov   [eax-4], edx
@@10:
end;

procedure CleanUp(var Str:TString; DoTrim: LongBool);
begin
// SetLength(Str,GetLength(Str));
 CleanUp(Str);
 if DoTrim then Str:=TrimStr(Str);
end;

function FillString(Chr:Char;Count:Integer):TString;
begin
 SetString(Result, nil, Count);
 FillChar(Pointer(Result)^, Count, Chr);
end;

function UpString(const Str:TString):TString;
begin
 Result:=Str;
 CharUpper(@Result[1]);
end;

function DnString(const Str:TString):TString;
begin
 Result:=Str;
 CharLower(@Result[1]);
end;

function GetChar(const Str:TString; Position:Integer=1):Char; register;
asm
   push  edi
   push  esi
   mov   edi, edx
   mov   esi, eax
   call  GetLength
   test  eax, eax
   jnz   @@10
   jmp   @@30
@@10:
   cmp   eax, edi
   jnb   @@20
   xor   eax, eax
   jmp   @@30
@@20:
   mov   eax, esi
   mov   edx, edi
   dec   edx
   call  ReadChar
@@30:
   pop   esi
   pop   edi
end;

function ReadChar(Ptr:Pointer;Offset:Integer):Char; register;
asm
   add   eax, edx
   mov   al, [eax]
end;

function UpChar(Ch:Char):Char; register;
asm
   and   eax, 000000FFh
   push  eax
   call  CharUpper
end;

function DnChar(Ch:Char):Char; register;
asm
   and   eax, 000000FFh
   push  eax
   call  CharLower
end;

function ReflectStr(const Str:TString):TString;
var
 i:Integer;
 len:Integer;
begin
 Len:=GetLength(Str);
 SetLength(Result,len);
 for i:=1 to Len do Result[i]:=Str[Len-i+1];
end;

function ReadSubStr(const Str:TString; Head, Tail:Integer):TString;
begin
 Result:=Copy(Str, Head, Tail-Head+1);
end;

function StrToFlt(const Str:TString;var Code:Integer):Extended;overload;
begin
 Val(PChar(Str), Result, Code);
end;

function StrToFlt(const Str:TString):Extended;overload;
var
 i:Integer;
begin
 Result:=StrToFlt(Str, i);
 if i<>0 then Result:=0;
end;

function FltToStr(const Value:Extended;Precision:Integer=5):TString;
var
 P:Integer;
begin
 Result:=FloatToStrF(Value,ffGeneral,Precision,0);
 P:=Pos(',',Result);
 if P<>0 then Result[P]:=chPoint;
 P:=Pos(DecimalSeparator,Result);
 if P<>0 then Result[P]:=chPoint;
end;

function BreakStr(const Str:TString;Len:Integer=64;AltChar:Char='\'):TString;
var
 i,j:Integer;
 Alt:Boolean;
begin
 if Length(Str)<=Len then begin
  Result:=Str;
  Exit;
 end;
 Result:='';
 i:=0;
 repeat
  j:=i+Len;
  if j>Length(Str) then begin
   j:=Length(Str);
   Result:=Result+Copy(Str,i+1,j-i);
   Exit;
  end;
  Alt:=False;
  while Str[j]<>chSpace do begin
   Dec(j);
   if j=i then begin
    Alt:=True;
    Break;
   end;
  end;
  if Alt then begin
   j:=i+Len;
   if j>Length(Str) then begin
    j:=Length(Str);
    Result:=Result+Copy(Str,i+1,j-i);
    Exit;
   end;
   while Str[j]<>AltChar do begin
    Dec(j);
    if j=i then begin
     j:=i+Len;
     Break;
    end;
   end;
  end;
  Result:=Result+Copy(Str,i+1,j-i)+#13#10;
  i:=j;
 until i>=Length(Str);
end;

function ValidInt(const Value:TString):LongBool;
var
 i,Code:Integer;
begin
 Val(Value,i,Code);
 Hole(i);
 Result:=Code=0;
end;

function ValidFloat(const Value:TString):LongBool;
var
 i:Double;
 Code:Integer;
begin
 Val(Value,i,Code);
 Hole(i);
 Result:=Code=0;
end;

function ValidFloatINF(const Value:TString): LongBool;
var
 R: Double;
 Code:Integer;
begin
 Val(Value, R, Code);
 Hole(Code);
 Result:=Infinity(R)=0;
end;


function ValidateFloat(const Value:TString):TString;
var
 P:Integer;
begin
 Result:=Value;
 P:=Pos(DecimalSeparator,Result);
 if P<>0 then Result[P]:=chPoint;
 P:=Pos(chComma,Result);
 if P<>0 then Result[p]:=chPoint;
 if not ValidFloat(Result) then Result:='';
end;

function Join(const Str1, Str2: TString): TString;
begin
 Result:='';
 if not IsEmptyStr(Str1) then Result:=PChar(@Str1[1]);
 if not IsEmptyStr(Str2) then Result:=Result+PChar(@Str2[1]);
end;

function LastChar(const Str:TString):Char;
begin
 if Str='' then Result:=chNull else Result:=Str[Length(Str)];
end;

function NextChar(const Str:TString;Pos:Integer;Passed:Char=chSpace):Char;
begin
 Result:=NextChar(Str,Pos,[Passed]);
end;

function PrevChar(const Str:TString;Pos:Integer;Passed:Char=chSpace):Char;
begin
 Result:=PrevChar(Str,Pos,[Passed]);
end;

function NextChar(const Str:TString;Pos:Integer;Passed:TSetChar):Char;overload;
var i:Integer;
begin
 Result:=#0;
 for i:=Pos+1 to Length(Str) do if not (Str[i] in Passed) then begin
  Result:=Str[i];
  Break;
 end;
end;

function PrevChar(const Str:TString;Pos:Integer;Passed:TSetChar):Char;overload;
var i:Integer;
begin
 Result:=#0;
 for i:=Pos-1 downto 1 do if not (Str[i] in Passed) then begin
  Result:=Str[i];
  Break;
 end;
end;

procedure AddString(var Str:TString; const Value:TString);
begin
 CleanUp(Str);
 Str:=Str+Value;
end;

function AdjustLength(Str: TString; Len: Integer; Ch: Char = chSpace): TString;
var
 L, N: Integer;
 S1: TString;
begin
 L:=GetStrLen(Str);
 if L<Len then begin
  N:=Len - L;
  SetString(S1, nil, N);
  FillMem(PChar(S1)^, N, Ord(Ch));
  Result:=Str+S1;
 end else Result:=Str;
end;

function CharCount(const Str:TString;Ch:Char):Integer; register;
asm
   push  edi
   test  eax, eax
   jnz   @@10
   xor   eax, eax
   jmp   @@40
@@10:
   mov   edi, eax
   xor   eax, eax
   dec   edi
@@20:
   inc   edi
   mov   dh, [edi]
   cmp   dh, dl
   jne   @@30
   inc   eax
@@30:
   test  dh, dh
   jnz   @@20
@@40:
   pop   edi
end;

function CopyToBuf(const Source:TString; Buf:PChar; Size:Integer):LongBool;
var
 Len: Integer;
begin
 Len:=GetLength(Source)+1;
 if Len>Size then begin
  Result:=False;
  Buf^:=#0;
 end else begin
  if not IsEmptyStr(Source) then MoveMem(PChar(Source)^, Buf^, Len)
                            else ClearMem(Buf^, Size);
  Result:=True;
 end;
end;

function MatchString(const Str:TString; const Values:array of TString;
                      CaseSensitive:LongBool=False):Integer;
{var
 i:Integer;
 fnTest:function(const S1,S2:TString):LongBool;
begin
 if not CaseSensitive then fnTest:=EqualText else fnTest:=EqualStr;
 Result:=0;
 for i:=Low(Values) to High(Values) do if fnTest(Str,Values[i]) then begin
  Result:=Succ(i);
  Break;
 end;}
var
   Count: LongInt;
   NS, LS: LongInt;
asm
   push  esi
   push  edi
   push  ebx
   test  eax, eax
   jnz   @@5
   mov   NS, eax
   mov   LS, eax
   lea   eax, NS
@@5:
   mov   esi, eax
   mov   edi, edx
   xor   ebx, ebx
   mov   eax, CaseSensitive
   not   eax
   and   eax, 1
   mov   CaseSensitive, eax
   mov   Count, ecx
@@10:
   cmp   ebx, Count
   jg    @@30
   push  dword ptr [esi-4]
   push  esi
   mov   eax, [edi+ebx*4]
   test  eax, eax
   jnz   @@15
   mov   NS, eax
   mov   LS, eax
   lea   eax, NS
@@15:
   push  dword ptr [eax-4]
   push  eax
   push  CaseSensitive
   push  LOCALE_USER_DEFAULT
   call  CompareString
   cmp   eax, 2
   je    @@20
   inc   ebx
   jmp   @@10
@@20:
   mov   eax, ebx
   inc   eax
   jmp   @@40
@@30:
   xor   eax, eax
@@40:
   pop   ebx
   pop   edi
   pop   esi
end;

function MatchStringEx(const Str:TString; const Values:Pointer; Count:Integer;
                            CaseSensitive:LongBool=False):Integer;
asm
   push  CaseSensitive
   call  MatchString
end;

function Among(N: Integer; const Values: array of Integer):LongBool;
asm
   push   ebx
   xor    ebx, ebx
@@10:
   test   ecx, ecx
   jl     @@30
   cmp    eax, [edx]
   jne    @@20
   not    ebx
   jmp    @@30
@@20:
   add    edx, 4
   dec    ecx
   jmp    @@10
@@30:
   mov    eax, ebx
   pop    ebx
end;

function __Parameters: TString;
var
 P: PChar;
begin
 P := GetCommandLine;
 if P^ = '"' then begin
  Inc(P);
  P := StrPos(P, '"');
  Inc(P);
 end else P := StrPos(P, ' ');
 Inc(P);
 Result:=P;
end;
 
var
 ParametersFirstCall: Boolean = True;
 ParamString: TString = '';

function Parameters: TString;
begin
 if ParametersFirstCall then begin
  ParamString:=__Parameters;
  ParametersFirstCall:=False;
 end;
 Result:=ParamString;
end;

function _GetTempDirectory: TString;
var
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 GetTempPath(SizeOf(Buf), @Buf);
 Result:=IncludeTrailingBackslash(PChar(@Buf));
end;

var
 TmpDir: TString = '';
 GetTempDirectoryFirstCall: Boolean = True;

function GetTempDirectory: TString;
begin
 if GetTempDirectoryFirstCall then begin
  TmpDir:=_GetTempDirectory;
  GetTempDirectoryFirstCall:=False;
 end;
 Result:=TmpDir;
end;

function GetTempFile(const Prefix: TString): TString;
var
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 GetTempFileName(PChar(GetTempDirectory), PChar(Prefix), 0, @Buf);
 Result:=PChar(@Buf);
end;

var
 Checked: Boolean = False;
 Embedded: Boolean = False;

function CheckAutomation: Boolean;
begin
 if not Checked then begin
  Embedded:=MatchString(Parameters, ['-EMBEDDING', '/EMBEDDING'])<>0;
  Checked:=True;
 end;
 Result:=Embedded;
end;

function ExeName:TString;
var
 S: PChar;
 P: Integer;
begin
 Result:=GetCommandLine;
 S:=@Result[2];
 P:=Pos('"', S);
 Result:=ReadSubStr(S, 1, P-1);
end;

function ExePath:TString;
begin
 Result:=ExtractFilePath(ExeName);
end;

function ExeVersion: TString;
begin
 Result:=VersionToString(FileVersion);
end;

function ProgVersion(Space: Char): TString;
var
 Ver: TString;
begin
 Result:=TrimStr(GetStringFileInfo(ExeName, sfiProductName));
 if Result = '' then begin
  Result:=ExtractFileName(ExeName);
  Result:=GetFileName(ExeName);
 end;
 Ver:=TrimStr(GetStringFileInfo(ExeName,sfiProductVersion));
 if Ver <> '' then Result := Result + Space + Ver;
end;

function InstanceName:TString;
var
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 GetModuleFileName(hInstance, Buf, MAX_PATH);
 Result:=Buf;
end;

function InstancePath:TString;
begin
 Result:=ExtractFilePath(InstanceName);
end;

function FileVersion(const FileName: TString = ''): TFileVersion;
var
 S: TString;
 hMem: HGLOBAL;
 Buf: pointer;
 BufSize, Len, dwHandle: DWORD;
 VerInfo: PVSFixedFileInfo;
 pszName: PAnsiChar;
begin
 FillChar(Result, SizeOf(Result), 0);
 S:=FileName;
 CleanUp(S, True);
 if IsEmptyStr(S) then S:=ParamStr(0);
 pszName:=@S[1];
 BufSize:=GetFileVersionInfoSize(pszName, dwHandle);
 if BufSize<>0 then begin
  hMem:=GlobalAlloc(GHND, BufSize);
  if hMem = 0 then OutOfMemoryError;
  Buf:=GlobalLock(hMem);
  if Buf=nil then OutOfMemoryError;
  GetFileVersionInfo(pszName, dwHandle, BufSize, Buf);
  VerQueryValue(Buf, '\', pointer(VerInfo), Len);
  with VerInfo^ do begin
   Result.HiVersion:=HiWord(dwFileVersionMS);
   Result.LoVersion:=LoWord(dwFileVersionMS);
   Result.Release:=HiWord(dwFileVersionLS);
   Result.Build:=LoWord(dwFileVersionLS);
  end;
  GlobalUnlock(hMem);
  GlobalFree(hMem);
 end else Result.HiVersion:=-1;
end;

function ComCtlVersion: TFileVersion;
begin
 Result:=FileVersion('COMCTL32.DLL');
end;

function IsDebug(const FileName:  TString): LongBool;
var
 S: TString;
 hMem: HGLOBAL;
 Buf: pointer;
 BufSize, Len, dwHandle: DWORD;
 VerInfo: PVSFixedFileInfo;
 pszName: PAnsiChar;
begin
 Result:=False;
 FillChar(Result, SizeOf(Result), 0);
 S:=FileName;
 CleanUp(S, True);
 if IsEmptyStr(S) then S:=ParamStr(0);
 pszName:=@S[1];
 BufSize:=GetFileVersionInfoSize(pszName, dwHandle);
 if BufSize<>0 then begin
  hMem:=GlobalAlloc(GHND, BufSize);
  if hMem = 0 then OutOfMemoryError;
  Buf:=GlobalLock(hMem);
  if Buf=nil then OutOfMemoryError;
  GetFileVersionInfo(pszName, dwHandle, BufSize, Buf);
  VerQueryValue(Buf, '\', pointer(VerInfo), Len);
  Result:=(VerInfo.dwFileFlags and VS_FF_DEBUG) <> 0;
  GlobalUnlock(hMem);
  GlobalFree(hMem);
 end;
end;

var
 IsDebugValue: Integer = Integer($80000000);

function IsDebug: LongBool; overload;
begin
 if IsDebugValue = Integer ($80000000) then IsDebugValue:=Integer(IsDebug(''));
 Result:=LongBool(IsDebugValue);
end;

procedure GetWindowSize(Handle: HWND; var Size: TSize);
var
 R: TRect;
begin
 GetWindowRect(Handle, R);
 with R, Size do begin
  cx:=Right-Left;
  cy:=Bottom-Top;
 end;
end;

procedure GetWindowCenter(Handle: HWND; CenterX, CenterY: PInteger);
var
 R: TRect;
asm
  push   esi
  push   edi
  mov    esi, ecx
  mov    edi, edx
  lea    ecx, R
  push   ecx
  push   eax
  call   GetWindowRect
  test   edi, edi
  jz     @@10
  mov    eax, R.Right
  sub    eax, R.Left
  shr    eax, 1
  mov    [edi], eax
@@10:
  test   esi, esi
  jz     @@20
  mov    eax, R.Bottom
  sub    eax, R.Top
  shr    eax, 1
  mov    [esi], eax
@@20:
  pop    edi
  pop    esi
end;

procedure PressKey(VKey: Byte);
begin
 keybd_event(VKey, 0, 0, 0);
 keybd_event(VKey, 0, KEYEVENTF_KEYUP, 0);
end;

function ForceDirectories(Dir: TString): Boolean;
begin
 try
  Result := True;
  if Length(Dir) = 0 then Abort;
  Dir := ExcludeTrailingBackslash(Dir);
  if (Length(Dir) < 3) or PathExists(Dir)
    or (ExtractFilePath(Dir) = Dir) then Exit; // avoid 'xyz:\' problem.
  Result := ForceDirectories(ExtractFilePath(Dir)) and CreateDir(Dir);
 except
  on EAbort do Result:=False;
  else raise;
 end;
end;

function StringToVersion(const Str: TString): TFileVersion;
var
 S, SH, SL, SR, SB: TString;
 Code: Integer;
 Count: Integer;
begin
 S:=Str;
 CleanUp(S, True);
 S:=ReplaceChar(S, ',','.');
 Count:=CharCount(S, '.')+1;
 SH:='0'; SL:='0'; SR:='0'; SB:='0';
 if Count>=1 then SH:=GetSubStr(S, 1, '.');
 if Count>=2 then SL:=GetSubStr(S, 2, '.');
 if Count>=3 then SR:=GetSubStr(S, 3, '.');
 if Count>=4 then SB:=GetSubStr(S, 4, '.');
 with Result do begin
  Val(SH, HiVersion, Code); if Code<>0 then HiVersion:=0;
  Val(SL, LoVersion, Code); if Code<>0 then LoVersion:=0;
  Val(SR, Release, Code); if Code<>0 then Release:=0;
  Val(SB, Build, Code); if Code<>0 then Build:=0;
 end;
end;

function VersionToString(const Ver: TFileVersion): TString;
begin
 with Ver do Result:=Format('%d.%d.%d.%d', [HiVersion, LoVersion, Release, Build]);
end;

function Version(HiVersion, LoVersion: Integer;
  Release: Integer = 0; Build: Integer = 0): TFileVersion; overload;
begin
 Result.HiVersion:=HiVersion;
 Result.LoVersion:=LoVersion;
 Result.Release:=Release;
 Result.Build:=Build;
end;

function LoadResStr(Instance:THandle;ID:Cardinal):TString;
begin
 SetLength(Result,512);
 LoadString(Instance,ID,@Result[1],512);
 CleanUp(Result);
end;

function LoadResStr(ID: Cardinal): TString; overload;
begin
 Result:=LoadResStr(hInstance, ID);
end;

function LoadDLL(const Path:TString):THandle;
begin
 Result:=LoadLibrary(PChar(Path));
end;

function GetDLLProc(Handle:THandle;const ProcName:TString):Pointer;
begin
 Result:=GetProcAddress(Handle,PChar(ProcName));
end;


var
  OSVersionInfo_Initialized: Boolean = False;
  OSVersionInfo: TOSVersionInfo;

procedure Initialize_OSVersionInfo;
begin
 if not OSVersionInfo_Initialized then begin
  ClearMem(OSVersionInfo, SizeOf(OSVersionInfo));
  OSVersionInfo.dwOSVersionInfoSize:=SizeOf(OSVersionInfo);
  GetVersionEx(OSVersionInfo);
  OSVersionInfo_Initialized:=True;
 end;
end;

function _Win32Platform: Integer;
begin
 Initialize_OSVersionInfo;
 Result:=OSVersionInfo.dwPlatformId;
end;

function _Win32MajorVersion: Integer;
begin
 Initialize_OSVersionInfo;
 Result:=OSVersionInfo.dwMajorVersion;
end;

function _Win32MinorVersion: Integer;
begin
 Initialize_OSVersionInfo;
 Result:=OSVersionInfo.dwMinorVersion;
end; 

function WinNT: Boolean;
begin
 Result:=_Win32Platform=VER_PLATFORM_WIN32_NT;
end;

function Win2K: Boolean;
begin
  Result := (_Win32MajorVersion > 4) and (_Win32Platform = VER_PLATFORM_WIN32_NT);
end;

function WinME: Boolean;
begin
  Result:=(_Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
   ((_Win32MajorVersion>4) or ((_Win32MajorVersion = 4) and (_Win32MinorVersion >= 90)));
end;

function WinXP: Boolean;
begin
 Result := (_Win32Platform = VER_PLATFORM_WIN32_NT) and
   ((_Win32MajorVersion)>5) or ((_Win32MajorVersion = 5) and (_Win32MinorVersion >= 1));
end;

var
 GetOperatingSystemFirstCall: Boolean = True;
 GetOperatingSystemResult: TOperatingSystem;

function GetOperatingSystem: TOperatingSystem;
begin
 if GetOperatingSystemFirstCall then begin
  GetOperatingSystemResult:=UndefinedWindows;
  case _Win32Platform of
   VER_PLATFORM_WIN32S: GetOperatingSystemResult:=Windows3x;
   VER_PLATFORM_WIN32_WINDOWS: begin
    if _Win32MajorVersion = 4 then begin
     if _Win32MinorVersion >= 0 then GetOperatingSystemResult:=Windows95;
     if _Win32MinorVersion >=10 then GetOperatingSystemResult:=Windows98;
     if _Win32MinorVersion >=90 then GetOperatingSystemResult:=WindowsME;
    end;
   end;
   VER_PLATFORM_WIN32_NT: begin
    if _Win32MajorVersion<=4 then GetOperatingSystemResult:=WindowsNT;
    if _Win32MajorVersion = 5 then begin
     if _Win32MinorVersion >= 0 then GetOperatingSystemResult:=Windows2000;
     if _Win32MinorVersion >= 1 then GetOperatingSystemResult:=WindowsXP;
    end;
   end;
  end;
  GetOperatingSystemFirstCall:=False;
 end;
 Result:=GetOperatingSystemResult;
end;

function WindowsVersion: TString;
var
 S: TString;
begin
 if _Win32Platform = VER_PLATFORM_WIN32_NT then S:=' NT' else S:='';
 Result:=Format('Windows%s %d.%d', [S, _Win32MajorVersion, _Win32MinorVersion]);
end;


procedure Sound(Frequency, Duration: Integer);
asm
   push  edx
   push	 eax
   call  _Win32Platform
   cmp   eax, VER_PLATFORM_WIN32_NT
   jne   @@9X
   call  Windows.Beep
   ret
@@9X:
   pop	 eax
   pop	 edx 
   push  ebx
   push  edx
   mov   bx,  ax
   mov   ax,  34DDh
   mov   dx,  0012h
   cmp   dx,  bx
   jnc   @@2
   div   bx
   mov   bx,  ax
   in    al,  61h
   test  al,  3
   jnz   @@1
   or    al,  3
   out   61h, al
   mov   al,  0B6h
   out   43h, al
@@1:
   mov   al,  bl
   out   42h, al
   mov   al,  bh
   out   42h, al
   call  Windows.Sleep
   in    al,  61h
   and   al,  0FCh
   out   61h, al
   jmp   @@3
@@2:
   pop   edx   
@@3:
   pop   ebx
end;

procedure CDDoorCmd(Cmd: TString);
var
 winmm: HINST;
 mciSendString: function (lpszCommand: PChar; lpszResturnString: PChar;
   cchReturn: UINT; hwndCallback: HWND): Integer stdcall;
begin
 winmm:=LoadLibrary('winmm.dll');
 if winmm > 32 then begin
  mciSendString:=GetProcAddress(winmm, 'mciSendStringA');
  if Assigned(mciSendString) then
   mciSendString(PChar(FmtString('SET CDAUDIO DOOR %1 WAIT', [Cmd])),
    nil, 0, 0);
  FreeLibrary(winmm);
 end;
end;

procedure OpenCD;
begin
 CDDoorCmd('OPEN');
end;

procedure CloseCD;
begin
 CDDoorCmd('CLOSED');
end;

function GetNCFontHandle(const NCFont:TNCFont):cardinal;
var
 NCM:TNonClientMetrics;
 LF:TLogFont;
 B:LongBool;
begin
 NCM.cbSize:=SizeOf(NCM);
 B:=SystemParametersInfo(SPI_GETNONCLIENTMETRICS,0,@NCM,0);
 if B then begin
  case NCFont of
   SmCaptionFont : LF:=NCM.lfSmCaptionFont;
   CaptionFont   : LF:=NCM.lfCaptionFont;
   MenuFont      : LF:=NCM.lfMenuFont;
   MessageFont   : LF:=NCM.lfMessageFont;
   StatusFont    : LF:=NCM.lfStatusFont;
   else            LF:=NCM.lfMessageFont;
  end;
  if WinNT then begin
   LF.lfCharset:=LangIDToCharset(0);
  end; 
 end else begin
  FillChar(LF,SizeOf(LF),0);
  LF.lfHeight:=-11;
  LF.lfWidth:=0;
  LF.lfCharSet:=DEFAULT_CHARSET;
  StrPCopy(@LF.lfFaceName[0],'MS Sans Serif');
 end;
 Result:=CreateFontIndirect(LF);
end;

function TrayWnd: HWND;
begin
 Result:=FindWindow('Shell_TrayWnd','');
end;

function GetDesktopRect: TRect;
var
 RgnDesktop, RgnTrayWnd: HRGN;

 function CreateWindowRgn(Handle: HWND): HRGN;
 var
  R: TRect;
 begin
  GetWindowRect(Handle, R);
  with R do
   Result:=CreateRectRgn(Left, Top, Right, Bottom);
 end;

begin
 RgnDesktop:=CreateWindowRgn(GetDesktopWindow);
 try
  RgnTrayWnd:=CreateWindowRgn(FindWindow('Shell_TrayWnd', ''));
  try
   CombineRgn(RgnDesktop, RgnDesktop, RgnTrayWnd, RGN_DIFF);
   GetRgnBox(RgnDesktop, Result);
  finally
   DeleteObject(RgnTrayWnd);
  end;
 finally
  DeleteObject(RgnDesktop);
 end;
end;


function _GetLocale: Integer;
var
 Translation: PWord;
 Buffer: Pointer;
 Size, Len, Handle: DWORD;
 Name: TString;
begin
 Name:=InstanceName;
 Size:=GetFileVersionInfoSize(PChar(Name), Handle);
 if Size = 0 then Result:=GetLocale else begin
  Buffer:=AllocateMem(Size);
  try
   GetFileVersionInfo(PChar(Name), Handle, Size, Buffer);
   VerQueryValue(Buffer, '\VarFileInfo\Translation', Pointer(Translation), Len);
   Result:=Translation^;
  finally
   DeallocateMem(Buffer);
  end;
 end;
end;

function LangIDToCharset(LangID: Integer): Byte;
var I: byte;
begin
 Result:=DEFAULT_CHARSET;
 if LangID = 0 then LangID:=_GetLocale;
 for i:=0 to LangCount do if Lo(LangID) = LangIDToCharsetInfo[i].LangID then begin
  Result:=LangIDToCharsetInfo[i].Charset;
  Break;
 end;
 if LangID = $0C1A then Result:=RUSSIAN_CHARSET;
end;

procedure OpenShortcut(var FileName: TString);
var
 ShellLink: TShellLink;
begin
 FileName:=TrimStr(FileName, '"');
 if EqualText(ExtractFileExt(FileName), '.LNK') then begin
  ShellLink:=TShellLink.Create;
  try
   ShellLink.LoadFromFile(FileName);
   FileName:=ShellLink.Path;
  finally
   ShellLink.Free;
  end;
 end;
 FileName:=GetLongName(FileName);
end;

function GetLocale: Integer;
var
 DataType: Integer;
 S: TString;
 Handle: HKEY;
 Temp: Integer;
 Size: Integer;
 Flag: Boolean;
begin
 Result:=GetSystemDefaultLCID;
 if RegOpenKeyEx(HKEY_CURRENT_USER, 'Control Panel\Desktop\ResourceLocale',
    0, KEY_READ, Handle)<>ERROR_SUCCESS then Exit;
 SetString(S, nil, 260);
 Size:=255;
 Flag:=RegQueryValueEx(Handle, '', nil, @DataType, PByte(@S[1]), @Size)=ERROR_SUCCESS;
 RegCloseKey(Handle);
 if not Flag then Exit;
 CleanUp(S, True);
 Temp:=HexToInt(S, DataType);
 if DataType<>0 then Exit;
 Result:=Temp;
end;

function ExitWindows(uFlags: UINT): BOOL;
var
 ProcessHandle: THandle;
 TokenHandle: THandle;
 Luid: Int64;
 Tkp: TTokenPrivileges;
 BufferNeeded: DWORD;
begin
 if WinNT then begin
  ProcessHandle:=GetCurrentProcess;
  OpenProcessToken(ProcessHandle, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TokenHandle);
  LookupPrivilegeValue(nil, 'SeShutdownPrivilege', Luid);
  Tkp.PrivilegeCount:=1;
  Tkp.Privileges[0].Luid:=Luid;
  Tkp.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED;
  AdjustTokenPrivileges(TokenHandle, FALSE, Tkp, 0, nil, BufferNeeded);
 end;
 Result:=ExitWindowsEx(uFlags, $FFFF);
end;

procedure RemoveDirectories(const Path: TString);
var
 S: TString;
 Len, P, i: Integer;
begin
 S:=ExcludeTrailingBackslash(Path);
 repeat
  if not RemoveDirectory(PChar(S)) then Break;
  Len:=Length(S);
  P:=0;
  for i:=Len downto 0 do if S[i] = '\' then begin
   P:=i;
   Break;
  end;
  if P = 0 then Break;
  S:=TrailTrim(S, Len-P+1);
 until False;
end;


{ There is a term in the MSDN -- "Windows 95/98: The heap managers are designed
 for memory blocks smaller than four megabytes. If you expect your memory
 blocks to be larger than one or two megabytes, you can avoid significant
 performance degradation by using the VirtualAlloc
 or VirtualAllocEx function instead."

  All the memory management routines are written to follow this rule.
 }

function LocalHandle(pMem: pointer): HLOCAL stdcall;
 external kernel32 name 'LocalHandle';

function LocalMemAlloc(Count: Integer; RecSize: Integer): Pointer;
asm
   test  eax, eax
   jle   @@10
   test  edx, edx
   jle   @@10
   imul  edx
   push  eax
   push  LHND
   call  LocalAlloc
   push  eax
   call  LocalLock
   ret
@@10:
   xor   eax, eax
end;

procedure LocalMemRealloc(var Pointer; Count: Integer; RecSize: Integer);
asm
   push  ebx
   mov   ebx, eax
   mov   eax, [ebx]
   test  eax, eax
   jnz   @@10
   mov   eax, edx
   mov   edx, ecx
   call  AllocateMem
   mov   [ebx], eax
   pop   ebx
   ret
@@10:
   push  ecx
   push  edx
   push  eax
   call  LocalHandle
   pop   edx
   pop   ecx
   test  eax, eax
   jnz   @@20
   pop   ebx
   ret
@@20:
   push  eax
   mov   eax, edx
   imul  ecx
   mov   edx, eax
   pop   eax
   push  LHND
   push  edx
   push  eax
   call  LocalRealloc
   push  eax
   call  LocalLock
   mov   [ebx], eax
   pop   ebx
end;

procedure LocalMemDealloc(var Pointer);
asm
   push  ebx
   mov   ebx, eax
   mov   eax, [ebx]
   test  eax, eax
   jz    @@10
   push  eax
   call  LocalHandle
   test  eax, eax
   jz    @@10
   push  eax
   push  eax
   call  LocalUnlock
   call  LocalFree
@@10:
   xor   eax, eax
   mov   [ebx], eax
   pop   ebx
end;

function LocalMemSize(P: Pointer): Integer;
asm
   test  eax, eax
   jnz   @@10
   ret
@@10:
   push  eax
   call  LocalHandle
   test  eax, eax
   jnz   @@20
   ret
@@20:
   push  eax
   call  LocalSize
end;

var
 AllocMemFunc: function (Count: Integer; RecSize: Integer): Pointer;
 ReallocMemFunc: procedure(var Pointer; Count: Integer; RecSize: Integer);
 DeallocMemFunc: procedure(var Pointer);
 MemSizeFunc: function(P: Pointer): Integer;

function AllocateMem(Count: Integer; RecSize: Integer = 1): Pointer;
asm
 jmp AllocMemFunc
end;

procedure ReallocateMem(var Pointer; Count: Integer; RecSize: Integer = 1);
asm
 jmp ReallocMemFunc
end;

procedure DeallocateMem(var Pointer);
asm
 jmp DeallocMemFunc
end;

function MemSize(P: Pointer): Integer;
asm
 jmp MemSizeFunc
end;

const
 MaxLocalAllocMemSize = $200000;

function Alloc9x(Count: Integer; RecSize: Integer): Pointer;
var
 Size: Integer;
begin
 Size := Count * RecSize;
 Size := Size + SizeOf(Integer);
 if Size < MaxLocalAllocMemSize
  then Result := LocalMemAlloc(Size, 1)
  else Result := VirtualAlloc(nil, Size, MEM_COMMIT, PAGE_READWRITE);
 PInteger(Result)^ := Size;
 Inc(Cardinal(Result), SizeOf(Integer));
end;

function MemSize9x(P: Pointer): Integer;
begin
 Dec(Cardinal(P), SizeOf(Integer));
 Result := PInteger(P)^ - SizeOf(Integer);
end;

procedure Dealloc9x(var Ptr);
var
 P: Pointer;
 Size: Integer;
begin
 P:=Pointer(Ptr);
 Dec(Cardinal(P), SizeOf(Integer));
 Size := PInteger(P)^;

 if Size < MaxLocalAllocMemSize
  then LocalMemDealloc(P)
  else VirtualFree(P, Size, MEM_DECOMMIT);
 Pointer(Ptr) := nil;
end;

procedure Realloc9x(var Ptr; Count: Integer; RecSize: Integer);
var
 P, NewPtr: Pointer;
 OldSize, NewSize: Integer;
begin
 P:=Pointer(Ptr);
 if P = nil then Pointer(Ptr) := Alloc9x(Count, RecSize) else begin
  OldSize := MemSize9x(P);
  NewSize := Count * RecSize;
  NewPtr := Alloc9x(NewSize, 1);
  Move(P^, NewPtr^, Min(NewSize, OldSize));
  Dealloc9x(Ptr);
  Pointer(Ptr) := NewPtr;
 end;
end;

procedure InitMemFuncs;
begin
 if WinNT then begin
  AllocMemFunc := @LocalMemAlloc;
  ReallocMemFunc := @LocalMemRealloc;
  DeallocMemFunc := @LocalMemDealloc;
  MemSizeFunc := @LocalMemSize;
 end else begin
  AllocMemFunc := @Alloc9x;
  ReallocMemFunc := @Realloc9x;
  DeallocMemFunc := @Dealloc9x;
  MemSizeFunc := @MemSize9x;
 end;
end;

function Year:word;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 Result:=S.wYear;
end;

function Month:word;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 Result:=S.wMonth;
end;

function Day:word;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 Result:=S.wDay;
end;

function DayOfWeek:word;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 Result:=S.wDayOfWeek;
end;

function Hour:word;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 Result:=S.wHour;
end;

function Minute:word;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 Result:=S.wMinute;
end;

function Second:word;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 Result:=S.wSecond;
end;

function Milliseconds:word;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 Result:=S.wMilliseconds;
end;

function Timer:Integer;
var
 S:TSystemTime;
begin
 GetLocalTime(S);
 with S do Result:=wHour*3600000+wMinute*60000+wSecond*1000+wMilliseconds;
end;

function LeapYear(Year:Word):Boolean;
begin
 if Year mod 100<>0 then Result:=(Year mod 4=0)
                    else Result:=((Year div 100) mod 4=0);
end;

function MonthLength(Month,Year:Word):Word; overload;
const Data:array[1..12] of byte = (31,28,31,30,31,30,31,31,30,31,30,31);
begin
 Result:=Data[Month];
 if (Month=2) and LeapYear(Year) then Inc(Result);
end;

function MonthLength: Word; overload;
var
 L: TSystemTime;
begin
 GetLocalTime(L);
 Result:=MonthLength(L.wMonth, L.wYear);
end;  

procedure GetLogicalDriveList(const List: TStrings);
var
 Size, Pos: Cardinal;
 Buffer: array[0..127] of AnsiChar;
 P: PChar;
begin
 List.BeginUpdate;
 try
  List.Clear;
  Size:=GetLogicalDriveStrings(SizeOf(Buffer), Buffer);
  Pos:=0;
  while Pos<Size do begin
   P:=@Buffer[Pos];
   List.Add(P);
   while Buffer[Pos]<>#0 do Inc(Pos);
   Inc(Pos);
  end;
 finally
  List.EndUpdate;
 end;
end;

procedure GetFixedDriveList(const List: TStrings);
var
 Size, Pos: Cardinal;
 Buffer: array[0..127] of AnsiChar;
 P: PChar;
begin
 List.BeginUpdate;
 try
  List.Clear;
  Size:=GetLogicalDriveStrings(SizeOf(Buffer), Buffer);
  Pos:=0;
  while Pos<Size do begin
   P:=@Buffer[Pos];
   if GetDriveType(P) = DRIVE_FIXED then List.Add(P);
   while Buffer[Pos]<>#0 do Inc(Pos);
   Inc(Pos);
  end;
 finally
  List.EndUpdate;
 end;
end;

function ChangeLayout(LANG: Integer): Boolean;
var
 Layouts: array [0..16] of HKL;
 i, Count: Integer;
begin
 Result:=False;
 Count:=GetKeyboardLayoutList(High(Layouts)+1, Layouts)-1;
 for i:=0 to Count do if (LoWord(Layouts[i]) and $FF) = LANG then
  Result:=ActivateKeyboardLayout(Layouts[i], 0)<>0;
end;


function GetStringFileInfo(const FileName: TString; const Key: TString):TString;
var
 Translation: PLongInt;
 W: PWord absolute Translation;
 Buffer, Value: Pointer;
 Size, Len, Handle: DWORD;
 Name, SFI, Lang: TString;
 P: PChar;
begin
 Name:=FileName; CleanUp(Name, True);
 if IsEmptyStr(Name) then Name:=InstanceName;
 P:=PChar(Name);
 Size:=GetFileVersionInfoSize(P, Handle);
 if Size<>0 then begin
  Buffer:=AllocateMem(Size);
  if Buffer = nil then OutOfMemoryError;
  try
   GetFileVersionInfo(P, Handle, Size, Buffer);
   VerQueryValue(Buffer, '\VarFileInfo\Translation', Pointer(Translation), Len);
   if EqualText(Key, sfiLanguageName) then begin
    VerLanguageName(W^, Buffer, Size);
    Result:=PChar(Buffer);
   end else if EqualText(Key, sfiLanguageID) then begin
    Result:=IntToStr(W^);
   end else begin
    Lang:=IntToHex(SwapWords(Translation^), 8);
    SFI:=Format('\StringFileInfo\%s\%s', [Lang, Key]);
    VerQueryValue(Buffer, PChar(SFI), Value, Len);
    Result:=PChar(Value);
   end;
  finally
   DeallocateMem(Buffer);
  end;
 end else Result:='';
end;

function GetShortName(const FileName:TString):TString;
var
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 if FileExists(FileName) then begin
  GetShortPathName(PChar(FileName), @Buf[0], SizeOf(Buf));
  Result:=PChar(@Buf[0]);
 end else Result:=FileName;
 Result:=UpString(Result);
end;

procedure LoadFile(const FileName: TString; out Buffer: Pointer; out Size: Integer);
var
 F: TFile;
begin
 F:=TFile.Open(FileName);
 try
  Size:=F.Size;
  Buffer:=AllocateMem(Size);
  try
   F.Read(Buffer^, Size);
  except
   DeallocateMem(Buffer);
   raise;
  end;
 finally
  F.Close;
 end;
end;

procedure SaveFile(const FileName: TString; Buffer: Pointer; Size: Integer);
var
 F: TFile;
begin
 F:=TFile.Create(FileName, False);
 try
  F.Write(Buffer^, Size);
 finally
  F.Close;
 end;
end;


function _GetLongName(FileName:TString):TString;
var
 SR:TSearchRec;
 Res:Cardinal;
 Path:TString;
 S1,S2,SN:TString;
begin
 CleanUp(FileName, True);
 if IsEmptyStr(FileName) then begin
  Result:='';
  Exit;
 end;
 if not FileExists(FileName) then begin
  if not PathExists(FileName) then begin
   Result:=FileName;
   Exit;
  end;
 end;
 Path:=ExtractFilePath(FileName)+'*.*';
 S1:=FileName;
 Delete(S1, 1, 1);
 if (Path<>'') and (S1<>':') and (S1<>'\') then begin
  Res:=FindFirst(Path,faAnyFile,SR);
  Result:=FileName;
  SN:=ExtractFileName(FileName);
  while Res=0 do begin
   S2:=SR.Name;
   if MatchString(SN, [SR.FindData.cAlternateFileName,S2])<>0 then begin
    Result:=_GetLongName(TrailTrim(Path,4))+'\'+S2;
    Break;
   end;
   Res:=FindNext(SR);
  end;
  FindClose(SR);
 end else Result:=FileName;
end;

function GetLongName(const FileName:TString):TString;
var
 GetLongPathName:function (pszShortName:PChar;pszLongName:PChar;
                           cchBuffer:Integer):Integer stdcall;
 Handle:hInst;
begin
 Handle:=GetModuleHandle('kernel32.dll');
 @GetLongPathName:=GetProcAddress(Handle,'GetLongPathNameA');
 if Assigned(GetLongPathName) then begin
  SetLength(Result,261);
  if GetLongPathName(PChar(FileName),PChar(Result),260)<>0 then CleanUp(Result)
                                                           else Result:=FileName;
 end else Result:=_GetLongName(FileName);
end;

function GetUserName: TString;
var
 N: Cardinal;
 Buf: array[0..1023] of AnsiChar;
begin
 N:=SizeOf(Buf)-1;
 Windows.GetUserName(Buf, N);
 Result:=PChar(@Buf[0]);
end;

function GetComputerName: TString;
var
 N: Cardinal;
 Buf: array [0..MAX_COMPUTERNAME_LENGTH + 1] of AnsiChar;
begin
 N:=SizeOf(Buf)-1;
 Windows.GetComputerName(Buf, N);
 Result:=PChar(@Buf[0]);
end;

function PathExists(const Path:TString): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Path));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function ExtractFolderName(const FileName: TString): TString;
var
 P1, P2: Integer;
begin
 P2:=FindChars(FileName, ['\'], Length(FileName), -1);
 if P2 = 0 then P2:=Length(FileName);
 P1:=FindChars(FileName, ['\'], P2-1, -1);
 Result:=ReadSubStr(FileName, P1+1, P2-1);
end;

function ChangeFileExt(const FileName, NewExt: TString): TString;
var
 P: Integer;
 Name, Ext: TString;
begin
 Name:=PChar(@FileName[1]);
 Ext:=PChar(@NewExt[1]);
 CleanUp(Ext, True);
 Ext:=LeftTrim(Ext, chPoint);
 P:=FindChars(Name, [chPoint], Length(Name), -1);
 if P = 0 then Result:=Name+chPoint+Ext
          else Result:=Copy(Name, 1, P)+Ext;
end;

function CompareVersion(const Version1, Version2: TFileVersion): Integer;
asm
   mov   ecx, [eax].TFileVersion.HiVersion
   cmp   ecx, [edx].TFileVersion.HiVersion
   jg    @@10
   jl    @@20
   mov   ecx, [eax].TFileVersion.LoVersion
   cmp   ecx, [edx].TFileVersion.LoVersion
   jg    @@10
   jl    @@20
   mov   ecx, [eax].TFileVersion.Release
   cmp   ecx, [edx].TFileVersion.Release
   jg    @@10
   jl    @@20
   mov   ecx, [eax].TFileVersion.Build
   cmp   ecx, [edx].TFileVersion.Build
   jg    @@10
   jl    @@20
   xor   eax, eax
   ret
@@10:
   xor   eax, eax
   inc   eax
   ret
@@20:
   xor   eax, eax
   dec   eax
   ret
end;

function GetFileName(const FileName:TString):TString;
begin
 Result:=TrailTrim(ExtractFileName(FileName),Length(ExtractFileExt(FileName)));
end;

function GetAbsoluteFileName(CurrentDir, RelativeName: TString): TString;

 function IsAbsoluteFileName(FileName: TString): Boolean;
 var
  P: PWord;
 begin
  P:=PWord(PChar(FileName));
  Result:=P^=$5C5C; // Network name
  if not Result then begin
   P:=IncPtr(P, 1);
   Result:=P^=$5C3A; // Local name
  end;
 end;

 procedure RemoveLastSubDir(var Dir: TString);
 var
  P: Integer;
 begin
  P:=Length(Dir);
  while ( P > 0) and ( Dir[P]<>'\') do Dec(P);
  if P = 0 then Dir:='' else Dir:=Copy(Dir, 1, P-1);
 end;

 function FindDots(Name: TString; var P: Integer): Integer;
 var
  Ptr: PInteger;
 begin
  Ptr:=IncPtr(PChar(Name), P);
  while ( P >= 0 ) and ( (Ptr^ and $00FFFFFF) <> $5C2E2E) do begin
   Dec(P);
   Ptr:=IncPtr(Ptr, -1);
  end;
  Inc(P);
  Result:=P;
 end;

var
 Drive: TString;
 P: Integer;
begin
 if IsAbsoluteFileName(RelativeName) then Result:=RelativeName else begin
  CurrentDir:=RightTrim(CurrentDir, '\');
  RelativeName:=LeftTrim(RelativeName, '\');
  Drive:=ExtractFileDrive(CurrentDir);
  Delete(CurrentDir, 1, Length(Drive)+1);
  P:=Length(RelativeName) - 3;
  while (FindDots(RelativeName, P) > 0) do begin
   Delete(RelativeName, P, 3);
   RemoveLastSubDir(CurrentDir);
   Dec(P);
  end;
  Result:=IncludeTrailingBackslash(Drive+'\'+CurrentDir)+RelativeName;
 end;
end;

function GetDiskFreeSize(Dir: TString): Int64;
var
 GetDiskFreeSpaceEx: function(Root: PChar; FBA, TNB, TNFB: PInt64): BOOL stdcall;
 GetDiskFreeSpace: function(Root: PChar; SPC, BPS, NFC, TNC: LPDWORD): BOOL stdcall;
 Handle: HINST;
 Dummy: Int64;
 SPC, BPS, NFC: DWORD;
begin
 Handle:=GetModuleHandle('kernel32.dll');
 GetDiskFreeSpaceEx:=GetProcAddress(Handle, 'GetDiskFreeSpaceExA');
 if Assigned(GetDiskFreeSpaceEx) then begin
  if not GetDiskFreeSpaceEx(PChar(Dir), @Result, @Dummy, @Dummy) then Result:=-1;
 end else begin
  GetDiskFreeSpace:=GetProcAddress(Handle, 'GetDiskFreeSpaceA');
  if Assigned(GetDiskFreeSpace) and
  GetDiskFreeSpace(PChar(Dir), @SPC, @BPS, @NFC, PDWORD(@Dummy))
   then Result:=SPC*BPS*NFC else Result:=-1;
 end;
end;


function GetColor(Color: Integer): Integer; register;
asm
   cmp   eax, 0
   jge   @@10
   and   eax, 000000FFH
   push  eax
   call  GetSysColor
@@10:
end;

function GetColor(Red, Green, Blue: Integer): Integer; register;
asm
   and   eax, 0FFh
   and   edx, 0FFh
   and   ecx, 0FFh
   shl   edx, 8
   shl   ecx, 16
   or    eax, ecx
   or    eax, edx
end;

procedure IndexToRGB(Color: Integer; R, G, B : PByte);
asm
   push ebx
   mov  ebx, b
   test edx, edx
   jz   @@GREEN
   mov  [edx], al
@@GREEN:
   shr  eax, 8
   test ecx, ecx
   jz   @@BLUE
   mov  [ecx], al
@@BLUE:
   shr eax, 8
   test ebx, ebx
   jz   @@QUIT
   mov  [ebx], al
@@QUIT:
   pop ebx
end;


procedure Line(DC: HDC; X1, Y1, X2, Y2: Integer);
begin
 MoveToEx(DC, X1, Y1, nil);
 LineTo(DC, X2, Y2);
end;

function clGradientActiveCaption: Integer;
var
 B: BOOL;
begin
 SystemParametersInfo(SPI_GETGRADIENTCAPTIONS, 0, @B, 0);
 if B then Result:=GetSysColor(COLOR_GRADIENTACTIVECAPTION)
  else Result:=GetSysColor(COLOR_ACTIVECAPTION);
end;


function ValueToName(Value:Integer;Map:array of TIdentMapItem; Default: TString = ''):TString;
var i:Integer;
begin
 Result:=Default;
 for i:=Low(Map) to High(Map) do if Map[i].Value=Value then begin
  Result:=Map[i].Name;
  Break;
 end;
end;

function NameToValue(Name:TString;Map:array of TIdentMapItem; Default: Integer = 0):Integer;
var i:Integer;
begin
 Result:=Default;
 for i:=Low(Map) to High(Map) do if Map[i].Name=Name then begin
  Result:=Map[i].Value;
  Break;
 end;
end;

const
 NPUControl   : word = $1C3F;
 NPUCtrlRound : word = $133F;
 NPUCtrlFloor : word = $143F;
 NPUCtrlCeil  : word = $183F;
 SaveNPUCtrl  : word = $0000;

function Int(R: Extended):Extended;
asm
  fclex
  fstcw   SaveNPUCtrl
  fldcw   NPUControl
  fld     R
  frndint
  fwait
  fldcw   SaveNPUCtrl
end;

function Frac(R:Extended):Extended;
begin
 Result:=R-Int(R);
end;

function Trunc(R:Extended):Integer;
var
 ERX: LongInt;
asm
  fclex
  fstcw SaveNPUCtrl
  fldcw NPUControl
  fld   R
  fistp dword ptr ERX
  fwait
  fldcw SaveNPUCtrl
  mov   eax, ERX
end;

function Round(R:Extended):Integer;
var
  ERX: LongInt;
asm
  fclex
  fstcw SaveNPUCtrl
  fldcw NPUCtrlRound
  fld   R
  fistp dword ptr ERX
  fwait
  fldcw SaveNPUCtrl
  mov   eax, ERX
end;

function Floor(R:Extended):Extended;
asm
  fclex
  fstcw   SaveNPUCtrl
  fldcw   NPUCtrlFloor
  fld     R
  frndint
  fwait
  fldcw   SaveNPUCtrl
end;

function Ceil(R:Extended):Extended;
asm
  fclex
  fstcw   SaveNPUCtrl
  fldcw   NPUCtrlCeil
  fld     R
  frndint
  fwait
  fldcw   SaveNPUCtrl
end;

function Arctan2(X, Y: Extended): Extended;
asm
        FLD     X
        FLD     Y
        FPATAN
        FWAIT
end;

procedure ClearFPUEx;
asm
   FCLEX
end;

function Infinity(R:Extended):Integer;
var
 P:^cardinal;
 N:Integer;
begin
 N:=Integer(@R)+6;
 P:=Pointer(N);
 case P^ of
  $7FFF8000:Result:=1;
  $FFFF8000:Result:=-1;
  else Result:=0;
 end;
end;

function NonAtNumber(R:Extended):Boolean;
var
 P:^cardinal;
 N:Integer;
begin
 N:=Integer(@R)+6;
 P:=Pointer(N);
 PByte(P)^:=0;
 Result:=P^=$FFFFC000;
end;

function LoadTextFile(const FileName:TString; var Text:TString):Integer;
var
 F: File;
 Count:Integer;
begin
 {$I-}
 AssignFile(F,FileName); Reset(F,1);
 Count:=FileSize(F)+10;
 Setlength(Text, Count);
 BlockRead(F, PChar(Text)^, Count);
 CleanUp(Text);
 CloseFile(F);
 {$I+}
 Result:=IOResult;
end;

function SaveTextFile(const FileName, Text: TString):Integer;
var
 F:File;
 Count:Integer;
begin
 {$I-}
 AssignFile(F,FileName); Rewrite(F,1);
 Count:=Length(Text);
 BlockWrite(F, PChar(Text)^, Count);
 CloseFile(F);
 {$I+}
 Result:=IOResult;
end;

function Incr(var N:Integer):Integer; register;
asm
   mov  edx, [eax]
   inc  edx
   mov  [eax], edx
   mov  eax, edx
end;

function Decr(var N:Integer):Integer; register;
asm
   mov  edx, [eax]
   dec  edx
   mov  [eax], edx
   mov  eax, edx
end;

function HiLong(const N: TWideInt): LongInt;
asm
   mov   eax, [eax+4]
end;

function LoLong(const N: TWideInt): LongInt;
asm
   mov   eax, [eax]
end;

function HiWord(N: Integer): word;
asm
   shr   eax, 16
end;

function LoWord(N: Integer): word;
asm
   and   eax, 0FFFFh;
end;

function HiByte(W: Word): Byte;
asm
   shr   ax, 8
end;

function LoByte(W: Word): Byte;
asm
   and   ax, 0FFh
end;

function AbsSub(N1, N2: Integer): Integer;
asm
   sub   eax, edx
   test  eax, eax
   jl    @@10
   ret
@@10:
   neg   eax
end;

function Bit(Value, Index: Integer): Boolean;
asm
   bt    eax, edx
   setc  al
   and   eax, 0FFh
end;


function SwapWords(Value: Integer): Integer;
asm
   mov   ecx, eax
   shl   ecx, 16
   shr   eax, 16
   or    eax, ecx
end;

function AbsInt(Value: Integer): Integer;
asm
   test  eax, eax
   jl    @@10
   ret
@@10:
   neg   eax
end;

function DivMod(Numenator, Denominator: Integer; out Remainder: Integer): Integer;
asm
   push   ebx
   mov    ebx, edx
   cdq
   idiv   ebx
   mov    [ecx], edx
   pop    ebx
end;

function GetAddress: Pointer;
asm
   mov   eax, [esp]
   add   eax, -5
end;

procedure MoveMem(const Source; var Dest; Count: Integer);
asm
   push  esi
   push  edi
   mov   esi, eax
   mov   edi, edx
   mov   eax, ecx
   cmp   edi, esi
   ja    @@10
   je    @@20
   sar   ecx, 2
   js    @@20
   rep   movsd
   mov   ecx, eax
   and   ecx, 3
   rep   movsb
   jmp   @@20
@@10:
   lea   esi, [esi+ecx-4]
   lea   edi, [edi+ecx-4]
   sar   ecx, 2
   js    @@20
   std
   rep   movsd
   mov   ecx, eax
   and   ecx, 3
   add   esi, 3
   add   edi, 3
   rep   movsb
   cld
@@20:
   pop   edi
   pop   esi
end;

procedure InvertMem(var X; Size:Integer=1);
asm
   push   esi
   mov    esi, eax
   mov    eax, edx
   sar    edx, 2
@@10:
   test   edx, edx
   jz     @@20
   mov    ecx, [esi]
   not    ecx
   mov    [esi], ecx
   add    esi, 4
   dec    edx
   jmp    @@10
@@20:
   mov    edx, eax
   and    edx, 3
@@30:
   test   edx, edx
   jz     @@40
   mov    cl, [esi]
   not    cl
   mov    [esi], cl
   inc    esi
   dec    edx
   jmp    @@30
@@40:
   pop    esi
end;

procedure XorMem(var X; Size: Integer; Value: Byte);
asm
   test   edx, edx
   jz     @@10
   xor    [eax], cl
   inc    eax
   dec    edx
   jmp    XorMem
@@10:
end;

procedure XorMemW(var X; Count: Integer; Value: Word);
asm
   test   edx, edx
   jz     @@10
   xor    [eax], cx
   add    eax, 2
   dec    edx
   jmp    XorMemW
@@10:
end;

procedure XorMemL(var X; Count: Integer; Value: LongInt);
asm
   test   edx, edx
   jz     @@10
   xor    [eax], ecx
   add    eax, 4
   dec    edx
   jmp    XorMemL
@@10:
end;

procedure FillMem(var X; Size: Integer; Value: Byte = 0);
asm
   push   edi
   mov    edi, eax
   mov    ch, cl
   mov    ax, cx
   shl    eax, 16
   mov    ax, cx
   mov    ecx, edx
   sar    ecx, 2
   rep    stosd
   mov    ecx, edx
   and    ecx, 3
   rep    stosb
   pop    edi
end;

procedure FillMemW(var X; Count: Integer; Value: Word = 0);
asm
   push   edi
   mov    edi, eax
   mov    ax, cx
   mov    ecx, edx
   rep    stosw
   pop    edi
end;

procedure FillMemL(var X; Count: Integer; Value: LongInt = 0);
asm
   push   edi
   mov    edi, eax
   mov    eax, ecx
   mov    ecx, edx
   rep    stosd
   pop    edi
end;

procedure ClearMem(var X; Size: Integer);
asm
   push   edi
   mov    edi, eax
   xor    eax, eax
   mov    ecx, edx
   sar    ecx, 2
   rep    stosd
   mov    ecx, edx
   and    ecx, 3
   rep    stosb
   pop    edi
end;

function GetLength(const Str: TString): Integer; register;
asm
   test  eax, eax
   jz    @@20
   mov   edx, eax
   dec   eax
@@10:
   inc   eax
   mov   cl, [eax]
   test  cl, cl
   jnz   @@10
   sub   eax, edx
@@20:
end;

function GetStrLen(const Str: TString): Integer;
asm
   test  eax, eax
   jz    @@10
   mov   eax, [eax-4]
@@10:
end;

function IsEmptyStr(const Str: TString): LongBool; register;
asm
   test  eax, eax
   jz    @@10
   mov   al, [eax]
   test  al, al
   setz  al
   and   eax, 0FFh
   ret
@@10:
   inc   al
end;

function CharEntryPos(const Str: TString; Ch: Char; Entry: Integer): Integer; register;
asm
   push  edi
   push  esi
   test  eax, eax
   jnz   @@10
   xor   eax, eax
   jmp   @@50
@@10:
   cmp   ecx, 0
   jnz   @@20
   xor   eax, eax
   jmp   @@50
@@20:
   mov   edi, eax
   dec   edi
   xor   esi, esi
@@30:
   inc   edi
   mov   dh, [edi]
   test  dh, dh
   jnz   @@40
   xor   eax, eax
   jmp   @@50
@@40:
   cmp   dh, dl
   jne   @@30
   inc   esi
   cmp   esi, ecx
   jne   @@30
   sub   edi, eax
   mov   eax, edi
   inc   eax
@@50:
   pop   esi
   pop   edi
end;

procedure ReplaceText(const SubStr: TString; var Str: TString; Pos, Len: Integer);
begin
 Delete(Str, Pos, Len);
 Insert(SubStr, Str, Pos);
end;

function EqualText(const S1, S2: TString): LongBool;
var
   Nullum: LongInt;
asm
   xor   ecx, ecx
   mov   Nullum, ecx
   test  edx, edx
   jz    @@10
   mov   ecx, [edx-4]
   jmp   @@20
@@10:
   lea   edx, Nullum
@@20:
   push  ecx
   push  edx
   xor   ecx, ecx
   test  eax, eax
   jz    @@30
   mov   ecx, [eax-4]
   jmp   @@40
@@30:
   lea   eax, Nullum
@@40:   
   push  ecx
   push  eax
   push  NORM_IGNORECASE
   push  LOCALE_USER_DEFAULT
   call  CompareString
   cmp   eax, 2
   setz  al
   and   eax, 0FFh
end;

function EqualStr(const S1, S2: TString): LongBool;
var
   Nullum: LongInt;
asm
   xor   ecx, ecx
   mov   Nullum, ecx
   test  edx, edx
   jz    @@10
   mov   ecx, [edx-4]
   jmp   @@20
@@10:
   lea   edx, Nullum
@@20:
   push  ecx
   push  edx
   xor   ecx, ecx
   test  eax, eax
   jz    @@30
   mov   ecx, [eax-4]
   jmp   @@40
@@30:
   lea   eax, Nullum
@@40:   
   push  ecx
   push  eax
   push  0
   push  LOCALE_USER_DEFAULT
   call  CompareString
   cmp   eax, 2
   setz  al
   and   eax, 0FFh
end;

function IntToStrLen(N: Integer; Len: Integer = 0): TString;
begin
 Result:=IntToStr(N);
 if GetStrLen(Result)<Len then Result:=FillString('0',Len-GetStrLen(Result))+Result;
end;

function GetPos(const SubStr, Str: TString; CaseSensitive: LongBool = True): Integer;
var
  PTX, CSX: Integer;
asm
   push  esi
   push  edi
   push  ebx
   test  eax, eax
   jz    @@20
   test  edx, edx
   jz    @@20
   mov   esi, eax
   mov   edi, edx
   mov   ptx, edx
   mov   ebx, [esi-4]
   not   ecx
   and   ecx, 1
   mov   CSX, ecx
   dec   edi
@@10:
   inc   edi
   mov   al, [edi]
   test  al, al
   jz    @@20
   push  ebx
   push  esi
   push  ebx
   push  edi
   push  csx
   push  LOCALE_USER_DEFAULT
   call  CompareString
   cmp   eax, 2
   jne   @@10
   mov   eax, edi
   sub   eax, ptx
   inc   eax
   jmp   @@30
@@20:
   xor   eax, eax
@@30:
   pop   ebx
   pop   edi
   pop   esi
end;

function GUIDToString(const GUID: TGUID): TString;
var
 S1, S2, S3: TString;
 S401: TString;
 S427: TString;
 i: Integer;
begin
 S1:=IntToHex(GUID.D1, 8);
 S2:=IntToHex(GUID.D2, 4);
 S3:=IntToHex(GUID.D3, 4);
 S401:=IntToHex(GUID.D4[0], 2)+IntToHex(GUID.D4[1], 2);
 S427:='';
 for i:=2 to 7 do S427:=S427+IntToHex(GUID.D4[i],2);
 Result:=Format('{%s-%s-%s-%s-%s}', [S1, S2, S3, S401, S427]);
end;


function CreateGUID(out GUID: TGUID): HResult; stdcall;

 const
  Funcs: array[Boolean] of TString = ('UuidCreate', 'UuidCreateSequential');

 function DoCreate(Func: TString; out GUID: TGUID): HResult;
 var
  UuidCreateFunc : function (var guid: TGUID): LongInt stdcall;
  RPCRT4: HINST;
 begin
  RPCRT4:=LoadLibrary('RPCRT4.DLL');
  UuidCreateFunc:=GetProcAddress(RPCRT4, PChar(Func));
  Result:=UuidCreateFunc(GUID);
  FreeLibrary(RPCRT4);
 end;

begin
 Result:=DoCreate(Funcs[Win2K or WinME], GUID);
end;

const
 LTRS   : array [0..26] of Char = ' ABCDEFGHIJKLMNOPQRSTUVWXYZ';

function LetterToNumber(const Letter: TString): Integer;
var
 Ch1, Ch2: Integer;
 L: Integer;
begin
 L:=GetLength(Letter);
 if Inside(L, 1, 2) then begin
  if Length(Letter)=1 then begin
   Ch1:=0; Ch2:=Ord(Letter[1])-64;
  end else begin
   Ch1:=Ord(Letter[1])-64; Ch2:=Ord(Letter[2])-64;
  end;
  Result:=Ch1*26+Ch2;
 end else Result:=-1;
end;

function NumberToLetter(Number: Integer): TString;
var
 C1, C2: Integer;
begin
 if Inside(Number, 1, 702) then begin
  C2:=Number mod 26;
  if C2 = 0 then C2:=26;
  C1:=(Number - C2) div 26;
  Result:=LeftTrim(LTRS[C1]+LTRS[C2]);
 end else Result:='';
end;

procedure SplitAlphanumericName(const Name: TString; var Alpha: TString;
 var Num: Integer; const AdditionalChars: TSetChar = []);
var
 _num: TString;
 i, Len, P, Code: Integer;
 Ch: Char;
begin
 Len:=Length(Name);
 P:=0;
 for i:=Len downto 1 do begin
  Ch:=Name[i];
  if IsCharAlpha(Ch) or (Ch in AdditionalChars) then begin
   P:=i;
   Break;
  end;
 end;
 if P = 0 then begin
  Alpha:=Name;
  Num:=0;
 end else begin
  Alpha:=Copy(Name, 1, P);
  _num:=Copy(Name, P+1, Len-P);
  val(_num, Num, Code);
 end;
end;

function HexToInt(const Hex: TString; var Code: Integer): Integer;
var
 I: Integer;
 C: Integer;
 N: Integer;
 Ch: Char;
begin
 Result:=0;
 Code:=0;
 C:=0;
 for i:=Length(Hex) downto 1 do begin
  Ch:=Hex[i];
  Hole(N);
  case Ch of
   '0'..'9': N:=Ord(Ch)-Ord('0');
   'A'..'F': N:=Ord(Ch)-Ord('A')+10;
   'a'..'f': N:=Ord(Ch)-Ord('a')+10;
   else begin
    Result:=0;
    Code:=i;
    Exit;
   end;
  end;
  N:=N shl C;
  Result:=Result or N;
  Inc(C, 4);
 end;
end;


function UrlEncode(Str: TString): TString;

function CharToHex(Ch: Char): Integer;
 asm
    and   eax, 0FFh
    mov   ah, al
    shr   al, 4
    and   ah, 00fh
    cmp   al, 00ah
    jl    @@10
    sub   al, 00ah
    add   al, 041h
    jmp   @@20
@@10:
    add   al, 030h
@@20:
    cmp   ah, 00ah
    jl    @@30
    sub   ah, 00ah
    add   ah, 041h
    jmp   @@40
@@30:
    add   ah, 030h
@@40:
    shl   eax, 8
    mov   al, '%'
end;

var
 i, Len: Integer;
 Ch: Char;
 N: Integer; P: PChar;
begin
 Result:='';
 Len:=Length(Str);
 P:=PChar(@N);
 for i:=1 to Len do begin
  Ch:=Str[i];
  if Ch in ['0'..'9', 'A'..'Z', 'a'..'z', '_'] then Result:=Result+Ch else begin
   if Ch = ' ' then Result:=Result+'+' else begin
    N:=CharToHex(Ch);
    Result:=Result+P;
   end;
  end;
 end;
end;

function UrlDecode(Str: TString): TString;

function HexToChar(W: word): Char;
asm
   cmp   ah, 030h
   jl    @@error
   cmp   ah, 039h
   jg    @@10
   sub   ah, 30h
   jmp   @@30
@@10:
   cmp   ah, 041h
   jl    @@error
   cmp   ah, 046h
   jg    @@20
   sub   ah, 041h
   add   ah, 00Ah
   jmp   @@30
@@20:
   cmp   ah, 061h
   jl    @@error
   cmp   al, 066h
   jg    @@error
   sub   ah, 061h
   add   ah, 00Ah
@@30:
   cmp   al, 030h
   jl    @@error
   cmp   al, 039h
   jg    @@40
   sub   al, 030h
   jmp   @@60
@@40:
   cmp   al, 041h
   jl    @@error
   cmp   al, 046h
   jg    @@50
   sub   al, 041h
   add   al, 00Ah
   jmp   @@60
@@50:
   cmp   al, 061h
   jl    @@error
   cmp   al, 066h
   jg    @@error
   sub   al, 061h
   add   al, 00Ah
@@60:
   shl   al, 4
   or    al, ah
   ret
@@error:
   xor   al, al
end;

function GetCh(P: PChar; var Ch: Char): Char;
begin
 Ch:=P^;
 Result:=Ch;
end;

var
 P: PChar;
 Ch: Char;
begin
 Result:='';
 P:=@Str[1];
 while GetCh(P, Ch) <> #0 do begin
  case Ch of
   '+': Result:=Result+' ';
   '%': begin
    Inc(P);
    Result:=Result+HexToChar(PWord(P)^);
    Inc(P);
   end;
   else Result:=Result+Ch;
  end;
  Inc(P);
 end;
end;


procedure ParseUrl(const Url: TString;
 out Protocol, Host, Port, Path, Hash: TString);
var
 S: TString;
 P1, P2: PChar;
begin
 S := PChar(@Url[1]);
 P1 := @S[1];
 P2 := StrPos(P1, '://');
 if Assigned(P2) then begin
  P2^ := #0;
  Protocol := P1;
  P1 := IncPtr(P2, 3);
 end else Protocol:='';
 P2 := StrPos(P1, '/');
 Path := '/';
 if Assigned(P2) then begin
  P2^ := #0;
  Inc(P2);
  Path := Path + P2;
 end;
 P2 := StrPos(P1, ':');
 if Assigned(P2) then begin
  P2^ := #0;
  Inc(P2);
  Port := P2;
 end else Port := '';
 Host := P1;
 P1 := PChar(Path);
 P2 := StrPos(P1, '#');
 if Assigned(P2) then begin
  P2^ := #0;
  Inc(P2);
  CleanUp(Path);
  Hash := P2;
 end else Hash := '';
end;



function CreateInstance(CLSID, IID: TGUID; out Instance): HResult;
begin
 Result:=CoCreateInstance(CLSID, nil, CLSCTX_INPROC_SERVER, IID, Instance);
 if (Result <> S_OK) and Assigned(CannotCreateInstance) then CannotCreateInstance(CLSID);
end;

function Recycle(const Name: TString; Wnd: HWND = 0): Boolean;
var
 FileOp: TSHFileOpStruct;
begin
 ClearMem(FileOp, SizeOf(FileOp));
 if Wnd = 0 then Wnd := TrayWnd;
 FileOp.Wnd:=Wnd;
 FileOp.wFunc:=FO_DELETE;
 FileOp.pFrom:=PChar(Name);
 FileOp.fFlags:=FOF_ALLOWUNDO or FOF_NOERRORUI or FOF_SILENT;
 Result:=(SHFileOperation(FileOp) = 0) and (not FileOp.fAnyOperationsAborted);
end;

function MapNetworkDrive(Wnd: HWND = 0): DWORD;
begin
 if Wnd = 0 then Wnd:=TrayWnd;
 Result:=WNetConnectionDialog(Wnd, RESOURCETYPE_DISK);
end;

function DisconnectNetworkDrive(Wnd: HWND = 0): DWORD;
begin
 if Wnd = 0 then Wnd:=TrayWnd;
 Result:=WNetDisconnectDialog(Wnd, RESOURCETYPE_DISK);
end;

function BitsPerPixel: Integer;
var
 DH: HWND;
 DC: HDC;
begin
 DH:=GetDesktopWindow;
 DC:=GetDC(DH);
 Result:=GetDeviceCaps(DC, BITSPIXEL);
 ReleaseDC(DH, DC);
end;

function RegWriteStr(RootKey: HKEY; Key, Name, Value: TString): Boolean;
var
 Handle: HKEY;
 Res: LongInt;
begin
 Result:=False;
 Res:=RegCreateKeyEx(RootKey, PChar(Key), 0, nil, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS,
  nil, Handle, nil);
 if Res<>ERROR_SUCCESS then Exit;
 Res:=RegSetValueEx(Handle, PChar(Name), 0, REG_SZ, PChar(Value), Length(Value)+1);
 Result:=Res=ERROR_SUCCESS;
 RegCloseKey(Handle);
end;

function RegQueryStr(RootKey: HKEY; Key, Name: TString; Success: PBoolean = nil): TString;
var
 Handle: HKEY;
 Res: LongInt;
 DataType, DataSize: DWORD;
begin
 SetByteValue(Success, Byte(False));
 Res:=RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_QUERY_VALUE, Handle);
 if Res<>ERROR_SUCCESS then Exit;
 Res:=RegQueryValueEx(Handle, PChar(Name), nil, @DataType, nil, @DataSize);
 if (Res<>ERROR_SUCCESS) or (DataType<>REG_SZ) then begin
  RegCloseKey(Handle);
  Exit;
 end;
 SetString(Result, nil, DataSize-1);
 Res:=RegQueryValueEx(Handle, PChar(Name), nil, @DataType, PByte(@Result[1]), @DataSize);
 if Res = ERROR_SUCCESS then SetByteValue(Success, Byte(True));
 RegCloseKey(Handle);
end;

function RunApplication(Path, CmdLine, Dir: TString; Wait: Boolean = False): Cardinal;
var
 StartUpInfo: TStartUpInfo;
 ProcessInformation: TProcessInformation;
begin
 FillChar(StartUpInfo, SizeOf(StartUpInfo), 0);
 FillChar(ProcessInformation, SizeOf(ProcessInformation), 0);
 CleanUp(Path, True);
 CleanUp(CmdLine, True);
 CleanUp(Dir, True);
 if IsEmptyStr(CmdLine) then CmdLine:=chSpace;
 Result:=0;
 if CreateProcess(PChar(Path), PChar(CmdLine), nil, nil, False, NORMAL_PRIORITY_CLASS,
  nil, PChar(Dir), StartUpInfo, ProcessInformation) then begin
  Result:=ProcessInformation.hProcess;
  if Wait then begin
   WaitForSingleObject(Result, INFINITE);
   Result:=1;
  end;
 end;
end;

procedure UniteLists(List1, List2: TStrings);
var
 C: Integer;
 i: Integer;
 S: TString;
begin
 C:=List2.Count-1;
 for i:=0 to C do begin
  S:=List2[i];
  if List1.IndexOf(S)=-1 then List1.Add(S);
 end;
end;


{ TShellLink }

constructor TShellLink.Create;
begin
 inherited Create;
 OleInitialize(nil);
 CreateInstance(CLSID_ShellLink, IShellLink, FShellLink);
 if Assigned(FShellLink) then FShellLink.QueryInterface(IPersistFile, FPersistFile);
end;

function TShellLink.DesktopFolder: TString;
begin
 if IsEmptyStr(FDesktopFolder) then
  FDesktopFolder:=IncludeTrailingBackslash(SpecialFolder(CSIDL_DESKTOP));
 Result:=FDesktopFolder;
end;

destructor TShellLink.Destroy;
begin
 FPersistFile:=nil;
 FShellLink:=nil;
 inherited Destroy;
end;

function TShellLink.GetArguments: TString;
var
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 Result:='';
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetArguments(@Buf[0], MAX_PATH);
  RunError(SShellLinkReadError);
  Result:=PChar(@Buf[0]);
 end;
end;

function TShellLink.GetDescription: TString;
var
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 Result:='';
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetDescription(@Buf[0], MAX_PATH);
  RunError(SShellLinkReadError);
  Result:=PChar(@Buf[0]);
 end;
end;

function TShellLink.GetHotKey: Word;
begin
 Result:=0;
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetHotKey(Result);
  RunError(SShellLinkReadError);
 end;
end;

function TShellLink.GetIconIndex: Integer;
var
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 Result:=-1;
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetIconLocation(@Buf[0], MAX_PATH, Result);
  RunError(SShellLinkReadError);
 end;
end;

function TShellLink.GetIconLoc: TString;
var
 Dummy: Integer;
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 Result:='';
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetIconLocation(@Buf[0], MAX_PATH, Dummy);
  RunError(SShellLinkReadError);
  Result:=PChar(@Buf[0]);
 end;
end;

function TShellLink.GetPath: TString;
var
 Dummy: TWin32FindData;
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 Result:='';
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetPath(@Buf[0], MAX_PATH, Dummy, SLGP_UNCPRIORITY);
  RunError(SShellLinkReadError);
  Result:=PChar(@Buf[0]);
 end;
end;

function TShellLink.GetPIDL: PItemIDList;
begin
 Result:=nil;
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetIDList(Result);
  RunError(SShellLinkReadError);
 end;
end;

function TShellLink.GetShowCmd: Integer;
begin
 Result:=-1;
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetShowCmd(Result);
  RunError(SShellLinkReadError);
 end;
end;

function TShellLink.GetWorkDir: TString;
var
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 Result:='';
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetWorkingDirectory(@Buf[0], MAX_PATH);
  RunError(SShellLinkReadError);
  Result:=PChar(@Buf[0]);
 end;
end;

function TShellLink.LoadFromFile(FileName: TString): Boolean;
begin
 if Assigned(FPersistFile) then begin
  FResult:=FPersistFile.Load(ResolveFileName(FileName),  OF_READWRITE);
  RunError(SShellLinkLoadError, FileName);
 end;
 Result:=True;
end;

function TShellLink.MyDocsFolder: TString;
begin
 if IsEmptyStr(FMyDocsFolder) then
  FMyDocsFolder:=IncludeTrailingBackSlash(SpecialFolder(CSIDL_PERSONAL));
 Result:=FMyDocsFolder;
end;

function TShellLink.ProgramsFolder: TString;
begin
 if IsEmptyStr(FProgramsFolder) then
  FProgramsFolder:=IncludeTrailingBackslash(SpecialFolder(CSIDL_PROGRAMS));
 Result:=FProgramsFolder;
end;


type
  TFuncStrObj = function: TString of object;

function TShellLink.ResolveFileName(FileName: TString): PWideChar;
var
 P: Integer;

 function Resolve(Str: TString; F: TFuncStrObj): Boolean;
 begin
  Result:=True;
  P:=Pos(Str, DnString(FileName));
  if P = 1 then begin
   Delete(FileName, 1, Length(Str));
   if FileName[1] = '\' then Delete(FileName, 1, 1);
   FileName:=F+FileName;
   Result:=False;
  end;
 end;

begin
 if Resolve('{$desktop}', DesktopFolder) then
 if Resolve('{$programs}', ProgramsFolder) then
 if Resolve('{$startmenu}', StartMenuFolder) then
 if Resolve('{$startup}', StartUpFolder) then Resolve('{$mydocs}', MyDocsFolder);
 FTemp:=FileName;
 Result:=PWideChar(@FTemp[1]);
end;

procedure TShellLink.RunError(const Msg, Args: TString);
begin
 if Failed(FResult) then begin
  FResult:=0;
  if Args<>'' then raise EShellLinkError.CreateFmt(Msg,[Args])
              else raise EShellLinkError.Create(Msg);
 end;
end;

function TShellLink.SaveToFile(FileName: TString): Boolean;
begin
 if Assigned(FPersistFile) then begin
  FResult:=FPersistFile.Save(ResolveFileName(FileName), True);
  RunError(SShellLinkSaveError, FileName);
 end;
 Result:=True;
end;

procedure TShellLink.SetArguments(const Value: TString);
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.SetArguments(PAnsiChar(Value));
  RunError(SShellLinkWriteError);
 end;
end;

procedure TShellLink.SetDescription(const Value: TString);
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.SetDescription(PAnsiChar(Value));
  RunError(SShellLinkWriteError);
 end;
end;

procedure TShellLink.SetHotKey(const Value: Word);
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.SetHotKey(Value);
  RunError(SShellLinkWriteError);
 end;
end;

procedure TShellLink.SetIconIndex(const Value: Integer);
var
 OldIndex:Integer;
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetIconLocation(@Buf[0], MAX_PATH, OldIndex);
  RunError(SShellLinkWriteError);
  FResult:=FShellLink.SetIconLocation(@Buf[0], Value);
  RunError(SShellLinkWriteError);
 end;
end;

procedure TShellLink.SetIconLoc(const Value: TString);
var
 Index:Integer;
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.GetIconLocation(@Buf[0], MAX_PATH, Index);
  RunError(SShellLinkWriteError);
  FResult:=FShellLink.SetIconLocation(PAnsiChar(Value),Index);
  RunError(SShellLinkWriteError);
 end;
end;

procedure TShellLink.SetPath(const Value: TString);
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.SetPath(PChar(Value));
  RunError(SShellLinkWriteError);
 end;
end;

procedure TShellLink.SetPIDL(const Value: PItemIDList);
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.SetIDList(Value);
  RunError(SShellLinkWriteError);
 end;
end;

procedure TShellLink.SetShowCmd(const Value: Integer);
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.SetShowCmd(Value);
  RunError(SShellLinkWriteError);
 end;
end;

procedure TShellLink.SetWorkDir(const Value: TString);
begin
 if Assigned(FShellLink) then begin
  FResult:=FShellLink.SetWorkingDirectory(PChar(Value));
  RunError(SShellLinkWriteError);
 end;
end;

class function TShellLink.SpecialFolder(FolderID: Integer): TString;
var
 PIDL:PItemIDList;
 Buf: array [0..MAX_PATH-1] of AnsiChar;
begin
 SHGetSpecialFolderLocation(0, FolderID, PIDL);
 SHGetPathFromIDList(PIDL, @Buf[0]);
 Result:=PChar(@Buf[0]);
end;

function TShellLink.StartMenuFolder: TString;
begin
 if IsEmptyStr(FStartMenuFolder) then
  FStartMenuFolder:=IncludeTrailingBackslash(SpecialFolder(CSIDL_STARTMENU));
 Result:=FStartMenuFolder;
end;

function TShellLink.StartUpFolder: TString;
begin
 if IsEmptyStr(FStartUpFolder) then
  FStartUpFolder:=IncludeTrailingBackslash(SpecialFolder(CSIDL_STARTUP));
 Result:=FStartUpFolder;
end;

{ TDynamicArray }

function TDynamicArray.Add: Integer;
asm
   mov   edx, [eax].FCount
   push  edx
   call  TDynamicArray.Insert
   pop   eax
end;

function TDynamicArray.AddItem(const Item): Integer;
asm
   push  esi
   push  edi
   push  ebx
   mov   esi, eax
   mov   edi, edx
   call  TDynamicArray.Add
   mov   ebx, eax
   mov   edx, ebx
   mov   ecx, edi
   mov   eax, esi
   call  TDynamicArray.PutItem
   mov   eax, ebx
   pop   ebx
   pop   edi
   pop   esi
end;

function TDynamicArray.AllocMem(ACount: Cardinal; var Handle: hLocal): pointer;
asm
   push  edi
   mov   edi, ecx
   mov   eax, [eax].FItemSize
   imul  edx
   push  edi
   push  eax
   push  LHND
   call  LocalAlloc
   pop   edi
   mov   [edi], eax
   push  eax
   call  LocalLock
   pop   edi
end;

constructor TDynamicArray.Create(ACount, AItemSize: Cardinal);
begin
 inherited Create;
 FItemSize:=AItemSize;
 _SetCount(ACount);
end;

procedure TDynamicArray.Delete(Index: Integer);
var
   thx: LongInt;
asm
   mov   ecx, [eax].FCount
   test  ecx, ecx
   jz    @@10
   cmp   edx, ecx
   jge   @@10
   test  edx, edx
   jl    @@10
   push  esi
   push  edi
   push  ebx
   mov   esi, eax
   mov   ebx, edx
   mov   edx, [esi].FCount
   dec   edx
   lea   ecx, thx
   call  TDynamicArray.AllocMem
   mov   edi, eax
   mov   eax, [esi].FItemSize
   mov   ecx, ebx
   imul  ecx
   mov   ecx, eax
   mov   edx, edi
   mov   eax, [esi].FData
   call  MoveMem
   mov   eax, esi
   mov   edx, ebx
   inc   edx
   call  TDynamicArray.GetItemPtr
   push  eax
   mov   eax, [esi].FCount
   sub   eax, ebx
   dec   eax
   mov   edx, [esi].FItemSize
   push  edx
   imul  edx
   mov   ecx, eax
   mov   eax, ebx
   pop   edx
   imul  edx
   add   eax, edi
   mov   edx, eax
   pop   eax
   call  MoveMem
   mov   eax, esi
   lea   edx, [esi].FHandle
   call  TDynamicArray.FreeMem
   mov   [esi].FData, edi
   mov   eax, thx
   mov   [esi].FHandle, eax
   dec   dword ptr [esi].FCount
   mov   eax, esi
   call  TDynamicArray.DoSizeChanged
   pop   ebx
   pop   edi
   pop   esi
   jmp   @@20
@@10:
   call  TDynamicArray.Error
@@20:
end;

procedure TDynamicArray.DeleteItem(Index: Integer; out Item);
asm
   push   esi
   push   ebx
   mov    esi, eax
   mov    ebx, edx
   call   TDynamicArray.GetItem
   mov    eax, esi
   mov    edx, ebx
   call   TDynamicArray.Delete
   pop    ebx
   pop    esi
end;

destructor TDynamicArray.Destroy;
begin
 _SetCount(0);
 inherited;
end;

procedure TDynamicArray.DoSizeChanged;
begin
 SizeChanged;
end;

procedure TDynamicArray.Error(Index: Integer);
begin
  raise EDynArray.CreateFmt(SDynArrayIndexError,[ClassName, Index]);
end;

procedure TDynamicArray.Extend(Count: Cardinal);
asm
   add   edx, [eax].FCount
   call  TDynamicArray._SetCount
end;

function TDynamicArray.ForEach(Tag: Integer; ForEachFunc: TForEachFunc): Integer;
var
   _Tag: LongInt;
   _Size: LongInt;
   _Count: LongInt;
asm
   push  esi
   push  edi
   push  ebx
   mov   esi, [eax].FData
   mov   edi, ecx
   mov   ebx, [eax].FCount
   mov   ecx, [eax].FItemSize
   mov   _Size, ecx
   mov   _Tag,  edx
   mov   _Count, ebx
   sub   esi, _Size
   test  ebx, ebx
@@10:
   jle    @@20
   add   esi, _Size
   mov   eax, _Tag
   mov   edx, _Count
   sub   edx, ebx
   mov   ecx, esi
   call  edi
   test  eax, eax
   jnz   @@30
   dec   ebx
   jmp   @@10
@@20:
   xor   eax, eax
@@30:
   pop   ebx
   pop   edi
   pop   esi
end;

procedure TDynamicArray.FreeMem(var Handle: hLocal);
asm
   push  esi
   mov   esi, edx
   mov   eax, [esi]
   test  eax, eax
   jz    @@10
   push  eax
   push  eax
   call  LocalUnlock
   call  LocalFree
   xor   eax, eax
   mov   [esi], eax
@@10:
   pop   esi
end;

function TDynamicArray.GetFirstItem: Pointer;
asm
   mov   eax, [eax].FData
end;

procedure TDynamicArray.GetItem(Index: Integer; out Item);
asm
   push   esi
   push   edi
   push   ebx
   mov    esi, eax
   mov    edi, ecx
   mov    ebx, edx
   call   TDynamicArray.GetItemPtr
   test   eax, eax
   jnz    @@10
   mov    eax, esi
   mov    edx, ebx
   pop    ebx
   pop    edi
   pop    esi
   call   TDynamicArray.Error
   ret
@@10:
   mov    ecx, [esi].FItemSize
   mov    edx, edi
   call   MoveMem
   pop    ebx
   pop    edi
   pop    esi
end;

function TDynamicArray.GetItemPtr(Index: Integer): Pointer;
asm
   mov   ecx, [eax].FCount
   test  ecx, ecx
   jz    @@10
   test  edx, edx
   jl    @@10
   cmp   edx, ecx
   jge   @@10
   mov   ecx, [eax].FData
   mov   eax, [eax].FItemSize
   xchg  eax, edx
   imul  edx
   add   eax, ecx
   ret
@@10:
   xor   eax, eax
end;

procedure TDynamicArray.Insert(Index: Integer);
var
   thx: LongInt;
asm
   mov    ecx, [eax].FCount
   cmp    edx, ecx
   jg     @@10
   test   edx, edx
   jl     @@10
   push   esi
   push   edi
   push   ebx
   mov    esi, eax
   mov    ebx, edx
   mov    edx, [esi].FCount
   inc    edx
   lea    ecx, thx
   call   TDynamicArray.AllocMem
   mov    edi, eax
   mov    eax, [esi].FItemSize
   mov    ecx, ebx
   imul   ecx
   mov    ecx, eax
   mov    edx, edi
   mov    eax, [esi].FData
   call   MoveMem
   mov    eax, esi
   mov    edx, ebx
   call   TDynamicArray.GetItemPtr
   push   eax
   mov    eax, [esi].FCount
   sub    eax, ebx
   mov    edx, [esi].FItemSize
   push   edx
   imul   edx
   mov    ecx, eax
   mov    eax, ebx
   inc    eax
   pop    edx
   imul   edx
   add    eax, edi
   mov    edx, eax
   pop    eax
   call   MoveMem
   mov    eax, esi
   lea    edx, [esi].FHandle
   call   TDynamicArray.FreeMem
   mov    [esi].FData, edi
   mov    eax, thx
   mov    [esi].FHandle, eax
   inc    dword ptr [esi].FCount
   mov    eax, esi
   call   TDynamicArray.DoSizeChanged
   pop    ebx
   pop    edi
   pop    esi
   jmp    @@20
@@10:
   call   TDynamicArray.Error
@@20:
end;

procedure TDynamicArray.InsertItem(Index: Integer; const Item);
asm
   push   esi
   push   edi
   push   ebx
   mov    esi, eax
   mov    edi, ecx
   mov    ebx, edx
   call   TDynamicArray.Insert
   mov    eax, esi
   mov    ecx, edi
   mov    edx, ebx
   call   TDynamicArray.PutItem
   pop    ebx
   pop    edi
   pop    esi
end;

procedure TDynamicArray.PutItem(Index: Integer; const Item);
asm
   push   esi
   push   edi
   push   ebx
   mov    esi, eax
   mov    edi, ecx
   mov    ebx, edx
   call   TDynamicArray.GetItemPtr
   test   eax, eax
   jnz    @@10
   mov    eax, esi
   mov    edx, ebx
   pop    ebx
   pop    edi
   pop    esi
   call   TDynamicArray.Error
   ret
@@10:
   mov    ecx, [esi].FItemSize
   mov    edx, edi
   xchg   eax, edx
   call   MoveMem
   pop    ebx
   pop    edi
   pop    esi
end;

procedure TDynamicArray.SetCount(const Value: Cardinal);
var
 THX, TDX: LongInt;
asm
   test  edx, edx
   jg    @@10
   mov   [eax].FCount, 0
   lea   edx, [eax].FHandle
   call  TDynamicArray.FreeMem
   jmp   @@30
@@10:
   cmp   edx, [eax].FCount
   je    @@30
   push  esi
   push  edi
   mov   esi, eax
   mov   edi, edx
   lea   ecx, thx
   call  TDynamicArray.AllocMem
   mov   tdx, eax
   mov   ecx, [esi].FCount
   mov   edx, edi
   cmp   edx, ecx
   jl    @@20
   mov   edx, ecx
@@20:
   mov   eax, edx
   mov   edx, [esi].FItemSize
   imul  edx
   mov   ecx, eax
   mov   edx, tdx
   mov   eax, [esi].FData
   call  MoveMem
   mov   eax, tdx
   mov   [esi].FData, eax
   lea   edx, [esi].FHandle
   mov   eax, esi
   call  TDynamicArray.FreeMem
   mov   eax, thx
   mov   [esi].FHandle, eax
   mov   [esi].FCount, edi
   mov   eax, esi
   call  TDynamicArray.DoSizeChanged
   pop   edi
   pop   esi
@@30:
end;

procedure TDynamicArray.SizeChanged;
begin

end;

procedure TDynamicArray.Swap(Index1, Index2: Cardinal);
var
   thx, tdx: LongInt;
asm
   push  esi
   push  edi
   push  ebx
   mov   ebx, eax
   mov   esi, edx
   mov   edi, ecx
   mov   edx, 1
   lea   ecx, thx
   call  TDynamicArray.AllocMem
   mov   tdx, eax
   mov   eax, ebx
   mov   edx, esi
   call  TDynamicArray.GetItemPtr
   mov   edx, esi
   test  eax, eax
   jz    @@10
   mov   esi, eax
   mov   edx, tdx
   mov   ecx, [ebx].FItemSize
   call  MoveMem
   mov   eax, ebx
   mov   edx, edi
   call  TDynamicArray.GetItemPtr
   mov   edx, edi
   test  eax, eax
   jz    @@10
   mov   edi, eax
   mov   edx, esi
   mov   ecx, [ebx].FItemSize
   call  MoveMem
   mov   eax, tdx
   mov   edx, edi
   mov   ecx, [ebx].FItemSize
   call  MoveMem
   mov   eax, ebx
   lea   edx, thx
   call  TDynamicArray.FreeMem
   pop   ebx
   pop   edi
   pop   esi
   jmp   @@20
@@10:
   mov   eax, ebx
   push  eax
   push  edx
   lea   edx, thx
   call  TDynamicArray.FreeMem
   pop   edx
   pop   eax
   pop   ebx
   pop   edi
   pop   esi
   call  TDynamicArray.Error
@@20:
end;

procedure TDynamicArray.Trim(Count: Cardinal);
asm
   mov    ecx, edx
   mov    edx, [eax].FCount
   sub    edx, ecx
   call   TDynamicArray._SetCount
end;

procedure TDynamicArray._SetCount(const Value: Cardinal);
begin
 SetCount(Value);
end;

{ TFile }

procedure TFile.Close;
begin
 Free;
end;

constructor TFile.Create(AFileName: TString; Backup: Boolean);
begin
 FStatus:=fsWriting;
 inherited Create;
 FFileName:=AFileName;
 if Backup and FileExists(FFileName) then CreateBackup;
 FHandle:=CreateFile(PChar(FFileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS,
  FILE_ATTRIBUTE_NORMAL, 0);
 if FHandle = INVALID_HANDLE_VALUE then Error(GetLastError);
end;

procedure TFile.CreateBackup;
var
 BackupName: TString;
 Ext: TString;
begin
 BackupName:=FFileName;
 Ext:=ExtractFileExt(BackupName);
 BackupName:=TrailTrim(BackupName, Length(Ext));
 Delete(Ext, 1, 1);
 BackupName:=BackupName+'.~'+Ext;
 if FileExists(BackupName) then DeleteFile(BackupName);
 if not RenameFile(FFileName, BackupName) then Error(GetLastError)
end;

class function TFile.EncodeDateTime(Year, Month, Day, Hour, Min,
  Sec: Word): TFileTime;
var
 LT: TFileTime;
 ST: TSystemTime;
begin
 ST.wYear:=Year;
 ST.wMonth:=Month;
 ST.wDayOfWeek:=0;
 ST.wDay:=Day;
 ST.wHour:=Hour;
 ST.wMinute:=Min;
 ST.wSecond:=Sec;
 ST.wMilliseconds:=0;
 SystemTimeToFileTime(ST, LT);
 LocalFileTimeToFileTime(LT, Result);
end;

destructor TFile.Destroy;
begin
 CloseHandle(FHandle);
 inherited;
end;

procedure TFile.Error(Code: Integer);
const
 strFileStatus : array[TFileStatus] of TString = (SFileReading, SFileWriting);
begin
 if Code<>0 then raise EFileError.CreateFmtHelp(SFileError,
  [strFileStatus[FStatus], FFileName, GetErrorMessage(Code)], Code);
end;

class procedure TFile.DecodeDateTime(const DateTime: TFileTime; Year,
  Month, Day, Hour, Min, Sec: PWord);
var
 LT: TFileTime;
 ST: TSystemTime;
begin
 FileTimeToLocalFileTime(DateTime, LT);
 FileTimeToSystemTime(LT, ST);
 SetWordValue(Year, ST.wYear);
 SetWordValue(Month, ST.wMonth);
 SetWordValue(Day, ST.wDay);
 SetWordValue(Hour, ST.wHour);
 SetWordValue(Min, ST.wMinute);
 SetWordValue(Sec, ST.wSecond);
end;

function TFile.GetAttributes: LongInt;
begin
 Result:=GetFileAttributes(PChar(FFileName));
 if Result = LongInt($FFFFFFFF) then Error(GetLastError);
end;

function TFile.GetCreationTime: TFileTime;
begin
 if not GetFileTime(FHandle, @Result, nil, nil) then Error(GetLastError);
end;

function TFile.GetErrorMessage(Code: Integer): TString;
begin
 case Code of
  2: Result:=SFileError002;
  3: Result:=SFileError003;
  4: Result:=SFileError004;
  5: Result:=SFileError005;
  14: Result:=SFileError014;
  15: Result:=SFileError015;
  17: Result:=SFileError017;
  19: Result:=SFileError019;
  20: Result:=SFileError020;
  21: Result:=SFileError021;
  22: Result:=SFileError022;
  25: Result:=SFileError025;
  26: Result:=SFileError026;
  27: Result:=SFileError027;
  29: Result:=SFileError029;
  30: Result:=SFileError030;
  32: Result:=SFileError032;
  36: Result:=SFileError036;
  38: Result:=SFileError038;
  39: Result:=SFileError039;
  50: Result:=SFileError050;
  51: Result:=SFileError051;
  52: Result:=SFileError052;
  53: Result:=SFileError053;
  54: Result:=SFileError054;
  55: Result:=SFileError055;
  57: Result:=SFileError057;
  58: Result:=SFileError058;
  59: Result:=SFileError059;
  64: Result:=SFileError064;
  65: Result:=SFileError065;
  66: Result:=SFileError066;
  67: Result:=SFileError067;
  70: Result:=SFileError070;
  82: Result:=SFileError082;
  112: Result:=SFileError112;
  123: Result:=SFileError123;
  161: Result:=SFileError161;
  183: Result:=SFileError183;
  else Result:='';
 end;
end;

function TFile.GetLastAccessTime: TFileTime;
begin
 if not GetFileTime(FHandle, nil, @Result, nil) then Error(GetLastError);
end;

function TFile.GetLastWriteTime: TFileTime;
begin
 if not GetFileTime(FHandle, nil, nil, @Result) then Error(GetLastError);
end;

function TFile.GetSize: Integer;
begin
 Result:=GetFileSize(FHandle, nil);
 if Result = -1 then Error(GetLastError);
end;

constructor TFile.Open(AFileName: TString);
begin
 inherited Create;
 FStatus:=fsReading;
 FFileName:=AFileName;
 FHandle:=CreateFile(PChar(FFileName), GENERIC_READ, 0, nil, OPEN_EXISTING,
  FILE_ATTRIBUTE_NORMAL, 0);
 if FHandle = INVALID_HANDLE_VALUE then Error(GetLastError);
end;

procedure TFile.Read(var Buffer; Size: Integer);
begin
 if FStatus = fsReading then begin
  if not ReadFile(FHandle, Buffer, Cardinal(Size), FDummy, nil)
   then Error(GetLastError);
 end;
end;

procedure TFile.Seek(Position: Integer);
begin
 SetFilePointer(FHandle, Position, nil, FILE_BEGIN);
 Error(GetLastError);
end;

procedure TFile.SetAttributes(const Value: LongInt);
begin
 if not SetFileAttributes(PChar(FFileName), Value) then Error(GetLastError);
end;

procedure TFile.SetCreationTime(const Value: TFileTime);
begin
 if not SetFileTime(FHandle, @Value, nil, nil) then Error(GetLastError);
end;

procedure TFile.SetLastAccessTime(const Value: TFileTime);
begin
 if not SetFileTime(FHandle, nil, @Value, nil) then Error(GetLastError);
end;

procedure TFile.SetLastWriteTime(const Value: TFileTime);
begin
 if not SetFileTime(FHandle, nil, nil, @Value) then Error(GetLastError);
end;

procedure TFile.UserError(Code: Integer);
begin
 Error(Code);
end;

procedure TFile.Write(const Buffer; Size: Integer);
begin
 if FStatus = fsWriting then begin
  if not WriteFile(FHandle, Buffer, Cardinal(Size), FDummy, nil)
   then Error(GetLastError);
 end;
end;

{ TFileStrm }

procedure TFileStrm.Close;
begin
 Free;
end;

constructor TFileStrm.Create(AFileName: TString; Backup: Boolean);
begin
 FStatus:=fsWriting;
 inherited Create;
 FFileName:=AFileName;
 if Backup and FileExists(FFileName) then CreateBackup;
 FHandle:=CreateFile(PChar(FFileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS,
  FILE_ATTRIBUTE_NORMAL, 0);
 if FHandle = INVALID_HANDLE_VALUE then Error(GetLastError);
end;

procedure TFileStrm.CreateBackup;
var
 BackupName: TString;
 Ext: TString;
begin
 BackupName:=FFileName;
 Ext:=ExtractFileExt(BackupName);
 BackupName:=TrailTrim(BackupName, Length(Ext));
 Delete(Ext, 1, 1);
 BackupName:=BackupName+'.~'+Ext;
 if FileExists(BackupName) then DeleteFile(BackupName);
 if not RenameFile(FFileName, BackupName) then Error(GetLastError)
end;

class procedure TFileStrm.DecodeDateTime(const DateTime: TFileTime; Year,
  Month, Day, Hour, Min, Sec: PWord);
var
 LT: TFileTime;
 ST: TSystemTime;
begin
 FileTimeToLocalFileTime(DateTime, LT);
 FileTimeToSystemTime(LT, ST);
 SetWordValue(Year, ST.wYear);
 SetWordValue(Month, ST.wMonth);
 SetWordValue(Day, ST.wDay);
 SetWordValue(Hour, ST.wHour);
 SetWordValue(Min, ST.wMinute);
 SetWordValue(Sec, ST.wSecond);
end;

destructor TFileStrm.Destroy;
begin
 CloseHandle(FHandle);
 inherited;
end;

class function TFileStrm.EncodeDateTime(Year, Month, Day, Hout, Min,
  Sec: Word): TFileTime;
var
 LT: TFileTime;
 ST: TSystemTime;
begin
 ST.wYear:=Year;
 ST.wMonth:=Month;
 ST.wDayOfWeek:=0;
 ST.wDay:=Day;
 ST.wHour:=Hour;
 ST.wMinute:=Min;
 ST.wSecond:=Sec;
 ST.wMilliseconds:=0;
 SystemTimeToFileTime(ST, LT);
 LocalFileTimeToFileTime(LT, Result);
end;

procedure TFileStrm.Error(Code: Integer);
const
 strFileStatus : array[TFileStatus] of TString = (SFileReading, SFileWriting);
begin
 if Code<>0 then raise EFileError.CreateFmt(SFileError,
  [strFileStatus[FStatus], FFileName, GetErrorMessage(Code)]);
end;

function TFileStrm.GetAttributes: LongInt;
begin
 Result:=GetFileAttributes(PChar(FFileName));
 if Result = LongInt($FFFFFFFF) then Error(GetLastError);
end;

function TFileStrm.GetCreationTime: TFileTime;
begin
 if not GetFileTime(FHandle, @Result, nil, nil) then Error(GetLastError);
end;

function TFileStrm.GetErrorMessage(Code: Integer): TString;
begin
 case Code of
  2: Result:=SFileError002;
  3: Result:=SFileError003;
  4: Result:=SFileError004;
  5: Result:=SFileError005;
  14: Result:=SFileError014;
  15: Result:=SFileError015;
  17: Result:=SFileError017;
  19: Result:=SFileError019;
  20: Result:=SFileError020;
  21: Result:=SFileError021;
  22: Result:=SFileError022;
  25: Result:=SFileError025;
  26: Result:=SFileError026;
  27: Result:=SFileError027;
  29: Result:=SFileError029;
  30: Result:=SFileError030;
  32: Result:=SFileError032;
  36: Result:=SFileError036;
  38: Result:=SFileError038;
  39: Result:=SFileError039;
  50: Result:=SFileError050;
  51: Result:=SFileError051;
  52: Result:=SFileError052;
  53: Result:=SFileError053;
  54: Result:=SFileError054;
  55: Result:=SFileError055;
  57: Result:=SFileError057;
  58: Result:=SFileError058;
  59: Result:=SFileError059;
  64: Result:=SFileError064;
  65: Result:=SFileError065;
  66: Result:=SFileError066;
  67: Result:=SFileError067;
  70: Result:=SFileError070;
  82: Result:=SFileError082;
  112: Result:=SFileError112;
  123: Result:=SFileError123;
  161: Result:=SFileError161;
  183: Result:=SFileError183;
  else Result:='';
 end;
end;

function TFileStrm.GetLastAccessTime: TFileTime;
begin
 if not GetFileTime(FHandle, nil, @Result, nil) then Error(GetLastError);
end;

function TFileStrm.GetLastWriteTime: TFileTime;
begin
 if not GetFileTime(FHandle, nil, nil, @Result) then Error(GetLastError);
end;

constructor TFileStrm.Open(AFileName: TString);
begin
 inherited Create;
 FStatus:=fsReading;
 FFileName:=AFileName;
 FHandle:=CreateFile(PChar(FFileName), GENERIC_READ, 0, nil, OPEN_EXISTING,
  FILE_ATTRIBUTE_NORMAL, 0);
 if FHandle = INVALID_HANDLE_VALUE then Error(GetLastError);
end;

function TFileStrm.Read(var Buffer; Count: Integer): LongInt;
begin
 if FStatus = fsReading then begin
  if not ReadFile(FHandle, Buffer, Cardinal(Count), LongWord(Result), nil)
   then Error(GetLastError);
 end;
end;

function TFileStrm.Seek(Offset: Integer; Origin: Word): LongInt;
begin
 Result:=SetFilePointer(FHandle, Offset, nil, Origin);
 Error(GetLastError);
end;

procedure TFileStrm.SetAttributes(const Value: LongInt);
begin
 if not SetFileAttributes(PChar(FFileName), Value) then Error(GetLastError);
end;

procedure TFileStrm.SetCreationTime(const Value: TFileTime);
begin
 if not SetFileTime(FHandle, @Value, nil, nil) then Error(GetLastError);
end;

procedure TFileStrm.SetLastAccessTime(const Value: TFileTime);
begin
 if not SetFileTime(FHandle, nil, @Value, nil) then Error(GetLastError);
end;

procedure TFileStrm.SetLastWriteTime(const Value: TFileTime);
begin
 if not SetFileTime(FHandle, nil, nil, @Value) then Error(GetLastError);
end;

procedure TFileStrm.SetSize(NewSize: LongInt);
begin
 raise EFileError.Create(SCannotSetSize);
end;

procedure TFileStrm.UserError(Code: Integer);
begin
 Error(Code);
end;

function TFileStrm.Write(const Buffer; Count: Integer): LongInt;
begin
 if FStatus = fsWriting then begin
  if not WriteFile(FHandle, Buffer, Cardinal(Count), LongWord(Result), nil)
   then Error(GetLastError);
 end;
end;

{ TUnknown }

function TUnknown.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
 if GetInterface(IID, Obj) then Result:=S_OK else Result:=E_NOINTERFACE;
end;

function TUnknown.Unknown: IUnknown;
begin
 GetInterface(IUnknown, Result);
end;

procedure TUnknown.Unknown(out Obj);
begin
 GetInterface(IUnknown, Obj);
end;

function TUnknown._AddRef: Integer;
begin
 Result:=Incr(FRefCount);
end;

function TUnknown._Release: Integer;
begin
 Result:=Decr(FRefCount);
end;

{ TMatrixRow }

constructor TMatrixRow.Create(AColCount: Integer; AMatrix: TMatrix);
begin
 FMatrix:=AMatrix;
 inherited Create(AColCount, FMatrix.FItemSize);
end;

{ TMatrixRows }

constructor TMatrixRows.Create(AMatrix: TMatrix);
begin
 inherited Create(0, SizeOf(TMatrixRow));
end;

procedure TMatrixRows.DeleteCol(Index: Integer);
begin
 FColIndex:=Index;
 ForEach(Integer(Self), @TMatrixRows.DeleteColFunc);
 Dec(FWidth);
end;

function TMatrixRows.DeleteColFunc(Index: Integer;
  var Row: TMatrixRow): Integer;
begin
 Row.Delete(FColIndex);
 Result:=0;
end;

function TMatrixRows.GetRow(Index: Integer): TMatrixRow;
begin
 Result:=PMatrixRow(GetItemPtr(Index))^;
end;

procedure TMatrixRows.InsertCol(Index: Integer);
begin
 FColIndex:=Index;
 ForEach(Integer(Self), @TMatrixRows.InsertColFunc);
 Inc(FWidth);
end;

function TMatrixRows.InsertColFunc(Index: Integer;
  var Row: TMatrixRow): Integer;
begin
 Row.Insert(FColIndex);
 Result:=0;
end;

procedure TMatrixRows.SetRow(Index: Integer; const Value: TMatrixRow);
begin
 PMatrixRow(GetItemPtr(Index))^:=Value;
end;

procedure TMatrixRows.SetWidth(const Value: Integer);
begin
 FWidth := Value;
 ForEach(Integer(Self), @TMatrixRows.SetWidthFunc);
end;

function TMatrixRows.SetWidthFunc(Index: Integer;
  var Row: TMatrixRow): Integer;
begin
 Row.Count:=FWidth;
 Result:=0;
end;

{ TMatrix }

constructor TMatrix.Create(AColCount, ARowCount, AItemSize: Integer);
begin
 inherited Create;
 FItemSize:=AItemSize;
 FRows:=TMatrixRows.Create(Self);
 RowCount:=ARowCount;
 ColCount:=AColCount;
end;

function TMatrix.CreateRow: TMatrixRow;
begin
 Result:=TMatrixRow.Create(ColCount, Self);
end;

procedure TMatrix.DeleteCol(Index: Integer);
begin
 if Inside(Index, 0, FRows.Width - 1)
  then FRows.DeleteCol(Index)
  else raise EMatrixError.CreateFmt(SColIndexOutOfRange, [Index]);
end;

procedure TMatrix.DeleteRow(Index: Integer);
begin
 if Inside(Index, 0, FRows.Count - 1) then begin
  FRows[Index].Free;
  FRows.Delete(Index);
 end else raise EMatrixError.CreateFmt(SRowIndexOutOfRange, [Index]);
end;

destructor TMatrix.Destroy;
begin
 FRows.Free;
 inherited;
end;

function TMatrix.ForEachRow(Tag: Integer;
  ForEachRowFunc: TForEachFunc): Integer;
begin
 Result:=FRows.ForEach(Tag, ForEachRowFunc);
end;

function TMatrix.GetColCount: Integer;
begin
 Result:=FRows.Width;
end;

procedure TMatrix.GetItem(ACol, ARow: Integer; out Item);
begin
 if Inside(ARow, 0, FRows.Count - 1) and Inside(ACol, 0, FRows.FWidth-1)
  then FRows[ARow].GetItem(ACol, Item)
  else raise EMatrixError.CreateFmt(SIndicesOutOfRange, [ACol, ARow]);
end;

function TMatrix.GetRow(Index: Integer): TMatrixRow;
begin
 Result:=FRows[Index];
end;

function TMatrix.GetRowCount: Integer;
begin
 Result:=FRows.Count;
end;

procedure TMatrix.InsertCol(Index: Integer);
begin
 if Inside(Index, 0, FRows.Width)
  then FRows.InsertCol(Index)
  else raise EMatrixError.CreateFmt(SColIndexOutOfRange, [Index]);
end;

procedure TMatrix.InsertRow(Index: Integer);
var
 Temp: TMatrixRow;
begin
 if Inside(Index, 0, FRows.Count) then begin
  Temp:=CreateRow;
  FRows.InsertItem(Index, Temp);
 end else raise EMatrixError.CreateFmt(SRowIndexOutOfRange, [Index]);
end;

procedure TMatrix.PutItem(ACol, ARow: Integer; const Item);
begin
 if Inside(ARow, 0, FRows.Count - 1) and Inside(ACol, 0, FRows.FWidth-1)
  then FRows[ARow].PutItem(ACol, Item)
  else raise EMatrixError.CreateFmt(SIndicesOutOfRange, [ACol, ARow]);
end;

procedure TMatrix.SetColCount(const Value: Integer);
begin
 FRows.Width:=Value;
end;

procedure TMatrix.SetRowCount(const Value: Integer);
var
 OldCount: Integer;
 i: Integer;
begin
 OldCount:=RowCount;
 if OldCount < Value then begin
  for i:=OldCount+1 to Value do InsertRow(RowCount);
 end else if OldCount > Value then begin
  for i:=OldCount-1 downto Value do DeleteRow(RowCount-1);
 end;
end;

{ TBufferStream }

constructor TBufferStream.Create(ABuffer: Pointer; ASize: Integer);
begin
 SetPointer(ABuffer, ASize);
 Seek(0, 0);
end;

function TBufferStream.Write(const Buffer; Count: Integer): Longint;
begin
 raise EStreamError.Create(SReadOnlyStream);
end;


{ TDynamicArrayEx }

function TDynamicArrayEx.Add: Integer;
begin
 Result := FCount;
 Insert(Result);
end;

procedure TDynamicArrayEx.AllocBuffer(ASize: Integer);
var
 ABuffer: Pointer;
begin
 ABuffer := AllocateMem(ASize);
 if Assigned(FBuffer) then begin
  Move(FBuffer^, ABuffer^, FBufferSize);
  DeallocateMem(FBuffer);
 end;
 FBuffer := ABuffer;
 FBufferSize := ASize;
end;

function TDynamicArrayEx.CompareItems(var Item1; var Item2): Integer;
begin
 Result:=0; // would be overriden
end;

constructor TDynamicArrayEx.Create(ACount, AItemSize: Integer);
begin
 FStatus := dsCreating;
 try
  inherited Create;
  FBuffer := nil;
  FBufferSize := 0;
  FItemSize := AItemSize;
  FCapacity := 0;
  SetCount(ACount);
 finally
  FStatus := dsNone;
 end;
end;

procedure TDynamicArrayEx.Delete(AIndex, ACount: Integer);
var
 Index: Integer;
 Ptr: Pointer;
begin
 FStatus := dsDeletingItems;
 try
  if (AIndex < 0) or (AIndex >= FCount) then Error(AIndex);
  if ACount > 0 then begin
   if AIndex + ACount >= FCount then SetCount(AIndex) else begin
    Ptr := Get(AIndex);
    FTempItems[3] := nil;
    for Index := AIndex to AIndex + ACount - 1 do begin
     DoDoneItem(Index, Ptr^);
     Ptr := IncPtr(Ptr, FItemSize);
    end;
    Move(Get(AIndex+ACount)^, Get(AIndex)^, (FCount - AIndex - ACount)*FItemSize);
    FillChar( Get(FCount - ACount)^, ACount * FItemSize, 0);
    Dec(FCount, ACount);
   end;
  end;
 finally
  FStatus := dsNone;
 end;
end;

destructor TDynamicArrayEx.Destroy;
begin
 FStatus := dsDestroying;
 DoneItems;
 inherited;
end;

function TDynamicArrayEx.DoDoneItem(Index: Integer;
 var Item): Integer;
begin
 DoneItem(Index, Item);
 if FTempItems[3] <> nil then FillChar(Item, FItemSize, 0);
 Result:=0;
end;

function TDynamicArrayEx.DoInitItem(Index: Integer;
 var Item): Integer;
begin
 if FTempItems[3] <> nil then FillChar(Item, FItemSize, 0);
 InitItem(Index, Item);
 Result:=0;
 Hole(Item);
end;

function TDynamicArrayEx.DoLoadItem(Index: Integer; var Item): Integer;
begin
 LoadItem(TStream(FTempItems[2]), Index, Item);
 Result:=0;
end;

procedure TDynamicArrayEx.DoneItem(Index: Integer; var Item);
begin
 // would be overriden
end;

procedure TDynamicArrayEx.DoneItems;
begin
 ForEach(Integer(Self), @TDynamicArrayEx.DoDoneItem);
 FreeBuffer;
end;

function TDynamicArrayEx.DoSaveItem(Index: Integer; var Item): Integer;
begin
 SaveItem(TStream(FTempItems[2]), Index, Item);
 Result:=0;
end;

procedure TDynamicArrayEx.Error(Index: Integer);
begin
 raise EDynArray.CreateFmt(SDynArrayIndexError, [ClassName, Index]);
end;

function TDynamicArrayEx.ForEach(Tag: Integer;
  ForEachFunc: TForEachFuncEx): Integer;
var
 Index, Delta: Integer;
begin
 Result := 0;
 Delta := 0;
 Index := 0;
 while Index < FCount do begin
  Result := ForEachFunc(Tag, Index, IncPtr(FBuffer, Delta));
  if Result <> 0 then Break;
  Inc(Delta, FItemSize);
  Inc(Index);
 end;
end;

procedure TDynamicArrayEx.FreeBuffer;
begin
 if FBuffer <> nil then begin
  DeallocateMem(FBuffer);
  FBuffer := nil;
  FBufferSize := 0;
  FCount := 0;
  FCapacity := 0;
 end;
end;

function TDynamicArrayEx.Get(Index: Integer): Pointer;
begin
 if (Index >= 0) and (Index < FCount)
  then Result := IncPtr(FBuffer, Index * FItemSize)
  else Result := nil;
end;

procedure TDynamicArrayEx.GetItem(Index: Integer; var Item);
var
 Ptr: Pointer;
begin
 Ptr := Get(Index);
 if not Assigned(Ptr) then Error(Index) else Move(Ptr^, Item, FItemSize);
end;

procedure TDynamicArrayEx.Grow(ACount: Integer);
var
 Delta: Integer;
begin
 if ACount > 64 then Delta := ACount div 4 else
  if ACount > 8 then Delta := 16 else
    Delta := 4;
 FCapacity := ACount + Delta;
 AllocBuffer(FCapacity * FItemSize);
end;

procedure TDynamicArrayEx.InitItem(Index: Integer; var Item);
begin
 // would be overriden
end;

procedure TDynamicArrayEx.Insert(AIndex, ACount: Integer);
var
 NewCount : Integer;
 Index: Integer;
 Ptr : Pointer;
 Size: Integer;
begin
 FStatus := dsInsertingItems;
 try
  if (AIndex < 0) or (AIndex > FCount) then Error(AIndex);
  if ACount > 0 then begin
   NewCount := FCount + ACount;
   if AIndex = FCount then SetCount(NewCount) else begin
    if NewCount > FCapacity then Grow(NewCount);
    Ptr := IncPtr(FBuffer, AIndex * FItemSize);
    Size := FItemSize * ACount;
    if AIndex < FCount then
      Move(Ptr^, IncPtr(Ptr, Size)^, (FCount - AIndex) * FItemSize);
    FTempItems[3] := Pointer(1);
    for Index := AIndex to AIndex + ACount - 1 do begin
     DoInitItem(Index, Ptr^);
     Ptr := IncPtr(Ptr, FItemSize);
    end;
    FCount := NewCount;
   end;
  end;
 finally
  FStatus := dsNone;
 end;
end;

procedure TDynamicArrayEx.LoadFromFile(const FileName: TString);
var
 F: TFileStrm;
begin
 F:=TFileStrm.Open(FileName);
 try
  LoadFromStream(F);
 finally
  F.Close;
 end;
end;

procedure TDynamicArrayEx.LoadFromStream(const Stream: TStream);
var
 N: LongInt;
begin
 FStatus := dsLoading;
 try
  Stream.ReadBuffer(N, SizeOf(N));
  SetCount(N);
  FTempItems[2] := Stream;
  ForEach(Integer(Self), @TDynamicArrayEx.DoLoadItem);
 finally
  FStatus := dsNone;
 end;
end;

procedure TDynamicArrayEx.LoadItem(Stream: TStream; Index: Integer;
  var Item);
begin
 Stream.ReadBuffer(Item, FItemSize);
end;

procedure TDynamicArrayEx.PutItem(Index: Integer; const Item);
var
 Ptr: Pointer;
begin
 Ptr := Get(Index);
 if not Assigned(Ptr) then Error(Index) else Move(Item, Ptr^, FItemSize);
end;

procedure TDynamicArrayEx.QuickSort(Low, High, Direction: Integer);

 procedure InternalSwap(Ptr1, Ptr2: Pointer);
 begin
  Move(Ptr1^, FTempItems[0]^, FItemSize);
  Move(Ptr2^, Ptr1^, FItemSize);
  Move(FTempItems[0]^, Ptr2^, FItemSize);
 end;

 function InternalCompare(Ptr1, Ptr2: Pointer): Integer;
 begin
  Result:=CompareItems(Ptr1^, Ptr2^) * Direction;
 end;

var
 Mid, ScanUp, ScanDown: Integer;
begin
  if High - Low <= 0 then Exit;
  if High - Low = 1 then begin
   if InternalCompare(Get(High), Get(Low)) < 0
    then InternalSwap(Get(Low), Get(High));
   Exit;
  end;
  Mid := (High + Low) shr 1;
  Move(Get(Mid)^, FTempItems[1]^, FItemSize);
  InternalSwap(Get(Mid), Get(Low));
  ScanUp:=Low+1;
  ScanDown:=High;
  repeat
   while (ScanUp <= ScanDown) and (InternalCompare(Get(ScanUp), FTempItems[1]) <= 0) do
    Inc(ScanUp);
   while InternalCompare(Get(ScanDown), FTempItems[1]) > 0 do Dec(ScanDown);
   if (ScanUp < ScanDown) then InternalSwap(Get(ScanUp), Get(ScanDown));
  until ScanUp >= ScanDown;
  Move(Get(ScanDown)^, Get(Low)^, FItemSize);
  Move(FTempItems[1]^, Get(ScanDown)^, FItemSize);

  if (Low < ScanDown - 1) then QuickSort(Low, ScanDown - 1, Direction);
  if (ScanDown + 1 < High) then QuickSort(ScanDown + 1, High, Direction);
end;

procedure TDynamicArrayEx.SaveItem(Stream: TStream; Index: Integer;
  var Item);
begin
 Stream.WriteBuffer(Item, FItemSize);
end;

procedure TDynamicArrayEx.SaveToFile(const FileName: TString);
var
 F: TFileStrm;
begin
 F:=TFileStrm.Create(FileName, True);
 try
  SaveToStream(F);
 finally
  F.Close;
 end;
end;

procedure TDynamicArrayEx.SaveToStream(const Stream: TStream);
var
 N: LongInt;
begin
 FStatus := dsSaving;
 try
  N := FCount;
  Stream.WriteBuffer(N, SizeOf(N));
  FTempItems[2] := Stream;
  ForEach(Integer(Self), @TDynamicArrayEx.DoSaveItem);
 finally
  FStatus := dsNone;
 end;
end;

procedure TDynamicArrayEx.SetCount(ACount: Integer);
var
 Index: Integer;
 Item: Pointer;
begin
 if ACount = 0 then DoneItems else begin
  if ACount < FCount then begin
   Item := Get(ACount);
   FTempItems[3] := Pointer(1);
   for Index:=ACount to FCount - 1 do begin
    DoDoneItem(Index, Item^);
    Item := IncPtr(Item, FItemSize);
   end;
   FCount := ACount;
  end else begin
   if ACount > FCapacity then Grow(ACount);
   Item := IncPtr(FBuffer, FCount * FItemSize);
   FTempItems[3] := Pointer(1);
   for Index := FCount to ACount - 1 do begin
    DoInitItem(Index, Item^);
    Item := IncPtr(Item, FItemSize);
   end;
   FCount := ACount;
  end;
 end;
end;

procedure TDynamicArrayEx.Shuffle(Moves: Integer);
var
 i: Integer;
begin
 for i:=1 to Moves do Swap(Random(FCount), Random(FCount));
end;

procedure TDynamicArrayEx.Sort(Direction: Integer);
begin
 if Direction >= 0 then Direction := 1 else Direction := -1;
 FTempItems[0] := AllocateMem(FItemSize);
 FTempItems[1] := AllocateMem(FItemSize);
 try
  QuickSort(0, FCount - 1, Direction);
 finally
  DeallocateMem(FTempItems[0]);
  DeallocateMem(FTempItems[1]);
 end;
end;

procedure TDynamicArrayEx.Swap(Index1, Index2: Integer);
var
 Item1: Pointer;
 Item2: Pointer;
 Temp: Pointer;
begin
 Item1 := Get(Index1);
 if not Assigned(Item1) then Error(Index1);
 Item2 := Get(Index2);
 if not Assigned(Item2) then Error(Index2);
 Temp := AllocateMem(FItemSize);
 try
  Move(Item1^, Temp^, FItemSize);
  Move(Item2^, Item1^, FItemSize);
  Move(Temp^, Item2^, FItemSize);
 finally
  DeallocateMem(Temp);
 end;
end;

const
 EncodeTable: array [0..63] of Byte = (
    065, 066, 067, 068, 069, 070, 071, 072,
    073, 074, 075, 076, 077, 078, 079, 080,
    081, 082, 083, 084, 085, 086, 087, 088,
    089, 090, 097, 098, 099, 100, 101, 102,
    103, 104, 105, 106, 107, 108, 109, 110,
    111, 112, 113, 114, 115, 116, 117, 118,
    119, 120, 121, 122, 048, 049, 050, 051,
    052, 053, 054, 055, 056, 057, 043, 047);

 DecodeTable: array [Byte] of Byte = (
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 062, 255, 255, 255, 063,
    052, 053, 054, 055, 056, 057, 058, 059,
    060, 061, 255, 255, 255, 255, 255, 255,
    255, 000, 001, 002, 003, 004, 005, 006,
    007, 008, 009, 010, 011, 012, 013, 014,
    015, 016, 017, 018, 019, 020, 021, 022,
    023, 024, 025, 255, 255, 255, 255, 255,
    255, 026, 027, 028, 029, 030, 031, 032,
    033, 034, 035, 036, 037, 038, 039, 040,
    041, 042, 043, 044, 045, 046, 047, 048,
    049, 050, 051, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255,
    255, 255, 255, 255, 255, 255, 255, 255);

 PadChar = Byte('=');

 EncodedLineSize = 76;
 DecodedLineSize = EncodedLineSize div 4 * 3;

type
  PByte = ^Byte;

  PByte4 = ^TByte4;
  TByte4 = packed array [1..4] of Byte;

  PByte3 = ^TByte3;
  TByte3 = packed array [1..3] of Byte;

procedure _MimeEncode(InBuf: Pointer; InSize: Cardinal;
 OutBuf: Pointer; CRLF: Boolean);

 procedure MimeEncodeLine(InBuf: PByte3; InSize: Cardinal; OutBuf: PByte4);
 var
  B, i, Count, Rem: Cardinal;
 begin
  if InSize <> 0 then begin
   Count := DivMod(InSize, 3, Integer(Rem));
   for i:=1 to Count do begin
    B := (((InBuf[1] shl 8) or InBuf[2]) shl 8) or InBuf[3];
    Inc(InBuf);
    OutBuf[4] := EncodeTable[B and $3F];
    B := B shr 6;
    OutBuf[3] := EncodeTable[B and $3F];
    B := B shr 6;
    OutBuf[2] := EncodeTable[B and $3F];
    B := B shr 6;
    OutBuf[1] := EncodeTable[B and $3F];
    Inc(OutBuf);
   end;
   case Rem of
    1: begin
     B := InBuf[1] shl 4;
     OutBuf[2] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[1] := EncodeTable[B];
     OutBuf[3] := PadChar;
     OutBuf[4] := PadChar;
    end;
    2: begin
     B := ((InBuf[1] shl 8) or InBuf[2]) shl 2;
     OutBuf[3] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[2] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[1] := EncodeTable[B];
     OutBuf[4] := PadChar;
    end;
   end;
  end;
 end;

 procedure MimeEncodeLines(InBuf: PByte3; InSize: Cardinal; OutBuf: PByte4);
 var
  B, i, j: Cardinal;
 begin
  if InSize > DecodedLineSize then begin
   for i := 1 to InSize div DecodedLineSize do begin
    for j := 1 to DecodedLineSize div 3 do begin
     B := (((InBuf[1] shl 8) or InBuf[2]) shl 8) or InBuf[3];
     Inc(InBuf);
     OutBuf[4] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[3] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[2] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[1] := EncodeTable[B and $3F];
     Inc(OutBuf);
    end;
    OutBuf[1] := 13;
    OutBuf[2] := 10;
    OutBuf := IncPtr(OutBuf, 2);
   end;
  end;
 end;

var
 D1, D2: Cardinal;
begin
 if CRLF then begin
  MimeEncodeLines(InBuf, InSize, OutBuf);
  D1 := InSize div DecodedLineSize;
  D2 := D1 * (EncodedLineSize + 2);
  D1 := D1 * DecodedLineSize;
  MimeEncodeLine(IncPtr(InBuf, D1), InSize - D1, IncPtr(OutBuf, D2));
 end else MimeEncodeLine(InBuf, InSize, OutBuf);
end;

function _MimeDecode(InBuf: PByte; InSize: Cardinal; OutBuf: Pointer): Cardinal;
var
 B, N, C: Cardinal;
 Limit: PByte;
 OutPtr: PByte3;
begin
 if InSize = 0 then Result := 0 else begin
  B := 0;
  N := 4;
  Limit := IncPtr(InBuf, InSize);
  OutPtr := OutBuf;
  while InBuf <> Limit do begin
   C := DecodeTable[InBuf^];
   Inc(InBuf);
   if C = 255 then Continue;
   B := (B shl 6) or C;
   Dec(N);
   if N <> 0 then Continue;
   OutPtr[3] := Lo(B);
   B := B shr 8;
   OutPtr[2] := Lo(B);
   B := B shr 8;
   OutPtr[1] := Lo(B);
   B := 0;
   Inc(OutPtr);
   N := 4;
  end;
  Result := Cardinal(OutPtr) - Cardinal(OutBuf);
  case N of
   1: begin
    B := B shr 2;
    OutPtr[2] := Lo(B);
    B := B shr 8;
    OutPtr[1] := Lo(B);
    Inc(Result, 2);
   end;
   2: begin
    B := B shr 4;
    OutPtr[1] := Lo(B);
    Inc(Result, 1);
   end;
  end;
 end;
end;

function EncodedSize(InSize: Cardinal; CRLF: Boolean): Cardinal;
begin
 if CRLF
  then Result := ((InSize+2) div 3) shl 2 + (InSize-1) div DecodedLineSize shl 1
  else Result := ((InSize+2) div 3) shl 2;
end;

function DecodedSize(InSize: Cardinal): Cardinal;
begin
 Result := (InSize + 3) shr 2 * 3;
end;

procedure MimeEncode(InBuf: Pointer; InSize: Cardinal;
  out OutBuf: Pointer; out OutSize: Cardinal; CRLF: Boolean = True); overload;
begin
 OutSize := EncodedSize(InSize, CRLF);
 OutBuf := AllocateMem(OutSize);
 try
  _MimeEncode(InBuf,InSize, OutBuf, CRLF);
 except
  DeallocateMem(OutBuf);
  raise;
 end;
end;

procedure MimeDecode(InBuf: Pointer; InSize: Cardinal;
  out OutBuf: Pointer; out OutSize: Cardinal); overload;
begin
 OutBuf := AllocateMem(DecodedSize(InSize));
 try
  OutSize := _MimeDecode(InBuf, InSize, OutBuf);
 except
  DeallocateMem(OutBuf);
  raise;
 end;
end;

function MimeEncode(Str: TString;
 CRLF: Boolean = True): TString; overload;
begin
 if Str <> '' then begin
  SetLength(Result, EncodedSize(Length(Str), CRLF));
  _MimeEncode(@Str[1], Length(Str), @Result[1], CRLF);
 end else Result := '';
end;

function MimeDecode(Str: AnsiString): AnsiString; overload;
begin
 if Str <> '' then begin
  SetLength(Result, DecodedSize(Length(Str)));
  SetLength(Result, _MimeDecode(@Str[1], Length(Str), @Result[1]));
 end else Result := '';
end;


procedure MimeEncode(InStream, OutStream: TStream;
  CRLF: Boolean = True); overload;

 procedure MimeEncodeLine(InStream, OutStream: TStream; InSize: Cardinal);
 var
  InBuf: TByte3;
  OutBuf: TByte4;
  B, i, Count, Rem: Cardinal;
 begin
  if InSize <> 0 then begin
   Count := DivMod(InSize, 3, Integer(Rem));
   for i:=1 to Count do begin
    InStream.ReadBuffer(InBuf, SizeOf(InBuf));
    B := (((InBuf[1] shl 8) or InBuf[2]) shl 8) or InBuf[3];
    OutBuf[4] := EncodeTable[B and $3F];
    B := B shr 6;
    OutBuf[3] := EncodeTable[B and $3F];
    B := B shr 6;
    OutBuf[2] := EncodeTable[B and $3F];
    B := B shr 6;
    OutBuf[1] := EncodeTable[B and $3F];
    OutStream.WriteBuffer(OutBuf, SizeOf(OutBuf));
   end;
   case Rem of
    1: begin
     InStream.ReadBuffer(InBuf, 1);
     B := InBuf[1] shl 4;
     OutBuf[2] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[1] := EncodeTable[B];
     OutBuf[3] := PadChar;
     OutBuf[4] := PadChar;
     OutStream.WriteBuffer(OutBuf, SizeOf(OutBuf));
    end;
    2: begin
     InStream.ReadBuffer(InBuf, 2);
     B := ((InBuf[1] shl 8) or InBuf[2]) shl 2;
     OutBuf[3] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[2] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[1] := EncodeTable[B];
     OutBuf[4] := PadChar;
     OutStream.WriteBuffer(OutBuf, SizeOf(OutBuf));
    end;
   end;
  end;
 end;

 procedure MimeEncodeLines(InStream, OutStream: TStream);
 var
  InBuf: TByte3;
  OutBuf: TByte4;
  B, i, j: Cardinal;
  S: Cardinal;
 begin
  S := InStream.Size;
  if S > DecodedLineSize then begin
   for i := 1 to S div DecodedLineSize do begin
    for j := 1 to DecodedLineSize div 3 do begin
     InStream.ReadBuffer(InBuf, SizeOf(InBuf));
     B := (((InBuf[1] shl 8) or InBuf[2]) shl 8) or InBuf[3];
     OutBuf[4] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[3] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[2] := EncodeTable[B and $3F];
     B := B shr 6;
     OutBuf[1] := EncodeTable[B and $3F];
     OutStream.WriteBuffer(OutBuf, SizeOf(OutBuf));
    end;
    OutBuf[1] := 13;
    OutBuf[2] := 10;
    OutStream.WriteBuffer(OutBuf, 2);
   end;
  end;
 end;

var
 D1: Cardinal;
begin
 if CRLF then begin
  InStream.Position := 0;
  MimeEncodeLines(InStream, OutStream);
  D1 := (InStream.Size div DecodedLineSize) * DecodedLineSize;
  InStream.Position := D1;
  MimeEncodeLine(InStream, OutStream, Cardinal(InStream.Size) - D1);
 end else MimeEncodeLine(InStream, OutStream, InStream.Size);
end;

procedure MimeDecode(InStream, OutStream: TStream); overload;
var
 B, N, Pos, Limit: Cardinal;
 C: Byte;
 OutBuf: TByte3;
begin
 if InStream.Size <> 0 then begin
  InStream.Position := 0;
  B := 0;
  N := 4;
  Limit := InStream.Size;
  Pos := 0;
  while Pos <> Limit do begin
   InStream.ReadBuffer(C, SizeOf(C));
   Inc(Pos);
   C := DecodeTable[C];
   if C = 255 then Continue;
   B := (B shl 6) or C;
   Dec(N);
   if N <> 0 then Continue;
   OutBuf[3] := Lo(B);
   B := B shr 8;
   OutBuf[2] := Lo(B);
   B := B shr 8;
   OutBuf[1] := Lo(B);
   B := 0;
   N := 4;
   OutStream.WriteBuffer(OutBuf, SizeOf(OutBuf));
  end;
  case N of
   1: begin
    B := B shr 2;
    OutBuf[2] := Lo(B);
    B := B shr 8;
    OutBuf[1] := Lo(B);
    OutStream.WriteBuffer(OutBuf, 2);
   end;
   2: begin
    B := B shr 4;
    OutBuf[1] := Lo(B);
    OutStream.WriteBuffer(OutBuf, 1);
   end;
  end;
 end;
end;


initialization
 InitMemFuncs;

end.

