unit OptiPerl_TLB;

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
// File generated on 2/15/2020 3:14:48 PM from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\OptiPerl\Project\OptiPerl.tlb (1)
// LIBID: {EA9A0861-1BE9-4FF6-B356-ED60982F5DA4}
// LCID: 0
// Helpfile: 
// HelpString: OptiPerl Library
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
  OptiPerlMajorVersion = 1;
  OptiPerlMinorVersion = 0;

  LIBID_OptiPerl: TGUID = '{EA9A0861-1BE9-4FF6-B356-ED60982F5DA4}';

  IID_IApplication: TGUID = '{69BC5A32-96D4-4AA6-900D-EA99F5C7DC6A}';
  DIID_IApplicationEvents: TGUID = '{F23F2519-6E04-4306-A20F-D7DF0ABC67E5}';
  CLASS_Application: TGUID = '{73311197-C363-409C-96D2-35955A91DAEE}';
  IID_IDocument: TGUID = '{A9991221-977F-4CE1-B514-A335E5FAB65F}';
  CLASS_Document: TGUID = '{BD35EEEB-8F35-479D-BEBB-D567D628655E}';
  IID_IProject: TGUID = '{A41D1250-5A42-4D0F-941A-E673B8B6BC7B}';
  CLASS_Project: TGUID = '{34A67A50-EA71-4CBC-A88A-FB30C0FB3E3B}';
  IID_INode: TGUID = '{EB011271-4D28-475B-B55D-B9371ABB16CF}';
  CLASS_Node: TGUID = '{8D328B51-8C26-4B91-A343-A238FA763D71}';
  IID_ITreeView: TGUID = '{A69C0445-73AA-491A-9505-2194FAD97B31}';
  CLASS_TreeView: TGUID = '{16D7EBC8-9242-453A-80EA-4C431759D6E5}';
  IID_IControl: TGUID = '{E1DC801E-2DFE-4EE4-87A6-D385B3C009AA}';
  CLASS_Control: TGUID = '{6CD61D4B-A32B-471F-AA41-7B2666D50EF8}';
  IID_IWindow: TGUID = '{F6C6BA68-788D-4DCA-9FFF-132AADE58256}';
  CLASS_Window: TGUID = '{84580361-56CB-4D3C-9C08-F05455E70043}';
  IID_IToolLinks: TGUID = '{FF843630-2A12-4314-A7B0-3DB710DA0E43}';
  CLASS_ToolLinks: TGUID = '{130CE53C-2BC7-4E8D-9A54-C5F774989F00}';
  IID_IProjectItem: TGUID = '{C9FAC5B9-0D65-469E-8F34-636C5C061240}';
  CLASS_ProjectItem: TGUID = '{5F99E89E-F732-4541-AEF9-A7102C1D6D16}';
  IID_IToolItem: TGUID = '{70E0C93C-5987-47B9-A167-99B6CA3E307C}';
  CLASS_ToolItem: TGUID = '{C6C38ED0-170C-499D-A261-A7A4B2236140}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IApplication = interface;
  IApplicationDisp = dispinterface;
  IApplicationEvents = dispinterface;
  IDocument = interface;
  IDocumentDisp = dispinterface;
  IProject = interface;
  IProjectDisp = dispinterface;
  INode = interface;
  INodeDisp = dispinterface;
  ITreeView = interface;
  ITreeViewDisp = dispinterface;
  IControl = interface;
  IControlDisp = dispinterface;
  IWindow = interface;
  IWindowDisp = dispinterface;
  IToolLinks = interface;
  IToolLinksDisp = dispinterface;
  IProjectItem = interface;
  IProjectItemDisp = dispinterface;
  IToolItem = interface;
  IToolItemDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  Application = IApplication;
  Document = IDocument;
  Project = IProject;
  Node = INode;
  TreeView = ITreeView;
  Control = IControl;
  Window = IWindow;
  ToolLinks = IToolLinks;
  ProjectItem = IProjectItem;
  ToolItem = IToolItem;


