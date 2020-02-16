{$B-,H+,X+,J-} //Essential directives
{$IFDEF VER140}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

unit HyperFrm;

interface

uses
  Windows, Messages, SysUtils, Controls, Forms, Dialogs, Classes, Graphics,
  Registry, Printers, WinSpool, ShellAPI, ShlObj, HyperStr, MAPI;

function  KillProc(const ClassName:AnsiString):Boolean;
function  ToggleSysKeys:Boolean;
function  GetKeyToggle(const Key:Integer):Boolean;
function  SetTopMost(const Hnd:Thandle; Flag:Boolean):Boolean;
procedure EnterTab(const hForm:THandle;var Key:Char);
procedure AddScrollBar(const hListBox:THandle;const Width:DWord);
procedure AddTabStops(const hListBox:THandle;const Stops:array of DWord);
function  SetTaskBar(const Visible:Boolean):Boolean;
procedure NoTaskBtn;
procedure NoCloseProgram;

function  GetWindows:Ansistring;
function  GetClasses:Ansistring;

procedure DebugConsole;
procedure DebugMsg(const Msg:AnsiString);

procedure TrayInsert;
procedure TrayClose(var Action:TCloseAction);
procedure TrayDelete;
procedure TrayPopUp;

function  ShellFileOp(const S,D:AnsiString; const FileOp,Flgs:Integer):Boolean;
function  MapNetDrive:Integer;
function  ShellToDoc(const FilePath:AnsiString):THandle;
procedure MakeDoc(const FileName:AnsiString);

procedure FlashMsg(const Title,Msg:AnsiString; TOut:Integer);
function  FormatDisk(Drive:Word):Boolean;
procedure FlashSplash(Bitmap:TGraphic; const Title:AnsiString);
procedure KillSplash;
function  GetFolder(const Msg,Path:AnsiString;FSOnly:Boolean):AnsiString;
function  GetWinFolder(const SpecialFolder : Integer) : AnsiString;
function  GetWinName(FileName: AnsiString): AnsiString;

procedure PrintStr(Source:AnsiString;Font:TFont);
procedure SaveStr(Source,FileName:AnsiString);
function  LoadStr(FileName:AnsiString):AnsiString;
function  LoadRec(FileName:AnsiString;var Rec; RecLen:Integer):Boolean;
function  SaveRec(FileName:AnsiString;var Rec; RecLen:Integer):Boolean;

function  GetPaperNames:AnsiString;
procedure GetComList(Strings:TStrings);
function  ShowFileProperties(FilePath:AnsiString):Boolean;
function  ShowPrinterProperties(PrnName:AnsiString):Boolean;

function  SendMAPI(Subj,Body,SendTo,CC,BCC,Att:AnsiString;MAPIFlags:Cardinal):Integer;

implementation

type
  TRegisterServiceProcess = function(dwProcessID, dwType: DWord): DWord; stdcall;

const
{$ifdef VER90}      //Delphi 2 doesn't have this constant
  PROCESS_TERMINATE = $0001;
{$endif}
  Tray_Msg = wm_User+$0EFD;        //tray notification message
var
  Splash: TForm;
  ICD   : TNotifyIconData;
  SF    : TShFileOpStruct;
  DebugFlg: Boolean=False;
  TrayFlg : Boolean=False;
  MsgFlg  : Boolean=False;
  BfrFlg  : Boolean=False;
  CloseFlg: Boolean=False;
  pPtr1:Pointer;
  SysKeyFlg:Integer=-1;
  Temp,Tmp:AnsiString;
  dwI:dWord;

function SetTopMost(const Hnd:THandle; Flag:Boolean):Boolean;
  {Set and reset a given Window to stay on top of ALL Windows.
   Setting 'formstyle:=fsStayOnTop' only works for windows within the application
   and causes flicker.}
var
  hFlag:Thandle;
begin
  Result:=False;
  if IsWindow(Hnd) then begin
    if Flag then hFlag:=HWND_TOPMOST else hFlag:=HWND_NOTOPMOST;  
    SetWindowPos(Hnd, hFlag, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE );
    Result:=True;
  end;
end;


procedure FlashSplash(Bitmap:TGraphic; const Title:AnsiString);
  {Dynamically create a splash form in a flash.}
var
  I,L1,R1:Integer;
  R:TRect;
  MS: TMemoryStatus;
  VerInfoSize,VerValueSize,dwI: DWord;
  VerInfo,VerValue: Pointer;
  Tmp,Temp,key1,key2,xl:AnsiString;
