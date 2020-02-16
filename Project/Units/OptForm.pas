{***************************************************************
 *
 * Unit Name: OptForm
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptForm;
{$I REG.INC}

interface
uses
  Windows, Classes, Forms, Controls, messages, sysutils, Graphics, ExtCtrls, HKDebug,
  aqDockingBase, aqDocking, aqDockingUtils, aqDockingUI,dialogs,dxBar,inifiles,
  HyperStr,Hakageneral,OptProcs, OptGeneral;

type
  TStanDockers = (doNone,doEditor,doWebbrowser,doCodeExplorer);
  TRegionType = (drtLeft, drtTop, drtRight, drtBottom, drtInside, drtNone);
  TDockingControl = aqDockingBase.TaqCustomDockingControl;

  TOptiForm = class(TForm)
  private
   FirstShownDone : Boolean;
   FName : String;
   FOverrideFloat : Boolean;
   Popup : TDxBarPopupMenu;
   Procedure DoTheCreate(Const AName : String);
   procedure LoadIniFile;
   procedure SaveIniFile;
   procedure DoStanDock;
   Function FindSpecialDock(index : Integer) : TaqCustomDockingControl;
   procedure SetSplitters(Par : TWinControl);
   procedure SplitterMoved(Sender: TObject);
   procedure SplitterPaint(Sender: TObject);
   procedure SetLinkBar;
  protected
   Procedure FirstShow(Sender: TObject); Virtual;
   Procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; Var Pix,Index : Integer); virtual;
   Procedure AfterContainerShow(Sender: TObject); Virtual;
   Function ShowButton : Boolean; Virtual;
   Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); Virtual;
   Procedure SetConstraints(AMinWidth,AMinHeight : Integer);
   procedure CMVisibleChanged(var Message: TMessage); message CM_VISIBLECHANGED;
  public
   OleObject : Pointer;
   BarMan : TDxBarManager;
   OrgBar,LinkBar : TDxBar;
   DockControl : TaqDockingControl;
   ShowMenuWhenDocked : Boolean;
   LinksAtEnd : Boolean;
   procedure Show;
   procedure ShowIfVisible;
   procedure Close;
   constructor Create(AOwner: TComponent); override;
   constructor CreateNamed(AOwner: TComponent; Const AName : String);
   Constructor CreateNormal(AOwner: TComponent);
   Destructor Destroy; Override;
   procedure UpdateMenu;
   Procedure FocusControl(Control : TWinControl);
   procedure AddLinkBarLinks;
   Function ButtonClick : Boolean;
   Function HasContextMenu : Boolean;
   Procedure SetCaption(const Text : String);
   Procedure CloseEnabled(Enabled : Boolean);
  Published
  end;


const
  inNone = -1; InTools = 0; InExplorers = 1; InDebugs = 2; InLogs = 3;

var
 DockingManager : TAqDockingManager;
 BarManager : TDXBarManager;
 IniFileName : String = '';
 BarWinList : TList;
 StanDocks : Array[TStanDockers] of TaqDockingControl;

implementation

const
 BoolStr : array[boolean] of char = ('0','1');
 WinSectionStr = 'WindowState';

 { TOptiForm }

Procedure TOptiForm.LoadIniFile;
var
 inifile : Tinifile;
 s:string;
 i:integer;
begin
 if (inifilename='') or (csDesigning in ComponentState) then exit;
 IniFile:=TIniFile.Create(inifilename);
 try
  s:=inifile.ReadString(WinSectionStr,name,'');
  if length(s)>=1 then
  begin
   ShowMenuWhenDocked:=s[1]='1';
   delete(s,1,1);
  end;

  if length(s)>=1 then
  begin
   FOverrideFloat:=s[1]='1';
   delete(s,1,1);
  end;

  if assigned(barman) then
  begin
   i:=0;
   while (length(s)>=2) and (barman.Bars.Count>i) do
   begin
    BarMan.Bars[i].DockingStyle:=TdxBarDockingStyle(StrToIntDef(s[1],2));
    BarMan.Bars[i].Visible:=Str2Bool(s[2]);
    delete(s,1,2);
    inc(i);
   end;
  end;
 finally
  inifile.free;
 end;
end;

Procedure TOptiForm.SaveIniFile;
var
 inifile : Tinifile;
 c:String;
 i : integer;
