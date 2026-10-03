@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

set cloudFile=C:\backupPhoneAndCloud\cloudFile
set diskBackupDisc=E:
set backupRoot=%diskBackupDisc%\backup_cloud

rem 先檢查是否插入備份硬碟 
call util.bat "checkIsHasDisk" "%diskBackupDisc%"

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

rem 2026.10.03 增加刪除雲端資料夾內所有檔案 
call :deleteCloudFile
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

rem 2026.10.03 增加刪除雲端資料夾內所有檔案 
call :deleteCloudFile
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

rem 刪除雲端資料夾內所有檔案 
:deleteCloudFile
if exist "%cloudFilePath%" (
	echo 開始刪除【%cloudFilePath%】內的檔案...
	rem 整個刪除後重建同名空目錄，達到清空內容、保留目錄 
	rd /s /q "%cloudFilePath%"
	mkdir "%cloudFilePath%"
	echo 【%cloudFilePath%】內的檔案刪除完畢
)
goto :eof