// *********************************************************************//
// Interface: IApplication
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {69BC5A32-96D4-4AA6-900D-EA99F5C7DC6A}
// *********************************************************************//
  IApplication = interface(IDispatch)
    ['{69BC5A32-96D4-4AA6-900D-EA99F5C7DC6A}']
    function Get_DocumentCount: Integer; safecall;
    function Get_ActiveDocument: OleVariant; safecall;
    function Get_Documents(Index: Integer): OleVariant; safecall;
    function Get_Project: OleVariant; safecall;
    function Get_CodeExplorer: OleVariant; safecall;
    procedure EndPlugIn(Process: Integer); safecall;
    procedure OutputAddLine(const Text: WideString); safecall;
    procedure OutputClear; safecall;
    function Get_Windows(const Name: WideString): OleVariant; safecall;
    function RequestWindow(Process: Integer): OleVariant; safecall;
    function Get_Handle: Integer; safecall;
    procedure UpdateOptions(Everything: WordBool); safecall;
    procedure StatusBarText(const Text: WideString); safecall;
    procedure StatusBarRestore; safecall;
    procedure ExecuteAction(const Action: WideString); safecall;
    function Get_FocusedControl: OleVariant; safecall;
    procedure Set_FocusedControl(Value: OleVariant); safecall;
    function Get_EditorControl: OleVariant; safecall;
    procedure DockWindow(Process: Integer; Handle: Integer; const Parent: IWindow); safecall;
    procedure SetOpt(const Name: WideString; Value: OleVariant); safecall;
    function GetOpt(const Name: WideString): OleVariant; safecall;
    function Get_Self: Integer; safecall;
    function OpenDocument(const Filename: WideString): OleVariant; safecall;
    function NewDocument(const Filename: WideString): OleVariant; safecall;
    procedure CloseDocument; safecall;
    procedure QuickSave; safecall;
    function Get_ToolBarLinks(Process: Integer): OleVariant; safecall;
    procedure UpdateToolBars(Process: Integer); safecall;
    function CreateToolItem(Process: Integer; const ClassName: WideString): OleVariant; safecall;
    procedure DestroyWindow(Process: Integer; const Window: IWindow); safecall;
    procedure GrabWindow(Process: Integer; Enable: WordBool; Handle: Integer); safecall;
    procedure ProcessMessages; safecall;
    function GetWindowHandle(const Window: IWindow): Integer; safecall;
    procedure ToolBarVisible(Process: Integer; Visible: WordBool); safecall;
    procedure SetColor(const Name: WideString; const Value: WideString); safecall;
    function GetColor(const Name: WideString): WideString; safecall;
    function MessageBox(const Caption: WideString; const Prompt: WideString; Flags: Integer): Integer; safecall;
    function InputBox(const Caption: WideString; const Prompt: WideString; const Default: WideString): WideString; safecall;
    property DocumentCount: Integer read Get_DocumentCount;
    property ActiveDocument: OleVariant read Get_ActiveDocument;
    property Documents[Index: Integer]: OleVariant read Get_Documents;
    property Project: OleVariant read Get_Project;
    property CodeExplorer: OleVariant read Get_CodeExplorer;
    property Windows[const Name: WideString]: OleVariant read Get_Windows;
    property Handle: Integer read Get_Handle;
    property FocusedControl: OleVariant read Get_FocusedControl write Set_FocusedControl;
    property EditorControl: OleVariant read Get_EditorControl;
    property Self: Integer read Get_Self;
    property ToolBarLinks[Process: Integer]: OleVariant read Get_ToolBarLinks;
  end;

