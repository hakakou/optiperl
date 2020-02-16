unit QueryFrm; //modeless //memo 1 //Tabs //Splitter

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, hyperstr,hakageneral,OptGeneral,OptProcs,
  Menus, jvCtrls, DIPcre, hyperfrm,OptQuery,OptForm,hakawin,aqDockingBase,
  FormSelectFrm, ActnList, ScriptInfoUnit, httpapp, ComCtrls,optFolders,
  dccommon, dcmemo, ParsersMdl,agproputils, QueryFm, ValEdit, Hakafile,
  ToolWin,OptOptions, HKActions, Buttons, dxBar, CentralImageListMdl,
  HaKaTabs;

type
  TQueryForm = class(TOptiForm)
    Pcre: TDIPcre;
    OpenDialog: TOpenDialog;
    PcreName: TDIPcre;
    PcreValue: TDIPcre;
    PcreType: TDIPcre;
    PcreForm: TDIPcre;
    ActionList: TActionList;
    ImportFileAction: THKAction;
    ImportWebAction: THKAction;
    SaveShotAction: THKAction;
    DelShotAction: THKAction;
    EnGetAction: THKAction;
    EnPostAction: THKAction;
    EnPathInfoAction: THKAction;
    EnCookieAction: THKAction;
    PageControl: THKPageControl;
    GetSheet: TTabSheet;
    PostSheet: TTabSheet;
    PathInfoSheet: TTabSheet;
    CookieSheet: TTabSheet;
    EnvironmentSheet: TTabSheet;
    CopyGetAction: THKAction;
    CopyPostAction: THKAction;
    CopyPathInfoAction: THKAction;
    rbEncode1: TRadioButton;
    rbEncode2: TRadioButton;
    PrevSheet: TTabSheet;
    vlPreview: TValueListEditor;
    memPreview: TDCMemo;
    Splitter: TSplitter;
    PreviewAction: THKAction;
    OpenQueryEditorAction: THKAction;
    GetFrame: TQueryFrame;
    PostFrame: TQueryFrame;
    PathInfoFrame: TQueryFrame;
    CookieFrame: TQueryFrame;
    SelectDialog: TOpenDialog;
    lblCookies: TLabel;
    cbCookies: TComboBox;
    rbEncode3: TRadioButton;
    vlEnv: TStringGrid;
    QuerySelectFileAction: THKAction;
    BarManager: TdxBarManager;
    siMethods: TdxBarSubItem;
    siCopy: TdxBarSubItem;
    dxEnGet: TdxBarButton;
    dxEnPost: TdxBarButton;
    dxEnPathinfo: TdxBarButton;
    dxEnCookie: TdxBarButton;
    dxImpFile: TdxBarButton;
    dxImpWeb: TdxBarButton;
    dxAddVal: TdxBarButton;
    dxDelVals: TdxBarButton;
    dxCopyGet: TdxBarButton;
    dxCopyPost: TdxBarButton;
    dxCopyPathinfo: TdxBarButton;
    dxSelectFile: TdxBarButton;
    siPopup: TdxBarSubItem;
    IncExtVariablesAction: THKAction;
    dxIncExtVariables: TdxBarButton;
    procedure EnableAction(Sender: TObject);
    procedure EnableUpdate(Sender: TObject);
    procedure SaveShotActionExecute(Sender: TObject);
    procedure DelShotActionExecute(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ImportFileActionExecute(Sender: TObject);
    procedure ImportWebActionExecute(Sender: TObject);
    procedure CopyGetActionExecute(Sender: TObject);
    procedure CopyPostActionExecute(Sender: TObject);
    procedure CopyPathInfoActionExecute(Sender: TObject);
    procedure rbEncode1Click(Sender: TObject);
    procedure rbEncode2Click(Sender: TObject);
    procedure PreviewActionExecute(Sender: TObject);
    procedure OpenQueryEditorActionExecute(Sender: TObject);
    procedure CopyActionUpdate(Sender: TObject);
    procedure ImportWebActionUpdate(Sender: TObject);
    procedure ImportFileActionUpdate(Sender: TObject);
    procedure vlEnvKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbCookiesDropDown(Sender: TObject);
    procedure cbCookiesSelect(Sender: TObject);
    procedure rbEncode3Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure QuerySelectFileActionExecute(Sender: TObject);
    procedure QuerySelectFileActionUpdate(Sender: TObject);
    procedure PageControlMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IncExtVariablesActionExecute(Sender: TObject);
    procedure IncExtVariablesActionUpdate(Sender: TObject);
  private
    QueryLink : TdxBarItemLink;
    Procedure ParseAll(Const Text : String; querygrid : TStringGrid);
    procedure Parse(Const Text : String; querygrid : TStringGrid);
    procedure DoTheParse(Const Text : String);
    procedure SetvlEnv;
    Function ActiveMethod : TQueryTypes;
    procedure UpdatePreview;
  protected
    procedure FirstShow(Sender: TObject); override;
    Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); override;
    procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer); override;
    procedure _ActiveScriptChanged;
  public
    QueryCombos : Array[0..3] of TdxBarCombo;
    Procedure UpdateAll;
  end;

