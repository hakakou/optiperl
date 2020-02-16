{Author:	Poul Bak}
{Copyright © 1999-2001 : BakSoft-Denmark (Poul Bak). All rights reserved.}
{http://home11.inet.tele.dk/BakSoft/}
{Mailto: baksoft-denmark@dk2net.dk}
{}
{Component Version: 3.00.00.00}
{}
{PBOpenPreviewDialog and PBSavePreviewDialog are FREEWARE Open/SaveDialog-components for Delphi 2.0 and up.}
{}
{PBOpenPreviewDialog is OpenDialog with universal Preview (Preview of YOUR files).}
{Automatic localization (language) of the dialogs captions, title and hints without external files - detected at runtime - follows the Windows-language.}
{The main property is OnPreview where you can write code that displays YOUR file the way you want. Two propertys PreviewText (TRichEdit) and PreviewImage (TImage) makes it easy to preview any kind of file.}
{PBOpenPreviewDialog can display preview for 'bmp, ico, wmf, emf, txt, ini, inf, bat, log, pas, dpr, dpk, rtf and wav'-files without writing any code.}
{Users can click a 'Scale' or 'Wordwrap' checkbox to display or hide scrollboxes.}
{For registered filetypes that are not supported the filetype-descriptions are displayed.}
{A Show-Preview button makes it possible to show or hide previews.}
{Version 3.00.00.00 does not use the registry - Windows NT/2000 safe.}
unit PBPreview;

interface

uses
	Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
	ExtCtrls, StdCtrls, Buttons, ComCtrls, MMSystem, CommDlg, ShellAPI;

type
	TPBOpenPreviewDialog = class;

	// The OnPreview event type.
{Sender is normally the Dialog itself.}
{Ext is the extension of the file selected (3 letters like 'txt').}
	TPreviewNotify = procedure(Sender:TPBOpenPreviewDialog; Ext : string) of object;

{Author:	Poul Bak}
{Copyright © 1999-2001 : BakSoft-Denmark (Poul Bak). All rights reserved.}
{http://home11.inet.tele.dk/BakSoft/}
{Mailto: baksoft-denmark@dk2net.dk}
{}
{Component Version: 3.00.00.00}
{}
{PBOpenPreviewDialog and PBSavePreviewDialog are FREEWARE Open/SaveDialog-components for Delphi 3.0 and Delphi 4.0}
{}
{PBOpenPreviewDialog is OpenDialog with universal Preview (Preview of YOUR files).}
{Automatic localization (language) of the dialogs captions, title and hints without external files - detected at runtime - follows the Windows-language.}
{The main property is OnPreview where you can write code that displays YOUR file the way you want. Two propertys PreviewText (TRichEdit) and PreviewImage (TImage) makes it easy to preview any kind of file.}
{PBOpenPreviewDialog can display preview for 'bmp, ico, wmf, emf, txt, ini, inf, bat, log, pas, dpr, dpk, rtf and wav'-files without writing any code.}
{Users can click a 'Scale' or 'Wordwrap' checkbox to display or hide scrollboxes.}
{For registered filetypes that are not supported the filetype-descriptions are displayed.}
{A Show-Preview button makes it possible to show or hide previews.}
{Version 3.00.00.00 does not use the registry - Windows NT/2000 safe.}
	TPBOpenPreviewDialog = class(TOpenDialog)
	private
		{ Private declarations }
		FPanel2 : TPanel;
		FScrollBox : TScrollBox;
		FPreviewImage : TImage;
		FNoPreviewTexts, FPreviewCaptions, FScaleHints, FWordWrapHints : TStringlist;
		FShowPreviewButtonHints, FTitles : TStringlist;
		FOnPreview : TPreviewNotify;
		FPreviewCustomExt, FPreviewDefaultExt : TStringlist;
		FPreviewText : TRichEdit;
		FVersion, FLocale : string;
		FWordWrapButton, FShowPreviewButton : TSpeedButton;
		FShow, FWordWrapAndScale : Boolean;
		function LocaleText(List : TStringlist) : string;
		function StoreNoPreview : Boolean;
		function StoreCaptions : Boolean;
		function StoreScaleHints : Boolean;
		function StoreWrapHints : Boolean;
		function StorePreviewHints : Boolean;
		procedure FPreview;
		procedure SetPreviewCaptions(Value : TStringlist);
		procedure SetScaleHints(Value : TStringlist);
		procedure SetWordWrapHints(Value : TStringlist);
		procedure Dummy(Value: String);
		procedure SetCustomPreviewExt(Value : TStringlist);
		procedure ShowPreviewClick(Sender : TObject);
		procedure WordWrapClick(Sender : TObject);
		procedure SetShowPreviewButtonHints(Value : TStringlist);
		procedure SetNoPreviewTexts(Value : TStringlist);
		procedure SetTitles(Value : TStringlist);
		procedure SetShow(Value : Boolean);
		procedure SetWordWrapAndScale(Value : Boolean);
	protected
		{ Protected declarations }
		procedure DoClose; override;
		procedure DoSelectionChange; override;
		procedure DoShow; override;
	public
		{ Public declarations }
		constructor Create(AOwner: TComponent); override;
//		pro
		destructor Destroy; override;
		function Execute: Boolean; override;
{A list that contains the extensions that 'PBOpenPreviewDialog' can preview
without writing any code.}
{Supports 'bmp, ico, wmf, emf, txt, ini, inf, bat, log, pas, dpr, dpk, rtf and
wav'-files by default.}
{Override these by including the extensions, for which you write a (better)
 preview, in the 'CustomPreviewExtensions'. Then your code is used instead.}
 {(Of course the filetypes have to be included in 'Filter'-Property to be
 displayed in the dialog).}
{A Read Only property - just for information.}
		property DefaultPreviewExtensions : TStringlist read FPreviewDefaultExt;
{A TImage property that you can use to display any graphic in the preview-area.}
{Use PreviewImage.Canvas to draw directly in the area.}
{Use in the 'OnPreview'-procedure.}
{PreviewImage is filled with 'clWindow' before calling 'OnPreview'.}
{The width of the image is 185 pixels without scrollbars.}
{The Height is either 222, 220 or 194 pixels without scrollbars. If Options include
[ofShoeHelp] it's 222, if not [ofHideReadOnly] it's 220, else 194.}
{When 'PreviewImage' is shown, there is a 'Scale to fit'-button above.
Here the user can click to view the image scaled or with scrollbars.}
{'PreviewImage' is only displayed if 'PreviewText' is empty.}
		property PreviewImage : TImage read FPreviewImage Write FPreviewImage;
{A TRichEdit property that you can use to display any text in the preview-area.}
{Use in the 'OnPreview'-procedure.}
{'PreviewText' is cleared before calling 'OnPreview'.}
{Simply ADD any text-Lines you want.}
{The 'PreviewText' is displayed automatic if it contains any text. Otherwise
the 'PreviewImage' is shown.}
{When PreviewText is shown, there is a 'WordWrap'-button above.
Here the user can click to view the text 'wordwrapped' or with scrollbars.}
		property PreviewText : TRichEdit read FPreviewText write FPreviewText;
	published
{The localized hint-list for the ShowPreview-button.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property ShowPreviewButtonHints : TStringlist read FShowPreviewButtonHints
			write SetShowPreviewButtonHints stored StorePreviewHints;
{NoPreviewTexts is the localized list for the text displayed - centered - when there is
 nothing else to preview.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property NoPreviewTexts : TStringlist read FNoPreviewTexts
			write SetNoPreviewTexts stored StoreNoPreview;
{PreviewCaptions is the localized caption-list for the caption above the previewarea.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property PreviewCaptions : TStringlist read FPreviewCaptions
			write SetPreviewCaptions stored StoreCaptions;
{ScaleHints is the localized hint-list for the Scale-button.
The scale-button is visble when PreviewImage is visible.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property ScaleHints : TStringlist read FScaleHints
			write SetScaleHints stored StoreScaleHints;
{WordWrapHints is the localized hint-list for the WordWrap-button.
The WordWrap-button is visible when PreviewText is visible.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
{If the Windows-localeversion is not found in the list the 'Default'-value is used.}
		property WordWrapHints : TStringlist read FWordWrapHints
			write SetWordWrapHints stored StoreWrapHints;
{OnPreview event occurs when the dialog needs information on what to display in
 previewarea - in other words when a file is selected.}
{Here you write code that puts some text into 'PreviewText' or some graphic into
 'PreviewImage'.}
{First assign a procedure to this event.}
{Then you check the extension to see if it is the right kind of file.
 Then open and read some or all of the file into 'PreviewText' or
 'PreviewImage'. Close the file.}
{The Extension of the filetype, for which you write the previewcode, has to be
 included in 'CustomPreviewExtensions' - for filetypes not included in
 CustomPreviewExtensions the event is not triggered - a common mistake!!!}
{See the demo for an example - compare the preview with the textfiles 'File.xxx'
and 'File.yyy' to get the idea.}
		property OnPreview : TPreviewNotify read FOnPreview write FOnPreview;
{The FileExtensions for which you write preview-code in the 'OnPreview'-procedure.}
{The OnPreview-event is only triggered for these extensions.}
{The extensions should be in the form 'xxx' - lowercase (without '').}
{For Filetypes in this list YOU deside what to preview - even if the extension
is in DefaultPreviewExtensions, too. Then the default preview is skipped.}
{(Off course the filetypes have to be included in 'Filter'-Property to be
displayed in the dialog).}
		property CustomPreviewExtensions : TStringlist read FPreviewCustomExt write SetCustomPreviewExt;
{The Localization list for the Title property. Always leave the Title property
empty. Windows automatic assigns a localized value of 'Open' or 'Save as' to
Title when left empty.}
{If you have a special wish to the Title, put the localized texts into this
list and then the Title is also localized.}
{See the 'International codes.txt'-file to find the codes.}
{At runtime the text that fits the Windows-language is used.}
		property Titles : TStringlist read FTitles write SetTitles;
{Determines whether the ShowPreview-Button is down - True (Preview will be shown) or
up - False (No preview).}
{Users can change this by clicking the button at runtime.}
		property ShowPreview : Boolean read FShow write SetShow;
{Determines whether the Word-wrap and scale-button is down - True (words will be wrapped
and images scaled to fit) or up - False (Scroll-boxes will be shown if lines are too
long or images to large to fit).}
{Users can change this by clicking the button at runtime.}
		property WordWrapAndScale : Boolean read FWordWrapAndScale write SetWordWrapAndScale;
//ReadOnly property.
		property Version : string read FVersion write Dummy stored False;
	end;

{TPBSavePreviewDialog is the classname for PBSavePreviewDialog.}
	TPBSavePreviewDialog = class(TPBOpenPreviewDialog)
		function Execute: Boolean; override;
	end;

procedure Register;

implementation

{$R PBPreview.RES}

const
	NoPreviewDefault = '"Default=No preview","0009=No preview",' +
		'"0406=Ingen visning","0407=Keine Vorschau","0409=No preview",' +
		'"040C=Rien de montrer","0413=Geen voorbeeld"';
	CaptionsDefault = 'Default=Preview:,0009=Preview:,0406=Prøvevisning:,' +
		'0407=Vorschau:,0409=Preview:,040C=Épreuve:,0413=Voorbeeld:';
	ScaleHintsDefault = '"Default=Scale to fit","0009=Scale to fit",' +
		'"0406=Komprimér størrelse","0407=Größe anpassen","0409=Scale to fit",' +
		'040C=Compression,0413=Opschalen';
	WrapHintsDefault = 'Default=Word-wrap,0009=Word-wrap,0406=Liniedeling,' +
		'0407=Zeilenumbruch,0409=Word-wrap,"040C=Division de lignes",' +
		'"0413=Regels afbreken"';
	PreviewHintsDefault = '"Default=Show Preview","0009=Show Preview",' +
		'"0406=Vis prøve",0407=Vorschau,"0409=Show Preview",' +
		'"040C=Montrer l''epreuve","0413=Toon Voorbeeld"';

var
	Rect1, Rect2 : TRect;
	Ext : string;

constructor TPBOpenPreviewDialog.Create(AOwner: TComponent);
begin
	inherited Create(AOwner);
	FPreviewCustomExt := TStringList.Create;
	FPreviewDefaultExt := TStringList.Create;
	FPreviewDefaultExt.CommaText :=
		'bmp, ico, wmf, emf, txt, ini, inf, bat, log, pas, dpr, dpk, rtf, wav';
	FNoPreviewTexts := TStringList.Create;
	FNoPreviewTexts.CommaText := NoPreviewDefault;
	FPreviewCaptions := TStringList.Create;
	FPreviewCaptions.CommaText := CaptionsDefault;
	FScaleHints := TStringList.Create;
	FScaleHints.CommaText := ScaleHintsDefault;
	FWordWrapHints := TStringList.Create;
	FWordWrapHints.CommaText := WrapHintsDefault;
	FShowPreviewButtonHints := TStringList.Create;
	FShowPreviewButtonHints.CommaText := PreviewHintsDefault;
	FTitles := TStringList.Create;
	FTitles.CommaText := 'Default=';
	FVersion := '3.00.00.00';
//	Filter := 'All files (*.*)|*.*';
	FScrollBox := TScrollBox.Create(Self);
	with FScrollBox do
	begin
		Name := 'PreviewBox';
		Ctl3D := True;
		BorderStyle := bsSingle;
	end;
	FPreviewText := TRichEdit.Create(Self);
	FPreviewText.Name := 'FPreviewText';
	FPanel2 := TPanel.Create(Self);
	with FPanel2 do
	begin
		Name := 'CaptionPanel';
		Caption := LocaleText(FPreviewCaptions);
		Alignment := taCenter;
		Ctl3D := False;
		BevelOuter := bvNone;
		BevelInner := bvNone;
		BorderStyle := bsNone;
		BorderWidth := 0;
		FWordWrapButton := TSpeedButton.Create(Self);
		with FWordWrapButton do
		begin
			Name := 'FWordWrapButton';
			Parent := FPanel2;
			Caption := '';
		end;
		FShowPreviewButton := TSpeedButton.Create(Self);
		with FShowPreviewButton do
		begin
			Name := 'FShowPreviewButton';
			Parent := FPanel2;
			Caption := '';
		end;
	end;
	FShow := True;
	FWordWrapAndScale := True;
end;

destructor TPBOpenPreviewDialog.Destroy;
begin
	FTitles.Free;
	FNoPreviewTexts.Free;
	FPreviewCaptions.Free;
	FScaleHints.Free;
	FWordWrapHints.Free;
	FShowPreviewButtonHints.Free;
	FPreviewText.Free;
	FPreviewImage.Free;
	FPreviewDefaultExt.Free;
	FPreviewCustomExt.Free;
	FShowPreviewButton.Free;
	FWordWrapButton.Free;
	FPanel2.Free;
	FScrollBox.Free;
	inherited Destroy;
end;

procedure TPBOpenPreviewDialog.DoSelectionChange;
begin
	inherited DoSelectionChange;
	FPreview;
end;

procedure TPBOpenPreviewDialog.DoShow;
var
	StaticRect : TRect;
begin
	inherited DoShow;
	FLocale := IntToHex(GetSystemDefaultLangID, 4);
	GetClientRect(Handle, Rect1);
	StaticRect := GetStaticRect;
	with Rect1 do
	begin
		Left := StaticRect.Right + 8;
		Top := Top + 33;
		Right := Right - 8;
		Bottom := Bottom - 8;
	end;
	FScrollBox.ParentWindow := Handle;
	with FScrollBox do
	begin
		BringToFront;
		BoundsRect := Rect1;
		Color := clBtnFace;
		ParentFont := True;
	end;
	FPreviewText.Parent := FScrollBox;
	FPanel2.ParentWindow := Handle;
	FPanel2.BringToFront;
	GetClientRect(Handle, Rect2);
	Rect2.Left := Rect1.Left;
	Rect2.Right := Rect1.Right;
	Rect2.Bottom := Rect1.Top - 1;
	FPanel2.BoundsRect := Rect2;
	with FWordWrapButton do
	begin
		Width := 22;
		Height := 22;
		Left := FPanel2.ClientRect.Right - Width;
		Top := (FPanel2.ClientHeight - Height) div 2;
		NumGlyphs := 1;
		OnClick := WordWrapClick;
		Hint := LocaleText(FWordWrapHints);
		ShowHint := True;
		GroupIndex := 3;
		AllowAllUp := True;
		Down := FWordWrapAndScale;
	end;
	with FShowPreviewButton do
	begin
		Width := 22;
		Height := 22;
		Top := (FPanel2.ClientHeight - Height) div 2;
		Glyph.LoadFromResourceName(HInstance, 'SHOWPREVIEWBUTTON');
		Hint := LocaleText(FShowPreviewButtonHints);
		ShowHint := True;
		GroupIndex := 2;
		AllowAllUp := True;
		Down := FShow;
		OnClick := ShowPreviewClick;
	end;
	FPreview;
end;

procedure TPBOpenPreviewDialog.DoClose;
begin
	Application.HideHint;
	try
		sndPlaySound(PChar(''), SND_ASYNC or SND_NODEFAULT);
	except
		Dummy('');
	end;
	inherited DoClose;
end;

procedure TPBOpenPreviewDialog.FPreview;
var
	FFileDescription : string;
	Ok : Boolean;
	t : integer;
	FileInfo : TSHFileInfo;
begin
	try
		sndPlaySound(PChar(''), SND_ASYNC or SND_NODEFAULT);
	except
		Dummy('');
	end;
	FPreviewImage.Free;
	FPreviewImage := NIL;
	FPreviewImage := TImage.Create(Self);
	with FPreviewImage do
	begin
		Name := 'FPreviewImage';
		Parent := FScrollBox;
		Align := alClient;
		AutoSize := False;
		Center := True;
		Canvas.Brush.Color := clWindow;
		Canvas.FillRect(BoundsRect);
		Visible := True;
	end;
	with FPreviewText do
	begin
		Align := alClient;
		Alignment := taLeftJustify;
		ScrollBars := ssBoth;
		BorderStyle := bsNone;
		FPreviewtext.Color := clWindow;
		WantReturns := False;
		ReadOnly := True;
		Visible := True;
		Clear;
		ParentFont := True;
		Text := '';
		ParaGraph.Alignment := taLeftJustify;
		DefAttributes.Assign(FScrollBox.Font);
	end;
	Ext := LowerCase(Copy(ExtractFileExt(FileName), 2, 9999));
	Ok := False;
	if (FileExists(FileName)) and (FShowPreviewButton.Down) then
	begin
		if (FPreviewCustomExt.IndexOf(Ext) <> -1) and Assigned(FOnPreview) then
		begin
			try
				FOnPreview(Self, Ext);
				Ok := True;
			except
				Dummy('');
			end;
		end
		else if (FPreviewDefaultExt.IndexOf(Ext) <> -1) then
		begin
			if pos(Ext, 'bmp ico wmf emf') > 0 then
			try
				FPreviewImage.Picture.LoadFromFile(FileName);
				Ok := True;
			except
				Dummy('');
			end
			else if pos(Ext, 'txt rtf ini inf bat log pas dpr dpk') > 0 then
			try
				FPreviewText.Lines.LoadFromFile(FileName);
				Ok := True;
			except
				Dummy('');
			end
			else if Ext = 'wav' then
			begin
				if SHGetFileInfo(PChar(FileName), 0, FileInfo,
					SizeOf(TSHFileInfo),SHGFI_TYPENAME) <> 0 then
				with FPreviewText do
				begin
					FFileDescription := FileInfo.szTypeName;
					WordWrap :=  True;
					Paragraph.Alignment := taCenter;
					for t := 1 to ((((Height - 4) div abs(SelAttributes.Height)) div 2) - 1) do Lines.Add('');
					Lines.Add(FFileDescription);
					Ok := True;
					try
						sndPlaySound(PChar(FileName), SND_ASYNC or SND_NODEFAULT);
					except
						Dummy('');
					end;
				end;
			end;
		end
		else if SHGetFileInfo(PChar(FileName), 0, FileInfo,
			SizeOf(TSHFileInfo),SHGFI_TYPENAME) <> 0 then
		begin
			FFileDescription := Trim(FileInfo.szTypeName);
			if FFileDescription <> '' then
			begin
				with FPreviewText do
				begin
					WordWrap := True;
					Paragraph.Alignment := taCenter;
					for t := 1 to ((((Height - 4) div abs(SelAttributes.Height)) div 2) - 1) do Lines.Add('');
					Lines.Add(FFileDescription);
				end;
				Ok := True;
			end;
		end;
	end;
	if Ok = False then with FPreviewText do
	begin
		WordWrap := True;
		Paragraph.Alignment := taCenter;
		for t := 1 to ((((Height - 4) div abs(SelAttributes.Height)) div 2) - 1) do Lines.Add('');
		Lines.Add(LocaleText(FNoPreviewTexts));
	end;
	if FPreviewText.Lines.Count > 0 then
	begin
		FPreviewText.Visible := True;
		FPreviewText.BringToFront;
		FPreviewImage.Visible := False;
		FWordWrapButton.Hint := LocaleText(FWordWrapHints);
		FWordWrapButton.Glyph.LoadFromResourceName(HInstance, 'WORDWRAPBUTTON');
	end
	else
	begin
		FPreviewImage.Visible := True;
		FPreviewImage.BringToFront;
		FPreviewText.Visible := False;
		FWordWrapButton.Hint := LocaleText(FScaleHints);
		FWordWrapButton.Glyph.LoadFromResourceName(HInstance, 'SCALEBUTTON');
	end;
	WordWrapClick(Self);
	FScrollBox.Update;
	FPanel2.Caption := LocaleText(FPreviewCaptions);
	FPanel2.Update;
end;

procedure TPBOpenPreviewDialog.SetPreviewCaptions(Value : TStringlist);
begin
	if Value <> FPreviewCaptions then
	begin
		FPreviewCaptions.Assign(Value);
		FPanel2.Caption := LocaleText(FPreviewCaptions);
	end;
end;

procedure TPBOpenPreviewDialog.SetScaleHints(Value : TStringlist);
begin
	if Value.Text <> FScaleHints.Text then
	begin
		FScaleHints.Assign(Value);
	end;
end;

procedure TPBOpenPreviewDialog.SetWordWrapHints(Value : TStringlist);
begin
	if Value.Text <> FWordWrapHints.Text then
	begin
		FWordWrapHints.Assign(Value);
	end;
end;

procedure TPBOpenPreviewDialog.SetShowPreviewButtonHints(Value : TStringlist);
begin
	if Value <> FShowPreviewButtonHints then
	begin
		FShowPreviewButtonHints.Assign(Value);
		FShowPreviewButton.Hint := LocaleText(FShowPreviewButtonHints);
	end;
end;

procedure TPBOpenPreviewDialog.SetNoPreviewTexts(Value : TStringlist);
begin
	if Value.Text <> FNoPreviewTexts.Text then
	begin
		FNoPreviewTexts.Assign(Value);
	end;
end;

procedure TPBOpenPreviewDialog.Dummy(Value: String);
begin
//	Read only !
end;

procedure TPBOpenPreviewDialog.SetCustomPreviewExt(Value : TStringlist);
begin
	if Value.Text <> FPreviewCustomExt.Text then FPreviewCustomExt.Assign(Value);
end;

procedure TPBOpenPreviewDialog.ShowPreviewClick(Sender : TObject);
begin
	FShow := FShowPreviewButton.Down;
	FPreview;
end;

procedure TPBOpenPreviewDialog.WordWrapClick(Sender : TObject);
var
	W, H : integer;
	HW : extended;
begin
	FWordWrapAndScale := FWordWrapButton.Down;
	if FPreviewImage.Visible = True then
	begin
		with FPreviewImage do
		begin
			Align := alClient;
			AutoSize := False;
			Center := True;
			Align := alNone;
			if FWordWrapButton.Down then
			begin
				W := Picture.Width;
				H := Picture.Height;
				if (W <> 0) and ((W > Width) or (H > Height)) then
				begin
					Stretch := True;
					HW := H / W;
					if Height / Width > HW then Height := Trunc(Width * HW)
					else Width := Trunc(Height / HW);
				end
				else
				begin
					Stretch := False;
				end;
			end
			else
			begin
				Stretch := False;
				W := Picture.Width;
				H := Picture.Height;
				if (W <> 0) and ((W > Width) or (H > Height)) then
				begin
					AutoSize := True;
				end;
			end;
			Update;
		end;
	end
	else
	begin
		FPreviewText.WordWrap := FWordWrapButton.Down;
		FPreviewText.Update;
	end;
end;

function TPBOpenPreviewDialog.Execute : Boolean;
begin
	if ofOldStyleDialog in Options then Options := Options -[ofOldStyleDialog];
	Template := 'PREVIEWTEMPLATE';
	if LocaleText(FTitles) <> '' then Title := LocaleText(FTitles);
	Result := inherited Execute;
end;

function TPBSavePreviewDialog.Execute : Boolean;
begin
	if ofOldStyleDialog in Options then Options := Options -[ofOldStyleDialog];
	Template := 'PREVIEWTEMPLATE';
	if LocaleText(FTitles) <> '' then Title := LocaleText(FTitles);
	Result := DoExecute(@GetSaveFileName);
end;

function TPBOpenPreviewDialog.LocaleText(List : TStringlist) : string;
begin
	if List.Count = 0 then Result := ''
	else
	begin
		if List.IndexOfName(FLocale) <> -1 then Result := List.Values[FLocale]
		else if List.IndexOfName('Default') <> -1 then Result := List.Values['Default']
		else Result := List.Values[List.Names[0]];
	end;
end;

procedure TPBOpenPreviewDialog.SetTitles(Value : TStringlist);
begin
	if FTitles.Text <> Value.Text then FTitles.Assign(Value);
end;

procedure TPBOpenPreviewDialog.SetShow(Value : Boolean);
begin
	if FShow <> Value then
	begin
		FShow := Value;
		FShowPreviewButton.Down := Value;
	end;
end;

procedure TPBOpenPreviewDialog.SetWordWrapAndScale(Value : Boolean);
begin
	if FWordWrapAndScale <> Value then
	begin
		FWordWrapAndScale := Value;
		FWordWrapButton.Down := Value;
	end;
end;

function TPBOpenPreviewDialog.StoreNoPreview : Boolean;
begin
	if FNoPreviewTexts.CommaText = NoPreviewDefault then Result := False
	else Result := True;
end;

function TPBOpenPreviewDialog.StoreCaptions : Boolean;
begin
	if FPreviewCaptions.CommaText = CaptionsDefault then Result := False
	else Result := True;
end;

function TPBOpenPreviewDialog.StoreScaleHints : Boolean;
begin
	if FScaleHints.CommaText = ScaleHintsDefault then Result := False
	else Result := True;
end;

function TPBOpenPreviewDialog.StoreWrapHints : Boolean;
begin
	if FWordWrapHints.CommaText = WrapHintsDefault then Result := False
	else Result := True;
end;

function TPBOpenPreviewDialog.StorePreviewHints : Boolean;
begin
	if FShowPreviewButtonHints.CommaText = PreviewHintsDefault then Result := False
	else Result := True;
end;

procedure Register;
begin
	RegisterComponents('PB', [TPBOpenPreviewDialog, TPBSavePreviewDialog]);
end;

end.