begin
 if (inifilename='') or (csDesigning in ComponentState) then exit;
 IniFile:=TIniFile.Create(inifilename);
 try
  c:=boolstr[ShowMenuWhenDocked];
  c:=c+bool2Str(FOverrideFloat);
  if assigned(barman) then
   for i:=0 to barman.Bars.Count-1 do
   begin
    c:=c+IntToStr(integer(BarMan.Bars[i].DockingStyle));
    c:=c+Bool2Str(BarMan.Bars[i].Visible);
   end;
  inifile.WriteString(WinSectionStr,name,c);
 finally
  inifile.free;
 end;
end;

Procedure TOptiForm.AddLinkBarLinks;
var
 i,j:integer;
 list : TList;
 found : boolean;
begin
 if assigned(LinkBar) then
 begin
  List:=TList.create;
  for i:=0 to LinkBar.ItemLinks.Count-1 do
  begin
   found:=false;
   for j:=0 to popup.ItemLinks.Count-1 do
    if linkbar.ItemLinks.Items[i].Item.name=popup.ItemLinks.Items[j].Item.name then
    begin
     found:=true;
     break;
    end;
   if not found then
    list.Add(linkbar.ItemLinks.Items[i].Item);
  end;

  for i:=0 to list.Count-1 do
    with popup.ItemLinks.Add do
    begin
     item:=list[i];
     if not LinksAtEnd
      then
       index:=i
      else
       if i=0 then begingroup:=true;
    end;

  if (not LinksAtEnd) and (popup.ItemLinks.Count>linkbar.ItemLinks.Count) then
   popup.ItemLinks.Items[list.Count].BeginGroup:=true;

  list.free;
 end;
end;

function TOptiForm.HasContextMenu: Boolean;
begin
 result:=assigned(popup);
end;

Function TOptiForm.ButtonClick : Boolean;
begin
 if assigned(popup) then
  begin
   GetpopUpLinks(popup,BarManager);
   if popup.Tag<>1000 then
    AddLinkBarLinks;
   result:=Popup.ItemLinks.Count>0;
   if result then
    popup.PopupFromCursorPos;
  end
 else
  result:=false;
end;

function TOptiForm.ShowButton: Boolean;
var
 i : Integer;
begin
 for i:=0 to ComponentCOunt-1 do
  if components[i] is TDxBarManager then
  begin
   BarMan:=TdxBarManager(Components[i]);
   break;
  end;
 result:=assigned(Barman);
 if assigned(Barman) then
 begin
  popup:=TDxBarPopupMenu.Create(self);
  popup.BarManager:=barman;
  BarMan.NotDocking:=[dsNone];
  BarMan.AlwaysSaveText:=false;
  BarMan.CanCustomize:=false;
  BarMan.Style:=barmanager.Style;
  BarMan.ShowShortCutInHint:=barmanager.ShowShortCutInHint;
  Barman.AllowCallFromAnotherForm:=false;
  BarMan.Font:=BarManager.Font;
  BarMan.AutoHideEmptyBars:=true;

  for i:=0 to barman.Bars.Count-1 do
  begin
   BarMan.Bars[i].UseRestSpace:=true;
   BarMan.Bars[i].WholeRow:=false;
   BarMan.Bars[i].ShowMark:=false;
   BarMan.Bars[i].Hidden:=true;
  end;
 end;
end;

Procedure TOptiForm.GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager);
begin
end;

Procedure TOptiForm.SetLinkBar;
begin
 if not assigned(BarMan) then exit;
 Orgbar:=barmanager.BarByName(Fname);
 if assigned(OrgBar) and (OrgBar.Hidden) then
 begin
  if not assigned(linkbar) then
   LinkBar:=barman.Bars.Add;
  LinkBar.Caption:=FName;
  LinkBar.ItemLinks:=OrgBar.ItemLinks;
  OrgBar.Visible:=false;
  Linkbar.DockingStyle:=dsTop;
  LinkBar.ShowMark:=false;
  LinkBar.UseRestSpace:=true;
  LinkBar.WholeRow:=false;
  Linkbar.Visible:=true;
  LinkBar.Hidden:=true;
  BarWinList.Add(self);
 end;
end;

Procedure TOptiForm.DoTheCreate(Const AName : String);
var
 i:integer;
 s:string;
 Dumb1 :  TaqCustomDockingControl;
 Dumb2 : TRegionType;
 Dumb3 : Integer;
 DumbForm : TForm;
