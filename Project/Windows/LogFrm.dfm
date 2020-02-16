object LogForm: TLogForm
  Left = 343
  Top = 208
  Width = 266
  Height = 145
  HelpContext = 620
  BorderStyle = bsSizeToolWin
  Caption = 'LogForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox: TJvTextListBox
    Left = 0
    Top = 0
    Width = 258
    Height = 111
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
    OnDblClick = ListBoxDblClick
  end
  object Timer: TTimer
    Tag = 10
    OnTimer = TimerTimer
    Left = 112
    Top = 16
  end
  object FPcre: TDIPcre
    CompileOptionBits = 4
    MatchPattern = 'at (.+) line (\d+)'
    Left = 168
    Top = 17
  end
end
