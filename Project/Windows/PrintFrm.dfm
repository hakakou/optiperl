object PrintForm: TPrintForm
  Left = 314
  Top = 167
  HelpContext = 6740
  AutoScroll = False
  Caption = 'Print Preview'
  ClientHeight = 542
  ClientWidth = 575
  Color = clBtnFace
  Constraints.MinWidth = 220
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnResize = FormResize
  DesignSize = (
    575
    542)
  PixelsPerInch = 96
  TextHeight = 13
  object ScrollBox: TScrollBox
    Left = 155
    Top = 8
    Width = 412
    Height = 528
    HorzScrollBar.Smooth = True
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clAppWorkSpace
    ParentColor = False
    TabOrder = 0
    object Image: TImage
      Left = 4
      Top = 3
      Width = 321
      Height = 425
      Proportional = True
      Stretch = True
      OnMouseDown = ImageMouseDown
    end
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 4
    Width = 138
    Height = 155
    Caption = '&Printing region'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 19
      Width = 45
      Height = 13
      Caption = '&From line:'
      FocusControl = edStartLine
    end
    object Label2: TLabel
      Left = 16
      Top = 63
      Width = 35
      Height = 13
      Caption = '&To line:'
      FocusControl = edEndLine
    end
    object lblPages: TLabel
      Left = 15
      Top = 130
      Width = 6
      Height = 13
      Caption = '&1'
    end
    object edEndLine: TJvSpinEdit
      Left = 16
      Top = 78
      Width = 105
      Height = 21
      MaxValue = 999999999.000000000000000000
      MinValue = 1.000000000000000000
      Value = 1.000000000000000000
      OnBottomClick = edStartLineChange
      OnTopClick = edStartLineChange
      MaxLength = 9
      TabOrder = 1
      OnChange = edStartLineChange
    end
    object edStartLine: TJvSpinEdit
      Left = 16
      Top = 34
      Width = 105
      Height = 21
      MaxValue = 999999999.000000000000000000
      MinValue = 1.000000000000000000
      Value = 1.000000000000000000
      OnBottomClick = edStartLineChange
      OnTopClick = edStartLineChange
      MaxLength = 9
      TabOrder = 0
      OnChange = edStartLineChange
    end
    object cbSelection: TCheckBox
      Left = 16
      Top = 106
      Width = 97
      Height = 17
      Caption = '&Selection'
      TabOrder = 2
      OnClick = cbSelectionClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 166
    Width = 137
    Height = 135
    Caption = 'P&review'
    TabOrder = 2
    object Label3: TLabel
      Left = 16
      Top = 19
      Width = 68
      Height = 13
      Caption = 'Pre&view page:'
      FocusControl = edPrevPage
    end
    object btnPreview: TButton
      Left = 16
      Top = 66
      Width = 75
      Height = 25
      Caption = 'Prev&iew'
      TabOrder = 1
      OnClick = btnPreviewClick
    end
    object edPrevPage: TJvSpinEdit
      Left = 16
      Top = 34
      Width = 74
      Height = 21
      MaxValue = 1.000000000000000000
      MinValue = 1.000000000000000000
      Value = 1.000000000000000000
      TabOrder = 0
    end
    object btnExport: TButton
      Left = 16
      Top = 98
      Width = 75
      Height = 25
      Caption = '&Export'
      Enabled = False
      TabOrder = 2
      OnClick = btnExportClick
    end
  end
  object PrintBox: TGroupBox
    Left = 8
    Top = 308
    Width = 137
    Height = 170
    Caption = 'Pri&nt'
    TabOrder = 3
    object lblStatus: TLabel
      Left = 15
      Top = 148
      Width = 6
      Height = 13
      Caption = '1'
    end
    object btnSetup: TButton
      Left = 16
      Top = 21
      Width = 94
      Height = 25
      Caption = 'Printer Set&up'
      TabOrder = 0
      OnClick = btnSetupClick
    end
    object btnPrint: TButton
      Left = 16
      Top = 53
      Width = 94
      Height = 25
      Caption = 'Print'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnPrintClick
    end
    object btnCancel: TButton
      Left = 16
      Top = 117
      Width = 94
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object btnPrintPage: TButton
      Left = 16
      Top = 85
      Width = 94
      Height = 25
      Caption = 'Print t&his page'
      TabOrder = 2
      OnClick = btnPrintPageClick
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 264
    Top = 112
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofEnableSizing, ofDontAddToRecent]
    Title = 'Export picture'
    Left = 224
    Top = 240
  end
  object FormStorage: TJvFormStorage
    Options = [fpPosition]
    StoredValues = <>
    Left = 200
    Top = 80
  end
end
