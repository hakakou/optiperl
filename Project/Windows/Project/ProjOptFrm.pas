unit ProjOptFrm; //Modal //Tabs
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OptProcs, hakafile, ComCtrls, OptOptions,PerlHelpers,
  Mask, dcControls,agproputils,HKOptions,FTPMdl,OptGeneral, ExtCtrls, Buttons,
  FTPSessionsFrm,HakaGeneral,hyperstr,hakacontrols, JvToolEdit;

type
  TStatus = (stPublish,stOK,stNotChanged,stNotFound,stError,stNotMode);

  PPrItem = ^TPrItem;
  TPrItem = Record
   Path : string;
   IsFolder : Boolean;
   Mode : Integer;
   Publish : Boolean;
   Text : Boolean;
   Crc : Integer;
   Status : TStatus;
   FileAge : Integer;
   PublishTo : String;
   NonPublished : Boolean;
   Deleted : Boolean;
   Info : String;
   OleObject : Pointer;
  end;

  TPrItemList = Array of TPrItem;
  TNodeList = Array of Pointer;

  TProjOptForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnDef: TButton;
    PageControl: TPageControl;
    ProjectSheet: TTabSheet;
    ServerSheet: TTabSheet;
    InternalBox: TGroupBox;
    Label6: TLabel;
    IntServerRootPath: TJvDirectoryEdit;
    ExtBox: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    AccessLogFile: TJvFilenameEdit;
    ErrorLogFile: TJvFilenameEdit;
    ExtServerRoot: TJvDirectoryEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Session: TComboBox;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    LocalPath: TJvDirectoryEdit;
    Label2: TLabel;
    RemotePath: TEdit;
    btnSetup: TSpeedButton;
    PerlDBOpts: TEdit;
    lblRD: TLabel;
    SettingsSheet: TTabSheet;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Host: TEdit;
    PerlBox: TGroupBox;
    Label12: TLabel;
    PerlSearchDir: TEdit;
    DefBox: TGroupBox;
    Label5: TLabel;
    DefaultScriptFolder: TJvDirectoryEdit;
    Label9: TLabel;
    DefaultHtmlFolder: TJvDirectoryEdit;
    btnHelp: TButton;
    Label13: TLabel;
    IntServerAliases: TEdit;
    Label10: TLabel;
    ExtServerAliases: TEdit;
    btnHttpConf: TButton;
    DataSheet: TTabSheet;
    GroupBox5: TGroupBox;
    Label14: TLabel;
    Data0: TEdit;
    data1: TEdit;
    data2: TEdit;
    data3: TEdit;
    data4: TEdit;
    data5: TEdit;
    data6: TEdit;
    data7: TEdit;
    data8: TEdit;
    data9: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    btnParseLib: TButton;
    GroupBox4: TGroupBox;
    OverrideProj: TCheckBox;
    GroupBox6: TGroupBox;
    Layout: TComboBox;
    Label24: TLabel;
    DisplayNonPublished: TCheckBox;
    RestoreFiles: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnDefClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OverrideProjClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSetupClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure btnHttpConfClick(Sender: TObject);
    procedure btnParseLibClick(Sender: TObject);
  private
    Procedure DefaultEnabledSet(en : boolean);
  public
    TempProjOpts : TProjOpts;
  end;

var
 ProjOptForm: TProjOptForm;

implementation
{$R *.DFM}

procedure TProjOptForm.FormCreate(Sender: TObject);
var
 i:integer;
begin
 FTPMod.GetSessions(Session.Items);

 PopulateLayoutList(Layout.items);
 Layout.items.insert(0,'(none)');
 Layout.ItemIndex:=0;

 TempProjOpts:=TProjOpts.Create;
 TempProjOpts.Assign(ProjOpt);
 TempProjOpts.setToForm(self);
 i:=layout.Items.IndexOf(ProjOpt.Layout);
 if i>=0 then
  Layout.ItemIndex:=i;

 if OptiRel=orStan then
 begin
  lblRd.Visible:=false;
  PerlDBOpts.Visible:=false;
 end;
end;

procedure TProjOptForm.btnOKClick(Sender: TObject);
begin
 ProjOpt.GetFromForm(self);
end;

procedure TProjOptForm.btnDefClick(Sender: TObject);
begin
 TempProjOpts.Setdefaults;
 TempProjOpts.setToForm(self);
end;

procedure TProjOptForm.FormShow(Sender: TObject);
begin
 NormalizeControl(self,RemotePath.Height);
 if layout.Text='' then
  layout.ItemIndex:=0;
 PageControl.ActivePageIndex:=0;
 DefaultEnabledSet(OverrideProj.checked);
end;

Procedure TProjOptForm.DefaultEnabledSet(en : boolean);
var a:integer;
begin
 with InternalBox do
  for a:=0 to ControlCount-1 do
   SetBoolProperty(controls[a],'enabled',en);
 with ExtBox do
  for a:=0 to ControlCount-1 do
   SetBoolProperty(controls[a],'enabled',en);
 with PerlBox do
  for a:=0 to ControlCount-1 do
   SetBoolProperty(controls[a],'enabled',en);
 with DefBox do
  for a:=0 to ControlCount-1 do
   SetBoolProperty(controls[a],'enabled',en);
 host.Enabled:=en;
end;

procedure TProjOptForm.OverrideProjClick(Sender: TObject);
begin
 DefaultEnabledSet(OverrideProj.checked);
end;

procedure TProjOptForm.FormDestroy(Sender: TObject);
begin
 TempProjOpts.free;
end;

procedure TProjOptForm.btnSetupClick(Sender: TObject);
begin
 FTPMod.TransTable.FindKey([session.Text]);
 OpenModalForm(TFTPSessionsForm);
 FTPMod.GetSessions(Session.Items);
end;

procedure TProjOptForm.btnHelpClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT,6870);
end;

procedure TProjOptForm.btnHttpConfClick(Sender: TObject);
var DocRoot,Aliases,ErrorLog,AccessLog : string;
begin
 if ParseHttpConf(DocRoot,Aliases,ErrorLog,AccessLog) then
 begin
  extserverroot.Text:=docroot;
  extserveraliases.Text:=aliases;
  errorlogfile.text:=errorlog;
  accesslogfile.Text:=accesslog;
 end;
end;

procedure TProjOptForm.btnParseLibClick(Sender: TObject);
begin
 PerlSearchDir.Text:=FastFindINCPath(options.PathToPerl)+';'+PR_GetLibInfo;
end;

end.