object TemSelectForm: TTemSelectForm
  Left = 247
  Top = 220
  AutoScroll = False
  Caption = 'Select Template'
  ClientHeight = 335
  ClientWidth = 733
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    733
    335)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 0
    Width = 733
    Height = 278
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter: TSplitter
      Left = 467
      Top = 0
      Width = 4
      Height = 278
      Align = alRight
      AutoSnap = False
      ResizeStyle = rsUpdate
    end
    object Memo: TDCMemo
      Left = 471
      Top = 0
      Width = 262
      Height = 278
      Cursor = crIBeam
      PrintOptions = [poShowProgress]
      LineNumColor = clBlack
      LineNumAlign = taRightJustify
      KeyMapping = 'Default'
      SelColor = clWhite
      SelBackColor = clNavy
      MatchBackColor = clBlack
      GutterBackColor = clWindow
      MemoSource = MemoSource
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
      SpacesInTab = 8
      Align = alRight
      UseDockManager = False
      TabOrder = 0
      TabStop = True
      CodeTemplates = <>
      TemplatesType = 'None'
      HideCaret = False
      UseGlobalOptions = False
    end
    object VET: TVirtualExplorerTree
      Left = 0
      Top = 0
      Width = 467
      Height = 278
      Active = True
      Align = alClient
      ButtonFillMode = fmShaded
      ColumnDetails = cdUser
      ColumnMenuItemCount = 8
      DefaultNodeHeight = 17
      DragHeight = 250
      DragWidth = 150
      DrawSelectionMode = smBlendedRectangle
      FileObjects = [foFolders, foNonFolders]
      FileSizeFormat = fsfActual
      FileSort = fsFileExtension
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoRestrictDrag, hoShowSortGlyphs, hoVisible]
      Header.Style = hsPlates
      HintAnimation = hatNone
      HintMode = hmHint
      LineMode = lmBands
      ParentColor = False
      RootFolder = rfCustom
      RootFolderCustomPath = 'c:\'
      TabOrder = 1
      TabStop = True
      TreeOptions.AnimationOptions = [toAnimatedToggle]
      TreeOptions.AutoOptions = [toAutoScrollOnExpand, toAutoTristateTracking]
      TreeOptions.PaintOptions = [toShowButtons, toShowHorzGridLines, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
      TreeOptions.VETFolderOptions = [toFoldersExpandable, toHideRootFolder]
      TreeOptions.VETShellOptions = []
      TreeOptions.VETSyncOptions = []
      TreeOptions.VETMiscOptions = [toPersistentColumns]
      TreeOptions.VETImageOptions = [toImages]
      OnChange = VETChange
      OnDblClick = VETDblClick
      Columns = <
        item
          Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
          Position = 0
          Width = 206
          ColumnDetails = cdFileName
          WideText = 'Name'
        end
        item
          Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
          Position = 1
          Width = 100
          ColumnDetails = cdType
          WideText = 'Type'
        end
        item
          Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
          Position = 2
          Width = 140
          ColumnDetails = cdModified
          WideText = 'Modified'
        end>
    end
  end
  object btnCreate: TButton
    Left = 7
    Top = 285
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Create'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 87
    Top = 285
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object MemoSource: TMemoSource
    Options = [soBackUnindents, soGroupUndo, soForceCutCopy, soAutoIndent, soSmartTab, soFindTextAtCursor, soOverwriteBlocks]
    TabStops = '9,17'
    ReadOnly = True
    SpacesInTab = 8
    CodeTemplates = <>
    TemplatesType = 'None'
    HighlightUrls = False
    UseGlobalOptions = False
    Left = 560
    Top = 96
  end
end
