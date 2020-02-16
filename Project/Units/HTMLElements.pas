unit HTMLElements;   //Unit

interface

Type
 THTMLTag = Record
  Name,Scope : String;
  Close : Byte;
  Comment : String;
 end;

Const
 PerlTags : Array[0..229] of string = (
'abs VALUE',
'accept NEWSOCKET,GENERICSOCKET',
'alarm SECONDS',
'atan2 Y,X',
'bind SOCKET,NAME',
'binmode FILEHANDLE, DISCIPLINE',
'binmode FILEHANDLE',
'bless REF,CLASSNAME',
'bless REF',
'caller EXPR',
'chdir EXPR',
'chmod LIST',
'chomp VARIABLE',
'chomp LIST',
'chop VARIABLE',
'chop LIST',
'chown LIST',
'chr NUMBER',
'chroot FILENAME',
'close FILEHANDLE',
'closedir DIRHANDLE',
'connect SOCKET,NAME',
'continue BLOCK',
'cos EXPR',
'crypt PLAINTEXT,SALT',
'dbmclose HASH',
'dbmopen HASH,DBNAME,MASK',
'defined EXPR',
'delete EXPR',
'die LIST',
'do BLOCK',
'do SUBROUTINE(LIST)',
'do EXPR',
'dump LABEL',
'each HASH',
'eof FILEHANDLE',
'eof ()',
'eval EXPR',
'eval BLOCK',
'exec LIST',
'exec PROGRAM LIST',
'exists EXPR',
'exit EXPR',
'exp EXPR',
'fcntl FILEHANDLE,FUNCTION,SCALAR',
'fileno FILEHANDLE',
'flock FILEHANDLE,OPERATION',
'formline PICTURE,LIST',
'getc FILEHANDLE',
'getpeername SOCKET',
'getpgrp PID',
'getpriority WHICH,WHO',
'getpwnam NAME',
'getgrnam NAME',
'gethostbyname NAME',
'getnetbyname NAME',
'getprotobyname NAME',
'getpwuid UID',
'getgrgid GID',
'getservbyname NAME,PROTO',
'gethostbyaddr ADDR,ADDRTYPE',
'getnetbyaddr ADDR,ADDRTYPE',
'getprotobynumber NUMBER',
'getservbyport PORT,PROTO',
'sethostent STAYOPEN',
'setnetent STAYOPEN',
'setprotoent STAYOPEN',
'setservent STAYOPEN',
'getsockname SOCKET',
'getsockopt SOCKET,LEVEL,OPTNAME',
'glob EXPR',
'gmtime EXPR',
'goto LABEL',
'goto EXPR',
'goto &NAME',
'grep BLOCK LIST',
'grep EXPR,LIST',
'hex EXPR',
'index STR,SUBSTR,POSITION',
'index STR,SUBSTR',
'int EXPR',
'ioctl FILEHANDLE,FUNCTION,SCALAR',
'join EXPR,LIST',
'keys HASH',
'kill SIGNAL, LIST',
'last LABEL',
'lc EXPR',
'lcfirst EXPR',
'length EXPR',
'link OLDFILE,NEWFILE',
'listen SOCKET,QUEUESIZE',
'local EXPR',
'localtime EXPR',
'log EXPR',
'lstat FILEHANDLE',
'lstat EXPR',
'map BLOCK LIST',
'map EXPR,LIST',
'mkdir FILENAME,MASK',
'mkdir FILENAME',
'msgctl ID,CMD,ARG',
'msgget KEY,FLAGS',
'msgrcv ID,VAR,SIZE,TYPE,FLAGS',
'msgsnd ID,MSG,FLAGS',
'my EXPR',
'my EXPR : ATTRIBUTES',
'next LABEL',
'no Module LIST',
'oct EXPR',
'open FILEHANDLE,MODE,LIST',
'open FILEHANDLE,EXPR',
'open FILEHANDLE',
'opendir DIRHANDLE,EXPR',
'ord EXPR',
'our EXPR',
'pack TEMPLATE,LIST',
'package NAMESPACE',
'pipe READHANDLE,WRITEHANDLE',
'pop ARRAY',
'pos SCALAR',
'print FILEHANDLE LIST',
'print LIST',
'printf FILEHANDLE FORMAT, LIST',
'printf FORMAT, LIST',
'prototype FUNCTION',
'push ARRAY,LIST',
'quotemeta EXPR',
'rand EXPR',
'read FILEHANDLE,SCALAR,LENGTH,OFFSET',
'read FILEHANDLE,SCALAR,LENGTH',
'readdir DIRHANDLE',
'readline EXPR',
'readlink EXPR',
'readpipe EXPR',
'recv SOCKET,SCALAR,LENGTH,FLAGS',
'redo LABEL',
'ref EXPR',
'rename OLDNAME,NEWNAME',
'require VERSION',
'require EXPR',
'reset EXPR',
'return EXPR',
'reverse LIST',
'rewinddir DIRHANDLE',
'rindex STR,SUBSTR,POSITION',
'rindex STR,SUBSTR',
'rmdir FILENAME',
'scalar EXPR',
'seek FILEHANDLE,POSITION,WHENCE',
'seekdir DIRHANDLE,POS',
'select FILEHANDLE',
'select RBITS,WBITS,EBITS,TIMEOUT',
'semctl ID,SEMNUM,CMD,ARG',
'semget KEY,NSEMS,FLAGS',
'semop KEY,OPSTRING',
'send SOCKET,MSG,FLAGS,TO',
'send SOCKET,MSG,FLAGS',
'setpgrp PID,PGRP',
'setpriority WHICH,WHO,PRIORITY',
'setsockopt SOCKET,LEVEL,OPTNAME,OPTVAL',
'shift ARRAY',
'shmctl ID,CMD,ARG',
'shmget KEY,SIZE,FLAGS',
'shmread ID,VAR,POS,SIZE',
'shmwrite ID,STRING,POS,SIZE',
'shutdown SOCKET,HOW',
'sin EXPR',
'sleep EXPR',
'socket SOCKET,DOMAIN,TYPE,PROTOCOL',
'socketpair SOCKET1,SOCKET2,DOMAIN,TYPE,PROTOCOL',
'sort SUBNAME LIST',
'sort BLOCK LIST',
'sort LIST',
'splice ARRAY,OFFSET,LENGTH,LIST',
'splice ARRAY,OFFSET,LENGTH',
'splice ARRAY,OFFSET',
'splice ARRAY',
'split /PATTERN/,EXPR,LIMIT',
'split /PATTERN/,EXPR',
'split /PATTERN/',
'sprintf FORMAT, LIST',
'sqrt EXPR',
'srand EXPR',
'stat FILEHANDLE',
'stat EXPR',
'study SCALAR',
'sub BLOCK',
'sub NAME',
'sub NAME BLOCK',
'substr EXPR,OFFSET,LENGTH,REPLACEMENT',
'substr EXPR,OFFSET,LENGTH',
'substr EXPR,OFFSET',
'symlink OLDFILE,NEWFILE',
'syscall LIST',
'sysopen FILEHANDLE,FILENAME,MODE',
'sysopen FILEHANDLE,FILENAME,MODE,PERMS',
'sysread FILEHANDLE,SCALAR,LENGTH,OFFSET',
'sysread FILEHANDLE,SCALAR,LENGTH',
'sysseek FILEHANDLE,POSITION,WHENCE',
'system LIST',
'system PROGRAM LIST',
'syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET',
'syswrite FILEHANDLE,SCALAR,LENGTH',
'syswrite FILEHANDLE,SCALAR',
'tell FILEHANDLE',
'telldir DIRHANDLE',
'tie VARIABLE,CLASSNAME,LIST',
'tied VARIABLE',
'truncate FILEHANDLE,LENGTH',
'truncate EXPR,LENGTH',
'uc EXPR',
'ucfirst EXPR',
'umask EXPR',
'undef EXPR',
'unlink LIST',
'unpack TEMPLATE,EXPR',
'untie VARIABLE',
'unshift ARRAY,LIST',
'use Module VERSION LIST',
'use Module VERSION',
'use Module LIST',
'use Module',
'use VERSION',
'utime LIST',
'values HASH',
'vec EXPR,OFFSET,BITS',
'waitpid PID,FLAGS',
'warn LIST',
'write FILEHANDLE',
'write EXPR'
 );

 HTMLTags : Array[0..140] of THTMLTag = (
(Name:'!'; Scope:'no-scope'; Close: 1; Comment: 'Indicates a comment that is not displayed.'),
(Name:'!DOCTYPE'; Scope:'first'; Close: 0; Comment: 'Specifies the HTML document type definition (DTD) to which the document corresponds.'),
(Name:'a'; Scope:'inline'; Close: 1; Comment: 'Designates the start or destination of a hypertext link.'),
(Name:'acronym'; Scope:'inline'; Close: 1; Comment: 'Indicates an acronym abbreviation.'),
(Name:'address'; Scope:'block'; Close: 1; Comment: 'Specifies information, such as address, signature, and authorship, of the current document.'),
(Name:'applet'; Scope:'block'; Close: 1; Comment: 'Places executable content (JAVA) on the page.'),
(Name:'area'; Scope:'MAP'; Close: 1; Comment: 'Defines the shape, coordinates, and associated URL of one hyperlink region within a client-side image MAP.'),
(Name:'attribute'; Scope:'script'; Close: 2; Comment: 'Represents an attribute or property of an HTML element as an object.'),
(Name:'b'; Scope:'inline'; Close: 1; Comment: 'Specifies that the text should be rendered in bold.'),
(Name:'base'; Scope:'HEAD'; Close: 0; Comment: 'Specifies an explicit URL used to resolve links and references to external sources such as images and style sheets.'),
(Name:'basefont'; Scope:'HEAD'; Close: 0; Comment: 'Sets the base font value to be used as the default font when rendering text.'),
(Name:'bdo'; Scope:'inline'; Close: 1; Comment: 'Allows authors to disable the bidirectional algorithm for selected fragments of text.'),
(Name:'bgsound'; Scope:'HEAD'; Close: 0; Comment: 'Enables pages with background sounds or soundtracks to be created.'),
(Name:'big'; Scope:'inline'; Close: 1; Comment: 'Specifies that the enclosed text should be displayed in a larger font than the current font.'),
(Name:'blockquote'; Scope:'block'; Close: 1; Comment: 'Sets apart a quotation in text.'),
(Name:'body'; Scope:'block'; Close: 1; Comment: 'Specifies the beginning and end of the document body.'),
(Name:'br'; Scope:'inline'; Close: 0; Comment: 'Inserts a line break.'),
(Name:'button'; Scope:'inline'; Close: 1; Comment: 'Specifies a container for rich HTML that is rendered as a button.'),
(Name:'caption'; Scope:'inline'; Close: 1; Comment: 'Specifies a brief description for a TABLE.'),
(Name:'center'; Scope:'block'; Close: 1; Comment: 'Centers subsequent text and images.'),
(Name:'cite'; Scope:'inline'; Close: 1; Comment: 'Indicates a citation by rendering text in italic.'),
(Name:'clientinformation'; Scope:'script'; Close: 2; Comment: 'Contains information about the Web browser.'),
(Name:'clipboarddata'; Scope:'script'; Close: 2; Comment: 'Provides access to predefined clipboard formats for use in editing operations.'),
(Name:'code'; Scope:'inline'; Close: 1; Comment: 'Specifies a code sample'),
(Name:'col'; Scope:'block'; Close: 0; Comment: 'Specifies column-based defaults for the table properties.'),
(Name:'colgroup'; Scope:'block'; Close: 0; Comment: 'Contains a group of columns.'),
(Name:'comment'; Scope:'no-scope'; Close: 1; Comment: 'Indicates a comment that is not displayed.'),
(Name:'currentstyle'; Scope:'script'; Close: 2; Comment: 'Represents the cascaded format and style of the object as specified by global style sheets, inline styles, and HTML attributes.'),
(Name:'custom'; Scope:'inline'; Close: 1; Comment: 'Represents a user-defined element.'),
(Name:'datatransfer'; Scope:'script'; Close: 2; Comment: 'Provides access to predefined clipboard formats for use in drag-and-drop operations.'),
(Name:'dd'; Scope:'block'; Close: 0; Comment: 'Indicates the definition in a definition list. The definition is usually indented in the definition list.'),
(Name:'defaults'; Scope:'script'; Close: 2; Comment: 'Programmatically sets default properties on an Element Behavior.'),
(Name:'del'; Scope:'inline'; Close: 1; Comment: 'Indicates that text has been deleted from the document.'),
(Name:'dfn'; Scope:'inline'; Close: 1; Comment: 'Indicates the defining instance of a term.'),
(Name:'dir'; Scope:'block'; Close: 1; Comment: 'Denotes a directory list.'),
(Name:'div'; Scope:'block'; Close: 1; Comment: 'Specifies a container that renders HTML..'),
(Name:'dl'; Scope:'block'; Close: 1; Comment: 'Denotes a definition list.'),
(Name:'document'; Scope:'script'; Close: 2; Comment: 'Represents the HTML document in a given browser window'),
(Name:'dt'; Scope:'block'; Close: 0; Comment: 'Indicates a definition term within a definition list'),
(Name:'em'; Scope:'inline'; Close: 1; Comment: 'Emphasizes text, usually by rendering it in italic.'),
(Name:'embed'; Scope:'block'; Close: 0; Comment: 'Allows documents of any type to be embedded.'),
(Name:'event'; Scope:'script'; Close: 2; Comment: 'Represents the state of an event, such as the element in which the event occurred, the state of the keyboard keys, the location of the mouse and the state of the mouse buttons.'),
(Name:'external'; Scope:'script'; Close: 2; Comment: 'Allows access to an additional object provided by host applications of the MS IE browser components.'),
(Name:'fieldset'; Scope:'block'; Close: 1; Comment: 'Draws a box around the text and other elements that the field set contains.'),
(Name:'font'; Scope:'inline'; Close: 1; Comment: 'Specifies a new font, size, and color to be used for rendering the enclosed text'),
(Name:'form'; Scope:'block'; Close: 1; Comment: 'Specifies that the contained controls take part in a form.'),
(Name:'frame'; Scope:'block'; Close: 1; Comment: 'Specifies an individual frame within FRAMESET element.'),
(Name:'frameset'; Scope:'block'; Close: 1; Comment: 'Specifies a frameset, which is used to organize multiple frames and nested framesets.'),
(Name:'h1'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style.'),
(Name:'h2'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style.'),
(Name:'h3'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style'),
(Name:'h4'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style.'),
(Name:'h5'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style'),
(Name:'h6'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style'),
(Name:'head'; Scope:'block'; Close: 1; Comment: 'Provides an unordered collection of information about the document.'),
(Name:'history'; Scope:'script'; Close: 2; Comment: 'Contains information about the URLs visited by the client'),
(Name:'hr'; Scope:'block'; Close: 1; Comment: 'Draws a horizontal rule.'),
(Name:'html'; Scope:''; Close: 1; Comment: 'Identifies the document as containing HTML elements.'),
(Name:'i'; Scope:'inline'; Close: 1; Comment: 'Specifies that the text should be rendered in italic, where available.'),
(Name:'iframe'; Scope:'block'; Close: 1; Comment: 'Creates inline floating frames.'),
(Name:'img'; Scope:'inline'; Close: 1; Comment: 'Embeds an image or a video clip in the document.'),
(Name:'input'; Scope:'inline'; Close: 0; Comment: 'Creates a variety of input controls'),
(Name:'input type=button'; Scope:'inline'; Close: 0; Comment: 'Creates a button control.'),
(Name:'input type=checkbox'; Scope:'inline'; Close: 0; Comment: 'Creates a check box control.'),
(Name:'input type=file'; Scope:'inline'; Close: 0; Comment: 'Creates a file upload object with a text box and Browse button.'),
(Name:'input type=hidden'; Scope:'inline'; Close: 0; Comment: 'Transmits state information about client/server interaction.'),
(Name:'input type=image'; Scope:'inline'; Close: 0; Comment: 'Creates an image control that, when clicked, causes the form to be immediately submitted.'),
(Name:'input type=password'; Scope:'inline'; Close: 0; Comment: 'Creates a single-line text entry control similar to the INPUT control, except that text is not displayed as the user enters it.'),
(Name:'input type=radio'; Scope:'inline'; Close: 0; Comment: 'Creates a radio button control.'),
(Name:'input type=reset'; Scope:'inline'; Close: 0; Comment: 'Creates a button that, when clicked, resets the form''s controls to their initial values.'),
(Name:'input type=submit'; Scope:'inline'; Close: 0; Comment: 'Creates a button that, when clicked, submits the form.'),
(Name:'input type=text'; Scope:'inline'; Close: 0; Comment: 'Creates a single-line text entry control.'),
(Name:'ins'; Scope:'inline'; Close: 0; Comment: 'Specifies text that has been inserted into the document.'),
(Name:'isindex'; Scope:'inline'; Close: 0; Comment: 'Causes the browser to display a dialog window that prompts the user for a single line of input'),
(Name:'kbd'; Scope:'inline'; Close: 1; Comment: 'Renders a text in fixed-width font.'),
(Name:'label'; Scope:'inline'; Close: 1; Comment: 'Specifies a label for another element on the page'),
(Name:'legend'; Scope:'block'; Close: 1; Comment: 'Inserts a caption into the box drawn by the FIELDSET object.'),
(Name:'li'; Scope:'inline'; Close: 0; Comment: 'Denotes one item in a list.'),
(Name:'link'; Scope:'HEAD'; Close: 0; Comment: 'Enables the current document to establish links to external documents.'),
(Name:'listing'; Scope:'block'; Close: 1; Comment: 'Renders text in a fixed-with font. Obsolete use PRE or SAMP tag instead.'),
(Name:'location'; Scope:'script'; Close: 2; Comment: 'Contains information about the current URL.'),
(Name:'map'; Scope:'no-scope'; Close: 1; Comment: 'Contains coordinate data for client-side image maps.'),
(Name:'marquee'; Scope:'block'; Close: 1; Comment: 'Creates a scrolling text marquee.'),
(Name:'menu'; Scope:'block'; Close: 1; Comment: 'Creates an unordered list of items.'),
(Name:'meta'; Scope:'HEAD'; Close: 0; Comment: 'Conveys hidden information about the document to the server and the client'),
(Name:'namespace'; Scope:'script'; Close: 2; Comment: 'Dynamically imports an Element Behavior into a document.'),
(Name:'navigator'; Scope:'script'; Close: 2; Comment: 'Contains information about the Web browser.'),
(Name:'nextid'; Scope:'HEAD'; Close: 2; Comment: 'Creates unique identifiers that text editing software can read.'),
(Name:'nobr'; Scope:'block'; Close: 1; Comment: 'Renders text without line breaks'),
(Name:'noframes'; Scope:'block'; Close: 1; Comment: 'Contains HTML for browsers that do not support FRAMESET elements.'),
(Name:'noscript'; Scope:'block'; Close: 1; Comment: 'Specifies HTML to be displayed in browsers that do not support scripting.'),
(Name:'object'; Scope:'block'; Close: 1; Comment: 'Inserts an object into the HTML page.'),
(Name:'ol'; Scope:'block'; Close: 1; Comment: 'Draws lines of text as a numbered list.'),
(Name:'option'; Scope:'SELECT'; Close: 0; Comment: 'Denotes one choice in a SELECT element.'),
(Name:'p'; Scope:'block'; Close: 0; Comment: 'Denotes a paragraph.'),
(Name:'page'; Scope:'styles'; Close: 2; Comment: 'Represents a  rule within a styleSheet.'),
(Name:'param'; Scope:'APPLET'; Close: 0; Comment: 'Stets the initial value of a property for an APPLET, EMBED or OBJECT element.'),
(Name:'plaintext'; Scope:'block'; Close: 1; Comment: 'Renders text in a fixed-width font without processing tags.'),
(Name:'popup'; Scope:'script'; Close: 2; Comment: 'A special type of overlapped window typically used for dialog boxes, message boxes, and other temporary windows that appear separate from an application''s main window.'),
(Name:'pre'; Scope:'block'; Close: 1; Comment: 'Renders Text in a fixed-width font.'),
(Name:'q'; Scope:'inline'; Close: 1; Comment: 'Sets apart a quotation in text.'),
(Name:'rt'; Scope:'inline'; Close: 0; Comment: 'Designates the ruby test for the RUBY element.'),
(Name:'ruby'; Scope:'inline'; Close: 1; Comment: 'Designates an annotation or pronunciation guide to be placed above or inline with a string of text.'),
(Name:'rule'; Scope:'styles'; Close: 2; Comment: 'Represent a style within a CSS that consists of a selector and one ore more declaration.'),
(Name:'runtimestyle'; Scope:'styles'; Close: 2; Comment: 'Represents the cascaded format and style of the object that overrides the format and style specified in global style sheets, inline styles, and HTML attributes.'),
(Name:'s'; Scope:'inline'; Close: 1; Comment: 'Renders test in strike-through type.'),
(Name:'samp'; Scope:'inline'; Close: 1; Comment: 'Specifies a code sample.'),
(Name:'screen'; Scope:'script'; Close: 2; Comment: 'Contains information about the client''s screen and rendering capabilities.'),
(Name:'script'; Scope:'block'; Close: 1; Comment: 'Specifies a script for the page that is interpreted by a script engine.'),
(Name:'select'; Scope:'inline'; Close: 1; Comment: 'Denotes a list box or a drop-down list.'),
(Name:'selection'; Scope:'script'; Close: 2; Comment: 'Represents the active selection, which is a highlighted block of text, and/or other elements in the document on which a user or script can carry out some action.'),
(Name:'small'; Scope:'inline'; Close: 1; Comment: 'Specifies that the enclosed text should be displayed in a smaller font.'),
(Name:'span'; Scope:'inline'; Close: 1; Comment: 'Specifies an inline text container.'),
(Name:'strike'; Scope:'inline'; Close: 1; Comment: 'Renders text in strike-through type.'),
(Name:'strong'; Scope:'inline'; Close: 1; Comment: 'Renders text in bold.'),
(Name:'style'; Scope:'script'; Close: 2; Comment: 'Represents the current settings of all possible inline styles for a given element.'),
(Name:'style'; Scope:'block'; Close: 1; Comment: 'Specifies a style sheet for the page.'),
(Name:'stylesheet'; Scope:'script'; Close: 2; Comment: 'Represents a single style sheet in the document.'),
(Name:'sub'; Scope:'inline'; Close: 1; Comment: 'Specifies that the enclosed text should be displayed in subscript, using a smaller font than the current font.'),
(Name:'sup'; Scope:'inline'; Close: 1; Comment: 'Specifies that the enclosed text should be displayed in superscript, using a smaller font than the current font.'),
(Name:'table'; Scope:'inline'; Close: 1; Comment: 'Specifies that the contained content is organized into a table with rows and columns.'),
(Name:'tbody'; Scope:'block'; Close: 1; Comment: 'Designates rows as the body of the table'),
(Name:'td'; Scope:'block'; Close: 1; Comment: 'Specifies a cell in a table.'),
(Name:'textarea'; Scope:'inline'; Close: 1; Comment: 'Specifies a multiline input control.'),
(Name:'textnode'; Scope:'script'; Close: 2; Comment: 'Represents a string of text as a node in the document hierarchy.'),
(Name:'textrange'; Scope:'script'; Close: 2; Comment: 'Represents text in an HTML element.'),
(Name:'textrectangle'; Scope:'script'; Close: 2; Comment: 'Specifies a rectangle that contains a line of text in either an element or a TextRange object.'),
(Name:'tfoot'; Scope:'block'; Close: 1; Comment: 'Designates rows as the table''s footer.'),
(Name:'th'; Scope:'block'; Close: 1; Comment: 'Specifies a header column. Header columns are centered within the cell and are bold.'),
(Name:'thead'; Scope:'block'; Close: 1; Comment: 'Designates rows as the table''s header.'),
(Name:'title'; Scope:'block'; Close: 1; Comment: 'Contains the title of the document.'),
(Name:'tr'; Scope:'block'; Close: 1; Comment: 'Specifies a row in a table.'),
(Name:'tt'; Scope:'inline'; Close: 1; Comment: 'Renders text in a fixed-width font.'),
(Name:'u'; Scope:'inline'; Close: 1; Comment: 'Renders text that is underlined.'),
(Name:'ul'; Scope:'inline'; Close: 1; Comment: 'Draws lines of text as a bulleted list.'),
(Name:'userprofile'; Scope:'script'; Close: 2; Comment: 'Provides methods that allow a script to request read access and perform read actions on a user''s profile information.'),
(Name:'var'; Scope:'inline'; Close: 1; Comment: 'Renders text in a small fixed-width font.'),
(Name:'wbr'; Scope:''; Close: 0; Comment: 'Inserts a soft line break into a block of NOBR text.'),
(Name:'window'; Scope:'script'; Close: 2; Comment: 'Represents an open window in the browser.'),
(Name:'xml'; Scope:'block'; Close: 1; Comment: 'Defines an XML data island on an HTML page.'),
(Name:'xmp'; Scope:'block'; Close: 1; Comment: 'Renders text used for examples in a fixed-width font.')

{
(Name:'A'; Scope:'inline'; Close: 1; Comment: 'Designates the start or destination of a hypertext link.'),
(Name:'ACRONYM'; Scope:'inline'; Close: 1; Comment: 'Indicates an acronym abbreviation.'),
(Name:'ADDRESS'; Scope:'block'; Close: 1; Comment: 'Specifies information, such as address, signature, and authorship, of the current document.'),
(Name:'APPLET'; Scope:'block'; Close: 1; Comment: 'Places executable content (JAVA) on the page.'),
(Name:'AREA'; Scope:'MAP'; Close: 1; Comment: 'Defines the shape, coordinates, and associated URL of one hyperlink region within a client-side image MAP.'),
(Name:'Attribute'; Scope:'script'; Close: 2; Comment: 'Represents an attribute or property of an HTML element as an object.'),
(Name:'B'; Scope:'inline'; Close: 1; Comment: 'Specifies that the text should be rendered in bold.'),
(Name:'BASE'; Scope:'HEAD'; Close: 0; Comment: 'Specifies an explicit URL used to resolve links and references to external sources such as images and style sheets.'),
(Name:'BASEFONT'; Scope:'HEAD'; Close: 0; Comment: 'Sets the base font value to be used as the default font when rendering text.'),
(Name:'BDO'; Scope:'inline'; Close: 1; Comment: 'Allows authors to disable the bidirectional algorithm for selected fragments of text.'),
(Name:'BGSOUND'; Scope:'HEAD'; Close: 0; Comment: 'Enables pages with background sounds or soundtracks to be created.'),
(Name:'BIG'; Scope:'inline'; Close: 1; Comment: 'Specifies that the enclosed text should be displayed in a larger font than the current font.'),
(Name:'BLOCKQUOTE'; Scope:'block'; Close: 1; Comment: 'Sets apart a quotation in text.'),
(Name:'BODY'; Scope:'block'; Close: 1; Comment: 'Specifies the beginning and end of the document body.'),
(Name:'BR'; Scope:'inline'; Close: 0; Comment: 'Inserts a line break.'),
(Name:'BUTTON'; Scope:'inline'; Close: 1; Comment: 'Specifies a container for rich HTML that is rendered as a button.'),
(Name:'CAPTION'; Scope:'inline'; Close: 1; Comment: 'Specifies a brief description for a TABLE.'),
(Name:'CENTER'; Scope:'block'; Close: 1; Comment: 'Centers subsequent text and images.'),
(Name:'CITE'; Scope:'inline'; Close: 1; Comment: 'Indicates a citation by rendering text in italic.'),
(Name:'clientInformation'; Scope:'script'; Close: 2; Comment: 'Contains information about the Web browser.'),
(Name:'clipboardData'; Scope:'script'; Close: 2; Comment: 'Provides access to predefined clipboard formats for use in editing operations.'),
(Name:'CODE'; Scope:'inline'; Close: 1; Comment: 'Specifies a code sample'),
(Name:'COL'; Scope:'block'; Close: 0; Comment: 'Specifies column-based defaults for the table properties.'),
(Name:'COLGROUP'; Scope:'block'; Close: 0; Comment: 'Contains a group of columns.'),
(Name:'COMMENT'; Scope:'no-scope'; Close: 1; Comment: 'Indicates a comment that is not displayed.'),
(Name:'currentStyle'; Scope:'script'; Close: 2; Comment: 'Represents the cascaded format and style of the object as specified by global style sheets, inline styles, and HTML attributes.'),
(Name:'custom'; Scope:'inline'; Close: 1; Comment: 'Represents a user-defined element.'),
(Name:'dataTransfer'; Scope:'script'; Close: 2; Comment: 'Provides access to predefined clipboard formats for use in drag-and-drop operations.'),
(Name:'DD'; Scope:'block'; Close: 0; Comment: 'Indicates the definition in a definition list. The definition is usually indented in the definition list.'),
(Name:'defaults'; Scope:'script'; Close: 2; Comment: 'Programmatically sets default properties on an Element Behavior.'),
(Name:'DEL'; Scope:'inline'; Close: 1; Comment: 'Indicates that text has been deleted from the document.'),
(Name:'DFN'; Scope:'inline'; Close: 1; Comment: 'Indicates the defining instance of a term.'),
(Name:'DIR'; Scope:'block'; Close: 1; Comment: 'Denotes a directory list.'),
(Name:'DIV'; Scope:'block'; Close: 1; Comment: 'Specifies a container that renders HTML..'),
(Name:'DL'; Scope:'block'; Close: 1; Comment: 'Denotes a definition list.'),
(Name:'document'; Scope:'script'; Close: 2; Comment: 'Represents the HTML document in a given browser window'),
(Name:'DT'; Scope:'block'; Close: 0; Comment: 'Indicates a definition term within a definition list'),
(Name:'EM'; Scope:'inline'; Close: 1; Comment: 'Emphasizes text, usually by rendering it in italic.'),
(Name:'EMBED'; Scope:'block'; Close: 0; Comment: 'Allows documents of any type to be embedded.'),
(Name:'event'; Scope:'script'; Close: 2; Comment: 'Represents the state of an event, such as the element in which the event occurred, the state of the keyboard keys, the location of the mouse and the state of the mouse buttons.'),
(Name:'external'; Scope:'script'; Close: 2; Comment: 'Allows access to an additional object provided by host applications of the MS IE browser components.'),
(Name:'FIELDSET'; Scope:'block'; Close: 1; Comment: 'Draws a box around the text and other elements that the field set contains.'),
(Name:'FONT'; Scope:'inline'; Close: 1; Comment: 'Specifies a new font, size, and color to be used for rendering the enclosed text'),
(Name:'FORM'; Scope:'block'; Close: 1; Comment: 'Specifies that the contained controls take part in a form.'),
(Name:'FRAME'; Scope:'block'; Close: 1; Comment: 'Specifies an individual frame within FRAMESET element.'),
(Name:'FRAMESET'; Scope:'block'; Close: 1; Comment: 'Specifies a frameset, which is used to organize multiple frames and nested framesets.'),
(Name:'H1'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style.'),
(Name:'H2'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style.'),
(Name:'H3'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style'),
(Name:'H4'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style.'),
(Name:'H5'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style'),
(Name:'H6'; Scope:'block'; Close: 1; Comment: 'Renders a text in heading style'),
(Name:'HEAD'; Scope:'block'; Close: 1; Comment: 'Provides an unordered collection of information about the document.'),
(Name:'history'; Scope:'script'; Close: 2; Comment: 'Contains information about the URLs visited by the client'),
(Name:'HR'; Scope:'block'; Close: 1; Comment: 'Draws a horizontal rule.'),
(Name:'HTML'; Scope:''; Close: 1; Comment: 'Identifies the document as containing HTML elements.'),
(Name:'I'; Scope:'inline'; Close: 1; Comment: 'Specifies that the text should be rendered in italic, where available.'),
(Name:'IFRAME'; Scope:'block'; Close: 1; Comment: 'Creates inline floating frames.'),
(Name:'IMG'; Scope:'inline'; Close: 1; Comment: 'Embeds an image or a video clip in the document.'),
(Name:'INPUT'; Scope:'inline'; Close: 0; Comment: 'Creates a variety of input controls'),
(Name:'INPUT type=button'; Scope:'inline'; Close: 0; Comment: 'Creates a button control.'),
(Name:'INPUT type=checkbox'; Scope:'inline'; Close: 0; Comment: 'Creates a check box control.'),
(Name:'INPUT type=file'; Scope:'inline'; Close: 0; Comment: 'Creates a file upload object with a text box and Browse button.'),
(Name:'INPUT type=hidden'; Scope:'inline'; Close: 0; Comment: 'Transmits state information about client/server interaction.'),
(Name:'INPUT type=image'; Scope:'inline'; Close: 0; Comment: 'Creates an image control that, when clicked, causes the form to be immediately submitted.'),
(Name:'INPUT type=password'; Scope:'inline'; Close: 0; Comment: 'Creates a single-line text entry control similar to the INPUT control, except that text is not displayed as the user enters it.'),
(Name:'INPUT type=radio'; Scope:'inline'; Close: 0; Comment: 'Creates a radio button control.'),
(Name:'INPUT type=reset'; Scope:'inline'; Close: 0; Comment: 'Creates a button that, when clicked, resets the form''s controls to their initial values.'),
(Name:'INPUT type=submit'; Scope:'inline'; Close: 0; Comment: 'Creates a button that, when clicked, submits the form.'),
(Name:'INPUT type=text'; Scope:'inline'; Close: 0; Comment: 'Creates a single-line text entry control.'),
(Name:'INS'; Scope:'inline'; Close: 0; Comment: 'Specifies text that has been inserted into the document.'),
(Name:'ISINDEX'; Scope:'inline'; Close: 0; Comment: 'Causes the browser to display a dialog window that prompts the user for a single line of input'),
(Name:'KBD'; Scope:'inline'; Close: 1; Comment: 'Renders a text in fixed-width font.'),
(Name:'LABEL'; Scope:'inline'; Close: 1; Comment: 'Specifies a label for another element on the page'),
(Name:'LEGEND'; Scope:'block'; Close: 1; Comment: 'Inserts a caption into the box drawn by the FIELDSET object.'),
(Name:'LI'; Scope:'inline'; Close: 0; Comment: 'Denotes one item in a list.'),
(Name:'LINK'; Scope:'HEAD'; Close: 0; Comment: 'Enables the current document to establish links to external documents.'),
(Name:'LISTING'; Scope:'block'; Close: 1; Comment: 'Renders text in a fixed-with font. Obsolete use PRE or SAMP tag instead.'),
(Name:'location'; Scope:'script'; Close: 2; Comment: 'Contains information about the current URL.'),
(Name:'MAP'; Scope:'no-scope'; Close: 1; Comment: 'Contains coordinate data for client-side image maps.'),
(Name:'MARQUEE'; Scope:'block'; Close: 1; Comment: 'Creates a scrolling text marquee.'),
(Name:'MENU'; Scope:'block'; Close: 1; Comment: 'Creates an unordered list of items.'),
(Name:'META'; Scope:'HEAD'; Close: 0; Comment: 'Conveys hidden information about the document to the server and the client'),
(Name:'namespace'; Scope:'script'; Close: 2; Comment: 'Dynamically imports an Element Behavior into a document.'),
(Name:'navigator'; Scope:'script'; Close: 2; Comment: 'Contains information about the Web browser.'),
(Name:'NEXTID'; Scope:'HEAD'; Close: 2; Comment: 'Creates unique identifiers that text editing software can read.'),
(Name:'NOBR'; Scope:'block'; Close: 1; Comment: 'Renders text without line breaks'),
(Name:'NOFRAMES'; Scope:'block'; Close: 1; Comment: 'Contains HTML for browsers that do not support FRAMESET elements.'),
(Name:'NOSCRIPT'; Scope:'block'; Close: 1; Comment: 'Specifies HTML to be displayed in browsers that do not support scripting.'),
(Name:'OBJECT'; Scope:'block'; Close: 1; Comment: 'Inserts an object into the HTML page.'),
(Name:'OL'; Scope:'block'; Close: 1; Comment: 'Draws lines of text as a numbered list.'),
(Name:'OPTION'; Scope:'SELECT'; Close: 0; Comment: 'Denotes one choice in a SELECT element.'),
(Name:'P'; Scope:'block'; Close: 0; Comment: 'Denotes a paragraph.'),
(Name:'page'; Scope:'styles'; Close: 2; Comment: 'Represents a @page rule within a styleSheet.'),
(Name:'PARAM'; Scope:'APPLET'; Close: 0; Comment: 'Stets the initial value of a property for an APPLET, EMBED or OBJECT element.'),
(Name:'PLAINTEXT'; Scope:'block'; Close: 1; Comment: 'Renders text in a fixed-width font without processing tags.'),
(Name:'popup'; Scope:'script'; Close: 2; Comment: 'A special type of overlapped window typically used for dialog boxes, message boxes, and other temporary windows that appear separate from an application''s main window.'),
(Name:'PRE'; Scope:'block'; Close: 1; Comment: 'Renders Text in a fixed-width font.'),
(Name:'Q'; Scope:'inline'; Close: 1; Comment: 'Sets apart a quotation in text.'),
(Name:'RT'; Scope:'inline'; Close: 0; Comment: 'Designates the ruby test for the RUBY element.'),
(Name:'RUBY'; Scope:'inline'; Close: 1; Comment: 'Designates an annotation or pronunciation guide to be placed above or inline with a string of text.'),
(Name:'rule'; Scope:'styles'; Close: 2; Comment: 'Represent a style within a CSS that consists of a selector and one ore more declaration.'),
(Name:'runtimeStyle'; Scope:'styles'; Close: 2; Comment: 'Represents the cascaded format and style of the object that overrides the format and style specified in global style sheets, inline styles, and HTML attributes.'),
(Name:'S'; Scope:'inline'; Close: 1; Comment: 'Renders test in strike-through type.'),
(Name:'SAMP'; Scope:'inline'; Close: 1; Comment: 'Specifies a code sample.'),
(Name:'screen'; Scope:'script'; Close: 2; Comment: 'Contains information about the client''s screen and rendering capabilities.'),
(Name:'SCRIPT'; Scope:'block'; Close: 1; Comment: 'Specifies a script for the page that is interpreted by a script engine.'),
(Name:'SELECT'; Scope:'inline'; Close: 1; Comment: 'Denotes a list box or a drop-down list.'),
(Name:'selection'; Scope:'script'; Close: 2; Comment: 'Represents the active selection, which is a highlighted block of text, and/or other elements in the document on which a user or script can carry out some action.'),
(Name:'SMALL'; Scope:'inline'; Close: 1; Comment: 'Specifies that the enclosed text should be displayed in a smaller font.'),
(Name:'SPAN'; Scope:'inline'; Close: 1; Comment: 'Specifies an inline text container.'),
(Name:'STRIKE'; Scope:'inline'; Close: 1; Comment: 'Renders text in strike-through type.'),
(Name:'STRONG'; Scope:'inline'; Close: 1; Comment: 'Renders text in bold.'),
(Name:'style'; Scope:'script'; Close: 2; Comment: 'Represents the current settings of all possible inline styles for a given element.'),
(Name:'STYLE'; Scope:'block'; Close: 1; Comment: 'Specifies a style sheet for the page.'),
(Name:'styleSheet'; Scope:'script'; Close: 2; Comment: 'Represents a single style sheet in the document.'),
(Name:'SUB'; Scope:'inline'; Close: 1; Comment: 'Specifies that the enclosed text should be displayed in subscript, using a smaller font than the current font.'),
(Name:'SUP'; Scope:'inline'; Close: 1; Comment: 'Specifies that the enclosed text should be displayed in superscript, using a smaller font than the current font.'),
(Name:'TABLE'; Scope:'inline'; Close: 1; Comment: 'Specifies that the contained content is organized into a table with rows and columns.'),
(Name:'TBODY'; Scope:'block'; Close: 1; Comment: 'Designates rows as the body of the table'),
(Name:'TD'; Scope:'block'; Close: 1; Comment: 'Specifies a cell in a table.'),
(Name:'TEXTAREA'; Scope:'inline'; Close: 1; Comment: 'Specifies a multiline input control.'),
(Name:'TextNode'; Scope:'script'; Close: 2; Comment: 'Represents a string of text as a node in the document hierarchy.'),
(Name:'TextRange'; Scope:'script'; Close: 2; Comment: 'Represents text in an HTML element.'),
(Name:'TextRectangle'; Scope:'script'; Close: 2; Comment: 'Specifies a rectangle that contains a line of text in either an element or a TextRange object.'),
(Name:'TFOOT'; Scope:'block'; Close: 1; Comment: 'Designates rows as the table''s footer.'),
(Name:'TH'; Scope:'block'; Close: 1; Comment: 'Specifies a header column. Header columns are centered within the cell and are bold.'),
(Name:'THEAD'; Scope:'block'; Close: 1; Comment: 'Designates rows as the table''s header.'),
(Name:'TITLE'; Scope:'block'; Close: 1; Comment: 'Contains the title of the document.'),
(Name:'TR'; Scope:'block'; Close: 1; Comment: 'Specifies a row in a table.'),
(Name:'TT'; Scope:'inline'; Close: 1; Comment: 'Renders text in a fixed-width font.'),
(Name:'U'; Scope:'inline'; Close: 1; Comment: 'Renders text that is underlined.'),
(Name:'UL'; Scope:'inline'; Close: 1; Comment: 'Draws lines of text as a bulleted list.'),
(Name:'userProfile'; Scope:'script'; Close: 2; Comment: 'Provides methods that allow a script to request read access and perform read actions on a user''s profile information.'),
(Name:'VAR'; Scope:'inline'; Close: 1; Comment: 'Renders text in a small fixed-width font.'),
(Name:'WBR'; Scope:''; Close: 0; Comment: 'Inserts a soft line break into a block of NOBR text.'),
(Name:'window'; Scope:'script'; Close: 2; Comment: 'Represents an open window in the browser.'),
(Name:'XML'; Scope:'block'; Close: 1; Comment: 'Defines an XML data island on an HTML page.'),
(Name:'XMP'; Scope:'block'; Close: 1; Comment: 'Renders text used for examples in a fixed-width font.')
}
 );
implementation

end.