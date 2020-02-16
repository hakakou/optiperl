// Delphi interface to 7-zip32.dll
// Written by Dominic Dumée (dominic@psas.co.za)
// Purpose: to create and extract files in the 7-zip format (www.7-zip.org)

// 7-zip32.dll written by Akky. Download it here:
// http://akky.cjb.net/download/7-zip32.html

// NB: I don't understand Japanese (no english docs are available for the dll)
// so I don't understand the purpose of all of the functions available,
// such as Set/GetCursorInterval, Cursormode etc...

// If anyone out there can provide more info on all the functions in the dll
// please let me know... :)

//-----------------------------------------------------------------------------
// HOW TO USE IT:
// Your program first needs to call LoadSevenZipDLL before any of the functions
// will work. Call UnloadSevenZipDLL when your program terminates...
// Obviously 7-zip32.dll file must be available to program (such as in the
// app's exe folder).

// Use SevenZipCreateArchive, SevenZipExtractArchive function to easily create
// and extract 7z files (with optional callback function)

// If you know what you're doing use SevenZipCommand function (works just like
// command line version of 7-zip). See 7-zip docs for command syntax.

// To get contents of archive file use SevenZipOpenArchive, SevenZipFindFirst,
// SevenZipFindNext and SevenZipCloseArchive (works like FindFirst, FindNext) 

//-----------------------------------------------------------------------------
// Revision history:
// v1.00 17 June 2005 - First release
// If you find any bugs or add any features please let me know

// v1.01 1 September 2005
// new feature:
//  --> Add parameter Password in SevenZipCreateArchive and SevenZipExtractArchive function
//      by Jéter Rabelo Ferreira (jeter.rabelo@jerasoft.com.br)

// --> Added BaseDirectory parameter to SevenZipCreateArchive for easier handling of
//     relative paths (note that absolute paths ARE NOT supported by the DLL) [Dominic Dumée]

unit SevenZip;

interface
uses windows, classes;

