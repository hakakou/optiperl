object URLEncodeForm: TURLEncodeForm
  Left = 485
  Top = 239
  HelpContext = 60
  BorderStyle = bsDialog
  Caption = 'Encoding'
  ClientHeight = 245
  ClientWidth = 352
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
  DesignSize = (
    352
    245)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 324
    Top = 2
    Width = 21
    Height = 13
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = '&Text'
    FocusControl = Memo1
  end
  object Label2: TLabel
    Left = 302
    Top = 117
    Width = 43
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = '&Encoded'
    FocusControl = memo2
  end
  object btnInsNormal: TButton
    Left = 6
    Top = 89
    Width = 102
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = '&Insert'
    TabOrder = 1
    OnClick = btnInsNormalClick
  end
  object btnInsURL: TButton
    Left = 6
    Top = 220
    Width = 102
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'I&nsert'
    TabOrder = 5
    OnClick = btnInsURLClick
  end
  object btnNorCopy: TButton
    Left = 116
    Top = 89
    Width = 103
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'Co&py to clipboard'
    TabOrder = 2
    OnClick = btnNorCopyClick
  end
  object btnCopyURL: TButton
    Left = 116
    Top = 220
    Width = 103
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'C&opy to clipboard'
    TabOrder = 6
    OnClick = btnCopyURLClick
  end
  object Memo1: TDCMemo
    Left = 6
    Top = 17
    Width = 341
    Height = 66
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
    UseDefaultMenu = True
    ReadOnly = False
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
    TabOrder = 0
    TabStop = True
    OnChange = Memo1Change
    CodeTemplates = <>
    TemplatesType = 'None'
    HideCaret = False
    UseGlobalOptions = False
  end
  object memo2: TDCMemo
    Left = 6
    Top = 133
    Width = 341
    Height = 82
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
    ScrollBars = ssVertical
    Options = [moThumbTracking, moColorSyntax]
    GutterBrush.Color = clBtnFace
    MarginPen.Color = clGrayText
    BlockOption = bkStreamSel
    WordWrap = True
    BkgndOption = boNone
    LineSeparator.Options = []
    LineSeparator.Pen.Color = clGrayText
    LineHighlight.Visible = False
    LineHighlight.Shape = shDoubleLine
    SpecialSymbols.EOLStringBinary = {01000000B6}
    SpecialSymbols.EOFStringBinary = {010000005F}
    UseDefaultMenu = True
    ReadOnly = False
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
    Anchors = [akLeft, akRight, akBottom]
    UseDockManager = False
    TabOrder = 4
    TabStop = True
    OnChange = Memo2Change
    CodeTemplates = <>
    TemplatesType = 'None'
    HideCaret = False
    UseGlobalOptions = False
  end
  object cbEncoding: TComboBox
    Left = 232
    Top = 89
    Width = 116
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    DropDownCount = 20
    ItemHeight = 13
    TabOrder = 3
    OnChange = cbEncodingChange
    Items.Strings = (
      'HTTP encode'
      'Base64'
      'UUEncoded'
      'Unix Crypt'
      '--'
      'Hexadecimal'
      'Binary'
      '--'
      'UPPER case'
      'lower case'
      'Proper Case'
      '--'
      'Human number'
      'Roman number')
  end
  object FormStorage: TJvFormStorage
    Options = []
    StoredProps.Strings = (
      'cbEncoding.ItemIndex')
    StoredValues = <>
    Left = 176
    Top = 160
  end
end
