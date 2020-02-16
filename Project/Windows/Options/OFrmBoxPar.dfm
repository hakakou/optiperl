inherited OFormBoxPar: TOFormBoxPar
  Left = 339
  Top = 305
  Caption = 'OFormBoxPar'
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object BoxParGroup: TGroupBox
    Left = 10
    Top = 7
    Width = 438
    Height = 263
    Caption = 'Parenthesis Boxes'
    TabOrder = 0
    object Label53: TLabel
      Left = 16
      Top = 53
      Width = 52
      Height = 13
      Caption = 'Box level &1'
      FocusControl = BoxPar1Curve
    end
    object Label54: TLabel
      Left = 165
      Top = 16
      Width = 28
      Height = 13
      Caption = 'Curve'
    end
    object Label55: TLabel
      Left = 262
      Top = 16
      Width = 23
      Height = 13
      Caption = 'Style'
    end
    object Label56: TLabel
      Left = 364
      Top = 16
      Width = 24
      Height = 13
      Caption = 'Color'
    end
    object Label57: TLabel
      Left = 103
      Top = 16
      Width = 30
      Height = 13
      Caption = 'Visible'
    end
    object Label58: TLabel
      Left = 16
      Top = 85
      Width = 52
      Height = 13
      Caption = 'Box level &2'
      FocusControl = BoxPar2Curve
    end
    object Label59: TLabel
      Left = 16
      Top = 117
      Width = 52
      Height = 13
      Caption = 'Box level &3'
      FocusControl = BoxPar3Curve
    end
    object Label60: TLabel
      Left = 16
      Top = 149
      Width = 52
      Height = 13
      Caption = 'Box level &4'
      FocusControl = BoxPar4Curve
    end
    object Label61: TLabel
      Left = 16
      Top = 181
      Width = 52
      Height = 13
      Caption = 'Box level &5'
      FocusControl = BoxPar5Curve
    end
    object Label62: TLabel
      Left = 16
      Top = 213
      Width = 52
      Height = 13
      Caption = 'Box level &6'
      FocusControl = BoxPar6Curve
    end
    object Bevel9: TBevel
      Left = 222
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Bevel10: TBevel
      Left = 147
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Bevel11: TBevel
      Left = 91
      Top = 12
      Width = 9
      Height = 248
      Shape = bsLeftLine
    end
    object Bevel12: TBevel
      Left = 326
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object BoxPar1Curve: TJvSpinEdit
      Left = 157
      Top = 49
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 1
    end
    object BoxPar1Visible: TCheckBox
      Left = 113
      Top = 51
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 0
    end
    object BoxPar2Visible: TCheckBox
      Left = 113
      Top = 83
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 4
    end
    object BoxPar2Curve: TJvSpinEdit
      Left = 157
      Top = 81
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 5
    end
    object BoxPar3Visible: TCheckBox
      Left = 113
      Top = 115
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 8
    end
    object BoxPar3Curve: TJvSpinEdit
      Left = 157
      Top = 113
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 9
    end
    object BoxPar4Visible: TCheckBox
      Left = 113
      Top = 147
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 12
    end
    object BoxPar4Curve: TJvSpinEdit
      Left = 157
      Top = 145
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 13
    end
    object BoxPar5Visible: TCheckBox
      Left = 113
      Top = 179
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 16
    end
    object BoxPar5Curve: TJvSpinEdit
      Left = 157
      Top = 177
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 17
    end
    object BoxPar6Visible: TCheckBox
      Left = 113
      Top = 211
      Width = 25
      Height = 17
      HelpContext = 5950
      TabOrder = 20
    end
    object BoxPar6Curve: TJvSpinEdit
      Left = 157
      Top = 209
      Width = 57
      Height = 24
      HelpContext = 5940
      MaxValue = 999.000000000000000000
      MaxLength = 3
      TabOrder = 21
    end
    object BoxPar1Brush: TFillStyleComboBox
      Left = 232
      Top = 49
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 2
    end
    object BoxPar2Brush: TFillStyleComboBox
      Left = 232
      Top = 81
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 6
    end
    object BoxPar3Brush: TFillStyleComboBox
      Left = 232
      Top = 113
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 10
    end
    object BoxPar4Brush: TFillStyleComboBox
      Left = 232
      Top = 145
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 14
    end
    object BoxPar5Brush: TFillStyleComboBox
      Left = 232
      Top = 177
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 18
    end
    object BoxPar6Brush: TFillStyleComboBox
      Left = 232
      Top = 209
      Width = 85
      Height = 24
      HelpContext = 6060
      ItemHeight = 18
      TabOrder = 22
    end
    object BoxPar1Color: THKColorBox
      Left = 337
      Top = 49
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 3
    end
    object BoxPar2Color: THKColorBox
      Left = 337
      Top = 81
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 7
    end
    object BoxPar3Color: THKColorBox
      Left = 337
      Top = 113
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 11
    end
    object BoxPar4Color: THKColorBox
      Left = 337
      Top = 145
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 15
    end
    object BoxPar5Color: THKColorBox
      Left = 337
      Top = 177
      Width = 90
      Height = 24
      HelpContext = 6120
      ItemHeight = 18
      TabOrder = 19
    end
    object BoxPar6Color: THKColorBox
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
