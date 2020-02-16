object RemDebInfoForm: TRemDebInfoForm
  Left = 337
  Top = 241
  BorderStyle = bsDialog
  Caption = 'Setting up remote debugging'
  ClientHeight = 367
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  DesignSize = (
    513
    367)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl: TPageControl
    Left = 7
    Top = 7
    Width = 499
    Height = 322
    ActivePage = RemSheet
    TabOrder = 0
    object LocalSheet: TTabSheet
      Caption = '&Debugging via Loopback'
      object GroupBox2: TGroupBox
        Left = 10
        Top = 6
        Width = 471
        Height = 144
        Caption = 'Status'
        TabOrder = 0
        DesignSize = (
          471
          144)
        object lblLocal: TLabel
          Left = 16
          Top = 17
          Width = 439
          Height = 123
          Anchors = [akLeft, akTop, akBottom]
          AutoSize = False
          Caption = 'lblLocal'
          WordWrap = True
        end
      end
      object GroupBox3: TGroupBox
        Left = 10
        Top = 157
        Width = 471
        Height = 127
        Caption = 'Registry && Environment'
        TabOrder = 1
        object Label1: TLabel
          Left = 16
          Top = 18
          Width = 361
          Height = 26
          Caption = 
            '&OptiPerl can enter or remove the value in the registry or envir' +
            'onment for you, '#13#10'(if you are not using the internal server) und' +
            'er PERLDB_OPTS:'
          FocusControl = edRegLocal
        end
        object Label4: TLabel
          Left = 16
          Top = 77
          Width = 41
          Height = 13
          Caption = 'Registry:'
        end
        object Label5: TLabel
          Left = 309
          Top = 77
          Width = 62
          Height = 13
          Caption = 'Environment:'
        end
        object edRegLocal: TEdit
          Left = 16
          Top = 51
          Width = 438
          Height = 21
          TabOrder = 0
        end
        object btnRegEnterLocal: TButton
          Left = 16
          Top = 93
          Width = 70
          Height = 25
          Caption = '&Enter'
          TabOrder = 1
          OnClick = btnRegEnterLocalClick
        end
        object btnRegRemoveLocal: TButton
          Left = 92
          Top = 93
          Width = 70
          Height = 25
          Caption = 'Remo&ve'
          TabOrder = 2
          OnClick = btnRegRemoveLocalClick
        end
        object btnEnvEnter: TButton
          Left = 309
          Top = 93
          Width = 70
          Height = 25
          Caption = 'En&ter'
          TabOrder = 3
          OnClick = btnEnvEnterClick
        end
        object btnEnvRemove: TButton
          Left = 385
          Top = 93
          Width = 70
          Height = 25
          Caption = 'Re&move'
          TabOrder = 4
          OnClick = btnEnvRemoveClick
        end
      end
    end
    object RemSheet: TTabSheet
      Caption = 'Debugging on a &Remote computer'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 10
        Top = 6
        Width = 471
        Height = 97
        Caption = 'Status'
        TabOrder = 0
        DesignSize = (
          471
          97)
        object lblRemote: TLabel
          Left = 16
          Top = 17
          Width = 440
          Height = 75
          Anchors = [akLeft, akTop, akBottom]
          AutoSize = False
          Caption = 'lblRemote'
          WordWrap = True
        end
      end
      object GroupBox4: TGroupBox
        Left = 10
        Top = 110
        Width = 471
        Height = 174
        Caption = 'Registry'
        TabOrder = 1
        object Label3: TLabel
          Left = 16
          Top = 20
          Width = 440
          Height = 48
          AutoSize = False
          Caption = 
            'OptiPerl can enter or remove the environment value in the remote' +
            ' machine'#39's registry, under PERLDB_OPTS if the remote machine has' +
            ' a Windows operating system and is connected via a network.'
          WordWrap = True
        end
        object Label2: TLabel
          Left = 16
          Top = 75
          Width = 112
          Height = 13
          Caption = 'Remote &machine name:'
          FocusControl = cbMachines
        end
        object btnRefresh: TSpeedButton
          Left = 389
          Top = 71
          Width = 65
          Height = 22
          Caption = 'Re&fresh'
          OnClick = btnRefreshClick
        end
        object edRegRemote: TEdit
          Left = 16
          Top = 106
          Width = 438
          Height = 21
          TabOrder = 1
        end
        object btnRegEnterRemote: TButton
          Left = 16
          Top = 140
          Width = 139
          Height = 25
          Caption = 'Enter &in registry'
          TabOrder = 2
          OnClick = btnRegEnterRemoteClick
        end
        object btnRegRemoveRemote: TButton
          Left = 164
          Top = 140
          Width = 140
          Height = 25
          Caption = 'Rem&ove from registry'
          TabOrder = 3
          OnClick = btnRegRemoveRemoteClick
        end
        object btnMakeReg: TButton
          Left = 313
          Top = 140
          Width = 140
          Height = 25
          Caption = '&Create a .reg file'
          TabOrder = 4
          OnClick = btnMakeRegClick
        end
        object cbMachines: TComboBox
          Left = 152
          Top = 71
          Width = 185
          Height = 21
          ItemHeight = 13
          TabOrder = 0
          OnDropDown = cbMachinesDropDown
        end
      end
    end
    object UploadSheet: TTabSheet
      Caption = '&Setting up using remote session'
      ImageIndex = 2
      object GroupBox5: TGroupBox
        Left = 10
        Top = 6
        Width = 471
        Height = 278
        Caption = 'Upload setup files for debugger'
        TabOrder = 0
        DesignSize = (
          471
          278)
        object Label6: TLabel
          Left = 16
          Top = 17
          Width = 440
          Height = 128
          Anchors = [akLeft, akTop, akBottom]
          AutoSize = False
          Caption = 
            'OptiPerl can set up the environment variable on a remote server ' +
            'by uploading the needed files. Select the remote session that ha' +
            's the script you want to debug and the path to the script on the' +
            ' remote server. If you have now open in the editor a remote scri' +
            'pt, then these will be filled automatically.'#13#10' '#13#10'If the IP of th' +
            'is computer is not static (like an internet connection with a dy' +
            'namic IP) you will need to upload each time your IP changes, so ' +
            'the remote debugger can find this computer when it starts.'
          WordWrap = True
        end
        object Label7: TLabel
          Left = 16
          Top = 140
          Width = 40
          Height = 13
          Caption = 'Sessi&on:'
          FocusControl = cbSessions
        end
        object Label8: TLabel
          Left = 16
          Top = 170
          Width = 25
          Height = 13
          Caption = '&Path:'
          FocusControl = edPath
        end
        object Label9: TLabel
          Left = 16
          Top = 200
          Width = 36
          Height = 13
          Caption = 'Se&tting:'
          FocusControl = edFTPSetting
        end
        object lblStatus: TLabel
          Left = 93
          Top = 224
          Width = 63
          Height = 13
          Caption = 'Connecting...'
          Visible = False
        end
        object btnUpdate: TSpeedButton
          Left = 389
          Top = 135
          Width = 65
          Height = 22
          Caption = 'Set&up'
          OnClick = btnUpdateClick
        end
        object cbSessions: TComboBox
          Left = 93
          Top = 136
          Width = 145
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
        end
        object edPath: TEdit
          Left = 93
          Top = 166
          Width = 360
          Height = 21
          TabOrder = 1
          Text = '/'
        end
        object btnUpload: TButton
          Left = 93
          Top = 244
          Width = 140
          Height = 25
          Caption = 'U&pload files'
          TabOrder = 3
          OnClick = btnUploadClick
        end
        object btnDelete: TButton
          Left = 245
          Top = 244
          Width = 140
          Height = 25
          Caption = 'De&lete files'
          TabOrder = 4
          OnClick = btnDeleteClick
        end
        object edFTPSetting: TEdit
          Left = 93
          Top = 196
          Width = 360
          Height = 21
          TabOrder = 2
          Text = '/'
        end
      end
    end
  end
  object btnClose: TButton
    Left = 431
    Top = 336
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = 'Close'
    Default = True
    ModalResult = 2
    TabOrder = 3
  end
  object Button2: TButton
    Left = 350
    Top = 336
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = '&Help'
    TabOrder = 2
    OnClick = Button2Click
  end
  object cbIP: TComboBox
    Left = 7
    Top = 338
    Width = 336
    Height = 21
    Style = csDropDownList
    DropDownCount = 15
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'reg'
    Filter = 'Registry files (*.reg)|*.reg'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Select registry file to save to'
    Left = 448
    Top = 248
  end
  object DIPcre: TDIPcre
    MatchPattern = 
      '\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[' +
      '0-4][0-9]|[01]?[0-9][0-9]?)\b'
    Left = 272
    Top = 160
  end
end
