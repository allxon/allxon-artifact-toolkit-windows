@echo off
@whoami /groups | find "S-1-16-12288" > nul && goto :admin
ECHO =============================
ECHO Running Admin shell
ECHO =============================
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

:: Create vbs to invoke UAC
SET "ELEVATE_CMDLINE=cd /d "%~dp0" & call "%~f0" %*"
ECHO Set objShell = CreateObject("Shell.Application") 1>temp.vbs
ECHO Set objWshShell = WScript.CreateObject("WScript.Shell") 1>>temp.vbs
ECHO Set objWshProcessEnv = objWshShell.Environment("PROCESS") 1>>temp.vbs
ECHO strCommandLine = Trim(objWshProcessEnv("ELEVATE_CMDLINE")) 1>>temp.vbs
ECHO objShell.ShellExecute "cmd", "/c " ^& strCommandLine, "", "runas" 1>>temp.vbs
cscript //nologo temp.vbs & del temp.vbs & exit /b

:admin
powershell -executionpolicy Bypass -file ota_test.ps1 %1