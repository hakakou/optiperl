unit PerlApi;

interface
uses windows,classes,sysutils,syncobjs,DIpcre;

// http://aspn.activestate.com/ASPN/docs/ActivePerl/5.10/lib/pods/perlapi.html
// http://aspn.activestate.com/ASPN/docs/ActivePerl/5.10/lib/pods/perlembed.html

 type
  EPerlRunError = Class(Exception);
  EPerlGetVarError = Class(Exception);

  PPcharArray = ^TPcharArray;
  TPcharArray = Array [0..10] of Pchar;
  PDynPcharArray = ^TPcharArray;
  TDynPcharArray = Array of Pchar;

  PPSV = ^PSv;
  PSv = ^TSv;
  TSv = Packed Record
   sv_any : pointer	;		//* pointer to something */
   sv_refcnt: Cardinal;	//* how many references to us */
   sv_flags: Cardinal;	//* what we are */
   perl510pchar : pchar;
  end;

  Pxpv = ^Txpv;
  Txpv = Packed Record
    xpv_pv : pchar;		//* pointer to malloced string */
    xpv_cur : Cardinal	;	//* length of xpv_pv as a C string */
    xpv_len : Cardinal	;	//* allocated size */
  end;

  Pxpviv = ^Txpviv;
  Txpviv = Record
   xpv_pv : pchar;		//* pointer to malloced string */
   xpv_cur: Cardinal;	//* length of xpv_pv as a C string */
   xpv_len: Cardinal;	//* allocated size */
   xiv_iv : Integer;		//* integer value or pv offset */
  end;
  
  PPop = ^Pop;
  POp = ^TOp;
  TOp = Packed Record
    op_next : POp;
    op_sibling : POp;
    op_ppaddr : Pop;
    op_targ : Cardinal;
    op_type : Word;
    op_seq : Word;
    op_flags : Byte;
    op_private : Byte;
  end;

  PIPerlProc = ^TIPerlProc;     //iperlsys.h
  TIPerlProc = Record
     pAbort: Pointer;
     pCrypt: Pointer;
     pExit: Pointer;
     p_Exit: Pointer;
     pExecl: Pointer;
     pExecv: Pointer;
     pExecvp: Pointer;
     pGetuid: Pointer;
     pGeteuid: Pointer;
     pGetgid: Pointer;
     pGetegid: Pointer;
     pGetlogin: Pointer;
     pKill: Pointer;
     pKillpg: Pointer;
     pPauseProc: Pointer;
     pPopen: Pointer;
     pPclose: Pointer;
     pPipe: Pointer;
     pSetuid: Pointer;
     pSetgid: Pointer;
     pSleep: Pointer;
     pTimes: Pointer;
     pWait: Pointer;
     pWaitpid: Pointer;
     pSignal: Pointer;
     pFork: Pointer;
     pGetpid: Pointer;
     pDynaLoader: Pointer;
     pGetOSError: Pointer;
     pSpawnvp: Pointer;
     pLastHost: Pointer;
     pPopenList: Pointer;
     pGetTimeOfDay: Pointer;
  end;

  PPerlInterpreter58 = ^TPerlInterpreter58;   //      intpvar.h
  TPerlInterpreter58 = Record
   TStack_sp : PPSv;
   Top : POp;
   Tcurpad:	PPSV;	//* active pad (lexicals+tmps) */
   Tstack_base:	PPSV;
   Tstack_max:	PPSV;
   Tscopestack:	Pointer;   //* scopes we've ENTERed */
   Tscopestack_ix:	Cardinal;
   Tscopestack_max:Cardinal;
   Tsavestack:	Pointer;
   Tsavestack_ix:	Cardinal;
   Tsavestack_max:	Cardinal;
   Ttmps_stack:	PPSv;
   Ttmps_ix:	Cardinal;
   Ttmps_floor:	Cardinal;
   Ttmps_max :	Cardinal;
   Tmarkstack :	Pointer;		//* stack_sp locations we're remembering */
   Tmarkstack_ptr :	Cardinal;
   Tmarkstack_max:	Cardinal;
   //   Imodcount :	Cardinal;  //New in Perl510
   Tretstack : PPOP;		//* OPs we have postponed executing */
   Tretstack_ix:	Cardinal;
   Tretstack_max :	Cardinal;

   //the next two are removed in 510
   TSv: PSV;		//* used to hold temporary values */
   TXpv: PXPV;		//* used to hold temporary values */

   //And a hell of alot more!
   Pad1 : array[1..$2B0] of byte;
   Iperl_destruct_level : Integer;  // offset : $30c
   Pad2 : array[1..$14f] of byte;
   Isys_intern : PIPerlProc;              // offset : $bfc
  end;

  PPerlInterpreter = PPerlInterpreter58;
  PInteger = ^Integer;

 var
  perl_alloc:
   function : PPerlInterpreter; cdecl;
  perl_alloc_using :
   function (ipM : Pointer; ipMS : Pointer; ipMP : Pointer; ipE : Pointer;
		ipStd : Pointer; ipLIO : Pointer; ipD : Pointer; ipS : Pointer;
		ipP : PIperlProc): PPerlInterpreter; cdecl;
  perl_get_host_info :
   Procedure (perlMemInfo : Pointer; perlMemSharedInfo : Pointer;
              perlMemParseInfo : Pointer; perlEnvInfo : Pointer;
          		perlStdIOInfo : Pointer; perlLIOInfo : Pointer;
              perlDirInfo : Pointer; perlSockInfo : Pointer;
          		perlProcInfo : PIperlProc); cdecl;
  boot_DynaLoader:
   procedure (interp: PPerlInterpreter; cv : pointer); cdecl;
  perl_construct:
   procedure (interp: PPerlInterpreter); cdecl;
  perl_destruct:
   function (interp: PPerlInterpreter): Integer; cdecl;
  perl_free:
   procedure (interp: PPerlInterpreter); cdecl;
  perl_run:
   function (interp: PPerlInterpreter): Integer; cdecl;
  perl_parse:
   function (interp: PPerlInterpreter; xsinit: pointer; argc: Integer;
             argv,env : PPcharArray) : Integer; cdecl;
  Perl_eval_pv:
   Function (interp: PPerlInterpreter; p : Pchar; croak_on_error: LongBool) : PSV; cdecl;
  Perl_eval_sv:
   Function (interp: PPerlInterpreter; SV : PSV; Flags: Integer) : Integer; cdecl;
  Perl_newXS:
   function(interp : PPerlInterpreter; name : Pchar; f : Pointer;
            filename : Pchar) : Pointer; cdecl;
  Perl_get_sv:
   Function(interp: PPerlInterpreter; name : Pchar; create : LongBool) : PSV; cdecl;
  Perl_sv_2pv_flags :
   function(interp: PPerlInterpreter; sv : PSV; lp : pointer; flags : Integer) : Pchar; cdecl;
  Perl_set_context:
   procedure(interp: PPerlInterpreter); cdecl;
  Perl_call_argv:
   Function(interp: PPerlInterpreter; sub_name : Pchar; Flags : Integer;
            argv : PPcharArray) : LongBool; cdecl;
  Perl_free_tmps :
   procedure(interp: PPerlInterpreter); cdecl;
  Perl_pop_scope :
   procedure(interp: PPerlInterpreter); cdecl;
  Perl_Push_scope :
   procedure(interp: PPerlInterpreter); cdecl;
  Perl_sv_setpv :
   procedure(interp: PPerlInterpreter; SV : PSV; Value : PChar); cdecl;
  Perl_markstack_grow :
   procedure(interp: PPerlInterpreter); cdecl;
  Perl_sv_2iv :
   Function(interp: PPerlInterpreter; SV : PSV) : Integer; cdecl;
  Perl_save_int :
   Procedure(interp: PPerlInterpreter; intp : PInteger); cdecl;
  Perl_sv_free :
   procedure(interp: PPerlInterpreter; SV : PSV); cdecl;

  //5.10
  Perl_sys_init3 :
   procedure (out argc: Integer; out argv, env : PPcharArray); cdecl;

 const
  G_DISCARD	= 2;	//* Call FREETMPS. */
  G_EVAL =	4;	//* Assume eval {} around subroutine call. */
  G_NOARGS = 8;	//* Don't construct a @_ array. */
  G_KEEPERR = 16;	//* Append errors to $@, don't overwrite it */
  G_NODEBUG = 32;	//* Disable debugging at toplevel.  */
  G_METHOD = 64 ; //* Calling method. */

  SV_IMMEDIATE_UNREF = 1;
  SV_GMAGIC	=	2;

  //sv.H
  SVf_IOK	= $10000;	//* has valid public integer value */
  SVf_NOK	= $20000;	//* has valid public numeric value */
  SVf_POK	= $40000;	//* has valid public pointer value */
  SVf_ROK	= $80000;	//* has a valid reference pointer */

  SVp_IOK	= $1000000;	//* has valid non-public integer value */
  SVp_NOK	=	$2000000;	//* has valid non-public numeric value */
  SVp_POK	= $4000000;	//* has valid non-public pointer value */

  //510
  SVf_IOK_510	= $100;	//* has valid public integer value */
  SVf_NOK_510	= $200;	//* has valid public numeric value */
  SVf_POK_510	= $400;	//* has valid public pointer value */
  SVf_ROK_510	= $800;	//* has a valid reference pointer */

  SVp_IOK_510	= $1000;	//* has valid non-public integer value */
  SVp_NOK_510	=	$2000;	//* has valid non-public numeric value */
  SVp_POK_510	= $4000;	//* has valid non-public pointer value */
  SVpgv_GP    = $8000;

  SVf_OK = (SVf_IOK or SVf_NOK or SVf_POK or SVf_ROK or SVp_IOK or SVp_NOK or SVp_POK);
  SVf_OK_510 = (SVf_IOK_510 or SVf_NOK_510 or SVf_POK_510 or SVf_ROK_510 or
                SVp_IOK_510 or SVp_NOK_510 or SVp_POK_510 OR SVpgv_GP);

 type
  TPerlBase = Class
  Private
   FFile : String;
   FThreadNum : Integer;
   FParams : Array of String;
   procedure AfterFunction(OldMark: Integer);
   procedure BeforeFunction(var OldMark: Integer);
   function ReturnString(SV: PSv): String;
   procedure ExecuteSub(const sub: String; Argv: PPcharArray; IsFunc: Boolean);
   Function MakeEnv(var Env : TDynPcharArray) : Pointer;
  protected
   Procedure BeforeRun; virtual;
  public
   Perl : PPerlInterpreter;
   MainHandle : THandle;
   Debug : Boolean;
   RaiseExceptions : Boolean;
   Perl5lib : String;
   Procedure SetContext;
   function VarDefined(const VarName: String): Boolean;
   function EvalCode(const Code: String): String;
   procedure CheckSubErrorMessage(const SubName : String);
   function GetVarString(const v: String): String;
   function GetVarInteger(const v: String): Integer;
   Procedure SetVarString(const VarName, VarValue : string);
   procedure Initialize; virtual;
   Procedure RunSubroutine(const sub: String; Argv : PPcharArray);
   function RunStrFunction(const sub: String; Argv: PPcharArray): String;
   Function RunIntFunction(const sub: String; Argv : PPcharArray) : Integer;
   Constructor Create(Params : Array of String; Dynaloader : Boolean);
   Destructor Destroy; override;
  end;

  TPerlCheck = Class
  private
   FThreadNum : Integer;
   XS : Pointer;
   Perl : PPerlInterpreter;
  public
   Errors : TStringList;
   Constructor Create;
   Procedure Check(Const Filename : String);
   Destructor Destroy; override;
  end;

  TPerlEvents = class(TPerlBase)
  protected
   Procedure BeforeRun; Override;
  public
   SelfStr : String;
   Subroutines : TStringList;
   UseTK : Boolean;
   Procedure TKDoEvent;
   procedure TKDoEventWait;
   procedure Initialize; Override;
   Function HasSub(Const SubName : String) : Boolean;
   Constructor Create(const PerlFile : String); reintroduce;
   Destructor Destroy; override;
  end;

