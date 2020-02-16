{-------------------------------------------------------------------------------
 
 Copyright (c) 1999-2003 The Delphi Inspiration - Ralf Junker
 Internet: http://www.zeitungsjunge.de/delphi/
 E-Mail:   delphi@zeitungsjunge.de

-------------------------------------------------------------------------------}

unit DIConsts;

interface

const
  CONTAINER_NOT_EMPTY_WHILE = 'Container not empty while ';
  NOT_ASSIGNED = ' not assigned';
  IS_NIL = ' is nil';

resourcestring

  SInvalidElementType = 'Invalid Element Type';
  SInvalidOperation = 'Invalid Operation';

  SStreamNilError = 'Stream is nil';

  SContainerEmptyError = 'Container is empty';

  SItemHandlerMismatchError = 'Itemhandlers do not match';
  SKeyHandlerMismatchError = 'Keyhandlers do not match';

  SInvalidItemSizeError = 'Invalid ItemSize (%d)';
  SInvalidItemPointer = 'Invalid Item pointer';
  SInvalidKeySizeError = 'Invalid KeySize (%d)';
  SInvalidHashCountError = 'Invalid HashCount (%d)';

  SItemHandlerNilError = 'Item' + 'Handler' + IS_NIL;
  SItemNilError = 'Item' + IS_NIL;

  SKeyHandlerNilError = 'Key' + 'Handler' + IS_NIL;
  SKeyNilError = 'Key' + IS_NIL;

  SItemDeletedError = 'Item is deleted';

  SNoOnHashKeyError = 'OnHashKey' + NOT_ASSIGNED;
  SNoOnHashKeyBufError = 'OnHashKeyBuf' + NOT_ASSIGNED;
  SNoOnSameKeysError = 'OnSameKeys' + NOT_ASSIGNED;
  SNoOnSameKeyBufError = 'OnSameKeyBuf' + NOT_ASSIGNED;

  SNoOnStoreKeyError = 'OnStoreKey' + NOT_ASSIGNED;
  SNoOnStoreKeyBufError = 'OnStoreKeyBuf' + NOT_ASSIGNED;

  SNoReadKeyError = 'OnReadKey' + NOT_ASSIGNED;
  SNoWriteKeyError = 'OnWriteKey' + NOT_ASSIGNED;

  SNoOnCopyItemsError = 'OnCopyItems' + NOT_ASSIGNED;

  SNoActionError = 'Action' + NOT_ASSIGNED;
  SNoCompareItemsError = 'CompareItems' + NOT_ASSIGNED;
  SNoIterateItemError = 'IterateItems' + NOT_ASSIGNED;
  SNoSameItemsError = 'SameItems' + NOT_ASSIGNED;

  SNoReadItemError = 'OnReadItem' + NOT_ASSIGNED;
  SNoWriteItemError = 'OnWriteItem' + NOT_ASSIGNED;

  SNotEmptyAssignItemHandlerError = CONTAINER_NOT_EMPTY_WHILE + 'assigning ' + 'ItemHandler';

  SItemHandlerInUseDestructionError = 'ItemHandler in use ' + 'during destruction';

  SItemHandlerInUseItemSizeError = 'ItemHandler in use while ' + 'setting ' + 'ItemSize';
  SItemHandlerInUseKeySizeError = 'ItemHandler in use while ' + 'setting ' + 'KeySize';

  SItemHandlerInUseOnInitItemError = 'ItemHandler in use while ' + 'assigning ' + 'OnInitItem';
  SItemHandlerInUseOnFreeItemError = 'ItemHandler in use while ' + 'assigning ' + 'OnFreeItem';
  SItemHandlerInUseOnCompareItemsError = 'ItemHandler in use while ' + 'assigning ' + 'OnCompareItems';
  SItemHandlerInUseOnCopyItemError = 'ItemHandler in use while ' + 'assigning ' + 'OnCopyItem';
  SItemHandlerInUseOnReadItemError = 'ItemHandler in use while ' + 'assigning ' + 'OnReadItem';
  SItemHandlerInUseOnWriteItemError = 'ItemHandler in use while ' + 'assigning ' + 'OnWriteItem';
  SItemHandlerInUseOnReadHeaderError = 'ItemHandler in use while ' + 'assigning ' + 'OnReadHeader';
  SItemHandlerInUseOnWriteHeaderError = 'ItemHandler in use while ' + 'assigning ' + 'OnWriteHeader';

  SItemHandlerInUseOnHashKeyError = 'ItemHandler in use while ' + 'assigning ' + 'OnHashKey';
  SItemHandlerInUseOnHashKeyBufError = 'ItemHandler in use while ' + 'assigning ' + 'OnHashKeyBuf';
  SItemHandlerInUseOnSameKeysError = 'ItemHandler in use while ' + 'assigning ' + 'OnSameKeys';
  SItemHandlerInUseOnSameKeyBufError = 'ItemHandler in use while ' + 'assigning ' + 'OnSameKeyBuf';
  SItemHandlerInUseOnStoreKeyError = 'ItemHandler in use while ' + 'assigning ' + 'OnStoreKey';
  SItemHandlerInUseOnStoreKeyBufError = 'ItemHandler in use while ' + 'assigning ' + 'OnStoreKeyBuf';
  SItemHandlerInUseOnFreeKeyError = 'ItemHandler in use while ' + 'assigning ' + 'OnFreeKey';
  SItemHandlerInUseOnReadKeyError = 'ItemHandler in use while ' + 'assigning ' + 'OnReadKey';
  SItemHandlerInUseOnWriteKeyError = 'ItemHandler in use while ' + 'assigning ' + 'OnWriteKey';

  SMatrixRowIndexError = 'Matrix row index out of bounds (%d)';
  SMatrixColIndexError = 'Matrix column index out of bounds (%d)';

  STreeMoveError = 'Cannot move a tree item to one of its children';

  SNoTagError = 'Tag is not assigned';
  SNoHtmlParserError = 'HtmlParser is not assigned';

  SHtmlParserPluginMismatch = 'Plugin does not belong to this HtmlParser instance';

  SUnrequestedTagError = 'Unrequested tag (''%s'') encountered. This should not happen and might indicate a bug in TDIHtmlParser.';

  SDIPcreCompileError = 'Regular Expression pattern error at position %d: %s';
  SDIPcreCodeNilError = 'Regular Expression pattern not compiled';
  SDIPcreBadMagicError = 'Magic number not found';

  SDIPcreSubStringIndexError = 'SubString index out of bounds (%d)';
  SDIPcreNamedSubStringIndexError = 'Named SubString index out of bounds (%d)';
  SDIPcreUnknownSubStringName = 'Named SubString ''%s'' does not exist';

  SNoDataError = 'Data is not assigned';
  SDataSizeError = 'DataSize out of bounds (%d)';

  SNoDestStreamError = 'Destination stream is not assigned';

  SNoSourceBufferError = 'SourceBuffer is not assigned';
  SSourceStreamModeError = 'Operation not allowed in Source Stream Mode';

  SSourceBufferPositionError = 'SourceBufferPosition out of bounds (%d)';

  SNoZipArchive = 'No Zip archive created yet';
  SNoZipEntry = 'No Zip entry created yet';

implementation

end.

