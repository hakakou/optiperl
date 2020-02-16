{***************************************************************
 *
 * Unit Name: AJBSpeller
 * Purpose  : Interface with Word spellcheck
 * Author   : Andrew Baylis
 * Date     : 4/07/2001
 * History  : Version 1 - bug in Word speller when options clicked
              Version 2 - Uses Filemapping to provide shared memory
                          This, in conjunction with a message hook
                          allows the pop-up spell check dialog to be
                          detected and the caption changed.
              Version 2.1-Property UserCancelled to indicate if the
                          user has pressed the Cancel key in the
                          Word Dialog box.
              Version 2.2 - Removed message hook due to NT & XP crashes
                            Used thread timer approach instead
              Version 2.3 - Property 'Language' added to specify proofing
                            Language. If set to LanguageNone, then
                            the default is used.
 *
 ****************************************************************}

unit AJBSpeller;

interface

uses
   Windows,variants,
   Messages,
   SysUtils,
   Classes,
   Graphics,
   Controls,
   Forms,
   Dialogs,
   ComObj, ActiveX, registry;

type

   TAJBWordTimer = class(TThread)
   private
      FCaption: string;
      FDelay: Integer;
      FDialogWndClass: string;
      FPopUpExists: Boolean;
      procedure SetDelay(Value: Integer);
   protected
      procedure Execute; override;
   public
      constructor Create(CreateSuspended: Boolean);
      procedure Resume;
      property Caption: string read FCaption write FCaption;
      property Delay: Integer read FDelay write SetDelay;
      property DialogWndClass: string read FDialogWndClass write FDialogWndClass;
   end;

   TSpellLanguage = Integer;

   TAJBSpell = class(TComponent)
   private
      FCancel: Boolean;
      FChangedText: string;
      FConnected: Boolean;
      FHandle: HWND;
      FNumChanges: Integer;
      FOleOn: Boolean;
      FSpellCaption: string;
      FTimer: TAJBWordTimer;
      FUseSpellCaption: Boolean;
      FWordApp, FRange, FADoc, FCustDics: OLEVariant;
      FWordDialogClass: string;
      FWordVersion: string;
      FLanguage: TSpellLanguage;
      function GetCheckGWS: Boolean;
      function GetGrammarErrors: Integer;
      function GetSpellChecked: Boolean;
      function GetSpellErrors: Integer;
      function GetUserCancel: Boolean;
      function GetVersion: string;
      function GetWordVersion: string;
      procedure SetCheckGWS(const Value: Boolean);
      procedure SetVersion(const Value: string);
      procedure SetLanguage(Value: TSpellLanguage);
   protected
      function Internal_checkGrammar: Boolean;
      function Internal_checkSpelling: Boolean;
      procedure StartTimer;
      procedure StopTimer;
   public
      function AddCustomDic(const FileName: string): Integer;
      function CheckClipboardGrammar: Boolean;
      function CheckClipboardSpell: Boolean;
      function CheckGrammar(const Text: string): Boolean;
      function CheckSpelling(const Text: string): Boolean;
      procedure ClearText;
      procedure Connect;
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
      procedure Disconnect;
      procedure RemoveCustomDic(const Name: string); overload;
      procedure RemoveCustomDic(const Index: Integer); overload;
      procedure ResetIgnoreAll;
      procedure SpellingOptions;
      property ChangedText: string read FChangedText;
      property CheckGrammarWithSpelling: Boolean read GetCheckGWS write SetCheckGWS;
      property Connected: Boolean read FConnected;
      property GrammarErrorCount: Integer read GetGrammarErrors;
      property NumChanges: Integer read FNumChanges;
      property SpellChecked: Boolean read GetSpellChecked;
      property SpellErrorCount: Integer read GetSpellErrors;
      property UserCancelled: Boolean read GetUserCancel write FCancel;
      property WordVersion: string read GetWordVersion;
   published
      property SpellCaption: string read FSpellCaption write FSpellCaption;
      property UseSpellCaption: Boolean read FUseSpellCaption write FUseSpellCaption;
      property Version: string read GetVersion write SetVersion;
      property Language: TSpellLanguage read FLanguage write SetLanguage;
   end;

   LangRecord = record
      LocalName: string;
      ID: Integer;
   end;

