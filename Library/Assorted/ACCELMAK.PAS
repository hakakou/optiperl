{$A+,B-,F-,G+,I+,P-,T-,U-,V+,Z-}
{$IFDEF DEBUG}
  {$R+,S+,W+}
{$ELSE}
  {$R-,S-,W-}
{$ENDIF}
{$IFNDEF VER80}
  {$H+}
  {$IFDEF DEBUG}
    {$Q+,O-}
    {$HINTS ON}{$WARNINGS ON}
  {$ELSE}
    {$Q-,O+}
    {$HINTS OFF}{$WARNINGS OFF}
  {$ENDIF}
{$ELSE}
  {$F-,K+,N+}
{$ENDIF}
{
**************************************

 Delphi unit
 Copyright (c) 1999, 2000 Riccardo Novello

**************************************
}

unit ACCELMAK;

interface

uses
  Windows,Messages,SysUtils,Classes,Graphics,
  Menus,StdCtrls,Controls,ExtCtrls,ComCtrls,
  Forms,DesignIntf,Dialogs,DesignEditors;


type
  TAcceleratorMaker = class(TComponent)
  public
    AMEF: TForm;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

type
  SelectMode = (smSelectAll,smSelectNone,smInvertSelection);

type
  TAcceleratorMakerEditorForm = class(TForm)
    ComponentsPopupMenu: TPopupMenu;
    CaptionsPopupMenu: TPopupMenu;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    N2: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    N1: TMenuItem;
    CopyCaptions: TMenuItem;
    Hints1: TMenuItem;
    Hints2: TMenuItem;
    Sorted1: TMenuItem;
    FilterPopupMenu: TPopupMenu;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    PageControl1: TPageControl;
    FilterTabSheet: TTabSheet;
    FilterListBox: TListBox;
    ComponentsTabSheet: TTabSheet;
    ComponentsListBox: TListBox;
    CaptionsTabSheet: TTabSheet;
    CaptionsListBox: TListBox;
    Panel4: TPanel;
    CaptionsEdit: TEdit;
    CaptionsUndo: TMenuItem;
    About1: TMenuItem;
    Refresh: TMenuItem;

    procedure ComponentsListBoxExit(Sender: TObject);
    procedure CaptionsEditExit(Sender: TObject);
    procedure CaptionsListBoxClick(Sender: TObject);
    procedure Panel4Resize(Sender: TObject);

    procedure SelectAllClick(Sender: TObject);
    procedure DeselectAllClick(Sender: TObject);
    procedure InvertSelectionClick(Sender: TObject);
    procedure CalcSelectedAcceleratorsClick(Sender: TObject);
    procedure CalcAllAcceleratorsClick(Sender: TObject);
    procedure ClearSelectedAcceleratorsClick(Sender: TObject);
    procedure ClearAllAcceleratorsClick(Sender: TObject);
    procedure SortedClick(Sender: TObject);
    procedure FilterListBoxExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure F10KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CaptionsEditEnter(Sender: TObject);
    procedure CaptionsUndoClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure CopyCaptionsClick(Sender: TObject);
    procedure RefreshClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure HintsClick(Sender: TObject);
  private
    fAcceleratorMaker: TAcceleratorMaker;
    MinTrackSizeX,
    MinTrackSizeY: Longint;
    SavedCaptions: TStringList;
    procedure WMGetMinMaxInfo(var Message :TWMGetMinMaxInfo); message WM_GETMINMAXINFO;
    procedure SetCaption(i: Integer; const s: String);
    procedure SetPosition;
    procedure UpdateFilter;
    procedure InitFilter;
    procedure InitComponents;
    procedure InitCaptions;
    procedure AdjustComponentCaptions;
    procedure ClearCaptionsAccelerators;
    procedure CalcCaptionsAccelerators;
    procedure SetCaptionsEdit;
    procedure UpdateSelectedCaption;
    procedure SelectClick(Mode: SelectMode);
    procedure ClearListAccelerators;
    procedure CopyMessage;
  public
    constructor CreateParam(AOwner: TComponent;
      AAcceleratorMaker: TAcceleratorMaker);
    destructor Destroy; override;
    end;

