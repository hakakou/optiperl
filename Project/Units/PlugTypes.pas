{***************************************************************
 *
 * Unit Name: PlugTypes
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}
 
unit PlugTypes;

{$I REG.INC}

interface

 uses classes,Messages,Sysutils,windows,perlApi,hyperstr,diPcre,hakafile,plugbase,dialogs,
      Forms,hakageneral,plugCommon,HakaMemMapFile,Hakawin, OptGeneral,HyperFrm,PerlHelpers,
      OptForm, OptProcs, aqDockingBase, OptOptions, HakaSync, OptiClient_TLB;

 type
  TPerlEmbPlugIn = Class(TBasePlugIn)
  private
  protected
   Perl : TPerlEvents;
   Function RunSubroutine(const sub: String; Argv : PPcharArray; Force : Boolean) : String; Virtual;
   Function RunIntFunc(const sub: String; Argv : PPcharArray; Force : Boolean; Default : Integer) : Integer; Virtual;
   Procedure DoCreate; override;
   Procedure DoDestroy; override;
  public
   Procedure RunCustom(const subname : string); Override;

   Procedure OnParseStart; override;
   Procedure OnParseEnd; override;
   Procedure OnActiveDocumentChange; override;
   Function OnCanTerminate : Boolean; override;
   Function OnKeyEvent(WParam, LParam : Cardinal) : Boolean; override;
   Function OnBeforeAction(const Action : String) : Boolean; Override;
   Procedure OnAfterAction(const Action : String); Override;
   Procedure OnDocumentClose(const Path : String); Override;
   Function OnDocumentOpen(const Action : String) : Boolean; Override;
  end;

  TPerlPrPlugIn = Class(TPerlEmbPlugIn)
  private
   Subroutines : TStringList;
  protected
   Procedure QueueChanged; override;
   Procedure DoCreate; override;
   Procedure DoDestroy; override;
   Function RunSubroutine(const sub: String; Argv : PPcharArray; Force : Boolean) : String; Override;
   Function RunIntFunc(const sub: String; Argv : PPcharArray; Force : Boolean; Default : Integer) : Integer; Override;
  public
   OLE : IOptiPerlClient;
   Procedure TellToExitLoop; Override;
  end;

  TDLLPlugIn = Class(TBasePlugIn)
  private
   FModule : Cardinal;
   PInitialization : Procedure(PlugID : Cardinal); stdcall;
   PFinalization: Procedure; stdcall;
   POnParseStart: Procedure; stdcall;
   POnActiveDocumentChange: Procedure; stdcall;
   POnParseEnd: Procedure; stdcall;
   POnCanTerminate : Function : Boolean; stdcall;
   POnKeyEvent : Function(WParam, LParam : Cardinal) : Boolean; stdcall;
   POnBeforeAction : Function(const Action : String) : Boolean; stdcall;
   POnAfterAction: Procedure(const Action : String); stdcall;
   POnDocumentClose: Procedure(const Action : String); stdcall;
   POnDocumentOpen : Function(const Action : String) : Boolean; stdcall;
  protected
   Procedure DoCreate; override;
   Procedure DoDestroy; override;
  public
   Procedure RunCustom(const subname : string); Override;

   Procedure OnActiveDocumentChange; override;
   Procedure OnParseStart; override;
   Procedure OnParseEnd; override;
   Function OnCanTerminate : Boolean; override;
   Function OnKeyEvent(WParam, LParam : Cardinal) : Boolean; override;
   Function OnBeforeAction(const Action : String) : Boolean; Override;
   Procedure OnAfterAction(const Action : String); Override;
   Procedure OnDocumentClose(const Path : String); Override;
   Function OnDocumentOpen(const Action : String) : Boolean; Override;
  end;

  TPerlPrTerminateThread = class(TThread)
  private
   PID : Integer;
  protected
   procedure Execute; override;
  public
   constructor Create(APid : Integer);
  end;

function GetPlugInData(Const Filename : String; out PlugName, PlugDesc, Icon, Button, Extensions: String): Boolean;

