unit ConfToolFrm; //Modal //VST
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,hyperstr,
  StdCtrls,hakageneral, Mask, menus,activex,OptGeneral,OptProcs,HyperFrm,HakaRandom,
  Buttons, OptFolders, VirtualTrees, ImgList, ActnList, ComCtrls,OptControl,HakaWin,
  ToolWin,hakafile, HKCSVParser,paramfrm,CentralImageListMdl,WorkingFrm,HakaPipes,
  shellapi, DIPcre,Variants,OptOptions,HTTPApp,scriptinfounit,HakaMessageBox,
  HKActions, JvPlacemnt;

type
  PToolItem  = ^TToolItem;
  TToolItem = Record
   Name,Prog,Params,StartDir : String;
   Image : Integer;
   ImageFile : String;
   LeaveOpen : Boolean;
   CommonTool : Boolean;
   ID : String;
  end;

  TPipeType = (ptNone,ptFile,ptSelection,ptProject);

  TConfToolForm = class(TForm)
    OpenDialog: TOpenDialog;
    VST: TVirtualStringTree;
    ToolsActionList: TActionList;
    AddItemAction: TAction;
    DeleteAction: TAction;
    SelectAppAction: TAction;
    CloseAction: TAction;
    CVS: THKCSVParser;
    PopupMenu: TPopupMenu;
    EditCaptionAction: TAction;
    EditParamAction: TAction;
    EditCaption1: TMenuItem;
    EditParameters1: TMenuItem;
    Delete1: TMenuItem;
    BuildParameters1: TMenuItem;
    BuildParamAction: TAction;
    ToolsList: TActionList;
    Pcre: TDIPcre;
    N2: TMenuItem;
    EditProgramAction: TAction;
    Editprogram1: TMenuItem;
    LinePcre: TDIPcre;
    MainMenu: TMainMenu;
    Items1: TMenuItem;
    Add1: TMenuItem;
    Delete2: TMenuItem;
    N4: TMenuItem;
    Close1: TMenuItem;
    oolSettings1: TMenuItem;
    Find1: TMenuItem;
    Editcaption2: TMenuItem;
    EditParameters2: TMenuItem;
    Selectprogram1: TMenuItem;
    Selectprogram2: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    SelectImageAction: TAction;
    N8: TMenuItem;
    SelectImageAction1: TMenuItem;
    N1: TMenuItem;
    FormPlacement: TjvFormPlacement;
    RunAction: TAction;
    N3: TMenuItem;
    estrun1: TMenuItem;
    N7: TMenuItem;
    estrun2: TMenuItem;
    N9: TMenuItem;
    SelectImage1: TMenuItem;
    CopyAction: TAction;
    N10: TMenuItem;
    CopyUserTool1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure VSTGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
    procedure VSTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; Text: WideString);
    procedure VSTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VSTDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure CloseActionExecute(Sender: TObject);
    procedure SelectAppActionExecute(Sender: TObject);
    procedure AddItemActionExecute(Sender: TObject);
    procedure EnabledIfFocusedActionUpdate(Sender: TObject);
    procedure DeleteActionExecute(Sender: TObject);
    procedure VSTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure CVSSetData(Sender: TObject; const Data: array of String);
    function CVSReadNewLine(Sender: TObject; var Line: String;
      LineNum: Integer): Boolean;
    procedure VSTColumnClick(Sender: TBaseVirtualTree; Column: TColumnIndex;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditCaptionActionExecute(Sender: TObject);
    procedure BuildParamActionExecute(Sender: TObject);
    procedure VSTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure EditProgramActionExecute(Sender: TObject);
    procedure SelectImageActionExecute(Sender: TObject);
    procedure EditParamActionExecute(Sender: TObject);
    procedure RunActionExecute(Sender: TObject);
    procedure CopyActionExecute(Sender: TObject);
    procedure CopyActionUpdate(Sender: TObject);
    procedure VSTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
  private
    AddedTools : Boolean;
    Procedure MoveData;
    Procedure AddNew;
    Procedure AddData(const Name,prog,params,startdir : string; Const Image : String; LeaveOpen : Boolean; Const ID : string; Common : Boolean = false);
    procedure ToolExecute(Sender: TObject);
    procedure savetools;
    Function GetNewShortCut:TShortCut;
    procedure ResetImages;
    procedure AnalyzeRun(Sender: THKAction; out Prog, Param, Dir: String; out IsPipe: Boolean);
    procedure GetPipeData(var Param: String; out LineGet, LineSend: Boolean;
            out InFile,OutFile : String; out PipeGet, PipeSend: TPipeType);
    procedure AfterPipe(LineGet: Boolean; PipeGet: TpipeType;
      SL: TStringList);
    procedure ReadyPipe(Active : TScriptInfo; LineSend: Boolean; PipeSend: TpipeType; const InFile: String);
   public
    function GetActionIndex(Action: TObject): Integer;
  end;

const
 ToolHeader = 'Tool_';

var
 ConfToolForm: TConfToolForm;

implementation

{$R *.DFM}

procedure TConfToolForm.AddData(const Name, prog, params,StartDir: string; Const Image : String; LeaveOpen : Boolean; Const ID : string; Common : Boolean = false);
var
 item : PToolItem;
 Node : PVirtualNode;
begin
 Node:=vst.AddChild(nil);
 Item:=VST.GetNodeData(node);
 item.Name:=name;
 item.prog:=prog;
 item.StartDir:=startdir;
 item.ID:=ID;
 item.Params:=params;
 item.CommonTool:=Common;
 item.LeaveOpen:=LeaveOpen;
 Item.ImageFile:=Image;
 Item.Image:=CentralImageListMod.GetImage(ID,Image);
end;

Procedure TConfToolForm.addnew;
var
 UT,f,p:string;
begin
 ut:='%opti%Tools.icl,';
 addData('Explore c:\perl','Explorer','c:\perl','',ut+'0',false,'User_0');
 f:='c:\perl\html\index.html';
 p:='';
 if not fileexists(f) then
 begin
  p:=extractfilepath(f);
  f:='Explorer';
 end;
 addData('Perl Documentation',f,p,'',ut+'70',false,'User_1');
 addData('Pod2Html','c:\perl\bin\pod2html.bat','-infile=%PathSn% %n<pod - %filenoext%.html>%%getfile%','',ut+'116',true,'User_2');
 addData('Start Apache','c:\apache\apache.exe','-f "c:/apache/conf/httpd.conf"','',ut+'69',false,'User_3');
 addData('Stop Apache','c:\apache\apache.exe','-f "c:/apache/conf/httpd.conf" -k shutdown','',ut+'69',false,'User_4');
 addData('Open Console','chdir','/d "%folder%"','',ut+'3',true,'User_5');
 addData('Indent selected lines with tabs',ProgramPath+'TabIndentSelection.pl','%SENDSELECTION%%GETSELECTION%','',ut+'16',false,'User_6');

 if Win32Platform = VER_PLATFORM_WIN32_NT
  then f:=includetrailingbackslash(GetWinDir)+'system32\drivers\etc\hosts'
  else f:=includetrailingbackslash(GetWinDir)+'hosts';

 addData('Map local IP to project',programpath+'MapIp.pl','%data7% "'+f+'"','',ut+'81',false,'User_7');
 addData('Unmap local IP to project',programpath+'UnMapIp.pl','%data7% "'+f+'"','',ut+'81',false,'User_8');
 addData('Open HOSTS file','','%o<'+f+'>%','',ut+'50',false,'User_9');

 addData('CVS Login','cvs.exe','-d %data0% login','',ut+'152',true,'CVS_Login');
 addData('CVS Checkout','cvs.exe','-d %data0% checkout -P %data1%','%data2%',ut+'149',true,'CVS_Checkout');
 addData('CVS Update','cvs.exe','-d %data0% update -d -P -R','%data3%',ut+'149',true,'CVS_Update');
 addData('CVS Commit','cvs.exe','-d %data0% commit -m"%querybox%"','%data3%',ut+'150',true,'CVS_Commit');
 addData('CVS Diff','cvs.exe','-d %data0% diff -c %pathSN%%n<diff - %fileNoExt%>%%getfile%','%folder%',ut+'154',false,'CVS_Diff');
 addData('CVS Log of file','cvs.exe','-d %data0% log %pathSN% %n<log - %fileNoExt%>%%getfile%','%folder%',ut+'155',false,'CVS_LogFile');
 addData('CVS Go to line',ProgramPath+'CVSGotoline.pl','%SENDFILE%%GETLINE%%SENDLINE%','',ut+'153',false,'CVS_Gotoline');

end;

procedure TConfToolForm.FormCreate(Sender: TObject);
var
 s:string;
begin
 VST.Font.Name:=hakawin.DefMonospaceFontName;
 if fileexists(Folders.ToolFile)
 then
  try
   cvs.Tag:=0;
   CVS.LoadFromFile(folders.ToolFile);
   if cvs.Tag=2 then
   begin
    addnew;
    SaveTools;
   end;

   if OptiRel = orCom then
   begin
    cvs.Tag:=1;
    s:=IncludeTrailingBackSlash(options.CommonFolder)+'Tools.csv';
    if (AnsicompareText(s,folders.ToolFile)<>0) and (fileexists(s)) then
     CVS.LoadFromFile(s);
   end;

  except
   on exception do addnew;
  end
 else
  begin
   addnew;
   SaveTools;
  end;
 MoveData;
end;

Function TConfToolForm.GetActionIndex(Action : TObject) : Integer;
var i:integer;
begin
 result:=-1;
 for i:=0 to ToolsList.ActionCount-1 do
  if ToolsList.Actions[i]=Action then
  begin
   result:=i;
   exit;
  end;
end;

Function TConfToolForm.GetNewShortCut:TShortCut;
var
 i,p:integer;
 sh : TList;
begin
 sh:=TList.create;
 try
  for i:=0 to 25 do //letter
   sh.Add(pointer(ShortCut(i+65, [ssCtrl,ssAlt])));
  for i:=0 to 9 do //numbers
   sh.Add(pointer(ShortCut(i+48, [ssCtrl,ssAlt])));

  for i:=0 to toolsList.ActionCount-1 do
  begin
   p:=sh.IndexOf(pointer(TAction(toolslist.Actions[i]).ShortCut));
   if p>=0 then
    sh.Delete(p);
  end;

  if sh.Count>0
   then result:=TShortCut(sh[0])
   else result:=0;

 finally
  sh.free;
 end;
end;

procedure TConfToolForm.MoveData;
var
 item : PToolItem;
 Node : PVirtualNode;
 j,i:integer;
 Action : THKAction;
 sl : TStringList;
begin
 ResetImages;
 sl:=TStringList.Create;
 sl.Sorted:=true;
 sl.CaseSensitive:=true;
 PR_ToolsUpdating(true,false);
 try

 for j:=0 to toolsList.ActionCount-1 do
  sl.AddObject(toolsList.actions[j].Name,toolsList.actions[j]);

 node:=vst.GetFirst;
 while assigned(node) do
 begin
  item:=vst.GetNodeData(node);

  j:=sl.IndexOf(ToolHeader+item.ID);
  if j<0 then
   begin
    action:=THKAction.Create(self);
    AddedTools:=true;
    try
     Action.Name:=ToolHeader+item.ID;
    except on exception do
     begin
      node:=vst.GetNext(node);
      Action.free;
      continue;
     end;
    end;
    Action.ShortCut:=GetNewShortCut;
   end
  else
   begin
    Action:=THKAction(sl.objects[j]);
    sl.Delete(j);
   end;

  action.Caption:=item.Name;
  Action.Category:='User tools';
  Action.OnExecute:=ToolExecute;
  Action.ImageIndex:=item.Image;
  action.Hint:=Item.Name+#13#10+Item.Prog+#13#10+item.Params+#13#10+item.StartDir+#13#10;
  if item.LeaveOpen
   then action.Tag:=1
   else action.Tag:=0;
  action.ActionList:=ToolsList;
  node:=vst.GetNext(node);
 end;

 for i:=0 to sl.Count-1 do
 begin
  j:=GetActionIndex(sl.Objects[i]);
  if j>=0 then ToolsList.Actions[j].Free;
 end;
 sl.free;

 finally
  PR_ToolsUpdating(false,false);
 end;
end;

procedure TConfToolForm.VSTGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
 NodeDataSize:=Sizeof(TTOolItem);
end;

procedure TConfToolForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
var
 item : PToolItem;
begin
 Item:=VST.GetNodeData(node);
 case column of
  0 : text:=item.name;
  1 : text:=extractFilename(item.Prog);
  2 : text:=item.Params;
 end;
end;

procedure TConfToolForm.VSTNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; Text: WideString);
var
 item : PToolItem;
