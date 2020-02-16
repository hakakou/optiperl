unit janEditListBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TjanEditListBox = class;

  TImgBox=class (TCustomControl)
  private
    FText: string;
    FColor:TColor;
    procedure SetText(const Value: string);
  public
    procedure Paint; override;
  published
    property Text:string read FText write SetText;
  end;

  TjanListBoxEdit = class(TEdit)
  private
    { Private declarations }
    FListbox:TjanEditListBox;
  protected
    { Protected declarations }
    procedure KeyPress(var Key: Char); override;
  public
    { Public declarations }
  published
    { Published declarations }
  end;


  TjanEditListBox = class(TListbox)
  private
    { Private declarations }
    FDownIndex:integer;
    IsDrag:boolean;
    IsDown:boolean;
    FInplaceEdit:TjanListBoxEdit;
    FAutoFileName: string;
    FDragimg:TImgBox;
    procedure SetAutoFileName(const Value: string);
    procedure AutoSave;
    procedure initDragList(s: string);
    procedure SetDragColor(const Value: TColor);
    function  GetDragColor:TColor;
  protected
    { Protected declarations }
    procedure Click;override;
    procedure dblClick;override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer);override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
//    procedure DragOver(Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean); override;
    procedure Loaded; override;
    procedure WMDestroy(var msg:TWMDestroy); message WM_Destroy;
  public
    { Public declarations }
    constructor create(AOwner:Tcomponent);override;
    destructor  destroy; override;
//    procedure DragDrop(Source: TObject; X, Y: Integer); override;

  published
    { Published declarations }
    property AutoFileName:string read FAutoFileName write SetAutoFileName;
    property DragColor:TColor read GetDragColor write SetDragColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Jans 2', [TjanEditListBox]);
end;

{ TjanEditListBox }

constructor TjanEditListBox.create(AOwner: Tcomponent);
begin
  inherited;
  FInplaceEdit:=TjanListBoxEdit.create(self);
  FInplaceEdit.parent:=self;
  FInplaceEdit.hide;
  FInplaceEdit.FListbox:=self;
  FInplaceEdit.Ctl3D:=false;
  FInplaceEdit.BorderStyle :=bsnone;
  FDragImg:=Timgbox.Create(self);
  FDragImg.parent:=self;
  FDragImg.Fcolor:=clyellow;
  isDrag:=false;
  isDown:=false;
end;

destructor TjanEditListBox.destroy;
begin
  FInplaceEdit.free;
  inherited;
end;

procedure TjanEditListBox.AutoSave;
var appldir:string;
begin
  appldir:=extractfilepath(application.exename);
   if FAutoFileName<>'' then
     items.SaveToFile (appldir+FAutoFilename);
end;

procedure TjanEditListBox.KeyPress(var Key: Char);
begin
  if key=' ' then
    if itemindex<>-1 then
    begin
      FinplaceEdit.BoundsRect :=itemrect(itemindex);
      FinplaceEdit.Text :=items[itemindex];
      FInplaceEdit.Font.Assign (self.font);
      FinplaceEdit.show;
      FinplaceEdit.BringToFront;
      FInplaceEdit.SetFocus;
      FinplaceEdit.SetSelLength(length(FinplaceEdit.text));
    end
    else
      key:=#0;
  inherited;
end;

procedure TjanEditListBox.KeyUp(var Key: Word; Shift: TShiftState);
var index:integer;
begin
  if key=vk_ADD  then
  begin
    itemindex:=items.add('new');
  end
  else if ssctrl in shift then
  begin
    if key=vk_insert then
    begin
      index:=itemindex;
      if index=-1 then
      begin
        if items.count=0 then
          itemindex:=items.add('new');
      end
      else
      begin
       items.Insert (index,'new');
       itemindex:=index;
      end;
    end
    else if key=vk_delete then
    begin
      index:=itemindex;
      if index<>-1 then
      begin
       items.Delete (index);
       if items.count<>0 then
       if index>=items.count then
         itemindex:=items.count-1
       else
          itemindex:=index;
      end;
    end;
  end;

  inherited;

end;

procedure TjanEditListBox.Loaded;
var appldir:string;
begin
  appldir:=extractfilepath(application.exename);
   if FAutoFileName<>'' then
     if fileexists(appldir+FAutoFilename) then
       items.LoadFromFile (appldir+FAutoFilename);
  inherited;

end;

procedure TjanEditListBox.SetAutoFileName(const Value: string);
begin
  FAutoFileName := Value;
end;


procedure TjanEditListBox.WMDestroy(var msg: TWMDestroy);
begin
 AutoSave;
end;






procedure TjanEditListBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var index:integer;
    s:string;
    pt:Tpoint;
begin
  IsDown:=true;
  IsDrag:=ssCtrl in shift;
  FDownindex:=ItemIndex;
  if isDrag then
  begin
    initDragList(items[FDownIndex]);
    FDragImg.left:=x;
    FDragImg.top:=y;
    FDragImg.BringToFront;
    FDragImg.Visible:=true;
  end;
  if assigned(onmousedown) then
    onmousedown(self,button,shift,x,y);
end;

procedure TjanEditListBox.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Isdrag then
  begin
   FDragImg.left:=x;
   FDragImg.top:=y;
   FDragImg.invalidate;
  end;
  if assigned(onmousemove) then
    onmousemove(self,shift,x,y);
end;

procedure TjanEditListBox.initDragList(s:string);
var index:integer;
    ASize:Tsize;
begin
  index:=itemindex;
  Asize:=FDragImg.canvas.TextExtent (s);
  FDragImg.width:=Asize.cx+2;
  FDragImg.height:=ASize.cy+2;
  FDragImg.Text:=s;
  FDragImg.canvas.TextOut(1,1,s);
end;



procedure TjanEditListBox.SetDragColor(const Value: TColor);
begin
  FDragImg.FColor := Value;
end;

function TjanEditListBox.GetDragColor: TColor;
begin
  result:=FDragImg.FColor;
end;



procedure TjanEditListBox.Click;
var index1,index2:integer;
begin
  inherited;
 if isDrag then
  begin
    index1:=FDownIndex;
    index2:=ItemIndex;
    if (index1<>-1) and (index2<>-1) then
      items.Move (index1,index2);
    ItemIndex:=index2;
  end;
   isDrag:=false;
   isDown:=false;
   FDragImg.visible:=false;
  if assigned(onClick) then
    onClick(self);
end;


procedure TjanEditListBox.dblClick;
begin
  FDragImg.visible:=false;
  isDrag:=false;
  isDown:=false;
  if assigned(onDblClick) then
    onDblClick(self);
end;

{ TjanListBoxEdit }

procedure TjanListBoxEdit.KeyPress(var Key: Char);
var index:integer;
begin
  if key=char(vk_return) then
  begin
    key:=#0;
    index:=FListbox.ItemIndex;
    FListbox.Items[index]:=text;
    hide;
    FListbox.SetFocus;
  end
  else if key=char(vk_escape) then
  begin
    hide;
    FListbox.SetFocus;
  end;
  inherited;
end;




{ TImgBox }

procedure TImgBox.Paint;
begin
  inherited;
  canvas.Brush.Color:=FColor;
  canvas.FillRect (Rect(0,0,width,height));
  canvas.brush.style:=bsclear;
  canvas.TextOut(1,1,FText);
end;


procedure TImgBox.SetText(const Value: string);
begin
  FText := Value;
end;

end.
