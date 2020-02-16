unit ParsersMdl;  //Module

interface

uses
  SysUtils, Classes, dcparser, dcsystem, dcSyntax,OptFolders,janXMLTree,Windows,
  hyperstr, OptOptions,graphics, HKPerlParser,HakaGeneral;

type
  TParsersMod = class(TDataModule)
    ASP: TSyntaxParser;
    HTML: THTMLParser;
    Sql: TSqlParser;
    Pascal: TDelphiParser;
    C: TCPPParser;
    Python: TPythonParser;
    Assembler: TSyntaxParser;
    Java: TSyntaxParser;
    Ini: TSyntaxParser;
    CSS1: TSyntaxParser;
    CSS2: TSyntaxParser;
    Clipper: TSyntaxParser;
    FoxPro: TSyntaxParser;
    MSDOSBat: TSyntaxParser;
    Fortran: TSyntaxParser;
    Awk: TSyntaxParser;
    PHP: TSyntaxParser;
    Oberon: TSyntaxParser;
    Modula2: TSyntaxParser;
    MicrosoftIDL: TSyntaxParser;
    TclTK: TSyntaxParser;
    UnixShell: TSyntaxParser;
    RC: TSyntaxParser;
    XML: TSyntaxParser;
    XMLScripts: TSyntaxParser;
    VisualBasic: TSyntaxParser;
    None: TSyntaxParser;
    JavaScriptHTML: TSyntaxParser;
    VBScriptHTML: TSyntaxParser;
    VBScript: TVBScriptParser;
    HeadParser: TSyntaxParser;
    Perl: THKPerlParser;
    JavaScript: TSyntaxParser;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    PerlExt : TStringList;
    SyntaxNames : TStringList;
    procedure GetExt;
    procedure MakeParserList(ext, pars: String; def : boolean);
    { Private declarations }
  public
    Parsers,Extensions : TStringList;
    FileTypes,FileExt : TStringList;
    Procedure SetSyntax(Options : TOptiOptions);
    function GetDefaultDelimiters(const Ext: string) : string;
    function GetParser(const Ext: string): TSimpleParser;
    Function IsPerl(const path : string) : Boolean;
    Function GetParserName(i : Integer) : String;
    Function GetParserNameByObject(ob : TObject) : string;
    Function GetLanguageList(List : TStrings; Associated : Boolean) : TObject;
  end;

var
  ParsersMod: TParsersMod;

implementation

uses
  Dialogs,scriptinfounit;

{$R *.dfm}

Procedure TParsersMod.MakeParserList(ext,pars : String; def : boolean);
var
 i,c:integer;
 s:string;
 list,alist : TList;
 isperl : boolean;
begin
 ext:=Trim(ext);
 pars:=Trim(pars);
 List:=TList.Create;
 isperl:=false;
 i:=1;
 repeat
  s := Parse(pars,' ',I);
  if (length(s)=0) then continue;
  if uppercase(s)='PERL' then isperl:=true;
  c:=Parsers.indexof(s);
  if c=-1
   then MessageDlg('Parser.xml: '+s+' is not a valid parser', mtWarning, [mbOK], 0)
   else begin
    list.Add(parsers.objects[c]);
   end;
 until (I<1) or (I>Length(pars));

 if def then
 begin
  Extensions.AddObject('',list);
  exit;
 end;

 I := 1;
 repeat
  s := Parse(ext,' ',I);
  if (length(s)=0) then continue;
  if (s[1]<>'.')
   then MessageDlg('Parser.xml: Found extension that does not start with a period.', mtWarning, [mbOK], 0)
   else
    begin
     c:=Extensions.IndexOf(s);
     if c<>-1
      then MessageDlg('Parser.xml: Found duplicate extension '+s, mtWarning, [mbOK], 0)
      else begin
       alist:=TList.Create;
       alist.Assign(list);
       Extensions.AddObject(s,alist);
       if isperl then
        perlext.Add(s);
      end;
    end;
 until (I<1) or (I>Length(ext));

 list.free;
end;

procedure TParsersMod.GetExt;
var
 xml : TjanXMLTree;
 xn,fxn,exn,pxn: TjanXMLNode;
 i:integer;
 list : TList;
