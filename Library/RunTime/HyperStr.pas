{$B-,H+,X+,J-,O+} //Essential directives
{$IFDEF VER140}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}
{$IFDEF VER150}
{$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

unit HyperStr;

interface

uses
  Windows, Messages, SysUtils, WinSock, WinSpool;

type
  IDateTime      = type Integer;
  TIntegerArray  = array[0..(MaxInt div SizeOf(Integer))-1] of Integer;
  TWordArray     = array[0..(MaxInt div SizeOf(Word))-1] of Word;
  TSingleArray   = array[0..(MaxInt div SizeOf(Single))-1] of Single;
  TDoubleArray   = array[0..(MaxInt div SizeOf(Double))-1] of Double;
  TCurrencyArray = array[0..(MaxInt div SizeOf(Currency))-1] of Currency;
  TPointerArray  = array[0..(MaxInt div SizeOf(Pointer))-1] of Pointer;
  TCharSet       = set of char;

//For debugging and internal use, undocumented
function GetRefCnt(Source:AnsiString):Integer;
function ClrStringLocks:Boolean;

//Convert
function  IntToChr(const X:Integer):AnsiString;
function  ChrToInt(const Source:AnsiString):Integer;
function  WordToChr(const X:Word):AnsiString;
function  ChrToWord(const Source:AnsiString):Word;
function  SngToChr(const X:Single):AnsiString;
function  ChrToSng(const Source:AnsiString):Single;
function  DblToChr(var X:Double):AnsiString;
function  ChrToDbl(const Source:AnsiString):Double;
function  CurToChr(var X:Currency):AnsiString;
function  ChrToCur(const Source:AnsiString):Currency;
function  BinToInt(const Source:AnsiString):Integer;
function  IntToBin(const X:Integer):AnsiString;
function  HexToInt(const Source:AnsiString):Integer;
function  NumToWord(const Source:AnsiString;Money:Boolean):AnsiString;
function  OrdSuffix(const X:Integer):AnsiString;
function  SwapEndian(const X:Integer):Integer;
function  BoolToStr(const TF:Boolean):AnsiString;
function  RadixStr(const NumStr:AnsiString; Old,New:Integer):AnsiString;

//Search
function  ScanF(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanFF(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanR(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanRF(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanB(const Source:AnsiString;X:Char;Start:Integer):Integer;
function  ScanC(const Source:AnsiString;X:Char;Start:Integer):Integer;
function  ScanD(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanL(const Source:AnsiString;Start:Integer):Integer;
function  ScanU(const Source:AnsiString;Start:Integer):Integer;
function  ScanN(const Source:AnsiString;Start:Integer):Integer;
function  ScanCC(const Source:AnsiString;X:Char;Count:Integer):Integer;
function  ScanNC(const Source:AnsiString;X:Char):Integer;
function  ScanNB(const Source:AnsiString;X:Char):Integer;
function  ScanT(const Source,Table:AnsiString;Start:Integer):Integer;
function  ScanTQ(const Source,Table:AnsiString;Start:Integer):Integer;
function  ScanRT(const Source,Table:AnsiString;Start:Integer):Integer;
function  ScanNT(const Source,Table:AnsiString;Start:Integer):Integer;
function  ScanRNT(const Source,Table:AnsiString;Start:Integer):Integer;
function  ScanP(const Source,Search:AnsiString;var Start:Integer):Integer;
function  ScanW(const Source,Search:AnsiString;var Start:Integer):Integer;
function  ScanQ(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanQC(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanQR(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanQRC(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanZ(const Source,Search:AnsiString;Defects:Integer;var Start:Integer):Integer;
function  ScanSS(const Source,Search:AnsiString;const Start,Stop:Integer):Integer;
function  ScanSC(const Source,Search:AnsiString;const Start:Integer; const Stop:Char):Integer;
function  ScanLU(const Source:AnsiString;Lower,Upper:Char;Start:Integer):Integer;
function  ScanOR(const Source,Search:AnsiString;Start:Integer):Integer;
function  ScanBfr(const Bfr:PByte;Search:AnsiString;BfrLen:Integer):PByte;
function  ScanBfrC(const Bfr:PByte;Search:AnsiString;BfrLen:Integer):PByte;
function  ScanBfrR(const Bfr:PByte;Search:AnsiString;BfrLen:Integer):PByte;
function  ScanBfrRC(const Bfr:PByte;Search:AnsiString;BfrLen:Integer):PByte;
function  MakePattern( const Source:AnsiString) : AnsiString;
function  ScanRX( const Source,Pattern : AnsiString; var Start : integer ):Integer;
procedure SetQuotes(const QStart,QEnd:Char);
function  WScan(const Source,Search:WideString;Start:Integer):Integer;
function  WScanC(const Source:WideString;X:WideChar;Start:Integer):Integer;
function  WScanRC(const Source:WideString;X:WideChar;Start:Integer):Integer;

//Pad,Trim,Slice
function  LTrim(const Source:AnsiString;X:Char):AnsiString;
function  RTrim(const Source:AnsiString;X:Char):AnsiString;
function  CTrim(const Source:AnsiString;X:Char):AnsiString;
procedure LPad(var Source: AnsiString; const X:Char;Count:Integer);
procedure RPad(var Source: AnsiString; const X:Char;Count:Integer);
procedure CPad(var Source: AnsiString; const X:Char;Count:Integer);
function  LAdd(const Source: AnsiString; const X:Char;Count:Integer):AnsiString;
function  RAdd(const Source: AnsiString; const X:Char;Count:Integer):AnsiString;
function  CAdd(const Source: AnsiString; const X:Char;Count:Integer):AnsiString;
procedure LFlush(var Source: AnsiString);
procedure RFlush(var Source: AnsiString);
procedure CFlush(var Source: AnsiString);
function  LStr(const Source:AnsiString;Count:Integer):AnsiString;
function  RStr(const Source:AnsiString;Count:Integer):AnsiString;
function  CStr(const Source:AnsiString;Index,Count:Integer):AnsiString;
function  IStr(const Source:AnsiString;Index:Integer):AnsiString;
function  Extract(const Source,Srch:AnsiString;Index:Integer):AnsiString;

//Tokens
function  Parse(const Source,Table:AnsiString;var Index:Integer):AnsiString;
function  ParseWord(const Source,Table:AnsiString;var Index:Integer):AnsiString;
function  ParseTag(const Source,Start,Stop:AnsiString;var Index:Integer):AnsiString;
function  Fetch(const Source,Table:AnsiString;Num:Integer;DelFlg:Boolean):AnsiString;
function  GetDelimiter:Char;
function  SetDelimiter(Delimit:Char):Boolean;
function  GetDelimiter2:AnsiString;
function  SetDelimiter2(Delimit:AnsiString):Boolean;
function  InsertToken(var Source:AnsiString; const Token:AnsiString;Index:Integer):Boolean;
function  DeleteToken(var Source:AnsiString;var Index:Integer):Boolean;
function  ReplaceToken(var Source:AnsiString;Token:AnsiString;Index:Integer):Boolean;
function  GetToken(const Source:AnsiString;Index:Integer):AnsiString;
function  PrevToken(const Source:AnsiString;var Index:Integer):Boolean;
function  NextToken(const Source:AnsiString;var Index:Integer):Boolean;
function  GetTokenNum(const Source:AnsiString;Index:Integer):Integer;
function  GetTokenPos(const Source:AnsiString;Num:Integer):Integer;
function  GetTokenCnt(const Source:AnsiString):Integer;

//Match
function  Similar(const S1,S2:AnsiString):Integer;
function  StrDist(const S1,S2:AnsiString):Integer;
function  Soundex(const Source:AnsiString):Integer;
function  MetaPhone(const Name:AnsiString):Integer;

//Count
function  CountF(const Source:AnsiString;X:Char;Index:Integer):Integer;
function  CountR(const Source:AnsiString;X:Char;Index:Integer):Integer;
function  CountT(const Source,Table:AnsiString;Index:Integer):Integer;
function  CountM(const Source,Table:AnsiString;Index:Integer):Integer;
function  CountN(const Source,Table:AnsiString;Index:Integer):Integer;
function  CountW(const Source,Table:AnsiString):Integer;

//Test
function  IsNum(const Source:AnsiString):Boolean;
function  IsHex(const Source:AnsiString):Boolean;
function  IsFloat(const Source:AnsiString):Boolean;
function  IsAlpha(const Source:AnsiString):Boolean;
function  IsAlphaNum(const Source:AnsiString):Boolean;
function  IsMask(const Source,Mask:AnsiString;Index:Integer):Boolean;
function  IsNull(const Source:AnsiString):Boolean;
function  IsDateTime(const Source:AnsiString):Boolean;
function  IsTable(const Source,Table:AnsiString):Boolean;
function  IsField(const Source,Table:AnsiString;const Index,Cnt:Integer):Boolean;
function  IsSet(const Source:AnsiString;Multiple,Single:TCharSet):Boolean;
function  IsNumChar(const C:Char):Boolean;
function  IsAlphaChar(const C:Char):Boolean;
function  IsAlphaNumChar(const C:Char):Boolean;
function  IsLChar(C:Char):Boolean;
function  IsUChar(C:Char):Boolean;
function  IsCChar(C1,C2:Char):Boolean;
function  IsFound(const Source,Search:AnsiString;Start:Integer):Boolean;
function  IsMatch(const Source,Pattern:AnsiString;CaseFlg:Boolean):Boolean;
function  AnsiCompare(const S1,S2:AnsiString;I1,I2,Cnt:Integer):Integer;
function  HyperCompare(S1,S2:AnsiString;I1,I2,Cnt:Integer):Integer;
function  StringAt(const Src,Table:AnsiString;Index,Cnt:Integer):Boolean;

//Edit
function  MakeNum(var Source:AnsiString):Integer;
function  MakeHex(var Source:AnsiString):Integer;
function  MakeFloat(var Source:AnsiString):Integer;
function  MakeFixed(var Source:AnsiString; const Count:Byte):Integer;
function  MakeAlpha(var Source:AnsiString):Integer;
function  MakeAlphaNum(var Source:AnsiString):Integer;
function  MakeTime(var Source:AnsiString):Integer;
function  MakeTable(var Source:AnsiString;const Table:AnsiString):Integer;
function  IntToFmtStr(const X:Integer):AnsiString;
function  DupChr(const X:Char;Count:Integer):AnsiString;
function  UChar(const Source:Char):Char;
function  LChar(const Source:Char):Char;
function  RChar(const Source:Char):Char;
procedure UCase(var Source:AnsiString;Index,Count:Integer);
procedure LCase(var Source:AnsiString;Index,Count:Integer);
procedure AnsiUCase(var Source:AnsiString;const Index,Count:Integer);
procedure AnsiLCase(var Source:AnsiString;const Index,Count:Integer);
procedure ProperCase(var Source: AnsiString);
procedure MoveStr(const S:AnsiString;XS:Integer;var D:AnsiString;const XD,Cnt:Integer);
procedure ShiftStr(var S:AnsiString;Index,Count:Integer);
procedure FillStr(var Source:AnsiString;const Index:Integer;X:Char);
procedure FillCnt(var Source:AnsiString;const Index,Cnt:Integer;X:Char);
procedure LCompact(var Source:AnsiString);
function  Compact(var Source:AnsiString):Integer;
function  DeleteC(var Source:AnsiString;const X:Char):Integer;
function  DeleteD(var Source:AnsiString;const X:Char):Integer;
function  DeleteS(var Source:AnsiString;const Index,Count:Integer):Integer;
function  DeleteT(var Source:AnsiString;const Table:AnsiString):Integer;
function  DeleteTQ(var Source:AnsiString;const Table:AnsiString):Integer;
function  DeleteI(var Source:AnsiString;const Table:AnsiString; const Index:Integer):Integer;
function  DeleteNT(var Source:AnsiString;const Table:AnsiString):Integer;
function  DeleteNI(var Source:AnsiString;const Table:AnsiString; const Index:Integer):Integer;
procedure ReplaceC(var Source:AnsiString;const X,Y:Char);
procedure ReplaceT(var Source:AnsiString;const Table:AnsiString;X:Char);
procedure ReplaceI(var Source:AnsiString;const Table:AnsiString;Index:Integer;X:Char);
procedure ReplaceS(var Source:AnsiString;const Target,Replace:AnsiString);
function  ReplaceSC(var Source:AnsiString;const Target,Replace:AnsiString;CaseFlg:Boolean):Integer;
procedure OverWrite(var Source:AnsiString; const Replace:AnsiString;Index:Integer);
procedure Translate(var Source:AnsiString;const Table,Replace:AnsiString);
procedure RevStr(var Source:AnsiString);
procedure IncStr(var Source:AnsiString);
function  TruncPath(var S:AnsiString; const Count:Integer):Boolean;
function  Abbreviate(var S:AnsiString; const T:AnsiString;const Count:Integer):Boolean;
procedure TomCat(const S:AnsiString; var D:AnsiString; var InUse:Integer);
function  BuildTable(const Source:AnsiString):AnsiString;
procedure CharSort(var A:AnsiString);
function  WrapText(const Source:AnsiString;MaxWidth:Integer):AnsiString;
function  SetStrAddr(Addr:DWord):AnsiString;
function  SetCaseTable(const Lower,Upper:AnsiString):Boolean;

//Arrays
procedure StrSort(var A:array of AnsiString;const Cnt:Integer);
function  StrSrch(var A:array of AnsiString;const Target:AnsiString;Cnt:Integer):Integer;
function  StrDelete(var A:array of AnsiString;const Target,Cnt:Integer):Boolean;
function  StrInsert(var A:array of AnsiString;const Target,Cnt:Integer):Boolean;
procedure StrSwap(var S1,S2:AnsiString);
procedure ISortA(var A:array of integer;const Cnt:Integer);
procedure ISortD(var A:array of integer;const Cnt:Integer);
procedure HyperSort(const ArrayPtr:Pointer;const Cnt:Integer);
function  IntSrch(const A:array of Integer;const Target,Cnt:Integer):Integer;
function  IntDelete(var A:array of Integer; const Target,Cnt:Integer):Boolean;
function  IntInsert(var A:array of Integer; const Target,Cnt:Integer):Boolean;
procedure Dim(var P; const Size:Integer; Initialize:Boolean);
function  Cap(const P):Integer;

//Hash, Encrypt
function  Hash(const Source:AnsiString):Integer;
procedure EnCipher(var Source:AnsiString);
procedure DeCipher(var Source:AnsiString);
procedure Crypt(var Source:AnsiString; const Key:AnsiString);
procedure CryptBfr(const BfrPtr:Pointer; const Key:AnsiString; const BfrLen:Integer);
procedure IniRC4(const Key:AnsiString);
procedure CryptRC4(var Source:AnsiString);
function  HideInteger(const Value:Integer):AnsiString;
function  SeekInteger(const S:AnsiString):Integer;
function  Chaff(Source:AnsiString):AnsiString;
function  Winnow(Source:AnsiString):AnsiString;

//CRC, Checksum
function  ChkSum(const Source:AnsiString):Word;
procedure MakeSumZero(var Source:AnsiString);
function  ChkSumXY(const Source:AnsiString):Byte;
function  NetSum(const Source:AnsiString):Word;
function  CRC16(const IniCRC:Word;Source:AnsiString):Word;
function  CRCXY(const IniCRC:Word;Source:AnsiString):Word;
function  CRC32(const IniCRC:Integer;Source:AnsiString):Integer;
function  CRCBfr(const IniCRC:Integer; Bfr:PByte;BfrLen:Integer):Integer;
function  CreditSum(const Source:AnsiString):Integer;
function  ISBNSum(const Source:AnsiString):Boolean;
function  ValidSSN(Source:AnsiString):Integer;

//Base64
function  EnCodeInt(const X:Integer):AnsiString;
function  DeCodeInt(const Source:AnsiString):Integer;
function  EnCodeWord(const X:Word):AnsiString;
function  DeCodeWord(const Source:AnsiString):Word;
function  EnCodeSng(const X:Single):AnsiString;
function  DeCodeSng(const Source:AnsiString):Single;
function  EnCodeDbl(var X:Double):AnsiString;
function  DeCodeDbl(const Source:AnsiString):Double;
function  EnCodeCur(var X:Currency):AnsiString;
function  DeCodeCur(const Source:AnsiString):Currency;
function  EnCodeStr(const Source:AnsiString):AnsiString;
function  DeCodeStr(const Source:AnsiString):AnsiString;
function  URLEncode(S:AnsiString):AnsiString;
function  URLDecode(S:AnsiString):AnsiString;
function  UUEncode(S:AnsiString):AnsiString;
function  UUDecode(S:AnsiString):AnsiString;

//Math
function  EnCodeBCD(const Source:AnsiString):AnsiString;
function  DeCodeBCD(const Source:AnsiString):AnsiString;
function  AddUSI(const X,Y:Integer):Integer;
function  SubUSI(const X,Y:Integer):Integer;
function  MulUSI(const X,Y:Integer):Integer;
function  DivUSI(const X,Y:Integer):Integer;
function  ModUSI(const X,Y:Integer):Integer;
function  CmpUSI(const X,Y:Integer):Integer;
function  USIToStr(const X:Integer):AnsiString;
function  StrToUSI(const Source:AnsiString):Integer;
function  StrAdd(X,Y:AnsiString):AnsiString;
function  StrSub(X,Y:AnsiString):AnsiString;
function  StrMul(X,Y:AnsiString):AnsiString;
function  StrDiv(X,Y:AnsiString; var R:AnsiString):AnsiString;
function  StrCmp(X,Y:AnsiString):Integer;
function  StrAbs(X:AnsiString):AnsiString;
function  StrHex(X:AnsiString):AnsiString;
function  StrDec(X:AnsiString):AnsiString;
function  StrRnd(X:AnsiString; Digits:Integer):AnsiString;

//Integer Date/Time
function  TDT2IDT(const TDT:TDateTime):IDateTime; //TDateTime to IDateTime
function  IDT2TDT(const IDT:IDateTime):TDateTime; //IDateTime to TDateTime
function  StrToITime(const Source:AnsiString):IDateTime;  //String to ITime
function  StrToIDate(const Source:AnsiString):IDateTime;  //String to IDate
function  StrToIDateTime(const Source:AnsiString):IDateTime;  //String to IDate
function  IDateToStr(const IDT:IDateTime):AnsiString;
function  ITimeToStr(const IDT:IDateTime):AnsiString;
function  ITimeTo2460(IDT:IDateTime):AnsiString;
function  IDateTimeToStr(const IDT:IDateTime):AnsiString;
function  EncodeITime(const D,H,M,S:Word):IDateTime;
procedure DecodeITime(const IDT:IDateTime; var D,H,M:Word);
function  EncodeIDate(const Y,M,D:Word):IDateTime;
procedure DecodeIDate(const IDT:IDateTime; var Y,M,D:Word);
function  RoundITime(const IDT:IDateTime;Mns:Word):IDateTime;
function  WeekNum(const TDT:TDateTime; FirstDayofWeek:Integer):Word;
function  ISOWeekNum(const TDT:TDateTime):Word;
function  Easter(const Year:Word):Integer;
function  DayOfMonth(Year,Month,Day,N:Word):Word;
function  DayOfWk(Year,Month,Day:Word):Word;
function  FirstWeek:AnsiString;
function  FirstDay:AnsiString;
function  FormatToDateTime(S,Format:AnsiString):TDateTime;
function  IsDateValid(S,Format:AnsiString):Boolean;

//API
function  GetUser:AnsiString;
function  GetNetUser: AnsiString;
function  GetComputer:AnsiString;
function  GetLocalIP:AnsiString;
function  GetDrives:AnsiString;
function  RemoteDrive(const Drv:Char):Boolean;
function  GetDisk(const Drv:Char; var CSize,Available,Total:DWord):Boolean;
function  GetVolume(const Drv:Char; var Name,FSys:AnsiString; var S:DWord):Boolean;
function  GetWinDir:AnsiString;
function  GetSysDir:AnsiString;
function  GetTmpDir: AnsiString;
function  GetExeDir:Ansistring;
function  GetTmpFile(const Path,Prefix:AnsiString):AnsiString;
function  GetWinClass(const Title:AnsiString):AnsiString;
function  GetDOSName(const LongName:AnsiString):AnsiString;
function  GetWinName(const FileName:AnsiString):AnsiString;
function  GetCPU:AnsiString;
function  GetDefaultPrn:AnsiString;
function  GetPrinters:AnsiString;
function  GetDocType(fileExt:AnsiString):AnsiString;
procedure GetMemStatus(var RAMTotal,RAMUsed,PGTotal,PGUsed:Integer);
function  IsWinNT:Boolean;
function  IsNetWork:Boolean;
function  GetKeyValues(const Root:HKey;Key,Values:AnsiString):AnsiString;
procedure KillOLE;
function  GetProcID(const hWnd:THandle):THandle;
function  DOSExec(const CmdLine:AnsiString;const DisplayMode:Integer):Boolean;
function  WaitExec(const CmdLine:AnsiString;const DisplayMode:Integer):Integer;
procedure PipeExec(const CmdLine:AnsiString;const DisplayMode:Integer);
function  ReadPipe(var S:AnsiString):Integer;
function  WritePipe(const S:AnsiString):Integer;
procedure ClosePipe;
function  SetAppPriority(const Priority:DWord):Boolean;
function  GetFileDate(const FileName:AnsiString):AnsiString;
function  GetFreq:Comp;
function  GetCount:Comp;
function  SetClipText(const Source:AnsiString):Boolean;
function  GetClipText:AnsiString;
function  DriveReady(const Drive: Char): Boolean;
procedure StartSelect(const Key:Char);
function  ReBoot:Boolean;
function  GetBuildInfo(const Filename:AnsiString):AnsiString;
function  PathScan(const FileName:AnsiString; var Path:AnsiString):Boolean;
function  GetDomain:AnsiString;
function  GetRelativePath(Root,Dest:AnsiString;CaseFlg:Boolean):AnsiString;

//Compression
procedure IniRLE;
function  RLE(const Bfr:AnsiString; L:Word):AnsiString;
function  RLD(const Bfr:AnsiString; L:Word):AnsiString;
procedure IniSQZ;
function  SQZ(const Bfr:AnsiString; L:Word):AnsiString;
function  UnSQZ(const Bfr:AnsiString; L:Word):AnsiString;
function  BPE(const Bfr:AnsiString; L:Word):AnsiString;
function  BPD(const Bfr:AnsiString; L:Word):AnsiString;

//Communicate
function  ListComm:AnsiString;
function  OpenComm(const Mode:AnsiString):THandle;
function  ReadComm(const pHnd:THandle; var Bfr:AnsiString):Integer;
function  WriteComm(const pHnd:THandle; const Bfr:AnsiString):Integer;
function  StatusComm(const pHnd:THandle):Integer;
function  CloseComm(const pHnd:THandle):Boolean;
function  GetComm(const pHnd:THandle):Char;
function  SetRxTime(const pHnd:THandle; const TimeC,TimeM:Integer):Boolean;
function  ModemThere(const pHnd:THandle):Boolean;
function  ModemCommand(const pHnd:THandle; S:AnsiString):Boolean;
function  ModemResponse(const pHnd:THandle):AnsiString;
function  ModemDialog:Boolean;
function  OpenSlot(const Name:AnsiString):THandle;
function  ReadSlot(const hSlot:THandle;var Bfr:AnsiString):Boolean;
function  WriteSlot(const Name,Bfr:AnsiString):Boolean;
function  CloseSlot(const hSlot:THandle):Boolean;
function  MakePipe(const Name:AnsiString):THandle;
function  OpenPipe(const Name:AnsiString):THandle;
function  StartPipe(const hPipe:THandle):Boolean;
function  StopPipe(const hPipe:THandle):Boolean;
function  RecvPipe(const hPipe:THandle;var Bfr:AnsiString):Boolean;
function  SendPipe(const hPipe:THandle;Bfr:AnsiString):Boolean;
function  StatusPipe(const hPipe:THandle):Integer;
function  KillPipe(const hPipe:THandle):Boolean;

//Miscellaneous
function  UnSignedCompare(const X,Y:Integer):Boolean;
function  LoBit(const X:Integer):Integer;
function  HiBit(const X:Integer):Integer;
function  RotL(const X,Cnt:Integer):Integer;
function  RotR(const X,Cnt:Integer):Integer;
function  TestBit(const X,Cnt:Integer):Boolean;
procedure SetBit(var X:Integer;Cnt:Byte);
procedure ClrBit(var X:Integer;Cnt:Byte);
function  CntBit(X:Integer):Integer;
procedure SetByteBit(var X:Byte;Cnt:Byte);
procedure ClrByteBit(var X:Byte;Cnt:Byte);
procedure IntSwap(var I1,I2:Integer);
procedure WordSwap(var W1,W2:Word);
//The two below are undocumented
function  SetFileLock(const FHandle,LockStart,LockSize:Integer):Boolean;
function  ClrFileLock(const FHandle,LockStart,LockSize:Integer):Boolean;
//The two above are undocumented
function  RndToFlt(const X:Double):Double;
function  RndToInt(const X:Double):Integer;
function  RndToDec(const X:Double; Decimals:Integer):Double;
function  TruncToDec(const X:Double; Decimals:Integer):Double;
function  RndToSig(const X:Double; Digits:Integer):Double;
function  RndToCents(const X:Currency):Currency;
function  TruncToCents(const X:Currency):Currency;
function  RndToSecs(const DT:TDateTime;Secs:Word):TDateTime;
function  FloatToFrac(const X : Double; D:Integer) : AnsiString;
procedure SetFloatTolerance(X:Double);
function  CmpFloat(X,Y:Double):Integer;
function  IPower(const X,Y:Integer):Integer;
function  IPower2(const Y:Integer):Integer;
function  iMin(const I,J:Integer):Integer;
function  iMax(const I,J:Integer):Integer;
function  iMid(const I,J,K:Integer):Integer;
function  iRnd(const Value,Range:Integer):Integer;
function  iTrunc(const Value,Range:Integer):Integer;
function  iSign(const Value:Integer):Integer;
function  Sign(const I:Variant):Integer;
function  SignDbl(const D:Double):Integer;
function  GCD(const X,Y:DWord):DWord;
//The three below are undocumented
function  LRC(const Source:AnsiString):Char;
function  InPort(Address:Word):Byte;
procedure OutPort(Data:Byte;Address:Word);
//The three above are undocumented
function  CalcStr(Source:AnsiString):Double;
function  UniqueApp(const Title:AnsiString):Boolean;
procedure SpeakerBeep;
procedure Marquee(var S:AnsiString);
function  GetNICAddr:AnsiString;
function  iif(const Condition: Boolean; Value1, Value2: Variant): Variant;
function  StateAbbrev(S:AnsiString):AnsiString;
function  DriveNum(DriveLtr:Char):Byte;
procedure AddSlash(var Path:AnsiString);
procedure DelSlash(var Path:AnsiString);
function  RomanNum(Number:Integer):AnsiString;
function  ASC2HTM(Title,Text,Attributes:AnsiString):AnsiString;
function  IsConsole:Boolean;
function  IsDebugger:Boolean;
function  WinstallDate:AnsiString;
function  GetDigit(Value,N:Integer):Integer;
function  RandomText(L:Integer; Table:AnsiString):AnsiString;

implementation

uses NB30;

{The following global data is used and abused throughout this unit. This is
 generally not very good practice as it can lead to some very subtle bugs.
 However, this unit is (or at least should be) a controlled, self contained
 environment. This data adds insignificant overhead to an app using HyperString.}
type
  CodeType      = 0..256;         //Word
  UpIndex       = 0..255;         //Byte
  DownIndex     = 0..512;        //Word
  TStates       = array[0..50] of Integer;
  TAbbrev       = array[0..50] of Word;
  TMask         = array[0..31] of Byte;  //generic bit mapped character table
  TreeDownArray = array[UpIndex]   of DownIndex;
  TreeUpArray   = array[DownIndex] of UpIndex;
  TStdIO = record
    hRead, hWrite : DWORD;
  end;

const
  BufSize  = 65536;                //Max. compression work buffer
  MaxChar  = 256;                  //Ordinal of highest character
  PredMax  = 255;                  //MaxChar-1
  TwiceMax = 512;                  //2*MaxChar
  Ticks    = 1440;                 //Integer Date/Time constant
  B64Tbl:ShortString='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
  DUPLICATE_CLOSE_SOURCE = 1;
  DUPLICATE_SAME_ACCESS  = 2;

  States: TStates = ( //MetaPhone table of US state names
  1095516749,1095521099,1095912270,1095914318,1179406932,1179798862,1179799072,
  1213669408,1229737555,1229870158,1230250016,1230446624,1263289938,1263293012,
  1263422292,1263424339,1263424587,1280855584,1296965664,1296978772,1296979022,
  1297239118,1297306144,1297306448,1297307731,1297632800,1312969299,1313231904,
  1313361232,1313493587,1313688403,1314009163,1314009172,1314476619,1330126880,
  1330334797,1330794016,1347310412,1377837088,1380471891,1395673938,1395676235,
  1414222675,1414289234,1414419232,1414747218,1431586848,1465076558,1465078854,
  1465405003,1498238539);

  Abbrev: TAbbrev = ( //abbreviations corresponding to above
  16716,16715,16722,16730,17996,22100,22081,18505,18764,18766,18756,18753,
  17217,17231,17236,19283,19289,19521,19781,19790,19796,19780,19791,19795,
  19777,19785,20037,20054,20040,20042,20045,20035,20036,20057,20296,20299,
  20306,20545,18241,21065,21315,21316,21592,17477,21582,17475,21844,22345,
  22358,22337,22361);

  NumT:TMask = (0,0,0,0,1,0,255,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  HexT:TMask = (0,0,0,0,0,0,255,3,126,0,0,0,126,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
  OK = 'OK';
  CLOSURE = '*';    // match zero or more of preceding character
  BOL = '^';        // beginning of line
  EOL = '$';        // end of line
  ESCAPE = '\';     // escape next character
  DASH = '-';       // used in [a-z] type expressions
  NEGATE = '^';     // negate next character/range in [a-z] expression
  CCL ='[';         // intro for [a-z] expressions
  CCLEND = ']';     // outro for [a-z] expressions
  ANY = '.';        // match any single character
  //internal tokens
  NCCL = '!';       // negate [a-z] must not be same as NEGATE!!!
  LITCHAR = '@';    // quote single literal character
  TAB = #9;         // tab
  cwChop:Word = $1F32;
  cwDown:Word = $177F;
  Cents :DWord=100;
var
  S     : TStartupInfo;
  P     : TProcessInformation;
  iScan : TMask;
  SInn  : TStdIO;
  SOut  : TStdIO;
  XI    : TLargeInteger;
  Left  : TreeDownArray;
  Right : TreeDownArray;
  Up    : TreeUpArray;
  AA    : DownIndex;
  bScan   : Boolean=True;
  bPipe   : Boolean=False;
  BfrFlg  : Boolean=False;
  RLEFlg  : Boolean=False;
  hMutex  : THandle = 0;
  Delimiter : Char = ',';
  Delimiter2: AnsiString=','#0;
  DecSep    : Char = #0;
  TimeSep   : Char = #0;
  DateSep   : Char = #0;
  ThouSep   : Char = #0;
  cC        : Char = #0;
  QS        : Char = #34;
  QE        : Char = #34;
  iStack : array [0..127] of Integer;
  RCA    : array [0..64] of Integer;
  bI,bJ,bX:Boolean;
  dwI,dwJ,dwK,dwL:DWord;
  dI:Double;
  wI,RCS:Word;
  iMn,iMx,iTry,OutLen,Stcknum,Total,L1,R1,L2,R2,Score,s2ed:Integer;
  RevCase:array[0..255] of Char;      //character conversion tables
  LowCase:array[0..255] of Char;
  UprCase:array[0..255] of Char;
  LowT,UprT,AlphaT,AlphaNumT,VowelT:TMask;   //set tables
  FloatTolerance:Double=1.0e-9;              //floating point comparison



function GetRefCnt(Source:AnsiString):Integer;
  {Retrieve the reference count for a string.  Mainly for internal use.}
asm
  Or   EAX,EAX
  Jz   @Exit
  Mov  EAX,[EAX-8]
@Exit:
end;

procedure GetSeps;
var
  I,J,K:Integer;
  Buffer: array[0..1] of Char;
  Locale: LCID;
begin
  Locale := GetThreadLocale;
  if GetLocaleInfo(Locale, LOCALE_SDECIMAL, Buffer, 2) > 0 then
    DecSep:=Buffer[0] else DecSep:='.';
  if GetLocaleInfo(Locale, LOCALE_STIME, Buffer, 2) > 0 then
    TimeSep:=Buffer[0] else TimeSep:=':';
  if GetLocaleInfo(Locale, LOCALE_SDATE, Buffer, 2) > 0 then
    DateSep:=Buffer[0] else DateSep:='/';
  if GetLocaleInfo(Locale, LOCALE_STHOUSAND, Buffer, 2) > 0 then
    ThouSep:=Buffer[0] else ThouSep:=',';
  for I:=0 to 31 do begin
    AlphaT[I]:=0;
    LowT[I]:=0;
    UprT[I]:=0;
  end;
  for I:=0 to 255 do begin  //build default ASCII case tables
    RevCase[I]:=Char(I);
    LowCase[I]:=Char(I);
    UprCase[I]:=Char(I);
    K:=I AND 7;
    J:=I SHR 3;
    if (I>=65) AND (I<=90) then begin
      LowCase[I]:=Char(I XOR 32);
      RevCase[I]:=LowCase[I];
      SetByteBit(AlphaT[J],K);
      SetByteBit(UprT[J],K);
    end else if (I>=97) AND (I<=122) then begin
      UprCase[I]:=Char(I XOR 32);
      RevCase[I]:=UprCase[I];
      SetByteBit(AlphaT[J],K);
      SetByteBit(LowT[J],K);
    end;
  end;
  AlphaT[4]:=1; //include space character
  for I:=0 to 31 do AlphaNumT[I]:=AlphaT[I] OR NumT[I];  //combine these two
end;


function SetStrAddr(Addr:DWord):AnsiString;
  {Sets resultant string to point to a specific null terminated string address.}
begin
  Result:=AnsiString(PChar(Ptr(Addr)));
end;


function  SetCaseTable(const Lower,Upper:AnsiString):Boolean;
  {Sets internal case conversion and set tables}
var
  I,J:Integer;
  K:Byte;
begin
  Result:=False;
  if Length(Lower)=0 then Exit;
  if Length(Lower)=Length(Upper) then begin
    for I:=0 to 31 do begin
      AlphaT[I]:=0;
      LowT[I]:=0;
      UprT[I]:=0;
    end;
    for I:=0 to 255 do begin
      LowCase[I]:=Char(I);
      UprCase[I]:=Char(I);
      RevCase[I]:=Char(I);
    end;
    for I:=1 to Length(Lower) do begin
      J:=Ord(Lower[I]);
      RevCase[J]:=Upper[I];
      UprCase[J]:=Upper[I];
      K:=J AND 7;
      J:=J SHR 3;
      SetByteBit(AlphaT[J],K);
      SetByteBit(LowT[J],K);
    end;
    for I:=1 to Length(Upper) do begin
      J:=Ord(Upper[I]);
      RevCase[J]:=Lower[I];
      LowCase[J]:=Lower[I];
      K:=J AND 7;
      J:=J SHR 3;
      SetByteBit(AlphaT[J],K);
      SetByteBit(UprT[J],K);
    end;
    AlphaT[4]:=1;  //include space
    for I:=0 to 31 do AlphaNumT[I]:=AlphaT[I] OR NumT[I];
    Result:=True;
  end;
end;


procedure  SetVowelTable(const Vowels:AnsiString);
  {Sets internal table with vowel characters}
var
  I,J:Integer;
  K:Byte;
begin
  if Length(Vowels)>0 then begin
    for I:=0 to 31 do VowelT[I]:=0;
    for I:=1 to Length(Vowels) do begin
      J:=Ord(Vowels[I]);
      K:=J AND 7;
      J:=J SHR 3;
      SetByteBit(VowelT[J],K);
    end;
  end;
end;


function Compact(var Source:AnsiString):Integer;

  {Compact a string by moving embedded spaces and control char. to
   the right where they can be deleted if necessary using RTrim or
   SetLength.

   Returns: Length minus #chars. moved and converted to spaces.}

  asm
    Push  ESI
    Push  EDI             //save the important stuff
    Push  EBX

    Xor   EBX,EBX
    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //get Source address in read register
    Or    ESI,ESI
    Jz    @Done
    Mov   EDI,ESI         //...and write register
    Mov   ECX,[ESI-4]     //get length into count register
    Mov   EBX,ECX         //save it in EBX
    Jecxz @Done           //bail out if zero length
    Mov   DL,32           //looking for spaces (or less)
    Cld                   //make sure we go forward
@L1:
    Lodsb
    Cmp   AL,DL           //space or less?
    Jbe   @L2             //yes, then skip the write
    Stosb
@L2:
    Dec   ECX
    Jnz   @L1
    Mov   AL,DL
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb                 //otherwise, pad with a space
    Dec   EBX             //decrease the length
    Jmp   @L3             //and do it again
@Done:
    Mov   Result,EBX      //set output length

    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


procedure LCompact(var Source:AnsiString);

  {Compact a string by moving embedded spaces and control char. to
   the left.}

  asm
    Push  ESI
    Push  EDI             //save the important stuff

    Xor   EBX,EBX
    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //get Source address in read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //get length into count register
    Jecxz @Done           //bail out if zero length
    Add   ESI,ECX         //point to end
    Dec   ESI
    Mov   EDI,ESI         //...and write register
    Mov   DL,32           //looking for spaces (or less)
    Std                   //make sure we go backwards
@L1:
    Lodsb
    Cmp   AL,DL           //space or less?
    Jbe   @L2             //yes, then skip the write
    Stosb                 //otherwise, write it back
@L2:
    Dec   ECX
    Jnz   @L1
    Mov   AL,DL
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb                 //otherwise, pad with a space
    Jmp   @L3             //and do it again
@Done:

    Cld
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


function DeleteC(var Source:AnsiString;const X:Char):Integer;

  {Convert specified char. into right justified spaces which can be
   deleted if necessary using RTrim or SetLength.

   Returns: Length minus #chars. converted to spaces.}

  asm
    Push  ESI
    Push  EDI             //save the important stuff
    Push  EBX

    Xor   EBX,EBX
    Or    EAX,EAX
    Jz    @Done           //abort if null

    Push  EAX
    Push  EDX
    Call  UniqueString
    Pop   EDX
    Pop   EAX

    Mov   ESI,[EAX]       //get address into read register
    Or    ESI,ESI         //check for null pointer
    Jz    @Done
    Mov   EDI,ESI         //...and write register
    Mov   ECX,[ESI-4]     //get length into count register
    Mov   EBX,ECX         //save it in EBX
    Jecxz @Done           //bail out if zero length
    Mov   AH,X            //looking for spaces (or less)
    Cld                   //make sure we go forward

@L1:
    Lodsb
    Cmp   AL,AH           //equal?
    Jz    @L2             //yes, then skip the write
    Stosb                 //write it back
@L2:
    Dec   ECX
    Jnz   @L1
    Mov   AL,32           //setup to pad length
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb                 //pad with space
    Dec   EBX             //decrease length
    Jmp   @L3             //and do it again
@Done:
    Mov   Result,EBX      //output length
    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


function DeleteS(var Source:AnsiString;const Index,Count:Integer):Integer;

  {Convert Count char. starting at Index into right justified spaces which can
   be deleted if necessary using RTrim or SetLength.

   Returns: Length minus #chars. converted to spaces.}

  asm
    Push  ESI
    Push  EDI             //save the important stuff
    Push  EBX
    Push  EBP

    Xor   EBP,EBP
    Or    EAX,EAX
    Jz    @Done           //abort if null

    Push  ECX
    Push  EAX
    Push  EDX
    Call  UniqueString
    Pop   EDX
    Pop   EAX
    Pop   ECX

    Cld                   //make sure we go forward
    Mov   ESI,[EAX]       //get address into read register
    Or    ESI,ESI         //check for null pointer
    Jz    @Done
    Mov   EBP,[ESI-4]     //get length into EBP
    Or    EBP,EBP
    Jz    @Done           //bail out if zero length
    Jecxz @Done           //abort if zero count
    Cmp   EBP,EDX
    Jb    @Done           //bail out if too short
    Mov   EBX,EBP         //Move length to EBX
    Dec   EDX             //zero based
    Add   ESI,EDX         //start offset
    Mov   EDI,ESI         //save in write pointer
    Sub   EBX,EDX         //remaining characters
    Cmp   EBX,ECX
    Jbe   @L1
    Add   ESI,ECX
    Sub   EBX,ECX

//    XChg  ECX,EBX
    Mov   EAX,EBX
    Mov   EBX,ECX
    Mov   ECX,EAX

    Rep   movsb
@L1:
    Mov   AL,32
    Sub   EBP,EBX
    Mov   ECX,EBX
    Rep   stosb
@Done:
    Mov   EAX,EBP      //output length
    Pop   EBP
    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here



function DeleteD(var Source:AnsiString;const X:Char):Integer;

  {Convert trailing duplicates of specified char. into right justified spaces
   which can be deleted if necessary using RTrim or SetLength.  Only duplicates
   are affected, the first character in a run of duplicates is left in place.

   Returns: Length minus #chars. converted to spaces.}

  asm
    Push  ESI
    Push  EDI             //save the important stuff
    Push  EBX

    Xor   EBX,EBX
    Or    EAX,EAX
    Jz    @Done           //abort if null
    Push  EAX
    Push  EDX
    Call  UniqueString
    Pop   EDX
    Pop   EAX

    Mov   ESI,[EAX]       //get address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   EDI,ESI         //...and write register
    Mov   ECX,[ESI-4]     //get length into count register
    Mov   EBX,ECX         //save it in EBX
    Jecxz @Done           //bail out if zero length
    Cld                   //make sure we go forward

    Mov   DH,DL           //DH will hold the "prior" character
    Not   DH              //make sure "prior" doesn't match on start
@L1:
    Lodsb
    Cmp   AL,DL           //equal to target?
    Jnz   @L2             //no, then write it back
    Cmp   AL,DH           //same as "prior" ?
    Jnz   @L2             //no, then write it back
    Jmp   @Skip           //a dup --- skip the write
@L2:
    Stosb                 //write it back
@Skip:
    Mov   DH,AL           //save our "prior" character
    Dec   ECX
    Jnz   @L1
    Mov   AL,32           //setup to pad length
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb                 //pad with space
    Dec   EBX             //decrease length
    Jmp   @L3             //and do it again
@Done:
    Mov   Result,EBX      //output length
    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


procedure _TableScanIni;
  {Initialization for table scanning routines. Internal use only.}
  asm
    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero table ?
    Jz    @NotFound
    Mov   ESI,ECX          //save start in ESI, temporarily
    Or    ECX,ECX
    Jz    @NotFound        //abort if zero start
    Jns   @L0              //skip if no sign bit
    Neg   ECX              //absolute value of Start
@L0:
    Mov   EBP,EAX          //save Source address
    Mov   EAX,[EAX-4]      //source length
    Cmp   ECX,EAX          //start beyond end ?
    Ja    @NotFound        //yes, then abort
    Mov   EAX,[EDX-4]      //table length
    Or    EAX,EAX
    Jz    @NotFound        //Abort if zero table
    Cmp   EAX,256          //abort if Table too long
    Ja    @NotFound

    Cld                    //insure we go forward
    Push  EBP              //Save Source address
    Push  ECX              //save Start
    Push  EDX              //save Table address
    Push  EAX              //save Table length

    Mov   ECX,8
    Xor   EAX,EAX
    Lea   EDI,iScan        //initialize scan array
    Push  EDI              //save the pointer
    Rep   Stosd            //store 8 dbl words (32 bytes)
    Pop   EDI              //restore pointer
    Pop   ECX              //Table length

    Lea   EBP,RevCase
    Shl   ECX,1            //move case bit from ESI to ECX
    Shl   ESI,1
    Rcr   ECX,1
    Pop   ESI              //Table address
    Xor   EAX,EAX
@L2:
    Lodsb                  //get a byte from table

    Mov   EDX,EAX          //save it in EDX
    And   EDX,31           //bit index
    Mov   DH,AL

    Shr   EAX,5            //byte index, divide by 32
    Shl   EAX,2            //multiply by 4 for dbl-word

    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bts   EBX,EDX           //set the bit
//*   Bts   EBX,DL           //set the bit
    Mov   [EDI+EAX],EBX    //store it back

    Bt    ECX,31           //case insensitive ?
    Jnc   @Skip            //no, then skip

    Shr   EDX,8
    Mov   AL,[EBP+EDX]     //reverse case
    Mov   EDX,EAX          //save it in EDX
    And   EDX,31           //bit index

    Shr   EAX,5            //byte index, divide by 32
    Shl   EAX,2            //multiply by 4 for dbl-word

    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bts   EBX,EDX          //set the bit
    Mov   [EDI+EAX],EBX    //store it back
@Skip:
    Dec   CX              //do it again
    Jnz   @L2

    Pop   EAX              //get Start
    Pop   EBP              //get Source address
    Mov   ESI,EBP
    Mov   ECX,[ESI-4]      //Source length
    Dec   EAX              //zero based Start
    Add   ESI,EAX          //adjust Source
    Jmp   @Done
    //returns ESI=Pointer to Start position
    //        EDI=Pointer to iScan array
    //        ECX=Full Length Source
    //        EAX=Zero based Start
    //        EBP=Pointer to Source[1]
    //        Direction flag clear
@NotFound:
    Xor   ECX,ECX
    //returns ECX=0 on error
@Done:
  end;


function DeleteI(var Source:AnsiString;const Table:AnsiString; const Index:Integer):Integer;

  {Convert Table chars. from Index position forward into right justified spaces
   which can be deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count; length minus chars. converted to spaces.}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX
    Jz    @Exit
    Push  EAX
    Push  EDX
    Push  ECX
    Call  UniqueString
    Pop   ECX
    Pop   EDX
    Pop   EAX
    Mov   EAX,[EAX]
    Call  _TableScanIni
    Jecxz @Abort
    Push  ECX              //save length
    Sub   ECX,EAX          //adjust for Start
    Mov   EBX,ESI          //use EBX as write pointer
    Xor   EAX,EAX

@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in DL
    Mov   DH,DL            //and in DH
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBP,[EDI+EAX]    //get the dbl-word
    Bt    EBP,EDX
//*    Bt    EBP,DL           //test the bit
    Jc    @Skip            //skip write if in Table
    Mov   [EBX],DH
    Inc   EBX
@Skip:
    Dec   ECX
    Jnz   @Next

    Pop   EAX              //original source length
    Mov   DH,32            //prepare to space fill
@L3:
    Cmp   EBX,ESI          //read = write ?
    Jz    @Exit            //yes, then we're done
    Mov   [EBX],DH         //no, then space fill
    Inc   EBX
    Dec   EAX              //adjust output length
    Jmp   @L3              //and do it again

@Abort:
    Xor   EAX,EAX
@Exit:

    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX

    Mov   Result,EAX       //output length
  end;


function DeleteT(var Source:AnsiString;const Table:AnsiString):Integer;

  {Convert any Table char. into right justified space which can be
   deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count (length minus chars. converted to spaces); zero on error.}

begin
  Result:=DeleteI(Source,Table,1);
end;


function DeleteTQ(var Source:AnsiString;const Table:AnsiString):Integer;

  {Convert Table chars. into right justified spaces which can be deleted if
   necessary using RTrim or SetLength. Characters inside dbl quotes are ignored.

   Returns: Valid char. count; length minus chars. converted to spaces.}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX
    Jz    @Exit
    Push  EAX
    Push  EDX
    Push  ECX
    Call  UniqueString
    Pop   ECX
    Pop   EDX
    Pop   EAX
    Mov   EAX,[EAX]
    Mov   ECX,1
    Call  _TableScanIni
    Jecxz @Abort
    Push  ECX              //save length
    Sub   ECX,EAX          //adjust for Start
    Mov   EBX,ESI          //use EBX as write pointer
    Xor   EAX,EAX
    Xor   EDX,EDX

@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in DL
    Mov   DH,DL            //and in DH
    Cmp   AL,34            //dbl quote ?
    Jnz   @Skip2           //no, then skip
    Xor   EDX,$40000000    //set flag
//    Jmp   @Skip2
//@Skip1:
//    Cmp   AL,39            //single quote ?
//    Jnz   @Skip2           //no, then skip
//    Xor   EDX,$20000000    //set flag
@Skip2:
    Test  EDX,$60000000    //quotes clear ?
    Jnz   @Write           //no, then write it out
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBP,[EDI+EAX]    //get the dbl-word
    Bt    EBP,EDX
//*    Bt    EBP,DL           //test the bit
    Jc    @Skip            //skip write if in Table
@Write:
    Mov   [EBX],DH
    Inc   EBX
@Skip:
    Dec   ECX
    Jnz   @Next
@Done:
    Pop   EAX              //original source length
    Mov   DH,32            //prepare to space fill
@L3:
    Cmp   EBX,ESI          //read = write ?
    Jz    @Exit            //yes, then we're done
    Mov   [EBX],DH         //no, then space fill
    Inc   EBX
    Dec   EAX              //adjust output length
    Jmp   @L3              //and do it again

@Abort:
    Xor   EAX,EAX
@Exit:

    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX

    Mov   Result,EAX       //output length
  end;


function DeleteNT(var Source:AnsiString;const Table:AnsiString):Integer;

  {Convert any non-Table character into right justified space
   which can be deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count (length minus chars. converted to spaces); zero on error.}

begin
  Result:=DeleteNI(Source,Table,1);
end;


function DeleteNI(var Source:AnsiString;const Table:AnsiString; const Index:Integer):Integer;

  {Convert any non-Table character from Index forward into right justified space
   which can be deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count; length minus chars. converted to spaces.

   Example: One application might be to filter keystroke errors from user
            input after the fact.

            Source:='$123X4.56  ';
            I:=DeleteNT(Source,'$+-0123456789.');

            On return, I=8, Source='$1234.56   '

   Same as MakeTable() but faster for longer strings (30+ characters).}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX
    Jz    @Exit
    Push  EAX
    Push  EDX
    Push  ECX
    Call  UniqueString
    Pop   ECX
    Pop   EDX
    Pop   EAX
    Mov   EAX,[EAX]
    Call  _TableScanIni
    Jecxz @Abort
    Push  ECX              //save length
    Sub   ECX,EAX          //adjust for Start
    Mov   EBX,ESI          //use EBX as write pointer
    Xor   EAX,EAX

@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in DL
    Mov   DH,DL            //and in DH
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBP,[EDI+EAX]    //get the dbl-word
    Bt    EBP,EDX
//*    Bt    EBP,DL           //test the bit
    Jnc   @Skip            //skip write if not in Table
    Mov   [EBX],DH
    Inc   EBX
@Skip:
    Dec   ECX
    Jnz   @Next

    Pop   EAX              //original source length
    Mov   DH,32            //prepare to space fill
@L3:
    Cmp   EBX,ESI          //read = write ?
    Jz    @Exit            //yes, then we're done
    Mov   [EBX],DH         //no, then space fill
    Inc   EBX
    Dec   EAX              //adjust output length
    Jmp   @L3              //and do it again

@Abort:
    Xor   EAX,EAX
@Exit:

    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX

    Mov   Result,EAX       //output length
  end;


function  IsFloat(const Source:AnsiString):Boolean;

  {Determine if a string contains characters,0-9,space,E,+,-,DecimalSeparator}
asm
  Push  ESI             //save the important stuff

  Mov   EAX,Source
  Or    EAX,EAX
  Jz    @Done           //abort if nil address
  Mov   ESI,EAX         //put address into write register
  Mov   ECX,[EAX-4]     //put length into count register
  Xor   EAX,EAX
  Jecxz @Done           //bail out if zero length
  Cld
@Start:
  Lodsb                 //get a byte
  Cmp   AL,DecSep
  Jz    @OK             //Decimal is OK
  Cmp   AL,32
  Jz    @OK             //space is OK
  Cmp   AL,43
  Jz    @OK             //+ is OK
  Cmp   AL,45
  Jz    @OK             //- is OK
  Cmp   AL,69
  Jz    @OK             //'E' is OK
  Cmp   AL,101
  Jz    @OK             //'e' is OK
  Cmp   AL,48
  Jb    @NG             //less than 0 is NG
  Cmp   AL,57
  Ja    @NG             //greater than 9 is NG
@OK:
  Dec   ECX
  Jnz   @Start
  Mov   EAX,True        //if we make it here, we've got a good one
  Jmp   @Done
@NG:
  Xor   EAX,EAX
@Done:
  Pop   ESI             //restore the important stuff
  Mov   Result,AL
end;                    //and we're outta here


function  IsDateTime(const Source:AnsiString):Boolean;

  {Determine if a string contains only char. 0-9,space,-,DateSeperator,TimeSeparator}
asm
  Push  ESI             //save the important stuff

  Mov   EAX,Source
  Or    EAX,EAX
  Jz    @Done           //abort if nil address
  Mov   ESI,EAX         //put address into write register
  Mov   ECX,[EAX-4]     //put length into count register
  Xor   EAX,EAX
  Jecxz @Done           //bail out if zero length
  Cld
@Start:
  Lodsb                 //get a byte
  Cmp   AL,32
  Jz    @OK             //space is OK
  Cmp   AL,TimeSep
  Jz    @OK             //Time is OK
  Cmp   AL,DateSep
  Jz    @OK             //Date is OK
  Cmp   AL,45
  Jz    @OK             //- is OK
  Cmp   AL,65
  Jz    @OK
  Cmp   AL,77
  Jz    @OK
  Cmp   AL,80
  Jz    @OK
  Cmp   AL,48
  Jb    @NG             //less than 0 is NG
  Cmp   AL,57
  Ja    @NG             //greater than 9 is NG
@OK:
  Dec   ECX
  Jnz   @Start
  Mov   EAX,True          //if we make it here, we've got a good one
  Jmp   @Done
@NG:
  Xor   EAX,EAX
@Done:
  Pop   ESI             //restore the important stuff
  Mov   Result,AL
end;                    //and we're outta here


function  IsTable(const Source,Table:AnsiString):Boolean;

  {Determine if string is composed solely of table characters.}

begin
  Result:=CountT(Source,Table,1)=Length(Source);
end;


function  IsField(const Source,Table:AnsiString;const Index,Cnt:Integer):Boolean;

  {Determine if a fielded portion of a string is composed solely of table characters.
   Field begins at Index position and is Cnt characters in length.}

begin
  Result:=CountM(Source,Table,Index)>=Cnt;
end;


function  IsSet(const Source:AnsiString;Multiple,Single:TCharSet):Boolean;
  {Determine if string is composed solely of characters from given sets. Only a
   single instance of characters in Single set is allowed}
var
  S:TCharSet;
  I:Integer;
begin
  Result:=False;
  I:=Length(Source);
  if I=0 then Exit;
  S:=Single;
  repeat
    if not (Source[I] in Multiple) then begin
      if not (Source[I] in S) then break else Exclude(S,Source[I]);
    end;
    Dec(I);
  until I=0;
  Result:=I=0;
end;


function  _IsTMask(const Source:AnsiString):Boolean;

  {Determine if a string contains only table characters. Table address = EDX}

  asm
    Push  ESI             //save the important stuff
    Push  EDI

    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Mov   ESI,EAX         //put address into write register
    Mov   ECX,[EAX-4]     //put length into count register
    Xor   EAX,EAX
    Jecxz @Done           //bail out if zero length
    Cld
    Mov   EDI,EDX      //initialize scan array
    Xor   EDX,EDX
@Start:
    Lodsb                 //get a byte

    Mov   EDX,EAX
    And   EDX,7           //bit index
    Shr   EAX,3           //byte index
    Mov   AL,[EDI+EAX]    //get byte
    Bt    EAX,EDX         //test the bit
    Jnc   @NG             //abort if NG

    Dec   ECX
    Jnz   @Start
    Mov   EAX,True          //if we make it here, we've got a good one
    Jmp   @Done
@NG:
    Xor   EAX,EAX
@Done:
    Pop   EDI
    Pop   ESI             //restore the important stuff
  end;                    //and we're outta here


function  IsNum(const Source:AnsiString):Boolean;

  {Determine if a string contains only digits (0-9) and spaces.}

  asm
    Lea   EDX,NumT      //initialize scan array
    Jmp   _ISTMask
  end;


function  IsNumChar(const C:Char):Boolean;

  {Determine if a character is an ASCII digit(0-9).}

  asm
    Or    EAX,EAX
    Jz    @Done           //abort if nil address

    Cmp   AL,48
    Jb    @NG             //less than 0 is NG
    Cmp   AL,57
    Ja    @NG             //greater than 9 is NG
    Mov   EAX,True        //OK
    Jmp   @Done
@NG:
    Xor   EAX,EAX
@Done:
  end;                    //and we're outta here


function  IsAlphaChar(const C:Char):Boolean;

  {Determine if a character is in [A..Z,a..z].}

  asm
    Or    EAX,EAX
    Jz    @Done           //abort if nil address

    Push  EDI
    Lea   EDI,AlphaT
    And   EAX,255
    Mov   EDX,EAX
    And   EDX,7           //bit index
    Shr   EAX,3           //byte index
    Mov   AL,[EDI+EAX]    //get byte
    Bt    EAX,EDX         //test the bit
    Pop   EDI
    Jnc   @NG             //abort if NG
    Mov   EAX,True        //OK
    Jmp   @Done
@NG:
    Xor   EAX,EAX
@Done:
  end;                    //and we're outta here



function  IsAlphaNumChar(const C:Char):Boolean;

  {Determine if a character is in [0..9,A..Z,a..z].}

  asm
    Or    EAX,EAX
    Jz    @Done           //abort if nil address

    Push  EDI
    Lea   EDI,AlphaNumT
    And   EAX,255
    Mov   EDX,EAX
    And   EDX,7           //bit index
    Shr   EAX,3           //byte index
    Mov   AL,[EDI+EAX]    //get byte
    Bt    EAX,EDX         //test the bit
    Pop   EDI
    Jnc   @NG             //abort if NG
    Mov   EAX,True        //OK
    Jmp   @Done
@NG:
    Xor   EAX,EAX
@Done:
  end;                    //and we're outta here



function  IsHex(const Source:AnsiString):Boolean;

  {Determine if a string contains only digits (0-9,A-F) and spaces.}

  asm
    Lea   EDX,HexT      //initialize scan array
    Jmp   _IsTMask
  end;

function  IsAlpha(const Source:AnsiString):Boolean;

  {Determine if a string contains only ASCII alpha characters and spaces.}

  asm
    Lea   EDX,AlphaT      //initialize scan array
    Jmp   _IsTMask
  end;


function IsAlphaNum(const Source:AnsiString):Boolean;

  {Determine if a string contains only alphabetic characters,digits,space.}

  asm
    Lea   EDX,AlphaNumT      //initialize scan array
    Jmp   _IsTMask
  end;

function IsMask(const Source,Mask:AnsiString;Index:Integer):Boolean;

  {Validate Source from start to Index (-1 = Full) for conformance to a
   'picture mask' (similar to Delphi's EditMask) composed from the
   following special character set.

      A - Alphanumeric required (a..z,A..Z,0..9)
      a - Alphanumeric permitted
      C - Alphabetic character required (a..z,A..Z)
      c - Alphabetic character permitted
      0 - Numeric required (0..9)
      9 - Numeric permitted
      # - +/- permitted
      ? - Any character required (#0..#255)
      @ - Any character permitted
      | - Literal next, required
      \ - Literal next, permitted

  NOTE: Trailing spaces are allowed, leading spaces are not.
        Index provides support for partial, incremental validation. If
        Index<>-1, validation is only performed on the characters present.
        In other words, Source is allowed to be incomplete compared to Mask.
        To FULLY validate the entire Mask, you MUST use Index = -1.}
var
  I,J:Integer;
begin
  Result:=False;
  R1:=Length(Source);
  R2:=Length(Mask);
  if (R2=0) OR (R1=0) then Exit;
  if (Index>0) and (Index<R1) then R1:=Index;
  J:=1;                 //initialize Mask pointer
  I:=1;                 //initialize Source pointer
  bI:=False;
  bJ:=False;
  while I<=R1 do begin
    bX:=False;          //assume invalid character
    case Mask[J] of
      '#':if (Source[I]<>#45) AND (Source[I]<>#43) then
            bJ:=True
          else begin
            bX:=True;
            bI:=True;
            bJ:=True;
          end;
      '0':if (Source[I]<#48) OR (Source[I]>#57) then
            break
          else begin
            bX:=True;
            bI:=True;
            bJ:=True;
          end;
      '9':if (Source[I]<#48) OR (Source[I]>#57) then begin
            bJ:=True;
          end else begin
            bX:=True;
            bI:=True;
            bJ:=True;
          end;
       '?','@':begin
            bX:=True;
            bI:=True;
            bJ:=True;
          end;
      'A':if (Source[I]=#32) OR (IsAlphaNumChar(Source[I])=False) then
//(Source[I]<#48) OR (Source[I]>#122) OR ((Source[I]>#57) AND (Source[I]<#65)) OR ((Source[I]>#90) AND (Source[I]<#97)) then
            break
          else begin
            bX:=True;
            bI:=True;
            bJ:=True;
          end;
      'C':if (Source[I]=#32) OR (IsAlphaChar(Source[I])=False) then
//(Source[I]<#65) OR (Source[I]>#122) OR ((Source[I]>#90) AND (Source[I]<#97)) then
            break
          else begin
            bX:=True;
            bI:=True;
            bJ:=True;
          end;
      'a':if (Source[I]=#32) OR (IsAlphaNumChar(Source[I])=False) then
//(Source[I]<#48) OR (Source[I]>#122) OR ((Source[I]>#57) AND (Source[I]<#65)) OR ((Source[I]>#90) AND (Source[I]<#97)) then
            bJ:=True
          else begin
            bX:=True;
            bI:=True;
            bJ:=True;
          end;
      'c':if (Source[I]=#32) OR (IsAlphaChar(Source[I])=False) then
//(Source[I]<#65) OR (Source[I]>#122) OR ((Source[I]>#90) AND (Source[I]<#97)) then
            bJ:=True
          else begin
            bX:=True;
            bI:=True;
            bJ:=True;
          end;
      '\':begin
            if J=R2 then break;
            J:=J+1;
            if Source[I]=Mask[J] then begin
              bX:=True;
              bI:=True;
              bJ:=True;
            end else bJ:=True;
          end;
      '|':begin
            if J=R2 then break;
            J:=J+1;
            if Source[I]<>Mask[J] then break;
            bX:=True;
            bI:=True;
            bJ:=True;
          end;

    else
      break;
    end;
    if bJ then begin         //increment Mask pointer
      if J=R2 then break;
      J:=J+1;
      bJ:=False;
    end;
    if bI then begin         //increment Source pointer
      if I=R1 then break;
      I:=I+1;
      bI:=False;
    end;
  end;
  if bX then begin     //last character matched
    if bJ then begin   //end of Mask
      Result:=True;
      if I<R1 then begin  //not end of Source
        for I:=I TO R1 do begin
          if Source[I]<>#32 then begin   //not a space
            Result:=False;               //invalid
            break;
          end;
        end;
      end;
    end else if Index<>-1 then           //partial validation
      Result:=True
    else                                 //full validation
      Result:=CountT(Mask,'AC0?|',J)=0;
  end;
end;


function  IsNull(const Source:AnsiString):Boolean;
  {Determine if a string contains only char. 0-32 and 255.}
  asm
    Push  ESI             //save the important stuff

    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Mov   ESI,EAX         //put address into write register
    Mov   ECX,[EAX-4]     //put length into count register
    Xor   EAX,EAX
    Jecxz @Done           //bail out if zero length
    Cld
@Start:
    Lodsb                 //get a byte
    Cmp   AL,32
    Jbe   @OK             //less than or equal to space is OK
    Cmp   AL,255
    Jnz   @NG             //255 is OK
@OK:
    Dec   ECX
    Jnz   @Start
    Mov   EAX,True        //if we make it here, we've got a good one
    Jmp   @Done
@NG:
    Xor   EAX,EAX
@Done:
    Pop   ESI             //restore the important stuff
  end;                    //and we're outta here


function IsFound(const Source,Search:AnsiString;Start:Integer):Boolean;
  {Returns True if Search is found within Source from Start location forward.
   Search may contain any number of different tokens by using '&' (ASCII 38)
   as a kind of logical AND operator. Supports case insensitive using negative Start.

   Example: IsFound(S,'who&what&when',I);}

var
  I,J:Integer;
  Token:AnsiString;
begin
  Result:=False;
  if Length(Source)=0 then Exit;
  I:=1;
  J:=Length(Search);
  repeat
    Token:=ParseWord(Search,'&',I);
    if Length(Token)>0 then
      if ScanF(Source,Token,Start)>0 then begin
        Result:=True;
        Break;
      end;
  until (I<1) OR (I>J);
end;


function UChar(const Source:Char):Char;
  {Upper case a single character; similar to the built-in UpperCase
   function but with a Char compatible resultant using user-defined table.}
begin
  Result := UprCase[Ord(Source)];
end;


function LChar(const Source:Char):Char;
  {Lower case a single character; similar to the built-in LowerCase
   function but with a Char compatible resultant using user-defined table.}
begin
  Result:=LowCase[Ord(Source)];
end;


function RChar(const Source:Char):Char;
  {Reverse the case (lower to upper or upper to lower) of a single character
   using user-defined table.}
begin
  Result:=RevCase[Ord(Source)];
end;


procedure _TstBit;
asm
  Push  EDX
  Push  EAX
  And   EAX,255
  Mov   EDX,EAX
  And   EDX,7           //bit index
  Shr   EAX,3           //byte index
  Mov   AL,[EBX+EAX]    //get byte
  Bt    EAX,EDX         //test the bit
  Pop   EAX
  Pop   EDX
end;


function IsMatch(const Source,Pattern:AnsiString; CaseFlg:Boolean):Boolean;

  {Returns True if Source contains a match for a pattern string containing
   wildcards:

     '*' = match any string (including null string)
     '?' = match any single character
     '#' = match any numeric character (0..9)
     '@' = match any alpha character (a..z, A..Z)
     '$' = match any alphanumeric character
     '~' = match any non-alpahumeric, non-space char.
    else = match given character only

   Case insensitive if CaseFlg = True.}

asm

  Push  ESI
  Push  EDI
  Push  EBX
  Push  EBP

  Or    EAX,EAX          //zero source ?
  Jz    @NotFound
  Or    EDX,EDX          //zero search ?
  Jz    @NotFound

  Mov   ESI,EAX          //source address
  Mov   EDI,EDX          //search address

  Xor   EAX,EAX          //clear for case flag
  Jecxz @L0              //skip if case sensitive
  Mov   EAX,-1           //set case flag
@L0:

  Mov   ECX,[ESI-4]      //source length
  Dec   ECX
  Js    @NotFound        //abort on null string

  Mov   EDX,[EDI-4]      //search length
  Dec   EDX
  Js    @NotFound        //abort on null string

  Add   EDX,EDI          //end of search
  Add   ECX,ESI          //end of source
  Xor   EBX,EBX
@Next:
  Cmp   EDI,EDX          //end of search ?
  Ja    @Found           //yes, we found it!

  Mov   AH,[EDI]         //get next character from search
  Inc   EDI              //next offset

  Cmp   AH,42            //wildcard '*'
  Jnz   @L1              //no, then skip
  Mov   EBX,EDI          //set flag
  Mov   EBP,ESI
  Jmp   @Next            //get next character

@L1:
  Cmp   ESI,ECX          //end of source ?
  Ja    @NotFound        //yes, no match

  Lodsb                  //get next character from source

  Cmp   AH,63            //wildcard '?'
  Jz    @Next            //yes, then check next char.
@L3:
  Cmp   AH,35            //wildcard '#'
  Jnz   @L5
  Cmp   AL,48
  Jb    @L4
  Cmp   AL,57
  Jbe   @Next
  Jmp   @L4
@L5:
  Cmp   AH,64            //wildcard '@'
  Jnz   @L6
  Cmp   AL,32
  Jz    @L4

  Push  EBX
  Lea   EBX,AlphaT
  Call  _TstBit
  Pop   EBX
  Jc    @Next
  Jmp   @L4
@L6:
  Cmp   AH,126           //wildcard '~'
  Jnz   @L7

  Push  EBX
  Lea   EBX,AlphaNumT
  Call  _TstBit
  Pop   EBX
  Jnc   @Next
  Jmp   @L4
@L7:
  Cmp   AH,36            //wildcard '$'
  Jnz   @L8
  Cmp   AL,32
  Jz    @L4

  Push  EBX
  Lea   EBX,AlphaNumT
  Call  _TstBit
  Pop   EBX
  Jc    @Next
  Jmp   @L4
@L8:
  Cmp   AL,AH            //match ?
  Jz    @Next            //yes, then check next char.

  Test  EAX,$80000000    //case insensitive flag ?
  Jz    @L4              //no, then skip

  Push  EAX
  Call  RChar
  Mov   [ESP],AL
  Pop   EAX
  Cmp   AL,AH            //match ?
  Jz    @Next            //yes, then check next char.

@L4:
  Or    EBX,EBX            //wildcard flag ?
  Jz    @NotFound          //no, then not found
  Mov   EDI,EBX            //back up Search
  Inc   EBP
  Mov   ESI,EBP            //back up Source+1
  Jmp   @Next              //and continue

@NotFound:
  Xor   EAX,EAX          //clear return
  Jmp   @Done
@Found:
  Mov   EAX,True
@Done:

  Pop   EBP
  Pop   EBX              //restore the world
  Pop   EDI
  Pop   ESI
end;


function ScanW(const Source,Search:AnsiString;var Start:integer):Integer;

  {Forward scan from Start looking for a match of Search string containing
   wildcards:

     '*' = match any string (including null string)
     '?' = match any single character
     '#' = match any numeric character (0..9)
     '@' = match any alpha character (a..z, A..Z)
     '$' = match any alphanumeric character
     '~' = match any non-alphanumeric, non-space char.
    else = match given character only

   For case insensitive scan, use negative Start.

   Returns:  Minimum matching length, Start = Match location.  If no match,
             Result = 0 AND Start = 0. To continue a search, manually adjust
             Start beyond the returned match.}

asm
  Push  EBX              //save the important stuff
  Push  ESI
  Push  EDI
  Push  EBP

  Mov   R1,ECX           //save Start address
  Or    EAX,EAX          //zero source ?
  Jz    @NotFound
  Or    EDX,EDX          //zero search ?
  Jz    @NotFound

  Mov   ESI,EAX          //source address
  Mov   L1,EAX           //save it in L1
  Mov   EDI,EDX          //search address
  Mov   ECX,[ECX]        //get start value
  Or    ECX,ECX          //case insensitive ?
  Jns   @L0              //no, then skip
  Neg   ECX              //absolute value of ECX
  Mov   EAX,-1           //set case flag
@L0:
  Dec   ECX              //zero based start position
  Js    @NotFound        //abort if less than zero

  Mov   EDX,[ESI-4]      //source length
  Or    EDX,EDX
  Jz    @NotFound        //abort on null string
  Sub   EDX,ECX          //consider only remaining of source
  Jbe   @NotFound        //abort if source is too short
  Add   ESI,ECX          //start at the given offset

  Mov   ECX,[EDI-4]      //search length
  Or    ECX,ECX
  Jz    @NotFound        //abort on null string
  Mov   L2,ECX           //save it in L2
  Mov   ECX,EDX          //source length in ECX
  Xor   EBX,EBX          //source offset
  Xor   EDX,EDX          //search offset
  Xor   EBP,EBP
  Mov   R2,EDX           //zero our anchor
@Next:
  Cmp   EDX,L2           //end of search ?
  Jz    @Found           //yes, we found it!

  Mov   AH,[EDI+EDX]     //get next character from search
  Inc   EDX              //next offset

  Cmp   AH,42            //wildcard '*'
  Jnz   @L1              //no, then skip
  Mov   R2,EDX           //drop anchor here
  Mov   EBP,EBX
  Jmp   @Next            //get next character

@L1:
  Cmp   EBX,ECX          //end of source ?
  Ja    @NotFound        //yes, then time to go

  Mov   AL,[ESI+EBX]     //get next character from source
  Inc   EBX              //next offset

  Cmp   AH,63            //wildcard '?'
  Jz    @Next            //yes, then check next char.
@L3:
  Cmp   AH,35            //wildcard '#'
  Jnz   @L5
  Cmp   AL,48
  Jb    @L4
  Cmp   AL,57
  Jbe   @Next
  Jmp   @L4
@L5:
  Cmp   AH,64            //wildcard '@'
  Jnz   @L6
  Cmp   AL,32
  Jz    @L4

  Push  EBX
  Lea   EBX,AlphaT

  Call  _TstBit
  Pop   EBX
  Jc    @Next
  Jmp   @L4
@L6:
  Cmp   AH,126            //wildcard '~'
  Jnz   @L7

  Push  EBX
  Lea   EBX,AlphaNumT
  Call  _TstBit
  Pop   EBX
  Jnc   @Next
  Jmp   @L4
@L7:
  Cmp   AH,36            //wildcard '$'
  Jnz   @L8
  Cmp   AL,32
  Jz    @L4

  Push  EBX
  Lea   EBX,AlphaNumT
  Call  _TstBit
  Pop   EBX
  Jc    @Next
  Jmp   @L4
@L8:
  Cmp   AL,AH            //match ?
  Jz    @Next            //yes, then check next char.

  Test  EAX,$80000000    //case insensitive flag
  Jz    @L4

  Push  EAX
  Call  RChar
  Mov   [ESP],AL
  Pop   EAX
  Cmp   AL,AH            //match ?
  Jz    @Next            //yes, then check next char.

@L4:
  Mov   EBX,EBP          //roll back Source offset
  Mov   EDX,R2           //roll back Search
  Or    EDX,EDX          //anchored ?
  Jz    @L2              //no, then skip
  Inc   EBP              //increment offset instead of base
  Inc   EBX
  Jmp   @Next
@L2:
  Inc   ESI              //move to next character in source
  Dec   ECX
  Jnz   @Next

@NotFound:
  Xor   EAX,EAX          //clear return
  Mov   ESI,EAX
  Jmp   @Done            //and bail
@Found:
  Sub   ESI,L1           //calc offset
  Inc   ESI
  Mov   EAX,EBX          //match length
@Done:
  Mov   EDI,R1           //Start = offset
  Mov   [EDI],ESI

  Pop   EBP              //restore the world
  Pop   EDI
  Pop   ESI
  Pop   EBX
end;


function AnsiCompare(const S1,S2:AnsiString;I1,I2,Cnt:Integer):Integer;
  {Generic lexical comparison routine.}
var
  Flg:DWord;
  C1,C2:Integer;
begin
  if (I1<0) or (I2<0) then Flg:=NORM_IGNORECASE else Flg:=0;
  I1:=ABS(I1);
  I2:=ABS(I2);
  C1:=Length(S1)-I1+1;
  C2:=Length(S2)-I2+1;
  if Cnt>0 then begin
    C1:=iMin(Cnt,C1);
    C2:=iMin(Cnt,C2);
  end;
  Result:=CompareString(LOCALE_SYSTEM_DEFAULT,Flg,@S2[I2],C2,@S1[I1],C1)-2;
end;


function HyperCompare(S1,S2:AnsiString;I1,I2,Cnt:Integer):Integer;
  {Generic lexical comparison routine using the internal case tables.}
asm

  Push  EBX              //save the important stuff
  Push  ESI
  Push  EDI

  Mov   ESI,EAX          //S1 address
  Mov   EDI,EDX          //S2 address

  Or    ESI,ESI          //zero S1 ?
  Jz    @Less
  Or    EDI,EDI          //zero S2 ?
  Jz    @More
  Or    ECX,ECX          //I1
  Jz    @NotFound        //invalid so abort

  Xor   EDX,EDX          //use EDX as case flg
  Or    ECX,ECX          //I1,case sensitive ?
  Jns   @L0              //yes, then skip
  Neg   ECX              //absolute value of ECX
  Bts   EDX,31           //set our case flg
@L0:
  Dec   ECX              //zero based start position
  Mov   EAX,[ESI-4]      //S1 length
  Or    EAX,EAX
  Jz    @Less            //abort on null string
  Sub   EAX,ECX
  Jbe   @NotFound        //abort if source is too short
  Add   ESI,ECX          //start at the given offset

  Mov   EBX,[EBP+$08]    //Cnt
  Or    EBX,EBX          //zero?
  Jz    @L2
  Cmp   EAX,EBX          //use shorter, Length(S1) or Cnt
  Jae   @Skip1
@L2:
  Mov   EBX,EAX
  Bts   EDX,30           //set flag showing S1 is short
@Skip1:
  Mov   ECX,[EBP+$0C]    //I2
  Jecxz @NotFound        //abort on zero
  Or    ECX,ECX          //case sensitive ?
  Jns   @L1              //yes, then skip
  Neg   ECX              //absolute value
  Bts   EDX,31           //set our case flag
@L1:
  Dec   ECX              //zero based start position
  Mov   EAX,[EDI-4]      //S2 length
  Or    EAX,EAX
  Jz    @More            //abort on null string
  Sub   EAX,ECX
  Jbe   @NotFound        //abort if source is too short
  Add   EDI,ECX          //start at the given offset
  Cmp   EAX,EBX
  Ja    @Skip2
  Btr   EDX,30           //reset flag, S1 is not shorter
  Jz    @Skip2           //skip if equal
  Mov   EBX,EAX
  Bts   EDX,29           //show S2 is shorter
@Skip2:
  Mov   ECX,EBX          //max. length to compare
  Lea   EBX,RevCase      //load reverse case table
  Xor   EAX,EAX          //clear to use for table index
  Cld                    //make sure we go forward
@Top:                    //top of main comparison loop
  Lodsb                  //get a byte from S1
  Cmp   AL,[EDI]         //compare to S2
  Jz    @Next            //if equal then try next byte
  Bt    EDX,31           //not equal so check our case flag bit
  Jnc   @Found           //done here if case sensitive
  Mov   DL,[EBX+EAX]     //reverse case
  Cmp   DL,[EDI]         //compare again
  Jnz   @Test            //done here if not equal
@Next:
  Inc   EDI              //next byte in S2
  Dec   ECX              //count down
  Jnz   @Top             //do it again if necessary

  Bt    EDX,30           //select shorter
  Jc    @Less
  Bt    EDX,29
  Jc    @More
@Equal:
  Xor   EAX,EAX          //no shorter so show equal
  Jmp   @Exit
@Test:                   //case insensitive comes here
  Cmp   DL,AL            //select lowest possible character from S1
  Jb    @Skip3
  Mov   DL,AL
@Skip3:
  Mov   AL,[EDI]         //select lowest possible character from S2
  Mov   CL,[EBX+EAX]
  Cmp   CL,AL
  Jb    @Skip4
  Mov   CL,AL
@Skip4:
  Cmp   DL,CL            //compare lowest from S1 and S2
  Jb    @Less            //S1 is less
  Jmp   @More            //S1 is greater (Note: Equal is not an option hee)
@Found:                  //case sensitive comes here
  Cmp   AL,[EDI]
  Jb    @Less
  Jmp   @More
@NotFound:               //problems come here
  Mov   EAX,-2
  Jmp   @Exit
@Less:
  Xor   EAX,EAX          //first, assume they're equal
  Or    EDI,EDI          //zero S2 ?
  Jz    @Exit            //yes, then show equal
  Not   EAX              //otherwise; show S1 as less
  Jmp   @Exit
@More:
  Mov   EAX,1            //show S1 as greater
@Exit:
  Pop   EDI              //restore the world
  Pop   ESI
  Pop   EBX
end;


function StringAt(const Src,Table:AnsiString;Index,Cnt:Integer):Boolean;
  {Table based substring comparison using internal case table.}
asm
  Push  EBX              //save the important stuff
  Push  ESI
  Push  EDI

  Mov   ESI,EAX          //Src address
  Mov   EDI,EDX          //Table address

  Or    ESI,ESI          //zero Src ?
  Jz    @NotFound
  Or    EDI,EDI          //zero Table ?
  Jz    @NotFound
  Or    ECX,ECX          //Index
  Jz    @NotFound        //invalid so abort

  Xor   EDX,EDX          //use EDX as case flg
  Or    ECX,ECX          //case sensitive ?
  Jns   @L0              //yes, then skip
  Neg   ECX              //absolute value of ECX
  Bts   EDX,31           //set our case flg
@L0:
  Dec   ECX              //zero based start position
  Mov   EBX,[EBP+$08]    //Cnt
  Or    EBX,EBX          //zero or neg?
  Jbe   @NotFound        //yes, then abort
  Mov   EAX,[ESI-4]      //Src length
  Sub   EAX,ECX
  Jbe   @NotFound        //abort if Src is too short for Index
  Cmp   EAX,EBX
  Jb    @NotFound        //abort if remaining is too short for Cnt
  Add   ESI,ECX          //start at the given offset

  Mov   EAX,[EDI-4]      //Table length
  Or    EAX,EAX
  Jz    @NotFound        //abort on null string
  Cmp   EAX,EBX          //Table too short for Cnt
  Jb    @NotFound
  Mov   ECX,EDX          //case flag in ECX
  Xor   EDX,EDX          //divide Table length by Cnt
  Div   EBX
  Or    ECX,EAX          //compare count in CX
  Mov   EDX,EBX          //compare length in EDX

  Dec   ESI              //zero base addresses
  Dec   EDI
  Lea   EBX,RevCase      //load reverse case table
  Xor   EAX,EAX          //clear to use for table index

@Top:                    //top of main comparison loop
  Push  EDX              //save compare length
@ITop:
  Mov   AL,[ESI+EDX]     //get Src
  Cmp   AL,[EDI+EDX]     //compare to Table
  Jz    @Again           //if equal then try next byte
  Bt    ECX,31           //not equal so check our case flag bit
  Jnc   @NG              //done here if case sensitive
  Mov   AL,[EBX+EAX]     //reverse case
  Cmp   AL,[EDI+EDX]     //compare again
  Jnz   @NG              //done here if not equal
@Again:
  Dec   EDX
  Jnz   @ITop
  Pop   EDX
  Mov   EAX,True         //good one
  Jmp   @Exit
@NG:
  Pop   EDX
  Add   EDI,EDX          //next Table entry
  Dec   CX               //count it
  Jnz   @Top             //do it again if necessary
@NotFound:               //problems come here
  Xor   EAX,EAX
@Exit:
  Pop   EDI              //restore the world
  Pop   ESI
  Pop   EBX
end;


procedure _TestBit;
asm
  Mov   EBX,EAX
  Mov   EDX,EAX
  And   EDX,7           //bit index
  Shr   EBX,3           //byte index
  Mov   BL,[EBP+EBX]    //get byte
  Bt    EBX,EDX         //test the bit
end;


function MakeAlphaNum(var Source:AnsiString):Integer;

  {Convert any non-alphanumeric (0..9,A..Z,a..z) char. into right justified
   spaces which can be deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count; length minus chars. converted to spaces.}

  asm
    Push  ESI             //save the important stuff
    Push  EDI
    Push  EBX
    Push  EBP

    Xor   EBX,EBX         //default return
    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //put address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Mov   EDI,ESI         //read=write

    Jecxz @Done           //bail out if zero length
    Push  ECX
    Lea   EBP,AlphaNumT
    Xor   EAX,EAX
    Cld                   //make sure we go forward
@L1:
    Lodsb                 //get a byte
    Cmp   AL,32
    Jz    @NG

    Call  _TestBit
    Jnc   @NG             //abort if NG
@OK:
    Stosb                 //write it back
@NG:
    Dec   ECX
    Jnz   @L1
    Pop   EBX
    Mov   AL,32           //prepare to space fill
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb
    Dec   EBX             //decrease our length
    Jmp   @L3             //and do it again
@Done:
    Mov   EAX,EBX

    Pop   EBP
    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


function MakeAlpha(var Source:AnsiString):Integer;

  {Convert non-alpha (A..Z,a..z) char. into right justified spaces which
   can be deleted if necessary using RTrim or SetLength.

   Returns: Length minus #chars. converted to spaces to facilitate using
            SetLength if desired.}

  asm
    Push  ESI             //save the important stuff
    Push  EDI
    Push  EBX
    Push  EBP

    Xor   EBX,EBX         //default return
    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //put address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Mov   EDI,ESI         //read=write

    Jecxz @Done           //bail out if zero length
    Push  ECX
    Lea   EBP,AlphaT
    Xor   EAX,EAX
    Cld                   //make sure we go forward
@L1:
    Lodsb                 //get a byte
    Cmp   AL,32
    Jz    @NG

    Call  _TestBit
    Jnc   @NG             //abort if NG
@OK:
    Stosb                 //write it back
@NG:
    Dec   ECX
    Jnz   @L1
    Pop   EBX
    Mov   AL,32
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb
    Dec   EBX             //decrease our length
    Jmp   @L3             //and do it again
@Done:
    Mov   EAX,EBX

    Pop   EBP
    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


function MakeNum(var Source:AnsiString):Integer;

  {Convert non-numeric (0..9) char. into right justified spaces which
   can be deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count; length minus #chars. converted to spaces.}

  asm
    Push  ESI             //save the important stuff
    Push  EDI
    Push  EBX

    Xor   EBX,EBX         //default return
    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //put address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Mov   EDI,ESI         //read=write

    Jecxz @Done           //bail out if zero length
    Mov   EBX,ECX         //default length
    Cld                   //make sure we go forward
@L1:
    Lodsb                 //get a byte
    Cmp   AL,48           //less than zero?
    Jb    @NG             //yes, then skip
    Cmp   AL,57           //greater than 9 ?
    Ja    @NG             //yes, then skip
    Stosb                 //write it back
@NG:
    Dec   ECX
    Jnz   @L1
    Mov   AL,32
@L2:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb
    Dec   EBX             //decrease our length
    Jmp   @L2             //and do it again
@Done:
    Mov   Result,EBX

    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


function MakeTime(var Source:AnsiString):Integer;

  {Convert non-time [0..9,TimeSep] char. into right justified spaces which
   can be deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count; length minus #chars. converted to spaces.}

  asm
    Push  ESI             //save the important stuff
    Push  EDI
    Push  EBX

    Xor   EBX,EBX         //default return
    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //put address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Mov   EDI,ESI         //read=write

    Jecxz @Done           //bail out if zero length
    Mov   EBX,ECX         //default length
    Cld                   //make sure we go forward
@L1:
    Lodsb                 //get a byte
    Cmp   AL,TimeSep      //time separator is OK
    Jz    @OK
    Cmp   AL,48           //less than zero?
    Jb    @NG             //yes, then skip
    Cmp   AL,57           //greater than 9 ?
    Ja    @NG             //yes, then skip
@OK:
    Stosb                 //write it back
@NG:
    Dec   ECX
    Jnz   @L1
    Mov   AL,32
@L2:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb
    Dec   EBX             //decrease our length
    Jmp   @L2             //and do it again
@Done:
    Mov   Result,EBX

    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


function MakeHex(var Source:AnsiString):Integer;

  {Convert non-hexadecimal [0..9,A..F] char. into right justified spaces which
   can be deleted if necessary using RTrim or SetLength.  Also uppercases all
   non-numeric digits.

   Returns: Valid char. count; length minus #chars. converted to spaces.}

  asm
    Push  ESI             //save the important stuff
    Push  EDI
    Push  EBX

    Xor   EBX,EBX         //default return
    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //put address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Mov   EDI,ESI         //read=write

    Jecxz @Done           //bail out if zero length
    Mov   EBX,ECX         //default length
    Cld                   //make sure we go forward
@L1:
    Lodsb                 //get a byte
    Cmp   AL,48           //less than zero?
    Jb    @NG             //yes, then skip
    Cmp   AL,57           //<=9 ?
    Jbe   @OK             //yes, then good one
@L0:
    Cmp   AL,65           //< 'A' ?
    Jb    @NG             //yes, then no good
    Cmp   AL,70           //<= F?
    Jbe   @OK             //yes, then good one
    Btr   AX,5            //maybe lower case ?
    Jnc   @NG             //no, then no good
    Jmp   @L0             //try it again
@OK:
    Stosb                 //write it back
@NG:
    Dec   ECX
    Jnz   @L1
    Mov   AL,32
@L2:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb
    Dec   EBX             //decrease our length
    Jmp   @L2             //and do it again
@Done:
    Mov   Result,EBX

    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here



function MakeFloat(var Source:AnsiString):Integer;

  {Convert chars other than 0..9,E,+,-,Decimal into right justified
   spaces which can be deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count, length minus #chars. converted to spaces.}

  asm
    Push  ESI             //save the important stuff
    Push  EDI
    Push  EBX

    Xor   EBX,EBX         //default return
    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //put address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Mov   EDI,ESI         //read=write

    Jecxz @Done           //bail out if zero length
    Mov   EBX,ECX         //default length
    Cld                   //make sure we go forward
@Start:
    Lodsb                 //get a byte
    Cmp   AL,DecSep
    Jz    @OK             //decimal is OK
    Cmp   AL,69
    Jz    @OK             //'E' is OK
    Cmp   AL,101
    Jz    @OK             //'e' is OK
    Cmp   AL,43
    Jz    @OK             //'+' is OK
    Cmp   AL,45
    Jz    @OK             //'-' is OK
    Cmp   AL,48
    Jb    @NG             //less than 0 is NG
    Cmp   AL,57
    Ja    @NG             //greater than 9 is NG
@OK:
    Stosb                 //write it back
@NG:
    Dec   ECX
    Jnz   @Start

    Mov   AL,32
@L2:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb
    Dec   EBX             //decrease our length
    Jmp   @L2             //and do it again
@Done:
    Mov   Result,EBX

    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


function MakeFixed(var Source:AnsiString; const Count:Byte):Integer;

  {Convert chars other than 0..9,+,-,Decimal into right justified spaces, add
   or remove digits as required to produce Count decimal places. Increase
   length as necessary to add decimals.

   Returns: Valid char. count; length minus #chars. converted to spaces.}

var
  I:Integer;
begin
  UniqueString(Source);
  if Count>0 then begin
    I:=ScanB(Source,'.',-1);
    if I>0 then I:=Length(Source)-I;
    if I<Count then Source:=Source+DupChr(#32,Count-I+1);
  end;
  asm
    Push  ESI             //save the important stuff
    Push  EDI
    Push  EBX

    Xor   EBX,EBX         //default return
    Mov   EAX,Source
    Mov   ESI,[EAX]       //put address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Jecxz @Done           //bail out if zero length
    Mov   EDI,ESI         //read=write

    Mov   EBX,ECX         //default length
    Xor   EDX,EDX         //default decimal location
    Cld                   //make sure we go forward
@Start:
    Lodsb                 //get a byte
    Cmp   AL,DecSep
    Jnz   @L1
    Mov   EDX,EDI
    Jmp   @OK             //decimal is OK
@L1:
    Cmp   AL,43
    Jz    @OK             //'+' is OK
    Cmp   AL,45
    Jz    @OK             //'-' is OK
    Cmp   AL,48
    Jb    @NG             //less than 0 is NG
    Cmp   AL,57
    Ja    @NG             //greater than 9 is NG
@OK:
    Stosb                 //write it back
@NG:
    Dec   ECX
    Jnz   @Start

    Mov   AL,48           //assume we need to add zeros
    Or    EDX,EDX         //found a decimal point ?
    Jnz   @L0             //yes, then skip
    Mov   AH,DecSep
    Mov   [EDI],AH        //add the decimal
    Inc   EDI
    Jmp   @L2
@L0:
    Mov   ECX,EDI         //calc actual number of decimal places
    Inc   EDX
    Sub   ECX,EDX
    Mov   EDX,ECX
    Cmp   DL,Count        //decimals OK or need more?
    Jbe   @L2             //yes, then skip
    Sub   DL,Count        //calc extra decimals
    Sub   EDI,EDX         //adjust write pointer
    Mov   DL,Count        //adjust decimal count
@L2:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Cmp   DL,Count        //decimals OK
    Jb    @L3             //no, then skip
    Mov   AL,32           //pad with space
    Dec   EBX             //decrease our length
@L3:
    Inc   DL
    Stosb
    Jmp   @L2             //and do it again

@Done:
    Mov   Result,EBX      //save our result

    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here
end;


function MakeTable(var Source:AnsiString;const Table:AnsiString):Integer;

  {Convert non-table char. into right justified spaces which
   can be deleted if necessary using RTrim or SetLength.

   Returns: Valid char. count; length minus #chars. converted to spaces.

   Same as DeleteNI() but faster for shorter strings (20-30 chars or less)}

  asm
    Push  ESI             //save the important stuff
    Push  EDI
    Push  EBX

    Xor   EBX,EBX         //default return
    Mov   EAX,Source
    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Push  EAX
    Push  EDX
    Call  UniqueString
    Pop   EDX
    Pop   EAX
    Mov   ESI,[EAX]       //put address into read register
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Jecxz @Done           //bail out if zero length
    Mov   EDX,Table
    Or    EDX,EDX
    Jz    @Done
    Mov   EBX,[EDX-4]
    Or    EBX,EBX
    Jz    @Done

    Cld                   //make sure we go forward
    Push  ECX
    Push  EBP
    Mov   ECX,8
    Lea   EDI,iScan        //initialize scan array
    Xor   EAX,EAX
    Push  EDI              //save the pointer
    Rep   Stosd
    Pop   EDI              //restore pointer

    Dec   EDX
@L0:
    Mov   AL,[EDX+EBX]     //get a byte from table
    Mov   ECX,EAX          //save it in ECX
    And   ECX,31           //bit index
    Shr   EAX,5            //byte index, divide by 32
    Shl   EAX,2            //multiply by 4
    Mov   EBP,[EDI+EAX]    //get the dbl-word
    Bts   EBP,ECX          //set the bit
    Mov   [EDI+EAX],EBP    //store it back
    Dec   EBX              //do it again
    Jnz   @L0

    Mov   EDX,EDI
    Mov   EDI,ESI         //read=write
    Mov   ECX,[ESI-4]

@L1:
    Lodsb                  //get a byte
    Mov   BL,AL            //save it in BL
    Mov   BH,AL            //and in BH
    And   BL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBP,[EDX+EAX]    //get the dbl-word from table
    Bt    EBP,EBX
//*    Bt    EBP,BL           //test the bit
    Jnc   @Skip            //skip write if not in Table
    Mov   AL,BH
    Stosb
@Skip:
    Dec   ECX
    Jnz   @L1

    Pop   EBP
    Pop   EBX             //default length

    Mov   AL,32
@L2:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb                 //fill with a space
    Dec   EBX             //decrease our length
    Jmp   @L2             //and do it again
@Done:
    Mov   Result,EBX

    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


function ChrToInt(const Source:AnsiString):Integer;

  {Convert any 4 char. string into an integer. See IntToChr for
   discussion.}

  asm
    Mov   EDX,EAX         //Move address to EDX
    Xor   EAX,EAX         //Default return
    Or    EDX,EDX
    Jz    @Done
    Mov   ECX,[EDX-4]     //String Length into ECX
    Cmp   ECX,4           //Less than 4 bytes?
    Jb    @Done           //Yes, then abort
    Mov   EAX,[EDX]       //put 4 bytes into EAX
    BSwap EAX
@Done:
  end;                    //and we're outta here


function ChrToWord(const Source:AnsiString):Word;

  {Convert any 2 Char string into a word. See IntToChr for discussion.}

  asm
    Mov   EDX,EAX         //Move address to EDX
    Xor   EAX,EAX         //Default return
    Or    EDX,EDX
    Jz    @Done
    Mov   ECX,[EDX-4]     //String Length into ECX
    Cmp   ECX,2           //Less than 2 bytes?
    Jb    @Done           //Yes, then abort
    Mov   AX,[EDX]        //put 2 bytes into AX
    Xchg  AL,AH           //'little-endian'
@Done:
  end;                    //and we're outta here


function SwapEndian(const X:Integer):Integer;
  {Swaps byte/word order, MSB to LSB and vice versa}
asm
  BSwap  EAX     //works with 486+
{  Xchg  AL,AH
  Ror   EAX,16
  Xchg  AL,AH}
end;


function IntToChr(const X:Integer):AnsiString;

  {Convert any integer into a 4 byte MSB string representation.

   This produces a rather blank look on the faces of some programmers so
   let me try to address the typical questions.

   1) Why do this?

   There are many reasons, one example might be to tag a string with a
   numeric value (a database record number for example) without requiring
   any additional data structures. Simply convert the value and append to
   the end of the string. To retrieve the value, apply the complimentary
   ChrToInt function to the last 4 chars. Admittedly, this is a quick and
   dirty solution which possibly violates the spirit of Pascal's rigid type
   checking but rules are made to be broken <g>.

   2) Why MSB (Most-Significant-Byte first, also known as 'big-endian')?

   String comparison and testing is normally performed on a left to right,
   MSB basis.  By using this basis for the conversion, the standard
   comparison functions can be used on the resultant integer strings with
   proper results.  For example, if I>J=True then IntToChr(I)>IntToChr(J)
   will also equal True.

   NOTE: Embedded nulls and control characters are fully supported with
         AnsiStrings; just don't try casting the string as null terminated.
         In other words, don't pass it in an API call.}
  begin
    SetLength(Result,4);//first,let compiler create a result string
    asm
      Mov   EAX,X       //get X
      BSwap EAX

      Mov   EDX,@Result //get pointer to Result
      Mov   EDX,[EDX]   //get address from pointer
      Mov   [EDX],EAX   //store integer at address
    end;
  end;


function WordToChr(const X:Word):AnsiString;

  {Convert any word into a 2 Char string.  See IntToChr for discussion.}

  begin
    SetLength(Result,2);//first,let compiler create a result string
    asm
      Mov   AX,X        //get X
      XChg  AL,AH
      Mov   EDX,@Result //de-reference Result pointer
      Mov   EDX,[EDX]
      Mov   [EDX],AX    //store integer at address
    end;
  end;


function SngToChr(const X:Single):AnsiString;

  {Convert any single into a 4 byte MSB string representation. See
   IntToChr for discussion.  This conversion is 'internally exact'. In
   other words, converting from single to string and back again yields
   the original 'internal' representation 'exactly'. However; as always
   with floating point, this is only an approximation of the real value.}

  begin
    SetLength(Result,4);//first,let compiler create a result string
    asm
      Mov   EAX,X       //get X
      BSwap EAX
      Mov   EDX,@Result //get pointer to Result
      Mov   EDX,[EDX]   //get address from Result
      Mov   [EDX],EAX   //store single at address
    end;
  end;


function ChrToSng(const Source:AnsiString):Single;

  {Convert any 4 char. string into a single floating point value. See
   IntToChr for discussion.}

  asm
    Mov   EDX,EAX         //Move address to EDX
    Xor   EAX,EAX         //Default return
    Or    EDX,EDX
    Jz    @Done
    Mov   ECX,[EDX-4]     //String Length into ECX
    Cmp   ECX,4           //Less than 4 bytes?
    Jb    @Done           //Yes, then abort
    Mov   EAX,[EDX]       //put 4 bytes into EAX
    BSwap EAX
    Mov   @Result,EAX
@Done:
  end;                    //and we're outta here


function DblToChr(var X:Double):AnsiString;

  {Convert any Double into an 8 byte MSB string representation. See
   IntToChr for discussion.}

  begin
    SetLength(Result,8);//first,let compiler create a result string
    asm
      Push  ESI

      Mov   ESI,X       //get pointer to X
      Mov   EDX,@Result //get pointer to Result
      Mov   EDX,[EDX]   //get address from Result

      Mov   ECX,[ESI+4] //get 4 MSB's from X
      BSwap ECX
      Mov   [EDX],ECX   //store single at address

      Mov   ECX,[ESI]   //get 4 LSB's from X
      BSwap ECX
      Mov   [EDX+4],ECX //store single at address

      Pop   ESI
    end;
  end;


function ChrToDbl(const Source:AnsiString):Double;

  {Convert any 8 char. string into a Double floating point value. See
   IntToChr for discussion. As always with floating point, the
   representation is only approximate.}

  asm
    Push  EDI
    Push  ESI

    Mov   ESI,EAX         //Move address to EDX
    Xor   EDX,EDX
    Xor   EAX,EAX         //Default return
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //String Length into ECX
    Cmp   ECX,8           //Less than 8 bytes?
    Jb    @Done           //Yes, then abort

    Mov   EDX,[ESI]       //put 4 MSB into EDX
    BSwap EDX

    Mov   EAX,[ESI+4]     //put 4 LSB into EAX
    BSwap EAX
@Done:
    Lea   EDI,@Result
    Mov   [EDI],EAX
    Mov   [EDI+4],EDX

    Pop   ESI
    Pop   EDI
  end;                    //and we're outta here


function CurToChr(var X:Currency):AnsiString;

  {Convert a Currency type into an 8 byte MSB string representation. See
   IntToChr for discussion.}

begin
  Move(X,dI,8);
  Result:=DblToChr(dI);
end;


function ChrToCur(const Source:AnsiString):Currency;

  {Convert any 8 char. string into a Currency value. See IntToChr for
   discussion.}

begin
  dI:=ChrToDbl(Source);
  Move(dI,Result,8);
end;


function IntToBin(const X:Integer):AnsiString;

  {Convert any integer into a 32 byte right justified 1/0 string.  Use
   LTrim to remove leading zeros if desired.}

  begin
    SetLength(Result,32);
    asm
      Push  EDI
      Push  EAX

      Mov   EAX,@Result
      Mov   EDI,[EAX]   //de-reference Result pointer
      Mov   EDX,X       //restore X
      Mov   ECX,32
      Cld
      Mov   AL,48
@L1:
      And   AL,48
      Shl   EDX,1
      Jnc   @L2
      Or    AL,1
@L2:
      Stosb
      Dec   ECX
      Jnz   @L1
//      Loop  @L1
      Cld
      Pop   EAX
      Pop   EDI
    end;
  end;


function BinToInt(const Source:AnsiString):Integer;

  {Converts a right justified 1/0 binary string into an integer.}

  asm
    Push  ESI
    Xor   EDX,EDX         //Default return
    Or    EAX,EAX         //null pointer
    Jz    @Done
    Mov   ESI,EAX         //Move address to ESI
    Mov   ECX,[ESI-4]     //String Length into ECX
    Jecxz @Done           //Abort on null
    Cld                   //make sure we go forward
@L1:
    Lodsb                 //load a byte from string
    Sub   AL,48           //adjust for zero
    Jz    @L2
    Shr   AL,1
@L2:
    Rcl   EDX,1
@L3:
    Dec   ECX
    Jnz   @L1
@Done:
    Mov   EAX,EDX

    Pop   ESI

  end;                    //and we're outta here


function HexToInt(const Source:AnsiString):Integer;

  {Convert a hexidecimal string into an integer. Prefixes and otherwise
   invalid characters (any other than 0-9,A-F) are ignored.

   The standard Pascal way to achieve this is to prepend '$' to the string
   and use StrToInt while checking for exceptions. This function eliminates
   the need to prepend and returns zero if string is null.}

  asm
    Push  ESI             //Save the good stuff
    Or    EAX,EAX
    Jz    @Done
    Mov   ECX,[EAX-4]     //String Length into ECX
    Xor   EDX,EDX         //Default return
    Jecxz @Done           //Abort on null string
    Mov   ESI,EAX         //Address into ESI
    Xor   AL,AL           //clear AL
    Cld                   //make sure we go forward
@L1:
    Lodsb                 //get the first byte into AL
    Cmp   AL,48           //less than 0 ?
    Jb    @L3             //yes, then ignore
    Sub   AL,48           //adjust for 0-9
    Cmp   AL,10           //OK ?
    Jb    @L2             //yes, then continue
    Sub   AL,7            //no, then adjust for A-F
    Cmp   AL,15           //OK ?
    Ja    @Done           //no, then abort
@L2:
    Shl   EDX,4           //make room for 4 bits
    Or    DL,AL           //add AL to EDX
@L3:
    Dec   ECX
    Jnz   @L1

@Done:
    Mov   EAX,EDX         //return 4 bytes into EAX
    Pop   ESI

  end;                    //and we're outta here


function EnCodeInt(const X:Integer):AnsiString;

  {Encode any integer as a truncated 6 char base64 string that is Internet,
   mainframe and database safe.}

  begin
    SetLength(Result,6);//first,let compiler create a result string
    asm
      Push  ESI         //save the good stuff
      Push  EDI

      Mov   EAX,@Result
      Mov   ESI,[EAX]   //de-reference Result pointer
      Mov   EDX,[ESI-4] //get length in EDX
      Cmp   EDX,6       //set properly ?
      Jnz   @Done       //no, then big problem, abort
      Mov   EDX,X       //restore X
      Xchg  DL,DH       //use "big-endian" order for left to right
      Ror   EDX,16      //  string comparisons
      Xchg  DL,DH
      Lea   EDI,B64Tbl  //get table address
      Inc   EDI         //skip length byte
      Mov   ECX,6       //output 6 bytes
      Xor   EAX,EAX
@Next:
      Mov   AL,DL       //get first byte
      And   AL,63       //use 6 bits only
      Mov   AL,[EDI+EAX]//get table value
      Mov   [ESI],AL    //store character at address
      Shr   EDX,6       //ready for next 6 bits
      Inc   ESI         //ready for next output
      Dec   ECX
      Jnz   @Next
@Done:
      Pop   EDI
      Pop   ESI
    end;                //and we're done

  end;


function DeCodeInt(const Source:AnsiString):Integer;

  {Decode a 6 Char integer string created with EnCodeInt and return the
   original integer value.}

  asm
    Push  ESI             //Save the good stuff
    Push  EDI
    Push  EBX

    Xor   EDX,EDX         //Default return
    Or    EAX,EAX
    Jz    @Done
    Mov   ESI,EAX         //String address in ESI
    Mov   EBX,[EAX-4]     //String Length into EBX
    Xor   EAX,EAX
    Cmp   EBX,6           //String too short ?
    Jb    @Done           //yes, then abort
    Lea   EBX,B64Tbl      //Table address in EDI
    Inc   EBX             //skip length byte
    Mov   AH,6            //examine 6 bytes only
    Cld                   //make sure we go forward
@Next:
    Lodsb                 //get first byte
    Mov   ECX,64          //setup for table scan
    Mov   EDI,EBX         //get table address
    Repnz Scasb           //scan it
    Jnz   @NG             //found one ?
    Dec   EDI
    Sub   EDI,EBX         //calc table offset
    Or    EDX,EDI         //combine with total
    Ror   EDX,6
@NG:
    Dec   AH              //decrease our count
    Jnz   @Next           //do it again
    Rol   EDX,4
@Done:
    Mov   EAX,EDX         //return 4 bytes into EAX
    Xchg  AL,AH           //'little-endian'
    Rol   EAX,16
    Xchg  AL,AH

    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;                    //and we're outta here


function EnCodeWord(const X:Word):AnsiString;

  {Encode any integer as a truncated 3 char base64 string that is Internet,
   mainframe and database safe.}

  begin
    SetLength(Result,3);//first,let compiler create a result string
    asm
      Push  ESI         //save the good stuff
      Push  EDI

      Mov   EAX,@Result
      Mov   ESI,[EAX]   //de-reference Result pointer
      Mov   EDX,[ESI-4] //get length in EDX
      Cmp   EDX,3       //set properly ?
      Jnz   @Done       //no, then big problem, abort
      Xor   EDX,EDX
      Mov   DX,X        //restore X
      Xchg  DL,DH       //use "big-endian" order for left to right
      Lea   EDI,B64Tbl  //get table address
      Inc   EDI         //skip length byte
      Mov   ECX,3       //output 3 bytes
      Xor   EAX,EAX
@Next:
      Mov   AL,DL       //get first byte
      And   AL,63       //use 6 bits only
      Mov   AL,[EDI+EAX]//get table value
      Mov   [ESI],AL    //store character at address
      Shr   EDX,6       //ready for next 6 bits
      Inc   ESI         //ready for next output
      Dec   ECX
      Jnz   @Next
@Done:
      Pop   EDI
      Pop   ESI
    end;                //and we're done

  end;


function DeCodeWord(const Source:AnsiString):Word;

  {Decode a 3 Char integer string created with EnCodeInt and return the
   numeric value.}

  asm
    Push  ESI             //Save the good stuff
    Push  EDI
    Push  EBX

    Xor   EDX,EDX         //Default return
    Or    EAX,EAX
    Jz    @Done
    Mov   ESI,EAX         //String address in ESI
    Mov   EBX,[EAX-4]     //String Length into EBX
    Xor   EAX,EAX
    Cmp   EBX,3           //String too short ?
    Jb    @Done           //yes, then abort
    Lea   EBX,B64Tbl      //Table address in EDI
    Inc   EBX             //skip length byte
    Mov   AH,3            //examine 3 bytes only
    Cld                   //make sure we go forward
@Next:
    Lodsb                 //get first byte
    Mov   ECX,64          //setup for table scan
    Mov   EDI,EBX         //get table address
    Repnz Scasb           //scan it
    Jnz   @NG             //found one ?
    Dec   EDI
    Sub   EDI,EBX         //calc table offset
    Or    EDX,EDI         //combine with total
    Ror   EDX,6
@NG:
    Dec   AH              //decrease our count
    Jnz   @Next           //do it again
    Ror   EDX,14
@Done:
    Mov   EAX,EDX         //return 4 bytes into EAX
    Xchg  AL,AH           //'little-endian'

    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;                    //and we're outta here


function EnCodeSng(const X:Single):AnsiString;

  {Encode any single floating point value as a 6 char base64 string
   that is Internet, mainframe and database safe.  This conversion is
   'internally exact'.}

var
  I:Integer;
begin
  Move(X,I,4);
  Result:=EnCodeInt(I);
end;


function DeCodeSng(const Source:AnsiString):Single;

  {Decode a 6 Char integer string created with EnCodeSng and return the
   original floating point single value.}

var
  I:Integer;
begin
  I:=DeCodeInt(Source);
  Move(I,Result,4);
end;


function EnCodeDbl(var X:Double):AnsiString;

  {Encode any FP double as an 11 char base64 string that is Internet,
   mainframe and database safe.  This conversion is 'internally exact'.}

  begin
    SetLength(Result,11);//first,let compiler create a result string
    asm
      Push  ESI         //save the good stuff
      Push  EDI
      Push  EBX

      Mov   EAX,@Result
      Mov   ESI,[EAX]   //de-reference Result pointer

      Mov   EDX,[ESI-4] //get length in EDX
      Cmp   EDX,11      //set properly ?
      Jnz   @Done       //no, then big problem, abort

      Lea   EDI,B64Tbl  //get table address
      Inc   EDI         //skip length byte
      Mov   EAX,X       //restore X
      Mov   EBX,[EAX+4] //get MSB's in EBX
      Mov   EDX,[EAX]   //get LSB's in EDX
      XChg  BL,BH       //use 'big-endian'
      Ror   EBX,16
      XChg  BL,BH
      XChg  DL,DH
      Ror   EDX,16
      XChg  DL,DH
      Xor   EAX,EAX
      Mov   ECX,11
@Next:
      Mov   AL,BL       //get byte
      And   AL,63       //use 6 bits only
      Mov   AL,[EDI+EAX]//get table value
      Mov   [ESI],AL    //store character at address
      Shr   EDX,1       //ready for next 6 bits
      Rcr   EBX,1
      Shr   EDX,1
      Rcr   EBX,1
      Shr   EDX,1
      Rcr   EBX,1
      Shr   EDX,1
      Rcr   EBX,1
      Shr   EDX,1
      Rcr   EBX,1
      Shr   EDX,1
      Rcr   EBX,1
      Inc   ESI         //ready for next output

      Dec   ECX
      Jnz   @Next

@Done:
      Pop   EBX
      Pop   EDI
      Pop   ESI
    end;                //and we're done

  end;


function DeCodeDbl(const Source:AnsiString):Double;

  {Decode an 11 Char double string created with EnCodeDbl and return the
   numeric value.}

  asm
    Push  ESI             //Save the good stuff
    Push  EDI
    Push  EBX

    Xor   EDX,EDX         //Default return
    Xor   EBX,EBX
    Or    EAX,EAX
    Jz    @Done
    Mov   ESI,EAX         //String address in ESI
    Mov   EAX,[ESI-4]     //String Length into EAX
    Cmp   EAX,11          //String too short ?
    Jb    @Done           //yes, then abort
    Lea   EDI,B64Tbl      //Table address in EDI
    Add   ESI,10          //work backwards
    Add   EDI,64
    Mov   AH,10           //examine 10 in loop
    Std                   //make sure we go BACKWARD
    Lodsb                 //get the first byte
    Push  EDI             //save EDI on stack
    Mov   ECX,64          //setup for table scan
    Repnz Scasb           //scan it
    Pop   EDI             //restore EDI
    Jnz   @Next           //found one ?
    Shl   EBX,1           //make room for it
    Rcl   EDX,1
    Shl   EBX,1
    Rcl   EDX,1
    Shl   EBX,1
    Rcl   EDX,1
    Shl   EBX,1
    Rcl   EDX,1
    Or    EBX,ECX         //combine with total
@Next:
    Lodsb                 //get next byte
    Push  EDI             //save EDI on stack
    Mov   ECX,64          //setup for table scan
    Repnz Scasb           //scan it
    Pop   EDI             //restore EDI
    Jnz   @NG             //found one ?
    Shl   EBX,1           //make room for it
    Rcl   EDX,1
    Shl   EBX,1
    Rcl   EDX,1
    Shl   EBX,1
    Rcl   EDX,1
    Shl   EBX,1
    Rcl   EDX,1
    Shl   EBX,1
    Rcl   EDX,1
    Shl   EBX,1
    Rcl   EDX,1
    Or    EBX,ECX         //combine with total
@NG:
    Dec   AH              //decrease our count
    Jnz   @Next           //do it again if necessary
@Done:
    XChg  BL,BH
    Rol   EBX,16
    XChg  BL,BH
    XChg  DL,DH           //'little-endian'
    Rol   EDX,16
    XChg  DL,DH

    Lea   EDI,@Result     //get pointer to Result
    Mov   [EDI+4],EBX       //store double at address
    Mov   [EDI],EDX

    Cld
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;                    //and we're outta here


function EnCodeCur(var X:Currency):AnsiString;

  {Encode any Currency type as an 11 char base64 string that is Internet,
   mainframe and database safe.  This conversion is 'internally exact'.}

begin
  Move(X,dI,8);
  Result:=EnCodeDbl(dI);
end;


function DeCodeCur(const Source:AnsiString):Currency;

  {Decode an 11 Char currency string created with EnCodeCur and return the
   original Currency type value.}

begin
  dI:=DeCodeDbl(Source);
  Move(dI,Result,8);
end;


function EnCodeStr(const Source:AnsiString):AnsiString;

  {Encode a string using base64 encoding compatible with Internet protocol
   RFC 1521 (the MIME standard).  Data encoded in this manner is safe for
   Internet, database and mainframe storage and use. By definition,
   the resultant string is at least 1/3 longer than the original}

  begin
    OutLen:=4*((Length(Source)+2) DIV 3);
    SetLength(Result,OutLen);             //first, create a result string
    if Length(Result)<>OutLen then Exit;  //big time problems
    asm
      Push  ESI         //save the good stuff
      Push  EDI
      Push  EBX

      Mov   ESI,Source  //get source address
      Mov   EDI,@Result //Result address
      Mov   EDI,[EDI]
      Or    ESI,ESI
      Jz    @Abort
      Mov   ECX,[ESI-4] //source length
      Jecxz @Abort      //abort on null
      Lea   EBX,B64Tbl  //get table address in EBX
      Inc   EBX         //skip length byte
      Xor   EAX,EAX     //Clear EAX
      Xor   EDX,EDX     //Clear EDX
      Mov   DH,2        //initialize output flg
      Cld               //make sure we go forward
@Next:
      Lodsb             //get a byte from Source
      Shl   EAX,8
      Or    DH,DH       //flag zero ?
      Jz    @Write4     //yes, then write the output
      Shr   DH,1
@L1:
      Dec   ECX
      Jnz   @Next

      Test  DH,2        //flag initialized ?
      Jnz   @Done       //yes, then we're done

      Test  DH,1        //2 in the hopper ?
      Jz    @L2         //yes, then skip ahead

      Shl   EAX,16      //otherwise, only 1
      Mov   EDX,EAX     //save what we got
      Xor   EAX,EAX
      Rol   EDX,6
      Call  @Write1     //write 1st byte
      Rol   EDX,6
      Call  @Write1     //write 2nd byte
      Mov   EAX,64       //fill char '='
      Call  @Write0     //write 3rd byte
      Mov   EAX,64       //fill char '='
      Call  @Write0     //write 4th byte
      Jmp   @Done       //and we're done
@L2:
      Shl   EAX,8       //2 in the hopper
      Mov   EDX,EAX     //save them
      Xor   EAX,EAX
      Rol   EDX,6
      Call  @Write1     //write 1st byte
      Rol   EDX,6
      Call  @Write1     //write second byte
      Rol   EDX,6
      Call  @Write1     //write 3rd byte
      Mov   EAX,64       //fill char '='
      Call  @Write0     //write 4th byte
@Abort:
      Jmp   @Done

@Write4:
      Mov   EDX,EAX     //save what we got
      Xor   EAX,EAX     //must clear, EAX used for table lookup
      Rol   EDX,6
      Call  @Write1
      Rol   EDX,6
      Call  @Write1
      Rol   EDX,6
      Call  @Write1
      Rol   EDX,6
      Call  @Write1
      Mov   DH,2        //initialize flag
      Jmp   @L1         //jump back into line

@Write1:
      Mov   AL,DL
      And   AL,63       //use lower 6 bits only
@Write0:
      Mov   AL,[EBX+EAX]//get table value
      Stosb             //store in Result
      Ret

@Done:
      Pop   EBX
      Pop   EDI
      Pop   ESI
    end;                //and we're done
  end;


function DeCodeStr(const Source:AnsiString):AnsiString;

  {Decode a base64 string created with EnCodeStr and return the original.
   By definition, the length of a properly encoded base64 string is a
   multiple of 4. This routine ignores any fractional excess.}

  begin
    OutLen:=3*(Length(Source) DIV 4);      //calc output length
    SetLength(Result,OutLen);              //create the resultant
    if Length(Result)<>OutLen then Exit;   //big time problems
    OutLen:=0;
    asm
      Push  ESI         //save the good stuff
      Push  EDI
      Push  EBX

      Mov   ESI,Source  //get source address
      Mov   EDI,@Result //Result address
      Mov   EDI,[EDI]
      Or    ESI,ESI
      Jz    @Abort
      Mov   EDX,[EDI-4] //Result length
      Mov   ECX,[ESI-4] //source length
      Shr   ECX,2       //divide by 4
      Jecxz @Abort      //abort on null
      Xor   EAX,EAX     //Clear EAX
      Cld               //make sure we go forward
@Next:
      Lodsd             //get 4 bytes from Source

      Xor   EDX,EDX     //clear accumulator
      Xor   EBX,EBX     //clear byte counter
      Call  @Decode
      Shr   EAX,8
      Call  @Decode
      Shr   EAX,8
      Call  @Decode
      Shr   EAX,8
      Call  @Decode

      Rol   EDX,10
      Or    BL,BL       //any octets output ?
      Jz    @Again      //no, then try again
      Dec   BL          //only 1 octet
      Jz    @Again      //yes, not enough for a byte, try again
      Mov   AL,DL
      Stosb             //write 1st byte
      Inc   OutLen
      Dec   BL          //any left
      Jz    @Again      //no, then try again
      Rol   EDX,8       //yes, then get it and output
      Mov   AL,DL
      Stosb             //write 2nd byte
      Inc   OutLen
      Dec   BL
      Jz    @Again
      Rol   EDX,8
      Mov   AL,DL
      Stosb             //write 3rd byte
      Inc   OutLen
@Again:
      Dec   ECX
      Jnz   @Next

@Abort:
      Jmp   @Done

@Decode:
      Cmp   AL,61
      Jz    @NG
      Cmp   AL,43
      Jb    @NG
      Cmp   AL,122
      Jg    @NG

      Cmp   AL,43     //+
      Jnz   @L1
      Mov   AL,62
      Jmp   @OK
@L1:
      Cmp   AL,47     //slash
      Jnz   @L2
      Mov   AL,63
      Jmp   @OK
@L2:
      Cmp   AL,48   //0
      Jb    @NG
      Cmp   AL,57   //9
      Jg    @L3
      Add   AL,4
      Jmp   @OK
@L3:
      Cmp   AL,65   //A
      Jb    @NG
      Cmp   AL,90   //Z
      Jg    @L4
      Sub   AL,65
      Jmp   @OK
@L4:
      Cmp   AL,97   //a
      Jb    @NG
      Sub   AL,71
@OK:
      Inc   BL
@NG:
      Or    DL,AL
      Shl   EDX,6
      Ret

@Done:
      Pop   EBX
      Pop   EDI
      Pop   ESI

    end;                        //and we're done...almost
    SetLength(Result,OutLen);   //set actual length decoded
  end;


function  EnCodeBCD(const Source:AnsiString):AnsiString;

  {Encode a numeric ASCII string (chars. 0..9) into unsigned packed decimal
   (BCD) format. By definition, the resultant string is 1/2 (+1 if odd # digits)
   the original's size.}

  begin
    if Length(Source)=0 then Exit;
    OutLen:=(Length(Source)+1) DIV 2;      //calc output length
    SetLength(Result,OutLen);              //create the resultant
    if Length(Result)<>OutLen then Exit;   //big time problems
    OutLen:=0;
    asm
      Push  ESI         //save the good stuff
      Push  EDI

      Mov   ESI,Source  //get source address
      Mov   EDI,@Result //Result address
      Mov   EDI,[EDI]
      Mov   ECX,[ESI-4] //source length
      Jecxz @Abort      //abort on null
      Xor   EAX,EAX     //Clear EAX
      Test  CL,1         //odd number of bytes ?
      Jz    @Start       //no, then start
      Or    AH,1         //prefix with 0
      Cld               //make sure we go forward
@Start:
      Lodsb             //get a byte from Source
      Cmp   AL,48
      Jb    @SkipIt
      Cmp   AL,57
      Ja    @SkipIt

      Sub   AL,48
      Test  AH,1
      Jnz   @X1
      Shl   AL,4
      Mov   AH,AL
      Or    AH,1
      Jmp   @SkipIt
@X1:
      And   AH,240
      Or    AL,AH
      Stosb
      Inc   OutLen
@SkipIt:
      Dec   ECX
      Jnz   @Start
//      Loop @Start            //loop until string is exhausted
@Abort:
      Pop   EDI
      Pop   ESI
  end;                       //and we're done
  SetLength(Result,OutLen);  //reset the resultant length
end;


function  DeCodeBCD(const Source:AnsiString):AnsiString;

  {Decode an unsigned packed decimal (BCD) string and return numeric ASCII.
   By definition, the resultant string is twice (-1 if odd # digits) the
   original's size.}

  begin
    if Length(Source)=0 then Exit;         //abort on null
    OutLen:=(Length(Source) * 2);          //calc max output length
    SetLength(Result,OutLen);              //create the resultant
    if Length(Result)<>OutLen then Exit;   //big time problems
    OutLen:=0;
    asm
      Push  ESI         //save the good stuff
      Push  EDI
      Push  EBX

      Mov   ESI,Source  //get source address
      Mov   EDI,@Result //Result address
      Mov   EDI,[EDI]
      Mov   ECX,[ESI-4] //source length
      Jecxz @Abort      //abort on null (should never happen but you never know)
      Xor   EAX,EAX     //Clear EAX
      Mov   BL,15       //useful constants
      Mov   BH,48
      Cld               //make sure we go forward
      Lodsb             //get the first byte
      Mov   AH,AL       //check for 0 padding
      And   AH,BL
      Cmp   AL,AH
      Jz    @Pad
      Jmp   @NoPad
@Again:
      Lodsb                 //get a character from string
@NoPad:
      Mov   AH,AL           //save a copy
      Shr   AL,4            //output high nibble first
      Add   AL,BH           //convert to ASCII
      Stosb                 //store it
      Inc   OutLen          //keep track of output
      And   AH,BL           //output lower nibble
      Mov   AL,AH
@Pad:
      Add   AL,BH           //convert to ASCII
      Stosb                 //store it
      Inc   OutLen
      Dec   ECX
      Jnz   @Again
//      Loop  @Again           //loop until string is exhausted
@Abort:
      Pop   EBX             //restore the world
      Pop   EDI
      Pop   ESI
    end;
    SetLength(Result,OutLen);  //reset the resultant length (odd # digits)
  end;


function Soundex(const Source:AnsiString):Integer;

  {Encode a string as a 4 byte integer value using the Soundex table
   originally provided by your friendly US Census Bureau:

                   BCDFGJKLMNPQRSTVXZ
                   123122245512623122

   NOTE: This function returns an integer for faster and more efficient
         comparisons. If you prefer the more traditional string
         representation, simply apply IntToChr to the resultant integer.}

  asm
    Push  ESI             //Save the good stuff
    Push  EBX

    Or    EAX,EAX
    Jz    @Done
    Mov   ECX,[EAX-4]     //String Length into ECX
    Mov   EDX,'0000'
    Jecxz @Done           //Abort on null string
    Mov   ESI,EAX         //Address into ESI
    Xor   AX,AX           //clear AX
    Xor   BX,BX           //...and BX
    Cld                   //make sure we go forward
@Top:
    Lodsb                 //get the first byte into AL
    Cmp   AL,65           //ignore non-alpha char.
    Jb    @Next
    Cmp   AL,122
    Ja    @Next
    And   AL,95           //make upper case
    Or    BL,BL           //first char.
    Jnz   @Scan           //no, then find the code
    Mov   DL,AL           //yes, just use first char.
    Ror   EDX,8
    Mov   BL,1
    Jmp   @Next
@L1:
    Mov   AL,49
    Jmp   @LL
@L2:
    Mov   AL,50
    Jmp   @LL
@L3:
    Mov   AL,51
    Jmp   @LL
@L4:
    Mov   AL,52
    Jmp   @LL
@L5:
    Mov   AL,53
    Jmp   @LL
@L6:
    Mov   AL,54
@LL:
    Cmp   AL,AH           //same as last ?
    Jz    @Next           //yes, then skip
    Mov   AH,AL           //save code
    Mov   DL,AL           //add to result
    Ror   EDX,8
    Add   BL,1            //increment code counter
@Next:
    Cmp   BL,4            //all done ?
    Jz    @Done           //yes, then bail out
    Dec   ECX
    Jnz   @Top
//    Loop  @Top            //do it again
@CleanUp:
    Rol   EDX,8
    Dec   BX
    Jbe   @Done
    Jmp   @CleanUp
@Done:
    Mov   EAX,EDX         //return 4 bytes in EAX
    Pop   EBX             //restore
    Pop   ESI
    Ret                   //and we're outta here

@Scan:                    //unrolled scan loop - total code size increases
    Sub   AL,66 //66      //...but so does speed.
    Jz    @L1
    Dec   AL    //67
    Jz    @L2
    Dec   AL    //68
    Jz    @L3
    Dec   AL
    Jz    @Next
    Dec   AL    //70
    Jz    @L1
    Dec   AL    //71
    Jz    @L2
    Sub   AL,3  //74
    Jc    @Next
    Jz    @L2
    Dec   AL    //75
    Jz    @L2
    Dec   AL    //76
    Jz    @L4
    Dec   AL    //77
    Jz    @L5
    Dec   AL    //78
    Jz    @L5
    Dec   AL
    Jz    @Next
    Dec   AL    //80
    Jz    @L1
    Dec   AL    //81
    Jz    @L2
    Dec   AL    //82
    Jz    @L6
    Dec   AL    //83
    Jz    @L2
    Dec   AL    //84
    Jz    @L3
    Dec   AL
    Jz    @Next
    Dec   AL    //86
    Jz    @L1
    Dec   AL
    Jz    @Next
    Dec   AL    //88
    Jz    @L2
    Dec   AL
    Jz    @Next
    Dec   AL    //90
    Jz    @L2
    Jmp   @Next
  end;                    //and we're outta here


procedure EnCipher(var Source:AnsiString);

  {Low order, 7-bit ASCII (char. 32-127) encryption designed for database use.
   Control and high order (8 bit) characters are passed through unchanged.

   Uses a hybrid method...random table substitution with bit-mangled output.
   No passwords to worry with (the built-in table is the password). Not industrial
   strength but enough to deter the casual hacker or snoop. Even repeating char.
   sequences have little discernable pattern once encrypted.

   NOTE: When displaying encrypted strings, remember that some characters
         within the output range are interpreted by VCL components; for
         example, '&'.}

  asm
    Push  ESI             //Save the good stuff
    Push  EDI

    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //String address into ESI
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //String Length into ECX
    Jecxz @Done           //Abort on null string
    Mov   EDX,ECX         //initialize EDX with length
    Lea   EDI,@ECTbl      //Table address into EDI
    Cld                   //make sure we go forward
@L1:
    Xor   EAX,EAX
    Lodsb                 //Load a byte from string
    Sub   AX,32           //Adjust to zero base
    Js    @Next           //Ignore if control char.
    Cmp   AX,95
    Jg    @Next           //Ignore if high order char.
    Mov   AL,[EDI+EAX]    //get the table value
    Test  CX,3            //screw it up some
    Jz    @L2
    Rol   EDX,3
@L2:
    And   DL,31
    Xor   AL,DL
    Add   EDX,ECX
    Add   EDX,EAX
    Add   AL,32           //adjust to output range
    Mov   [ESI-1],AL      //write it back into string
@Next:
    Dec   ECX
    Jnz   @L1
//    Loop  @L1             //do it again if necessary

@Done:
    Pop   EDI
    Pop   ESI

    Jmp   @Exit
//    Ret                   //this does not work with Delphi 3 - EFD 971022

@ECTbl:  //The encipher table
    DB   75,85,86,92,93,95,74,76,84,87,91,94
    DB   63,73,77,83,88,90,62,64,72,78,82,89
    DB   51,61,65,71,79,81,50,52,60,66,70,80
    DB   39,49,53,59,67,69,38,40,48,54,58,68
    DB   27,37,41,47,55,57,26,28,36,42,46,56
    DB   15,25,29,35,43,45,14,16,24,30,34,44
    DB   06,13,17,23,31,33,05,07,12,18,22,32
    DB   01,04,08,11,19,21,00,02,03,09,10,20
@Exit:

  end;


procedure DeCipher(var Source:AnsiString);

  {Decrypts a string previously encrypted with EnCipher.}

  asm
    Push  ESI             //Save the good stuff
    Push  EDI
    Push  EBX

    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]       //String address into ESI
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //String Length into ECX
    Jecxz @Done           //Abort on null string
    Mov   EDX,ECX         //Initialize EDX with length
    Lea   EDI,@DCTbl      //Table address into EDI
    Cld                   //make sure we go forward
@L1:
    Xor   EAX,EAX
    Lodsb                 //Load a byte from string
    Sub   AX,32           //Adjust to zero base
    Js    @Next           //Ignore if control char.
    Cmp   AX,95
    Jg    @Next           //Ignore if high order char.
    Mov   EBX,EAX         //save to accumulate below
    Test  CX,3            //unscrew it
    Jz    @L2
    Rol   EDX,3
@L2:
    And   DL,31
    Xor   AL,DL
    Add   EDX,ECX
    Add   EDX,EBX
    Mov   AL,[EDI+EAX]    //get the table value
    Add   AL,32           //adjust to output range
    Mov   [ESI-1],AL      //store it back in string
@Next:
    Dec   ECX
    Jnz   @L1
//    Loop  @L1             //do it again if necessary

@Done:
    Pop   EBX
    Pop   EDI
    Pop   ESI

    Jmp   @Exit
//    Ret        Does not work with Delphi3 - EFD 971022

@DCTbl:  //The decryption table
    DB   90,84,91,92,85,78,72,79,86,93,94,87
    DB   80,73,66,60,67,74,81,88,95,89,82,75
    DB   68,61,54,48,55,62,69,76,83,77,70,63
    DB   56,49,42,36,43,50,57,64,71,65,58,51
    DB   44,37,30,24,31,38,45,52,59,53,46,39
    DB   32,25,18,12,19,26,33,40,47,41,34,27
    DB   20,13,06,00,07,14,21,28,35,29,22,15
    DB   08,01,02,09,16,23,17,10,03,04,11,05
@Exit:
  end;


procedure Crypt(var Source:AnsiString;const Key:AnsiString);

  {Encrypt AND decrypt strings using an enhanced XOR technique similar to
   S-Coder (DDJ, Jan. 1990). To decrypt, simply re-apply the procedure
   using the same password key. This algorithm is reasonably secure on
   it's own; however,there are steps you can take to make it even more
   secure.

         1) Use a long key that is not easily guessed.
         2) Double or triple encrypt the string using different keys.
            To decrypt, re-apply the passwords in reverse order.
         3) Use EnCipher before using Crypt.  To decrypt, re-apply Crypt
            first then use DeCipher.
         4) Some unique combination of the above

   NOTE: The resultant string may contain any character, 0..255.}


  asm
    Push  ESI             //Save the good stuff
    Push  EDI
    Push  EBX

    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Push  EDX
    Call  UniqueString
    Pop   EDX
    Pop   EAX
    Mov   EDI,[EAX]       //String address into EDI
    Or    EDI,EDI
    Jz    @Done
    Mov   ECX,[EDI-4]     //String Length into ECX
    Jecxz @Done           //Abort on null string
    Mov   ESI,EDX         //Key address into ESI
    Or    ESI,ESI
    Jz    @Done
    Mov   EDX,[ESI-4]     //Key Length into EDX
    Dec   EDX             //make zero based
    Js    @Done           //abort if zero key length
    Mov   EBX,EDX         //use EBX for rotation offset
    Mov   AH,DL           //seed with key length
    Cld                   //make sure we go forward
@L1:
    Test  AH,8            //build stream char.
    Jnz   @L3
    Xor   AH,1
@L3:
    Not   AH
    Ror   AH,1
    Mov   AL,[ESI+EBX]    //Get next char. from Key
    Xor   AL,AH           //XOR key with stream to make pseudo-key
    Xor   AL,[EDI]        //XOR pseudo-key with Source
    Stosb                 //store it back
    Dec   EBX             //less than zero ?
    Jns   @L2             //no, then skip
    Mov   EBX,EDX         //re-initialize Key offset
@L2:
    Dec   ECX
    Jnz   @L1
@Done:
    Pop   EBX             //restore the world
    Pop   EDI
    Pop   ESI
  end;                    //and we're done


procedure CryptBfr(const BfrPtr:Pointer;const Key:AnsiString;const BfrLen:Integer);
  {Same as Crypt() but using arbitrary buffer instead of string.}
asm
  Push  ESI             //Save the good stuff
  Push  EDI
  Push  EBX

  Mov   EDI,EAX         //Buffer address into EDI
  Or    EDI,EDI
  Jz    @Done
  Jecxz @Done           //Abort on null length
  Or    EDX,EDX         //null Key ?
  Jz    @Done           //yes, then abort
  Mov   ESI,EDX         //Key address into ESI
  Mov   EDX,[ESI-4]     //Key Length into EDX
  Dec   EDX             //make zero based
  Js    @Done           //abort if zero key length
  Mov   EBX,EDX         //use EBX for rotation offset
  Mov   AH,DL           //seed with key length
  Cld                   //make sure we go forward
@L1:
  Test  AH,8            //build stream char.
  Jnz   @L3
  Xor   AH,1
@L3:
  Not   AH
  Ror   AH,1
  Mov   AL,[ESI+EBX]    //Get next char. from Key
  Xor   AL,AH           //XOR key with stream to make pseudo-key
  Xor   AL,[EDI]        //XOR pseudo-key with Source
  Stosb                 //store it back
  Dec   EBX             //less than zero ?
  Jns   @L2             //no, then skip
  Mov   EBX,EDX         //re-initialize Key offset
@L2:
  Dec   ECX
  Jnz   @L1
@Done:
  Pop   EBX             //restore the world
  Pop   EDI
  Pop   ESI
end;


function Hash(const Source:AnsiString):Integer;

  {Generate an integer hash key for the input string.

   Returns:  32 bit integer hash key (may be pos. or neg.)
             0 (zero) if null string

   NOTE: This is a highly efficient, verified, general purpose hashing
   algorithm based upon the published research of Peter J. Weinberger of
   AT&T Bell Labs and others.  This implementation has been used for
   years in UNIX object files and is about as good as it gets for
   general use.}

  asm
    Push  ESI             //Save the good stuff
    Push  EBX

    Xor   EDX,EDX         //Default return
    Or    EAX,EAX
    Jz    @Done
    Mov   EBX,EDX
    Mov   ECX,[EAX-4]     //String Length into ECX
    Jecxz @Done           //Abort on null string
    Mov   ESI,EAX         //Address into ESI
    Cld                   //make sure we go forward
@Next:
    Xor   EAX,EAX         //clear EAX
    Lodsb                 //get next byte
    Shl   EDX,4           //shift accumulator left by 4
    Add   EDX,EAX         //accumulate new byte
    Mov   EBX,EDX         //make temp test value
    And   EBX,$F000000    //EBX = EDX AND $F000000
    Jz    @L1             //jump if zero
    Shr   EBX,24
    Xor   EDX,EBX         //EDX = EDX XOR (EBX>>24)
@L1:
    Not   EBX
    And   EDX,EBX         //EDX = EDX AND (NOT EBX)
    Dec   ECX
    Jnz   @Next

@Done:
    Mov   EAX,EDX         //return 4 bytes into EAX

    Pop   EBX             //restore
    Pop   ESI

  end;


function ScanF(const Source,Search:AnsiString;Start:Integer):Integer;

  {Forward scan from specified Start looking for Search key.  Search may
   contain any number of '?' wildcards to match any character.
   Supports case insensitive using negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero search ?
    Jz    @NotFound
    Jecxz @NotFound        //zero start ?

    Mov   ESI,EAX          //source address
    Mov   EBP,ESI          //save it in EBP
    Mov   EDI,EDX          //search address

    Mov   EDX,ECX
    Or    ECX,ECX          //case sensitive ?
    Jns   @L0              //yes, then skip
    Neg   ECX              //absolute value of ECX
@L0:
    Dec   ECX              //zero based start position
    Mov   EAX,[ESI-4]      //source length
    Or    EAX,EAX
    Jz    @NotFound        //abort on null string
    Sub   EAX,ECX          //consider only remaining of source
    Jbe   @NotFound        //abort if source is too short
    Add   ESI,ECX          //start at the given offset

    Mov   ECX,[EDI-4]      //search length
    Jecxz @NotFound        //abort on null string
    Sub   EAX,ECX          //no need to examine any trailing
    Jb    @NotFound        //abort if source is too short
    Inc   EAX

//    XChg  EAX,ECX
    Mov   EBX,EAX
    Mov   EAX,ECX
    Mov   ECX,EBX

    Push  EBP              //save start offset on stack
    Push  EAX              //save end of search pointer
    Xor   EAX,EAX
    Lea   EBP,RevCase
    Mov   EBX,-1           //use EBX as temporary offset
@Next:
    Inc   EBX              //next offset
@Top:
    Cmp   EBX,[ESP]        //end of search ?
    Jz    @Found           //yes, we found it!

    Mov   AL,[EDI+EBX]     //get next search character

    Cmp   AL,63            //wildcard ?
    Jz    @Next            //yes, then check next char.

    Cmp   AL,[ESI+EBX]     //match ?
    Jz    @Next            //yes, then check next char.

    Bt    EDX,31           //test our case flag bit
    Jnc   @L1

    Mov   AL,[EBP+EAX]     //reverse case
    Cmp   AL,[ESI+EBX]     //check it again ?
    Jz    @Next            //yes, then check next char.
@L1:
    Inc   ESI              //no, then move to next character in source
    Xor   EBX,EBX          //zero offset
    Dec   ECX
    Jnz   @Top

    Pop   EAX
    Pop   EAX
@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Pop   EAX
    Pop   EAX
    Sub   ESI,EAX          //calc offset
    Mov   EAX,ESI
    Inc   EAX

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX

end;



function ScanD(const Source,Search:AnsiString;Start:Integer):Integer;

  {Forward scan from specified Start looking for next location where Source differs
   from Search.  Search may contain any number of '?' wildcards to match any character.
   Supports case insensitive using negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm
    Push  EBX
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Mov   ESI,EAX          //source address
    Mov   EBX,ESI          //save source in EBX
    Or    EDX,EDX          //zero search ?
    Jz    @Found
    Mov   EDI,EDX          //search address

    Mov   EDX,ECX
    Or    ECX,ECX          //case sensitive ?
    Jns   @L0              //yes, then skip
    Neg   ECX              //absolute value of ECX
@L0:
    Dec   ECX              //zero based start position
    Js    @Notfound
    Add   ESI,ECX          //start at the given offset

    Mov   EAX,[EBX-4]      //source length
    Or    EAX,EAX
    Jz    @NotFound        //abort on null string
    Sub   EAX,ECX          //consider only remaining of source
    Jbe   @NotFound        //bad start

    Mov   ECX,[EDI-4]      //search length
    Jecxz @Found           //abort on null string

    Btc   EDX,0
    Cmp   ECX,EAX
    Jb    @Skip
    Mov   ECX,EAX
    Btr   EDX,0
@Skip:
    Xor   EAX,EAX
    Lea   EBP,RevCase
@Top:
    Mov   AL,[EDI]         //get next search character

    Cmp   AL,63            //wildcard ?
    Jz    @Next            //yes, then check next char.

    Cmp   AL,[ESI]         //match ?
    Jz    @Next            //yes, then check next char.

    Bt    EDX,31
    Jnc   @Found

    Mov   AL,[EBP+EAX]
    Cmp   AL,[ESI]         //check it again ?
    Jnz   @Found           //no, then found it
@Next:
    Inc   ESI
    Inc   EDI
    Dec   ECX
    Jnz   @Top

    Bt    EDX,0
    Jc    @Found

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Mov   EAX,ESI
    Sub   EAX,EBX
    Inc   EAX
@Exit:

    Pop   EBP
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;



function ScanFF(const Source,Search:AnsiString;Start:Integer):Integer;

  {Fast Forward scan from specified Start looking for Search key.
   Case insensitive and wildcards NOT supported.

   Returns:  position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero search ?
    Jz    @NotFound
    Jecxz @NotFound        //zero start ?

    Mov   EDI,EAX          //source address
    Mov   EBP,EAX          //save it in EBP
    Mov   ESI,EDX          //search address

    Dec   ECX              //zero based start position
    Mov   EDX,[EDI-4]      //source length
    Sub   EDX,ECX          //consider only remaining of source
    Jbe   @NotFound        //abort if source is too short
    Add   EDI,ECX          //start at the given offset

    Mov   ECX,[ESI-4]      //search length
    Jecxz @NotFound        //abort on null string

    Dec   ECX
    Sub   EDX,ECX          //no need to examine any trailing
    Jbe   @NotFound        //abort if source is too short

//    XChg  EDX,ECX
    Mov   EAX,EDX
    Mov   EDX,ECX
    Mov   ECX,EAX

    Mov   AL,[ESI]
    Inc   ESI
    Cld
@Next:
    repnz scasb
    Jnz   @NotFound

    Mov   EBX,EDX          //use EBX as temporary offset
@NextOne:
    Dec   EBX              //next offset
    Js    @Found           //done if zero
    Mov   AH,[EDI+EBX]     //next character from source
    Cmp   AH,[ESI+EBX]     //match ?
    Jz    @NextOne         //yes, then check next char.
    Jmp   @Next            //try again

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Sub   EDI,EBP          //calc offset
    Mov   EAX,EDI

@Exit:

    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX

end;


function ScanSS(const Source,Search:AnsiString;const Start,Stop:Integer):Integer;

  {Partial scan of Source from specified Start to specified Stop looking for Search.
   Search may contain any number of '?' wildcards to match any character.
   Supports case insensitive using negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm

    Mov   dwI,EAX         //get stop position
    Mov   EAX,Stop

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Mov   ESI,EAX
    Mov   EAX,dwI
    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero search ?
    Jz    @NotFound
    Jecxz @NotFound        //zero start ?

    Mov   EBP,EAX
    Mov   EAX,ESI
    Mov   ESI,EBP
//    XChg  ESI,EAX          //source address/stop
//    Mov   EBP,ESI          //save it in EBP

    Mov   EDI,EDX          //search address
    Mov   EDX,[ESI-4]      //source length
    Or    EAX,EAX
    Jnz   @Skip
    Mov   EAX,EDX          //use Source length if Stop = 0
@Skip:
    Cmp   EAX,EDX          //stop beyond end ?
    Ja    @NotFound        //yes, then abort
    Mov   EDX,EAX          //use Stop as new length

    Mov   EAX,ECX          //save for case test
    Or    ECX,ECX          //case sensitive ?
    Jns   @L0              //yes, then skip
    Neg   ECX              //absolute value of ECX
@L0:
    Dec   ECX              //zero based Start
    Js    @NotFound

    Sub   EDX,ECX          //consider only remaining of source
    Jbe   @NotFound        //abort if source is too short
    Add   ESI,ECX          //adjust offset to Start

    Mov   ECX,[EDI-4]      //search length
    Jecxz @NotFound        //abort on null string
    Sub   EDX,ECX          //no need to examine any trailing
    Jb    @NotFound        //abort if source is too short
    Inc   EDX

//    XChg  EDX,ECX
    Mov   EBX,EDX
    Mov   EDX,ECX
    Mov   ECX,EBX

    Xor   EBX,EBX          //use EBX as temporary offset
    Push  EBP              //save start offset on stack
    Push  EDX              //save end of search pointer
    Mov   EDX,EAX
    Lea   EBP,RevCase
    Xor   EAX,EAX
    Mov   EBX,-1           //use EBX as temporary offset
@Next:
    Inc   EBX
@Top:
    Cmp   EBX,[ESP]        //end of search ?
    Jz    @Found           //yes, we found it!

    Mov   AL,[EDI+EBX]     //get next search character

    Cmp   AL,63            //wildcard ?
    Jz    @Next            //yes, then check next char.

    Cmp   AL,[ESI+EBX]     //match ?
    Jz    @Next            //yes, then check next char.

    Bt    EDX,31
    Jnc   @L1

    Mov   AL,[EBP+EAX]     //reverse case
    Cmp   AL,[ESI+EBX]     //check it again ?
    Jz    @Next            //yes, then check next char.
@L1:
    Inc   ESI              //no, then move to next character in source
    Xor   EBX,EBX          //zero offset
    Dec   ECX
    Jnz   @Top

    Pop   EAX
    Pop   EAX
@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Pop   EAX
    Pop   EAX
    Sub   ESI,EAX          //calc offset
    Mov   EAX,ESI
    Inc   EAX

@Exit:

    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX

end;


function ScanSC(const Source,Search:AnsiString;const Start:Integer; const Stop:Char):Integer;

  {Partial scan of Source from specified Start to Stop character (or end of
   string) looking for Search. Search may contain any number of '?' wildcards
   to match any character. Supports case insensitive using negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm

    Mov   dwI,EAX
    Mov   AL,Stop
    Mov   bI,AL
    Mov   EAX,dwI

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero search ?
    Jz    @NotFound
    Jecxz @NotFound        //zero start ?

    Mov   ESI,EAX          //source address
    Mov   EBP,EAX          //save it in EBP
    Mov   EDI,EDX          //search address

    Mov   EDX,ECX
    Or    ECX,ECX          //case sensitive ?
    Jns   @L0              //yes, then skip
    Neg   ECX              //absolute value of ECX
@L0:
    Dec   ECX              //zero based start position
    Js    @NotFound
    Mov   EAX,[ESI-4]      //source length
    Or    EAX,EAX
    Jz    @NotFound        //abort on null string
    Sub   EAX,ECX          //consider only remaining of source
    Jbe   @NotFound        //abort if source is too short
    Add   ESI,ECX          //start at the given offset

    Mov   ECX,[EDI-4]      //search length
    Jecxz @NotFound        //abort on null string
    Sub   EAX,ECX          //no need to examine any trailing
    Jb    @NotFound        //abort if source is too short
    Inc   EAX

//    XChg  EAX,ECX
    Mov   EBX,EAX
    Mov   EAX,ECX
    Mov   ECX,EBX

    Push  EBP              //save start offset on stack
    Push  EAX
    Lea   EBP,RevCase
    Xor   EAX,EAX
    Mov   EBX,-1           //use EBX as temporary offset
@Next:
    Inc   EBX
@Top:
    Cmp   EBX,[ESP]        //end of search ?
    Jz    @Found           //yes, we found it!

    Mov   AL,[ESI+EBX]     //get next character from source
    Cmp   AL,bI            //stop character
    Jz    @Done            //yes, then done

    Cmp   byte ptr [EDI+EBX],63            //wildcard ?
    Jz    @Next            //yes, then check next char.

    Cmp   AL,[EDI+EBX]     //match ?
    Jz    @Next            //yes, then check next char.

    Bt    EDX,31
    Jnc   @L1

    Mov   AL,[EBP+EAX]     //reverse case
    Cmp   AL,[EDI+EBX]     //check it again ?
    Jz    @Next            //yes, then check next char.
@L1:
    Inc   ESI              //no, then move to next character in source
    Xor   EBX,EBX          //zero offset
    Dec   ECX
    Jnz   @Top

@Done:
    Pop   EAX
    Pop   EAX
@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Pop   EAX
    Pop   EAX
    Sub   ESI,EAX          //calc offset
    Mov   EAX,ESI
    Inc   EAX

@Exit:

    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX

end;


function ScanR(const Source,Search:AnsiString;Start:integer):integer;

  {Reverse scan from specified Start (0 = End) looking for Search key.
   Search may contain any number of '?' wildcards to match any char..
   Supports case insensitive using negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP              //and the original source address

    Or    EAX,EAX
    Jz    @NotFound
    Or    EDX,EDX
    Jz    @NotFound
    Mov   ESI,EAX          //source address
    Mov   EBP,EAX          //save it in EBP
    Mov   EDI,EDX          //search address
    Mov   EDX,[ESI-4]      //source length
    Or    EDX,EDX
    Jz    @NotFound

    Mov   EAX,ECX          //save for case flag
    Or    ECX,ECX          //case insensitive ?
    Jns   @L0              //no, then skip
    Neg   ECX              //absolute value of start
@L0:
    Jnz   @L1              //skip if non-zero ?
    Mov   ECX,EDX          //start at end
@L1:
    Cmp   ECX,EDX          //start beyond end?
    Jbe   @L2              //no, then OK
    Mov   ECX,EDX          //yes, then start at end
@L2:
    Mov   EDX,[EDI-4]      //search length
    Or    EDX,EDX          //zero search?
    Jz    @NotFound        //yes, then Abort
    Sub   ECX,EDX          //no need to examine any trailing
    Jb    @NotFound        //abort if source is too short
    Add   ESI,ECX          //start at the given offset
    Inc   ECX
    Push  EBP              //save start offset on stack
    Push  EDX              //save end of search pointer
    Mov   EDX,EAX
    Lea   EBP,RevCase
    Xor   EAX,EAX
    Mov   EBX,-1           //use EBX as temporary offset
@Next:
    Inc   EBX
@Top:
    Cmp   EBX,[ESP]        //end of search ?
    Jz    @Found           //yes, we found it!

    Mov   AL,[EDI+EBX]     //get next character from search

    Cmp   AL,63            //wildcard ?
    Jz    @Next            //yes, then check next char.

    Cmp   AL,[ESI+EBX]     //match ?
    Jz    @Next            //yes, then check next char.

    Bt    EDX,31
    Jnc   @L3

    Mov   AL,[EBP+EAX]     //reverse case
    Cmp   AL,[ESI+EBX]     //check it again ?
    Jz    @Next            //yes, then check next char.
@L3:
    Dec   ESI              //no, then move to next character in source
    Xor   EBX,EBX          //zero offset
    Dec   ECX
    Jnz   @Top

    Pop   EAX
    Pop   EAX
@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit
@Found:
    Pop   EAX
    Pop   EAX
    Sub   ESI,EAX          //calc offset
    Mov   EAX,ESI
    Inc   EAX
@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


function ScanRF(const Source,Search:AnsiString;Start:integer):integer;

  {Fast reverse scan from specified Start (0 = End) looking for Search key.
   No support for case or wildcards and therefore faster.

   Returns:  position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //no source?
    Jz    @NotFound
    Or    EDX,EDX          //no search?
    Jz    @NotFound
    Mov   ESI,EAX          //source address
    Mov   EBP,EAX          //save it in EBP
    Mov   EDI,EDX          //search address
    Mov   EDX,[ESI-4]      //source length
    Or    EDX,EDX          //zero length?
    Jz    @NotFound

    Or    ECX,ECX          //zero start?
    Jnz   @L1              //no, then skip
    Mov   ECX,EDX          //start at end
@L1:
    Cmp   ECX,EDX          //start beyond end?
    Jbe   @L2              //no, then skip
    Mov   ECX,EDX          //else, start at end
@L2:
    Mov   EDX,[EDI-4]      //search length
    Or    EDX,EDX          //zero search?
    Jz    @NotFound        //yes, then Abort
    Sub   ECX,EDX          //no need to examine any trailing
    Jb    @NotFound        //abort if source is too short
    Add   ESI,ECX          //start at the given offset
    Inc   ECX
    Xor   EAX,EAX
    Mov   EBX,-1           //use EBX as temporary offset
@Next:
    Inc   EBX
@Top:
    Cmp   EBX,EDX          //end of search ?
    Jz    @Found           //yes, we found it!

    Mov   AL,[EDI+EBX]     //get next character from search

    Cmp   AL,[ESI+EBX]     //match ?
    Jz    @Next            //yes, then check next char.

    Dec   ESI              //no, then move to next character in source
    Xor   EBX,EBX          //zero offset
    Dec   ECX
    Jnz   @Top

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit
@Found:
    Sub   ESI,EBP          //calc offset
    Mov   EAX,ESI
    Inc   EAX
@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;

function ScanC2(const Source,Search:AnsiString;Start:Integer):Integer;

  {Forward scan from Start looking for the double char. sequence given in Search.
   This is a specialized routine which will only search for a two character
   target string.

   Returns: Position where/if found; otherwise, 0}

  asm
    Push  ESI
    Push  EBX

    Or    EAX,EAX       //invalid pointer ?
    Jz    @Done
    Mov   ESI,EAX
    Or    EDX,EDX
    Jz    @NG
    Mov   EAX,[EDX-4]
    Cmp   EAX,2         //only a 2 char string allowed
    Jnz   @NG

    Mov   EAX,EDX
    Mov   EBX,[ESI-4]   //string length
    Cmp   ECX,EBX       //start beyond end ?
    Ja    @NG           //yes, then abort
    Dec   ECX           //zero based start
    Js    @NG
    Mov   EDX,ESI       //save start offset
    Add   ESI,ECX       //start at specified location
    Sub   EBX,ECX       //consider only remaining of source
    Cmp   EBX,2         //need at least 2 char. for a match
    Jb    @NG
    Mov   ECX,EBX
    Mov   BX,[EAX]      //get the search sequence
    Xchg  BL,BH

    Cld
    Lodsb
    Mov   AH,AL
    Dec   ECX
@Top:
    Lodsb
    Cmp   AX,BX
    Jz    @OK
    Mov   AH,AL
    Dec   ECX
    Jnz   @Top
@NG:
    Xor   EAX,EAX
    Jmp   @Done

@OK:
    Mov   EAX,ESI
    Sub   EAX,EDX
    Dec   EAX
@Done:
    Pop   EBX
    Pop   ESI
  end;


//function ScanC(const Source:AnsiString;X:Char;Start:Integer):Integer;
//
//  {Forward scan from Start looking for next matching char. (X). This
//   and the complementary ScanB (backwards scan) are optimized routines
//   providing the fastest possible case sensitive scan for a single char..
//
//   Returns: Position where/if found; otherwise, 0}
//
//  asm
//    Push  EDI
//    Push  EBX
//
//    Or    EAX,EAX       //invalid pointer ?
//    Jz    @Done
//    Mov   EDI,EAX
//    Xor   EAX,EAX
//
//    Mov   EBX,[EDI-4]   //string length
//    Cmp   ECX,EBX       //start beyond end ?
//    Ja    @Done         //yes, then abort
//    Dec   ECX           //zero based start
//    Js    @Done
//    Mov   EAX,EDX       //get search character
//    Mov   EDX,EDI       //save start offset
//    Add   EDI,ECX
//    Sub   EBX,ECX
//    Mov   ECX,EBX
//
//    Cld
//
//    repnz scasb
//    Jz    @OK
//    Xor   EAX,EAX
//    Jmp   @Done
//
//@OK:
//    Mov   EAX,EDI
//    Sub   EAX,EDX
//
//@Done:
//    Pop   EBX
//    Pop   EDI
//  end;


function WScan(const Source,Search:WideString;Start:Integer):Integer;

  {Forward scan from specified Start looking for Search key.

   Returns:  WideChar position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero search ?
    Jz    @NotFound
    Jecxz @NotFound        //zero start ?

    Mov   EDI,EAX          //source address
    Mov   EBP,EAX          //save it in EBP
    Mov   ESI,EDX          //search address

    Dec   ECX              //zero based start position
    Mov   EDX,[EDI-4]      //Source length
    Shl   ECX,1            //Unicode start
    Sub   EDX,ECX          //consider only remaining of source
    Jbe   @NotFound        //abort if Source too short
    Add   EDI,ECX          //start offset

    Mov   ECX,[ESI-4]      //search length
    Jecxz @NotFound        //abort on null string

    Dec   ECX
    Sub   EDX,ECX          //no need to examine any trailing
    Jbe   @NotFound        //abort if source is too short

//    XChg  EDX,ECX          //EDX=Search length
    Mov   EAX,EDX
    Mov   EDX,ECX
    Mov   ECX,EAX

    Shr   ECX,1            //WideChar Count
    Inc   ECX
    Dec   EDX
    Inc   ESI              //Adjust to match EDI
    Inc   ESI
    Cld                    //make sure we go forward
@Next:
    Mov   AX,[ESI-2]
@Top:
    repnz scasw
    Jnz   @NotFound

    Mov   EBX,EDX          //use EBX as temporary offset
@NextOne:
    Sub   EBX,2            //next offset
    Js    @Found           //done if zero
    Mov   AX,[EDI+EBX]     //next character from source
    Cmp   AX,[ESI+EBX]     //match ?
    Jz    @NextOne         //yes, then check next char.
    Jmp   @Next            //try again

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit            //done

@Found:
    Mov   EAX,EDI
    Sub   EAX,EBP          //calc offset
    Shr   EAX,1

@Exit:

    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX

end;



function WScanC(const Source:WideString;X:WideChar;Start:Integer):Integer;

  {Forward scan from Start looking for next matching char. (X).

   Returns: WideChar position where/if found; otherwise, 0}

  asm
    Push  ESI
    Push  EBX

    Or    EAX,EAX       //invalid pointer ?
    Jz    @Done
    Mov   ESI,EAX

    Mov   EAX,[ESI-4]   //string length
    Mov   EBX,EDX       //get search character
    And   EBX,$FFFF
    Mov   EDX,ESI       //save start offset
    Dec   ECX           //zero based start
    Js    @Done
    Shl   ECX,1
    Cmp   ECX,EAX       //start beyond end ?
    Ja    @Done         //yes, then abort
    Add   ESI,ECX
    Sub   EAX,ECX
    Mov   ECX,EAX
    Shr   ECX,1
    Xor   EAX,EAX

    Cld
@Top:
    lodsw
    Cmp   EAX,EBX
    Jz    @OK
    Dec   ECX
    Jnz   @Top

    Xor   EAX,EAX
    Jmp   @Done

@OK:
    Mov   EAX,ESI
    Sub   EAX,EDX
    Shr   EAX,1
@Done:
    Pop   EBX
    Pop   ESI
  end;


function WScanRC(const Source:WideString;X:WideChar;Start:Integer):Integer;

  {Reverse scan from Start looking for next matching char. (X).

   Returns: WideChar position where/if found; otherwise, 0}

  asm
    Push  ESI
    Push  EBX

    Or    EAX,EAX       //invalid pointer ?
    Jz    @Done
    Mov   ESI,EAX

    Mov   EAX,[ESI-4]   //string length
    Mov   EBX,EDX       //get search character
    And   EBX,$FFFF
    Mov   EDX,ESI       //save start offset
    Jecxz @Reset        //zero start
    Shl   ECX,1
    Cmp   ECX,EAX       //start beyond end ?
    Jbe   @Go
@ReSet:
    Mov   ECX,EAX
@Go:
    Add   ESI,ECX
    Shr   ECX,1
    Xor   EAX,EAX

@Top:
    Dec   ESI
    Dec   ESI
    Mov   AX,[ESI]
    Cmp   EAX,EBX
    Jz    @OK
    Dec   ECX
    Jnz   @Top

    Xor   EAX,EAX
    Jmp   @Done

@OK:
    Mov   EAX,ESI
    Sub   EAX,EDX
    Shr   EAX,1
    Inc   EAX
@Done:
    Pop   EBX
    Pop   ESI
  end;



function ScanC(const Source:AnsiString;X:Char;Start:Integer):Integer;

  {Forward scan from Start looking for next matching char. (X). This
   and the complementary ScanB (backwards scan) are optimized routines
   providing the fastest possible case sensitive scan for a single char..

   Returns: Position where/if found; otherwise, 0}

  asm
    Push  EDI
    Push  ESI
    Push  EBX
    Push  EBP

    Or    EAX,EAX       //invalid pointer ?
    Jz    @Done
    Mov   EDI,EAX
    Xor   EAX,EAX

    Mov   EBP,[EDI-4]   //string length
    Cmp   ECX,EBP       //start beyond end ?
    Ja    @Done         //yes, then abort
    Dec   ECX           //zero based start
    Js    @Done
    Mov   EAX,EDX       //get search character
    Mov   ESI,EDI       //save start offset
    Add   EDI,ECX
    Sub   EBP,ECX

    Cld
    Mov   ECX,EBP
    Shr   ECX,2         //calc dwords
    Jz    @Skip

    Mov   AH,AL         //use EBX as mask register
    Mov   BX,AX
    Shl   EBX,16
    Mov   BX,AX
@Top:
    Mov   EAX,[EDI]
    Add   EDI,4
    Xor   EAX,EBX                   //apply mask

    Lea   EDX,[EAX-$01010101]       //subtract 1 from each byte
    Not   EAX                       //invert all bytes
    And   EDX,EAX                   //and these two
    And   EDX,$80808080             //test all sign bits
    Jnz   @GotIt                    //sign bit = match

    Dec   ECX                       //do it again
    Jnz   @Top

    Mov   AL,BL                     //get our search character
@Skip:
    And   EBP,3
    Jz    @Bail
    Mov   ECX,EBP
    repnz scasb                     //scan odd bytes
    Jz    @OK
@Bail:
    Xor   EAX,EAX
    Jmp   @Done
@GotIt:
    Test  EDX,$8080                 //test first two bytes
    Jz    @L1
    Sub   EDI,2
    Shl   EDX,16
@L1:
    Shl   EDX,9
@OK:
    Sbb   EDI,ESI
    Mov   EAX,EDI

@Done:
    Pop   EBP
    Pop   EBX
    Pop   ESI
    Pop   EDI
  end;


function ScanLU(const Source:AnsiString;Lower,Upper:Char;Start:Integer):Integer;

  {Forward scan from Start looking for next char. within the range of Lower to
   Upper.

   Returns: Position where/if found; otherwise, 0}

  asm
    Mov   dwI,EAX
    Mov   EAX,Start

    Push  ESI
    Push  EBX

    Mov   EBX,EAX
    Mov   EAX,dwI

    Or    EAX,EAX
    Jz    @Done
    Mov   ESI,EAX
    Xor   EAX,EAX

    Mov   DH,CL
    Mov   ECX,[ESI-4]   //string length
    Cmp   EBX,ECX       //start beyond end ?
    Ja    @Done         //yes, then abort
    Dec   EBX           //zero based start
    Js    @Done
    Sub   ECX,EBX

//    Xchg  ESI,EBX
    Mov   EAX,ESI
    Mov   ESI,EBX
    Mov   EBX,EAX

    Add   ESI,EBX

    Cld
    Cmp   DL,DH
    Jb    @Top
    Xchg  DL,DH
@Top:
    Lodsb
    Cmp   AL,DL
    Jb    @Next
    Cmp   AL,DH
    Ja    @Next
    Jmp   @OK
@Next:
    Dec   ECX
    Jnz   @Top


    Xor   EAX,EAX
    Jmp   @Done

@OK:
    Mov   EAX,ESI
    Sub   EAX,EBX

@Done:
    Pop   EBX
    Pop   ESI
  end;


function IsLChar(C:Char):Boolean;
  {Test if C is lower case per case table}
asm
  Lea   ECX,LowT
  Mov   EDX,EAX
  And   EDX,7           //bit index
  And   EAX,255
  Shr   EAX,3           //byte index
  Mov   AL,[ECX+EAX]    //get byte
  Bt    EAX,EDX         //test the bit
  Jc    @OK             //good one
  Xor   EAX,EAX         //no good, return false
  Jmp   @Done
@OK:
  Mov   EAX,True
@Done:
end;


function IsUChar(C:Char):Boolean;
  {Test if C is upper case per case table}
asm
  Lea   ECX,UprT
  Mov   EDX,EAX
  And   EDX,7           //bit index
  And   EAX,255
  Shr   EAX,3           //byte index
  Mov   AL,[ECX+EAX]    //get byte
  Bt    EAX,EDX         //test the bit
  Jc    @OK
  Xor   EAX,EAX
  Jmp   @Done
@OK:
  Mov   EAX,True
@Done:
end;


function IsCChar(C1,C2:Char):Boolean;
  {Test if C1 and C2 are equivalent ignoring case}
begin
  Result := (C1=C2) OR (C1=RevCase[Ord(C2)]);
end;


function ScanL(const Source:AnsiString;Start:Integer):Integer;
  {Forward scan from Start looking for next lower case char., ASCII 97..122.

   Returns: Position where/if found; otherwise, 0}

  asm
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Dec   EDX              //zero start ?
    Js    @NotFound

    Mov   ESI,EAX          //Source in ESI
    Mov   EBP,ESI          //save in EBP

    Mov   ECX,[ESI-4]      //source length
    Add   ESI,EDX
    Sub   ECX,EDX          //adjust for start
    Js    @NotFound        //abort if too short
    Lea   EDI,LowT
    Xor   EAX,EAX
    Cld                    //insure we go forward

@Next:
    Lodsb                  //get the byte

    Mov   EDX,EAX
    And   EDX,7           //bit index
    Shr   EAX,3           //byte index
    Mov   AL,[EDI+EAX]    //get byte
    Bt    EAX,EDX         //test the bit
    Jc    @Found

    Dec   ECX
    Jnz   @Next

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Mov   EAX,ESI
    Sub   EAX,EBP          //calc offset

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
  end;


function ScanU(const Source:AnsiString;Start:Integer):Integer;

  {Forward scan from Start looking for next upper case char., ASCII 65..90.

   Returns: Position where/if found; otherwise, 0}

  asm
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Dec   EDX              //zero start ?
    Js    @NotFound

    Mov   ESI,EAX          //Source in ESI
    Mov   EBP,ESI          //save in EBP

    Mov   ECX,[ESI-4]      //source length
    Add   ESI,EDX
    Sub   ECX,EDX          //adjust for start
    Js    @NotFound        //abort if too short
    Lea   EDI,UprT
    Xor   EAX,EAX
    Cld                    //insure we go forward

@Next:
    Lodsb                  //get the byte

    Mov   EDX,EAX
    And   EDX,7           //bit index
    Shr   EAX,3           //byte index
    Mov   AL,[EDI+EAX]    //get byte
    Bt    EAX,EDX         //test the bit
    Jc    @Found

    Dec   ECX
    Jnz   @Next

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Mov   EAX,ESI
    Sub   EAX,EBP          //calc offset

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
  end;


function ScanN(const Source:AnsiString;Start:Integer):Integer;

  {Forward scan from Start looking for next numeric character, ASCII 48..57.

   Returns: Position where/if found; otherwise, 0}
begin
  Result:=ScanLU(Source,#48,#57,Start);
end;


function ScanOR(const Source,Search:AnsiString;Start:Integer):Integer;
  {Forward scan from Start looking for the next match of any token
   in Search.  Up to 16 different tokens can be specified using '|' (ASCII 124)
   as a kind of logical OR operator.  For case insensitive use neagtive Start.

   Example: ScanOR(S,'who|what|when',I); }

var
  C:Char;
  I,J,K,N,CaseFlg:Integer;
  Word,Table:AnsiString;
  List: array[1..16] of AnsiString;
begin
  Result:=0;
  if (Length(Source)=0) OR (Length(Search)=0) then Exit;
  N:=0;
  I:=1;
  Table:=DupChr(#32,16);
  Word:=ParseWord(Search,'|',I);
  while (Length(Word)>0) and (N<16) do begin
    Inc(N);
    Table[N]:=Word[1];
    List[N]:=Word;
    Word:=ParseWord(Search,'|',I);
  end;
  if N=0 then Exit;
  SetLength(Table,N);
  CaseFlg:=Sign(Start);
  I:=ScanT(Source,Table,Start);
  while I>0 do begin
    C:=Source[I];
    J:=ScanF(Table,C,CaseFlg);
    while J>0 do begin
      K:=ScanSS(Source,List[J],I*CaseFlg,I+Length(List[J])-1);
      if K>0 then begin
         Result:=I;
         Exit;
      end;
      J:=ScanF(Table,C,(J+1)*CaseFlg);
    end;
    I:=ScanT(Source,Table,(I+1)*CaseFlg);
  end;
end;


function ScanCC(const Source:AnsiString;X:Char;Count:Integer):Integer;

  {Forward scan from start looking for Count occurance of char. X.

   Returns: Position where/if found; otherwise, 0}

  asm
    Push  EDI
    Push  EBX

    Or    EAX,EAX
    Jz    @Done
    Mov   EDI,EAX
    Xor   EAX,EAX
    Mov   EBX,ECX
    Or    EBX,EBX
    Jz    @NG
    Mov   ECX,[EDI-4]
    Jecxz @Done

    Mov   EAX,EDX
    Mov   EDX,EDI

    Cld
@L1:
    repnz scasb
    Jnz   @NG
    Dec   EBX
    Jz    @OK
    Jecxz @NG
    Jmp   @L1

@NG:
    Xor   EAX,EAX
    Jmp   @Done

@OK:
    Mov   EAX,EDI
    Sub   EAX,EDX

@Done:
    Pop   EBX
    Pop   EDI
  end;


function ScanB(const Source:AnsiString;X:Char;Start:Integer):Integer;

  {Backward/reverse scan from Start location (0 = End) looking for single
   character, X.

   Returns: Position where/if found; otherwise, 0}

  asm
    Push  EDI
    Push  ESI
    Push  EBX

    Or    EAX,EAX          //bad pointer ?
    Jz    @Done
    Mov   EDI,EAX
    Xor   EAX,EAX
    Mov   EBX,[EDI-4]
    Jecxz @L0
    Cmp   ECX,EBX
    Jb    @L1
@L0:
    Mov   ECX,EBX          //use full length if 0 start
@L1:
    Mov   EAX,EDX          //search char. in AL
    Mov   ESI,EDI
    Add   EDI,ECX
    Mov   EDX,EDI
    Dec   EDI
    Mov   EBX,ECX
    And   ECX,3
    Jz    @Skip

    Std
    repnz scasb         //scan odd bytes first
    Jnz   @Skip
    Add   EDI,2
    Jmp   @OK
@Skip:
    Inc   EDI
    Mov   ECX,EBX
    Shr   ECX,2
    Jz    @Bail

    Mov   AH,AL         //use EBX as mask register
    Mov   BX,AX
    Shl   EBX,16
    Mov   BX,AX

@Top:
    Sub   EDI,4
    Mov   EAX,[EDI]
    Xor   EAX,EBX

    Lea   EDX,[EAX-$01010101]       //subtract 1 from each byte
    Not   EAX                       //invert all bytes
    And   EDX,EAX                   //and these two
    And   EDX,$80808080             //test all sign bits
    Jnz   @GotIt

    Dec   ECX
    Jnz   @Top
@Bail:
    Xor   EAX,EAX
    Jmp   @Done
@GotIt:
    Add   EDI,2
    Test  EDX,$80800000            //test first two bytes
    Jz    @L2
    Add   EDI,2
    Shr   EDX,16
@L2:
    Not   EDX
    Shr   EDX,16
@OK:
    Sbb   EDI,ESI
    Mov   EAX,EDI
@Done:
    Cld
    Pop   EBX
    Pop   ESI
    Pop   EDI

  end;


function ScanB2(const Source,Search:AnsiString;Start:Integer):Integer;

  {Backward/reverse scan from Start location (0 = End) looking for double
   character Search string.

   Returns: Position where/if found; otherwise, 0}

  asm
    Push  ESI
    Push  EBX

    Or    EAX,EAX          //bad pointer ?
    Jz    @Done
    Or    EDX,EDX
    Jz    @NG
    Mov   ESI,EAX
    Mov   EBX,[ESI-4]
    Jecxz @L0
    Cmp   ECX,EBX
    Jb    @L1
@L0:
    Mov   ECX,EBX          //use full length if 0 start
@L1:
    Cmp   ECX,2
    Jb    @NG
    Mov   EBX,[EDX-4]
    Cmp   EBX,2
    Jnz   @NG
    Mov   BX,[EDX]
    Dec   ESI
    Mov   EDX,ESI
    Add   ESI,ECX

    Std
    Lodsb
    Mov   AH,AL
    Dec   ECX
@Top:
    Lodsb
    Cmp   AX,BX
    Jz    @OK
    Mov   AH,AL
    Dec   ECX
    Jnz   @Top
@NG:
    Xor   EAX,EAX
    Jmp   @Done
@OK:
    Mov   EAX,ESI         //calc offset to return
    Sub   EAX,EDX
    Inc   EAX
@Done:
    Cld
    Pop   EBX
    Pop   ESI

  end;



//function ScanB(const Source:AnsiString;X:Char;Start:Integer):Integer;
//
//  {Backward/reverse scan from Start location (0 = End) looking for single
//   character, X.
//
//   Returns: Position where/if found; otherwise, 0}
//
//  asm
//    Push  EDI
//    Push  EBX
//
//    Or    EAX,EAX          //bad pointer ?
//    Jz    @Done
//    Mov   EDI,EAX
//    Xor   EAX,EAX
//    Mov   EBX,[EDI-4]
//    Jecxz @L0
//    Cmp   ECX,EBX
//    Jb    @L1
//@L0:
//    Mov   ECX,EBX          //use full length if 0 start
//@L1:
//    Mov   EAX,EDX
//   Dec   EDI
//    Mov   EDX,EDI
//    Add   EDI,ECX
//
//    Std
//    repnz scasb
//    Cld
//    Jz    @OK
//    Xor   EAX,EAX
//    Jmp   @Done
//@OK:
//    Mov   EAX,EDI         //calc offset to return
//    Sub   EAX,EDX
//    Inc   EAX
//@Done:
//    Pop   EBX
//    Pop   EDI
//
//  end;

//function ScanB(const Source:AnsiString;X:Char;Start:Integer):Integer;
//
//  {Backward/reverse scan from Start location (0 = End) looking for single
//   character, X.
//
//   Returns: Position where/if found; otherwise, 0}
//
//  asm
//    Push  EDI
//    Push  EBX
//
//    Or    EAX,EAX          //bad pointer ?
//    Jz    @Done
//    Mov   EDI,EAX
//    Xor   EAX,EAX
//    Mov   EBX,[EDI-4]
//    Jecxz @L0
//    Cmp   ECX,EBX
//    Jb    @L1
//@L0:
//    Mov   ECX,EBX          //use full length if 0 start
//@L1:
//    Mov   EAX,EDX
//   Dec   EDI
//    Mov   EDX,EDI
//    Add   EDI,ECX
//
//    Std
//    repnz scasb
//    Cld
//    Jz    @OK
//    Xor   EAX,EAX
//    Jmp   @Done
//@OK:
//    Mov   EAX,EDI         //calc offset to return
//    Sub   EAX,EDX
//    Inc   EAX
//@Done:
//    Pop   EBX
//    Pop   EDI
//
//  end;


function ScanNC(const Source:AnsiString;X:Char):Integer;

  {Forward scan looking for first char. NOT matching X.

   Returns: Position where/if found; otherwise, O}

  asm
    Push  EDI

    Or    EAX,EAX
    Jz    @Done
    Mov   EDI,EAX
    Mov   ECX,[EAX-4]
    Xor   EAX,EAX
    Jecxz @Done

    Mov   EAX,EDX          //Get target character
    Mov   EDX,EDI          //save start address

    Cld
    repz  scasb
    Jnz   @OK
    Xor   EAX,EAX
    Jmp   @Done
@OK:
    Mov   EAX,EDI          //current address
    Sub   EAX,EDX          //offset = current-start
@Done:
    Pop   EDI
  end;


function ScanNB(const Source:AnsiString;X:Char):Integer;

  {Backward/Reverse scan looking for first NON-matching character.

   Returns: Position where/if found; otherwise, O}

  asm
    Push  EDI

    Or    EAX,EAX
    Jz    @Done
    Mov   EDI,EAX
    Mov   ECX,[EAX-4]
    Xor   EAX,EAX
    Jecxz @Done
    Mov   EAX,EDX
    Dec   EDI
    Mov   EDX,EDI
    Add   EDI,ECX

    Std
    repz  scasb
    Cld
    Jnz   @OK
    Xor   EAX,EAX
    Jmp   @Done
@OK:
    Mov   EAX,EDI
    Sub   EAX,EDX
    Inc   EAX
@Done:
    Pop   EDI
  end;




function ScanT(const Source,Table:AnsiString;Start:Integer):Integer;

  {Forward scan from Start looking for any Table char..
   Supports case insensitive using negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Call  _TableScanIni    //do initialization
    Jecxz @NotFound        //abort on error
    Sub   ECX,EAX          //adjust length
    Xor   EAX,EAX
@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in EDX
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bt    EBX,EDX
//*    Bt    EBX,DL           //test the bit
    Jc    @Found

    Dec   ECX
    Jnz   @Next

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Mov   EAX,ESI
    Sub   EAX,EBP          //calc offset

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


function ScanTQ(const Source,Table:AnsiString;Start:Integer):Integer;

  {Forward scan from Start looking for any Table char. NOT inside quotes.
   Quote charactera must not be used in Table.  Supports
   case insensitive scan using negative Start.

   Returns:  Position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Call  _TableScanIni    //do initialization
    Jecxz @NotFound        //abort on error
    Sub   ECX,EAX          //adjust length
    Xor   EAX,EAX
    Xor   EDX,EDX

@Next:
    Lodsb                  //get the byte
    Cmp   AL,QS
    Jnz   @Skip1
    Xor   EDX,$40000000    //set flag
    Jmp   @Skip2
@Skip1:
    Cmp   AL,QE
    Jnz   @Skip2
    Test  EDX,$40000000
    Jz    @Skip2
    Xor   EDX,$40000000    //set flag
//    Cmp   AL,34            //dbl quote ?
//    Jnz   @Skip2           //no, then skip
//    Xor   EDX,$40000000    //set flag
//    Jmp   @Skip2
//@Skip1:
//    Cmp   AL,39            //single quote ?
//    Jnz   @Skip2           //no, then skip
//    Xor   EDX,$20000000    //set flag
@Skip2:
    Test  EDX,$60000000    //quotes clear ?
    Jz    @Table           //yes, then check table
    Dec   ECX
    Jnz   @Next
    Jmp   @NotFound
@Table:
    Mov   DL,AL            //save it in EDX
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bt    EBX,EDX
//*    Bt    EBX,DL           //test the bit
    Jc    @Found

    Dec   ECX
    Jnz   @Next

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Mov   EAX,ESI
    Sub   EAX,EBP          //calc offset

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


function ScanRT(const Source,Table:AnsiString;Start:Integer):Integer;

  {Reverse scan from Start looking for any Table char..
   Supports case insensitive using negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Call  _TableScanIni    //do initialization
    Jecxz @NotFound        //abort on error
    Mov   ECX,EAX
    Inc   ECX
    Xor   EAX,EAX
    Std
@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in EDX
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bt    EBX,EDX
//*    Bt    EBX,DL           //test the bit
    Jc    @Found

    Dec   ECX
    Jnz   @Next

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Mov   EAX,ESI
    Inc   EAX
    Inc   EAX
    Sub   EAX,EBP          //calc offset

@Exit:
    Cld
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


function ScanNT(const Source,Table:AnsiString;Start:Integer):Integer;

  {Forward scan from Start looking for first char. NOT in table.
   Supports case insensitive via negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Call  _TableScanIni    //do initialization
    Jecxz @NotFound        //abort on error
    Sub   ECX,EAX          //adjust length
    Xor   EAX,EAX
@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in EDX
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bt    EBX,EDX
//*    Bt    EBX,DL           //test the bit
    Jnc   @Found

    Dec   ECX
    Jnz   @Next

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Mov   EAX,ESI
    Sub   EAX,EBP          //calc offset

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


function ScanRNT(const Source,Table:AnsiString;Start:Integer):Integer;

  {Reverse scan from Start looking for first char. NOT in table.
   Supports case insensitive via negative Start.

   Returns:  position where/if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Call  _TableScanIni    //do initialization
    Jecxz @NotFound        //abort on error
    Mov   ECX,EAX
    Inc   ECX
    Xor   EAX,EAX
    Std
@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in EDX
    And   DL,31           //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bt    EBX,EDX
//*    Bt    EBX,DL           //test the bit
    Jnc   @Found

    Dec   ECX
    Jnz   @Next

@NotFound:
    Xor   EAX,EAX          //clear return
    Jmp   @Exit

@Found:
    Mov   EAX,ESI
    Inc   EAX
    Inc   EAX
    Sub   EAX,EBP          //calc offset

@Exit:
    Cld
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


function ScanP(const Source,Search:AnsiString;var Start:integer):Integer;

  {Forward scan from Start looking for longest partial match of Search.
   Search may contain '?' wildcards to match any character.
   Does not support case insensitive scan.

   Returns:  Matching length.  Start = Match location.  To continue
             a search, manually adjust Start beyond the returned match.
             If a perfect match is found, resultant = Length(Search).
             If no partial match, 0 is returned and Start = 0.}

begin
  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero search ?
    Jz    @NotFound
    Jecxz @NotFound        //zero start ?
    Mov   ECX,[ECX]

    Mov   ESI,EAX          //source address
    Mov   EBP,EAX          //save it in EBP
    Mov   EDI,EDX          //search address

    Dec   ECX              //zero based start position
    Js    @NotFound        //abort if less than zero

    Mov   EDX,[ESI-4]      //source length
    Or    EDX,EDX
    Jz    @NotFound        //abort on null string
    Sub   EDX,ECX          //consider only remaining of source
    Jbe   @NotFound        //abort if source is too short
    Add   ESI,ECX          //start at the given offset

    Mov   ECX,[EDI-4]      //search length
    Jecxz @NotFound        //abort on null string
//    XChg  EDX,ECX
    Mov   EBX,EDX
    Mov   EDX,ECX
    Mov   ECX,EBX

    Xor   EBX,EBX          //use EBX as temporary offset
    Mov   Total,EBX        //initialize global storage
    Mov   Score,EBX
@Next:
    Cmp   EBX,EDX          //end of search ?
    Jz    @Found           //yes, we found it!


    Mov   AL,[ESI+EBX]     //get next character from source
    Mov   AH,[EDI+EBX]     //get next character from search
    Inc   EBX              //next offset

    Cmp   EBX,ECX          //end of source
    Ja    @L2              //yes, time to go

    Cmp   AH,63            //wildcard ?
    Jz    @Next            //yes, then check next char.
    Cmp   AL,AH            //match ?
    Jz    @Next            //yes, then check next char.
@L2:
    Dec   EBX              //any characters match ?
    Jz    @L1              //no, then skip
    Cmp   EBX,Score        //greater than current ?
    Jbe   @L1              //no, then skip
    Mov   Score,EBX        //save new match length
    Mov   Total,ESI        //save new location
@L1:
    Xor   EBX,EBX          //zero offset
    Inc   ESI              //no, then move to next character in source

    Dec   ECX
    Jnz   @Next

    Mov   EDX,Score
    Mov   ESI,Total
    Jmp   @Found

@NotFound:
    Xor   EAX,EAX          //clear return
    Mov   Score,EAX
    Mov   Total,EAX
    Jmp   @Exit

@Found:
    Mov   Score,EDX
    Sub   ESI,EBP          //calc offset
    Mov   EAX,ESI
    Inc   EAX
    Add   EAX,EDX
    Mov   Total,EAX
@Exit:

    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
  end;
  Start:=Total-Score;
  Result:=Score;
end;



function ScanZ(const Source,Search:AnsiString;Defects:Integer;var Start:integer):Integer;

  {Forward scan from Start looking for an approximate, "fuzzy" match of Search.
   Defects is the max. number of character "defects" allowed in a matching sub-string.
   Typically, 0<Defects<Length(Search).  A "defect" is one of the following:

   - Extra/missing character
   - Mismatched character
   - Adjacent characters swapped

   If Defects=0, a perfect match is required.  If Defects >= Length(Search), any string
   will match. Use negative start for case insensitive scan, i.e. case difference
   is NOT considered a defect.

   Returns:  Matching length, Start = Match location.  Resultant = 0 and Start
             is undefined if no match.  To continue a search, adjust Start
             beyond the returned match.}

begin
  Result:=0;                          //assume no match
  L1:=Length(Source);
  L2:=Length(Search);
  if (L1=0) OR (L2=0) OR (Defects<0) then Exit;      //sanity check
  if Defects=0 then begin             //perfect match
    Start:=ScanF(Source,Search,Start);
    if Start>0 then Result:=L2;
  end else if Defects>=L2 then begin  //match any
    if Abs(Start)<=L1 then Result:=iMin(L1,L2);
  end else asm                        //do the fuzzy thing
    Push  ESI
    Push  EDI
    Push  EBX

    Cld
    Mov   EDX,Source
    Mov   ECX,[EDX-4]

    Mov   EDI,Defects
    Mov   EBX,EDI
    Add   EBX,ECX

    Dec   ECX
    Add   ECX,EDX
    Mov   L1,ECX

    Mov   ESI,Search
    Mov   EAX,[ESI-4]
    Sub   EBX,EAX
    Add   EBX,EDX
    Mov   iMx,EBX

    Dec   EAX
    Add   EAX,ESI
    Mov   L2,EAX

    Mov   EBX,Start
    Mov   EAX,[EBX]
    Xor   EBX,EBX
    Or    EAX,EAX
    Jns   @L0
    Neg   EAX
    Or    EBX,$000F0000
@L0:
    Dec   EAX
    Add   EDX,EAX
    Mov   ECX,EDI
@Top:
    Xor   EAX,EAX
    Or    EBX,$F0000000
    Mov   ESI,Search
@L1:
    Cmp   EDX,iMx
    Ja    @Done
    Mov   EDI,EDX
    Inc   EDX
    Mov   Score,EAX
@L2:
    Lodsb
    Mov   AH,AL
    Mov   BL,[EDI]
    Inc   EDI
    Test  EBX,$000F0000
    Jz    @L3
    Push  EAX
    Call  RChar
    Mov   [ESP],AL
    Pop   EAX
@L3:
    Cmp   BL,AL
    Jz    @Next
    Cmp   BL,AH
    Jz    @Next
    Inc   Score
    Cmp   ECX,Score
    Jb    @Top
    Cmp   ESI,L2
    Ja    @L10
    Cmp   EDI,L1
    Ja    @L9
    Mov   BH,[EDI]
    And   EBX,$FF0FFFFF
    Cmp   BH,AL
    Jnz   @L4
    Jmp   @First
@L4:
    Cmp   BH,AH
    Jnz   @L5
@First:
    Test  EBX,$F0000000
    Jnz   @Top
    Or    EBX,$00F00000
@L5:
    Mov   AL,[ESI]
    Mov   AH,AL
    Test  EBX,$000F0000
    Jz    @L6
    Call  RChar
@L6:
    Cmp   BL,AL
    Jz    @L7
    Cmp   BL,AH
    Jz    @L7
    Test  EBX,$00F00000
    Jz    @Next
    Dec   ESI
    Jmp   @Next
@L7:
    Test  EBX,$00F00000
    Jnz   @L8
    Dec   EDI
    Jmp   @Next
@L8:
    Inc   ESI
    Inc   EDI
@Next:
    And   EBX,$0FFFFFFF
    Cmp   ESI,L2
    Ja    @L10
    Cmp   EDI,L1
    Jbe   @L2
@L9:
    Mov   EAX,L2
    Sub   EAX,ESI
    Add   EAX,Score
    Inc   EAX
    Mov   Score,EAX
@L10:
    Cmp   ECX,Score
    Jb    @Top
    Sub   EDI,EDX
    Inc   EDI
    Mov   @Result,EDI
    Mov   EDI,Source
    Sub   EDX,EDI
    Mov   ESI,Start
    Mov   [ESI],EDX
@Done:
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;
end;


procedure _BMTableINI;
  {Skip table initialization for Boyer-Moore search.

   On entry:
     EAX = Search string length
     ESI = Search address (Search end if reverse)
     EDI = Skip table address
     S2ED= Case Insensitive Flag
  }

  asm
    Push  EDI              //save skip array start
    Mov   ECX,256          //store 256 bytes
    Cld                    //make sure we go forward
    Rep   Stosb            //initialize the skip array
    Pop   EDI              //restore skip array start

    Mov   ECX,EAX          //move length to counter
    Dec   EAX              //zero based length
    Jz    @L3              //abort if only 1 char.
    Mov   EBX,EAX          //use EBX as temporary counter
    Xor   EAX,EAX
    Push  EBP
    Lea   EBP,RevCase

    Bt    S2ED,30          //reverse scan?
    Jnc   @L1              //no, then skip
    Std                    //go backwards

@L1:
    Lodsb                  //get byte from Search
    Mov   [EDI+EAX],BL     //store count into array

    Bt    S2ED,31          //case sensitive ?
    Jnc   @L2              //yes, then skip

    Mov   AL,[EBP+EAX]     //Reverse case
    Mov   [EDI+EAX],BL
@L2:
    Dec   EBX              //change counter
    Dec   ECX
    Jnz   @L1
    Pop   EBP
    Cld
@L3:
  end;


procedure _BMScan;
  {Boyer-Moore buffer scan.

   On entry:
     ECX  = Skip array address
     EDI  = Search end address
     ESI  = Source start (Buffer start + Length(Search))
     EDX  = Source End
     S2ED = Case Flg
   On return:
     EAX = Match address, zero if none
   }
  asm
    Lea   EAX,RevCase
    Mov   Score,EAX
    Xor   EBX,EBX          //clear counter
    Xor   EAX,EAX          //clear EAX
    Std                    //go backwards

@Next:
    Inc   EBX              //count the char
    Cmp   EBX,EBP          //over the limit ?
    Ja    @Found           //yes, we found a match!

    Lodsb                  //get next character from Source
    Mov   AH,[EDI]         //get next character from Search
    Dec   EDI              //decrement pointer

    Cmp   AH,63            //wildcard ?
    Jz    @Next            //yes, then check next char.

    Cmp   AL,AH            //match ?
    Jz    @Next            //yes, then check next char.
    Bt    S2ED,31          //case sensitive ?
    Jnc   @L4              //yes, then skip

    Push  EBX
    Push  EBP
    Mov   EBP,Score
    Xor   EBX,EBX
    Mov   BL,AL
    Mov   AL,[EBP+EBX]     //Reverse case
    Pop   EBP
    Pop   EBX

//    Cmp   AH,122
//    Ja    @L4
//    Cmp   AL,65
//    Jb    @L4
//    Cmp   AL,122
//    Ja    @L4
//    Xor   AL,32

    Cmp   AL,AH            //match ?
    Jz    @Next            //yes, then check next char.
@L4:
    Xor   AH,AH            //calc skip offset
    Mov   AL,[ECX+EAX]     //get skip from table
    Cmp   EBX,EAX          //count less than skip ?
    Jbe   @L7              //yes, then skip
    Mov   EAX,EBX          //use larger of count and skip
@L7:
    Inc   ESI
    Add   ESI,EAX          //add to Source pointer
    Add   EDI,EBX          //re-initialize Search offset
    Xor   EBX,EBX          //clear count
    Cmp   ESI,EDX          //end of string ?
    Jbe   @Next            //no, then do it again

@NotFound:
    Mov   ESI,-1
@Found:
    Inc   ESI
    Mov   EAX,ESI
  end;


procedure _BMScanR;
  {Reverse Boyer-Moore buffer scan.

   On entry:
     ECX  = Skip array address
     EDI  = Search start address
     EBP  = Search length
     ESI  = Source end (Buffer end - Length(Search))
     EDX  = Source start (where the search ends in this case)
     S2ED = Case Flg
   On return:
     EAX = Match address, zero if none
   }
  asm
    Lea   EAX,RevCase
    Mov   Score, EAX
    Xor   EBX,EBX          //clear counter
    Xor   EAX,EAX          //clear EAX
    Cld                    //go forwards

@Next:
    Inc   EBX              //count the char
    Cmp   EBX,EBP          //over the limit ?
    Ja    @Found           //yes, we found a match!

    Lodsb                  //get next character from Source
    Mov   AH,[EDI]         //get next character from Search
    Inc   EDI              //decrement pointer

    Cmp   AH,63            //wildcard ?
    Jz    @Next            //yes, then check next char.

    Cmp   AL,AH            //match ?
    Jz    @Next            //yes, then check next char.
    Bt    S2ED,31          //case sensitive ?
    Jnc   @L4              //yes, then skip

    Push  EBX
    Push  EBP
    Mov   EBP,Score
    Xor   EBX,EBX
    Mov   BL,AL
    Mov   AL,[EBP+EBX]     //Reverse case
    Pop   EBP
    Pop   EBX

//    Cmp   AH,122
//    Ja    @L4
//    Cmp   AL,65
//    Jb    @L4
//    Cmp   AL,122
//    Ja    @L4
//    Xor   AL,32

    Cmp   AL,AH            //match ?
    Jz    @Next            //yes, then check next char.
@L4:
    Xor   AH,AH            //calc skip offset
    Mov   AL,[ECX+EAX]     //get skip from table
    Cmp   EBX,EAX          //count less than skip ?
    Jbe   @L7              //yes, then skip
    Mov   EAX,EBX          //use larger of count and skip
@L7:
    Dec   ESI
    Sub   ESI,EAX          //add to Source pointer
    Sub   EDI,EBX          //re-initialize Search offset
    Xor   EBX,EBX          //clear count
    Cmp   EDX,ESI          //end of search ?
    Jbe   @Next            //no, then do it again

@NotFound:
    Mov   ESI,EBP
@Found:
    Sub   ESI,EBP
    Mov   EAX,ESI
  end;



function  ScanQ(const Source,Search:AnsiString;Start:Integer):Integer;

  {"Quick" forward scan using the primary Boyer-Moore heuristic. Search
   key length is limited to 256 characters or less and may contain any
   number of '?' wildcards to match any character. Supports case insensitive
   search via negative Start.

   This algorithm is often dramatically faster than a sequential search;
   however, there are cases where it may actually be slower.

   1) Very short Search key string (<3 chars).
   2) Relatively short Source string (<256 chars).
   3) A match is located very near the given Start location.  Obviously, you
      won't know this in advance; otherwise, you wouldn't need to search.
   4) Source contains many instances of a sub-string which matches the
      rightmost part of Search key. For example, if Search ends with '...ing'
      (as in 'String') and Source contains an excessively large number of
      the 'ing' sequence. In this case, the algorithm may waste significant
      time investigating false leads.

   Therefore, this function is probably at it's best when working with
   relatively long strings and medium sized keys.}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero Source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero Search ?
    Jz    @NotFound

    Mov   ESI,EAX          //Source address
    Mov   OutLen,ESI       //save it in OutLen
    Mov   EDI,EDX          //Search address
    Mov   Score,EDI        //save in Score

    Mov   S2ED,ECX         //save start offset
    Or    ECX,ECX          //zero start ?
    Jz    @NotFound        //yes, then bail
    Jns   @L0              //skip if case sensitive
    Neg   ECX
@L0:
    Btr   S2ED,30          //clear reverse flag
    Dec   ECX              //zero based start position
    Js    @NotFound

    Mov   EDX,[EAX-4]      //Source length
    Dec   EDX              //zero based
    Js    @NotFound        //abort on null string
    Cmp   EDX,ECX          //Source < Start?
    Jb    @NotFound        //yes, then abort

    Mov   EAX,[EDI-4]      //Search length
    Cmp   EAX,256          //Search > 256 char. ?
    Ja    @NotFound        //yes, then abort
    Mov   EBP,EAX          //save length in EBP
    Dec   EAX              //zero based
    Js    @NotFound        //abort on null string

    Add   EDX,ESI          //EDX = end of Source
    Add   ESI,ECX          //start at the given offset
    Add   ESI,EAX          //...from the right of Search
    Cmp   EDX,ESI          //Source too short for match ?
    Jb    @NotFound        //yes, then abort
    Mov   Total,ESI        //save start offset in Total

    Lea   EDI,iStack       //skip array address
    Xor   ECX,ECX
    Mov   CL,bScan         //initialization flag
    Jecxz @L3              //skip if initialize not required
    Mov   ESI,Score        //initialize Search address
    Inc   EAX              //Search length
    Call  _BMTableIni
@L3:
    Mov   bScan,True
    Mov   ECX,EDI          //skip address in ECX
    Mov   EDI,Score        //Search start
    Add   EDI,EBP          //Search end
    Dec   EDI
    Mov   ESI,Total        //Source start

    Call  _BMScan
    Or    EAX,EAX
    Jz    @Exit
    Sub   EAX,OutLen       //calc offset to end of match
    Inc   EAX
    Jmp   @Exit

@NotFound:
    Xor   EAX,EAX          //clear return

@Exit:
    Cld                    //clear the direction flag
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
  end;


function  ScanQC(const Source,Search:AnsiString;Start:Integer):Integer;

  {Continue a "Quick" forward scan. Source and Search must be the
   same as previously used with ScanQ. }

asm
  Mov  bScan,0
  Jmp  ScanQ
end;


function  ScanBfr(const Bfr:PByte;Search:AnsiString;BfrLen:Integer):PByte;
  {Same as ScanQ for generic buffer.}
  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero Source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero Search ?
    Jz    @NotFound

    Mov   ESI,EAX          //Source address
    Mov   OutLen,ESI       //save it in OutLen
    Mov   EDI,EDX          //Search address
    Mov   Score,EDI        //save in Score

    Mov   S2ED,ECX         //save length
    Or    ECX,ECX          //zero length ?
    Jz    @NotFound        //yes, then bail
    Jns   @L0              //skip if case sensitive
    Neg   ECX
@L0:
    Btr   S2ED,30          //clear reverse flag
    Mov   EDX,ECX          //Source length
    Dec   EDX              //zero based
    Js    @NotFound        //abort on null string

    Mov   EAX,[EDI-4]      //Search length
    Cmp   EAX,256          //Search > 256 char. ?
    Ja    @NotFound        //yes, then abort
    Mov   EBP,EAX          //save length in EBP
    Dec   EAX              //zero based
    Js    @NotFound        //abort on null string

    Add   EDX,ESI          //EDX = end of Source
    Add   ESI,EAX          //...from the right of Search
    Cmp   EDX,ESI          //Source too short for match ?
    Jb    @NotFound        //yes, then abort
    Mov   Total,ESI        //save start offset in Total

    Lea   EDI,iStack       //skip array address
    Xor   ECX,ECX
    Mov   CL,bScan         //initialization flag
    Jecxz @L3              //skip if initialize not required
    Mov   ESI,Score        //initialize Search address
    Inc   EAX              //Search length
    Call  _BMTableIni      //initialize skip array
@L3:
    Mov   bScan,True
    Mov   ECX,EDI          //skip address in ECX
    Mov   EDI,Score        //Search start
    Add   EDI,EBP          //Search end
    Dec   EDI
    Mov   ESI,Total        //Source start

    Call  _BMScan          //do the scan

    Jmp   @Exit

@NotFound:
    Xor   EAX,EAX          //clear return

@Exit:
    Cld                    //clear the direction flag
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
  end;


function  ScanBfrC(const Bfr:PByte;Search:AnsiString;BfrLen:Integer):PByte;
    {Same as ScanQC for generic buffer}
  asm
    Mov  bScan,0
    Jmp  ScanBfr
  end;


function  ScanBfrR(const Bfr:PByte;Search:AnsiString;BfrLen:Integer):PByte;
  {Reverse scan for generic buffer.}
  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero Source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero Search ?
    Jz    @NotFound

    Mov   ESI,EAX          //Source address
    Mov   OutLen,ESI       //save it in OutLen
    Mov   EDI,EDX          //Search address
    Mov   Score,EDI        //save in Score

    Mov   S2ED,ECX         //save length
    Or    ECX,ECX          //zero length ?
    Jz    @NotFound        //yes, then bail
    Jns   @L0              //skip if case sensitive
    Neg   ECX
@L0:
    Bts   S2ED,30          //set reverse flag
    Mov   EDX,ECX          //Source length
    Dec   EDX              //zero based
    Js    @NotFound        //abort on null string

    Mov   EAX,[EDI-4]      //Search length
    Cmp   EAX,256          //Search > 256 char. ?
    Ja    @NotFound        //yes, then abort
    Mov   EBP,EAX          //save length in EBP
    Dec   EAX              //zero based
    Js    @NotFound        //abort on null string

    Cmp   EDX,EAX          //Source<Search
    Jb    @NotFound        //yes, then abort
    Neg   EDX
    Add   EDX,ESI          //Source start
    Sub   ESI,EAX          //...from the Left of Search
    Mov   Total,ESI        //save start offset in Total

    Lea   EDI,iStack       //skip array address
    Xor   ECX,ECX
    Mov   CL,bScan         //initialization flag
    Jecxz @L3              //skip if initialize not required
    Mov   ESI,Score        //initialize Search address
    Add   ESI,EAX          //Search End address
    Inc   EAX              //Search length
    Call  _BMTableIni      //initialize skip array
@L3:
    Mov   bScan,True
    Mov   ECX,EDI          //skip address in ECX
    Mov   EDI,Score        //Search start
    Mov   ESI,Total        //Source start

    Call  _BMScanR         //do the reverse scan

    Jmp   @Exit

@NotFound:
    Xor   EAX,EAX          //clear return

@Exit:
    Cld                    //clear the direction flag
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
  end;


function  ScanBfrRC(const Bfr:PByte;Search:AnsiString;BfrLen:Integer):PByte;
    {Same as ScanQC for generic buffer}
  asm
    Mov  bScan,0
    Jmp  ScanBfrR
  end;


function  ScanQR(const Source,Search:AnsiString;Start:Integer):Integer;
  {Same as ScanQ but reversed.}
  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX          //zero Source ?
    Jz    @NotFound
    Or    EDX,EDX          //zero Search ?
    Jz    @NotFound

    Mov   ESI,EAX          //Source address
    Mov   OutLen,ESI       //save it in OutLen
    Mov   EDI,EDX          //Search address
    Mov   Score,EDI        //save in Score

    Mov   EDX,[EAX-4]      //Source length
    Mov   S2ED,ECX         //save start offset
    Or    ECX,ECX          //zero length ?
    Jz    @L4              //yes, then use full length
    Jns   @L0              //skip if case sensitive
    Neg   ECX
    Jmp   @L0
@L4:
    Mov   ECX,EDX          //use full length
@L0:
    Bts   S2ED,30          //set reverse flag
    Cmp   EDX,ECX          //Source < Start?
    Jb    @NotFound        //yes, then abort
    Dec   EDX              //zero based
    Js    @NotFound        //abort on null string

    Mov   EAX,[EDI-4]      //Search length
    Cmp   EAX,256          //Search > 256 char. ?
    Ja    @NotFound        //yes, then abort
    Mov   EBP,EAX          //save length in EBP
    Dec   EAX              //zero based
    Js    @NotFound        //abort on null string

    Mov   EDX,ESI          //EDX = Start of Source (where search ends)
    Add   ESI,ECX          //start at the given offset
    Sub   ESI,EAX          //...from the Left of Search
    Cmp   ESI,EDX          //Source too short for match ?
    Jb    @NotFound        //yes, then abort
    Mov   Total,ESI        //save start offset in Total

    Lea   EDI,iStack       //skip array address
    Xor   ECX,ECX
    Mov   CL,bScan         //initialization flag
    Jecxz @L3              //skip if initialize not required
    Mov   ESI,Score        //initialize Search address
    Add   ESI,EAX          //Search End address
    Inc   EAX              //Search length
    Call  _BMTableIni      //initialize skip array
@L3:
    Mov   bScan,True
    Mov   ECX,EDI          //skip address in ECX
    Mov   EDI,Score        //Search start
    Mov   ESI,Total        //Source start

    Call  _BMScanR         //do the reverse scan

    Or    EAX,EAX
    Jz    @Exit
    Sub   EAX,OutLen       //calc offset to end of match
    Inc   EAX
    Jmp   @Exit

@NotFound:
    Xor   EAX,EAX          //clear return

@Exit:
    Cld                    //clear the direction flag
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
  end;


function  ScanQRC(const Source,Search:AnsiString;Start:Integer):Integer;
    {Same as ScanQC but reversed.}
  asm
    Mov  bScan,0
    Jmp  ScanQR
  end;


procedure UCase(var Source:AnsiString; Index,Count:Integer);
  {Upper case Count chars. in Source starting at Index.}
var
  I:Integer;
begin
  if Index<=0 then Exit;
  while (Index<=Length(Source)) AND (Count>0) do begin
    I:=Ord(Source[Index]);
    Source[Index]:=UprCase[I];
    Inc(Index);
    Dec(Count);
  end;
end;


procedure LCase(var Source:AnsiString;Index,Count:Integer);
  {Lower case Count chars. in Source starting at Index.}
var
  I:Integer;
begin
  if Index<=0 then Exit;
  while (Index<=Length(Source)) AND (Count>0) do begin
    I:=Ord(Source[Index]);
    Source[Index]:=LowCase[I];
    Inc(Index);
    Dec(Count);
  end;
end;


procedure AnsiLCase(var Source:AnsiString;const Index,Count:Integer);
  {Lower case Count characters in Source starting at Index considering
   Windows locale.}
var
  I:Integer;
begin
  if (Index<1) or (Index>Length(Source)) then Exit;
  I:=Length(Source)-Index+1;
  if (Count>0) AND (I>Count) then I:=Count;
  UniqueString(Source);
  CharLowerBuff(@Source[Index],I);
end;


procedure AnsiUCase(var Source:AnsiString;const Index,Count:Integer);
  {Upper case Count characters in Source starting at Index considering
   Windows locale.}
var
  I:Integer;
begin
  if (Index<1) OR (Index>Length(Source)) then Exit;
  I:=Length(Source)-Index+1;
  if (Count>0) AND (I>Count) then I:=Count;
  UniqueString(Source);
  CharUpperBuff(@Source[Index],I);
end;


procedure ProperCase(var Source:AnsiString);

  {Upper case the first alpha character in each word, lower case all
   other characters. Any char. less than ASCII 48 (0) is considered a
   word delimiter.}

  asm
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX
    Jz    @Exit
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]
    Or    ESI,ESI
    Jz    @Exit
    Mov   ECX,[ESI-4]      //source length
    Jecxz @Exit
    Cld                    //insure we go forward
    Mov   DL,32
    Lea   EBP,LowCase
    Lea   EDI,UprCase
    Xor   EAX,EAX
@L1:
    Lodsb                  //get character from string
    Cmp   DL,48            //last char. a delimiter ?
    Jae   @L2              //no, then continue
    Mov   AL,[EDI+EAX]     //upper case it
    Mov   [ESI-1],AL       //store it back in string
    Jmp   @Next
@L2:
    Mov   AL,[EBP+EAX]     //lower case it
    Mov   [ESI-1],AL       //store it back in string
@Next:
    Mov   DL,AL
    Dec   ECX
    Jnz   @L1

@Exit:
    Pop   EBP
    Pop   EDI
    Pop   ESI
  end;


function CountT(const Source,Table:AnsiString;Index:Integer):integer;

  {Count all occurances of Table chars from Index position
   forward to end of string.

   Returns:  Count if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Call  _TableScanIni    //do initialization
    Jecxz @NotFound        //abort on error
    Sub   ECX,EAX          //adjust length
    Xor   EAX,EAX
    Mov   EBP,EAX
@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in EDX
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bt    EBX,EDX
//*    Bt    EBX,DL           //test the bit
    Jnc   @Skip
    Inc   EBP
@Skip:
    Dec   ECX
    Jnz   @Next

    Mov   EAX,EBP
    Jmp   @Exit

@NotFound:
    Xor   EAX,EAX          //clear return

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


function CountW(const Source,Table:AnsiString):Integer;

  {Count the number of words in Source delimited by any of the char.
   in Table. Leading and trailing delimiters are ignored, any consecutive
   delimiters are treated as one.

   Returns:  Count if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI

    Xor   EBX,EBX          //zero accumulator
    Or    EAX,EAX          //zero source ?
    Jz    @Exit
    Or    EDX,EDX          //zero table ?
    Jz    @Exit

    Mov   EDI,EAX          //source address
    Mov   ESI,EDX          //table address
    Mov   ECX,[EDI-4]      //source length
    Jecxz @Exit            //abort on null

    Mov   EDX,[ESI-4]      //table length
    Or    EDX,EDX
    Jz    @Exit            //abort on null
    Add   EDX,ESI          //EDX=table end
    Cld                    //insure we go forward

@Next:
    Push  ESI              //save Table start
    Mov   AH,[EDI]         //get next character from source
    Inc   EDI
@Table:
    Lodsb                  //get next character from table
    Cmp   AL,AH            //match ?
    Jnz   @Skip            //no, then don't count
    Or    EBX,EBX          //flag set ?
    Jns   @Match           //no, then skip
    Xor   EBX,$80000000    //clear the flag
    Inc   EBX              //count the delimiter
    Jmp   @Match           //go to next char in source
@Skip:
    Cmp   ESI,EDX          //end of table ?
    Jnz   @Table           //no, then try next table char
    Or    EBX,$80000000    //set the flag
@Match:
    Pop   ESI              //restore table start
    Dec   ECX
    Jnz   @Next


    Or    EBX,EBX
    Jns   @Exit
    Xor   EBX,$80000000
    Inc   EBX

@Exit:
    Mov   EAX,EBX

    Pop   EDI              //restore the world
    Pop   ESI
    Pop   EBX

end;


function CountM(const Source,Table:AnsiString;Index:Integer):integer;

  {Count Table characters from Index position forward.
   Stop at first non-matching character or end of string.

   Returns:  Count if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Call  _TableScanIni    //do initialization
    Jecxz @NotFound        //abort on error
    Sub   ECX,EAX          //adjust length
    Xor   EAX,EAX
    Mov   EBP,EAX
@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in EDX
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bt    EBX,EDX
//*    Bt    EBX,DL           //test the bit
    Jnc   @Done
    Inc   EBP
    Dec   ECX
    Jnz   @Next
@Done:
    Mov   EAX,EBP
    Jmp   @Exit

@NotFound:
    Xor   EAX,EAX          //clear return

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


function CountN(const Source,Table:AnsiString;Index:Integer):integer;

  {Count NON-Table characters from Index position forward.
   Stop at first matching character or end of string.

   Returns:  Count if found; otherwise, 0}

  asm

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Call  _TableScanIni    //do initialization
    Jecxz @NotFound        //abort on error
    Sub   ECX,EAX          //adjust length
    Xor   EAX,EAX
    Mov   EBP,EAX
@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in EDX
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBX,[EDI+EAX]    //get the dbl-word
    Bt    EBX,EDX
//*    Bt    EBX,DL           //test the bit
    Jc    @Done
    Inc   EBP
    Dec   ECX
    Jnz   @Next
@Done:
    Mov   EAX,EBP
    Jmp   @Exit

@NotFound:
    Xor   EAX,EAX          //clear return

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
end;


procedure Translate(var Source:AnsiString;const Table,Replace:AnsiString);

  {Replace all Table chars. with the corresponding character from Replace
   table.  By definition, the 2 tables must be the same size.}
var
  I,J:Integer;
begin
  if Length(Table)=Length(Replace) then begin
    I:=1;
    J:=ScanT(Source,Table,I);
    while J>0 do begin
      Source[J]:=Replace[ScanC(Table,Source[J],1)];
      I:=J+1;
      J:=ScanT(Source,Table,I);
    end;
  end;
end;


procedure ReplaceT(var Source:AnsiString;const Table:AnsiString;X:Char);

  {Search and replace all chars. matching any in Table with a given
   replacement character.}

begin
  ReplaceI(Source,Table,1,X);
end;


procedure ReplaceI(var Source:AnsiString;const Table:AnsiString;Index:Integer;X:Char);
  {Search from Index forward and replace all chars. matching any in Table with a
   given replacement character.}

  asm
    Push  EAX
    Mov   AL,X             //replacement char
    Mov   bI,AL            //save
    Pop   EAX

    Push  EBX              //save the important stuff
    Push  ESI
    Push  EDI
    Push  EBP

    Or    EAX,EAX
    Jz    @Exit
    Push  EAX
    Push  EDX
    Push  ECX
    Call  UniqueString
    Pop   ECX
    Pop   EDX
    Pop   EAX
    Mov   EAX,[EAX]
    Call  _TableScanIni
    Jecxz @Exit
    Sub   ECX,EAX
    Xor   EAX,EAX
    Mov   DH,bI
@Next:
    Lodsb                  //get the byte
    Mov   DL,AL            //save it in DL
    And   DL,31            //bit index
    Shr   EAX,5            //dbl-word index
    Shl   EAX,2
    Mov   EBP,[EDI+EAX]    //get the dbl-word
    Bt    EBP,EDX
//*    Bt    EBP,DL           //test the bit
    Jnc   @Skip            //skip write if not in Table
    Mov   [ESI-1],DH
@Skip:
    Dec   ECX
    Jnz   @Next

@Exit:
    Pop   EBP              //restore the world
    Pop   EDI
    Pop   ESI
    Pop   EBX
  end;


procedure IncStr(var Source:AnsiString);

  {Increment an alphanumeric string.  Only string positions containing
   alphanumeric characters (0-9,A-Z,a-z) are included.  Therefore,
   strings to be incremented must be properly initialized. Incrementation
   is case-sensitive, overflows are ignored.

   Example: 1a-9Z-99 is incremented to 1b-0A-00.}

  asm
    Push  ESI                //save the important stuff

    Or    EAX,EAX
    Jz    @Exit

    Push  EAX
    Call  UniqueString
    Pop   EAX

    Mov   ESI,[EAX]
    Or    ESI,ESI
    Jz    @Exit
    Mov   ECX,[ESI-4]        //Source length
    Jcxz  @Exit              //abort if null
    Add   ESI,ECX            //point to end
    Dec   ESI
    Std                      //work backwards

@More:
    Lodsb                    //get character from Source
    Cmp   AL,"0"             //delimiter?
    Jb    @Next              //yes, then skip
    Cmp   AL,"9"             //is it a digit?
    Ja    @Upper             //no, but see if it's an upper case letter
    Call  @Inc               //yes, increment it
    Jc    @Exit              //this character didn't wrap, all done
    Jmp   @Next              //we need to increment the next one, continue

@Upper:
    Cmp   AL,"A"             //is it a delimiter?
    Jb    @Next              //yes, skip ahead
    Cmp   AL,"Z"             //is it an upper case letter?
    Ja    @Lower             //no, see if it's a lower case letter
    Call  @Inc               //yes, increment it
    Jc    @Exit              //all done, exit
    Jmp   @Next              //continue to the next character

@Lower:
    Cmp   AL,"a"             //is it a delimiter?
    Jb    @Next              //yes, skip ahead
    Cmp   AL,"z"             //is it an upper case letter?
    Ja    @Next              //no, skip ahead to the next character
    Call  @Inc               //yes, increment it
    Jc    @Exit              //all done, exit

@Next:
    Dec   ECX
    Jnz   @More


@Inc:

    Inc   AL                 //first increment the character

    Cmp   AL,"9" + 1         //did we bump too far on a digit?
    Jne   @ChkUpper          //no, but see if it was an upper case letter
    Mov   AL,"0"             //wrap around to "0"
    Jmp   @IncDone           //and leave with the carry flag clear

@ChkUpper:
    Cmp   AL,"Z" + 1         //did we bump too far on an upper case letter?
    Jne   @ChkLower          //no, but see if it was a lower case letter
    Mov   AL,"A"             //wrap around to "A"
    Jmp   @IncDone           //and leave with the carry flag clear

@ChkLower:
    Cmp   AL,"z" + 1         //did we bump too far on a lower case letter?
    Jne   @IncDone           //no, so we're all done
    Mov   AL,"a"             //wrap around to "a"

@IncDone:
    Mov   [ESI+01],AL        //replace the character in the string
    Ret                      //return to caller

@Exit:
    Cld                      //restore the direction flag for BASIC

    Pop   ESI

  end;


procedure ReplaceS(var Source:AnsiString;const Target,Replace:AnsiString);

  {Replaces all occurances of Target sub-string with Replace sub-string.}

begin
  ReplaceSC(Source,Target,Replace,False);
end;


//function ReplaceSC(var Source:AnsiString;const Target,
//                   Replace:AnsiString;CaseFlg:Boolean):Integer;
//  {Replace all occurances of Target sub-string in Source with Replace
//   sub-string. Case-insensitive if CaseFlg=True. Returns number of replacements
//   made.}
//var
//  I,J,K,T,R:Integer;
//  Tmp:AnsiString;
//begin
//  Result:=0;
//  R:=Length(Replace);
//  T:=Length(Target);
//  if T=0 then Exit;
//  I:=1;
//  K:=1;
//  J:=0;
//  repeat
//    if CaseFlg then I:=-I;
//    I:=ScanF(Source,Target,I);
//    if I>0 then begin
//      if I>K then begin
////        I:=I-K;
////        J:=J+I;
//        Dec(I,K);
//        Inc(J,I);
//        if J>Length(Tmp) then Setlength(Tmp,J SHL 1);
//        MoveStr(Source, K, Tmp, J-I+1, I);
////        K:=K+I;
//        Inc(K,I);
//        I:=K;
//      end;
//      if R>0 then begin
////        J:=J+R;
//        Inc(J,R);
//        if J>Length(Tmp) then Setlength(Tmp,J SHL 1);
//        MoveStr(Replace, 1, Tmp, J-R+1, R);
//      end;
//      K:=I+T;
//      I:=K;
//      Inc(Result);
//    end else break;
//  until True=False;
//  if Result>0 then begin
//    if K<=Length(Source) then begin
//      I:=Length(Source)-K+1;
////      J:=J+I;
//      Inc(J,I);
//      if J>Length(Tmp) then Setlength(Tmp,J);
//      MoveStr(Source, K, Tmp, J-I+1, I);
//    end;
//    SetLength(Tmp,J);
//    Source:=Tmp;
//  end;
//end;


function ReplaceSC(var Source:AnsiString;const Target,
                   Replace:AnsiString;CaseFlg:Boolean):Integer;
  {Replace all occurances of Target sub-string in Source with Replace
   sub-string. Case-insensitive if CaseFlg=True. Returns number of replacements
   made.}
var
  I,J,K,L,T,R:Integer;
  Tmp:AnsiString;
  iArray:^TIntegerArray;
begin
  Result:=0;
  R:=Length(Replace);
  T:=Length(Target);
  if T=0 then Exit;
  I:=1;
  J:=0;
  iArray:=nil;
  try
    repeat
      if CaseFlg then I:=ScanF(Source,Target,-I) else I:=ScanFF(Source,Target,I);
      if I>0 then begin
        if Result>=J then begin
          Inc(J,1024);
          Dim(iArray,J SHL 2,False);
        end;
        iArray[Result]:=I;
        Inc(Result);
        Inc(I,T);
      end else break;
    until True=False;
    if Result>0 then begin
      SetLength(Tmp,Length(Source)+(Result*(R-T)));
      I:=1;
      J:=1;
      K:=0;
      while K<Result do begin
        L:=iArray[K]-I;
        Move(Source[I],Tmp[J],L);
        Inc(J,L);
        if R>0 then begin
          Move(Replace[1],Tmp[J],R);
          Inc(J,R);
        end;
        Inc(I,L);
        Inc(I,T);
        Inc(K);
      end;
      L:=Length(Source)-I+1;
      if L>0 then Move(Source[I],Tmp[J],L);
      Source:=Tmp;
    end;
  finally
    Dim(iArray,0,False);
  end;
end;


function LStr(const Source:AnsiString;Count:Integer):AnsiString;

  {For VB converts, similar to LEFT$().  This and related routines are
   specialized, easy-to-use wrappers for the Copy function.}

begin
  Result:=Copy(Source,1,Count);
end;


function RStr(const Source: AnsiString; Count: Integer): AnsiString;

  {For VB converts, similar to RIGHT$()}

begin
  Result:=Copy(Source,Length(Source)-Count+1,Count);
end;


function CStr(const Source:AnsiString;Index,Count:Integer):AnsiString;

  {For VB converts, similar to MID$() function}

begin
  Result:=Copy(Source,Index,Count);
end;


function IStr(const Source:AnsiString;Index:Integer):AnsiString;
  {Returns remaining portion of source from Index forward}
begin
  if Index<1 then
    Result:=''
  else if Index=1 then
    Result:=Source
  else
    Result:=Copy(Source,Index,Length(Source));

end;


function Extract(const Source,Srch:AnsiString;Index:Integer):AnsiString;
  {Returns portion of Source from Index forward to Srch. Supports case
   insensitive using negative index. If Srch begins with '?' then remainder
   is treated as a table of single characters to be matched.}
var
  I:Integer;
begin
  I:=0;
  Result:='';
  if Length(Srch)>0 then begin
    if Srch[1]='?' then I:=ScanT(Source,IStr(Srch,2),Index)
    else I:=ScanF(Source,Srch,Index);
  end;
  if I>0 then Result:=Copy(Source,Abs(Index),I-ABS(Index))
  else Result:=IStr(Source,Abs(Index));
end;



function  DupChr(const X:Char;Count:Integer):AnsiString;
  {Returns a string of length Count by duplicating char. X.
   Use the native StringOfChar() function for new work.}
begin
  if Count>0 then begin
    SetLength(Result,Count);
    if Length(Result)=Count then FillChar(Result[1],Count,X);
  end;
end;


procedure LPad(var Source: AnsiString;const X:Char;Count:Integer);
  {Append characters (X) to left of string as required to increase
   length to Count. Similar results can be obtained using the built-in
   Format function; however, this routine is much simpler in many cases.}
begin
  if Length(Source)<Count then
    Insert(DupChr(X,Count-Length(Source)),Source,1);
end;


procedure RPad(var Source: AnsiString;const X:Char;Count:Integer);
  {Append characters (X) to right of string as required to increase
   length to Count.}
var
  I:Integer;
begin
  if Length(Source)<Count then
  begin
    I:=Length(Source)+1;
    SetLength(Source,Count);
    FillStr(Source,I,X);
  end;
end;


procedure CPad(var Source: AnsiString; const X:Char;Count:Integer);
  {Append characters to left and right of string as required to increase
   length to Count and center (approx.) text within Source.}
var
  I:Integer;
begin
  if Length(Source)<Count then
  begin
    I:=(Count-Length(Source)) DIV 2;
    if I>0 then Insert(DupChr(X,I),Source,1);
    if Length(Source)<Count then begin
      I:=Length(Source)+1;
      SetLength(Source,Count);
      FillStr(Source,I,X);
    end;
  end;
end;


function LAdd(const Source: AnsiString;const X:Char;Count:Integer):AnsiString;
begin
  Result:=Source;
  LPad(Result,X,Count);
end;

function RAdd(const Source: AnsiString;const X:Char;Count:Integer):AnsiString;
begin
  Result:=Source;
  RPad(Result,X,Count);
end;

function CAdd(const Source: AnsiString;const X:Char;Count:Integer):AnsiString;
begin
  Result:=Source;
  CPad(Result,X,Count);
end;


procedure LFlush(var Source:AnsiString);

  {Left justifies text within Source.  Length is unchanged.}

  asm
    Push  ESI
    Push  EDI             //save the important stuff
    Push  EBX

    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]
    Or    ESI,ESI
    Jz    @Done
    Mov   EDI,ESI         //put address into write register
    Mov   ECX,[ESI-4]     //put length into count register
    Mov   EBX,ECX         //save it in EBX
    Jecxz @Done           //bail out if zero length
    Mov   AH,32           //looking for spaces (or less)
    Xor   DL,DL           //use DL as a flag
    Cld                   //make sure we go forward
@L1:
    Lodsb
    Or    DL,DL
    Jnz   @L4
    Cmp   AL,AH           //equal or less?
    Jbe   @L2             //yes, then skip the write
@L4:
    Stosb
    Mov   DL,255
@L2:
    Dec   ECX
    Jnz   @L1

    Mov   AL,32           //prepare to pad with spaces
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb                 //pad it
    Jmp   @L3             //and do it again
@Done:
    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


procedure RFlush(var Source:AnsiString);

  {Right justifies text within Source.  Length is unchanged.}

  asm
    Push  ESI
    Push  EDI             //save the important stuff
    Push  EBX

    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Mov   EBX,ECX         //save it in EBX
    Jecxz @Done           //bail out if zero length
    Dec   ESI
    Add   ESI,ECX
    Mov   EDI,ESI         //put address into write register
    Mov   AH,32           //looking for spaces (or less)
    Xor   DL,DL           //use DL as a flag
    Std                   //make sure we go backward
@L1:
    Lodsb
    Or    DL,DL
    Jnz   @L4
    Cmp   AL,AH           //equal or less?
    Jbe   @L2             //yes, then skip the write
@L4:
    Stosb
    Mov   DL,255
@L2:
    Dec   ECX
    Jnz   @L1

    Mov   AL,32           //prepare to pad with spaces
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb                 //pad it
    Jmp   @L3             //and do it again
@Done:
    Cld
    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here


procedure CFlush(var Source:AnsiString);

  {Center justifies text within Source.  Length is unchanged.}

  asm
    Push  ESI
    Push  EDI             //save the important stuff
    Push  EBX

    Or    EAX,EAX
    Jz    @Done
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //put length into count register
    Jecxz @Done           //bail out if zero length
    Mov   EDI,ESI         //put address into write register
    Mov   AH,32           //looking for spaces (or less)
    Xor   EBX,EBX         //clear accumulators
    Xor   EDX,EDX
    Push  ECX             //save length
    Cld                   //go forward
@X1:                      //scan for left and right spaces
    Lodsb                 //get a byte
    Cmp   AL,AH           //space or less ?
    Jg    @X2             //no then skip
    Or    EDX,EDX         //EDX already set ?
    Jnz   @X3             //yes, then skip
    Mov   EBX,ESI         //set left marker
    Jmp   @X3
@X2:
    Mov   EDX,ESI         //set right marker
@X3:
    Dec   ECX
    Jnz   @X1

    Pop   ECX             //restore length
    Or    EBX,EBX         //all spaces ?
    Jz    @Done           //yes, then nothing to do
    Mov   ESI,EDI         //restore start address
    Sub   EBX,ESI         //# left spaces
    Sub   EDX,ESI         //# left non-spaces
    Mov   EAX,ECX
    Sub   EAX,EDX         //# right spaces
    Cmp   EBX,EAX         //left = right ?
    Jz    @Done           //yes, then done
    Jg    @Y1             //Left>Right then skip
    Sub   EAX,EBX         //difference
    Shr   EAX,1           //divide by 2
    Jz    @Done           //nothing to do
    Dec   EDI
    Add   EDI,ECX         //end of string
    Sub   ECX,EAX         //subtract offset
    Add   ESI,ECX         //end of string - offset
    Dec   ESI
    Std                   //make sure we go backward
    Jmp   @L1             //move it
@Y1:
    Sub   EBX,EAX         //difference
    Shr   EBX,1           //divide by 2
    Jz    @Done           //nothing to do
    Add   ESI,EBX         //adjust for offset
    Sub   ECX,EBX
@L1:
    rep   movsb           //do the move
    Mov   AL,32           //prepare to pad with spaces
@L3:
    Cmp   ESI,EDI         //read = write ?
    Jz    @Done           //yes, then we're done
    Stosb                 //pad it
    Jmp   @L3             //and do it again
@Done:
    Cld
    Pop   EBX
    Pop   EDI             //restore the important stuff
    Pop   ESI
  end;                    //and we're outta here



procedure FillStr(var Source:AnsiString;const Index:Integer;X:Char);

  {Fill Source starting at Index location using Char X. Includes range
   checking to prevent memory corruption.}

begin
  FillCnt(Source,Index,Length(Source),X);
end;


procedure FillCnt(var Source:AnsiString;const Index,Cnt:Integer;X:Char);

  {Fill Source with Cnt characters (X fill char.) starting at index location.
   Includes range checking to prevent memory corruption.}

begin
  UniqueString(Source);
  asm
    Push  ESI

    Mov   EAX,Source
    Or    EAX,EAX
    Jz    @Done
    Mov   EDI,[EAX]        //Source address
    Or    EDI,EDI
    Jz    @Done
    Mov   EDX,Index        //start location
    Or    EDX,EDX
    Jz    @Done

    Mov   ECX,[EDI-4]      //source length
    Jecxz @Done            //Abort on null string

    Dec   EDX              //zero based index position
    Sub   ECX,EDX          //remaining length
    Jbe   @Done            //abort if Index>Length
    Add   EDI,EDX          //start at the given offset

    Mov   EAX,Cnt          //fill count
    Cmp   ECX,EAX          //less than remaining length ?
    Jbe   @L1              //yes, then skip
    Mov   ECX,EAX          //use fill count
@L1:
    Mov   AL,X             //the fill character
    Cld                    //make sure we go forward
    Repnz Stosb            //do the fill
@Done:
    Pop   EDI
  end;
end;


procedure OverWrite(var Source:AnsiString; const Replace:AnsiString;Index:Integer);

  {Replace Source text at Index location with Replace text. A companion to
   the Delphi Insert and Delete functions. Built-in range checking prevents
   memory corruption.}

begin
  MoveStr(Replace,1,Source,Index,Length(Replace));
end;


procedure MoveStr(const S:AnsiString;XS:Integer;var D:AnsiString;const XD,Cnt:Integer);

  {Generic string slice and dice utility. Overwrite destination string (D)
   at location XD with Cnt characters from source string (S) at location XS.
   Full range checking is included to prevent memory corruption.
   Example use: MoveStr(Source,SIndex,Dest,DIndex,Count) }

  asm
    Or    EAX,EAX
    Jz    @Abort           //bad source address
    Jecxz @Abort           //bad destination address
    Xchg  EAX,ECX          //swap Source/Dest for UniqueString call

    Push  EAX
    Push  ECX
    Push  EDX
    Call  UniqueString
    Pop   EDX
    Pop   ECX
    Pop   EAX

    Push  ESI
    Push  EDI
    Push  EBX

    Mov   ESI,ECX          //Source address
    Mov   EDI,[EAX]        //Dest address
    Or    EDI,EDI
    Jz    @Done            //quit if null Dest pointer
    Mov   ECX,Cnt          //copy count
    Jecxz @Done            //abort if zero

    Mov   EBX,EDX          //Start location
    Or    EBX,EBX
    Jz    @L1
    Dec   EBX              //zero based
@L1:
    Mov   EDX,[ESI-4]      //source length
    Or    EDX,EDX
    Jz    @Done            //Abort if null string

    Sub   EDX,EBX          //remaining
    Jbe   @Done            //nothing left so quit
    Add   ESI,EBX          //start offset address

    Cmp   ECX,EDX          //Count<=remaining ?
    Jbe   @L2              //Yes, then OK
    Mov   ECX,EDX          //use remaining
@L2:
    Mov   EBX,XD           //destination location
    Or    EBX,EBX
    Jz    @L3
    Dec   EBX              //zero based
@L3:
    Mov   EDX,[EDI-4]      //destination length
    Or    EDX,EDX
    Jz    @Done            //Abort if null string

    Sub   EDX,EBX          //remaining
    Jbe   @Done            //nothing left so quit
    Add   EDI,EBX          //start location

    Cmp   ECX,EDX          //Count<=remaining ?
    Jbe   @L4              //Yes, then OK
    Mov   ECX,EDX          //use remaining
@L4:
    Cld                    //make sure we go forward
    Mov   EDX,ECX          //save count
    Shr   ECX,2            //calc dwords
    Rep   Movsd            //move the dwords
    Mov   ECX,EDX
    And   ECX,3            //calc bytes
    Rep   Movsb            //move the odd bytes
@Done:
    Pop   EBX              //restore the world
    Pop   EDI
    Pop   ESI
@Abort:
  end;


procedure ShiftStr(var S:AnsiString;Index,Count:Integer);

  {Generic string shift utility; moves chars left/right within S starting at Index.
   +Count moves characters right,
   -Count moves characters left.
   +Index selects Index and following characters
   -Index selects Index and preceding characters
   Characters are discarded/overwritten as required.
   Vacated positions are left as-is.}

  asm
    Or    EAX,EAX
    Jz    @Abort           //bad source address
    Or    EDX,EDX
    Jz    @Abort           //bad index
    Or    ECX,ECX
    Jz    @Abort           //bad count

    Push  EAX
    Push  ECX
    Push  EDX
    Call  UniqueString     //make sure string is unique
    Pop   EDX
    Pop   ECX
    Pop   EAX

    Push  ESI
    Push  EDI

    Mov   EDI,EAX          //Source address
    Mov   EAX,ECX          //Save count in EAX
    Mov   EDI,[EDI]
    Mov   ECX,[EDI-4]      //Source length
    Or    ECX,ECX
    Jz    @Done            //bail out if zero source
    Or    EAX,EAX          //reverse ?
    Js    @RL              //yes, then skip

@RR:
    Std                    //work backwards
    Or    EDX,EDX
    Js    @LR
    Cmp   EDX,ECX          //index at or beyond end ?
    Jae   @Done            //yes, then nothing to do
    Add   EDI,ECX          //end of string
    Dec   EDI
    Sub   ECX,EDX          //remaining string
    Cmp   ECX,EAX          //remaining < Count
    Jb    @Done            //yes, then nothing to do
    Sub   ECX,EAX          //remaining - count
    Inc   ECX              //+1 = characters to move
    Mov   ESI,EDI
    Sub   ESI,EAX          //read pointer
    Rep   movsb            //do the move
    Jmp   @Done            //and we're done
@LR:
    Neg   EDX
    Cmp   EDX,ECX          //index beyond end ?
    Ja    @Done            //yes, then done
    Cmp   EAX,ECX          //move beyond end
    Jae   @Done            //yes, then done
    Add   EDI,EDX
    Dec   EDI              //Index address
    Mov   ESI,EDI          //save as source
    Add   EDI,EAX          //destination address
    Sub   ECX,EDX          //remaining characters
    Cmp   EAX,ECX          //move<=remaining
    Jbe   @Skip1           //yes then skip
    Sub   EAX,ECX          //calc overshoot
    Sub   EDI,EAX          //adjust destination
    Sub   ESI,EAX          //adjust source
    Sub   EDX,EAX          //adjust count
@Skip1:
    Mov   ECX,EDX          //characters to move
    Rep   movsb            //do it
    Jmp   @Done            //and we're done
@RL:
    Cld                    //work forwards
    Neg   EAX
    Or    EDX,EDX
    Js    @LL
    Cmp   EDX,ECX          //bad index
    Ja    @Done
    Cmp   EAX,ECX          //Count>=Length
    Jae   @Done            //yes, then nothing to do
    Sub   ECX,EDX          //remaining = Length-Index
    Inc   ECX              //+1 = characters to move
    Add   EDI,EDX
    Dec   EDI              //Index address
    Mov   ESI,EDI          //Source
    Sub   EDI,EAX          //destination
    Cmp   EAX,EDX          //Count<Index
    Jb    @Skip2           //yes, then skip
    Sub   EAX,EDX          //Adjust = Count - Index + 1
    Inc   EAX
    Add   ESI,EAX          //adjust source
    Add   EDI,EAX          //adjust dest
    Sub   ECX,EAX          //adjust count
@Skip2:
    Rep   movsb
    Jmp   @Done
@LL:
    Neg   EDX
    Cmp   EDX,ECX          //bad index
    Ja    @Done
    Cmp   EAX,EDX          //bad count
    Jae   @Done
    Mov   ESI,EDI
    Add   ESI,EAX          //source = start + count
    Sub   EDX,EAX          //characters to move = index - count
    Mov   ECX,EDX
    Rep   movsb            //do it
@Done:
    Cld
    Pop   EDI
    Pop   ESI
@Abort:
  end;



function Parse(const Source,Table:AnsiString;var Index:Integer):AnsiString;

  {Sequential, left to right token parsing using a delimiter table.
   Intended for applications where there is limited control over delimiter use.
   Index is a pointer (initialize to '1' for first token) updated by the
   function to point to next token.  For the next token, simply call the
   function again using the prior returned Index value.

   If returned Index > Length or Index < 1, no more tokens are available.}
var
  I,J:Integer;
begin
  {Please resist the temptation to tamper with the following code.  Doing so
   will break other routines which rely upon Parse.  The returned Index value
   is quite subtle but critical in some cases.}

  J:=Length(Source)+1;
  if (Index>0) and (Index<J) and (Length(Table)>0) then begin
    I:=ScanTQ(Source,Table,Index);
    if I=0 then begin  //no delimiter before end of string
      I:=J;
      J:=0;            //return a zero Index
    end else J:=I+1;   //otherwise, return delimiter + 1
    Result:=Copy(Source,Index,I-Index);
    Index:=J;
  end else begin
    Index:=0;    //return a null index
    Result:='';  //and a null string
  end;
end;


function ParseWord(const Source,Table:AnsiString;var Index:Integer):AnsiString;

  {Similar to Parse but does not stop on null tokens.  Intended for use
   in parsing "words" from freeform text.

   Index is a pointer (initialize to '1' for first token) updated by the
   function to point to next token.  For the next token, simply call the
   function again using the prior returned Index value.

   If returned Index > Length or Index < 1, no more tokens are available.}
var
  I,J:Integer;
begin
  J:=Length(Source)+1;
  if (Index>0) and (Index<J) and (Length(Table)>0) then begin
    Dec(Index);
    repeat
      Inc(Index);
      I:=ScanTQ(Source,Table,Index);
    until (I=0) or (I>Index);
    if I=0 then begin  //no delimiter before end of string
      I:=J;
      J:=0;            //return a zero Index
    end else J:=I+1;   //otherwise, return delimiter + 1
    Result:=Copy(Source,Index,I-Index);
    Index:=J;
  end else begin
    Index:=0;    //return a null index
    Result:='';  //and a null string
  end;
end;


function ParseTag(const Source,Start,Stop:AnsiString;var Index:Integer):AnsiString;

  {Sequential, left to right parsing of tokens delimited by start/stop "tag"
   strings as commonly found in HTML and XML strings.

   Index is a pointer (initialize to '1' for first token) updated by the
   function to point to the next token.  For the next token, simply call the
   function again using the prior returned Index value.

   If returned Index > Length or Index < 1, no more tokens are available.}
var
  I,J:Integer;
begin
  I:=0;
  Result:='';
  if (Index>0) and (Index<Length(Source)) and
     (Length(Start)>0) and (Length(Stop)>0) then begin
    I:=ScanQ(Source,Start,Index);
    if I>0 then begin      //start delimiter found
      I:=I+Length(Start);
      J:=ScanQ(Source,Stop,I);
      if J>0 then begin    //stop delimiter found
        Result:=Copy(Source,I,J-I);
        I:=J+Length(Stop);
      end else I:=0;
    end;
  end;
  Index:=I;
end;


function Fetch(const Source,Table:AnsiString;Num:Integer;DelFlg:Boolean):AnsiString;

  {Retrieve token by number using a delimiter table. Intended for applications
   where there is limited control over delimiter use. Num is the token number
   ('1' = first) to 'fetch' from Source. If DelFlg is True, the returned token
   includes the end delimiter as the last character.

   If token not found, a null string is returned.}
var
  I,J:Integer;
begin
  Result:='';
  if (Num>0) and (Length(Source)>0) and (Length(Table)>0) then
  begin
    I:=0;
    Total:=0;
    repeat
      J:=I+1;
      I:=ScanTQ(Source,Table,J);
      Inc(Total);
    until (Total=Num) OR (I=0);
    if Total=Num then begin
      if I=0 then
        I:=Length(Source)+1
      else if DelFlg then I:=I+1;
      Result:=Copy(Source,J,I-J);
    end;
  end;
end;


function CountF2(Source,Search:AnsiString;Index:Integer):Integer;
  {Count double character strings from Index forward.}
begin
  Result:=0;
  Index:=ScanC2(Source,Search,Index);
  while Index>0 do begin
    Inc(Result);
    Inc(Index,2);
    Index:=ScanC2(Source,Search,Index);
  end;
end;


function CountR2(Source,Search:AnsiString;Index:Integer):Integer;
  {Count double character strings from index backward.}
begin
  Result:=0;
  Index:=ScanB2(Source,Search,Index);
  while Index>0 do begin
    Inc(Result);
    Dec(Index);
    Index:=ScanB2(Source,Search,Index);
  end;
end;


function SetDelimiter(Delimit:Char):Boolean;

  {Set the single delimiter character used by the following token functions.
   Default = Comma (ASCII 44). Returns False if delimiter is null (zero).}

begin
  Result:=Ord(Delimit)>0;
  if Result then begin
    Delimiter:=Delimit;
    Delimiter2[1]:=Delimit;
    Delimiter2[2]:=#0;
  end;
end;


function GetDelimiter:Char;
  {Return the current single delimiter char. being used by the token functions.
   Supports writing well behaved token handlers.  For example, a routine
   which needs to use a specific delimiter can save the current delimiter,
   change to the required delimiter, do the task at hand, then restore the
   original.}
begin
  Result:=Delimiter;
end;


function SetDelimiter2(Delimit:AnsiString):Boolean;
  {Set the double character delimiter to be used by the following token functions.
   Returns True if Delimit is a 2 character string; otherwise, False.}
begin
  Result:=False;
  if (Length(Delimit)>0) and (Length(Delimit)<=2) then begin
    Delimiter:=Delimit[1];
    Delimiter2[2]:=#0;
    MoveStr(Delimit,1,Delimiter2,1,2);
    Result:=True;
  end;
end;


function GetDelimiter2:AnsiString;
  {Return the current double char. delimiter being used by the token functions.
   Supports writing well behaved token handlers.}
begin
  Result:=Delimiter2;
end;


function  GetToken(const Source:AnsiString;Index:Integer):AnsiString;
  {Retrieves the token associated with the given Index position. NOTE:
   A valid Index is any character position between delimiters (string
   start and end are considered delimiters). Index is indeterminate if
   Source[Index] = Delimiter. Use Index = 1 for first token, Index =
   Length(Source) for Last. An invalid or indeterminate Index returns
   a null string. See docs for more details.}
var
  I,J:Integer;
begin
  if (Index<=0) or (Length(Source)=0) or (Index>Length(Source)) or (Source[Index]=Delimiter) then
  begin
    Result:='';
  end else begin
    if Delimiter2[2]<>#0 then begin
      I:=ScanB2(Source,Delimiter2,Index);
      J:=ScanC2(Source,Delimiter2,Index);
      if I=0 then I:=1 else Inc(I,2);
    end else begin
      I:=ScanB(Source,Delimiter,Index)+1;
      J:=ScanC(Source,Delimiter,Index);
    end;
    if J=0 then J:=Length(Source)+1;
    Result:=Copy(Source,I,J-I);
  end;
end;


function InsertToken(var Source:AnsiString; const Token:AnsiString;Index:Integer):Boolean;
  {Insert token at the position referenced by Index; shifting existing tokens
   as necessary.  Use Index = 0 to append a new token. Returns False if
   Index is otherwise invalid.}
var
  I:Integer;
  D2Flg:Boolean;
begin
  I:=Length(Source);
  Result:=Index<=I;
  if NOT(Result) then Exit;
  D2Flg:=Delimiter2[2]<>#0;
  if I>0 then
    if Index=0 then begin
      Index:=I+1;
      if Index=1 then
        Insert(Token,Source,Index)
      else begin
        if D2Flg then Insert(Delimiter2+Token,Source,Index)
        else Insert(Delimiter+Token,Source,Index);
      end;
    end else begin
      if D2Flg then begin
        Index:=ScanB2(Source,Delimiter2,Index);
        if Index=0 then Index:=1 else Inc(Index,2);
        Insert(Token+Delimiter2,Source,Index);
      end else begin
        Index:=ScanB(Source,Delimiter,Index)+1;
        Insert(Token+Delimiter,Source,Index);
      end;
    end
  else Source:=Token;
end;


function DeleteToken(var Source:AnsiString;var Index:Integer):Boolean;
  {Delete token referenced by Index position; shifting tokens as
   necessary to fill the voided position. Returns False if Index is
   invalid. If Source[Index] = Delimiter, the delimiter is deleted.
   Index points to the next token if successful (resultant = True).}
var
  I,J:Integer;
  D2Flg:Boolean;
begin
  I:=Length(Source);
  if (Index<=0) or (I=0) or (Index>I) then begin
    Result:=False;
    Exit;
  end else Result:=True;
  D2Flg:=Delimiter2[2]<>#0;
  if D2Flg then begin
    J:=ScanC2(Source,Delimiter2,Index);
    I:=ScanB2(Source,Delimiter2,Index);
  end else begin
    J:=ScanC(Source,Delimiter,Index);
    I:=ScanB(Source,Delimiter,Index);
  end;
  if J=0 then J:=Length(Source)+1;
  if I=J then begin
    if D2Flg then Delete(Source,Index,2) else Delete(Source,Index,1);
  end else begin
    Index:=I;
    if D2Flg and (Index<>0) then Inc(Index);
    Inc(Index);
    Delete(Source,Index,J-I);
  end;
end;


function ReplaceToken(var Source:AnsiString;Token:AnsiString;Index:Integer):Boolean;
  {Replace the token at the given Index position.  Returns False if
   Index is invalid.}
var
  I,J:Integer;
  D2Flg:Boolean;
begin
  I:=Length(Source);
  if (Index<=0) or (I=0) or (Index>I) then begin
    Result:=False;
    Exit;
  end else Result:=True;
  D2Flg:=Delimiter2[2]<>#0;
  if D2Flg then begin
    J:=ScanC2(Source,Delimiter2,Index);
    I:=ScanB2(Source,Delimiter2,Index);
    if I=0 then I:=1 else if I<>J then Inc(I,2);
  end else begin
    J:=ScanC(Source,Delimiter,Index);
    I:=ScanB(Source,Delimiter,Index);
    if I=0 then I:=1 else if I<>J then Inc(I);
  end;
  if J=0 then J:=Length(Source)+1;
  Insert(Token,Source,I);
  if I<>J then Delete(Source,I+Length(Token),J-I);
end;



function PrevToken(const Source:AnsiString;var Index:Integer):Boolean;
  {Move Index pointer to preceding token.  Returns False and Index is
   undefined if no token precedes current.}
var
  I:Integer;
begin
  I:=Length(Source);
  if (Index<=0) or (I=0) or (Index>I) then begin
    Result:=False;
    Exit;
  end;
  if Delimiter2[2]<>#0 then Index:=ScanB2(Source,Delimiter2,Index)
  else Index:=ScanB(Source,Delimiter,Index);
  if Index>0 then Dec(Index);
  Result:=(Index>0);
end;


function NextToken(const Source:AnsiString;var Index:Integer):Boolean;
  {Move Index pointer to following token.  Returns False and Index is
   undefined if no additional token is found.}
var
  I:Integer;
begin
  I:=Length(Source);
  if (Index<=0) or (I=0) or (Index>I) then begin
    Result:=False;
    Exit;
  end;
  if Delimiter2[2]<>#0 then begin
    Index:=ScanC2(Source,Delimiter2,Index);
    if Index>0 then Inc(Index);
  end else Index:=ScanC(Source,Delimiter,Index);
  if Index>0 then begin
    Inc(Index);
    Result:=True;  //replace with line below for full compatability with previous versions
//    Result:=(Index<=I);
  end else Result:=False;
end;


function  GetTokenNum(const Source:AnsiString;Index:Integer):Integer;
  {Translate a string Index position into a 1 based (First = 1) token
   number. Returns zero if Index is invalid or indeterminate.

   Tokens are normally referenced by a string index position so this
   function should rarely be needed.}
begin
  Result:=0;
  if (Index>0) AND (Index<=Length(Source)) AND (Source[Index]<>Delimiter) then begin
    if Delimiter2[2]<>#0 then Result:=CountR2(Source,Delimiter2,Index)+1
    else Result:=CountR(Source,Delimiter,Index)+1;
  end;
end;


function  GetTokenPos(const Source:AnsiString;Num:Integer):Integer;
  {Translate a token position Number into a string index position.
   Returns zero if the requested token position is invalid.}
begin
  Result:=0;
  if Num=1 then begin
    if Length(Source)>0 then Result:=1;
  end else begin
    Dec(Num);
    if Delimiter2[2]<>#0 then begin
      repeat
        Inc(Result);
        Dec(Num);
        Result:=ScanC2(Source,Delimiter2,Result);
        if Result=0 then break else Inc(Result);
      until Num=0;
    end else Result:=ScanCC(Source,Delimiter,Num);
    if Result>0 then Inc(Result);
  end;
end;


function  GetTokenCnt(const Source:AnsiString):Integer;
  {Count the total number of tokens in Source.}
begin
  Result:=0;
  if Length(Source)>0 then begin
    if Delimiter2[2]<>#0 then Result:=CountF2(Source,Delimiter2,1)+1
    else Result:=CountF(Source,Delimiter,1)+1;
  end;
end;


function ChkSum(const Source:AnsiString):Word;
  {Fletcher's Checksum, IEEE Transactions on Communications, Jan. 1982
   Error detection nearly as good as 16-bit CRC but much "cheaper" to
   calc, also has some special properites.

   Max. error rates:  16-bit CRC      = 0.001526%
                      16-bit Fletcher = 0.001538%}
  asm
    Push  EBX
    Push  ESI

    Or    EAX,EAX          //abort on nil string
    Jz    @Done
    Mov   ESI,EAX          //get descriptor address into SI
    Mov   ECX,[EAX-4]      //put it into CX
    Xor   EAX,EAX
    Jecxz @Done             //abort if zero length

    Xor   BX,BX            //clear BX, use as checksum accumulator
    Cld                    //make sure we go forward

@Start:                    //begin checksum loop
    Lodsb                  //load a string byte
    Add   BL,AL            //sum1 + S[i]
    Adc   BL,AH            //a "cheap" way to calc MOD 255 (almost)
    Add   BH,BL            //sum1 + sum2
    Adc   BH,AH            //another "cheap" MOD 255
    Dec   ECX
    Jnz   @Start

    Cmp   BL,255           //make sure sum1 is 0-254
    Jne   @L1              //the cheap calc above fails if sum1 = 255
    Xor   BL,BL
@L1:
    Cmp   BH,255           //make sure sum2 is 0-254
    Jne   @L2
    Xor   BH,BH
@L2:
    Mov   AX,BX            //return combined checksum in AX

@Done:
    Pop   ESI
    Pop   EBX
  end;


procedure MakeSumZero(var Source:AnsiString);
  {Appends BINARY WORD (2 chars, range 0-255) to Source creating a new
   string which "sums to zero" with the complementary Fletcher checksum
   routine. Use to make strings self-checking! NOTE: The resultant string
   should not be cast as null terminated.}

  {NOTE: A few words on "var" type parameters.  These parameters are
         passed by reference, i.e. a pointer to the variable.  Since a
         string is itself a pointer, a double de-reference is required.
         The first de-reference exposes the string pointer variable;
         the second exposes the actual memory address of the string.}

begin
  if Length(Source)>0 then
  begin
    wI:=ChkSum(Source);
    SetLength(Source,Length(Source)+2);
    asm
      Push  ESI              //save the good stuff
      Mov   ESI,Source       //get the pointer to Source
      Or    ESI,ESI
      Jz    @Done
      Mov   ESI,[ESI]        //get the address held in Source
      Mov   EAX,[ESI-4]      //using the address, get the string length
      Add   ESI,EAX          //point to the end of string
      Dec   ESI              //..minus 2
      Dec   ESI
      Mov   AX,wI            //get the checksum calculated above
      Add   AL,AH            //sum1 + sum2
      Adc   AL,0             //a "cheap" MOD 255
      Xor   AL,255           //sum1 = 255 - ((sum1 + sum2) MOD 255)
      Mov   [ESI],AX         //store back in string
@Done:
      Pop   ESI
    end;
  end;
end;


procedure Do_CRC32;
asm
    Lea   EDI,@CRCTbl      //Table address into EDI
    Xor   EAX,EAX          //clear EAX for use with Lodsb

    Cld                    //make sure we go forward
@L1:
    Lodsb                  //load byte from string
    Mov   EBX,EDX          //Build table index
    Xor   EBX,EAX          //add current byte
    And   EBX,$FF          //mask out low byte only
    Shl   EBX,2            //a cheap 4 X multiply (double word table)
    Shr   EDX,8            //shift and mask current total
    And   EDX,$FFFFFF
    Xor   EDX,[EDI+EBX]    //add table to current
    Dec   ECX
    Jnz   @L1

    Mov   EAX,EDX          //output new total

    Jmp   @Done            //and we're outta here

@CRCTbl:  //Standard CRC table
    DD    $00000000, $77073096, $ee0e612c, $990951ba
    DD    $076dc419, $706af48f, $e963a535, $9e6495a3
    DD    $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988
    DD    $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91

    DD    $1db71064, $6ab020f2, $f3b97148, $84be41de
    DD    $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7
    DD    $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec
    DD    $14015c4f, $63066cd9, $fa0f3d63, $8d080df5

    DD    $3b6e20c8, $4c69105e, $d56041e4, $a2677172
    DD    $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b
    DD    $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940
    DD    $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59

    DD    $26d930ac, $51de003a, $c8d75180, $bfd06116
    DD    $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f
    DD    $2802b89e, $5f058808, $c60cd9b2, $b10be924
    DD    $2f6f7c87, $58684c11, $c1611dab, $b6662d3d

    DD    $76dc4190, $01db7106, $98d220bc, $efd5102a
    DD    $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433
    DD    $7807c9a2, $0f00f934, $9609a88e, $e10e9818
    DD    $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01

    DD    $6b6b51f4, $1c6c6162, $856530d8, $f262004e
    DD    $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457
    DD    $65b0d9c6, $12b7e950, $8bbeb8ea, $fcb9887c
    DD    $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65

    DD    $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2
    DD    $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb
    DD    $4369e96a, $346ed9fc, $ad678846, $da60b8d0
    DD    $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9

    DD    $5005713c, $270241aa, $be0b1010, $c90c2086
    DD    $5768b525, $206f85b3, $b966d409, $ce61e49f
    DD    $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4
    DD    $59b33d17, $2eb40d81, $b7bd5c3b, $c0ba6cad

    DD    $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a
    DD    $ead54739, $9dd277af, $04db2615, $73dc1683
    DD    $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8
    DD    $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1

    DD    $f00f9344, $8708a3d2, $1e01f268, $6906c2fe
    DD    $f762575d, $806567cb, $196c3671, $6e6b06e7
    DD    $fed41b76, $89d32be0, $10da7a5a, $67dd4acc
    DD    $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5

    DD    $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252
    DD    $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b
    DD    $d80d2bda, $af0a1b4c, $36034af6, $41047a60
    DD    $df60efc3, $a867df55, $316e8eef, $4669be79

    DD    $cb61b38c, $bc66831a, $256fd2a0, $5268e236
    DD    $cc0c7795, $bb0b4703, $220216b9, $5505262f
    DD    $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04
    DD    $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d

    DD    $9b64c2b0, $ec63f226, $756aa39c, $026d930a
    DD    $9c0906a9, $eb0e363f, $72076785, $05005713
    DD    $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38
    DD    $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21

    DD    $86d3d2d4, $f1d4e242, $68ddb3f8, $1fda836e
    DD    $81be16cd, $f6b9265b, $6fb077e1, $18b74777
    DD    $88085ae6, $ff0f6a70, $66063bca, $11010b5c
    DD    $8f659eff, $f862ae69, $616bffd3, $166ccf45

    DD    $a00ae278, $d70dd2ee, $4e048354, $3903b3c2
    DD    $a7672661, $d06016f7, $4969474d, $3e6e77db
    DD    $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0
    DD    $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9

    DD    $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6
    DD    $bad03605, $cdd70693, $54de5729, $23d967bf
    DD    $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94
    DD    $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d

@Done:

end;


function CRC32(const IniCRC:Integer;Source:AnsiString):Integer;
  {Standard, table based CRC32 calculation. Initial string MUST use
   IniCRC:=-1 (or $FFFFFFFF). To add subsequent strings to the calcs, use
   IniCrc:= Prior CRC32 resultant. Final resultant must be bit flipped
   using NOT operator to conform to specs.  Equivalent Pascal to add char.
   I to the CRC total might be as follows:

   CRC:=((CRC SHR 8) AND $FFFFFF) XOR CRCTbl[(CRC XOR Source[I]) AND $FF];}

  asm
    Push  EBX
    Push  ESI
    Push  EDI

    Or    EDX,EDX
    Jz    @Done
    Mov   ESI,EDX          //get address into SI
    Mov   ECX,[EDX-4]      //put length into ECX
    Jecxz @Done            //abort if zero length
    Mov   EDX,EAX          //Initial CRC into EDX

    CALL  Do_CRC32

@Done:
    Pop   EDI              //restore the world
    Pop   ESI
    Pop   EBX
  end;

//function CRC32(const IniCRC:Integer;Source:AnsiString):Integer;
//  {Standard, table based CRC32 calculation. Initial string MUST use
//   IniCRC:=-1 (or $FFFFFFFF). To add subsequent strings to the calcs, use
//   IniCrc:= Prior CRC32 resultant. Final resultant must be bit flipped
//   using NOT operator to conform to specs.  Equivalent Pascal to add char.
//   I to the CRC total might be as follows:
//
//   CRC:=((CRC SHR 8) AND $FFFFFF) XOR CRCTbl[(CRC XOR Source[I]) AND $FF];}
//
//  asm
//    Push  EBX
//    Push  ESI
//    Push  EDI
//
//    Or    EDX,EDX
//    Jz    @Done
//    Mov   ESI,EDX          //get address into SI
//    Mov   ECX,[EDX-4]      //put length into ECX
//    Jecxz @Done            //abort if zero length
//    Mov   EDX,EAX          //Initial CRC into EDX
//
//    Lea   EDI,@CRCTbl      //Table address into EDI
//    Xor   EAX,EAX          //clear EAX for use with Lodsb
//
//    Cld                    //make sure we go forward
//@L1:
//    Lodsb                  //load byte from string
//    Mov   EBX,EDX          //Build table index
//    Xor   EBX,EAX          //add current byte
//    And   EBX,$FF          //mask out low byte only
//    Shl   EBX,2            //a cheap 4 X multiply (double word table)
//    Shr   EDX,8            //shift and mask current total
//    And   EDX,$FFFFFF
//    Xor   EDX,[EDI+EBX]    //add table to current
//    Dec   ECX
//    Jnz   @L1
//
//    Mov   EAX,EDX          //output new total
//
//@Done:
//    Pop   EDI              //restore the world
//    Pop   ESI
//    Pop   EBX
//
//    Ret                   //and we're outta here
//
//@CRCTbl:  //Standard CRC table
//    DD    $00000000, $77073096, $ee0e612c, $990951ba
//    DD    $076dc419, $706af48f, $e963a535, $9e6495a3
//    DD    $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988
//    DD    $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91
//
//    DD    $1db71064, $6ab020f2, $f3b97148, $84be41de
//    DD    $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7
//    DD    $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec
//    DD    $14015c4f, $63066cd9, $fa0f3d63, $8d080df5
//
//    DD    $3b6e20c8, $4c69105e, $d56041e4, $a2677172
//    DD    $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b
//    DD    $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940
//    DD    $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59
//
//    DD    $26d930ac, $51de003a, $c8d75180, $bfd06116
//    DD    $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f
//    DD    $2802b89e, $5f058808, $c60cd9b2, $b10be924
//    DD    $2f6f7c87, $58684c11, $c1611dab, $b6662d3d
//
//    DD    $76dc4190, $01db7106, $98d220bc, $efd5102a
//    DD    $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433
//    DD    $7807c9a2, $0f00f934, $9609a88e, $e10e9818
//    DD    $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01
//
//    DD    $6b6b51f4, $1c6c6162, $856530d8, $f262004e
//    DD    $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457
//    DD    $65b0d9c6, $12b7e950, $8bbeb8ea, $fcb9887c
//    DD    $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65
//
//    DD    $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2
//    DD    $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb
//    DD    $4369e96a, $346ed9fc, $ad678846, $da60b8d0
//    DD    $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9
//
//    DD    $5005713c, $270241aa, $be0b1010, $c90c2086
//    DD    $5768b525, $206f85b3, $b966d409, $ce61e49f
//    DD    $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4
//    DD    $59b33d17, $2eb40d81, $b7bd5c3b, $c0ba6cad
//
//    DD    $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a
//    DD    $ead54739, $9dd277af, $04db2615, $73dc1683
//    DD    $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8
//    DD    $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1
//
//    DD    $f00f9344, $8708a3d2, $1e01f268, $6906c2fe
//    DD    $f762575d, $806567cb, $196c3671, $6e6b06e7
//    DD    $fed41b76, $89d32be0, $10da7a5a, $67dd4acc
//    DD    $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5
//
//    DD    $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252
//    DD    $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b
//    DD    $d80d2bda, $af0a1b4c, $36034af6, $41047a60
//    DD    $df60efc3, $a867df55, $316e8eef, $4669be79
//
//    DD    $cb61b38c, $bc66831a, $256fd2a0, $5268e236
//    DD    $cc0c7795, $bb0b4703, $220216b9, $5505262f
//    DD    $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04
//    DD    $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d
//
//    DD    $9b64c2b0, $ec63f226, $756aa39c, $026d930a
//    DD    $9c0906a9, $eb0e363f, $72076785, $05005713
//    DD    $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38
//    DD    $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21
//
//    DD    $86d3d2d4, $f1d4e242, $68ddb3f8, $1fda836e
//    DD    $81be16cd, $f6b9265b, $6fb077e1, $18b74777
//    DD    $88085ae6, $ff0f6a70, $66063bca, $11010b5c
//    DD    $8f659eff, $f862ae69, $616bffd3, $166ccf45
//
//    DD    $a00ae278, $d70dd2ee, $4e048354, $3903b3c2
//    DD    $a7672661, $d06016f7, $4969474d, $3e6e77db
//    DD    $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0
//    DD    $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9
//
//    DD    $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6
//    DD    $bad03605, $cdd70693, $54de5729, $23d967bf
//    DD    $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94
//    DD    $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d
//  end;


function  CRCBfr(const IniCRC:Integer; Bfr:PByte;BfrLen:Integer):Integer;
  {Same as CRC32 but for generic buffer}
  asm
    Push  EBX
    Push  ESI
    Push  EDI

    Or    EDX,EDX          //bad pointer ?
    Jz    @Done            //yes, then abort
    Mov   ESI,EDX          //get address into SI
    Jecxz @Done            //abort if zero length
    Mov   EDX,EAX          //Initial CRC into EDX

    CALL  Do_CRC32         //do the CRC calcs

@Done:
    Pop   EDI
    Pop   ESI
    Pop   EBX
  end;


function CRC8(const IniCRC:Byte;Source:AnsiString):Byte;
  {8 bit CRC calculation. Initial string MUST use IniCRC:=0. To add subsequent
   strings to the calcs, use  IniCrc:= Prior CRC8 resultant.}
asm
  Push  ESI

  Or    EDX,EDX
  Jz    @Done
  Mov   ESI,EDX          //get address into SI
  Mov   ECX,[EDX-4]      //put length into ECX
  Jecxz @Done            //abort if zero length
  Mov   EDX,EAX          //Initial CRC into EDX
  Xor   EAX,EAX          //clear EAX for use with Lodsb

  Cld
@Top:
  Mov   AH,8
  Lodsb
@L1:
  Shr   AL,1
  Jc    @Skip1
  Shr   DL,1
  Jc    @Skip2
  Jmp   @Skip3
@Skip1:
  Shr   DL,1
  Jc    @Skip3
@Skip2:
  Xor   DL,$8C
@Skip3:
  Dec   AH
  Jnz   @L1
  Dec   ECX
  Jnz   @Top
  Mov   AL,DL
@Done:
  Pop   ESI

end;



function CRC16(const IniCRC:Word;Source:AnsiString):Word;

  {Standard, table based CRC16 calculation. Initial string MUST use
   IniCRC:=-1 (or $FFFF). To add subsequent strings to the calcs, use
   IniCrc:= Prior CRC16 resultant. Final resultant must be bit flipped
   using NOT operator to conform to specs.  Equivalent Pascal logic to add
   char. I to the CRC total might be as follows:

   CRC:=((CRC SHR 8) AND $FF) XOR CRCTbl[(CRC XOR Source[I]) AND $FF];}

  asm
    Push  EBX
    Push  ESI
    Push  EDI

    Or    EDX,EDX
    Jz    @Done
    Mov   ESI,EDX          //get address into SI
    Mov   ECX,[EDX-4]      //put length into ECX
    Jecxz @Done            //abort if zero length
    Lea   EDI,@CRCTbl      //Table address into EDI
    Mov   EDX,EAX          //Initial CRC into EDX
    Xor   EAX,EAX          //clear EAX for use with Lodsb

    Cld                    //make sure we go forward
@L1:
    Lodsb                  //load byte from string
    Mov   EBX,EDX          //Build table index
    Xor   EBX,EAX          //add current byte
    And   EBX,$FF          //mask out low byte only
    Shl   EBX,1            //a cheap 2 X multiply (word table)
    Shr   EDX,8            //shift and mask current total
    And   EDX,$FF
    Xor   EDX,[EDI+EBX]    //add table to current
    Dec   ECX
    Jnz   @L1

    Mov   EAX,EDX          //output new total

@Done:
    Pop   EDI              //restore the world
    Pop   ESI
    Pop   EBX

    Ret                   //and we're outta here

@CrcTbl:  //Standard CRC Table
    DW    $0000, $C0C1, $C181, $0140, $C301, $03C0, $0280, $C241
    DW    $C601, $06C0, $0780, $C741, $0500, $C5C1, $C481, $0440

    DW    $CC01, $0CC0, $0D80, $CD41, $0F00, $CFC1, $CE81, $0E40
    DW    $0A00, $CAC1, $CB81, $0B40, $C901, $09C0, $0880, $C841

    DW    $D801, $18C0, $1980, $D941, $1B00, $DBC1, $DA81, $1A40
    DW    $1E00, $DEC1, $DF81, $1F40, $DD01, $1DC0, $1C80, $DC41

    DW    $1400, $D4C1, $D581, $1540, $D701, $17C0, $1680, $D641
    DW    $D201, $12C0, $1380, $D341, $1100, $D1C1, $D081, $1040

    DW    $F001, $30C0, $3180, $F141, $3300, $F3C1, $F281, $3240
    DW    $3600, $F6C1, $F781, $3740, $F501, $35C0, $3480, $F441

    DW    $3C00, $FCC1, $FD81, $3D40, $FF01, $3FC0, $3E80, $FE41
    DW    $FA01, $3AC0, $3B80, $FB41, $3900, $F9C1, $F881, $3840

    DW    $2800, $E8C1, $E981, $2940, $EB01, $2BC0, $2A80, $EA41
    DW    $EE01, $2EC0, $2F80, $EF41, $2D00, $EDC1, $EC81, $2C40

    DW    $E401, $24C0, $2580, $E541, $2700, $E7C1, $E681, $2640
    DW    $2200, $E2C1, $E381, $2340, $E101, $21C0, $2080, $E041

    DW    $A001, $60C0, $6180, $A141, $6300, $A3C1, $A281, $6240
    DW    $6600, $A6C1, $A781, $6740, $A501, $65C0, $6480, $A441

    DW    $6C00, $ACC1, $AD81, $6D40, $AF01, $6FC0, $6E80, $AE41
    DW    $AA01, $6AC0, $6B80, $AB41, $6900, $A9C1, $A881, $6840

    DW    $7800, $B8C1, $B981, $7940, $BB01, $7BC0, $7A80, $BA41
    DW    $BE01, $7EC0, $7F80, $BF41, $7D00, $BDC1, $BC81, $7C40

    DW    $B401, $74C0, $7580, $B541, $7700, $B7C1, $B681, $7640
    DW    $7200, $B2C1, $B381, $7340, $B101, $71C0, $7080, $B041

    DW    $5000, $90C1, $9181, $5140, $9301, $53C0, $5280, $9241
    DW    $9601, $56C0, $5780, $9741, $5500, $95C1, $9481, $5440

    DW    $9C01, $5CC0, $5D80, $9D41, $5F00, $9FC1, $9E81, $5E40
    DW    $5A00, $9AC1, $9B81, $5B40, $9901, $59C0, $5880, $9841

    DW    $8801, $48C0, $4980, $8941, $4B00, $8BC1, $8A81, $4A40
    DW    $4E00, $8EC1, $8F81, $4F40, $8D01, $4DC0, $4C80, $8C41

    DW    $4400, $84C1, $8581, $4540, $8701, $47C0, $4680, $8641
    DW    $8201, $42C0, $4380, $8341, $4100, $81C1, $8081, $4040

  end;


function CRCXY(const IniCRC:Word;Source:AnsiString):Word;

  {16-bit CRC variant made popular by X/YModem communication protocols.}

  asm
    Push  EBX
    Push  ESI

    Or    EDX,EDX
    Jz    @Done
    Mov   ESI,EDX          //get address into SI
    Mov   ECX,[ESI-4]      //put length into ECX
    Jecxz @Done            //abort if zero length
    Mov   EDX,EAX          //Initial CRC into EDX
    XChg  DL,DH
    Xor   EAX,EAX          //clear EAX for use with Lodsb
    Mov   BX,$1021

    Cld                    //make sure we go forward
@L1:
    Lodsb                  //load byte from string
    Mov   AH,AL
    Xor   AL,AL
    Xor   DX,AX

    Shl   DX,1
    Jnc   @noXor1
    Xor   DX,BX
@noXor1:
    Shl   DX,1
    Jnc   @noXor2
    Xor   DX,BX
@noXor2:
    Shl   DX,1
    Jnc   @noXor3
    Xor   DX,BX
@noXor3:
    Shl   DX,1
    Jnc   @noXor4
    Xor   DX,BX
@noXor4:
    Shl   DX,1
    Jnc   @noXor5
    Xor   DX,BX
@noXor5:
    Shl   DX,1
    Jnc   @noXor6
    Xor   DX,BX
@noXor6:
    Shl   DX,1
    Jnc   @noXor7
    Xor   DX,BX
@noXor7:
    Shl   DX,1
    Jnc   @noXor8
    Xor   DX,BX
@noXor8:
    Dec   ECX
    Jnz   @L1

    Mov   AX,DX
    XChg  AL,AH
@Done:
    Pop   ESI
    Pop   EBX

  end;


function ChkSumXY(const Source:AnsiString):Byte;

  {Simple additive 1 byte checksum as used in X/YModem communication protocols.}

  asm
    Push  ESI

    Or    EAX,EAX          //abort on nil string
    Jz    @Done
    Mov   ESI,EAX          //get descriptor address into SI
    Mov   ECX,[EAX-4]      //put it into CX
    Xor   EAX,EAX
    Jecxz @Done            //abort if zero length

    Cld                    //make sure we go forward

@Start:                    //begin checksum loop
    Lodsb                  //load a string byte
    Add   AH,AL            //sum1 + S[i]
    Dec   ECX
    Jnz   @Start

    Mov   AL,AH
    Xor   AH,AH            //return checksum in AX

@Done:
    Pop   ESI
  end;


function NetSum(const Source:AnsiString):Word;

  {Simple 16-bit one's complement checksum as used in UDP/IP datagrams.
   Returns zero only on error.}

  asm
    Push  ESI

    Or    EAX,EAX          //abort on nil string
    Jz    @Done
    Mov   ESI,EAX          //get descriptor address into SI
    Mov   ECX,[EAX-4]      //put length into ECX
    Xor   EAX,EAX
    Jecxz @Done            //abort if zero length
    Cld                    //make sure we go forward
    Xor   EDX,EDX
    Shr   ECX,1            //length in words
    Jnc   @Start           //skip if even no. bytes
    Lodsb                  //get initial/odd byte
    Mov   EDX,EAX
    Clc
@Start:                    //begin checksum loop
    Lodsw                  //load a string word
    Adc   DX,AX            //sum := sum + S[i]
    Dec   ECX              //loop
    Jnz   @Start

    Mov   AX,DX

    Adc   AX,0
    Adc   AX,0
    Not   AX
    Jnz   @Done
    Not   AX
@Done:
    Pop   ESI
  end;



//function CountF(const Source: AnsiString; X:Char;Index:Integer): Integer;
//
//  {Count occurances of char X. from Index position forward to end of string.}
//
//  asm
//    Push  ESI              //save the good stuff
//    Push  EBX
//
//    Or    EAX,EAX          //zero source ?
//    Jz    @Exit            //yes, then bail
//
//    Mov   ESI,EAX          //source address
//    Xor   EAX,EAX          //default return (False)
//    Jecxz @Exit            //bail if zero start
//    Mov   EBX,[ESI-4]      //source length
//    Or    EBX,EBX          //zero ?
//    Jz    @Exit            //yes, then bail
//    Or    ECX,ECX
//    Js    @Reverse         //going backwards ?
//    Cmp   ECX,EBX          //Bail out if invalid start
//    Ja    @Exit
//    Dec   ECX              //zero based
//    Add   ESI,ECX          //start pointer
//    Sub   EBX,ECX          //remaining count
//    Mov   ECX,EBX          //put it in ECX
//    Jmp   @Begin
//@Reverse:
//    Neg   ECX
//    Cmp   ECX,EBX          //Bail out if invalid start
//    Ja    @Exit
//@Begin:
//    Xor   EBX,EBX          //zero our count register
//    Mov   AH,DL            //search char
//    Cld                    //insure we go forward
//@Next:
//    Lodsb                  //get source character
//    Cmp   AL,AH            //match ?
//    Jnz   @Skip            //no, then skip
//    Inc   EBX              //yes, then count it
//@Skip:
//    Dec   ECX
//    Jnz   @Next
//
//    Mov  EAX,EBX           //return count
//@Exit:
//    Pop  EBX
//    Pop  ESI
//
//  end;


//function CountR(const Source: AnsiString; X:Char; Index:Integer): Integer;
//
//  {Count occurances of char X. from Index position BACKWARD to start of string.}
//
//  asm
//    Neg   ECX
//    Jmp   CountF
//  end;


function CountF(const Source: AnsiString; X:Char;Index:Integer): Integer;
  {Count occurances of char X. from Index position forward to end of string.}
begin
  Result:=0;
  Index:=ScanC(Source,X,Index);
  while Index>0 do begin
    Inc(Result);
    Inc(Index);
    Index:=ScanC(Source,X,Index);
  end;
end;


function CountR(const Source: AnsiString; X:Char; Index:Integer): Integer;
  {Count occurances of char X. from Index position BACKWARD to start of string.}
begin
  Result:=0;
  Index:=ScanB(Source,X,Index);
  while Index<>0 do begin
    Inc(Result);
    Dec(Index);
    if Index>0 then Index:=ScanB(Source,X,Index);
  end;
end;


function LTrim(const Source:AnsiString;X:Char):AnsiString;
  {Trim specified char. X from the front of the string and return
   new, potentially shorter string.}
var
  I:Integer;
begin
  I:=ScanNC(Source,X); //first, scan to find amount to trim
  Result:=Copy(Source,I,Length(Source)-I+1);
end;


function RTrim(const Source:AnsiString;X:Char):AnsiString;

  {Trim specified char. X from the end of Source string and
   return new, potentially shorter string.}
var
  I:Integer;
begin
  I:=ScanNB(Source,X); //first, scan to find amount to trim
  Result:=Copy(Source,1,I);
end;


function CTrim(const Source:AnsiString;X:Char):AnsiString;

  {Trim specified char. X from both ends of Source string and
   return new, potentially shorter string.}
var
  I,J:Integer;
begin
  Result:='';
  I:=ScanNC(Source,X); //first, find amount to trim from front
  J:=ScanNB(Source,X); //next, find amount to trim from back
  if (I>0) or (J>0) then begin
    if I=0 then I:=1;
    if J=0 then J:=Length(Source);
    Result:=Copy(Source,I,J-I+1);  //trim out the middle
  end;
end;


procedure ReplaceC(var Source: AnsiString;const X,Y:Char);

  {Search and replace all occurances of char. X with char Y. To remove a
   character entirely, see DeleteC.}

begin
  UniqueString(Source);
  asm
    Push  ESI              //save the good stuff
    Push  EBX

    Mov   EAX,Source
    Or    EAX,EAX
    Jz    @Exit
    Mov   ESI,[EAX]        //source address
    Or    ESI,ESI          //zero source ?
    Jz    @Exit            //yes, then bail

    Mov   AH,X             //search char
    Mov   BL,Y             //replacement char
    Cmp   AH,BL            //same?
    Jz    @Exit            //yes, nothing to do but abort

    Mov   ECX,[ESI-4]      //source length
    Jecxz @Exit            //bail if zero

    Cld                    //insure we go forward
@Next:
    Lodsb                  //get source character
    Cmp   AL,AH            //match ?
    Jne   @Skip            //no, then skip
    Mov   [ESI-1],BL       //yes, then replace
@Skip:
    Dec   ECX
    Jnz   @Next

@Exit:
    Pop  EBX
    Pop  ESI

  end;
end;


procedure RevStr(var Source:AnsiString);

  {Reverse the characters first to last in the Source string.}

var
  I,J:Integer;
  cI:Char;
begin
  J:=Length(Source);
  if J=0 then Exit;
  for I:=1 to (Length(Source) Shr 1) do begin
    cI:=Source[I];
    Source[I]:=Source[J];
    Source[J]:=cI;
    Dec(J);
  end;
end;


procedure ISortA(var A:array of integer;const Cnt:Integer);

  {Sort an integer array into ascending, UNSIGNED order using CombSort, a
   generalized, much improved Bubble sort (see Byte, April 1991). Using
   assembler, this extremely simple, compact algorithm is reasonably fast.
   Cnt = Element Count (1 based) for partially filled array; use -1 for All.}

  {-> EAX - Pointer to array
      EDX - zero based element count
      ECX - # of elements to be sorted}

  asm
    Push  ESI              //save the good stuff
    Push  EDI
    Push  EBX
    Push  EBP

    Mov   EAX,A
    Or    EAX,EAX          //zero source ?
    Jz    @Exit            //yes, then bail
    Mov   ESI,EAX          //pointer to array
    Dec   ECX              //zero based count
    Cmp   ECX,EDX          //Cnt <= no. elements ?
    Jbe   @Start           //yes, then Start
    Mov   ECX,EDX          //otherwise, use actual count
@Start:
    Jecxz @Exit            //abort if only 1 element
    Cmp   ECX,$3FFFFFFF    //too big ?
    Ja    @Exit            //yes, then abort
    Mov   EDX,ECX          //initialize Gap
    Shl   EDX,2            //...in bytes
    Mov   EDI,ESI          //save array start
    Cld                    //insure we go forward
@Outer:
    Push  ECX              //save Size
    Mov   ESI,EDI          //restore start
    Shr   EDX,2            //Gap in elements
    Mov   EAX,3            //multiply Gap by 3/4
    Mul   EDX
    Shr   EAX,2
    Sub   ECX,EAX          //Size = Total-Gap
    Shl   EAX,2            //multiply Gap by 4 for
    Mov   EDX,EAX          //bytes
    Xor   EBP,EBP          //clear swap flag

@Inner:
    Lodsd                  //get I element
    Mov   EBX,[ESI+EDX]    //get J element
    Cmp   EBX,EAX          //J >= I?
    Jae   @Skip            //yes, then skip
    Mov   [ESI-4],EBX      //swap
    Mov   [ESI+EDX],EAX
    Or    EBP,1            //set flag
@Skip:
    Dec   ECX
    Jnz   @Inner

    Pop   ECX              //restore Size
    Or    EDX,EDX          //gap = 1 ?
    Jnz   @Outer           //no, then do it again
    Or    EBP,EBP          //swapped ?
    Jnz   @Outer           //yes, then do it again
@Exit:
    Pop   EBP              //restore the world
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;


procedure HyperSort(const ArrayPtr:Pointer;const Cnt:Integer);

  {Very fast hybrid sorting technique, intended for use with HyperString's dynamic
   integer arrays. Typically faster than Quicksort with better worst case performance.
   How is all this wonderment possible? Glad you asked<g>. By using more memory, the
   proverbial memory/speed tradeoff.  A parallel dynamic integer array 1/8 the
   size (Cnt/8) of the original is used to speed things up.}

var
  A,L:^TIntegerArray;
  D,I,J,K,M,N,Z:Integer;
begin
  asm
    Mov   EAX,ArrayPtr
    Mov   ECX,Cnt
    Xor   EDX,EDX
    Mov   N,EDX
    Mov   L,EDX
    Or    EAX,EAX          //zero source ?
    Jz    @Abort           //yes, then bail
    Mov   A,EAX
    Dec   ECX
    Jbe   @Abort
    Mov   N,ECX

    Push  ESI
    Push  EDI
    Push  EBX

    Mov   ESI,EAX          //pointer to array
    Mov   EDI,EAX          //pointer to max element
    Cld
    Lodsd
    Mov   EBX,EAX          //our min. element
    Mov   EDX,EAX          //our max. element
@Top:
    Lodsd
    Cmp   EAX,EBX          //>=min.?
    Jge   @Skip1           //yes, then skip
    Mov   EBX,EAX          //save min.
@Skip1:
    Cmp   EAX,EDX          //<=max.
    Jle   @Skip2           //yes, then skip
    Mov   EDX,EAX          //save max.
    Mov   EDI,ESI          //save pointer
    Sub   EDI,4
@Skip2:
    Dec   ECX
    Jnz   @Top

    Mov   Z,EBX            //min. valaue
    Mov   EAX,EDX
    Sub   EDX,EBX          //delta value
    Mov   D,EDX
    Mov   ESI,A
    XChg  EAX,[ESI]
    Mov   [EDI],EAX

    Pop   EBX
    Pop   EDI
    Pop   ESI
@Abort:
  end;

  if (N=0) OR (D=0) then Exit;
  if N>14 then begin
    M:=((N+1) Shr 3) Shl 2;
    try
      Dim(L,((M Shr 4)+1) Shl 4,True);  //allocate in paragraphs
      if L=nil then Exit;
      M:=(M Shr 2)-1;
    except
      Exit;
    end;

    asm
      Push  ESI
      Push  EDI
      Push  EBX

      Mov   ECX,N
      Inc   ECX
      Mov   ESI,A
      Mov   EDI,L
      Cld
    @S1:
      Lodsd

      Sub   EAX,Z    //Index(EAX)
      Mov   EBX,M
      Mul   EBX
      Mov   EBX,D
      Div   EBX

      Shl   EAX,2
      Mov   EBX,[EDI+EAX]
      Inc   EBX
      Mov   [EDI+EAX],EBX

      Dec   ECX
      Jnz   @S1

      Mov   ECX,M
      Mov   K,ECX
      Mov   ESI,L
      Lodsd
      Mov   EDI,ESI
    @S2:
      Mov   EBX,EAX
      Lodsd
      Add   EAX,EBX
      Stosd

      Dec   ECX
      Jnz   @S2

      Xor   EAX,EAX

      Mov   I,EAX
      Mov   J,EAX

      Mov   ESI,A
      Mov   EDI,L
    @S3:
      Mov   EAX,N
      Cmp   I,EAX       //I<N
      Jnl   @S4

      Mov   EAX,K
      Mov   ECX,J
      Cmp   ECX,[EDI+EAX*4] //J>=L[K]
      Jl    @S5

      Inc   ECX
      Mov   J,ECX
      Mov   EAX,[ESI+ECX*4]

      Sub   EAX,Z
      Mov   EBX,M
      Mul   EBX
      Mov   EBX,D
      Div   EBX

      Mov   K,EAX
    @S5:
      Mov   ECX,[ESI+ECX*4]  //H:=A[J]
    @S6:
      Mov   EBX,K
      Mov   EDX,[EDI+EBX*4]
      Cmp   J,EDX            //J<L[K]
      Jnl   @S3

      Inc   I

      Mov   EAX,ECX

      Sub   EAX,Z
      Mov   EBX,M
      Mul   EBX
      Mov   EBX,D
      Div   EBX

      Mov   K,EAX            //K:=Index(H);
      Shl   EAX,2
      Mov   EBX,[EDI+EAX]    //Dec(L[K])
      Dec   EBX
      Mov   [EDI+EAX],EBX

      XChg  ECX,[ESI+EBX*4]  //IntSwap(H,A[L[K]]);

      Jmp   @S6
    @S4:
      Pop   EBX
      Pop   EDI
      Pop   ESI
    end;
{--- Pascal reference version of the above, only about 10% slower
    for I:=0 to N do begin
      K:=Index(A[I]);
      Inc(L[K]);
    end;
    for K:=1 to M do L[K]:=L[K]+L[K-1];
    I:=0;
    J:=0;
    K:=M;

    while I<N do begin
      while J>=L[K] do begin
        Inc(J);
        K:=Index(A[J]);
      end;
      H:=A[J];
      while J<L[K] do begin
        K:=Index(H);
        Inc(I);
        Dec(L[K]);
        IntSwap(H,A[L[K]]);
      end;
    end;
}
    Dim(L,0,False);
  end;

  asm
    Mov   EAX,A
    Mov   ECX,N

    Push  ESI
    Push  EDI
    Push  EBX

    Or    EAX,EAX
    Jz    @Done
    Jecxz @Done

    Mov   ESI,EAX
    Mov   EBX,EAX
    Cld
    Lodsd
@L1:
    Mov   EDX,EAX
    Lodsd
    Cmp   EAX,EDX
    Jl    @L2
    Dec   ECX
    Jnz   @L1

    Jmp   @Done
@L2:
    Sub   ESI,4
    Mov   EDI,ESI
@L3:
    Mov   EDX,[EDI-4]
    Cmp   EAX,EDX
    Jge   @L4
    Mov   [EDI],EDX
    Sub   EDI,4
    Cmp   EDI,EBX
    Jnz   @L3
@L4:
    Mov   [EDI],EAX
    Lodsd
    Dec   ECX
    Jnz   @L1

@Done:
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;

end;



procedure ISortD(var A:array of integer;const Cnt:Integer);

  {Sort an integer array into descending, UNSIGNED order using CombSort,
   a generalized, much improved Bubble sort (see Byte, April 1991). Using
   assembler, this extremely simple, compact algorithm is reasonably fast.
   Cnt = Element Count (1 based) for partially filled array; use -1 for All.}

  {-> EAX - Pointer to array
      EDX - zero based element count
      ECX - # of elements to be sorted}

  asm
    Push  ESI              //save the good stuff
    Push  EDI
    Push  EBX
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @Exit            //yes, then bail
    Mov   ESI,EAX          //pointer to array
    Dec   ECX              //zero based count
    Cmp   ECX,EDX          //Cnt <= no. elements ?
    Jbe   @Start           //yes, then Start
    Mov   ECX,EDX          //otherwise, use actual count
@Start:
    Jecxz @Exit            //abort if only 1 element
    Cmp   ECX,$3FFFFFFF    //too big ?
    Ja    @Exit            //yes, then abort
    Mov   EDX,ECX          //initialize Gap
    Shl   EDX,2            //...in bytes
    Mov   EDI,ESI          //save array address
    Cld                    //insure we go forward
@Outer:
    Push  ECX              //save Size
    Mov   ESI,EDI          //restore address
    Shr   EDX,2            //Gap in elements
    Mov   EAX,3            //multiply Gap by 3/4
    Mul   EDX
    Shr   EAX,2
    Sub   ECX,EAX          //Size = Total-Gap
    Shl   EAX,2            //multiply Gap by 4 for
    Mov   EDX,EAX          //bytes
    Xor   EBP,EBP          //clear swap flag

@Inner:
    Lodsd                  //get I element
    Mov   EBX,[ESI+EDX]    //get J element
    Cmp   EBX,EAX          //J <= I?
    Jbe   @Skip            //yes, then skip
    Mov   [ESI-4],EBX      //swap
    Mov   [ESI+EDX],EAX
    Or    EBP,1            //set flag
@Skip:
    Dec   ECX
    Jnz   @Inner

    Pop   ECX              //restore Size
    Or    EDX,EDX          //gap = 1 ?
    Jnz   @Outer           //no, then do it again
    Or    EBP,EBP          //swapped ?
    Jnz   @Outer           //yes, then do it again
@Exit:
    Pop   EBP              //restore the world
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;


function IntSrch(const A:array of Integer;const Target,Cnt:Integer):Integer;

  {UNSIGNED binary search of an integer array.  Array is assumed to be
   in ascending sorted order.  Cnt = Number of elements to search (supports
   partially filled arrays, -1 = All elements).

   Returns: Element offset of match if found; otherwise,-Expected index}

begin
  iMn:=0;
  iMx:=High(A);                        //get highest array element
  Result:=-1;
  if (iMx<0) OR (Cnt=0) then Exit;     //abort if nothing to search
  if (Cnt>0) AND (Cnt<iMx) then iMx:=Cnt-1;
  repeat
    ITry:=(iMx+iMn) Shr 1;
    if A[ITry]=Target then begin
      Result:=ITry;
      Exit;
    end;
    if UnSignedCompare(A[ITry],Target) then iMx:=ITry-1 else iMn:=ITry+1;
  until iMx<iMn;
  if ITry=0 then Result:=-1 else Result:=-ITry;
end;


procedure StrSort(var A:array of AnsiString; const Cnt:Integer);

  {Fast, "semi-sort" (uses first 2 char. only) of a string array into
   ascending order. This is "good enough" in many cases.  In any case, a
   semi-sorted array can be searched much faster (see StrSrch) than a
   non-sorted one. The number of elements to be sorted must be provided in
   Cnt (-1 = All).  Any blank elements are up front after sorting.}

  {-> EAX - Pointer to array
      EDX - element count
      ECX - # of elements to be sorted}

  asm
    Push  ESI              //save the good stuff
    Push  EDI
    Push  EBX
    Push  EBP

    Or    EAX,EAX          //zero source ?
    Jz    @Exit            //yes, then bail
    Mov   EDI,EAX          //pointer to array
    Or    EDX,EDX          //zero elements ?
    Jz    @Exit            //yes, then abort
    Cld                    //insure we go forward
    Dec   EDX              //zero based element count
    Jz    @Exit            //abort if nothing to sort (1 element)
    Cmp   ECX,EDX          //Cnt greater than no. elements ?
    Jae   @Outer           //yes, then skip
    Dec   ECX              //zero base the sort count
    Mov   EDX,ECX          //use requested count

@Outer:
    Mov   EBX,[EDI]        //pick initial min. value
    Mov   ESI,EDI
    Add   ESI,4            //set select pointer to next element
    Mov   EBP,ESI          //pointer to min. value (actually + 1 element)
    Mov   ECX,EDX          //elements to scan for new minimum (Total - 1)
    Push  EDX              //save the count
    Or    EBX,EBX
    Jz    @Swap
    Mov   EAX,[EBX-4]      //length of selected element
    Mov   BX,[EBX]         //first 2 chars. of element
    Or    EAX,EAX
    Cmp   EAX,2            //less than 2 chars ?
    Jae   @Inner           //no, then continue
    Xor   BH,BH
@Inner:
    Lodsd                  //get pointer to next test element
    Or    EAX,EAX          //check for null pointer
    Jz    @L2
    Mov   EDX,[EAX-4]      //element length
    Mov   AX,[EAX]         //first 2 char. of element
    Cmp   EDX,2            //less than 2 ?
    Jae   @L1              //no, then continue
    Xor   AH,AH
@L1:
    Cmp   AL,BL            //less than current min.
    Ja    @Next            //no, then skip
    Cmp   AH,BH
    Ja    @Next
@L2:
    Mov   EBP,ESI          //yes,point to this element as min.
    Mov   BX,AX
@Next:
    Dec   ECX
    Jnz   @Inner

@Swap:
    Sub   EBP,4            //EBP points just ahead of new min. element
    Mov   EBX,[EBP]        //swap current element with new min.
    Mov   EAX,[EDI]
    Mov   [EDI],EBX
    Mov   [EBP],EAX
    Add   EDI,4            //move to next element in array
    Pop   EDX
    Dec   EDX              //decrement remaining element count
    Jnz   @Outer           //do it all again if necessary
@Exit:
    Pop   EBP              //restore the world
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;


function StrSrch(var A:array of AnsiString;const Target:AnsiString; Cnt:Integer):Integer;

  {Binary search of string array for Target string.  Array is assumed to
   be in "semi-sorted" order as provided by StrSort.  Cnt = Element count
   for a partially filled array; -1 = Full array.

   Returns: Element offset of match if found; otherwise,-Expected index

   NOTE: Target string must be at least 2 chars in length. A "match" occurs
         if the leftmost part of any element is the same as Target.}

var
  T1,T2:AnsiString;
  I:Integer;
begin
  iMn:=0;
  iMx:=High(A);                                 //get highest array element
  I:=Length(Target);
  Result:=-1;
  if (iMx<0) OR (I<2) OR (Cnt=0) then Exit;    //abort if nothing to search
  if (Cnt>0) AND (Cnt<iMx) then iMx:=Cnt-1;
  T1:=LStr(Target,2);
  repeat
    ITry:=(iMx+iMn) DIV 2;
    T2:=Copy(A[ITry],1,2);
    if T2=T1 then begin
      while (T2=T1) AND (ITry>0) do begin   //back up to first partial match
        ITry:=ITry-1;
        T2:=Copy(A[ITry],1,2);
      end;
      if ITry>0 then begin
        ITry:=ITry+1;
        T2:=Copy(A[ITry],1,2);
      end;
      while (T2=T1) AND (ITry<iMx) do begin //search forward for match
        if Copy(A[ITry],1,I)=Target then begin
          Result:=ITry;
          Exit;
        end;
        Inc(ITry);
        T2:=Copy(A[ITry],1,2);
      end;
      if ITry=0 then Result:=-1 else Result:=-ITry;
      Exit;
    end;
    if T2<T1 then iMn:=ITry+1 else iMx:=ITry-1;
  until iMx<iMn;
  if ITry=0 then Result:=-1 else Result:=-ITry;
end;


procedure CopyDown;
  {Move 4 byte array elements}
  asm
    Push  ESI              //save the good stuff
    Push  EDI

    Or    EAX,EAX          //zero source ?
    Jz    @Exit            //yes, then bail
    Mov   EDI,EAX          //pointer to array
    Xor   EAX,EAX          //default return
    Dec   EDX              //zero based
    Cmp   ECX,EDX          //Target > Count
    Ja    @Exit            //yes, then abort
    Jz    @Done            //if equal, nothing to do
    XChg  EDX,ECX
    Sub   ECX,EDX          //use remaining
    Shl   EDX,2            //offset = Target * 4
    Add   EDI,EDX          //add to pointer
    Mov   ESI,EDI          //setup read pointer
    Add   ESI,4            //...just beyond write
    Mov   EDX,[EDI]        //save the Target element

    Cld                    //insure we go forward
    rep   movsd            //move the elements up
    mov   EAX,EDX          //put Target at end
    Stosd
@Done:
    Mov   EAX,True         //return True
@Exit:
    Pop   EDI
    Pop   ESI
  end;


function IntDelete(var A:array of Integer; const Target,Cnt:Integer):Boolean;
  asm
    Or    EDX,EDX          //zero elements ?
    Jz    @Exit            //yes, then abort
    Cmp   EDX,Cnt          //Total<=Cnt
    Jbe   @L1              //yes, then use total
    Mov   EDX,Cnt          //use requested count
@L1:
    Call  CopyDown
    Jmp   @Done
@Exit:
    Xor   EAX,EAX
@Done:
  end;


function StrDelete(var A:array of AnsiString; const Target,Cnt:Integer):Boolean;

  {Safe, "ring copy" of array elements downward (to lower index) starting at
   Target element specified as zero-based offset from base:
                           Target = Index - Base
   Obviously, Target = element index if array is zero based.  Cnt = Total
   active element count (prior to the deletion); -1 = Full array.

   Returns: True if successful. Eements after Target shifted downward to next
            lower index, A[Cnt-1] = A[Target].

   Note:  The last element (A[Cnt-1]) can be deleted if desired; however, it
          is generally more convenient and efficient timewise to simply
          leave in place and overwrite later when/if a new element is added.}

  {-> EAX - Pointer to array
      EDX - element count
      ECX - Target}
  asm
    Or    EDX,EDX          //zero elements ?
    Jz    @Exit            //yes, then abort
    Cmp   EDX,Cnt          //Total<=Cnt
    Jbe   @L1              //yes, then use total
    Mov   EDX,Cnt          //use requested count
@L1:
    Call  CopyDown
    Jmp   @Done
@Exit:
    Xor   EAX,EAX
@Done:
  end;



procedure CopyUp;
  asm
    Push  ESI              //save the good stuff
    Push  EDI

    Or    EAX,EAX          //zero source ?
    Jz    @Exit            //yes, then bail
    Mov   EDI,EAX          //pointer to array
    Xor   EAX,EAX          //default return
    Cmp   ECX,EDX          //Target > Count
    Ja    @Exit            //yes, then abort
    Jz    @Done            //nothing to do
    XChg  ECX,EDX          //put count in ECX
    Mov   EAX,ECX          //and EAX
    Sub   ECX,EDX          //use remaining
    Shl   EAX,2            //offset = Length * 4
    Add   EDI,EAX          //add to pointer
    Mov   ESI,EDI          //setup read pointer
    Sub   ESI,4            //...just behind write
    Mov   EDX,[EDI]        //save the Target element

    Std                    //insure we go backward
    rep   movsd            //move the elements down
    mov   EAX,EDX          //put end at Target
    Stosd
@Done:
    Mov   EAX,True          //return True
@Exit:
    Pop   EDI
    Pop   ESI
    Cld
  end;


function IntInsert(var A:array of Integer; const Target,Cnt:Integer):Boolean;
  asm
    Or    EDX,EDX          //zero elements ?
    Jz    @Exit            //yes, then abort
    Cmp   EDX,Cnt         //Total<=Cnt ?
    Jbe   @Exit           //yes, then abort
    Mov   EDX,Cnt         //use requested count
    Call  CopyUp
    Jmp   @Done
@Exit:
    Xor   EAX,EAX
@Done:
  end;


function StrInsert(var A:array of AnsiString; const Target,Cnt:Integer):Boolean;

  {Safe,"ring copy" of array elements upward (to next higher index) starting at
   Target element specified as zero-based offset from base:
                           Target = Index - Base
   Obviously, Target = element index if array is zero based.  Cnt = Current
   total active element count; before inserting.  Must be less than array size
   (Array Size = High(A)-Low(A)+1).

   Returns: True if Cnt<(Array size). Elements from Target forward are shifted
            upward to next higher index, A[Target] = A[Cnt].}

  {-> EAX - Pointer to array
      EDX - element count
      ECX - Target}
  asm
    Or    EDX,EDX         //zero elements ?
    Jz    @Exit           //yes, then abort
    Cmp   EDX,Cnt         //Total<=Cnt ?
    Jbe   @Exit           //yes, then abort
    Mov   EDX,Cnt         //use requested count
    Call  CopyUp
    Jmp   @Done
@Exit:
    Xor   EAX,EAX
@Done:
  end;
{
  asm
    Push  ESI              //save the good stuff
    Push  EDI

    Or    EAX,EAX          //zero source ?
    Jz    @Exit            //yes, then bail
    Mov   EDI,EAX          //pointer to array
    Xor   EAX,EAX          //default return
    Or    EDX,EDX          //zero elements ?
    Jz    @Exit            //yes, then abort
    Cmp   EDX,Cnt          //Total<=Cnt ?
    Jbe   @Exit            //yes, then abort
    Mov   EDX,Cnt          //use requested count
    Cmp   ECX,EDX          //Target > Count
    Ja    @Exit            //yes, then abort
    XChg  ECX,EDX          //put count in ECX
    Mov   EAX,ECX          //and EAX
    Sub   ECX,EDX          //use remaining
    Shl   EAX,2            //offset = Length * 4
    Add   EDI,EAX          //add to pointer
    Mov   ESI,EDI          //setup read pointer
    Sub   ESI,4            //...just behind write
    Mov   EDX,[EDI]        //save the Target element

    Std                    //insure we go backward
    rep   movsd            //move the elements down
    mov   EAX,EDX          //put end at Target
    Stosd
@Done:
    Mov   EAX,-1           //return True
@Exit:
    Pop   EDI
    Pop   ESI
    Cld
  end;
}


procedure StrSwap(var S1,S2:AnsiString);

  {Quickly exchange the value of 2 strings.}

  asm
    mov   ECX,[EAX]
    Xchg  ECX,[EDX]
    Mov   [EAX],ECX
  end;


function  WeekNum(const TDT:TDateTime; FirstDayofWeek:Integer):Word;

  {Calculate a week index (0-52) for a given date. Week starts on
   specified FirstDayofWeek (1-7, Sunday-Saturday). Week 0 is the first week
   ending in the new year.

   NOTE: Some years have 53 weeks.}

var
  I:Integer;
  Y,M,D:Word;
  dtTmp:TDateTime;
begin
  Result:=99;
  if (FirstDayofWeek<1) OR (FirstDayofWeek>7) then Exit;
  DecodeDate(TDT,Y,M,D);
  if FirstDayofWeek>1 then Dec(FirstDayofWeek) else FirstDayofWeek:=7;
  I:=DayOfMonth(Y,1,FirstDayofWeek,1); //first week end day
  dtTmp:=EnCodeDate(Y,1,I)-6;     //start of Week 0
  Result:=Trunc(TDT-dtTmp) DIV 7; //weeks since Week 0
  if Result>=52 then begin        //end of year is a special case
    I:=FirstDayofWeek-DayOfWeek(TDT);
    if I<0 then Inc(I,7);         //remaining days in week
    if I>(31-D) then Result:=0;   //greater than remains in month ?
  end;
end;


function  ISOWeekNum(const TDT:TDateTime):Word;

  {Calculate a week-of-the-year index (0-52) for a given date per ISO 8601.
   Week 0 is the week containing January 4 or the first Thursday.  Monday is
   first day of week.

   NOTE: Occasionally, a year will have 53 weeks (1998 for example). }

var
  I:Integer;
  Y,M,D:Word;
  dtTmp:TDateTime;
begin
  DecodeDate(TDT,Y,M,D);
  repeat
    dtTmp:=EnCodeDate(Y,1,4);
    Dec(Y)
  until dtTmp<=TDT;
  I:=DayOfWeek(dtTmp);
  if I=1 then I:=6 else I:=I-2;
  dtTmp:=dtTmp-I;
  Result:=Trunc(TDT-dtTmp) DIV 7;
  if (Result=52) and (I<6) then Result:=0;
end;


function  TDT2IDT(const TDT:TDateTime):IDateTime;  //TDateTime to IDateTime
begin
  Result:=Trunc(TDT * Ticks);
end;

function  IDT2TDT(const IDT:IDateTime):TDateTime; //IDateTime to TDateTime
begin
  Result:=(IDT DIV Ticks)+((IDT MOD Ticks)/Ticks);
end;

function  StrToITime(const Source:AnsiString):IDateTime;  //String to IDateTime
begin
  Result:=Trunc(StrToTime(Source) * Ticks);
end;

function  StrToIDate(const Source:AnsiString):IDateTime;  //String to IDateTime
begin
  Result:=Trunc(StrToDate(Source)) * Ticks;
end;

function  StrToIDateTime(const Source:AnsiString):IDateTime;  //String to IDateTime
begin
  Result:=TDT2IDT(StrToDateTime(Source));
end;

function  IDateToStr(const IDT:IDateTime):AnsiString;
begin
  Result:=DateToStr(IDT/Ticks);
end;

function  ITimeToStr(const IDT:IDateTime):AnsiString;
begin
  Result:=TimeToStr((IDT MOD Ticks)/Ticks);
end;

function  ITimeTo2460(IDT:IDateTime):AnsiString;
var
  NegFlg:Boolean;
begin
  NegFlg:=IDT<0;
  if NegFlg then IDT:=-IDT;
  Result:=' '+LAdd(IntToStr(IDT DIV 60),'0',2)+TimeSep+LAdd(IntToStr(IDT MOD 60),'0',2);
  if NegFlg then Result[1]:='-';
end;


function  IDateTimeToStr(const IDT:IDateTime):AnsiString;
begin
  Result:=DateTimeToStr(IDT2TDT(IDT));
end;

function  EncodeITime(const D,H,M,S:Word):IDateTime; //Hrs,Min to IDateTime
begin
  Result:=(D * Ticks) + ((H*60)+M);
  If S>=30 then Inc(Result);
end;

procedure DecodeITime(const IDT:IDateTime; var D,H,M:Word);
begin
  D:=IDT DIV Ticks;
  M:=IDT MOD Ticks;
  H:=M DIV 60;
  M:=M MOD 60;
end;

function  EncodeIDate(const Y,M,D:Word):IDateTime;
begin
  Result:=TDT2IDT(EncodeDate(Y,M,D));
end;

procedure DecodeIDate(const IDT:IDateTime; var Y,M,D:Word);
begin
  DecodeDate(IDT2TDT(IDT),Y,M,D);
end;


function  RoundITime(const IDT:IDateTime;Mns:Word):IDateTime;
  {Rounds an IDateTime variable in native format to the nearest
   minutes (1,3,5,etc.). Mns must be an integer divisor of 60.}
var
  I,J:Integer;
begin
  if (60 MOD Mns)=0 then begin
    J:=IDT DIV 60;
    I:=(((IDT MOD 60) Shl 1)+Mns) Shr 1;
    Result:=(J*60)+I;
  end else Result:=IDT;
end;


function  RndToSecs(const DT:TDateTime;Secs:Word):TDateTime;
  {Rounds DT to the nearest Secs using "traditional" rounding.}
var
  T:TDateTime;
begin
  T:=Secs/172800;
  if DT<0 then Result:= DT-T else Result:=DT+T;
  T:=T*2;
  Result:=Trunc(Result/T)*T;
end;


function GetUser: AnsiString;

  {Returns the ID for the current Windows's user. Returns empty string ('') if
   function fails.}

begin
  dwI:=MAX_PATH;
  SetLength(Result,MAX_PATH+1);
  if GetUserName(PChar(Result),dwI) then
    SetLength(Result,StrLen(PChar(Result)))
  else SetLength(Result,0);
end;


function GetNetUser: AnsiString;

  {Returns the network ID for the current system user. Returns null string ('') if
   function fails.}

begin
  dwI:=MAX_PATH;
  SetLength(Result,MAX_PATH+1);
  if WNetGetUser(nil,PChar(Result),dwI)=NO_ERROR then
    SetLength(Result,StrLen(PChar(Result)))
  else SetLength(Result,0);
end;


function GetComputer: AnsiString;

  {Returns the name string for the current system. Returns empty string ('') if
   function fails.}

begin
  dwI:=MAX_PATH;
  SetLength(Result,MAX_PATH+1);
  if GetComputerName(PChar(Result),dwI) then
    SetLength(Result,dwI)
  else SetLength(Result,0);
end;


function GetLocalIP:AnsiString;
var
  W: TWSAData;
  P: PHostEnt;
  A: array[0..3] of Byte;
begin
  Result:='';
  if IsNetWork then begin
    WSAStartup($0101, W);
    try
      P:= GetHostByName(PChar(GetComputer));
      if (P<>nil) and (P.h_length=4) then begin
        Move(P^.h_addr_list^^,A,P.h_length);
        Result := format('%d.%d.%d.%d',[A[0],A[1],A[2],A[3]]);
      end;
    finally
      WSACleanup;
    end;
  end;
end;




function GetDrives: AnsiString;

  {Returns a string containing all valid drive letters.  Drives identified
   as removable are lower case, all others are upper.}
var
  I,J:Integer;
begin
  Result:='';
  I:=GetLogicalDrives;
  if I<>0 then begin
    for J:=65 to 90 do
      if TestBit(I,J-65) then
        if GetDriveType(PChar(Chr(J)+':\'))=DRIVE_REMOVABLE then
          Result:=Result+Chr(J+32)
        else Result:=Result+Chr(J);
  end;
end;


function  GetDisk(const Drv:Char; var CSize,Available,Total:DWord):Boolean;

  {Returns disk stats; cluster size, available and total clusters.}

begin
  Result:=GetDiskFreeSpace(PChar(Drv+':\'),dwI,dwJ,Available,Total);
  if Result then CSize:=dwI*dwJ;
end;


function  GetVolume(const Drv:Char; var Name,FSys:AnsiString; var S:DWord):Boolean;

  {Returns volume name, file system and serial number for a given drive.}

var
  I,J:DWord;
begin
  SetLength(Name, MAX_PATH);
  SetLength(FSys, MAX_PATH);
  Result:= GetVolumeInformation(PChar(Drv+':\'), PChar(Name), MAX_PATH,
                                @S, I, J, PChar(FSys), MAX_PATH);
  if Result then begin
    SetLength(Name, StrLen(PChar(Name)));
    SetLength(FSys, StrLen(PChar(FSys)));
  end else begin
    SetLength(Name,0);
    SetLength(FSys,0);
    S:=0;
  end;
end;



function GetWinDir: AnsiString;

  {Returns the Windows directory.}

begin
  SetLength(Result,MAX_PATH+1);
  dwI:=GetWindowsDirectory(PChar(Result), MAX_PATH);
  SetLength(Result,dwI);
end;


function GetSysDir: AnsiString;

  {Returns the Windows\System directory.}

begin
  SetLength(Result,MAX_PATH+1);
  dwI:=GetSystemDirectory(PChar(Result), MAX_PATH);
  SetLength(Result,dwI);
end;


function GetTmpDir: AnsiString;

  {Returns the preferred directory for temporary files.}

begin
  SetLength(Result,MAX_PATH+1);
  dwI:=GetTempPath(MAX_PATH,PChar(Result));
  SetLength(Result,dwI);
end;


function GetExeDir: Ansistring;
  {Returns the directory from whence the current .EXE was loaded.}
var
  S:AnsiString;
  I:Integer;
begin
  Setlength(S,MAX_PATH);
  I:=GetModuleFileName(0,PChar(S),MAX_PATH);
  SetLength(S,I);
  Result:=ExtractFilePath(S);
end;


function GetDOSName(const LongName:AnsiString): AnsiString;

  {Returns the short, DOS equivalent for a long file name.}

begin
  SetLength(Result,MAX_PATH+1);
  if GetShortPathName(PChar(LongName),PChar(Result),MAX_PATH)>0 then
    SetLength(Result,StrLen(PChar(Result)))
  else SetLength(Result,0);
end;


function GetWinName(const FileName:AnsiString): AnsiString;
  {Returns the long Windows filename for a file.}
var
  Hdl:THandle;
  SearchRec:TWin32FindData;
begin
  Setlength(Result,0);
  Hdl:=FindFirstFile(PChar(FileName),SearchRec);
  if Hdl<>INVALID_HANDLE_VALUE then begin
    Result:=SearchRec.cFileName;
    Windows.FindClose(Hdl);
  end;
end;


function UnSignedCompare(const X,Y:Integer):Boolean;

  {Does a full 32 bit unsigned integer compare for sorting and searching
   purposes. Returns True if X>Y (exchange required for ascending order)}

  asm
    Sub   EAX,EDX
    Jnc   @OK
    Xor   EAX,EAX
    Jmp   @Done
@OK:
    Mov   EAX,True
@Done:
  end;


function LoBit(const X:Integer):Integer;

  {Scans an integer for lowest non-zero bit.
   Returns:    -1, if X=0 (all bits zero )
             bit#, (0-31) of lowest 1 bit)}

  asm
    Mov   ECX,EAX
    Mov   EAX,-1
    Bsf   EAX,ECX
  end;


function HiBit(const X:Integer):Integer;

  {Scans an integer for highest non-zero bit.}

  asm
    Mov   ECX,EAX
    Mov   EAX,-1
    Bsr   EAX,ECX
  end;


procedure IntSwap(var I1,I2:Integer);

  {Quickly exchange the value of 2 Integers.}

  asm
    Mov   ECX,[EAX]
    Xchg  ECX,[EDX]
    Mov   [EAX],ECX
  end;


procedure WordSwap(var W1,W2:Word);

  {Quickly exchange the value of 2 Words.}

  asm
    Mov   CX,[EAX]
    Xchg  CX,[EDX]
    Mov   [EAX],CX
  end;


function RotL(const X,Cnt:Integer):Integer;

  {Rotate integer X left by the number of bits specified in Cnt.}

  asm
    Mov   CL,DL
    Rol   EAX,CL
  end;


function RotR(const X,Cnt:Integer):Integer;

  {Rotate integer X right by the number of bits specified in Cnt.}

  asm
    Mov   CL,DL
    Ror   EAX,CL
  end;


function TestBit(const X,Cnt:Integer):Boolean;

  {Test the Cnt bit (least significant = 0) of integer X.
   Returns True if bit is set (1);otherwise, False}

  asm
    Bt    EAX,EDX
//*    Bt    EAX,DL
    Jnc   @Done
    Mov   DH,True
@Done:
    Mov   AL,DH
  end;


procedure SetByteBit(var X:Byte;Cnt:Byte);
  {Set the Cnt bit (least significant = 0) of byte X.}
  asm
    Mov   CL,[EAX]
    Bts   ECX,EDX
//*   Bts   ECX,DL
    Mov   [EAX],CL
  end;

procedure ClrByteBit(var X:Byte;Cnt:Byte);
  {Clear the Cnt bit (least significant = 0) of byte X.}
  asm
    Mov   CL,[EAX]
    Btr   ECX,EDX
//*    Btr   ECX,DL
    Mov   [EAX],CL
  end;

procedure SetBit(var X:Integer;Cnt:Byte);
  {Set the Cnt bit (least significant = 0) of integer X.}
  asm
    Mov   ECX,[EAX]
    Bts   ECX,EDX
//*    Bts   ECX,DL
    Mov   [EAX],ECX
  end;

procedure ClrBit(var X:Integer;Cnt:Byte);
  {Clear the Cnt bit (least significant = 0) of integer X.}
  asm
    Mov   ECX,[EAX]
    Btr   ECX,EDX
//*    Btr   ECX,DL
    Mov   [EAX],ECX
  end;


function MetaPhone(const Name : AnsiString) : Integer;
  {Returns Metaphone phonetic spelling; similar to Soundex but more
   selective.  Original algorithm by Lawrence Philips, 'Computer Language',
   Dec. 1990.  There are a number of problems with this article ---
   discrepancies between code and text; some code is clearly missing. The
   implementation here draws from a number of public domain sources including
   that of Gary Parker, 'C Gazette', June/July, 1991.

   Returns:  Integer representing phonetic spelling if length >=2;
             otherwise; 0.  Integers are faster and easier to compare. If
             you prefer the more traditional string representation,apply
             IntToChr to the function resultant.

   MetaPhone constants:  B X S K J T F H L M N P R O(zero = 'th') W Y}

const
  Vowels = [ 'A', 'E', 'I', 'O', 'U' ];
  FrontV = [ 'E', 'I', 'Y' ];
  VarSon = [ 'C', 'S', 'P', 'T', 'G' ];
  First2 : AnsiString = 'WH PN AE KN GN WR';
  MaxOut = 4;  //output length can be increased by changing this; however,
               //resultant type will also need to be changed
var
  Instr,Work : AnsiString;
  I,P,L : Integer;
  Last, This, Next, NNext : Char;

  procedure AddChr(const X:Char);
  begin
    Inc(I);
    if I<=MaxOut then Work[I]:=X;
  end;

begin

  Result:=0;
  if Length(Name)<2 then Exit;

  Instr:=UpperCase(Name);
  L:=MakeAlpha(Instr);  //remove non-alpha
  if L<2 then Exit;
  Setlength(Instr,L);

  { Remove first if word starts with certain two char combos }
  Work:=LStr(Instr,2);
  P:=Pos(Work,First2);
  if Instr[1] = 'X' then
    Instr[1]:= 'S'
  else if P>0 then begin
    if P=1 then Instr[2]:='W';
    Instr:=CStr(Instr,2,L);
  end;

  I:=0;
  Work:=DupChr(#32,MaxOut);
  if (Instr[1] in Vowels) then begin  //add to result if first is vowel
    AddChr(Instr[1]);
    Instr := CStr(Instr,2,L);
  end;

  P := 1;
  This := #0;
  Next := #255;
  L:=Length(Instr);

  while (P<=L) and (I<MaxOut) do begin
    if (This <> 'C') and (This = Next) then Inc(P);  //skip dups except for C
    Last:=This;
    This := Instr[P];
    if P < L then Next := Instr[P + 1] else Next := #0;
    if Succ(P) < L then NNext := Instr[P + 2] else NNext := #0;

    case This of

    'B' : if (P <> L) and (Last <> 'M') then AddChr('B');

    'C' : if (Next = 'H') or ((Next = 'I') and (NNext = 'A')) then AddChr('X')
          else if (Next in FrontV) and (Last <> 'S') then AddChr('S')
          else AddChr('K');

    'D' : if (Next = 'G') and (NNext in FrontV) then AddChr('J') else AddChr('T');

    'F', 'J', 'L', 'M', 'N', 'R' : AddChr(This);

    'G' : if ((Next = 'H') and ((NNext <> #0) or (NNext in Vowels))) or
             ((Next = 'N')  and (NNext = 'E')) or
             ((Last = 'D')  and (Next in FrontV)) then
          else if (Next in FrontV) and (Last <> 'G') then AddChr('J')
          else AddChr('K');

    'H' : if not(((Last in Vowels) and (Next in Vowels)) or (Last in Varson)) then
            AddChr('H');

    'K' : if (Last <> 'C') then AddChr('K');

    'P' : if (Next = 'H') then AddChr('F') else AddChr('P');

    'Q' : AddChr('K');

    'S' : if (Next = 'H') or ((Next = 'I') and ((NNext = 'O') or (NNext = 'A'))) then
          AddChr('X') else AddChr('S');

    'T' : if ((Next = 'I') and ((NNext = 'O') or (NNext = 'A'))) then AddChr('X')
          else if (Next = 'H') then AddChr('0')
          else if not ((Next = 'C') and (NNext = 'H')) then AddChr('T');

    'V' : AddChr('F');

    'W', 'Y' : if (Next in Vowels) then AddChr(This);

    'X' : begin
            AddChr('K');
            AddChr('S');
          end;

    'Z' : AddChr('S');

    end;
    Inc(P);
  end;
  Result:=ChrToInt(Work);
end;


function NumToWord(const Source:AnsiString;Money:Boolean):AnsiString;

  {Returns an English word translation of a numeric string.  'Money' is a
   flag indicating that 'Dollars' and 'Cents' units are to be included.}

var
  Num,Frc,Units,Minus,Total,Temp:AnsiString;
  I,J,X,Y,Z,L,M,N:Integer;
const
  Ones  = ' One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Eleven, Twelve, Thirteen, Fourteen, Fifteen, Sixteen, Seventeen, Eighteen, Nineteen';
  Tens  = ' Ten, Twenty, Thirty, Forty, Fifty, Sixty, Seventy, Eighty, Ninety';
  Powers= ' Thousand, Million, Billion, Trillion';

  function GetTok(const Source:AnsiString;X:Integer):AnsiString;
  begin
    Result:='';
    if X>0 then begin
      I:=ScanCC(Source,',',X-1)+1;
      J:=ScanCC(Source,',',X);
      if J=0 then J:=Length(Source)+1;
      Result:=Copy(Source,I,J-I);
    end;
  end;

begin

  Num:=Source;
  Compact(Num);
  if Num[1]='-' then Minus:='Negative ';
  DeleteC(Num,'-');
  DeleteC(Num,ThouSep);
  L:=Compact(Num);

  if (L=0) or (L > 15) THEN Exit;

  if Money then Units:=' Dollars';
  X:=Pos(DecSep,Num);
  if (X>0) and (X<L) then begin
    Frc:=Copy(Num,X+1,2);
    if Money then begin
       RPad(Frc,'0',2);
       Frc:=' and ' + Frc+' Cents';
    end else begin
      Z:=StrToInt(Frc);
      if Z<20 then
        Frc:=GetTok(Ones,Z)
      else begin
        Frc:=GetTok(Tens,Z DIV 10);
        Frc:=Frc+GetTok(Ones,Z MOD 10);
      end;
      Frc:=' pt'+Frc;
    end;
    Num:=LStr(Num,X-1);
    L:=X-1;
  end;
  Y:=3;
  N:=0;

  while L>0 do begin
    if L<3 then Y:=L;
    Z:=StrToInt(Copy(Num,L-Y+1,Y));
    L:=L-Y;

    case Z of
      1..19:
        Temp:=GetTok(Ones,Z);
      20..99:
      begin
        Temp:=GetTok(Tens,Z DIV 10);
        Temp:=Temp+GetTok(Ones,Z MOD 10);
      end;
      100..999:
      begin
        Temp:=GetTok(Ones,Z DIV 100)+' Hundred';
        M:=Z MOD 100;
        if M<20 then begin
          Temp:=Temp+GetTok(Ones,M);
        end else begin
          Temp:=Temp+GetTok(Tens,M DIV 10);
          Temp:=Temp+GetTok(Ones,M MOD 10);
        end;
      end;
    end;
    if Z>0 then begin
      Temp:=Temp+GetTok(Powers,N);
      Total:=Temp+Total;
    end;
    Inc(N);
  end;
  if Length(Total)=0 then Total:='Zero';
  Result:=Minus+TrimLeft(Total)+Units+Frc;
end;


function  OrdSuffix(const X:Integer):AnsiString;

  {Returns a 2 character ordinal suffix for an integer.  For
   example, if X=1 then OrdSuffix='st' as in '1st', if X=2 then
   OrdSuffix='nd' as in 2nd, etc.}

begin
  SetLength(Result,2);//first,let compiler create a result string
  asm
    Push  ESI
    Push  EDI         //save the important stuff
    Push  EBX


    Mov   EAX,X       //get X
    Mov   EDI,@Result //get resultant address
    Mov   EDI,[EDI]
    Cld
    Cdq
    Xor   EAX,EDX
    Sub   EAX,EDX
    Sub   EDX,EDX
    Mov   ECX,EAX
    Mov   ESI,10
    Sub   EAX,ESI
    Ja    @LA
    Mov   EAX,ECX
    Div   ESI
    Jmp   @LB
@LA:
    Mov   EBX,100
    Div   EBX
    Mov   EAX,EDX
    Cdq
    Div   ESI
    Or    EAX,EAX
    Jnz   @LB
    Mov   EDX,EAX
@LB:
    Mov   EBX,EDX
    Cmp   EBX,1
    Jz    @L1
    Cmp   EBX,2
    Jz    @L2
    Cmp   EBX,3
    Jz    @L3

    Mov   AX,'ht'
    Jmp   @Done
@L1:
    Mov   AX,'ts'
    Jmp   @Done
@L2:
    Mov   AX,'dn'
    Jmp   @Done
@L3:
    Mov   AX,'dr'
@Done:
    Stosw

    Pop   EBX
    Pop   EDI
    Pop   ESI

  end;
end;


function BoolToStr(const TF:Boolean):AnsiString;
begin
  if TF then Result:='True' else Result:='False';
end;


function Similar(const S1,S2:AnsiString):Integer;

  {Ratcliff/Obershelp pattern matching algorithm (DDJ, July 88). Returns a
   percentage (0 - 100) corresponding to the similarity between S1 & S2:

                100 = Total match---identical
                  0 = Total mismatch---nothing in common

   Uppercase the two strings for case insensitivity.

   NOTE: This routine uses an internal stack.  To avoid potential
         overflow, input strings are limited to 255 characters.}

  asm

    push  esi
    push  edi
    push  ebx
    push  ebp

    mov   esi,eax
    mov   edi,edx
    xor   eax,eax
    or    esi,esi
    jz    @donit
    or    edi,edi
    jz    @donit
    mov   score,eax
    mov   stcknum,eax
    mov   ebp,[edi-4]
    or    ebp,ebp
    jz    @donit
    cmp   ebp,255
    jg    @donit
    mov   ebx,[esi-4]
    or    ebx,ebx
    jz    @donit
    cmp   ebx,255
    jg    @donit
    mov   eax,ebp
    add   eax,ebx
    mov   total,eax
    dec   ebp
    add   ebp,edi
    dec   ebx
    add   ebx,esi
    call  @pushst
@main:
    cmp   stcknum,0
    jz    @done
    call  @popst
    call  @compare
    or    edx,edx
    jz    @main
    shl   edx,1
    add   score,edx
    mov   ebp,stcknum
    shl   ebp,2
    lea   eax,istack[0]
    add   ebp,eax
    mov   esi,[ebp]
    mov   ebx,l1
    add   ebp,200
    mov   edi,[ebp]
    mov   ecx,l2
    sub   ebp,100
    mov   eax,[ebp]
    mov   l1,eax
    add   ebp,200
    mov   eax,[ebp]
    mov   l2,eax
    mov   ebp,ecx
    cmp   ebx,esi
    jz    @chrght
    cmp   ebp,edi
    jz    @chrght
    dec   ebx
    dec   ebp
    cmp   ebx,esi
    jnz   @pushit
    cmp   ebp,edi
    jz    @chrght
@pushit:
    call  @pushst
@chrght:
    mov   esi,r1
    mov   ebx,l1
    mov   edi,r2
    mov   ebp,l2
    cmp   esi,ebx
    jz    @main
    cmp   edi,ebp
    jz    @main
    inc   esi
    inc   edi
    cmp   ebx,esi
    jnz   @push2
    cmp   ebp,edi
    jz    @main
@push2:
    call  @pushst
    jmp   @main
@done:
    mov   eax,score
    mov   ecx,1000
    mul   ecx
    mov   ecx,total
    idiv  ecx
    mov   ecx,5
    add   eax,ecx
    xor   edx,edx
    shl   ecx,1
    idiv  ecx
@donit:
    pop   ebp
    pop   ebx
    pop   edi
    pop   esi

    Ret

@compare:
    mov   s2ed,ebp
    xor   edx,edx
@forl3:
    push  edi
@forl4:
    push  edi
    push  esi
    mov   ecx,s2ed
    sub   ecx,edi
    inc   ecx
    push  ecx
    repz  cmpsb
    jz    @equal
    inc   ecx
@equal:
    pop   eax
    sub   eax,ecx
    jnz   @newmax
    pop   esi
    pop   edi
@reent:
    inc   edi
@reent2:
    cmp   edi,ebp
    jbe   @forl4
    pop   edi
    inc   esi
    cmp   esi,ebx
    jbe   @forl3

    ret

@newmax:
    cmp   eax,edx
    ja    @newmx2
    pop   esi
    pop   edi
    add   edi,eax
    jmp   @reent2
@newmx2:
    pop   esi
    pop   edi
    mov   l1,esi
    mov   l2,edi
    mov   ecx,eax
    sub   eax,edx
    sub   ebx,eax
    sub   ebp,eax
    mov   edx,ecx
    dec   ecx
    add   edi,ecx
    mov   r2,edi
    add   ecx,esi
    mov   r1,ecx
    jmp   @reent

@pushst:
    mov   ecx,ebp
    mov   ebp,stcknum
    shl   ebp,2
    lea   eax,istack[0]
    add   ebp,eax
    mov   [ebp],esi
    add   ebp,100
    mov   [ebp],ebx
    add   ebp,100
    mov   [ebp],edi
    add   ebp,100
    mov   [ebp],ecx
    inc   stcknum
    mov   ebp,ecx

    ret

@popst:
    dec   stcknum
    mov   ebp,stcknum
    shl   ebp,2
    lea   eax,istack[0]
    add   ebp,eax
    mov   esi,[ebp]
    add   ebp,100
    mov   ebx,[ebp]
    add   ebp,100
    mov   edi,[ebp]
    add   ebp,100
    mov   ebp,[ebp]

    ret

  end;


function SetFileLock(const FHandle,LockStart,LockSize:Integer):Boolean;

  {Performs record locking on an open file.}

var
  TimeOut:DWord;
begin
  TimeOut:=GetTickCount+15000;  //wait up to 15 seconds for lock to clear
  repeat
    Result := LockFile(FHandle, DWord(LockStart), 0, DWord(LockSize), 0);
    if Not(Result) then begin
      if GetTickCount>TimeOut then break;
      SleepEx(110,False); //Wait 2 ticks for lock to clear
    end;
  until Result;
end;


function ClrFileLock(const FHandle,LockStart,LockSize:Integer):Boolean;

  {Clears record lock on an open file.}

begin
  Result := UnLockFile(FHandle, LockStart, 0, LockSize, 0);
end;


function UniqueApp(const Title:AnsiString):Boolean;

  {Checks for previous Win32 instances of an application by attempting to
   to create a named mutex global synchronization object.  'Title' is a user
   specified object name.

   Returns: True if unique instance; otherwise, false (app exists).}

begin
  hMutex:=CreateMutex(nil, False, PChar(Title));
  Result:=GetLastError<>ERROR_ALREADY_EXISTS;
end;




function GetCPU:AnsiString;

  {Returns identifying string for installed CPU type as follows:

   '80386'= Intel 80386
   '80486'= Intel 80486
   '80586'= Intel Pentium
   '4000' = MIPS
   '21064'= DEC Alpha
  }

var
  SI:TSystemInfo;
begin
  GetSystemInfo(SI);
  if SI.dwOemId=0 then
     SI.dwProcessorType:=SI.dwProcessorType+80000;
  Result:=IntToStr(SI.dwProcessorType);
end;


function  GetKeyValues(const Root:HKey;Key,Values:AnsiString):AnsiString;

  {Reads multiple values from a given registry key and returns the data as a
   tokenized string.  If a specified value is not found, a '?' is returned
   as a placeholder.

   Note: Incoming values string must be delimited using commas.  The current
         internal delimiter setting (use SetDelimiter) is used for the resultant.

   Example:

   Label1.Caption:=GetKeyValues(HKEY_LOCAL_MACHINE,
                   'SOFTWARE\Microsoft\Windows\CurrentVersion',
                   'Version,VersionNumber,RegisteredOwner,RegisteredOrganization,ProductId');}

var
  hTmp          : HKEY;
  tkey,vBfr     : AnsiString;
  lJ,lK         : Integer;
  dt            : DWord;
const
  Tbl=',';
begin
  if RegOpenKeyEx(Root,PChar(Key),0,KEY_READ,hTmp) = ERROR_SUCCESS then begin
    Result:='';
    lK:=1;
    dt:=0;
    tkey:=Parse(values,Tbl,lK);
    SetLength(vBfr,MAX_PATH+1);   //initialize buffer for key values
    lJ:=MAX_PATH;
    if tkey='?' then while RegEnumKey(hTmp,dt,PChar(vBfr),lJ) = ERROR_SUCCESS do begin
      if Length(Result)>0 then Result:=Result+Delimiter;
      Result:=Result+LStr(vBfr,StrLen(PChar(vBfr)));
      Inc(dt);
    end else while Length(tkey)>0 do begin
      lJ:=MAX_PATH;
      if Length(Result)>0 then Result:=Result+Delimiter;
      if RegQueryValueEx(hTmp,PChar(tkey),nil,@dt,PByte(vBfr),@lJ) = ERROR_SUCCESS then begin
        if dt=REG_DWORD then begin
          Move(vBfr[1],dt,4);
          Result:=Result+IntToStr(dt);
        end else if dt=REG_SZ then
          Result:=Result+LStr(vBfr,lJ-1)
        else
          Result:=Result+LStr(vBfr,lJ);
      end else Result:=Result+'?';
      tkey:=Parse(Values,Tbl,lK);
    end;
    RegCloseKey(hTmp);
  end else Result:='!ERROR';
end;


function CalcStr(Source:AnsiString):Double;

  {Numeric evaluation of an algebraic string using a recursive approach.
   Supports the 4 basic math operators, negation, exponentiation, Ln(),
   Exp(),Abs() and trigonometric functions (MATH unit required, commented out in
   freeware version).  Other functions can be easily added. Exception is
   raised if the string cannot be evaluated for any reason.}

const
  MathDel:AnsiString = '+-/*^()';
var
  Term:AnsiString;
  Oper:Char;
  P:Integer;

  procedure GetOperTerm;
  begin
    Term:=Parse(Source,MathDel,P);
    if P<1 then Oper:=#0 else Oper:=Source[P-1];
  end;

  function DoAdd : Double; forward;

  function DoBracket : Double; //5
  begin
    Result := DoAdd;
    if Oper = ')' then GetOperTerm
    else raise Exception.Create ('Mismatched brackets')
  end;

  function DoSign : Double;    //4
  var
    I:Integer;
  begin
    Result:=0;
    bJ := False;  //global boolean
    GetOperTerm;
    if Length(Term)>0 then begin
      if IsFloat(Term) then begin
        Result := StrToFloat(Term)
      end else begin
        I:=Hash(UpperCase(Term));
        if Oper = '(' then begin
          //Function table - define new functional hash values as needed
          case I of
            1294:    Result:=LN(DoBracket);
            17779:   Result:=ABS(DoBracket);
            19152:   Result:=EXP(DoBracket);
{            18499:   Result:=COS(DoBracket);
            22494:   Result:=SIN(DoBracket);
            22622:   Result:=TAN(DoBracket);
            296056:  Result:=COSH(DoBracket);
            332706:  Result:=LOG2(DoBracket);
            359976:  Result:=SINH(DoBracket);
            362024:  Result:=TANH(DoBracket);
            5323328: Result:=LOG10(DoBracket);
            73824323:Result:=ARCCOS(DoBracket);
            73828314:Result:=ARCSIN(DoBracket);
            73828442:Result:=ARCTAN(DoBracket);}
            else         bJ:=True;
          end;
        end else begin
          //Constants table
          case I of
            1353: Result:=PI;
            else      bJ:=True;
          end;
        end;
      end;
    end else begin
      case Oper of
        '+' : Result := DoSign;
        '-' : Result := -DoSign;
        '(' : Result := DoBracket;
        else      bJ := True
      end;
    end;
    if bJ then raise Exception.CreateFmt ('Syntax error at position %d', [P])
  end;

  function DoPwr : Double; //3
  begin
    Result := DoSign;
    if Oper='^' then Result := exp (ln (Result) * DoSign);
  end;

  function DoDiv : Double; //2
  begin
    Result := DoPwr;
    while True do begin
      case Oper of
        '*' : Result := Result * DoPwr;
        '/' : Result := Result / DoPwr;
        else break;
      end;
    end;
  end;

  function DoAdd : Double; //1
  begin
    Result := DoDiv;
    while True do begin
      case Oper of
        '+' : Result := Result + DoDiv;
        '-' : Result := Result - DoDiv;
        else break;
      end;
    end;
  end;

begin
  Result:=0;
  bI:=False;             //global boolean
  P := Compact(Source);
  if P>0 then begin
    SetLength(Source,P);
    P := 1;
    Result := DoAdd;
    bI:=(Oper=#0);
  end;
  if bI=False then Raise Exception.Create('Unexpected end of string');
end;


function RndToFlt (const X : Double) : Double;

  {Provides the popular 'biased' method for rounding of floating point values
   where fractions of 0.5 and greater are rounded up to the next higher integer.
   Logically, there is no basis for always favoring the larger value since 0.5 is
   exactly half way between integers.

   Delphi's Round() function uses 'unbiased' rounding whereby fractions of 0.5
   are sometimes rounded up; sometimes down. Actually, the nearest even integer
   is always returned. For example, 1.5 rounds to 2, 2.5 also rounds to 2 but
   3.5 rounds to 4. Statistically, this makes more sense and produces less error
   overall since 0.5 is rounded DOWN half the time; rounded UP the other half.

   To illustrate, the table below shows the effects of rounding and summing the
   first 4 midpoint fractions.


            Biased           Unbiased
            ------------     -------------
            0.5 --> 1        0.5 --> 0
            1.5 --> 2        1.5 --> 2
            2.5 --> 3        2.5 --> 2
            3.5 --> 4        3.5 --> 4
            ------------     -------------
        Sum 8.0     10   Sum 8.0     8                 }

const
  HalfD:Double=0.5;
var
  W:Word;
asm
//  Result := Int(X) + Int ( Frac(X) * 2 );
  Fstcw [W]        //save control word
  Fwait            //is this still necessary ?
  Fldcw cwChop     //set co-proc to truncate (see SYSTEM.PAS)
  Fld   [X]        //load the value to be rounded
  Ftst             //positive ?
  Fnstsw AX
  Fld   [HalfD]
  Sahf
  Jae   @Pos       //yes, then jump
  FSub             //subtract 1/2
  Jmp   @Skip      //...and continue
@Pos:
  FAdd             //add 1/2
@Skip:
  Frndint          //truncate any fraction
  Fwait            //is this still necessary ?
  Fldcw [W]        //restore original control word
end;


function RndToInt (const X : Double) : Integer;
  {Round to integer using "traditional" (biased) rounding.}
begin
  Result := Trunc(X) + Trunc ( Frac(X) * 2 );
end;


function RndToDec (const X:Double; Decimals:Integer):Double;
  {Round a double to specified number of decimals.}
var
  I: Integer;
  W: Word;
asm
  Mov    EDX,EAX
  Or     EAX,EAX
  Jnz    @Start
  Fld    X
  Frndint
  Jmp    @End
@Start:
  Mov    I,EAX
  Fild   I
  Fldl2t
  FmulP  ST(1), ST
  Fstcw  [W]
  Fldcw  cwDown
  Fld    ST
  Frndint
  Fldcw  [W]
  Fxch
  Fsub   ST,ST(1)
  F2xm1
  Fld1
  FaddP  ST(1),ST
  Fscale
  Fst    ST(1)
  Fld    X
  FMul
  Frndint
  Fxch
  FDiv
@End:
  Fwait
end;


function TruncToDec (const X:Double; Decimals:Integer):Double;
  {Truncate a double to specified number of decimals.}
var
  I: Integer;
  W: Word;
asm
  Fstcw  [W]
  Mov    EDX,EAX
  Or     EAX,EAX
  Jnz    @Start
  Fld    X
  Fldcw  cwChop
  Frndint
  Jmp    @End
@Start:
  Mov    I,EAX
  Fild   I
  Fldl2t
  FmulP  ST(1), ST
  Fldcw  cwDown
  Fld    ST
  Frndint
  Fxch
  Fsub   ST,ST(1)
  F2xm1
  Fld1
  FaddP  ST(1),ST
  Fscale
  Fst    ST(1)
  Fld    X
  FMul
  Fldcw  cwChop
  Frndint
  Fxch
  FDiv
@End:
  Fldcw  [W]
  Fwait
end;



function RndToSig (const X:Double; Digits:Integer):Double;
  {Round a double to specified number of significant digits.}

  function IntLog10(X:Double):Integer;
  asm
    Sub    ESP,8
    Fldlg2
    Fld X
    FAbs
    Fyl2x
    Fstcw  [ESP]
    FWait
    Fldcw  cwDown
    Fistp  dWord ptr [ESP+4]
    FWait
    Fldcw  [ESP]
    Add    ESP,4
    Pop    EAX
  end;

begin
  Dec(Digits,1+IntLog10(X));
  Result:=RndtoDec(X,Digits);
end;


function RndToCents(const X:Currency):Currency;
  {Round a currency value to 2 decimals using traditional rounding.}
const
  HalfC :DWord=50;
var
  W:Word;
asm
  Fstcw [W]        //save control word
  Fwait            //is this still necessary ?
  Fldcw cwChop     //set co-proc to truncate (see SYSTEM.PAS)
  Fild  qword [X]  //load the integer to be rounded
  Ftst             //positive ?
  Fnstsw AX
  Sahf
  Jae   @Pos       //yes, then jump
  Fisub HalfC      //subtract 1/2 a cent
  Jmp   @Skip      //...and continue
@Pos:
  FiAdd HalfC      //add 1/2 a cent
@Skip:
  FiDiv Cents      //divide by pennies
  Frndint          //truncate any fraction
  FiMul Cents      //multiply by pennies
  Fwait            //is this still necessary ?
  Fldcw [W]        //restore original control word
end;


function TruncToCents(const X:Currency):Currency;
  {Truncate a currency value to 2 decimals.}
var
  W:Word;
asm
  Fstcw [W]
  Fwait
  Fldcw cwChop
  Fild  qword [X]
  FiDiv Cents
  Frndint
  FiMul Cents
  Fwait
  Fldcw [W]
end;


function FloatToFrac(const X : Double; D:Integer) : AnsiString;

  {Converts a floating point number into a rounded fraction string with max.
   denominator D.  Example:  FloatToFrac(StrToFloat('5.25'),16) returns 5-1/4

   NOTE: D must be a power of 2.}

var
  N:Integer;
begin
  N:=RndToInt(Frac(X)*D);
  N:=Abs(N);
  if (N=0) OR (N=D) then
    Result:=FloatToStr(RndToFlt(X))
  else begin
    while (N>1) AND ((N AND 1)=0) do begin
      N := N Shr 1;
      D := D Shr 1;
    end;
    Result:=FloatToStr(Int(X));
    if N>0 then Result:=Result+'-'+IntToStr(N)+'/'+IntToStr(D);
  end;
end;


function IPower(const X,Y:Integer):Integer;

  {Calculates integer powers (X^Y) without floating point Math unit.
   Max. Y = 30. Resultant = zero on error or overflow. }

asm
    Push EBX

    Mov  ECX,EDX

    Cmp  EAX,1                   //1^Y = 1
    Jz   @Done
    Or   EAX,EAX                 //0^Y = 0
    Jz   @Done

    Or   ECX,ECX                 //examine exponent
    Jnz  @Skip
    Mov  EAX,1                   //X^0 = 1
    Jmp  @Done
@Skip:
    Js   @Error                  //negative power is undefined
    Dec  ECX                     //the first power is implicit
    Jz   @Done

    Mov  EBX,EAX                 //save a copy of the base

@Top:
    IMul EBX                     //multiply
    Jo   @Error                  //abort on overflow
    Jc   @Error
    Dec  ECX
    Jnz  @Top

    Jmp  @Done                   //done if no overflow

@Error:
    Xor  EAX,EAX                 //return zero on error
@Done:
    Pop  EBX

end;


function IPower2(const Y:Integer):Integer;

  {Calculates integer powers of 2 (2^Y) without floating point Math unit.
   Max. Y = 30. Resultant = zero on error or overflow. }

asm
    Mov   ECX,EAX
    Xor   EAX,EAX
    Cmp   ECX,30
    Ja    @Done
    Or    ECX,ECX
    Js    @Done
    Mov   EAX,1
    Jecxz @Done
    Shl   EAX,CL
@Done:

end;


procedure SpeakerBeep;
  { Beep using the system speaker in Win95.  Faster than using the sound card,
    works even if sound driver is muted. }
begin
  MessageBeep($FFFF);
end;


procedure KillOLE;
  { Unloads (actually de-references) OLE automation DLL's thus reducing memory
    requirements of your app by roughly 1 meg.

    WARNING:  DO NOT use this routine unless you are confident that your app
              doesn't use OLE or variant data types.  The data access controls;
              TTable, TDataSource, etc., have the potential to use variant data
              types. }

begin
  FreeLibrary(GetModuleHandle('OLEAUT32'));
end;


function IsWinNT:Boolean;
  {Returns True if WinNT; otherwise, Win95.}
var
  VersionInfo: TOSVersionInfo;
begin
//  Result:=SysUtils.Win32Platform=VER_PLATFORM_WIN32_NT;
  VersionInfo.dwOSVersionInfoSize := Sizeof(TOSVersionInfo);
  Result:=GetVersionEx(VersionInfo);
  if Result then Result:=VersionInfo.dwPlatformID=VER_PLATFORM_WIN32_NT;
end;


function IsNetWork:Boolean;
  {Returns True if machine is networked.  Requires Win95 or WinNT 4.0+.}
begin
  Result := (GetSystemMetrics(SM_NETWORK) and 1) <> 0;
end;


function GetTmpFile(const Path,Prefix:AnsiString):AnsiString;
  { Obtains a unique temporary filename.  Use Path :='.' for current directory,
    Path := GetTmpDir for Windows temporary path. Prefix is up to 3 char. used
    as the start of the filename. Returns null string on error.}
begin
  SetLength(Result,MAX_PATH);
  if GetTempFileName(PChar(Path),PChar(Prefix),0,PChar(Result))>0 then
    SetLength(Result,StrLen(PChar(Result)))
  else
    SetLength(Result,0);
end;


function GetDefaultPrn:AnsiString;
  { Returns a tokenized string (comma delimited) with info on the
    current system default printer in the format: Device,Driver,Port}
var
  I:DWord;
begin
  SetLength(Result,MAX_PATH);
  I:=GetProfileString('Windows','Device','',PChar(Result),MAX_PATH);
  SetLength(Result,I);
end;


procedure GetMemStatus(var RAMTotal,RAMUsed,PGTotal,PGUsed:Integer);
  { RAMTotal = Total physical memory available to Windows
    RAMUsed  = Percent of physical memory curently used
    PGTotal  = Total swap file storage available to Windows
    PGUsed   = Percent of swap file currently used }
var
  MS: TMemoryStatus;
begin
  MS.dwLength:=SizeOf(MS);
  GlobalMemoryStatus(MS);
  Cardinal(RAMTotal):=MS.dwTotalPhys div 1024;
  Cardinal(RAMUsed):=Integer(MS.dwMemoryLoad);
  Cardinal(PGTotal):=MS.dwTotalPageFile div 1024;
  Cardinal(PGUsed):=((((MS.dwTotalPageFile-MS.dwAvailPageFile)+512) div 1024)*100) div Cardinal(PGTotal);
end;


function  GetProcID(const hWnd:THandle):THandle;
  {Returns a process status handle given a window handle.}

{$ifdef VER90}      //Delphi 2 doesn't have this constant
const
  PROCESS_ALL_ACCESS = $001F0FFFF;
{$endif}

begin
  Result:=$FFFFFFFF;
  if IsWindow(hWnd) then begin
    GetWindowThreadProcessId(hWnd, @Result);
    Result := OpenProcess(PROCESS_ALL_ACCESS, FALSE, Result);
  end;
end;




function GetWinClass(const Title:AnsiString):AnsiString;
  {Returns a window class name given a window title.}
var
  hWnd:THandle;
begin
  hWnd := FindWindow(nil,PCHAR(Title));
  if IsWindow(hWnd) then begin
    SetLength(Result,256);
    dwI:=GetClassName(hWnd,PChar(Result),255);
    setLength(Result,dwI);
  end else Setlength(Result,0);
end;


function DOSExec(const CmdLine:AnsiString;const DisplayMode:Integer):Boolean;
  {Execute a DOS app and automatically close the Window on termination.
   Path is optional but CmdLine must include the executable's extension.
   DisplayMode is usually either sw_ShowNormal or sw_Hide. Returns True
   unless execution fails.}
begin
  Result:=WinExec(PChar('command.com /c '+CmdLine),DisplayMode)>31;
end;


function WaitExec(const CmdLine:AnsiString;const DisplayMode:Integer):Integer;
  {Execute an app, wait for it to terminate then return exit code.  Returns -1
   if execution fails. DisplayMode is usually either sw_ShowNormal or sw_Hide.}
 var
   S:TStartupInfo;
   P:TProcessInformation;
   M:TMsg;
   R:DWord;
 begin
   FillChar(P,SizeOf(P),#0);
   FillChar(S,Sizeof(S),#0);
   S.cb := Sizeof(S);
   S.dwFlags := STARTF_USESHOWWINDOW;
   S.wShowWindow := DisplayMode;
   if not CreateProcess(nil,
     PChar(CmdLine),                { pointer to command line string }
     nil,                           { pointer to process security attributes }
     nil,                           { pointer to thread security attributes }
     False,                         { handle inheritance flag }
     CREATE_NEW_CONSOLE or          { creation flags }
     NORMAL_PRIORITY_CLASS,
     nil,                           { pointer to new environment block }
     nil,                           { pointer to current directory name }
     S,                             { pointer to STARTUPINFO }
     P)                             { pointer to PROCESS_INF }
   then Result:=-1 else begin
//     WaitforSingleObject(P.hProcess,INFINITE);
//   The following replacement better satisfies DDE requirements
     repeat
       R := MsgWaitForMultipleObjects(1, // One event to wait for
       P.hProcess, // The array of events
       FALSE, // Wait for 1 event
       INFINITE, // Timeout value
       QS_ALLINPUT); // Any message wakes up
       if R>WAIT_OBJECT_0 then begin
         M.Message := 0;
         while PeekMessage(M,0,0,0,PM_REMOVE) do begin
           TranslateMessage(M);
           DispatchMessage(M);
         end
       end;
     until R=WAIT_OBJECT_0;
     GetExitCodeProcess(P.hProcess,DWord(Result));
     CloseHandle(P.hProcess);
     CloseHandle(P.hThread);
     P.hProcess:=0;
     P.hThread:=0;
   end;
end;


procedure NewPipe;
begin
  FillChar(P,SizeOf(P),#0);
  FillChar(SInn,Sizeof(SInn),#0);
  FillChar(SOut,Sizeof(SOut),#0);
  bPipe:=True;
  with SInn do begin
    if CreatePipe (hRead, hWrite, nil, 4096) then
      DuplicateHandle(GetCurrentProcess,hRead,GetCurrentProcess,@hRead,0,True,DUPLICATE_CLOSE_SOURCE OR DUPLICATE_SAME_ACCESS)
    else begin
      raise Exception.Create('Error creating STDIN pipe');
      Exit;
    end;
  end;
  with SOut do begin
    if CreatePipe (hRead, hWrite, nil, 4096) then
      DuplicateHandle(GetCurrentProcess,hWrite,GetCurrentProcess,@hWrite,0,True,DUPLICATE_CLOSE_SOURCE OR DUPLICATE_SAME_ACCESS)
    else begin
      raise Exception.Create('Error creating STDOUT pipe');
      Exit;
    end;
  end;
end;


procedure ClosePipe;
  {Close application and pipe handles created by PipeExec.}
var
   Status:DWord;
begin
  if bPipe then begin
    with P do begin
      GetExitCodeProcess(hProcess,Status);
      if Status = STILL_ACTIVE then TerminateProcess(hProcess,0);
      if hProcess<>0 then CloseHandle(hProcess);
      if hThread <>0 then CloseHandle(hThread);
      hProcess:=0;
      hThread:=0;
    end;
    with SInn do begin
      if hRead <> 0 then CloseHandle (hRead);
      if hWrite <> 0 then CloseHandle (hWrite);
      hRead := 0;
      hWrite := 0;
    end;
    with SOut do begin
      if hRead <> 0 then CloseHandle (hRead);
      if hWrite <> 0 then CloseHandle (hWrite);
      hRead := 0;
      hWrite := 0;
    end;
    bPipe:=False;
  end;
end;


procedure PipeExec(const CmdLine:AnsiString;const DisplayMode:Integer);
  {Execute an external app with re-directed STDIN, STDOUT, and STDERR.
   Generates an exception if execution fails for any reason. }
var
  Tmp:AnsiString; 
begin
  if bPipe then begin
    raise Exception.Create('Pipe unavailable/in use');
    Exit;
  end;
  try
    NewPipe;
  except
    ClosePipe;
    Exit;
  end;
  FillChar(S,Sizeof(S),#0);
  S.cb := Sizeof(S);
  S.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  S.wShowWindow := DisplayMode;
  S.hStdInput := SInn.hRead;
  S.hStdOutput := SOut.hWrite;
  S.hStdError := SOut.hWrite;
  Tmp:=CmdLine;
  if IsWinNT then if ScanF(CmdLine,'cmd',-1)=0 then Tmp:='cmd /c '+CmdLine;
  if CreateProcess(nil,
    PChar(Tmp),                    { pointer to command line string }
    nil,                           { pointer to process security attributes }
    nil,                           { pointer to thread security attributes }
    True,                          { handle inheritance flag }
    0,                             { creation flags }
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    S,                             { pointer to STARTUPINFO }
    P)                             { pointer to PROCESS_INF }
  then begin
    CloseHandle(P.hThread);
    P.hThread:=0;
  end else begin
    ClosePipe;
    raise Exception.Create('Error '+IntToStr(GetLastError)+' creating re-directed process');
  end;
end;


function ReadPipe(var S:AnsiString):Integer;
  {Attempt to read Length(S) bytes from STDOUT of application launched using
   PipeExec.  Result = no. bytes read. Exception is generated on external app
   failure.}
begin
  Result:=0;
  if (bPipe=False) OR (Length(S)=0) or (SOut.hRead=0) then Exit;
  if PeekNamedPipe(SOut.hRead,nil,0,nil,@Result,nil) then begin
    if Result>0 then if not ReadFile (SOut.hRead, S[1], Length(S), DWord(Result), nil)
      then raise Exception.Create('Error '+IntToStr(GetLastError)+' reading from pipe');
  end;
end;


function WritePipe(const S:AnsiString):Integer;
  {Attempt to write Length(S) bytes to STDIN of application launched using
   PipeExec.  Result = no. bytes written.  Exception is generated on external
   app failure.}
begin
  Result:=0;
  if (bPipe=False) or (Length(S)=0) or (SInn.hWrite=0) then Exit;
  if not WriteFile (SInn.hWrite, S[1], Length(S), DWord(Result), nil) then
    raise Exception.Create('Error '+IntToStr(GetLastError)+' writing to pipe');
end;


function RemoteDrive(const Drv:Char):Boolean;
  {Returns True if specified letter is a networked drive.}
begin
  Result:=GetDriveType(PChar(Drv+':\'))=DRIVE_REMOTE;
end;


function DriveNum(DriveLtr:Char):Byte;
begin
  Result := Byte(DriveLtr) AND 31;
end;


function ListComm:AnsiString;
  {Returns delimited string containing a list of all available COM ports as
   obtained from Registry. Use SetDelimiter first to specify delimiter char.}
var
  hTmp                   : HKEY;
  key,tKey,kBfr,vBfr,S   : AnsiString;
  I,J,K,Cnt,Max_Key,Max_Val: DWord;
begin
  //read all available modems for internal ports
  SetLength(Result,0);
  key:='System\CurrentControlSet\Services\Class\Modem';
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(Key),0,KEY_READ,hTmp) = ERROR_SUCCESS then begin
    if RegQueryInfoKey(hTmp, nil, nil, nil, @Cnt,@Max_Key, nil, nil, nil,
      nil, nil, nil) = ERROR_SUCCESS then begin;
      if Cnt>0 then begin
        SetLength(kBfr,Max_Key+1);
        SetLength(vBfr,MAX_PATH+1);
        for I:=0 to Cnt - 1 do begin
          J:=Max_Key+1;
          if RegEnumKeyEx(hTmp, I, PChar(kBfr), J, nil, nil, nil, nil)=ERROR_SUCCESS then begin;
            tKey:=key+'\'+LStr(kBfr,J);
            RegCloseKey(hTmp);
            if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(tKey),0,KEY_READ,hTmp) = ERROR_SUCCESS then begin
              J:=MAX_PATH;
              if RegQueryValueEx(hTmp,'AttachedTo',nil,nil,PByte(vBfr),@J) = ERROR_SUCCESS then begin
                InsertToken(Result,LStr(vBfr,J-1),0);
              end;
              RegCloseKey(hTmp);
            end;
            RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(Key),0,KEY_READ,hTmp);
          end;
        end;
      end;
    end;
    RegCloseKey(hTmp);
  end;
  //read all available comm ports
  key:='hardware\devicemap\serialcomm';
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE,PChar(Key),0,KEY_READ,hTmp) = ERROR_SUCCESS then begin
    if RegQueryInfoKey(hTmp, nil, nil, nil, nil, nil, nil, @Cnt, @Max_Key,
      @Max_Val, nil, nil) = ERROR_SUCCESS then begin;
      if Cnt>0 then begin
        SetLength(kBfr,Max_Key+1);
        SetLength(vBfr,Max_Val+1);
        for I:=0 to Cnt - 1 do begin
          J:=Max_Key+1;
          K:=Max_Val+1;
          if RegEnumValue(hTmp, I, PChar(kBfr), J, nil, nil, PByte(vBfr), @K)=ERROR_SUCCESS then begin;
            if K>1 then begin
              S:=LStr(vBfr,K-1);
              if ScanF(Result,S,1)=0 then InsertToken(Result,S,0);
            end;
          end;
        end;
      end;
    end;
    RegCloseKey(hTmp);
  end;
end;


function OpenComm(const Mode:AnsiString):THandle;
  {Open a COM port for synchronous, non-overlapped Read/Write access. Returns
   port handle if successful; otherwise, an exception is raised.}
var
  DCB : TDCB;
  TOut: TCommTimeouts;
  I:Integer;
  Bfr:AnsiString;
begin
  Bfr:=Mode;
  UniqueString(Bfr);
  I:=Pos(':',Bfr)-1;
  if I<=0 then I:=4;
  Result := CreateFile(PChar(LStr(Bfr,I)),GENERIC_READ or GENERIC_WRITE,
         0,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  if Result=INVALID_HANDLE_VALUE then raise exception.create('Error opening port');
  if GetFileType( Result ) <> FILE_TYPE_CHAR then raise exception.Create('Invalid or unavailable port');
  if not GetCommState( Result, DCB) then raise exception.Create('Error reading port state');
  if not BuildCommDCB(PChar(Bfr),DCB) then raise exception.Create('Invalid mode');
  DCB.EvtChar := #13;
  DCB.Flags := DCB.Flags AND DWord(NOT $4000);  //clear fAbortonError
  if not SetCommState( Result, DCB) then raise exception.Create('Error setting port state');
  TOut.ReadIntervalTimeout         := MAXDWORD;
  TOut.ReadTotalTimeoutMultiplier  := 0;
  TOut.ReadTotalTimeoutConstant    := 0;
  TOut.WriteTotalTimeoutMultiplier := 0;
  TOut.WriteTotalTimeoutConstant   := 0;
  if not SetCommTimeOuts( Result, TOut) then
    raise exception.Create('Error setting timeouts')
  else begin
    SetCommMask(Result,EV_RLSD OR EV_RXFLAG); //scan for carrier change or data receive
    PurgeComm(Result,PURGE_TXCLEAR);          //clear transmit buffer
    PurgeComm(Result,PURGE_RXCLEAR);          //clear receive buffer
  end;
end;


function ReadComm(const pHnd:THandle; var Bfr:AnsiString):Integer;
  {Read characters from open COM port. Returns number of bytes read.}
var
  I,J:DWord;
begin
  Result:=0;
  J:=Length(Bfr);
  repeat
    I:=0;
    if ReadFile(pHnd, Bfr[Result+1], J-DWord(Result), I, nil) then begin
      Inc(Result,Integer(I));
      if DWord(Result)=J then break;  //we're done
      Sleep(110);
    end;
  until I=0;                          //nothing left to read
end;


function GetComm(const pHnd:THandle):Char;
  {Read next single character from open COM port.}
var
  I:DWord;
begin
  Result:=#0;
  ReadFile(pHnd, Result, 1, I, nil);
end;


function WriteComm(const pHnd:THandle; const Bfr:AnsiString):Integer;
  { Write characters to open COM port from Bfr string.  Returns number of
    characters written.}
var
  I,J:DWord;
begin
  Result:=0;
  J:=Length(Bfr);
  repeat
    WriteFile(pHnd, Bfr[Result+1], J-DWord(Result), I, nil);
    Inc(Result,Integer(I));
    if DWord(Result)=J then Break;
    Sleep(55);
  until I=0;
  if J<16 then FlushFileBuffers(pHnd);
end;

function StatusComm(const pHnd:THandle):Integer;
  {Returns the number of character available in input queue; -1 on error.}
var
  CS:TComStat;
  E:DWord;
begin
  Result:=-1;
  if ClearCommError(pHnd,E,@CS) then Result:=CS.cbInQue;
end;

function CloseComm(const pHnd:THandle): Boolean;
  {Close an open COM port.  Returns True if successful; otherwise, False.}
begin
  Result := CloseHandle(pHnd);
end;


function SetRxTime(const pHnd:THandle; const TimeC,TimeM:Integer):Boolean;
  { Set read time outs. }
var
  TOut:TCommTimeouts;
begin
  if (TimeC=0) AND (TimeM=0) then
    TOut.ReadIntervalTimeout       := MAXDWORD
  else TOut.ReadIntervalTimeout    := 0;
  TOut.ReadTotalTimeoutMultiplier  := TimeM;
  TOut.ReadTotalTimeoutConstant    := TimeC;
  TOut.WriteTotalTimeoutMultiplier := 0;
  TOut.WriteTotalTimeoutConstant   := 0;
  Result:=SetCommTimeOuts( pHnd, TOut);
end;


function ModemResponse(const pHnd:THandle):AnsiString;
  {Generic modem response retrieval.}
var
  TOut,TS:TCommTimeOuts;
  I:DWord;
begin
  if GetCommTimeOuts(pHnd,TS)=False then begin
    SetLength(Result,0);
    Exit;
  end;
  SetLength(Result,80);
  TOut.ReadIntervalTimeout := 500;
  TOut.ReadTotalTimeoutMultiplier  := 30;
  TOut.ReadTotalTimeoutConstant    := 3000;
  TOut.WriteTotalTimeoutMultiplier := 0;
  TOut.WriteTotalTimeoutConstant   := 0;
  SetCommTimeOuts(pHnd, TOut);
  ReadFile(pHnd, Result[1], 80, I, nil);
  SetLength(Result,I);
  SetCommTimeOuts(pHnd, TS);
end;


function ModemThere(const pHnd:THandle):Boolean;
  {Detects presence of a Hayes compatible modem given a valid port handle.}
var
  Status:DWord;
begin
  Result:=False;
  if pHnd<>INVALID_HANDLE_VALUE then begin
    EscapeCommFunction(pHnd,SETDTR);  //raise DTR
    EscapeCommFunction(pHnd,SETRTS);  //raise RTS
    if GetCommModemStatus(pHnd,Status) then begin
      PurgeComm(pHnd,PURGE_TXCLEAR);      //clear transmit buffer
      PurgeComm(pHnd,PURGE_RXCLEAR);      //clear receive buffer
      if (Status and MS_RLSD_ON)<>0 then begin  //on-line ?
        Sleep(1000);
        WriteComm(pHnd,'+++');
        Sleep(1000);
        WriteComm(pHnd,'ATH'#13);
        ModemResponse(pHnd);
      end;
      WriteComm(pHnd,'ATZ'#13);         //reset the modem
      Sleep(2500);                      //additional delay required with some modems
      Result := ScanF(ModemResponse(pHnd),OK,1)>0;  //check for "OK" string
    end;
  end;
end;


function ModemCommand(const pHnd:THandle; S:AnsiString):Boolean;
  {Send a command string to the modem and optionally wait for response.}
var
  I,J:Integer;
begin
  Result:=False;
  I:=1;J:=1;
  CTrim(S,#32);
  if (Length(S)=0) or (pHnd=INVALID_HANDLE_VALUE) then Exit;
  PurgeComm(pHnd,PURGE_RXCLEAR);      //clear receive buffer
  repeat  //parse the command string
    case S[I] of
      ':':begin  //just transmit with terminator
        S[I]:=#13;
        WriteComm(pHnd,CStr(S,J,I-J+1));
        Sleep(125);
        J:=I+1;
      end;
      '<':begin  //flush receive buffer
        PurgeComm(pHnd,PURGE_RXCLEAR);
      end;
      '>':begin  //flush transmit buffer
        PurgeComm(pHnd,PURGE_TXCLEAR);
      end;
      '|':begin  //transmit and wait for response
        S[I]:=#13;
        WriteComm(pHnd,CStr(S,J,I-J+1));
        Sleep(125);
        if ScanF(ModemResponse(pHnd),OK,1)=0 then Exit;
        J:=I+1;
      end;
      '~':begin  //software pause
        if J<I then begin
          WriteComm(pHnd,CStr(S,J,I-J));
          J:=I+1;
        end else Inc(J);
        S[I]:=#32;
        Sleep(500);
      end;
    end;
    Inc(I);
  until I>Length(S);
  RTrim(S,#32);
  if J<Length(S) then begin
    WriteComm(pHnd,CStr(S,J,Length(S)-J+1)); //send trailing if any
    Sleep(125);
  end;
  Result:=True;
end;


function ModemDialog:Boolean;
  {Displays modem configuration dialog from Control Panel}
begin
  Result := WinExec('rundll32 shell32.dll,Control_RunDLL modem.cpl',SW_SHOW)>31;
end;


function  IntToFmtStr(const X:Integer):AnsiString;
  {Converts integer to string with thousands separators}
begin
  Result:=FormatFloat(ThouSep+'#',X);
end;


function TruncPath(var S:AnsiString; const Count:Integer):Boolean;
  {Trys to shorten a file path to Count length by replacing text between
   backslashes with an ellipsis and dropping characters from file name while
   retaining as much of the file name as possible. Returns True if file path
   was shortened to Count.}
var
  I,J:Integer;
begin
  if Length(S)<=Count then begin
    Result:=True;
    Exit;
  end;
  Result:=False;
  if Count<4 then Exit;
  Total:=Length(S)-Count+3;
  I:=ScanC(S,'\',1);
  J:=ScanB(S,'\',-1);
  if I=J then
    S:=LStr(S,Count-3)+'...'
  else begin
    if (J-I)>Total then
      S:=LStr(S,J-Total-1)+'...'+CStr(S,J,Length(S))
    else begin
      Total:=iMax(Length(S)-Total-I-3,2);
      S:=LStr(S,I)+'...'+CStr(S,J,Total)+'...';
    end;
  end;
  Result:=Length(S)=Count;
end;


function Abbreviate(var S:AnsiString;const T:AnsiString;const Count:Integer):Boolean;

  {Attempt to shorten (S)ource to Count characters by first removing redundant
   whitespace and then (T)able characters and finally any additional characters
   as necessary.  Returns True if valid input and abbreviation was successful.}

var
  I,J,K,L,N,P,Mx:Integer;
  W,R:AnsiString;
begin
  Result:=True;
  L:=Length(S);
  if (L=0) OR (L<=Count) then Exit;
  Result:=False;
  if Count<=0 then Exit;
  S:=RTrim(S,' ');                    //remove trailing spaces
  I:=DeleteD(S,' ');                  //remove redundant spaces
  Setlength(S,I);
  if I>Count then begin
    N:=CountW(S,' ');
    if N>1 then begin
      L:=I-Count;
      Mx:=1;
      if Length(T)>0 then begin
        P:=Length(S);
        for I:=N downto 1 do begin    //remove table characters, word by word
          J:=ScanB(S,' ',P-1);
          W:=CStr(S,J+1,P-J);
          P:=J;
          K:=Length(W);
          if (K>1) AND (L>0) then begin
            J:=DeleteI(W,T,2);
            SetLength(W,J);
            L:=L-K+J;
            Mx:=IMax(Mx,J);
          end;
          R:=W+R;
        end;
        S:=R;
      end;
      while (L>0) and (Mx>1) do begin  //remove non-table if necessary
        Dec(Mx);
        J:=Mx;
        P:=Length(S);
        Setlength(R,0);
        for I:=N downto 1 do begin     //word by word
          K:=ScanB(S,' ',P-1);
          W:=CStr(S,K+1,P-K);
          P:=K;
          K:=Length(W);
          if W[K]=' ' then Dec(K);
          if (K>J) AND (L>0) AND (IsNumChar(W[K])=False)then begin
            if K<Length(W) then W[K]:=W[K+1] else Dec(K);
            SetLength(W,K);
            Dec(L);
            Mx:=IMax(Mx,K);
          end;
          R:=W+R;
        end;
        L:=DeleteD(R,' ');
        S:=LStr(R,L);
        L:=L-Count;
      end;
    end else begin
      J:=DeleteI(S,T,2);
      if J>Count then J:=Count;
      S:=LStr(S,J);
    end;
  end;
  Result:=Length(S)<=Count;
end;



function  iMax(const I,J:Integer):Integer;
asm
  Cmp   EAX,EDX
  Jge   @Exit
  Mov   EAX,EDX
@Exit:
end;


function  iMin(const I,J:Integer):Integer;
asm
  Cmp   EAX,EDX
  Jle   @Exit
  Mov   EAX,EDX
@Exit:
end;


function  iMid(const I,J,K:Integer):Integer;
asm
  Cmp   EAX,EDX
  Je    @Exit
  Ja    @L1
  Mov   EAX,EDX
@L1:
  Cmp   EAX,ECX
  Je    @Exit
  Jb    @Exit
  Mov   EAX,ECX
@Exit:
end;


function  iRnd(const Value, Range:Integer):Integer;
  {Rounds integer Value to specified Range using "traditional" rounding.
   Example: I := iRnd(-354,100) returns I = -400}
begin
  if Range>0 then
    Result:=((Value + (Value MOD Range)) DIV Range)*Range
  else
    Result:=Value;
end;


function  iTrunc(const Value, Range:Integer):Integer;
  {Truncates integer Value at specified Range.
   Example: I := iTrunc(-354,100) returns I = -300}
asm
  Mov   ECX,EDX
  Cdq
  IDiv  ECX
  IMul  ECX
end;


function iSign(const Value:Integer):Integer;
asm
  Cdq
  Or   EAX,EAX
  Jz   @Done
  Or   EDX,1
@Done:
  Mov  EAX,EDX
end;


function  AddUSI(const X,Y:Integer):Integer;
  {Unsigned addition.}
asm
  Add  EAX,EDX
  Jnc  @Done
  Int  4
@Done:
end;


function  SubUSI(const X,Y:Integer):Integer;
  {Unsigned subtraction, X - Y.}
asm
  Sub  EAX,EDX
  Jnc  @Done
  Int  4
@Done:
end;


function  MulUSI(const X,Y:Integer):Integer;
  {Unsigned multiplication}
asm
  Mul  EDX
  Or   EDX,EDX
  Jz   @Done
  Int  4
@Done:
end;


function  DivUSI(const X,Y:Integer):Integer;
  {Unsigned division quotent, X/Y.}
asm
  Mov  ECX,EDX
  Xor  EDX,EDX
  Div  ECX
end;


function  ModUSI(const X,Y:Integer):Integer;
  {Unsigned division remainder, X/Y.}
asm
  Mov  ECX,EDX
  Xor  EDX,EDX
  Div  ECX
  Mov  EAX,EDX
end;


function  CmpUSI(const X,Y:Integer):Integer;
  {Unsigned comparison. Returns: 0 of X=Y, Positive if X>Y, Negative if X<Y.}
asm
  Sub  EAX,EDX
  Jz   @Done
  Jc   @Skip
  Mov  EAX,1
  Jmp  @Done
@Skip:
  Mov  EAX,-1
@Done:
end;


function USIToStr(const X:Integer):AnsiString;
  {Unsigned integer to string.}
begin
  Setlength(Result,10);
  asm
    Push  ESI
    Push  EDI

    Mov   EAX,X
    Mov   EDI,@Result
    Mov   EDI,[EDI]
    Mov   ECX,10
    Add   EDI,ECX
    Mov   ESI,ECX
@L1:
    Dec   EDI
    Dec   ECX
    Xor   EDX,EDX
    Div   ESI
    Add   DL,48
    Mov   [EDI],DL
    Or    EAX,EAX
    Jnz   @L1

    Mov   dwI,ECX

    Pop   EDI
    Pop   ESI
  end;
  Delete(Result,1,dwI);
end;


function StrToUSI(const Source:AnsiString):Integer;
  {String to unsigned integer.}
asm
  Push  ESI
  Push  EDI

  Mov   ESI,EAX
  Xor   EAX,EAX
  Or    ESI,ESI
  Jz    @Done
  Mov   ECX,[ESI-4]
  Jecxz @Done
  Add   ESI,ECX
  Dec   ESI
  Mov   dwI,1
  Mov   dwJ,10
  Xor   EDX,EDX
  Xor   EDI,EDI
  Std
@L1:
  Or    EDX,EDX
  Jnz   @Abort
  Xor   EAX,EAX
  Lodsb
  Sub   AL,48
  Jc    @Next
  Cmp   AL,9
  Ja    @Next
  Mul   dwI
  Or    EDX,EDX
  Jnz   @Abort
  Add   EDI,EAX
  Jc    @Abort
  Mov   EAX,dwI
  Mul   dwJ
  Mov   dwI,EAX
@Next:
  Dec   ECX
  Jnz   @L1

  Mov   EAX,EDI
  Jmp   @Done
@Abort:
  Xor   EAX,EAX
  Int   4
@Done:
  Cld
  Pop   EDI
  Pop   ESI
end;


function LRC(const Source:AnsiString):Char;
  {Longitudinal Redundancy Check - A single character checksum.}
var
  I,J:Integer;
begin
   Result:=#0;
   if Length(Source)=0 then Exit;
   J:=Ord(Source[1]);
   for I:=2 to Length(Source) do J:=J XOR Ord(Source[I]);
   Result:=Char(J AND 255);
end;


procedure IniRLE;
  {Initialize run length encoding.}
begin
  cC:=#0;
  RLEFlg:=False;
end;


function RLE(const Bfr:AnsiString; L:Word):AnsiString;
  {Compress a string buffer containing repeated character sequences by applying
   a "safe" run length encoding (RLE) technique.  Effective buffer length may
   be specified in L. If L=0 or L>Length(Bfr) then Length(Bfr) is used.

   This routine is "safe" in that it avoids adding control characters to
   the output.  High order ASCII characters (192..255) are used to represent
   repeat counts.

   Note:
   Buffer length (L) is intentionally limited to Word range to prevent overflow
   during de-compression.  Larger text blocks can be sub-divided for processing.
   IniRLE must be called before starting compression.

   Input may safely include any binary character; however, if large numbers of
   widely dispersed (non-repeating) high order characters (192..255) are present,
   output length may actually exceed the input.}
var
  I,J,N:Integer;
  cI:Char;

  procedure WriteCount;
  begin
    Inc(N);
    J:=J OR 192;
    Result[N]:=Char(J);
    J:=0;
  end;

begin
  if (L>Length(Bfr)) or (L=0) then L:=Length(Bfr);
  if L=0 then Exit;
  SetLength(Result,BufSize);
  J:=0;
  I:=0;
  N:=0;
  repeat
    Inc(I);
    cI:=Bfr[I];
    if (cI=cC) AND (J<63) then
      Inc(J)
    else begin
      if J>0 then WriteCount;
      if cI>=#192 then begin
        Inc(N);
        Result[N]:=#192;
      end;
      Inc(N);
      Result[N]:=cI;
      cC:=cI;
    end;
  until I=L;
  if J>0 then WriteCount;
  SetLength(Result,N);
end;


function RLD(const Bfr:AnsiString; L:Word):AnsiString;

  {De-code a buffer string previously compressed using RLE.  An internal
   overflow may occur (generating an address exception) if Length(Result)
   exceeds Word range. IniRLE must be called before starting de-compression.
   See RLE for discusssion.}

var
  I,J,N:Integer;
  cI:Char;
begin
  if (L>Length(Bfr)) or (L=0) then L:=Length(Bfr);
  if L=0 then Exit;
  SetLength(Result,BufSize);
  I:=0;
  N:=0;
  repeat
    Inc(I);
    cI:=Bfr[I];
    if RLEFlg OR (cI<#192) then begin
      Inc(N);
      Result[N]:=cI;
      RLEFlg:=cI=#192;
    end else begin
      J:=Ord(cI) AND 63;
      if J>0 then begin
        FillChar(Result[N+1],J,Byte(cC));
        N:=N+J;
      end;
    end;
    if cI=#192 then RLEFlg:=NOT RLEFlg;
    cC:=cI;
  until I=L;
  SetLength(Result,N);
end;




procedure IniSQZ;
  {Initialize splay tree compression}
var
  A, B : DownIndex;
  C    : UpIndex;
begin
  AA := 0;
  for A := 1 to TwiceMax do Up[A] := Pred(A) shr 1;
  for C := 0 to PredMax do begin
    B := (C+1) shl 1;
    Left[C] := Pred(B);
    Right[C] := B;
  end;
end;


procedure SplayTree(X : CodeType);
  {Update the splay tree}
var
  A, B : DownIndex;
  C, D : UpIndex;
begin
  A := X + MaxChar;
  repeat  //Walk up the tree semi-rotating pairs
    C := Up[A];
    if C <> 0 then begin  // A pair remains
      D := Up[C];
      //Exchange children
      B := Left[D];
      if C = B then begin
        B := Right[D];
        Right[D] := A;
      end else Left[D] := A;
      if A = Left[C] then Left[C] := B else Right[C] := B;
      Up[A] := D;
      Up[B] := C;
      A := D;
    end else A := C;   //Handle odd node at end
  until A = 0;
end;


function SQZ(const Bfr:AnsiString; L:Word):AnsiString;
  {Splay tree compression}
var
  I,N    : Integer;
  InByte : CodeType;
  OutByte: CodeType;
  BitPos : Byte;
  Sp     : 0..MaxChar;
  A, B   : DownIndex;
  Stack  : array[UpIndex] of Boolean;
begin
  if (L>Length(Bfr)) or (L=0) then L:=Length(Bfr);
  if L=0 then Exit;
  SetLength(Result,BufSize);
  N:=0;
  I:=0;
  OutByte:=0;
  BitPos:=1;
  repeat
    Inc(I);
    if I>L then InByte:=MaxChar else InByte:=Word(Bfr[I]);
    A  := InByte + MaxChar;
    Sp := 0;
    //Walk up the tree pushing bits onto stack
    repeat
      B := Up[A];
      Stack[Sp] := (Right[B] = A);
      Inc(Sp);
      A := B;
    until A = 0;
    //unstack
    repeat
      Dec(Sp);
      if Stack[Sp] then OutByte := OutByte OR BitPos;
      if BitPos = 128 then begin
        Inc(N);
        Result[N] := Char(OutByte);
        BitPos := 1;
        OutByte := 0;
      end else BitPos := BitPos Shl 1;
    until Sp = 0;
    SplayTree(InByte);
  until I>L;
  if BitPos <> 1 then begin
    Inc(N);
    Result[N] := Char(OutByte);
  end;
  SetLength(Result,N);
end;


function UnSQZ(const Bfr:AnsiString; L:Word):AnsiString;
  {Splay tree de-compression}
var
  I,N    : Integer;
  InByte : CodeType;
  BitPos : Byte;
begin
  if (L>Length(Bfr)) or (L=0)then L:=Length(Bfr);
  if L=0 then Exit;
  SetLength(Result,BufSize);
  I := 0;
  N := 0;
  InByte:=0;
  BitPos:=128;
  repeat
    //Scan the tree to a leaf, which determines the character
    repeat
      if BitPos = 128 then begin
        Inc(I);
        if I>L then break;
        InByte:=Word(Bfr[I]);
        BitPos := 1;
      end else BitPos := BitPos Shl 1;
      if (InByte AND BitPos) = 0 then AA := Left[AA] else AA := Right[AA];
    until AA > PredMax;
    if I>L then break;

    //Update the code tree
    Dec(AA, MaxChar);
    SplayTree(AA);

    if AA=MaxChar then
      BitPos := 128
    else begin
      Inc(N);
      Result[N]:=Char(AA);
    end;
    AA := 0;
  until True=False;
  SetLength(Result,N);
end;


function BPE(const Bfr:AnsiString; L:Word):AnsiString;
  {Byte Pair Encoding}
var
  Tmp:AnsiString;
begin
  SetLength(Result,0);
  if (L>Length(Bfr)) or (L=0) then L:=Length(Bfr);
  if L=0 then Exit;
  SetLength(Result,BufSize);
  SetLength(Tmp,BufSize);
  asm
    Push  ESI
    Push  EDI
    Push  EBX

    Cld
    Mov   ESI,Bfr       //input buffer
    Mov   EAX,@Result
    Mov   EDI,[EAX]     //Result work buffer
    Add   EDI,3         //skip over header
    Mov   dwK,EDI
    Lea   EAX,Tmp
    Mov   EBX,[EAX]     //Pair count array
    Mov   dwJ,EBX
    Lea   EAX,iStack    //Stack
    Mov   dwL,EAX
    Xor   EAX,EAX
    Mov   Score,EAX     //Initialize replacement count

    Xor   ECX,ECX
    Mov   CX,L          //scan for high order characters
    Mov   DX,128
    Mov   wI,DX
  @L0:
    Lodsb
    Bt    EAX,7         //high order ?
    Jnc   @Skip         //no, then skip
    Mov   [EDI],DL      //store as [128][char XOR 128]
    Inc   EDI
    Xor   AL,DL
  @Skip:
    Stosb
    Dec   ECX
    Jnz   @L0

    Mov   EAX,dwK       //calc new length
    XChg  EAX,EDI       //buffer expands if high order characters present
    Sub   EAX,EDI
    Mov   L,AX          //save the new length

  //*** Main compression loop
  @Top:
    Inc   wI
    Call  @CntPairs
    Jnc   @Cleanup
    Call  @UpdateTable
    Call  @ReplacePairs
    Cmp   wI,255
    Jnz   @Top
  //*** End main loop

  @CleanUp:
    Mov   ECX,Score     //build block header
    Jecxz @Abort        //abort if no compression
    Mov   EAX,ECX
    Add   EAX,127
    Mov   EDI,dwK       //output buffer address
    Mov   [EDI-3],AL    //pair count
    Mov   AX,L
    Mov   [EDI-2],AX    //block length
    Add   EDI,EAX
    Shl   ECX,1         //pair table length
    Add   EAX,ECX
    Add   EAX,3         //add header to total length
    Mov   L,AX          //add table to total length
    Mov   ESI,dwL
    Lodsw               //skip first pair (null)
    Rep   Movsb         //add pair table to end of output buffer

  @Abort:
    Jmp   @Exit

  @CntPairs:
    //Count Byte pairs, return: DL = Max. Cnt (carry set if >2), AX = Pair
    Mov   EDI,dwJ
    Mov   ECX,BufSize    //initialize count array
    Shr   ECX,2          //use double words for speed
    Xor   EAX,EAX
    Rep   Stosd

    Mov   ESI,dwK
    Mov   EDI,dwJ
    Xor   EDX,EDX
    Mov   CX,L          //current length
    Dec   CX
    Jz    @GotIt
    Lodsb               //get first byte
  @L1:
    Mov   AH,AL
    Lodsb
    Mov   DL,[EDI+EAX]  //get current count
    Inc   DL
    Bt    EDX,7         //bail out if Count=128
    Jc    @GotIt
    Mov   [EDI+EAX],DL  //store pair count
    Cmp   DL,DH
    Jb    @Next
    Mov   DH,DL
    Mov   BX,AX
  @Next:
    Dec   ECX
    Jnz   @L1

    Mov   DL,DH
    Mov   AX,BX
    Mov   DH,2
    Cmp   DH,DL         //DL = Count, AX = Pair
  @GotIt:
  Ret

  @Exit:               //intermediate exit jump
    Jmp   @Done

  @UpDateTable:
    //Add AX pair to global table
    Mov   EBX,dwL
    Mov   DX,wI
    And   EDX,127
    Shl   EDX,1
    Mov   [EBX+EDX],AX
  Ret

  @ReplacePairs:
    //Replace all AX pairs with wI character
    Mov   BX,AX    //replace pair
    XChg  BL,BH
    Mov   DX,wI    //replace character
    Xor   ECX,ECX
    Mov   CX,L     //buffer size
    Dec   CX
    Mov   ESI,dwK  //read buffer address
    Mov   EDI,ESI  //write buffer
  @L2:
    Lodsw
    Cmp   AX,BX
    Jnz   @L3
    Mov   AL,DL
    Stosb
    Jmp   @Next2
  @L3:
    Stosw
    Cmp   AH,BL
    Jnz   @Next2
    Dec   ESI
    Dec   EDI
    Inc   ECX
  @Next2:
    Dec   ECX
    Dec   ECX
    Js    @Out
    Jnz   @L2

    Lodsb
    Stosb
  @Out:
    Mov   EAX,dwK
    XChg  EAX,EDI
    Sub   EAX,EDI    //calc current length
    Mov   L,AX
    Inc   Score      //count the pair
  Ret

  @Done:
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;
  if Score=0 then Result:=Bfr
  else SetLength(Result,L);
  Setlength(Tmp,0);
end;


function BPD(const Bfr:AnsiString; L:Word):AnsiString;
  {Byte Pair Decoding}
begin
  SetLength(Result,0);
  if (L>Length(Bfr)) or (L=0) then L:=Length(Bfr);
  if L=0 then Exit;
  Setlength(Result,BufSize);
  asm
    Push  ESI
    Push  EDI
    Push  EBX
    Push  EBP

    Cld
    Mov   ESI,Bfr       //Input buffer
    Mov   EAX,@Result   //Output buffer
    Mov   EDI,[EAX]
    Mov   dwJ,EDI       //save start address
    Xor   EAX,EAX
    Mov   ECX,EAX
    Mov   Score,EAX
    Mov   CX,L          //buffer length
    Lodsb
    Bt    EAX,7         //check first byte >127
    Jc    @Start        //yes, then jump
    Dec   ESI           //get that first byte again
    rep   movsb         //straight copy, input to output
    Jmp   @Exit         //and bail out
  @Start:
    Lodsw               //load block length
    Cmp   EAX,ECX
    Ja    @Abort
    Mov   ECX,EAX
    Mov   EBX,ESI
    Add   EBX,EAX       //pair table offset
    Lea   EBP,iStack    //stack base
    Xor   EDX,EDX       //stack pointer

  @Top:
    Or    EDX,EDX       //stack empty ?
    Jz    @L1           //yes, then jump
    Dec   EDX           //decrease stack pointer
    Mov   AL,[EBP+EDX]  //get byte from stack
    Jmp   @L2           //do output routine
  @L1:
    Jcxz  @Exit         //bail out if buffer empty
    Lodsb               //get byte from Bfr
    Dec   CX            //decrease count
  @L2:
    Bt    EAX,7         //pair ?
    Jc    @L3           //yes, then jump
    Test  ECX,$80000000
    Jz    @L5
    Or    AL,128
    Xor   ECX,$80000000
  @L5:
    Stosb               //emit character
    Jmp   @Top          //and do it all again
  @L3:
    And   EAX,127       //pair index
    Jnz   @L4
    Or    ECX,$80000000
    Jmp   @Top
  @L4:
    Dec   EAX
    Shl   EAX,1         //times 2 for offset
    Mov   AX,[EBX+EAX]  //get the pair
    Mov   [EBP+EDX],AX  //put it on the stack
    Inc   EDX           //move stack pointer
    Inc   EDX
    Jmp   @Top          //do it again
  @Exit:
    Mov   EAX,dwJ
    XChg  EAX,EDI
    Sub   EAX,EDI       //calc output length
    Mov   Score,EAX     //save it in Score
  @Abort:
    Pop   EBP           //restore the world
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;
  SetLength(Result,Score);
end;




function InPort(Address:Word):Byte;
  {Direct hardware port read, Win95 only}
asm
  Mov  DX,AX
  In   AL,DX
end;

procedure OutPort(Data:Byte;Address:Word);
  {Direct hardware port write, Win95 only}
asm
  Out  DX,AL
end;


function  CreditSum(const Source:AnsiString):Integer;
  {Performs a shifted Mod 10 checksum on a numeric ASCII string.  Characters
   outside the range ['0'..'9'] are ignored.

   This checksum is used for credit card encoding. Result = 0 if Source is a
   "potentially" valid credit card number string. Result = -1 if Source is null.}

asm
  Push  ESI
  Push  EBX

  Mov   ESI,EAX
  Mov   EAX,-1
  Or    ESI,ESI
  Jz    @Done
  Mov   ECX,[ESI-4]
  Jecxz @Done
  Xor   EAX,EAX
  Xor   EDX,EDX
  Xor   EBX,EBX
  Mov   BL,10
  Cld
@Top:
  Lodsb
  Sub   AL,48
  Js    @Next
  Cmp   AL,BL
  Jae   @Next
  Xor   BH,1
  Jz    @L1
  Shl   AL,1
  Cmp   AL,BL
  Jb    @L1
  Inc   AL
@L1:
  Add   EDX,EAX
@Next:
  Dec   ECX
  Jnz   @Top

  Mov   EAX,EDX
  Xor   EDX,EDX
  Xor   BH,BH
  Div   EBX
  Mov   EAX,EDX
@Done:
  Pop   EBX
  Pop   ESI
end;


function  ISBNSum(const Source:AnsiString):Boolean;

  {Computes International Standard Book Number (ISBN) checksum.  Returns True
   if the given string is a potentially valid alpha-numeric ISBN number.}

asm
  Push  ESI
  Push  EBX

  Mov   ESI,EAX
  Xor   EAX,EAX
  Or    ESI,ESI
  Jz    @Done
  Mov   ECX,[ESI-4]
  Jecxz @Done
  Xor   EDX,EDX
  Xor   EBX,EBX
  Cld
@Top:
  Lodsb
  Sub   AL,48
  Js    @Next
  Cmp   AL,10
  Jb    @L1
  Cmp   BL,9
  Jnz   @Next
  Cmp   AL,40
  Jz    @L2
  Cmp   AL,72
  Jnz   @Next
@L2:
  Mov   AL,10
@L1:
  Inc   BL
  Mul   BL
  Add   EDX,EAX
@Next:
  Dec   ECX
  Jnz   @Top

  Xor   EAX,EAX
  Cmp   BX,10
  Jnz   @Done
  XChg  EAX,EDX
  Mov   EBX,11
  Div   EBX
  Xor   EAX,EAX
  Or    EDX,EDX
  Jnz   @Done
  Mov   EAX,True
@Done:
  Pop   EBX
  Pop   ESI
end;

function  SetAppPriority(const Priority:DWord):Boolean;
begin
  Result:=SetPriorityClass(GetCurrentProcess,Priority);
end;

function  GetFileDate(const FileName:AnsiString):AnsiString;
begin
  Result:=DateTimeToStr(FileDateToDateTime(FileAge(FileName)));
end;


procedure Dim(var P;const Size:Integer; Initialize:Boolean);
  {Allocate dynamic array memory}
var
  h:THandle;

  procedure RLS_MEM;
  begin
    GlobalUnlock(h);
    GlobalFree(h);
    Pointer(P):=nil;
  end;

begin
  if Size<0 then Pointer(P):=nil;
  if Pointer(P)<>nil then begin
    h := GlobalHandle(Pointer(P));
    if h = 0 then Pointer(P):= nil;
  end;
  if (Pointer(P)=nil) then begin
    if Size<>0 then begin
      if Initialize then dwI:=GPTR else dwI:=GMEM_FIXED;
      h := GlobalAlloc(dwI, ABS(Size));
      if h<>0 then Pointer(P) := GlobalLock(h);
    end;
  end else if Size=0 then
    RLS_MEM
  else begin
    dwI:=GMEM_MOVEABLE;
    if Initialize then dwI:=dwI OR GMEM_ZEROINIT;
    dwJ := GlobalReAlloc(h, Size, dwI);
    if dwJ=0 then RLS_MEM else Pointer(P):=Pointer(dwJ);
  end;
end;


function Cap(const P):Integer;
  {Report current dynamic array size}
var
  h:THandle;
begin
  Result:=0;
  h := GlobalHandle(Pointer(P));
  if h<>0 then Result:=GlobalSize(h);
end;


procedure TomCat(const S:AnsiString; var D:AnsiString; var InUse:Integer);

 {String concatenation with smart allocation.  Offers a speed advantage when
  incrementally building a resultant string (D) from many smaller fragements.
  "InUse" is a user-supplied variable updated by the procedure to track the
  portion of D actually "in use" at any time (typically less than allocated).
  Initialize to zero or Length(D) as appropriate at the outset but don't alter
  otherwise. When finished, you must use SetLength(D,InUse) to trim any unused
  excess from the resultant.

  TIP:  To significantly reduce memory requirements (with only a minor loss in
  speed), de-allocate the string fragments (using SetLength(S,0);) as they are
  added to D.

  Sorry, couldn't resist toying with the name<g>. }

var
  J:Integer;
begin
  J:=Length(D);
  if InUse>J then InUse:=J; //sanity check
  J:=Length(S)+InUse;  //memory needed to concatenate
  if J>Length(D) then
  try
    J:=iMax(Length(S),Length(D));
    SetLength(D,J shl 1); //allocate space exponentially
  except
    Exit;  //Oops, out of memory
  end;
  J:=Length(S);
//  Move(S[1],D[InUse+1],J);  //standard Delphi w/o rng chk
  MoveStr(S,1,D,InUse+1,J); //improved HyperString w/ rng chk
  InUse:=InUse+J;
end;


function  BuildTable(const Source:AnsiString):AnsiString;
  {Create a table from a range definition string for use with table driven
   search and edit routines. A range is any 2 characters separated by a dash (-).
   A definition string can include multiple ranges and individual characters.
   Max. length of resultant table = 256 characters. Returns null on error.}
begin
  SetLength(Result,256);
  asm
    Push  ESI             //save the important stuff
    Push  EDI

    Xor   EDX,EDX         //default return
    Mov   EAX,Source
    Or    EAX,EAX
    Jz    @Done           //abort if nil address
    Mov   ESI,EAX         //put address into write register
    Mov   ECX,[EAX-4]     //put length into count register
    Jecxz @Done           //bail out if zero length
    Mov   EAX,@Result     //get our resultant string
    Mov   EDI,[EAX]
    Mov   EDX,[EDI-4]     //resultant length
    Xor   EAX,EAX
    Cld                   //make sure we go forward
@Start:
    Lodsb                 //get a byte
    Cmp   AL,45           //range character ?
    Jz    @Range          //yes, then do range
    Mov   AH,AL           //save
    Stosb                 //store
    Dec   EDX             //count
    Js    @NG             //bail out if too many
    Jmp   @Skip           //do it again
@Range:
    Dec   ECX             //unexpected end of string ?
    Jecxz @NG             //yes, then bail out
    Lodsb                 //get next character
    XChg  AL,AH           //AL = Start, AH=Stop
    Cmp   AL,AH
    Jz    @Skip           //nothing to do
    Ja    @L2             //decreasing range
@L1:
    Inc   AL              //next in range
    Stosb                 //store
    Dec   EDX             //count
    Js    @NG             //bail if necessary
    Cmp   AL,AH           //done ?
    Jnz   @L1             //no, then do it again
    Jmp   @Skip
@L2:
    Dec   AL
    Stosb
    Dec   EDX
    Js    @NG
    Cmp   AL,AH
    Jnz   @L2
@Skip:
    Dec   ECX
    Jnz   @Start

    Mov   EAX,256         //calc resultant length
    Sub   EAX,EDX
    Mov   EDX,EAX
    Jmp   @Done
@NG:
    Xor   EDX,EDX
@Done:
    Mov   dwI,EDX

    Pop   EDI
    Pop   ESI             //restore the important stuff
  end;                    //and we're outta here
  Setlength(Result,dwI);
end;


procedure CharSort(var A:AnsiString);
  {In-place sort of string characters into ascending ASCII order.}
  asm
    Or    EAX,EAX          //zero source ?
    Jz    @Bail            //yes, then bail

    Push  ESI              //save the good stuff
    Push  EDI
    Push  EBX
    Push  EBP

    Push  EAX
    Call  UniqueString
    Pop   EAX

    Mov   ESI,[EAX]
    Mov   ECX,[ESI-4]
    Cmp   ECX,1
    Jle   @Exit

    Cld
    Lea   EDI,iStack
    Mov   EDX,ECX
    Mov   EBP,EDI
    Xor   EAX,EAX

    Mov   ECX,128          //Zero array
    Rep   Stosd
    Mov   ECX,EDX
    Mov   EDI,EBP
    Mov   EBX,ESI
@Start:                    //count characters
    Xor   AH,AH
    Lodsb
    Shl   EAX,1
    Mov   DX,[EDI+EAX]
    Inc   DX
    Mov   [EDI+EAX],DX
    Dec   ECX
    Jnz   @Start

    Mov   EDI,EBX
    Mov   ESI,EBP
    Mov   EDX,256
    Xor   EBX,EBX
    Xor   EAX,EAX
@Top:                      //build sorted string
    Lodsw
    Or    EAX,EAX
    Jz    @Skip
    Mov   ECX,EAX
    Mov   AX,BX
    Rep   Stosb
@Skip:
    Inc   EBX
    Dec   EDX
    Jnz   @Top
@Exit:
    Pop   EBP              //restore the world
    Pop   EBX
    Pop   EDI
    Pop   ESI
@Bail:
  end;


procedure Marquee(var S:AnsiString);
  {A fun little function which creates a rotating "marquee" effect by
   moving characters from front to back in a string. Much more efficient than
   using native functions requiring string temporaries and concatenation.}

  asm

    Push  ESI              //save the important stuff
    Push  EDI

    Or    EAX,EAX          //zero source ?
    Jz    @Exit
    Push  EAX
    Call  UniqueString
    Pop   EAX
    Mov   ESI,[EAX]
    Mov   EDI,ESI
    Mov   ECX,[ESI-4]
    Dec   ECX
    Jbe   @Exit
    Cld
    Lodsb
    Mov   AH,AL
    rep   movsb
    Mov   AL,AH
    Stosb
@Exit:
    Pop   EDI
    Pop   ESI
  end;


function GetFreq:Comp;
  {Returns high performance timer frequency in ticks per second.
   Returns 0 if counter not available.}
begin
  QueryPerformanceFrequency(XI);
{$ifdef VER100}
   Result:=XI.QuadPart;
{$else}
   Result:=XI;
{$endif}
end;


function GetCount:Comp;
  {Returns current high performance timer tick count.}
begin
  QueryPerformanceCounter(XI);
{$ifdef VER100}
   Result:=XI.QuadPart;
{$else}
   Result:=XI;
{$endif}
end;


function FirstWeek:AnsiString;
begin
  SetLength(Result,4);
  GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_IFIRSTWEEKOFYEAR,PChar(Result),Length(Result));
  SetLength(Result,StrLen(PChar(Result)));
end;


function FirstDay:AnsiString;
begin
  SetLength(Result,4);
  GetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_IFIRSTDAYOFWEEK,PChar(Result),Length(Result));
  SetLength(Result,StrLen(PChar(Result)));
end;


function SetClipText(const Source:AnsiString):Boolean;
  {Place simple text into clipboard.}
var
  Tmp: THandle;
  TmpPtr: Pointer;
begin
  Result := False;
  if Length(Source)=0 then Exit;
  if OpenClipBoard(0) then
  try
    Tmp := GlobalAlloc(GMEM_MOVEABLE, Length(Source)+1);
    try
      TmpPtr := GlobalLock(Tmp);
      try
        Move(Source[1], TmpPtr^, Length(Source)+1);
        EmptyClipBoard;
        SetClipboardData(CF_TEXT, Tmp);
        Result:=True;
      finally
        GlobalUnlock(Tmp);
      end;
    except
      GlobalFree(Tmp);
    end;
  finally
    CloseClipBoard;
  end;
end;


function GetClipText: AnsiString;
  {Retrieve simple text from clipboard}
var
  Tmp: THandle;
begin
  Result:='';
  if OpenClipBoard(0) then begin
    Tmp := GetClipBoardData(CF_TEXT);
    try
      if Tmp <> 0 then Result := PChar(GlobalLock(Tmp)) else Result := '';
    finally
      if Tmp <> 0 then GlobalUnlock(Tmp);
      CloseClipBoard;
    end;
  end;
end;


function StrDist(const S1,S2:ansiString):Integer;
  {Levenshtein string distance; the minimum number of character edits
   (insert/delete/replace) required to transform S1 into S2.  Serves as a
   similarity index, see DDJ - April,1992}

var
  r,c,n_rows,n_cols:Word;
  I,dN,dW,dNW:Word;
  M:^TWordArray;
begin
  Result:=-1;
  n_rows:=Length(S1);
  n_cols:=Length(S2);
  if (n_rows=0) or (n_cols=0) then begin
    Result:=iMax(n_rows,n_cols);
    Exit;
  end;
  if (n_rows>255) OR (n_cols>255) then Exit;
  M:=nil;
  try
    Dim(M,(n_rows+1)*(n_cols+1)*Sizeof(Word),True);
    if M<>nil then begin
      for c:=0 to n_cols do M[c]:=c;
      for r:=0 to n_rows do M[r*(n_cols+1)]:=r;
      for r:=1 to n_rows do for c:=1 to n_cols do begin
        I   := (r*(n_cols+1))+c;
        dNW := M[((r-1)*(n_cols+1))+(c-1)];
        dW  := M[(r*(n_cols+1))+(c-1)];
        dN  := M[((r-1)*(n_cols+1))+c];
        if dW<dN then begin
          if dW<dNW then
            M[I]:=dW + 1
          else begin
            if S1[r]<>S2[c] then Inc(dNW);
            M[I]:=dNW;
          end;
        end else begin
          if dN<dNW then
            M[I]:=dN + 1
          else begin
            if S1[r]<>S2[c] then Inc(dNW);
            M[I]:=dNW;
          end;
        end;
      end;
      Result:=M[((n_rows+1)*(n_cols+1))-1];
    end;
  finally
    Dim(M,0,False);
  end;
end;

//*** This function does not work as expected under the latest OS versions ***
//Perhaps as a result of public outcry over GUIDs being embedded in Office douments,
//the GUID algorithm has been changed and now appears to generate a totally random number.
//
//function CoCreateGuid(P:Pointer):Integer;stdcall;external 'ole32.dll';
//
//function GetNicAddr:AnsiString;
//  {Replaces function below.}
//var
//  T:AnsiString;
//  I:Integer;
//begin
//  Result:='';
//  SetLength(T,16);
//  if CoCreateGUID(@T[1])=S_OK then begin
//    for I:=11 to 15 do Result:=Result+IntToStr(Ord(T[I]))+'.';
//    Result:=Result+IntToStr(Ord(T[16]));
//  end;
//end;

function Netbios(P: Pointer):Char; stdcall; external 'netapi32.dll' name 'Netbios';

function GetNICAddr:AnsiString;

  {Returns Network Interface Card (NIC) hardware address in dotted decimal
   notation using NetBios functions.  Returns null string on error --- No network
   or NetBios not supported.

   Note: MSDN warns that this may not work reliably under Win95; perhaps
         reflecting the fact that Win95 can be configured without NetBios support.
         I have observed this working sporadically under new NT installs as well.
         Re-installing NetBEUI protocol seemd to fix the problem.}

const
  NCBRESET  = $32;
  NCBASTAT  = $33;
  NCBCANCEL = $35;
var
  BN,BA:AnsiString;
  I:Integer;

  function DoCmd(Cmd:Byte):Byte;
  begin
    BN[1]:=Char(Cmd);
    Result:=Ord(NetBios(@BN[1]));
  end;

begin
  Result:='';
  Setlength(BN,64);
  FillStr(BN,1,#0);
  if DoCmd(NCBRESET)=0 then begin
    Setlength(BA,600);
    FillStr(BN,1,#0);
    I:=Integer(@BA[1]);
    Move(I,BN[5],4);
    I:=Length(BA);
    Move(I,BN[9],2);
    BN[11]:='*';
    if DoCmd(NCBASTAT)=0 then begin
      for I:=1 to 5 do Result:=Result+IntToStr(Ord(BA[I]))+'.';
      Result:=Result+IntToStr(Ord(BA[6]));
    end;
  end;
end;



function iif(const Condition: Boolean; Value1, Value2: Variant): Variant;
  {Immediate if function.}
begin
  if Condition then Result := Value1 else Result := Value2;
end;


function HideInteger(const Value:Integer):AnsiString;
  {Produce an obfuscated 64-bit integer to hold a hidden 32-bit Value.
   Resultant is provided as a 16 char. hex string.}
var
  I,N:Integer;
begin
  Randomize;
  I := Random(-1);
  N := Value XOR SwapEndian(NOT (I SHL 1));
  Result:=IntToHex(I,8)+IntToHex(N,8);
end;


function SeekInteger(const S:AnsiString):Integer;
  {Decode a 32-bit integer previously obfuscated using HideInteger.}
var
  I,N:Integer;
begin
  N:=0;
  I:=0;
  if (Length(S)=16) AND IsHex(S) then begin
    I := HexToInt(LStr(S,8));
    N := HexToInt(RStr(S,8));
  end;
  Result := N XOR SwapEndian(NOT (I SHL 1));
end;


function StateAbbrev(S:AnsiString):AnsiString;
  {Returns 2 char. abbreviation for given US State name using a pre-defined
   MetaPhone lookup table. Returns '??' if not found.}
var
  I:Integer;
  J:Word;
begin
  J:=ChrToWord('??');
  if Length(S)>0 then begin
    I:=MetaPhone(S);
    I:=IntSrch(States,I,-1);
    if I>0 then J:=Abbrev[I];
  end;
  Result:=WordToChr(J);
end;


function DriveReady(const Drive: Char): Boolean;
var
  EMode: Word;
begin
  EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    Result:=DiskSize(Ord(UChar(Drive))-$40) <> -1;
  finally
    SetErrorMode(EMode);
  end;
end;


function Easter(const Year:Word):Integer;
  {Calculates Easter date for any year from 1900 to 2099 using Carter's method.
   Returns: Number of days before or after March 31; - = before, + = after.}
var
  D:Integer;
begin
  Result:=-31;
  if (Year>=1900) and (Year<=2099) then begin
    D:=((204-(11*(Year MOD 19))) MOD 30) + 21;
    if D>48 then Dec(D);
    Result:=D-24-(((Year Shr 2)+Year+D+1) MOD 7);
  end;
end;


function  DayOfWk(Year,Month,Day:Word):Word;
  {Integer day of week function}
var
  A:Integer;
begin
  A := (14-month) DIV 12;
  Year := Year - A;
  Month := Month +(12*A)-2;
  Result:=1+((day + year + (year SHR 2) - (year DIV 100) + (Year DIV 400) +
          ((31*month) DIV 12)) MOD 7);
end;


function DayOfMonth(Year,Month,Day,N:Word):Word;

  {Returns day of month for the Nth occurance of a given day of the week.
   Day = Day of week (1-7); Sunday = 1, Saturday = 7.
   N = Occurance ordinal (1-5); corresponding to first, second, third, forth
   and last in the month.

   Returns: Day of month, 1-31, zero on error.}

  function Mod7(I:Integer):Word;
  begin
    I:=I MOD 7;
    if I<0 then I:=I+7;
    Result:=Word(I);
  end;

begin

  Result:=0;
  if (Month<1) OR (Month>12) then Exit;
  if (Day<1) OR (Day>7) then Exit;
  if N<1 then Exit;
  if N>4 then begin
    N:=MonthDays[IsLeapYear(Year),Month];
    Result:=N-Mod7(DayOfWk(Year,Month,N)-Day);
  end else begin
    N:=1+((N-1)*7);
    Result:=N+Mod7(Day - DayOfWk(Year,Month,N));
  end;
end;


function  Sign(const I:Variant):Integer;
  {Returns -1 if I<0 , 1 if I>0; otherwise, zero.}
begin
  if I<0 then
    Result:=-1
  else if I>0 then
    Result:=1
  else Result:=0;
end;


function  SignDbl(const D:Double):Integer;
  {Returns -1 if D<0 , 1 if I>0; otherwise, 0}
asm
  Mov EAX,[EBP+12]
  Mov EDX,[EBP+8]
  Or  EDX,EAX
  Jz  @Done
  Sar EAX,31
  Or  EAX,1
@Done:
end;


function RadixStr(const NumStr:AnsiString; Old,New:Integer):AnsiString;
  {Convert basis of a numeric string from Old to New base within range [base2..base36]}
var
  i,j : Integer;
  Tmp,Temp:AnsiString;
  C,O,N,R:AnsiString;
begin
  Result:='';
  if not ((Old in [2..36]) AND (New in [2..36])) then Exit;
  if Old<=10 then Tmp:=BuildTable('0-'+Char(48+Old-1))
  else Tmp:=BuildTable('0-9A-'+Char(55+Old-1));
  Temp:=UpperCase(NumStr);
  i:=MakeTable(Temp,Tmp);
  if i=0 then Exit;
  Setlength(Temp,i);
  Tmp:=BuildTable('0-9A-Z');
  C:='0';
  N:=IntToStr(New);
  O:=IntToStr(Old);
  for i := 1 to Length(Temp) do begin
    j:=Ord(Temp[i]);
    if j>57 then Dec(j,55) else Dec(j,48);
    C:=StrMul(C,O);
    C:=StrAdd(C,IntToStr(j));
  end;
  while C[1]<>'0' do begin
    C:=StrDiv(C,N,R);
    i:=StrToInt(R)+1;
    Result := Tmp[i]+Result;
  end;
  if Length(Result)=0 then Result:='0'
  else if NumStr[1]='-' then Result:='-'+Result;
end;


function FormatToDateTime(S,Format:AnsiString):TDateTime;
var
  I:Integer;
  ST:TSystemTime;
begin
  Result:=0;
  if Length(S)=0 then Exit;
  UCase(Format,1,Length(Format));
  I:=ScanFF(Format,'CC',1);
  if (I>0) and (I<Length(S)) then
    ST.wYear:=StrToIntDef(CStr(S,I,2),0)*100
  else GetLocalTime(ST);
  ST.wHour:=0;
  ST.wMinute:=0;
  ST.wSecond:=0;
  ST.wMilliSeconds:=0;
  I:=ScanFF(Format,'YY',1);
  if (I>0) and (I<Length(S))then
    ST.wYear:=((ST.wYear DIV 100)*100)+StrToIntDef(CStr(S,I,2),0);
  I:=ScanFF(Format,'MM',1);
  if (I=0) OR (I>Length(S)) then Exit;
  ST.wMonth:=StrToIntDef(CStr(S,I,2),0);
  I:=ScanFF(Format,'DD',1);
  if (I=0) OR (I>Length(S)) then Exit;
  ST.wDay:=StrToIntDef(CStr(S,I,2),0);
  I:=ScanFF(Format,'HH',1);
  if (I>0) and (I<Length(S))then begin
    ST.wHour:=StrToIntDef(CStr(S,I,2),0);
    I:=ScanFF(Format,'MM',I);
    if (I>0) and (I<Length(S)) then begin
      ST.wMinute:=StrToIntDef(CStr(S,I,2),0);
      I:=ScanFF(Format,'SS',1);
      if (I>0) and (I<Length(S)) then
        ST.wSecond:=StrToIntDef(CStr(S,I,2),0);
    end;
    I:=ScanFF(Format,'AP',1);
    if (I>0) and (I<Length(S)) then begin
      if (S[I]='P') OR (S[I]='p') then begin
        if ST.wHour<12 then ST.wHour:=ST.wHour+12;
      end else if ST.wHour=12 then ST.wHour:=0;
    end;
  end;
  try
    Result:=SystemTimeToDateTime(ST);
  except
    Result:=0;
  end;
end;


function IsDateValid(S,Format:AnsiString):Boolean;
  {Verify that a string contains a valid date in specified format.}
var
  I:Integer;
  M,C,Y:Word;
  ST:TSystemTime;
begin
  Result:=False;
  if (Length(Format)<>Length(S)) OR (Length(Format)=0) then Exit;
  UCase(Format,1,Length(Format));
  for I:=1 to Length(Format) do begin
    if Format[I] in ['C','Y','M','D'] then
      Result:=IsNumChar(S[I])=False
    else Result:=Format[I]<>S[I];
  end;
  if Result then begin
    Result:=False;
    Exit;
  end;
  I:=ScanFF(Format,'MM',1);
  if I=0 then Exit;
  M:=StrToIntDef(CStr(S,I,2),0);
  if (M<1) or (M>12) then Exit;
  GetLocalTime(ST);
  I:=ScanFF(Format,'CC',1);
  if I>0 then C:=StrToIntDef(CStr(S,I,2),0) else C:=ST.WYear DIV 100;
  I:=ScanFF(Format,'YY',1);
  if I>0 then Y:=StrToIntDef(CStr(S,I,2),0) else Y:=ST.wYear MOD 100;
  if (Y=0) and (C<>20) then Exit;
  Y:=C*100+Y;
  I:=ScanFF(Format,'DD',1);
  I:=StrToIntDef(CStr(S,I,2),0);
  if I=0 then Exit;
  Result:=MonthDays[IsLeapYear(Y),M]>=I;
end;


function ReBoot:Boolean;
begin
  Result:=ExitWindowsEx(EWX_REBOOT,0);
end;


function GCD(const X,Y:DWord):DWord;
  {Returns greatest common divisor for X and Y.}
asm
  neg  eax
  jz   @L3
@L4:
  neg  eax
  xchg edx,eax
@L1:
  sub  eax,edx
  jg   @L1
  jnz  @L4
@L3:
  add  eax,edx
  jnz  @L2
  inc  eax
@L2:
end;


procedure StartSelect(const Key:Char);
begin
  keybd_event( VK_LWIN, MapvirtualKey( VK_LWIN, 0), 0, 0 );
  keybd_event( Ord(Key), MapvirtualKey(Ord(Key), 0), 0, 0 );
  keybd_event( Ord(Key), MapvirtualKey(Ord(Key), 0), KEYEVENTF_KEYUP, 0 );
  keybd_event( VK_LWIN, MapvirtualKey(VK_LWIN, 0), KEYEVENTF_KEYUP, 0 );
end;


function OpenSlot(const Name:AnsiString):THandle;
begin
  Result:=0;
  if IsNetWork then Result:=CreateMailSlot(PChar(Name),0,0,nil);
end;


function CloseSlot(const hSlot:THandle):Boolean;
begin
  Result:=CloseHandle(hSlot);
end;


function WriteSlot(const Name,Bfr:AnsiString):Boolean;
var
  I:DWord;
  hSlot:THandle;
begin
  Result:=False;
  hSlot := CreateFile(PChar(Name), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if hSlot<>INVALID_HANDLE_VALUE then begin
    if WriteFile(hSlot, Bfr[1], Length(Bfr), I, nil) then Result := (I=DWord(Length(Bfr)));
    CloseHandle(hSlot);
  end;
end;


function ReadSlot(const hSlot:THandle;var Bfr:AnsiString):Boolean;
var
  I,J,K:DWord;
begin
  Result:=False;
  if hSlot<>INVALID_HANDLE_VALUE then begin
    if GetMailSlotInfo(hSlot,nil,I,@J,@K) then begin
      if (J>0) and (I<>MAILSLOT_NO_MESSAGE) then begin
        SetLength(Bfr,I);
        if ReadFile(hSlot, Bfr[1], Length(Bfr), I, nil) then Result := (I=DWord(Length(Bfr)));
      end;
    end;
  end;
end;


function  MakePipe(const Name:AnsiString):THandle;
  {Create named pipe and allow universal access from domain. Add pipe name to
   HKLM/System/CurrentControlSet/Services/LanmanServer/Parameters/NullSessionPipes
   for access across domains. See MSKB article Q126645.}
var
  sd:TSecurityDescriptor;
  sa:TSecurityAttributes;
begin
  InitializeSecurityDescriptor(@sd,1);
  SetSecurityDescriptorDacl(@sd,True,nil,False); //allow any access request
  sa.nLength := sizeof(TSecurityAttributes);
  sa.lpSecurityDescriptor := @sd;
  sa.bInheritHandle := FALSE;
  Result:=CreateNamedPipe(PChar('\\.\pipe\'+Name),PIPE_ACCESS_DUPLEX,
          PIPE_TYPE_MESSAGE OR PIPE_READMODE_MESSAGE OR PIPE_NOWAIT,
          PIPE_UNLIMITED_INSTANCES,4096,4096,5000,@sa);
end;


function  StopPipe(const hPipe:THandle):Boolean;
  {Disconnect without destroying pipe}
begin
  Result:=False;
  if hPipe<>INVALID_HANDLE_VALUE then begin
    FlushFileBuffers(hPipe);
    if DisconnectNamedPipe(hPipe) then Result:=ConnectNamedPipe(hPipe,nil);
  end;
end;


function  StartPipe(const hPipe:THandle):Boolean;
  {Poll for client connection}
var
  I:DWord;
begin
  Result:=False;
  if hPipe<>INVALID_HANDLE_VALUE then begin
    Result:=ConnectNamedPipe(hPipe,nil);
    if Result=False then begin
      I:=GetLastError;
      if I=ERROR_PIPE_CONNECTED then Result:=True else SetLastError(I);
    end;
  end;
end;


function  OpenPipe(const Name:AnsiString):THandle;
  {Connect to existing pipe.}
begin
  Result := INVALID_HANDLE_VALUE;
  if Length(Name)>0 then begin
    if WaitNamedPipe(PChar(Name),NMPWAIT_USE_DEFAULT_WAIT) then begin
      Result:= CreateFile(PChar(Name),
               GENERIC_READ OR GENERIC_WRITE,
               FILE_SHARE_READ OR FILE_SHARE_WRITE,
               nil,
               OPEN_EXISTING,
               FILE_ATTRIBUTE_NORMAL,
               0);
    end;
  end;
end;


function  RecvPipe(const hPipe:Thandle;var Bfr:AnsiString):Boolean;
  {Receive message. Likely errors are:
   ERROR_NO_DATA (232, Client or Server)
   ERROR_PIPE_NOT_CONNECTED (233, Client)
   ERROR_BROKEN_PIPE (109, Server)}
var
  I,J:DWord;
begin
  Result:=False;
  if PeekNamedPipe(hPipe,nil,0,nil,@I,@J) then begin
    if J>0 then begin
      Setlength(Bfr,J);
      if ReadFile(hPipe, Bfr[1], J, I, nil) then Result:=(I=J);
    end else SetLastError(ERROR_NO_DATA);
  end;
end;


function  SendPipe(const hPipe:THandle;Bfr:AnsiString):Boolean;
  {Send message. Bfr is limited to 65535 bytes across network.  Likely errors are:
   ERROR_NO_DATA (232, Server)
   ERROR_PIPE_NOT_CONNECTED (233, Client)}
var
  I:DWord;
begin
  Result:=False;
  if WriteFile(hPipe, Bfr[1], Length(Bfr), I, nil) then Result := (I=DWord(Length(Bfr)));
end;


function  StatusPipe(const hPipe:Thandle):Integer;
  {Retrieves size of next waiting message (if any).}
begin
  if PeekNamedPipe(hPipe,nil,0,nil,nil,@Result)=False then Result:=-1;
end;


function  KillPipe(const hPipe:THandle):Boolean;
  {Close pipe and free all resources}
begin
  Result:=CloseHandle(hPipe);
end;


function WrapText(const Source:AnsiString;MaxWidth:Integer):AnsiString;
  {Break Source into lines of MaxWidth characters or less by inserting hard CRLF pairs.
   Pre-existing CRLF pairs remain.}
var
  I,J,K,L,N:Integer;
begin
  Result:='';
  L:=Length(Source);
  if L=0 then Exit;
  J:=1;
  repeat
    I:=ScanLU(Source,#0,#31,J);
    if I=0 then I:=L+1;
    repeat
      N:=I-J;
      if N>MaxWidth then begin
        K:=ScanRT(Source,' ,:;.?!&>]})|-=+~`',J+MaxWidth-1);
        if K>J then begin
          while (Source[K]=#32) and (K>0) do Dec(K);
          N:=K-J+1;
        end;
        if N<=0 then N:=MaxWidth;
      end;
      Result:=Result+CStr(Source,J,N)+#13#10;
      J:=J+N;
    until J=I;
    J:=I+1;
    while (J<=L) and (Source[J]<#32) do Inc(J);
  until J>L;
end;


function  GetBuildInfo(const Filename:AnsiString):AnsiString;
  {Returns verson info (if available) from FileName in dotted decimal string format:
   MajorVer.MinorVer.Release.Build}
var
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  Result:='';
  dwI := GetFileVersionInfoSize(PChar(FileName), dwJ);
  if dwI >0 then begin
    VerInfo:=nil;
    try
      GetMem(VerInfo, dwI);
      GetFileVersionInfo(PChar(FileName), 0, dwI, VerInfo);
      VerQueryValue(VerInfo, '\', Pointer(VerValue), dwJ);
      with VerValue^ do begin
        Result:=IntToStr(dwFileVersionMS shr 16)+'.';
        Result:=Result+IntToStr(dwFileVersionMS and $FFFF)+'.';
        Result:=Result+IntToStr(dwFileVersionLS shr 16)+'.';
        Result:=Result+IntToStr(dwFileVersionLS and $FFFF);
      end;
    finally
      FreeMem(VerInfo, dwI);
    end;
  end;
end;


procedure IniRC4(const Key:AnsiString);
asm
    Push  ESI             //Save the good stuff
    Push  EDI
    Push  EBX

    Mov   ESI,EAX         //String address into ESI
    Or    ESI,ESI
    Jz    @Done
    Mov   ECX,[ESI-4]     //String Length into ECX
    Jecxz @Done           //Abort on null string
    Mov   EAX,255
    Mov   EDX,EAX
    Cmp   ECX,EAX
    Jbe   @LL
    Mov   ECX,EAX
@LL:
    Lea   EDI,RCA         //array address
@L0:
    Mov   [EDI+EAX],AL
    Dec   EAX
    Jns   @L0

//    XChg  ECX,EDX
    Mov   EAX,ECX
    Mov   ECX,EDX
    Mov   EDX,EAX

    Xor   EBX,EBX
    Xor   EAX,EAX
@L1:
    Mov   DH,[ESI+EBX]
    Add   AL,DH
    Mov   BH,[EDI+ECX]
    Add   AL,BH
    Mov   DH,[EDI+EAX]
    Mov   [EDI+ECX],DH
    Mov   [EDI+EAX],BH
    Xor   BH,BH
    Inc   BL
    Cmp   BL,DL
    Jnz   @L2
    Xor   EBX,EBX
@L2:
    Dec   ECX
    Jns   @L1

@Done:
    Xor   EAX,EAX
    Mov   RCS,AX

    Pop   EBX
    Pop   EDI
    Pop   ESI
end;


procedure CryptRC4(var Source:AnsiString);
  asm
    Push  ESI             //Save the good stuff
    Push  EDI
    Push  EBX

    Push  EAX
    Call  UniqueString
    Pop   EAX

    Mov   EDI,[EAX]       //String address into EDI
    Or    EDI,EDI
    Jz    @Done
    Mov   ECX,[EDI-4]     //String Length into ECX
    Jecxz @Done           //Abort on null string
    Lea   ESI,RCA
    Xor   EAX,EAX
    Xor   EBX,EBX
    Xor   EDX,EDX
    Mov   AX,RCS
    Mov   BL,AH
    Xor   AH,AH
@L0:
    Inc   AL
    Mov   DL,[ESI+EAX]
    Add   BL,DL
    Mov   DH,[ESI+EBX]
    Mov   [ESI+EAX],DH
    Mov   [ESI+EBX],DL
    Add   DL,DH
    Xor   DH,DH
    Mov   BH,[ESI+EDX]
    Mov   AH,[EDI]
    Xor   AH,BH
    Mov   [EDI],AH
    Inc   EDI
    Xor   AH,AH
    Xor   BH,BH
    Dec   ECX
    Jnz   @L0

    Mov   AH,BL
    Mov   RCS,AX
@Done:
    Pop   EBX
    Pop   EDI
    Pop   ESI
  end;


function StrAdd(X,Y:AnsiString):AnsiString;
var
  I,J,K:Integer;
  C,S:Boolean;
begin
  Result:='';
  I:=Length(X);
  J:=Length(Y);
  C:=False;
  S:=False;
  if (I=0) OR (X[1]=#48) then begin
    Result:=Y;
    Exit;
  end;
  if (J=0) OR (Y[1]=#48) then begin
    Result:=X;
    Exit;
  end;
  if X[1]=#45 then begin
    Dec(I);
    X:=CStr(X,2,I);
    if Y[1]=#45 then begin
      Dec(J);
      Y:=CStr(Y,2,J);
      S:=True;
    end else begin
      Result:=StrSub(Y,X);
      Exit;
    end;
  end else if Y[1]=#45 then begin
    Y:=CStr(Y,2,J);
    Result:=StrSub(X,Y);
    Exit;
  end;
  repeat
    if I>0 then begin
      K:=Ord(X[I]) AND 15;
      Dec(I);
    end else K:=0;
    if J>0 then begin
      Inc(K,Ord(Y[J]) AND 15);
      Dec(J);
    end;
    if C then Inc(K);
    C:=K>9;
    if C then Dec(K,10);
    Result:=Char(K OR 48)+Result;
  until (I=0) AND (J=0);
  if C then Result:=#49+Result;
  if S then Result:=#45+Result;
end;


function StrSub(X,Y:AnsiString):AnsiString;
var
  I,J,K,M:Integer;
  C:Boolean;
begin
  Result:='';
  I:=Length(X);
  J:=Length(Y);
  C:=False;
  if (I=0) OR (X[1]=#48) then begin
    if J>0 then if Y[1]=#45 then Result:=CStr(Y,2,J) else
    if Y[1]=#48 then Result:=Y else Result:=#45+Y;
    Exit;
  end;
  if (J=0) OR (Y[1]=#48) then begin
    Result:=X;
    Exit;
  end;
  if X[1]=#45 then begin
    X:=CStr(X,2,I);
    if Y[1]=#45 then begin
      Y:=CStr(Y,2,J);
      Result:=StrSub(Y,X);
    end else Result:=#45+StrAdd(X,Y);
    Exit;
  end else if Y[1]=#45 then begin
    Y:=CStr(Y,2,J);
    Result:=StrAdd(X,Y);
    Exit;
  end;
  if I<J then begin
    Result:=#45+StrSub(Y,X);
    Exit;
  end;
  if I=J then begin
    K:=StrCmp(X,Y);
    if K=0 then begin
      Result:='0';
      Exit;
    end;
    if K<0 then begin
      Result:=#45+StrSub(Y,X);
      Exit;
    end;
  end;
  M:=I;
  SetLength(Result,I);
  repeat
    K:=Ord(X[I]) AND 15;
    if J>0 then begin
      Dec(K,Ord(Y[J]) AND 15);
      Dec(J);
    end;
    if C then Dec(K);
    C:=K<0;
    if C then Inc(K,10);
    Result[I]:=Char(K OR 48);
    if K<>0 then M:=I;
    Dec(I);
  until I=0;
  Result:=CStr(Result,M,Length(Result));
  if C then Result:=#45+StrSub(#49+DupChr(#48,Length(Result)),Result);
end;


function StrMul(X,Y:AnsiString):AnsiString;
var
  C,I,J,K,L,M,N,P:Integer;
  S:Boolean;
  Temp:AnsiString;
begin
  Result:=#48;
  I:=Length(X);
  J:=Length(Y);
  Temp:=DupChr(#0,I+J);
  S:=False;
  if (I=0) OR (J=0) OR (X[1]=#48) OR (Y[1]=#48) then Exit;
  if X[1]=#45 then begin
    Dec(I);
    X:=CStr(X,2,I);
    if Y[1]=#45 then begin
      Dec(J);
      Y:=CStr(Y,2,J)
    end else S:=True;
  end else if Y[1]=#45 then begin
    Dec(J);
    Y:=CStr(Y,2,J);
    S:=True;
  end;
  if (I=0) OR (J=0) then Exit;
  if X='1' then begin
    if S then Result:=#45+Y else Result:=Y;
    Exit;
  end;
  if Y='1' then begin
    if S then Result:=#45+X else Result:=X;
    Exit;
  end;
  M:=0;
  P:=1;
  while J>0 do begin
    K:=Ord(Y[J]) AND 15;
    Dec(J);
    C:=0;
    N:=P;
    I:=Length(X);
    while I>0 do begin
      L:=Ord(X[I]) AND 15;
      L:=(K*L)+C+Ord(Temp[N]);
      Dec(I);
      C:=L DIV 10;
      Temp[N]:=Char(L MOD 10);
      Inc(N);
    end;
    while C>0 do begin
      C := C + Ord(Temp[N]);
      Temp[N]:=Char(C MOD 10);
      C:=C DIV 10;
      Inc(N);
    end;
    if N>M then M:=N;
    Inc(P);
  end;
  I:=1;
  Dec(M);
  SetLength(Result,M);
  while M>0 do begin
    Result[M]:=Char(Ord(Temp[I]) OR 48);
    Inc(I);
    Dec(M);
  end;
  if S then Result:=#45+Result;
end;


function StrCmp(X,Y:AnsiString):Integer;
var
  I,J:Integer;
begin
  I:=Length(X);
  J:=Length(Y);
  if I=0 then begin
    Result:=J;
    Exit;
  end;
  if J=0 then begin
    Result:=I;
    Exit;
  end;
  if X[1]=#45 then begin
    if Y[1]=#45 then begin
      X:=CStr(X,2,I);
      Y:=CStr(Y,2,J);
    end else begin
      Result:=-1;
      Exit;
    end;
  end else if Y[1]=#45 then begin
    Result:=1;
    Exit;
  end;
  Result:=I-J;
  if Result=0 then Result:=CompareStr(X,Y);
end;


function StrAbs(X:AnsiString):AnsiString;
begin
  Result:=X;
  if Length(X)>1 then if X[1]=#45 then Result:=CStr(X,2,Length(X));
end;


function StrDiv(X,Y:AnsiString; var R:AnsiString):AnsiString;
var
  I,J:Integer;
  S,V:Boolean;
  T1,T2:AnsiString;
begin
  Result:=#48;
  R:=#48;
  I:=Length(X);
  J:=Length(Y);
  S:=False;
  V:=False;
  if I=0 then Exit;
  if (J=0) OR (Y[1]=#48) then begin
    Result:='';
    R:='';
    Exit;
  end;
  if X[1]=#45 then begin
    Dec(I);
    V:=True;
    X:=CStr(X,2,I);
    if Y[1]=#45 then begin
      Dec(J);
      Y:=CStr(Y,2,J)
    end else S:=True;
  end else if Y[1]=#45 then begin
    Dec(J);
    Y:=CStr(Y,2,J);
    S:=True;
  end;
  Dec(I,J);
  if I<0 then begin
    R:=X;
    Exit;
  end;
  T2:=DupChr(#48,I);
  T1:=Y+T2;
  T2:=#49+T2;
  while Length(T1)>=J do begin
    while StrCmp(X,T1)>=0 do begin
      X:=StrSub(X,T1);
      Result:=StrAdd(Result,T2);
    end;
    SetLength(T1,Length(T1)-1);
    SetLength(T2,Length(T2)-1);
  end;
  R:=X;
  if S then if Result[1]<>#48 then Result:=#45+Result;
  if V then if R[1]<>#48 then R:=#45+R;
end;


function StrHex(X:AnsiString):AnsiString;
var
  R:AnsiString;
  S:Boolean;
  I:Integer;
begin
  Result:='';
  if Length(X)>0 then begin
    S:=X[1]=#45;
    if S then X:=CStr(X,2,Length(X));
    if X[1]=#48 then begin
      Result:=X;
      Exit;
    end;
    repeat
      X:=StrDiv(X,'65536',R);
      Result:=IntToHex(StrToInt(R),4)+Result;
    until X[1]=#48;
    I:=1;
    while (I<Length(Result)) and (Result[I]=#48) do Inc(I);
    Result:=CStr(Result,I,Length(Result));
    if S then Result:=#45+Result;
  end;
end;


function StrDec(X:AnsiString):AnsiString;
var
  I,J:Integer;
  S:Boolean;
  T1,T2:AnsiString;
begin
  Result:='';
  if Length(X)>0 then begin
    S:=X[1]=#45;
    if S then X:=CStr(X,2,Length(X));
    Result:=#48;
    if X[1]=#48 then Exit;
    I:=Length(X);
    T1:='1';
    repeat
      Setlength(X,I);
      J:=HexToInt(RStr(X,4));
      T2:=StrMul(T1,IntToStr(J));
      Result:=StrAdd(Result,T2);
      T1:=StrMul(T1,'65536');
      Dec(I,4);
    until I<=0;
    if S then Result:=#45+Result;
  end;
end;


function StrRnd(X:AnsiString; Digits:Integer):AnsiString;
var
  B:Byte;
  C,S:Boolean;
  I:Integer;
begin
  Result:=X;
  if (Length(X)>0) and (Digits>0) then begin
    S:=X[1]=#45;
    I:=Length(X)-Digits+1;
    if I<2 then if S then I:=2 else I:=1;
    C:=Result[I]>#52;
    FillStr(Result,I,'0');
    Dec(I);
    while C and (I>0) do begin
      B:=Ord(Result[I]);
      C:=B=57;
      if C then B:=48
      else if B<48 then B:=49 else Inc(B);
      Result[I]:=Chr(B);
      Dec(I);
    end;
    if C then Result:='1'+Result;
    if S then begin
      if Result[1]=#45 then begin
        if (Length(Result)=1) OR (Result[2]=#48) then Result:='0';
      end else if Result[1]<>#48 then Result:=#45+Result;
    end;
  end;
end;


function URLEncode(S:AnsiString):AnsiString;
var
  I:Integer;
  C:Char;
begin
  Result:='';
  I:=Length(S);
  while I>0 do begin
    C:=S[I];
    if IsAlphaNumChar(C) or (C in ['.','-','_']) then
      Result:=C+Result
    else Result:='%'+IntToHex(Ord(C),2)+Result;
    Dec(I);
  end;
end;


function URLDecode(S:AnsiString):AnsiString;
var
  I:Integer;
  C:Char;
begin
  Result:='';
  I:=1;
  while I<=Length(S) do begin
    C:=S[I];
    if C='%' then begin
      Inc(I);
      Result := Result + Char(HexToInt(Copy(S,I,2)));
      Inc(I);
    end else if C='+' then
      Result:=Result+' '
    else if C='&' then
      Result:=Result+#13+#10
    else Result:=Result+C;
    Inc(I);
  end;
end;


function  Chaff(Source:AnsiString):AnsiString;
var
  I,J,K,H:Integer;
begin
  Result:='';
  I:=Length(Source);
  if I>0 then begin
    Randomize;
    EnCipher(Source);
    H:=Hash(Source);
    J:=I SHL 3;
    SetLength(Result,J);
    while J>0 do begin
      K:=Random(224);
      if K<32 then K:=K OR 32;
      Result[J]:=Char(K);
      Dec(J);
    end;
    Inc(J);
    while I>0 do begin
      K:=(RotR(H,1)) AND 7;
      Result[J+K]:=Source[I];
      Dec(I);
      Inc(J,8);
    end;
    Result:=Result+EncodeInt(H);
  end;
end;


function  Winnow(Source:AnsiString):AnsiString;
var
  I,J,K,H:Integer;
begin
  Result:='';
  I:=Length(Source)-6;
  if I>7 then begin
    H:=DecodeInt(RStr(Source,6));
    SetLength(Source,I);
    J:=1;
    I:=I SHR 3;
    SetLength(Result,I);
    while I>0 do begin
      K:=(RotR(H,1)) AND 7;
      Result[I]:=Source[J+K];
      Inc(J,8);
      Dec(I);
    end;
    if H=Hash(Result) then Decipher(Result) else SetLength(Result,0);
  end;
end;


function  ValidSSN(Source:AnsiString):Integer;
var
  State,Group,Serial:Integer;
begin
  Result:=-1;
  SetLength(Source,MakeNum(Source));
  if Length(Source)=9 then begin
    State:=StrToInt(LStr(Source,3));
    Group:=StrToInt(CStr(Source,4,2));
    Serial:=StrToInt(RStr(Source,4));
    if (State>0) and (State<729) and (Group<>0) and (Serial<>0) then begin
      case State of
        8..9:Result:=-1;
        581..584:Result:=-1;
        627..699:Result:=-1;
        else begin
          if (Odd(Group) AND (Group>10)) OR (State>699) then
            Result:=0
          else Result:=1;
        end;
      end;
    end;
  end;
end;


function PathScan(const FileName:AnsiString; var Path:AnsiString):Boolean;
  {Recursively search Path and all sub-directories for a user specified file name.}
var
  I,J : Integer;
  SearchRec: TSearchRec;
  NextPath, FilePath, ResultPath : AnsiString;
  Flag:Boolean;
begin
  J:=1;
  Result:=False;
  Path:=CTrim(Path,#32);
  repeat
    Flag:=False;
    I:=ScanC(Path,';',J);
    if I=0 then I:=Length(Path)+1;
    NextPath:=CStr(Path,J,I-J);
    J := I + 1;
    if Length(NextPath)>0 then begin
      if NextPath[Length(NextPath)]='*' then begin
        Flag:=True;
        SetLength(NextPath,Length(NextPath)-1);
      end;
      AddSlash(NextPath);
    end;
    if FindFirst(NextPath + FileName, SysUtils.faAnyFile, SearchRec) = 0 then begin
      ResultPath:=NextPath;
      FindClose(SearchRec);
    end;
    if Flag OR (Length(ResultPath)=0) then begin
      if FindFirst(NextPath + '*.*', SysUtils.faDirectory, SearchRec)=0 then begin
        repeat
          if (SearchRec.Attr and SysUtils.faDirectory<>0) and (SearchRec.Name[1]<>'.') then begin
             FilePath := NextPath + SearchRec.Name+'\';
             if Flag then FilePath:=FilePath+'*';
             Result := PathScan(Filename, FilePath);
             if Result then begin
               if Flag then begin
                 if Length(ResultPath)>0 then ResultPath:=ResultPath+';';
                 ResultPath:=ResultPath+FilePath;
                 Result:=False;
               end else ResultPath := FilePath;
             end;
          end;
        until Result or (FindNext(SearchRec)<>0);
//        Application.ProcessMessages;
        FindClose(SearchRec);
      end;
    end;
  until Result or (J>Length(Path));
  if Length(ResultPath)>0 then begin
    Result:=True;
    Path:=ResultPath;
  end;
end;

function  GetDomain:AnsiString;
  {Returns logon domain, null string on error}
begin
  Result:=GetKeyValues(HKEY_LOCAL_MACHINE,'System\CurrentControlSet\Services\VxD\VNETSUP',
                       'Workgroup');
end;


function  GetRelativePath(Root,Dest:AnsiString; CaseFlg:Boolean):AnsiString;
  {Returns relative path from Root to Dest, null string on error.
   Case insensitive if CaseFlg = True.}
var
  I,J:Integer;
  Tbl:AnsiString;
  Sep:Char;
begin
  Result:='';
  if CaseFlg then I:=-1 else I:=1;
  I:=ScanD(Root,Dest,I);
  if I>1 then begin
     Tbl:='\/';
     Sep:='/';
     J:=CountT(Root,Tbl,I);
     if J>0 then begin
       if ScanC(Root,Sep,I)=0 then Sep:='\';
       repeat
         Result:=Result+'..'+Sep;
         Dec(J);
       until J=0;
     end;
     J:=ScanRT(Dest,Tbl,I);
     Result:=Result+IStr(Dest,J+1)
  end else Result:=Dest;
end;


procedure AddSlash(var Path:AnsiString);
  {Just what the name says, it trims Path and adds a backslash terminator *if*
   one does not already exist.}
begin
  Path := RTrim(Path,#32);
  if (Length(Path)=0) OR (Path[Length(Path)]<>'\') then Path:=Path+'\';
end;


procedure DelSlash(var Path:AnsiString);
  {Just what the name says, it trims Path and removes the backslash terminator *if*
   one exists.}
begin
  Path := RTrim(Path,#32);
  if (Length(Path)>0) AND (Path[Length(Path)]='\') then SetLength(Path, Length(Path)-1);
end;


function MakePattern( const Source : AnsiString ) : AnsiString;
  {Compile a working pattern description from Source. Returns null string on error.
   Derived from RegExpUnit.Pas, Copyright (C) 1997, Object Dynamics Ltd.}
var
  p, pstart, i : integer;

  function Esc( const s : AnsiString; var i : integer ) : char;
  begin
    if ( s[i] <> ESCAPE ) then
      result := s[i]
    else if Length(S)<=i then
      result := ESCAPE
    else begin
      inc( i );
      if ( s[i] = 't' ) then result := TAB else result := s[i];
    end;
  end;

  function ExpandDash( delim : char; const pat : AnsiString; var i : integer ) : AnsiString;
  var
    k : char;
  begin
    result := '';
    while (pat[i] <> delim) and (i<=Length(pat)) do begin
      if ( pat[i] = ESCAPE ) then
        result := result + Esc( pat, i )
      else if ( pat[i] <> DASH ) then
        result := result + pat[i]
      else if ( Length(pat)<i ) then
        result := result + DASH
      else if IsAlphaNumChar( pat[i-1] ) and IsAlphaNumChar( pat[i+1]) then begin
        if pat[i-1] <= pat[i+1] then
          for k := char(integer(pat[i-1]) + 1) to pat[i+1] do result := result +  k
        else
          for k := char(integer(pat[i-1]) + 1) downto pat[i+1] do result := result +  k;
        inc( i );
      end else result := result + DASH;
      Inc( i );
    end;
  end;

  function ExpandCharClass( const c : AnsiString; var i : integer ) : AnsiString;
  var
    tmp : AnsiString;
  begin
    result := '';
    inc( i );
    if ( c[i] = NEGATE ) then begin
      result := result + NCCL;
      inc ( i );
    end else result := result + CCL;
    tmp := ExpandDash( CCLEND, c, i );
    if ( c[i] = CCLEND ) then result := result + char(length(Tmp)) + tmp else result := '';
  end;

begin
  i := 1;
  result := '';
  pstart := 0;
  while i<=Length(Source) do begin
    if ( Source[i] = ANY ) then begin
      pstart := Length( result ) + 1;
      result := result + ANY;
    end else if ( (Source[i] = BOL) and (i = 1)) then begin
      pstart := Length( result ) + 1;
      result := result + BOL;
    end else if ( (Source[i] =EOL) and (Length(Source)<=i)) then begin
      pstart := length( result ) + 1;
      result := result + EOL;
    end else if ( Source[i] = CCL ) then begin
      pstart := length( result ) + 1;
      result := result + ExpandCharClass( Source, i );
    end else if ( ( Source[i] = CLOSURE ) and ( i > 1 )) then begin
      p := pstart;
      pstart := length( result ) + 1;
      if ( ( p < 1 ) or (result[p] in [BOL, EOL, CLOSURE]) ) then begin
        result := '';
        exit;
      end;
      Insert( CLOSURE, result, p);
    end else begin
      pstart := length( result ) + 1;
      result := result + LITCHAR + Esc( Source, i );
    end;
    Inc( i );
  end;
end;


function ScanRX(const Source,Pattern:AnsiString; var Start:Integer):Integer;
  {Search for regular expression Pattern in Source.  If found; Result = match length,
   Start = match location; otherwise, Result = 0, Start = undefined.

   Supports case insensitive using negative start.

   Derived from RegExpUnit.Pas, Copyright (C) 1997, Object Dynamics Ltd.}
var
  CaseFlg : boolean;

  function CmpChar( c1, c2 : char) : boolean;
  begin
    if CaseFlg then Result := c1 = c2 else Result := IsCChar(C1,C2);
  end;

  function PatSize( const pat : string; n : integer ) : integer;
  begin
    Result:=0;
    if ( pat[n] = LITCHAR ) then
      result := 2
    else if ( pat[n] in [BOL, EOL, ANY, CLOSURE] ) then
      result := 1
    else if ( (pat[n] = CCL) or (pat[n] = NCCL)) then
      result := integer(pat[n+1]) + 2;
  end;

  function LocateChar( c : char; const pat : string; index : integer) : boolean;
  var
    i : integer;
  begin
    result := false;
    i := index + integer( pat[index] );
    while (i > index) and (Result=False) do begin
      Result:=CmpChar(c, pat[i]);
      dec(i );
    end;
  end;

  function MatchOne( const str : string; var i : integer; const pat : string; j : integer) : boolean;
  var
    advance : integer;
  begin
    advance := -1;
    if ( Length(str)<i ) then begin
      if ( pat[j] = EOL ) then advance := 0;
    end else if ( not (pat[j] in [LITCHAR, BOl, EOL, ANY, CCL, NCCL, CLOSURE])) then
      raise Exception.Create( 'Invalid pattern!' )
    else begin
      case pat[j] of
        LITCHAR:if ( CmpChar( str[i], pat[j+1]) ) then  advance := 1;
            BOL:if ( i = 1 ) then advance := 0;
            ANY:if ( i<=Length(str) ) then advance := 1;
            EOL:if ( Length(str)<=i ) then advance := 0;
            CCL:if ( LocateChar( str[i], pat, j+1)) then advance := 1;
           NCCL:if ( (i+1)<=Length(str)) and ( not LocateChar( str[i], pat, j+1) ) then
                advance := 1;
      end;
    end;
    result := advance>=0;
    if result then Inc(i,advance);
  end;

  function MatchPat( const str : string; index : integer; const pat : string; j : integer) : integer;
  var
    i, k : integer;
  begin
    while( j<=Length(pat) ) do begin
      if ( pat[j] = CLOSURE ) then begin
        j := j + PatSize( pat, j );
        i := index;
        while (i<=Length(str)) and ( MatchOne( str, i, pat, j)) do;  // nothing
        k:=0;
        while (i>=index) and (k=0) do begin
          k := MatchPat( str, i, pat, j + PatSize( pat, j ));
          dec( i );
        end;
        index := k;
        break;
      end else if ( not MatchOne( str, index, pat, j ) ) then begin
        index := 0;
        break;
      end else j := j + PatSize( pat, j );
    end;
    result := index;
  end;


begin
  Result := 0;
  if Start=0 then exit;
  CaseFlg := start>0;
  Start := abs(Start);
  while (Start<=Length(Source)) do begin
    Result := MatchPat( Source, Start, Pattern, 1);
    if ( Result <> 0 ) then begin
      Dec(Result,Start);
      break;
    end;
    Inc( Start );
  end;
end;


function RomanNum(Number:Integer):AnsiString;
  {Returns concise Roman numeral string representation for Number in range [1..9999]}
var
  i,j,n: integer;
  Digit,Pivot:AnsiString;
begin
  if (Number<1) or (Number>9999) then begin
    Result:='Error!';
    Exit;
  end;
  Result:='';
  Digit:='IXCM';
  Pivot:='VLD';
  for i:=1 to 3 do begin
    n := Number MOD 10;
    Number := Number Div 10;
    case n of
      1..3: for j := 1 to n do Result := Digit[i]+Result;
         4: Result := Digit[i]+Pivot[i]+Result;
      5..8: begin
              for j := 6 to n do Result:=Digit[i]+Result;
              Result:=Pivot[i]+Result;
            end;
         9: Result:=CStr(Digit,i,2)+Result;
    end;
  end;
  for i:=1 to Number do Result:='M'+Result;
end;


procedure SetFloatTolerance(X:Double);
begin
  FloatTolerance:=X;
end;


function CmpFloat(X,Y:Double):Integer;
  {Returns
      0 if X=Y +/- FloatTolerance;
     +1 if X>Y,
     -1 if X<Y}
begin
  Result:=0;
  if ABS(X-Y)>FloatTolerance then
  if X>Y then Result:=1 else Result:=-1;
end;


function CntBit(X: Integer): Integer;
  {Count 1 bits in X}
begin
  X := X and $55555555 + X shr 1 and $55555555;
  X := X and $33333333 + X shr 2 and $33333333;
  X := X and $0f0f0f0f + X shr 4 and $0f0f0f0f;
  X := X and $00ff00ff + X shr 8 and $00ff00ff;
  X := X and $0000ffff + X shr 16 and $0000ffff;
  Result := X;
end;

{
asm
  xor ecx,ecx
  clc
@top:
  adc ecx,0
  shr eax,1
  jnz @top
  adc ecx,0
  mov eax,ecx
end;
}

function UUEncode(S:AnsiString):AnsiString;
const
  Msk = 63;
  Ofs = 32;
var
  X,Y:Byte;
  I,J:Integer;
begin
  I:=(Length(S)+2) DIV 3;
  if I=0 then Exit;
  SetLength(Result,I SHL 2);
  I:=1;
  J:=1;
  while I<=Length(S) do begin
    X:=Byte(S[I]);
    Inc(I);
    if I>Length(S) then Y:=32 else Y:=Byte(S[I]);
    Inc(I);
    Result[J]:=Char((X SHR 2)+Ofs);
    Inc(J);
    Result[J]:=Char((((X SHL 4) OR (Y SHR 4)) AND Msk)+Ofs);
    Inc(J);
    if I>Length(S) then X:=32 else X:=Byte(S[I]);
    Inc(I);
    Result[J]:=Char((((Y SHL 2) OR (X SHR 6)) AND Msk)+Ofs);
    Inc(J);
    Result[J]:=Char((X AND Msk)+Ofs);
    Inc(J);
  end;
end;


function UUDecode(S:AnsiString):AnsiString;
const
  Ofs = 32;
var
  X,Y:Byte;
  I,J:Integer;
begin
  I:=Length(S) SHR 2;
  if I=0 then Exit;
  Setlength(Result,I * 3);
  I:=1;
  J:=1;
  while I<Length(S) do begin
    X:=Byte(S[I])-Ofs;
    Inc(I);
    Y:=Byte(S[I])-Ofs;
    Inc(I);
    Result[J]:=Char((X SHL 2) OR (Y SHR 4));
    Inc(J);
    X:=Byte(S[I])-Ofs;
    Inc(I);
    Result[J]:=Char((Y SHL 4) OR (X SHR 2));
    Inc(J);
    Y:=Byte(S[I])-Ofs;
    Inc(I);
    Result[J]:=Char((X SHL 6) OR Y);
    Inc(J);
  end;
end;


function ASC2HTM(Title,Text,Attributes:AnsiString):AnsiString;
const
  brk='<BR>';
  lne='<HR>';
  tbl=#9#10#13#32#44#59;
var
  I,J,K,L:Integer;
  Tag,Tmp1,Tmp2,Ftr:AnsiString;
  BFlg,OFlg,LFlg,PFlg:Boolean;

  procedure TestFlgs;
  begin
    if LFlg then begin
      Tag:='</UL>'+Tag;
      LFlg:=False;
    end;
    if OFlg then begin
      Tag:='</OL>'+Tag;
      OFlg:=False;
    end;
  end;

begin
  Result:='<html><head><title>';
  if Length(Title)=0 then Result:=Result+'No title' else Result:=Result+Title;
  Result:=Result+'</title></head><body>';
  K:=ScanN(Attributes,1);
  I:=ScanC(Attributes,'"',1);
  if (I>0) OR (K>0) then begin
    Result:=Result+'<font ';
    if K>0 then Result:=Result+'size="'+Attributes[K]+'" ';
    J:=ScanC(Attributes,'"',I+1);
    if J>0 then begin
      Result:=Result+'face='+CStr(Attributes,I,J-I+1);
      SetLength(Attributes,DeleteS(Attributes,I,J-I+1));
    end else Setlength(Attributes,I-1);
    Result:=Result+'>';
  end;
  if ScanTQ(Attributes,'bB',1)>0 then begin
    Ftr:='</B>';
    Result:=Result+'<B>';
  end;
  if ScanTQ(Attributes,'iI',1)>0 then begin
    Ftr:='</I>';
    Result:=Result+'<I>';
  end;

  if Length(Text)>0 then begin
    ReplaceSC(Text,'&','&amp',False);
    ReplaceSC(Text,'(c)','&copy;',True);
    ReplaceSC(Text,'(r)','&reg;',True);
    ReplaceSC(Text,'<','&LT',False);
    ReplaceSC(Text,'>','&GT',False);
    I:=ScanLU(Text,#160,#255,1);
    while I>0 do begin                        //escape all extended characters
      J:=Ord(Text[I]);                        //character ASCII code
      Text[I]:='&';                           //replace with escape character
      Tmp1:='#'+IntToStr(J)+';';
      if I=Length(Text) then
        Text:=Text+Tmp1
      else Insert(Tmp1,Text,I+1);              //insert the escape sequence
      I:=ScanLU(Text,#160,#255,I+1);          //find the next one
    end;
    OFlg:=False;
    LFlg:=False;
    PFlg:=False;
    I:=1;
    SetDelimiter2(#13#10);
    repeat
      BFlg:=False;
      Tag:=GetToken(Text,I);
      if Length(Tag)>0 then begin
        J:=ScanC(Tag,'[',1);
        while J>0 do begin    //build links
          K:=ScanC(Tag,']',J+1);
          if K>J then begin
            Tmp1:=CStr(Tag,J+1,K-J-1);
            L:=K+1;
            Tmp2:=ParseWord(Tag,Tbl,L);
            if Length(Tmp2)>0 then begin
              Tmp1:='<A HREF="'+Tmp2+'">'+Tmp1+'</A> ';
              Tag:=LStr(Tag,J-1)+Tmp1+IStr(Tag,L);
            end;
          end;
          J:=ScanC(Tag,'[',J+1);
        end;
        case Tag[1] of
          '#':if PFlg then
                BFlg:=True
              else begin
                Tag[1]:='>';
                Tag:='<LI'+Tag;
                if Not OFlg then begin
                  Tag:='<OL>'+Tag;
                  TestFlgs;
                  OFlg:=True;
                end;
              end;
          '*':if PFlg then
                BFlg:=True
              else begin
                Tag[1]:='>';
                Tag:='<LI'+Tag;
                if Not LFlg then begin
                  Tag:='<UL>'+Tag;
                  TestFlgs;
                  LFlg:=True;
                end;
              end;
          '-':if PFlg then
                BFlg:=True
              else begin
                Tag:='<HR>';
                TestFlgs;
              end;
          '@':begin
                Tag[1]:='>';
                if PFlg then begin
                  PFlg:=False;
                  Tag:='</PRE'+Tag;
                end else begin
                  Tag:='<PRE'+Tag;
                  TestFlgs;
                  PFlg:=True;
                end;
              end;
          '\':if PFlg then
                bFlg:=True
              else begin
                J:=CountM(Tag,'\',1);
                SetLength(Tag,DeleteS(Tag,1,J));
                J:=iMin(J,6);
                Tag:='<H'+IntToStr(J)+'>'+Tag+'</H'+IntToStr(J)+'>';
                TestFlgs;
              end;
          else begin
            if Not PFlg then TestFlgs;
            BFlg:=True;
          end;
        end;
      end;
      Result:=Result+Tag;
      if BFlg then Result:=Result+Brk;
    until NextToken(Text,I)=False;
    if LFlg then Result:=Result+'</UL>';
    if OFlg then Result:=Result+'</OL>';
    if PFlg then Result:=Result+'</PRE>';
  end;
  Result:=Result+Ftr+'</body></html>';
end;


function ClrStringLocks:Boolean;
  {Returns True if not D5 or if string thread LOCKs were cleared.}
var
  X:DWord;
asm
  Push ESI
  Push EDI
{$IFDEF VER130}   //D5 only
  Lea  ESI,System.@LStrClr
  Or   ESI,ESI
  Jz   @BadExit
  Add  ESI,18
  Call @PatchIt
  Lea  ESI,System.@LStrArrayClr
  Or   ESI,ESI
  Jz   @BadExit
  Add  ESI,24
  Lea  ESI,System.@LStrAsg
  Or   ESI,ESI
  Jz   @BadExit
  Add  ESI,36
  Call @PatchIt
  Add  ESI,16
  Call @PatchIt
  Lea  ESI,System.@LStrLAsg
  Or   ESI,ESI
  Jz   @BadExit
  Add  ESI,10
  Call @PatchIt
  Add  ESI,16
  Call @PatchIt

  Jmp  @GoodExit

@PatchIt:
  Mov  AL,[ESI] //get the opcode
  Cmp  AL,$F0   //Ok to patch
  Jnz  @Bail    //no, then bail out now
  Lea  EDI,X
  Push EDI
  Mov  EAX,PAGE_READWRITE
  Push EAX
  Mov  EAX,1
  Push EAX
  Push ESI
  Call Windows.VirtualProtect
  Or   EAX,EAX
  Jnz  @Skip
@Bail:
  Pop  EAX
  Jmp  @BadExit
@Skip:
  Mov  EAX,$90
  Mov  [ESI],AL
  Push EDI
  Mov  EAX,[EDI]
  Push EAX
  Mov  EAX,1
  Push EAX
  Push ESI
  Call Windows.VirtualProtect

  Ret

@BadExit:
  Xor  EAX,EAX
  Jmp  @Done
{$ENDIF}
@GoodExit:
  Mov  AX,True
@Done:
  Pop  EDI
  Pop  ESI
end;


function IsConsole:Boolean;
  {Returns true if a console window was created by current process.}
var
  Title:AnsiString;
begin
  SetLength(Title,64);
  Result:=GetConsoleTitle(PChar(Title),64)<>0;
end;


function IsDebugger:Boolean;
  {Returns true if the current process is running under the Delphi debugger.}
begin
  Result:=DebugHook<>0;
end;


function WinstallDate:AnsiString;
var
  S:AnsiString;
  I:DWord;
begin
  Result:='';
  if IsWinNT then
    S:=GetKeyValues(HKEY_LOCAL_MACHINE,
                    'SOFTWARE\Microsoft\Windows NT\CurrentVersion',
                    'InstallDate')
  else
    S:=GetKeyValues(HKEY_LOCAL_MACHINE,
                    'SOFTWARE\Microsoft\Windows\CurrentVersion',
                    'FirstInstallDateTime');

  if Length(S)=4 then begin
    Move(S[1],I,4);
    Result:=DateTimeToStr(FileDatetoDateTime(I));
  end;
end;


function  GetDigit(Value,N:Integer):Integer;
begin
  Result:=9999;
  if (N>0) and (N<10) then begin
    N:=IPower(10,N-1);
    Result:=(Value DIV N) MOD 10;
  end;
end;


function FetchStr(var Str: PChar): PChar;
var
  P: PChar;
begin
  Result := Str;
  if Str = nil then Exit;
  P := Str;
  while P^ = ' ' do Inc(P);
  Result := P;
  while (P^ <> #0) and (P^ <> ',') do Inc(P);
  if P^ = ',' then begin
    P^ := #0;
    Inc(P);
  end;
  Str := P;
end;


function GetPrinters: AnsiString;
var
  LineCur, Port: PChar;
  Buffer, PrinterInfo: PChar;
  I: Integer;
  Count, NumInfo: DWord;
  Flags: Integer;
  Level: Byte;
begin
  Result:='';
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    Flags := PRINTER_ENUM_CONNECTIONS or PRINTER_ENUM_LOCAL;
    Level := 4;
  end else begin
    Flags := PRINTER_ENUM_LOCAL;
    Level := 5;
  end;
  Count := 0;
  EnumPrinters(Flags, nil, Level, nil, 0, Count, NumInfo);
  if Count = 0 then Exit;
  GetMem(Buffer, Count);
  try
    if not EnumPrinters(Flags, nil, Level, PByte(Buffer), Count, Count, NumInfo) then Exit;
    PrinterInfo := Buffer;
    for I := 0 to NumInfo - 1 do begin
      if Level = 4 then
        with PPrinterInfo4(PrinterInfo)^ do  begin
          if Length(Result)>0 then Result:=Result+';';
          Result:=Result+pPrinterName;
          Inc(PrinterInfo, sizeof(TPrinterInfo4));
        end
      else
        with PPrinterInfo5(PrinterInfo)^ do begin
          LineCur := pPortName;
          Port := FetchStr(LineCur);
          while Port^ <> #0 do begin
            if Length(Result)>0 then Result:=Result+';';
            Result:=Result+pPrinterName;
            Port := FetchStr(LineCur);
          end;
          Inc(PrinterInfo, sizeof(TPrinterInfo5));
        end;
    end;
  finally
    FreeMem(Buffer, Count);
  end;
end;


function GetDocType(fileExt:AnsiString):AnsiString;
  {Returns document identifier given a registered file extension.  Null string on error.}
var
  hTmp:HKEY;
  s:Integer;
  dt:DWord;
  buffer:AnsiString;
begin
  Result:='';

  s := 128;
  SetLength(buffer,s);

  if RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar(fileExt),0,KEY_ALL_ACCESS,hTmp) <> ERROR_SUCCESS then exit;
  RegQueryValueEx(hTmp,nil,nil,@dt,@buffer[1],@s);
  RegCloseKey(hTmp);
  if s=0 then exit;

//  OverWrite(buffer,'\shell\open\command'+#0,s);

  s:=128;
  if RegOpenKeyEx(HKEY_CLASSES_ROOT, PChar(buffer), 0,KEY_ALL_ACCESS,hTmp) <> ERROR_SUCCESS then exit;
  RegQueryValueEx(hTmp, nil, nil, @dt, @buffer[1], @s);
  RegCloseKey(hTmp);

  Result:=Buffer;
  SetLength(Result,s-1);
//  ExpandEnvironmentStrings(PChar(buffer), PChar(Result), s);

end;


function RandomText(L:Integer; Table:AnsiString):AnsiString;
  //Returns random text of length L using characters from Table
var
  R:Integer;
begin
  Setlength(Result,0);
  R:=Length(Table);
  if (L>0) and (R>0) then begin
    Randomize;
    SetLength(Result, L);
    while L>0 do begin
      Result[L]:=Table[1+Random(R)];
      Dec(L);
    end;
  end;
end;


procedure SetQuotes(const QStart,QEnd:Char);
begin
  QS:=QStart;
  QE:=QEnd;
end;


initialization
  GetSeps;
finalization
  if hMutex<>0 then ReleaseMutex(hMutex);
end.
