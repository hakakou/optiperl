{***************************************************************
 *
 * Unit Name: OptAuto_Project
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptAuto_Project;
{$I REG.INC}
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Sysutils, ComObj, ActiveX, OptiPerl_TLB, StdVcl, ComServ, VirtualTrees, ProjectFrm, ProjOptFrm,
  agproputils,OptOptions;

type
  TProject = class(TAutoObject, IProject)
  public
   Project : TProjectForm;
   Destructor Destroy; Override;
  protected
    function Get_Self: Integer; safecall;
    function Get_Count: Integer; safecall;
    function AddFile(const Filename: WideString): OleVariant; safecall;
    procedure AddFolder(const Folder, WildCard: WideString); safecall;
    function Get_Filename: WideString; safecall;
    procedure OpenProject(const Filename: WideString); safecall;
    procedure SaveProject; safecall;
    procedure NewProject(const Filename: WideString); safecall;
    function Get_Modified: WordBool; safecall;
    procedure Set_Modified(Value: WordBool); safecall;
    function Get_Items(Index: Integer): OleVariant; safecall;
    function Get_SelectedItem: OleVariant; safecall;
    procedure Set_SelectedItem(Value: OleVariant); safecall;
    procedure Set_Filename(const Value: WideString); safecall;
    function GetOpt(const Name: WideString): WideString; safecall;
    procedure SetOpt(const Name, Value: WideString); safecall;
    procedure UpdateOptions; safecall;
    procedure RemoveFile(const Filename: WideString); safecall;
  end;

  TProjectItem = class(TAutoObject, IProjectItem)
  public
   Project : TProjectForm;
   Node : PVirtualNode;
   Data : PPrItem;
   Destructor Destroy; Override;
   Procedure Initialize; override;
  protected
    function Get_Self: Integer; safecall;
    function Get_Filename: WideString; safecall;
    function Get_Mode: Integer; safecall;
    function Get_Publish: WordBool; safecall;
    function Get_PublishTo: WideString; safecall;
    function Get_Text: WordBool; safecall;
    procedure Set_Mode(Value: Integer); safecall;
    procedure Set_Publish(Value: WordBool); safecall;
    procedure Set_PublishTo(const Value: WideString); safecall;
    procedure Set_Text(Value: WordBool); safecall;
  end;

Function GetProjectItem(Project : TProjectForm; Node : PVirtualNode) : OleVariant;
Function GetProject(Project : TProjectForm) : OleVariant;

implementation


/// DESTRUCTORS AND GETTERS

Function GetProject(Project : TProjectForm) : OleVariant;
var
 Obj : TProject;
begin
 if assigned(Project) then
 begin
  Obj:=Project.oleobject;
  if Obj=nil then
  begin
   Obj:=TProject.Create;
   obj.Project:=Project;
   project.OleObject:=obj;
  end;
  result:=Obj as IDispatch;
 end;
end;

Function GetProjectItem(Project : TProjectForm; Node : PVirtualNode) : OleVariant;
var
 Obj : TProjectItem;
 Data : PPrItem;
begin
 if (assigned(Project)) and (assigned(node)) then
 begin
  data:=Project.vst.getnodedata(node);
  Obj:=data.oleobject;
  if Obj=nil then
  begin
   Obj:=TProjectItem.Create;
   obj.Project:=Project;
   obj.node:=node;
   obj.Data:=data;
   data.oleobject:=obj;
  end;
  result:=Obj as IDispatch;
 end;
end;


destructor TProject.Destroy;
begin
 Project.oleobject:=nil;
 Project:=nil;
 inherited;
end;

function TProject.Get_Self: Integer;
begin
 result:=Integer(self);
end;

function TProject.AddFile(const Filename: WideString): OleVariant;
var
 node : PVirtualNode;
begin
 node:=Project.AddFile(Filename);
 if not assigned(node) then
  Node:=project.FindFile(filename);
 result:=getProjectItem(project,node);
end;

procedure TProject.AddFolder(const Folder, WildCard: WideString);
begin
 Project.addFolder(Folder, WildCard);
end;

function TProject.Get_Filename: WideString;
begin
 result:=Project.FMH.Filename;
end;

procedure TProject.OpenProject(const Filename: WideString);
begin
 project.FMH.Dirty:=false;
 project.FMH.OpenFile(Filename);
end;

procedure TProject.SaveProject;
begin
 project.FMH.IsNew:=false;
 project.FMH.Save;
end;

procedure TProject.NewProject(const Filename: WideString);
begin
 project.FMH.Dirty:=false;
 project.FMH.IsNew:=false;
 project.FMH.Filename:=filename;
 project.FMHNewFormCaption(Filename);
 project.FMHNew(filename);
end;

function TProject.Get_Modified: WordBool;
begin
 result:=project.FMH.Dirty;
end;

procedure TProject.Set_Modified(Value: WordBool);
begin
 project.FMH.Dirty:=Value;
end;

procedure TProjectItem.Initialize;
begin
 inherited;
end;

destructor TProjectItem.Destroy;
begin
 data.oleobject:=nil;
 node:=nil;
 data:=nil;
 inherited;
end;

function TProjectItem.Get_Self: Integer;
begin
 result:=Integer(self);
end;

function TProject.Get_Items(Index: Integer): OleVariant;
var
 List : TNodeList;
begin
 Project.GetFlatFileList(list);
 if index<length(list) then
  result:=GetProjectItem(project,list[index]);
end;

function TProject.Get_Count: Integer;
var
 List : TNodeList;
begin
 Project.GetFlatFileList(list);
 result:=length(list);
end;

function TProject.Get_SelectedItem: OleVariant;
begin
 result:=GetProjectItem(project,project.VST.focusednode);
end;

procedure TProject.Set_SelectedItem(Value: OleVariant);
var
 node : PVirtualNode;
begin
 node:=TProjectItem(Integer(value.self)).node;
 if assigned(node) then
  Project.VST.Focusednode:=Node;
end;

function TProjectItem.Get_Filename: WideString;
begin
 result:=data.Path;
end;

function TProjectItem.Get_Mode: Integer;
begin
 result:=data.Mode;
end;

function TProjectItem.Get_Publish: WordBool;
begin
 result:=data.Publish;
end;

function TProjectItem.Get_PublishTo: WideString;
begin
 result:=data.PublishTo;
end;

function TProjectItem.Get_Text: WordBool;
begin
 result:=data.Text;
end;

procedure TProjectItem.Set_Mode(Value: Integer);
begin
 data.Mode:=value;
end;

procedure TProjectItem.Set_Publish(Value: WordBool);
begin
 data.Publish:=value;
end;

procedure TProjectItem.Set_PublishTo(const Value: WideString);
begin
 data.PublishTo:=value;
end;

procedure TProjectItem.Set_Text(Value: WordBool);
begin
 data.Text:=value;
end;

procedure TProject.Set_Filename(const Value: WideString);
begin
 project.FMH.Filename:=value;
 project.FMHNewFormCaption(value);
end;

function TProject.GetOpt(const Name: WideString): WideString;
begin
 result:=GetProperty(ProjOpt,name);
end;

procedure TProject.SetOpt(const Name, Value: WideString);
begin
 SetProperty(ProjOpt,name,value);
end;

procedure TProject.UpdateOptions;
begin
 Project.updateoptions(true);
end;

procedure TProject.RemoveFile(const Filename: WideString);
var node:  PVirtualNode;
begin
 node:=project.FindFile(filename);
 if assigned(node) then
 begin
  Project.vst.focusedNode:=node;
  project.RemoveFromProjectAction.Execute;
 end;
end;

initialization
  TAutoObjectFactory.Create(ComServer, TProject, Class_Project,ciInternal);
  TAutoObjectFactory.Create(ComServer, TProjectItem, Class_ProjectItem,ciInternal);
end.