// *********************************************************************//
// DispIntf:  IApplicationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {69BC5A32-96D4-4AA6-900D-EA99F5C7DC6A}
// *********************************************************************//
  IApplicationDisp = dispinterface
    ['{69BC5A32-96D4-4AA6-900D-EA99F5C7DC6A}']
    property DocumentCount: Integer readonly dispid 201;
    property ActiveDocument: OleVariant readonly dispid 202;
    property Documents[Index: Integer]: OleVariant readonly dispid 203;
    property Project: OleVariant readonly dispid 204;
    property CodeExplorer: OleVariant readonly dispid 207;
    procedure EndPlugIn(Process: Integer); dispid 209;
    procedure OutputAddLine(const Text: WideString); dispid 210;
    procedure OutputClear; dispid 211;
    property Windows[const Name: WideString]: OleVariant readonly dispid 212;
    function RequestWindow(Process: Integer): OleVariant; dispid 213;
    property Handle: Integer readonly dispid 214;
    procedure UpdateOptions(Everything: WordBool); dispid 217;
    procedure StatusBarText(const Text: WideString); dispid 205;
    procedure StatusBarRestore; dispid 206;
    procedure ExecuteAction(const Action: WideString); dispid 208;
    property FocusedControl: OleVariant dispid 215;
    property EditorControl: OleVariant readonly dispid 218;
    procedure DockWindow(Process: Integer; Handle: Integer; const Parent: IWindow); dispid 219;
    procedure SetOpt(const Name: WideString; Value: OleVariant); dispid 216;
    function GetOpt(const Name: WideString): OleVariant; dispid 220;
    property Self: Integer readonly dispid 221;
    function OpenDocument(const Filename: WideString): OleVariant; dispid 222;
    function NewDocument(const Filename: WideString): OleVariant; dispid 223;
    procedure CloseDocument; dispid 224;
    procedure QuickSave; dispid 225;
    property ToolBarLinks[Process: Integer]: OleVariant readonly dispid 227;
    procedure UpdateToolBars(Process: Integer); dispid 228;
    function CreateToolItem(Process: Integer; const ClassName: WideString): OleVariant; dispid 229;
    procedure DestroyWindow(Process: Integer; const Window: IWindow); dispid 230;
    procedure GrabWindow(Process: Integer; Enable: WordBool; Handle: Integer); dispid 231;
    procedure ProcessMessages; dispid 232;
    function GetWindowHandle(const Window: IWindow): Integer; dispid 233;
    procedure ToolBarVisible(Process: Integer; Visible: WordBool); dispid 234;
    procedure SetColor(const Name: WideString; const Value: WideString); dispid 235;
    function GetColor(const Name: WideString): WideString; dispid 236;
    function MessageBox(const Caption: WideString; const Prompt: WideString; Flags: Integer): Integer; dispid 237;
    function InputBox(const Caption: WideString; const Prompt: WideString; const Default: WideString): WideString; dispid 238;
  end;

// *********************************************************************//
// DispIntf:  IApplicationEvents
// Flags:     (4096) Dispatchable
// GUID:      {F23F2519-6E04-4306-A20F-D7DF0ABC67E5}
// *********************************************************************//
  IApplicationEvents = dispinterface
    ['{F23F2519-6E04-4306-A20F-D7DF0ABC67E5}']
  end;

// *********************************************************************//
// Interface: IDocument
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A9991221-977F-4CE1-B514-A335E5FAB65F}
// *********************************************************************//
  IDocument = interface(IDispatch)
    ['{A9991221-977F-4CE1-B514-A335E5FAB65F}']
    function Get_LineCount: Integer; safecall;
    function Get_Lines(Index: Integer): WideString; safecall;
    procedure Set_Lines(Index: Integer; const Value: WideString); safecall;
    function Get_ColorData(Index: Integer): WideString; safecall;
    procedure Set_ColorData(Index: Integer; const Value: WideString); safecall;
    procedure Add(const Text: WideString); safecall;
    procedure Delete(Index: Integer); safecall;
    procedure Insert(Index: Integer; const Text: WideString); safecall;
    function Get_Selection: WideString; safecall;
    procedure Set_Selection(const Value: WideString); safecall;
    function Get_CursorPosX: Integer; safecall;
    procedure Set_CursorPosX(Value: Integer); safecall;
    function Get_CursorPosY: Integer; safecall;
    procedure Set_CursorPosY(Value: Integer); safecall;
    procedure TempHightlightLine(Index: Integer); safecall;
    procedure CursorUp; safecall;
    procedure CursorDown; safecall;
    procedure CursorRight; safecall;
    procedure CursorLeft; safecall;
    function Get_Self: Integer; safecall;
    function Get_Filename: WideString; safecall;
    function Get_Modified: WordBool; safecall;
    procedure Set_Modified(Value: WordBool); safecall;
    property LineCount: Integer read Get_LineCount;
    property Lines[Index: Integer]: WideString read Get_Lines write Set_Lines;
    property ColorData[Index: Integer]: WideString read Get_ColorData write Set_ColorData;
    property Selection: WideString read Get_Selection write Set_Selection;
    property CursorPosX: Integer read Get_CursorPosX write Set_CursorPosX;
    property CursorPosY: Integer read Get_CursorPosY write Set_CursorPosY;
    property Self: Integer read Get_Self;
    property Filename: WideString read Get_Filename;
    property Modified: WordBool read Get_Modified write Set_Modified;
  end;