begin
  Splash:=TForm.Create(Application);
  with Splash do begin
    Name := 'EFD_Splash';
    Caption := Title;
    Position := poScreenCenter;
    BorderStyle := bsDialog;
    FormStyle := fsStayOnTop;
    BorderIcons := [];
    Height := 279;
    Width := 349;
    Cursor:=crHourGlass;
    Show;
    Application.ProcessMessages;
    with Canvas do begin
      Draw(16,16,BitMap);
      R.Top := 168;
      R.Left := 80;
      R.Right := R.Left+249;
      R.Bottom := R.Top+2;
      FrameRect(R);
      MoveTo(R.Left,R.Top);
      LineTo(R.Right,R.Top);
      Brush.Style := bsClear;
      L1 := Abs((3*Font.Height) Div 2);
      SetDelimiter(#32);
      if IsWinNT then begin
        Key1:='SOFTWARE\Microsoft\Windows NT\CurrentVersion';
        Key2:='Windows NT '+GetKeyValues(HKEY_LOCAL_MACHINE, Key1,'CurrentVersion');
      end else begin
        Key1:='SOFTWARE\Microsoft\Windows\CurrentVersion';
        Key2:=GetKeyValues(HKEY_LOCAL_MACHINE, Key1,'Version,VersionNumber');
      end;
      SetDelimiter(#10);
      Tmp:=GetKeyValues(HKEY_LOCAL_MACHINE,Key1,'RegisteredOwner,RegisteredOrganization,ProductID');
      R1:=1;
      R.Top:=176-(4*L1);
      for I:=0 to 2 do begin
        Temp:=GetToken(Tmp,R1);
        if Length(Temp)>0 then begin
          TextOut(R.Left,R.Top,Temp);
          R.Top:=R.Top+L1;
        end;
        NextToken(Tmp,R1);
      end;
      SetDelimiter(' ');
      R.Top := 176;
      TextOut(R.Left,R.Top,Key2);
      R.Top:=R.Top+L1;
      TextOut(R.Left,R.Top,'Memory Available to Windows:');

      MS.dwLength:=SizeOf(MS);
      GlobalMemoryStatus(MS);
      Tmp:=IntToFmtStr(MS.dwTotalPhys div 1024)+' KB';
      TextOut(R.Right-TextWidth(Tmp),R.Top,Tmp);

      VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), dwI);
      if VerInfoSize<>0 then begin
        GetMem(VerInfo, VerInfoSize);
        try
          if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then begin
            SetLength(Tmp,0);
            R.Top:=28+L1;
            xl:='040904E4';  //US English
            if VerQueryValue(VerInfo,'\VarFileInfo\Translation',VerValue,VerValueSize) then begin
              if VerValueSize>=4 then begin
                Move(VerValue^,I,4);
                xl:=IntToHex(LoWord(I),4)+IntToHex(HiWord(I),4);
              end;
            end;
            xl:='\StringFileInfo\'+xl;
            if VerQueryValue(VerInfo, PChar(xl+'\FileDescription'), VerValue, VerValueSize) then begin
              if VerValueSize>1 then begin
                Font.Style:=[fsItalic];
                TextOut(R.Left,R.Top,PChar(VerValue));
                Font.Style:=[];
                R.Top:=R.Top+L1;
              end;
            end;
            VerQueryValue(VerInfo, PChar(xl+'\ProductVersion'), VerValue, VerValueSize);
            if VerValueSize>1 then Tmp:=PChar(VerValue)+' ';
            VerQueryValue(VerInfo, PChar(xl+'\LegalCopyright'), VerValue, VerValueSize);
            if VerValueSize>1 then Tmp:=Tmp+PChar(VerValue);
            if Length(Tmp)>0 then TextOut(R.Left,R.Top,Tmp);
            if VerQueryValue(VerInfo, PChar(xl+'\CompanyName'), VerValue, VerValueSize) then begin
              if VerValueSize>1 then begin
                R.Top:=R.Top+L1;
                TextOut(R.Left,R.Top,PChar(VerValue));
              end;
            end;
            if VerQueryValue(VerInfo, PChar(xl+'\LegalTrademarks'), VerValue, VerValueSize) then begin
              if VerValueSize>1 then begin
                R.Top:=R.Top+L1;
                TextOut(R.Left,R.Top,PChar(VerValue));
              end;
            end;
            if VerQueryValue(VerInfo, PChar(xl+'\ProductName'), VerValue, VerValueSize) then begin
              if VerValueSize>1 then begin
                R.Top:=16;
                Font.Size:=18;
                Font.Color:=clBlue;
                Font.Style:=[];
                TextOut(R.Left,R.Top,PChar(VerValue));
              end;
            end;
          end;
        finally
          FreeMem(VerInfo, VerInfoSize);
        end;
      end;
    end;
  end;
end;



procedure FlashMsg(const Title,Msg:AnsiString; TOut:Integer);
  {Dynamically create a timed message display form.}
var
  I,J:Integer;
