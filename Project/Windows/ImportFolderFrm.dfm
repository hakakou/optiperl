object ImportFolderForm: TImportFolderForm
  Left = 278
  Top = 445
  BorderStyle = bsDialog
  Caption = 'Import Folder'
  ClientHeight = 168
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnOK: TButton
    Left = 164
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 244
    Top = 136
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
    Height = 121
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 80
      Height = 13
      Caption = 'Folder to import:'
    end
    object Label3: TLabel
      Left = 16
      Top = 66
      Width = 45
      Height = 13
      Caption = 'Wildcard:'
      FocusControl = edWild
    end
    object edWild: TEdit
      Left = 16
      Top = 81
      Width = 280
      Height = 21
      TabOrder = 1
      Text = '*.pl;*.pm;*.cgi'
    end
    object edDirectory: TJvDirectoryEdit
      Left = 16
      Top = 31
      Width = 280
      Height = 21
      DialogKind = dkWin32
      DialogText = 'Select Folder:'
      ButtonFlat = True
      NumGlyphs = 1
      TabOrder = 0
    end
  end
end