// *********************************************************************//
// DispIntf:  IDocumentDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A9991221-977F-4CE1-B514-A335E5FAB65F}
// *********************************************************************//
  IDocumentDisp = dispinterface
    ['{A9991221-977F-4CE1-B514-A335E5FAB65F}']
    property LineCount: Integer readonly dispid 201;
    property Lines[Index: Integer]: WideString dispid 202;
    property ColorData[Index: Integer]: WideString dispid 203;
    procedure Add(const Text: WideString); dispid 204;
    procedure Delete(Index: Integer); dispid 205;
    procedure Insert(Index: Integer; const Text: WideString); dispid 206;
    property Selection: WideString dispid 207;
    property CursorPosX: Integer dispid 208;
    property CursorPosY: Integer dispid 209;
    procedure TempHightlightLine(Index: Integer); dispid 210;
    procedure CursorUp; dispid 212;
    procedure CursorDown; dispid 213;
    procedure CursorRight; dispid 214;
    procedure CursorLeft; dispid 215;
    property Self: Integer readonly dispid 216;
    property Filename: WideString readonly dispid 217;
    property Modified: WordBool dispid 218;
  end;

// *********************************************************************//
// Interface: IProject
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A41D1250-5A42-4D0F-941A-E673B8B6BC7B}
// *********************************************************************//
  IProject = interface(IDispatch)
    ['{A41D1250-5A42-4D0F-941A-E673B8B6BC7B}']
    function Get_Self: Integer; safecall;
    function Get_Count: Integer; safecall;
    function AddFile(const Filename: WideString): OleVariant; safecall;
    procedure AddFolder(const Folder: WideString; const WildCard: WideString); safecall;
    procedure OpenProject(const Filename: WideString); safecall;
    procedure SaveProject; safecall;
    procedure NewProject(const Filename: WideString); safecall;
    function Get_Modified: WordBool; safecall;
    procedure Set_Modified(Value: WordBool); safecall;
    function Get_Items(Index: Integer): OleVariant; safecall;
    function Get_SelectedItem: OleVariant; safecall;
    procedure Set_SelectedItem(Value: OleVariant); safecall;
    function Get_Filename: WideString; safecall;
    procedure Set_Filename(const Value: WideString); safecall;
    function GetOpt(const Name: WideString): WideString; safecall;
    procedure SetOpt(const Name: WideString; const Value: WideString); safecall;
    procedure UpdateOptions; safecall;
    procedure RemoveFile(const Filename: WideString); safecall;
    property Self: Integer read Get_Self;
    property Count: Integer read Get_Count;
    property Modified: WordBool read Get_Modified write Set_Modified;
    property Items[Index: Integer]: OleVariant read Get_Items;
    property SelectedItem: OleVariant read Get_SelectedItem write Set_SelectedItem;
    property Filename: WideString read Get_Filename write Set_Filename;
  end;

// *********************************************************************//
// DispIntf:  IProjectDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A41D1250-5A42-4D0F-941A-E673B8B6BC7B}
// *********************************************************************//
  IProjectDisp = dispinterface
    ['{A41D1250-5A42-4D0F-941A-E673B8B6BC7B}']
    property Self: Integer readonly dispid 201;
    property Count: Integer readonly dispid 202;
    function AddFile(const Filename: WideString): OleVariant; dispid 204;
    procedure AddFolder(const Folder: WideString; const WildCard: WideString); dispid 205;
    procedure OpenProject(const Filename: WideString); dispid 206;
    procedure SaveProject; dispid 203;
    procedure NewProject(const Filename: WideString); dispid 208;
    property Modified: WordBool dispid 209;
    property Items[Index: Integer]: OleVariant readonly dispid 210;
    property SelectedItem: OleVariant dispid 211;
    property Filename: WideString dispid 207;
    function GetOpt(const Name: WideString): WideString; dispid 212;
    procedure SetOpt(const Name: WideString; const Value: WideString); dispid 213;
    procedure UpdateOptions; dispid 214;
    procedure RemoveFile(const Filename: WideString); dispid 215;
  end;