begin
  with TForm.Create(Application) do begin
    Name := 'EFD_Msg'+IntToStr(GetTickCount AND $FFFF);
    Caption := Title;
    Position := poScreenCenter;
    BorderStyle := bsDialog;
    FormStyle := fsStayOnTop;
    BorderIcons := [];
    Height := 64;
    I := Canvas.TextWidth(Msg);
    J := Canvas.TextHeight(Msg);
    Height := 5*J;
    Width := iMax(128,I + (I Shr 1));
    I := Left+((Width - I ) Shr 1);
    J := Top+J;
    Show;
    Canvas.Brush.Style := bsClear;
    Canvas.TextOut(I,J,Msg);
    I:=GetTickCount+DWord(TOut);
    repeat
      Application.ProcessMessages;
    until GetTickCount>DWord(I);
    Free;
  end;
end;


procedure KillSplash;
begin
  if IsWindow(Splash.Handle) then Splash.Free;
end;


procedure EnterTab(const hForm:THandle;var Key:Char);
  {Make Enter act like Tab by calling from FormKeyPress event handler.
   Form.KeyPreview must be set to True.}
begin
  if Key = #13 then begin
    Key := #0;
    PostMessage(hForm, WM_NEXTDLGCTL, 0, 0);
  end;
end;


function  SetTaskBar(const Visible:Boolean):Boolean;

  {Enables/Disables the Windows task bar based upon the Visible parameter.
   Not a very 'Windows friendly' function but necessary if you want your
   app to have the entire screen available.}

var
  TrayHandle: THandle;
begin
  Result:=False;
  TrayHandle := FindWindow('Shell_TrayWnd', nil);
  if TrayHandle<>0 then begin
    if Visible then
      ShowWindow(TrayHandle, SW_RESTORE)
    else
      ShowWindow(TrayHandle, SW_HIDE);
    Result:=True;
  end;
end;


procedure  NoTaskBtn;
  {Disables the display of a taskbar button for the application.}
var
  WinStyle:Integer;
begin
  WinStyle := GetWindowLong(Application.Handle, GWL_EXSTYLE);
  WinStyle := WinStyle OR WS_EX_TOOLWINDOW AND (NOT WS_EX_APPWINDOW);
  SetWindowLong(Application.Handle, GWL_EXSTYLE, WinStyle);
end;


procedure  NoCloseProgram;
  {Hides app from system Close Program (Ctrl-Alt-Del) dialog in Win95.}
var
  hkernel:THandle;
  RegisterServiceProcess:TRegisterServiceProcess;
  dwI:DWord;
begin
  if IsWinNT=False then begin
    hKernel:=LoadLibrary('KERNEL32.DLL');
    if hKernel<>0 then begin
      CloseFlg:=Not CloseFlg;
      if CloseFlg then dwI:=1 else dwI:=0;
      @RegisterServiceProcess:=GetProcAddress(hKernel,'RegisterServiceProcess');
      RegisterServiceProcess(GetCurrentProcessID, dwI);
      FreeLibrary(hKernel);
    end;
  end;
end;

procedure DebugConsole;
begin
  if FindWindow('TAppBuilder',nil)<>0 then begin
    if DebugFlg then begin
      FreeConsole;
      DebugFlg:=False;
    end else if GetStdhandle(STD_OUTPUT_HANDLE)=INVALID_HANDLE_VALUE then DebugFlg:=AllocConsole;
  end;
end;


procedure DebugMsg(const Msg:AnsiString);
begin
  if DebugFlg then WriteLn(Msg);
end;


function EFD_WndProc(Handle: hWnd; Msg, wParam, lParam:Integer):Integer; stdcall;
  {Internal message handler for tray applications.}
begin
  if MsgFlg AND (Msg=Tray_Msg) then begin  //are we filtering ?
    if (lParam=wm_LButtonDown) or (lParam=wm_RButtonDown) then begin //left or right button click ?
      MsgFlg:=False;                 //clear flag so we don't come here
      Application.MainForm.Show;     //show main form
      Application.BringToFront;      //give it focus
      ShowWindow(Application.MainForm.Handle, SW_SHOWNORMAL);
      Msg:=WM_NULL;                  //kill the message
    end;                             //again until they close
  end;
  Result:=CallWindowProc(pPtr1, Handle, Msg, wParam, lParam);
end;


procedure TrayInsert;
  {Adds application icon to tray.}
begin
  if TrayFlg then     //we're already in the tray
    MsgFlg:=True      //make sure message handler is enabled
  else begin
    ICD.cbSize := Sizeof(ICD);
    ICD.Wnd := Application.Handle;
    ICD.uID := $0EFD;
    ICD.uFlags := NIF_MESSAGE OR NIF_ICON OR NIF_TIP;
    ICD.uCallbackMessage := Tray_Msg;
    ICD.hIcon := Application.Icon.Handle;
    StrPCopy(ICD.szTip, Application.Title);
    Shell_NotifyIcon(NIM_ADD, @ICD);
    pPtr1 := Pointer(SetWindowLong(ICD.Wnd, gwl_WndProc,Integer(@EFD_WndProc)));
    TrayFlg := True;  //show we're in tray
    MsgFlg := True;   //turn internal message handler on
  end;
