inherited OFormPrinter: TOFormPrinter
  Left = 328
  Top = 309
  Caption = 'OFormPrinter'
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox10: TGroupBox
    Left = 10
    Top = 7
    Width = 438
    Height = 263
    Caption = 'Printer settings'
    TabOrder = 0
    object Label67: TLabel
      Left = 16
      Top = 28
      Width = 56
      Height = 13
      Caption = '&Top margin:'
      FocusControl = PrintMarginTop
    end
    object Label69: TLabel
      Left = 16
      Top = 57
      Width = 70
      Height = 13
      Caption = '&Bottom margin:'
      FocusControl = PrintMarginBottom
    end
    object Label70: TLabel
      Left = 16
      Top = 86
      Width = 55
      Height = 13
      Caption = '&Left margin:'
      FocusControl = PrintMarginLeft
    end
    object Label71: TLabel
      Left = 16
      Top = 115
      Width = 62
      Height = 13
      Caption = '&Right margin:'
      FocusControl = PrintMarginRight
    end
    object Label68: TLabel
      Left = 235
      Top = 22
      Width = 71
      Height = 13
      HelpContext = 5410
      Caption = '&Scale font to fit'
      FocusControl = PrintLinesPerPage
    end
    object Label72: TLabel
      Left = 235
      Top = 62
      Width = 66
      Height = 13
      HelpContext = 5410
      Caption = 'lines per page'
    end
    object Label1: TLabel
      Left = 304
      Top = 173
      Width = 27
      Height = 13
      Caption = '&Pixels'
      FocusControl = PrintOvLinesWidth
    end
    object EditFontLbl: TLabel
      Left = 235
      Top = 90
      Width = 24
      Height = 13
      HelpContext = 4650
      Caption = '&Font:'
      FocusControl = PrintFontName
    end
    object PrintMarginTop: TJvSpinEdit
      Left = 96
      Top = 24
      Width = 81
      Height = 24
      HelpContext = 5320
      MaxValue = 5.000000000000000000
      MinValue = 0.010000000000000000
      ValueType = vtFloat
      Value = 0.500000000000000000
      TabOrder = 0
    end
    object PrintMarginBottom: TJvSpinEdit
      Left = 96
      Top = 53
      Width = 81
      Height = 24
      HelpContext = 5320
      MaxValue = 5.000000000000000000
      MinValue = 0.010000000000000000
      ValueType = vtFloat
      Value = 0.500000000000000000
      TabOrder = 1
    end
    object PrintMarginLeft: TJvSpinEdit
      Left = 96
      Top = 82
      Width = 81
      Height = 24
      HelpContext = 5320
      MaxValue = 5.000000000000000000
      MinValue = 0.010000000000000000
      ValueType = vtFloat
      Value = 0.500000000000000000
      TabOrder = 2
    end
    object PrintMarginRight: TJvSpinEdit
      Left = 96
      Top = 111
      Width = 81
      Height = 24
      HelpContext = 5320
      MaxValue = 5.000000000000000000
      MinValue = 0.010000000000000000
      ValueType = vtFloat
      Value = 0.500000000000000000
      TabOrder = 3
    end
    object PrintSyntax: TCheckBox
      Left = 16
      Top = 159
      Width = 97
      Height = 17
      HelpContext = 5360
      Caption = 'S&yntax coding'
      TabOrder = 4
    end
    object PrintLines: TCheckBox
      Left = 16
      Top = 181
      Width = 129
      Height = 17
      HelpContext = 5370
      Caption = 'Pri&nt line coding'
      TabOrder = 5
    end
    object PrintBoxes: TCheckBox
      Left = 16
      Top = 203
      Width = 121
      Height = 17
      HelpContext = 5380
      Caption = 'Print bo&x coding'
      TabOrder = 6
    end
    object PrintOvLinesWidth: TJvSpinEdit
      Left = 235
      Top = 167
      Width = 62
      Height = 24
      HelpContext = 5390
      MaxValue = 99.000000000000000000
      MinValue = 1.000000000000000000
      Value = 1.000000000000000000
      MaxLength = 2
      TabOrder = 11
    end
    object PrintOvLines: TCheckBox
      Left = 235
      Top = 145
      Width = 145
      Height = 17
      HelpContext = 5390
      Caption = '&Override line widths with:'
      TabOrder = 10
    end
    object PrintLinesPerPage: TJvSpinEdit
      Left = 235
      Top = 37
      Width = 100
      Height = 24
      HelpContext = 5410
      MaxValue = 500.000000000000000000
      MinValue = 30.000000000000000000
      Value = 30.000000000000000000
      MaxLength = 3
      TabOrder = 8
    end
    object PrintOnlySolid: TCheckBox
      Left = 16
      Top = 225
      Width = 113
      Height = 17
      HelpContext = 5420
      Caption = 'Sol&id patterns'
      TabOrder = 7
    end
    object PrintFontName: TJvFontComboBox
      Left = 235
      Top = 105
      Width = 166
      Height = 22
      HelpContext = 7810
      FontName = 'System'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemIndex = 0
      UseImages = False
      ParentFont = False
      Sorted = False
      TabOrder = 9
    end
    object PrintComp: TCheckBox
      Left = 235
      Top = 225
      Width = 118
      Height = 17
      HelpContext = 7820
      Caption = 'Compatible mode'
      TabOrder = 13
    end
    object PrintFooter: TCheckBox
      Left = 235
      Top = 203
      Width = 182
      Height = 17
      Caption = 'Print filename and page number'
      TabOrder = 12
    end
  end
end
