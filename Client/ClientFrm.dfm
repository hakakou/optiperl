object ClientForm: TClientForm
  Left = 591
  Top = 297
  BorderStyle = bsDialog
  Caption = 'ClientForm'
  ClientHeight = 74
  ClientWidth = 192
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TerminateTimer: TTimer
    Interval = 3000
    OnTimer = TerminateTimerTimer
    Left = 40
    Top = 16
  end
end