end;


procedure TrayClose(var Action:TCloseAction);
  {Hides main form once icon has been added to tray.}
begin
  if not(TrayFlg) then Exit;
  Application.MainForm.Hide;
  ShowWindow(Application.Handle, SW_HIDE); //make sure TApplication window stays hid
  MsgFlg:=True;                  //activate message handler
  Action:=caNone;                //kill the normal close
end;


procedure TrayDelete;
  {Remove the icon from the tray.}
begin
  if not(TrayFlg) then Exit;                          //icon, what icon?
  MsgFlg:=False;                                      //reset our message flag
  SetWindowLong(ICD.Wnd, gwl_WndProc,Integer(pPtr1)); //remove internal message loop
  Shell_NotifyIcon(NIM_DELETE, @ICD);                 //kill the icon
  TrayFlg:=False;
end;


procedure TrayPopUp;
  {Manually restore a tray app.}
begin
  if not(TrayFlg and MsgFlg) then Exit;
  MsgFlg:=False;                 //disable message handler
  Application.MainForm.Show;     //show main form
  Application.BringToFront;      //give it focus
  ShowWindow(Application.MainForm.Handle, SW_SHOWNORMAL);
end;

function ShellFileOp(const S,D:AnsiString; const FileOp,Flgs:Integer):Boolean;
  {Convenient interface to Win95 shell for file operations.}
const
  Delimiter=',';
var
  Tmp,Temp:AnsiString;