// *********************************************************************//
// Interface: INode
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB011271-4D28-475B-B55D-B9371ABB16CF}
// *********************************************************************//
  INode = interface(IDispatch)
    ['{EB011271-4D28-475B-B55D-B9371ABB16CF}']
    function Get_ID: Integer; safecall;
    function Get_Self: Integer; safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Line: Integer; safecall;
    procedure Set_Line(Value: Integer); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_Path: WideString; safecall;
    procedure Set_Path(const Value: WideString); safecall;
    property ID: Integer read Get_ID;
    property Self: Integer read Get_Self;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Line: Integer read Get_Line write Set_Line;
    property Hint: WideString read Get_Hint write Set_Hint;
    property Path: WideString read Get_Path write Set_Path;
  end;

// *********************************************************************//
// DispIntf:  INodeDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {EB011271-4D28-475B-B55D-B9371ABB16CF}
// *********************************************************************//
  INodeDisp = dispinterface
    ['{EB011271-4D28-475B-B55D-B9371ABB16CF}']
    property ID: Integer readonly dispid 201;
    property Self: Integer readonly dispid 203;
    property Caption: WideString dispid 202;
    property Line: Integer dispid 204;
    property Hint: WideString dispid 205;
    property Path: WideString dispid 206;
  end;

// *********************************************************************//
// Interface: ITreeView
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A69C0445-73AA-491A-9505-2194FAD97B31}
// *********************************************************************//
  ITreeView = interface(IDispatch)
    ['{A69C0445-73AA-491A-9505-2194FAD97B31}']
    function AddNode(const ParentNode: INode): OleVariant; safecall;
    procedure DeleteNode(const Node: INode); safecall;
    function GetFirstChild(const Node: INode): OleVariant; safecall;
    function GetNext(const Node: INode; Sibling: WordBool): OleVariant; safecall;
    function Get_RootNode: OleVariant; safecall;
    function GetFirst: OleVariant; safecall;
    procedure DeleteChildren(const Node: INode); safecall;
    function Node(ID: Integer): OleVariant; safecall;
    function Get_Self: Integer; safecall;
    function Get_MainNode(Index: Integer): OleVariant; safecall;
    property RootNode: OleVariant read Get_RootNode;
    property Self: Integer read Get_Self;
    property MainNode[Index: Integer]: OleVariant read Get_MainNode;
  end;

// *********************************************************************//
// DispIntf:  ITreeViewDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A69C0445-73AA-491A-9505-2194FAD97B31}
// *********************************************************************//
  ITreeViewDisp = dispinterface
    ['{A69C0445-73AA-491A-9505-2194FAD97B31}']
    function AddNode(const ParentNode: INode): OleVariant; dispid 201;
    procedure DeleteNode(const Node: INode); dispid 202;
    function GetFirstChild(const Node: INode): OleVariant; dispid 203;
    function GetNext(const Node: INode; Sibling: WordBool): OleVariant; dispid 204;
    property RootNode: OleVariant readonly dispid 205;
    function GetFirst: OleVariant; dispid 206;
    procedure DeleteChildren(const Node: INode); dispid 207;
    function Node(ID: Integer): OleVariant; dispid 208;
    property Self: Integer readonly dispid 209;
    property MainNode[Index: Integer]: OleVariant readonly dispid 210;
  end;

// *********************************************************************//
// Interface: IControl
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E1DC801E-2DFE-4EE4-87A6-D385B3C009AA}
// *********************************************************************//
  IControl = interface(IDispatch)
    ['{E1DC801E-2DFE-4EE4-87A6-D385B3C009AA}']
    function Get_Self: Integer; safecall;
    function GetP(const Prop: WideString): OleVariant; safecall;
    procedure SetP(const Prop: WideString; Value: OleVariant); safecall;
    procedure Event(const Event: WideString; const CallBack: WideString); safecall;
    function Get_Handle: Integer; safecall;
    property Self: Integer read Get_Self;
    property Handle: Integer read Get_Handle;
  end;

// *********************************************************************//
// DispIntf:  IControlDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {E1DC801E-2DFE-4EE4-87A6-D385B3C009AA}
// *********************************************************************//
  IControlDisp = dispinterface
    ['{E1DC801E-2DFE-4EE4-87A6-D385B3C009AA}']
    property Self: Integer readonly dispid 201;
    function GetP(const Prop: WideString): OleVariant; dispid 202;
    procedure SetP(const Prop: WideString; Value: OleVariant); dispid 203;
    procedure Event(const Event: WideString; const CallBack: WideString); dispid 204;
    property Handle: Integer readonly dispid 205;
  end;

