object QueryForm: TQueryForm
  Left = 588
  Top = 373
  HelpContext = 50
  BorderStyle = bsDialog
  Caption = 'Query Editor'
  ClientHeight = 393
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: THKPageControl
    Left = 0
    Top = 26
    Width = 408
    Height = 367
    ActivePage = PrevSheet
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    OnMouseUp = PageControlMouseUp
    BorderStyle = bsSingle
    object GetSheet: TTabSheet
      Caption = 'Get Method'
      inline GetFrame: TQueryFrame
        Left = 0
        Top = 0
        Width = 400
        Height = 339
        Align = alClient
        AutoScroll = False
        TabOrder = 0
        DesignSize = (
          400
          339)
        inherited lblManual: TLabel
          Top = 304
          Width = 35
        end
        inherited vlQuery: TStringGrid
          Height = 299
        end
        inherited edManual: TEdit
          Top = 318
        end
      end
    end
    object PostSheet: TTabSheet
      Caption = 'Post Method'
      DesignSize = (
        400
        339)
      object rbEncode1: TRadioButton
        Left = 1
        Top = 322
        Width = 132
        Height = 17
        Hint = 
          'Send with a x-www-form-urlencoded encoding.'#13#10'Most common encodin' +
          'g.'
        Anchors = [akLeft, akBottom]
        Caption = '&x-www-form-urlencoded'
        Checked = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        OnClick = rbEncode1Click
      end
      object rbEncode2: TRadioButton
        Left = 146
        Top = 322
        Width = 112
        Height = 17
        Hint = 
          'Send with multipart/form-data encoding.'#13#10'Usually used only when ' +
          'uploading files.'
        Anchors = [akLeft, akBottom]
        Caption = '&multipart/form-data'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = rbEncode2Click
      end
      inline PostFrame: TQueryFrame
        Left = 0
        Top = 0
        Width = 400
        Height = 318
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoScroll = False
        TabOrder = 0
        DesignSize = (
          400
          318)
        inherited lblManual: TLabel
          Top = 283
          Width = 35
        end
        inherited vlQuery: TStringGrid
          Height = 278
        end
        inherited edManual: TEdit
          Top = 297
        end
      end
      object rbEncode3: TRadioButton
        Left = 270
        Top = 322
        Width = 41
        Height = 17
        Hint = 
          'Send the text in the manual edit box raw.'#13#10'Use ONLY for console ' +
          'scripts.'
        Anchors = [akLeft, akBottom]
        Caption = '&raw'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = rbEncode3Click
      end
    end
    object PathInfoSheet: TTabSheet
      Caption = 'PathInfo'
      ImageIndex = 78
      inline PathInfoFrame: TQueryFrame
        Left = 0
        Top = 0
        Width = 400
        Height = 339
        Align = alClient
        AutoScroll = False
        TabOrder = 0
        DesignSize = (
          400
          339)
        inherited lblManual: TLabel
          Top = 304
          Width = 35
        end
        inherited vlQuery: TStringGrid
          Height = 299
        end
        inherited edManual: TEdit
          Top = 318
        end
      end
    end
    object CookieSheet: TTabSheet
      Caption = 'Cookie'
      ImageIndex = 82
      DesignSize = (
        400
        339)
      object lblCookies: TLabel
        Left = 2
        Top = 304
        Width = 62
        Height = 13
        Anchors = [akLeft, akBottom]
        Caption = 'Cookie folder'
      end
      inline CookieFrame: TQueryFrame
        Left = 0
        Top = 0
        Width = 400
        Height = 299
        Align = alTop
        Anchors = [akLeft, akTop, akRight, akBottom]
        AutoScroll = False
        TabOrder = 0
        inherited lblManual: TLabel
          Top = 264
          Width = 35
        end
        inherited vlQuery: TStringGrid
          Height = 259
        end
        inherited edManual: TEdit
          Top = 278
        end
      end
      object cbCookies: TComboBox
        Left = 0
        Top = 318
        Width = 401
        Height = 21
        Style = csDropDownList
        Anchors = [akLeft, akRight, akBottom]
        DropDownCount = 12
        ItemHeight = 0
        TabOrder = 1
        OnDropDown = cbCookiesDropDown
        OnSelect = cbCookiesSelect
      end
    end
    object EnvironmentSheet: TTabSheet
      Caption = 'Environment'
      ImageIndex = 93
      object vlEnv: TStringGrid
        Left = 0
        Top = 0
        Width = 400
        Height = 339
        Align = alClient
        ColCount = 2
        DefaultColWidth = 200
        DefaultRowHeight = 18
        FixedCols = 0
        RowCount = 40
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goAlwaysShowEditor]
        ScrollBars = ssVertical
        TabOrder = 0
        OnKeyUp = vlEnvKeyUp
        OnTopLeftChanged = FormResize
        ColWidths = (
          200
          206)
      end
    end
    object PrevSheet: TTabSheet
      Caption = 'Preview'
      ImageIndex = 102
      object Splitter: TSplitter
        Left = 0
        Top = 246
        Width = 400
        Height = 4
        Cursor = crVSplit
        Align = alBottom
        ResizeStyle = rsUpdate
      end
      object vlPreview: TValueListEditor
        Left = 0
        Top = 0
        Width = 400
        Height = 246
        Align = alClient
        DefaultRowHeight = 17
        KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
        TabOrder = 0
        TitleCaptions.Strings = (
          'Name'
          'Value')
        ColWidths = (
          150
          244)
      end
      object memPreview: TDCMemo
        Left = 0
        Top = 250
        Width = 400
        Height = 89
        Cursor = crIBeam
        PrintOptions = [poShowProgress]
        LineNumColor = clBlack
        LineNumAlign = taRightJustify
        StringsOptions = [soBackUnindents, soGroupUndo, soForceCutCopy, soAutoIndent, soSmartTab, soFindTextAtCursor, soOverwriteBlocks]
        TabStops = '9,17'
        KeyMapping = 'Default'
        SelColor = clWhite
        SelBackColor = clNavy
        MatchBackColor = clBlack
        GutterBackColor = clWindow
        ScrollBars = ssBoth
        Options = [moThumbTracking, moColorSyntax]
        GutterBrush.Color = clBtnFace
        MarginPen.Color = clGrayText
        BkgndOption = boNone
        LineSeparator.Options = []
        LineSeparator.Pen.Color = clGrayText
        LineHighlight.Visible = False
        LineHighlight.Shape = shDoubleLine
        SpecialSymbols.EOLStringBinary = {01000000B6}
        SpecialSymbols.EOFStringBinary = {010000005F}
        UseDefaultMenu = False
        ReadOnly = True
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
        SpacesInTab = 8
        Align = alBottom
        UseDockManager = False
        TabOrder = 1
        TabStop = True
        CodeTemplates = <>
        TemplatesType = 'None'
        HideCaret = False
        UseGlobalOptions = False
      end
    end
  end
  object Pcre: TDIPcre
    CompileOptionBits = 7
    Left = 64
    Top = 144
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'htm'
    Filter = 
      'HTML Documents (*.htm; *.html;*.shtml)|*.htm;*.html;*.shtml|All ' +
      'Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select html document to import'
    Left = 352
    Top = 127
  end
  object PcreName: TDIPcre
    CompileOptionBits = 7
    MatchPattern = 'name\s*=\s*(?:\"([^\"]*)\"|(\w+))'
    Left = 112
    Top = 144
  end
  object PcreValue: TDIPcre
    CompileOptionBits = 7
    MatchPattern = 'value\s*=\s*(?:\"([^\"]*)\"|(\S+))'
    Left = 168
    Top = 144
  end
  object PcreType: TDIPcre
    CompileOptionBits = 7
    MatchPattern = 'type\s*=\s*(?:\"([^\"]*)\"|(\w+))'
    Left = 224
    Top = 144
  end
  object PcreForm: TDIPcre
    CompileOptionBits = 7
    MatchPattern = '<\s*form\s+([^>]+)\s*>'
    Left = 280
    Top = 144
  end
  object ActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 112
    Top = 216
    object OpenQueryEditorAction: THKAction
      Category = 'Query'
      Caption = '&Open Query Editor'
      Hint = 'Show query editor window'
      ImageIndex = 129
      ShortCut = 16465
      OnExecute = OpenQueryEditorActionExecute
      UserData = 0
    end
    object EnGetAction: THKAction
      Category = 'Query'
      Caption = '&Enable GET'
      Hint = 'Enable GET method'
      OnExecute = EnableAction
      OnUpdate = EnableUpdate
      UserData = 0
    end
    object EnPostAction: THKAction
      Tag = 1
      Category = 'Query'
      Caption = 'E&nable POST'
      Hint = 'Enable POST method'
      OnExecute = EnableAction
      OnUpdate = EnableUpdate
      UserData = 0
    end
    object EnPathInfoAction: THKAction
      Tag = 2
      Category = 'Query'
      Caption = 'Ena&ble PATHINFO'
      Hint = 'Enable Pathinfo'
      OnExecute = EnableAction
      OnUpdate = EnableUpdate
      UserData = 0
    end
    object EnCookieAction: THKAction
      Tag = 3
      Category = 'Query'
      Caption = 'Enab&le Cookie'
      Hint = 'Enable Cookie'
      OnExecute = EnableAction
      OnUpdate = EnableUpdate
      UserData = 0
    end
    object ImportFileAction: THKAction
      Category = 'Query'
      Caption = '&Import from File...'
      Hint = 'Import query from html document with a form'
      OnExecute = ImportFileActionExecute
      OnUpdate = ImportFileActionUpdate
      UserData = 0
    end
    object ImportWebAction: THKAction
      Category = 'Query'
      Caption = 'I&mport from Web'
      Hint = 'Import query from open html document'
      OnExecute = ImportWebActionExecute
      OnUpdate = ImportWebActionUpdate
      UserData = 0
    end
    object SaveShotAction: THKAction
      Category = 'Query'
      Caption = '&Add Values'
      Hint = 'Save query'
      ImageIndex = 23
      OnExecute = SaveShotActionExecute
      UserData = 0
    end
    object DelShotAction: THKAction
      Category = 'Query'
      Caption = '&Delete Values'
      Hint = 'Delete query'
      ImageIndex = 22
      OnExecute = DelShotActionExecute
      UserData = 0
    end
    object CopyGetAction: THKAction
      Category = 'Query'
      Caption = '&Copy from GET'
      Hint = 'Copy from GET method'
      OnExecute = CopyGetActionExecute
      OnUpdate = CopyActionUpdate
      UserData = 0
    end
    object CopyPostAction: THKAction
      Tag = 1
      Category = 'Query'
      Caption = 'Cop&y from POST'
      Hint = 'Copy from POST method'
      OnExecute = CopyPostActionExecute
      OnUpdate = CopyActionUpdate
      UserData = 0
    end
    object CopyPathInfoAction: THKAction
      Tag = 2
      Category = 'Query'
      Caption = 'Copy &from PathInfo'
      Hint = 'Copy from Pathinfo'
      OnExecute = CopyPathInfoActionExecute
      OnUpdate = CopyActionUpdate
      UserData = 0
    end
    object PreviewAction: THKAction
      Category = 'Query'
      Caption = '&Preview'
      Hint = 'Preview environment settings'
      OnExecute = PreviewActionExecute
      UserData = 0
    end
    object QuerySelectFileAction: THKAction
      Category = 'Query'
      Caption = 'Select File...'
      Hint = 'Selects a file to use as input in query'
      OnExecute = QuerySelectFileActionExecute
      OnUpdate = QuerySelectFileActionUpdate
      UserData = 0
    end
    object IncExtVariablesAction: THKAction
      Category = 'Query'
      Caption = 'Include External Variables'
      Hint = 
        'Check to include external variables from your system when runnin' +
        'g script'
      OnExecute = IncExtVariablesActionExecute
      OnUpdate = IncExtVariablesActionUpdate
      UserData = 0
    end
  end
  object SelectDialog: TOpenDialog
    Filter = 'All Files (*.*)|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select file'
    Left = 312
    Top = 215
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
        FloatLeft = 460
        FloatTop = 402
        FloatClientWidth = 23
        FloatClientHeight = 22
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        IsMainMenu = True
        ItemLinks = <
          item
            Item = siMethods
            Visible = True
          end
          item
            Item = siCopy
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxSelectFile
            Visible = True
          end>
        MultiLine = True
        Name = 'Main menu'
        OneOnRow = True
        Row = 0
        ShowMark = False
        UseOwnFont = True
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
    Left = 232
    Top = 216
    DockControlHeights = (
      0
      0
      26
      0)
    object siMethods: TdxBarSubItem
      Caption = 'Methods'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxEnGet
          Visible = True
        end
        item
          Item = dxEnPost
          Visible = True
        end
        item
          Item = dxEnPathinfo
          Visible = True
        end
        item
          Item = dxEnCookie
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxAddVal
          Visible = True
        end
        item
          Item = dxDelVals
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxImpFile
          Visible = True
        end
        item
          Item = dxImpWeb
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxIncExtVariables
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxSelectFile
          Visible = True
        end>
    end
    object siCopy: TdxBarSubItem
      Caption = 'Copy'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxCopyGet
          Visible = True
        end
        item
          Item = dxCopyPost
          Visible = True
        end
        item
          Item = dxCopyPathinfo
          Visible = True
        end>
    end
    object siPopup: TdxBarSubItem
      Caption = 'Popup'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxEnGet
          Visible = True
        end
        item
          Item = dxEnPost
          Visible = True
        end
        item
          Item = dxEnPathinfo
          Visible = True
        end
        item
          Item = dxEnCookie
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxAddVal
          Visible = True
        end
        item
          Item = dxDelVals
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxCopyGet
          Visible = True
        end
        item
          Item = dxCopyPost
          Visible = True
        end
        item
          Item = dxCopyPathinfo
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxSelectFile
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxImpWeb
          Visible = True
        end
        item
          Item = dxImpFile
          Visible = True
        end>
    end
    object dxEnGet: TdxBarButton
      Action = EnGetAction
      Category = 0
      ButtonStyle = bsChecked
    end
    object dxEnPost: TdxBarButton
      Action = EnPostAction
      Category = 0
      ButtonStyle = bsChecked
    end
    object dxEnPathinfo: TdxBarButton
      Action = EnPathInfoAction
      Category = 0
      ButtonStyle = bsChecked
    end
    object dxEnCookie: TdxBarButton
      Action = EnCookieAction
      Category = 0
      ButtonStyle = bsChecked
    end
    object dxImpFile: TdxBarButton
      Action = ImportFileAction
      Category = 0
    end
    object dxImpWeb: TdxBarButton
      Action = ImportWebAction
      Category = 0
    end
    object dxAddVal: TdxBarButton
      Action = SaveShotAction
      Category = 0
    end
    object dxDelVals: TdxBarButton
      Action = DelShotAction
      Category = 0
    end
    object dxCopyGet: TdxBarButton
      Action = CopyGetAction
      Category = 0
    end
    object dxCopyPost: TdxBarButton
      Action = CopyPostAction
      Category = 0
    end
    object dxCopyPathinfo: TdxBarButton
      Action = CopyPathInfoAction
      Category = 0
    end
    object dxIncExtVariables: TdxBarButton
      Action = IncExtVariablesAction
      Category = 0
      ButtonStyle = bsChecked
    end
    object dxSelectFile: TdxBarButton
      Action = QuerySelectFileAction
      Category = 0
      Hint = 'Select File'
    end
  end
end
