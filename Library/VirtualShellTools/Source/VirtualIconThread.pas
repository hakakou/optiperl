unit VirtualIconThread;

// Version 1.5.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------

interface

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  ShlObj, ShellAPI, ActiveX,
  {$IFDEF VIRTUALNAMESPACES}
  VirtualNamespace,
  {$ENDIF}
  VirtualShellUtilities,
  VirtualResources;


const
  SAFETLYVALVEMAX = 20;  // Number of times PostMessage it tried if it fails (very unlikely)

type
  PVirtualThreadIconInfo = ^TVirtualThreadIconInfo;
  TVirtualThreadIconInfo = packed record
    PIDL: PItemIDList;    // PIDL to the object that requested the image index
    IconIndex: integer;   // Extracted Icon Index
    LargeIcon: Boolean;   // Extract the large Icon or Small Icon
    Control: TWinControl; // The window that needs the icon
    UserData: Pointer;    // In VET and VLVEx this is the node. The value in this field is used as the test in ClearPendingItem(TestItem: Pointer) so true is if UserData = TestItem
    UserData2: Pointer;   // User definable
    Tag: integer;         // In VLVEx this is the item index
    MessageID: LongWord;  // The WM_xxx Message to send the control
  end;


  TWMVTSetIconIndex = packed record
    Msg: Cardinal;
    IconInfo: PVirtualThreadIconInfo;
  end;

  TWMVTSetThreadMark = TWMVTSetIconIndex;

