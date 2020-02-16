object ChartPreview: TChartPreview
  Left = 121
  Top = 130
  AutoScroll = False
  Caption = 'Print Preview'
  ClientHeight = 383
  ClientWidth = 551
  Color = clBtnFace
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 551
    Height = 38
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 3
      Top = 13
      Width = 52
      Height = 17
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'P&rinter:'
      FocusControl = Printers
    end
    object Printers: TComboBox
      Left = 57
      Top = 9
      Width = 195
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = PrintersChange
    end
    object BSetupPrinter: TBitBtn
      Left = 262
      Top = 7
      Width = 100
      Height = 23
      Caption = 'Printer &Setup...'
      TabOrder = 1
      OnClick = BSetupPrinterClick
      NumGlyphs = 2
    end
    object BClose: TButton
      Left = 451
      Top = 7
      Width = 69
      Height = 23
      Cancel = True
      Caption = 'Close'
      Default = True
      ModalResult = 1
      TabOrder = 2
      OnClick = BCloseClick
    end
    object BPrint: TButton
      Left = 371
      Top = 7
      Width = 69
      Height = 23
      Caption = '&Print'
      TabOrder = 3
      OnClick = BPrintClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 38
    Width = 112
    Height = 345
    Align = alLeft
    TabOrder = 1
    object Orientation: TRadioGroup
      Left = 3
      Top = 3
      Width = 105
      Height = 57
      Caption = 'Paper Orientation:'
      ItemIndex = 1
      Items.Strings = (
        'P&ortrait'
        '&Landscape')
      TabOrder = 0
      OnClick = OrientationClick
    end
    object GBMargins: TGroupBox
      Left = 3
      Top = 67
      Width = 105
      Height = 95
      Caption = 'Margins (%)'
      TabOrder = 1
      object SETopMa: TEdit
        Left = 34
        Top = 17
        Width = 27
        Height = 21
        TabOrder = 0
        Text = '0'
        OnChange = SETopMaChange
      end
      object SELeftMa: TEdit
        Left = 6
        Top = 43
        Width = 26
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = SELeftMaChange
      end
      object SEBotMa: TEdit
        Left = 34
        Top = 68
        Width = 27
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = SEBotMaChange
      end
      object SERightMa: TEdit
        Left = 58
        Top = 43
        Width = 27
        Height = 21
        TabOrder = 3
        Text = '0'
        OnChange = SERightMaChange
      end
      object UDLeftMa: TUpDown
        Left = 32
        Top = 43
        Width = 15
        Height = 21
        Associate = SELeftMa
        Min = 0
        Position = 0
        TabOrder = 4
        Wrap = False
      end
      object UDTopMa: TUpDown
        Left = 61
        Top = 17
        Width = 15
        Height = 21
        Associate = SETopMa
        Min = 0
        Position = 0
        TabOrder = 5
        Wrap = False
      end
      object UDRightMa: TUpDown
        Left = 85
        Top = 43
        Width = 15
        Height = 21
        Associate = SERightMa
        Min = 0
        Position = 0
        TabOrder = 6
        Wrap = False
      end
      object UDBotMa: TUpDown
        Left = 61
        Top = 68
        Width = 15
        Height = 21
        Associate = SEBotMa
        Min = 0
        Position = 0
        TabOrder = 7
        Wrap = False
      end
    end
    object ShowMargins: TCheckBox
      Left = 13
      Top = 204
      Width = 95
      Height = 14
      Caption = '&View Margins'
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = ShowMarginsClick
    end
    object BReset: TButton
      Left = 12
      Top = 171
      Width = 86
      Height = 25
      Caption = 'Reset &Margins'
      Enabled = False
      TabOrder = 3
      OnClick = BResetClick
    end
    object ChangeDetailGroup: TGroupBox
      Left = 3
      Top = 229
      Width = 105
      Height = 66
      Caption = 'Detail:'
      TabOrder = 4
      object Label2: TLabel
        Left = 8
        Top = 18
        Width = 36
        Height = 19
        AutoSize = False
        Caption = 'More'
      end
      object Label3: TLabel
        Left = 57
        Top = 18
        Width = 41
        Height = 15
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'Normal'
      end
      object Resolution: TScrollBar
        Left = 8
        Top = 38
        Width = 90
        Height = 16
        Max = 0
        Min = -100
        PageSize = 0
        TabOrder = 0
        OnChange = ResolutionChange
      end
    end
    object CBProp: TCheckBox
      Left = 13
      Top = 304
      Width = 92
      Height = 17
      Caption = 'Proportional'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = CBPropClick
    end
  end
  object PrinterSetupDialog1: TPrinterSetupDialog
    Left = 149
    Top = 46
  end
end
