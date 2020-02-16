inherited RDebMod: TRDebMod
  OldCreateOrder = True
  Left = 523
  Top = 580
  Height = 177
  Width = 413
  inherited Timer: TTimer
    Left = 88
  end
  object Server: TServerSocket
    Active = False
    Port = 9010
    ServerType = stNonBlocking
    OnAccept = ServerAccept
    OnClientConnect = ServerClientConnect
    OnClientDisconnect = ServerClientDisconnect
    OnClientRead = ServerClientRead
    OnClientError = ServerClientError
    Left = 332
    Top = 24
  end
  object Pcre: TDIPcre
    MatchPattern = '\(([^()\n\r\t\f]+):(\d+)\):'
    Left = 264
    Top = 16
  end
  object LinePcre: TDIPcre
    MatchPattern = '^(\d+)(:| |==>|==>\w)\t(.*)$'
    Left = 152
    Top = 16
  end
  object Pcre2: TDIPcre
    MatchPattern = '\[([^\n\r\t\f]+):(\d+)\]'
    Left = 24
    Top = 16
  end
  object GLpcre: TDIPcre
    MatchPattern = '(\w+)(:| |==>|\):)\t(.+)$'
    Left = 208
    Top = 16
  end
  object Pcre3: TDIPcre
    MatchPattern = '\[([^\n\r\t\f]+):(\d+)\]:(\d+)\):'
    Left = 232
    Top = 80
  end
  object EvalTimer: TTimer
    Enabled = False
    Interval = 250
    OnTimer = EvalTimerTimer
    Left = 48
    Top = 80
  end
  object LineEndPcre: TDIPcre
    MatchPattern = '(\d+) \t(.*?)$'
    Left = 112
    Top = 88
  end
  object PodPcre: TDIPcre
    MatchPattern = '^=\w+'
    Left = 168
    Top = 88
  end
  object Output: TServerSocket
    Active = False
    Port = 9020
    ServerType = stNonBlocking
    OnClientConnect = OutputClientConnect
    OnClientDisconnect = OutputClientDisconnect
    OnClientRead = OutputClientRead
    OnClientError = OutputClientError
    Left = 332
    Top = 88
  end
end
