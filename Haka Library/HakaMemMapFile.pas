unit HakaMemMapFile;

interface
uses sysutils,classes,windows;

type
  EMMFError = class(exception);

  TMemMapFile = class
  private
   FFilename : string;
   FSize,FFIleSize : LongInt;
   FFileMode : integer;
   FFileHandle,FMapHandle : Integer;
   FData : PByte;
   FMapNow : Boolean;
   procedure AllocFileHandle;
   procedure AllocFileMapping;
   procedure AllocFileView;
   function GetSize : Longint;
   Procedure SetSize(NewSize : LongInt);
  public
   Constructor Create(Filename: String; FileMode,Size : Integer;
                      MapNow : Boolean); virtual;
   destructor Destroy; override;
   procedure ClearMemory;
   procedure FreeMapping;
   property Data : PByte read Fdata;
   property Size : LongInt read GetSize write SetSize;
   property FileName : String read FFileName;
   property MapHandle: Integer read FMapHandle;
  end;


  TCacheMapFile = class
  private
   Fname : string;
   FSize : LongInt;
   FMapHandle : Integer;
   FData : PByte;
   procedure AllocFileMapping;
   procedure AllocFileView;
   function GetSize : Longint;
   procedure FreeMapping;
  public
   Existed : Boolean;
   Constructor Create(Name: String; Size : Integer); virtual;
   destructor Destroy; override;
   procedure ClearMemory;
   property Data : PByte read Fdata;
   property Size : LongInt read GetSize;
   property Name : String read FName;
   property MapHandle: Integer read FMapHandle;
  end;

  PFifoRec = ^TFifoRec;
  TFifoRec = Packed Record
   Count,Index,LastIndex : Integer;
   Data : Array[0..MaxInt-32] of char;
  end;

  TFIFOStringList = Class
  private
   FRec : PFifoRec;
   FSize : Integer;
   Function GetCount : Integer;
   procedure IncIndex(Amount: Integer);
  public
   Function PutString(Const Text : String) : Boolean;
   Function PutInteger(Int : Integer) : Boolean;
   Function PutByte(B : Byte) : Boolean;
   Function GetString : String;
   Function GetInteger : Integer;
   Function GetByte : Byte;
   Constructor Create(Data : Pointer; Size : Integer; Creator : Boolean);
   property Count : Integer read GetCount;
  end;


implementation
{ TMemMapFile }

procedure TMemMapFile.AllocFileHandle;
begin
 if FFileMode = fmCreate then
  FFileHandle:=FileCreate(FFileName)
 else
  FFileHandle:=FileOpen(FFileName,FFileMode);
 if FFileMode<0 then
  raise EMMFError.create('Failed to open or create file');
end;

procedure TMemMapFile.AllocFileMapping;
var protattr : DWord;
begin
 if FFileMode = fmOpenRead
  then ProtAttr:=Page_ReadOnly
  else ProtAttr:=Page_ReadWrite;
 FMapHandle:=CreateFileMapping(FFileHandle,nil,protAttr,0,FSize,nil);
 if FMapHandle = 0 then
  raise EMMFError.create('Failed to create file mapping');
end;

procedure TMemMapFile.AllocFileView;
var Access : longint;
begin
 If FileMode=fmopenread
  then Access:=File_map_read
  else Access:=File_map_All_Access;
 FData:=MapViewOfFile(FMapHandle,Access,0,0,FSize);
 IF FData = nil then
  raise EMMFError.create('Failed to map view of file');
end;

procedure TMemMapFile.ClearMemory;
begin
 fillchar(fdata,FSize,0);
end;

constructor TMemMapFile.Create(Filename: String; FileMode, Size: Integer;
  MapNow: Boolean);
begin
 FMapNow:=MapNow;
 FFilename:=filename;
 FFileMode:=FileMode;
 AllocFileHandle;
 FFileSize:=GetFileSize(FFileHandle,nil);
 Fsize:=Size;
 try
  AllocFileMapping;
 except
  on EMMFError do
  begin
   closehandle(FFileHandle);
   FFileHandle:=0;
   raise;
  end;
 end;
 if FMapNow then AllocFileView;
 inherited create;
end;

destructor TMemMapFile.Destroy;
begin
 IF FFileHandle<>0 then
  closeHandle(FFileHandle);
 if FMapHandle<>0 then
  closehandle(FMapHandle);
 Freemapping;
 inherited destroy;
end;

procedure TMemMapFile.FreeMapping;
begin
 if FData<>nil then
 begin
  UnMapViewofFile(FData);
  FData:=nil;
 end;
