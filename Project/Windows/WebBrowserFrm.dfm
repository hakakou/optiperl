object WebBrowserForm: TWebBrowserForm
  Tag = 4
  Left = 619
  Top = 317
  HelpContext = 450
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Web Browser'
  ClientHeight = 330
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnEndDock = FormEndDock
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: THKPageControl
    Left = 0
    Top = 0
    Width = 331
    Height = 256
    ActivePage = InfoSheet
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    MultiLine = True
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = PageControlChange
    OnMouseUp = PageControlMouseUp
    BorderStyle = bsNone
    object TextSheet: TTabSheet
      Caption = 'Text'
      object memOutput: TDCMemo
        Left = 0
        Top = 0
        Width = 329
        Height = 232
        Cursor = crIBeam
        PrintOptions = [poShowProgress]
        LineNumColor = clBlack
        LineNumAlign = taRightJustify
        StringsOptions = [soBackUnindents, soGroupUndo, soForceCutCopy, soAutoIndent, soFindTextAtCursor, soOverwriteBlocks, soUseTabCharacter, soCursorOnTabs]
        TabStops = '4'
        KeyMapping = 'Default'
        SelColor = clWhite
        SelBackColor = clNavy
        MatchBackColor = clBlack
        GutterBackColor = clWindow
        ScrollBars = ssBoth
        Options = [moThumbTracking, moColorSyntax, moLineNumbersOnGutter]
        GutterBrush.Color = clBtnFace
        MarginPen.Color = clGrayText
        BkgndOption = boEmpty
        MemoBackground.BkgndOption = boEmpty
        MemoBackground.GradientBeginColor = clWindow
        LineSeparator.Options = []
        LineSeparator.Pen.Color = clGrayText
        LineHighlight.Visible = False
        LineHighlight.Shape = shDoubleLine
        SpecialSymbols.TabChar = '+'
        SpecialSymbols.EOLStringBinary = {01000000B6}
        SpecialSymbols.EOFStringBinary = {010000005F}
        UseDefaultMenu = False
        ReadOnly = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Style = []
        TextStyles = <
          item
            Name = 'Whitespace'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'String'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Comment'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = [fsItalic]
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Identifier'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Integer'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Float'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Reserved words'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = [fsBold]
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Delimiters'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Defines'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Assembler'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Html tags'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Html params'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Url'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = [fsUnderline]
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'BreakPoint'
            Color = clRed
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindow
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = False
            UseMemoFont = False
          end
          item
            Name = 'Error line'
            Color = clMaroon
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindow
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = False
            UseMemoFont = False
          end
          item
            Name = 'Marked Block'
            Color = clNavy
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWhite
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcSelection
            UseMemoColor = False
            UseMemoFont = False
          end
          item
            Name = 'Search Match'
            Color = clBlack
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clLime
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcSearchMatch
            UseMemoColor = False
            UseMemoFont = False
          end
          item
            Name = 'Emphasis'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = [fsBold]
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'System Variable'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Script Whitespace'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clTeal
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Script Delimiters'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Script Comment'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = [fsItalic]
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Script String'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Script Number'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end
          item
            Name = 'Script ResWord'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = [fsBold]
            UpdateMemoColors = mcNone
            UseMemoColor = True
            UseMemoFont = False
          end>
        PrinterFont.Charset = DEFAULT_CHARSET
        PrinterFont.Color = clBlack
        PrinterFont.Height = -13
        PrinterFont.Name = 'Courier New'
        PrinterFont.Style = []
        TemplateFont.Charset = DEFAULT_CHARSET
        TemplateFont.Color = clWindowText
        TemplateFont.Height = -11
        TemplateFont.Name = 'MS Sans Serif'
        TemplateFont.Style = []
        UsePrinterFont = False
        BlockIndent = 1
        SpacesInTab = 3
        Align = alClient
        PopupMenu = PopupMenu
        UseDockManager = False
        TabOrder = 0
        TabStop = True
        CodeTemplates = <>
        TemplatesType = 'None'
        HideCaret = False
        UseGlobalOptions = False
      end
    end
    object WebSheet: TTabSheet
      Caption = 'HTML'
      ImageIndex = 1
      OnResize = WebSheetResize
    end
    object InfoSheet: TTabSheet
      Caption = 'Information'
      ImageIndex = 2
      object VST: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 329
        Height = 232
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Options = [hoColumnResize, hoShowSortGlyphs, hoVisible]
        Header.Style = hsXPStyle
        HintAnimation = hatNone
        HintMode = hmHint
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toDisableAutoscrollOnFocus]
        TreeOptions.MiscOptions = [toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toShowButtons, toShowHorzGridLines, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        OnFreeNode = VSTFreeNode
        OnGetText = VSTGetText
        OnGetHint = VSTGetHint
        Columns = <
          item
            Position = 0
            Width = 126
            WideText = 'Property'
          end
          item
            Position = 1
            Width = 284
            WideText = 'Value'
          end>
      end
    end
    object TalkSheet: TTabSheet
      Caption = 'Server Talk'
      ImageIndex = 4
      OnResize = TalkSheetResize
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 310
    Width = 331
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Panels = <>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = True
    SizeGrip = False
    UseSystemFont = False
  end
  object BarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Bars = <
      item
        Caption = 'Main menu'
        DockedDockingStyle = dsBottom
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsBottom
        FloatLeft = 308
        FloatTop = 502
        FloatClientWidth = 232
        FloatClientHeight = 50
        IsMainMenu = True
        ItemLinks = <
          item
            Item = edSend
            Visible = True
          end
          item
            Item = btnSend
            Visible = True
          end
          item
            BeginGroup = True
            Item = cbFilter
            Visible = True
          end
          item
            Item = edThreads
            Visible = True
          end
          item
            Item = btnClear
            Visible = True
          end>
        MultiLine = True
        Name = 'Main menu'
        OneOnRow = True
        Row = 0
        ShowMark = False
        UseOwnFont = False
        Visible = True
        WholeRow = True
      end>
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 233
    Top = 192
    DockControlHeights = (
      0
      0
      0
      54)
    object ServerGroup: TdxBarGroup
      Items = (
        'btnClear'
        'cbFilter'
        'edThreads')
    end
    object edSend: TdxBarEdit
      Caption = 'Send'
      Category = 0
      Hint = 'Text to send to script'
      Visible = ivAlways
      OnCurChange = edSendCurChange
      OnKeyDown = edSendKeyDown
      OnKeyUp = edSendKeyUp
      Width = 200
    end
    object btnSend: TdxBarButton
      Caption = 'Send'
      Category = 0
      Hint = 'Send'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = btnSendClick
    end
    object btnClear: TdxBarButton
      Caption = 'Clear'
      Category = 0
      Hint = 'Clear text in windows'
      Visible = ivAlways
      OnClick = btnClearClick
    end
    object cbFilter: TdxBarCombo
      Caption = 'URL Filter'
      Category = 0
      Hint = 
        'View only client requests and server responses that were produce' +
        'd from selected files'
      Visible = ivAlways
      Text = '*.*'
      OnChange = cbFilterChange
      ShowCaption = True
      Width = 100
      Items.Strings = (
        '*.*'
        '*.cgi;*.pl;*.plx'
        '*.html;*.htm;*.shtml')
      ItemIndex = 0
    end
    object edThreads: TdxBarSpinEdit
      Caption = 'Threads'
      Category = 0
      Hint = 
        'How many windows to open. Increase number if you are getting cor' +
        'rupted results.'
      Visible = ivAlways
      OnCurChange = edThreadsChange
      MaxLength = 1
      ShowCaption = True
      Width = 40
      MaxValue = 6.000000000000000000
      MinValue = 1.000000000000000000
      Value = 1.000000000000000000
    end
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 36
    Top = 75
    object WrapLinesItems: TMenuItem
      Caption = '&Wrap Lines'
      Checked = True
      OnClick = WrapLinesItemsClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object CopySelected1: TMenuItem
      Caption = 'C&opy Selected'
      OnClick = CopySelected1Click
    end
    object Copyall1: TMenuItem
      Caption = 'Co&py all'
      OnClick = Copyall1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object IncreaseFontSizeItem: TMenuItem
      Caption = '&Increase Font Size'
      OnClick = IncreaseFontSizeItemClick
    end
    object DecreaseFontSizeItem: TMenuItem
      Caption = '&Decrease Font Size'
      OnClick = DecreaseFontSizeItemClick
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 750
    OnTimer = TimerTimer
    Left = 100
    Top = 59
  end
  object FlashTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = FlashTimerTimer
    Left = 60
    Top = 211
  end
  object cxKeyPlus: TcxKeyPlus
    Enabled = False
    OnBrowserBackward = cxKeyPlusBrowserBackward
    OnBrowserForward = cxKeyPlusBrowserForward
    OnBrowserRefresh = cxKeyPlusBrowserRefresh
    OnBrowserStop = cxKeyPlusBrowserStop
    OnBrowserSearch = cxKeyPlusBrowserSearch
    OnBrowserHome = cxKeyPlusBrowserHome
    Left = 84
    Top = 147
  end
  object FormStorage: TJvFormStorage
    Active = False
    Options = []
    StoredProps.Strings = (
      'PageControl.ActivePage'
      'cbFilter.Items'
      'edThreads.Text')
    StoredValues = <>
    Left = 152
    Top = 184
  end
  object GUI: TGUI2Console
    AppType = at32bit
    AutoTerminate = False
    PipeSize = ps128k
    BufferSize = bs1k
    TimeOutDelay = 50
    Priority = tpNormal
    SendNillLines = True
    OnStart = GUIStart
    OnDone = GUIDone
    OnLine = GUILine
    OnTimeOut = GUITimeOut
    OnPrompt = GUIPrompt
    Left = 208
    Top = 48
  end
end
