unit HakaFTP;
interface

uses classes,sysutils,Psock, NMFtp,hyperstr,fileutil,hakahyper;

type

 TFTPUploadRec = Record
  LocalFile,RemotePath,RemoteFile : string;
  CHMod : Integer;
  CRC : Integer;
  Text : Boolean;
  StatusOK : Boolean;
  Status : string;
 end;

 TFTPUploadList = array of TFTPUploadRec;

procedure CancelSynchro;
procedure ForceDirectory(path : string; FTP : TNMFTP);
Procedure SynchronizePath(var FTPList : TFTPUploadList; StartPath : string; FTP: TNMFTP);
Function FTPFileExists(const Filename : string; FTP : TNMFTP) : Boolean;

implementation
var cancel : Boolean;

Function FTPFileExists(const Filename : string; FTP : TNMFTP) : Boolean;
begin
 Result:=True;
 try
  FTP.DoCommand('SIZE '+filename);
 except
  on Exception do Result:=False;
 end;
end;

procedure CancelSynchro;
begin
 cancel:=True;
end;

procedure ForceDirectory(path : string; FTP : TNMFTP);
var
 i:integer;
 w:string;
begin
 if Length(path)=0 then Exit;
 try
  FTP.ChangeDir(path);
  Exit;
 except
  on Exception do
 end;

 replaceC(path,'\','/');
 if path[1]='/' then FTP.ChangeDir('/');
 I := 1;
 repeat
  W := Parse(path,'/',I);
  if Length(w)>0 then
  begin
   try
    FTP.ChangeDir(w);
   except
   on Exception do
    begin
     FTP.makedirectory(w);
     FTP.changeDir(w);
    end;
   end;
  end;
 until (I<1) or (I>Length(path));
end;


Procedure SynchronizePath(var FTPList : TFTPUploadList; StartPath : string; FTP: TNMFTP);
var
 i,j : Integer;
 crc : Integer;
 temp : string;
 IsText : Boolean;
 Path,PrevPath : string;
begin
 cancel:=False;
 if (not Assigned(FTP)) or (not Assigned(FTPList)) or (Length(FTPList)=0) then Exit;

 isText:=not FTPList[0].Text;
 PrevPath:=FTP.CurrentDir;

 for i:=0 to Length(FTPList)-1 do
 begin
  if fileexists(FTPList[i].LocalFile) then
  begin
   crc:=GetFileCrc32(FTPList[i].LocalFile);

   if (crc<>FTPList[i].CRC) then
   begin

    Path:=IncludeTrailingBackSlash(StartPath)+FTPList[i].RemotePath;
    ReplaceC(Path,'\','/');
    ReplaceSC(Path,'//','/',false);
    ReplaceSC(Path,'//','/',false);

    if FTPlist[i].Text<>IsText then
    begin
     if FTPlist[i].Text
      then ftp.Mode(MODE_ASCII)
      else ftp.Mode(MODE_BYTE);
     IsText:=FTPlist[i].Text;
    end;

    FTPList[i].StatusOK:=false;

    try
     if PrevPath<>FTPList[i].RemotePath then
     begin
      ForceDirectory(Path,FTP);
      PrevPath:=Path;
     end;

     FTP.Upload(FTPList[i].LocalFile,FTPList[i].RemoteFile);
     ftpList[i].CRC:=crc;
     FTPList[i].StatusOK:=true;
     FTPList[i].status:='Uploaded';
    except
     on Exception do
     begin
      FTPList[i].StatusOK:=False;
      FTPList[i].status:='Could not upload '+FTPList[i].LocalFile;
      continue;
     end;
    end;

    if FTPList[i].chmod>=0 then
    try
     FTP.DoCommand('SITE CHMOD '+inttostr(FTPList[i].CHMOD)+' '+FTPList[i].RemoteFile);
    except
     on exception do begin
      FTPList[i].status:='Uploaded, but could not Chmod';
      continue;
     end;
    end;

   end

    else FTPList[i].status:='Not Changed';

  end;
  if cancel then Exit;
 end;
end;

end.

