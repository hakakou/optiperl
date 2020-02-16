unit SendmailFrm;    //modeless //memo 1

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,parsersmdl, dccommon, dcmemo, ToolWin,OptFolders, OptMessage,
  ComCtrls, dcstring, OptOptions,HakaGeneral,HyperFrm;

type
  TSendmailForm = class(TForm)
    memOut: TDCMemo;
    ToolBar: TToolBar;
    MemoSource: TMemoSource;
    btnSend: TToolButton;
    btnClose: TToolButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    UpdateCaption : Boolean;
    Function GetField(Const Name : String) : String;
  public
    Constructor Create(AOwner : TComponent; Mess,WParam,LParam : Cardinal); Reintroduce;
  end;

implementation

{$R *.dfm}

procedure TSendmailForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=CaFree;
end;

procedure TSendmailForm.FormCreate(Sender: TObject);
begin
 SetMemo(memout,[]);
end;

function TSendmailForm.GetField(const Name: String): String;
var i:integer;
begin
 i:=0;
 result:='';
 with MemOut.lines do
 while (i<Count) and (Strings[i]<>'') do
 begin
  if StringStartsWithCase(name+':',Strings[i]) then
  begin
   result:=Trim(CopyFromToEnd(Strings[i],pos(':',Strings[i])+1));
   exit;
  end;
  inc(i);
 end;
end;

procedure TSendmailForm.btnCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TSendmailForm.btnSendClick(Sender: TObject);
var
 s,Sendto:string;
 j,i:integer;
begin
 with memout.Lines do
 begin
  if count=0 then exit;
  i:=0;
  s:='';
  while (i<count) and (strings[i]<>'') do inc(i);
  if I<count then
   for j:=i+1 to count-1 do
    s:=s+strings[j]+#13#10;
 end;

 SendTo:=GetField('To');
 if sendto='' then exit;

 SendMapi(
  GetField('Subject'),s,sendto,GetField('CC'),GetField('BCC'),'',0);
end;

procedure TSendmailForm.FormShow(Sender: TObject);
var s:string;
begin
 if updatecaption then
 begin
  s:=GetField('TO');
  if trim(s)<>'' then
   caption:='Sendmail to '+s
 end;
end;

constructor TSendmailForm.Create(AOwner: TComponent; mess, WParam, LParam: Cardinal);
var
 s:String;
begin
 inherited Create(AOWNER);
 s:=Folders.UserFolder+'sm'+inttostr(WParam)+'.txt';
 if not fileexists(s) then
  exit;
 memosource.Lines.LoadFromFile(s);
 UpdateCaption:=(GetField('to')<>'') and (GetField('from')<>'');
 Toolbar.Visible:=UpdateCaption;
 if not updatecaption then
  caption:='Output '+DateTimeToStr(now);
end;

end.