function IsWordPresent: Boolean;

const // Spelling Language
   AJBSpellLanguage: array[0..63] of LangRecord =
      ((LocalName: 'LanguageNone'; ID: $00000000),
      (LocalName: 'NoProofing '; ID: $00000400),
      (LocalName: 'Danish '; ID: $00000406),
      (LocalName: 'German '; ID: $00000407),
      (LocalName: 'SwissGerman '; ID: $00000807),
      (LocalName: 'EnglishAUS '; ID: $00000C09),
      (LocalName: 'EnglishUK '; ID: $00000809),
      (LocalName: 'EnglishUS '; ID: $00000409),
      (LocalName: 'EnglishCanadian '; ID: $00001009),
      (LocalName: 'EnglishNewZealand '; ID: $00001409),
      (LocalName: 'EnglishSouthAfrica '; ID: $00001C09),
      (LocalName: 'Spanish '; ID: $0000040A),
      (LocalName: 'French '; ID: $0000040C),
      (LocalName: 'FrenchCanadian '; ID: $00000C0C),
      (LocalName: 'Italian '; ID: $00000410),
      (LocalName: 'Dutch '; ID: $00000413),
      (LocalName: 'NorwegianBokmol '; ID: $00000414),
      (LocalName: 'NorwegianNynorsk '; ID: $00000814),
      (LocalName: 'BrazilianPortuguese '; ID: $00000416),
      (LocalName: 'Portuguese '; ID: $00000816),
      (LocalName: 'Finnish '; ID: $0000040B),
      (LocalName: 'Swedish '; ID: $0000041D),
      (LocalName: 'Catalan '; ID: $00000403),
      (LocalName: 'Greek '; ID: $00000408),
      (LocalName: 'Turkish '; ID: $0000041F),
      (LocalName: 'Russian '; ID: $00000419),
      (LocalName: 'Czech '; ID: $00000405),
      (LocalName: 'Hungarian '; ID: $0000040E),
      (LocalName: 'Polish '; ID: $00000415),
      (LocalName: 'Slovenian '; ID: $00000424),
      (LocalName: 'Basque '; ID: $0000042D),
      (LocalName: 'Malaysian '; ID: $0000043E),
      (LocalName: 'Japanese '; ID: $00000411),
      (LocalName: 'Korean '; ID: $00000412),
      (LocalName: 'SimplifiedChinese '; ID: $00000804),
      (LocalName: 'TraditionalChinese '; ID: $00000404),
      (LocalName: 'SwissFrench '; ID: $0000100C),
      (LocalName: 'Sesotho '; ID: $00000430),
      (LocalName: 'Tsonga '; ID: $00000431),
      (LocalName: 'Tswana '; ID: $00000432),
      (LocalName: 'Venda '; ID: $00000433),
      (LocalName: 'Xhosa '; ID: $00000434),
      (LocalName: 'Zulu '; ID: $00000435),
      (LocalName: 'Afrikaans '; ID: $00000436),
      (LocalName: 'Arabic '; ID: $00000401),
      (LocalName: 'Hebrew '; ID: $0000040D),
      (LocalName: 'Slovak '; ID: $0000041B),
      (LocalName: 'Farsi '; ID: $00000429),
      (LocalName: 'Romanian '; ID: $00000418),
      (LocalName: 'Croatian '; ID: $0000041A),
      (LocalName: 'Ukrainian '; ID: $00000422),
      (LocalName: 'Byelorussian '; ID: $00000423),
      (LocalName: 'Estonian '; ID: $00000425),
      (LocalName: 'Latvian '; ID: $00000426),
      (LocalName: 'Macedonian '; ID: $0000042F),
      (LocalName: 'SerbianLatin '; ID: $0000081A),
      (LocalName: 'SerbianCyrillic '; ID: $00000C1A),
      (LocalName: 'Icelandic '; ID: $0000040F),
      (LocalName: 'BelgianFrench '; ID: $0000080C),
      (LocalName: 'BelgianDutch '; ID: $00000813),
      (LocalName: 'Bulgarian '; ID: $00000402),
      (LocalName: 'MexicanSpanish '; ID: $0000080A),
      (LocalName: 'SpanishModernSort '; ID: $00000C0A),
      (LocalName: 'SwissItalian '; ID: $00000810));

