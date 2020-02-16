unit ExplorerFrm; //Modeless //VST
{$I REG.INC}

interface

uses  Windows, Forms, Classes, Controls, variants, VirtualTrees, sysutils,dialogs,
  ExtCtrls,OptFolders, RunPerl, graphics,hakamessagebox, messages, HKDebug, HakaRandom,
  dcmemo,hyperstr,hakageneral,hakahyper,ImgList,OptOptions, WebBrowserFrm,
  OptGeneral, Menus, codeanalyzeunit, dccommon,dcstring, OptSearch,HKPerlParser,
  AppEvnts,hakafile,hkClasses, DIPcre, ScriptInfoUnit,OptForm,ParsersMdl,
  OptProcs,PlugMdl, dxBar;

type
  TExplorerThread = class;
  TFoldType = (ftBracket,ftParen,ftHereDoc,ftPod);
  TFoldPos = (fpStart,fpEnd,fpMiddle);

  TFoldData = Record
   Ls,Le,InS,InE : Integer;
   FoldPos : TFoldPos;
   Level : Integer;
  end;

  TVarData = Record
   Node : PVirtualNode;
   Level : Integer;
  end;

  TFolds = record
   Folders : Set of TFoldType;
   Data : array[TFoldType] of TFoldData;
  end;

  PData = ^TData;
  TData = record
   Str : string;
   line : integer;
   dataline : String;
   usage : string;
   path : String;
   ModDat : TModuleData;
   OleObject : Pointer;
  end;

  TItemNodeTypes = (inPackage,inExports,inUses,inRequires,inSubs,inScalars,inArrays,inHashes,inPods,inBookmarks);

  TExplorerForm = class(TOptiForm)
    VST: TVirtualStringTree;
    ImageList: TImageList;
    ModMenu: TPopupMenu;
    OpenModuleItem: TMenuItem;
    OpenInPodExtractorItem: TMenuItem;
    N1: TMenuItem;
    UpdateModulesItem: TMenuItem;
    SearchMenu: TPopupMenu;
    SearchagaininopenscriptItem: TMenuItem;
    ApplicationEvents: TApplicationEvents;
    Pcre: TDIPcre;
    bPcre: TDIPcre;
    forPCRE: TDIPcre;
    ClearsearchresultsItem: TMenuItem;
    Timer: TTimer;
    BarManager: TdxBarManager;
    RenameMenu: TPopupMenu;
    RenameItem: TMenuItem;
    RenamePcre: TDIPcre;
    PodPcre: TDIPcre;
    headPcre: TDIPcre;
    N2: TMenuItem;
    HighlightPosition1Item: TMenuItem;
    HighlightPosition2Item: TMenuItem;
    HighlightPosition3Item: TMenuItem;
    HighlightPosition4Item: TMenuItem;
    N3: TMenuItem;
    ArchiveSearchItem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
    procedure VSTDblClick(Sender: TObject);
    procedure VSTKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure VSTPaintText(Sender: TBaseVirtualTree; const Canvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure OpenModuleItemClick(Sender: TObject);
    procedure OpenInPodExtractorItemClick(Sender: TObject);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var Index: Integer);
    procedure VSTGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const P: TPoint; var AskParent: Boolean;
      var PopupMenu: TPopupMenu);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure UpdateModulesItemClick(Sender: TObject);
    procedure SearchagaininopenscriptItemClick(Sender: TObject);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ClearsearchresultsItemClick(Sender: TObject);
    procedure VSTIncrementalSearch(Sender: TBaseVirtualTree;
      Node: PVirtualNode; const SearchText: WideString;
      var Result: Integer);
    procedure TimerTimer(Sender: TObject);
    procedure RenameItemClick(Sender: TObject);
    procedure ApplicationEventsShowHint(var HintStr: String;
      var CanShow: Boolean; var HintInfo: THintInfo);
    procedure HighlightPositionItemClick(Sender: TObject);
    procedure ArchiveSearchItemClick(Sender: TObject);
    procedure SearchMenuPopup(Sender: TObject);
    procedure VSTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
  private
    ModuleSearch : String;
    //the code that will be explored
    VarPat : String;
    //will hold a regular pattern to search for variabled
    BracketLevel : integer;
    //During the search holds the level in {} brackets of the cursor
    ItemStates : array [TItemNodeTypes] of boolean;
    //Whether the main nodes are expanded or not. Used after the update to
    //restore previous settings
    NewReq,NewUses : TStringList;
    //A list of the new subnodes of uses and requires
    RejectedList,VarList,SubList,SubVarList : THKStringList;
    VarData : Array of TVarData;

    PodQueue : TStringList;
    PodNode : PVirtualNode;
    LastPodLevel : Integer;

    SearchList,SearchUsage : TStringList;
    FocusedVars : TStringlist;
    //??
    ErrorNode,SearchNode,TodoSearchNode : PvirtualNode;
    FFileName,LastExtSub : String;
    SubMatrix : Array of PVirtualNode;
    //List of each line in code and the node with the subroutine that corresponds
    PrevSubHighLightNode,SubHighlightNode : PVirtualNode;
    //THe current highligh node (for subs) and the previous one
    //to know when to invalidate
    LastNewNode : PVirtualNode;
    PrevErrorNodeExp : Boolean;
    //Used when updating

    procedure UpdateCode;
    procedure ProcessLine(Var s:string; line : Integer);
    procedure ClearNodeTypes;
    Function AddLine(n : TItemNodeTypes; const Str:string; Line : Integer) : PVirtualNode;
    procedure SortNodeTypes;
    function GetFocusedModulePath: string;
    function safeGetLine(l: Integer): string;
    procedure AddSubData(subnode : PVirtualNode);
    function GetModulePath(Node: PVirtualNode): string;
    Procedure AddSubVar(node : PVirtualNode; Line : Integer; Before : Boolean);
    procedure IterateNodeForSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
    Procedure RestoreFocusedVars;
    Function HintDeclaration(const s: string) : String;
    procedure DoHDCoding;
    procedure DoLevelCoding(OBr, CBr: Char; FoldType : TFoldType);
    procedure LevelCoding;
    procedure DoPodCoding;
    procedure InitializeUpdate;
    procedure UpdateFont;
    function GetHint(Node: PVirtualNode): String;
    procedure AddPodLine(const Str: String; Line: Integer);
   protected
    procedure _OneSaved(const path: String);
    procedure _GetSubList(sl: TStringList);
    procedure _OptionsUpdated(Level: Integer);
    Procedure _FindDeclaration(const dec : string);
    procedure _UpdateCodeExplorer;
    procedure _UpdateSyntaxErrors(Errors: TStrings; Status: Integer);
    Procedure _UpdateSearchResult;
    Procedure _HighLightSub(line : Integer; Focus : Boolean);
    procedure _Explorer_GetDeclarationHint(const Declaration: String; var Result: String);
    procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer); override;
   PUBLIC
    {$IFDEF OLE}
    OleObject : Pointer;
    {$ENDIF}
    ItemNodes : array [TItemNodeTypes] of PVirtualNode;
    //Main Nodes
    Thread : TExplorerThread;
    Folding : array of TFolds;
    Code : TStringList;
    Syntax : TStringList;
    Showing : TMemoSource;
    procedure AddBookmark(const path: string; Line,BookNum:integer);
    procedure DoGoNext(Next: Boolean);
    procedure RestartThread;
    function IsDeclaration(const Declaration: String): Boolean;
    Procedure ExportCode(sl : TStringList);
    function MajorSearch(const dec: string): String;
    procedure StartmajorSearch(const module: String);
    procedure GotoBookmark(num: Integer);
    procedure UpdateRightNow;
   Protected
    Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); Override;
  end;

  TExplorerThread = class(TThread)
  private
   FExplorer : TExplorerForm;
   FWillDo : TMemoSource;
   Procedure GetCode;
   procedure DoUpdate;
   procedure ExecuteLoop;
   procedure SetFoldingLength;
  public
   constructor Create(Explorer : TExplorerForm);
   procedure Execute; override;
  end;


Const
 ItemNodeStrs : array[TItemNodeTypes] of string =
  ('Packages','Exported','Uses','Requires','Subroutines','Scalars','Arrays','Hashes','Pod','Bookmarks');

var
  ExplorerForm: TExplorerForm;

implementation
{$IFDEF OLE}
uses OptAuto_Nodes;
{$ENDIF}

{$R *.DFM}

Function TExplorerForm.AddLine(n : TItemNodeTypes; const Str:string; Line : Integer) : PVirtualNode;
var
 UpStr : String;
 data : PData;
 Node : PVirtualNode;
 found : boolean;
