unit CodeAnalyzeUnit;    //Unit

interface
uses sysutils,classes,hyperstr,hakageneral,hakahyper,jclfileutils,DIPCre,
     VirtualTrees,OptGeneral;

type
 TSubObject = Record
  Line : Integer;
  Synopsis : String;
  Usage : String;
  InPackage : Integer;
  Node : PVirtualNode;
 end;

 TModuleData = Class
 private
  code : TStringList;
  PodSubData : TStringList;
  BracketLevel : Integer;
  InPackage:Integer;
  procedure ProcessLine(const s: string; line : Integer);
  function safeGetLine(l : Integer) : string;
  function GetPod(const sub: string; out use : string): String;
 public
  TimeStamp : Integer;
  Module : string;
  Subs : TStringList;
  Exported : TStringList;
  Expanded : Boolean;
  ExportsLine : Integer;
  Packages : TStringList;
  constructor Create(const Amodule : string);
  destructor Destroy; override;
  procedure UpdateList;
 end;

 TModuleList = class(TList)
 public
  PodPcre : TDIPcre;
  procedure ResetAll;
  destructor Destroy; override;
  Constructor Create;
  Function ModuleIndex(Const path : String) : Integer;
  Function GetModule(const module : string) : TModuleData;
  Function FindModuleWithPackage(const Package : String) : String;
 end;

var
 ModList : TModuleList;

implementation

var
 ExportsPat : String;
 LastPodLine : TDiPcre;

{ TModuleData }

function TModuleData.safeGetLine(l : Integer) : string;
begin
 if (l>=0) and (l<=code.Count-1)
  then Result:=trim(code[l])+#13#10
  else Result:='';
end;

Function TModuleData.GetPod(const sub : string; out use : string) : String;
var
 i,j,max,t,next:integer;
 s:string;
 found : boolean;
begin
 use:='';
 result:='';
 i:=PodSubData.IndexOf(sub);
 if i>=0 then
 begin
  i:=Integer(PodSubData.objects[i]);
  //get next used line number
  max:=maxint;
  next:=code.Count;
  for j:=0 to podsubdata.Count-1 do
  begin
   t:=Integer(podsubdata.Objects[j]);
   if ((t-i)<max) and (t-i>0) then
   begin
    max:=t-i;
    next:=t;
   end;
  end;

  result:=HintLineSplitter;

  j:=0;
  found:=false;
  while (j<20) do begin
   s:=safegetline(i);
   if s<>'' then
   begin
    inc(j);
    if s[1]='=' then delete(s,1,pos(' ',s));
    replacesc(s,'B<','',false);
    replacesc(s,'C<','',false);
    replacesc(s,'>','',false);
    result:=result+s;
    if not found then
    begin
     use:=trim(s);
     if StringStartsWithCase(sub,use) then
      delete(use,1,length(sub));
     if pos('(',use)<>0
      then use:=Trim(use)
      else use:='';
     found:=true;
    end;
   end;
   inc(i);
   if (i>=code.Count) or (i>=next) then break;
  end;
  if LastPodLine.MatchStr(result)>0 then
   setlength(result,lastpodline.MatchedStrFirstCharPos);
 end;
end;

constructor TModuleData.Create(const Amodule: string);
begin
 inherited Create;
 Subs:=TStringList.Create;
 subs.Sorted:=True;
 subs.Duplicates:=dupAccept;
 PodSubData:=TStringList.create;
 PodSubData.sorted:=true;
 PodSubData.CaseSensitive:=true;
 Exported:=TStringList.create;
 Exported.sorted:=true;
 Exported.CaseSensitive:=true;
 Exported.Duplicates:=dupIgnore;
 Packages:=TStringList.create;
 Packages.CaseSensitive:=true;
 Module:=AModule;
 Expanded:=false;
 TimeStamp:=fileage(AModule);
 UpdateList;
end;

