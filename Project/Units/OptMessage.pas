{***************************************************************
 *
 * Unit Name: OptMessage
 * Date     : 23/1/2001 10:54:14 μμ
 * Purpose  : Message const
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit OptMessage;    //Unit

interface
uses classes,sysutils,Messages;

Type
 TCurError = Record
  Line,Index : Integer;
 end;

var
 BreakPoints : TStringList;
 CurErrors : TStringList;
 CurErrorsLines : Array of TCurError;
 CurErrorsShowing : TObject;
 CurErrorsStatus : Integer;

type
  TBreakStatus = (bsGeneral,bsOK,bsInvalid,bsNone);

  PBreakInfo = ^TBreakInfo;
  TBreakInfo = Record
   Line : Integer;
   BreakStatus : TBreakStatus;
   Condition : String;
   Done : Boolean;
  end;

 //sendmail
const
 HK_SendMail = WM_User + $3023;
 //the above must be the same as sendmail.exe
 HK_DockingEvent = WM_USER + $3024;
 HK_LoadFile = WM_USER + $3026;


implementation

procedure FreeBreakpoints;
var
 i:integer;
begin
 for i:=0 to BreakPoints.Count-1 do
  Dispose(PBreakInfo(Breakpoints.Objects[i]));
 BreakPoints.Free;
end;

initialization
 breakpoints:=TStringList.create;
 BreakPoints.Sorted:=true;
 BreakPoints.Duplicates:=dupAccept;
 CurErrors:=TStringList.Create;
finalization
 CurErrors.Free;
 FreeBreakpoints;
end.