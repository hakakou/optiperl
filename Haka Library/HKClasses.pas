unit HKClasses;

interface
uses classes,windows,sysutils,hyperstr,hakahyper,hakageneral;

type

 THKStringList = Class(TStringList)
 public
  Constructor Create(IsSorted,IsCaseSensitive : Boolean; Dups: TDuplicates);
 end;

 EKeyNotFoundError = class(Exception);
 EDuplicateKeyError = class(Exception);
 EOutOfRange=class(EListError);

 Type
 THashList = Class(TStringList)
 private
  FLiteralDel : Char;
  FDoubleLiteralDel : String;
  procedure SetLiteralDel(const C: Char);
 protected
  FValues: TStringList;
  function GetValue(Const Key : String): string;
  procedure PutValue(Const Key : String; const S: string);
  function GetObject(Const Key : String): TObject;  reintroduce;
  procedure PutObject(Const Key : String; AObject: TObject); reintroduce;
  function GetTextStr : string; override;
  procedure SetTextStr(const S: string); override;
  Function GetSimpleText : String;
  procedure SetSimpleText(const S: string);
 public
  HashDel,LineDel : Char;
  LastParseWasGood : Boolean;
  property Value[const Key: String]: String read GetValue write PutValue;
  property Objects[const Key: String]: TObject read GetObject write PutObject;
  constructor Create(ISSorted, IsCaseSensitive : Boolean; Dups: TDuplicates);
  function Add(const Key,Value: string): Integer; reintroduce;
  function AddObject(Const Key,Value: string; AObject: TObject): Integer; reintroduce;
  procedure Delete(Index: Integer); override;
  procedure DeleteKey(Const Key : String);
  procedure Insert(Index: Integer; const key,Value: string); reintroduce;
  procedure Clear; override;
  Procedure GetHash(index : Integer; Out key,Value: string);
  Function GetTObject(index : Integer) : TObject;
  Function GetInteger(index : Integer) : Integer;
  Function ValueAt(index : Integer) : String;
  destructor Destroy; override;
  property Text: String read GetTextStr write SetTextStr;
  property SimpleText: String read GetSimpleText write SetSimpleText;
  Property LiteralChar : Char read FLiteralDel write SetLiteralDel;
 end;

 Procedure ParsePeriodAndEqual(const Text:string; Hash : THashList);
 //Both key and value must be present! Null not allowed on either.

type

 TIntegerList = class(TPersistent)
 private
   FList:TList;
   FDuplicates:TDuplicates;
   FMin:LongInt;
   FMax:LongInt;
   FSizeOfLong:Integer;
   FSorted:Boolean;
   procedure ReadMin(Reader:TReader);
   procedure WriteMin(Writer:TWriter);
   procedure ReadMax(Reader:TReader);
   procedure WriteMax(Writer:TWriter);
   procedure ReadIntegers(Reader:TReader);
   procedure WriteIntegers(Writer:TWriter);
   procedure SetSorted(Value:Boolean);
   procedure QuickSort(L,R:Integer);
 protected
   procedure DefineProperties(Filer:TFiler);override;
   function Find(N:LongInt;var Index:Integer):Boolean;virtual;
   function GetCount:Integer;
   function GetItem(Index:Integer):LongInt;
   procedure SetItem(Index:Integer;Value:LongInt);virtual;
   procedure SetMin(Value:LongInt);
   procedure SetMax(Value:LongInt);
   procedure Sort;virtual;
 public
   constructor Create;
   destructor Destroy;override;

   function Add(Value:LongInt):Integer;virtual;
   procedure AddIntegers(List:TIntegerList);virtual;
   procedure Assign(Source:TPersistent);override;
   procedure AssignTo(Dest:TPersistent);override;
   procedure Clear;virtual;
   procedure Delete(Index:Integer);virtual;
   function Equals(List:TIntegerList):Boolean;
   procedure Exchange(Index1,Index2:Integer);virtual;
   function IndexOf(N:LongInt):Integer;virtual;
   procedure Insert(Index:Integer;Value:LongInt);virtual;
   procedure Move(CurIndex,NewIndex:Integer);virtual;

   property Duplicates:TDuplicates read FDuplicates write FDuplicates;
   property Count:Integer read GetCount;
   property Items[Index:Integer]:LongInt read GetItem write SetItem; default;
   property Min:LongInt read FMin write SetMin;
   property Max:LongInt read FMax write SetMax;
   property Sorted:Boolean read FSorted write SetSorted;
 end;