const
  // codes returned by SevenZipCreateArchive and SevenZipExtractArchive
  SZ_OK = 0;
  SZ_ERROR = 1;
  SZ_CANCELLED = 2;
  SZ_DLLERROR = 3;

  FNAME_MAX32	= 512;
  // these get returned as nState in the Callback function
  ARCEXTRACT_BEGIN = 0;
  ARCEXTRACT_INPROCESS = 1;
  ARCEXTRACT_END = 2;
  ARCEXTRACT_OPEN	= 3;
  ARCEXTRACT_COPY	= 4;

  // functions (QueryFunctionList)
  ISARC								            = 0	; (* SevenZip *)
  ISARC_GET_VERSION					      = 1	; (* SevenZipGetVersion *)
  ISARC_GET_CURSOR_INTERVAL			  = 2	; (* SevenZipGetCursorInterval *)
  ISARC_SET_CURSOR_INTERVAL			  = 3	; (* SevenZipSetCursorInterval *)
  ISARC_GET_BACK_GROUND_MODE			= 4	; (* SevenZipGetBackGroundMode *)
  ISARC_SET_BACK_GROUND_MODE			= 5	; (* SevenZipSetBackGroundMode *)
  ISARC_GET_CURSOR_MODE				    = 6	; (* SevenZipGetCursorMode *)
  ISARC_SET_CURSOR_MODE				    = 7	; (* SevenZipSetCursorMode *)
  ISARC_GET_RUNNING					      = 8	; (* SevenZipGetRunning *)

  ISARC_CHECK_ARCHIVE					    = 16	; (* SevenZipCheckArchive *)
  ISARC_CONFIG_DIALOG					    = 17	; (* SevenZipConfigDialog *)
  ISARC_GET_FILE_COUNT				    = 18	; (* SevenZipGetFileCount *)
  ISARC_QUERY_FUNCTION_LIST			  = 19	; (* SevenZipQueryFunctionList *)
  ISARC_HOUT							        = 20	; (* SevenZipHOut *)
  ISARC_STRUCTOUT						      = 21	; (* SevenZipStructOut *)
  ISARC_GET_ARC_FILE_INFO				  = 22	; (* SevenZipGetArcFileInfo *)

  ISARC_OPEN_ARCHIVE					    = 23	; (* SevenZipOpenArchive *)
  ISARC_CLOSE_ARCHIVE					    = 24	; (* SevenZipCloseArchive *)
  ISARC_FIND_FIRST					      = 25	; (* SevenZipFindFirst *)
  ISARC_FIND_NEXT						      = 26	; (* SevenZipFindNext *)
  ISARC_EXTRACT						        = 27	; (* SevenZipExtract *)
  ISARC_ADD							          = 28	; (* SevenZipAdd *)
  ISARC_MOVE							        = 29	; (* SevenZipMove *)
  ISARC_DELETE						        = 30	; (* SevenZipDelete *)
  ISARC_SETOWNERWINDOW				    = 31	; (* SevenZipSetOwnerWindow *)
  ISARC_CLEAROWNERWINDOW				  = 32	; (* SevenZipClearOwnerWindow *)
  ISARC_SETOWNERWINDOWEX				  = 33	; (* SevenZipSetOwnerWindowEx *)
  ISARC_KILLOWNERWINDOWEX				  = 34	; (* SevenZipKillOwnerWindowEx *)

  ISARC_GET_ARC_FILE_NAME				  = 40	; (* SevenZipGetArcFileName *)
  ISARC_GET_ARC_FILE_SIZE				  = 41	; (* SevenZipGetArcFileSize *)
  ISARC_GET_ARC_ORIGINAL_SIZE			= 42	; (* SevenZipArcOriginalSize *)
  ISARC_GET_ARC_COMPRESSED_SIZE		= 43	; (* SevenZipGetArcCompressedSize *)
  ISARC_GET_ARC_RATIO					    = 44	; (* SevenZipGetArcRatio *)
  ISARC_GET_ARC_DATE					    = 45	; (* SevenZipGetArcDate *)
  ISARC_GET_ARC_TIME					    = 46	; (* SevenZipGetArcTime *)
  ISARC_GET_ARC_OS_TYPE				    = 47	; (* SevenZipGetArcOSType *)
  ISARC_GET_ARC_IS_SFX_FILE			  = 48	; (* SevenZipGetArcIsSFXFile *)
  ISARC_GET_ARC_WRITE_TIME_EX			= 49	; (* SevenZipGetArcWriteTimeEx *)
  ISARC_GET_ARC_CREATE_TIME_EX		= 50	; (* SevenZipGetArcCreateTimeEx *)
 	ISARC_GET_ARC_ACCESS_TIME_EX		= 51	; (* SevenZipGetArcAccessTimeEx *)
 	ISARC_GET_ARC_CREATE_TIME_EX2		= 52	; (* SevenZipGetArcCreateTimeEx2 *)
  ISARC_GET_ARC_WRITE_TIME_EX2		= 53	; (* SevenZipGetArcWriteTimeEx2 *)
  ISARC_GET_FILE_NAME					    = 57	; (* SevenZipGetFileName *)
  ISARC_GET_ORIGINAL_SIZE				  = 58	; (* SevenZipGetOriginalSize *)
  ISARC_GET_COMPRESSED_SIZE			  = 59	; (* SevenZipGetCompressedSize *)
  ISARC_GET_RATIO						      = 60	; (* SevenZipGetRatio *)
  ISARC_GET_DATE						      = 61	; (* SevenZipGetDate *)
  ISARC_GET_TIME						      = 62	; (* SevenZipGetTime *)
  ISARC_GET_CRC						        = 63	; (* SevenZipGetCRC *)
  ISARC_GET_ATTRIBUTE					    = 64	; (* SevenZipGetAttribute *)
  ISARC_GET_OS_TYPE					      = 65	; (* SevenZipGetOSType *)
  ISARC_GET_METHOD					      = 66	; (* SevenZipGetMethod *)
  ISARC_GET_WRITE_TIME				    = 67	; (* SevenZipGetWriteTime *)
  ISARC_GET_CREATE_TIME				    = 68	; (* SevenZipGetCreateTime *)
  ISARC_GET_ACCESS_TIME				    = 69	; (* SevenZipGetAccessTime *)
  ISARC_GET_WRITE_TIME_EX				  = 70	; (* SevenZipGetWriteTimeEx *)
  ISARC_GET_CREATE_TIME_EX			  = 71	; (* SevenZipGetCreateTimeEx *)
  ISARC_GET_ACCESS_TIME_EX			  = 72	; (* SevenZipGetAccessTimeEx *)
  ISARC_SET_ENUM_MEMBERS_PROC			= 80 ; (* SevenZipSetEnumMembersProc *)
  ISARC_CLEAR_ENUM_MEMBERS_PROC		= 81	; (* SevenZipClearEnumMembersProc *)
  ISARC_GET_ARC_FILE_SIZE_EX			= 82	; (* SevenZipGetArcFileSizeEx *)
  ISARC_GET_ARC_ORIGINAL_SIZE_EX	=	83	; (* SevenZipArcOriginalSizeEx *)
  ISARC_GET_ARC_COMPRESSED_SIZE_EX = 84	; (* SevenZipGetArcCompressedSizeEx *)
  ISARC_GET_ORIGINAL_SIZE_EX			= 85	; (* SevenZipGetOriginalSizeEx *)
  ISARC_GET_COMPRESSED_SIZE_EX		= 86	; (* SevenZipGetCompressedSizeEx *)
  ISARC_SETOWNERWINDOWEX64			  = 87	; (* SevenZipSetOwnerWindowEx64 *)
  ISARC_KILLOWNERWINDOWEX64			  = 88	; (* SevenZipKillOwnerWindowEx64 *)
  ISARC_SET_ENUM_MEMBERS_PROC64		= 89  ; (* SevenZipSetEnumMembersProc64 *)
  ISARC_CLEAR_ENUM_MEMBERS_PROC64	= 90	; (* SevenZipClearEnumMembersProc64 *)
  ISARC_OPEN_ARCHIVE2					    = 91	; (* SevenZipOpenArchive2 *)
  ISARC_GET_ARC_READ_SIZE				  = 92	; (* SevenZipGetArcReadSize *)
  ISARC_GET_ARC_READ_SIZE_EX			= 93	; (* SevenZipGetArcReadSizeEx*)


