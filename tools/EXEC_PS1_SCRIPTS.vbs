' This is a launcher script that hides PowerShell console Window
' File Name: EXEC_PS1_SCRIPTS.vbs

' For only one script:
command = "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass C:\command1.ps1"

' For multiple scripts to be executed successively (wrapped line):
' command = "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass C:\command1.ps1 ; " & _
' "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass C:\command2.ps1"

' For multiple scripts to be executed successively (single line):
' command = "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass C:\command1.ps1 ; " & "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass C:\command2.ps1"

 set shell = CreateObject("WScript.Shell")
 shell.Run command,0
