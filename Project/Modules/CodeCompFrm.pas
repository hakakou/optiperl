unit CodeCompFrm;    //Module

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ConsoleIO, DIPcre, StdCtrls,optOptions,OPtGeneral,runperl,
  optFolders,hyperstr,Hakageneral,CodeAnalyzeUnit,hakafile,
  explorerfrm,scriptinfounit,HTMLElements, OptProcs;

type
  TStatus = (stRunning,stStopped);
  TProcessWay = function (const Line: String): String of object;

  TCodeComplete = class(TDataModule)
    ModPcre: TDIPcre;
    GUI: TGUI2Console;
    FindPcre: TDIPcre;
    ExpPcre: TDIPcre;
    ScalPcre: TDIPcre;
    Find2Pcre: TDIPcre;
    PakPcre: TDIPcre;
    ModQWPcre: TDIPcre;
    Find3Pcre: TDIPcre;
    SimpPcre: TDIPcre;
    SimpDPcre: TDIPcre;
    SModPcre: TDIPcre;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GUILine(Sender: TObject; const Line: String);
    procedure GUIDone(Sender: TObject);
    procedure GUIPrompt(Sender: TObject; const Line: String);
  private
    Safe : Boolean;
    FAdded : TStringList;
    FFillup : TStrings;
    SubFilter,AMod : String;
    Status : TStatus;
    Terminated : boolean;
    ProcessWay : TProcessWay;
    Procedure WaitPrompt;
    Procedure SendCommand(const s : string);
    function GetMethodsCallable(const Line: String): String;
    function GetVariablesPackage(const Line: String): String;
    function GetSimpleSubs(const Line: String): String;
    function GetSimpleVars(const Line: String): String;
    function StandardPerl(const Exp: String): String;
  protected
    procedure _CodeComplete_GetDeclarationHint(const Declaration: String; var Result: String);
  public
    Procedure LoadDeb(Code,FillUp : TStrings; StartPath,LookFor : String; X : Integer);
  end;

var
  CodeComplete: TCodeComplete;

implementation

{$R *.dfm}

{ TCodeCompleteForm }

Function MatchStrBackwards(pcre : TDIPcre; Const Str : String; X : Integer) : Boolean;
var
 i,r:integer;
begin
 Pcre.SetSubjectStr(str);
 i:=0;
 repeat
  if Pcre.Match(i)>0
   then r:=Pcre.MatchedStrAfterLastCharPos
   else r:=0;
  inc(i);
 until (i>=length(str)-1) or (r=x);

 result:=r=x;
 if result then
  pcre.Match(i-1);
end;

procedure TCodeComplete.LoadDeb(Code,FillUp : TStrings; StartPath,LookFor : String; X : Integer);
var
 i : integer;
 s,qw:string;
 buffer:TStringlist;
 found : boolean;
 Simple,issub : Boolean;
