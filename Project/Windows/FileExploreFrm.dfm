object FileExploreForm: TFileExploreForm
  Left = 473
  Top = 258
  HelpContext = 760
  AutoScroll = False
  Caption = 'File Explorer'
  ClientHeight = 322
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object VET: TVirtualExplorerTreeview
    Left = 0
    Top = 26
    Width = 383
    Height = 296
    Active = True
    Align = alClient
    ButtonFillMode = fmShaded
    Colors.SelectionRectangleBlendColor = clMoneyGreen
    ColumnDetails = cdUser
    DefaultNodeHeight = 17
    DragHeight = 250
    DragWidth = 150
    DrawSelectionMode = smBlendedRectangle
    FileObjects = [foFolders, foNonFolders, foHidden]
    FileSizeFormat = fsfActual
    FileSort = fsFileType
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.Style = hsFlatButtons
    HintMode = hmHint
    LineMode = lmBands
    ParentColor = False
    ParentShowHint = False
    RootFolder = rfPersonal
    ShowHint = True
    TabOrder = 0
    TabStop = True
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSpanColumns, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick]
    TreeOptions.PaintOptions = [toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toMultiSelect, toSiblingSelectConstraint]
    TreeOptions.StringOptions = []
    TreeOptions.VETFolderOptions = [toFoldersExpandable, toHideRootFolder]
    TreeOptions.VETShellOptions = [toContextMenus, toDragDrop, toShellHints, toShellColumnMenu]
    TreeOptions.VETSyncOptions = []
    TreeOptions.VETMiscOptions = [toPersistentColumns, toExecuteOnDblClk]
    TreeOptions.VETImageOptions = [toImages]
    OnRootChange = VETRootChange
    Columns = <
      item
        Position = 0
        Width = 150
        ColumnDetails = cdFileName
        WideText = 'Name'
      end
      item
        Alignment = taRightJustify
        Position = 1
        Width = 70
        ColumnDetails = cdSize
        WideText = 'Size'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 2
        Width = 120
        ColumnDetails = cdType
        WideText = 'Type'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 3
        Width = 60
        ColumnDetails = cdAttributes
        WideText = 'Attributes'
      end
      item
        Position = 4
        Width = 130
        ColumnDetails = cdModified
        WideText = 'Modified'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 5
        Width = 180
        ColumnDetails = cdAccessed
        WideText = 'Accessed'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 6
        Width = 120
        ColumnDetails = cdCreated
        WideText = 'Created'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 7
        Width = 80
        ColumnDetails = cdDOSName
        WideText = 'DOS Name'
      end>
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
            Item = btnDesktop
            Visible = True
          end
          item
            Item = btnNetwork
            Visible = True
          end
          item
            Item = siDrives
            Visible = True
          end
          item
            Item = btnZoom
            Visible = True
          end
          item
            BeginGroup = True
            Item = siFavorites
            Visible = True
          end
          item
            BeginGroup = True
            Item = btnCurrent
            Visible = True
          end
          item
            Item = btnProject
            Visible = True
          end
          item
            BeginGroup = True
            Item = btnFolder
            Visible = True
          end
          item
            BeginGroup = True
            Item = btnUp
            Visible = True
          end
          item
            Item = btnRefresh
            Visible = True
          end
          item
            BeginGroup = True
            Item = btnSearch
            Visible = True
          end>
        MultiLine = True
        Name = 'Main menu'
        OneOnRow = True
        Row = 0
        ShowMark = False
        UseOwnFont = False
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
    Left = 192
    Top = 200
    DockControlHeights = (
      0
      0
      26
      0)
    object siFavorites: TdxBarSubItem
      Caption = 'Favorites'
      Category = 0
      Hint = 'List of favorite folders'
      Visible = ivAlways
      ImageIndex = 60
      ItemLinks = <
        item
          Item = liFavorites
          Visible = True
        end
        item
          BeginGroup = True
          Item = btnAddFav
          Visible = True
        end
        item
          Item = btnRemoveFav
          Visible = True
        end>
    end
    object liFavorites: TdxBarListItem
      Caption = 'Favorites'
      Category = 0
      Visible = ivAlways
      OnClick = liFavoritesClick
      OnGetData = liFavoritesGetData
      ShowCheck = True
    end
    object siDrives: TdxBarSubItem
      Caption = 'Drives'
      Category = 0
      Hint = 'List of drives'
      Visible = ivAlways
      ImageIndex = 62
      ShowCaption = False
      ItemLinks = <
        item
          Item = liDrives
          Visible = True
        end>
    end
    object liDrives: TdxBarListItem
      Caption = 'Drives'
      Category = 0
      Visible = ivAlways
      OnClick = liDrivesClick
      OnGetData = liDrivesGetData
    end
    object btnDesktop: TdxBarButton
      Caption = 'Show desktop'
      Category = 0
      Hint = 'Shows desktop'
      Visible = ivAlways
      ImageIndex = 61
      OnClick = btnDesktopClick
    end
    object btnNetwork: TdxBarButton
      Caption = 'Show network'
      Category = 0
      Hint = 'Shows network'
      Visible = ivAlways
      ImageIndex = 63
      OnClick = btnNetworkClick
    end
    object btnCurrent: TdxBarButton
      Caption = 'Current folder'
      Category = 0
      Hint = 'Selects folder from current script'
      Visible = ivAlways
      ImageIndex = 8
      OnClick = btnCurrentClick
    end
    object btnProject: TdxBarButton
      Caption = 'Project folder'
      Category = 0
      Hint = 'Selects folder from current project'
      Visible = ivAlways
      ImageIndex = 24
      OnClick = btnProjectClick
    end
    object btnZoom: TdxBarButton
      Caption = 'Zoom selected'
      Category = 0
      Hint = 'Use selected folder as root of tree view'
      Visible = ivAlways
      ImageIndex = 26
      OnClick = btnZoomClick
    end
    object btnUp: TdxBarButton
      Caption = 'Up level'
      Category = 0
      Hint = 'Go to parent folder'
      Visible = ivAlways
      ImageIndex = 66
      OnClick = btnUpClick
    end
    object btnFolder: TdxBarButton
      Caption = 'New folder'
      Category = 0
      Hint = 'Create new folder'
      Visible = ivAlways
      ImageIndex = 58
      OnClick = btnFolderClick
    end
    object btnRefresh: TdxBarButton
      Caption = 'Refresh tree'
      Category = 0
      Hint = 'Refresh tree'
      Visible = ivAlways
      ImageIndex = 67
      OnClick = btnRefreshClick
    end
    object btnSearch: TdxBarButton
      Caption = 'Search'
      Category = 0
      Hint = 'Search & replace in selected files and folders'
      Visible = ivAlways
      ImageIndex = 118
      PaintStyle = psCaptionGlyph
      OnClick = btnSearchClick
    end
    object btnAddFav: TdxBarButton
      Caption = 'Add to favorites'
      Category = 0
      Hint = 'Add to favorites'
      Visible = ivAlways
      ImageIndex = 23
      OnClick = btnAddFavClick
    end
    object btnRemoveFav: TdxBarButton
      Caption = 'Remove from favorites'
      Category = 0
      Hint = 'Remove from favorites'
      Visible = ivAlways
      ImageIndex = 22
      OnClick = btnRemoveFavClick
    end
  end
  object RecentMenu: TPopupMenu
    Left = 88
    Top = 176
    object N1: TMenuItem
      Caption = '-'
    end
    object AddtoRecentItem: TMenuItem
      AutoHotkeys = maAutomatic
      Caption = 'Add to favorites'
      OnClick = btnAddFavClick
    end
    object RemoveFromFavoritesItem: TMenuItem
      Caption = 'Remove from favorites'
      OnClick = btnRemoveFavClick
    end
  end
end
