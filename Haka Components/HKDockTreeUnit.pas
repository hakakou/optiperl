unit HKDockTreeUnit;

interface

uses Messages, Windows, MultiMon, Classes, Sysutils, Graphics, Menus, CommCtrl, Imm,
  ImgList, ActnList,Controls;

  type
    THKDockTree = class(TInterfacedObject, IDockManager)
  private
    FBorderWidth: Integer;
    FBrush: TBrush;
    FDockSite: TWinControl;
    FGrabberSize: Integer;
    FGrabbersOnTop: Boolean;
    FOldRect: TRect;
    FOldWndProc: TWndMethod;
    FReplacementZone: TDockZone;
    FScaleBy: Double;
    FShiftScaleOrient: TDockOrientation;
    FShiftBy: Integer;
    FSizePos: TPoint;
    FSizingDC: HDC;
    FSizingWnd: HWND;
    FSizingZone: TDockZone;
    FTopZone: TDockZone;
    FTopXYLimit: Integer;
    FUpdateCount: Integer;
    FVersion: Integer;
    procedure ControlVisibilityChanged(Control: TControl; Visible: Boolean);
    procedure DrawSizeSplitter;
    function FindControlZone(Control: TControl): TDockZone;
    procedure ForEachAt(Zone: TDockZone; Proc: TForEachZoneProc);
    function GetNextLimit(AZone: TDockZone): Integer;
    procedure InsertNewParent(NewZone, SiblingZone: TDockZone;
      ParentOrientation: TDockOrientation; InsertLast: Boolean);
    procedure InsertSibling(NewZone, SiblingZone: TDockZone; InsertLast: Boolean);
    function InternalHitTest(const MousePos: TPoint; out HTFlag: Integer): TDockZone;
    procedure PruneZone(Zone: TDockZone);
    procedure RemoveZone(Zone: TDockZone);
    procedure ScaleZone(Zone: TDockZone);
    procedure SetNewBounds(Zone: TDockZone);
    procedure ShiftZone(Zone: TDockZone);
    procedure SplitterMouseDown(OnZone: TDockZone; MousePos: TPoint);
    procedure SplitterMouseUp;
    procedure UpdateZone(Zone: TDockZone);
    procedure WindowProc(var Message: TMessage);
  protected
    procedure AdjustDockRect(Control: TControl; var ARect: TRect); virtual;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure GetControlBounds(Control: TControl; out CtlBounds: TRect);
    function HitTest(const MousePos: TPoint; out HTFlag: Integer): TControl; virtual;
    procedure InsertControl(Control: TControl; InsertAt: TAlign;
      DropCtl: TControl); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure PaintDockFrame(Canvas: TCanvas; Control: TControl;
      const ARect: TRect); virtual;
    procedure PositionDockRect(Client, DropCtl: TControl; DropAlign: TAlign;
      var DockRect: TRect); virtual;
    procedure RemoveControl(Control: TControl); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SetReplacingControl(Control: TControl);
    procedure ResetBounds(Force: Boolean); virtual;
    procedure UpdateAll;
    property DockSite: TWinControl read FDockSite write FDockSite;
  public
    constructor Create(DockSite: TWinControl); virtual;
    destructor Destroy; override;
    procedure PaintSite(DC: HDC); virtual;
  end;

implementation
uses Consts, Forms, ActiveX;
const
  GrabberSize = 12;

constructor THKDockTree.Create(DockSite: TWinControl);
var
  I: Integer;
begin
  inherited Create;
  FBorderWidth := 4;
  FDockSite := DockSite;
  FVersion := $00040000;
  FGrabberSize := GrabberSize;
  FGrabbersOnTop := (DockSite.Align <> alTop) and (DockSite.Align <> alBottom);
  FTopZone := TDockZone.Create(TDockTree(Self));
  FBrush := TBrush.Create;
  FBrush.Bitmap := AllocPatternBitmap(clBlack, clWhite);
  // insert existing controls into tree
  BeginUpdate;
  try
    for I := 0 to DockSite.ControlCount - 1 do
      InsertControl(DockSite.Controls[I], alLeft, nil);
    FTopZone.ResetChildren;
  finally
    EndUpdate;
  end;
  if not (csDesigning in DockSite.ComponentState) then
  begin
    FOldWndProc := FDockSite.WindowProc;
    FDockSite.WindowProc := WindowProc;
  end;
end;

destructor THKDockTree.Destroy;
begin
  if @FOldWndProc <> nil then
    FDockSite.WindowProc := FOldWndProc;
  PruneZone(FTopZone);
  FBrush.Free;
  inherited Destroy;
end;

procedure THKDockTree.AdjustDockRect(Control: TControl; var ARect: TRect);
begin
  { Allocate room for the caption on the left if docksite is horizontally
    oriented, otherwise allocate room for the caption on the top. }
  if FDockSite.Align in [alTop, alBottom] then
    Inc(ARect.Left, GrabberSize) else
    Inc(ARect.Top, GrabberSize);
end;

procedure THKDockTree.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure THKDockTree.EndUpdate;
begin
  Dec(FUpdateCount);
  if FUpdateCount <= 0 then
  begin
    FUpdateCount := 0;
    UpdateAll;
  end;
end;

function THKDockTree.FindControlZone(Control: TControl): TDockZone;
var
  CtlZone: TDockZone;

  procedure DoFindControlZone(StartZone: TDockZone);
  begin
    if StartZone.FChildControl = Control then
      CtlZone := StartZone
    else begin
      // Recurse sibling
      if (CtlZone = nil) and (StartZone.FNextSibling <> nil) then
        DoFindControlZone(StartZone.FNextSibling);
      // Recurse child
      if (CtlZone = nil) and (StartZone.FChildZones <> nil) then
        DoFindControlZone(StartZone.FChildZones);
    end;
  end;

