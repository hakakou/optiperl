{-------------------------------------------------------------------------------
 
 Copyright (c) 1999-2003 The Delphi Inspiration - Ralf Junker
 Internet: http://www.zeitungsjunge.de/delphi/
 E-Mail:   delphi@zeitungsjunge.de

-------------------------------------------------------------------------------}

unit DIPcreControls;

interface

{$I DI.inc}

{$DEFINE DefaultContextMenu}

uses
  Windows,
  Messages,
  Classes,
  Controls,
  StdCtrls,

  DIPcre;

type
  {$IFNDEF DefaultContextMenu}
  {$IFNDEF DELPHI_5_UP}

  TWMContextMenu = packed record
    Msg: Cardinal;
    HWND: HWND;
    case Integer of
      0: (
        XPos: SmallInt;
        YPos: SmallInt);
      1: (
        Pos: TSmallPoint;
        Result: LongInt);
  end;
  {$ENDIF}
  {$ENDIF}

  TDICustomPcreEdit = class(TCustomEdit)
  private
    FAlignment: TAlignment;
    FPcre: TDIPcre;

    procedure SetAlignment(const Value: TAlignment);
    procedure SetPcre(const Value: TDIPcre);
    procedure SetTextAsInteger(const AValue: Integer);

    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure WMClear(var Message: TWMClear); message WM_CLEAR;
    {$IFNDEF DefaultContextMenu}

    procedure WMContextMenu(var Message: TWMContextMenu); message WM_CONTEXTMENU;
    {$ENDIF}
    procedure WMCut(var Message: TWMCut); message WM_CUT;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
    procedure WMPaste(var Message: TWMPaste); message WM_PASTE;
    procedure WMSetTExt(var Message: TWMSetText); message WM_SETTEXT;
  protected
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Keydown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    {$IFNDEF DI_No_Pcre_Component}

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    {$ENDIF}
    property Pcre: TDIPcre read FPcre write SetPcre;

    property TextAsInteger: Integer write SetTextAsInteger;
  public
    procedure Clear; override;
  end;

  TDIPcreEdit = class(TDICustomPcreEdit)
  public
    {$IFDEF DI_No_Pcre_Component}
    property Pcre;
    {$ENDIF}

    property TextAsInteger;
  published
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BidiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property maxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    {$IFDEF DELPHI_5_UP}
    property OnContextPopup;
    {$ENDIF}
    {$IFDEF DELPHI_6_UP}
    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;

    property Alignment;
    {$IFNDEF DI_No_Pcre_Component}
    property Pcre;
    {$ENDIF}
  end;

  TDICustomPcreComboBox = class(TCustomComboBox)
  private
    FPcre: TDIPcre;
    procedure SetPcre(const Value: TDIPcre);

    procedure WMSetTExt(var Message: TWMSetText); message WM_SETTEXT;
  protected

    procedure ComboWndProc(var Message: TMessage; ComboWnd: HWND; ComboProc: Pointer); override;

    procedure KeyPress(var Key: Char); override;
    procedure Keydown(var Key: Word; Shift: TShiftState); override;
    {$IFNDEF DI_No_Pcre_Component}
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    {$ENDIF}
    property Pcre: TDIPcre read FPcre write SetPcre;
    {$IFDEF DELPHI_6_UP}
  public
    constructor Create(Owner: TComponent); override;
    {$ENDIF}
  end;

  TDIPcreComboBox = class(TDICustomPcreComboBox)
    {$IFDEF DI_No_Pcre_Component}
  public
    property Pcre;
    {$ENDIF}
  published
    property Style;
    property Anchors;
    property BidiMode;
    property Color;
    property Constraints;
    property CharCase;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property ItemIndex default -1;
    property maxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    {$IFDEF DELPHI_5_UP}
    property OnContextPopup;
    {$ENDIF}
    {$IFDEF DELPHI_6_UP}

    property AutoDropDown;

    property BevelEdges;
    property BevelInner;
    property BevelKind;
    property BevelOuter;

    property OnCloseUp;
    property OnSelect;
    {$ENDIF}
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnStartDock;
    property OnStartDrag;
    property Items;

    {$IFNDEF DI_No_Pcre_Component}
    property Pcre;
    {$ENDIF}
  end;

