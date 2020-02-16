object CodeComplete: TCodeComplete
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  Left = 511
  Top = 437
  Height = 174
  Width = 483
  object ModPcre: TDIPcre
    MatchPattern = '^\s*use\s+([\w\:]+)'
    Left = 128
    Top = 72
  end
  object GUI: TGUI2Console
    AppType = at32bit
    Prompt = '> '
    AutoTerminate = False
    PipeSize = ps128k
    BufferSize = bs1k
    TimeOutDelay = 50
    Priority = tpTimeCritical
    SendNillLines = False
    OnDone = GUIDone
    OnLine = GUILine
    OnPrompt = GUIPrompt
    Left = 264
    Top = 80
  end
  object FindPcre: TDIPcre
    Left = 88
    Top = 8
  end
  object ExpPcre: TDIPcre
    MatchPattern = '\s\s\s\d+\s+'#39'([^:]\w+)'#39
    Left = 128
    Top = 24
  end
  object ScalPcre: TDIPcre
    MatchPattern = '(\$[\w\:]+)(->|'#39')'
    Left = 424
    Top = 24
  end
  object Find2Pcre: TDIPcre
    Left = 24
    Top = 72
  end
  object PakPcre: TDIPcre
    MatchPattern = '(\w+)$'
    Left = 208
    Top = 16
  end
  object ModQWPcre: TDIPcre
    MatchPattern = '^\s*use\s+([\w\:]+)\s+qw\(([\w ]+)\)'
    Left = 200
    Top = 72
  end
  object Find3Pcre: TDIPcre
    Left = 16
    Top = 16
  end
  object SimpPcre: TDIPcre
    MatchPattern = '((?:[\&\$\%\@]|)[\w\:]+)::'
    Left = 424
    Top = 88
  end
  object SimpDPcre: TDIPcre
    MatchPattern = '^([\&\$\%\@]\w+) ='
    Left = 264
    Top = 16
  end
  object SModPcre: TDIPcre
    MatchPattern = '\s*(?:use|require)\s+(?:'#39'|"|)[\w:]+[^;]*;'
    Left = 80
    Top = 72
  end
end