begin
 Item:=VST.GetNodeData(node);
 case column of
  0 : item.name:=text;
  1 : item.Prog:=text;
  2 : item.Params:=text;
 end;
 if (column=0) and (text='') then begin
  MessageDlg('A caption is needed for the tool item.', mtError, [mbOK], 0);
  item.name:='Tool';
 end;
end;

procedure TConfToolForm.VSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  I: Integer;
  AttachMode: TVTNodeAttachMode;
begin
    for I := 0 to High(Formats) do
      if Formats[I] = CF_VIRTUALTREE then
      begin
        case Mode of
          dmAbove: AttachMode := amInsertBefore;
          dmOnNode,dmbelow: AttachMode := amInsertAfter;
        end;
      end;
 Sender.ProcessDrop(DataObject, Sender.DropTargetNode, Effect, AttachMode);
end;

procedure TConfToolForm.VSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
 Accept:=mode<>dmNowhere;
end;

procedure TConfToolForm.CloseActionExecute(Sender: TObject);
begin
 Close;
end;

procedure TConfToolForm.SelectAppActionExecute(Sender: TObject);
var
 item : PToolItem;
 Node : PVirtualNode;
begin
 node:=vst.FocusedNode;
 if not assigned(node) then exit;
 item:=VST.GetNodeData(node);
 OpenDialog.InitialDir:=ExtractFilePath(item.Prog);
 openDialog.FileName:=item.prog;
 if opendialog.Execute then
  item.Prog:=opendialog.FileName;