implementation

uses
  SysUtils

  ;

procedure EditGetSelection(const Handle: HWND; out SelectionStart, SelectionLength: Cardinal);
begin
  SendMessage(Handle, EM_GETSEL, wParam(@SelectionStart), lParam(@SelectionLength));
  Dec(SelectionLength, SelectionStart);
  Inc(SelectionStart);
end;

procedure EditSetSelection(const Handle: HWND; const SelectionStart, SelectionLength: Cardinal);
begin
  SendMessage(Handle, EM_SETSEL, SelectionStart, SelectionStart + SelectionLength);
end;

procedure EditSelectAll(const Handle: HWND);
begin
  SendMessage(Handle, EM_SETSEL, 0, -1);
end;

procedure EditReplaceSelection(const Handle: HWND; const Text: AnsiString);
begin
  SendMessage(Handle, EM_REPLACESEL, 0, lParam(PAnsiChar(Text)));
end;

function EditGetText(const Handle: HWND): AnsiString;
var
  l: lResult;
begin
  l := SendMessage(Handle, WM_GETTEXTLENGTH, 0, 0);
  SetLength(Result, l);
  if l > 0 then SendMessage(Handle, WM_GETTEXT, l + 1, lParam(Result))
end;

procedure PcreControl_KeyDown(const Handle: HWND; const Pcre: TDIPcre; var Key: Word; const Shift: TShiftState);
label
  ZeroKey;
var
  TheText, NewText: AnsiString;
  SelectionStart: Cardinal;
  SelectionLength, NewSelectionLength: Cardinal;
begin
  case Key of
    Ord('A'):
      if ssCtrl in Shift then EditSelectAll(Handle);
    VK_DELETE:
      begin
        if (Handle = 0) or (Pcre = nil) then Exit;

        TheText := EditGetText(Handle);
        EditGetSelection(Handle, SelectionStart, SelectionLength);

        if SelectionStart > Cardinal(Length(TheText)) then Exit;

        if SelectionLength = 0 then Inc(SelectionLength);

        NewText := TheText;

        Delete(NewText, SelectionStart, SelectionLength);
        if Pcre.MatchStr(NewText) >= 0 then Exit;

        NewSelectionLength := SelectionLength - 1;
        while NewSelectionLength > 0 do
          begin
            Insert(TheText[SelectionStart + NewSelectionLength], NewText, SelectionStart);
            if Pcre.MatchStr(NewText) >= 0 then
              begin

                EditReplaceSelection(Handle, Copy(NewText, SelectionStart, SelectionLength - NewSelectionLength));
                EditSetSelection(Handle, SelectionStart - 1, 0);
                goto ZeroKey;
              end;

            Dec(NewSelectionLength);
          end;

        EditSetSelection(Handle, SelectionStart, 0);
        goto ZeroKey;
      end;
  end;

  Exit;

  ZeroKey:
  Key := 0;
end;

procedure PcreControl_KeyPress(const Handle: HWND; const Pcre: TDIPcre; var Key: AnsiChar);
label
  ZeroKey;
var
  TheText, NewText: AnsiString;
  i: Cardinal;
  SelectionStart, NewSelectionStart: Cardinal;
  SelectionLength, NewSelectionLength: Cardinal;
  TextLength: Cardinal;
