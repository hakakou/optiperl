unit HKActions;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList;

type

  TOnBeforeActionEvent = Function(Sender : TObject) : Boolean of object;

  THKAction = class(TAction)
  private
   FUserData : Integer;
  public
   function Execute: Boolean; override;
   function SimpleExecute: Boolean;
  published
   property UserData : Integer read FUserData write FUserData;
  end;

var
 GlobalBeforeActionEvent : TOnBeforeActionEvent;
 GlobalAfterActionEvent : TNotifyEvent;

implementation

function THKAction.Execute: Boolean;
begin
 if assigned(GlobalBeforeActionEvent) then
  if not GlobalBeforeActionEvent(self) then
  begin
   result:=false;
   exit;
  end;
 try
  result:=inherited Execute;
 finally
  if assigned(GlobalAfterActionEvent) then
   GlobalAfterActionEvent(self);
 end;
end;

function THKAction.SimpleExecute: Boolean;
begin
 result:=inherited Execute;
end;

end.
