inherited OFormLines: TOFormLines
  Left = 392
  Top = 255
  Caption = 'OFormLines'
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object LineGroup: TGroupBox
    Left = 10
    Top = 7
    Width = 438
    Height = 262
    Caption = 'Bracket levels'
    TabOrder = 0
    object Label29: TLabel
      Left = 16
      Top = 53
      Width = 54
      Height = 13
      Caption = 'Line level &1'
      FocusControl = Line1Width
    end
    object Label30: TLabel
      Left = 160
      Top = 16
      Width = 48
      Height = 13
      Caption = 'Line width'
    end
    object Label31: TLabel
      Left = 260
      Top = 16
      Width = 23
      Height = 13
      Caption = 'Style'
    end
    object Label32: TLabel
      Left = 364
      Top = 16
      Width = 24
      Height = 13
      Caption = 'Color'
    end
    object Label33: TLabel
      Left = 103
      Top = 16
      Width = 30
      Height = 13
      Caption = 'Visible'
    end
    object Label34: TLabel
      Left = 16
      Top = 85
      Width = 54
      Height = 13
      Caption = 'Line level &2'
      FocusControl = Line2Width
    end
    object Label35: TLabel
      Left = 16
      Top = 117
      Width = 54
      Height = 13
      Caption = 'Line level &3'
      FocusControl = Line3Width
    end
    object Label36: TLabel
      Left = 16
      Top = 149
      Width = 54
      Height = 13
      Caption = 'Line level &4'
      FocusControl = Line4Width
    end
    object Label37: TLabel
      Left = 16
      Top = 181
      Width = 54
      Height = 13
      Caption = 'Line level &5'
      FocusControl = Line5Width
    end
    object Label38: TLabel
      Left = 16
      Top = 213
      Width = 54
      Height = 13
      Caption = 'Line level &6'
      FocusControl = Line6Width
    end
    object Bevel1: TBevel
      Left = 222
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Bevel2: TBevel
      Left = 147
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Bevel3: TBevel
      Left = 91
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Bevel4: TBevel
      Left = 326
      Top = 7
      Width = 9
      Height = 254
      Shape = bsLeftLine
    end
    object Line1Pen: TLineStyleComboBox
      Left = 235
      Top = 49
      Width = 80
      Height = 24
      HelpContext = 5700
      ItemHeight = 18
      PenStyle = psSolid
      TabOrder = 2
    end
    object Line1Width: TLineWidthComboBox
      Left = 157
      Top = 49
      Width = 57
      Height = 24
      HelpContext = 5710
      ItemHeight = 18
      MaxValue = 9
      TabOrder = 1
    end
    object Line1Visible: TCheckBox
      Left = 113
      Top = 51
      Width = 25
      Height = 17
      HelpContext = 5720
      TabOrder = 0
    end
    object Line2Visible: TCheckBox
      Left = 113
      Top = 83
      Width = 25
      Height = 17
      HelpContext = 5720
      TabOrder = 4
    end
    object Line2Width: TLineWidthComboBox
      Left = 157
      Top = 81
      Width = 57
      Height = 24
      HelpContext = 5710
      ItemHeight = 18
      MaxValue = 9
      TabOrder = 5
    end
    object Line2Pen: TLineStyleComboBox
      Left = 235
      Top = 81
      Width = 80
      Height = 24
      HelpContext = 5700
      ItemHeight = 18
      PenStyle = psSolid
      TabOrder = 6
    end
    object Line3Visible: TCheckBox
      Left = 113
      Top = 115
      Width = 25
      Height = 17
      HelpContext = 5720
      TabOrder = 8
    end
    object Line3Width: TLineWidthComboBox
      Left = 157
      Top = 113
      Width = 57
      Height = 24
      HelpContext = 5710
      ItemHeight = 18
      MaxValue = 9
      TabOrder = 9
    end
    object Line3Pen: TLineStyleComboBox
      Left = 235
      Top = 113
      Width = 80
      Height = 24
      HelpContext = 5700
      ItemHeight = 18
      PenStyle = psSolid
      TabOrder = 10
    end
    object Line4Visible: TCheckBox
      Left = 113
      Top = 147
      Width = 25
      Height = 17
      HelpContext = 5720
      TabOrder = 12
    end
    object Line4Width: TLineWidthComboBox
      Left = 157
      Top = 145
      Width = 57
      Height = 24
      HelpContext = 5710
      ItemHeight = 18
      MaxValue = 9
      TabOrder = 13
    end
    object Line4Pen: TLineStyleComboBox
      Left = 235
      Top = 145
      Width = 80
      Height = 24
      HelpContext = 5700
      ItemHeight = 18
      PenStyle = psSolid
      TabOrder = 14
    end
    object Line5Visible: TCheckBox
      Left = 113
      Top = 179
      Width = 25
      Height = 17
      HelpContext = 5720
      TabOrder = 16
    end
    object Line5Width: TLineWidthComboBox
      Left = 157
      Top = 177
      Width = 57
      Height = 24
      HelpContext = 5710
      ItemHeight = 18
      MaxValue = 9
      TabOrder = 17
    end
    object Line5Pen: TLineStyleComboBox
      Left = 235
      Top = 177
      Width = 80
      Height = 24
      HelpContext = 5700
      ItemHeight = 18
      PenStyle = psSolid
      TabOrder = 18
    end
    object Line6Visible: TCheckBox
      Left = 113
      Top = 211
      Width = 25
      Height = 17
      HelpContext = 5720
      TabOrder = 20
    end
    object Line6Width: TLineWidthComboBox
      Left = 157
      Top = 209
      Width = 57
      Height = 24
      HelpContext = 5710
      ItemHeight = 18
      MaxValue = 9
      TabOrder = 21
    end
    object Line6Pen: TLineStyleComboBox
      Left = 235
      Top = 209
      Width = 80
      Height = 24
      HelpContext = 5700
      ItemHeight = 18
      PenStyle = psSolid
      TabOrder = 22
    end
    object Line1Color: THKColorBox
      Left = 338
      Top = 49
      Width = 88
      Height = 24
      HelpContext = 5880
      ItemHeight = 18
      TabOrder = 3
    end
    object Line2Color: THKColorBox
      Left = 338
      Top = 81
      Width = 88
      Height = 24
      HelpContext = 5880
      ItemHeight = 18
      TabOrder = 7
    end
    object Line3Color: THKColorBox
      Left = 338
      Top = 113
      Width = 88
      Height = 24
      HelpContext = 5880
      ItemHeight = 18
      TabOrder = 11
    end
    object Line4Color: THKColorBox
      Left = 338
      Top = 145
      Width = 88
      Height = 24
      HelpContext = 5880
      ItemHeight = 18
      TabOrder = 15
    end
    object Line5Color: THKColorBox
      Left = 338
      Top = 177
      Width = 88
      Height = 24
      HelpContext = 5880
      ItemHeight = 18
      TabOrder = 19
    end
    object Line6Color: THKColorBox
      Left = 338
      Top = 209
      Width = 88
      Height = 24
      HelpContext = 5880
      ItemHeight = 18
      TabOrder = 23
    end
  end
end