begin
  if (Handle = 0) or (Pcre = nil) then Exit;

  case Key of
    #0..#2, #4..#7, #9..#12, #14..#25, #28..#31:
      begin
        goto ZeroKey;
      end;

    #3,
    #26,
    AnsiChar(VK_RETURN),
    AnsiChar(VK_ESCAPE):
      begin
        Exit;
      end;

    #8:
      begin
        EditGetSelection(Handle, SelectionStart, SelectionLength);

        if SelectionLength = 0 then
          begin
            Inc(SelectionLength);
            Dec(SelectionStart);
          end;

        if SelectionStart = 0 then Exit;

        TheText := EditGetText(Handle);

        NewText := TheText;
        Delete(NewText, SelectionStart, SelectionLength);
        if Pcre.MatchStr(NewText) >= 0 then Exit;

        NewSelectionStart := SelectionStart;

        while NewSelectionStart - SelectionStart < SelectionLength - 1 do
          begin
            Insert(TheText[NewSelectionStart], NewText, NewSelectionStart);
            Inc(NewSelectionStart);
            if Pcre.MatchStr(NewText) >= 0 then
              begin
                EditReplaceSelection(Handle, Copy(NewText, SelectionStart, NewSelectionStart - SelectionStart));
                goto ZeroKey;
              end;
          end;

        EditSetSelection(Handle, NewSelectionStart - 1, 0); ;
      end;

  else
    begin
      TheText := EditGetText(Handle);
      EditGetSelection(Handle, SelectionStart, SelectionLength);

      NewText := TheText;
      if SelectionLength > 0 then
        begin

          NewSelectionLength := SelectionLength;

          Delete(NewText, SelectionStart, NewSelectionLength);
          if Pcre.MatchStr(NewText) < 0 then
            begin

              Dec(NewSelectionLength);
              while NewSelectionLength > 0 do
                begin
                  Insert(TheText[SelectionStart + NewSelectionLength], NewText, SelectionStart);
                  if Pcre.MatchStr(NewText) >= 0 then Break;
                  Dec(NewSelectionLength);
                end;
            end;

          Insert(Key, NewText, SelectionStart);
          if Pcre.MatchStr(NewText) >= 0 then
            begin

              Dec(SelectionStart);
              EditSetSelection(Handle, SelectionStart, NewSelectionLength);

              Exit;
            end;
        end;

      NewText := TheText;
      Insert(Key, NewText, SelectionStart);
      if Pcre.MatchStr(NewText) >= 0 then
        begin
          Dec(SelectionStart);
          EditSetSelection(Handle, SelectionStart, 0);
          Exit;
        end;

      TextLength := Length(TheText) + 1;

      i := SelectionStart;
      while i <= TextLength do
        begin
          NewText := TheText;
          Insert(Key, NewText, i);
          if Pcre.MatchStr(NewText) >= 0 then
            begin

              EditSetSelection(Handle, i - 1, 0);
              Exit;
            end;
          Inc(i);
        end;

      i := SelectionStart;
      while i < TextLength do
        begin
          NewText := TheText;
          NewText[i] := Key;
          if Pcre.MatchStr(NewText) >= 0 then
            begin
              Dec(i);
              EditSetSelection(Handle, i, 1);

              Exit;
            end;
          Inc(i);
        end;

    end;
  end;

  ZeroKey:
  Key := #0;
end;

function PcreControl_WM_CLEAR(const Handle: HWND; const Pcre: TDIPcre): Boolean;
label
  DoInherited;
var
  TheText: AnsiString;
  NewText: AnsiString;
  SelectionStart: Cardinal;
  SelectionLength: Cardinal;
begin
  if (Handle = 0) or (Pcre = nil) then goto DoInherited;

  EditGetSelection(Handle, SelectionStart, SelectionLength);
  if SelectionLength = 0 then goto DoInherited;

  TheText := EditGetText(Handle);
  NewText := TheText;

  Delete(NewText, SelectionStart, SelectionLength);
  if Pcre.MatchStr(NewText) >= 0 then goto DoInherited;

  Dec(SelectionLength);
  while SelectionLength > 0 do
    begin
      Insert(TheText[SelectionStart + SelectionLength], NewText, SelectionStart);
      if Pcre.MatchStr(NewText) >= 0 then
        begin

          EditSetSelection(Handle, SelectionStart - 1, SelectionLength);
          goto DoInherited;
        end;
      Dec(SelectionLength);
    end;

  Result := True;
  Exit;

  DoInherited:
  Result := False;
end;

procedure TDICustomPcreEdit.Clear;
begin
  if (FPcre = nil) or (FPcre.MatchStr('') >= 0) then inherited;
end;

procedure TDICustomPcreEdit.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then SelectAll;
  inherited;
end;

procedure TDICustomPcreEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TAlignment] of Word = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);

  with Params do
    if Alignment = taLeftJustify then
      Style := Style and not ES_MULTILINE
    else
      Style := Style or ES_MULTILINE or Alignments[Alignment];
end;

procedure TDICustomPcreEdit.Keydown(var Key: Word; Shift: TShiftState);
begin
  inherited Keydown(Key, Shift);
  PcreControl_KeyDown(Handle, FPcre, Key, Shift);
