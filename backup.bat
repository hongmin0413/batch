@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

rem 若不備份某一路徑，直接註解即可 
set backupRoot=C:\backup
set otherBackupRoot1=D:\backup
set usbBackupDisc1=E:
set otherBackupRoot2=%usbBackupDisc1%\backup_computer
set usbBackupDisc2=F:
set otherBackupRoot3=%usbBackupDisc2%\backup_computer
set backupBackup=history
rem 讀取config.ini並設為參數
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i

echo 即將備份重要資料，請插入隨身碟，若要完整備份，請先關閉相關應用程式 
echo 請按任意鍵繼續... 
pause>nul

rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot%" (
	mkdir "%backupRoot%"
)
rem ==============================以下為桌面的檔案===================================== 
:disc_desktop
set fileDisc=C:\Users\User\OneDrive\桌面
set backupDiscName=disc-desktop
call :initialBackupDisc

rem 備份program 
set fileName=program
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"
rem ==============================以上為桌面的檔案===================================== 
rem ==============================以下為C槽的檔案===================================== 
:disc_c
set fileDisc=C:
set backupDiscName=disc-c
call :initialBackupDisc

rem 備份checkDisc 
rem 113.02.27 更名為CrystalDiskInfo 
set fileName=CrystalDiskInfo
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 113.02.27 增加備份fakeFlashTest 
set fileName=fakeFlashTest
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 113.02.27 增加備份h2testw 
set fileName=h2testw
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份JavaDoc 
set fileName=JavaDoc
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份JavaImage 
set fileName=JavaImage
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份javaWeb_setting 
set fileName=javaWeb_setting
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"
rem ==============================以上為C槽的檔案===================================== 
rem ==============================以下為D槽的檔案===================================== 
:disc_d
set fileDisc=D:
set backupDiscName=disc-d
call :initialBackupDisc

rem 備份apache-tomcat-9.0.46 
set fileName=apache-tomcat-9.0.46
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份Beyond Compare 4 
set fileName=Beyond Compare 4
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份C#Workspace 
set fileName=C#Workspace
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份DB(先備份資料庫，再備份資料) 
set sqlServerInfo=%sqlServerInfo1%
set sqlServerDbName=ALMS、ATM
call util.bat "backupSqlServer" "%sqlServerInfo%" "%sqlServerDbName%"
set mySqlInfo=%mySqlInfo1%
set mySqlDbName=library
call util.bat "backupMySql" "%mySqlInfo%" "%mySqlDbName%"
set mySqlInfo=%mySqlInfo2%
set mySqlDbName=xo219rlloiny8yk8
call util.bat "backupMySql" "%mySqlInfo%" "%mySqlDbName%"
set fileName=DB
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份eclipse-workspace 
set fileName=eclipse-workspace
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份eclipse-workspace_JavaWeb 
set fileName=eclipse-workspace_JavaWeb
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份githubWorkspace 
set fileName=githubWorkspace
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份html_css_javascript 
set fileName=html_css_javascript
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份incomeTax 
set fileName=incomeTax
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份jaspersoftstudio 
set fileName=jaspersoftstudio
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份JaspersoftWorkspace 
set fileName=JaspersoftWorkspace
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份Java 
set fileName=Java
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份pokemon 
set fileName=pokemon
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份programWork 
set fileName=programWork
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份pythonWorkspace 
set fileName=pythonWorkspace
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份Q-Dir 
set fileName=Q-Dir
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"
rem ==============================以上為D槽的檔案===================================== 
echo ================================================================================ 
echo 開始備份到%otherBackupRoot1%中... 
set otherBackupRoot=%otherBackupRoot1%
call :copyToOtherBakupRoot

echo 開始備份到%otherBackupRoot2%中... 
rem 先檢查是否插入隨身碟 
set usbBackupDisc=%usbBackupDisc1%
call :checkUsbBackupDisc
set otherBackupRoot=%otherBackupRoot2%
call :copyToOtherBakupRoot

echo 開始備份到%otherBackupRoot3%中... 
rem 先檢查是否插入隨身碟 
set usbBackupDisc=%usbBackupDisc2%
call :checkUsbBackupDisc
set otherBackupRoot=%otherBackupRoot3%
call :copyToOtherBakupRoot
echo ================================================================================ 
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
:initialBackupDisc
set backupPath=%backupRoot%\%backupDiscName%
set backupBackupPath=%backupPath%\%backupBackup%\
if not exist "%backupPath%" (
	mkdir "%backupPath%"
)
if not exist "%backupBackupPath%" (
	mkdir "%backupBackupPath%"
)
rem backupPath中有檔案就丟到backupBackupPath中 
dir /b "%backupPath%"| findstr /r /v "%backupBackup%">nul && move /y "%backupPath%\*.*" "%backupBackupPath%">nul
goto :eof

rem 備份至其它備份root中 
:copyToOtherBakupRoot
if "%otherBackupRoot%" equ "" (
	echo 其它備份root未設定，不備份 
)else (
	rem 若其它備份root中不存在，先建其資料夾 
	if not exist "%otherBackupRoot%" (
		mkdir "%otherBackupRoot%">nul
	)
	rem 113.03.03 改用robocopy增加效率
	robocopy /mir /mt:32 "%backupRoot%" "%otherBackupRoot%">nul
)
set otherBackupRoot=
goto :eof

rem 檢查是否插入隨身碟 
:checkUsbBackupDisc
if "%usbBackupDisc%" equ "" (
	echo usb槽未設定，不備份 
)else if not exist "%usbBackupDisc%" (
	echo 請插入隨身碟^(%usbBackupDisc%^)，再按任意鍵繼續備份... 
	pause>nul
	goto checkUsbBackupDisc
)
set usbBackupDisc=
goto :eof