begin
 XML:=TJanXMLTree.Create('ParserList','',nil);
 try
  xml.LoadFromFile(folders.ParsersFile);
  xn:=xml.getNamedNode('ParserList');
  pxn:=xn.getnamednode('default');
  if not assigned(pxn)
   then MessageDlg('Parser.xml: Could not find default parser.', mtWarning, [mbOK], 0)
   else MakeParserList('',pxn.Value,true);
  list:=TList.Create;
  xn.findNamedNodes('filetype',list);
  for i:=0 to list.Count-1 do
  begin
   fxn:=list[i];
   exn:=fxn.getnamednode('extensions');
   pxn:=fxn.getnamednode('parser');
   if assigned(exn) and assigned(pxn) then
    MakeParserList(exn.Value,pxn.value,false);
  end;
  list.free;

  i:=parsers.IndexOf('perl');
  if i=-1
   then MessageDlg('Parser.xml: No extensions for Perl!', mtWarning, [mbOK], 0)

 finally
  xml.free;
 end;
end;

procedure TParsersMod.DataModuleCreate(Sender: TObject);
var
 i:integer;
 s:string;
 sp : TSimpleParser;
begin
 Perl.LoadFiles(programPath+'Reserved words.txt',programPath+'Internal Functions.txt',programPath+'Heredoc Ignore.txt');
 FileTypes:=TStringList.Create;
 FileExt:=TStringList.Create;
 Parsers:=TStringList.Create;
 Parsers.Sorted:=true;
 Extensions:=TStringList.Create;
 Extensions.Sorted:=true;
 PerlExt:=TStringList.Create;
 PerlExt.Sorted:=true;
 SyntaxNames:=TStringList.Create;
 PerlExt.Sorted:=true;
 for i:=0 to ComponentCount-1 do
  if (Components[i] is TSimpleParser) and (components[i].Tag=0) then
  begin
   sp:=TSimpleParser(Components[i]);
   s:=sp.Name;
   Parsers.Addobject(s,sp);
  end;
 GetExt;
 with SyntaxNames do
 begin
  AddObject('Whitespace',TObject(0));
  AddObject('String',TObject(1));
  AddObject('Comment',TObject(2));
  AddObject('Identifier',TObject(3));
  AddObject('Integer',TObject(4));
  AddObject('Float',TObject(5));
  AddObject('Reserved words',TObject(6));
  AddObject('Delimiters',TObject(7));
  AddObject('Defines',TObject(8));
  AddObject('Regular Expressions',TObject(9));
  AddObject('Html tags',TObject(10));
  AddObject('Html params',TObject(11));
  AddObject('Breakpoint',TObject(12));
  AddObject('Error line',TObject(13));
  AddObject('Debugger',TObject(14));
  AddObject('Search result',TObject(15));
  AddObject('Bracket matching',TObject(16));
  AddObject('Script Whitespace',TObject(17));
  AddObject('Script Number',TObject(18));
  AddObject('Script Comment',TObject(19));
  AddObject('Script String',TObject(20));
  AddObject('Script ResWord',TObject(21));
  AddObject('Script Delimiters',TObject(22));
  AddObject('Emphasis',TObject(23));
  AddObject('System Variable',TObject(24));
  AddObject('Assembler',TObject(25));
  AddObject('RegExp Replacement',TObject(26));
  AddObject('Perl Declared Identifier',TObject(27));
  AddObject('Perl Internal Functions',TObject(28));
  AddObject('Pod',TObject(29));
  AddObject('Pod Tags',TObject(30));
  AddObject('Perl Variables',TObject(31));
  AddObject('URL',TObject(32));
 end;
end;

procedure TParsersMod.DataModuleDestroy(Sender: TObject);
var i:integer;
begin
 FileTypes.Free;
 FileExt.Free;
 Parsers.free;
 for i:=0 to Extensions.Count-1 do
  TList(Extensions.Objects[i]).Free;
 Extensions.free;
 PerlExt.Free;
 SyntaxNames.free;
end;

