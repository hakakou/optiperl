unit RegExpTesterFrm; //modeless //memo //splitter //VST
{$I REG.INC}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,hyperfrm,
  StdCtrls, hyperstr, OptFolders,optOptions, OptForm,PerlApi,hkDebug,dcstring,PerlHelpers,
  ExtCtrls, Clipbrd, optGeneral, dccommon, dcmemo,Hakawin, hkGraphics, hakahyper,
  ComCtrls,runPerl,hakageneral, Buttons, dxBar, JvComponent, JvThreadTimer, JvPlacemnt,
  VirtualTrees,centralimagelistmdl,dcSystem;


type
  TMyParser = class(TSimpleParser)
   function ColorString(const StrData: String; InitState: Integer;
      var AColorData: String): Integer; Override;
  end;

  TRegExpTesterForm = class(TOptiForm)
    OpenDialog: TOpenDialog;
    FormStorage: TjvFormStorage;
    Timer: TTimer;
    BarManager: TdxBarManager;
    cbWord: TdxBarButton;
    cbEOL: TdxBarButton;
    cbSync: TdxBarButton;
    btnExplain: TdxBarButton;
    btnOpen: TdxBarButton;
    TopPanel: TPanel;
    edRegExp: TComboBox;
    btnAdd: TSpeedButton;
    btnRemove: TSpeedButton;
    Splitter: TSplitter;
    gbInput: TGroupBox;
    gbOutput: TGroupBox;
    memInput: TDCMemo;
    BotPanel: TPanel;
    ListView: TListView;
    VST: TVirtualStringTree;
    btnHorizontal: TdxBarButton;
    btnUpdate: TdxBarButton;
    btnSingleLine: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure edRegExpChange(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbWordClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExplainClick(Sender: TObject);
    procedure memInputChange(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure edRegExpKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbEOLClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure TopPanelResize(Sender: TObject);
    procedure SplitterMoved(Sender: TObject);
    procedure FormStorageRestorePlacement(Sender: TObject);
    procedure VSTGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VSTFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure memInputMemoViewChange(Sender: TObject);
    procedure VSTScroll(Sender: TBaseVirtualTree; DeltaX, DeltaY: Integer);
    procedure btnHorizontalClick(Sender: TObject);
    procedure VSTPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType);
    procedure VSTBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);
    procedure btnUpdateClick(Sender: TObject);
    procedure VSTGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle;
      var HintText: WideString);
    procedure btnSingleLineClick(Sender: TObject);
  private
    OffSet,SCStart : Integer;
    MyParser: TMyParser;
    Perl : TPerlBase;
    RegExpChanged,Valid,DoAllowRun,Running,WasOK,SimplePattern,IsTrans : Boolean;
    Levels : Array[0..9] of TColor;
    TempCode : TStringList;
    Procedure Test;
    procedure Explain;
    procedure CleanOutput(Tokens: TStringList);
    Function TestLine(const Pattern: String; var text: String;
      MainNode : PVirtualNode; line,count : Integer; Var offset : Integer; Var Recursive : Boolean) : Boolean;
    procedure DrawMemNode(var SC : String; Node : PVirtualNode);
    procedure InitPerl;
    procedure memRealTimeColor(Sender: TObject; Line: integer);
  protected
   procedure SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer); override;
   Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); Override;
  end;

var
 RegExpForm : TRegExpTesterForm;

implementation

Const
 MaxLines = 200;
 SmallNodeHeight = 14;

type
 PData = ^TData;
 TData = Record
  Str : String;
  Line,Num,SP,EP : Integer;
  //When parent, num = number of found results
  //else num = $0..$9
 end;

{$R *.DFM}

