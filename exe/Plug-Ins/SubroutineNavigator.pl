#Name: Subroutine Navigator
#Description: Perl script to navigate through subroutines in file using Ctrl+Shift+Up & Down arrows (\optiperl\plug-ins\SubroutineNavigator.pl)
#Icon: %opti%Tools.icl,148
##Extensions: Startup

#Remove second # above to load at startup


use Win32::OLE;

sub Initialization {
 $optiperl = Win32::OLE->new('OptiPerl.Application');
 if (defined $valid_plugin) {
  $plug_id = $_[0];
  my $menu = $optiperl->CreateToolItem($plug_id,"menu");
  $menu->SetOptions("Menu","","","","");

  my $btn = $optiperl->CreateToolItem($plug_id,"button");
  $btn->SetOptions(
      "Find next","Find next subroutine",
      "%opti%tools.icl,157","Ctrl+Shift+Down","do_findnext");
  $menu->ToolLinks->Add($btn,0);

  $btn = $optiperl->CreateToolItem($plug_id,"button");
  $btn->SetOptions(
      "Find previous","Find previous subroutine",
      "%opti%tools.icl,158","Ctrl+Shift+Up","do_findprev");
  $menu->ToolLinks->Add($btn,0);

  $optiperl->ToolBarLinks($plug_id)->AssignLinks($menu->ToolLinks);
  $optiperl->UpdateToolBars($plug_id);
  $optiperl->ToolBarVisible($plug_id,1);
 }
}

sub Finalization {
}

sub _find_next {
 my $doc = $optiperl->ActiveDocument;
 my $i = $optiperl->ActiveDocument->CursorPosY+$_[0];
 my $totallines = $doc->LineCount;
 while (($i<$totallines) and ($i>=0) and
        ($doc->lines($i) !~/^\s*sub (\w+)/)) {
  $i=$i+$_[0];
 }
 if (($i < $totallines) and ($i>=0)) {
  $doc->TempHightlightLine($i);

  return 1;
 }
 else {
  return 0;
 }
}


sub do_findnext {
 if (!_find_next(1)) {
   $optiperl->ActiveDocument->{CursorPosY} = 0;
   _find_next(1);
  }
}

sub do_findprev {
 if (!_find_next(-1)) {
   $optiperl->ActiveDocument->{CursorPosY}=
       $optiperl->ActiveDocument->LineCount-1;
   _find_next(-1);
  }
}

if (! defined $valid_plugin)
{
 Initialization;
}