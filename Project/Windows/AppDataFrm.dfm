object AppDataForm: TAppDataForm
  Left = 353
  Top = 243
  BorderStyle = bsDialog
  Caption = 'Application Data Folder'
  ClientHeight = 105
  ClientWidth = 382
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
  object Label2: TLabel
    Left = 11
    Top = 7
    Width = 184
    Height = 26
    Caption = 
      '&Select the new application data folder. '#13#10'All your settings wil' +
      'l be copied here:'
    FocusControl = edFolder
  end
  object btnSelect: TSpeedButton
    Left = 328
    Top = 37
    Width = 47
    Height = 21
    Caption = 'Select'
    Flat = True
    OnClick = btnSelectClick
  end
  object Button1: TButton
    Left = 116
    Top = 72
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 196
    Top = 72
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object edFolder: TEdit
    Left = 8
    Top = 37
    Width = 320
    Height = 21
    TabOrder = 2
  end
  object FolderDialog: TPBFolderDialog
    Flags = [OnlyFileSystem, ShowPath, ShowShared]
    LabelCaptions = 'Current folder:'
    NewFolderCaptions = 'New folder'
    Title = 'Select folder'
    Left = 320
    Top = 61
  end
end