var
 QueryForm : TQueryForm;

implementation
const
 QueryTags : Array[0..3] of TQueryTypes = (qmGet,qmPost,qmPathInfo,qmCookie);
 InputPat='<[^>]*(?:input|select)\ +([^>]+)>';
 TextAreaPat='<\s*textarea[^>]*name\s*=\s*(?:\"([^\"]*)\"|(\w+))[^>]*>([^<]*)<\/textarea>';

{$R *.DFM}

procedure TQueryForm.FirstShow(Sender: TObject);
var
 i:integer;
begin
 PC_Query_ActiveScriptChanged:=_ActiveScriptChanged;
 PageControl.ActivePageIndex:=0;
 SetMemo(memPreview,[]);
 memPreview.memosource.SyntaxParser:=parsersmod.HeadParser;

 GetFrame.IsQuery:=qmGet;
 PostFrame.IsQuery:=qmPost;
 PathInfoFrame.IsQuery:=qmPathInfo;
 CookieFrame.IsQuery:=qmCookie;

 GetFrame.CreateFrame;
 PathInfoFrame.CreateFrame;
 PostFrame.CreateFrame;
 CookieFrame.CreateFrame;

 if folders.CookiesFolder='' then
 begin
  cbCookies.Visible:=false;
  CookieFrame.Align:=alClient;
 end;

 if not assigned(queryLink) then
  with barmanager.Bars[0].ItemLinks do
   for i:=0 to count-1 do
    if items[i].Item=dxSelectFile then
    begin
     QueryLink:=items[i];
     break;
    end;

 PageControlChange(sender);
 UpdateAll;
end;

Procedure TQueryForm.ParseAll(Const Text : String; querygrid : TStringGrid);
var
 FName,Faction,s:string;
 FSF: TFormSelectForm;
 i,j:integer;
begin
 FSF:=TFormSelectForm.create(application);
 pcreForm.SetSubjectStr(text);
 i:=0;
 with pcreForm do
  if Match(0)>=0 then
   repeat
    s:=SubStr(1);
    j:=pcreName.MatchStr(s);
    if (j>0)
     then Fname:=pcreName.SubStr(j-1)
     else Fname:='<no name>';
    pcre.MatchPattern:='action\s*=(?:\s*\"([^\"]*)\"|(\S+))';
    j:=pcre.MatchStr(s);
    if j>0
     then FAction:=pcre.SubStr(j-1)
     else FAction:='<no action>';
    inc(i);
    FSF.Forms.Items.addobject(
     'Form:'+inttostr(i)+'  Name:'+FName+'  Action:'+FAction,
     TObject(MatchedStrAfterLastCharPos));
    until Match(MatchedStrAfterLastCharPos)<0;
 if (i>0) then FSF.Forms.ItemIndex:=0;
 if ((i>1) and (FSF.showmodal<>mrOK)) or
     (i=0) then
 begin
  FSF.free;
  exit;
 end;
 with fsf.Forms do
 begin
  if itemindex<items.count-1
  then
   s:=copyFromTo(text,integer(items.objects[itemindex]),Integer(items.objects[itemindex+1]))
  else
   s:=copyFromToEnd(text,integer(items.objects[itemindex]));
 end;
 FSF.free;
 Parse(s,QueryGrid);
