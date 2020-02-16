unit SearchFilesFrm; //modal //Tabs

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OptFolders, FindFile,OptGeneral, jclfileutils, hyperstr, hakageneral,
  Hakahyper, OptSearch, diPcre,  ExtCtrls, ComCtrls,agPropUtils,dcString,OptProcs,
  PromptReplaceFrm,dcMemo,ScriptInfoUnit, Menus, JvPlacemnt, Buttons, HK_ReplUnit;

type
  TSearchDialogType = (sdFiles,sdProject,sdActive);

  TSearchFilesForm = class(TForm)
    FormStorage: TjvFormStorage;
    FindFile: TFindFile;
    TabControl: TTabControl;
    FindBox: TGroupBox;
    edFind: TComboBox;
    ReplBox: TGroupBox;
    edReplace: TComboBox;
    MaskBox: TGroupBox;
    edFileMask: TComboBox;
    cbRecursive: TCheckBox;
    cbBinary: TCheckBox;
    cbCase: TCheckBox;
    cbPrompt: TCheckBox;
    Panel: TPanel;
    lblSearching: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    cbOpen: TCheckBox;
    cbUngreedy: TCheckBox;
    cbEOL: TCheckBox;
    cbRegExp: TCheckBox;
    btnLast: TSpeedButton;
    PopupMenu: TPopupMenu;
    Position1Item: TMenuItem;
    Position2Item: TMenuItem;
    Position3item: TMenuItem;
    Position4item: TMenuItem;
    lblFiles: TLabel;
    btnHighLight: TBitBtn;
    cbAllOpen: TCheckBox;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FindFileFound(Sender: TObject; Folder: String;
      var FileInfo: TSearchRec);
    procedure edFindChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TabControlChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbBinaryClick(Sender: TObject);
    procedure cbPromptClick(Sender: TObject);
    procedure cbRegExpClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure PositionItemClick(Sender: TObject);
    procedure btnHighLightClick(Sender: TObject);
    procedure cbAllOpenClick(Sender: TObject);
  private
    FileList : TStringList;
    h1,h2,h3,c1,c2 : INteger;
    InitialF : String;
    Cancel:boolean;
    DialType : TSearchDialogType;
    procedure SearchFiles;
    procedure GetGoodFileList;
    procedure SetEnable(val: Boolean);
    procedure ReplaceFiles;
    procedure ControlReplace(const F: String; Memo : TDCMemo; var Response: Integer);
    function UpdateReplace(const F: String; Replaced, CurrSize: Integer): Boolean;
    procedure SetInitial;
  public
    Constructor Create(AOwner: TComponent; DialogType : TSearchDialogType; Files : TStrings; Const InitialFind : String);
  end;


implementation

{$R *.DFM}

procedure TSearchFilesForm.FormShow(Sender: TObject);
begin
 TabControlChange(sender);
 FormStorage.RestoreFormPlacement;
 cbAllOpenClick(sender);
 cbRegExpClick(sender);
 cbBinaryClick(sender);
 cbPromptClick(sender);
 edFindChange(sender);
 if CurrentOptions.DialogVisible
  then btnLastClick(nil)
  else SetInitial;
 edFind.SetFocus;
end;

procedure TSearchFilesForm.SetInitial;
begin
 if not cbRegExp.Checked
  then EdFind.Text:=InitialF
  else EdFind.Text:=SimpleToRegExpPattern(InitialF,cbUngreedy.Checked);
end;

procedure TSearchFilesForm.FormCreate(Sender: TObject);
begin
 cbAllOpen.visible:=dialType=sdActive;

 if dialType=sdFiles
  then lblFiles.caption:='Will search '+inttostr(FileList.Count)+' files/folders'
 else
 if dialtype=sdProject
  then begin
   lblFiles.caption:='Will search '+inttostr(FileList.Count)+' files';
   cbBinary.Top:=edFileMask.Top+(edFileMask.Height-cbBinary.Height) div 2
  end;

 h1:=FindBox.Top; h2:=ReplBox.Top; h3:=MaskBox.Top;
 c1:=cbRecursive.Top; c2:=cbBinary.Top;
end;

procedure TSearchFilesForm.SearchFiles;
var
 i:integer;
 pat:string;
begin
 InitPatternSearch;
 ProgressBar.visible:=True;
 lblsearching.Left:=ProgressBar.Left+ProgressBar.Width+5;
 cbAllOpen.Visible:=false;
 pat:=edFind.text;
 try
  for i:=0 to FileList.Count-1 do
  begin
   if cancel then break;
   if i mod 5 = 0 then
   begin
    lblsearching.Caption:='Searching file '+extractfilename(fileList[i])+' ('+inttostr(i)+' of '+inttostr(FileList.Count)+')';
    ProgressBar.Position:=Round(i*100/FileList.Count);
    application.ProcessMessages;
   end; 
   PatternSearchFile(fileList[i],pat,
    cbUnGreedy.Checked,cbBinary.Checked,cbCase.Checked,cbRegExp.Checked);
  end;
 finally
  EndPatternSearch;
 end;
