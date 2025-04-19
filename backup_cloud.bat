@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

set cloudFile=C:\backupPhoneAndCloud\cloudFile
set usbBackupDisc=E:
set backupRoot=%usbBackupDisc%\backup_cloud

rem 先檢查是否插入隨身碟 
call util.bat "checkIsHasUsb" "%usbBackupDisc%"

rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot%" (
	mkdir "%backupRoot%"
)
rem ==============================以下為s06152210的檔案===================================== 
set cloudName=s06152210
call :initialBackupCloud

rem 備份Journal 
set fileName=Journal
call util.bat "copyFile" "%backupPath%" "%cloudFilePath%" "%fileName%"

rem 備份ファイル 
set fileName=ファイル
call util.bat "copyFile" "%backupPath%" "%cloudFilePath%" "%fileName%"

rem 備份プリント 
set fileName=プリント
call util.bat "copyFile" "%backupPath%" "%cloudFilePath%" "%fileName%"

rem 備份宿題 
set fileName=宿題
call util.bat "copyFile" "%backupPath%" "%cloudFilePath%" "%fileName%"
rem ==============================以下為s06152210的檔案===================================== 
rem ==============================以下為s94062826的檔案===================================== 
set cloudName=s94062826
call :initialBackupCloud

rem 備份程式介接 
set fileName=程式介接
call util.bat "copyFile" "%backupPath%" "%cloudFilePath%" "%fileName%"

rem 備份旅遊記帳.xlsx 
set fileName=旅遊記帳.xlsx
call util.bat "copyFile" "%backupPath%" "%cloudFilePath%" "%fileName%"
rem ==============================以下為s94062826的檔案===================================== 

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