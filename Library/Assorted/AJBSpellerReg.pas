unit AJBSpellerReg;

interface

uses Classes, AJBSpeller, DesignIntf, DesignEditors, SysUtils;

type
   TLanguageProperty = class(TIntegerProperty)
   public
      function GetAttributes: TPropertyAttributes; override;
      function GetValue: string; override;
      procedure GetValues(Proc: TGetStrProc); override;
      procedure SetValue(const Value: string); override;
   end;

procedure Register;

implementation

procedure Register;
begin
   RegisterComponents('AJB', [TAJBSpell]);
   RegisterPropertyEditor(TypeInfo(TSpellLanguage), TAJBSpell, 'Language', TLanguageProperty);
end;

{ TLanguageProperty }

function TLanguageProperty.GetAttributes: TPropertyAttributes;
begin
   Result := [paMultiSelect, paValueList, paRevertable];
end;

function TLanguageProperty.GetValue: string;
var
   CurValue: Longint;
begin
   CurValue := GetOrdValue;
   case CurValue of
      Low(AJBSpellLanguage)..High(AJBSpellLanguage):
         Result := AJBSpellLanguage[CurValue].LocalName;
      else
         Result := IntToStr(CurValue);
   end;
end;

procedure TLanguageProperty.GetValues(Proc: TGetStrProc);
var
   I: Integer;
begin
   for I := Low(AJBSpellLanguage) to High(AJBSpellLanguage) do
      Proc(AJBSpellLanguage[I].LocalName);
end;

procedure TLanguageProperty.SetValue(const Value: string);
var
   I: Integer;
begin
   if Value = '' then
   begin
      SetOrdValue(0);
      Exit;
   end;
   for I := Low(AJBSpellLanguage) to High(AJBSpellLanguage) do
      if CompareText(AJBSpellLanguage[I].LocalName, Value) = 0 then
      begin
         SetOrdValue(I);
         Exit;
      end;
   inherited SetValue(Value);
end;

end.

 