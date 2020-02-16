object ShortcutForm: TShortcutForm
  Left = 369
  Top = 202
  BorderStyle = bsDialog
  Caption = 'Edit Shortcuts'
  ClientHeight = 365
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 260
    Top = 332
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 340
    Top = 332
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object GroupBox2: TGroupBox
    Left = 10
    Top = 7
    Width = 406
    Height = 315
    Caption = 'Shortcuts'
    TabOrder = 0
    object btnSet: TSpeedButton
      Left = 355
      Top = 228
      Width = 37
      Height = 21
      Hint = 'Sets shortcut to selected item'
      Caption = '&Set'
      Flat = True
      OnClick = btnSetClick
    end
    object btnClear: TSpeedButton
      Left = 318
      Top = 228
      Width = 37
      Height = 21
      Hint = 'Clears shortcut'
      Caption = 'Cl&ear'
      Flat = True
      OnClick = btnClearClick
    end
    object Label1: TLabel
      Left = 14
      Top = 254
      Width = 53
      Height = 13
      Caption = 'Description'
    end
    object Bevel1: TBevel
      Left = 75
      Top = 261
      Width = 316
      Height = 9
      Shape = bsTopLine
    end
    object Label2: TLabel
      Left = 14
      Top = 19
      Width = 53
      Height = 13
      Caption = 'Ca&tegories:'
      FocusControl = CatBox
    end
    object Label3: TLabel
      Left = 174
      Top = 19
      Width = 55
      Height = 13
      Caption = 'C&ommands:'
      FocusControl = ItemBox
    end
    object lblDesc: TLabel
      Left = 14
      Top = 269
      Width = 378
      Height = 39
      AutoSize = False
      Caption = 'lblDesc'
      ShowAccelChar = False
      WordWrap = True
    end
    object ItemBox: TListBox
      Left = 174
      Top = 35
      Width = 218
      Height = 183
      Style = lbOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 1
      OnClick = ItemBoxClick
      OnDrawItem = ItemBoxDrawItem
    end
    object HotKey: THotKey
      Left = 174
      Top = 228
      Width = 142
      Height = 21
      Hint = 'Enter key combination for shortcut.'
      Enabled = False
      HotKey = 32833
      InvalidKeys = []
      TabOrder = 2
    end
    object CatBox: TListBox
      Left = 14
      Top = 35
      Width = 149
      Height = 215
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnClick = CatBoxClick
    end
  end
  object btnDefault: TButton
    Left = 10
    Top = 332
    Width = 75
    Height = 25
    Hint = 'Reset to a default set of keys'
    Caption = '&Default'
    TabOrder = 1
    OnClick = btnDefaultClick
  end
end