// Errors
  ERROR_START				              = $8000;

// (* WARNING *)
  ERROR_DISK_SPACE		            = $8005;
  ERROR_READ_ONLY			            = $8006;
  ERROR_USER_SKIP			            = $8007;
  ERROR_UNKNOWN_TYPE		          = $8008;
  ERROR_METHOD			              = $8009;
  ERROR_PASSWORD_FILE		          = $800A;
  ERROR_VERSION			              = $800B;
  ERROR_FILE_CRC			            = $800C;
  ERROR_FILE_OPEN			            = $800D;
  ERROR_MORE_FRESH		            = $800E;
  ERROR_NOT_EXIST			            = $800F;
  ERROR_ALREADY_EXIST		          = $8010;

  ERROR_TOO_MANY_FILES	          = $8011;

// (* ERROR *)
  ERROR_MAKEDIRECTORY		          = $8012;
  ERROR_CANNOT_WRITE		          = $8013;
  ERROR_HUFFMAN_CODE		          = $8014;
  ERROR_COMMENT_HEADER	          = $8015;
  ERROR_HEADER_CRC		            = $8016;
  ERROR_HEADER_BROKEN		          = $8017;
  ERROR_ARC_FILE_OPEN		          = $8018;
  ERROR_NOT_ARC_FILE		          = $8019;
  ERROR_CANNOT_READ		            = $801A;
  ERROR_FILE_STYLE		            = $801B;
  ERROR_COMMAND_NAME		          = $801C;
  ERROR_MORE_HEAP_MEMORY	        = $801D;
  ERROR_ENOUGH_MEMORY		          = $801E;
  ERROR_ALREADY_RUNNING	          = $801F;
  ERROR_USER_CANCEL		            = $8020;
  ERROR_HARC_ISNOT_OPENED	        = $8021;
  ERROR_NOT_SEARCH_MODE	          = $8022;
  ERROR_NOT_SUPPORT		            = $8023;
  ERROR_TIME_STAMP		            = $8024;
  ERROR_TMP_OPEN			            = $8025;
  ERROR_LONG_FILE_NAME	          = $8026;
  ERROR_ARC_READ_ONLY		          = $8027;
  ERROR_SAME_NAME_FILE	          = $8028;
  ERROR_NOT_FIND_ARC_FILE         = $8029;
  ERROR_RESPONSE_READ		          = $802A;
  ERROR_NOT_FILENAME		          = $802B;
  ERROR_TMP_COPY			            = $802C;
  ERROR_EOF				                = $802D;
  ERROR_ADD_TO_LARC		            = $802E;
  ERROR_TMP_BACK_SPACE	          = $802F;
  ERROR_SHARING			              = $8030;
  ERROR_NOT_FIND_FILE		          = $8031;
  ERROR_LOG_FILE			            = $8032;
 	ERROR_NO_DEVICE			            = $8033;
  ERROR_GET_ATTRIBUTES	          = $8034;
  ERROR_SET_ATTRIBUTES	          = $8035;
  ERROR_GET_INFORMATION	          = $8036;
  ERROR_GET_POINT			            = $8037;
  ERROR_SET_POINT			            = $8038;
  ERROR_CONVERT_TIME		          = $8039;
  ERROR_GET_TIME			            = $803a;
  ERROR_SET_TIME			            = $803b;
  ERROR_CLOSE_FILE		            = $803c;
  ERROR_HEAP_MEMORY		            = $803d;
  ERROR_HANDLE			              = $803e;
  ERROR_TIME_STAMP_RANGE	        = $803f;
  ERROR_MAKE_ARCHIVE		          = $8040;
  ERROR_NOT_CONFIRM_NAME	        = $8041;
  ERROR_UNEXPECTED_EOF	          = $8042;
  ERROR_INVALID_END_MARK	        = $8043;
  ERROR_INVOLVED_LZH		          = $8044;
  ERROR_NO_END_MARK		            = $8045;
  ERROR_HDR_INVALID_SIZE	        = $8046;
  ERROR_UNKNOWN_LEVEL		          = $8047;
  ERROR_BROKEN_DATA		            = $8048;

  FA_RDONLY		 = $01;
  FA_HIDDEN		 = $02;
  FA_SYSTEM		 = $04;
  FA_LABEL		 = $08;
  FA_DIREC		 = $10;
  FA_ARCH 		 = $20;
  FA_ENCRYPTED = $40;

  ERROR_7ZIP_START                    = $8100;

  ERROR_WARNING		                    = $8101;
  ERROR_FATAL			                    = $8102;
  ERROR_DURING_DECOMPRESSION          = $8103;
  ERROR_DIR_FILE_WITH_64BIT_SIZE      = $8104;
  ERROR_FILE_CHANGED_DURING_OPERATION	= $8105;

  ARCHIVETYPE_ZIP	= 1;
  ARCHIVETYPE_7Z	=	2;


