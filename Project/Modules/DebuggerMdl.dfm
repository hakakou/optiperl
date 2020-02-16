inherited LDebMod: TLDebMod
  OldCreateOrder = True
  Height = 114
  Width = 164
  inherited Timer: TTimer
    Left = 88
  end
  object GUI: TGUI2Console
    AppType = at32bit
    AutoTerminate = False
    PipeSize = ps128k
    BufferSize = bs1k
    TimeOutDelay = 10
    Priority = tpNormal
    SendNillLines = False
    OnStart = GUIStart
    OnDone = GUIDone
    OnLine = GUILine
    OnError = GUIError
    OnTimeOut = GUITimeOut
    OnPrompt = GUIPrompt
    OnPreTerminate = GUIPreTerminate
    Left = 24
    Top = 16
  end
end
