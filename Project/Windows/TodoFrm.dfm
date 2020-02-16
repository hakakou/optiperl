object TodoForm: TTodoForm
  Left = 273
  Top = 419
  Width = 428
  Height = 199
  HelpContext = 360
  BorderStyle = bsSizeToolWin
  Caption = 'To-Do List'
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
  PixelsPerInch = 96
  TextHeight = 13
  object VST: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 420
    Height = 168
    Align = alClient
    CheckImageKind = ckLightTick
    ClipboardFormats.Strings = (
      'Virtual Tree Data')
    DragMode = dmAutomatic
    DragOperations = [doMove]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoHotTrack, hoShowSortGlyphs, hoVisible]
    Header.SortDirection = sdDescending
    Header.Style = hsXPStyle
    HintAnimation = hatNone
    IncrementalSearch = isAll
    ParentShowHint = False
    PopupMenu = PopupMenu
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toCheckSupport, toEditable, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
    TreeOptions.StringOptions = []
    OnChecked = VSTChecked
    OnCompareNodes = VSTCompareNodes
    OnDblClick = VSTDblClick
    OnDragOver = VSTDragOver
    OnDragDrop = VSTDragDrop
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    OnPaintText = VSTPaintText
    OnHeaderClick = VSTHeaderClick
    OnLoadNode = VSTLoadNode
    OnNewText = VSTNewText
    OnSaveNode = VSTSaveNode
    Columns = <
      item
        Position = 0
        Width = 168
        WideText = 'Action'
      end
      item
        Position = 1
        Width = 53
        WideText = 'Priority'
      end
      item
        Position = 2
        Width = 102
        WideText = 'Owner'
      end
      item
        Position = 3
        Width = 92
        WideText = 'Category'
      end>
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 136
    Top = 88
    object NewItem: TMenuItem
      Caption = '&New item'
      OnClick = NewitemClick
    end
    object EditItem: TMenuItem
      Caption = '&Edit item'
      OnClick = EditItemClick
    end
    object DeleteItem: TMenuItem
      Caption = '&Delete Item'
      OnClick = DeleteItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SortItem: TMenuItem
      Caption = '&Sort'
      OnClick = SortItemClick
    end
  end
  object CSV: THKCSVParser
    QuoteChar = '"'
    Delimiter = ','
    OnSetData = CSVSetData
    Left = 248
    Top = 80
  end
end
