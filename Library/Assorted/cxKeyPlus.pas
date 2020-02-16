(*******************************************************************

  CarbonSoft cxKeyPlus VCL Extension v1.0
  Delphi Implementation

  Copyright © 2000 Kev French, CarbonSoft. All rights reserved

  Important Information:
  You (individual or organisation) are free to use this library and
  associated component in compiled form for any purpose 

  You may create and distribute derivative components provided that:

  - No charge is made for the component
  - Full source code is included with the component, and
  - All existing copyright notices are preserved.

  The source code may NOT be redistributed, in whole or in part, for
  profit without written permission from CarbonSoft.

  If you have any queries please contact: licensing@carbonsoft.com

 *******************************************************************)
unit cxKeyPlus;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TKeyPlusEvent = procedure(Sender: TObject; ShiftState: TShiftState) of object;
  EKeyPlusError = class(Exception);

  TcxKeyPlus = class(TComponent)
  private
    { Private declarations }
    FEnabled: Boolean;

    FOldWindowProcedure: TFarProc;
    FNewWindowProcedure: Pointer;

    FOnBrowserBackward: TKeyPlusEvent;
    FOnBrowserForward: TKeyPlusEvent;
    FOnBrowserRefresh: TKeyPlusEvent;
    FOnBrowserStop: TKeyPlusEvent;
    FOnBrowserSearch: TKeyPlusEvent;
    FOnBrowserFavourites: TKeyPlusEvent;
    FOnBrowserHome: TKeyPlusEvent;
    FOnVolumeMute: TKeyPlusEvent;
    FOnVolumeDown: TKeyPlusEvent;
    FOnVolumeUp: TKeyPlusEvent;
    FOnMediaNextTrack: TKeyPlusEvent;
    FOnMediaPreviousTrack: TKeyPlusEvent;
    FOnMediaStop: TKeyPlusEvent;
    FOnMediaPlayPause: TKeyPlusEvent;
    FOnLaunchMail: TKeyPlusEvent;
    FOnLaunchMediaSelect: TKeyPlusEvent;
    FOnLaunchApp1: TKeyPlusEvent;
    FOnLaunchApp2: TKeyPlusEvent;
    FOnBassDown: TKeyPlusEvent;
    FOnBassBoost: TKeyPlusEvent;
    FOnBassUp: TKeyPlusEvent;
    FOnTrebleDown: TKeyPlusEvent;
    FOnTrebleUp: TKeyPlusEvent;

    procedure HookedWindowProcedure(var Msg: TMessage);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Enabled: Boolean read FEnabled write FEnabled;
    
    property OnBrowserBackward: TKeyPlusEvent read FOnBrowserBackward write FOnBrowserBackward;
    property OnBrowserForward: TKeyPlusEvent read FOnBrowserForward write FOnBrowserForward;
    property OnBrowserRefresh: TKeyPlusEvent read FOnBrowserRefresh write FOnBrowserRefresh;
    property OnBrowserStop: TKeyPlusEvent read FOnBrowserStop write FOnBrowserStop;
    property OnBrowserSearch: TKeyPlusEvent read FOnBrowserSearch write FOnBrowserSearch;
    property OnBrowserFavouries: TKeyPlusEvent read FOnBrowserFavourites write FOnBrowserFavourites;
    property OnBrowserHome: TKeyPlusEvent read FOnBrowserHome write FOnBrowserHome;
    property OnVolumeMute: TKeyPlusEvent read FOnVolumeMute write FOnVolumeMute;
    property OnVolumeDown: TKeyPlusEvent read FOnVolumeDown write FOnVolumeDown;
    property OnVolumeUp: TKeyPlusEvent read FOnVolumeUp write FOnVolumeUp;
    property OnMediaNextTrack: TKeyPlusEvent read FOnMediaNextTrack write FOnMediaNextTrack;
    property OnMediaPreviousTrack: TKeyPlusEvent read FOnMediaPreviousTrack write FOnMediaPreviousTrack;
    property OnMediaStop: TKeyPlusEvent read FOnMediaStop write FOnMediaStop;
    property OnMediaPlayPause: TKeyPlusEvent read FOnMediaPlayPause write FOnMediaPlayPause;
    property OnLaunchMail: TKeyPlusEvent read FOnLaunchMail write FOnLaunchMail;
    property OnLaunchMediaSelect: TKeyPlusEvent read FOnLaunchMediaSelect write FOnLaunchMediaSelect;
    property OnLaunchApp1: TKeyPlusEvent read FOnLaunchApp1 write FOnLaunchApp1;
    property OnLaunchApp2: TKeyPlusEvent read FOnLaunchApp2 write FOnLaunchApp2;
    property OnBassDown: TKeyPlusEvent read FOnBassDown write FOnBassDown;
    property OnBassBoost: TKeyPlusEvent read FOnBassBoost write FOnBassBoost;
    property OnBassUp: TKeyPlusEvent read FOnBassUp write FOnBassUp;
    property OnTrebleDown: TKeyPlusEvent read FOnTrebleDown write FOnTrebleDown;
    property OnTrebleUp: TKeyPlusEvent read FOnTrebleUp write FOnTrebleUp;
  end;