type

  HARC = integer;

  TSevenZipEXTRACTINGINFO = record
    dwFileSize          : DWORD;
    dwWriteSize         : DWORD;
    szSourceFileName    : array[ 0..FNAME_MAX32 ] of char;
    dummy1              : array[ 0..2 ] of char;
    szDestFileName      : array[ 0..FNAME_MAX32 ] of char;
    dummy               : array[ 0..2 ] of char;
  end;

  TSevenZipEXTRACTINGINFOEX = record
    exinfo           : TSevenZipEXTRACTINGINFO;
    dwCompressedSize : DWORD;
    dwCRC            : DWORD;
    uOSType          : UINT;
    wRatio           : WORD;
    wDate            : WORD;
    wTime            : WORD;
    szAttribute      : array[ 0..7 ] of char;
    szMode           : array[ 0..7 ] of char;
  end;

  TSevenZipINDIVIDUALINFO = record
    dwOriginalSize   : DWORD;
	  dwCompressedSize : DWORD;
	  dwCRC            : DWORD;
    uFlag            : UINT;
		uOSType          : UINT;
    wRatio           : WORD;
    wDate            : WORD;
    wTime            : WORD;
    szFilename       : array[ 0..FNAME_MAX32 ] of char;
    dummy1           : array[ 0..2 ] of char;
    szAttribute      : array[ 0..7 ] of char;
    szMode           : array[ 0..7 ] of char;
  end;

  TSevenZipCommand                = function (const hWnd: HWND; szCmdLine: PChar; szOutput: PChar; dwSize: DWORD): Integer; stdcall;
	TSevenZipGetVersion             = function : WORD; stdcall;
  TSevenZipGetCursorMode          = function : BOOL; stdcall;
  TSevenZipSetCursorMode          = function( CursorMode : BOOL ) : BOOL; stdcall;
  TSevenZipGetCursorInterval      = function : WORD; stdcall;
  TSevenZipSetCursorInterval      = function( CursorInterval : WORD ) : WORD; stdcall; // millisecs
  TSevenZipGetBackgroundMode      = function : BOOL; stdcall;
  TSevenZipSetBackgroundMode      = function( BackgroundMode : BOOL ) : BOOL; stdcall;
	TSevenZipGetRunning             = function : BOOL; stdcall;

  TSevenZipConfigDialog           = function( hwnd : HWND; szOptionBuffer : PChar; iMode : integer ) : BOOL; stdcall;
  TSevenZipCheckArchive           = function( szFilename : PChar; iMode : integer ) : BOOL; stdcall;
  TSevenZipGetFileCount           = function( szArcFile : PChar ) : integer; stdcall;
  TSevenZipQueryFunctionList      = function( iFunction : integer ) : BOOL; stdcall;

	TSevenZipOpenArchive            = function( hwnd : HWND; szFileName : PChar; dwMode : DWORD ) : HARC; stdcall;
	TSevenZipCloseArchive           = function( harc : HARC ) : integer; stdcall;
	TSevenZipFindFirst              = function( harc : HARC; szFilename : PChar; var lpSubInfo : TSevenZipINDIVIDUALINFO ) : integer; stdcall;
	TSevenZipFindNext               = function( harc : HARC; var lpSubInfo : TSevenZipINDIVIDUALINFO ) : integer; stdcall;
	TSevenZipGetArcFileName         = function( harc : HARC; lpBuffer : pchar; nSize : integer ) : integer; stdcall;
	TSevenZipGetArcFileSize         = function( harc : HARC ) : DWORD; stdcall;
	TSevenZipGetArcOriginalSize     = function( harc : HARC ) : DWORD; stdcall;
	TSevenZipGetArcCompressedSize   = function( harc : HARC ) : DWORD; stdcall;
	TSevenZipGetArcRatio            = function( harc : HARC ) : WORD; stdcall;
	TSevenZipGetArcDate             = function( harc : HARC ) : WORD; stdcall;
	TSevenZipGetArcTime             = function( harc : HARC ) : WORD; stdcall;
	TSevenZipGetArcOSType           = function( harc : HARC ) : UINT; stdcall;
	TSevenZipIsSFXFile              = function( harc : HARC ) : integer; stdcall;
	TSevenZipGetFileName            = function( harc : HARC ; lpBuffer : PChar; nsize : integer) : integer; stdcall;
	TSevenZipGetOriginalSize        = function( harc : HARC ) : DWORD; stdcall;
	TSevenZipGetCompressedSize      = function( harc : HARC ) : DWORD; stdcall;
	TSevenZipGetRatio               = function( harc : HARC ) : WORD; stdcall;
	TSevenZipGetDate                = function( harc : HARC ) : WORD; stdcall;
	TSevenZipGetTime                = function( harc : HARC ) : WORD; stdcall;
	TSevenZipGetCRC                 = function( harc : HARC ) : DWORD; stdcall;
	TSevenZipGetAttribute           = function( harc : HARC ) : integer; stdcall;
	TSevenZipGetOSType              = function( harc : HARC ) : UINT; stdcall;
	TSevenZipGetMethod              = function( harc : HARC ; lpBuffer : PChar; nsize : integer) : integer; stdcall;
	TSevenZipGetWriteTime           = function( harc : HARC ) : DWORD; stdcall;
	TSevenZipGetWriteTimeEx         = function( harc : HARC; var lpftLastWriteTime : FILETIME ) : BOOL; stdcall;
	TSevenZipGetArcCreateTimeEx     = function( harc : HARC; var lpftCreationTime : FILETIME ) : BOOL; stdcall;
	TSevenZipGetArcAccessTimeEx     = function( harc : HARC; var lpftLastAccessTime : FILETIME ) : BOOL; stdcall;
	TSevenZipGetArcWriteTimeEx      = function( harc : HARC; var lpftLastWriteTime : FILETIME ) : BOOL; stdcall;
	TSevenZipGetArcFileSizeEx       = function( harc : HARC; var lpllSize : TLargeInteger ) : BOOL; stdcall;
	TSevenZipGetArcOriginalSizeEx   = function( harc : HARC; var lpllSize : TLargeInteger ) : BOOL; stdcall;
	TSevenZipGetArcCompressedSizeEx = function( harc : HARC; var lpllSize : TLargeInteger ) : BOOL; stdcall;
	TSevenZipGetOriginalSizeEx      = function( harc : HARC; var lpllSize : TLargeInteger  ) : BOOL; stdcall;
	TSevenZipGetCompressedSizeEx    = function( harc : HARC; var lpllSize : TLargeInteger ) : BOOL; stdcall;

  // Callback func should return FALSE to cancel the archiving process, else TRUE
  TSevenZipCallbackProc           = function( hWnd : HWND; uMsg, nState : UINT; var ExInfo : TSevenZipEXTRACTINGINFOEX ) : BOOL; stdcall;

  TSevenZipSetOwnerWindow         = function( hwnd : HWND ) : BOOL; stdcall;
	TSevenZipClearOwnerWindow       = function : BOOL; stdcall;
  TSevenZipSetOwnerWindowEx       = function( hwnd : HWND; CallbackProc : TSevenZipCallbackProc ) : BOOL; stdcall;
	TSevenZipKillOwnerWindowEx      = function( hwnd : HWND ) : BOOL; stdcall;

	TSevenZipGetSubVersion          = function : WORD; stdcall;
	TSevenZipGetArchiveType         = function( szFileName : pchar ) : integer; stdcall;
	TSevenZipSetUnicodeMode         = function( bUnicode : BOOL ) : BOOL; stdcall;