begin
  CtlZone := nil;
  if (Control <> nil) and (FTopZone <> nil) then DoFindControlZone(FTopZone);
  Result := CtlZone;
end;

procedure THKDockTree.ForEachAt(Zone: TDockZone; Proc: TForEachZoneProc);

  procedure DoForEach(Zone: TDockZone);
  begin
    Proc(Zone);
    // Recurse sibling
    if Zone.FNextSibling <> nil then DoForEach(Zone.FNextSibling);
    // Recurse child
    if Zone.FChildZones <> nil then DoForEach(Zone.FChildZones);
  end;

begin
  if Zone = nil then Zone := FTopZone;
  DoForEach(Zone);
end;

procedure THKDockTree.GetControlBounds(Control: TControl; out CtlBounds: TRect);
var
  Z: TDockZone;
begin
  Z := FindControlZone(Control);
  if Z = nil then
    FillChar(CtlBounds, SizeOf(CtlBounds), 0)
  else
    with Z do
      CtlBounds := Bounds(Left, Top, Width, Height);
end;

function THKDockTree.HitTest(const MousePos: TPoint; out HTFlag: Integer): TControl;
var
  Zone: TDockZone;
begin
  Zone := InternalHitTest(MousePos, HTFlag);
  if Zone <> nil then Result := Zone.FChildControl
  else Result := nil;
end;

procedure THKDockTree.InsertControl(Control: TControl; InsertAt: TAlign;
  DropCtl: TControl);
const
  OrientArray: array[TAlign] of TDockOrientation = (doNoOrient, doHorizontal,
    doHorizontal, doVertical, doVertical, doNoOrient);
  MakeLast: array[TAlign] of Boolean = (False, False, True, False, True, False);
var
  Sibling, Me: TDockZone;
  InsertOrientation, CurrentOrientation: TDockOrientation;
  NewWidth, NewHeight: Integer;
  R: TRect;
begin
  if not Control.Visible then Exit;
  if FReplacementZone <> nil then
  begin
    FReplacementZone.FChildControl := Control;
    FReplacementZone.Update;
  end
  else if FTopZone.FChildZones = nil then
  begin
    // Tree is empty, so add first child
    R := FDockSite.ClientRect;
    FDockSite.AdjustClientRect(R);
    NewWidth := R.Right - R.Left;
    NewHeight := R.Bottom - R.Top;
    if FDockSite.AutoSize then
    begin
      if NewWidth = 0 then NewWidth := Control.UndockWidth;
      if NewHeight = 0 then NewHeight := Control.UndockHeight;
    end;
    R := Bounds(R.Left, R.Top, NewWidth, NewHeight);
    AdjustDockRect(Control, R);
    Control.BoundsRect := R;
    Me := TDockZone.Create(Self);
    FTopZone.FChildZones := Me;
    Me.FParentZone := FTopZone;
    Me.FChildControl := Control;
  end
  else begin
    // Default to right-side docking
    if InsertAt in [alClient, alNone] then InsertAt := alRight;
    Me := FindControlZone(Control);
    if Me <> nil then RemoveZone(Me);
    Sibling := FindControlZone(DropCtl);
    InsertOrientation := OrientArray[InsertAt];
    if FTopZone.ChildCount = 1 then
    begin
      // Tree only has one child, and a second is being added, so orientation and
      // limits must be set up
      FTopZone.FOrientation := InsertOrientation;
      case InsertOrientation of
        doHorizontal:
          begin
            FTopZone.FZoneLimit := FTopZone.FChildZones.Width;
            FTopXYLimit := FTopZone.FChildZones.Height;
          end;
        doVertical:
          begin
            FTopZone.FZoneLimit := FTopZone.FChildZones.Height;
            FTopXYLimit := FTopZone.FChildZones.Width;
          end;
      end;
    end;
    Me := TDockZone.Create(Self);
    Me.FChildControl := Control;
    if Sibling <> nil then CurrentOrientation := Sibling.FParentZone.FOrientation
    else CurrentOrientation := FTopZone.FOrientation;
    if InsertOrientation = doNoOrient then
      InsertOrientation := CurrentOrientation;
    // Control is being dropped into a zone with the same orientation we
    // are requesting, so we just need to add ourselves to the sibling last
    if InsertOrientation = CurrentOrientation then InsertSibling(Me, Sibling,
      MakeLast[InsertAt])
    // Control is being dropped into a zone with a different orientation than
    // we are requesting
    else InsertNewParent(Me, Sibling, InsertOrientation, MakeLast[InsertAt]);
  end;
  { Redraw client dock frames }
  FDockSite.Invalidate;
end;

procedure THKDockTree.InsertNewParent(NewZone, SiblingZone: TDockZone;
  ParentOrientation: TDockOrientation; InsertLast: Boolean);
var
  NewParent: TDockZone;
