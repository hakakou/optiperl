unit KAParserReg;

interface

procedure Register;

implementation
uses
  Classes, CTParser;

procedure Register;
begin
  RegisterComponents( 'HK Assorted', [TKAParser] );
end;

end.
