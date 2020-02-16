object FileCompareForm: TFileCompareForm
  Left = 260
  Top = 297
  HelpContext = 800
  AutoScroll = False
  Caption = 'File Compare'
  ClientHeight = 179
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object rmDiffMap: TrmDiffMap
    Left = 313
    Top = 21
    Width = 22
    Height = 158
    Caption = 'rmDiffMap'
    Align = alRight
    ColorDeleted = clRed
    ColorInserted = clLime
    ColorModified = clYellow
    ShowIndicator = False
  end
  object DiffViewer: TrmDiffViewer
    Left = 0
    Top = 21
    Width = 313
    Height = 158
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    DiffEngine = DiffEngine
    ChangedTextColor = clBlack
    DeletedTextColor = clBlack
    InsertedTextColor = clBlack
    DiffMap = rmDiffMap
    SimpleDiffViewer = False
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 335
    Height = 21
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 102
    EdgeBorders = []
    Flat = True
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 2
    Transparent = True
    object btnFile1: TToolButton
      Left = 0
      Top = 0
      Caption = 'Select &First File'
      ImageIndex = 1
      OnClick = btnFile1Click
    end
    object btnFile2: TToolButton
      Left = 102
      Top = 0
      Caption = 'Select &Second File'
      ImageIndex = 0
      OnClick = btnFile2Click
    end
    object ToolButton1: TToolButton
      Left = 204
      Top = 0
      Width = 17
      Caption = 'ToolButton1'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object btnCompare: TToolButton
      Left = 221
      Top = 0
      Hint = 'Compare selected files'
      Caption = '&Compare'
      Enabled = False
      OnClick = btnCompareClick
    end
  end
  object DiffEngine: TrmDiffEngine
    DiffOptions = [fdoCaseSensitive]
    Left = 88
    Top = 72
  end
  object FormStorage: TJvFormStorage
    Options = []
    StoredProps.Strings = (
      'OpenDialog.InitialDir')
    StoredValues = <>
    Left = 160
    Top = 80
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*'
    Filter = 
      'All Files (*.*)|*.*|Text Files (*.txt)|*.txt|Perl Files (*.pl;*.' +
      'pm;*.cgi;*.plx)|*.pl;*.pm;*.cgi;*.plx'
    Options = [ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Select file to compare'
    Left = 264
    Top = 80
  end
end