end;

procedure TConfToolForm.CopyActionExecute(Sender: TObject);
var
 node : PVirtualNode;
 Data,od: PToolItem;
begin
 od:=vst.GetNodeData(vst.FocusedNode);

 node:=vst.InsertNode(vst.FocusedNode,amInsertAfter);
 data:=vst.GetNodeData(node);
 data.Name:='Copy of '+od.Name;
 data.Prog:=od.Prog;
 data.StartDir:=od.StartDir;
 data.Params:=od.Params;
 data.Image:=od.Image;
 data.ImageFile:=od.ImageFile;
 data.ID:=RandomString(16);
 data.LeaveOpen:=od.LeaveOpen;
 data.CommonTool:=false;
 vst.focusednode:=node;
end;

procedure TConfToolForm.CopyActionUpdate(Sender: TObject);
var
 Data: PToolItem;
begin
 data:=vst.GetNodeData(vst.FocusedNode);
 CopyAction.Enabled:=assigned(data);
end;

procedure TConfToolForm.AddItemActionExecute(Sender: TObject);
var
 node : PVirtualNode;
 Data: PToolItem;
begin
 node:=vst.InsertNode(vst.FocusedNode,amInsertAfter);
 data:=vst.GetNodeData(node);
 data.Name:='New Tool';
 data.Prog:='';
 data.StartDir:='';
 data.Params:='Enter Parameters';
 data.Image:=DefToolIcon;
 data.ImageFile:='';
 data.ID:=RandomString(16);
 data.LeaveOpen:=true;
 data.CommonTool:=false;
 vst.focusednode:=node;