begin
  NewParent := TDockZone.Create(Self);
  NewParent.FOrientation := ParentOrientation;
  if SiblingZone = nil then
  begin
    // if SiblingZone is nil, then we need to insert zone as a child of the top
    NewParent.FZoneLimit := FTopXYLimit;
    FTopXYLimit := FTopZone.FZoneLimit;
    FShiftScaleOrient := ParentOrientation;
    FScaleBy := 0.5;
    if InsertLast then
    begin
      NewParent.FChildZones := FTopZone;
      FTopZone.FParentZone := NewParent;
      FTopZone.FNextSibling := NewZone;
      NewZone.FPrevSibling := FTopZone;
      NewZone.FParentZone := NewParent;
      FTopZone := NewParent;
      ForEachAt(NewParent.FChildZones, ScaleZone);
    end
    else begin
      NewParent.FChildZones := NewZone;
      FTopZone.FParentZone := NewParent;
      FTopZone.FPrevSibling := NewZone;
      NewZone.FNextSibling := FTopZone;
      NewZone.FParentZone := NewParent;
      FTopZone := NewParent;
      ForEachAt(NewParent.FChildZones, ScaleZone);
      FShiftBy := FTopZone.FZoneLimit div 2;
      ForEachAt(NewParent.FChildZones, ShiftZone);
      NewZone.FZoneLimit := FTopZone.FZoneLimit div 2;
    end;
    ForEachAt(nil, UpdateZone);
  end
  else begin
    // if SiblingZone is not nil, we need to insert a new parent zone for me
    // and my SiblingZone
    NewParent.FZoneLimit := SiblingZone.FZoneLimit;
    NewParent.FParentZone := SiblingZone.FParentZone;
    NewParent.FPrevSibling := SiblingZone.FPrevSibling;
    if NewParent.FPrevSibling <> nil then
      NewParent.FPrevSibling.FNextSibling := NewParent;
    NewParent.FNextSibling := SiblingZone.FNextSibling;
    if NewParent.FNextSibling <> nil then
      NewParent.FNextSibling.FPrevSibling := NewParent;
    if NewParent.FParentZone.FChildZones = SiblingZone then
      NewParent.FParentZone.FChildZones := NewParent;
    NewZone.FParentZone := NewParent;
    SiblingZone.FParentZone := NewParent;
    if InsertLast then
    begin
      // insert after SiblingZone
      NewParent.FChildZones := SiblingZone;
      SiblingZone.FPrevSibling := nil;
      SiblingZone.FNextSibling := NewZone;
      NewZone.FPrevSibling := SiblingZone;
    end
    else begin
      // insert before SiblingZone
      NewParent.FChildZones := NewZone;
      SiblingZone.FPrevSibling := NewZone;
      SiblingZone.FNextSibling := nil;
      NewZone.FNextSibling := SiblingZone;
    end;
    // Set bounds of new children
  end;
  NewParent.ResetChildren;
  ForEachAt(nil, UpdateZone);
end;

procedure THKDockTree.InsertSibling(NewZone, SiblingZone: TDockZone;
  InsertLast: Boolean);
begin
  if SiblingZone = nil then
  begin
    // If sibling is nil then make me the a child of the top
    SiblingZone := FTopZone.FChildZones;
    if InsertLast then
      while SiblingZone.FNextSibling <> nil do
        SiblingZone := SiblingZone.FNextSibling;
  end;
  if InsertLast then
  begin
    // Insert me after sibling
    NewZone.FParentZone := SiblingZone.FParentZone;
    NewZone.FPrevSibling := SiblingZone;
    NewZone.FNextSibling := SiblingZone.FNextSibling;
    if NewZone.FNextSibling <> nil then
      NewZone.FNextSibling.FPrevSibling := NewZone;
    SiblingZone.FNextSibling := NewZone;
  end
  else begin
    // insert before sibling
    NewZone.FNextSibling := SiblingZone;
    NewZone.FPrevSibling := SiblingZone.FPrevSibling;
    if NewZone.FPrevSibling <> nil then
      NewZone.FPrevSibling.FNextSibling := NewZone;
    SiblingZone.FPrevSibling := NewZone;
    NewZone.FParentZone := SiblingZone.FParentZone;
    if NewZone.FParentZone.FChildZones = SiblingZone then
      NewZone.FParentZone.FChildZones := NewZone;
  end;
  // Set up zone limits for all siblings
  SiblingZone.FParentZone.ResetChildren;
end;

function THKDockTree.InternalHitTest(const MousePos: TPoint; out HTFlag: Integer): TDockZone;
var
  ResultZone: TDockZone;

  procedure DoFindZone(Zone: TDockZone);
  var
    ZoneTop, ZoneLeft: Integer;
  begin
    // Check for hit on bottom splitter...
    if (Zone.FParentZone.FOrientation = doHorizontal) and
      ((MousePos.Y <= Zone.FZoneLimit) and
      (MousePos.Y >= Zone.FZoneLimit - FBorderWidth)) then
    begin
      HTFlag := HTBORDER;
      ResultZone := Zone;
    end
    // Check for hit on left splitter...
    else if (Zone.FParentZone.FOrientation = doVertical) and
      ((MousePos.X <= Zone.FZoneLimit) and
      (MousePos.X >= Zone.FZoneLimit - FBorderWidth)) then
    begin
      HTFlag := HTBORDER;
      ResultZone := Zone;
    end
    // Check for hit on grabber...
    else if Zone.FChildControl <> nil then
    begin
      ZoneTop := Zone.Top;
      ZoneLeft := Zone.Left;
      if FGrabbersOnTop then
      begin
        if (MousePos.Y >= ZoneTop) and (MousePos.Y <= ZoneTop + FGrabberSize) and
          (MousePos.X >= ZoneLeft) and (MousePos.X <= ZoneLeft + Zone.Width) then
        begin
          ResultZone := Zone;
          with Zone.FChildControl do
            if MousePos.X > Left + Width - 15 then HTFlag := HTCLOSE
            else HTFlag := HTCAPTION;
        end;
      end
      else begin
        if (MousePos.X >= ZoneLeft) and (MousePos.X <= ZoneLeft + FGrabberSize) and
          (MousePos.Y >= ZoneTop) and (MousePos.Y <= ZoneTop + Zone.Height) then
        begin
          ResultZone := Zone;
          if MousePos.Y < Zone.FChildControl.Top + 15 then HTFlag := HTCLOSE
          else HTFlag := HTCAPTION;
        end;
      end;
    end;
    // Recurse to next zone...
    if (ResultZone = nil) and (Zone.FNextSibling <> nil) then
      DoFindZone(Zone.FNextSibling);
    if (ResultZone = nil) and (Zone.FChildZones <> nil) then
      DoFindZone(Zone.FChildZones);
  end;

  function FindControlAtPos(const Pos: TPoint): TControl;
  var
    I: Integer;
    P: TPoint;
  begin
    for I := FDockSite.ControlCount - 1 downto 0 do
    begin
      Result := FDockSite.Controls[I];
      with Result do
      begin
        { Control must be Visible and Showing }
        if not Result.Visible or ((Result is TWinControl) and
           not TWinControl(Result).Showing) then continue;
        P := Point(Pos.X - Left, Pos.Y - Top);
        if PtInRect(ClientRect, P) then Exit;
      end;
    end;
    Result := nil;
  end;

