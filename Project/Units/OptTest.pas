{***************************************************************
 *
 * Unit Name: OptTest
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}
 
unit OptTest;
{$I REG.INC}

interface
uses sysutils,windows,classes,editorfrm,messages,hakaGeneral,forms,ExplorerFrm,
     OptGeneral,controls,HakaFile,HyperStr,HKDebug,OptProcs,Recorder,OptOptions;

Procedure TTToggleRecord;
Procedure TTRunTest;
Procedure TTLoadTestLayout;

implementation

Procedure TTLoadTestLayout;
var
 sl : TStringList;
 i:integer;
 TestPath : String;
begin
 TestPath:=ProgramPath+'Tests';
 EditorForm.CloseAllAction.SimpleExecute;
 PR_LoadLayout('');
 EditorForm.OpenDialog.InitialDir:=TestPath;
 EditorForm.SaveDialog.InitialDir:=TestPath;
 Application.ProcessMessages;
 sl:=TStringList.create;
 GetFilelist(TestPath,'*.html',true,faArchive,sl);
 GetFilelist(TestPath,'*.pl',true,faArchive,sl);
 for i:=0 to sl.Count-1 do
  PR_OpenFile(sl[i]);
 SetForegroundWindow(Application.mainform.handle);
 PR_FocusEditor;
 TheRecorder:=TRecorder.Create;
end;

Procedure TTToggleRecord;
begin
 if TheRecorder.State=rsRecording then
  begin
   TheRecorder.DoStop;
   TheRecorder.Stream.SaveToFile(ProgramPath + 'tests\~.dat');
  end
 else
  TheRecorder.DoRecord(false);
end;

Procedure TTRunTest;
var
 i:integer;
 Cancel:boolean;
begin
 TTLoadTestLayout;
 TheRecorder.stream.loadfromfile(ProgramPath + 'tests\~.dat');
 i:=0;
 Cancel:=false;

 repeat
  TheRecorder.SpeedFactor:=20+random(180);
  Assert(false,'LOG TEST '+inttostr(TheRecorder.SpeedFactor));

  TheRecorder.DoPlay;
  while therecorder.State=rsPlaying do
  begin
   application.ProcessMessages;
   if GetAsyncKeyState(VK_SHIFT) < 0 then
   begin
    TheRecorder.DoStop;
    Cancel:=true;
   end;
  end;

  editorform.saveallaction.SimpleExecute;
  inc(i);
 until Cancel;

 Assert(false,'LOG TEST TERMINATED');
 SleepAndProcess(2000);
end;

Initialization
finalization
 if assigned(TheRecorder) then
  Therecorder.Free;
end.
