#Name: Subroutine Uses
#Description: Shows where each subroutine is used within the same script under "sub" node of code explorer (\optiperl\plug-ins\SubroutineUses.pl)
#Icon: %opti%Tools.icl,148
#Button: Explorer / Main menu

use Win32::OLE;

sub Initialization {

 $PlugID = $_[0];
 #Get plug id. Will be used later
 $optiperl =  Win32::OLE->new('OptiPerl.Application');
 #get reference to application
 $treeview = $optiperl->CodeExplorer;
 #get reference to code explorer treeview
 $subroutinenode = $treeview->MainNode(4);
 #get the 4th (0-index) main node (subroutines)

 #Now iterate all subnodes of subroutine nodes
 #to get all subroutines used. We will create a
 #hash with them.
 my $node = $treeview->GetFirstChild($subroutinenode);
 #get first child of subroutine node
 while (defined $node) {
 #While the node is defined,
  $hash{$node->Caption} = $node;
  #add the subroutine name as key with the node as value
  $node = $treeview->GetNext($node,1);
  #get the next node
 }

 $optiperl->QuickSave;
 #Quick save active file. See help file for more information
 $filename = $optiperl->ActiveDocument->Filename;
 #Get the filename
 $line = 0;
 open(FILE, $filename);
 while (<FILE>)
 {
	while ((my $key,my $node) = each %hash)
	#for each item in the subroutine hash:
	{
		if ((index $_,$key) >= 0) {
		#is the text in the line?
		 $newnode=$treeview->AddNode($node);
		 #add a child node under the node with the subroutine
		 $newnode->{Caption} = $_;
		 $newnode->{Path} = $filename;
		 $newnode->{Hint} = $_;
		 $newnode->{Line} = $line;
		}
	}
	$line++;
 }
 close(FILE);

 $optiperl->EndPlugIn($PlugID);
 #Finished. Note that this plug-in is not ment to
 #run continually, so the above terminates it right after
 #it runs.
}


sub Finalization {
}

if (! defined $valid_plugin) {
 #enter here the subroutines you want to test.
 Initialization;
}