unit StringViewFrm; //modeless

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdCtrls, OptFolders,OptForm, JvxCtrls,ClipBrd, Menus, DIPcre, OptProcs;

type
  TStringViewForm = class(TOptiForm)
    ListBox: TjvTextListBox;
    PopupMenu: TPopupMenu;
    CopytoClipboardItem: TMenuItem;
    Copylinetoclipboard1: TMenuItem;
    LinePcre: TDIPcre;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CopytoClipboardItemClick(Sender: TObject);
    procedure Copylinetoclipboard1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListBoxDblClick(Sender: TObject);
  protected
    procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix, index: Integer); override;
  end;

Procedure ViewStringForm(const Str,Title,AName : String);
Procedure UpdateStringForm(const Str,AName : String);

implementation
var
 OpenWins : TStringList;

{$R *.DFM}

Procedure UpdateStringForm(const Str,AName : String);
var
 StringViewForm: TStringViewForm;
 i:integer;
 s:string;
 sl : TStringList;
begin
 i:=OpenWins.IndexOf(AName);
 if i<0
  then exit
  else StringViewForm:=TStringViewForm(OpenWins.Objects[i]);

 sl:=TStringList.Create;
 StringViewForm.ListBox.Clear;
 try
  sl.Text:=str;
  for i:=0 to sl.Count-1 do
  begin
   s:=copy(sl[i],1,999);
   if pos('DB<',s)=0 then
    StringViewForm.ListBox.Items.add(s);
  end;
 finally
  sl.free;
 end; 
end;

Procedure ViewStringForm(const Str,Title,AName : String);
var
 StringViewForm: TStringViewForm;
 i:integer;
begin
 if length(AName)>0 then
  begin
   i:=OpenWins.IndexOf(AName);
   if i<0 then
    begin
     StringViewForm:=TStringViewForm.CreateNamed(Application,AName);
     OpenWins.AddObject(AName,StringViewForm);
    end
   else
    StringViewForm:=TStringViewForm(OpenWins.Objects[i]);
  end
 else
  StringViewForm:=TStringViewForm.CreateNormal(Application);

 With StringViewForm do
 begin
  SetCaption(Title);
  Listbox.Items.Text:=str;
  Show;
 end;
end;

procedure TStringViewForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TStringViewForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=nil;
 Alignment:=drtNone;
 Pix:=0;
 Index:=InDebugs;
end;

procedure TStringViewForm.CopytoClipboardItemClick(Sender: TObject);
begin
 ClipBoard.AsText:=ListBox.Items.Text;
end;

procedure TStringViewForm.Copylinetoclipboard1Click(Sender: TObject);
begin
 if ListBox.ItemIndex>=0 then
  ClipBoard.AsText:=ListBox.Items[ListBox.itemindex];
end;

procedure TStringViewForm.FormDestroy(Sender: TObject);
var i:integer;
begin
 i:=OpenWins.IndexOf(name);
 if i>=0 then
  OpenWins.Delete(i);
end;

procedure TStringViewForm.ListBoxDblClick(Sender: TObject);
var s:string;
begin
 if listbox.ItemIndex<0 then exit;
 s:=ListBox.Items[Listbox.itemindex];
 if linepcre.MatchStr(s)>0 then
  PR_GotoLine(linepcre.SubStr(1),StrToInt(linepcre.SubStr(2))-1);
end;

initialization
 OpenWins:=TStringList.Create;
 OpenWins.Sorted:=true;
finalization
 OpenWins.free;
end.