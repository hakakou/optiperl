{***************************************************************
 *
 * Unit Name: ScriptInfoUnit
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}
 
unit ScriptInfoUnit;
{$I REG.INC}

interface
Uses windows,HakaGeneral,HKMultiFileHandler,dcstring,classes,sysutils,inifiles, 
     dcmemo,OptOptions,OptGeneral,hyperfrm, hakafile,dcsystem, OptQuery, OptMessage,
     jclfileutils,parsersmdl,OptFolders,hyperstr,hakahyper,hkInifiles,hkstreams,
     variants,hakawin,dipcre,HKDEbug,OptProcs;

type
  TScriptInfo = class(TFileInfo)
  private
   FRunLine : Integer;
   Procedure SetRunLine(r : integer);
   procedure FixRunLine(Line: Integer; Active: Boolean);
   function ShouldDoErrorCheck(Const APath : String): Boolean;
   Procedure OnBeginUpdate(Sender: TObject);
   Procedure OnEndUpdate(Sender: TObject);
   procedure OldGetInfoFile(const InfoFile,Ext: string);
  public
   Original : String;
   FTPModified : Boolean;
   ms : TmemoSource;
   Query  : TQuery;
   Todo : TStringList;
   IsPerl : Boolean;
   Backup : Boolean;
   JustLoaded : Boolean;
   QuickSaveModified : Boolean;
   DoErrorCheck : Boolean;
   DoCheckStripped : Boolean;
   CorrInfo : String;
   {$IFDEF OLE}
   OleObject: Pointer;
   {$ENDIF}
   Constructor Create(const APath : String);
   Destructor Destroy; override;
   Procedure GetInfo; Override; {Get Information about file from user window}
   Procedure SetInfo; Override; {Set Information about file to user window}
   procedure ClearAllRunLines;
   Function GetBreakPoint(line : Integer) : TBreakStatus;
   procedure SetBreakPoint(BreakInfo : tBreakInfo);
   Function GetFTPSession : String;
   Function GetFTPFolder : String;
   Function GetCaption : String;
   Function DisplayName : string; override;
   procedure writeInfoFile;
   Procedure GetInfoFile(const APath : string);
  Published
   property RunLine : integer read FRunLine write SetRunLine;
 end;

 TEncoding = record
  Name,Encoding,Display : String;
  CharSet : Byte;
 end;


Var
 ActiveScriptInfo : TScriptInfo;
 PerlTemplates : TMemoCodeTemplates;
 NearLineString : String;

