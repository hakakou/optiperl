unit FTPSelectFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, bt_ddftp, Psock, NMFtp, ComCtrls, Menus, StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdFTP;

type
  TFTPSelectForm = class(TForm)
    FTP: TNMFTP;
    ListView: TListView;
    BT: TBTDragDropFTP;
    PopupMenu: TPopupMenu;
    ItemDelete: TMenuItem;
    ItemRename: TMenuItem;
    ItemNewFolder: TMenuItem;
    ItemChangePermissions: TMenuItem;
    ItemN1: TMenuItem;
    ItemRefresh: TMenuItem;
    Button1: TButton;
    StatusBar: TStatusBar;
    Label1: TLabel;
    Button2: TButton;
    procedure FTPStatus(Sender: TComponent; Status: String);
    procedure FTPConnect(Sender: TObject);
    procedure FTPDisconnect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ItemDeleteClick(Sender: TObject);
    procedure ItemRenameClick(Sender: TObject);
    procedure ItemRefreshClick(Sender: TObject);
    procedure FTPListItem(Listing: String);
    procedure ItemNewFolderClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    procedure ListItems;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FTPSelectForm: TFTPSelectForm;

implementation

{$R *.dfm}

procedure TFTPSelectForm.FTPStatus(Sender: TComponent; Status: String);
begin
 Statusbar.Panels[1].Text:=Status;
end;

procedure TFTPSelectForm.FTPConnect(Sender: TObject);
begin
 StatusBar.Panels[0].Text:='Connected';
end;

procedure TFTPSelectForm.FTPDisconnect(Sender: TObject);
begin
 StatusBar.Panels[0].Text:='Connected';
end;

procedure TFTPSelectForm.FormCreate(Sender: TObject);
begin
 StatusBar.Panels[0].Text:='Disconnected';
end;

procedure TFTPSelectForm.ListItems;
begin
 Listview.Clear;
 ftp.List;
end;

procedure TFTPSelectForm.Button1Click(Sender: TObject);
begin
  FTP.Connect;
 FTP.ChangeDir('/pub');
 ListItems;
end;

procedure TFTPSelectForm.ItemDeleteClick(Sender: TObject);
begin
 FTP.Delete(listview.Selected.Caption);
end;

procedure TFTPSelectForm.ItemRenameClick(Sender: TObject);
begin
// FTP.Rename(listview.Selected.Caption, );
end;

procedure TFTPSelectForm.ItemRefreshClick(Sender: TObject);
begin
 ListItems;
end;

procedure TFTPSelectForm.FTPListItem(Listing: String);
var
 li : TListItem;
begin
   li:=Listview.Items.Add;
   li.caption:=listing;
{   li.Caption:=name[i];
   li.SubItems.Add(size[i]);
   li.SubItems.Add(ModifDate[i]);
   li.subitems.Add(Attribute[i])}
end;

procedure TFTPSelectForm.ItemNewFolderClick(Sender: TObject);
begin
//InputQuery('New folder', 'Folder name:', DirName);

end;

procedure TFTPSelectForm.Button2Click(Sender: TObject);
begin
 Bt.ConnectTo('ftp.ntua.gr','anonymous','kxmgas@sdgtwe.com')
end;

end.

^([\w-]+)\s+(\d+)\s+(\S+)\s+(\S+)\s+(\d+)\s+(\w+)\s+(\d+)\s+(\d+):(\d+)\s+(\S+)$
