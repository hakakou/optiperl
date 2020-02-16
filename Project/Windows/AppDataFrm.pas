unit AppDataFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OptFolders, PBFolderDialog, Buttons, jvfileutil,jclRegistry,
  inifiles,OptOptions;

type
  TAppDataForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label2: TLabel;
    edFolder: TEdit;
    btnSelect: TSpeedButton;
    FolderDialog: TPBFolderDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AppDataForm: TAppDataForm;

implementation

{$R *.dfm}

procedure TAppDataForm.FormCreate(Sender: TObject);
begin
 EdFolder.Text:=Folders.AppDataFolder;
end;

procedure TAppDataForm.btnSelectClick(Sender: TObject);
begin
 with FolderDialog do
 begin
  folder:=edFolder.Text;
  if execute then
   edFolder.Text:=folder;
 end;
end;

procedure TAppDataForm.Button1Click(Sender: TObject);
var
 fl : TStringList;
 OSet,OFTP,ORemote,ODir,s : String;
begin
 if not directoryExists(edFolder.Text) then
 begin
  MessageDlg('Folder does not exists. Please select a valid folder.', mtError, [mbOK], 0);
  modalresult:=mrNone;
  exit;
 end;

 if AnsiCompareText(includeTrailingBackslash(edFolder.Text),folders.AppDataFolder)=0 then exit;

 ODir:=folders.AppDataFolder;
 OSet:=ExcludeTrailingBackSlash(folders.UserFolder);
 OFTP:=ExcludeTrailingBackSlash(folders.FTPFolder);
 ORemote:=ExcludeTrailingBackSlash(Folders.RemoteFolder);
 Options.SaveToFile(folders.OptFile);

 RegWriteString(HKEY_CURRENT_USER,OptiRegKey,OptiRegKey_UserFolder,IncludeTrailingBackSlash(edFolder.Text));
 optFolders.ResetFolders;
 s:=ExcludeTrailingBackSlash(Folders.AppDataFolder);
 CopyFileEx(OSet,s,true,true,nil);
 CopyFileEx(OFTP,s,true,true,nil);
 CopyFileEx(ORemote,s,true,true,nil);
 MessageDlg('Your application data folder has changed.'+#13+#10+''+#13+#10+'OptiPerl needs to be restarted now, so please '+#13+#10+'save all your open files.'+#13+#10+''+#13+#10+'After OptiPerl terminates, you can safely delete'+#13+#10+'the folder '+odir+#13+#10+'with all it''s contents.'+#13+#10+''+#13+#10+'All your settings have been copied to your new '+#13+#10+'application data folder.', mtInformation, [mbOK], 0);
 Application.MainForm.Close;
end;

end.