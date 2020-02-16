unit janXMLTree;

{  Created by Jan Verhoeven - 10 June 2000
   jan1.verhoeven@wxs.nl
   http://jansfreeware.com

   This code may be freely used in any freeware application
   provided you keep this text in the source code.
   When you want to use this code in a commercial application
   you must obtain approval from the author.}

interface

uses
  Windows,  SysUtils, Classes,  Dialogs, variants;

type
  TjanXMLValueType=(xvtString,xvtCDATA);
  TjanXMLFilterOperator=(xfoNOP,xfoEQ,xfoIEQ,xfoNE,xfoINE,xfoGE,xfoIGE,xfoLE,xfoILE,xfoGT,xfoIGT,xfoLT,xfoILT);

  TjanXMLTree = class;

  TjanXMLFilterAtom=class(TObject)
  private
    FValue: string;
    FName: string;
    FOperator: TjanXMLFilterOperator;
    FAttributeFilter: boolean;
    procedure SetName(const Value: string);
    procedure SetOperator(const Value: TjanXMLFilterOperator);
    procedure SetValue(const Value: string);
    procedure SetAttributeFilter(const Value: boolean);
  public
    property Name:string read FName write SetName;
    property Operator:TjanXMLFilterOperator read FOperator write SetOperator;
    property Value:string read FValue write SetValue;
    property AttributeFilter:boolean read FAttributeFilter write SetAttributeFilter;
  end;


  TjanXMLFilter=class(TObject)
  private
    FName: string;
    FFilters: TList;
    procedure SetName(const Value: string);
    procedure SetFilters(const Value: TList);
  public
    constructor Create(FilterStr:string);
    destructor  Destroy; override;
    property    Name:string read FName write SetName;
    property    Filters:TList read FFilters write SetFilters;
  end;

  TjanXMLAttribute=class(TObject)
  private
    FName: string;
    FValue: variant;
    procedure   SetName(const Value: string);
    procedure   SetValue(const Value: variant);
  public
    constructor create(aName:string;aValue:variant);
    function    document:string;
    property    Name:string read FName write SetName;
    property    Value:variant read FValue write SetValue;
  end;

  TjanXMLNode= class(TObject)
  private
    FName: string;
    FValue: variant;
    FNodes: TList;
    FAttributes: TList;
    FParentNode: TjanXMLNode;
    FValueType: TjanXMLValueType;
    procedure   SetName(const Value: string);
    procedure   SetValue(const Value: variant);
    procedure   SetNodes(const Value: TList);
    procedure   SetAttributes(const Value: TList);
    procedure   SetParentNode(const Value: TjanXMLNode);
    procedure SetValueType(const Value: TjanXMLValueType);
  public
    constructor create(aName:string;aValue:variant;aParent:TjanXMLNode);
    destructor  destroy;override;
    function    AddNode(aName:string;aValue:variant):TjanXMLNode;
    function    AddNodeEx(aName:string;aValue:variant):TjanXMLNode;
    function    AddOrReplaceNode(aName: string; aValue: variant): TjanXMLNode;
    procedure   DeleteNode(index:integer);
    procedure   ClearNodes;
    function    AddAttribute(aName:string;aValue:variant):TjanXMLAttribute;
    procedure   DeleteAttribute(index:integer);
    procedure   ClearAttributes;
    function    document(aLevel:integer):string;
    function    getNodePath:string;
    function    getNamedNode(aName:string):TjanXMLNode;
    function    getNodeValue(aName: string): Variant;
    function    SelectSingleNode(pattern:string):TjanXMLNode;
    procedure   selectNodes(pattern:string;aList:TList);
    function    transformNode(stylesheet:TjanXMLNode):string;
    function    process(aLevel:integer;node:TjanXMLNode):string;
    function    findNamedNode(aName:string):TjanXMLNode;
    procedure   findNamedNodes(aName:string;aList:TList);
    procedure   getAllNodes(aList:TList);
    function    getNamedAttribute(aName:string):TjanXMLAttribute;
    procedure   findNamedAttributes(aName:string;aList:TList);
    function    matchFilter(objFilter:TjanXMLFilter):boolean;
    function    findRealNamedNode(aName:string):TjanXMLNode;
    procedure   findRealNamedNodes(aName:string;aList:TList);
    procedure   getNodeNames(aList:TStringList);
    procedure   getAttributeNames(aList:TStringList);
    function    getNameSpace:string;
    function    hasChildNodes:boolean;
    function    cloneNode:TjanXMLNode;
    function    firstChild:TjanXMLNode;
    function    lastChild:TjanXMLNode;
    function    previousSibling:TjanXMLNode;
    function    nextSibling:TjanXMLNode;
    function    moveAddNode(Dest:TjanXMLNode):TjanXMLNode;
    function    moveInsertNode(Dest:TjanXMLNode):TjanXMLNode;
    function    removeChildNode(aNode:TjanXMLNode):TjanXMLNode;
    property    Name:string read FName write SetName;
    property    Value:variant read FValue write SetValue;
    property    ValueType:TjanXMLValueType read FValueType write SetValueType;
    property    Nodes:TList read FNodes write SetNodes;
    property    parentNode:TjanXMLNode read FParentNode write SetParentNode;
    property    Attributes:TList read FAttributes write SetAttributes;
  end;


  TjanXMLTree = class(TjanXMLNode)
  private
    FLines: TStringlist;
    FNodeCount:integer;
    procedure   SetLines(const Value: TStringlist);
    function getText: string;
    procedure setText(const Value: string);
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(aName:string;aValue:variant;aParent:TjanXMLNode);
    destructor  Destroy;override;
    procedure   ParseXML;
    procedure   LoadFromFile(fn:string);
    procedure   LoadFromStream(Stream:TStream);
    procedure   SaveToFile(aFile:string);
    procedure   SaveToStream(Stream:TStream);
    function    asText:string;
    property    Lines:TStringlist read FLines write SetLines;
    property    NodeCount:integer read FNodeCount;
    property    Text:string read getText write setText;
  published
    { Published declarations }
  end;


  procedure PreProcessXML(aList:Tstringlist);

