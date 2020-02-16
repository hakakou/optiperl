unit HK_replunit; //Modeless

interface
{$I dc.inc}

uses
  Forms, StdCtrls, ExtCtrls, Controls,agproputils,hakacontrols,dialogs,
  dcSystem, dcCommon, dcConsts, Consts, windows,sysutils,hyperstr,hakahyper,
  Classes,  dcString, dcedit, ComCtrls,dcMemo, ActnList,
  Menus, HakaGeneral, JvPlacemnt, Buttons;

type
  THKReplDialog = class(TForm)
    TabControl: TTabControl;
    FindBox: TGroupBox;
    LTexttFind: TLabel;
    LReplWith: TLabel;
    btnReplace: TButton;
    btnReplaceAll: TButton;
    btnClose: TButton;
    btnNext: TButton;
    SearText: TComboBox;
    ReplText: TComboBox;
    FormStorage: TjvFormStorage;
    btnToggle: TBitBtn;
    ActionList: TActionList;
    ReplaceAction: TAction;
    ReplaceAllAction: TAction;
    FindNextAction: TAction;
    CloseAction: TAction;
    OptionsGroup: TGroupBox;
    CaseSens: TCheckBox;
    WholeWord: TCheckBox;
    PromptRepl: TCheckBox;
    DirectionGroup: TGroupBox;
    dirForward: TRadioButton;
    dirBackward: TRadioButton;
    ScopeGroup: TRadioGroup;
    OriginGroup: TRadioGroup;
    PopupMenu: TPopupMenu;
    Position1Item: TMenuItem;
    Position2Item: TMenuItem;
    Position3item: TMenuItem;
    Position4item: TMenuItem;
    btnHighLight: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TabControlChange(Sender: TObject);
    procedure SearTextChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure OriginGroupClick(Sender: TObject);
    procedure ScopeGroupClick(Sender: TObject);
    procedure ReplaceActionExecute(Sender: TObject);
    procedure ReplaceAllActionExecute(Sender: TObject);
    procedure FindNextActionExecute(Sender: TObject);
    procedure CloseActionExecute(Sender: TObject);
    procedure ReplaceAllActionUpdate(Sender: TObject);
    procedure ReplaceActionUpdate(Sender: TObject);
    procedure FindNextActionUpdate(Sender: TObject);
    procedure btnHighLightClick(Sender: TObject);
    procedure PositionItemClick(Sender: TObject);
    procedure ReplTextChange(Sender: TObject);
    procedure CaseSensClick(Sender: TObject);
    procedure WholeWordClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
 private
    Memo : TCustomMemoSource;
    procedure PutOptions;
    procedure MoveDialog;
    procedure SaveOptions(AInReplace, AReplaceAll: Boolean);
    procedure MakeFirstSearch;
  end;

Procedure ExecuteFindReplace(AMemo: TCustomMemoSource; PageIndex,HelpContext : Integer);
Procedure FixDialogPos;
Procedure SetNewMemo(AMemo: TCustomMemoSource);

Type
 TCurrentOptions = Record
  SearchText,ReplText : String;
  DialogVisible : Boolean;
  CaseSensitive : Boolean;
  WholeWords : Boolean;
 end;

var
 MaxItems : integer = 15;
 OnFindClose : TNotifyEvent = nil;
 CurrentOptions : TCurrentOptions;
 OnPositionItemClick : Procedure(Sender : TObject; Const Pat : String; CaseSens : Boolean; Index : Integer) of object;

implementation

const
 ppe = 96;
{$R *.DFM}

var
 Dialog: THKReplDialog = nil;

Procedure ExecuteFindReplace(Amemo : TCustomMemoSource; PageIndex,HelpContext : Integer);
begin
 if assigned(amemo) and (pageindex=1) and (amemo.ReadOnly) then
  exit;
 if not assigned(dialog) then
  dialog:=THKReplDialog.create(application);
 dialog.HelpContext:=helpcontext;
 with dialog do
 begin
  Memo:=Amemo;
  memo.SmartSearchOptions;
  putOptions;
  TabControl.TabIndex:=pageindex;
  TabControlChange(nil);
  dialog.Show;
 end;
end;

Procedure FixDialogPos;
begin
 if assigned(dialog) then dialog.MoveDialog;
end;

Procedure SetNewMemo(AMemo: TCustomMemoSource);
begin
 if assigned(dialog) then dialog.Memo:=AMemo;
end;
{---------------------------------------------------}

Procedure THKReplDialog.PutOptions;
var
 IntSearchOptions:TSearchOptions;
begin
  IntSearchOptions:=GetSearchOptions;
  with IntSearchOptions do
  begin
    SearText.Text := TextToFind;
    ReplText.Text := ReplaceWith;
    CaseSens.Checked := CaseSensitive;
    WholeWord.Checked := WholeWordsOnly;
    PromptRepl.Checked := PromptOnReplace;
    if Direction = sdBackward then
      dirBackward.Checked := True
    else
      dirForward.Checked := True;
    if Scope = ssSelectedText then
      ScopeGroup.ItemIndex := 1
    else
      ScopeGroup.ItemIndex := 0;
    if Origin = soEntireScope then
      OriginGroup.ItemIndex := 1
    else
      OriginGroup.ItemIndex := 0;
  end;
