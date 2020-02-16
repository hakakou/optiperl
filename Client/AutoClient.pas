unit AutoClient;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  SysUtils, ComObj, ActiveX, AxCtrls, Classes, OptiClient_TLB, StdVcl, ComServ, PerlAPI, ClientFrm,
  PlugCommon, Windows, Forms, ExtCtrls, OptiPerl_TLB;

type
  TOptiPerlClient = class(TAutoObject, IOptiPerlClient)
  private
    procedure OnIdle(Sender: TObject; var Done: Boolean);
    Procedure OnTimer(Sender: TObject);
  public
    PArray : TPcharArray;
    Timer : TTimer;
    OptiPerl : IApplication;
    procedure Initialize; override;
    Destructor Destroy; Override;
  protected
    procedure Start; safecall;
    procedure InitOptions(const PerlDLL: WideString; MainHandle: Integer;
      const Filename: WideString; PlugNum: Integer); safecall;
    function Get_Subroutines: WideString; safecall;
    function RunInt0(const Sub: WideString): Integer; safecall;
    function RunInt1(const Sub, P1: WideString): Integer; safecall;
    procedure RunSub0(const Sub: WideString); safecall;
    procedure RunSub1(const Sub, P1: WideString); safecall;
    procedure RunSub2(const Sub, P1, P2: WideString); safecall;
    procedure DockWindow(Handle, Parent: Integer); safecall;
    procedure Grab(Enable: WordBool; Handle: Integer); safecall;
    function Get_FirstEnabledWindow: Integer; safecall;
    function Get_ProcessID: Integer; safecall;
    function RunInt2(const Sub, P1, P2: WideString): Integer; safecall;
  end;

var
 MainFormHandle : THandle;
 PlugAction : Cardinal;
 Perl : TPerlEvents;

implementation

procedure TOptiPerlClient.Initialize;
begin
  ClientForm.TerminateTimer.Enabled:=false;
  inherited Initialize;
end;

procedure TOptiPerlClient.OnIdle(Sender: TObject; var Done: Boolean);
begin
 perl.TKDoEventWait;
end;

procedure TOptiPerlClient.Start;
begin
 Perl.Initialize;
 Forms.Application.OnIdle:=OnIdle;
end;

destructor TOptiPerlClient.Destroy;
begin
 if assigned(Timer) then
  FreeAndNil(Timer);
 if assigned(perl) then
  FreeAndNil(Perl);
 PostMessage(MainFormHandle,HK_P_Terminate,PlugAction,0);
 inherited Destroy;
end;

procedure TOptiPerlClient.InitOptions(const PerlDLL: WideString;
  MainHandle: Integer; const Filename: WideString; PlugNum: Integer);
begin
 PerlApi.PerlDllFile:=PerlDLL;
 MainFormHandle:=MainHandle;
 ClientForm.Caption:=Filename;
 PlugAction:=PlugNum;
 Perl:=TPerlEvents.Create(FileName);
 Perl.MainHandle:=MainHandle;
 perl.SelfStr:=IntToStr(plugAction);
 Perl.RaiseExceptions:=true;
 perl.Debug:=true;
 Perl.UseTK:=true;
end;

function TOptiPerlClient.Get_Subroutines: WideString;
begin
 result:=perl.Subroutines.Text;
end;

function TOptiPerlClient.RunInt0(const Sub: WideString): Integer;
begin
 result:=Perl.RunIntFunction(sub,nil);
end;

function TOptiPerlClient.RunInt1(const Sub, P1: WideString): Integer;
begin
 PArray[0]:=PChar(String(p1));
 PArray[1]:=nil;
 result:=Perl.RunIntFunction(sub,@PArray);
end;

function TOptiPerlClient.RunInt2(const Sub, P1, P2: WideString): Integer;
begin
 PArray[0]:=PChar(String(p1));
 PArray[1]:=PChar(String(p2));
 PArray[2]:=nil;
 result:=Perl.RunIntFunction(sub,@PArray);
end;

procedure TOptiPerlClient.RunSub0(const Sub: WideString);
begin
 Perl.RunSubroutine(sub,nil);
end;

procedure TOptiPerlClient.RunSub1(const Sub, P1: WideString);
begin
 PArray[0]:=PAnsiChar(String(p1));
 PArray[1]:=nil;
 Perl.RunSubroutine(sub,@PArray);
end;

procedure TOptiPerlClient.RunSub2(const Sub, P1, P2: WideString);
begin
 PArray[0]:=PAnsiChar(String(p1));
 PArray[1]:=PAnsiChar(String(p2));
 PArray[2]:=nil;
 Perl.RunSubroutine(sub,@PArray);
end;

procedure TOptiPerlClient.DockWindow(Handle, Parent: Integer);
var rect : Trect;
begin
 SetWindowLong(Handle,GWL_STYLE,WS_VISIBLE);
 perl.TKDoEvent;
 GetWindowRect(Handle,Rect);
 with rect do
  SetWindowPos(Handle,0,0,0,right-left+1,bottom-top+1,SWP_NOACTIVATE	or SWP_NOZORDER);
 SetParent(handle,parent);
 Perl.TKDoEvent;
end;

procedure TOptiPerlClient.Grab(Enable: WordBool; Handle: Integer);
begin
 OptiPerl:=CoApplication.Create;
 if Enable then
  begin
   Timer:=TTimer.Create(nil);
   Timer.OnTimer:=OnTimer;
   Timer.Interval:=50;
  end
 else
  FreeAndNil(Timer);
end;

procedure TOptiPerlClient.OnTimer(Sender: TObject);
begin
 try
  if assigned(OptiPerl) then
   OptiPerl.ProcessMessages;
 except
  halt;
 end;
end;

Function EnumThreadWndProc(Hwnd : THandle; LParam : Cardinal) : Boolean; Stdcall;
var H : ^THandle;
begin
 if IsWindowEnabled(Hwnd) and
    isWindowVisible(hwnd) and
    (hwnd<>Forms.Application.MainForm.Handle) then
  begin
   H:=pointer(LParam);
   h^:=hwnd;
   result:=false;
  end
 else
  result:=true;
end;

function TOptiPerlClient.Get_FirstEnabledWindow: Integer;
begin
 result:=0;
 EnumThreadWindows(GetCurrentThreadID,@EnumThreadWndProc,Integer(@result));
end;

function TOptiPerlClient.Get_ProcessID: Integer;
begin
 result:=GetCurrentProcessID;
end;


initialization
 TAutoObjectFactory.Create(ComServer, TOptiPerlClient, Class_OptiPerlClient,
    ciSingleInstance, tmSingle);
end.
