object FTPMod: TFTPMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 841
  Top = 435
  Height = 318
  Width = 195
  object TransTable: TkbmMemTable
    Active = True
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'Session'
        Attributes = [faRequired]
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Type'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'Server'
        Attributes = [faRequired]
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Port'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'Username'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Password'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Account'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'Passive'
        Attributes = [faRequired]
        DataType = ftBoolean
      end
      item
        Name = 'DocRoot'
        DataType = ftString
        Size = 512
      end
      item
        Name = 'LinksTo'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'Aliases'
        DataType = ftString
        Size = 2048
      end
      item
        Name = 'ProxyServer'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ProxyPort'
        Attributes = [faRequired]
        DataType = ftInteger
      end
      item
        Name = 'ProxyType'
        DataType = ftString
        Size = 11
      end
      item
        Name = 'ProxyUsername'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'ProxyPassword'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'LastFolder'
        DataType = ftString
        Size = 512
      end
      item
        Name = 'VersionConvert'
        Attributes = [faRequired]
        DataType = ftBoolean
      end
      item
        Name = 'SheBang'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'ChangeShebang'
        Attributes = [faRequired]
        DataType = ftBoolean
      end
      item
        Name = 'Notes'
        DataType = ftMemo
      end
      item
        Name = 'SavePassword'
        Attributes = [faRequired]
        DataType = ftBoolean
      end
      item
        Name = 'Favorites'
        DataType = ftMemo
      end>
    IndexFieldNames = 'Session'
    IndexName = 'Index'
    IndexDefs = <
      item
        Name = 'Index'
        Fields = 'Session'
        Options = [ixPrimary, ixUnique]
      end>
    SortOptions = []
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    FilterOptions = []
    Version = '4.08b'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    BeforeInsert = TransTableBeforeEdit
    BeforeEdit = TransTableBeforeEdit
    AfterPost = TransTableAfterUpdate
    AfterCancel = TransTableAfterUpdate
    AfterDelete = TransTableAfterUpdate
    Left = 40
    Top = 24
    object TransTableSession: TStringField
      FieldName = 'Session'
      Required = True
      Size = 100
    end
    object TransTableType: TStringField
      DefaultExpression = 'FTP'
      FieldName = 'Type'
    end
    object TransTableServer: TStringField
      FieldName = 'Server'
      Required = True
      Size = 100
    end
    object TransTablePort: TIntegerField
      AutoGenerateValue = arDefault
      DefaultExpression = '21'
      DisplayWidth = 5
      FieldName = 'Port'
      Required = True
    end
    object TransTableUsername: TStringField
      DisplayWidth = 100
      FieldName = 'Username'
      Size = 100
    end
    object TransTablePassword: TStringField
      DisplayWidth = 100
      FieldName = 'Password'
      Size = 100
    end
    object TransTableAccount: TStringField
      FieldName = 'Account'
      Size = 100
    end
    object TransTablePassive: TBooleanField
      DefaultExpression = 'False'
      FieldName = 'Passive'
      Required = True
    end
    object TransTableDocRoot: TStringField
      FieldName = 'DocRoot'
      Size = 512
    end
    object TransTableLinksTo: TStringField
      FieldName = 'LinksTo'
      Size = 200
    end
    object TransTableAliases: TStringField
      FieldName = 'Aliases'
      Size = 2048
    end
    object TransTableProxyServer: TStringField
      DisplayLabel = 'Proxy Server'
      FieldName = 'ProxyServer'
      Size = 100
    end
    object TransTableProxyPort: TIntegerField
      DefaultExpression = '21'
      DisplayLabel = 'Proxy Port'
      FieldName = 'ProxyPort'
      Required = True
    end
    object TransTableProxyType: TStringField
      DefaultExpression = '(None)'
      DisplayWidth = 11
      FieldName = 'ProxyType'
      Size = 11
    end
    object TransTableProxyUsername: TStringField
      DisplayLabel = 'Proxy Username'
      FieldName = 'ProxyUsername'
      Size = 100
    end
    object TransTableProxyPassword: TStringField
      DisplayLabel = 'Proxy Password'
      FieldName = 'ProxyPassword'
      Size = 100
    end
    object TransTableLastFolder: TStringField
      FieldName = 'LastFolder'
      Size = 512
    end
    object TransTableVersionConvert: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'VersionConvert'
      Required = True
      OnChange = TransSpecialChange
    end
    object TransTableShebang: TStringField
      DefaultExpression = '#!/bin/perl'
      DisplayLabel = 'SheBang Line'
      DisplayWidth = 25
      FieldName = 'SheBang'
      OnChange = TransSpecialChange
      Size = 200
    end
    object TransTableChangeShebang: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'ChangeShebang'
      Required = True
      OnChange = TransSpecialChange
    end
    object TransTableNotes: TMemoField
      FieldName = 'Notes'
      BlobType = ftMemo
    end
    object TransTableSavePassword: TBooleanField
      DefaultExpression = 'True'
      FieldName = 'SavePassword'
      Required = True
    end
    object TransTableFavorites: TMemoField
      FieldName = 'Favorites'
      BlobType = ftMemo
    end
  end
  object TransSource: TDataSource
    DataSet = TransTable
    Left = 120
    Top = 24
  end
  object AntiFreeze: TIdAntiFreeze
    Left = 40
    Top = 144
  end
  object SysImages: TImageList
    Left = 120
    Top = 144
  end
  object CSV: THKCSVParser
    QuoteChar = '"'
    Delimiter = ','
    OnSetData = CSVSetData
    OnReadNewLine = CSVReadNewLine
    Left = 42
    Top = 88
  end
  object ModePcre: TDIPcre
    MatchPattern = '^\s*([^;\[]\S+?)\s*=\s*(\w*?)\s*,\s*(text|binary|)\s*$'
    Left = 40
    Top = 216
  end
end
