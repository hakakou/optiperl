object FormSelectForm: TFormSelectForm
  Left = 343
  Top = 197
  BorderStyle = bsDialog
  Caption = 'Select form'
  ClientHeight = 190
  ClientWidth = 353
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 319
    Height = 13
    Caption = 
      '&Multiple forms where found in the document. Select one to proce' +
      'ed:'
    FocusControl = Forms
  end
  object btnOK: TButton
    Left = 190
    Top = 160
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Forms: TListBox
    Left = 8
    Top = 24
    Width = 337
    Height = 129
    ItemHeight = 13
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 270
    Top = 160
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
