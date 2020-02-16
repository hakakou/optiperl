unit ErrorCheckMdl;  //Module
{$I Reg.Inc}

interface

uses
  Windows,SysUtils, Classes, DIPcre,hyperstr,OptOptions,ScriptInfoUnit,dcstring,
  hakageneral,hakafile, runperl,Forms, OptGeneral,CommConvUnit,OptForm,OptMessage,
  HakaPipes, ExtCtrls,HKDebug, OptProcs,HKPerlParser, OptFolders;

type
  TProgStatus = (psOK,psWarnings,psErrors,psOther);

  TErrorCheckMod = class(TDataModule)
   ReqPCRE: TDIPcre;
   procedure DataModuleCreate(Sender: TObject);
   procedure DataModuleDestroy(Sender: TObject);
  private
   outfile,FFilename : String;
   DoAddPath : String;
   Priority : Cardinal;
   LineData : TStringList;
   InQuote : Boolean;
   InQuoteLines : Integer;
   Procedure SetStatus(Astatus : TProgStatus);
   procedure CheckCarp;
   procedure Processlines;
   Procedure DeleteOutFile;
   Procedure ExpandScript(const outFile : string);
   procedure DoLine(const Line: String);
  public
   Checking : Boolean;
   Status : TProgStatus;
   Errors : TStrings;
   ContainerForm : TOptiForm;
   CheckAutoOptions : Boolean;
   Function UpdateError(const script : String; Expand : Boolean = false) : Boolean;
   property Filename : String read FFilename;
  end;

  TErrorThread = class(TThread)
  private
   Errors: TStringList;
   Status : Integer;
   ErrorMod : TErrorCheckMod;
   Code: TStringList;
   PCRE,PCRE2 : TDIPcre;
   procedure ExecuteLoop;
   procedure SafeCopyStrings;
   procedure CopyErrors;
  public
   constructor Create;
   Destructor Destroy; override;
   procedure Execute; override;
  end;

implementation

{$R *.dfm}

Function TErrorCheckMod.UpdateError(const script: String; Expand : Boolean = false) : Boolean;
Const
 WarningsStr : array[0..2] of string = ('c','cw','cW');
 TaintStr : array[False..True] of string = ('','T');
var
 f,Env,AScript,HomeDir : string;
 i:integer;
 ps : TPipeStatus;
 SL : TStringList;
begin
 Result:=true;
 Checking:=true;
 LineData.Clear;
 FFileName:=Script;
 DeleteOutFile;
 InQuote:=false;
 InQuoteLines:=0;

 Errors.clear;

 If (not fileexists(script)) or
    (not fileexists(options.pathtoperl)) then
 begin
  SetStatus(psOther);
  Errors.add('Problem checking '+script);
  Checking:=false;
  exit;
 end;

 if assigned(ContainerForm) then
  ContainerForm.SetCaption('Syntax Checking...');

 if length(DoAddPath)=0
  then HomeDir:=extractfilepath(script)
  else HomeDir:=extractfilepath(DoAddPath);

 Ascript:=Script;

 if Expand then
 begin
  outfile:=GetTmpFile(ExtractFilepath(Script),'OP');
  if fileexists(outfile) then
  try
   expandScript(outfile);
   AScript:=outfile;
  except
   on exception do AScript:=Script;
  end;
 end;

 if not CheckAutoOptions
 then
  f:='-'+WarningsStr[options.Warnings]+taintstr[Options.Tainting]+
     ' "'+Ascript+'"'
 else
  f:='-'+WarningsStr[1]+' "'+Ascript+'"';

 if length(DoAddPath)>0
  then Env:=GetLibPath(DoAddPath)
  else env:=GetLibPath(FFilename);

 Env:='PERL5LIB='+Env+#0+GetEnvironmentString;

 sl:=TStringList.Create;
 try
  sl.Text:=PipeStdAndWait(options.PathToPerl,f,Env,HomeDir,'',10000,Priority,ps);
  if ps=psException then
   begin
    Status:=psOther;
    Errors.Add('Perl generated errors while checking '+script);
    Errors.Add('Automatic checking has been disabled on this script.');
    Errors.Add('To enable, close and re-open file.');
    result:=false;
   end
  else
   begin
    inQuote:=false;
    for i:=0 to sl.Count-1 do
     DoLine(sl[i]);
    checkcarp;
    ProcessLines;
   end;
  SetStatus(Status);
 finally
  Checking:=false;
  DeleteOutFIle;
  sl.free;
 end;
end;

procedure TErrorCheckMod.CheckCarp;
var
 i,l,p:integer;
 s:string;
 CarpMode : Boolean;
 CarpPat:string;
