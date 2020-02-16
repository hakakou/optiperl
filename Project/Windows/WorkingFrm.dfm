object WorkingForm: TWorkingForm
  Left = 428
  Top = 333
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'User tool'
  ClientHeight = 67
  ClientWidth = 159
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 8
    Width = 60
    Height = 13
    Caption = 'Working...'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btnTerminate: TButton
    Left = 15
    Top = 32
    Width = 129
    Height = 25
    Caption = '&Terminate'
    TabOrder = 0
    OnClick = btnTerminateClick
  end
end
