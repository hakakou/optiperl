{***************************************************************
 *
 * Unit Name: RunPerl
 * Date     : 11/10/2000 9:28:02 рм
 * Purpose  : Run Perl and Perl Info
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit RunPerl;  //Unit
{$I REG.INC}

interface

uses sysutils,hakageneral,hyperstr,hyperfrm,windows,perlapi,
     optgeneral,classes,OptOptions,OptFolders,dialogs,jclfileutils,
     hakahyper,hkdebug,PerlHelpers,hakafile,DIPcre;

type
 EPerlLoadError = class(Exception);

Function SearchModule(Const Module,CurrentPath : string; InPerlOnly : Boolean) : String;
Procedure UpdateModSearchPaths;
Function GetLibPath(Const CurrentPath : String) : String;
Function GetPodName(const Filename : String) : String;

//Function PerlCommand(const switches,programfile,arguments : string) : string;
//Function GetPerlInfo : String;
//Procedure ProfileScript(const script : string; Times,Tree : TStrings);

implementation

var
 SearchPathGlobal,SearchPathPerl : TStringList;
 LibPath : String = '';
 GlobalPerlPath : String = '';
 ModuleSearchPcre : TDiPcre;

Function GetPodName(const Filename : String) : String;
begin
 result:=ExtractFilePath(Filename)+ExtractFileNoExt(Filename)+'.pod';
end;

Function GetLibPath(Const CurrentPath : String) : String;
begin
 result:=LibPath+excludeTrailingBackSlash(ExtractFilePath(CurrentPath));
end;

Procedure UpdateModSearchPaths;
var
 i:integer;
 w,sd:string;
begin
 SearchPathGlobal.Clear;
 SearchPathPerl.Clear;
 sd:=Options.PerlSearchDir;
 i:=1;

 repeat
  W := IncludeTrailingBackSlash(trim(Parse(sd,';',i)));
  if DirectoryExists(w) then
   SearchPathGlobal.Add(w);
 until (I<1) or (I>Length(sd));

 LibPath:='';
 for i:=0 to SearchPathGlobal.Count-1 do
  LibPath:=LibPath+excludeTrailingBackSlash(SearchPathGlobal[i])+';';

 GlobalPerlPath:=FastFindINCPath(options.PathToPerl)+';';
 i:=1;
 repeat
  W := IncludeTrailingBackSlash(trim(Parse(GlobalPerlPath,';',i)));
  if DirectoryExists(w) then
   SearchPathPerl.Add(w);
 until (I<1) or (I>Length(GlobalPerlPath));

 replaceC(GlobalPerlPath,'\','/');
end;

Function SearchModule(Const Module,CurrentPath : string; InPerlOnly : Boolean) : String;
var
 AMod : String;
 Lib : TStrings;
 i:integer;
begin
 //Assert(false,'LOG Searching for '+module);
 AMod:=Module;
 if (pos('$',Amod)>0) and (ModuleSearchPcre.MatchStr(amod)>0) then
  Amod:=ModuleSearchPcre.SubStr(1);

 replaceSC(AMod,'::','\',false);
 AMod:=removequotes(AMod,'"');
 AMod:=removequotes(AMod,'''');
 if InPerlOnly then
  Lib:=SearchPathPerl
 else
  begin
   Lib:=SearchPathGlobal;

   result:=CurrentPath+AMod+'.pm';
   if fileexists(result) then exit;
   result:=CurrentPath+AMod;
   if fileexists(result) then exit;
  end;

 for i:=0 to lib.Count-1 do
 begin
  result:=lib[i]+AMod+'.pm';
  if fileexists(result) then exit;
  result:=lib[i]+AMod;
  if fileexists(result) then exit;
 end;
 result:='';
end;
{
Procedure ProfileScript(const script : string; Times,Tree : TStrings);
const
 dproffile = 'tmon.out';
var
 path,cl : string;
 tmpfile : string;
 pi : TProcessInformation;
 dprofpp : string;
begin
 DProfpp:=extractFilePath(Options.PathToPerl)+'dprofpp.bat';
 if not fileexists(dprofpp) then
 begin
  Times.Clear;
  Tree.Clear;
  Exit;
 end;

 TmpFile:=GetTempFile;
 path:=ExtractFilePath(Script);

 try
  cl:='"'+Options.PathToPerl+'" -d:DProf "'+script+'"';
  WaitExec(cl,SW_HIDE);

  //Get Times

  if Assigned(Times) then
  begin
   if fileexists(path+dproffile) then
    PipeExeToFile(DProfpp,'',path,tmpfile,'',pi);
   if fileexists(TmpFile) then
   begin
    Times.LoadFromFile(tmpfile);
    deletefile(PChar(tmpfile));
   end;
  end;
  //get tree

  if Assigned(Tree) then
  begin
   if fileexists(path+dproffile) then
    PipeExeToFile(DProfpp,'-t',path,tmpfile,'',pi);
   if fileexists(TmpFile) then
   begin
    Tree.LoadFromFile(tmpfile);
    deletefile(PChar(tmpfile));
   end;
  end;

 finally
  if fileexists(path+dproffile) then
   deletefile(PChar(path+dproffile));
 end;
end;

Function PerlCommand(const switches,programfile,arguments : string) : string;
begin
 result:=switches+' '+addquotes(programfile,'"')+' '+arguments ;
end;

Function GetPerlInfo : String;
var fn : string;
begin
 fn:=getTempFile;
 WaitExec(Options.PathToPerl+' -v>'+fn,SW_HIDE);
 result:=LoadStr(fn);
 WaitExec(Options.PathToPerl+' -V>'+fn,SW_HIDE);
 result:=result+LoadStr(fn);
 deleteFile(pchar(fn));
end;
}

initialization
 SearchPathGlobal:=TStringList.Create;
 SearchPathPerl:=TStringList.Create;
 ModuleSearchPcre:=TDiPcre.Create(nil);
 ModuleSearchPcre.MatchPattern:='\$[^\/\\]+[\/\\]([^\$]+)$';
finalization
 SearchPathGlobal.free;
 SearchPathPerl.free;
 ModuleSearchPcre.Free;
end.