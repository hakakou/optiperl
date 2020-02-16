object EditTodoItemForm: TEditTodoItemForm
  Left = 318
  Top = 165
  HelpContext = 360
  BorderStyle = bsDialog
  Caption = 'Edit To-Do Item'
  ClientHeight = 247
  ClientWidth = 275
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
    Top = 10
    Width = 33
    Height = 13
    Caption = '&Action:'
    FocusControl = edAction
  end
  object Label2: TLabel
    Left = 8
    Top = 37
    Width = 34
    Height = 13
    Caption = '&Priority:'
    FocusControl = edPriority
  end
  object Label3: TLabel
    Left = 8
    Top = 63
    Width = 34
    Height = 13
    Caption = '&Owner:'
    FocusControl = edOwner
  end
  object Label4: TLabel
    Left = 8
    Top = 89
    Width = 45
    Height = 13
    Caption = 'Ca&tegory:'
    FocusControl = edCat
  end
  object Label5: TLabel
    Left = 8
    Top = 115
    Width = 31
    Height = 13
    Caption = '&Notes:'
    FocusControl = memNotes
  end
  object btnOK: TButton
    Left = 109
    Top = 216
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 6
  end
  object btnCancel: TButton
    Left = 192
    Top = 216
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object cbDone: TCheckBox
    Left = 8
    Top = 221
    Width = 73
    Height = 17
    Caption = '&Done'
    TabOrder = 5
  end
  object edCat: TComboBox
    Left = 64
    Top = 87
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 3
    Text = 'edCat'
  end
  object edOwner: TComboBox
    Left = 64
    Top = 60
    Width = 145
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    Text = 'edOwner'
  end
  object edPriority: TJvSpinEdit
    Left = 64
    Top = 33
    Width = 57
    Height = 21
    Decimal = 0
    MaxValue = 10.000000000000000000
    MaxLength = 2
    TabOrder = 1
  end
  object edAction: TEdit
    Left = 64
    Top = 6
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edAction'
  end
  object memNotes: TMemo
    Left = 64
    Top = 114
    Width = 204
    Height = 87
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object FormPlacement: TJvFormPlacement
    Left = 216
    Top = 16
  end
end
