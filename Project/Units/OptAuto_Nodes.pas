{***************************************************************
 *
 * Unit Name: OptAuto_Nodes
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptAuto_Nodes;
{$I REG.INC}

interface

uses
  Sysutils, ComObj, ActiveX, OptiPerl_TLB, StdVcl, ComServ,Variants,
  ExplorerFrm,VirtualTrees;

type
  TNodeType = (ntCustom,ntExplorer,ntProject);

  TNode = class(TAutoObject, INode)
  Public
    Data : PData;
    Node : PVirtualNode;
    Destructor Destroy; Override;
  protected
    function Get_ID: Integer; safecall;
    function Get_Self: Integer; safecall;
    function Get_Caption: WideString; safecall;
    function Get_Hint: WideString; safecall;
    function Get_Line: Integer; safecall;
    function Get_Path: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    procedure Set_Line(Value: Integer); safecall;
    procedure Set_Path(const Value: WideString); safecall;
  end;

  TTreeView = class(TAutoObject, ITreeView)
  public
    VST : TVirtualStringTree;
    Destructor Destroy; Override;
  protected
    function AddNode(const ParentNode: INode): OleVariant; safecall;
    function GetFirst: OleVariant; safecall;
    function GetNext(const Node: INode; Sibling: WordBool): OleVariant;
      safecall;
    procedure DeleteNode(const Node: INode); safecall;
    function Get_RootNode: OleVariant; safecall;
    function GetFirstChild(const Node: INode): OleVariant; safecall;
    procedure DeleteChildren(const Node: INode); safecall;
    function Node(ID: Integer): OleVariant; safecall;
    function Get_Self: Integer; safecall;
    function Get_MainNode(Index: Integer): OleVariant; safecall;
  end;

Function GetNode(Node : PVirtualNode; VST : TVirtualStringTree) : OleVariant;
Function GetTreeView : OleVariant;

implementation

function TNode.Get_ID: Integer;
begin
 result:=Integer(node);
end;

function TTreeView.AddNode(const ParentNode: INode): OleVariant;
var
 Vnode : PVirtualNode;
begin
 VNode:=vst.AddChild(PVirtualNode(ParentNode.ID));
 result:=GetNode(VNode,VST);
end;

function TTreeView.GetFirstChild(const Node: INode): OleVariant;
var
 Vnode : PVirtualNode;
begin
 Vnode:=VST.GetFirstChild(PVirtualNode(Node.id));
 result:=GetNode(VNode,VST);
end;

function TTreeView.GetFirst: OleVariant;
var
 Vnode : PVirtualNode;
begin
 Vnode:=VST.GetFirst;
 result:=GetNode(VNode,VST);
end;

function TTreeView.GetNext(const Node: INode;
  Sibling: WordBool): OleVariant;
var
 VNode : PVirtualNode;
begin
 if Sibling
 then
  Vnode:=VST.GetNextSibling(PVirtualNode(Node.id))
 else
  Vnode:=VST.GetNext(PVirtualNode(Node.id));

 result:=GetNode(VNode,VST);
end;

procedure TTreeView.DeleteNode(const Node: INode);
var
 n : TNode;
begin
 n:=TNode(integer(node.Self));
 n.Data:=nil;
 VST.DeleteNode(PVirtualNode(n.node));
 n.Node:=nil;
end;

function TTreeView.Get_RootNode: OleVariant;
var
 VNode : PVirtualNode;
begin
 VNode:=vst.RootNode;
 result:=GetNode(VNode,VST);
end;

procedure TTreeView.DeleteChildren(const Node: INode);
begin
 VST.DeleteChildren(PVirtualNode(node.id));
end;

function TTreeView.Node(ID: Integer): OleVariant;
begin
 result:=GetNode(PVirtualNode(ID),VST);
end;

/// DESTRUCTORS AND GETTERS

destructor TNode.Destroy;
begin
 if assigned(Data) then
  Data.OleObject:=nil;
 data:=nil;
 node:=nil;
 inherited;
end;

destructor TTreeView.Destroy;
begin
 VST.Tag:=0;
 VST:=nil;
 inherited;
end;

Function GetNode(Node : PVirtualNode; VST : TVirtualStringTree) : OleVariant;
var
 Obj : TNode;
 data : PData;
begin
 if assigned(node) and assigned(vst) then
 begin
  data:=Vst.GetNodeData(node);
  if assigned(data)
   then obj:=data.oleobject
   else obj:=nil; //in case it is rootnode
  if obj=nil then
  begin
   obj:=TNode.Create;
   obj.Data:=data;
   obj.Node:=node;
   if assigned(data) then
    data.OleObject:=obj;
  end;
  result:=obj as IDispatch;
 end;
end;

Function GetTreeView : OleVariant;
var
 obj : TTreeView;
 VST : TVirtualStringTree;
begin
 vst:=ExplorerForm.VST;
 if assigned(vst) then
 begin
  obj:=TTreeView(vst.tag);
  if obj=nil then
  begin
   obj:=TTreeview.Create;
   obj.VST:=vst;
   vst.Tag:=integer(obj);
  end;
  result:=obj as IDispatch;
 end;
end;

function TNode.Get_Self: Integer;
begin
 result:=Integer(self);
end;

function TTreeView.Get_Self: Integer;
begin
 result:=Integer(self);
end;

function TTreeView.Get_MainNode(Index: Integer): OleVariant;
var
 node:TNode;
begin
 Node:=TNode.Create;
 node.Node:=explorerForm.itemnodes[TItemNodeTypes(index)];
 Node.Data:=explorerForm.VST.GetNodeData(Node.Node);
 result:=node as IDispatch;
end;

function TNode.Get_Caption: WideString;
begin
 result:=data.Str;
end;

function TNode.Get_Hint: WideString;
begin
 result:=data.dataline;
end;

function TNode.Get_Line: Integer;
begin
 result:=data.line;
end;

function TNode.Get_Path: WideString;
begin
 result:=data.path;
end;

procedure TNode.Set_Caption(const Value: WideString);
begin
 data.Str:=value;
end;

procedure TNode.Set_Hint(const Value: WideString);
begin
 data.dataline:=value;
end;

procedure TNode.Set_Line(Value: Integer);
begin
 data.line:=value;
end;

procedure TNode.Set_Path(const Value: WideString);
begin
 data.path:=value;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TNode, Class_Node,ciInternal);
  TAutoObjectFactory.Create(ComServer, TTreeView, Class_TreeView,ciInternal);
end.