procedure TRegExpTesterForm.TopPanelResize(Sender: TObject);
var ch : integer;
begin
 ch:=TopPanel.ClientHeight-edRegExp.Height;
 with TopPanel do
 if not btnHorizontal.Down then
  begin
   gbInput.Width:=ClientWidth div 2 - 7;
   gbInput.Left:=5;
   gboutput.Width:=gbInput.Width;
   gbOutput.Left:=ClientWidth div 2 + 3;
   gbOutput.Top:=gbInput.Top;
   gbInput.Height:=ch - 5;
   gbOutput.Height:=gbInput.Height
  end
 else
  begin
   gbInput.Width:=ClientWidth - gbInput.Left*2;
   gboutput.Width:=gbInput.Width;
   gbOutPUt.Top:=ch div 2 + edRegExp.Height;
   gbOutput.Height:=ch div 2 - 4;
   gbInput.Height:=gbOutput.Height;
   gbOutput.left:=gbInput.Left;
  end;
end;

procedure TRegExpTesterForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=StanDocks[doEditor];
 Alignment:=drtTop;
 Pix:=0;
 Index:=InTools;
end;

procedure TRegExpTesterForm.FormCreate(Sender: TObject);
var
 i,j : integer;
 ListItem: TListItem;
const
 add = round(256/10);
begin
 RegExpChanged:=true;
 SetMemo(memInput,[]);
 MyParser:=TMyParser.Create(nil);
 memInput.OnRealTimeColor:=memRealTimeColor;
 memInput.MemoSource.SyntaxParser:=myParser;
 TempCode:=TStringList.Create;
 edRegExp.Font.Name:=hakawin.DefMonospaceFontName;
 memInput.Font.Name:=options.FontName;
 memInput.Font.Size:=options.FontSize+1;
 VST.Font:=memInput.Font;
 vst.DefaultNodeHeight:=memInput.LineHeight;
 vst.Color:=options.EditorColor;
 j:=0;
 scStart:=memInput.TextStyles.Count;
 with memInput do
  for i:=0 to 9 do
  begin
   TextStyles.AddStyle(inttostr(i),0,0);
   with textstyles[i+scStart] do
   begin
    Assign(textstyles[0]);
    color:=HSLRangeToRGB(j,240,200);
    Levels[i]:=color;
    inc(j,add);
   end;
 end;

 InitPerl;
 Timer.Enabled:=DoAllowRun;

 if not DoAllowRun then
 begin
  ListView.Items.Clear;
  ListItem:=ListView.Items.add;
  ListItem.Caption:='';
  ListItem.SubItems.add('');
  ListItem.SubItems.add(PerlDLLBadStr);
 end;

 WasOK:=false;
 splitterMoved(nil);
end;

procedure TRegExpTesterForm.btnOpenClick(Sender: TObject);
begin
 if OpenDialog.Execute then
  memInput.Lines.LoadFromFile(OpenDialog.FileName);
end;

procedure TRegExpTesterForm.memInputChange(Sender: TObject);
begin
 Timer.Enabled:=false;
 Timer.Enabled:=DoAllowRun;
 if memInput.lines.count>MaxLines
  then btnUpdate.Visible:=ivAlways
  else btnUpdate.Visible:=ivNever;
end;

procedure TRegExpTesterForm.edRegExpChange(Sender: TObject);
begin
 Timer.Enabled:=false;
 Timer.Enabled:=DoAllowRun;
 RegExpChanged:=true;
end;

procedure TRegExpTesterForm.TimerTimer(Sender: TObject);
var
 c:integer;
begin
 if Running then Exit;
 running:=True;

 tempcode.Clear;

 if not btnSingleLine.Down then
  begin
   if sender=nil
    then c:=memInput.memosource.StrCount-1
    else c:=imin(memInput.memosource.StrCount-1,MaxLines-1);
   for c:=0 to c do
    tempcode.Add(memInput.MemoSource.StringItem[c].StrData);
  end
 else
  begin
   TempCode.add(memInput.MemoSource.Strings.Text);
  end;

 if (sender=nil) or (random(10)=0) then
 begin
  perl.Free;
  initPerl;
 end;

 BtnExplain.Enabled:=false;
 WasOK:=false;
 try
  if valid then
   begin

    try
     perl.setcontext;
     Test;
     if RegExpChanged then
      Explain;
     WasOK:=true;
    except
     on exception do begin
      perl.Free;
      initPerl;
     end;
    end;

   end;

 finally
  BtnExplain.Enabled:=true;
  Running:=False;
  memInput.Invalidate;
  memInputMemoViewChange(nil);
  Timer.Enabled:=not WasOK;
 end;
