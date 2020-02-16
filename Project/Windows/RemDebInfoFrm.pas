unit RemDebInfoFrm; //Modal //Tabs

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, HakaGeneral,
  Dialogs, ComCtrls, StdCtrls,optoptions,IPINfo, Buttons,registry,hyperfrm,HKNetwork,
  OptGeneral, ExtCtrls,FTPMdl,ScriptInfoUnit, HKTransfer, Hakawin, UrlMon, wininet,
  DIPcre,FTPSessionsFrm;

type
  TRemDebInfoForm = class(TForm)
    PageControl: TPageControl;
    btnClose: TButton;
    LocalSheet: TTabSheet;
    RemSheet: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    lblLocal: TLabel;
    lblRemote: TLabel;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    edRegLocal: TEdit;
    btnRegEnterLocal: TButton;
    btnRegRemoveLocal: TButton;
    GroupBox4: TGroupBox;
    Label3: TLabel;
    edRegRemote: TEdit;
    btnRegEnterRemote: TButton;
    btnRegRemoveRemote: TButton;
    btnMakeReg: TButton;
    cbMachines: TComboBox;
    Label2: TLabel;
    btnRefresh: TSpeedButton;
    SaveDialog: TSaveDialog;
    btnEnvEnter: TButton;
    btnEnvRemove: TButton;
    Label4: TLabel;
    Label5: TLabel;
    UploadSheet: TTabSheet;
    GroupBox5: TGroupBox;
    Label6: TLabel;
    cbSessions: TComboBox;
    Label7: TLabel;
    edPath: TEdit;
    Label8: TLabel;
    btnUpload: TButton;
    btnDelete: TButton;
    edFTPSetting: TEdit;
    Label9: TLabel;
    lblStatus: TLabel;
    Button2: TButton;
    cbIP: TComboBox;
    DIPcre: TDIPcre;
    btnUpdate: TSpeedButton;
    procedure btnRefreshClick(Sender: TObject);
    procedure btnRegEnterLocalClick(Sender: TObject);
    procedure btnRegRemoveLocalClick(Sender: TObject);
    procedure btnRegEnterRemoteClick(Sender: TObject);
    procedure btnRegRemoveRemoteClick(Sender: TObject);
    procedure btnMakeRegClick(Sender: TObject);
    procedure btnEnvEnterClick(Sender: TObject);
    procedure btnEnvRemoveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure cbIPSelect(Sender: TObject);
    procedure cbMachinesDropDown(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
  private
    ValueStr : string;
    FTP : TBaseTransfer;
    IP:string;
    procedure Refresh;
    procedure OnStatus(Sender: TObject; const Status: String);
    procedure UpdateIPAddress;
    function GetIPAddress: String;
  public
    Loaded:boolean;
  end;

var
  RemDebInfoForm: TRemDebInfoForm;

implementation

Const
 NameStr = 'PERLDB_OPTS';

{$R *.dfm}

procedure TRemDebInfoForm.UpdateIPAddress;
var
 IPnfo: TIPInfo;
 s : string;
 i,j:integer;
begin
 try
  IPnfo:=TIPInfo.Create;
  for i:=0 to IPnfo.maxadapters-1 do
  begin
   s:=IPNfo.Adapters[i].Description;
   for j:=0 to IPnfo.Adapters[i].MaxIPAddresses-1 do
    cbIP.Items.Add(IPnfo.Adapters[i].IPAddresses[j].Address+' - '+s);
  end;
 except
  ip:=MyipAddress;
  if ip<>'127.0.0.1' then
   cbIP.Items.Add(ip+' - Network');
 end;
 cbIp.Items.add('Get IP from the internet...');
 cbIP.Itemindex:=0;
end;

Function TRemDebInfoForm.GetIPAddress : String;
var
 sl : TStringList;
 Temp,url,s : String;
begin
 result:='127.0.0.1';
 temp:=GetTempFile;
 sl:=TStringList.create;
 sl.LoadFromFile(ProgramPath+'IP Address Pages.txt');
 url:=sl[Random(sl.Count)];
 try
  InternetSetOption(nil, INTERNET_OPTION_RESET_URLCACHE_SESSION ,nil,0);
  if URLDownloadToFile(nil,PAnsiChar(URL),PAnsiChar(Temp),0,nil)=S_OK then
  begin
   s:=LoadStr(temp);
   if DIPCRE.MatchStr(s)>0 then
    result:=DIPcre.MatchedStr;
  end;
 finally
  sl.free;
  DeleteFile(temp);
 end;
end;

procedure TRemDebInfoForm.Refresh;
var
 r,e,s : string;
begin
 ValueStr:=Format(options.DefPerlDBOpts,[ip,inttostr(options.remdebport)]);
 r:=HasPErlDBReg;
 e:=HasPErlDBEnv;
 if r='' then r:='<none>';
 if e='' then e:='<none>';

 if loaded then
  s:='The debugger is waiting for you to run a script with a -d in it''s shebang. '
 else
  s:='Select "Listen for remote debugger" to enabled remote debugging. ';

 lblLocal.caption:=s+
  'If you are using the internal server, the value '+
  '"'+nameStr+'='+options.PerlDBOpts+'" '+
  'will be entered automatically in the scripts environment. '+
  'If you want to use an external server, you will need to enter this value manually. '+
  'The current values on this computer are:'+#13#10+#13#10+
  'Registry: '+r+#13#10+
  'Environment: '+e;

 if ip='127.0.0.1' then
  begin
   lblRemote.Caption:=
    'You can only use the remote debugger to debug a script via loopback, '+
    'because no network or internet connection was found.';
  end
 else
  begin
   lblRemote.Caption:=
   'You will need to enter the value'+#13#10+namestr+'='+valuestr+#13#10+
   'in the environment variables of the remote machine.';
  end;

 edRegLocal.Text:=Options.PerlDBOpts;
 edRegRemote.Text:=valuestr;
 edFTPSetting.Text:='&parse_options("'+valuestr+'");';
end;

procedure TRemDebInfoForm.FormShow(Sender: TObject);
var
 s:string;
 i:integer;
begin
 PageControl.ActivePageIndex:=0;
 UpdateIPAddress;
 Refresh;
 cbIP.OnSelect:=cbIPSelect;
 cbIPSelect(nil);

 FTPMod.GetSessions(cbSessions.Items);
 s:=ActiveScriptInfo.GetFTPSession;
 if s<>'' then
 begin
  i:=cbSessions.Items.IndexOf(s);
  if i>=0 then
  cbSessions.ItemIndex:=i;
  edPath.Text:=activescriptinfo.GetFTPFolder;
 end;
end;

procedure TRemDebInfoForm.cbMachinesDropDown(Sender: TObject);
begin
 if cbMachines.Items.count=0 then
  HKNetwork.GetNetworkComputers(cbMachines.Items);
end;

procedure TRemDebInfoForm.btnRefreshClick(Sender: TObject);
begin
 cbMachines.Items.clear;
 HKNetwork.GetNetworkComputers(cbMachines.Items);
end;

procedure TRemDebInfoForm.btnRegEnterLocalClick(Sender: TObject);
begin
 doPerlDBReg(edRegLocal.Text,'',true);
 Refresh;
end;

procedure TRemDebInfoForm.btnRegRemoveLocalClick(Sender: TObject);
begin
 doPerlDBReg(edRegLocal.Text,'',false);
 Refresh;
end;

procedure TRemDebInfoForm.btnRegEnterRemoteClick(Sender: TObject);
begin
 if (trim(cbMachines.text)='') and (MessageDlg('Leaving blank will modify this machine. Continue?', mtConfirmation, [mbOK,mbCancel], 0) <> mrOk) then exit;
 doPerlDBReg(edRegRemote.Text,cbMachines.text,true);
 Refresh;
end;

procedure TRemDebInfoForm.btnRegRemoveRemoteClick(Sender: TObject);
begin
 if (trim(cbMachines.text)='') and (MessageDlg('Leaving blank will modify this machine. Continue?', mtConfirmation, [mbOK,mbCancel], 0) <> mrOk) then exit;
 doPerlDBReg(edRegRemote.Text,cbMachines.text,false);
 Refresh;
end;

procedure TRemDebInfoForm.btnMakeRegClick(Sender: TObject);
var s:string;
begin
 if savedialog.Execute then
 begin
  s:='REGEDIT4'+#13#10+
    #13#10+
    '[HKEY_LOCAL_MACHINE\SOFTWARE\Perl]'+#13#10+
    '"'+nameStr+'"="'+edRegRemote.Text+'"'+#13#10+
    '"PERL5DB"=-'+#13#10;
  savestr(s,savedialog.FileName);
 end;
end;

procedure TRemDebInfoForm.btnEnvEnterClick(Sender: TObject);
begin
 DoPerlDBEnv(edRegLocal.Text,true);
 Refresh;
end;

procedure TRemDebInfoForm.btnEnvRemoveClick(Sender: TObject);
begin
 DoPerlDBEnv(edRegLocal.Text,false);
 Refresh;
end;

procedure TRemDebInfoForm.btnUploadClick(Sender: TObject);
var
 f:string;
begin
 lblStatus.Visible:=true;
 DisableApplication;
 try
  FTPMod.OpenSession(cbSessions.Text,FTP,false,nil,OnStatus,edPath.Text);
  f:=GetTempFile;
  saveStr(edFTPSetting.Text+#10,f);
  ftp.TextTransfer:=true;
  FTP.Put(f,'.perldb');
  FTP.CHMod('.perldb',755);
  FTP.Put(f,'perldb.ini');
  FTP.CHMod('perldb.ini',755);
  lblstatus.Caption:='Files ".perldb" and "perldb.ini" uploaded succesfully';
 finally
  FTPMod.CloseSession(FTP);
  EnableApplication;
  DeleteFile(f);
 end;
end;

procedure TRemDebInfoForm.btnDeleteClick(Sender: TObject);
begin
 lblStatus.Visible:=true;
 DisableApplication;
 try
  FTPMod.OpenSession(cbSessions.Text,FTP,false,nil,OnStatus,edPath.Text);
  FTP.DeleteFile('.perldb');
  FTP.DeleteFile('perldb.ini');
  lblstatus.Caption:='Files ".perldb" and "perldb.ini" deleted succesfully';
 finally
  FTPMod.CloseSession(FTP);
  EnableApplication;
 end;
end;

procedure TRemDebInfoForm.OnStatus(Sender: TObject; const Status: String);
begin
 lblstatus.Caption:=Status;
end;

procedure TRemDebInfoForm.Button2Click(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT,7210);
end;

procedure TRemDebInfoForm.cbIPSelect(Sender: TObject);
begin
 with cbIP do
 begin
  if itemindex=items.Count-1 then
   begin
    if sender=nil
     then IP:='127.0.0.1'
     else IP:=GetIPAddress;
   end
  else
  if itemindex>=0 then
   IP:=copy(items[itemindex],1,pos(' ',items[itemindex])-1);
  Hint:=Text;
  if (not visible) or (itemIndex<0) then
   ip:='127.0.0.1';
 end;

 Refresh;
end;

procedure TRemDebInfoForm.btnUpdateClick(Sender: TObject);
begin
 FTPSessionsForm:=TFTPSessionsForm.Create(Application);
 try
  FTPSessionsForm.ShowModal;
 finally
  FTPSessionsForm.Free;
 end;
end;

end.
