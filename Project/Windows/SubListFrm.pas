unit SubListFrm; //Modal //VST

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,OptFolders, CentralImageListMdl,OptProcs,
  ComCtrls, ToolWin, VirtualTrees, StdCtrls,clipbrd, JvPlacemnt;

type
  TSubListForm = class(TForm)
    VST: TVirtualStringTree;
    ToolBar: TToolBar;
    btnCopy: TToolButton;
    btnGo: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    edSearch: TEdit;
    FormPlacement: TjvFormPlacement;
    procedure FormCreate(Sender: TObject);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure edSearchChange(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure VSTDblClick(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    sl : TStringList;
    procedure GoSelected;
    function GetActive: PvirtualNode;
    procedure SetActive(node: PVirtualNode);
    procedure PgMove(Up: Boolean);
    procedure Rewrite(const find: string);
  public
    { Public declarations }
  end;

var
  SubListForm: TSubListForm;

implementation
type
  PData = ^Tdata;
  TData = Record
   Sub : String;
   Line : Integer;
  end;

{$R *.dfm}

procedure TSubListForm.FormCreate(Sender: TObject);
begin
 VST.NodeDataSize:=sizeof(TData);
 sl:=TStringList.Create;
 sl.Sorted:=true;
 PR_GetSubList(sl);
 Rewrite('');
end;

procedure TSubListForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var data: PData;
begin
 data:=vst.getnodedata(node);
 case column of
  0 : celltext:=data.Sub;
  1 : celltext:=inttostr(data.Line+1);
 end;
end;

procedure TSubListForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 data: PData;
begin
 data:=vst.getnodedata(node);
 setlength(data.Sub,0);
end;

procedure TSubListForm.edSearchChange(Sender: TObject);
begin
 rewrite(edSearch.text);
end;

procedure TSubListForm.btnCopyClick(Sender: TObject);
var
 data: PData;
begin
 data:=vst.getnodedata(vst.FocusedNode);
 if assigned(data) then
 begin
  clipboard.AsText:=data.Sub;
  close;
 end;
end;

procedure TSubListForm.FormDestroy(Sender: TObject);
begin
 sl.free;
end;

procedure TSubListForm.VSTDblClick(Sender: TObject);
begin
 GoSelected;
end;

procedure TSubListForm.GoSelected;
var
 data: PData;
begin
 if assigned(vst.focusednode) then
 begin
  data:=vst.GetNodeData(GetActive);
  if assigned(data) then
   PR_GotoLine('',integer(data.Line));
 end;
 modalresult:=mrCancel;
end;

procedure TSubListForm.btnGoClick(Sender: TObject);
begin
 GoSelected;
end;

procedure TSubListForm.Rewrite(const find : string);
var
 node : PVirtualNode;
 Data : PData;
 s:string;
 i:integer;
begin
 s:=uppercase(find);
 vst.Clear;
 vst.BeginUpdate;
 for i:=0 to sl.Count-1 do
 if (find='') or (pos(s,uppercase(sl[i]))<>0) then
 begin
  node:=vst.AddChild(vst.RootNode);
  data:=vst.GetNodeData(node);
  data.Sub:=sl[i];
  data.Line:=integer(sl.Objects[i]);
 end;
 vst.EndUpdate;
 setactive(vst.GetFirst);
end;

procedure TSubListForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
 if key=#27 then
  modalresult:=mrcancel;
end;

procedure TSubListForm.SetActive(node : PVirtualNode);
begin
 vst.FocusedNode:=node;
 vst.Selected[node]:=true;
end;

Function TSubListForm.GetActive : PvirtualNode;
begin
 result:=vst.GetFirstSelected;
end;

procedure TSubListForm.PgMove(Up : Boolean);
var
 node : pvirtualNode;
 i:integer;
begin
 node:=getActive;
 for i:=2 to vst.ClientHeight div vst.NodeHeight[vst.getfirstvisible] do
  if assigned(node) then
   begin
    if up
     then node:=vst.GetPreviousVisible(node)
     else node:=vst.GetNextVisible(node);
   end
  else
   break;
 if assigned(node)
  then SetActive(node)
  else begin
   if up
    then setactive(vst.GetFirstVisible)
    else setActive(vst.GetLastVisible);
  end;
end;

procedure TSubListForm.edSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 b : boolean;
begin
 if key=VK_Return then
 begin
  if ssCtrl in shift
   then btnCopy.Click
   else goSelected;
 end;

 if vst.GetFirstVisible<>nil then
 begin
  b:=true;
  case key of
   vk_up : SetActive(vst.GetPreviousVisible(GetActive));
   vk_down : SetActive(vst.GetNextVisible(getactive));
   vk_home : SetActive(Vst.GetFirstVisible);
   vk_end : SetActive(vst.GetLastVisible);
   vk_prior : pgMove(true);
   vk_next : pgmove(false);
   else b:=false;
  end;
  if b then key:=0;
 end;
end;

end.