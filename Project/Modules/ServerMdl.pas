unit ServerMdl;  //Module

interface

uses
  SysUtils, Classes, Sockets, dialogs, inifiles, hyperstr, ScktComp,
  ConsoleIO, DIPcre,httpapp,hakageneral,hakafile,jclfileutils,hyperfrm,
  ExtCtrls,SyncObjs,Forms, FindFile,hakawin,windows,jvVCLUtils,OptOptions,
  hakahyper,hkClasses,OptProcs;

var
  ServerName : String;
  webroot : String;                       //must be set
  iniFile : String;                       //Needs Refresh
  TimeOut : Integer;
  ProgAssociations : String;              //Needs Refresh
  Rewrite : String;                       //Needs Refresh
  Alias : String;
  PutPerlDBOpt : Boolean = false;
  DoFeed : Boolean = false;
  CookieOverride : String = #0;
  LogFilter : String = '*.*';

type
  TStatusEvent = procedure(Sender : TObject; const Status : String) of object;

  TServerMod = class(TDataModule)
    ReqPcre: TDIPcre;
    HeadPcre: TDIPcre;
    GUI: TGUI2Console;
    FindFile: TFindFile;
    VarPcre: TDIPcre;
    SsiPCRE: TDIPcre;
    ResPCRE: TDIPcre;
    GHeadPcre: TDIPcre;
    CTPcre: TDIPcre;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure GUIDone(Sender: TObject);
    procedure GUILine(Sender: TObject; const Line: String);
    procedure GUITimeOut(Sender: TObject; var Kill: Boolean);
    procedure FindFileFound(Sender: TObject; Folder: String;
      var FileInfo: TSearchRec);
    procedure GUIPreTerminate(Sender: TObject);
    procedure GUIError(Sender: TObject; const Error: String);
    procedure GUIStart(Sender: TObject; const Command: String);
  private
    RewriteFrom,RewriteTo:TStringList;
    AWebRoot : String;
    Header,Body,Response : TStringList;
    SentPost,SentFirst:boolean;
    DidDirContents :Boolean;
    Socket: TCustomWinSocket;
    MimeExt, MimeTypes : TStringList;
    Aliases : THashList;
    CGIRunning : BOolean;
    CGIHeaderReached : Boolean;
    CGIHeader : TStringList;
    CGIKilled : boolean;
    CGIIsTextOutput : boolean;
    CGIContentLength : integer;
    CGIStartMS,CGINextMs : Cardinal;
    WasCGI : Boolean;
    Content : string;
    Method : String;
    URL,OriginalURL : String;
    HTTP : String;
    Query,PathInfo : String;
    KeepAliveTime : Integer;
    IndexList : TStringList;
    Associations : TStringList;
    RealFile : String;
    AssocProgs : TStringList;
    KeepAlive : Boolean;

    LastStatus : Integer;
    Function GetMimeType(const ext : String) : String;
    Procedure GetHeaderAndBody;
    Procedure MakeResponse;
    Procedure GetHeaderRequest;
    Procedure GetKeepAlive;
    Procedure ProcessURL;
    function GetHeader(const AHeader: String): String;
    Procedure OutStatus(status : Integer);
    procedure SendFile;
    procedure PreProcess;
    procedure GetQuery;
    function Environment: String;
    Procedure RSendText(const s:string; Log : Boolean);
    function isCGI: boolean;
    Procedure SendStatus(const Str : String);
    Procedure SendRequest(const Str : String);
    Procedure SendResponse(const Str : String);
    procedure CGIExplanation(const str: string; Header : Boolean);
    function CheckCgiHeader: BOolean;
    Procedure DoRewrite(var line : string; IsHeader: boolean);
    procedure CreateError(Error: Integer; const Str: String);
    procedure DoAliases;
  public
    OnServerStatus : TStatusEvent;
    OnClientRequest,OnServerResponse : TStatusEvent;
    Thread:TServerClientThread;
    procedure ServerClientRead(const S: String; ASocket: TCustomWinSocket);
    procedure Refresh;  //must be called
  end;

implementation
uses MainServerMdl;
{$R *.dfm}

