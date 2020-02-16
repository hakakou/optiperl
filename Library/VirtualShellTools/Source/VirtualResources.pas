unit VirtualResources;

interface

// Version 1.5.0
//
// The contents of this file are subject to the Mozilla Public License
// Version 1.1 (the "License"); you may not use this file except in compliance
// with the License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
//
// Alternatively, you may redistribute this library, use and/or modify it under the terms of the
// GNU Lesser General Public License as published by the Free Software Foundation;
// either version 2.1 of the License, or (at your option) any later version.
// You may obtain a copy of the LGPL at http://www.gnu.org/copyleft/.
//
// Software distributed under the License is distributed on an "AS IS" basis,
// WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
// specific language governing rights and limitations under the License.
//
// The initial developer of this code is Jim Kueneman <jimdk@mindspring.com>
//
//----------------------------------------------------------------------------
//
// Modifications by Francois Rivierre, 2005-11-09, to allow runtime
// customization of internal strings.
//
//----------------------------------------------------------------------------

uses
  // < FR added 11-28-05 >
  // To allow customization of check images at runtime in the column dialog
  VirtualTrees,
  // </ FR added 11-28-05 >
  Messages;

{$include Compilers.inc}
{$include ..\Include\VSToolsAddIns.inc}

const
  WM_VETBASE = WM_APP + 51;
  WM_SHELLNOTIFY = WM_VETBASE;                 // Change in the Shell occured
  WM_VTSETICONINDEX = WM_VETBASE + 1;          // Threaded Icons
  WM_INVALIDFILENAME = WM_VETBASE + 2;         // VET
  WM_SHELLNOTIFYTHREADQUIT = WM_VETBASE + 3;   // ShellNotifier
  WM_CHANGENOTIFY_NT = WM_VETBASE + 4;         // ShellNotifier
  WM_CHANGENOTIFY = WM_VETBASE + 5;            // ShellNotifier
  WM_SHELLNOTIFYTHREADEVENT = WM_VETBASE + 6;  // ShellNotifier
  WM_SHELLNOTIFYRELEASE = WM_VETBASE + 7;      // ShellNotifier
  WM_REMOVEBUTTON = WM_VETBASE + 8;            // VirtualShellToolbar
  WM_CHANGENOTIFY_CUSTOM = WM_VETBASE + 9;
  WM_UPDATESCROLLBAR = WM_VETBASE + 10;       // Signal TDropDownWnd to update scrollbar
  WM_VTSETTHREADMARK = WM_VETBASE + 11;

// <FR changes 2005-11-09>
// Const were changed to var of WideString type, to allow customization
// at runtime. Please not that const necessary to launch control panel applets
// and all this kind of stuff remain unmodified.

var
   S_WARNING: WideString = 'Warning';
   S_OPEN: WideString = 'Open';

  // Names shown in column headers if toShellColumnDetails is not used. In that
  // case the shell handles the names based on local.
   VET_COLUMN_NAMES: array[0..9] of WideString = (
    'Name',
    'Size',
    'Type',
    'Modified',
    'Attributes',
    'Created',
    'Accessed',
    'Path',
    'DOS Name',
    'Custom'
  );

  // < FR added 11-28-05>
  // These variables are used to customize at runtime the column dialog.
  // They are loaded in the corresponding components in the OnShow event
  // of the column dialog.
  // Note that these modifications were done only to ColumnForm.pas and not
  // to ColumnFormD4.pas (I don't have Delphi 4 to test).
  STR_COLUMNDLG_CAPTION : WideString = 'Column settings';
  STR_COLUMNDLG_LABEL1  : WideString = 'Check the columns you would like ' +
    'to make visible in this Folder.  Drag and Drop to reorder the columns. ';
  STR_COLUMNDLG_LABEL2  : WideString = 'The selected column should be ';
  STR_COLUMNDLG_LABEL3  : WideString = 'pixels wide';
  STR_COLUMNDLG_CHECKBOXLIVEUPDATE : WideString = 'LiveUpdate';
  STR_COLUMNDLG_BUTTONOK     : WideString = 'OK';
  STR_COLUMNDLG_BUTTONCANCEL : WideString = 'Cancel';
  // The following is not a string, but I find useful to be able to change
  // the checkboxes style, so I've added another variable to manage it.
  COLUMNDLG_CHKSTYLE : TCheckImageKind = ckXP;
  // </ FR added 11-28-05>

    // Error given when the root of VET is set to a path that does not exist.  The
  // end user should never see this message.
  STR_ERR_INVALID_CUSTOMPATH: WideString = 'Invalid pathname for Custom Root Path';

  // Menu item text shown when the column popup menu has more than a specified
  // number of items or the column has told VET it should not be shown in the
  // menu but only show it in the dialog box.
  STR_COLUMNMENU_MORE: WideString = 'More ...';

    // --------------------------------------------------------------------------
  // TExplorerComboBox messages
  // --------------------------------------------------------------------------

  S_PATH_ERROR: WideString = 'Invalid Path';
  S_COMBOEDIT_DEFAULT_ERROR1: WideString = 'Windows can not find "';
  S_COMBOEDIT_DEFAULT_ERROR2: WideString = '" Please check the spelling and try again.';
  // --------------------------------------------------------------------------

    // --------------------------------------------------------------------------
  // VirtualShellNewMenu strings
  // --------------------------------------------------------------------------
  // The string used as a prefix to the new file being created based on the file type
  // of the extension.  For example a Notepad TXT file will create a new file named
  // New Text Document.txt, where the "New " string is this constant.
  S_NEW: WideString = 'New ';
  // These are the strings that will be appended to New when the additional menu
  // item "New Folder" and "New ShortCut" are requested in the menu.
  S_FOLDER: WideString = 'Folder';
  S_SHORTCUT: WideString = 'Shortcut';
  // This is the string that is shown in the Messagebox if the new file will
  // overwrite an existing file.
  S_OVERWRITE_EXISTING_FILE: WideString = 'File exists.  Overwrite existing file?';

