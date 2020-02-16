unit cbAudioPlay;
(*==========================================================================;
 *
 *  Content:	TcbAudioPlay Delphi freeware component
 *
 *  Download: http://www.carlosb.com
 *  E-Mail: delphi@carlosb.com
 *
 *  Helped by Konstantin Boshnyaga (ameoba32@mail.ru) correcting device selection bug
 ***************************************************************************)

interface

uses
  Windows, Classes, MMSystem, Messages, SysUtils, controls,
  directshow9, Dialogs, ActiveX, ComObj;
//>>> Don't have the DirectShow file? Make sure you download the latest DirectX
//>>> headers from http://www.delphi-jedi.org/delphigraphics/

const
  WM_PLAY_EVENT = WM_USER+13;

type
  EcbAudioPlayError = class(Exception)
  private
    FErrorCode: HRESULT;
  public
    constructor Create( const Msg: String; const ErrorCode: HRESULT ); virtual;
    property ErrorCode: HRESULT read FErrorCode;
  end;

  TcbAudioPlay = class;
  TGrabbedSampleEvent = procedure (Sender: TObject; Buffer: PByte; Size: Longint) of object;

  TcbAudioPlayEventListener = class(TWinControl)
  private
    FCreator: TcbAudioPlay;
  protected
    procedure WMPlayEvent(var Msg: TMessage); message WM_PLAY_EVENT;
  public
    property Creator: TcbAudioPlay read FCreator write FCreator;
  end;

  TcbAudioPlay = class(TInterfacedObject, ISampleGrabberCB)
  private
    FParent: TWinControl;
    FFileName: String;
    FOnComplete: TNotifyEvent;
    FOnGrabbedSample: TGrabbedSampleEvent;
    FListener: TcbAudioPlayEventListener;
    FDuration: LONGLONG;
    FCapabilities: DWord;
    FState: Filter_State;
    FLoop,
    FGrabsSamples: Boolean;
    FDeviceIndex: Integer;
    FWaveFormat: PWaveFormatEx;

    // DirectShow interfaces
    FMC: IMediaControl;           // IMediaControl interface
    FME: IMediaEventEx;           // IMediaEventEx interface
    FMS: IMediaSeeking;
    FBA: IBasicAudio;
    FSG: ISampleGrabber;
    FSampleGrabber: IBaseFilter;

    procedure AddARToGraph;
    function CheckFilter(Filter: IBaseFilter): Boolean;
    function GetAudioRendererInterface: IBaseFilter;
    function IsFilterConnected(const Filter: IBaseFilter): Boolean;
    procedure WaitForState(State: Filter_State);

    function GetBalance: Longint;
    function GetCurrentPosition: LONGLONG;
    function GetPreroll: LONGLONG;
    function GetRate: Double;
    function GetStopPosition: LONGLONG;
    function GetVolume: Longint;
    procedure SetBalance(Value: Longint);
    procedure SetRate(Value: Double);
    procedure SetVolume(Value: Longint);

    function SampleCB(SampleTime: Double; pSample: IMediaSample): HResult;
      stdcall;
    function BufferCB(SampleTime: Double;
        pBuffer: PByte; BufferLen: longint): HResult; stdcall;

  protected
    FGraph: IGraphBuilder;        // IGraphBuilder interface
    procedure DoPlayEvent(var Msg: TMessage);
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

  public
    constructor Create(const Parent: TWinControl; const FileName: string;
      DeviceIndex: Integer);
    destructor Destroy; override;

    procedure GetTimeFormat(out Format: TGUID);
    procedure GetAvailable(out Earliest, Latest: LONGLONG);
    function IsFormatSupported(Format: TGUID): Boolean;
    function IsUsingTimeFormat(Format: TGUID): Boolean;
    procedure Play;
    procedure Pause;
    procedure QueryPreferredFormat(out Format: TGUID);
    procedure SetCurrentPosition(var Position: Int64; Flags: DWord);
    procedure SetStopPosition(var Position: Int64; Flags: DWord);
    procedure SetTimeFormat(Format: TGUID);
    procedure Stop;

    property CurrentPosition: LONGLONG read GetCurrentPosition;
    property Balance: Longint read GetBalance write SetBalance;
    property Capabilities: DWord read FCapabilities;  // Specifies the seeking capabilities of a media stream. IMediaSeeking::GetCapabilities
    property Duration: LONGLONG read FDuration;
    property FileName: String read FFileName;
    property GrabsSamples: Boolean read FGrabsSamples;
    property Loop: Boolean read FLoop write FLoop;
    property Preroll: LONGLONG read GetPreroll;
    property Rate: Double read GetRate write SetRate;
    property State: Filter_State read FState;
    property StopPosition: LONGLONG read GetStopPosition;
    property Volume: Longint read GetVolume write SetVolume;
    property WaveFormat: PWaveFormatEx read FWaveFormat;

    property OnComplete: TNotifyEvent read FOnComplete write FOnComplete;
    property OnGrabbedSample: TGrabbedSampleEvent read FOnGrabbedSample
      write FOnGrabbedSample;
  end;


