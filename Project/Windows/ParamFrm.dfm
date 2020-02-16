object ParamForm: TParamForm
  Left = 297
  Top = 215
  HelpContext = 810
  BorderStyle = bsDialog
  Caption = 'Parameter List'
  ClientHeight = 344
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    445
    344)
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 280
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 360
    Top = 312
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 7
    Width = 425
    Height = 238
    Caption = '&Parameters'
    TabOrder = 0
    object edParams: TComboBox
      Left = 13
      Top = 23
      Width = 400
      Height = 23
      Hint = 
        'Parameters for running script.'#13#10'Must include the path to the scr' +
        'ipt as the first parameter.'
      AutoComplete = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      ItemHeight = 15
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnChange = edParamsChange
    end
    object ListView: TListView
      Left = 13
      Top = 56
      Width = 399
      Height = 170
      Columns = <
        item
          Caption = 'Tag'
          Width = 100
        end
        item
          AutoSize = True
          Caption = 'Value'
        end>
      ColumnClick = False
      GridLines = True
      Items.Data = {
        680300001C00000000000000FFFFFFFFFFFFFFFF000000000000000006254152
        47562500000000FFFFFFFFFFFFFFFF00000000000000000825636F6F6B696525
        00000000FFFFFFFFFFFFFFFF00000000000000000A2564617461302E2E392500
        000000FFFFFFFFFFFFFFFF00000000000000000D25663C66696C656E616D653E
        2500000000FFFFFFFFFFFFFFFF0000000000000000062566696C652500000000
        FFFFFFFFFFFFFFFF00000000000000000B2566696C654E6F4578742500000000
        FFFFFFFFFFFFFFFF00000000000000000825666F6C6465722500000000FFFFFF
        FFFFFFFFFF000000000000000005256765742500000000FFFFFFFFFFFFFFFF00
        00000000000000092547455446494C452500000000FFFFFFFFFFFFFFFF000000
        000000000009254745544C494E452500000000FFFFFFFFFFFFFFFF0000000000
        0000000C2547455450524F4A4543542500000000FFFFFFFFFFFFFFFF00000000
        000000000E2547455453454C454354494F4E2500000000FFFFFFFFFFFFFFFF00
        000000000000000D256E3C66696C656E616D653E2500000000FFFFFFFFFFFFFF
        FF00000000000000000D256F3C66696C656E616D653E2500000000FFFFFFFFFF
        FFFFFF00000000000000000625706174682500000000FFFFFFFFFFFFFFFF0000
        0000000000000A2570617468696E666F2500000000FFFFFFFFFFFFFFFF000000
        0000000000082570617468534E2500000000FFFFFFFFFFFFFFFF000000000000
        00000625706F73742500000000FFFFFFFFFFFFFFFF00000000000000000A2571
        75657279626F782500000000FFFFFFFFFFFFFFFF00000000000000000B257365
        6C656374696F6E2500000000FFFFFFFFFFFFFFFF00000000000000000A255345
        4E4446494C452500000000FFFFFFFFFFFFFFFF00000000000000000A2553454E
        444C494E452500000000FFFFFFFFFFFFFFFF00000000000000000D2553454E44
        50524F4A4543542500000000FFFFFFFFFFFFFFFF00000000000000000F255345
        4E4453454C454354494F4E2500000000FFFFFFFFFFFFFFFF0000000000000000
        0D257365743C6F7074696F6E3E2500000000FFFFFFFFFFFFFFFF000000000000
        00001025746F67676C653C6F7074696F6E3E2500000000FFFFFFFFFFFFFFFF00
        00000000000000052575726C2500000000FFFFFFFFFFFFFFFF00000000000000
        000625776F726425}
      ReadOnly = True
      SortType = stText
      TabOrder = 1
      ViewStyle = vsReport
      OnDblClick = ListViewDblClick
    end
  end
  object btnDefault: TButton
    Left = 199
    Top = 312
    Width = 75
    Height = 25
    Hint = 'Set default parameter for running'
    Anchors = [akLeft, akBottom]
    Cancel = True
    Caption = '&Default'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Visible = False
    OnClick = btnDefaultClick
  end
  object StartBox: TGroupBox
    Left = 10
    Top = 250
    Width = 425
    Height = 54
    Anchors = [akLeft, akBottom]
    Caption = '&Starting path'
    TabOrder = 1
    object edStartDir: TJvDirectoryEdit
      Left = 13
      Top = 19
      Width = 399
      Height = 21
      DialogKind = dkWin32
      DialogText = 'Select Folder:'
      ButtonFlat = True
      NumGlyphs = 1
      TabOrder = 0
    end
  end
  object cbLeaveOpen: TCheckBox
    Left = 8
    Top = 315
    Width = 177
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = '&Leave console window open'
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
  object FormStorage: TJvFormStorage
    Options = [fpPosition]
    StoredProps.Strings = (
      'edParams.Text'
      'edParams.Items'
      'cbLeaveOpen.Checked')
    StoredValues = <>
    Left = 336
    Top = 120
  end
end
