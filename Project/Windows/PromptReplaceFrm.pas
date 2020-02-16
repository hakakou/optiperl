unit PromptReplaceFrm; //Modal

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, dcMemo;

type
  TPromptReplaceForm = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    Edit : TDCMemo;
    procedure MoveDialog;
    { Private declarations }
  public
    { Public declarations }
  end;

Function ExecuteReplaceDialog(memo : TDCMemo) : Integer;

implementation
var
 lp : TPoint;

{$R *.dfm}
Function ExecuteReplaceDialog(memo : TDCMemo) : Integer;
var
 f : TPromptReplaceForm;
begin
 F:=TPromptReplaceForm.create(Application);
 try
  f.Edit:=memo;
  result:=f.showmodal;
  lp.X:=f.Left;
  lp.Y:=f.top;
 finally
  f.free;
 end;
end;

procedure TPromptReplaceForm.MoveDialog;
var
 tp,bp : TPoint;
 FoundRect,testr,r : TRect;


 function isok : boolean;
 begin
  result:=(not ptInRect(testr,tp)) and (not ptInRect(testr,bp)) and
          (testr.Top>=0) and (testr.Bottom<=screen.Height);
  if result then begin
   top:=testr.Top;
   left:=testr.Left;
  end;
 end;

begin
 foundrect:=edit.MemoSource.SelectionRect;
// if IsRectEmpty(FoundRect) then exit;
 tp:=edit.TextToPixelPoint(foundrect.TopLeft);
 bp:=edit.TextToPixelPoint(foundrect.BottomRight);
 tp:=edit.ClientToScreen(tp);
 bp:=edit.clientToScreen(bp);

 r:=Rect(left,top,width+left,top+height);
 if ptInRect(r,tp) or ptInRect(r,bp) then
 begin
  testr:=r;
  testr.top:=bp.y+25;
  testr.Bottom:=testr.top+height;
  if isok then exit;

  testr:=r;
  testr.bottom:=tp.y-25;
  testr.Top:=testr.Bottom-height;
  if isok then exit;
 end;
end;

procedure TPromptReplaceForm.FormShow(Sender: TObject);
begin
 Left:=lp.X;
 Top:=lp.Y;
 MoveDialog;
end;

procedure TPromptReplaceForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case key of
  vk_up : edit.ScrollUp;
  vk_Down : edit.ScrollDown;
  vk_left : edit.ScrollLeft;
  vk_Right : edit.ScrollRight;
  VK_Prior : Edit.ScrollPageUp;
  VK_Next : Edit.ScrollPageDown;
 end;
end;

initialization
 lp.X:=screen.Width div 2 - 100;
 lp.Y:=screen.Height div 2 - 50;
end.