end;

procedure TSearchFilesForm.GetGoodFileList;
var
 i:integer;
 sl : TStringList;
 f:string;
begin
 FindFile.Subfolders:=cbRecursive.Checked;
 sl:=TStringList.Create;
 try
  sl.Assign(FileList);
  FileList.Clear;
  for i:=0 to sl.count-1 do
  begin
   if cancel then break;
   lblsearching.Caption:='Searching for files: '+inttostr( ((i+1)*100) div (sl.Count) )+'%';
   application.ProcessMessages;

   f:=sl[i];
   if FileExists(f) and IsFileInMask(f,edFileMask.text) then
    FileList.Add(f);
   if directoryexists(f) then
    begin
     FindFile.Location:=ExcludeTrailingBackSlash(f);
     FindFile.Execute;
    end;
  end;
 finally
  sl.free;
 end;
end;

Function TSearchFilesForm.UpdateReplace(Const F : String;
  Replaced,CurrSize : Integer) : Boolean;
begin
 application.ProcessMessages;
 lblSearching.Caption:=Format('%s: Made %d replacements. Current size: %d bytes',
  [ExtractFilename(f),replaced,currsize]);
 result:=Cancel;
end;

Procedure TSearchFilesForm.ControlReplace(Const F : String; Memo : TDCMemo; Var Response : Integer);
begin
 visible:=false;
 response:=PromptReplaceFrm.ExecuteReplaceDialog(memo)
end;

procedure TSearchFilesForm.ReplaceFiles;
var
 i:integer;
 w:boolean;