end;

procedure TConfToolForm.EnabledIfFocusedActionUpdate(Sender: TObject);
var
 Data: PToolItem;
begin
 data:=vst.GetNodeData(vst.FocusedNode);
 TAction(sender).Enabled:=Assigned(data) and (not data.CommonTool);
end;

procedure TConfToolForm.DeleteActionExecute(Sender: TObject);
begin
 if MessageDlg('Are you sure you want to delete tool?', mtConfirmation, [mbOK,mbCancel], 0) = mrOk then
  VST.DeleteNode(vst.focusednode);
end;

procedure TConfToolForm.VSTEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
var
 Data: PToolItem;
begin
 data:=vst.GetNodeData(node);
 allowed:=not data.CommonTool;
end;

procedure TConfToolForm.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
 Data1: PToolItem;
 Data2: PToolItem;
 s1,s2 : string;
begin
 Data1:=sender.GetNodeData(node1);
 data2:=sender.GetNodeData(node2);
 case column of
  0 : begin s1:=data1.Name; s2:=data2.Name end;
  1 : begin s1:=data1.Prog; s2:=data2.Prog end;
  2 : begin s1:=data1.Params; s2:=data2.params end;
 end;
 result:=strcomp(pchar(s1),pchar(s2));
end;

procedure TConfToolForm.CVSSetData(Sender: TObject;
  const Data: array of String);
