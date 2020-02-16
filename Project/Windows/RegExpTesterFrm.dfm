object RegExpTesterForm: TRegExpTesterForm
  Left = 300
  Top = 229
  HelpContext = 680
  Anchors = [akLeft, akBottom]
  BorderStyle = bsDialog
  Caption = 'Regular Expression Tester'
  ClientHeight = 378
  ClientWidth = 683
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 0
    Top = 281
    Width = 683
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    AutoSnap = False
    MinSize = 25
    ResizeStyle = rsUpdate
    OnMoved = SplitterMoved
  end
  object TopPanel: TPanel
    Left = 0
    Top = 26
    Width = 683
    Height = 255
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnResize = TopPanelResize
    DesignSize = (
      683
      255)
    object btnAdd: TSpeedButton
      Left = 643
      Top = 1
      Width = 21
      Height = 21
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000004200001F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000004200001F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C0000000000000000004200000000000000001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C0000004200420042004200420042004200001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C0000000000000000004200000000000000001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000004200001F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000004200001F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      OnClick = btnAddClick
    end
    object btnRemove: TSpeedButton
      Left = 664
      Top = 1
      Width = 19
      Height = 21
      Anchors = [akTop, akRight]
      Flat = True
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C0000000000000000000000000000000000001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C0000004200420042004200420042004200001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C0000000000000000000000000000000000001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
      OnClick = btnRemoveClick
    end
    object edRegExp: TComboBox
      Left = 1
      Top = 0
      Width = 643
      Height = 23
      AutoComplete = False
      Anchors = [akLeft, akTop, akRight]
      DropDownCount = 12
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      TabOrder = 0
      Text = '/(\S+)@(\S+)\.(\S+)/'
      OnChange = edRegExpChange
      OnKeyDown = edRegExpKeyDown
    end
    object gbInput: TGroupBox
      Left = 5
      Top = 24
      Width = 244
      Height = 228
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'I&nput'
      TabOrder = 1
      DesignSize = (
        244
        228)
      object memInput: TDCMemo
        Left = 7
        Top = 18
        Width = 230
        Height = 203
        Cursor = crIBeam
        OnMemoViewChange = memInputMemoViewChange
        PrintOptions = [poShowProgress]
        WantTabs = True
        LineNumColor = clBlack
        LineNumAlign = taRightJustify
        StringsOptions = [soBackUnindents, soGroupUndo, soForceCutCopy, soFindTextAtCursor, soOverwriteBlocks, soUseTabCharacter]
        TabStops = '2,3'
        KeyMapping = 'Default'
        SelColor = clWhite
        SelBackColor = clNavy
        MatchBackColor = clBlack
        GutterBackColor = clWindow
        ScrollBars = ssBoth
        Options = [moDrawGutter, moThumbTracking, moColorSyntax, moLineNumbers, moSelectOnlyText, moLineNumbersOnGutter, moTripleClick, moLimitLineNumbers]
        GutterBrush.Color = clBtnFace
        MarginPen.Color = clGrayText
        GutterWidth = 10
        BlockOption = bkStreamSel
        WordWrap = True
        BkgndOption = boNone
        LineSeparator.Options = []
        LineSeparator.Pen.Color = clGrayText
        LineHighlight.Brush.Color = clGreen
        LineHighlight.Brush.Style = bsCross
        LineHighlight.Visible = False
        LineHighlight.Shape = shDoubleLine
        SpecialSymbols.TabChar = '|'
        SpecialSymbols.EOLStringBinary = {01000000B6}
        SpecialSymbols.EOFStringBinary = {010000005F}
        UseDefaultMenu = True
        ReadOnly = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        TextStyles = <
          item
            Name = 'Whitespace'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlack
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
            Font.Height = -11
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
        SpacesInTab = 1
        Anchors = [akLeft, akTop, akRight, akBottom]
        UseDockManager = False
        TabOrder = 0
        TabStop = True
        OnChange = memInputChange
        CodeTemplates = <>
        TemplatesType = 'None'
        HideCaret = False
        UseGlobalOptions = False
      end
    end
    object gbOutput: TGroupBox
      Left = 255
      Top = 24
      Width = 244
      Height = 228
      Anchors = [akLeft, akTop, akBottom]
      Caption = 'Ou&tput'
      TabOrder = 2
      DesignSize = (
        244
        228)
      object VST: TVirtualStringTree
        Left = 7
        Top = 18
        Width = 230
        Height = 203
        Anchors = [akLeft, akTop, akRight, akBottom]
        Header.AutoSizeIndex = 1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Shell Dlg 2'
        Header.Font.Style = []
        Header.MainColumn = 1
        Header.Options = [hoAutoResize, hoColumnResize, hoRestrictDrag, hoShowSortGlyphs]
        HintMode = hmHint
        Indent = 9
        ParentShowHint = False
        ScrollBarOptions.AlwaysVisible = True
        ShowHint = True
        TabOrder = 0
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toGridExtensions, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages, toGhostedIfUnfocused]
        TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
        TreeOptions.StringOptions = []
        OnBeforeCellPaint = VSTBeforeCellPaint
        OnFreeNode = VSTFreeNode
        OnGetText = VSTGetText
        OnPaintText = VSTPaintText
        OnGetHint = VSTGetHint
        OnGetNodeDataSize = VSTGetNodeDataSize
        OnScroll = VSTScroll
        Columns = <
          item
            Alignment = taCenter
            Margin = 2
            Position = 0
            Spacing = 2
            WideText = 'Line'
          end
          item
            Margin = 2
            Position = 1
            Spacing = 2
            Width = 159
            WideText = 'Text'
          end>
      end
    end
  end
  object BotPanel: TPanel
    Left = 0
    Top = 286
    Width = 683
    Height = 92
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object ListView: TListView
      Left = 0
      Top = 0
      Width = 683
      Height = 92
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Columns = <
        item
          Caption = 'Pos'
          Width = 40
        end
        item
          Caption = 'Token'
          Width = 100
        end
        item
          AutoSize = True
          Caption = 'Explanation'
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      GridLines = True
      ReadOnly = True
      RowSelect = True
      ParentFont = False
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = ListViewSelectItem
    end
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
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 276
        FloatTop = 216
        FloatClientWidth = 23
        FloatClientHeight = 22
        IsMainMenu = True
        ItemLinks = <
          item
            Item = cbWord
            Visible = True
          end
          item
            Item = cbEOL
            Visible = True
          end
          item
            BeginGroup = True
            Item = btnSingleLine
            Visible = True
          end
          item
            BeginGroup = True
            Item = btnExplain
            Visible = True
          end
          item
            Item = btnHorizontal
            Visible = True
          end
          item
            Item = cbSync
            Visible = True
          end
          item
            BeginGroup = True
            Item = btnOpen
            Visible = True
          end
          item
            BeginGroup = True
            Item = btnUpdate
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
    Images = CentralImageListMod.ImageList
    PopupMenuLinks = <>
    UseSystemFont = False
    Left = 48
    Top = 112
    DockControlHeights = (
      0
      0
      26
      0)
    object cbWord: TdxBarButton
      Caption = 'Word wrap'
      Category = 0
      Hint = 'Word wrap in editors'
      Visible = ivAlways
      ButtonStyle = bsChecked
      Down = True
      OnClick = cbWordClick
    end
    object cbEOL: TdxBarButton
      Caption = 'Show EOL'
      Category = 0
      Hint = 'Show end of line markers'
      Visible = ivAlways
      ButtonStyle = bsChecked
      OnClick = cbEOLClick
    end
    object cbSync: TdxBarButton
      Caption = 'Synchronize'
      Category = 0
      Hint = 'Synchronize scrolling of editors'
      Visible = ivAlways
      ButtonStyle = bsChecked
      Down = True
      ImageIndex = 9
    end
    object btnExplain: TdxBarButton
      Caption = 'Explain'
      Category = 0
      Hint = 'Explain currect regular expression'
      Visible = ivAlways
      ButtonStyle = bsChecked
      Down = True
      ImageIndex = 32
      PaintStyle = psCaptionGlyph
      OnClick = btnExplainClick
    end
    object btnOpen: TdxBarButton
      Caption = 'Open file'
      Category = 0
      Hint = 'Open file in input editor'
      Visible = ivAlways
      ImageIndex = 25
      OnClick = btnOpenClick
    end
    object btnHorizontal: TdxBarButton
      Caption = 'Horizontal'
      Category = 0
      Hint = 'Horizontal arrangement'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 136
      OnClick = btnHorizontalClick
    end
    object btnUpdate: TdxBarButton
      Caption = 'Update all'
      Category = 0
      Hint = 'Update now all lines in output'
      Visible = ivNever
      ImageIndex = 134
      PaintStyle = psCaptionGlyph
      OnClick = btnUpdateClick
    end
    object btnSingleLine: TdxBarButton
      Caption = 'Single line'
      Category = 0
      Hint = 'Treat all of input as a single line'
      Visible = ivNever
      ButtonStyle = bsChecked
      ImageIndex = 88
      PaintStyle = psCaptionGlyph
      OnClick = btnSingleLineClick
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 
      'All files (*.*)|*.*|Text files (*.txt)|*.txt|HTML files (*.htm;*' +
      '.html)|*.htm;*.html'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select file...'
    Left = 116
    Top = 114
  end
  object FormStorage: TJvFormStorage
    Options = []
    OnRestorePlacement = FormStorageRestorePlacement
    StoredProps.Strings = (
      'btnExplain.Down'
      'cbEOL.Down'
      'cbSync.Down'
      'cbWord.Down'
      'edRegExp.Items'
      'edRegExp.Text'
      'btnHorizontal.Down')
    StoredValues = <>
    Left = 55
    Top = 163
  end
  object Timer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TimerTimer
    Left = 117
    Top = 162
  end
end
