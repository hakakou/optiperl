unit HKTransfer;
{$I REG.INC}

interface
uses sysutils,classes,ExtCtrls,shellApi,hyperstr,hakageneral;

Type
  TItemType = (itDirectory, itFile, itSymbolicLink);
  TItemTypes = set of TItemType;

  TStatusEvent = Procedure(Sender : TObject; Const Status : String) of object;
  EFTPError = Class(Exception);

const
  ItemTypeAll = [itDirectory, itFile, itSymbolicLink];
  ItemTypeFiles = [itFile, itSymbolicLink];

  ColFilename = 0;
  ColSize = 1;
  ColModified = 2;
  ColAttributes = 3;
  ColItemDesc = 4;

  StrItemType : Array[TItemType] of string = ('Directory','File','Link');

type
  PItemData = ^TItemData;
  TItemData = Record
   Filename : String;
   Size : Int64;
   Modified : TDateTime;
   Attributes : String;
   Description : String;
   LinksTo : String;
   ItemType : TItemType;
   ImageIndex : Integer;
  end;

  TTransferFields =
   (tfPassive,tfAccount,tfProxyHost,tfProxyUsername,tfProxyPassword,tfProxyPort,tfProxyType);

  TBaseTransfer = Class
  private
   FCurrentDirectory : String;
   FPathOnConnect : string;
   FLastError : String;
   FAutoGetFileList,FUpdateAutoGetFileList : Boolean;
   FOnUpdate : TNotifyEvent;
   FOnStatus : TStatusEvent;
   FOnDisconnect : TNotifyEvent;
   ImgSymbLink,imgFolder : Integer;
   Procedure OnTimer(sender: TObject);
   procedure RaiseErrors;
  protected
   Procedure AddStatus(Const Text : String);
   Procedure UpdateConnectedFromLastError(CloseOnAnyError : Boolean); virtual; abstract;

   Function GetConnected : Boolean; virtual; abstract;
   Function GetBusy : Boolean; virtual; abstract;
   Procedure SetUsername(Const Text:String); virtual; abstract;
   Function GetUsername : String; virtual; abstract;
   Procedure SetPassword(Const Text:String); virtual; abstract;
   Function GetPassword : String; virtual; abstract;
   Procedure SetHost(Const Text:String); virtual; abstract;
   Function GetHost : String; virtual; abstract;
   Procedure SetPort(Port : integer); virtual; abstract;
   Function GetPort : Integer; virtual; abstract;
   Function GetTextTranfer : boolean; virtual; abstract;
   Procedure SetTextTransfer(Text : boolean); virtual; abstract;
   Function GetLoginMessage : String; virtual; abstract;

   procedure IntDeleteFile(const Filename: String); virtual; abstract;
   Procedure IntCHMod(const FileName : String; Mode : Integer); virtual; abstract;
   Procedure IntCreateDirectory(Const Dir : String); virtual; abstract;
   Procedure IntChangeDirectory(Const Dir : String); virtual; abstract;
   Procedure IntRemoveDirectory(Const Dir : String); virtual; abstract;
   Procedure IntGet(Const RemoteFile,LocalFile : String); virtual; abstract;
   Procedure IntPut(Const LocalFile,RemoteFile : String); virtual; abstract;
   Procedure IntRename(const OldFile,NewFile : String); virtual; abstract;
   Procedure IntCustom(Const Text : String); virtual; abstract;
   Procedure IntChangeDirUp; virtual; abstract;
   Procedure IntConnect; virtual; abstract;
   procedure IntAbort; virtual; abstract;
   procedure IntDoDumbCommand; virtual; abstract;
   Procedure IntDisconnect; virtual; abstract;
   Function IntGetCurrectDirectory : String; virtual; abstract;
   Procedure IntUpdateFileList; virtual; abstract;
  public
   KeepAliveTimer : TTimer;
   FileList : Array of TItemData;
   BeingUsed : Boolean; //user

   Constructor Create;
   Destructor Destroy; Override;
   Procedure ReCheckConnect;
   Procedure SetProp(Prop : TTransferFields; Val : Variant); virtual;

   Procedure BeginUpdate;
   Procedure EndUpdate(UpdateList : Boolean = true);

   Procedure UpdateFileList;
   Procedure GetCurrectDirectory;
   Procedure DeleteFile(Const Filename : String);
   Procedure DeleteFolder(Const Folder : String);
   Procedure Custom(Const Text : String);
   Procedure CreateDirectory(Const Dir : String);
   Procedure ChangeDirectory(Const Dir : String);
   Procedure RemoveDirectory(Const Dir : String);
   Procedure Get(Const RemoteFile,LocalFile : String);
   Procedure Put(Const LocalFile,RemoteFile : String);
   Procedure Rename(const OldFile,NewFile : String);
   Procedure CHMod(const FileName : String; Mode : Integer);
   Procedure ChangeDirUp;
   Procedure Connect(InitialPath : String = '');
   Procedure Abort;

   property CurrentDirectory : String read FCurrentDirectory;
   property LastError : String read FLastError write FLastError;
   property Connected : Boolean read GetConnected;
   Property LoginMessage : String read GetLoginMessage;
   Property Busy : Boolean read GetBusy;

   Property PathOnConnect : String read FPathOnConnect;
   Property AutoGetFileList : Boolean read FAutoGetFileList write FAutoGetFileList;

   property OnFileListUpdated : TNotifyEvent read FOnUpdate write FOnUpdate;
   property OnDisconnected : TNotifyEvent read FOnDisconnect write FOnDisconnect;
   property OnStatus : TStatusEvent read FOnStatus write FOnStatus;
  Published
   property Username : String read GetUsername write SetUsername;
   property Password : String read GetPassword write SetPassword;
   property Host : String read GetHost write SetHost;
   property Port : Integer read GetPort write SetPort;
   property TextTransfer : Boolean read GetTextTranfer write SetTextTransfer;
  end;

