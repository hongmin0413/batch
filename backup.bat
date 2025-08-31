@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

rem 若不備份某一路徑，直接註解即可 
rem 2025.06.19 以後不再備份到F槽 
set backupRoot=C:\backup
set otherBackupRoot1=D:\backup
set usbBackupDisc=E:
set otherBackupRoot2=%usbBackupDisc%\backup_computer
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
rem 2025.06.20 調整桌面路徑 
rem 2025.06.22 將檔案放到C:\computer_setting，因此不再備份 
rem set fileDisc=C:\Users\Henry\Desktop
rem set backupDiscName=disc-desktop
rem call :initialBackupDisc
rem ==============================以上為桌面的檔案===================================== 
rem ==============================以下為C槽的檔案===================================== 
:disc_c
set fileDisc=C:
set backupDiscName=disc-c
call :initialBackupDisc

rem 2025.06.20 增加備份backupPhoneAndCloud_backup，用來存結構，換筆電後要複製一份並拿掉"_backup" 
set fileName=backupPhoneAndCloud_backup
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.06.22 增加備份computer_setting 
set fileName=computer_setting
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份checkDisc 
rem 2024.02.27 更名為CrystalDiskInfo 
set fileName=CrystalDiskInfo
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2024.02.27 增加備份fakeFlashTest 
set fileName=fakeFlashTest
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2024.02.27 增加備份h2testw 
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

rem 2025.01.20 增加備份cursorSetting 
set fileName=cursorSetting
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"
rem ==============================以上為C槽的檔案===================================== 
rem ==============================以下為D槽的檔案===================================== 
:disc_d
set fileDisc=D:
set backupDiscName=disc-d
call :initialBackupDisc

rem 2025.01.19 增加備份apache-maven 
set fileName=apache-maven
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.01.19 增加備份apache-tomcat(將所有tomcat整合在一起) 
rem 2025.06.19 修正備份失敗的問題 
set fileName=apache-tomcat
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2024.10.06 增加備份batch 
set fileName=batch
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

rem 備份jaspersoft 
rem 2024.11.21 將studio及workspace放在一起成jaspersoft 
set fileName=jaspersoft
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份Java 
set fileName=Java
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.01.19 增加備份javaWebWorkspace 
set fileName=javaWebWorkspace
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

rem 114.07.07 增加備份VirtuaWin_portable_4.5 
set fileName=VirtuaWin_portable_4.5
call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"
rem ==============================以上為D槽的檔案===================================== 
echo ================================================================================ 
echo 開始備份到%otherBackupRoot1%中... 
set otherBackupRoot=%otherBackupRoot1%
call :copyToOtherBakupRoot

echo 開始備份到%otherBackupRoot2%中... 
rem 先檢查是否插入隨身碟 
call util.bat "checkIsHasUsb" "%usbBackupDisc%"
set otherBackupRoot=%otherBackupRoot2%
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
rem backupPath中有backupBackup就丟到backupBackupPath中 
rem 2024.10.02 修正不管有沒有找到都會丟到backupBackupPath中的問題 
dir /b "%backupPath%" | findstr "%backupBackup%">nul && move /y "%backupPath%\*.*" "%backupBackupPath%">nul
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
	rem 2024.03.03 改用robocopy增加效率 
	robocopy /mir /mt:32 "%backupRoot%" "%otherBackupRoot%">nul
)
set otherBackupRoot=
goto :eof