var
  CtlAtPos: TControl;
begin
  ResultZone := nil;
  HTFlag := HTNOWHERE;
  CtlAtPos := FindControlAtPos(MousePos);
  if (CtlAtPos <> nil) and (CtlAtPos.HostDockSite = FDockSite) then
  begin
    ResultZone := FindControlZone(CtlAtPos);
    if ResultZone <> nil then HTFlag := HTCLIENT;
  end
  else if (FTopZone.FChildZones <> nil) and (FTopZone.ChildCount >= 1) and
    (CtlAtPos = nil) then
    DoFindZone(FTopZone.FChildZones);
  Result := ResultZone;
end;

var
  TreeStreamEndFlag: Integer = -1;

procedure THKDockTree.LoadFromStream(Stream: TStream);

  procedure ReadControlName(var ControlName: string);
  var
    Size: Integer;
  begin
    ControlName := '';
    Stream.Read(Size, SizeOf(Size));
    if Size > 0 then
    begin
      SetLength(ControlName, Size);
      Stream.Read(Pointer(ControlName)^, Size);
    end;
  end;

var
  CompName: string;
  Client: TControl;
  Level, LastLevel, I, InVisCount: Integer;
  Zone, LastZone, NextZone: TDockZone;
begin
  PruneZone(FTopZone);
  BeginUpdate;
  try
    // read stream version
    Stream.Read(I, SizeOf(I));
    // read invisible dock clients
    Stream.Read(InVisCount, SizeOf(InVisCount));
    for I := 0 to InVisCount - 1 do
    begin
      ReadControlName(CompName);
      if CompName <> '' then
      begin
        FDockSite.ReloadDockedControl(CompName, Client);
        if Client <> nil then
        begin
          Client.Visible := False;
          Client.ManualDock(FDockSite);
        end;
      end;
    end;
    // read top zone data
    Stream.Read(FTopXYLimit, SizeOf(FTopXYLimit));
    LastLevel := 0;
    LastZone := nil;
    // read dock zone tree
    while True do
    begin
      with Stream do
      begin
        Read(Level, SizeOf(Level));
        if Level = TreeStreamEndFlag then Break;
        Zone := TDockZone.Create(Self);
        Read(Zone.FOrientation, SizeOf(Zone.FOrientation));
        Read(Zone.FZoneLimit, SizeOf(Zone.FZoneLimit));
        ReadControlName(CompName);
        if CompName <> '' then
          if not Zone.SetControlName(CompName) then
          begin
            {Remove dock zone if control cannot be found}
            Zone.Free;
            Continue;
          end;
      end;
      if Level = 0 then FTopZone := Zone
      else if Level = LastLevel then
      begin
        LastZone.FNextSibling := Zone;
        Zone.FPrevSibling := LastZone;
        Zone.FParentZone := LastZone.FParentZone;
      end
      else if Level > LastLevel then
      begin
        LastZone.FChildZones := Zone;
        Zone.FParentZone := LastZone;
      end
      else if Level < LastLevel then
      begin
        NextZone := LastZone;
        for I := 1 to LastLevel - Level do NextZone := NextZone.FParentZone;
        NextZone.FNextSibling := Zone;
        Zone.FPrevSibling := NextZone;
        Zone.FParentZone := NextZone.FParentZone;
      end;
      LastLevel := Level;
      LastZone := Zone;
    end;
  finally
    EndUpdate;
  end;
//  ResetBounds(True);
end;

procedure THKDockTree.PaintDockFrame(Canvas: TCanvas; Control: TControl;
  const ARect: TRect);

  procedure DrawCloseButton(Left, Top: Integer);
  begin
    DrawFrameControl(Canvas.Handle, Rect(Left, Top, Left+FGrabberSize-2,
      Top+FGrabberSize-2), DFC_CAPTION, DFCS_CAPTIONCLOSE);
  end;

  procedure DrawGrabberLine(Left, Top, Right, Bottom: Integer);
  begin
    with Canvas do
    begin
      Pen.Color := clBtnHighlight;
      MoveTo(Right, Top);
      LineTo(Left, Top);
      LineTo(Left, Bottom);
      Pen.Color := clBtnShadow;
      LineTo(Right, Bottom);
      LineTo(Right, Top-1);
    end;
  end;

begin
  with ARect do
    if FDockSite.Align in [alTop, alBottom] then
    begin
      DrawCloseButton(Left+1, Top+1);
      DrawGrabberLine(Left+3, Top+FGrabberSize+1, Left+5, Bottom-2);
      DrawGrabberLine(Left+6, Top+FGrabberSize+1, Left+8, Bottom-2);
    end
    else
    begin
      DrawCloseButton(Right-FGrabberSize+1, Top+1);
      DrawGrabberLine(Left+2, Top+3, Right-FGrabberSize-2, Top+5);
      DrawGrabberLine(Left+2, Top+6, Right-FGrabberSize-2, Top+8);
    end;
end;

procedure THKDockTree.PaintSite(DC: HDC);
var
  Canvas: TControlCanvas;
  Control: TControl;
  I: Integer;
  R: TRect;
