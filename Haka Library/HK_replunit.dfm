object HKReplDialog: THKReplDialog
  Left = 272
  Top = 218
  Anchors = [akLeft, akBottom]
  BorderStyle = bsDialog
  Caption = 'Find and Replace'
  ClientHeight = 299
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl: TTabControl
    Left = 0
    Top = 0
    Width = 421
    Height = 299
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      'Fin&d'
      'Rep&lace')
    TabIndex = 0
    OnChange = TabControlChange
    DesignSize = (
      421
      299)
    object FindBox: TGroupBox
      Left = 11
      Top = 27
      Width = 349
      Height = 88
      Caption = 'Text selection'
      TabOrder = 0
      DesignSize = (
        349
        88)
      object LTexttFind: TLabel
        Left = 10
        Top = 25
        Width = 76
        Height = 13
        AutoSize = False
        Caption = '&Text to find:'
        FocusControl = SearText
        WordWrap = True
      end
      object LReplWith: TLabel
        Left = 10
        Top = 57
        Width = 65
        Height = 13
        Caption = 'Replace &with:'
        FocusControl = ReplText
      end
      object SearText: TComboBox
        Left = 92
        Top = 21
        Width = 243
        Height = 21
        AutoComplete = False
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 0
        OnChange = SearTextChange
      end
      object ReplText: TComboBox
        Left = 92
        Top = 53
        Width = 243
        Height = 21
        AutoComplete = False
        Anchors = [akLeft, akTop, akRight]
        ItemHeight = 13
        TabOrder = 1
        OnChange = ReplTextChange
      end
    end
    object btnReplace: TButton
      Left = 100
      Top = 267
      Width = 70
      Height = 23
      Action = ReplaceAction
      Anchors = [akRight, akBottom]
      ModalResult = 1
      TabOrder = 7
    end
    object btnReplaceAll: TButton
      Left = 175
      Top = 267
      Width = 83
      Height = 23
      Action = ReplaceAllAction
      Anchors = [akRight, akBottom]
      ModalResult = 8
      TabOrder = 8
    end
    object btnClose: TButton
      Left = 339
      Top = 267
      Width = 71
      Height = 23
      Action = CloseAction
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Close'
      ModalResult = 2
      TabOrder = 10
    end
    object btnNext: TButton
      Left = 263
      Top = 267
      Width = 72
      Height = 23
      Action = FindNextAction
      Anchors = [akRight, akBottom]
      Default = True
      ModalResult = 4
      TabOrder = 9
    end
    object btnToggle: TBitBtn
      Left = 10
      Top = 267
      Width = 23
      Height = 23
      Anchors = [akLeft, akBottom]
      TabOrder = 5
      OnClick = btnToggleClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888800000000088888880888888808888888088808880888888808800088
        0888888808000008088888880880008808888888088888880888888800000000
        0888888808888888088888880880008808888888080000080888888808800088
        0888888808880888088888880888888808888888000000000888}
      Layout = blGlyphRight
    end
    object OptionsGroup: TGroupBox
      Left = 11
      Top = 118
      Width = 183
      Height = 78
      Caption = 'Options'
      TabOrder = 1
      DesignSize = (
        183
        78)
      object CaseSens: TCheckBox
        Left = 12
        Top = 16
        Width = 162
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Case &sensitive'
        TabOrder = 0
        OnClick = CaseSensClick
      end
      object WholeWord: TCheckBox
        Left = 12
        Top = 35
        Width = 162
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'W&hole words only'
        TabOrder = 1
        OnClick = WholeWordClick
      end
      object PromptRepl: TCheckBox
        Left = 12
        Top = 54
        Width = 162
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = 'Prompt on repla&ce'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
    end
    object DirectionGroup: TGroupBox
      Left = 212
      Top = 118
      Width = 194
      Height = 78
      Caption = 'Direction'
      TabOrder = 2
      DesignSize = (
        194
        78)
      object dirForward: TRadioButton
        Left = 8
        Top = 22
        Width = 163
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Forward'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object dirBackward: TRadioButton
        Left = 8
        Top = 46
        Width = 163
        Height = 17
        Anchors = [akLeft, akTop, akRight]
        Caption = '&Backward'
        TabOrder = 1
      end
    end
    object ScopeGroup: TRadioGroup
      Left = 11
      Top = 199
      Width = 183
      Height = 60
      Caption = 'Scope'
      ItemIndex = 0
      Items.Strings = (
        '&Global'
        'Selected te&xt')
      TabOrder = 3
      OnClick = ScopeGroupClick
    end
    object OriginGroup: TRadioGroup
      Left = 211
      Top = 199
      Width = 195
      Height = 60
      Caption = 'Origin'
      ItemIndex = 0
      Items.Strings = (
        'From c&ursor'
        'Entire scop&e')
      TabOrder = 4
      OnClick = OriginGroupClick
    end
    object btnHighLight: TBitBtn
      Left = 37
      Top = 267
      Width = 23
      Height = 23
      Anchors = [akLeft, akBottom]
      TabOrder = 6
      OnClick = btnHighLightClick
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7CEF3D420821040000000000000000000000000000
        000000001F7C1F7C1F7C1F7CEF3D1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C00001F7C1F7C1F7C1F7CEF3D1F7C1F7C1F7C1F7C1F7C1F7C0D000D000D00
        0D0000001F7C1F7C1F7C1F7CEF3D1F7C1F7C6F0C2D041F7C1F7C0D001F7C1F7C
        0D0021041F7C1F7C1F7C1F7CEF3D1F7C8E106F0C2D040D001F7C0D001F7C1F7C
        2D0442081F7C1F7C1F7C1F7CEF3D1F7C6F0C6F0C2D040D000D000D000D000D00
        2D0442081F7C1F7C1F7C1F7CEF3D1F7C1F7C6F0C2D001F7C1F7C1F7C0D001F7C
        1F7C21041F7C1F7C1F7C1F7C1F7CEF3D1F7C2D041F7C1F7C1F7C0D001F7C1F7C
        1F7C00001F7C1F7C1F7C1F7CEF3DEF3D1F7C1F7C0D001F7C0D001F7CAD310000
        000000001F7C1F7C1F7CEF3D630C4208AD351F7C1F7C0D001F7C1F7C8D311F7C
        00001F7C1F7C1F7C1F7C630C1F7C1F7C00008C311F7C1F7C1F7C1F7C8D310000
        1F7C1F7C1F7C1F7C1F7C630C1F7C1F7C00008D31AD31AD35AD318D318D311F7C
        1F7C1F7C1F7C1F7C630C843C210400008D311F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C630C843C42081F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C630C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      Layout = blGlyphRight
    end
  end
  object FormStorage: TJvFormStorage
    StoredProps.Strings = (
      'SearText.Items'
      'ReplText.Items'
      'ReplText.Text'
      'OriginGroup.ItemIndex')
    StoredValues = <>
    Left = 283
    Top = 11
  end
  object ActionList: TActionList
    Left = 315
    Top = 172
    object ReplaceAction: TAction
      Caption = '&Replace'
      OnExecute = ReplaceActionExecute
      OnUpdate = ReplaceActionUpdate
    end
    object ReplaceAllAction: TAction
      Caption = 'Replace &All'
      OnExecute = ReplaceAllActionExecute
      OnUpdate = ReplaceAllActionUpdate
    end
    object FindNextAction: TAction
      Caption = 'Find &Next'
      ShortCut = 114
      OnExecute = FindNextActionExecute
      OnUpdate = FindNextActionUpdate
    end
    object CloseAction: TAction
      Caption = '&Close'
      OnExecute = CloseActionExecute
    end
  end
  object PopupMenu: TPopupMenu
    Left = 128
    Top = 208
    object Position1Item: TMenuItem
      Caption = 'Highlight Position &1'
      OnClick = PositionItemClick
    end
    object Position2Item: TMenuItem
      Tag = 1
      Caption = 'Highlight Position &2'
      OnClick = PositionItemClick
    end
    object Position3item: TMenuItem
      Tag = 2
      Caption = 'Highlight Position &3'
      OnClick = PositionItemClick
    end
    object Position4item: TMenuItem
      Tag = 3
      Caption = 'Highlight Position &4'
      OnClick = PositionItemClick
    end
  end
end