end;

procedure TQueryForm.Parse(Const Text : String; querygrid : TStringGrid);
var
 j,i,p:integer;
 s,q,n:string;
 inquote : boolean;
begin
 for i:=1 to querygrid.RowCount-1 do
 begin
  querygrid.cells[0,i]:='';
  querygrid.cells[1,i]:='';
 end;
 SafeFocus(querygrid);
 i:=0;

 //search for text area
 PCRE.MatchPattern:=TextAreaPat;
 pcre.SetSubjectStr(text);
 with pcre do
 begin
  j:=Match(0);
  if j>0 then
   repeat
    s:=copy(text,MatchedStrFirstCharPos+1,MatchedStrLength);
    inc(i);
    q:=SubStr(1);
    if q='' then q:=SubStr(2);
    querygrid.cells[0,i]:=q;
    q:=SubStr(3);
    replaceSC(q,#13#10,'\n',false);
    replaceSC(q,#9,'\t',false);
    querygrid.cells[1,i]:=q;
   until Match(MatchedStrAfterLastCharPos)<0;
 end;

 //search for form elements
 PCRE.MatchPattern:=InputPat;
 p:=1;
 while pcre.matchStr(text,p)>0 do
 begin
  if i>=queryGrid.RowCount then break;
  s:=copy(text,pcre.MatchedStrFirstCharPos+1,pcre.MatchedStrLength);
  inc(i);
  q:=pcre.SubStr(1);

  //Get "Name"
  j:=pcreName.MatchStr(q);
  if j>0 then
   querygrid.cells[0,i]:=pcrename.SubStr(j-1);

  //Get "Value"
  j:=pcreValue.MatchStr(q);
  if j>0 then
   querygrid.cells[1,i]:=(pcrevalue.SubStr(j-1));

  //Get "Type"
  j:=pcreType.MatchStr(q);
  if j>0
   then n:=pcreType.SubStr(j-1)
   else n:='';

  if ((n='checkbox') or (n='radio')) then
  begin
   inquote:=false;
   for j:=1 to length(q) do begin
    if (q[j]='"') then
     inquote:=not inquote;
    if inquote then q[j]:='_';
   end;
//   if (pos(' checked',q)=0) then
//    querygrid.cells[1,i]:='';
  end;

  p:=pcre.MatchedStrAfterLastCharPos;
 end;

end;

procedure TQueryForm.EnableAction(Sender: TObject);
var t:integer;
begin
 t:=THKAction(Sender).Tag;
 if querytags[t] in ActiveScriptInfo.Query.Methods
  then exclude(ActiveScriptInfo.Query.Methods,QueryTags[t])
  Else include(ActiveScriptInfo.Query.Methods,QueryTags[t]);
 EnableUpdate(sender);

 if PageControl.ActivePageIndex=5 then
  PreviewAction.SimpleExecute;
end;

procedure TQueryForm.EnableUpdate(Sender: TObject);
begin
 THKAction(sender).enabled:=assigned(ActiveScriptInfo);
 if assigned(ActiveScriptInfo) then
  THKAction(sender).Checked:=
   QueryTags[THKAction(Sender).Tag] in ActiveScriptInfo.Query.Methods
end;

procedure TQueryForm.SaveShotActionExecute(Sender: TObject);
var i :TQueryTypes;
begin
 With ActiveScriptInfo.Query do
  for i:=low(i) to high(i) do
   SmartStringsAdd(QueryLists[i],ActiveQuery[i]);
end;

procedure TQueryForm.DelShotActionExecute(Sender: TObject);
var
 i :TQueryTypes;
 j:integer;
begin
 With ActiveScriptInfo.Query do
  for i:=low(i) to high(i) do
  begin
   j:=QueryLists[i].indexof(ActiveQuery[i]);
   if j>=0 then
    queryLists[i].delete(j);
  end;
end;

procedure TQueryForm.SetvlEnv;
var t:integer;
begin
  for t:=0 to ActiveScriptInfo.query.EnvStatic.Count-1 do
  begin
   vlEnv.Cols[0].Strings[t]:=ActiveScriptInfo.query.EnvStatic.Strings[t];
   vlEnv.Cols[1].Strings[t]:=ActiveScriptInfo.query.EnvStatic.ValueAt(t);
  end;
  for t:=ActiveScriptInfo.query.EnvStatic.Count to vlEnv.RowCount-1 do
  begin
   vlEnv.Cols[0].Strings[t]:='';
   vlEnv.Cols[1].Strings[t]:='';
  end;
end;

procedure TQueryForm.PageControlChange(Sender: TObject);
begin
 SetCaption('Query Editor - Editing '+pagecontrol.ActivePage.Caption);
 UpdateAll;
 if assigned(QueryCombos[0]) then
 begin
  QueryLink.Visible:=false;
  if pagecontrol.ActivePageIndex<=high(QueryCombos) then
   begin
    QueryLink.Item:=QueryCombos[pagecontrol.ActivePageIndex];
    QueryLink.Visible:=true;
   end
 end;
end;

procedure TQueryForm.UpdateAll;
var
 t:integer;
begin
 if (not visible) or (not assigned(ActiveScriptInfo)) then exit;
 GetFrame.UpdateFrame;
 PostFrame.UpdateFrame;
 PathInfoFrame.UpdateFrame;
 CookieFrame.UpdateFrame;
 rbencode1.Checked:=ActiveScriptInfo.Query.Encoding=etURL;
 rbencode2.Checked:=ActiveScriptInfo.Query.Encoding=etStream;
 rbencode3.Checked:=ActiveScriptInfo.Query.Encoding=etRaw;
 t:=pagecontrol.ActivePageIndex;
 if t=5 then UpdatePreview;
 if t=4 then SetVlEnv;
end;

procedure TQueryForm.ImportFileActionExecute(Sender: TObject);
begin
 if opendialog.Execute then
 begin
  DoTheParse(LoadStr(opendialog.FileName));
 end;
end;

procedure TQueryForm.ImportWebActionExecute(Sender: TObject);
begin
 if pagecontrol.ActivePageIndex<3
  then DoTheParse(PR_WebBrowserData)
  else
  begin
   ActiveScriptInfo.Query.ActiveQuery[qmCookie]:=PR_GetWebCookie;
   PC_QueryChanged;
   UpdateAll;
  end;
end;

procedure TQueryForm.CopyActionUpdate(Sender: TObject);
var t:integer;
begin
 t:=pagecontrol.ActivePageIndex;
 copyGetAction.Visible:=copyGetAction.Tag<>t;
 copyPostAction.Visible:=copyPostAction.Tag<>t;
 copyPathINfoAction.Visible:=copyPathinfoAction.Tag<>t;
 SetGroupEnable([copyGetAction,copyPostAction,copyPathINfoAction],(t<=2) and (visible));
end;


procedure TQueryForm.CopyGetActionExecute(Sender: TObject);
begin
 with ActiveScriptInfo.Query do
 begin
  ActiveQuery[ActiveMethod]:=ActiveQuery[qmGet];
  QueryLists[ActiveMethod].Assign(QueryLists[qmGet]);
 end;
 UpdateAll;
 PC_QueryChanged;
end;

procedure TQueryForm.CopyPostActionExecute(Sender: TObject);
begin
 with ActiveScriptInfo.Query do
 begin
  ActiveQuery[ActiveMethod]:=ActiveQuery[qmPost];
  QueryLists[ActiveMethod].Assign(QueryLists[qmPost]);
 end;
 UpdateAll;
 PC_QueryChanged;
end;

procedure TQueryForm.CopyPathInfoActionExecute(Sender: TObject);
begin
 with ActiveScriptInfo.Query do
 begin
  ActiveQuery[ActiveMethod]:=ActiveQuery[qmPathInfo];
  QueryLists[ActiveMethod].Assign(QueryLists[qmPathInfo]);
 end;
 UpdateAll;
 PC_QueryChanged;
end;

procedure TQueryForm.rbEncode1Click(Sender: TObject);
begin
 ActiveScriptInfo.Query.Encoding:=etURL;
end;

procedure TQueryForm.rbEncode2Click(Sender: TObject);
begin
 ActiveScriptInfo.Query.Encoding:=etStream;
end;

procedure TQueryForm.rbEncode3Click(Sender: TObject);
begin
 ActiveScriptInfo.Query.Encoding:=etRaw;
end;

procedure TQueryForm.UpdatePreview;
begin
 if dockControl.dockstate=dcsHidden then exit;
 SetGroupEnable([copyGetAction,copyPostAction,copyPathINfoAction],false);
 ActiveScriptInfo.Query.MakeEnv(ActiveScriptInfo.path);
 vlPreview.Strings.Text:=ActiveScriptInfo.Query.EnvDynamic.SimpleText;
 ActiveScriptInfo.Query.MakePreview(mempreview.lines);
end;

procedure TQueryForm.PreviewActionExecute(Sender: TObject);
begin
 PageControl.ActivePageIndex:=5;
 show;
 UpdatePreview;
end;

procedure TQueryForm.OpenQueryEditorActionExecute(Sender: TObject);
begin
 show;
end;

function TQueryForm.ActiveMethod: TQueryTypes;
begin
 case pagecontrol.ActivePageIndex of
  0 : result:=qmGet;
  1 : Result:=qmPost;
  2 : Result:=qmPathInfo;
  3 : Result:=qmCookie;
 end;
end;

procedure TQueryForm.DoTheParse(const Text: String);
begin
 case ActiveMethod of
  qmGet : begin
   ParseAll(text,GetFrame.vlQuery);
   GetFrame.GridChange;
  end;
  qmPost : begin
   ParseAll(text,PostFrame.vlQuery);
   PostFrame.GridChange;
  end;
  qmPathInfo : begin
   ParseAll(text,PathInfoFrame.vlQuery);
   PathInfoFrame.GridChange;
  end;
 end;
 PC_QueryChanged;
end;

procedure TQueryForm.ImportWebActionUpdate(Sender: TObject);
begin
 ImportWebAction.Enabled:=(PageControl.ActivePageIndex<=2) and (visible);
end;

procedure TQueryForm.ImportFileActionUpdate(Sender: TObject);
begin
 ImportFileAction.Enabled:=(PageControl.ActivePageIndex<=2) and (visible);
end;

procedure TQueryForm._ActiveScriptChanged;
begin
 if visible
  then updateall;
end;

procedure TQueryForm.vlEnvKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
 i:integer;
 s:string;
begin
 ActiveScriptInfo.Query.EnvStatic.Clear;
 for i:=0 to vlEnv.RowCount-1 do
 begin
  s:=trim(vlEnv.Cols[0].Strings[i]);
  if s<>'' then
  begin
   ActiveScriptInfo.Query.EnvStatic.Add(s,trim(vlEnv.Cols[1].Strings[i]));
  end;
 end;
end;

procedure TQueryForm.cbCookiesDropDown(Sender: TObject);
begin
 with cbCookies do
 begin
  if (folders.CookiesFolder='') then exit;
  items.Clear;
  hakafile.GetFileList(folders.CookiesFolder,'*.txt',false,faArchive,Items);
 end;
end;

procedure TQueryForm.cbCookiesSelect(Sender: TObject);
var
 f,s: string;
 sl:TStringList;
 i : Integer;
begin
 f:=Folders.CookiesFolder+cbCookies.Text;
 if not fileexists(f) then exit;
 sl:=TStringList.Create;
 sl.LoadFromFile(f);
 sl.Insert(0,'*');
 if sl.Count>=2 then
 begin
  ActiveScriptInfo.Query.ActiveQuery[qmCookie]:='';
  for i:=0 to sl.Count-1 do
  if (trim(sl[i])='*') and (i+2<sl.Count) then
  begin
   f:=sl[i+1];
   replaceSC(f,'=','\=',false);
   replaceSC(f,';','\;',false);

   s:=sl[i+2];
   replaceSC(s,'=','\=',false);
   replaceSC(s,';','\;',false);
   with ActiveScriptInfo.Query do
    ActiveQuery[qmCookie]:=ActiveQuery[qmCookie]+f+'='+s+';';
  end;
   with ActiveScriptInfo.Query do
    SetLength(ActiveQuery[qmCookie],Length(ActiveQuery[qmCookie])-1);
  PC_QueryChanged;
  CookieFrame.UpdateFrame;
 end;
 sl.free;
end;

procedure TQueryForm.FormResize(Sender: TObject);
begin
 with vlEnv do
 begin
  ColWidths[0]:=imax(120,ClientWidth div 3);
  ColWidths[1]:=ClientWidth-ColWidths[0]-3;
  vlEnv.LeftCol:=0;
 end;
end;

procedure TQueryForm.QuerySelectFileActionExecute(Sender: TObject);
var s:string;
begin
 if SelectDialog.Execute then
 begin
  s:='\f<'+selectdialog.FileName+'>';
  case ActiveMethod of
   qmGet : GetFrame.InsertFilename(s);
   qmPost : PostFrame.InsertFilename(s);
   qmPathInfo : PathInfoFrame.InsertFilename(s);
   qmCookie : CookieFrame.InsertFilename(s);
  end;
 end;
end;

procedure TQueryForm.QuerySelectFileActionUpdate(Sender: TObject);
begin
 QuerySelectFileAction.Enabled:=
  ActiveMethod in [qmGet..qmCookie];
end;

procedure TQueryForm.GetPopupLinks(Popup: TDxBarPopupMenu; MainBarManager: TDxBarManager);
var
 il : TdxBarItemLink;
begin
 popup.ItemLinks:=siPopup.ItemLinks;
 if pagecontrol.ActivePageIndex<=high(QueryCombos) then
 begin
  il:=popup.ItemLinks.Add;
  il.Index:=4;
  il.item:=QueryCombos[pagecontrol.ActivePageIndex];
  il.beginGroup:=true;
 end;
end;

procedure TQueryForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtInside;
 Pix:=0;
 index:=InNone;
end;

procedure TQueryForm.PageControlMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 i:integer;
begin
 if Button = mbRight then
 begin
   i:=PageControl.GetTabIndex(x,y);
   pagecontrol.ActivePageIndex:=i;
   PageControlChange(nil);
   ButtonClick;
   exit;
 end;
end;

procedure TQueryForm.IncExtVariablesActionExecute(Sender: TObject);
begin
 if assigned(ActiveScriptInfo) then
 begin
  with ActiveScriptInfo.Query do
   IncExtVariables:=not IncExtVariables;
  UpdatePreview;
 end; 
end;

procedure TQueryForm.IncExtVariablesActionUpdate(Sender: TObject);
begin
 if assigned(ActiveScriptInfo) then
  IncExtVariablesAction.Checked:=ActiveScriptInfo.Query.IncExtVariables;
end;

end.

 {

 <form method="GET" enctype="multipart/form-data" action="/cgi-bin/parse-test.cgi">
  <p>&nbsp;</p>
  <p><input type="text" name="TextBox" size="20" value="Initial Value"></p>
  <p>
  <input type="password" name="TextBoxPassword" size="20" value="Initial Value"></p>
  <p><textarea rows="2" name="TextArea" cols="20">Initial Value
First Line
Second line</textarea></p>
  <p><input type="file" name="Upload" size="20" value="Initial"></p>
  <p><input type="checkbox" name="CheckBox" value="InitialValue" checked></p>
  <p><input type="checkbox" name="CBUnchecked" value="InitialValue"></p>
<input type="hidden" name="Hidden" value="InitialValue">
  <fieldset style="padding: 2">
  <legend>Group box</legend>
  kl;jmlkml<p>&nbsp;</p>
  </fieldset><p><input type="button" value="InitialValue" name="NormalButton"><input type="submit" value="InitialValue" name="SubmitButton"><input type="reset" value="InitialValue" name="ResetButton"></p>
  <p><input type="text" name="T2" size="20" id="fp1"><label for="fp1">dsghdsfh</label></p>
  <p><input type="submit" value="Submit" name="B1"><input type="reset" value="Reset" name="B2"></p>
</form>


 TextBox=Initial+Value&
 TextBoxPassword=Initial+Value&TextArea=Initial+Value%0D%0AFirst+Line%0D%0ASecond+line&
 Upload=&
 CBUnchecked=InitialValue&
 Hidden=InitialValue&
 T2=&
 B1=Submit
}