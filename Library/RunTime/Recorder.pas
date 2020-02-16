// TRecorder
//
// cyamon software
// place de l'Hôtel-de-Ville 8
// 1040 Echallens
// Switzerland
// www.cyamon.com

// 11/99

// This unit is a freeware. You may change it, use it in your applications
// at your own risks.

// The recorder is an object that allows to record and play back mouse and
// keyboard events. The recorder is not a component, it is instead a singleton
// that is created and destroyed automatically in the initialization and
// finalization parts of this unit. The recorded information is saved into a
// memory stream.

// The recorder exports the following properties and methods:

// property State (Read only) is the recorder's state (idle, recording or playing).

// property SpeedFactor is the factor (in %) by which the playback speed is modified.
// Values < 100 accelerate, and values > 100 slowdown.

// property OnStateChange is an event that is fired when the state changes.

// procedure DoRecord(Append : boolean);
// Starts recording. When "Append" is true the new recorded information is appended
// to information already stored in the local stream. Otherwise, the local stream is
// clared before recording.

// procedure DoPlay;
// Plays the recorded information

// procedure DoStop;
// Stops recording and/or to playing

unit Recorder;

interface
  uses
    Classes, Windows;

  type
    TRecorderState = (rsIdle, rsRecording, rsPlaying);
    TStateChangeEvent = procedure(NewState : TRecorderState) of object;

    TRecorder = class(TObject)
    private
      EventMsg : TEVENTMSG;
      FState : TRecorderState;
      FStream : TMemoryStream;
      HookHandle : THandle;
      BaseTime : integer;
      FSpeedFactor : integer;
      FOnStateChange : TStateChangeEvent;
      procedure SetSpeedFactor(const Value: integer);
      procedure SetState(const Value: TRecorderState);
    public
      constructor Create;
      destructor Destroy; override;
      procedure DoPlay;
      procedure DoRecord(Append : boolean);
      procedure DoStop;
      property SpeedFactor : integer read FSpeedFactor write SetSpeedFactor;
      property OnStateChange : TStateChangeEvent read FOnStateChange write FOnStateChange;
      property State : TRecorderState read FState;
      property Stream : TMemoryStream read FStream;
    end;

  var
    TheRecorder : TRecorder = nil;

implementation
  uses
    SysUtils, Messages;
{~t}
(************)
(* PlayProc *)
(************)

function PlayProc(Code : integer; Undefined : WPARAM; P : LPARAM) : LRESULT; stdcall;
begin
  if Code < 0 then
    Result := CallNextHookEx(TheRecorder.HookHandle, Code, Undefined, P)
  else begin
    case Code of
      HC_SKIP: begin
        if TheRecorder.FStream.Position < TheRecorder.FStream.Size then begin
          TheRecorder.FStream.Read(TheRecorder.EventMsg, SizeOf(EventMsg));
          TheRecorder.EventMsg.Time := TheRecorder.SpeedFactor*(TheRecorder.EventMsg.Time div 100);
          TheRecorder.EventMsg.Time := TheRecorder.EventMsg.Time + TheRecorder.BaseTime;
        end else
          TheRecorder.SetState(rsIdle);
      end;

      HC_GETNEXT: begin
        Result := TheRecorder.EventMsg.Time - GetTickCount();
        if Result < 0 then
          Result := 0;
        PEVENTMSG(P)^ := TheRecorder.EventMsg;
      end;
    else
      PEVENTMSG(P)^ := TheRecorder.EventMsg;
      Result := CallNextHookEx(TheRecorder.HookHandle, Code, Undefined, P)
    end {case};
  end {if};
end {PlayProc};


(**************)
(* RecordProc *)
(**************)

