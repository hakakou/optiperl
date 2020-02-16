object EditorForm: TEditorForm
  Tag = 5
  Left = 319
  Top = 404
  HelpContext = 490
  Align = alClient
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Editor'
  ClientHeight = 265
  ClientWidth = 598
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = XFormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl: THKTabcontrol
    Left = 0
    Top = 26
    Width = 598
    Height = 219
    Align = alClient
    HotTrack = True
    TabOrder = 0
    TabStop = False
    OnChange = TabControlChange
    OnChanging = TabControlChanging
    OnMouseDown = TabControlMouseDown
    OnMouseUp = TabControlMouseUp
    object memEditor: TDCMemo
      Left = 1
      Top = 6
      Width = 596
      Height = 213
      Cursor = crIBeam
      PrintOptions = [poLineNumbers, poPrintSyntax, poShowProgress]
      WantTabs = True
      LineNumColor = clBlack
      LineNumAlign = taRightJustify
      StringsOptions = [soBackUnindents, soGroupUndo, soForceCutCopy, soFindTextAtCursor, soOverwriteBlocks, soUseTabCharacter, soCursorOnTabs, soCursorAlwaysOnTabs]
      TabStops = '9,17'
      KeyMapping = 'Default'
      UndoLimit = 100
      SelColor = clWhite
      SelBackColor = clNavy
      MatchBackColor = clBlack
      GutterBackColor = clMaroon
      ScrollBars = ssBoth
      Options = [moDrawMargin, moDrawGutter, moThumbTracking, moColorSyntax, moLineNumbers, moHideInvisibleLines, moDrawLineBookmarks, moShowScrollHint, moCenterOnBookmark, moTripleClick, moLimitLineNumbers]
      GutterBrush.Color = clBtnFace
      MarginPen.Color = clActiveBorder
      GutterLineColor = clGreen
      GutterWidth = 30
      GutterImgs = <
        item
          Name = 'BreakPoint'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            04000000000078000000120B0000120B00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0FFFFF00000FFFFF0FFFF0999990F
            FFF0FFF099999990FFF0FFF099999990FFF0FFF099999990FFF0FFF099999990
            FFF0FFF099999990FFF0FFFF0999990FFFF0FFFFF00000FFFFF0FFFFFFFFFFFF
            FFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0}
        end
        item
          Name = 'Bookmark0'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082600062070F0FF086062606070F0FF0820262020
            70F0FF086062606070F0FF082026202070F0FF086062606070F0FF0820262020
            70F0FF086200026070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 0
        end
        item
          Name = 'Bookmark1'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082000002070F0FF086260626070F0FF0826202620
            70F0FF086260626070F0FF082620262070F0FF086060626070F0FF0826002620
            70F0FF086260626070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 1
        end
        item
          Name = 'Bookmark2'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082000002070F0FF086062626070F0FF0826062620
            70F0FF086260626070F0FF082626062070F0FF086262606070F0FF0820262020
            70F0FF086200026070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 2
        end
        item
          Name = 'Bookmark3'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082600062070F0FF086062606070F0FF0826262020
            70F0FF086262606070F0FF082620062070F0FF086262606070F0FF0820262020
            70F0FF086200026070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 3
        end
        item
          Name = 'Bookmark4'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082626062070F0FF086262026070F0FF0826260620
            70F0FF086000006070F0FF082026062070F0FF086062026070F0FF0820260620
            70F0FF086062026070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 4
        end
        item
          Name = 'Bookmark5'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082600062070F0FF086062606070F0FF0826262020
            70F0FF086262606070F0FF082000062070F0FF086062626070F0FF0820262620
            70F0FF086000006070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 5
        end
        item
          Name = 'Bookmark6'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082600062070F0FF086062606070F0FF0820262020
            70F0FF086062606070F0FF082000062070F0FF086062626070F0FF0820262020
            70F0FF086200026070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 6
        end
        item
          Name = 'Bookmark7'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082620262070F0FF086260626070F0FF0826202620
            70F0FF086262026070F0FF082626062070F0FF086262606070F0FF0820262020
            70F0FF086000006070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 7
        end
        item
          Name = 'Bookmark8'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082600062070F0FF086062606070F0FF0820262020
            70F0FF086062606070F0FF086600062070F0FF086062606070F0FF0820262020
            70F0FF086200026070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 8
        end
        item
          Name = 'Bookmark9'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            0400000000007800000000000000000000001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF0000000000
            FFF0FF08626262600FF0FF082600062070F0FF086262206070F0FF0826262020
            70F0FF086200606070F0FF082026002070F0FF086062606070F0FF0820262020
            70F0FF086200026070F0FF082626262070F0FF000000000070F0FFF088888888
            70F0FFFF000000000FF0FFFFFFFFFFFFFFF0}
          BookmarkIndex = 9
        end
        item
          Name = 'Debugger'
          Glyph.Data = {
            36010000424D3601000000000000760000002800000012000000100000000100
            040000000000C0000000120B0000120B00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
            8888880000008888888888888888880088888888888888888888880088888888
            88880888888888008888888888880088888888008888888888880C0888888800
            8888888800000CC088888800888888880CCCCCCC08888800888888880CCCCCCC
            C0888800888888880CCCCCCC088888008888888800000CC08888880088888888
            88880C0888888800888888888888008888888800888888888888088888888800
            8888888888888888888888008888888888888888888888008888}
        end
        item
          Name = 'BreakTick'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            04000000000078000000120B0000120B00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0FFFFF00000FFFFF0FFFF09A9990F
            FFF0FFF09AAA9990FFF0FFF0AA9A9990FFF0FFF0999AA990FFF0FFF09999A990
            FFF0FFF09999AA90FFF0FFFF09999A0FFFF0FFFFF0000AA0FFF0FFFFFFFFF00F
            FFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0}
        end
        item
          Name = 'BreakError'
          Glyph.Data = {
            EE000000424DEE0000000000000076000000280000000F0000000F0000000100
            04000000000078000000120B0000120B00001000000000000000000000000000
            8000008000000080800080000000800080008080000080808000C0C0C0000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
            FFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0FFFFF00000FFFFF0FFFF0999990F
            FFF0FFF09B999B90FFF0FFF09BB9BB90FFF0FFF099BBB990FFF0FFF09BB9BB90
            FFF0FFF09B999B90FFF0FFFF0999990FFFF0FFFFF00000FFFFF0FFFFFFFFFFFF
            FFF0FFFFFFFFFFFFFFF0FFFFFFFFFFFFFFF0}
        end>
      BlockOption = bkStreamSel
      BkgndOption = boEmpty
      MemoBackground.BkgndOption = boEmpty
      MemoBackground.GradientBeginColor = clWindow
      LineSeparator.Options = []
      LineSeparator.Pen.Color = clSilver
      LineHighlight.Visible = False
      LineHighlight.Shape = shDoubleLine
      SpecialSymbols.EOLStringBinary = {01000000B6}
      SpecialSymbols.EOFStringBinary = {010000005F}
      LineNumBackColor = clWhite
      UseDefaultMenu = False
      OnGetColorStyle = memEditorGetColorStyle
      OnStateChange = memEditorStateChange
      OnJumpToUrl = memEditorJumpToUrl
      OnClickGutter = memEditorClickGutter
      OnHintPopup = memEditorHintPopup
      OnHintInsert = memEditorHintInsert
      OnMemoScroll = memEditorMemoScroll
      ReadOnly = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
      TextStyles = <
        item
          Name = 'Whitespace'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'String'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Comment'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Identifier'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Integer'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Float'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Reserved words'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Delimiters'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Defines'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Regular Expressions'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Html tags'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Html params'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Breakpoint'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Error line'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Debugger'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Search result'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Bracket matching'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Script Whitespace'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Script Number'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Script Comment'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Script String'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Script ResWord'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Script Delimiters'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Emphasis'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'System Variable'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end
        item
          Name = 'Assembler'
          Color = 16775398
          UpdateMemoColors = mcNone
          UseMemoColor = False
          UseMemoFont = True
        end>
      PrinterFont.Charset = DEFAULT_CHARSET
      PrinterFont.Color = clBlack
      PrinterFont.Height = -13
      PrinterFont.Name = 'Courier New'
      PrinterFont.Style = []
      TemplateFont.Charset = ANSI_CHARSET
      TemplateFont.Color = clWindowText
      TemplateFont.Height = -11
      TemplateFont.Name = 'Arial'
      TemplateFont.Style = []
      UsePrinterFont = False
      BlockIndent = 1
      SpacesInTab = 8
      Align = alClient
      ShowHint = True
      Color = 16775398
      ParentShowHint = False
      UseDockManager = False
      OnDblClick = memEditorDblClick
      OnMouseDown = memEditorMouseDown
      OnMouseMove = memEditorMouseMove
      OnMouseUp = memEditorMouseUp
      OnKeyDown = memEditorKeyDown
      OnKeyPress = memEditorKeyPress
      OnKeyUp = memEditorKeyUp
      TabOrder = 0
      TabStop = True
      OnCanResize = memEditorCanResize
      CodeTemplates = <>
      TemplatesType = 'Custom'
      HideCaret = False
      UseGlobalOptions = False
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 245
    Width = 598
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Shell Dlg 2'
    Font.Style = []
    Panels = <
      item
        Alignment = taRightJustify
        Width = 80
      end
      item
        Text = 'Modified'
        Width = 72
      end
      item
        Text = 'Overwrite'
        Width = 70
      end
      item
        Width = 200
      end
      item
        Text = 'Server: None'
        Width = 50
      end>
    SizeGrip = False
    UseSystemFont = False
    OnDblClick = StatusBarDblClick
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
        FloatTop = 213
        FloatClientWidth = 23
        FloatClientHeight = 22
        IsMainMenu = True
        ItemLinks = <>
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
    UseSystemFont = False
    Left = 496
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object MFH: TMultiFileHandler
    OnOpen = MFHOpen
    OnSave = MFHSave
    OnNew = MFHNew
    OnSaveCancel = MFHSaveCancel
    OpenDialog = OpenDialog
    SaveDialog = SaveDialog
    MRUCount = 15
    DefaultName = 'newscript%d.cgi'
    ReservedAccents = 'FESPDRTBVWLQ'
    AddAccents = True
    OnGetActiveIndex = MFHGetActiveIndex
    OnGoToIndex = MFHGoToIndex
    OnAllClosed = MFHAllClosed
    OnOneClosed = MFHOneClosed
    OnOneOpened = MFHOneOpened
    OnTabChanged = MFHTabChanged
    OnModifyUpdate = MFHModifyUpdate
    OnReloadActive = MFHReloadActive
    OnBeforeOpen = MFHBeforeOpen
    Left = 192
    Top = 40
  end
  object OpenDialog: TOpenDialog
    OnClose = OpenDialogClose
    Filter = 
      'Perl Scripts (*.cgi;*.pl;*.pm;*.plx)|*.cgi;*.pl;*.pm;*.plx|HTML ' +
      'Documents (*.htm; *.html;*.shtml)|*.htm;*.html;*.shtml|XLM Docum' +
      'ents (*.xml)|*.xml|Configuration files (*.cfg;*.conf)|*.cfg;*.co' +
      'nf|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Dialog'
    OnCanClose = OpenDialogCanClose
    Left = 448
    Top = 104
  end
  object SaveDialog: TSaveDialog
    OnClose = SaveDialogClose
    Filter = 
      'Perl Scripts (*.cgi;*.pl;*.pm;*.plx)|*.pl;*.cgi;*.pm;*.plx|HTML ' +
      'Documents (*.htm; *.html;*.shtml)|*.htm;*.html;*.shtml|XLM Docum' +
      'ents (*.xml)|*.xml|Configuration files (*.cfg;*.conf)|*.cfg;*.co' +
      'nf|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save Dialog'
    Left = 400
    Top = 144
  end
  object FileActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 56
    Top = 48
    object NewAction: THKAction
      Category = 'File'
      Caption = '&New Script'
      HelpContext = 480
      Hint = 'Creates a new perl script'
      ImageIndex = 38
      ShortCut = 16462
      OnExecute = NewActionExecute
      UserData = 0
    end
    object NewHtmlFileAction: THKAction
      Category = 'File'
      Caption = 'New &Html'
      HelpContext = 480
      Hint = 'New html document'
      ImageIndex = 33
      ShortCut = 24654
      OnExecute = NewHtmlFileActionExecute
      UserData = 0
    end
    object NewTemplateAction: THKAction
      Category = 'File'
      Caption = '&Choose From Templates...'
      Hint = 'Creates a new file by selecting a template'
      OnExecute = NewTemplateActionExecute
      UserData = 0
    end
    object OpenAction: THKAction
      Category = 'File'
      Caption = '&Open...'
      HelpContext = 70
      Hint = 'Open an existing file'
      ImageIndex = 34
      ShortCut = 16463
      OnExecute = OpenActionExecute
      UserData = 0
    end
    object SaveAction: THKAction
      Category = 'File'
      Caption = '&Save'
      HelpContext = 70
      Hint = 'Save active file in editor'
      ImageIndex = 35
      ShortCut = 16467
      OnExecute = SaveActionExecute
      OnUpdate = SaveActionUpdate
      UserData = 0
    end
    object SaveAsAction: THKAction
      Category = 'File'
      Caption = 'Save &As...'
      HelpContext = 70
      Hint = 'Save active file in editor with a new name'
      ShortCut = 24641
      OnExecute = SaveAsActionExecute
      UserData = 0
    end
    object SaveAllAction: THKAction
      Category = 'File'
      Caption = 'Sa&ve All'
      HelpContext = 70
      Hint = 'Saves all open files'
      ImageIndex = 36
      ShortCut = 8305
      OnExecute = SaveAllActionExecute
      OnUpdate = SaveAllActionUpdate
      UserData = 0
    end
    object ReloadAction: THKAction
      Category = 'File'
      Caption = '&Reload'
      Hint = 'Reloads selected file'
      ImageIndex = 52
      OnExecute = ReloadActionExecute
      OnUpdate = ReloadActionUpdate
      UserData = 0
    end
    object ResetPermAction: THKAction
      Category = 'File'
      Caption = 'Rese&t All Permissions'
      Hint = 
        'Checks each open file if its read-only permission has been chang' +
        'ed'
      ImageIndex = 67
      OnExecute = ResetPermActionExecute
      UserData = 0
    end
    object CloseAction: THKAction
      Category = 'File'
      Caption = 'Close'
      HelpContext = 70
      Hint = 'Close active file in editor'
      ImageIndex = 139
      ShortCut = 16499
      OnExecute = CloseActionExecute
      OnUpdate = CloseActionUpdate
      UserData = 0
    end
    object CloseAllAction: THKAction
      Category = 'File'
      Caption = 'C&lose All'
      HelpContext = 70
      Hint = 'Closes all files'
      ImageIndex = 142
      OnExecute = CloseAllActionExecute
      OnUpdate = CloseAllActionUpdate
      UserData = 0
    end
    object WindowsFormatAction: THKAction
      Category = 'File'
      Caption = '&Windows Format'
      Hint = 'Select windows line ending format'
      OnExecute = WindowsFormatActionExecute
      OnUpdate = FormatUpdate
      UserData = 0
    end
    object UnixFormatAction: THKAction
      Tag = 2
      Category = 'File'
      Caption = '&Unix Format'
      Hint = 'Select UNIX line ending format'
      OnExecute = UnixFormatActionExecute
      OnUpdate = FormatUpdate
      UserData = 0
    end
    object MacFormatAction: THKAction
      Tag = 1
      Category = 'File'
      Caption = '&Mac Format'
      Hint = 'Select Mac line ending format'
      OnExecute = MacFormatActionExecute
      OnUpdate = FormatUpdate
      UserData = 0
    end
    object ExportHTMLAction: THKAction
      Category = 'File'
      Caption = '&Export to Html...'
      HelpContext = 70
      Hint = 'Exports active file to an Html document preserving color syntax'
      ImageIndex = 140
      OnExecute = ExportHTMLActionExecute
      OnUpdate = ExportHTMLActionUpdate
      UserData = 0
    end
    object ExportRTFAction: THKAction
      Category = 'File'
      Caption = 'Export to Rt&f...'
      HelpContext = 70
      Hint = 'Exports active file to an RTF document preserving color syntax'
      ImageIndex = 141
      OnExecute = ExportRTFActionExecute
      OnUpdate = ExportRTFActionUpdate
      UserData = 0
    end
    object CodeCompAction: THKAction
      Category = 'Search'
      Caption = 'Co&de Completion'
      Hint = 'Open code completion window'
      ImageIndex = 143
      ShortCut = 24608
      OnExecute = CodeCompActionExecute
      UserData = 0
    end
    object BrowseBackAction: THKAction
      Category = 'Search'
      Caption = 'Browse Back'
      Hint = 'Browse to last position before jump'
      ImageIndex = 180
      ShortCut = 32805
      OnExecute = BrowseBackActionExecute
      OnUpdate = BrowseBackActionUpdate
      UserData = 0
    end
    object ClearHighlightsAction: THKAction
      Category = 'Search'
      Caption = 'Clear all Highlights'
      Hint = 'Clear all highlights'
      OnExecute = ClearHighlightsActionExecute
      UserData = 0
    end
  end
  object ExportHtmlDialog: TSaveDialog
    DefaultExt = 'html'
    Filter = 'Html Files (*.htm;*.html)|*.htm;*.html'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofEnableSizing]
    Title = 'Export source with Html formatiing'
    Left = 544
    Top = 152
  end
  object ApplicationEvents: TApplicationEvents
    OnIdle = ApplicationEventsIdle
    OnShowHint = ApplicationEventsShowHint
    Left = 272
    Top = 136
  end
  object ExportRTFDialog: TSaveDialog
    DefaultExt = 'html'
    Filter = 'RTF Files (*.rtf)|*.rtf'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofEnableSizing]
    Title = 'Export source with RTF formatiing'
    Left = 544
    Top = 104
  end
  object HighlightTimer: TTimer
    Enabled = False
    Interval = 800
    OnTimer = HighlightTimerTimer
    Left = 104
    Top = 104
  end
  object CommPcre: TDIPcre
    MatchPattern = '^(\s*)(?:#(.*)|<!-- (.*) -->)$'
    Left = 184
    Top = 152
  end
  object MouseTimer: TTimer
    Enabled = False
    OnTimer = MouseTimerTimer
    Left = 192
    Top = 104
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 128
    Top = 48
  end
  object DropFileTarget: TDropFileTarget
    Dragtypes = [dtCopy]
    GetDataOnEnter = False
    OnDragOver = DropFileTargetDragOver
    OnDrop = DropFileTargetDrop
    ShowImage = True
    Left = 320
    Top = 40
  end
  object DropMenu: TPopupMenu
    Left = 344
    Top = 160
    object OpenFileItem: TMenuItem
      Caption = '&Open file(s)'
      OnClick = OpenFileItemClick
    end
    object InsertfileatcursorItem: TMenuItem
      Caption = '&Insert file(s) at cursor'
      OnClick = InsertfileatcursorItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Cancel1: TMenuItem
      Caption = '&Cancel'
    end
  end
  object HistoryPcre: TDIPcre
    MatchPattern = '^(.*) - (\d+):(\d+)$'
    Left = 432
    Top = 40
  end
end