implementation

// these constants used to identify the window class of Word's dialog box
const
  //Constants for MS Word
   MSDialogWndClass2000 = 'bosa_sdm_Microsoft Word 9.0';
   MSDialogWndClass97 = 'bosa_sdm_Microsoft Word 8.0';
   MSDialogWndClassXP = 'bosa_sdm_Microsoft Word 10.0';
   MSDialogWndClass = 'bosa_sdm_Microsoft Word ';
   MSWordWndClass = 'OpusApp';

  //Component Version
   AJBSpellerVersion = 'Ver 2.3';

function IsWordPresent: Boolean;
var
   reg: TRegistry;
begin
   reg := TRegistry.Create;
   try
      reg.RootKey := HKEY_CLASSES_ROOT;
      Result := reg.KeyExists('Word.Application');
   finally
      reg.Free;
   end;
end;

{ TAJBSpell }

function TAJBSpell.GetCheckGWS: Boolean;
begin
   Result := False;
   if FConnected then Result := FWordApp.Options.CheckGrammarWithSpelling;
end;

function TAJBSpell.GetGrammarErrors: Integer;
begin
   if FConnected then
      Result := FRange.GrammaticalErrors.Count
   else
      Result := 0;
end;

function TAJBSpell.GetSpellChecked: Boolean;
// returns false if spelling has yet to be checked
begin
   Result := True;
   if FConnected then Result := not FRange.SpellingChecked;
end;

function TAJBSpell.GetSpellErrors: Integer;
begin
   if FConnected then
      Result := FRange.SpellingErrors.Count
   else
      Result := 0;
end;

function TAJBSpell.GetUserCancel: Boolean;
begin
   Result := FCancel;
end;

function TAJBSpell.GetVersion: string;
begin
   Result := AJBSpellerVersion;
end;

function TAJBSpell.GetWordVersion: string;
begin
   Result := FWordVersion;
end;

procedure TAJBSpell.SetCheckGWS(const Value: Boolean);
begin
   if FConnected then FWordApp.Options.CheckGrammarWithSpelling := Value;
end;

procedure TAJBSpell.SetVersion(const Value: string);
begin
     //Needed to make property appear in Object Inspector
end;

function TAJBSpell.Internal_checkGrammar: Boolean;
begin
   SetWindowPos(FHandle, HWND_TOPMOST, 0, 0, 0, 0,
      SWP_NOACTIVATE + SWP_HIDEWINDOW); // ensures dialogs appear in front
   FADoc.TrackRevisions := True; // note if changes are made
   FNumChanges := 0;

   FRange.GrammarChecked := False;
   if (FLanguage > 0) then // 0 means use the default setting
      FRange.LanguageID := AJBSpellLanguage[FLanguage].ID;

   StartTimer;
   OleCheck(FRange.CheckGrammar);
   StopTimer;

   FCancel := not FRange.GrammarChecked;
   FWordApp.Visible := False; // need to stop ActiveDocument appearing

   FNumChanges := FRange.Revisions.Count; // seems revisions counts the old word and the new one separately
   Result := (FRange.Revisions.Count > 0);
   if Result then FRange.Revisions.AcceptAll; // accept all changes

   FADoc.TrackRevisions := False; // don't track future changes
end;

