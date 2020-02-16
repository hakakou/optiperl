unit HakaHyper;

interface
uses sysutils,hyperstr,classes,hyperfrm,masks,hakageneral,graphics,windows;

Function GetPattern(const str,pattern:string; sl:TStrings ) : integer;
Function PathToFileUrl(Const path:string) : String;
Function FileURLToPath(Const path:string) : String;
function DeSQZ(const Bfr:AnsiString):AnsiString;
Function CreateBackupName(const path : string) : string;
Function GetHtmlTitleFromFile(const path:string) : string;
function FirstWord(const s:string; var start : integer) : string;
function FirstWordSkipSpaces(const s:string; var start : integer) : string;
function DeleteChars(const str,deltable : string) : string;
function GetHtmlTitle(const htmldata: string): string;
function IsFileinMask(Text : String; Const Mask:string) : Boolean;
function GetFileCRC32(const FileName : string) : Integer;
function GetFileCRC32Cardinal(const FileName : string) : Cardinal;
procedure GetComLines(files,switches : TStrings; swchar : char);

Procedure QuoteStr(Var s:string; quotechar: char);  overload;
Procedure UnQuoteStr(Var s:string; quotechar: char); overload;
Function CharsSameFromEnd(CheckChar : Char; Str : String) : Integer;
function ParseWithLit(const Source,Table:AnsiString; Literal : Char; var Index:Integer):AnsiString;
Function StringWithoutLiteral(const Str : String; Literal : Char) : String;
Procedure ReplaceLiteral(Var Str : String; Literal,Replace : Char);
function EncodeBad(const S : AnsiString; Const Bad :AnsiString):AnsiString;
//bad must include %
function DecodeBad(const S : AnsiString):AnsiString;
function EncodeIni(S:AnsiString):AnsiString;
function DecodeIni(S:AnsiString):AnsiString;
Procedure ChangeUnixEOLtoCustom(Var text : String; EOL : Integer);
Procedure ChangeEOLCustomtoUnix(Var text : String; EOL : Integer);
Procedure ParsePathStyleString(Const Str : String; Paths : TStrings);
Function LighterColor(Color : TColor; Amount, Min, Max : Integer) : TColor;
Function SafeComponentName(Const Str : String) : String;

Function EncodeBuf(const buf; size : Integer) : String;
Procedure DecodeBuf(const buf : string; var output);

Function DateTimeToEncodedStr(D : TDateTime) : String;
Function EncodedStrToDateTime(Str : String) : TDateTime;
Function SimpleToRegExpPattern(Const Pat : String; WholeWords : Boolean) : String;

implementation

