unit HKRichEditUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,RxRichEd;

type
  THKRichEdit = class(TRxRichEdit)
  private
    FRow: Longint;
    FColumn: Longint;
    FOnHScroll: TNotifyEvent;
    FOnVScroll: TNotifyEvent;
    FCaretMove : TNotifyEvent;
    procedure WMHScroll(var Msg: TWMHScroll); message WM_HSCROLL;
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
    procedure SetRow(Value: Longint);
    procedure SetColumn(Value: Longint);
    function GetRow: Longint;
    function GetColumn: Longint;
    function GetRealSelStart : Integer;
  protected
    // Event dispatching methods
    procedure HScroll;
    procedure VScroll;
  public
    property Row: Longint read GetRow write SetRow;
    property Column: Longint read GetColumn write SetColumn;
    property RealSelStart : Longint read GetRealSelStart;
  published
    property OnHScroll: TNotifyEvent read FOnHScroll write FOnHScroll;
    property OnVScroll: TNotifyEvent read FOnVScroll write FOnVScroll;

  end;

  procedure Register;


implementation


procedure THKRichEdit.WMHScroll(var Msg: TWMHScroll);
begin
  inherited;
  HScroll;
end;

procedure THKRichEdit.WMVScroll(var Msg: TWMVScroll);
begin
  inherited;
  VScroll;
end;

procedure THKRichEdit.HScroll;
begin
  if Assigned(FOnHScroll) then
    FOnHScroll(self);
end;

procedure THKRichEdit.VScroll;
begin
  if Assigned(FOnVScroll) then
    FOnVScroll(self);
end;

procedure THKRichEdit.SetRow(Value: Longint);
begin
  SelStart := Perform(EM_LINEINDEX, Value, 0);
  FRow := SelStart;
end;

function THKRichEdit.GetRow: Longint;
begin
  Result := Perform(EM_LINEFROMCHAR, -1, 0);
end;

procedure THKRichEdit.SetColumn(Value: Longint);
begin
  FColumn := Perform(EM_LINELENGTH, Perform(EM_LINEINDEX, GetRow, 0), 0);
  if FColumn > Value then
    FColumn := Value;
  SelStart := Perform(EM_LINEINDEX, GetRow, 0) + FColumn;
end;

function THKRichEdit.GetColumn: Longint;
begin
  Result := SelStart - Perform(EM_LINEINDEX, -1, 0);
end;


procedure Register;
begin
  RegisterComponents('Haka', [THKRichEdit]);
end;


function THKRichEdit.GetRealSelStart: Integer;
begin
 result:=getrow+selstart;
end;

end.
