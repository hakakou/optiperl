unit HKWWWMenu;

interface

 uses
    Windows, Messages, SysUtils, Classes, Controls,
    Menus, Registry,inifiles;

   type
    TOnURLClick = procedure(Sender : TObject; URL : String) of object;

    TWWWMenu = class(TComponent)
    Private
     FOnURLClick : TOnURLClick;
     procedure OnClick(Sender: TObject);
    public
     function PopFavMenu(WMenu: TMenu): boolean;
     Constructor Create(AOwner : TComponent); override;
     Destructor Destroy; override;
    published
     property OnUrlClick : TOnURLClick read FOnURLClick write FOnURLClick;
    end;

    Procedure Register;

implementation

type
     TURLrec = Class
      Rep      : String;
      URLName  : String;
      URLPath  : String;
     end;


Procedure Register;
begin
     RegisterComponents('HAKA', [TWWWMenu]);
end;

function SortFunction( item1, item2 : Pointer ) : Integer;
var
   tempObj1 : TURLrec;
   tempObj2 : TURLrec;
begin
     Result:=0;
     tempObj1 := TURLrec( item1 );
     tempObj2 := TURLrec( item2 );
     if tempObj1.rep < tempObj2.rep then result:=-1;
     if tempObj1.rep > tempObj2.rep then result:=1;
     if tempObj1.rep = tempObj2.rep then
        begin
             if ((tempobj1.URLName < tempobj2.URLName)) then result:=-1;
             if ((tempobj1.URLName > tempobj2.URLName)) then result:=1;
             if ((tempobj1.URLName = tempobj2.URLName)) then result:=0;
        end;
end;

constructor TWWWMenu.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
end;

destructor TWWWMenu.Destroy;
begin
 inherited Destroy;
end;

procedure TWWWMenu.OnClick(Sender: TObject);
var
 Item : TMenuItem;
begin
 item:=TMenuItem(Sender);
 if (assigned(FOnURLClick)) then
  FOnURLClick(item,item.Hint);
end;

