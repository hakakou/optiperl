unit HakaRandom;

interface
uses Sysutils,Classes,AMRandom;

Type
 TRandomSequence = class
 private
  FList : TList;
  FCount,FLast : Integer;
 public
  Constructor Create(Count : Integer);
  Destructor Destroy; override;
  Function Next : Integer;
 end;

Function RandomString(Len : Integer) : String;
Function RandomSingle(max : Single = 1) : Single;
Function Random64(i64 : Int64) : Int64;
Function Random64Range(Min, Max : Int64) : Int64;
Function RandomCharacters(len : Integer) : String;


implementation

Function Random64(i64 : Int64) : Int64;
begin
 result:=Round(Extended(Random)*i64);
end;

Function Random64Range(Min, Max : Int64) : Int64;
begin
 if Max<=Min then
  result:=Min
 else
 if Min>Max then
  result:=Max
 else
  result:=Random64(Max-Min+1)+Min;
end;

Function RandomSingle(max : Single = 1) : Single;
begin
 result:=Random*Max;
end;

Function RandomCharacters(len : Integer) : String;
const
 ChrSet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0987654321';
var
 i:integer;
begin
 setlength(result,len);
 for i:=1 to len do
  result[i]:=ChrSet[random(length(chrset))+1];
end;

Function RandomString(Len : Integer) : String;
var i:integer;
begin
 setlength(result,len);
 for i:=1 to len do
  result[i]:=chr(random(122-97+1)+97);
end;


{ TRandomSequence }

constructor TRandomSequence.Create(Count: Integer);
begin
 FList:=TList.Create;
 FCount:=Count;
 FLast:=-1;
end;

destructor TRandomSequence.Destroy;
begin
 FList.Free;
end;

function TRandomSequence.Next: Integer;
var i:integer;
begin
 if (FList.Count=1) and (FCount>1) then
 begin
  FLast:=Integer(FList[0]);
  Flist.Delete(0);
  result:=FLast;
  exit;
 end;

 if FList.Count=0 then
 begin
  for i:=0 to FCount-1 do
   FList.Add(pointer(i));
 end;

 repeat
  i:=Random(FList.Count);
  result:=Integer(FList[i]);
 until (result<>FLast);

 FList.Delete(i);
 FLast:=-1;
end;

end.