type
  { Thread to extract images without slowing down VET }
  TVirtualImageThread = class(TThread)
  private
    FQueryList: TThreadList;
    FImageThreadEvent: THandle;

  protected
    procedure AddNewItem(Control: TWinControl; WindowsMessageID: LongWord; PIDL: PItemIDList; LargeIcon: Boolean;
      UserData: Pointer; Tag: integer); virtual;
    procedure ClearPendingItem(Control: TWinControl; TestItem: Pointer;
      MessageID: LongWord; const Malloc: IMalloc);
    procedure ClearPendingItems(Control: TWinControl; MessageID: LongWord; const Malloc: IMalloc);
    function CopyPIDL(APIDL: PItemIDList; const Malloc: IMalloc): PItemIDList;
    procedure Execute; override;
    function ExtractIconImage(APIDL: PItemIDLIst): Integer;
    procedure ExtractInfo(PIDL: PItemIDList; Info: PVirtualThreadIconInfo); virtual;
    procedure ExtractedInfoLoad(Info: PVirtualThreadIconInfo); virtual; // Load Info before being sent to Control(s)
    procedure InsertNewItem(Control: TWinControl; WindowsMessageID: LongWord; PIDL: PItemIDList;
        LargeIcon: Boolean; UserData: Pointer; Tag: integer);
    procedure InvalidateExtraction; virtual; // Called if after extraction the item can't be dispatched
    function NextID(APIDL: PItemIDList): PItemIDList;
    function PIDLSize(APIDL: PItemIDList): Integer;
    procedure ReleaseItem(Item: PVirtualThreadIconInfo; const Malloc: IMalloc); virtual;
    procedure SetEvent;
    function StripLastID(IDList: PItemIDList; var Last_CB: Word; var LastID: PItemIDList): PItemIDList;

    property ImageThreadEvent: THandle read FImageThreadEvent write FImageThreadEvent;
    property QueryList: TThreadList read FQueryList;

  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
  end;

  IVirtualImageThreadManager = interface(IUnknown)
  ['{F6CDCFE6-4294-4169-A6ED-D1E24F3152AC}']
    procedure AddNewItem(Control: TWinControl; MessageID: LongWord;
      PIDL: PItemIDList; LargeIcon: Boolean; UserData: Pointer; Tag: integer);
    procedure ClearPendingItems(Control: TWinControl; MessageID: LongWord; const Malloc: IMalloc);
    procedure ClearPendingItem(Control: TWinControl; TestItem: Pointer; MessageID: LongWord; const Malloc: IMalloc);
    procedure CreateThreadObject;
    procedure InsertNewItem(Control: TWinControl; WindowsMessageID: LongWord; PIDL: PItemIDList;
        LargeIcon: Boolean; UserData: Pointer; Tag: integer);
    function LockThread: TList;
    procedure RegisterControl(Control: TWinControl);
    procedure ReleaseItem(Item: PVirtualThreadIconInfo; const Malloc: IMalloc);
    procedure SetThreadPriority(Priority: TThreadPriority);
    procedure UnLockThread;
    procedure UnRegisterControl(Control: TWinControl);
  end;

  TVirtualExpandMarkThread = class(TVirtualImageThread)
  protected
    procedure AddNewItem(Control: TWinControl; WindowsMessageID: LongWord; PIDL: PItemIDList; LargeIcon: Boolean; UserData: Pointer; Tag: integer); override;
    procedure ExtractedInfoLoad(Info: PVirtualThreadIconInfo); override;
    procedure ExtractInfo(PIDL: PItemIDList; Info: PVirtualThreadIconInfo); override;
    procedure InvalidateExtraction; override;
    procedure ReleaseItem(Item: PVirtualThreadIconInfo; const Malloc: IMalloc); override;
  end;

  TVirtualImageThreadManager = class(TInterfacedObject, IVirtualImageThreadManager)
  private
    FControlList: TThreadList;
    FImageThread: TVirtualImageThread;
    FThreadPriority: TThreadPriority;
  protected
    function GetThreadObject: TVirtualImageThread; virtual;
    procedure ReleaseImageThread;
    function RegisteredControl(Control: TWinControl): Boolean;

    property ControlList: TThreadList read FControlList write FControlList;
    property ImageThread: TVirtualImageThread read FImageThread write FImageThread;
    property ThreadPriority: TThreadPriority read FThreadPriority write FThreadPriority;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    procedure AddNewItem(Control: TWinControl;  WindowsMessageID: LongWord; PIDL: PItemIDList;
      LargeIcon: Boolean; UserData: Pointer; Tag: integer);
    procedure ClearPendingItems(Control: TWinControl; MessageID: LongWord; const Malloc: IMalloc);
    procedure ClearPendingItem(Control: TWinControl; TestItem: Pointer; MessageID: LongWord; const Malloc: IMalloc);
    procedure CreateThreadObject;
    procedure InsertNewItem(Control: TWinControl; WindowsMessageID: LongWord; PIDL: PItemIDList;
        LargeIcon: Boolean; UserData: Pointer; Tag: integer);
    function LockThread: TList;
    procedure RegisterControl(Control: TWinControl);
    procedure ReleaseItem(Item: PVirtualThreadIconInfo; const Malloc: IMalloc);
    procedure SetThreadPriority(Priority: TThreadPriority);
    procedure UnLockThread;
    procedure UnRegisterControl(Control: TWinControl);
  end;

  TVirtualExpandMarkManager = class(TVirtualImageThreadManager, IVirtualImageThreadManager)
  protected
    function GetThreadObject: TVirtualImageThread; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

function ImageThreadManager: IVirtualImageThreadManager;
function ExpandMarkThreadManager: IVirtualImageThreadManager;

implementation

var
  ImageManager: IVirtualImageThreadManager = nil;
  ExpandMarkManager: IVirtualImageThreadManager = nil;

function ImageThreadManager: IVirtualImageThreadManager;
begin
  if not Assigned(ImageManager) then
    ImageManager := TVirtualImageThreadManager.Create as IVirtualImageThreadManager;
  Result := ImageManager
end;

function ExpandMarkThreadManager: IVirtualImageThreadManager;
begin
  if not Assigned(ExpandMarkManager) then
    ExpandMarkManager := TVirtualExpandMarkManager.Create as IVirtualImageThreadManager;
  Result := ExpandMarkManager
end;

{ TVirtualImageThread }

procedure TVirtualImageThread.AddNewItem(Control: TWinControl; WindowsMessageID: LongWord;
  PIDL: PItemIDList; LargeIcon: Boolean; UserData: Pointer; Tag: integer);
var
  List: TList;
  Info: PVirtualThreadIconInfo;