// *********************************************************************//
// Interface: IWindow
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F6C6BA68-788D-4DCA-9FFF-132AADE58256}
// *********************************************************************//
  IWindow = interface(IDispatch)
    ['{F6C6BA68-788D-4DCA-9FFF-132AADE58256}']
    function Get_MainControl: OleVariant; safecall;
    procedure Show; safecall;
    function NewControl(Process: Integer; const ClassName: WideString; const Parent: IControl): OleVariant; safecall;
    function Get_Title: WideString; safecall;
    procedure Set_Title(const Value: WideString); safecall;
    function Get_Handle: Integer; safecall;
    function Get_Self: Integer; safecall;
    function Get_MainBarLinks: OleVariant; safecall;
    function Get_PopUpLinks: OleVariant; safecall;
    procedure Redraw; safecall;
    procedure Hide; safecall;
    property MainControl: OleVariant read Get_MainControl;
    property Title: WideString read Get_Title write Set_Title;
    property Handle: Integer read Get_Handle;
    property Self: Integer read Get_Self;
    property MainBarLinks: OleVariant read Get_MainBarLinks;
    property PopUpLinks: OleVariant read Get_PopUpLinks;
  end;

// *********************************************************************//
// DispIntf:  IWindowDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {F6C6BA68-788D-4DCA-9FFF-132AADE58256}
// *********************************************************************//
  IWindowDisp = dispinterface
    ['{F6C6BA68-788D-4DCA-9FFF-132AADE58256}']
    property MainControl: OleVariant readonly dispid 201;
    procedure Show; dispid 202;
    function NewControl(Process: Integer; const ClassName: WideString; const Parent: IControl): OleVariant; dispid 203;
    property Title: WideString dispid 204;
    property Handle: Integer readonly dispid 206;
    property Self: Integer readonly dispid 207;
    property MainBarLinks: OleVariant readonly dispid 208;
    property PopUpLinks: OleVariant readonly dispid 209;
    procedure Redraw; dispid 205;
    procedure Hide; dispid 210;
  end;

// *********************************************************************//
// Interface: IToolLinks
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF843630-2A12-4314-A7B0-3DB710DA0E43}
// *********************************************************************//
  IToolLinks = interface(IDispatch)
    ['{FF843630-2A12-4314-A7B0-3DB710DA0E43}']
    function Get_Self: Integer; safecall;
    procedure Add(ToolItem: OleVariant; BeginGroup: WordBool); safecall;
    function Get_Count: Integer; safecall;
    function Get_Items(Index: Integer): OleVariant; safecall;
    procedure AssignLinks(SourceLinks: OleVariant); safecall;
    property Self: Integer read Get_Self;
    property Count: Integer read Get_Count;
    property Items[Index: Integer]: OleVariant read Get_Items;
  end;

// *********************************************************************//
// DispIntf:  IToolLinksDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {FF843630-2A12-4314-A7B0-3DB710DA0E43}
// *********************************************************************//
  IToolLinksDisp = dispinterface
    ['{FF843630-2A12-4314-A7B0-3DB710DA0E43}']
    property Self: Integer readonly dispid 201;
    procedure Add(ToolItem: OleVariant; BeginGroup: WordBool); dispid 202;
    property Count: Integer readonly dispid 203;
    property Items[Index: Integer]: OleVariant readonly dispid 204;
    procedure AssignLinks(SourceLinks: OleVariant); dispid 205;
  end;

// *********************************************************************//
// Interface: IProjectItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C9FAC5B9-0D65-469E-8F34-636C5C061240}
// *********************************************************************//
  IProjectItem = interface(IDispatch)
    ['{C9FAC5B9-0D65-469E-8F34-636C5C061240}']
    function Get_Self: Integer; safecall;
    function Get_Filename: WideString; safecall;
    function Get_Mode: Integer; safecall;
    procedure Set_Mode(Value: Integer); safecall;
    function Get_Publish: WordBool; safecall;
    procedure Set_Publish(Value: WordBool); safecall;
    function Get_Text: WordBool; safecall;
    procedure Set_Text(Value: WordBool); safecall;
    function Get_PublishTo: WideString; safecall;
    procedure Set_PublishTo(const Value: WideString); safecall;
    property Self: Integer read Get_Self;
    property Filename: WideString read Get_Filename;
    property Mode: Integer read Get_Mode write Set_Mode;
    property Publish: WordBool read Get_Publish write Set_Publish;
    property Text: WordBool read Get_Text write Set_Text;
    property PublishTo: WideString read Get_PublishTo write Set_PublishTo;
  end;