const
  cbAudioPlay_MAX_BALANCE = 10000;
  cbAudioPlay_MIN_BALANCE = -10000;
  cbAudioPlay_MAX_VOLUME = 0;
  cbAudioPlay_MIN_VOLUME = -10000;
  cbAudioPlay_NO_AUDIO_STREAM = 1000;
  cbAudioPlay_DEVICE_NOT_CONNECTED = 1001;

var
  cbDeviceList: TStringList;

function DirectShowPresent: Boolean;

implementation


//************************
//******** GENERIC SECTION
//************************

function SCheck( Value: HRESULT ): HRESULT; { Check the result of a COM operation }
var
  S: String;
  S2: array [0..300] of Char;
begin
  Result := Value;

  if (Value <> S_OK) and (Value <> S_FALSE) then
  begin
    Case DWord(Value) of
      DWord(REGDB_E_CLASSNOTREG): S:='A specified class is not registered in the registration database.';
      DWord(CLASS_E_NOAGGREGATION): S:='This class cannot be created as part of an aggregate.';
      DWord(E_ABORT): S:='The update aborted.';
      DWOrd(E_INVALIDARG): S:='One of the parameters is invalid.';
      DWord(E_POINTER): S:='This method tried to access an invalid pointer.';
      DWord(E_NOINTERFACE): S:='No interface.';
      MS_S_PENDING: S:='The asynchronous update is pending.';
      MS_S_NOUPDATE: S:='Sample was not updated after forced completion.';
      MS_S_ENDOFSTREAM: S:='Reached the end of the stream; the sample wasn''t updated.';
      MS_E_SAMPLEALLOC: S:='An IMediaStream object could not be removed from an IMultiMediaStream object because it still contains at least one allocated sample.';
      MS_E_PURPOSEID: S:='The specified purpose ID can''t be used for the call.';
      MS_E_NOSTREAM: S:='No stream can be found with the specified attributes.';
      MS_E_NOSEEKING: S:='One or more media streams don''t support seeking.';
      MS_E_INCOMPATIBLE: S:='The stream formats are not compatible.';
      MS_E_BUSY: S:='This sample already has a pending update.';
      MS_E_NOTINIT: S:='The object can''t accept the call because its initialize function or equivalent has not been called.';
      MS_E_SOURCEALREADYDEFINED: S:='Source already defined.';
      MS_E_INVALIDSTREAMTYPE: S:='The stream type is not valid for this operation.';
      MS_E_NOTRUNNING: S:='The IMultiMediaStream object is not in running state.';
      Else
        begin
          if AMGetErrorText( Value, s2, High(s2) ) = 0 then
            S:='Unrecognized error value.'
          else
            S:=StrPas( s2 );
        end;
    end;

    S:= Format ( 'DirectShow call failed: %x', [ Value ] )  + #13 + S;
    raise EcbAudioPlayError.Create(S, Value);
  end;
end;

function SSucceeded(Value: HRESULT): Boolean;
begin
  Result := (Value >= 0);
end;

function DirectShowPresent: Boolean;
var
  AMovie: IGraphBuilder;
  Value: Integer;
begin
  Value := CoCreateInstance( CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER,
    IID_IGraphBuilder, AMovie );

  if (Value = S_OK) then
    Result := True
  else
    Result := False;
end;

procedure EnumerateAudioRenderers;
var
  CreateDevEnum: ICreateDevEnum;
  EmDev: IEnumMoniker;
  MDev: IMoniker;
  Fetched: ULong;
  PropBag: IPropertyBag;
  DevClsid,
  DevName: OleVariant;