destructor TModuleData.Destroy;
var i:integer;
begin
 for i:=0 to subs.Count-1 do
  Dispose(pointer(subs.Objects[i]));
 Subs.Free;
 for i:=0 to Exported.Count-1 do
  Dispose(pointer(Exported.Objects[i]));
 Exported.free;
 PodSubData.free;
 Packages.free;
 inherited Destroy;
end;

procedure TModuleData.ProcessLine(const s: string; line: Integer);
var
 w:string;
 p:integer;
 so : ^TSubObject;
begin
 try
  p:=1;
  w:=firstWord(s,p);
  bracketLevel:=BracketLevel+countf(s,'{',1)-countf(s,'}',1);
  if Length(w)=0 then Exit;
  if w='sub' then
  begin
   bracketlevel:=countf(s,'{',1)-countf(s,'}',1);
   w:=FirstWordSkipSpaces(s,p);
   if (Length(w)>0) and (w[Length(w)]='{') then
    Delete(w,Length(w),1);
   if Length(w)>0 then
   begin
    new(so);
    fillchar(so^,sizeof(so^),0);
    so^.Line:=line;
    so^.InPackage:=InPackage;
    so^.Synopsis:=trim(
     SafeGetLine(line)+
     SafeGetLine(line+1)+
     SafeGetLine(line+2)+
     SafeGetLine(line+3)+
     SafeGetLine(line+4));
    so^.Synopsis:=so^.Synopsis+GetPod(w,so^.usage);
    Subs.AddObject(w,pointer(so));
   end;
  end;
  if w='package' then
  begin
   w:=FirstWordSkipSpaces(s,p);
   if length(w)>0 then
   begin
    Packages.Add(w);
    InPackage:=Packages.count-1;
   end;
  end;

 except
  on Exception do
 end;
end;

procedure TModuleData.UpdateList;
var
 i,j,p :integer;
 s,w:string;
 ispod : Boolean;
 InExport : BOolean;
 Exportss:String;
 so : ^TSubObject;
