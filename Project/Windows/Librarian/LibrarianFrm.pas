unit LibrarianFrm; //Modeless //memo 1//VST //StatusBar //Splitter
{$I REG.INC}

interface

uses Windows, Forms, dccommon, dcmemo, ExtCtrls, dcsystem, dcparser,
  Controls, Classes, VirtualTrees, Menus, ActnList, dcstring, graphics,
  ComCtrls,  StdCtrls,dialogs, hakageneral,hyperstr,ParsersMdl,hyperFrm,
  ImgList,activex,sysutils,OptGeneral,OptFolders,clipbrd,JclIniFIles,
  hakafile,hkstreams,OptForm,OptOptions, ZipMstr,ImageListEx, CentralImageListMdl,
  dxBar,OptProcs;

type
  TLibrarianForm = class(TOptiForm)
    VST: TVirtualStringTree;
    Splitter: TSplitter;
    MemLib: TDCMemo;
    LibSource: TMemoSource;
    LibActionList: TActionList;
    AddItemAction: TAction;
    AddFolderAction: TAction;
    DeleteAction: TAction;
    CollapseAllAction: TAction;
    ExpandAllAction: TAction;
    ExportLibAction: TAction;
    ImportLibAction: TAction;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    InsertCodeAction: TAction;
    CopyCodeAction: TAction;
    RenameAction: TAction;
    Zip: TZipMaster;
    OPLOpenDialog: TOpenDialog;
    StatusBar: TStatusBar;
    CancelAction: TAction;
    BarManager: TdxBarManager;
    dxCollapseAll: TdxBarButton;
    dxAddItem: TdxBarButton;
    dxAddFolder: TdxBarButton;
    dxDelete: TdxBarButton;
    dxExpandAll: TdxBarButton;
    dxSaveZip: TdxBarButton;
    dxImport: TdxBarButton;
    dxInsert: TdxBarButton;
    dxCopyCode: TdxBarButton;
    dxRename: TdxBarButton;
    dxCancel: TdxBarButton;
    siEdit: TdxBarSubItem;
    siFile: TdxBarSubItem;
    PopupMenu: TdxBarPopupMenu;
    siPopUp: TdxBarSubItem;
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
    procedure ExportLibActionExecute(Sender: TObject);
    procedure ImportLibActionExecute(Sender: TObject);
    procedure AddItemActionExecute(Sender: TObject);
    procedure ExpandAllActionExecute(Sender: TObject);
    procedure CollapseAllActionExecute(Sender: TObject);
    procedure VSTDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure DeleteActionExecute(Sender: TObject);
    procedure VSTNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      column: TColumnIndex; Text: WideString);
    procedure AddFolderActionExecute(Sender: TObject);
    procedure AddItemActionUpdate(Sender: TObject);
    procedure AddFolderActionUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TrueIfFocusedUpdate(Sender: TObject);
    procedure InsertCodeActionExecute(Sender: TObject);
    procedure CopyCodeActionExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RenameActionUpdate(Sender: TObject);
    procedure RenameActionExecute(Sender: TObject);
    procedure VSTDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure VSTGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; column: TColumnIndex;
      var Ghosted: Boolean; var Index: Integer);
    procedure VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; column: TColumnIndex; var Result: Integer);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ZipDirUpdate(Sender: TObject);
    procedure VSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure TrueIfFocAndText(Sender: TObject);
    procedure ZipProgress(Sender: TObject; ProgrType: ProgressType;
      Filename: String; FileSize: Integer);
    procedure ZipMessage(Sender: TObject; ErrCode: Integer;
      Message: String);
    procedure VSTClick(Sender: TObject);
    procedure VSTKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EnabledIfNotBusy(Sender: TObject);
    procedure VSTFocusChanging(Sender: TBaseVirtualTree; OldNode,
      NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
      var Allowed: Boolean);
    procedure CancelActionUpdate(Sender: TObject);
    procedure CancelActionExecute(Sender: TObject);
    procedure VSTEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VSTMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  Protected
   Procedure FirstShow(Sender: TObject); override;
   Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); override;
  private
    ZipFile : String;
    RootDir : String;
    Number : Integer;
    SystemImageList: TImageListEx;
    FUncompressedTotal: Cardinal;
    FCompressedTotal: Cardinal;
    Focused : TStringList;
    LastFullPath : String;
    LastOpenNode : PVirtualNode;
    IsBusy : Boolean;
    DidCancel : Boolean;

    procedure VTreeFillData;
    procedure AddItem(IsFile: Boolean);
    function FileExist(isFile: Boolean; Const Path : String): Boolean;
    function GetNewFile(isFile: Boolean; Index: Integer): String;
    procedure GetFocused;
    procedure SetFocused;
    procedure DeleteFolder(const d: string);
    procedure DoRename(const Source, Dest: String);
    procedure ImportLib(const Filename: String);
    procedure DoSetWorking(Working: Boolean);
    procedure DoChangeFocus(Node: PVirtualNode; ForceSave,FocusLast : Boolean);
    procedure SetBusy(Busy: Boolean);
  protected
    procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix, index: Integer); override;
  public
    Constructor Create(Num : Integer; Const Zip : String); reintroduce;
  end;

  TOldImpMod = class
  private
    VST: TVirtualStringTree;
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTLoadNode(Sender: TBaseVirtualTree; Node: PVirtualNode; Stream: TStream);
    function VSTGetFolder(node: PVirtualNode): String;
  public
    Procedure OpenOPL(const Filename : String);
  end;