end;

procedure THKReplDialog.SaveOptions(AInReplace, AReplaceAll: Boolean);
var
 IntSearchOptions:TSearchOptions;
begin
  IntSearchOptions:=GetSearchOptions;
  with IntSearchOptions do
  begin
    TextToFind := SearText.Text;
    if not AInREplace
     then ReplaceWith:=''
     else ReplaceWith:=ReplText.Text;

    CaseSensitive := CaseSens.Checked;
    WholeWordsOnly := WholeWord.Checked;
    RegularExpr := false;

    if AInREplace
     then PromptOnReplace := PromptRepl.Checked
     else PromptOnReplace:=false;

    if dirBackward.Checked then
      Direction := sdBackward
    else
      Direction := sdForward;
    if ScopeGroup.ItemIndex = 1 then
      Scope := ssSelectedText
    else
      Scope := ssGlobal;
    if OriginGroup.ItemIndex = 1 then
      Origin := soEntireScope
    else
      Origin := soFromCursor;
    if AInREplace
     then ReplaceAll := AReplaceAll
     else ReplaceAll:=false;
    InReplace:=AInREplace;
  end;
end;


procedure THKReplDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 Action:=caFree;
 Dialog:=nil;
 CurrentOptions.DialogVisible:=false;
 if assigned(OnFindClose) then OnFindClose(sender);
end;

procedure THKReplDialog.TabControlChange(Sender: TObject);
begin
 SetGroupVisible([LReplWith,ReplText,PromptRepl,ReplaceAction,ReplaceAllAction],
                  tabcontrol.TabIndex=1);
end;

procedure THKReplDialog.MoveDialog;
var
 tp,bp : TPoint;
 edit  : TCustomDCMemo;
 testr,r : TRect;

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
 with memo do
 begin
  if IsRectEmpty(FoundRect) then exit;
  if ActiveMemo is TCustomDCMemo
   then edit:=TCustomDCMemo(activememo)
   else exit;
  tp:=edit.TextToPixelPoint(foundrect.TopLeft);
  bp:=edit.TextToPixelPoint(foundrect.BottomRight);
  tp:=edit.ClientToScreen(tp);
  bp:=edit.clientToScreen(bp);
 end;
 r:=Rect(left,top,width+left,top+height);
 if ptInRect(r,tp) or ptInRect(r,bp) then
 begin
  testr:=r;
  testr.top:=bp.y+5;
  testr.Bottom:=testr.top+height;
  if isok then exit;

  testr:=r;
  testr.bottom:=tp.y-5;
  testr.Top:=testr.Bottom-height;
  if isok then exit;
 end;
end;

procedure THKReplDialog.MakeFirstSearch;
var
 IntSearchOPtions : TSearchOptions;
begin
 IntSearchOPtions:=GetSearchOptions;
 IntSearchOptions.FirstSearch:=true;
end;

procedure THKReplDialog.SearTextChange(Sender: TObject);
begin
 CurrentOptions.SearchText:=SearText.Text;
 MakeFirstSearch;
end;

procedure THKReplDialog.FormCreate(Sender: TObject);
begin
 borderstyle:=bsSizeable;
end;

procedure THKReplDialog.FormShow(Sender: TObject);
var d,a:integer;
begin
 CurrentOptions.DialogVisible:=true;
 CurrentOptions.SearchText:=SearText.text;
 CurrentOptions.ReplText:=ReplText.text;
 CurrentOptions.CaseSensitive:=CaseSens.Checked;
 CurrentOptions.WholeWords:=WholeWord.Checked;

 d:=Height-clientHeight;
 a:=Round(screen.PixelsPerInch*14 / ppe);

 constraints.MinHeight:=FindBox.Height+FindBox.Top+btnToggle.Height+a+d;
 constraints.MaxHeight:=constraints.MinHeight+OptionsGroup.Height+ScopeGroup.Height+6;

 d:=Width-clientWidth;
 constraints.MinWidth:=btnClose.Width+btnNext.Width+btnReplaceAll.Width+btnHighlight.Width+
                       btnReplace.Width+btnToggle.Width+d+btnToggle.Left*5;
 MoveDialog;
 SearText.SetFocus;
end;

procedure THKReplDialog.FormResize(Sender: TObject);
var
 o,d : integer;

begin
 d:=(ClientWidth - (findbox.left)*2) div 2;

 FindBox.Width:=d * 2;

 OptionsGroup.Width:=d - 5;
 ScopeGroup.Width:=d - 6;

 o:=FindBox.width-d*2;

 OriginGroup.Width:=d - 5 + o;
 DirectionGroup.Width:=d - 5 + o;

 d:=findbox.Width+findbox.Left;
 d:=d-DirectionGroup.Width;
 DirectionGroup.Left:=d;
 OriginGroup.Left:=DirectionGroup.Left;


 ScopeGroup.Visible:=btnReplace.top>ScopeGroup.top+ScopeGroup.Height;
 OriginGroup.visible:=ScopeGroup.Visible;
 OptionsGroup.Visible:=btnReplace.top>OptionsGroup.top+OptionsGroup.Height;
 DirectionGroup.visible:=OptionsGroup.Visible;