implementation

Procedure ParsePeriodAndEqual(const Text:string; Hash : THashList);
var
 i : integer;
 w,v1,v2 : string;
begin
 hash.Clear;
 I := 1;
 repeat
  W := Parse(text,';',I);
  if not parsewithequal(w,v1,v2) then continue;
  if (length(v1)=0) or (length(v2)=0) then continue;
  hash.Add(v1,v2);
 until (I<1) or (I>Length(text));
end;

{ THashList }

function THashList.Add(const Key,Value: string): Integer;
begin
 Result:=inherited AddObject(key,TObject(FValues.Add(value)));
end;

function THashList.AddObject(const Key, Value: string; AObject: TObject): Integer;
begin
 Result:=inherited AddObject(key,TObject(FValues.AddObject(value,AObject)));
end;

procedure THashList.Clear;
begin
 inherited Clear;
 FValues.Clear;
end;

constructor THashList.Create(ISSorted, IsCaseSensitive : Boolean; Dups: TDuplicates);
begin
 inherited Create;
 FValues:=TStringList.Create;
 CaseSensitive:=IsCaseSensitive;
 Sorted:=ISSorted;
 Duplicates:=dups;
 LiteralChar:='\';
 HashDel:='=';
 LineDel:='&';
end;

procedure THashList.DeleteKey(const Key: String);
var i:integer;
begin
 i:=IndexOf(key);
 if i>=0
  then
   begin
    FValues.Delete(integer(inherited objects[i]));
    inherited delete(i);
   end
  else EKeyNotFoundError.Create('Key '+key+' not found.');
end;

procedure THashList.Delete(Index: Integer);
begin
 FValues.Delete(Integer(inherited Objects[Index]));
 inherited Delete(Index);
end;

destructor THashList.Destroy;
begin
 inherited Destroy;
 FValues.Free;
end;

procedure THashList.PutValue(const Key, S: string);
var i:integer;
begin
 i:=indexof(key);
 if i>=0
  then FValues[Integer(inherited objects[i])]:=s
  else add(key,s);
end;

function THashList.GetValue(const Key: String): string;
var i:integer;
begin
 i:=IndexOf(key);
 if i>=0
  then result:=FValues[integer(inherited objects[i])]
  else EKeyNotFoundError.Create('Key '+key+' not found.');
end;

function THashList.GetObject(const Key: String): TObject;
var i:integer;
begin
 i:=IndexOf(key);
 if i>=0
  then result:=FValues.Objects[integer(inherited objects[i])]
  else
   begin
    result:=nil;
    EKeyNotFoundError.Create('Key '+key+' not found.');
   end;
end;

procedure THashList.PutObject(const Key: String; AObject: TObject);
var i:integer;
begin
 i:=indexof(key);
 if i>=0
  then FValues.Objects[Integer(inherited objects[i])]:=AObject
  else addObject(key,'',AObject);
end;


constructor THKStringList.Create(IsSorted, IsCaseSensitive: Boolean;
  Dups: TDuplicates);
begin
 inherited Create;
 Sorted:=IsSorted;
 Duplicates:=dups;
 CaseSensitive:=IsCaseSensitive
end;


procedure THashList.Insert(Index: Integer; const key, Value: string);
begin
 inherited insert(index,key);
 inherited objects[index]:=TObject(FVAlues.count);
 FValues.Add(value);
