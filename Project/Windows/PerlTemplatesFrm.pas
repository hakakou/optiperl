unit PerlTemplatesFrm; //Modal //Memo 1 //VST //Splitter

interface

uses Windows, Forms, ImgList, Controls, Menus, Classes, ActnList,
  dcstring, dcsystem, dcparser, ComCtrls, ToolWin, ExtCtrls, dccommon,HakaFile,
  dcmemo, VirtualTrees,activex,dialogs,OptGeneral,OptFolders,sysutils,
  hyperstr, ParsersMdl, scriptinfounit,OptProcs,
  hkstreams,OptOptions,CentralImageListMdl, JvPlacemnt;

type
  TTemplate = Record
   Name,Desc,Data : string;
  end;
  PTemplate = ^TTemplate;

  TTemplateForm = class(TForm)
    Splitter: TSplitter;
    VST: TVirtualStringTree;
    MemTem: TDCMemo;
    TemSource: TMemoSource;
    TemActionList: TActionList;
    AddItemAction: TAction;
    DeleteAction: TAction;
    EditMenu: TPopupMenu;
    AddItem1: TMenuItem;
    ExpandAll2: TMenuItem;
    N3: TMenuItem;
    SaveAction: TAction;
    SaveNow1: TMenuItem;
    OpenDialog: TOpenDialog;
    ImportAction: TAction;
    ImportTemplates1: TMenuItem;
    FormStorage: TjvFormStorage;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    EditNameAction: TAction;
    EditDescAction: TAction;
    N1: TMenuItem;
    EditName1: TMenuItem;
    EditDescription1: TMenuItem;
    procedure VSTLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure VSTSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure XFormCreate(Sender: TObject);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
    procedure VSTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; Text: WideString);
    procedure VSTFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, Newcolumn: TColumnIndex;
      var Allowed: Boolean);
    procedure MemTemStateChange(Sender: TObject; State: TMemoStates);
    procedure AddItemActionExecute(Sender: TObject);
    procedure DeleteActionExecute(Sender: TObject);
    procedure XFormShow(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure XFormDestroy(Sender: TObject);
    procedure ImportActionExecute(Sender: TObject);
    procedure VSTDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VSTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; column: TColumnIndex; var Result: Integer);
    procedure EditNameActionExecute(Sender: TObject);
    procedure EditDescActionExecute(Sender: TObject);
    procedure EnabledIfFocused(Sender: TObject);
    procedure VSTHeaderClick(Sender: TVTHeader; column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    Modified : Boolean;
    Procedure GetTemplates;
    Procedure SetTemplates;
    procedure ForEachCallback(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
    procedure ImportFile(const FileName: string);
    procedure ExportFile(const FileName: string);
  end;

var
 TemplateForm: TTemplateForm;

implementation

{$R *.DFM}

procedure TTemplateForm.XFormCreate(Sender: TObject);
begin
 Splitter.Width:=OptiSplitterWidth;
 SetMemo(memTem,[msModal]);
 VST.NodeDataSize:=sizeOf(TTEmplate);
 if fileexists(Folders.templatefile) then
 begin
   try
    ImportFile(Folders.templatefile);
   except
    MessageDlg('Could not open editor templates.', mtError, [mbOK], 0);
   end;
 end;
 SetTemplates;
end;

procedure TTemplateForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
var
  Data: PTemplate;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
   case column of
    0 : Text:=data.Name;
    1 : Text:=data.desc;
   end;
end;

procedure TTemplateForm.VSTNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; Text: WideString);
var
  Data: PTemplate;
begin
  modified:=true;
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
   case column of
    0 : data.Name :=TExt;
    1 : data.desc :=text;
   end;
  if (column=0) and (text='') then begin
   MessageDlg('A name is needed for the item.', mtError, [mbOK], 0);
   data.Name:='Template';
  end;
end;

procedure TTemplateForm.VSTFocusChanging(Sender: TBaseVirtualTree; OldNode,
  NewNode: PVirtualNode; OldColumn, Newcolumn: TColumnIndex;
  var Allowed: Boolean);
var
  Data: PTemplate;
begin
  memtem.OnStateChange:=nil;
  Data := Sender.GetNodeData(NewNode);
  if Assigned(Data) then
   TemSource.Lines.Text:=data.Data;
  memtem.OnStateChange:=memtemStateChange;
  memtem.ReadOnly:=false;
end;

procedure TTemplateForm.MemTemStateChange(Sender: TObject;
  State: TMemoStates);
var
  Node: PVirtualNode;
  Data: PTemplate;
begin
  if MsEdited in state then begin
    modified:=true;
    Node:=vst.FocusedNode;
    Data := VST.GetNodeData(Node);
    if assigned(data) then
      data.Data:=temSource.lines.text;
  end;
end;

procedure TTemplateForm.AddItemActionExecute(Sender: TObject);
var
 node : PVirtualNode;
 Data: PTemplate;
begin
 modified:=true;
 node:=vst.InsertNode(vst.FocusedNode,amInsertAfter);
 data:=vst.GetNodeData(node);
 data.Name:='New Template';
 data.Desc:='Enter Description';
 data.Data:='';
 vst.Expanded[vst.FocusedNode]:=true;
 vst.Selected[node]:=true;
 vst.focusednode:=node;
end;

procedure TTemplateForm.VSTDragDrop(Sender: TBaseVirtualTree;
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
 memtem.ReadOnly:=not assigned(sender.focusednode);
 modified:=true;
end;

procedure TTemplateForm.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; column: TColumnIndex; var Result: Integer);
var
 Data1: PTEmplate;
 Data2: PTEmplate;
 s1,s2 : string;
begin
 Data1:=sender.GetNodeData(node1);
 data2:=sender.GetNodeData(node2);
 case column of
  0 : begin s1:=data1.name; s2:=data2.Name end;
  1 : begin s1:=data1.desc; s2:=data2.desc end;
 end;
 result:=strcomp(pchar(s1),pchar(s2));
end;

procedure TTemplateForm.DeleteActionExecute(Sender: TObject);
begin
 if not assigned(vst.focusednode) then exit;
 if (vst.FocusedNode.ChildCount>0) and
    (MessageDlg('Delete template?', mtWarning,
       [mbYes, mbCancel], 0)=mrCancel) then exit;

 VST.DeleteNode(vst.focusednode);
 if not assigned(Vst.focusednode) then
 begin
  memtem.ReadOnly:=true;
  temsource.lines.text:='';
 end;
end;

procedure TTemplateForm.GetTemplates;
var
  i:integer;
  Node: PVirtualNode;
  Data: PTemplate;
begin
 for i:=0 to PerlTemplates.Count -1 do
 begin
  node:=vst.addchild(nil);
  data:=vst.GetNodeData(node);
  data.Name:=PerlTemplates.Items[i].Name;
  data.Desc:=PerlTEmplates.Items[i].Description;
  data.data:=PerlTEmplates.Items[i].Code.Text;
 end;
 modified:=true;
end;

procedure TTemplateForm.SetTemplates;
begin
 PerlTemplates.Clear;
 vst.IterateSubtree(nil,foreachcallback,nil);
end;

procedure TTemplateForm.VSTSaveNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);