var
 GrabbedHandle : Thandle;

implementation

{ TPerlEmbPlugIn }

procedure TPerlEmbPlugIn.OnAfterAction(const Action: String);
var
 pc : TPcharArray;
begin
 pc[0]:=pchar(Action);
 pc[1]:=nil;
 RunSubroutine(ppOnAfterAction,@pc,false);
end;

function TPerlEmbPlugIn.OnDocumentOpen(const Action: String): Boolean;
var
 pc : TPcharArray;
begin
 pc[0]:=pchar(Action);
 pc[1]:=nil;
 Result:=RunIntFunc(ppOnDocumentOpen,@pc,false,1)=1;
end;

function TPerlEmbPlugIn.OnBeforeAction(const Action: String): Boolean;
var
 pc : TPcharArray;
begin
 pc[0]:=pchar(Action);
 pc[1]:=nil;
 Result:=RunIntFunc(ppOnBeforeAction,@pc,false,1)=1;
end;

function TPerlEmbPlugIn.OnCanTerminate: Boolean;
begin
 result:=RunIntFunc(ppOnCanTerminate,nil,false,1)=1;
end;

procedure TPerlEmbPlugIn.OnDocumentClose(const Path: String);
var
 pc : TPcharArray;
begin
 pc[0]:=pchar(Path);
 pc[1]:=nil;
 RunSubroutine(ppOnDocumentClose,@pc,false);
end;

function TPerlEmbPlugIn.OnKeyEvent(WParam, LParam: Cardinal): Boolean;
var
 ARGV : TPcharArray;
begin
 Argv[0]:=PAnsiChar(inttostr(WParam));
 Argv[1]:=PAnsiChar(InttoStr(LParam));
 Argv[2]:=nil;
 result:=RunIntFunc(ppOnKeyEvent,@Argv,false,1)=1;
end;

procedure TPerlEmbPlugIn.OnParseEnd;
begin
 RunSubroutine(ppOnParseEnd,nil,false);
end;

procedure TPerlEmbPlugIn.OnParseStart;
begin
 RunSubroutine(ppOnParseStart,nil,false);
end;

procedure TPerlEmbPlugIn.DoCreate;
begin
 if not fileexists(PerlApi.PerlDllFile) then
  raise EPerlRunError.Create(PerlDLLBadStr);

 Perl:=TPerlEvents.Create(FFilename);
 perl.Debug:=true;
 perl.SelfStr:=inttostr(integer(self));
 Perl.Initialize;
 HasOnKeyEvent:=perl.Subroutines.indexof(ppOnKeyEvent)>=0;
end;

procedure TPerlEmbPlugIn.DoDestroy;
begin
 Perl.free;
end;

procedure TPerlEmbPlugIn.RunCustom(const subname: string);
begin
 RunSubroutine(subname,nil,true);
end;

function TPerlEmbPlugIn.RunIntFunc(const sub: String; Argv: PPcharArray;
  Force: Boolean; Default : Integer): Integer;
begin
 if (force) or (perl.HasSub(sub))
 then
  result:=perl.RunIntFunction(sub,argv)
 else
  result:=Default;
end;

function TPerlEmbPlugIn.RunSubroutine(const sub: String; Argv: PPcharArray;
  Force: Boolean): String;
begin
 if (force) or (perl.HasSub(sub)) then
  perl.RunSubroutine(sub,argv);
end;

procedure TPerlEmbPlugIn.OnActiveDocumentChange;
begin
 RunSubroutine(ppOnActiveDocumentChange,nil,false);
end;

{ TDLLPlugIn }

