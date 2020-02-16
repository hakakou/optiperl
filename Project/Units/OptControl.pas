{***************************************************************
 *
 * Unit Name: OptControl
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptControl;   //Unit

interface
uses sysutils,windows,stdctrls,Forms,dcMemo,HakaGeneral,controls,Grids,
     VirtualTrees,clipbrd,messages,BigWebFrm,HKDebug,ActnList,classes;

type
 TEditActions = (eaCut,eaCopy,eaPaste,eaSelectAll,edDelete,eaUndo,eaRedo);

 TEditKinds = Record
  Control : TWinControlClass;
  Allowed : Set of TEditActions;
 end;

const
 EditKinds : array[0..1] of TEditKinds = (
 (control : TCustomEdit;
  Allowed : [eaCut,eaCopy,eaPaste,eaSelectAll,eaUndo,edDelete];
 ),
 (control : TDCMemo;
  Allowed : [eaCut,eaCopy,eaPaste,edDelete,eaSelectAll,eaUndo,eaRedo];
 )
 );

type
 TGeneralEdit = Class
 public
  Actions : Array[TEditActions] of TCustomAction;

  Procedure Cut(Sender: TObject);
  procedure Copy(Sender: TObject);
  Procedure Paste(Sender: TObject);
  Procedure SelectAll(Sender: TObject);
  Procedure Delete(Sender: TObject);
  Procedure Undo(Sender: TObject);
  Procedure Redo(Sender: TObject);

  procedure CanCopy(sender: TObject);
  procedure CanSelectAll(sender: TObject);
  procedure CanPaste(sender: TObject);
  procedure CanCut(sender: TObject);
  procedure CanDelete(sender: TObject);
  procedure CanUndo(sender: TObject);
  procedure CanRedo(sender: TObject);

 public
  MainMemo,Memo : TDCMemo;
  LastTime : Cardinal;
  Control,LastControl : TWinControl;
  Procedure initActions;
  Function IsMainActive : Boolean;
  Function IsMemoActive : Boolean;
  Procedure ActiveWindowClosed;
 private
  procedure OnActiveControlChange(Sender: TObject);
 end;

var
 ActiveEdit : TGeneralEdit;

implementation

type
 TTempStringGrid = class(TStringGrid);


Function TGeneralEdit.IsMemoActive : Boolean;
begin
 result:=assigned(Memo);
end;

Function TGeneralEdit.IsMainActive : Boolean;
begin
 Result:= memo = MainMemo;
end;

procedure TGeneralEdit.OnActiveControlChange(Sender: TObject);
var
 FormExists : Boolean;
 Form : TCustomForm;
begin
 LastControl:=Control;
 Control:=Screen.ActiveControl;
 LastTime:=GetTickCount;

 if (Control is TDCMemo)
  then Memo:=TDCMemo(control)
  else memo:=nil;

 if (MainWebForm.WebFocused) or
    (PodWebForm.WebFocused) or
    (control is TVTEdit) then
 begin
  memo:=nil;
  Control:=nil;
 end;
end;

procedure TGeneralEdit.ActiveWindowClosed;
begin
 Memo:=nil;
 Control:=nil;
end;

procedure TGeneralEdit.CanCopy(sender: TObject);
begin
 try
  TAction(sender).enabled:=
  ((control is TDCMemo) and (not TDCMemo(Control).MemoSource.IsSelectionEmpty)) or
  ((control is TCustomEdit) and (TCustomEdit(Control).SelLength>0)) or
  ((control is TCustomComboBox) and (TCustomComboBox(Control).SelLength>0)) or
  ((control is TCustomListBox) and (TCustomListBox(Control).ItemIndex>=0)) or
  (control is TStringGrid);
 except
  control:=nil;
 end;
end;

procedure TGeneralEdit.CanCut(sender: TObject);
begin
 try
  TAction(Sender).Enabled:=
  ((control is TDCMemo) and (not TDCMemo(Control).memosource.isselectionempty) and (not TDCMemo(Control).ReadOnly)) or
  ((control is TCustomEdit) and (TCustomEdit(Control).SelLength>0)) or
  ((control is TCustomComboBox) and (TCustomComboBox(Control).SelLength>0)) or
  (control is TStringGrid);
 except
  control:=nil;
 end;
end;

procedure TGeneralEdit.CanDelete(sender: TObject);
begin
 try
  TAction(Sender).Enabled:=
  ((control is TDCMemo) and (not TDCMemo(Control).memosource.isselectionempty)) and (not TDCMemo(Control).ReadOnly) or
  ((control is TCustomEdit) and (TCustomEdit(Control).SelLength>0)) or
  ((control is TCustomComboBox) and (TCustomComboBox(Control).SelLength>0)) or
  (control is TStringGrid);
 except
  control:=nil;
 end;
end;

procedure TGeneralEdit.CanPaste(sender: TObject);
begin
 try
  TAction(Sender).Enabled:=
   ((control is TDCMemo) and (TDCMemo(Control).CanPaste)) or
   (control is TCustomEdit) or
   (control is TCustomComboBox) or
   (control is TStringGrid);
 except
  control:=nil;
 end;
end;

procedure TGeneralEdit.CanRedo(sender: TObject);
begin
 try
  TAction(Sender).Enabled:=
  (control is TDCMemo) and (TDCMemo(Control).MemoSource.RedoAvailable);
 except
  control:=nil;
 end;
end;

procedure TGeneralEdit.CanSelectAll(sender: TObject);
begin
 try
  TAction(Sender).Enabled:=
   (control is TDCMemo) or
   (control is TCustomEdit) or
   (control is TCustomComboBox);
 except
  control:=nil;
 end;
end;

procedure TGeneralEdit.CanUndo(sender: TObject);
begin
 try
  TAction(Sender).Enabled:=
  ((control is TDCMemo) and (TDCMemo(Control).MemoSource.UndoAvailable)) or
   (control is TCustomEdit) or
   (control is TStringGrid);
 except
  control:=nil;
 end;
end;

procedure TGeneralEdit.Copy(Sender: TObject);
begin
 if control is TCustomEdit then
  TCustomEdit(Control).CopyToClipboard
 else
 if control is TDCMemo then
  TDCMemo(Control).CopyToClipboard
 else
 if control is TCustomComboBox then
  clipboard.AsText:=TCustomComboBox(control).SelText
 else
 if control is TCustomListBox then
  with TCustomListBox(control) do
   clipboard.AsText:=Items[ItemIndex]
 else
 if control is TStringGrid then
  TTempStringGrid(control).InplaceEditor.CopyToClipboard;
end;

procedure TGeneralEdit.Cut(Sender: TObject);
begin
 if control is TCustomEdit then
  TCustomEdit(Control).CutToClipboard
 else
 if control is TDCMemo then
  TDCMemo(Control).CutToClipboard
 else
 if control is TCustomComboBox then
 begin
  clipboard.AsText:=TCustomComboBox(control).SelText;
  TCustomComboBox(control).SelText:=''
 end
 else
 if control is TStringGrid then
  TTempStringGrid(control).InplaceEditor.CutToClipboard;
end;

procedure TGeneralEdit.Delete(Sender: TObject);
begin
 if control is TCustomEdit then
  TCustomEdit(Control).ClearSelection
 else
 if control is TDCMemo then
  TDCMemo(Control).MemoSource.DeleteCharRight
 else
 if control is TCustomComboBox then
  TCustomComboBox(control).SelText:=''
 else
 if control is TStringGrid then
  TTempStringGrid(control).InplaceEditor.ClearSelection;
end;

procedure TGeneralEdit.Paste(Sender: TObject);
begin
 if control is TCustomEdit then
  TCustomEdit(Control).PasteFromClipboard
 else
 if control is TDCMemo then
  TDCMemo(Control).PasteFromClipboard
 else
 if control is TCustomComboBox then
  TCustomComboBox(control).SelText:=clipboard.AsText
 else
 if control is TStringGrid then
  TTempStringGrid(control).InplaceEditor.PasteFromClipboard;
end;

procedure TGeneralEdit.Redo(Sender: TObject);
begin
 if control is TDCMemo then
  TDCMemo(Control).MemoSource.Redo;
end;

procedure TGeneralEdit.SelectAll(Sender: TObject);
begin
 if control is TCustomEdit then
  TCustomEdit(Control).SelectAll
 else
 if control is TDCMemo then
  TDCMemo(Control).memosource.SelectAll
 else
 if control is TCustomComboBox then
  TCustomComboBox(control).SelectAll;
end;

procedure TGeneralEdit.Undo(Sender: TObject);
begin
 if control is TCustomEdit then
  TCustomEdit(Control).Undo
 else
 if control is TDCMemo then
  TDCMemo(Control).MemoSource.Undo
 else
 if control is TStringGrid then
  TTempStringGrid(control).InplaceEditor.Undo;
end;

procedure TGeneralEdit.initActions;
begin
 Actions[eaCut].OnExecute:=Cut;
 Actions[eaCopy].OnExecute:=Copy;
 Actions[eaPaste].OnExecute:=Paste;
 Actions[eaSelectAll].OnExecute:=SelectAll;
 Actions[edDelete].OnExecute:=Delete;
 Actions[eaUndo].OnExecute:=Undo;
 Actions[eaRedo].OnExecute:=Redo;

 Actions[eaCut].Onupdate:=CanCut;
 Actions[eaCopy].Onupdate:=CanCopy;
 Actions[eaPaste].Onupdate:=CanPaste;
 Actions[eaSelectAll].Onupdate:=CanSelectAll;
 Actions[edDelete].Onupdate:=CanDelete;
 Actions[eaUndo].Onupdate:=CanUndo;
 Actions[eaRedo].Onupdate:=CanRedo;

 Screen.OnActiveControlChange:=OnActiveControlChange;
// screen.OnActiveFormChange:=OnActiveFormChange;
end;

initialization
 HKLog('OptControl Start');
 ActiveEdit:=TGeneralEdit.Create;
 HKLog;
finalization
 ActiveEdit.Free;
end.