var
  Data: PTEmplate;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then
  begin
    WriteStr(data.name,stream);
    WriteStr(data.desc,stream);
    WriteStr(data.data,stream);
  end;
end;

procedure TTemplateForm.VSTLoadNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);

var
  Data: PTemplate;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then begin
   data.Name:=ReadStr(stream);
   data.Desc:=ReadStr(stream);
   data.data:=ReadStr(stream);
  end;
end;

procedure TTemplateForm.ForEachCallback(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
  aData: PTemplate;
  T : TmemoCodeTemplate;
begin
 adata:=sender.GetNodeData(node);
 t:=TMemoCodeTemplate(PerlTEmplates.Add);
 t.Name:=adata.Name;
 t.Description:=adata.Desc;
 t.Code.text:=adata.Data;
end;

procedure TTemplateForm.XFormShow(Sender: TObject);
begin
 memtem.ReadOnly:=not assigned(Vst.focusednode);
end;

procedure TTemplateForm.SaveActionExecute(Sender: TObject);
begin
 ExportFile(Folders.TemplateFile);
end;

procedure TTemplateForm.XFormDestroy(Sender: TObject);
begin
 SetTemplates;
 if modified then
 begin
  SaveActionExecute(sender);
  PR_TemplatesUpdated(perlTemplates);
 end;
end;

procedure TTemplateForm.ImportActionExecute(Sender: TObject);
begin
 if opendialog.Execute then
 begin
  ImportFile(OpenDialog.FileName);
  modified:=True;
 end;
end;

procedure TTemplateForm.ExportFile(const FileName : string);
var
 sl : TStringList;
 Node: PVirtualNode;
 Data: PTemplate;
begin
  sl:=TStringList.Create;
  try
   Node:=vst.GetFirst;
   data:=vst.getnodedata(Node);
   repeat
    ReplaceC(data.Name,'|','/');
    sl.Add('[ '+data.Name+' | '+data.Desc+' ]');
    sl.Add(data.Data);
    Node:=vst.GetNext(Node);
    if Assigned(Node) then data:=vst.getnodedata(Node);
   until Node=nil;
   sl.SaveToFile(filename);
  finally
   sl.Free;
  end;
end;

procedure TTemplateForm.ImportFile(const FileName : string);
var
 sl : TStringList;
 i,c,ob,cb,mb : integer;
 Node: PVirtualNode;
 Data: PTemplate;
 t : string;
begin
  sl:=TStringList.Create;
  data:=nil;
  try
   sl.LoadFromFile(filename);
   c:=0;
   while (sl.count-1>=c) do begin
    i:=-1;
    t:=sl[c];
    ScanW(t,'[*?*|*?*]',i);
    if i=1 then begin
     if Assigned(data) then Delete(data.data,Length(data.data)-1,2);
     node:=vst.AddChild(nil);
     data:=vst.GetNodeData(node);
     ob:=pos('[',t);
     mb:=pos('|',t);
     cb:=pos(']',t);
     data.Name:=trim(copy(t,ob+1,mb-ob-1));
     data.Desc:=trim(copy(t,mb+1,cb-mb-1));
     data.Data:='';
    end
     else
      if assigned(data) then data.Data:=data.data+t+#13#10;
    inc(c);
   End;
  finally
   sl.free;
  end;
end;

procedure TTemplateForm.VSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
 Accept:=mode<>dmNowhere;
end;

procedure TTemplateForm.VSTHeaderClick(Sender: TVTHeader; column: TColumnIndex;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 modified:=true;
 if vst.Header.SortDirection = sdAscending
  then vst.Header.SortDirection:=sdDescending
  else vst.Header.SortDirection:=sdAscending;
 VST.Header.SortColumn:=column;
 VST.Sort(nil,column,vst.header.sortdirection);
end;

procedure TTemplateForm.EditNameActionExecute(Sender: TObject);
begin
 VST.EditNode(vst.focusednode,0);
end;

procedure TTemplateForm.EditDescActionExecute(Sender: TObject);
begin
 VST.EditNode(vst.focusednode,1);
end;

procedure TTemplateForm.EnabledIfFocused(Sender: TObject);
begin
 TAction(sender).Enabled:=Assigned(VST.focusednode);
end;


procedure TTemplateForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Tem : PTemplate;
begin
 tem:=VST.GetNodeData(node);
 with Tem^ do
 begin
  SetLength(Name,0);
  SetLength(desc,0);
  SetLength(data,0);
 end;
end;

end.