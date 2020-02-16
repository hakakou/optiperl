inherited OPerformanceForm: TOPerformanceForm
  Left = 351
  Top = 201
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Performance options'
  ClientHeight = 281
  ClientWidth = 323
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 10
    Top = 7
    Width = 303
    Height = 235
    Caption = 'Performance Options'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 28
      Width = 108
      Height = 13
      Caption = '&Error check delay (ms):'
      FocusControl = CheckUpdateLag
    end
    object Label4: TLabel
      Left = 16
      Top = 96
      Width = 91
      Height = 13
      Caption = '&Max search results:'
      FocusControl = MaxSearchResults
    end
    object Label2: TLabel
      Left = 16
      Top = 62
      Width = 124
      Height = 13
      Caption = 'E&xplorer check delay (ms):'
      FocusControl = ExplorerUpdateLag
    end
    object Label3: TLabel
      Left = 16
      Top = 130
      Width = 75
      Height = 13
      Caption = 'M&ax undo level:'
      FocusControl = UndoLevel
    end
    object Label5: TLabel
      Left = 16
      Top = 164
      Width = 106
      Height = 13
      Caption = '&Line lookahead (lines):'
      FocusControl = LineLookAhead
    end
    object Label6: TLabel
      Left = 16
      Top = 199
      Width = 104
      Height = 13
      Caption = '&Box lookahead (lines):'
      FocusControl = BoxLookAhead
    end
    object CheckUpdateLag: TJvSpinEdit
      Left = 168
      Top = 24
      Width = 121
      Height = 21
      Increment = 10.000000000000000000
      MaxValue = 2000000000.000000000000000000
      MinValue = 25.000000000000000000
      Value = 25.000000000000000000
      TabOrder = 0
    end
    object ExplorerUpdateLag: TJvSpinEdit
      Left = 168
      Top = 58
      Width = 121
      Height = 21
      Increment = 10.000000000000000000
      MaxValue = 2000000000.000000000000000000
      MinValue = 25.000000000000000000
      Value = 25.000000000000000000
      TabOrder = 1
    end
    object MaxSearchResults: TJvSpinEdit
      Left = 168
      Top = 92
      Width = 121
      Height = 21
      Increment = 10.000000000000000000
      MaxValue = 2000000000.000000000000000000
      MinValue = 1.000000000000000000
      Value = 1.000000000000000000
      TabOrder = 2
    end
    object UndoLevel: TJvSpinEdit
      Left = 168
      Top = 126
      Width = 121
      Height = 21
      Increment = 10.000000000000000000
      MaxValue = 2000000000.000000000000000000
      TabOrder = 3
    end
    object LineLookAhead: TJvSpinEdit
      Left = 168
      Top = 160
      Width = 121
      Height = 21
      Increment = 10.000000000000000000
      MaxValue = 2000000000.000000000000000000
      TabOrder = 4
    end
    object BoxLookAhead: TJvSpinEdit
      Left = 168
      Top = 195
      Width = 121
      Height = 21
      Increment = 10.000000000000000000
      MaxValue = 2000000000.000000000000000000
      TabOrder = 5
    end
  end
  object btnClose: TButton
    Left = 81
    Top = 250
    Width = 75
    Height = 25
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object Button1: TButton
    Left = 161
    Top = 250
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 2
    OnClick = Button1Click
  end
end
