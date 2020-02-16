object HexEditConvForm: THexEditConvForm
  Left = 385
  Top = 342
  BorderStyle = bsDialog
  Caption = 'Convert'
  ClientHeight = 146
  ClientWidth = 272
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 6
    Width = 26
    Height = 13
    Caption = 'From:'
  end
  object Label2: TLabel
    Left = 141
    Top = 6
    Width = 16
    Height = 13
    Caption = 'To:'
  end
  object ListBox1: TListBox
    Left = 9
    Top = 22
    Width = 121
    Height = 85
    ItemHeight = 13
    Items.Strings = (
      'ANSI'
      'OEM Codepage 850'
      'ASCII 7 Bit'
      'MAC'
      'EBCDIC CP 038')
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object ListBox2: TListBox
    Left = 141
    Top = 22
    Width = 121
    Height = 85
    ItemHeight = 13
    Items.Strings = (
      'ANSI'
      'OEM Codepage 850'
      'ASCII 7 Bit'
      'MAC'
      'EBCDIC CP 038')
    TabOrder = 1
    OnClick = ListBox1Click
  end
  object Button1: TButton
    Left = 59
    Top = 115
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 139
    Top = 115
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