end;

procedure THashList.GetHash(index: Integer; out key, Value: string);
begin
 key:=strings[index];
 value:=FValues[integer(inherited objects[index])];
end;

function THashList.GetInteger(index: Integer): Integer;
begin
 result:=Integer(FValues.Objects[integer(inherited objects[index])]);
end;

function THashList.GetTObject(index: Integer): TObject;
begin
 result:=(FValues.Objects[integer(inherited objects[index])]);
end;

function THashList.GetTextStr: string;
var
 i:integer;
 s1,s2 : String;
begin
 result:='';
 for i:=0 to count-1 do
 begin
  s1:=Strings[i];
  replaceSC(s1,FliteralDel,FDoubleLiteralDel,false);
  replaceSC(s1,HashDel,FliteralDel+HashDel,false);
  replaceSC(s1,LineDel,FliteralDel+LineDel,false);
  s2:=ValueAt(i);
  replaceSC(s2,FliteralDel,FDoubleLiteralDel,false);
  replaceSC(s2,HashDel,FliteralDel+HashDel,false);
  replaceSC(s2,LineDel,FliteralDel+LineDel,false);
  result:=result+s1+HashDel+s2+linedel;
 end;
 if count>0 then
  setlength(result,length(result)-length(linedel));
end;

procedure THashList.SetTextStr(Const S: string);
var
  w,s1,s2:string;
  i,j:integer;
begin
 clear;
 LastParseWasGood:=true;
 BeginUpdate;
 I := 1;
 repeat
  W := ParseWithLit(S,linedel,FLiteralDel,I);
  J:=1;
  s1 := ParseWithLit(w,Hashdel,FLiteralDel,j);
  replaceSC(s1,FDoubleLiteralDel,FliteralDel,false);
  if (j<1) or (J>length(w))
   then
    begin
     add(s1,'');
     LastParseWasGood:=not ((count=1) and (j<1))
    end
   else
    begin
     s2:=copyFromToEnd(w,j);
     s2:=StringWithoutLiteral(s2,FLiteralDel);
     Add(s1,s2);
     LastParseWasGood:=true;
    end;
 until (I<1) or (I>Length(S));
 EndUpdate;
end;

function THashList.GetSimpleText: String;
var
 i:integer;
 s:string;
begin
 result:='';
 for i:=0 to count-1 do
 begin
  s:=Strings[i];
  replaceSC(s,HashDel,FliteralDel+HashDel,false);
  result:=result+s+HashDel+valueat(i)+#13#10;
 end;
end;


procedure THashList.SetSimpleText(const s: String);
var
  w,s1,s2:string;
  i,j:integer;
  sl:TStringList;
begin
 LastParseWasGood:=true;
 sl:=TStringList.Create;
 sl.Text:=s;
 clear;
 BeginUpdate;
 for i:=0 to sl.count-1 do
 begin
    J:=1;
    w:=sl.strings[i];
    s1 := ParseWithLit(w,Hashdel,FLiteralDel,j);
    if not ((j<1) or (J>length(w))) then
    begin
     replaceSC(s1,FDoubleLiteralDel,FliteralDel,false);
     s2:=copyFromToEnd(w,j);
     s2:=StringWithoutLiteral(s2,FliteralDel);
     add(s1,s2);
     LastParseWasGood:=true;
    end
     else
    begin
     s1:=StringWithoutLiteral(s1,FliteralDel);
     add(s1,'');
     LastParseWasGood:=not ((count=1) and (j<1))
    end;
 end;
 sl.free;
 EndUpdate;
end;


function THashList.ValueAt(index: Integer): String;
begin
 result:=FVAlues[integer(inherited Objects[index])];
end;

procedure THashList.SetLiteralDel(const C: Char);
begin
 FLiteralDel:=c;
 FDoubleLiteralDel:=c+c;