// FR added 2005-11-09. This allow to preserve the following as constants.
const
  // SHOULD NOT HAVE TO EDIT THESE STRINGS
  // applet launcher file, should never have to change this
  S_RUNDLL32 = '\rundll32.exe';
  // The dll launched by RunDll32.exe for the Briefcase with the necessary mods
  // Do not Modify!
  // The %1 seems to be Boolean for create on desktop on not (not being true)
  S_BRIEFCASE_HACK_STRING = 'syncui.dll,Briefcase_Create 1!d! ';
  // Test string to match up with Command string to see if the menu item will
  // create a new Briefcase or Link. Do not Modify!
  S_BRIEFCASE_IDENTIFIER = ',Briefcase_Create';
  S_CREATELINK_IDENTIFIER = ',NewLinkHere';
  S_NULLFILE = 'NullFile';
  S_FILENAME = 'FileName';
  S_COMMAND = 'Command';
  S_DATA = 'Data';
  S_SHELLNEW_PATH = '\ShellNew';
  // --------------------------------------------------------------------------

  // Literal translations of TShellNotifyEvent type.  Useful when using the
  // OnShellNotify event to print out what event occured.  VirtualShellUtilities.pas
  // has a helper function ShellNotifyEventToStr that uses these.
  VET_NOTIFY_EVENTS: array[0..19] of WideString = (
    'Assocciation Changed',
    'Attributes',
    'Item Create',
    'Item Delete',
    'Drive Add',
    'Drive Add GUI',
    'Drive Removed',
    'Free Space',
    'Media Inserted',
    'Media Removed',
    'Make Directory',
    'Network Share',
    'Network Unshare',
    'Folder Rename',
    'Item Rename',
    'Remove Directory',
    'Server Disconnect',
    'Update Directory',
    'Update Image',
    'Update Item'
  );

// const
var
  // General Error message
  S_ERROR: WideString = 'Error';

  // Strings that format the Details view in KB. Only applies if toShellColumnDetails
  // is not used.
  STR_FILE_SIZE_IN_KB: WideString = '%.0n KB';
  STR_ZERO_KB: WideString = '0 KB';
  STR_ONE_KB: WideString = '1 KB';

  // Strings that are used to show the attributes of a file in Details view.  Only
  // applies if toShellColumnDetails is not used.
  STR_ARCHIVE: WideString = 'A';
  STR_HIDDEN: WideString = 'H';
  STR_READONLY: WideString = 'R';
  STR_SYSTEM: WideString = 'S';
  STR_COMPRESS: WideString = 'C';

  // What is displayed in the FileType column if VET could not get the information
  // the normal way and it had determined that the item is a system folder.
  STR_SYSTEMFOLDER: WideString = 'System Folder';
  STR_FILE: WideString = ' File'; // NT is lax in the FileType column if the file is not registered
                                  // it returns nothing.  This is tacked on the end of the file extension
                                  // for example 'PAS Files', BAK Files, ZIP Files and so on.

  // The verb sent to the context menu notification events if the selected context
  // menu item is a non standard verb.
  STR_UNKNOWNCOMMAN: WideString = 'Unknown Command';

  // Shown when an operation in the TNamspace is being done on item that are not the
  // direct children of the TNamespace.  This is only a debugging aid, if the tree
  // is set up right this should never occur, i.e. restricted multiselect to one level
  STR_ERR_BAD_PIDL_RELATIONSHIP: WideString = 'PIDLs to operate on are not siblings of the Namespace doing the operation.';


  // The name given a new folder when CreateNewFolder is called.
  STR_NEWFOLDER: WideString = 'New Folder';

  STR_DRIVELETTER_A: WideString = 'a';

  // --------------------------------------------------------------------------
  // VirtualShellLink strings
  // --------------------------------------------------------------------------
  // Message shown if an attempt to create a new link is made with no target defined
  S_NOTARGETDEFINED: WideString = 'No target application defined';
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // Common strings
  // --------------------------------------------------------------------------

  S_PRINT: WideString = 'print';
  S_PROPERTIES: WideString = 'properties';

  // --------------------------------------------------------------------------


  // ASSERT Strings
  S_KERNELNOTIFERREGISTERED: WideString = 'A KernelChangeNotifier is still registered with a Control';
  S_SHELLNOTIFERREGISTERED: WideString = 'A ShellChangeThread is still registered with a Control';
  S_SHELLNOTIFERDISPATCHTHREAD: WideString = 'ChangeDispatchThread is still registered';
  S_KERNELSPECIALFOLDERWATCH: WideString = 'A control must be registered with ' +
     'the VirtualChangeNotifier using RegisterShellChangeNotify before this ' +
     'method may be used.';

implementation

end.
