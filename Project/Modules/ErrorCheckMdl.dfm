object ErrorCheckMod: TErrorCheckMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 335
  Top = 232
  Height = 107
  Width = 214
  object ReqPCRE: TDIPcre
    CompileOptionBits = 4
    MatchPattern = 'require\s+([^;#]+);'
    Left = 22
    Top = 16
  end
end