function TAJBSpell.Internal_checkSpelling: Boolean;
begin
   SetWindowPos(FHandle, HWND_TOPMOST, 0, 0, 0, 0,
      SWP_NOACTIVATE + SWP_HIDEWINDOW); // ensures dialogs appear in front
   FADoc.TrackRevisions := True; // note if changes are made
   FNumChanges := 0;

   if (FLanguage > 0) then // 0 means use the default setting
      FRange.LanguageID := AJBSpellLanguage[FLanguage].ID;

   StartTimer;
   OleCheck(FADoc.CheckSpelling);
   StopTimer;

   FCancel := not FADoc.SpellingChecked;
   FWordApp.Visible := False; // need to stop ActiveDocument appearing

   FNumChanges := FRange.Revisions.Count; // seems revisions counts the old word and the new one separately
   Result := (FRange.Revisions.Count > 0);
   if Result then FRange.Revisions.AcceptAll; // accept all changes

   FADoc.TrackRevisions := False; // don't track future changes
end;

procedure TAJBSpell.StartTimer;
begin
   if FUseSpellCaption then
   begin
      FTimer.Caption := FSpellCaption;
      FTimer.Resume;
   end;
end;

procedure TAJBSpell.StopTimer;
begin
   FTimer.Suspend;
end;

function TAJBSpell.AddCustomDic(const FileName: string): Integer;
begin
   FCustDics.Add(FileName);
   Result := FCustDics.Count;
end;

function TAJBSpell.CheckClipboardGrammar: Boolean;
// returns true if changes were made. Corrected text is on
// the clipboard
begin
   Result := False;
   if not FConnected then Connect;
   if not FConnected then Exit; // if still not connected then no MS Word!

   if FConnected then
   begin
      FRange.Paste; // replace with new text to check
      Result := Internal_CheckGrammar;
      if Result then FRange.Copy;
   end;
end;

function TAJBSpell.CheckClipboardSpell: Boolean;
// returns true if changes were made. Corrected text is on
// the clipboard
begin
   Result := False;
   if not FConnected then Connect;
   if not FConnected then Exit; // if still not connected then no MS Word!
   if FConnected then
   begin
      FRange.Paste; // replace with new text to check
      Result := Internal_checkSpelling;
      if Result then FRange.Copy; // put onto clipboard
   end;
end;

function TAJBSpell.CheckGrammar(const Text: string): Boolean;
// returns true if changes were made and the corrected text is
// placed in the Text string
begin
   Result := False;
   if not FConnected then Connect;
   if not FConnected then Exit; // if still not connected then no MS Word!
   if FConnected then
   begin
      FChangedText := '';
      FRange.Text := Text; // replace with new text to check
      Result := Internal_CheckGrammar;
      if Result then FChangedText := FRange.Text;
   end;
end;

function TAJBSpell.CheckSpelling(const Text: string): Boolean;
// returns true if changes were made and the corrected text is
// placed in the Text string
begin
   Result := False;
   if not FConnected then Connect;
   if not FConnected then Exit; // if still not connected then no MS Word!
   if FConnected then
   begin
      FChangedText := '';
      FRange.Text := Text; // replace with new text to check
      Result := Internal_CheckSpelling;
      if Result then FChangedText := FRange.Text;
   end
   else
      Result := False;
end;

procedure TAJBSpell.ClearText;
begin
   if FConnected then FRange.Text := '';
end;

procedure TAJBSpell.Connect;
var
   s: string;
begin
   if FConnected then Exit; // don't create two instances
   try
      FWordApp := CreateOleObject('Word.Application');
      FConnected := True;
      FWordApp.Visible := False; // hides the application
      FWordApp.ScreenUpdating := False; // speed up winword's processing
      FWordApp.WindowState := $00000002; // minimise
      sleep(500);
      FADoc := FWordApp.Documents.Add(EmptyParam, False); // this will hold the text to be checked
      FRange := FADoc.Range;
      FRange.WholeStory; // makes FRange point to all text in document
      FCustDics := FWordApp.CustomDictionaries;
      FWordVersion := FWordApp.Version;
      s := FADoc.Name + ' - ' + FWordApp.Name;
      FHandle := FindWindow(MSWordWndClass, PChar(s)); // winword
      FWordDialogClass:=MSDialogWndClass+FWordVersion;

