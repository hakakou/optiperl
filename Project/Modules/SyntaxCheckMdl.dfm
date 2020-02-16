object SyntaxCheckMod: TSyntaxCheckMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 241
  Top = 184
  Height = 340
  Width = 471
  object GUI: TGUI2Console
    AppType = at32bit
    AutoTerminate = True
    PipeSize = ps128k
    BufferSize = bs1k
    TimeOutDelay = 50
    Priority = tpNormal
    OnDone = GUIDone
    OnLine = GUILine
    OnError = GUIError
    Left = 56
    Top = 24
  end
  object HKMessageReceiver: THKMessageReceiver
    OnRequestAction = HKMessageReceiverRequestAction
    Left = 56
    Top = 96
  end
  object Timer: TTimer
    Interval = 1500
    OnTimer = TimerTimer
    Left = 56
    Top = 160
  end
end
