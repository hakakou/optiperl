unit WatchFrm; //modeless //VST

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CustDebmdl, Menus, OptForm, hakageneral,CentralImageListMdl,ScriptInfoUnit,agPropUtils,
  OptProcs, OptFolders, hakawin, VirtualTrees, DIPcre, ExtCtrls, StdCtrls;


type
  TWatchForm = class(TOptiForm)
    PopupMenu: TPopupMenu;
    InsertItem: TMenuItem;
    DeleteItem: TMenuItem;
    VST: TVirtualStringTree;
    N2: TMenuItem;
    EditExpressionItem: TMenuItem;
    EditValueItem: TMenuItem;
    Pcre: TDIPcre;
    N1: TMenuItem;
    EvaluateagainItem: TMenuItem;
    ErrorMemo: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure VSTGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure PopupMenuPopup(Sender: TObject);
    procedure InsertItemClick(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure EditExpressionItemClick(Sender: TObject);
    procedure EditValueItemClick(Sender: TObject);
    procedure VSTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: WideString);
    procedure VSTEdited(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure VSTExpanded(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure EvaluateagainItemClick(Sender: TObject);
    procedure VSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure VSTCollapsed(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
  private
    StandardNode,ExecutionNode,UserNode : PVirtualNode;
    ExeExpanded : Boolean;
    procedure AddStan(const Exp: String);
    function FindExp(Parent: PVirtualNode; const Exp: String): PVirtualNode;
    procedure ExpandNode(node: PVirtualNode);
    procedure ExpandNodeCat(Mnode: PVirtualNode);
    procedure InvalidateMessage(var Msg: TMessage); message WM_USER;
  Protected
    procedure _UpdateWatchList;
    procedure _GetWatchList;
    procedure _UpdateNearLines;
    procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix, index: Integer); override;
  public
    Function AddUser(const Exp: String; Eval,User: Boolean) : Boolean;
  end;

var
  WatchForm: TWatchForm;

implementation

{$R *.DFM}

procedure TWatchForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=caFree;
 WatchForm:=nil;
end;

procedure TWatchForm.FormCreate(Sender: TObject);
var
 Watch : PWatch;
 sl : TStringList;
 s:string;
 i:integer;
begin
 PR_UpdateWatchList:=_UpdateWatchList;
 PR_GetWatchList:=_GetWatchList;
 PR_UpdateNearLines:=_UpdateNearLines;

 StandardNode:=vst.AddChild(vst.RootNode);
 watch:=vst.GetNodeData(StandardNode);
 Watch.Expression:='Standard';

 ExecutionNode:=vst.AddChild(vst.RootNode);
 watch:=vst.GetNodeData(ExecutionNode);
 Watch.Expression:='Execution';

 UserNode:=vst.AddChild(vst.RootNode);
 watch:=vst.GetNodeData(UserNode);
 Watch.Expression:='User';

 s:=programpath+'Default Watches.txt';
 if fileexists(s) then
 begin
  sl:=TStringList.Create;
  try
   sl.LoadFromFile(s);
   for i:=0 to sl.Count-1 do
   begin
    s:=trim(sl[i]);
    if length(s)>0 then
     addstan(s);
   end;
  finally
   sl.free;
  end;
 end;

end;

procedure TWatchForm.AddStan(const Exp : String);
var
 Watch : PWatch;
begin
 watch:=vst.GetNodeData(vst.AddChild(StandardNode));
 watch.Expression:=exp;
end;

procedure TWatchForm.VSTGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
 NodeDataSize:=sizeof(TWatch);
end;

procedure TWatchForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
 Watch : PWatch;
begin
 Watch:=vst.GetNodeData(node);
 case column of
  0: celltext:=watch.Expression;
  1: celltext:=watch.Value;
 end;
end;

procedure TWatchForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Watch : PWatch;
begin
 Watch:=vst.GetNodeData(node);
 setlength(watch.Expression,0);
 setlength(watch.value,0);
end;

procedure TWatchForm.VSTEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
 allowed:=false;
 if (vst.GetNodeLevel(node)=2) or (vst.GetNodeLevel(node)=0) then exit;
 if (column=0) and (
    (node.Parent=StandardNode) or
    (node.Parent=ExecutionNode)) then exit;
 Allowed:=(assigned(debmod) and (debmod.Status in [stStopped,stNotRunning]));
end;

procedure TWatchForm.PopupMenuPopup(Sender: TObject);
var
 Node: PVirtualNode;
begin
 node:=vst.FocusedNode;
 if assigned(node) and (vst.GetNodeLevel(node)=2) then node:=nil;

 InsertItem.Visible:=assigned(node);
 DeleteItem.Visible:=(assigned(node)) and (node.Parent=UserNode);
 EditExpressionItem.Visible:=DeleteItem.Visible;
 EditValueItem.Visible:=(assigned(node)) and (node.Parent<>vst.RootNode);

 SetGroupEnable([InsertItem,DeleteItem,EditExpressionItem,EditValueItem,EvaluateagainItem],
  (assigned(debmod) and (debmod.Status in [stStopped,stNotRunning])));
end;

procedure TWatchForm.InsertItemClick(Sender: TObject);
var
 Node: PVirtualNode;
begin
 Node:=vst.AddChild(usernode);
 vst.EditNode(node,0)
end;

procedure TWatchForm.DeleteItemClick(Sender: TObject);
begin
 vst.DeleteNode(vst.FocusedNode);
end;

procedure TWatchForm.EditExpressionItemClick(Sender: TObject);
begin
 vst.EditNode(vst.FocusedNode,0)
end;

procedure TWatchForm.EditValueItemClick(Sender: TObject);
begin
 vst.EditNode(vst.FocusedNode,1)
end;

Function TWatchForm.FindExp(Parent : PVirtualNode; Const Exp : String) : PVirtualNode;
var
 Watch : PWatch;
begin
 result:=vst.GetFirstChild(Parent);
 while assigned(result) do
 begin
  watch:=vst.GetNodeData(result);
  if watch.Expression=exp then break;
  result:=vst.GetNextSibling(result);
 end;
end;

Function TWatchForm.AddUser(const Exp: String; Eval,User: Boolean) : Boolean;
var
 Node: PVirtualNode;
 Watch : PWatch;
begin
 result:=false;
 if not user and (stringendsWith(':',Exp)) then exit;

 if User then
  begin
   Node:=FindExp(UserNode,exp);
   if assigned(node) then exit;
   node:=FindExp(ExecutionNode,exp);
   if assigned(Node) then
    Vst.DeleteNode(node);
  end
 else
  begin
   Node:=FindExp(ExecutionNode,exp);
   if assigned(node) then exit;
   node:=FindExp(UserNode,exp);
   if assigned(node) then exit;
   node:=FindExp(StandardNode,exp);
   if assigned(node) then exit;
  end;

 result:=true;
 if User
  then node:=vst.AddChild(UserNode)
  else node:=vst.AddChild(ExecutionNode);
 Watch:=vst.GetNodeData(node);
 watch.Expression:=exp;

 if Eval then
 begin
  vst.OnExpanded:=nil;
  vst.Expanded[node.Parent]:=true;
  vst.OnExpanded:=VSTExpanded;
  if assigned(debmod) then
  begin
   Watch.Value:=debmod.EvaluateVar(watch.Expression);
   ExpandNode(node);
  end;
  PostMessage(handle,WM_USER,0,0);
 end;
end;

procedure TWatchForm._UpdateNearLines;
var
 c : integer;
begin
 if debmod=nil then exit;

 vst.BeginUpdate;
 vst.DeleteChildren(ExecutionNode);
 c:=0;
 with Pcre do
 begin
  SetSubjectStr(NearLineString);
  if (Match(0) >= 0) then
  repeat
   if AddUser(MatchedStr,false,false) then
    inc(c);

  until (Match(MatchedStrAfterLastCharPos) < 0) or (c>10);
 end;

 vst.OnExpanded:=nil;
 vst.OnCollapsed:=nil;
 vst.Expanded[ExecutionNode]:=ExeExpanded;
 vst.OnExpanded:=VSTExpanded;
 vst.OnCollapsed:=VSTCollapsed;
end;

procedure TWatchForm._GetWatchList;
var
 Node: PVirtualNode;
 Watch : PWatch;
begin
 WatchList.Clear;
 if ExecutionNode.ChildCount>0 then
  ExeExpanded:=vst.Expanded[ExecutionNode];

 node:=vst.GetFirst;
 while assigned(node) do
 begin
  if (node.Parent<>vst.RootNode) and
     (vst.Expanded[node.Parent]) then
  begin
   watch:=vst.GetNodeData(node);
   watchList.Add(watch);
  end;
  node:=vst.GetNext(node);
 end;
end;

procedure TWatchForm.ExpandNode(node : PVirtualNode);
var
 Watch,Nw: PWatch;
 NNode : PVirtualNode;
 sl:TStringList;
 i:integer;
 ishash : boolean;
begin
 watch:=vst.GetNodeData(node);
 vst.DeleteChildren(node);
 if (length(watch.Expression)>0) and (watch.Expression[1] in ['@','%']) then
 begin
  ishash:=watch.Expression[1]='%';
  sl:=TStringList.Create;
  sl.Text:=watch.Value;
  i:=0;
  while (i<sl.Count) do
  begin
   nnode:=vst.AddChild(node);
   nw:=vst.GetNodeData(nnode);
   if IsHash then
    begin
     nw.Expression:=sl[i];
     inc(i);
     if i<sl.Count then
      nw.Value:=sl[i]
    end
   else
    begin
     nw.Expression:=inttostr(i);
     nw.Value:=sl[i];
    end;
   inc(i);
  end;
  sl.free;
 end;
end;

procedure TWatchForm.ExpandNodeCat(Mnode : PVirtualNode);
var
 Node : PVirtualNode;
begin
 node:=vst.GetFirstChild(MNode);
 while assigned(node) do
 begin
  ExpandNode(node);
  node:=vst.GetNextSibling(node);
 end;
end;

procedure TWatchForm._UpdateWatchList;
begin
 ExpandNodeCat(StandardNode);
 ExpandNodeCat(ExecutionNode);
 ExpandNodeCat(UserNode);
 vst.endupdate;
 if LastWatchTIme=0
  then vst.Header.Columns.Items[1].Text:='Value'
  else vst.Header.Columns.Items[1].Text:='Value - '+inttostr(LastWatchTime)+'ms';
 PostMessage(handle,WM_USER,0,0);
 ErrorMemo.Text:=lastWatchText;
 ErrorMemo.Visible:=length(lastWatchText)>0;
end;

procedure TWatchForm.VSTNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: WideString);
var
 Watch : PWatch;
begin
 Watch:=vst.GetNodeData(node);
 case column of
  0 : Watch.Expression:=Newtext;
  1 : Watch.Value:=Newtext;
 end;
end;

procedure TWatchForm.VSTEdited(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
 Watch : PWatch;
begin
 Watch:=vst.GetNodeData(node);
 if trim(Watch.Expression)='' then
 begin
  vst.DeleteNode(node);
  exit;
 end;

 if assigned(DebMod) then
 begin
  if column=0 then
   Watch.Value:=debmod.EvaluateVar(watch.Expression)
  else
  if column=1 then
   debmod.WatchValueChange(watch);
 end;

 PostMessage(handle,WM_USER,0,0);
end;

procedure TWatchForm.VSTCollapsed(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
 if node=ExecutionNode then
  ExeExpanded:=false;
end;

procedure TWatchForm.VSTExpanded(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
 if node.Parent<>vst.RootNode then exit;

 if node=ExecutionNode then
  ExeExpanded:=true;

 vst.Enabled:=false;
 try
  if assigned(debmod) then
   debmod.EvaluateWatches;
 finally
  vst.Enabled:=true;
 end;
end;

procedure TWatchForm.EvaluateagainItemClick(Sender: TObject);
begin
 vst.Enabled:=false;
 try
  if assigned(debmod) then
   debmod.EvaluateWatches;
 finally
  vst.Enabled:=true;
 end;
end;

procedure TWatchForm.VSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
 if node.Parent=vst.RootNode
  then TargetCanvas.Font.Style:=[fsBold]
  else TargetCanvas.Font.Style:=[];
end;

procedure TWatchForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=nil;
 Alignment:=drtNone;
 Pix:=0;
 Index:=InDebugs;
end;

procedure TWatchForm.FormDestroy(Sender: TObject);
begin
 PR_UpdateWatchList:=nil;
 PR_GetWatchList:=nil;
 PR_UpdateNearLines:=nil;
end;

procedure TWatchForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
 CanClose:=vst.Enabled;
end;

procedure TWatchForm.InvalidateMessage(var Msg: TMessage);
begin
 Vst.Invalidate;
end;

procedure TWatchForm.VSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
 Watch : PWatch;
begin
 if column<>1 then exit;
 Watch:=vst.GetNodeData(node);
 HintText:=watch.Value;
end;

end.