begin
  // Create an enumerator
  SCheck( CoCreateInstance(CLSID_SystemDeviceEnum, nil, CLSCTX_INPROC,
    IID_ICreateDevEnum, CreateDevEnum) );

  // Use the meta-category that contains a list of all audio renderers.
  SCheck( CreateDevEnum.CreateClassEnumerator(CLSID_AudioRendererCategory,
    EmDev, 0) );

  // Enumerate over every category
  while (EmDev.Next(1, MDev, @Fetched) = S_OK) do
    // Associate moniker with a file
    if SSucceeded(MDev.BindToStorage(nil, nil, IPropertyBag, PropBag)) then
    begin
      // Read CLSID string from property bag
      If SSucceeded(PropBag.Read('CLSID', DevClsid, nil)) then
      begin
        // Read filter name
        // Use the guid if we can't get the name
        if not SSucceeded(PropBag.Read('FriendlyName', DevName, nil)) then
          DevName := DevClsid;

        cbDeviceList.Add(DevName);
      end;
    end
    else
      break;
end;

//  Free an existing media type (ie free resources it holds)
procedure FreeMediaType(var mt: AM_MEDIA_TYPE);
begin
  if (mt.cbFormat <> 0) then
  begin
    CoTaskMemFree(mt.pbFormat);

    // Strictly unnecessary but tidier
    mt.cbFormat := 0;
    mt.pbFormat := nil;
  end;

  mt.pUnk := nil;
end;

// general purpose function to delete a heap allocated AM_MEDIA_TYPE structure
// which is useful when calling IEnumMediaTypes::Next as the interface
// implementation allocates the structures which you must later delete
// the format block may also be a pointer to an interface to release

procedure DeleteMediaType(mt: PAMMediaType);
begin
  // allow NULL pointers for coding simplicity
  if Assigned(mt) then
  begin
    FreeMediaType(mt^);
    CoTaskMemFree(mt);
  end;
end;

constructor EcbAudioPlayError.Create( const Msg: String; const ErrorCode: HRESULT );
begin
  inherited Create( Msg );
  FErrorCode := ErrorCode;
end;

//************************
//******** PRIVATE SECTION
//************************


// if choosen instantiate audio renderer, add it to the filter graph
procedure TcbAudioPlay.AddARToGraph;
var
  AudR: IBaseFilter;
  CreateDevEnum: ICreateDevEnum;
  EmDev: IEnumMoniker;
  MDev: IMoniker;
  Fetched: ULong;
  PropBag: IPropertyBag;
  DevClsid,
  DevName: OleVariant;
begin
  if (FDeviceIndex < 0) or (FDeviceIndex >= cbDeviceList.Count) then
    exit;

  // Create an enumerator
  SCheck( CoCreateInstance(CLSID_SystemDeviceEnum, nil, CLSCTX_INPROC,
    IID_ICreateDevEnum, CreateDevEnum) );

  // Use the meta-category that contains a list of all audio renderers.
  SCheck( CreateDevEnum.CreateClassEnumerator(CLSID_AudioRendererCategory,
    EmDev, 0) );

  // Enumerate over every category
  while (EmDev.Next(1, MDev, @Fetched) = S_OK) do
    // Associate moniker with a file
    if SSucceeded(MDev.BindToStorage(nil, nil, IPropertyBag, PropBag)) then
    begin
      // Read CLSID string from property bag
      If SSucceeded(PropBag.Read('CLSID', DevClsid, nil)) then
      begin
        // Read filter name
        // Use the guid if we can't get the name
        if not SSucceeded(PropBag.Read('FriendlyName', DevName, nil)) then
          DevName := DevClsid;

        if (CompareStr(cbDeviceList[FDeviceIndex], DevName) = 0) then
        // found renderer so add it to graph
        begin
          MDev.BindToObject(nil, nil, IID_IBaseFilter, AudR);

          SCheck( FGraph.AddFilter(AudR, 'Audio Renderer'));

          exit;
        end;
      end;
    end
    else
      break;
end;

// Checks if Filter is an audio renderer. If it's a renderer and not audio
// replace it by a null renderer
function TcbAudioPlay.CheckFilter(Filter: IBaseFilter): Boolean;
var
  Enum: IEnumPins;
  Pin,
  Input,
  Output: IPin;
  InCount,
  OutCount: Integer;
  PinDirThis: PIN_DIRECTION;
  Fetched: ULong;
  MediaType: AM_MEDIA_TYPE;
  NullFilter: IBaseFilter;
