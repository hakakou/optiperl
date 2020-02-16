object SendMailAddForm: TSendMailAddForm
  Left = 482
  Top = 455
  BorderStyle = bsDialog
  Caption = 'Extrernal programs support'
  ClientHeight = 233
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 84
    Top = 201
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 164
    Top = 201
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object GroupBox1: TGroupBox
    Left = 7
    Top = 8
    Width = 312
    Height = 186
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 15
      Width = 108
      Height = 26
      Caption = 'Enter path to &sendmail:'#13#10'e.g. /bin/sendmail'
      FocusControl = edMail
    end
    object Label2: TLabel
      Left = 16
      Top = 136
      Width = 118
      Height = 13
      Caption = 'Select &drive to copy files:'
      FocusControl = edDrive
    end
    object Label3: TLabel
      Left = 16
      Top = 76
      Width = 88
      Height = 26
      Caption = 'Enter &path to date:'#13#10'e.g. /bin/date'
      FocusControl = edDate
    end
    object edMail: TEdit
      Left = 16
      Top = 44
      Width = 280
      Height = 21
      TabOrder = 0
    end
    object edDrive: TComboBox
      Left = 16
      Top = 153
      Width = 65
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 2
    end
    object edDate: TEdit
      Left = 16
      Top = 105
      Width = 280
      Height = 21
      TabOrder = 1
    end
  end
  object btnHelp: TButton
    Left = 244
    Top = 201
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
    OnClick = btnHelpClick
  end
end
