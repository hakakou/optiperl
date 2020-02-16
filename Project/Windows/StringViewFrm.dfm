object StringViewForm: TStringViewForm
  Left = 303
  Top = 207
  Width = 329
  Height = 261
  HelpContext = 510
  BorderStyle = bsSizeToolWin
  Caption = 'StringViewForm'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox: TJvTextListBox
    Left = 0
    Top = 0
    Width = 321
    Height = 227
    Align = alClient
    ItemHeight = 13
    PopupMenu = PopupMenu
    TabOrder = 0
    OnDblClick = ListBoxDblClick
  end
  object PopupMenu: TPopupMenu
    Left = 128
    Top = 104
    object Copylinetoclipboard1: TMenuItem
      Caption = 'Copy line to clipboard'
      OnClick = Copylinetoclipboard1Click
    end
    object CopytoClipboardItem: TMenuItem
      Caption = 'Copy all lines to clipboard'
      OnClick = CopytoClipboardItemClick
    end
  end
  object LinePcre: TDIPcre
    MatchPattern = '`(.*)'#39' line (\d+)'
    Left = 200
    Top = 104
  end
end
