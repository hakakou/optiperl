unit URLEncodeFrm; //modeless //memo 2

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,hyperstr,clipbrd, OptFolders, dccommon,Hakawin,
  dcmemo,fscrypt,OptForm,OptOptions,OptControl,dcString,
  httpapp,hakageneral, JvPlacemnt;

type
  TURLEncodeForm = class(TOptiForm)
    btnInsNormal: TButton;
    btnInsURL: TButton;
    btnNorCopy: TButton;
    btnCopyURL: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Memo1: TDCMemo;
    memo2: TDCMemo;
    cbEncoding: TComboBox;
    FormStorage: TjvFormStorage;
    procedure Memo1Change(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure btnInsNormalClick(Sender: TObject);
    procedure btnInsURLClick(Sender: TObject);
    procedure btnNorCopyClick(Sender: TObject);
    procedure btnCopyURLClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbEncodingChange(Sender: TObject);
  Protected
    procedure FirstShow(Sender: TObject); override;
  private
    Memo : TDCMemo;
    procedure AddText(const AText : String);
    function Encode(const str : string) : string;
    function Decode(const str : string) : string;
  protected
    procedure SetDockPosition(var Alignment: TRegionType;
      var Form: TDockingControl; var Pix, index: Integer); override;
  public
    Procedure UpdateText;
  end;

var
  URLEncodeForm: TURLEncodeForm;


implementation

const
 BtnCap : array[boolean] of string = ('Insert','Replace');

{$R *.DFM}

procedure TURLEncodeForm.Memo1Change(Sender: TObject);
begin
 if not memo1.focused then exit;
 memo2.lines.Text:=Encode(memo1.GetRealText);
end;

procedure TURLEncodeForm.Memo2Change(Sender: TObject);
begin
 if not memo2.focused then exit;
 memo1.lines.text:=decode(memo2.GetRealText);
end;

procedure TURLEncodeForm.AddText(const AText : String);
begin
 if memolist.IndexOf(memo)>=0 then
 with memo do
 begin
  if sellength=0 then
   begin
     memosource.BeginUpdate(acInsert);
     memosource.InsertString(Atext);
     memosource.EndUpdate;
   end
  else
   begin
    memosource.BeginUpdate(acReplace);
    SelText:=Atext;
    memosource.EndUpdate;
    FocusControl(self);
    btnInsNormal.Caption:=BtnCap[false];
    btnInsUrl.Caption:=BtnCap[false];
   end;
 end;
end;

procedure TURLEncodeForm.btnInsNormalClick(Sender: TObject);
begin
 AddText(memo1.GetRealtext);
end;

procedure TURLEncodeForm.btnInsURLClick(Sender: TObject);
begin
 AddText(memo2.GetRealtext);
end;

procedure TURLEncodeForm.btnNorCopyClick(Sender: TObject);
begin
 clipboard.AsText:=Memo1.GetRealText;
end;

procedure TURLEncodeForm.btnCopyURLClick(Sender: TObject);
begin
 clipboard.AsText:=Memo2.GetRealText;
end;

procedure TURLEncodeForm.UpdateText;
var
 s:string;
 p:integer;
begin
 memo:=activeEdit.Memo;
 btnInsNormal.Enabled:=assigned(memo);
 btnInsUrl.Enabled:=assigned(memo);
 btnInsNormal.Caption:=BtnCap[assigned(memo) and (memo.sellength>0)];
 btnInsUrl.Caption:=btnInsNormal.Caption;
 if (assigned(memo)) and (memo.SelLength>0) then
  begin
    p:=1;
    s:=Memo.GetRealSelection;

    case cbEncoding.ItemIndex of
     0:
     if ScanW(s,'%$$',p)<>0 then
      begin
       memo2.lines.text:=s;
       memo1.lines.text:=decode(memo2.getrealtext);
      end
     else
      begin
       memo1.lines.text:=s;
       memo2.lines.text:=Encode(memo1.getrealtext);
      end;

     1:
     if (pos(#13,s)<>0) or (pos(' ',s)<>0) then
      begin
       memo1.lines.text:=s;
       memo2.lines.text:=Encode(memo1.getrealtext);
      end
     else
      begin
       memo2.lines.text:=s;
       memo1.lines.text:=decode(memo2.getrealtext);
      end

     else
     begin
       memo1.lines.text:=s;
       memo2.lines.text:=Encode(memo1.getrealtext);
     end;
    end; //case
  end;

// FocusControl(memo1);
end;


procedure TURLEncodeForm.FormCreate(Sender: TObject);
begin
 SetMemo(memo1,[]);
 SetMemo(memo2,[]);
 SetConstraints(
 btnInsURL.Width*3+35,
 label1.Height*2+btnInsURL.Height*6+memo2.Height+15
 );
end;

procedure TURLEncodeForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 URLEncodeForm:=nil;
end;

function TURLEncodeForm.Encode(const str: string): string;
var i : Int64;
begin
 result:='';
 try
  case cbEncoding.ItemIndex of
   0 : Result:=HTTPEncode(str);
   1 : Result:=EncodeStr(str);
   2 : Result:=UUEncode(str);
   3 : Result:=Crypt(str);

   5 : Result:=IntToHex(strToInt(trim(str)),8);
   6 : Result:=IntToBin(strtoInt(trim(str)));

   8 : Result:=AnsiUppercase(str);
   9 : result:=AnsiLowerCase(Str);
   10: begin Result:=str; Propercase(result); end;

   12 : Result:=LowerCase(NumToWord(trim(str),false));
   13 : result:=RomanNum(strtoIntDef(trim(str),0));
  end;
 except
  on Exception do result:='Error!';
 end;
 {
0 HTTP encode
1 Base64
2 UUEncoded
3 Unix Crypt
4 --
5 Hexadecimal
6 Binary
7 --
8 UPPER case
9 lower case
10 Proper Case
11 --
12 Human number
13 Roman number
}

end;

function TURLEncodeForm.Decode(const str: string): string;
begin
 result:='';
 try
  case cbEncoding.ItemIndex of
   0 : Result:=HTTPDecode(str);
   1 : Result:=DecodeStr(str);
   5 : if length(trim(str))<=8
        then Result:=IntToStr(HexToInt(uppercase(trim(str))))
        else result:='Error!';
   6 : if length(trim(str))<=32
        then Result:=IntToStr(BinToInt(trim(str)))
        else result:='Error!';
   8 : Result:=AnsiLowercase(str);
   9 : result:=AnsiUpperCase(Str);
  end;
 except
  on Exception do result:='Error!';
 end;
end;

procedure TURLEncodeForm.cbEncodingChange(Sender: TObject);
begin
 memo2.lines.text:=Encode(memo1.getrealtext);
end;

procedure TURLEncodeForm.FirstShow(Sender: TObject);
begin
 UpdateText;
end;

procedure TURLEncodeForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtTop;
 Pix:=0;
 Index:=InTools;
end;


end.