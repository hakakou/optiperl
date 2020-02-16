{***************************************************************
 *
 * Unit Name: OptOptions
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptOptions;  //Unit
{$I REG.INC}

interface
uses sysutils,classes,graphics,windows,Controls,Forms,dcSystem,hyperstr,variants,PerlHelpers,
     dcmemo,dcstring,dialogs,hakaGeneral,hakamessagebox,registry,OptFolders,PerlApi,
     HakaHyper,jclfileutils,hakafile,hakawin,jclRegistry,OptMessage,
     hyperfrm,HKOptions,inifiles,dcControls,typinfo,HKDebug,UXTheme,OptProcs;

const
 OptiPerlBuild = 62;
 MaxStyles = 5;
 OptiLastLayout = 'Last session';

type
 TOptiMemoOptions = (msPrimary,msModal);
 TOptiRelease = (orStan,orPro,orCom,orUnreg);
 TOptiMemoSet = Set of TOptiMemoOptions;

 TVTextStyle = record
   HasBackGround: Boolean;
   BackColor: Tcolor;
   ForeColor: TColor;
   Bold:  Boolean;
   Italic: Boolean;
   UnderLine: Boolean;
   Extra : String;
 end;

 TVTextStyleArr = Record
  Name : String[50];
  Data : array[0..32] of TVTextStyle;
  //see also end of this file and parsersmod and optionsform
 end;

  TProjOpts = Class(THKOptions)
  Protected
   Procedure SetDefaults; Override;
  published
   property Session : String index 0 read GetString write SetString;
   property LocalPath : String index 1 read GetString write SetString;
   property RemotePath : String index 2 read GetString write SetString;
   property OverrideProj : Boolean index 3 read GetBool write SetBool;
   property IntServerRootPath : String index 4 read GetString write SetString;
   property AccessLogFile : String index 5 read GetString write SetString;
   property ErrorLogFile : String index 6 read GetString write SetString;
   property ExtServerAliases : String index 7 read GetString write SetString;
   property ExtServerRoot : String index 8 read GetString write SetString;
   property DisplayNonPublished : boolean index 9 read GetBool write SetBool;
   property Host : String index 10 read GetString write SetString;
   property PerlDBOpts: String index 11 read GetString write SetString;
   property PerlSearchDir: String index 12 read GetString write SetString;
   property DefaultScriptFolder: String index 13 read GetString write SetString;
   property DefaultHtmlFolder: String index 14 read GetString write SetString;
   property IntServerAliases: String index 15 read GetString write SetString;
   property Layout: String index 16 read GetString write SetString;
   property Data0: String index 17 read GetString write SetString;
   property Data1: String index 18 read GetString write SetString;
   property Data2: String index 19 read GetString write SetString;
   property Data3: String index 20 read GetString write SetString;
   property Data4: String index 21 read GetString write SetString;
   property Data5: String index 22 read GetString write SetString;
   property Data6: String index 23 read GetString write SetString;
   property Data7: String index 24 read GetString write SetString;
   property Data8: String index 25 read GetString write SetString;
   property Data9: String index 26 read GetString write SetString;
   property RestoreFiles : Boolean index 27 read GetBool write SetBool;
   property LastOpenFiles : String index 28 read GetString write SetString;
   property LastOpenFile : String index 29 read GetString write SetString;
  end;


 TOptiOptions = Class(THKOptions)
 Private
  Function LoadCustomStyle(Ini: TInifile; Style : Integer) : Boolean;
 Protected
  Procedure LoadCustomSettings(Ini : TInifile); Override;
  Procedure SaveCustomSettings(Ini : TInifile); Override;
  Procedure SetDefaults; Override;
  function GetPrjString(Index: Integer): String;
  function GetMUString(Index: Integer): String;
  function GetHost(index : Integer) : String;
 Public
  //not saved
  FileFilters : String; //read from File Dialog Filters.txt
  PrintingNow : Boolean;  //to synchronize edmagic with printer
  SimpleMemo : BOolean; //evaluted after setting options using FindOutSimpleMemo
  SyncScroll : Boolean; //Selected at run time
  MemTrace,CBTTest,RunTest,LogExceptions : Boolean; //loaded from the parameter list
  FTPLog : Boolean; //loaded from the parameter list
  DebSyntaxCheck : Boolean; //loaded from the parameter list
  ComboBarWidths : Integer; //Now this is static

  TS : Array[0..MaxStyles-1] of TVTextStyleArr;
  procedure ApplyStyle(mem : TDCMemo);
  procedure FindOutSimpleMemo;
  procedure Assign(Source: TPersistent); override;
  Procedure SetDefTextStyle(i : INteger);
  Function ToggleBoolOption(Const Name : String) : Boolean;
  Function SetAnOption(Const NameValue : String) : Boolean;
  Constructor Create;
  Procedure CheckImportant;
 Published
  //opti options
  property Warnings : Integer index 0 read GetInt write SetInt;
  // {0=none 1=useful 2=all}
  property Tainting : Boolean index 1 read GetBool write SetBool;
  property PathToPerl : String index 3 read GetString write SetString;
  property DefaultScript: String index 4 read GetString write SetString;
  property DefaultHtml : string index 5 read GetString write SetString;
  property DefaultScriptFolder : String index 6 read GetPrjString write SetString;
  property DefaultHtmlFolder : String index 7 read GetPrjString write SetString;
  property RootDirList : string index 10 read GetString write SetString;
  property LeaveUnlessEmpty : Boolean index 12 read GetBool write SetBool;

  //overriden by project
  //if changed will need to set GetPrjString
  property AccessLogFile : string index 8 read GetPrjString write SetString;
  property ErrorLogFile : string index 9 read GetPrjString write SetString;
  property Host : String index 2 read GetHost write SetString;
  property RootDir : String index 11 read GetPrjString write SetString;
  property ExtServerAliases : String index 13 read GetPrjString write SetString;
  property ExtServerRoot : String index 14 read GetPrjString write SetString;
  property PerlDBOpts: String index 206 read GetPrjString write SetString;
  property IntServerAliases: String index 222 read GetPrjString write SetString;
  //end

  property RunWithServer : Boolean index 15 read GetBool write SetBool;
  property ShowTipsStartup : Boolean index 16 read GetBool write SetBool;
  property PerlDLL : String index 17 read GetString write SetString;
  property MaxReadFromLogs : integer index 18 read GetInt write SetInt;
  property RunTimeOut : Integer index 19 read GetInt write SetInt;
  property ServerPort : Integer index 20 read GetInt write SetInt;

  property PerlSearchDir : string index 21 read GetPrjString write SetString;
  property BrowserFocus : Boolean index 22 read GetBool write SetBool;
  property AssocList : String index 23 read GetString write SetString;
  property StartPath : string index 24 read GetString write SetString;
  property StartPathList : string index 25 read GetString write SetString;
  property DoBracketSearch : boolean index 26 read GetBool write SetBool;
  property DoBracketMouseSearch : boolean index 27 read GetBool write SetBool;
  property ExplorerRecentList : string index 28 read GetString write SetString;
  property SecondBrowser : String index 29 read GetString write SetString;
  property RecentItems : Integer index 30 read GetInt write SetInt;
  property StartupLastOpen: Boolean index 31 read GetBool write SetBool;
  property LastOpenFiles : String index 32 read GetString write SetString;
  property CheckSyntax:boolean index 33 read GetBool write SetBool;
  property TrayBarIcon:boolean index 34 read GetBool write SetBool;
  property LastOpenFile : String index 35 read GetString write SetString;
  property IncGutter : Boolean index 36 read GetBool write SetBool;
  property ExtServerPort : Integer index 37 read GetInt write SetInt;
  property LiveEvalDelay : Integer index 38 read GetInt write SetInt;
  property LastOpenProject : String index 39 read GetString write SetString;
  property KeybExtended : boolean index 40 read GetBool write SetBool;
  property DefaultLineEnd : Integer index 41 read GetInt write SetInt;
  //Windows = 0  Unix = 1   Mac=2
  property Layout : String index 42 read GetString write SetString;

  //Editor Options
  property BlockIndent: Integer index 43 read GetInt write SetInt;
  property TabStopsEdit: String index 44 read GetString write SetString;
  property AutoIndent : Boolean index 45 read GetBool write SetBool;
  property SmartTab: Boolean index 46 read GetBool write SetBool;
  property BackUnindent: Boolean index 47 read GetBool write SetBool;
  property PersistentBlock : Boolean index 48 read GetBool write SetBool;
  property OverwriteBlock : Boolean index 49 read GetBool write SetBool;
  property DblClickEdit: Boolean index 50 read GetBool write SetBool;
  property FindText: Boolean index 51 read GetBool write SetBool;
  property SyntaxHighlight: Boolean index 52 read GetBool write SetBool;
  property OverCaret: Boolean index 53 read GetBool write SetBool;
  property DisableDrag: Boolean index 54 read GetBool write SetBool;
  property ShowLineNum: Boolean index 55 read GetBool write SetBool;
  property ShowLineNumGut: Boolean index 56 read GetBool write SetBool;
  property GroupUndo: Boolean index 57 read GetBool write SetBool;
  property CursorEof: Boolean index 58 read GetBool write SetBool;
  property BeyondEol: Boolean index 59 read GetBool write SetBool;
  property SelectEol: Boolean index 60 read GetBool write SetBool;
   //DisplaySheet: TTabSheet
  property MarginVisible: Boolean index 61 read GetBool write SetBool;
  property MarginColor: TColor index 62 read GetColor write SetColor;
  property MarginStyle: TPenStyle index 63 read GetPen write SetPen;
  property MarginWidth: Integer index 64 read GetInt write SetInt;
  property MarginPos: Integer index 65 read GetInt write SetInt;
  property GutterVisible: Boolean index 66 read GetBool write SetBool;
  property GutterColor: TCOlor index 67 read GetColor write SetColor;
  property GutterStyle: TBrushStyle index 68 read GetBrush write SetBrush;
  property GutterWidth : Integer index 69 read GetInt write SetInt;
  property FontName : String index 70 read GetString write SetString;
  property FontSize : Integer index 71 read GetInt write SetInt;
  property EditorColor : TColor index 72 read GetColor write SetColor;
  property WordWrap : Boolean index 73 read GetBool write SetBool;
  property TabCharacter : Boolean index 74 read GetBool write SetBool;
  property LineSeparator : Boolean index 75 read GetBool write SetBool;
  property LineSepColor : TColor index 76 read GetColor write SetColor;
  property LineSepStyle : TPenStyle index 77 read GetPen write SetPen;
  property LineSepWidth : Integer index 78 read GetInt write SetInt;
  property FoldGutColor : TColor index 79 read GetColor write SetColor;
  property FoldEnable : Boolean index 80 read GetBool write SetBool;
  property FoldBrackets : Boolean index 81 read GetBool write SetBool;
  property FoldParenthesis : Boolean index 82 read GetBool write SetBool;
  property FoldHereDoc : Boolean index 83 read GetBool write SetBool;
  property FoldPod : Boolean index 84 read GetBool write SetBool;
  property FoldDefBrackets : Boolean index 85 read GetBool write SetBool;
  property FoldDefParenthesis : Boolean index 86 read GetBool write SetBool;
  property FoldDefHereDoc : Boolean index 87 read GetBool write SetBool;
  property FoldDefPod : Boolean index 88 read GetBool write SetBool;
  property ShowSpecialSymbols : Boolean index 89 read GetBool write SetBool;
  property UseMonoFont : Boolean index 90 read GetBool write SetBool;

  property LHVisible : Boolean index 91 read GetBool write SetBool;
  property LHWidth : Integer index 92 read GetInt write SetInt;
  property LHLineColor : TColor index 93 read GetColor write SetColor;
  property LHLineStyle : TPenStyle index 94 read GetPen write SetPen;
  property LHBackColor : TColor index 95 read GetColor write SetColor;
  property LHBackStyle: TBrushStyle index 96 read GetBrush write SetBrush;

  property LineEnable : Boolean index 97 read GetBool write SetBool;
  property BoxEnable : Boolean index 98 read GetBool write SetBool;

  property Line1Visible : Boolean index 99 read GetBool write SetBool;
  property Line2Visible : Boolean index 100 read GetBool write SetBool;
  property Line3Visible : Boolean index 101 read GetBool write SetBool;
  property Line4Visible : Boolean index 102 read GetBool write SetBool;
  property Line5Visible : Boolean index 103 read GetBool write SetBool;
  property Line6Visible : Boolean index 104 read GetBool write SetBool;
  property Line1Width : Integer index 105 read GetInt write SetInt;
  property Line2Width : Integer index 106 read GetInt write SetInt;
  property Line3Width : Integer index 107 read GetInt write SetInt;
  property Line4Width : Integer index 108 read GetInt write SetInt;
  property Line5Width : Integer index 109 read GetInt write SetInt;
  property Line6Width : Integer index 110 read GetInt write SetInt;
  property Line1Pen : TPenStyle index 111 read GetPen write SetPen;
  property Line2Pen : TPenStyle index 112 read GetPen write SetPen;
  property Line3Pen : TPenStyle index 113 read GetPen write SetPen;
  property Line4Pen : TPenStyle index 114 read GetPen write SetPen;
  property Line5Pen : TPenStyle index 115 read GetPen write SetPen;
  property Line6Pen : TPenStyle index 116 read GetPen write SetPen;
  property Line1Color : TColor index 117 read GetColor write SetColor;
  property Line2Color : TColor index 118 read GetColor write SetColor;
  property Line3Color : TColor index 119 read GetColor write SetColor;
  property Line4Color : TColor index 120 read GetColor write SetColor;
  property Line5Color : TColor index 121 read GetColor write SetColor;
  property Line6Color : TColor index 122 read GetColor write SetColor;

  property BoxBrackets : Boolean index 123 read GetBool write SetBool;
  property BoxParen : Boolean index 124 read GetBool write SetBool;
  property BoxHereDoc : Boolean index 125 read GetBool write SetBool;
  property BoxPod : Boolean index 126 read GetBool write SetBool;
  property BoxHereDocColor : TColor index 127 read GetColor write SetColor;
  property BoxPodColor : TColor index 128 read GetColor write SetColor;
  property BoxHereDocBrush: TBrushStyle index 129 read GetBrush write SetBrush;
  property BoxPodBrush: TBrushStyle index 130 read GetBrush write SetBrush;

  property BoxBr1Visible : Boolean index 131 read GetBool write SetBool;
  property BoxBr2Visible : Boolean index 132 read GetBool write SetBool;
  property BoxBr3Visible : Boolean index 133 read GetBool write SetBool;
  property BoxBr4Visible : Boolean index 134 read GetBool write SetBool;
  property BoxBr5Visible : Boolean index 135 read GetBool write SetBool;
  property BoxBr6Visible : Boolean index 136 read GetBool write SetBool;
  property BoxBr1Curve : Integer index 137 read GetInt write SetInt;
  property BoxBr2Curve : Integer index 138 read GetInt write SetInt;
  property BoxBr3Curve : Integer index 139 read GetInt write SetInt;
  property BoxBr4Curve : Integer index 140 read GetInt write SetInt;
  property BoxBr5Curve : Integer index 141 read GetInt write SetInt;
  property BoxBr6Curve : Integer index 142 read GetInt write SetInt;
  property BoxBr1Brush : TBrushStyle index 143 read GetBrush write SetBrush;
  property BoxBr2Brush : TBrushStyle index 144 read GetBrush write SetBrush;
  property BoxBr3Brush : TBrushStyle index 145 read GetBrush write SetBrush;
  property BoxBr4Brush : TBrushStyle index 146 read GetBrush write SetBrush;
  property BoxBr5Brush : TBrushStyle index 147 read GetBrush write SetBrush;
  property BoxBr6Brush : TBrushStyle index 148 read GetBrush write SetBrush;
  property BoxBr1Color : TColor index 149 read GetColor write SetColor;
  property BoxBr2Color : TColor index 150 read GetColor write SetColor;
  property BoxBr3Color : TColor index 151 read GetColor write SetColor;
  property BoxBr4Color : TColor index 152 read GetColor write SetColor;
  property BoxBr5Color : TColor index 153 read GetColor write SetColor;
  property BoxBr6Color : TColor index 154 read GetColor write SetColor;

  property BoxPar1Visible : Boolean index 155 read GetBool write SetBool;
  property BoxPar2Visible : Boolean index 156 read GetBool write SetBool;
  property BoxPar3Visible : Boolean index 157 read GetBool write SetBool;
  property BoxPar4Visible : Boolean index 158 read GetBool write SetBool;
  property BoxPar5Visible : Boolean index 159 read GetBool write SetBool;
  property BoxPar6Visible : Boolean index 160 read GetBool write SetBool;
  property BoxPar1Curve : Integer index 161 read GetInt write SetInt;
  property BoxPar2Curve : Integer index 162 read GetInt write SetInt;
  property BoxPar3Curve : Integer index 163 read GetInt write SetInt;
  property BoxPar4Curve : Integer index 164 read GetInt write SetInt;
  property BoxPar5Curve : Integer index 165 read GetInt write SetInt;
  property BoxPar6Curve : Integer index 166 read GetInt write SetInt;
  property BoxPar1Brush : TBrushStyle index 167 read GetBrush write SetBrush;
  property BoxPar2Brush : TBrushStyle index 168 read GetBrush write SetBrush;
  property BoxPar3Brush : TBrushStyle index 169 read GetBrush write SetBrush;
  property BoxPar4Brush : TBrushStyle index 170 read GetBrush write SetBrush;
  property BoxPar5Brush : TBrushStyle index 171 read GetBrush write SetBrush;
  property BoxPar6Brush : TBrushStyle index 172 read GetBrush write SetBrush;
  property BoxPar1Color : TColor index 173 read GetColor write SetColor;
  property BoxPar2Color : TColor index 174 read GetColor write SetColor;
  property BoxPar3Color : TColor index 175 read GetColor write SetColor;
  property BoxPar4Color : TColor index 176 read GetColor write SetColor;
  property BoxPar5Color : TColor index 177 read GetColor write SetColor;
  property BoxPar6Color : TColor index 178 read GetColor write SetColor;

  property CursorOnTabs : Boolean index 179 read GetBool write SetBool;
  property ActiveTextStyle : Integer index 180 read GetInt write SetInt;
  property EnableHHHEEE : Boolean index 181 read GetBool write SetBool;

  property TabVisible : Boolean index 182 read GetBool write SetBool;
  property TabWidth : Integer index 183 read GetInt write SetInt;
  property TabColor : TColor index 184 read GetColor write SetColor;
  property TabStyle : TPenStyle index 185 read GetPen write SetPen;
  property TrimWhiteSpace : Integer index 186 read GetInt write SetInt;

  property PrintMarginTop : Real index 187 read GetReal write SetReal;
  property PrintMarginBottom : Real index 188 read GetReal write SetReal;
  property PrintMarginLeft : Real index 189 read GetReal write SetReal;
  property PrintMarginRight : Real index 190 read GetReal write SetReal;
  property PrintOvLines : Boolean index 191 read GetBool write SetBool;
  property PrintSyntax : Boolean index 192 read GetBool write SetBool;
  property PrintLines : Boolean index 193 read GetBool write SetBool;
  property PrintBoxes : Boolean index 194 read GetBool write SetBool;
  property PrintOvLinesWidth : Integer index 195 read GetInt write SetInt;
  property PrintLinesPerPage : Integer index 196 read GetInt write SetInt;
  property LineLookAhead : Integer index 197 read GetInt write SetInt;
  property BoxLookAhead : Integer index 198 read GetInt write SetInt;
  property PrintOnlySolid : Boolean index 199 read GetBool write SetBool;

  property CodeComEnable : Boolean index 200 read GetBool write SetBool;
  property CodeComHints : Boolean index 201 read GetBool write SetBool;

  property SHEditorErrors : Boolean index 202 read GetBool write SetBool;
  property SHEditorWarnings : Boolean index 203 read GetBool write SetBool;
  property SHExplorerErrors : Boolean index 204 read GetBool write SetBool;
  property SHExplorerWarnings : Boolean index 205 read GetBool write SetBool;
  property SHErrorStyle : TPenStyle index 207 read GetPen write SetPen;
  property SHWarningStyle : TPenStyle index 208 read GetPen write SetPen;
  property SHErrorColor : TColor index 209 read GetColor write SetColor;
  property SHWarningColor : TColor index 210 read GetColor write SetColor;

  property RemDebPort : Integer index 211 read GetInt write SetInt;
  property IntServerFeed : Boolean index 212 read GetBool write SetBool;
  property StandardLayouts : Boolean index 213 read GetBool write SetBool;
  property UndoLevel : Integer index 214 read GetInt write SetInt;
  property DefPerlExtension : string index 215 read GetString write SetString;
  property MaxSearchResults : Integer index 216 read GetInt write SetInt;
  property RunRemUpload : Boolean index 217 read GetBool write SetBool;
  property RunRemHost : Boolean index 218 read GetBool write SetBool;
  property CodeExplorerFontName : String index 219 read GetString write SetString;
  property CodeExplorerFontSize : Integer index 220 read GetInt write SetInt;
  property CodeExplorerHeight : Integer index 221 read GetInt write SetInt;
  //next 222 used
  property ExplorerUpdateLag : Integer index 223 read GetInt write SetInt;
  property CheckUpdateLag : Integer index 224 read GetInt write SetInt;
  property SHPathDisable : String index 225 read GetString write SetString;
  property TemplateFolder : String index 226 read GetMUString write SetString;
  property CommonFolder : String index 227 read GetMUString write SetString;
  property SCDecIdent : Boolean index 228 read GetBool write SetBool;
  property HighLightURL : Boolean index 229 read GetBool write SetBool;
  property CodeComHTML : Boolean index 230 read GetBool write SetBool;
  property DispFullExtension : Boolean index 231 read GetBool write SetBool;
  property FoldLastLine : Boolean index 232 read GetBool write SetBool;
  property FontAliased : Boolean index 233 read GetBool write SetBool;
  property CodeLibPrompt : Boolean index 234 read GetBool write SetBool;
  property SelBackColor : TColor index 235 read GetColor write SetColor;
  property SelColor : TColor index 236 read GetColor write SetColor;
  property EditorDelimiters : String index 237 read GetString write SetString;
  property HintEditorFont : Boolean index 238 read GetBool write SetBool;
  property AutoEvaluation : Boolean index 239 read GetBool write SetBool;
  property PrintFontName : String index 240 read GetString write SetString;
  property PrintComp : Boolean index 241 read GetBool write SetBool;
  property LastFTPSelect : String index 242 read GetString write SetString;
  property SCVarDiff : Boolean index 243 read GetBool write SetBool;
  property CloseTabDoubleClick : Boolean index 244 read GetBool write SetBool;
  property DockingStyle : Integer index 245 read GetInt write SetInt;
  property DockInvertCtrl : Boolean index 246 read GetBool write SetBool;
  property DockCapHeight : Integer index 247 read GetInt write SetInt;
  property DockShowButtons : Boolean index 248 read GetBool write SetBool;
  property DockShowTaskBar : Boolean index 249 read GetBool write SetBool;
  property DockContextMenu : Boolean index 250 read GetBool write SetBool;
  property BackupName : String index 251 read GetString write SetString;
  property BackupEnable : Boolean index 252 read GetBool write SetBool;
  property BackupZip : Boolean index 253 read GetBool write SetBool;
  property KeepSessionsAlive : Boolean index 254 read GetBool write SetBool;
  property BackupPrjName : String index 255 read GetString write SetString;
  property DefPerlDBOpts : String index 256 read GetString write SetString;
  property PrintLineNumbers : boolean index 257 read GetBool write SetBool;
  property PrintFooter : boolean index 258 read GetBool write SetBool;
  property MultiLineTabs : boolean index 259 read GetBool write SetBool;
  property SessionKeepAliveInterval : Integer index 260 read GetInt write SetInt;
  property ShowRefreshDialog : boolean index 261 read GetBool write SetBool;
  property WordWrapMargin : boolean index 262 read GetBool write SetBool;
  property InOutPort : integer index 263 read GetInt write SetInt;
  property InOutRedirect: boolean index 264 read GetBool write SetBool;
  property ActiveDebScript : string index 265 read GetString write SetString;
  property NavDelimiters : String index 266 read GetString write SetString;
 end;

var
 Options : TOptiOptions = nil;
 ProjOpt : TProjOPts = nil;
 DebugMode : Boolean = false;
 ShouldTerminate : Boolean = false;
 OptiRel : TOptiRelease = orUnreg;

Procedure SetMemo(mem : TDCMemo; MemoSet: TOptiMemoSet);
Procedure SetMemoSource(mem : TMemoSource);

var
 CPUSpeed : Cardinal = 0;

implementation

var
 OptiMutex : Cardinal = 0;
 OneInstance : Boolean = true;

Procedure SetMemoSource(mem : TMemoSource);
var
 so : TStringsOptions;

    procedure SetSOStatus(ASO : TStringsOption; Status : Boolean);
    begin
     if status
      then include(so,ASO)
      else exclude(so,ASO);
    end;

begin
 With Options do begin
  mem.BlockIndent:=BlockIndent;
  mem.TabStops:=TabStopsEdit;
  mem.HighlightUrls:=HighLightURL;

  case TrimWhiteSpace of
   0: begin
       mem.LeaveSpacesAndTabs:=true;
       mem.LeaveInEmptyOnly:=false;
      end;
   1: begin
       mem.LeaveSpacesAndTabs:=true;
       mem.LeaveInEmptyOnly:=true;
      end;
   2: begin
       mem.LeaveSpacesAndTabs:=false;
       mem.LeaveInEmptyOnly:=false;
      end;
  end;

  mem.Delimeters:=EditorDelimiters;
  mem.DelimSet2:=StringToCharSet([#0..#31], NavDelimiters, true);
  so:=mem.Options;

  SetSoStatus(soForceCutCopy,false);
  SetSoStatus(soCreateBackups,false);
  SetSoStatus(soOptimalFill,false);
  SetSoStatus(soUsePrevIndent,true);
  SetSoStatus(soCursorAlwaysOnTabs,false);
  SetSoStatus(soSelectFoundText,false);
  SetSoStatus(soRetainColumn,true);
  SetSoStatus(soExcludeReadOnlyLines,false);
  SetSoStatus(soAutoIndent,AutoIndent);
  SetSoStatus(soSmartTab,SmartTAb);
  SetSoStatus(soBackUnindents,BackUnindent);
  SetSoStatus(soPersistentBlocks,PersistentBlock);
  SetSoStatus(soOverwriteBlocks,OverwriteBlock);
  SetSoStatus(soFindTextAtCursor,FindText);
  SetSoStatus(soGroupUndo,GroupUndo);
  SetSoStatus(soBeyondFileEnd,CursorEof);
  SetSoStatus(soCursorOnTabs,CursorOnTabs);
  SetsoStatus(soLimitEOL,not BeyondEol);
  setSoStatus(soUseTabCharacter,TabCharacter);
  mem.Options:=so;
 end;
end;

Procedure SetMemo(mem : TDCMemo; MemoSet: TOptiMemoSet);
var
 mo : TMemoOptions;

    procedure SetMOStatus(AMO : TMemoOption; Status : Boolean);
    begin
     if status
      then include(mo,AmO)
      else exclude(mo,AmO);
    end;

begin
 With Options do
 begin
  if msPrimary in MemoSet then
  begin
   mo:=mem.Options;
   SetMoStatus(moDrawMargin,MarginVisible);
   SetMoStatus(moDrawGutter,GutterVisible);
   SetMoStatus(moThumbTracking,true);  //static
   SetMoStatus(moDblClickLine,DblClickEdit);
   SetMoStatus(moColorSyntax,SyntaxHighlight);
   SetMoStatus(moLineNumbers,ShowLineNum);
   SetMoStatus(moOverwriteCaret,OverCaret);
   SetMoStatus(moLeftIndent,false); //static
   SetMoStatus(moDisableDrag,DisableDrag);
   SetMoStatus(moSelectOnlyText, not SelectEol);
   SetMoStatus(moLineNumbersOnGutter,ShowLineNumGut);
   SetMoStatus(moNotePadCursorStyle,true); //static
   SetMoStatus(moBreakWordAtMargin,true); //static
   SetMoStatus(moDrawSpecialSymbols,ShowSpecialSymbols);
   SetMoStatus(moDisableRightClickMove,false); //static
   SetMoStatus(moColoredLineStyle,false); //static
   SetMoStatus(moDisableInvertedSel,false); //static
   SetMoStatus(moHideInvisibleLines,FoldEnable);
   SetMoStatus(moDrawLineBookmarks,True); //static
   SetMoStatus(moShowScrollHint,false); //static
   SetMoStatus(moUseReadOnlyColor,False); //static
   SetMoStatus(moExtendedSel,False); //static
   SetMoStatus(moCenterOnBookmark,True); //static
   SetMoStatus(moTripleClick,True); //static
   SetMoStatus(moLimitLineNumbers,True); //static
   mem.WordWrap:=wordWrap;
   if LineSeparator
    then mem.LineSeparator.Options:=[moDrawLineSeparator]
    else mem.LineSeparator.Options:=[];
   mem.LineSeparator.Pen.style:=LineSepStyle;
   mem.LineSeparator.pen.Width:=LineSepWidth;
   mem.LineSeparator.pen.Color:=LineSepCOlor;

   if not options.TabVisible
    then mem.SpecialSymbols.TabChar:='¦'
    else mem.SpecialSymbols.tabchar:=#0;

   mem.marginpen.Color:=MarginColor;
   mem.MarginPen.Style:=MarginStyle;
   mem.MarginPen.Width:=MarginWidth;

   if (WordWrap) and (not WordWrapMargin) and (not PrintingNow) then
    begin
     if UseMonoFont
      then mem.MarginPos:=imax(mem.GetMaxCaretChar+1,30)
      else mem.MarginPos:=imax(Round(mem.GetMaxCaretChar * 0.70),30);
    end
   else
    mem.MarginPos:=MarginPos;
   mem.GutterWidth:=GutterWidth;
   mem.LineHighlight.Visible:=LHVisible;
   if lhwidth=1
    then mem.LineHighlight.shape:=shSingleLine
    Else mem.LineHighlight.shape:=shDoubleLine;
   mem.LineHighlight.Pen.Color:=LHLineColor;
   mem.LineHighlight.Pen.Style:=LHLineStyle;
   mem.LineHighlight.Brush.Color:=LHBackColor;
   mem.LineHighlight.Brush.Style:=LHBackStyle;
   mem.Options:=mo;
   SetMemoSource(TMemoSource(mem.memosource));
  end;

  mem.GutterBrush.Color:=GutterColor;
  mem.GutterBrush.Style:=GutterStyle;

  if msModal in MemoSet
   then mem.KeyMapping:='OptiEx' //for modal dialogs
   else mem.KeyMapping:='Opti';

   ApplyStyle(mem);
 end;
end;

function TOptiOptions.GetHost(index : Integer) : String;
begin
 if Streaming then
 begin
  result:=GetString(index);
  exit;
 end;

 result:=PR_GetOpenRemoteHost;
 if result='' then
 begin
  if not projOpt.OverrideProj
   then result:=GetString(index)
   else result:=ProjOpt.Host;
 end;
end;

function TOptiOptions.GetMUString(Index: Integer): String;
begin
 if OptiRel = orCom then
  Result:=GetString(index)
 else
  case index of
   226 : result:=ProgramPath+'templates';
   227 : result:=Folders.UserFolder;
  end;
end;

function TOptiOptions.GetPrjString(Index: Integer): String;
begin
 if (not projOpt.OverrideProj) or (streaming)
  then Result:=GetString(index)
  else
   case Index of
    21: result:=ProjOpt.PerlSearchDir;
    6 : result:=ProjOpt.DefaultScriptFolder;
    7 : result:=ProjOpt.DefaultHtmlFolder;
    206:result:=ProjOpt.PerlDBOpts;
    11: result:=ProjOpt.IntServerRootPath;
    8 : result:=ProjOpt.AccessLogFile;
    9 : result:=ProjOpt.ErrorLogFile;
    13: result:=ProjOpt.ExtServerAliases;
    14: result:=ProjOpt.ExtServerRoot;
    222 : result:=ProjOpt.IntServerAliases;
    else showmessage('Error 134');
   end;
end;

Procedure TOptiOptions.FindOutSimpleMemo;
begin
 SimpleMemo:=not BoxEnable;
end;

procedure TOptiOptions.ApplyStyle(mem : TDCMemo);
var
  i:integer;
  fs : TFontStyles;
begin
 FindOutSimpleMemo;
 {$IFDEF ALTDRAW}
  mem.MemoBackground.BkgndOption:=boEmpty;
 {$ENDIF}
 mem.MemoBackground.GradientBeginColor:=editorcolor;
 mem.GutterBackColor:=LighterColor(GutterColor,-25,0,255);
 mem.GutterLineColor:=LighterColor(GutterColor,15,0,255);
 mem.LineNumBackColor:=EditorColor;
 mem.Color:=FoldGutColor;
 {$IFDEF ALTDRAW}
  if simplememo then
 {$ENDIF}
  begin
   mem.MemoBackground.BkgndOption:=boNone;
   mem.Color:=editorcolor;
  end;

 mem.FoldGutterColor:=FoldGutColor;
 mem.UseMonoFont:=UseMonoFont;
 mem.UsePrinterFont:=not UseMonoFont;
 mem.Font.Color:=ts[ActiveTextStyle].Data[0].Forecolor;
 mem.Font.Name:=FontName;
 mem.Font.Size:=FontSize;
 mem.MatchBackColor:=ts[ActiveTextStyle].Data[15].BackColor;
 mem.MatchColor:=ts[ActiveTextStyle].Data[15].ForeColor;
 mem.SelColor:=selcolor;
 mem.SelBackColor:=selbackcolor;

 if FontAliased
  then mem.Font.style:=mem.Font.style-[fsStrikeOut]
  else mem.Font.style:=mem.Font.style+[fsStrikeOut];

  for i:=0 to high(ts[ActiveTextStyle].Data) do
   with ts[ActiveTextStyle].Data[i] do
   begin
   if i>mem.TextStyles.count -1 then
    mem.TextStyles.AddStyle(inttostr(i),0,0);
    with mem.textstyles[i] do
    begin
     UpperCase:=false;
     UseMemoColor:=false;
     UseMemoFont:=true;
     UpdateMemoColors:=mcNone;
     if FontAliased
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
     if HasBackGround
      then color:=BackColor
      else
       begin
        {$IFDEF ALTDRAW}
         if SimpleMemo
          then color:=EditorColor
          else color:=FoldGutColor;
        {$ELSE}
         color:=EditorColor;
        {$ENDIF}
       end;
     font.Style:=fs;
     font.Color:=ForeColor;
     font.Size:=FontSize;
     font.Name:=FontName;
    end;
   end;
end;

procedure CheckLoadFile;
var
 files : TStringList;
 h : THandle;
begin
 Files:=TStringList.Create;
 try
  GetComLines(Files,Nil,'/');
  if WaitForSingleObject(OptiMutex,INFINITE)=WAIT_OBJECT_0 then
  begin
   SetLoadFile(files);
   if shouldterminate then
   begin
    h:=FindWindow(PAnsiChar('TOptiMainForm'),nil);
    if h<>0 then
     SendMessage(h,HK_LoadFile,0,0);
   end;
   ReleaseMutex(optimutex);
  end;
 finally
  Files.free;
 end;
end;

procedure CheckParams;
var
 switches : TStringList;
begin
 Switches:=TStringList.Create;
 Switches.Sorted:=true;
 try
  GetComLines(nil,Switches,'/');
  if switches.count>0 then
  begin
   if switches.IndexOf('/deboutput')>=0 then
    begin
     Folders.deboutput:='c:\L_deboutput.log';
     Folders.Rdeboutput:='c:\R_deboutput.log';
    end
   else
    begin
     Folders.deboutput:='';
     Folders.Rdeboutput:='';
    end;

   if switches.IndexOf('/logmem')>=0
    then options.MemTrace:=true;
   if switches.IndexOf('/logftp')>=0
    then options.FtpLog:=true;
   if switches.IndexOf('/ct')>=0
    then options.CBTTest:=true;
   if switches.IndexOf('/rt')>=0
    then options.RunTest:=true;
   if switches.IndexOf('/logexceptions')>=0
    then options.LogExceptions:=true;
   if OPtions.CBTTest or options.RunTest then
    DeleteFile(pchar(folders.iniFile));
   DebugMode:=Options.RunTest or Options.MemTrace;
   options.DebSyntaxCheck:=switches.IndexOf('/logsyntax')>=0;
  end;
 finally
  switches.Free;
 end;
end;


{ TOptiOptions }

procedure TOptiOptions.Assign(Source: TPersistent);
begin
 inherited Assign(source);
 if source is TOptiOptions then
 begin
  TS:=TOptiOptions(Source).TS;
 end;
end;

procedure TOptiOptions.LoadCustomSettings(Ini: TInifile);
var i:integer;
begin
 for i:=0 to maxstyles-1 do
  if not loadCustomStyle(ini,i)
   then SetDefTextStyle(i);
end;

Function TOptiOptions.LoadCustomStyle(Ini: TInifile; Style : Integer) : Boolean;
var
 j,p:integer;
 n,s,section:string;
begin
  section:='TextStyle_'+inttostr(style);
  result:=ini.SectionExists(section);
  if result then
  begin
   ts[style].Name:=ini.readString(section,'Name','Style '+inttostr(style));
   for j:=0 to high(ts[style].data) do
   with ts[style].data[j] do
   begin
    s:=ini.ReadString(section,'Style_'+inttostr(j),'#FFFFFF #000000 0 0 0 0');
    p:=1;
    n:=parse(s,' ',p); backcolor:=HTMLToColor(n);
    n:=parse(s,' ',p); Forecolor:=HTMLToColor(n);
    n:=parse(s,' ',p); HasBackGround:=Str2Bool(n);
    n:=parse(s,' ',p); Bold:=Str2Bool(n);
    n:=parse(s,' ',p); Italic:=Str2Bool(n);
    n:=parse(s,' ',p); UnderLine:=Str2Bool(n);
    if (p>0) and (p<length(s))
     then extra:=copyFromToEnd(s,p)
     else extra:='';
   end;
  end;
end;

procedure TOptiOptions.SaveCustomSettings(Ini: TInifile);
var
 i,j:integer;
 s:string;
begin
 for i:=0 to maxstyles-1 do
 begin
  s:='TextStyle_'+inttostr(i);
  ini.WriteString(s,'Name',ts[i].Name);
  for j:=0 to high(ts[i].data) do
  with ts[i].data[j] do
  begin
   ini.WriteString(s,'Style_'+inttostr(j),trim(
    ColorToHtml(backcolor)+' '+
    ColorToHtml(Forecolor)+' '+
    bool2str(HasBackGround)+' '+
    bool2str(Bold)+' '+
    bool2str(Italic)+' '+
    bool2str(UnderLine)+' '+extra
   ));
  end;
 end;
end;

Function TOptiOptions.SetAnOption(Const NameValue : String) : Boolean;
var
 name,value : string;
begin
 result:=false;
 if not ParseWithEqual(namevalue,name,value) then exit;

 try
  SetPropValue(self,trim(name),trim(value));
  result:=true;
 except on exception do end;
end;

Function TOptiOptions.ToggleBoolOption(Const Name : String) : Boolean;
var
 PropInfo: PPropInfo;
 v:Variant;
begin
 result:=false;
 propinfo:=GetPropInfo(classinfo,name);
 if not assigned(propinfo) then exit;

 try
  v:=GetPropValue(self,name,false);
 except on exception do
  exit;
 end;

 if VarIsType(v,varBoolean) then
 begin
  SetOrdProp(self,PropInfo,not v);
  result:=true;
 end;
end;

Procedure TOptiOptions.SetDefTextStyle(i : INteger);
var
 s:String;
 ini : TIniFile;
begin
 s:=programPath+'Default Styles.ini';
 if fileexists(s) then
  begin
   ini:=TINiFile.Create(s);
   try
    LoadCustomStyle(ini,i);
   finally
    ini.free;
   end;
  end
 else
  MessageDlg('Cannot find file'+s+#13+#10+'Please install again.', mtError, [mbOK], 0);
end;

Procedure TOptiOptions.CheckImportant;
begin
 if AnsiSameText('/regserver',ParamStr(1)) or
    AnsiSameText('/unregserver',ParamStr(1)) then exit;

 if not fileexists(Options.pathtoperl) then
 begin
  MessageDlgMemo('OptiPerl requires Perl installed to function correctly.'+#13+#10+''+#13+#10+'If you have not installed Perl yet, please read "Setting Up" in'+#13+#10+'help for directions on how to install.'+#13+#10+''+#13+#10+'If Perl is already installed, please go to the Tools / Options'+#13+#10+'Dialog, end enter the path to Perl.', mtInformation, [mbOK], 0,3700);
  exit;
 end;

 if not fileexists(Options.PerlDLL) then
 begin
  MessageDlgMemo('OptiPerl requires Perl DLL library to function correcty.'+#13+#10+''+#13+#10+'Please set the correct path from Tools / Options Dialog / Perl'+#13+#10+'and restart OptiPerl.', mtError, [mbOK], 0,3600);
  exit;
 end;

 if not FindIfDLLOK(Options.PerlDLL) then
 begin
  MessageDlgMemo('OptiPerl does not support this version of perl DLL.'+#13+#10+''+#13+#10+'For plug-ins and the regular expression tester'+#13+#10+'to function, you will need perl 5.6 or above with'+#13+#10+'compile-time options: MULTIPLICITY && USE_ITHREADS.', mtError, [mbOK], 0,3500);
  exit;
 end;

 PerlApi.perlDllFile:=Options.perlDll;
 //PerlApi.perlDllFile:=ProgramPath+'perl58.dll';
end;

procedure TOptiOptions.SetDefaults;
var
 IsFast,IsMedium : Boolean;
 apache : String;
begin
 IsFast:=CPUSpeed>1000;
 IsMedium:=(CPUSpeed=0) or (CPUSpeed>500);

 //need Medium CPU
 SHEditorErrors:=IsMedium;
 SHEditorWarnings:=IsMedium;
 SHExplorerErrors:=IsMedium;
 SHExplorerWarnings:=IsMedium;
 FoldEnable:=IsMedium;

 //need Fast CPU
 LineEnable:=IsMedium;
 BoxEnable:=IsFast;

 ExplorerUpdateLag:=100;

 if IsFast then
  CheckUpdateLag:=1000
 else
 if IsMedium then
  CheckUpdateLag:=3000
 else
  CheckUpdateLag:=6000;

 //General
 LineLookAhead:=200;
 BoxLookAhead:=1000;

 if Usethemes
  then DockingStyle:=1
  else DockingStyle:=2;
 DockInvertCtrl:=false;
 DockCapHeight:=15;
 DockShowButtons:=true;
 DockShowTaskBar:=true;
 DockContextMenu:=true;
 PrintLineNumbers:=true;
 PrintFooter:=true;
 WordWrapMargin:=true;
 Backupname:='%F.~%E';
 BackupPrjName:='%F.~%E';
 BackupZip:=false;

 BackupEnable:=false;
 KeepSessionsAlive:=true;
 InOutPort:=9020;
 InOutRedirect:=false;

 MultiLineTabs:=false;
 ServerPort:=80;
 LastFTPSelect:='';
 CloseTabDoubleClick:=false;
 PrintingNow:=false;
 PrintComp:=true;
 EditorDelimiters:='''/+*=,;.^~|<>(){}[]-"';
 NavDelimiters:=' ''";(),{}';
 AutoEvaluation:=true;
 CodeLibPrompt:=true;
 SelColor:=clWhite;
 SelBackColor:=clNavy;
 SCVarDiff:=true;
 FontAliased:=true; //Win32MajorVersion<=4;
 FoldLastLine:=false;
 DispFullExtension:=false;
 SCDecIdent:=true;
 HighLightURL:=false;
 SHPAthDisable:='';
 CodeExplorerFontSize:=8;
 CodeExplorerFontName:='Arial';
 CodeExplorerHeight:=18;
 RunRemUpload:=true;
 RunRemHost:=true;
 version:=optiperlbuild;
 UndoLevel:=300;
 DefPerlExtension:='pl';
 RemDebPort:=9010;
 StartPathList:='';
 StartPath:='';
 MaxSearchResults:=20000;
 CurrentVersion:=optiperlbuild;
 Warnings:=1;
 Tainting:=False;
 Host:='http://127.0.0.1/';
 DefPerlDBOpts:='RemotePort=%s:%s ReadLine=0';
 PerlDBOpts:='RemotePort=127.0.0.1:9010 ReadLine=0';
 PathToPerl := FindPerlPath;
 PerlSearchDir:=FastFindINCPath(PathToPerl);
 PerlDll:=FindDllPath(PathToPerl);
 templateFolder:=ProgramPath+'templates';
 if OptiRel=orCom
  then CommonFolder:=GetAppDataFolder(true,true,'OptiPerl')
  else CommonFolder:=Folders.UserFolder;

 DefaultScript:=ExcludeTrailingBackSlash(TemplateFolder)+'\perl\default.pl';
 DefaultHTML:=ExcludeTrailingBackSlash(TemplateFolder)+'\html\default.html';
 DefaultHtmlFolder:=Programpath+'webroot\';
 DefaultScriptFolder := DefaultHtmlFolder+'cgi-bin\';
 RootDir:=DefaultHtmlFolder;
 RootDirList:=DefaultHtmlFolder+#13#10;
 ExplorerRecentList:='c:\perl\';

 Apache:='c:\apache2\';
 if not directoryExists(apache) then
  Apache:='c:\apache\';
 AccessLogFile:=apache+'logs\access.log';
 ErrorLogFile:=apache+'logs\error.log';
 ExtServerRoot:=apache+'htdocs\';
 replaceC(apache,'\','/');
 ExtServerAliases:='/cgi-bin/='+apache+'cgi-bin/;/perl/='+apache+'perl/;';

 IntServerAliases:='';
 RunWithServer:=false;
 ShowTipsStartup:=true;
 MaxReadFromLogs:=16384;
 RunTimeOut:=10;
 OneInstance:=True;
 BrowserFocus:=true;
 assocList:=
  'pl='+pathtoperl+#13#10+
  'cgi='+pathtoperl+#13#10+
  'plx='+pathtoperl;
 DoBracketSearch:=true;
 DoBracketMouseSearch:=true;
 SecondBrowser:='';
 RecentItems:=15;
 LastOpenFiles:='';
 LastOpenFile:='';
 LastOpenProject:='';
 StartupLastOpen:=True;
 CheckSyntax:=false;
 TrayBarIcon:=true;
 IncGutter:=true;
 SyncScroll:=false;
 LiveEvalDelay:=1000;
 KeybExtended:=false;
 DefaultLineEnd:=0;
 ExtServerPort:=80;
 layout:=OptiLastLayout;
 ComboBarWidths:=250;

 //edit Options
 BlockIndent:=1;
 TabStopsEdit:= '5,9,13,17';
 AutoIndent :=true;
 SmartTab:=false;
 BackUnindent:=true;
 PersistentBlock :=false;
 OverwriteBlock :=true;
 DblClickEdit:=false;
 FindText:=true;
 CursorOnTabs:=false;
 SyntaxHighlight:=true;
 OverCaret:=false;
 DisableDrag:=false;
 ShowLineNum:=true;
 ShowLineNumGut:=true;
 GroupUndo:=true;
 CursorEof:=false;
 BeyondEol:=true;
 SelectEol:=false;
 TrimWhiteSpace:=2;

 MarginVisible:=true;
 MarginColor:=clGray;
 MarginStyle:=psSolid;
 MarginWidth:=1;
 MarginPos:=80;
 GutterVisible:=true;
 GutterColor:=clBtnFace;
 GutterStyle:= bsSolid;
 GutterWidth :=30;
 FontName :=DefMonospaceFontName;
 if AnsiCompareText(FontName,'Courier New')=0 then
  begin
   PrintFontName:='Arial Black';
   if screen.Fonts.IndexOf(PrintFontName)<0 then
    PrintFontName:='Verdana';
   if screen.Fonts.IndexOf(PrintFontName)<0 then
    PrintFontName:=FontName;
  end
 else //japan
  PrintFontName:=DefMonospaceFontName;

 FontSize :=10;
 EditorColor :=clWhite;
 WordWrap:=False;
 LineSeparator:=False;
 TabCharacter:=true;
 LineSepColor := clSilver;
 LineSepStyle := psSolid;
 LineSepWidth := 1;
 ShowSpecialSymbols:=false;

 UseMonoFont:=true;
 LHVisible:=false;
 LHWidth:=1;
 LHLineColor:=14803425;
 LHLineStyle:=psSolid;
 LHBackColor:=16777215;
 LHBackStyle:=bsClear;
 ActiveTextStyle:=0;

 FoldGutColor:=LighterColor(clBtnFace,40,0,245);

 FoldBrackets:=true;
 FoldParenthesis:=true;
 FoldHereDoc:=true;
 FoldPod:=true;
 FoldDefBrackets:=false;
 FoldDefParenthesis:=false;
 FoldDefHereDoc:=false;
 FoldDefPod:=true;

 Line1Visible:=False;
 Line2Visible:=True;
 Line3Visible:=True;
 Line4Visible:=True;
 Line5Visible:=True;
 Line6Visible:=True;
 Line1Width:=1;
 Line2Width:=1;
 Line3Width:=1;
 Line4Width:=2;
 Line5Width:=3;
 Line6Width:=3;
 Line1Pen:=psDot;
 Line2Pen:=psDot;
 Line3Pen:=psDash;
 Line4Pen:=psSolid;
 Line5Pen:=psSolid;
 Line6Pen:=psSolid;
 Line1Color:=16764057;
 Line2Color:=10079487;
 Line3Color:=16766207;
 Line4Color:=5636052;
 Line5Color:=11206655;
 Line6Color:=16766164;

 BoxBrackets:=true;
 BoxParen:=true;
 BoxHereDoc:=true;
 BoxPod:=true;

 BoxHereDocColor:=13948159;
 BoxPodColor:=16766207     ;
 BoxHereDocBrush:=bsDiagCross;
 BoxPodBrush:=bsBDiagonal     ;

 BoxBr1Visible:=True  ;
 BoxBr2Visible:=False ;
 BoxBr3Visible:=False ;
 BoxBr4Visible:=False ;
 BoxBr5Visible:=False ;
 BoxBr6Visible:=False ;
 BoxBr1Curve:=20      ;
 BoxBr2Curve:=20      ;
 BoxBr3Curve:=30      ;
 BoxBr4Curve:=30      ;
 BoxBr5Curve:=40      ;
 BoxBr6Curve:=40      ;
 BoxBr1Brush:=bsDiagCross ;
 BoxBr2Brush:=bsVertical  ;
 BoxBr3Brush:=bsHorizontal;
 BoxBr4Brush:=bsFDiagonal ;
 BoxBr5Brush:=bsCross     ;
 BoxBr6Brush:=bsBDiagonal ;
 BoxBr1Color:=16777172    ;
 BoxBr2Color:=13948159    ;
 BoxBr3Color:=10092543    ;
 BoxBr4Color:=13434828    ;
 BoxBr5Color:=16777164    ;
 BoxBr6Color:=16764057    ;

 BoxPar1Visible:=True     ;
 BoxPar2Visible:=True     ;
 BoxPar3Visible:=True     ;
 BoxPar4Visible:=True     ;
 BoxPar5Visible:=True     ;
 BoxPar6Visible:=True     ;
 BoxPar1Curve:=50         ;
 BoxPar2Curve:=60         ;
 BoxPar3Curve:=70         ;
 BoxPar4Curve:=80         ;
 BoxPar5Curve:=90         ;
 BoxPar6Curve:=100        ;
 BoxPar1Brush:=bsCross    ;
 BoxPar2Brush:=bsSolid    ;
 BoxPar3Brush:=bsSolid    ;
 BoxPar4Brush:=bsSolid    ;
 BoxPar5Brush:=bsSolid    ;
 BoxPar6Brush:=bsSolid    ;
 BoxPar1Color:=13959124   ;
 BoxPar2Color:=16766207   ;
 BoxPar3Color:=11206655   ;
 BoxPar4Color:=16766164   ;
 BoxPar5Color:=16764057   ;
 BoxPar6Color:=13959082   ;

 EnableHHHEEE:=false;

 TabVisible:=true;
 TabWidth:=1;
 TabColor:=clSilver;
 TabStyle:=psSolid;

 PrintMarginTop:=0.5;
 PrintMarginBottom:=0.5;
 PrintMarginLeft:=0.5;
 PrintMarginRight:=0.5;
 PrintOvLines:=false;
 PrintSyntax:=true;
 PrintLines:=true;
 PrintBoxes:=true;
 PrintOvLinesWidth:=3;
 PrintLinesPerPage:=70;
 PrintOnlySolid:=false;

 CodeComEnable:=Win32Platform=VER_PLATFORM_WIN32_NT;
 CodeComHints:=true;
 CodeComHTML:=false;
 HintEditorFont:=false;

 SHErrorStyle:=psSolid;
 SHWarningStyle:=psDot;
 SHErrorColor:=11184895;
 SHWarningColor:=15390976;

 SessionKeepAliveInterval:=60;
 ShowRefreshDialog:=true;

 IntServerFeed:=false;
 StandardLayouts:=false;
 ActiveDebScript:='';

 FindOutSimpleMemo;
end;

Constructor TOptiOptions.Create;
var i:integer;
begin
 inherited Create;
 for i:=0 to MaxStyles-1 do
  SetDefTextStyle(i);
end;

Procedure TProjOpts.SetDefaults;
begin
  Currentversion:=optiperlbuild;
  OptionsSection:='*Options*';
  Session:='';
  Layout:='(none)';
  RemotePath:='/';
  OverrideProj:=false;
  DisplayNonPublished:=True;
  Data0:='';
  Data1:='';
  Data2:='';
  Data3:='';
  Data4:='';
  Data5:='';
  Data6:='';
  Data7:='';
  Data8:='';
  Data9:='';
  RestoreFiles:=false;
  LastOpenFiles:='';
  LastOpenFile:='';

  if assigned(options) then
   begin
    options.Streaming:=true;
    LocalPath:=options.RootDir;
    IntServerRootPath:=options.RootDir;
    AccessLogFile:=options.AccessLogFile;
    ErrorLogFile:=options.ErrorLogFile;
    extserverAliases:=options.extserverAliases;
    IntserverAliases:=options.IntserverAliases;
    extserverRoot:=options.extserverRoot;
    Host:=Options.Host;
    PerldbOpts:=options.PerlDBOpts;
    PerlSearchDir:=options.PerlSearchDir;
    DefaultScriptFolder:=options.DefaultScriptFolder;
    DefaultHtmlFolder:=options.DefaultHtmlFolder;
    options.Streaming:=false;
   end
  else
   begin
    LocalPath:='';
    IntServerRootPath:='';
    AccessLogFile:='';
    ErrorLogFile:='';
    extserverAliases:='';
    IntserverAliases:='';
    extserverRoot:='';
    Host:='';
    PerldbOpts:='';
    PerlSearchDir:='';
    DefaultScriptFolder:='';
    DefaultHtmlFolder:='';
   end;
end;

Procedure GetFileDialogFilters;
var
 Sl : TStringList;
 i : Integer;
 s:string;
begin
 s:=ProgramPath+'File Dialog Filters.txt';
 if not fileexists(s) then exit;
 sl:=TStringList.Create;
 try
  sl.LoadFromFile(s);

  for i:=sl.Count-1 downto 0 do
  begin
   s:=Trim(sl[i]);
   if length(s)=0
    then sl.Delete(i)
    else sl[i]:=s;
  end;
  if (sl.Count>1) and (not odd(sl.count)) then
  with options do
  begin
   filefilters:=sl.text;
   setlength(filefilters,length(filefilters)-2);
   replaceSC(filefilters,#13#10,'|',false);
  end;
 finally
  sl.free;
 end;
end;

initialization
 HKLog('Options Start');

 OneInstance:=RegReadBoolDef(HKEY_LOCAL_MACHINE,OptiRegKey,OptiRegKey_OneInstance,true);
 OptiMutex:=CreateMutex(nil,false,'OptiXarkaSysRegWin');

 if (GetLastError=ERROR_ALREADY_EXISTS)
  then ShouldTerminate:=OneInstance
  else ShouldTerminate:=false;

 CheckLoadFile;

 if not shouldterminate then
 begin
  InitThemeLibrary;
  CPUSpeed:=GetCPUSpeed;
  ProjOpt:=TProjOpts.Create;
  Options:=TOptiOptions.Create;
  try
   options.loadfromFile(folders.OptFile);
  except
   on Exception do Options.SetDefaults;
  end;
  CheckParams;
  GetFileDialogFilters;
  ProjOpt.SetDefaults;
  options.CheckImportant;
 end;

 HKLog;
finalization
 HKLog('Options End');
 if not ShouldTerminate then
 begin
  Options.SaveToFile(folders.OptFile);
  Options.Free;
  ProjOpt.Free;
 end;
 CloseHandle(OptiMutex);
 HKLog;
end.

{
soBackUnindents	Aligns the insertion point to the previous indentation level (outdents it) when you press Backspace, if the cursor is on the first nonblank character 			of a line.
soGroupUndo		Undoes your last editing command as well as any subsequent editing commands of the same type, if you press Alt+Backspace.
soBeyondFileEnd	Positions the cursor beyond the end-of-file character.
soForceCutCopy	Enables Cut and Copy, even when there is no text selected.

soAutoIndent		Positions the cursor under the first nonblank character of the preceding nonblank line when you press Enter.
soSmartTab		Tabs to the first non-whitespace character in the preceding line.
soFindTextAtCursor	Places the text at the cursor into the Text To Find list box in the Find Text dialog box. When this option is disabled you must type in the search 			text, unless the Text To Find list box is blank, in which case the editor still inserts the text at the cursor.

soCreateBackups	Creates backup copy of file before saving the text.
soPersistentBlocks	Keeps marked blocks selected even when the cursor is moved, until a new block is selected.
soOverwriteBlocks	Replaces a marked block of text with whatever is typed next. If Persistent Blocks is also selected, text you enter is appended following the 			currently selected block.
soLimitEOL		Prevents the caret from moving beyond the end of line.
soUseTabCharacter	Inserts the Tab character into the text when the user presses Tab button. If False then spaces are inserted instead.

soCursorOnTab	If True then the caret is moved by tabs. For example if the caret is situated on the tab character and the user presses left arrow character
			the caret is moved by the tab (as in Delphi IDE)

}