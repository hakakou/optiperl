unit HKAccurateTimer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TSecondUnit = (suSeconds,suMilliSeconds,suMicroSeconds,suNanoSeconds,suPicoSeconds);

  TAccurateTimer = class(TComponent)
  private
    fStartTime,fEndTime,fElapsed:ULARGE_INTEGER;
    FSecUnit : TSecondUnit;
    function GetTimeStamp: ULARGE_INTEGER;
  protected
    { Protected declarations }
  public
    LastUsedUnitStr : string;
    Constructor Create(AOwner : Tcomponent); override;
    function GetElapsedSeconds: Double;
    function GetElapsedTicks: Int64;
    procedure StartTimer;
    procedure StopTimer;
  published
    Property SecondUnit : TSecondUnit read FSecUnit write FSecUnit;
  end;

const
 SecondUnitStr : Array[TSecondUnit] of string = ('s','ms',#181+'s','ns','ps');

var
 ExactCPUSpeed : Double;

Function SupportsTimeStamp:Boolean;
procedure InitAccurateTimer;

procedure Register;

implementation

const
 SecUnitDiv : array[TSecondUnit] of double = (1,1000,1000000,1000000000,1000000000000);

var
  fCPUSpeed:Comp;
  fTimeStamp1:Word;
  fTimeStamp2:Word;
  fTimeStamp3:Word;
  fTimeStamp4:Word;
  AccurateTimerInitialized : Boolean = False;

function GetCPUID4 :DWORD; assembler;register;
(** This function retrieves a set of CPUID flags,
    one of which, is whether the TimeStamp counter exists **)
asm
  PUSH    EBX		(** Save registers **)
  PUSH    EDI
  MOV     EAX,1 	(** Set up for CPUID **)
  DW      $A20F 	(** CPUID OpCode **)
  MOV @Result,EDX	(** Put the flag array into a DWord **)
  POP     EDI		(** Restore registers **)
  POP     EBX
end;


Function SupportsTimeStamp:Boolean;
begin
Result:=FALSE;
If (GetCPUID4 and 16) = 16 then result:=TRUE;
end;

Function GetTimeStampHi:DWord;assembler;register;
asm
 DW      $310F       {RDTSC Command}
 MOV @Result, EDX;
end;

(******************************************************************************)

Function GetTimeStampLo:DWord;assembler;register;
asm
  DW      $310F       {RDTSC Command}
  MOV @Result, EAX;
end;


Procedure RefreshTimeStamp;
begin
if SupportsTimeStamp then
 begin
  fTimeStamp1:=HiWord(GetTimeStampHi);
  fTimeStamp2:=LoWord(GetTimeStampHi);
  fTimeStamp3:=HiWord(GetTimeStampLo);
  fTimeStamp4:=LoWord(GetTimeStampLo);
 end;
end;

function OldGetCpuSpeed: Comp;
(** Uses RDTSC Command to get the Processor Timer count **)
var
  t: DWORD;
  mhi, mlo, nhi, nlo: DWORD;
  t0, t1, chi, clo, shr32: Comp;
begin
  Result:=0;
  shr32 := 65536;
  shr32 := shr32 * 65536;

  (** Get a start time **)
  t := GetTickCount;
  while t = GetTickCount do begin end;
  asm
    DB 0FH
    DB 031H  	(** RDTSC Opcode retrieves 64-bit tick count since boot **)
    mov mhi,edx (** 32-bit Ticks Hi **)
    mov mlo,eax (** 32-bit Ticks Lo **)
  end;

 (** Look 1 second later **)
  while GetTickCount < (t + 1000) do begin end;
  asm
    DB 0FH
    DB 031H  (** RDTSC **)
    mov nhi,edx
    mov nlo,eax
  end;

  (** See how many Processor Timer Ticks have elapsed **)
  chi := mhi; if mhi < 0 then chi := chi + shr32;
  clo := mlo; if mlo < 0 then clo := clo + shr32;

  t0 := chi * shr32 + clo;

  chi := nhi; if nhi < 0 then chi := chi + shr32;
  clo := nlo; if nlo < 0 then clo := clo + shr32;

  t1 := chi * shr32 + clo;

  Result := Round(t1 - t0);
  ExactCPUSpeed:=Result/1E6;
end;

Function GetTicksPerSecond(ITERATIONS:Word):Comp;
Var
 FREQ,PERFCOUNT,TARGET:ULARGE_INTEGER;
 AT : TAccurateTimer;
begin
  Result:=0; (** Initialise in case of failure **)
  if NOT QueryPerformanceFrequency(int64(FREQ)) then exit;
  (** The OS or hardware may not support this API call.
      Sometimes, the FREQ is equal to Processor Ticks/Second,
      but it might not be on every system **)

  QueryPerformanceCounter(int64(PERFCOUNT));
  (** Get a start time via the OS **)

  TARGET.QuadPart:=PERFCOUNT.QuadPart + (FREQ.QuadPart * ITERATIONS);
  (** Make an end time **)

  AT:=TAccurateTimer.Create(nil);
  try
   at.StartTimer;
  (** Fetch the processor tickcount **)

   REPEAT (** Loop for exactly one second (according to the OS) **)
    QueryPerformanceCounter(int64(PERFCOUNT));
   UNTIL (PERFCOUNT.QuadPart >= TARGET.QuadPart);

   (** Fetch the number of processor ticks since the loop started **)
   at.StopTimer;
   Result:=(At.GetElapsedTicks/ITERATIONS);
  finally
   AT.Free;
  end;

 (** In MegaHertz **)
 ExactCPUSpeed:=Result/1E6;
end;

Function GetCPUSpeed:Comp;
Begin
 Result:=GetTicksPerSecond(1);
End;

(******************************************************************************)


procedure Register;
begin
  RegisterComponents('Haka', [TAccurateTimer]);
end;

{ TAccurateTimer }

Function TAccurateTimer.GetTimeStamp:ULARGE_INTEGER;
begin
 Result.QuadPart:=0;
 If (GetCPUID4 and 16) <> 16 then exit; (** No Timestamp Function **)
 Result.HighPart:=DWORD(GetTimeStampHi);
 Result.LowPart:=GetTimeStampLo;
End;

Procedure TAccurateTimer.StartTimer;
Begin
 (** Get raw processor ticks since power-on **)
 fStartTime:=GetTimeStamp;
 fEndTime.QuadPart:=0;
 fElapsed.QuadPart:=0;
End;

(******************************************************************************)

Procedure TAccurateTimer.StopTimer;
Begin
 (** Get raw processor ticks since power-on **)
 fEndTime:=GetTimeStamp;
 fElapsed.QuadPart:=(fEndTime.QuadPart-fStartTime.QuadPart);
End;

(******************************************************************************)

Function TAccurateTimer.GetElapsedTicks:int64;
Begin
 (** Implicit 64-bit TypeCast **)
 Result:=fElapsed.QuadPart;
End;

Function TAccurateTimer.GetElapsedSeconds:Double;
begin
 if FCPUSpeed>0 then begin
  Result:=(GetElapsedTicks/(fCPUSpeed));
  result:=result*SecUnitDiv[FSecUnit];
  LastUsedUnitStr:=SecondUnitStr[FSecUnit];
 end
  else Result:=-1;
End;

constructor TAccurateTimer.Create(AOwner: Tcomponent);
begin
 FSecUnit:=suSeconds;
 inherited Create(AOwner);
end;

procedure InitAccurateTimer;
begin
 if AccurateTimerInitialized then Exit;
 FCPUSpeed:=0;
 if SupportsTimeStamp then
 begin
  RefreshTimeStamp; (** Sets the TimeStamp members **)
  if fCPUSpeed=0 then
   FCPUSpeed:=GetCPUSpeed;
 end;
 (** Alternative methods for CPU Speed **)
 if fCPUSpeed=0 then FCPUSpeed:=OldGetCPUSpeed; (** Last ditch try! **)
 AccurateTimerInitialized:=True;
end;

end.