begin
  List := QueryList.LockList;
  try
    Info := AllocMem(SizeOf(TVirtualThreadIconInfo));
    Info.Control := Control;
    Info.PIDL := PIDLMgr.CopyPIDL(PIDL);
    Info.LargeIcon := LargeIcon;
    Info.UserData := UserData;
    Info.Tag := Tag;
    Info.MessageID := WindowsMessageID;
    List.Add(Info);
    SetEvent
  finally
    QueryList.UnlockList;
  end
end;

procedure TVirtualImageThread.ClearPendingItem(Control: TWinControl; TestItem: Pointer;
  MessageID: Longword; const Malloc: IMalloc);
// This method makes one big assumption.  It assumes that the TestItem is equal to the
// PVirtualThreadIconInfo.UserData field.
var
  List: TList;
  i : integer;
  Msg: TMsg;
begin
  // Lock the thread from dispatching any more messages
  List := QueryList.LockList;
  try
    // Since we have the list locked we can pick any messages that are in
    // message queue that are pending.  They may reference the Item we are
    // now deleting! By handling this message while the list is locked we
    // can be sure all pending icon updates are done before we delete a Item.
    if Control.HandleAllocated then
    begin
      // First flush out any pending messages and let them be processed
      while PeekMessage(Msg, Control.Handle, MessageID, MessageID, PM_REMOVE) do
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg)
      end;
    end;


    for i := 0 to List.Count - 1 do
    begin
      if (PVirtualThreadIconInfo(List[i])^.Control = Control) then
      begin
        if (TestItem = PVirtualThreadIconInfo(List[i])^.UserData)  then
        begin
          ReleaseItem(PVirtualThreadIconInfo(List[i]), Malloc);
          List[i] := nil
        end
      end
    end;
    List.Pack;
  finally
    QueryList.UnlockList;
  end
end;

procedure TVirtualImageThread.ClearPendingItems(Control: TWinControl; MessageID: LongWord; const Malloc: IMalloc);
var
  List: TList;
  i : integer;
  Msg: TMsg;
begin
  // Lock the thread from dispatching any more messages
  List := QueryList.LockList;
  try
    // Since we have the list locked we can pick any messages that are in
    // message queue that are pending.  They may reference the Item we are
    // now deleting! By handling this message while the list is locked we
    // can be sure all pending icon updates are done before we delete a Item.
    if Control.HandleAllocated then
    begin
      // First flush out any pending messages and let them be processed
      while PeekMessage(Msg, Control.Handle, MessageID, MessageID, PM_REMOVE) do
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg)
      end;
    end;


    for i := 0 to List.Count - 1 do
    begin
      if (PVirtualThreadIconInfo(List[i])^.Control = Control) then
      begin
       ReleaseItem(PVirtualThreadIconInfo(List[i]), Malloc);
       List[i] := nil
      end
    end;
    List.Pack;
  finally
    QueryList.UnlockList;
  end
end;

function TVirtualImageThread.CopyPIDL(APIDL: PItemIDList; const Malloc: IMalloc): PItemIDList;
// Copies the PIDL and returns a newly allocated PIDL. It is not associated
// with any instance of TPIDLManager so it may be assigned to any instance.
var
  Size: integer;
begin
  if Assigned(APIDL) then
  begin
    Size := PIDLSize(APIDL);
    Result := Malloc.Alloc(Size);
    if Result <> nil then
      CopyMemory(Result, APIDL, Size);
  end else
    Result := nil
end;

constructor TVirtualImageThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  { NEED A UNIQUE EVENT FOR EACH THREAD IDIOT!!!}
  ImageThreadEvent := CreateEvent(nil, True, False, '');
  FQueryList := TThreadList.Create;
end;

destructor TVirtualImageThread.Destroy;
begin
  inherited;
  { Important to keep resources valid until after the inherited Destroy returns. }
  { The Execute method is terminated during a WaitFor called in this destructor. }
  { During that time Execute may still reference these resources.                }
  FQueryList.Free;
  if ImageThreadEvent <> 0 then
    CloseHandle(ImageThreadEvent);  
end;

