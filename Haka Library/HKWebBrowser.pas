unit HKWebBrowser;

interface
uses sysutils,OleCtrls, ActiveX,mshtml,classes,forms,Controls,
     registry,windows,inifiles,dialogs,hyperstr,variants,SHDocVw;

const
  HTMLID_FIND       = 1;
  HTMLID_VIEWSOURCE = 2;
  HTMLID_OPTIONS    = 3;

procedure PrintDoc(WB : TWebBrowser);  //IE 4 and above
procedure OldPrintDoc(WB : TWebBrowser); //for IE3 and above
Procedure InvokeCommand(WB : TWebBrowser; Command : Integer);
procedure FindDialog(WB : TWebBrowser);
procedure ViewSourceDialog(WB : TWebBrowser);
procedure OptionsDialog(WB : TWebBrowser);
procedure LoadString(WB : TWebBrowser; const Str : string);
Function LoadStream(WB : TWebBrowser; Stream : TStream) : HRESULT;
procedure LoadAboutHTMLString(WB : TWebBrowser; sHTML: String);
procedure LoadHTMLResource(WB : TWebBrowser; const res : String);
{Create a resource file (*.rc) with the following code and compile it with brcc32.exe:
 MYHTML 23 ".\html\myhtml.htm"
 MOREHTML 23 ".\html\morehtml.htm"
 Edit your project file so that it looks like this:
 $R *.RES
 $R HTML.RES //where html.rc was compiled into html.res}

function GetHtmlSource(WB : TWebBrowser) : string; //only for IE5+
Procedure GetHtmlFrameSource(WB : TWebBrowser; SL : TStrings);
function GetIEVersion : integer;
function GetIEVersionStr : String;
Function ExtractAddressFromUrl(const urlfile : String) : String;

{>WebBrowser1.OleObject.Document.all.item(0).outerHTML
>You might want to check in case the first tag isn't the <HTML> tag.
>if WebBrowser1.OleObject.Document.all.item(0).tagName = 'HTML' then
>or loop until you find it.
>With IE4, you're kinda limited to the <BODY> tag:
>WebBrowser1.OleObject.Document.body.outerHTML       }

Function ScrollToAnchor(WB : TWebBrowser; const anchor : string) : boolean;
procedure SaveHTMLSource(WB : TWebBrowser;  const FileName : string);
procedure NavigateWithPost(const stURL, stPostData, ExtraHeader: String;  URLEncoded : Boolean; vFlags : OleVariant; var wbWebBrowser: TWebBrowser);
//procedure NavigateWithPost2(const stURL, strPostData: String;  Flags : OleVariant; var wb: TWebBrowser);

Function WaitToFinish(WB : TWebBrowser; TimeOut : Cardinal) : Boolean;
//if false then timeout occured. Must shutdown manually.
Function GetTextFromUrl(const url,postdata : string; Wb: TWebBrowser) : string;

var
 WebBrowserPanic : Boolean = False;

implementation

Function GetTextFromUrl(const url,postdata : string; Wb: TWebBrowser) : string;
var
 flags : OleVariant;
Begin
 result:='';
 try
  flags:=2+4+8;
  if postdata=''
   then wb.Navigate(url,flags)
   else NavigateWithPost(url,postdata,'',true,flags,wb);
  waittofinish(wb,10);
  sleep(10);
  result:=GetHtmlSource(wb);
 except on exception do
 end;
end;

Function ExtractAddressFromUrl(const urlfile : String) : String;
var ini:TInifile;
begin
 result:='';
 if not fileexists(urlFile) then exit;
 ini:=TIniFile.create(urlfile);
 try
  result:=ini.readstring('InternetShortcut','URL','');
 finally
  ini.free;
 end;
end;

Function ScrollToAnchor(WB : TWebBrowser; const anchor : string) : boolean;
var
 ovAnchor: OleVariant;
begin
 result:=false;
 try
  ovAnchor:=trim(anchor);
  Wb.OleObject.Document.anchors.item(ovAnchor,0).scrollIntoView(TRUE);
  result:=true;
 except
  on exception do
 end;
end;

function GetIEVersionStr : String;
var
  Reg: TRegistry;
begin
 result:='';
 try
    Reg := TRegistry.Create;
    try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    Reg.Access:=KEY_READ;
      if Reg.OpenKey('\Software\Microsoft\Internet Explorer',false)
       then result:=Reg.ReadString('Version')
    finally
      Reg.CloseKey;
      Reg.Free;
    end;
 except
  on exception do
   result:='';
 end;
end;

function GetIEVersion : Integer;
var
  s:string;
  Reg: TRegistry;
  c : Integer;
begin
 result:=-1;
 s:=GetIEVersionStr;
 if length(s)=0 then exit;
 setlength(s,1);
 result:=StrToIntDef(s,-1);
end;

Procedure InvokeCommand(WB : TWebBrowser; Command : Integer);
// has errors
const
  CGID_WebBrowser: TGUID = '{ED016940-BD5B-11cf-BA4E-00C04FD70816}';
{var
  CmdTarget : IOleCommandTarget;
  vaIn, vaOut: OleVariant;
  PtrGUID: PGUID;}
begin
{  New(PtrGUID);
  PtrGUID^ := CGID_WebBrowser;
  if WB.Document <> nil then
    try
      WB.Document.QueryInterface(IOleCommandTarget, CmdTarget);
      if CmdTarget <> nil then
        try
          CmdTarget.Exec( PtrGUID, Command, 0, vaIn, vaOut);
        finally
          CmdTarget._Release;
        end;
    except
      // Nothing
    end;
  Dispose(PtrGUID);}
end;

Function WaitToFinish(WB : TWebBrowser; TimeOut : Cardinal) : Boolean;
var
 MaxClicks : Cardinal;
begin
 Result:=True;
 if not Assigned(wb) then Exit;
 try
  MaxClicks:=GetTickCount + TimeOut*1000;
  while (WB.readystate <> READYSTATE_COMPLETE) and (not WebBrowserPanic) do
  begin
   Forms.Application.ProcessMessages;

   if (Timeout>0) and (GetTickCount>MaxClicks) then
   begin
    if MessageDlg('Browser timeout occured. Continue?',
         mtInformation, [mbYes, mbCancel], 0) = mrYes
    then MaxClicks:=GetTickCount + TimeOut*1000
    else
     begin
      Result:=False;
      break;
     end;
   end;
  end;
 finally
  if webbrowserpanic then WB.Stop;
  screen.cursor:=crDefault;
  WebBrowserPanic:=False;
 end;
end;

function GetHtmlSource(WB : TWebBrowser) : string;
var i:integer;
begin
 if (not Assigned(wb)) or (wb.Document=nil) then Exit;
 i:=-1;
 repeat
  Inc(i);
  try
   if WB.OleObject.Document.all.item(i).tagName = 'HTML' then break;
  except
   on Exception do Exit;
  end;

 until False;
 Result:=WB.OleObject.Document.all.item(i).outerHTML;
end;

Procedure GetHtmlFrameSource(WB : TWebBrowser; SL : TStrings);
var
 iDoc       : HtmlDocument;
 iFrames    : iHTMLFramesCollection2;
 FrameCount ,
 loop       : integer;
 OleRef     : OLEVariant;
begin
 iDoc        := Wb.document as HtmlDocument;
 iFrames     := iDoc.frames as iHTMLFramesCollection2;
 FrameCount  := iFrames.length-1;
 Sl.Clear;
 if framecount<=0 then begin
  sl.Add(Wb.oleobject.document.all.item(0,0).OuterHtml);
 end;
 for loop := 0 to FrameCount do
     begin
       OleRef := Loop;
       sl.Add(iFrames.item( OleRef ).document.all.item(0,0).OuterHtml);
     end;
end;

{
procedure NavigateWithPost2(const stURL, strPostData: String;  Flags : OleVariant; var wb: TWebBrowser);
var
  Data: Pointer;
  URL, TargetFrameName, PostData, Headers: OleVariant;
begin
  PostData :=  VarArrayCreate([0, Length(strPostData) - 1], varByte);
  Data := VarArrayLock(PostData);
  try
    Move(strPostData[1], Data^, Length(strPostData));
  finally
    VarArrayUnlock(PostData);
  end;
  URL := stURL;
  TargetFrameName := EmptyParam;
  Headers := EmptyParam; // TWebBrowser will see that we are providing
                         // post data and then should automatically fill
                         // this Headers with appropriate value
  WB.Navigate2(URL, Flags, TargetFrameName, PostData, Headers);
end;
}

procedure NavigateWithPost(const stURL, stPostData, ExtraHeader: String; URLEncoded : Boolean; vFlags : OleVariant; var wbWebBrowser: TWebBrowser);
var
  vWebAddr, vPostData, vFrame, vHeaders: OleVariant;
  iLoop: Integer;
begin
 try
  {Are we posting data to this Url?}
  if Length(stPostData)> 0 then
  begin
    {Require this header information if there is stPostData.}
    if URLEncoded
     then vHeaders:= 'Content-Type: application/x-www-form-urlencoded'+ #10#13+ExtraHeader+#0
     else vHeaders:= 'Content-Type: application/octet-stream'+ #10#13+ExtraHeader+#0;
    {Set the variant type for the vPostData.}
    vPostData:= VarArrayCreate([0, Length(stPostData)-1], varByte);
    for iLoop := 0 to Length(stPostData)- 1 do    // Iterate
    begin
      vPostData[iLoop]:= Ord(stPostData[iLoop+ 1]);
    end;    // for
    {Final terminating Character.}
//    vPostData[Length(stPostData)]:= 0;
    {Set the type of Variant, cast}
    TVarData(vPostData).vType:= varArray;
  end;
  {And the other stuff.}
  vWebAddr:= stURL;
  {Make the call Rex.}
  wbWebBrowser.Navigate2(vWebAddr, vFlags, vFrame, vPostData, vHeaders);
 except
  on exception do
 end;
end;


procedure SaveHTMLSource(WB : TWebBrowser;  const FileName : string);
var
  HTMLDocument: IHTMLDocument2;
  PersistFile: IPersistFile;
begin
  if wb.Document=nil then Exit;
  HTMLDocument := WB.Document as IHTMLDocument2;
  PersistFile := HTMLDocument as IPersistFile;
  PersistFile.Save(StringToOleStr(filename),true);
  while HTMLDocument.readyState <> 'complete' do
    Application.ProcessMessages;
end;

procedure LoadAboutHTMLString(WB : TWebBrowser; sHTML: String);
var
  Flags, TargetFrameName, PostData, Headers: OleVariant;
begin
  WB.Navigate('about:' + sHTML, Flags, TargetFrameName, PostData, Headers)
end;

procedure LoadHTMLResource(WB : TWebBrowser; const res : String);
var
  Flags, TargetFrameName, PostData, Headers: OleVariant;
begin
  WB.Navigate('res://' + Application.ExeName + '/'+res, Flags, TargetFrameName, PostData, Headers)
end;

procedure LoadString(WB : TWebBrowser; const Str : string);
var
  v: Variant;
  HTMLDocument: IHTMLDocument2;
begin

  if wb.Document=nil then
  begin
   loadAboutHtmlString(wb,'blank');
   WaitToFinish(wb,5);
  end;

  try
   HTMLDocument := WB.Document as IHTMLDocument2;
  except
   on Exception do
   begin
    loadAboutHtmlString(wb,'blank');
    WaitToFinish(wb,5);
    HTMLDocument := WB.Document as IHTMLDocument2;
   end;
  end;
  v := VarArrayCreate([0, 0], varVariant);
  v[0] := Str; // Here's your HTML string
  HTMLDocument.Write(PSafeArray(TVarData(v).VArray));
  HTMLDocument.Close;
end;

Function LoadStream(WB : TWebBrowser; Stream : TStream) : HRESULT;
begin
  Stream.seek(0, 0);
  Result := (WB.Document as IPersistStreamInit).Load(TStreamAdapter.Create(Stream));
end;

procedure InvokeDialog(WB : TWebBrowser; HTMLID : Cardinal);
const
  CGID_WebBrowser: TGUID = '{ED016940-BD5B-11cf-BA4E-00C04FD70816}';
var
  CmdTarget : IOleCommandTarget;
  vaIn, vaOut: OleVariant;
  PtrGUID: PGUID;
begin
  New(PtrGUID);
  PtrGUID^ := CGID_WebBrowser;
  if WB.Document <> nil then
    try
      WB.Document.QueryInterface(IOleCommandTarget, CmdTarget);
      if CmdTarget <> nil then
        try
          CmdTarget.Exec( PtrGUID, HTMLID, 0, vaIn, vaOut);
        finally
          CmdTarget._Release;
        end;
    except
      // Nothing
    end;
  Dispose(PtrGUID);
end;

procedure FindDialog(WB : TWebBrowser);
begin
 InvokeDialog(WB,HTMLID_FIND);
end;

procedure ViewSourceDialog(WB : TWebBrowser);
begin
 InvokeDialog(WB,HTMLID_VIEWSOURCE);
end;

procedure OptionsDialog(WB : TWebBrowser);
begin
 InvokeDialog(WB,HTMLID_OPTIONS);
end;

procedure PrintDoc(WB : TWebBrowser);
var
  vaIn, vaOut: OleVariant;
begin
 WB.ControlInterface.ExecWB(OLECMDID_PRINT,
 OLECMDEXECOPT_DONTPROMPTUSER, vaIn, vaOut);
end;


procedure OldPrintDoc(WB : TWebBrowser);
var
  CmdTarget : IOleCommandTarget;
  vaIn, vaOut: OleVariant;
begin
  if WB.Document <> nil then
    try
      WB.Document.QueryInterface(IOleCommandTarget, CmdTarget);
      if CmdTarget <> nil then
        try
          CmdTarget.Exec( PGuid(nil), OLECMDID_PRINT, OLECMDEXECOPT_DONTPROMPTUSER, vaIn, vaOut);
        finally
          CmdTarget._Release;
        end;                                                                       
    except
      // Nothing
    end;
end;



end.