end;

procedure TRegExpTesterForm.FormDestroy(Sender: TObject);
begin
 TempCode.Free;
 perl.Free;
 MyParser.Free;
end;

procedure TRegExpTesterForm.InitPerl;
var
 error:string;
begin
 DoAllowRun:=FileExists(perlapi.PerlDllFile);
 if DoAllowRun then
 begin
  perl:=TPerlBase.Create(['-I'+folders.IncludePath,'-e0'],true);
  perl.Initialize;
  error:=perl.EvalCode('use YAPE::Regex::Explain;');
  valid:=length(error)=0;
  if not valid
   then //
   else perl.EvalCode('$found=$0; $found=0; $_="";');
  DoAllowRun:=valid;
 end;
end;

Function TRegExpTesterForm.TestLine(Const Pattern : String; Var text : String;
  MainNode : PVirtualNode; line,count : Integer; Var offset : Integer; Var Recursive : Boolean) : Boolean;
var
 i,num,toff,len,sp,ep:integer;
 code,error:string;
 c:char;
 Node : PVirtualNode;
 Data : PData;
begin
 Application.ProcessMessages;

 result:=false;
 if length(text)=0 then exit;

 Perl.SetContext;
 perl.setvarstring('_',text);

 code:= '$found=('+Pattern+'); $m0=$&; $s0=$-[0]; $e0=$+[0]; $num=0; ';
 for i:=1 to 9 do
 begin
  c:=inttostr(i)[1];
  code:=code+'if (defined $'+c+') '+
   '{ $m'+c+'=$'+c+'; $s'+c+'=$-['+c+']; $e'+c+'=$+['+c+']; $num='+c+'; } else '+
   '{ $m'+c+'=undef; $s'+c+'=-1; $e'+c+'=-1; }';
 end;

 error:=perl.EvalCode(code);

 if length(error)>0 then
 begin
  data:=vst.GetNodeData(mainnode);
  data.Str:=error;
  exit;
 end;

 result:=(not IsTrans) and (perl.GetVarInteger('found')=1);
 toff:=offset;

 if result then
  begin
   num:=perl.GetVarInteger('num');
   mainnode:=vst.AddChild(mainnode);
   data:=vst.GetNodeData(mainnode);
   data.Str:='Match '+inttostr(count+1);

   Perl.SetContext;
   for i:=0 to num do
   begin
    c:=inttostr(i)[1];

    SP:=perl.GetVarInteger('s'+c)+toff;
    EP:=perl.GetVarInteger('e'+c)+toff;
    if (sp=-1) and (ep=-1)
     then code:='undef'
     else code:='"'+perl.GetVarString('m'+c)+'"';

    node:=vst.AddChild(MainNode);
    data:=vst.GetNodeData(node);
    data.Num:=i;
    data.line:=Line;
    data.SP:=sp;
    data.EP:=ep;

    if i=0 then
    begin
     c:='&';
     len:=data.EP-offset;
     recursive:=len=0;
     delete(text,1,len);
     offset:=data.EP;
    end;
    data.Str:='$'+c+' = '+code;
   end;
  end;
end;

procedure TRegExpTesterForm.Test;
var
 i,offset,Count,po,org:integer;
 p,text,outp,t:string;
 node,pnode : PVirtualNode;
 Data : PData;
 recursive,Repeater : boolean;