implementation

const
  cr = chr(13)+chr(10);
  tab = chr(9);

  ToUpperChars: array[0..255] of Char =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
     #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$80,#$81,#$82,#$81,#$84,#$85,#$86,#$87,#$88,#$89,#$8A,#$8B,#$8C,#$8D,#$8E,#$8F,
     #$80,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$8A,#$9B,#$8C,#$8D,#$8E,#$8F,
     #$A0,#$A1,#$A1,#$A3,#$A4,#$A5,#$A6,#$A7,#$A8,#$A9,#$AA,#$AB,#$AC,#$AD,#$AE,#$AF,
     #$B0,#$B1,#$B2,#$B2,#$A5,#$B5,#$B6,#$B7,#$A8,#$B9,#$AA,#$BB,#$A3,#$BD,#$BD,#$AF,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF);

  ToLowerChars: array[0..255] of Char =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
     #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
     #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$90,#$83,#$82,#$83,#$84,#$85,#$86,#$87,#$88,#$89,#$9A,#$8B,#$9C,#$9D,#$9E,#$9F,
     #$90,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$9A,#$9B,#$9C,#$9D,#$9E,#$9F,
     #$A0,#$A2,#$A2,#$BC,#$A4,#$B4,#$A6,#$A7,#$B8,#$A9,#$BA,#$AB,#$AC,#$AD,#$AE,#$BF,
     #$B0,#$B1,#$B3,#$B3,#$B4,#$B5,#$B6,#$B7,#$B8,#$B9,#$BA,#$BB,#$BC,#$BE,#$BE,#$BF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
     #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF,
     #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
     #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF);


