program uninsOpti;

uses
  windows,
  OptAssociations in '..\Project\Units\OptAssociations.pas';

var p : char;
begin
 if (length(paramstr(2))>0) and (paramstr(1)='optin') then
 begin
  p:=paramstr(2)[1];
  case p of
  'i' : AddOptiAssociations;
  'p' : AddPerlAssociations;
  'u' : begin
         RemovePerlAssociation;
         RemoveOptiAssociation;
         messagebox(0,pchar(
        'Your custom settings will not be deleted.'+#13#10+
        'To completely remove all files, delete the folder:'+#13#10+
        ''+#13#10+
        paramstr(3)+#13#10+
        ''+#13#10+
        'Please ignore this warning if you are upgrading OptiPerl.'),pchar('Warning'),MB_OK or MB_ICONWARNING);
       end;
  end;
 end;


end.
