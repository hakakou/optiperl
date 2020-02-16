unit VirtualUtilities;

// Version 1.5.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------

interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms,
  Menus,
  Math;

  // Helpers to create a callback function out of a object method
function CreateStub(ObjectPtr: Pointer; MethodPtr: Pointer): Pointer;
procedure DisposeStub(Stub: Pointer);

//
function AbsRect(Rect: TRect): TRect;
function DiffRectHorz(Rect1, Rect2: TRect): TRect;
function DiffRectVert(Rect1, Rect2: TRect): TRect;
function DragDetectPlus(Handle: HWND; Pt: TPoint): Boolean;
procedure FreeMemAndNil(var P: Pointer);
function IsUnicode: Boolean;    // OS supports Unicode functions (basiclly means IsWinNT or XP)
function IsWin2000: Boolean;
function IsWin95_SR1: Boolean;
function IsWinME: Boolean;
function IsWinNT4: Boolean;
function IsWinXP: Boolean;
{$EXTERNALSYM MAKE_HRESULT}
function MAKE_HRESULT(sev, fac: LongWord; code: Word): HResult;
function WinMsgBox(const Text: WideString; const Caption: WideString; uType: integer): integer;


{$IFNDEF DELPHI_5_UP}
procedure FreeAndNil(var Obj);
procedure ClearMenuItems(Menu: TMenu);
{$ENDIF DELPHI_5_UP}


implementation

  // Helpers to create a callback function out of a object method


