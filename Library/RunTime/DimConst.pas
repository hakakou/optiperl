unit DimConst;

interface

resourcestring
  SShellLinkReadError = 'Shortcut read error';
  SShellLinkWriteError = 'Shortsut write error';
  SShellLinkLoadError = 'Cannot load shortcut %s';
  SShellLinkSaveError = 'Cannot save shortcut %s';
  SShellLinkCreateError = 'Cannot initialize shortcut interface';
  SDynArrayIndexError = 'Array %s item index is out of bounds (%d)';
  SDynArrayCountError = 'Array items count is out of bounds (%d)';
  SSharedMemoryError = 'Cannot create file mapping object';
  SCannotInitTimer = 'Cannot initialize timer';
  SPrinterIndexError = 'Printer index is out of bounds (%d)';
  SIndicesOutOfRange = 'Matrix item indices is out of bounds [%d: %d]';
  SRowIndexOutOfRange = 'Matrix row index is out of bounds (%d)';
  SColIndexOutOfRange = 'Matrix col index is out of bounds (%d)';
  SNoAdminRights = 'No admin rights to continue the program';
  SReadOnlyStream = 'Cannot write to a read-only memory stream';

  SFileError = 'Error %s file %s%s';
  SFileReading = 'reading';
  SFileWriting = 'writing';
  SFileError002 = ' - file not found';
  SFileError003 = ' - path not found';
  SFileError004 = ' - cannot open file';
  SFileError005 = ' - access denied';
  SFileError014 = ' - no enough memory';
  SFileError015 = ' - cannot find specified drive';
  SFileError017 = ' - cannot move file to another drive';
  SFileError019 = ' - write protected media';
  SFileError020 = ' - cannot find specified device';
  SFileError021 = ' - device is not ready';
  SFileError022 = ' - device cannot recognize command';
  SFileError025 = ' - specified area not found';
  SFileError026 = ' - drive access denied';
  SFileError027 = ' - sector not found';
  SFileError029 = ' - device write error';
  SFileError030 = ' - device read error';
  SFileError032 = ' - file is used by another application';
  SFileError036 = ' - too many open files';
  SFileError038 = ' - end of file reached';
  SFileError039 = ' - disk full';
  SFileError050 = ' - network request not supported';
  SFileError051 = ' - remote computer is inaccessible';
  SFileError052 = ' - indentical names found on network';
  SFileError053 = ' - network path not found';
  SFileError054 = ' - network busy';
  SFileError055 = ' - network resource or device is inaccessible';
  SFileError057 = ' - network card hardware error';
  SFileError058 = ' - server unable to perform operation';
  SFileError059 = ' - network error';
  SFileError064 = ' - inaccessible network name';
  SFileError065 = ' - network access denied';
  SFileError066 = ' - network resource type incorrectly specified';
  SFileError067 = ' - network name not found';
  SFileError070 = ' - network server shut down';
  SFileError082 = ' - cannot create file or folder';
  SFileError112 = ' - no enough disk free space';
  SFileError123 = ' - file name syntax error';
  SFileError161 = ' - path incorrectly specified';
  SFileError183 = ' - file already exists';

  SCannotSetSize = 'Unable to change the size of a file';

  SUnableToCompress = 'Cannot compress data';
  SUnableToDecompress = 'Cannot decompress data';

  SCannotFindNetwork = 'Cannot find network neiborhood';

implementation

end.