{      if FWordVersion[1] = '9' then
         FWordDialogClass := MSDialogWndClass2000
      else
         FWordDialogClass := MSDialogWndClass97;}

      FTimer := TAJBWordTimer.Create(True);
      FTimer.Delay := 50; // every 0.05 s
      FTimer.DialogWndClass := FWordDialogClass;
      FTimer.FreeOnTerminate := True;

   except
      FWordApp := Unassigned;
      FConnected := False;
      if Assigned(FTimer) then
      begin
         FTimer.Terminate;
         while FTimer.Suspended do
            FTimer.Resume;
      end;
      FTimer := nil;
      MessageDlg('Unable to initialise MS Word', mtError, [mbYes], 0);
   end;
end;

constructor TAJBSpell.Create(AOwner: TComponent);
var
   init: Integer;
begin
   inherited;
   FConnected := False;
   FCancel := False;
   FChangedText := '';
   init := CoInitialize(nil);
   if (init = S_OK) or (init = S_FALSE) then
      FOleOn := True
   else
      raise EOleSysError.CreateFmt('Error initialising COM library', []);

   FSpellCaption := '';
   FUseSpellCaption := False;
   FLanguage := 0;
end;

destructor TAJBSpell.Destroy;
begin
   Disconnect;
   if FOleOn then CoUninitialize;
   inherited;
end;

procedure TAJBSpell.Disconnect;
var
   savechanges: OleVariant;

begin
   if not VarIsEmpty(FWordApp) then
   begin
      savechanges := False;
      FWordApp.Quit(savechanges); // don't save changes
      FRange := Unassigned;
      FADoc := Unassigned;
      FWordApp := Unassigned;
      FCustDics := Unassigned;
      FConnected := False;
      if Assigned(FTimer) then
      begin
         FTimer.Terminate;
         while FTimer.Suspended do
            FTimer.Resume; // need this in case thread was never started
      end;
      FTimer := nil;
   end;
end;

procedure TAJBSpell.RemoveCustomDic(const Name: string);
var
   dic: OleVariant;
begin
   dic := FCustDics.Item(Name);
   if not VarIsEmpty(dic) then
      dic.Delete;
   dic := Unassigned;
end;

procedure TAJBSpell.RemoveCustomDic(const Index: Integer);
var
   dic: OleVariant;
begin
   dic := FCustDics.Item(Index);
   if not VarIsEmpty(dic) then
      dic.Delete;
   dic := Unassigned;
end;

procedure TAJBSpell.ResetIgnoreAll;
begin
   if FConnected then
   begin
      FRange.Text := ''; // ResetIgnoreAll performs an automatic spell check
      FWordApp.ResetIgnoreAll;
   end;
end;

procedure TAJBSpell.SpellingOptions;
begin
   BringWindowToTop(FHandle); // ensures that dialog opens on top
   FWordApp.dialogs.item($000000D3).show;
   FWordApp.Visible := False;
end;

procedure TAJBSpell.SetLanguage(Value: TSpellLanguage);
begin
   FLanguage := Value;
end;

{ TAJBWordTimer }

procedure TAJBWordTimer.SetDelay(Value: Integer);
begin
   if (Value > 0) then FDelay := Value;
end;

procedure TAJBWordTimer.Execute;
var
   h: HWND;
begin
   while not Terminated do
   begin
      sleep(FDelay); // use this as a rough timer
      if (FDialogWndClass <> '') then
      begin
         h := FindWindow(PChar(FDialogWndClass), nil);
         if (h <> 0) and (not FPopUpExists) then
         // only change caption if the window has just appeared
         begin
            SetWindowText(h, PChar(FCaption));
            FPopUpExists := True;
         end
         else
            FPopUpExists := False;
      end;
   end;
end;

constructor TAJBWordTimer.Create(CreateSuspended: Boolean);
begin
   FDelay := 100; // default delay (ms)
   inherited Create(CreateSuspended);
end;

procedure TAJBWordTimer.Resume;
begin
   FPopUpExists := False;
   inherited;
end;

end.

