unit CentralImageListMdl;    //Module

{$I REG.INC}

interface

uses
  SysUtils, Windows, Classes, ImgList, Controls,graphics,HakaGeneral,dialogs,shellapi,
  {$IFDEF SAVEDEBUGFILES}
  jvIcon,
  {$ENDIF}
  JvComponent, JvBaseDlg, JvWinDialogs, HyperStr, HakaFile, HKGraphics,optfolders;
  
type
  TCentralImageListMod = class(TDataModule)
    ImageList: TImageList;       
    ChangeIconDialog: TJvChangeIconDialog;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    Function GetFilename(const Image : String) : String;
    Function GetIndex(const Image : String) : Integer;
  public
    ToolsStart : Integer;
    Tools : TStringList;
    Function GetImage(const ToolHash, Image : String) : Integer;
    Procedure GetGlyph(SourcePath,Image : String; Bmp : TBitmap);
    Procedure DeleteImages;
    function SelectIcon(const Image : String): String;
  end;

var
  CentralImageListMod: TCentralImageListMod;
Const
  DefToolIcon = 146;

implementation

{$R *.dfm}


procedure TCentralImageListMod.GetGlyph(SourcePath,Image: String; Bmp: TBitmap);
var
 icon : TIcon;
 IcS,Icl : HIcon;
 w,h : Integer;
 s:String;
begin
 ReplaceSC(Image,'%SystemRoot%',hyperstr.GetWinDir,true);
 ReplaceSC(Image,'%opti%',ProgramPath,true);
 if (Image<>'') then
  Image:=GetAbsoluteFile(excludetrailingbackslash(extractfilepath(SourcePath)),Image);
 Icl:=0; ics:=0;
 s:=GetFilename(image);
 if (fileexists(s)) and
    (ExtractIconEx(pchar(s),GetIndex(image),icl,ics,1)<>0) then
 begin
  w:=GetSystemMetrics(SM_CXSMICON);
  h:=GetSystemMetrics(SM_CYSMICON);
  icon:=TIcon.Create;
  icon.Handle:=ics;

  bmp.Width:=w;
  bmp.Height:=h;
  bmp.Canvas.FillRect(bmp.Canvas.ClipRect);
  bmp.Canvas.Draw(0,0,icon);
  if (bmp.Width<>16) or (bmp.Height<>16) then
   Stretch(16,16,bmp);
  DestroyIcon(ics);
  DestroyIcon(icl);
  icon.free;
 end
end;

Function TCentralImageListMod.GetImage(const ToolHash, Image : String) : Integer;
var
 i:integer;
 icon : TIcon;
 IcS,Icl : HIcon;
 s:String;
begin
 i:=tools.indexof(ToolHash);
 if i>=0 then
  result:=Integer(Tools.objects[i])
 else
  begin
   Icon:=TIcon.create;
   Icl:=0; ics:=0;
   s:=GetFilename(image);
   if (fileexists(s)) and
      (ExtractIconEx(pchar(s),GetIndex(image),icl,ics,1)<>0) then
    begin
     Icon.Handle:=ics;
     i:=imagelist.AddIcon(Icon);
     DestroyIcon(ics);
     DestroyIcon(icl);
    end
   else
    i:=DefToolIcon;

   Icon.free;
   Tools.AddObject(ToolHash,TObject(i));
   result:=i;
  end;
end;

Function TCentralImageListMod.SelectIcon(const Image : String) : String;
begin
 if FileExists(Getfilename(image)) then
  begin
   ChangeIconDialog.filename:=Getfilename(image);
   ChangeIconDialog.IconIndex:=GetIndex(image);
  end
 Else
  begin
   ChangeIconDialog.filename:='';
   ChangeIconDialog.IconIndex:=0;
  end;
 ChangeIconDialog.Execute;
 result:=Format('%s,%d',[ChangeIconDialog.Filename,ChangeIconDialog.IconIndex]);
 ReplaceSC(result,ProgramPath,'%opti%',true);
end;

procedure TCentralImageListMod.DataModuleCreate(Sender: TObject);
{$IFDEF SAVEDEBUGFILES}
var
 jv : TjvIcon;
 bmp : TBitmap;
 i:integer;
{$ENDIF}
begin
 ToolsStart:=ImageList.Count;
 Tools:=TStringList.create;
 Tools.duplicates:=dupError;
 Tools.sorted:=true;
 {$IFDEF SAVEDEBUGFILES}
 for i:=0 to imagelist.Count-1 do
 begin
  jv:=TjvIcon.Create(nil);
  bmp:=TBitmap.Create;
  ImageList.GetBitmap(i,bmp);
  jv.SaveAsIcon256(bmp,
  format('c:\unzip\OptiPerl Exe\Icons\OP%3d.ico',[i]));
  jv.Free;
  bmp.free;
 end;
 {$ENDIF}
end;

procedure TCentralImageListMod.DataModuleDestroy(Sender: TObject);
begin
 Tools.free;
end;

function TCentralImageListMod.GetFilename(const Image: String): String;
var i:integer;
begin
 i:=scanB(image,',',0);
 Dec(i);
 if i<1 then i:=length(image);
 result:=copy(image,1,i);
 ReplaceSC(result,'%SystemRoot%',hyperstr.GetWinDir,true);
 ReplaceSC(result,'%opti%',ProgramPath,true);
end;

function TCentralImageListMod.GetIndex(const Image: String): Integer;
var i:integer;
begin
 i:=scanB(image,',',0);
 result:=StrToIntDef(copyFromToEnd(image,i+1),0);
end;

procedure TCentralImageListMod.DeleteImages;
var i:integer;
begin
 for i:=ImageList.Count-1 downto ToolsStart do
  ImageList.Delete(i);
 Tools.Clear;
end;


end.