function TParsersMod.GetParserName(i: Integer): String;
begin
 if Parsers.Objects[i] is TSyntaxParser
  then result:=TSyntaxParser(Parsers.objects[i]).SyntaxScheme.Name
  else result:=Parsers[i];
 if result='' then result:='<none>';
end;

function TParsersMod.GetLanguageList(List: TStrings;
  Associated: Boolean): TObject;
var
 si : TScriptInfo;
 i:integer;
 ext : String;
 assoclist : TList;
 sp : TObject;
begin
 si:=ActiveScriptInfo;
 if not assigned(si) then
 begin
  List.clear;
  result:=nil;
  exit;
 end;
 ext:=ExtractFileExt(si.path);
 if length(ext)=0 then ext:='.';
 i:=extensions.indexof(ext);
 if i=-1 then i:=extensions.indexof('');
 assoclist:=TList(extensions.objects[i]);
 if associated
 then
  begin
   for i:=0 to assoclist.Count-1 do
   begin
    sp:=TObject(AssocList[i]);
    list.AddObject(GetParserNameByObject(sp),sp);
   end;
  end
 else
  begin
   for i:=0 to Parsers.Count-1 do
   begin
    if assoclist.IndexOf(parsers.Objects[i])=-1 then
     list.addobject(GetParserName(i),parsers.Objects[i]);
   end;
  end;
 result:=si.ms.SyntaxParser;
end;

function TParsersMod.GetParserNameByObject(ob: TObject): string;
begin
 if ob is TSyntaxParser
  then result:=TSyntaxParser(ob).SyntaxScheme.Name
  else result:=TComponent(ob).name;
 if result='' then result:='<none>';
end;

function TParsersMod.GetParser(const ext: string): TSimpleParser;
var
 i:integer;
 l:TList;
begin
 if length(ext)=0
  then i:=Extensions.indexof('.')
  else i:=Extensions.indexof(ext);
 if i<0 then i:=Extensions.indexof('');
 if i>=0 then
 begin
  l:=TList(Extensions.objects[i]);
  if l.Count>0 then
   result:=TSimpleParser(l[0]);
 end
 else
  result:=None;
end;

function TParsersMod.IsPerl(const path: string): Boolean;
var ext : string;
begin
 ext:=extractfileext(path);
 if length(ext)=0 then ext:='.';
 result:=perlext.IndexOf(ext)>=0;
end;

function TParsersMod.GetDefaultDelimiters(const Ext: string): string;
begin
 result:='/+*=,;.^~|<>(){}[]';
end;

procedure TParsersMod.SetSyntax(Options : TOptiOptions);
var
  i,j,p,ind:integer;
  fl: TFontList;
  ai : TAttrItem;
  fs : TFontStyles;
begin
 for i:=0 to ComponentCount-1 do
  if (Components[i] is TSyntaxParser) then
  begin
    TSyntaxParser(Components[i]).DefaultAttr.Font.Name:=options.FontName;
    TSyntaxParser(Components[i]).DefaultAttr.Font.size:=options.FontSize;
    fl:=TSyntaxParser(components[i]).SyntaxScheme.FontTable;
    for j:=0 to fl.Count-1 do
    begin
     ai:=fl.Items[j];
     p:=syntaxnames.IndexOf(ai.GlobalAttrID);
     if p<0 then continue;
     ind:=integer(syntaxnames.Objects[p]);
     with options.TS[Options.ActiveTextStyle].Data[ind] do
     begin
      ai.UseDefFont:=false;
      ai.UseDefBack:=false;

      if HasBackGround
       then ai.BackColor:=BackColor
       else ai.BackColor:=options.EditorColor;

      if options.FontAliased
       then fs:=[]
       else fs:=[fsStrikeOut];

      if Bold
       then include(fs,fsBold)
       else exclude(fs,fsBold);
      if Italic
       then include(fs,fsItalic)
       else exclude(fs,fsItalic);
      if Underline
       then include(fs,fsUnderline)
       else exclude(fs,fsUnderline);

      ai.Font.Style:=fs;
      ai.font.Color:=ForeColor;
      ai.font.Size:=options.FontSize;
      ai.Font.Name:=options.FontName;
     end;
    end;
    TSyntaxParser(components[i]).SyntaxScheme.SchemeChanged;
  end;
end;

end.