unit WebBrowserFrm; //Modeless //memo 3 //VST //StatusBar //TAbs
{$I REG.INC}

interface

uses Windows, Forms, OleCtrls,SHDocVw,hakacontrols, OptQuery, aqDockingBase,
  Controls, dccommon, dcmemo, ComCtrls, StdCtrls, Classes, Buttons,messages,
  OptGeneral, ExtCtrls,sysutils, OptFolders,hakafile,OptProcs,OptControl,
  OptOptions,hyperstr,jvVCLUtils, Menus, jvCtrls,ScriptInfoUnit,HakaMessageBox,
  HKWebBrowser,hakageneral,hyperfrm,hakawin,clipbrd, dcsystem, dcparser,
  dcstring,HKComboInputForm,dialogs,variants,fmxutils,ParsersMdl,shellapi,
  VirtualTrees, hakahyper, jclfileutils,graphics, cxKeyPlus, AppEvnts,
  HKWebFind, wininet, jvSpin, dcSyntax,SyncObjs,ServerMdl,MainServerMdl,
  ConsoleIO,FTPMdl,HaKaTabs,hkclasses,OptForm, bigwebfrm, dcstdctl,HKDebug,
  JvPlacemnt, JvEdit, JvSpeedButton, dxBar, dxBarExtItems,splashFrm;


const
  MaxThreads = 6;
  MaxLines = 500;

  type
  TMemoThread = Record
   Memo : TDCMemo;
   LastSender : TObject;
  end;


  TWebBrowserForm = class(TOptiForm)
    TextSheet: TTabSheet;
    WebSheet: TTabSheet;
    memOutput: TDCMemo;
    PageControl: THKPageControl;
    PopupMenu: TPopupMenu;
    WrapLinesItems: TMenuItem;
    StatusBar: TStatusBar;
    N1: TMenuItem;
    CopySelected1: TMenuItem;
    Copyall1: TMenuItem;
    Timer: TTimer;
    InfoSheet: TTabSheet;
    VST: TVirtualStringTree;
    N2: TMenuItem;
    IncreaseFontSizeItem: TMenuItem;
    DecreaseFontSizeItem: TMenuItem;
    FlashTimer: TTimer;
    cxKeyPlus: TcxKeyPlus;
    TalkSheet: TTabSheet;
    FormStorage: TjvFormStorage;
    GUI: TGUI2Console;
    BarManager: TdxBarManager;
    btnSend: TdxBarButton;
    edSend: TdxBarEdit;
    btnClear: TdxBarButton;
    cbFilter: TdxBarCombo;
    edThreads: TdxBarSpinEdit;
    ServerGroup: TdxBarGroup;
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure btnSendClick(Sender: TObject);
    procedure WrapLinesItemsClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure CopySelected1Click(Sender: TObject);
    procedure Copyall1Click(Sender: TObject);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
    procedure PageControlChange(Sender: TObject);
    procedure IncreaseFontSizeItemClick(Sender: TObject);
    procedure DecreaseFontSizeItemClick(Sender: TObject);
    procedure FlashTimerTimer(Sender: TObject);
    procedure cxKeyPlusBrowserBackward(Sender: TObject;
      ShiftState: TShiftState);
    procedure cxKeyPlusBrowserForward(Sender: TObject;
      ShiftState: TShiftState);
    procedure cxKeyPlusBrowserRefresh(Sender: TObject;
      ShiftState: TShiftState);
    procedure cxKeyPlusBrowserStop(Sender: TObject;
      ShiftState: TShiftState);
    procedure cxKeyPlusBrowserSearch(Sender: TObject;
      ShiftState: TShiftState);
    procedure cxKeyPlusBrowserHome(Sender: TObject;
      ShiftState: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edThreadsChange(Sender: TObject);
    procedure TalkSheetResize(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure GUIStart(Sender: TObject; const Command: String);
    procedure GUILine(Sender: TObject; const Line: String);
    procedure GUITimeOut(Sender: TObject; var Kill: Boolean);
    procedure GUIDone(Sender: TObject);
    procedure GUIPrompt(Sender: TObject; const Line: String);
    procedure cbFilterChange(Sender: TObject);
    procedure WebSheetResize(Sender: TObject);
    procedure PageControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edSendKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSendKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edSendCurChange(Sender: TObject);
    procedure VSTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
  private
    StrProgress,StrStatus,StrTitle,StrMs : String;
    LastEnv,LastPost : String;
    LastUsed : Integer;
    FixHeaders,WebPrimary : Boolean;
    FileExternal,FileSecond : Boolean;
    FileText : String;
    FileTemp : String;
    GUISentInput : Boolean;
    GUIStartScript,GUINextTimeOut : Cardinal;
    FirstRun : Boolean;
    MemoThread : Array[0..MaxThreads-1] of TMemoThread;
    ProxyMemoWrite : Integer;
    ProxyNewLine,ProxyToggle : Boolean;

    procedure WebBrowserTitleChange(Sender: TObject; const Text: WideString);
    procedure WebBrowserProgressChange(Sender: TObject; Progress, ProgressMax: Integer);
    procedure WebBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    procedure WebBrowserStatusTextChange(Sender: TObject; const Text: WideString);
    procedure WebBrowserCommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);

    procedure UpdateFromPrimary;
    procedure TimeToUpdate;
    Function MakeURL(ForceRunWithServer : boolean) : String;
    function AddNode(const prop, Value: string; Parent: Pointer = nil) : PVirtualNode;
    procedure MakeInfo;
    procedure MakeThreads;
    procedure UpdateCookie(CNode : PVirtualNode; Const LastCookie : String);
    function GetPos(Sender: TObject): Integer;
    procedure WriteMemo(i: Integer; const Str: String);
    procedure RunPage(Internal, Secondary: Boolean; GoURL : String);
    function MakeHeaders(const URL : String) : String;
    Procedure WMActivate(var msg : TWMActivate); message WM_Activate;
    procedure AddCookies(URL : String);
    procedure DeleteCookies(URL: String);
    procedure UpdateStatusBar;
    procedure InitBrowser;
  Protected
   Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); Override;
   procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix, index: Integer); override;
   procedure FirstShow(Sender: TObject); override;
   procedure AfterContainerShow(Sender: TObject); override;

   procedure _OpenURL(const Data: String);
   procedure _OptionsUpdated(Level: Integer);
   procedure _WaitingForInput(data: BOolean);
   procedure _PerlOutput(const Str: String);
   procedure _NewSession;
   procedure _OpenURLQuery(const data: String);
   procedure _RunScriptExternal;
   procedure _RunScriptExtSec;
   procedure _RunScriptInternal;
   function _GetWebCookie: String;
   function _WebBrowserData: String;
  Public
    ForwardEnable,BackEnable,RefreshEnable : Boolean;
    RunningOffline : Boolean;
    WebBrowser : TWebBrowser;
    DeActivated : Boolean;
    procedure ResetBrowser;
    procedure TermBrowser;
    procedure OnRequest(Sender : TObject; const Status: string);
    procedure OnResponse(Sender : TObject; const Status: string);
    Procedure OnProxyLog(Sender : TObject; Const Log : String);
  end;

  PData = ^TData;
  TData = Record
   prop,value: string;
  end;