var
 //OpenLibs : TStringList;
 CodeLibrarians : Array[0..3] of TLibrarianForm;

Procedure CreateLibrarian(Const Zip : String);
function IniCreateLibrarian(Num : Integer) : Boolean;
Function LibrarianAvailable : Boolean;

implementation

const
 NewText = 'New Snippet.pl';
 NewText2 = 'New Snippet %d.pl';
 NewFolder = 'New Folder';
 NewFolder2 = 'New Folder %d';
 iniLib = 'CodeLibrarian';

Function LibrarianAvailable : Boolean;
begin
 result:=(CodeLibrarians[0]=nil) or (CodeLibrarians[1]=nil) or
         (CodeLibrarians[2]=nil) or (CodeLibrarians[3]=nil);
end;

function IniCreateLibrarian(Num : Integer) : Boolean;
var zip : string;
begin
 result:=false;
 if not LibrarianAvailable then exit;
 zip:=iniReadString(Folders.IniFile,iniLib,inttostr(num));
 if not fileexists(zip) then exit;
 result:=true;
 CodeLibrarians[num]:=TLibrarianForm.Create(num,zip);
 CodeLibrarians[num].Show;
end;

Procedure CreateLibrarian(Const Zip : String);
var i:integer;
begin
 if not fileexists(zip) then
  savestr('PK'#5#6+stringofchar(#0,18),zip);

 for i:=0 to high(CodeLibrarians) do
  if assigned(CodeLibrarians[i]) and issamefile(zip,CodeLibrarians[i].ZipFile) then
  begin
   CodeLibrarians[i].Show;
   exit;
  end;

 i:=0;
 while assigned(CodeLibrarians[i]) do
  inc(i);
 CodeLibrarians[i]:=TLibrarianForm.Create(i,zip);
 CodeLibrarians[i].Show;
end;

type
  TPNodeData = ^TNodeData;
  TNodeData = Record
    Index: Integer;
    Path: String;
    FullPath: String;
  End;

{$R *.DFM}
{$R ZipMsgUS.res}

constructor TLibrarianForm.Create(Num: Integer; const Zip: String);
begin
 number:=num;
 ZipFile:=zip;
 inherited CreateNamed(application,'LibrarianForm'+inttostr(num));

 if ZipFile<>Folders.SnippetFile
  then SetCaption(zipfile+' - Code Librarian')
  else SetCaption('Code Librarian');
end;

Procedure TLibrarianForm.DoSetWorking(Working : Boolean);
begin
 if Working
  then screen.Cursor:=crHourglass
  else Screen.Cursor:=crDefault;
end;

procedure TLibrarianForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; TextType: TVSTTextType;
  var Text: WideString);
Var
  Data1: TPNodeData;
Begin
   Begin
    Data1 := TPNodeData(VST.GetNodeData(Node));
    if data1.Index>=0
     then Text := ExtractFileNoExt(Data1.Path)
     else text:=data1.Path;
   End
end;

procedure TLibrarianForm.ExportLibActionExecute(Sender: TObject);
begin
 if SaveDialog.Execute then
  CopyFile(pchar(ZipFile),Pchar(saveDialog.filename),false);
end;

Procedure TLibrarianForm.ImportLib(const Filename : String);
var
 OldImpMod : TOldImpMod;
