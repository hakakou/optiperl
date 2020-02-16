unit HKEvents;

interface
uses SysUtils,Controls,classes;

Type
   TProc_Nil = Procedure of object;
   TFunc_Nil_Bool = Function : Boolean of object;
   TProc_Int = Procedure(Int : Integer) of object;
   TFunc_Int_Bool = Function(Int : Integer) : Boolean;

   TEventReceiver = class(TComponent)
   public
    constructor Create(AOwner : TComponent);
    Destructor Destroy; Override;
    Procedure HookEvent(EventNum : integer; Proc : TProc_Nil);
   end;


Procedure TriggerEvent(EventNum : Integer);

implementation

Var EventArray : Array of TList;

Procedure TriggerEvent(EventNum : Integer);
begin

end;


{ TEventReceiver }

constructor TEventReceiver.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
end;

destructor TEventReceiver.Destroy;
begin
 inherited Destroy;
end;

end.
