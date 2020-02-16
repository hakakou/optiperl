unit HKDebug;
{$I REG.INC}

interface
uses Sysutils,Windows,dateutils,
    {$IFDEF SENDDEBUG}dialogs,dbugintf, {$ENDIF}
     variants;

{$IFDEF SENDDEBUG}
procedure SendDebug(Const Msg : String); overload;
procedure SendDebug(vars : array of const); overload;
procedure SendDebug(Avar : variant); overload;
Procedure StartTime;
Procedure ShowElapsed(const msg : String);
{$ENDIF}

Procedure HKLog(Const msg : String = '');

implementation
var
 LogDo : Boolean = false;
 LogFile : String = '';

Procedure HKLog(Const msg : String = '');
var
 LogText : TextFile;
 D:String;
begin
 If LogDo then
 begin
  AssignFile(logText,LogFile);
  Append(LogText);
  d:=DateTimeToStr(now)+' - ';
  if length(msg)=0
   then d:=d+'Check'
   else d:=d+msg;
  WriteLN(LogText,d);
  close(LogText);
 end;
end;

{$IFDEF SENDDEBUG}
var
 TempLine : String = '';
 StartCounter : TDateTime;

Const
 MaxChars = 100;
 MaxLen = 20;

procedure GlobalSendDebug(const Msg: string);
begin
//mtWarning, mtError, mtInformation, mtConfirmation
 SendDebugEx(Msg, mtInformation);
end;

Procedure StartTime;
begin
 StartCounter:=now;
end;

Procedure ShowElapsed(const msg : String);
begin
 senddebugEx(msg+': '+IntToStr(MilliSecondsBetween(now,StartCounter)),mtConfirmation);
end;

procedure SendDebug(Const Msg : String);
begin
 GlobalSendDebug(msg);
end;

Function SafeVarToStr(Avar : Variant) : String;
begin
 try
  if (VarIsNull(Avar)) then result:='(Null)' else
  if (VarIsEmpty(Avar)) then result:='(Empty)' else
   result:=AVar;
 except
  on EVariantError do result:='(Other)';
 end;
end;

function MakeStr(const Arg: TVarRec): string;
const
 BoolStr: array[Boolean] of String = ('False', 'True');
begin
 Result := '';
 with Arg do
  case VType of
   vtInteger:    Result := IntToStr(VInteger);
   vtBoolean:    Result := BoolStr[VBoolean];
   vtChar:       Result := VChar;
   vtExtended:   Result := FloatToStr(VExtended^);
   vtString:     Result := VString^;
   vtPChar:      Result := VPChar;
   vtObject:     Result := VObject.ClassName;
   vtClass:      Result := VClass.ClassName;
   vtAnsiString: Result := string(VAnsiString);
   vtCurrency:   Result := CurrToStr(VCurrency^);
   vtVariant:    Result := SafeVarToStr(VVariant^);
   vtInt64:      Result := IntToStr(VInt64^);
  end;
end;

Procedure FlushDebug;
begin
 delete(TempLine,length(templine)-2,3);
 GlobalSendDebug(TempLine);
 TempLine:='';
end;

Procedure AddToDebug(const s:string);
begin
 TempLine:=TempLine+Copy(s,1,maxlen)+' ÿ ';
 if length(TempLine)>MaxChars then FlushDebug;
end;

procedure SendDebug(Avar : variant); overload;
var c : integer;
begin
 if VarIsArray(AVar) then begin
  for c:=VararraylowBound(AVar,1) to VararrayHighBound(AVar,1) do
   AddToDebug('['+IntToStr(c)+'] '+SafeVarToStr(Avar[c]));
 end else
  AddToDebug(SafeVarToStr(Avar));
 FlushDebug;
end;

procedure SendDebug(vars : array of const); overload;
var a:integer;
begin
 for a:=0 to length(vars) -1 do
  AddToDebug(MakeStr(vars[a]));
 FlushDebug;
end;

procedure AssertHandler(const Message, Filename: string; LineNumber: Integer; ErrorAddr: Pointer);
var f:string;
begin
 F:=ExtractFilename(filename);
 if length(f)>=4 then setlength(f,length(f)-4);
 if length(f)>0
  then f:=f+':'+inttostr(linenumber)
  else f:=inttostr(linenumber);

 if Uppercase(copy(message,1,3))='LOG'
 then
  SendDebug(copy(Message,5,length(message))+' - '+f)
 else
  raise EAssertionFailed.Create(message+' - '+f);
end;

{$ENDIF}

Procedure StartLog;
var
 LogText : TextFile;
begin
 LogDo:=ParamStr(1)='/e0';
 if LogDo then
 begin
  LogFile:=extractfilename(paramstr(0))+'.txt';
  assignfile(logText,logFile);
  if FileExists(logFile)
   then Append(logText)
   else ReWrite(LogText);
  Writeln(LogText,'--- File OK');
  close(logText);
 end;
end;

initialization
{$IFOPT C+}
 asserterrorProc:=AssertHandler;
 StartCounter:=now;
{$ENDIF}
 try
  StartLog;
 except
  LogDo:=false;
 end;
// assignfile(output,'c:\trace.txt');
finalization
// closefile(output);
end.