begin
 FillUp.clear;
 FFillUp:=FillUp;
 FAdded.Clear;

 if MatchStrBackwards(SimpPcre,lookfor,x) then
  begin
   Simple:=True;
   lookfor:=SimpPcre.SubStr(1);
  end
 else

 if MatchStrBackwards(scalPcre,LookFor,x) then
  begin
   lookfor:=scalpcre.SubStr(1);
   Simple:=false;
  end

 else
  exit;

 GUI.Application:='';
 GUI.Command:='"'+OPtions.PathToPerl+'" -I"'+folders.includepath+'"'+
     DeSafeStr(#137#23#37#126#229#21#141#163#126#42#129#112#235)+  //' -d:perl5db "'
     '~opce.tmp'+
     DeSafeStr(#201#155#219#126#190#5#202#114#95#204);      //'" -emacs '

 GUI.HomeDirectory:=extractFilePath(StartPath);

 if safe
  then s:=''
  else s:=GetLibPath(ActiveScriptInfo.path);

 GUI.Environment:='PERL5LIB='+s+#0+GetEnvironment+#0;
 GUI.Prompt:='(> |\[1m)$';

 AMod:='';
 found:=false;
 if lookfor<>'' then
 begin
  FindPcre.MatchPattern:='\s*\'+lookfor+'\s*=\s*new\s*([\w\:]+)';
  Find2Pcre.MatchPattern:='\s*\'+lookfor+'\s*=\s*([\w\:]+)\s*->';
  Find3Pcre.MatchPattern:='\s*\'+lookfor+'\s*=\s*([\w\:]+)';
 end;

 if not simple then
 begin
   qw:='';
   for i:=0 to code.Count-1 do
   begin
    if (not found) and (findpcre.MatchStr(code[i])=2) then
    begin
     AMod:=findpcre.SubStr(1);
     found:=true;
    end;
    if (not found) and (find2pcre.MatchStr(code[i])=2) then
    begin
     AMod:=find2pcre.SubStr(1);
     found:=true;
    end;
    if (not found) and (find3pcre.MatchStr(code[i])=2) then
    begin
     AMod:='';
     qw:=find3pcre.SubStr(1);
     found:=true;
    end;
   end;
   if not found then exit;
 end
  else
 if lookfor[1] in ['&','$','%','@']
  then Amod:=copyFromToEnd(lookfor,2)
  else Amod:=LookFor;

 if AMod='' then exit;
 buffer:=TStringList.create;

 with SModPcre do
  for i:=0 to code.Count-1 do
  begin
   SetSubjectStr(code[i]);
   if Match(0) >= 0 then
     repeat
       s:=MatchedStr;
       ReplaceSC(s,#13#10,'  ',false);
       s:=Trim(s);
       if Buffer.IndexOf(s)<0 then
        Buffer.add(s);
     until Match(MatchedStrAfterLastCharPos) < 0
  end;

 if buffer.Count=0 then
 begin
  buffer.free;
  exit;
 end;

 buffer.Add('1;');
 buffer.SaveToFile(extractFilePath(StartPath)+'~opce.tmp');
 buffer.free;
 Terminated:=false;

 ProcessWay:=nil;
 GUI.Start;
 ExplorerForm.StartmajorSearch(AMod);
 status:=stRunning;

 waitprompt;
 if (simple)
  then isSub:=(lookfor[1] in ['&','_']) or IsAlphaNumChar(lookfor[1])
  else isSub:=false;

// SendCommand('b  '+inttostr(buffer.count));
 SendCommand('c');
 if (not simple) or ((simple) and (not issub)) then
 begin
  if Simple
    Then ProcessWay:=GetSimpleVars
    else ProcessWay:=GetVariablesPackage;
  SendCommand('V '+AMod);
 end;
 if (not simple) or ((simple) and (issub)) then
 begin
  if Simple
   then ProcessWay:=GetSimpleSubs
   else ProcessWay:=GetMethodsCallable;

//  Sendcommand('m '+AMod);
  Sendcommand('S '+AMod);
 end;
 SubFilter:='';
{ if not Simple then
 begin
  subFilter:=AMod;
  ProcessWay:=GetSubNames;
  Sendcommand('S');
 end;}
 ProcessWay:=nil;
 SendCommand('q');
 GUI.Stop;
 DeleteFile(extractFilePath(StartPath)+'~opce.tmp');
end;

procedure TCodeComplete.FormCreate(Sender: TObject);
begin
 PC_CodeComplete_GetDeclarationHint:=_CodeComplete_GetDeclarationHint;
 FAdded:=TStringList.create;
 FAdded.Sorted:=true;
 FAdded.CaseSensitive:=true;
end;

procedure TCodeComplete.FormDestroy(Sender: TObject);
begin
 Fadded.Free;
end;

Function TCodeComplete.GetSimpleSubs(const Line : String) : String;
var
 i :integer;
begin
 result:=line;
 if StringStartsWith('via UNIVERSAL',line) then
  result:=''
 else
  begin
   i:=pos('::',result);
   if i>0 then
    delete(result,1,i+1);
  end;
end;

Function TCodeComplete.GetSimpleVars(const Line : String) : String;
begin
 result:='';
 if simpDPcre.MatchStr(line)=2 then
  result:=SimpDPcre.SubStr(1);
end;

Function TCodeComplete.GetMethodsCallable(const Line : String) : String;
begin
 result:='';
 if pakPcre.MatchStr(line)=2 then
  result:=(pakpcre.SubStr(1));
end;

Function TCodeComplete.GetVariablesPackage(const Line : String) : String;
begin
 result:='';
 if expPcre.MatchStr(line)=2 then
  result:=(exppcre.SubStr(1));
end;


procedure TCodeComplete.GUILine(Sender: TObject; const Line: String);
var
 ALine,s,u:string;
begin
 if (StringStartsWithCase('Default die handler',line)) or
    (StringStartsWithCase('Loading DB routines from',line)) or
    (StringStartsWithCase('Editor support enabled',line)) or
    (StringStartsWithCase('Enter h or `h',line)) or
    (StringStartsWithCase(#26#26,line)) then exit;
 ALine:=Line;
 DeleteDebugPrompt(ALine);
 if assigned(ProcessWay)
  then s:=ProcessWay(ALine)
  else s:='';
 if (s<>'') and (FAdded.IndexOf(s)<0) then
 begin
  FAdded.Add(s);
  u:=ExplorerForm.majorSearch(s);
  if u<>'' then
   s:=s+' '+u;
  FFIllup.Add(s);
 end;
end;

procedure TCodeComplete.GUIDone(Sender: TObject);
begin
 Terminated:=true;
end;

procedure TCodeComplete.GUIPrompt(Sender: TObject; const Line: String);
var
 aline:string;
 f : integer;
begin
 f:=1;
 ALine:=Line;
 ReplaceSC(ALine,#27+'[4;m','',false);
 ReplaceSC(ALine,#27+'[1m'+#27+'[0m','',false);
// l:=ScanW(Aline,'  DB<*#*> ',f);
 if (f>=1)  ///was =1
  then
   status:=stStopped;
end;

procedure TCodeComplete.WaitPrompt;
var counter : cardinal;
begin
 counter:=GetTickCount+4000;
 while (status=stRunning) and (not terminated) and
       (GetTickCount<counter) do
   application.processmessages;
end;

procedure TCodeComplete.SendCommand(const s: string);
begin
 Status:=stRunning;
 GUI.WriteLN(s);
 waitprompt;
end;

Function TCodeComplete.StandardPerl(const Exp : String) : String;
var
 i:integer;
 s:string;
 f : boolean;
begin
 result:='';
 s:=trim(exp)+' ';
 i:=0;
 f:=false;
 while (i<=high(perlTags)) do
 begin
  if StringStartsWithCase(s,PerlTags[i]) then
   begin
    result:=result+perltags[i]+#13#10;
    f:=true;
   end
  else
   if f then break;
  inc(i);
 end;
end;

procedure TCodeComplete._CodeComplete_GetDeclarationHint(Const Declaration : String; Var Result : String);
begin
 AddDeclaration(result,Declaration,StandardPerl);
end;

end.


{


function TCodeComplete.GetSubNames(const Line : String) : String;
begin
 if (SubFilter<>'') then
 begin
  result:='';
  if (StringStartsWith(subFilter,line)) then
   result:=copyfromtoend(line,length(SubFilter)+3);
 end
  else result:=line;
end;