const
  { WM_APPCOMMAND message (from Win2000 SDK) }
  WM_APPCOMMAND = $319;

  { Commands for HSHELL_APPCOMMAND and WM_APPCOMMAND (from Win2000 SDK) }
  WM_APPCOMMAND_BROWSER_BACKWARD      = 1;
  WM_APPCOMMAND_BROWSER_FORWARD       = 2;
  WM_APPCOMMAND_BROWSER_REFRESH       = 3;
  WM_APPCOMMAND_BROWSER_STOP          = 4;
  WM_APPCOMMAND_BROWSER_SEARCH        = 5;
  WM_APPCOMMAND_BROWSER_FAVOURITES    = 6;
  WM_APPCOMMAND_BROWSER_HOME          = 7;
  WM_APPCOMMAND_VOLUME_MUTE           = 8;
  WM_APPCOMMAND_VOLUME_DOWN           = 9;
  WM_APPCOMMAND_VOLUME_UP             = 10;
  WM_APPCOMMAND_MEDIA_NEXTTRACK       = 11;
  WM_APPCOMMAND_MEDIA_PREVIOUSTRACK   = 12;
  WM_APPCOMMAND_MEDIA_STOP            = 13;
  WM_APPCOMMAND_MEDIA_PLAY_PAUSE      = 14;
  WM_APPCOMMAND_LAUNCH_MAIL           = 15;
  WM_APPCOMMAND_LAUNCH_MEDIA_SELECT   = 16;
  WM_APPCOMMAND_LAUNCH_APP1           = 17;
  WM_APPCOMMAND_LAUNCH_APP2           = 18;
  WM_APPCOMMAND_BASS_DOWN             = 19;
  WM_APPCOMMAND_BASS_BOOST            = 20;
  WM_APPCOMMAND_BASS_UP               = 21;
  WM_APPCOMMAND_TREBLE_DOWN           = 22;
  WM_APPCOMMAND_TREBLE_UP             = 23;

implementation

{ TcxKeyPlus }

constructor TcxKeyPlus.Create(AOwner: TComponent);
var
  vclIndex: Integer;
  vclInstance: Integer;
