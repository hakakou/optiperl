unit HKOptions;

interface
uses classes,sysutils,agpropUtils,forms,controls,StdCtrls,TypInfo,Types,
     variants,dialogs,hyperstr,hakageneral,graphics,inifiles,HakaHyper;

type
 THKOptions = class(TPersistent)
 Private
  FVersion : Integer;
  FVars : Array of Variant;
  OptionsList : TStringList;
  Function GetProp(PropInfo : PPropInfo; Obj : TObject) : Variant;
  procedure DoWinControl(WinControl: TWinControl; Setting : Boolean);
  procedure DoSetControl(Control: TControl);
  procedure DoGetControl(Control: TControl);
  Procedure CopyProp(Source,Dest : PPropInfo; SourceObj,DestObj : TObject);
  Procedure MakeOptionsList;
  function GetVar(Index: Integer): Variant;
  procedure SetVar(Index: Integer; Const Value: Variant);
  procedure SetProp(PropInfo: PPropInfo; Obj: TObject; temp: Variant);
 protected
  DebugMode : Boolean;
  HotList : TStringDynArray;
  function GetString(Index: Integer): String;
  procedure SetString(Index: Integer; Const Value: String);
  function GetBool(Index: Integer): Boolean;
  procedure SetBool(Index: Integer; Value: Boolean);
  function GetInt(Index: Integer): Integer;
  procedure SetInt(Index: Integer; Value: Integer);
  function GetInt64(Index: Integer): int64;
  procedure SetInt64(Index: Integer; Value: Int64);
  function GetBrush(Index: Integer): TBrushStyle;
  procedure SetBrush(Index: Integer; Value: TBrushStyle);
  function GetPen(Index: Integer): TPenStyle;
  procedure SetPen(Index: Integer; Value: TPenStyle);
  function GetColor(Index: Integer): TColor;
  procedure SetColor(Index: Integer; Value: TColor);
  function GetReal(Index: Integer): Real;
  procedure SetReal(Index: Integer; Value: Real);
  Procedure LoadCustomSettings(Ini : TInifile); Virtual;
  Procedure SaveCustomSettings(Ini : TInifile); Virtual;
 public
  Streaming : Boolean;
  CurrentVersion : Integer;
  OptionsSection : String;
  procedure Assign(Source: TPersistent); override;
  Procedure SetDefaults; Virtual; Abstract;
  Procedure SaveToFile(Const Filename : String);
  Procedure LoadFromFile(Const Filename : String);
  Procedure SetToForm(Form : TCustomForm);
  Procedure GetFromForm(Form : TCustomForm);
  procedure LoadFromIni(IniFile: TiniFile);
  procedure SaveToIni(IniFile: TiniFile);
  Constructor Create;
  Destructor Destroy; override;
 published
  property Version : Integer read FVersion write FVersion;
 end;

implementation
Const
 DefHotList : Array[0..11] of string = ('Selected','Filename','Value','Checked','Text','FontName','ItemIndex','Items','Lines','BrushStyle','PenStyle','Caption');
 BadChars = '[=]%';

{ THKOptions }

function THKOptions.GetVar(Index: Integer): Variant;
begin
 if index<Length(FVars)
  then result:=FVars[index]
  else VarClear(Result);
end;

procedure THKOptions.SetVar(Index: Integer; const Value: Variant);
begin
 if index>=Length(FVars)
  then setlength(FVars,index+1);
 FVars[index]:=value;
end;

function THKOptions.GetColor(Index: Integer): TColor;
begin
 result:=GetVar(index);
end;

procedure THKOptions.SetColor(Index: Integer; Value: TColor);
begin
 SetVar(index,value);
end;

function THKOptions.GetBool(Index: Integer): Boolean;
begin
 result:=GetVar(index);
end;

procedure THKOptions.SetBool(Index: Integer; Value: Boolean);
begin
 SetVar(index,value);
end;

function THKOptions.GetString(Index: Integer): String;
begin
 Result:=GetVar(index);
end;

procedure THKOptions.SetString(Index: Integer; Const Value: String);
begin
 SetVar(index,value);
end;

function THKOptions.GetInt(Index: Integer): Integer;
begin
 result:=GetVar(index);
end;

procedure THKOptions.SetInt(Index, Value: Integer);
begin
 SetVar(index,value);
end;

function THKOptions.GetInt64(Index: Integer): int64;
begin
 result:=GetVar(index);
end;

procedure THKOptions.SetInt64(Index: Integer; Value: Int64);
begin
 SetVar(index,value);
end;

function THKOptions.GetBrush(Index: Integer): TBrushStyle;
begin
 result:=TBrushStyle(GetInt(index));
end;

function THKOptions.GetReal(Index: Integer): Real;
begin
 result:=GetVar(index);
end;

procedure THKOptions.SetReal(Index: Integer; Value: Real);
begin
 SetVar(index,Value);
