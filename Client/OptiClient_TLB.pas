unit OptiClient_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 2/14/2020 5:17:25 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\OptiPerl\Client\OptiClient.tlb (1)
// LIBID: {67CACABA-D0CA-47F2-A056-A05E5DB271A0}
// LCID: 0
// Helpfile: 
// HelpString: OptiClient Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  OptiClientMajorVersion = 1;
  OptiClientMinorVersion = 0;

  LIBID_OptiClient: TGUID = '{67CACABA-D0CA-47F2-A056-A05E5DB271A0}';

  IID_IOptiPerlClient: TGUID = '{0C8B5172-F3B2-460D-97D2-E08B482F35CD}';
  CLASS_OptiPerlClient: TGUID = '{96AD2497-5B8E-4E14-BF2A-58B1A2E8D88F}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IOptiPerlClient = interface;
  IOptiPerlClientDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  OptiPerlClient = IOptiPerlClient;


// *********************************************************************//
// Interface: IOptiPerlClient
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {0C8B5172-F3B2-460D-97D2-E08B482F35CD}
// *********************************************************************//
  IOptiPerlClient = interface(IDispatch)
    ['{0C8B5172-F3B2-460D-97D2-E08B482F35CD}']
    procedure Start; safecall;
    procedure InitOptions(const PerlDLL: WideString; MainHandle: Integer; 
                          const Filename: WideString; PlugNum: Integer); safecall;
    function Get_Subroutines: WideString; safecall;
    procedure RunSub0(const Sub: WideString); safecall;
    procedure RunSub1(const Sub: WideString; const P1: WideString); safecall;
    procedure RunSub2(const Sub: WideString; const P1: WideString; const P2: WideString); safecall;
    function RunInt0(const Sub: WideString): Integer; safecall;
    function RunInt1(const Sub: WideString; const P1: WideString): Integer; safecall;
    procedure DockWindow(Handle: Integer; Parent: Integer); safecall;
    procedure Grab(Enable: WordBool; Handle: Integer); safecall;
    function Get_FirstEnabledWindow: Integer; safecall;
    function Get_ProcessID: Integer; safecall;
    function RunInt2(const Sub: WideString; const P1: WideString; const P2: WideString): Integer; safecall;
    property Subroutines: WideString read Get_Subroutines;
    property FirstEnabledWindow: Integer read Get_FirstEnabledWindow;
    property ProcessID: Integer read Get_ProcessID;
  end;

// *********************************************************************//
// DispIntf:  IOptiPerlClientDisp
// Flags:     (4432) Hidden Dual OleAutomation Dispatchable
// GUID:      {0C8B5172-F3B2-460D-97D2-E08B482F35CD}
// *********************************************************************//
  IOptiPerlClientDisp = dispinterface
    ['{0C8B5172-F3B2-460D-97D2-E08B482F35CD}']
    procedure Start; dispid 201;
    procedure InitOptions(const PerlDLL: WideString; MainHandle: Integer; 
                          const Filename: WideString; PlugNum: Integer); dispid 202;
    property Subroutines: WideString readonly dispid 203;
    procedure RunSub0(const Sub: WideString); dispid 204;
    procedure RunSub1(const Sub: WideString; const P1: WideString); dispid 205;
    procedure RunSub2(const Sub: WideString; const P1: WideString; const P2: WideString); dispid 206;
    function RunInt0(const Sub: WideString): Integer; dispid 207;
    function RunInt1(const Sub: WideString; const P1: WideString): Integer; dispid 208;
    procedure DockWindow(Handle: Integer; Parent: Integer); dispid 209;
    procedure Grab(Enable: WordBool; Handle: Integer); dispid 211;
    property FirstEnabledWindow: Integer readonly dispid 212;
    property ProcessID: Integer readonly dispid 210;
    function RunInt2(const Sub: WideString; const P1: WideString; const P2: WideString): Integer; dispid 213;
  end;

// *********************************************************************//
// The Class CoOptiPerlClient provides a Create and CreateRemote method to          
// create instances of the default interface IOptiPerlClient exposed by              
// the CoClass OptiPerlClient. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoOptiPerlClient = class
    class function Create: IOptiPerlClient;
    class function CreateRemote(const MachineName: string): IOptiPerlClient;
  end;

implementation

uses ComObj;

class function CoOptiPerlClient.Create: IOptiPerlClient;
begin
  Result := CreateComObject(CLASS_OptiPerlClient) as IOptiPerlClient;
end;

class function CoOptiPerlClient.CreateRemote(const MachineName: string): IOptiPerlClient;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_OptiPerlClient) as IOptiPerlClient;
end;

end.
