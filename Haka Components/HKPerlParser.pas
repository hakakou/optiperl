unit HKPerlParser;

interface

uses
  Windows, Messages, SysUtils, Classes, dcsystem, DIPcre, hyperstr,
  dcParser,hakageneral;

type
  TIsDeclaration = Function(const Declaration : String) : Boolean of object;

  THKPerlParser = Class(TSimpleParser)
  private
    PodPCRE : TDIPCre;
    HDPcre : TDiPcre;
    FHTML : THTMLParser;
    LastWord : String;

    ResWords,FunWords,HDIgnore : TStringList;
    SubState,State : Integer;

    QLevel : Word;
    QQuote : Char;
    QInterpolate : Boolean;
    LCrc : Word;
    LInterpolate : boolean;
    RQuote : Char;
    RLevel : Word;
    RDone : Boolean;

    SQQuote : Char;
    SQInterpolate : Boolean;

    procedure DoPod(const StrData: String; var AColorData: String);
    procedure DoLongString(const StrData: String; var AColorData: String);
    procedure DoRegExp(const StrData: String; var AColorData: String;
      var Start: Integer; Multiline,IsRep : Boolean);
    procedure DoVariables(p: Integer; const Word: String;
      var AColorData: String);

    Procedure DoNormal(Const StrData: String; var AColorData: String; var Start : Integer);
    Procedure DoSimpleQuote(Const StrData: String; var AColorData: String; var Start : Integer);
    Procedure DoQQuote(Const StrData: String; var AColorData: String; var Start : Integer);
    Procedure DoComment(const StrData: String; var AColorData: String; var Start: Integer);
    Procedure DoWords(P : Integer; Const Word: String; var AColorData: String);
    procedure DoNumbers(P: Integer; const Word: String;
      var AColorData: String);
    procedure ProcessString(const StrData: String; var AColorData: String; Index,Count : Integer; Interpolate : Boolean);
    function IsHTMLLine(const S: String; Start: Integer): Boolean;
  protected
    procedure UpdateLinePos(Value : integer); override;
  public
    VarDiff : Boolean;
    constructor Create(AOwner : TComponent); override;
    Procedure LoadFiles(Const ResFile,FunFile,HDIgnoreFile : String);
    destructor Destroy; override;
    function ColorString(const StrData: String; InitState: Integer; var AColorData: String): Integer; override;
    procedure PrepareColorData(LinePos : integer; const s : string ; var ColorData : string); override;
  published
    property HTMLParser : THTMLParser read FHTML write FHTML;
  end;

const
  // ----------- parser state codes ---------------------
  psNormal = 0;

  psNewString = 7;
  psLongString = 1;
  psHTMLString = 9;

  psLongQString = 2;
  psNewQString = 6;
  psHTMLQString = 8;
  psNewQStringQuoteNext = 11;

  psNewSQString = 12;
  psSQString = 13;
  psSQHtml = 14;

  psLongRegExp = 3;
  psPOD = 4;
  psHtmlTag = 5;
  psRegReplace = 10;

  //Tokens
  tokWhitespace = 0;
  tokString = 1;
  tokComment = 2;
  tokIdentifier = 3;
  tokInteger = 4;
  tokFloat = 5;
  tokResWord = 6;
  tokDelimiters = 7;
  tokRegExp = 9;
  tokHtmlTag = 10;
  tokHtmlParam = 11;
  tokRegReplace = 26;
  tokDeclared = 27;
  tokFunWord = 28;
  tokPod = 29;
  tokPodHeaders = 30;
  tokVariables = 31;

type
  TPerlStorage = record
  case State : Byte of
   psNormal : ();
   psLongString : (LInterpolate: boolean; LCrc : Word);
   psLongQString : (QQuote : Char; QLevel : Word);
   psLongRegExp : (RQuote : Char; RLevel : Word);
   psSQString : (SQQuote : Char; SQInterpolate : Boolean);
  end;

procedure Register;

implementation

const
  strchar = '(<{[';
  endchar = ')>}]';

{ THKPerlParser }

Procedure THKPerlParser.DoRegExp(const StrData: String; var AColorData: String; var Start: Integer; Multiline,isRep : Boolean);
var
 p,p2,com : boolean;
 endquote : char;
 RealComment,NestCom,doNest,IsDel : boolean;
 i,j:integer;
