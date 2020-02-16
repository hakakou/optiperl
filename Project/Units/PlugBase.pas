{***************************************************************
 *
 * Unit Name: PlugBase
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}
 
unit PlugBase;

interface
 uses Classes,SysUtils,windows,PlugInFrm,hkActions;

 Const
  ppInitialization = 'Initialization';
  ppFinalization = 'Finalization';
  ppGetPlugInData = 'GetPlugInData';

  ppOnParseStart = 'OnParseStart';
  ppOnParseEnd = 'OnParseEnd';
  ppOnCanTerminate = 'OnCanTerminate';
  ppOnKeyEvent = 'OnKeyEvent';
  ppOnDocumentClose = 'OnDocumentClose';
  ppOnBeforeAction = 'OnBeforeAction';
  ppOnDocumentOpen = 'OnDocumentOpen';
  ppOnAfterAction = 'OnAfterAction';
  ppOnActiveDocumentChange = 'OnActiveDocumentChange';

 Type
  TPlugStatus = (psLoading,psRunning,psTerminating,psTerminated);

  TOnQueueEvent = Procedure of object;
  TOnWorkingToggle = Procedure(Sender : TObject; Status : TPlugStatus) of object;

  TPlugInClass = Class of TBasePlugIn;

  TBasePlugIn = Class
  protected
   FFilename : String;
   FOnWorkingToggle : TOnWorkingToggle;
   Procedure DoCreate; Virtual;
   Procedure DoDestroy; Virtual;
   Procedure QueueChanged; virtual;
  public
   MainToolbar : TObject;
   Links : TList;
   OnDestroyed : TNotifyEvent;
   HasOnKeyEvent : Boolean; //for speed
   Constructor Create(Const Filename : String; OnWorkingToggle : TOnWorkingToggle; MainBar : TObject);
   Destructor Destroy; override;

   Procedure RunCustom(const subname : string); virtual; abstract;
   Procedure TellToExitLoop; virtual;

   Procedure OnParseStart; virtual; abstract;
   Procedure OnParseEnd; virtual; abstract;
   Procedure OnActiveDocumentChange; virtual; abstract;
   Function OnCanTerminate : Boolean; virtual; abstract;
   Function OnKeyEvent(WParam, LParam : Cardinal) : Boolean; virtual; abstract;
   Function OnBeforeAction(const Action : String) : Boolean; virtual; abstract;
   Procedure OnAfterAction(const Action : String); virtual; abstract;
   Procedure OnDocumentClose(const Path : String); virtual; abstract;
   Function OnDocumentOpen(const Action : String) : Boolean; virtual; abstract;
  end;

var
 Running : TList;

implementation

{ TBasePlugIn }

procedure TBasePlugIn.DoCreate;
begin
end;

procedure TBasePlugIn.DoDestroy;
begin
end;

constructor TBasePlugIn.Create(Const Filename : String; OnWorkingToggle : TOnWorkingToggle; MainBar : TObject);
begin
 MainToolBar:=MainBar;
 FOnWorkingToggle:=OnWorkingToggle;
 if assigned(FOnWorkingToggle) then
  FOnWorkingToggle(self,psLoading);
 FFilename:=Filename;
 Links:=TList.Create;
 Running.add(self);
 DoCreate;
 if assigned(FOnWorkingToggle) then
  FOnWorkingToggle(self,psRunning);
end;

destructor TBasePlugIn.Destroy;
var
 i :Integer;
begin
 i:=Running.IndexOf(self);
 if i>=0 then
  Running.Delete(i);

 if assigned(FOnWorkingToggle) then
  FOnWorkingToggle(self,psTerminating);

 try
  DoDestroy;
 finally

  For i:=0 to Links.Count-1 do
   TObject(links[i]).Free;
  Links.Free;

  if assigned(OnDestroyed) then
   OnDestroyed(self);
  FreeAndNil(maintoolbar);
  if assigned(FOnWorkingToggle) then
   FOnWorkingToggle(self,psTerminated);
 end;  
end;

procedure TBasePlugIn.QueueChanged;
begin
end;

procedure TBasePlugIn.TellToExitLoop;
begin
end;

initialization
 Running:=TList.create;
finalization
 Running.free;
end.