begin
  Result := False;

  InCount := 0;
  OutCount := 0;

  // count number of input/output pins
  SCheck(Filter.EnumPins(Enum));
  while Enum.Next(1, Pin, @Fetched) = S_OK do
  begin
    SCheck(Pin.QueryDirection(PinDirThis));
    if PinDirThis = PINDIR_INPUT then
    begin
      Inc(InCount);
      Input := Pin;
    end
    else
      Inc(OutCount);
  end;

  // if there's 0 output pins and 1 input pin it's a renderer
  if (OutCount = 0) and (InCount = 1) then
  begin
    if Input.ConnectionMediaType(MediaType) = S_OK then
    begin
      // check if it's an audio pin
      if CompareMem(@(MediaType.majorType), @MEDIATYPE_Audio, sizeof(TGUID)) then
        Result := True;
      FreeMediaType(MediaType);

      // if not audio replace for a null renderer
      if not Result then
      begin
        SCheck( CoCreateInstance(CLSID_NullRenderer, nil, CLSCTX_INPROC_SERVER,
          IID_IBaseFilter, NullFilter) );
        SCheck(FGraph.AddFilter(NullFilter, 'Void render'));

        SCheck(Input.ConnectedTo(Output));
        SCheck( FGraph.RemoveFilter(Filter) );

        // Now connect the upstream filter's out pin to Null's in pin
        SCheck( NullFilter.EnumPins(Enum) );

        SCheck(Enum.Next(1, Input, @Fetched));
        SCheck(FGraph.Connect(Output, Input));
      end;
    end;
  end;
end;

function TcbAudioPlay.GetAudioRendererInterface: IBaseFilter;
var
  Enum: IEnumFilters;
  Filter: IBaseFilter;
  List: TInterfaceList;
  Fetched: ULONG;
  Cnt: Integer;
begin
  List := TInterfaceList.Create;
  try
    // Get all filters in graph
    SCheck( FGraph.EnumFilters(Enum) );
    while Enum.Next(1, Filter, @Fetched) = S_OK do
      List.Add(Filter);

    // check all filters
    for Cnt := 0 to List.Count-1 do
      if CheckFilter(IBaseFilter(List[Cnt])) then
        Result := IBaseFilter(List[Cnt]);
  finally
    List.Free;
  end;
end;

function TcbAudioPlay.IsFilterConnected(const Filter: IBaseFilter): Boolean;
var
  EnumPins: IEnumPins;
  Pin,
  Pin2: IPin;
  ul: ULONG;
  hr: HResult;
begin
  SCheck( Filter.EnumPins(EnumPins) );

  Result := False;

  while (EnumPins.Next(1, Pin, @ul) = S_OK) and (ul = 1) do
  begin
    hr := Pin.ConnectedTo(Pin2);
    if (hr = S_OK) and Assigned(Pin2) then
      Result := True;

    Pin := nil;
  end;
end;

// Wait for the state to change to the given one.
procedure TcbAudioPlay.WaitForState(State: Filter_State);
var
  lfs: Filter_State;
begin
  // Make sure we have switched to the required state
  repeat
    FMC.GetState(10, lfs);
  until (State = lfs);
end;

function TcbAudioPlay.GetBalance: Longint;
begin
  SCheck( FBA.get_Balance(Result) );
end;

function TcbAudioPlay.GetCurrentPosition: LONGLONG;
begin
  SCheck( FMS.GetCurrentPosition(Result) );
end;

function TcbAudioPlay.GetPreroll: LONGLONG;
begin
  SCheck( FMS.GetPreroll(Result) );
end;

function TcbAudioPlay.GetRate: Double;
begin
  SCheck( FMS.GetRate(Result) );
end;

function TcbAudioPlay.GetStopPosition: LONGLONG;
begin
  SCheck( FMS.GetStopPosition(Result) );
end;

function TcbAudioPlay.GetVolume: Longint;
begin
  SCheck( FBA.get_Volume(Result) );
end;

procedure TcbAudioPlay.SetBalance(Value: Longint);
begin
  SCheck( FBA.put_Balance(Value) );
end;

procedure TcbAudioPlay.SetRate(Value: Double);
begin
  SCheck( FMS.SetRate(Value) );
end;

procedure TcbAudioPlay.SetVolume(Value: Longint);
begin
  SCheck( FBA.put_Volume(Value) );