begin
 if length(data)=3 then
 begin
  if (data[0]<>'Explore c:\perl') and
     (data[0]<>'Perl Documentation') and
     (data[0]<>'Pod2Html') and
     (data[0]<>'Start Apache') and
     (data[0]<>'Stop Apache') and
     (data[0]<>'Open Console') then
  AddData(data[0],data[1],data[2],'','0',false,RandomString(16));
  CVS.Tag:=2;
 end;
 if length(data)=7 then
  AddData(data[0],data[1],data[2],data[3],data[4],data[5]='1',data[6],cvs.Tag=1);
end;

function TConfToolForm.CVSReadNewLine(Sender: TObject; var Line: String;
  LineNum: Integer): Boolean;
begin
 result:=not StringStartsWithCase('"Name","Execute","Parameters"',line);
end;

procedure TConfToolForm.VSTColumnClick(Sender: TBaseVirtualTree;
  Column: TColumnIndex; Shift: TShiftState);
begin
 if shift=[ssRight]
  then VST.EditNode(vst.focusednode,column);
end;

procedure TConfToolForm.savetools;
var
 item : PToolItem;
 Node : PVirtualNode;
const
 lstr : array[boolean] of char = ('0','1');
begin
 CVS.Lines.Clear;
 node:=VST.GetFirst;
 while assigned(node) do begin
  item:=vst.GetNodeData(node);
  if not item.CommonTool then
   cvs.AddData([item.Name,item.Prog,item.Params,item.startdir,
    item.ImageFile,lstr[item.leaveopen],item.ID]);
  node:=vst.GetNext(node);
 end;
 CVS.SaveToFile(Folders.ToolFile);
 MoveData;
end;

