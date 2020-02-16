object ModeSelectForm: TModeSelectForm
  Left = 311
  Top = 230
  BorderStyle = bsDialog
  Caption = 'Mode Selection'
  ClientHeight = 177
  ClientWidth = 197
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel5: TBevel
    Left = 56
    Top = 22
    Width = 128
    Height = 79
  end
  object Label1: TLabel
    Left = 8
    Top = 30
    Width = 29
    Height = 13
    Caption = 'Read:'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 28
    Height = 13
    Caption = 'Write:'
  end
  object Label3: TLabel
    Left = 8
    Top = 82
    Width = 42
    Height = 13
    Caption = 'Execute:'
  end
  object Label4: TLabel
    Left = 8
    Top = 115
    Width = 38
    Height = 13
    Caption = '&Manual:'
    FocusControl = edManual
  end
  object Label5: TLabel
    Left = 61
    Top = 6
    Width = 31
    Height = 13
    Caption = 'Owner'
  end
  object Label6: TLabel
    Left = 105
    Top = 6
    Width = 29
    Height = 13
    Caption = 'Group'
  end
  object Label7: TLabel
    Left = 148
    Top = 6
    Width = 28
    Height = 13
    Caption = 'World'
  end
  object Bevel1: TBevel
    Left = 98
    Top = 23
    Width = 9
    Height = 77
    Shape = bsLeftLine
  end
  object Bevel2: TBevel
    Left = 141
    Top = 23
    Width = 9
    Height = 77
    Shape = bsLeftLine
  end
  object Bevel3: TBevel
    Left = 57
    Top = 48
    Width = 125
    Height = 9
    Shape = bsTopLine
  end
  object Bevel4: TBevel
    Left = 57
    Top = 75
    Width = 125
    Height = 9
    Shape = bsTopLine
  end
  object btnOK: TButton
    Left = 32
    Top = 148
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 10
  end
  object btnCancel: TButton
    Left = 113
    Top = 148
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 11
  end
  object CheckBox1: TCheckBox
    Tag = 4
    Left = 70
    Top = 28
    Width = 26
    Height = 17
    Hint = '3'
    HelpContext = 1
    TabOrder = 0
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Tag = 2
    Left = 70
    Top = 54
    Width = 26
    Height = 17
    Hint = '3'
    HelpContext = 1
    TabOrder = 1
    OnClick = CheckBox1Click
  end
  object CheckBox3: TCheckBox
    Tag = 1
    Left = 70
    Top = 80
    Width = 26
    Height = 17
    Hint = '3'
    HelpContext = 1
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object CheckBox4: TCheckBox
    Tag = 4
    Left = 113
    Top = 28
    Width = 26
    Height = 17
    Hint = '2'
    HelpContext = 2
    TabOrder = 3
    OnClick = CheckBox1Click
  end
  object CheckBox5: TCheckBox
    Tag = 2
    Left = 113
    Top = 54
    Width = 26
    Height = 17
    Hint = '2'
    HelpContext = 2
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object CheckBox6: TCheckBox
    Tag = 1
    Left = 113
    Top = 80
    Width = 26
    Height = 17
    Hint = '2'
    HelpContext = 2
    TabOrder = 5
    OnClick = CheckBox1Click
  end
  object CheckBox7: TCheckBox
    Tag = 4
    Left = 156
    Top = 27
    Width = 25
    Height = 21
    Hint = '1'
    HelpContext = 3
    TabOrder = 6
    OnClick = CheckBox1Click
  end
  object CheckBox8: TCheckBox
    Tag = 2
    Left = 156
    Top = 54
    Width = 26
    Height = 17
    Hint = '1'
    HelpContext = 3
    TabOrder = 7
    OnClick = CheckBox1Click
  end
  object CheckBox9: TCheckBox
    Tag = 1
    Left = 156
    Top = 80
    Width = 26
    Height = 17
    Hint = '1'
    HelpContext = 3
    TabOrder = 8
    OnClick = CheckBox1Click
  end
  object edManual: TEdit
    Left = 57
    Top = 111
    Width = 40
    Height = 21
    MaxLength = 3
    TabOrder = 9
    Text = '644'
    OnChange = edManualChange
  end
end
