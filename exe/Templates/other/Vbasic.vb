Attribute VB_Name = "Module1"
# If WIN16 Then
    Declare Function OSWritePrivateProfileString% Lib "KERNEL" Alias "WritePrivateProfileString" (ByVal AppName$, ByVal KeyName$, ByVal keydefault$, ByVal FileName$)
    Declare Function OSGetPrivateProfileString% Lib "KERNEL" Alias "GetPrivateProfileString" (ByVal AppName$, ByVal KeyName$, ByVal keydefault$, ByVal ReturnString$, ByVal NumBytes As Integer, ByVal FileName$)
# Else
    Declare Function OSWritePrivateProfileString% Lib "Kernel32" Alias "WritePrivateProfileStringA" (ByVal AppName$, ByVal KeyName$, ByVal keydefault$, ByVal FileName$)
    Declare Function OSGetPrivateProfileString% Lib "Kernel32" Alias "GetPrivateProfileStringA" (ByVal AppName$, ByVal KeyName$, ByVal keydefault$, ByVal ReturnString$, ByVal NumBytes As Integer, ByVal FileName$)
# End If


'How many entries are we going to allow in the ListBox? One modification
'is to let the user set the number of entries we keep.
Private NumberOfEntries As Long

Sub Main()
Dim ReturnString As String
'--- Check to see if we are in the VB.INI File.  If not, Add ourselves to the INI file
    # If WIN16 Then
        Section$ = "Add-Ins16"
    # Else
        Section$ = "Add-Ins32"
    # End If
    ReturnString = String$(255, Chr$(0))
    ErrCode = OSGetPrivateProfileString(Section$, "Sample.FileEventSpy", "NotFound", ReturnString, Len(ReturnString) + 1, "VB.INI")
    If Left(ReturnString, InStr(ReturnString, Chr(0)) - 1) = "NotFound" Then
        ErrCode = OSWritePrivateProfileString%(Section$, "Sample.FileEventSpy", "0", "VB.INI")
    End If
    SpyShow.Show
    About.Show
    NumberOfEntries = 100
End Sub

'This subroutine essentially adds the passed string to the listbox, and then
'deletes the oldest entries if the number of entries exceeds the limit
Sub AddEntry(AddString As String)
    SpyShow.List1.AddItem (AddString)
    While SpyShow.List1.ListCount > NumberOfEntries
        SpyShow.List1.RemoveItem 0
    Wend
End Sub