procedure TServerMod.Refresh;
var
 ini : TINifile;
 slm : TStringlist;
 i,j,c:integer;
 s,mt,w:string;
begin
 ini:=TInifile.Create(inifile);
 //XARKA INIFILE
 ParsePeriodAndEqual(alias,aliases);

 //get index files
 IndexList.clear;
 s:=ini.ReadString('index','indexfiles','index.htm index.html index.shtml');
 s:=trim(s);
 c := 1;
 repeat
  W := Parse(S,' ',c);
  if Length(W)=0 then continue;
  IndexList.add(w);
 until (c<1) or (c>Length(S));

 //get mime types
 MimeTypes.clear;
 MimeExt.clear;
 slm:=TStringList.create;
 ini.ReadSectionValues('MimeTypes',slm);
 for i:=0 to slm.Count-1 do
 begin
  j:=pos('=',slm[i]);
  mt:=copy(slm[i],1,j-1);
  s:=trim(copy(slm[i],j+1,length(slm[i])));

  c := 1;
  repeat
   W := Parse(S,' ',c);
   if Length(W)=0 then continue;
   mimetypes.Add(mt);
   mimeext.AddObject(w,TObject(mimetypes.count-1));
  until (c<1) or (c>Length(S));

 end;

 //add associations
 AssocProgs.clear;
 Associations.clear;
 slm.Text:=ProgAssociations;
 for i:=0 to slm.Count-1 do
  if parsewithequal(slm[i],s,w) then
  begin
   j:=assocProgs.IndexOf(w);
   if j=-1 then
   begin
    assocProgs.Add(w);
    j:=assocprogs.Count-1;
   end;
   associations.AddObject(s,TObject(j));
 end;

 RewriteFrom.clear;
 RewriteTo.clear;
 slm.text:=Rewrite;
 for i:=0 to slm.Count-1 do
  if parseWithEqual(slm[i],s,w) then
  begin
   RewriteFrom.add(s);
   RewriteTo.Add(w);
  end;
 ini.free;
 slm.Free;
end;

procedure TServerMod.DataModuleCreate(Sender: TObject);
begin
 Aliases:=THashList.Create(false,false,dupIgnore);
 CGIHeader:=TStringList.Create;
 MimeTypes:=TStringList.Create;
 MimeExt:=TStringList.Create;
 mimeExt.Sorted:=true;
 Header:=TStringList.Create;
 Body:=TStringList.Create;
 Response:=TStringList.Create;
 IndexList:=TStringList.Create;
 IndexList.Sorted:=true;
 Associations:=TStringList.Create;
 Associations.Sorted:=true;
 Associations.Duplicates:=dupIgnore;
 AssocProgs:=TStringList.Create;
 RewriteFrom:=TStringList.create;
 RewriteTo:=TStringList.create;
end;

procedure TServerMod.DataModuleDestroy(Sender: TObject);
begin
 Aliases.free;
 MimeTypes.free;
 MimeExt.free;
 Header.free;
 Body.Free;
 Response.Free;
 AssocProgs.Free;
 Associations.free;
 IndexList.free;
 CGIHeader.free;
 RewriteFrom.free;
 RewriteTo.free;
end;

function TServerMod.GetMimeType(const ext: String): String;
var i:integer;
begin
 i:=mimeext.IndexOf(ext);
 if i<0
  then result:=''
  else result:=MimeTypes[integer(MimeExt.Objects[i])];
end;