end;

function THKOptions.GetPen(Index: Integer): TPenStyle;
begin
 result:=TPenStyle(GetInt(index));
end;

procedure THKOptions.SetBrush(Index: Integer; Value: TBrushStyle);
begin
 SetInt(index,ord(value));
end;

procedure THKOptions.SetPen(Index: Integer; Value: TPenStyle);
begin
 SetInt(index,ord(value));
end;

Procedure THKOptions.LoadFromFile(const Filename: String);
var
 inifile : TInifile;
begin
 inifile:=TInifile.Create(filename);
 //XARKA INIFILE
 try
  LoadFromIni(inifile);
 finally
  inifile.Free;
 end;
end;

Procedure THKOptions.LoadFromIni(IniFile : TiniFile);
var
 i : integer;
 SL:TStringList;
 temp:variant;
 v1,v2 : string;
 PropInfo: PPropInfo;
begin
 SL:=TStringList.Create;
 try
  inifile.ReadSectionValues(OptionsSection,sl);
  for i:=0 to sl.count-1 do
  if ParseWithEqual(sl[i],v1,v2) then
  begin
   propinfo:=GetPropInfo(classinfo,v1);
   if not assigned(propinfo) then continue;
   temp:=v2;
   try
    case PropInfo^.PropType^.Kind of
     tkString,tkLString,tkWString: SetStrProp(self,PropInfo,DecodeIni(temp));
     else SetProp(PropInfo,self,temp);
    end;
   except
    on exception do
     showmessage('Cannot load setting for option "'+v1+'"');
   end;
  end;
  LoadCustomSettings(inifile);
 finally
  sL.free;
 end;
end;

Procedure THKOptions.SaveToFile(const Filename: String);
var
 inifile : TInifile;
begin
 inifile:=TInifile.Create(filename);
 //XARKA INIFILE
 try
  SaveToIni(inifile);
 finally
  inifile.Free;
 end;
end;

Procedure THKOptions.SaveToIni(IniFile : TiniFile);
var
 proplist : PPropList;
 i,count : integer;
 temp:variant;
 name : string;
begin
 streaming:=true;
 try
  Version:=CurrentVersion;
  count:=GetPropList(self,PropList);
  for i:=0 to count-1 do
  begin
   name:=PropList^[i].Name;
   temp:=GetProp(PropList^[i],self);
   if varistype(temp,[varString,varOleStr]) then
    temp:=EncodeIni(temp);
   inifile.WriteString(OptionsSection,name,VarAsType(temp,varString));
  end;
  SaveCustomSettings(inifile);
 finally
  streaming:=false;
 end;
end;

procedure THKOptions.DoWinControl(WinControl : TWinControl; Setting : Boolean);
var
 i:integer;
begin
 with wincontrol do
 for i:=0 to ControlCount-1 do
  begin
   if controls[i].Name<>'' then
   begin
    if Setting
     then DoSetControl(Controls[i])
     else DoGetControl(Controls[i]);
   end;
   if (controls[i] is TWinControl) and
      (TWinControl(Controls[i]).ControlCount>0)
    then DoWinControl(Controls[i] as TWinControl,setting);
  end;
end;

Function THKOptions.GetProp(PropInfo : PPropInfo; Obj : TObject) : Variant;
begin
 case PropInfo^.PropType^.Kind of
  tkString,tkLString,tkWString: result:=GetStrProp(Obj,PropInfo);
  tkInteger: result:=GetOrdProp(Obj,PropInfo);
  tkFloat: result:=GetFloatProp(Obj,PropInfo);
  tkEnumeration: result:=GetEnumProp(Obj,PropInfo);
  tkClass :
  begin
   Obj:=TOBject(GetOrdProp(Obj,PropInfo));
   if obj is TStrings
    then result:=TStrings(Obj).Text
    else showmessage('P3');
  end;
  else
    showmessage('P1 '+PropInfo^.Name);
 end;
end;

Procedure THKOptions.SetProp(PropInfo : PPropInfo; Obj : TObject; temp : Variant);
var
 TObj : TObject;
 i:integer;
begin
 try
   case PropInfo^.PropType^.Kind of
    tkString,tkLString,tkWString: SetStrProp(Obj,PropInfo,temp);
    tkInteger: SetOrdProp(Obj,PropInfo,temp);
    tkFloat: SetFloatProp(Obj,PropInfo,temp);
    tkEnumeration:
    begin
     i:=GetEnumValue(PropInfo^.PropType^,temp);
     SetOrdProp(Obj,PropInfo,i);
    end;
    tkClass :
    begin
     TObj:=TObject(GetOrdProp(Obj,PropInfo));
     if Tobj is TStrings
      then TStrings(TObj).Text:=temp
      else showmessage('P4');
    end;
    else showmessage('P2 '+PropInfo^.Name);
   end;
 except
  on exception do
   showmessage('P5 '+PropInfo^.Name);
 end;