function LoadSevenZipDLL : Boolean;
function UnloadSevenZipDLL : Boolean;

// NB: add '-hide' to command line switches if you want the CallBack function to be called
// (set up via SevenZipSetOwnerWindowEx).
// otherwise the DLL uses it's own internal progress dialog
function SevenZipCommand( hWnd : HWND;                     // parent window
                          CommandLine : string;            // 7zip command line (see 7zip docs)
                          var CommandOutput : string;      // returns 7zip output
                          MaxCommandOutputLen : integer = 32768 ) : integer;

// simplified func to create archive
function SevenZipCreateArchive( hWnd : HWND; // parent window handle
                                ArchiveFilename : string;
                                BaseDirectory : string; // all filenames in FileList must be relative to this directory (absolute paths e.g. "c:\temp\test.txt" not allowed, but "temp\test.txt" allowed)
                                FList : TStrings; // comma separated files to be added to archive (wildcards ok)
                                CompressionLevel : integer;   // 0 = none, 9=max
                                CreateSolidArchive : Boolean; // solid = better compression for multiple files
                                RecurseFolders : Boolean;     // recurse folders?
                                Password: String; // '' Nothing happens
                                ShowProgress   : Boolean;     // if true uses dll's internal progress indicator (callback func ignored)
                                Callback       : TSevenZipCallbackProc = nil ) // optional callback (ShowProgress must be false)
                                : integer;

// simplified func to extract archive
function SevenZipExtractArchive( hWnd : HWND; // parent window handle
                                 ArchiveFilename : string;
                                 FileList : string; // comma separated files to be extracted (wildcards ok)
                                 RecurseFolders : Boolean;
                                 Password: String; // '' Nothing happens
                                 ExtractFullPaths : Boolean;
                                 ExtractBaseDir : string;
                                 ShowProgress   : Boolean;     // if true uses dll's internal progress indicator (callback func ignored)
                                 Callback       : TSevenZipCallbackProc = nil ) // optional callback (ShowProgress must be false)
                                 : integer; // 0 = success