end;




////////////////////////////////////////////////////////////////////////////////

constructor TIntegerList.Create;
begin
 inherited Create;
 FList:=TList.Create;
 FSizeOfLong:=SizeOf(LongInt);
end;

destructor TIntegerList.Destroy;
begin
 Clear;
 FList.Free;
 inherited Destroy;
end;

procedure TIntegerList.Assign(Source:TPersistent);
begin
 if Source is TIntegerList then
  begin
   Clear;
   AddIntegers(TIntegerList(Source));
  end
 else
  inherited Assign(Source);
end;

procedure TIntegerList.DefineProperties(Filer:TFiler);
begin
 Filer.DefineProperty('Min',ReadMin,WriteMin,FMin<>0);
 Filer.DefineProperty('Max',ReadMax,WriteMax,FMax<>0);
 Filer.DefineProperty('Integers',ReadIntegers,WriteIntegers,Count>0);
end;

procedure TIntegerList.ReadMin(Reader:TReader);
begin
 FMin:=Reader.ReadInteger;
end;

procedure TIntegerList.WriteMin(Writer:TWriter);
begin
 Writer.WriteInteger(FMin);
end;

procedure TIntegerList.ReadMax(Reader:TReader);
begin
 FMax:=Reader.ReadInteger;
end;

procedure TIntegerList.WriteMax(Writer:TWriter);
begin
 Writer.WriteInteger(FMax);
end;

procedure TIntegerList.ReadIntegers(Reader:TReader);
begin
 Reader.ReadListBegin;
 Clear;
 while not Reader.EndOfList do
   Add(Reader.ReadInteger);
 Reader.ReadListEnd;
end;

procedure TIntegerList.WriteIntegers(Writer:TWriter);
var I:Integer;
begin
 Writer.WriteListBegin;
 for I:=0 to Count-1 do
  Writer.WriteInteger(GetItem(I));
 Writer.WriteListEnd;
end;

procedure TIntegerList.SetSorted(Value:Boolean);
begin
 if FSorted<>Value then
  begin
   if Value then Sort;
   FSorted:=Value;
  end;
end;

function TIntegerList.GetCount:Integer;
begin
 Result:=FList.Count;
end;

function TIntegerList.GetItem(Index:Integer):LongInt;
begin
 Result:=PLongInt(FList.Items[Index])^;
end;

procedure TIntegerList.SetItem(Index:Integer;Value:LongInt);
begin
 if (FMin<>FMax) and ((Value<FMin) or (Value>FMax))
  then raise EOutOfRange.CreateFmt(
   'Value must be within %d..%d',[FMin,FMax]);
 PLongInt(FList.Items[Index])^:=Value;
end;

procedure TIntegerList.SetMin(Value:LongInt);
var I:Integer;
begin
 if Value<>FMin then
 begin
   for I:=0 to Count-1 do
   begin
     if GetItem(I)<Value then
      raise EOutOfRange.CreateFmt(
       'Unable to set new minimum value.'#13+
       'List contains values below %d',[Value]);
   end;{ for }
   FMin:=Value;
   if FMin>FMax then FMax:=FMin;
 end; { if }
end;

procedure TIntegerList.SetMax(Value:LongInt);
var I:Integer;
begin
 if Value<>FMax then
 begin
   for I:=0 to Count-1 do
   begin
     if GetItem(I)>Value then
      raise EOutOfRange.CreateFmt(
       'Unable to set new maximum value.'#13+
       'List contains values above %d',[Value]);
   end;{ for }
   FMax:=Value;
   if FMax<FMin then FMin:=FMax;
 end; { if }
end;

procedure TIntegerList.AddIntegers(List:TIntegerList);
var I:Integer;
begin
 for I:=0 to Pred(List.Count) do
  Add(List[I]);
end;