{
Encoders : Array[0..27] of TEncoding = (
(Name: 'Central European (Mac) (x-mac-ce)'; Encoding:'x-mac-ce'; Display: 'windows-1250'; Charset: RUSSIAN_CHARSET),
(Name: 'Central European (Windows) (windows-1250)'; Encoding:'windows-1250'; Display: 'windows-1250'; Charset: RUSSIAN_CHARSET),
(Name: 'Chinese Simplified (EUC) (EUC-CN)'; Encoding:'euc-cn'; Display: 'gb2312'; Charset: GB2312_CHARSET),
(Name: 'Chinese Simplified (GB2312) (gb2312)'; Encoding:'gb2312'; Display: 'gb2312'; Charset: GB2312_CHARSET),
(Name: 'Chinese Simplified (HZ) (hz-gb-2312)'; Encoding:'hz-gb-2312'; Display: 'gb2312'; Charset: GB2312_CHARSET),
(Name: 'Chinese Simplified (Mac) (x-mac-chinesesimp)'; Encoding:'x-mac-chinesesimp'; Display: 'gb2312'; Charset: GB2312_CHARSET),
(Name: 'Chinese Traditional (Big5) (big5)'; Encoding:'big5'; Display: 'big5'; Charset: CHINESEBIG5_CHARSET),
(Name: 'Chinese Traditional (CNS) (x-Chinese-CNS)'; Encoding:'x-chinese-cns'; Display: 'big5'; Charset: CHINESEBIG5_CHARSET),
(Name: 'Chinese Traditional (Eten) (x-Chinese-Eten)'; Encoding:'x-chinese-eten'; Display: 'big5'; Charset: CHINESEBIG5_CHARSET),
(Name: 'Chinese Traditional (Mac) (x-mac-chinesetrad)'; Encoding:'x-mac-chinesetrad'; Display: 'big5'; Charset: CHINESEBIG5_CHARSET),
(Name: 'Cyrillic (ISO) (iso-8859-5)'; Encoding:'iso-8859-5'; Display: 'windows-1251'; Charset: RUSSIAN_CHARSET),
(Name: 'Cyrillic (KOI8-R) (koi8-r)'; Encoding:'koi8r'; Display: 'windows-1251'; Charset: RUSSIAN_CHARSET),
(Name: 'Cyrillic (KOI8-U) (koi8-u)'; Encoding:'koi8-u'; Display: 'windows-1251'; Charset: RUSSIAN_CHARSET),
(Name: 'Cyrillic (Mac) (x-mac-cyrillic)'; Encoding:'x-mac-cyrillic'; Display: 'windows-1251'; Charset: RUSSIAN_CHARSET),
(Name: 'Cyrillic (Windows) (windows-1251)'; Encoding:'windows-1251'; Display: 'windows-1251'; Charset: RUSSIAN_CHARSET),
(Name: 'Greek (ISO) (iso-8859-7)'; Encoding:'iso-8859-7'; Display: 'windows-1253'; Charset: GREEK_CHARSET),
(Name: 'Greek (Mac) (x-mac-greek)'; Encoding:'x-mac-greek'; Display: 'windows-1253'; Charset: GREEK_CHARSET),
(Name: 'Greek (Windows) (windows-1253)'; Encoding:'windows-1253'; Display: 'windows-1253'; Charset: GREEK_CHARSET),
(Name: 'Japanese (EUC) (euc-jp)'; Encoding:'euc-jp'; Display: 'shift_jis'; Charset: SHIFTJIS_CHARSET),
(Name: 'Japanese (JIS) (iso-2022-jp)'; Encoding:'iso-2022-jp'; Display: 'shift_jis'; Charset: SHIFTJIS_CHARSET),
(Name: 'Japanese (JIS-Allow 1 byte Kana) (csISO2022JP)'; Encoding:'csiso2022jp'; Display: 'shift_jis'; Charset: SHIFTJIS_CHARSET),
(Name: 'Japanese (Mac) (x-mac-japanese)'; Encoding:'x-mac-japanese'; Display: 'shift_jis'; Charset: SHIFTJIS_CHARSET),
(Name: 'Japanese (Shift-JIS) (shift_jis)'; Encoding:'shift-jis'; Display: 'shift_jis'; Charset: SHIFTJIS_CHARSET),
(Name: 'Korean (EUC) (euc-kr)'; Encoding:'euc-kr'; Display: 'Johab'; Charset: JOHAB_CHARSET),
(Name: 'Korean (ISO) (iso-2022-kr)'; Encoding:'iso-2022-kr'; Display: 'Johab'; Charset: JOHAB_CHARSET),
(Name: 'Korean (Johab) (Johab)'; Encoding:'johab'; Display: 'Johab'; Charset: JOHAB_CHARSET),
(Name: 'Korean (Mac) (x-mac-korean)'; Encoding:'x-mac-korean'; Display: 'Johab'; Charset: JOHAB_CHARSET),
(Name: 'Western European (ISO) (iso-8859-1)'; Encoding:'iso8859-1'; Display: 'Windows-1252'; Charset: ANSI_CHARSET)
);
}

implementation

const
 giRunLine = 11;
 giBreakGeneral = 0;
 giBreakOK = 12;
 giBreakInvalid = 13;
 IniSection = 'A';

Function GuessEncoding(Strings : TStrings) : String;
var
 i:integer;
 pcre : TDIPcre;
begin
 result:='';
 pcre:=TDiPcre.Create(nil);
 pcre.MatchPattern:='charset\s*=\s*"*\s*([\w\d-]+';
 try
  for i:=0 to imin(strings.count-1,15) do
   if pcre.MatchStr(strings[i])>1 then
   begin
    result:=pcre.SubStr(1);
    break;
   end;
 finally
  pcre.Free;
 end;
end;

