@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

rem TODO rclone到pCloud 

set msg=備份完畢 
if exist "%msgExe%" (
	"%msgExe%" ^* "%msg%" 
)else (
	echo %msg% 
	echo 請按任意鍵退出... 
	pause>nul
)
exit

rem 初始化備份路徑 
:initialBackupCloud
set backupPath=%backupRoot%\%cloudName%
set cloudFilePath=%cloudFile%\%cloudName%
if not exist "%backupPath%" (
	mkdir "%backupPath%"
)
goto :eof