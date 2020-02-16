{Author:	Poul Bak}
{Copyright © 1999-2002 : BakSoft-Denmark (Poul Bak). All rights reserved.}
{http://home11.inet.tele.dk/BakSoft/}
{Mailto: baksoft-denmark@dk2net.dk}
{}
{Component Version: 7.00.00.00}
{}
{PBFolderDialog is SHBrowseForFolder dialog supporting both 'NewDialogStyle' for Windows ME/2000/XP and traditional style.}
{Supports new flags, for instance 'IncludeFiles' that lets you choose any object (files, controlpanel-applets etc.).}
{Both new and old style have a 'New folder' button to create new folders when browsing for a folder. It can show path above the window.}
{The 'New folder'-button caption and a 'Label'-caption (shown above the path) are automatically localized (national language) detected every time the application runs.}

{Thanks to Gaetano Giunta for great bug-fixing in version 1.20.00.00}
{Thanks to Daniel Deycard for reporting a problem with using large fonts in Windows.}
{Thanks to Peter Aschbacher for great translation and bug-reporting.}
{Thanks to Taine G. for fixing a network-folder problem.}
{Thanks to Oliver Sturm for fixing a bug changing captions at runtime.}
{Thanks to Diederik Wierenga for fixing a display-path problem.}
{Thanks to Laurent Baudrillard for great translations.}
{"Too many cooks spoil the broth !"}
{Thanks to Bernard White for fixing a bug introduced in version 2.00 (Delphi 3).}
{Thanks to Peter Magor for fixing a bug if application has no mainform.}
{Thanks to Peter Kueneman for giving some PIDL functions.}
{Thanks to Andreas Hesse for fixing a Window 2000/XP bug 
and help implementing the new flags.}

unit PBFolderDialog;

interface

uses
{$IFNDEF VER100}{$IFNDEF VER120}{$IFNDEF VER130}
	{$WARN UNIT_PLATFORM OFF}
{$ENDIF}{$ENDIF}{$ENDIF}
	Windows, Messages, Classes, Forms, Dialogs, SysUtils, ActiveX, Shlobj,
	FileCtrl, Controls, Graphics, ShellApi, StdCtrls;

type
{Decides what foldertypes to accept and whether to show path.}
	TBrowseInfoFlags = (OnlyComputers, OnlyPrinters, OnlyDomains, OnlyAncestors,
		OnlyFileSystem, ShowPath, EditBox, Includefiles, IncludeURLs, NewDialogStyle,
		UsageHint, HideNewFolderButton, ShowShared, Validate);
{Decides what foldertypes to accept and whether to show path.}
{To select a printer: Set Flags to 'OnlyPrinters' and set RootFolder property
to 'foPrinters'.}
	TBrowseInfoFlagSet = set of TBrowseInfoFlags;
{List of Foldernames used as the root-folder. Users can not browse to a folder above that level.}
{To select a printer: Set Flags to 'OnlyPrinters' and set RootFolder property
to 'foPrinters'.}
	TSHFolders = (foDesktop, foDesktopExpanded, foPrograms, foControlPanel,
		foPrinters, foPersonal, foFavorites, foStartup, foRecent, foSendto,
		foRecycleBin, foStartMenu, foDesktopFolder, foMyComputer, foNetwork,
		foNetworkNeighborhood, foFonts, foTemplates);

	TPBFolderDialog = class;
{The event that is triggered when the dialog has initialized.}
	TBrowserInitializedEvent=procedure(Sender: TPBFolderDialog; DialogHandle: HWND) of object;
{The event that is triggered whenever a folder is selected.}
{Manually add 'ShlObj' to the uses clause of your forms unit, when you create
a TSelectionChangedEvent.}
	TSelectionChangedEvent=procedure(Sender: TPBFolderDialog; DialogHandle: HWND;
		const ItemIDList: PItemIDList; const Folder: String; const Attr : Cardinal) of object;
{The event that is triggered when a user types a non-valid folder in the editbox.}
	TValidateFailedEvent=procedure(Sender: TPBFolderDialog;
		DialogHandle: HWND) of object;

{Author:	Poul Bak}
{Copyright © 1999-2002 : BakSoft-Denmark (Poul Bak). All rights reserved.}
{http://home11.inet.tele.dk/BakSoft/}
{Mailto: baksoft-denmark@dk2net.dk}
{}
{Component Version: 7.00.00.00}
{}
{PBFolderDialog is SHBrowseForFolder dialog supporting both 'NewDialogStyle' for Windows ME/2000/XP and traditional style. Supports new flags, for instance 'IncludeFiles' that lets you choose any object (files, controlpanel-applets etc.).}
{Both new and old style have a 'New folder' button to create new folders when browsing for a folder. It can show path above the window.}
{The 'New folder'-button caption and a 'Label'-caption (shown above the path) are automatically localized (national language) detected every time the application runs.}
	TPBFolderDialog = class(TComponent)
	private
		FDialogHandle, FNewFolderHandle, FParentHandle : HWnd;
		FFolder, FSelectedFolder, FLabelCaption, FDisplayName : string;
		FImageIndex, FSpecialFolder : Integer;
		FFolderAttr : Cardinal;
		FFlags : TBrowseInfoFlagSet;
		FRootFolder : TSHFolders;
		FInitialized : Boolean;
		FNewFolderCaption, FVersion, FLocale : String;
		FRestart, FValidPath, FReturnSpecialFolder, FNewStyle : Boolean;
		FTitle : String;
		PStartItemIDList : PItemIDList;
		FOnInitialized : TBrowserInitializedEvent;
		FOnSelectionChanged : TSelectionChangedEvent;
		FOnValidateFailed : TValidateFailedEvent;
		FShellFolder : IShellFolder;
//		function LocaleText(List : TStringList) : string;
		function MakeDisplayPath(Path : string; MaxL : integer) : string;
//		function StoreNewFolderCaptions : Boolean;
//		function StoreCurrentFolderCaptions : Boolean;
		procedure Dummy(Value: String);
		procedure SetNewFolderCaption(Value : String);
//		procedure SetNewFolderCaptions(Value : TStringList);
		procedure SetSelectedFolder(Value : String);
//		procedure SetLabelCaptions(Value : TStringList);
//		procedure LabelCaptionsChange (Sender: TObject);
//		procedure NewFolderCaptionsChange (Sender: TObject);
	protected
	public
		constructor Create(AOwner : TComponent); override;
		procedure Loaded; override;
		destructor Destroy; override;
{Use the Execute function to browse for a folder. If the user presses 'Ok'
the Folder-property will contain the path to the selected folder.}
{If the user presses 'Cancel' the Folder-property will not change.}
{The start-folder is determined by:}
{1: if SpecialFolder property <> -1}
{2: if Folder property <> ''}
{3: Rootfolder property}
		function Execute : Boolean;
{Use the ExecutePIDL function to browse for a folder or a printer.}
{If PIDL is non-nil - when called - the dialog will show the folder pointed to.}
{If the user presses 'Ok' the Folder-property will contain the path to the
selected folder and PIDL will contain a pointer to an ItemIDList.}
{If the user presses 'Cancel' the Folder-property will not change.}
{The start-folder is determined by:}
{1: if PIDL <> nil}
{2: if SpecialFolder property <> -1}
{3: if Folder property <> ''}
{4: Rootfolder property}
		function ExecutePIDL(var PIDL : PItemIDList) : Boolean;
{Use this procedure to set the selected folder to an ItemIDList.}
{Use it from an event.}
		procedure SetSelectionPIDL(const Hwindow : HWND; const ItemIDList : PItemIDList);
{Use this procedure to set the selected folder to a path.}
{Use it from an event.}
		procedure SetSelectionPath(const Hwindow : HWND; const Path : String);
{Use this procedure to Enable/Disable the 'Ok'-button.}
{Use it from an event.}
		procedure EnableOK(const Hwindow : HWND; const Value : Boolean);
{Use this procedure to get an ItemIDList, when you know the path.}
		procedure GetIDListFromPath(Path: String; var ItemIDList: PItemIDList);
{This property gives the Window-title (when you open a folder in Explorer).}
{The DisplayName is normally the short foldername.}
		property DisplayName : String read FDisplayName;
{Returns the attributes of the folder, see IShellfolder.GetAttributesOf
in WinAPI help.}
		property FolderAttributes : Cardinal read FFolderAttr;
{A system index to the image for the folder.}
		property ImageIndex : Integer read FImageIndex;
{The handle of the parent window (the form that called the dialog.}
		property ParentHandle : HWnd read FParentHandle write FParentHandle;
{The handle of the dialog.}
		property DialogHandle : HWnd read FDialogHandle write FDialogHandle;
{The handle of the 'New folder' button.}
		property NewFolderHandle : HWnd read FNewFolderHandle write FNewFolderHandle;
{The currently selected folder. You can access and set this path in one of the events.}
		property SelectedFolder : String read FSelectedFolder write SetSelectedFolder;
	published
{If True, PBFolderDialog scans the selected folder to see if it matches one
of the Shell's SpecialFolders. If so, it sets the SpecialFolder property to that
value. When False, it sets the SpecialFolder property to -1.}
		property ReturnSpecialFolder : Boolean read FReturnSpecialFolder
			write FReturnSpecialFolder default False;
{The SpecialFolder number (see scidl.htm or SHGetSpecialFolderLocation) that is
selected when the dialog opens. if ReturnSpecialFolder is True, it contains the
SpecialFolder number (CSIDL value) to the folder the user selected. If both
Folder property and SpecialFolder property are set the dialog uses the
SpecialFolder property to open the folder.}
{See also: Folder and ReturnSpecialFolder}
		property SpecialFolder : integer read FSpecialFolder
			write FSpecialFolder default - 1;
{The Folder that is selected when the dialog opens and, when returned,
contains the path to the folder the user selected.}
{See also SpecialFolder.}
		property Folder : String read FFolder write FFolder;
{Decides what foldertypes to accept and whether to show path.}
{To select a printer: Set Flags to 'OnlyPrinters' and set RootFolder property
to 'foPrinters'.}
		property Flags : TBrowseInfoFlagSet read FFlags write FFlags;
{The root-folder. Users can not browse to a folder above that level.}
{To select a printer: Set Flags to 'OnlyPrinters' and set RootFolder property
to 'foPrinters'.}
		property RootFolder : TSHFolders read FRootFolder write FRootFolder default foDesktopExpanded;
{The event that is triggered when the dialog has initialized.}
		property OnInitialized : TBrowserInitializedEvent read FOnInitialized
			write FOnInitialized;
{The event that is triggered whenever a folder is selected.}
{Manually add 'ShlObj' to the uses clause of your forms unit, when you create
an OnSelectionChanged event.}
		property OnSelectionChanged : TSelectionChangedEvent read FOnSelectionChanged
			write FOnSelectionChanged;
{Triggers when users type a non-valid name in the editbox.}
{Requires Flags: EditBox and Validate.}
		property OnValidateFailed : TValidateFailedEvent read FOnValidateFailed
			write FOnValidateFailed;
{LabelCaptions is the localized caption-list for the caption above the browsewindow.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property LabelCaptions : String read FLabelCaption write FLabelCaption;
{NewFolderCaptions is the localized caption-list for the caption of the 'New folder' button.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property NewFolderCaptions : String read FNewFolderCaption write FNewFolderCaption;
{The localized list of titles for the dialog. If left empty, windows sets
a default title.}
		property Title : String read FTitle write FTitle;
//ReadOnly property.
		property Version : string read FVersion write Dummy stored False;
	end;

procedure GetPathDisplayAndAttr(PIDL : PItemIDList; var Path, Display : string;
	var Attr : Cardinal);

Function BrowseForFolder(Const Title : String; HasNewButton : Boolean; Var Path : String) : Boolean;

procedure Register;

implementation

//xarka
var
 WindowList: Pointer;
//

Function BrowseForFolder(Const Title : String; HasNewButton : Boolean; Var Path : String) : Boolean;
var
 pb:TPBFolderDialog;
begin
 pb:=TPBFolderDialog.Create(nil);
//xarka
 if assigned(screen.ActiveCustomForm) then
  pb.ParentHandle:=screen.ActiveCustomForm.Handle;
//
 if HasNewButton
  then pb.Flags:=pb.Flags-[HideNewFolderButton]
  else pb.Flags:=pb.Flags+[HideNewFolderButton];
 pb.Folder:=path;
 if title<>'' then
  pb.Title:=title;
 result:=pb.execute;
 if result then path:=IncludeTrailingBackSlash(pb.Folder);
end;


const
	MinButtonWidth = 75;
	_BUTTON_ID = 255;
	MAX_PATH_DISPLAY_LENGTH = 50;
	BIF_BROWSEINCLUDEURLS = $80;
	BIF_NEWDIALOGSTYLE = $40;
	BIF_UAHINT = $100;
	BIF_NONEWFOLDERBUTTON = $200;
	BIF_SHAREABLE = $8000;
	BROWSE_FLAG_ARRAY: array[TBrowseInfoFlags] of Cardinal = (BIF_BROWSEFORCOMPUTER,
		BIF_BROWSEFORPRINTER, BIF_DONTGOBELOWDOMAIN, BIF_RETURNFSANCESTORS,
		BIF_RETURNONLYFSDIRS, BIF_STATUSTEXT, BIF_EDITBOX, BIF_BROWSEINCLUDEFILES,
		BIF_BROWSEINCLUDEURLS, BIF_NEWDIALOGSTYLE, BIF_UAHINT, BIF_NONEWFOLDERBUTTON,
		BIF_SHAREABLE, BIF_VALIDATE);
	SH_FOLDERS_ARRAY: array[TSHFolders] of Integer=
		(CSIDL_DESKTOP,-1,
		CSIDL_PROGRAMS,CSIDL_CONTROLS,CSIDL_PRINTERS,CSIDL_PERSONAL,CSIDL_FAVORITES,
		CSIDL_STARTUP,CSIDL_RECENT,CSIDL_SENDTO,CSIDL_BITBUCKET,CSIDL_STARTMENU,CSIDL_DESKTOPDIRECTORY,
		CSIDL_DRIVES,CSIDL_NETWORK,CSIDL_NETHOOD,CSIDL_FONTS,CSIDL_TEMPLATES);

procedure CenterWindow(HWindow: HWND);
var
	Rect0: TRect;
begin
	GetWindowRect(HWindow, Rect0);
	SetWindowPos(HWindow,0,
		(Screen.Width div 2) - ((Rect0.Right-Rect0.Left) div 2),
		(Screen.Height div 2) - ((Rect0.Bottom - Rect0.Top) div 2),
		0,0,SWP_NOACTIVATE or SWP_NOSIZE or SWP_NOZORDER);
end;

function WndProc(HWindow: HWND; Msg: UINT; wParam : WPARAM;
	lParam : LPARAM): LRESULT; stdcall;
var
	Instance: TPBFolderDialog;
	NewFolder, TempFolder : String;
begin
	Instance := TPBFolderDialog(GetWindowLong(HWindow,GWL_USERDATA));
	Result:=0;
	if (Msg=WM_COMMAND) and (Lo(wParam)=_BUTTON_ID) then
	begin
		NewFolder := InputBox(Instance.FNewFolderCaption, '', '');
		if NewFolder <> '' then
		begin
			Instance.FRestart := True;
			if (NewFolder[1] <> '\')
				and (Instance.FSelectedFolder[Length(Instance.FSelectedFolder)] <> '\')
				then NewFolder := '\' + NewFolder;
			TempFolder := Instance.FSelectedFolder + NewFolder;
			try
				ForceDirectories(TempFolder);
				Application.ProcessMessages;
				if DirectoryExists(TempFolder)
					then Instance.GetIDListFromPath(TempFolder, Instance.PStartItemIDList)
				else Raise Exception.Create('');
			except
				Instance.FInitialized := False;
				ShowMessage(SysErrorMessage(82));
			end;
			PostMessage(HWindow, WM_KEYDOWN, VK_ESCAPE, 0);
			PostMessage(HWindow, WM_KEYUP, VK_ESCAPE, 0);
		end;
	end
	else Result:=DefDlgProc(HWindow,Msg,wParam,lParam);
end;

procedure AddControls(HWindow : HWND; Instance : TPBFolderDialog);
var
	NewFolderWindowHandle : HWND;
	ControlCreateStyles, Height0, TextWidth : Integer;
	Rect0, Rect1 : TRect;
	TopLeft : TPoint;
begin
	ControlCreateStyles := WS_CHILD or WS_CLIPSIBLINGS or WS_VISIBLE or WS_TABSTOP
		or BS_PUSHBUTTON;
	GetClientRect(HWindow, Rect0);
	Height0 := Rect0.Bottom - Rect0.Top;
	case Screen.PixelsPerInch of
		72, 96: NewFolderWindowHandle:=CreateWindow('Button', PChar(Instance.FNewFolderCaption),
			ControlCreateStyles, 12, Height0 - 36, MinButtonWidth, 23,
			HWindow, _BUTTON_ID, HInstance, nil);
		120: NewFolderWindowHandle:=CreateWindow('Button', PChar(Instance.FNewFolderCaption),
			ControlCreateStyles, 15, Height0 - 45, MinButtonWidth * 5 div 4, 28,
			HWindow, _BUTTON_ID, HInstance, nil);
		144: NewFolderWindowHandle:=CreateWindow('Button', PChar(Instance.FNewFolderCaption),
			ControlCreateStyles, 17, Height0 - 56, MinButtonWidth * 3 div 2, 35,
			HWindow, _BUTTON_ID, HInstance, nil);
		192: NewFolderWindowHandle:=CreateWindow('Button', PChar(Instance.FNewFolderCaption),
			ControlCreateStyles, 20, Height0 - 66, MinButtonWidth * 192 div 96,
			41, HWindow, _BUTTON_ID, HInstance, nil);
		else NewFolderWindowHandle:=CreateWindow('Button', PChar(Instance.FNewFolderCaption),
			ControlCreateStyles, 12 * Screen.PixelsPerInch div 96,
			Height0 - GetSystemMetrics(SM_CYCAPTION) - 17,
			MinButtonWidth * Screen.PixelsPerInch div 96, 23 * Screen.PixelsPerInch div 96,
			HWindow, _BUTTON_ID, HInstance, nil);
	end;
	with TBitmap.Create do
	begin
		TextWidth := Canvas.TextWidth(Instance.FNewFolderCaption);
		PostMessage(NewFolderWindowHandle, WM_SETFONT, Canvas.Font.Handle,
			MAKELPARAM(1,0));
		Free;
	end;
	GetClientRect(NewFolderWindowHandle, Rect1);
	Rect1.Right := Rect1.Left + TextWidth + 12;
	if (Rect1.Right < MinButtonWidth) and (Screen.PixelsPerInch = 72)
		then Rect1.Right := MinButtonWidth
	else if Rect1.Right < MinButtonWidth * Screen.PixelsPerInch div 96
		then Rect1.Right := MinButtonWidth * Screen.PixelsPerInch div 96;
	AdjustWindowRect(Rect1, ControlCreateStyles, False);
	GetWindowRect(NewFolderWindowHandle, Rect0);
	TopLeft := Rect0.TopLeft;
	ScreenToClient(HWindow, TopLeft);
	MoveWindow(NewFolderWindowHandle, TopLeft.x, TopLeft.y, Rect1.Right,
		Rect1.Bottom, True);
	EnableWindow(NewFolderWindowHandle, True);
	SetWindowLong(HWindow, GWL_WNDPROC, Cardinal(@WndProc));
	Instance.FNewFolderHandle:=NewFolderWindowHandle;
end;

function BindToParent(PIDL : PItemIDList; var RelPIDL : PItemIDList): IShellFolder;
type
	TSHBindToParent = function(const PIDL : PItemIDList; const Riid : TGUID;
		out ppvOut; out RelPIDL : PItemIDList) : HResult; stdcall;
var
	Old_cb : Word;
	APIDL: PItemIDList;
	Desktop: IShellFolder;
	LibHandle : THandle;
	SHBindToParent : TSHBindToParent;
begin
	Result := nil;
	APIDL := PIDL;
	RelPIDL := PIDL;
	if Assigned(PIDL) then
	begin
		if (Win32MajorVersion >= 5) then
		begin
			LibHandle := GetModuleHandle('Shell32.dll');
			if LibHandle <> 0 then
			begin
				@SHBindToParent := GetProcAddress(LibHandle, 'SHBindToParent');
				if @SHBindToParent <> nil
					then SHBindToParent(PIDL, IID_IShellFolder, Result, RelPIDL);
			end;
		end;
		if (Result = nil) or (RelPIDL = nil) then
		begin
			while (APIDL.mkid.cb <> 0) do
			begin
				RelPIDL := APIDL;
				Inc(PChar(APIDL), APIDL.mkid.cb);
			end;
			Old_cb := RelPIDL.mkid.cb;
			RelPIDL.mkid.cb := 0;
			try
				SHGetDesktopFolder(Desktop);
				Desktop.BindToObject(PIDL, nil, IID_IShellFolder, Result);
				if Result = nil then SHGetDesktopFolder(Result);
			finally
				RelPIDL.mkid.cb := Old_cb;
			end;
		end;
	end;
end;

procedure GetPathDisplayAndAttr(PIDL : PItemIDList; var Path, Display : string;
	var Attr : Cardinal);
var
	TempPath: array[0..MAX_PATH] of Char;
	lpDisplay : TStrRet;
	TempIDList: PItemIDList;
	RelShellFolder : IShellFolder;
begin
	TempPath := #0;
	SHGetPathFromIDList(PIDL, TempPath);
	Path := StrPas(TempPath);
	RelShellFolder := BindToParent(PIDL, TempIDList);
	if RelShellFolder = nil then Exit;
	ZeroMemory(@lpDisplay, SizeOf(lpDisplay));
	lpDisplay.uType := STRRET_CSTR;
	RelShellFolder.GetDisplayNameOf(TempIDList,
		SHGDN_FORPARSING or SHGDN_INCLUDE_NONFILESYS, lpDisplay);
	case lpDisplay.uType of
		STRRET_CSTR : Display := StrPas(lpDisplay.cStr);
		STRRET_WSTR :
		begin
			WideCharToMultiByte(CP_ACP, 0, lpDisplay.pOleStr, -1, TempPath,
				MAX_PATH, nil, nil);
			Display := TempPath;
		end;
		STRRET_OFFSET :
		begin
			SetString(Display, PChar(TempIDList) + lpDisplay.uOffset,
				TempIDList.mkid.cb - lpDisplay.uOffset);
		end;
	end;
	Attr := $FFFFFFFF;
	RelShellFolder.GetAttributesOf(1, TempIDList, Attr);
end;

function BrowserCallbackProc(HWindow: HWND; uMsg: Cardinal; lParameter: LPARAM;
	lpPBFolderDialog: LPARAM) : integer; stdcall;
var
	Instance: TPBFolderDialog;
	TempIDList: PItemIDList;
	Title : string;
	Attr : Cardinal;
begin
	Result := 0;
	Instance := TPBFolderDialog(lpPBFolderDialog);
	case uMsg of
		BFFM_INITIALIZED:
		begin
			Instance.DialogHandle:=HWindow;
			CenterWindow(HWindow);
			SetWindowLong(HWindow,GWL_USERDATA,lpPBFolderDialog);
			Title := Instance.FTitle;
			if Title <> ''
				then SendMessage(HWindow, WM_SETTEXT, 0, Cardinal(PChar(Title)));
			if not (HideNewFolderButton in Instance.FFlags)
				then AddControls(HWindow,Instance);
			if IsWindow(Instance.FNewFolderHandle) then
			begin
				EnableWindow(Instance.FNewFolderHandle, Instance.FValidPath);
				ShowWindow(Instance.FNewFolderHandle, SW_SHOW);
			end;
			if Instance.PStartItemIDList <> nil
				then Instance.SetSelectionPIDL(HWindow, Instance.PStartItemIDList)
			else if (Instance.FSpecialFolder <> -1)
				and (SHGetSpecialFolderLocation(HWindow, Instance.FSpecialFolder,
				TempIDList) = NOERROR) then Instance.SetSelectionPIDL(HWindow,
				TempIDList)
			else Instance.SetSelectionPath(HWindow,Instance.FFolder);
			Instance.FInitialized := True;
			if Assigned(Instance.OnInitialized)
				then Instance.OnInitialized(Instance,HWindow);
		end;
		BFFM_SELCHANGED:
		begin
			if PItemIDList(lParameter) = nil then Exit;
			if Instance.FInitialized
				then Instance.PStartItemIDList := PItemIDList(lParameter);
			GetPathDisplayAndAttr(PItemIDList(lParameter), Instance.FSelectedFolder,
				Instance.FDisplayName, Attr);
			if (ShowPath in Instance.FFlags)
				then SendMessage(HWindow, BFFM_SETSTATUSTEXT, 0,
				Cardinal(PChar(Instance.MakeDisplayPath(Instance.FDisplayName,
				MAX_PATH_DISPLAY_LENGTH))));
			Instance.FValidPath := (Instance.FSelectedFolder <> '');
			if (OnlyFileSystem in Instance.FFlags) then Instance.EnableOK(HWindow,
				Instance.FValidPath)
			else Instance.EnableOK(HWindow, True);
			if (OnlyAncestors in Instance.FFlags)
				and ((Attr and SFGAO_FILESYSANCESTOR) = 0)
				then Instance.EnableOK(HWindow, False);
			if IsWindow(Instance.FNewFolderHandle)
				then EnableWindow(Instance.FNewFolderHandle, Instance.FValidPath);
			if Assigned(Instance.OnSelectionChanged)
				then Instance.OnSelectionChanged(Instance,HWindow,PItemIDList(lParameter),
				Instance.SelectedFolder, Attr);
		end;
		BFFM_VALIDATEFAILED :
		begin
			if Assigned(Instance.FOnValidateFailed)
				then Instance.FOnValidateFailed(Instance, HWindow)
			else MessageBeep(0);
		end;
	end;
end;

function SetTextFonts(Hwndnext : HWnd; lpPBFolderDialog : LPARAM) : Boolean; stdcall;
var
	ClassName : array[0..500] of Char;
begin
	Result := True;
	if HwndNext <> 0 then
	begin
		GetClassName(HwndNext, ClassName, 500);
		if ClassName = 'Static' then
		begin
			with TBitmap.Create do
			begin
				PostMessage(HwndNext, WM_SETFONT, Canvas.Font.Handle,
					MAKELPARAM(1,0));
				Free;
			end;
		end;
	end
	else Result := False;
end;

function NewStyleCallbackProc(HWindow : HWND; uMsg : Cardinal; lParameter: LPARAM;
	lpPBFolderDialog : LPARAM) : integer; stdcall;
var
	Instance: TPBFolderDialog;
	TempIDList: PItemIDList;
	Title : string;
	Attr : Cardinal;
begin
	Result := 0;
	Instance := TPBFolderDialog(lpPBFolderDialog);
	case uMsg of
		BFFM_INITIALIZED:
		begin
			Instance.DialogHandle := HWindow;
			CenterWindow(HWindow);
//			EnumChildWindows(HWindow, @SetTextFonts, lpPBFolderDialog);
			Title := Instance.FTitle;
			if Title <> ''
				then SendMessage(HWindow, WM_SETTEXT, 0, Cardinal(PChar(Title)));
			if Instance.PStartItemIDList <> nil
				then Instance.SetSelectionPIDL(HWindow, Instance.PStartItemIDList)
			else if (Instance.FSpecialFolder <> -1)
				and (SHGetSpecialFolderLocation(HWindow, Instance.FSpecialFolder,
				TempIDList) = NOERROR) then Instance.SetSelectionPIDL(HWindow,
				TempIDList)
			else Instance.SetSelectionPath(HWindow,Instance.FFolder);
			Instance.FInitialized := True;
			if Assigned(Instance.OnInitialized)
				then Instance.OnInitialized(Instance,HWindow);
		end;
		BFFM_SELCHANGED:
		begin
			if PItemIDList(lParameter) = nil then Exit;
			if Instance.FInitialized
				then Instance.PStartItemIDList := PItemIDList(lParameter);
			GetPathDisplayAndAttr(PItemIDList(lParameter), Instance.FSelectedFolder,
				Instance.FDisplayName, Attr);
			if (ShowPath in Instance.FFlags)
				then SendMessage(HWindow, BFFM_SETSTATUSTEXT, 0,
				Cardinal(PChar(Instance.MakeDisplayPath(Instance.FDisplayName,
				MAX_PATH_DISPLAY_LENGTH))));
			Instance.FValidPath := (Instance.FSelectedFolder <> '');
			if (OnlyFileSystem in Instance.FFlags) then Instance.EnableOK(HWindow,
				Instance.FValidPath)
			else Instance.EnableOK(HWindow, True);
			if (OnlyAncestors in Instance.FFlags)
				and ((Attr and SFGAO_FILESYSANCESTOR) = 0)
				then Instance.EnableOK(HWindow, False);
			if Assigned(Instance.OnSelectionChanged)
				then Instance.OnSelectionChanged(Instance, HWindow,
				PItemIDList(lParameter), Instance.SelectedFolder, Attr);
		end;
		BFFM_VALIDATEFAILED :
		begin
			if Assigned(Instance.FOnValidateFailed)
				then Instance.FOnValidateFailed(Instance, HWindow)
			else MessageBeep(0);
		end;
	end;
end;

// -----------------------  TPBFolderDialog  ---------------------
constructor TPBFolderDialog.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	FParentHandle := 0;
	FRootFolder := foDesktopExpanded;
	FFlags:=[ShowPath, ShowShared, OnlyFileSystem];
	FFolder := '';
	FSelectedFolder := '';
	FDisplayName := '';
	PStartItemIDList := nil;
	FInitialized := False;
	FValidPath := True;
	FVersion := '7.00.00.00';
	FLocale := IntToHex(GetSystemDefaultLangID, 4);
	FSpecialFolder := -1;
        FNewFolderCaption:='New folder';
        FLabelCaption:='Current folder:';
        FTitle:='Select folder';
end;

procedure TPBFolderDialog.Loaded;
begin
 SetNewFolderCaption(FNewFolderCaption);
end;

destructor TPBFolderDialog.Destroy;
begin
	inherited Destroy;
end;

procedure TPBFolderDialog.GetIDListFromPath(Path: String; var ItemIDList: PItemIDList);
var
	CharsParsed: ULONG;
	Attributes: ULONG;
begin
	if Path <> '' then FShellFolder.ParseDisplayName(0, nil, StringToOleStr(Path),
		CharsParsed, ItemIDList, Attributes);
end;

procedure TPBFolderDialog.SetSelectionPIDL(const Hwindow: HWND; const ItemIDList: PItemIDList);
begin
	SendMessage(Hwindow, BFFM_SETSELECTION, Ord(FALSE), Cardinal(ItemIDList));
end;

procedure TPBFolderDialog.SetSelectionPath(const Hwindow : HWND; const Path: String);
var
	ItemIDList : PItemIDList;
begin
	ItemIDList := nil;
	GetIDListFromPath(Path, ItemIDList);
 try //SMALLEYD@imtins.com.elf
	SendMessage(Hwindow, BFFM_SETSELECTION, Ord(FALSE), Longint(ItemIDList));
 except end; 
end;

procedure TPBFolderDialog.EnableOK(const Hwindow : HWND; const Value: Boolean);
begin
	SendMessage(Hwindow, BFFM_ENABLEOK, 0, Ord(Value));
end;

procedure TPBFolderDialog.SetNewFolderCaption(Value: String);
begin
	FNewFolderCaption:=Value;
	if (IsWindow(FNewFolderHandle))
		then SetWindowText(FNewFolderHandle, PChar(Value));
end;

procedure TPBFolderDialog.SetSelectedFolder(Value: String);
begin
	SetSelectionPath(DialogHandle, Value);
end;

{
procedure TPBFolderDialog.SetLabelCaptions(Value : TStringList);
begin
	if FLabelCaptions.Text <> Value.Text then
	begin
		FLabelCaptions.Assign(Value);
	end;
end;


procedure TPBFolderDialog.SetNewFolderCaptions(Value : TStringList);
begin
	if FNewFolderCaptions.Text <> Value.Text then
	begin
		FNewFolderCaptions.Assign(Value);
	end;
end;
}
{
procedure TPBFolderDialog.LabelCaptionsChange (Sender: TObject);
begin
	FLabelCaption := LocaleText(FLabelCaptions);
end;

function TPBFolderDialog.StoreCurrentFolderCaptions : Boolean;
begin
	Result := (FLabelCaptions.CommaText <> CURRENT_FOLDER_CAPTIONS);
end;
)
{
procedure TPBFolderDialog.NewFolderCaptionsChange (Sender: TObject);
begin
	SetNewFolderCaption(LocaleText(FNewFolderCaptions));
end;

function TPBFolderDialog.StoreNewFolderCaptions : Boolean;
begin
	Result := (FNewFolderCaptions.CommaText <> NEW_FOLDER_CAPTIONS);
end;
}
procedure TPBFolderDialog.Dummy(Value: String); begin {Read only !} end;

{
function TPBFolderDialog.LocaleText(List : TStringList) : string;
begin
	if List.Count = 0 then Result := ''
	else
	begin
		if List.IndexOfName(FLocale) <> -1 then Result := List.Values[FLocale]
		else if List.IndexOfName('Default') <> -1 then Result := List.Values['Default']
		else Result := List.Values[List.Names[0]];
	end;
end;
}

function TPBFolderDialog.MakeDisplayPath(Path : string; MaxL : integer) : string;
var
	t, Pos0, NumBack : integer;
begin
	Result := '';
        if (length(path)>10) and (path[1]=':') then exit;
	if (Length(Path) <= MaxL) or (MaxL < 6) or (Pos('\', Path) = 0) then Result := Copy(Path, 1, MaxL)
	else
	begin
		NumBack := 0;
		for t := 3 to Length(Path) do if (Path[t] = '\') then inc(NumBack);
		if NumBack < 2 then Result := Copy(Path, 1, MaxL)
		else
		begin
			Pos0 := Pos('\', Path);
			if Pos0 < 3 then
			begin
				Result := '\\';
				Path := Copy(Path, 3, Length(Path) - 2);
			end;
			Pos0 := Pos('\', Path);
			Result := Result + Copy(Path, 1, Pos0) + '...';
			repeat
				Path := Copy(Path, Pos0 + 1, Length(Path) - Pos0);
				Pos0 := Pos('\', Path);
			until ((Length(Result + Path) + 1) <= MaxL) or (Pos0 = 0);
			if ((Length(Result + Path) + 1) <= MaxL) then Result := Result + '\' + Path
			else Result := Copy(Result + '\' + Path, 1, MaxL - 3) + '...';
		end;
	end;
end;

function TPBFolderDialog.Execute: Boolean;
var
	ItemIDList : PItemIDList;
begin
	ItemIDList := nil;
	Result := ExecutePIDL(ItemIDList);
	if ItemIDList <> nil then CoTaskMemFree(ItemIDList);
end;

function TPBFolderDialog.ExecutePIDL(var PIDL : PItemIDList) : Boolean;
var
	BrowseInfo : TBrowseInfo;
	i: Integer;
	t : TBrowseInfoFlags;
	TempIDList : PItemIDList;
	Found : Boolean;
	ApiResult : HRESULT;
begin
	CoInitialize(nil);
	Result := False;
	ApiResult :=  SHGetDesktopFolder(FShellFolder);
	if ApiResult <> NOERROR then
	begin
		FShellFolder := nil;
		ShowMessage(SysErrorMessage(ApiResult));
		Exit;
	end;
	FNewStyle := (Win32MajorVersion >= 5) and (NewDialogStyle in FFLags);
  WindowList := DisableTaskWindows(0);
	try
		ZeroMemory(@BrowseInfo, SizeOf(TBrowseInfo));
		if IsWindow(FParentHandle) then BrowseInfo.hwndOwner:=FParentHandle
		else if (Owner is TWinControl) then BrowseInfo.hwndOwner:=TWinControl(Owner).Handle
		else if Assigned(Application.MainForm) then BrowseInfo.hwndOwner:=Application.MainForm.Handle
		else BrowseInfo.hwndOwner:=Application.Handle;
		if FRootFolder=foDesktopExpanded then BrowseInfo.pidlRoot:=nil
		else SHGetSpecialFolderLocation(Application.Handle,
			SH_FOLDERS_ARRAY[FRootFolder], BrowseInfo.pidlRoot);
		BrowseInfo.pszDisplayName := StrAlloc(MAX_PATH + 1);
		ZeroMemory(BrowseInfo.pszDisplayName, MAX_PATH + 1);
		BrowseInfo.lpszTitle := PChar(FLabelCaption);
		BrowseInfo.ulFlags := 0;
		for t := Low(TBrowseInfoFlags) to High(TBrowseInfoFlags)
			do if t in FFlags then BrowseInfo.ulFlags:=BrowseInfo.ulFlags
			or Cardinal(BROWSE_FLAG_ARRAY[t]);
		if FNewStyle then BrowseInfo.lpfn := @NewStyleCallbackProc
		else BrowseInfo.lpfn := @BrowserCallbackProc;
		BrowseInfo.lParam := Integer(Self);
		BrowseInfo.iImage := 0;
		FSelectedFolder := FFolder;
		PStartItemIDList := PIDL;
		repeat
			FInitialized := False;
			FRestart := False;
			FFolder := FSelectedFolder;
			{SHBrowseForFolder; return is nil if user cancels}
			PIDL := SHBrowseForFolder(BrowseInfo);
		until not FRestart;
		Result := (PIDL <> nil);
		if Result then
		begin
			GetPathDisplayAndAttr(PIDL, FFolder, FDisplayName, FFolderAttr);
			FImageIndex := BrowseInfo.iImage;
			Found := False;
			i := 0;
			while FReturnSpecialFolder and (i <= 255) and not Found do
			try
				TempIDList := nil;
				if (SHGetSpecialFolderLocation(FDialogHandle, i, TempIDList) = NOERROR)
					and (FShellFolder.CompareIDs(0, PIDL, TempIDList) = 0) then
				begin
					Found := True;
					FSpecialFolder := i;
				end;
			finally
				if TempIDList <> nil then CoTaskMemFree(TempIDList);
				Inc(i);
			end;
			if not Found then FSpecialFolder := -1;
		end;
	finally
		if BrowseInfo.pidlRoot <> nil then CoTaskMemFree(BrowseInfo.pidlRoot);
		StrDispose(BrowseInfo.pszDisplayName);
		CoUninitialize;
    //xarka
    EnableTaskWindows(WindowList);
    //
	end;
end;

procedure Register;
begin
	RegisterComponents('PB', [TPBFolderDialog]);
end;

end.