begin
 CarpPat:=MakePattern('^\[[^\]][^\]]*\]');
 carpmode:=False;

  for i:=0 to Errors.Count -1 do
  begin
   p:=1;
   l:=ScanRX(Errors[i],CarpPat,p);
   if l<>0 then
   begin
    carpmode:=true;
    break;
   end;
  end;

 if carpmode then
  for i:=Errors.Count-1 downto 0 do
  begin
   p:=1;
   l:=ScanRX(Errors[i],CarpPat,p);
   if l=0
    then Errors.Delete(i)
    else
     begin
      s:=Errors[i];
      Delete(s,1,l);
      replaceSC(s,#9,'',false);
      s:=trim(s);

      DeleteStartsWithCase(FFilename+':',s);
      DeleteStartsWithCase(ExtractFilename(FFilename)+':',s);

      if outfile<>'' then
      begin
       DeleteStartsWithCase(OutFile+':',s);
       DeleteStartsWithCase(ExtractFilename(OutFile)+':',s);
      end;

      Errors[i]:=Trim(s);
     end;
  end;
end;

procedure TErrorCheckMod.SetStatus(Astatus: TProgStatus);
Const
 ProgStatusStr : array[TProgStatus] of string = ('OK','Warnings','Errors','Problems');
begin
 Status:=AStatus;
 if assigned(ContainerForm) then
 begin
  ContainerForm.SetCaption('Status: '+ProgStatusStr[Status]);
  if Status<>psOther then
  begin
    if Errors.Count=0 then
     begin
      if fileexists(FFIlename)
       then Errors.add(ExtractFilename(FFilename)+' syntax OK')
       else Errors.add('Could not find file '+ExtractFilename(FFilename));
     end
    else
     Errors.Add('--- Finished checking '+FFileName+' ---');
  end;
 end;
end;

procedure TErrorCheckMod.Processlines;
var
 i,j,q,line,ss1f,ss2f : integer;
 t,s,filename,ss1,ss2 : String;
begin
 status:=psOK;
 for i:=Errors.Count-1 downto 0 do
 begin
  s:=Errors[i];

 // Delete Lines
  if pos('Can''t open perl script',s)<>0 then
  begin
   Status:=psErrors;
   Errors.Delete(i);
   continue;
  end;

  if pos('had compilation errors.',s)<>0 then
  begin
   Status:=psErrors;
   Errors.Delete(i);
   continue;
  end;

  if StringEndsWith(' syntax OK',s) then
  begin
   Errors.Delete(i);
   continue;
  end;

  if (Pos('syntax error at ',s)<>0) or
     (pos('compilation aborted at ',s)<>0) then
   Status:=psErrors;

  //Remove Filename

   ss1:='';
   ss2:='';
   ss1f:=0;
   ss2f:=0;
   j:=scanFF(s,' at ',1);
   q:=0;
   if j>0 then
    q:=scanFF(s,' line ',j);
   if q>0 then
   begin
    ss1f:=j+4;
    ss2f:=q+6;
    ss1:=copyFromTo(s,ss1f,q-1);
    q:=ss2f;
    while isnumber(s[q]) do
    begin
     ss2:=ss2+s[q];
     inc(q);
    end;
   end;

   if (length(ss1)>0) and (length(ss2)>0) then
   begin
    t:=ss2;
    line:=strtoint(t)-1;
    filename:=ss1;

    if IsSameFile(Filename,FFilename) then
    begin
     delete(s,ss1f,length(ss1)+1);
     replaceSC(s,'at '+ss1,'',true);
     //might be two filenames on the same line!
    end;

    if (LineData.Count>line) then
    begin
     delete(s,ss2f,length(ss2));
     insert(inttostr(integer(LineData.Objects[line])+1),s,
            ss2f);
     if (IsSameFile(filename,outfile)) and (not IsSameFile(Filename,FFilename)) then
     begin
      delete(s,ss1f,length(ss1));
      if LineData[line]<>fFilename
       then insert(LineData[line],s,ss1f)
       else delete(s,ss1f,1);
     end;
    end;
    Errors[i]:=s;
   end;

  //Get line

  q:=scanFF(s,' line ',j);
  if q>0 then
  begin
   ss2:='';
   inc(q,6);
   while isnumber(s[q]) do
   begin
    ss2:=ss2+s[q];
    inc(q);
   end;

   if length(ss2)>0 then
   begin
    q:=strtoInt(ss2)-Integer(Errors.Objects[i]);
    Errors.Objects[i]:=TObject(q);
   end;
  end;

 end;

 if (Status=psOK) and (Errors.count>0) then
  Status:=psWarnings;
end;

procedure TErrorCheckMod.DoLine(const Line: String);
var
 mq : Boolean;
begin
 if (length(trim(line))>0) then
 begin
  if ((line[1]=#9) or stringStartsWith('  (',line)) and
     (errors.Count>0)
   then
   with Errors do
   begin
    Strings[count-1]:=strings[count-1]+' '+copy(line,2,length(line));
    InQuote:=false;
    exit;
   end;

  mq:=Odd(countF(line,'"',1));

  if (mq) and (not inquote) then
  begin
   Errors.Add(line);
   InQuote:=true;
   exit;
  end;

  if (mq) and (inQuote) then
  begin
   Inc(InQuoteLines);
   if (Errors.count>0) then
   with Errors do
    Strings[count-1]:=strings[count-1]+line;

   Inquote:=false;
   InQuoteLines:=0;
   exit;
  end;

  if (Inquote) then
   with Errors do
   begin
    Inc(InQuoteLines);
    Strings[count-1]:=strings[count-1]+line;
    exit;
   end;

  Errors.Add(line);
 end;
end;


Procedure TErrorCheckMod.DeleteOutFile;
begin
 if (fileexists(outfile)) and
    (not options.DebSyntaxCheck)  then
  DeleteFile(outfile);
 outfile:='';
end;

Procedure TErrorCheckMod.ExpandScript(const outFile : string);
var
 sl,tsl : TstringList;
 path,reqpath : string;
 i,j:integer;
 s:string;
 found : boolean;
begin
 path:=ExtractFilepath(FFIlename);
 sl:=TStringList.create;
 tsl:=TStringList.create;
 try
  sl.LoadFromFile(FFilename);
  for i:=0 to sl.Count-1 do
   LineData.Addobject(FFilename,TObject(i));

  i:=0;
  While (i<sl.Count) do
  begin
   s:=sl[i];
   j:=pos('#',s);
   if j<>0 then
    setlength(s,j-1);

   found:=false;

   if pos('require',s)<>0 then
   with reqPcre do
   begin
    SetSubjectStr(s);
    if Match(0) >= 0 then
    repeat
     reqpath:=SearchModule(SubStr(1),Path,false);
     if fileexists(reqpath) then
     begin
      tsl.Clear;
      tsl.LoadFromFile(reqpath);

      if not found then
      begin
       sl.Delete(i);
       linedata.Delete(i);
      end;

      if found then inc(i);

      for j:=0 to tsl.Count-1 do
      begin
       sl.Insert(i,tsl[j]);
       linedata.InsertObject(i,reqpath,tobject(j));
       inc(i);
      end;

      dec(i);
      found:=true;

     end;
    until Match(MatchedStrAfterLastCharPos) < 0
   end;

   inc(i);
  end;

  sl.SaveToFile(outfile);
 finally
  sl.free;
  TSL.free;
 end;
end;

procedure TErrorCheckMod.DataModuleCreate(Sender: TObject);
begin
 LineData:=TStringList.create;
 Priority:=NORMAL_PRIORITY_CLASS;
end;

procedure TErrorCheckMod.DataModuleDestroy(Sender: TObject);
begin
 LineData.free;
 DELETEoutfile;
end;

{ TErrorThread }

constructor TErrorThread.Create;
begin
 inherited create(true);
 FreeOnTerminate:=true;
 Priority:=tpLowest;
 ErrorMod:=TErrorCheckMod.Create(nil);
 ErrorMod.CheckAutoOptions:=true;
 ErrorMod.Priority:=IDLE_PRIORITY_CLASS;
 Code:=TStringList.create;
 Errors:=TStringList.create;
 ErrorMod.Errors:=Errors;
 PCRE:=TDIPCre.Create(nil);
 PCRE.matchPattern:='use\s+([\w\:\''\"\.]+)';
 PCRE2:=TDIPCre.Create(nil);
 PCRE2.matchPattern:='(?:^|[^\w])(BEGIN|CHECK)(?:$|[^\w])';
 resume;
end;

destructor TErrorThread.Destroy;
begin
 Code.free;
 Errors.free;
 ErrorMod.Free;
 PCRE.Free;
 PCRE2.free;
 inherited Destroy;
end;

Procedure TErrorThread.SafeCopyStrings;
var
 i,lines:integer;
 s,p:string;
 ms : TMemoSource;
begin
 code.Clear;
 if NoMemoSource then exit;
 ms:=ActiveScriptInfo.ms;
 i:=0;

 EditorEnterCS; //Error Thread
 try
  Lines:=ms.Lines.Count;
  CodeGetCodeSkip:=false;
 finally
  EditorLeaveCS(false);
 end;

 while (i<Lines) do
 begin
  EditorEnterCS; //Error Thread
  try
   if (not NoMemoSource) and (not CodeGetCodeSkip) and (I<ms.Lines.Count) then
    begin
     s:=ms.StringItem[i].ColorData;
     if (length(s)=0) or (ord(s[1]) in [tokComment,tokPod,tokPodHeaders])
     then
      code.Add('')
     else
      begin
       p:=ms.StringItem[i].StrData;
       code.Add(p);
      end;
    end
   else
    begin
     code.clear;
     Assert(false,'LOG CODE EXIT: '+Bool2Str(NoMemoSource)+' '+Bool2Str(CodeGetCodeSkip));
     EditorLeaveCS(false);
     exit;
    end;
   inc(i);
  finally
   EditorLeaveCS(false);
  end;

 end;
end;

Procedure TErrorThread.ExecuteLoop;
var
 filename,s,q:string;
 i,j:integer;
 WillDo : TScriptInfo;
begin
 EditorEnterCS; //Error Thread
 try
  WillDo:=ActiveScriptInfo;
 finally
  EditorLeaveCS(false);
 end;

 try
  SafeCopyStrings;
 except
  on exception do code.Clear;
 end;

 if NoMemoSource then exit;

 i:=shebangline(code);
 if i>=0 then
 begin
  s:=code[i];
  replaceSC(s,'-d','',true);
  code[i]:=s;
 end;

 for i:=0 to imin(5,code.Count-1) do
 begin
  if scanf(code[i],'perl5db.pl',-1)<>0 then
   code[i]:='';
 end;

 if ActiveScriptInfo.DoCheckStripped then
 begin
  for i:=0 to code.Count-1 do
  begin
   s:=TrimRight(code[i]);
   if length(s)=0 then continue;

   j:=1;
   while (j<=length(s)) and (s[j]<=' ') do
    inc(j);
   if (j<=length(s)) and (s[j]='#') then
    continue;

   if pcre2.MatchStr(s)=2 then
    MoveStr('INIT ',s,pcre2.SubStrFirstCharPos(1)+1);

   if stringEndsWith('use',s) then
    s[length(s)]:='d';
   j:=0;
   pcre.SetSubjectStr(s);
   while pcre.Match(j)=2 do
   begin
    if not IsNumber(pcre.SubStr(1)[1]) then
    begin
     q:=SearchModule(pcre.SubStr(1),'',true);
     if not Fileexists(q) then
      s[pcre.MatchedStrFirstCharPos+3]:='d';
    end;
    j:=pcre.MatchedStrAfterLastCharPos+1;
   end;
   code[i]:=s;
  end;
 end;

 filename:=GetTmpDir+ExtractFilename(ActiveScriptInfo.path)+'.~OPC';
 ErrorMod.DoAddPath:=ActiveScriptInfo.path;

 try
  code.SaveToFile(filename);
  try
   if not ErrorMod.UpdateError(Filename) then
    ActiveScriptINfo.DoErrorCheck:=false;
  finally
   deleteFile(filename);
  end;
 except
  on exception do
  begin
   Errors.Clear;
   ActiveScriptINfo.DoErrorCheck:=false;
  end;
 end;

 //See EditorForm.timerTimer comment
 //Below seems to fix the problem
 //The synchronized method probably should not
 //be called while the other synchronize is running
 //and this was called because of application.processmessages
 while ExplorerUpdating do
  sleep(1);

 Status:=Integer(errormod.Status);
 CurErrorsShowing:=WillDo;

 Synchronize(copyErrors);
 Synchronize(PR_DoErrorThreadDone);
end;

procedure TErrorThread.CopyErrors;
var i,c:integer;
begin
 CurErrors.Assign(Errors);
 SetLength(CurErrorsLines,CurErrors.Count);
 c:=0;
 for i:=0 to curerrors.Count-1 do
  if length(ExtFileFromErrorLine(curerrors[i]))=0 then
  begin
   CurErrorsLines[c].Line:=integer(curerrors.Objects[i])-1;
   CurErrorsLines[c].Index:=i;
   inc(c);
  end;
 SetLength(CurErrorsLines,c);
 CurErrorsStatus:=Status;
end;

procedure TErrorThread.Execute;
begin
 repeat
  if WaitForSingleObject(EventStartCode,INFINITE)=WAIT_OBJECT_0 then
  begin

   TicksNextCode:=GetTickCount+TicksTimeOut;
   if WaitForSingleObject(CSEntireCode,INFINITE)=WAIT_OBJECT_0 then
    try
     try
      with options do
       if (assigned(ActiveScriptInfo)) and (ActiveScriptInfo.isPerl) and
          (SHEditorErrors or SHExplorerErrors or SHExplorerWarnings or SHEditorWarnings) then
       begin
        CurErrorsShowing:=nil;
        if activeScriptInfo.DoErrorCheck then
         ExecuteLoop;
       end;
     except end;
    finally
     ReleaseMutex(CSEntireCode);
    end;
   TicksNextCode:=0;

  end;
 until terminated;
 Assert(false,'LOG *** Error Thread Terminated');
end;

end.