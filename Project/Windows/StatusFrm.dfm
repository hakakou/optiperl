object StatusForm: TStatusForm
  Tag = 2
  Left = 260
  Top = 206
  Width = 439
  Height = 107
  HelpContext = 260
  BorderStyle = bsSizeToolWin
  Caption = 'Error Status'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBox: TJvTextListBox
    Left = 0
    Top = 0
    Width = 431
    Height = 73
    HelpContext = 260
    Align = alClient
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnDblClick = StatusBoxDblClick
    OnMouseMove = StatusBoxMouseMove
  end
  object ApplicationEvents: TApplicationEvents
    OnShowHint = ApplicationEventsShowHint
    Left = 80
    Top = 16
  end
end
