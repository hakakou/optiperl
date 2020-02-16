object PlugInForm: TPlugInForm
  Left = 373
  Top = 335
  Width = 386
  Height = 189
  HelpContext = 10
  Caption = 'Plug-In'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel: TPanel
    Left = 0
    Top = 26
    Width = 378
    Height = 132
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Plug-In'
    TabOrder = 4
    OnResize = PanelResize
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
    PopupMenuLinks = <>
    UseSystemFont = False
    Left = 56
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
    object siPopUpLinks: TdxBarSubItem
      Caption = 'PopUp'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
  end
end
