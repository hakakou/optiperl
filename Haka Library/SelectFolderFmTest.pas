{***************************************************************
 *
 * Author   : Harry Kakoulidis
 *
 ****************************************************************}

unit SelectFolderFmTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponent, JvAppStorage, JvAppRegistryStorage, uPngImageList,
  ImgList, SelectFolderFm, GUITesting, TestFramework, HyperFrm;

type
  TTestForm = class(TForm)
    SelectFolderFrame: TSelectFolderFrame;
    DirImageList: TPngImageList;
    DirImageCollection: TPngImageCollection;
    AppRegistryStorage: TJvAppRegistryStorage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


  TSelectFolderFrameTests = class(TGUITestCase)
  private
   Form : TTestForm;
   Frame : TSelectFolderFrame;
  public
   procedure SetUp; override;
   procedure TearDown; override;
  published
   procedure TestFrame;
   procedure TestRegistry;
   procedure TestGetFile;
  end;

implementation
{$R *.dfm}

procedure TTestForm.FormCreate(Sender: TObject);
begin
 SelectFolderFrame.AddSpecialFolderToList('My Music','My Music',true,1);
 SelectFolderFrame.AddSpecialFolderToList('Shared Pictures','CommonPictures',false,2);
 SelectFolderFrame.AddSpecialFolderToList('Not exist','Problem',false,3);
 SelectFolderFrame.AddSpecialFolderToList('Dup Not exist','Problem',false,3);
 SelectFolderFrame.LoadFromStorage(AppRegistryStorage);
end;

procedure TTestForm.FormDestroy(Sender: TObject);
begin
 SelectFolderFrame.SaveToStorage(AppRegistryStorage);
end;

procedure TSelectFolderFrameTests.SetUp;
begin
 inherited;
 self.ActionDelay:=10;
 Form:=TTestForm.Create(Application);
 Frame:=Form.SelectFolderFrame;
 Form.Show;
end;

procedure TSelectFolderFrameTests.TearDown;
begin
 Form.free;
 inherited;
end;

procedure TSelectFolderFrameTests.TestFrame;
begin
 Check(Frame.cbFolders.Items.Count>0);
end;

procedure TSelectFolderFrameTests.TestRegistry;
begin;
 Frame.LoadFromStorage(Form.AppRegistryStorage);
 Frame.SaveToStorage(Form.AppRegistryStorage);
end;

procedure TSelectFolderFrameTests.TestGetFile;
var
 f:string;
begin
 self.SetFocus(frame.edFilename);
 self.EnterText('test.xarka.bak');
 f:=Frame.Filename;
 self.Status(f);
 SaveStr('',f);
 DeleteFile(f);
end;

initialization
   testFramework.RegisterTest('SelectFolderFmTests Suite',
    TSelectFolderFrameTests.Suite);

end.
