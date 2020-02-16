{***************************************************************
 *
 * Unit Name: OptQuery
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptQuery;    //Unit
{$I REG.INC}

interface
uses classes,HakaFile,sysutils,HyperStr,DIPcre,httpapp,optOptions,optProcs,
     Hakageneral,hyperfrm,HKClasses,HKStreams,Messages,inifiles,hakahyper,
     HKiniFiles,JvVCLUtils;

type
       //          0     1         2         3         4
  TQueryTypes = (qmGet,qmPost,qmPathInfo,qmCookie,qmCMDLine,qmRes1,qmRes2,qmRes3);
  TQuerySet = Set of TQueryTypes;
  TEncodingTypes = (etUrl,etStream,etRaw);

  TQuery = Class
  private
   function OctetEncode(const Str: String): String;
   function URLEncode(const Str: String; SlashAlso : Boolean): String;
   Function RawEncode(const Str : String) : String;
   procedure AddExtVariables;
  public
   Methods : TQuerySet;
   IncExtVariables : Boolean;
   Encoding : TEncodingTypes;
   QueryLists : array[TQueryTypes] of TStringList;
   ActiveQuery : array[TQueryTypes] of String;
   EnvStatic,EnvDynamic: THashList;
   LastPost : String;
   Function IsNeeded : Boolean;
   Procedure SaveToINI(ini : TIniFile; Const Section : String);
   Procedure LoadFromIni(INI : TIniFile; Const Section : String);
   procedure OldLoadFromIni(INI: TIniFile);
   Constructor Create;
   Destructor Destroy; Override;
   Procedure MakeEnv(const Path : String);
   Procedure MakePreview(Strings : TStrings);
   Function GetEncoded(method : TQueryTypes) : string;
   function GetZeroDelEnv(const Path: string; out POST: String): String;
  end;

var
 ServerName : String = 'OptiPerl/4';

const
 QueryTypesStr : Array[TQueryTypes] of string =
  ('Get','Post','PathInfo','Cookie','CMDLine','Res1','Res2','Res3');
 OctetBoundary = '---------------------------7d23e316405c4';
 MaxQueryType = qmCMDLine;


Function TagEncode(Const Str : String; FileToo,HTTPEncodeToo,IsManual : Boolean) : String;

implementation
var
 FilePcre : TDIPcre;
const
 iniInformation = 'Information'; 

Function TagEncode(Const Str : String; FileToo,HTTPEncodeToo,IsManual : Boolean) : String;
var
 i:integer;
 b:boolean;
 f:string;
begin
{ test
wegwe=\\f<C:\\test\\num\\\=dgd\\\&sdgs\\zeta\\test.txt>&\\n\\\\n\\\\\\n\\\\\\\\n=\\f<C:\\test\\num\\\=dgd\\\&sdgs\\zeta\\test.txt>&\\\=\\\\\=\\\\\\\=\\\\\\\\\==\\f<C:\\test\\num\\\=dgd\\\&sdgs\\zeta\\test.txt>&\\y=weg\\
}
 b:=false;
 i:=1;
 result:='';
 while i<=length(str) do
 begin

  if str[i]='\' then
  begin
   if not b then
    begin
     b:=true;
     inc(i);
     if I>length(str) then
      result:=result+'\';
     continue;
    end
   else
    b:=false;
  end;

  if b then
   begin
    case str[i] of

      'n' : result:=result+#10;
      'r' : result:=result+#13;
      'z' : result:=result+#26;
      'd' : result:=result+#4;
      't' : result:=result+#9;
      '=','&' :
       if IsManual
        then result:=result+str[i]
        else result:=result+'\'+str[i];
      'f' :
       if (FIlePcre.matchStr(str,i)=2) then
        begin
         if FileToo then
          begin
           if fileexists(FilePcre.SubStr(1))
            then f:=LoadStr(FilePcre.SubStr(1))
            else f:='Cannot find file '+FilePcre.SubStr(1);
          end
         else
          begin
           f:=FilePcre.MatchedStr;
           f[1]:=#1;
          end;
         result:=result+f;
         inc(i,FilePcre.MatchedStrLength-1);
        end
       else
        result:=result+'\'+str[i];

      else result:=result+'\'+str[i];
    end; //case
    b:=false;
   end
  else
   result:=result+str[i];
  inc(i);
 end;

 If HTTPEncodeToo then
  result:=HTTPEncode(result);
end;

{ TQuery }

constructor TQuery.Create;
var i :TQueryTypes;
begin
 inherited Create;
 methods:=[qmGet];
 IncExtVariables:=True;
 for i:=low(i) to high(i) do
  queryLists[i]:=TStringList.create;
 EnvStatic:=THashList.Create(true,false,dupIgnore);
 EnvDynamic:=THashList.Create(true,false,dupIgnore);
 with EnvStatic do
 begin
  Add('GATEWAY_INTERFACE','CGI/1.1');
  Add('HTTP_ACCEPT','image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*');
  Add('HTTP_ACCEPT_ENCODING','gzip, deflate');
  Add('HTTP_ACCEPT_LANGUAGE','en');
  Add('HTTP_CONNECTION','Keep-Alive');
  Add('HTTP_USER_AGENT','Mozilla/4.0');
  Add('HTTP_HOST','127.0.0.1');
  Add('HTTP_REFERER','');
  Add('REMOTE_ADDR','');
  Add('REMOTE_PORT','');
  Add('SERVER_ADDR','127.0.0.1');
  Add('SERVER_ADMIN','you@your.address');
  Add('SERVER_NAME','localhost');
  Add('SERVER_PORT','80');
  Add('SERVER_PROTOCOL','HTTP/1.1');
  Add('SERVER_SIGNATURE','<ADDRESS>OptiPerl/4 Server at localhost Port 80</ADDRESS>');
  Add('SERVER_SOFTWARE','OptiPerl/4');
  Add('USER_NAME','');
  Add('USER_PASSWORD','');
 end;
end;

Procedure TQuery.AddExtVariables;
var
 i : integer;
 hl : THashList;
begin
 hl:=THashList.Create(true,false,dupIgnore);
 try
  hl.HashDel:='=';
  hl.LineDel:=#0;
  hl.LiteralChar:=#1;
  hl.Text:=GetEnvironment;
  for i:=0 to hl.Count-1 do
  begin
   if (EnvDynamic.IndexOf(hl[i])<0) and
      (EnvStatic.IndexOf(hl[i])<0) then
    EnvDynamic.Add(hl[i],hl.ValueAt(i));
  end;
 finally
  hl.Free;
 end;
end;

Procedure TQuery.MakeEnv(const Path : String);
var
 temp,tr: string;
begin
 EnvDynamic.Clear;
 with EnvDynamic do
 begin
  Add('COMSPEC',GetEnvVar('Comspec'));

  LastPost:='';
  if (qmPost in Methods) then
  begin
   LastPost:=GetEncoded(qmPost);
   Add('CONTENT_LENGTH',inttostr(length(lastPost)));
   if Encoding=etURL then
    Add('CONTENT_TYPE','application/x-www-form-urlencoded');
   if Encoding=etStream then
    Add('CONTENT_TYPE','multipart/form-data; boundary='+OctetBoundary);
  end;

  if PR_GetActiveServer=1
   then temp:=options.ExtServerRoot
   else temp:=options.RootDir;
  temp := excludetrailingbackslash(temp);
  ReplaceC(temp,'\', '/');
  Add('DOCUMENT_ROOT',temp);

  if qmCookie in Methods then
   Add('HTTP_COOKIE',(GetEncoded(qmCookie)));

  Add('PATH',GetEnvVar('Path'));

  if (qmPathInfo in Methods) then
  begin
   Add('PATH_INFO','/'+GetEncoded(qmPathInfo));
   temp:=IncludeTrailingBackSlash(path);
   ReplaceC(temp,'/', '\');
   Add('PATH_TRANSLATED',temp+GetEncoded(qmPathInfo)+'\');
  end;

  if (qmGet in Methods) and (ActiveQuery[qmGET]<>'') then
   Add('QUERY_STRING',GetEncoded(qmGet));

  if qmPost in Methods
   then Add('REQUEST_METHOD','POST')
   else Add('REQUEST_METHOD','GET');

  temp:=path;
  ReplaceC(temp,'\', '/');
  Add('SCRIPT_FILENAME',temp);
  tr:=temp;
  if pos(':',temp)=2 then
   system.delete(temp,1,2);
  Add('SCRIPT_NAME',temp);

  if (qmPathInfo in Methods) and (ActiveQuery[qmPathInfo]<>'') then
   tr:=tr+GetEncoded(qmPathInfo)+'/';

  if (qmGet in Methods) then
   tr:=tr+GetEncoded(qmGet);

  Add('REQUEST_URI',tr);

  temp:=GetEnvVar('SYSTEMROOT');
  if temp='' then
   temp:=ExcludeTrailingBackSlash(hyperstr.GetWinDir);
  Add('SYSTEMROOT',temp);

  temp:=GetEnvVar('WINDIR');
  if temp='' then
   temp:=ExcludeTrailingBackSlash(hyperstr.GetWinDir);
  Add('WINDIR',temp);

  if IncExtVariables then
   AddExtVariables;
 end;
end;

destructor TQuery.Destroy;
var i :TQueryTypes;
begin
 for i:=low(i) to high(i) do
  queryLists[i].free;
 EnvStatic.free;
 EnvDynamic.free;
 inherited Destroy;
end;

function TQuery.IsNeeded: Boolean;
var i :TQueryTypes;
begin
 result:=true;
 for i:=low(i) to high(i) do
 begin
  if length(ActiveQuery[i])>0 then exit;
  if queryLists[i].Count>0 then exit;
 end;
 result:=false;
end;

procedure TQuery.OldLoadFromIni(INI: TIniFile);
var
 i :TQueryTypes;
 sl : TStringList;
begin
 for i:=low(i) to MaxQueryType do
 begin
  ActiveQuery[i]:=DecodeIni(
   ini.readstring(QueryTypesStr[i],'Active',''));
  if ini.ReadBool(QueryTypesStr[i],'Enabled',false)
   then include(methods,i)
   else exclude(methods,i);
  ReadTStrings(ini,QueryTypesStr[i],'History',queryLists[i]);
 end;
 sl:=TStringList.Create;
 ReadTStrings(ini,'Environment','Env',sl);
 EnvStatic.SimpleText:=sl.Text;
 sl.free;
 Encoding:=TEncodingTypes(
  ini.ReadInteger(IniInformation,'Encoding',0));
 IncExtVariables:=ini.ReadBool(IniInformation,'IncExtVariables',false);
end;

procedure TQuery.LoadFromIni(INI: TIniFile; Const Section : String);
var
 i :TQueryTypes;
 sl : TStringList;
 s:string;
begin
 for i:=low(i) to MaxQueryType do
 begin
  ActiveQuery[i]:=DecodeIni(
   ini.readstring(Section,'_'+QueryTypesStr[i]+'_Active',''));
  if ini.ReadBool(Section,'_'+QueryTypesStr[i]+'_Enabled',false)
   then include(methods,i)
   else exclude(methods,i);
  ReadTStrings(ini,Section,'_'+QueryTypesStr[i]+'_History',queryLists[i]);
 end;
 sl:=TStringList.Create;
 ReadTStrings(ini,Section,'_Env',sl);
 s:=sl.Text;
 if length(s)>0 then
  EnvStatic.SimpleText:=s;
 sl.free;
 Encoding:=TEncodingTypes(
  ini.ReadInteger(Section,'_Encoding',0));
 IncExtVariables:=ini.ReadBool(Section,'_IncExtVariables',true);
end;

procedure TQuery.SaveToINI(ini: TIniFile; Const Section : String);
var
 i :TQueryTypes;
 sl : TStringList;
begin
 if not IsNeeded then exit;
 for i:=low(i) to MaxQueryType do
 begin
  ini.WriteString(Section,'_'+QueryTypesStr[i]+'_Active',EncodeIni(ActiveQuery[i]));
  ini.WriteBool(Section,'_'+QueryTypesStr[i]+'_Enabled',i in methods);
  WriteTStrings(ini,Section,'_'+QueryTypesStr[i]+'_History',queryLists[i]);
 end;
 sl:=TStringList.Create;
 sl.Text:=EnvStatic.SimpleText;
 WriteTStrings(ini,Section,'_Env',sl);
 sl.free;
 ini.WriteInteger(Section,'_Encoding',ord(Encoding));
 ini.WriteBool(Section,'_IncExtVariables',IncExtVariables);
end;

Function TQuery.GetZeroDelEnv(const Path : string; out POST : String) : String;
begin
 MakeEnv(path);
 post:=LastPost;
 result:=envStatic.SimpleText+envDynamic.SimpleText;
 replaceSC(result,#13#10,#0,false);
 result:=result+#0;
end;

Function TQuery.URLEncode(const Str : String; SlashAlso : Boolean) : String;
var
 HL : THashList;
 i : Integer;
 s1,s2 : String;
begin
 hl:=THashList.Create(false,false,dupAccept);
 hl.Text:=str;
 if not hl.lastparseWasGood then
 begin
  result:=TagEncode(str,true,true,true);
  if SlashAlso then
   replaceSC(result,'%2F','/',false);
  hl.Free;
  exit;
 end;
 result:='';
 for i:=0 to hl.Count-1 do
 begin
  s1:=tagEncode(hl.Strings[i],true,true,false);
  s2:=tagEncode(hl.ValueAt(i),true,true,false);
  result:=result+s1+'='+s2+'&';
 end;
 if hl.Count>0 then
  setLength(result,length(result)-1);
 hl.free;
end;

Function TQuery.RawEncode(const Str : String) : String;
begin
 result:=tagEncode(str,true,false,true);
end;

Function TQuery.OctetEncode(const Str : String) : String;
const
 del = #13#10+'--'+OctetBoundary;
var
 HL : THashList;
 i : Integer;
 s1,s2,temp : String;
begin
 hl:=THashList.Create(false,false,dupAccept);
 hl.Text:=str;
 if not hl.lastparseWasGood then
 begin
  result:='Cannot convert text to octet stream';
  hl.Free;
  exit;
 end;
 result:='';
 for i:=0 to hl.Count-1 do
 begin
  s1:=tagEncode(hl.Strings[i],true,true,false);
  s2:=tagEncode(hl.ValueAt(i),false,false,false);

  with FilePcre do
  if matchStr(s2)=2 then
   begin
    temp:=SubStr(1);
    if FileExists(temp)
     then s2:=LoadStr(temp)
     else s2:='Cannot find file '+temp;
    result:=result+del+#13#10+
    'Content-Disposition: form-data; name="'+s1+'"; filename="'+temp+'"'+#13#10+
    'Content-Type: application/octet-stream'+#13#10+#13#10+s2;
   end
  else
   begin
    result:=result+del+#13#10+
    'Content-Disposition: form-data; name="'+s1+'"'+#13#10+#13#10+s2;
   end;

 end;
 result:=result+del+'--'+#13#10;
 delete(result,1,2);
 hl.free;
end;
//
//Content-Type: multipart/form-data; boundary=---------------------------7d23e316405c4

{
-----------------------------7d229e181064e
Content-Disposition: form-data; name="filename"; filename="C:\unzip\optiperl6_exe\webroot\cgi-bin\cookie.cgi.op"
Content-Type: application/octet-stream


-----------------------------7d229e181064e
Content-Disposition: form-data; name="count"

count lines
-----------------------------7d229e181064e
Content-Disposition: form-data; name="count"

count words
-----------------------------7d229e181064e
Content-Disposition: form-data; name="count"

count characters
-----------------------------7d229e181064e
Content-Disposition: form-data; name="submit"

Process File
-----------------------------7d229e181064e
Content-Disposition: form-data; name=".cgifields"

count
-----------------------------7d229e181064e--
}

procedure TQuery.MakePreview(Strings: TStrings);
var
 i:TQueryTypes;
 sl : TStringList;
 j:integer;
begin
 Strings.Clear;
 sl:=TStringList.Create;
 for i:=low(i) to qmCookie do
 if i in Methods then
  begin
   sl.Clear;
   Strings.add('* '+QueryTypesStr[i]+' *');
   sl.Text:=GetEncoded(i);
   for j:=0 to sl.count-1 do
    strings.add(sl[j]);
   strings.Add('');
  end;
 sl.free;
end;

function TQuery.GetEncoded(method: TQueryTypes): string;
begin
 if (method=qmPost) and (encoding=etStream)
  then result:=OctetEncode(ActiveQuery[method])
 else
 if (method=qmPost) and (encoding=etRaw)
  then result:=RawEncode(ActiveQuery[method])
 else
 if (method=qmCookie)
  then result:=ActiveQuery[method]
 else
  result:=URLEncode(ActiveQuery[method],method=qmPathInfo)
end;


initialization
 FilePcre:=TDIPcre.Create(nil);
 FilePcre.MatchPattern:='(?:f|\x01)<([^>]+)>'
finalization
 FilePcre.free;
end.