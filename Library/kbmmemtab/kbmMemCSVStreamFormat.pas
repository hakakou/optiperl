unit kbmMemCSVStreamFormat;

interface

{$include kbmMemTable.inc}

// =========================================================================
// CSV stream format for kbmMemTable v. 3.xx+
//
// Copyright 1999-2002 Kim Bo Madsen/Optical Services - Scandinavia
// All rights reserved.
//
// LICENSE AGREEMENT
// PLEASE NOTE THAT THE LICENSE AGREEMENT HAS CHANGED!!! 16. Feb. 2000
//
// You are allowed to use this component in any project for free.
// You are NOT allowed to claim that you have created this component or to
// copy its code into your own component and claim that it was your idea.
//
// -----------------------------------------------------------------------------------
// IM OFFERING THIS FOR FREE FOR YOUR CONVINIENCE, BUT
// YOU ARE REQUIRED TO SEND AN E-MAIL ABOUT WHAT PROJECT THIS COMPONENT (OR DERIVED VERSIONS)
// IS USED FOR !
// -----------------------------------------------------------------------------------
//
// -----------------------------------------------------------------------------------
// PLEASE NOTE THE FOLLOWING ADDITION TO THE LICENSE AGREEMENT:
// If you choose to use this component for generating middleware libraries (with similar
// functionality as dbOvernet, Midas, Asta etc.), those libraries MUST be released as
// Open Source and Freeware!
// -----------------------------------------------------------------------------------
//
// You dont need to state my name in your software, although it would be
// appreciated if you do.
//
// If you find bugs or alter the component (f.ex. see suggested enhancements
// further down), please DONT just send the corrected/new code out on the internet,
// but instead send it to me, so I can put it into the official version. You will
// be acredited if you do so.
//
//
// DISCLAIMER
// By using this component or parts theirof you are accepting the full
// responsibility of the use. You are understanding that the author cant be
// made responsible in any way for any problems occuring using this component.
// You also recognize the author as the creator of this component and agrees
// not to claim otherwize!
//
// Please forward corrected versions (source code ONLY!), comments,
// and emails saying you are using it for this or that project to:
//            kbm@components4developers.com
//
// Latest version can be found at:
//            http://www.components4developers.com

//=============================================================================
// Remove the remark on the next lines if to keep CSV file compatibility
// between different versions of TkbmMemTable.
//{$define CSV_FILE_1XX_COMPATIBILITY}
//=============================================================================

// History.
// Per v. 3.00, the stream formats will have their own history.
//
// 3.00a alpha
//       Initial v. 3.00 CSV stream format release based on the sources of v. 2.53b.
//
// 3.00b alpha 11. Aug. 2001
//       Fixed loading CSV with CSVQuote=#0 and CSVRecordDelimiter=#0.
//       Fixed not allowing CSVFieldDelimiter=#0.
//       Bugs reported by Dave (rave154@yahoo.co.uk)
//
// 3.00c alpha 12. Aug. 2001
//       Added support for the Assign method.
//
// 3.00d alpha 20. Sep. 2001
//       Changed GetWord to automatically detect and accept unquoted fields.
//       Contribution by Georg Zimmer (gzimmer@empoweryourfirm.com).
//
// 3.00e alpha 17. Nov. 2001
//       Fixed LoadDef not deciphering the field definition list correctly
//       todo with field kind and default expression.
//
// 3.00f beta 30. Jan. 2002
//       Fixed bug reading CSV files with blobs.
//       Reason was a faulty GetWord algorithm.
//
// 3.00f9 beta 25. Feb. 2002
//       Added OnFormatLoadField and OnFormatSaveField event for reformatting of data.
//       Added sfQuoteOnlyStrings flag for selecting to only quote string/binary fields during save.
//       Published sfNoHeader and completed support for it. It controls if a header should be saved or loaded.
//
// 3.00 Final 14. Jun. 2002
//       Changed version status to final.
//
// 3.01 7. Aug. 2002
//      Fixed problem not loading last field if not quoted. Bug reported by several.
//
// 3.09 20. Apr. 2003
//      Fixed problem not loading last field in certain cases.

uses
  kbmMemTable,Classes,DB,
{$include kbmMemRes.inc}
  SysUtils;

