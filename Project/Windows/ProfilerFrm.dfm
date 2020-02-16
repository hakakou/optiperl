object ProfilerForm: TProfilerForm
  Left = 243
  Top = 158
  Width = 334
  Height = 330
  Caption = 'Script Profiler'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object memTimes: TDCMemo
    Left = 0
    Top = 0
    Width = 326
    Height = 303
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
    Options = [moThumbTracking, moColorSyntax]
    GutterBrush.Color = clBtnFace
    MarginPen.Color = clGrayText
    BkgndOption = boNone
    LineSeparator.Options = []
    LineSeparator.Pen.Color = clGrayText
    LineHighlight.Visible = False
    SpecialSymbols.EOLString = '¶'
    SpecialSymbols.EOFString = '_'
    UseDefaultMenu = False
    ReadOnly = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    TextStyles = <
      item
        Name = 'Whitespace'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
        Font.Height = -12
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
    Align = alClient
    UseDockManager = False
    TabOrder = 0
    TabStop = True
    CodeTemplates = <>
    TemplatesType = 'None'
    HideCaret = False
    UseGlobalOptions = False
  end
end