begin
  Canvas := TControlCanvas.Create;
  try
    Canvas.Control := FDockSite;
    Canvas.Lock;
    try
      Canvas.Handle := DC;
      try
        for I := 0 to FDockSite.ControlCount - 1 do
        begin
          Control := FDockSite.Controls[I];
          if Control.Visible and (Control.HostDockSite = FDockSite) then
          begin
            R := Control.BoundsRect;
            AdjustDockRect(Control, R);
            Dec(R.Left, 2 * (R.Left - Control.Left));
            Dec(R.Top, 2 * (R.Top - Control.Top));
            Dec(R.Right, 2 * (Control.Width - (R.Right - R.Left)));
            Dec(R.Bottom, 2 * (Control.Height - (R.Bottom - R.Top)));
            PaintDockFrame(Canvas, Control, R);
          end;
        end;
      finally
        Canvas.Handle := 0;
      end;
    finally
      Canvas.Unlock;
    end;
  finally
    Canvas.Free;
  end;
end;

procedure THKDockTree.PositionDockRect(Client, DropCtl: TControl;
  DropAlign: TAlign; var DockRect: TRect);
var
  VisibleClients,
  NewX, NewY, NewWidth, NewHeight: Integer;
begin
  VisibleClients := FDockSite.VisibleDockClientCount;
  { When docksite has no controls in it, or 1 or less clients then the
    dockrect should only be based on the client area of the docksite }
  if (DropCtl = nil) or (DropCtl.DockOrientation = doNoOrient) or
     {(DropCtl = Client) or }(VisibleClients < 2) then
  begin
    DockRect := Rect(0, 0, FDockSite.ClientWidth, FDockSite.ClientHeight);
    { When there is exactly 1 client we divide the docksite client area in half}
    if VisibleClients > 0 then
    with DockRect do
      case DropAlign of
        alLeft: Right := Right div 2;
        alRight: Left := Right div 2;
        alTop: Bottom := Bottom div 2;
        alBottom: Top := Bottom div 2;
      end;
  end
  else begin
  { Otherwise, if the docksite contains more than 1 client, set the coordinates
    for the dockrect based on the control under the mouse }
    NewX := DropCtl.Left;
    NewY := DropCtl.Top;
    NewWidth := DropCtl.Width;
    NewHeight := DropCtl.Height;
    if DropAlign in [alLeft, alRight] then
      NewWidth := DropCtl.Width div 2
    else if DropAlign in [alTop, alBottom] then
      NewHeight := DropCtl.Height div 2;
    case DropAlign of
      alRight: Inc(NewX, NewWidth);
      alBottom: Inc(NewY, NewHeight);
    end;
    DockRect := Bounds(NewX, NewY, NewWidth, NewHeight);
  end;
  MapWindowPoints(FDockSite.Handle, 0, DockRect, 2);
end;

procedure THKDockTree.PruneZone(Zone: TDockZone);

  procedure DoPrune(Zone: TDockZone);
  begin
    // Recurse sibling
    if Zone.FNextSibling <> nil then
      DoPrune(Zone.FNextSibling);
    // Recurse child
    if Zone.FChildZones <> nil then
      DoPrune(Zone.FChildZones);
    // Free zone
    Zone.Free;
  end;

begin
  if Zone = nil then Exit;
  // Delete children recursively
  if Zone.FChildZones <> nil then DoPrune(Zone.FChildZones);
  // Fixup all pointers to this zone
  if Zone.FPrevSibling <> nil then
    Zone.FPrevSibling.FNextSibling := Zone.FNextSibling
  else if Zone.FParentZone <> nil then
    Zone.FParentZone.FChildZones := Zone.FNextSibling;
  if Zone.FNextSibling <> nil then
    Zone.FNextSibling.FPrevSibling := Zone.FPrevSibling;
  // Free this zone
  if Zone = FTopZone then FTopZone := nil;
  Zone.Free;
end;

procedure THKDockTree.RemoveControl(Control: TControl);
var
  Z: TDockZone;
begin
  Z := FindControlZone(Control);
  if (Z <> nil) then
  begin
    if Z = FReplacementZone then
      Z.FChildControl := nil
    else
     RemoveZone(Z);
    Control.DockOrientation := doNoOrient;
    { Redraw client dock frames }
    FDockSite.Invalidate;
  end;
end;

procedure THKDockTree.RemoveZone(Zone: TDockZone);
var
  Sibling, LastChild: TDockZone;
  ZoneChildCount: Integer;