begin
  OldImpMod:=TOldImpMod.Create;
  try
   OldImpMod.OpenOPL(FileName);
   zip.AddOptions:=[AddDirNames,AddRecurseDirs];
   zip.FSpecArgs.text:='Imported\*.*';

   GetFocused;
   SetBusy(true);
   try
    Zip.add;
   finally
    SetBusy(false);
    SetFocused;
   end;

   deltree(zip.RootDir+'Imported\');
  finally
   OldImpMod.Free;
  end;
end;

procedure TLibrarianForm.ImportLibActionExecute(Sender: TObject);
begin
 if OPLOpenDialog.Execute then
  ImportLib(OPLOpenDialog.FIlename);
end;

Procedure TLibrarianForm.VTreeFillData;

  Procedure GetParsedPath(AInput: String; AList: TStrings);
  Const
    Delimiter = '\';
    DelimiterLen = Length(Delimiter);
  Var
    DelimiterPos1: Integer;
    TempStr: String;
  Begin
    AList.Clear;
    Repeat
      DelimiterPos1 := Pos(Delimiter, AInput);
      If DelimiterPos1 = 0 Then TempStr := AInput
      Else TempStr := Copy(AInput, 1, DelimiterPos1 - 1);
      If (TempStr <> '') Then Begin
        AList.Add(Trim(TempStr));
        AInput := Copy(AInput, DelimiterPos1 + DelimiterLen, Length(AInput) - DelimiterPos1);
      End;
    Until DelimiterPos1 = 0;
  End;

  Procedure AddEndLeaf(ANode: PVirtualNode; AList: TStrings; ANodeData: TNodeData);
  Var
    Data1: TPNodeData;
    Data2: TPNodeData;
    Node1: PVirtualNode;
    Node2: PVirtualNode;
  Begin
    Node1 := VST.AddChild(ANode);
    Node2 := Node1.Parent;
    Data1 := TPNodeData(VST.GetNodeData(Node1));
    Data2 := TPNodeData(VST.GetNodeData(Node2));
    Data1.Index := -1;
    Data1.Path := AList[0];
    If assigned(data2) and (Data2.FullPath <> '')
      Then Data1.FullPath := Data2.FullPath + '\' + Data1.Path
      Else Data1.FullPath := Data1.Path;

    AList.Delete(0);
    If AList.Count >= 1 Then AddEndLeaf(Node1, AList, ANodeData)
    Else Data1.Index := ANodeData.Index;
  End;

  Procedure PlaceIntoTree(ANode: PVirtualNode; AList: TStrings; ANodeData: TNodeData);
  Var
    Data1: TNodeData;
    Node1: PVirtualNode;
  Begin
    If (AList.Count > 0) And (ANode.ChildCount > 0) Then Begin
      Node1 := ANode.FirstChild;
      While Assigned(Node1) Do Begin
        Data1 := TNodeData(VST.GetNodeData(Node1)^);
        If Data1.Path = AList[0] Then Begin
          AList.Delete(0);
          If AList.Count > 0 Then PlaceIntoTree(Node1, AList, ANodeData);
          Exit;
        End;
        Node1 := Node1.NextSibling;
      End;
    End;
    AddEndLeaf(ANode, AList, ANodeData); //If it has not exited, it must add as leaf node.
  End;
Var
  i: Integer;
  Data1: TNodeData;
  PathList1: TStrings;
  Node1: PVirtualNode;
  ZipDirEntry1: ZipDirEntry;
Begin
  FUncompressedTotal := 0;
  FCompressedTotal := 0;
  VST.BeginUpdate;
  If Zip.Count = 0 Then Begin
    VST.Clear;
    VST.EndUpdate;
    Exit;
  End;

  VST.Clear;
  PathList1 := TStringList.Create;
  node1:=vst.RootNode;

  For i := 0 To Zip.Count - 1 Do Begin
    Data1.Index := i;
    Data1.Path := '';
    ZipDirEntry1 := ZipDirEntry(Zip.ZipContents[i]^);
    GetParsedPath(ZipDirEntry1.FileName, PathList1);
    PlaceIntoTree(Node1, PathList1, Data1);
    FUncompressedTotal := FUncompressedTotal + Cardinal(ZipDirEntry1.UncompressedSize);
    Inc(FCompressedTotal, ZipDirEntry1.CompressedSize);
  End;

  for i:=0 to zip.dircontents.Count-1 do
  begin
    Data1.Index := -1;
    Data1.Path := '';
    GetParsedPath(zip.dircontents[i], PathList1);
    PlaceIntoTree(Node1, PathList1, Data1);
  end;

  PathList1.Free;
  VST.SortTree(0, sdAscending, True);
  VST.EndUpdate;
End;


procedure TLibrarianForm.VSTGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; column: TColumnIndex;
  var Ghosted: Boolean; var Index: Integer);
Var
  Data1: TPNodeData;
  ZipEntry1: ZipDirEntry;
Begin
  Data1 := TPNodeData(VST.GetNodeData(Node));
  If Data1.Index >= 0 Then Begin
    ZipEntry1 := ZipDirEntry(Zip.ZipContents[Data1.Index]^);
    Index := SystemImageList.GetVirtualFileSystemIconIndex(ZipEntry1.FileName);
  End Else If (vsSelected In Node.States) Then Index := SystemImageList.GetOpenFolderIndex
  Else Index := SystemImageList.GetClosedFolderIndex;
end;


procedure TLibrarianForm.DoRename(Const Source,Dest : String);
var
 ZipRenameList:	TList;
 RenRec: pZipRenameRec;
begin
 if AnsiCompareText(source,dest)=0 then
 begin
  MessageDlg('Filename already exists.', mtError, [mbOK], 0);
  exit;
 end;
 ZipRenameList:= TList.Create;
 New(RenRec);
 try
  RenRec^.Source:=Source;
  RenRec^.Dest:=Dest;
  RenRec^.DateTime:=0;
  ZipRenameList.Add(RenRec);

  GetFocused;
  SetBusy(true);
  try
   Zip.Rename( ZipRenameList,0 );
  finally
   SetBusy(false);
   SetFocused;
  end;

 finally
  Dispose( RenRec );
  ZipRenameList.Free;
 end;
end;

procedure TLibrarianForm.VSTNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; column: TColumnIndex; Text: WideString);
var
 Data: TPNodeData;
 s,ext:string;