var
  _SevenZipCommand              : TSevenZipCommand              = nil;
  SevenZipGetVersion            : TSevenZipGetVersion           = nil;
  SevenZipGetCursorMode         : TSevenZipGetCursorMode        = nil;
  SevenZipSetCursorMode         : TSevenZipSetCursorMode        = nil;
  SevenZipGetCursorInterval     : TSevenZipGetCursorInterval    = nil;
  SevenZipSetCursorInterval     : TSevenZipSetCursorInterval    = nil;
  SevenZipGetBackgroundMode     : TSevenZipGetBackgroundMode    = nil;
  SevenZipSetBackgroundMode     : TSevenZipSetBackgroundMode    = nil;
  SevenZipGetRunning            : TSevenZipGetRunning           = nil;

  SevenZipConfigDialog          : TSevenZipConfigDialog         = nil;
  SevenZipCheckArchive          : TSevenZipCheckArchive         = nil;
  SevenZipGetFileCount          : TSevenZipGetFileCount         = nil;
  SevenZipQueryFunctionList     : TSevenZipQueryFunctionList    = nil;

  SevenZipOpenArchive           : TSevenZipOpenArchive          = nil;
  SevenZipCloseArchive          : TSevenZipCloseArchive         = nil;
  SevenZipFindFirst             : TSevenZipFindFirst            = nil;
  SevenZipFindNext              : TSevenZipFindNext             = nil;
  SevenZipGetArcFileName        : TSevenZipGetArcFileName       = nil;
  SevenZipGetArcFileSize        : TSevenZipGetArcFileSize       = nil;
  SevenZipGetArcOriginalSize    : TSevenZipGetArcOriginalSize   = nil;
  SevenZipGetArcCompressedSize  : TSevenZipGetArcCompressedSize = nil;
  SevenZipGetArcRatio           : TSevenZipGetArcRatio          = nil;
  SevenZipGetArcDate            : TSevenZipGetArcDate           = nil;
  SevenZipGetArcTime            : TSevenZipGetArcTime           = nil;
  SevenZipGetArcOSType          : TSevenZipGetArcOSType         = nil;
  SevenZipIsSFXFile             : TSevenZipIsSFXFile            = nil;
  SevenZipGetFileName           : TSevenZipGetFileName          = nil;
  SevenZipGetOriginalSize       : TSevenZipGetOriginalSize      = nil;
  SevenZipGetCompressedSize     : TSevenZipGetCompressedSize    = nil;
  SevenZipGetRatio              : TSevenZipGetRatio             = nil;
  SevenZipGetDate               : TSevenZipGetDate              = nil;   
  SevenZipGetTime               : TSevenZipGetTime              = nil;   
  SevenZipGetCRC                : TSevenZipGetCRC               = nil;
  SevenZipGetAttribute          : TSevenZipGetAttribute         = nil;   
  SevenZipGetOSType             : TSevenZipGetOSType            = nil;   
  SevenZipGetMethod             : TSevenZipGetMethod            = nil;   
  SevenZipGetWriteTime          : TSevenZipGetWriteTime         = nil;
  SevenZipGetWriteTimeEx        : TSevenZipGetWriteTimeEx       = nil;
  SevenZipGetArcCreateTimeEx    : TSevenZipGetArcCreateTimeEx   = nil;   
  SevenZipGetArcAccessTimeEx    : TSevenZipGetArcAccessTimeEx   = nil;   
  SevenZipGetArcWriteTimeEx     : TSevenZipGetArcWriteTimeEx    = nil;   
  SevenZipGetArcFileSizeEx      : TSevenZipGetArcFileSizeEx     = nil;   
  SevenZipGetArcOriginalSizeEx  : TSevenZipGetArcOriginalSizeEx = nil;   
  SevenZipGetArcCompressedSizeEx: TSevenZipGetArcCompressedSizeEx= nil;
  SevenZipGetOriginalSizeEx     : TSevenZipGetOriginalSizeEx    = nil; 
  SevenZipGetCompressedSizeEx   : TSevenZipGetCompressedSizeEx  = nil;

  SevenZipSetOwnerWindow        : TSevenZipSetOwnerWindow       = nil; 
  SevenZipClearOwnerWindow      : TSevenZipClearOwnerWindow     = nil; 
  SevenZipSetOwnerWindowEx      : TSevenZipSetOwnerWindowEx     = nil; 
  SevenZipKillOwnerWindowEx     : TSevenZipKillOwnerWindowEx    = nil; 

  SevenZipGetSubVersion         : TSevenZipGetSubVersion        = nil;
  SevenZipGetArchiveType        : TSevenZipGetArchiveType       = nil;
  SevenZipSetUnicodeMode        : TSevenZipSetUnicodeMode       = nil;

implementation
uses sysutils, dialogs;

var
  _SevenZipDLLHandle : THandle = 0;

function LoadSevenZipDLL : Boolean;

