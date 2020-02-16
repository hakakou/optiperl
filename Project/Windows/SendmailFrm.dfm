object SendmailForm: TSendmailForm
  Left = 1396
  Top = 241
  Width = 370
  Height = 210
  HelpContext = 6750
  Caption = 'Sendmail'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDefaultPosOnly
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object memOut: TDCMemo
    Left = 0
    Top = 23
    Width = 362
    Height = 153
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
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 362
    Height = 23
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 73
    Caption = 'ToolBar'
    EdgeBorders = [ebBottom]
    Flat = True
    ShowCaptions = True
    TabOrder = 1
    object btnSend: TToolButton
      Left = 0
      Top = 0
      Caption = 'Send to MAPI'
      ImageIndex = 0
      OnClick = btnSendClick
    end
    object btnClose: TToolButton
      Left = 73
      Top = 0
      Caption = 'Close'
      ImageIndex = 1
      OnClick = btnCloseClick
    end
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
    Left = 56
    Top = 80
  end
end
