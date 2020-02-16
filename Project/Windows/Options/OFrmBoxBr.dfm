inherited OFormBoxBr: TOFormBoxBr
  Left = 393
  Top = 267
  Caption = 'OFormBoxBr'
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BoxBrGroup: TGroupBox
    Left = 10
    Top = 7
    Width = 438
    Height = 262
    Caption = 'Bracket Boxes'
    TabOrder = 0
    object Label43: TLabel
      Left = 16
      Top = 53
      Width = 52
      Height = 13
      Caption = 'Box level &1'
      FocusControl = BoxBr1Curve
    end
    object Label44: TLabel
      Left = 165
      Top = 16
      Width = 28
      Height = 13
      Caption = 'Curve'
    end
    object Label45: TLabel
      Left = 262
      Top = 16
      Width = 23
      Height = 13
      Caption = 'Style'
    end
    object Label46: TLabel
      Left = 364
      Top = 16
      Width = 24
      Height = 13
      Caption = 'Color'
    end
    object Label47: TLabel
      Left = 103
      Top = 16
      Width = 30
      Height = 13
      Caption = 'Visible'
    end
    object Label48: TLabel
      Left = 16
      Top = 85
      Width = 52
      Height = 13
      Caption = 'Box level &2'
      FocusControl = BoxBr2Curve
    end
    object Label49: TLabel
      Left = 16
      Top = 117
      Width = 52
      Height = 13
      Caption = 'Box level &3'
      FocusControl = BoxBr3Curve
    end
    object Label50: TLabel
      Left = 16
      Top = 149
      Width = 52
      Height = 13
      Caption = 'Box level &4'
      FocusControl = BoxBr4Curve
    end
    object Label51: TLabel
      Left = 16
      Top = 181
      Width = 52
      Height = 13
      Caption = 'Box level &5'
      FocusControl = BoxBr5Curve
    end
    object Label52: TLabel
      Left = 16
      Top = 213
      Width = 52
      Height = 13
      Caption = 'Box level &6'
      FocusControl = BoxBr6Curve
    end
    object Bevel5: TBevel
      Left = 222
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Bevel6: TBevel
      Left = 147
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Bevel7: TBevel
      Left = 91
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Bevel8: TBevel
      Left = 326
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object BoxBr1Curve: TJvSpinEdit
      Left = 157
      Top = 49
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 1
    end
    object BoxBr1Visible: TCheckBox
      Left = 113
      Top = 51
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 0
    end
    object BoxBr2Visible: TCheckBox
      Left = 113
      Top = 83
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 4
    end
    object BoxBr2Curve: TJvSpinEdit
      Left = 157
      Top = 81
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 5
    end
    object BoxBr3Visible: TCheckBox
      Left = 113
      Top = 115
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 8
    end
    object BoxBr3Curve: TJvSpinEdit
      Left = 157
      Top = 113
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 9
    end
    object BoxBr4Visible: TCheckBox
      Left = 113
      Top = 147
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 12
    end
    object BoxBr4Curve: TJvSpinEdit
      Left = 157
      Top = 145
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 13
    end
    object BoxBr5Visible: TCheckBox
      Left = 113
      Top = 179
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 16
    end
    object BoxBr5Curve: TJvSpinEdit
      Left = 157
      Top = 177
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 17
    end
    object BoxBr6Visible: TCheckBox
      Left = 113
      Top = 211
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 20
    end
    object BoxBr6Curve: TJvSpinEdit
      Left = 157
      Top = 209
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 21
    end
    object BoxBr1Brush: TFillStyleComboBox
      Left = 232
      Top = 49
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 2
    end
    object BoxBr2Brush: TFillStyleComboBox
      Left = 232
      Top = 81
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 6
    end
    object BoxBr3Brush: TFillStyleComboBox
      Left = 232
      Top = 113
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 10
    end
    object BoxBr4Brush: TFillStyleComboBox
      Left = 232
      Top = 145
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 14
    end
    object BoxBr5Brush: TFillStyleComboBox
      Left = 232
      Top = 177
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 18
    end
    object BoxBr6Brush: TFillStyleComboBox
      Left = 232
      Top = 209
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 22
    end
    object BoxBr1Color: THKColorBox
      Left = 337
      Top = 49
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 3
    end
    object BoxBr2Color: THKColorBox
      Left = 337
      Top = 81
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 7
    end
    object BoxBr3Color: THKColorBox
      Left = 337
      Top = 113
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 11
    end
    object BoxBr4Color: THKColorBox
      Left = 337
      Top = 145
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 15
    end
    object BoxBr5Color: THKColorBox
      Left = 337
      Top = 177
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 19
    end
    object BoxBr6Color: THKColorBox
      Left = 337
      Top = 209
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 23
    end
  end
end
