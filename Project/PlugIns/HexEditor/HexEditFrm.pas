unit HexEditFrm; //StatusBar //Modal

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, Buttons, ComCtrls, Menus , clipbrd,
  Printers, HexPrinterFrm,HexEditConvFrm, hexeditor;

type
  THexEditForm = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu: TMainMenu;
    Datei1: TMenuItem;
    Neu1: TMenuItem;
    ffnen1: TMenuItem;
    Speichern1: TMenuItem;
    Speichernunter1: TMenuItem;
    Bearbeiten1: TMenuItem;
    Rckgngig1: TMenuItem;
    N3: TMenuItem;
    Ausschneiden1: TMenuItem;
    Kopieren1: TMenuItem;
    Einfgen1: TMenuItem;
    View1: TMenuItem;
    _16: TMenuItem;
    _32: TMenuItem;
    _64: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    N2: TMenuItem;
    Blocksize1: TMenuItem;
    N2Bytesperblock1: TMenuItem;
    N4Bytesperblock1: TMenuItem;
    N1Byteperblock1: TMenuItem;
    N5: TMenuItem;
    Goto1: TMenuItem;
    Caretstyle1: TMenuItem;
    Fullblock1: TMenuItem;
    Leftline1: TMenuItem;
    Bottomline1: TMenuItem;
    Linesize1: TMenuItem;
    Grid1: TMenuItem;
    Offsetdisplay1: TMenuItem;
    Hex1: TMenuItem;
    Dec1: TMenuItem;
    None1: TMenuItem;
    Showmarkers1: TMenuItem;
    Find1: TMenuItem;
    FindNext1: TMenuItem;
    Jump1: TMenuItem;
    Amount40001: TMenuItem;
    N4: TMenuItem;
    Jumpforward1: TMenuItem;
    Jumpbackward1: TMenuItem;
    HexToCanvas: THexToCanvas;
    HexEditor: THexEditor;
    N6: TMenuItem;
    Printpreview1: TMenuItem;
    PrinterSetupDialog: TPrinterSetupDialog;
    Printsetup1: TMenuItem;
    Print1: TMenuItem;
    N7: TMenuItem;
    Translation1: TMenuItem;
    Ansi1: TMenuItem;
    ASCII7Bit1: TMenuItem;
    DOS8Bit1: TMenuItem;
    Mac1: TMenuItem;
    IBMEBCDICcp381: TMenuItem;
    SwapNibbles1: TMenuItem;
    InsertNibble1: TMenuItem;
    DeleteNibble1: TMenuItem;
    N8: TMenuItem;
    Convertfile1: TMenuItem;
    MaskWhitespaces1: TMenuItem;
    AnyFile1: TMenuItem;
    HexText1: TMenuItem;
    ImportfromHexText1: TMenuItem;
    FixedFilesize1: TMenuItem;
    Octal1: TMenuItem;
    PasteText1: TMenuItem;
    N9: TMenuItem;
    Auto1: TMenuItem;
    Printlayout1: TMenuItem;
    Hex2: TMenuItem;
    Decimal1: TMenuItem;
    Octal2: TMenuItem;
    ReadOnly1: TMenuItem;
    procedure Bearbeiten1Click(Sender: TObject);
    procedure Datei1Click(Sender: TObject);
    procedure Einfgen1Click(Sender: TObject);
    procedure Rckgngig1Click(Sender: TObject);
    procedure HexEditorStateChanged(Sender: TObject);
    procedure Kopieren1Click(Sender: TObject);
    procedure Ausschneiden1Click(Sender: TObject);
    procedure _64Click(Sender: TObject);
    procedure View1Click(Sender: TObject);
    procedure Neu1Click(Sender: TObject);
    procedure ffnen1Click(Sender: TObject);
    procedure Speichern1Click(Sender: TObject);
    procedure HexEditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Blocksize1Click(Sender: TObject);
    procedure N4Bytesperblock1Click(Sender: TObject);
    procedure Goto1Click(Sender: TObject);
    procedure Caretstyle1Click(Sender: TObject);
    procedure Bottomline1Click(Sender: TObject);
    procedure Grid1Click(Sender: TObject);
    procedure Offsetdisplay1Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure Showmarkers1Click(Sender: TObject);
    procedure FindNext1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Jumpforward1Click(Sender: TObject);
    procedure Jumpbackward1Click(Sender: TObject);
    procedure Amount40001Click(Sender: TObject);
    procedure Jump1Click(Sender: TObject);
    procedure Printpreview1Click(Sender: TObject);
    procedure Printsetup1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Ansi1Click(Sender: TObject);
    procedure SwapNibbles1Click(Sender: TObject);
    procedure InsertNibble1Click(Sender: TObject);
    procedure DeleteNibble1Click(Sender: TObject);
    procedure Convertfile1Click(Sender: TObject);
    procedure MaskWhitespaces1Click(Sender: TObject);
    procedure AnyFile1Click(Sender: TObject);
    procedure HexText1Click(Sender: TObject);
    procedure ImportfromHexText1Click(Sender: TObject);
    procedure FixedFilesize1Click(Sender: TObject);
    procedure PasteText1Click(Sender: TObject);
    procedure Auto1Click(Sender: TObject);
    procedure Printlayout1Click(Sender: TObject);
    procedure Hex2Click(Sender: TObject);
    procedure Decimal1Click(Sender: TObject);
    procedure Octal2Click(Sender: TObject);
    procedure ReadOnly1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    function SaveFile : Boolean;
    procedure Error ( aMsg : string );
    procedure AppendByte;
  public
    function CheckChanges : Boolean;
  end;