begin
 p:=false;
 com:=false;
 IsDel:=false;
 NestCom:=false;

 i:=ScanC(strchar,Rquote,1);
 DoNest:=i>0;
 if DoNest
  then endquote:=endchar[i]
  else endquote:=Rquote;

 inc(start);
 while start<=length(strdata) do
 begin

  if not com then
  begin
   if strdata[start]='\' then
    p:=not p
   else

   if (strdata[start]=endquote) and (not p) then
   begin
     dec(RLevel);

     if RLevel=0 then
     begin
        if ((not ISRep) or ((isRep) and (RDone))) then
        begin
         AColorData[Start]:=chr(TokDelimiters);
         inc(start);
         while (strdata[start] in ['a'..'z','A'..'Z']) do inc(start);
         State:=psNormal;
         exit;
        end
       else
        begin
         RDone:=true;
         if DoNest
          then RLevel:=0
          else RLevel:=1;
         IsDel:=true;
        end;
     end;
   end
   else

   if ((DoNest) and (not p) and (strdata[start]=Rquote))
      or ((DoNest) and (not P) and RDone and (rlevel=0) and isrep and (ScanC(strchar,strdata[start],1)>0))
    then
     begin
      inc(RLevel);
      if RQuote<>strdata[start] then
      begin
       RQuote:=strdata[start];
       j:=scanC(STrChar,RQuote,1);
       endquote:=endchar[j]
      end;
     end
   else

   if (strdata[start]='#') and (not p) and (RQuote<>'#') then
   begin
     p2:=false;
     j:=start+1;
     while (j<=length(strdata)) do
     begin
      if strdata[j]='\' then p2:=not p2
      else
      if (strdata[j]=Endquote) and (not p2) then break
      else
      p2:=false;
      inc(j);
     end;
     RealComment:=j>length(StrData);
     if (RealComment) and (rdone) then
       NestCom:=true;
     if RealComment then
      com:=true
   end
   else
    p:=false;
  end;

  if not com then
  begin
   if (Not isRep) or ((isrep) and (not RDone))
    then i:=TokRegExp
    else i:=TokRegReplace;
  end
   else i:=TokComment;
  if (IsDel) or (DoNest and RDone and (rlevel=0) and (not com) ) or
  (
   DoNest and RDone and (rlevel=1) and (strdata[start]=RQuote) and
   ((start=1) or (strdata[start-1]<>'\'))
  )
  then
  begin
   IsDel:=false;
   if strdata[start] in [' ',#9]
    then i:=tokWhiteSpace
    else i:=TokDelimiters;
  end;
  if NestCom then i:=tokComment;
  AColorData[start]:=chr(i);
  inc(start);
 end;
end;

Function THKPerlParser.IsHTMLLine(const S : String; Start : Integer) : Boolean;
var i:integer;
begin
 i:=length(s);
 while (start<=i) and (s[start] in [' ',#9]) do
  inc(start);
 result:=(start<=i) and (s[start]='<');
 if result and (start<length(s)) and (s[start+1] in ['&','$']) then
  result:=false;
end;

Procedure THKPerlParser.DoQQuote(const StrData: String; var AColorData: String; var Start: Integer);
var
 i,j : integer;
 endquote : char;
 doNest : boolean;
 s,c:string;
 p : boolean;

 Procedure Draw;
 begin
   setlength(s,j-1);
   if s<>'' then
   begin
    if (state in [psnewQString,psNewQStringQuoteNext]) then
    begin
     if IsHTMLLine(s,1)
      then state:=psHTMLQString
      else State:=psLongQString;
     SubState:=0;
    end;

    if (state=psHTMLQString) and (assigned(FHTML)) then
     begin
      setlength(c,length(s));
      Fillchar(c[1],length(c),0);
      SubState:=FHTML.ColorString(s,substate,c);
      move(c[1],AColordata[start-j+1],length(c));
     end
    else
     processString(strdata,acolordata,start-j+1,length(s),QInterpolate);
   end;
 end;

begin
 p:=false;
 i:=ScanC(strchar,Qquote,1);
 DoNest:=i>0;
 if DoNest
  then endquote:=endchar[i]
  else endquote:=Qquote;

 inc(start);
 setlength(s,length(strdata));
 j:=1;

 while start<=length(strdata) do
 begin

  if (strdata[start]='\') and (qquote<>'\') then
   p:=not p

  else
  if (not p) and DoNest and (strdata[start]=Qquote)  then inc(QLevel)

  else
  if (not p) and (strdata[start]=endquote) then dec(QLevel)

  else
   p:=false;

  if QLevel=0 then
  begin
   QLevel:=1;
   Draw;
   inc(start);
   State:=psNormal;
   exit;
  end;

  s[j]:=strdata[start];
  inc(j);
  inc(start);

 end;
 Draw;
end;

Procedure THKPerlParser.DoSimpleQuote(Const StrData: String; var AColorData: String; var Start : Integer);

 Procedure Draw(St,En : Integer);
 var s,c : string;
 begin
  if st>en then exit;
  s:=copyFromTo(strdata,st,en);
  if (state=psNewSQString) then
  begin
   if IsHTMLLine(s,1)
    then state:=psSQHTML
    else State:=psSQString;
   SubState:=0;
  end;

  if (state=psSQHtml) and (assigned(FHTML)) then
   begin
    setlength(c,length(s));
    Fillchar(c[1],length(c),0);
    SubState:=FHTML.ColorString(s,substate,c);
    move(c[1],AColordata[st],length(c));
   end
  else
   processString(strdata,acolordata,st,length(s),SQInterpolate);
 end;

var
 p : boolean;
 i :integer;
begin
 p:=false;
 inc(start);
 i:=start;
 while start<=length(strdata) do
 begin
  if strdata[start]='\' then
   p:=not p
  else

  if (not p) and (strdata[start]=SQquote) then
   begin
    Draw(i,start-1);
    inc(start);
    State:=psNormal;
    exit;
   end

  else
   p:=false;

  inc(start);
 end;
 draw(i,start-1);
end;

Procedure THKPerlParser.DoNumbers(P : Integer; Const Word: String; var AColorData: String);
var i:integer;
begin
 if Scanc(word,'.',1)=0
  then i:=tokInteger
  else i:=tokFloat;
 if (length(word)>2) and (upcase(word[2]) in ['X','B']) then
  i:=tokFloat;
 FillChar(AColorData[p-length(word)],length(word),i)
end;

Procedure THKPerlParser.DoVariables(p: Integer; Const Word: String; var AColorData: String);
begin
  FillChar(AColorData[p-length(word)],length(word),tokVariables);
end;

Procedure THKPerlParser.DoWords(P : Integer; Const Word: String; var AColorData: String);
begin
 if ResWords.IndexOf(word)>=0 then
  FillChar(AColorData[p-length(word)],length(word),tokResWord)
 else
 if FunWords.IndexOf(word)>=0 then
  FillChar(AColorData[p-length(word)],length(word),tokFunWord);
end;

Procedure THKPerlParser.DoComment(Const StrData: String; var AColorData: String; var Start : Integer);
begin
 fillchar(AColorData[start],length(strdata)-start+1,tokComment);
 start:=length(strdata)+1;
end;

Procedure THKPerlParser.DoPod(Const StrData: String; var AColorData: String);
var i:integer;
begin
 with podPcre do
  if (MatchStr(StrData)=2) then
   begin
    i:=tokPodHeaders;
    if (AnsiCompareText(substr(1),'cut')=0) then
     State:=psNormal;
   end
  else
   i:=tokPod;
 fillchar(aColorData[1],Length(AColorData),i);
end;

Procedure THKPerlParser.ProcessString(Const StrData: String; var AColorData: String; Index,Count : Integer; Interpolate : Boolean);
var
 i,j : integer;
 c:byte;
 Next,Previous : Char;
 p,force,opened:boolean;
begin
 if (not interpolate) or (not VarDiff) then
 begin
  Fillchar(acolordata[index],count,tokString);
  exit;
 end;
 j:=1;
 c:=tokString;
 i:=index;
 p:=false;
 force:=false;
 opened:=false;
 Previous:=#0;

 while (j<=count) do
 begin
  if j<count
   then next:=strdata[i+1]
   else next:=#0;

  if strdata[i]='\' then
   begin
    p:=not p;
    c:=TokString;
   end

  else
   if (not p) and (Strdata[i] in ['$','%','@']) then
   begin
    c:=tokDelimiters;
    force:=false;
    Opened:=false;
   end

  else
  if (strdata[i]=':') and (next=':') then
   begin
    c:=tokVariables;
    AColorData[i]:=chr(c);
    force:=false;
    p:=false;
    inc(i);
    inc(j);
   end

  else
  if (force) or (not (strdata[i] in ['A'..'Z','a'..'z','0'..'9','_','[','{',']','}','''']))
  then
   begin
    c:=tokString;
    p:=false;
    Opened:=false;
    force:=false;
   end

  else
   begin
    force:=strdata[i] in [']','}'];
    if (Force) and (Not Opened) then
     begin
      c:=tokString
     end
    else
     begin
      if (not opened) and (strdata[i] in ['[','{']) then
      begin
       if (c=tokDelimiters) and (strdata[i] = '[')  //for variable $[ 
        then force:=true
        else opened:=true;
      end;
      if c=tokDelimiters then
       c:=tokVariables;
     end;
    p:=false;
   end;

  Previous:=StrData[i];
  AColorData[i]:=chr(c);
  inc(i);
  inc(j);
 end;
end;

Procedure THKPerlParser.DoLongString(Const StrData: String; var AColorData: String);
begin
 if (crc16($FFFF,strdata)=LCrc)
  then State:=psNormal
  else
 begin
  if state=psNewString then
  begin
   if IsHTMLLine(strdata,1)
    then state:=psHTMLString
    else State:=psLongString;
   SubState:=0;
  end;
  if (state=psHTMLString) and (assigned(FHTML))
   then SubState:=FHTML.ColorString(strdata,substate,acolordata)
   else ProcessString(strdata,AColorData,1,length(strdata),LInterpolate);
 end;
end;

Function PerlIsNum(const w : string) : Boolean;
var i:integer;
begin
 if (length(w)>2) and (w[1]='0') then
 begin
  if w[2] in ['b','B'] then
  begin
   for i:=3 to length(w) do
    if not (w[i] in ['0'..'1']) then
    begin
     result:=false;
     exit;
    end;
   result:=true;
   exit;
  end;

  if w[2] in ['x','X'] then
  begin
   for i:=3 to length(w) do
    if not (w[i] in ['0'..'9','a'..'f','A'..'F']) then
    begin
     result:=false;
     exit;
    end;
   result:=true;
   exit;
  end;

 end;

 for i:=1 to length(w) do
  if not (w[i] in ['0'..'9']) then
  begin
   result:=false;
   exit;
  end;

 result:=true;
end;

Procedure THKPerlParser.DoNormal(Const StrData: String; var AColorData: String; var Start : Integer);
var
 i,j : integer;
 w : string;
 LastRepChar : Char;
 NextHD : Boolean;

  Function IncToSpace(Increase : Integer = 0) : Boolean;
  begin
   inc(i,increase);
   while (i<=length(strData)) and (strData[i] in [' ',#9]) do inc(i);
   result:=i<=length(strdata);
  end;

  Procedure DoWordsAndVars;
  var goWord : Boolean;
  begin
     if (w<>'') then
     begin
      if Perlisnum(w) then
      begin
       while (i<=length(strdata)) and (strdata[i] in ['0'..'9','.']) do
       begin
        w:=w+strdata[i];
        inc(i);
       end;
       DoNumbers(i,w,acolordata);
       exit;
      end;

      j:=i-length(w)-1;
      while (j>=1) and (strdata[j] in [' ',#9]) do dec(j);

      GoWord:=(j>=1) and (strdata[j] in ['&','@','$','%','`','*']);
      if (GoWord) and (j>=2) and (strdata[j]='&') and (strdata[j-1]='&') then
       GoWord:=false;

      if not GoWord then
       DoWords(i,w,acolordata)
      else
       begin
         while (i<=length(strdata)) and
               (strdata[i] in ['A'..'Z','a'..'z','0'..'9','_',':']) do
         begin
          w:=w+strdata[i];
          inc(i);
         end;
         DoVariables(i,w,acolordata);
        end;
     end;
  end;

  function CheckForReplace : boolean;
  var q:integer;
  begin
   q:=i-length(w)-1;
   while (q>=1) and (strdata[q] in [' ',#9]) do dec(q);
   result:=(q<1) or (not (strdata[q] in ['@','$','%','^','&','*','/','a'..'z','A'..'Z','''','-','"','>']));
   if q>=1
    then LastRepChar:=strdata[q]
    else LastRepChar:=#0;
   if (not result) and (q>1) and (
      (lastword='if') or (lastword='while') or
      (lastword='grep') or (lastword='unless')
      )
    then
     result:=true;
  end;

  function CheckForQQ : boolean;
  var q:integer;
  begin
   q:=i-length(w)-1;
   while (q>=1) and (strdata[q] in [' ',#9]) do dec(q);
   result:=(q<1) or (not (strdata[q] in ['@','$','%','^','&','*']));
  end;

  function CheckForComment : boolean;
  var q:integer;
  begin
   q:=i-length(w)-1;
   while (q>=1) and (strdata[q] in [' ',#9]) do dec(q);
   result:=(q<1) or (not (strdata[q] in ['@','$','%']));
  end;

  function CheckQuestRegExp(quote : char) : boolean;
  var
   q:integer;
   s:string;
  begin
   q:=i-length(w)-1;
   s:=lastword;
   if s='' then s:=w;
   while (q>=1) and (strdata[q] in [' ',#9]) do dec(q);
   if q>=1
    then result:=(
     (strdata[q] in ['(','=','{','!','&','|','.']) or
     (s='split') or (s='if') or (s='or') or (s='and') or (s='while') or (s='unless') or
     (s='ge') or (s='eq') or (s='gt') or (s='le') or (s='lt') or (s='ne') or (s='xor')
     ) and (scanC(strdata,quote,i+1)<>0)
    else result:=(quote='/'); //check this
  end;

  function CheckForBeforeLongString : boolean;
  var j:integer;
  begin
   j:=i-2;
   while (j>=1) and (strdata[j] in [' ',#9]) do
    dec(j);
   result:=(j<1) or (
    (not (ord(AColorData[j]) in [tokVariables,tokInteger,tokFloat])) and
    (strdata[j] in [',','=','>','A'..'Z','a'..'z','0'..'9','_','(',':','?','.'])
    );
  end;

  Function checkForTidle :  Boolean;
  var j:integer;
  begin
   j:=i-1;
   while (j>=1) and (strdata[j] in [' ',#9]) do
    dec(j);
   result:=(j>=1) and (not (strdata[j] in ['$','@','&','*','%','<']))
  end;

  function CheckForGoodQuote : boolean;
  var q:integer;
  begin
   q:=i-1;

   if (q>=1) and (strdata[i] in ['''','`']) and (strdata[q] in ['A'..'Z','a'..'z','0'..'9','_']) then
   begin
    result:=false;
    exit;
   end;

   while (q>=1) and (strdata[q] in [' ',#9]) do
    dec(q);
   result:=(q<1) or (not (strdata[q] in ['$','@','%','*','&','\']));
   if (not result) and (q>=2) and (strdata[q-1] = strdata[q]) then
    result:=true;
  end;

  Function DoQQ : BOolean;
  begin
    result:=((w='q') or (w='qq') or (w='qw') or (w='qx')) and CheckForQQ;
    if result then
     begin
      if not inctospace
       then begin State:=psNewQStringQuoteNext; QQuote:=#0; exit; end
       else State:=psNewQString;
      QLevel:=1;
      QQuote:=strdata[i];
      QInterpolate:=(w='qq');
      DoQQuote(strdata,acolordata,i);
     end;
  end;

  Function DoRE : BOolean;
  begin
   result:=((w='m') or (w='s') or (w='tr') or (w='qr') or (w='y')) And (CheckForReplace) and (inctospace) and
           (not (strdata[i] in [' ',#9]));
   if result then
   begin
      if not incToSpace then exit;

      //if it looks like { s =>
      if (strdata[i]='=') then
      begin
       j:=i+1;
       while (j<=length(strdata)) and (strdata[j] in [' ',#9]) do inc(j);
       if (j<=length(strdata)) and (strdata[j]='>') then exit;
      end;

      if (strdata[i] in ['}',')','>',']']) then exit;

      RQuote:=StrData[i];
      AColorData[i]:=chr(tokDelimiters);
      RLevel:=1;
      if (w='m') or (w='qr') then
       begin
        State:=psLongRegExp;
        DoRegExp(strdata,acolordata,i,false,false);
       if state=psNormal then dec(i);
       end
      else
       begin
        State:=psRegReplace;
        RDone:=false;
        DoRegExp(strdata,acolordata,i,false,True);
       end;
   end
  end;

begin
  NextHD:=false;
  if (start=1) and (podPcre.Matchstr(strdata)=2) then
  begin
   state:=psPod;
   DoPod(strdata,AColorData);
   exit;
  end;

  w:='';
  i:=start;
  while (i<=length(StrData)) do
  begin
   if strdata[i] in ['A'..'Z','a'..'z','0'..'9','_']
   then
     w:=w+strdata[i]
   else
    begin

     DoWordsAndVars;
     if i>length(strdata) then exit;

     if DoQQ then
     else

     if DoRE then
     else

     if (strdata[i]='~') and (checkForTidle) then
     begin
      if (incToSpace(1)) and
         (not (strdata[i] in [' ','A'..'Z','a'..'z','0'..'9','_','$','@','#','%','*',#9])) then
      begin
       if not incToSpace then exit;
       RQuote:=StrData[i];
       RLevel:=1;
       State:=psLongRegExp;
       DoRegExp(strdata,acolordata,i,false,false);
      end
       else
        dec(i);
     end

     else
     if (strdata[i] in ['''','"','`']) and (CheckForGoodQuote) then
     begin
      SQQuote:=strdata[i];
      SQInterpolate:=strdata[i] in ['"','`'];
      State:=psNewSQString;
      DoSimpleQuote(strdata,acolordata,i);
     end

     else
     if i<=length(strdata) then
     begin

      if (strdata[i]='#') and (checkforcomment) then DoComment(Strdata,acolordata,i)

      else
      if ( (strdata[i]='?') and (checkQuestRegExp('?')) ) or
         ( (strdata[i]='/') and (checkQuestRegExp('/')) ) then
      begin
       RQuote:=strdata[i];
       RLevel:=1;
       State:=psLongRegExp;
       DoRegExp(strdata,acolordata,i,false,false);
      end
      else

      if (strdata[i]='<') and (i>1) and
         (strdata[i-1]='<') and CheckForBeforeLongString then
      begin
       j:=HDPcre.MatchStr(strdata,i-1)-1;
       if (j>=1) and (HDIgnore.IndexOf(HdPcre.SubStr(j))<0) then
       begin
        State:=psNewString;
        SubState:=0;
        LCrc:=Crc16($FFFF,PerlToRealTokens(HdPcre.SubStr(j),nil));
        LInterpolate:=j<>1;
        i:=hdpcre.SubStrAfterLastCharPos(j)+1;
        NextHD:=true;
       end;
      end;

      if (i>length(strdata)) or (not (strdata[i] in [' ',#9]))
       then LastWord:=''
       else LastWord:=w;
     end;

     w:='';
    end;
   inc(i);
  end;
 DoWordsAndVars;
 DoQQ;
 if (nextHD) and (state=psNormal) then
  State:=psNewString;
end;

function THKPerlParser.ColorString(const StrData: String;
  InitState: Integer; var AColorData: String): Integer;
var
 i:integer;
 s:string;
 st : TPerlStorage absolute Initstate;
 Rt : TPerlStorage absolute result;
begin
 i:=1;
 State:=(st.State and $F0) shr 4;
 SubState:=st.State and $0F;
 case State of
  psNormal : DoNormal(StrData,AColorData,i);

  psLongQString,psNewQString,psHTMLQString :
  begin
   i:=0;
   QQuote:=chr(ord(st.QQuote) and $7F);
   QInterpolate:=ord(St.QQuote) and $80 = $80;
   QLevel:=st.QLevel;
   DoQQuote(strdata,acolordata,i);
   DoNormal(StrData,AColorData,i);
  end;

  psNewQStringQuoteNext :
  begin
   QQuote:=chr(ord(st.QQuote) and $7F);
   QInterpolate:=ord(St.QQuote) and $80 = $80;
   QLevel:=1;
   i:=0;
   if QQUote=#0 then
    begin
     s:=trim(StrData);
     if s<>'' then
     begin
      QQuote:=s[1];
      i:=ScanC(strdata,QQuote,1);
      DoQQuote(strdata,acolordata,i);
      DoNormal(StrData,AColorData,i);
     end;
    end
   else
    begin
      DoQQuote(strdata,acolordata,i);
      DoNormal(StrData,AColorData,i);
    end;
  end;

  psPod : DoPod(strdata,acolordata);

  psLongString,psNewString,psHTMLString :
  begin
   LCrc:=st.LCrc;
   LInterpolate:=st.LInterpolate;
   DoLongString(strdata,acolordata);
  end;

  psLongRegExp :
  begin
   i:=0;
   RQuote:=st.RQuote;
   RLevel:=st.RLevel;
   DoRegExp(strdata,acOLORData,i,true,false);
   DoNormal(StrData,AColorData,i);
  end;

  psRegReplace :
  begin
   i:=0;
   RQuote:=st.RQuote;
   if st.RLevel>=$8000 then
    begin
     RDone:=true;
     Dec(st.RLevel,$8000);
    end
   else
    RDone:=false;

   RLevel:=st.RLevel;
   DoRegExp(strdata,acOLORData,i,true,true);
   DoNormal(StrData,AColorData,i);
  end;

  psSQString,psNewSQString,psSQHTML :
  begin
   i:=0;
   SQQuote:=st.SQQuote;
   SQInterpolate:=st.SQInterpolate;
   DoSimpleQuote(strdata,acolordata,i);
   DoNormal(StrData,AColorData,i);
  end;

 end; //case;

 rt.State:=state shl 4 + substate;
 case state of
  psLongQString,psNewQString,psHTMLQString,psNewQStringQuoteNext :
   begin
    rt.QQuote:=QQuote; rt.QLevel:=QLevel;
    if QInterpolate then rt.QQuote:=chr(ord(rt.QQuote)+$80);
   end;
  psLongString,psNewString,psHTMLString : begin
   rt.LCrc:=LCrc;
   rt.LInterpolate:=LInterpolate;
  end;
  psLongRegExp :
   begin
    rt.RLevel:=RLevel; rt.RQuote:=rquote;
   end;
  psRegReplace :
   begin
    rt.RLevel:=RLevel;
    if RDone then inc(rt.RLevel,$8000);
    rt.RQuote:=RQuote;
   end;
  psSQString,psNewSQString,psSQHTML :
   begin
    rt.SQQuote:=SQQUote;
    rt.SQInterpolate:=SQInterpolate;
   end;
 end;
end;

constructor THKPerlParser.Create(AOwner: TComponent);
begin
 inherited create(aowner);
 VarDiff:=true;
 PodPCRE:=TDIPcre.Create(nil);
 PodPcre.MatchPattern:='^=(\w+)';
 HDPcre:=TDIPcre.Create(nil);
 HDPCre.CompileOptions:=HDPCre.CompileOptions + [coUnGreedy];
 HDPCre.MatchPattern:='<<(?:\s*''(.+[^\\])''|\s*"(.+[^\\])"|\s*`(.+[^\\])`|(\w+)[^\w])';
 HDIgnore:=TStringList.Create;
 HDIgnore.Sorted:=true;
 HDIgnore.Duplicates:=dupIgnore;
 HDIgnore.CaseSensitive:=true;
 ResWords:=TStringList.Create;
 ResWords.Sorted:=true;
 ResWords.Duplicates:=dupIgnore;
 ResWords.CaseSensitive:=true;
 FunWords:=TStringList.Create;
 FunWords.Sorted:=true;
 FunWords.Duplicates:=dupIgnore;
 FunWords.CaseSensitive:=true;
end;

destructor THKPerlParser.Destroy;
begin
 ResWords.Free;
 FunWords.Free;
 HDIgnore.free;
 PodPCre.Free;
 HDPcre.Free;
 inherited;
end;

procedure THKPerlParser.LoadFiles(const ResFile, FunFile,HDIgnoreFile: string);
begin
 if fileexists(ResFile) then
  ResWords.LoadFromFile(ResFile);
 if Fileexists(FunFile) then
  FunWords.LoadFromFile(FunFile);
 if Fileexists(HDIgnoreFile) then
  HDIgnore.LoadFromFile(HDIgnoreFile);
end;

procedure THKPerlParser.PrepareColorData(LinePos: integer; const s: string;
  var ColorData: string);
var i:integer;
begin
 SetLength(colordata,length(s));
 for i:=1 to length(s) do
 begin
  if s[i] in [' ',#9] then colordata[i]:=chr(tokWhiteSpace)
  else
  if s[i] in ['A'..'Z','a'..'z','_','0'..'9'] then
   colordata[i]:=chr(tokIdentifier)
  else
   colordata[i]:=chr(tokDelimiters);
 end;
end;

procedure THKPerlParser.UpdateLinePos(Value: integer);
begin
 inherited;
end;

procedure Register;
begin
  RegisterComponents('haka', [THKPerlParser]);
end;

end.

( ) { } [ ] - / + * = , ; . ^ ~ | < >
