{*******************************************************}
{                                                       }
{       Alex Ghost Library                              }
{                                                       }
{       Copyright (c) 1999,2000 Alexey Popov            }
{                                                       }
{*******************************************************}

{$I AG.INC}

unit agUtils;

interface

uses Windows, Classes,variants;

// color functions

type
  TColor = -$7FFFFFFF-1..$7FFFFFFF;

function ColorToRGB(Color: TColor): Longint;
function ColorToStr(Color: TColor): string;
function StrToColor(const S: string): TColor;

const
  MsgWindowTitle: string = '';
  MsgWindowFlags: UINT = 0;

// MessageBox wrappers
function ShowMsg(Handle: HWnd; Title,Msg: string; Flags: UINT): integer;
procedure ErrorMsg(Msg: string);
procedure WarningMsg(Msg: string);
procedure InfoMsg(Msg: string);
function YesNoMsg(Msg: string): integer;
function YesNoCancelMsg(Msg: string): integer;

// getting system dirs
function GetTempDir: string;
function GetWindowsDir: string;
function GetSystemDir: string;

// miscellaneous functions
function WidthOf(R: TRect): Integer;
function HeightOf(R: TRect): Integer;
procedure CenterWindow(Wnd: HWnd);
procedure RefreshWindow(Wnd: HWnd);
function ScreenSize: TSize;
procedure Beep;
function GetEnvVar(const VarName: string): string;

// OS version
type
  TPlatform = (plWin32s, plWin95, plWin98, plWinNT, plWin2000);
  TOSVersion = packed record
    Platform: TPlatform;
    MajorVersion, MinorVersion: integer;
    VersionStr: string;
    Build: integer;
    CSDVersion: string;
    FullVersionStr: string;
  end;

var
  OSVersion: TOSVersion;
  {$IFNDEF D4}
  HexDisplayPrefix: string = '$';
  {$ENDIF}

implementation

uses SysUtils, Messages, agStrUtils, agArithm;

function Rect(ALeft, ATop, ARight, ABottom: Integer): TRect;
begin
  with Result do begin
    Left:=ALeft; Top:=ATop; Right:=ARight; Bottom:=ABottom;
  end;
end;

// thanks to Pavel Schurenko (pasha@ics.kiev.ua)
const
  MsgHook: integer = 0;

function CenterMsgWindow(Code: Integer; WParam: WPARAM; LParam: LPARAM): LRESULT; stdcall;
begin
  if Code = HCBT_ACTIVATE then begin
    CenterWindow(WParam);
    Result:=CallNextHookEx(MsgHook,Code,WParam,LParam);
    UnhookWindowsHookEx(MsgHook);
    MsgHook:=0;
  end else
    Result:=0;
end;

function ShowMsg(Handle: HWnd; Title,Msg: string; Flags: UINT): integer;
begin
  MsgHook:=SetWindowsHookEx(WH_CBT,CenterMsgWindow,0,GetCurrentThreadId);
  try
    Result:=MessageBox(Handle,PChar(Msg),PChar(Title),
      MB_TASKMODAL or MsgWindowFlags or Flags);
  finally
    if MsgHook <> 0 then begin
      UnhookWindowsHookEx(MsgHook);
      MsgHook:=0;
    end;
  end;
end;

procedure ErrorMsg(Msg: string);
begin
  ShowMsg(0,VarToStr(iif(MsgWindowTitle = '','Error',MsgWindowTitle)),Msg,
    MB_ICONERROR);
end;

procedure WarningMsg(Msg: string);
begin
  ShowMsg(0,VarToStr(iif(MsgWindowTitle = '','Warning',MsgWindowTitle)),Msg,
    MB_ICONWARNING);
end;

procedure InfoMsg(Msg: string);
begin
  ShowMsg(0,VarToStr(iif(MsgWindowTitle = '','Information',MsgWindowTitle)),Msg,
    MB_ICONINFORMATION);
end;

function YesNoMsg(Msg: string): integer;
begin
  Result:=ShowMsg(0,VarToStr(iif(MsgWindowTitle = '','Question',MsgWindowTitle)),
    Msg,MB_YESNO or MB_ICONQUESTION);
end;

function YesNoCancelMsg(Msg: string): integer;
begin
  Result:=ShowMsg(0,VarToStr(iif(MsgWindowTitle = '','Question',MsgWindowTitle)),
    Msg,MB_YESNOCANCEL or MB_ICONQUESTION);
end;

