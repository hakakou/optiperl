{*******************************************************}
{                                                       }
{       Alex Ghost Library                              }
{                                                       }
{       Copyright (c) 1999,2000 Alexey Popov            }
{                                                       }
{*******************************************************}

{$I AG.INC}

unit agPropUtils;

interface

uses Classes, Graphics,variants;

function GetStrProperty(Obj: TObject; const PropName: string): string;
function GetIntProperty(Obj: TObject; const PropName: string): longint;
function GetFloatProperty(Obj: TObject; const PropName: string): extended;
function GetBoolProperty(Obj: TObject; const PropName: string): boolean;
function GetClassProperty(Obj: TObject; const PropName: string): pointer;
function GetProperty(Obj: TObject; const PropName: string): Variant;

procedure SetStrProperty(Obj: TObject; const PropName, Value: string);
procedure SetIntProperty(Obj: TObject; const PropName: string; Value: longint);
procedure SetFloatProperty(Obj: TObject; const PropName: string; Value: extended);
procedure SetBoolProperty(Obj: TObject; const PropName: string; Value: boolean);
procedure SetClassProperty(Obj: TObject; const PropName: string; Value: pointer);
procedure SetProperty(Obj: TObject; const PropName: string; const Value: Variant);

function PropExists(Obj: TObject; const PropName: string): boolean;
procedure AssignProperty(Obj: TObject; const PropName: string; Value: TPersistent);

procedure SetGroupProperty(Objects: array of TObject; const PropName: string;
  const Value: Variant);
procedure AssignGroupProperty(Objects: array of TObject; const PropName: string;
  Value: TPersistent);
  
procedure SetGroupEnable(Objects: array of TObject; Value: Boolean);
procedure SetGroupVisible(Objects: array of TObject; Value: Boolean);
procedure SetGroupColor(Objects: array of TObject; Value: TColor);
procedure SetGroupFont(Objects: array of TObject; Value: TFont);


implementation

uses TypInfo;

const
  CBooleanPropType = 'Boolean';

var
  BooleanIdents: array [Boolean] of string = ('False', 'True');

function PropExists(Obj: TObject; const PropName: string): boolean;
begin
  Result:=Assigned(GetPropInfo(Obj.ClassInfo,PropName));
end;

function GetStrProperty(Obj: TObject; const PropName: string): string;
var
  PropInfo: PPropInfo;
begin
  Result:='';
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind in [tkString,tkLString,tkWString] then
      Result:=GetStrProp(Obj,PropInfo);
end;

function GetIntProperty(Obj: TObject; const PropName: string): longint;
var
  PropInfo: PPropInfo;
begin
  Result:=0;
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind = tkInteger then
      Result:=GetOrdProp(Obj,PropInfo);
end;

function GetFloatProperty(Obj: TObject; const PropName: string): extended;
var
  PropInfo: PPropInfo;
begin
  Result:=0;
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind = tkFloat then
      Result:=GetFloatProp(Obj,PropInfo);
end;

function GetBoolProperty(Obj: TObject; const PropName: string): boolean;
var
  PropInfo: PPropInfo;
  PropType: PTypeInfo;
begin
  Result:=false;
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then begin
    PropType:=PropInfo^.PropType^;
    if (PropType^.Kind = tkEnumeration) and (PropType^.Name = CBooleanPropType) then
      Result:=(GetEnumName(PropType,GetOrdProp(Obj,PropInfo))=BooleanIdents[true]);
  end;
end;

function GetClassProperty(Obj: TObject; const PropName: string): pointer;
var
  PropInfo: PPropInfo;
begin
  Result:=nil;
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind = tkClass then
      Result:=pointer(GetOrdProp(Obj,PropInfo));
end;

procedure SetStrProperty(Obj: TObject; const PropName, Value: string);
var
  PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind in [tkString,tkLString,tkWString] then
      SetStrProp(Obj,PropInfo,Value);
end;

procedure SetIntProperty(Obj: TObject; const PropName: string; Value: longint);
var
  PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind = tkInteger then
      SetOrdProp(Obj,PropInfo,Value);
end;

procedure SetFloatProperty(Obj: TObject; const PropName: string; Value: extended);
var
  PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind = tkFloat then
      SetFloatProp(Obj,PropInfo,Value);
end;

procedure SetBoolProperty(Obj: TObject; const PropName: string; Value: boolean);
var
  PropInfo: PPropInfo;
  PropType: PTypeInfo;
begin
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then begin
    PropType:=PropInfo^.PropType^;
    if (PropType^.Kind = tkEnumeration) and (PropType^.Name = CBooleanPropType) then
      SetOrdProp(Obj,PropInfo,GetEnumValue(PropType,BooleanIdents[Value]));
  end;
end;

procedure SetClassProperty(Obj: TObject; const PropName: string; Value: pointer);
var
  PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind = tkClass then
      SetOrdProp(Obj,PropInfo,integer(Value));
end;

function GetProperty(Obj: TObject; const PropName: string): Variant;
var
  PropInfo: PPropInfo;
  PropType: PTypeInfo;
begin
  VarClear(Result);
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then begin
    PropType:=PropInfo^.PropType^;
    case PropType^.Kind of
      tkString,tkLString,tkWString:
        Result:=GetStrProp(Obj,PropInfo);
      tkInteger:
        Result:=GetOrdProp(Obj,PropInfo);
      tkFloat:
        Result:=GetFloatProp(Obj,PropInfo);
      tkEnumeration:
        if PropType^.Name = CBooleanPropType then Result:=GetBoolProperty(Obj,PropName);
    end;
  end;
end;

procedure SetProperty(Obj: TObject; const PropName: string; const Value: Variant);
begin
  case (VarType(Value) and varTypeMask) of
    varSmallint,varInteger,varByte:
      SetIntProperty(Obj,PropName,Value);
    varOleStr,varString:
      SetStrProperty(Obj,PropName,Value);
    varSingle,varDouble:
      SetFloatProperty(Obj,PropName,Value);
    varBoolean:
      SetBoolProperty(Obj,PropName,Value);
  end;
end;

procedure AssignProperty(Obj: TObject; const PropName: string; Value: TPersistent);
var
  PropInfo: PPropInfo;
begin
  PropInfo:=GetPropInfo(Obj.ClassInfo,PropName);
  if Assigned(PropInfo) then
    if PropInfo^.PropType^.Kind = tkClass then
      TPersistent(GetOrdProp(Obj,PropInfo)).Assign(Value);
end;

procedure SetGroupProperty(Objects: array of TObject; const PropName: string;
  const Value: Variant);
var
  i: integer;
begin
  for i := 0 to High(Objects) do
    SetProperty(Objects[i],PropName,Value);
end;

procedure AssignGroupProperty(Objects: array of TObject; const PropName: string;
  Value: TPersistent);
var
  i: integer;
begin
  for i := 0 to High(Objects) do
    AssignProperty(Objects[i],PropName,Value);
end;

procedure SetGroupEnable(Objects: array of TObject; Value: Boolean);
begin
  SetGroupProperty(Objects,'Enabled',Value);
end;

procedure SetGroupVisible(Objects: array of TObject; Value: Boolean);
begin
  SetGroupProperty(Objects,'Visible',Value);
end;

procedure SetGroupColor(Objects: array of TObject; Value: TColor);
begin
  SetGroupProperty(Objects,'Color',Value);
end;

procedure SetGroupFont(Objects: array of TObject; Value: TFont);
begin
  AssignGroupProperty(Objects,'Font',Value);
end;

end.
