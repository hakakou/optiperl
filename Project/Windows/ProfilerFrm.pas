unit ProfilerFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RunPerl,OptMessages, dccommon, dcmemo, ExtCtrls, StdCtrls, BUGroupBox,
  HKMessageRec;

type
  TProfilerForm = class(TForm)
    memTimes: TDCMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProfilerForm: TProfilerForm;

implementation

{$R *.DFM}

procedure TProfilerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin writeln(TimeToStr(time)+' TProfilerForm.FormClose'); system.flush(system.output); writeln(TimeToStr(time)+' TProfilerForm.FormClose'); flush(output); writeln(TimeToStr(time)+' TProfilerForm.FormClose'); writeln('TProfilerForm.FormClose');
 Action:=caFree;
 ProfilerForm:=nil;
 ActiveMemo:=nil;
end;

procedure TProfilerForm.FormShow(Sender: TObject);
begin writeln(TimeToStr(time)+' TProfilerForm.FormShow'); system.flush(system.output); writeln(TimeToStr(time)+' TProfilerForm.FormShow'); flush(output); writeln(TimeToStr(time)+' TProfilerForm.FormShow'); writeln('TProfilerForm.FormShow');
 RunPerl.ProfileScript(RequestString(HK_ActiveScriptPath),
  memTimes.Lines,nil);
end;

end.