var
  HexEditForm: THexEditForm;
  FindPos : Integer = -1;
  FindBuf : PChar = nil;
  FindLen : Integer = 0;
  FindStr : string = '';
  FindICase : Boolean = False;
  JumpOffs : Integer = 4000;
  CanvasDisplay : TOffsetDisplayStyle = odHex;

  OptiPerl : Variant;

implementation

{$R *.DFM}

const
 cCaption = 'Hex editor';


(* utility routines *)
function SaveText ( const aText , aName : string ) : Boolean;
var
   f : System.Text;
begin
     {$I-}
     AssignFile ( f , aName );
     Rewrite ( f );
     write ( f , aText );
     CloseFile ( f );
     Result := IOResult = 0;
     {$I+}
end;

function LoadText ( const aName : string ) : string;
var
   fST : TMemoryStream;
begin
     Result := '';
     if not FileExists ( aName )
     then
         Exit;
     fST := TMemoryStream.Create;
     try
        fST.LoadFromFile ( aName );
        SetLength ( Result , fST.Size );
        fST. Position := 0;
        fST.Read ( Result[1] , fST.Size );
     finally
            fST.Free;
     end;
end;

(* form1 routines *)
procedure THexEditForm.Bearbeiten1Click(Sender: TObject);
begin
     with Rckgngig1
     do begin
        Enabled := HexEditor.CanUndo;
        Caption := 'Undo : '+HexEditor.UndoDescription;
     end;
     Ausschneiden1.Enabled := (HexEditor.SelCount > 0) and (not HexEditor.ReadOnlyView);
     Kopieren1.Enabled := HexEditor.SelCount > 0;
     Einfgen1.Enabled := (Clipboard.HasFormat ( CF_TEXT )) and (not HexEditor.ReadOnlyView);
     PasteText1.Enabled := Einfgen1.Enabled;
     Goto1.Enabled := HexEditor.DataSize > 0;
     Find1.Enabled := HexEditor.DataSize > 0;
     FindNext1.Enabled := HexEditor.DataSize > 0;
     InsertNibble1.Enabled := (HexEditor.DataSize > 0) and (not HexEditor.ReadOnlyView);
     DeleteNibble1.Enabled := (HexEditor.DataSize > 0) and (not HexEditor.ReadOnlyView);
     ConvertFile1.Enabled := HexEditor.DataSize > 0;
     if HexEditor.SelCount = 0
     then
         ConvertFile1.Caption := 'Convert File'
     else
         ConvertFile1.Caption := 'Convert Selection'
end;

procedure THexEditForm.Datei1Click(Sender: TObject);
begin
     Speichern1.Enabled := HexEditor.Modified and (not HexEditor.ReadOnlyFile);
     Speichernunter1.Enabled := HexEditor.DataSize > 0;
     PrintPreview1.Enabled := HexEditor.DataSize > 0;
     Print1.Enabled := HexEditor.DataSize > 0;