begin
 if length(AName)>0 then
  Name:=Aname;

 BorderStyle:=bsNone;  /////////////////////////////
 s:='dc'+name;
 for i:=0 to DockingManager.Items.count-1 do
  if DockingManager.Items[i].Name=s then
  begin
   DockControl:=TaqDockingControl(DockingManager.Items[i]);
   break;
  end;
 Assert(assigned(dockControl),'No dockcontrol for: '+name);
 //Needed to know whether this control will have a special dock

 SetDockPosition(Dumb2,Dumb1,Dumb3,i);
 if I>=0 then
  try
   DockControl.HelpKeyword:=inttostr(i);
  except end;
 parent:=DockControl; /////////////////////////////
 FormStyle:=fsNormal;
 DragKind:=dkDrag;
 DragMode:=dmManual;
 visible:=true;

 try
  dockcontrol.HelpContext:=helpcontext;
 except end;
 Assert(helpcontext<>0,'No help context for '+name);

 FName:=dockControl.Name;
 delete(Fname,1,2);
 DockControl.Caption := Caption;
 DockControl.PreferredWidth := Width;
 DockControl.PreferredHeight := Height;

 align:=alClient;
 DockControl.Tag:=integer(self);
 SetConstraints(Constraints.MinWidth,Constraints.MinHeight);
 Constraints.MinHeight:=0;
 Constraints.MaxHeight:=0;
 Constraints.MinWidth:=0;
 Constraints.MaxHeight:=0;
 dockcontrol.Buttons[dbkCustom].Enabled:=ShowButton;

 SetLinkBar;
 LoadIniFile;
 assert(false,'LOG OptiForm create: '+Name);
end;

constructor TOptiForm.CreateNamed(AOwner: TComponent; const AName: String);
begin
 ShowMenuWhenDocked:=true;
 inherited create(AOwner);
 DoTheCreate(AName);
end;

constructor TOptiForm.Create(AOwner: TComponent);
begin
 ShowMenuWhenDocked:=true;
 inherited create(AOwner);
 DoTheCreate('');
end;

constructor TOptiForm.CreateNormal(AOwner: TComponent);
begin
 inherited create(AOwner);
end;

procedure TOptiForm.SplitterMoved(Sender: TObject);
var sp : TSplitter absolute sender;
begin
 SetConstraints(sp.Left+OptiMinSplitterAdd,0);
 //only for left-right splitters
end;

procedure TOptiForm.SplitterPaint(Sender: TObject);
begin
 PR_DrawSplitter(sender);
end;

procedure TOptiForm.SetSplitters(Par : TWinControl);
var
 i:integer;
 c : TControl;
begin
  for i:=0 to par.controlcount-1 do
  begin
   c:=par.Controls[i];
   if c is TSplitter then
   begin
    with c as TSplitter do
     if visible then
     begin
      if align in [alLeft,alRight]
       then width:=OptiSplitterWidth-1;
      if align in [altop,albottom]
       then height:=OPtiSplitterWidth-1;
      OnPaint:=SplitterPaint;
      if not assigned(onmoved) then
       OnMoved:=SplitterMoved;
      SplitterMoved(controls[i]);
     end
   end

   else
   if (c is TWinControl) and
      (TWinControl(c).ControlCount>0) then
    SetSplitters(TWinControl(c));
  end;
end;

procedure TOptiForm.UpdateMenu;
var
 i:integer;
 Doshow : Boolean;
begin
 if not assigned(BarMan) then exit;
 Doshow:=(DockControl.dockstate=dcsFloating) or ShowMenuWhenDocked;
 for i:=0 to barman.bars.Count-1 do
  BarMan.bars[i].Visible:=DoShow and (BarMan.bars[i].ItemLinks.Count>0);
end;

destructor TOptiForm.Destroy;
var i:integer;
begin
 if assigned(DockControl) then
 begin
  DockControl.Tag:=0;
  DockControl.HelpKeyword:='';
  SaveIniFile;
 end;
 i:=BarWinList.IndexOf(self);
 if i>=0 then
  BarWinList.Delete(i);
 assert(false,'LOG OptiForm Destroy: '+Name);
 inherited;
end;

procedure TOptiForm.Close;
var
 AAction: TCloseAction;
