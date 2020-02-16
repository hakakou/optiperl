object CheckUpdateForm: TCheckUpdateForm
  Left = 335
  Top = 429
  HelpContext = 330
  BorderStyle = bsDialog
  Caption = 'Check for Update'
  ClientHeight = 174
  ClientWidth = 297
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblStatus: TLabel
    Left = 8
    Top = 151
    Width = 130
    Height = 13
    Caption = 'Checking for Update...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnClose: TButton
    Left = 216
    Top = 143
    Width = 75
    Height = 25
    Cancel = True
    Caption = '&Close'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object WebBrowser: TWebBrowser
    Left = 7
    Top = 7
    Width = 234
    Height = 103
    TabOrder = 1
    OnDocumentComplete = WebBrowserDocumentComplete
    ControlData = {
      4C0000002F180000A50A00000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126206000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
end