implementation

type
  TKeepAliveThread = class(TThread)
  Private
   Transfer : TBaseTransfer;
  public
   Constructor Create(ATransfer : TBaseTransfer);
   Destructor Destroy; Override;
  protected
   procedure Execute; override;
  end;

{ TBaseTransfer }

//Create & Destroy

constructor TBaseTransfer.Create;
var
 ShInfo: TSHFileInfo;
begin
 SHGetFileInfo(pchar('1.exe'), 0, ShInfo, SizeOf(TSHFileInfo),
                SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
 ImgSymbLink:= ShInfo.iIcon;
 SHGetFileInfo(pchar(GetWinDir), 0, ShInfo, SizeOf(TSHFileInfo),
                SHGFI_SYSICONINDEX);
 ImgFolder:= ShInfo.iIcon;
 KeepAliveTimer:=TTimer.create(nil);
 KeepAliveTimer.Interval:=60000;
 KeepAliveTimer.OnTimer:=OnTimer;
 KeepAliveTimer.Enabled:=false;
end;

destructor TBaseTransfer.Destroy;
begin
 if Connected then
 begin
  FLastError:='';
  IntDisconnect;
 end;
 if assigned(FOnDisconnect) then
  FOnDisconnect(self);
 KeepAliveTimer.free; 
 inherited;
end;

procedure TBaseTransfer.ReCheckConnect;
begin
 FLastError:='';
 IntDoDumbCommand;
 UpdateConnectedFromLastError(true);
 if Connected then
  exit
 else
  try
   Connect(FCurrentDirectory);
   FLastError:='';
  except
   free;
   raise EFTPError.Create('Could not reconnect.');
   //admin@mayples.co.uk.elf
  end;
end;

procedure TBaseTransfer.Abort;
begin
 FLastError:='';
 IntAbort;
 RaiseErrors;
 if (not Connected) then
  Free;
end;

procedure TBaseTransfer.RaiseErrors;
begin
 UpdateConnectedFromLastError(false);
 If FLastError<>'' then
  Raise EFTPError.Create(FLastError);
end;

// Methods

procedure TBaseTransfer.BeginUpdate;
begin
 FUpdateAutoGetFileList:=FAutoGetFileList;
 FAutoGetFileList:=false;
end;

procedure TBaseTransfer.EndUpdate(UpdateList : Boolean = true);
begin
 FAutoGetFileList:=FUpdateAutoGetFileList;
 if UpdateList and FAutoGetFileList and (FLastError='') then
  UpdateFileList;
end;

procedure TBaseTransfer.Connect(InitialPath : String = '');
begin
 if Connected then exit;
 FLastError:='';
 IntConnect;
 if Connected then
  try
   GetCurrectDirectory;
    FPathOnConnect:=FCurrentDirectory;
   if InitialPath<>'' then
   begin
    try
     ChangeDirectory(InitialPath);
    except on exception do end;
    LastError:='';
   end;
  finally
   if (FAutoGetFileList) and (FLastError='') then
    if InitialPath='' then
     UpdateFileList;
  end
 else
  if FLastError='' then
   FLastError:='Could not connect.';
 RaiseErrors;
end;

procedure TBaseTransfer.CreateDirectory(const Dir: String);
begin
 FLastError:='';
 IntCreateDirectory(dir);
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.Custom(const Text: String);
begin
 FLastError:='';
 IntCustom(Text);
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.Get(const RemoteFile, LocalFile: String);
begin
 FLastError:='';
 IntGet(RemoteFile,LocalFile);
 RaiseErrors;
end;

procedure TBaseTransfer.DeleteFile(const Filename: String);
begin
 FLastError:='';
 IntDeleteFile(Filename);
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.DeleteFolder(const Folder: String);

 procedure DoDelete(const Folder: String);
 var
  IntFileList : Array of TItemData;
  i:integer;
 begin
  IntChangeDirectory(folder);
  if FLastError<>'' then exit;

  SetLength(fileList,0);
  IntUpdateFileList;
  if FLastError<>'' then exit;

  SetLength(IntFileList,length(FileList));
  for i:=0 to length(FileList)-1 do
   IntFileList[i]:=FileList[i];

  for i:=0 to length(IntFileList)-1 do
   if (intFileList[i].Filename<>'.') and (intFileList[i].Filename<>'..') then
   begin
    if Intfilelist[i].ItemType=itDirectory then
     begin
      DoDelete(Intfilelist[i].Filename);
      IntChangeDirUp;
      IntRemoveDirectory(Intfilelist[i].Filename);
     end
    else
     IntDeleteFile(Intfilelist[i].Filename);

    if FLastError<>'' then exit;
   end;
 end;

begin
 FLastError:='';
 DoDelete(folder);
 if FLastError='' then
  IntChangeDirUp;
 if FLastError='' then
  RemoveDirectory(Folder);
 RaiseErrors;
end;

procedure TBaseTransfer.Put(const LocalFile, RemoteFile: String);
begin
 FLastError:='';
 IntPut(LocalFile,RemoteFile);
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.RemoveDirectory(const Dir: String);
begin
 FLastError:='';
 IntRemoveDirectory(Dir);
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.Rename(const OldFile, NewFile: String);
begin
 FLastError:='';
 IntRename(OldFile,NewFile);
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.ChangeDirUp;
begin
 FLastError:='';
 IntChangeDirUp;
 RaiseErrors;
 GetCurrectDirectory;
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.ChangeDirectory(const Dir: String);
begin
 FLastError:='';
 if length(dir)>0
  then IntChangeDirectory(Dir);
 RaiseErrors;
 GetCurrectDirectory;
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.CHMod(const FileName: String; Mode: Integer);
begin
 FLastError:='';
 IntCHMod(Filename,mode);
 if (FAutoGetFileList) and (FLastError='') then
  UpdateFileList;
 RaiseErrors;
end;

procedure TBaseTransfer.GetCurrectDirectory;
var s:string;
begin
 FLastError:='';
 s:=IntGetCurrectDirectory;
 if FLastError=''
  then FCurrentDirectory:=s
  else FLastError:='';
end;

//Events handling

procedure TBaseTransfer.UpdateFileList;
var
 i:integer;
 ShInfo: TSHFileInfo;
begin
 SetLength(fileList,0);
 IntUpdateFileList;
 FLastError:='';

 for i:=0 to length(FileList)-1 do
 begin
  case FileList[i].ItemType of
   itDirectory :
    begin
     FileList[i].ImageIndex:=ImgFolder;
     FileList[i].Description:='Folder';
    end;
   itFile :
    begin
     SHGetFileInfo(pchar(FileList[i].Filename), 0, ShInfo, SizeOf(TSHFileInfo),
            SHGFI_TYPENAME or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
     FileList[i].ImageIndex := ShInfo.iIcon;
     FileList[i].Description:=shinfo.szTypeName;
    end;
   itSymbolicLink :
   begin
    FileList[i].Description:='Symbolic link';
    FileList[i].ImageIndex:=ImgSymbLink;
   end;

  end; //case
 end;
 if assigned(FOnUpdate) then
  FOnUpdate(self);
end;

procedure TBaseTransfer.AddStatus(const Text: String);
begin
 if assigned(FOnStatus) then
  FOnStatus(self,text);
end;

{ TKeepAliveThread }

procedure TBaseTransfer.OnTimer(sender: TObject);
begin
 if Connected then
  begin
   if not busy then
   begin
    KeepAliveTimer.Enabled:=false;
    TKeepAliveThread.Create(self);
   end;
  end
 else
  Free; 
end;

constructor TKeepAliveThread.Create(ATransfer : TBaseTransfer);
begin
 Inherited Create(true);
 FreeOnTerminate:=true;
 Priority:=tpLowest;
 Transfer:=ATransfer;
 Resume;
end;

destructor TKeepAliveThread.Destroy;
begin
 try
  if not Transfer.connected then
   Transfer.KeepAliveTimer.Interval:=100;
  Transfer.KeepAliveTimer.Enabled:=true;
 except
  Inherited Destroy;
 end; 
end;

procedure TKeepAliveThread.Execute;
begin
 with Transfer do
 begin
  LastError:='';
  Assert(False,'LOG KA '+host);
  IntDoDumbCommand;
  UpdateConnectedFromLastError(true);
 end;
end;

procedure TBaseTransfer.SetProp(Prop : TTransferFields; Val: Variant);
begin
end;

end.
