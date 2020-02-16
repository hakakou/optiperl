unit HakaWin;

interface
uses sysutils,windows,messages,shellapi,tlhelp32,hyperstr,classes,
     registry,forms,controls,graphics,variants;

type
 TMakeWinList = Procedure (list : TList) of object;

function GetSpecialFolder(const Name : String; CurrentUser : Boolean): string;
function ControlPanelOpen(const Parametros: String): THandle;
Function KillProcess(Handle : THandle) : Boolean;
Function SetAutoHideBar(AutoHide : Boolean; TaskBarHandle: THandle) : boolean;
Function ProcessIDToProcess(PID : Cardinal) : Cardinal;
Function GetProcessEntry32(ExeName : string; var Hadpath : string) : THandle;
Function IsExeLoaded(ExeName : String) : Boolean;
Procedure GetWorkAreaDimensions(out Width,Height : integer);
Procedure PostKeyEx( hWindow: HWnd; key: Word; Const shift: TShiftState;
                     specialkey: Boolean );
procedure KillAllExeNames(const ExeName : string);

Function LoadResToBuffer(const resName : string; ires : integer;
                         out buf : Pointer; out Size : integer) : Boolean;

Procedure FocusFormIfExists(Form : TForm);
Function CheckForm(Form : TCustomForm) : Boolean;
Procedure SafeFocus(Form : TCustomForm); overload;
Procedure SafeFocus(WinControl : TWinControl); overload;

Procedure OverlapWindow(BottomWin, TopWin : THandle);
Procedure SetWindowInsertAfter(Handle : THandle; InsertAfter : Cardinal);

Function FormExists(Form : TForm) : Boolean;
Function GetVisibleCount : Integer;
Function GetModalForm : TCustomForm;
function GetAppDataFolder(CanCreate,Common : Boolean; const AppName : String): string;
function GetMyDocFolder(CanCreate : Boolean; const AppName : String): string;

Procedure GetVersionInfo(Const Path : String; Items: TStrings);
Function GetVersionValue(const Path,Val : String) : String;

Function StringToOleVarArray(const str : string) : OleVariant;
Function OleVarArrayToString(const OleVar : OleVariant) : String;

Function GetTextWidth(Canvas : TCanvas; Const Str : String) : TPoint;
Procedure ConstraintSetHeight(Form : TCustomForm; AHeight : Integer);

Procedure EnableApplication(RestoreAlso : Boolean = false);
Procedure DisableApplication;

Procedure StartNonAnimatedWindows;
Procedure EndNonAnimatedWindows;
//end MUST be called after start!!!

Function HKCanRestoreWindows : Boolean;
procedure HKSaveWindows;
procedure HKRestoreWindows;
Procedure HKSizeWindows(w1,w2 : TCustomForm; Big : Boolean; Divid : Integer);
procedure HKSelectNextWindow(MakeList : TMakeWinList);

var
 DefMonospaceFontName : String;

implementation

type
 TSaveWin = Record
  Form : TCustomForm;
  Rect : TRect;
 end;

var
 WindowList: Pointer;
 DisabledApp : Boolean = false;
 DisFocusedForm : TCustomForm;
 SavedWins : Array of TSaveWin;
 LastWinList : TList;
 LastWin : Integer = 0;

Function HKCanRestoreWindows : Boolean;
begin
 result:=length(savedWins)>0;
end;

procedure HKSelectNextWindow(MakeList : TMakeWinList);
var
 i,j:integer;
 cf : TCustomForm;
 List : TList;
 DoAgain : boolean;
begin
 if not assigned(LastWinList) then
  LastWinList:=TList.create;

 List:=TList.Create;
 try
  MakeList(list);
  DoAgain:=List.Count<>LastWinList.Count;
  if not DoAgain then
   for i:=0 to LastWinList.Count-1 do
   begin
    j:=List.IndexOf(LastWinList[i]);
    if J>=0 then
     List.Delete(j)
    else
     begin
      DoAgain:=true;
      break;
     end;
   end;
  if not DoAgain then
   DoAgain:=List.Count>0;
 finally
  list.Free;
 end;

 if DoAgain then
  MakeList(LastWinList);

 Inc(lastWin);
 if LastWin>=LastWinList.Count then LastWin:=0;
 if LastWin<LastWinList.count then
 begin
  cf:=TCustomForm(LastWinList[LastWin]);
  if (cf.Enabled) and (cf.Visible)
   then cf.SetFocus;
 end;
end;


