{================================================================================
Copyright (C) 1997-2001 Mills Enterprise

Unit     : rmRegister
Purpose  : This is the registration unit for all of the "rm" Controls.
Date     : 06-02-1999
Author   : Ryan J. Mills
Version  : 1.80
================================================================================}

unit rmRegister;

interface

{$I CompilerDefines.INC}

uses rmDiff,rmLibrary,rmListControl;

procedure Register;

implementation
uses classes;

const
     PalettePage = 'rmControls';

procedure Register;
begin
     RegisterClasses([TrmCustomDiffEngine, TrmCustomDiffViewer]);
     RegisterComponents(PalettePage,[TrmListControl, TrmDiffEngine, TrmDiffViewer, TrmDiffMergeViewer, TrmDiffMap]);
end;

end.
