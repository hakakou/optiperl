{-------------------------------------------------------------------------------
 
 Copyright (c) 1999-2003 The Delphi Inspiration - Ralf Junker
 Internet: http://www.zeitungsjunge.de/delphi/
 E-Mail:   delphi@zeitungsjunge.de

-------------------------------------------------------------------------------}

unit DIPcreReg;

{$I DI.inc}

interface

uses
  Classes,

  DIPcre,
  DIPcreControls;

{$IFNDEF DI_No_Pcre_Component}
procedure Register;
{$ENDIF}

implementation

{$IFNDEF DI_No_Pcre_Component}
procedure Register;
begin
  RegisterComponents('The Delphi Inspiration', [TDIPcre, TDIPcreEdit, TDIPcreComboBox]);
end;
{$ENDIF}

end.

