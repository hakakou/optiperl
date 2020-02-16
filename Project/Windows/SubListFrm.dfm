object SubListForm: TSubListForm
  Left = 445
  Top = 266
  Width = 264
  Height = 269
  HelpContext = 7180
  Caption = 'Subroutine list'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object VST: TVirtualStringTree
    Left = 0
    Top = 24
    Width = 256
    Height = 214
    Align = alClient
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
    Header.Style = hsXPStyle
    HintAnimation = hatNone
    TabOrder = 1
    TabStop = False
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toGridExtensions, toWheelPanning]
    TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    TreeOptions.StringOptions = []
    OnDblClick = VSTDblClick
    OnFreeNode = VSTFreeNode
    OnGetText = VSTGetText
    Columns = <
      item
        Position = 0
        Width = 182
        WideText = 'Name'
      end
      item
        Alignment = taCenter
        Position = 1
        Width = 70
        WideText = 'Line'
      end>
  end
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 256
    Height = 24
    AutoSize = True
    EdgeBorders = [ebBottom]
    Flat = True
    Images = CentralImageListMod.ImageList
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    object btnCopy: TToolButton
      Left = 0
      Top = 0
      Hint = 'Copy subroutine name to clipboard and exit (Ctrl-Enter)'
      Caption = 'btnCopy'
      ImageIndex = 78
      OnClick = btnCopyClick
    end
    object ToolButton1: TToolButton
      Left = 23
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 82
      Style = tbsSeparator
    end
    object btnGo: TToolButton
      Left = 31
      Top = 0
      Hint = 'Go to implementation (Enter)'
      Caption = 'btnGo'
      ImageIndex = 114
      OnClick = btnGoClick
    end
    object ToolButton3: TToolButton
      Left = 54
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 115
      Style = tbsSeparator
    end
    object edSearch: TEdit
      Left = 62
      Top = 0
      Width = 163
      Height = 22
      TabOrder = 0
      OnChange = edSearchChange
      OnKeyDown = edSearchKeyDown
      OnKeyPress = FormKeyPress
    end
  end
  object FormPlacement: TJvFormPlacement
    Left = 56
    Top = 112
  end
end
