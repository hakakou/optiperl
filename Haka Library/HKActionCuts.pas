unit HKActionCuts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, StdCtrls, ComCtrls, HyperStr, Buttons, ExtCtrls, menus;

type
  TActionArray = Array of TActionList;

  TShortcutForm = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    GroupBox2: TGroupBox;
    ItemBox: TListBox;
    HotKey: THotKey;
    btnDefault: TButton;
    btnSet: TSpeedButton;
    btnClear: TSpeedButton;
    CatBox: TListBox;
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    lblDesc: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CatBoxClick(Sender: TObject);
    procedure ItemBoxClick(Sender: TObject);
    procedure btnSetClick(Sender: TObject);
    procedure ItemBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure btnCancelClick(Sender: TObject);
    procedure btnDefaultClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnClearClick(Sender: TObject);
  public
    Procedure SetItems(AL : TActionArray; len: integer);
  private
    Items : TStringList;
    Original : TStringList;
    procedure ExportList(const fname : String; Sh : Boolean);
  end;

Procedure EditActionShortcuts(ActionLists : Array of TActionlist; HelpContext : Integer = 0);
Procedure GetDefaultShortcuts(ActionLists : Array of TActionlist);
Procedure LoadShortCuts(ActionLists : Array of TActionlist; const f:String);
Procedure SaveShortCuts(ActionLists : Array of TActionlist; const f:String);


implementation

var
 defaults : TStringList;

{$R *.DFM}

Procedure LoadShortCuts(ActionLists : Array of TActionlist; const f:String);
var
 i,j,c : Integer;
 s:string;
 sl : TStringList;
begin
 try
 if not fileexists(f) then exit;
 sl:=TStringList.create;
 try
  sl.LoadFromFile(f);
  for i:=0 to sl.count-1 do
  begin
   s:=sl[i];
   j:=pos(',',s);
   sl[i]:=copy(s,1,j-1);
   s:=copy(s,j+1,length(s));
   val(s,j,c);
   if c<>0 then j:=0;
   sl.objects[i]:=TObject(j);
  end;

  sl.Sorted:=true;
  sl.Sort;

  for i:=0 to length(ActionLists)-1 do
   for j:=0 to ActionLists[i].ActionCount-1 do
   begin
    c:=sl.IndexOf(ActionLists[i].Actions[j].Name);
    if c>=0 then
     TCustomAction(ActionLists[i].Actions[j]).shortcut:=
       TShortcut(sl.Objects[c])
   end;

 finally
  sl.free;
 end;

 except
  on exception do
 end;

end;

Procedure SaveShortCuts(ActionLists : Array of TActionlist; const f:String);
var
 i,j : Integer;
 sl : TStringList;
begin
 try
 sl:=TStringList.create;
 sl.Sorted:=true;
 try
  for i:=0 to length(ActionLists)-1 do
   for j:=0 to ActionLists[i].ActionCount-1 do
    begin
     sl.add(ActionLists[i].Actions[j].name+','+
            inttostr(TCustomAction(ActionLists[i].Actions[j]).shortcut));

    end;

  sl.SaveToFile(f);
 finally
  sl.free;
 end;

 except
  on exception do
 end;
end;


Procedure GetDefaultShortcuts(ActionLists : Array of TActionlist);
var i,j : Integer;
begin
 for i:=0 to length(ActionLists)-1 do
  for j:=0 to ActionLists[i].ActionCount-1 do
   defaults.Addobject(
            ActionLists[i].Actions[j].Name,
            TObject(TCustomAction(ActionLists[i].Actions[j]).shortcut));

end;

Procedure EditActionShortcuts(ActionLists : Array of TActionlist; HelpContext : Integer = 0);
var
 ShortcutForm: TShortcutForm;
 l : Integer;
begin
 ShortCutForm:=TShortcutForm.Create(Application);
 ShortCutForm.HelpContext:=HelpContext;
 with ShortCutForm do
 try
  l:=length(ActionLists);
  setitems(@ActionLists,l);
  showmodal;
 finally
  ShortCutForm.free;
 end;
end;

Procedure TShortCutForm.SetItems(AL : TActionArray; len : Integer);
var
 i,j:integer;
 s:string;
begin
 for i:=0 to len-1 do
  for j:=0 to AL[i].ActionCount-1 do
  begin
   if TCustomAction(AL[i].Actions[j]).visible then
   try
    s:=AL[i].Actions[j].Category;
    if CatBox.Items.IndexOf(s)<0 then
     CatBox.items.add(s);
    Items.AddObject(AL[i].Actions[j].name,AL[i].Actions[j]);
   except
    on exception do 
   end;
  end;

 for i:=0 to items.Count-1 do
  Original.AddObject(items[i],TObject(TCustomAction(items.objects[i]).shortcut));
end;

procedure TShortcutForm.FormCreate(Sender: TObject);
begin
 lblDesc.Caption:='';
 Items:=TStringList.create;
 items.Duplicates:=dupError;
 original:=TStringList.create;
 Original.Duplicates:=dupError;
end;

procedure TShortcutForm.FormDestroy(Sender: TObject);
begin
 Items.free;
 Original.free;
end;

procedure TShortcutForm.CatBoxClick(Sender: TObject);
var
 s:string;
 i:integer;
