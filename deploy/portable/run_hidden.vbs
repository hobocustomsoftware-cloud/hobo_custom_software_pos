' HoBo POS - Run without console window (optional launcher)
' Double-click or: cscript run_hidden.vbs
Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
WshShell.Run "cmd /c launch.bat", 0, False