var
  WebBrowserForm: TWebBrowserForm;

implementation

{$R *.DFM}

procedure TWebBrowserForm.FirstShow(Sender: TObject);
var
 i:integer;
begin
 PR_PerlOutput:=_PerlOutput;
 PR_OpenURL:=_OpenURL;
 PR_NewSession:=_NewSession;
 PR_OpenURLQuery:=_OpenURLQuery;
 PR_RunScriptExternal:=_RunScriptExternal;
 PR_RunScriptExtSec:=_RunScriptExtSec;
 PR_RunScriptInternal:=_RunScriptInternal;
 PR_WaitingForInput:=_WaitingForInput;
 PC_WebBrowser_OptionsUpdated:=_OptionsUpdated;
 PR_GetWebCookie:=_GetWebCookie;
 PR_WebBrowserData:=_WebBrowserData;

 ResetBrowser;

 FixHeaders:=false;
 edThreads.MaxValue:=round(MaxThreads);
 LastUsed:=-1;
 for i:=0 to MaxThreads-1 do
 begin
   memoThread[i].Memo:=TDCMemo.Create(TalkSheet);
   MemoThread[i].Memo.PopupMenu:=popupmenu;
   SetMemo(memoThread[i].Memo,[]);

   with memoThread[i].Memo do
   begin
    lefT:=0;
    parent:=TalkSheet;
    visible:=false;
    SyntaxParser:=ParsersMod.HeadParser;
    Font.Size:=8;
    scrollbars:=ssBoth;
    readonly:=true;
   end;

 end;
 MakeThreads;

 memOutput.MemoSource.SyntaxParser:=ParsersMod.HTML;
 RunningOffline:=false;
 PageControl.ActivePage:=WebSheet;
 RefreshEnable:=false;
 VST.NodeDataSize:=SizeOf(TData);
 cxKeyPlus.enabled:=options.KeybExtended;

 WebBrowser.Tag:=Integer(DockControl);

 FormStorage.RestoreFormPlacement;
 initBrowser;
 WebPrimary:=True;
 TimeToUpdate;
 PageControlChange(nil);
 SetMemo(memOutput,[]);
end;

procedure TWebBrowserForm.InitBrowser;
begin
 Sleep(50);
 if (fileexists(programpath+OptiStartPage)) then
 try
  WebBrowser.Navigate(programpath+OptiStartPage);
 except
 end;
end;

procedure TWebBrowserForm.edSendKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_RETURN then
 begin
  key:=0;
  btnSend.Click;
 end;
end;

procedure TWebBrowserForm.edSendKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_RETURN then
  key:=0;
end;

procedure TWebBrowserForm._PerlOutput(const Str: String);
begin
 FixHeaders:=false;
 WebPrimary:=False;
 memOutput.Lines.Add(Str);
 TimeToUpdate;
end;

procedure TWebBrowserForm._NewSession;
begin
 FixHeaders:=false;
 WebPrimary:=False;
 memOutput.Lines.Clear;
 TimeToUpdate;
end;

procedure TWebBrowserForm._WaitingForInput(data : BOolean);
begin
 flashtimer.Enabled:=data;
 btnSend.down:=data;
 if DockControl.DockState=dcsHidden then
 try
  show;
 except
 end;
end;

procedure TWebBrowserForm._OpenURL(Const Data : String);
begin
  FixHeaders:=false;
  WebPrimary:=True;
  InternetSetOption(nil, INTERNET_OPTION_RESET_URLCACHE_SESSION ,nil,0);
  WebBrowser.Navigate(string(data));
end;

Procedure TWebBrowserForm._OptionsUpdated(Level : Integer);
begin
 cxKeyPlus.enabled:=Options.KeybExtended;
 memOutput.TabStops:=options.TabStopsEdit;