{ ----------------------------------------------------------------------------- }
{ This is a piece of magic by Jeroen Mineur.  Allows a class method to be used  }
{ as a callback. Create a stub using CreateStub with the instance of the object }
{ the callback should call as the first parameter and the method as the second  }
{ parameter, ie @TForm1.MyCallback or declare a type of object for the callback }
{ method and then use a variable of that type and set the variable to the       }
{ method and pass it:                                                           }
{                                                                               }
{ DON'T FORGET TO DEFINE THE FUNCTION METHOD AS "STDCALL" FOR A WINDOWS         }
{  CALLBACK.  ALL KINDS OF WEIRD THINGS CAN HAPPEN IF YOU DON'T                 }
{                                                                               }
{ type                                                                          }
{   TEnumWindowsFunc = function (AHandle: hWnd; Param: lParam): BOOL of object; stdcall; }
{                                                                               }
{  TForm1 = class(TForm)                                                        }
{  private                                                                      }
{    function EnumWindowsProc(AHandle: hWnd; Param: lParam): BOOL; stdcall;     }
{  end;                                                                         }
{                                                                               }
{  var                                                                          }
{    MyFunc: TEnumWindowsFunc;                                                  }
{    Stub: pointer;                                                             }
{  begin                                                                        }
{    MyFunct := EnumWindowsProc;                                                }
{    Stub := CreateStub(Self, MyFunct);                                         }
{     ....                                                                      }
{  or                                                                           }
{                                                                               }
{  var                                                                          }
{    Stub: pointer;                                                             }
{  begin                                                                        }
{    Stub := CreateStub(Self, @TForm1.EnumWindowsProc);                         }
{     ....                                                                      }
{  Now Stub can be passed as the callback pointer to any windows API          }
{  Don't forget to call Dispose Stub when not needed        }
{ ----------------------------------------------------------------------------- }
const
  AsmPopEDX = $5A;
  AsmMovEAX = $B8;
  AsmPushEAX = $50;
  AsmPushEDX = $52;
  AsmJmpShort = $E9;

type
  TStub = packed record
    PopEDX: Byte;
    MovEAX: Byte;
    SelfPointer: Pointer;
    PushEAX: Byte;
    PushEDX: Byte;
    JmpShort: Byte;
    Displacement: Integer;
  end;

{ ----------------------------------------------------------------------------- }
function CreateStub(ObjectPtr: Pointer; MethodPtr: Pointer): Pointer;
var
  Stub: ^TStub;
begin
  // Allocate memory for the stub
  // 1/10/04 Support for 64 bit, executable code must be in virtual space
  // currently New/Dispose use Virtual space but a replacement memory manager
  // may not
  Stub := VirtualAlloc(nil, SizeOf(TStub), MEM_COMMIT, PAGE_EXECUTE_READWRITE);

  // Pop the return address off the stack
  Stub^.PopEDX := AsmPopEDX;

  // Push the object pointer on the stack
  Stub^.MovEAX := AsmMovEAX;
  Stub^.SelfPointer := ObjectPtr;
  Stub^.PushEAX := AsmPushEAX;

  // Push the return address back on the stack
  Stub^.PushEDX := AsmPushEDX;

  // Jump to the 'real' procedure, the method.
  Stub^.JmpShort := AsmJmpShort;
  Stub^.Displacement := (Integer(MethodPtr) - Integer(@(Stub^.JmpShort))) -
    (SizeOf(Stub^.JmpShort) + SizeOf(Stub^.Displacement));

  // Return a pointer to the stub
  Result := Stub;
end;
{ ----------------------------------------------------------------------------- }

{ ----------------------------------------------------------------------------- }
procedure DisposeStub(Stub: Pointer);
begin
  // 1/10/04 Support for 64 bit, executable code must be in virtual space
  // currently New/Dispose use Virtual space but a replacement memory manager
  // may not
  VirtualFree(Stub, SizeOf(TStub),MEM_DECOMMIT);  
end;
{ ----------------------------------------------------------------------------- }
//  MAKE_HRESULT(sev,fac,code)
//  ((HRESULT) (((unsigned long)(sev)<<31) | ((unsigned long)(fac)<<16) | ((unsigned long)(code))) )
function MAKE_HRESULT(sev, fac: LongWord; code: Word): HResult;
begin
  Result := LongInt( (sev shl 31) or (fac shl 16) or code)
end;

{$IFNDEF DELPHI_5_UP}
procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

procedure ClearMenuItems(Menu: TMenu);
var
  I: Integer;
begin
  for I := Menu.Items.Count - 1 downto 0 do
    Menu.Items[I].Free;
end;
{$ENDIF DELPHI_5_UP}

function DiffRectHorz(Rect1, Rect2: TRect): TRect;
// Returns the "difference" rectangle of the passed rects in the Horz direction.
// Assumes that one corner is common between the two rects
begin
  Rect1 := ABSRect(Rect1);
  Rect2 := ABSRect(Rect2);
  // Make sure we contain every thing horizontally
  Result.Left := Min(Rect1.Left, Rect2.Left);
  Result.Right := Max(Rect1.Right, Rect1.Right);
  // Now find the difference rect height
  if Rect1.Top = Rect2.Top then
  begin
    // The tops are equal so it must be the bottom that contains the difference
    Result.Bottom := Max(Rect1.Bottom, Rect2.Bottom);
    Result.Top := Min(Rect1.Bottom, Rect2.Bottom);
  end else
  begin
   // The bottoms are equal so it must be the tops that contains the difference
    Result.Bottom := Max(Rect1.Top, Rect2.Top);
    Result.Top := Min(Rect1.Top, Rect2.Top);
  end
end;

function DiffRectVert(Rect1, Rect2: TRect): TRect;
// Returns the "difference" rectangle of the passed rects in the Vert direction.
// Assumes that one corner is common between the two rects
begin
  Rect1 := ABSRect(Rect1);
  Rect2 := ABSRect(Rect2);
  // Make sure we contain every thing vertically
  Result.Top := Min(Rect1.Top, Rect2.Bottom);
  Result.Bottom := Max(Rect1.Top, Rect1.Bottom);
  // Now find the difference rect width
  if Rect1.Left = Rect2.Left then
  begin
    // The tops are equal so it must be the bottom that contains the difference
    Result.Right := Max(Rect1.Right, Rect2.Right);
    Result.Left := Min(Rect1.Right, Rect2.Right);
  end else
  begin
   // The bottoms are equal so it must be the tops that contains the difference
    Result.Right := Max(Rect1.Left, Rect2.Left);
    Result.Left := Min(Rect1.Left, Rect2.Left);
  end
end;

function AbsRect(Rect: TRect): TRect;
// Makes sure a rectangle's left is less than its right and its top is less than its bottom
var
  Temp: integer;
begin
  Result := Rect;
  if Result.Right < Result.Left then
  begin
    Temp := Result.Right;
    Result.Right := Rect.Left;
    Result.Left := Temp;
  end;
  if Rect.Bottom < Rect.Top then
  begin
    Temp := Result.Top;
    Result.Top := Rect.Bottom;
    Result.Bottom := Temp;
  end
end;

function DragDetectPlus(Handle: HWND; Pt: TPoint): Boolean;
//  Replacement for DragDetect API which is buggy.
//    Pt is in Client Coords of the Handle window
var
  DragRect: TRect;
  Msg: TMsg;
  TestPt: TPoint;
  HadCapture, Done: Boolean;
begin
  Result := False;
  Done := False;
  HadCapture := GetCapture = Handle;
  DragRect.TopLeft := Pt;
  DragRect.BottomRight := Pt;
  InflateRect(DragRect, GetSystemMetrics(SM_CXDRAG),
    GetSystemMetrics(SM_CYDRAG));
  SetCapture(Handle);
  try
    while (not Result) and (not Done) do
      if (PeekMessage(Msg, Handle, 0,0, PM_REMOVE)) then
      begin
        case (Msg.message) of
          WM_MOUSEMOVE:
          begin
            TestPt := Msg.Pt;
            // Not sure why this works.  The Message point "should" be in client
            // coordinates but seem to be screen
     //       Windows.ClientToScreen(Msg.hWnd, TestPt);
            Result := not(PtInRect(DragRect, TestPt));
          end;
          WM_RBUTTONUP,
          WM_LBUTTONUP,
          WM_CANCELMODE,
          WM_QUIT,
          WM_LBUTTONDBLCLK:
            begin                     
              // Let the window get these messages after we have ended our
              // local message loop
              PostMessage(Msg.hWnd, Msg.message, Msg.wParam, Msg.lParam);
              Done := True;
            end;
        else
          TranslateMessage(Msg);
          DispatchMessage(Msg)
        end
      end else
        Sleep(0);
  finally
    ReleaseCapture;
    if HadCapture then
      Mouse.Capture := Handle;
  end;
end;

procedure FreeMemAndNil(var P: Pointer);
{ Frees the memeory allocated with GetMem and nils the pointer                  }
var
  Temp: Pointer;
begin
  Temp := P;
  P := nil;
  FreeMem(Temp);
end;

function IsUnicode: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT
end;

function IsWin2000: Boolean;
begin
  Result := False;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := LoWord(Win32MajorVersion) >= 5
end;

function IsWin95_SR1: Boolean;
begin
  Result := False;
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
    Result :=  ((Win32MajorVersion = 4) and
                (Win32MinorVersion = 0) and
                (LoWord(Win32BuildNumber) <= 1080))
end;

function IsWinME: Boolean;
begin
  Result := False;
  if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
    Result := Win32BuildNumber >= $045A0BB8
end;

function IsWinNT4: Boolean;
begin
  Result := False;
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    Result := Win32MajorVersion < 5
end;

function IsWinXP: Boolean;
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion = 5)
    and (Win32MinorVersion > 0)
end;


function WinMsgBox(const Text: WideString; const Caption: WideString; uType: integer): integer;
var
 TextA, CaptionA: string;
begin
 if IsUnicode then
   Result := MessageBoxW(Application.Handle, PWideChar( Text), PWideChar( Caption), uType)
 else begin
   TextA := Text;
   CaptionA := Caption;
   Result := MessageBoxA(Application.Handle, PChar( TextA), PChar( CaptionA), uType)
 end
end;


end.