function WidthOf(R: TRect): Integer;
begin
  Result := R.Right - R.Left;
end;

function HeightOf(R: TRect): Integer;
begin
  Result := R.Bottom - R.Top;
end;

procedure Beep;
begin
  MessageBeep(0);
end;

function GetOSVersion: TOSVersion;
const
  CWindowsVersion = 'Windows %s %s.%.4d %s';
var
  OSVer: TOSVersion;
  s: string;
begin
  with OSVer do begin
    MajorVersion := Win32MajorVersion;
    MinorVersion := Win32MinorVersion;
    if MinorVersion = 0 then s := '%d.%d' else s := '%d.%.2d';
    VersionStr := Format(s, [MajorVersion, MinorVersion]);
    Build := Win32BuildNumber;
    CSDVersion := Win32CSDVersion;
    case Win32Platform of
      VER_PLATFORM_WIN32s: Platform := plWin32s;
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          Build := Win32BuildNumber and $0000FFFF;
          if (MajorVersion > 4) or ((MajorVersion = 4) and (MinorVersion >= 10))
            then Platform := plWin98
            else Platform := plWin95;
        end;
      VER_PLATFORM_WIN32_NT:
        if MajorVersion > 4 then Platform := plWin2000 else Platform := plWinNT;
    end;
    case Platform of
      plWin32s: s := '32s';
      plWin95: s := '95';
      plWin98: s := '98';
      plWinNT: s := 'NT';
      plWin2000: s := '2000';
    end;
    FullVersionStr := Trim(Format(CWindowsVersion, [s, VersionStr, Build, CSDVersion]));
  end;
  Result := OSVer;
end;

function GetEnvVar(const VarName: string): string;
begin
  SetLength(Result,2048);
  SetLength(Result,GetEnvironmentVariable(PChar(VarName), @Result[1], Length(Result)));
end;

procedure FitRectToScreen(var Rect: TRect);
var
  X,Y,Delta: Integer;
begin
  X:=ScreenSize.cx;
  Y:=ScreenSize.cy;
  with Rect do begin
    if Right > X then begin
      Delta := Right - Left;
      Right := X;
      Left := Right - Delta;
    end;
    if Left < 0 then begin
      Delta := Right - Left;
      Left := 0;
      Right := Left + Delta;
    end;
    if Bottom > Y then begin
      Delta := Bottom - Top;
      Bottom := Y;
      Top := Bottom - Delta;
    end;
    if Top < 0 then begin
      Delta := Bottom - Top;
      Top := 0;
      Bottom := Top + Delta;
    end;
  end;
end;

procedure CenterWindow(Wnd: HWnd);
var
  R: TRect;
begin
  GetWindowRect(Wnd,R);
  R:=Rect((ScreenSize.cx-(R.Right-R.Left)) div 2,
    (ScreenSize.cy-(R.Bottom-R.Top)) div 2,
    R.Right-R.Left,R.Bottom-R.Top);
  FitRectToScreen(R);
  SetWindowPos(Wnd,0,R.Left,R.Top,0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

function GetTempDir: string;
begin
  SetLength(Result,MAX_PATH);
  SetLength(Result,GetTempPath(length(Result),PChar(Result)));
end;

function GetWindowsDir: string;
begin
  SetLength(Result,GetWindowsDirectory(nil,0));
  SetLength(Result,GetWindowsDirectory(PChar(Result),length(Result)));
end;

function GetSystemDir: string;
begin
  SetLength(Result,GetSystemDirectory(nil,0));
  SetLength(Result,GetSystemDirectory(PChar(Result),length(Result)));
end;

function ColorToRGB(Color: TColor): Longint;
begin
  if Color < 0 then
    Result := GetSysColor(Color and $000000FF) else
    Result := Color;
end;

function ColorToStr(Color: TColor): string;
begin
  FmtStr(Result, '%s%.8x', [HexDisplayPrefix, Color]);
end;

function StrToColor(const S: string): TColor;
begin
  Result := TColor(StrToInt(S));
end;

function ScreenSize: TSize;
begin
  Result.cx:=GetSystemMetrics(SM_CXSCREEN);
  Result.cy:=GetSystemMetrics(SM_CYSCREEN);
end;

procedure RefreshWindow(Wnd: HWnd);
begin
  RedrawWindow(Wnd,nil,0,RDW_INVALIDATE or RDW_UPDATENOW);
end;

initialization
  OSVersion := GetOSVersion;

end.