begin
 found:=false;

 if (n in [inuses,inrequires,inScalars,inArrays,inHashes]) then
 begin
  UpStr:=str;
  Node:=vst.GetFirstChild(ItemNodes[n]);
  while Assigned(Node) and (Node.Parent=ItemNodes[n]) do
  begin
   data:=VST.GetNodeData(node);
   if (data.Str)=Upstr then
   begin
    found:=true;
    break;
   end;
   Node:=vst.GetNextSibling(node);
  end;
 end;

 if (not found) then
 //ADDING
 node:=vst.AddChild(itemNodes[n]);

 result:=node;

 if n=inSubs then LastNewNode:=node;

 if n=inUses then
  NewUses.AddObject(str,TObject(Node));
 if n=inRequires then
  NewReq.AddObject(str,TObject(Node));

 if (n in [inScalars,inArrays,inHashes]) and (found) then exit;

 data:=vst.GetNodeData(node);
 data.str:=str;
 data.line:=line;
 data.path:=FFIlename;
 data.dataline:=trim(
  SafeGetLine(line-1)+
  SafeGetLine(line)+
  SafeGetLine(line+1)+
  SafeGetLine(line+2)+
  SafeGetLine(line+3)+
  SafeGetLine(line+4));
end;

procedure TExplorerForm.ClearNodeTypes;
var
 Node:PVirtualNode;
 data : PData;
begin
 node:=VST.GetFirst;
 while assigned(node) do
 begin
  if ((node.Parent=itemNodes[inScalars]) or
     (node.Parent=itemNodes[inArrays]) or
     (node.Parent=itemNodes[inHashes])) and
     (vsExpanded in node.States) then
  begin
   data:=vst.GetNodeData(node);
   focusedvars.AddObject(data.str,tobject(node.parent));
  end;
  node:=vst.GetNext(node);
 end;
 vst.deleteChildren(itemNodes[inPackage]);
 vst.deleteChildren(itemNodes[inSubs]);
 vst.deleteChildren(itemNodes[inScalars]);
 vst.deleteChildren(itemNodes[inArrays]);
 vst.deleteChildren(itemNodes[inHashes]);
 vst.deleteChildren(itemNodes[inPods]);
end;


Procedure TExplorerForm.RestoreFocusedVars;
var
 Node:PVirtualNode;
 data : PData;
 i:integer;
begin
 node:=VST.GetFirst;
 while assigned(node) do
 begin
  if ((node.Parent=itemNodes[inScalars]) or
     (node.Parent=itemNodes[inArrays]) or
     (node.Parent=itemNodes[inHashes])) then
  begin
   data:=vst.GetNodeData(node);
   i:=Focusedvars.indexof(data.str);
   if (i>=0) and (FocusedVars.objects[i]=TObject(node.parent)) then
    vst.Expanded[node]:=true;
  end;
  node:=vst.GetNext(node);
 end;
 focusedVars.Clear;
end;


procedure TExplorerForm.AddSubData(subnode : PVirtualNode);
var
 i,c:Integer;
 Node,nnode:PVirtualNode;
 ndata,data : PData;
 md : TModuleData;
 sl,VsSl : TStringList;
 nodearray : TNodeArray;
 path : string;
 so : ^TSubObject;
begin
 //Put correct string list in sl
 if subnode=itemNodes[inUses]
  then begin sl:=NewUses; VsSl:=NewReq; end
  else begin sl:=NewReq;; VsSl:=NewUses; end;

//First delete all nodes that are not used. First we put
//in nodearray all to nodes to be deleted
 Node:=vst.GetFirstChild(subnode);
 c:=0;
 while Assigned(Node) and (Node.Parent=subnode) do
 begin
  data:=vst.getnodedata(node);

  if sl.IndexOf(data.str)=-1 then
  begin
   inc(c);
   setlength(nodearray,c);
   nodearray[c-1]:=node;
   if assigned(data.ModDat) then
   begin
    data.ModDat.Expanded:=vst.Expanded[node];

    if VsSl.IndexOf(data.str)=-1 then
     with data.ModDat.Exported do
      for i:=0 to Count-1 do
      begin
       so:=pointer(objects[i]);
       if assigned(so^.node) then
       begin
        vst.DeleteNode(so^.Node);
        so^.Node:=nil;
       end;
      end;

   end;
  end;

  Node:=vst.GetNextSibling(node);
 end;

