(*******************************************************************

  CarbonSoft cxKeyPlus VCL Extension v1.0
  Component Registration Unit

  Copyright © 2000 CarbonSoft. All rights reserved

  Important Information:
  You (individual or organisation) are free to use this library and
  associated component in compiled form for any purpose but you may
  NOT create derivative products, including (but not limited to) DLL,
  COM, or ActiveX implementations for any platform for distribution
  without written permission from CarbonSoft.

  The source code may NOT be redistributed, in whole or in part, for
  profit or otherwise without written permission from CarbonSoft.

  If you have any queries please contact: licensing@carbonsoft.com

 *******************************************************************)
unit cxKeyPlusReg;

interface
  uses Classes, cxKeyPlus;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CarbonSoft', [TcxKeyPlus]);
end;

end.
 