object TemplateForm: TTemplateForm
  Left = 349
  Top = 201
  Width = 521
  Height = 302
  HelpContext = 410
  Caption = 'Code Templates'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = XFormCreate
  OnDestroy = XFormDestroy
  OnShow = XFormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 273
    Top = 22
    Width = 4
    Height = 249
    AutoSnap = False
    ResizeStyle = rsUpdate
  end
  object VST: TVirtualStringTree
    Left = 0
    Top = 22
    Width = 273
    Height = 249
    Align = alLeft
    ButtonStyle = bsTriangle
    ClipboardFormats.Strings = (
      'Virtual Tree Data')
    DragMode = dmAutomatic
    DragOperations = [doCopy, doMove, doLink]
    DrawSelectionMode = smBlendedRectangle
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoHotTrack, hoShowSortGlyphs, hoVisible]
    Header.SortDirection = sdDescending
    Header.Style = hsXPStyle
    HintAnimation = hatNone
    IncrementalSearch = isAll
    IncrementalSearchStart = ssAlwaysStartOver
    PopupMenu = EditMenu
    TabOrder = 0
    TreeOptions.AnimationOptions = [toAnimatedToggle]
    TreeOptions.AutoOptions = [toAutoTristateTracking, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
    TreeOptions.StringOptions = []
    OnCompareNodes = VSTCompareNodes
    OnDragOver = VSTDragOver
    OnDragDrop = VSTDragDrop
    OnFocusChanging = VSTFocusChanging
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    OnHeaderClick = VSTHeaderClick
    OnLoadNode = VSTLoadNode
    OnNewText = VSTNewText
    OnSaveNode = VSTSaveNode
    Columns = <
      item
        Position = 0
        Width = 95
        WideText = 'Name'
      end
      item
        Position = 1
        Width = 172
        WideText = 'Description'
      end>
  end
  object MemTem: TDCMemo
    Left = 277
    Top = 22
    Width = 236
    Height = 249
    Cursor = crIBeam
    PrintOptions = [poShowProgress]
    LineNumColor = clBlack
    LineNumAlign = taRightJustify
    KeyMapping = 'Default'
    SelColor = clWhite
    SelBackColor = clNavy
    MatchBackColor = clBlack
    GutterBackColor = clWindow
    MemoSource = TemSource
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
    OnStateChange = MemTemStateChange
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
    TabOrder = 1
    TabStop = True
    CodeTemplates = <>
    TemplatesType = 'None'
    HideCaret = False
    UseGlobalOptions = False
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 513
    Height = 22
    AutoSize = True
    ButtonWidth = 64
    Caption = 'ToolBar1'
    EdgeBorders = [ebBottom]
    EdgeInner = esNone
    EdgeOuter = esNone
    Flat = True
    Images = CentralImageListMod.ImageList
    List = True
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 2
    object ToolButton2: TToolButton
      Left = 0
      Top = 0
      Caption = 'Edit'
      DropdownMenu = EditMenu
      ImageIndex = 77
    end
    object ToolButton4: TToolButton
      Left = 64
      Top = 0
      Width = 16
      Caption = 'ToolButton4'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object ToolButton1: TToolButton
      Left = 80
      Top = 0
      Action = AddItemAction
    end
    object ToolButton3: TToolButton
      Left = 144
      Top = 0
      Action = DeleteAction
    end
  end
  object TemSource: TMemoSource
    Options = [soBackUnindents, soGroupUndo, soForceCutCopy, soAutoIndent, soSmartTab, soFindTextAtCursor, soOverwriteBlocks]
    SyntaxParser = ParsersMod.Perl
    TabStops = '9,17'
    ReadOnly = False
    SpacesInTab = 8
    CodeTemplates = <>
    TemplatesType = 'None'
    HighlightUrls = False
    UseGlobalOptions = False
    Left = 32
    Top = 104
  end
  object TemActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 112
    Top = 104
    object AddItemAction: TAction
      Caption = '&New'
      Hint = 'Adds a new template'
      ImageIndex = 73
      OnExecute = AddItemActionExecute
    end
    object DeleteAction: TAction
      Caption = '&Delete'
      Hint = 'Deletes selected template'
      ImageIndex = 72
      OnExecute = DeleteActionExecute
      OnUpdate = EnabledIfFocused
    end
    object SaveAction: TAction
      Caption = '&Save Now'
      Hint = 'Save templates now'
      ImageIndex = 0
      OnExecute = SaveActionExecute
    end
    object ImportAction: TAction
      Caption = '&Import Templates'
      Hint = 'Imports templates from text file'
      OnExecute = ImportActionExecute
    end
    object EditNameAction: TAction
      Caption = '&Edit Name'
      OnExecute = EditNameActionExecute
      OnUpdate = EnabledIfFocused
    end
    object EditDescAction: TAction
      Caption = 'Edi&t Description'
      OnExecute = EditDescActionExecute
      OnUpdate = EnabledIfFocused
    end
  end
  object EditMenu: TPopupMenu
    Images = CentralImageListMod.ImageList
    Left = 32
    Top = 168
    object AddItem1: TMenuItem
      Action = AddItemAction
    end
    object ExpandAll2: TMenuItem
      Action = DeleteAction
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object EditName1: TMenuItem
      Action = EditNameAction
    end
    object EditDescription1: TMenuItem
      Action = EditDescAction
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object ImportTemplates1: TMenuItem
      Action = ImportAction
    end
    object SaveNow1: TMenuItem
      Action = SaveAction
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'txt'
    Filter = 'Text files (*.txt)|*.txt|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Import Templates File'
    Left = 320
    Top = 120
  end
  object FormStorage: TJvFormStorage
    StoredValues = <>
    Left = 184
    Top = 160
  end
end