procedure TVirtualImageThread.Execute;
var
  Index: Integer;
  List: TList;
  SafetyValve: integer;
  Info: PVirtualThreadIconInfo;
  InfoCopy: TVirtualThreadIconInfo;
  Malloc: IMalloc;
begin
  CoInitialize(nil);
  try
    SHGetMalloc(Malloc); // Create in the context of the thread
    while not Terminated do
    begin
      WaitForSingleObject(ImageThreadEvent, INFINITE);
      if not Terminated then
      begin
        // Ok everyone .... breath
        Sleep(1);

        // Get the next waiting node
        List := QueryList.LockList;
        try
          Info := nil;
          // Grab the last item but don't remove it from the list yet.
          // If we remove it then if a control flushs pending queries before
          // we dispatch it we will send it to a control that is not ready.
          // If there are not items in the list then we are done so reset
          // local varaibles and reset the event so WaitForSingleObject waits again
          if List.Count > 0 then
          begin
            Index := List.Count - 1;
            Info := PVirtualThreadIconInfo(List.Items[Index]);
            InfoCopy.PIDL := CopyPIDL(Info.PIDL, Malloc);
            InfoCopy.IconIndex := Info^.IconIndex;
            InfoCopy.LargeIcon := Info^.LargeIcon;
            InfoCopy.Control := Info^.Control;
            InfoCopy.UserData := Info^.UserData;
            InfoCopy.UserData2 := Info^.UserData2;
            InfoCopy.Tag := Info^.Tag;
            InfoCopy.MessageID := Info^.MessageID;
          end
          else begin
            Index := -1;
            FillChar(InfoCopy, SizeOf(InfoCopy), #0);
            ResetEvent(ImageThreadEvent); // Reset ourselves when there are no more images
          end;
        finally
          QueryList.UnlockList
        end;

        if Assigned(InfoCopy.PIDL) then
        try
          // Call the long processing method.
          ExtractInfo(InfoCopy.PIDL, @InfoCopy);

          // Ok the slow extraction is done time to dispatch it
          List := QueryList.LockList;
          try
            // Free the temp PIDL
            if InfoCopy.PIDL <> nil then
              Malloc.Free(InfoCopy.PIDL);

            // Check to see if there are any items in the list or if items have
            // been deleted first. If they are the item will be left if the queue
            // and it will have to be done again
            if (List.Count > 0) and (Index < List.Count) then
            begin
              // See if the node was deleted and removed from the list or the
              // contexts were shifted
              if List[Index] = Info then
              begin
                ExtractedInfoLoad(@InfoCopy);
                Info^.IconIndex := InfoCopy.IconIndex;
                Info^.LargeIcon := InfoCopy.LargeIcon;
                Info^.UserData := InfoCopy.UserData;
                Info^.UserData2 := InfoCopy.UserData2;
                Info^.Tag := InfoCopy.Tag;
                // No it is still there so we can remove it
                List.Delete(Index);
                // Note: It is possible by the time the VET gets this TMessage
                // the node can be destroyed so main thread locks the list
                // the PeekMessage's to remove all WM_VTSETICONINDEX before
                // freeing node.
                // Can't SendMessage because the main thread may be blocked
                // waiting for the list and SendMessage will deadlock.

                // Here again accessing a TWinControl is not thread safe but
                // we are only reading the properties
                if Info.Control.HandleAllocated then
                begin
                  SafetyValve := 0;
                  while not PostMessage(Info.Control.Handle, Info.MessageID, Integer(Info), 0) and (SafetyValve < SAFETLYVALVEMAX) do
                  begin
                    Inc(SafetyValve);
                    Sleep(1);
                  end;
                  if SafetyValve >= SAFETLYVALVEMAX then
                    ReleaseItem(Info, Malloc)
                end else
                  ReleaseItem(Info, Malloc)
              end else
                InvalidateExtraction
            end else
              InvalidateExtraction
          finally
            QueryList.UnlockList;
          end
        except
          // Don't let exceptions escape the thread
        end
      end
    end
  finally
    // Make sure WaitFor is in the Wait Function before the thread really ends
    Sleep(100);
    Malloc := nil;
    CoUninitialize;
  end;
end;

procedure TVirtualImageThread.ExtractedInfoLoad(Info: PVirtualThreadIconInfo);
// This is called from within a locked list so it is safe to maniulate
begin

end;

function TVirtualImageThread.ExtractIconImage(APIDL: PItemIDLIst): integer;

  function GetIconByIShellIcon(PIDL: PItemIDList; var Index: integer): Boolean;
  var
    Flags: Longword;
    OldCB: Word;
    Old_ID: PItemIDList;
    {$IFNDEF VIRTUALNAMESPACES}
    Desktop,
    {$ENDIF}
    Folder: IShellFolder;
    ShellIcon: IShellIcon;
  begin
    Result := False;
    StripLastID(PIDL, OldCB, Old_ID);
    try
      {$IFDEF VIRTUALNAMESPACES}
      Old_ID.mkid.cb := OldCB;
      Folder := NamespaceExtensionFactory.BindToVirtualParentObject(PIDL);
      {$ELSE}
      SHGetDesktopFolder(Desktop);
      Desktop.BindToObject(PIDL, nil, IShellFolder, Pointer(Folder));
      Old_ID.mkid.cb := OldCB;
      {$ENDIF}
      if Assigned(Folder) then
        if Folder.QueryInterface(IShellIcon, ShellIcon) = S_OK then
        begin
          Flags := 0;
          Result := ShellIcon.GetIconOf(Old_ID, Flags, Index) = NOERROR
      end
    finally
      {$IFNDEF VIRTUALNAMESPACES}
      Old_ID.mkid.cb := OldCB
      {$ENDIF}
    end
  end;

  procedure GetIconBySHGetFileInfo(APIDL: PItemIDList; var Index: Integer);
  var
    Flags: integer;
    Info: TSHFILEINFO;
  begin
    Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX or SHGFI_SHELLICONSIZE;
    Flags := Flags or SHGFI_SMALLICON;
    if SHGetFileInfo(PChar(APIDL), 0, Info, SizeOf(Info), Flags) <> 0 then
      Index := Info.iIcon
    else
      Index := 0
  end;

begin
  if not GetIconByIShellIcon(APIDL, Result) then
    GetIconBySHGetFileInfo(APIDL, Result);
end;

procedure TVirtualImageThread.ExtractInfo(PIDL: PItemIDList; Info: PVirtualThreadIconInfo);
// Use the passed PIDL to figure out what what to extract
begin
  Info.IconIndex := ExtractIconImage(PIDL);
end;

procedure TVirtualImageThread.InsertNewItem(Control: TWinControl;
  WindowsMessageID: LongWord; PIDL: PItemIDList; LargeIcon: Boolean;
  UserData: Pointer; Tag: integer);
var
  List: TList;
  Info: PVirtualThreadIconInfo;
begin
  List := QueryList.LockList;
  try
    Info := AllocMem(SizeOf(TVirtualThreadIconInfo));
    Info.Control := Control;
    Info.PIDL := PIDLMgr.CopyPIDL(PIDL);
    Info.LargeIcon := LargeIcon;
    Info.UserData := UserData;
    Info.Tag := Tag;
    Info.MessageID := WindowsMessageID;
    List.Insert(0, Info);
    SetEvent
  finally
    QueryList.UnlockList;
  end
end;

procedure TVirtualImageThread.InvalidateExtraction;
begin

end;

function TVirtualImageThread.NextID(APIDL: PItemIDList): PItemIDList;
begin
  Result := APIDL;
  if Assigned(APIDL) then
    Inc(PChar(Result), APIDL^.mkid.cb);
end;

function TVirtualImageThread.PIDLSize(APIDL: PItemIDList): integer;
// Returns the total Memory in bytes the PIDL occupies.
begin
  Result := 0;
  if Assigned(APIDL) then
  begin
    Result := SizeOf( Word);  // add the null terminating last ItemID
    while APIDL.mkid.cb <> 0 do
    begin
      Result := Result + APIDL.mkid.cb;
      APIDL := NextID(APIDL);
    end;
  end;
end;

procedure TVirtualImageThread.ReleaseItem(Item: PVirtualThreadIconInfo; const Malloc: IMalloc);
begin
  if Assigned(Item) then
  begin
    if Assigned(Item.PIDL) then
      Malloc.Free(Item.PIDL);
    FreeMem(Item)
  end
end;

procedure TVirtualImageThread.SetEvent;
begin
  Windows.SetEvent(ImageThreadEvent);
end;

function TVirtualImageThread.StripLastID(IDList: PItemIDList;
  var Last_CB: Word; var LastID: PItemIDList): PItemIDList;
var
  MarkerID: PItemIDList;
begin
  Last_CB := 0;
  LastID := nil;
  Result := IDList;
  MarkerID := IDList;
  if Assigned(IDList) then
  begin
    while IDList.mkid.cb <> 0 do
    begin
      MarkerID := IDList;
      IDList := NextID(IDList);
    end;
    Last_CB := MarkerID.mkid.cb;
    LastID := MarkerID;
    MarkerID.mkid.cb := 0;
  end;
end;

{ TVirtualImageThreadManager }



procedure TVirtualImageThreadManager.AddNewItem(Control: TWinControl; WindowsMessageID: LongWord;
  PIDL: PItemIDList; LargeIcon: Boolean; UserData: Pointer; Tag: integer);
begin
  if Assigned(ImageThread) then
  begin
    ImageThread.Suspended := False;
    Assert(RegisteredControl(Control), 'Trying to add Image Thread Item to a unregistered control');
    ImageThread.AddNewItem(Control, WindowsMessageID, PIDL, LargeIcon, UserData, Tag)
  end
end;

procedure TVirtualImageThreadManager.ClearPendingItem(Control: TWinControl;
  TestItem: Pointer; MessageID: LongWord; const Malloc: IMalloc);
// Looks for the matching TestItem in the Item field of the record as a flag to delete
// the record
begin
  if Assigned(ImageThread) then
  begin
    if RegisteredControl(Control) then
    begin
      ImageThread.ClearPendingItem(Control, TestItem, MessageID, Malloc)
    end else
      Assert(True=False, 'Trying to clear pending Image Thead Items from an unregistered control');
  end
end;

procedure TVirtualImageThreadManager.ClearPendingItems(Control: TWinControl; MessageID: LongWord; const Malloc: IMalloc);
begin
  if Assigned(ImageThread) then
  begin
    if RegisteredControl(Control) then
    begin
      ImageThread.ClearPendingItems(Control, MessageID, Malloc)
    end else
      Assert(True=False, 'Trying to clear pending Image Thead Items from an unregistered control');
  end
end;

constructor TVirtualImageThreadManager.Create;
begin
  ControlList := TThreadList.Create;
  ThreadPriority := tpNormal;
end;

destructor TVirtualImageThreadManager.Destroy;
begin
  ReleaseImageThread;
  ControlList.Free;
  inherited;
end;

function TVirtualImageThreadManager.GetThreadObject: TVirtualImageThread;
begin
  // Don't Execute until we add items
  Result := TVirtualImageThread.Create(True);
end;

function TVirtualImageThreadManager.LockThread: TList;
begin
  if Assigned(ImageThread) then
    Result := ImageThread.QueryList.LockList
  else
    Result := nil
end;

procedure TVirtualImageThreadManager.CreateThreadObject;
begin
  if not Assigned(ImageThread) then
  begin
    ImageThread := GetThreadObject;
    ImageThread.Priority := ThreadPriority;
  end
end;

procedure TVirtualImageThreadManager.InsertNewItem(Control: TWinControl;
  WindowsMessageID: LongWord; PIDL: PItemIDList; LargeIcon: Boolean;
  UserData: Pointer; Tag: integer);
begin
  if Assigned(ImageThread) then
  begin
    Assert(RegisteredControl(Control), 'Trying to add Image Thread Item to a unregistered control');
    ImageThread.InsertNewItem(Control, WindowsMessageID, PIDL, LargeIcon, UserData, Tag)
  end
end;

procedure TVirtualImageThreadManager.RegisterControl(Control: TWinControl);
var
  List: TList;
begin
  List := ControlList.LockList;
  try
    List.Add(Control);
    CreateThreadObject;
  finally
    ControlList.UnlockList
  end
end;

function TVirtualImageThreadManager.RegisteredControl( Control: TWinControl): Boolean;
var
  List: TList;
begin
  if Assigned(Control) then
  begin
    List := ControlList.LockList;
    try
      Result := List.IndexOf(Control) > -1
    finally
      ControlList.UnlockList
    end
  end else
    Result := False;
end;

procedure TVirtualImageThreadManager.ReleaseItem(Item: PVirtualThreadIconInfo; const Malloc: IMalloc);
begin
  ImageThread.ReleaseItem(Item, Malloc)
end;

procedure TVirtualImageThreadManager.ReleaseImageThread;
begin
  if Assigned(ImageThread) then
  begin
    ImageThread.Suspended := False;
    ImageThread.Priority := tpNormal; // So D6 shuts down faster.
    ImageThread.Terminate;
    ImageThread.SetEvent;
    ImageThread.WaitFor;
    FreeAndNil(FImageThread)
  end
end;

procedure TVirtualImageThreadManager.SetThreadPriority(
  Priority: TThreadPriority);
begin
  ThreadPriority := Priority;
  if Assigned(ImageThread) then
   ImageThread.Priority := ThreadPriority
end;

procedure TVirtualImageThreadManager.UnLockThread;
begin
  if Assigned(ImageThread) then
    ImageThread.QueryList.UnLockList
end;

procedure TVirtualImageThreadManager.UnRegisterControl(Control: TWinControl);
var
  List: TList;
  Index: integer;
begin
  List := ControlList.LockList;
  try
    Index := List.IndexOf(Control);
    if Index > -1 then
    begin
      List.Delete(Index);
      if List.Count = 0 then
        ReleaseImageThread;
      end
  finally
    ControlList.UnlockList
  end
end;

{ TVirtualExpandMarkThread }

procedure TVirtualExpandMarkThread.AddNewItem(Control: TWinControl; WindowsMessageID: LongWord; PIDL: PItemIDList; LargeIcon: Boolean; UserData: Pointer; Tag: integer);
var
  List: TList;
  Info: PVirtualThreadIconInfo;
begin
  List := QueryList.LockList;
  try
    Info := AllocMem(SizeOf(TVirtualThreadIconInfo));
    Info.Control := Control;
    Info.PIDL := PIDLMgr.CopyPIDL(PIDL);
    Info.LargeIcon := LargeIcon;
    Info.UserData := UserData;
    Info.Tag := Tag;
    Info.MessageID := WindowsMessageID;
    List.Insert(0, Info);
    SetEvent
  finally
    QueryList.UnlockList; 
  end
end;


procedure TVirtualExpandMarkThread.ExtractedInfoLoad(Info: PVirtualThreadIconInfo);
begin
  inherited ExtractedInfoLoad(Info);
end;

procedure TVirtualExpandMarkThread.ExtractInfo(PIDL: PItemIDList;
  Info: PVirtualThreadIconInfo);
var
  NS: TNamespace;
begin
  NS := TNamespace.Create(PIDL, nil);
  try
    NS.FreePIDLOnDestroy := False;
      // Tag contains the SHCONTF_XXXX flags
      Integer(Info^.UserData2) :=  Integer(NS.SubFoldersEx(Info^.Tag));
  finally
    NS.Free
  end
end;

procedure TVirtualExpandMarkThread.InvalidateExtraction;
begin
  inherited InvalidateExtraction;
end;

procedure TVirtualExpandMarkThread.ReleaseItem(Item: PVirtualThreadIconInfo;
  const Malloc: IMalloc);
begin
  inherited ReleaseItem(Item, Malloc);
end;

{ TVirtualExpandMarkManager }

constructor TVirtualExpandMarkManager.Create;
begin
  inherited Create;
  ThreadPriority := tpNormal;
end;

destructor TVirtualExpandMarkManager.Destroy;
begin
  inherited Destroy;
end;  

function TVirtualExpandMarkManager.GetThreadObject: TVirtualImageThread;
begin
  // Don't Execute until we add items
  Result:= TVirtualExpandMarkThread.Create(True)
end;

initialization

finalization
  ImageManager := nil;

end.
