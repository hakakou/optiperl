{*******************************************************}
{                                                       }
{                                                       }
{                                                       }
{                                                       }
{*******************************************************}

unit Utils;

interface

uses Windows, Classes, Variants, SysUtils, Messages;

// color functions
type
  TColor = -$7FFFFFFF-1..$7FFFFFFF;

function StrToColor(const S: string): TColor;

type
  TPlatform = (plWin32s, plWin95, plWin98, plWinNT, plWin2000);

implementation

function StrToColor(const S: string): TColor;
begin
  Result := TColor(StrToInt(S));
end;

initialization
end.