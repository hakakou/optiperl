unit HKProgressBr;

{
  HKProgressBar v1.5
   By Harry Kakoulidis 11/1999

  prog@xarka.com
  http://www.xarka.com

  This is Freeware. Please copy the file unchanged.
  If you find bugs, have options etc. Please send at my e-mail.

  The use of this component is at your own risk.
  I do not take any responsibility for any damages.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Buttons;

type

  EProgressThreadError = class(Exception);

  TProgressForm = class(TForm)
    bar: TProgressBar;
    lblText: TLabel;
    lblProg: TLabel;
    btnCancel: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    Canceled : boolean;
  end;

  TProcessItemEvent = Procedure of object;
  TProgressEnd = Procedure(Cancelled : boolean) of Object;
  TFormPositions = (fpTopRight,fpTopLeft,fpBottomRight,fpBottomLeft,fpCenter);

  TProgThread = class(TThread)
  Public
   DoThread : Procedure of object;
  protected
   procedure Execute; override;
  Private
  end;

  THKProgressBar = class(TComponent)
  private
   FUnCount,FCanCancel : Boolean;
   FWait : Boolean;
   FShowForm : Boolean;
   FProgForm : TProgressForm;
   FOnCancel : TProgressEnd;
   FOnProcessItem : TProcessItemEvent;
   FCounter : integer;
   FUpdateTimes : Integer;
   FCaption,FTextStr : string;
   FInThread : Boolean;
   FPos : TFormPositions;
   ProgThread : TProgThread;
   Procedure OnEndThread(sender : TObject);
   procedure InitProgForm;
   Procedure InitThread;
  public
   procedure StartProgress(NumKnown : Boolean);
   procedure SetPosition(DoneNum,FromNum : Integer);
   function UserCanceled: boolean;
   Constructor Create(AOwner : TComponent); override;
  published
   property OnEnd : TProgressEnd read FOnCancel write FOnCancel;
   property OnProcessItem : TProcessItemEvent read FOnProcessItem write FOnProcessItem;
   property InThread : boolean read FInThread write FInThread;
   property Caption : string read FCaption write FCaption;
   property ShowDialog : boolean read FShowForm write FShowForm;
   property WaitTillFinish : boolean read FWait write FWait;
   property CanCancel : boolean read FCanCancel write FCanCancel;
   property TextString : string read FTextStr write FTextStr;
   property UpdateTImes : integer read FUpdateTImes write FUpdateTImes;
   Property FormPosition : TFormPositions read FPos write FPos;
  end;

procedure Register;

implementation

{$R *.DFM}

procedure Register;
begin
  RegisterComponents('Haka', [THKProgressBar]);
end;

constructor THKProgressBar.Create(AOwner: TComponent);
begin
 FInThread:=true;
 FUpdateTimes:=200;
 FCanCancel:=true;
 FWait:=False;
 FPos:=fpBottomRight;
 FShowForm:=true;
 FCaption:='Processing...';
 FTextStr:='Please wait';
 inherited create(AOwner);
end;

procedure THKProgressBar.StartProgress(NumKnown : Boolean);
begin
 FUnCount:=not NumKnown;
 FCounter:=0;
 if not assigned(FOnProcessItem) then exit;
 InitprogForm;
 if FInThread then begin
  initThread;
  if Fshowform then
   if Fwait then FProgForm.Showmodal else FProgForm.Show;
 end else begin
  if Fshowform then begin
   FProgForm.Show;
   try
    if FWait then application.MainForm.Enabled:=false;
    FOnProcessItem;
   finally;
    OnEndThread(self);
    if FWait then application.MainForm.Enabled:=true;
   end;
  end else begin
   try
    FOnProcessItem;
   finally
    OnEndThread(self);
   end; 
  end;
 end;
end;

procedure THKProgressBar.InitProgForm;
begin
 if FShowForm then begin
  FProgForm:=TProgressForm.create(Application);
  with FProgForm do begin
   lbltext.caption:=FTextStr;
   Caption:=FCaption;
   lblprog.visible:=not FUnCount;
   bar.visible:=not FUnCount;
   btnCancel.visible:=FCanCancel;
   if not FCanCancel then height:=height-btncancel.height;
   case Fpos of
    fpTopLeft : begin top:=5; left:=5; end;
    fpBottomLeft : begin top:=screen.Height-height-5; left:=5; end;
    fpTopRight : begin top:=5; left:=screen.Width-width-5; end;
    fpBottomRight : begin top:= screen.Height-height-5; left:=5;
                         left:=screen.Width-width-5; end;
    fpCenter : begin top:=(screen.height-height) div 2;
                     left:=(screen.width-width) div 2;
               end;
   end;
  end;
 end;
end;

procedure THKProgressBar.InitThread;
begin
 progThread:=TProgThread.create(true);
 ProgThread.DoThread:=FOnProcessItem;
 ProgThread.OnTerminate:=OnEndThread;
 ProgThread.Resume;
end;

procedure THKProgressBar.OnEndThread(sender: TObject);
var b:boolean;
begin
 if FShowForm then begin
  b:=FProgForm.Canceled;
  FProgForm.Close;
 end else b:=false;
 if assigned(FOnCancel) then FOnCancel(b);
end;

procedure TProgressForm.FormCreate(Sender: TObject);
begin
 Canceled:=false;
end;
procedure TProgressForm.btnCancelClick(Sender: TObject);
begin
 Canceled:=true;
end;
procedure TProgressForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 action:=caFree;
end;

procedure TProgThread.Execute;
begin
 FreeOnTerminate:=True;
 DoThread;
end;

Function THKProgressBar.UserCanceled : boolean;
begin
 if FShowForm
  then result:=FProgForm.Canceled
  else result:=false;
end;

Procedure THKProgressBar.SetPosition(DoneNum, FromNum: Integer);
begin
 with FProgForm do
 if FShowForm then begin
  if FCounter=FUpdateTimes then begin
   FCounter:=0;
   if FUnCount then begin
    lbltext.Caption:=format(FTExtstr,[DoneNum]);
   end else begin
    if fromNum<>0 then begin
     bar.max:=FromNum;
     FProgForm.bar.Position:=DoneNum;
     FProgForm.lblProg.caption:=inttostr((100*(DoneNum)) div (FromNum))+'%';
    end else begin
     bar.max:=1;
    FProgForm.bar.Position:=1;
     FProgForm.lblProg.caption:='100%';
    end;
   end;
  end;
  Inc(FCounter);
 end;
 if not FInThread then Application.ProcessMessages;
end;

end.
