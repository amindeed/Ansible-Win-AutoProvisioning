' This is a launcher script that hides PowerShell console Window
' File Name: EXEC_PS1_SCRIPTS.vbs

' For only one script:
command = "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File D:\AppServ\nodejs\set_NODEJS_HOME.ps1"

 set shell = CreateObject("WScript.Shell")
 shell.Run command,0
