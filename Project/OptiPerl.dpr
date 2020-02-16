program OptiPerl;
{$I REG.INC}
{%ToDo 'OptiPerl.todo'}
{%File 'REG.INC'}

uses
  VirtualTrees,
  HKDebug,
  OptiPerl_TLB in 'OptiPerl_TLB.pas',
  OptiClient_TLB in '..\Client\OptiClient_TLB.pas',
  OptAuto_App in 'Units\OptAuto_App.pas' {Application: CoClass},
  OptAuto_Doc in 'Units\OptAuto_Doc.pas' {Application: CoClass},
  OptAuto_Project in 'Units\OptAuto_Project.pas' {Application: CoClass},
  OptAuto_Nodes in 'Units\OptAuto_Nodes.pas' {Application: CoClass},
  OptAuto_Control in 'Units\OptAuto_Control.pas' {Application: CoClass},
  PlugInFrm in 'Windows\PlugInFrm.pas' {PlugInForm},
  PlugMdl in 'Modules\PlugMdl.pas' {PlugMod: TDataModule},
  PlugTypes in 'Units\PlugTypes.pas',
  PlugCommon in 'Units\PlugCommon.pas',
  PlugBase in 'Units\PlugBase.pas',
  AboutFrm in 'Windows\AboutFrm.pas' {AboutForm},
  AddAssocFrm in 'Windows\AddAssocFrm.pas' {AddAssocForm},
  AppDataFrm in 'Windows\AppDataFrm.pas' {AppDataForm},
  AutoViewFrm in 'Windows\AutoViewFrm.pas' {AutoViewForm},
  BigWebFrm in 'Windows\BigWebFrm.pas' {BigWebForm: TFormEx},
  CentralImageListMdl in 'Modules\CentralImageListMdl.pas' {CentralImageListMod: TDataModule},
  CheckForUpdateFrm in 'Windows\CheckForUpdateFrm.pas' {CheckUpdateForm},
  CodeAnalyzeUnit in 'Units\CodeAnalyzeUnit.pas',
  CodeCompFrm in 'Modules\CodeCompFrm.pas' {CodeComplete: TDataModule},
  CommConvUnit in 'Units\CommConvUnit.pas',
  ConfToolFrm in 'Windows\ConfToolFrm.pas' {ConfToolForm},
  CustDebMdl in 'Modules\CustDebMdl.pas' {CustDebMod: TDataModule},
  DebuggerMdl in 'Modules\DebuggerMdl.pas' {LDebMod: TDataModule},
  EditorFrm in 'Windows\EditorFrm.pas' {EditorForm},
  EditTodoItemFrm in 'Windows\EditTodoItemFrm.pas' {EditTodoItemForm},
  EdMagicMdl in 'Modules\EdMagicMdl.pas' {EdMagicMod: TDataModule},
  ErrorCheckMdl in 'Modules\ErrorCheckMdl.pas' {ErrorCheckMod: TDataModule},
  EvalExpFrm in 'Windows\EvalExpFrm.pas' {EvalExpForm},
  ExplorerFrm in 'Windows\ExplorerFrm.pas' {ExplorerForm},
  FileCompareFrm in 'Windows\FileCompareFrm.pas' {FileCompareForm},
  FileExploreFrm in 'Windows\FileExploreFrm.pas' {FileExploreForm},
  FormSelectFrm in 'Windows\FormSelectFrm.pas' {FormSelectForm},
  FTPMdl in 'Modules\FTPMdl.pas' {FTPMod: TDataModule},
  FTPSelectFrm in 'Windows\FTPSelectFrm.pas' {FTPSelectForm},
  FTPSessionsFrm in 'Windows\FTPSessionsFrm.pas' {FTPSessionsForm},
  FTPUploadFrm in 'Windows\FTPUploadFrm.pas' {FTPUploadForm},
  HTMLElements in 'Units\HTMLElements.pas',
  HttpProxy in 'Units\HttpProxy.pas',
  ImportFolderFrm in 'Windows\ImportFolderFrm.pas' {ImportFolderForm},
  ItemMdl in 'Modules\ItemMdl.pas' {ItemMod: TDataModule},
  LibrarianFrm in 'Windows\Librarian\LibrarianFrm.pas' {LibrarianForm},
  LogFrm in 'Windows\LogFrm.pas' {LogForm},
  MainFrm in 'Windows\MainFrm.pas' {OptiMainForm},
  MainServerMdl in 'Modules\MainServerMdl.pas' {MainServerMod: TDataModule},
  OPerformanceFrm in 'Windows\OPerformanceFrm.pas' {OPerformanceForm},
  OptAssociations in 'Units\OptAssociations.pas',
  OptBackup in 'Units\OptBackup.pas',
  OptControl in 'Units\OptControl.pas',
  OptFolders in 'Units\OptFolders.pas',
  OptForm in 'Units\OptForm.pas',
  OptGeneral in 'Units\OptGeneral.pas',
  OptKeyboard in 'Units\OptKeyboard.pas',
  OptMessage in 'Units\OptMessage.pas',
  OptQuery in 'Units\OptQuery.pas',
  OptOptions in 'Units\OptOptions.pas',
  OptProcs in 'Units\OptProcs.pas',
  OptSearch in 'Units\OptSearch.pas',
  OptTest in 'Units\OptTest.pas',
  OptionFrm in 'Windows\OptionFrm.pas' {OptionForm},
  OptProtoFrm in 'Windows\Options\OptProtoFrm.pas' {OptProtoForm},
  OFrmBoxBr in 'Windows\Options\OFrmBoxBr.pas' {OFormBoxBr},
  OFrmBoxPar in 'Windows\Options\OFrmBoxPar.pas' {OFormBoxPar},
  OFrmBVisual in 'Windows\Options\OFrmBVisual.pas' {OFormVisual},
  OFrmLines in 'Windows\Options\OFrmLines.pas' {OFormLines},
  OFrmPrinter in 'Windows\Options\OFrmPrinter.pas' {OFormPrinter},
  ParamFrm in 'Windows\ParamFrm.pas' {ParamForm},
  ParsersMdl in 'Modules\ParsersMdl.pas' {ParsersMod: TDataModule},
  PerlInfoFrm in 'Windows\PerlInfoFrm.pas' {PerlInfoForm},
  PerlPrinterFrm in 'Windows\PerlPrinterFrm.pas' {PerlPrinterForm},
  PerlTemplatesFrm in 'Windows\PerlTemplatesFrm.pas' {TemplateForm},
  PerlTidyFrm in 'Windows\PerlTidyFrm.pas' {PerltidyForm},
  PodViewerFrm in 'Windows\PodViewerFrm.pas' {PodViewerForm},
  PrintFrm in 'Windows\PrintFrm.pas' {PrintForm},
  ProjectFrm in 'Windows\Project\ProjectFrm.pas' {ProjectForm},
  ProjOptFrm in 'Windows\Project\ProjOptFrm.pas' {ProjOptForm},
  PromptReplaceFrm in 'Windows\PromptReplaceFrm.pas' {PromptReplaceForm},
  QueryFm in 'Windows\QueryFm.pas' {QueryFrame: TFrame},
  QueryFrm in 'Windows\QueryFrm.pas' {QueryForm},
  RDebMdl in 'Modules\RDebMdl.pas' {RDebMod: TDataModule},
  RegExpTesterFrm in 'Windows\RegExpTesterFrm.pas' {RegExpTesterForm},
  RemDebInfoFrm in 'Windows\RemDebInfoFrm.pas' {RemDebInfoForm},
  RemoteDebFrm in 'Windows\RemoteDebFrm.pas' {RemoteDebForm},
  RunPerl in 'Units\RunPerl.pas',
  ScriptInfoUnit in 'Units\ScriptInfoUnit.pas',
  SearchFilesFrm in 'Windows\SearchFilesFrm.pas' {SearchFilesForm},
  SecEditFrm in 'Windows\SecEditFrm.pas' {SecEditForm},
  SendmailAddFrm in 'Windows\SendmailAddFrm.pas' {SendMailAddForm},
  SendmailFrm in 'Windows\SendmailFrm.pas' {SendmailForm},
  ServerMdl in 'Modules\ServerMdl.pas' {ServerMod: TDataModule},
  SplashFrm in 'Windows\SplashFrm.pas' {SplashForm},
  StatusFrm in 'Windows\StatusFrm.pas' {StatusForm},
  StringViewFrm in 'Windows\StringViewFrm.pas' {StringViewForm},
  SubListFrm in 'Windows\SubListFrm.pas' {SubListForm},
  TemSelectFrm in 'Windows\TemSelectFrm.pas' {TemSelectForm},
  TodoFrm in 'Windows\TodoFrm.pas' {TodoForm},
  URLEncodeFrm in 'Windows\URLEncodeFrm.pas' {URLEncodeForm},
  WatchFrm in 'Windows\WatchFrm.pas' {WatchForm},
  WebBrowserFrm in 'Windows\WebBrowserFrm.pas' {WebBrowserForm},
  WorkingFrm in 'Windows\WorkingFrm.pas' {WorkingForm},
  HKWebFind in '..\Haka Library\HKWebFind.pas' {WebFindForm},
  HK_replunit in '..\Haka Library\HK_replunit.pas' {HKReplDialog},
  Forms,
  classes,
  sysutils,
  dialogs;