{
Function GetEncodingIndex(Const Enc : String) : Integer;
var i:integer;
begin
 result:=-1;
 if length(enc)=0 then exit;
 for i:=0 to high(encoders) do
  if AnsicompareText(encoders[i].encoding,enc)=0 then
  begin
   result:=i;
   exit;
  end;
end;
Function ConvertMemo(Const FromCharset,ToCharset : String; Memo : TMemoSource) : Boolean;
var
 i,l:integer;
 s:string;
begin
 CEncoder.FromCharset:=FromCharset;
 CEncoder.ToCharset := ToCharset;
 if AnsiCompareText(FromCharset,ToCharset)=0 then exit;
 s:=memo.Lines.Text;
 i:=CEncoder.VerifyData(FromCharset,StringToOleVarArray(s));
 result:=i=1;
 if not result then exit;
 memo.beginupdate(acReplace);
 with memo do
 try
  for i:=0 to lines.count-1 do
  begin
   s:=stringitem[i].StrData;
   l:=length(s);
   if s<>'' then
   begin
    s:=OleVarArrayToString(CEncoder.ConvertData(StringToOleVarArray(s)));
    if length(s)<l*4 then
     stringitem[i].StrData:=s;
   end;
  end;
 finally
  EndUpdate;
 end;
end;
}

Constructor TScriptInfo.Create(const APath : String);
begin
 Inherited Create;
 FTPModified:=false;
 JustLoaded:=true;
 DoErrorCheck:=ShouldDoErrorCheck(Apath);
 DoCheckStripped:=false;
 todo:=TStringList.create;
 Query:=TQuery.Create;
 Backup:=true;
 ms:=TMemoSource.Create(nil);
 ms.TemplatesType:='Custom';
 SetMemoSource(ms);
 ms.CodeTemplates.Assign(PerlTemplates);
 ms.readonly:=false;
 ms.UndoLimit:=options.undolevel;
 ms.OnBeginUpdate:=OnBeginUpdate;
 ms.OnEndUpdate:=OnEndUpdate;

 if length(APAth)>0 then
  begin
   QuickSaveModified:=not fileexists(apath);
   ms.Delimeters:=Options.EditorDelimiters;
   ms.ReadOnly:=FileReadOnly(Apath);
   ms.syntaxparser:=parsersmod.getparser(extractfileext(apath));
   isPerl:=parsersmod.isperl(apath);
   GetInfoFile(apath);
   DontCheckReload:=StringStartsWithCase(Folders.FTPFolder,Apath);
  end
 else
  begin
   QuickSaveModified:=true;
   ms.Delimeters:='';
   ms.ReadOnly:=false;
   isPerl:=false;
  end;
 FRunLine:=-1;
end;

procedure TScriptInfo.OldGetInfoFile(Const InfoFile,Ext : string);
const
 iniInformation = 'Information';
var
 i : Integer;
 s1 : String;
 ini : TInifile;
 sp : TSimpleParser;
begin
 ini:=TIniFile.Create(infofile);
 //XARKA INIFILE
 try
  Query.OldLoadFromINI(ini);
  ReadTStrings(ini,'Todo','Todo',todo);
  sp:=parsersmod.GetParser(ext);
  s1:=ini.ReadString(iniInformation,'Parser',sp.Name);
  i:=parsersmod.Parsers.IndexOf(s1);
  if i>=0
   then ms.SyntaxParser:=TSimpleParser(parsersmod.parsers.objects[i])
   else ms.SyntaxParser:=sp;
  isperl:=ms.SyntaxParser.Name='Perl';
  DoErrorCheck:=ini.ReadBool(iniInformation,'SyntaxCheck',DoErrorCheck);
  DoCheckStripped:=ini.ReadBool(iniInformation,'CheckStripped',false);
 finally
  ini.free;
 end;
end;

procedure TScriptInfo.GetInfoFile(const APath : string);
var
 i : Integer;
 ext,s1 : String;
 ini : TInifile;
 sp : TSimpleParser;
 Str : ^String;
 Strings : TStringList;
