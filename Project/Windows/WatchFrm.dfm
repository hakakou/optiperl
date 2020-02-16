object WatchForm: TWatchForm
  Left = 560
  Top = 417
  Width = 258
  Height = 252
  HelpContext = 440
  BorderStyle = bsSizeToolWin
  Caption = 'Watch list'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDefaultPosOnly
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object ErrorMemo: TMemo
    Left = 0
    Top = 0
    Width = 250
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    Color = 14540287
    Lines.Strings = (
      '1'
      '2')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    Visible = False
    WantReturns = False
  end
  object VST: TVirtualStringTree
    Left = 0
    Top = 35
    Width = 250
    Height = 186
    Align = alClient
    Header.AutoSizeIndex = 1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Shell Dlg 2'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.Style = hsXPStyle
    HintAnimation = hatNone
    HintMode = hmHint
    ParentShowHint = False
    PopupMenu = PopupMenu
    ShowHint = True
    TabOrder = 0
    TreeOptions.MiscOptions = [toEditable, toGridExtensions, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toExtendedFocus, toFullRowSelect, toRightClickSelect]
    TreeOptions.StringOptions = []
    OnCollapsed = VSTCollapsed
    OnEdited = VSTEdited
    OnEditing = VSTEditing
    OnExpanded = VSTExpanded
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    OnPaintText = VSTPaintText
    OnGetHint = VSTGetHint
    OnGetNodeDataSize = VSTGetNodeDataSize
    OnNewText = VSTNewText
    Columns = <
      item
        Position = 0
        Width = 90
        WideText = 'Expression'
      end
      item
        Position = 1
        Width = 156
        WideText = 'Value'
      end>
  end
  object PopupMenu: TPopupMenu
    Images = CentralImageListMod.ImageList
    OnPopup = PopupMenuPopup
    Left = 72
    Top = 136
    object InsertItem: TMenuItem
      Caption = '&Insert new expression'
      ImageIndex = 23
      OnClick = InsertItemClick
    end
    object DeleteItem: TMenuItem
      Caption = '&Delete expression'
      ImageIndex = 22
      OnClick = DeleteItemClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object EditExpressionItem: TMenuItem
      Caption = 'Edit e&xpression'
      ImageIndex = 129
      OnClick = EditExpressionItemClick
    end
    object EditValueItem: TMenuItem
      Caption = 'Edit &value'
      ImageIndex = 129
      OnClick = EditValueItemClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object EvaluateagainItem: TMenuItem
      Caption = 'Evaluate &again'
      OnClick = EvaluateagainItemClick
    end
  end
  object Pcre: TDIPcre
    MatchPattern = '[\$\@\%][\w:]+(?:\[[^\]]+\]|\{[^\}]+\}){0,1}'
    Left = 160
    Top = 128
  end
end
