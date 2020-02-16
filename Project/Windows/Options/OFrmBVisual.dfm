inherited OFormVisual: TOFormVisual
  Left = 378
  Top = 287
  Caption = 'OFormVisual'
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object EditMarginGroup: TGroupBox
    Left = 10
    Top = 7
    Width = 215
    Height = 149
    HelpContext = 5080
    Caption = 'E&ditor margin'
    TabOrder = 0
    object ColorLbl: TLabel
      Left = 10
      Top = 46
      Width = 27
      Height = 13
      Caption = '&Color:'
      FocusControl = MarginColor
    end
    object StyleMarginLbl: TLabel
      Left = 10
      Top = 71
      Width = 26
      Height = 13
      Caption = '&Style:'
      FocusControl = MarginStyle
    end
    object WitdhMarginLbl: TLabel
      Left = 96
      Top = 21
      Width = 31
      Height = 13
      Caption = '&Width:'
      FocusControl = MarginWidth
    end
    object PositionLbl: TLabel
      Left = 10
      Top = 98
      Width = 40
      Height = 13
      Caption = '&Position:'
      FocusControl = MarginPos
    end
    object MarginVisible: TCheckBox
      Left = 10
      Top = 17
      Width = 77
      Height = 21
      HelpContext = 5080
      Caption = 'V&isible'
      TabOrder = 0
    end
    object MarginStyle: TLineStyleComboBox
      Left = 84
      Top = 68
      Width = 120
      Height = 24
      HelpContext = 5090
      ItemHeight = 18
      PenStyle = psSolid
      TabOrder = 3
    end
    object MarginWidth: TLineWidthComboBox
      Left = 147
      Top = 17
      Width = 57
      HelpContext = 5100
      MaxValue = 2
      TabOrder = 1
    end
    object MarginPos: TJvSpinEdit
      Left = 107
      Top = 94
      Width = 97
      Height = 24
      HelpContext = 5110
      MaxValue = 300.000000000000000000
      MinValue = 10.000000000000000000
      Value = 10.000000000000000000
      MaxLength = 3
      TabOrder = 4
    end
    object MarginColor: THKColorBox
      Left = 84
      Top = 42
      Width = 120
      Height = 24
      HelpContext = 5120
      ItemHeight = 18
      TabOrder = 2
    end
    object WordWrapMargin: TCheckBox
      Left = 10
      Top = 123
      Width = 167
      Height = 17
      HelpContext = 8080
      Caption = 'Word wrap on margin'
      TabOrder = 5
    end
  end
  object EditGutterGroup: TGroupBox
    Left = 10
    Top = 160
    Width = 215
    Height = 109
    HelpContext = 5130
    Caption = '&Editor gutter'
    TabOrder = 1
    object ColorGutterLbl: TLabel
      Left = 10
      Top = 52
      Width = 27
      Height = 13
      Caption = 'C&olor:'
      FocusControl = GutterColor
    end
    object StyleLbl: TLabel
      Left = 10
      Top = 82
      Width = 26
      Height = 13
      Caption = 'S&tyle:'
      FocusControl = GutterStyle
    end
    object WidthLbl: TLabel
      Left = 96
      Top = 23
      Width = 31
      Height = 13
      Caption = 'Width:'
    end
    object GutterVisible: TCheckBox
      Left = 10
      Top = 19
      Width = 79
      Height = 21
      HelpContext = 5130
      Caption = '&Visible'
      TabOrder = 0
    end
    object GutterStyle: TFillStyleComboBox
      Left = 84
      Top = 78
      Width = 120
      Height = 24
      HelpContext = 5140
      ItemHeight = 18
      TabOrder = 3
    end
    object GutterWidth: TJvSpinEdit
      Left = 147
      Top = 18
      Width = 57
      Height = 24
      HelpContext = 5150
      MaxValue = 300.000000000000000000
      MinValue = 20.000000000000000000
      Value = 20.000000000000000000
      TabOrder = 1
    end
    object GutterColor: THKColorBox
      Left = 84
      Top = 48
      Width = 120
      Height = 24
      HelpContext = 5160
      ItemHeight = 18
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 235
    Top = 160
    Width = 215
    Height = 109
    HelpContext = 5170
    Caption = '&Line Separator'
    TabOrder = 3
    object Label15: TLabel
      Left = 10
      Top = 52
      Width = 27
      Height = 13
      Caption = 'Colo&r:'
      FocusControl = LineSepColor
    end
    object Label16: TLabel
      Left = 10
      Top = 82
      Width = 26
      Height = 13
      Caption = 'St&yle:'
      FocusControl = LineSepStyle
    end
    object Label17: TLabel
      Left = 96
      Top = 23
      Width = 31
      Height = 13
      Caption = 'Width:'
      FocusControl = LineSepWidth
    end
    object LineSeparator: TCheckBox
      Left = 10
      Top = 19
      Width = 79
      Height = 21
      HelpContext = 5170
      Caption = 'Visi&ble'
      TabOrder = 0
    end
    object LineSepWidth: TLineWidthComboBox
      Left = 147
      Top = 18
      Width = 57
      HelpContext = 5180
      MaxValue = 2
      TabOrder = 1
    end
    object LineSepStyle: TLineStyleComboBox
      Left = 84
      Top = 78
      Width = 120
      Height = 24
      HelpContext = 5190
      ItemHeight = 18
      PenStyle = psSolid
      TabOrder = 3
    end
    object LineSepColor: THKColorBox
      Left = 84
      Top = 48
      Width = 120
      Height = 24
      HelpContext = 5200
      ItemHeight = 18
      TabOrder = 2
    end
  end
  object GroupBox5: TGroupBox
    Left = 235
    Top = 7
    Width = 215
    Height = 149
    HelpContext = 5210
    Caption = 'Line &Highlight'
    TabOrder = 2
    object Label24: TLabel
      Left = 10
      Top = 46
      Width = 49
      Height = 13
      Caption = 'Li&ne color:'
      FocusControl = LHLineColor
    end
    object Label25: TLabel
      Left = 10
      Top = 71
      Width = 26
      Height = 13
      Caption = 'Style:'
      FocusControl = LHLineStyle
    end
    object Label26: TLabel
      Left = 96
      Top = 20
      Width = 31
      Height = 13
      Caption = 'Width:'
      FocusControl = LHWidth
    end
    object Label27: TLabel
      Left = 10
      Top = 98
      Width = 61
      Height = 13
      Caption = 'B&ackground:'
      FocusControl = LHBackColor
    end
    object Label28: TLabel
      Left = 10
      Top = 123
      Width = 26
      Height = 13
      Caption = 'Style:'
      FocusControl = LHBackStyle
    end
    object LHVisible: TCheckBox
      Left = 10
      Top = 16
      Width = 79
      Height = 21
      HelpContext = 5210
      Caption = 'Visible'
      TabOrder = 0
    end
    object LHWidth: TLineWidthComboBox
      Left = 147
      Top = 16
      Width = 57
      HelpContext = 5220
      MaxValue = 2
      TabOrder = 1
    end
    object LHLineStyle: TLineStyleComboBox
      Left = 84
      Top = 68
      Width = 120
      Height = 22
      HelpContext = 5230
      ItemHeight = 16
      PenStyle = psSolid
      TabOrder = 3
    end
    object LHBackStyle: TFillStyleComboBox
      Left = 84
      Top = 120
      Width = 120
      Height = 22
      HelpContext = 5240
      ItemHeight = 16
      TabOrder = 5
    end
    object LHLineColor: THKColorBox
      Left = 84
      Top = 42
      Width = 120
      Height = 22
      HelpContext = 5250
      ItemHeight = 16
      TabOrder = 2
    end
    object LHBackColor: THKColorBox
      Left = 84
      Top = 94
      Width = 120
      Height = 22
      HelpContext = 5260
      ItemHeight = 16
      TabOrder = 4
    end
  end
end