type
  TkbmStreamFlagLocalFormat   = (sfSaveLocalFormat,sfLoadLocalFormat);
  TkbmStreamFlagNoHeader      = (sfSaveNoHeader,sfLoadNoHeader);
  TkbmStreamFlagQuoteOnlyStrings = (sfSaveQuoteOnlyStrings);
  TkbmStreamFlagPlaceholders  = (sfSavePlaceholders);

  TkbmStreamFlagsLocalFormat  = set of TkbmStreamFlagLocalFormat;
  TkbmStreamFlagsNoHeader     = set of TkbmStreamFlagNoHeader;
  TkbmStreamFlagsPlaceHolders = set of TkbmStreamFlagPlaceHolders;
  TkbmStreamFlagsQuoteOnlyStrings = set of TkbmStreamFlagQuoteOnlyStrings;

  TkbmOnFormatLoadField = procedure(Sender:TObject; Field:TField; var Null:boolean; var Data:string) of object;
  TkbmOnFormatSaveField = procedure(Sender:TObject; Field:TField; var Null:boolean; var Data:string) of object;

  TkbmCustomCSVStreamFormat = class(TkbmCustomStreamFormat)
  private
     FDataset:TkbmCustomMemTable;
     FOnFormatLoadField:TkbmOnFormatLoadField;
     FOnFormatSaveField:TkbmOnFormatSaveField;

     Ods,Oms,Ots,Oths:char;
     Ocf,Onf:Byte;
     Osdf,Ocs:string;

     buf,bufptr:PChar;
     remaining_in_buf:integer;
     Line,Word:string;
     lptr,elptr:PChar;

     ProgressCnt:integer;
     StreamSize:longint;

     FCSVQuote:char;
     FCSVFieldDelimiter:char;
     FCSVRecordDelimiter:char;
     FCSVTrueString,FCSVFalseString:string;
     FsfLocalFormat:TkbmStreamFlagsLocalFormat;
     FsfNoHeader:TkbmStreamFlagsNoHeader;
     FsfPlaceHolders:TkbmStreamFlagsPlaceHolders;
     FsfQuoteOnlyStrings:TkbmStreamFlagsQuoteOnlyStrings;

     procedure SetCSVFieldDelimiter(Value:char);
  protected
     FDefLoaded:boolean;

     function GetChunk:boolean; virtual;
     function GetLine:boolean; virtual;
     function GetWord(var null:boolean):string; virtual;

     function GetVersion:string; override;

     procedure BeforeSave(ADataset:TkbmCustomMemTable); override;
     procedure SaveDef(ADataset:TkbmCustomMemTable); override;
     procedure SaveData(ADataset:TkbmCustomMemTable); override;
     procedure AfterSave(ADataset:TkbmCustomMemTable); override;

     procedure DetermineLoadFieldIDs(ADataset:TkbmCustomMemTable; AList:TStringList; Situation:TkbmDetermineLoadFieldsSituation); override;
     procedure DetermineLoadFieldIndex(ADataset:TkbmCustomMemTable; ID:string; FieldCount:integer; OrigIndex:integer; var NewIndex:integer; Situation:TkbmDetermineLoadFieldsSituation); override;
     procedure BeforeLoad(ADataset:TkbmCustomMemTable); override;
     procedure LoadDef(ADataset:TkbmCustomMemTable); override;
     procedure LoadData(ADataset:TkbmCustomMemTable); override;
     procedure AfterLoad(ADataset:TkbmCustomMemTable); override;

     property OnFormatLoadField:TkbmOnFormatLoadField read FOnFormatLoadField write FOnFormatLoadField;
     property OnFormatSaveField:TkbmOnFormatSaveField read FOnFormatSaveField write FOnFormatSaveField;
     property CSVQuote:char read FCSVQuote write FCSVQuote;
     property CSVFieldDelimiter:char read FCSVFieldDelimiter write SetCSVFieldDelimiter;
     property CSVRecordDelimiter:char read FCSVRecordDelimiter write FCSVRecordDelimiter;
     property CSVTrueString:string read FCSVTrueString write FCSVTrueString;
     property CSVFalseString:string read FCSVFalseString write FCSVFalseString;
     property sfLocalFormat:TkbmStreamFlagsLocalFormat read FsfLocalFormat write FsfLocalFormat;
     property sfNoHeader:TkbmStreamFlagsNoHeader read FsfNoHeader write FsfNoHeader;
     property sfPlaceHolders:TkbmStreamFlagsPlaceHolders read FsfPlaceHolders write FsfPlaceHolders;
     property sfQuoteOnlyStrings:TkbmStreamFlagsQuoteOnlyStrings read FsfQuoteOnlyStrings write FsfQuoteOnlyStrings;
  public
     constructor Create(AOwner:TComponent); override;
     procedure Assign(Source:TPersistent); override;
  end;

  TkbmCSVStreamFormat = class(TkbmCustomCSVStreamFormat)
  published
     property CSVQuote;
     property CSVFieldDelimiter;
     property CSVRecordDelimiter;
     property CSVTrueString;
     property CSVFalseString;
     property sfLocalFormat;
     property sfQuoteOnlyStrings;
     property sfNoHeader;
     property Version;

     property sfData;
     property sfCalculated;
     property sfLookup;
     property sfNonVisible;
     property sfBlobs;
     property sfDef;
     property sfIndexDef;
     property sfPlaceHolders;
     property sfFiltered;
     property sfIgnoreRange;
     property sfIgnoreMasterDetail;
     property sfDeltas;
     property sfDontFilterDeltas;
     property sfAppend;
     property sfFieldKind;
     property sfFromStart;

     property OnFormatLoadField;
     property OnFormatSaveField;
     property OnBeforeLoad;
     property OnAfterLoad;
     property OnBeforeSave;
     property OnAfterSave;
     property OnCompress;
     property OnDeCompress;
  end;

  function StringToCodedString(const Source:string):string;
  function CodedStringToString(const Source:string):string;
  function StringToBase64(const Source:string):string;
  function Base64ToString(const Source:string):string;

{$ifdef LEVEL3}
procedure Register;
{$endif}

implementation

const
  // Table definition magic words.
  kbmTableDefMagicStart = '@@TABLEDEF START@@';
  kbmTableDefMagicEnd = '@@TABLEDEF END@@';

  // Index definition magic words.
  kbmIndexDefMagicStart = '@@INDEXDEF START@@';
  kbmIndexDefMagicEnd = '@@INDEXDEF END@@';

  // File version magic word.
  kbmFileVersionMagic = '@@FILE VERSION@@';

  // Current file versions. V. 1.xx file versions are considered 100, 2.xx are considered 2xx etc.
  kbmCSVFileVersion = 251;

  CSVBUFSIZE=8192;

type
  TkbmProtCustomMemTable = class(TkbmCustomMemTable);
  TkbmProtCommon = class(TkbmCommon);

// General procedures
// ************************************************************

// Code special characters (LF,CR,%,#0)
// CR (#13) -> %c
// LF (#10) -> %n
// #0 -> %0
// % -> %%
function StringToCodedString(const Source:string):string;
var
   i,j:integer;
   l:integer;
