object FTPSelectForm: TFTPSelectForm
  Left = 326
  Top = 287
  HelpContext = 6730
  BorderStyle = bsDialog
  Caption = 'Select remote file'
  ClientHeight = 338
  ClientWidth = 568
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormExDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar: TStatusBar
    Left = 0
    Top = 318
    Width = 568
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Panels = <>
    SimplePanel = True
    SizeGrip = False
    UseSystemFont = False
  end
  object Panel: TPanel
    Left = 0
    Top = 26
    Width = 568
    Height = 258
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object VST: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 568
      Height = 258
      Align = alClient
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Shell Dlg 2'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDrag, hoHotTrack, hoShowSortGlyphs, hoVisible]
      Header.SortDirection = sdDescending
      Header.Style = hsXPStyle
      HintMode = hmHint
      Images = FTPMod.SysImages
      IncrementalSearch = isAll
      ParentShowHint = False
      PopupMenu = PopupMenu
      ShowHint = True
      TabOrder = 0
      TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect]
      TreeOptions.StringOptions = []
      OnClick = VSTClick
      OnCompareNodes = VSTCompareNodes
      OnCreateDataObject = VSTCreateDataObject
      OnCreateDragManager = VSTCreateDragManager
      OnDblClick = VSTDblClick
      OnDragAllowed = VSTDragAllowed
      OnDragOver = VSTDragOver
      OnDragDrop = VSTDragDrop
      OnFreeNode = VSTFreeNode
      OnGetText = VSTGetText
      OnPaintText = VSTPaintText
      OnGetImageIndex = VSTGetImageIndex
      OnGetHint = VSTGetHint
      OnGetNodeDataSize = VSTGetNodeDataSize
      OnHeaderClick = VSTHeaderClick
      Columns = <
        item
          Position = 0
          Width = 135
          WideText = 'Filename'
        end
        item
          Position = 1
          Width = 70
          WideText = 'Size'
        end
        item
          Position = 2
          Width = 100
          WideText = 'Modified'
        end
        item
          Position = 3
          Width = 70
          WideText = 'Attributes'
        end
        item
          Position = 4
          Width = 140
          WideText = 'Description'
        end>
    end
  end
  object BotPanel: TPanel
    Left = 0
    Top = 284
    Width = 568
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    DesignSize = (
      568
      34)
    object lblFilename: TLabel
      Left = 8
      Top = 11
      Width = 45
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = '&Filename:'
      FocusControl = edFilename
    end
    object edFilename: TEdit
      Left = 59
      Top = 7
      Width = 158
      Height = 21
      Anchors = [akLeft, akBottom]
      TabOrder = 0
    end
    object btnOK: TButton
      Left = 408
      Top = 5
      Width = 75
      Height = 25
      Action = OKAction
      Anchors = [akRight, akBottom]
      TabOrder = 1
    end
    object btnCancel: TButton
      Left = 489
      Top = 5
      Width = 75
      Height = 25
      Action = CancelAction
      Anchors = [akRight, akBottom]
      Cancel = True
      TabOrder = 2
    end
  end
  object ActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 320
    Top = 72
    object OKAction: TAction
      Caption = '&OK'
      OnExecute = OKActionExecute
      OnUpdate = OKActionUpdate
    end
    object CancelAction: TAction
      Caption = '&Cancel'
      OnExecute = CancelActionExecute
      OnUpdate = NotBusyUpdate
    end
    object ConnectAction: TAction
      Caption = 'Conn&ect'
      Hint = 'Connect to selected session'
      ImageIndex = 42
      OnExecute = ConnectActionExecute
      OnUpdate = ConnectActionUpdate
    end
    object SessionsAction: TAction
      Caption = 'Se&tup Sessions'
      Hint = 'Setup sessions'
      ImageIndex = 46
      OnExecute = SessionsActionExecute
      OnUpdate = NotConnectedUpdate
    end
    object NewFolderAction: TAction
      Caption = '&New Folder'
      Hint = 'Create new folder'
      ImageIndex = 58
      OnExecute = NewFolderActionExecute
      OnUpdate = ConnectedAndNotBusyUpdate
    end
    object NewFileAction: TAction
      Caption = 'New File'
      Hint = 'Create a new file'
      ImageIndex = 31
      OnExecute = NewFileActionExecute
      OnUpdate = ConnectedAndNotBusyUpdate
    end
    object RefreshAction: TAction
      Caption = '&Refresh'
      Hint = 'Refresh list'
      ImageIndex = 59
      OnExecute = RefreshActionExecute
      OnUpdate = ConnectedAndNotBusyUpdate
    end
    object UpLevelAction: TAction
      Caption = '&Up Level'
      Hint = 'Parent folder'
      ImageIndex = 56
      OnExecute = UpLevelActionExecute
      OnUpdate = ConnectedAndNotBusyUpdate
    end
    object AbortAction: TAction
      Caption = '&Abort'
      Hint = 'Abort current task'
      ImageIndex = 57
      OnExecute = AbortActionExecute
      OnUpdate = ConnectedAndBusyUpdate
    end
    object DisconnectAction: TAction
      Caption = 'D&isconnect'
      Hint = 'Disconnect'
      ImageIndex = 43
      OnExecute = DisconnectActionExecute
      OnUpdate = DisconnectActionUpdate
    end
    object chModAction: TAction
      Caption = 'C&hange Mode'
      Hint = 'Chmod'
      ImageIndex = 91
      OnExecute = chModActionExecute
      OnUpdate = ConnectedNotbusySelectedUpdate
    end
    object DelAction: TAction
      Caption = '&Delete'
      Hint = 'Delete'
      ImageIndex = 55
      OnExecute = DelActionExecute
      OnUpdate = ConnectedNotbusySelectedUpdate
    end
    object CustomAction: TAction
      Caption = '&Send Custom Command'
      Hint = 'Send a custom command'
      OnExecute = CustomActionExecute
      OnUpdate = ConnectedAndNotBusyUpdate
    end
    object RenameAction: TAction
      Caption = 'Rena&me'
      Hint = 'Rename selected file'
      OnExecute = RenameActionExecute
      OnUpdate = ConnectedNotbusySelectedUpdate
    end
    object OpenAction: TAction
      Caption = 'O&pen in Editor'
      Hint = 'Open in editor without closing this window'
      ImageIndex = 8
      OnExecute = OpenActionExecute
      OnUpdate = OpenUpdate
    end
    object LogAction: TAction
      Caption = '&Log'
      Hint = 'View log'
      ImageIndex = 88
      OnExecute = LogActionExecute
    end
    object OpenSymDir: TAction
      Caption = '&Go to Directory'
      OnExecute = OpenSymDirExecute
      OnUpdate = SymLinkUpdate
    end
    object AddFavAction: TAction
      Caption = 'Add to Favorites'
      ImageIndex = 23
      OnExecute = AddFavActionExecute
      OnUpdate = ConnectedAndNotBusyUpdate
    end
    object RemFavAction: TAction
      Caption = 'Remove from Favorites'
      ImageIndex = 22
      OnExecute = RemFavActionExecute
      OnUpdate = ConnectedAndNotBusyUpdate
    end
    object DownloadAction: TAction
      Caption = 'Download'
      Hint = 'Download selected files'
      ImageIndex = 53
      OnExecute = DownloadActionExecute
      OnUpdate = OpenUpdate
    end
  end
  object PopupMenu: TPopupMenu
    Left = 248
    Top = 136
    object Abort1: TMenuItem
      Action = OpenAction
    end
    object Openineditorasfile2: TMenuItem
      Action = OpenSymDir
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Rename1: TMenuItem
      Action = RenameAction
    end
    object Delete1: TMenuItem
      Action = DelAction
    end
    object NewFolder1: TMenuItem
      Action = NewFolderAction
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object CHMod1: TMenuItem
      Action = chModAction
    end
    object Sendcustomcommand1: TMenuItem
      Action = CustomAction
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Action = RefreshAction
    end
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
        FloatLeft = 435
        FloatTop = 544
        FloatClientWidth = 371
        FloatClientHeight = 22
        IsMainMenu = True
        ItemLinks = <
          item
            Item = cbSession
            Visible = True
          end
          item
            Item = dxBarButton1
            Visible = True
          end
          item
            Item = dxBarButton7
            Visible = True
          end
          item
            Item = dxBarButton2
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxBarButton5
            Visible = True
          end
          item
            Item = dxBarButton4
            Visible = True
          end
          item
            Item = dxBarButton6
            Visible = True
          end
          item
            Item = dxBarButton8
            Visible = True
          end
          item
            BeginGroup = True
            Item = siFavorites
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxBarButton13
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxBarButton12
            Visible = True
          end
          item
            Item = dxBarButton17
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxBarButton3
            Visible = True
          end
          item
            Item = dxBarButton18
            Visible = True
          end
          item
            Item = dxBarButton9
            Visible = True
          end
          item
            BeginGroup = True
            Item = dxBarButton10
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
    Left = 48
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarButton1: TdxBarButton
      Action = ConnectAction
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = SessionsAction
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = NewFolderAction
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = RefreshAction
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = UpLevelAction
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = AbortAction
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = DisconnectAction
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = chModAction
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = DelAction
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = CustomAction
      Category = 0
      ImageIndex = 18
    end
    object dxBarButton11: TdxBarButton
      Action = RenameAction
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = OpenAction
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Action = LogAction
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = OpenSymDir
      Category = 0
      Hint = 'Go to Directory'
    end
    object cbSession: TdxBarCombo
      Caption = 'Sessions'
      Category = 0
      Hint = 'Sessions'
      Visible = ivAlways
      OnCurChange = cbSessionCurChange
      Width = 115
      OnDropDown = cbSessionDropDown
      DropDownCount = 20
      ItemIndex = -1
    end
    object siFavorites: TdxBarSubItem
      Caption = 'Favorites'
      Category = 0
      Visible = ivAlways
      ImageIndex = 60
      ItemLinks = <
        item
          Item = liFavorites
          Visible = True
        end
        item
          BeginGroup = True
          Item = dxBarButton15
          Visible = True
        end
        item
          Item = dxBarButton16
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
    object dxBarButton15: TdxBarButton
      Action = AddFavAction
      Category = 0
      Hint = 'Add to Favorites'
    end
    object dxBarButton16: TdxBarButton
      Action = RemFavAction
      Category = 0
      Hint = 'Remove from Favorites'
    end
    object dxBarButton17: TdxBarButton
      Action = DownloadAction
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Action = NewFileAction
      Category = 0
    end
  end
  object DropFileSource: TDropFileSource
    Dragtypes = [dtCopy]
    ImageIndex = 0
    ShowImage = False
    ImageHotSpotX = 16
    ImageHotSpotY = 16
    Left = 112
    Top = 168
  end
end