procedure UnloadPerlDll;
Procedure HookWinCBT;
Procedure UnHookWinCBT;

var
 PerlDllValid : Boolean = false;
 PerlDllFile : String;

const
 Var_valid_Plugin = 'valid_plugin';

implementation

var
 FIs510 : Boolean;
 FPerlLib : Cardinal;
 XsInit : Array[0..19] of Pointer;
 XsInitPerl : Array[0..19] of PPerlInterpreter;
 CS : TCriticalSection;
 CBT_Hook : HHook = 0;

Function GetMsgProc(Code: Integer; wParam: WParam; lParam: LParam): LRESULT; stdcall;
begin
 if (code=HCBT_MINMAX) or (code=HCBT_MOVESIZE)
  then result:=1
  else Result := CallNextHookEx(CBT_Hook, Code, wParam, lParam)
end;

const
 Dyna = 'DynaLoader::boot_DynaLoader';

procedure xsinit0; begin
 Perl_newXS(XsInitPerl[0],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit1; begin
 Perl_newXS(XsInitPerl[1],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit2; begin
 Perl_newXS(XsInitPerl[2],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit3; begin
 Perl_newXS(XsInitPerl[3],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit4; begin
 Perl_newXS(XsInitPerl[4],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit5; begin
 Perl_newXS(XsInitPerl[5],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit6; begin
 Perl_newXS(XsInitPerl[6],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit7; begin
 Perl_newXS(XsInitPerl[7],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit8; begin
 Perl_newXS(XsInitPerl[8],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit9; begin
 Perl_newXS(XsInitPerl[9],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit10; begin
 Perl_newXS(XsInitPerl[10],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit11; begin
 Perl_newXS(XsInitPerl[11],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit12; begin
 Perl_newXS(XsInitPerl[12],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit13; begin
 Perl_newXS(XsInitPerl[13],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit14; begin
 Perl_newXS(XsInitPerl[14],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit15; begin
 Perl_newXS(XsInitPerl[15],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit16; begin
 Perl_newXS(XsInitPerl[16],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit17; begin
 Perl_newXS(XsInitPerl[17],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit18; begin
 Perl_newXS(XsInitPerl[18],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;
procedure xsinit19; begin
 Perl_newXS(XsInitPerl[19],Pchar(Dyna), @boot_DynaLoader, pchar(''));
end;

Procedure PerlProcExit(piPerl: PIPerlProc; Status : Integer); Stdcall;
begin
 inttostr(status);
end;

procedure UnloadPerlDll;
begin
 if FPerlLib<>0 then
 begin
  Freelibrary(FperlLib);
  FPerlLib:=0;
 end;
end;

procedure UpdatePerlDll;
begin
 if (FPerlLib=0) and (fileexists(PerlDLLFile)) then
 begin
  PerlDllValid:=false;
  FPerlLib:=LoadLibrary(pchar(PerlDLLFile));
  if FPerlLib<>0 then
  begin
   @perl_alloc:=GetProcAddress(FPerlLib,'perl_alloc');
   @perl_alloc_using:=GetProcAddress(FPerlLib,'perl_alloc_using');
   @perl_get_host_info:=GetProcAddress(FPerlLib,'perl_get_host_info');
   @perl_construct:=GetProcAddress(FPerlLib,'perl_construct');
   @perl_destruct:=GetProcAddress(FPerlLib,'perl_destruct');
   @perl_free:=GetProcAddress(FPerlLib,'perl_free');
   @perl_run:=GetProcAddress(FPerlLib,'perl_run');
   @perl_parse:=GetProcAddress(FPerlLib,'perl_parse');
   @boot_DynaLoader:=GetProcAddress(FPerlLib,'boot_DynaLoader');
   @Perl_newXS:=GetProcAddress(FPerlLib,'Perl_newXS');
   @Perl_eval_pv:=GetProcAddress(FPerlLib,'Perl_eval_pv');
   @Perl_get_sv:=GetProcAddress(FPerlLib,'Perl_get_sv');
   @Perl_sv_2pv_flags:=GetProcAddress(FPerlLib,'Perl_sv_2pv_flags');
   @Perl_set_context:=GetProcAddress(FPerlLib,'Perl_set_context');
   @Perl_call_argv:=GetProcAddress(FPerlLib,'Perl_call_argv');
   @Perl_free_tmps:=GetProcAddress(FPerlLib,'Perl_free_tmps');
   @Perl_pop_scope:=GetProcAddress(FPerlLib,'Perl_pop_scope');
   @Perl_push_scope:=GetProcAddress(FPerlLib,'Perl_push_scope');
   @Perl_markstack_grow:=GetProcAddress(FPerlLib,'Perl_markstack_grow');
   @Perl_sv_2iv:=GetProcAddress(FPerlLib,'Perl_sv_2iv');
   @Perl_sv_setpv:=GetProcAddress(FPerlLib,'Perl_sv_setpv');
   @Perl_save_int:=GetProcAddress(FPerlLib,'Perl_save_int');
   @Perl_sv_free:=GetProcAddress(FPerlLib,'Perl_sv_free');
   @Perl_eval_sv:=GetProcAddress(FPerlLib,'Perl_eval_sv');

   //for 510
   @Perl_sys_init3:=GetProcAddress(FPerlLib,'Perl_sys_init3');
   FIs510:=assigned(Perl_sys_init3);

   PerlDllValid:=true;
  end;
 end;
end;

constructor TPerlBase.Create(Params : Array of String; Dynaloader : Boolean);
var
 i:integer;
begin
 RaiseExceptions:=true;
 Debug:=true;
 UpdatePerlDll;
 if not PerlDLLValid then exit;
 SetLength(FParams,length(Params));
 for i:=0 to length(params)-1 do
  FParams[i]:=Params[i];

 if DynaLoader then
  begin
   i:=0;
   while (i<=high(XsinitPerl)) and (XsinitPerl[i]<>Nil) do
    inc(i);
   FThreadNum:=i;
  end
 else
  FThreadNum:=-1;
end;

Function TPerlBase.MakeEnv(var Env : TDynPcharArray) : Pointer;
Type
 PByteArray = ^TByteArray;
 TByteArray = array[0..MaxLongInt-1] of Byte;
var
  p: PByteArray;
  j,i,pi: Integer;
begin
 p := Pointer(GetEnvironmentStrings);
 j:=0;
 i:=0;
 pi:=0;

 repeat
  while (p^[j]<>0) do
   inc(j);
  SetLength(Env,i+1);
  Env[i]:=@p[pi];
  if AnsiCompareText(copy(Env[i],1,4),'PERL')<>0 then
   inc(i);
  inc(j);
  pi:=j;
  if p^[j]=0 then break;
 Until (false);

 SetLength(Env,i+2);
 Env[i]:=pchar('PERL5LIB='+perl5lib);
 Env[i+1]:=nil;
 result:=p;
end;

procedure TPerlBase.SetContext;
begin
 Perl_set_context(perl);
end;

procedure TPerlBase.BeforeRun;
begin

end;

procedure TPerlBase.Initialize;
var
 Argv : TPcharArray;
 PEnv : Pointer;
 TE : Pointer;
 Env : TDynPcharArray;
 i:integer;
 XS : Pointer;
 d1,d2 : PPCharArray;
begin
 try
  perl:=perl_alloc;
  SetContext;
 except
  perl:=nil;
 end;

 if perl<>nil then
 begin
  argv[0]:=pchar('Thread '+inttostr(FThreadNum));
  for i:=0 to length(FParams)-1 do
   argv[i+1]:=pchar(FParams[i]);

  if FThreadNum>=0 then
   begin
    XsinitPerl[FThreadNum]:=perl;
    xs:=xsinit[FThreadNum];
   end
  else
   XS:=nil;

  Perl_construct(perl);

  if Length(Perl5Lib)=0 then
   begin
    PEnv:=nil;
    TE:=nil;
   end
  else
   begin
    TE:=MakeEnv(Env);
    PEnv:=@Env[0];
   end;

  d1:=nil;
  d2:=nil;
  if assigned(Perl_sys_init3) then
   Perl_sys_init3(i,d1,d2);

  perl_parse(perl,xs,Length(FParams)+1,@argv,PEnv);
  if TE<>nil then
   FreeEnvironmentStrings(TE);
  BeforeRun;
  Perl_run(perl);
 end;
end;

destructor TPerlBase.Destroy;
begin
 if (PerlDLLValid) and (perl<>nil) then
 begin
  try
   SetContext;
   Perl_Destruct(perl);
   Perl_Free(perl);
  except on exception do end;

  if FThreadNum>=0 then
   XsinitPerl[FThreadNum]:=nil;
 end;

 inherited;
end;

function TPerlBase.VarDefined(Const VarName : String) : Boolean;
VAR
 sv : PSV;
begin
 sv:=Perl_get_sv(perl,Pchar(varname),false);
 if FIs510 then
  result:=assigned(sv) and ((sv.sv_flags and SVf_OK_510) > 0)
 else
  result:=assigned(sv) and ((sv.sv_flags and SVf_OK) > 0)
end;

function TPerlBase.GetVarInteger(const v: String): Integer;
VAR
 sv : PSV;
begin
 sv:=Perl_get_sv(perl,Pchar(v),false);
 if (assigned(sv))
  then result:=Perl_sv_2iv(perl, sv)
  else result:=0;
end;

Procedure TPerlBase.SetVarString(Const VarName,VarValue : string);
VAR
 sv : PSV;
begin
 sv:=Perl_get_sv(perl,pchar(varname),false);
 if assigned(sv)
  then Perl_sv_setpv(perl,sv,pchar(VarValue))
end;

function TPerlBase.GetVarString(const v: String): String;
VAR
 sv : PSV;
begin
 sv:=Perl_get_sv(perl,pchar(v),false);
 if assigned(sv)
  then result:=returnString(sv)
  else result:='';
end;

Function TPerlBase.ReturnString(SV : PSv) : String;
var
 xpv : Pxpv;
 res : pchar;
 len : Cardinal;
begin
 if FIs510 and (sv.sv_flags and SVf_POK_510 = SVf_POK_510) then
  res:=sv.perl510pchar

 else
 if not Fis510 and (sv.sv_flags and SVf_POK = SVf_POK) then
  begin
   XPV:=sv.sv_any;
   res:=xpv.xpv_pv;
  end

 else
  res:=Perl_sv_2pv_flags(perl, sv, @len, SV_GMAGIC);
 result:=res;
end;

Procedure TPerlBase.RunSubroutine(const sub : String; Argv : PPcharArray);
begin
 SetContext;
 ExecuteSub(sub,argv,false);
end;

Procedure TPerlBase.BeforeFunction(Var OldMark : Integer);
begin
 Perl_Push_scope(perl);
 Perl_save_int(perl,@perl.Ttmps_floor);
 perl.Ttmps_floor:=perl.Ttmps_ix;
 oldmark:=perl.Tmarkstack_ptr;
end;

Procedure TPerlBase.AfterFunction(OldMark : Integer);
begin
 perl.TStack_sp:=pointer( integer( perl.Tstack_base )+ OldMark );
 if (perl.Ttmps_ix >  perl.Ttmps_floor) then
  Perl_free_tmps(perl);
 Perl_pop_scope(perl);
end;

Procedure TPerlBase.ExecuteSub(const sub: String; Argv: PPcharArray; IsFunc : Boolean);
const
 Flags : array[boolean] of integer = (0,G_EVAL);
 FuncFlags : array[boolean] of integer = (G_DISCARD,0);
begin
 if argv<>nil
 then
  Perl_call_argv(perl,pchar(sub),flags[debug] or FuncFlags[IsFunc],argv)
 else
  Perl_call_argv(perl,pchar(sub),flags[debug] or FuncFlags[IsFunc] or G_NOARGS,nil);
 CheckSubErrorMessage(sub);
end;

Function TPerlBase.EvalCode(const Code : String) : String;
begin
 if (not PerlDLLValid) or (perl=nil) then
  result:='Perl DLL not loaded'
 else
  begin
   perl_Eval_PV(perl,pchar(code),false);
   perl_free_tmps(perl);
   result:=GetVarString('@');
  end
end;

Procedure TPerlBase.CheckSubErrorMessage(const SubName : String);
var
 error : string;
begin
 if Debug then
 begin
  error:=trim(GetVarString('@'));
  if length(error)>0 then
  begin
   if raiseExceptions then
    begin
     error:='Error in script: '+FFile+#13#10+'Subroutine: '+subname+#13#10+error;
     raise EPerlRunError.Create(Error);
    end
   else
    messagebox(Mainhandle,pchar('Subroutine: '+subname+#13#10+error),
     pchar('Error in script: '+FFile),MB_OK	or MB_ICONERROR);
  end;
 end;
end;

function TPerlBase.RunStrFunction(const sub: String; Argv: PPcharArray): String;
var
 sp : PPSv;
 sv : PSv;
 OldMark : Integer;
begin
 if (not PerlDLLValid) or (perl=nil) then exit;
 SetContext;

 BeforeFunction(oldmark);

 ExecuteSub(sub,argv,true);

 sp:=perl.TStack_sp;
 perl.TSv:=sp^;
 sv:=perl.TSv;

 result:=ReturnString(sv);
 AfterFunction(oldmark);
end;


function TPerlBase.RunIntFunction(const sub: String; Argv: PPcharArray): Integer;
var
 sp : PPSv;
 sv : PSv;
 OldMark : Integer;
begin
 if (not PerlDLLValid) or (perl=nil) then
 begin
  result:=0;
  exit;
 end;

 SetContext;
 BeforeFunction(oldmark);

 ExecuteSub(sub,argv,true);

 sp:=perl.TStack_sp;
 perl.TSv:=sp^;
 sv:=perl.TSv;

 if (sv.sv_flags and SVf_IOK = SVf_IOK)
 then
  result:=PXPVIV(perl.TSv.sv_any).xiv_iv
 else
  result:=(Perl_sv_2iv(perl, sv));

 AfterFunction(oldmark);
end;

{ TPerlEvents }

constructor TPerlEvents.Create(const PerlFile: String);
var
 Spcre : TDIPcre;
 sl : TStringList;
 i:integer;
begin
 inherited create([PerlFile],true);
 SelfStr:=IntToStr(integer(self));
 FFile:=PerlFile;

 Subroutines:=TStringList.Create;
 Subroutines.Sorted:=true;
 Subroutines.CaseSensitive:=true;
 Subroutines.Duplicates:=dupIgnore;

 SPcre:=TDIPcre.Create(nil);
 SPcre.MatchPattern:='^\s*sub\s+(\w+)';
 sl:=TStringList.Create;
 try
  sl.LoadFromFile(PerlFile);
  for i:=0 to sl.Count-1 do
   if SPcre.MatchStr(sl[i])=2 then
    subroutines.Add(spcre.SubStr(1));
 finally
  sl.free;
  SPcre.Free;
 end;
end;

Procedure TPerlEvents.TKDoEventWait;
begin
 try
  Perl_Eval_Pv(perl,'DoOneEvent(0);while(DoOneEvent(254)){}',false);
 except on exception do end;
 Perl_free_tmps(perl);
end;

Procedure TPerlEvents.TKDoEvent;
begin
 try
  Perl_Eval_Pv(perl,'while(DoOneEvent(254)){}',false);
 except on exception do end;
 Perl_free_tmps(perl);
{
 254 =  11111110
 #define TCL_DONT_WAIT		(1<<1)   -> must include this !!
 #define TCL_WINDOW_EVENTS	(1<<2)
 #define TCL_FILE_EVENTS		(1<<3)
 #define TCL_TIMER_EVENTS	(1<<4)
 #define TCL_IDLE_EVENTS		(1<<5)	/* WAS 0x10 ???? */
 #define TCL_ALL_EVENTS		(~TCL_DONT_WAIT)
}
end;

procedure TPerlEvents.BeforeRun;
begin
 EvalCode('$'+var_Valid_PlugIN+'=1; sub ProcessEvents{while(DoOneEvent(254)){}}');
end;

Procedure HookWinCBT;
begin
 if CBT_Hook=0 then
  CBT_Hook:=setWindowsHookEx(WH_CBT,GetMsgProc,0,GetCurrentThreadID);
end;

Procedure UnHookWinCBT;
begin
 if CBT_Hook<>0 then
 begin
  Unhookwindowshookex(CBT_Hook);
  CBT_Hook:=0;
 end;
end;

procedure TPerlEvents.Initialize;
var
 Argv : TPcharArray;
begin
 if UseTK then
  HookWinCBT;

 inherited;

 self.EvalCode('sub ProcessEvents {while(DoOneEvent(254)){}}');
 argv[0]:=pchar(selfstr);
 argv[1]:=nil;
 RunSubroutine('Initialization',@argv);

 if UseTK then
 begin
  TKDoEvent;
  UnHookWinCBT;
  TKDoEvent;
 end;

end;

destructor TPerlEvents.Destroy;
begin
 RunSubroutine('Finalization',nil);
 if UseTK then
  TKDoEvent;
 Subroutines.Free;
 inherited;
end;

function TPerlEvents.HasSub(const SubName: String): Boolean;
begin
 result:=subroutines.IndexOf(subname)>=0;
end;

{ TPerlCheck }

constructor TPerlCheck.Create;
var
 Argv : TPcharArray;
 i : Integer;
begin
 UpdatePerlDll;
 if (not PerlDLLValid) then
  raise EPerlRunError.Create('Could not open Perl DLL');

 i:=0;
 while (i<=high(XsinitPerl)) and (XsinitPerl[i]<>Nil) do
  inc(i);
 FThreadNum:=i;

 perl:=perl_alloc;
 if (perl=nil) then
  raise EPerlRunError.Create('Could not open Perl DLL');

 if (CBT_Hook=0) then
  CBT_Hook:=setWindowsHookEx(WH_CBT,GetMsgProc,0,GetCurrentThreadID);

 XsinitPerl[FThreadNum]:=perl;
 xs:=xsinit[FThreadNum];
 Perl_construct(perl);

 argv[0]:=pchar('Thread '+inttostr(FThreadNum));
 Argv[1]:='-cwe';
 argv[2]:='0';
 perl_parse(perl,xs,3,@argv,nil);
 perl_run(perl);
end;


procedure TPerlCheck.Check(const Filename: String);
var
 Argv : TPcharArray;
begin
 perl_Eval_PV(perl,pchar('open(STDERR,''>c:\1.txt'');'),false);

 argv[0]:=pchar('Thread '+inttostr(FThreadNum));
 Argv[1]:='-cw';
 argv[2]:=pchar(filename);
 perl_parse(perl,xs,3,@argv,nil);

 perl_Eval_PV(perl,pchar('close(STDERR);'),false);
end;

destructor TPerlCheck.Destroy;
begin
 try
  Perl_Destruct(perl);
  Perl_Free(perl);
 except on exception do end;

 if FThreadNum>=0 then
  XsinitPerl[FThreadNum]:=nil;

 if (CBT_Hook<>0) then
 begin
  Unhookwindowshookex(CBT_Hook);
  CBT_Hook:=0;
 end;

 inherited;
end;

initialization
 xsinit[0]:=@XSInit0; xsinit[1]:=@XSInit1;
 xsinit[2]:=@XSInit2; xsinit[3]:=@XSInit3;
 xsinit[4]:=@XSInit4; xsinit[5]:=@XSInit5;
 xsinit[6]:=@XSInit6; xsinit[7]:=@XSInit7;
 xsinit[8]:=@XSInit8; xsinit[9]:=@XSInit9;
 xsinit[10]:=@XSInit10; xsinit[11]:=@XSInit11;
 xsinit[12]:=@XSInit12; xsinit[13]:=@XSInit13;
 xsinit[14]:=@XSInit14; xsinit[15]:=@XSInit15;
 xsinit[16]:=@XSInit16; xsinit[17]:=@XSInit17;
 xsinit[18]:=@XSInit18; xsinit[19]:=@XSInit19;

 FillChar(XsInitPerl,sizeof(XsInitPerl),0);
 CS:=TCriticalSection.Create;
Finalization
 UnloadPerlDll;
 CS.free;
end.