procedure TServerMod.GetHeaderAndBody;
var i,j:integer;
begin
 j:=4;
 i:=pos(#13#10#13#10,content);
 if i=0 then
 begin
  j:=2;
  i:=pos(#10#10,content);
 end;
 if i=0 then
 begin
  j:=4;
  i:=pos(#10#13#10#13,content);
 end;
 if i=0 then i:=length(content);
 header.Text:=copy(content,1,i-1);
 content:=copyFromToEnd(content,i+j);
 body.Text:=content;
end;

Function TServerMod.GetHeader(const AHeader : String) : String;
var i:integer;
begin
 i:=0;
 headpcre.MatchPattern:=Aheader+':\s+(.+)$';
 while (I<header.count) do
 begin
  if headpcre.MatchStr(header[i])=2 then
  begin
   result:=headpcre.SubStr(1);
   exit;
  end;
  inc(i);
 end;
 result:='';
end;

procedure TServerMod.GetHeaderRequest;
var i:integer;
begin
 with ReqPcre do
  if MatchStr(header[0])=4 then
   begin
    method:=SubStr(1);
    url:=SubStr(2);
    OriginalURL:=URL;
    if stringstartswithcase('http://',url) then
    begin
     delete(url,1,7);
     i:=scanc(url,'/',1);
     if i<>0 then delete(url,1,i-1);
    end;
    http:=SubStr(3);
   end
  else
   begin
    method:='';
    url:='';
    http:='';
   end;
end;

procedure TServerMod.GetKeepAlive;
var c : Integer;
begin
 val(getheader('Keep-Alive'),keepaliveTime,c);
 if c<>0 then keepaliveTime:=0;
 keepAlive:=StringStartsWithCase('keep-alive',getheader('Connection'));
end;

Procedure TServerMod.GetQuery;
var i:integer;
begin
 i:=pos('?',URL);
 if i<>0 then
 begin
  query:=copy(URL,i+1,length(URL));
  SetLength(URL,i-1);
 end
  else query:='';
end;

procedure TServerMod.ProcessURL;
var
  j,i:integer;
  w:string;
begin

  //check for pathinfo
  j:=0;
  w:=url;

  For i:=0 To associations.Count-1 do
  begin
   j:=scanf(w,'.'+associations[i]+'/',-1);
   if (j<>0) then
   begin
    inc(j,length(associations[i]));
    if fileexists(excludeTrailingBackSlash(AWebRoot)+copy(w,1,j)) then break;
   end;
  end;

  if j<>0 then
  begin
   pathinfo:=copy(URL,j+1,length(URL));
   realFile:=copy(realfile,1,j+length(excludeTrailingBackSlash(AWebRoot)));
  end
   else pathinfo:='';


 //add index name

 if (Lastchar(realfile,'\')) and (directoryexists(realfile)) then
 begin
  j:=0;
  while (j<indexlist.Count) do
  begin
   if fileexists(realfile+indexlist[j]) then
   begin
    realfile:=realfile+indexlist[j];
    break;
   end;
   inc(j);
  end;

  if j=indexlist.Count then
  begin
   OutStatus(200);
   Response.Add('Content-Type: text/html');
   Response.Add('');
   sendResponse(Response.text);
   Response.Add('Directory listing of '+realfile+'<p>');
   sendResponse('<directory listing of '+realfile+'>');
   DidDirContents:=true;
   FindFile.Location:=realfile;
   FindFile.Execute;
  end;

 end;
end;

procedure TServerMod.OutStatus(status: Integer);
begin
 LastStatus:=Status;
 response.Add('HTTP/1.1 '+inttostr(status)+' '+StatusString(status));
end;

Procedure TServerMod.CreateError(Error : Integer; Const Str : String);
var s:string;
begin
 OutStatus(200);
 s:='<html><head><title>Error '+inttostr(error)+' '+StatusString(Error)+'</title></head><body>'+#10+
    '<table width="100%" border="1" cellspacing="1" cellpadding="5" bgcolor="#FFFFCC"><tr><td><font color="#000000">'+#10+
    '<b>OptiPerl Server: Error '+inttostr(error)+' '+StatusString(Error)+'</b><hr>'+#10+
    str+
    '</font></td></tr></table></body></html>'+#10#10;
 response.add('Content-Type: text/html');
 response.add('');
 response.Add(s);
end;

Procedure TServerMod.PreProcess;
begin
 if length(method)=0 then
 begin
  CreateError(400,'Only HEAD, GET and POST is supported.');
  SendResponse('<Only HEAD, GET and POST is supported>');
  exit;
 end;

 if length(url)=0 then
 begin
  CreateError(403,'No url!');
  SendResponse('<No URL!>');
  exit;
 end;

 GetQuery;

 if Pos('\', URl) > 0 then
 begin
  CreateError(403,'URL has a \ character.<br>Make sure you are running a file that is under the folder "'+AWebRoot+'" you have selected as webroot/alias or in one of it''s subfolders.');
  SendResponse('<URL has a \ character>');
  SendResponse('<make sure you are running a file that is under the folder '+AWebRoot+'>');
  Exit;
 end;

 if (Pos('..', url)>0) or
    (Pos(':',url)>0) or
    (Pos('\\',url)>0) then
 begin
  CreateError(403,'URL has .. or : characters.<br>Make sure you are running a file that is under the folder <b>'+AWebRoot+'</b> you have selected as webroot/alias or in one of it''s subfolders.');
  SendResponse('<URL has .. or : characters>');
  SendResponse('<make sure you are running a file that is under the folder '+AWebRoot+'>');
  Exit;
 end;

 realFile := excludeTrailingBackSlash(AWebRoot) + URL;
 ReplaceC(realfile,'/','\');

 if (directoryexists(realfile)) and (url[length(url)]<>'/') then
 begin
  outstatus(302);
  response.Add('Location: '+url+'/');
  exit;
 end;

 ProcessURL;

 if (not fileexists(realfile)) and
    (not Directoryexists(realfile)) then
 begin
  CreateError(404,'Cannot find the file <b>'+realfile+'</b><br><br>Make sure this file is under the folder <b>'+AWebRoot+'</b> you have selected as webroot/alias '+
                  'or in one of it''s subfolders.');
  SendResponse('<cannot find '+realfile+'>');
  exit;
 end;
end;

procedure TServerMod.DoAliases;
var
 i:integer;
 s:string;
begin
 AWebRoot:=WebRoot;
 replaceSC(AWebRoot,'/','\',false);
 for i:=0 to aliases.Count-1 do
  if FileStartsWith(aliases.Strings[i],url) then
  begin
   AWebRoot:=Aliases.ValueAt(i);
   replaceC(AWebroot,'/','\');
   s:=ExcludeTrailingAnySlash(aliases.Strings[i]);
   delete(url,1,length(s));
   break;
  end;
end;

procedure TServerMod.MakeResponse;
begin
 GetHeaderAndBody;
 GetHeaderRequest;
 GetKeepAlive;
 LastStatus:=0;
 DidDirContents:=false;
 response.Clear;
 DoAliases;
 Preprocess;
 if laststatus<>0 then
  begin
   RSendText(response.text,not DidDirContents);
  end
 else
  SendFile;
end;

procedure TServerMod.ServerClientRead(const s : String; ASocket: TCustomWinSocket);
begin
 SendStatus('Processing request...');
 content:=s;
 sendrequest(content);
 socket:=TCustomWinSocket(Asocket);
 Response.Clear;
 try
  makeresponse;
 except on exception do end;
 SendStatus('Running');
end;

const
  CGIServerVariables: array[0..28] of string = (
    'REQUEST_METHOD',
    'SERVER_PROTOCOL',
    'URL',
    'QUERY_STRING',
    'PATH_INFO',
    'PATH_TRANSLATED',
    'HTTP_CACHE_CONTROL',
    'HTTP_DATE',
    'HTTP_ACCEPT',
    'HTTP_FROM',
    'HTTP_HOST',
    'HTTP_IF_MODIFIED_SINCE',
    'HTTP_REFERER',
    'HTTP_USER_AGENT',
    'HTTP_CONTENT_ENCODING',
    'HTTP_CONTENT_TYPE',
    'HTTP_CONTENT_LENGTH',
    'HTTP_CONTENT_VERSION',
    'HTTP_DERIVED_FROM',
    'HTTP_EXPIRES',
    'HTTP_TITLE',
    'REMOTE_ADDR',
    'REMOTE_HOST',
    'SCRIPT_NAME',
    'SERVER_PORT',
    '',
    'HTTP_CONNECTION',
    'HTTP_COOKIE',
    'HTTP_AUTHORIZATION');


Function TServerMod.Environment : String;

  procedure Add(const Name, Value: string; AddifExistingOnly : boolean);
  begin
   if (value<>'') or (not AddifExistingOnly) then
    result := result + Name+'='+Value+#0
  end;

var
 temp : string;
 j:integer;
begin
  result:='';
  if PutPerlDBOpt then
  begin
   Add('PERLDB_OPTS',Options.perldbopts,true);
//   add('PERL5DB','BEGIN { require "perl5db.pl" }',true);
  end;

  Add('AUTH_TYPE', '',true);

  Add('COMSPEC',GetEnvVar('Comspec'),false);

  temp:=GetHeader('Content-length');
  val(temp,CGIContentLength,j);
  if j<>0 then CGIContentLength:=0;
  if CGIContentLength<>0 then
   Add('CONTENT_LENGTH',temp,true);

  Add('CONTENT_TYPE', GetHeader('Content-type'),true);

  temp := excludetrailingbackslash(AWebRoot);
  ReplaceC(temp,'\', '/');
  Add('DOCUMENT_ROOT', temp,false);

  Add('GATEWAY_INTERFACE', 'CGI/1.1',false);

  for j:=0 to Header.Count-1 do
  with GHeadPcre do
  begin
   if (MatchStr(header[j])=3) and
      (not StringStartsWithCase('server',SubStr(1))) and
      (not StringStartsWithCase('content',SubStr(1))) then
   begin
    temp:=SubStr(1);
    replaceC(temp,'-','_');
    temp:=uppercase(temp);
    if (CookieOverride<>#0) and (temp='COOKIE') then
     continue;
    add('HTTP_'+uppercase(temp),SubStr(2),true);
   end;
  end;

  if (CookieOverride<>#0) then
  begin
   add('HTTP_COOKIE',CookieOverride,true);
   SendResponse('<Cookie changed to: '+CookieOverride+'>');
   CookieOverride:=#0;
  end;

  Add('PATH',GetEnvVar('Path'),false);
  Add('PATH_INFO',pathinfo,true);

  if pathinfo<>'' then
  begin
   temp:=pathinfo;
   if temp[1] in ['/','\'] then delete(temp,1,1);
   temp:=realfile+'\'+temp;
   Add('PATH_TRANSLATED',temp,false);
  end;

  Add('QUERY_STRING', Query,false);

  Add('REMOTE_ADDR', thread.ClientSocket.RemoteAddress,false);
  Add('REMOTE_PORT', IntToStr(thread.ClientSocket.RemotePort),false);

  Add('REQUEST_METHOD', Method,false);

  add('REQUEST_URI',OriginalURL,false);
  //REQUEST_URI = /cgi-bin/graffiti.pl

  temp:=realfile;
  ReplaceC(temp,'\', '/');
  Add('SCRIPT_FILENAME',temp, false);

  temp:=URL;
  setlength(temp,length(temp)-length(pathinfo));
  Add('SCRIPT_NAME',temp,false);

  temp:=thread.ServerSocket.LocalHost;
  j:=thread.ServerSocket.LocalPort;

  add('SERVER_ADDR',thread.ServerSocket.LocalAddress,false);
  add('SERVER_ADMIN','you@your.address',false);
  add('SERVER_NAME',temp,false);
  add('SERVER_PORT',inttostr(j),false);
  Add('SERVER_PROTOCOL', HTTP,true);             //HTTP/1.1

  Add('SERVER_SIGNATURE','<ADDRESS>'+ServerName+' Server at '+temp+' Port '+inttostr(j)+'</ADDRESS>',false);
  // Apache/1.3.20 Server at localhost Port 80

  Add('SERVER_SOFTWARE',ServerName+' (Win32)',false);
  //Apache/1.3.20 (Win32) mod_perl/1.25

  temp:=GetEnvVar('SYSTEMROOT');
  if temp='' then temp:=ExcludeTrailingBackSlash(hyperstr.GetWinDir);
  Add('SYSTEMROOT',temp,false);

  temp:=GetEnvVar('WINDIR');
  if temp='' then temp:=ExcludeTrailingBackSlash(hyperstr.GetWinDir);
  Add('WINDIR',temp,false);

  ////////////
  Add('USER_NAME', '',true);
  Add('USER_PASSWORD', '',true);

  Result := result + #0;
end;


Function TServerMod.isCGI : boolean;
var
 prog,ext : String;
 i:integer;
 tms:Cardinal;
begin
 If CGIRunning then GUI.Stop;
 sleep(100);
 // SleepAndProcess(100);  Took about 24 hours to find this bug
 ext:=ExtractFileExt(realfile);
 delete(ext,1,1);
 i:=associations.IndexOf(ext);
 result:=i>=0;
 if not result then exit;

 prog:=AssocProgs[integer(Associations.Objects[i])];
 CGIHeader.Clear;
 CGIKilled:=false;
 CGIIsTextOutput:=false;
 CGIHeaderReached:=false;
 GUI.Command:='"'+prog+'" "'+realfile+'"';
 GUI.HomeDirectory:=ExtractFilePath(realfile);
 GUI.Environment:=Environment;
 CGIRunning:=True;
 SentPost:=false;
 SentFirst:=false;
 GUI.Start;
 tms:=GetTickCount+Timeout*1000;
 CGIStartMS:=GetTickCount;
 CGINextMS:=CGIStartMS;
 while CGIRunning do
 begin

  if (GetTickCount>tms) and (timeout<>0) then
  begin
   CGIKilled:=true;
   GUI.Stop;
   killAllExeNames(extractfilename(GUI.Application));
   CGIRunning:=false;
   SendStatus('Timeout occured.');
   SendResponse('<script terminated by server after '+
                inttostr(GetTickCount-CGIStartMS)+'ms>');
   CGIExplanation('This script was terminated because it ran more time then the maximum timeout limit you have set. If needed you can increase the timeout in the options dialog.<br>',not CGIHeaderReached);
   end;
  sleep(5);
 end;
 if not CGIKilled then
 begin
  if not SentFirst then
  begin
    if fileexists(Prog)
     then CGIExplanation('This script produced no output.',true)
     else CGIExplanation('Cannot find '+prog+' needed to run script. Please set-up the internal server from Options Dialog / Internal Server.',true);
   exit;
  end;
  if not CGIHeaderReached then
   CGIExplanation('This script produced output but did not send any headers. The first line of your script''s output should be something like<br>'+
   '<code>print "Content-type: text/html\n\n";</code><br>'+
   'The way this script output''s it''s header will not work on a real server!',true);
  sleep(2);
 end;
end;


Procedure TServerMod.SendFile;
var
 Fs : TFileStream;
 ext,mime : string;
 s:string;
begin
 if not fileexists(realfile) then
 begin
  OutStatus(200);
  RSendText('Could not find file '+realfile,true);
  RSendText(response.text,true);
  exit;
 end;

 WasCGI:=IsCGI;
 if not wascgi then
 begin
  OutStatus(200);
  // response.add('Date: Fri, 05 Apr 2002 21:29:28 GMT');
  response.Add('Server: '+ServerName);
  ext:=extractfileext(realfile);
  delete(ext,1,1);
  mime:=GetMimeType(ext);
  response.Add('Content-Type: '+mime);
  // response.add('Last-Modified: Sat, 23 Mar 2002 14:42:00 GMT');

//   response.Add('Connection: Keep-Alive');
   response.Add('Connection: close');

  if (scanf(mime,'text/html',-1)=0) then
   begin
    fs:=TFilestream.Create(realfile,fmOpenRead+fmShareDenyNone);

    response.Add('Content-Length: '+inttostr(fs.Size));
    response.Add('');
    RSendText(response.text,true);

    if uppercase(method)='HEAD' then exit;

    socket.SendStream(fs);
    SendResponse('<raw contents of file '+realfile+' sent to client>');
   end
  else
   begin
    s:=LoadStr(realfile);
    DoReWrite(s,false);

    response.Add('Content-Length: '+inttostr(length(s)));
    response.Add('');
    RSendText(response.text,true);

    if uppercase(method)='HEAD' then exit;

    RSendText(s,false);
    SendResponse('<contents of text file '+realfile+' sent to client>');
   end;
 end
end;


procedure TServerMod.GUIDone(Sender: TObject);
begin
 CGIRunning:=false;
 if not CGIKilled then
  SendResponse('<script finished normally after '+
                 inttostr(GetTickCount-CGIStartMS)+'ms>');
end;

procedure TServerMod.GUILine(Sender: TObject; const Line: String);
var
 s:string;
 i:integer;
begin
 if not sentfirst then sentfirst:=true;

 if (not CGIHeaderReached) then CGIHeader.Add(line);

 if (not CGIHeaderReached) and (line='') then
 begin
  CGIHeaderReached:=true;

  if CheckCGIHeader then
  begin
   if not StringStartsWith('HTTP/',CGIHeader[0]) then
   begin
    i:=0;
    while (I<CGIHeader.Count) and
          (not StringStartsWithCase('Status: ',CGIHeader[i])) do
     inc(i);
    if (i<CGIHeader.Count) and (resPcre.matchStr(CGIHEader[i])=3)
     then CGIHeader.Insert(
            0,trim('HTTP/1.1 '+respcre.SubStr(1)+' '+respcre.SubStr(2)))
     else CGIHeader.insert(0,'HTTP/1.1 200 OK');
     CGIHeader.Insert(1,'Connection: close');
   end;

   s:=CGIHeader.Text;
   CGIIsTextOutput:=scanf(s,'text/html',-1)<>0;
   DoReWrite(s,true);
   RSendText(s,true);
  end;
  SendResponse('<continuing running '+realfile+' and sending raw output>');
  exit;
 end;

 if CGIHeaderReached then
 begin
  s:=line+#13#10;
  if CGIIsTextOutput then DoReWrite(s,false);
  RSendText(s,false);
 end;
end;

Function  TServerMod.CheckCgiHeader : BOolean;

Function MakeExplanation : boolean;
var i,c : integer;
begin
 result:=false;
 if CGIHeader.Count=0 then
 begin
  CGIExplanation('This script did not sent any headers. The first line of your script''s output should be something like<br>'+
  '<code>print "Content-type: text/html\n\n";</code><br>'+
  'The way this script output''s it''s header will not work on a real server!',true);
  exit;
 end;

 i:=0;
 while (I<CGIHeader.Count) and
       (not StringStartsWithCase('Status: ',CGIHeader[i])) do
  inc(i);
 if i<CGIHeader.Count then
 begin
  if resPcre.MatchStr(CGIHeader[i])=3
   then c:=StrToInt(resPCRE.SubStr(1))
   else
    begin
     CGIExplanation('This script has a malformed status result. <br>'+
     '<code>'+cgiheader[0]+'</code><br>'+
     'The way this script output''s it''s header will not work on a real server!',true);
     exit;
    end;
 end
  else c:=200;

 if (CGIHeader.count>=2) and (StringStartsWithCase('Location:',cgiheader[0]))
    and (trim(cgiheader[CGIHeader.count-1])='') then
 begin
  CGIHeader.Insert(0,'HTTP/1.1 '+inttostr(302)+' '+StatusString(302));
  c:=302;
 end;

 if (c=200) then
 begin
  i:=0;
  while (i<CGIHeader.Count) do
  begin
   if CTPcre.MatchStr(cgiheader[i])=1 then break;
   inc(i);
  end;

  if i=CGIHeader.Count then
  begin
   CGIExplanation('This script does not output it''s mime type. It does not print something like:<br>'+
   '<code>print "Content-type: text/html\n\n";</code><br>'+
   'The way this script output''s it''s header will not work on a real server!',true);
   exit;
  end;
 end;

 if StringStartsWith('HTTP/',CGIHeader[0])
  then i:=1
  else i:=0;

 while (i<CGIHeader.Count-1) do
 begin
  if Gheadpcre.MatchStr(CGIHeader[i])<>3 then break;
  inc(i);
 end;

 if (i<CGIHeader.Count-1) then
 begin
  CGIExplanation('This script has strange output in it''s header.<br>'+
       'Did not like the line:<br><code>'+CGIHeader[i]+'</code>',false);
  exit;
 end;

 result:=true;
end;

begin
 result:=MakeExplanation;
end;

procedure TServerMod.CGIExplanation(const str : string; Header : Boolean);
var s,code:string;
begin
 if header
  then s:='HTTP/1.1 200 OK'+#10+'Content-Type: text/html'+#10#10
  else s:='';
 s:=s+'<table width="100%" border="1" cellspacing="1" cellpadding="5" bgcolor="#FFFFCC"><tr><td><font color="#000000">'+#10;
 s:=s+'<b>OptiPerl Server Warning</b><br>'+#10;
 s:=s+str+#10;
 if header then
 begin
  code:=HTMLEncode(CGIHeader.Text);
  replaceSC(code,#13#10,'<br>',false);
  replaceSC(code,#10,'<br>'#10,false);
  s:=s+'<i>Here is the complete header:</i><br><br><code>'+#10+code+'</code>';
 end;
 s:=s+'</font></td></tr></table>'+#10#10;
 RSendText(s,false);
end;

procedure TServerMod.GUITimeOut(Sender: TObject; var Kill: Boolean);
const
 buf = 128;
var
 s:string;
begin
 if SentPost then
 begin
  if ((GetTickCount-CGINextMS)>500) and (timeout<>0)  then
  begin
   SendResponse('<still waiting for script to terminate after '+
                 inttostr(GetTickCount-CGIStartMS)+'ms>');
   CGINextMs:=GetTickCount;
  end;
 end;

 if (method='POST') and (not SentPost) then
 begin
  s:=Content;
  SendResponse('<sending '+inttostr(length(s))+' bytes of POST data to STDIN>');
  GUI.WriteLN(s);
  if CGIContentLength>length(s) then
  begin
   SendResponse('<WARNING: The client reported that content length is '+
       IntToStr(CGIContentLength)+' but sent only '+inttostr(length(s))+'. Will pad the rest with spaces>');
   s:=StringOfChar(' ',CGIContentLength-length(s));
   GUI.Write(s);
  end;
  sentpost:=true;
 end;
end;

procedure TServerMod.FindFileFound(Sender: TObject; Folder: String;
  var FileInfo: TSearchRec);
begin
 Response.Add('<a href="'+fileinfo.Name+'">'+fileinfo.Name+'</a><br>');
end;

procedure TServerMod.RSendText(const s: string; Log : Boolean);
begin
 if (DoFeed) and (not log)
  then PR_PerlOutput(s)
  else socket.SendText(s);
 if log then
  SendResponse(s);
end;

procedure TServerMod.GUIPreTerminate(Sender: TObject);
begin
 GUI.WriteLN(#3);
 GUI.WriteLN(#3);
 GUI.WriteLN(#3);
 GUI.WriteLN(#3);
 GUI.WriteLN(#13#10);
 GUI.WriteLN(#3);
 GUI.WriteLN(#13#10);
 GUI.WriteLN(#3);
 GUI.WriteLN(#10);
end;

procedure TServerMod.GUIError(Sender: TObject; const Error: String);
begin
 killAllExeNames(extractfilename(GUI.Application));
 CGIRunning:=false;
end;

procedure TServerMod.GUIStart(Sender: TObject; const Command: String);
begin
 SendResponse('<Running '+realfile+'. Here are it''s headers:>');
end;

procedure TServerMod.SendResponse(const Str: String);
begin
 if (LogFilter='*.*') or (isFileInMask(realfile,logfilter)) then
  TServerThread(Thread).DoSync(str,OnServerResponse);
end;

procedure TServerMod.SendStatus(const Str: String);
begin
 TServerThread(Thread).DoSync(str,OnServerStatus);
end;

procedure TServerMod.SendRequest(const Str: String);
begin
 if (LogFilter='*.*') or (isFileInMask(realfile,logfilter)) then
  TServerThread(Thread).DoSync(str,OnClientRequest);
end;

procedure TServerMod.DoRewrite(var line: string; IsHeader: boolean);
var
 i,j:integer;
begin
 for i:=0 to RewriteFrom.Count-1 do
  begin
   j:=ReplaceSC(line,RewriteFrom[i],RewriteTo[i],true);
   if j>0 then SendResponse('<made '+inttostr(j)+' replacements using rule "'+rewriteFrom[i]+'->'+rewriteTo[i]+'"');
  end;
end;

end.