function RecordProc(Code : integer; Undefined : WPARAM; P : LPARAM) : LRESULT; stdcall;
begin
  if Code < 0 then
    Result := CallNextHookEx(TheRecorder.HookHandle, Code, Undefined, P)
  else begin
    case Code of
      HC_ACTION: begin
        TheRecorder.EventMsg := PEVENTMSG(P)^;
        TheRecorder.EventMsg.Time := TheRecorder.EventMsg.Time-TheRecorder.BaseTime;
        if (TheRecorder.EventMsg.Message >= WM_KEYFIRST) and (TheRecorder.EventMsg.Message <= WM_KEYLAST) and
          (LoByte(TheRecorder.EventMsg.ParamL) = VK_CANCEL) then begin
          // Recording aborted by ctrl-Break
          TheRecorder.SetState(rsIdle);
        end {if};
        TheRecorder.FStream.Write(TheRecorder.EventMsg, sizeOf(TheRecorder.EventMsg));
      end;
      HC_SYSMODALON:;
      HC_SYSMODALOFF:
    end {case};
  end {if};
end {RecordProc};


(********************)
(* TRecorder.Create *)
(********************)

constructor TRecorder.Create;
begin
 FStream := TMemoryStream.Create;
 FSpeedFactor := 100;
end {TRecorder.Create};


(*********************)
(* TRecorder.Destroy *)
(*********************)

destructor TRecorder.Destroy;
begin
  DoStop;
  FStream.Free;
  inherited;
end {TRecorder.Destroy};


(********************)
(* TRecorder.DoPlay *)
(********************)

procedure TRecorder.DoPlay;
begin
  if State <> rsIdle then
    raise Exception.Create('Recorder: Not ready to play.')
  else if FStream.Size = 0 then
    raise Exception.Create('Recorder: Nothing to play')
  else begin
    FStream.Seek(0,0);
    FStream.Read(EventMsg, SizeOf(EventMsg));
    HookHandle := SetWindowsHookEx(WH_JOURNALPLAYBACK, @PlayProc, hInstance, 0);
    if HookHandle = 0 then
      raise Exception.Create('Playback hook cannot be created')
    else begin
      BaseTime := GetTickCount();
      SetState(rsPlaying);
    end {if};
  end {if};
end {TRecorder.DoPlay};


(**********************)
(* TRecorder.DoRecord *)
(**********************)

procedure TRecorder.DoRecord(Append : boolean);
begin
  if State <> rsIdle then
    raise Exception.Create('Recorder: NotReady to record.')
  else begin
    if not Append then begin
      FStream.Size := 0;
      BaseTime := GetTickCount();
    end else begin
      EventMsg.Time := 0;
      if FStream.Size > 0 then begin
        FStream.Seek(-SizeOf(EventMsg),soFromCurrent);
        FStream.Read(TheRecorder.EventMsg, SizeOf(EventMsg));
      end {if};
      BaseTime := GetTickCount() - EventMsg.Time;
    end {if};
    HookHandle := SetWindowsHookEx(WH_JOURNALRECORD, @RecordProc, hInstance, 0);
    if HookHandle = 0 then
      raise Exception.Create('JournalHook cannot be created')
    else begin
      SetState(rsRecording);
    end {if};
  end {if};
end {TRecorder.DoRecord};


(********************)
(* TRecorder.DoStop *)
(********************)

procedure TRecorder.DoStop;
begin
 SetState(rsIdle);
end {TRecorder.DoStop};


(****************************)
(* TRecorder.SetSpeedFactor *)
(****************************)

procedure TRecorder.SetSpeedFactor(const Value: integer);
begin
  if Value > 0 then
    FSpeedFactor := Value;
end {TRecorder.SetSpeedFactor};


(**********************)
(* TRecorder.SetState *)
(**********************)

procedure TRecorder.SetState(const Value: TRecorderState);
begin
  if (Value = rsIdle) and (HookHandle <> THandle(0)) then begin
    UnhookWindowsHookEx(HookHandle);
    HookHandle := THandle(0);
  end {if};
  if Value <> FState then begin
    FState := Value;
    if Assigned(FOnStateChange) then
      FOnStateChange(FState)
  end {if};
end {TRecorder.SetState};

end.
