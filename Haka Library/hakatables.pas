unit HakaTables;

interface
uses db,classes,hakafile,comobj,sysutils,clipbrd,variants,HKStreams;

procedure DisableSources(Sources : array of TDataSource);
procedure EnableSources;
function GetMinMax(Table : TDataset; Field : string; var min,max : variant) : boolean;
procedure PostTables(Tables : array of TDataset);
procedure ReadTable(MS : TStream; table : TDataSet; FieldNames : array of string);
procedure WriteTable(MS : TStream; table : TDataSet; FieldNames : array of string);
procedure ReplaceField(Table : TDataSet; Field : String; what,new : variant);
Function ExportTableExcel(Table : TDataSet; Workbook,worksheet : string) : boolean;
Function ExportTableText(Table : TDataSet; const Path : string) : boolean;
Function ExportTableClipboard(Table : TDataSet) : boolean;

implementation
var
 PrevRecNo : array of Integer;
 PrevSources : array of TDataSource;

function GetMinMax(Table : TDataset; Field : string; var min,max : variant) : boolean;
begin
 result:=false;
 if table.active then
 try
  posttables([table]);
  if table.IsEmpty then exit;
  table.first;
  min:=table[Field];
  max:=min;
  while not table.eof do
  begin
   if not varisnull(table[field]) then begin
    if table[field]>max then max:=table[field];
    if table[field]<min then min:=table[field];
   end;
   table.next;
  end;
 except
  on exception do exit;
 end;
 result:=true;
end;


procedure DisableSources(Sources : array of TDataSource);
var a:integer;
begin
 PrevRecNo:=nil;
 PrevSources:=nil;
 setlength(PrevSources,length(Sources));
 setlength(PrevRecNo,length(Sources));
 for a:=0 to length(Prevsources)-1 do
 begin
  PrevSources[a]:=sources[a];
  if PrevSources[a].dataset<>nil then begin
   PostTables([PrevSources[a].dataset]);
   if not TDataSet(PrevSources[a].dataset).isempty then
    PrevRecNo[a]:=TDataSet(PrevSources[a].dataset).RecNo;
   PrevSources[a].enabled:=false;
  end;
 end;
end;

procedure EnableSources;
var a:integer;
begin
 for a:=0 to length(Prevsources)-1 do
  if PrevSources[a]<>nil then begin
   PrevSources[a].enabled:=true;
   if not TDataSet(PrevSources[a].dataset).isempty then
    TDataSet(prevSources[a].dataset).RecNo:=prevRecNo[a];
  end;
end;

procedure PostTables(Tables : array of TDataset);
var a:integer;
begin
 for a:=0 to length(tables)-1 do
 if (tables[a].active) and (tables[a].state in [dsEdit,dsInsert]) then
 tables[a].cancel;
end;

procedure WriteTable(MS : TStream; table : TDataSet; FieldNames : array of string);
var i,f:integer;
v:array of variant;
begin
 if table.Active then begin
  posttables([table]);
  i:=table.RecordCount;
  ms.Write(i,sizeof(i));
  table.first;
  setlength(v,length(fieldNames));
  while not table.eof do
  begin
   for f:=0 to length(fieldNames)-1 do
    v[f]:=table[fieldNames[f]];
   WriteVarArray(ms,v);
   table.next;
  end;
 end;
end;

procedure ReadTable(MS : TStream; table : TDataSet; FieldNames : array of string);
var c,i,f:integer;
 v:array of variant;
begin
 if table.active then begin
  posttables([table]);
  ms.Read(i,sizeof(i));
  for c:=1 to i do
  begin
   table.Append;
   v:=nil;
   setlength(v,length(fieldNames));
   readVarArray(ms,v);
   for f:=0 to length(fieldNames)-1 do
    table[fieldnames[f]]:=v[f];
   table.post;
  end;
 end;
end;

procedure ReplaceField(Table : TDataSet; field : string; what,new : variant);
begin
 if table.Active then begin
  posttables([table]);
  table.First;
  while not table.eof do
  begin
   if table[field]=what then begin
    table.edit;
    table[field]:=new;
    table.post;
   end;
   table.next;
  end;
 end;
end;

Function ExportTableExcel(Table : TDataSet; Workbook,worksheet : string) : boolean;
var v,a,x,s,r : variant;
fr,fc,f : integer;
begin
 result:=true;
 try
  v:=createoleobject('Excel.Sheet.8');
  a:=v.application;
  a.visible:=true;
  x:=v.application.workbooks.add;
  s:=x.worksheets.item[1];
  posttables([table]);
  table.first;
  fr:=1;
  fc:=0;
  for f:=0 to table.FieldCount-1 do
  if table.fields[f].visible then
  begin
   inc(fc);
   r:=s.cells[fr,fc];
   r.value:=table.fields[f].displayname;
  end;
  while not table.eof do
  begin
   inc(fr);
   fc:=0;
   for f:=0 to table.FieldCount-1 do
   if table.fields[f].visible then
   begin
    inc(fc);
    r:=s.cells[fr,fc];
    r.value:=table.fields[f].asstring;
   end;
   table.next;
  end;
 except
  on exception do result:=false;
 end;
end;

Function GetFieldValue(F : TField) : String;
begin
 if f.IsNull
  then result:=''
  else result:=f.value;
end;

Function ExportTableText(Table : TDataSet; const Path : string) : boolean;
var
 c : integer;
 f:textfile;
 s:string;
begin
 result:=false;
 if table.IsEmpty then exit;
 assignfile(f,path);
 rewrite(f);
 with table do
 try
  for c:=0 to FieldCount-2 do
   if fields[c].visible then
    Write(f,fields[c].displayname,#9);
  if fields[FieldCount-1].visible then
   Writeln(f,fields[FieldCount-1].displayname);
  table.First;
  while not table.eof do
  begin
   for c:=0 to FieldCount-2 do
    if fields[c].visible then
     Write(f,GetFieldValue(fields[c]),#9);

   if fields[FieldCount-1].visible then
    Writeln(f,GetFieldValue(fields[FieldCount-1]));
   next;
  end;
  result:=true;
 finally
  closefile(f);
 end;
end;

Function ExportTableClipboard(Table : TDataSet) : boolean;
var c : integer;
var s:string;
begin
 result:=false;
 if table.IsEmpty then exit;
 clipboard.Clear;
 with table do
 begin
  for c:=0 to FieldCount-2 do
   if fields[c].visible then
    s:=s+fields[c].displayname+#9;
  if fields[FieldCount-1].visible then
   s:=s+fields[FieldCount-1].displayname+#13#10;
  table.First;
  while not table.eof do
  begin
   for c:=0 to FieldCount-2 do
    if fields[c].visible then
     s:=s+fields[c].asstring+#9;
   if fields[FieldCount-1].visible then
    s:=s+fields[FieldCount-1].asstring+#13#10;
   next;
  end;
  result:=true;
  clipboard.astext:=s;
 end;
end;

end.