end;

function TMemMapFile.GetSize: Longint;
begin
 if Fsize<>0 then result:=FSize else result:=FFileSize;
end;

procedure TMemMapFile.SetSize(NewSize: Integer);
begin
 IF FFileHandle<>0 then
  closeHandle(FFileHandle);
 if FMapHandle<>0 then
  closehandle(FMapHandle);
 Freemapping;
 FSize:=NewSize;
 FFilemode:=fmopenreadwrite;
 AllocFileHandle;
 try
  AllocFileMapping;
 except
  on EMMFError do
  begin
   closehandle(FFileHandle);
   FFileHandle:=0;
   raise;
  end;
 end;
 if FMapNow then AllocFileView;
 FFileSize:=GetFileSize(FFileHandle,nil);
end;


{ TCacheMapFile }


procedure TCacheMapFile.AllocFileMapping;
begin
 FMapHandle:=CreateFileMapping($FFFFFFFF,nil,PAGE_READWRITE,0,FSize,PChar(FName));
 if FMapHandle = 0 then
  raise EMMFError.create('Failed to create file mapping')
 else
  Existed:=GetLastError=ERROR_ALREADY_EXISTS;
end;

procedure TCacheMapFile.AllocFileView;
begin
 FData:=MapViewOfFile(FMapHandle,File_map_All_Access,0,0,FSize);
 IF FData = nil then
  raise EMMFError.create('Failed to map view of file');
end;

procedure TCacheMapFile.ClearMemory;
begin
 fillchar(fdata,FSize,0);
end;

constructor TCacheMapFile.Create(Name: String; Size: Integer);
begin
 FName:=Name;
 Fsize:=Size;
 AllocFileMapping;
 AllocFileView;
 inherited create;
end;

destructor TCacheMapFile.Destroy;
begin
 if FMapHandle<>0 then
  closehandle(FMapHandle);
 Freemapping;
 inherited destroy;
end;

procedure TCacheMapFile.FreeMapping;
begin
 if FData<>nil then
 begin
  UnMapViewofFile(FData);
  FData:=nil;
 end;
end;

function TCacheMapFile.GetSize: Longint;
begin
 result:=FSize;
end;


{ TFIFOStringList }

Function TFIFOStringList.PutString(const Text: String) : Boolean;
var
 i:integer;
begin
 i:=length(text);
 result:=FRec.LastIndex+i<FSize;
 if result then
 begin
  move(Text[1],FRec.Data[FRec.LastIndex],i);
  inc(FRec.LastIndex,i);
  FRec.Data[FRec.LastIndex]:=#0;
  inc(FRec.LastIndex);
  Inc(FRec.Count);
 end;
end;

function TFIFOStringList.PutInteger(Int: Integer): Boolean;
var
 i:integer;
begin
 i:=SizeOf(Int);
 result:=FRec.LastIndex+i<=FSize;
 if result then
 begin
  move(int,FRec.Data[FRec.LastIndex],i);
  inc(FRec.LastIndex,i);
  Inc(FRec.Count);
 end;
end;

function TFIFOStringList.PutByte(B: Byte): Boolean;
begin
 result:=FRec.LastIndex<FSize;
 if result then
 begin
  move(b,FRec.Data[FRec.LastIndex],1);
  inc(FRec.LastIndex,1);
  Inc(FRec.Count);
 end;
end;

function TFIFOStringList.GetByte: Byte;
begin
 move(FRec.Data[FRec.Index],result,1);
 IncIndex(1);
end;

function TFIFOStringList.GetString: String;
var
 p : PChar;
begin
 p:=@FRec.Data[FRec.Index];
 result:=p;
 IncIndex(length(result)+1);
end;

function TFIFOStringList.GetInteger: Integer;
begin
 move(FRec.Data[FRec.Index],result,sizeof(result));
 IncIndex(sizeof(result));
end;

Procedure TFIFOStringList.IncIndex(Amount : Integer);
begin
 inc(FRec.Index,Amount);
 dec(FRec.Count);
 if FRec.Count=0 then
 begin
  FRec.Index:=0;
  FRec.LastIndex:=0;
 end;
end;

constructor TFIFOStringList.Create(Data: Pointer; Size: Integer; Creator : Boolean);
begin
 FRec:=Data;
 FSize:=Size;
 if creator then
 begin
  FRec.Count:=0;
  FRec.Index:=0;
  FRec.LastIndex:=0;
 end; 
end;

function TFIFOStringList.GetCount: Integer;
begin
 result:=FRec.Count;
end;

end.
