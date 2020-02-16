object PerlPrinterForm: TPerlPrinterForm
  Left = 304
  Top = 304
  HelpContext = 430
  Anchors = [akLeft, akBottom]
  BorderStyle = bsDialog
  Caption = 'Perl Printer'
  ClientHeight = 264
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnResize = FormResize
  DesignSize = (
    505
    264)
  PixelsPerInch = 96
  TextHeight = 13
  object btnInsert: TButton
    Left = 428
    Top = 234
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Insert'
    TabOrder = 4
    OnClick = btnInsertClick
  end
  object btnOpen: TButton
    Left = 428
    Top = 205
    Width = 73
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Open file'
    TabOrder = 3
    OnClick = btnOpenClick
  end
  object gbInput: TGroupBox
    Left = 5
    Top = 2
    Width = 244
    Height = 135
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'I&nput'
    TabOrder = 0
    DesignSize = (
      244
      135)
    object memInput: TMemo
      Left = 7
      Top = 18
      Width = 230
      Height = 110
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
      OnChange = memInputChange
    end
  end
  object gbOutput: TGroupBox
    Left = 255
    Top = 2
    Width = 244
    Height = 135
    Anchors = [akLeft, akTop, akBottom]
    Caption = 'Ou&tput'
    TabOrder = 1
    DesignSize = (
      244
      135)
    object memOutput: TMemo
      Left = 7
      Top = 18
      Width = 230
      Height = 110
      Anchors = [akLeft, akTop, akRight, akBottom]
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  object GroupBox: TGroupBox
    Left = 5
    Top = 140
    Width = 393
    Height = 120
    Anchors = [akLeft, akBottom]
    Caption = '&Quoting Options'
    TabOrder = 2
    object Label1: TLabel
      Left = 256
      Top = 60
      Width = 21
      Height = 13
      Caption = '&end:'
      FocusControl = cbEnd
    end
    object Bevel: TBevel
      Left = 1
      Top = 85
      Width = 391
      Height = 10
      Shape = bsTopLine
    end
    object Label2: TLabel
      Left = 272
      Top = 96
      Width = 33
      Height = 13
      Caption = 'In&dent:'
      FocusControl = edIndent
    end
    object cbStart: TComboBox
      Left = 120
      Top = 56
      Width = 128
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = 'print qq|'
      OnChange = memInputChange
      OnClick = memInputChange
      Items.Strings = (
        'print qq|'
        'print "'
        'print '#39)
    end
    object rbHere: TRadioButton
      Left = 8
      Top = 23
      Width = 113
      Height = 17
      Caption = '&Here Document:'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbLineClick
    end
    object rbLine: TRadioButton
      Left = 8
      Top = 58
      Width = 97
      Height = 17
      Caption = '&Line. Start:'
      TabOrder = 2
      OnClick = rbLineClick
    end
    object cbHere: TComboBox
      Left = 120
      Top = 21
      Width = 128
      Height = 21
      ItemHeight = 13
      TabOrder = 1
      Text = 'HTML'
      OnChange = memInputChange
      OnClick = memInputChange
      Items.Strings = (
        'HTML'
        'StartHdr'
        'EndFooter')
    end
    object cbEnd: TComboBox
      Left = 286
      Top = 56
      Width = 95
      Height = 21
      ItemHeight = 13
      TabOrder = 4
      Text = '|,"\n";'
      OnChange = memInputChange
      OnClick = memInputChange
      Items.Strings = (
        '|,"\n";'
        '\n";'
        #39',"\n";')
    end
    object cbEncode: TCheckBox
      Left = 12
      Top = 94
      Width = 109
      Height = 17
      Caption = '&URL Encode'
      TabOrder = 5
      OnClick = memInputChange
    end
    object edIndent: TJvSpinEdit
      Left = 316
      Top = 92
      Width = 65
      Height = 21
      MaxValue = 99.000000000000000000
      Value = 1.000000000000000000
      MaxLength = 2
      TabOrder = 7
      OnChange = memInputChange
    end
    object cbSmart: TCheckBox
      Left = 137
      Top = 94
      Width = 101
      Height = 17
      Caption = '&Smart backslash'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = memInputChange
    end
  end
  object FormStorage: TJvFormStorage
    Options = []
    StoredProps.Strings = (
      'cbEnd.Text'
      'cbEnd.Items'
      'cbHere.Items'
      'cbHere.Text'
      'cbStart.Text'
      'cbStart.Items'
      'rbHere.Enabled'
      'rbLine.Enabled'
      'cbEncode.Enabled'
      'edIndent.Value'
      'cbSmart.Checked'
      'cbEncode.Checked')
    StoredValues = <>
    Left = 69
    Top = 50
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Filter = 
      'Text Files (*.txt)|*.txt|HTML Files (*.htm;*.html)|*.htm;*.html|' +
      'All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Perl Printer...'
    Left = 157
    Top = 50
  end
  object Timer: TTimer
    Interval = 700
    OnTimer = TimerTimer
    Left = 319
    Top = 74
  end
end
