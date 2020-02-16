object frmDockingSetup: TfrmDockingSetup
  Left = 326
  Top = 263
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Docking Setup'
  ClientHeight = 277
  ClientWidth = 368
  Color = clBtnFace
  Constraints.MinHeight = 306
  Constraints.MinWidth = 376
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object pgcDockSetup: TPageControl
    Tag = 2
    Left = 6
    Top = 6
    Width = 356
    Height = 234
    ActivePage = tsPanels
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    OnChange = pgcDockSetupChange
    object tsPanels: TTabSheet
      Caption = 'Panels'
      object pnlSiteWarn: TPanel
        Left = 0
        Top = 169
        Width = 348
        Height = 37
        Align = alBottom
        BevelOuter = bvNone
        Color = clInfoBk
        TabOrder = 0
        DesignSize = (
          348
          37)
        object Label2: TLabel
          Left = 24
          Top = 0
          Width = 324
          Height = 37
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoSize = False
          Caption = 
            'Link a aqDockingSite component to this aqDockingManager to add c' +
            'omponents or frames to the panels.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object Image2: TImage
          Left = 4
          Top = 10
          Width = 16
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            000010000000010004000000000080000000130B0000130B0000100000001000
            00001B0000003249590079373700C5A2A20000A9D20000CDE60000CEF10048C9
            DC0000D6FF0000E7FF0008DEFF00FF00FF0005ECFF0002F9FF000EF9FF0075F9
            FF00B33333333333333B744444444444412B466668146666682B568889029888
            853BF5A88900988E82BBB5A88A998A9A83BBBF5E8945A8EA2BBBBB5A99146CC9
            3BBBBBF5ED01AEA2BBBBBBB5ED00EED3BBBBBBBF6D00EC2BBBBBBBBB5E00DD3B
            BBBBBBBBF9EEC2BBBBBBBBBBB5EED3BBBBBBBBBBBFDD1BBBBBBBBBBBBBEFBBBB
            BBBB}
          Transparent = True
        end
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 348
        Height = 169
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          348
          169)
        object lblPanels: TLabel
          Left = 8
          Top = 8
          Width = 35
          Height = 13
          Caption = '&Panels:'
          FocusControl = lvPanels
        end
        object Bevel1: TBevel
          Left = 240
          Top = 120
          Width = 97
          Height = 2
          Anchors = [akTop, akRight]
          Visible = False
        end
        object lvPanels: TListView
          Left = 5
          Top = 24
          Width = 223
          Height = 145
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              AutoSize = True
              Caption = 'Caption'
            end>
          ColumnClick = False
          HideSelection = False
          RowSelect = True
          ShowColumnHeaders = False
          TabOrder = 0
          ViewStyle = vsReport
          OnChanging = lvPanelsChanging
          OnEdited = lvPanelsEdited
          OnEditing = lvPanelsEditing
          OnSelectItem = lvPanelsSelectItem
        end
        object btnNew: TButton
          Left = 236
          Top = 21
          Width = 104
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '&New...'
          TabOrder = 1
          OnClick = btnNewClick
        end
        object btnRename: TButton
          Left = 237
          Top = 53
          Width = 104
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '&Rename...'
          TabOrder = 2
          OnClick = btnRenameClick
        end
        object btnDelete: TButton
          Left = 237
          Top = 85
          Width = 104
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '&Delete'
          TabOrder = 3
          OnClick = btnDeleteClick
        end
        object btnShow: TButton
          Left = 237
          Top = 133
          Width = 104
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '&Show'
          TabOrder = 4
          Visible = False
          OnClick = btnShowClick
        end
      end
    end
    object tsStyles: TTabSheet
      Tag = 1
      Caption = 'Interface'
      ImageIndex = 1
      object pnlStyleWarn: TPanel
        Left = 0
        Top = 177
        Width = 348
        Height = 29
        Align = alBottom
        BevelOuter = bvNone
        Color = clInfoBk
        TabOrder = 0
        DesignSize = (
          348
          29)
        object Label1: TLabel
          Left = 24
          Top = 0
          Width = 324
          Height = 29
          Anchors = [akLeft, akTop, akRight, akBottom]
          AutoSize = False
          Caption = 'Assign the StyleManager property to enable styles management.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInfoText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object Image1: TImage
          Left = 4
          Top = 7
          Width = 16
          Height = 16
          AutoSize = True
          Picture.Data = {
            07544269746D6170F6000000424DF60000000000000076000000280000001000
            000010000000010004000000000080000000130B0000130B0000100000001000
            00001B0000003249590079373700C5A2A20000A9D20000CDE60000CEF10048C9
            DC0000D6FF0000E7FF0008DEFF00FF00FF0005ECFF0002F9FF000EF9FF0075F9
            FF00B33333333333333B744444444444412B466668146666682B568889029888
            853BF5A88900988E82BBB5A88A998A9A83BBBF5E8945A8EA2BBBBB5A99146CC9
            3BBBBBF5ED01AEA2BBBBBBB5ED00EED3BBBBBBBF6D00EC2BBBBBBBBB5E00DD3B
            BBBBBBBBF9EEC2BBBBBBBBBBB5EED3BBBBBBBBBBBFDD1BBBBBBBBBBBBBEFBBBB
            BBBB}
          Transparent = True
        end
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 348
        Height = 177
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          348
          177)
        object lblStyles: TLabel
          Left = 8
          Top = 8
          Width = 62
          Height = 13
          Caption = 'Visual &Styles:'
          FocusControl = lvStyles
        end
        object lvStyles: TListView
          Left = 5
          Top = 26
          Width = 223
          Height = 144
          Anchors = [akLeft, akTop, akRight, akBottom]
          Columns = <
            item
              AutoSize = True
              Caption = 'Name'
            end>
          ColumnClick = False
          HideSelection = False
          ReadOnly = True
          RowSelect = True
          ShowColumnHeaders = False
          TabOrder = 0
          ViewStyle = vsReport
          OnChanging = lvStylesChanging
          OnSelectItem = lvStylesSelectItem
        end
        object btnApply: TButton
          Left = 236
          Top = 21
          Width = 104
          Height = 22
          Anchors = [akTop, akRight]
          Caption = '&Apply'
          TabOrder = 1
          OnClick = btnApplyClick
        end
      end
    end
    object tsSettings: TTabSheet
      Caption = 'Settings'
      ImageIndex = 2
      object chkAutoDrag: TCheckBox
        Left = 8
        Top = 8
        Width = 169
        Height = 17
        Caption = '&Auto drag docking'
        TabOrder = 0
        OnClick = chkAutoDragClick
      end
      object GroupBox2: TGroupBox
        Left = 8
        Top = 106
        Width = 329
        Height = 95
        Caption = ' Title buttons '
        TabOrder = 3
        object chkHide: TCheckBox
          Left = 8
          Top = 16
          Width = 97
          Height = 17
          Caption = 'Hi&de'
          TabOrder = 0
          OnClick = chkButtonClick
        end
        object chkUndock: TCheckBox
          Left = 176
          Top = 12
          Width = 97
          Height = 17
          Caption = '&Undock'
          TabOrder = 1
          OnClick = chkButtonClick
        end
        object chkMax: TCheckBox
          Left = 8
          Top = 40
          Width = 105
          Height = 17
          Caption = '&Maximize/Restore'
          TabOrder = 2
          OnClick = chkButtonClick
        end
        object chkHelp: TCheckBox
          Left = 176
          Top = 36
          Width = 97
          Height = 17
          Caption = 'H&elp'
          TabOrder = 3
          OnClick = chkButtonClick
        end
        object chkShowHint: TCheckBox
          Left = 8
          Top = 72
          Width = 89
          Height = 17
          Caption = 'Show &hint'
          TabOrder = 4
          OnClick = chkShowHintClick
        end
        object chkAutoHideButtons: TCheckBox
          Left = 176
          Top = 72
          Width = 145
          Height = 17
          Caption = 'Hide di&sabled buttons'
          TabOrder = 5
          OnClick = chkAutoHideButtonsClick
        end
      end
      object chkFloatOnTop: TCheckBox
        Left = 184
        Top = 8
        Width = 161
        Height = 17
        Caption = '&Floating forms always on top'
        TabOrder = 1
        OnClick = chkFloatOnTopClick
      end
      object GroupBox1: TGroupBox
        Left = 8
        Top = 32
        Width = 329
        Height = 65
        Caption = ' Show container captions '
        TabOrder = 2
        object chkShowInside: TCheckBox
          Left = 8
          Top = 40
          Width = 137
          Height = 17
          Caption = '&Inside container'
          TabOrder = 2
          OnClick = chkShowInsideClick
        end
        object chkShowVert: TCheckBox
          Left = 8
          Top = 16
          Width = 137
          Height = 17
          Caption = '&Vertical container'
          TabOrder = 0
          OnClick = chkShowVertClick
        end
        object chkShowHor: TCheckBox
          Left = 176
          Top = 16
          Width = 137
          Height = 17
          Caption = 'Hori&zontal container'
          TabOrder = 1
          OnClick = chkShowHorClick
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 240
    Width = 368
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    DesignSize = (
      368
      37)
    object btnClose: TButton
      Left = 288
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Close'
      Default = True
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object Panel3: TPanel
    Left = 362
    Top = 6
    Width = 6
    Height = 234
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel2: TPanel
    Left = 0
    Top = 6
    Width = 6
    Height = 234
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 368
    Height = 6
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
  end
end