procedure HKSaveWindows;
var i:integer;
begin
 SetLength(SavedWins,screen.CustomFormCount);
 for i:=0 to screen.CustomFormCount-1 do
 begin
  SavedWins[i].Form:=screen.CustomForms[i];
  SavedWins[i].Rect:=screen.CustomForms[i].BoundsRect;
 end;
end;

procedure HKRestoreWindows;
var
 i,j : Integer;
 f : TCustomForm;
 R : TRect;
begin
 for i:=0 to length(SavedWins) do
 begin

  f:=nil;
  for j:=0 to screen.CustomFormCount-1 do
   if Screen.CustomForms[j]=savedwins[i].Form then
    begin
     f:=Screen.CustomForms[j];
     r:=SavedWins[i].Rect;
     break;
    end;

  if assigned(f) and (f.Parent=nil) and (not EqualRect(r,f.BoundsRect)) then
   f.BoundsRect:=r;
 end;
 SetLength(SavedWins,0);
end;

Procedure HKSizeWindows(w1,w2 : TCustomForm; Big : Boolean; Divid : Integer);
var w : integer;
begin
 w1.WindowState:=wsNormal;
 w2.WindowState:=wsNormal;
 if W1.Left<0 then w1.left:=0;
 if W2.Left<0 then w2.left:=0;

 if W1.left+W1.Width>Screen.Width then
  W1.Width:=Screen.Width-W1.left;

 if w2.left+w2.Width>Screen.Width then
  W2.Width:=screen.Width-W2.left;

 w:=w1.Width+w1.Left-w2.Left;
 if big
  then w2.Width:=w div Divid
  else w2.Width:=w - w div Divid;
 w1.Left:=w2.left+w2.Width;
 if big
  then w1.Width:=w - w div Divid
  else w1.Width:=w div Divid;
end;


Procedure ConstraintSetHeight(Form : TCustomForm; AHeight : Integer);
begin
 with form do
 begin
  constraints.MinHeight:=0;
  constraints.MaxHeight:=0;
  ClientHeight:=AHeight;
  constraints.MinHeight:=height;
  constraints.MaxHeight:=height;
 end;
end;

Function GetTextWidth(Canvas : TCanvas; Const Str : String) : TPoint;
var
 Chars : Integer;
 ASize : SIZE;
begin
 if GetTextExtentPoint32(canvas.Handle,pchar(str),length(str),ASize) then
  begin
   Result.X:=ASize.cx;
   result.Y:=ASize.cy;
  end
 else
  fillchar(result,sizeof(result),0);
end;

Procedure EnableApplication(RestoreAlso : Boolean = false);
begin
 if not DisabledApp then exit;
 EnableTaskWindows(WindowList);
 if (RestoreAlso) and CheckForm(DisFocusedForm) then
  SafeFocus(DisFocusedForm);
 DisabledApp:=false;
end;

Procedure DisableApplication;
begin
 if DisabledApp then exit;
 DisabledApp:=true;
 DisFocusedForm:=screen.ActiveCustomForm;
 WindowList := DisableTaskWindows(0);
end;

Function StringToOleVarArray(const str : string) : OleVariant;
var i:integer;
begin
 result:= VarArrayCreate([0, Length(Str)-1], varByte);
 for i := 0 to Length(str)- 1 do    // Iterate
  result[i]:= Ord(str[i+1]);
end;

Function OleVarArrayToString(const OleVar : OleVariant) : String;
var
 i,l:integer;
begin
 l:=vararrayhighBound(olevar,1);
 SetLength(result,l+1);
 for i := 0 to l do
  result[i+1]:=chr(byte(olevar[i]));
end;


Function GetVersionValue(const Path,Val : String) : String;
var
  n, Len, i: DWORD;
  Buf: PChar;
  Value: PChar;
