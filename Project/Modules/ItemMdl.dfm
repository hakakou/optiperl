object ItemMod: TItemMod
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 452
  Top = 191
  Height = 178
  Width = 259
  object ItemList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 40
    Top = 16
    object OptionsAction: THKAction
      Category = 'Tools'
      Caption = '&Options...'
      HelpContext = 390
      Hint = 'Show options'
      ImageIndex = 18
      ShortCut = 24655
      OnExecute = OptionsActionExecute
      UserData = 0
    end
    object IndentAction: THKAction
      Category = 'Editing'
      Caption = '&Indent Block'
      Hint = 'Increase block indent'
      ImageIndex = 16
      ShortCut = 16571
      OnExecute = IndentActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object OutdentAction: THKAction
      Category = 'Editing'
      Caption = '&Outdent Block'
      Hint = 'Decrease block indent'
      ImageIndex = 15
      ShortCut = 16573
      OnExecute = OutdentActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DelCharLeftAction: THKAction
      Category = 'Editing'
      Caption = 'Delete Character Left'
      Hint = 'Delete character left of cursor'
      OnExecute = DelCharLeftActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DelCharRightAction: THKAction
      Category = 'Editing'
      Caption = 'Delete Character Right'
      Hint = 'Delete character right of cursor'
      OnExecute = DelCharRightActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DelCharRightVIAction: THKAction
      Category = 'Editing'
      Caption = 'Delete Character Right VI Style'
      Hint = 'Delete character right of cursor (VI style)'
      OnExecute = DelCharRightVIActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object EditColorAction: THKAction
      Category = 'Tools'
      Caption = 'Customize Color...'
      Hint = 
        'Open option dialog and selects the color under the cursor of the' +
        ' editor'
      ImageIndex = 147
      OnExecute = EditColorActionExecute
      UserData = 0
    end
    object CustToolsAction: THKAction
      Category = 'Tools'
      Caption = 'Edit &Toolbars...'
      Hint = 'Edit main menu and toolbars'
      ImageIndex = 49
      OnExecute = CustToolsActionExecute
      UserData = 2
    end
    object ForwardAction: THKAction
      Category = 'Browser'
      Caption = '&Forward'
      HelpContext = 300
      Hint = 'Web browser next page'
      ImageIndex = 109
      ShortCut = 16605
      OnExecute = ForwardActionExecute
      OnUpdate = ForwardActionUpdate
      UserData = 0
    end
    object BackAction: THKAction
      Category = 'Browser'
      Caption = '&Back'
      HelpContext = 300
      Hint = 'Web browser previous page'
      ImageIndex = 108
      ShortCut = 16603
      OnExecute = BackActionExecute
      OnUpdate = BackActionUpdate
      UserData = 0
    end
    object EditShortCutAction: THKAction
      Category = 'Tools'
      Caption = 'Edit &Shortcuts...'
      Hint = 'Edit shortcuts'
      ImageIndex = 14
      OnExecute = EditShortCutActionExecute
      UserData = 0
    end
    object RefreshAction: THKAction
      Category = 'Browser'
      Caption = '&Refresh'
      HelpContext = 300
      Hint = 'Refresh page'
      ImageIndex = 110
      ShortCut = 24658
      OnExecute = RefreshActionExecute
      OnUpdate = RefreshActionUpdate
      UserData = 0
    end
    object StopAction: THKAction
      Category = 'Browser'
      Caption = '&Stop'
      HelpContext = 510
      Hint = 'Stop loading'
      ImageIndex = 101
      ShortCut = 24659
      OnExecute = StopActionExecute
      UserData = 0
    end
    object FileExplorerAction: THKAction
      Category = 'Tools'
      Caption = '&File Explorer'
      Hint = 'File explorer'
      ImageIndex = 12
      ShortCut = 16459
      OnExecute = FileExplorerActionExecute
      UserData = 0
    end
    object FindAction: THKAction
      Tag = 1
      Category = 'Search'
      Caption = '&Find'
      HelpContext = 490
      Hint = 'Find text'
      ImageIndex = 95
      ShortCut = 16454
      OnExecute = FindActionExecute
      UserData = 0
    end
    object RemoteExplorerAction: THKAction
      Category = 'Tools'
      Caption = 'Remote Explorer'
      Hint = 'Remote Explorer'
      ImageIndex = 42
      OnExecute = RemoteExplorerActionExecute
      UserData = 0
    end
    object RemoteSessionsAction: THKAction
      Category = 'Tools'
      Caption = 'Remo&te Sessions'
      HelpContext = 200
      Hint = 'Setup remote sessions'
      ImageIndex = 46
      ShortCut = 24661
      OnExecute = RemoteSessionsActionExecute
      UserData = 0
    end
    object CodeLibAction: THKAction
      Category = 'Tools'
      Caption = 'Code &Librarian'
      HelpContext = 380
      Hint = 'Code Librarian'
      ImageIndex = 121
      ShortCut = 16460
      OnExecute = CodeLibActionExecute
      OnUpdate = CodeLibActionUpdate
      UserData = 0
    end
    object SearchAgainAction: THKAction
      Tag = 1
      Category = 'Search'
      Caption = 'Find &Next'
      HelpContext = 350
      Hint = 'Find next occurence without prompting'
      ImageIndex = 84
      ShortCut = 114
      OnExecute = SearchAgainActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object SearchNextAction: THKAction
      Category = 'Search'
      Caption = 'Find Word Under &Cursor'
      Hint = 'Find word under cursor without prompting'
      ImageIndex = 185
      ShortCut = 32882
      OnExecute = SearchNextActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object ReplaceAction: THKAction
      Tag = 1
      Category = 'Search'
      Caption = '&Replace'
      HelpContext = 350
      Hint = 'Find and replace text'
      ImageIndex = 83
      ShortCut = 16466
      OnExecute = ReplaceActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object UndoAction: THKAction
      Category = 'Edit'
      Caption = '&Undo'
      HelpContext = 350
      Hint = 'Undo last edit'
      ImageIndex = 112
      ShortCut = 16474
      UserData = 0
    end
    object RedoAction: THKAction
      Tag = 1
      Category = 'Edit'
      Caption = '&Redo'
      HelpContext = 350
      Hint = 'Redo last edit'
      ImageIndex = 113
      ShortCut = 16473
      UserData = 0
    end
    object CutAction: THKAction
      Tag = 1
      Category = 'Edit'
      Caption = '&Cut'
      HelpContext = 350
      Hint = 'Cut selected text'
      ImageIndex = 103
      ShortCut = 16472
      UserData = 0
    end
    object CopyAction: THKAction
      Tag = 1
      Category = 'Edit'
      Caption = 'C&opy'
      Enabled = False
      HelpContext = 350
      Hint = 'Copy selected text'
      ImageIndex = 78
      ShortCut = 16451
      UserData = 0
    end
    object PatternSearchAction: THKAction
      Category = 'Search'
      Caption = '&Advanced Search && Replace...'
      HelpContext = 370
      Hint = 
        'Search && replace using a regular expression. All results are lo' +
        'gged in the code explorer window.'
      ImageIndex = 118
      ShortCut = 16498
      OnExecute = PatternSearchActionExecute
      UserData = 0
    end
    object PrevSearchAction: THKAction
      Category = 'Search'
      Caption = 'Previous Match'
      Hint = 'Positions cursor on previous match found'
      ImageIndex = 183
      ShortCut = 32806
      OnExecute = NextPrevSearchActionExecute
      UserData = 0
    end
    object NextSearchAction: THKAction
      Tag = 1
      Category = 'Search'
      Caption = 'Next Match'
      Hint = 'Positions cursor on next match found'
      ImageIndex = 184
      ShortCut = 32808
      OnExecute = NextPrevSearchActionExecute
      UserData = 0
    end
    object OpenCodeExplorerAction: THKAction
      Category = 'Search'
      Caption = '&Code Explorer'
      HelpContext = 370
      Hint = 'Show code explorer'
      ImageIndex = 100
      OnExecute = OpenCodeExplorerActionExecute
      UserData = 0
    end
    object PasteAction: THKAction
      Tag = 1
      Category = 'Edit'
      Caption = '&Paste'
      Enabled = False
      Hint = 'Pastes text from clipboard'
      ImageIndex = 45
      ShortCut = 16470
      UserData = 0
    end
    object DeleteAction: THKAction
      Tag = 1
      Category = 'Edit'
      Caption = '&Delete'
      HelpContext = 350
      Hint = 'Delete selected text'
      ImageIndex = 89
      UserData = 0
    end
    object SelectAllAction: THKAction
      Category = 'Edit'
      Caption = 'Select &All'
      HelpContext = 350
      Hint = 'Select all'
      ShortCut = 16449
      UserData = 0
    end
    object CommentInAction: THKAction
      Category = 'Edit'
      Caption = 'Comment &In'
      Hint = 'Comment in block'
      ImageIndex = 17
      OnExecute = CommentInActionExecute
      OnUpdate = CommentInActionUpdate
      UserData = 0
    end
    object CommentOutAction: THKAction
      Category = 'Edit'
      Caption = 'Comment &Out'
      Hint = 'Comment out block'
      ImageIndex = 19
      OnExecute = CommentOutActionExecute
      OnUpdate = CommentOutActionUpdate
      UserData = 0
    end
    object CommentToggleAction: THKAction
      Category = 'Edit'
      Caption = '&Comment'
      Hint = 'Toggle comments in block'
      ImageIndex = 13
      OnExecute = CommentToggleActionExecute
      OnUpdate = CommentToggleActionUpdate
      UserData = 0
    end
    object AboutAction: THKAction
      Category = 'Help'
      Caption = '&About...'
      HelpContext = 10
      Hint = 'Shows information about OptiPerl'
      ImageIndex = 119
      OnExecute = AboutActionExecute
      UserData = 0
    end
    object HaulBrowserAction: THKAction
      Category = 'Browser'
      Caption = '&Halt Browser'
      HelpContext = 300
      Hint = 
        'Stop browser, release resources and delete all instances of perl' +
        ' in memory'
      ImageIndex = 107
      ShortCut = 24648
      OnExecute = HaulBrowserActionExecute
      UserData = 0
    end
    object OpenURLAction: THKAction
      Category = 'Browser'
      Caption = 'Go to &URL'
      HelpContext = 300
      Hint = 'Go to selected URL'
      ImageIndex = 111
      ShortCut = 16469
      OnExecute = OpenURLActionExecute
      UserData = 0
    end
    object OpenURLQueryAction: THKAction
      Category = 'Browser'
      Caption = 'Go to URL with &Query'
      Hint = 'Go to selected URL using options in query editor'
      ImageIndex = 126
      OnExecute = OpenURLQueryActionExecute
      UserData = 0
    end
    object ProxyEnableAction: THKAction
      Category = 'Browser'
      Caption = 'Spy HTTP Pro&xy'
      Hint = 'Enable spy HTTP Proxy'
      ImageIndex = 132
      OnExecute = ProxyEnableActionExecute
      OnUpdate = ProxyEnableActionUpdate
      UserData = 0
    end
    object InternetOptionsAction: THKAction
      Category = 'Browser'
      Caption = '&Internet Options'
      Hint = 'Windows internet options'
      ImageIndex = 11
      OnExecute = InternetOptionsActionExecute
      UserData = 0
    end
    object OpenBrowserWindowAction: THKAction
      Category = 'Browser'
      Caption = 'Sho&w Browser'
      HelpContext = 450
      Hint = 'Show browser'
      ImageIndex = 47
      ShortCut = 16507
      OnExecute = OpenBrowserWindowActionExecute
      UserData = 0
    end
    object ContinueAction: THKAction
      Category = 'Debug'
      Caption = '&Continue Script'
      HelpContext = 510
      Hint = 'Continue execution of script'
      ImageIndex = 97
      ShortCut = 115
      OnExecute = ContinueActionExecute
      OnUpdate = ContinueActionUpdate
      UserData = 0
    end
    object SingleStepAction: THKAction
      Category = 'Debug'
      Caption = 'S&ingle Step'
      HelpContext = 510
      Hint = 'Single step'
      ImageIndex = 96
      ShortCut = 118
      OnExecute = SingleStepActionExecute
      OnUpdate = SingleStepActionUpdate
      UserData = 0
    end
    object StepOverAction: THKAction
      Category = 'Debug'
      Caption = 'Step &Over'
      HelpContext = 510
      Hint = 'Step over'
      ImageIndex = 92
      ShortCut = 119
      OnExecute = StepOverActionExecute
      OnUpdate = StepOverActionUpdate
      UserData = 0
    end
    object ReturnFromSubAction: THKAction
      Category = 'Debug'
      Caption = 'Return from S&ubroutine'
      HelpContext = 510
      Hint = 'Return from subroutine'
      ImageIndex = 94
      ShortCut = 8307
      OnExecute = ReturnFromSubActionExecute
      OnUpdate = ReturnFromSubActionUpdate
      UserData = 0
    end
    object StopDebAction: THKAction
      Category = 'Debug'
      Caption = 'S&top Debugger'
      HelpContext = 510
      Hint = 'Stop debugger'
      ImageIndex = 89
      ShortCut = 117
      OnExecute = StopDebActionExecute
      OnUpdate = StopDebActionUpdate
      UserData = 0
    end
    object ActiveScriptDebAction: TAction
      Category = 'Debug'
      Caption = 'Select active script...'
      Hint = 'Selects script that will be  loaded when  you start the debugger'
      OnExecute = ActiveScriptDebActionExecute
      OnUpdate = ActiveScriptDebActionUpdate
    end
    object StartRemDebAction: THKAction
      Category = 'Debug'
      Caption = 'Listen for Remote De&bugger'
      Hint = 'Listen for remote debugger'
      ImageIndex = 87
      OnExecute = StartRemDebActionExecute
      OnUpdate = StartRemDebActionUpdate
      UserData = 0
    end
    object RemDebSetupAction: THKAction
      Category = 'Debug'
      Caption = 'Set-up && in&formation...'
      Hint = 'Information and tools to help set-up remote debugging'
      OnExecute = RemDebSetupActionExecute
      UserData = 0
    end
    object RedOutputAction: THKAction
      Category = 'Debug'
      Caption = 'Redirect Input && Output'
      Hint = 'Enable redirection of STDIN && STDOUT of remote script'
      OnExecute = RedOutputActionExecute
      OnUpdate = RedOutputActionUpdate
      UserData = 0
    end
    object ListSubAction: THKAction
      Category = 'Debug'
      Caption = '&List Subroutine Names'
      HelpContext = 510
      Hint = 'List subroutines'
      ImageIndex = 127
      ShortCut = 24691
      OnExecute = ListSubActionExecute
      OnUpdate = ListSubActionUpdate
      UserData = 1
    end
    object PackageVarsAction: THKAction
      Category = 'Debug'
      Caption = 'List &Variables in Package'
      HelpContext = 510
      Hint = 'List variables in package'
      ImageIndex = 68
      ShortCut = 24692
      OnExecute = PackageVarsActionExecute
      OnUpdate = PackageVarsActionUpdate
      UserData = 1
    end
    object MethodsCallAction: THKAction
      Category = 'Debug'
      Caption = '&Methods Callable'
      HelpContext = 510
      Hint = 'Methods callable'
      ImageIndex = 86
      ShortCut = 24693
      OnExecute = MethodsCallActionExecute
      OnUpdate = MethodsCallActionUpdate
      UserData = 1
    end
    object EvaluateVarAction: THKAction
      Category = 'Debug'
      Caption = '&Evaluate Expression'
      HelpContext = 510
      Hint = 'Window to evaluate expressions'
      ImageIndex = 48
      ShortCut = 24694
      OnExecute = EvaluateVarActionExecute
      UserData = 0
    end
    object CallStackAction: THKAction
      Category = 'Debug'
      Caption = 'Call Stack'
      Hint = 'Call stack'
      ImageIndex = 171
      ShortCut = 24695
      OnExecute = CallStackActionExecute
      UserData = 0
    end
    object ShowTemplatesAction: THKAction
      Category = 'Edit'
      Caption = '&Show Templates'
      HelpContext = 410
      Hint = 'Show templates'
      ShortCut = 16458
      OnExecute = ShowTemplatesActionExecute
      OnUpdate = EnIFMainMemoEnabled
      UserData = 0
    end
    object TemplateFormAction: THKAction
      Category = 'Edit'
      Caption = '&Edit Templates...'
      HelpContext = 410
      Hint = 'Edit templates'
      ImageIndex = 165
      OnExecute = TemplateFormActionExecute
      UserData = 0
    end
    object PerlInfoAction: THKAction
      Category = 'Help'
      Caption = 'Perl &Information'
      HelpContext = 400
      Hint = 'Information about installed Perl'
      ImageIndex = 70
      ShortCut = 24649
      OnExecute = PerlInfoActionExecute
      UserData = 0
    end
    object OpenTodoListAction: THKAction
      Category = 'Edit'
      Caption = 'To-Do &List'
      HelpContext = 360
      Hint = 'Shows to-do list window'
      ImageIndex = 29
      ShortCut = 24660
      OnExecute = OpenTodoListActionExecute
      UserData = 0
    end
    object NewEditWinAction: THKAction
      Category = 'Edit'
      Caption = '&New Edit Window'
      Hint = 'Open another editor window'
      ImageIndex = 50
      OnExecute = NewEditWinActionExecute
      OnUpdate = NewEditWinActionUpdate
      UserData = 0
    end
    object SyncScrollAction: THKAction
      Category = 'Edit'
      Caption = '&Synchronized Scrolling'
      Hint = 'Synchronize scrolling between editor windows'
      OnExecute = SyncScrollActionExecute
      OnUpdate = SyncScrollActionUpdate
      UserData = 0
    end
    object OpenEditorAction: THKAction
      Category = 'Edit'
      Caption = 'Show E&ditor'
      HelpContext = 350
      Hint = 'Show editor'
      ImageIndex = 93
      ShortCut = 16506
      OnExecute = OpenEditorActionExecute
      UserData = 0
    end
    object EditorBigAction: THKAction
      Category = 'Edit'
      Caption = 'Make Editor &Big'
      Enabled = False
      HelpContext = 350
      Hint = 'Increases the size of the editor window'
      ImageIndex = 83
      ShortCut = 122
      OnExecute = WinBigActionExecute
      OnUpdate = WinBigUpdate
      UserData = 0
    end
    object BrowserBigAction: THKAction
      Tag = 1
      Category = 'Browser'
      Caption = '&Make Browser Big'
      Enabled = False
      HelpContext = 450
      Hint = 'Increases the size of the browser window'
      ImageIndex = 81
      ShortCut = 123
      OnExecute = WinBigActionExecute
      OnUpdate = WinBigUpdate
      UserData = 0
    end
    object ScrollTabAction: THKAction
      Category = 'Browser'
      Caption = 'Next &Tab'
      Hint = 'Selects next page in web browser window'
      ImageIndex = 133
      ShortCut = 8315
      OnExecute = ScrollTabActionExecute
      UserData = 0
    end
    object RunBrowserAction: THKAction
      Category = 'Run'
      Caption = '&Run in Browser'
      Enabled = False
      HelpContext = 520
      Hint = 'Run in internal browser'
      ImageIndex = 98
      ShortCut = 120
      OnExecute = RunBrowserActionExecute
      OnUpdate = RunBrowserActionUpdate
      UserData = 0
    end
    object RunExtBrowserAction: THKAction
      Category = 'Run'
      Caption = 'Run in &External Browser'
      HelpContext = 520
      Hint = 'Run in external browser'
      ImageIndex = 99
      ShortCut = 16504
      OnExecute = RunExtBrowserActionExecute
      UserData = 0
    end
    object RunSecBrowserAction: THKAction
      Category = 'Run'
      Caption = 'Run in &Secondary Browser'
      Hint = 'Run in secondary browser'
      ImageIndex = 99
      OnExecute = RunSecBrowserActionExecute
      OnUpdate = RunSecBrowserActionUpdate
      UserData = 0
    end
    object PrRunInConsoleAction: THKAction
      Category = 'Run'
      Caption = 'Prompt && Run in &Console...'
      HelpContext = 520
      Hint = 'Run in console prompting first for parameters'
      ImageIndex = 3
      ShortCut = 8312
      OnExecute = PrRunInConsoleActionExecute
      UserData = 0
    end
    object RunInConsoleAction: THKAction
      Category = 'Run'
      Caption = 'Run in Co&nsole'
      Hint = 'Run in console'
      ImageIndex = 3
      ShortCut = 24696
      OnExecute = RunInConsoleActionExecute
      UserData = 0
    end
    object CheckForUpdateAction: THKAction
      Category = 'Help'
      Caption = 'Check for &Update...'
      HelpContext = 330
      Hint = 'Check if you have the latest version of OptiPerl'
      ImageIndex = 105
      OnExecute = CheckForUpdateActionExecute
      UserData = 0
    end
    object ShowHelpAction: THKAction
      Category = 'Help'
      Caption = '&Help Index'
      HelpContext = 10
      Hint = 'Show help index'
      ImageIndex = 130
      OnExecute = ShowHelpActionExecute
      UserData = 0
    end
    object ExportCodeExplorerAction: THKAction
      Category = 'Search'
      Caption = '&Export Code Explorer'
      Hint = 'Export code explorer'
      ImageIndex = 135
      OnExecute = ExportCodeExplorerActionExecute
      UserData = 0
    end
    object FindSubAction: THKAction
      Category = 'Search'
      Caption = 'Find Subroutine'
      Hint = 'Find subroutine in code explorer'
      ImageIndex = 26
      ShortCut = 16450
      OnExecute = FindSubActionExecute
      OnUpdate = EnIFMainMemoEnabled
      UserData = 0
    end
    object SubListAction: THKAction
      Category = 'Search'
      Caption = '&Subroutine List...'
      Hint = 'Opens the subroutine list window'
      ImageIndex = 41
      ShortCut = 16452
      OnExecute = SubListActionExecute
      UserData = 0
    end
    object GoToLineAction: THKAction
      Tag = 1
      Category = 'Search'
      Caption = '&Go to Line Number...'
      HelpContext = 350
      Hint = 'Go to a line number'
      ImageIndex = 120
      ShortCut = 16455
      OnExecute = GoToLineActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object RunWithServerAction: THKAction
      Category = 'Server'
      Caption = '&Run with Server'
      Checked = True
      HelpContext = 550
      Hint = 'Use a http address to load script in browser'
      OnExecute = RunWithServerActionExecute
      OnUpdate = RunWithServerActionUpdate
      UserData = 0
    end
    object OpenAccessLogsAction: THKAction
      Category = 'Server'
      Caption = 'View &Access Logs'
      HelpContext = 620
      Hint = 'View server access logs'
      ImageIndex = 79
      OnExecute = OpenAccessLogsActionExecute
      UserData = 0
    end
    object OpenErrorLogsAction: THKAction
      Category = 'Server'
      Caption = 'View &Error Logs'
      HelpContext = 620
      Hint = 'View server error logs'
      ImageIndex = 2
      OnExecute = OpenErrorLogsActionExecute
      UserData = 0
    end
    object InternalServerAction: THKAction
      Category = 'Server'
      Caption = '&Internal Server Enabled'
      HelpContext = 550
      Hint = 'Enable/disable internal server'
      OnExecute = InternalServerActionExecute
      UserData = 0
    end
    object ChangeRootAction: THKAction
      Category = 'Server'
      Caption = 'Change &Server Root'
      HelpContext = 550
      Hint = 'Selects folder to be the root of the internal server'
      ImageIndex = 122
      ShortCut = 24643
      OnExecute = ChangeRootActionExecute
      OnUpdate = ChangeRootActionUpdate
      UserData = 0
    end
    object ToggleBreakAction: THKAction
      Category = 'Debug'
      Caption = '&Add/Remove Breakpoint'
      HelpContext = 510
      Hint = 'Toggle breakpoint at cursor'
      ImageIndex = 114
      ShortCut = 16503
      OnExecute = ToggleBreakActionExecute
      OnUpdate = ToggleBreakActionUpdate
      UserData = 0
    end
    object OpenZipAction: THKAction
      Category = 'Tools'
      Caption = 'Open &Zip File'
      Hint = 'Opens a ZIP compressed file using Code Librarian'
      ImageIndex = 159
      OnExecute = OpenZipActionExecute
      OnUpdate = CodeLibActionUpdate
      UserData = 0
    end
    object PodExtractorAction: THKAction
      Category = 'Tools'
      Caption = 'Po&d Extractor'
      HelpContext = 420
      Hint = 'Pod Extractor'
      ImageIndex = 123
      ShortCut = 16464
      OnExecute = PodExtractorActionExecute
      OnUpdate = TrueIfActivePerlActionUpdate
      UserData = 0
    end
    object URLEncodeAction: THKAction
      Category = 'Tools'
      Caption = '&Encoder'
      HelpContext = 60
      Hint = 'URL Encoder'
      ImageIndex = 124
      ShortCut = 16457
      OnExecute = URLEncodeActionExecute
      UserData = 0
    end
    object PerlDocAction: THKAction
      Category = 'Help'
      Caption = '&Perl Documentation'
      HelpContext = 650
      Hint = 'Opens perl documentation'
      ImageIndex = 116
      OnExecute = PerlDocActionExecute
      UserData = 0
    end
    object ApacheDocAction: THKAction
      Category = 'Help'
      Caption = '&Apache Documentation'
      Hint = 'Opens apache documentation'
      ImageIndex = 69
      OnExecute = ApacheDocActionExecute
      UserData = 0
    end
    object BreakConditionAction: THKAction
      Category = 'Debug'
      Caption = 'Breakpoint Condition'
      Hint = 
        'Expression that must evaluate to true for the breakpoint to stop' +
        ' the execution of the script'
      ImageIndex = 170
      OnExecute = BreakConditionActionExecute
      OnUpdate = BreakConditionActionUpdate
      UserData = 0
    end
    object OpenWatchesAction: THKAction
      Category = 'Debug'
      Caption = '&Watches'
      HelpContext = 440
      Hint = 'Shows watch list window'
      ImageIndex = 90
      ShortCut = 16502
      OnExecute = OpenWatchesActionExecute
      UserData = 0
    end
    object PerlPrinterAction: THKAction
      Category = 'Tools'
      Caption = 'Perl &Printer'
      HelpContext = 430
      Hint = 'Perl printer'
      ImageIndex = 4
      ShortCut = 24656
      OnExecute = PerlPrinterActionExecute
      UserData = 0
    end
    object AutoEvaluationAction: THKAction
      Category = 'Debug'
      Caption = '&Live Evaluation'
      Checked = True
      HelpContext = 510
      Hint = 'Auto evaluation enabled'
      ShortCut = 24662
      OnExecute = AutoEvaluationActionExecute
      OnUpdate = AutoEvaluationActionUpdate
      UserData = 0
    end
    object AddToWatchAction: THKAction
      Category = 'Debug'
      Caption = 'Add to &Watches'
      Hint = 'Add statement to watches'
      ImageIndex = 90
      OnExecute = AddToWatchActionExecute
      OnUpdate = AddToWatchActionUpdate
      UserData = 0
    end
    object RegExpTesterAction: THKAction
      Category = 'Tools'
      Caption = '&Regular Expression Tester'
      Hint = 'Regular expression tester'
      ImageIndex = 125
      ShortCut = 16468
      OnExecute = RegExpTesterActionExecute
      UserData = 0
    end
    object MatchBracketAction: THKAction
      Category = 'Search'
      Caption = 'Find &Matching Bracket'
      Hint = 'Match bracket'
      ImageIndex = 6
      ShortCut = 16604
      OnExecute = MatchBracketActionExecute
      OnUpdate = EnIFMainMemoEnabled
      UserData = 0
    end
    object PerlTidyAction: THKAction
      Category = 'Tools'
      Caption = 'Perl &Tidy...'
      Hint = 'Perl tidy'
      ImageIndex = 7
      OnExecute = PerlTidyActionExecute
      UserData = 0
    end
    object FileCompareAction: THKAction
      Category = 'Tools'
      Caption = 'File Co&mpare'
      Hint = 'Compare files'
      ImageIndex = 9
      OnExecute = FileCompareActionExecute
      UserData = 0
    end
    object OpenAutoViewAction: THKAction
      Category = 'Tools'
      Caption = 'Auto View'
      Hint = 'File viewer that updates automatically'
      ImageIndex = 52
      OnExecute = OpenAutoViewActionExecute
      UserData = 0
    end
    object ProfilerAction: THKAction
      Category = 'Tools'
      Caption = '&Profiler...'
      Visible = False
      OnExecute = ProfilerActionExecute
      UserData = 0
    end
    object ConfToolsAction: THKAction
      Category = 'Tools'
      Caption = '&Configure User Tools...'
      HelpContext = 340
      Hint = 'Configure user tools'
      ImageIndex = 82
      OnExecute = ConfToolsActionExecute
      UserData = 0
    end
    object SendMailAction: THKAction
      Category = 'Run'
      Caption = '&Sendmail/Date Support...'
      Hint = 'Enable sendmail and date support in scripts'
      ImageIndex = 39
      OnExecute = SendMailActionExecute
      UserData = 0
    end
    object SelectStartPathAction: THKAction
      Category = 'Run'
      Caption = 'Select Starting &Path'
      Hint = 'Select starting path for script'
      OnExecute = SelectStartPathActionExecute
      UserData = 0
    end
    object SameAsScriptPathAction: THKAction
      Category = 'Run'
      Caption = 'Same Path as S&cript'
      Checked = True
      Hint = 'Have the starting path same as the script'#39's path'
      OnExecute = SameAsScriptPathActionExecute
      OnUpdate = SameAsScriptPathActionUpdate
      UserData = 0
    end
    object AutoSynCheckAction: THKAction
      Category = 'Run'
      Caption = 'Automatic Syntax Checking'
      Hint = 'Enables or disables automatic syntax checking'
      OnExecute = AutoSynCheckActionExecute
      OnUpdate = AutoSynCheckActionUpdate
      UserData = 0
    end
    object AutoSynCheckStrippedAction: THKAction
      Category = 'Run'
      Caption = 'Syntax Checking Only in Script'
      Hint = 
        'If enabled, will syntax check script without used modules, BEGIN' +
        ' && CHECK blocks'
      OnExecute = AutoSynCheckStrippedActionExecute
      OnUpdate = AutoSynCheckStrippedActionUpdate
      UserData = 0
    end
    object TestErrorAction: THKAction
      Category = 'Run'
      Caption = '&Syntax Check'
      HelpContext = 630
      Hint = 'Test script for syntax errors'
      ImageIndex = 128
      ShortCut = 116
      OnExecute = TestErrorActionExecute
      OnUpdate = TestErrorActionUpdate
      UserData = 0
    end
    object TestErrorExpAction: THKAction
      Category = 'Run'
      Caption = 'E&xpanded Syntax Check'
      HelpContext = 630
      Hint = 'Evaluate required modules and test script for syntax errors'
      ImageIndex = 128
      ShortCut = 16500
      OnExecute = TestErrorExpActionExecute
      OnUpdate = TestErrorActionUpdate
      UserData = 0
    end
    object SearchDocsAction: THKAction
      Category = 'Help'
      Caption = '&Search Documentation'
      Hint = 'Search for word in perl documentation'
      OnExecute = SearchDocsActionExecute
      UserData = 0
    end
    object Tog0BookmarkAction: THKAction
      Tag = 10
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &0'
      Hint = 'Toggles bookmark 0'
      ShortCut = 24624
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog1BookmarkAction: THKAction
      Tag = 1
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &1'
      Hint = 'Toggles bookmark 1'
      ShortCut = 24625
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog2BookmarkAction: THKAction
      Tag = 2
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &2'
      Hint = 'Toggles bookmark 2'
      ShortCut = 24626
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog3BookmarkAction: THKAction
      Tag = 3
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &3'
      Hint = 'Toggles bookmark 3'
      ShortCut = 24627
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog4BookmarkAction: THKAction
      Tag = 4
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &4'
      Hint = 'Toggles bookmark 4'
      ShortCut = 24628
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog5BookmarkAction: THKAction
      Tag = 5
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &5'
      Hint = 'Toggles bookmark 5'
      ShortCut = 24629
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog6BookmarkAction: THKAction
      Tag = 6
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &6'
      Hint = 'Toggles bookmark 6'
      ShortCut = 24630
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog7BookmarkAction: THKAction
      Tag = 7
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &7'
      Hint = 'Toggles bookmark 7'
      ShortCut = 24631
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog8BookmarkAction: THKAction
      Tag = 8
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &8'
      Hint = 'Toggles bookmark 8'
      ShortCut = 24632
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Tog9BookmarkAction: THKAction
      Tag = 9
      Category = 'Bookmarks'
      Caption = 'Toggle Bookmark &9'
      Hint = 'Toggles bookmark 9'
      ShortCut = 24633
      OnExecute = TogBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto0BookmarkAction: THKAction
      Tag = 10
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &0'
      Hint = 'Goes to bookmark 0'
      ShortCut = 16432
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto1BookmarkAction: THKAction
      Tag = 1
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &1'
      Hint = 'Goes to bookmark 1'
      ShortCut = 16433
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto2BookmarkAction: THKAction
      Tag = 2
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &2'
      Hint = 'Goes to bookmark 2'
      ShortCut = 16434
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto3BookmarkAction: THKAction
      Tag = 3
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &3'
      Hint = 'Goes to bookmark 3'
      ShortCut = 16435
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto4BookmarkAction: THKAction
      Tag = 4
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &4'
      Hint = 'Goes to bookmark 4'
      ShortCut = 16436
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto5BookmarkAction: THKAction
      Tag = 5
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &5'
      Hint = 'Goes to bookmark 5'
      ShortCut = 16437
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto6BookmarkAction: THKAction
      Tag = 6
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &6'
      Hint = 'Goes to bookmark 6'
      ShortCut = 16438
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto7BookmarkAction: THKAction
      Tag = 7
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &7'
      Hint = 'Goes to bookmark 7'
      ShortCut = 16439
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto8BookmarkAction: THKAction
      Tag = 8
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &8'
      Hint = 'Goes to bookmark 8'
      ShortCut = 16440
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto9BookmarkAction: THKAction
      Tag = 9
      Category = 'Bookmarks'
      Caption = 'Go to Bookmark &9'
      Hint = 'Goes to bookmark 9'
      ShortCut = 16441
      OnExecute = GotoBookmarkActionExecute
      OnUpdate = BookmarkActionUpdate
      UserData = 0
    end
    object Goto0GlobalAction: THKAction
      Tag = 10
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &0'
      Hint = 'Goes to global bookmark 0'
      ShortCut = 49200
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object Goto1GlobalAction: THKAction
      Tag = 1
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &1'
      Hint = 'Goes to global bookmark 1'
      ShortCut = 49201
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object Goto2GlobalAction: THKAction
      Tag = 2
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &2'
      Hint = 'Goes to global bookmark 2'
      ShortCut = 49202
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object Goto3GlobalAction: THKAction
      Tag = 3
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &3'
      Hint = 'Goes to global bookmark 3'
      ShortCut = 49203
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object Goto4GlobalAction: THKAction
      Tag = 4
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &4'
      Hint = 'Goes to global bookmark 4'
      ShortCut = 49204
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object Goto5GlobalAction: THKAction
      Tag = 5
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &5'
      Hint = 'Goes to global bookmark 5'
      ShortCut = 49205
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object MatchBracketSelectAction: THKAction
      Category = 'Search'
      Caption = 'Find && Select Matching Bracket'
      Hint = 'Match bracket and select contents in between'
      ImageIndex = 6
      ShortCut = 24796
      OnExecute = MatchBracketSelectActionExecute
      OnUpdate = EnIFMainMemoEnabled
      UserData = 0
    end
    object SaveLayoutAction: THKAction
      Category = 'Window'
      Caption = 'Save &Layout'
      Hint = 'Save current layout'
      ImageIndex = 21
      OnExecute = SaveLayoutActionExecute
      UserData = 0
    end
    object DeleteLayoutAction: THKAction
      Category = 'Window'
      Caption = '&Delete Layout'
      Hint = 'Delete selected layout'
      ImageIndex = 55
      OnExecute = DeleteLayoutActionExecute
      UserData = 0
    end
    object LoadEditLayoutAction: THKAction
      Category = 'Window'
      Caption = 'Load &Edit Layout'
      Hint = 'Loads the "Edit" layout'
      OnExecute = LoadEditLayoutActionExecute
      UserData = 0
    end
    object DelWordLeft: THKAction
      Category = 'Editing'
      Caption = 'Delete Word &Left'
      Hint = 'Delete word left of cursor'
      OnExecute = DelWordLeftExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DelWordRight: THKAction
      Category = 'Editing'
      Caption = 'Delete Word &Right'
      Hint = 'Delete word right of cursor'
      OnExecute = DelWordRightExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object ToggleIMEAction: THKAction
      Category = 'Edit'
      Caption = 'Toggle &IME'
      Hint = 'Toggle input system (IME)'
      ImageIndex = 71
      OnExecute = ToggleIMEActionExecute
      UserData = 0
    end
    object TextStyle1: THKAction
      Category = 'Edit'
      Caption = 'TextStyle1'
      Hint = 'Select first text style'
      OnExecute = TextStyleExecute
      OnUpdate = TextStyleUpdate
      UserData = 0
    end
    object TextStyle2: THKAction
      Tag = 1
      Category = 'Edit'
      Caption = 'TextStyle2'
      Hint = 'Select second text style'
      OnExecute = TextStyleExecute
      OnUpdate = TextStyleUpdate
      UserData = 0
    end
    object TextStyle3: THKAction
      Tag = 2
      Category = 'Edit'
      Caption = 'TextStyle3'
      Hint = 'Select third text style'
      OnExecute = TextStyleExecute
      OnUpdate = TextStyleUpdate
      UserData = 0
    end
    object TextStyle4: THKAction
      Tag = 3
      Category = 'Edit'
      Caption = 'TextStyle4'
      Hint = 'Select fourth text style'
      OnExecute = TextStyleExecute
      OnUpdate = TextStyleUpdate
      UserData = 0
    end
    object TextStyle5: THKAction
      Tag = 4
      Category = 'Edit'
      Caption = 'TextStyle5'
      Hint = 'Select fifth text style'
      OnExecute = TextStyleExecute
      OnUpdate = TextStyleUpdate
      UserData = 0
    end
    object OpenRemoteAction: THKAction
      Category = 'File'
      Caption = 'Open R&emote File...'
      Hint = 'Open remote file'
      ImageIndex = 53
      OnExecute = OpenRemoteActionExecute
      UserData = 0
    end
    object ReloadRemoteAction: THKAction
      Category = 'File'
      Caption = 'Reload &Remote File'
      Hint = 'Reload remote file'
      ImageIndex = 59
      OnExecute = ReloadRemoteActionExecute
      OnUpdate = IsRemoteActionUpdate
      UserData = 0
    end
    object OpenCacheAction: THKAction
      Category = 'File'
      Caption = 'Open &Cached Remote File...'
      Hint = 
        'Open a file that has been saved in the cache from a past remote ' +
        'session'
      OnExecute = OpenCacheActionExecute
      UserData = 0
    end
    object SaveRemoteAction: THKAction
      Category = 'File'
      Caption = 'S&ave Remote File'
      Hint = 'Save remote file'
      ImageIndex = 54
      OnExecute = SaveRemoteActionExecute
      OnUpdate = IsRemoteActionUpdate
      UserData = 0
    end
    object SaveRemoteActionAs: THKAction
      Category = 'File'
      Caption = 'Save to &Location...'
      Hint = 'Save remote file in another FTP session'
      OnExecute = SaveRemoteActionAsExecute
      UserData = 0
    end
    object SaveAllRemoteAction: THKAction
      Category = 'File'
      Caption = 'Save All Remo&te Files'
      Hint = 'Upload all remote files'
      ImageIndex = 138
      Visible = False
      OnExecute = SaveAllRemoteActionExecute
      UserData = 0
    end
    object PrintAction: THKAction
      Category = 'File'
      Caption = '&Print...'
      Hint = 'Print document'
      ImageIndex = 104
      OnExecute = PrintActionExecute
      UserData = 0
    end
    object ExitAction: THKAction
      Category = 'File'
      Caption = 'E&xit'
      HelpContext = 70
      Hint = 'Exits OptiPerl'
      ImageIndex = 1
      OnExecute = ExitActionExecute
      UserData = 0
    end
    object WinCascadeAction: THKAction
      Category = 'Window'
      Caption = 'Cascade Windows'
      Hint = 'Cascades windows'
      ImageIndex = 136
      OnExecute = WinArrangeActionExecute
      UserData = 0
    end
    object WinTileAction: THKAction
      Tag = 1
      Category = 'Window'
      Caption = 'Tile Windows'
      Hint = 'Tile windows'
      ImageIndex = 137
      OnExecute = WinArrangeActionExecute
      UserData = 0
    end
    object NextWindowAction: THKAction
      Category = 'Window'
      Caption = 'Next Window'
      Hint = 'Select next window'
      ImageIndex = 144
      ShortCut = 32803
      OnExecute = NextWindowActionExecute
      UserData = 0
    end
    object DelWholeLineAction: THKAction
      Category = 'Editing'
      Caption = 'Delete Whole Line'
      Hint = 'Delete whole line under cursor'
      OnExecute = DelWholeLineActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DeleteLineBreakAction: THKAction
      Category = 'Editing'
      Caption = 'Delete Line Break'
      Hint = 'Delete line break (VI style)'
      OnExecute = DeleteLineBreakActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object InsertNewLineAction: THKAction
      Category = 'Editing'
      Caption = 'Insert New Line'
      Hint = 'Insert new line under cursor (VI style)'
      OnExecute = InsertNewLineActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DuplicateLineActon: THKAction
      Category = 'Editing'
      Caption = 'Duplicate Line'
      Hint = 'Duplicate line'
      OnExecute = DuplicateLineActonExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object SelectLineAction: THKAction
      Category = 'Editing'
      Caption = 'Select Line'
      Hint = 'Select line under cursor'
      OnExecute = SelectLineActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DeleteToEOLAction: THKAction
      Category = 'Editing'
      Caption = 'Delete to EOL'
      Hint = 'Delete from cursor position to end of line'
      OnExecute = DeleteToEOLActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DeleteToStartAction: THKAction
      Category = 'Editing'
      Caption = 'Delete to Beginning'
      Hint = 'Delete from cursor position to beginning of line'
      OnExecute = DeleteToStartActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object DeleteWordAction: THKAction
      Category = 'Editing'
      Caption = 'Delete word'
      Hint = 'Delete word under cursor'
      OnExecute = DeleteWordActionExecute
      OnUpdate = EnIFAnyMemoActive
      UserData = 0
    end
    object ToggleSelOptionAction: THKAction
      Category = 'Editing'
      Caption = 'Block Style Selection'
      Hint = 'Toggles between normal and block selection style'
      OnExecute = ToggleSelOptionActionExecute
      OnUpdate = ToggleSelOptionActionUpdate
      UserData = 0
    end
    object SwapVersionAction: THKAction
      Category = 'Search'
      Caption = 'Swap &Version'
      Hint = 'Swap version'
      ImageIndex = 134
      OnExecute = SwapVersionActionExecute
      OnUpdate = SwapVersionActionUpdate
      UserData = 0
    end
    object FindDeclarationAction: THKAction
      Category = 'Search'
      Caption = 'Find &Declaration'
      Hint = 'Find declaration of the statement'
      ImageIndex = 10
      OnExecute = FindDeclarationActionExecute
      OnUpdate = EnIFMainMemoEnabled
      UserData = 0
    end
    object HighDeclarationAction: THKAction
      Category = 'Search'
      Caption = 'Highlight Identifier'
      Hint = 'Highlight identifier'
      ImageIndex = 173
      OnExecute = HighDeclarationActionExecute
      UserData = 0
    end
    object Goto6GlobalAction: THKAction
      Tag = 6
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &6'
      Hint = 'Goes to global bookmark 6'
      ShortCut = 49206
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object Goto7GlobalAction: THKAction
      Tag = 7
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &7'
      Hint = 'Goes to global bookmark 7'
      ShortCut = 49207
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object Goto8GlobalAction: THKAction
      Tag = 8
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &8'
      Hint = 'Goes to global bookmark 8'
      ShortCut = 49208
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
    object Goto9GlobalAction: THKAction
      Tag = 9
      Category = 'Bookmarks'
      Caption = 'Go to Global Bookmark &9'
      Hint = 'Goes to global bookmark 9'
      ShortCut = 49209
      OnExecute = GotoGlobalActionExecute
      UserData = 0
    end
  end
  object ApplicationEvents: TApplicationEvents
    OnMessage = ApplicationEventsMessage
    Left = 40
    Top = 72
  end
  object ZIPOpenDialog: TOpenDialog
    DefaultExt = 'zip'
    Filter = 'ZIP File|*.zip'
    Options = [ofHideReadOnly, ofPathMustExist, ofCreatePrompt, ofEnableSizing]
    Title = 'Open Zip File'
    Left = 128
    Top = 72
  end
  object HelpRouter: THelpRouter
    HelpType = htHTMLhelp
    CHMPopupTopics = 'xpopup.txt'
    ValidateID = False
    Left = 200
    Top = 40
  end
end