end;

procedure THKReplDialog.btnToggleClick(Sender: TObject);
begin
 if ScopeGroup.Visible
  then height:=constraints.MinHeight
  else height:=constraints.MaxHeight;

 ScopeGroup.Visible:=btnReplace.top>ScopeGroup.top+ScopeGroup.Height;
 OriginGroup.visible:=ScopeGroup.Visible;
 OptionsGroup.Visible:=btnReplace.top>OptionsGroup.top+OptionsGroup.Height;
 DirectionGroup.visible:=OptionsGroup.Visible;
end;

procedure THKReplDialog.OriginGroupClick(Sender: TObject);
var
 IntSearchOPtions : TSearchOptions;
begin
 IntSearchOPtions:=GetSearchOptions;
 IntSearchOptions.FirstSearch:=true;
end;

procedure THKReplDialog.ScopeGroupClick(Sender: TObject);
begin
 MakeFirstSearch;
end;

procedure THKReplDialog.ReplaceActionExecute(Sender: TObject);
var
 p : integer;
begin
 HandleComboBoxText(SearText,MaxItems);
 HandleComboBoxText(ReplText,MaxItems);
 SaveOptions(true,false);
 if assigned(memo) then
 begin
  p:=memo.FoundRect.Right-memo.FoundRect.left;
  if p<0 then p:=0;
  memo.Replace(p);
  SaveOptions(false,false);
  memo.FindNext(false);
 end;
 MoveDialog;
end;

procedure THKReplDialog.ReplaceAllActionExecute(Sender: TObject);
var
 org : TPoint;
begin
 HandleComboBoxText(SearText,MaxItems);
 HandleComboBoxText(ReplText,MaxItems);
 SaveOptions(true,true);
 if assigned(memo) then
 begin
  org:=memo.CaretPoint;
  if ScopeGroup.ItemIndex=0 then
   memo.CaretPoint:=memo.FoundRect.TopLeft;
  memo.Replace(0);
  if (memo.ReplacedCount>0) then
  begin
   MessageDlg('Search completed. '+inttostr(memo.ReplacedCount)+
    ' replacement(s) made.', mtInformation, [mbOK], 0);
   memo.CaretPoint:=org;
  end;
 end;
 MoveDialog;
 MakeFirstSearch;
end;

procedure THKReplDialog.FindNextActionExecute(Sender: TObject);
var
 res : boolean;
begin
 HandleComboBoxText(SearText,MaxItems);
 HandleComboBoxText(ReplText,MaxItems);
 SaveOptions(false,false);
 if assigned(memo) then
 begin
  memo.SearchOptions.DidShowNotFound:=false;
  res:=memo.FindNext;
  if (not res) and (not memo.SearchOptions.DidShowNotFound) then
   memo.find;
 end;
 MoveDialog;
end;

procedure THKReplDialog.CloseActionExecute(Sender: TObject);
begin
 SaveOptions(false,false);
 Close;
end;

procedure THKReplDialog.ReplaceAllActionUpdate(Sender: TObject);
begin
 ReplaceAllAction.Enabled:=(Assigned(memo)) and (not memo.ReadOnly) and
                           (SearText.Text<>'');
end;

procedure THKReplDialog.ReplaceActionUpdate(Sender: TObject);
begin
 ReplaceAction.Enabled:=(assigned(memo)) and (not IsRectEmpty(memo.FoundRect)) and
                        (not memo.ReadOnly);
end;

procedure THKReplDialog.FindNextActionUpdate(Sender: TObject);
begin
 FindNextAction.Enabled:=(SearText.Text<>'') and (assigned(memo));
end;


procedure THKReplDialog.btnHighLightClick(Sender: TObject);
var pt : TPoint;
begin
 pt.X:=0;
 pt.Y:=btnHighLight.height;
 pt:=btnHighLight.ClientToScreen(pt);
 popupMenu.Popup(pt.X,pt.Y);
end;

procedure THKReplDialog.PositionItemClick(Sender: TObject);
var s:string;
begin
 s:=SimpleToRegExpPattern(SearText.Text,WholeWord.Checked);
 if assigned(OnPositionItemClick) then
  OnPositionItemClick(self,s,CaseSens.Checked,TMenuItem(sender).Tag);
end;

procedure THKReplDialog.ReplTextChange(Sender: TObject);
begin
 CurrentOptions.ReplText:=ReplText.Text;
end;

procedure THKReplDialog.CaseSensClick(Sender: TObject);
begin
 CurrentOptions.CaseSensitive:=CaseSens.Checked;
end;

procedure THKReplDialog.WholeWordClick(Sender: TObject);
begin
 CurrentOptions.WholeWords:=WholeWord.Checked;
end;

end.
