object IPLookup: TIPLookup
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 227
  Top = 181
  Height = 480
  Width = 696
  object HTTP: TNMHTTP
    Port = 0
    ReportLevel = 0
    Body = 'Default.htm'
    Header = 'Head.txt'
    InputFileMode = False
    OutputFileMode = False
    ProxyPort = 0
    Left = 120
    Top = 64
  end
  object NNPcre: TDIPcre
    Pattern = 'Netname(:| )\s*([^\x0A\x0D]+)\s*'
    Left = 128
    Top = 184
  end
  object NBPcre: TDIPcre
    Pattern = '(inetnum|Netblock)\s*(:| )\s*([\d\.]+)\s*-\s*([\d\.]+)\s*'
    Left = 48
    Top = 184
  end
  object CountryPcre: TDIPcre
    Pattern = 'country(:| )\s*([^\x0A\x0D]+)\s*'
    Left = 224
    Top = 192
  end
  object StrPcre: TDIPcre
    Pattern = '<pre>\x0A([^<\x0A\x0D]+) \(<A HREF="'
    Left = 56
    Top = 256
  end
  object JapPcre: TDIPcre
    Pattern = '(\S+)\s+\[([\d\.]+)\s*<->\s*([\d\.]+)\]'
    Left = 136
    Top = 296
  end
  object JapIPPcre: TDIPcre
    Pattern = '\[Network Number\]\s+([\d\.]+)\s*-\s*([\d\.]+)'
    Left = 232
    Top = 296
  end
  object JapNamePcre: TDIPcre
    Pattern = '\[Network Name\]\s+([^\x0A\x0D]+)'
    Left = 304
    Top = 296
  end
end
