object ConfToolForm: TConfToolForm
  Left = 280
  Top = 205
  Width = 580
  Height = 277
  HelpContext = 340
  BorderIcons = [biSystemMenu]
  Caption = 'Configure Tools'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object VST: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 572
    Height = 226
    Align = alClient
    ClipboardFormats.Strings = (
      'Virtual Tree Data')
    DragMode = dmAutomatic
    EditDelay = 750
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoColumnResize, hoHotTrack, hoShowSortGlyphs, hoVisible]
    Header.SortDirection = sdDescending
    Header.Style = hsXPStyle
    HintMode = hmHint
    Images = CentralImageListMod.ImageList
    IncrementalSearch = isAll
    IncrementalSearchStart = ssAlwaysStartOver
    ParentFont = False
    ParentShowHint = False
    PopupMenu = PopupMenu
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toAcceptOLEDrop, toEditable, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowTreeLines, toShowVertGridLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
    TreeOptions.StringOptions = []
    OnColumnClick = VSTColumnClick
    OnCompareNodes = VSTCompareNodes
    OnDragOver = VSTDragOver
    OnDragDrop = VSTDragDrop
    OnEditing = VSTEditing
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    OnGetImageIndex = VSTGetImageIndex
    OnGetHint = VSTGetHint
    OnGetNodeDataSize = VSTGetNodeDataSize
    OnHeaderClick = VSTHeaderClick
    OnNewText = VSTNewText
    Columns = <
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        Width = 166
        WideText = 'Caption'
      end
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 1
        Width = 100
        WideText = 'Program'
      end
      item
        Options = [coAllowClick, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 2
        Width = 300
        WideText = 'Parameters'
      end>
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'exe'
    Filter = 
      'Perl Scripts (*.pl)|*.pl|Executables (*.exe;*.bat;*.com)|*.exe;*' +
      '.bat;*.com|All Files (*.*)|*.*'
    Options = [ofHideReadOnly, ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select a file to execute'
    Left = 148
    Top = 158
  end
  object ToolsActionList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 64
    Top = 80
    object AddItemAction: TAction
      Caption = '&New'
      Hint = 'Adds a new tool'
      ImageIndex = 23
      OnExecute = AddItemActionExecute
    end
    object DeleteAction: TAction
      Caption = '&Delete'
      Hint = 'Deletes selected tool'
      ImageIndex = 22
      OnExecute = DeleteActionExecute
      OnUpdate = EnabledIfFocusedActionUpdate
    end
    object SelectAppAction: TAction
      Caption = '&Select Program...'
      Hint = 'Opens a file dialog'
      ImageIndex = 0
      OnExecute = SelectAppActionExecute
      OnUpdate = EnabledIfFocusedActionUpdate
    end
    object CloseAction: TAction
      Caption = '&Close'
      Hint = 'Close dialog and save changes'
      ImageIndex = 44
      OnExecute = CloseActionExecute
    end
    object EditCaptionAction: TAction
      Caption = '&Edit Caption'
      ImageIndex = 129
      OnExecute = EditCaptionActionExecute
      OnUpdate = EnabledIfFocusedActionUpdate
    end
    object EditParamAction: TAction
      Caption = 'Ed&it Parameters'
      OnExecute = EditParamActionExecute
      OnUpdate = EnabledIfFocusedActionUpdate
    end
    object BuildParamAction: TAction
      Caption = '&Build Parameters...'
      ImageIndex = 50
      OnExecute = BuildParamActionExecute
      OnUpdate = EnabledIfFocusedActionUpdate
    end
    object EditProgramAction: TAction
      Caption = 'Edi&t Program'
      OnExecute = EditProgramActionExecute
      OnUpdate = EnabledIfFocusedActionUpdate
    end
    object SelectImageAction: TAction
      Caption = 'Se&lect Image...'
      ImageIndex = 51
      OnExecute = SelectImageActionExecute
      OnUpdate = EnabledIfFocusedActionUpdate
    end
    object RunAction: TAction
      Caption = 'Test Run'
      ImageIndex = 98
      OnExecute = RunActionExecute
      OnUpdate = EnabledIfFocusedActionUpdate
    end
    object CopyAction: TAction
      Caption = 'Copy User Tool'
      OnExecute = CopyActionExecute
      OnUpdate = CopyActionUpdate
    end
  end
  object CVS: THKCSVParser
    QuoteChar = '"'
    Delimiter = ','
    OnSetData = CVSSetData
    OnReadNewLine = CVSReadNewLine
    Left = 352
    Top = 120
  end
  object PopupMenu: TPopupMenu
    Images = CentralImageListMod.ImageList
    Left = 48
    Top = 144
    object EditCaption1: TMenuItem
      Action = EditCaptionAction
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object EditParameters1: TMenuItem
      Action = SelectAppAction
    end
    object Editprogram1: TMenuItem
      Action = EditProgramAction
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object BuildParameters1: TMenuItem
      Action = BuildParamAction
    end
    object Delete1: TMenuItem
      Action = EditParamAction
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object SelectImage1: TMenuItem
      Action = SelectImageAction
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object estrun2: TMenuItem
      Action = RunAction
    end
  end
  object ToolsList: TActionList
    Images = CentralImageListMod.ImageList
    Left = 216
    Top = 64
  end
  object Pcre: TDIPcre
    MatchPattern = '%(get|send)(file|selection|project|line)%'
    Left = 288
    Top = 144
  end
  object LinePcre: TDIPcre
    MatchPattern = '(\d+)\t([^\t]*)'
    Left = 216
    Top = 120
  end
  object MainMenu: TMainMenu
    Images = CentralImageListMod.ImageList
    Left = 144
    Top = 104
    object Items1: TMenuItem
      Caption = '&User tools'
      object Add1: TMenuItem
        Action = AddItemAction
      end
      object Delete2: TMenuItem
        Action = DeleteAction
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object CopyUserTool1: TMenuItem
        Action = CopyAction
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object estrun1: TMenuItem
        Action = RunAction
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Action = CloseAction
      end
    end
    object oolSettings1: TMenuItem
      Caption = '&Tool settings'
      object Editcaption2: TMenuItem
        Action = EditCaptionAction
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Find1: TMenuItem
        Action = SelectAppAction
      end
      object Selectprogram1: TMenuItem
        Action = EditProgramAction
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Selectprogram2: TMenuItem
        Action = BuildParamAction
      end
      object EditParameters2: TMenuItem
        Action = EditParamAction
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object SelectImageAction1: TMenuItem
        Action = SelectImageAction
      end
    end
  end
  object FormPlacement: TJvFormPlacement
    Left = 136
    Top = 48
  end
end