begin
 ext:=extractfileext(APath);

 Str:=PR_RequestInfoFile(APath);
 if not assigned(Str) then exit;

 if length(str^)>0 then
 begin
  Strings:=TStringList.Create;
  Strings.Text:=Str^;
  Strings.Insert(0,'['+IniSection+']');
  ini:=TIniFile.CreateStrings(Strings);
  try
   Query.LoadFromINI(ini,IniSection);

   ReadTStrings(ini,iniSection,'_Todo',todo);
   sp:=parsersmod.GetParser(ext);
   s1:=ini.ReadString(iniSection,'_Parser',sp.Name);
   i:=parsersmod.Parsers.IndexOf(s1);
   if i>=0
    then ms.SyntaxParser:=TSimpleParser(parsersmod.parsers.objects[i])
    else ms.SyntaxParser:=sp;
   isperl:=ms.SyntaxParser.Name='Perl';
   DoErrorCheck:=ini.ReadBool(iniSection,'_SyntaxCheck',DoErrorCheck);
   DoCheckStripped:=ini.ReadBool(iniSection,'_CheckStripped',false);
  finally
   ini.free;
   Strings.free;
  end;
 end;

 s1:=Apath+'.op';
 if (todo.Count=0) and (not Query.isNeeded) and fileexists(s1) then
  begin
   OldGetInfoFile(s1,Extractfileext(apath));
   PR_ProjectModified;
   exit;
  end
end;

procedure TScriptInfo.writeInfoFile;
var
 ini : TInifile;
 Strings : TStringList;
 Str : ^String;
 s:string;
begin
 Str:=PR_RequestInfoFile(Path);
 if not assigned(Str) then exit;

 Strings:=TStringList.Create;
 ini:=TIniFile.CreateStrings(Strings);
 try
  Query.SaveToINI(ini,IniSection);
  s:=ms.SyntaxParser.Name;
  ini.WriteString(IniSection,'_Parser',s);
  ini.WriteBool(INiSection,'_SyntaxCheck',DoErrorCheck);
  ini.WriteBool(IniSection,'_CheckStripped',DoCheckStripped);
  WriteTStrings(ini,IniSection,'_Todo',todo);
 finally
  ini.free;
  strings.Delete(0);
  s:=strings.text;
  if Str^<>S then
   PR_ProjectModified;
  Str^:=s;
  Strings.free;
 end;
end;

destructor TScriptInfo.Destroy;
begin
 WriteInfoFile;
 Todo.Free;
 Query.Free;

 EditorEnterCS;
 try
  NoMemoSource:=true;
  FreeAndNil(ms);
  if ActiveScriptInfo=self then
   ActiveScriptInfo:=nil;
 finally
  EditorLeaveCS(true);
 end;
end;


function TScriptInfo.GetBreakPoint(line: Integer): TBreakStatus;
begin
 if ms.imagebit[line,giBreakGeneral]
  then result:=bsGeneral
 else
 if ms.imagebit[line,giBreakOK]
  then result:=bsOK
 else
 if ms.imagebit[line,giBreakInvalid]
  then result:=bsInvalid
 else
  result:=bsNone;
end;

Procedure TScriptInfo.SetBreakPoint(BreakInfo : tBreakInfo);
begin
 with breakInfo do
 if GetBreakPoint(Line)<>Breakstatus then
 case Breakstatus of
  bsGeneral : begin
   ms.imagebit[line,giBreakGeneral]:=true;
   ms.imagebit[line,giBreakOK]:=False;
   ms.imagebit[line,giBreakInvalid]:=False;
   ms.LineTextStyle[line]:=12;
  end;

  bsOK :  begin
   ms.imagebit[line,giBreakGeneral]:=False;
   ms.imagebit[line,giBreakOK]:=true;
   ms.imagebit[line,giBreakInvalid]:=False;
   ms.LineTextStyle[line]:=12;
  end;

  bsInvalid : begin
   ms.imagebit[line,giBreakGeneral]:=False;
   ms.imagebit[line,giBreakOK]:=False;
   ms.imagebit[line,giBreakInvalid]:=true;
   ms.LineTextStyle[line]:=12;
  end;

  bsNone :  begin
   ms.imagebit[line,giBreakGeneral]:=false;
   ms.imagebit[line,giBreakOK]:=False;
   ms.imagebit[line,giBreakInvalid]:=False;
   if (FRunLine<>line) or (not PC_DebuggerRunning)
    then ms.LineTextStyle[line]:=0
    else ms.LineTextStyle[line]:=14;
  end;

 end;
