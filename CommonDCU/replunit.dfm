object ReplDialog: TReplDialog
  Left = 299
  Top = 240
  ActiveControl = SearText
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Replace Text'
  ClientHeight = 269
  ClientWidth = 425
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
    Top = 13
    Width = 76
    Height = 13
    AutoSize = False
    Caption = '&Text to find:'
    FocusControl = SearText
    WordWrap = True
  end
  object LReplWith: TLabel
    Left = 8
    Top = 45
    Width = 65
    Height = 13
    Caption = '&Replace with:'
    FocusControl = ReplText
  end
  object OptionsGroup: TGroupBox
    Left = 8
    Top = 68
    Width = 201
    Height = 97
    Caption = 'Options'
    TabOrder = 2
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
      Top = 36
      Width = 130
      Height = 17
      Caption = '&Whole words only'
      TabOrder = 1
    end
    object RegExpr: TCheckBox
      Left = 16
      Top = 56
      Width = 173
      Height = 17
      Caption = 'Regular e&xpressions'
      TabOrder = 2
    end
    object PromptRepl: TCheckBox
      Left = 16
      Top = 76
      Width = 173
      Height = 17
      Caption = '&Prompt on replace'
      TabOrder = 3
      OnClick = PromptReplClick
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
  object ReplText: TComboBox
    Left = 96
    Top = 41
    Width = 321
    Height = 21
    ItemHeight = 13
    TabOrder = 1
  end
  object ScopeGroup: TRadioGroup
    Left = 8
    Top = 169
    Width = 201
    Height = 65
    Caption = 'Scope'
    Items.Strings = (
      'Global'
      'Selected text')
    TabOrder = 4
  end
  object OriginGroup: TRadioGroup
    Left = 216
    Top = 169
    Width = 201
    Height = 65
    Caption = 'Origin'
    Items.Strings = (
      'From cursor'
      'Entire scope')
    TabOrder = 5
    OnClick = OriginGroupClick
  end
  object DirectionGroup: TGroupBox
    Left = 216
    Top = 68
    Width = 201
    Height = 97
    Caption = 'Direction'
    TabOrder = 3
    object dirForward: TRadioButton
      Left = 8
      Top = 29
      Width = 185
      Height = 17
      Caption = 'Forward'
      TabOrder = 0
    end
    object dirBackward: TRadioButton
      Left = 8
      Top = 53
      Width = 185
      Height = 17
      Caption = 'Backward'
      TabOrder = 1
    end
  end
  object OKBut: TButton
    Left = 88
    Top = 240
    Width = 73
    Height = 25
    Caption = '&OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
    OnClick = OKButClick
  end
  object ReplBut: TButton
    Left = 168
    Top = 240
    Width = 89
    Height = 25
    Caption = 'Replace &All'
    ModalResult = 8
    TabOrder = 7
    OnClick = ReplButClick
  end
  object CancelBut: TButton
    Left = 264
    Top = 240
    Width = 73
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 8
  end
  object HelpBut: TButton
    Left = 344
    Top = 240
    Width = 73
    Height = 25
    Caption = '&Help'
    TabOrder = 9
  end
end
