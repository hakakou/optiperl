object PodViewerForm: TPodViewerForm
  Left = 321
  Top = 314
  HelpContext = 420
  AutoScroll = False
  Caption = 'Pod Xtractor'
  ClientHeight = 288
  ClientWidth = 485
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 131
    Top = 26
    Width = 4
    Height = 262
    AutoSnap = False
    MinSize = 1
  end
  object VST: TVirtualStringTree
    Left = 0
    Top = 26
    Width = 131
    Height = 262
    Align = alLeft
    Colors.HotColor = clHighlight
    Colors.UnfocusedSelectionColor = clInactiveBorder
    Colors.UnfocusedSelectionBorderColor = clInactiveBorder
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
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoTristateTracking, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowRoot, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect, toRightClickSelect]
    TreeOptions.StringOptions = []
    OnFocusChanged = VSTFocusChanged
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    OnPaintText = VSTPaintText
    Columns = <>
  end
  object WebPanel: TPanel
    Left = 135
    Top = 26
    Width = 350
    Height = 262
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    OnResize = WebPanelResize
  end
  object SearchFile: TFindFile
    Filename = '*.*'
    OnFound = SearchFileFound
    OnComplete = SearchFileEnded
    Left = 56
    Top = 128
  end
  object Pcre: TDIPcre
    CompileOptionBits = 4
    MatchPattern = '^=head(\d) (.*)$'
    Left = 64
    Top = 192
  end
  object tagPcre: TDIPcre
    CompileOptionBits = 4
    MatchPattern = '[A-Z]<([^>]+)>'
    Left = 120
    Top = 192
  end
  object ActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 224
    Top = 192
    object FindAction: TAction
      Caption = '&Find'
      Hint = 'Open find dialog'
      ImageIndex = 118
      OnExecute = FindActionExecute
    end
    object BackAction: TAction
      Caption = '&Back'
      Hint = 'Back'
      ImageIndex = 108
      OnExecute = BackActionExecute
    end
    object ForwardAction: TAction
      Caption = 'Fo&rward'
      Hint = 'Forward'
      ImageIndex = 109
      OnExecute = ForwardActionExecute
    end
    object FindPodFilesAction: TAction
      Caption = 'F&ind Pod Files'
      Hint = 'Search for pod files'
      ImageIndex = 26
      OnExecute = FindPodFilesActionExecute
    end
    object OpenFileAction: TAction
      Caption = '&Open File'
      Hint = 'Open pod file'
      ImageIndex = 34
      OnExecute = OpenFileActionExecute
    end
    object RefreshAction: TAction
      Caption = 'Refresh'
      ImageIndex = 59
      OnExecute = RefreshActionExecute
      OnUpdate = RefreshActionUpdate
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'pod'
    Filter = 
      'POD Files (*.pod)|*.pod|Perl Scripts (*.cgi;*.pl;*.pm;*.plx)|*.c' +
      'gi;*.pl;*.pm;*.plx|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Dialog'
    Left = 224
    Top = 48
  end
  object FormStorage: TJvFormStorage
    Options = []
    StoredProps.Strings = (
      'VST.Width')
    StoredValues = <>
    Left = 64
    Top = 64
  end
  object ApplicationEvents: TApplicationEvents
    OnMessage = ApplicationEventsMessage
    Left = 336
    Top = 120
  end
  object BarManager: TdxBarManager
    AllowCallFromAnotherForm = True
    AlwaysSaveText = True
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
        FloatLeft = 469
        FloatTop = 419
        FloatClientWidth = 23
        FloatClientHeight = 22
        IsMainMenu = True
        ItemLinks = <
          item
            Item = bOpen
            Visible = True
          end
          item
            Item = bFindPodFiles
            Visible = True
          end
          item
            BeginGroup = True
            Item = bBack
            Visible = True
          end
          item
            Item = bForward
            Visible = True
          end
          item
            Item = Refresh
            Visible = True
          end
          item
            BeginGroup = True
            Item = bFind
            Visible = True
          end
          item
            BeginGroup = True
            Item = cbPods
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
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = False
    Left = 344
    Top = 64
    DockControlHeights = (
      0
      0
      26
      0)
    object bOpen: TdxBarButton
      Action = OpenFileAction
      Category = 0
    end
    object bFindPodFiles: TdxBarButton
      Action = FindPodFilesAction
      Category = 0
    end
    object bBack: TdxBarButton
      Action = BackAction
      Category = 0
    end
    object bForward: TdxBarButton
      Action = ForwardAction
      Category = 0
    end
    object Refresh: TdxBarButton
      Action = RefreshAction
      Category = 0
    end
    object bFind: TdxBarButton
      Action = FindAction
      Category = 0
    end
    object cbPods: TdxBarCombo
      Caption = '&Recent'
      Category = 0
      Hint = 'Recent POD files'
      Visible = ivAlways
      OnCurChange = cbPodsCurChange
      Width = 200
      DropDownCount = 15
      ItemIndex = -1
    end
  end
end
