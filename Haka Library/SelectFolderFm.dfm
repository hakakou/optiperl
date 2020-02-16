object SelectFolderFrame: TSelectFolderFrame
  Left = 0
  Top = 0
  Width = 392
  Height = 142
  AutoScroll = False
  TabOrder = 0
  DesignSize = (
    392
    142)
  object lblSelFile: TbsSkinStdLabel
    Left = 8
    Top = 8
    Width = 85
    Height = 13
    UseSkinFont = True
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -11
    DefaultFont.Name = 'MS Shell Dlg 2'
    DefaultFont.Style = []
    SkinDataName = 'stdlabel'
    Caption = 'Select a filename:'
  end
  object lblSelFolder: TbsSkinStdLabel
    Left = 8
    Top = 56
    Width = 112
    Height = 13
    UseSkinFont = True
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = -11
    DefaultFont.Name = 'MS Shell Dlg 2'
    DefaultFont.Style = []
    SkinDataName = 'stdlabel'
    Caption = 'Select a folder to save:'
  end
  object cbFolders: TbsSkinComboBox
    Left = 7
    Top = 72
    Width = 378
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    SkinDataName = 'combobox'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    UseSkinSize = True
    AlphaBlend = False
    AlphaBlendValue = 0
    AlphaBlendAnimation = False
    HideSelection = True
    AutoComplete = True
    ListBoxUseSkinFont = True
    ListBoxUseSkinItemHeight = True
    ListBoxWidth = 0
    ImageIndex = -1
    ListBoxCaptionMode = False
    ListBoxDefaultFont.Charset = DEFAULT_CHARSET
    ListBoxDefaultFont.Color = clWindowText
    ListBoxDefaultFont.Height = 14
    ListBoxDefaultFont.Name = 'Arial'
    ListBoxDefaultFont.Style = []
    ListBoxDefaultCaptionFont.Charset = DEFAULT_CHARSET
    ListBoxDefaultCaptionFont.Color = clWindowText
    ListBoxDefaultCaptionFont.Height = 14
    ListBoxDefaultCaptionFont.Name = 'Arial'
    ListBoxDefaultCaptionFont.Style = []
    ListBoxDefaultItemHeight = 20
    ListBoxCaptionAlignment = taLeftJustify
    ShowHint = True
    ItemIndex = -1
    DropDownCount = 8
    HorizontalExtent = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    Sorted = False
    Style = bscbFixedStyle
    OnListBoxDrawItem = cbFoldersListBoxDrawItem
    OnComboBoxDrawItem = cbFoldersListBoxDrawItem
  end
  object btnBrowse: TbsSkinButton
    Left = 309
    Top = 104
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 2
    SkinDataName = 'button'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultWidth = 0
    DefaultHeight = 0
    UseSkinFont = True
    UseSkinSize = True
    RepeatMode = False
    RepeatInterval = 100
    AllowAllUp = False
    TabStop = True
    CanFocused = True
    Down = False
    GroupIndex = 0
    Caption = 'Browse'
    NumGlyphs = 1
    Spacing = 1
    OnClick = btnBrowseClick
  end
  object edFilename: TbsSkinEdit
    Left = 8
    Top = 24
    Width = 209
    Height = 18
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clBlack
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    UseSkinFont = True
    DefaultWidth = 0
    DefaultHeight = 0
    ButtonMode = False
    SkinDataName = 'edit'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = 14
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object SkinSelectDirectoryDialog: TbsSkinSelectDirectoryDialog
    DialogWidth = 0
    DialogHeight = 0
    DialogMinWidth = 0
    DialogMinHeight = 0
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    Title = 'Select folder'
    ShowToolBar = True
    Left = 296
    Top = 16
  end
end