begin
  Result:=False;
  if FileOp in [FO_DELETE,FO_COPY,FO_MOVE,FO_RENAME] then begin
    SF.Wnd:=0;
    SF.wFunc:=FileOp;
    SF.fAnyOperationsAborted:=False;
    Tmp:=S;
    Temp:=D;
    if Length(Tmp)=0 then Exit;
    if Tmp[Length(Tmp)]<>Delimiter then Tmp:=Tmp+Delimiter;
    ReplaceC(Tmp,Delimiter,#0);  //replace delimiters with nulls (double null at end)
    if Length(Temp)>0 then begin
      if Temp[Length(Temp)]<>Delimiter then Temp:=Temp+Delimiter;
      ReplaceC(Temp,Delimiter,#0);
    end;
    SF.pFrom:=PChar(Tmp);
    SF.pTo:=PChar(Temp);
    SF.fFlags:=Flgs AND (NOT FOF_WANTMAPPINGHANDLE);
    Result:=NOT((ShFileOperation(SF)<>0) OR SF.fAnyOperationsAborted);
    SetLength(Temp,0);
    SetLength(Tmp,0);
  end;
end;

function SHFormatDrive(H:hWnd;D,F,O:Word):Integer;stdcall;external 'shell32.dll';
function FormatDisk(Drive:Word):Boolean;

  {Convenient MODAL interface to shell disk format operations. Drive is ASCII
   drive letter; A = 65, B=66, etc..

   Returns True if valid drive and no user abort.}

begin
  Drive:=(Drive AND 31)-1;
  Result:= (ShFormatDrive(Application.MainForm.Handle,Drive,$FFFF,0)>=0);
end;

function MapNetDrive:Integer;
begin
  Result:=WNetConnectionDialog(Application.Handle,RESOURCETYPE_DISK);
end;


function ShellToDoc(const FilePath:AnsiString):THandle;
  {Open a document with associated application using Windows shell}
begin
  Result:=ShellExecute(Application.Handle,nil,PChar(FilePath),nil,nil,SW_SHOWNORMAL);
end;


procedure FreePIDL(PIDL:PItemIDList); stdcall;external 'shell32.dll' index 155;
function  SHSimpleIDListFromPath(Path: Pointer): PItemIDList; stdcall;external 'shell32.dll' index 162;

function  GetPIDLFromPath(Path: AnsiString): PItemIDList;
var
  PWPath:WideString;
begin
  if IsWinNT then begin
    SetLength(PWPath,Length(Path) SHL 1);
    StringToWideChar(Path,PWideChar(PWPath),Length(Path)+1);
    Result:=ShSimpleIDListFromPath(PWideChar(PWPath));
  end else Result:=SHSimpleIDListFromPath(PChar(Path));
end;


function GetFolder(const Msg,Path:AnsiString;FSOnly:Boolean):AnsiString;
  {Browse for folder using Windows shell. Returns path of selected folder,
   null string on abort.}
var
  pbi : TBrowseInfo;
  PIDL: PItemIDList;
begin
  SetLength(Result,MAX_PATH+1);
//  pbi.hwndOwner := Application.MainForm.Handle;
  pbi.hwndOwner := Screen.ActiveForm.Handle;
  pbi.pidlRoot := nil;
  if Length(Path)>0 then pbi.pidlRoot:=GetPIDLFromPath(ExtractFileDir(Path));
  pbi.pszDisplayName := PChar(Result);
  pbi.lpszTitle := PChar(Msg);
  pbi.ulFlags :=BIF_STATUSTEXT OR BIF_DONTGOBELOWDOMAIN;
  if FSOnly then pbi.ulFlags := pbi.ulFlags OR BIF_RETURNONLYFSDIRS;
  pbi.lpfn := nil;
  pbi.lParam := 0;
  pbi.iImage := 0;
  PIDL:=SHBrowseForFolder(pbi);
  if (PIDL<>nil) and SHGetPathFromIDList(PIDL,PChar(Result)) then
    SetLength(Result,StrLen(PChar(Result)))
  else Setlength(Result,0);
  FreePIDL(PIDL);
  FreePIDL(pbi.pidlRoot);
end;


function GetWinFolder(const SpecialFolder : Integer) : AnsiString;
  {Retrieves location of Special Windows folders.  See SHGetSpecialFolderLocation
   for a list of valid SpecialFolder constants.  "SHLOBJ" must be added to "Uses".}
var
  Pidl: PItemIDList;
begin
  SetLength(Result,MAX_PATH+1);
  if SHGetSpecialFolderLocation(0, SpecialFolder, Pidl)=NOERROR then begin
    if SHGetPathFromIDList(Pidl, PChar(Result)) then
       Setlength(Result,StrLen(PChar(Result)))
    else SetLength(Result,0);
  end;
end;


function GetWinName(FileName: AnsiString): AnsiString;
  {Retrieve long filename equivalent}
var
  PIDL: PItemIDList;
  Shell: IShellFolder;
  WideName: WideString;
  AnsiName: AnsiString;
  Dummy: DWord;
begin
  Result := FileName;
  if Succeeded(SHGetDesktopFolder(Shell)) then begin
    SetLength(WideName,Length(FileName) SHL 1);
    StringToWideChar(FileName,PWideChar(WideName),Length(FileName)+1);
    if Succeeded(Shell.ParseDisplayName(0, nil, PWideChar(WideName), Dummy, PIDL, Dummy)) then
    if PIDL<>nil then begin
      SetLength(AnsiName,MAX_PATH+1);
      if SHGetPathFromIDList(PIDL, PChar(AnsiName)) then begin
        Result := AnsiName;
        SetLength(Result,StrLen(PChar(Result)));
      end;
      FreePIDL(PIDL);
    end;
  end;
end;


procedure MakeDoc(const FileName:AnsiString);
  {Adds FileName to Window's Documents menu.  Clears the menu if FileName = null.}
begin
  if Length(FileName)>0 then
    SHAddToRecentDocs(SHARD_PATH, pChar(FileName))
  else
    SHAddToRecentDocs(SHARD_PATH, nil);
end;

function  GetKeyToggle(const Key:Integer):Boolean;
  { Returns current keyboard status.  Any key may be specifed, the standard
    toggle keys are VK_INSERT,VK_NUMLOCK,VK_SCROLL, VK_CAPITAL}
begin
   Result := Odd(GetKeyState(Key));
end;

function ToggleSysKeys:Boolean;
  {Enables/Disables system keys (Win95 only).  Returns current key state.}
var
  Tmp: Bool;
begin
  if SystemParametersInfo(SPI_SCREENSAVERRUNNING, SysKeyFlg, @Tmp, 0 ) then SysKeyFlg:= NOT SysKeyFlg;
  Result:=(SysKeyFlg<>0);
end;


procedure AddScrollBar(const hListBox:THandle;const Width:DWord);
  {Add a horizontal scroll bar to a ListBox component.}
begin
  SendMessage(hListBox,LB_SetHorizontalExtent,Width,0);
end;


procedure AddTabStops(const hListBox:THandle;const Stops:array of DWord);
  {Add horizontal tab stops to a ListBox component.}
begin
  SendMessage(hListBox,LB_SETTABSTOPS, High(Stops)+1,Longint(@Stops));
end;


function  KillProc(const ClassName:AnsiString):Boolean;

  {Terminates the first process with the given window class.  Window class is
   fixed whereas Window title can change.

   Example: KillProc('NOTEPAD') unconditionally terminates Windows Notepad if
            it is running. }
var
  hWnd,hProc:THandle;
  pid:DWORD;
begin
  Result:=False;
  hWnd := FindWindow(PCHAR(ClassName),nil);
  if IsWindow(hWnd) then begin
    GetWindowThreadProcessId(hWnd, @pid);
    hproc := OpenProcess(PROCESS_TERMINATE, FALSE, pid);
    if hproc<>0 then begin
      Result:=TerminateProcess(hProc,0);
      if Result then CloseHandle(hProc);
    end;
  end;
end;


procedure PrintStr(Source:AnsiString; Font:TFont);
  {Print contents of Source on default printer using Font.}
var
  Prn: TextFile;
begin
  if Length(Source)=0 then Exit;
  AssignPrn(Prn);
  try
    Rewrite(Prn);
    try
      if Font=nil then begin
        Printer.Canvas.Font.Name:='Courier New';
        Printer.Canvas.Font.Size:=12;
      end else Printer.Canvas.Font:=Font;
      Write(Prn, Source);
    finally
      CloseFile(Prn);
    end;
  except
    on EInOutError do raise Exception.Create('Error printing text.');
  end;
end;


procedure SaveStr(Source,FileName:AnsiString);
  {Save contents of Source string into FileName.}
var
  F:File;
  SaveMode:Integer;
begin
  AssignFile(F,FileName);
  SaveMode:=FileMode;
  FileMode:=1;            //always set this regardless of what docs say
  try
    Rewrite(F,1);
    try
      BlockWrite(F,Source[1],Length(Source));
    finally
      CloseFile(F);
    end;
  except
    on EInOutError do raise Exception.Create('Error writing to '+Filename);
  end;
  FileMode:=SaveMode;
end;


function LoadStr(FileName:AnsiString):AnsiString;
  {Retrieve contents of FileName as string.}
var
  F:File;
  I:Integer;
  SaveMode:Integer;
begin
  Setlength(Result,0);
  AssignFile(F,FileName);
  SaveMode:=FileMode;
  FileMode := 0;
  try
    Reset(F,1);
    try
      if SetFileLock(TFileRec(F).Handle,0,FileSize(F)) then begin
        SetLength(Result,FileSize(F));
        BlockRead(F,Result[1],Length(Result),I);
        ClrFileLock(TFileRec(F).Handle,0,FileSize(F));
        SetLength(Result,I);
      end;
    finally
      CloseFile(F);
    end;
  except
    on EInOutError do raise Exception.Create('Error reading from'+Filename);
  end;
  FileMode:=SaveMode;
end;


function LoadRec(FileName:AnsiString;var Rec; RecLen:Integer):Boolean;
  {Retrieve contents of FileName as record type.}
var
  F:File;
  I:Integer;
begin
  I:=-1;
  AssignFile(F,FileName);
  FileMode := 0;
  try
    Reset(F,1);
    try
      if SetFileLock(TFileRec(F).Handle,0,RecLen) then begin
        BlockRead(F,Rec,RecLen,I);
        ClrFileLock(TFileRec(F).Handle,0,RecLen);
      end;
    finally
      CloseFile(F);
      Result:=I=RecLen;
    end;
  except
    on EInOutError do raise Exception.Create('Error reading from'+Filename);
  end;
end;


function SaveRec(FileName:AnsiString;var Rec; RecLen:Integer):Boolean;
  {Save contents of record type into FileName.}
var
  F:File;
  I:Integer;
begin
  I:=-1;
  AssignFile(F,FileName);
  FileMode:=1;            //always set this regardless of what docs say
  try
    Rewrite(F,1);
    try
      BlockWrite(F,Rec,RecLen,I);
    finally
      CloseFile(F);
      Result:=I=RecLen;
    end;
  except
    on EInOutError do raise Exception.Create('Error writing to '+Filename);
  end;
end;


function GetPaperNames:AnsiString;
  {Returns a tokenized string (comma delimited) listing the names of all
   paper types supported by the default printer driver.}
var
  Tmp, Device, Port: AnsiString;
  I,J:Integer;
begin
  Result:='';
  Tmp:=GetDefaultPrn;
  if Length(Tmp)=0 then Exit;
  I:=1;
  Device:=Parse(Tmp,',',I);
  Parse(Tmp,',',I);
  Port:=Parse(Tmp,',',I);
  J := DeviceCapabilities( PChar(Device), PChar(Port), DC_PAPERNAMES, Nil, Nil );
  if J > 0 then begin
    SetLength(Tmp,J*64);
    DeviceCapabilities( PChar(Device), PChar(Port), DC_PAPERNAMES, PChar(Tmp), Nil);
    for I:= 1 To J do begin
      Result := Result + PChar(CStr(Tmp,((I-1)*64)+1,64) );
      if I<J then Result := Result+',';
    end;
    SetLength(Tmp,0);
  end;
end;


procedure GetComList(Strings:TStrings);

  {Reads all available COM ports from Registry and stores them in a TStrings
   list (ListBox). Also checks to see if a modem is attached to the port.
   If so, the modem 'Model' string is appended to the COM port name.}

var
  hTmp                   : HKEY;
  key,tKey,kBfr,vBfr,S   : AnsiString;
  I,N                    : Integer;
  J,K,Cnt,Max_Key,Max_Val: DWord;
begin
  //first, clear any existing entries in list
  if Strings.Count>0 then Strings.Clear;
  //read all available ports
  key:='hardware\devicemap\serialcomm';
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(Key),0,KEY_READ,hTmp) = ERROR_SUCCESS then begin
    if RegQueryInfoKey(hTmp, nil, nil, nil, nil, nil, nil, @Cnt, @Max_Key,
      @Max_Val, nil, nil) = ERROR_SUCCESS then begin;
      if Cnt>0 then begin
        SetLength(kBfr,Max_Key+1);
        SetLength(vBfr,Max_Val+1);
        for I:=0 to Cnt - 1 do begin
          J:=Max_Key+1;
          K:=Max_Val+1;
          if RegEnumValue(hTmp, I, PChar(kBfr), J, nil, nil, PByte(vBfr), @K)=ERROR_SUCCESS then begin;
            if K>1 then begin
              S:=LStr(vBfr,K-1);  //extract the port name from the buffer
              if Strings.IndexOf(S)=-1 then Strings.Add(S); //avoid any duplicates
            end;
          end;
        end;
      end;
    end;
    RegCloseKey(hTmp);
  end;

  //supplement port list with modem 'Model' string

  key:='System\CurrentControlSet\Services\Class\Modem';
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(Key),0,KEY_READ,hTmp) = ERROR_SUCCESS then begin
    if RegQueryInfoKey(hTmp, nil, nil, nil, @Cnt,@Max_Key, nil, nil, nil,
      nil, nil, nil) = ERROR_SUCCESS then begin;
      if Cnt>0 then begin
        SetLength(kBfr,Max_Key+1);
        SetLength(vBfr,MAX_PATH+1);
        for I:=0 to Cnt - 1 do begin
          J:=Max_Key+1;
          if RegEnumKeyEx(hTmp, I, PChar(kBfr), J, nil, nil, nil, nil)=ERROR_SUCCESS then begin;
            tKey:=key+'\'+LStr(kBfr,J);
            RegCloseKey(hTmp);
            if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(tKey),0,KEY_READ,hTmp) = ERROR_SUCCESS then begin
              J:=MAX_PATH;
              if RegQueryValueEx(hTmp,'AttachedTo',nil,nil,PByte(vBfr),@J) = ERROR_SUCCESS then begin
                S:=LStr(vBfr,J-1);
                J:=MAX_PATH;
                if RegQueryValueEx(hTmp,'Model',nil,nil,PByte(vBfr),@J) = ERROR_SUCCESS then begin
                   N:=Strings.IndexOf(S);
                   S:=S+'-'+LStr(vBfr,J-1);
                   if N=-1 then Strings.Add(S) else Strings[N]:=S;
                end;
              end;
              RegCloseKey(hTmp);
            end;
            RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(Key),0,KEY_READ,hTmp);
          end;
        end;
      end;
    end;
    RegCloseKey(hTmp);
  end;

