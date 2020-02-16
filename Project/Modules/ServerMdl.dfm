object ServerMod: TServerMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 512
  Top = 285
  Height = 292
  Width = 249
  object ReqPcre: TDIPcre
    MatchPattern = '(POST|HEAD|GET) (\S+) (\S+)'
    Left = 104
    Top = 72
  end
  object HeadPcre: TDIPcre
    Left = 104
    Top = 136
  end
  object GUI: TGUI2Console
    AppType = at32bit
    AutoTerminate = False
    PipeSize = ps128k
    BufferSize = bs1k
    TimeOutDelay = 50
    Priority = tpNormal
    SendNillLines = True
    OnStart = GUIStart
    OnDone = GUIDone
    OnLine = GUILine
    OnError = GUIError
    OnTimeOut = GUITimeOut
    OnPreTerminate = GUIPreTerminate
    Left = 40
    Top = 16
  end
  object FindFile: TFindFile
    Filename = '*.*'
    Subfolders = False
    OnFound = FindFileFound
    Left = 128
    Top = 24
  end
  object VarPcre: TDIPcre
    MatchPattern = '<!--#echo var="([^"\s]+)" -->'
    Left = 184
    Top = 136
  end
  object SsiPCRE: TDIPcre
    MatchPattern = '<!--#exec cgi="([^"\s]+)" -->'
    Left = 184
    Top = 200
  end
  object ResPCRE: TDIPcre
    MatchPattern = '^Status:\s+(\w+)\s*(.*)$'
    Left = 184
    Top = 72
  end
  object GHeadPcre: TDIPcre
    MatchPattern = '^(\S+):\s+(.*)$'
    Left = 104
    Top = 200
  end
  object CTPcre: TDIPcre
    MatchPattern = '^content-type:\s+\S+'
    Left = 32
    Top = 72
  end
end
