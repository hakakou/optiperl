unit HKCSVParser;

interface

uses
  Windows, Messages, SysUtils, Classes, Hyperstr, Graphics, Controls, Forms,
  Dialogs,HakaHyper;

type

  TOnSetData = procedure(Sender : TObject; Const Data : array of String) of object;
  TOnNewLine = Function(Sender : TObject; var Line : String; LineNum : Integer) : boolean of object;

  THKCSVParser = class(TComponent)
  private
   FQuoteChar : Char;
   FDelimiter : Char;
   FOnSetData : TOnSetData;
   FOnReadNewLine : TOnNewLine;
   FOnBeforeParse : TNotifyEvent;
  public
   Lines : TStringList;
   Procedure LoadFromFile(const Filename : string);
   Procedure SaveToFile(const Filename : string);
   Procedure AddData(const Data : array of String);
   Procedure Parse;
   Constructor create(AOwner : TComponent); override;
   Destructor Destroy; override;
  published
   Property QuoteChar : Char read FQuoteChar write FQuoteChar;
   Property Delimiter : Char read FDelimiter write FDelimiter;
   Property OnSetData : TOnSetData read FOnSetData write FOnSetData;
   Property OnReadNewLine : TOnNewLine read FOnReadNewLine write FOnReadNewLine;
   Property OnBeforeParse : TNotifyEvent read FOnBeforeParse write FOnBeforeParse;
  end;

procedure Register;

implementation


Procedure THKCSVParser.Parse;
var
 count,i,itemcount:integer;
 s,w:string;
 items : array of string;
begin
 SetQuotes(FQuoteChar,FQuoteChar);
 for count:=0 to lines.Count-1 do
 begin
  s:=lines[count];

  if (assigned(FOnReadNewLine)) and (not FOnReadNewLine(self,s,count))
   then continue;

  I := 1;
  itemcount:=0;
  repeat
    W := HyperStr.Parse(s,FDelimiter,I);
    UnQuoteStr(w,FQuoteCHar);
    inc(itemCount);
    setLength(Items,itemcount);
    Items[itemcount-1]:=w;
  until (I<1) or (I>Length(S));

  If Assigned(FOnSetData) then FOnSetData(self,items);

 end;
end;

Procedure THKCSVParser.AddData(const Data : array of String);
var
 itemcount,i:integer;
 line,d:string;
begin
 line:='';
 for i:=0 to length(data)-1 do begin
  d:=data[i];
  replaceSC(d,FQuoteChar,FQuoteChar+FQuoteChar,false);
  line:=line+FQuoteChar+d+FQuoteChar+FDelimiter;
 end;
 if length(line)>0 then
  delete(line,length(line),1);
 lines.Add(line);
end;

Destructor THKCSVParser.Destroy;
begin
 Lines.Free;
 Inherited Destroy;
end;

constructor THKCSVParser.create(AOwner: TComponent);
begin
 inherited create(AOwner);
 FQuoteChar:='"';
 FDelimiter:=',';
 Lines:=TStringList.Create;
end;

Procedure THKCSVParser.LoadFromFile(const Filename : string);
begin
 Lines.LoadFromFile(FIlename);
 if assigned(FOnBeforeParse) then FOnBeforeParse(self);
 Parse;
end;

Procedure THKCSVParser.SaveToFile(const Filename : string);
begin
 Lines.SaveToFile(filename);
end;

procedure Register;
begin
  RegisterComponents('Haka', [THKCSVParser]);
end;

end.
