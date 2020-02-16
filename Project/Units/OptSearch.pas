{***************************************************************
 *
 * Unit Name: OptSearch
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptSearch;  //Unit

interface
uses DIPCRE,classes,sysutils, hyperstr,hyperfrm,OptOptions,
     hakahyper,hakaGeneral,hakafile,variants,dcString,dcMemo,windows,controls,OptProcs,
     ScriptInfoUnit,OptControl;

type
 TPatternSearch = record
  Pattern : String;
  FilesSearched : Integer;
  Files : TStringList;
  lines : TStringList;
  Synopsis : TStringList;
 end;


 TUpdateReplace = Function (Const F : String;
   Replaced,CurrSize : Integer) : Boolean of object;

 TControlReplace = Procedure (Const F : String; Memo : TDCMemo;  Var Response : Integer) of object;

Procedure PatternSearchFile(const f,pattern : string; UnGreedy,AlsoBinary,CaseSensitive,RegExp : boolean);
Procedure InitPatternSearch;
Procedure EndPatternSearch;

Procedure PatternReplace(const f,Find,ReplaceStr : string;
 KeepEOL,UnGreedy,CaseSensitive, prompt, DoOpen, RegExp : boolean; DoReplace : TControlReplace; DoUpdate : TUpdateReplace);

var
 PatternSearch : TPatternSearch;

implementation
var
 Response : Integer = -1;

Procedure EndPatternSearch;
begin
 PR_UpdateSearchResult;
 with patternsearch do
 begin
  files.Clear;
  lines.clear;
  synopsis.clear;
 end;
end;

Procedure OptiEncode(Var s:string);
var
  c:char;
  i,l:Integer;
begin
 l:=Length(s);
 for i:=1 to l do
 begin
  c:=s[i];
  if (ord(c)<=31) and (c<>#13) and (c<>#10) then
   s[i]:=' ';
 end;
end;

Procedure InitPatternSearch;
begin
 Response:=-1;
 with patternsearch do
 begin
  pattern:='';
  FilesSearched:=0;
  files.Clear;
  lines.clear;
  synopsis.clear;
 end;
end;

//replace code

Procedure GetLFStringListText(ed : TDCMemo; out Text : String);
var
 I, L, Size, Count: Integer;
 P: PChar;
 S : string;
begin
 with ed.MemoSource do
 begin
  Count := Lines.Count;
  Size := 0;
  for I := 0 to Count - 1 do Inc(Size, Length(stringitem[i].StrData) + 1);
  SetString(text, nil, Size);
  P := Pointer(text);
  for I := 0 to Count - 1 do
  begin
    S := stringitem[i].StrData+#10;
    L := Length(S);
    System.Move(Pointer(S)^, P^, L);
    Inc(P, L);
  end;
 end;
end;

Procedure SetSel(ed : TDcMemo; var LastLine : Integer; Start, Len : Integer; Select : Boolean);
var x,y,x2,y2,i,l,p,d,np,a:integer;
begin
 ed.WinCharPos:=0;
 p:=0;
 i:=0;
 while (i<ed.Lines.Count) do
 begin
  l:=length(ed.memosource.StringItem[i].StrData)+1+p;
  if l>start then break;
  p:=l;
  inc(i);
 end;
 x:=start-p;
 y:=i;
 d:=0;
 for l:=0 to x-1 do
 begin
  ed.memosource.GetTabDelta(d, i, true, np);
  inc(d,np);
 end;
  ed.MemoSource.SetCaretPoint(point(d,y));
 LastLine:=y;
  if select then
 begin
  x2:=x; y2:=y;
  p:=0;
  repeat
   inc(p);
   inc(x2);
   if x2>length(ed.memosource.StringItem[y2].StrData) then
   begin
    if y2=ed.Lines.Count-1
     then break
     else inc(y2);
    x2:=0;
   end;
  until p=len;

  a:=0;
  for l:=0 to x2-1 do
  begin
   ed.memosource.GetTabDelta(a, y2, true, np);
   inc(a,np);
  end;
  ed.MemoSource.SetSelection(stStreamSel,d,y,a,y2);
 end;
 ed.setfocus;
end;

Procedure BinarySearch(Const Find,ReplaceStr,f,s: String; out new:String;
 var Log,modified : Boolean; PCRE : TDIPcre; Start : Integer; DoUpdate : TUpdateReplace);
var
 i,p,np,d,len,max,count:integer;
 r:string;
 sl : TStringList;
begin
 sl:=TStringList.Create;
 with pcre do
 begin
    max:=OptOptions.Options.MaxSearchResults;
    Modified:=false;
    new:='';
    count:=0;
    p:=0;
    len:=0;
    SetLength(new,length(s));
    SetSubjectStr(s);
    if Match(Start)>=0 then
    repeat
     sl.Clear;
     for i:=0 to pcre.SubStrCount-1 do
      sl.Add(pcre.SubStr(i));
     r:=PerlToRealTokens(replaceStr,sl);

     np:=len+1;
     d:=MatchedStrFirstCharPos-p;
     len:=len+d+length(r);
     if len>length(new) then
      setlength(new,imax(length(new)+length(s) div 3,len));
     move(s[p+1],new[np],d);
     inc(np,d);
     move(r[1],new[np],length(r));
     p:=MatchedStrAfterLastCharPos;

     if log then
     begin
      PatternSearch.Files.AddObject(f,TObject(-10));
      PatternSearch.lines.AddObject(
       IntToStr(np)+': "'+MatchedStr+'" -> "'+r+'"',TObject(np));
      PatternSearch.Synopsis.Add(
       'Replaced "'+MatchedStr+'" found at position '+IntToStr(np)+' (old position: '+inttostr(MatchedStrFirstCharPos)+
       ') to "'+r+'"');
     end;
     modified:=true;

     inc(count);
     if (count mod 25 = 0) then
     begin
      if (log) and (PatternSearch.Files.count>Max) then
      begin
       log:=false;
       PatternSearch.Files.AddObject(f,TObject(-1));
       PatternSearch.lines.Add('Over '+inttostr(Max)+' results found. More replacements were made than listed here.');
       PatternSearch.Synopsis.Add(PatternSearch.lines[PatternSearch.lines.count-1]);
      end;
      if (assigned(doUpdate)) and (DoUpdate(f,count,len)) then
      begin
       modified:=false;
       break;
      end;
     end;
    until Match(MatchedStrAfterLastCharPos)<0;

    np:=len+1;
    len:=len+Length(s)-p;
     if len>length(new) then
      setlength(new,imax(length(new)+length(s) div 3,len));
    move(s[p+1],new[np],Length(s)-p);
    setLength(new,len);
 end;
 sl.free;
end;


Procedure PatternReplace(const f,Find,ReplaceStr : string;
  KeepEOL,UnGreedy,CaseSensitive, Prompt, DoOpen , RegExp: boolean; DoReplace : TControlReplace; DoUpdate : TUpdateReplace);
var
 pcre : TDIPCRe;
 eol,a,p:integer;
 s,r,org,new:string;
 modified,Log,WasOpen : boolean;
 SecondUpdate,LastChar : Boolean;
 LastLine : Integer;
 sl : TStringList;
 ed : TDCMemo;
 HadEOL : Boolean;
begin
 LastLine:=-1;
 LastChar:=false;

 PCre:=TDIPCRE.Create(nil);

 if RegExp then
  begin
   if casesensitive
    then pcre.CompileOptions:=pcre.CompileOptions - [coCaseless]
    else pcre.CompileOptions:=pcre.CompileOptions + [coCaseless];
   if UnGreedy
    then pcre.CompileOptions:=pcre.CompileOptions + [coUnGreedy]
    else pcre.CompileOptions:=pcre.CompileOptions - [coUnGreedy];
   pcre.MatchPattern:=find;
  end
 else
  begin
   if casesensitive
    then pcre.CompileOptions:=pcre.CompileOptions - [coCaseless]
    else pcre.CompileOptions:=pcre.CompileOptions + [coCaseless];
   pcre.CompileOptions:=pcre.CompileOptions - [coUnGreedy];
   pcre.MatchPattern:=SimpleToRegExpPattern(find,UnGreedy);
  end;

 sl:=TStringList.Create;
 p:=0;
 HadEol:=ActiveEdit.mainMemo.MemoSource.LeaveSpacesAndTabs;
 ActiveEdit.mainMemo.MemoSource.LeaveSpacesAndTabs:=true;

 Log:=PatternSearch.Files.count<OptOptions.Options.MaxSearchResults;
 PatternSearch.Pattern:=Find;
 inc(patternsearch.filessearched);
 try

  //binary search without search and replace
  if (not prompt) then
   begin
    modified:=false;
    try
     PR_QuickSave;
     s:=loadstr(f);
    except
     on exception do s:='';
    end;

    if keepeol then
    begin
     eol:=GetEOLCharacter(s);
     if (eol>=0) and (isBinaryText(s)) then
      eol:=-1;
     ChangeEolCustomToUnix(s,eol);
    end;

    if s<>'' then
    begin
     BinarySearch(find,ReplaceStr,f,s,new,log,modified,pcre,0,DoUpdate);
     if DoOpen then
      begin
       if Modified then
        PR_OpenFile(f);
       if (modified) and (IsSameFile(ActiveScriptInfo.path,f)) then
       with ActiveEdit.MainMemo do
       begin
        memosource.BeginUpdate(acReplace);
        Lines.Text:=new;
        memosource.endupdate;
       end;
      end
     else
      begin
       if Modified then
       begin
        if keepeol then ChangeUnixEOLtoCustom(new,eol);
        savestr(new,f);
       end;
       PR_ForceReloadAll;
      end;
    end;

   end

  //search with search and replace
  else
   if response<>mrCancel then
   with pcre do
   begin
    ed:=ActiveEdit.mainMemo;
    WasOpen:=PR_OpenTempFile(f);

    ed.MemoSource.Options:=ed.MemoSource.Options - [soLimitEOL,soAutoIndent,soOverwriteBlocks,soOverwriteBlocks];
    ed.Options:=ed.Options - [moSelectOnlyText];

    GetLFStringListText(ed,s);
    pcre.SetSubjectStr(s);

    if response=mrYesToAll then
     begin
      SecondUpdate:=true;
      ed.MemoSource.BeginUpdate(acReplace);
     end
    else
     SecondUpdate:=false;

    if response=mrYesToAll then
     begin
      BinarySearch(find,replaceStr,f,s,new,log,modified,pcre,p,nil);
     end
    else
     if pcre.Match(0)>0 then
     repeat

      sl.Clear;
      for a:=0 to SubStrCount-1 do
       sl.Add(SubStr(a));
      r:=PerlToRealTokens(replaceStr,sl);
      org:=MatchedStr;
      SetSel(ed,LastLine,pcre.MatchedStrFirstCharPos,pcre.MatchedStrLength,response<>mrYesToAll);

      if not (response in [mrCancel,mrYesToAll]) then
       doReplace(f,ed,response);
      if response=mrCancel then break;
      if response=mrYesToAll then
      begin
       BinarySearch(find,replaceStr,f,s,new,log,modified,pcre,p,nil);
       break;
      end;
      if response = mrYes then
      begin
       p:=MatchedStrFirstCharPos;

       with ed.MemoSource do
       begin
        if not secondupdate then
          beginupdate(acReplace);
        for a:=1 to MatchedStrLength do
         DeleteCharRight;
        LastChar:=(caretpoint.y>=lines.Count-1) and
         (length(Lines[CaretPoint.y]) <= CaretPoint.x);

        for a:=1 to length(r) do
        if r[a]=#9 then PressTab
         else
        if r[a]=#10 then
         begin
          PressEnter;
          inc(p);
          Navigate(0,-ed.MemoSource.CaretPoint.X);
         end
        else
         begin
          Insert(r[a]);
          Navigate(0, 1);
          inc(p);
         end;
        GetLFStringListText(ed,s);
        if not secondupdate then
         EndUpdate;
        SetSubjectStr(s);
       end;
       PatternSearch.Files.AddObject(f,TObject(LastLine));
       PatternSearch.lines.Add('"'+org+'" -> "'+r+'"');
       PatternSearch.Synopsis.Add(
        'Replaced "'+org+'" to "'+r+'" (position '+inttostr(p)+')');
      end
       else
        p:=MatchedStrAfterLastCharPos;
     until (response=mrCancel) or (pcre.Match(p)<0) or (LastChar)

    else
     if not WasOpen then
      PR_CloseActiveFile;

    if not optoptions.options.beyondEOL
     then ed.MemoSource.Options:=ed.MemoSource.Options + [soLimitEOL]
     else ed.MemoSource.Options:=ed.MemoSource.Options - [soLimitEOL];
    if optoptions.options.AutoIndent
     then ed.MemoSource.Options:=ed.MemoSource.Options + [soAutoIndent]
     else ed.MemoSource.Options:=ed.MemoSource.Options - [soAutoIndent];
    if optoptions.options.OverwriteBlock
     then ed.MemoSource.Options:=ed.MemoSource.Options + [soOverwriteBlocks]
     else ed.MemoSource.Options:=ed.MemoSource.Options - [soOverwriteBlocks];
    if not optoptions.options.selecteol
     then ed.Options:=ed.Options + [moSelectOnlyText]
     else ed.Options:=ed.Options - [moSelectOnlyText];

    if response=mrYesToAll then
     ed.MemoSource.Lines.Text:=new;

    if SecondUpdate then
     ed.MemoSource.EndUpdate;
   end;
 finally
  sl.free;
  pcre.free;
  ActiveEdit.mainMemo.MemoSource.LeaveSpacesAndTabs:=HadEol;
 end;
end;

Procedure PatternSearchFile(const f,pattern : string; UnGreedy,alsobinary,casesensitive,RegExp : boolean);
var
 pcre : TDIPCRe;
 Sl : TStringList;
 i,a,max:integer;
 log:boolean;
 count:integer;
 s:string;

 function getaline(l : integer) : string;
 const max = 180;
 var s:string;
 begin
  if (l>=0) and (l<=sl.count-1)
   then begin
    s:=trim(sl[l]);
    if length(s)>max then
     s:=copy(s,1,max)+'...';
    result:=inttostr(l+1)+': '+s+#13#10
   end
   else result:='';
 end;

begin
 PCre:=TDIPCRE.Create(nil);

 if RegExp then
  begin
   if casesensitive
    then pcre.CompileOptions:=pcre.CompileOptions - [coCaseless]
    else pcre.CompileOptions:=pcre.CompileOptions + [coCaseless];
   if UnGreedy
    then pcre.CompileOptions:=pcre.CompileOptions + [coUnGreedy]
    else pcre.CompileOptions:=pcre.CompileOptions - [coUnGreedy];
   pcre.MatchPattern:=pattern;
  end
 else
  begin
   if casesensitive
    then pcre.CompileOptions:=pcre.CompileOptions - [coCaseless]
    else pcre.CompileOptions:=pcre.CompileOptions + [coCaseless];
   pcre.CompileOptions:=pcre.CompileOptions - [coUnGreedy];
   pcre.MatchPattern:=SimpleToRegExpPattern(pattern,UnGreedy);
  end;

 PatternSearch.Pattern:=pattern;
 max:=Options.MaxSearchResults;
 Log:=PatternSearch.Files.count<max;
 count:=0;

 sl:=TStringList.create;
 try
  try
   s:=loadstr(f);
  except
   on exception do s:='';
  end;
  if alsobinary then OptiEncode(s);
  sl.Text:=s;
  for i:=0 to sl.Count-1 do
  begin
   a:=pcre.MatchStr(sl.strings[i]);
   if a>0 then with patternsearch do
   begin
    inc(count);
    if (log) and (count>max) then
    begin
     log:=false;
     Files.AddObject(f,TObject(-1));
     lines.Add('Over '+inttostr(max)+' results found...');
     Synopsis.Add('');
    end;

    if log then
    begin
     files.AddObject(f,tobject(i));
     lines.Add(sl[i]);
     s:=trim(
      getaline(i-1)+
      getaline(i)+
      getaline(i+1)+
      getaline(i+2));
     synopsis.add(s);
    end;

   end;
  end;
  inc(patternsearch.filessearched);
 finally
  pcre.free;
  sl.free;
 end;
end;

initialization

 with PatternSearch do
 begin
  Files:=TStringList.create;
  Lines:=TStringList.create;
  Synopsis:=TStringList.create;
 end;

finalization

 with PatternSearch do
 begin
  Files.free;
  lines.free;
  Synopsis.free;
 end;

end.