function TWWWMenu.PopFavMenu(WMenu: TMenu): boolean;
var
 Registry         : TRegistry;   // register var for operations in RegEdit.
 SList : TList;
 Orig_Folder      : String;      // Main path of the favorites.
 tempObj          : TURLrec;     // Temp Pointer.
 Index : Integer;
 NewItem,subItem,DirItem          : TMenuItem;   // Item of PopupMenu.


  Function CreateSubMenu : Boolean;
  var
   i          : Integer;
   Car        : String[1];
   Dir1       : String;
   nbre,loop3       : Integer;
  begin
     Result:=False;
     Nbre:=0;
     For i:=0 to length(TempObj.rep) do
         begin
              Car:=Copy(TempObj.Rep,i,1);
              If car='\' then inc(nbre);
         end;
     loop3:=0;
     For i:=0 to length(TempObj.rep) do
         begin
              Car:=Copy(TempObj.Rep,i,1);
              If car='\' then
                 begin
                      inc(loop3);
                      // Get the directory name
                      Dir1:=Copy(TempObj.Rep,0,i-1);
                      Dir1:=Copy(TempObj.Rep,Length(Dir1)+2,Length(TempObj.Rep));
                      If ((Nbre=1)) then // First subMenu
                         begin
                              // Other subMenu.
                              subItem:=TMenuItem.Create(NewItem);
                              subItem.Caption:=Dir1; // Directory Name.
                              NewItem.insert(0,SubItem);
                              DirItem:=SubItem;
                              Subitem.tag:=1; // Tag = 1 , icone menu (Rep)
                              subitem.ImageIndex:=0;
                         end
                      else
                          begin
                               if loop3=Nbre then  // Other subMenu.
                                  begin
                                       SubItem:=TMenuItem.Create(DirItem);
                                       SubItem.Caption:=Dir1;
                                       DirItem.insert(0,SubItem);
                                       Diritem:=Subitem;
                                       Diritem.tag:=1;  // Tag = 1 , icone menu (Rep).
                                       diritem.ImageIndex:=0;
                                  end;
                          end;
                      Result:=True; // SubMenus found and created.
                 end;
         end;
  end;


  Procedure createMenu;
  var
   nom             : String;
   Loop2,loop,Flag : Boolean;
   i : integer;
   FolderNom :String;
  begin
     loop:=false;
     nom:=':';
     i:=0;
     While i<= Slist.count-1 do
           begin
                TempObj:=Slist.items[i];
                If ((TempObj.Rep<>'')) then Nom:=TempObj.Rep; // New Directory.
                If ((TempObj.Rep=Nom)) then // If Record = Repertoire
                       begin
                            Loop2:=False;
                            If CreateSubMenu then Loop2:=True; // SubMenu Created.
                            If loop2=True then // If there are subMenus.
                               begin
                                    While ((TempObj.Rep=Nom)) do
                                          begin
                                               if TempObj.URLName<>'' then
                                                  begin
                                                       // URL File of the directory.
                                                       SubItem:=TMenuItem.Create(DirItem);
                                                       SubItem.Caption:=TempObj.URLNAme;
                                                       SubItem.hint:=(tempObj.URLPath);
                                                       subitem.ImageIndex:=1;
                                                       subItem.OnClick:=OnClick;
                                                       DirItem.Add(SubItem);
                                                  end
                                               else   //Folder with URLName=''.
                                                   begin
                                                        // Empty Folder ?.
                                                        if i<=Slist.count-1 then
                                                           begin
                                                                FolderNom:=Tempobj.Rep;
                                                                Tempobj:=slist.items[i+1];
                                                                if FolderNom<>tempobj.rep then
                                                                   begin
                                                                        SubItem:=TMenuItem.Create(DirItem);
                                                                        SubItem.Caption:='(Empty)';
                                                                        Subitem.Enabled:=False;
                                                                        DirItem.Add(SubItem);
                                                                   end;
                                                                Tempobj:=slist.items[i];
                                                           end;
                                                   end;
                                               inc(i);
                                               If i<=Slist.count-1 then TempObj:=Slist.items[i]
                                               else nom:=':';
                                               Loop:=True;
                                          end;
                               end
                            Else // Not submenus.
                                begin
                                     // Create the Main directory.
                                     NewItem:=TMenuItem.Create(WMenu);
                                     Newitem.ImageIndex:=0;
                                     NewItem.Caption:=TempObj.Rep;
                                     WMenu.Items.Add(NewItem);
                                     Newitem.tag:=1; // Tag = 1 , icone menu (Rep)
                                     // Empty Folder ?.
                                     if i<=Slist.count-1 then
                                        begin
                                             FolderNom:=Tempobj.Rep;
                                             Tempobj:=slist.items[i+1];
                                             if FolderNom<>tempobj.rep then
                                                begin
                                                     SubItem:=TMenuItem.Create(Newitem);
                                                     SubItem.Caption:='(Empty)';
                                                     Subitem.Enabled:=False;
                                                     NewItem.Add(SubItem);
                                                end;
                                             Tempobj:=slist.items[i];
                                        end;
                                end;
                            Flag:=False;
                            while ((TempObj.Rep=Nom) and (flag=False)) do
                                  begin
                                       If TempObj.URLName<>'' then
                                          begin
                                               // Create the URL file of the First Directory.
                                               subItem:=TMenuItem.Create(NewItem);
                                               subItem.Caption:=TempObj.URLNAme;
                                               subitem.hint:=tempObj.URLPath;
                                               subitem.ImageIndex:=1;
                                               subItem.OnClick:=OnClick;

                                               NewItem.Add(SubItem);
                                          end;
                                       // End Of List ?
                                       inc(i);
                                       if i > slist.count-1 then flag:=true
                                       else tempobj:=slist.items[i];
                                       Loop:=True;
                                  end;
                       end;
                // End Of List ? or Value incremented before ?.
                If loop=false then inc(i);
                Loop:=False;
           end;
     // Created URL File of the main Directory.
     i:=0;
     TempObj:=Slist.items[0];
     While ((TempObj.rep='') and (i<slist.count)) do
           begin
                NewItem:=TMenuItem.Create(WMenu);
                NewItem.Caption:=TempObj.URLName;
                Newitem.hint:=tempObj.URLPath;
                Newitem.ImageIndex:=1;
                NewItem.OnClick:=OnClick;
                WMenu.Items.Add(NewItem);
                inc(i);
                if i<slist.count then TempObj:=Slist.items[i];
           end;
  End;


 procedure SearchURL(Folder : String);
 var
    Flag      : Integer;
    SearchRec : TSearchRec;
    fichier   : Tinifile;
 begin
     // First File.
     Flag := FindFirst(Folder+'\*.*', faAnyFile, SearchRec);
     // Research other file.
     while Flag = 0 do
           begin
                // don't get the special directory ('.' et '..');
                if ((SearchRec.Name <> '.' ) and (SearchRec.Name <> '..')) then
                   // change directory.
                   if (SearchRec.Attr and fadirectory > 0) then
                      begin
                           if not (SearchRec.Attr and fasysfile > 0) then
                               begin
                           tempObj := TURLrec.Create;
                           tempobj.Rep:=copy(Folder+'\'+SearchRec.Name,length(Orig_Folder)+2,length(Folder+'\'+SearchRec.Name));
                           TempObj.URLName:='';
                           TempObj.URLPath:='';
                           sList.Add(tempObj);
                               end;
                           searchURL(Folder+'\'+SearchRec.Name);
                      end
                   else
                       begin
                            // Get the file extension.
                            if (UpperCase(ExtractFileExt(Searchrec.Name)) = '.URL') then
          	               begin
                                    begin
                                         tempObj := TURLrec.Create;
                                         TempObj.Rep:=copy(folder,length(Orig_Folder)+2,length(folder));
                                         fichier := Tinifile.create(Folder+'\'+SearchRec.name);
                                         TempObj.URLName:=copy(SearchRec.Name,0,length(SearchRec.Name)-3);
                                         TempObj.URLPath:=fichier.ReadString('InternetShortcut','URL','(empty)');
                                         fichier.Free;
                                         sList.Add(tempObj);
                                    end;
                               end;
                       end;
                   // other file.
                   Flag := FindNext(SearchRec);
           end;
  end;

begin
     result:=false;
     Registry:=Tregistry.create(KEY_READ);
     Registry.RootKey:= HKEY_CURRENT_USER;
     registry.openKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders',false);
     Orig_Folder:=registry.ReadString('Favorites');
     Registry.free;
     if Orig_Folder <>'' then
        begin
            sList := TList.Create;
             // Get all the links.
             SearchURL(Orig_Folder);
             // Sort the list.
             if SList.Count>0 then
                begin
                     sList.Sort(SortFunction);
                     // Create and set the popupmenu.
                     CreateMenu;
                end;
             result:=true;
        end;

      if Orig_Folder ='' then
        begin
             if Slist.count<>0 then
                for index := 0 to sList.count-1 do
                    begin
                         tempObj := sList[index];
                         tempObj.Destroy;
                    end;
             sList.Destroy;
        end;
end;


end.
