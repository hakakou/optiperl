unit HakaSecurity;

interface
uses HCMngr,classes,sysutils;

type TAskPassword = Function : string of object;


Procedure SaveEncodedStream(Ms : TMemoryStream; const Password,filename : String;
            Cipher:TCipherManager);
function loadEncodedStream(const filename : String;
           Cipher:TCipherManager; AskPassword: TAskPassword) : TMemoryStream;

implementation

Procedure SaveEncodedStream(Ms : TMemoryStream; const Password,filename : String;
                            Cipher:TCipherManager);
var c:char;
fs : TFileStream;
mstemp : TMemoryStream;
begin
 if ms.size=0 then exit;
 fs:=TFilestream.Create(Filename,fmCreate);
 try
  if (cipher=nil) or (password='') then begin
   c:='!';
   ms.position:=0;
   fs.Write(c,sizeof(c));
   fs.CopyFrom(ms,0);
  end else begin
   mstemp:=TMemoryStream.create;
   try
    c:='*';
    fs.write(c,sizeof(c));
    cipher.InitKey(password,nil);
    ms.position:=0;
    cipher.EncodeStream(ms,mstemp,ms.Size);
    mstemp.position:=0;
    fs.CopyFrom(mstemp,mstemp.size);
   finally
    mstemp.free;
   end;
  end;
 finally
  fs.Free;
 end;
end;

function loadEncodedStream(const filename : String;
           Cipher:TCipherManager; AskPassword: TAskPassword) : TMemoryStream;
var
 c:char;
 fs : TFileStream;  mstemp : TMemoryStream;
begin
 result:=nil;
 if not fileexists(filename) then exit;
 fs:=TFilestream.Create(Filename,fmOpenRead);
 if fs.size=0 then abort;
 mstemp:=TMemorystream.create;
 try
  fs.read(c,sizeof(c));
  if (cipher=nil) or (c='!') or (not assigned(askpassword)) then begin
   mstemp.CopyFrom(fs,fs.size-1);
   mstemp.position:=0;
   result:=mstemp;
  end else begin
   cipher.InitKey(askpassword,nil);
   cipher.DecodeStream(fs,mstemp,fs.size-1);
   mstemp.position:=0;
   result:=mstemp;
  end;
 finally
  fs.free;
 end;
end;


end.