end;

Procedure TWebBrowserForm._RunScriptInternal;
begin
 RunPage(true,false,'');
end;

Procedure TWebBrowserForm._RunScriptExternal;
begin
 RunPage(false,false,'');
end;

Procedure TWebBrowserForm._RunScriptExtSec;
begin
 RunPage(false,true,'');
end;

Procedure TWebBrowserForm._OpenURLQuery(Const data : String);
begin
 RunPage(true,false,data)
end;


function TWebBrowserForm.MakeURL(ForceRunWithServer : boolean) : string;
const ReqMethod : array[0..2] of string = ('GET','POST','GET');
var
 SI : TScriptInfo;
 URLname,param,folder : string;
begin
  Si:=ActiveScriptInfo;
  if not assigned(si) then exit;
  LastEnv:=si.Query.GetZeroDelEnv(si.path,LastPost);

  if (options.RunWithServer) or (ForceRunWithServer) then
  begin
   FirstRun:=true;
   URLName:=PR_ActiveHTTPAddress;
  end

   else
  {Not run with server}
  begin
    if si.IsPerl then
    begin
      if options.StartPath=''
       then folder:=ExtractFilepath(si.path)
       else folder:=options.StartPath;

      URLName:='';

      param:=ActiveScriptInfo.Query.ActiveQuery[qmCMDLine];
      if trim(param)='' then
       param:='';

      RunningOffline:=true;
      application.ProcessMessages;

      GUI.Application:='';
      GUI.Command:='"'+options.PathToPerl+'" "'+si.path+'" '+param;  //extractshortpathname

      FileTemp:=ExtractFilePath(si.path)+'~OpOut.htm';
      GUI.Environment:=LastEnv;
      GUI.homedirectory:=folder;
      GUISentInput:=false;
      if ServerMdl.TimeOut<>0
       then GUINextTimeOut:=GetTickCount+options.RunTimeOut*1000
       else GUINextTimeOut:=0;
      GUI.Start;
    end
     else
    URLname:=Si.path;
  end;

  Result:=URLname;
end;

Function TWebBrowserForm.MakeHeaders(const URL : String) : String;
var
 i:integer;
 s,v:string;
begin
 result:='';
 with activescriptinfo.Query.EnvStatic do
 for i:=0 to count-1 do
   if StringStartsWith('HTTP_',Strings[i]) then
   begin
    s:=Strings[i];
    v:=ValueAt(i);
    if (trim(v)<>'') and (trim(s)<>'') then
    begin
     system.Delete(s,1,5);
     replaceC(s,'_','-');
     ProperCase(s);

     if (s='Host') and (options.RunRemHost) and (url<>'') then
      //nothing
     else
      begin
      s:=s+': '+valueat(i);
      result:=result+s+#13#10;
     end;
    end;
   end;

 with activescriptinfo.Query.EnvDynamic do
  for i:=0 to count-1 do
   if StringStartsWith('HTTP_',Strings[i]) then
   begin
    s:=Strings[i];
    v:=ValueAt(i);
    if (trim(v)<>'') and (trim(s)<>'') then
    begin
     system.Delete(s,1,5);
     replaceC(s,'_','-');
     ProperCase(s);
     s:=s+': '+valueat(i);
     result:=result+s+#13#10;
    end;
   end;
end;

procedure TWebBrowserForm.DeleteCookies(URL : String);
var
 i:integer;
 l : Cardinal;
 HL : THashList;
 N,v,buf : String;
begin
 l:=0;
 buf:='';
 if InternetGetCookie(pchar(URL),nil,nil,l) then
 begin
  setlength(buf,l);
  if InternetGetCookie(pchar(URL),nil,@buf[1],l) and (l>1)
   then setlength(buf,l-1)
   else setlength(buf,0);
 end;

 if length(buf)=0 then exit;

 HL:=THashList.Create(false,true,dupAccept);
 try
  hl.LineDel:=';';
  hl.HashDel:='=';
  hl.Text:=buf;
  v:='; expires=Fri, 01-Jan-1999 00:00:00 GMT';
  for i:=0 to hl.Count-1 do
  begin
   n:=Trim(hl.Strings[i]);
   InternetSetCookie(pchar(url),Pchar(n),pchar(v));
  end;
  InternetSetCookie(pchar(url),nil,pchar(v));
 finally
  HL.FREE;
 end;
end;

procedure TWebBrowserForm.AddCookies(URL : String);
var
 i:integer;
 HL : THashList;
 N,v : String;
begin
 if not (qmCookie in ActiveScriptInfo.query.Methods) then exit;
 if URL='' then
  URL:=options.Host;
 URL:=URLTOHost(URL);

 n:=URL;
 repeat
  DeleteCookies('http://'+n+'/');
  if countf(n,'.',1)>=2 then
   begin
    i:=pos('.',n);
    delete(n,1,i);
   end
  else
   break;
 until false;

 URL:='http://'+url+'/';
 n:=activescriptinfo.Query.ActiveQuery[qmCookie];
 if length(trim(n))=0 then exit;
 if pos('=',n)=0 then
  InternetSetCookie(pchar(url),nil,pchar(n))
 else
  begin
   HL:=THashList.Create(false,true,dupAccept);
   try
    hl.LineDel:=';';
    hl.HashDel:='=';
    hl.Text:=n;
    for i:=0 to hl.Count-1 do
    begin
     n:=hl.Strings[i];
     v:=hl.ValueAt(i);
     InternetSetCookie(pchar(url),Pchar(n),pchar(v));
    end;
   finally
    HL.free;
   end;
  end;