end;

function  SHObjectProperties(Owner: HWND; Flags: UINT; ObjectName: Pointer;
                             InitialTabName: Pointer): LongBool;
                             stdcall;external 'shell32.dll' index 178;

function  ShowFileProperties(FilePath:AnsiString):Boolean;
begin
  Result:=SHObjectProperties(Application.Handle,$02,PChar(FilePath),nil);
end;

function  ShowPrinterProperties(PrnName:AnsiString):Boolean;
begin
  Result:=SHObjectProperties(Application.Handle,$01,PChar(PrnName),nil);
end;


function GetWindows:AnsiString;
  {Returns a tokenized string listing all currently active Windows.}
var
  lpCallBack: TFNWndEnumProc;

  function DoEnumWin(hwnd:THandle;lIntParam:LPARAM):Bool stdcall;
  begin
    if IsWindow(hwnd) then begin
      SetLength(Tmp,256);
      dwI:=GetWindowText(hwnd,PChar(Tmp),255);
      if dwI>0 then begin
        SetLength(Tmp,dwI);
        InsertToken(Temp,Tmp,0);
      end;
    end;
    Result:=True;
  end;

begin
  SetLength(Temp,0);
  lpCallBack:=@DoEnumWin;
  ENumWindows(lpCallBack,0);
  Result:=Temp;
