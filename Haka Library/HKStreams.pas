unit HKStreams;

interface
uses classes,sysutils,variants;

procedure WriteVar(Const Str: String; Stream: TStream); overload;
Procedure ReadVar(out Str: String; Stream: TStream); overload;

procedure WriteVar(Int: LongInt; Stream: TStream); overload;
Procedure ReadVar(out int: LongInt; Stream: TStream); overload;
Function ReadVar(Stream: TStream) : LongInt; overload;

procedure WriteVar(Bool: Boolean; Stream: TStream); overload;
Procedure ReadVar(out Bool: Boolean; Stream: TStream); overload;

procedure WriteVar(SourceStream: TStream; Stream: TStream); overload;
Procedure ReadVar(SourceStream: TStream; Stream: TStream); overload;

procedure WriteVar(Strings : TStrings; Stream: TStream); overload;
Procedure ReadVar(Strings : TStrings; Stream: TStream); overload;

procedure WriteStr(Const S: String; Stream: TStream);
Procedure ReadStr(out S: String; Stream: TStream); overload;
Function ReadStr(Stream : TStream) : String; overload;

procedure ReadVarArray(Ms : TStream; var Data : array of variant);
Procedure WriteVarArray(Ms : TStream; const Data : array of variant);

procedure WriteStr32(Const S: String; Stream: TStream);
Procedure ReadStr32(out S: String; Stream: TStream);

implementation

procedure WriteVar(Strings : TStrings; Stream: TStream);
begin
 WriteVar(strings.Text,stream);
end;

Procedure ReadVar(Strings : TStrings; Stream: TStream);
var s:string;
begin
 ReadVar(s,stream);
 strings.Text:=s;
end;

procedure WriteVar(SourceStream: TStream; Stream: TStream);
var i:Integer;
begin
 i:=SourceStream.Size;
 WriteVar(i,stream);
 Stream.CopyFrom(SourceStream,0)
end;

Procedure ReadVar(SourceStream: TStream; Stream: TStream);
var i:Integer;
begin
 ReadVar(i,stream);
 SourceStream.CopyFrom(Stream,i);
end;

procedure WriteVar(Const Str: String; Stream: TStream);
begin
 WriteStr(str,stream);
end;

Procedure ReadVar(out Str: String; Stream: TStream);
begin
 readstr(str,stream);
end;

procedure WriteVar(Int: LongInt; Stream: TStream);
begin
 stream.Write(int,sizeof(int));
end;

Function ReadVar(Stream: TStream) : LongInt; overload;
begin
 stream.Read(result,sizeof(Result));
end;

Procedure ReadVar(out int: LongInt; Stream: TStream); overload;
begin
 stream.Read(int,sizeof(int));
end;

procedure WriteVar(Bool: Boolean; Stream: TStream); overload;
begin
 stream.Write(Bool,sizeof(Bool));
end;


Procedure ReadVar(out Bool: Boolean; Stream: TStream); overload;
begin
 stream.Read(Bool,sizeof(Bool));
end;

procedure WriteStr(Const S: String; Stream: TStream);
var
 i:LongWord;
begin
 i:=length(s);
 stream.Write(i,sizeof(i));
 stream.write(pchar(s)^,i);
end;

Function ReadStr(Stream : TStream) : String; overload;
var
 i:LongWord;
begin
 stream.Read(i,sizeof(i));
 setlength(result,i);
 stream.Read(pchar(result)^,i);
end;

Procedure ReadStr(out S: String; Stream: TStream); overload;
var
 i:LongWord;
begin
 stream.Read(i,sizeof(i));
 if stream.Size-stream.Position>=i then
 begin
  setlength(s,i);
  stream.Read(pchar(s)^,i);
 end
  else s:='';
end;

procedure WriteStr32(Const S: String; Stream: TStream);
var
 i:Word;
begin
 i:=length(s);
 stream.Write(i,sizeof(i));
 stream.write(s[1],i);
end;

Procedure ReadStr32(out S: String; Stream: TStream);
var
 i:Word;
begin
 stream.Read(i,sizeof(i));
 if stream.Size-stream.Position>=i then
 begin
  setlength(s,i);
  stream.Read(s[1],i);
 end
  else s:='';
end;


Procedure WriteVarArray(Ms : TStream; const Data : array of variant);
var c:integer;
 si : smallint; int : integer; sin : single; doub : double;
 curr : currency; dt : tdatetime; st : string; bool : boolean;
 b : byte;
begin
 for c:=0 to length(data)-1 do
 begin

  {WRITE HEADER}

  int:=vartype(data[c]);
  case int of
   varstring : b:=$12;
   vartypemask : b:=$13;
   varArray : b:=$14;
   varByRef : b:=$15;
   else b:=int;
  end;
  ms.write(b,sizeof(b));

  {WRITE DATA}

  case vartype(data[c]) of
   varSmallInt : begin si:=data[c]; ms.write(si,sizeof(si)); end;
   varInteger : begin int:=data[c]; ms.write(int,sizeof(int)); end;
   varsingle : begin sin:=data[c]; ms.write(sin,sizeof(sin)); end;
   varDouble : begin doub:=data[c]; ms.write(doub,sizeof(doub)); end;
   varCurrency : begin curr:=data[c]; ms.write(curr,sizeof(curr)); end;
   varDate : begin dt:=vartodatetime(data[c]); ms.write(dt,sizeof(dt)); end;
   varOlestr,varString : begin st:=vartostr(data[c]); writestr(st,ms); end;
   varBoolean : begin bool:=data[c]; ms.write(bool,sizeof(bool)); end;
   varByte : begin b:=data[c]; ms.write(b,sizeof(b)); end;
  end;
 end;
end;

procedure ReadVarArray(Ms : TStream; var Data : array of variant);
var c,t:integer;
 si : smallint; int : integer; sin : single; doub : double;
 curr : currency; dt : tdatetime; st : string; bool : boolean;
 b : byte;
begin
 for c:=0 to length(data) -1 do
 begin
  ms.read(b,sizeof(b));
  case b of
   $12 : t:=varString;
   $13 : t:=varTypeMask;
   $14 : t:=varArray;
   $15 : t:=varByRef;
   else t:=b;
  end;
  data[c]:=varastype(data[c],t);
  case t of
   varSmallInt : begin ms.read(si,sizeof(si)); data[c]:=si; end;
   varInteger : begin ms.read(int,sizeof(int)); data[c]:=int; end;
   varsingle : begin ms.read(sin,sizeof(sin)); data[c]:=sin; end;
   varDouble : begin ms.read(doub,sizeof(doub)); data[c]:=doub; end;
   varCurrency : begin ms.read(curr,sizeof(curr)); data[c]:=curr; end;
   varDate : begin ms.read(dt,sizeof(dt)); data[c]:=varFromDateTime(dt); end;
   varOlestr,varString : begin readstr(st,ms); data[c]:=st; end;
   varBoolean : begin ms.read(bool,sizeof(bool)); data[c]:=bool; end;
   varByte : begin ms.read(b,sizeof(b)); data[c]:=b; end;
  end;
 end;
end;

end.
