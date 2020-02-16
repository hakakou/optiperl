unit RemoteDebFrm; //modeless

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, HKNetwork, OptForm, ComCtrls, ToolWin, Buttons,
  optoptions, OptFolders,RemDebInfoFrm, dxBarExtItems, dxBar,CentralImageListMdl,
  JvxCtrls;

type
  TRemoteDebForm = class(TOptiForm)
    StatusBox: TjvTextListBox;
    BarManager: TdxBarManager;
    dxPush: TdxBarButton;
    dcInfo: TdxBarButton;
    lblStat: TdxBarStatic;
    dxReload: TdxBarButton;
    procedure FormCreate(Sender: TObject);
    procedure btnInfoClick(Sender: TObject);
    procedure dxPushClick(Sender: TObject);
    procedure dxReloadClick(Sender: TObject);
  private
    procedure DoReload(var Msg: TMessage); message WM_USER + 1;
    procedure DoPush(var Msg: TMessage); message WM_USER + 2;
  protected
    Procedure GetPopupLinks(Popup : TDxBarPopupMenu; MainBarManager: TDxBarManager); Override;
    procedure SetDockPosition(var Alignment: TRegionType;
      var Form: TDockingControl; var Pix, index: Integer); override;
  end;

implementation
uses RDebMdl;

{$R *.dfm}

procedure TRemoteDebForm.FormCreate(Sender: TObject);
begin
 SetCaption('Server at '+MyIPAddress);
 left:=5;
 top:=screen.Height-height-5;
end;

procedure TRemoteDebForm.btnInfoClick(Sender: TObject);
begin
 RemDebInfoForm:=TRemDebInfoForm.create(Application);
 RemDebInfoForm.loaded:=true;
 try
  RemDebInfoForm.showmodal;
 finally
  RemDebInfoForm.free;
 end;
end;

procedure TRemoteDebForm.GetPopupLinks(Popup: TDxBarPopupMenu;
  MainBarManager: TDxBarManager);
begin
 popup.ItemLinks:=barmanager.Bars[0].ItemLinks;
end;

procedure TRemoteDebForm.SetDockPosition(var Alignment: TRegionType; var Form: TDockingControl; var Pix,index: Integer);
begin
 Form:=nil;
 Alignment:=drtNone;
 Pix:=0;
 Index:=InDebugs;
end;

procedure TRemoteDebForm.DoPush(var Msg: TMessage);
begin
 RDebMod.sendPush;
end;

procedure TRemoteDebForm.DoReload(var Msg: TMessage);
begin
 RDebMod.ForceReloadFile;
end;

procedure TRemoteDebForm.dxPushClick(Sender: TObject);
begin
 PostMessage(handle,WM_USER+2,0,0);
end;

procedure TRemoteDebForm.dxReloadClick(Sender: TObject);
begin
 PostMessage(handle,WM_USER+1,0,0);
end;

end.
