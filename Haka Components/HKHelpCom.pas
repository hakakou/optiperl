unit HKHelpCom;

{
----------------------------------------------------------------
THKHelp v1.1 by Harry Kakoulidis 1/2000
kcm@mailbox.gr
http://kakoulidis.homepage.com

This is Freeware. Please copy HKHelp11.zip unchanged.
If you find bugs, have options etc. Please send at my e-mail.

The use of this component is at your own risk.
I do not take any responsibility for any damages.

Note: If you use this I would really like to be mentioned somewhere!
However thats not necessary. At least send me a copy of your program.

Please Read ReadMe.txt for more info.

----------------------------------------------------------------
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdctrls,clipbrd,richedit,comctrls,buttons, ExtCtrls,Dsgnintf, RxRichEd;


type
  THKHelp = class;
  THelpEvent = Procedure(Control : TControl) of object;

  THelpItem = class(TCollectionItem)
  private
   FOldWndMethod : TWndMethod;
   FControl : TControl;
   FBorderColor,FBackColor : TColor;
   FWidth,FHeight,FBorderWidth : Integer;
   FPaste : Boolean;
   FRTF : String;
   FTest : Boolean;
   Procedure SetControl(value : TControl);
   Procedure SubClassWndProc(var Message: TMessage);
   Procedure SetPaste(Value : Boolean);
   Procedure OpenHelp;
   Procedure SetTest(b : boolean);
  Public
   Constructor Create(Collection : TCollection); override;
   Procedure Assign(Source : TPersistent); override;
   Destructor Destroy; override;
  Published
   property Control : TControl read FControl write SetControl;
   Property BackColor : TColor read FBackColor write FBackColor;
   Property BorderColor : TColor read FBorderColor write FBorderColor;
   Property BorderWidth : Integer read FBorderWidth write FBorderWidth;
   Property Paste : Boolean read FPaste write SetPaste stored False;
   Property RTF : String read FRTF write FRTF;
   Property Width : Integer read FWidth write FWidth;
   Property Height : Integer read FHeight write FHeight;
   Property Test : Boolean read FTest write SetTest stored false;
  end;

  THelpCol = class(TCollection)
  private
   FHKHelp : THKHelp;
   Function GetItem(index : integer): THelpItem;
   Procedure SetItem(index : integer; Value: THelpItem);
  protected
   function GetOwner: TPersistent; override;
   procedure Update(item : TCollectionItem); override;
  public
   Constructor Create(HKHelp : THKHelp);
   Function Add : THelpItem;
   Property Items[Index : Integer]: THelpItem read GetItem write SetItem; default;
  end;

  THKHelp = class(TComponent)
  Private
   FHelpCol: THelpCol;
   FHelpMode,FEnabled : Boolean;
   FHelpOpen,FHelpClose : THelpEvent;
   Procedure SetHelpCol(value : THelpCol);
   Procedure SetHelpMode(mode : Boolean);
  Public
   constructor Create(AOwner : TComponent); override;
   Destructor Destroy; override;
  Published
   property HelpWindows : THelpCol read FHelpCol Write SetHelpCol;
   Property HelpMode : Boolean read FHelpMode write SetHelpMode stored false;
   property OnHelpOpen : THelpEvent read FHelpOpen write FHelpOpen;
   property OnHelpClose : THelpEvent read FHelpClose write FHelpClose;
   Property Enabled : Boolean read FEnabled write FEnabled;
  end;


  THelpWin = class(TForm)
    Panel: TPanel;
    RichEdit: TRxRichEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RichEditMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
   Public
    FHelpOpen,FHelpClose : THelpEvent;
    FControl : TControl;
   Private
//    procedure WMNCHitTest(var M: TWMNCHitTest); message wm_NCHitTest;
//    Procedure WMRButtonDown(Var M: TWMRButtonDown); message WM_NCRBUTTONUP;
   end;

  THKComponentEditor = class(TComponentEditor)
  Public
   Procedure ExecuteVerb(index : Integer); override;
   Function GetVerb(Index : Integer) : string; override;
   Function GetVerbCount : Integer; override;
  end;

procedure Register;

implementation
{$R *.DFM}

Uses
 VCLUtils;

var
 HelpShowing : Boolean;
 HelpWin : THelpWin;

procedure Register;
begin
 RegisterComponentEditor(THKHelp,THKComponentEditor);
 RegisterComponents('Haka', [THKHelp]);
end;

procedure THelpItem.SetTest(b: boolean);
begin
 if assigned(FControl) then OpenHelp;
 FTest:=false;
end;

procedure THelpItem.SetPaste(Value: Boolean);
var h:thandle; p:pchar; C:integer;
begin
 ClipBoard.Open;
 try
  c:=RegisterClipboardFormat(pchar(CF_RTF));
  H := Clipboard.GetAsHandle(C);
  p := GlobalLock(h);
  FRTF:= StrPas(p);
  GlobalUnlock(h);
 finally
  Clipboard.Close;
  FPaste:=false;
 end;
end;

procedure THelpItem.SetControl(value: TControl);
var a:integer; F : boolean;
begin
 if assigned(value) then begin
  f:=false;
  For a:=0 to Collection.count-1 do
   if (assigned(THelpItem(Collection.Items[a]).FControl)) and
      (THelpItem(Collection.Items[a]).FControl.Name=Value.name) then f:=true;
  if not f then begin
   if assigned(FOldWndMethod) then
    if assigned(FControl) then FControl.WindowProc:=FOldWndMethod;
   FControl:=Value;
   FOldWndMethod:=FControl.WindowProc;
   FControl.WindowProc:=SubClassWndProc;
  end else begin FControl:=nil; raise Exception.Create('Control already linked!'); end;
 end else begin
  if assigned(FOldWndMethod) then
   if assigned(FControl) then FControl.WindowProc:=FOldWndMethod;
   FOldWndMethod:=nil;
   FControl:=nil;
 end;
end;

procedure THelpItem.OpenHelp;
var ms : TMemoryStream;
 IsLeft,IsTop : Boolean;
begin
 if HelpShowing then HelpWin.Close;
 if not THelpCol(Collection).FHKHelp.Enabled then exit;
 HelpWin:=THelpWin.Create(Application);
 HelpWin.FHelpOpen:=nil;
 HelpWin.FHelpClose:=nil;
 with THelpCol(Collection).FHKHelp do
  if ComponentState=[] then begin
   HelpWin.FHelpOpen:=FHelpOpen;
   HelpWin.FHelpClose:=FHelpClose;
  end;
 HelpWin.Fcontrol:=FControl;
 HelpWin.Color:=BorderColor;
 HelpWin.Width:=FWidth;
 HelpWin.Height:=FHeight;
 HelpWin.RichEdit.Color:=BackColor;
 HelpWin.Panel.Color:=BorderColor;
 HelpWin.Panel.BorderWidth:=BorderWidth;
 if FControl is TWinControl then
  HelpWin.HelpContext:=TWinControl(FControl).helpcontext;
 ms:=TMemoryStream.create;
 try
  ms.Write(pchar(FRtf)^,length(FRTF));
  ms.Position:=0;
  HelpWin.RichEdit.lines.LoadFromStream(ms);
 finally
  ms.free
 end;
 IsLeft:=FControl.ClientOrigin.x<Screen.Width div 2;
 isTop:=FControl.ClientOrigin.y<Screen.height div 2;
 if IsTop
  then HelpWin.top:=FControl.ClientOrigin.y+FControl.height+5
  else HelpWin.top:=FControl.ClientOrigin.y-HelpWin.Height-5;
 if isLeft
  then HelpWin.Left:=FControl.ClientOrigin.X+5
  else HelpWin.Left:=FControl.ClientOrigin.X-HelpWin.Width-5;
 if HelpWin.Left<0 then HelpWin.Left:=5;
 if HelpWin.Top<0 then HelpWin.Top:=5;
 if HelpWin.Left+HelpWin.Width>Screen.Width
  then HelpWin.Left:=Screen.Width-HelpWin.Width-5;
 if HelpWin.Top+HelpWin.Height>Screen.Height
  then HelpWin.Top:=Screen.Height-helpwin.height-5;
 if THelpCol(Collection).FHKHelp.ComponentState=[]
  then
  begin HelpWin.Show;  SetCaptureControl(HelpWin.RichEdit); end
  else begin HelpWin.ShowModal; end;
end;


procedure THelpItem.SubClassWndProc(var Message: TMessage);
begin
 If ((THelpCol(Collection).FHKHelp.HelpMode) and (Message.msg=WM_LBUTTONDOWN)) or
    (message.msg=WM_Help) then begin
  THelpCol(Collection).FHKHelp.HelpMode:=false;
  Message.msg:=0;
  OpenHelp;
 end else
  FOldWndMethod(Message);
end;

procedure THelpItem.Assign(Source: TPersistent);
begin
 if source is THelpItem then begin
  Control:=THelpItem(Source).control;
  BorderWidth:=THelpItem(source).BorderWidth;
  BackColor:=THelpItem(source).BackColor;
  BorderColor:=THelpItem(source).BorderColor;
  RTF:=THelpItem(source).RTF;
  Width:=THelpItem(source).Width;
  height:=THelpItem(source).Height;
 end
 else inherited Assign(Source);
end;

constructor THelpItem.Create(Collection: TCollection);
begin
 inherited Create(Collection);
 FBorderWidth:=2;
 FBackColor:=clInfoBK;
 FBorderColor:=clBlack;
 FPaste:=False;
 FWidth:=Screen.Width div 3;
 FHeight:=Screen.height div 3;
 FOldWndMethod:=nil;
end;

destructor THelpItem.Destroy;
begin
 if assigned(FControl) then
  FControl.WindowProc:=FOldWndMethod;
 inherited Destroy;
end;

{ THKHelp }

constructor THKHelp.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FHelpMode:=False;
 FEnabled:=true;
 FHelpCol:=THelpCol.create(self);
end;

destructor THKHelp.Destroy;
begin
 FHelpCol.free;
 inherited destroy;
end;

procedure THKHelp.SetHelpCol(value: THelpCol);
begin
 FHelpCol.Assign(value);
end;

procedure THKHelp.SetHelpMode(mode: Boolean);
begin
 If (mode) and (FHelpCol.Count>0) then
 begin
  Screen.Cursor:=crHelp;
  FHelpMode:=true;
 end else begin
  Screen.Cursor:=crDefault;
  FHelpMode:=false;
 end;
end;

{ THelpCol }

function THelpCol.Add: THelpItem;
begin
 result:=THelpItem(inherited Add);
end;

constructor THelpCol.Create(HKHelp: THKHelp);
begin
 Inherited Create(THelpItem);
 FHKHelp:=HKHelp;
end;

function THelpCol.GetItem(index: integer): THelpItem;
begin
 result:=THelpItem(inherited getitem(index));
end;

function THelpCol.GetOwner: TPersistent;
begin
 result:=FHKHelp;
end;

procedure THelpCol.SetItem(index: integer; Value: THelpItem);
begin
 inherited SetItem(index,Value);
end;

procedure THelpCol.Update(item: TCollectionItem);
begin
 inherited Update(item);
end;

{ THelpWin }

procedure THelpWin.FormKeyPress(Sender: TObject; var Key: Char);
begin
 SetCaptureControl(HelpWin.RichEdit);
 if key=#27 then begin key:=#0; close; end;
end;

procedure THelpWin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action:=CaFree;
 if Assigned(FHelpClose) then
  FHelpClose(FControl);
 HelpShowing:=false;
 ReleaseCapture;
end;

procedure THelpWin.FormShow(Sender: TObject);
begin
 HelpShowing:=true;
 if Assigned(FHelpOpen) then
  FHelpOpen(FControl);
end;

//procedure THelpWin.WMNCHitTest(var M: TWMNCHitTest);
//begin
// inherited;
// if  M.Result = htClient then
//   M.Result := htCaption;
//end;

//procedure THelpWin.WMRButtonDown(var M: TWMRButtonDown);
//begin
// m.msg:=0;
// close;
//end;

{ THKComponentEditor }

procedure THKComponentEditor.ExecuteVerb(index: Integer);
begin
 case index of
  0 : THKHelp(Component).Helpmode:=true;
  1 : MessageDlg('HKHelp v1.0'+#13+#10+'by Harry Kakoulidis'
   +#13#10+'kcm@mailbox.gr', mtInformation, [mbOK], 0);
 end;
end;

function THKComponentEditor.GetVerb(Index: Integer): string;
begin
 case index of
  0 : result:='Test help';
  1 : result:='About...';
 end;
end;

function THKComponentEditor.GetVerbCount: Integer;
begin
 result:=2;
end;

procedure THelpWin.RichEditMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 SetCaptureControl(HelpWin.RichEdit);
 if not PointInRect(Point(X, Y), Rect(0,0,Width,Height)) or (Button = mbRight) then
    Close;
end;

end.
