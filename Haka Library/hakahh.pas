unit HakaHH;

interface
uses ehshhapi,windows,hakawin,sysutils;

Function DisplayIndex(const HelpFile,Index : string) : THandle;
Function DisplayTOC(const HelpFile : string) : THandle;
Function DisplayContext(const HelpFile : string; Index : Integer) : THandle;
Function HHVersionOK : Boolean;
Procedure LoadHTMLHelp;

var
 HtmlHelp: THtmlHelpA;

implementation

var
 HelpVersion : String = '';

Procedure LoadHTMLHelp;
begin
 LoadHH;
 HtmlHelp:=ehshhapi.HtmlHelp;
end;

Function HHVersionOK : Boolean;
begin
 result:=HHCTRL<>0;
end;

Function DisplayContext(const HelpFile : string; Index : Integer) : THandle;
begin
 if (HHCTRL<>0) and (HHVersionOK) then
  result:=HtmlHelp(getdesktopwindow,PChar(helpfile),HH_HELP_CONTEXT,Index);
end;

Function DisplayTOC(const HelpFile : string) : THandle;
begin
 if (HHCTRL<>0) and (HHVersionOK) then
  result:=HtmlHelp(getdesktopwindow,PChar(helpfile),HH_Display_TOC, 0);
end;

Function DisplayIndex(const HelpFile,Index : string) : THandle;
var pc:PChar;
begin
 pc:=PChar(Index);
 if (HHCTRL<>0) and (HHVersionOK) then
  result:=HtmlHelp(getdesktopwindow,PChar(helpfile),
             HH_DISPLAY_INDEX,Cardinal(pc));
end;

end.
