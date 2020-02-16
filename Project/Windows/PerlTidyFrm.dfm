object PerltidyForm: TPerltidyForm
  Left = 360
  Top = 267
  HelpContext = 710
  AutoScroll = False
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Perltidy'
  ClientHeight = 485
  ClientWidth = 510
  Color = clBtnFace
  Constraints.MinHeight = 380
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    510
    485)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 76
    Height = 13
    Hint = 'Columns per indentation level'
    Caption = '&Indent Columns:'
    FocusControl = edIndentColumns
  end
  object Label2: TLabel
    Left = 8
    Top = 30
    Width = 49
    Height = 13
    Hint = 'Tightness of curly braces, parentheses, and square brackets'
    Caption = '&Tightness:'
    FocusControl = edTightness
  end
  object Label3: TLabel
    Left = 8
    Top = 54
    Width = 118
    Height = 13
    Hint = 'Extra indentation spaces applied when a long line is broken'
    Caption = 'Co&ntinuation Indentation:'
    FocusControl = edContIndent
  end
  object Label4: TLabel
    Left = 8
    Top = 78
    Width = 98
    Height = 13
    Caption = '&Maximum line length:'
    FocusControl = edMaxLine
  end
  object Label5: TLabel
    Left = 8
    Top = 104
    Width = 39
    Height = 13
    Caption = '&Options:'
    FocusControl = edOptions
  end
  object btnCLose: TButton
    Left = 433
    Top = 66
    Width = 75
    Height = 25
    Hint = 'Cancel changes and exit'
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 12
  end
  object btnSave: TButton
    Left = 433
    Top = 35
    Width = 75
    Height = 25
    Hint = 'Save changes and exit'
    Anchors = [akTop, akRight]
    Caption = '&Save'
    ModalResult = 1
    TabOrder = 11
    OnClick = btnSaveClick
  end
  object btnPreview: TButton
    Left = 433
    Top = 4
    Width = 75
    Height = 25
    Hint = 'Preview script with selected options'
    Anchors = [akTop, akRight]
    Caption = '&Preview'
    Default = True
    TabOrder = 10
    OnClick = btnPreviewClick
  end
  object cbBackup: TCheckBox
    Left = 216
    Top = 61
    Width = 97
    Height = 17
    Hint = 'Create a backup file in the same folder'
    Caption = 'Create &Backup'
    Checked = True
    State = cbChecked
    TabOrder = 7
    OnClick = OptChanged
  end
  object edIndentColumns: TJvSpinEdit
    Left = 137
    Top = 3
    Width = 57
    Height = 21
    Hint = 'Columns per indentation level'
    MaxValue = 99.000000000000000000
    MinValue = 1.000000000000000000
    Value = 4.000000000000000000
    OnBottomClick = OptChanged
    OnTopClick = OptChanged
    MaxLength = 2
    TabOrder = 0
    OnChange = OptChanged
  end
  object edTightness: TJvSpinEdit
    Left = 137
    Top = 27
    Width = 57
    Height = 21
    Hint = 'Tightness of curly braces, parentheses, and square brackets'
    MaxValue = 2.000000000000000000
    Value = 1.000000000000000000
    OnBottomClick = OptChanged
    OnTopClick = OptChanged
    MaxLength = 1
    TabOrder = 1
    OnChange = OptChanged
  end
  object edContIndent: TJvSpinEdit
    Left = 137
    Top = 51
    Width = 57
    Height = 21
    Hint = 'Extra indentation spaces applied when a long line is broken'
    MaxValue = 9.000000000000000000
    MinValue = 1.000000000000000000
    Value = 2.000000000000000000
    OnBottomClick = OptChanged
    OnTopClick = OptChanged
    MaxLength = 1
    TabOrder = 2
    OnChange = OptChanged
  end
  object cbIndBlockCom: TCheckBox
    Left = 216
    Top = 2
    Width = 137
    Height = 17
    Hint = 
      'Full-line comments are indented to the same level as the code wh' +
      'ich follows them'
    Caption = 'Indent b&lock comments'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = OptChanged
  end
  object edMaxLine: TJvSpinEdit
    Left = 137
    Top = 75
    Width = 57
    Height = 21
    MaxValue = 999.000000000000000000
    MinValue = 20.000000000000000000
    Value = 80.000000000000000000
    OnBottomClick = edMaxLineChange
    OnTopClick = edMaxLineChange
    MaxLength = 3
    TabOrder = 3
    OnChange = edMaxLineChange
  end
  object cbMangle: TCheckBox
    Left = 216
    Top = 22
    Width = 97
    Height = 17
    Hint = 'Make the file unreadable'
    Caption = 'M&angle'
    TabOrder = 5
    OnClick = OptChanged
  end
  object cbCuddledElse: TCheckBox
    Left = 216
    Top = 41
    Width = 97
    Height = 17
    Hint = 
      'Enable the "cuddled else" style, in which `else'#39' and `elsif'#39' are' +
      ' followed '#13#10'immediately after the curly brace closing the previo' +
      'us block'
    Caption = 'Cuddled &else'
    TabOrder = 6
    OnClick = OptChanged
  end
  object btnDefaults: TButton
    Left = 433
    Top = 97
    Width = 75
    Height = 25
    Hint = 'Select default options'
    Anchors = [akTop, akRight]
    Caption = 'De&faults'
    TabOrder = 13
    OnClick = btnDefaultsClick
  end
  object edOptions: TEdit
    Left = 55
    Top = 100
    Width = 293
    Height = 21
    Hint = 'Add custom options (read perltidy.txt)'
    TabOrder = 9
    OnChange = OptChanged
  end
  object Panel: TPanel
    Left = 0
    Top = 126
    Width = 510
    Height = 359
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 14
    object Splitter: TSplitter
      Left = 0
      Top = 266
      Width = 510
      Height = 4
      Cursor = crVSplit
      Align = alBottom
      AutoSnap = False
      MinSize = 40
      ResizeStyle = rsUpdate
    end
    object memOut: TDCMemo
      Left = 0
      Top = 0
      Width = 510
      Height = 266
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
      Options = [moDrawMargin, moDrawGutter, moThumbTracking, moDblClickLine, moColorSyntax, moLineNumbers, moLineNumbersOnGutter, moShowScrollHint, moTripleClick]
      GutterBrush.Color = clBtnFace
      MarginPen.Color = clGrayText
      GutterWidth = 26
      BkgndOption = boNone
      LineSeparator.Options = []
      LineSeparator.Pen.Color = clGrayText
      LineHighlight.Visible = False
      LineHighlight.Shape = shDoubleLine
      SpecialSymbols.EOLStringBinary = {01000000B6}
      SpecialSymbols.EOFStringBinary = {010000005F}
      UseDefaultMenu = False
      OnSelectionChange = memOutSelectionChange
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Style = []
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
    object edLog: TDCMemo
      Left = 0
      Top = 270
      Width = 510
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
  object cbLog: TCheckBox
    Left = 216
    Top = 80
    Width = 97
    Height = 17
    Hint = 'Show the pertidy log after executing'
    Caption = '&View log file'
    TabOrder = 8
    OnClick = cbLogClick
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
    Left = 112
    Top = 168
  end
  object FormStorage: TJvFormStorage
    Options = [fpPosition]
    StoredProps.Strings = (
      'cbBackup.Checked'
      'cbCuddledElse.Checked'
      'cbIndBlockCom.Checked'
      'cbMangle.Checked'
      'edContIndent.Value'
      'edIndentColumns.Value'
      'edMaxLine.Value'
      'edOptions.Text'
      'edTightness.Value'
      'cbLog.Checked')
    StoredValues = <>
    Left = 192
    Top = 160
  end
end
