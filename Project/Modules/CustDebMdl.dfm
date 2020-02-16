object CustDebMod: TCustDebMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 351
  Top = 418
  Height = 105
  Width = 190
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 72
    Top = 16
  end
end