begin
  if Zone = nil then
    raise Exception.Create(SDockTreeRemoveError + SDockZoneNotFound);
  if Zone.FChildControl = nil then
    raise Exception.Create(SDockTreeRemoveError + SDockZoneHasNoCtl);
  ZoneChildCount := Zone.FParentZone.ChildCount;
  if ZoneChildCount = 1 then
  begin
    FTopZone.FChildZones := nil;
    FTopZone.FOrientation := doNoOrient;
  end
  else if ZoneChildCount = 2 then
  begin
    // This zone has only one sibling zone
    if Zone.FPrevSibling = nil then Sibling := Zone.FNextSibling
    else Sibling := Zone.FPrevSibling;
    if Sibling.FChildControl <> nil then
    begin
      // Sibling is a zone with one control and no child zones
      if Zone.FParentZone = FTopZone then
      begin
        // If parent is top zone, then just remove the zone
        FTopZone.FChildZones := Sibling;
        Sibling.FPrevSibling := nil;
        Sibling.FNextSibling := nil;
        Sibling.FZoneLimit := FTopZone.LimitSize;
        Sibling.Update;
      end
      else begin
        // Otherwise, move sibling's control up into parent zone and dispose of sibling
        Zone.FParentZone.FOrientation := doNoOrient;
        Zone.FParentZone.FChildControl := Sibling.FChildControl;
        Zone.FParentZone.FChildZones := nil;
        Sibling.Free;
      end;
      ForEachAt(Zone.FParentZone, UpdateZone);
    end
    else begin
      // Sibling is a zone with child zones, so sibling must be made topmost
      // or collapsed into higher zone.
      if Zone.FParentZone = FTopZone then
      begin
        // Zone is a child of topmost zone, so sibling becomes topmost
        Sibling.FZoneLimit := FTopXYLimit;
        FTopXYLimit := FTopZone.FZoneLimit;
        FTopZone.Free;
        FTopZone := Sibling;
        Sibling.FNextSibling := nil;
        Sibling.FPrevSibling := nil;
        Sibling.FParentZone := nil;
        UpdateAll;
      end
      else begin
        // Zone's parent is not the topmost zone, so child zones must be
        // collapsed into parent zone
        Sibling.FChildZones.FPrevSibling := Zone.FParentZone.FPrevSibling;
        if Sibling.FChildZones.FPrevSibling = nil then
          Zone.FParentZone.FParentZone.FChildZones := Sibling.FChildZones
        else
          Sibling.FChildZones.FPrevSibling.FNextSibling := Sibling.FChildZones;
        LastChild := Sibling.FChildZones;
        LastChild.FParentZone := Zone.FParentZone.FParentZone;
        repeat
          LastChild := LastChild.FNextSibling;
          LastChild.FParentZone := Zone.FParentZone.FParentZone;
        until LastChild.FNextSibling = nil;
        LastChild.FNextSibling := Zone.FParentZone.FNextSibling;
        if LastChild.FNextSibling <> nil then
          LastChild.FNextSibling.FPrevSibling := LastChild;
        ForEachAt(LastChild.FParentZone, UpdateZone);
        Zone.FParentZone.Free;
        Sibling.Free;
      end;
    end;
  end
  else begin
    // This zone has multiple sibling zones
    if Zone.FPrevSibling = nil then
    begin
      // First zone in parent's child list, so make next one first and remove
      // from list
      Zone.FParentZone.FChildZones := Zone.FNextSibling;
      Zone.FNextSibling.FPrevSibling := nil;
      Zone.FNextSibling.Update;
    end
    else begin
      // Not first zone in parent's child list, so remove zone from list and fix
      // up adjacent siblings
      Zone.FPrevSibling.FNextSibling := Zone.FNextSibling;
      if Zone.FNextSibling <> nil then
        Zone.FNextSibling.FPrevSibling := Zone.FPrevSibling;
      Zone.FPrevSibling.FZoneLimit := Zone.FZoneLimit;
      Zone.FPrevSibling.Update;
    end;
    ForEachAt(Zone.FParentZone, UpdateZone);
  end;
  Zone.Free;
end;

procedure THKDockTree.ResetBounds(Force: Boolean);
var
  R: TRect;
begin
  if not (csLoading in FDockSite.ComponentState) and
    (FTopZone <> nil) and (FDockSite.DockClientCount > 0) then
  begin
    R := FDockSite.ClientRect;
    FDockSite.AdjustClientRect(R);
    if Force or (not CompareMem(@R, @FOldRect, SizeOf(TRect))) then
    begin
      FOldRect := R;
      case FTopZone.FOrientation of
        doHorizontal:
          begin
            FTopZone.FZoneLimit := R.Right - R.Left;
            FTopXYLimit := R.Bottom - R.Top;
          end;
        doVertical:
          begin
            FTopZone.FZoneLimit := R.Bottom - R.Top;
            FTopXYLimit := R.Right - R.Left;
          end;
      end;
      if FDockSite.DockClientCount > 0 then
      begin
        SetNewBounds(nil);
        if FUpdateCount = 0 then ForEachAt(nil, UpdateZone);
      end;
    end;
  end;
end;

procedure THKDockTree.ScaleZone(Zone: TDockZone);
begin
  if Zone = nil then Exit;
  if (Zone <> nil) and (Zone.FParentZone.FOrientation = FShiftScaleOrient) then
    with Zone do
      FZoneLimit := Integer(Round(FZoneLimit * FScaleBy));
end;

procedure THKDockTree.SaveToStream(Stream: TStream);

  procedure WriteControlName(ControlName: string);
  var
    NameLen: Integer;
  begin
    NameLen := Length(ControlName);
    Stream.Write(NameLen, SizeOf(NameLen));
    if NameLen > 0 then Stream.Write(Pointer(ControlName)^, NameLen);
  end;

  procedure DoSaveZone(Zone: TDockZone; Level: Integer);
  begin
    with Stream do
    begin
      Write(Level, SizeOf(Level));
      Write(Zone.FOrientation, SizeOf(Zone.FOrientation));
      Write(Zone.FZoneLimit, SizeOf(Zone.FZoneLimit));
      WriteControlName(Zone.GetControlName);
    end;
    // Recurse child
    if Zone.FChildZones <> nil then
      DoSaveZone(Zone.FChildZones, Level + 1);
    // Recurse sibling
    if Zone.FNextSibling <> nil then
      DoSaveZone(Zone.FNextSibling, Level);
  end;

var
  I, NVCount: Integer;
  Ctl: TControl;
  NonVisList: TStringList;
begin
  // write stream version
  Stream.Write(FVersion, SizeOf(FVersion));
  // get list of non-visible dock clients
  NonVisList := TStringList.Create;
  try
    for I := 0 to FDockSite.DockClientCount - 1 do
    begin
      Ctl := FDockSite.DockClients[I];
      if (not Ctl.Visible) and (Ctl.Name <> '') then
        NonVisList.Add(Ctl.Name);
    end;
    // write non-visible dock client list
    NVCount := NonVisList.Count;
    Stream.Write(NVCount, SizeOf(NVCount));
    for I := 0 to NVCount - 1 do WriteControlName(NonVisList[I]);
  finally
    NonVisList.Free;
  end;
  // write top zone data
  Stream.Write(FTopXYLimit, SizeOf(FTopXYLimit));
  // write all zones from tree
  DoSaveZone(FTopZone, 0);
  Stream.Write(TreeStreamEndFlag, SizeOf(TreeStreamEndFlag));