begin
 Data := Sender.GetNodeData(Node);
 if not Assigned(Data) then exit;
 text:=GetSafeFilename(text);

 s:=ExtractFilepath(data.FullPath);
 ext:=ExtractFileExt(data.fullpath);
 s:=s+text;
 if fileexist(false,s) or
    fileexist(True,s) then
 begin
  MessageDlg('Filename already exists.', mtError, [mbOK], 0);
  exit;
 end;
 if (pos('.',text)=0) and (data.Index>=0)
  then s:=extractFilepath(data.FullPath)+text+ext
  else s:=extractFilepath(data.FullPath)+text;
 DoRename(data.FullPath,s);
end;


procedure TLibrarianForm.VSTDragDrop(Sender: TBaseVirtualTree;
  Source: TObject; DataObject: IDataObject; Formats: TFormatArray;
  Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var
  I: Integer;
  datas,datat : TPNodeData;
  s,temp,text:string;
  Zs : TZipStream;
  RemForm : TLibrarianForm;
begin
 memlib.ReadOnly:=not assigned(sender.focusednode);
    for I := 0 to High(Formats) do
      if (Formats[I] = CF_VIRTUALTREE) then
      begin

       if Source<>vst then
        begin
         RemForm:=TLibrarianForm(TControl(source).parent);
         dataS:=RemForm.VST.GetNodeData(RemForm.VST.FocusedNode)
        end
       else
        begin
         RemForm:=nil;
         DataS:=vst.GetNodeData(Sender.FocusedNode);
        end;

       case mode of
        dmOnNode:
        if vst.DropTargetNode<>nil then
        begin
         dataT:=vst.GetNodeData(vst.DropTargetNode);
         if (not assigned(dataS)) or (not assigned(dataT)) then exit;
         s:=dataT.FullPath+'\'+ExtractFilename(dataS.FullPath);
         if fileexist(false,s) or
            fileexist(True,s) then
         begin
          MessageDlg('Filename already exists.', mtError, [mbOK], 0);
          exit;
         end;
         if Source<>vst then
          begin
           if datas.Index<0
            then exit
            else remform.Zip.FSpecArgs.Text:=datas.FullPath;

           SetBusy(true);
           try
            zs:=remform.zip.ExtractFileToStream(dataS.FullPath);
           finally
            SetBusy(false);
           end;
           if not assigned(zs) then exit;
           setLength(text,zs.size);
           zs.read(text[1],length(text));

           Temp:=RootDir+datat.FullPath;
           forcedirectories(temp);
           zip.FSpecArgs.Text:=datat.fullpath+'\'+extractfilename(datas.FullPath);
           s:=temp+'\'+extractfilename(datas.FullPath);
           savestr(text,s);
           zip.AddOptions:=[AddDirNames];

           GetFocused;
           SetBusy(true);
           try
            zip.Add;
           finally
            SetBusy(false);
            SetFocused;
           end;
           DeleteFolder(RootDir);
          end
         else
           DoRename(dataS.FullPath,s);
        end;

        dmAbove:
        begin

         if (not assigned(dataS)) then exit;
         s:=ExtractFilename(dataS.FullPath);
         if fileexist(false,s) or
           fileexist(True,s) then
         begin
          MessageDlg('Filename already exists.', mtError, [mbOK], 0);
          exit;
         end;
         if Source=vst
         then
          DoRename(datas.FullPath,s)
         else
          begin
           if datas.Index<0
            then exit;
           zs:=remform.zip.ExtractFileToStream(dataS.FullPath);
           if not assigned(zs) then exit;
           setLength(text,zs.size);
           zs.read(text[1],length(text));
           forcedirectories(RootDir);
           savestr(text,RootDir+extractfilename(datas.FullPath));
           zip.FSpecArgs.Text:=extractfilename(datas.FullPath);
           GetFocused;
           SetBusy(true);
           try
            zip.Add;
           finally
            SetBusy(false);
            SetFocused;
           end;
           DeleteFolder(RootDir);
          end;

        end;
       end; //case
      end;
end;

procedure TLibrarianForm.ExpandAllActionExecute(Sender: TObject);
begin
 vst.FullExpand;
end;

procedure TLibrarianForm.CollapseAllActionExecute(Sender: TObject);
begin
 vst.FullCollapse;
end;

procedure TLibrarianForm.VSTDragOver(Sender: TBaseVirtualTree;
  Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint;
  Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
var
 Data: TPNodeData;
begin
 accept:=false;
 if (vst.DropTargetNode=vst.FocusedNode) then exit;
 if (memLib.MemoSource.Modified) then exit;
 if (isBusy) then exit;
 if (not (source is TVirtualStringTree)) or
    (not (TControl(source).Parent is TLibrarianForm)) then exit;
 if (mode=dmAbove) and (vst.DropTargetNode=vst.GetFirst) then
 begin
  Accept:=true;
  exit;
 end;

 if (mode<>dmOnNode)
  then exit;

 data:=vst.GetNodeData(vst.DropTargetNode);
 Accept:=(assigned(data)) and (data.Index<0);
end;

procedure TLibrarianForm.GetFocused;
var
 Data: TPNodeData;
 node: PVirtualNode;
begin
 VST.BeginUpdate;
 Focused.Clear;
 node:=vst.GetFirst;
 while assigned(node) do
 begin
  data:=vst.GetNodeData(node);
  if assigned(data) then
   Focused.AddObject(data.FullPath,TObject(vsExpanded in node.States));
  node:=vst.GetNext(node);
 end;
end;

procedure TLibrarianForm.SetFocused;
var
 Data: TPNodeData;
 node: PVirtualNode;
 i:integer;
begin
 node:=vst.GetFirst;
 while assigned(node) do
 begin
  data:=vst.GetNodeData(node);
  if assigned(data) then
  begin
   i:=Focused.IndexOf(data.FullPath);
   if i>=0 then
    vst.Expanded[node]:=Boolean(Focused.Objects[i]);
  end;
  node:=vst.GetNext(node);
 end;
 Focused.Clear;
 VST.EndUpdate;
end;

procedure TLibrarianForm.DeleteActionExecute(Sender: TObject);
var
 Data: TPNodeData;
 s:string;
 node,LNode: PVirtualNode;
 ZipEntry: PZipDirEntry;
begin
 if not assigned(vst.focusednode) then exit;

 LastFullPath:='';
 data:=VSt.GetNodeData(vst.FocusedNode);
 if data.Index>=0 then
  begin
   ZipEntry:=zip.ZipContents[data.index];
   if (MessageDlg('Are you sure you want to delete file "'+ZipEntry^.FileName+'"?', mtConfirmation,
       [mbYes, mbCancel], 0)=mrCancel) then exit;
   zip.FSpecArgs.Text:=ZipEntry^.FileName;
  end
 else
  begin
   s:=data.FullPath+'\';
   if (MessageDlg('Are you sure you want to delete folder "'+data.FullPath+'"?', mtConfirmation,
       [mbYes, mbCancel], 0)=mrCancel) then exit;
   LNode:=vst.GetNextSibling(vst.FocusedNode);
   node:=vst.GetFirstChild(vst.FocusedNode);
   zip.FSpecArgs.Clear;

   while (assigned(node)) and (node<>LNode) do
   begin
    data:=vst.GetNodeData(node);
    if (assigned(data)) then
    begin
     if data.Index>=0
      then zip.FSpecArgs.Add(data.FullPath)
      else zip.FSpecArgs.Add(data.FullPath+'\');
    end;
    node:=vst.GetNext(node);
   end;
   zip.FSpecArgs.Add(s);
  end;

 GetFocused;
 SetBusy(true);
 try
  zip.Delete;
  memLib.Lines.Clear;
  memLib.MemoSource.Modified:=false;
  memLib.ReadOnly:=true;
  LastFullPath:='';
  if (vst.RootNodeCount=0) then
  begin
   MessageDlg('Archive is empty. Adding a single item.', mtInformation, [mbOK], 0);
   AddFolderAction.Execute;
  end;
 finally
  SetBusy(false);
  SetFocused;
 end;
end;

procedure TLibrarianForm.DoChangeFocus(Node : PVirtualNode; ForceSave,FocusLast  : Boolean);
var
  Data: TPNodeData;
  Zs : TZipStream;
  d,f:string;
begin
 DidCancel:=False;

 if not ForceSave then
 begin
  data:=vst.GetNodeData(node);
  if not assigned(node) then exit;
  if data.fullpath=LastFullPath then exit;
 end;

 if (LibSource.Modified) and ((LastFullPath<>'') or (forceSave)) then
 begin
  if (OPtions.codelibprompt) and (not Application.terminated) and
     (MessageDlg('Would you like to save the changes made?', mtWarning, [mbOK,mbCancel], 0)=mrCancel) then
  begin
   if (FocusLast) and (LastOpenNode<>nil) then
   try
    Vst.focusednode:=LastOpenNode;
    VST.Selected[LastOpenNode]:=true;
   except
    LastOpenNode:=nil;
   end;
   DidCancel:=true;
   exit;
  end;

  f:=zip.RootDir+LastFullPath;
  d:=ExtractFilePath(f);
  ForceDirectories(d);
  LibSource.SaveToFile(f);
  zip.FSpecArgs.Text:=LastFullPath;
  zip.AddOptions:=[AddDirNames];
  zip.OnDirUpdate:=nil;
  SetBusy(true);
  try
   zip.Add;
  finally
   zip.OnDirUpdate:=ZipDirUpdate;
   SetBusy(false);
  end;
  DeleteFolder(RootDir);
 end;

 LibSource.Modified:=false;
 if ForceSave then exit;

 IsBusy:=true;
 CloseEnabled(false);
 try
  zs:=zip.ExtractFileToStream(data.FullPath);
 finally
  IsBusy:=False;
  CloseEnabled(true);
 end;
 if assigned(zs) then
  begin
   memLib.Lines.LoadFromStream(zs);
   LibSource.SyntaxParser:=ParsersMod.GetParser(extractfileext(data.Path));
   LastFullPath:=data.FullPath;
   LastOpenNode:=node;
  end
 else
  begin
   memLib.Lines.Clear;
   if data.Index>=0
    then lastFullPath:=data.FullPath
    else LastFullPath:='';
  end;
 LibSource.Modified:=false;
 memLib.ReadOnly:=data.Index<0;

end;

procedure TLibrarianForm.DeleteFolder(const d:string);
var
 s:string;
begin
 s:=ExtractFilepath(d);
 DelTree(s);
end;

Function TLibrarianForm.GetNewFile(isFile : Boolean; Index : Integer) : String;
begin
 if isFile then
  begin
   if index=0
    then result:=NewText
    else result:=Format(newText2,[index]);
  end
 else
  begin
   if index=0
    then result:=NewFolder
    else result:=Format(newFolder2,[index]);
  end;
end;

Function TLibrarianForm.FileExist(isFile : Boolean; Const Path : String) : Boolean;
var i:integer;
begin
 if not isFile then
  begin
   for i:=0 to zip.ZipContents.Count-1 do
    if StringStartsWithCase(IncludeTrailingBackSlash(Path),
     PZipDirEntry(zip.ZipContents[i])^.FileName) then
    begin
     result:=true;
     exit;
    end;
   result:=false;
  end

 else
  begin
   for i:=0 to zip.ZipContents.Count-1 do
    if AnsiCompareText(PZipDirEntry(zip.ZipContents[i])^.FileName,path)=0 then
    begin
     result:=true;
     exit;
    end;
   result:=false;
  end;
end;

procedure TLibrarianForm.AddItem(IsFile : Boolean);
var
 node : PVirtualNode;
 Data: TPNodeData;
 s,d,nt:string;
 c:integer;
begin
 s:=zip.RootDir;
 node:=vst.FocusedNode;
 data:=vst.GetNodeData(node);

 if assigned(data) and (data.Index>=0) then
  begin
   node:=node.Parent;
   data:=vst.GetNodeData(node);
   if assigned(data)
    then d:=data.FullPath+'\'
    else d:='';
  end
 else
  begin
   if assigned(data)
    then d:=data.FullPath+'\'
    else d:='';
  end;

 if not isFile then
 begin
  c:=0;
  repeat
   nt:=d+GetNewFile(false,c);
   inc(c);
  until not FileExist(false,nt);
  d:=nt+'\';
 end;

 s:=s+d;
 ForceDirectories(s);

 c:=0;
 repeat
  nt:=getNewFile(true,c);
  inc(c);
 until not fileexist(true,d+nt);

 s:=s+nt;
 SaveStr('',s);

 d:=d+nt;
 zip.FSpecArgs.Text:=d;
 zip.AddOptions:=[AddDirNames];
 GetFocused;
 SetBusy(true);

 try
  zip.Add;
 finally
  SetBusy(false);

  node:=vst.GetFirst;
  while assigned(node) do
  begin
   data:=vst.GetNodeData(node);
   if assigned(data) and (data.FullPath=d) then
   begin
    vst.FocusedNode:=node;
    vst.Selected[node]:=true;
    vst.SetFocus;
    break;
   end;
   node:=vst.GetNext(node);
  end;

  SetFocused;
  vst.ScrollIntoView(node,true);
 end;
 DeleteFolder(RootDir);
end;

procedure TLibrarianForm.AddItemActionExecute(Sender: TObject);
begin
 if Sender.ClassName<>'TAction' then Exit;
 AddItem(True);
end;

procedure TLibrarianForm.AddFolderActionExecute(Sender: TObject);
begin
 addItem(false);
end;

procedure TLibrarianForm.AddItemActionUpdate(Sender: TObject);
begin
 AddItemAction.Enabled:=(Not IsBusy) and (not memLib.MemoSource.Modified) and
  ((Assigned(vst.focusednode)) or (vst.RootNodeCount=0));
end;

procedure TLibrarianForm.AddFolderActionUpdate(Sender: TObject);
begin
 AddFolderAction.Enabled:=(not isbusy) and (not memLib.MemoSource.Modified) and
 ((Assigned(vst.focusednode)) or (vst.RootNodeCount=0));
end;

procedure TLibrarianForm.FormDestroy(Sender: TObject);
begin
 iniWriteString(folders.IniFile,iniLib,inttostr(number),zipfile);
 Focused.Free;
 CodeLibrarians[number]:=nil;
end;

procedure TLibrarianForm.TrueIfFocusedUpdate(Sender: TObject);
begin
 TAction(Sender).Enabled:=(not isbusy) and (assigned(vst.focusednode)) and (not memLib.MemoSource.Modified);
end;

procedure TLibrarianForm.VSTCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; column: TColumnIndex; var Result: Integer);
var
  Data1: TPNodeData;
  Data2: TPNodeData;
begin
 Data1 := TPNodeData(VST.GetNodeData(Node1));
 Data2 := TPNodeData(VST.GetNodeData(Node2));
 If (Data1.Index >= 0) And (Data2.Index >= 0) Then
  Begin
   Result := AnsiCompareText(Data1.FullPath, Data2.FullPath);
  End
 Else
 If (Data1.Index < 0) And (Data2.Index < 0) Then
  Result := AnsiCompareText(Data1.FullPath, Data2.FullPath)
 Else
 If (Data1.Index < 0) Then
  Result := -1
 Else
 If (Data2.Index < 0) Then Result := 1;
end;

procedure TLibrarianForm.InsertCodeActionExecute(Sender: TObject);
begin
 PR_insertTextAtCursor(MemLib.LineS.Text);
end;

procedure TLibrarianForm.CopyCodeActionExecute(Sender: TObject);
begin
 ClipBoard.AsText:=memlib.Lines.text;
end;


procedure TLibrarianForm.RenameActionUpdate(Sender: TObject);
begin
 RenameAction.enabled:=(not isbusy) and (Assigned(VST.FocusedNode));
// and (not memLib.MemoSource.Modified);
end;

procedure TLibrarianForm.RenameActionExecute(Sender: TObject);
var
 Data: TPNodeData;
 s,ext,text:string;
 node : PVirtualNode;
begin
 if memLib.MemoSource.Modified then
 begin
  DoChangeFocus(vst.FocusedNode,true,false);
  if memLib.MemoSource.Modified then
   exit;
 end;
 node:=vst.focusednode;
 Data := Vst.GetNodeData(Node);
 if not Assigned(Data) then exit;
 text:=extractfilename(data.fullPath);
 if not inputQuery('Rename','Enter new name',text) then exit;
 text:=GetSafeFilename(text);
 s:=ExtractFilepath(data.FullPath);
 ext:=ExtractFileExt(data.fullpath);
 s:=s+text;
 if fileexist(false,s) or
    fileexist(True,s) then
 begin
  MessageDlg('Filename already exists.', mtError, [mbOK], 0);
  exit;
 end;
 if (pos('.',text)=0) and (data.Index>=0)
  then s:=extractFilepath(data.FullPath)+text+ext
  else s:=extractFilepath(data.FullPath)+text;
 DoRename(data.FullPath,s);
end;

procedure TLibrarianForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Data : TPNodeData;
begin
 Data:=VST.GetNodeData(node);
 with data^ do
 begin
  setlength(Path,0);
  Setlength(FullPath,0);
 end;
end;

procedure TLibrarianForm.ZipDirUpdate(Sender: TObject);
begin
 SetBusy(true);
 try
  VTreeFillData;
 finally
  SetBusy(false);
 end;
end;

procedure TLibrarianForm.VSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
 Data : TPNodeData;
begin
 if (node.ChildCount>0) or (node.Parent=sender.rootnode) then
  begin
   data:=vst.GetNodeData(node);
   if data.Index<0
    then TargetCanvas.Font.style:=[fsbold]
    else TargetCanvas.Font.style:=[];
  end
 else
  TargetCanvas.Font.style:=[];
end;

procedure TLibrarianForm.TrueIfFocAndText(Sender: TObject);
var
 Data : TPNodeData;
begin
 if IsBusy then
 begin
  TAction(Sender).Enabled:=false;
  exit;
 end;

 if assigned(VST.focusedNode) then
 begin
  data:=vst.GetNodeData(VST.focusedNode);
  TAction(Sender).Enabled:=data.Index>=0;
  exit;
 end;

 TAction(Sender).Enabled:=false;
end;

procedure TLibrarianForm.ZipProgress(Sender: TObject;
  ProgrType: ProgressType; Filename: String; FileSize: Integer);
begin
 DoSetWorking(ProgrType<>EndOfBatch);
end;

procedure TLibrarianForm.ZipMessage(Sender: TObject; ErrCode: Integer;
  Message: String);
begin
 StatusBar.Panels[0].Text:=message;
end;

procedure TLibrarianForm.VSTClick(Sender: TObject);
begin
 if not IsBusy then
  DoChangeFocus(vst.FocusedNode,false,true);
end;

procedure TLibrarianForm.VSTKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if not IsBusy then
  DoChangeFocus(vst.FocusedNode,false,true);
end;

procedure TLibrarianForm.SetBusy(Busy : Boolean);
begin
 CloseEnabled(not Busy);
 vst.enabled:=not busy;
 memLib.Enabled:=not busy;
 IsBusy:=Busy;
 with vst.TreeOptions do
 if busy
  then MiscOptions:=MiscOptions - [toAcceptOleDrop]
  else MiscOptions:=MiscOptions + [toAcceptOleDrop];
 if not busy then
 begin
  if not assigned(vst.FocusedNode) then
  begin
   memLib.Lines.Clear;
   memLib.ReadOnly:=true;
   memlib.MemoSource.Modified:=false;
   LastFullPath:='';
  end;
 end;
end;

procedure TLibrarianForm.EnabledIfNotBusy(Sender: TObject);
begin
 TAction(Sender).Enabled:=(not IsBusy) and (not memLib.MemoSource.Modified);
end;

procedure TLibrarianForm.VSTFocusChanging(Sender: TBaseVirtualTree;
  OldNode, NewNode: PVirtualNode; OldColumn, NewColumn: TColumnIndex;
  var Allowed: Boolean);
begin
 Allowed:=not IsBusy;
end;

procedure TLibrarianForm.CancelActionUpdate(Sender: TObject);
begin
 CancelAction.Enabled:=(not isbusy) and (memLib.MemoSource.Modified);
end;

procedure TLibrarianForm.CancelActionExecute(Sender: TObject);
begin
 if MessageDlg('Are you sure you want to cancel all changes you made to this '+#13+#10+'snippet?', mtConfirmation, [mbOK,mbCancel], 0) = mrOk then
 begin
  memLib.MemoSource.Modified:=false;
  LastFullPath:='';
  DoChangeFocus(vst.FocusedNode,false,true);
 end;
end;

procedure TLibrarianForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=cafree;
 DoChangeFocus(vst.FocusedNode,true,true);
end;

procedure TLibrarianForm.VSTEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
 Allowed:=(not IsBusy) and (not memLib.MemoSource.Modified);
end;

procedure TLibrarianForm.VSTMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if button=mbRight then
  popupmenu.PopupFromCursorPos;
end;

procedure TLibrarianForm.FirstShow(Sender: TObject);
begin
 SystemImageList := TImageListEx.Create(Self);
 VST.NodeDataSize:=sizeOf(TNodeData);
 VST.Images:=SystemImageList;
 Zip.DLLDirectory:=ProgramPath;
 RootDir:=GetTmpDir+'OCL\';
 zip.RootDir:=RootDir;
 SetMemo(memLib,[]);
 Focused:=TStringList.Create;
 DoSetWorking(False);
 Zip.ZipFileName:=ZipFile;
 vst.Focusednode:=vst.TopNode;
 DoChangeFocus(vst.FocusedNode,false,true);
end;

procedure TLibrarianForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=siPopup.ItemLinks;
end;

procedure TLibrarianForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtTop;
 Pix:=0;
 Index:=InTools;
end;

//////////////////////////////////////////////////////////////////////////////////////
//OPL
//////////////////////////////////////////////////////////////////////////////////////

type
  TSnippet = Record
   Caption,Snippet : string;
   NodeType : Byte;
   Int : Integer; //not used
  end;
  PSnippet = ^TSnippet;

procedure TOldImpMod.VSTLoadNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var
  Data: PSnippet;
begin
  Data := Sender.GetNodeData(Node);
  if Assigned(Data) then begin
    stream.Read(data.NodeType,1);
    data.caption:=readstr(stream);
    data.Snippet:=readstr(stream);
  end;
end;

procedure TOldImpMod.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 Snippet : PSnippet;
begin
 Snippet:=vst.GetNodeData(node);
 with Snippet^ do
 begin
  setlength(Caption,0);
  Setlength(Snippet,0);
 end;
end;

Function TOldImpMod.VSTGetFolder(node : PVirtualNode) : String;
var
 Data: PSnippet;
begin
 result:='';
 repeat
  Data:=vst.GetNodeData(node);
  result:=GetSafeFilename(data.Caption)+'\'+result;
  node:=node.Parent;
 until node=vst.RootNode;
end;

procedure TOldImpMod.OpenOPL(const Filename: String);
var
 Node: PVirtualNode;
 Data: PSnippet;
 tmp,s,d,ext:string;
 c:integer;
begin
 vst:=TVirtualStringTree.Create(nil);
 vst.OnFreeNode:=VSTFreeNode;
 vst.OnLoadNode:=VSTLoadNode;
 vst.NodeDataSize:=sizeof(TSnippet);
 try
  vst.LoadFromFile(filename);

  tmp:=GetTmpDir+'OCL\Imported\';
  DelTree(tmp);
  ForceDirectories(tmp);
  ext:='.pl';

  node:=vst.GetFirst;
  while assigned(node) do
  begin
   data:=vst.GetNodeData(node);
   if (assigned(data)) and (trim(data.Snippet)<>'') then
   begin
    if data.Caption='HTML Librarian' then ext:='.htm';
    s:=tmp+VSTGetFolder(node);
    if node.ChildCount=0
     then s:=excludetrailingbackslash(s)
     else s:=s+GetSafeFilename(data.Caption);

    ForceDirectories(extractfilepath(s));
    c:=0;
    d:=s;
    if fileexists(s+ext) then
     repeat
      inc(c);
      s:=d+inttostr(c);
     until not fileexists(s+ext);
    saveStr(data.Snippet,s+ext);
   end;
   node:=vst.GetNext(node);
  end;

 finally
  vst.Free;
 end;
end;

Procedure DoInit;
var
 old : string;
begin
 old:='Code Librarian.zip';
 if (fileexists(programPath+old)) and
    (not fileexists(folders.UserFolder+old)) then
  Copyfile(pchar(programPath+old),pchar(folders.UserFolder+old),true);
end;

initialization
 DoInit;
end.