end;

procedure TDICustomPcreEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if Key <> #13 then
    PcreControl_KeyPress(Handle, FPcre, Key)
  else
    Key := #0;
end;

{$IFNDEF DI_No_Pcre_Component}
procedure TDICustomPcreEdit.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FPcre) then FPcre := nil;
end;
{$ENDIF}

procedure TDICustomPcreEdit.SetAlignment(const Value: TAlignment);
begin
  if FAlignment = Value then Exit;
  FAlignment := Value;
  RecreateWnd;
end;

procedure TDICustomPcreEdit.SetPcre(const Value: TDIPcre);
begin
  if FPcre = Value then Exit;
  {$IFNDEF DI_No_Pcre_Component}{$IFDEF DELPHI_5_UP}
  if FPcre <> nil then FPcre.RemoveFreeNotification(Self);
  {$ENDIF}{$ENDIF}

  FPcre := Value;
  {$IFNDEF DI_No_Pcre_Component}
  if Value <> nil then Value.FreeNotification(Self);
  {$ENDIF}
end;

procedure TDICustomPcreEdit.SetTextAsInteger(const AValue: Integer);
begin
  Text := IntToStr(AValue);
end;

procedure TDICustomPcreEdit.WMClear(var Message: TWMClear);
begin
  if not PcreControl_WM_CLEAR(Handle, FPcre) then
    inherited;
end;

{$IFNDEF DefaultContextMenu}
procedure TDICustomPcreEdit.WMContextMenu(var Message: TWMContextMenu);
begin

end;
{$ENDIF}

procedure TDICustomPcreEdit.WMCut(var Message: TWMCut);
begin
  if FPcre = nil then inherited;
end;

procedure TDICustomPcreEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result and not DLGC_WANTALLKEYS;
end;

procedure TDICustomPcreEdit.WMPaste(var Message: TWMPaste);
begin
  if FPcre = nil then
    inherited;
end;

procedure TDICustomPcreEdit.WMSetTExt(var Message: TWMSetText);
begin
  if (FPcre = nil) or (FPcre.MatchStr(Message.Text) >= 0) then
    inherited;
end;

{$IFDEF DELPHI_6_UP}
constructor TDICustomPcreComboBox.Create(Owner: TComponent);
begin
  inherited;
  AutoComplete := False;
end;
{$ENDIF}

procedure TDICustomPcreComboBox.ComboWndProc(var Message: TMessage; ComboWnd: HWND; ComboProc: Pointer);
begin
  if ComboWnd = EditHandle then
    case Message.Msg of
      WM_CLEAR:
        begin
          if PcreControl_WM_CLEAR(ComboWnd, FPcre) then Exit;
        end;

      {$IFNDEF DefaultContextMenu}WM_CONTEXTMENU, {$ENDIF}WM_CUT, WM_PASTE:
        begin
          Exit;
        end;
    end;
  inherited;
end;

procedure TDICustomPcreComboBox.Keydown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  PcreControl_KeyDown(EditHandle, FPcre, Key, Shift);
end;

procedure TDICustomPcreComboBox.KeyPress(var Key: Char);
begin
  inherited;
  PcreControl_KeyPress(EditHandle, FPcre, Key);
end;

{$IFNDEF DI_No_Pcre_Component}
procedure TDICustomPcreComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FPcre) then
    FPcre := nil;
end;
{$ENDIF}

procedure TDICustomPcreComboBox.SetPcre(const Value: TDIPcre);
begin
  if FPcre = Value then Exit;
  {$IFNDEF DI_No_Pcre_Component}{$IFDEF DELPHI_5_UP}
  if FPcre <> nil then FPcre.RemoveFreeNotification(Self);
  {$ENDIF}{$ENDIF}
  FPcre := Value;
  {$IFNDEF DI_No_Pcre_Component}
  if Value <> nil then Value.FreeNotification(Self);
  {$ENDIF}
end;

procedure TDICustomPcreComboBox.WMSetTExt(var Message: TWMSetText);
begin
  if (FPcre = nil) or (FPcre.MatchStr(Message.Text) >= 0) then
    inherited;
end;

end.