end;

procedure THexEditForm.Einfgen1Click(Sender: TObject);
var
   sr : string;
   BT : Integer;
begin
     Bearbeiten1Click ( Sender );
     if Einfgen1.Enabled
     then begin
          // paste clipboard
          sr := Clipboard.AsText;
          HexEditor.ReplaceSelection ( ConvertHexToBin ( @sr[1] , @sr[1] , Length ( sr ) , False , bt ) , bt);
     end;
end;

procedure THexEditForm.Rckgngig1Click(Sender: TObject);
begin
     if HexEditor.CanUndo
     then
         HexEditor.Undo;
end;

procedure THexEditForm.HexEditorStateChanged(Sender: TObject);
var
   pSS , pSE : Integer;
begin
     with HexEditor,StatusBar1
     do begin
        Panels[0].Text := 'Pos : '+IntToStr ( GetCursorPos );
        if SelCount <> 0
        then begin
             pSS := SelStart;
             pSE := SelEnd;
             Panels[1].Text := 'Sel : '+IntToStr ( Min ( pSS , pSE)) +' - '+IntToStr(Max ( pSS , pSE));
        end
        else
            Panels[1].Text := '';

        if Modified
        then
            Panels[2].Text := '*'
        else
            Panels[2].Text := '';

        if ReadOnlyFile
        then
            Panels[3].Text := 'R'
        else
            Panels[3].Text := '';

        if IsInsertMode
        then
            Panels[4].Text := 'INS'
        else
            Panels[4].Text := 'OVW';

        Panels[5].Text := 'Size : '+IntToStr ( DataSize );
        Self.Caption := cCaption+'['+FileName+']';
     end;
end;

procedure SetCBText ( aP : PChar ; aCount : Integer );
var
   sr : string;
begin
     SetLength ( sr , aCount * 2 );
     ConvertBinToHex ( aP , @sr[1] , aCount , False );
     ClipBoard.AsText := sr;
     SetLength ( sr , 0 );
end;

procedure THexEditForm.Kopieren1Click(Sender: TObject);
var
   pct : Integer;
   pPC : PChar;
begin
     Bearbeiten1Click ( Sender );
     if Kopieren1.Enabled
     then
         with HexEditor
         do begin
            pCT := SelCount;
            pPC := BufferFromFile ( Min ( SelStart , SelEnd ) , pCT );
            SetCBText ( pPC , pCT );
            FreeMem ( pPC , pCT );
         end;

end;

procedure THexEditForm.Ausschneiden1Click(Sender: TObject);
var
   pct : Integer;
   pPC : PChar;
begin
     Bearbeiten1Click ( Sender );
     if Ausschneiden1.Enabled
     then
         with HexEditor
         do begin
            pCT := SelCount;
            pPC := BufferFromFile ( Min ( SelStart , SelEnd ) , pCT );
            SetCBText ( pPC , pCT );
            FreeMem ( pPC , pCT );
            DeleteSelection;
         end;

end;

procedure THexEditForm._64Click(Sender: TObject);
begin
     HexEditor.BytesPerLine := TMenuItem ( Sender).Tag;
end;

procedure THexEditForm.View1Click(Sender: TObject);
begin
     Case HexEditor.BytesPerLine
     of
       16 : _16.Checked := True;
       32 : _32.Checked := True;
       64 : _64.Checked := True;
     end;
     Grid1.Checked := HexEditor.GridLineWidth = 1;
     ShowMarkers1.Checked := HexEditor.ShowMarkerColumn;
     SwapNibbles1.Checked := HexEditor.SwapNibbles;
     MaskWhiteSpaces1.Checked := HexEditor.MaskWhiteSpaces;
     ReadOnly1.Checked := HexEditor.ReadOnlyView;
     Case HexEditor.Translation
     of
       ttAnsi : Ansi1.Checked := True;
       ttASCII : ASCII7Bit1.Checked := True;
       ttDOS8 : Dos8Bit1.Checked := True;
       ttMac  : Mac1.Checked := True;
       ttEBCDIC : IBMEBCDICCP381.Checked := True;
     end;
     FixedFileSize1.Checked := HexEditor.NoSizeChange;
end;