procedure TConfToolForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 SaveTools;
 if AddedTools then
 begin
  MessageDlgMemo('New tools were added. '+#13+#10+''+#13+#10+'You can now customize their position in the menus and toolbars, from the'+#13+#10+'"Customize toolbars" item / User tools category.', mtInformation, [mbOK], 0, 2700);
  AddedTools:=false;
 end;
end;

procedure TConfToolForm.EditCaptionActionExecute(Sender: TObject);
begin
 VST.EditNode(VST.focusedNode,0);
end;

procedure TConfToolForm.BuildParamActionExecute(Sender: TObject);
var
 item : PToolItem;
begin
 if not assigned(vst.focusednode) then exit;
 item:=vst.GetNodeData(vst.focusednode);
 ParamForm:=TParamForm.Create(application,ptParams);
 ParamForm.FormStorage.IniSection:='ConfToolsParams';
 ParamForm.FormStorage.RestoreFormPlacement;
 ParamForm.FormStorage.Active:=false;
 try
  paramform.edParams.text:=item.Params;
  paramform.edStartDir.text:=item.StartDir;
  paramform.CbLeaveOpen.Checked:=item.LeaveOpen;
  if paramform.ShowModal=mrOK then
  begin
   item.Params:=paramform.edParams.text;
   item.StartDir:=paramform.edStartDir.Text;
   item.LeaveOpen:=paramform.CbLeaveOpen.Checked;
  end;
 finally
  ParamForm.FormStorage.Active:=true;
  paramform.free;
 end;
end;

procedure TConfToolForm.VSTHeaderClick(Sender: TVTHeader; Column: TColumnIndex;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if vst.Header.SortDirection = sdAscending
  then vst.Header.SortDirection:=sdDescending
  else vst.Header.SortDirection:=sdAscending;
 VST.Header.SortColumn:=column;
 VST.Sort(nil,column,vst.header.sortdirection);
end;

procedure TConfToolForm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
 item : PToolItem;
begin
 if (column=0) and (kind in [ikNormal,ikSelected]) then
 begin
  item:=VST.GetNodeData(node);
  imageindex:=item.Image;
  if imageindex<0 then
   ImageIndex:=DefToolIcon;
 end;
end;

procedure TConfToolForm.AnalyzeRun(Sender : THKAction; Out Prog,Param,Dir: String; out IsPipe : Boolean);
const
 CProg=1; CParam=2; CStartDir=3;
var
 sl : TStringList;
 LOpen : BOolean;
 Ext : String;
 c:char;
 doCMD,doLeaveOpen : Boolean;
begin
 IsPipe:=false;

 sl:=TStringList.Create;
 try
  sl.Text:=THKAction(sender).Hint;
  LOpen:=THKAction(Sender).Tag=1;
  Prog:=trim(sl[CProg]);
  Param:=trim(sl[Cparam]);
  dir:=trim(sl[Cstartdir]);
 finally
  sl.free;
 end;

 if Param<>'' then
  PC_TagConvert(Param);
 if (Prog='') or (Param=#0) then
 begin
  prog:='';
  exit;
 end;

 if (Dir='') then
  begin
   if fileexists(Prog) then
    dir:=ExtractFilePath(Prog);
  end
 else
  PC_TagConvert(dir);

 ext:=UpFileExt(Prog);
 if (Ext='PL') or (Ext='PLX') or (Ext='CGI') then
 begin
  Param:='"'+Prog+'" '+Param;
  Prog:=options.PathToPerl;   //extractshortpathname
 end;

 isPipe:=pcre.MatchStr(Param)=3;

 DoCMD:=IsPipe or LOpen;
 DoLeaveOpen:=(LOpen) and (not IsPipe);

 if DoCMD then
 begin
  if DoLeaveOpen
   then c:='K'
   else c:='C';
  if fileexists(prog) then
   Prog:=ExtractShortPathName(prog);
  Param:='/'+c+' '+Prog+' '+Param;
  Prog:=GetComSpec;
 end;

 if IsPipe then
  dir:=gettmpdir;
end;

procedure TConfToolForm.GetPipeData(var Param : String;
        out LineGet,LineSend : Boolean;
        out InFile,OutFile : String;
        out PipeGet,PipeSend : TPipeType);
var
 p:string;
begin
 InFile:='';
 OutFile:='';
 PipeGet:=ptNone;
 PipeSend:=ptNone;
 LineGet:=false;
 LineSend:=false;
 while pcre.MatchStr(param)=3 do
 begin
    p:=Uppercase(pcre.MatchedStr);
    delete(p,1,1);
    setlength(p,length(p)-1);
    if p='GETFILE' then PipeGet:=ptFile else
    if p='GETPROJECT' then PipeGet:=ptProject else
    if p='GETSELECTION' then PipeGet:=ptSelection;
    if p='GETLINE' then LineGet:=true;

    if p='SENDFILE' then PipeSend:=ptFile else
    if p='SENDPROJECT' then PipeSend:=ptProject else
    if p='SENDSELECTION' then PipeSend:=ptSelection;
    if p='SENDLINE' then LineSend:=true;

    Delete(param,pcre.MatchedStrFirstCharPos+1,pcre.MatchedStrLength);
 end;

 if (PipeSend<>ptNone) or (LineSend) then
 begin
  InFile:=optGeneral.GetTempFile;
  Param:=Param+' <'+ExtractFilename(InFile);
 end;

 if (PipeGet<>ptNone) or (LineGet) then
 begin
  OutFile:=optGeneral.GetTempFile;
  Param:=Param+' >'+ExtractFilename(outfile);
 end;
end;

procedure TConfToolForm.AfterPipe(LineGet : Boolean; PipeGet : TpipeType; SL : TStringList);
var
 GoLine : Boolean;
 Path : String;
 Y : Integer;
 s:string;
begin
 GoLine:=false;
 if (LineGet) and (sl.Count>0) then
 begin
  s:=sl[0];
  sl.Delete(0);
  if linepcre.MatchStr(s)=3 then
  begin
   y:=strtoint(linepcre.SubStr(1));
   path:=linepcre.SubStr(2);
   GoLine:=true;
  end;
 end;

 case pipeGet of
  ptFile : PC_PipeTool(HKP_GET_FILE,sl,ActiveScriptInfo);
  ptSelection : PC_PipeTool(HKP_GET_SELECTION,sl,ActiveScriptInfo);
  ptProject: PC_PipeTool(HKP_GET_PROJECT,sl,ActiveScriptInfo);
 end;

 PR_ExtToolRan;
 if GoLine then
  PR_GotoLine(path,y);
end;

procedure TConfToolForm.ReadyPipe(Active : TScriptInfo; LineSend : Boolean; PipeSend : TpipeType; Const InFile : String);
var
 sl:TStringList;
 s:string;
begin
 if InFile='' then exit;

 sl:=TStringList.Create;
 try
  case pipeSend of
   ptFile : PC_PipeTool(HKP_SEND_FILE,SL,Active);
   ptSelection : PC_PipeTool(HKP_SEND_SELECTION,SL,Active);
   ptProject: PC_PipeTool(HKP_SEND_PROJECT,sl,Active);
  end;
  if linesend then
   sl.Insert(0,format('%d'#9'%s',[Active.ms.caretpoint.y,Active.path]));

  s:=sl.Text;
  while stringendswith(#13#10#13#10,s) do SetLength(s,length(s)-2);
  SaveStr(s,infile);
 finally
  sl.Free;
 end;
end;

procedure TConfToolForm.ToolExecute(Sender: TObject);
var
 Prog,Param,Dir,InFile,OutFile : String;
 PipeGet,PipeSend : TPipeType;
 LineGet,LineSend : Boolean;

 GUI : THKGui;
 SL : TStringList;
 IsPipe : Boolean;
 DialogTime : Cardinal;
 Active : TScriptInfo;
begin
 Active:=ActiveScriptInfo;
 AnalyzeRun(THKAction(sender),Prog,Param,Dir,IsPipe);
 if Prog='' then exit;

 if not ispipe then
  begin
   ShellExecute(application.Handle,'open',pchar(prog),
         pchar(param),pchar(Dir),SW_SHOW);
   PR_ExtToolRan;
  end
 else
  begin
   GetPipeData(param,lineget,linesend,InFile,OutFile,pipeget,pipesend);
   GUI:=THKGUI.Create;
   try
    GUI.AppName:=prog;
    GUI.CmdLine:=param;
    GUI.HomeDir:=dir;
    DialogTime:=GetTickCount+400;

    ReadyPipe(Active,LineSend,PipeSend,InFile);

    gui.Start;

    if gui.PipeStatus=psNormal then
    begin
     DisableApplication;
     try
      repeat
       gui.Read;
       if (WorkingForm=nil) and (GetTickCount>Dialogtime) then
        WorkingForm:=TWorkingForm.Create(Application);
       if (WorkingForm<>nil) and (WorkingForm.Terminate) then
        break;
       Application.ProcessMessages;
      until gui.PipeStatus = psTerminated;
     finally
      enableapplication(WorkingForm<>nil);
      if WorkingForm<>nil then
       WorkingForm.Free;
     end;

     if (pipeget=ptNone) and (not lineget) and (length(GUI.Output)>0) then
      MessageDlg(GUI.Output, mtInformation, [mbOK], 0);

     if fileexists(outFile) then
     begin
      sl:=TStringList.Create;
      try
       sl.LoadFromFile(outfile);
       AfterPipe(LineGet,PipeGet,sl);
      finally
       sl.free;
      end;
     end;

     DeleteFile(inFile);
     DeleteFile(outFile);
    end;

   finally
    gui.Free;
   end;
  end;
end;

procedure TConfToolForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 TI : PToolItem;
begin
 ti:=VST.GetNodeData(node);
 with ti^ do
 begin
  SetLength(Name,0);
  SetLength(Prog,0);
  SetLength(Params,0);
  SetLength(StartDir,0);
  SetLength(ID,0);
 end;
end;

procedure TConfToolForm.EditProgramActionExecute(Sender: TObject);
begin
 VST.EditNode(VST.focusedNode,1);
end;

procedure TConfToolForm.SelectImageActionExecute(Sender: TObject);
var
 item : PToolItem;
 s:string;
begin
 if not assigned(vst.focusednode) then exit;
 item:=vst.GetNodeData(vst.focusednode);

 s:=CentralImageListMod.SelectIcon(Item.ImageFile);
 if Item.ImageFile<>s then
 begin
  Item.ImageFile:=s;

  ResetImages;
 end;
end;

procedure TConfToolForm.ResetImages;
var
 item : PToolItem;
 Node : PVirtualNode;
begin
 PR_ToolsUpdating(true,true);
 try
  CentralImageListMod.DeleteImages;
  Node:=VST.GetFirst;
  while assigned(node) do
  begin
   item:=VST.getNodeData(node);
   item.Image:=CentralImageListMod.GetImage(item.ID,item.ImageFile);
   node:=VST.GetNext(node);
  end;
 finally
  PR_ToolsUpdating(false,true);
 end;
end;

procedure TConfToolForm.EditParamActionExecute(Sender: TObject);
begin
 VST.EditNode(VST.focusedNode,2);
end;

procedure TConfToolForm.RunActionExecute(Sender: TObject);
var
 i:integer;
 item : PToolItem;
begin
 item:=vst.GetNodeData(vst.FocusedNode);
 MoveData;
 for i:=0 to toolsList.ActionCount-1 do
  if ToolsList.Actions[i].Name=ToolHeader+item.ID then
  begin
   THKAction(ToolsList.Actions[i]).SimpleExecute;
   break;
  end;
end;

procedure TConfToolForm.VSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
 item : PToolItem;
begin
 if not assigned(node) then exit;
 item:=VST.GetNodeData(node);
 case column of
  0 : HintText:=Item.name;
  1 : begin
   HintText:=item.Prog;
   if item.StartDir<>''
    then HintText:=HintText+#13#10+'Will execute in folder '+item.StartDir;
  end;
  2 : HintText:=item.Params;
 end;
end;

end.
