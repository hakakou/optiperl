object GetHeaderForm: TGetHeaderForm
  Left = 304
  Top = 228
  BorderStyle = bsDialog
  Caption = 'Retrieving Headers'
  ClientHeight = 78
  ClientWidth = 390
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 40
    Width = 77
    Height = 13
    Caption = 'Total messages:'
  end
  object Label3: TLabel
    Left = 8
    Top = 56
    Width = 87
    Height = 13
    Caption = 'Headers retrieved:'
  end
  object lblMess: TLabel
    Left = 112
    Top = 40
    Width = 35
    Height = 13
    Caption = 'lblMess'
  end
  object lblgot: TLabel
    Left = 112
    Top = 56
    Width = 25
    Height = 13
    Caption = 'lblgot'
  end
  object Button1: TButton
    Left = 312
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ProgressBar: TProgressBar
    Left = 8
    Top = 8
    Width = 377
    Height = 25
    Min = 0
    Max = 100
    TabOrder = 1
  end
  object Timer: TTimer
    Interval = 250
    OnTimer = TimerTimer
    Left = 256
    Top = 8
  end
end
