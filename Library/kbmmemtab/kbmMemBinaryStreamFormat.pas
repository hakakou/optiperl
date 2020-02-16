unit kbmMemBinaryStreamFormat;

interface

{$include kbmMemTable.inc}

// =========================================================================
// Binary stream format for kbmMemTable v. 3.xx+
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
//            kbm@optical.dk
//
// Latest version can be found at:
//            http://www.onelist.com/community/memtable

//=============================================================================
// Remove the remark on the next lines if to keep binary file compatibility
// between different versions of TkbmMemTable.
//{$define BINARY_FILE_230_COMPATIBILITY}
//{$define BINARY_FILE_200_COMPATIBILITY}
//{$define BINARY_FILE_1XX_COMPATIBILITY}
//=============================================================================

// History.
// Per v. 3.00, the stream formats will each have their own history.
//
// 3.00a alpha
//       Initial v. 3.00 binary stream format release based on the sources of v. 2.53b.
//
// 3.00b beta
//       Fixed Floating point error in calculation of progress.
//       Bug reported by Fred Schetterer (yahoogroups@shaw.ca)
//
// 3.00c beta
//       Fixed bug not setting record flag to record being part of table.
//       This would result in massive memory leaks.
//
// 3.00  Final
//       Added BufferSize property (default 16384) which controls the internal
//       read and write buffer size. Suggested by Ken Schafer (prez@write-brain.com)

uses
  kbmMemTable,Classes,DB,
{$include kbmMemRes.inc}
  SysUtils;

type
  TkbmStreamFlagUsingIndex  = (sfSaveUsingIndex);
  TkbmStreamFlagUsingIndexs = set of TkbmStreamFlagUsingIndex;

  TkbmStreamFlagDataTypeHeader = (sfSaveDataTypeHeader,sfLoadDataTypeHeader);
  TkbmStreamFlagDataTypeHeaders = set of TkbmStreamFlagDataTypeHeader;

  TkbmCustomBinaryStreamFormat = class(TkbmCustomStreamFormat)
  private
     Writer:TWriter;
     Reader:TReader;

     FUsingIndex:TkbmStreamFlagUsingIndexs;
     FDataTypeHeader:TkbmStreamFlagDataTypeHeaders;
     FBuffSize:LongInt;

     FileVersion:integer;
     InitIndexDef:boolean;

     ProgressCnt:integer;
     StreamSize:longint;
     procedure SetBuffSize(ABuffSize:LongInt);
  protected
     function GetVersion:string; override;

     procedure BeforeSave(ADataset:TkbmCustomMemTable); override;
     procedure SaveDef(ADataset:TkbmCustomMemTable); override;
     procedure SaveData(ADataset:TkbmCustomMemTable); override;
     procedure AfterSave(ADataset:TkbmCustomMemTable); override;

     procedure BeforeLoad(ADataset:TkbmCustomMemTable); override;
     procedure LoadDef(ADataset:TkbmCustomMemTable); override;
     procedure LoadData(ADataset:TkbmCustomMemTable); override;
     procedure AfterLoad(ADataset:TkbmCustomMemTable); override;

     procedure DetermineLoadFieldIndex(ADataset:TkbmCustomMemTable; ID:string; FieldCount:integer; OrigIndex:integer; var NewIndex:integer; Situation:TkbmDetermineLoadFieldsSituation); override;
     
     property sfUsingIndex:TkbmStreamFlagUsingIndexs read FUsingIndex write FUsingIndex;
     property sfDataTypeHeader:TkbmStreamFlagDataTypeHeaders read FDataTypeHeader write FDataTypeHeader;
     property BufferSize:LongInt read FBuffSize write SetBuffSize;
  public
     constructor Create(AOwner:TComponent); override;
  end;

  TkbmBinaryStreamFormat = class(TkbmCustomBinaryStreamFormat)
  published
     property Version;
     property sfUsingIndex;
     property sfData;
     property sfCalculated;
     property sfLookup;
     property sfNonVisible;
     property sfBlobs;
     property sfDef;
     property sfIndexDef;
     property sfFiltered;
     property sfIgnoreRange;
     property sfIgnoreMasterDetail;
     property sfDeltas;
     property sfDontFilterDeltas;
     property sfAppend;
     property sfFieldKind;
     property sfFromStart;
     property sfDataTypeHeader;

     property OnBeforeLoad;
     property OnAfterLoad;
     property OnBeforeSave;
     property OnAfterSave;
     property OnCompress;
     property OnDeCompress;

     property BufferSize;
  end;