function Q_PosStr(const FindString, SourceString: string; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        PUSH    EDX
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        SUB     EDX,ECX
        JNG     @@qt0
        MOV     EBX,EAX
        XCHG    EAX,EDX
        NOP
        ADD     EDI,ECX
        MOV     ECX,EAX
        MOV     AL,BYTE PTR [ESI]
@@lp1:  CMP     AL,BYTE PTR [EDI]
        JE      @@uu
@@fr:   INC     EDI
        DEC     ECX
        JNZ     @@lp1
@@qt0:  XOR     EAX,EAX
        JMP     @@qt
@@ms:   MOV     AL,BYTE PTR [ESI]
        MOV     EBX,EDX
        JMP     @@fr
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     AL,BYTE PTR [ESI+EBX]
        XOR     AL,BYTE PTR [EDI+EBX]
        JNE     @@ms
        DEC     EBX
        JNE     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        SUB     EAX,[ESP]
@@qt:   POP     ECX
        POP     EBX
        POP     EDI
        POP     ESI
end;


function Q_PosText(const FindString, SourceString: string; StartPos: Integer): Integer;
asm
        PUSH    ESI
        PUSH    EDI
        PUSH    EBX
        NOP
        TEST    EAX,EAX
        JE      @@qt
        TEST    EDX,EDX
        JE      @@qt0
        MOV     ESI,EAX
        MOV     EDI,EDX
        PUSH    EDX
        MOV     EAX,[EAX-4]
        MOV     EDX,[EDX-4]
        DEC     EAX
        SUB     EDX,EAX
        DEC     ECX
        PUSH    EAX
        SUB     EDX,ECX
        JNG     @@qtx
        ADD     EDI,ECX
        MOV     ECX,EDX
        MOV     EDX,EAX
        MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
@@lp1:  MOVZX   EBX,BYTE PTR [EDI]
        CMP     AL,BYTE PTR [EBX+ToUpperChars]
        JE      @@uu
@@fr:   INC     EDI
        DEC     ECX
        JNE     @@lp1
@@qtx:  ADD     ESP,$08
@@qt0:  XOR     EAX,EAX
        JMP     @@qt
@@ms:   MOVZX   EBX,BYTE PTR [ESI]
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOV     EDX,[ESP]
        JMP     @@fr
        NOP
@@uu:   TEST    EDX,EDX
        JE      @@fd
@@lp2:  MOV     BL,BYTE PTR [ESI+EDX]
        MOV     AH,BYTE PTR [EDI+EDX]
        CMP     BL,AH
        JE      @@eq
        MOV     AL,BYTE PTR [EBX+ToUpperChars]
        MOVZX   EBX,AH
        XOR     AL,BYTE PTR [EBX+ToUpperChars]
        JNE     @@ms
@@eq:   DEC     EDX
        JNZ     @@lp2
@@fd:   LEA     EAX,[EDI+1]
        POP     ECX
        SUB     EAX,[ESP]
        POP     ECX
@@qt:   POP     EBX
        POP     EDI
        POP     ESI
end;


procedure PreProcessXML(aList:Tstringlist);
const
  crlf  = chr(13)+chr(10);
  tab = chr(9);
var oList:TStringlist;
    s,xTag,xText,xData:string;
    p1,p2,c:integer;
    aLevel:integer;

    function clean(aText:string):string;
    begin
      result:=stringreplace(aText,crlf,' ',[rfreplaceall]);
      result:=stringreplace(result,tab,' ',[rfreplaceall]);
      result:=trim(result);
    end;

    function cleanCDATA(aText:string):string;
    begin
      result:=stringreplace(aText,crlf,'\n ',[rfreplaceall]);
      result:=stringreplace(result,tab,'\t ',[rfreplaceall]);
    end;

    function spc:string;
    begin
      if alevel<1 then
        result:=''
      else
        result:=stringofchar(' ',2*aLevel);
    end;
begin
  oList:=TStringlist.create;
  s:=aList.text;
  xText:='';
  xTag:='';
  p1:=1;
  c:=length(s);
  aLevel:=0;
  repeat
    p2:=Q_posstr('<',s,p1);
    if p2>0 then begin
      xText:=trim(copy(s,p1,p2-p1));
      if xText<>'' then begin
        oList.Append('TX:'+clean(xText));
      end;
      p1:=p2;
      // check for CDATA
      if uppercase(copy(s,p1,9))='<![CDATA[' then begin
        p2:=Q_posstr(']]>',s,p1);
        xData:=copy(s,p1+9,p2-p1-9);
        oList.Append('CD:'+cleanCDATA(xData));
        p1:=p2+2;
      end
      else begin
        p2:=Q_posstr('>',s,p1);
        if p2>0 then begin
          xTag:=copy(s,p1+1,p2-p1-1);
          p1:=p2;
          if xTag[1]='/' then begin
            delete(xTag,1,1);
            oList.Append('CT:'+clean(xTag));
            dec(aLevel);
          end
          else if xtag[length(xTag)]='/' then begin
            oList.Append('ET:'+clean(xTag));
          end
          else begin
            inc(aLevel);
            oList.Append('OT:'+clean(xTag));
          end
        end
      end
    end
    else begin
      xText:=trim(copy(s,p1,length(s)));
      if xText<>'' then begin
        oList.Append('TX:'+clean(xText));
      end;
      p1:=c;
    end;
    inc(p1);
  until p1>c;
  alist.assign(oList);
  oList.free;
end;

procedure SaveString(aFile, aText:string);
begin
  with TFileStream.Create(aFile, fmCreate) do try
    writeBuffer(aText[1],length(aText));
    finally free; end;
end;


{ TjanXMLNode }

function TjanXMLNode.AddAttribute(aName: string;
  aValue: variant): TjanXMLAttribute;
var n:TjanXMLAttribute;
begin
  n:=TjanXMLAttribute.create(aName,aValue);
  Attributes.Add(n);
  result:=n;
end;

function TjanXMLNode.AddOrReplaceNode(aName: string; aValue: variant): TjanXMLNode;
var n:TjanXMLNode;
begin
 Result:=GetNamedNode(aname);
 if Assigned(Result)
  then Result.Value:=avalue
  else Result:=addnode(aname,avalue);
end;

function TjanXMLNode.AddNode(aName: string; aValue: variant): TjanXMLNode;
var n:TjanXMLNode;
begin
  n:=TjanXMLNode.create(aName,aValue,self);
  self.Nodes.Add(n);
  result:=n
end;

// adds node and parses any attributes;
function TjanXMLNode.AddNodeEx(aName: string; aValue: variant): TjanXMLNode;
var n:TjanXMLNode;
    s,sn,sv:string;
    c,p1,p2:integer;
begin
  n:=TjanXMLNode.create(aName,aValue,self);
  self.Nodes.Add(n);
  result:=n;
  c:=length(aName);
  //first parse name
  p1:=Q_posstr(' ',aName,1);
  if p1=0 then exit;
  s:=copy(aName,1,p1-1);
  n.Name:=s;
  repeat
  // find '='
    p2:=Q_posstr('=',aName,p1);
    if p2=0 then exit;
    sn:=trim(copy(aName,p1,p2-p1));
    p1:=p2;
  // find begin of value
    p1:=Q_posstr('"',aName,p1);
    if p1=0 then exit;
    p2:=Q_posstr('"',aName,p1+1);
    if p2=0 then exit;
    sv:=copy(aName,p1+1,p2-p1-1);
    n.AddAttribute(sn,sv);
    p1:=p2+1;
  until p1>c;
end;

function TjanXMLNode.getNamedAttribute(aName: string): TjanXMLAttribute;
var i:integer;
    n:TjanXMLAttribute;
begin
  result:=nil;
  if Attributes.Count=0 then exit;
  for i:=0 to Attributes.count-1 do
  begin
    n:=TjanXMLAttribute(Attributes[i]);
    if n.name=aName then begin
      result:=n;
      exit;
    end;
  end;
end;

procedure TjanXMLNode.ClearAttributes;
var i:integer;
begin
  if Attributes.count<>0 then begin
    for i:=0 to Attributes.count-1 do
      TjanXMLAttribute(Attributes[i]).free;
    Attributes.clear;
  end;
end;

procedure TjanXMLNode.ClearNodes;
var i:integer;
begin
  i:=nodes.count;
  if i<>0 then begin
    for i:=0 to nodes.count-1 do
      TjanXMLNode(Nodes[i]).free;
    nodes.clear;
  end;
end;

constructor TjanXMLNode.create(aName:string;aValue:variant;aParent:TjanXMLNode);
begin
  FNodes:=TList.Create;
  FName:=aName;
  FValue:=aValue;
  FValueType:=xvtString;
  FParentNode:=aParent;
  FAttributes:=TList.Create;
end;

procedure TjanXMLNode.DeleteAttribute(index: integer);
begin
  TjanXMLAttribute(Attributes[index]).free;
end;

procedure TjanXMLNode.DeleteNode(index: integer);
begin
  TjanXMLNode(Nodes[index]).free;
end;

destructor TjanXMLNode.destroy;
begin
  ClearNodes;
  FNodes.free;
  ClearAttributes;
  FAttributes.Free;
  inherited;
end;


function TjanXMLNode.document(aLevel:integer):string;
const
  cr = chr(13)+chr(10);
  tab = chr(9);

var s:string;
    i:integer;
    spc:string;

    function ExpandCDATA(aValue:string):string;
    begin
      result:=stringreplace(aValue,'\n ',cr,[rfreplaceall]);
      result:=stringreplace(result,'\t ',tab,[rfreplaceall]);
    end;
begin
  if aLevel>0 then
    spc:=StringOfChar(' ',aLevel*2)
  else
    spc:='';
  result:=spc+'<'+Name;
  if Attributes.Count>0 then
  for i:=0 to Attributes.count-1 do
    result:=result+TjanXMLAttribute(Attributes[i]).document;

  try
   s:=Value;
  except
   on EVariantError do s:='';
  end;

  if (nodes.count=0) and (s='') then
  begin
    result:=result+' />'+cr;
    exit;
  end
  else
    result:=result+'>'+cr;
  if s<>'' then
  begin
    if ValueType=xvtString then
      result:=result+spc+'  '+s+cr
    else if ValueType=xvtCDATA then begin
      result:=result+spc+'  '+'<![CDATA['+ExpandCDATA(s)+']]>'+cr;
    end
  end;
  if nodes.count<>0 then
    for i:=0 to nodes.count-1 do
      result:=result+TjanXMLNode(nodes[i]).document(aLevel+1);
  result:=result+spc+'</'+Name+'>'+cr;
end;

// duplicates a node recursively
function TjanXMLNode.cloneNode: TjanXMLNode;
var i:integer;
    n:TjanXMLNode;
begin
  result:=TjanXMLNode.create(name,value,nil);
  result.name:=name;
  result.value:=value;
  if Attributes.count>0 then begin
    for i:=0 to Attributes.count-1 do begin
      result.AddAttribute(TjanXMLAttribute(Attributes[i]).name,TjanXMLAttribute(Attributes[i]).value);
    end;
  end;
  if nodes.count>0 then begin
    for i:=0 to nodes.count-1 do begin
      n:=TjanXMLNode(nodes[i]).cloneNode;
      result.Nodes.Add(n);
    end;
  end;
end;

function TJanXMLNode.getNodeValue(aName:string): Variant;
var xn : TJanXMLNode;
begin
 xn:=GetNamedNode(aname);
 if not Assigned(xn)
  then Result:=null
  else Result:=xn.Value;
end;

function TjanXMLNode.getNamedNode(aName:string): TjanXMLNode;
var i,c:integer;
    n:TjanXMLNode;
begin
  result:=nil;
  if Nodes.Count=0 then exit;
  for i:=0 to Nodes.count-1 do
  begin
    n:=TjanXMLNode(nodes[i]);
    if n.name=aName then begin
      result:=n;
      exit;
    end;
  end;
end;

procedure TjanXMLNode.SetAttributes(const Value: TList);
begin
  FAttributes := Value;
end;

procedure TjanXMLNode.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TjanXMLNode.SetNodes(const Value: TList);
begin
  FNodes := Value;
end;

procedure TjanXMLNode.SetParentNode(const Value: TjanXMLNode);
begin
  FParentNode := Value;
end;

procedure TjanXMLNode.SetValue(const Value: variant);
begin
  FValue := Value;
end;

function TjanXMLNode.firstChild: TjanXMLNode;
begin
 if Nodes.Count>0 then
   result:=TjanXMLNode(nodes[0])
 else
   result:=nil;  
end;

function TjanXMLNode.lastChild: TjanXMLNode;
begin
  if nodes.count>0 then
    result:=TjanXMLNode(nodes[nodes.count-1])
  else
    result:=nil;
end;

function TjanXMLNode.nextSibling: TjanXMLNode;
var index:integer;
begin
  result:=nil;
  if ParentNode=nil then exit;
  index:= ParentNode.Nodes.IndexOf(self);
  if index=-1 then exit;
  if index<ParentNode.nodes.Count-1 then
    result:=TjanXMLNode(ParentNode.nodes[index+1]);
end;

function TjanXMLNode.previousSibling: TjanXMLNode;
var index:integer;
begin
  result:=nil;
  if ParentNode=nil then exit;
  index:= ParentNode.Nodes.IndexOf(self);
  if index=-1 then exit;
  if index>0 then
    result:=TjanXMLNode(ParentNode.nodes[index-1]);
end;
// moves a node to a new location
function TjanXMLNode.moveInsertNode(Dest: TjanXMLNode): TjanXMLNode;
var index1,index2:integer;
begin
  result:=nil;
  if Dest.parentNode=nil then exit;  // can not move to root
  index1:=self.parentNode.Nodes.IndexOf(self);
  if index1=-1 then exit;
  index2:=dest.parentNode.Nodes.IndexOf(dest);
  if index2=-1 then exit;
  dest.parentNode.Nodes.Insert(index2,self);
  self.parentNode.nodes.Delete(index1);
  self.parentNode:=dest.parentnode;
  result:=self;
end;

function TjanXMLNode.moveAddNode(Dest: TjanXMLNode): TjanXMLNode;
var index:integer;
begin
  result:=nil;
  if Dest=nil then exit;  // can not move to root
  index:=self.parentNode.Nodes.IndexOf(self);
  if index=-1 then exit;
  dest.Nodes.Add(self);
  self.parentNode.nodes.Delete(index);
  self.parentNode:=dest;
  result:=self;
end;


// removes and frees the childnode recursively.
// returns self when done, or nil in case of error
function TjanXMLNode.removeChildNode(aNode: TjanXMLNode): TjanXMLNode;
var index:integer;
begin
  result:=nil;
  index:=nodes.IndexOf(aNode);
  if index=-1 then exit;
  nodes.Delete(index);
  aNode.free;
  result:=self;
end;

function TjanXMLNode.hasChildNodes: boolean;
begin
  result:=nodes.count>0;
end;

procedure TjanXMLNode.getAttributeNames(aList: TStringList);
var i,c:integer;
begin
  aList.Clear;
  c:=Attributes.count;
  if c=0 then exit;
  for i:=0 to c-1 do
    aList.append(TjanXMLAttribute(Attributes[i]).name);
end;

procedure TjanXMLNode.getNodeNames(aList: TStringList);
var i,c:integer;
begin
  aList.Clear;
  c:=Nodes.count;
  if c=0 then exit;
  for i:=0 to c-1 do
    aList.append(TjanXMLNode(Nodes[i]).name);
end;

function TjanXMLNode.getNodePath: string;
var n:TjanXMLNode;
begin
  n:=self;
  result:=name;
  while n.parentNode<>nil do
  begin
    n:=n.parentNode;
    result:=n.name+'/'+result;
  end;
end;


// search recursively for a named node
function TjanXMLNode.findNamedNode(aName: string): TjanXMLNode;
var i,c:integer;
    n:TjanXMLNode;
begin
  result:=nil;
  if Nodes.Count=0 then exit;
  for i:=0 to Nodes.count-1 do
  begin
    n:=TjanXMLNode(nodes[i]);
    if n.name=aName then begin
      result:=n;
      exit;
    end
    else begin  // recurse
      result:=n.findNamedNode(aName);
      if result<>nil then exit;
    end;
  end;
end;

// add all found named nodes to aList
procedure TjanXMLNode.findNamedNodes(aName: string; aList: TList);
var i,c:integer;
    n:TjanXMLNode;
begin
  if Nodes.Count=0 then exit;
  for i:=0 to Nodes.count-1 do
  begin
    n:=TjanXMLNode(nodes[i]);
    if n.name=aName then
      alist.Add(n);
    // recurse
    n.findNamedNodes(aName,aList);
  end;
end;

// add recursively all nodes to aList
// the list only contains pointers to the nodes
// typecast to use, e.g. n:=TjanXMLNode(aList[0]);
procedure TjanXMLNode.getAllNodes(aList: TList);
var i,c:integer;
    n:TjanXMLNode;
begin
  if Nodes.Count=0 then exit;
  for i:=0 to Nodes.count-1 do
  begin
    n:=TjanXMLNode(nodes[i]);
    alist.Add(n);
    // recurse
    n.getAllNodes(aList);
  end;
end;

// add recursively all nodes with matching named attribute to aList
// the list only contains pointers to the nodes
// typecast to use, e.g. n:=TjanXMLNode(aList[0]);
procedure TjanXMLNode.findNamedAttributes(aName: string; aList: TList);
var i,c:integer;
    n:TjanXMLNode;
begin
  c:= Attributes.count;
  if c>0 then
    for i:=0 to c-1 do begin
      if TjanXMLAttribute(Attributes[i]).name=aName then
      begin
        aList.Add(self);
        break;
      end;
    end;
  if Nodes.Count=0 then exit;
  for i:=0 to Nodes.count-1 do
  begin
    n:=TjanXMLNode(nodes[i]);
    n.findNamedAttributes(aName,aList);
  end;
end;

{
this procedure adds the node to aList when it matches the pattern
this will be the key procedure for XSL implementation
only basic matching is provided in the first release
path operators
 /  child path
 // recursive descent
 .  curren context or node
 @  attribute
 *  wildcar
some examples
 /  the root node only
 book/author  <author> elements that are children of <book> elements
 // the root node and all nodes below
 //*  all element nodes below the root node
 book//author  <author> elements that are descendants of <book> elements
 .//author  <author elements that are descendants of the current element
 *  non-root elements, irrespective of the element name
 book/*  elements that are children of <book> elements
 book//* elements that are descendants of <book> elements
 book/*/author  <author> elements that are grandchildren of <book> elements
 book/@print_date print_date attributes that are attached to <book> elements
 */@print_date print_date atrtributes that are attached to any elements

index can be used to specify a particular node within a matching set
 /booklist/book[0]  First <book> node in root <booklist> element
 /booklist/book[2]  Third <book> node in root <booklist> element
 /booklist/book[end()] Last <book> node in root <booklist> element
}

// search recursively for a named node XARKA

function RealName(Node : TJanXMLNode) : String;
var
 p : integer;
begin
 p:=pos(':',node.Name);
 if p=0
  then result:=node.Name
  else result:=copy(node.Name,p+1,255);
end;

function TjanXMLNode.findRealNamedNode(aName: string): TjanXMLNode;
var i,c:integer;
    n:TjanXMLNode;
begin
  result:=nil;
  if Nodes.Count=0 then exit;
  for i:=0 to Nodes.count-1 do
  begin
    n:=TjanXMLNode(nodes[i]);
    if AnsiSameText(RealName(n),aName) then
    begin
      result:=n;
      exit;
    end
    else
    begin  // recurse
      result:=n.findRealNamedNode(aName);
      if result<>nil then exit;
    end;
  end;
end;

// add all found named nodes to aList
procedure TjanXMLNode.findRealNamedNodes(aName: string; aList: TList);
var i,c:integer;
    n:TjanXMLNode;
begin
  if Nodes.Count=0 then exit;
  for i:=0 to Nodes.count-1 do
  begin
    n:=TjanXMLNode(nodes[i]);
    if AnsiSameText(RealName(n),aName) then
      alist.Add(n);
    // recurse
    n.findRealNamedNodes(aName,aList);
  end;
end;

procedure TjanXMLNode.SetValueType(const Value: TjanXMLValueType);
begin
  FValueType := Value;
end;

{select a node based on path info
 e.g. booklist/book/category will find the first
 <category> that is a child of <book> that is a child of <booklist>
 }
function TjanXMLNode.SelectSingleNode(pattern: string): TjanXMLNode;
var aName,npattern,aFilter:string;
    p,i,c:integer;
    n:TjanXMLNode;
    objFilter:TjanXMLFilter;
begin
  result:=nil;
  c:=nodes.count;
  if c=0 then exit;
  p:=pos('/',pattern);
  if p=0 then begin
    objFilter:=TjanXMLFilter.create(pattern);
    for i:=0 to c-1 do begin
      n:=TjanXMLNode(nodes[i]);
      if n.matchFilter(objFilter) then begin
        result:=n;
        objFilter.free;
        exit;
      end;
    end;
    objFilter.free;
    exit; // not found;
  end
  else begin
    aFilter:=copy(pattern,1,p-1);
    nPattern:=copy(pattern,p+1,length(pattern));
    objFilter:=TjanXMLFilter.create(aFilter);
    for i:=0 to c-1 do begin
      n:=TjanXMLNode(nodes[i]);
      if n.matchFilter(objFilter) then begin
        result:=n.SelectSingleNode(npattern);
        if result<>nil then begin objFilter.free; exit end;
      end;
    end;
    objFilter.free;
  end;
end;

// filter contains name + any filters between []
function TjanXMLNode.matchFilter(objFilter: TjanXMLFilter): boolean;
var
  i,j:integer;
  attName,attValue:string;
  a:TjanXMLAttribute;
  n:TjanXMLNode;
  atom:TjanXMLFilterAtom;
  attResult:boolean;

  function evalAtom(aValue:string):boolean;
  begin
    result:=false;
    case atom.Operator of
      xfoNOP: result:=true;
      xfoEQ : result:=aValue=atom.Value;
      xfoIEQ: result:=comparetext(aValue,atom.value)=0;
      xfoNE : result:=avalue<>atom.value;
      xfoINE: result:=comparetext(aValue,atom.value)<>0;
      xfoGT :
        try
          result:= Strtofloat(avalue)>strtofloat(atom.value);
          except
          end;
      xfoIGT: result:=comparetext(aValue,atom.value)>0;
      xfoLT :
        try
          result:= Strtofloat(avalue)<strtofloat(atom.value);
          except
          end;
      xfoILT: result:=comparetext(aValue,atom.value)<0;
      xfoGE :
        try
          result:= Strtofloat(avalue)>=strtofloat(atom.value);
          except
          end;
      xfoIGE: result:=comparetext(aValue,atom.value)>=0;
      xfoLE :
        try
          result:= Strtofloat(avalue)<=strtofloat(atom.value);
          except
          end;
      xfoILE: result:=comparetext(aValue,atom.value)<=0;
    end;

  end;
begin
  result:=false;
  if objFilter.Filters.Count=0 then
  begin  // just filter on name
    result:=objFilter.Name=name;
    exit;
  end;
  for i:=0 to objFilter.Filters.count-1 do
  begin
    atom:=TjanXMLFilterAtom(objFilter.Filters[i]);
    if atom.AttributeFilter then begin
      attName:=atom.Name;
      if attName='*' then begin  // match any attribute
        if Attributes.Count=0 then exit;
        for j:=0 to Attributes.count-1 do
        begin
          a:=TjanXMLAttribute(Attributes[j]);
          attResult:=evalAtom(a.value);
          if AttResult then break;
        end;
        if not AttResult then exit;
      end
      else begin
        a:=GetNamedAttribute(attName);
        if a=nil then exit;
        if not evalAtom(a.value) then exit;
      end;
    end
    else begin
      attName:=atom.Name;
      n:=GetNamedNode(attName);
      if n=nil then exit;
      if not evalAtom(n.value) then exit;
    end;
  end;
  result:=true;
end;

procedure TjanXMLNode.SelectNodes(pattern: string; aList: TList);
var aName,npattern:string;
    p,i,c:integer;
    n:TjanXMLNode;
    aFilter:string;
    objFilter:TjanXMLFilter;
    recurse:boolean;
begin
  c:=nodes.count;
  if c=0 then exit;
  if copy(pattern,1,2)='//' then begin  //recursive
    delete(pattern,1,2);
    recurse:=true;
  end
  else recurse:=false;
  p:=pos('/',pattern);
  if p=0 then begin
    aFilter:=pattern;
    objFilter:=TjanXMLFilter.Create(aFilter);
    for i:=0 to c-1 do begin
      n:=TjanXMLNode(nodes[i]);
      if n.matchFilter(objFilter) then
        aList.Add(n)
      else begin
        if recurse then
          n.SelectNodes('//'+pattern,aList);
      end;
    end;
    objFilter.free;
  end
  else begin
    aFilter:=copy(pattern,1,p-1);
    if copy(pattern,p,2)='//' then
      npattern:=copy(pattern,p,length(pattern))
    else
      npattern:=copy(pattern,p+1,length(pattern));
    objFilter:=TjanXMLFilter.Create(aFilter);
    for i:=0 to c-1 do begin
      n:=TjanXMLNode(nodes[i]);
      if n.matchFilter(objFilter) then
        n.SelectNodes(npattern,aList)
      else begin
        if recurse then
          n.selectNodes('//'+pattern,aList);
      end;
    end;
    objFilter.free;
  end;
end;

// the XSL implementation
// although this function returns a string, the string itself can be parsed to create a DOM
function TjanXMLNode.transformNode(stylesheet: TjanXMLNode): string;
begin
  // to be implemented;
  result:=stylesheet.process(0,self);
end;

// used in conjunction with the transformNode function.
// basically works like the document function except for nodes with processing instructions
function TjanXMLNode.process(aLevel:integer;node: TjanXMLNode): string;
const
  cr = chr(13)+chr(10);
  tab = chr(9);

var s:string;
    i:integer;
    spc:string;

    function ExpandCDATA(aValue:string):string;
    begin
      result:=stringreplace(aValue,'\n ',cr,[rfreplaceall]);
      result:=stringreplace(result,'\t ',tab,[rfreplaceall]);
    end;
begin
  if parentNode=nil then begin
    if nodes.count<>0 then
    for i:=0 to nodes.count-1 do
      result:=result+TjanXMLNode(nodes[i]).process(aLevel+1,node);
    exit;
  end;
  if aLevel>0 then
    spc:=StringOfChar(' ',aLevel*2)
  else
    spc:='';
  result:=spc+'<'+Name;
  if Attributes.Count>0 then
  for i:=0 to Attributes.count-1 do
    result:=result+TjanXMLAttribute(Attributes[i]).document;
  if (nodes.count=0) and (value='') then
  begin
    result:=result+' />'+cr;
    exit;
  end
  else
    result:=result+'>'+cr;
  if Value<>'' then
  begin
    if ValueType=xvtString then
      result:=result+spc+'  '+Value+cr
    else if ValueType=xvtCDATA then begin
      result:=result+spc+'  '+'<![CDATA['+ExpandCDATA(value)+']]>'+cr;
    end
  end;
  if nodes.count<>0 then
    for i:=0 to nodes.count-1 do
      result:=result+TjanXMLNode(nodes[i]).process(aLevel+1,node);
  result:=result+spc+'</'+Name+'>'+cr;
end;


function TjanXMLNode.getNameSpace: string;
var p:integer;
begin
  p:=pos(':',FName);
  if p>0 then
    result:=copy(FName,1,p-1)
  else
    result:='';
end;

{ TjanXMLTree }



constructor TjanXMLTree.Create(aName:string;aValue:variant;aParent:TjanXMLNode);
begin
  inherited Create(aName,aValue,aParent);
  FLines:=TStringList.create;
end;

destructor TjanXMLTree.Destroy;
begin
  FLines.free;
  inherited destroy;
end;

function TjanXMLTree.asText: string;
var
  i,c:integer;
begin
  c:=Nodes.Count;
  if c=0 then exit;
  result:='<'+Name;
  if Attributes.Count>0 then
  for i:=0 to Attributes.count-1 do
    result:=result+TjanXMLAttribute(Attributes[i]).document;
  result:=result+'>'+cr;
  for i:=0 to c-1 do
   result:=result+TjanXMLNode(nodes[i]).document(1);
  result:=result+'</'+Name+'>'+cr;
end;

procedure TjanXMLTree.SaveToFile(aFile: string);
begin
  Lines.text:=Text;
  Lines.SaveToFile(aFile)
end;


procedure TjanXMLTree.SetLines(const Value: TStringlist);
begin
  FLines.assign(Value);
end;

procedure TjanXMLTree.LoadFromStream(Stream:TStream);
begin
  ClearNodes;
  ClearAttributes;
  Lines.LoadFromStream(Stream);
  PreProcessXML(FLines);
  ParseXML;
end;

procedure TjanXMLTree.SaveToStream(Stream: TStream);
begin
  Lines.text:=asText;
  Lines.SaveToStream(Stream);
end;

function TjanXMLTree.getText: string;
var
  i,c:integer;
begin
  c:=Nodes.Count;
  if c=0 then exit;
//  result:='<'+Name;
//  if Attributes.Count>0 then
//  for i:=0 to Attributes.count-1 do
//    result:=result+TjanXMLAttribute(Attributes[i]).document;
//  result:=result+'>'+cr;
  result:='';
  for i:=0 to c-1 do
   result:=result+TjanXMLNode(nodes[i]).document(0);
//  result:=result+'</'+Name+'>'+cr;
end;

procedure TjanXMLTree.setText(const Value: string);
begin
  ClearNodes;
  ClearAttributes;
  Lines.text:=Value;
  PreProcessXML(FLines);
  ParseXML;
end;

{ TjanXMLAttribute }

constructor TjanXMLAttribute.create(aName: string; aValue: variant);
begin
  FName:=aName;
  FValue:=aValue;
end;

function TjanXMLAttribute.document:string;
var s:string;
begin
  s:=Value;
  result:=' '+Name+'="'+s+'"';
end;

procedure TjanXMLAttribute.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TjanXMLAttribute.SetValue(const Value: variant);
begin
  FValue := Value;
end;




{ TjanXMLTree }

procedure TjanXMLTree.ParseXML;
var i,c,index:integer;
    s,token,aName:string;
    n:TjanXMLNode;
begin
  i:=0;
  FNodeCount:=0;
  ClearNodes;
  ClearAttributes;
  Name:='root';
  n:=self;
  c:=Lines.Count-1;
  repeat
    s:=Lines[i];
    token:=copy(s,1,3);
    aName:=copy(s,4,length(s));
    if token='OT:' then begin
      n:=n.AddNodeEx(aName,'');
      inc(FNodeCount);
    end
    else if token='CT:' then begin
      n:=n.ParentNode;
    end
    else if token='ET:' then begin
      n.AddNodeEx(aName,'');
    end
    else if token='TX:' then begin
      n.Value:=aName;
      n.ValueType:=xvtString;
    end
    else if token='CD:' then begin
      n.value:=aName;
      n.ValueType:=xvtCDATA;
    end;
    inc(i);
  until i>c;
end;

procedure TjanXMLTree.LoadFromFile(fn: string);
begin
  ClearNodes;
  ClearAttributes;
  Lines.LoadFromFile(fn);
  PreProcessXML(FLines);
  ParseXML;
end;


{ TjanXMLFilter }

constructor TjanXMLFilter.Create(FilterStr: string);
var aName,aFilter,theFilter,nextFilter:string;
    p1,p2:integer;
    attName,attValue:string;
    attOperator:TjanXMLFilterOperator;
    atom:TjanXMLFilterAtom;
    a:TjanXMLAttribute;
    n:TjanXMLNode;

    function trimquotes(s:string):string;
    var cc:integer;
    begin
      result:=trim(s);
      if s='' then exit;
      if (s[1]='"') or (s[1]='''') then delete(result,1,1);
      if s='' then exit;
      cc:=length(result);
      if (result[cc]='"') or (result[cc]='''') then delete(result,cc,1);
    end;

    function splitNameValue(s:string):boolean;
    var pp:integer;
    begin
      result:=false;
      pp:=q_posstr(' $ne$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoNE;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+6,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $ine$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoINE;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+7,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $ge$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoGE;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+6,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $ige$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoIGE;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+7,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $gt$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoGT;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+6,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $igt$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoIGT;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+7,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $le$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoLE;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+6,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $ile$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoILE;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+7,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $lt$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoLT;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+6,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $ilt$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoILT;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+7,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $eq$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoEQ;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+6,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' $ieq$ ',s,1);
      if pp>0 then begin
        attOperator:=xfoIEQ;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+7,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      pp:=q_posstr(' = ',s,1);
      if pp>0 then begin
        attOperator:=xfoEQ;
        attName:=trim(copy(s,1,pp-1));
        attvalue:=trimquotes(copy(s,pp+3,length(s)));
        result:=(attName<>'') and (attValue<>'');
        exit;
      end;
      attOperator:=xfoNOP;
      attName:=s;
      attValue:='';
      result:=true;
      exit;
    end;

begin
  Filters:=TList.Create;
  p1:=q_posstr('[',FilterStr,1);
  if p1=0 then begin  // just a name filter on name
    name:=FilterStr;
    exit;
  end
  else begin
    Name:=copy(FilterStr,1,p1-1);
    delete(FilterStr,1,p1-1);
  end;
  repeat
    FilterStr:=trim(FilterStr);
    p1:=q_posstr('[',FilterStr,1);
    if p1=0 then exit;
    p2:=q_posstr(']',FilterStr,p1+1);
    if p2=0 then exit;
    theFilter:=copy(FilterStr,p1+1,p2-p1-1);
    delete(FilterStr,1,p2);
    if theFilter='' then exit;
    // check for attribute filter
    if theFilter[1]='@' then begin
      if not splitNameValue(copy(theFilter,2,length(theFilter))) then exit;
      atom:=TjanXMLFilterAtom.create;
      atom.Name:=attName;
      atom.Operator:=attOperator;
      atom.Value:=attValue;
      atom.AttributeFilter:=true;
      Filters.Add(atom);
    end
    else begin // childfilter
        if not splitNameValue(theFilter) then exit;
      atom:=TjanXMLFilterAtom.create;
      atom.Name:=attName;
      atom.Operator:=attOperator;
      atom.Value:=attValue;
      atom.AttributeFilter:=false;
      Filters.Add(atom);
    end;
  until FilterStr='';
end;




destructor TjanXMLFilter.Destroy;
var i:integer;
begin
  if Filters.Count>0 then
    for i:=0 to Filters.count-1 do
      TjanXMLFilterAtom(Filters[i]).free;
  filters.free;    
  inherited Destroy;
end;

procedure TjanXMLFilter.SetFilters(const Value: TList);
begin
  FFilters := Value;
end;

procedure TjanXMLFilter.SetName(const Value: string);
begin
  FName := Value;
end;

{ TjanXMLFilterAtom }

procedure TjanXMLFilterAtom.SetAttributeFilter(const Value: boolean);
begin
  FAttributeFilter := Value;
end;

procedure TjanXMLFilterAtom.SetName(const Value: string);
begin
  FName := Value;
end;

procedure TjanXMLFilterAtom.SetOperator(
  const Value: TjanXMLFilterOperator);
begin
  FOperator := Value;
end;

procedure TjanXMLFilterAtom.SetValue(const Value: string);
begin
  FValue := Value;
end;

end.
