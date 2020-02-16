{***************************************************************
 *
 * Unit Name: OptKeyboard
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptKeyboard;  //Unit

interface
uses dcSystem,dcmemo,dcstring,windows,classes,dccommon;

implementation

Procedure InitStandardKeys(Memo : TCustomDCMemo);
begin
  with Memo.GetSource, Memo, Memo.Keys do
  begin
    // Standard cut-copy-paste

    AddSimpleKey(VK_DELETE, [ssShift], CutToClipboard);
    AddSimpleKey(VK_DELETE, [ssCtrl], DeleteBlock);
    AddSimpleKey(VK_INSERT, [ssShift], PasteFromClipboard);
    AddSimpleKey(VK_INSERT, [ssCtrl], CopyToClipboard);

    //Navigation
    AddAllKey(VK_UP, [], MemoCursorUp);
    AddAllKey(VK_DOWN, [], MemoCursorDown);
    AddAllKey(VK_LEFT, [], MemoCursorLeft);
    AddAllKey(VK_RIGHT, [], MemoCursorRight);
    AddAllKey(VK_PRIOR, [], PageUp);
    AddAllKey(VK_NEXT, [], PageDown);
    AddSimpleKey(VK_INSERT, [], ToggleInsMode);

    AddSimpleKey(VK_DELETE, [], DeleteCharRight);
    AddSimpleKey(VK_BACK, [], DeleteCharLeft);

    AddSimpleKey(VK_RETURN, [ssShift], PressEnter);
    AddSimpleKey(VK_RETURN, [], PressEnter);
    AddSimpleKey(VK_ESCAPE, [], ProcessEscape);
    AddSimpleKey(VK_TAB, [], PressTab);
    AddSimpleKey(VK_TAB, [ssShift], PressShiftTab);
    AddSimpleKey(VK_LEFT, [ssCtrl], JumpWordLeft);
    AddSimpleKey(VK_RIGHT, [ssCtrl], JumpWordRight);

    AddAllKey(VK_HOME, [ssCtrl], JumpToFileBegin);
    AddAllKey(VK_END, [ssCtrl], JumpToFileEnd);
    AddAllKey(VK_PRIOR, [ssCtrl], JumpToScreenTop);
    AddAllKey(VK_NEXT, [ssCtrl], JumpToScreenBottom);
    AddSimpleKey(VK_DOWN, [ssCtrl], ScrollDown);
    AddSimpleKey(VK_UP, [ssCtrl], ScrollUp);

    AddAllKey(VK_HOME, [], MemoJumpToLineBegin);
    AddAllKey(VK_END, [], MemoJumpToLineEnd);

    //Block Layout

    AddSimpleKey(VK_DOWN, [ssShift], MemoMarkDown);
    AddSimpleKey(VK_UP, [ssShift], MemoMarkUp);
    AddSimpleKey(VK_LEFT, [ssShift], MemoMarkLeft);
    AddSimpleKey(VK_RIGHT, [ssShift], MarkRight);
    AddSimpleKey(VK_HOME, [ssShift], MemoMarkToLineBegin);
    AddSimpleKey(VK_END, [ssShift], MemoMarkToLineEnd);
    AddSimpleKey(VK_PRIOR, [ssShift], MarkPageUp);
    AddSimpleKey(VK_NEXT, [ssShift], MarkPageDown);

    AddSimpleKey(VK_PRIOR, ssCShift, MarkToTop);
    AddSimpleKey(VK_NEXT, ssCShift, MarkToBottom);
    AddSimpleKey(VK_HOME, ssCShift, MarkToFileBegin);
    AddSimpleKey(VK_END, ssCShift, MarkToFileEnd);
    AddSimpleKey(VK_LEFT, ssCShift, MarkWordLeft);
    AddSimpleKey(VK_RIGHT, ssCShift, MarkWordRight);

    AddSimpleKey(VK_DOWN, ssAShift, MarkColDown);
    AddSimpleKey(VK_UP, ssAShift, MarkColUp);
    AddSimpleKey(VK_LEFT, ssAShift, MarkColLeft);
    AddSimpleKey(VK_RIGHT, ssAShift, MarkColRight);
    AddSimpleKey(VK_HOME, ssAShift, MarkColToLineBegin);
    AddSimpleKey(VK_END, ssAShift, MarkColToLineEnd);
    AddSimpleKey(VK_PRIOR, ssAShift, MarkColPageUp);
    AddSimpleKey(VK_NEXT, ssAShift, MarkColPageDown);

    AddSimpleKey(VK_HOME, ssCAShift, MarkColToTop);
    AddSimpleKey(VK_END, ssCAShift, MarkColToBottom);
    AddSimpleKey(VK_PRIOR, ssCAShift, MarkColToFileBegin);
    AddSimpleKey(VK_NEXT, ssCAShift, MarkColToFileEnd);
    AddSimpleKey(VK_LEFT, ssCAShift, MarkColWordLeft);
    AddSimpleKey(VK_RIGHT, ssCAShift, MarkColWordRight);


    // Bookmarks

{    AddSimpleKey(Key_0, [ssCtrl], GoToBookMark0);
    AddSimpleKey(Key_1, [ssCtrl], GoToBookMark1);
    AddSimpleKey(Key_2, [ssCtrl], GoToBookMark2);
    AddSimpleKey(Key_3, [ssCtrl], GoToBookMark3);
    AddSimpleKey(Key_4, [ssCtrl], GoToBookMark4);
    AddSimpleKey(Key_5, [ssCtrl], GoToBookMark5);
    AddSimpleKey(Key_6, [ssCtrl], GoToBookMark6);
    AddSimpleKey(Key_7, [ssCtrl], GoToBookMark7);
    AddSimpleKey(Key_8, [ssCtrl], GoToBookMark8);
    AddSimpleKey(Key_9, [ssCtrl], GoToBookMark9);
    AddSimpleKey(Key_0, [ssShift, ssCtrl], ToggleBookMark0);
    AddSimpleKey(Key_1, [ssShift, ssCtrl], ToggleBookMark1);
    AddSimpleKey(Key_2, [ssShift, ssCtrl], ToggleBookMark2);
    AddSimpleKey(Key_3, [ssShift, ssCtrl], ToggleBookMark3);
    AddSimpleKey(Key_4, [ssShift, ssCtrl], ToggleBookMark4);
    AddSimpleKey(Key_5, [ssShift, ssCtrl], ToggleBookMark5);
    AddSimpleKey(Key_6, [ssShift, ssCtrl], ToggleBookMark6);
    AddSimpleKey(Key_7, [ssShift, ssCtrl], ToggleBookMark7);
    AddSimpleKey(Key_8, [ssShift, ssCtrl], ToggleBookMark8);
    AddSimpleKey(Key_9, [ssShift, ssCtrl], ToggleBookMark9);}

{    AddKey(Key_K, [ssCtrl], nil, 0, sCtrlK);
    AddKey(Key_Q, [ssCtrl], nil, 0, sCtrlQ);
    AddKey(Key_0, [ssCtrl], ToggleBookMark0, sCtrlk, 0);
    AddKey(Key_1, [ssCtrl], ToggleBookMark1, sCtrlk, 0);
    AddKey(Key_2, [ssCtrl], ToggleBookMark2, sCtrlk, 0);
    AddKey(Key_3, [ssCtrl], ToggleBookMark3, sCtrlk, 0);
    AddKey(Key_4, [ssCtrl], ToggleBookMark4, sCtrlk, 0);
    AddKey(Key_5, [ssCtrl], ToggleBookMark5, sCtrlk, 0);
    AddKey(Key_6, [ssCtrl], ToggleBookMark6, sCtrlk, 0);
    AddKey(Key_7, [ssCtrl], ToggleBookMark7, sCtrlk, 0);
    AddKey(Key_8, [ssCtrl], ToggleBookMark8, sCtrlk, 0);
    AddKey(Key_9, [ssCtrl], ToggleBookMark9, sCtrlk, 0);

    AddKey(Key_0, [], ToggleBookMark0, sCtrlk, 0);
    AddKey(Key_1, [], ToggleBookMark1, sCtrlk, 0);
    AddKey(Key_2, [], ToggleBookMark2, sCtrlk, 0);
    AddKey(Key_3, [], ToggleBookMark3, sCtrlk, 0);
    AddKey(Key_4, [], ToggleBookMark4, sCtrlk, 0);
    AddKey(Key_5, [], ToggleBookMark5, sCtrlk, 0);
    AddKey(Key_6, [], ToggleBookMark6, sCtrlk, 0);
    AddKey(Key_7, [], ToggleBookMark7, sCtrlk, 0);
    AddKey(Key_8, [], ToggleBookMark8, sCtrlk, 0);
    AddKey(Key_9, [], ToggleBookMark9, sCtrlk, 0);

    AddKey(Key_0, [], GoToBookMark0, sCtrlQ, 0);
    AddKey(Key_1, [], GoToBookMark1, sCtrlQ, 0);
    AddKey(Key_2, [], GoToBookMark2, sCtrlQ, 0);
    AddKey(Key_3, [], GoToBookMark3, sCtrlQ, 0);
    AddKey(Key_4, [], GoToBookMark4, sCtrlQ, 0);
    AddKey(Key_5, [], GoToBookMark5, sCtrlQ, 0);
    AddKey(Key_6, [], GoToBookMark6, sCtrlQ, 0);
    AddKey(Key_7, [], GoToBookMark7, sCtrlQ, 0);
    AddKey(Key_8, [], GoToBookMark8, sCtrlQ, 0);
    AddKey(Key_9, [], GoToBookMark9, sCtrlQ, 0);

    AddKey(Key_0, ssCShift, ToggleBookMark0, sCtrlQ, 0);
    AddKey(Key_1, ssCShift, ToggleBookMark1, sCtrlQ, 0);
    AddKey(Key_2, ssCShift, ToggleBookMark2, sCtrlQ, 0);
    AddKey(Key_3, ssCShift, ToggleBookMark3, sCtrlQ, 0);
    AddKey(Key_4, ssCShift, ToggleBookMark4, sCtrlQ, 0);
    AddKey(Key_5, ssCShift, ToggleBookMark5, sCtrlQ, 0);
    AddKey(Key_6, ssCShift, ToggleBookMark6, sCtrlQ, 0);
    AddKey(Key_7, ssCShift, ToggleBookMark7, sCtrlQ, 0);
    AddKey(Key_8, ssCShift, ToggleBookMark8, sCtrlQ, 0);
    AddKey(Key_9, ssCShift, ToggleBookMark9, sCtrlQ, 0);

    AddKey(Key_0, [ssCtrl], GoToBookMark0, sCtrlQ, 0);
    AddKey(Key_1, [ssCtrl], GoToBookMark1, sCtrlQ, 0);
    AddKey(Key_2, [ssCtrl], GoToBookMark2, sCtrlQ, 0);
    AddKey(Key_3, [ssCtrl], GoToBookMark3, sCtrlQ, 0);
    AddKey(Key_4, [ssCtrl], GoToBookMark4, sCtrlQ, 0);
    AddKey(Key_5, [ssCtrl], GoToBookMark5, sCtrlQ, 0);
    AddKey(Key_6, [ssCtrl], GoToBookMark6, sCtrlQ, 0);
    AddKey(Key_7, [ssCtrl], GoToBookMark7, sCtrlQ, 0);
    AddKey(Key_8, [ssCtrl], GoToBookMark8, sCtrlQ, 0);
    AddKey(Key_9, [ssCtrl], GoToBookMark9, sCtrlQ, 0);}

  end;
end;

Procedure InitOptiExKeyboard(instance : TObject);
var
  Memo : TCustomDCMemo;
begin
  Memo := TCustomDCMemo(Instance);
  with Memo.GetSource, Memo, Memo.Keys do
  begin
    AddSimpleKey(Key_A, [ssCtrl], SelectAll);
    AddKey(Key_G, [ssCtrl], PromptedGotoLine, sCtrlO, 0);

    AddSimpleKey(VK_F3, [], KeyFindNext);
    AddSimpleKey(Key_F, [ssCtrl], ShowSearchDialog);
    AddSimpleKey(Key_R, [ssCtrl], ShowReplaceDialog);

    AddSimpleKey(Key_X, [ssCtrl], CutToClipboard);
    AddSimpleKey(Key_V, [ssCtrl], PasteFromClipboard);
    AddSimpleKey(Key_C, [ssCtrl], CopyToClipboard);

    AddSimpleKey(Key_Z, [ssCtrl], Undo);
    AddSimpleKey(Key_Y, [ssCtrl], Redo);
    AddSimpleKey(VK_BACK, [ssAlt], Undo);
    AddSimpleKey(VK_BACK, [ssAlt, ssShift], Redo);

  end;
  initStandardKeys(memo);

end;


procedure InitOptiKeyboard(Instance : TObject);
var
  Memo : TCustomDCMemo;
begin
  Memo := TCustomDCMemo(Instance);
  initStandardKeys(memo);
end;

initialization
 RegisterKeyboardInitProc(TCustomDCMemo,'Opti',InitOptiKeyboard);
 RegisterKeyboardInitProc(TCustomDCMemo,'OptiEx',InitOptiExKeyboard);
end.