{$ifdef LEVEL3}
procedure Register;
{$endif}

implementation

const
  // Binary file magic word.
  kbmBinaryMagic = '@@BINARY@@';

  // Current file versions. V. 1.xx file versions are considered 100, 2.xx are considered 2xx etc.
  kbmBinaryFileVersion = 251;
  kbmDeltaVersion = 200;

type
  TkbmProtCustomMemTable = class(TkbmCustomMemTable);
  TkbmProtCommon = class(TkbmCommon);

function TkbmCustomBinaryStreamFormat.GetVersion:string;
begin
     Result:='3.00';
end;

constructor TkbmCustomBinaryStreamFormat.Create(AOwner:TComponent);
begin
     inherited;
     FUsingIndex:=[sfSaveUsingIndex];
     FDataTypeHeader:=[sfSaveDataTypeHeader,sfLoadDataTypeHeader];
     FBuffSize:=16384;
end;

procedure TkbmCustomBinaryStreamFormat.SetBuffSize(ABuffSize:LongInt);
begin
     if ABuffSize<16384 then ABuffSize:=16384;
     FBuffSize:=ABuffSize;
end;

procedure TkbmCustomBinaryStreamFormat.BeforeSave(ADataset:TkbmCustomMemTable);
begin
     inherited;

     Writer:=TWriter.Create(WorkStream,FBuffSize);
     Writer.WriteSignature;

