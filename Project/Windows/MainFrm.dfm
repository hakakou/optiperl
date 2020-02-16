object OptiMainForm: TOptiMainForm
  Left = 373
  Top = 303
  AutoScroll = False
  Caption = 'OptiPerl'
  ClientHeight = 302
  ClientWidth = 767
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DockingSite: TaqDockingSite
    Left = 0
    Top = 75
    Width = 767
    Height = 227
    Align = alClient
    DockingManager = DockingManager
  end
  object BarManager: TdxBarManager
    AllowCallFromAnotherForm = True
    AlwaysSaveText = True
    AutoHideEmptyBars = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Bars = <
      item
        Caption = 'File'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 23
        DockingStyle = dsTop
        FloatLeft = 452
        FloatTop = 310
        FloatClientWidth = 120
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = bToggleIMEAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bNewAction
            Visible = True
          end
          item
            Item = bNewHtmlFileAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bOpenAction
            Visible = True
          end
          item
            Item = bSaveAction
            Visible = True
          end
          item
            Item = bSaveAllAction
            Visible = True
          end>
        Name = 'File'
        OneOnRow = False
        Row = 1
        UseOwnFont = False
        Visible = True
        WholeRow = False
      end
      item
        Caption = 'Edit'
        DockedDockingStyle = dsTop
        DockedLeft = 169
        DockedTop = 23
        DockingStyle = dsTop
        FloatLeft = 426
        FloatTop = 298
        FloatClientWidth = 222
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = bCutAction
            Visible = True
          end
          item
            Item = bCopyAction
            Visible = True
          end
          item
            Item = bPasteAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bUndoAction
            Visible = True
          end
          item
            Item = bRedoAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bFindAction
            Visible = True
          end
          item
            Item = bPatternSearchAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bOutdentAction
            Visible = True
          end
          item
            Item = bIndentAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bBrowseBackAction
            Visible = True
          end>
        Name = 'Edit'
        OneOnRow = False
        Row = 1
        UseOwnFont = False
        Visible = True
        WholeRow = False
      end
      item
        Caption = 'Debugger'
        DockedDockingStyle = dsTop
        DockedLeft = 385
        DockedTop = 49
        DockingStyle = dsTop
        FloatLeft = 448
        FloatTop = 296
        FloatClientWidth = 171
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = bStopDebAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bSingleStepAction
            Visible = True
          end
          item
            Item = bStepOverAction
            Visible = True
          end
          item
            Item = bReturnFromSubAction
            Visible = True
          end
          item
            Item = bContinueAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bToggleBreakAction
            Visible = True
          end>
        Name = 'Debugger'
        OneOnRow = False
        Row = 2
        UseOwnFont = False
        Visible = True
        WholeRow = False
      end
      item
        Caption = 'Run'
        DockedDockingStyle = dsTop
        DockedLeft = 577
        DockedTop = 49
        DockingStyle = dsTop
        FloatLeft = 536
        FloatTop = 331
        FloatClientWidth = 97
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = bRunBrowserAction
            Visible = True
          end
          item
            Item = bRunInConsoleAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bTestErrorAction
            Visible = True
          end
          item
            Item = bOpenAccessLogsAction
            Visible = True
          end>
        Name = 'Run'
        OneOnRow = False
        Row = 2
        UseOwnFont = False
        Visible = True
        WholeRow = False
      end
      item
        Caption = 'Tools'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 75
        DockingStyle = dsTop
        FloatLeft = 247
        FloatTop = 258
        FloatClientWidth = 161
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = bFileExplorerAction
            Visible = True
          end
          item
            Item = bCodeLibAction
            Visible = True
          end
          item
            Item = bPodExtractorAction
            Visible = True
          end
          item
            Item = bURLEncodeAction
            Visible = True
          end
          item
            Item = bPerlPrinterAction
            Visible = True
          end
          item
            Item = bRegExpTesterAction
            Visible = True
          end
          item
            Item = bPerlTidyAction
            Visible = True
          end>
        Name = 'Tools'
        OneOnRow = True
        Row = 3
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end
      item
        Caption = 'Browser'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 49
        DockingStyle = dsTop
        FloatLeft = 624
        FloatTop = 348
        FloatClientWidth = 240
        FloatClientHeight = 44
        ItemLinks = <
          item
            Item = bBackAction
            Visible = True
          end
          item
            Item = bForwardAction
            Visible = True
          end
          item
            Item = bStopAction
            Visible = True
          end
          item
            Item = bRefreshAction
            Visible = True
          end
          item
            Item = siFavorites
            Visible = True
          end
          item
            Item = cbUrls
            Visible = True
          end
          item
            Item = bOpenURLAction
            Visible = True
          end
          item
            Item = bOpenURLQueryAction
            Visible = True
          end>
        Name = 'Browser'
        OneOnRow = False
        Row = 2
        UseOwnFont = False
        Visible = True
        WholeRow = False
      end
      item
        Caption = 'Query'
        DockedDockingStyle = dsTop
        DockedLeft = 463
        DockedTop = 23
        DockingStyle = dsTop
        FloatLeft = 419
        FloatTop = 362
        FloatClientWidth = 228
        FloatClientHeight = 20
        ItemLinks = <
          item
            Item = cbGet
            Visible = True
          end>
        Name = 'Query'
        OneOnRow = False
        Row = 1
        UseOwnFont = False
        Visible = True
        WholeRow = False
      end
      item
        Caption = 'Main menu'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 318
        FloatTop = 331
        FloatClientWidth = 534
        FloatClientHeight = 19
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
            Item = siSearch
            Visible = True
          end
          item
            Item = siProject
            Visible = True
          end
          item
            Item = siDebug
            Visible = True
          end
          item
            Item = siRun
            Visible = True
          end
          item
            Item = siQuery
            Visible = True
          end
          item
            Item = siTools
            Visible = True
          end
          item
            Item = siBrowser
            Visible = True
          end
          item
            Item = siServer
            Visible = True
          end
          item
            Item = siWindows
            Visible = True
          end
          item
            Item = siHelp
            Visible = True
          end>
        MultiLine = True
        Name = 'Main menu'
        NotDocking = [dsNone, dsLeft, dsRight, dsBottom]
        OneOnRow = True
        Row = 0
        ShowMark = False
        UseOwnFont = False
        Visible = True
        WholeRow = False
      end
      item
        Caption = 'User tools'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 75
        DockingStyle = dsTop
        FloatLeft = 260
        FloatTop = 323
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <>
        Name = 'User tools'
        OneOnRow = True
        Row = 3
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end
      item
        Caption = 'Layout'
        DockedDockingStyle = dsTop
        DockedLeft = 544
        DockedTop = 0
        DockingStyle = dsTop
        FloatLeft = 271
        FloatTop = 315
        FloatClientWidth = 23
        FloatClientHeight = 22
        ItemLinks = <
          item
            Item = bLoadEditLayoutAction
            Visible = True
          end>
        Name = 'Layout'
        OneOnRow = False
        Row = 0
        ShowMark = False
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end
      item
        Caption = 'Editor'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsNone
        FloatLeft = 222
        FloatTop = 356
        FloatClientWidth = 97
        FloatClientHeight = 22
        Hidden = True
        ItemLinks = <
          item
            Item = bCutAction
            Visible = True
          end
          item
            Item = bCopyAction
            Visible = True
          end
          item
            Item = bPasteAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bEditColorAction
            Visible = True
          end>
        Name = 'EditorForm'
        NotDocking = [dsLeft, dsTop, dsRight, dsBottom]
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end
      item
        Caption = 'Code Librarian'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsNone
        FloatLeft = 512
        FloatTop = 356
        FloatClientWidth = 120
        FloatClientHeight = 22
        Hidden = True
        ItemLinks = <
          item
            Item = bCutAction
            Visible = True
          end
          item
            Item = bCopyAction
            Visible = True
          end
          item
            Item = bPasteAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = bUndoAction
            UserDefine = [udPaintStyle]
            Visible = True
          end
          item
            Item = bRedoAction
            Visible = True
          end>
        Name = 'LibrarianForm'
        NotDocking = [dsLeft, dsTop, dsRight, dsBottom]
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end
      item
        Caption = 'Code Explorer'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsNone
        FloatLeft = 609
        FloatTop = 265
        FloatClientWidth = 23
        FloatClientHeight = 22
        Hidden = True
        ItemLinks = <>
        Name = 'ExplorerForm'
        NotDocking = [dsLeft, dsTop, dsRight, dsBottom]
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end
      item
        Caption = 'Project Explorer'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsNone
        FloatLeft = 609
        FloatTop = 356
        FloatClientWidth = 23
        FloatClientHeight = 22
        Hidden = True
        ItemLinks = <>
        Name = 'ProjectForm'
        NotDocking = [dsLeft, dsTop, dsRight, dsBottom]
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end
      item
        Caption = 'Web Browser'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsNone
        FloatLeft = 503
        FloatTop = 356
        FloatClientWidth = 129
        FloatClientHeight = 22
        Hidden = True
        ItemLinks = <
          item
            Item = bBackAction
            Visible = True
          end
          item
            Item = bForwardAction
            Visible = True
          end
          item
            Item = bStopAction
            Visible = True
          end
          item
            Item = bRefreshAction
            Visible = True
          end
          item
            BeginGroup = True
            Item = siFavorites
            Visible = True
          end>
        Name = 'WebBrowserForm'
        NotDocking = [dsLeft, dsTop, dsRight, dsBottom]
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end
      item
        Caption = 'Query Editor'
        DockedDockingStyle = dsTop
        DockedLeft = 0
        DockedTop = 0
        DockingStyle = dsNone
        FloatLeft = 325
        FloatTop = 299
        FloatClientWidth = 23
        FloatClientHeight = 22
        Hidden = True
        ItemLinks = <>
        Name = 'QueryForm'
        NotDocking = [dsLeft, dsTop, dsRight, dsBottom]
        OneOnRow = True
        Row = 0
        UseOwnFont = False
        Visible = False
        WholeRow = False
      end>
    Categories.Strings = (
      'File'
      'Edit'
      'Editing'
      'Search'
      'Project'
      'Debug'
      'Run'
      'Query'
      'Tools'
      'User tools'
      'Plug-Ins'
      'Browser'
      'Server'
      'Window'
      'Help'
      'Bookmarks'
      'Main Menus'
      'Sub Menus'
      'Custom Menus')
    Categories.ItemsVisibles = (
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2
      2)
    Categories.Visibles = (
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True
      True)
    HelpButtonGlyph.Data = {
      42020000424D4202000000000000420000002800000010000000100000000100
      1000030000000002000000000000000000000000000000000000007C0000E003
      00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000000F3C0F3CEF3D00001F7C1F7C
      1F7C1F7C1F7C1F7C1F7C1F7C000000000F3C0F3CFF7FFF7F1F7CEF3D00001F7C
      1F7C1F7C1F7C1F7C000000000F3C0F3CFF7FFF7F000000001F7C1F7CEF3D0000
      1F7C1F7C1F7CEF3D0F3C0F3CFF7FFF7F000000000F3C0F3C00001F7C1F7CEF3D
      00001F7C1F7CEF3D0F3CFF7F000000000F3C0F3C0F3C0F3C0F3C00001F7C1F7C
      EF3D00001F7CEF3D000000000F3C0F3C0F3CE03DE07F0F3C0F3C0F3C00001F7C
      1F7CEF3D0000EF3D0F3C0F3C0F3C0F3C0F3C0F3CE03D0F3C0F3C0F3C0F3C0000
      1F7C00001F7C1F7C0F3CFF7F0F3C0F3C0F3C0F3C0F3CE07FE07F0F3C0F3C0F3C
      000000001F7C1F7C1F7C0F3CFF7F0F3C0F3C0F3C0F3C0F3CE03DE07FE07F0F3C
      0F3C00001F7C1F7C1F7C1F7C0F3CFF7F0F3C0F3C0F3CE03D0F3CE07FE07F0F3C
      0F3C0F3C00001F7C1F7C1F7C1F7C0F3CFF7F0F3C0F3CE07FE07FE07F0F3C0F3C
      0F3C000000001F7C1F7C1F7C1F7C1F7C0F3CFF7F0F3C0F3C0F3C0F3C0F3C0000
      00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0F3CFF7F0F3C0F3C000000001F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0F3C0F3C00001F7C1F7C1F7C
      1F7C1F7C1F7C}
    HelpContext = 6640
    HideFloatingBarsWhenInactive = False
    ImageListBkColor = clWhite
    Images = CentralImageListMod.ImageList
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    ShowFullMenusAfterDelay = False
    ShowHelpButton = True
    ShowShortCutInHint = True
    StretchGlyphs = False
    Style = bmsFlat
    UseSystemFont = False
    OnBarAfterReset = BarManagerBarAfterReset
    OnBarVisibleChange = BarManagerBarVisibleChange
    OnDocking = BarManagerDocking
    OnHideCustomizingForm = BarManagerHideCustomizingForm
    OnShowCustomizingForm = BarManagerShowCustomizingForm
    OnClickItem = BarManagerClickItem
    Left = 176
    Top = 152
    DockControlHeights = (
      0
      0
      75
      0)
    object StandardGroup: TdxBarGroup
      Items = (
        'bStartRemDebAction'
        'bStopDebAction'
        'bSingleStepAction'
        'bStepOverAction'
        'bReturnFromSubAction'
        'bContinueAction'
        'bListSubAction'
        'bPackageVarsAction'
        'bEvaluateVarAction'
        'bMethodsCallAction'
        'bToggleBreakAction'
        'bOpenWatchesAction'
        'bAutoEvaluationAction'
        'bAddToWatchAction')
    end
    object siFile: TdxBarSubItem
      Caption = '&File'
      Category = 16
      Description = 'File menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = siNewFile
          Visible = True
        end
        item
          Item = bOpenAction
          Visible = True
        end
        item
          Item = siRecentScripts
          Visible = True
        end
        item
          Item = siRecentFiles
          Visible = True
        end
        item
          BeginGroup = True
          Item = bOpenRemoteAction
          Visible = True
        end
        item
          Item = bOpenCacheAction
          Visible = True
        end
        item
          Item = bSaveRemoteAction
          Visible = True
        end
        item
          Item = bSaveRemoteActionAs
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSaveAction
          Visible = True
        end
        item
          Item = bSaveAsAction
          Visible = True
        end
        item
          Item = bSaveAllAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bCloseAction
          Visible = True
        end
        item
          Item = bCloseAllAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bWindowsFormatAction
          Visible = True
        end
        item
          Item = bUnixFormatAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = liDefaultLanguages
          Visible = True
        end
        item
          Item = siViewAsLanguage
          Visible = True
        end
        item
          BeginGroup = True
          Item = bExportHTMLAction
          Visible = True
        end
        item
          Item = bExportRTFAction
          Visible = True
        end
        item
          Item = bPrintAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bExitAction
          Visible = True
        end>
    end
    object siEdit: TdxBarSubItem
      Caption = '&Edit'
      Category = 16
      Description = 'Edit menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bUndoAction
          Visible = True
        end
        item
          Item = bRedoAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bCutAction
          Visible = True
        end
        item
          Item = bCopyAction
          Visible = True
        end
        item
          Item = bPasteAction
          Visible = True
        end
        item
          Item = bDeleteAction
          Visible = True
        end
        item
          Item = bSelectAllAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bCommentInAction
          Visible = True
        end
        item
          Item = bCommentOutAction
          Visible = True
        end
        item
          Item = bCommentToggleAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bShowTemplatesAction
          Visible = True
        end
        item
          Item = bTemplateFormAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bOpenTodoListAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bNewEditWinAction
          Visible = True
        end
        item
          Item = bSyncScrollAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = siTextStyles
          Visible = True
        end
        item
          BeginGroup = True
          Item = bOpenEditorAction
          Visible = True
        end
        item
          Item = bEditorBigAction
          Visible = True
        end>
    end
    object siSearch: TdxBarSubItem
      Caption = '&Search'
      Category = 16
      Description = 'Search menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bFindAction
          Visible = True
        end
        item
          Item = bSearchAgainAction
          Visible = True
        end
        item
          Item = bSearchNextAction
          Visible = True
        end
        item
          Item = bReplaceAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bPatternSearchAction
          Visible = True
        end
        item
          Item = siHighlights
          Visible = True
        end
        item
          BeginGroup = True
          Item = bCodeCompAction
          Visible = True
        end
        item
          Item = bOpenCodeExplorerAction
          Visible = True
        end
        item
          Item = bExportCodeExplorerAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSubListAction
          Visible = True
        end
        item
          Item = bGoToLineAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bMatchBracketAction
          Visible = True
        end
        item
          Item = bFindSubAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bBrowseBackAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSwapVersionAction
          Visible = True
        end>
    end
    object siProject: TdxBarSubItem
      Caption = '&Project'
      Category = 16
      Description = 'Project menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bNewProjectAction
          Visible = True
        end
        item
          Item = bOpenProjectAction
          Visible = True
        end
        item
          Item = siRecentProjects
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSaveProjectAction
          Visible = True
        end
        item
          Item = bSaveProjectAsAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bAddCurrentToProjectAction
          Visible = True
        end
        item
          Item = bRemoveFromProjectAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bAddToProjectAction
          Visible = True
        end
        item
          Item = bImportFolderAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bShowManagerAction
          Visible = True
        end
        item
          Item = bSearchInProjectAction
          Visible = True
        end
        item
          Item = bProjectOptionsAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bPublishProjectAction
          Visible = True
        end
        item
          Item = bViewProjLogAction
          Visible = True
        end
        item
          Item = bPublishAllAgainAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bProjOpenRemoteAction
          Visible = True
        end>
    end
    object siDebug: TdxBarSubItem
      Caption = '&Debug'
      Category = 16
      Description = 'Debug menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bContinueAction
          Visible = True
        end
        item
          Item = bSingleStepAction
          Visible = True
        end
        item
          Item = bStepOverAction
          Visible = True
        end
        item
          Item = bReturnFromSubAction
          Visible = True
        end
        item
          Item = bStopDebAction
          Visible = True
        end
        item
          Item = bActiveScriptDebAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bStartRemDebAction
          Visible = True
        end
        item
          Item = bRemDebSetupAction
          Visible = True
        end
        item
          Item = bRedOutputAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bListSubAction
          Visible = True
        end
        item
          Item = bPackageVarsAction
          Visible = True
        end
        item
          Item = bMethodsCallAction
          Visible = True
        end
        item
          Item = bEvaluateVarAction
          Visible = True
        end
        item
          Item = bCallStackAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bToggleBreakAction
          Visible = True
        end
        item
          Item = bBreakConditionAction
          Visible = True
        end
        item
          Item = bOpenWatchesAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bAutoEvaluationAction
          Visible = True
        end>
    end
    object siRun: TdxBarSubItem
      Caption = '&Run'
      Category = 16
      Description = 'Run menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bRunBrowserAction
          Visible = True
        end
        item
          Item = bRunExtBrowserAction
          Visible = True
        end
        item
          Item = bRunSecBrowserAction
          Visible = True
        end
        item
          Item = bprRunInConsoleAction
          Visible = True
        end
        item
          Item = bRunInConsoleAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSendMailAction
          Visible = True
        end
        item
          Item = siArguments
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSelectStartPathAction
          Visible = True
        end
        item
          Item = siStartingPath
          Visible = True
        end
        item
          BeginGroup = True
          Item = bAutoSynCheckAction
          Visible = True
        end
        item
          Item = bAutoSynCheckStrippedAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bTestErrorAction
          Visible = True
        end
        item
          Item = bTestErrorExpAction
          Visible = True
        end>
    end
    object siQuery: TdxBarSubItem
      Caption = '&Query'
      Category = 16
      Description = 'Query menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = cbGet
          Visible = True
        end
        item
          Item = bEnGetAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = cbPost
          Visible = True
        end
        item
          Item = bEnPostAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = cbPathInfo
          Visible = True
        end
        item
          Item = bEnPathInfoAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = cbCookie
          Visible = True
        end
        item
          Item = bEnCookieAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bOpenQueryEditorAction
          Visible = True
        end
        item
          Item = bPreviewAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSaveShotAction
          Visible = True
        end
        item
          Item = bDelShotAction
          Visible = True
        end>
    end
    object siTools: TdxBarSubItem
      Caption = '&Tools'
      Category = 16
      Description = 'Tools menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bOptionsAction
          Visible = True
        end
        item
          Item = bCustToolsAction
          Visible = True
        end
        item
          Item = bEditShortCutAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bFileExplorerAction
          Visible = True
        end
        item
          Item = bRemoteExplorerAction
          Visible = True
        end
        item
          Item = bRemoteSessionsAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bCodeLibAction
          Visible = True
        end
        item
          Item = bOpenZipAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bPodExtractorAction
          Visible = True
        end
        item
          Item = bURLEncodeAction
          Visible = True
        end
        item
          Item = bPerlPrinterAction
          Visible = True
        end
        item
          Item = bRegExpTesterAction
          Visible = True
        end
        item
          Item = bPerlTidyAction
          Visible = True
        end
        item
          Item = bFileCompareAction
          Visible = True
        end
        item
          Item = bOpenAutoViewAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = liPlugWins
          Visible = True
        end
        item
          BeginGroup = True
          Item = siPlugins
          Visible = True
        end
        item
          BeginGroup = True
          Item = bConfToolsAction
          Visible = True
        end
        item
          Item = siUserTools
          Visible = True
        end
        item
          Item = siCVS
          Visible = True
        end>
    end
    object siUserTools: TdxBarSubItem
      Caption = '&User tools'
      Category = 16
      Description = 'Default menu for adding custom tools'
      Visible = ivAlways
      ItemLinks = <>
    end
    object siBrowser: TdxBarSubItem
      Caption = '&Browser'
      Category = 16
      Description = 'Browser menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bForwardAction
          Visible = True
        end
        item
          Item = bBackAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bRefreshAction
          Visible = True
        end
        item
          Item = bStopAction
          Visible = True
        end
        item
          Item = bHaulBrowserAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bOpenURLAction
          Visible = True
        end
        item
          Item = bOpenURLQueryAction
          Visible = True
        end
        item
          Item = bProxyEnableAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = siFavorites
          Visible = True
        end
        item
          Item = cbUrls
          Visible = True
        end
        item
          BeginGroup = True
          Item = bInternetOptionsAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bOpenBrowserWindowAction
          Visible = True
        end
        item
          Item = bBrowserBigAction
          Visible = True
        end>
    end
    object siServer: TdxBarSubItem
      Caption = 'Ser&ver'
      Category = 16
      Description = 'Server menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bRunWithServerAction
          Visible = True
        end
        item
          Item = bOpenAccessLogsAction
          Visible = True
        end
        item
          Item = bOpenErrorLogsAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bInternalServerAction
          Visible = True
        end
        item
          Item = bChangeRootAction
          Visible = True
        end
        item
          Item = siRecentServerWebroots
          Visible = True
        end
        item
          BeginGroup = True
          Item = liServerStatus
          Visible = True
        end>
    end
    object siEditorPop: TdxBarSubItem
      Caption = '&Editor Pop-up'
      Category = 17
      Description = 'Pop-up menu when right clicking in the editor'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bBreakConditionAction
          Visible = True
        end
        item
          Item = bFindDeclarationAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSaveAction
          Visible = True
        end
        item
          Item = bCloseAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bCutAction
          Visible = True
        end
        item
          Item = bCopyAction
          Visible = True
        end
        item
          Item = bPasteAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bToggleIMEAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = siGotoBookmarks
          Visible = True
        end
        item
          Item = siToggleBookmarks
          Visible = True
        end
        item
          BeginGroup = True
          Item = bCommentInAction
          Visible = True
        end
        item
          Item = bCommentOutAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSearchDocsAction
          Visible = True
        end
        item
          Item = bHighDeclarationAction
          Visible = True
        end
        item
          Item = bAddToWatchAction
          Visible = True
        end
        item
          Item = bOpenTodoListAction
          Visible = True
        end
        item
          Item = bOptionsAction
          Visible = True
        end>
    end
    object siTabPop: TdxBarSubItem
      Caption = 'Tab Pop-up'
      Category = 17
      Description = 'Pop-up menu when right clicking in the editor'#39's tabs'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bCloseAction
          Visible = True
        end
        item
          Item = bNewEditWinAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = siOpenFiles
          Visible = True
        end>
    end
    object siNewFile: TdxBarSubItem
      Caption = '&New'
      Category = 17
      Description = 'Items to create new files'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bNewAction
          Visible = True
        end
        item
          Item = bNewHtmlFileAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bNewTemplateAction
          Visible = True
        end>
    end
    object siRecentScripts: TdxBarSubItem
      Caption = '&Recent Scripts'
      Category = 17
      Description = 'List of recently used scripts'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = mruRecentScripts
          Visible = True
        end>
    end
    object siRecentFiles: TdxBarSubItem
      Caption = 'R&ecent Files'
      Category = 17
      Description = 'List of recently used files'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = mruRecentFiles
          Visible = True
        end>
    end
    object siRecentProjects: TdxBarSubItem
      Caption = 'Recent Pro&jects'
      Category = 17
      Description = 'List of recently used projects'
      Hint = 'List of recently used projects'
      Visible = ivAlways
      ImageIndex = 5
      ShowCaption = False
      ItemLinks = <
        item
          Item = mruProject
          Visible = True
        end>
    end
    object siDefLanguages: TdxBarSubItem
      Caption = '&Default Languages'
      Category = 17
      Description = 'List of default languages for active file type in editor'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = liDefaultLanguages
          Visible = True
        end>
    end
    object bNewProjectAction: TdxBarButton
      Action = ProjectForm.NewProjectAction
      Category = 4
      Hint = 'New'
    end
    object bNewAction: TdxBarButton
      Caption = '&New Script'
      Category = 0
      HelpContext = 480
      Hint = 'New Script'
      Visible = ivAlways
      ImageIndex = 38
      ShortCut = 16462
    end
    object bNewHtmlFileAction: TdxBarButton
      Caption = 'New &Html'
      Category = 0
      HelpContext = 480
      Hint = 'New Html'
      Visible = ivAlways
      ImageIndex = 33
      ShortCut = 24654
    end
    object bNewTemplateAction: TdxBarButton
      Caption = 'Choose from templates'
      Category = 0
      Hint = 'Choose from templates'
      Visible = ivAlways
    end
    object bOpenAction: TdxBarButton
      Caption = '&Open'
      Category = 0
      HelpContext = 70
      Hint = 'Open'
      Visible = ivAlways
      ImageIndex = 34
      ShortCut = 16463
    end
    object mruRecentScripts: TdxBarMRUListItem
      Caption = 'Re&cent Scripts'
      Category = 0
      Visible = ivAlways
      OnClick = mruRecentScriptsClick
      OnGetData = mruRecentScriptsGetData
    end
    object mruRecentFiles: TdxBarMRUListItem
      Caption = 'Rece&nt Files'
      Category = 0
      Visible = ivAlways
      OnClick = mruRecentScriptsClick
      OnGetData = mruRecentFilesGetData
    end
    object bOpenRemoteAction: TdxBarButton
      Caption = 'Open Remote'
      Category = 0
      Hint = 'Open Remote'
      Visible = ivAlways
    end
    object bReloadRemoteAction: TdxBarButton
      Caption = 'Reload remote'
      Category = 0
      Hint = 'Reload remote'
      Visible = ivAlways
    end
    object bOpenCacheAction: TdxBarButton
      Caption = 'Open cache'
      Category = 0
      Hint = 'Open cache'
      Visible = ivAlways
    end
    object bSaveRemoteAction: TdxBarButton
      Caption = 'Save remote'
      Category = 0
      Hint = 'Save remote'
      Visible = ivAlways
    end
    object bSaveRemoteActionAs: TdxBarButton
      Caption = 'Save remote as'
      Category = 0
      Hint = 'Save remote as'
      Visible = ivAlways
    end
    object bSaveAllRemoteAction: TdxBarButton
      Caption = 'Save All remote'
      Category = 0
      Hint = 'Save All remote'
      Visible = ivAlways
    end
    object bSaveAction: TdxBarButton
      Caption = '&Save'
      Category = 0
      HelpContext = 70
      Hint = 'Save'
      Visible = ivAlways
      ImageIndex = 35
      ShortCut = 16467
    end
    object bSaveAsAction: TdxBarButton
      Caption = 'Save &As...'
      Category = 0
      HelpContext = 70
      Hint = 'Save As'
      Visible = ivAlways
      ShortCut = 24641
    end
    object bSaveAllAction: TdxBarButton
      Caption = 'Save &All'
      Category = 0
      HelpContext = 70
      Hint = 'Save All'
      Visible = ivAlways
      ImageIndex = 36
      ShortCut = 8305
    end
    object bReloadAction: TdxBarButton
      Caption = 'Reload'
      Category = 0
      Hint = 'Reload'
      Visible = ivAlways
    end
    object bResetPermAction: TdxBarButton
      Caption = 'Reset Permissions'
      Category = 0
      Hint = 'Reset Permissions'
      Visible = ivAlways
    end
    object bCloseAction: TdxBarButton
      Caption = '&Close'
      Category = 0
      HelpContext = 70
      Hint = 'Close'
      Visible = ivAlways
      ShortCut = 16499
    end
    object bUndoAction: TdxBarButton
      Caption = 'Undo'
      Category = 1
      Hint = 'Undo'
      Visible = ivAlways
      ImageIndex = 112
    end
    object bRedoAction: TdxBarButton
      Caption = 'Redo'
      Category = 1
      Hint = 'Redo'
      Visible = ivAlways
      ImageIndex = 113
    end
    object bCutAction: TdxBarButton
      Caption = '&Cut'
      Category = 1
      HelpContext = 350
      Hint = 'Cut'
      Visible = ivAlways
      ImageIndex = 103
      ShortCut = 16472
    end
    object bCopyAction: TdxBarButton
      Caption = 'C&opy'
      Category = 1
      Enabled = False
      HelpContext = 350
      Hint = 'Copy'
      Visible = ivAlways
      ImageIndex = 78
      ShortCut = 16451
    end
    object bPasteAction: TdxBarButton
      Caption = '&Paste'
      Category = 1
      Enabled = False
      Hint = 'Paste'
      Visible = ivAlways
      ImageIndex = 45
      ShortCut = 16470
    end
    object bDeleteAction: TdxBarButton
      Caption = '&Delete'
      Category = 1
      HelpContext = 350
      Hint = 'Delete'
      Visible = ivAlways
      ImageIndex = 89
    end
    object bSelectAllAction: TdxBarButton
      Caption = 'Select &All'
      Category = 1
      HelpContext = 350
      Hint = 'Select All'
      Visible = ivAlways
      ShortCut = 16449
    end
    object bCommentInAction: TdxBarButton
      Caption = 'Comment In'
      Category = 1
      Hint = 'Comment In'
      Visible = ivAlways
      ImageIndex = 17
    end
    object bCommentOutAction: TdxBarButton
      Caption = 'Comment Out'
      Category = 1
      Hint = 'Comment Out'
      Visible = ivAlways
      ImageIndex = 19
    end
    object bCommentToggleAction: TdxBarButton
      Caption = '&Comment'
      Category = 1
      Hint = 'Comment'
      Visible = ivAlways
      ImageIndex = 13
    end
    object bShowTemplatesAction: TdxBarButton
      Caption = '&Show Templates'
      Category = 1
      HelpContext = 410
      Hint = 'Show Templates'
      Visible = ivAlways
      ShortCut = 16458
    end
    object bTemplateFormAction: TdxBarButton
      Caption = '&Templates...'
      Category = 1
      HelpContext = 410
      Hint = 'Templates'
      Visible = ivAlways
      ImageIndex = 93
    end
    object bOpenTodoListAction: TdxBarButton
      Caption = 'To-Do &List...'
      Category = 1
      HelpContext = 360
      Hint = 'To-Do List'
      Visible = ivAlways
      ImageIndex = 29
      ShortCut = 24660
    end
    object bNewEditWinAction: TdxBarButton
      Caption = '&New Edit Window'
      Category = 1
      Hint = 'New Edit Window'
      Visible = ivAlways
      ImageIndex = 93
    end
    object bSyncScrollAction: TdxBarButton
      Caption = '&Synchronized scrolling'
      Category = 1
      Hint = 'Synchronized scrolling'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bOpenEditorAction: TdxBarButton
      Caption = 'Show E&ditor'
      Category = 1
      HelpContext = 350
      Hint = 'Show Editor'
      Visible = ivAlways
      ShortCut = 16506
    end
    object bEditorBigAction: TdxBarButton
      Caption = 'Make Editor &Big'
      Category = 1
      Enabled = False
      HelpContext = 350
      Hint = 'Make Editor Big'
      Visible = ivAlways
      ImageIndex = 83
      ShortCut = 122
    end
    object bIndentAction: TdxBarButton
      Caption = 'Indent Block'
      Category = 2
      Hint = 'Indent Block'
      Visible = ivAlways
      ImageIndex = 16
      ShortCut = 16571
    end
    object bAboutAction: TdxBarButton
      Caption = '&About...'
      Category = 14
      HelpContext = 10
      Hint = 'About'
      Visible = ivAlways
      ImageIndex = 119
    end
    object bPerlInfoAction: TdxBarButton
      Caption = 'Perl &Information'
      Category = 14
      HelpContext = 400
      Hint = 'Perl Information'
      Visible = ivAlways
      ImageIndex = 116
      ShortCut = 24649
    end
    object bCheckForUpdateAction: TdxBarButton
      Caption = 'Check for &Update...'
      Category = 14
      HelpContext = 330
      Hint = 'Check for Update'
      Visible = ivAlways
      ImageIndex = 105
    end
    object bShowHelpAction: TdxBarButton
      Caption = 'Show &Help'
      Category = 14
      HelpContext = 10
      Hint = 'Show Help'
      Visible = ivAlways
      ImageIndex = 130
    end
    object bPerlDocAction: TdxBarButton
      Caption = '&Perl Documentation'
      Category = 14
      HelpContext = 650
      Hint = 'Perl Documentation'
      Visible = ivAlways
      ImageIndex = 106
    end
    object bForwardAction: TdxBarButton
      Caption = '&Forward'
      Category = 11
      HelpContext = 300
      Visible = ivAlways
      ImageIndex = 109
      ShortCut = 16605
    end
    object bBackAction: TdxBarButton
      Caption = '&Back'
      Category = 11
      HelpContext = 300
      Visible = ivAlways
      ImageIndex = 108
      ShortCut = 16603
    end
    object bRefreshAction: TdxBarButton
      Caption = '&Refresh'
      Category = 11
      HelpContext = 300
      Visible = ivAlways
      ImageIndex = 110
      ShortCut = 24658
    end
    object bStopAction: TdxBarButton
      Caption = '&Stop'
      Category = 11
      HelpContext = 510
      Visible = ivAlways
      ImageIndex = 101
      ShortCut = 24659
    end
    object bHaulBrowserAction: TdxBarButton
      Caption = '&Halt Browser'
      Category = 11
      HelpContext = 300
      Visible = ivAlways
      ImageIndex = 107
      ShortCut = 24648
    end
    object bOpenURLAction: TdxBarButton
      Caption = '&Open URL...'
      Category = 11
      HelpContext = 300
      Visible = ivAlways
      ImageIndex = 111
      ShortCut = 16469
    end
    object bOpenURLQueryAction: TdxBarButton
      Caption = 'Go to URL with query'
      Category = 11
      Visible = ivAlways
      ImageIndex = 126
    end
    object bProxyEnableAction: TdxBarButton
      Caption = 'Spy HTTP Proxy'
      Category = 11
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object cbUrls: TdxBarCombo
      Caption = '&Url'
      Category = 11
      Description = 'URL to jump to and recently used URL'#39's'
      Hint = 'Url'
      Visible = ivAlways
      OnKeyDown = cbKeyDown
      ShowCaption = True
      Width = 170
      ItemIndex = -1
    end
    object bInternetOptionsAction: TdxBarButton
      Caption = '&Internet Options'
      Category = 11
      Visible = ivAlways
      ImageIndex = 11
    end
    object bStopDebAction: TdxBarButton
      Caption = 'S&top Debugger'
      Category = 5
      HelpContext = 510
      Hint = 'Stop Debugger'
      Visible = ivAlways
      ImageIndex = 89
      ShortCut = 117
    end
    object bActiveScriptDebAction: TdxBarButton
      Caption = 'ActiveScriptDebAction'
      Category = 5
      Hint = 'ActiveScriptDebAction'
      Visible = ivAlways
    end
    object bStartRemDebAction: TdxBarButton
      Caption = 'Start remote de&bugger'
      Category = 5
      Hint = 'Start remote debugger'
      Visible = ivAlways
    end
    object bRemDebSetupAction: TdxBarButton
      Caption = 'Info and setup'
      Category = 5
      Hint = 'Info and setup'
      Visible = ivAlways
    end
    object bRedOutputAction: TdxBarButton
      Caption = 'RedOutputAction'
      Category = 5
      Hint = 'RedOutputAction'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bSingleStepAction: TdxBarButton
      Caption = 'S&ingle Step'
      Category = 5
      HelpContext = 510
      Hint = 'Single Step'
      Visible = ivAlways
      ImageIndex = 96
      ShortCut = 118
    end
    object bStepOverAction: TdxBarButton
      Caption = 'Step &Over'
      Category = 5
      HelpContext = 510
      Hint = 'Step Over'
      Visible = ivAlways
      ImageIndex = 92
      ShortCut = 119
    end
    object bReturnFromSubAction: TdxBarButton
      Caption = 'Return from S&ubroutine'
      Category = 5
      HelpContext = 510
      Hint = 'Return from Subroutine'
      Visible = ivAlways
      ImageIndex = 94
      ShortCut = 8307
    end
    object bContinueAction: TdxBarButton
      Caption = '&Continue Script'
      Category = 5
      HelpContext = 510
      Hint = 'Continue Script'
      Visible = ivAlways
      ImageIndex = 97
      ShortCut = 115
    end
    object bListSubAction: TdxBarButton
      Caption = '&List Subroutine Names'
      Category = 5
      HelpContext = 510
      Hint = 'List Subroutine Names'
      Visible = ivAlways
      ImageIndex = 127
      ShortCut = 24691
    end
    object bPackageVarsAction: TdxBarButton
      Caption = 'List &variables in package'
      Category = 5
      HelpContext = 510
      Hint = 'List variables in package'
      Visible = ivAlways
      ImageIndex = 68
      ShortCut = 24692
    end
    object bMethodsCallAction: TdxBarButton
      Caption = '&Methods Callable'
      Category = 5
      HelpContext = 510
      Hint = 'Methods Callable'
      Visible = ivAlways
      ImageIndex = 86
      ShortCut = 24693
    end
    object bEvaluateVarAction: TdxBarButton
      Caption = '&Evaluate Expression'
      Category = 5
      HelpContext = 510
      Hint = 'Evaluate Expression'
      Visible = ivAlways
      ImageIndex = 85
      ShortCut = 24694
    end
    object bCallStackAction: TdxBarButton
      Caption = 'CallStackAction'
      Category = 5
      Hint = 'CallStackAction'
      Visible = ivAlways
    end
    object bToggleBreakAction: TdxBarButton
      Caption = '&Add/Remove Breakpoint'
      Category = 5
      HelpContext = 510
      Hint = 'Add/Remove Breakpoint'
      Visible = ivAlways
      ImageIndex = 114
      ShortCut = 16503
    end
    object bBreakConditionAction: TdxBarButton
      Caption = 'BreakConditionAction'
      Category = 5
      Hint = 'BreakConditionAction'
      Visible = ivAlways
    end
    object bOpenProjectAction: TdxBarButton
      Action = ProjectForm.OpenProjectAction
      Category = 4
      Hint = 'Open'
    end
    object mruProject: TdxBarMRUListItem
      Caption = 'Recen&t Projects'
      Category = 4
      Visible = ivAlways
      OnClick = mruProjectClick
      OnGetData = mruProjectGetData
    end
    object bSaveProjectAction: TdxBarButton
      Action = ProjectForm.SaveProjectAction
      Category = 4
      Hint = 'Save'
    end
    object bSaveProjectAsAction: TdxBarButton
      Action = ProjectForm.SaveProjectAsAction
      Category = 4
      Hint = 'Save As'
    end
    object bAddCurrentToProjectAction: TdxBarButton
      Action = ProjectForm.AddCurrentToProjectAction
      Category = 4
      Hint = 'Add'
    end
    object bRemoveFromProjectAction: TdxBarButton
      Action = ProjectForm.RemoveFromProjectAction
      Category = 4
      Hint = 'Remove'
    end
    object bAddToProjectAction: TdxBarButton
      Action = ProjectForm.AddToProjectAction
      Category = 4
      Hint = 'Add Files to Project'
    end
    object bImportFolderAction: TdxBarButton
      Caption = 'Import Folder'
      Category = 4
      Hint = 'Import Folder'
      Visible = ivAlways
    end
    object bPublishAllAgainAction: TdxBarButton
      Caption = 'Publish all again'
      Category = 4
      Hint = 'Publish all again'
      Visible = ivAlways
    end
    object bShowManagerAction: TdxBarButton
      Action = ProjectForm.ShowManagerAction
      Category = 4
      Hint = 'Show Project Manager'
    end
    object bSearchInProjectAction: TdxBarButton
      Action = ProjectForm.SearchInProjectAction
      Category = 4
      Hint = 'Search && Replace in Project'
    end
    object bFindAction: TdxBarButton
      Caption = '&Find'
      Category = 3
      HelpContext = 490
      Hint = 'Find'
      Visible = ivAlways
      ImageIndex = 95
      ShortCut = 16454
    end
    object bSearchAgainAction: TdxBarButton
      Caption = 'Search &Again'
      Category = 3
      HelpContext = 350
      Hint = 'Search Again'
      Visible = ivAlways
      ImageIndex = 84
      ShortCut = 114
    end
    object bSearchNextAction: TdxBarButton
      Caption = 'SearchNextAction'
      Category = 3
      Hint = 'SearchNextAction'
      Visible = ivAlways
    end
    object bReplaceAction: TdxBarButton
      Caption = '&Replace'
      Category = 3
      HelpContext = 350
      Hint = 'Replace'
      Visible = ivAlways
      ImageIndex = 83
      ShortCut = 16466
    end
    object bPatternSearchAction: TdxBarButton
      Caption = 'Perl &Pattern Search'
      Category = 3
      HelpContext = 370
      Hint = 'Perl Pattern Search'
      Visible = ivAlways
      ImageIndex = 118
      ShortCut = 16498
    end
    object bPrevSearchAction: TdxBarButton
      Caption = 'PrevSearchAction'
      Category = 3
      Hint = 'PrevSearchAction'
      Visible = ivAlways
    end
    object bNextSearchAction: TdxBarButton
      Caption = 'NextSearchAction'
      Category = 3
      Hint = 'NextSearchAction'
      Visible = ivAlways
    end
    object liHighlights: TdxBarListItem
      Caption = 'Search Highlights'
      Category = 3
      Description = 'List of search highlights'
      Visible = ivAlways
      ImageIndex = 173
      OnClick = liHighlightsClick
      OnGetData = liHighlightsGetData
    end
    object bClearHighlightsAction: TdxBarButton
      Caption = 'ClearHighlightsAction'
      Category = 3
      Hint = 'ClearHighlightsAction'
      Visible = ivAlways
    end
    object bRunBrowserAction: TdxBarButton
      Caption = '&Run in browser'
      Category = 6
      Enabled = False
      HelpContext = 520
      Hint = 'Run in browser'
      Visible = ivAlways
      ImageIndex = 98
      ShortCut = 120
    end
    object bRunExtBrowserAction: TdxBarButton
      Caption = 'Run in &External Browser'
      Category = 6
      HelpContext = 520
      Hint = 'Run in External Browser'
      Visible = ivAlways
      ImageIndex = 99
      ShortCut = 16504
    end
    object bRunSecBrowserAction: TdxBarButton
      Caption = 'Run in &secondary browser'
      Category = 6
      Hint = 'Run in secondary browser'
      Visible = ivAlways
      ImageIndex = 99
    end
    object bprRunInConsoleAction: TdxBarButton
      Caption = 'Prompt run in console'
      Category = 6
      Hint = 'Prompt run in console'
      Visible = ivAlways
    end
    object bRunInConsoleAction: TdxBarButton
      Caption = 'Run in &Console'
      Category = 6
      HelpContext = 520
      Hint = 'Run in Console'
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 8312
    end
    object bOptionsAction: TdxBarButton
      Caption = '&Options...'
      Category = 8
      HelpContext = 390
      Hint = 'Options'
      Visible = ivAlways
      ImageIndex = 18
      ShortCut = 24655
    end
    object bEditColorAction: TdxBarButton
      Caption = 'Edit Color'
      Category = 8
      Hint = 'Edit Color'
      Visible = ivAlways
      ImageIndex = 147
    end
    object bCustToolsAction: TdxBarButton
      Caption = 'Edit toolbars'
      Category = 8
      Hint = 'Edit toolbars'
      Visible = ivAlways
    end
    object bEditShortCutAction: TdxBarButton
      Caption = 'Edit &Shortcuts'
      Category = 8
      Hint = 'Edit Shortcuts'
      Visible = ivAlways
      ImageIndex = 14
    end
    object bFileExplorerAction: TdxBarButton
      Caption = '&File Explorer'
      Category = 8
      Hint = 'File Explorer'
      Visible = ivAlways
      ImageIndex = 12
      ShortCut = 16459
    end
    object bRemoteExplorerAction: TdxBarButton
      Caption = 'FTP Browser'
      Category = 8
      Hint = 'FTP Browser'
      Visible = ivAlways
    end
    object bRemoteSessionsAction: TdxBarButton
      Caption = 'FTP Sessions'
      Category = 8
      HelpContext = 200
      Hint = 'FTP Sessions'
      Visible = ivAlways
      ImageIndex = 131
      ShortCut = 24661
    end
    object bCodeLibAction: TdxBarButton
      Caption = 'Code &Librarian'
      Category = 8
      HelpContext = 380
      Hint = 'Code Librarian'
      Visible = ivAlways
      ImageIndex = 121
      ShortCut = 16460
    end
    object bOpenZipAction: TdxBarButton
      Caption = 'Open Zip'
      Category = 8
      Hint = 'Open Zip'
      Visible = ivAlways
    end
    object bPodExtractorAction: TdxBarButton
      Caption = 'Po&d Extractor'
      Category = 8
      HelpContext = 420
      Hint = 'Pod Extractor'
      Visible = ivAlways
      ImageIndex = 123
      ShortCut = 16464
    end
    object bURLEncodeAction: TdxBarButton
      Caption = '&Encoder'
      Category = 8
      HelpContext = 60
      Hint = 'Encoder'
      Visible = ivAlways
      ImageIndex = 124
      ShortCut = 16457
    end
    object bPerlPrinterAction: TdxBarButton
      Caption = 'Perl &Printer'
      Category = 8
      HelpContext = 430
      Hint = 'Perl Printer'
      Visible = ivAlways
      ImageIndex = 4
      ShortCut = 24656
    end
    object bRunWithServerAction: TdxBarButton
      Caption = '&Run with server'
      Category = 12
      HelpContext = 550
      Hint = 'Run with server'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bOpenAccessLogsAction: TdxBarButton
      Caption = 'View &Access Logs'
      Category = 12
      HelpContext = 620
      Hint = 'View Access Logs'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bOpenErrorLogsAction: TdxBarButton
      Caption = 'View &Error Logs'
      Category = 12
      HelpContext = 620
      Hint = 'View Error Logs'
      Visible = ivAlways
      ImageIndex = 2
    end
    object bInternalServerAction: TdxBarButton
      Caption = '&Internal Server Enabled'
      Category = 12
      HelpContext = 550
      Hint = 'Internal Server Enabled'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bChangeRootAction: TdxBarButton
      Caption = 'Change &Server Root'
      Category = 12
      HelpContext = 550
      Hint = 'Change Server Root'
      Visible = ivAlways
      ImageIndex = 122
      ShortCut = 24643
    end
    object liRecentServerWebroots: TdxBarListItem
      Caption = 'Recent &Server Webroots'
      Category = 12
      Visible = ivAlways
      OnClick = liRecentServerWebrootsClick
      OnGetData = liRecentServerWebrootsGetData
      ShowCheck = True
    end
    object bSaveLayoutAction: TdxBarButton
      Caption = 'Save Layout'
      Category = 13
      Hint = 'Save Layout'
      Visible = ivAlways
    end
    object bDeleteLayoutAction: TdxBarButton
      Caption = 'Delete Layout'
      Category = 13
      Hint = 'Delete Layout'
      Visible = ivAlways
    end
    object bLoadEditLayoutAction: TdxBarButton
      Caption = 'Editor layout'
      Category = 13
      Hint = 'Editor layout'
      Visible = ivAlways
    end
    object bOutdentAction: TdxBarButton
      Caption = 'Outdent Block'
      Category = 2
      Hint = 'Outdent Block'
      Visible = ivAlways
      ImageIndex = 15
      ShortCut = 16573
    end
    object bProjectOptionsAction: TdxBarButton
      Action = ProjectForm.ProjectOptionsAction
      Category = 4
      Hint = 'Options'
    end
    object bSendMailAction: TdxBarButton
      Caption = 'Sendmail'
      Category = 6
      Hint = 'Sendmail'
      Visible = ivAlways
    end
    object cbArguments: TdxBarCombo
      Caption = '&Arguments'
      Category = 6
      Description = 'Arguments to send script and previous arguments used'
      Hint = 'Arguments'
      Visible = ivAlways
      OnChange = cbArgumentsChange
      OnKeyDown = cbKeyDown
      Width = 250
      OnCloseUp = cbBoxCloseUp
      OnDropDown = cbArgumentsDropDown
      ItemIndex = -1
    end
    object bSelectStartPathAction: TdxBarButton
      Caption = 'Select starting path'
      Category = 6
      Hint = 'Select starting path'
      Visible = ivAlways
    end
    object bSameAsScriptPathAction: TdxBarButton
      Caption = 'Same path as script'
      Category = 6
      Hint = 'Same path as script'
      Visible = ivAlways
      ButtonStyle = bsChecked
      Down = True
    end
    object liOpenWindows: TdxBarListItem
      Caption = '&Open Windows'
      Category = 13
      Description = 'List of open windows'
      Visible = ivAlways
      OnClick = liWindowsClick
      OnGetData = liOpenWindowsGetData
    end
    object siViewAsLanguage: TdxBarSubItem
      Caption = '&Other Languages'
      Category = 17
      Description = 'List of other languages'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = liOtherLanguages
          Visible = True
        end>
    end
    object siOpenFiles: TdxBarSubItem
      Caption = 'Open Files'
      Category = 17
      Description = 'List of open files in editor'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = liOpenFiles
          Visible = True
        end>
    end
    object bTog0BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 0'
      Category = 15
      Hint = 'Toggle Bookmark 0'
      Visible = ivAlways
      ShortCut = 24624
    end
    object bTog1BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 1'
      Category = 15
      Hint = 'Toggle Bookmark 1'
      Visible = ivAlways
      ShortCut = 24625
    end
    object bTog2BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 2'
      Category = 15
      Hint = 'Toggle Bookmark 2'
      Visible = ivAlways
      ShortCut = 24626
    end
    object bTog3BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 3'
      Category = 15
      Hint = 'Toggle Bookmark 3'
      Visible = ivAlways
      ShortCut = 24627
    end
    object bTog4BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 4'
      Category = 15
      Hint = 'Toggle Bookmark 4'
      Visible = ivAlways
      ShortCut = 24628
    end
    object bTog5BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 5'
      Category = 15
      Hint = 'Toggle Bookmark 5'
      Visible = ivAlways
      ShortCut = 24629
    end
    object bTog6BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 6'
      Category = 15
      Hint = 'Toggle Bookmark 6'
      Visible = ivAlways
      ShortCut = 24630
    end
    object bTog7BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 7'
      Category = 15
      Hint = 'Toggle Bookmark 7'
      Visible = ivAlways
      ShortCut = 24631
    end
    object bTog8BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 8'
      Category = 15
      Hint = 'Toggle Bookmark 8'
      Visible = ivAlways
      ShortCut = 24632
    end
    object bTog9BookmarkAction: TdxBarButton
      Caption = 'Toggle Bookmark 9'
      Category = 15
      Hint = 'Toggle Bookmark 9'
      Visible = ivAlways
      ShortCut = 24633
    end
    object bGoto0BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 0'
      Category = 15
      Hint = 'Goto Bookmark 0'
      Visible = ivAlways
      ShortCut = 16432
    end
    object bGoto1BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 1'
      Category = 15
      Hint = 'Goto Bookmark 1'
      Visible = ivAlways
      ShortCut = 16433
    end
    object bGoto2BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 2'
      Category = 15
      Hint = 'Goto Bookmark 2'
      Visible = ivAlways
      ShortCut = 16434
    end
    object bGoto3BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 3'
      Category = 15
      Hint = 'Goto Bookmark 3'
      Visible = ivAlways
      ShortCut = 16435
    end
    object bGoto4BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 4'
      Category = 15
      Hint = 'Goto Bookmark 4'
      Visible = ivAlways
      ShortCut = 16436
    end
    object bGoto5BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 5'
      Category = 15
      Hint = 'Goto Bookmark 5'
      Visible = ivAlways
      ShortCut = 16437
    end
    object bGoto6BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 6'
      Category = 15
      Hint = 'Goto Bookmark 6'
      Visible = ivAlways
      ShortCut = 16438
    end
    object bGoto7BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 7'
      Category = 15
      Hint = 'Goto Bookmark 7'
      Visible = ivAlways
      ShortCut = 16439
    end
    object bGoto8BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 8'
      Category = 15
      Hint = 'Goto Bookmark 8'
      Visible = ivAlways
      ShortCut = 16440
    end
    object bGoto9BookmarkAction: TdxBarButton
      Caption = 'Goto Bookmark 9'
      Category = 15
      Hint = 'Goto Bookmark 9'
      Visible = ivAlways
      ShortCut = 16441
    end
    object siTextStyles: TdxBarSubItem
      Caption = 'Te&xt Styles'
      Category = 17
      Description = 'List of assigned syntax parser styles'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bTextStyle1
          Visible = True
        end
        item
          Item = bTextStyle2
          Visible = True
        end
        item
          Item = bTextStyle3
          Visible = True
        end
        item
          Item = bTextStyle4
          Visible = True
        end
        item
          Item = bTextStyle5
          Visible = True
        end>
    end
    object siHighlights: TdxBarSubItem
      Caption = 'Search Highlights'
      Category = 17
      Description = 'List of search highlights'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = liHighlights
          Visible = True
        end
        item
          BeginGroup = True
          Item = bClearHighlightsAction
          Visible = True
        end>
    end
    object bApacheDocAction: TdxBarButton
      Caption = 'Apache docs'
      Category = 14
      Hint = 'Apache docs'
      Visible = ivAlways
    end
    object siArguments: TdxBarSubItem
      Caption = '&Arguments'
      Category = 17
      Description = 'Selection of arguments sent to the command line of script'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = cbArguments
          Visible = True
        end
        item
          BeginGroup = True
          Item = bSaveShotAction
          Visible = True
        end
        item
          Item = bDelShotAction
          Visible = True
        end>
    end
    object siStartingPath: TdxBarSubItem
      Caption = 'Starting Pat&h'
      Category = 17
      Description = 'Selection of starting paths for script'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bSameAsScriptPathAction
          Visible = True
        end
        item
          Item = liStartingPath
          Visible = True
        end>
    end
    object bCloseAllAction: TdxBarButton
      Caption = 'C&lose All'
      Category = 0
      HelpContext = 70
      Hint = 'Close All'
      Visible = ivAlways
    end
    object liLayouts: TdxBarListItem
      Caption = 'La&youts'
      Category = 13
      Description = 'List of layouts'
      Visible = ivAlways
      OnClick = liLayoutsClick
      OnGetData = liLayoutsGetData
      ShowCheck = True
    end
    object siCustom1: TdxBarSubItem
      Caption = 'Custom Menu 1'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object siCustom2: TdxBarSubItem
      Caption = 'Custom Menu 2'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object siCustom3: TdxBarSubItem
      Caption = 'Custom Menu 3'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object bEnGetAction: TdxBarButton
      Caption = 'Enable GET'
      Category = 7
      Hint = 'Enable GET'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object cbGet: TdxBarCombo
      Caption = '&Get'
      Category = 7
      Description = 'Active GET method data and list of previously used data'
      Hint = 'Get'
      Visible = ivAlways
      OnCurChange = cbGetCurChange
      OnKeyDown = cbKeyDown
      ShowCaption = True
      Width = 200
      OnCloseUp = cbBoxCloseUp
      OnDropDown = cbGetDropDown
      ItemIndex = -1
    end
    object bEnPostAction: TdxBarButton
      Caption = 'Enable POST'
      Category = 7
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object cbPost: TdxBarCombo
      Caption = '&Post'
      Category = 7
      Description = 'Active POST method data and list of previously used data'
      Hint = 'Post'
      Visible = ivAlways
      OnCurChange = cbPostCurChange
      OnKeyDown = cbKeyDown
      ShowCaption = True
      Width = 200
      OnCloseUp = cbBoxCloseUp
      OnDropDown = cbPostDropDown
      ItemIndex = -1
    end
    object bEnPathInfoAction: TdxBarButton
      Caption = 'Enable PATHINFO'
      Category = 7
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object cbPathInfo: TdxBarCombo
      Caption = 'P&athInfo'
      Category = 7
      Description = 'Active pathinfo and list of previously used data'
      Hint = 'PathInfo'
      Visible = ivAlways
      OnCurChange = cbPathInfoCurChange
      OnKeyDown = cbKeyDown
      ShowCaption = True
      Width = 200
      OnCloseUp = cbBoxCloseUp
      OnDropDown = cbPathInfoDropDown
      ItemIndex = -1
    end
    object bEnCookieAction: TdxBarButton
      Caption = 'Enable cookie'
      Category = 7
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object cbCookie: TdxBarCombo
      Caption = 'Coo&kie'
      Category = 7
      Description = 'Active cookie and list of previously used data'
      Hint = 'Cookie'
      Visible = ivAlways
      OnCurChange = cbCookieCurChange
      OnKeyDown = cbKeyDown
      ShowCaption = True
      Width = 300
      OnCloseUp = cbBoxCloseUp
      OnDropDown = cbCookieDropDown
      ItemIndex = -1
    end
    object bOpenQueryEditorAction: TdxBarButton
      Caption = 'Open query editor'
      Category = 7
      Visible = ivAlways
      ImageIndex = 129
      ShortCut = 16465
    end
    object bPreviewAction: TdxBarButton
      Caption = 'PreviewAction'
      Category = 7
      Visible = ivAlways
    end
    object bSaveShotAction: TdxBarButton
      Caption = 'Save snapshot'
      Category = 7
      Visible = ivAlways
    end
    object siRecentServerWebroots: TdxBarSubItem
      Caption = '&Recent Server Webroots'
      Category = 17
      Description = 'Recently used webroots for internal server'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = liRecentServerWebroots
          Visible = True
        end>
    end
    object bDelShotAction: TdxBarButton
      Caption = 'Delete snapshot'
      Category = 7
      Visible = ivAlways
    end
    object bImportFileAction: TdxBarButton
      Caption = 'Import from file'
      Category = 7
      Visible = ivAlways
    end
    object bImportWebAction: TdxBarButton
      Caption = 'Import from web'
      Category = 7
      Visible = ivAlways
    end
    object bIncExtVariablesAction: TdxBarButton
      Caption = 'IncExtVariables'
      Category = 7
      Hint = 'IncExtVariables'
      Visible = ivAlways
    end
    object siLayouts: TdxBarSubItem
      Caption = '&Layouts'
      Category = 17
      Description = 'List of layouts assigned'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = liLayouts
          Visible = True
        end>
    end
    object bQuerySelectFileAction: TdxBarButton
      Caption = 'Insert File'
      Category = 7
      Hint = 'Insert File'
      Visible = ivAlways
    end
    object bCopyGetAction: TdxBarButton
      Caption = 'Copy from GET'
      Category = 7
      Visible = ivAlways
    end
    object bOpenBrowserWindowAction: TdxBarButton
      Caption = 'Sho&w Browser'
      Category = 11
      HelpContext = 450
      Visible = ivAlways
      ShortCut = 16507
    end
    object bBrowserBigAction: TdxBarButton
      Caption = '&Make Browser Big'
      Category = 11
      Enabled = False
      HelpContext = 450
      Visible = ivAlways
      ImageIndex = 81
      ShortCut = 123
    end
    object bScrollTabAction: TdxBarButton
      Caption = 'Scroll &Tab'
      Category = 11
      Visible = ivAlways
      ShortCut = 8315
    end
    object siWindows: TdxBarSubItem
      Caption = '&Windows'
      Category = 16
      Description = 'Windows menu'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bSaveLayoutAction
          Visible = True
        end
        item
          Item = bDeleteLayoutAction
          Visible = True
        end
        item
          Item = liLayouts
          Visible = True
        end
        item
          BeginGroup = True
          Item = liOpenWindows
          Visible = True
        end
        item
          BeginGroup = True
          Item = bWinCascadeAction
          Visible = True
        end
        item
          Item = bWinTileAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bNextWindowAction
          Visible = True
        end>
    end
    object siFavorites: TdxBarSubItem
      Caption = 'Favor&ites'
      Category = 11
      Description = 'Contains internet bookmarks from the favorites folder'
      Visible = ivAlways
      ImageIndex = 5
      ShowCaption = False
      AllowCustomizing = False
      ItemLinks = <>
    end
    object bDelWordLeft: TdxBarButton
      Caption = 'Del word Left'
      Category = 2
      Hint = 'Del word Left'
      Visible = ivAlways
    end
    object bDelWordRight: TdxBarButton
      Caption = 'Del word right'
      Category = 2
      Hint = 'Del word right'
      Visible = ivAlways
    end
    object bToggleIMEAction: TdxBarButton
      Caption = 'Toggle IME'
      Category = 1
      Hint = 'Toggle IME'
      Visible = ivAlways
      ImageIndex = 71
    end
    object liOpenFiles: TdxBarListItem
      Caption = 'Open Files'
      Category = 1
      Description = 'List of all open files in the editor'
      Visible = ivAlways
      OnClick = liOpenFilesClick
      OnGetData = liOpenFilesGetData
      ShowCheck = True
    end
    object bTextStyle1: TdxBarButton
      Caption = 'TextStyle1'
      Category = 1
      Hint = 'TextStyle1'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bTextStyle2: TdxBarButton
      Caption = 'TextStyle2'
      Category = 1
      Hint = 'TextStyle2'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bWindowsFormatAction: TdxBarButton
      Caption = 'Windows Format'
      Category = 0
      Hint = 'Windows Format'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bUnixFormatAction: TdxBarButton
      Caption = 'Unix Format'
      Category = 0
      Hint = 'Unix Format'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bMacFormatAction: TdxBarButton
      Caption = 'Mac Format'
      Category = 0
      Hint = 'Mac Format'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bRegExpTesterAction: TdxBarButton
      Caption = '&RegExp Tester'
      Category = 8
      Hint = 'RegExp Tester'
      Visible = ivAlways
      ImageIndex = 125
      ShortCut = 16468
    end
    object bTextStyle3: TdxBarButton
      Caption = 'TextStyle3'
      Category = 1
      Hint = 'TextStyle3'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bTextStyle4: TdxBarButton
      Caption = 'TextStyle4'
      Category = 1
      Hint = 'TextStyle4'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bCodeCompAction: TdxBarButton
      Caption = 'Code Completion'
      Category = 3
      Hint = 'Code Completion'
      Visible = ivAlways
    end
    object liStartingPath: TdxBarListItem
      Caption = '&Starting Paths'
      Category = 6
      Visible = ivAlways
      OnClick = liStartingPathClick
      OnGetData = liStartingPathGetData
      ShowCheck = True
    end
    object bPublishProjectAction: TdxBarButton
      Action = ProjectForm.PublishProjectAction
      Category = 4
      Hint = 'Publish'
    end
    object bAutoSynCheckAction: TdxBarButton
      Caption = 'AutoSynCheckAction'
      Category = 6
      Hint = 'AutoSynCheckAction'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bViewProjLogAction: TdxBarButton
      Caption = 'View Logs'
      Category = 4
      Hint = 'View Logs'
      Visible = ivAlways
    end
    object bOpenCodeExplorerAction: TdxBarButton
      Caption = '&Code Explorer...'
      Category = 3
      HelpContext = 370
      Hint = 'Code Explorer'
      Visible = ivAlways
      ImageIndex = 100
    end
    object siHelp: TdxBarSubItem
      Caption = 'He&lp'
      Category = 16
      Description = 'Help menu'
      Visible = ivAlways
      OnClick = siHelpClick
      ItemLinks = <
        item
          Item = bShowHelpAction
          Visible = True
        end
        item
          Item = bPerlDocAction
          Visible = True
        end
        item
          Item = bApacheDocAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bPerlInfoAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = bCheckForUpdateAction
          Visible = True
        end
        item
          Item = bAboutAction
          Visible = True
        end>
    end
    object bAddToWatchAction: TdxBarButton
      Caption = 'Add to &Watches'
      Category = 5
      Hint = 'Add to Watches'
      Visible = ivAlways
      ImageIndex = 90
    end
    object bPerlTidyAction: TdxBarButton
      Caption = 'Perl &Tidy'
      Category = 8
      Hint = 'Perl Tidy'
      Visible = ivAlways
      ImageIndex = 7
    end
    object bFileCompareAction: TdxBarButton
      Caption = 'File Co&mpare'
      Category = 8
      Hint = 'File Compare'
      Visible = ivAlways
      ImageIndex = 9
    end
    object siOpenWindows: TdxBarSubItem
      Caption = '&Open Windows'
      Category = 17
      Description = 'List of open windows'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = liOpenWindows
          Visible = True
        end>
    end
    object siCustom4: TdxBarSubItem
      Caption = 'Custom Menu 4'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object siCustom5: TdxBarSubItem
      Caption = 'Custom Menu 5'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object siCustom6: TdxBarSubItem
      Caption = 'Custom Menu 6'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object bExportCodeExplorerAction: TdxBarButton
      Caption = 'Export code explorer'
      Category = 3
      Hint = 'Export code explorer'
      Visible = ivAlways
    end
    object bSearchDocsAction: TdxBarButton
      Caption = 'Search Documentation'
      Category = 14
      Hint = 'Search Documentation'
      Visible = ivAlways
    end
    object bAutoSynCheckStrippedAction: TdxBarButton
      Caption = 'AutoSynCheckStrippedAction'
      Category = 6
      Hint = 'AutoSynCheckStrippedAction'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object siCustom7: TdxBarSubItem
      Caption = 'Custom Menu 7'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object siCustom8: TdxBarSubItem
      Caption = 'Custom Menu 8'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object siCustom9: TdxBarSubItem
      Caption = 'Custom Menu 9'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object siCustom10: TdxBarSubItem
      Caption = 'Custom Menu 10'
      Category = 18
      Visible = ivAlways
      ItemLinks = <>
    end
    object siTrayIconMenu: TdxBarSubItem
      Caption = '&Tray Icon'
      Category = 16
      Description = 'Pop-up menu of OptiPerl'#39's icon in the windows tray bar'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bOpenAction
          Visible = True
        end
        item
          BeginGroup = True
          Item = liOpenWindows
          Visible = True
        end>
    end
    object siToggleBookmarks: TdxBarSubItem
      Caption = '&Toggle Bookmarks'
      Category = 17
      Description = 'Sets bookmarks in editor'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bTog0BookmarkAction
          Visible = True
        end
        item
          Item = bTog1BookmarkAction
          Visible = True
        end
        item
          Item = bTog2BookmarkAction
          Visible = True
        end
        item
          Item = bTog3BookmarkAction
          Visible = True
        end
        item
          Item = bTog4BookmarkAction
          Visible = True
        end
        item
          Item = bTog5BookmarkAction
          Visible = True
        end
        item
          Item = bTog6BookmarkAction
          Visible = True
        end
        item
          Item = bTog7BookmarkAction
          Visible = True
        end
        item
          Item = bTog8BookmarkAction
          Visible = True
        end
        item
          Item = bTog9BookmarkAction
          Visible = True
        end>
    end
    object bProjOpenRemoteAction: TdxBarButton
      Caption = 'ProjOpenRemoteAction'
      Category = 4
      Hint = 'ProjOpenRemoteAction'
      Visible = ivAlways
    end
    object liDefaultLanguages: TdxBarListItem
      Tag = 1
      Caption = '&Default Languages'
      Category = 0
      Visible = ivAlways
      OnClick = liLanguagesClick
      OnGetData = liDefaultLanguagesGetData
      ShowCheck = True
    end
    object liOtherLanguages: TdxBarListItem
      Caption = '&Other Languages'
      Category = 0
      Visible = ivAlways
      OnClick = liLanguagesClick
      OnGetData = liOtherLanguagesGetData
      ShowCheck = True
    end
    object bExportHTMLAction: TdxBarButton
      Caption = '&Export to Html'
      Category = 0
      HelpContext = 70
      Hint = 'Export to Html'
      Visible = ivAlways
    end
    object bExportRTFAction: TdxBarButton
      Caption = 'Export to &Rtf'
      Category = 0
      HelpContext = 70
      Hint = 'Export to Rtf'
      Visible = ivAlways
    end
    object bPrintAction: TdxBarButton
      Caption = '&Print...'
      Category = 0
      HelpContext = 70
      Hint = 'Print'
      Visible = ivAlways
      ImageIndex = 37
    end
    object bExitAction: TdxBarButton
      Caption = 'E&xit'
      Category = 0
      HelpContext = 70
      Hint = 'Exit'
      Visible = ivAlways
      ImageIndex = 1
    end
    object bCopyPostAction: TdxBarButton
      Caption = 'Copy from POST'
      Category = 7
      Visible = ivAlways
    end
    object bOpenAutoViewAction: TdxBarButton
      Caption = 'Auto View'
      Category = 8
      Hint = 'Auto View'
      Visible = ivAlways
    end
    object bProfilerAction: TdxBarButton
      Caption = 'Profiler'
      Category = 8
      Hint = 'Profiler'
      Visible = ivNever
    end
    object bWinCascadeAction: TdxBarButton
      Caption = 'Cascade'
      Category = 13
      Hint = 'Cascade'
      Visible = ivAlways
    end
    object bWinTileAction: TdxBarButton
      Caption = 'Tile'
      Category = 13
      Hint = 'Tile'
      Visible = ivAlways
    end
    object bNextWindowAction: TdxBarButton
      Caption = 'Next Window'
      Category = 13
      Hint = 'Next Window'
      Visible = ivAlways
    end
    object bConfToolsAction: TdxBarButton
      Caption = '&Configure...'
      Category = 8
      HelpContext = 340
      Hint = 'Configure'
      Visible = ivAlways
      ImageIndex = 82
    end
    object liPlugWins: TdxBarListItem
      Caption = 'Plug-In Windows'
      Category = 10
      Visible = ivAlways
      OnClick = liPlugWinsClick
      OnGetData = liPlugWinsGetData
    end
    object bUpdatePluginAction: TdxBarButton
      Caption = 'Update plugins'
      Category = 10
      Hint = 'Update plugins'
      Visible = ivAlways
    end
    object siPlugins: TdxBarSubItem
      Caption = 'Start/stop Plug-ins'
      Category = 10
      Description = 'Automatically lists all plug-ins'
      Visible = ivAlways
      ItemLinks = <>
    end
    object bDelCharLeftAction: TdxBarButton
      Caption = 'DelCharLeftAction'
      Category = 2
      Hint = 'DelCharLeftAction'
      Visible = ivAlways
    end
    object bDelCharRightAction: TdxBarButton
      Caption = 'DelCharRightAction'
      Category = 2
      Hint = 'DelCharRightAction'
      Visible = ivAlways
    end
    object bDelCharRightVIAction: TdxBarButton
      Caption = 'DelCharRightVIAction'
      Category = 2
      Hint = 'DelCharRightVIAction'
      Visible = ivAlways
    end
    object bDelWholeLineAction: TdxBarButton
      Caption = 'DelWholeLineAction'
      Category = 2
      Hint = 'DelWholeLineAction'
      Visible = ivAlways
    end
    object bDeleteLineBreakAction: TdxBarButton
      Caption = 'DeleteLineBreakAction'
      Category = 2
      Hint = 'DeleteLineBreakAction'
      Visible = ivAlways
    end
    object bInsertNewLineAction: TdxBarButton
      Caption = 'InsertNewLineAction'
      Category = 2
      Hint = 'InsertNewLineAction'
      Visible = ivAlways
    end
    object bDuplicateLineActon: TdxBarButton
      Caption = 'DuplicateLineActon'
      Category = 2
      Hint = 'DuplicateLineActon'
      Visible = ivAlways
    end
    object bSelectLineAction: TdxBarButton
      Caption = 'SelectLineAction'
      Category = 2
      Hint = 'SelectLineAction'
      Visible = ivAlways
    end
    object bDeleteToEOLAction: TdxBarButton
      Caption = 'DeleteToEOLAction'
      Category = 2
      Hint = 'DeleteToEOLAction'
      Visible = ivAlways
    end
    object bDeleteToStartAction: TdxBarButton
      Caption = 'DeleteToStartAction'
      Category = 2
      Hint = 'DeleteToStartAction'
      Visible = ivAlways
    end
    object bDeleteWordAction: TdxBarButton
      Caption = 'DeleteWordAction'
      Category = 2
      Hint = 'DeleteWordAction'
      Visible = ivAlways
    end
    object bToggleSelOptionAction: TdxBarButton
      Caption = 'ToggleSelOptionAction'
      Category = 2
      Hint = 'ToggleSelOptionAction'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object bTestErrorAction: TdxBarButton
      Caption = '&Syntax check'
      Category = 6
      HelpContext = 630
      Hint = 'Syntax check'
      Visible = ivAlways
      ImageIndex = 128
      ShortCut = 116
    end
    object bTestErrorExpAction: TdxBarButton
      Caption = 'E&xpanded syntax check'
      Category = 6
      HelpContext = 630
      Hint = 'Expanded syntax check'
      Visible = ivAlways
      ImageIndex = 128
      ShortCut = 16500
    end
    object bSubListAction: TdxBarButton
      Caption = 'Sub List'
      Category = 3
      Hint = 'Sub List'
      Visible = ivAlways
    end
    object bGoToLineAction: TdxBarButton
      Caption = '&Go to Line Number...'
      Category = 3
      HelpContext = 350
      Hint = 'Go to Line Number'
      Visible = ivAlways
      ImageIndex = 120
      ShortCut = 16455
    end
    object siGotoBookmarks: TdxBarSubItem
      Caption = '&Goto Bookmarks'
      Category = 17
      Description = 'Navigates to bookmarks in editor'
      Visible = ivAlways
      ItemLinks = <
        item
          Item = bGoto0BookmarkAction
          Visible = True
        end
        item
          Item = bGoto1BookmarkAction
          Visible = True
        end
        item
          Item = bGoto2BookmarkAction
          Visible = True
        end
        item
          Item = bGoto3BookmarkAction
          Visible = True
        end
        item
          Item = bGoto4BookmarkAction
          Visible = True
        end
        item
          Item = bGoto5BookmarkAction
          Visible = True
        end
        item
          Item = bGoto6BookmarkAction
          Visible = True
        end
        item
          Item = bGoto7BookmarkAction
          Visible = True
        end
        item
          Item = bGoto8BookmarkAction
          Visible = True
        end
        item
          Item = bGoto9BookmarkAction
          Visible = True
        end>
    end
    object bMatchBracketAction: TdxBarButton
      Caption = 'Find &Matching Bracket'
      Category = 3
      Hint = 'Find Matching Bracket'
      Visible = ivAlways
      ImageIndex = 6
      ShortCut = 16604
    end
    object bMatchBracketSelectAction: TdxBarButton
      Caption = 'MatchBracketSelectAction'
      Category = 3
      Hint = 'MatchBracketSelectAction'
      Visible = ivAlways
    end
    object bCopyPathInfoAction: TdxBarButton
      Caption = 'Copy from PathInfo'
      Category = 7
      Visible = ivAlways
    end
    object bFindSubAction: TdxBarButton
      Caption = 'Find Subroutine'
      Category = 3
      Hint = 'Find Subroutine'
      Visible = ivAlways
      ShortCut = 16450
    end
    object bTextStyle5: TdxBarButton
      Caption = 'TextStyle5'
      Category = 1
      Hint = 'TextStyle5'
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object siToolBars: TdxBarToolbarsListItem
      Caption = '&Toolbars'
      Category = 17
      Description = 'List of assigned toolbars'
      Visible = ivAlways
    end
    object siCVS: TdxBarSubItem
      Caption = '&CVS'
      Category = 17
      Description = 'Commands for CVS'
      Visible = ivAlways
      ItemLinks = <>
    end
    object bBrowseBackAction: TdxBarButton
      Caption = 'BrowseBack'
      Category = 3
      Hint = 'BrowseBackAction'
      Visible = ivAlways
      ImageIndex = 180
    end
    object bSwapVersionAction: TdxBarButton
      Caption = 'Swap Version'
      Category = 3
      Hint = 'Swap Version'
      Visible = ivAlways
    end
    object bFindDeclarationAction: TdxBarButton
      Caption = 'Find &Declaration'
      Category = 3
      Hint = 'Find Declaration'
      Visible = ivAlways
      ImageIndex = 10
    end
    object bHighDeclarationAction: TdxBarButton
      Caption = 'HighDeclaration'
      Category = 3
      Hint = 'HighDeclaration'
      Visible = ivAlways
    end
    object liServerStatus: TdxBarListItem
      Caption = 'Server Status'
      Category = 12
      Visible = ivAlways
      OnGetData = liServerStatusGetData
      ItemIndex = 0
      Items.Strings = (
        '1'
        '2')
      ShowCheck = True
    end
    object bGoto0GlobalAction: TdxBarButton
      Caption = '0'
      Category = 15
      Hint = '0'
      Visible = ivAlways
    end
    object bGoto1GlobalAction: TdxBarButton
      Caption = '1'
      Category = 15
      Hint = '1'
      Visible = ivAlways
    end
    object bGoto2GlobalAction: TdxBarButton
      Caption = '2'
      Category = 15
      Hint = '2'
      Visible = ivAlways
    end
    object bGoto3GlobalAction: TdxBarButton
      Caption = '3'
      Category = 15
      Hint = '3'
      Visible = ivAlways
    end
    object bGoto4GlobalAction: TdxBarButton
      Caption = '4'
      Category = 15
      Hint = '4'
      Visible = ivAlways
    end
    object bGoto5GlobalAction: TdxBarButton
      Caption = '5'
      Category = 15
      Hint = '5'
      Visible = ivAlways
    end
    object bGoto6GlobalAction: TdxBarButton
      Caption = '6'
      Category = 15
      Hint = '6'
      Visible = ivAlways
    end
    object bGoto7GlobalAction: TdxBarButton
      Caption = '7'
      Category = 15
      Hint = '7'
      Visible = ivAlways
    end
    object bGoto8GlobalAction: TdxBarButton
      Caption = '8'
      Category = 15
      Hint = '8'
      Visible = ivAlways
    end
    object bGoto9GlobalAction: TdxBarButton
      Caption = '9'
      Category = 15
      Hint = '9'
      Visible = ivAlways
    end
    object bOpenWatchesAction: TdxBarButton
      Caption = '&Watches...'
      Category = 5
      HelpContext = 440
      Hint = 'Watches'
      Visible = ivAlways
      ImageIndex = 90
      ShortCut = 16502
    end
    object bAutoEvaluationAction: TdxBarButton
      Caption = 'Live Evaluation E&nabled'
      Category = 5
      HelpContext = 510
      Hint = 'Live Evaluation Enabled'
      Visible = ivAlways
      ButtonStyle = bsChecked
      Down = True
      ShortCut = 24662
    end
  end
  object TrayPopup: TdxBarPopupMenu
    BarManager = BarManager
    ItemLinks = <>
    UseOwnFont = False
    Left = 96
    Top = 152
  end
  object TrayIcon: TJvTrayIcon
    Icon.Data = {
      0000010001002020040000000000E80200001600000028000000200000004000
      0000010004000000000000020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      00000000000000000000000000000078888888888888888888880800000007FF
      873333378FFFFFFFFFFF80800000078833333331388888888888808000000783
      33333333338FFFFFFFFF80800000073BBBBB3333133FFFFFFFFF8080000007BB
      BBBBBB333337888888888080000007BBBBBBBBB33333FFFFFFFF808000000BBB
      BBBBBBB3333307FFFFFF8080000007BB888BBBBB3333F7000008808000000BB8
      888BBBBB3333FBF833308080000007BBFFF8BBBB33333FBF83330080000007B8
      888BBBBB333783BBF83334800000078BB88BBBBB3338FF3FBB8330800000078B
      BBBBBBB3337FFFF3FBF80000000007888BBBBB33388888883FB00000400007FF
      887BBB378FFFFFFFF3000000440007FFFFFFFFFFFFFFFFFFFF0F004CC4400788
      88888888888888888800F4C4CC4007FFFFFFFFFFFFFFFFFFFFF00CCC4CC007FF
      FFFFFFFFFFFFFFFFFFFF4CBCC4C00788888888888888888888884CCFCC4007FF
      FFFFFFFFFFFFFFFFFFFF84CCFCC007FFFFFFFFFFFFFFFFFFFFFF804CCBC00788
      888888888888888888888084CCF007FFFFFFFFFFFFFFFFFFFFFF80804CC007FF
      FFFFFFFFFFFFFFFFFFFF808004C007FFFFFFFFFFFFFFFFFFFFFF8080004007F0
      FF0FF0FF0FF0FF0FF0FF7080000007F0FF0FF0FF0FF0FF0FF0FF70800000007F
      77F77F77F77F77F77F77F000000000000000000000000000000000000000FFFF
      FFFFC00000BF8000001F8000001F8000001F8000001F8000001F8000001F8000
      001F8000001F8000001F8000001F8000001F8000001F8000001F800000078000
      0003800000018000000180000001800000018000000180000001800000018000
      000180000011800000198000001D8000001F8000001FC000003FE492497F}
    IconIndex = -1
    Visibility = [tvVisibleTaskBar, tvVisibleTaskList]
    OnClick = TrayIconClick
    Left = 400
    Top = 144
  end
  object FormStorage: TJvFormStorage
    Options = []
    StoredProps.Strings = (
      'cbUrls.Items'
      'cbUrls.Text')
    StoredValues = <>
    Left = 560
    Top = 232
  end
  object memTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = memTimerTimer
    Left = 560
    Top = 144
  end
  object ApplicationEvents: TApplicationEvents
    OnActivate = ApplicationEventsActivate
    OnDeactivate = ApplicationEventsDeactivate
    OnException = ApplicationEventsException
    OnSettingChange = ApplicationEventsSettingChange
    Left = 320
    Top = 176
  end
  object DockingManager: TaqDockingManager
    StyleManager = StyleManager
    Style = StyleManager.GradientStyle
    AutoDragDocking = True
    AutoHideButtons = True
    Enabled = True
    FloatingFormsOnTop = False
    FloatingFormType = fftNormal
    Images = CentralImageListMod.ImageList
    ShowDockButtonHint = True
    ShowDockingHint = True
    ShowImages = [ctCaption, ctTab]
    StoreOptions = [dsoFormPosition, dsoFormState]
    CaptionButtons = [dbiHide, dbiUndock, dbiMaximizeRestore, dbiCustom]
    OnPopupMenuCreate = DockingManagerPopupMenuCreate
    OnRegister = DockingManagerRegister
    OnUpdateActions = DockingManagerUpdateActions
    Left = 64
    Top = 240
    object dcEditorForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 117
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      OnShow = dcEditorFormShow
      Key = '{B59C998F-8CE9-489B-8B41-5DB8F56C1944}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcExplorerForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 100
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{46FA668A-16F8-4D9A-9D3E-2FAA7F2D8289}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcProjectForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 28
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{0CADCBB5-E4D1-416B-BBBF-17F521599E40}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPerlInfoForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 116
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{51925FEC-70A7-494D-A598-9D5779994697}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcAutoViewForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 52
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{ED801DFE-04CC-4F82-9457-DFF3CEED4C30}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcWebBrowserForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 105
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{35D371A3-82DD-417B-AD74-E8C2210AE61A}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPodViewerForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 123
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{549A32A1-0DC6-47F6-BCAA-C52591CAD5F3}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcLibrarianForm0: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 121
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{A71961F7-9E93-41DA-A4AF-D054C761139A}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcLibrarianForm1: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 121
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{F3923B4A-2D33-4BE1-BF5B-32400D76DF2C}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcLibrarianForm2: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 121
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{877A0FAA-D869-4F0D-BC6D-60B3AEC19482}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcLibrarianForm3: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 121
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{EBC26A11-2B03-45A7-9A50-1F332E7430F4}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcQueryForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 129
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{5AAC2403-EFF9-40D9-B4B1-3A8274B43CE0}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcFTPSelectForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 42
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{2069688A-899E-4483-B34E-B6F390AB0287}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcURLEncodeForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 124
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{2156E717-40BD-41F5-A1B6-02D4DB73A55D}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcFileExploreForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 12
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{962729C7-0408-443A-9D35-9D407431FBBE}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcStatusForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 128
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{5AFD1F7E-91B4-41E2-88B0-8EB2B8D8E7F8}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcListSubNames: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 41
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{C2BA0C4A-CBBC-4FBD-9C3D-38DB43C1A295}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPackVariables: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 68
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{EAA5DACF-60F4-4E7F-A835-332A71485968}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcMethodsCall: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 86
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{DBEAC9D1-C21D-431A-B95D-4F9EBDD69FB6}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcWatchForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 90
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{7E89AEC7-C922-4DD9-A0F9-A985D217B637}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcTodoForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 29
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{EE07875D-999B-4C28-964A-014FBD0E8C8F}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcErrorLogForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 2
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{25CAA0EF-9FF0-4671-BF56-F3F224305A6E}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcAccessLogForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 79
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{EE4EC795-CAF2-4F92-A838-8A898963DF3B}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcFileCompareForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 9
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{0A481946-8B23-4649-AB0B-B8A25133F97B}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcEvalExpForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 85
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{2D0FA175-5842-479B-82C1-2BA661F14168}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPerlPrinterForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 4
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{C8BCD46F-8CA6-4AF3-97DD-0235A900048A}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcRegExpTesterForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 125
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{D667F871-52FD-405A-ADF9-D240747D4B1F}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcRemoteDebForm: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 87
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{5F9B7697-D583-4DA9-9CDE-11FE2B8388B7}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcSecEditForm0: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 50
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{22202767-8692-426A-847D-B5E4BD23AC70}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcSecEditForm1: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 50
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{7B88D87F-FC22-423C-A341-8ECA1BB2FB13}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcSecEditForm2: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 50
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{19EB9CBA-448F-4A95-ADB1-ECFD92E50B89}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcSecEditForm3: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 50
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{47C68BE7-DD6A-4073-BEF7-4EB9F5C4B60D}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_0: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{BAA32DF6-D88A-4BB3-A8F3-A69E5516DA59}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_1: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{2E77349B-66C1-4AA4-AFBA-182B84FC592F}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_2: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{45ECB074-D4C7-45FC-85FC-DB302D0C0538}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_3: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{0915AE75-F7F4-4206-8691-90E1FA0D7B8F}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_4: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{EC058362-3C67-442B-A1C6-43D925214A85}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_5: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{9F14C02E-356A-42BB-935E-82080590359C}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_6: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{FAC43510-B65B-4291-B193-3F5DAC8A8A6D}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_7: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{C5A406BB-18E6-4B21-A16F-E38921FFECA2}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_8: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{41B850A1-4A01-465F-AC05-CEDDDBA0EB3E}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcPlugIn_9: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 146
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{3BA37789-3100-4E34-BCB8-42CB1DC77FB1}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
    object dcCallStack: TaqDockingControl
      Width = 767
      Height = 203
      ImageIndex = 171
      MinWidth = 0
      MinHeight = 0
      ShowCaption = bvDefault
      ShowImage = bvDefault
      Visible = True
      Key = '{BBBCBE7B-536B-4E1A-BA0E-4FAB129A2835}'
      DesignClientHeight = 203
      DesignClientWidth = 767
    end
  end
  object StyleManager: TaqStyleManager
    Left = 144
    Top = 240
    object DefaultStyle: TaqDefaultUIStyle
      InactiveTabColor.Bands = 256
      InactiveTabColor.EndColor = clWindow
      InactiveTabColor.FillType = gtSolid
      InactiveTabColor.StartColor = clBtnHighlight
      TabColor.Bands = 256
      TabColor.EndColor = clWindow
      TabColor.FillType = gtSolid
      TabColor.StartColor = clBtnFace
      TabPaneColor.Bands = 256
      TabPaneColor.EndColor = clWindow
      TabPaneColor.FillType = gtSolid
      TabPaneColor.StartColor = clBtnHighlight
      CaptionColor.Bands = 256
      CaptionColor.EndColor = clWindow
      CaptionColor.FillType = gtSolid
      CaptionColor.StartColor = clBtnFace
      CaptionButtonSize = 15
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Shell Dlg 2'
      CaptionFont.Style = []
      TabFont.Charset = DEFAULT_CHARSET
      TabFont.Color = clWindowText
      TabFont.Height = -11
      TabFont.Name = 'MS Shell Dlg 2'
      TabFont.Style = []
      Predefined = True
    end
    object ThemedStyle: TaqThemedUIStyle
      CaptionButtonSize = 15
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Shell Dlg 2'
      CaptionFont.Style = []
      SplitterHeight = 5
      SplitterWidth = 5
      TabFont.Charset = DEFAULT_CHARSET
      TabFont.Color = clWindowText
      TabFont.Height = -11
      TabFont.Name = 'MS Shell Dlg 2'
      TabFont.Style = []
      Predefined = True
      object TaqCaptionButtonWidgets
        HideButton.PartIndex = bwCloseButton
        HideButton.ImageIndex = 0
        UndockButton.PartIndex = bwDropDown
        UndockButton.ImageIndex = 1
        MaximizeButton.PartIndex = bwMaxButton
        MaximizeButton.ImageIndex = 2
        RestoreButton.PartIndex = bwRestoreButton
        RestoreButton.ImageIndex = 3
        HelpButton.PartIndex = bwHelpButton
        HelpButton.ImageIndex = 5
        CustomButton.PartIndex = bwNone
        CustomButton.ImageIndex = 4
        Images = RunImageList
        DrawStyle = idsCenter
      end
    end
    object GradientStyle: TaqDefaultUIStyle
      InactiveTabColor.Bands = 256
      InactiveTabColor.EndColor = clWindow
      InactiveTabColor.FillType = gtVertical
      InactiveTabColor.StartColor = clBtnFace
      TabColor.Bands = 256
      TabColor.EndColor = clBtnFace
      TabColor.FillType = gtVertical
      TabColor.StartColor = clBtnHighlight
      TabPaneColor.Bands = 256
      TabPaneColor.EndColor = clWindow
      TabPaneColor.FillType = gtVertical
      TabPaneColor.StartColor = clBtnFace
      CaptionColor.Bands = 256
      CaptionColor.EndColor = clWindow
      CaptionColor.FillType = gtHorizontal
      CaptionColor.StartColor = clBtnFace
      CaptionButtonSize = 30
      CaptionFont.Charset = DEFAULT_CHARSET
      CaptionFont.Color = clWindowText
      CaptionFont.Height = -11
      CaptionFont.Name = 'MS Shell Dlg 2'
      CaptionFont.Style = []
      TabFont.Charset = DEFAULT_CHARSET
      TabFont.Color = clWindowText
      TabFont.Height = -11
      TabFont.Name = 'Tahoma'
      TabFont.Style = []
      Caption = 'Gradient'
    end
  end
  object TipDlg: TJvTipOfDay
    ButtonNext.Caption = '&Next Tip'
    ButtonNext.Flat = False
    ButtonNext.HotTrack = False
    ButtonNext.HotTrackFont.Charset = DEFAULT_CHARSET
    ButtonNext.HotTrackFont.Color = clWindowText
    ButtonNext.HotTrackFont.Height = -11
    ButtonNext.HotTrackFont.Name = 'MS Shell Dlg 2'
    ButtonNext.HotTrackFont.Style = []
    ButtonNext.ShowHint = False
    ButtonClose.Caption = '&Close'
    ButtonClose.Flat = False
    ButtonClose.HotTrack = False
    ButtonClose.HotTrackFont.Charset = DEFAULT_CHARSET
    ButtonClose.HotTrackFont.Color = clWindowText
    ButtonClose.HotTrackFont.Height = -11
    ButtonClose.HotTrackFont.Name = 'MS Shell Dlg 2'
    ButtonClose.HotTrackFont.Style = []
    ButtonClose.ShowHint = False
    CheckBoxText = '&Show tips on start-up'
    HeaderText = 'Did you know...'
    Options = []
    Title = 'Tips and Tricks'
    Left = 400
    Top = 233
  end
  object IconList: TImageList
    Masked = False
    Left = 232
    Top = 241
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001001000000000000018
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000841000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630CE71C0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630CE71C4A29000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008410E71C4A298C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630CE71C4A298C318C310000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630CE71C4A298C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008410E71C4A29000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008410E71C0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630C00000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C310000000000000000
      000000000000000000008C310000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      396700000000CE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      3967D65A524ACE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      3967D65A524ACE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      3967D65A524ACE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      3967D65A524ACE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      396700000000CE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C310000000000000000
      000000000000000000008C310000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFF00000000FDFFFFFF00000000
      FCFFFC7F00000000FC7FFC7F00000000FC3FFFFF00000000FC1FFC7F00000000
      FC0FFC3F00000000FC07FE1F00000000FC0FFF0F00000000FC1FF18F00000000
      FC3FF18F00000000FC7FF81F00000000FCFFFC3F00000000FDFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      CFE7F9FFE003FFFFC7C7F8C7EFFBE03FE38FF807EFFBEFBFF11FF807EFFBEFBF
      F83FF807EFFBEFA7FC7F8007EFFBEFB7F83FF807EFFBE037F11FF807EFFBE037
      E38FF8C7E003FFF7C7C7F9FFE003FC07CFE7F9FFE003FC07FFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object RunImageList: TImageList
    Masked = False
    Left = 304
    Top = 241
    Bitmap = {
      494C010106000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001001000000000000018
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000841000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630CE71C0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630CE71C4A29000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008410E71C4A298C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630CE71C4A298C318C310000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630CE71C4A298C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008410E71C4A29000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00008410E71C0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000630C00000000000000000000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C310000000000000000
      000000000000000000008C310000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      396700000000CE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      3967D65A524ACE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      3967D65A524ACE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      3967D65A524ACE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      3967D65A524ACE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      396700000000CE398C3100000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009C73
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C310000000000000000
      000000000000000000008C310000000000000000000000000000000000000000
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
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFF00000000FDFFFFFF00000000
      FCFFFC7F00000000FC7FFC7F00000000FC3FFFFF00000000FC1FFC7F00000000
      FC0FFC3F00000000FC07FE1F00000000FC0FFF0F00000000FC1FF18F00000000
      FC3FF18F00000000FC7FF81F00000000FCFFFC3F00000000FDFFFFFF00000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      CFE7F9FFE003FFFFC7C7F8C7EFFBE03FE38FF807EFFBEFBFF11FF807EFFBEFBF
      F83FF807EFFBEFA7FC7F8007EFFBEFB7F83FF807EFFBE037F11FF807EFFBE037
      E38FF8C7E003FFF7C7C7F9FFE003FC07CFE7F9FFE003FC07FFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object DataEmbedded: TJvDataEmbedded
    Size = 1547
    Left = 472
    Top = 145
    EmbeddedData = {
      0B060000484B444F4332020000000000000003FCFFFFFFFCFFFFFF04040000E6
      02000002000000000000000000000000000000000000D1050000847F1B07ECCA
      444D85BABC29248C1FF201BC050000901352EE8BD111D599FE00D0B749C8FE00
      0000006500000000040000E202000000000000000000000052000000436F6465
      204578706C6F7265722C2050726F6A656374204E657750726F6A6563742C2045
      6469746F722C20517565727920456469746F722C205765622042726F77736572
      2C20506F64205854726163746F72000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000003000000AD0100007FB01356
      8BD111D599FE00D0B749C8FE0000000065000000CB000000E202000000000000
      000000000021000000436F6465204578706C6F7265722C2050726F6A65637420
      4E657750726F6A65637401000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000002000000840000008A66FA46F8169A4D
      9D3E2FAA7F2D82890000000065000000CB000000F30100000000000000000000
      000D000000436F6465204578706C6F7265720000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000089000000
      B5CBAD0CD1E46B41BBBF17F521599E4000000000FA010000CB000000E2020000
      6D01000018000000001200000050726F6A656374204E657750726F6A65637404
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000009801000069C0EFDE8BD111D599FE00D0B749C8FED20000
      0065000000E6020000E202000000000000000000000014000000456469746F72
      2C20517565727920456469746F72000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000020000007D0000008F999CB5
      E98C9B488B415DB8F56C1944D20000007D000000E6020000E20200004A000000
      7D0200000006000000456469746F720000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000830000000324AC
      5AF9EFD940B4B13A8274B43CE0D20000007D000000E6020000E2020000000000
      0000000000000C000000517565727920456469746F7200000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000A201000069C0EFDE8BD111D599FE00D0B749C8FEED020000650000
      0000040000E2020000000000000000000000190000005765622042726F777365
      722C20506F64205854726163746F720300000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000200000082000000A371D3
      35DD827B41AD74E8C2210AE61AED0200007D00000000040000E2020000620300
      007D020000000B0000005765622042726F777365720000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000083
      000000A1329A54C60DF647BCAAC52591CAD5F3ED0200007D00000000040000E2
      0200000000000000000000000C000000506F64205854726163746F7200000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000}
  end
end
