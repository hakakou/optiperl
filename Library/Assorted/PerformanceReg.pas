unit PerformanceReg;
interface

uses
  Windows, Messages, SysUtils, Classes, Registry, Designintf,DesignEditors,PerformanceBar;

type
  TPerformanceStatisticEditor = Class (TPropertyEditor)
  Public
    Function GetAttributes : TPropertyAttributes ; Override ;
    Procedure GetValues (Proc : TGetStrProc) ; Override ;
    Function GetValue : String ; Override ;
    Procedure SetValue (const Value : String) ; Override ;
  End ;

procedure Register;

implementation

Function TPerformanceStatisticEditor.GetAttributes : TPropertyAttributes ;
  Begin
  Result := [paValueList,paSortList] ;
  End ;

Procedure TPerformanceStatisticEditor.GetValues (Proc : TGetStrProc) ;
  Var
    List : TStringList ;
    Registry : TRegistry ;
    II : Integer ;
  Begin
  list := TStringList.Create ;
  registry := TRegistry.Create ;
  try
    registry.RootKey := HKEY_DYN_DATA ;
    registry.OpenKey ('PerfStats\StartStat', false) ;
    registry.GetValueNames (list) ;
    registry.CloseKey () ;
    For II := 0 To List.Count - 1 Do
      Proc (List [ii]) ;
  Finally
    List.Free ;
    Registry.Free ;
    End ;
  End ;

Function TPerformanceStatisticEditor.GetValue : String ;
  Begin
  Result := GetStrValue ;
  End ;

Procedure TPerformanceStatisticEditor.SetValue (const Value : String) ;
  Begin
  SetStrValue (Value) ;
  End ;

procedure Register;
begin
  RegisterComponents('Colosseum', [TPerformanceBar]);
  RegisterPropertyEditor (TypeInfo (String),
                          TPerformanceBar,
                          'Statistic',
                          TPerformanceStatisticEditor) ;
end;

end.