procedure TDLLPlugIn.DoCreate;
begin
 FModule:=LoadLibrary(pchar(FFilename));
 if FModule=0 then exit;

 @PInitialization:=GetProcAddress(FModule,ppInitialization);
 @PFinalization:=GetProcAddress(FModule,ppFinalization);
 @POnCanTerminate:=GetProcAddress(FModule,ppOnCanTerminate);
 @POnKeyEvent:=GetProcAddress(FModule,ppOnKeyEvent);
 @POnParseStart:=GetProcAddress(FModule,ppOnParseStart);
 @POnParseEnd:=GetProcAddress(FModule,ppOnParseEnd);
 @POnBeforeAction:=GetProcAddress(FModule,ppOnBeforeAction);
 @POnAfterAction:=GetProcAddress(FModule,ppOnAfterAction);
 @POnDocumentClose:=GetProcAddress(FModule,ppOnDocumentClose);
 @POnDocumentOpen:=GetProcAddress(FModule,ppOnDocumentOpen);
 @POnActiveDocumentChange:=GetProcAddress(FModule,ppOnActiveDocumentChange);

 if assigned(@PInitialization) then
  PInitialization(Cardinal(Self));
 HasOnKeyEvent:=Assigned(@POnKeyEvent);
end;

procedure TDLLPlugIn.DoDestroy;
begin
 if assigned(@PFinalization) then
  PFinalization;
 if (FModule<>0) then
  FreeLibrary(FModule);
end;

procedure TDLLPlugIn.OnActiveDocumentChange;
begin
 if assigned(@POnActiveDocumentChange) then
  POnActiveDocumentChange;
end;

procedure TDLLPlugIn.OnAfterAction(const Action: String);
begin
 if assigned(@POnAfterAction) then
  POnAfterAction(action);
end;

function TDLLPlugIn.OnBeforeAction(const Action: String): Boolean;
begin
 if assigned(@POnBeforeAction)
  then result:=POnBeforeAction(action)
  else result:=true;
end;

function TDLLPlugIn.OnCanTerminate: Boolean;
begin
 if assigned(@POnCanTerminate)
  then result:=POnCanTerminate
  else result:=true;
end;

procedure TDLLPlugIn.OnDocumentClose(const Path: String);
begin
 if assigned(@POnDocumentClose) then
  POnDocumentClose(path);
end;

function TDLLPlugIn.OnDocumentOpen(const Action: String): Boolean;
begin
 if assigned(@POnDocumentOpen)
  then result:=POnDocumentOpen(action)
  else result:=true;
end;

function TDLLPlugIn.OnKeyEvent(WParam, LParam: Cardinal): Boolean;
begin
 if assigned(@POnKeyEvent)
  then result:=POnKeyEvent(WParam,LParam)
  else result:=true;
end;

procedure TDLLPlugIn.OnParseEnd;
begin
 if assigned(@POnParseEnd) then
  POnParseEnd;
end;

procedure TDLLPlugIn.OnParseStart;
begin
 if assigned(@POnParseStart) then
  POnParseStart;
end;

procedure TDLLPlugIn.RunCustom(const subname: string);
var
 PCustom: Procedure; stdcall;
begin
 @PCustom:=GetProcAddress(FModule,pchar(subname));
 if assigned(@PCustom)
  then PCustom
  else MessageDlg('Could not find implementation of '+subname, mtError, [mbOK], 0);
end;

{ TPerlPrPlugIn }

procedure TPerlPrPlugIn.DoCreate;
begin
 if not fileexists(PerlApi.PerlDllFile) then
  raise EPerlRunError.Create(PerlDLLBadStr);
 Ole := CoOptiPerlClient.create;
 Ole.InitOptions(options.PerlDLL,Application.MainForm.Handle,FFilename,Integer(self));
 Subroutines:=TStringList.Create;
 Subroutines.Text:=ole.Subroutines;
 Ole.Start;
 HasOnKeyEvent:=Subroutines.indexof(ppOnKeyEvent)>=0;
end;

procedure TPerlPrPlugIn.DoDestroy;
begin
 Subroutines.free;
 Assert(false,'LOG Term 1');
 Ole:=nil;
 Assert(false,'LOG Term 2');
end;

function TPerlPrPlugIn.RunSubroutine(const sub: String; Argv: PPcharArray;
  Force: Boolean): String;
