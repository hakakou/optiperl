object FTPSessionsForm: TFTPSessionsForm
  Left = 273
  Top = 157
  HelpContext = 200
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  BorderStyle = bsDialog
  Caption = 'Remote transfer sessions setup'
  ClientHeight = 464
  ClientWidth = 690
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object DBNavigator: TDBNavigator
    Left = 180
    Top = 433
    Width = 250
    Height = 25
    HelpContext = 3970
    DataSource = FTPMod.TransSource
    VisibleButtons = [nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
  end
  object btnClose: TButton
    Left = 534
    Top = 433
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    ModalResult = 2
    TabOrder = 3
    OnClick = btnCloseClick
  end
  object btnHelp: TButton
    Left = 613
    Top = 433
    Width = 70
    Height = 25
    Cancel = True
    Caption = '&Help'
    TabOrder = 4
    OnClick = btnHelpClick
  end
  object ScrollMax: TJvScrollMax
    Left = 177
    Top = 3
    Width = 510
    Height = 429
    ButtonFont.Charset = DEFAULT_CHARSET
    ButtonFont.Color = clWindowText
    ButtonFont.Height = -11
    ButtonFont.Name = 'MS Sans Serif'
    ButtonFont.Style = [fsBold]
    AutoHeight = False
    ScrollBarWidth = 10
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object BandServer: TJvScrollMaxBand
      Caption = 'Remote Server'
      ExpandedHeight = 138
      ButtonFont.Charset = DEFAULT_CHARSET
      ButtonFont.Color = clWindowText
      ButtonFont.Height = -11
      ButtonFont.Name = 'MS Sans Serif'
      ButtonFont.Style = []
      ParentButtonFont = False
      object Label1: TLabel
        Left = 16
        Top = 31
        Width = 69
        Height = 13
        Caption = '&Session name:'
        FocusControl = Session
      end
      object Label2: TLabel
        Left = 16
        Top = 58
        Width = 34
        Height = 13
        Caption = 'S&erver:'
        FocusControl = Server
      end
      object l2: TLabel
        Left = 304
        Top = 85
        Width = 22
        Height = 13
        Caption = '&Port:'
        FocusControl = Port
      end
      object Label4: TLabel
        Left = 16
        Top = 85
        Width = 51
        Height = 13
        Caption = '&Username:'
        FocusControl = Username
      end
      object Label5: TLabel
        Left = 16
        Top = 112
        Width = 49
        Height = 13
        Caption = 'Pass&word:'
        FocusControl = Password
      end
      object l1: TLabel
        Left = 304
        Top = 58
        Width = 43
        Height = 13
        Caption = 'Accoun&t:'
        FocusControl = Account
      end
      object Label17: TLabel
        Left = 304
        Top = 31
        Width = 27
        Height = 13
        Caption = 'Type:'
        FocusControl = Session
      end
      object Session: TDBEdit
        Left = 96
        Top = 27
        Width = 145
        Height = 21
        HelpContext = 3980
        DataField = 'Session'
        DataSource = FTPMod.TransSource
        TabOrder = 0
      end
      object Server: TDBEdit
        Left = 96
        Top = 54
        Width = 161
        Height = 21
        HelpContext = 3990
        DataField = 'Server'
        DataSource = FTPMod.TransSource
        TabOrder = 1
      end
      object Port: TDBEdit
        Left = 368
        Top = 81
        Width = 41
        Height = 21
        HelpContext = 4000
        DataField = 'Port'
        DataSource = FTPMod.TransSource
        TabOrder = 6
      end
      object Username: TDBEdit
        Left = 96
        Top = 81
        Width = 113
        Height = 21
        HelpContext = 4010
        DataField = 'Username'
        DataSource = FTPMod.TransSource
        TabOrder = 2
      end
      object Password: TDBEdit
        Left = 96
        Top = 108
        Width = 105
        Height = 21
        HelpContext = 4020
        DataField = 'Password'
        DataSource = FTPMod.TransSource
        PasswordChar = '*'
        TabOrder = 3
      end
      object Passive: TDBCheckBox
        Left = 304
        Top = 110
        Width = 113
        Height = 17
        HelpContext = 4040
        Caption = 'Pass&ive transfers'
        DataField = 'Passive'
        DataSource = FTPMod.TransSource
        TabOrder = 7
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object Account: TDBEdit
        Left = 368
        Top = 54
        Width = 106
        Height = 21
        HelpContext = 4060
        DataField = 'Account'
        DataSource = FTPMod.TransSource
        TabOrder = 5
      end
      object TType: TDBComboBox
        Left = 368
        Top = 27
        Width = 97
        Height = 21
        HelpContext = 8040
        Style = csDropDownList
        DataField = 'Type'
        DataSource = FTPMod.TransSource
        ItemHeight = 13
        Items.Strings = (
          'FTP'
          'Secure FTP')
        TabOrder = 4
        OnChange = TTypeChange
      end
    end
    object BandFirewall: TJvScrollMaxBand
      Expanded = False
      Caption = 'Firewall settings'
      ExpandedHeight = 110
      ButtonFont.Charset = DEFAULT_CHARSET
      ButtonFont.Color = clWindowText
      ButtonFont.Height = -11
      ButtonFont.Name = 'MS Sans Serif'
      ButtonFont.Style = []
      ParentButtonFont = False
      object l3: TLabel
        Left = 16
        Top = 31
        Width = 34
        Height = 13
        Caption = 'Se&rver:'
        FocusControl = ProxyServer
      end
      object l5: TLabel
        Left = 304
        Top = 31
        Width = 22
        Height = 13
        Caption = 'Port:'
        FocusControl = ProxyPort
      end
      object l4: TLabel
        Left = 16
        Top = 57
        Width = 51
        Height = 13
        Caption = 'Userna&me:'
        FocusControl = ProxyUser
      end
      object l6: TLabel
        Left = 304
        Top = 57
        Width = 49
        Height = 13
        Caption = 'Password:'
        FocusControl = ProxyPass
      end
      object l7: TLabel
        Left = 16
        Top = 83
        Width = 27
        Height = 13
        Caption = 'Type:'
      end
      object ProxyServer: TDBEdit
        Left = 96
        Top = 27
        Width = 177
        Height = 21
        HelpContext = 4070
        DataField = 'ProxyServer'
        DataSource = FTPMod.TransSource
        TabOrder = 0
      end
      object ProxyPort: TDBEdit
        Left = 368
        Top = 27
        Width = 41
        Height = 21
        HelpContext = 4080
        DataField = 'ProxyPort'
        DataSource = FTPMod.TransSource
        TabOrder = 3
      end
      object ProxyUser: TDBEdit
        Left = 96
        Top = 53
        Width = 113
        Height = 21
        HelpContext = 4090
        DataField = 'ProxyUsername'
        DataSource = FTPMod.TransSource
        TabOrder = 1
      end
      object ProxyPass: TDBEdit
        Left = 368
        Top = 53
        Width = 105
        Height = 21
        HelpContext = 4100
        DataField = 'ProxyPassword'
        DataSource = FTPMod.TransSource
        PasswordChar = '*'
        TabOrder = 4
      end
      object ProxyType: TDBComboBox
        Left = 96
        Top = 79
        Width = 145
        Height = 21
        HelpContext = 4110
        Style = csDropDownList
        DataField = 'ProxyType'
        DataSource = FTPMod.TransSource
        ItemHeight = 13
        Items.Strings = (
          '(None)'
          'Open'
          'Site'
          'User'
          'UserPass'
          'Transparent')
        TabOrder = 2
      end
    end
    object BandRemote: TJvScrollMaxBand
      Caption = 'Remote running'
      ExpandedHeight = 109
      ButtonFont.Charset = DEFAULT_CHARSET
      ButtonFont.Color = clWindowText
      ButtonFont.Height = -11
      ButtonFont.Name = 'MS Sans Serif'
      ButtonFont.Style = []
      ParentButtonFont = False
      object Label6: TLabel
        Left = 16
        Top = 31
        Width = 73
        Height = 13
        Caption = '&Document root:'
        FocusControl = DocRoot
      end
      object Label14: TLabel
        Left = 16
        Top = 57
        Width = 65
        Height = 13
        Caption = '&Links to URL:'
        FocusControl = URLLink
      end
      object Label16: TLabel
        Left = 16
        Top = 83
        Width = 36
        Height = 13
        Caption = '&Aliases:'
        FocusControl = Aliases
      end
      object DocRoot: TDBEdit
        Left = 96
        Top = 27
        Width = 232
        Height = 21
        HelpContext = 4030
        DataField = 'DocRoot'
        DataSource = FTPMod.TransSource
        TabOrder = 0
      end
      object URLLink: TDBEdit
        Left = 96
        Top = 53
        Width = 232
        Height = 21
        HelpContext = 4050
        DataField = 'LinksTo'
        DataSource = FTPMod.TransSource
        TabOrder = 1
      end
      object Aliases: TDBEdit
        Left = 96
        Top = 79
        Width = 377
        Height = 21
        HelpContext = 7500
        DataField = 'Aliases'
        DataSource = FTPMod.TransSource
        TabOrder = 2
      end
    end
    object BandSettings: TJvScrollMaxBand
      Caption = 'Session settings'
      ExpandedHeight = 148
      ButtonFont.Charset = DEFAULT_CHARSET
      ButtonFont.Color = clWindowText
      ButtonFont.Height = -11
      ButtonFont.Name = 'MS Sans Serif'
      ButtonFont.Style = []
      ParentButtonFont = False
      object Label11: TLabel
        Left = 16
        Top = 31
        Width = 65
        Height = 13
        Caption = 'She&bang line:'
        FocusControl = Sheebang
      end
      object Label12: TLabel
        Left = 16
        Top = 90
        Width = 31
        Height = 13
        Caption = '&Notes:'
        FocusControl = Notes
      end
      object Notes: TDBMemo
        Left = 96
        Top = 75
        Width = 378
        Height = 43
        HelpContext = 4120
        DataField = 'Notes'
        DataSource = FTPMod.TransSource
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object Sheebang: TDBEdit
        Left = 96
        Top = 27
        Width = 225
        Height = 21
        HelpContext = 4130
        DataField = 'SheBang'
        DataSource = FTPMod.TransSource
        TabOrder = 0
      end
      object AutoVersion: TDBCheckBox
        Left = 96
        Top = 53
        Width = 185
        Height = 17
        HelpContext = 4140
        Caption = 'Automatically convert &version'
        DataField = 'VersionConvert'
        DataSource = FTPMod.TransSource
        TabOrder = 2
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object SavePass: TDBCheckBox
        Left = 96
        Top = 123
        Width = 185
        Height = 17
        HelpContext = 4150
        Caption = 'Save passwords'
        DataField = 'SavePassword'
        DataSource = FTPMod.TransSource
        TabOrder = 4
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
      object ChangeSheBang: TDBCheckBox
        Left = 335
        Top = 29
        Width = 145
        Height = 17
        HelpContext = 4160
        Caption = 'Chan&ge when uploading'
        DataField = 'ChangeShebang'
        DataSource = FTPMod.TransSource
        TabOrder = 1
        ValueChecked = 'True'
        ValueUnchecked = 'False'
      end
    end
  end
  object VST: TVirtualStringTree
    Left = 0
    Top = 0
    Width = 172
    Height = 464
    HelpContext = 3960
    Align = alLeft
    BevelInner = bvNone
    BorderStyle = bsNone
    ButtonFillMode = fmWindowColor
    ButtonStyle = bsTriangle
    CheckImageKind = ckXP
    Color = 15181444
    Colors.BorderColor = clBlack
    Colors.DisabledColor = clBlack
    Colors.DropMarkColor = clBlack
    Colors.DropTargetColor = clBlack
    Colors.DropTargetBorderColor = clBlack
    Colors.FocusedSelectionColor = 13526321
    Colors.FocusedSelectionBorderColor = 14782308
    Colors.GridLineColor = clBlack
    Colors.HotColor = clBlack
    Colors.SelectionRectangleBlendColor = clBlack
    Colors.SelectionRectangleBorderColor = clBlack
    Colors.TreeLineColor = clBtnFace
    Colors.UnfocusedSelectionColor = 13526321
    Colors.UnfocusedSelectionBorderColor = 14782308
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Shell Dlg 2'
    Font.Style = []
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDrag]
    HintAnimation = hatNone
    ParentFont = False
    PopupMenu = PopupMenu
    ScrollBarOptions.ScrollBars = ssVertical
    SelectionBlendFactor = 0
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes, toDisableAutoscrollOnFocus]
    TreeOptions.MiscOptions = [toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowBackground, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnFocusChanged = VSTFocusChanged
    OnGetText = VSTGetText
    OnGetNodeDataSize = VSTGetNodeDataSize
    Columns = <>
  end
  object FormStorage: TJvFormStorage
    Options = [fpPosition]
    StoredProps.Strings = (
      'BandFirewall.Expanded'
      'BandRemote.Expanded'
      'BandServer.Expanded'
      'BandSettings.Expanded')
    StoredValues = <>
    Left = 72
    Top = 152
  end
  object PopupMenu: TPopupMenu
    Left = 48
    Top = 264
    object Insertrecord1: TMenuItem
      Caption = 'Insert record'
      OnClick = Insertrecord1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Deleterecord1: TMenuItem
      Caption = 'Delete record'
      OnClick = Deleterecord1Click
    end
  end
  object fQuickTyper: TdxfQuickTyper
    WinControl = Owner
    QuickTyperControls = <
      item
        Control = Session
      end
      item
        Control = Server
      end
      item
        Control = Username
      end
      item
        Control = Password
      end
      item
        Control = Account
      end
      item
        Control = Port
      end
      item
        Control = Passive
      end
      item
        Control = ProxyServer
      end
      item
        Control = ProxyUser
      end
      item
        Control = ProxyPort
      end
      item
        Control = ProxyPass
      end
      item
        Control = DocRoot
      end
      item
        Control = URLLink
      end
      item
        Control = Aliases
      end
      item
        Control = Sheebang
      end
      item
        Control = ChangeSheBang
      end
      item
        Control = AutoVersion
      end
      item
        Control = Notes
      end
      item
        Control = SavePass
      end>
    MessageBeep = False
    Left = 100
    Top = 78
  end
end
