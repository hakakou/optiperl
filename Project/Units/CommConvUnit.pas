unit CommConvUnit;  //Unit

interface
uses classes,sysutils,hyperstr,hakageneral,ScriptINfoUnit;


Procedure GetVersionLabels(Lines,Labels : TStrings);
//The active one is at index 0
Function SwapVersions(lines : TStrings) : boolean;
Function DoesHaveDebug : Boolean;
procedure MakeVersion(SL : TStrings; Const Ver : String);
Procedure SetSheBang(sl : TStrings; const shebang : string);
Function SheBangLine(SL : TStrings) : Integer;


implementation

const
 maxline = 100;
 VerStr = '#@';
 DivStr = '#?';

Function SheBangLine(SL : TStrings) : Integer;
var
 i:integer;
 sb : String;
begin
 result:=-1;
 with sl do
 begin
  If (Count=0) then exit;
  i:=0;
  while (i<Count) and (trim(Strings[i])='') do
   inc(i);
  if i=count then exit;
  sb:=Trim(Strings[i]);
  if (Length(sb)<3) or (sb[1]<>'#') or (sb[2]<>'!') then exit;
  result:=i;
 end;
end;

Function DoesHaveDebug : Boolean;
var i:integer;
begin
 with ActiveScriptInfo.ms do
 begin
  i:=SheBangLine(Lines);
  result:=(i>=0) and (pos('-d',lines[i])>0);
 end;
end;

procedure MakeVersion(SL : TStrings; Const Ver : String);
var
 labels : TStringList;
 atry : Integer;
begin
 if sl.Count=0 then exit;
 Labels:=TStringList.Create;
 atry:=0;
 try
  repeat
   Inc(atry);
   GetVersionLabels(sl,labels);
   if Labels.Count=0 then break;
   if labels.IndexOf(ver)<0 then break;
   if Uppercase(labels[0])=Ver then
    break;
   SwapVersions(sl);
  until atry>4;
 finally
  Labels.Free;
 end;
end;

Procedure SetSheBang(sl : TStrings; const shebang : string);
var
 i,p:integer;
 s:string;
begin
 If (SL.Count=0) or (shebang='') then exit;
 p:=SheBangLine(sl);
 if p<0 then exit;
 s:=sl[p];
 i:=pos(' ',s);
 if i=0 then
   s:=shebang
 else
   begin
    delete(s,1,i-1);
    s:=shebang+s;
   end;
 sl[p]:=s;
end;


Function CountStr(Const s,What : string) : Integer;
var p:integer;
begin
 p:=0;
 result:=0;
 repeat
  inc(p);
  p:=scanFF(s,what,p);
  if p<>0 then inc(result);
 until p=0;
end;

Function SwapLine(var s:string) : Boolean;
var p,spaces:integer;
left,right : string;
begin
 p:=pos(DivStr,s);
 if p<>0 then begin
  spaces:=PosFirstNonSpace(s);
  left:=copyFromTo(s,Spaces,p-1);
  right:=CopyFromToEnd(s,p+length(DivStr));
  s:=DupChr(' ',spaces-1)+right+divstr+left;
  result:=true;
 end
  else
   result:=false;
end;

Function SwapVersions(lines : TStrings) : boolean;
var
 A:integer;
 s:string;
begin
 result:=false;
 for a:=0 to lines.count-1 do
 begin
  s:=lines[a];
  if SwapLine(s) then
  begin
   lines[a]:=s;
   result:=true;
  end;
 end;

end;


Procedure GetVersionLabels(Lines,Labels : TStrings);
var
 i,p:integer;
 s,f:string;
begin
 i:=0;
 labels.Clear;
 while (i<=lines.Count-1) and (i<maxline) do
 begin
  s:=lines[i];
  p:=pos(verstr,s);
  if p<>0 then break;
  inc(i);
 end;
 if i=maxline then exit;
 i:=1;
 s:=trim(s);
 repeat
  f := Parse(S,'?',I);
  if (length(f)>=2) and (f[1]=verstr[1]) and (f[2]=verstr[2])
   then delete(f,1,2)
   else
     begin
      labels.clear;
      exit;
     end;
  if (length(f)>0) and (f[length(f)]='#') then delete(f,length(f),1);
  Labels.Add(trim(f));
 until (I<1) or (I>Length(S));
end;



end.