begin
  inherited Create(AOwner);

  { Only accept TForm as parent }
  if not(Owner is TForm) then
    raise EKeyPlusError.Create('cxKeyPlus must be placed on a Form!');

  { Only allow one instance }
  vclInstance := 0;
  for vclIndex := 0 to Owner.ComponentCount - 1 do
    if (Owner.Components[vclIndex] is TcxKeyPlus) then
      Inc(vclInstance);
  if (vclInstance > 1) then
    raise EKeyPlusError.Create('Only one instance of TcxKeyPlus allowed on form');

  { Hook the parent form's message loop }
  FOldWindowProcedure := TFarProc(GetWindowLong((Owner as TForm).Handle, GWL_WNDPROC));
  FNewWindowProcedure := MakeObjectInstance(HookedWindowProcedure);
  SetWindowLong((Owner as TForm).Handle, GWL_WNDPROC, LongInt(FNewWindowProcedure));

  { Set default state }
  FEnabled := TRUE;
end;

destructor TcxKeyPlus.Destroy;
begin
  { Unhook the parent form's message loop }
  if (Owner<>nil) and Assigned(FOldWindowProcedure) then
    SetWindowLong((Owner as TForm).Handle, GWL_WNDPROC, LongInt(FOldWindowProcedure));
  if Assigned(FNewWindowProcedure) then
    FreeObjectInstance(FNewWindowProcedure);
  { Clean up }
  inherited Destroy;
end;

procedure TcxKeyPlus.HookedWindowProcedure(var Msg: TMessage);
var
  Handled: Boolean;
  Sender: TObject;
  ShiftState: TShiftState;
begin
  with Msg do begin
    if (Msg = WM_APPCOMMAND) then begin
      { Get the window that originally received the message }
      Sender := TObject(FindControl(wParam));

      { Get the shift state }
      ShiftState := KeysToShiftState(lParamLo);

      { Process the command }
      Handled := FALSE;
      case (LParamHi and $FFF) of
        WM_APPCOMMAND_BROWSER_BACKWARD:     if Assigned(FOnBrowserBackward) and (Enabled) then begin
                                              FOnBrowserBackward(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BROWSER_FORWARD:      if Assigned(FOnBrowserForward) and (Enabled) then begin
                                              FOnBrowserForward(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BROWSER_REFRESH:      if Assigned(FOnBrowserRefresh) and (Enabled) then begin
                                              FOnBrowserRefresh(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BROWSER_STOP:         if Assigned(FOnBrowserStop) and (Enabled) then begin
                                              FOnBrowserStop(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BROWSER_SEARCH:       if Assigned(FOnBrowserSearch) and (Enabled) then begin
                                              FOnBrowserSearch(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BROWSER_FAVOURITES:   if Assigned(FOnBrowserFavourites) and (Enabled) then begin
                                              FOnBrowserFavourites(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BROWSER_HOME:         if Assigned(FOnBrowserHome) and (Enabled) then begin
                                              FOnBrowserHome(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_VOLUME_MUTE:          if Assigned(FOnVolumeMute) and (Enabled) then begin
                                              FOnVolumeMute(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_VOLUME_DOWN:          if Assigned(FOnVolumeDown) and (Enabled) then begin
                                              FOnVolumeDown(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_VOLUME_UP:            if Assigned(FOnVolumeUp) and (Enabled) then begin
                                              FOnVolumeUp(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_MEDIA_NEXTTRACK:      if Assigned(FOnMediaNextTrack) and (Enabled) then begin
                                              FOnMediaNextTrack(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_MEDIA_PREVIOUSTRACK:  if Assigned(FOnMediaPreviousTrack) and (Enabled) then begin
                                              FOnMediaPreviousTrack(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_MEDIA_STOP:           if Assigned(FOnMediaStop) and (Enabled) then begin
                                              FOnMediaStop(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_MEDIA_PLAY_PAUSE:     if Assigned(FOnMediaPlayPause) and (Enabled) then begin
                                              FOnMediaPlayPause(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_LAUNCH_MAIL:          if Assigned(FOnLaunchMail) and (Enabled) then begin
                                              FOnLaunchMail(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_LAUNCH_MEDIA_SELECT:  if Assigned(FOnLaunchMediaSelect) and (Enabled) then begin
                                              FOnLaunchMediaSelect(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_LAUNCH_APP1:          if Assigned(FOnLaunchApp1) and (Enabled) then begin
                                              FOnLaunchApp1(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_LAUNCH_APP2:          if Assigned(FOnLaunchApp2) and (Enabled) then begin
                                              FOnLaunchApp2(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BASS_DOWN:            if Assigned(FOnBassDown) and (Enabled) then begin
                                              FOnBassDown(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BASS_BOOST:           if Assigned(FOnBassBoost) and (Enabled) then begin
                                              FOnBassBoost(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_BASS_UP:              if Assigned(FOnBassUp) and (Enabled) then begin
                                              FOnBassUp(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_TREBLE_DOWN:          if Assigned(FOnTrebleDown) and (Enabled) then begin
                                              FOnTrebleDown(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
        WM_APPCOMMAND_TREBLE_UP:            if Assigned(FOnTrebleUp) and (Enabled) then begin
                                              FOnTrebleUp(Sender, ShiftState);
                                              Handled := TRUE;
                                            end;
      else
        { Unknown command - not handled here so bubble up the message Q }
        Handled := FALSE;
      end;
      Result := LongInt(Handled);
    end else
      { Not WM_APPCOMMAND - we're not interested }
      Result:=CallWindowProc(FOldWindowProcedure,(Owner as TForm).Handle, Msg, wParam, lParam);
  end;
end;

end.
