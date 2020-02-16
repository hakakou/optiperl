{***************************************************************
 *
 * Unit Name: OptAuto_Control
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptAuto_Control;
{$I REG.INC}

interface

uses
  Sysutils, Controls, Windows, StdCtrls, ComObj, ActiveX, OptiPerl_TLB, StdVcl, ComServ, OptForm,
  PlugInFrm,ExtCtrls,hakageneral,classes,buttons,JvxCtrls, JvCombobox, JvColorCombo,
  JvEdit,jvSpin,JvToolEdit,agproputils,PlugBase,dxbar,centralImageListMdl,OptFolders,menus;

type
  TControl = class(TAutoObject, IControl)
  public                     
   Control : Controls.TControl;
   PlugIn : TBasePlugIn;
   Destructor Destroy; Override;
  private
   FClick : String;
   Procedure OnClick(sender : TObject);
  protected
   function Get_Self: Integer; safecall;
   function GetP(const Prop: WideString): OleVariant; safecall;
   procedure SetP(const Prop: WideString; Value: OleVariant); safecall;
   procedure Event(const Event, CallBack: WideString); safecall;
   function Get_Handle: Integer; safecall;
  end;

  TWindow = class(TAutoObject, IWindow)
  public
   Form : TOptiForm;
   Panel : TPanel;
   Destructor Destroy; Override;
  protected
    function Get_MainControl: OleVariant; safecall;
    procedure Show; safecall;
    function NewControl(Process: Integer; const ClassName: WideString;
      const Parent: IControl): OleVariant; safecall;
    function Get_Title: WideString; safecall;
    procedure Set_Title(const Value: WideString); safecall;
    function Get_Handle: Integer; safecall;
    function Get_Self: Integer; safecall;
    function Get_MainBarLinks: OleVariant; safecall;
    function Get_PopUpLinks: OleVariant; safecall;
    procedure Redraw; safecall;
    procedure Hide; safecall;
  end;

  TToolLinks = class(TAutoObject, IToolLinks)
  public
   ItemLinks : TdxBarItemLinks;
   Destructor Destroy; Override;
  protected
    function Get_Self: Integer; safecall;
    function Get_Count: Integer; safecall;
    procedure Add(ToolItem: OleVariant; _BGroup: WordBool); safecall;
    function Get_Items(Index: Integer): OleVariant; safecall;
    procedure AssignLinks(SourceLinks: OleVariant); safecall;
  end;

  TToolItem = class(TAutoObject, IToolItem)
  public
   Item : TdxBarItem;
   Destructor Destroy; Override;
  private
  protected
    function Get_Self: Integer; safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure Set_Image(const Value: WideString); safecall;
    function Get_Shortcut: WideString; safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Shortcut(const Value: WideString); safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_ToolLinks: OleVariant; safecall;
    procedure SetOptions(const Caption, Hint, Image, Shortcut,
      OnClick: WideString); safecall;
    function Get_OnClick: WideString; safecall;
    procedure Set_OnClick(const Value: WideString); safecall;
  end;

  TEvents = Class
  private
   FPlugIn : TBasePlugIn;
   FItem : TdxBarItem;
   FOnClick : String;
   Procedure OnClick(sender : TObject);
  public
   Constructor Create(Item : TdxBarItem; PlugIN : TBasePlugIN);
   Destructor Destroy; override;
  end;

Function GetControl(Acontrol : controls.TControl; PlugIn : TBasePlugIn) : OleVariant;
Function GetWindow(Window : TOptiForm) : OleVariant;

Function GetToolLinks(Links : TdxBarItemLinks) : OleVariant;
Function GetToolItem(Item : TdxBarItem) : OleVariant;


implementation

function TControl.Get_Self: Integer;
begin
 result:=Integer(self);
end;

function TWindow.Get_MainControl: OleVariant;
begin
 result:=GetControl(panel,nil);
end;

procedure TWindow.Hide;
begin
 Form.DockControl.RemoveFromDocking;
end;

procedure TWindow.Show;
begin
 Form.Show;
 Redraw;
end;

procedure TWindow.Redraw;
begin
 if Form is TPlugINForm then
  with Form as TPlugINForm do
  begin
   if childHandle<>0 then
   begin
    SetActiveWindow(childHandle);
    SetForegroundWindow(childHandle);
    windows.setfocus(childHandle);
    PaintChild;
   end;
   UpdateMenu;
  end;
end;


function TWindow.NewControl(Process: Integer; const ClassName: WideString;
  const Parent: IControl): OleVariant;
var
 ctr : Controls.TControl;
 cl : string;
begin
 ctr:=nil;
 cl:=lowercase(ClassName);

 if (cl='button') then
  ctr:=TButton.create(form)
 else
 if (cl='label') then
  ctr:=TLabel.create(form)
 else
 if (cl='edit') then
  ctr:=TEdit.create(form)
 else
 if (cl='panel') then
  ctr:=TPanel.create(form)
 else
 if (cl='listbox') then
  ctr:=TListbox.create(form)
 else
 if (cl='groupbox') then
  ctr:=TGroupBox.Create(form)
 else
 if (cl='spinedit') then
  ctr:=TjvSpinEdit.create(form)
 else
 if (cl='filenameedit') then
  ctr:=tjvFilenameEdit.create(form)
 else
 if (cl='directoryedit') then
  ctr:=tjvDirectoryEdit.create(form)
 else
 if (cl='checkbox') then
  ctr:=TCheckbox.Create(form)
 else
 if (cl='fontnameedit') then
  ctr:=TjvFontComboBox.Create(form)
 else
 if (cl='radiobutton') then
  ctr:=TRadioButton.Create(form)
 else
 if (cl='combobox') then
  ctr:=TComboBox.Create(form)
 ;

 if assigned(ctr) then
  ctr.Parent:=TWinControl(TControl(parent.Self).Control);

 result:=GetControl(ctr,TBasePlugIN(Process));
end;

function TControl.GetP(const Prop: WideString): OleVariant;
begin
 result:=GetProperty(control,Prop);
end;

procedure TControl.SetP(const Prop: WideString; Value: OleVariant);
begin
 SetProperty(control,Prop,value);
end;

procedure TControl.OnClick(sender: TObject);
begin
 PlugIN.RunCustom(FClick);
end;

procedure TControl.Event(const Event, CallBack: WideString);
var
 e,c :string;
begin
 if not assigned(PlugIn) then exit;
 e:=lowercase(event);
 c:=trim(callback);
 if e='onclick' then
  FCLick:=C;
 if control is TButton then
  TButton(control).onclick:=OnClick;
end;

function TControl.Get_Handle: Integer;
begin
 if control is TWinControl
  then result:=TWinControl(control).handle
  else result:=0;
end;

function TWindow.Get_Title: WideString;
begin
 result:=Form.DockControl.Caption;
end;

procedure TWindow.Set_Title(const Value: WideString);
begin
 form.DockControl.Caption:=value;
end;


/// DESTRUCTORS AND GETTERS

destructor TControl.Destroy;
begin
 Control.Tag:=0;
 Control:=nil;
 PlugIN:=nil;
 inherited;
end;

destructor TWindow.Destroy;
begin
 Form.oleobject:=nil;
 Form:=nil;
 inherited;
end;

destructor TToolLinks.Destroy;
begin
 ItemLinks.Tag:=0;
 ItemLinks:=nil;
 inherited;
end;


Function GetToolItem(Item : TdxBarItem) : OleVariant;
var
 Obj : TToolItem;
begin
 if  assigned(item) then
 begin
  Obj:=TToolItem(Item.tag);
  if Obj=nil then
  begin
   Obj:=TToolItem.Create;
   obj.Item:=item;
   Item.tag:=integer(Obj);
  end;
  result:=Obj as IDispatch;
 end;
end;


Function GetToolLinks(Links : TdxBarItemLinks) : OleVariant;
var
 Obj : TToolLinks;
begin
 if assigned(links) then
 begin
  Obj:=TToolLinks(links.tag);
  if Obj=nil then
  begin
   Obj:=TToolLinks.Create;
   obj.ItemLinks:=links;
   links.Tag:=integer(Obj);
  end;
  result:=Obj as IDispatch;
 end;
end;

Function GetControl(Acontrol : controls.TControl; PlugIn : TBasePlugIn) : OleVariant;
var
 Obj : TControl;
begin
 if assigned(Acontrol) then
 begin
  Obj:=TControl(Acontrol.tag);
  if Obj=nil then
  begin
   Obj:=TControl.Create;
   Obj.Control:=Acontrol;
   obj.PlugIN:=PlugIn;
   AControl.tag:=integer(Obj);
  end;
  result:=Obj as IDispatch;
 end;
end;

Function GetWindow(Window : TOptiForm) : OleVariant;
var
 Obj : TWindow;
begin
 if assigned(Window) then
 begin
  Obj:=Window.oleobject;
  if Obj=nil then
  begin
   Obj:=TWindow.Create;
   obj.Form:=window;
   Window.OleObject:=Obj;
   if Window is TPlugInForm then
    Obj.Panel:=TPlugInForm(Window).panel;
  end;
  result:=Obj as IDispatch;
 end;
end;

function TWindow.Get_Handle: Integer;
begin
 result:=form.Handle;
end;

function TToolLinks.Get_Self: Integer;
begin
 result:=Integer(self);
end;

function TWindow.Get_Self: Integer;
begin
 result:=Integer(self);
end;

{ TToolItem }

destructor TToolItem.Destroy;
begin
 Item.tag:=0;
 Item:=nil;
 inherited;
end;

function TToolItem.Get_Self: Integer;
begin
 result:=Integer(self);
end;

function TWindow.Get_MainBarLinks: OleVariant;
begin
 result:=GetToolLinks(form.BarMan.Bars[0].itemlinks);
end;

function TWindow.Get_PopUpLinks: OleVariant;
begin
 if form is TPlugInForm then
  result:=GetToolLinks(TPlugInForm(form).siPopUpLinks.ItemLinks);
end;

function TToolLinks.Get_Count: Integer;
begin
 result:=ItemLinks.Count;
end;


procedure TToolLinks.Add(ToolItem: OleVariant; _BGroup: WordBool);
begin
 with itemLinks.Add do
 begin
  item:=TToolItem(Integer(ToolItem.self)).Item;
  BeginGroup:=_BGroup;
 end;
end;


function TToolLinks.Get_Items(Index: Integer): OleVariant;
begin
 result:=GetToolItem({Form,}itemlinks.Items[index].Item);
end;

function TToolItem.Get_Enabled: WordBool;
begin
 result:=item.Enabled;
end;

procedure TToolItem.Set_Enabled(Value: WordBool);
begin
 item.Enabled:=value;
end;

function TToolItem.Get_Hint: WideString;
begin
 result:=item.Hint;
end;

procedure TToolItem.Set_Hint(const Value: WideString);
begin
 item.Hint:=value;
end;

function TToolItem.Get_Caption: WideString;
begin
 result:=item.Caption;
end;

procedure TToolItem.Set_Caption(const Value: WideString);
begin
 item.Caption:=value;
end;

procedure TToolItem.Set_Image(const Value: WideString);
begin
 centralimagelistmod.GetGlyph(folders.PluginFolder,Value,item.Glyph);
end;

function TToolItem.Get_Shortcut: WideString;
begin
 result:=ShortCutToText(item.ShortCut);
end;

function TToolItem.Get_Visible: WordBool;
begin
 result:=item.Visible=ivAlways;
end;

procedure TToolItem.Set_Shortcut(const Value: WideString);
begin
 item.ShortCut:=TextToShortcut(value);
end;

procedure TToolItem.Set_Visible(Value: WordBool);
begin
 if value
  then Item.Visible:=ivAlways
  else item.Visible:=ivNever;
end;

function TToolItem.Get_ToolLinks: OleVariant;
begin
 if item is TCustomdxBarSubItem then
  result:=GetToolLinks(TCustomdxBarSubItem(item).ItemLinks);
end;

procedure TToolLinks.AssignLinks(SourceLinks: OleVariant);
begin
 itemlinks.Assign(TToolLinks(Integer(sourceLinks.self)).itemlinks);
end;

procedure TToolItem.SetOptions(const Caption, Hint, Image, Shortcut,
  OnClick: WideString);
begin
 Set_Caption(caption);
 Set_Hint(hint);
 Set_Image(image);
 Set_Shortcut(shortcut);
 Set_OnClick(OnClick);
end;

function TToolItem.Get_OnClick: WideString;
begin
 result:=TEvents(item.data).FOnClick;
end;

procedure TToolItem.Set_OnClick(const Value: WideString);
begin
 TEvents(Item.Data).FOnClick:=Value;
end;


{ TEvents }

constructor TEvents.Create(Item : TdxBarItem; PlugIN: TBasePlugIN);
begin
 FItem:=Item;
 FPlugIn:=PlugIn;
 FItem.OnClick:=OnClick;
 FPlugIn.Links.Add(self);
end;

destructor TEvents.Destroy;
begin
 FItem.Free;
 inherited;
end;

procedure TEvents.OnClick(sender: TObject);
begin
 if FOnClick<>'' then
  FPlugIn.RunCustom(FOnClick);
end;

initialization
  TAutoObjectFactory.Create(ComServer, TControl, Class_Control,ciInternal);
  TAutoObjectFactory.Create(ComServer, TToolLinks, Class_ToolLinks,ciInternal);
  TAutoObjectFactory.Create(ComServer, TToolItem, Class_ToolItem,ciInternal);
  TAutoObjectFactory.Create(ComServer, TWindow, Class_Window,ciInternal);
end.