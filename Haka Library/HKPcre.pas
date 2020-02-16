unit HKPcre;


interface
uses DIPcre,hyperstr,sysutils,classes,hakageneral;


Function ReplacePCRE(Const Find,RepStr,text: String; out Modified : Boolean; Start : Integer = 0) : string;
Function TextReplacePCRE(Const RepStr,Text: String; PCRE : TDIPcre; out Modified : Boolean; Start : Integer = 0) : string;

implementation

Function ReplacePCRE(Const Find,RepStr,text: String; out Modified : Boolean; Start : Integer = 0) : string;
var
 pcre : TDIpcre;
begin
 Pcre:=TDIPcre.Create(nil);
 Pcre.MatchPattern:=find;
 pcre.SetSubjectStr(text);
 try
  result:=TextReplacePcre(RepStr,text,pcre,modified,start);
 finally
  pcre.free;
 end;
end;

Function TextReplacePCRE(Const repstr,Text: String; PCRE : TDIPcre; out Modified : Boolean; Start : Integer = 0) : string;
var
 i,p,np,d,len:integer;
 r:string;
 sl : TStringList;
begin
 modified:=false;
 sl:=TStringList.Create;
 with pcre do
 begin
    result:='';
    p:=0;
    len:=0;
    SetLength(result,length(text));
    if Match(Start)>=0 then
    repeat
     sl.Clear;
     for i:=0 to pcre.SubStrCount-1 do
      sl.Add(pcre.SubStr(i));
     r:=PerlToRealTokens(repstr,sl);

     np:=len+1;
     d:=MatchedStrFirstCharPos-p;
     len:=len+d+length(r);
     if len>length(result) then
      setlength(result,imax(length(result)+length(text) div 3,len));
     move(text[p+1],result[np],d);
     inc(np,d);
     move(r[1],result[np],length(r));
     modified:=true;
     p:=MatchedStrAfterLastCharPos;

    until Match(MatchedStrAfterLastCharPos)<0;

    np:=len+1;
    len:=len+Length(text)-p;
     if len>length(result) then
      setlength(result,imax(length(result)+length(text) div 3,len));
    move(text[p+1],result[np],Length(text)-p);
    setLength(result,len);
 end;
 sl.free;
end;

end.