procedure THexEditForm.Neu1Click(Sender: TObject);
begin
     if CheckChanges
     then
         HexEditor.CreateEmptyFile ( 'Untitled' );
end;

function THexEditForm.CheckChanges : Boolean;
var
   psr : string;
begin
     Result := True;
     if not HexEditor.Modified
     then
         Exit;
     Result := False;
     pSR := HexEditor.FileName;
     if not FileExists ( pSR )
     then
         pSR := 'Unnamed File';

     Case MessageDlg ( 'Save changes to'#13#10+psr+' ?' , mtConfirmation , [mbNo , mbYes , mbCancel] , 0 )
     of
       IDNo     : Result := True;
       IDYES    : Result := SaveFile;
     end;
end;


procedure THexEditForm.ffnen1Click(Sender: TObject);
begin
     if CheckChanges
     then
         if Opendialog.Execute
         then begin
              HexEditor.LoadfromFile(OpenDialog.FileName);
              if ofReadOnly in OpenDialog.Options
              then
                  HexEditor.ReadOnlyFile := True;
         end;

end;

procedure THexEditForm.Speichern1Click(Sender: TObject);
begin
     SaveFile ;
end;

function THexEditForm.SaveFile : Boolean;
begin
     Result := False;
     if ( not FileExists ( HexEditor.FileName )) or HexEditor.ReadOnlyFile
     then begin
          if SaveDialog.Execute
          then begin
               if HexEditor.SaveToFile ( SaveDialog.FileName )
               then
                   Result := True
               else begin
                    Error ( 'Cannot save file'#13#10+HexEditor.FileName );
               end;
          end
     end
     else
         if HexEditor.SaveToFile ( HexEditor.FileName )
         then
             Result := True
         else
             Error ( 'Cannot save file'#13#10+HexEditor.FileName );


end;

procedure THexEditForm.Error ( aMsg : string );
begin
     Windows.MessageBox ( Handle , PChar ( aMsg ) , nil , MB_ICONHAND);
end;


procedure THexEditForm.HexEditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if (Shift = [ssCTRL] ) and ( KEY = Ord('A') )
     then begin
          Key := 0;
          AppendByte ;
     end;
end;


procedure THexEditForm.AppendByte;
var
   pBY : Byte;
begin
     pBY := 255;
     HexEditor.AppendBuffer ( @pBY , 1 );
end;

procedure THexEditForm.Blocksize1Click(Sender: TObject);
begin
     case HexEditor.BytesPerColumn
     of
       1 : N1Byteperblock1.Checked := True;
       2 : N2Bytesperblock1.Checked := True;
       4 : N4Bytesperblock1.Checked := True;
     end;

end;

procedure THexEditForm.N4Bytesperblock1Click(Sender: TObject);
begin
     HexEditor.BytesPerColumn := TMenuItem ( Sender) . Tag;
end;

procedure THexEditForm.Goto1Click(Sender: TObject);
var
   sr : string;
   s1 : LongInt;
begin
     if HexEditor.DataSize < 1
     then
         Exit;

     s1 := HexEditor.GetCursorPos;
     sr := IntToStr ( s1 );
     if InputQuery ( 'Goto file position...' ,
                     '(prefix "0x" or "$" means hex)', sr )
     then begin
          if Pos ( '0x' , AnsiLowerCase ( sr ) ) = 1
          then
              sr := '$'+Copy ( sr , 3 , MaxInt );

          s1 :=  StrToIntDef ( sr , -1 );
          if not HexEditor.Seek ( s1 , soFromBeginning , True )
          then
              Error ( 'Invalid position' )
     end;

end;

procedure THexEditForm.Caretstyle1Click(Sender: TObject);
begin
     case HexEditor.CaretStyle
     of
       csFull       : FullBlock1.Checked := True;
       csLeftLine   : LeftLine1.Checked := True;
       csBottomLine : BottomLine1.Checked := True;
     end;


end;

procedure THexEditForm.Bottomline1Click(Sender: TObject);
begin
     HexEditor.CaretStyle := TCaretStyle(TMenuItem(Sender).Tag);
end;

procedure THexEditForm.Grid1Click(Sender: TObject);
begin
      HexEditor.GridLineWidth := 1 - HexEditor.GridLineWidth;
end;

procedure THexEditForm.Offsetdisplay1Click(Sender: TObject);
begin
     case HexEditor.OffsetDisplay
     of
       odHex       : Hex1.Checked := True;
       odDec       : Dec1.Checked := True;
       odOctal     : Octal1.Checked := True;
       odNone      : None1.Checked := True;
     end;
     Auto1.Checked := HexEditor.AutoCaretMode;
end;

procedure THexEditForm.None1Click(Sender: TObject);
begin
     HexEditor.OffsetDisplay := TOffsetDisplayStyle(TMenuItem(Sender).Tag);

end;

procedure THexEditForm.Showmarkers1Click(Sender: TObject);
begin
     HexEditor.ShowMarkerColumn := not HexEditor.ShowMarkerColumn;
end;

procedure THexEditForm.FindNext1Click(Sender: TObject);
begin
     if HexEditor.DataSize < 1
     then
         Exit;

     if FindStr = ''
     then
         Find1.Click
     else begin
          if FindPos = HexEditor.SelEnd
          then
              Inc ( FindPos , 1 );

         FindPos := HexEditor.Find ( FindBuf , FindLen , FindPos , HexEditor.DataSize -1 , FindICase , False);
         if FindPos = -1
         then
             ShowMessage ( 'Data not found.' )
         else begin
              HexEditor.SelStart := FindPos+FindLen-1;
              HexEditor.SelEnd := FindPos ;
         end;
     end;
end;

procedure THexEditForm.Find1Click(Sender: TObject);
const
     cHexChars = '0123456789abcdef';
var
   pSTR,pTMP : String;
   pCT,pCT1 : Integer;
begin
     if HexEditor.DataSize < 1
     then
         Exit;

     FindPos := -1;
     FindICase := False;
     if FindBuf <> nil
     then begin
          FreeMem ( FindBuf );
          FindBuf := nil;
     end;
     if not InputQuery ( 'Find Data' , '"t.." ascii, "T.." + ignore case, else search hex' , FindStr )
     then
         Exit;

     // make a search string
     if FindStr = ''
     then
         Exit;

     pStr := '';

     if UpCase(FindStr[1]) = 'T'
     then begin
          pStr := Copy ( FindStr , 2 , MaxInt );
          pCT1 := Length ( pStr );
     end
     else begin
          // calculate Data from input
          pTMP := AnsiLowerCase ( FindStr);

          for pCT := Length ( pTMP ) downto 1
          do
            if Pos( pTMP[pCT] , cHexChars ) = 0
            then
                Delete ( pTMP , pCT , 1 );

          while (Length(pTMP) mod 2) <> 0
          do
            pTMP := '0'+pTMP;

          if pTMP = ''
          then
              Exit;

          pSTR := '';
          pCT1 := Length ( pTMP ) div 2;
          for pCT := 0 to (Length ( pTMP ) div 2) -1
          do
            pStr := pStr + Char ( (Pos ( pTMP[pCt*2+1] , cHexChars ) -1) * 16 + (Pos ( pTMP[pCt*2+2] , cHexChars ) -1));
     end;

     if pCT1 = 0
     then
         Exit;

     GetMem ( FindBuf , pCT1 );
     try
        if FindStr[1] = 'T'
        then
            FindICase := True;

        FindLen := pCT1;

        Move ( pStr[1] , FindBuf^, pCt1 );

        FindPos := HexEditor.Find ( FindBuf , FindLen , HexEditor.GetCursorPos , HexEditor.DataSize -1 , FindICase , UpCase(FindStr[1]) = 'T' );
        if FindPos = -1
        then
            ShowMessage ( 'Data not found.' )
        else begin
             HexEditor.SelStart := FindPos+FindLen-1;
             HexEditor.SelEnd := FindPos ;
        end;

     finally
     end;


end;

procedure THexEditForm.FormDestroy(Sender: TObject);
begin
     if FindBuf <> nil
     then begin
          FreeMem ( FindBuf );
          FindBuf := nil;
     end;
end;

procedure THexEditForm.Jumpforward1Click(Sender: TObject);
begin
     HexEditor.Seek ( JumpOffs , soFromCurrent , False );
end;

procedure THexEditForm.Jumpbackward1Click(Sender: TObject);
begin
     HexEditor.Seek ( -JumpOffs , soFromCurrent , False );

end;

procedure THexEditForm.Amount40001Click(Sender: TObject);
var
   sr : string;
begin
     sr := IntToStr ( JumpOffs );
     if InputQuery ( 'Jump amount' , 'Enter new value:' , sr )
     then
         JumpOffs := StrToIntDef ( sr , JumpOffs );
end;

procedure THexEditForm.Jump1Click(Sender: TObject);
begin
     Amount40001.Caption := 'Amount : '+IntToStr ( JumpOffs );
     JumpForward1.Enabled := HexEditor.DataSize > 0;
     JumpBackWard1.Enabled := HexEditor.DataSize > 0;
end;

procedure THexEditForm.Printpreview1Click(Sender: TObject);
var
   pBMP : TBitMap;
   l1 : Integer;
begin
     pBMP := TBitmap.Create;
     try
        pBMP.Width := 1000 ;
        pBMP.Height := Round ( Printer.PageHeight / Printer.PageWidth * 1000 );
        with pBMP
        do begin
           Canvas.Brush.Color := clWhite;
           Canvas.Brush.Style := bsSolid;
           Canvas.FillRect ( Rect ( 0 , 0 , Width , Height ) );
           // nun ränder berechnen
           HexToCanvas.GetLayout;
           HexToCanvas.MemFieldDisplay := CanvasDisplay;
           HexToCanvas.StretchToFit := False;
           HexToCanvas.TopMargin := Height div 20;
           HexToCanvas.BottomMargin := Height - (Height div 20);
           HexToCanvas.LeftMargin := Width div 20;
           HexToCanvas.RightMargin := Width - (Width div 20);
           HexToCanvas.Draw ( Canvas , 0 , HexEditor.DataSize -1 , 'Hex Editor - '+ExtractFileName(HexEditor.FileName),' - Page 1' );
        end;
        with THexPrinterForm.Create(Forms.Application) do
        try
           Image.Width := ClientWidth;
           l1 := Round ( Image.Width / pBMP.Width * pBMP.Height );
           if l1 > ClientHeight
           then begin
                Image.Height := ClientHeight;
                Image.Width := Round ( Image.Height / pBMP.Height * pBMP.Width );
           end
           else
               Image.Height := l1;
           Image.Picture.Bitmap.Assign ( pBMP );
           ShowModal;
        finally
               Free;
        end;
     finally
            pBMP.Free;
     end;
end;

procedure THexEditForm.Printsetup1Click(Sender: TObject);
begin
 PrinterSetupDialog.Execute;
end;

procedure THexEditForm.Print1Click(Sender: TObject);
var
   l1,l2 : Integer;
begin
     if HexEditor.DataSize < 1
     then
         Exit;

     l1 := 0;

     with Printer
     do begin
        // nun ränder berechnen
        HexToCanvas.StretchToFit := False;
        HexToCanvas.GetLayout;
        HexToCanvas.MemFieldDisplay := CanvasDisplay;
        HexToCanvas.TopMargin := PageHeight div 20;
        HexToCanvas.BottomMargin := PageHeight - (PageHeight div 20);
        HexToCanvas.LeftMargin := PageWidth div 20;
        HexToCanvas.RightMargin := PageWidth - (PageWidth div 20);
        l2 := 1;
        BeginDoc;
        repeat
              Canvas.Brush.Color := clWhite;
              Canvas.Brush.Style := bsSolid;
              Canvas.FillRect ( Rect ( 0 , 0 , PageWidth , PageHeight ) );
              l1 := HexToCanvas.Draw ( Canvas , l1 , HexEditor.DataSize -1 ,
              'Hex Editor - '+ExtractFileName(HexEditor.FileName),' - Page '+IntToStr(l2) );
              if l1 < HexEditor.DataSize
              then
                  NewPage;
              l2 := l2+1;
        until l1 >= HexEditor.DataSize;
        EndDoc;
     end;
end;

procedure THexEditForm.Ansi1Click(Sender: TObject);
begin
     HexEditor.Translation := TTranslationType ( TMenuItem ( Sender ) . Tag ) ;
end;

procedure THexEditForm.SwapNibbles1Click(Sender: TObject);
begin
     HexEditor.SwapNibbles := not HexEditor.SwapNibbles;
end;

procedure THexEditForm.InsertNibble1Click(Sender: TObject);
begin
     HexEditor.InsertNibble ( HexEditor.GetCursorPos , HexEditor.InCharField or ((HexEditor.Col mod 2) = 0 ));
end;

procedure THexEditForm.DeleteNibble1Click(Sender: TObject);
begin
     HexEditor.DeleteNibble ( HexEditor.GetCursorPos , HexEditor.InCharField or ((HexEditor.Col mod 2) = 0 ));
end;

procedure THexEditForm.Convertfile1Click(Sender: TObject);
var
   pFrom , pTo : Integer;
begin
     pFrom := 0;
     pTO := HexEditor.DataSize-1;
     if HexEditor.SelCount <> 0
     then begin
          pFrom := Min ( HexEditor.SelStart , HexEditor.SelEnd );
          pTo := Max ( HexEditor.SelStart , HexEditor.SelEnd );
     end;
     with THexEditConvForm.Create(Forms.Application) do
     try
        Caption := ConvertFile1.Caption;
        if ShowModal = IDOK
        then
            HexEditor.ConvertRange ( pFrom , pTo , TTranslationType(ListBox1.ItemIndex) ,
                                      TTranslationType(ListBox2.ItemIndex) );
     finally
            Free;
     end;

end;

procedure THexEditForm.MaskWhitespaces1Click(Sender: TObject);
begin
     HexEditor.MaskWhiteSpaces := not HexEditor.MaskWhiteSpaces;
end;

procedure THexEditForm.AnyFile1Click(Sender: TObject);
begin
     if SaveDialog.Execute
     then
          if not HexEditor.SaveToFile ( SaveDialog.FileName )
          then
               Error ( 'Cannot save file'#13#10+SaveDialog.FileName );

end;

procedure THexEditForm.HexText1Click(Sender: TObject);
begin
     if SaveDialog.Execute
     then
          if not SaveText ( HexEditor.AsHex , SaveDialog.FileName )
          then
               Error ( 'Cannot save file'#13#10+SaveDialog.FileName );


end;

procedure THexEditForm.ImportfromHexText1Click(Sender: TObject);
begin
     if Opendialog.Execute
     then begin
          HexEditor.AsHex := LoadText(Opendialog.FileName);
          if ofReadOnly in Opendialog.Options
          then
              HexEditor.ReadOnlyFile := True;
     end;
end;

procedure THexEditForm.FixedFilesize1Click(Sender: TObject);
begin
     HexEditor.NoSizeChange := not HexEditor.NoSizeChange;

end;

procedure THexEditForm.PasteText1Click(Sender: TObject);
var
   sr : string;
begin
     Bearbeiten1Click ( Sender );
     if Einfgen1.Enabled
     then begin
          // paste clipboard
          sr := Clipboard.AsText;
          HexEditor.ReplaceSelection ( @sr[1] , Length ( sr ) );
     end;
end;

procedure THexEditForm.Auto1Click(Sender: TObject);
begin
     HexEditor.AutoCaretMode := not HexEditor.AutoCaretMode;
end;

procedure THexEditForm.Printlayout1Click(Sender: TObject);
begin
     case CanvasDisplay
     of
       odHex : Hex2.Checked := True;
       odDec : Decimal1.Checked := True;
       odOctal : Octal2.Checked := True;
     end;
end;

procedure THexEditForm.Hex2Click(Sender: TObject);
begin
     CanvasDisplay := odHex;
end;

procedure THexEditForm.Decimal1Click(Sender: TObject);
begin
     CanvasDisplay := odDec;

end;

procedure THexEditForm.Octal2Click(Sender: TObject);
begin
     CanvasDisplay := odOctal;

end;

procedure THexEditForm.ReadOnly1Click(Sender: TObject);
begin
     HexEditor.ReadOnlyView := not HexEditor.ReadOnlyView;
end;

procedure THexEditForm.FormCreate(Sender: TObject);
begin
 HexEditor.Font.Name:=OptiPerl.GetOpt('FontName');
 HexToCanvas.Font.Name:=OptiPerl.GetOpt('FontName');
 HexEditor.Font.Size:=OptiPerl.GetOpt('FontSize');
end;

end.