type
 TAcceleratorMakerEditor = class(TComponentEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    end;

var
  AcceleratorMaker: TAcceleratorMaker;

procedure Register;

implementation

{$R *.DFM}

uses
  Buttons,DBCtrls,TypInfo;

const
  UNITNAME = 'ACCELMAK';

procedure RaiseException(Obj: TObject; const MethodName,Info: String);
  var s: String;
  begin
  s:=Format('%s.%s.%s error',[UNITNAME,Obj.ClassName,MethodName]);
  if Length(Info) <> 0 then
    s:=s+': '+Info;
  raise Exception.Create(s);
  end;


{ TAcceleratorMaker }
constructor TAcceleratorMaker.Create(AOwner: TComponent);
  begin
  if AOwner = nil then
    RaiseException(Self,'Create','AOwner unassigned');
  if not (AOwner is TControl) then
    RaiseException(Self,'Create','AOwner is not TControl');
  inherited Create(AOwner);
  AMEF:=TAcceleratorMakerEditorForm.CreateParam(Application,Self);
  end;

destructor TAcceleratorMaker.Destroy;
  begin
  AMEF.Free;
  inherited Destroy;
  end;

procedure ListBoxSelect(ListBox: TListBox; Select: SelectMode);
  var i: Integer;
  begin
  with ListBox do
    begin
    case Select of
    smSelectAll:
      for i:=0 to Items.Count-1 do
        Selected[i]:=true;
    smSelectNone:
      for i:=0 to Items.Count-1 do
        Selected[i]:=false;
smInvertSelection:
      for i:=0 to Items.Count-1 do
        Selected[i]:=not Selected[i]
      end
    end;
  end;

procedure TAcceleratorMakerEditorForm.WMGetMinMaxInfo(var Message :TWMGetMinMaxInfo);
  begin
  with Message.MinMaxInfo^ do
    begin
    ptMinTrackSize.X:=MinTrackSizeX;
    ptMinTrackSize.Y:=MinTrackSizeY;
    end;
  Message.Result:=0;
  inherited
  end;

procedure TAcceleratorMakerEditorForm.SetCaption(i: Integer; const s: String);
  var WasSelected: Boolean;
  begin
  with CaptionsListBox,Items do
    begin
    WasSelected:=Selected[i];
    Items[i]:=s; { reset Selected!!! }
    if WasSelected then
      Selected[i]:=true;
    end
  end;


procedure TAcceleratorMakerEditorForm.ClearCaptionsAccelerators;
  var
    i,j: Integer; s: String;
  begin
  with CaptionsListBox,Items do
    begin
    if Count < 1 then
      Exit;
    BeginUpdate;
    SavedCaptions.Assign(Items);
    CaptionsUndo.Enabled:=true;
    try
      for i:=0 to Count-1 do
        if Selected[i] then
          begin
          s:=Strings[i];
          j:=Pos('&',s);
          if j > 0 then
            begin
            System.Delete(s,j,1);
            SetCaption(i,s);
            end;
          end;

    finally
      EndUpdate;
      end;
    end;
  end;


const ValidChars =['!','$','0'..'9','<'..'Z','a'..'z'];


procedure TAcceleratorMakerEditorForm.CalcCaptionsAccelerators;
  var
    i,p,j,k,q,Len: Integer; s: String;
    c: Char; Found: Boolean;
    AcceleratorStack: TStringList; Obj: TObject;

  begin
  with CaptionsListBox,Items do
    begin
    if Count < 1 then
      Exit;
    AcceleratorStack:=TStringList.Create;
    BeginUpdate;
    SavedCaptions.Assign(Items);
    CaptionsUndo.Enabled:=true;
    try
      with AcceleratorStack do
        begin Duplicates:=dupIgnore; Sorted:=true end;
      for i:=0 to Count-1 do
        if Selected[i] then
          begin
          s:=Strings[i];
          Len:=Length(s);
          if Len > 0 then
            begin
            p:=Pos('&',s);
            if p = 0
              then begin System.Insert('&',s,1); p:=1 end
              else if p = Len then
                     begin System.Insert('&',s,1); System.Delete(s,Len,1); p:=1 end;
            c:=UpCase(s[p+1]);
            k:=AcceleratorStack.IndexOf(c);
            if k = -1 then
              begin
              Obj:=Objects[i];
{$IFDEF DEBUG}
              if Obj = nil then
                RaiseException(Self,'CalcCaptionsAccelerators',
                  'Objects[i] unassigned');
{$ENDIF}
              AcceleratorStack.AddObject(c,Obj);
              end;
            SetCaption(i,s);
            end;
          end;

      for i:=0 to Count-1 do
        if Selected[i] then
          begin
          s:=Strings[i];
          Len:=Length(s);
          if Len > 0 then
            begin
            q:=Pos('&',s);
            p:=q+1;
            j:=1; Found:=false;
            while (j <= Len) and (not Found) do
              begin
              c:=UpCase(s[p]);
              if c in ValidChars then
                begin
                k:=AcceleratorStack.IndexOf(c);
                if k > -1
                  then begin
                       if AcceleratorStack.Objects[k] = Objects[i] then
                         begin
                         SetCaption(i,s);
                         Found:=true;
                         end
                       end
                  else begin
                       AcceleratorStack.AddObject(c,Objects[i]);
                       System.Insert('&',s,p);
                       System.Delete(s,q,1);
                       SetCaption(i,s);
                       Found:=true;
                       end
                end;
              Inc(p);
              if p > Length(s) then
                p:=1;
              Inc(j);
              end;
            if not Found then
              begin
              s:=StripHotKey(s);
              SetCaption(i,s);
              end
            end
          end;
    finally
      AcceleratorStack.Free;
      EndUpdate;
      end;
    end;
  AdjustComponentCaptions;
  end;

procedure TAcceleratorMakerEditorForm.ClearListAccelerators;
  begin
  ClearCaptionsAccelerators;
  AdjustComponentCaptions;
  end;

procedure TAcceleratorMakerEditorForm.ClearSelectedAcceleratorsClick(
  Sender: TObject);
  begin
  ClearListAccelerators;
  end;

procedure TAcceleratorMakerEditorForm.ClearAllAcceleratorsClick(Sender: TObject);
  begin
  ListBoxSelect(CaptionsListBox,smSelectAll);
  ClearListAccelerators;
  end;

procedure SetComponentCaption(Obj: TObject; const S: String);
  var PropInfo: TypInfo.PPropInfo;
  begin
  PropInfo:=GetPropInfo(Obj.ClassInfo,'Caption');
  if PropInfo <> nil then
    TypInfo.SetStrProp(Obj,PropInfo,S);
  end;

procedure TAcceleratorMakerEditorForm.AdjustComponentCaptions;
  var i: Integer;
  begin
  with CaptionsListBox do
    for i:=0 to Items.Count-1 do
      SetComponentCaption(TComponent(Items.Objects[i]),
        Items[i]);
  TControl(fAcceleratorMaker.Owner).Invalidate;
  CaptionsListBoxClick(nil)
  end;

procedure TAcceleratorMakerEditorForm.InitComponents;
  var
    s,n: String;
    PropInfo: TypInfo.PPropInfo;

  procedure RecursiveFill(Component: TComponent);
    var i: Integer; C: TComponent;

    function ValidComponent: Boolean;
      begin
      if C.Owner = nil then
        RaiseException(Self,'InitComponents.ValidComponent','');
      PropInfo:=GetPropInfo(C.ClassInfo,'Visible');
      Result:=PropInfo <> nil;
      if Result then
        begin
        Result:=TypInfo.GetOrdProp(C,PropInfo) <> 0;
        if Result then
          begin
          PropInfo:=GetPropInfo(C.ClassInfo,'Caption');
          Result:=PropInfo <> nil;
          if Result then
            begin
            with FilterListBox do
              Result:=Selected[Items.IndexOf(C.ClassName)];
            if Result {and
               (not (C is TRadioButton)) and
               (not (C is TGroupBox)) and
               (not (C is TRadioGroup)) and
               (not (C is TDBRadioGroup)) }then
              begin
              s:=TypInfo.GetStrProp(C,PropInfo);
              Result:=(Length(s) > 0) and
                      (s <> '-');
              end
            end
          end
        end;
      if Result then
        begin
        n:='';
        if C.Owner <> fAcceleratorMaker.Owner then
           if Length(C.Owner.Name) > 0 then
             n:=n+C.Owner.Name+'.';
        n:=n+C.Name;
        if Length(C.Name) < 1 then
          n:=n+StripHotKey(s);
        n:=n+': '+C.ClassName;
        end;
      end;

    begin
    with Component do
      for i:=0 to ComponentCount-1 do
        begin
        C:=Components[i];
        if ValidComponent then
          ComponentsListBox.Items.AddObject(n,C);
        if C.ComponentCount > 0 then
          RecursiveFill(C);
        end;
    end;


  begin
  ComponentsListBox.Clear;
  ComponentsListBox.Items.BeginUpdate;
  try
    RecursiveFill(fAcceleratorMaker.Owner);
    (*SortTStrings(ComponentsListBox.Items);*)
  finally
    ComponentsListBox.Items.EndUpdate;
    end;
  ListBoxSelect(ComponentsListBox,smSelectAll);
  ComponentsListBoxExit(Self);
  end;



procedure TAcceleratorMakerEditorForm.SetPosition;
  var OwnerScreenCenter: TPoint; OwnerR: TRect;
  begin
  OwnerR:=TControl(fAcceleratorMaker.Owner).BoundsRect;
  OwnerScreenCenter.X:=(OwnerR.Left+OwnerR.Right) div 2;
  OwnerScreenCenter.Y:=(OwnerR.Top+OwnerR.Bottom) div 2;
  if OwnerScreenCenter.X >= Screen.Width div 2
    then Left:=OwnerR.Left-Width
    else Left:=OwnerR.Right;
  if OwnerScreenCenter.Y >= Screen.Height div 2
    then Top:=OwnerR.Bottom-Height
    else Top:=OwnerR.Top;
  end;


procedure TAcceleratorMakerEditorForm.UpdateFilter;
  var
    s: String;
    PropInfo: TypInfo.PPropInfo;
    j: Integer;

  procedure RecursiveFill(Component: TComponent);
    var i: Integer; C: TComponent;

    function ValidComponent: Boolean;
      begin
      if C.Owner = nil then
        RaiseException(Self,'InitClasses.ValidComponent','');
      PropInfo:=GetPropInfo(C.ClassInfo,'Visible');
      Result:=PropInfo <> nil;
      if Result then
        begin
        Result:=TypInfo.GetOrdProp(C,PropInfo) <> 0;
        if Result then
          begin
          PropInfo:=GetPropInfo(C.ClassInfo,'Caption');
          Result:=PropInfo <> nil;
          if Result then
            s:=C.ClassName
          end
        end
      end;

    begin
    with Component do
      for i:=0 to ComponentCount-1 do
        begin
        C:=Components[i];
        if ValidComponent then
          with FilterListBox,Items do
            if IndexOf(s) < 0 then
              begin
              j:=AddObject(s,C);
              if j < 0
                then RaiseException(Self,'InitClasses','')
                else Selected[j]:=true
              end;
        if C.ComponentCount > 0 then
          RecursiveFill(C);
        end;
    end;


  begin
  FilterListBox.Items.BeginUpdate;
  try
    RecursiveFill(fAcceleratorMaker.Owner);
    (*SortTStrings(FilterListBox.Items);*)
  finally
    FilterListBox.Items.EndUpdate;
    end;
  end;

procedure TAcceleratorMakerEditorForm.InitFilter;
  begin
  FilterListBox.Clear;
  UpdateFilter;
  ListBoxSelect(FilterListBox,smSelectAll);
  FilterListBoxExit(Self);
  end;


constructor TAcceleratorMakerEditorForm.CreateParam(AOwner: TComponent;
    AAcceleratorMaker: TAcceleratorMaker);
  begin
  if AOwner = nil then
    RaiseException(Self,'CreateParam','AOwner unassigned');
  if AAcceleratorMaker = nil then
    RaiseException(Self,'CreateParam','AAcceleratorMaker unassigned');
  inherited Create(AOwner);
  MinTrackSizeX:=178{Width};
  MinTrackSizeY:=121{Height div 2};
  fAcceleratorMaker:=AAcceleratorMaker;
  SavedCaptions:=TStringList.Create;
  with SavedCaptions do
    begin
    Sorted:=false;
    Duplicates:=dupAccept;
    end;
  CaptionsUndo.Enabled:=false;
  SetPosition;
  PageControl1.ActivePage:=FilterTabSheet;
  InitFilter;
  end;

procedure TAcceleratorMakerEditorForm.FilterListBoxExit(Sender: TObject);
  begin
  InitComponents;
  end;

procedure TAcceleratorMakerEditorForm.InitCaptions;
  var i: Integer; C: TObject; s: String; PropInfo: TypInfo.PPropInfo;
  begin
  CaptionsListBox.Items.BeginUpdate;
  try
    CaptionsListBox.Clear;
    with ComponentsListBox do
      for i:=0 to Items.Count-1 do
        if Selected[i] then
          begin
          C:=Items.Objects[i];
          PropInfo:=GetPropInfo(C.ClassInfo,'Caption');
          if PropInfo <> nil
            then s:=TypInfo.GetStrProp(C,PropInfo)
            else RaiseException(Self,'ComponentsListBoxExit','');
          CaptionsListBox.Items.AddObject(s,C);
          end
  finally
    CaptionsListBox.Items.EndUpdate;
    end;
  ListBoxSelect(CaptionsListBox,smSelectAll);
  SetCaptionsEdit;
  end;

procedure TAcceleratorMakerEditorForm.ComponentsListBoxExit(
  Sender: TObject);
  begin
  InitCaptions;
  end;

procedure TAcceleratorMakerEditorForm.SetCaptionsEdit;
  begin
  with CaptionsListBox do
    if (Items.Count > 0) and
       (ItemIndex >= 0)
      then CaptionsEdit.Text:=Items[ItemIndex]
      else CaptionsEdit.Text:=''
  end;

procedure TAcceleratorMakerEditorForm.UpdateSelectedCaption;
  var Index: Integer;
  begin
  with CaptionsListBox,CaptionsEdit do
    begin
    Index:=ItemIndex;
    if (Index < 0) or (Items.Count < 1) then
      Exit;
    Items[Index]:=Text;
    Selected[Index]:=true;
    SetComponentCaption(Items.Objects[Index],Text);
    end;
  end;


procedure TAcceleratorMakerEditorForm.CaptionsListBoxClick(
  Sender: TObject);
  begin
  SetCaptionsEdit;
  end;

procedure TAcceleratorMakerEditorForm.CaptionsEditEnter(Sender: TObject);
  begin
  SetCaptionsEdit;
  end;

procedure TAcceleratorMakerEditorForm.CaptionsEditExit(Sender: TObject);
  begin
  UpdateSelectedCaption;
  end;


procedure TAcceleratorMakerEditorForm.Panel4Resize(Sender: TObject);
  begin
  CaptionsEdit.SetBounds(0,0,Panel4.Width,Panel4.Height);
  end;


procedure TAcceleratorMakerEditorForm.SelectClick(Mode: SelectMode);
  begin
  if PageControl1.ActivePage = FilterTabSheet then
    begin
    ListBoxSelect(FilterListBox,Mode);
    FilterListBoxExit(Self);
    end
  else if PageControl1.ActivePage = ComponentsTabSheet then
    begin
    ListBoxSelect(ComponentsListBox,Mode);
    ComponentsListBoxExit(Self);
    end
  else if PageControl1.ActivePage = CaptionsTabSheet then
    ListBoxSelect(CaptionsListBox,Mode)
  end;

procedure TAcceleratorMakerEditorForm.SelectAllClick(Sender: TObject);
  begin
  SelectClick(smSelectAll);
  end;

procedure TAcceleratorMakerEditorForm.DeselectAllClick(Sender: TObject);
  begin
  SelectClick(smSelectNone);
  end;

procedure TAcceleratorMakerEditorForm.InvertSelectionClick(
  Sender: TObject);
  begin
  SelectClick(smInvertSelection);
  end;



procedure TAcceleratorMakerEditorForm.CalcSelectedAcceleratorsClick(Sender: TObject);
  begin
  CalcCaptionsAccelerators
  end;

procedure TAcceleratorMakerEditorForm.CalcAllAcceleratorsClick(Sender: TObject);
  begin
  ListBoxSelect(CaptionsListBox,smSelectAll);
  CalcCaptionsAccelerators
  end;



procedure TAcceleratorMakerEditorForm.SortedClick(Sender: TObject);
  var ListBox: TListBox;
  begin
  TMenuItem(Sender).Checked:=not TMenuItem(Sender).Checked;
  if PageControl1.ActivePage = FilterTabSheet then
    ListBox:=FilterListBox
  else if PageControl1.ActivePage = ComponentsTabSheet then
    ListBox:=ComponentsListBox
  else ListBox:=CaptionsListBox;
  ListBox.Sorted:=TMenuItem(Sender).Checked;
  Application.ProcessMessages;
  SendMessage(ListBox.Handle,WM_KEYDOWN,VK_HOME,1);
  SendMessage(ListBox.Handle,WM_KEYUP,VK_HOME,1);
  end;

procedure TAcceleratorMakerEditorForm.HintsClick(Sender: TObject);
  begin
  TMenuItem(Sender).Checked:=not TMenuItem(Sender).Checked;
  ShowHint:=TMenuItem(Sender).Checked;
  end;

(*
Question:
Is there any way to reduce the resource requirements of the TNotebook and TTabbedNotebook components?
Answer:
Yes. It is possible to reduce the requirements of the pages in the
TNotebook and TTabbedNotebook components by destroying the handles of
the components that are not on the current page. The following
example demonstrates calling the protected DestroyHandle method of the
page, by subclassing the notebook to get access to the protected
method.

type TMyTabbedNotebook = class(TTabbedNotebook);
type TMyNotebook = class(TNotebook);

procedure TForm1.TabbedNotebook1Change(Sender: TObject;
                                       NewTab: Integer;
                                       var AllowChange: Boolean);
begin
  with TabbedNotebook1 do
    TMyTabbedNotebook(
      TWinControl(Pages.Objects[PageIndex])).DestroyHandle;
end;

procedure TForm1.TabSet1Change(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
  with Notebook1 do
    TMyNotebook(TWinControl(Pages.Objects[PageIndex])).DestroyHandle;
  NoteBook1.PageIndex := NewTab;
  AllowChange := true
end;


type { subclass to expose protected methods }
  TMyTabSheet= class(TTabSheet)
    end;

procedure TAcceleratorMakerEditorForm.PageControl1Enter(Sender: TObject);
  var i: Integer; Page: TTabSheet;
  begin
  with PageControl1 do
    for i:=0 to PageCount-1 do
      begin
      Page:=Pages[i];
      if Page <> ActivePage then
        TMyTabSheet(Page).DestroyHandle
      end;
  end;

procedure TAcceleratorMakerEditorForm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
  begin
  TMyTabSheet(PageControl1.ActivePage).DestroyHandle;
  end;
*)

procedure TAcceleratorMakerEditorForm.PageControl1Change(Sender: TObject);
  begin
(*  TMyTabSheet(PageControl1.ActivePage).CreateHandle;*)
  if PageControl1.ActivePage = FilterTabSheet then
    begin
    UpdateFilter;
    FilterListBoxExit(Self);
    end;
  if PageControl1.ActivePage = CaptionsTabSheet then
    SetCaptionsEdit;
  end;

destructor TAcceleratorMakerEditorForm.Destroy;
   begin
   if fAcceleratorMaker <> nil then
     fAcceleratorMaker.AMEF:=nil;
   SavedCaptions.Free;
   inherited Destroy;
   end;

procedure TAcceleratorMakerEditorForm.FormActivate(Sender: TObject);
  begin
  {if FilterListBox.Items.Count > 0 then
    InitComponents;}
  end;



procedure TAcceleratorMakerEditorForm.CopyMessage;
  const
    CopyMSG = '%s component.'#13#13+
    'Captions editor/optimizer.'#13#13+
    'Version 01.03/Freeware'#13#13+
    '%s';

  function CM: String;
    const CopyYear = 1999;
    var
      Present: TDateTime;
      Year,Month,Day: Word;
      s: String;
    begin
    Present:=Now;
    DecodeDate(Present,Year,Month,Day);
    Result:=IntToStr(CopyYear);
    if Year > CopyYear then
      Result:=Result+', '+IntToStr(Year);
    s:=
'Copyright (c) %s'#13+
'Riccardo Novello/a bit of taste'#13+
'e-mail: novello.r@libero.it';
    Result:=Format(s,[Result])
    end;
  begin
  MessageDlg(Format(CopyMSG,[fAcceleratorMaker.ClassName,CM]),
      mtInformation,[mbOk],0);
  end;

function TAcceleratorMakerEditor.GetVerbCount: Integer;
  begin
  Result:=2;
  end;

function TAcceleratorMakerEditor.GetVerb(Index: Integer): String;
  begin
  with TAcceleratorMakerEditor(Component) do
    case Index of
    0: Result:='&Edit...';
    1: Result:='&About...';
    end;
  end;

procedure TAcceleratorMakerEditor.ExecuteVerb(Index: Integer);
  begin
  with TAcceleratorMaker(Component) do
    if Assigned(AMEF) then
      with TAcceleratorMakerEditorForm(AMEF) do
      case Index of
    0: begin
       Show;
       BringToFront;
       end;
    1: About1Click(nil);
    end;
  end;

procedure Register;
  begin
  RegisterComponents('Samples',[TAcceleratorMaker]);
  RegisterComponentEditor(TAcceleratorMaker,TAcceleratorMakerEditor);
  end;

procedure TAcceleratorMakerEditorForm.F10KeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
    var P: TPoint;
  begin
  if Key = VK_F10 then
     if ssAlt in Shift then
       with ActiveControl do
         begin
         GetCursorPos(P);
         P:=ScreenToClient(P);
         PostMessage(Handle,WM_RBUTTONUP,0,
{$IFNDEF VER80}
           Longint(PointToSmallPoint(P)));
{$ELSE}
           Longint(P));
{$ENDIF}
       end;
  end;

procedure TAcceleratorMakerEditorForm.CaptionsUndoClick(Sender: TObject);
  begin
  CaptionsListBox.Items.Assign(SavedCaptions);
  SetCaptionsEdit;
  AdjustComponentCaptions;
  end;

procedure TAcceleratorMakerEditorForm.About1Click(Sender: TObject);
  begin
  CopyMessage;
  end;

procedure TAcceleratorMakerEditorForm.CopyCaptionsClick(Sender: TObject);
  var Memo: TMemo; i: Integer;
  begin
  Memo:=TMemo.Create(Self);
  try
    Memo.Parent:=Self;
    with CaptionsListbox do
      for i:=0 to Items.Count-1 do
        if Selected[i] then
          Memo.Lines.Add(Items.Strings[i]);
    Memo.SelectAll;
    Memo.CopyToClipboard;
  finally
    Memo.Free
    end;
  end;

procedure TAcceleratorMakerEditorForm.RefreshClick(Sender: TObject);
  begin
  InitComponents;
  end;

procedure TAcceleratorMakerEditorForm.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
  begin
  if PageControl1.ActivePage = FilterTabSheet then
    InitComponents
  else if PageControl1.ActivePage = ComponentsTabSheet then
    InitCaptions
  end;

end.

