object ComboInputForm: TComboInputForm
  Left = 252
  Top = 218
  HelpContext = 110
  BorderStyle = bsDialog
  ClientHeight = 97
  ClientWidth = 316
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblStatus: TLabel
    Left = 14
    Top = 67
    Width = 6
    Height = 13
    Caption = '1'
  end
  object lblText: TLabel
    Left = 14
    Top = 8
    Width = 6
    Height = 13
    Caption = '1'
    FocusControl = edInput
  end
  object Button1: TButton
    Left = 144
    Top = 61
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 228
    Top = 61
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = Button2Click
  end
  object edInput: TComboBox
    Left = 14
    Top = 26
    Width = 290
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object FormStorage: TJvFormStorage
    Options = []
    StoredProps.Strings = (
      'edInput.Items')
    StoredValues = <>
    Left = 96
    Top = 8
  end
end
