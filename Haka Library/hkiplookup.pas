unit HKIPLookup;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Psock, NMHttp, DIPcre, hakageneral;

type

  TIPInfo = Record
   IP : String;
   netname : string;
   NetBlockStart : string;
   NetBlockEnd : String;
   country : String;
  end;

  TIPLookup = class(TDataModule)
    HTTP: TNMHTTP;
    NNPcre: TDIPcre;
    NBPcre: TDIPcre;
    CountryPcre: TDIPcre;
    StrPcre: TDIPcre;
    JapPcre: TDIPcre;
    JapIPPcre: TDIPcre;
    JapNamePcre: TDIPcre;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure ClearList;
    { Private declarations }
  public
    IPList : TStringList;
    Procedure ReverseIPLookUp(const IP : string; Var IPInfo : TIPInfo);
  end;


var
  IPLookup: TIPLookup;

implementation
{$R *.DFM}


{ TIPLookupMod }

procedure TIPLookup.ReverseIPLookUp(const IP: string;
  var IPInfo: TIPInfo);
var
 s:string;
begin
 fillchar(ipInfo,sizeof(ipinfo),0);
 ipinfo.IP:=ip;
 http.Get('http://www.arin.net/cgi-bin/whois.pl?queryinput='+ip);
 if pos('whois.ripe.net',http.body)<>0
 then
  http.Get('http://www.ripe.net/perl/whois?searchtext='+ip)
 else

 if pos('WHOIS.APNIC.NET',http.body)<>0
 then
  begin
  http.Get('http://www.apnic.net/apnic-bin/whois2.pl?results=all&search='+ip+'&whois=Go%21');
  if pos('Japan Network Information Center',http.body)<>0
  then
   begin
    http.Get('http://whois.nic.ad.jp/cgi-bin/whois_gw?type=NET&lang=%2Fe&key='+ip);
    if jappcre.Match(http.body)=4 then
    begin
     ipinfo.country:='JP';
     ipinfo.netname:=trim(japPcre.SubStrings[1]);
     ipinfo.NetBlockStart:=japPcre.SubStrings[2];
     ipinfo.NetBlockend:=japPcre.SubStrings[3];
     exit;
    end;
    s:=RemoveHTMLTags(http.body);
    if (japIPpcre.Match(s)=3) and (japNamePcre.Match(s)=2) then
    begin
     ipinfo.NetBlockStart:=japIPPcre.SubStrings[1];
     ipinfo.NetBlockend:=japIPPcre.SubStrings[2];
     ipinfo.country:='JP';
     ipinfo.netname:=trim(japNamePcre.SubStrings[1]);
     exit;
    end;
   end
  end

 else
  begin
   if StrPcre.Match(http.body)=2 then
   begin
    ipInfo.country:='US';
    ipinfo.netname:=StrPcre.SubStrings[1];
    exit;
   end;
  end;


 s:=RemoveHTMLTags(http.body);
 if NBPCre.Match(s)=5 then
 begin
  ipinfo.NetBlockStart:=NBPCre.SubStrings[3];
  ipinfo.NetBlockEnd:=NBPCre.SubStrings[4];
  ipinfo.country:='US';
 end;

 if NNPCre.Match(s)=3 then
  ipinfo.netname:=trim(NNPCre.SubStrings[2]);

 if CountryPCre.Match(s)=3 then
  ipinfo.Country:=trim(CountryPCre.SubStrings[2]);
end;


procedure TIPLookup.DataModuleCreate(Sender: TObject);
begin
 IPList:=TStringList.create;
end;

procedure TIPLookup.ClearList;
var
 i:integer;
 ipinfo : ^TIPInfo;
begin
 for i:=0 to IPList.Count-1 do
  if assigned(IPList.objects[i]) then
  begin
   ipinfo:=pointer(IPList.objects[i]);
   Dispose(ipinfo);
  end;
end;

procedure TIPLookup.DataModuleDestroy(Sender: TObject);
begin
 ClearList;
 IPList.free;
end;


end.