begin
 vst.Clear;
 IsTrans:=false;
 if TempCode.Count=0 then exit;

 p:=trim(edRegExp.Text);
 if length(p)<=2 then exit;
 IsTrans:=StringStartsWith('tr',p);
 Repeater:=StringEndsWith('x',p);

 if StringStartsWith('s',p) or
    StringStartsWith('tr',p) or
    StringStartsWith('y',p) then
  SimplePattern:=false
 else
  SimplePattern:=true;

 vst.beginupdate;
 try
  for i:=0 to tempcode.Count-1 do
  begin
   Node:=Vst.AddChild(vst.RootNode);
   TempCode.Objects[i]:=TObject(Node);

   Count:=0;
   offset:=0;
   Node:=PVirtualNode(TempCode.Objects[i]);
   text:=TempCode[i];
   org:=length(text);
   recursive:=false;
   outp:='';
   po:=0;

   while TestLine(p,text,node,i,count,offset,recursive) do
   begin
    inc(count);
    if not SimplePattern then
    begin
     t:=perl.GetVarString('_');
     org:=org-length(t);
     setlength(t,offset-po-org);
     outp:=outp+t;

     po:=offset;
     org:=length(text);
    end;

    if not repeater then
    begin
     recursive:=false;
     break;
    end;
    if recursive then break;
   end;

   if not simplePattern then
   begin
    if IsTrans then
     outp:=perl.GetVarString('_')
    else
     if count=0
      then outp:=TempCode[i]
      else outp:=outp+text;
   end;

   if count=1 then
   begin
    pnode:=vst.GetFirstChild(node);
    vst.MoveTo(pnode,node,amAddChildFirst,true);
    vst.DeleteNode(pnode);
   end;
   data:=vst.GetNodeData(node);
   data.Line:=i;
   data.Num:=count;

   if SimplePattern then
    begin
     if count=0 then
      data.Str:='Not found'
     else
      begin
       data.Str:='Found '+inttostr(count)+' ';
       if count=1
        then Data.Str:=Data.Str+'match'
        else Data.Str:=Data.Str+'matches';
       if recursive then
        data.Str:=data.Str+' (terminated because last match was null length)'
      end;
    end
   else
    begin
     data.Str:=outp;
     if recursive then
      data.Str:=data.Str+' (terminated because last match was null length)'
    end;
   end;

 finally
  vst.Header.Columns[0].Width:=memInput.GetPaintX+12;
  vst.EndUpdate;
 end;

 {
 $` is the same as substr($var, 0, $-[0])
 $& is the same as substr($var, $-[0], $+[0] - $-[0])
 $' is the same as substr($var, $+[0])
 $1 is the same as substr($var, $-[1], $+[1] - $-[1])
 $2 is the same as substr($var, $-[2], $+[2] - $-[2])
 }

end;

procedure TRegExpTesterForm.cbWordClick(Sender: TObject);
begin
 memInput.WordWrap:=cbWord.down;
end;

procedure TRegExpTesterForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 RegExpForm:=nil;
 Action:=caFree;
end;

procedure TRegExpTesterForm.btnExplainClick(Sender: TObject);
begin
 if btnExplain.Down then
  begin
   BotPanel.visible:=btnExplain.Down;
   Splitter.Visible:=btnExplain.Down;
  end
 else
  begin
   Splitter.Visible:=btnExplain.Down;
   BotPanel.visible:=btnExplain.Down;
  end;
end;

procedure TRegExpTesterForm.CleanOutput(Tokens : TStringList);
var
 i:integer;
begin
 for i:=1 to 10 do
  if Tokens.Count>0 then
   Tokens.Delete(0);

 for i:=1 to 4 do
  if tokens.Count>0 then
   Tokens.Delete(tokens.Count-1);

 if tokens.Count>=3 then
 begin
  i:=Tokens.Count-3;
  repeat
   Tokens.Delete(i);
   Dec(i,3);
  until i<0;
 end;

 if Tokens.Count>=2 then
 begin
  i:=Tokens.Count-2;
  repeat
   Tokens[i]:=copyFromToEnd(Tokens[i+1],3);
   Tokens.Delete(i+1);
   Dec(i,2);
  until i<0;
 end;
end;


procedure TRegExpTesterForm.Explain;
var
 sl:TStringList;
 ListItem: TListItem;
 rex,code,s,outd : string;
 j,ofs,o:integer;

 Error : String;
 StDel : Boolean;
 Delimiter : Char;

   Procedure Parse;
   var
    p:integer;
    b:boolean;
   begin
    Error:='';
    if StringStartsWith('m',rex) or
       StringStartsWith('y',rex) or
       StringStartsWith('s',rex) then
     p:=1
    else
    if StringStartsWith('tr',rex) then
     p:=2
    else
     p:=0;

    Delete(rex,1,p);
    rex:=trim(rex);

    if (length(rex)<=2) then
    begin
     Error:='Regular expression length too small.';
     Exit;
    end;

    Delimiter:=Rex[1];
    p:=2;
    b:=false;
    while p<=length(rex) do
    begin
     if (rex[p]='\') then
      b:=not b
     else
     if (not b) and (rex[p]=Delimiter) then
      break
     else
      b:=false;
     inc(p);
    end;

    if p>length(rex) then
    begin
     Error:='Could not find ending delimiter';
     exit;
    end;
    rex:=copy(rex,2,p-2);
   end;

begin
 RegExpChanged:=false;
 edRegExp.Color:=clWindow;
 rex:=trim(edRegExp.Text);
 Parse;

 if (Error<>'') then
  begin
   ListView.Items.Clear;
   ListItem:=ListView.Items.add;
   ListItem.Caption:='';
   ListItem.SubItems.add('');
   ListItem.SubItems.add(Error);
   exit;
  end;

 offset:=scanF(edRegExp.Text,delimiter,1);
 stdel:=Delimiter<>'/';
 if stdel then
  replaceSC(rex,'/','\/',false);

 code:='$rex = qr/'+rex+'/i;';

 Error:=trim(perl.EvalCode(code));
 if (Error<>'') then
  begin
   j:=scanR(Error,'at (',0);
   if j>0 then
    setlength(Error,j-2);
   ListView.Items.Clear;
   edRegExp.Color:=$009B9BFF;
   ListItem:=ListView.Items.add;
   ListItem.Caption:='';
   ListItem.SubItems.add('');
   ListItem.SubItems.add(Error);
   exit;
  end;

 code:='$exp=YAPE::Regex::Explain->new($rex);$outd="";'+
       'while($chunk=$exp->next){$outd=$outd.$chunk->string."\x01"} $code=$exp->explain;';

 Error:=trim(perl.EvalCode(code));
 if length(Error)>0 then exit;

 sl:=TStringList.Create;
 ofs:=1;
 try
  sl.Text:=perl.GetVarString('code');
  outd:=perl.GetVarString('outd');
  CleanOutput(sl);
  delete(outd,1,pos(#1,outd));
  ListView.Items.Clear;

  o:=1;
  j:=1;
  while (j<=length(outd)) and (o<=length(rex)) do
  begin
   if outd[j]<>#1 then
   begin
    if outd[j]<>rex[o] then
     insert('\',outd,j);
    inc(o);
   end;
   inc(j);
  end;

  for j:=0 to sl.Count-1 do
  begin
   ListItem:=ListView.Items.Add;
   if error<>'' then continue;
   o:=pos(#1,outd);
   s:=Copy(outd,1,o-1);


   delete(outd,1,o);
   listitem.Caption:=IntToStr(ofs);
   ListItem.Data:=TObject(ofs);
   inc(ofs,length(s));
   listitem.SubItems.Add(s);
   listitem.SubItems.Add(sl[j]);
  end;
 finally
  sl.Free;
 end;
end;

procedure TRegExpTesterForm.ListViewSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
 if (not Assigned(item)) or (not assigned(item.data)) then
  exit;
 edRegExp.SelStart:=Integer(Item.data)-1+offset;
 edRegExp.SelLength:=Length(Item.subitems[0]);
end;

procedure TRegExpTesterForm.edRegExpKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if (key=vk_up) or (key=vk_down) then key:=0;
end;

procedure TRegExpTesterForm.cbEOLClick(Sender: TObject);
begin
 if cbEOL.down
 then
  memInPut.Options:=memInPut.Options+[moDrawSpecialSymbols]
 else
  memInPut.Options:=memInPut.Options-[moDrawSpecialSymbols];
end;

procedure TRegExpTesterForm.memInputMemoViewChange(Sender: TObject);
var
 node : PVirtualNode;
 l:integer;
begin
 if (not running) and (memInput.Focused) and (cbSync.Down) then
 begin
  l:=meminput.winlinepos;
  l:=memInput.RealPosition(l);
  if l>=tempcode.Count then exit;
  node:=PVirtualNode(TempCode.Objects[l]);
  vst.TopNode:=node;
 end;
end;

procedure TRegExpTesterForm.VSTScroll(Sender: TBaseVirtualTree; DeltaX,
  DeltaY: Integer);
var
 node : PVirtualNode;
 data : PData;
 l : Integer;
begin
 if (not running) and (VST.Focused) and (cbSync.Down) then
 begin
  node:=vst.TopNode;
  vst.TopNode:=node;
  if not assigned(node) then exit;
  while node.Parent<>vst.RootNode do
   node:=node.Parent;
  data:=vst.GetNodeData(node);
  l:=IMin(data.Line,TempCode.count-1);
  l:=memInput.wbPosition(l);
  memINput.WinLinePos:=l;
 end;
end;

procedure TRegExpTesterForm.btnAddClick(Sender: TObject);
var i:integer;
begin
 i:=edRegExp.Items.IndexOf(edRegExp.Text);
 if i<0
  then edRegExp.Items.Add(edRegExp.Text)
  else edRegExp.Items.Move(i,0);
end;

procedure TRegExpTesterForm.btnRemoveClick(Sender: TObject);
var i:integer;
begin
 i:=edRegExp.Items.IndexOf(edRegExp.Text);
 if i>=0
  then edRegExp.Items.Delete(i);
end;

procedure TRegExpTesterForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=barmanager.Bars[0].ItemLinks;
end;

procedure TRegExpTesterForm.SplitterMoved(Sender: TObject);
begin
 SetConstraints(50,ListView.Height+50+OptiMinSplitterAdd);
end;

procedure TRegExpTesterForm.FormStorageRestorePlacement(Sender: TObject);
begin
 if FormStorage.tag=0 then
 begin
  cbWordClick(nil);
  cbEolClick(nil);
  btnExplainClick(nil);
  FormStorage.tag:=1;
 end;
end;


procedure TRegExpTesterForm.VSTGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
 NodeDataSize:=sizeof(TData);
end;

procedure TRegExpTesterForm.VSTFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
 data:PData;
begin
 data:=vst.getnodedata(node);
 setlength(data.str,0);
end;

//Function TRegExpTesterForm.GetCaption(Node) : String;

procedure TRegExpTesterForm.VSTGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
 data:PData;
 s:string;
begin
 data:=vst.getnodedata(node);
 if column=1 then
 begin
  s:=data.Str;
  replaceC(s,#9,'|');
  if (node.Parent=vst.RootNode) or (node.ChildCount>0) or ((data.sp=-1) and (data.ep=-1))
   then celltext:=s
   else CellText:=Format('%s start:%d end:%d',[s,data.SP,data.EP]);
 end

 else
 if (node.Parent=vst.RootNode) and (column=0) then
  celltext:=IntToStr(data.Line+1)

 else
  celltext:='...';
end;

procedure TRegExpTesterForm.btnHorizontalClick(Sender: TObject);
begin
 TopPanelResize(nil);
end;

procedure TRegExpTesterForm.VSTPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
 data : PData;
begin
 targetcanvas.Font.Height:=node.NodeHeight-2;
 if (not simplepattern) and (node.Parent=vst.RootNode) then
 begin
  data:=vst.GetNodeData(node);
  if data.Num>0 then
   targetcanvas.Font.Style:=[fsBold];
 end;
end;

procedure TRegExpTesterForm.VSTBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
 x:integer;
 data : PData;
begin
 with targetcanvas do

  if (node.Parent=vst.RootNode) then
   begin
    if (column=0) then
    begin
     dec(cellrect.Right,2);
     Brush:=memInput.GutterBrush;
     FillRect(cellrect);
     x:=cellrect.Right;
     Pen.Color := memInput.GutterBackColor;
     MoveTo(X, cellrect.Top);
     LineTo(X, cellrect.bottom);
     Pen.Color := memInput.GutterLineColor;
     inc(x);
     MoveTo(X, cellrect.Top);
     LineTo(X, cellrect.bottom);
    end;
   end
  else
   begin
    if node.ChildCount>0 then
     Brush.color:=clInfoBk
    else
     begin
      data:=vst.GetNodeData(node);
      Brush.color:=levels[data.Num];
     end;
    fillrect(cellrect);
   end;
end;

procedure TRegExpTesterForm.btnUpdateClick(Sender: TObject);
begin
 Screen.Cursor:=crHourGlass;
 hakawin.DisableApplication;
 try
  TimerTimer(nil);
 finally
  screen.Cursor:=crDefault;
  hakawin.EnableApplication;
 end;
end;

procedure TRegExpTesterForm.btnSingleLineClick(Sender: TObject);
begin
 btnUpdateClick(nil);
end;

{ TMyParser }

function TMyParser.ColorString(const StrData: String; InitState: Integer;
  var AColorData: String): Integer;
begin
 Acolordata:=dupchr(#0,length(strdata));
 result:=0;
end;

procedure TRegExpTesterForm.memRealTimeColor(Sender: TObject;
  Line: integer);
var
 si : dcstring.TStringItem;
 sc : string;
 LineNode,Node : PVirtualNode;
 data : PData;
begin
 if Running or not wasok then exit;
 if line>=Tempcode.Count then exit;

 si:=memInput.MemoSource.StringItem[line];
 if not assigned(si) then exit;

 si.ItemState:=si.ItemState - [isWasParsed];
 memInput.MemoSource.ParseStrings(line,line,true);
 sc:=si.ColorData;

 LineNode:=PVirtualNode(TempCode.Objects[line]);
 if not assigned(lineNode) then exit;

 data:=vst.getnodeData(LineNode);
 if data.num=0
  then exit
 else
 if data.Num=1 then
  drawmemNode(sc,linenode)
 else
  begin
   node:=vst.GetFirstChild(linenode);
   while assigned(node) do
   begin
    drawMemNode(sc,node);
    node:=vst.GetNextSibling(node);
   end;
  end;

 si.ColorData:=sc;
end;

procedure TRegExpTesterForm.DrawMemNode(var SC : String; Node : PVirtualNode);
var
 ANode : PVirtualNode;
 Adata : PData;
 i,lev : integer;
begin
 ANode:=vst.GetFirstChild(node);
 while assigned(ANode) do
 begin
  AData:=vst.GetNodeData(ANode);
  lev:=adata.Num+scStart;
  for i:=adata.SP+1 to adata.EP do
   if (i>=1) and (i<=length(sc)) then
    sc[i]:=chr(lev);
  ANode:=vst.GetNextSibling(ANode);
 end;
end;

procedure TRegExpTesterForm.VSTGetHint(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex;
  var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var
 data : PData;
 s:string;
begin
 if column=1 then
 begin
  data:=vst.GetNodeData(node);
  s:=data.Str;
  replaceSC(s,#9,'\t',false);
  if (node.Parent=vst.RootNode) or (node.ChildCount>0)
   then HintText:=s
   else HintText:=Format('%s start:%d end:%d',[s,data.SP,data.EP]);
 end;
end;


end.