begin
     // Count CR/LF.
     l:=0;
     for i:=1 to length(Source) do
         if Source[i] in [#13,#10,'%',#0] then inc(l);

     // If no special characters, return the original string.
     if l=0 then
     begin
          Result:=Source;
          exit;
     end;

     // If any special characters, make room for them.
     SetLength(Result,length(Source)+l);

     // Code special characters.
     j:=1;
     for i:=1 to length(Source) do
         case Source[i] of
              #13: begin
                        Result[j]:='%'; inc(j);
                        Result[j]:='c'; inc(j);
                   end;
              #10: begin
                        Result[j]:='%'; inc(j);
                        Result[j]:='n'; inc(j);
                   end;
              #0:  begin
                        Result[j]:='%'; inc(j);
                        Result[j]:='0'; inc(j);
                   end;
              '%': begin
                        Result[j]:='%'; inc(j);
                        Result[j]:='%'; inc(j);
                   end;
              else
                   begin
                        Result[j]:=Source[i];
                        inc(j);
                   end;
         end;
end;

// Decode special characters (LF,CR,%,#0)
// %c -> CR (#13)
// %n -> LF (#10)
// %% -> %
// %0 -> #0
function CodedStringToString(const Source:string):string;
var
   i,j:integer;
begin
     SetLength(Result,length(Source));

     // Code special characters.
     i:=1;
     j:=1;
     while true do
     begin
          if i>length(Source) then break;
          if Source[i]='%' then
          begin
               inc(i);
               if i>length(Source) then break;
               case Source[i] of
                    'c': Result[j]:=#13;
                    'n': Result[j]:=#10;
                    '%': Result[j]:='%';
                    '0': Result[j]:=#0;
               end;
               inc(j);
          end
          else
          begin
               Result[j]:=Source[i];
               inc(j);
          end;
          inc(i);
     end;

     // Cut result string to right length.
     if i<>j then SetLength(Result,j-1);
end;

// Code a string as BASE 64.
function StringToBase64(const Source:string):string;
var
   Act: Word;
   Bits,I,P,Len: Integer;
begin
     Bits:=0;
     Len:=(Length(Source)*4+2) div 3;
     if Len>0 then
     begin
          SetLength(Result,Len);
	        P:=1;
	        Act:=0;
	        for I:=1 to Pred(Len) do
          begin
	             if Bits<6 then
               begin
	                  Act:=(Act shr 6) or (Ord(Source[P]) shl Bits);
		                Inc(P);
		                Inc(Bits,2);
               end
               else
               begin
	                  Dec(Bits,6);
		                Act:=Act shr 6;
               end;
	             Result[I]:=Char(Act and 63+32);
          end;
	        Result[Len]:=Char(Act shr 6+32);
     end
     else
        Result:='';
end;

// Decode BASE64 string.
function Base64ToString(const Source:string): string;
var
   Act: Word;
   Bits,I,P,Len: Integer;
begin
     Len:=(Length(Source)*3) div 4;
     SetLength(Result,Len);
     Bits:=0;
     Act:=0;
     P:=1;
     for I:=1 to system.Length(Source) do
     begin
          Act:=Act or (Ord(Source[I])-32) shl Bits;
	        if Bits>=2 then
          begin
	             Result[P]:=Char(Act and $FF);
	             Inc(P);
	             Act:=Act shr 8;
	             Dec(Bits,2);
          end
          else
	            Inc(Bits,6);
     end;
end;

// Quote a string.
function QuoteString(const Source:string; Quote:char):string;
begin
     if Quote=#0 then Result:=Source
     else Result:=AnsiQuotedStr(Source,Quote);
end;

// Extract a quoted string.
function ExtractQuoteString(const Source:string; Quote:char):string;
var
   p:PChar;
begin
     p:=PChar(Source);
     if Quote=#0 then Result:=Source
     else Result:=AnsiExtractQuotedStr(p,Quote);
end;

// TKbmCustomCSVStreamFormat
//*******************************************************************

constructor TkbmCustomCSVStreamFormat.Create(AOwner:TComponent);
begin
     inherited;
     FCSVQuote:='"';
     FCSVFieldDelimiter:=',';
     FCSVRecordDelimiter:=',';
     FCSVTrueString:='True';
     FCSVFalseString:='False';
     FsfLocalFormat:=[];
     FsfPlaceHolders:=[];
end;

function TkbmCustomCSVStreamFormat.GetVersion:string;
begin
     Result:='3.00';
end;

procedure TkbmCUstomCSVStreamFormat.Assign(Source:TPersistent);
begin
     if Source is TkbmCustomCSVStreamFormat then
     begin
          CSVQuote:=TkbmCustomCSVStreamFormat(Source).CSVQuote;
          CSVFieldDelimiter:=TkbmCustomCSVStreamFormat(Source).CSVFieldDelimiter;
          CSVRecordDelimiter:=TkbmCustomCSVStreamFormat(Source).CSVRecordDelimiter;
          CSVTrueString:=TkbmCustomCSVStreamFormat(Source).CSVTrueString;
          CSVFalseString:=TkbmCustomCSVStreamFormat(Source).CSVFalseString;
          sfLocalFormat:=TkbmCustomCSVStreamFormat(Source).sfLocalFormat;
          sfPlaceHolders:=TkbmCustomCSVStreamFormat(Source).sfPlaceHolders;
     end;
     inherited;
end;

procedure TkbmCustomCSVStreamFormat.SetCSVFieldDelimiter(Value:char);
begin
     if Value<>#0 then FCSVFieldDelimiter:=Value;
end;

procedure TkbmCustomCSVStreamFormat.BeforeSave(ADataset:TkbmCustomMemTable);
begin
     // Check if trying to save deltas in CSV format. Not supported.
     if sfSaveDeltas in sfDeltas then
        raise EMemTableError.Create(kbmSavingDeltasBinary);

     inherited;

     // Setup standard layout for data.
     Ods:=DateSeparator;
     Oms:=DecimalSeparator;
     Ots:=TimeSeparator;
     Oths:=ThousandSeparator;
     Ocf:=CurrencyFormat;
     Onf:=NegCurrFormat;
     Osdf:=ShortDateFormat;
     Ocs:=CurrencyString;

     if not (sfSaveLocalFormat in FsfLocalFormat) then
     begin
          DateSeparator:='/';
          TimeSeparator:=':';
          ThousandSeparator:=',';
          DecimalSeparator:='.';
          ShortDateFormat:='dd/mm/yyyy';
          CurrencyString:='';
          CurrencyFormat:=0;
          NegCurrFormat:=1;
     end;
end;

procedure TkbmCustomCSVStreamFormat.AfterSave(ADataset:TkbmCustomMemTable);
begin
     // Restore locale setup.
     DateSeparator:=Ods;
     DecimalSeparator:=Oms;
     TimeSeparator:=Ots;
     ThousandSeparator:=Oths;
     CurrencyFormat:=Ocf;
     NegCurrFormat:=Onf;
     ShortDateFormat:=Osdf;
     CurrencyString:=Ocs;

     inherited;
end;

procedure TkbmCustomCSVStreamFormat.SaveDef(ADataset:TkbmCustomMemTable);
var
   i,l:integer;
   nf:integer;
   s:string;
begin
     if not (sfSaveDef in sfDef) then exit;

     with TkbmProtCustomMemTable(ADataSet) do
     begin
          // Setup flags for fields to save.
          nf:=Fieldcount;

{$IFNDEF CSV_FILE_1XX_COMPATIBILITY}
          // Write file version.
          s:=QuoteString(PChar(kbmFileVersionMagic),FCSVQuote)+FCSVFieldDelimiter+QuoteString(IntToStr(kbmCSVFileVersion),FCSVQuote)+#13+#10;
          l:=length(s);
          WorkStream.WriteBuffer(Pointer(s)^, l);
{$ENDIF}

          // Write header.
          s:=QuoteString(PChar(kbmTableDefMagicStart),FCSVQuote)+#13+#10;
          l:=length(s);
          WorkStream.WriteBuffer(Pointer(s)^, l);

          // Write fielddefinitions.
          for i:=0 to nf-1 do
          begin
               if (SaveFields[i]>=0) or (sfSavePlaceHolders in sfPlaceHolders) then
               begin
                    s:=Fields[i].FieldName+'='+
                        FieldTypeNames[Fields[i].DataType]+','+
                        inttostr(Fields[i].Size)+','+
                        QuoteString(Fields[i].DisplayName,'"')+','+
                        QuoteString(Fields[i].EditMask,'"')+','+
                        inttostr(Fields[i].DisplayWidth);
                    if Fields[i].Required then s:=s+',REQ';
                    if Fields[i].ReadOnly then s:=s+',RO';
                    if sfSaveFieldKind in sfFieldKind then
                       s:=s+','+FieldKindNames[ord(Fields[i].FieldKind)]
                    else
                        s:=s+','+FieldKindNames[0];
{$IFDEF LEVEL4}
                    s:=s+','+QuoteString(Fields[i].DefaultExpression,'"');
{$ENDIF}
                    s:=QuoteString(PChar(s),FCSVQuote)+#13+#10;
                    l:=length(s);
                    WorkStream.WriteBuffer(Pointer(s)^, l);
               end;
          end;

{$IFNDEF CSV_FILE_1XX_COMPATIBILITY}
          // Check if to write index definitions.
          if sfSaveIndexDef in sfIndexDef then
          begin
               // Write header.
               s:=QuoteString(PChar(kbmIndexDefMagicStart),FCSVQuote)+#13+#10;
               l:=length(s);
               WorkStream.WriteBuffer(Pointer(s)^, l);

               // Write indexdefinitions.
               for i:=0 to IndexDefs.count-1 do
                   with IndexDefs.Items[i] do
                   begin
                        s:=Name+'='+
                           QuoteString(Fields,FCSVQuote)+','+
{$IFDEF LEVEL3}
                           Name;
{$ELSE}
                           QuoteString(DisplayName,FCSVQuote);
{$ENDIF}
                        if ixDescending in Options then s:=s+',DESC';
                        if ixCaseInsensitive in Options then s:=s+',CASE';
{$IFNDEF LEVEL3}
                        if ixNonMaintained in Options then s:=s+',NONMT';
{$ENDIF}
                        if ixUnique in Options then s:=s+',UNIQ';
                        s:=QuoteString(PChar(s),FCSVQuote)+#13+#10;
                        l:=length(s);
                        WorkStream.WriteBuffer(Pointer(s)^, l);
                   end;

               // Write footer.
               s:=QuoteString(PChar(kbmIndexDefMagicEnd),FCSVQuote)+#13+#10;
               l:=length(s);
               WorkStream.WriteBuffer(Pointer(s)^, l);
          end;
{$ENDIF}

          // Write footer.
          s:=QuoteString(PChar(kbmTableDefMagicEnd),FCSVQuote)+#13+#10;
          l:=length(s);
          WorkStream.WriteBuffer(Pointer(s)^, l);
     end;
end;

procedure TkbmCustomCSVStreamFormat.SaveData(ADataset:TkbmCustomMemTable);
var
   i,j,l:integer;
   nf:integer;
   s,s1,a:string;
   Accept:boolean;
   null:boolean;
begin
     with TkbmProtCustomMemTable(ADataSet) do
     begin
          FSaveCount:=0;

          // Setup flags for fields to save.
          nf:=Fieldcount;

          // Save header.
          if not (sfSaveNoHeader in sfNoHeader) then
          begin
               // Write all field display names in CSV format.
               s:='';
               a:='';
               for i:=0 to nf-1 do
               begin
                    if (SaveFields[i]>=0) or (sfSavePlaceHolders in sfPlaceHolders) then
                    begin
                         s:=s+a+QuoteString(PChar(Fields[i].DisplayName),FCSVQuote);
                         a:=FCSVFieldDelimiter;
                    end;
               end;
               if FCSVRecordDelimiter <> #0 then s:=s+FCSVRecordDelimiter;
               s:=s+#13+#10;
               l:=length(s);
               WorkStream.Write(Pointer(s)^, l);
          end;

          // Write all records in CSV format ordered by current index.
          if sfSaveData in sfData then
          begin
               try
                  FSavedCompletely:=true;
                  for j:=0 to CurIndex.References.Count-1 do
                  begin
                       // Check if to save more.
                       if (FSaveLimit>0) and (FSaveCount>=FSaveLimit) then
                       begin
                            FSavedCompletely:=false;
                            break;
                       end;

                       // Check if to invoke progress event if any.
                       if (j mod 100)=0 then Progress(trunc((j/CurIndex.References.count)*100),mtpcSave);

                       // Setup which record to work on.
                       OverrideActiveRecordBuffer:=PkbmRecord(CurIndex.References.Items[j]);
                       if OverrideActiveRecordBuffer=nil then continue;

                       // Calculate fields.
                       ClearCalcFields(PChar(OverrideActiveRecordBuffer));
                       GetCalcFields(PChar(OverrideActiveRecordBuffer));

                       // Check filter of record.
                       Accept:=FilterRecord(OverrideActiveRecordBuffer,false);
                       if not Accept then continue;

                       // Check if to accept that record for save.
                       Accept:=true;
                       if Assigned(OnSaveRecord) then OnSaveRecord(ADataset,Accept);
                       if not Accept then continue;

                       // Write current record.
                       s:='';
                       a:='';
                       for i:=0 to nf-1 do
                       begin
                            if SaveFields[i]>=0 then
                            begin
                                 if Assigned(OnSaveField) then OnSaveField(ADataset,i,Fields[i]);

                                 if (Fields[i].IsNull) then s1:=''
                                 else if Fields[i].DataType in kbmStringTypes then
                                     s1:=StringToCodedString(Fields[i].AsString)
                                 else if Fields[i].DataType in kbmBinaryTypes then
                                     s1:=StringToBase64(Fields[i].AsString)
{$IFDEF LEVEL6}
                                 else if Fields[i].DataType=ftWideString then
                                     s1:=UTF8Encode(Fields[i].Value)
{$ENDIF}
                                 else if Fields[i].DataType=ftBoolean then
                                 begin
                                      with TBooleanField(Fields[i]) do
                                           if Value then
                                              s1:=FCSVTrueString
                                           else
                                               s1:=FCSVFalseString;
                                      end
                                 else
                                     s1:=Fields[i].AsString;

                                 null:=Fields[i].IsNull;
                                 if assigned(FOnFormatSaveField) then
                                    FOnFormatSaveField(self,Fields[i],null,s1);

                                 if null then
                                    s:=s+a
                                 else if ((sfSaveQuoteOnlyStrings in sfQuoteOnlyStrings) and
                                          (not (Fields[i].DataType in kbmStringTypes+kbmBinaryTypes))) then
                                    s:=s+a+s1
                                 else
                                    s:=s+a+QuoteString(s1,FCSVQuote);
                                 a:=FCSVFieldDelimiter;
                            end
                            else if sfSavePlaceHolders in sfPlaceHolders then
                            begin
                                 s:=s+a;
                                 a:=FCSVFieldDelimiter;
                            end;
                       end;

                       // Add record delimiter.
                       if FCSVRecordDelimiter <> #0 then s:=s+FCSVRecordDelimiter;
                       s:=s+#13+#10;
                       l:=length(s);

                       // Write line.
                       WorkStream.WriteBuffer(Pointer(s)^, l);

                       // Increment savecounter.
                       inc(FSaveCount);
                  end;

               finally
                  OverrideActiveRecordBuffer:=nil;
               end;
          end;
     end;
end;

function TkbmCustomCSVStreamFormat.GetChunk:boolean;
begin
     remaining_in_buf:=WorkStream.Read(pointer(buf)^,CSVBUFSIZE);
     bufptr:=buf;
     Result:=remaining_in_buf>0;

     // Show progress.
     inc(ProgressCnt);
     ProgressCnt:=ProgressCnt mod 100;
     if (ProgressCnt=0) then
         FDataset.Progress(trunc((WorkStream.Position / StreamSize) * 100),mtpcLoad);
end;

function TkbmCustomCSVStreamFormat.GetLine:boolean;
var
  EOL,EOF:boolean;
  ep,sp:PChar;
  TmpStr:string;
begin
     // Cut out a line.
     EOL:=false;
     EOF:=false;
     Line:='';
     sp:=bufptr;
     ep:=bufptr;
     while true do
     begin
          // Check if need another chunk.
          if remaining_in_buf=0 then
          begin
               // Add to line.
               if EOL then
                  SetString(TmpStr,sp,ep-sp+1)
               else
                  SetString(TmpStr,sp,bufptr-sp);
               Line:=Line+TmpStr;

               // Check if EOF.
               if not GetChunk then
               begin
                    EOF:=true;
                    break;
               end;
               sp:=bufptr;
               ep:=bufptr-1;
          end;

          // Check if we got EOL character, skip them and finally break.
          if (bufptr^) in [#0, #10, #13] then
          begin
               if not EOL then ep:=bufptr-1;
               EOL:=true
          end
          else if EOL then
          begin
               SetString(TmpStr,sp,ep-sp+1);
               Line:=Line+TmpStr;
               break;
          end;

          // Prepare to look at next char.
          Inc(bufptr);
          dec(remaining_in_buf);
     end;

     lptr:=PChar(Line);
     elptr:=PChar(Line)+Length(Line);
     Result:=(not EOF);
end;

function TkbmCustomCSVStreamFormat.GetWord(var null:boolean):string;
type
    tfsmstate=(stStart,stQuote,stText,stDelim);
var
   sptr:PChar;
   TmpStr:string;
   l:integer;
   state: tfsmstate;
begin
    Result:='';

    // Check if parsing without quote.
    if FCSVQuote=#0 then
    begin
         sptr:=lptr;
         while (lptr^ <> FCSVFieldDelimiter) and (lptr^ <> FCSVRecordDelimiter) and (lptr<elptr) do inc(lptr);
         l:=lptr-sptr;
         if (lptr>=elptr) then inc(l); // Allow for missing fieldseperator/recordseperator at end of line.
         if (lptr^ = #0) then dec(l);
         SetString(Result,sptr,l);
         null:=(length(Result)<=0);
         if (lptr^=FCSVFieldDelimiter) or (lptr^=FCSVRecordDelimiter) then inc(lptr);
    end
    else
    begin
         sptr:=lptr;
         state:=stStart;
         null:=false;
         while state<>stDelim do
         begin
             if (lptr>=elptr) then
             begin
                  if state=stText then
                  begin
                       SetString(TmpStr,sptr,lptr-sptr);
                       Result:=Result+TmpStr;
                  end;
                  exit;
             end;

             case state of
               stStart:
                 if lptr^=FCSVQuote then
                 begin
                      state:=stQuote;
                      inc(sptr);
                 end
                 else if lptr^=FCSVFieldDelimiter then
                 begin
                      state:=stDelim;
                      null:=true;
                 end
                 else
                     state:=stText;

               stText:
                 if lptr^=FCSVFieldDelimiter then
                 begin
                      SetString(TmpStr,sptr,lptr-sptr);
                      sptr:=lptr;
                      Result:=Result+TmpStr;
                      state:=stDelim;
                 end;

               stQuote:
                 if lptr^=FCSVQuote then
                 begin
                      // Either got endquote or got double quote.
                      SetString(TmpStr,sptr,lptr-sptr);
                      Result:=Result+TmpStr;
                      inc(lptr);
                      if lptr^=FCSVQuote then
                         Result:=Result+FCSVQuote
                      else
                         state:=stDelim;
                      sptr:=lptr;
                      inc(sptr);
                 end;
             end;

             inc(lptr);
         end;
    end;
end;

{
function TkbmCustomCSVStreamFormat.GetWord(var null:boolean):string;
type
    tfsmstate=(stStart,stQuote,stText,stDelim);
var
   sptr:PChar;
   TmpStr:string;
   l:integer;
   state: tfsmstate;
begin
    Result:='';

    // Check if parsing without quote.
    if FCSVQuote=#0 then
    begin
         sptr:=lptr;
         while (lptr^ <> FCSVFieldDelimiter) and (lptr^ <> FCSVRecordDelimiter) and (lptr<elptr) do inc(lptr);
         l:=lptr-sptr;
         if (lptr>=elptr) then inc(l); // Allow for missing fieldseperator/recordseperator at end of line.
         SetString(Result,sptr,l);
         null:=(length(Result)<=0);
         if (lptr^=FCSVFieldDelimiter) or (lptr^=FCSVRecordDelimiter) then inc(lptr);
    end
    else
    begin
         sptr:=lptr;
         state:=stStart;
         null:=false;
         while state<>stDelim do
         begin
             if (lptr>=elptr) then exit;

             case state of
               stStart:
                 case lptr^ of
                      '"': begin
                                state:=stQuote;
                                inc(sptr);
                           end;
                      ',': begin
                                state:=stDelim;
                                null:=true;
                           end;
                      else
                           state:=stText;
                 end;

               stText:
                 case lptr^ of
                      ',': begin
                                SetString(TmpStr,sptr,lptr-sptr);
                                Result:=Result+TmpStr;
                                state:=stDelim;
                           end;
                 end;

               stQuote:
                 case lptr^ of
                      '"': begin
                                SetString(TmpStr,sptr,lptr-sptr);
                                Result:=Result+TmpStr;
                                inc(lptr);
                                if lptr^ <> '"' then state:=stDelim;
                           end;
                 end;
             end;

             inc(lptr);
         end;
    end;
end;
}

{
function TkbmCustomCSVStreamFormat.GetWord(var null:boolean):string;
label
  L_exit;
var
  sptr:PChar;
  TmpStr:string;
  l:integer;
begin

  // Cut out next word.
  Result:='';

  // Check if parsing without quote.
  if FCSVQuote=#0 then
  begin
       sptr:=lptr;
       while (lptr<elptr) and (not (lptr^ in [FCSVFieldDelimiter,FCSVRecordDelimiter])) do inc(lptr);
       l:=lptr-sptr;
       if (lptr>elptr) then inc(l); // Allow for missing fieldseperator/recordseperator at end of line.
       SetString(Result,sptr,l);
       null:=(length(Result)<=0);
       if (lptr<elptr) and (lptr^ in [FCSVFieldDelimiter,FCSVRecordDelimiter]) then inc(lptr);
  end
  else
  begin
       // Look for starting CSVQuote or CSVFieldDelimiter
       while (lptr^ <> FCSVQuote) and (lptr^ <> FCSVFieldDelimiter) and (lptr^ <> FCSVRecordDelimiter) and (lptr<elptr) do inc(lptr);
       if (lptr>=elptr) then exit;
       if (lptr^ = FCSVFieldDelimiter) or (lptr^ = FCSVRecordDelimiter) then
       begin
            null:=true;
            inc(lptr);
            exit;
       end
       else null:=false;
       inc(lptr);

       while true do
       begin
            // Look for ending ".
            sptr:=lptr;
            while not (lptr^ = FCSVQuote) do
            begin
                 if (lptr>=elptr) then goto L_exit;
                 inc(lptr);
            end;
            SetString(TmpStr,sptr,lptr-sptr);
            Result:=Result+TmpStr;
            inc(lptr);

            // Is it a double "" or end of word ?.
            if (lptr^ = FCSVQuote) then
            begin
                 Result:=Result+FCSVQuote;
                 inc(lptr);
                 continue;
            end;

L_exit:
            inc(lptr);
            break;
       end;
  end;
end;
}

procedure TkbmCustomCSVStreamFormat.BeforeLoad(ADataset:TkbmCustomMemTable);
begin
     FDefLoaded:=false;
     inherited;

     // Allocate space for a buffer.
     GetMem(buf,CSVBUFSIZE);

     // Still nothing in the buffer to handle.
     FDataset:=ADataset;
     remaining_in_buf:=0;
     StreamSize:=WorkStream.Size;
     ProgressCnt:=0;

     // Setup standard layout for data.
     Ods:=DateSeparator;
     Oms:=DecimalSeparator;
     Ots:=TimeSeparator;
     Oths:=ThousandSeparator;
     Ocf:=CurrencyFormat;
     Onf:=NegCurrFormat;
     Osdf:=ShortDateFormat;
     Ocs:=CurrencyString;

     // Check if to load in local format.
     if not (sfLoadLocalFormat in sfLocalFormat) then
     begin
          DateSeparator:='/';
          TimeSeparator:=':';
          ThousandSeparator:=',';
          DecimalSeparator:='.';
          ShortDateFormat:='dd/mm/yyyy';
          CurrencyString:='';
          CurrencyFormat:=0;
          NegCurrFormat:=1;
     end;
end;

procedure TkbmCustomCSVStreamFormat.AfterLoad(ADataset:TkbmCustomMemTable);
begin
     DateSeparator:=Ods;
     DecimalSeparator:=Oms;
     TimeSeparator:=Ots;
     ThousandSeparator:=Oths;
     CurrencyFormat:=Ocf;
     NegCurrFormat:=Onf;
     ShortDateFormat:=Osdf;
     CurrencyString:=Ocs;

     FreeMem(buf);

     inherited;
end;

procedure TkbmCustomCSVStreamFormat.DetermineLoadFieldIDs(ADataset:TkbmCustomMemTable; AList:TStringList; Situation:TkbmDetermineLoadFieldsSituation);
var
   s:string;
   null:boolean;
begin
     // Dont try to get fields display names if def not yet loaded.
     if (Situation<>dlfAfterLoadDef) or (Line='') or (sfLoadNoHeader in sfNoHeader) then
     begin
          inherited;
          exit;
     end;

     // Determine which fields is present in the stream.
     // Line has already been populated by LoadDef.
     with TkbmProtCustomMemTable(ADataSet) do
     begin
          AList.Clear;
          lptr:=PChar(Line);
          while (lptr<elptr) do
          begin
               // Get DisplayName for field.
               s:=GetWord(null);
               AList.Add(s);
          end;
     end;
end;

procedure TkbmCUstomCSVStreamFormat.DetermineLoadFieldIndex(ADataset:TkbmCustomMemTable; ID:string; FieldCount:integer; OrigIndex:integer; var NewIndex:integer; Situation:TkbmDetermineLoadFieldsSituation);
var
   i:integer;
   s:string;
begin
     // If determined not to load field, dont.
     if (Situation<>dlfAfterLoadDef) then exit;

     // Dont want to worry about case.
     s:=UpperCase(ID);

     // Find Field index in dataset
     for i:=0 to ADataset.FieldCount-1 do
     begin
          if (UpperCase(ADataset.Fields[i].DisplayName)=s) then
          begin
               NewIndex:=i;
               exit;
          end;
     end;

     NewIndex:=-1;
end;

procedure TkbmCustomCSVStreamFormat.LoadDef(ADataset:TkbmCustomMemTable);
var
   ld,ldidx:boolean;
   i:integer;
   slist:TStringList;
   DuringTableDef,DuringIndexDef:boolean;
   null:boolean;
   FName,KName,TName,DName,EMask,DExpr:string;
   FSize,DSize:integer;
   REQ,RO,INV,CASEIN,{$IFNDEF LEVEL3}NONMT,{$ENDIF}DESC,UNIQ:boolean;
   FT:TFieldType;
   FK:TFieldKind;
   FFields:string;
   ioptions:TIndexOptions;
begin
     if (StreamSize = 0) then exit;
     ld:=sfLoadDef in sfDef;
     ldidx:=sfLoadIndexDef in sfIndexDef;

     with TkbmProtCustomMemTable(ADataSet) do
     begin
          // Read all definition lines in CSV format.
          slist:=TStringList.Create;
          DuringTableDef:=false;
          DuringIndexDef:=false;
          try
             while true do
             begin
                  GetLine;
                  if Line='' then break;

                  // Read magic words if any.
                  Word:=GetWord(null);

{$IFNDEF CSV_FILE_1XX_COMPATIBILITY}
                  if Word=kbmFileVersionMagic then
                  begin
                       Word:=GetWord(null);
//                     FileVersion:=StrToInt(Word);
                       continue;
                  end
                  else
{$ENDIF}

                  if Word=kbmTableDefMagicStart then
                  begin
                       DuringTableDef:=true;
                       if ld then
                       begin
                            Close;
                            FieldDefs.clear;
                            DeleteTable;
                       end;
                       continue;
                  end

                  // End of table definition?
                  else if Word=kbmTableDefMagicEnd then
                  begin
                       DuringTableDef:=false;
                       Open;
                       continue;
                  end

                  // Start of index definitions?
                  else if Word=kbmIndexDefMagicStart then
                  begin
                       if ld and ldidx then
                       begin
                            DestroyIndexes;
                            IndexDefs.Clear;
                       end;
                       DuringIndexDef:=true;
                       continue;
                  end

                  // End of index definitions?
                  else if Word=kbmIndexDefMagicEnd then
                  begin
                       DuringIndexDef:=false;
                       if ld and ldidx then CreateIndexes;
                       continue;
                  end;

                  // If not during table definitions then its the header. Break.
                  if not DuringTableDef then break;

                  // If its an index definition.
                  if DuringIndexDef then
                  begin
                       if ld and ldidx then
                       begin
                            Line:=ExtractQuoteString(Line,FCSVQuote);
                            i:=pos('=',Line);
                            slist.CommaText:=copy(Line,i+1,length(Line));
                            FName:=copy(Line,1,i-1);
                            FFields:=slist.Strings[0];
                            DName:=slist.Strings[1];
                            CASEIN:=pos(',CASE',Line)<>0;
{$IFNDEF LEVEL3}
                            NONMT:=pos(',NONMT',Line)<>0;
{$ENDIF}
                            DESC:=pos(',DESC',Line)<>0;
                            UNIQ:=pos(',UNIQ',Line)<>0;

                            // Add field definition.
                            ioptions:=[];
                            if CASEIN then ioptions:=ioptions+[ixCaseInSensitive];
                            if DESC then ioptions:=ioptions+[ixDescending];
                            if UNIQ then ioptions:=ioptions+[ixUnique];
{$IFNDEF LEVEL3}
                            if NONMT then ioptions:=ioptions+[ixNonMaintained];
                            with IndexDefs.AddIndexDef do
                            begin
                                 Name:=FName;
                                 Fields:=FFields;
                                 Options:=ioptions;
                                 DisplayName:=DName;
                            end;
{$ELSE}
                            IndexDefs.Add(FName,FFields,ioptions);
{$ENDIF}
                       end;
                       continue;
                  end;

                  // Otherwise its a field definition. Break the line apart.
                  if ld then
                  begin
                       Line:=ExtractQuoteString(Line,FCSVQuote);
                       i:=pos('=',Line);
                       slist.CommaText:=copy(Line,i+1,length(Line));
                       FName:=copy(Line,1,i-1);
                       TName:=slist.Strings[0];
                       FSize:=strtoint(slist.Strings[1]);
                       DName:=slist.Strings[2];
                       EMask:=slist.Strings[3];
                       DSize:=strtoint(slist.Strings[4]);
                       REQ:=pos(',REQ',Line)<>0;
                       RO:=pos(',RO',Line)<>0;
                       INV:=pos(',INV',Line)<>0;
                       i:=slist.Count;
                       DExpr:='';
                       if i>6 then
                       begin
                            DExpr:=slist.Strings[i-1];
                            dec(i);
                       end;
                       if i>5 then
                          KName:=slist.Strings[i-1]
                       else
                           KName:=FieldKindNames[0]; // fkData.

                       // Find fieldtype from fieldtypename.
                       for i:=0 to ord(High(FieldTypeNames)) do
                           if FieldTypeNames[TFieldType(i)]=TName then break;
                       FT:=TFieldType(i);
                       if not (FT in kbmSupportedFieldTypes) then
                          raise EMemTableError.Create(Format(kbmUnknownFieldErr1+kbmUnknownFieldErr2,[TName,Word]));

                       // Check if autoinc field in stream, use data from stream.
                       if FT=ftAutoInc then
                          SetIgnoreAutoIncPopulation(ADataset,true);

                       // If fieldkind specified, find fieldkind.
                       FK:=fkData;
                       for i:=0 to ord(High(FieldKindNames)) do
                           if FieldKindNames[i]=KName then
                           begin
                                FK:=TFieldKind(i);
                                break;
                           end;

                       // Add field definition.
                       FieldDefs.Add(FName,FT,FSize,REQ);

                       // Setup other properties.
                       i:=FieldDefs.IndexOf(FName);
                       with FieldDefs.Items[i].CreateField(ADataset) do
                       begin
                            FieldKind:=FK;
                            DisplayLabel:=DName;
                            EditMask:=EMask;
                            ReadOnly:=RO;
                            DisplayWidth:=DSize;
{$IFDEF LEVEL4}
                            DefaultExpression:=DExpr;
{$ENDIF}
                            Visible:=not INV;
                       end;
                  end;
             end;
          finally
             slist.free;
          end;
     end;
     FDefLoaded:=true;
end;

procedure TkbmCustomCSVStreamFormat.LoadData(ADataset:TkbmCustomMemTable);
var
   i,j:integer;
   nf:integer;
   null:boolean;
   s:string;
   Accept:boolean;
   LoadLine:boolean;
begin
     if (StreamSize = 0) then exit;
     if not (sfLoadData in sfData) then exit;

     // Check if data line already loaded.
     LoadLine:=not (sfLoadNoHeader in sfNoHeader);
     lptr:=PChar(Line);            // Make sure word pointer is at start of line.

     with TkbmProtCustomMemTable(ADataSet) do
     begin
          ResetAutoInc;

          // Read all lines in CSV format.
          FLoadCount:=0;
          FLoadedCompletely:=true;
          while true do
          begin
               if (FLoadLimit>0) and (FLoadCount>=FLoadLimit) then
               begin
                    FLoadedCompletely:=false;
                    break;
               end;

               if LoadLine then GetLine;
               LoadLine:=true;
               if Line='' then break;

               append;

               i:=0;
{$IFDEF LEVEL4}
               nf:=length(LoadFields);
{$ELSE}
               nf:=LoadFieldsCount;
{$ENDIF}
               while (lptr<elptr) and (i<nf) do
               begin
                    j:=LoadFields[i];
                    s:=GetWord(null);
                    if j>=0 then
                    begin
                         if not (sfLoadFieldKind in sfFieldKind) then
                         begin
                              if Fields[j].FieldKind<>fkData then
                              begin
                                   inc(i);
                                   continue;
                              end;
                         end;

                         if assigned(FOnFormatLoadField) then
                            FOnFormatLoadField(self,Fields[j],null,s);

                         if null then
                             Fields[j].Clear
                         else if Fields[j].DataType in kbmStringTypes then
                             Fields[j].AsString:=CodedStringToString(s)
                         else if Fields[j].DataType in kbmBinaryTypes then
                             Fields[j].AsString:=Base64ToString(s)
{$IFDEF LEVEL6}
                         else if Fields[j].DataType=ftWideString then
                              Fields[j].Value:=UTF8Decode(s)
{$ENDIF}
                         else if Fields[j].DataType = ftBoolean then
                              with TBooleanField(Fields[j]) do
                              begin
                                   if s=FCSVTrueString then
                                      Value:=true
                                   else
                                       Value:=false;
                              end
                         else
                             Fields[j].AsString:=s;

                         if Assigned(OnLoadField) then OnLoadField(ADataSet,j,Fields[j]);
                    end;
                    inc(i);
               end;

               Accept:=true;
               if Assigned(OnLoadRecord) then OnLoadRecord(ADataset,Accept);
               if Accept then
               begin
                    Post;
                    inc(FLoadCount);
               end
               else
                    Cancel;
          end;
     end;
end;

// -----------------------------------------------------------------------------------
// Registration for Delphi 3 / C++ Builder 3
// -----------------------------------------------------------------------------------

{$ifdef LEVEL3}
procedure Register;
begin
     RegisterComponents('kbmMemTable', [TkbmCSVStreamFormat]);
end;
{$endif}

end.

