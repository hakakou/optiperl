unit HakaControls;

interface
uses comctrls,Windows,controls,classes,sysutils,stdctrls,
     hakageneral, variants, agproputils;

Procedure SafeLoadFileInListBox(Const Filename : String; List : TStrings; StartFrom : Integer = 0);

//tab Control
Procedure ScrollTabPage(Control : TTabControl; Direction : Integer; ScrollStart : Boolean); overload;
Procedure ScrollTabPage(Control : TPageControl; Direction : Integer; ScrollStart : Boolean); overload;

//Combo Box
Function HandleComboBoxText(CB : TComboBox; Max : Integer) : Boolean;
Procedure NormalizeControl(WinControl : TWinControl; H : Integer);
Procedure SetComboHeight(CB : TCustomCombo; H : Integer);
Procedure SetComboBoxActiveIndex(CB : TComboBox; Const Str : String; Default : Integer);

implementation

Procedure SetComboBoxActiveIndex(CB : TComboBox; Const Str : String; Default : Integer);
var
 i:integer;
begin
 i:=cb.items.IndexOf(str);
 if i<0 then i:=default;
 cb.ItemIndex:=i;
end;

Procedure SafeLoadFileInListBox(Const Filename : String; List : TStrings; StartFrom : Integer = 0);
var
 sl:TStringList;
 fs:TFileStream;
 i:integer;
begin
 fs:=TFileStream.Create(filename,fmOpenRead or fmShareDenyNone);
 fs.Position:=StartFrom;
 sl:=TStringList.Create;
 try
  list.Clear;
  sl.LoadFromStream(fs);
  for i:=0 to sl.Count-1 do
   list.Add(copy(sl[i],1,999));
 finally
  fs.free;
  sl.free;
 end;
end;

Procedure SetComboHeight(CB : TCustomCombo; H : Integer);
var i:integer;
begin
 i:=cb.Height-TComboBox(cb).ItemHeight;
 TComboBox(cb).ItemHeight:=h-i;
end;

Procedure NormalizeControl(WinControl : TWinControl; H : Integer);
var
 CH : Integer;

Procedure DONormalizeControl(WinControl : TWinControl; H : Integer);
var
 i:integer;
begin
 with wincontrol do
 for i:=0 to ControlCount-1 do
  begin
   if (controls[i].ClassName='TDCFileNameEdit') or
      (controls[i].ClassName='TDCDirectoryEdit') or
      (controls[i].ClassName='TJvSpinEdit')
    then Controls[i].Height:=H
   else
   if (controls[i] is TCustomCombo) then
   begin
     if (ch=0) then
     begin
      if TComboBox(Controls[i]).ItemHeight<>0
       then ch:=Controls[i].Height-TComboBox(Controls[i]).ItemHeight
       else ch:=6;
     end;
     TComboBox(Controls[i]).ItemHeight:=h-ch;
   end

   else
   if (controls[i] is TWinControl) and
      (TWinControl(Controls[i]).ControlCount>0)
    then NormalizeControl(Controls[i] as TWinControl,H);
  end;
end;

begin
 CH:=0;
 DONormalizeControl(WinControl,H);
end;

Procedure ScrollTabPage(Control : TTabControl; Direction : Integer; ScrollStart : Boolean); overload;
var i:integer;
begin
 with control do
 begin
  if Tabs.count<=1 then exit;
  tabindex:=IncreaseNumber(tabs.count,tabindex+1,direction,scrollstart)-1;
 end;
end;

Procedure ScrollTabPage(Control : TPageControl; Direction : Integer; ScrollStart : Boolean); overload;
begin
 with control do
 begin
  if PageCount<=1 then exit;
  ActivePageindex:=IncreaseNumber(PageCount,ActivePageIndex+1,direction,scrollstart)-1;
 end;
end;


Function HandleComboBoxText(CB : TComboBox; Max : Integer) : Boolean;
begin
 with CB do begin
  if text='' then begin
   result:=false;
   exit;
  end;
  result:=items.IndexOf(text)=-1;
  if result then items.Insert(0,text);
  if items.count>Max then
  begin
   repeat
    items.Delete(Max);
   until items.count=Max;
   result:=true;
  end;
 end;
end;


Function ReturnBool(const c:string) : Boolean;
const
 BoolStr : array[false..true] of char = ('F','T');
begin
 result:=BoolStr[True]=c[1];
end;


end.