begin
 if (not Force) and (subroutines.IndexOf(sub)<0) then exit;
 if not assigned(OLE) then exit;
 if Argv=nil then
  OLE.runSub0(sub)
 else
 if Argv[1]=nil then
  Ole.RunSub1(sub,Argv[0])
 else
 if Argv[2]=nil then
  Ole.RunSub2(sub,Argv[0],Argv[1])
 else
 Assert(false);
end;

function TPerlPrPlugIn.RunIntFunc(const sub: String; Argv: PPcharArray;
  Force: Boolean; Default: Integer): Integer;
begin
 result:=default;
 if (not Force) and (subroutines.IndexOf(sub)<0) then exit;
 if not assigned(OLE) then exit;

 if Argv=nil then
  result:=OLE.runInt0(sub)
 else
 if Argv[1]=nil then
  result:=Ole.RunInt1(sub,Argv[0])
 else
 if Argv[2]=nil then
  result:=Ole.RunInt2(sub,Argv[0],Argv[1])
 else
 Assert(false);
end;

procedure TPerlPrPlugIn.QueueChanged;
begin
 TellToExitLoop;
end;

procedure TPerlPrPlugIn.TellToExitLoop;
begin
// PostMessage(sharemem.Handle,WM_NULL,0,0);
end;

//GetPlugInData

function GetPlugInData(Const Filename : String; out PlugName, PlugDesc, Icon, Button, Extensions: String): Boolean;
var
 fil : TextFile;
 lines : Integer;
 s,ext,f1,f2:string;
 p1,p2,p3,p4 : PAnsichar;
 Pcre : TDiPcre;
 module : cardinal;
 PGetPlugInData : Procedure(var Name,Description,Button,Extensions : PChar); stdcall;
begin
 result:=false;
 Ext:=UpFileExt(FIlename);

 if (ext='CGI') or (ext='PL') then
  begin
   result:=true;
   PlugName:=ExtractFileNoExt(Filename);
   PlugDesc:='Executes '+Filename;
   Icon:='';

   try
    assignfile(fil,Filename);
    reset(fil);
   except on exception do exit end;

   Lines:=0;
   Pcre:=TDIPcre.Create(nil);
   Pcre.MatchPattern:='^\s*#\s*(description|name|icon|button|extensions)\s*:\s*(.*)';
   try
    while (lines<=5) do
    begin
     readln(fil,s);
     Pcre.SetSubjectStr(s);
     if pcre.match=3 then
     begin
      f1:=lowercase(pcre.SubStr(1));
      f2:=trim(pcre.SubStr(2));
      if f1='description' then PlugDesc:=f2;
      if f1='name' then PlugName:=f2;
      if f1='icon' then icon:=f2;
      if f1='button' then Button:=f2;
      if f1='extensions' then Extensions:=f2;
     end;
     inc(lines);
    end;

   finally
    Pcre.free;
    closefile(fil);
   end;
  end

 else
 if (ext='OPP') then
  begin
   Icon:=Filename+',0';
   Module:=LoadLibrary(pchar(Filename));
   if Module=0 then exit;
   @PGetPlugInData:=GetProcAddress(Module,ppGetPlugInData);
   if @PGetPlugInData<>Nil then
   begin
    PGetPlugInData(p1,p2,p3,p4);
    PlugName:=p1;
    PlugDesc:=p2;
    Button:=p3;
    Extensions:=p4;
    result:=true;
   end;
   FreeLibrary(Module);
  end;
end;

{ TPerlPrTerminateThread }

constructor TPerlPrTerminateThread.Create(APid: Integer);
begin
 Inherited create(true);
 Pid:=APid;
 FreeOnTerminate:=true;
 Resume;
end;

procedure TPerlPrTerminateThread.Execute;
begin
 sleep(1500);
 Pid:=OpenProcess(PROCESS_ALL_ACCESS,false,Pid);
 if Pid>0 then
  TerminateProcess(Pid,0);
end;

end.