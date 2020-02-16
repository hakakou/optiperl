unit HKVST;

interface
uses SysUtils,Windows,Classes,VirtualTrees,hyperstr,ShellAPI,ActiveX;

Function GetHeaderWidths(VST : TVirtualStringTree) : String;
Procedure SetHeaderWidths(VST : TVirtualStringTree; Const Str: String);
Procedure GetDragDropFiles(Files : TStrings; DataObject: IDataObject; Formats: TFormatArray);

type
  TBoolFunction = Function(Sender : TObject) : Boolean of object;

  THKVTDragManager = class(TVTDragManager, IDropSource)
  private
    FOnQueryDrag : TBoolFunction;
    FOnDragAllowed : TBoolFunction;
    FOwner : TBaseVirtualTree;
  public
    function QueryContinueDrag(EscapePressed: BOOL; KeyState: Integer): HResult; stdcall;
    constructor Create(AOwner: TBaseVirtualTree; OnQueryDrag, OnDragAllowed : TBoolFunction);
  end;

implementation

Procedure GetDragDropFiles(Files : TStrings; DataObject: IDataObject; Formats: TFormatArray);
var
 I: Integer;
 Buffer: array[0..2048] of Char;
 fmtetc: tagFORMATETC;
 stgmed: tagSTGMEDIUM;
 dropH: HDROP;
 nFiles, nNames: Cardinal;
 szFileName: array[0..MAX_PATH + 1] of Char;
begin
 for I := 0 to High(Formats) do
  if Formats[I] <> CF_VIRTUALTREE  then
  begin
   if GetClipboardFormatName(Formats[I], @Buffer, 2048) < 1 then
    continue;
   if not Assigned(DataObject) then
    continue;

   fmtetc.cfFormat:=CF_HDROP;
   fmtetc.ptd:=nil;
   fmtetc.dwAspect:=DVASPECT_CONTENT;
   fmtetc.lindex:= -1;
   fmtetc.tymed:=TYMED_HGLOBAL;
   if DataObject.GetData(fmtetc, stgmed)<>S_OK then
    continue;

   // Lock the data
   dropH:=HDROP(Windows.GlobalLock(stgmed.hGlobal));
   if dropH=0 then continue;
   try
    // Get the number of filenames
    nFiles := DragQueryFile(dropH, $FFFFFFFF, nil, 0);
    // Get the filenames of each file
    Files.Clear;
    for nNames:=0 to nFiles - 1 do
    begin
     ZeroMemory(@szFileName, MAX_PATH + 1);
     DragQueryFile(dropH, nNames, szFilename,MAX_PATH + 1);
     Files.Add(szFilename);
    end;
   finally
    GlobalUnlock(stgmed.hGlobal);
    ReleaseStgMedium(stgmed);
   end;
   break;
  end;
end;


Function GetHeaderWidths(VST : TVirtualStringTree) : String;
var i:integer;
begin
 result:='';
 for i:=0 to vst.Header.Columns.Count-1 do
  result:=result+inttostr(vst.Header.Columns.Items[i].Width)+',';
end;

Procedure SetHeaderWidths(VST : TVirtualStringTree; Const Str: String);
var
 i,c,wid:integer;
 w:string;
begin
 i:=1;
 c:=0;
 repeat
  W := Parse(Str,',',i);
  wid:=StrToIntDef(w,-1);
  if (wid>=0) and (vst.Header.Columns.Count>c) then
   vst.Header.Columns.Items[c].Width:=wid;
  inc(c);
 until (I<1) or (I>Length(Str));
end;

{ THKVTDragManager }

constructor THKVTDragManager.Create(AOwner: TBaseVirtualTree; OnQueryDrag, OnDragAllowed : TBoolFunction);
begin
  FOwner:=AOwner;
  FOnQueryDrag:=OnQueryDrag;
  FOnDragAllowed:=OnDragAllowed;
  inherited Create(AOwner);
end;

function THKVTDragManager.QueryContinueDrag(EscapePressed: BOOL; KeyState: Integer): HResult;
var
  RButton,
  LButton: Boolean;
begin
  if assigned(FOnDragAllowed) and not FOnDragAllowed(FOwner) then
  begin
   result:=DRAGDROP_S_CANCEL;
   exit;
  end;

  LButton := (KeyState and MK_LBUTTON) <> 0;
  RButton := (KeyState and MK_RBUTTON) <> 0;
  if (LButton and RButton) or EscapePressed then
    Result := DRAGDROP_S_CANCEL
  else
    if not (LButton or RButton) then
     begin
      if assigned(FOnQueryDrag) and not FOnQueryDrag(FOwner)
       then Result := DRAGDROP_S_CANCEL
       else Result := DRAGDROP_S_DROP;
     end
   else
      Result := S_OK;
end;


end.