{$IFDEF OLE}
 {$R *.TLB}
{$ENDIF}

{$R *.RES}

procedure CreateForm(InstanceClass: TComponentClass; var Reference);
var s:string;
begin
 Application.CreateForm(InstanceClass, Reference);
 s:=instanceclass.ClassName;
 delete(s,1,1);
 HKLog(s);
 {$IFDEF SPLASHFORM}
 SplashForm.splashText('Class '+s+' created.');
 {$ENDIF}
end;

begin
  HKLog('Main 1');
  if shouldterminate then exit;
  Application.Initialize;

  HKLog('Main 2');
  Application.Title := 'OptiPerl';

  {$IFDEF SPLASHFORM}
  if not assigned(SplashForm) then
   SplashForm:=TSplashForm.Create(Application);
  SplashForm.splashText('Initializing...');
  {$ENDIF}

  HKLog('Main 3');
  CreateForm(TOptiMainForm, OptiMainForm);
  CreateForm(TParsersMod, ParsersMod);
  CreateForm(TCentralImageListMod, CentralImageListMod);
  CreateForm(TProjectForm, ProjectForm);
  CreateForm(TQueryForm, QueryForm);
  CreateForm(TStatusForm, StatusForm);
  CreateForm(TWebBrowserForm, WebBrowserForm);
  CreateForm(TConfToolForm, ConfToolForm);
  CreateForm(TFTPMod, FTPMod);
  CreateForm(TEditorForm, EditorForm);
  CreateForm(TLDebMod, LDebMod);
  CreateForm(TRDebMod, RDebMod);
  CreateForm(TMainServerMod, MainServerMod);
  {$IFDEF OLE}
  CreateForm(TPlugMod, PlugMod);
  {$ENDIF}
  CreateForm(TItemMod, ItemMod);
  CreateForm(TExplorerForm, ExplorerForm);
  CreateForm(TEdMagicMod, EdMagicMod);
  CreateForm(TCodeComplete, CodeComplete);
  CreateForm(TPodViewerForm, PodViewerForm);
  {$IFDEF SPLASHFORM}
  SplashForm.splashText('Initializing browser...');
  {$ENDIF}
  HKLog('Main 4');
  Application.Run;
  HKLog('Main 5');
end.