begin
 InPackage:=-1;
 Code:=TStringList.Create;
 code.loadFromFile(Module);
 SetQuotes('"','"');
 BracketLevel:=0;
 Exportss:='';
 ExportsLine:=-1;
 InExport:=false;
 try
  ispod:=False;
  for i:=0 to code.Count-1 do
  begin
    s:=Trim(code[i]);
    if Pos('=head',s)=1 then ispod:=True;
    if Pos('=pod',s)=1 then ispod:=True;
    if Pos('=cut',s)=1 then ispod:=False;
    if ispod then
    begin
     if modlist.PodPcre.MatchStr(s)=2 then
      PodSubData.AddObject(modlist.PodPcre.SubStr(1),TObject(i));
     COntinue;
    end;
  end;

  ispod:=False;
  for i:=0 to code.Count-1 do
  begin
   try
    // First level processing:
    s:=Trim(code[i]);
    //Trim line
    if Length(s)=0 then continue;
    //dont send nil lines
    if Pos('=head',s)=1 then ispod:=True;
    if Pos('=pod',s)=1 then ispod:=True;
    if Pos('=cut',s)=1 then ispod:=False;
    if ispod then continue;
    //Break if pod found

    j:=Pos('#',s);
    if j>0 then delete(s,j,length(s));
    if length(s)=0 then continue;
    //dont send if remark parse

    if not inexport then
    begin
     p:=1;
     j:=ScanRX(s,ExportsPat,p);
     p:=pos('{',s);
     if p=0 then p:=pos('}',s);
     if p=0 then p:=pos('''',s);
     if (j<>0) and (p=0) then
      inExport:=true;
    end;

    if Inexport then
    begin
     if ExportsLine=-1 then ExportsLine:=i;
     Exportss:=Exportss + s + ' ';
     if pos(')',s)<>0 then InExport:=false;
    end;

    if InExport then continue;
    j:=1;
    repeat
     W := Parse(S,';',j);
     if Length(w)>0 then
      processLine(trim(w),i);
    until (j<1) or (j>Length(S));
   except
    on Exception do begin end;
   end;
  end;

  if Exportss<>'' then
  begin
   ReplaceSC(Exportss,'@EXPORT_OK','',true);
   ReplaceSC(Exportss,'@EXPORT_FAIL','',true);
   ReplaceSC(Exportss,'@EXPORT','',true);
   ReplaceSC(Exportss,'(','',true);
   ReplaceSC(Exportss,'qw','',true);
   ReplaceSC(Exportss,'=','',true);
   ReplaceSC(Exportss,')','',true);
   ReplaceSC(Exportss,';','',true);
   ReplaceSC(Exportss,#13,' ',true);
   ReplaceSC(Exportss,#10,' ',true);
   ReplaceSC(Exportss,#9,' ',true);

   I := 1;
   repeat
    s := Parse(Exportss,' ',I);
    if Length(s)<>0 then
    begin
     new(so);
     fillchar(so^,sizeof(so^),0);
     so^.Line:=ExportsLine;
     so^.Synopsis:=GetPod(s,so^.usage);
     Exported.AddObject(s,TObject(so));
    end;
   until (I<1) or (I>Length(ExportsS));
  end;
 finally
  code.Free;
 end;
end;

{ TModuleList }

destructor TModuleList.Destroy;
begin
 PodPcre.free;
 ResetAll;
 inherited Destroy;
end;

function TModuleList.FindModuleWithPackage(const Package: String): String;
var
 i,j:integer;
 md : TMOduleData;
begin
 result:='';
 for i:=0 to count-1 do
 begin
  md:=items[i];

  for j:=0 to md.Packages.Count-1 do
   if md.Packages[j]=package then
   begin
    result:=md.Module;
    exit;
   end;

 end;
end;

Function TModuleList.ModuleIndex(Const path : String) : Integer;
var
 i:integer;
begin
 result:=0;
 while (result<count) and (AnsiCompareText(TModuleData(Items[result]).Module,path)<>0) do
  inc(result);
 if result>=count then
  result:=-1;
end;

function TModuleList.GetModule(const module: string): TModuleData;
var
 i:integer;
begin
 Result:=nil;
 if sysutils.fileexists(module) then
 begin
  i:=ModuleIndex(module);
  if i<0 then
   begin
    Result:=TModuleData.Create(module);
    add(result);
   end
  else
   result:=TModuleData(items[i]);
 end; 
end;

Procedure TModuleList.ResetAll;
var
 i:integer;
begin
 for i:=count - 1 downto 0 do
 begin
  TModuleData(Items[i]).Free;
  delete(i);
 end;
end;


constructor TModuleList.Create;
begin
 inherited;
 podPcre:=TDIPcre.Create(nil);
 podPcre.MatchPattern:='^=item\s+(?:[A-Z]<|\$\w+\->|)(\w+)';
end;


initialization
 ModList:=TModuleList.Create;
 ExportsPat:=MakePattern('^\@EXPORT');
 LastPodLine:=TDiPcre.create(nil);
 LastPodLine.MatchPattern:='\n=\w+[^\n]+\n?$';
finalization
 ModList.Free;
 LastPodLine.free;
end.

{
Samples for export

@EXPORT =
    qw(
	NULL
	WIN31_CLASS
	OWNER_SECURITY_INFORMATION
	GROUP_SECURITY_INFORMATION
	DACL_SECURITY_INFORMATION
	SACL_SECURITY_INFORMATION
	MB_ICONHAND
	MB_ICONQUESTION
	MB_ICONEXCLAMATION
	MB_ICONASTERISK
	MB_ICONWARNING
	MB_ICONERROR
	MB_ICONINFORMATION
	MB_ICONSTOP
);


@EXPORT_OK = qw(uf_uri uf_uristr uf_url uf_urlstr);