// *********************************************************************//
// DispIntf:  IProjectItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C9FAC5B9-0D65-469E-8F34-636C5C061240}
// *********************************************************************//
  IProjectItemDisp = dispinterface
    ['{C9FAC5B9-0D65-469E-8F34-636C5C061240}']
    property Self: Integer readonly dispid 201;
    property Filename: WideString readonly dispid 202;
    property Mode: Integer dispid 203;
    property Publish: WordBool dispid 204;
    property Text: WordBool dispid 205;
    property PublishTo: WideString dispid 206;
  end;

// *********************************************************************//
// Interface: IToolItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {70E0C93C-5987-47B9-A167-99B6CA3E307C}
// *********************************************************************//
  IToolItem = interface(IDispatch)
    ['{70E0C93C-5987-47B9-A167-99B6CA3E307C}']
    function Get_Self: Integer; safecall;
    function Get_Enabled: WordBool; safecall;
    procedure Set_Enabled(Value: WordBool); safecall;
    function Get_Hint: WideString; safecall;
    procedure Set_Hint(const Value: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    procedure Set_Image(const Param1: WideString); safecall;
    function Get_Visible: WordBool; safecall;
    procedure Set_Visible(Value: WordBool); safecall;
    function Get_Shortcut: WideString; safecall;
    procedure Set_Shortcut(const Value: WideString); safecall;
    function Get_ToolLinks: OleVariant; safecall;
    procedure SetOptions(const Caption: WideString; const Hint: WideString; 
                         const Image: WideString; const Shortcut: WideString; 
                         const OnClick: WideString); safecall;
    function Get_OnClick: WideString; safecall;
    procedure Set_OnClick(const Value: WideString); safecall;
    property Self: Integer read Get_Self;
    property Enabled: WordBool read Get_Enabled write Set_Enabled;
    property Hint: WideString read Get_Hint write Set_Hint;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Image: WideString write Set_Image;
    property Visible: WordBool read Get_Visible write Set_Visible;
    property Shortcut: WideString read Get_Shortcut write Set_Shortcut;
    property ToolLinks: OleVariant read Get_ToolLinks;
    property OnClick: WideString read Get_OnClick write Set_OnClick;
  end;

// *********************************************************************//
// DispIntf:  IToolItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {70E0C93C-5987-47B9-A167-99B6CA3E307C}
// *********************************************************************//
  IToolItemDisp = dispinterface
    ['{70E0C93C-5987-47B9-A167-99B6CA3E307C}']
    property Self: Integer readonly dispid 201;
    property Enabled: WordBool dispid 202;
    property Hint: WideString dispid 203;
    property Caption: WideString dispid 204;
    property Image: WideString writeonly dispid 205;
    property Visible: WordBool dispid 206;
    property Shortcut: WideString dispid 207;
    property ToolLinks: OleVariant readonly dispid 208;
    procedure SetOptions(const Caption: WideString; const Hint: WideString; 
                         const Image: WideString; const Shortcut: WideString; 
                         const OnClick: WideString); dispid 209;
    property OnClick: WideString dispid 210;
  end;

// *********************************************************************//
// The Class CoApplication provides a Create and CreateRemote method to          
// create instances of the default interface IApplication exposed by              
// the CoClass Application. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoApplication = class
    class function Create: IApplication;
    class function CreateRemote(const MachineName: string): IApplication;
  end;

// *********************************************************************//
// The Class CoDocument provides a Create and CreateRemote method to          
// create instances of the default interface IDocument exposed by              
// the CoClass Document. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoDocument = class
    class function Create: IDocument;
    class function CreateRemote(const MachineName: string): IDocument;
  end;

// *********************************************************************//
// The Class CoProject provides a Create and CreateRemote method to          
// create instances of the default interface IProject exposed by              
// the CoClass Project. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoProject = class
    class function Create: IProject;
    class function CreateRemote(const MachineName: string): IProject;
  end;

// *********************************************************************//
// The Class CoNode provides a Create and CreateRemote method to          
// create instances of the default interface INode exposed by              
// the CoClass Node. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoNode = class
    class function Create: INode;
    class function CreateRemote(const MachineName: string): INode;
  end;

// *********************************************************************//
// The Class CoTreeView provides a Create and CreateRemote method to          
// create instances of the default interface ITreeView exposed by              
// the CoClass TreeView. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoTreeView = class
    class function Create: ITreeView;
    class function CreateRemote(const MachineName: string): ITreeView;
  end;

// *********************************************************************//
// The Class CoControl provides a Create and CreateRemote method to          
// create instances of the default interface IControl exposed by              
// the CoClass Control. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoControl = class
    class function Create: IControl;
    class function CreateRemote(const MachineName: string): IControl;
  end;

// *********************************************************************//
// The Class CoWindow provides a Create and CreateRemote method to          
// create instances of the default interface IWindow exposed by              
// the CoClass Window. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoWindow = class
    class function Create: IWindow;
    class function CreateRemote(const MachineName: string): IWindow;
  end;

// *********************************************************************//
// The Class CoToolLinks provides a Create and CreateRemote method to          
// create instances of the default interface IToolLinks exposed by              
// the CoClass ToolLinks. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoToolLinks = class
    class function Create: IToolLinks;
    class function CreateRemote(const MachineName: string): IToolLinks;
  end;

// *********************************************************************//
// The Class CoProjectItem provides a Create and CreateRemote method to          
// create instances of the default interface IProjectItem exposed by              
// the CoClass ProjectItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoProjectItem = class
    class function Create: IProjectItem;
    class function CreateRemote(const MachineName: string): IProjectItem;
  end;

// *********************************************************************//
// The Class CoToolItem provides a Create and CreateRemote method to          
// create instances of the default interface IToolItem exposed by              
// the CoClass ToolItem. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoToolItem = class
    class function Create: IToolItem;
    class function CreateRemote(const MachineName: string): IToolItem;
  end;

implementation

uses ComObj;

class function CoApplication.Create: IApplication;
begin
  Result := CreateComObject(CLASS_Application) as IApplication;
end;

class function CoApplication.CreateRemote(const MachineName: string): IApplication;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Application) as IApplication;
end;