end;

procedure TScriptInfo.ClearAllRunLines;
var i:integer;
begin
 for i:=0 to ms.Lines.Count-1 do
 begin
  if GetBreakPoint(i)<>bsNone
   then ms.LineTextStyle[i]:=12
   else ms.LineTextStyle[i]:=0;
  if ms.ImageBit[i,giRunLine]
   then ms.ImageBit[i,giRunLine]:=False;
 end;
end;

procedure TScriptInfo.FixRunLine(Line : Integer; Active : Boolean);
begin
 if not Active then
 begin
  if GetBreakPoint(Line)<>bsNone
   then ms.LineTextStyle[line]:=12
   else ms.LineTextStyle[line]:=0;
  if ms.ImageBit[line,giRunLine]
   then ms.ImageBit[line,giRunLine]:=False;
 end
  else
 begin
  ms.ImageBit[line,giRunLine]:=True;
  ms.LineTextStyle[line]:=14;
 end;
end;


procedure TScriptInfo.SetRunLine(r: integer);
var
 i:integer;
begin
 FixRunLine(FRunLine,false);
 FRunLine:=r;
 FixRunLine(FRunLine,True);

 if FRunLine>=0 then
 begin
  ms.JumpToLine(FRunLine);
  if assigned(PR_UpdateNearLines) then
  begin
   NearLineString:='';
   i:=imax(FRunLine-6,0);
   while (i<ms.Lines.Count) and
         (length(NearLineString)<500) do
    begin
     NearLineString:=NearLineString+ms.lines[i]+#13#10;
     inc(i);
    end;
  end;
 end;
 PR_FocusEditor;
end;

procedure TScriptInfo.SetInfo;
begin
end;

procedure TScriptInfo.GetInfo;
begin
end;

function TScriptInfo.GetFTPFolder: String;
begin
 if StringStartsWithCase(Folders.FTPFolder,path) then
  begin
   result:=copyFromToEnd(path,length(Folders.FTPFolder)+1);
   setlength(result,length(result)-length(extractfilename(path)));
   delete(result,1,pos('\',result)-1);
   replaceC(result,'\','/');
   replaceSC(result,'%DRV%',':',false);
  end
 else
  result:='';
end;

function TScriptInfo.GetFTPSession: String;
begin
 if StringStartsWithCase(Folders.FTPFolder,path) then
  begin
   result:=copyFromToEnd(path,length(Folders.FTPFolder)+1);
   setlength(result,pos('\',result)-1);
  end
 else
  result:='';
end;

function TScriptInfo.DisplayName: string;
begin
 if Options.DispFullExtension
  then result:=ExtractFilename(path)
  else result:=ExtractFileNoExt(path);
 if length(result)=0 then
  result:=ExtractFilename(path);
end;

Function TScriptInfo.ShouldDoErrorCheck(Const APath : String) : Boolean;
var
 i:integer;
 str,w:string;
begin
 i:=1;
 str:=options.SHPathDisable;
 repeat
  W:=trim(Parse(str,';',i));
  if (w<>'') and (filestartswith(w,Apath)) then
  begin
   result:=false;
   exit;
  end;
 until (I<1) or (I>Length(str));
 result:=not FileStartsWith(folders.RemoteFolder,apath);
end;

procedure TScriptInfo.OnBeginUpdate(Sender: TObject);
begin
 EditorEnterCS;
end;

procedure TScriptInfo.OnEndUpdate(Sender: TObject);
begin
 EditorLeaveCS(false);
end;

function TScriptInfo.GetCaption: String;
var f : string;
begin
 result:=path;
 if ms.readOnly then
  result:=result+' (Read Only)';
 f:=GetFTPSession;
 if f<>'' then
  result:='(Remote: '+f+') '+GetFTPFolder+
   ExtractFilename(path);
end;

initialization
 PerlTemplates:=TMemoCodeTemplates.Create(nil,TMemoCodeTemplate);
finalization
 PerlTemplates.free;
end.