end;

procedure THKDockTree.SetNewBounds(Zone: TDockZone);

  procedure DoSetNewBounds(Zone: TDockZone);
  begin
    if Zone <> nil then
    begin
      if (Zone.FNextSibling = nil) and (Zone <> FTopZone) then
      begin
        if Zone.FParentZone = FTopZone then Zone.FZoneLimit := FTopXYLimit
        else Zone.FZoneLimit := Zone.FParentZone.FParentZone.FZoneLimit;
      end;
      if Zone.FChildZones <> nil then DoSetNewBounds(Zone.FChildZones);
      if Zone.FNextSibling <> nil then DoSetNewBounds(Zone.FNextSibling);
    end;
  end;

begin
  if Zone = nil then Zone := FTopZone.FChildZones;
  DoSetNewBounds(Zone);
  { Redraw client dock frames }
  FDockSite.Invalidate;
end;

procedure THKDockTree.SetReplacingControl(Control: TControl);
begin
  FReplacementZone := FindControlZone(Control);
end;

procedure THKDockTree.ShiftZone(Zone: TDockZone);
begin
  if (Zone <> nil) and (Zone <> FTopZone) and
    (Zone.FParentZone.FOrientation = FShiftScaleOrient) then
    Inc(Zone.FZoneLimit, FShiftBy);
end;

procedure THKDockTree.SplitterMouseDown(OnZone: TDockZone; MousePos: TPoint);
begin
  FSizingZone := OnZone;
  Mouse.Capture := FDockSite.Handle;
  FSizingWnd := FDockSite.Handle;
  FSizingDC := GetDCEx(FSizingWnd, 0, DCX_CACHE or DCX_CLIPSIBLINGS or
    DCX_LOCKWINDOWUPDATE);
  FSizePos := MousePos;
  DrawSizeSplitter;
end;

procedure THKDockTree.SplitterMouseUp;
begin
  Mouse.Capture := 0;
  DrawSizeSplitter;
  ReleaseDC(FSizingWnd, FSizingDC);
  if FSizingZone.FParentZone.FOrientation = doHorizontal then
    FSizingZone.FZoneLimit := FSizePos.y + (FBorderWidth div 2) else
    FSizingZone.FZoneLimit := FSizePos.x + (FBorderWidth div 2);
  SetNewBounds(FSizingZone.FParentZone);
  ForEachAt(FSizingZone.FParentZone, UpdateZone);
  FSizingZone := nil;
end;

procedure THKDockTree.UpdateAll;
begin
  if (FUpdateCount = 0) and (FDockSite.DockClientCount > 0) then
    ForEachAt(nil, UpdateZone);
end;

procedure THKDockTree.UpdateZone(Zone: TDockZone);
begin
  if FUpdateCount = 0 then Zone.Update;
end;

procedure THKDockTree.DrawSizeSplitter;
var
  R: TRect;
  PrevBrush: HBrush;
begin
  if FSizingZone <> nil then
  begin
    with R do
    begin
      if FSizingZone.FParentZone.FOrientation = doHorizontal then
      begin
        Left := FSizingZone.Left;
        Top := FSizePos.Y - (FBorderWidth div 2);
        Right := Left + FSizingZone.Width;
        Bottom := Top + FBorderWidth;
      end
      else begin
        Left := FSizePos.X - (FBorderWidth div 2);
        Top := FSizingZone.Top;
        Right := Left + FBorderWidth;
        Bottom := Top + FSizingZone.Height;
      end;
    end;
    PrevBrush := SelectObject(FSizingDC, FBrush.Handle);
    with R do
      PatBlt(FSizingDC, Left, Top, Right - Left, Bottom - Top, PATINVERT);
    SelectObject(FSizingDC, PrevBrush);
  end;
end;

function THKDockTree.GetNextLimit(AZone: TDockZone): Integer;
var
  LimitResult: Integer;

  function Min(I1, I2: Integer): Integer;
  begin
    if I1 > I2 then Result := I2
    else Result := I1;
  end;

  procedure DoGetNextLimit(Zone: TDockZone);
  begin
    if (Zone <> AZone) and
      (Zone.FParentZone.FOrientation = AZone.FParentZone.FOrientation) and
      (Zone.FZoneLimit > AZone.FZoneLimit) and ((Zone.FChildControl = nil) or
      ((Zone.FChildControl <> nil) and (Zone.FChildControl.Visible))) then
      LimitResult := Min(LimitResult, Zone.FZoneLimit);
    if Zone.FNextSibling <> nil then DoGetNextLimit(Zone.FNextSibling);
    if Zone.FChildZones <> nil then DoGetNextLimit(Zone.FChildZones);
  end;

begin
  if AZone.FNextSibling <> nil then
    LimitResult := AZone.FNextSibling.FZoneLimit
  else
    LimitResult := AZone.FZoneLimit + AZone.LimitSize;
  DoGetNextLimit(FTopZone.FChildZones);
  Result := LimitResult;
end;

procedure THKDockTree.ControlVisibilityChanged(Control: TControl;
  Visible: Boolean);

  function GetDockAlign(Client, DropCtl: TControl): TAlign;
  var
    CRect, DRect: TRect;
  begin
    Result := alRight;
    if DropCtl <> nil then
    begin
      CRect := Client.BoundsRect;
      DRect := DropCtl.BoundsRect;
      if (CRect.Top <= DRect.Top) and (CRect.Bottom < DRect.Bottom) and
         (CRect.Right >= DRect.Right) then
        Result := alTop
      else if (CRect.Left <= DRect.Left) and (CRect.Right < DRect.Right) and
         (CRect.Bottom >= DRect.Bottom) then
        Result := alLeft
      else if CRect.Top >= ((DRect.Top + DRect.Bottom) div 2) then
        Result := alBottom;
    end;
  end;