begin
 with catbox do
  s:=Items[itemindex];
 ItemBox.clear;
 for i:=0 to items.Count-1 do
  with TCustomAction(items.objects[i]) do
  if category=s then
   ItemBox.Items.AddObject('',items.objects[i]);
end;

procedure TShortcutForm.ItemBoxClick(Sender: TObject);
var
 ci : TCustomAction;
begin
 with itembox do
  ci:=TCustomAction(items.objects[itemindex]);
 hotkey.HotKey:=ci.ShortCut;
 lblDesc.Caption:=ci.Hint;
 HotKey.Enabled:=true;
 btnSet.Enabled:=true;
end;

procedure TShortcutForm.btnSetClick(Sender: TObject);
var
 ci : TCustomAction;
 i:integer;
begin
 if itembox.itemindex<0 then exit;

 if hotkey.hotkey<>0 then
  for i:=0 to items.Count-1 do
  begin
   ci:=TCustomAction(items.objects[i]);
   if (ci.shortcut=hotkey.hotkey) and
      (ci<>TCustomAction(itembox.items.objects[itembox.itemindex])) then
   begin
    if MessageDlg(
     'Hotkey already assigned to "'+ci.Category+' / '+ci.caption+'".'+#13#10+#13#10+
     'Should this shortcut be cleared first?', mtConfirmation, [mbOK,mbCancel], 0)=mrCancel
     then exit
     else ci.ShortCut:=0;
   end;
  end;

 with itembox do
  ci:=TCustomAction(items.objects[itemindex]);
 ci.ShortCut:=hotkey.hotkey;
end;

procedure TShortcutForm.ItemBoxDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  wDisplayText: string;
  ca : TCustomAction;
begin
  itembox.Canvas.Font.assign(itembox.font);
  ca := TCustomAction(itembox.Items.objects[index]);

  if odSelected in State then
  begin
    itembox.Canvas.Brush.Color := clHighlight;
    itembox.Canvas.Font.Color := clHighlightText;
  end
  else
  begin
    itembox.Canvas.Brush.Color := clWindow;
    itembox.Canvas.Font.Color := clWindowText;
  end;
  itembox.Canvas.FillRect(rect);

  {if (wKeyData.DesignLocked) then
  begin
     itembox.Canvas.Font.Style := [fsitalic];
     itembox.Canvas.Font.color := clGrayText;
  end;}

  with ca.actionlist do
  if assigned(images) then
  begin
     images.Draw(itembox.Canvas,rect.left,rect.top,ca.ImageIndex);
     rect.Left := rect.left + (images.width) + 4;
  end
  else
     rect.Left := rect.left + 1;

  wDisplayText := ca.caption;
  replacesc(wDisplayText,'&','',false);
  itembox.Canvas.TextRect(rect,rect.left,rect.top,wDisplayText);
end;

procedure TShortcutForm.btnCancelClick(Sender: TObject);
var
 i:integer;
begin
 for i:=0 to items.Count-1 do
  TCustomAction(items.objects[i]).shortcut:=TShortcut(Original.Objects[i]);
end;

procedure TShortcutForm.btnDefaultClick(Sender: TObject);
var
 i,p:integer;
begin
 for i:=0 to items.Count-1 do
 begin
  p:=Defaults.IndexOf(items[i]);
  if p>=0 then
   TCustomAction(items.objects[i]).shortcut:=TShortcut(Defaults.Objects[p])
 end;

// ExportList('c:\actions.txt',false);
// ExportList('c:\shortcuts.txt',true);
end;

procedure TShortcutForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if key=VK_BACK then
 Begin
  HotKey.HotKey:=HotKey.HotKey+VK_Back;
  key:=0;
 end

 else
 if key=VK_DELETE then
 Begin
  HotKey.HotKey:=HotKey.HotKey+VK_DELETE;
  key:=0;
 end;
end;

procedure TShortcutForm.btnClearClick(Sender: TObject);
begin
 hotkey.HotKey:=0;
 btnSetClick(sender);
end;

procedure TShortcutForm.ExportList(const fname : String; Sh : Boolean);
var
 c,i : Integer;
 sl : TStringList;
 ci : TCustomAction;
 s:string;
begin
 sl:=TStringList.Create;
 for c:=0 to CatBox.Items.Count-1 do
 begin
  CatBox.ItemIndex:=c;
  CatBoxClick(nil);
  sl.Add('');
  sl.Add('');
  sl.Add(catBox.Items[c]+' Category');
  sl.Add('');
  for i:=0 to ItemBox.Items.Count-1 do
  begin
   ci:=TCustomAction(ItemBox.items.objects[i]);
   if (not sh) or (sh and (ci.ShortCut<>0)) then
   begin
    s:=StripHotKey(ci.Caption);
    if ci.ShortCut<>0 then
     s:=s+'  ('+ShortcutToText(ci.shortcut)+')';
    replaceSC(s,#13,'',false);
    replaceSC(s,#10,' - ',false);
    sl.Add(s);

    s:=StripHotKey(ci.Hint);
    replaceSC(s,#13,'',false);
    replaceSC(s,#10,' - ',false);
    sl.add('Description: '+s);

    sl.add('');
   end;
  end;
 end;
 sl.SaveToFile(fname);
 sl.free;
end;

initialization
 Defaults:=TStringList.create;
 Defaults.Sorted:=true;
 Defaults.Duplicates:=dupError;
finalization
 Defaults.free;
end.