Function SimpleToRegExpPattern(Const Pat : String; WholeWords : Boolean) : String;
var i:integer;
begin
 result:='';
 for i:=1 to length(pat) do
  if pat[i] in ['\','^','.','$','|','(',')','[',']','?','.','*','@']
   then result:=result+'\'+pat[i]
   else result:=result+pat[i];
 if (WholeWords) and (length(result)>0) then
 begin
  if IsAlphaNumChar(result[1]) or (result[1]='_') then
   result:='\b'+result;
  if IsAlphaNumChar(result[length(result)]) or (result[length(result)]='_') then
   result:=result+'\b';
 end;
end;

Function DateTimeToEncodedStr(D : TDateTime) : String;
begin
 setlength(result,sizeof(TDateTime));
 move(d,result[1],sizeof(TDateTime));
 result:=encodeStr(result);
end;

Function EncodedStrToDateTime(Str : String) : TDateTime;
begin
 try
  str:=decodeStr(str);
  if length(str)<>sizeof(TDateTime)
   then result:=0
   else move(str[1],result,sizeof(TDateTime));
 except
  result:=0;
 end;
end;


Function EncodeBuf(const buf; size : Integer) : String;
begin
 setlength(result,size);
 move(buf,result[1],size);
 result:=EncodeStr(result);
end;

Procedure DecodeBuf(const buf : string; var output);
var s:string;
begin
 s:=DecodeStr(buf);
 move(s[1],output,length(s));
end;

Function SafeComponentName(Const Str : String) : String;
var j:integer;
begin
 result:=lowercase(copy(str,1,12));
 for j:=1 to length(result) do
  if not (result[j] in ['a'..'z','A'..'Z','0'..'9']) then
    result[j]:='_';
 j:=-1;
 result:=result+'_'+inttostr(crc16(j,lowercase(str)));
end;

Function LighterColor(Color : TColor; Amount, Min, Max : Integer) : TColor;
var
 tmpRGB : TColorRef;
begin
 tmpRGB:=ColorToRGB(Color);
 result:=RGB(
  imid(min,GetRValue(tmpRGB)+Amount,Max),
  imid(min,GetGValue(tmpRGB)+Amount,Max),
  imid(min,GetBValue(tmpRGB)+Amount,Max));
end;

Procedure ParsePathStyleString(Const Str : String; Paths : TStrings);
var
 i:integer;
 w:string;
begin
 i:=1;
 repeat
  W := trim(Parse(str,';',i));
  if w<>'' then paths.Add(w);
 until (I<1) or (I>Length(str));
end;

Procedure ChangeUnixEOLtoCustom(Var text : String; EOL : Integer);
const
 EOLStr : array[0..2] of string = (#13#10,#10,#13);
begin
 if (EOL=-1) or (eol=1) then exit;
 replaceSC(text,#10,eolstr[eol],false);
end;

Procedure ChangeEOLCustomtoUnix(Var text : String; EOL : Integer);
const
 EOLStr : array[0..2] of string = (#13#10,#10,#13);
begin
 if (EOL=-1) or (eol=1) then exit;
 replaceSC(text,EolStr[eol],#10,false);
end;

function EncodeIni(S:AnsiString):AnsiString;
var
  I:Integer;
  C:Char;
begin
  Result:='';
  I:=Length(S);
  while I>0 do begin
    C:=S[I];
    if (c in [#0..#31,'[',']','=','%'])
     then Result:='%'+IntToHex(Ord(C),2)+Result
     else Result:=C+Result;
    Dec(I);
  end;
end;

function DecodeIni(S:AnsiString):AnsiString;
var
  I:Integer;
  C:Char;
begin
  Result:='';
  I:=1;
  while I<=Length(S) do begin
    C:=S[I];
    if C='%' then begin
      Inc(I);
      Result := Result + Char(HexToInt(Copy(S,I,2)));
      Inc(I);
    end
    else Result:=Result+C;
    Inc(I);
  end;
end;


function EncodeBad(const S : AnsiString; Const Bad :AnsiString):AnsiString;
var
  I:Integer;
  C:Char;
begin
  Result:='';
  I:=Length(S);
  while I>0 do begin
    C:=S[I];
    if ScanC(bad,c,1)=0
     then Result:=C+Result
     else Result:='%'+IntToHex(Ord(C),2)+Result;
    Dec(I);
  end;
end;

function DecodeBad(const S : AnsiString):AnsiString;
begin
 result:=DecodeIni(s);
end;

Function CharsSameFromEnd(CheckChar : Char; Str : String) : Integer;
var i:integer;
begin
 i:=length(str);
 result:=i;
 while (i>0) and (str[i]=CheckChar) do dec(i);
 result:=result-i;
end;

Procedure ReplaceLiteral(Var Str : String; Literal,Replace : Char);
var
 i,j : integer;
 lit : boolean;
begin
 lit:=false;
 for i:=1 to length(str) do
 begin
  if (str[i]=literal) and (not lit) then
   begin
    str[i]:=Replace;
    lit:=true;
   end
  else
   lit:=false;
 end;
end;

Function StringWithoutLiteral(const Str : String; Literal : Char) : String;
var
 i,j : integer;
 lit : boolean;
begin
 setlength(result,length(str));
 i:=1;
 j:=1;
 lit:=false;
 while (i<=length(str)) do
 begin
  if (str[i]=literal) and (not lit)
   then Lit:=true
   else lit:=false;

  if not lit then
  begin
   result[j]:=str[i];
   inc(j);
  end;
  inc(i);
 end;
 dec(j);
 setlength(result,j);
end;

function ParseWithLit(const Source,Table:AnsiString; Literal : Char; var Index:Integer):AnsiString;
var
  I,J,c:Integer;
begin
  J:=Length(Source)+1;
  if (Index>0) and (Index<J) and (Length(Table)>0) then begin
   result:='';
   c:=1;
   while (j>0) and (c=1) do
   begin
    I:=ScanT(Source,Table,Index);
    if I=0 then begin  //no delimiter before end of string
      I:=J;
      J:=0;            //return a zero Index
    end else J:=I+1;   //otherwise, return delimiter + 1
    Result:=result+Copy(Source,Index,I-Index);
    Index:=J;
    c:=CharsSameFromEnd(literal,result);
    if (odd(c)) and (i<=length(source)) then
     begin
      result[length(result)]:=source[i];
      J:=Length(Source)+1;
      c:=1;
     end
    else
     c:=0;
   end;

  end else begin
    Index:=0;    //return a null index
    Result:='';  //and a null string
  end;
end;


Procedure UnQuoteStr(Var s:string; quotechar: char);
begin
 if (length(s)>=2) and (s[1]=quotechar) and (s[length(s)]=quotechar)
  then s:=copy(s,2,length(s)-2);
 ReplaceSC(s,quotechar+quotechar,quotechar,false);
end;

Procedure QuoteStr(Var s:string; quotechar: char);
begin
 ReplaceSC(s,quotechar,quotechar+quotechar,false);
 insert(quotechar,s,1);
 s:=s+quotechar;
end;

function GetFileCRC32(const FileName : string) : Integer;
var s:string;
begin
 s:=loadstr(FileName);
 Result:=-1;
 Result:=CRC32(Result,s);
 Result:=not Result;
end;

function GetFileCRC32Cardinal(const FileName : string) : Cardinal;
begin
 result:=Cardinal(GetFileCRC32(FileName));
end;

Function FileURLToPath(Const path:string) : String;
begin
 if Pos('FILE://',uppercase(path))=1 then
 begin
  Result:=URLDecode(path);
  Delete(Result,1,7);
  if Length(Result)=0 then Exit;
  replaceC(Result,'/','\');
  if (length(result)>0) and (Result[1]='\') then Delete(Result,1,1);
 end
  else Result:='';
end;

Function CreateBackupName(const path : string) : string;
var p,s:integer;
begin
 Result:=path;
 if Length(path)=0 then Exit;

 p:=scanb(path,'.',0);
 s:=scanb(path,'\',0);
 if (p=0) or (p<s)
 then
  Result:=Result+'.~'
 else
  Insert('~',Result,p+1)
end;

function IsFileinMask(Text : String; Const Mask:string) : Boolean;
var
 i : Integer;
 w:string;
begin
 I := 1;
 Result:=False;
 if pos('.',text)=0 then
  text:=text+'.';
 repeat
  W := Parse(mask,';',I);
  if (Length(w)>0) and (matchesMask(Text,w)) then
  begin
   Result:=True;
   Exit;
  end;
 until (I<1) or (I>Length(mask));
end;

function GetHtmlTitle(const htmldata: string): string;
var
 l,p : integer;
begin
 p:=-1;
 l:=ScanW(htmldata,'<TITLE>@*</TITLE>',p);
 Result:=Copy(htmldata,p+7,l-15);
end;

procedure GetComLines(files,switches : TStrings; swchar : char);
var
 i:integer;
 p:string;
begin
 for i:=1 to paramcount do
 begin

  p:=ParamStr(i);
  if Length(p)>0 then
  begin
   if p[1]=swchar then
    begin
     if assigned(switches) then
      switches.Add(p)
    end
   else
    begin
     if assigned(files) then
      files.Add(p);
    end;
  end;

 end;
end;

function DeleteChars(const str,deltable : string) : string;
var i:integer;
begin
 Result:=str;
 for i:=1 to Length(deltable) do
  SetLength(result,DeleteC(Result,deltable[i]));
end;

function FirstWord(const s:string; var start : integer) : string;
var p:integer;
begin
 p:=start;
 while (length(s)>=p) and (s[p]<>' ') and (s[p]<>#9) do inc(p);
 if (p=0) or (p>=length(s))
  then Result:=Copy(s,start,Length(s))
  else Result:=CopyFromTo(s,start,p-1);
 start:=p+1;
end;

function FirstWordSkipSpaces(const s:string; var start : integer) : string;
var p:integer;
begin
 while (length(s)>=start) and (s[start] in [' ',#9]) do inc(start);
 result:=FirstWord(s,Start);
end;

function DeSQZ(const Bfr:AnsiString):AnsiString;
begin
 iniSQZ;
 result:=UnSQZ(bfr,0);
end;

Function GetPattern(const str,pattern:string; sl:TStrings ) : integer;
var l,p : Integer;
begin
 p:=1;
 result:=0;
 repeat
  l:=ScanW(str,pattern,p);
  if l<>0 then
  begin
   sl.Add(copy(str,p,l));
   inc(p);
   inc(result);
  end;
 until l=0;
end;

Function PathToFileUrl(Const path:string) : String;
var a:char;
begin
 result:=path;
 if length(result)<3 then exit;
 replacec(result,'\','/');
 a:=result[1];
 delete(result,1,1);
 replaceSC(result,':/','file://'+a+':/',false);
end;

Function GetHtmlTitleFromFile(const path:string) : string;
var pc:PChar;
l,p:integer;
f:file;
begin
 result:='';
 if not fileexists(path)
  then exit;
 Getmem(pc,3000);
 try
  assignfile(f,path);
  reset(f,1);
  try
   blockread(f,pc^,3000,l);
  finally
   closefile(f);
  end;
  p:=-1;
  l:=ScanW(string(pc),'<TITLE>*</TITLE>',p);
  if l>0 then
  begin
   result:=copy(string(pc),p+7,l-15);
   replacesc(result,#10,'',false);
   replacesc(result,#13,'',false);
  end;
 finally
  freemem(pc,3000);
 end;
end;

end.