begin
  Result := FALSE;

  if _SevenZipDLLHandle <> 0 then
    exit;

  _SevenZipDLLHandle := LoadLibrary( '7-zip32.dll' );
  if _SevenZipDLLHandle > 0 then
  begin
    _SevenZipCommand             := GetProcAddress( _SevenZipDLLHandle, 'SevenZip' );

    SevenZipGetVersion           := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetVersion' );
    SevenZipGetCursorMode        := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetCursorMode' );
    SevenZipSetCursorMode        := GetProcAddress( _SevenZipDLLHandle, 'SevenZipSetCursorMode' );
    SevenZipGetCursorInterval    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetCursorInterval' );
    SevenZipSetCursorInterval    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipSetCursorInterval' );
    SevenZipGetBackgroundMode    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetBackgroundMode' );
    SevenZipSetBackgroundMode    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipSetBackgroundMode' );
    SevenZipGetRunning           := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetRunning' );

    SevenZipConfigDialog         := GetProcAddress( _SevenZipDLLHandle, 'SevenZipConfigDialog' );
    SevenZipCheckArchive         := GetProcAddress( _SevenZipDLLHandle, 'SevenZipCheckArchive' );
    SevenZipGetFileCount         := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetFileCount' );
    SevenZipQueryFunctionList    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipQueryFunctionList' );

    SevenZipOpenArchive          := GetProcAddress( _SevenZipDLLHandle, 'SevenZipOpenArchive' );
    SevenZipCloseArchive         := GetProcAddress( _SevenZipDLLHandle, 'SevenZipCloseArchive' );
    SevenZipFindFirst            := GetProcAddress( _SevenZipDLLHandle, 'SevenZipFindFirst' );
    SevenZipFindNext             := GetProcAddress( _SevenZipDLLHandle, 'SevenZipFindNext' );
    SevenZipGetArcFileName       := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcFileName' );      
    SevenZipGetArcFileSize       := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcFileSize' );      
    SevenZipGetArcOriginalSize   := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcOriginalSize' );  
    SevenZipGetArcCompressedSize := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcCompressedSize' );
    SevenZipGetArcRatio          := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcRatio' );         
    SevenZipGetArcDate           := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcDate' );          
    SevenZipGetArcTime           := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcTime' );          
    SevenZipGetArcOSType         := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcOSType' );        
    SevenZipIsSFXFile            := GetProcAddress( _SevenZipDLLHandle, 'SevenZipIsSFXFile' );           
    SevenZipGetFileName          := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetFileName' );         
    SevenZipGetOriginalSize      := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetOriginalSize' );     
    SevenZipGetCompressedSize    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetCompressedSize' );
    SevenZipGetRatio             := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetRatio' );            
    SevenZipGetDate              := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetDate' );             
    SevenZipGetTime              := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetTime' );             
    SevenZipGetCRC               := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetCRC' );              
    SevenZipGetAttribute         := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetAttribute' );         
    SevenZipGetOSType            := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetOSType' );            
    SevenZipGetMethod            := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetMethod' );            
    SevenZipGetWriteTime         := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetWriteTime' );         
    SevenZipGetWriteTimeEx       := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetWriteTimeEx' );       
    SevenZipGetArcCreateTimeEx   := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcCreateTimeEx' );   
    SevenZipGetArcAccessTimeEx   := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcAccessTimeEx' );   
    SevenZipGetArcWriteTimeEx    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcWriteTimeEx' );
    SevenZipGetArcFileSizeEx     := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcFileSizeEx' );
    SevenZipGetArcOriginalSizeEx := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcOriginalSizeEx' ); 
    SevenZipGetArcCompressedSizeEx := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArcCompressedSizeEx' );
    SevenZipGetOriginalSizeEx    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetOriginalSizeEx' );
    SevenZipGetCompressedSizeEx  := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetCompressedSizeEx' );

    SevenZipSetOwnerWindow       := GetProcAddress( _SevenZipDLLHandle, 'SevenZipSetOwnerWindow' );
    SevenZipClearOwnerWindow     := GetProcAddress( _SevenZipDLLHandle, 'SevenZipClearOwnerWindow' );
    SevenZipSetOwnerWindowEx     := GetProcAddress( _SevenZipDLLHandle, 'SevenZipSetOwnerWindowEx' );
    SevenZipKillOwnerWindowEx    := GetProcAddress( _SevenZipDLLHandle, 'SevenZipKillOwnerWindowEx' );

    SevenZipGetSubVersion        := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetSubVersion' );
    SevenZipGetArchiveType       := GetProcAddress( _SevenZipDLLHandle, 'SevenZipGetArchiveType' );
    SevenZipSetUnicodeMode       := GetProcAddress( _SevenZipDLLHandle, 'SevenZipSetUnicodeMode' );

    Result := TRUE;
  end;

end;

function UnloadSevenZipDLL : Boolean;

begin
  Result := FALSE;

  if _SevenZipDLLHandle <> 0 then
  begin
    FreeLibrary( _SevenZipDLLHandle );
    _SevenZipDLLHandle := 0;
    Result := TRUE;
  end;
end;

function SevenZipCommand( hWnd : HWND;
                          CommandLine : string;
                          var CommandOutput : string;
                          MaxCommandOutputLen : integer = 32768 ) : integer;

begin
  SetLength( CommandOutput, MaxCommandOutputLen );
  Result := _SevenZipCommand( hWnd, PChar( CommandLine), PChar( CommandOutput ), MaxCommandOutputLen - 1 );
  CommandOutput := string( PChar( CommandOutput ) );
end;

function RemoveQuotes( s : string ) : string;

begin
  if ( Copy( s, 1, 1 ) = '"' ) and ( Copy( s, Length( s ), 1 ) = '"' ) then
    Result := Copy( s, 2, Length( s ) - 2 )
  else
    Result := s;
end;

