unit SyntaxCheckMdl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ConsoleIO,optfolders,optmessages,optoptions,scriptinfounit, HKMessageRec,
  BUThreadTimer, ExtCtrls;

type
  TSyntaxCheckMod = class(TDataModule)
    GUI: TGUI2Console;
    HKMessageReceiver: THKMessageReceiver;
    Timer: TTimer;
    procedure HKMessageReceiverRequestAction(ID: Cardinal; Data: Variant);
    procedure TimerTimer(Sender: TObject);
    procedure GUIDone(Sender: TObject);
    procedure GUIError(Sender: TObject; const Error: String);
    procedure GUILine(Sender: TObject; const Line: String);
    procedure DataModuleCreate(Sender: TObject);
  private
    si:TScriptInfo;
    Executing : Boolean;
    LastName : string;
    procedure StartGUI;
  public
    { Public declarations }
  end;

var
  SyntaxCheckMod: TSyntaxCheckMod;

const
  ErrOut = '~OptiErr.txt';

implementation

{$R *.DFM}

{ TSyntaxCheckMod }

procedure TSyntaxCheckMod.StartGUI;
var s:string;
begin writeln(TimeToStr(time)+' TSyntaxCheckMod.StartGUI'); system.flush(system.output); writeln(TimeToStr(time)+' TSyntaxCheckMod.StartGUI'); flush(output); writeln(TimeToStr(time)+' TSyntaxCheckMod.StartGUI'); writeln('TSyntaxCheckMod.StartGUI');
 si:=TScriptInfo(RequestObject(HK_ActiveScript));
 if not Assigned(si) then Exit;
 GUI.Application:=Options.PathToPerl;
 GUI.HomeDirectory:=extractFIlePath(si.path);
 LastName:=extractFIlePath(si.path)+ErrOut;
 si.ms.SaveToFile(LastName);
 GUI.Command:='"'+lastname+'"';
 GUI.Start;
end;

procedure TSyntaxCheckMod.HKMessageReceiverRequestAction(ID: Cardinal;
  Data: Variant);
begin writeln(TimeToStr(time)+' TSyntaxCheckMod.HKMessageReceiverRequestAction'); system.flush(system.output); writeln(TimeToStr(time)+' TSyntaxCheckMod.HKMessageReceiverRequestAction'); flush(output); writeln(TimeToStr(time)+' TSyntaxCheckMod.HKMessageReceiverRequestAction'); writeln('TSyntaxCheckMod.HKMessageReceiverRequestAction');
 if id=HK_UPdateCodeExplorer then begin
  Timer.Enabled:=True;
 end;
end;

procedure TSyntaxCheckMod.TimerTimer(Sender: TObject);
begin writeln(TimeToStr(time)+' TSyntaxCheckMod.TimerTimer'); system.flush(system.output); writeln(TimeToStr(time)+' TSyntaxCheckMod.TimerTimer'); flush(output); writeln(TimeToStr(time)+' TSyntaxCheckMod.TimerTimer'); writeln('TSyntaxCheckMod.TimerTimer');
 if Executing then Exit;
 Executing:=True;
 Timer.Enabled:=False;
 StartGUI;
end;

procedure TSyntaxCheckMod.GUIDone(Sender: TObject);
begin writeln(TimeToStr(time)+' TSyntaxCheckMod.GUIDone'); system.flush(system.output); writeln(TimeToStr(time)+' TSyntaxCheckMod.GUIDone'); flush(output); writeln(TimeToStr(time)+' TSyntaxCheckMod.GUIDone'); writeln('TSyntaxCheckMod.GUIDone');
 Executing:=False;
end;

procedure TSyntaxCheckMod.GUIError(Sender: TObject; const Error: String);
begin writeln(TimeToStr(time)+' TSyntaxCheckMod.GUIError'); system.flush(system.output); writeln(TimeToStr(time)+' TSyntaxCheckMod.GUIError'); flush(output); writeln(TimeToStr(time)+' TSyntaxCheckMod.GUIError'); writeln('TSyntaxCheckMod.GUIError');
 Executing:=False;
end;

procedure TSyntaxCheckMod.GUILine(Sender: TObject; const Line: String);
begin writeln(TimeToStr(time)+' TSyntaxCheckMod.GUILine'); system.flush(system.output); writeln(TimeToStr(time)+' TSyntaxCheckMod.GUILine'); flush(output); writeln(TimeToStr(time)+' TSyntaxCheckMod.GUILine'); writeln('TSyntaxCheckMod.GUILine');
 ShowMessage(line);
end;

procedure TSyntaxCheckMod.DataModuleCreate(Sender: TObject);
begin writeln(TimeToStr(time)+' TSyntaxCheckMod.DataModuleCreate'); system.flush(system.output); writeln(TimeToStr(time)+' TSyntaxCheckMod.DataModuleCreate'); flush(output); writeln(TimeToStr(time)+' TSyntaxCheckMod.DataModuleCreate'); writeln('TSyntaxCheckMod.DataModuleCreate');
 Executing:=False;
end;

end.