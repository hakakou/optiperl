unit SecEditFrm;    //modeles //memo
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  optOptions, optfolders, dccommon, dcmemo,dcstring,OptProcs, jclIniFiles,
  ScriptInfoUnit,StdCtrls,menus,variants,OptForm, OptGeneral;

type
  TSecEditForm = class(TOptiForm)
    memEditor: TDCMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure memEditorMemoScroll(Sender: TObject;
      ScrollStyle: TScrollStyle; Delta: Integer);
    procedure FormDestroy(Sender: TObject);
  private
    Number : Integer;
    EditScriptInfo : TScriptInfo;
  protected
    Procedure FirstShow(Sender: TObject); Override;
    procedure _OptionsUpdated(Level: Integer);
    procedure _SyncScroll(CharPos, LinePos: Integer; const Path: String; Sender: TObject);
    procedure _OneClosed(si: TObject);
  public
  end;

Function SecEditAvailable : Boolean;
Function IniCreateSecEdit(num : Integer) : Boolean;
Procedure CreateSecEdit;

implementation
const
 iniSecEdit = 'SecEdit';

{$R *.DFM}

Function SecEditAvailable : Boolean;
begin
 result:=(SecEditForms[0].Window=nil) or (SecEditForms[1].Window=nil) or
         (SecEditForms[2].Window=nil) or (SecEditForms[3].Window=nil);
end;

Procedure CreateNum(i : Integer);
begin
 with SecEditForms[i] do
  begin
   window:=TSecEditForm.CreateNamed(application,'SecEditForm'+inttostr(i));
   TSecEditForm(window).Number:=i;
   OneClosed:=TSecEditForm(window)._OneClosed;
   OptionsUpdated:=TSecEditForm(window)._OptionsUpdated;
   SyncScroll:=TSecEditForm(window)._syncScroll;
   TSecEditForm(window).Show;
  end;
end;

Function IniCreateSecEdit(num : Integer) : Boolean;
var path : string;
begin
 result:=false;
 if not SecEditAvailable then
  exit;
 path:=iniReadString(Folders.IniFile,inisecedit,inttostr(num));
 if not fileexists(path) then
  exit;
 result:=true;
 PR_OpenFile(path);
 CreateNum(num);
end;

Procedure CreateSecEdit;
var i:integer;
begin
 i:=0;
 while assigned(SecEditForms[i].Window) do inc(i);
 Createnum(i);
end;

procedure TSecEditForm.FormCreate(Sender: TObject);
begin
 {$IFDEF SECEDITCRIPPLE}
 if not IsLoadingLayout then
  MessageDlg('The secondary edit window is disabled in the trial version.'+#13+#10+'Please register!', mtInformation, [mbOK], 0);
 {$ENDIF}
end;

procedure TSecEditForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
end;

procedure TSecEditForm._OptionsUpdated(Level : Integer);
begin
 if (level=HKO_BigVisible) or (Level=HKO_LiteVisible) then
  SetMemo(memEditor,[msPrimary]);
 memEditor.options:=memEditor.options-[moHideInvisibleLines];
end;

procedure TSecEditForm._SyncScroll(CharPos,LinePos : Integer; Const Path : String; Sender : TObject);
begin
 if (Path=EditScriptInfo.path) and
    (Sender<>self) then
 begin
  memEditor.OnMemoScroll:=nil;
  memeditor.WinCharPos:=CharPos;
  memeditor.WinLinePos:=LinePos;
  memEditor.OnMemoScroll:=memEditorMemoScroll;
 end;
end;

procedure TSecEditForm._OneClosed(si : TObject);
begin
 if SI=EditScriptInfo then
  dockControl.RemoveFromDocking;
end;

procedure TSecEditForm.memEditorMemoScroll(Sender: TObject;
  ScrollStyle: TScrollStyle; Delta: Integer);
begin
 if OPtions.SyncScroll then
  PC_SyncScroll(memEditor.winCharPos,memeditor.WinLinePos,
    EditScriptInfo.path,self);
end;

procedure TSecEditForm.FormDestroy(Sender: TObject);
begin
 iniWriteString(folders.IniFile,iniSecEdit,inttostr(number),EditScriptInfo.path);
 SecEditForms[Number].Window:=nil;
end;

procedure TSecEditForm.FirstShow(Sender: TObject);
begin
 SetMemo(memEditor,[msPrimary]);
 memEditor.options:=memEditor.options-[moHideInvisibleLines];
 EditScriptInfo:=ActiveScriptInfo;
 {$IFDEF SECEDITCRIPPLE}
  memeditor.Enabled:=false;
 {$ENDIF}
 memeditor.MemoSource:=EditScriptInfo.ms;
 caption:=EditScriptINfo.GetCaption;
end;

end.