function TIntegerList.Add(Value:LongInt):Integer;
begin
 if FDuplicates<>dupAccept
 then begin
  Result:=IndexOf(Value);
  if Result>=0 then
  begin
   if FDuplicates=dupIgnore then Exit;
   if FDuplicates=dupError then raise EListError.CreateFmt('Value %d already exists in the no duplicates list',[Value]);
  end;
 end;
 Insert(Count,Value);
 if Sorted then begin Sorted:=False; Sorted:=True; end;
 Result:=IndexOf(Value);
end;

procedure TIntegerList.Clear;
var I:Integer;
begin
 for I:=0 to Pred(FList.Count) do
  Dispose(PLongInt(FList.Items[I]));
 FList.Clear;
end;

procedure TIntegerList.Delete(Index:Integer);
begin
 Dispose(PLongInt(FList.Items[Index]));
 FList.Delete(Index);
end;

function TIntegerList.Equals(List:TIntegerList):Boolean;
var I,Count:Integer;
begin
 Count:=GetCount;
 if Count<>List.GetCount
  then Result:=False
  else
  begin
   I:=0;
   while (I<Count) and ( GetItem(I)=List.GetItem(I) ) do
    Inc(I);
   Result:=I=Count;
  end; {if else }
end;

procedure TIntegerList.Exchange(Index1,Index2:Integer);
begin
 FList.Exchange(Index1,Index2);
end;

{ List must be sorted }
function TIntegerList.Find(N:LongInt;var Index:Integer):Boolean;
var L,H,I:Integer;
begin
 Result:=False;
 L:=0;
 H:=Count-1;
 while L<=H do
 begin
  I:=(L+H)shr 1;
  if PLongInt(FList[I])^<N
   then L:=I+1
   else begin
    H:=I-1;
    if PLongInt(FList[I])^=N
     then begin
      Result:=True;
      if Duplicates<>dupAccept then L:=I;
     end; { if =N then }
   end; { if else }
 end; { while }
 Index:=L;
end;

function TIntegerList.IndexOf(N:LongInt):Integer;
var I:Integer;
begin
 Result:=-1;
 if not Sorted
 then begin
   for I:=0 to Pred(GetCount) do
   begin
    if GetItem(I)=N then Result:=I;
   end; { for }
 end { if not sorted then }
 else if Find(N,I) then Result:=I;
end;

procedure TIntegerList.Insert(Index:Integer;Value:LongInt);
var P:PLongInt;
begin
 if (FMin<>FMax) and ((Value<FMin) or (Value>FMax))
  then raise EOutOfRange.CreateFmt(
   'Value must be within %d..%d',[FMin,FMax]);
 New(P);
 P^:=Value;
 FList.Insert(Index,P)
end;

procedure TIntegerList.Move(CurIndex,NewIndex:Integer);
begin
 FList.Move(CurIndex,NewIndex);
end;

procedure TIntegerList.QuickSort(L,R:Integer);
var
 I,J:Integer;
 P:PLongInt;
begin
 I:=L;
 J:=R;
 P:=PLongInt(FList[(L+R)shr 1]);
 repeat
  while PLongInt(FList[I])^<P^ do Inc(I);
  while PLongInt(FList[J])^>P^ do Dec(J);
  if I<=J then
  begin
   FList.Exchange(I,J);
   Inc(I);
   Dec(J);
  end; { if }
 until I>J;
 if L<J then QuickSort(L,J);
 if I<R then QuickSort(I,R);
end;

procedure TIntegerList.Sort;
begin
 if not Sorted and (FList.Count>1)
  then QuickSort(0,FList.Count-1);
end;

procedure TIntegerList.AssignTo(Dest:TPersistent);
var i:integer;
    FStr:TStrings;
begin
 if Dest is TStrings
 then begin
   FStr:=TStrings(Dest);
   FStr.Clear;
   for i:=0 to Count-1 do FStr.Add(IntToStr(Items[i]));
 end
 else inherited AssignTo(Dest);
end;



end.
