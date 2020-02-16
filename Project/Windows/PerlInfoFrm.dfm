object PerlInfoForm: TPerlInfoForm
  Left = 321
  Top = 248
  Width = 525
  Height = 308
  HelpContext = 400
  BorderStyle = bsSizeToolWin
  Caption = 'Perl Information'
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object memInfo: TDCMemo
    Left = 0
    Top = 26
    Width = 517
    Height = 248
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
    ReadOnly = True
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
        FloatLeft = 410
        FloatTop = 311
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
            Item = dxDetInfo
            Visible = True
          end
          item
            Item = dxCopyToClipboard
            Visible = True
          end>
        MultiLine = True
        Name = 'Main menu'
        OneOnRow = True
        Row = 0
        ShowMark = False
        UseOwnFont = True
        UseRestSpace = True
        Visible = True
        WholeRow = True
      end>
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    Images = CentralImageListMod.ImageList
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    UseSystemFont = False
    Left = 80
    Top = 72
    DockControlHeights = (
      0
      0
      26
      0)
    object dxDetInfo: TdxBarButton
      Caption = 'Detailed Info'
      Category = 0
      Hint = 'Detailed info'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 31
      PaintStyle = psCaptionGlyph
      OnClick = dxDetInfoClick
    end
    object dxCopyToClipboard: TdxBarButton
      Caption = 'Copy To clipboard'
      Category = 0
      Hint = 'Copy To clipboard'
      Visible = ivAlways
      ImageIndex = 78
      PaintStyle = psCaptionGlyph
      OnClick = dxCopyToClipboardClick
    end
  end
end
