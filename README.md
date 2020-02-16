

![logo](https://raw.githubusercontent.com/wiki/hakakou/optiperl/logo.gif)



**Latest Version: 5.5.62**

*OptiPerl will help you create Perl scripts, offline in Windows. It is a fully integrated developing environment for creating, testing, debugging and running perl scripts, directly or through associated html documents.*

OptiPerl was a commercial application for Windows, developed between the years 1999 and 2008. As we don't support it any more, we have released the source code.

You'll probably find various "trial" versions on the internet from different download sites that have not been updated, and list this software since 2008. You can safely ignore them and install the binary below, or compile from the source code uploaded on GitHub.

If you were a customer of OptiPerl and bought the full version, you'll notice that the update and activation links do not work any more on the version you had purchased. Please uninstall, and use the binary version here.

**Although developed for older version of Windows, you can still use OptiPerl for all Perl 5.x versions.** We have extensively tested in Window 10 with Strawberry Perl 5.30.1.1-32bit.

***Features in OptiPerl***

* Offline editing of CGI Perl Scripts.

* Complete emulation of a real server - scripts can be run indirectly from html documents.

* Live preview of the scripts in the internal web browser.

* Feature packed editor with syntax highlighting.

* Completely integrated debugging with live evaluation of expressions, watches, breakpoints, flow control.

* Remote debugging of scripts located on your web server, remote machine or via loopback.

* Code completion, and hints while programming.

* Automatic syntax checking.

* Box and line coding give a better view of your code.

* Saveable desktops.

* Code librarian that supports ZIP files and code templates.

* Context sensitive help on core perl and module documentation.

* Powerful query editor to create the environment and data sent when calling CGI scripts.

* Many tools like Text encoder, Perl printer, Pod viewer and other.

* Projects to organize and publish a set of scripts.

* Version converter to handle non supported perl functions in windows.

* Opening, saving and running scripts on remote servers.

* Sendmail and date debugging under windows.

* Printing script and exporting as HTML with syntax highlighting.

* Searching and replacing with regular expressions in projects and files.

* Backups using Zip files.

* File and Remote (FTP & Secure FTP) explorer.

* Plug-Ins.

  

# Binary Release

# How to compile OptiPerl

OptiPerl was written using Delphi 7. To compile, you'll need to install Delphi 7 (newer versions are not supported).

1. Checkout everything to the folder C:\OptiPerl. This is because many paths are hardcoded into various project options.
2. Run Delphi 7 and ensure it's working.
3. Menu "Tools" → "Environment Options", "Library" tab. Set the following paths:

   - Library path: `C:\OptiPerl\CommonDelphi;c:\OptiPerl\CommonDCU\;$(DELPHI)\Lib;$(DELPHI)\Bin;$(DELPHI)\Imports;$(DELPHI)\Projects\Bpl;c:\OptiPerl\Bin\;c:\OptiPerl\Haka Library;c:\OptiPerl\Haka Components;c:\OptiPerl\Library\Assorted;c:\OptiPerl\Library\Console;c:\OptiPerl\Library\kbmmemtab;c:\OptiPerl\Library\zip\Vcl;c:\OptiPerl\Library\rmDiff;c:\OptiPerl\Library\DragDrop;C:\OptiPerl\Library\RunTime;c:\OptiPerl\Library\VirtualTrees\Source;c:\OptiPerl\Library\KAPars;C:\OptiPerl\Library\Jvcl\source;C:\OptiPerl\Library\JCL;C:\OptiPerl\Library\JCL\source;c:\OptiPerl\Library\Jvcl\dcu\;c:\OptiPerl\Library\DIPcre\Source\;c:\OptiPerl\Library\VirtualShellTools\Source\;`
   - BPL output directory: `c:\OptiPerl\Bin\`
   - DCP output directory: `c:\OptiPerl\Bin\`
4. Click Menu "Component" → "Install Packages". Click "Add", and select all *.bpl files in c:\OptiPerl\Bin. Ignore any warning when adding components.
5. "File" → "Open Project" choose: `c:\OptiPerl\OptiPerl Project.bpg`
6. In the Project manager window, set "OptiPerl.exe" as Active (click toolbar button "Activate")
7. Menu "Project" → "Build All". Should build without any errors.

Now all output exe should be located in the folder `c:\OptiPerl\exe\`. This also contains various files and folders that are needed to run.

You can also try "Run" → "Run".

To build installer:

1. Install Inno Setup 5.3.6 at http://files.jrsoftware.org/is/5/isetup-5.3.6.exe
2. Open `Inst-OptiPerl.iss` with Inno Setup and compile installer. The installer (exe file) will be compiled to the Output folder.



   