function SevenZipCreateArchive( hWnd : HWND; // parent window handle
                                ArchiveFilename : string;
                                BaseDirectory : string; // all filenames in FileList must be relative to this directory (absolute paths e.g. "c:\temp\test.txt" not allowed, but "temp\test.txt" allowed)
                                flist : TStrings; // comma separated files to be added to archive (wildcards ok) - all relative to BaseDirectory
                                CompressionLevel : integer;   // 0 = none, 9=max
                                CreateSolidArchive : Boolean; // solid = better compression for multiple files
                                RecurseFolders : Boolean;     // recurse folders?
                                Password: String; // '' Nothing happens
                                ShowProgress   : Boolean;     // if true uses dll's internal progress indicator (callback func ignored)
                                Callback       : TSevenZipCallbackProc = nil ) // optional callback (ShowProgress must be false)
                                : integer; // 0 = success

var

  S7ResultOutput : string;
  s7cmd : string;
  i : integer;
  cwd : string;

begin
  //
  cwd := GetCurrentDir;

  // change to base dir so relative paths work correctly
  if not SetCurrentDir( BaseDirectory ) then
  begin
    Result := SZ_ERROR;
    exit;
  end;

//  flist := TStringList.Create;
//  flist.CommaText := FileList;

  if @Callback <> nil then
    ShowProgress := FALSE;

  try
    s7cmd := 'a "' + ArchiveFilename + '" "' + RemoveQuotes( flist[ 0 ] ) + '"';

    for i := 1 to flist.count - 1 do
    begin
      s7cmd := s7cmd + ' -i';
      if RecurseFolders then
        s7cmd := s7cmd + 'r';

      s7cmd := s7cmd + '!"' + RemoveQuotes( flist[ i ] ) + '"';
    end;

    s7cmd := s7cmd + ' -mx' + IntToStr( CompressionLevel );
    if RecurseFolders then
      s7Cmd := s7cmd + ' -r';

    if Password <> '' then
      s7Cmd := s7Cmd + ' -p' + Password;

    if CreateSolidArchive then
      s7cmd := s7cmd + ' -ms=on'
    else
      s7cmd := s7cmd + ' -ms=off';

    if not ShowProgress then
      s7cmd := s7cmd + ' -hide';

    try
      SevenZipSetOwnerWindowEx( hwnd, Callback );

      SevenZipCommand( hWnd, s7cmd, s7ResultOutput );

      SevenZipSetOwnerWindowEx( hwnd, nil );

      S7ResultOutput := string(PChar(S7ResultOutput));

      if Pos( 'operation aborted', Lowercase( S7ResultOutput ) ) > 0 then
        Result := SZ_CANCELLED
      else
      if Pos('error:', LowerCase(S7ResultOutput)) > 0 then
        Result := SZ_ERROR
      else
        Result := SZ_OK;
    except
      on e : exception do
      begin
        Result := SZ_DLLERROR;
      end;
    end;

  finally
//    flist.Free;
    SetCurrentDir( cwd ); // back to where we were
  end;
end;

function SevenZipExtractArchive( hWnd : HWND; // parent window handle
                                ArchiveFilename : string;
                                FileList : string; // comma separated files to be extracted (wildcards ok)
                                RecurseFolders : Boolean;
                                Password: String; // '' Nothing happens
                                ExtractFullPaths : Boolean;
                                ExtractBaseDir : string;
                                ShowProgress   : Boolean;     // if true uses dll's internal progress indicator (callback func ignored)
                                Callback       : TSevenZipCallbackProc = nil ) // optional callback (ShowProgress must be false)
                                : integer; // 0 = success

var
  flist : TStringList;
  S7ResultOutput : string;
  s7cmd : string;
  i : integer;

begin
  //
  flist := TStringList.Create;
  flist.CommaText := FileList;

  if @Callback <> nil then
    ShowProgress := FALSE;

  if FileList = '' then
    FileList := '*.*';

  try
    if ExtractFullPaths then
      s7cmd := 'x'
    else
      s7cmd := 'e';

    s7cmd := s7cmd + ' "' + ArchiveFilename + '" -o"' + ExtractBaseDir + '"';

    s7cmd := s7cmd + ' "' + flist[ 0 ] + '"';


    for i := 1 to flist.count - 1 do
    begin
      s7cmd := s7cmd + ' -i';
      if RecurseFolders then
        s7cmd := s7cmd + 'r';

      s7cmd := s7cmd + '!"' + RemoveQuotes( flist[ i ] ) + '"';
    end;

    if RecurseFolders then
      s7cmd := s7cmd + ' -r';

    if Password <> '' then
      s7Cmd := s7Cmd + ' -p' + Password;  

    if not ShowProgress then
      s7cmd := s7cmd + ' -hide';

    s7cmd := s7cmd + ' -y'; // yes on all queries (will overwrite)

    try
      SevenZipSetOwnerWindowEx( hwnd, Callback );

      SevenZipCommand( hWnd, s7cmd, s7ResultOutput );

      SevenZipSetOwnerWindowEx( hwnd, nil );

      S7ResultOutput := string(PChar(S7ResultOutput));

      if Pos( 'operation aborted', Lowercase( S7ResultOutput ) ) > 0 then
        Result := SZ_CANCELLED
      else
      if Pos('error:', LowerCase(S7ResultOutput)) > 0 then
        Result := SZ_ERROR
      else
        Result := SZ_OK;
    except
      on e : exception do
      begin
        Result := SZ_DLLERROR;
      end;
    end;

  finally
    flist.Free;
  end;
end;


end.