var
  HitTest: Integer;
  DropCtlZone: TDockZone;
  DropCtl: TControl;
begin
  if Visible then
  begin
    if FindControlZone(Control) = nil then
    begin
      DropCtlZone := InternalHitTest(Point(Control.Left, Control.Top), HitTest);
      if DropCtlZone <> nil then DropCtl := DropCtlZone.FChildControl
      else DropCtl := nil;
      InsertControl(Control, GetDockAlign(Control, DropCtl), DropCtl);
    end;
  end
  else
    RemoveControl(Control)
end;

procedure THKDockTree.WindowProc(var Message: TMessage);

  procedure CalcSplitterPos;
  var
    MinWidth,
    TestLimit: Integer;
  begin
    MinWidth := FGrabberSize;
    if (FSizingZone.FParentZone.FOrientation = doHorizontal) then
    begin
      TestLimit := FSizingZone.Top + MinWidth;
      if FSizePos.y <= TestLimit then FSizePos.y := TestLimit;
      TestLimit := GetNextLimit(FSizingZone) - MinWidth;
      if FSizePos.y >= TestLimit then FSizePos.y := TestLimit;
    end
    else begin
      TestLimit := FSizingZone.Left + MinWidth;
      if FSizePos.x <= TestLimit then FSizePos.x := TestLimit;
      TestLimit := GetNextLimit(FSizingZone) - MinWidth;
      if FSizePos.x >= TestLimit then FSizePos.x := TestLimit;
    end;
  end;

const
  SizeCursors: array[TDockOrientation] of TCursor = (crDefault, crVSplit, crHSplit);
var
  TempZone: TDockZone;
  Control: TControl;
  P: TPoint;
  R: TRect;
  HitTestValue: Integer;
  Msg: TMsg;
begin
  case Message.Msg of
    CM_DOCKNOTIFICATION:
      with TCMDockNotification(Message) do
        if (NotifyRec.ClientMsg = CM_VISIBLECHANGED) then
          ControlVisibilityChanged(Client, Boolean(NotifyRec.MsgWParam));
    WM_MOUSEMOVE:
      if FSizingZone <> nil then
      begin
        DrawSizeSplitter;
        FSizePos := SmallPointToPoint(TWMMouse(Message).Pos);
        CalcSplitterPos;
        DrawSizeSplitter;
      end;
    WM_LBUTTONDBLCLK:
      begin
        TempZone := InternalHitTest(SmallPointToPoint(TWMMouse(Message).Pos),
          HitTestValue);
        if TempZone <> nil then
          with TempZone do
            if (FChildControl <> nil) and (HitTestValue = HTCAPTION) then
            begin
              CancelDrag;
              FChildControl.ManualDock(nil, nil, alTop);
            end;
      end;
    WM_LBUTTONDOWN:
      begin
        P := SmallPointToPoint(TWMMouse(Message).Pos);
        TempZone := InternalHitTest(P, HitTestValue);
        if (TempZone <> nil) then
        begin
          if HitTestValue = HTBORDER then
            SplitterMouseDown(TempZone, P)
          else if HitTestValue = HTCAPTION then
          begin
            if (not PeekMessage(Msg, FDockSite.Handle, WM_LBUTTONDBLCLK,
              WM_LBUTTONDBLCLK, PM_NOREMOVE)) and
              (TempZone.FChildControl is TWinControl) then
              TWinControl(TempZone.FChildControl).SetFocus;
	    if (TempZone.FChildControl.DragKind = dkDock) and
              (TempZone.FChildControl.DragMode = dmAutomatic)then
                TempZone.FChildControl.BeginDrag(False);
	    Exit;
          end;
        end;
      end;
    WM_LBUTTONUP:
      if FSizingZone = nil then
      begin
        P := SmallPointToPoint(TWMMouse(Message).Pos);
        TempZone := InternalHitTest(P, HitTestValue);
        if (TempZone <> nil) and (HitTestValue = HTCLOSE) then
        begin
          if TempZone.FChildControl is TCustomForm then
            TCustomForm(TempZone.FChildControl).Close
          else
            TempZone.FChildControl.Visible := False;
        end;
      end
      else
        SplitterMouseUp;
    WM_SETCURSOR:
      begin
        GetCursorPos(P);
        P := FDockSite.ScreenToClient(P);
        with TWMSetCursor(Message) do
          if (Smallint(HitTest) = HTCLIENT) and (CursorWnd = FDockSite.Handle)
            and (FDockSite.VisibleDockClientCount > 0) then
          begin
            TempZone := InternalHitTest(P, HitTestValue);
            if (TempZone <> nil) and (HitTestValue = HTBORDER) then
            begin
              Windows.SetCursor(Screen.Cursors[SizeCursors[TempZone.FParentZone.FOrientation]]);
              Result := 1;
              Exit;
            end;
          end;
      end;
    CM_HINTSHOW:
      with TCMHintShow(Message) do
      begin
        FOldWndProc(Message);
        if Result = 0 then
        begin
          Control := HitTest(HintInfo^.CursorPos, HitTestValue);
          if HitTestValue = HTBORDER then
            HintInfo^.HintStr := ''
          else if (Control <> nil) and (HitTestValue in [HTCAPTION, HTCLOSE]) then
          begin
            R := Control.BoundsRect;
            AdjustDockRect(Control, R);
            Dec(R.Left, 2 * (R.Left - Control.Left));
            Dec(R.Top, 2 * (R.Top - Control.Top));
            Dec(R.Right, 2 * (Control.Width - (R.Right - R.Left)));
            Dec(R.Bottom, 2 * (Control.Height - (R.Bottom - R.Top)));
            HintInfo^.HintStr := Control.Caption;
            HintInfo^.CursorRect := R;
          end;
        end;
        Exit;
      end;
  end;
  FOldWndProc(Message);
end;

end.
 