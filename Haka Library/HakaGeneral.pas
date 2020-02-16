unit HakaGeneral;

interface
uses sysutils,Dialogs,forms,classes,windows,messages,controls,variants,graphics;

function Between(num,min,max : integer) : boolean; overload;
function Between(num,min,max : real) : boolean; overload;
function Between(num,min,max : string) : boolean; overload;
Procedure Exchange(var v1,v2 : Single);

function MaxValue(Value1, Value2, Value3 : integer) : integer;
Function IsNumber(c:char) : Boolean;
Function LastChar(const s:string; ischar : Char) : boolean;
Function OpenModalForm(AFormClass : TPersistentClass) : Integer;
Procedure OpenModelessForm(var AFormVar; AFormClass : TPersistentClass);
Function CreateAClass(const AClassName : string; AOwner : TComponent) : TObject;
function PosLast(Substr: string; S: string): Integer;
function GetCpuSpeed : Cardinal;

Function SingleTStringAdd(Const StringList,Add : String) : String;
Function SingleTStringRemove(Const StringList,Remove : String) : String;

function IsCustomFormInScreen(CustomForm : TCustomForm) : Boolean; overload;
function IsCustomFormInScreen(AFormClass : TPersistentClass) : Boolean; overload;
Procedure GetAllActiveControls(Const AClassName : String; List : TList);
Procedure GetAllControls(AWinControl : TWinControl; List : TList);
Function SelectNextForm(ActiveForm : TCustomForm) : TCustomForm;
function IsControlInForm(Control : TControl; CustomForm : TCustomForm) : Boolean;
Function GetFormByName(Const AName: String):TCustomForm;
Procedure MoveStr(Const Str : String; Var Target : String; Index : Integer);

function MakeStr(const Arg: TVarRec): string;
Function HKVarToStr(v : variant ) : string;
Function SecondsToStr(Sec: Integer): string;
function Firstcase(const str : string) : string;
Function IsAllCaps(const str : string) : Boolean;
Procedure SmartCase(var str : string);
//Puts on first case only if all uppercase

Procedure SaveManyStreams(Sources : array of TStream; Dest : TStream);
Procedure LoadManyStreams(Dest : array of TStream; Source : TStream);


Function NiceIniName : string;
Function NiceAppName : string;
Function ProgramPath : String;
function RemoveQuotes(const s:string; quotechar: char) : string;
function AddQuotes(const s:string; quotechar: char) : string;
function OSType : Cardinal;

Function URLToHost(const URL : String) : String;
Function PosFirstNonSpace(const s:string) : Integer;
Function CopyFromTo(const s:string; FromC,ToC: integer) : string;
Function CopyFromToEnd(const s:string; FromC: integer) : string;
function FirstWord(const s:string) : string;
function StringStartsWith(const starts,str : string) : Boolean;
function StringStartsWithCase(const Starts,str : string) : Boolean;
function StringEndsWith(const ends,str : string) : Boolean;
function StringEndsWithCase(const ends,str : string) : Boolean;
procedure DeleteStartsWith(const Starts : string; var str : string);
procedure DeleteStartsWithCase(const Starts : string; var str : string);
procedure DeleteEndsWith(const Ends : string; var str : string);
procedure ReplaceStartsWithCase(Const Starts,Replace : String; var str : string);
function IsInStr(const search,str : string) : Boolean;
function IsBinaryFile(const FileName : string) : Boolean;
function IsBinaryText(const Text : string) : Boolean;
Procedure SaveFileWithEOlChar(SL : TStrings; EOL : Integer; const Target : String);
Function GetEOLCharacter(const text : String) : Integer;
//-1 = Cannot determine 0 = windows 1=unix 2=mac

Function ParseWithEqual(const line : string; Var t1,t2 : string) : BOolean;
Function ParseWithCustom(const line : string; Var t1,t2 : string; Sep:char) : BOolean;
procedure ShowVars(Avar : variant);

Function GetHeapString(OldHeap : THeapStatus) : String;

Function WaitForOrTimeOut(var Occupied : Boolean; TimeoutMS : Cardinal) : Boolean;
//does this work??

procedure SleepAndProcess(ms : Cardinal);

procedure SmartTStringsAdd(sl : TStrings; const text : string; Max : Integer);
Function IncreaseNumber(MaxCount,Current,Direction : Integer; ScrollStart : Boolean) : Integer;
//1 - index
Function RemoveHTMLTags(const HTML : String) : String;

