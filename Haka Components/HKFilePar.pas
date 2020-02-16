unit HKFilePar;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;


type
  TOnNewLine = Procedure(Sender : TObject; LineData : TStringList) of object;
  TOnLoaded = Procedure(Sender : TObject; FileLines : TStringList) of object;

  THKFileParser = class(TComponent)
  private
   FMin,FMax : Integer;
   FDelRepeated : boolean;
   FFileStrings : TStringList;
   FLineData : TStringList;
   FEmptyStr : String;
   FOnNewLine : TOnNewLine;
   FOnLoaded : TOnLoaded;
   Procedure ParseToStringList(const Str:string);
  public
   Table : String;
   Continue : Boolean;
   Procedure Execute(const Filename : string);
   Constructor create(AOwner : TComponent); override;
  published
   Property DelRepeated : boolean read FDelRepeated write FDelRepeated;
   Property MinFields : integer read FMin write FMin;
   Property MaxFields : integer read FMax write FMax;
   property EmptyString : string read FEmptystr write FEmptystr;
   Property OnNewLine : TOnNewLine read FOnNewLine write FOnNewLine;
   Property OnLoaded : TOnLoaded read FOnLoaded write FOnLoaded;
  end;

procedure Register;

implementation
uses HyperStr;

constructor THKFileParser.create(AOwner: TComponent);
begin
 inherited create(AOwner);
 Fmin:=1;
 FMax:=10;
 FDelrepeated:=false;
 FEmptyStr:='<EMPTY>';
 Table:=' '+#9+',';
end;

procedure THKFileParser.Execute(const Filename: string);
var a:integer;
begin
 Continue:=true;
 if fileexists(Filename) then begin
  FFileStrings:=TStringList.create;
  FLineData:=TStringList.create;
  with FFileStrings do
   try
    LoadFromFile(Filename);
    if assigned(FOnLoaded) then FOnLoaded(Self,FFileStrings);
    for a:=0 to Count -1 do begin
     if not continue then break;
     Application.ProcessMessages;
     ParseToStringList(Strings[a]);
     if ((FLineData.count>=Fmin) and (FLineData.count<=Fmax)) then
      If Assigned(FOnNewLine) then
       FOnNewLine(Self,FLineData);
    end;
   finally
    FLineData.free;
    FFileStrings.free;
   end;
 end;
end;

Procedure THKFileParser.ParseToStringList(const Str:string);
var W : String;
 i:integer;
begin
 I := 1;
 FLineData.Clear;
 if FDelrepeated then
  repeat
   W := ParseWord(Str,Table,I);
   if Length(W)>0
    then FLineData.add(W) else break;
  until False
 else
  repeat
   W := Parse(Str,Table,I);
    if length(w)>0 then FLineData.add(w) else FLineData.add(FEmptyStr);
  until (I<1) or (I>Length(Str));
end;

procedure Register;
begin
  RegisterComponents('Haka', [THKFileParser]);
end;

end.
