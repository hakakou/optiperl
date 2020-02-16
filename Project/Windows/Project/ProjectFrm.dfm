object ProjectForm: TProjectForm
  Left = 355
  Top = 197
  Width = 444
  Height = 221
  HelpContext = 720
  BorderStyle = bsSizeToolWin
  Caption = 'Project Manager'
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
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object VST: TVirtualStringTree
    Left = 0
    Top = 26
    Width = 436
    Height = 161
    Align = alClient
    DragOperations = [doCopy]
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoDrag, hoHotTrack, hoShowSortGlyphs, hoVisible]
    Header.SortDirection = sdDescending
    Header.Style = hsXPStyle
    HintMode = hmHint
    Images = ImageList
    ParentShowHint = False
    PopupMenu = PopupMenu
    ShowHint = True
    TabOrder = 0
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.SelectionOptions = [toMultiSelect, toRightClickSelect]
    TreeOptions.StringOptions = []
    OnCompareNodes = VSTCompareNodes
    OnCreateDataObject = VSTCreateDataObject
    OnDblClick = VSTDblClick
    OnDragAllowed = VSTDragAllowed
    OnDragOver = VSTDragOver
    OnDragDrop = VSTDragDrop
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    OnPaintText = VSTPaintText
    OnGetImageIndex = VSTGetImageIndex
    OnGetHint = VSTGetHint
    OnHeaderClick = VSTHeaderClick
    OnKeyDown = VSTKeyDown
    Columns = <
      item
        Position = 0
        Width = 160
        WideText = 'File'
      end
      item
        Alignment = taCenter
        Position = 1
        Width = 40
        WideText = 'Mode'
      end
      item
        Alignment = taCenter
        Position = 2
        Width = 60
        WideText = 'Publish'
      end
      item
        Alignment = taCenter
        Position = 3
        Width = 60
        WideText = 'Transfer'
      end
      item
        Alignment = taCenter
        Position = 4
        Width = 110
        WideText = 'Status'
      end>
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'opj'
    Filter = 'OptiPerl Projects (*.opj)|*.opj'
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Dialog'
    Left = 176
    Top = 112
  end
  object ActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 24
    Top = 56
    object NewProjectAction: THKAction
      Category = 'Project'
      Caption = '&New'
      Hint = 'New project'
      ImageIndex = 24
      OnExecute = NewProjectActionExecute
      UserData = 0
    end
    object OpenProjectAction: THKAction
      Category = 'Project'
      Caption = '&Open...'
      Hint = 'Open project'
      ImageIndex = 25
      OnExecute = OpenProjectActionExecute
      UserData = 0
    end
    object SaveProjectAction: THKAction
      Category = 'Project'
      Caption = '&Save'
      Hint = 'Save project'
      ImageIndex = 35
      OnExecute = SaveProjectActionExecute
      UserData = 0
    end
    object SaveProjectAsAction: THKAction
      Category = 'Project'
      Caption = 'Save &As...'
      Hint = 'Save project as...'
      OnExecute = SaveProjectAsActionExecute
      UserData = 0
    end
    object AddCurrentToProjectAction: THKAction
      Category = 'Project'
      Caption = 'A&dd'
      Hint = 'Add current file to project'
      ImageIndex = 23
      OnExecute = AddCurrentToProjectActionExecute
      UserData = 0
    end
    object RemoveFromProjectAction: THKAction
      Category = 'Project'
      Caption = '&Remove'
      Hint = 'Remove selected file from project'
      ImageIndex = 22
      OnExecute = RemoveFromProjectActionExecute
      OnUpdate = RemoveFromProjectActionUpdate
      UserData = 0
    end
    object AddToProjectAction: THKAction
      Category = 'Project'
      Caption = 'Add &Files to Project...'
      Hint = 'Add files to project'
      ImageIndex = 26
      OnExecute = AddToProjectActionExecute
      UserData = 0
    end
    object ImportFolderAction: THKAction
      Category = 'Project'
      Caption = '&Import Entire Folder...'
      Hint = 'Import an entire folder with subfolders into the project'
      ImageIndex = 58
      OnExecute = ImportFolderActionExecute
      UserData = 0
    end
    object ShowManagerAction: THKAction
      Category = 'Project'
      Caption = 'Show Project &Manager'
      Hint = 'Show project manager'
      ImageIndex = 28
      ShortCut = 113
      OnExecute = ShowManagerActionExecute
      UserData = 0
    end
    object SearchInProjectAction: THKAction
      Category = 'Project'
      Caption = 'Searc&h && Replace in Project...'
      Hint = 'Search & replace in project'#39's files using regular expression'
      ImageIndex = 32
      OnExecute = SearchInProjectActionExecute
      OnUpdate = SearchInProjectActionUpdate
      UserData = 0
    end
    object ProjectOptionsAction: THKAction
      Category = 'Project'
      Caption = 'Op&tions...'
      Hint = 'Project options'
      ImageIndex = 27
      ShortCut = 16497
      OnExecute = ProjectOptionsActionExecute
      UserData = 0
    end
    object PublishProjectAction: THKAction
      Category = 'Project'
      Caption = 'P&ublish'
      Hint = 'Publish project'
      ImageIndex = 20
      OnExecute = PublishProjectActionExecute
      UserData = 0
    end
    object ViewProjLogAction: THKAction
      Category = 'Project'
      Caption = '&Log'
      Hint = 'View logs from publishing'
      ImageIndex = 31
      OnExecute = ViewLogProjActionExecute
      OnUpdate = ViewProjLogActionUpdate
      UserData = 0
    end
    object PublishAllAgainAction: THKAction
      Category = 'Project'
      Caption = '&Publish All Again'
      Hint = 'Mark all files to be published again'
      OnExecute = PublishAllAgainActionExecute
      UserData = 0
    end
    object ProjOpenRemoteAction: THKAction
      Category = 'Project'
      Caption = 'Open as Remote Item'
      Hint = 
        'Retrieves the remote copy of the selected file and opens it in t' +
        'he editor'
      ImageIndex = 140
      OnExecute = ProjOpenRemoteActionExecute
      OnUpdate = ProjOpenRemoteActionUpdate
      UserData = 0
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'opj'
    Filter = 'OptiPerl Projects (*.opj)|*.opj'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Save Dialog'
    Left = 232
    Top = 120
  end
  object AddDialog: TOpenDialog
    DefaultExt = 'cgi'
    Filter = 
      'Perl Scripts (*.cgi;*.pl;*.pm)|*.cgi;*.pl;*.pm|HTML Documents (*' +
      '.htm; *.html)|*.htm;*.html|Configuration files (*.cfg;*.conf)|*.' +
      'cfg;*.conf|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Open Dialog'
    Left = 176
    Top = 56
  end
  object FMH: TFileMenuLite
    OnSaveDialog = FMHSaveDialog
    OnOpenDialog = FMHOpenDialog
    MaxList = 15
    DefaultFileName = 'NewProject.opj'
    OnQueryToSaveDialog = FMHQueryToSaveDialog
    OnOpen = FMHOpen
    OnSave = FMHSave
    OnNew = FMHNew
    OnNewFormCaption = FMHNewFormCaption
    Left = 232
    Top = 56
  end
  object PopupMenu: TPopupMenu
    Images = CentralImageListMod.ImageList
    OnPopup = PopupMenuPopup
    Left = 296
    Top = 120
    object miChangeMode: TMenuItem
      Caption = 'Change mode'
      OnClick = miChangeModeClick
    end
    object PublishToItem: TMenuItem
      Caption = 'Override destination directory'
      OnClick = PublishToItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miPublish: TMenuItem
      Caption = 'Publish'
      Checked = True
      OnClick = miPublishClick
    end
    object miPubAgain: TMenuItem
      Tag = 1
      Caption = 'Publish again'
      OnClick = miPubAgainClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miText: TMenuItem
      Caption = 'Text transfer'
      Checked = True
      OnClick = miTextBinaryClick
    end
    object miBinary: TMenuItem
      Tag = 1
      Caption = 'Binary transfer'
      OnClick = miTextBinaryClick
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object OpenasRemoteItem1: TMenuItem
      Action = ProjOpenRemoteAction
    end
  end
  object LibPcre: TDIPcre
    MatchPattern = '\x0d\x0ause\s+Lib\s*\(\s*([^\)]+)\s*\)\s*;\s*\x0d\x0a'
    Left = 352
    Top = 120
  end
  object ImageList: TImageList
    Left = 368
    Top = 56
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001001000000000000008
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604E2C672C672C672C672C672C67
      2C672C672C672C672C672C672C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604EF97F337FF37F337FF37F337F
      F37F337FF37F337F337F337F2C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604EF97FF37FF37FF37F337FF37F
      337FF37F337FF37F337F337F2C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604EF97FF37FF37FF37FF37FF37F
      F37F337FF37F337FF37F337F2C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604EF97FF37FF37FF37FF37FF37F
      337FF37F337FF37F337FF37F2C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604EF97FF37FF37FF37FF37FF37F
      F37FF37FF37F337FF37F337F2C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604EF97FF37FF37FF37FF37FF37F
      F37FF37F337FF37F337FF37F2C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604EF97FF37FF37FF37FF37FF37F
      F37FF37FF37FF37FF37F337F2C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7FFF7FFF7FFF7F00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604EF97FF97FF97FF97FF97FF97F
      F97FF97FF97FF97FF97FF37F2C6700000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7F00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000604E2C672C672C672C672C672C67
      2C67604E604E604E604E604E604E00000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7F0000FF7F000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000604EDE7BF97FF97FF37FF37F
      604E00000000000000000000000000000000000000000000FF7FFF7FFF7FFF7F
      FF7FFF7F00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000604E604E604E604E604E
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      8001C007000000000001C007000000000001C007000000000001C00700000000
      0001C007000000000001C007000000000001C007000000000001C00700000000
      0001C007000000000001C007000000000003C00F00000000807FC01F00000000
      C0FFC03F00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
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
        ItemLinks = <>
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
    UseSystemFont = True
    Left = 24
    Top = 112
    DockControlHeights = (
      0
      0
      26
      0)
    object siMain: TdxBarSubItem
      Caption = 'Project'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
  end
  object FormStorage: TJvFormStorage
    Options = []
    StoredProps.Strings = (
      'FMH.Recent')
    StoredValues = <>
    Left = 288
    Top = 72
  end
  object DropFileSource: TDropFileSource
    Dragtypes = [dtCopy]
    ImageIndex = 0
    ShowImage = False
    ImageHotSpotX = 16
    ImageHotSpotY = 16
    Left = 104
    Top = 112
  end
end