end;

procedure TWebBrowserForm.RunPage(Internal,Secondary : Boolean; GoURL : String);
var
 SI : TScriptInfo;
 URL,TargetFrame,Headers,Flags,Post: OleVariant;
 URLName,cook:string;
 Temp,TH : String;
begin
 if (internal) and (options.BrowserFocus) then
  show;

 FixHeaders:=GoURL<>'';
 DeleteFile(FileTemp);
 FileExternal:=not Internal;
 FileSecond:=Secondary;
 FileText:='';
 FileTemp:='';

 if (Internal) and (WebBrowser.Busy) then Exit;
 if (options.RunWithServer) or (GoURL<>'') then
  addcookies(GoURL);
 InternetSetOption(nil, INTERNET_OPTION_RESET_URLCACHE_SESSION ,nil,0);
 PR_QuickSave;
 Si:=ActiveScriptinfo;
 WebPrimary:=True;

 //set flag
 flags:=navNoHistory+navNoReadFromCache+navNoWriteToCache;
 if not internal then
  flags:=flags+navOpenInNewWindow;
 TargetFrame:=null;
 Post:=null;
 Headers:=null;

 //this also sets LastEnv and LastPos
 if GOurl=''
  then URLname:=makeURL(false)
  else URLname:=GoURL;

 if urlname='' then exit; //Out of here
 //Timeout occured or external browser will be lanched from
 //GUI.done

 if qmCookie in si.query.Methods
  then cook:=si.Query.GetEncoded(qmCookie)
  else cook:=#0;

 if secondary then
 begin
  if options.RunWithServer then
    ExecuteFile(options.SecondBrowser,URLName,'',SW_SHOWNORMAL)
  else
  begin
   if (qmPathInfo in si.query.Methods) and (si.Query.ActiveQuery[qmPathInfo]<>'') then
     URLName:=ExcludeTrailingAnySlash(URLName)+'/'+Si.query.GetEncoded(qmPathInfo)+'/';
   if (qmGet in si.query.Methods) and (si.Query.ActiveQuery[qmGet]<>'') then
     URLName:=URLName+'?'+Si.query.GetEncoded(qmGet);
   ExecuteFile(options.SecondBrowser,URLName,'',SW_SHOWNORMAL);
  end;
  exit;
 end;

 if (not options.RunWithServer) and (GoURL='') then
 //This is called only when a non perl page is called.
 begin
  if internal then
   Headers:=MakeHeaders('')+#0;
  //needed because of bug with Win ME and IE 5.5
  URL:=URLName;
  WebBrowser.Navigate2(URL,flags,targetframe,post,Headers);
  exit;
 end;

 if (MainServerMod.running) then
  ServerMdl.cookieOverride:=Cook;

 if (qmPathInfo in si.query.Methods) then
 begin
   if si.query.ActiveQuery[qmPathInfo]<>'' then
    URLName:=ExcludeTrailingAnySlash(URLName)+'/'+si.query.GetEncoded(qmPathInfo);
 end;

 if (qmGet in si.query.Methods) or (not si.isPerl) then
 begin
  if si.query.ActiveQuery[qmGet]<>'' then
    URLName:=URLName+'?'+Si.query.GetEncoded(qmGet);
 end;

 TH:=MakeHeaders(URLName);
 if not (qmPost in si.Query.Methods)
 then
  Headers:=TH+#0
 else
  begin
   post:=StringToOleVarArray(LastPost);
   if si.Query.Encoding=etURL then
    temp:='Content-Type: application/x-www-form-urlencoded'+ #10#13;
   if si.Query.Encoding=etStream then
    temp:='Content-Type: multipart/form-data; boundary='+OctetBoundary+#10#13;
   Headers:=temp+TH+#0;
  end;

 URL:=URLName;
 if not internal then
  Headers:=null;
  //needed because of bug with Win ME and IE 5.5

 WebBrowser.Navigate2(URL,flags,targetframe,post,Headers);
end;

procedure TWebBrowserForm.TimerTimer(Sender: TObject);
begin
 Timer.Enabled:=false;
 UpdateFromPrimary;
end;

procedure TWebBrowserForm.TermBrowser;
begin
 webbrowser.OnDocumentComplete:=nil;
 webbrowser.OnProgressChange:=nil;
 webbrowser.OnStatusTextChange:=nil;
 webbrowser.OnTitleChange:=nil;
 webbrowser.OnCommandStateChange:=nil;
end;

procedure TWebBrowserForm.ResetBrowser;
begin
 WebBrowser:=MainWebForm.WebBrowser;
 webbrowser.OnDocumentComplete:=WebBrowserDocumentComplete;
 webbrowser.OnProgressChange:=WebBrowserProgressChange;
 webbrowser.OnStatusTextChange:=WebBrowserStatusTextChange;
 webbrowser.OnTitleChange:=WebBrowserTitleChange;
 webbrowser.OnCommandStateChange:=WebBrowserCommandStateChange;
end;

procedure TWebBrowserForm.FormDestroy(Sender: TObject);
var i:integer;
begin
 DeleteFile(FileTemp);
 for i:=0 to MaxThreads-1 do
   memoThread[i].Memo.free;
 FormStorage.SaveFormPlacement;
 WebBrowserForm:=nil;
 {$IFDEF DEVELOP}
  SendDebug('Destroyed: '+name);
 {$ENDIF}
