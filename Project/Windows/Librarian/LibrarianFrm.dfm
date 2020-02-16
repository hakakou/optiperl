object LibrarianForm: TLibrarianForm
  Left = 428
  Top = 447
  HelpContext = 380
  AutoScroll = False
  Caption = 'Code Librarian'
  ClientHeight = 257
  ClientWidth = 535
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnActivate = AddItemActionExecute
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 200
    Top = 26
    Width = 4
    Height = 211
    AutoSnap = False
    MinSize = 1
    ResizeStyle = rsUpdate
  end
  object VST: TVirtualStringTree
    Left = 0
    Top = 26
    Width = 200
    Height = 211
    Align = alLeft
    BevelOuter = bvNone
    ClipboardFormats.Strings = (
      'Virtual Tree Data')
    DragMode = dmAutomatic
    DragOperations = [doCopy, doMove, doLink]
    DrawSelectionMode = smBlendedRectangle
    EditDelay = 750
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintAnimation = hatNone
    TabOrder = 0
    TreeOptions.AnimationOptions = [toAnimatedToggle]
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScroll, toAutoTristateTracking, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toToggleOnDblClick, toWheelPanning]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
    TreeOptions.StringOptions = []
    OnClick = VSTClick
    OnCompareNodes = VSTCompareNodes
    OnDragOver = VSTDragOver
    OnDragDrop = VSTDragDrop
    OnEditing = VSTEditing
    OnFocusChanging = VSTFocusChanging
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    OnPaintText = VSTPaintText
    OnGetImageIndex = VSTGetImageIndex
    OnKeyUp = VSTKeyUp
    OnMouseUp = VSTMouseUp
    OnNewText = VSTNewText
    Columns = <>
  end
  object MemLib: TDCMemo
    Left = 204
    Top = 26
    Width = 331
    Height = 211
    Cursor = crIBeam
    PrintOptions = [poShowProgress]
    LineNumColor = clBlack
    LineNumAlign = taRightJustify
    KeyMapping = 'Default'
    SelColor = clWhite
    SelBackColor = clNavy
    MatchBackColor = clBlack
    GutterBackColor = clWindow
    MemoSource = LibSource
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
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TextStyles = <
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
  object StatusBar: TStatusBar
    Left = 0
    Top = 237
    Width = 535
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Panels = <
      item
        Width = 80
      end>
    SizeGrip = False
    UseSystemFont = False
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
        FloatTop = 216
        FloatClientWidth = 23
        FloatClientHeight = 22
        IsMainMenu = True
        ItemLinks = <
          item
            Item = siFile
            Visible = True
          end
          item
            Item = siEdit
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxInsert
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxAddItem
            Visible = True
          end
          item
            Item = dxAddFolder
            Visible = True
          end
          item
            Item = dxDelete
            Visible = True
          end>
        MultiLine = True
        Name = 'Main menu'
        OneOnRow = True
        Row = 0
        ShowMark = False
        UseOwnFont = False
        UseRestSpace = True
        Visible = True
        WholeRow = True
      end>
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    Images = CentralImageListMod.ImageList
    PopupMenuLinks = <>
    UseSystemFont = False
    Left = 232
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
    object siFile: TdxBarSubItem
      Caption = 'File'
      Category = 0
      Visible = ivAlways
      ImageIndex = 77
      ItemLinks = <
        item
          Item = dxSaveZip
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxCancel
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxImport
          Visible = True
        end>
    end
    object siEdit: TdxBarSubItem
      Caption = 'Edit'
      Category = 0
      Visible = ivAlways
      ImageIndex = 77
      ItemLinks = <
        item
          Item = dxAddItem
          Visible = True
        end
        item
          Item = dxAddFolder
          Visible = True
        end
        item
          Item = dxRename
          Visible = True
        end
        item
          Item = dxDelete
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxInsert
          Visible = True
        end
        item
          Item = dxCopyCode
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxCollapseAll
          Visible = True
        end
        item
          Item = dxExpandAll
          Visible = True
        end>
    end
    object siPopUp: TdxBarSubItem
      Caption = 'PopUp'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Item = dxInsert
          Visible = True
        end
        item
          Item = dxCopyCode
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxAddItem
          Visible = True
        end
        item
          Item = dxAddFolder
          Visible = True
        end
        item
          Item = dxRename
          Visible = True
        end
        item
          Item = dxDelete
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxCancel
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxCollapseAll
          Visible = True
        end
        item
          Item = dxExpandAll
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxSaveZip
          Visible = True
        end
        item
          Item = dxImport
          Visible = True
        end>
    end
    object dxCollapseAll: TdxBarButton
      Action = CollapseAllAction
      Category = 0
      Hint = 'Collapse all'
    end
    object dxAddItem: TdxBarButton
      Action = AddItemAction
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxAddFolder: TdxBarButton
      Action = AddFolderAction
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxDelete: TdxBarButton
      Action = DeleteAction
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxExpandAll: TdxBarButton
      Action = ExpandAllAction
      Category = 0
      Hint = 'Expand all'
    end
    object dxSaveZip: TdxBarButton
      Action = ExportLibAction
      Category = 0
      Hint = 'Save ZIP as'
    end
    object dxImport: TdxBarButton
      Action = ImportLibAction
      Category = 0
    end
    object dxInsert: TdxBarButton
      Action = InsertCodeAction
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxCopyCode: TdxBarButton
      Action = CopyCodeAction
      Category = 0
      Hint = 'Copy code'
    end
    object dxRename: TdxBarButton
      Action = RenameAction
      Category = 0
    end
    object dxCancel: TdxBarButton
      Action = CancelAction
      Category = 0
    end
  end
  object LibSource: TMemoSource
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
  object LibActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 136
    Top = 112
    object CollapseAllAction: TAction
      Caption = '&Collapse all'
      OnExecute = CollapseAllActionExecute
      OnUpdate = EnabledIfNotBusy
    end
    object AddItemAction: TAction
      Caption = '&Add Item'
      Enabled = False
      Hint = 'Add item in the current node'
      ImageIndex = 73
      OnExecute = AddItemActionExecute
      OnUpdate = AddItemActionUpdate
    end
    object AddFolderAction: TAction
      Caption = 'Add &folder'
      Hint = 'Add a new folder'
      ImageIndex = 74
      OnExecute = AddFolderActionExecute
      OnUpdate = AddFolderActionUpdate
    end
    object DeleteAction: TAction
      Caption = '&Delete'
      Hint = 'Delete Item'
      ImageIndex = 72
      OnExecute = DeleteActionExecute
      OnUpdate = TrueIfFocusedUpdate
    end
    object ExpandAllAction: TAction
      Caption = '&Expand all'
      OnExecute = ExpandAllActionExecute
      OnUpdate = EnabledIfNotBusy
    end
    object ExportLibAction: TAction
      Caption = '&Save ZIP as...'
      OnExecute = ExportLibActionExecute
      OnUpdate = EnabledIfNotBusy
    end
    object ImportLibAction: TAction
      Caption = '&Import OPL File'
      OnExecute = ImportLibActionExecute
      OnUpdate = EnabledIfNotBusy
    end
    object InsertCodeAction: TAction
      Caption = 'I&nsert'
      Hint = 'Inserts Snippet in Editor'
      ImageIndex = 75
      OnExecute = InsertCodeActionExecute
      OnUpdate = TrueIfFocAndText
    end
    object CopyCodeAction: TAction
      Caption = 'C&opy code'
      ImageIndex = 76
      OnExecute = CopyCodeActionExecute
      OnUpdate = TrueIfFocAndText
    end
    object RenameAction: TAction
      Caption = '&Rename'
      OnExecute = RenameActionExecute
      OnUpdate = RenameActionUpdate
    end
    object CancelAction: TAction
      Caption = 'Cance&l changes'
      OnExecute = CancelActionExecute
      OnUpdate = CancelActionUpdate
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'zip'
    Filter = 'ZIP File|*.zip'
    Options = [ofHideReadOnly, ofPathMustExist, ofCreatePrompt, ofEnableSizing]
    Title = 'Open Zip File'
    Left = 424
    Top = 56
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'zip'
    Filter = 'ZIP File|*.zip'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Title = 'Save Zip file'
    Left = 424
    Top = 112
  end
  object Zip: TZipMaster
    Verbose = False
    Trace = False
    AddCompLevel = 9
    AddOptions = []
    ExtrOptions = []
    Unattended = False
    SFXPath = 'ZipSFX.bin'
    SFXOverWriteMode = OvrConfirm
    SFXCaption = 'Self-extracting Archive'
    KeepFreeOnDisk1 = 0
    HowToDelete = htdFinal
    VersionInfo = '1.60 N'
    AddStoreSuffixes = [assGIF, assPNG, assZ, assZIP, assZOO, assARC, assLZH, assARJ, assTAZ, assTGZ, assLHA, assRAR, assACE, assCAB, assGZ, assGZIP, assJAR]
    OnDirUpdate = ZipDirUpdate
    OnProgress = ZipProgress
    OnMessage = ZipMessage
    Left = 344
    Top = 56
  end
  object OPLOpenDialog: TOpenDialog
    DefaultExt = 'opl'
    Filter = 'Optiperl Library Files|*.opl'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open OptiPerl Library File'
    Left = 424
    Top = 168
  end
  object PopupMenu: TdxBarPopupMenu
    BarManager = BarManager
    ItemLinks = <
      item
        Item = dxAddItem
        Visible = True
      end
      item
        Item = dxDelete
        Visible = True
      end
      item
        BeginGroup = True
        Item = dxRename
        Visible = True
      end
      item
        BeginGroup = True
        Item = dxCollapseAll
        Visible = True
      end
      item
        Item = dxExpandAll
        Visible = True
      end>
    UseOwnFont = False
    Left = 240
    Top = 120
  end
end
