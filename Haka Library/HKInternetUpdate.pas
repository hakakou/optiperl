// Really fucked up - must make again...
dd

unit HKInternetUpdate;

interface
uses classes,HakaHyper,hyperstr,sysutils;

type
 TOnError = procedure (Sender:TObject;ErrorMsg:string) of object;

 TNetUpdate = Class
 private
  procedure DoneStream(Sender:TObject;Stream:TStream;StreamSize:integer;Url:string);
 Public
  HTTP : TNMHTTP;
  DataNames,DataValues : TStringList;
  FOnDone : TNotifyEvent;
  constructor Create(const ProgramName,url : string; OnError : TOnError; OnDone : TNotifyEvent);
  destructor Destroy; Override;
  Procedure NetUpdate;
 end;

implementation

constructor TNetUpdate.Create;
var Name,FSys : string;
    S:Cardinal;
begin
 DataNames:=TStringList.Create;
 DataValues:=TStringList.Create;
 HTTP:=TNMHTTP.create(nil);
 HTTP.Url:=url;
 HTTP.OnDoneStream:=DoneStream;
 FOnDone:=OnDone;
 HTTP.OnError:=OnError;
{ Http.Agent:='X-'+programname;
 GetVolume('C',Name,FSys,S);
 Http.Referer:='X-'+inttostr(int64(S));}
end;

destructor TNetUpdate.Destroy;
begin
 DataNames.free;
 DataValues.free;
 inherited Destroy
end;

procedure TNetUpdate.DoneStream(Sender: TObject; Stream: TStream;
  StreamSize: integer; Url: string);
var
 i,p:integer;
 S:String;
begin
 DataNames.Clear;
 DataValues.Clear;
 DataNames.LoadFromStream(stream);
 For i:=0 to Datanames.Count-1 do begin
  s:=DataNames[i];
  p:=pos('=',s);
  if p<>0 then
  begin
   DataValues.Add(copy(s,p+1,length(s)));
   DataNames[i]:=copy(s,1,p-1);
  end else
  begin
   DataValues.Add('');
  end;
 end;
 if assigned(FOnDone) then FOnDone(sender);
end;

procedure TNetUpdate.NetUpdate;
begin
 http.Execute;
end;

end.