{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
     Writer.WriteInteger(kbmBinaryFileVersion);
{$ENDIF}
end;

procedure TkbmCustomBinaryStreamFormat.AfterSave(ADataset:TkbmCustomMemTable);
begin
     Writer.FlushBuffer;
     Writer.Free;
     Writer:=nil;

     TkbmProtCustomMemTable(ADataset).FOverrideActiveRecordBuffer:=nil;

     inherited;
end;

procedure TkbmCustomBinaryStreamFormat.SaveDef(ADataset:TkbmCustomMemTable);
var
   i:integer;
   nf:integer;
begin
     // Write field definitions
     with TkbmProtCustomMemTable(ADataset) do
     begin
          // Write fielddefinitions.
          nf:=FieldCount;

          Writer.WriteListBegin;
          if (sfSaveDef in sfDef) then
          begin
               for i:=0 to nf-1 do
               begin
                    if SaveFields[i]>=0 then
                    begin
                         Writer.WriteString(Fields[i].FieldName);
                         Writer.WriteString(FieldTypeNames[Fields[i].DataType]);
                         Writer.WriteInteger(Fields[i].Size);
                         Writer.WriteString(Fields[i].DisplayName);
                         Writer.WriteString(Fields[i].EditMask);
                         Writer.WriteInteger(Fields[i].DisplayWidth);
                         Writer.WriteBoolean(Fields[i].Required);
                         Writer.WriteBoolean(Fields[i].ReadOnly);

                         // New for 2.50i BinaryFileVersion 250
                         if sfSaveFieldKind in sfFieldKind then
                            Writer.WriteString(FieldKindNames[ord(Fields[i].FieldKind)])
                         else
                             Writer.WriteString(FieldKindNames[0]); //fkData.

                         // New for 2.50o2 BinaryFileVersion 251
{$IFDEF LEVEL4}
                         Writer.WriteString(Fields[i].DefaultExpression);
{$ELSE}
                         Writer.WriteString('');
{$ENDIF}
                    end;
               end;
          end;
          Writer.WriteListEnd;

{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
          // Save index definitions.
          Writer.WriteListBegin;
          if sfSaveIndexDef in sfIndexDef then
          begin
               for i:=0 to FIndexDefs.Count-1 do
                   with FIndexDefs.Items[i] do
                   begin
                        Writer.WriteString(Name);
                        Writer.WriteString(Fields);
{$IFNDEF LEVEL3}
                        Writer.WriteString(DisplayName);
{$ELSE}
                        Writer.WriteString(Name);
{$ENDIF}
                        Writer.WriteBoolean(ixDescending in Options);
                        Writer.WriteBoolean(ixCaseInSensitive in Options);
{$IFNDEF LEVEL3}
                        Writer.WriteBoolean(ixNonMaintained in Options);
{$ELSE}
                        Writer.WriteBoolean(false);
{$ENDIF}
                        Writer.WriteBoolean(ixUnique in Options);
                   end;
          end;
          Writer.WriteListEnd;
{$ENDIF}
     end;
end;

procedure TkbmCustomBinaryStreamFormat.SaveData(ADataset:TkbmCustomMemTable);
var
   i,j,cnt:integer;
   nf:integer;
   Accept:boolean;
   NewestVersion:boolean;
   pRec:PkbmRecord;
   UsingIndex:boolean;
begin
     with TkbmProtCustomMemTable(ADataset) do
     begin
          // Write fielddefinitions.
          nf:=FieldCount;

          // Write datatypes as a kind of header.
          if sfSaveDataTypeHeader in sfDataTypeHeader then
          begin
               // Count number of fields actually saved.
               j:=0;
               for i:=0 to nf-1 do
                   if SaveFields[i]>=0 then inc(j);

               // Start writing header.
               Writer.WriteListBegin;
               Writer.WriteInteger(j);
               for i:=0 to nf-1 do
               begin
                    if SaveFields[i]>=0 then
                       Writer.WriteInteger(ord(Fields[i].DataType));
               end;
               Writer.WriteListEnd;
          end;

          // Write all records
          FSaveCount:=0;
          FSavedCompletely:=true;
          Writer.WriteListBegin;

          // Check if to write according to current index or not.
          UsingIndex:=sfSaveUsingIndex in FUsingIndex;
          if UsingIndex then
             cnt:=FCurIndex.References.Count
          else
              cnt:=TkbmProtCommon(Common).FRecords.Count;

          for j:=0 to cnt-1 do
          begin
               // Check if to save more.
               if (FSaveLimit>0) and (FSaveCount>=FSaveLimit) then
               begin
                    FSavedCompletely:=false;
                    break;
               end;

               // Check if to invoke progress event if any.
               if (j mod 100)=0 then Progress(trunc((j/cnt)*100),mtpcSave);

               // Setup which record to look at.
               if UsingIndex then
                  FOverrideActiveRecordBuffer:=PkbmRecord(FCurIndex.References.Items[j])
               else
                  FOverrideActiveRecordBuffer:=PkbmRecord(TkbmProtCommon(Common).FRecords.Items[j]);
               if (FOverrideActiveRecordBuffer=nil) then continue;

               // Calculate fields.
               ClearCalcFields(PChar(FOverrideActiveRecordBuffer));
               GetCalcFields(PChar(FOverrideActiveRecordBuffer));

               // Check filter of record.
               Accept:=FilterRecord(FOverrideActiveRecordBuffer,false);
               if not Accept then continue;

               // Check accept of saving this record.
               Accept:=true;
               if Assigned(OnSaveRecord) then OnSaveRecord(ADataset,Accept);
               if not Accept then continue;

               // Write current record.
               NewestVersion:=true;
{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
{$IFNDEF BINARY_FILE_200_COMPATIBILITY}
               // New for v. 2.24.
               if (not (sfSaveData in sfData)) and (FOverrideActiveRecordBuffer^.UpdateStatus=usUnmodified) then continue;

               // New for v. 2.30b
               if (not (sfSaveDontFilterDeltas in sfDontFilterDeltas)) and (FOverrideActiveRecordBuffer^.UpdateStatus=usDeleted) then
               begin
                    // Make sure record has not been inserted and deleted again.
                    pRec:=FOverrideActiveRecordBuffer^.PrevRecordVersion;
                    while pRec^.PrevRecordVersion<>nil do pRec:=pRec^.PrevRecordVersion;
                    if pRec^.UpdateStatus=usInserted then continue;
               end;

               // Write record versions in a list starting with Updatestatus.
               Writer.WriteListBegin;
               while FOverrideActiveRecordBuffer<>nil do
               begin
                    Writer.WriteInteger(ord(FOverrideActiveRecordBuffer^.UpdateStatus));
{$ENDIF}
{$ENDIF}
                    for i:=0 to nf-1 do
                    begin
                         if SaveFields[i]>=0 then
                         begin
                              if NewestVersion and Assigned(FOnSaveField) then FOnSaveField(ADataset,i,Fields[i]);

{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
{$IFNDEF BINARY_FILE_200_COMPATIBILITY}
{$IFNDEF BINARY_FILE_230_COMPATIBILITY}
                              Writer.WriteBoolean(Fields[i].IsNull);
                              if not Fields[i].IsNull then
                              begin
{$ENDIF}
{$ENDIF}
{$ENDIF}
                                   case Fields[i].DataType of
                                        ftBoolean : Writer.WriteBoolean(Fields[i].AsBoolean);

{$IFNDEF LEVEL3}
                                        ftLargeInt: Writer.WriteFloat(Fields[i].AsFloat);
                                        ftWideString: Writer.WriteString({$IFDEF LEVEL6}UTF8Encode(Fields[i].Value){$ELSE}Fields[i].AsString{$ENDIF});
{$ENDIF}

                                        ftSmallInt,
                                        ftInteger,
                                        ftWord,
                                        ftAutoInc : Writer.WriteInteger(Fields[i].AsInteger);

                                        ftFloat : Writer.WriteFloat(Fields[i].AsFloat);

                                        ftBCD,
                                        ftCurrency : Writer.WriteFloat(Fields[i].AsCurrency);

                                        ftDate,
                                        ftTime,ftDateTime: Writer.WriteFloat(Fields[i].AsFloat);
                                   else
                                       Writer.WriteString(Fields[i].AsString);
                                   end;
{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
{$IFNDEF BINARY_FILE_200_COMPATIBILITY}
{$IFNDEF BINARY_FILE_230_COMPATIBILITY}
                              end;
{$ENDIF}
{$ENDIF}
{$ENDIF}
                         end;
                    end;
{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
{$IFNDEF BINARY_FILE_200_COMPATIBILITY}                         // New for v. 2.24.

                    // Only write newest version (current data).
                    if not (sfSaveDeltas in sfDeltas) then break;

                    // Prepare writing next older version of record.
                    FOverrideActiveRecordBuffer:=FOverrideActiveRecordBuffer^.PrevRecordVersion;
                    NewestVersion:=false;
               end;
               Writer.WriteListEnd;
{$ENDIF}
{$ENDIF}

               // Increment save count.
               inc(FSaveCount);
          end;
          Writer.WriteListEnd;
     end;
end;

procedure TkbmCustomBinaryStreamFormat.BeforeLoad(ADataset:TkbmCustomMemTable);
begin
     inherited;

     StreamSize:=WorkStream.Size;
     ProgressCnt:=0;

     Reader:=TReader.Create(WorkStream,FBuffSize);
     Reader.ReadSignature;

     InitIndexDef:=false;

{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
     if Reader.NextValue = vaList then       // A hack since vaList only exists in >= v. 2.xx.
       FileVersion := 100
     else
       FileVersion:=Reader.ReadInteger;
{$ELSE}
     FileVersion:=0;
{$ENDIF}
end;

procedure TkbmCustomBinaryStreamFormat.AfterLoad(ADataset:TkbmCustomMemTable);
begin
     Reader.Free;

     with TkbmProtCustomMemTable(ADataset) do
     begin
          // Now create indexes as defined.
          if InitIndexDef then CreateIndexes;

          FOverrideActiveRecordBuffer:=nil;
     end;

     inherited;
end;

procedure TkbmCustomBinaryStreamFormat.DetermineLoadFieldIndex(ADataset:TkbmCustomMemTable; ID:string; FieldCount:integer; OrigIndex:integer; var NewIndex:integer; Situation:TkbmDetermineLoadFieldsSituation);
begin
     NewIndex:=OrigIndex;
end;

procedure TkbmCustomBinaryStreamFormat.LoadDef(ADataset:TkbmCustomMemTable);
var
   i:integer;
   FName,KName,TName,DName,EMask,DExpr:string;
   FSize,DSize:integer;
   REQ,RO:boolean;
   FT:TFieldType;
   FK:TFieldKind;
   InitTableDef:boolean;
   ld,ldidx:boolean;
{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
   ioptions:TIndexOptions;
   FFields:string;
{$ENDIF}
begin
     if (StreamSize = 0) then exit;
     ld:=sfLoadDef in sfDef;
     ldidx:=sfLoadIndexDef in sfIndexDef;

     with TkbmProtCustomMemTable(ADataset) do
     begin
          // Read all definitions if any saved.
          InitTableDef:=false;
          InitIndexDef:=false;
          try
             Reader.ReadListBegin;

             while not(Reader.EndofList) do
             begin
                  // Clear previous setup if not cleared yet.
                  if not InitTableDef then
                  begin
                       if ld then
                       begin
                            Close;
                            FieldDefs.clear;
                            DeleteTable;
                       end;
                       InitTableDef:=true;
                  end;

                  // read field definition.
                  FName := Reader.ReadString;
                  TName := Reader.ReadString;
                  FSize := Reader.ReadInteger;
                  DName := Reader.ReadString;
                  EMask := Reader.ReadString;
                  DSize := Reader.ReadInteger;
                  REQ := Reader.ReadBoolean;
                  RO := Reader.ReadBoolean;
                  if FileVersion>=250 then KName:=Reader.ReadString
                  else KName:=FieldKindNames[0]; // fkData
                  if FileVersion>=251 then DExpr:=Reader.ReadString
                  else DExpr:='';

                  // Find fieldtype from fieldtypename.
                  for i:=0 to ord(High(FieldTypeNames)) do
                      if FieldTypeNames[TFieldType(i)]=TName then break;
                  FT:=TFieldType(i);
                  if not (FT in kbmSupportedFieldTypes) then
                     raise EMemTableError.Create(Format(kbmUnknownFieldErr1,[TName]));

                  // Find fieldkind from fieldkindname.
                  FK:=fkData;
                  for i:=0 to ord(High(FieldKindNames)) do
                      if FieldKindNames[i]=KName then
                      begin
                           FK:=TFieldKind(i);
                           break;
                      end;

                 if ld then
                 begin
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
                      end;
                  end;
             end;
             Reader.ReadListEnd;

             // Indexes introduced in file version 2.00
             if FileVersion>=200 then
             begin
                  // Read all index definitions if any saved.
                  Reader.ReadListBegin;

                  while not(Reader.EndofList) do
                  begin
                       // Clear previous setup if not cleared yet.
                       if not InitIndexDef then
                       begin
                            if ld and ldidx then
                            begin
                                 DestroyIndexes;
                                 FIndexDefs.Clear;
                            end;
                            InitIndexDef:=true;
                       end;

                       // read index definition.
                       FName := Reader.ReadString;
                       FFields := Reader.ReadString;
                       DName := Reader.ReadString;

                       ioptions:=[];
                       if Reader.ReadBoolean then ioptions:=ioptions+[ixDescending];
                       if Reader.ReadBoolean then ioptions:=ioptions+[ixCaseInSensitive];

{$IFNDEF LEVEL3}
                       if Reader.ReadBoolean then ioptions:=ioptions+[ixNonMaintained];
{$ELSE}
                       Reader.ReadBoolean;     // Skip ixNonMaintained info since not supported for D3/BCB3.
{$ENDIF}
                       if Reader.ReadBoolean then ioptions:=ioptions+[ixUnique];

                       // Add index definition.
                       if ld and ldidx then
                       begin
{$IFNDEF LEVEL3}
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
                  end;
                  Reader.ReadListEnd;
             end;
          finally
             if InitTableDef then Open;
          end;
     end;
     if not (ld and ldidx) then InitIndexDef:=false;
end;

procedure TkbmCustomBinaryStreamFormat.LoadData(ADataset:TkbmCustomMemTable);
   procedure SkipField(AFieldType:TFieldType);
   begin
        case AFieldType of
          ftBoolean :   Reader.ReadBoolean;

{$IFNDEF LEVEL3}
          ftLargeInt:   Reader.ReadFloat;
          ftWideString: Reader.ReadString;
{$ENDIF}

          ftSmallInt,
          ftInteger,
          ftWord :      Reader.ReadInteger;

          ftAutoInc :   Reader.ReadInteger;

          ftFloat :     Reader.ReadFloat;

          ftBCD,
          ftCurrency :  Reader.ReadFloat;

          ftDate,
          ftTime,
          ftDateTime : Reader.ReadFloat;
        else
          Reader.ReadString;
        end;
   end;
var
   i,j:integer;
   nf:integer;
   Accept:boolean;
   bNull:boolean;
   Date:double;
   NewestVersion:boolean;
   pRec:PkbmRecord;
   ApproxRecs:integer;
   fc,fno:integer;
   ftypes:array of TFieldType;
begin
     if (StreamSize = 0) then exit;
     with TkbmProtCustomMemTable(ADataset),TkbmProtCommon(ADataset.Common) do
     begin
          SetTempState(dsinsert);
          try
             ResetAutoInc;

             // Try to determine approx how many records in stream + add some slack.
             if RecordSize>0 then
             begin
                  ApproxRecs:=StreamSize div FDataRecordSize;
                  ApproxRecs:=ApproxRecs + (ApproxRecs div 50) + RecordCount;
             end
             else
                 ApproxRecs:=0;

{$IFDEF LEVEL4}
             nf:=length(LoadFields);
{$ELSE}
             nf:=LoadFieldsCount;
{$ENDIF}

             // Load datatypes from header.
             fc:=0;
             if sfLoadDataTypeHeader in sfDataTypeHeader then
             begin
                  Reader.ReadListBegin;
                  fc:=Reader.ReadInteger;
                  SetLength(ftypes,fc);
                  for i:=0 to fc-1 do
                      ftypes[i]:=TFieldType(Reader.ReadInteger);
                  Reader.ReadListEnd;
             end;

             // Read all records.
             FLoadCount:=0;
             FLoadedCompletely:=true;

             if ApproxRecs>0 then FRecords.Capacity:=ApproxRecs; // For speed reason try to preallocate room for all records.

             Reader.ReadListBegin;
             while not(Reader.EndofList) do
             begin
                  // Show progress.
                  inc(ProgressCnt);
                  ProgressCnt:=ProgressCnt mod 100;
                  if (ProgressCnt=0) then
                     Progress(trunc((WorkStream.Position / StreamSize) * 100),mtpcLoad);

                  if (FLoadLimit>0) and (FLoadCount>=FLoadLimit) then
                  begin
                       FLoadedCompletely:=false;
                       break;
                  end;

                  pRec:=_InternalAllocRecord;
                  FOverrideActiveRecordBuffer:=pRec;

                  NewestVersion:=true;
{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
 {$IFNDEF BINARY_FILE_200_COMPATIBILITY}                         // New for v. 2.24.

                  // Loop for all versions of record if versioning is used (2.30 and forth).
                  if FileVersion>=230 then Reader.ReadListBegin;
                  while true do
                  begin
                       if FileVersion>=230 then FOverrideActiveRecordBuffer^.UpdateStatus:=TUpdateStatus(Reader.ReadInteger);
 {$ENDIF}
{$ENDIF}

                       // Read fields for current record version.
                       fno:=0;
                       for i:=0 to nf-1 do
                       begin
                            if LoadFields[i]<0 then
                            begin
                                 // Check if to skip.
                                 if fc>0 then SkipField(ftypes[fno]);
                                 continue;
                            end;
                            j:=LoadFields[i];

                            //2.50i                          if Fields[i].FieldKind<>fkData then continue;

{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
 {$IFNDEF BINARY_FILE_200_COMPATIBILITY}
  {$IFNDEF BINARY_FILE_230_COMPATIBILITY}                     // New for v. 2.49.
                            // Check if null values saved in binary file.
                            if (FileVersion>=249) then
                               bNull:=Reader.ReadBoolean
                            else
  {$ENDIF}
 {$ENDIF}
{$ENDIF}
                               bNull:=false;

                            // Check if null field.
                            if bNull then
                               Fields[j].Clear
                            else
                            begin
                                 // Not null, load data.
                                 case Fields[j].DataType of
                                      ftBoolean : Fields[j].AsBoolean := Reader.ReadBoolean;

{$IFNDEF LEVEL3}
                                      ftLargeInt: Fields[j].AsFloat := Reader.ReadFloat;
                                      ftWideString: Fields[j].Value := {$IFDEF LEVEL6}UTF8Decode(Reader.ReadString){$ELSE}Reader.ReadString{$ENDIF};
{$ENDIF}

                                      ftSmallInt,
                                      ftInteger,
                                      ftWord : Fields[j].AsInteger := Reader.ReadInteger;

                                      ftAutoInc : with Fields[j] do begin
                                                       AsInteger:=Reader.ReadInteger;
                                                       if FAutoIncMax<AsInteger then
                                                          FAutoIncMax:=AsInteger;
                                                  end;

                                      ftFloat : Fields[j].AsFloat := Reader.ReadFloat;

                                      ftBCD,
                                      ftCurrency : Fields[j].AsCurrency := Reader.ReadFloat;

                                      ftDate,
                                      ftTime,
                                      ftDateTime : begin
                                                      Date:=Reader.ReadFloat;
                                                      if Date=0 then Fields[j].Clear
                                                      else Fields[j].AsFloat:=Date;
                                                   end;
                                 else
                                     Fields[j].AsString := Reader.ReadString;
                                 end;
                            end;

                            if NewestVersion and Assigned(FOnLoadField) then OnLoadField(ADataset,i,Fields[i]);
{$IFNDEF BINARY_FILE_1XX_COMPATIBILITY}
 {$IFNDEF BINARY_FILE_200_COMPATIBILITY}                         // New for v. 2.24.
                       end;

                       // Previous file versions didnt contain versions, so just break loop.
                       if FileVersion<230 then break;

                       // Prepare for reading next version if any. (introduced in v. 2.30)
                       if Reader.EndOfList then break;

                       // Prepare next version.
                       NewestVersion:=false;
                       FOverrideActiveRecordBuffer^.PrevRecordVersion:=_InternalAllocRecord;
                       FOverrideActiveRecordBuffer:=FOverrideActiveRecordBuffer^.PrevRecordVersion;

                  end;
                  if FileVersion>=230 then Reader.ReadListEnd;
 {$ENDIF}
{$ENDIF}

                  Accept:=true;
                  if Assigned(OnLoadRecord) then OnLoadRecord(ADataset,Accept);
                  if Accept then
                  begin
                       pRec^.RecordID:=FRecordID;
                       inc(FRecordID);
                       pRec^.UniqueRecordID:=FUniqueRecordID;
                       inc(FUniqueRecordID);
                       pRec^.Flag:=kbmrfInTable;
                       FRecords.Add(pRec);
                       if pRec^.UpdateStatus=usDeleted then inc(FDeletedCount);
                       inc(FLoadCount);
                  end
                  else
                     _InternalFreeRecord(pRec,true,true);
             end;
             Reader.ReadListEnd;
          finally
             RestoreState(dsBrowse);
          end;
     end;
end;

// -----------------------------------------------------------------------------------
// Registration for Delphi 3 / C++ Builder 3
// -----------------------------------------------------------------------------------

{$ifdef LEVEL3}
procedure Register;
begin
     RegisterComponents('kbmMemTable', [TkbmBinaryStreamFormat]);
end;
{$endif}

end.
