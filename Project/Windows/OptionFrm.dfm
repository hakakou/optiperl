object OptionForm: TOptionForm
  Left = 280
  Top = 225
  HelpContext = 4199
  BorderIcons = [biSystemMenu, biHelp]
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 391
  ClientWidth = 635
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object btnWT: TSpeedButton
    Left = 551
    Top = 315
    Width = 69
    Height = 25
    Caption = '&What'#39's this?'
    Flat = True
  end
  object Status: TLabel
    Left = 190
    Top = 9
    Width = 41
    Height = 14
    Caption = 'Status'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Shell Dlg 2'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object btnOK: TButton
    Left = 217
    Top = 359
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 299
    Top = 359
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object btnDefault: TButton
    Left = 381
    Top = 359
    Width = 75
    Height = 25
    Caption = '&Default'
    TabOrder = 4
    OnClick = btnDefaultClick
  end
  object btnApply: TButton
    Left = 463
    Top = 359
    Width = 75
    Height = 25
    Caption = '&Apply'
    TabOrder = 5
    OnClick = btnApplyClick
  end
  object btnHelp: TButton
    Left = 545
    Top = 359
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 6
    OnClick = btnHelpClick
  end
  object VST: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 162
    Height = 391
    HelpContext = 7300
    Align = alLeft
    BevelInner = bvNone
    BorderStyle = bsNone
    ButtonFillMode = fmWindowColor
    ButtonStyle = bsTriangle
    CheckImageKind = ckXP
    Color = 14117167
    Colors.BorderColor = clBlack
    Colors.DisabledColor = clBlack
    Colors.DropMarkColor = clBlack
    Colors.DropTargetColor = clBlack
    Colors.DropTargetBorderColor = clBlack
    Colors.FocusedSelectionColor = 13526321
    Colors.FocusedSelectionBorderColor = 14782308
    Colors.GridLineColor = clBlack
    Colors.HotColor = clBlack
    Colors.SelectionRectangleBlendColor = clBlack
    Colors.SelectionRectangleBorderColor = clBlack
    Colors.TreeLineColor = clBtnFace
    Colors.UnfocusedSelectionColor = 13526321
    Colors.UnfocusedSelectionBorderColor = 14782308
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Shell Dlg 2'
    Font.Style = []
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintAnimation = hatNone
    ParentFont = False
    ScrollBarOptions.ScrollBars = ssVertical
    ScrollBarOptions.ScrollBarStyle = sbmFlat
    SelectionBlendFactor = 0
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnChange = VSTChange
    OnGetText = VSTGetText
    Columns = <>
  end
  object Notebook: TNotebook
    Left = 171
    Top = 30
    Width = 457
    Height = 282
    ParentColor = False
    TabOrder = 1
    OnPageChanged = NotebookPageChanged
    object TPage
      Left = 0
      Top = 0
      Caption = 'Perl'
      object AGroupBox1: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 186
        Caption = 'Perl'
        TabOrder = 0
        object Label1: TLabel
          Left = 16
          Top = 20
          Width = 60
          Height = 13
          Caption = '&Path to Perl:'
          FocusControl = PathToPerl
        end
        object Label2: TLabel
          Left = 16
          Top = 120
          Width = 91
          Height = 13
          Caption = '&Run Timeout (sec):'
          FocusControl = RunTimeOut
        end
        object Label12: TLabel
          Left = 16
          Top = 50
          Width = 32
          Height = 13
          Caption = '@&INC:'
          FocusControl = PerlSearchDir
        end
        object btnFindPerl: TSpeedButton
          Left = 358
          Top = 15
          Width = 66
          Height = 21
          HelpContext = 4200
          Caption = 'Find again'
          OnClick = btnFindPerlClick
        end
        object btnGuess: TSpeedButton
          Left = 358
          Top = 77
          Width = 66
          Height = 21
          HelpContext = 4210
          Caption = 'Guess'
          OnClick = btnGuessClick
        end
        object Label79: TLabel
          Left = 16
          Top = 150
          Width = 110
          Height = 13
          Caption = 'De&fault perl extension:'
          FocusControl = DefPerlExtension
        end
        object Label35: TLabel
          Left = 16
          Top = 81
          Width = 42
          Height = 13
          Caption = 'Perl DLL:'
          FocusControl = PerlDLL
        end
        object RunTimeOut: TJvSpinEdit
          Left = 145
          Top = 116
          Width = 58
          Height = 21
          HelpContext = 4230
          MaxValue = 999.000000000000000000
          MinValue = 1.000000000000000000
          Value = 5.000000000000000000
          MaxLength = 3
          TabOrder = 3
        end
        object PerlSearchDir: TEdit
          Left = 87
          Top = 46
          Width = 260
          Height = 21
          HelpContext = 4240
          TabOrder = 1
        end
        object DefPerlExtension: TEdit
          Left = 146
          Top = 146
          Width = 57
          Height = 21
          HelpContext = 7140
          TabOrder = 4
          Text = 'pl'
        end
        object PathToPerl: TJvFilenameEdit
          Left = 87
          Top = 16
          Width = 260
          Height = 21
          HelpContext = 4220
          DefaultExt = 'exe'
          Filter = 'Executable (*.exe)|*.exe'
          FilterIndex = 0
          DialogOptions = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
          DialogTitle = 'Select external browser'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 0
        end
        object PerlDLL: TEdit
          Left = 87
          Top = 77
          Width = 260
          Height = 21
          HelpContext = 7900
          TabOrder = 2
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Environment'
      object AGroupBox7: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 109
        Caption = '&Environment Settings'
        TabOrder = 0
        object btnResetMessages: TSpeedButton
          Left = 288
          Top = 71
          Width = 137
          Height = 23
          HelpContext = 4300
          Caption = 'Reset Message Dialogs'
          OnClick = btnResetMessagesClick
        end
        object cbOneInstance: TCheckBox
          Left = 16
          Top = 20
          Width = 225
          Height = 17
          HelpContext = 4320
          Caption = 'A&llow only one instance of OptiPerl'
          TabOrder = 0
          OnClick = cbOneInstanceClick
        end
        object ShowTipsStartup: TCheckBox
          Left = 16
          Top = 40
          Width = 137
          Height = 17
          HelpContext = 4330
          Caption = '&Show tips at startup'
          TabOrder = 1
        end
        object TrayBarIcon: TCheckBox
          Left = 16
          Top = 60
          Width = 201
          Height = 17
          HelpContext = 4340
          Caption = 'Show &tray bar icon'
          Checked = True
          State = cbChecked
          TabOrder = 2
        end
        object KeybExtended: TCheckBox
          Left = 16
          Top = 80
          Width = 233
          Height = 17
          HelpContext = 4350
          Caption = 'Enable extended &keyboard support'
          TabOrder = 3
        end
      end
      object AGroupBox10: TGroupBox
        Left = 10
        Top = 126
        Width = 438
        Height = 61
        Caption = 'Recent Lists'
        TabOrder = 1
        object btnClearRecent: TSpeedButton
          Left = 288
          Top = 21
          Width = 137
          Height = 23
          HelpContext = 4360
          Caption = 'Clear Recent lists'
          OnClick = btnClearRecentClick
        end
        object Label18: TLabel
          Left = 16
          Top = 26
          Width = 146
          Height = 13
          HelpContext = 4370
          Caption = '&Maximum items on recent lists:'
          FocusControl = RecentItems
        end
        object RecentItems: TJvSpinEdit
          Left = 176
          Top = 22
          Width = 54
          Height = 21
          HelpContext = 4370
          MaxValue = 99.000000000000000000
          MinValue = 3.000000000000000000
          Value = 6.000000000000000000
          MaxLength = 2
          TabOrder = 0
        end
      end
      object AGroupBox6: TGroupBox
        Left = 10
        Top = 197
        Width = 438
        Height = 73
        Caption = 'Registered File Types'
        TabOrder = 2
        object Label14: TLabel
          Left = 16
          Top = 21
          Width = 35
          Height = 13
          HelpContext = 6610
          Caption = 'Status:'
        end
        object lblRegStatus: TLabel
          Left = 56
          Top = 21
          Width = 43
          Height = 13
          HelpContext = 6610
          Caption = 'Problems'
        end
        object btnRestoreReg: TSpeedButton
          Left = 288
          Top = 14
          Width = 137
          Height = 23
          HelpContext = 4380
          Caption = 'Restore associations'
          OnClick = btnRestoreRegClick
        end
        object btnSetReg: TSpeedButton
          Left = 288
          Top = 41
          Width = 137
          Height = 23
          HelpContext = 4390
          Caption = 'Associate again'
          OnClick = btnSetRegClick
        end
        object cbCheckAssociations: TCheckBox
          Left = 16
          Top = 40
          Width = 225
          Height = 17
          HelpContext = 4400
          Caption = 'Check automatically when &OptiPerl starts'
          TabOrder = 0
          OnClick = cbCheckAssociationsClick
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Environment II'
      object btnPerformance: TSpeedButton
        Left = 10
        Top = 248
        Width = 157
        Height = 23
        HelpContext = 7690
        Caption = 'Set performance options'
        OnClick = btnPerformanceClick
      end
      object btnAppData: TSpeedButton
        Left = 178
        Top = 248
        Width = 157
        Height = 23
        HelpContext = 7740
        Caption = 'Set Application Data folder'
        OnClick = btnAppDataClick
      end
      object GroupBox11: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 74
        Caption = 'Code co&mpletion'
        TabOrder = 0
        object CodeComEnable: TCheckBox
          Left = 16
          Top = 21
          Width = 145
          Height = 17
          HelpContext = 4470
          Caption = 'Enable c&ode completion'
          TabOrder = 0
        end
        object CodeComHints: TCheckBox
          Left = 245
          Top = 21
          Width = 110
          Height = 17
          HelpContext = 4480
          Caption = '&Enable hints'
          TabOrder = 2
        end
        object CodeComHTML: TCheckBox
          Left = 16
          Top = 45
          Width = 185
          Height = 17
          HelpContext = 7630
          Caption = 'Enable H&TML code completion'
          TabOrder = 1
        end
        object HintEditorFont: TCheckBox
          Left = 245
          Top = 45
          Width = 164
          Height = 17
          HelpContext = 7800
          Caption = '&Use editor font for hints'
          TabOrder = 3
        end
      end
      object GroupBox15: TGroupBox
        Left = 10
        Top = 87
        Width = 438
        Height = 45
        Caption = '&Layouts'
        TabOrder = 1
        object StandardLayouts: TCheckBox
          Left = 16
          Top = 19
          Width = 385
          Height = 17
          HelpContext = 6630
          Caption = 'Ena&ble standard layouts (edit, debug and run)'
          TabOrder = 0
        end
      end
      object GroupBox17: TGroupBox
        Left = 10
        Top = 186
        Width = 438
        Height = 54
        Caption = 'Code e&xplorer'
        TabOrder = 3
        object Label80: TLabel
          Left = 16
          Top = 25
          Width = 55
          Height = 13
          Caption = '&Font name:'
          FocusControl = CodeExplorerFontName
        end
        object Label81: TLabel
          Left = 307
          Top = 25
          Width = 47
          Height = 13
          Caption = 'Font s&ize:'
          FocusControl = CodeExplorerFontSize
        end
        object CodeExplorerFontSize: TJvSpinEdit
          Left = 370
          Top = 21
          Width = 54
          Height = 21
          HelpContext = 7290
          MaxValue = 32.000000000000000000
          MinValue = 3.000000000000000000
          Value = 6.000000000000000000
          MaxLength = 2
          TabOrder = 1
        end
        object CodeExplorerFontName: TJvFontComboBox
          Left = 80
          Top = 21
          Width = 177
          Height = 22
          HelpContext = 7280
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
          TabOrder = 0
        end
      end
      object GroupBox10: TGroupBox
        Left = 10
        Top = 137
        Width = 438
        Height = 45
        Caption = 'Code Libraria&n'
        TabOrder = 2
        object CodeLibPrompt: TCheckBox
          Left = 16
          Top = 19
          Width = 281
          Height = 17
          HelpContext = 7760
          Caption = '&Prompt before saving changes'
          TabOrder = 0
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Windows'
      object GroupBox14: TGroupBox
        Left = 10
        Top = 56
        Width = 438
        Height = 155
        Caption = 'Window Options'
        TabOrder = 1
        object Label28: TLabel
          Left = 16
          Top = 124
          Width = 110
          Height = 13
          Caption = 'Docked caption height:'
        end
        object DockInvertCtrl: TCheckBox
          Left = 16
          Top = 24
          Width = 361
          Height = 17
          HelpContext = 7960
          Caption = 'Allow docking windows with mouse only while Control is down'
          TabOrder = 0
        end
        object DockCapHeight: TJvSpinEdit
          Left = 136
          Top = 120
          Width = 65
          Height = 21
          HelpContext = 7920
          MaxValue = 24.000000000000000000
          MinValue = 14.000000000000000000
          Value = 14.000000000000000000
          TabOrder = 4
        end
        object DockShowButtons: TCheckBox
          Left = 16
          Top = 48
          Width = 217
          Height = 17
          HelpContext = 7950
          Caption = 'Show buttons in docked captions'
          TabOrder = 1
        end
        object DockShowTaskBar: TCheckBox
          Left = 16
          Top = 96
          Width = 289
          Height = 17
          HelpContext = 7930
          Caption = 'Show floating windows in task bar (requires restart)'
          TabOrder = 3
        end
        object DockContextMenu: TCheckBox
          Left = 16
          Top = 72
          Width = 417
          Height = 17
          HelpContext = 7940
          Caption = 
            'Right-clicking on tabs displays context menu (Control-right clic' +
            'k for window menu)'
          TabOrder = 2
        end
      end
      object DockingStyle: TRadioGroup
        Left = 10
        Top = 7
        Width = 438
        Height = 43
        HelpContext = 7910
        Caption = 'Docking Style'
        Columns = 3
        Items.Strings = (
          'Default'
          'Themed'
          'Gradient')
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Debugger'
      object gbDebugger: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 90
        Caption = 'De&bugger'
        TabOrder = 0
        object Label20: TLabel
          Left = 320
          Top = 24
          Width = 101
          Height = 13
          HelpContext = 4460
          Caption = '&Live evaluation delay'
          FocusControl = LiveEvalDelay
        end
        object CheckSyntax: TCheckBox
          Left = 16
          Top = 28
          Width = 217
          Height = 17
          HelpContext = 4430
          Caption = 'Ch&eck syntax before entering debugger'
          TabOrder = 0
        end
        object IncGutter: TCheckBox
          Left = 16
          Top = 48
          Width = 281
          Height = 17
          HelpContext = 4440
          Caption = '&Increase gutter width before entering debugger'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object LiveEvalDelay: TJvSpinEdit
          Left = 320
          Top = 40
          Width = 102
          Height = 21
          HelpContext = 4460
          Increment = 100.000000000000000000
          MaxValue = 9999.000000000000000000
          MinValue = 250.000000000000000000
          Value = 250.000000000000000000
          MaxLength = 4
          TabOrder = 2
        end
      end
      object GroupBox13: TGroupBox
        Left = 10
        Top = 104
        Width = 437
        Height = 89
        Caption = 'Remote debugger'
        TabOrder = 1
        object Label73: TLabel
          Left = 16
          Top = 23
          Width = 68
          Height = 13
          Caption = 'Li&sten at port:'
          FocusControl = RemDebPort
        end
        object Label45: TLabel
          Left = 14
          Top = 56
          Width = 181
          Height = 13
          Caption = 'Port for STDIN && STDOUT redirection:'
          FocusControl = InOutPort
        end
        object RemDebPort: TJvSpinEdit
          Left = 206
          Top = 20
          Width = 89
          Height = 21
          HelpContext = 6880
          TabOrder = 0
        end
        object InOutPort: TJvSpinEdit
          Left = 206
          Top = 53
          Width = 89
          Height = 21
          HelpContext = 4450
          TabOrder = 1
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Error Testing'
      object Warnings: TRadioGroup
        Left = 10
        Top = 7
        Width = 438
        Height = 66
        HelpContext = 4250
        Caption = 'Error &testing warning level'
        Columns = 2
        Items.Strings = (
          'No warnings'
          'Useful warnings'
          'All warnings')
        TabOrder = 0
      end
      object GroupBox12: TGroupBox
        Left = 10
        Top = 79
        Width = 438
        Height = 191
        Caption = 'Automatic syntax checking'
        TabOrder = 1
        object Label75: TLabel
          Left = 16
          Top = 45
          Width = 28
          Height = 13
          Caption = '&Lines:'
          FocusControl = SHErrorStyle
        end
        object Label76: TLabel
          Left = 235
          Top = 45
          Width = 29
          Height = 13
          Caption = 'C&olor:'
          FocusControl = SHErrorColor
        end
        object Label77: TLabel
          Left = 16
          Top = 99
          Width = 28
          Height = 13
          Caption = 'L&ines:'
          FocusControl = SHWarningStyle
        end
        object Label78: TLabel
          Left = 235
          Top = 99
          Width = 29
          Height = 13
          Caption = 'Colo&r:'
          FocusControl = SHWarningColor
        end
        object Label26: TLabel
          Left = 16
          Top = 160
          Width = 83
          Height = 13
          Caption = 'Disa&ble on paths:'
          FocusControl = SHPathDisable
        end
        object SHEditorErrors: TCheckBox
          Left = 16
          Top = 20
          Width = 145
          Height = 17
          HelpContext = 4270
          Caption = 'Highlight &errors in editor'
          TabOrder = 0
        end
        object SHExplorerErrors: TCheckBox
          Left = 16
          Top = 129
          Width = 185
          Height = 17
          HelpContext = 4280
          Caption = '&Show errors in code explorer'
          TabOrder = 6
        end
        object SHExplorerWarnings: TCheckBox
          Left = 235
          Top = 129
          Width = 177
          Height = 17
          HelpContext = 4290
          Caption = 'Show warnin&gs in code explorer'
          TabOrder = 7
        end
        object SHEditorWarnings: TCheckBox
          Left = 16
          Top = 74
          Width = 161
          Height = 17
          HelpContext = 6930
          Caption = 'Highlight war&nings in editor'
          TabOrder = 3
        end
        object SHWarningColor: THKColorBox
          Left = 287
          Top = 95
          Width = 135
          Height = 22
          HelpContext = 6950
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 5
        end
        object SHErrorColor: THKColorBox
          Left = 287
          Top = 41
          Width = 135
          Height = 22
          HelpContext = 6950
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 2
        end
        object SHErrorStyle: TLineStyleComboBox
          Left = 76
          Top = 41
          Width = 135
          HelpContext = 6940
          PenStyle = psSolid
          TabOrder = 1
        end
        object SHWarningStyle: TLineStyleComboBox
          Left = 76
          Top = 95
          Width = 135
          HelpContext = 6940
          PenStyle = psSolid
          TabOrder = 4
        end
        object SHPathDisable: TEdit
          Left = 107
          Top = 156
          Width = 315
          Height = 21
          HelpContext = 7790
          TabOrder = 8
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Running'
      object AGroupBox8: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 56
        Caption = '&Run with server'
        TabOrder = 0
        object Label3: TLabel
          Left = 16
          Top = 24
          Width = 48
          Height = 13
          Caption = 'H&ost URL:'
          FocusControl = Host
        end
        object Host: TEdit
          Left = 79
          Top = 20
          Width = 341
          Height = 21
          HelpContext = 4490
          TabOrder = 0
        end
      end
      object GroupBox16: TGroupBox
        Left = 10
        Top = 69
        Width = 438
        Height = 51
        Caption = 'R&emote script running'
        TabOrder = 1
        object RunRemHost: TCheckBox
          Left = 152
          Top = 20
          Width = 278
          Height = 17
          HelpContext = 7120
          Caption = 'Re&place the '#39'Host'#39' field in headers sent when running'
          TabOrder = 1
        end
        object RunRemUpload: TCheckBox
          Left = 16
          Top = 20
          Width = 129
          Height = 17
          HelpContext = 7110
          Caption = '&Upload automatically'
          TabOrder = 0
        end
      end
      object GroupBox5: TGroupBox
        Left = 10
        Top = 126
        Width = 438
        Height = 90
        Caption = '&Browsers'
        TabOrder = 2
        object Label19: TLabel
          Left = 17
          Top = 41
          Width = 128
          Height = 13
          Caption = '&Select secondary browser:'
          FocusControl = SecondBrowser
        end
        object BrowserFocus: TCheckBox
          Left = 16
          Top = 20
          Width = 249
          Height = 17
          HelpContext = 4420
          Caption = 'Br&ing up internal browser after running a file'
          TabOrder = 0
        end
        object SecondBrowser: TJvFilenameEdit
          Left = 16
          Top = 56
          Width = 406
          Height = 21
          HelpContext = 4410
          DefaultExt = 'exe'
          Filter = 'Executable (*.exe)|*.exe'
          FilterIndex = 0
          DialogOptions = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist]
          DialogTitle = 'Select external browser'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 1
        end
      end
      object GroupBox19: TGroupBox
        Left = 10
        Top = 223
        Width = 438
        Height = 47
        Caption = 'Remote Transfers'
        TabOrder = 3
        object Label43: TLabel
          Left = 206
          Top = 21
          Width = 158
          Height = 13
          HelpContext = 4370
          Caption = 'Session keep-alive interval (sec):'
          FocusControl = SessionKeepAliveInterval
        end
        object KeepSessionsAlive: TCheckBox
          Left = 16
          Top = 20
          Width = 174
          Height = 17
          HelpContext = 7970
          Caption = 'Keep transfer sessions open'
          TabOrder = 0
        end
        object SessionKeepAliveInterval: TJvSpinEdit
          Left = 371
          Top = 17
          Width = 50
          Height = 21
          HelpContext = 8060
          MaxValue = 999999.000000000000000000
          Value = 6.000000000000000000
          MaxLength = 6
          TabOrder = 1
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Internal Server'
      object grpInternalServer: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 263
        Caption = 'Internal &Server'
        TabOrder = 0
        object Label10: TLabel
          Left = 16
          Top = 28
          Width = 58
          Height = 13
          HelpContext = 4560
          Caption = '&Root folder:'
          FocusControl = RootDir
        end
        object btnRootDir: TSpeedButton
          Left = 401
          Top = 24
          Width = 22
          Height = 19
          HelpContext = 4560
          Flat = True
          Glyph.Data = {
            D6000000424DD60000000000000076000000280000000E0000000C0000000100
            0400000000006000000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00D0000000000D
            DD00D00777777770DD00D0F0777777770D00D0FF077777777000D0FFF0000000
            0000D0FFFFFFFF0DDD00D0FFF000000DDD00DD000DDDDDDDDD00DDDDDDDDDD00
            0D00DDDDDDDDDDD00D00DDDDDD0DDD0D0D00DDDDDDD000DDDD00}
          Spacing = 0
          OnClick = btnRootDirClick
        end
        object Label13: TLabel
          Left = 16
          Top = 54
          Width = 63
          Height = 13
          Caption = 'Ass&ociations:'
          FocusControl = AssocList
        end
        object btnAddAssoc: TSpeedButton
          Left = 284
          Top = 68
          Width = 67
          Height = 25
          HelpContext = 4520
          Caption = 'Add'
          OnClick = btnAddAssocClick
        end
        object btnRemoveAssoc: TSpeedButton
          Left = 284
          Top = 99
          Width = 67
          Height = 25
          HelpContext = 4530
          Caption = 'Remove'
          OnClick = btnRemoveAssocClick
        end
        object btnEdit: TSpeedButton
          Left = 355
          Top = 68
          Width = 67
          Height = 25
          HelpContext = 4540
          Caption = 'Edit'
          OnClick = btnEditClick
        end
        object btnDef: TSpeedButton
          Left = 355
          Top = 99
          Width = 67
          Height = 25
          HelpContext = 4550
          Caption = 'Set Default'
          OnClick = btnDefClick
        end
        object Label15: TLabel
          Left = 16
          Top = 133
          Width = 37
          Height = 13
          Caption = 'A&liases:'
          FocusControl = IntServerAliases
        end
        object PerlDBOptslbl: TLabel
          Left = 16
          Top = 213
          Width = 349
          Height = 13
          Caption = 
            'Whe&n the internal server runs a script, add this value for PERL' +
            'DB_OPTS:'
          FocusControl = PerlDBOpts
        end
        object Label44: TLabel
          Left = 16
          Top = 186
          Width = 24
          Height = 13
          Caption = 'Port:'
          FocusControl = IntServerAliases
        end
        object RootDir: TComboBox
          Left = 79
          Top = 24
          Width = 323
          Height = 21
          HelpContext = 4560
          ItemHeight = 13
          TabOrder = 0
          Text = 'RootDir'
        end
        object AssocList: TJvTextListBox
          Left = 16
          Top = 69
          Width = 262
          Height = 57
          HelpContext = 4570
          ItemHeight = 13
          Sorted = True
          TabOrder = 1
        end
        object IntServerAliases: TEdit
          Left = 16
          Top = 148
          Width = 406
          Height = 21
          HelpContext = 7430
          TabOrder = 2
        end
        object PerlDBOpts: TEdit
          Left = 16
          Top = 228
          Width = 406
          Height = 21
          HelpContext = 6620
          TabOrder = 4
        end
        object ServerPort: TJvSpinEdit
          Left = 47
          Top = 182
          Width = 79
          Height = 21
          HelpContext = 8250
          MaxValue = 65535.000000000000000000
          MinValue = 1.000000000000000000
          Value = 6.000000000000000000
          MaxLength = 5
          TabOrder = 3
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'External Server'
      object AGroupBox3: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 263
        Caption = 'External Server'
        TabOrder = 0
        object Label6: TLabel
          Left = 16
          Top = 144
          Width = 76
          Height = 13
          Caption = 'Acce&ss Log File:'
          FocusControl = AccessLogFile
        end
        object Label7: TLabel
          Left = 16
          Top = 172
          Width = 67
          Height = 13
          Caption = 'E&rror Log File:'
          FocusControl = ErrorLogFile
        end
        object Label16: TLabel
          Left = 16
          Top = 116
          Width = 78
          Height = 13
          Caption = 'D&ocument Root:'
          FocusControl = ExtServerRoot
        end
        object Label9: TLabel
          Left = 16
          Top = 209
          Width = 37
          Height = 13
          Caption = 'A&liases:'
          FocusControl = ExtServerAliases
        end
        object Label8: TLabel
          Left = 16
          Top = 72
          Width = 24
          Height = 13
          Caption = 'Port:'
          FocusControl = IntServerAliases
        end
        object AccessLogFile: TJvFilenameEdit
          Left = 104
          Top = 140
          Width = 319
          Height = 21
          HelpContext = 4580
          DefaultExt = 'log'
          Filter = 'Log Files (*.Log)|*.log|All Files (*.*)|*.*'
          FilterIndex = 0
          DialogOptions = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
          DialogTitle = 'Path to Log File'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 3
        end
        object ErrorLogFile: TJvFilenameEdit
          Left = 104
          Top = 168
          Width = 319
          Height = 21
          HelpContext = 4590
          DefaultExt = 'log'
          Filter = 'Log Files (*.Log)|*.log|All Files (*.*)|*.*'
          FilterIndex = 0
          DialogOptions = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
          DialogTitle = 'Path to Log File'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 4
        end
        object btnHttpConf: TButton
          Left = 16
          Top = 25
          Width = 145
          Height = 25
          HelpContext = 7450
          Caption = 'Get from httpd.conf file'
          TabOrder = 0
          OnClick = btnHttpConfClick
        end
        object ExtServerRoot: TJvDirectoryEdit
          Left = 104
          Top = 112
          Width = 319
          Height = 21
          HelpContext = 4620
          DialogKind = dkWin32
          DialogText = 'Select Folder:'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 2
        end
        object ExtServerAliases: TEdit
          Left = 16
          Top = 224
          Width = 406
          Height = 21
          HelpContext = 7460
          TabOrder = 5
        end
        object ExtServerPort: TJvSpinEdit
          Left = 47
          Top = 68
          Width = 79
          Height = 21
          HelpContext = 8260
          MaxValue = 65535.000000000000000000
          MinValue = 1.000000000000000000
          Value = 6.000000000000000000
          MaxLength = 5
          TabOrder = 1
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Printer'
      object OPrinterPanel: TDCFormPanel
        Left = 48
        Top = 40
        Width = 369
        Height = 185
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Backups'
      object GroupBox18: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 263
        Caption = 'Backups'
        TabOrder = 0
        object Label29: TLabel
          Left = 16
          Top = 46
          Width = 85
          Height = 13
          Caption = 'Filename scheme:'
        end
        object Label30: TLabel
          Left = 16
          Top = 134
          Width = 23
          Height = 52
          Caption = '%F'#13#10'%E'#13#10'%P  '#13#10'%Y'
        end
        object Label31: TLabel
          Left = 48
          Top = 134
          Width = 88
          Height = 52
          Caption = 'Filename (no ext.)'#13#10'Extension'#13#10'Project Filename'#13#10'Year (4-digits)'
        end
        object Label32: TLabel
          Left = 151
          Top = 134
          Width = 19
          Height = 52
          Caption = '%M'#13#10'%D'#13#10'%H'#13#10'%N'
        end
        object Label33: TLabel
          Left = 183
          Top = 134
          Width = 78
          Height = 52
          Caption = 
            'Month (2-digits)'#13#10'Day  (2-digits)'#13#10'Hour (2-digits)'#13#10'Minute (2-di' +
            'gits)'
        end
        object Bevel1: TBevel
          Left = 146
          Top = 134
          Width = 14
          Height = 52
          Shape = bsLeftLine
        end
        object Label34: TLabel
          Left = 16
          Top = 197
          Width = 99
          Height = 13
          Caption = 'Preview of open file:'
        end
        object Label36: TLabel
          Left = 16
          Top = 88
          Width = 177
          Height = 13
          Caption = 'Filename scheme for files in projects:'
        end
        object Bevel2: TBevel
          Left = 281
          Top = 134
          Width = 14
          Height = 52
          Shape = bsLeftLine
        end
        object Label37: TLabel
          Left = 286
          Top = 134
          Width = 17
          Height = 52
          Caption = '%S'#13#10'%J'#13#10'%0'#13#10'%9'
        end
        object Label38: TLabel
          Left = 318
          Top = 134
          Width = 84
          Height = 52
          Caption = 
            'Second (2-digits)'#13#10'Project Path'#13#10'Project Data 0 ...'#13#10'.. Project ' +
            'Data 9'
        end
        object BackupEnable: TCheckBox
          Left = 16
          Top = 21
          Width = 201
          Height = 17
          HelpContext = 8020
          Caption = 'Create backups when saving files'
          TabOrder = 0
          OnClick = BackupEnableClick
        end
        object BackupName: TEdit
          Left = 16
          Top = 61
          Width = 406
          Height = 21
          HelpContext = 8000
          TabOrder = 2
          OnChange = BackupNameChange
        end
        object BackupZip: TCheckBox
          Left = 235
          Top = 21
          Width = 166
          Height = 17
          HelpContext = 8010
          Caption = 'Enable zip compression'
          TabOrder = 1
          OnClick = BackupNameChange
        end
        object BakPreview: TMemo
          Left = 16
          Top = 211
          Width = 406
          Height = 39
          HelpContext = 7980
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 4
          WantReturns = False
        end
        object BackupPrjName: TEdit
          Tag = 1
          Left = 16
          Top = 103
          Width = 406
          Height = 21
          HelpContext = 7990
          TabOrder = 3
          OnChange = BackupNameChange
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Editor'
      object GroupBox1: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 128
        Caption = 'Editor &font, background && selection'
        TabOrder = 0
        object EditFontLbl: TLabel
          Left = 16
          Top = 25
          Width = 55
          Height = 13
          HelpContext = 4650
          Caption = '&Editor font:'
          FocusControl = FontName
        end
        object EditorColorLbl: TLabel
          Left = 17
          Top = 78
          Width = 117
          Height = 13
          Caption = 'Ed&itor background color:'
          FocusControl = EditorColor
        end
        object SizeLbl: TLabel
          Left = 267
          Top = 25
          Width = 23
          Height = 13
          HelpContext = 4660
          Caption = 'Si&ze:'
          FocusControl = FontSize
        end
        object Label24: TLabel
          Left = 158
          Top = 78
          Width = 73
          Height = 13
          Caption = 'Selec&tion color:'
          FocusControl = SelBackColor
        end
        object Label25: TLabel
          Left = 299
          Top = 78
          Width = 96
          Height = 13
          Caption = 'Selecti&on font color:'
          FocusControl = SelColor
        end
        object FontName: TJvFontComboBox
          Left = 75
          Top = 21
          Width = 174
          Height = 22
          HelpContext = 4650
          FontName = 'System'
          ItemIndex = 0
          UseImages = False
          Sorted = False
          TabOrder = 0
        end
        object FontSize: TJvSpinEdit
          Left = 299
          Top = 21
          Width = 93
          Height = 21
          HelpContext = 4660
          ButtonKind = bkStandard
          MaxValue = 32.000000000000000000
          MinValue = 3.000000000000000000
          Value = 6.000000000000000000
          MaxLength = 2
          TabOrder = 2
        end
        object UseMonoFont: TCheckBox
          Left = 75
          Top = 46
          Width = 182
          Height = 17
          HelpContext = 4670
          Caption = 'Fi&xed width fonts only'
          Checked = True
          State = cbChecked
          TabOrder = 1
          OnClick = UseMonoFontClick
        end
        object EditorColor: THKColorBox
          Left = 17
          Top = 92
          Width = 124
          Height = 22
          HelpContext = 4680
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 4
        end
        object FontAliased: TCheckBox
          Left = 299
          Top = 46
          Width = 101
          Height = 17
          HelpContext = 7730
          Caption = 'Font s&moothing'
          TabOrder = 3
        end
        object SelBackColor: THKColorBox
          Left = 158
          Top = 92
          Width = 124
          Height = 22
          HelpContext = 7770
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 5
        end
        object SelColor: THKColorBox
          Left = 299
          Top = 92
          Width = 124
          Height = 22
          HelpContext = 7780
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 6
        end
      end
      object GroupBox6: TGroupBox
        Left = 10
        Top = 141
        Width = 438
        Height = 53
        Caption = 'Brac&ket Highlighting'
        TabOrder = 1
        object DoBracketSearch: TCheckBox
          Left = 16
          Top = 20
          Width = 177
          Height = 21
          HelpContext = 4690
          Caption = 'Auto hi&ghlight brackets'
          TabOrder = 0
        end
        object DoBracketMouseSearch: TCheckBox
          Left = 235
          Top = 20
          Width = 181
          Height = 21
          HelpContext = 4700
          Caption = 'Highlight b&rackets with mouse'
          TabOrder = 1
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Code folding'
      object FoldGroup: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 89
        Caption = 'Code &folding options'
        TabOrder = 0
        object Label21: TLabel
          Left = 235
          Top = 23
          Width = 97
          Height = 13
          HelpContext = 4800
          Caption = 'Foldin&g gutter color:'
          FocusControl = FoldGutColor
        end
        object FoldEnable: TCheckBox
          Left = 16
          Top = 24
          Width = 153
          Height = 17
          HelpContext = 4750
          Caption = 'Code fo&lding enabled'
          TabOrder = 0
          OnClick = FoldEnableClick
        end
        object FoldGutColor: THKColorBox
          Left = 235
          Top = 39
          Width = 120
          Height = 22
          HelpContext = 4800
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 2
        end
        object FoldLastLine: TCheckBox
          Left = 16
          Top = 52
          Width = 153
          Height = 17
          HelpContext = 7710
          Caption = 'Fold la&st line'
          TabOrder = 1
          OnClick = FoldEnableClick
        end
      end
      object GroupBox3: TGroupBox
        Left = 10
        Top = 104
        Width = 438
        Height = 166
        Caption = 'Code folding &elements'
        TabOrder = 1
        object FoldBrackets: TCheckBox
          Left = 16
          Top = 24
          Width = 129
          Height = 17
          HelpContext = 4710
          Caption = '&Bracket folding'
          TabOrder = 0
          OnClick = FoldBracketsClick
        end
        object FoldParenthesis: TCheckBox
          Left = 16
          Top = 106
          Width = 129
          Height = 17
          HelpContext = 4720
          Caption = '&Parenthesis folding'
          TabOrder = 2
          OnClick = FoldParenthesisClick
        end
        object FoldHereDoc: TCheckBox
          Left = 235
          Top = 24
          Width = 158
          Height = 17
          HelpContext = 4730
          Caption = 'He&re document folding'
          TabOrder = 4
          OnClick = FoldHereDocClick
        end
        object FoldPod: TCheckBox
          Left = 235
          Top = 106
          Width = 129
          Height = 17
          HelpContext = 4740
          Caption = 'Pod fold&ing'
          TabOrder = 6
          OnClick = FoldPodClick
        end
        object FoldDefBrackets: TCheckBox
          Left = 16
          Top = 50
          Width = 153
          Height = 17
          HelpContext = 4760
          Caption = 'Fold brac&kets on open'
          TabOrder = 1
        end
        object FoldDefParenthesis: TCheckBox
          Left = 16
          Top = 132
          Width = 153
          Height = 17
          HelpContext = 4760
          Caption = 'Fold pare&nthesis on open'
          TabOrder = 3
        end
        object FoldDefHereDoc: TCheckBox
          Left = 235
          Top = 50
          Width = 193
          Height = 17
          HelpContext = 4760
          Caption = 'Fold here doc&uments on open'
          TabOrder = 5
        end
        object FoldDefPod: TCheckBox
          Left = 235
          Top = 132
          Width = 153
          Height = 17
          HelpContext = 4760
          Caption = 'F&old pod on open'
          TabOrder = 7
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Tabs and Lines'
      object GroupBox8: TGroupBox
        Left = 10
        Top = 189
        Width = 213
        Height = 81
        Caption = '&Lines'
        TabOrder = 1
        object BackUnindent: TCheckBox
          Left = 16
          Top = 46
          Width = 161
          Height = 17
          HelpContext = 4900
          Caption = 'Bac&kspace unindents'
          TabOrder = 1
        end
        object AutoIndent: TCheckBox
          Left = 16
          Top = 23
          Width = 145
          Height = 17
          HelpContext = 4890
          Caption = 'A&uto indent mode'
          TabOrder = 0
        end
      end
      object GroupBox9: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 175
        Caption = '&Tabs'
        TabOrder = 0
        object TabStopLbl: TLabel
          Left = 235
          Top = 23
          Width = 51
          Height = 13
          HelpContext = 4860
          Caption = 'Ta&b stops:'
          FocusControl = TabStopsEdit
        end
        object BlockIndentLbl: TLabel
          Left = 235
          Top = 70
          Width = 61
          Height = 13
          HelpContext = 5040
          Caption = '&Block indent:'
          FocusControl = BlockIndent
        end
        object Label64: TLabel
          Left = 16
          Top = 112
          Width = 29
          Height = 13
          HelpContext = 4840
          Caption = 'C&olor:'
          FocusControl = TabColor
        end
        object Label65: TLabel
          Left = 16
          Top = 141
          Width = 28
          Height = 13
          HelpContext = 4830
          Caption = '&Style:'
          FocusControl = TabStyle
        end
        object Label66: TLabel
          Left = 235
          Top = 112
          Width = 32
          Height = 13
          Caption = 'W&idth:'
          FocusControl = TabWidth
        end
        object SmartTab: TCheckBox
          Left = 16
          Top = 40
          Width = 209
          Height = 21
          HelpContext = 4850
          Caption = 'S&mart tab'
          TabOrder = 1
          OnClick = SmartTabClick
        end
        object TabStopsEdit: TEdit
          Left = 235
          Top = 38
          Width = 190
          Height = 21
          HelpContext = 4860
          TabOrder = 3
        end
        object TabCharacter: TCheckBox
          Left = 16
          Top = 20
          Width = 105
          Height = 21
          HelpContext = 4870
          Caption = '&Use tab character'
          TabOrder = 0
          OnClick = TabCharacterClick
        end
        object CursorOnTabs: TCheckBox
          Left = 16
          Top = 60
          Width = 193
          Height = 21
          HelpContext = 4880
          Caption = 'Cu&rsor always on tabs'
          TabOrder = 2
        end
        object BlockIndent: TJvSpinEdit
          Left = 313
          Top = 66
          Width = 57
          Height = 21
          HelpContext = 5040
          MaxValue = 20.000000000000000000
          MinValue = 1.000000000000000000
          Value = 1.000000000000000000
          MaxLength = 2
          TabOrder = 4
        end
        object TabVisible: TCheckBox
          Left = 16
          Top = 80
          Width = 145
          Height = 21
          HelpContext = 4810
          Caption = '&Visualize tabs'
          TabOrder = 5
        end
        object TabStyle: TLineStyleComboBox
          Left = 80
          Top = 139
          Width = 121
          HelpContext = 4830
          PenStyle = psSolid
          TabOrder = 6
        end
        object TabColor: THKColorBox
          Left = 80
          Top = 108
          Width = 120
          Height = 22
          HelpContext = 4840
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 7
        end
        object TabWidth: TLineWidthComboBox
          Left = 293
          Top = 107
          Width = 76
          MaxValue = 9
          TabOrder = 8
        end
      end
      object TrimWhiteSpace: TRadioGroup
        Left = 235
        Top = 189
        Width = 213
        Height = 81
        HelpContext = 8090
        Caption = 'Whitespace'
        Items.Strings = (
          'Never trim'
          'Trim only in non-empty lines'
          'Trim always')
        TabOrder = 2
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Behaviour'
      object EditOptGroup: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 263
        Caption = 'Editor behaviour:'
        TabOrder = 0
        object Label27: TLabel
          Left = 16
          Top = 233
          Width = 53
          Height = 13
          Caption = 'D&elimiters: '
          FocusControl = EditorDelimiters
        end
        object Label46: TLabel
          Left = 235
          Top = 233
          Width = 112
          Height = 13
          Caption = 'Navigational Delimiters:'
          FocusControl = NavDelimiters
        end
        object PersistentBlock: TCheckBox
          Left = 16
          Top = 172
          Width = 192
          Height = 22
          HelpContext = 4910
          Caption = '&Persistent blocks'
          TabOrder = 9
        end
        object OverwriteBlock: TCheckBox
          Left = 16
          Top = 191
          Width = 192
          Height = 22
          HelpContext = 4920
          Caption = '&Overwrite blocks'
          TabOrder = 10
        end
        object DblClickEdit: TCheckBox
          Left = 235
          Top = 20
          Width = 192
          Height = 22
          HelpContext = 4930
          Caption = 'Double cl&ick line'
          TabOrder = 11
        end
        object FindText: TCheckBox
          Left = 235
          Top = 39
          Width = 192
          Height = 22
          HelpContext = 4940
          Caption = '&Find text at cursor'
          TabOrder = 12
        end
        object OverCaret: TCheckBox
          Left = 235
          Top = 77
          Width = 192
          Height = 22
          HelpContext = 4950
          Caption = 'O&verwrite cursor as block'
          TabOrder = 14
        end
        object DisableDrag: TCheckBox
          Left = 235
          Top = 96
          Width = 192
          Height = 22
          HelpContext = 4960
          Caption = 'Disable d&ragging'
          TabOrder = 15
        end
        object ShowLineNum: TCheckBox
          Left = 16
          Top = 20
          Width = 200
          Height = 22
          HelpContext = 4970
          Caption = '&Show line numbers'
          TabOrder = 0
        end
        object ShowLineNumGut: TCheckBox
          Left = 16
          Top = 39
          Width = 200
          Height = 22
          HelpContext = 4980
          Caption = 'Show li&ne numbers on gutter'
          TabOrder = 1
        end
        object GroupUndo: TCheckBox
          Left = 16
          Top = 58
          Width = 200
          Height = 22
          HelpContext = 4990
          Caption = '&Group undo'
          TabOrder = 2
        end
        object CursorEof: TCheckBox
          Left = 16
          Top = 77
          Width = 200
          Height = 22
          HelpContext = 5000
          Caption = 'Cursor be&yond EOF'
          TabOrder = 3
        end
        object BeyondEol: TCheckBox
          Left = 16
          Top = 96
          Width = 200
          Height = 22
          HelpContext = 5010
          Caption = 'Cursor beyond EOL'
          TabOrder = 4
        end
        object SelectEol: TCheckBox
          Left = 16
          Top = 115
          Width = 200
          Height = 22
          HelpContext = 5020
          Caption = 'Selec&tion beyond EOL'
          TabOrder = 5
        end
        object WordWrap: TCheckBox
          Left = 16
          Top = 153
          Width = 192
          Height = 22
          HelpContext = 5030
          Caption = 'Word wrap'
          TabOrder = 7
        end
        object ShowSpecialSymbols: TCheckBox
          Left = 235
          Top = 58
          Width = 136
          Height = 22
          HelpContext = 5050
          Caption = 'Show special sy&mbols'
          TabOrder = 13
        end
        object EnableHHHEEE: TCheckBox
          Left = 16
          Top = 134
          Width = 176
          Height = 22
          HelpContext = 5060
          Caption = 'Enable triple Home && End keys'
          TabOrder = 6
        end
        object HighLightURL: TCheckBox
          Left = 235
          Top = 115
          Width = 176
          Height = 22
          HelpContext = 7600
          Caption = 'Highlight URL'#39's'
          TabOrder = 16
        end
        object DispFullExtension: TCheckBox
          Left = 235
          Top = 134
          Width = 182
          Height = 22
          HelpContext = 7700
          Caption = 'Display full file e&xtensions in tabs'
          TabOrder = 17
        end
        object EditorDelimiters: TEdit
          Left = 73
          Top = 230
          Width = 130
          Height = 22
          HelpContext = 7830
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          TabOrder = 8
        end
        object CloseTabDoubleClick: TCheckBox
          Left = 235
          Top = 153
          Width = 185
          Height = 22
          HelpContext = 7850
          Caption = 'Close file with double-click'
          TabOrder = 18
        end
        object MultiLineTabs: TCheckBox
          Left = 235
          Top = 172
          Width = 192
          Height = 22
          HelpContext = 8050
          Caption = 'Multiline tabs'
          TabOrder = 19
        end
        object NavDelimiters: TEdit
          Left = 360
          Top = 230
          Width = 62
          Height = 22
          HelpContext = 8290
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Style = []
          ParentFont = False
          TabOrder = 20
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Visual'
      object OVisualPanel: TDCFormPanel
        Left = 40
        Top = 56
        Width = 329
        Height = 161
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Defaults'
      object AGroupBox4: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 112
        Caption = 'Default for new &Scripts'
        TabOrder = 0
        object Label4: TLabel
          Left = 8
          Top = 24
          Width = 102
          Height = 13
          Caption = 'D&efault Script Folder:'
          FocusControl = DefaultScriptFolder
        end
        object Label22: TLabel
          Left = 8
          Top = 56
          Width = 86
          Height = 13
          Caption = 'Defau&lt Template:'
          FocusControl = DefaultScript
        end
        object DefaultScriptFolder: TJvDirectoryEdit
          Left = 120
          Top = 21
          Width = 310
          Height = 21
          HelpContext = 5270
          DialogKind = dkWin32
          DialogText = 'Select Folder:'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 0
        end
        object DefaultScript: TJvFilenameEdit
          Left = 120
          Top = 52
          Width = 310
          Height = 21
          HelpContext = 5280
          Filter = 
            'Perl Scripts (*.cgi;*.pl;*.pm;*.plx)|*.cgi;*.pl;*.pm;*.plx|HTML ' +
            'Documents (*.htm; *.html;*.shtml)|*.htm;*.html;*.shtml|All Files' +
            ' (*.*)|*.*'
          FilterIndex = 0
          DialogOptions = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 1
        end
        object StartupLastOpen: TCheckBox
          Left = 8
          Top = 83
          Width = 217
          Height = 17
          HelpContext = 4640
          Caption = 'Startup editor with last open files'
          TabOrder = 2
        end
      end
      object AGroupBox5: TGroupBox
        Left = 10
        Top = 127
        Width = 438
        Height = 88
        Caption = 'Default for new H&tml files'
        TabOrder = 1
        object Label5: TLabel
          Left = 8
          Top = 24
          Width = 96
          Height = 13
          Caption = 'Default Ht&ml Folder:'
          FocusControl = DefaultHtmlFolder
        end
        object Label23: TLabel
          Left = 8
          Top = 56
          Width = 86
          Height = 13
          Caption = 'Default Tem&plate:'
          FocusControl = DefaultHtml
        end
        object DefaultHtmlFolder: TJvDirectoryEdit
          Left = 120
          Top = 21
          Width = 310
          Height = 21
          HelpContext = 5290
          DialogKind = dkWin32
          DialogText = 'Select Folder:'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 0
        end
        object DefaultHtml: TJvFilenameEdit
          Left = 120
          Top = 52
          Width = 310
          Height = 21
          HelpContext = 5300
          Filter = 
            'Perl Scripts (*.cgi;*.pl;*.pm;*.plx)|*.cgi;*.pl;*.pm;*.plx|HTML ' +
            'Documents (*.htm; *.html;*.shtml)|*.htm;*.html;*.shtml|All Files' +
            ' (*.*)|*.*'
          DialogOptions = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 1
        end
      end
      object DefaultLineEnd: TRadioGroup
        Left = 10
        Top = 223
        Width = 438
        Height = 47
        HelpContext = 5310
        Caption = 'Default line ending &format'
        Columns = 3
        Items.Strings = (
          'Windows (CRLF)'
          'Unix (LF)'
          'Mac (LFCR)')
        TabOrder = 2
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Syntax Coding'
      object btnEditStyle: TSpeedButton
        Left = 11
        Top = 217
        Width = 105
        Height = 23
        HelpContext = 5430
        Caption = 'Edit style'
        OnClick = btnEditStyleClick
      end
      object btnResetStyles: TSpeedButton
        Left = 11
        Top = 247
        Width = 105
        Height = 23
        HelpContext = 5440
        Caption = 'Reset all styles'
        OnClick = btnResetStylesClick
      end
      object btnSynPreviewFile: TSpeedButton
        Left = 283
        Top = 247
        Width = 164
        Height = 23
        HelpContext = 7610
        Caption = 'Open preview file in editor'
        OnClick = btnSynPreviewFileClick
      end
      object GroupBox7: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 84
        Caption = '&Syntax Coding'
        TabOrder = 0
        object SyntaxHighlight: TCheckBox
          Left = 16
          Top = 20
          Width = 137
          Height = 21
          HelpContext = 5450
          Caption = '&Use syntax coding'
          TabOrder = 0
        end
        object SCDecIdent: TCheckBox
          Left = 16
          Top = 51
          Width = 182
          Height = 21
          HelpContext = 7590
          Caption = 'Co&lor code declared identifiers'
          TabOrder = 1
        end
        object SCVarDiff: TCheckBox
          Left = 235
          Top = 51
          Width = 182
          Height = 21
          HelpContext = 7840
          Caption = '&Variable differentiation in strings'
          TabOrder = 2
        end
      end
      object ActiveTextStyle: TRadioGroup
        Left = 10
        Top = 104
        Width = 438
        Height = 101
        HelpContext = 5460
        Caption = 'Active &text style'
        Columns = 2
        Items.Strings = (
          '0'
          '1'
          '2'
          '3'
          '4')
        TabOrder = 1
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Tem'
      object AGroupBox9: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 263
        Caption = 'Text style'
        TabOrder = 0
        object ElementLbl: TLabel
          Left = 16
          Top = 71
          Width = 42
          Height = 13
          Caption = '&Element:'
          FocusControl = Elements
        end
        object ForeColorLbl: TLabel
          Left = 187
          Top = 72
          Width = 52
          Height = 13
          Caption = '&Text color:'
          FocusControl = ForeColor
        end
        object Label63: TLabel
          Left = 16
          Top = 21
          Width = 81
          Height = 13
          Caption = 'Te&xt style name:'
          FocusControl = edStyleName
        end
        object btnCopyThis: TSpeedButton
          Left = 245
          Top = 36
          Width = 109
          Height = 23
          HelpContext = 5480
          Caption = 'Copy from first style'
          OnClick = btnCopyThisClick
        end
        object btnApplyStyle: TSpeedButton
          Left = 360
          Top = 36
          Width = 64
          Height = 23
          HelpContext = 5490
          Caption = 'Apply'
          OnClick = btnApplyStyleClick
        end
        object btnSuggest: TSpeedButton
          Left = 342
          Top = 86
          Width = 82
          Height = 23
          Caption = 'Suggest color'
          OnClick = btnSuggestClick
        end
        object BoldChk: TCheckBox
          Left = 187
          Top = 183
          Width = 54
          Height = 21
          Caption = '&Bold'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = BoldChkClick
        end
        object ItalicChk: TCheckBox
          Left = 187
          Top = 207
          Width = 70
          Height = 21
          Caption = '&Italic'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 4
          OnClick = ItalicChkClick
        end
        object UnderLineChk: TCheckBox
          Left = 187
          Top = 231
          Width = 78
          Height = 21
          Caption = '&Underline'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 5
          OnClick = UnderLineChkClick
        end
        object Elements: TListBox
          Left = 16
          Top = 87
          Width = 153
          Height = 162
          HelpContext = 5530
          ItemHeight = 13
          Items.Strings = (
            'Whitespace'
            'String'
            'Comment'
            'Identifier'
            'Integer'
            'Float'
            'Reserved Words'
            'Delimiters'
            'Defines'
            'RegExp Pattern'
            'Html Tags'
            'Html Params'
            'Breakpoint'
            'Error Line'
            'Debugger'
            'Search Result'
            'Bracket Match'
            'Script Whitespace'
            'Script Number'
            'Script Comment'
            'Script String'
            'Script ResWord'
            'Script Delimiters'
            'Emphasis'
            'System Variable'
            'Assembler'
            'RegExp Replacement'
            'Perl Declared Identifier'
            'Perl Internal Functions'
            'Pod'
            'Pod Tags'
            'Perl Variables'
            'URL')
          TabOrder = 7
          OnClick = ElementsClick
        end
        object cbFontBack: TCheckBox
          Left = 187
          Top = 126
          Width = 110
          Height = 17
          HelpContext = 5540
          Caption = 'Bac&kground color:'
          TabOrder = 1
          OnClick = cbFontBackClick
        end
        object edStyleName: TEdit
          Left = 16
          Top = 37
          Width = 121
          Height = 21
          HelpContext = 5550
          MaxLength = 50
          TabOrder = 6
          OnChange = edStyleNameChange
        end
        object ForeColor: THKColorBox
          Left = 187
          Top = 87
          Width = 134
          Height = 22
          HelpContext = 5560
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 0
          OnChange = ForeColorChange
        end
        object BackColor: THKColorBox
          Left = 187
          Top = 144
          Width = 134
          Height = 22
          HelpContext = 5570
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 2
          OnChange = BackColorChange
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Level coding'
      object GroupBox4: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 57
        Caption = '&Line coding'
        TabOrder = 0
        object btnPreviewBox: TSpeedButton
          Left = 258
          Top = 20
          Width = 164
          Height = 23
          HelpContext = 7610
          Caption = 'Open preview file in editor'
          OnClick = btnPreviewBoxClick
        end
        object LineEnable: TCheckBox
          Left = 16
          Top = 23
          Width = 153
          Height = 17
          HelpContext = 5580
          Caption = '&Enable bracket line coding'
          TabOrder = 0
        end
      end
      object BoxGroup: TGroupBox
        Left = 10
        Top = 72
        Width = 438
        Height = 198
        Caption = '&Box coding'
        TabOrder = 1
        object btnBrackets: TSpeedButton
          Left = 16
          Top = 74
          Width = 80
          Height = 21
          Caption = 'More options'
          OnClick = btnBracketsParClick
        end
        object btnParen: TSpeedButton
          Left = 240
          Top = 74
          Width = 80
          Height = 21
          Caption = 'More options'
          OnClick = btnBracketsParClick
        end
        object Label39: TLabel
          Left = 16
          Top = 141
          Width = 29
          Height = 13
          Caption = 'Color:'
          FocusControl = BoxHereDocColor
        end
        object Label40: TLabel
          Left = 16
          Top = 168
          Width = 28
          Height = 13
          Caption = '&Style:'
          FocusControl = BoxHereDocBrush
        end
        object Label41: TLabel
          Left = 240
          Top = 141
          Width = 29
          Height = 13
          Caption = 'Color:'
          FocusControl = BoxPodColor
        end
        object Label42: TLabel
          Left = 240
          Top = 168
          Width = 28
          Height = 13
          Caption = 'S&tyle:'
          FocusControl = BoxPodBrush
        end
        object BoxEnable: TCheckBox
          Left = 16
          Top = 20
          Width = 233
          Height = 17
          HelpContext = 5610
          Caption = 'E&nable box coding'
          TabOrder = 0
          OnClick = BoxEnableClick
        end
        object BoxBrackets: TCheckBox
          Left = 16
          Top = 53
          Width = 185
          Height = 17
          HelpContext = 5620
          Caption = 'Color brac&kets'
          TabOrder = 1
        end
        object BoxParen: TCheckBox
          Left = 240
          Top = 53
          Width = 153
          Height = 17
          HelpContext = 5630
          Caption = 'Color &parenthesis'
          TabOrder = 2
        end
        object BoxPod: TCheckBox
          Left = 240
          Top = 116
          Width = 169
          Height = 17
          HelpContext = 5640
          Caption = 'Color pod'
          TabOrder = 6
        end
        object BoxHereDoc: TCheckBox
          Left = 16
          Top = 116
          Width = 201
          Height = 17
          HelpContext = 5650
          Caption = 'Color here doc&uments'
          TabOrder = 3
        end
        object BoxHereDocBrush: TFillStyleComboBox
          Left = 56
          Top = 164
          Width = 121
          HelpContext = 5670
          TabOrder = 5
        end
        object BoxPodBrush: TFillStyleComboBox
          Left = 288
          Top = 164
          Width = 121
          HelpContext = 5670
          TabOrder = 8
        end
        object BoxHereDocColor: THKColorBox
          Left = 56
          Top = 137
          Width = 121
          Height = 22
          HelpContext = 5690
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 4
        end
        object BoxPodColor: THKColorBox
          Left = 288
          Top = 137
          Width = 121
          Height = 22
          HelpContext = 5690
          ColorDialog = ColorDialog
          ItemHeight = 16
          TabOrder = 7
        end
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Lines'
      object OLinePanel: TDCFormPanel
        Left = 48
        Top = 32
        Width = 361
        Height = 202
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Bracket Boxing'
      object OBoxBrPanel: TDCFormPanel
        Left = 64
        Top = 48
        Width = 313
        Height = 161
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Parenthesis Boxing'
      object OBoxParPanel: TDCFormPanel
        Left = 48
        Top = 56
        Width = 265
        Height = 145
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
    object TPage
      Left = 0
      Top = 0
      Caption = 'Multi user settings'
      object GroupBox2: TGroupBox
        Left = 10
        Top = 7
        Width = 438
        Height = 121
        Caption = 'Co&mmon folders'
        TabOrder = 0
        object Label11: TLabel
          Left = 16
          Top = 20
          Width = 84
          Height = 13
          Caption = '&Templates folder:'
          FocusControl = TemplateFolder
        end
        object Label17: TLabel
          Left = 16
          Top = 68
          Width = 76
          Height = 13
          Caption = 'C&ommon folder:'
          FocusControl = CommonFolder
        end
        object TemplateFolder: TJvDirectoryEdit
          Left = 16
          Top = 35
          Width = 406
          Height = 21
          HelpContext = 7470
          DialogKind = dkWin32
          DialogText = 'Select Folder:'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 0
        end
        object CommonFolder: TJvDirectoryEdit
          Left = 16
          Top = 83
          Width = 406
          Height = 21
          HelpContext = 7480
          DialogKind = dkWin32
          DialogText = 'Select Folder:'
          ButtonFlat = True
          NumGlyphs = 1
          TabOrder = 1
        end
      end
    end
  end
  object FormStorage: TJvFormStorage
    Options = [fpPosition]
    StoredProps.Strings = (
      'ColorDialog.CustomColors'
      'Status.Caption')
    StoredValues = <>
    Left = 76
    Top = 104
  end
  object ColorDialog: TColorDialog
    Options = [cdFullOpen, cdSolidColor, cdAnyColor]
    Left = 72
    Top = 168
  end
  object WhatsThis: TWhatsThis
    Active = True
    F1Action = goContext
    Options = [wtMenuRightClick, wtInheritFormContext, wtUseTag]
    PopupCaption = 'What'#39's this?'
    PopupHelpContext = 0
    WTToolbarButton = btnWT
    Left = 32
    Top = 72
  end
  object OpenDialog: TOpenDialog
    Left = 72
    Top = 240
  end
end
