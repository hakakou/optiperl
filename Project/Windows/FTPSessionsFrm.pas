unit FTPSessionsFrm;    //Modal //VST

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,FTPMdl, ExtCtrls, DBCtrls, Grids, DBGrids, StdCtrls, Mask, DB,
  JvScrollMax, JvComponent, VirtualTrees, HKthemes, Themes, JvPlacemnt, OptProcs,
  Menus, dxfQuickTyp, agproputils;

type
  TFTPSessionsForm = class(TForm)
    DBNavigator: TDBNavigator;
    btnClose: TButton;
    btnHelp: TButton;
    ScrollMax: TJvScrollMax;
    BandServer: TJvScrollMaxBand;
    BandFirewall: TJvScrollMaxBand;
    BandRemote: TJvScrollMaxBand;
    BandSettings: TJvScrollMaxBand;
    Label1: TLabel;
    Label2: TLabel;
    l2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    l1: TLabel;
    Session: TDBEdit;
    Server: TDBEdit;
    Port: TDBEdit;
    Username: TDBEdit;
    Password: TDBEdit;
    Passive: TDBCheckBox;
    Account: TDBEdit;
    l3: TLabel;
    l5: TLabel;
    l4: TLabel;
    l6: TLabel;
    l7: TLabel;
    ProxyServer: TDBEdit;
    ProxyPort: TDBEdit;
    ProxyUser: TDBEdit;
    ProxyPass: TDBEdit;
    ProxyType: TDBComboBox;
    Label6: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    DocRoot: TDBEdit;
    URLLink: TDBEdit;
    Aliases: TDBEdit;
    Label11: TLabel;
    Label12: TLabel;
    Notes: TDBMemo;
    Sheebang: TDBEdit;
    AutoVersion: TDBCheckBox;
    SavePass: TDBCheckBox;
    ChangeSheBang: TDBCheckBox;
    FormStorage: TJvFormStorage;
    VST: TVirtualStringTree;
    PopupMenu: TPopupMenu;
    Insertrecord1: TMenuItem;
    Deleterecord1: TMenuItem;
    N1: TMenuItem;
    fQuickTyper: TdxfQuickTyper;
    TType: TDBComboBox;
    Label17: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure FormShow(Sender: TObject);
    procedure VSTFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure VSTGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Insertrecord1Click(Sender: TObject);
    procedure Deleterecord1Click(Sender: TObject);
    procedure TTypeChange(Sender: TObject);
  protected
    procedure _UpdateSessionTree;
    procedure _SessionEditMode(before: Boolean);
  end;

var
  FTPSessionsForm: TFTPSessionsForm;

implementation
type
  PData = ^TData;
  TData = record
   Str : String;
  end;

{$R *.dfm}

procedure TFTPSessionsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 FTPMod.SaveFile;
end;

procedure TFTPSessionsForm._UpdateSessionTree;
var
 node:PVirtualNode;
 Data : PData;
 s:string;
begin
 vst.clear;
 with FTPMod do
 begin
  if TransTable.FieldCount>0
   then s:=TransTableSession.AsString
   else s:='';

  TransTable.first;
  while not TransTable.eof do
  begin
   node:=vst.AddChild(vst.RootNode);
   data:=vst.GetNodeData(node);
   data.Str:=TransTableSession.AsString;
   if data.str=S then
   begin
    vst.focusednode:=node;
    vst.Selected[node]:=true;
   end;
   TransTable.next;
  end;

  TransTable.FindKey([s]);
 end;
end;

procedure TFTPSessionsForm.btnCloseClick(Sender: TObject);
begin
 if FTPMod.TransTable.State in [dsEdit,dsInsert] then
  FTPMod.TransTable.post;
end;

procedure TFTPSessionsForm.btnHelpClick(Sender: TObject);
begin
 Application.HelpCommand(HELP_CONTEXT,200);
end;

procedure TFTPSessionsForm.FormCreate(Sender: TObject);
begin
 SetVirtualTree(VST);
 PR_UpdateSessionTree:=_UpdateSessionTree;
 PR_SessionEditMode:=_SessionEditMode;
end;

procedure TFTPSessionsForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 data : PData;
begin
 data:=vst.GetNodeData(node);
 setlength(data.Str,0);
end;

procedure TFTPSessionsForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
 data : PData;
begin
 data:=vst.GetNodeData(node);
 celltext:=data.Str;
end;

procedure TFTPSessionsForm.FormShow(Sender: TObject);
begin
 PR_UpdateSessionTree;
 TTypeChange(nil);
end;

procedure TFTPSessionsForm.VSTFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
 data : PData;
begin
 data:=vst.GetNodeData(node);
 ftpmod.TransTable.FindKey([data.Str]);
 TTypeChange(nil);
end;

procedure TFTPSessionsForm.VSTGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
 nodedatasize:=sizeof(TData);
end;

Procedure TFTPSessionsForm._SessionEditMode(before: Boolean);
begin
 vst.enabled:=not before;
 btnClose.Enabled:=vst.enabled;
end;

procedure TFTPSessionsForm.FormDestroy(Sender: TObject);
begin
 PR_UpdateSessionTree:=nil;
 PR_SessionEditMode:=nil;
end;

procedure TFTPSessionsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 canclose:=btnClose.Enabled;
end;

procedure TFTPSessionsForm.Insertrecord1Click(Sender: TObject);
begin
 FTPMod.TransTable.Insert;
 Session.SetFocus;
end;

procedure TFTPSessionsForm.Deleterecord1Click(Sender: TObject);
begin
 FTPMod.TransTable.Delete;
end;

procedure TFTPSessionsForm.TTypeChange(Sender: TObject);
var
 ftp : Boolean;
begin
 FTP:=TType.ItemIndex <=0;
 SetGroupEnable([account,passive,ProxyServer,proxyport,proxyuser,proxypass,proxytype,
  l1,l3,l4,l5,l6,l7],FTP);
 if (FTPMod.TransTable.State in [dsEdit,dsInsert]) then
  if ftp
   then FTPMod.TransTablePort.Value:=21
   else FTPMod.TransTablePort.Value:=22;
end;

end.