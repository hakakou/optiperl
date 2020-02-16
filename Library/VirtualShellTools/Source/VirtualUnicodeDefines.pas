unit VirtualUnicodeDefines;

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

// This unit remaps Unicode API functions to dynamiclly loaded functions so that Win95
// applications can still use VSTools.

// The following are implemented in Win 95:
//  EnumResourceLanguagesW
//  EnumResourceNamesW
//  EnumResourceTypesW
//  ExtTextOutW
//  FindResourceW
//  FindResourceExW
//  GetCharWidthW
//  GetCommandLineW
//  GetTextExtentPoint32W
//  GetTextExtentPointW
//  lstrlenW
//  MessageBoxExW
//  MessageBoxW
//  MultiByteToWideChar
//  TextOutW
//  WideCharToMultiByte

interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ShellAPI, ActiveX,
  ShlObj, ComCtrls, ComObj, Forms, CommCtrl;

var
  GetDriveTypeW_VST: function(lpRootPathName: PWideChar): UINT; stdcall;
  DrawTextW_VST: function(hDC: HDC; lpString: PWideChar; nCount: Integer;
    var lpRect: TRect; uFormat: UINT): Integer; stdcall;
  SHGetFileInfoW_VST: function(pszPath: PWideChar; dwFileAttributes: DWORD;
    var psfi: TSHFileInfoW; cbFileInfo, uFlags: UINT): DWORD; stdcall;
  CreateFileW_VST: function(lpFileName: PWideChar; dwDesiredAccess, dwShareMode: DWORD;
    lpSecurityAttributes: PSecurityAttributes; dwCreationDisposition, dwFlagsAndAttributes: DWORD;
    hTemplateFile: THandle): THandle; stdcall;
  SHGetDataFromIDListW_VST: function(psf: IShellFolder; pidl: PItemIDList;
    nFormat: Integer; ptr: Pointer; cb: Integer): HResult; stdcall;
  FindFirstFileW_VST: function(lpFileName: PWideChar; var lpFindFileData: TWIN32FindDataW): THandle; stdcall;
    GetDiskFreeSpaceW_VST: function(lpRootPathName: PWideChar; var lpSectorsPerCluster,
    lpBytesPerSector, lpNumberOfFreeClusters, lpTotalNumberOfClusters: DWORD): BOOL; stdcall;
  lstrcmpiW_VST: function(lpString1, lpString2: PWideChar): Integer; stdcall;
  CharLowerBuffW_VST: function(lpsz: PWideChar; cchLength: DWORD): DWORD; stdcall;
  CreateDirectoryW_VST: function(lpPathName: PWideChar; lpSecurityAttributes: PSecurityAttributes): BOOL; stdcall;
  GetFullPathNameW_VST: function(lpFileName: PWideChar; nBufferLength: DWORD; lpBuffer: PWideChar; var lpFilePart: PWideChar): DWORD; stdcall;
  ShellExecuteExW_VST: function(lpExecInfo: PShellExecuteInfoW):BOOL; stdcall;
  FindFirstChangeNotificationW_VST: function(lpPathName: PWideChar;
    bWatchSubtree: BOOL; dwNotifyFilter: DWORD): THandle; stdcall;
  GetCharABCWidthsW_VST: function(DC: HDC; FirstChar, LastChar: UINT; const ABCStructs): BOOL; stdcall;
  GetFileAttributesW_VST: function(lpFileName: PWideChar): DWORD; stdcall;
  GetSystemDirectoryW_VST: function(lpBuffer: PWideChar; uSize: UINT): UINT; stdcall;
  GetWindowsDirectoryW_VST: function(lpBuffer: PWideChar; uSize: UINT): UINT; stdcall;
  // Robert
  SHMultiFileProperties_VST: function(pdtobj: IDataObject; dwFlags: DWORD): HResult; stdcall;
  GetDiskFreeSpaceExA_VST: function(lpDirectoryName: PAnsiChar;
    var lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes; lpTotalNumberOfFreeBytes: PLargeInteger): BOOL; stdcall;
  GetDiskFreeSpaceExW_VST: function(lpDirectoryName: PWideChar; var lpFreeBytesAvailableToCaller,
    lpTotalNumberOfBytes; lpTotalNumberOfFreeBytes: PLargeInteger): BOOL; stdcall;
  GetNumberFormatW_VST: function(Locale: LCID; dwFlags: DWORD; lpValue: PWideChar;
    lpFormat: PNumberFmtW; lpNumberStr: PWideChar; cchNumber: Integer): Integer; stdcall;

implementation

var
  Shell32Handle,
  Kernel32Handle,
  User32Handle,
  GDI32Handle: THandle;

initialization
  // We can be sure these are already loaded.  This keeps us from having to
  // reference count when VSTools is being used in an OCX
  Shell32Handle := GetModuleHandle(Shell32);
  Kernel32Handle := GetModuleHandle(Kernel32);
  User32Handle := GetModuleHandle(User32);
  GDI32Handle := GetModuleHandle(GDI32);

  GetDiskFreeSpaceExA_VST := GetProcAddress(Kernel32Handle, 'GetDiskFreeSpaceA');

  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    GetDriveTypeW_VST := GetProcAddress(Kernel32Handle, 'GetDriveTypeW');
    DrawTextW_VST := GetProcAddress(User32Handle, 'DrawTextW');
    SHGetFileInfoW_VST := GetProcAddress(Shell32Handle, 'SHGetFileInfoW');
    CreateFileW_VST := GetProcAddress(Kernel32Handle, 'CreateFileW');
    SHGetDataFromIDListW_VST := GetProcAddress(Shell32Handle, 'SHGetDataFromIDListW');
    FindFirstFileW_VST := GetProcAddress(Kernel32Handle, 'FindFirstFileW');
    lstrcmpiW_VST := GetProcAddress(Kernel32Handle, 'lstrcmpiW');
    CharLowerBuffW_VST := GetProcAddress(User32Handle, 'CharLowerBuffW');
    CreateDirectoryW_VST := GetProcAddress(Kernel32Handle, 'CreateDirectoryW');
    GetFullPathNameW_VST := GetProcAddress(Kernel32Handle, 'GetFullPathNameW');
    ShellExecuteExW_VST := GetProcAddress(Shell32Handle, 'ShellExecuteExW');
    FindFirstChangeNotificationW_VST := GetProcAddress(Kernel32Handle, 'FindFirstChangeNotificationW');
    GetCharABCWidthsW_VST := GetProcAddress(GDI32Handle, 'GetCharABCWidthsW');
    GetFileAttributesW_VST := GetProcAddress(Kernel32Handle, 'GetFileAttributesW');
    GetSystemDirectoryW_VST := GetProcAddress(Kernel32Handle, 'GetSystemDirectoryW');
    GetWindowsDirectoryW_VST := GetProcAddress(Kernel32Handle, 'GetWindowsDirectoryW');
    GetDiskFreeSpaceExW_VST := GetProcAddress(Kernel32Handle, 'GetDiskFreeSpaceExW');
    // SHMultiFileProperties only supported on Win2k and WinXP
    // http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/shell/reference/functions/shmultifileproperties.asp
    SHMultiFileProperties_VST := GetProcAddress(Shell32Handle, PChar(716));
    GetNumberFormatW_VST := GetProcAddress(Kernel32Handle, 'GetNumberFormatW');
  end;

finalization

end.
