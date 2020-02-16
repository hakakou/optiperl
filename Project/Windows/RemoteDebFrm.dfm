object RemoteDebForm: TRemoteDebForm
  Left = 343
  Top = 394
  HelpContext = 510
  BorderStyle = bsDialog
  Caption = 'Remote Debugger'
  ClientHeight = 125
  ClientWidth = 266
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBox: TJvTextListBox
    Left = 0
    Top = 26
    Width = 266
    Height = 99
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
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
        FloatLeft = 337
        FloatTop = 380
        FloatClientWidth = 95
        FloatClientHeight = 22
        IsMainMenu = True
        ItemLinks = <
          item
            Item = lblStat
            Visible = True
          end
          item
            BeginGroup = True
            Item = dcInfo
            Visible = True
          end
          item
            Item = dxPush
            Visible = True
          end
          item
            Item = dxReload
            Visible = True
          end>
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
    UseSystemFont = False
    Left = 160
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
    object dxPush: TdxBarButton
      Caption = 'Push'
      Category = 0
      Hint = 'Push'
      Visible = ivAlways
      ImageIndex = 51
      OnClick = dxPushClick
    end
    object dcInfo: TdxBarButton
      Caption = 'Set-up && Information'
      Category = 0
      Hint = 'Set-up & Information'
      Visible = ivAlways
      ImageIndex = 31
      OnClick = btnInfoClick
    end
    object lblStat: TdxBarStatic
      Caption = 'Waiting for Remote Debugger'
      Category = 0
      Hint = 'Waiting for Remote Debugger'
      Visible = ivAlways
    end
    object dxReload: TdxBarButton
      Caption = 'Reload Source Code'
      Category = 0
      Hint = 'Reload Source Code'
      Visible = ivAlways
      ImageIndex = 52
      OnClick = dxReloadClick
    end
  end
end