begin
 if assigned(DockControl) then
  begin
   FOverrideFloat:=dockcontrol.DockState=dcsFloating;
   DockControl.HelpKeyword:='';
   AAction:=caNone;
   if assigned(OnClose) then
    OnClose(nil,Aaction);
   if Aaction=caFree then
    free;
  end
 else
  inherited Close;
end;

procedure TOptiForm.CMVisibleChanged(var Message: TMessage);
begin
 inherited;
 if (not FirstShownDone) and boolean(message.WParam) then
 begin
  FirstShownDone:=true;
  SetSplitters(self);
  FirstShow(self);
 end;
end;

procedure TOptiForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; Var Pix,Index : Integer);
begin
 Alignment:=drtNone;
 Form:=nil;
 Pix:=0;
 Index:=InNone;
end;

procedure TOptiForm.DoStanDock;
var
 Docker : TaqDocker;
 DefDockAlignment : TRegionType;
 DefDockForm :  TaqCustomDockingControl;
 DefSpecialForm : TaqCustomDockingControl;
 p,SpecialDockIndex : Integer;
begin
 SetDockPosition(DefDockAlignment,DefDockForm,p,SpecialDockIndex);
 if SpecialDockIndex>=0 then
 begin
  DefSpecialForm:=FindSpecialDock(SpecialDockIndex);
  if assigned(DefSpecialForm) then
  begin
   DefDockForm:=DefSpecialForm;
   DefDockAlignment:=drtInside;
  end;
 end;
 if (DefDockForm=nil) or (FOverrideFloat) then exit;
 if (DefDockForm.DockState=dcsHidden) then exit;
 if DockControl.DockState<>dcsHidden then exit;
 if (DefDockForm.Height<50) or (DefDockForm.width<50) then exit;
 Docker := TaqDocker(DockingManager.Docker[DefDockForm.DockClass]);
 Docker.ManagedItem := DefDockForm;
 Docker.RIncr:=p;
 DockingManager.OnDoDock(nil,true);
 try
  Docker.DockItem2(TaqDockingRegionType(DefDockAlignment), DockControl);
 finally
  DockingManager.OnDoDock(nil,false);
 end;
end;

procedure TOptiForm.Show;
begin
 if assigned(DockControl) then
  begin
   try
    DoStanDock;
   except end; 
   dockcontrol.ForceVisible;
   AfterContainerShow(self);
  end
 else
  inherited Show;
end;

procedure TOptiForm.ShowIfVisible;
begin
 if assigned(DockControl) then
 begin
  if dockcontrol.DockState<>dcsHidden then
   Show;
 end;
end;


procedure TOptiForm.FirstShow(Sender: TObject);
begin
end;

procedure TOptiForm.AfterContainerShow(Sender: TObject);
begin
end;

procedure TOptiForm.SetCaption(const Text: String);
begin
 if assigned(dockcontrol)
  then DockControl.Caption:=text
  else caption:=text;
end;

procedure TOptiForm.SetConstraints(AMinWidth, AMinHeight: Integer);
begin
 if assigned(DockControl) then
  begin
   DockControl.MinWidth:=AMinWidth;
   DockControl.MinHeight:=AMinHeight;
  end
 else
  begin
   constraints.MinWidth:=AMinWidth;
   constraints.MinHeight:=AMinHeight;
  end;
end;

procedure TOptiForm.FocusControl(Control: TWinControl);
begin
 if (not assigned(control)) or (not Control.Enabled) then exit;
 if assigned(DockControl) then
  begin
   if (dockControl.DockState<>dcsHidden) and
      (visible) and (dockcontrol.Visible) then
    Control.SetFocus
  end
 else
  control.SetFocus;
end;

function TOptiForm.FindSpecialDock(index: Integer): TaqCustomDockingControl;
var
 i:integer;
 s:string;
begin
 s:=inttostr(index);
 for i:=0 to dockingmanager.Items.Count-1 do
  if (dockingmanager.Items[i]<>DockControl) and
     (dockingmanager.Items[i].HelpKeyword=s) then
   begin
    result:=dockingmanager.Items[i];
    exit;
   end;
 result:=nil;
end;

procedure TOptiForm.CloseEnabled(Enabled: Boolean);
var
 CustomAction: TaqCustomDockAction;
begin
 if assigned(DockControl) then
 begin
  CustomAction := DockControl.Actions[idactHide];
  CustomAction.Enabled:=enabled;
 end;
end;

initialization
 BarWinList:=TList.Create;
finalization
 BarWinList.free;
end.