end;


function GetClasses:AnsiString;
  {Returns a tokenized string listing all active window class names.}
var
  lpCallBack: TFNWndEnumProc;

  function DoEnumWin(hWnd:THandle;lIntParam:LPARAM):Bool stdcall;
  begin
    if IsWindow(hWnd) then begin
      SetLength(Tmp,256);
      dwI:=GetClassName(hWnd,PChar(Tmp),255);
      if dwI>0 then begin
        SetLength(Tmp,dwI);
        InsertToken(Temp,Tmp,0);
      end;
    end;
    Result:=True;
  end;

begin
  SetLength(Temp,0);  
  lpCallBack:=@DoEnumWin;
  ENumWindows(lpCallBack,0);
  Result:=Temp;
end;


function SendMAPI(Subj,Body,SendTo,CC,BCC,Att:AnsiString;MAPIFlags:Cardinal):Integer;
const
  FDelimiters=';,';
var
  MAPIMessage : TMAPIMessage;
  RB          : PMapiRecipDesc;
  RC          : LongInt;
  AB          : PMapiFileDesc;
  AC          : LongInt;

  procedure AllocateRecipients(var RecipientsBuffer : PMapiRecipDesc;
                               var RecipientsCount  : LongInt);
  var
    ES       : LongInt;
    RI       : LongInt;

    procedure AddRecipients(RecipientsString : AnsiString;RecipientsClass:Cardinal);
    var
     RS : AnsiString;
     I:Integer;
    begin
      I:=1;
      repeat
        //Find recipient string
        RS := Parse(RecipientsString, FDelimiters, I);
        if Length(RS)>0 then begin
          //Assign recipient buffer
          with PMapiRecipDesc(PAnsiChar(RecipientsBuffer) + (RI * ES))^ do begin
            ulRecipClass := RecipientsClass;
            lpszName := StrAlloc(Length(RS) + 1);
            StrPCopy(lpszName, RS);
          end;
          Inc(RI);
        end;
      until (I>Length(RecipientsString)) OR (I<1);
    end;

  begin
    //Initialize recipient index
    RI:=0;

    //Calculate recipient count
    RecipientsCount :=CountW(SendTo,FDelimiters)+CountW(CC,FDelimiters)+
                      CountW(BCC,FDelimiters);

    //Calculate element size
    ES := SizeOf(TMapiRecipDesc);

    //Allocate and initialize buffer
    GetMem(RecipientsBuffer, RecipientsCount * ES);
    FillChar(RecipientsBuffer^, RecipientsCount * ES, #0);

    //Add recipients to buffer
    AddRecipients(SendTo, MAPI_TO);
    AddRecipients(CC, MAPI_CC);
    AddRecipients(BCC, MAPI_BCC);
  end;

  procedure DeallocateRecipients(RecipientsBuffer : PMapiRecipDesc;
                                 RecipientsCount  : LongInt);
  var
    I  : LongInt;
    ES : LongInt;
  begin
     //Calculate element size
    ES := SizeOf(TMapiRecipDesc);

     //Deallocate addresses
    for I := 0 to RecipientsCount - 1 do
      with PMapiRecipDesc(PAnsiChar(RecipientsBuffer) + (I * ES))^ do StrDispose(lpszAddress);

     //Deallocate buffer
    FreeMem(RecipientsBuffer, RecipientsCount * ES);
  end;

  procedure AllocateAttachments(var AttachmentBuffer : PMapiFileDesc;
                                var AttachmentCount  : LongInt);
  var
    ES : LongInt;
    FI : LongInt;
    FS : AnsiString;
     I : Integer;
  begin
    //Calculate attachments count
    AttachmentCount := CountW(Att, FDelimiters);

    //Calculate element size
    ES := SizeOf(TMapiFileDesc);

    //Allocate and initialize buffer
    GetMem(AttachmentBuffer, AttachmentCount * ES);
    FillChar(AttachmentBuffer^, AttachmentCount * ES, #0);

    //Add attachments to buffer
    I:=1;
    FI:=0;
    repeat
      //Find attachment string
      FS := Parse(Att, FDelimiters, I);

      if Length(FS)>0 then begin
        //Assign Attachment buffer
        with PMapiFileDesc(PAnsiChar(AttachmentBuffer) + (FI * ES))^ do begin
          //Assign Attachment buffer
          lpszPathName := StrAlloc(Length(FS) + 1);
          StrPCopy(lpszPathName, FS);
          LongInt(nPosition) := -1;
        end;
        Inc(FI);
      end;
    until (I>Length(Att)) OR (I<1) OR (FI=AttachmentCount);
  end;

  procedure DeallocateAttachments(AttachmentBuffer : PMapiFileDesc;
                                  AttachmentCount  : LongInt);
  var
    I  : LongInt;
    ES : LongInt;
  begin
    //Calculate element size
    ES := SizeOf(TMapiFileDesc);

    //Deallocate addresses
    for I := 0 to AttachmentCount - 1 do
      with PMapiFileDesc(PAnsiChar(AttachmentBuffer) + (I * ES))^ do StrDispose(lpszPathName);

    //Deallocate buffer
    FreeMem(AttachmentBuffer, AttachmentCount * ES);
  end;


begin

  with MAPIMessage do begin
    ulReserved         := 0;
    lpszSubject        := PAnsiChar(Subj);
    lpszNoteText       := PAnsiChar(Body);
    lpszMessageType    := nil;
    lpszDateReceived   := nil;
    lpszConversationID := nil;
    flFlags            := 0;
    lpOriginator       := nil;

    AllocateRecipients(RB, RC);

    nRecipCount        := RC;
    lpRecips           := RB;

    AllocateAttachments(AB, AC);

    nFileCount         := AC;
    lpFiles            := AB;
  end;

  //Send mail
  Result := MAPISendMail(0, Application.Handle, MAPIMessage, MAPIFlags, 0);

  //Deallocate buffers
  DeallocateRecipients(RB, RC);
  DeallocateAttachments(AB, AC);
end;


end.
