object frmStyleEditor: TfrmStyleEditor
  Left = 380
  Top = 368
  Width = 428
  Height = 215
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  ActiveControl = lvStyles
  BorderIcons = [biSystemMenu]
  Caption = 'aqStyleManager Editor'
  Color = clBtnFace
  Constraints.MinHeight = 150
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object ControlBar1: TControlBar
    Left = 0
    Top = 0
    Width = 420
    Height = 26
    Align = alTop
    AutoSize = True
    BevelEdges = []
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object tlbStyles: TToolBar
      Left = 11
      Top = 2
      Width = 94
      Height = 22
      AutoSize = True
      Caption = 'Styles'
      EdgeBorders = []
      Flat = True
      Images = ilStyles
      TabOrder = 0
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Action = actStyleNew
        DropdownMenu = pmPredefinedStyles
        Style = tbsDropDown
      end
      object ToolButton2: TToolButton
        Left = 36
        Top = 0
        Action = actStyleDelete
      end
      object ToolButton4: TToolButton
        Left = 59
        Top = 0
        Width = 8
        Caption = 'ToolButton4'
        ImageIndex = 0
        Style = tbsSeparator
      end
      object ToolButton3: TToolButton
        Left = 67
        Top = 0
        Action = actStyleRename
      end
    end
  end
  object lvStyles: TListView
    Left = 0
    Top = 26
    Width = 420
    Height = 158
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 200
      end
      item
        AutoSize = True
        Caption = 'Based on'
      end>
    HideSelection = False
    RowSelect = True
    PopupMenu = pmStyles
    TabOrder = 1
    ViewStyle = vsReport
    OnChanging = lvStylesChanging
    OnEdited = lvStylesEdited
    OnEditing = lvStylesEditing
    OnSelectItem = lvStylesSelectItem
  end
  object alStyles: TActionList
    Images = ilStyles
    Left = 320
    Top = 80
    object actStyleNew: TAction
      Category = 'Style'
      Caption = '&Clone Current'
      Hint = 'Create new style based on current'
      ImageIndex = 0
      OnExecute = actStyleNewExecute
    end
    object actStyleReset: TAction
      Category = 'Style'
      Caption = '&Reset'
      Hint = 'Reset style list'
      OnExecute = actStyleResetExecute
    end
    object actStyleDelete: TAction
      Category = 'Style'
      Caption = '&Delete'
      Hint = 'Delete style'
      ImageIndex = 1
      OnExecute = actStyleDeleteExecute
      OnUpdate = actStyleDeleteUpdate
    end
    object actStyleRename: TAction
      Category = 'Style'
      Caption = 'Re&name'
      Hint = 'Rename style'
      ImageIndex = 2
      OnExecute = actStyleRenameExecute
      OnUpdate = actStyleRenameUpdate
    end
  end
  object ilStyles: TImageList
    Left = 272
    Top = 80
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000080808000808080008080800080808000808080008080
      8000000000008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      00007F7F7F3F7F7F7F007F7F7F0000FFFF0000FFFF3F7F7F7F007F7F7F3F7F7F
      7F007F7F7F0000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C0008080800000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF000000003F7F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF000000003F7F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000C0C0C0000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF000000003F7F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000008080000080800000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF000000003F7F7F7F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000008080000080800000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000FFFF0000FFFF000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008080000080800000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00FFFFFFBFFFFF
      FF000000000000FFFF0000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000008080000080800000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000008080000080800000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00000000BFFFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000008080000080800000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF00000000BFFFFFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000080
      80000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFFBFFFFFFF00FFFFFFBFFFFFFF0000000000000000000000000000FF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF0000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000080000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF0000FFFF000000
      000000000000000000000000000000FFFF0000FFFF0000000000000000000000
      00000000000000FFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FF7EFFFFE40800009001FFFFFFF00000
      C003EFFDFFE00000E003C7FFFFC10000E003C3FBFF830000E003E3F7FF070000
      E003F1E7FE0F00000001F8CFFC1F00008000FC1FF83F0000E007FE3FF07F0000
      E00FFC1FE0FF0000E00FF8CFC1FF0000E027E1E783FF0000C073C3F307FF0000
      9E79C7FD0FFF00007EFEFFFF9FFF000000000000000000000000000000000000
      000000000000}
  end
  object pmStyles: TPopupMenu
    Images = ilStyles
    OnPopup = pmStylesPopup
    Left = 56
    Top = 72
    object miNew: TMenuItem
      Caption = '&New Based On'
      ImageIndex = 0
    end
    object Rename1: TMenuItem
      Action = actStyleRename
    end
    object Delete1: TMenuItem
      Action = actStyleDelete
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Reset1: TMenuItem
      Action = actStyleReset
    end
  end
  object pmPredefinedStyles: TPopupMenu
    OnPopup = pmPredefinedStylesPopup
    Left = 56
    Top = 120
  end
end
