unit TodoFrm; //modeless //VST

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OptFolders, Menus,  VirtualTrees,hyperstr,edittodoitemfrm,OptGeneral,OptProcs,
  ScriptInfoUnit, hakafile, ActiveX, hkstreams,OptForm,
  HKCSVParser,hakahyper, JvPlacemnt;

type
  TTodoForm = class(TOptiForm)
    PopupMenu: TPopupMenu;
    NewItem: TMenuItem;
    DeleteItem: TMenuItem;
    N1: TMenuItem;
    SortItem: TMenuItem;
    VST: TVirtualStringTree;
    EditItem: TMenuItem;
    CSV: THKCSVParser;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure NewitemClick(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
    procedure EditItemClick(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure SortItemClick(Sender: TObject);
    procedure VSTPaintText(Sender: TBaseVirtualTree; const Canvas: TCanvas;
      Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType);
    procedure VSTDblClick(Sender: TObject);
    procedure VSTLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure VSTSaveNode(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Stream: TStream);
    procedure VSTChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; column: TColumnIndex; var Result: Integer);
    procedure VSTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; Text: WideString);
    procedure VSTDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure VSTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VSTHeaderClick(Sender: TVTHeader; column: TColumnIndex;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure CSVSetData(Sender: TObject; const Data: array of String);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ForEachCat(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
    procedure ForEachOwner(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
    Function EditAddItem(Node : PVirtualNode) : Boolean;
  protected
    procedure FirstShow(Sender: TObject); override;
  public
   procedure UpdateList;
   procedure SaveList;
   procedure DoSaveList(Todo: TStrings);
  end;

var
  TodoForm: TTodoForm;

implementation

{$R *.DFM}

procedure TTodoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=cafree;
 TodoForm:=nil;
end;

procedure TTodoForm.FirstShow(Sender: TObject);
begin
 PC_Todo_ActiveScriptChanged:=UpdateList;
 VST.NodeDataSize:=Sizeof(TTodoRec);
 UpdateList;
end;

procedure TTodoForm.NewitemClick(Sender: TObject);
var
 node :PVirtualNode;
 data : PTodoRec;
begin
 if not PR_IsFileInProject(ActiveScriptInfo.path) then
 begin
  MessageDlg('To-do entries are saved in the project.'+#13+#10+''+#13+#10+'To enable adding new entries, you will need '+#13+#10+'to add the open file in the active project.', mtError, [mbOK], 0);
  exit;
 end;

 Node:=VST.AddChild(vst.rootnode);
 node.checktype:=ctCheckBox;
 node.CheckState:=csUncheckedNormal;
 Data:=Vst.GetNodeData(node);
 if assigned(data) then begin
  data.Action:='New Action';
  data.Priority:=0;
  data.Owner:=GetUser;
  data.Category:='';
  data.notes:='';
 end;
 if not EditAddItem(node) then
  vst.DeleteNode(Node);
end;

procedure TTodoForm.DeleteItemClick(Sender: TObject);
begin
 VST.DeleteSelectedNodes;
 SaveList;
end;

procedure TTodoForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
var data : PTodoRec;
begin
 Data:=Vst.GetNodeData(node);
 if assigned(data) then
  case column of
   0: text:=data.Action;
   1: text:=inttostr(data.Priority);
   2: text:=data.Owner;
   3: text:=data.Category;
  end;
end;

procedure TTodoForm.ForEachCat(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Data: Pointer; var Abort: Boolean);
var tr : PTodoRec;
begin
 tr:=Vst.GetNodeData(node);
 if length(tr.Category)>0 then
  TStringList(data).add(tr.category);
end;

procedure TTodoForm.ForEachOwner(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var tr : PTodoRec;
begin
 tr:=Vst.GetNodeData(node);
 if length(tr.Owner)>0 then
  TStringList(data).add(tr.owner);
end;

Function TTodoForm.EditAddItem(Node : PVirtualNode) : BOolean;
var
 cl,ol : TStringList;
 done : BOolean;
 Ti:PTodoRec;
begin
 result:=false;
 ti:=Vst.GetNodeData(Node);
 if ti=nil then exit;
 done:=node.checkstate=cscheckedNormal;
 cl:=TStringList.create;
 cl.Sorted:=true;
 cl.Duplicates:=dupIgnore;
 ol:=TStringList.create;
 ol.Sorted:=true;
 ol.Duplicates:=dupIgnore;
 try
  VST.IterateSubtree(nil,Foreachcat,cl);
  VST.IterateSubtree(nil,ForeachOwner,ol);
  EditAddItem:=Execute(ti^,done,cl,ol);
  if done
   then node.CheckState:=csCheckedNormal
   else node.CheckState:=csUnCheckedNormal;
  VST.Invalidate;
 finally
  cl.free;
  ol.free;
 end;
 if Result then SaveList;
end;

procedure TTodoForm.EditItemClick(Sender: TObject);
begin
 EditAddItem(Vst.FocusedNode);
end;

procedure TTodoForm.PopupMenuPopup(Sender: TObject);
begin
 EditItem.Enabled:=VST.FocusedNode<>nil;
 DeleteItem.Enabled:=VST.FocusedNode<>nil;
end;

procedure TTodoForm.SortItemClick(Sender: TObject);
begin
 VST.Sort(vst.rootnode,0,sdAscending);
end;

procedure TTodoForm.VSTPaintText(Sender: TBaseVirtualTree;
  const Canvas: TCanvas; Node: PVirtualNode; column: TColumnIndex;
  TextType: TVSTTextType);
begin
 if node.checkstate=csCheckedNormal
  then Canvas.font.color:=clGrayText;
end;

procedure TTodoForm.VSTDblClick(Sender: TObject);
begin
 IF VST.FocusedNode<>nil then edititem.Click;
end;

procedure TTodoForm.VSTLoadNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var data : PTodoRec;
begin
 Data:=Vst.GetNodeData(node);
 data.Action:=readstr(stream);
 Stream.Read(data.priority,sizeof(data.priority));
 data.Owner:=readstr(stream);
 data.Category:=readstr(stream);
 data.notes:=readstr(stream);
end;

procedure TTodoForm.VSTSaveNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var data : PTodoRec;
begin
 Data:=Vst.GetNodeData(node);
 Writestr(data.Action,stream);
 Stream.Write(data.priority,sizeof(data.priority));
 WriteStr(data.Owner,stream);
 WriteStr(data.Category,stream);
 WriteStr(data.notes,stream);
end;

procedure TTodoForm.CSVSetData(Sender: TObject;
  const Data: array of String);
var
 node : PVirtualNode;
 Pdata : PTodoRec;
begin
 if length(data)<5 then exit;
 node:=VST.AddChild(vst.RootNode);
 node.CheckType:=ctCheckBox;
 Pdata:=vst.GetNodeData(node);

 Pdata.Action:=DecodeIni(data[0]);
 if data[1]<>''
  then node.CheckState:=csCheckedNormal
  else node.CheckState:=csUncheckedNormal;
 Pdata.Priority:=StrToIntDef(data[2],0);
 Pdata.Owner:=DecodeIni(data[3]);
 Pdata.Category:=DecodeIni(data[4]);
 if length(data)>=6
  then Pdata.Notes:=DecodeIni(data[5])
  else Pdata.Notes:='';
end;

procedure TTodoForm.UpdateList;
var
 si:TSCriptInfo;
begin
 si:=ActiveScriptInfo;
 VST.Clear;
 if (not Assigned(si)) or (not Assigned(si.todo)) then Exit;
 CSV.Lines.Assign(si.Todo);
 csv.Parse;
 CSV.Lines.Clear;
end;

procedure TTodoForm.SaveList;
begin
 if (not Assigned(ActiveScriptInfo)) or
    (not Assigned(ActiveScriptInfo.todo)) then Exit;
 DoSaveList(ActiveScriptInfo.Todo);
end;

procedure TTodoForm.DoSaveList(Todo : TStrings);
var
 node : PVirtualNode;
 data : PTodoRec;
 s:string;
begin
 Todo.clear;
 node:=vst.GetFirst;
 while assigned(node) do
 begin
  if node.CheckState=csCheckedNormal
   then s:='Done'
   else s:='';
  data:=vst.GetNodeData(node);
  Todo.Add(
   EncodeIni(data.Action)+','+
   s+','+
   IntToStr(data.Priority)+','+
   EncodeIni(data.Owner)+','+
   EncodeIni(data.Category)+','+
   EncodeIni(data.Notes));
  node:=vst.GetNext(node);
 end;
end;

procedure TTodoForm.VSTChecked(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
 SaveList;
end;

procedure TTodoForm.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; column: TColumnIndex; var Result: Integer);
var data1,data2 : PTodoRec;
begin
 result:=0;
 Data1:=Vst.GetNodeData(node1);
 Data2:=Vst.GetNodeData(node2);
 case column of
  0 : Result:=AnsiCompareStr(data1.Action,data2.action);
  2 : Result:=AnsiCompareStr(data1.Owner,data2.Owner);
  3 : Result:=AnsiCompareStr(data1.category,data2.category);
  1 : result:=integer(data1.Priority) - integer(Data2.Priority);
 end;
end;

procedure TTodoForm.VSTNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; Text: WideString);
var data : PTodoRec;
begin
 Data:=Vst.GetNodeData(node);
 if assigned(data) then
  case column of
   0: data.Action:=text;
   1: try
       data.Priority:=StrToInt(text);
      except
       on exception do data.Priority:=0;
      end;
   2: data.Owner:=text;
   3: data.Category:=text;
  end;
end;

procedure TTodoForm.VSTDragOver(Sender: TBaseVirtualTree; Source: TObject;
  Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
  var Effect: Integer; var Accept: Boolean);
begin
 Accept:=(mode<>dmNowhere) and (source=vst);
end;

procedure TTodoForm.VSTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
  DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
  Pt: TPoint; var Effect: Integer; Mode: TDropMode);
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

procedure TTodoForm.VSTHeaderClick(Sender: TVTHeader; column: TColumnIndex;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if VST.Header.SortColumn=column then
  if vst.Header.SortDirection = sdAscending
   then vst.Header.SortDirection:=sdDescending
   else vst.Header.SortDirection:=sdAscending;
 VST.Header.SortColumn:=column;
 VST.Sort(nil,column,vst.header.sortdirection);
end;

procedure TTodoForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 data : PTodoRec;
begin
 Data:=VST.GetNodeData(node);
 with data^ do
 begin
  SetLength(Action,0);
  SetLength(Owner,0);
  SetLength(Category,0);
  SetLength(Notes,0);
 end;
end;

procedure TTodoForm.FormDestroy(Sender: TObject);
begin
 PC_Todo_ActiveScriptChanged:=nil;
end;


end.