begin
  //nice but wont work if version info is not in english
  result:='';
  n := GetFileVersionInfoSize(PChar(Path), n);
  if n > 0 then
  begin
    Buf := AllocMem(n);
    GetFileVersionInfo(PChar(path), 0, n, Buf);
    if VerQueryValue(Buf, PChar('StringFileInfo\040904E4\'+Val), Pointer(Value), Len) then
     result:=value;
    FreeMem(Buf, n);
  end;
end;

Procedure GetVersionInfo(Const Path : String; Items: TStrings);
const
  InfoNum = 10;
  InfoStr : array[1..Infonum] of string = ('CompanyName', 'FileDescription', 'FileVersion', 'InternalName', 'LegalCopyright', 'LegalTradeMarks', 'OriginalFileName', 'ProductName', 'ProductVersion', 'Comments');
var
  n, Len, i: DWORD;
  Buf: PChar;
  Value: PChar;
begin
  //nice but wont work if version info is not in english
  n := GetFileVersionInfoSize(PChar(Path), n);
  if n > 0 then
  begin
    Buf := AllocMem(n);
    Items.Add('VersionInfoSize='+IntToStr(n));
    GetFileVersionInfo(PChar(path), 0, n, Buf);
    for i := 1 to InfoNum do
      if VerQueryValue(Buf, PChar('StringFileInfo\040904E4\' + InfoStr[i]), Pointer(Value), Len) then
        Items.Add(InfoStr[i] + '=' + Value);
    FreeMem(Buf, n);
  end;
end;

var PrevAni : Integer = 0;

Procedure StartNonAnimatedWindows;
var
 ANI : ANIMATIONINFO;
begin
 ANI.cbSize:=sizeof(ANI);
 ANI.iMinAnimate:=0;
 SystemParametersInfo(SPI_GETANIMATION,sizeof(ANI),@ANI,0);
 PrevANI:=ANI.iMinAnimate;

 if PrevANI<>0 then
 begin
  ANI.cbSize:=sizeof(ANI);
  ANI.iMinAnimate:=0;
  SystemParametersInfo(SPI_SETANIMATION,sizeof(ANI),@ANI,0);
 end;
end;

Procedure EndNonAnimatedWindows;
var
 ANI : ANIMATIONINFO;
begin
 if PrevANI<>0 then
 begin
  ANI.cbSize:=sizeof(ANI);
  ANI.iMinAnimate:=PrevANI;
  SystemParametersInfo(SPI_SETANIMATION,sizeof(ANI),@ANI,0);
 end;
end;

Function GetVisibleCount : Integer;
var i:integer;
begin
 result:=0;
 for i:=0 to screen.FormCount-1 do
  if screen.Forms[i].Visible then inc(result);
end;

Procedure SetWindowInsertAfter(Handle : THandle; InsertAfter : Cardinal);
begin
 SetWindowPos(Handle, InsertAfter, 0, 0, 0, 0,
  SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

Procedure OverlapWindow(BottomWin, TopWin : THandle);
begin
 SetWindowPos(BottomWin,TopWin,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE+SWP_NOACTIVATE);
end;

Function GetModalForm : TCustomForm;
var
 i:integer;
begin
 with screen do
  for i:=0 to CustomFormCount-1 do
   if fsmodal in Customforms[i].FormState then
   begin
    result:=Customforms[i];
    exit;
   end;
 result:=nil;
end;

Function FormExists(Form : TForm) : Boolean;
var i:integer;
begin
 if (form=nil) then
 begin
  result:=false;
  exit;
 end;
 for i:=0 to screen.FormCount-1 do
  if screen.Forms[i]=form then
  begin
   result:=true;
   exit;
  end;
 result:=false;
end;

Function CheckForm(Form : TCustomForm) : Boolean;
var i:integer;
begin
 if not assigned(Form) then
 begin
  result:=false;
  exit;
 end;

 with screen do
  for i:=0 to CustomFormCount-1 do
   if form=customforms[i] then
   begin
    result:=true;
    exit;
   end;
 result:=false;
end;

Procedure SafeFocus(WinControl : TWinControl);
var form : TCustomForm;
begin
 with screen do
  if (winControl.Enabled) and
    ((not assigned(ActiveForm)) or (not (fsmodal in activeform.FormState))) then
  begin
   Form:=ValidParentForm(WinControl);
   if (not assigned(Form)) or (not form.Enabled) then exit;
   if not form.Visible then form.Show;
   WinControl.setFocus
  end;
end;

Procedure SafeFocus(Form : TCustomForm);
begin
 with screen do
  try
   if (assigned(form)) and (Form.Enabled) and
     ((not assigned(ActiveCustomForm)) or (not (fsmodal in activeCustomform.FormState))) then
   begin
    if not form.Visible then form.show;
    if not form.Focused then Form.SetFocus;
   end;
  except on exception do end;
end;

Procedure FocusFormIfExists(Form : TForm);
var i:integer;
begin
 if (form<>Screen.ActiveForm) and (FormExists(form)) then
  SafeFocus(Form);
end;

Function LoadResToBuffer(const resName : string; ires : integer;
                         out buf : Pointer; out Size : integer) : Boolean;
var
 h,ResHandle : Cardinal;
begin
 h:=GetModuleHandle(pchar(extractFilename(paramstr(0))));
 reshandle:=FindResource(h,Makeintresource(ires),PChar(ResName));
 buf:=Pointer(loadresource(h,reshandle));
 Result:=buf<>nil;
 if not Result then Exit;
 Size:=SizeofResource(h,reshandle);
end;


Procedure PostKeyEx( hWindow: HWnd; key: Word; Const shift: TShiftState;
                     specialkey: Boolean );
Type
  TBuffers = Array [0..1] of TKeyboardState;
Var
  pKeyBuffers : ^TBuffers;
  lparam: LongInt;
Begin
  (* check if the target window exists *)
  If IsWindow(hWindow) Then Begin
    (* set local variables to default values *)
    pKeyBuffers := Nil;
    lparam := MakeLong(0, MapVirtualKey(key, 0));

    (* modify lparam if special key requested *)
    If specialkey Then
      lparam := lparam or $1000000;

    (* allocate space for the key state buffers *)
    New(pKeyBuffers);
    try
      (* Fill buffer 1 with current state so we can later restore it.  
         Null out buffer 0 to get a "no key pressed" state. *)
      GetKeyboardState( pKeyBuffers^[1] );
      FillChar(pKeyBuffers^[0], Sizeof(TKeyboardState), 0);

      (* set the requested modifier keys to "down" state in the buffer *)
      If ssShift In shift Then
        pKeyBuffers^[0][VK_SHIFT] := $80;
      If ssAlt In shift Then Begin
        (* Alt needs special treatment since a bit in lparam needs also be set *)
        pKeyBuffers^[0][VK_MENU] := $80;
        lparam := lparam or $20000000;
      End;
      If ssCtrl In shift Then
        pKeyBuffers^[0][VK_CONTROL] := $80;
      If ssLeft In shift Then
        pKeyBuffers^[0][VK_LBUTTON] := $80;
      If ssRight In shift Then
        pKeyBuffers^[0][VK_RBUTTON] := $80;
      If ssMiddle In shift Then
        pKeyBuffers^[0][VK_MBUTTON] := $80;

      (* make out new key state array the active key state map *)
      SetKeyboardState( pKeyBuffers^[0] );

      (* post the key messages *)
      If ssAlt In Shift Then Begin
        PostMessage( hWindow, WM_SYSKEYDOWN, key, lparam);
        PostMessage( hWindow, WM_SYSKEYUP, key, lparam or $C0000000);
      End
      Else Begin
        PostMessage( hWindow, WM_KEYDOWN, key, lparam);
        PostMessage( hWindow, WM_KEYUP, key, lparam or $C0000000);
      End;
      (* process the messages *)
      Application.ProcessMessages;

      (* restore the old key state map *)
      SetKeyboardState( pKeyBuffers^[1] );
    finally
      (* free the memory for the key state buffers *)
      If pKeyBuffers <> Nil Then
        Dispose( pKeyBuffers );
    End; { If }
  End;
End; { PostKeyEx }


Procedure GetWorkAreaDimensions(out Width,Height : integer);
var r : tRECT;
begin
 SystemParametersInfo(SPI_GETWORKAREA,0,@r,0);
 Width:=r.Right-r.Left;
 Height:=r.Bottom-r.Top;
end;

procedure KillAllExeNames(const ExeName : string);
var
 h:Integer;
 hadpath:string;
begin
 h:=GetProcessEntry32(exename,hadpath);
 repeat
  if h>0 then killprocess(h);
  h:=GetProcessEntry32(exename,hadpath);
 until h<=0;
end;

Function SetAutoHideBar(AutoHide : Boolean; TaskBarHandle: THandle) : boolean;
var
 AppBarData : TAppBarData;
begin
 result:=false;
 AppBarData.cbSize:=sizeof(AppBarData);
 AppBarData.hWnd:=TaskBarHandle;
 AppBarData.uEdge:=ABE_BOTTOM;
 AppBarData.rc.Left:=10;
 AppBarData.rc.Right:=500;
 AppBarData.rc.Top:=10;
 AppBarData.rc.Bottom:=400;
 ShowWindow(TaskBarHandle, SW_SHOW)
end;

Function IsExeLoaded(ExeName : String) : Boolean;
var
 PE: TProcessEntry32;
 Snap : THandle;
begin
 Result:=False;
 Exename:=uppercase(ExtractFilename(exename));
 snap:=createToolHelp32Snapshot(TH32CS_SNAPPROCESS,0);
 if integer(snap)=-1 then exit;
 PE.dwSize:=sizeof(PE);
 if Process32First(Snap,PE) then
  repeat
   if uppercase(extractfilename(string(pe.szExeFile)))=eXeName then
   begin
    Result:=True;
    break;
   end;
  until not Process32Next(snap,pe);
 CloseHandle(snap);
end;

Function ProcessIDToProcess(PID : Cardinal) : Cardinal;
var
 PE: TProcessEntry32;
 Snap : THandle;
begin
 result:=0;
 snap:=createToolHelp32Snapshot(TH32CS_SNAPPROCESS,0);
 if integer(snap)=-1 then exit;
 PE.dwSize:=sizeof(PE);
 if Process32First(Snap,PE) then
  repeat
   if pe.th32ParentProcessID=pId then
   begin
    result:=OpenProcess(PROCESS_ALL_ACCESS,false,pe.th32ProcessID);
    IF integer(result)>0 then break;
   end;
  until not Process32Next(snap,pe);
 CloseHandle(snap);
end;


Function GetProcessEntry32(ExeName : string; var Hadpath : string) : THandle;
var
 PE: TProcessEntry32;
 Snap : THandle;
begin
 Exename:=uppercase(ExtractFilename(exename));
 integer(result):=-1;
 snap:=createToolHelp32Snapshot(TH32CS_SNAPPROCESS,0);
 if integer(snap)=-1 then exit;
 PE.dwSize:=sizeof(PE);
 if Process32First(Snap,PE) then
  repeat
   if uppercase(extractfilename(string(pe.szExeFile)))=eXeName then
   begin
    hadPath:=ExtractFilepath(string(pe.szExeFile));
    result:=OpenProcess(PROCESS_ALL_ACCESS,false,pe.th32ProcessID);
    IF integer(result)>0 then break;
   end;
  until not Process32Next(snap,pe);
 CloseHandle(snap);
end;

Function KillProcess(Handle : THandle) : Boolean;
var
 i : Cardinal;
begin
 i:=0;
 result:=TerminateProcess(Handle,i);
end;

function GetAppDataFolder(CanCreate,Common : Boolean; const AppName : String): string;
begin
 result:='';
 if common then
  result:=GetSpecialFolder('Common AppData',false);

 if result='' then
  result:=GetSpecialFolder('AppData',true);

 if result='' then exit;
 result:=IncludeTrailingBackSlash(result);
 if length(AppName)>0
  then result:=result+AppName+'\';

 if (not DirectoryExists(result)) and (CanCreate) then
  ForceDirectories(result);
end;

function GetMyDocFolder(CanCreate : Boolean; const AppName : String): string;
begin
 result:=GetSpecialFolder('Personal',true);
 if result='' then exit;
 result:=IncludeTrailingBackSlash(result)+AppName+'\';

 if (not DirectoryExists(result)) and (CanCreate) then
  ForceDirectories(result);
end;


{('AppData','Cache','Cookies','Desktop',
                 'Favorites','Fonts','History','NetHood','Personal','Programs','Recent',
                 'SendTo','Start Menu','Statup','Templates');
}

function GetSpecialFolder(const Name : String; CurrentUser : Boolean): string;
var
 reg : TRegistry;
const
 KEYConst : Array [boolean] of HKEY = (HKEY_LOCAL_MACHINE,HKEY_CURRENT_USER);
begin
 result:='';
 reg:=TRegistry.Create(KEY_READ);
 try
  try
   reg.RootKey:=KEYConst[CurrentUser];
   reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',false);
   result:=reg.ReadString(name);
   reg.CloseKey;
   if length(result)>0 then
    result:=IncludeTrailingBackSlash(result);
  except
   on exception do
  end;
 finally
  reg.free;
 end;
end;

function ControlPanelOpen(const Parametros: String): THandle;
begin
  Result := ShellExecute(Application.MainForm.Handle,
                         nil,
                          Pchar('rundll32.exe'),
                          Pchar(Parametros),
                          nil,
                          SW_SHOW);
end;

procedure GetDefFontNames;
var
  Charset: TFontCharset;
begin
 DefMonospaceFontName:='Courier New';
 if not SysLocale.FarEast then Exit;
 Charset := GetDefFontCharset;
 case Charset of
    SHIFTJIS_CHARSET:
      begin
        DefMonospaceFontName:='‚l‚r ƒSƒVƒbƒN';
        if screen.Fonts.IndexOf(DefMonospaceFontName)=0 then
         DefMonospaceFontName:='‚l‚r –¾’©';
        if screen.Fonts.IndexOf(DefMonospaceFontName)=0 then
        begin
         if (Win32MajorVersion>=5)
          then DefMonospaceFontName:='MS Shell Dlg 2'
          else DefMonospaceFontName:='MS Shell Dlg';
        end;
      end;
  end;
end;

initialization
 GetDefFontNames;
finalization
 if assigned(LastWinList) then
  LastWinList.Free;
end.
