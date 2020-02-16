unit PerformanceBar;
{
  Copyright 1998, Colosseum Builders, Inc.

  This software may be freely reistributed as long as this copyright notice
  is included and as long as modifications are documented at the top of the
  file.

  This software may be used under licence from Colosseum Builders, Inc. No
  transfer of ownership is made.

  This software may only be used on an "as-is" basis. There is no warranty of
  any kind.

  This software may only be included in other software if the author assumes
  all liability. Colosseum Builders, Inc. cannot ensure that its software will
  work correctly in any system.

  This software may be used without a fee in software that is distributed
  with complete source code to all users.

  Colosseum Builders, Inc
  E101 103 Park Ave
  Summit NJ 07901

  info@colosseumbuilders.com
}

{
  Title: TPerformanceBar Custom Control

  Description: This control displays a bar graph of a system performance
               statistics.

  Author:  John M. Miano miano@colosseumbuilders.com

  Properties:
    AlertColor: The forground color when the value exceeds AlertValue.
    AlertValue: When the statistic value exceeds this value AlertColor is used
                as the forground color.
    ForgroundColor:    The normal forground color.
    Interval:   The interval in milliseconds between updates.
    Orientations:  Determines if the graph is vertical or horizontal.
    ScaleMax: The range of the graph. This value is automatically made larger
              if the statistic value is greater than ScaleMax.
    Statistic: The statistic to measure.
    TextLabel: A label control used to display the statistic value.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Registry, ExtCtrls, StdCtrls ;

type

 TPerformanceBarOrientation =
  (
    pboHorizontal,
    pboVertical
   ) ;

TPerformanceBar = class(TGraphicControl)
  private
    FRegistry : TRegistry ;
    FStatistic : String ;
    FTimer : TTimer ;
    FTextLabel : TLabel ;
    FAlertColor : TColor ;
    FForgroundColor : TColor ;
    FInterval : Cardinal ;
    FOrientation : TPerformanceBarOrientation ;
    FScaleMax : Cardinal ;
    FAlertValue : Cardinal ;

    Procedure SetOrientation (Value : TPerformanceBarOrientation) ;
    Procedure SetInterval (value : Cardinal) ;
    Procedure SetStatistic (value : String) ;
    Procedure SetScaleMax (value : Cardinal) ;
    Procedure SetAlertValue(value : Cardinal) ;
    Procedure SetAlertColor(value : TColor) ;
    Procedure SetForgroundColor(value : TColor) ;

    { Private declarations }
  protected
    Procedure TimerHandler (Sender : TObject) ;
    Procedure Paint ; Override ;
    Procedure Notification (Component : TComponent ;
                            Operation : TOperation) ; Override ;
  public
    Constructor Create (Owner : TComponent) ; Override ;
    Destructor Destroy ; Override ;
    Procedure GetStatistics (statistics : TStrings) ;
  published
    Property Align ;
    Property AlertColor : TColor read FAlertColor write SetAlertColor ;
    Property AlertValue : Cardinal read FAlertValue write SetAlertValue ;
    Property Color ;
    Property Cursor ;
    Property DragCursor ;
    Property DragMode ;
    Property Enabled ;
    Property Font ;
    Property ForgroundColor : TColor read FForgroundColor
                                     write SetForgroundColor ;
    Property Hint ;
    Property Interval : Cardinal read FInterval write SetInterval ;
    Property Orientation : TPerformanceBarOrientation
                read FOrientation
                write SetOrientation
                default pboHorizontal ;
    Property ParentColor ;
    Property ParentFont ;
    Property ParentShowHint ;
    Property PopupMenu ;
    Property ScaleMax : Cardinal Read FScaleMax write SetScaleMax ;
    Property ShowHint ;
    Property Statistic : String read FStatistic write SetStatistic ;
    Property TextLabel : TLabel  read FTextLabel write FTextLabel ;
  end;

implementation

Constructor TPerformanceBar.Create (Owner : TComponent) ;
  Begin
  Inherited Create (Owner) ;
  FScaleMax := 100 ;
  FAlertvalue := 0 ;
  FInterval := 1000 ;

  FTextLabel := Nil ;
  FOrientation := pboHorizontal ;
  Height := 20 ;
  Width := 100 ;

  FForgroundColor := clGreen ;
  FAlertColor := clRed ;

  FRegistry := TRegistry.Create ;
  FRegistry.RootKey := HKEY_DYN_DATA ;

  If (csDesigning In ComponentState) Then
    Begin
    FTimer := Nil ;
    End
  Else
    Begin
    FTimer := TTimer.Create (self) ;
    FTimer.OnTimer := TimerHandler ;
    FTimer.Interval := FInterval ;
    End ;

  Statistic := 'KERNEL\CPUUsage' ;
  End ;

Destructor TPerformanceBar.Destroy ;
  Var
    Status : Bool ;
    Value : Cardinal ;
  Begin
  status := FRegistry.OpenKey ('PerfStats\StopStat', false) ;
  if (Not status) Then
    Raise Exception.Create ('TPerformanceBar: Can''t open registry key') ;
  FRegistry.ReadBinaryData (FStatistic, value, sizeof (value)) ;
  FRegistry.CloseKey () ;
  FRegistry.Free ;
  FTimer.Free ;
  Inherited Destroy ;
  End ;

Procedure TPerformanceBar.TimerHandler (Sender : TObject) ;
  Begin
  If Enabled Then
    Invalidate ;
  End ;

Procedure TPerformanceBar.Paint ;
  Var
    Status : Bool ;
    Value : Cardinal ;
  Procedure DrawHorizontalDesignMode ;
    Var
      Size : Cardinal ;
      Rect : TRect ;
    Begin
    If FAlertValue <> 0 Then
      size := Width * FAlertValue Div FScaleMax
    Else
      size := Width Div 2 ;
    Canvas.Brush.Color := FForgroundColor ;
    rect.Top := 0 ;
    rect.Left := 0 ;
    rect.Bottom := Height ;
    rect.Right := size ;
    Canvas.FillRect (rect) ;
    Canvas.Brush.Color := FAlertColor ;
    rect.Left := size ;
    rect.Right := Width ;
    Canvas.FillRect (rect) ;
    End ;
  Procedure DrawVerticalDesignMode ;
    Var
      Size : Cardinal ;
      Rect : TRect ;
    Begin
    If FAlertValue <> 0 Then
      size := Height - Height * FAlertValue Div FScaleMax 
    Else
      size := Height Div 2 ;
    Canvas.Brush.Color := FForgroundColor ;
    rect.Top := size ;
    rect.Left := 0 ;
    rect.Bottom := Height ;
    rect.Right := Width ;
    Canvas.FillRect (rect) ;
    Canvas.Brush.Color := FAlertColor ;
    rect.Top := 0 ;
    rect.Bottom := size ;
    Canvas.FillRect (rect) ;
    End ;
  Procedure DrawHorizontal ;
    Var
      Size : Cardinal ;
      Rect : TRect ;
    Begin
    size := Width * Value Div FScaleMax ;
    if (value < FAlertValue) Or (FAlertValue = 0) Then
      Canvas.Brush.Color := FForgroundColor
    else
      Canvas.Brush.Color := FAlertColor ;
    rect.Top := 0 ;
    rect.Left := 0 ;
    rect.Bottom := Height ;
    rect.Right := size ;
    Canvas.FillRect (rect) ;
    Canvas.Brush.Color := Color ;
    rect.Left := size ;
    rect.Right := Width ;
    Canvas.FillRect (rect) ;
    End ;
  Procedure DrawVertical ;
    Var
      Size : Cardinal ;
      Rect : TRect ;
    Begin
    size := Height - Height * value Div FScaleMax ;
    if (value < FAlertValue) Or (FAlertValue = 0) Then
      Canvas.Brush.Color := FForgroundColor
    else
      Canvas.Brush.Color := FAlertColor ;
    rect.Top := size ;
    rect.Left := 0 ;
    rect.Bottom := Height ;
    rect.Right := Width ;
    Canvas.FillRect (rect) ;
    Canvas.Brush.Color := Color ;
    rect.Top := 0 ;
    rect.Bottom := size ;
    Canvas.FillRect (rect) ;
    End ;
  Begin
  If csDesigning In ComponentState Then
    Case FOrientation Of
    pboHorizontal: DrawHorizontalDesignMode ;
    pboVertical : DrawVerticalDesignMode ;
    Else Raise Exception.Create (
                   'TPerformanceBar INTERNAL ERROR: Invalid Orientation') ;
    End
  Else If Enabled Then
    Begin
    Status := FRegistry.OpenKey ('PerfStats\StatData', false) ;
    if (Not status) Then
      Raise Exception.Create ('TPerformanceBar: Can''t open registry key') ;
    FRegistry.ReadBinaryData (FStatistic, value, sizeof (value)) ;
    Fregistry.CloseKey  ;
    Case FOrientation Of
      pboHorizontal: DrawHorizontal ;
      pboVertical: DrawVertical ;
      Else Raise Exception.Create (
                   'TPerformanceBar INTERNAL ERROR: Invalid Orientation') ;
      End ;
    if (Assigned (FTextLabel)) Then
      FTextLabel.Caption := IntToStr (Value) ;
    End ;
  End ;

Procedure TPerformanceBar.Notification (Component : TComponent ;
                                        Operation : TOperation) ;
  Begin
  If Operation = opRemove Then
    If Component = FTextLabel Then
      FTextLabel := Nil ;
  End ;
Procedure TPerformanceBar.SetOrientation (Value : TPerformanceBarOrientation) ;
  Begin
  If FOrientation = Value Then
    Exit ;
  FOrientation := Value ;
  Invalidate ;
  End ;

Procedure TPerformanceBar.SetInterval (value : Cardinal) ;
  Begin
  If FInterval = Value Then
    Exit ;
  FInterval := Value ;
  Invalidate ;
  End ;

Procedure TPerformanceBar.SetStatistic (value : String) ;
  Var
    II : Integer ;
    Status : Boolean ;
    BValue : Cardinal ;
    List : TStringList ;
  Begin
  If FStatistic = Value Then
    Exit ;

  list := TStringList.Create ;
{
  status := FRegistry.OpenKey ('PerfStats\StartStat', false) ;
  FRegistry.GetValueNames (list) ;
  FRegistry.CloseKey () ;
}
  GetStatistics (list) ;
  for II := 0 To List.Count - 1 Do
    Begin
    if Uppercase (list [ii])= UpperCase (value) Then
      Begin
      if FStatistic <> '' Then
        Begin
        status := FRegistry.OpenKey ('PerfStats\StopStat', false) ;
        if (Not status) Then
          raise Exception.Create ('TPerformanceBar: Can''t open registry key') ;
         FRegistry.ReadBinaryData (FStatistic, bvalue, sizeof (bvalue)) ;
         FRegistry.CloseKey ;
        End ;
      FStatistic := value ;
      status := FRegistry.OpenKey ('PerfStats\StartStat', false) ;
      if (Not status) Then
        raise Exception.Create ('TPerformanceBar: Can''t open registry key') ;
      FRegistry.ReadBinaryData (FStatistic, bvalue, sizeof (bvalue)) ;
      FRegistry.CloseKey ;
      list.Free ;
      Invalidate ;
      Exit ;
    End ;
  End ;
  List.Free ;
  raise Exception.Create ('TPerformanceBar:  Invalid Statistic') ;
  End ;

Procedure TPerformanceBar.SetScaleMax (value : Cardinal) ;
  Begin
  If FScaleMax = Value Then
    Exit ;
  FScaleMax := Value ;
  Invalidate ;
  End ;

Procedure TPerformanceBar.SetAlertValue(value : Cardinal) ;
  Begin
  If FAlertValue = Value Then
    Exit ;
  FAlertValue := Value ;
  Invalidate ;
  End ;

Procedure TPerformanceBar.SetAlertColor(value : TColor) ;
  Begin
  If FAlertColor = Value Then
    Exit ;
  FAlertColor := Value ;
  Invalidate ;
  End ;

Procedure TPerformanceBar.SetForgroundColor(value : TColor) ;
  Begin
  If FForgroundColor = Value Then
    Exit ;
  FForgroundColor := Value ;
  Invalidate ;
  End ;

Procedure TPerformanceBar.GetStatistics (statistics : TStrings) ;
  Begin
  FRegistry.OpenKey ('PerfStats\StartStat', false) ;
  FRegistry.GetValueNames (statistics) ;
  FRegistry.CloseKey () ;
  End ;

end.
