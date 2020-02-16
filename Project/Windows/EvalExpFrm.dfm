object EvalExpForm: TEvalExpForm
  Left = 401
  Top = 297
  HelpContext = 510
  BorderStyle = bsDialog
  Caption = 'Evaluate Expression'
  ClientHeight = 85
  ClientWidth = 261
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  DesignSize = (
    261
    85)
  PixelsPerInch = 96
  TextHeight = 13
  object btnEval: TSpeedButton
    Left = 138
    Top = 3
    Width = 59
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Evaluate'
    OnClick = btnEvalClick
  end
  object btnClear: TSpeedButton
    Left = 200
    Top = 3
    Width = 58
    Height = 21
    Anchors = [akTop, akRight]
    Caption = '&Clear'
    OnClick = btnClearClick
  end
  object edEval: TComboBox
    Left = 2
    Top = 3
    Width = 133
    Height = 21
    AutoComplete = False
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnChange = edEvalChange
    OnKeyPress = edEvalKeyPress
  end
  object memOutPut: TDCMemo
    Left = 2
    Top = 28
    Width = 257
    Height = 54
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
    Anchors = [akLeft, akTop, akRight, akBottom]
    UseDockManager = False
    TabOrder = 1
    TabStop = True
    CodeTemplates = <>
    TemplatesType = 'None'
    HideCaret = False
    UseGlobalOptions = False
  end
  object FormStorage: TJvFormStorage
    Options = []
    StoredProps.Strings = (
      'edEval.Items')
    StoredValues = <>
    Left = 128
    Top = 32
  end
end
