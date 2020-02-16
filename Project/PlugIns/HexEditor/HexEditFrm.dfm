object HexEditForm: THexEditForm
  Left = 329
  Top = 292
  BorderStyle = bsNone
  Caption = 'Hex editor'
  ClientHeight = 287
  ClientWidth = 574
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010080000000000680500001600000028000000100000002000
    0000010008000000000000010000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C000C0DC
    C000F0CAA6000020400000206000002080000020A0000020C0000020E0000040
    0000004020000040400000406000004080000040A0000040C0000040E0000060
    0000006020000060400000606000006080000060A0000060C0000060E0000080
    0000008020000080400000806000008080000080A0000080C0000080E00000A0
    000000A0200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0
    000000C0200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0
    000000E0200000E0400000E0600000E0800000E0A00000E0C00000E0E0004000
    0000400020004000400040006000400080004000A0004000C0004000E0004020
    0000402020004020400040206000402080004020A0004020C0004020E0004040
    0000404020004040400040406000404080004040A0004040C0004040E0004060
    0000406020004060400040606000406080004060A0004060C0004060E0004080
    0000408020004080400040806000408080004080A0004080C0004080E00040A0
    000040A0200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0
    000040C0200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0
    000040E0200040E0400040E0600040E0800040E0A00040E0C00040E0E0008000
    0000800020008000400080006000800080008000A0008000C0008000E0008020
    0000802020008020400080206000802080008020A0008020C0008020E0008040
    0000804020008040400080406000804080008040A0008040C0008040E0008060
    0000806020008060400080606000806080008060A0008060C0008060E0008080
    0000808020008080400080806000808080008080A0008080C0008080E00080A0
    000080A0200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0
    000080C0200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0
    000080E0200080E0400080E0600080E0800080E0A00080E0C00080E0E000C000
    0000C0002000C0004000C0006000C0008000C000A000C000C000C000E000C020
    0000C0202000C0204000C0206000C0208000C020A000C020C000C020E000C040
    0000C0402000C0404000C0406000C0408000C040A000C040C000C040E000C060
    0000C0602000C0604000C0606000C0608000C060A000C060C000C060E000C080
    0000C0802000C0804000C0806000C0808000C080A000C080C000C080E000C0A0
    0000C0A02000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C0
    0000C0C02000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000000000000000000000000100000000000100000000000100000E
    0E010000000E0E010000000E0E01000000000000000000000000000000000000
    0000000000000000000000000000525249000000000000000000000000005B08
    F708F608F607F608070707ED00005B08B4F69898F608F698989850ED00009BF6
    F508F6F6F608F6F60807EEED00009BF6F7F6A1A1F608F698989850ED0000A4F6
    07F6F6F6F608F6F60807EEF700009BF6F5F6A1A1F608F698989850ED0000A4F6
    07F6F6F6F608F6F60807EEF700009B07F7F7F7F7F7F7ADADA4A49C9C00009B08
    076AE2A16AA1A1989898985000005B5B5252525252490000000000000000FFFF
    0000DF7D00008E380000FFFF0000FFFF00000001000000010000000100000001
    000000010000000100000001000000010000000100000001000000010000}
  Menu = MainMenu
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 267
    Width = 574
    Height = 20
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBtnText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Panels = <
      item
        Width = 120
      end
      item
        Width = 150
      end
      item
        Width = 30
      end
      item
        Width = 30
      end
      item
        Width = 38
      end
      item
        Width = 50
      end>
    SizeGrip = False
    UseSystemFont = False
  end
  object HexEditor: THexEditor
    Left = 0
    Top = 0
    Width = 574
    Height = 267
    Cursor = crIBeam
    BytesPerColumn = 2
    OnStateChanged = HexEditorStateChanged
    Translation = ttAnsi
    BackupExtension = '.bak'
    Align = alClient
    OffsetDisplay = odHex
    BytesPerLine = 16
    Colors.Background = clWindow
    Colors.PositionBackground = clMaroon
    Colors.PositionText = clRed
    Colors.ChangedBackground = clWindow
    Colors.ChangedText = clRed
    Colors.CursorFrame = clBlack
    Colors.Offset = clBlack
    Colors.OddColumn = clBlue
    Colors.EvenColumn = clNavy
    FocusFrame = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'courier new'
    Font.Pitch = fpFixed
    Font.Style = []
    OffsetSeparator = ':'
    AllowInsertMode = True
    TabOrder = 1
    OnKeyDown = HexEditorKeyDown
    ColWidths = (
      40
      10
      10
      10
      10
      20
      10
      10
      10
      20
      10
      10
      10
      20
      10
      10
      10
      20
      10
      10
      10
      20
      10
      10
      10
      20
      10
      10
      10
      20
      10
      10
      10
      20
      10
      10
      10
      10
      10
      10
      10
      10
      10
      10
      10
      10
      10
      10
      10
      10
      10)
  end
  object MainMenu: TMainMenu
    Left = 498
    Top = 68
    object Datei1: TMenuItem
      Caption = '&File'
      OnClick = Datei1Click
      object Neu1: TMenuItem
        Caption = '&New'
        OnClick = Neu1Click
      end
      object ffnen1: TMenuItem
        Caption = '&Open...'
        OnClick = ffnen1Click
      end
      object Speichern1: TMenuItem
        Caption = '&Save'
        OnClick = Speichern1Click
      end
      object Speichernunter1: TMenuItem
        Caption = 'Save &as'
        object AnyFile1: TMenuItem
          Caption = 'Any file...'
          OnClick = AnyFile1Click
        end
        object HexText1: TMenuItem
          Caption = 'Hex text...'
          OnClick = HexText1Click
        end
      end
      object ImportfromHexText1: TMenuItem
        Caption = 'Import from Hex Text...'
        OnClick = ImportfromHexText1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object Printlayout1: TMenuItem
        Caption = 'Print layout'
        OnClick = Printlayout1Click
        object Hex2: TMenuItem
          Caption = 'Hex'
          GroupIndex = 92
          RadioItem = True
          OnClick = Hex2Click
        end
        object Decimal1: TMenuItem
          Caption = 'Decimal'
          GroupIndex = 92
          RadioItem = True
          OnClick = Decimal1Click
        end
        object Octal2: TMenuItem
          Caption = 'Octal'
          GroupIndex = 92
          RadioItem = True
          OnClick = Octal2Click
        end
      end
      object Printpreview1: TMenuItem
        Caption = 'Print preview'
        OnClick = Printpreview1Click
      end
      object Printsetup1: TMenuItem
        Caption = 'Print setup'
        OnClick = Printsetup1Click
      end
      object Print1: TMenuItem
        Caption = 'Print'
        ShortCut = 16464
        OnClick = Print1Click
      end
    end
    object Bearbeiten1: TMenuItem
      Caption = '&Edit'
      OnClick = Bearbeiten1Click
      object Rckgngig1: TMenuItem
        Caption = 'Undo'
        ShortCut = 16474
        OnClick = Rckgngig1Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object Ausschneiden1: TMenuItem
        Caption = 'Cut'
        ShortCut = 16472
        OnClick = Ausschneiden1Click
      end
      object Kopieren1: TMenuItem
        Caption = 'Copy'
        ShortCut = 16451
        OnClick = Kopieren1Click
      end
      object Einfgen1: TMenuItem
        Caption = 'Paste'
        ShortCut = 16470
        OnClick = Einfgen1Click
      end
      object PasteText1: TMenuItem
        Caption = 'Paste text'
        ShortCut = 24662
        OnClick = PasteText1Click
      end
      object InsertNibble1: TMenuItem
        Caption = 'Insert nibble'
        ShortCut = 24649
        OnClick = InsertNibble1Click
      end
      object DeleteNibble1: TMenuItem
        Caption = 'Delete nibble'
        ShortCut = 24644
        OnClick = DeleteNibble1Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Goto1: TMenuItem
        Caption = 'Goto...'
        ShortCut = 16455
        OnClick = Goto1Click
      end
      object Jump1: TMenuItem
        Caption = 'Jump'
        OnClick = Jump1Click
        object Amount40001: TMenuItem
          Caption = 'Amount : 4000'
          OnClick = Amount40001Click
        end
        object N4: TMenuItem
          Caption = '-'
        end
        object Jumpforward1: TMenuItem
          Caption = 'Jump forward'
          ShortCut = 16458
          OnClick = Jumpforward1Click
        end
        object Jumpbackward1: TMenuItem
          Caption = 'Jump backward'
          ShortCut = 24650
          OnClick = Jumpbackward1Click
        end
      end
      object Find1: TMenuItem
        Caption = 'Find '
        ShortCut = 16454
        OnClick = Find1Click
      end
      object FindNext1: TMenuItem
        Caption = 'Find Next'
        ShortCut = 114
        OnClick = FindNext1Click
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object Convertfile1: TMenuItem
        Caption = 'Convert file'
        OnClick = Convertfile1Click
      end
    end
    object View1: TMenuItem
      Caption = '&View'
      OnClick = View1Click
      object Linesize1: TMenuItem
        Caption = 'Line size'
        object _16: TMenuItem
          Tag = 16
          Caption = '16 Bytes per line'
          Checked = True
          RadioItem = True
          OnClick = _64Click
        end
        object _32: TMenuItem
          Tag = 32
          Caption = '32 Bytes per line'
          RadioItem = True
          OnClick = _64Click
        end
        object _64: TMenuItem
          Tag = 64
          Caption = '64 Bytes per line'
          RadioItem = True
          OnClick = _64Click
        end
      end
      object Blocksize1: TMenuItem
        Caption = 'Column width'
        OnClick = Blocksize1Click
        object N1Byteperblock1: TMenuItem
          Tag = 1
          Caption = '1 Byte per column'
          GroupIndex = 7
          RadioItem = True
          OnClick = N4Bytesperblock1Click
        end
        object N2Bytesperblock1: TMenuItem
          Tag = 2
          Caption = '2 Bytes per column'
          GroupIndex = 7
          RadioItem = True
          OnClick = N4Bytesperblock1Click
        end
        object N4Bytesperblock1: TMenuItem
          Tag = 4
          Caption = '4 Bytes per column'
          GroupIndex = 7
          RadioItem = True
          OnClick = N4Bytesperblock1Click
        end
      end
      object Caretstyle1: TMenuItem
        Caption = 'Caret style'
        OnClick = Caretstyle1Click
        object Fullblock1: TMenuItem
          Caption = 'Full block'
          GroupIndex = 12
          RadioItem = True
          OnClick = Bottomline1Click
        end
        object Leftline1: TMenuItem
          Tag = 1
          Caption = 'Left line'
          GroupIndex = 12
          RadioItem = True
          OnClick = Bottomline1Click
        end
        object Bottomline1: TMenuItem
          Tag = 2
          Caption = 'Bottom line'
          GroupIndex = 12
          RadioItem = True
          OnClick = Bottomline1Click
        end
        object N9: TMenuItem
          Caption = '-'
          GroupIndex = 12
        end
        object Auto1: TMenuItem
          Caption = 'Auto'
          GroupIndex = 12
          OnClick = Auto1Click
        end
      end
      object Offsetdisplay1: TMenuItem
        Caption = 'Offset display'
        OnClick = Offsetdisplay1Click
        object Hex1: TMenuItem
          Caption = 'Hex'
          GroupIndex = 4
          RadioItem = True
          OnClick = None1Click
        end
        object Dec1: TMenuItem
          Tag = 1
          Caption = 'Dec'
          GroupIndex = 4
          RadioItem = True
          OnClick = None1Click
        end
        object Octal1: TMenuItem
          Tag = 2
          Caption = 'Octal'
          GroupIndex = 4
          RadioItem = True
          OnClick = None1Click
        end
        object None1: TMenuItem
          Tag = 3
          Caption = 'None'
          GroupIndex = 4
          RadioItem = True
          OnClick = None1Click
        end
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Translation1: TMenuItem
        Caption = 'Translation'
        object Ansi1: TMenuItem
          Caption = 'Ansi'
          Checked = True
          GroupIndex = 5
          RadioItem = True
          OnClick = Ansi1Click
        end
        object ASCII7Bit1: TMenuItem
          Tag = 2
          Caption = 'ASCII 7 Bit'
          GroupIndex = 5
          RadioItem = True
          OnClick = Ansi1Click
        end
        object DOS8Bit1: TMenuItem
          Tag = 1
          Caption = 'DOS 8 Bit'
          GroupIndex = 5
          RadioItem = True
          OnClick = Ansi1Click
        end
        object Mac1: TMenuItem
          Tag = 3
          Caption = 'Mac'
          GroupIndex = 5
          RadioItem = True
          OnClick = Ansi1Click
        end
        object IBMEBCDICcp381: TMenuItem
          Tag = 4
          Caption = 'IBM EBCDIC CP 38'
          GroupIndex = 5
          RadioItem = True
          OnClick = Ansi1Click
        end
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Grid1: TMenuItem
        Caption = 'Grid'
        OnClick = Grid1Click
      end
      object Showmarkers1: TMenuItem
        Caption = 'Show markers'
        OnClick = Showmarkers1Click
      end
      object SwapNibbles1: TMenuItem
        Caption = 'Swap nibbles'
        OnClick = SwapNibbles1Click
      end
      object MaskWhitespaces1: TMenuItem
        Caption = 'Mask whitespace'
        Checked = True
        OnClick = MaskWhitespaces1Click
      end
      object FixedFilesize1: TMenuItem
        Caption = 'Fixed file size'
        OnClick = FixedFilesize1Click
      end
      object ReadOnly1: TMenuItem
        Caption = 'Read only'
        OnClick = ReadOnly1Click
      end
    end
  end
  object SaveDialog: TSaveDialog
    Filter = 'All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Title = 'Save as'
    Left = 342
    Top = 175
  end
  object OpenDialog: TOpenDialog
    Filter = 'All Files (*.*)|*.*'
    Options = [ofPathMustExist, ofFileMustExist]
    Title = 'Open file'
    Left = 392
    Top = 161
  end
  object HexToCanvas: THexToCanvas
    HexEditor = HexEditor
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    StretchToFit = False
    Left = 508
    Top = 169
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 374
    Top = 63
  end
end
