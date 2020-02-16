object FTPSelectForm: TFTPSelectForm
  Left = 259
  Top = 115
  Width = 631
  Height = 452
  Caption = 'FTP'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 72
    Top = 16
    Width = 32
    Height = 13
    Caption = 'Label1'
  end
  object ListView: TListView
    Left = 24
    Top = 48
    Width = 377
    Height = 137
    Columns = <
      item
        Caption = 'Name'
        Width = 120
      end
      item
        Caption = 'Size'
        Width = 60
      end
      item
        Caption = 'Date'
        Width = 100
      end
      item
        Caption = 'Permissions'
        Width = 80
      end>
    PopupMenu = PopupMenu
    TabOrder = 0
    ViewStyle = vsReport
  end
  object BT: TBTDragDropFTP
    Left = 24
    Top = 224
    Width = 553
    Height = 177
    BorderWidth = 3
    Caption = 'BT'
    TabOrder = 1
    Active = True
    HostName = 'localhost'
    LoginName = 'anonymous'
    Passive = True
    Port = 21
  end
  object Button1: TButton
    Left = 488
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 406
    Width = 623
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
    SimplePanel = False
  end
  object Button2: TButton
    Left = 520
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 4
    OnClick = Button2Click
  end
  object FTP: TNMFTP
    Host = 'ftp.ntua.gr'
    Port = 21
    ReportLevel = 3
    OnDisconnect = FTPDisconnect
    OnConnect = FTPConnect
    OnStatus = FTPStatus
    UserID = 'anonymous'
    Password = 'kcme@tsasg.com'
    OnListItem = FTPListItem
    Vendor = 2411
    ParseList = False
    ProxyPort = 0
    Passive = False
    FirewallType = FTUser
    FWAuthenticate = False
    Left = 168
    Top = 8
  end
  object PopupMenu: TPopupMenu
    Left = 432
    Top = 144
    object ItemDelete: TMenuItem
      Caption = 'Delete'
      OnClick = ItemDeleteClick
    end
    object ItemRename: TMenuItem
      Caption = 'Rename'
      OnClick = ItemRenameClick
    end
    object ItemNewFolder: TMenuItem
      Caption = 'New Folder'
      OnClick = ItemNewFolderClick
    end
    object ItemChangePermissions: TMenuItem
      Caption = 'Change Permissions'
    end
    object ItemN1: TMenuItem
      Caption = '-'
    end
    object ItemRefresh: TMenuItem
      Caption = 'Refresh'
      OnClick = ItemRefreshClick
    end
  end
end
