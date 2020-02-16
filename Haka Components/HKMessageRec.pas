unit HKMessageRec;
{.$DEFINE STATS}
//remove the above on release versions of your program

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs;


type
  TOnReceiveMessage = Procedure(Msg : cardinal; WParam,LParam : Integer) of object;
  TOnRequestObject = Procedure(ID : Cardinal; var AObject : TObject) of object;
  TOnRequestString = Procedure(ID : Cardinal; var AString : string) of object;
  TOnRequestVariant = Procedure(ID : cardinal; var AVariant : Variant) of object;
  TOnRequestAction = Procedure(ID : cardinal; Data : Variant) of object;

  THKMessageReceiver = class(TComponent)
  private
    FActive,FHooked : boolean;
    FOnReceiveMessage :  TOnReceiveMessage;
    FOnRequestObject : TOnRequestObject;
    FOnRequestAction : TOnRequestAction;
    FOnRequestString: TOnRequestString;
    FOnRequestVariant : TOnRequestVariant;
    function AppWindowHook(var Message:TMessage) : boolean;
    {$IFDEF STATS}
    procedure StatMessage(Mes: Integer; SL: TStringList);
    {$ENDIF}
  public
    constructor Create(AOWner : TComponent); override;
    Destructor Destroy; override;
  published
    Property OnReceiveMessage : TOnReceiveMessage read FOnReceiveMessage write FOnReceiveMessage;
    Property OnRequestObject : TOnRequestObject read FOnRequestObject write FOnRequestObject;
    Property OnRequestString : TOnRequestString read FOnRequestString write FOnRequestString;
    Property OnRequestVariant : TOnRequestVariant read FOnRequestVariant write FOnRequestVariant;
    Property OnRequestAction : TOnRequestAction read FOnRequestAction write FOnRequestAction;
    Property Active : Boolean read FActive write FActive;
  end;

Function RequestObject(ID : Cardinal) : TObject;
Function RequestString(ID : Cardinal) : string;
Function RequestVariant(ID : Cardinal) : Variant;
Procedure RequestAction(ID : Cardinal; Data : Variant);

procedure Register;

implementation

Const
 HK_Strings = WM_User + $3000;
 HK_Objects = WM_User + $3001;
 HK_Actions = WM_User + $3002;
 HK_Variants = WM_User + $3003;

{$IFDEF STATS}
 var
  StringStats,ObjStats,ActionStats,VarStats : TStringList;
{$ENDIF}

Function RequestVariant(ID : Cardinal) : Variant;
var
 Res : Variant;
begin
 SendMessage(Application.handle,HK_Variants,ID,integer(@Res));
 result:=res;
end;

Procedure RequestAction(ID : Cardinal; Data : Variant);
begin
 SendMessage(Application.handle,HK_Actions,ID,integer(@Data));
end;

Function RequestObject(ID : Cardinal) : TObject;
var
 Res : TObject;
begin
 SendMessage(application.handle,HK_Objects,ID,integer(@Res));
 result:=res;
end;

Function RequestString(ID : Cardinal) : string;
var
 Res : String;
begin
 SendMessage(application.handle,HK_Strings,ID,integer(@res));
 Result:=res;
end;


procedure Register;
begin
  RegisterComponents('Haka', [THKMessageReceiver]);
end;

{ THKMessageReceiver }

{$IFDEF STATS}
Procedure THKMessageReceiver.StatMessage(Mes : Integer; SL : TStringList);
var
 i: integer;
begin
 i:=SL.IndexOf(inttostr(mes));
 if i<0
  then sl.AddObject(inttostr(mes),TObject(1))
  else sl.Objects[i]:=TObject(integer(sl.Objects[i])+1);
end;
{$ENDIF}

function THKMessageReceiver.AppWindowHook(var Message: TMessage): boolean;
var
 ResObject : ^TOBject;
 ResString : ^String;
 ResVariant : ^Variant;
begin
  with message do begin
    if (Msg>=WM_USER + $3000) and (Msg<=WM_USER+$3005) and (FActive) then
    begin
     case Msg of
     HK_Actions : begin
       if assigned(FOnRequestAction) then
       begin
         ResVariant:=Pointer(message.LParam);
         FOnRequestAction(Message.WParam,ResVariant^);
       end;
     {$IFDEF STATS}
      StatMessage(Message.WParam,ActionStats);
     {$ENDIF}
     end;

     HK_Variants : begin
       if assigned(FOnRequestVariant) then begin
         ResVariant:=ptr(message.LParam);
         FOnRequestVariant(Message.wParam,ResVariant^);
       end;
     {$IFDEF STATS}
      StatMessage(Message.WParam,VarStats);
     {$ENDIF}
     end;

     HK_Strings : begin
       If assigned(FOnRequestString) then begin
         ResString:=pointer(message.lparam);
         FOnRequestString(Message.wParam,ResString^);
       end;
     {$IFDEF STATS}
      StatMessage(Message.WParam,StringStats);
     {$ENDIF}
     end;

     HK_Objects : begin
       if assigned(FOnRequestObject) then begin
         ResObject:=ptr(message.LParam);
         FOnRequestObject(Message.wParam,ResObject^);
       end;
     {$IFDEF STATS}
      StatMessage(Message.WParam,ObjStats);
     {$ENDIF}
     end;

     else
      If Assigned(FOnReceiveMessage) then FOnReceiveMessage(msg,WParam,LParam)
     end;
    end;
    AppWindowHook:=false;
  end;
end;

constructor THKMessageReceiver.Create(AOWner: TComponent);
begin
 inherited create(AOwner);
 FActive:=true;
 if ComponentState=[] then begin
  Application.HookMainWindow(AppWindowHook);
  FHooked:=true;
 end else FHooked:=false;
end;

destructor THKMessageReceiver.Destroy;
begin
 if FHooked then Application.UnhookMainWindow(AppWindowHook);
 Inherited Destroy;
end;

{$IFDEF STATS}
procedure SaveStats(sl : TStringList; FN : String);
var i : integer;
begin
 sl.Sorted:=false;
 for i:=0 to Sl.Count-1 do
  sl[i]:=sl[i]+#9+inttostr(integer(sl.Objects[i]));
 sl.SaveToFile('c:\'+fn+'.csv');
end;

initialization
 StringStats:=TStringList.Create;
 StringStats.Sorted:=true;
 ObjStats:=TStringList.Create;
 ObjStats.Sorted:=true;
 ActionStats:=TStringList.Create;
 ActionStats.Sorted:=true;
 VarStats:=TStringList.Create;
 VarStats.Sorted:=true;
finalization
 SaveStats(StringStats,'Strings');
 SaveStats(ObjStats,'Objects');
 SaveStats(ActionStats,'Actions');
 SaveStats(VarStats,'Variants');
 StringStats.Free;
 ObjStats.Free;
 ActionStats.Free;
 VarStats.Free;
{$ENDIF}
end.
