object PromptReplaceForm: TPromptReplaceForm
  Left = 283
  Top = 309
  BorderStyle = bsDialog
  Caption = 'Replace'
  ClientHeight = 53
  ClientWidth = 231
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 5
    Width = 119
    Height = 13
    Caption = 'Replace this occurance?'
  end
  object Button1: TButton
    Left = 5
    Top = 25
    Width = 53
    Height = 25
    Caption = 'Yes'
    Default = True
    ModalResult = 6
    TabOrder = 0
    TabStop = False
  end
  object Button2: TButton
    Left = 61
    Top = 25
    Width = 53
    Height = 25
    Caption = '&No'
    ModalResult = 7
    TabOrder = 1
    TabStop = False
  end
  object Button3: TButton
    Left = 117
    Top = 25
    Width = 53
    Height = 25
    Caption = '&All'
    ModalResult = 10
    TabOrder = 2
    TabStop = False
  end
  object Button4: TButton
    Left = 173
    Top = 25
    Width = 53
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 3
    TabStop = False
  end
end
