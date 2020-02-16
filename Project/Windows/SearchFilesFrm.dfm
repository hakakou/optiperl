object SearchFilesForm: TSearchFilesForm
  Left = 330
  Top = 212
  HelpContext = 820
  BorderStyle = bsDialog
  Caption = 'Search files'
  ClientHeight = 332
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl: TTabControl
    Left = 0
    Top = 0
    Width = 504
    Height = 291
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Tabs.Strings = (
      'Search'
      'Rep&lace')
    TabIndex = 0
    OnChange = TabControlChange
    object lblFiles: TLabel
      Left = 460
      Top = 5
      Width = 31
      Height = 13
      Alignment = taRightJustify
      Caption = 'lblFiles'
      Transparent = True
    end
    object FindBox: TGroupBox
      Left = 11
      Top = 30
      Width = 481
      Height = 77
      Caption = '&Find Pattern'
      TabOrder = 0
      object btnLast: TSpeedButton
        Left = 384
        Top = 47
        Width = 80
        Height = 20
        Caption = 'Last Search'
        Flat = True
        OnClick = btnLastClick
      end
      object edFind: TComboBox
        Left = 16
        Top = 22
        Width = 449
        Height = 21
        Hint = 'Regular expression to search for.'#13#10'EOL character is \n.'
        ItemHeight = 13
        TabOrder = 0
        OnChange = edFindChange
        Items.Strings = (
          '(FTP|HTTP)://([_a-z\d\-]+(\.[_a-z\d\-]+)+)((/[_a-z\d\-\\\.]+)+)*')
      end
      object cbCase: TCheckBox
        Left = 159
        Top = 49
        Width = 95
        Height = 17
        Hint = 'Select this box for a case sensitive search'
        Caption = 'Case &sensitive'
        TabOrder = 2
      end
      object cbUngreedy: TCheckBox
        Left = 263
        Top = 49
        Width = 114
        Height = 17
        Caption = 'Ungreedy'
        TabOrder = 3
      end
      object cbRegExp: TCheckBox
        Left = 16
        Top = 49
        Width = 136
        Height = 17
        Hint = 
          'Select this box to enable searching and replacing using a perl c' +
          'ompatible regular expression'
        Caption = '&Perl regular expression'
        TabOrder = 1
        OnClick = cbRegExpClick
      end
    end
    object ReplBox: TGroupBox
      Left = 11
      Top = 113
      Width = 481
      Height = 96
      Caption = '&Replace with'
      TabOrder = 1
      object edReplace: TComboBox
        Left = 16
        Top = 22
        Width = 449
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        OnChange = edFindChange
      end
      object cbPrompt: TCheckBox
        Left = 16
        Top = 48
        Width = 122
        Height = 17
        Hint = 
          'Prompt on each occurance of the search pattern to query if the r' +
          'eplacement should be made'
        Caption = 'Prompt on repla&ce'
        TabOrder = 1
        OnClick = cbPromptClick
      end
      object cbOpen: TCheckBox
        Left = 152
        Top = 48
        Width = 273
        Height = 17
        Hint = 
          'Will not actually save files after the replacement, only open th' +
          'em in the editor (were you can save them afterwards)'
        Caption = '&Open files in editor after replacing; don'#39't save'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object cbEOL: TCheckBox
        Left = 16
        Top = 70
        Width = 217
        Height = 17
        Hint = 
          'Will detect the EOL format of the file (Windows, Unix, Mac) and ' +
          'save accordingly.'#13#10'This should be enabled if you want the \n pat' +
          'tern to match a line, without risk '#13#10'of messing up the file'#39's li' +
          'ne ending sequence.'#13#10' '#13#10'Will not affect binary files.'
        Caption = 'Detect && &keep EOL character format'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
    end
    object MaskBox: TGroupBox
      Left = 11
      Top = 215
      Width = 481
      Height = 63
      Caption = 'F&ile Mask'
      TabOrder = 2
      object edFileMask: TComboBox
        Left = 16
        Top = 25
        Width = 273
        Height = 21
        ItemHeight = 13
        TabOrder = 0
        Text = '*.*'
        Items.Strings = (
          '*.*'
          '*.pl;*.plx;*.cgi;*.pm;'
          '*.html;*.htm')
      end
      object cbRecursive: TCheckBox
        Left = 326
        Top = 17
        Width = 106
        Height = 17
        Hint = 'Include subdirectories in search'
        Caption = 'R&ecursive search'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object cbBinary: TCheckBox
        Left = 326
        Top = 36
        Width = 137
        Height = 17
        Hint = 'Search in binary files also (slower)'
        Caption = 'Search in &binary files'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = cbBinaryClick
      end
    end
  end
  object Panel: TPanel
    Left = 0
    Top = 293
    Width = 504
    Height = 39
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      504
      39)
    object lblSearching: TLabel
      Left = 42
      Top = 10
      Width = 273
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Searching for files...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object btnOK: TButton
      Left = 339
      Top = 6
      Width = 72
      Height = 26
      Caption = 'Search'
      Default = True
      ModalResult = 1
      TabOrder = 2
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 417
      Top = 6
      Width = 74
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object btnHighLight: TBitBtn
      Left = 11
      Top = 6
      Width = 23
      Height = 25
      Anchors = [akLeft, akBottom]
      TabOrder = 0
      OnClick = btnHighLightClick
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7CEF3D420821040000000000000000000000000000
        000000001F7C1F7C1F7C1F7CEF3D1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C00001F7C1F7C1F7C1F7CEF3D1F7C1F7C1F7C1F7C1F7C1F7C0D000D000D00
        0D0000001F7C1F7C1F7C1F7CEF3D1F7C1F7C6F0C2D041F7C1F7C0D001F7C1F7C
        0D0021041F7C1F7C1F7C1F7CEF3D1F7C8E106F0C2D040D001F7C0D001F7C1F7C
        2D0442081F7C1F7C1F7C1F7CEF3D1F7C6F0C6F0C2D040D000D000D000D000D00
        2D0442081F7C1F7C1F7C1F7CEF3D1F7C1F7C6F0C2D001F7C1F7C1F7C0D001F7C
        1F7C21041F7C1F7C1F7C1F7C1F7CEF3D1F7C2D041F7C1F7C1F7C0D001F7C1F7C
        1F7C00001F7C1F7C1F7C1F7CEF3DEF3D1F7C1F7C0D001F7C0D001F7CAD310000
        000000001F7C1F7C1F7CEF3D630C4208AD351F7C1F7C0D001F7C1F7C8D311F7C
        00001F7C1F7C1F7C1F7C630C1F7C1F7C00008C311F7C1F7C1F7C1F7C8D310000
        1F7C1F7C1F7C1F7C1F7C630C1F7C1F7C00008D31AD31AD35AD318D318D311F7C
        1F7C1F7C1F7C1F7C630C843C210400008D311F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C630C843C42081F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C630C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      Layout = blGlyphRight
    end
    object cbAllOpen: TCheckBox
      Left = 42
      Top = 10
      Width = 135
      Height = 16
      Hint = 
        'If selected, all files currently open will be searched; else onl' +
        'y the active file.'
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Sear&ch all open files'
      TabOrder = 1
      OnClick = cbAllOpenClick
    end
    object ProgressBar: TProgressBar
      Left = 42
      Top = 9
      Width = 64
      Height = 17
      Smooth = True
      TabOrder = 4
      Visible = False
    end
  end
  object FormStorage: TJvFormStorage
    Options = [fpPosition]
    StoredProps.Strings = (
      'cbBinary.Checked'
      'cbCase.Checked'
      'cbPrompt.Checked'
      'cbRecursive.Checked'
      'edFileMask.Text'
      'edFileMask.Items'
      'edFind.Items'
      'edFind.Text'
      'edReplace.Text'
      'edReplace.Items'
      'cbOpen.Checked'
      'cbUngreedy.Checked'
      'cbEOL.Checked'
      'cbRegExp.Checked')
    StoredValues = <>
    Left = 367
    Top = 154
  end
  object FindFile: TFindFile
    Filename = '*.*'
    OnFound = FindFileFound
    Left = 424
    Top = 154
  end
  object PopupMenu: TPopupMenu
    Left = 280
    Top = 192
    object Position1Item: TMenuItem
      Caption = 'Highlight Position &1'
      OnClick = PositionItemClick
    end
    object Position2Item: TMenuItem
      Tag = 1
      Caption = 'Highlight Position &2'
      OnClick = PositionItemClick
    end
    object Position3item: TMenuItem
      Tag = 2
      Caption = 'Highlight Position &3'
      OnClick = PositionItemClick
    end
    object Position4item: TMenuItem
      Tag = 3
      Caption = 'Highlight Position &4'
      OnClick = PositionItemClick
    end
  end
end