Procedure SetHelpKeywords(Form : TForm);
function GetXMLTagValue(const Tag,Str : String) : String;

Function PerlToRealTokens(Const Str : String; BackRefs : TStrings) : String;

Function GetAddressFromURLFile(Const URLFile : String) : String;

function HTMLToColor(sColor : string ): TColor;
function ColorToHtml(DelphiColor:TColor):string;

Function Bool2Str(Bool : Boolean) : String;
Function Str2Bool(Const Str : String) : Boolean;
function ExtractFileFromURL(const URL: string): string;

const
 LetterSChar : Array[false..true] of string = ('','s');

implementation
uses typinfo;
var tempform : TForm = nil;


function ExtractFileFromURL(const URL: string): string;
var
  I: Integer;
begin
  I := LastDelimiter('/', URL);
  Result := Copy(URL, I + 1, MaxInt);
end;

function GetXMLTagValue(const Tag,Str : String) : String;
var
 i,j:integer;
 op,cl : String;
begin
 op:='<'+tag+'>';
 cl:='</'+tag+'>';
 i:=pos(op,str)+length(op);
 j:=pos(cl,str)-i;
 if (i>0) and (j>0)
  then result:=copy(str,i,j)
  else result:='';
end;

procedure ReplaceStartsWithCase(Const Starts,Replace : String; var str : string);
begin
 if stringstartswithcase(starts,str) then
 begin
  delete(str,1,length(starts));
  insert(replace,str,1);
 end;
end;

Procedure MoveStr(Const Str : String; Var Target : String; Index : Integer);
begin
 move(str[1],target[index],length(str));
end;

Function Bool2Str(Bool : Boolean) : String;
const
 BStr : array[boolean] of char = ('0','1');
begin
 result:=BStr[bool];
end;

Function Str2Bool(Const Str : String) : Boolean;
begin
 result:=(length(str)>0) and ( (str[1]='1') or (str[1]='T') or (str[1]='t') );    
end;

function HTMLToColor( sColor : string ): TColor;
begin
  if (length(scolor)>0) and (scolor[1]='#') then
   Delete(scolor,1,1);
  if length(SColor)=6 then
   Result :=
    RGB(
      { get red value }
      StrToInt( '$'+Copy( sColor, 1, 2 ) ),
      { get green value }
      StrToInt( '$'+Copy( sColor, 3, 2 ) ),
      { get blue value }
      StrToInt( '$'+Copy( sColor, 5, 2 ) )
    )
  else
   result:=0;
end;

function ColorToHtml(DelphiColor:TColor):string;
 var
   tmpRGB : TColorRef;
 begin
   tmpRGB := ColorToRGB(DelphiColor);
   Result:=Format( '#%.2x%.2x%.2x',
                   [GetRValue(tmpRGB),
                    GetGValue(tmpRGB),
                    GetBValue(tmpRGB)]);
end;

Function URLToHost(const URL : String) : String;
var i:integer;
begin
 result:=URL;
 deleteStartswithCase('http://',result);
 i:=pos('/',result);
 if i>0 then setlength(result,i-1);
end;

Function GetAddressFromURLFile(Const URLFile : String) : String;
var
 sl : TStringList;
 i:integer;
 s1:string;
 f : boolean;
begin
 if not fileexists(URLFile) then
 begin
  result:='';
  exit;
 end;
 sl:=TSTringList.Create;
 try
  sl.LoadFromFile(URLFile);
  f:=false;
  for i:=0 to sl.Count-1 do
  begin
   if (stringStartsWithCase('URL',sl[i])) and
      (parsewithEqual(sl[i],s1,result)) and
      (AnsiCompareText(trim(s1),'URL')=0) then
    begin
     result:=trim(result);
     f:=true;
     break;
    end;
  end;
  if not f then
   result:='';
 finally
  sl.free;
 end;
end;


Function PerlToRealTokens(Const Str : String; BackRefs : TStrings) : String;
var
 i:integer;
 br : byte;
 bs,uc,lc : Boolean;