// Do the actual deleting
 for i:=length(NodeArray)-1 downto 0 do
  vst.DeleteNode(nodearray[i]);

 //Now add data to the nodes that don't have childs

 for c:=0 to sl.Count-1 do
 begin
  TObject(node):=(sl.objects[c]);
  if not assigned(node) then
   Showmessage('Internal Error with Code Explorer');
  if node.ChildCount=0 then
  begin
   path:=GetModulePath(node);
   md:=ModList.GetModule(path);
   if Assigned(md) then
   begin
   //add subroutines
    for i:=0 to md.Subs.Count-1 do
    begin
     //ADDING
     nnode:=vst.AddChild(node);
     ndata:=vst.getnodedata(nnode);
     ndata.Str:=md.Subs[i];
     so:=pointer(md.subs.objects[i]);
     ndata.line:=so^.Line;
     ndata.path:=path;
     ndata.dataline:=md.Module+':'+inttostr(so^.line)+#13#10+so^.Synopsis;
     ndata.usage:=so^.Usage;
    end;
    vst.Expanded[node]:=md.Expanded;
    data:=VST.GetNodeData(node);
    data.ModDat:=md;

    //add exports
    for i:=0 to md.Exported.Count-1 do
    begin
     so:=pointer(md.exported.objects[i]);
     if not assigned(so^.node) then
     begin
      //ADDING
      nnode:=vst.AddChild(itemNodes[inExports]);
      ndata:=vst.getnodedata(nnode);
      ndata.Str:=md.Exported[i];
      ndata.line:=md.ExportsLine;
      so^.Node:=nnode;
      ndata.path:=md.Module;
      ndata.usage:=so^.Usage;
      ndata.ModDat:=md;
      ndata.dataline:=trim(
       'Exported from '+extractfileNoExt(md.module)+#13#10+so^.Synopsis);
    end;
    end;

   end;
  end;
 end;
end;

procedure TExplorerForm.UpdateFont;
begin
 VST.Font.size:=options.codeexplorerfontsize;
 VST.Font.name:=options.codeexplorerfontName;
 vst.DefaultNodeHeight:=Options.CodeExplorerHeight;
end;

procedure TExplorerForm.FormCreate(Sender: TObject);
var
 data : PData;
 T : TItemNodeTypes;
begin
 PR_OneSaved:=_OneSaved;
 pr_UpdateSyntaxErrors:=_UpdateSyntaxErrors;
 pr_UpdateCodeExplorer:=_UpdateCodeExplorer;
 pr_HighLightSub:=_HighLightSub;
 PR_UpdateSearchResult:=_UpdateSearchResult;
 pr_FindDeclaration:=_FindDeclaration;
 PC_Explorer_GetDeclarationHint:=_Explorer_GetDeclarationHint;
 PC_Explorer_OptionsUpdated:=_OptionsUpdated;
 PR_GetSubList:=_GetSubList;

 {$IFDEF REG}
  if FIleExists(programPath+OptiExplorerBmp) then
  begin
   VST.Background.LoadFromFile(programPath+OptiExplorerBmp);
   VST.TreeOptions.AnimationOptions :=VST.TreeOptions.AnimationOptions - [toAnimatedToggle];
  end;
 {$ENDIF}

 VarPat:=MakePattern('[\$\@\%][A-Za-z0-9_][A-Za-z0-9_:]*');
 VST.NodeDataSize:=sizeof(TData);

 for t:=Low(ItemNodes) to High(ItemNodes) do
 begin
  ItemNodes[t]:=Vst.AddChild(nil);
  Data:=vst.GetNodeData(ItemNodes[t]);
  data.line:=-1;
  data.Str:=ItemNodeStrs[t];
 end;

 SearchNode:=vst.AddChild(nil);
 data:=vst.GetNodeData(SearchNode);
 data.Str:='Search Results';
 data.usage:=#0;
 data.line:=-1;

 NewReq:=TstringList.create;
 NewReq.Sorted:=true;
 NewReq.Duplicates:=dupIgnore;
 NewUses:=TStringList.create;
 NewUses.sorted:=true;
 NewUses.Duplicates:=dupIgnore;

 VarList:=THKStringList.create(true,true,dupIgnore);
 SubList:=THKStringList.create(true,true,dupIgnore);
 RejectedList:=THKStringList.create(true,true,dupIgnore);
 SubVarList:=THKStringList.create(true,true,dupAccept);
 FocusedVars:=TStringList.create;
 FocusedVars.sorted:=true;
 FocusedVars.Duplicates:=dupIgnore;
 SearchList :=TStringList.Create;
 SearchList.sorted:=true;
 SearchList.Duplicates:=dupaccept;
 SearchList.CaseSensitive:=true;
 SearchUsage:=TStringList.create;
 PodQueue:=TStringList.Create;

 Code:=TStringList.create;
 Syntax:=TStringList.create;
 PrevErrorNodeExp:=true;

 Thread:=TExplorerThread.Create(Self);
end;

procedure TExplorerForm.RestartThread;
begin
 TerminateThread(thread.Handle,1);
 EditorInitCS(false);
 EditorInitCS(true);
 Closehandle(CSEntireExplorer);
 CSEntireExplorer:=CreateMutex(nil,false,nil);
 Thread:=TExplorerThread.Create(Self);
end;

procedure TExplorerForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
var data : PData;
begin
 data:=sender.GetNodeData(node);
 text:=trim(data.Str);
end;

Procedure TExplorerForm.AddSubVar(node : PVirtualNode; Line : Integer; Before : Boolean);
var
 data : PData;
 Nnode : PVirtualNode;
begin
 //ADDING
 Nnode:=VST.addchild(node);
 if before then vst.MoveTo(NNode,node,amAddChildFirst,false);
 data:=Vst.GetNodeData(nnode);
 data.Str:=trim(SafeGetLine(line));
 code.Strings[line];
 data.line:=line;
 data.path:=FFIlename;
 data.dataline:=trim(
  SafeGetLine(line-1)+
  SafeGetLine(line)+
  SafeGetLine(line+1)+
  SafeGetLine(line+2));
 data.ModDat:=nil;
end;

procedure TExplorerForm.ProcessLine(Var s:string; line : Integer);
var
 w,lok:string;
 reject : boolean;
 p,q:integer;
 insub : string;

 procedure AddVariable(const st:string; NextChar : Char);
 var
  tnode : PVirtualNode;
  v,t : string;
  n: TItemNodeTypes;
  i:integer;
 begin
  v:=copy(st,2,length(st));
  if v='_' then exit;
  if Reject then
  begin
   rejectedlist.add(v);
   exit;
  end;

  if rejectedlist.IndexOf(v)=-1 then
  begin
   case st[1] of
    '$' : n:=inScalars;
    '@' : n:=inArrays;
    '%' : n:=inHashes;
   end;

   if n=inScalars then
   begin
    if NextChar='[' then n:=inArrays
    else
    if NextChar='{' then n:=inHashes;
   end;

   i:=pos('::',v);
   if i<>0
    then t:=copyFromToEnd(v,i+2)
    else t:=v;
   i:=varlist.IndexOf(t);
   if i=-1 then
    begin
     if length(vardata)<=varlist.Count then
      setlength(vardata,length(vardata)+100);
     tnode:=addline(n,v,line);
     varlist.AddObject(t,tobject(varlist.count));
     vardata[varlist.Count-1].Node:=tnode;
     vardata[varlist.Count-1].Level:=bracketlevel;
     repeat
      i:=subvarlist.IndexOf(t);
      if i<0 then break;
      if integer(subvarlist.Objects[i])<>line then
       addsubvar(tnode,integer(subvarlist.Objects[i]),true);
      subvarlist.Delete(i);
     until false;
    end

   else
    with vardata[integer(varlist.Objects[i])] do
    begin
     if (Level>bracketlevel) and (node.Parent<>itemnodes[n]) then
     begin
      //ADDING
      vst.MoveTo(node,itemnodes[n],amAddChildLast,false);    //check this out
      level:=bracketlevel;
     end;
    end;
  end;
 end;

begin
try
 p:=bracketLevel;
 for q:=1 to length(s) do
 begin
  if s[q]='{' then inc(bracketLevel)
  else
  if s[q]='}' then dec(bracketLevel);
 end;
 if (bracketLevel=0) and (p<>0) then
  RejectedList.Clear;

 p:=1;
 w:=firstWord(s,p);
 if Length(w)=0 then Exit;
 insub:='';

 if w='sub' then
 begin
  bracketlevel:=countf(s,'{',1)-countf(s,'}',1);
  w:=FirstWordSkipSpaces(s,p);
  if (Length(w)>0) and (w[Length(w)]='{') then
   Delete(w,Length(w),1);
  if Length(w)>0 then
   addline(inSubs,w,line);
  SubList.Add(w);
  insub:=w;
 end
  else

 if w='require' then
 begin
  w:=FirstWordSkipSpaces(s,p);
  w:=DeleteChars(w,'"''');
  if Length(w)>0 then
  addline(inRequires,w,line);
 end
  else

 if w='use' then
 begin
  w:=FirstWordSkipSpaces(s,p);
  if Length(w)>0 then
  addline(inUses,w,line);
 end
  else

 if w='package' then
 begin
  w:=FirstWordSkipSpaces(s,p);
   if Length(w)>0 then
  addline(inPackage,w,line);
 end

  else

 begin
  if forpcre.MatchStr(s)=1 then
   delete(s,1,forpcre.MatchedStrLength);
  if pcre.MatchStr(s)=4 then
   begin
    reject:=false;
    lok:=trim(pcre.SubStr(1));
    if (bracketlevel>0) and ((lok='my') or (lok='local'))
      then reject:=true;
    if pcre.SubStr(2)='('
     then
     begin
        p:=pos('=',s);
        if p=0 then p:=length(s);
        with bPcre do
        begin
         SetSubjectStr(s);
         if (Match(0) = 4) then
         repeat
          if (SubStrfirstCharPos(1) < p) then
          begin
           insub:=SubStr(2);
           addvariable(insub,#0);
          end;
         until Match(SubStrAfterLastCharPos(3)-2) <> 4
        end
     end
     else
      begin
       p:=pcre.SubStrAfterLastCharPos(3)+1;
       while (p<=length(s)) and (s[p]=' ') do inc(p);
       if p<=length(s) then
        addvariable(pcre.SubStr(3),s[p]);
      end;
   end;
 end;
except
 on Exception do begin end;
end;
end;

procedure TExplorerForm.SortNodeTypes;
var T : TItemNodeTypes;
begin
 for t:=inPackage to inHashes do
  VST.Sort(itemnodes[t],0,sdAscending);
end;

procedure TExplorerForm.InitializeUpdate;
var i:integer;
begin
 SetLength(SubMatrix,code.Count);
 NewReq.Clear;
 VarList.clear;
 NewUses.clear;
 SubList.Clear;
 SubVarList.Clear;
 RejectedList.clear;
 SetQuotes('"','"');

 if (options.FoldEnable) or (options.BoxEnable) or (options.LineEnable) then
  begin
   thread.Synchronize(thread.SetFoldingLength);
   // SOS: This needed to be in synchronize method
   // becase of problems in TEdMagicMod.DoViewChange
   // line:  En:=iMin(Length(ExplorerForm.folding)-1,en);
   for i:=0 to length(Folding)-1 do
    folding[i].Folders:=[];
  end
 else
  setlength(Folding,0);
end;

Procedure TExplorerForm.AddPodLine(const Str : String; Line : Integer);
var
 Data: Pdata;
 Level : Shortint;
 node : PVirtualNode;
begin
 level:=ord(str[length(str)]);
 dec(level,64);

 if (level<1) and (podNode=ItemNodes[inPods]) then
  level:=1;

 if level=0 then
  begin
   node:=vst.AddChild(podNode.Parent);
   podnode:=node;
  end
 else
  if level=1 then
  begin
   Node:=vst.addChild(podNode);
   PodNode:=node;
  end
 else
  begin
   while level<0 do
   begin
    PodNode:=PodNode.Parent;
    if PodNode=VST.RootNode then
    begin
     podnode:=itemnodes[inPods];
     break;
    end;
    inc(level);
   end;

   PodNode:=PodNode.Parent;
   if podNode=vst.RootNode then
    podnode:=itemnodes[inPods];

   Node:=vst.addChild(podNode);
   podNode:=node;
  end;

 data:=vst.GetNodeData(node);
 data.Str:=str;
 setlength(data.Str,length(str)-1);
 data.line:=line;
 data.path:=FFIlename;
 data.dataline:=data.Str;
end;

procedure TExplorerForm.UpdateCode;
var
 i,j,l,p,ind,q :integer;
 s,col,w,avar:string;
 Node : PVirtualNode;
 Data : PData;
 n: TItemNodeTypes;
begin
 if not assigned(ActiveScriptInfo) then exit;
 SubHighlightNode:=nil;
 PrevSubHighLightNode:=nil;
 LastNewNode:=nil;
 ModuleSearch:=ExtractFilePath(FFilename);

 setlength(vardata,code.Count div 5);

 for n:=inPackage to inPods do
  if itemnodes[n].ChildCount>0 then
   ItemStates[n]:=vst.Expanded[ItemNodes[n]];

 clearnodetypes;
 BracketLevel:=0;
 s:='';

 PodNode:=ItemNodes[inPods];
 with Podqueue do
  for i:=0 to Count-1 do
   AddPodLine(Strings[i],Integer(objects[i]));

 for i:=0 to code.Count-1 do
 begin
   Application.ProcessMessages;
   try
    col:=Syntax[i];
    j:=1;
    p:=Length(col);
    while (j<=p) and (ord(col[j])=tokWhitespace) do  inc(j);
    if (p=0) or ((j<=p) and (ord(col[j])=tokComment)) then
    begin
     SubMatrix[i]:=LastNewNode;
     continue;
    end;
    s:=s+code[i];
    if (Length(s)=0) then
    begin
     SubMatrix[i]:=LastNewNode;
     continue;
    end;

    j:=1;
    if (s[length(s)]<>',') then
    begin
     repeat
      W := Parse(S,';',j);
      w:=trim(w);

      if Length(w)>0 then
      begin
       p:=1;

       repeat
        l:=ScanRX(w,varpat,p);
        if l=0 then break;
        avar:=copy(w,p+1,l-1);
        q:=pos('::',avar);
        if q<>0 then
         delete(avar,1,q+1);
        DeleteEndsWith(':',avar);
        ind:=varlist.IndexOf(avar);
        if ind<>-1
         then addsubvar(vardata[Integer(varlist.objects[ind])].Node,i,false)
         else SubVarList.AddObject(avar,TObject(i));
        inc(p,3);
       until false;
       processLine(w,i);
       SubMatrix[i]:=LastNewNode;
      end;

     until (j<1) or (j>Length(S));
     s:='';
    end;


   except
    on Exception do begin end;
   end;
 end;

  //glue
 AddSubData(itemnodes[inUses]);
 AddSubData(itemNodes[inRequires]);
 sortnodetypes;
 RestoreFocusedVars;

 for n:=inPackage to inPods do
  vst.Expanded[ItemNodes[n]]:=ItemStates[n];

 if LastExtSub<>'' then
 begin
  node:=VST.GetFirstChild(itemnodes[inSubs]);
  data:=VST.GetNodeData(node);
  while (assigned(node)) and (node.parent=itemnodes[inSubs]) and (data.Str<>LastExtSub) do
  begin
   node:=VST.GetNextSibling(node);
   data:=VST.GetNodeData(node);
  end;

  if assigned(node) then begin
   vst.FocusedNode:=node;
   vst.Selected[VST.focusedNode]:=true;
  end;
  LastExtSub:='';
 end;
end;

Function TExplorerForm.IsDeclaration(const Declaration : String) : Boolean;
begin
  try
   result:=(varlist.IndexOf(declaration)>=0) or (Sublist.IndexOf(declaration)>=0);
  except
   result:=false;
  end;
end;

procedure TExplorerForm.VSTDblClick(Sender: TObject);
var
 data : PData;
 i:integer;
 f:string;
begin
 if assigned(VST.focusedNode) then
 begin
  data:=vst.GetNodeData(vst.focusednode);
  i:=data.line;
  if vst.Focusednode.Parent=ErrorNode then
   begin
    f:=ExtFileFromErrorLine(data.Str);
    if length(f)=0 then
     f:=data.path
   end
  else
   f:=data.path;

  if not fileexists(f) then f:='';
  if (vst.FocusedNode.Parent=SearchNode) and
     (data.usage=#0) and (data.line>=0) then
  begin
   PR_HighLightLineByPos(f,i);
   exit;
  end;
  if i<0 then Exit;
  if VST.focusedNode.Parent.Parent.parent=VST.rootnode
   then LastExtSub:=data.Str
   else LastExtSub:='';
  PR_GotoLine(f,i);
 end;
end;

Procedure TExplorerForm._HighLightSub(line : Integer; Focus : Boolean);
begin
 if length(subMatrix)>line
  then SubHighLightNode:=SubMatrix[line]
  else SubHighLightNode:=nil;
 if PrevSubHighLightNode<>SubHighLightNode then
 begin
  PrevSubHighLightNode:=SubHighLightNode;
  VST.Invalidate;
 end;
 if (focus) and (assigned(subhighlightnode)) then
 begin
  vst.Expanded[itemNodes[insubs]]:=true;
  vst.FocusedNode:=SubHighLightNode;
  vst.Selected[SubHighLightNode]:=true;
  vst.IsVisible[SubHighLightNode]:=true;
 end;
end;

Procedure TExplorerForm._UpdateSyntaxErrors(Errors : TStrings; Status : Integer);
var i:integer;
Const
// psOK,psWarnings,psErrors,psOther
 Str : array[0..3] of string = ('No errors','Warnings','Errors','Errors');
var
 data : PData;
 Node,n2 : PVIrtualNode;
begin
 if not assigned(ActiveScriptInfo) then exit;

 Assert(not ExplorerUpdating,'LOG Updating errors while updating');

 vst.BeginUpdate;
 try
  if assigned(ErrorNode) then
  begin
  //DeleteChildren has problems
   node:=vst.GetFirstChild(errorNode);

   while assigned(node) and (node.Parent=errorNode) do
   begin
    n2:=node;
    node:=vst.GetNext(node);
    vst.DeleteNode(n2);
    end;
   PrevErrorNodeExp:=VST.Expanded[ErrorNode];
   vst.DeleteNode(ErrorNode);
   ErrorNode:=nil;
  end;

  if (  Not assigned(Errors) ) or
     ( (not (OPtions.SHExplorerErrors)) and (status=2) ) or
     ( (not (OPtions.SHExplorerWarnings)) and (status=1) ) or
     ( (not (Options.SHExplorerErrors)) and (not options.SHExplorerWarnings) ) or
     ( Errors.Count=0 ) then
  begin
   vst.endUpdate;
   VST.InvalidateToBottom(itemNodes[inHashes]);
   exit;
  end;

  ErrorNode:=vst.InsertNode(SearchNode,amInsertBefore);
  data:=vst.GetNodeData(ErrorNode);
  data.Str:=Str[status];
  data.line:=-1;
  for i:=0 to Errors.Count-1 do
  begin
   node:=vst.AddChild(ErrorNode);
   data:=Vst.GetNodeData(node);
   data.Str:=Errors[i];
   data.dataline:=Errors[i];
   data.path:=ActiveScriptINfo.path;
   Data.line:=Integer(Errors.Objects[i])-1;
  end;

  if (options.RunTest) and (ExtractFileName(ActiveScriptInfo.path)='test1.pm') then
   for i:=0 to 500 do
   begin
    node:=vst.AddChild(ErrorNode);
    data:=Vst.GetNodeData(node);
    data.Str:=RandomString(100);
   end;

  VST.Expanded[ErrorNode]:=PrevErrorNodeExp;

 finally
  vst.endupdate;
  VST.InvalidateToBottom(ErrorNode);
 end;
end;

Procedure TExplorerForm.ExportCode(sl : TStringList);
var
 node : PVirtualNode;
 data : PData;
 i,p : integer;
 s,t,max,element,filename:string;
begin
 max:=IntToStr(code.Count);
 max:=IntToStr(length(max)+1);
 node:=vst.GetFirst;
 filename:=ExtractFilename(ActiveScriptInfo.path);
 while assigned(NODE) do
 begin
  i:=vst.getnodelevel(node);
  if (i<=1) and (node<>ItemNodes[inExports]) and
     (node.Parent<>itemNodes[inExports]) then
  begin
   data:=vst.GetNodeData(node);
   if i=0 then
   begin
    if node=SearchNode
     then Element:='Search'
     else Element:=data.Str;
   end;
   if data.line>=0
    then s:=inttostr(data.line+1)
    else s:='';
   if node.parent=SearchNode then
    begin
     t:=data.Str;
     //This part does not really get executed. Seems also to have
     //something to do with perlapi.pas
     p:=pos(':',t);
     if p>0 then delete(t,1,p+1);
     t:=trim(t);
    end
   else
    t:=data.str;
   if i=1 then sl.Add(filename+#9+s+#9+element+#9+t);
  end;
  node:=vst.GetNext(node);
 end;
end;

procedure TExplorerForm._GetSubList(sl : TStringList);
var
 node : PVirtualNode;
 data : PData;
begin
 node:=vst.GetFirstChild(ItemNodes[inSubs]);
 while assigned(NODE) do
 begin
  data:=vst.GetNodeData(node);
  sl.addobject(data.Str,TObject(data.line));
  node:=vst.GetNextSibling(node);
 end;
end;

procedure TExplorerForm._UpdateCodeExplorer;
begin
 Timer.Enabled:=false;
 if not TerminateChecking then
  timer.Enabled:=true;
end;

procedure TExplorerForm._Explorer_GetDeclarationHint(Const Declaration : String; Var Result : String);
begin
 AddDeclaration(result,Declaration,HintDeclaration);
end;

procedure TExplorerForm._OptionsUpdated(Level : Integer);
begin
 UpdateFont;
 if (level=HKO_Big) or (level=HKO_BigVisible) then
  Timer.Interval:=options.ExplorerUpdateLag;
end;

Procedure TExplorerForm._UpdateSearchResult;

 Function FixText(const text : String) : String;
 begin
  result:=text;
  replaceSC(result,#10,'\n',false);
  replaceSC(result,#9,'\t',false);
 end;

var
 i:integer;
 sd : PData;
 l : string;
 node,snode : PVirtualNode;
begin
 if assigned(TodoSearchNode) then
  begin
   snode:=TodoSearchNode;
   TodoSearchNode:=nil;
  end
 else
  snode:=searchNode;

 vst.beginUpdate;
 with PatternSearch do
 try
  VST.DeleteChildren(snode);
  if (files.count<=0) then
   begin
    sd:=vst.GetNodeData(snode);
    sd.str:='No results for /'+pattern+'/';
    sd.path:=pattern;
    sd.line:=-1;
    sd.dataline:='Could not find pattern in '+inttostr(filessearched)+' file(s)';
   end
  else
   begin
    sd:=vst.GetNodeData(snode);
    sd.path:=pattern;
    if FilesSearched=1
     then sd.str:=extractfilename(files[0])+' /'+pattern+'/'
     else sd.str:='Multiple /'+pattern+'/';
    sd.dataline:='Searched '+inttostr(FilesSearched)+' file(s) and found '+
                 inttostr(files.count)+' result(s)';

    for i:=0 to files.Count-1 do
    begin
     node:=vst.AddChild(snode);
     sd:=vst.GetNodeData(node);
     sd.path:=files[i];

     if files.Objects[i]=TObject(-10) then
     //does line.object has absolute position found (not line)?
     //used from binary replace
      begin
       sd.line:=Integer(lines.objects[i]);
       sd.usage:=#0;
      end
     else
      begin
       sd.line:=integer(files.objects[i]);
      end;

     if (sd.line>=0) and (files.Objects[i]<>TObject(-10)) then
      begin
       l:=inttostr(sd.line+1)+': ';
       sd.dataline:=sd.path+':'+inttostr(sd.line)+#13#10+synopsis[i];
      end
     else
      begin
       l:='';
       sd.dataline:=sd.path+#13#10+synopsis[i];
      end;
     if FilesSearched=1
      then sd.Str:=l+FixText(lines[i])
      else sd.str:=ExtractFileNoExt(sd.path)+':'+l+fixtext(lines[i]);
     if length(sd.str)>300 then setlength(sd.str,300);
    end; 
   end;
 finally
  VST.Expanded[snode]:=true;
  VST.TopNode:=snode;
  vst.EndUpdate;
 end;
end;

procedure TExplorerForm.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
 Data1: PData;
 Data2: PData;
 s1,s2 : string;
begin
 Data1:=sender.GetNodeData(node1);
 data2:=sender.GetNodeData(node2);
 s1:=uppercase(data1.str);
 s2:=uppercase(data2.str);
 if s1<s2 then result:=-1
  else
 if s1>s2 then result:=1
  else
 result:=0;
end;

procedure TExplorerForm.VSTKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=vk_Return) and
    (not (tsEditing in VST.TreeStates)) and
    (not (tsEditPending in VST.TreeStates))
     then VSTDblClick(Sender);
end;

procedure TExplorerForm.VSTPaintText(Sender: TBaseVirtualTree;
  const Canvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
 if not assigned(node) then exit;
 if (node.ChildCount>0)
  then Canvas.Font.style:=[fsbold]
  else Canvas.Font.style:=[];
 if (node=subhighlightnode)
  then Canvas.Font.Color:=clRed;
end;

procedure TExplorerForm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var Index: Integer);
var
 t:TItemNodeTypes;
 Parent2,Parent1 : PVirtualNode;
begin
 if not (kind in [ikNormal, ikSelected]) then exit;

 Parent1:=Node.Parent;

 if parent1 = vst.RootNode
  then Index:=0
 else
 if parent1 = itemnodes[inBookmarks]
  then index:=14
 else
  begin
   for t:=inPackage to inBookmarks do
    if itemnodes[t]=parent1 then
    begin
     Index:=Ord(t)+2;
     Exit;
    end;
   parent2:=parent1.Parent;
   if parent2=itemnodes[inScalars]
    then index:=11
   else
   if parent2=itemnodes[inArrays]
    then index:=12
   else
   if parent2=itemnodes[inHashes]
    then index:=13
   else
   if (Parent2=itemnodes[inUses]) or
      (Parent2=itemnodes[inRequires])
    then index:=6
   else
   index:=1;
  end;
end;

procedure TExplorerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 if not IsLoadingLayout then
  MessageDlgMemo('You closed code explorer. To show again, select'+#13+#10+'"Code Explorer" from the Search menu.', mtInformation, [mbOK], 0, 1300);
end;

procedure TExplorerForm.FormDestroy(Sender: TObject);
begin
  SubVarList.free;
  SubList.free;
  try
   Code.free;
  except end; 
  PodQueue.Free;
  Syntax.free;
  NewReq.Free;
  NewUses.free;
  VarList.free;
  FocusedVars.Free;
  RejectedList.free;
  SearchList.free;
  SearchUsage.free;
 {$IFDEF DEVELOP}
  SendDebug('Destroyed: '+name);
 {$ENDIF}
end;

function TExplorerFOrm.GetModulePath(Node : PVirtualNode) : string;
var
 rec: PData;
begin
 if not Assigned(Node) then Exit;
 if (Node.Parent=ItemNodes[inUses]) or (Node.Parent=ItemNodes[inRequires]) then
 begin
  rec:=VST.GetNodeData(Node);
  result:=SearchModule(rec.Str,ModuleSearch,false);
 end;
end;

function TExplorerForm.GetFocusedModulePath : string;
begin
 Result:=GetModulePath(vst.focusedNode);
end;

procedure TExplorerForm.OpenModuleItemClick(Sender: TObject);
var f:string;
begin
 ModuleSearch:=ExtractFilePath(ActiveScriptInfo.path);
 f:=GetFocusedModulePath;
 if f<>'' then PR_OpenFile(f);
end;

procedure TExplorerForm.OpenInPodExtractorItemClick(Sender: TObject);
var f,p:string;
begin
 ModuleSearch:=ExtractFilePath(ActiveScriptInfo.path);
 f:=GetFocusedModulePath;
 if f<>'' then
 begin
  p:=GetPodName(f);
  if fileexists(p) then
   f:=p;
  PR_OpenInPodViewer(f);
 end;
end;

procedure TExplorerForm.VSTGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
var
 rec: PData;
begin
 AskParent:=false;
 PopupMenu:=nil;
 if (not Assigned(Node)) or (ExplorerUpdating) then
  exit;

 if ((Node.Parent=itemNodes[inUses]) or (node.parent=itemNodes[inRequires])) then
  PopupMenu:=ModMenu
 else
 if (node.Parent=itemNodes[inSubs]) or
    (node.Parent=itemNodes[inScalars]) or
    (node.Parent=itemNodes[inArrays]) or
    (node.Parent=itemNodes[inHashes]) then
  popupmenu:=RenameMenu
 else
  if (node.Parent=vst.RootNode) then
  begin
   rec:=vst.GetNodeData(node);
   if (length(rec.path)>0) and (length(patternsearch.Pattern)>0) then
    PopUpMenu:=SearchMenu;
  end;
end;

Function TExplorerForm.GetHint(Node: PVirtualNode) : String;
var
 rec: PData;
const
 max = 100;
begin
 if (not Assigned(Node)) then exit;
 if (Node.Parent<>VST.rootnode) or (node=searchnode) then
 begin
  rec:=VST.GetNodeData(Node);
  result:=rec.dataline;
 end

 else
 if (node.ChildCount=0) then
   result:=''

 else
 if (node.ChildCount=1)
  then result:='1 item'

 else
  result:=inttostr(node.ChildCount)+' total item(s)';
end;

Procedure TExplorerForm.StartMajorSearch(const module : String);
var
 w:string;
 rec: PData;
 Pnode,node : PVirtualNode;
begin
 SearchList.clear;
 SearchUsage.clear;

 Pnode:=VST.GetFirstChild(itemnodes[inUses]);
 while (assigned(Pnode)) and (Pnode<>ItemNodes[inSubs]) do
 begin
  rec:=vst.GetNodeData(Pnode);
  if rec.Str=module then break;
  pnode:=VST.GetNext(pnode);
 end;

 if not assigned(pnode) then exit;

 node:=VST.GetFirstChild(pnode);
 while (assigned(node)) and (node.parent=pnode) do
 begin
  rec:=vst.GetNodeData(node);
  searchusage.Add(rec.usage);
  SearchList.AddObject(rec.Str,TObject(SearchUsage.count-1));
  node:=VST.GetNext(node);
 end;

 node:=VST.GetFirstChild(itemnodes[inExports]);
 while (assigned(node)) and (node.Parent=itemnodes[inExports]) do
 begin
  rec:=vst.GetNodeData(node);
  w:=rec.path;
  replaceSC(w,'\','::',false);
  if ScanF(w,module,-1)<>0 then
  begin
   searchusage.Add(rec.usage);
   SearchList.AddObject(rec.Str,TObject(searchusage.count-1));
  end;
  node:=VST.GetNext(node);
 end;
end;

Function TExplorerForm.MajorSearch(const dec : string) : String;
var
 w:string;
 i:integer;
begin
 w:=dec;
 result:='';
 if (w='') then exit;
 if w[1] in ['@','#','$','%','&','-'] then delete(w,1,1);
 i:=SearchList.IndexOf(w);
 if i>=0 then
 begin
  result:=SearchUsage[integer(searchlist.Objects[i])];
 end;
end;

Function TExplorerForm.HintDeclaration(const s: string) : String;
var
 w:string;
 rec: PData;
 node : PVirtualNode;
 WasVar : Boolean;
 EText : String;
 i,j:integer;
begin
 w:=s;
 result:='';
 EText:='';
 if (w='') then exit;
 wasVar:=w[1] in ['@','$','%'];
 if wasvar or (w[1] in ['#','&','-']) then delete(w,1,1);
 if WasVar
  then Node:=VST.GetFirstChild(ItemNodes[inScalars])
  else node:=VST.GetFirst;
 while (assigned(node)) and (node<>SearchNode) and (node<>ErrorNode) do
 begin
  rec:=vst.GetNodeData(node);
  if rec.Str=w then
  begin
   if (length(EText)=0) and (node.Parent=itemNodes[inExports]) then
   begin
    i:=pos(#13#10,rec.dataline);
    if i>0 then
     EText:=CopyFromToEnd(rec.dataline,i+2);
   end;
   if length(result)<>0
   then
    result:=result+HintLineSplitter+rec.dataline
   else
    result:=rec.dataline;
  end;
  node:=VST.GetNext(node);
 end;

 if length(EText)<>0 then
 begin
  j:=0;
  i:=ScanF(result,EText,1);
  if i>0 then
   j:=ScanF(result,EText,i+length(EText));
  if (i<>0) and (j>i) then
   Delete(Result,i,length(EText));
 end;
end;

procedure TExplorerForm._FindDeclaration(const dec: string);
var w:string;
begin
 w:=dec;
 if (w<>'') then
 begin
  ModuleSearch:=ExtractFilePath(ActiveScriptInfo.path);
  if w[1] in ['@','#','$','%','&','-'] then delete(w,1,1);
  VST.IterateSubtree(nil,IterateNodeForSearch,pointer(w));
 end;
end;

procedure TExplorerForm.IterateNodeForSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Data: Pointer; var Abort: Boolean);
var
 rec: PData;
 f:string;
 l:integer;
begin
 if node.Parent=vst.RootNode then exit;
 if node.Parent=SearchNode then exit;
 rec:=vst.GetNodeData(Node);
 if rec.Str=String(Data) then
 begin
  f:=GetModulePath(node);
  l:=0;
  if f='' then
  begin
   f:=rec.path;
   l:=rec.line;
  end;
  abort:=fileexists(f);
  if abort then
   PR_GoToLine(f,l);
 end;
end;

procedure TExplorerForm.RenameItemClick(Sender: TObject);
const
 FirstChar : array[boolean] of integer =
  (tokDelimiters,tokDeclared);
var
 data: Pdata;
 i,l,p,fp : integer;
 Org,Repl,s,c:string;
 linechanged,FoundOK:boolean;
 IsSubs : Boolean;
begin
 if ExplorerUpdating then exit;
 data:=VST.GetNodeData(vst.FocusedNode);
 repl:=data.Str;
 Org:=data.str;
 if (renamepcre.MatchStr(org)<0) or (renamepcre.SubStr(1)<>'') then exit;
 if not inputquery('Rename','Rename "'+repl+'" to:',repl) then exit;

 if (renamepcre.MatchStr(repl)<0) or (renamepcre.SubStr(1)<>'') or
    (length(repl)<>renamepcre.MatchedStrLength) then
  if MessageDlg('New text does not seem valid. '+#13+#10+'Are you sure you want to proceed?', mtConfirmation, [mbOK,mbCancel], 0)=mrCancel then exit;

 ISSubs:=vst.FocusedNode.Parent=itemNodes[inSubs];
 Vst.DeleteChildren(searchNode);

 with ActiveScriptInfo.ms,renamePcre do
  for i:=0 to Lines.Count-1 do
  begin
   linechanged:=false;
   s:=stringitem[i].StrData;
   c:=StringItem[i].ColorData;
   SetSubjectStr(s);
   if Match(0) >= 0 then
   repeat
    p:=MatchedStrAfterLastCharPos;
    if ( (IsSubs and (SubStr(1)='')) or
         (not IsSubs and (SubStr(1)<>''))
       ) and
       (substr(2)=org) and
       (length(c)=Length(s)) then
    begin

     FoundOK:=True;
     if c[MatchedStrFirstCharPos+1]<>chr(Firstchar[IsSubs]) then
      FoundOK:=false
     else
      for l:=MatchedStrFirstCharPos+2 to MatchedStrAfterLastCharPos do
       if (issubs and (c[l]<>chr(tokDeclared))) or
          (not issubs and (not (c[l] in [chr(tokDeclared),chr(tokVariables)]))) then
        begin
         FoundOK:=false;
         break;
        end;

     Data:=VST.GetNodeData(vst.AddChild(searchnode));
     data.line:=i;
     data.path:=ActiveScriptInfo.path;

     if FoundOK then
      begin
       LineChanged:=true;
       data.Str:='Match on line '+inttostr(i)+': Changed "'+matchedstr+'" to "'+SubStr(1)+repl+'"';
       data.dataline:='OLD: '+stringitem[i].StrData+#13#10;
       fp:=SubStrFirstCharPos(2)+1;
       Delete(s,fp,SubStrLength(2));
       Delete(C,fp,SubStrLength(2));
       Dec(p,SubStrLength(2));
       System.Insert(repl,s,fp);
       System.Insert(StringOfChar(chr(tokDeclared),length(repl)),c,fp);
       inc(p,length(repl));
       data.dataline:=data.dataline+'NEW: '+s;
       SetSubjectStr(s);
      end
     else
      begin
       data.str:='Match on line '+inttostr(i)+' skipped';
       data.dataline:=stringitem[i].StrData;
      end;
    end;
   until Match(p) < 0;

   if LineChanged then
   begin
    stringitem[i].StrData:=s;
    StringItem[i].ColorData:=c;
    ParseStrings(i,i,true);
   end;

  end;
 UpdateRightNow;
 ActiveScriptInfo.Modified;
end;

procedure TExplorerForm._OneSaved(const path : String);
var
 fmd : TModuleData;
 i:integer;

 Procedure Search(parent : PVirtualNode);
 var
  node:PVirtualNode;
  data : PData;
 begin
  node:=vst.GetLastChild(parent);
  while assigned(node) do
  begin
   data:=vst.GetNodeData(node);
   if data.ModDat=fmd then
    vst.DeleteNode(node);
   node:=vst.GetPreviousSibling(node);
  end;
 end; 

begin
 if Showing=nil then exit;
 i:=modlist.ModuleIndex(path);
 if i>=0 then
 begin
  fmd:=TModuleData(modlist.Items[i]);
  Search(itemNodes[inUses]);
  Search(itemNodes[inRequires]);
  fmd.Free;
  modList.Delete(i);
 end;
end;

procedure TExplorerForm.UpdateModulesItemClick(Sender: TObject);
begin
 if Showing=nil then exit;
 ModList.ResetAll;
 vst.deleteChildren(itemNodes[inUses]);
 vst.deleteChildren(itemNodes[inRequires]);
 UpdateRightNow;
end;

procedure TExplorerForm.SearchagaininopenscriptItemClick(Sender: TObject);
var
 sd : PData;
begin
 sd:=vst.GetNodeData(vst.FocusedNode);
 if not assigned(sd) then exit;
 PR_QuickSave;
 TodoSearchNode:=vst.FocusedNode;
 InitPatternSearch;
 PatternSearchFile(ActiveScriptInfo.path,sd.path,false,false,false,true);
 EndPatternSearch;
end;

procedure TExplorerForm.LevelCoding;
begin
 with options do
 if (FoldEnable) or (BoxEnable) or (LineEnable) then
 begin
  if (FoldBrackets) or (BoxBrackets) or (LineEnable) then
   DoLevelCoding('{','}',ftBracket);

  if (FoldParenthesis) or (BoxParen) then
   DoLevelCoding('(',')',ftParen);

  if (FoldHereDoc) or (BoxHereDoc) then
   DoHDCoding;
 end;
end;

procedure TExplorerForm.DoHDCoding;
var
 i,j:integer;
 indoc : boolean;
 st : integer;
begin
 i:=0;
 st:=-1;
 while (i<syntax.Count) do
 begin
  j:=(TPerlStorage(syntax.Objects[i]).State and $F0) shr 4;
  indoc:=(j in [psLongString,psNewString,psHTMLString]);
  if (indoc) and (j=psNewString) then
   st:=i

  else
  if (st<>-1) and (not indoc) and (i<code.count) then
  begin
   include(folding[st].Folders,ftHereDoc);
   with Folding[st].Data[ftHereDoc] do
   begin
    level:=1; ls:=st; ins:=1;  ine:=1;  le:=i;
    FoldPos:=fpStart;
   end;
   Folding[i]:=Folding[st];
   folding[i].Data[ftHereDoc].FoldPos:=fpEnd;
   st:=-1;
  end;

  inc(i);
 end;
end;


procedure TExplorerForm.DoPodCoding;
var
 i,j,pr,Podlevel:integer;
 s,t:string;
 inpod : boolean;
 FoldEn : Boolean;
begin
 inpod:=false;
 FoldEn:=(options.FoldEnable) or (options.BoxEnable) or (options.LineEnable);
 LastPodLevel:=1;
 PodQueue.Clear;
 for i:=0 to Code.Count-1 do
  begin
   s:=Code[i];

   if (not inpod) and
      (((TPerlStorage(syntax.Objects[i]).State and $F0) shr 4) = psPOD) then
   begin
     if FoldEn then
     begin
      include(folding[i].Folders,ftPod);
      with Folding[i].Data[ftPod] do
      begin
       level:=1;
       ls:=i;
       ins:=1;
       FoldPos:=fpStart;
      end;
      pr:=i;
     end;

     InPod:=true;
   end;

   if inpod then
   begin
    if podPcre.MatchStr(s)>0 then
    begin
     if podPcre.SubStr(1)='cut' then
      begin
       if FoldEn then
       begin
        include(folding[i].Folders,ftPod);
        with folding[i].Data[ftpod] do
         foldpos:=fpEnd;
        with folding[pr].Data[ftpod] do
        begin
         InE:=1;
         LE:=i;
        end;
       end;
       inpod:=false;
      end
     else
      begin

       if HeadPcre.MatchStr(podPcre.SubStr(1))>0 then
       begin
        Podlevel:=strToInt(HeadPcre.SubStr(1));
        t:=podPcre.SubStr(2);

        if PodLevel>LastPodLevel
         then PodQueue.AddObject(t+chr(65),TObject(i))
        else
        if PodLevel=LastPodLevel then
         PodQueue.AddObject(t+chr(64),TObject(i))
        else
        begin
         j:=64-(LastPodLevel-PodLevel);
         PodQueue.AddObject(t+chr(j),TObject(i));
        end;
        LastPodLevel:=PodLevel;
       end;

      end;
    end; // if podPcre.MatchStr(s)>0
   end; // if inpod

   if (inPod) then
    begin
     SubMatrix[i]:=nil;
     if length(s)>0 then
      code[i]:='';
    end
   else
    begin
     j:=1;
     while (j<=length(s)) and (s[j] in [' ',#9]) do inc(j);
     if (j<length(s)) and (s[j]='#')
      then //code[i]:=''
      else
       begin
        j:=length(s);
        while (j>=1) and (s[j]=' ') do dec(j);
        setlength(s,j);
        code[i]:=s;
       end;
    end;
  end;

  if (inpod) and (foldEn) then
   with folding[pr].Data[ftpod] do
   begin
    InE:=1;
    LE:=code.Count-1;
   end;

end;

procedure TExplorerForm.DoLevelCoding(OBr,CBr : Char; FoldType : TFoldType);
type
 TBracket = Record
  isOpening : Boolean;
  Level : Integer;
  index : Integer;
  Line : Integer;
 end;

var
 PrLevel : Array of integer;
 i,j,lev,index,curline,CurLevel,size:integer;
 off : integer;
 s,syn:string;
 brackets : Array of TBracket;
 indarray : array[-200..200] of integer;
begin
 lev:=0;
 index:=-1;
 size:=Code.Count*2;
 setLength(brackets,size);
 setLength(PrLevel,10);
 for i:=0 to length(prLevel)-1 do
  prlevel[i]:=-1;

 for i:=0 to code.Count-1 do
 begin
  off:=0;
  s:=code[i];
  syn:=syntax[i];
  if length(s)>length(syn) then
   continue;

  for j:=1 to length(s) do
  begin
   if (s[j]=OBr) and (ord(syn[j])=tokDelimiters) then
   begin
    inc(off);
    if off>high(indarray) then continue;
    indarray[off]:=j;
   end;
   if (s[j]=CBr) and (ord(syn[j])=tokDelimiters) then
   begin
    dec(off);
    if off<low(indarray) then continue;
    indarray[off]:=j;
   end;
  end;

  for j:=1 to off do
   begin
    inc(lev);

    inc(index);
    if size<=index then
    begin
     Inc(size,200);
     setlength(brackets,size);
    end;

    with brackets[index] do
    begin
     isopening:=true;
     level:=lev;
     line:=i;
     index:=indarray[j];
    end;
   end;

  for j:=-1 downto off do
   begin
    if lev=0 then break;
    inc(index);
    if size<=index then
    begin
     Inc(size,200);
     setlength(brackets,size);
    end;

    with brackets[index] do
    begin
     isopening:=false;
     level:=lev;
     line:=i;
     index:=indarray[j];
    end;
    dec(lev);
   end;
 end;
 inc(index);
 SetLength(brackets,index);

 for i:=0 to length(brackets)-1 do
 begin
  curline:=brackets[i].Line;
  CurLevel:=brackets[i].Level;
  if brackets[i].isOpening then
  begin
   include(folding[curline].Folders,foldtype);

   if brackets[i].Level>=length(prlevel) then
   begin
    SetLength(PrLevel,CurLevel+5);
    for j:=length(prLevel)-1 downto length(prLevel)-5 do
     prLevel[j]:=-1;
   end;
   PrLevel[CurLevel]:=CurLine;

   with folding[CurLine].Data[foldtype] do
   begin
    LS:=CurLine;
    Level:=CurLevel;
    InS:=brackets[i].index;
    FoldPos:=fpStart;
   end;
  end
   else
  begin
   with Folding[PrLevel[CurLevel]] do
   begin
    PrLevel[CurLevel]:=-1;
    include(folders,foldtype);
    with data[foldtype] do
    begin
     LE:=CurLine;
     InE:=brackets[i].index;
    end;
   end;

   with Folding[CurLine] do
   begin
    include(folders,foldtype);
    data[foldtype].FoldPos:=fpEnd;
   end;
  end;
 end;

 For i:=1 to length(prLevel)-1 do
  if prLevel[i]<>-1 then
   with Folding[PrLevel[i]] do
    exclude(folders,foldtype);
end;

procedure TExplorerForm.TimerTimer(Sender: TObject);
begin
 Timer.Enabled:=false;
 if (TicksNextExplorer<>0) and (GetTickCount>TicksNextExplorer) then
 begin
  Assert(false,'LOG RESTART EXPLORER');
  TicksNextExplorer:=0;
  RestartThread;
 end;
 SetEvent(EventStartExplorer);
end;

procedure TExplorerForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var data : PData;
begin
 data:=VST.GetNodeData(node);
 with data^ do
 begin
  SetLength(Str,0);
  SetLength(dataline,0);
  SetLength(path,0);
  SetLength(usage,0);
  OleObject:=nil;
 end;
end;

procedure TExplorerForm.UpdateRightNow;
begin
 ExplorerForm.Showing:=nil;
 TimerTimer(nil);
end;

function TExplorerForm.safeGetLine(l: Integer): string;
begin
 if (l>=0) and (l<=code.Count-1)
  then Result:=inttostr(l+1)+': '+trim(code[l])+#13#10
  else Result:='';
end;

procedure TExplorerForm.ClearsearchresultsItemClick(Sender: TObject);
var
 sd : PData;
begin
 if vst.FocusedNode=searchNode then
  begin
   VST.DeleteChildren(SearchNode);
   sd:=vst.GetNodeData(searchNode);
   sd.Str:='Search Results';
   sd.dataline:='';
   vst.Expanded[searchnode]:=true;
  end
 else
  VST.DeleteNode(vst.FocusedNode);
end;

procedure TExplorerForm.VSTIncrementalSearch(Sender: TBaseVirtualTree;
  Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var
 rec: PData;
 i:integer;
begin
 rec:=vst.GetNodeData(Node);
 i:=length(searchText);
 if length(rec.Str)<i then
  i:=length(rec.Str);
 result:=AnsiCompareText(copy(rec.Str,1,i),copy(searchText,1,i));
end;

procedure TExplorerForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtLeft;
 Pix:=200;
 Index:=InNone;
end;

{ TExplorerThread }

constructor TExplorerThread.Create(Explorer: TExplorerForm);
begin
 FExplorer:=Explorer;
 inherited Create(true);
 FreeOnTerminate:=true;
 Priority:=tpLowest;
 resume;
end;

procedure TExplorerThread.DoUpdate;
begin
 FExplorer.vst.beginUpdate;
 try
  PlugMod.OnParseStart;
  FExplorer.updateCode;
  PlugMod.OnParseEnd;
 finally
  FExplorer.vst.EndUpdate;
 end;
end;

procedure TExplorerThread.ExecuteLoop;
begin
    FExplorer.Showing:=nil;
  //(*
    GetCode;
    if NoMemoSource then exit;

    FExplorer.InitializeUpdate; //safe
    FExplorer.DoPodCoding; //safe

    ExplorerUpdating:=true;
    try
     Synchronize(DoUpdate);
    finally
     ExplorerUpdating:=false;
    end;

    FExplorer.LevelCoding; //safe
    FExplorer.Showing:=FWillDo;

    if (ActiveScriptInfo<>nil) and
       (ActiveScriptInfo.ms=FExplorer.Showing) and
       (ActiveScriptInfo.JustLoaded) then
    begin
     ActiveScriptInfo.JustLoaded:=false;
     Synchronize(PR_GoodFolderUpdate);
    end;

    Synchronize(PR_FinishedExplorer);
   //*)
end;

procedure TExplorerThread.Execute;
begin
 repeat
  if WaitForSingleObject(EventStartExplorer,INFINITE)=WAIT_OBJECT_0 then
  begin

   TicksNextExplorer:=GetTickCount+TicksTimeOut;
   if WaitForSingleObject(CSEntireExplorer,INFINITE)=WAIT_OBJECT_0 then
    try
      if (assigned(ActiveScriptInfo)) then
      try
       ExecuteLoop;
      except
       try
        FExplorer.Code.Clear;
        Assert(false,'LOG *** Explorer Thread Exception');
       except end;
      end;
    finally
      ReleaseMutex(CSEntireExplorer);
    end;
   TicksNextExplorer:=0;

  end;
 until terminated;
 Assert(false,'LOG *** Explorer Thread Terminated');
end;

procedure TExplorerThread.GetCode;
var
 i,Alines:integer;
 s:string;
begin
 FExplorer.Code.Clear;
 FExplorer.Syntax.Clear;
 if NoMemoSource then exit;

 EditorEnterCS; //Explorer Thread
 try
  ALines:=activeScriptInfo.ms.Lines.Count;
  CodeGetExplorerSkip:=false;
  FExplorer.FFilename:=ActiveScriptInfo.path;
  FWillDo:=ActiveScriptInfo.ms;
 finally
  EditorLeaveCS(false);
 end;

 i:=0;
  with activeScriptInfo.ms, FExplorer do
  While (i<Alines) do
  begin

   EditorEnterCS; //Explorer Thread
   try
    if (not NoMemoSource) and (not CodeGetExplorerSkip) and (I<StrCount) then
     with stringitem[i] do
      begin
       s:=GetColorData(i);
       checkcolordata(StrData,s);
       Syntax.AddObject(s,TObject(ParserState));
       s:=lines[i];
       Code.Add(s);
       inc(i);
      end
     else
      begin
       FExplorer.Code.Clear;
       Assert(false,'LOG EXPR EXIT: '+Bool2Str(NoMemoSource)+' '+Bool2Str(CodeGetCodeSkip));
       EditorLeaveCS(false);
       exit;
      end;
   finally
    EditorLeaveCS(false);
   end;

  end;
end;

procedure TExplorerThread.SetFoldingLength;
begin
 setLength(FExplorer.Folding,FExplorer.Code.Count);
end;

procedure TExplorerForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=barmanager.Bars[0].ItemLinks;
end;

procedure TExplorerForm.ApplicationEventsShowHint(var HintStr: String;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
 if HintInfo.HintControl=VST then
 begin
  hintinfo.HideTimeout:=60000;
  hintinfo.HintColor:=$00FEF3ED;
 end;
end;

procedure TExplorerForm.HighlightPositionItemClick(Sender: TObject);
var
 sd : PData;
begin
 sd:=vst.GetNodeData(vst.FocusedNode);
 if not assigned(sd) then exit;
 PR_setPattern(TMenuItem(sender).Tag,sd.path,false);
end;

procedure TExplorerForm.DoGoNext(Next : Boolean);
var
 data : PData;
 node : PVirtualNode;

 Function FindNext : PVirtualNode;
 begin
  if not assigned(vst.FocusedNode) then
  begin
   if next
    then result:=vst.GetFirstChild(SearchNode)
    else result:=vst.GetLastChild(SearchNode);
   exit;
  end;

  data:=vst.GetNodeData(vst.FocusedNode.Parent);
  if (assigned(data)) and (data.usage=#0) then
  begin
   if next
    then result:=vst.GetNextSibling(vst.FocusedNode)
    else result:=vst.GetPreviousSibling(vst.FocusedNode);
   if not assigned(result) then
   begin
    if next
     then result:=vst.GetFirstChild(vst.FocusedNode.parent)
     else result:=vst.GetLastChild(vst.FocusedNode.Parent);
   end;
   exit;
  end;

  data:=vst.GetNodeData(vst.FocusedNode);
  if (assigned(data)) and (data.usage=#0) then
  begin
   if next
    then result:=vst.GetFirstChild(vst.FocusedNode)
    else result:=vst.GetLastChild(vst.FocusedNode);
   exit;
  end;

  if next
   then result:=vst.GetFirstChild(SearchNode)
   else result:=vst.GetLastChild(SearchNode);
 end;

begin
 node:=FindNext;
 data:=vst.GetNodeData(node);
 if assigned(data) then
 begin
  PR_GotoLine(data.path,data.line);
  vst.FocusedNode:=node;
  vst.Selected[node]:=true;
 end;
end;

procedure TExplorerForm.ArchiveSearchItemClick(Sender: TObject);
var
 sd,data : PData;
 Node : PvirtualNode;
begin
 vst.BeginUpdate;
 try
  node:=vst.AddChild(vst.RootNode);
  vst.MoveTo(SearchNode,node,amAddChildFirst,true);
  sd:=vst.GetNodeData(node);
  data:=vst.GetNodeData(SearchNode);

  sd^:=data^;
  data:=vst.GetNodeData(SearchNode);
  data.Str:='Search Results';
  data.line:=-1;
 finally
  vst.EndUpdate;
 end;
end;

procedure TExplorerForm.SearchMenuPopup(Sender: TObject);
begin
 ArchiveSearchItem.Visible:=(vst.FocusedNode=searchNode) and (searchNode.ChildCount>0)
end;

Procedure TExplorerForm.GotoBookmark(num : Integer);
var
 Node : PvirtualNode;
 data : PData;
 s:string;
begin
 node:=vst.GetFirstChild(itemNodes[inBookmarks]);
 if num=10 then num:=0;
 s:=inttostr(num);
 while assigned(node) do
 begin
  data:=vst.GetNodeData(node);
  if data.usage=s then
  begin
   PR_GotoLine(data.path,data.line);
   break;
  end;
  node:=vst.GetNextSibling(node);
 end;
end;

Procedure TExplorerForm.AddBookmark(Const path : string; Line,BookNum: integer);
var
 data : PData;
 s:string;
 Node : PvirtualNode;
 i:integer;
begin
 node:=vst.GetFirstChild(itemNodes[inBookmarks]);
 if booknum=10 then booknum:=0;
 s:=inttostr(booknum);
 while assigned(node) do
 begin
  data:=vst.GetNodeData(node);
  if (data.usage=s) then break;
  node:=vst.GetNextSibling(node)
 end;

 if not assigned(node) then
  node:=vst.AddChild(itemNodes[inBookmarks]);

 data:=vst.GetNodeData(node);
 data.line:=line;
 data.dataline:=path+#13#10+'Line: '+inttostr(line+1);
 data.path:=path;
 data.usage:=s;
 s:=extractFileNoExt(Path);
  if length(s)=0 then s:=ExtractFilePath(path);
 data.Str:=data.usage+':'+s+':'+inttostr(data.line+1);

 vst.Sort(itemNodes[inBookmarks],0,sdAscending);
end;

procedure TExplorerForm.VSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
begin
 Hinttext:=gethint(node);
end;

end.