class function CoDocument.Create: IDocument;
begin
  Result := CreateComObject(CLASS_Document) as IDocument;
end;

class function CoDocument.CreateRemote(const MachineName: string): IDocument;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Document) as IDocument;
end;

class function CoProject.Create: IProject;
begin
  Result := CreateComObject(CLASS_Project) as IProject;
end;

class function CoProject.CreateRemote(const MachineName: string): IProject;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Project) as IProject;
end;

class function CoNode.Create: INode;
begin
  Result := CreateComObject(CLASS_Node) as INode;
end;

class function CoNode.CreateRemote(const MachineName: string): INode;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Node) as INode;
end;

class function CoTreeView.Create: ITreeView;
begin
  Result := CreateComObject(CLASS_TreeView) as ITreeView;
end;

class function CoTreeView.CreateRemote(const MachineName: string): ITreeView;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_TreeView) as ITreeView;
end;

class function CoControl.Create: IControl;
begin
  Result := CreateComObject(CLASS_Control) as IControl;
end;

class function CoControl.CreateRemote(const MachineName: string): IControl;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Control) as IControl;
end;

class function CoWindow.Create: IWindow;
begin
  Result := CreateComObject(CLASS_Window) as IWindow;
end;

class function CoWindow.CreateRemote(const MachineName: string): IWindow;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Window) as IWindow;
end;

class function CoToolLinks.Create: IToolLinks;
begin
  Result := CreateComObject(CLASS_ToolLinks) as IToolLinks;
end;

class function CoToolLinks.CreateRemote(const MachineName: string): IToolLinks;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ToolLinks) as IToolLinks;
end;

class function CoProjectItem.Create: IProjectItem;
begin
  Result := CreateComObject(CLASS_ProjectItem) as IProjectItem;
end;

class function CoProjectItem.CreateRemote(const MachineName: string): IProjectItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ProjectItem) as IProjectItem;
end;

class function CoToolItem.Create: IToolItem;
begin
  Result := CreateComObject(CLASS_ToolItem) as IToolItem;
end;

class function CoToolItem.CreateRemote(const MachineName: string): IToolItem;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_ToolItem) as IToolItem;
end;

end.