end;

Procedure THKOptions.CopyProp(Source,Dest : PPropInfo; SourceObj,DestObj : TObject);
var
 Temp : Variant;
begin
 temp:=GetProp(source,SourceObj);
 SetProp(Dest,DestObj,temp);
end;

procedure THKOptions.DoGetControl(Control: TControl);
var
 i,j:integer;
 MyPropInfo,ConPropInfo: PPropInfo;
begin
 if (not (Control is TButton)) and
    (not (control is TCustomLabel)) then
 begin
  MyPropInfo:=GetPropInfo(classinfo,control.name);
  if not assigned(MyPropInfo) then exit;
  for i:=0 to length(HotList)-1 do
  begin
   ConPropInfo:=GetPropInfo(Control.classinfo,HotList[i]);
   if not assigned(ConPropInfo) then continue;
   CopyProp(ConPropInfo,MyPropInfo,Control,self);
   if DebugMode then
   begin
    j:=optionslist.IndexOf(control.name);
    if j>=0 then optionslist.Delete(j);
   end;
   break;
  end;
 end;
end;

procedure THKOptions.DoSetControl(Control : TControl);
var
 i,j:integer;
 MyPropInfo,ConPropInfo: PPropInfo;
begin
 if (not (Control is TButton)) and
    (not (control is TCustomLabel)) then
 begin
  MyPropInfo:=GetPropInfo(classinfo,control.name);
  if not assigned(MyPropInfo) then exit;
  for i:=0 to length(HotList)-1 do
  begin
   ConPropInfo:=GetPropInfo(Control.classinfo,HotList[i]);
   if not assigned(ConPropInfo) then continue;
   CopyProp(MyPropInfo,ConPropInfo,self,Control);
   if DebugMode then
   begin
    j:=optionslist.IndexOf(control.name);
    if j>=0 then optionslist.Delete(j);
   end;
   break;
  end;
 end;
end;

procedure THKOptions.SetToForm(Form: TCustomForm);
begin
 Streaming:=true;
 try
  if debugmode then
   MakeOptionsList;
  DoWinControl(form,True);
  if (debugmode) and (OptionsList.Count>0) then
   Showmessage(OptionsList.Text);
 finally
  streaming:=false;
 end;
end;

procedure THKOptions.GetFromForm(Form: TCustomForm);
begin
 if debugmode then
  MakeOptionsList;
 DoWinControl(form,false);
 if (debugmode) and (OptionsList.Count>0) then
  Showmessage(OptionsList.Text);
end;

constructor THKOptions.Create;
var i,j:integer;
begin
 inherited Create;
 CurrentVersion:=1;
 SetLength(HotList,Length(DefHotList));
 for i:=0 to length(HotList)-1 do
  HotList[i]:=DefHotList[i];
 OptionsSection:='Options';
 SetDefaults;
 if DebugMode then
 begin
  OptionsList:=TStringList.Create;
  OptionsList.Sorted:=true;
  MakeOptionsList;
  for i:=OptionsList.Count-1 downto 0 do
  begin
   j:=integer(optionsList.Objects[i]);
   if (optionslist.IndexOfObject(TObject(j))<>i) then
    showmessage('Dup Index '+optionsList[i]);
   if (j>OptionsList.Count) then
    Showmessage('Big Index '+optionsList[i]);
   if (j<length(FVars)) and (VarIsEmpty(FVars[i]))
    then showmessage('Noinit index '+inttostr(i));
  end;
 end;
end;

destructor THKOptions.Destroy;
begin
 if debugmode then
  OptionsList.Free;
 inherited Destroy;
end;

procedure THKOptions.MakeOptionsList;
var
 proplist : PPropList;
 i,c : integer;
begin
 with optionslist do
 begin
  Clear;
  c:=GetPropList(self,PropList);
  for i:=0 to c-1 do
   AddObject(PropList^[i].Name,TObject(PropList^[i].Index));
  delete(indexof('Version'));
 end;
end;

procedure THKOptions.LoadCustomSettings(Ini: TInifile);
begin
end;

procedure THKOptions.SaveCustomSettings(Ini: TInifile);
begin
end;

procedure THKOptions.Assign(Source: TPersistent);
var
 proplist : PPropList;
 i,c : integer;
 PropInfo: PPropInfo;
begin
 if source is THKOptions then
  begin
   THKOPtions(Source).Streaming:=true;
   try
    c:=GetPropList(Source,PropList);
    for i:=0 to c-1 do
    begin
     propinfo:=GetPropInfo(self,PropList^[i].Name);
     if assigned(propInfo) then
      CopyProp(PropList^[i],PropInfo,source,self);
    end;
   finally
    THKOPtions(Source).Streaming:=false;
   end;
  end
 else
  inherited Assign(Source);
end;


end.