begin
 if (not cbPrompt.Checked) and (not cbOpen.Checked) and
  (MessageDlg('You have deselected options "Prompt on replace" and'+#13+#10+'"Open in editor". This will replace text in files and save them'+#13+#10+'without prompting. Continue?',
   mtWarning, [mbOK,mbCancel], 0)<>mrOK) then exit;

 w:=false;
 InitPatternSearch;
 try
  for i:=0 to FileList.Count-1 do
  begin
   if cancel then break;
   if FileReadOnly(fileList[i]) then
   begin
    if not w then
     MessageDlg('Found file that is read-only.'+#13+#10+'All read-only files will be skipped from replacing.', mtWarning, [mbOK], 0);
    w:=true;
   end
    else
     PatternReplace(fileList[i],edFind.Text,edReplace.Text,
     cbEOL.Checked,cbUnGreedy.Checked,cbCase.Checked,
     cbPrompt.checked,cbOpen.checked,cbRegExp.checked,ControlReplace,UpdateReplace);
  end;
 finally
  EndPatternSearch;
 end;
end;

procedure TSearchFilesForm.SetEnable(val : Boolean);
begin
 SetGroupEnable([btnOk,edFind,edReplace,edFilemask,cbCase,cbPrompt,cbRegExp,cbRecursive,cbBinary],val)
end;

procedure TSearchFilesForm.btnOKClick(Sender: TObject);
begin
 if length(edFind.Text)=0 then exit;
 
 SmartStringsAdd(edFind.Items,edFind.text);
 SmartStringsAdd(edReplace.Items,edReplace.text);
 SmartStringsAdd(edFileMask.Items,edFileMask.text);
 if FileList.count<=0 then exit;

 SetEnable(false);
 lblSearching.Visible:=dialtype<>sdActive;

 if dialType<>sdActive then
  GetGoodFileList
 else
  if not cbAllOpen.Checked then
   FileList.Text:=ActiveScriptInfo.path;

 if TabControl.TabIndex=0
 then
  SearchFiles
 else
  ReplaceFiles;
end;

procedure TSearchFilesForm.btnCancelClick(Sender: TObject);
begin
 Cancel:=true;
end;

procedure TSearchFilesForm.FindFileFound(Sender: TObject; Folder: String;
  var FileInfo: TSearchRec);
begin
 if IsFileInMask(fileinfo.name,edFileMask.text) then
 begin
  FIleList.Add(includetrailingbackslash(folder)+fileinfo.Name);
  application.processmessages;
 end;
end;

procedure TSearchFilesForm.edFindChange(Sender: TObject);
begin
 btnOK.Enabled:=edFind.Text<>'';
end;

procedure TSearchFilesForm.FormDestroy(Sender: TObject);
begin
 FileList.Free;
end;

procedure TSearchFilesForm.TabControlChange(Sender: TObject);
Const
 CapStr : Array[0..1] of string = ('Search in ','Search and Replace in ');
 DialStr : Array[TSearchDialogType] of string = ('Files','Project','Open file(s)');
var
 ha : Integer;
begin
 Caption:=CapStr[TabControl.tabindex]+DialStr[DialType];
 ha:=ClientHeight-TabControl.Height+15;
 if TabControl.TabIndex=0 then
 begin
  ReplBox.Visible:=false;
  MaskBox.Visible:=dialtype<>sdActive;
  MaskBox.Top:=h2;
  cbBinary.Visible:=true;
  cbRecursive.Visible:=dialtype<>sdProject;
  cbRecursive.Top:=c1;
  cbBinary.Top:=c2;
  if dialtype<>sdActive then
    ClientHeight:=h2+maskBox.Height+ha
  else
    ClientHeight:=h1+FindBox.Height+ha;
 end
 else if TabControl.TabIndex=1 then
 begin
   cbBinary.Visible:=false;
   cbRecursive.Top:=edFileMask.Top+(edFileMask.Height-cbRecursive.Height) div 2;
   cbRecursive.Visible:=dialtype<>sdProject;
   ReplBox.Visible:=true;
   ReplBox.Top:=h2;
   MaskBox.Visible:=dialtype<>sdactive;
   MaskBox.Top:=h3;
   if dialtype<>sdActive then
    ClientHeight:=h3+maskBox.Height+ha
   else
    ClientHeight:=h2+replBox.Height+ha;
 end;
end;

constructor TSearchFilesForm.Create(AOwner: TComponent;
  DialogType: TSearchDialogType; Files : TStrings; Const InitialFind : String);
var i:integer;
begin
 DialType:=DialogType;
 InitialF:=InitialFind;
 Inherited Create(AOwner);
 FileList:=TStringList.Create;
 FileList.Sorted:=true;
 FileList.Duplicates:=dupIgnore;
 for i:=0 to FIles.Count-1 do
  FileList.Add(Files[i]);
end;

procedure TSearchFilesForm.cbBinaryClick(Sender: TObject);
begin
 cbPrompt.Enabled:=not cbBinary.Checked;
end;

procedure TSearchFilesForm.cbPromptClick(Sender: TObject);
begin
 cbOpen.Enabled:=not cbPrompt.Checked;
 if not cbOpen.Enabled then cbOpen.Checked:=true;
 cbEOL.Enabled:=not cbPrompt.Checked;
 if not cbEOL.Enabled then cbEOL.Checked:=true;
end;

procedure TSearchFilesForm.cbRegExpClick(Sender: TObject);
const
 captStr : array[boolean] of string = ('W&hole words','Un&greedy');
 hintStr : array[boolean] of string =
 ('Match whole words only','Match the minimum number of times possible. The default is unselected, to match the maximum number of times.');
begin
 cbUngreedy.Caption:=captStr[cbRegExp.checked];
 cbUngreedy.Hint:=HintStr[cbRegExp.checked];
end;

procedure TSearchFilesForm.btnLastClick(Sender: TObject);
begin
 cbCase.Checked:=CurrentOptions.CaseSensitive;
 cbRegExp.Checked:=false;
 cbUngreedy.Checked:=CurrentOptions.WholeWords;
 cbRegExpClick(nil);
 edFind.Text:=CurrentOptions.SearchText;
 if CurrentOptions.ReplText<>'' then
  edReplace.Text:=CurrentOptions.ReplText;
 btnLast.Visible:=false;
 btnOK.Enabled:=edFind.Text<>'';
end;

procedure TSearchFilesForm.PositionItemClick(Sender: TObject);
var s:string;
begin
 if not cBRegExp.Checked
  then s:=SimpleToRegExpPattern(edFind.Text,cbUngreedy.Checked)
  else s:=edFind.Text;

 PR_setPattern(TMenuItem(sender).Tag,s,cbCase.Checked);
 btnCancel.Caption:='Close';
 btnCancel.Default:=true;
 btnCancel.SetFocus;
end;

procedure TSearchFilesForm.btnHighLightClick(Sender: TObject);
var pt : TPoint;
begin
 pt.X:=0;
 pt.Y:=btnHighLight.height;
 pt:=btnHighLight.ClientToScreen(pt);
 popupMenu.Popup(pt.X,pt.Y);
end;

procedure TSearchFilesForm.cbAllOpenClick(Sender: TObject);
const
 StatusStr : array [boolean] of string = ('Will search active file','Will search all open files');
begin
 if dialType=sdActive then
  lblFiles.caption:=StatusStr[cballopen.checked];
end;

end.