begin
 i:=1;
 bs:=false;
 uc:=false;
 lc:=false;
 result:='';
 while (i<=length(str)) do
 begin
  if (str[i]='\') and (not bs)
  then
   bs:=true
  else
   begin
    if bs then
     begin
      case str[i] of
       'n' : result:=result+#10;
       'r' : result:=result+#13;
       't' : result:=result+#9;
       '0'..'9' :
           if assigned(backrefs) then
           begin
            br:=ord(str[i])-48;
            if (br<backrefs.Count)
             then result:=result+BackRefs[br];
           end;
       'u' : uc:=true;
       'l' : lc:=true;
       'b' : if length(result)>0 then
              setlength(result,length(result)-1);
       else result:=result+str[i];
      end;
      bs:=false;
     end
    else
     begin
      if uc then
       begin
        result:=result+UpCase(str[i]);
        uc:=false;
       end
      else
      if lc then
       begin
        result:=result+LowerCase(str[i]);
        lc:=false;
       end
      else
       result:=result+str[i];
     end;
   end;
  inc(i);
 end;
end;

Procedure SetHelpKeywords(Form : TForm);

  Procedure SetWinControl(win : TWinControl);
  var
   i:integer;
  begin
   with win do
   for i:=0 to ControlCount-1 do
   begin
    if (Controls[i] is TWinControl) and
       (TWinControl(Controls[i]).ControlCount>0)
     then SetWinControl(TWinControl(Controls[i]));
    if (Controls[i].ShowHint) and (Controls[i].HelpKeyword='') and
       (Controls[i].name<>'') then
      Controls[i].HelpKeyword:=Form.Name+'.'+Controls[i].Name;
   end;
  end;

begin
 SetWinControl(form);
end;


function PosLast(Substr: string; S: string): Integer;
begin
 result:=pos(substr,s);
 if result>0 then inc(result,length(substr));
end;

function MaxValue(Value1, Value2, Value3 : integer) : integer;
begin
  if Value1 > Value2 then
    Result := Value1
  else
    Result := Value2;

  if Value3 > Result then
    Result := Value3;
end;


Function GetFormByName(Const AName: String):TCustomForm;
var
 i:integer;
begin
 i:=0;
 while (i<screen.CustomFormCount) and
       (screen.CustomForms[i].Name<>AName) do
  inc(i);
 if i<Screen.customformcount
   then result:=Screen.customforms[i]
   else result:=nil;
end;

Function IsAllCaps(const str : string) : Boolean;
var i:integer;
begin
 i:=1;
 while (i<=length(str)) and (not (str[i] in ['a'..'z'])) do inc(i);
 result:=i>length(str);
end;

Procedure SmartCase(var str : string);
begin
 if isallcaps(str) then str:=FirstCase(str);
end;

Function LastChar(const s:string; ischar : Char) : boolean;
begin
 result:=(length(s)>0) and (s[length(s)]=ischar);
end;

Function SelectNextForm(ActiveForm : TCustomForm) : TCustomForm;
var i:integer;
begin
 result:=nil;
 if screen.CustomFormCount<=1 then exit;
 if (fsmodal in  Screen.ActiveForm.FormState) then exit;
 i:=0;
  While (ActiveForm<>screen.CustomForms[i]) and
        (I<screen.CustomFormCount) do
   inc(i);
 if I=Screen.CustomFormCount
  then i:=0
  else inc(i);
 result:=Screen.CustomForms[i];
end;


Function IncreaseNumber(MaxCount,Current,Direction : Integer; ScrollStart : Boolean) : Integer;
begin
 result:=Current;
 if MaxCount<=0 then
  exit;
 inc(result,direction);
 if ScrollStart then
  begin
   if result<1 then result:=Maxcount;
   if result>Maxcount then result:=1;
  end
 else
  begin
   if result<1 then result:=1;
   if result>Maxcount then result:=MaxCount;
  end;
end;

Function RemoveHTMLTags(const HTML : String) : String;
var
 i:integer;
 inh : boolean;
begin
 result:='';
 inh:=false;
 for i:=1 to length(html) do begin

  if html[i]='<' then
  begin
   inh:=true;
   continue;
  end;

  if html[i]='>' then
  begin
   inh:=false;
   continue;
  end;

  if not inh then result:=result+html[i];

 end;
end;

Function SingleTStringAdd(Const StringList,Add : String) : String;
var
 sl:TStringList;
 i : Integer;
begin
 sl:=TStringList.Create;
 try
  sl.Text:=StringList;
  i:=0;
  while (i<sl.Count) and (ansicomparetext(sl[i],Add)<>0) do
   inc(i);
  if i>=sl.Count then
   sl.Add(add);
  result:=sl.Text;
 finally
  sl.free;
 end;
end;

Function SingleTStringRemove(Const StringList,Remove : String) : String;
var
 sl:TStringList;
 i : Integer;
begin
 sl:=TStringList.Create;
 try
  sl.Text:=StringList;
  i:=0;
  while (i<sl.Count) and (ansicomparetext(sl[i],remove)<>0) do
    inc(i);
  if i<sl.Count then
   sl.Delete(i);
  result:=sl.Text;
 finally
  sl.free;
 end;
end;

procedure SmartTStringsAdd(sl : TStrings; const text : string; Max : Integer);
var i:Boolean;
begin
 if Length(Text)>0 then
 begin
  i:=sl.IndexOf(text)=-1;
  if i then sl.Insert(0,text);
  if sl.count>Max then
   repeat
    sl.Delete(Max);
   until sl.count=max;
 end;
end;

Function ParseWithCustom(const line : string; Var t1,t2 : string; Sep:char) : BOolean;
var i:integer;
begin
 i:=pos(sep,line);
 result:=i>0;
 if result then
 begin
  t1:=copy(line,1,i-1);
  T2:=copy(line,i+1,length(line));
 end;
end;

Function ParseWithEqual(const line : string; Var t1,t2 : string) : BOolean;
var i:integer;
begin
 i:=pos('=',line);
 result:=i>0;
 if result then
 begin
  t1:=copy(line,1,i-1);
  T2:=copy(line,i+1,length(line));
 end;
end;

procedure SleepAndProcess(ms : Cardinal);
var tms:Cardinal;
begin
 tms:=GetTickCount+Ms;
 while GetTickCount<tms do application.ProcessMessages;
end;

Function WaitForOrTimeOut(var Occupied : Boolean; TimeoutMS : Cardinal) : Boolean;
var ms:Cardinal;
begin
 result:=false;
 ms:=GetTickCount+TimeoutMs;
 while occupied do
 begin
  if GetTickCount>ms then
  begin
   result:=true;
   exit;
  end;
  Application.ProcessMessages;
 end;
end;

Procedure SaveFileWithEOlChar(SL : TStrings; EOL : Integer; const Target : String);
const
 EOLChr : array[0..2] of string = (#13#10,#10,#13);
var
 fs : TFileStream;
 i:integer;
 s:string;
begin
 fs:=TFileStream.Create(Target,fmCreate);
 try
  for i:=0 to sl.Count-1 do
  begin
   s:=sl[i]+EOLChr[eol];
   fs.write(s[1],length(s));
  end;
 finally
  fs.free;
 end;
end;

Function GetEOLCharacter(const text : String) : Integer;
var
 c : byte;
 p,l : Integer;
begin
 result:=-1;
 for p:=1 to length(text)-1 do
 begin
  if text[p] in [#13,#10] then
  begin
   if (text[p]=#13) and (text[p+1]=#10) then result:=0
   else
   if (text[p]=#10) then result:=1
   else
   if (text[p]=#13) then result:=2;
   break;
  end;
 end;
 if (length(text)>0) and (result<0) then
 begin
  if (text[length(text)]=#10) then result:=1
  else if (text[length(text)]=#13) then result:=2;
 end;
end;

function IsBinaryText(const Text : string) : Boolean;
var
 c : byte;
 p,l : Integer;
begin
 Result:=False;
 l:=length(text);
 p:=1;
 while (p<=l) do
 begin
   c:=ord(text[p]);
   if (c<32) and (not (c in [13,10,9,26])) then
   begin
    Result:=True;
    break;
   end;
   inc(p);
 end;
end;

function IsBinaryFile(const FileName : string) : Boolean;
var
 fs : TFileStream;
 c : Byte;
 size : Integer;
begin
 fs:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyNone);
 Result:=False;
 if fs.Size>5000
  then size:=5000
  else size:=fs.Size;
 try
  while (fs.Position+1<=size) do
  begin
   fs.read(c,1);
   if (c<32) and (not (c in [13,10,9,26])) then
   begin
    Result:=True;
    break;
   end;
  end;
 finally
  fs.Free;
 end;
end;

function IsInStr(const search,str : string) : Boolean;
begin
 Result:=Pos(search,str)<>0;
end;

procedure DeleteStartsWith(const Starts : string; var str : string);
begin
 if stringStartsWith(starts,str)
  then Delete(str,1,Length(starts));
end;

procedure DeleteStartsWithCase(const Starts : string; var str : string);
begin
 if stringStartsWithCase(starts,str)
  then Delete(str,1,Length(starts));
end;

procedure DeleteEndsWith(const Ends : string; var str : string);
begin
 if stringEndsWith(Ends,str)
  then setlength(str,length(str)-length(ends));
end;

function StringEndsWith(const Ends,str : string) : Boolean;
var i,j:integer;
begin
 Result:=Length(Str)>=Length(ends);
 if Result then
 begin
  i:=length(ends);
  j:=length(str);
  repeat
   if ends[i]<>str[j] then
   begin
    Result:=False;
    Exit;
   end;
   dec(i);
   dec(j);
  until (i<=0);
 end; 
end;

function StringEndsWithCase(const Ends,str : string) : Boolean;
var i,j:integer;
begin
 Result:=Length(Str)>=Length(ends);
 if Result then
 begin
  i:=length(ends);
  j:=length(str);
  repeat
   if upcase(ends[i])<>upcase(str[j]) then
   begin
    Result:=False;
    Exit;
   end;
   dec(i);
   dec(j);
  until (i<=0);
 end;
end;


function StringStartsWithCase(const Starts,str : string) : Boolean;
var i:integer;
begin
 Result:=Length(Str)>=Length(starts);
 if Result then
 begin
  for i:=1 to Length(starts) do
   if Upcase(str[i])<>Upcase(starts[i]) then begin
    Result:=False;
    Exit;
   end;
 end;
end;


function StringStartsWith(const Starts,str : string) : Boolean;
var i:integer;
begin
 Result:=Length(Str)>=Length(starts);
 if Result then
 begin
  for i:=1 to Length(starts) do
   if str[i]<>starts[i] then begin
    Result:=False;
    Exit;
   end;
 end;
end;

function FirstWord(const s:string) : string;
var p:integer;
begin
 p:=Pos(' ',s);
 if p=0
 then Result:=s
 else Result:=Copy(s,1,p-1);
end;


function IsCustomFormInScreen(CustomForm : TCustomForm) : Boolean;
var i : Integer;
begin
 i:=-1;
 repeat
  Inc(i)
 until (i>=Screen.CustomFormCount) or (Screen.CustomForms[i]=CustomForm);
 Result:=i<Screen.CustomFormCount;
end;

function IsCustomFormInScreen(AFormClass : TPersistentClass) : Boolean;
var i : Integer;
begin
 i:=-1;
 repeat
  Inc(i)
 until (i>=Screen.CustomFormCount) or (Screen.CustomForms[i].ClassType = AFormClass);
 Result:=i<Screen.CustomFormCount;
end;

Procedure GetAllActiveControls(Const AClassName : String; List : TList);

 procedure DoWinControl(WinControl : TWinControl);
 var
  i:integer;
 begin
  with wincontrol do
  for i:=0 to ControlCount-1 do
   begin
    if AnsiCompareText(controls[i].ClassName,AClassName)=0 then
     List.Add(Controls[i]);
    if (controls[i] is TWinControl) and
       (TWinControl(Controls[i]).ControlCount>0)
     then DoWinControl(Controls[i] as TWinControl);
   end;
 end;

var
 j : Integer;
begin
 for j:=0 to screen.CustomFormCount -1 do
  DoWinControl(screen.CustomForms[j]);
end;

Procedure GetAllControls(AWinControl : TWinControl; List : TList);

 procedure DoWinControl(WinControl : TWinControl);
 var
  i:integer;
 begin
  with wincontrol do
  for i:=0 to ControlCount-1 do
   begin
    List.Add(Controls[i]);
    if (controls[i] is TWinControl) and
       (TWinControl(Controls[i]).ControlCount>0)
     then DoWinControl(Controls[i] as TWinControl);
   end;
 end;

begin
 DoWinControl(AWinControl);
end;


function IsControlInForm(Control : TControl; CustomForm : TCustomForm) : Boolean;
var i : Integer;
begin
 i:=-1;
 repeat
  Inc(i)
 until (i>=CustomForm.ControlCount) or (CustomForm.Controls[i]=Control);
 Result:=i<Screen.CustomFormCount;
end;

Function PosFirstNonSpace(const s:string) : Integer;
begin
 result:=1;
 while (result<=length(s)) and (s[result]=' ') do inc(result);
 if result>length(s) then result:=-1;
end;

Function CopyFromTo(const s:string; FromC,ToC: integer) : string;
begin
 result:=copy(s,fromC,ToC-FromC+1);
end;

Function CopyFromToEnd(const s:string; FromC: integer) : string;
begin
 result:=copy(s,fromC,length(s));
end;

function IsNumber(c: char): Boolean;
begin
 result:=(c in ['0'..'9']);
end;

function OSType : Cardinal;
var
 osv : TOSVersionInfo;
begin
 osv.dwOSVersionInfoSize := sizeof(osv);
 GetVersionEx(osv);
 result:=osv.dwPlatformId;
end;

{
   VER_PLATFORM_WIN32_NT : Result := ostWinNT;
   VER_PLATFORM_WIN32_WINDOWS : Result := ostWin95;
}



function RemoveQuotes(const s:string; quotechar: char) : string;
begin
 if (length(s)>=2) and (s[1]=quotechar) and (s[length(s)]=quotechar)
  then result:=copy(s,2,length(s)-2)
  else result:=s;
end;

function AddQuotes(const s:string; quotechar: char) : string;
begin
 result:=s;
 if length(result)>0 then begin
  if result[1]<>quotechar then insert(quotechar,result,1);
  if result[length(result)]<>quotechar then result:=result+quotechar;
 end;
end;

Function ProgramPath : String;
begin
 result:=extractfilepath(Application.exename);
end;

Function NiceIniName : string;
begin
 result:=NiceAppName+'.ini';
end;

Function NiceAppName : string;
var a:integer;
begin
 result:=application.exename;
 a:=length(result);
 while (result[a]<>'.') and (a>1) do dec(a);
 delete(result,a,length(result));
 result:=FirstCase(result);
end;

Procedure SaveManyStreams(Sources : array of TStream; Dest : TStream);
var a,s:integer;
begin
 for a:=0 to length(Sources) -1 do begin
  s:=Sources[a].Size;
  dest.Write(s,sizeof(s));
  Sources[a].position:=0;
  dest.CopyFrom(Sources[a],Sources[a].Size);
 end;
end;

Procedure LoadManyStreams(Dest : array of TStream; Source : TStream);
var a,s:integer;
begin
 for a:=0 to length(Dest) -1 do begin
  Source.Read(s,sizeof(s));
  if Dest[a] = nil
   then Dest[a].Seek(s,soFromCurrent)
   else Dest[a].CopyFrom(Source,s);
 end;
end;

function Firstcase(const str : string) : string;
begin
 if length(str)>0 then begin
  result:=lowercase(str);
  result[1]:=Upcase(result[1]);
 end else result:='';
end;

function SecondsToStr(Sec: integer): string;
begin
 if sec<=3600*2
  then result:=Format('%.2d:%.2d',[sec div 60,sec mod 60])
  else result:=Format('%dh %dm',[sec div 3600,(sec mod 3600) div 60])
end;

Function HKVarToStr(v : variant ) : string;
begin
 try
  result:=VarTostr(v);
 except
  on EVariantError do result:='';
 end;
end;

Function GetChar(const s:string) : char;
begin
 if length(s)>0
  then result:=s[1]
  else result:=#0;
end;

function MakeStr(const Arg: TVarRec): string;
const
 BoolChars: array[Boolean] of Char = ('F', 'T');
begin
 Result := '';
 with Arg do
  case VType of
   vtInteger:    Result := Result + IntToStr(VInteger);
   vtBoolean:    Result := Result + BoolChars[VBoolean];
   vtChar:       Result := Result + VChar;
   vtExtended:   Result := Result + FloatToStr(VExtended^);
   vtString:     Result := Result + VString^;
   vtPChar:      Result := Result + VPChar;
   vtObject:     Result := Result + VObject.ClassName;
   vtClass:      Result := Result + VClass.ClassName;
   vtAnsiString: Result := Result + string(VAnsiString);
   vtCurrency:   Result := Result + CurrToStr(VCurrency^);
   vtVariant:    Result := Result + string(VVariant^);
   vtInt64:      Result := Result + IntToStr(VInt64^);
  end;
end;

Function CreateAClass(const AClassName : string; AOwner : TComponent) : TObject;
var
 c: tformclass;
begin
 c:=TFormClass(FindClass(AClassName));
 result:=C.Create(AOwner);
end;

Function OpenModalForm(AFormClass : TPersistentClass) : Integer;
begin
 if getclass(AFormClass.classname) = nil then
  RegisterClasses([AFormClass]);
 TempForm:=tform(CreateAClass(AFormClass.Classname,application));
 try
  result:=TempForm.Showmodal;
 finally
  TempForm.Free;
 end;
end;

procedure OpenModelessForm(var aFormVar; AFormClass : TPersistentClass);
begin
 if not assigned(pointer(AFormVar)) then begin
  if getclass(AFormClass.classname) = nil then
    RegisterClasses([AFormClass]);
  pointer(AFormVar):=tform(CreateAClass(AFormClass.Classname,application));
 end;
 tform(AFormVar).Show;
end;

procedure ShowVars(Avar : variant);
var c : integer; s:string;
begin
 if VarIsArray(AVar) then begin
  for c:=VararraylowBound(AVar,1) to VararrayHighBound(AVar,1) do
   try
    s:=s+inttostr(c)+'. '+AVar[c]+#13#10;
   except
    on EVariantError do s:=s+inttostr(c)+'. (Other type)';
   end;
  showmessage(s);
 end else
 showmessage(Avar);
end;

function Between(num,min,max : integer) : boolean;
begin
 result:=(num>=min) and (num<=max);
end;

function Between(num,min,max : real) : boolean;
begin
 result:=(num>=min) and (num<=max);
end;

function Between(num,min,max : string) : boolean;
begin
 result:=(num>=min) and (num<=max);
end;

Procedure Exchange(var v1,v2 : Single);
var t : real;
begin
 t:=v1;
 v1:=v2;
 v2:=t;
end;

function GetCpuSpeed : Cardinal;
(** Uses RDTSC Command to get the Processor Timer count **)
var
  t: DWORD;
  mhi, mlo, nhi, nlo: DWORD;
  t0, t1, chi, clo, shr32: Comp;
begin
  Result:=0;
  shr32 := 65536;
  shr32 := shr32 * 65536;

  (** Get a start time **)
  t := GetTickCount;
  while t = GetTickCount do begin end;
  asm
    DB 0FH
    DB 031H  	(** RDTSC Opcode retrieves 64-bit tick count since boot **)
    mov mhi,edx (** 32-bit Ticks Hi **)
    mov mlo,eax (** 32-bit Ticks Lo **)
  end;

 (** Look 1 second later **)
  while GetTickCount < (t + 100) do begin end;
  asm
    DB 0FH
    DB 031H  (** RDTSC **)
    mov nhi,edx
    mov nlo,eax
  end;

  (** See how many Processor Timer Ticks have elapsed **)
  chi := mhi; if mhi < 0 then chi := chi + shr32;
  clo := mlo; if mlo < 0 then clo := clo + shr32;

  t0 := chi * shr32 + clo;

  chi := nhi; if nhi < 0 then chi := chi + shr32;
  clo := nlo; if nlo < 0 then clo := clo + shr32;

  t1 := chi * shr32 + clo;

  Result:=Round((t1 - t0)/100000);
end;


Function GetHeapString(OldHeap : THeapStatus) : String;
var
 hs : THeapStatus;
begin
 hs:=GetHeapStatus;
 with hs do
 result:=Format('TotalUnc: %d, TotalCom: %d, '+
           'TotalAlloc: %d, TotalFree: %d, FreeSmall: %d, FreeBig: %d, '+
           'Overhead: %d, ErrorCode: %d',
           [TotalUncommitted-OldHeap.TotalUncommitted,
            TotalCommitted-OldHeap.TotalCommitted,
            TotalAllocated-OldHeap.TotalAllocated,
            TotalFree-OldHeap.TotalFree,
            FreeSmall-OldHeap.FreeSmall,
            FreeBig-OldHeap.FreeBig,
            Overhead-OldHeap.Overhead,
            HeapErrorCode]);
end;

end.
