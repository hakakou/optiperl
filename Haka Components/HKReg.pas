unit HKReg;

interface
uses HKActions,HKFormEx,ActnList,Forms,Windows,  Classes,
     ExptIntf, ToolIntf, EditIntf, VirtIntf, designintf,DesignEditors;

type
  TFormExExpert = class(TIExpert)
  private
    procedure RunExpert(ToolServices: TIToolServices);
  public
    function GetName: string; override;
    function GetAuthor: string; override;
    function GetComment: string; override;
    function GetPage: string; override;
    function GetGlyph: HICON; override;
    function GetStyle: TExpertStyle; override;
    function GetState: TExpertState; override;
    function GetIDString: string; override;
    function GetMenuText: string; override;
    procedure Execute; override;
  end;


procedure Register;
implementation

procedure Register;
begin
 if Assigned(RegisterActionsProc) then
 begin
  RegisterActions('Haka', [THKAction], THKAction);
  RegisterCustomModule(TFormEx, TCustomModule);
  RegisterLibraryExpert(TFormExExpert.create);
 end;
end;


const
  CRLF = #13#10;
  CRLF2 = #13#10#13#10;
  DefaultModuleFlags = [cmShowSource, cmShowForm, cmMarkModified, cmUnNamed];

resourcestring
  sCustFormExpertAuthor = 'Harry Kakoulidis';
  sCustFormExpertName   = 'FormEx HKForm';
  sCustFormExpertDesc   = 'Create a new TFormEx';

{ TFormExModuleCreator }

type
  TFormExModuleCreator = class(TIModuleCreator)
  private
    FAncestorIdent : string;
    FAncestorClass : TClass;
    FFormIdent : string;
    FUnitIdent : string;
    FFileName  : string;
  public
    function Existing: Boolean; override;
    function GetFileName: string; override;
    function GetFileSystem: string; override;
    function GetFormName: string; override;
    function GetAncestorName: string; override;
    function NewModuleSource(const UnitIdent, FormIdent, AncestorIdent: string): string; override;
    procedure FormCreated(Form: TIFormInterface); override;
  end;

function TFormExModuleCreator.Existing:boolean;
begin
  Result:=False
end;

function TFormExModuleCreator.GetFileName:string;
begin
  Result:=FFileName; //'';
end;

function TFormExModuleCreator.GetFileSystem:string;
begin
  Result:='';
end;

function TFormExModuleCreator.GetFormName:string;
begin
  Result:=FFormIdent;
end;

function TFormExModuleCreator.GetAncestorName:string;
begin
  Result:=FAncestorIdent;
end;

function TFormExModuleCreator.NewModuleSource(const UnitIdent,FormIdent,AncestorIdent:string):string;
var
  s : string;
begin
  s:='unit '+FUnitIdent+';'+CRLF2+
     'interface'+CRLF2+
     'uses'+CRLF+
     '  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs';

  if (FAncestorIdent<>'Form') and (FAncestorIdent<>'DataModule') then
    s:=s+','+CRLF+
      '  HKFormEx';

  s:=s+';'+CRLF2+
    'type'+CRLF+
    '  T'+FFormIdent+' = class(TFormEx)'+CRLF+
    '  private'+CRLF+
    '    { Private declarations }'+CRLF+
    '  public'+CRLF+
    '    { Public declarations }'+CRLF+
    '  end;'+CRLF2;

  s:=s+
    'var'+CRLF+
    '  '+FFormIdent+' : T'+FFormIdent+';'+CRLF2;

  s:=s+
      'implementation'+CRLF2;

  s:=s+
    '{$R *.DFM}'+CRLF2;

  s:=s+
      'end.';

  Result:=s;
end;

procedure TFormExModuleCreator.FormCreated(Form:TIFormInterface);
begin
end;

{ HandleException }

procedure HandleException;
begin
  ToolServices.RaiseException(ReleaseException);
end;

{ TFormExExpert }

function TFormExExpert.GetName: string;
begin
  try
    Result := sCustFormExpertName;
  except
    HandleException;
  end;
end;

function TFormExExpert.GetComment: string;
begin
  try
    Result := sCustFormExpertDesc;
  except
    HandleException;
  end;
end;

function TFormExExpert.GetGlyph: HICON;
begin
  result:=0;
{  try
    Result := LoadIcon(HInstance, 'NEWRMDOCKFORM');
  except
    HandleException;
  end;}
end;

function TFormExExpert.GetStyle: TExpertStyle;
begin
  try
    Result := esForm;
  except
    HandleException;
  end;
end;

function TFormExExpert.GetState: TExpertState;
begin
  try
    Result := [esEnabled];
  except
    HandleException;
  end;
end;

function TFormExExpert.GetIDString: string;
begin
  try
    Result := 'Xarka.'+sCustFormExpertName;
  except
    HandleException;
  end;
end;

function TFormExExpert.GetMenuText: string;
begin
   try
     result := '';
   except
     HandleException;
   end;
end;

function TFormExExpert.GetAuthor: string;
begin
  try
    Result := sCustFormExpertAuthor;
  except
    HandleException;
  end;
end;

function TFormExExpert.GetPage: string;
begin
  try
    Result := 'New';
  except
    HandleException;
  end;
end;

procedure TFormExExpert.Execute;
begin
  try
    RunExpert(ToolServices);
  except
    HandleException;
  end;
end;

procedure TFormExExpert.RunExpert(ToolServices: TIToolServices);
var
  ModuleFlags : TCreateModuleFlags;
  IModuleCreator : TFormExModuleCreator;
  IModule : TIModuleInterface;
begin
  if ToolServices = nil then Exit;
  IModuleCreator:=TFormExModuleCreator.Create;
  IModuleCreator.FAncestorIdent:='FormEx';
  IModuleCreator.FAncestorClass:=TFormEx;
  ToolServices.GetNewModuleAndClassName(IModuleCreator.FAncestorIdent,IModuleCreator.FUnitIdent,IModuleCreator.FFormIdent,IModuleCreator.FFileName);
  ModuleFlags:=DefaultModuleFlags;
  ModuleFlags:=ModuleFlags+[cmAddToProject];
  try
    IModule:=ToolServices.ModuleCreate(IModuleCreator,ModuleFlags);
    IModule.Free;
  finally
    IModuleCreator.Free;
  end;
end;


end.