end;

function TcbAudioPlay.SampleCB(SampleTime: Double;
  pSample: IMediaSample): HResult;
begin
  Result := E_NOTIMPL;
end;

function TcbAudioPlay.BufferCB(SampleTime: Double; pBuffer: PByte;
  BufferLen: longint): HResult;
begin
  if Assigned(FOnGrabbedSample) then
    FOnGrabbedSample(Self, pBuffer, BufferLen);

  Result := S_OK;
end;

//************************
//******** PROTECTED SECTION
//************************

function TcbAudioPlay._AddRef: Integer;
begin
  Result := -1;
end;

function TcbAudioPlay._Release: Integer;
begin
  Result := -1;
end;

procedure TcbAudioPlayEventListener.WMPlayEvent(var Msg: TMessage);
begin
  FCreator.DoPlayEvent(Msg);
end;

procedure TcbAudioPlay.DoPlayEvent(var Msg: TMessage);
var
  evCode, evParam1, evParam2: Longint;
  hr: Longint;
  Pos: LONGLONG;
begin
  hr := FME.GetEvent(evCode, evParam1, evParam2, 0);
  while hr = S_OK do
  begin
    // Spin through the events
    SCheck( FME.FreeEventParams(evCode, evParam1, evParam2) );

    if (evCode = EC_COMPLETE) or (evCode = EC_USERABORT) then
    begin
      if FLoop then
      begin
        Pause;

        Pos := 0;
        SetCurrentPosition(Pos, AM_SEEKING_AbsolutePositioning);

        Play;
      end
      else
        Stop;

      if Assigned(FOnComplete) then
        FOnComplete(self);
    end;

    hr := FME.GetEvent(evCode, evParam1, evParam2, 0);
  end;

  if hr <> E_ABORT then
    SCheck(hr);
end;

//************************
//******** PUBLIC SECTION
//************************

constructor TcbAudioPlay.Create(const Parent: TWinControl;
  const FileName: string; DeviceIndex: Integer);
var
  wFileName: array [0..MAX_PATH] of WideChar;
  AudR: IBaseFilter;
  mt: AM_MEDIA_TYPE;
begin
  inherited Create;

  FParent := Parent;
  FFileName := FileName;
  FDeviceIndex := DeviceIndex;

  FListener := TcbAudioPlayEventListener.Create(FParent);
  FListener.Parent := FParent;
  FListener.Creator := Self;

  FState := State_Stopped;

  // Get the interface for DirectShow's GraphBuilder
  SCheck( CoCreateInstance(CLSID_FilterGraph, nil, CLSCTX_INPROC_SERVER,
    IID_IGraphBuilder, FGraph) );

  StringToWideChar(FFileName, wFileName, High(wFileName));

  // Instantiate Audio Renderer, add it to the graph
  AddARToGraph;

  // Instantiate Sample Grabber
  if CoCreateInstance(CLSID_SampleGrabber, nil, CLSCTX_INPROC_SERVER,
    IID_IBaseFilter, FSampleGrabber) = S_OK then
  begin
    FGrabsSamples := True;

    SCheck(FSampleGrabber.QueryInterface(IID_ISampleGrabber, FSG));

    FGraph.AddFilter(FSampleGrabber, 'Grabber');

    ZeroMemory(@mt, sizeof(AM_MEDIA_TYPE));
    mt.majortype := MEDIATYPE_AUDIO;
    mt.subtype := GUID_NULL;
    mt.formattype := FORMAT_WaveFormatEx;
    SCheck( FSG.SetMediaType(mt));
  end
  else
    FGrabsSamples := False;

  // First render the graph for the selected file
  SCheck( FGraph.RenderFile(wFileName, nil) );

  if FGrabsSamples then
  begin
    FSG.SetOneShot(False);
    FSG.SetBufferSamples(True);
    FSG.SetCallback(self, 1);
  end;

  AudR := GetAudioRendererInterface;

  if not Assigned(AudR) then
    raise EcbAudioPlayError.Create('Specified file doesn''t have any ' +
      'audio stream.', cbAudioPlay_NO_AUDIO_STREAM);

  if not IsFilterConnected(AudR) then
    raise EcbAudioPlayError.Create('Selected audio device not connected',
      cbAudioPlay_DEVICE_NOT_CONNECTED);

  if FGrabsSamples then
  begin
    if not IsFilterConnected(FSampleGrabber) then
      raise EcbAudioPlayError.Create('Sample grabber not connected',
        cbAudioPlay_DEVICE_NOT_CONNECTED);

    // Get sample format
    SCheck( FSG.GetConnectedMediaType(mt) );
    GetMem(FWaveFormat, mt.cbFormat);
    CopyMemory(FWaveFormat, mt.pbFormat, mt.cbFormat);
  end;

  // We are successful in building the graph. Now the rest...
  SCheck( FGraph.QueryInterface(IID_IMediaControl, FMC) );
  SCheck( FGraph.QueryInterface(IID_IMediaEventEx, FME) );
  SCheck( FGraph.QueryInterface(IID_IMediaSeeking, FMS) );
  SCheck( FGraph.QueryInterface(IID_IBasicAudio, FBA) );

  // Also set up the event notification so that the main window gets
  // informed about all that we care about during playback.
  SCheck( FME.SetNotifyWindow(FListener.Handle, WM_PLAY_EVENT, 0) );

  SCheck( FMS.GetCapabilities(FCapabilities) );
  if (FCapabilities and AM_SEEKING_CanGetDuration) <> 0 then
    SCheck( FMS.GetDuration(FDuration) );