end;

procedure TWebBrowserForm.FormEndDock(Sender, Target: TObject; X,
  Y: Integer);
begin
 UpdateFromPrimary;
end;

procedure TWebBrowserForm.WebBrowserDocumentComplete(Sender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
 RefreshEnable:=true;
 if WebPrimary then
  UpdateFromPrimary;
 //Dont wait for the timer, do right away (it's fast)
 if (pagecontrol.ActivePage=InfoSheet) then
  MakeInfo;
 screen.cursor:=crDefault;
 resetWebFindDialog(webBrowser);
 ProxyNewLine:=true;
end;

procedure TWebBrowserForm.UpdateStatusBar;
var
 s:string;
const
 d = ' - ';
begin
 if StrStatus='Done'
  then s:=strProgress+d+strTitle+d+strStatus+strMS
  else s:=strProgress+d+strStatus+d+strTitle;
 replacesc(s,d+d,d,false);
 replacesc(s,d+d,d,false);
 deleteStartswith(d,s);
 deleteEndsWith(d,s);
 StatusBar.SimpleText:=s;
 StatusBar.hint:=s;
end;

procedure TWebBrowserForm.WebBrowserStatusTextChange(Sender: TObject;
  const Text: WideString);
begin
 StrStatus:=Text;
 UpdateStatusBar;
end;

procedure TWebBrowserForm.WebBrowserProgressChange(Sender: TObject;
  Progress, ProgressMax: Integer);
var
 i:integer;
begin
 if (progress=-1) or (progressmax=0) then
  begin
   StrProgress:='';
   UpdateStatusBar;
  end
 else
  begin
   i:=imid(0,100,round(Progress*100/ProgressMax));
   StrProgress:=IntToStr(i)+'%';
   StrMS:='';
   UpdateStatusBar;
  end;
end;

procedure TWebBrowserForm.WebBrowserTitleChange(Sender: TObject;
  const Text: WideString);
begin
 StrTitle:=WebBrowser.LocationURL;
 UpdateStatusBar;
end;

procedure TWebBrowserForm.UpdateFromPrimary;
var
 s:string;
 h:THandle;
begin
 if WebPrimary then
  begin
   s:=FIleURLToPath(WebBrowser.LocationURL);
   if (s<>'') and (fileexists(s))
    then memoutput.Lines.LoadFromFile(s)
    else memoutput.Lines.Text:=GetHTMLSource(WebBrowser);
  end
 else
  begin
   h:=GetForegroundWindow;
   try //2004-02 Luinrandir@columbus.rr.com.elf
    LoadString(WebBrowser,memoutput.Lines.Text);
   except end;
   SetForegroundWindow(h);
  end;
end;

procedure TWebBrowserForm.TimeToUpdate;
begin
 Timer.Enabled:=True;
end;

procedure TWebBrowserForm.btnSendClick(Sender: TObject);
var s:string;
begin
 s:=edSend.CurText;
 s:=TagEncode(s,true,false,true);
 PC_PerlInput(s);
 if RunningOffline then
  GUI.WriteLN(s);
 edSend.Text:='';
 edSend.CurText:='';
 btnSend.Down:=false;
end;

procedure TWebBrowserForm.PopupMenuPopup(Sender: TObject);
begin
 if assigned(ActiveEdit.Memo) then
  WrapLinesItems.Checked:=ActiveEdit.Memo.WordWrap;
end;

procedure TWebBrowserForm.WrapLinesItemsClick(Sender: TObject);
begin
 if assigned(ActiveEdit.Memo) then
 begin
  WrapLinesItems.Checked:=not WrapLinesItems.Checked;
  ActiveEdit.Memo.WordWrap:=WrapLinesItems.Checked;
 end;
end;

procedure TWebBrowserForm.IncreaseFontSizeItemClick(Sender: TObject);
begin
 if assigned(ActiveEdit.Memo) then
  ActiveEdit.Memo.Font.Size:=ActiveEdit.Memo.Font.Size+2;
end;

procedure TWebBrowserForm.DecreaseFontSizeItemClick(Sender: TObject);
begin
 if assigned(ActiveEdit.Memo) then
  ActiveEdit.Memo.Font.Size:=ActiveEdit.Memo.Font.Size-2;
end;

procedure TWebBrowserForm.CopySelected1Click(Sender: TObject);
begin
 if assigned(ActiveEdit.Memo) and (activeEdit.Memo.Focused) then
  activeEdit.Memo.CopyToClipboard;
end;

procedure TWebBrowserForm.Copyall1Click(Sender: TObject);
begin
 if assigned(ActiveEdit.Memo) and (activeEdit.Memo.Focused) then
  Clipboard.AsText:=activeEdit.Memo.Lines.Text;
end;

procedure TWebBrowserForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
var data : PData;
begin
 data:=VST.GetNodeData(Node);
 if (Assigned(data)) then
 begin
  if (column=0)
   then Text:=data.prop
   else Text:=data.Value;
 end;
end;

procedure TWebBrowserForm.MakeInfo;
var
 CExp,EExp : Boolean;
 Node,CookieNode : PVirtualNode;
 ColorNode,ElementsNode : PVirtualNode;
 i:integer;
 s:string;
begin
 {$IFDEF SPLASHFORM}
 if (assigned(SplashForm)) or (not visible) then exit;
 {$ENDIF}
 if assigned(ColorNode)
  then CExp:=VST.expanded[ColorNode]
  else CExp:=false;
 if assigned(ElementsNode)
  then EExp:=VST.expanded[ElementsNode]
  else EExp:=false;
 VST.Clear;
 with WebBrowser do
 begin
  ColorNode:=AddNode('Colors','');
  ElementsNode:=AddNode('Elements','');
  /// ADD COLORS

  try AddNode('AlinkColor',OleObject.document.alinkColor,colorNode);
  except on Exception do end;

  try AddNode('BgColor',OleObject.document.bgColor,colorNode);
  except on Exception do end;

  try AddNode('FgColor',OleObject.document.fgColor,colorNode);
  except on Exception do end;

  try AddNode('LinkColor',OleObject.document.linkColor,colorNode);
  except on Exception do end;

  try AddNode('VlinkColor',OleObject.document.vlinkColor,colorNode);
  except on Exception do end;


  /// ADD Elements

  try AddNode('Anchors',OleObject.document.anchors.Length,elementsNode);
  except on Exception do end;

  try AddNode('Applets',OleObject.document.applets.Length,elementsNode);
  except on Exception do end;

  try AddNode('Embeds',OleObject.document.embeds.Length,elementsNode);
  except on Exception do end;

  try AddNode('Links',OleObject.document.links.Length,elementsNode);
  except on Exception do end;

  try AddNode('Forms',OleObject.document.forms.Length,elementsNode);
  except on Exception do end;

  try AddNode('Frames',OleObject.document.frames.Length,elementsNode);
  except on Exception do end;

  try AddNode('Images',OleObject.document.images.Length,elementsNode);
  except on Exception do end;

  try AddNode('Scripts',OleObject.document.scripts.Length,elementsNode);
  except on Exception do end;

  try AddNode('StyleSheets',OleObject.document.styleSheets.Length,elementsNode);
  except on Exception do end;

  /// ADD IMAGES

  Node:=AddNOde('Images','W x H');
  try
  for i:=0 to OleObject.document.images.length-1 do
  begin
   AddNode(OleObject.document.images.item(i).src,
    inttostr(OleObject.document.images.item(i).width)+'x'+Inttostr(OleObject.document.images.item(i).Height),node);
  end;
  except on Exception do end;

  /// ADD Links

  Node:=AddNOde('Links','');
  try
  for i:=0 to OleObject.document.links.length-1 do
  begin
   AddNode(OleObject.document.links.item(i).href,
    OleObject.document.links.item(i).innerhtml,node);
  end;
  except on Exception do end;

  /// ADD GENERAL

  try AddNode('ActiveElement',OleObject.document.activeElement.tagname);
  except on Exception do end;

  try AddNode('ActiveName',OleObject.document.activeElement.name);
  except on Exception do end;

  try AddNode('Charset',OleObject.document.charset);
  except on Exception do end;

  try s:=OleObject.document.cookie;
  except on Exception do s:=''; end;

  AddNode('Cookie Raw',s);

  if s<>'' then
  begin
   CookieNode:=AddNode('Cookie Parsed','');
   UpdateCookie(CookieNode,s);
  end;

  try AddNode('DefaultCharset',OleObject.document.defaultCharset);
  except on Exception do end;

  try AddNode('Domain',OleObject.document.domain);
  except on Exception do end;

  try AddNode('FileCreatedDate',OleObject.document.fileCreatedDate);
  except on Exception do end;

  try AddNode('FileModifiedDate',OleObject.document.fileModifiedDate);
  except on Exception do end;

  try AddNode('FileSize',OleObject.document.fileSize);
  except on Exception do end;

  try AddNode('LastModified',OleObject.document.lastModified);
  except on Exception do end;

  try AddNode('Location',OleObject.document.location);
  except on Exception do end;

  try AddNode('Protocol',OleObject.document.protocol);
  except on Exception do end;

  try AddNode('MimeType',OleObject.document.mimeType);
  except on Exception do end;

  try AddNode('Referrer',OleObject.document.referrer);
  except on Exception do end;

  try AddNode('Title',OleObject.document.title);
  except on Exception do end;

  try AddNode('URL',OleObject.document.URL);
  except on Exception do end;

  try AddNode('URLUnencoded',OleObject.document.URLUnencoded);
  except on Exception do end;
 end;

 VST.Expanded[ColorNode]:=CExp;
 VST.Expanded[ElementsNode]:=EExp;
end;


Function TWebBrowserForm.AddNode(const prop, Value: string; Parent: Pointer = nil) : PVirtualNode;
var
 Data : PData;
begin
 if Parent=nil then
  Parent:=vst.rootnode;
 result:=VST.addChild(Parent);
 data:=VST.getNodeData(result);

 if Assigned(Data) then
 begin
  data.prop:=prop;
  data.Value:=Value;
 end;
end;

procedure TWebBrowserForm.PageControlChange(Sender: TObject);
const
 bv : array[boolean] of TdxBarItemVisible = (ivNever,ivAlways);
begin
 if (pagecontrol.ActivePage=InfoSheet) then MakeInfo;
 ServerGroup.Visible:=bv[pagecontrol.activepage=TalkSheet];
end;

Function TWebBrowserForm._WebBrowserData : String;
begin
 result:=GetHTMLSource(WebBrowser);
end;

Function TWebBrowserForm._GetWebCookie : String;
begin
 try
  result:=WebBrowser.OleObject.document.cookie;
 except on Exception do
  result:='';
 end;
end;

procedure TWebBrowserForm.FlashTimerTimer(Sender: TObject);
begin
 if not assigned(btnSend) then exit;
 btnSend.Down:=not btnSend.Down;
end;

procedure TWebBrowserForm.cxKeyPlusBrowserBackward(Sender: TObject;
  ShiftState: TShiftState);
begin
 if backenable then
  WebBrowser.GoBack;
end;

procedure TWebBrowserForm.cxKeyPlusBrowserForward(Sender: TObject;
  ShiftState: TShiftState);
begin
 if forwardenable then
  WebBrowser.GoForward
end;

procedure TWebBrowserForm.cxKeyPlusBrowserRefresh(Sender: TObject;
  ShiftState: TShiftState);
begin
 if refreshenable then
 WebBrowser.Refresh;
end;

procedure TWebBrowserForm.cxKeyPlusBrowserStop(Sender: TObject;
  ShiftState: TShiftState);
begin
 WebBrowser.Stop;
end;

procedure TWebBrowserForm.cxKeyPlusBrowserSearch(Sender: TObject;
  ShiftState: TShiftState);
begin
 webbrowser.GoSearch;
end;

procedure TWebBrowserForm.cxKeyPlusBrowserHome(Sender: TObject;
  ShiftState: TShiftState);
begin
 webbrowser.GoHome;
end;

procedure TWebBrowserForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 CloseWebFindDialog;
end;

procedure TWebBrowserForm.UpdateCookie(CNode : PVirtualNode; Const LastCookie : String);
var
 s,w : String;
 left,right : string;
 i,j : Integer;
 node,Snode : PVirtualNode;
 Data : PData;
begin
 I := 1;
 repeat
  W := Parse(LastCookie,';',i);
  if Length(W)=0 then W:='<null>';
  node:=VST.AddChild(CNode);
  data:=VST.GetNodeData(node);
  if ParseWithEqual(w,left,right) then
  begin
   data.prop:=trim(left);
   data.value:=trim(right);
   j:=1;
   repeat
     s:=Parse(right,'&',j);
     if Length(s)=0 then s:='<null>';
     snode:=VST.AddChild(node);
     data:=VST.GetNodeData(snode);
     data.prop:=trim(s);
   until (j<1) or (j>Length(right));
  end
   else
    data.prop:=trim(w);
 until (I<1) or (I>Length(lastcookie));
end;

procedure TWebBrowserForm.MakeThreads;
var
 count,Ch,i,h,hcounter : Integer;
begin
 count:=edThreads.IntCurValue;
 Ch:=TalkSheet.Height;

 h:=ch div (count );
 hcounter:=0;

 for i:=0 to maxthreads-1 do
 begin
  memoThread[i].Memo.visible:=i<count;
 end;

 for i:=0 to count-1 do
  with memoThread[i] do
  begin
   memo.width:=TalkSheet.ClientWidth-2;
   memo.Height:=h;
   memo.top:=hCounter;
   inc(hcounter,memo.Height);
  end;
end;

Function TWebBrowserForm.GetPos(Sender: TObject) : Integer;
var i:integer;
begin
 i:=0;
 while (i<edThreads.IntCurValue) and
       (MemoThread[i].LastSender<>sender) do inc(i);
 if i=edThreads.IntCurValue
  then
  begin
   Inc(lastUsed);
   if LastUsed>edThreads.IntCurValue-1 then LastUsed:=0;
   i:=LastUsed;
   MemoThread[i].LastSender:=Sender;
  end;
 result:=i;
end;

procedure TWebBrowserForm.OnRequest(Sender: TObject; const Status: string);
var i:integer;
begin
 i:=GetPos(sender);
 with MemoThread[i].Memo do
 begin
  if FirstRun then
   begin
    Lines.Add('* RUNNING *');
    WinLinePos:=lines.Count-1;
    Lines.Add('* REQUEST *');
    firstrun:=false;
   end
  else
   begin
    Lines.Add('* REQUEST *');
    WinLinePos:=lines.Count-1;
   end;
  WriteMemo(i,status);
  Lines.Add('* RESPONSE *');
  while lines.count>MaxLines do
   lines.Delete(0);
 end;
end;

procedure TWebBrowserForm.WriteMemo(i : Integer; const Str : String);
var
 j:integer;
 w:string;
begin
 j:=1;
 repeat
  W := Parse(Str,#10,j);
  w:=TrimRight(w);
  try
   MemoThread[i].Memo.Lines.Add(w);
  except end;  //MAILER-DAEMON@lyl-canbys.de.elf
 until (j<1) or (j>Length(Str));
end;

procedure TWebBrowserForm.OnResponse(Sender: TObject;
  const Status: string);
begin
 WriteMemo(GetPos(sender),status);
end;

procedure TWebBrowserForm.edThreadsChange(Sender: TObject);
begin
 edThreads.Value:=edThreads.CurValue;
 MakeThreads;
 ProxyMemoWrite:=0;
 ProxyToggle:=false;
end;

procedure TWebBrowserForm.TalkSheetResize(Sender: TObject);
begin
 MakeThreads;
end;

procedure TWebBrowserForm.btnClearClick(Sender: TObject);
var
 i:integer;
begin
 for i:=0 to MaxThreads-1 do
  memoThread[i].Memo.lines.clear;
end;

procedure TWebBrowserForm.OnProxyLog(Sender: TObject; const Log: String);
begin
 if proxyNewLine then
 with MemoThread[ProxyMemoWrite].Memo do
 begin
  lines.Add('*CLICK IN BROWSER*');
  WinLinePos:=Lines.Count-1;
  ProxyNewLine:=false;
 end;
 WriteMemo(ProxyMemoWrite,log);
 with MemoThread[ProxyMemoWrite].Memo do
  while lines.count>MaxLines do lines.Delete(0);

 if ProxyToggle then
 begin
  inc(ProxyMemoWrite);
  if ProxyMemoWrite>=edThreads.IntCurValue then
   ProxyMemoWrite:=0;
 end;
 ProxyToggle:=not ProxyToggle;
end;

procedure TWebBrowserForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Data : Pdata;
begin
 Data:=VST.GetNodeData(Node);
 with data^ do
 begin
  SetLength(prop,0);
  Setlength(Value,0);
 end;
end;

procedure TWebBrowserForm.GUIStart(Sender: TObject; const Command: String);
begin
 if not (FileExternal or FileSecond) then
  PR_NewSession;
 GUIStartScript:=GetTickCount;
 StrStatus:='Running script...';
 UpdateStatusBar;
end;

procedure TWebBrowserForm.GUIPrompt(Sender: TObject; const Line: String);
begin
 PR_PerlOutput(line);
end;

procedure TWebBrowserForm.GUILine(Sender: TObject; const Line: String);
begin
 if FileExternal or FileSecond
  then FileText:=Filetext+line+#13#10
  else PR_PerlOutput(line);
end;

procedure TWebBrowserForm.GUITimeOut(Sender: TObject; var Kill: Boolean);
begin
 if (not GUISentInput) then
  begin
   if (Lastpost<>'') then
    GUI.Write(LastPost);
   GUISentInput:=true;
  end
 else
  begin
   FlashTimer.Enabled:=true;
   if (GetTickCount>GuiNextTimeOut) and (GuiNextTimeOut<>0) then
   begin
    Kill:=MessageDlg('Timeout Occurred. Terminate Process?',
                      mtWarning, [mbYes, mbCancel], 0)=mryes;
    GUINextTimeOut:=GetTickCount+options.RunTimeOut*1000;
    if kill then
     btnSend.Down:=false;
   end;
  end;
end;

procedure TWebBrowserForm.GUIDone(Sender: TObject);
begin
 FlashTimer.Enabled:=false;
 btnSend.Down:=false;
 RunningOffline:=false;
 StrMs:=' '+inttostr(GetTickCount - GUIStartScript)+ 'ms';
 StrStatus:='Script finished after'+StrMs;
 UpdateStatusBar;
 if FileExternal or FileSecond then
 try
  saveStr(filetext,filetemp);
  if fileexists(filetemp) then
  begin
   if (FileExternal) and (not FileSecond) then
    ShellExecute(Application.Handle,'open',pchar('file://'+filetemp),NIL,NIL,SW_SHOWNORMAL);
   if FileSecond then
    ShellExecute(Application.Handle,'open',pchar(options.SecondBrowser),pchar('file://'+filetemp),NIL,SW_SHOWNORMAL);
  end;
 except on exception do end;
end;

procedure TWebBrowserForm.WebBrowserCommandStateChange(Sender: TObject;
  Command: Integer; Enable: WordBool);
begin
 if command=CSC_NAVIGATEFORWARD then
  ForwardEnable:=Enable;
 if command=CSC_NAVIGATEBACK then
  BackEnable:=Enable;
end;

procedure TWebBrowserForm.cbFilterChange(Sender: TObject);
begin
 ServerMdl.LogFilter:=cbFilter.Text;
 optGeneral.SmartStringsAdd(cbFilter.items,cbFilter.Text);
end;

procedure TWebBrowserForm.WMActivate(var msg: TWMActivate);
begin
 inherited;
end;

procedure TWebBrowserForm.AfterContainerShow(Sender: TObject);
begin
 Windows.SetParent(MainWebForm.Handle,WebSheet.Handle);
 MainWebForm.Top:=0;
 MainWebForm.Left:=0;
 MainWebForm.visible:=true;
end;

procedure TWebBrowserForm.WebSheetResize(Sender: TObject);
begin
 MainWebForm.Width:=WebSheet.ClientWidth;
 MainWebForm.Height:=WebSheet.ClientHeight;
end;

procedure TWebBrowserForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popUp.ItemLinks:=Barmanager.Bars[0].ItemLinks;
end;

procedure TWebBrowserForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtRight;
 Pix:=200;
 Index:=InNone;
end;

procedure TWebBrowserForm.PageControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 i:integer;
begin
 if Button = mbRight then
 begin
   i:=PageControl.GetTabIndex(x,y);
   pagecontrol.ActivePageIndex:=i;
   PageControlChange(nil);
   ButtonClick;
   exit;
 end;
end;


procedure TWebBrowserForm.edSendCurChange(Sender: TObject);
begin
 edSend.Text:=edSend.CurText;
end;                             

procedure TWebBrowserForm.VSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
 data : PData;
begin
 data:=VST.GetNodeData(Node);
 if (Assigned(data)) and (column=1)
  then HintText:=data.value;
 if (Assigned(data)) and (column=0)
  then HintText:=data.prop;
end;

end.

{
Run a DOS command and return immediately:
ShellExecute(Handle, 'open', PChar('command.com'), PChar('/c copy file1.txt file2.txt'), nil, SW_SHOW);


Run a DOS command and keep the DOS-window open ("stay in DOS"):
ShellExecute(Handle, 'open', PChar('command.com'), PChar('/k dir'), nil, SW_SHOW);