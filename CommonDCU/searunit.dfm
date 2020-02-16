object SrchDialog: TSrchDialog
  Left = 339
  Top = 268
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Find Text'
  ClientHeight = 232
  ClientWidth = 424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object LTexttFind: TLabel
    Left = 8
    Top = 12
    Width = 81
    Height = 13
    AutoSize = False
    Caption = '&Text to find:'
    FocusControl = SearText
    WordWrap = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 191
    Width = 424
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object OKBut: TButton
      Left = 184
      Top = 12
      Width = 73
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = OKButClick
    end
    object CancelBut: TButton
      Left = 264
      Top = 12
      Width = 73
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object HelpBut: TButton
      Left = 344
      Top = 12
      Width = 73
      Height = 25
      Caption = 'Help'
      TabOrder = 2
    end
  end
  object OptionsGroup: TGroupBox
    Left = 8
    Top = 36
    Width = 201
    Height = 89
    Caption = 'Options'
    TabOrder = 1
    object CaseSens: TCheckBox
      Left = 16
      Top = 16
      Width = 130
      Height = 17
      Caption = '&Case sensitive'
      TabOrder = 0
    end
    object WholeWord: TCheckBox
      Left = 16
      Top = 40
      Width = 173
      Height = 17
      Caption = '&Whole words only'
      TabOrder = 1
    end
    object RegExpr: TCheckBox
      Left = 16
      Top = 64
      Width = 173
      Height = 17
      Caption = '&Regular expressions'
      TabOrder = 2
    end
  end
  object SearText: TComboBox
    Left = 96
    Top = 9
    Width = 321
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object ScopeGroup: TRadioGroup
    Left = 8
    Top = 132
    Width = 201
    Height = 65
    Caption = 'Scope'
    Items.Strings = (
      'Global'
      'Selected text')
    TabOrder = 3
  end
  object OriginGroup: TRadioGroup
    Left = 216
    Top = 132
    Width = 201
    Height = 65
    Caption = 'Origin'
    Items.Strings = (
      'From cursor'
      'Entire scope')
    TabOrder = 4
  end
  object DirectionGroup: TGroupBox
    Left = 216
    Top = 36
    Width = 201
    Height = 89
    Caption = 'Direction'
    TabOrder = 2
    object dirForward: TRadioButton
      Left = 8
      Top = 25
      Width = 185
      Height = 17
      Caption = 'Forward'
      TabOrder = 0
    end
    object dirBackward: TRadioButton
      Left = 8
      Top = 49
      Width = 185
      Height = 17
      Caption = 'Backward'
      TabOrder = 1
    end
  end
end
