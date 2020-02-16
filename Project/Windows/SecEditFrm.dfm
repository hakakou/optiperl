object SecEditForm: TSecEditForm
  Left = 311
  Top = 351
  Width = 478
  Height = 296
  HelpContext = 770
  Caption = 'Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object memEditor: TDCMemo
    Left = 0
    Top = 0
    Width = 470
    Height = 262
    Cursor = crIBeam
    PrintOptions = [poLineNumbers, poPrintSyntax, poShowProgress]
    WantTabs = True
    LineNumColor = clBlack
    LineNumAlign = taRightJustify
    StringsOptions = [soBackUnindents, soGroupUndo, soForceCutCopy, soAutoIndent, soSmartTab, soFindTextAtCursor, soOverwriteBlocks]
    TabStops = '9,17'
    KeyMapping = 'Default'
    UseMonoFont = False
    SelColor = clWindow
    SelBackColor = clNavy
    MatchBackColor = clBlack
    GutterBackColor = clSilver
    ScrollBars = ssBoth
    Options = [moDrawMargin, moDrawGutter, moThumbTracking, moColorSyntax, moLineNumbersOnGutter, moShowScrollHint, moCenterOnBookmark, moTripleClick]
    GutterBrush.Color = clBtnFace
    MarginPen.Color = clGrayText
    GutterWidth = 30
    GutterImgs = <
      item
        Name = 'BreakPoint'
        Glyph.Data = {
          CA000000424DCA000000000000004A0000002800000010000000100000000100
          04000000000080000000120B0000120B00000500000005000000FFFFFF002424
          FF000000FF004848480000000000000000000000000000000000000000000000
          0000000000000000000000000000000000333330000000000312221300000000
          3122222130000000322222223000000032222222300000003222222230000000
          3122222130000000031222130000000000333330000000000000000000000000
          0000000000000000000000000000}
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
          82020000424D8202000000000000420000002800000012000000100000000100
          1000030000004002000000000000000000000000000000000000007C0000E003
          00001F000000F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75E0000F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75E00000000F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75EF75EF75E00001F000000F75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75E000000000000000000001F001F000000F75EF75EF75EF75EF75E
          F75EF75EF75EF75EF75E00001F001F001F001F001F001F001F000000F75EF75E
          F75EF75EF75EF75EF75EF75EF75E00001F001F001F001F001F001F001F001F00
          0000F75EF75EF75EF75EF75EF75EF75EF75E00001F001F001F001F001F001F00
          1F000000F75EF75EF75EF75EF75EF75EF75EF75EF75E00000000000000000000
          1F001F000000F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75E00001F000000F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75E00000000F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75EF75EF75E0000F75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75EF75E
          F75EF75EF75E}
      end>
    BlockOption = bkStreamSel
    BkgndOption = boTile
    MemoBackground.BkgndOption = boTile
    LineSeparator.Options = []
    LineSeparator.Pen.Color = clGrayText
    LineHighlight.Visible = False
    LineHighlight.Shape = shDoubleLine
    SpecialSymbols.EOLStringBinary = {01000000B6}
    SpecialSymbols.EOFStringBinary = {010000005F}
    UseDefaultMenu = False
    OnMemoScroll = memEditorMemoScroll
    ReadOnly = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindow
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TextStyles = <
      item
        Name = 'Whitespace'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'String'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Comment'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Identifier'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Integer'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Float'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Reserved words'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Delimiters'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Defines'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Html tags'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Html params'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Url'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'BreakPoint'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Error line'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Debugger'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Name = 'Search Result'
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
        UpdateMemoColors = mcNone
        UseMemoColor = False
        UseMemoFont = True
      end
      item
        Color = clWindow
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
    ParentShowHint = False
    UseDockManager = False
    TabOrder = 0
    TabStop = True
    CodeTemplates = <>
    TemplatesType = 'Custom'
    HideCaret = False
    UseGlobalOptions = False
  end
end