end;

destructor TcbAudioPlay.Destroy;
begin
  if Assigned(FME) then
  // clear any already set notification arrangement
    FME.SetNotifyWindow(0, WM_PLAY_EVENT, 0);

  if Assigned(FWaveFormat) then
    FreeMem(FWaveFormat);

  FBA := nil;
  FMS := nil;
  FME := nil;
  FMC := nil;
  FSG := nil;
  FSampleGrabber := nil;
  FGraph := nil;

  FListener.Free;

  inherited Destroy;
end;

// Plays the filter graph (and waits to really start playing)
procedure TcbAudioPlay.Play;
begin
  SCheck( FMC.Run );
  WaitForState(State_Running);

  FState := State_Running;
end;

// Pauses/Cues the filter graph (and waits to really pause)
procedure TcbAudioPlay.Pause;
begin
  SCheck(FMC.Pause);
  WaitForState(State_Paused);

  FState := State_Paused;
end;

// CBaseVideoPlayer::Stop(): Stops the filter graph (and waits to really stop)
procedure TcbAudioPlay.Stop;
begin
  SCheck(FMC.Stop);
  WaitForState(State_Stopped);

  FState := State_Stopped;
end;

procedure TcbAudioPlay.GetTimeFormat(out Format: TGUID);
begin
  SCheck( FMS.GetTimeFormat(Format) );
end;

procedure TcbAudioPlay.GetAvailable(out Earliest, Latest: LONGLONG);
begin
  SCheck( FMS.GetAvailable(Earliest, Latest) );
end;

function TcbAudioPlay.IsFormatSupported(Format: TGUID): Boolean;
var
  r: HResult;
begin
  r := FMS.IsFormatSupported(Format);
  Result := True;
  if r = S_FALSE then
    Result := False
  else
    SCheck(r);
end;

function TcbAudioPlay.IsUsingTimeFormat(Format: TGUID): Boolean;
var
  r: HResult;
begin
  r := FMS.IsUsingTimeFormat(Format);
  Result := True;
  if r = S_FALSE then
    Result := False
  else
    SCheck(r);
end;

procedure TcbAudioPlay.QueryPreferredFormat(out Format: TGUID);
begin
  SCheck( FMS.QueryPreferredFormat(Format) );
end;

procedure TcbAudioPlay.SetCurrentPosition(var Position: Int64; Flags: DWord);
var
  temp: Int64;
begin
  SCheck( FMS.SetPositions(Position, Flags, temp, AM_SEEKING_NoPositioning) );
end;

procedure TcbAudioPlay.SetStopPosition(var Position: Int64; Flags: DWord);
var
  temp: Int64;
begin
  SCheck( FMS.SetPositions(temp, AM_SEEKING_NoPositioning, Position, Flags) );
end;

procedure TcbAudioPlay.SetTimeFormat(Format: TGUID);
begin
  SCheck( FMS.SetTimeFormat(Format) );
end;

initialization
CoInitialize(nil);

cbDeviceList := TStringList.Create;

EnumerateAudioRenderers;

finalization
cbDeviceList.Free;

CoUninitialize;

end.



