@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

rem 若不備份某一路徑，直接註解即可 
rem 2025.06.19 以後不再備份到F槽 
rem 2026.04.26 以後不再備份到C、D槽 
rem 2026.05.02 備份到E槽不再壓縮，直接做差異備份 
set diskBackupDisc=E:
set backupRoot=%diskBackupDisc%\backup_computer
rem 讀取config.ini並設為參數
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i

echo 即將備份重要資料，請插入備份硬碟，若要完整備份，請先關閉相關應用程式 
echo 請按任意鍵繼續... 
pause>nul

rem 先檢查是否插入備份硬碟 
call util.bat "checkIsHasDisk" "%diskBackupDisc%"

rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot%" (
	mkdir "%backupRoot%"
)
rem ==============================以下為桌面的檔案===================================== 
:disc_desktop
rem 2025.06.20 調整桌面路徑 
rem 2025.06.22 將檔案放到C:\computerSetting，因此不再備份 
rem set fileDisc=%USERPROFILE%\Desktop 
rem set backupDiscName=disc-desktop 
rem call :initialBackupDisc 
rem ==============================以上為桌面的檔案===================================== 
rem ==============================以下為C槽的檔案===================================== 
:disc_c
set fileDisc=C:
set backupDiscName=disc-c
call :initialBackupDisc

rem 2026.02.07 增加備份antigravitySetting 
rem 2026.08.09 不再備份 
rem set fileName=antigravitySetting
rem call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.06.20 增加備份backupPhoneAndCloud_backup，用來存結構，換筆電後要複製一份並拿掉"_backup" 
set fileName=backupPhoneAndCloud_backup
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.06.22 增加備份computerSetting 
set fileName=computerSetting
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份checkDisc 
rem 2024.02.27 更名為CrystalDiskInfo 
set fileName=CrystalDiskInfo
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.01.20 增加備份cursorSetting 
rem 2026.08.09 不再備份 
rem set fileName=cursorSetting
rem call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2024.02.27 增加備份fakeFlashTest 
set fileName=fakeFlashTest
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2024.02.27 增加備份h2testw 
set fileName=h2testw
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份JavaDoc 
set fileName=JavaDoc
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份JavaImage 
set fileName=JavaImage
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份javaWebSetting 
set fileName=javaWebSetting
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"
rem ==============================以上為C槽的檔案===================================== 
rem ==============================以下為D槽的檔案===================================== 
:disc_d
set fileDisc=D:
set backupDiscName=disc-d
call :initialBackupDisc

rem 2025.01.19 增加備份apache-maven 
set fileName=apache-maven
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.01.19 增加備份apache-tomcat(將所有tomcat整合在一起) 
rem 2025.06.19 修正備份失敗的問題 
set fileName=apache-tomcat
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2024.10.06 增加備份batch 
rem 2026.08.29 不再備份 
rem set fileName=batch
rem call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份Beyond Compare 4 
set fileName=Beyond Compare 4
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份C#Workspace 
set fileName=C#Workspace
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份DB(先備份db，再備份資料) 
rem 2025.11.30 mysql-library不再備份 
rem 2025.04.06 更新mysqlInfo2的dbName 
rem 2026.04.26 db容器化後，將資料轉移到docker目錄下 
rem set mssqlInfo=%mssqlInfo1% 
rem set mssqlDbName=ALMS、ATM 
rem call util.bat "backupMssql" "%mssqlInfo%" "%mssqlDbName%" 
rem set mysqlInfo=%mysqlInfo1% 
rem set mysqlDbName=library 
rem call util.bat "backupMysql" "%mysqlInfo%" "%mysqlDbName%" 
rem set mysqlInfo=%mysqlInfo2% 
rem set mysqlDbName=ALMS 
rem call util.bat "backupMysql" "%mysqlInfo%" "%mysqlDbName%" 
rem set fileName=DB 
rem call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%" 

rem 2026.04.26 增加備份docker(先備份db，再備份資料) 
rem 2026.05.02 mssql-ATM不再備份 
rem 2026.05.02 mysql-library不再備份 
rem set "mssqlInfo=%mssqlInfo1%" 
rem set mssqlDbName=ATM 
rem call util.bat "backupMssql" "%mssqlInfo%" "%mssqlDbName%" 
rem set "mysqlInfo=%mysqlInfo1%" 
rem set mysqlDbName=library 
rem call util.bat "backupMysql" "%mysqlInfo%" "%mysqlDbName%" "mysql" 
set "mysqlInfo=%tidbInfo1%"
set mysqlDbName=ALMS、ALMS_dev_revise_setUpAccount
call util.bat "backupMysql" "%mysqlInfo%" "%mysqlDbName%" "tidb"
set fileName=docker
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份eclipse-workspace 
set fileName=eclipse-workspace
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份eclipse-workspace_JavaWeb 
rem 2026.08.01 不再備份 
rem set fileName=eclipse-workspace_JavaWeb
rem call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份githubWorkspace 
set fileName=githubWorkspace
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份html_css_javascript 
set fileName=html_css_javascript
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份incomeTax 
rem 2026.05.02 不再備份 
rem set fileName=incomeTax
rem call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份jaspersoft 
rem 2024.11.21 將studio及workspace放在一起成jaspersoft 
set fileName=jaspersoft
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份java 
set fileName=java
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.01.19 增加備份javaWebWorkspace 
rem 2026.08.01 不再備份 
rem set fileName=javaWebWorkspace
rem call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份pokemon 
set fileName=pokemon
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份programWork 
set fileName=programWork
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份pythonWorkspace 
set fileName=pythonWorkspace
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 備份Q-Dir 
set fileName=Q-Dir
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"

rem 2025.07.07 增加備份VirtuaWin_portable_4.5 
set fileName=VirtuaWin_portable_4.5
call util.bat "copyFile" "%backupPath%" "%fileDisc%" "%fileName%"
rem ==============================以上為D槽的檔案===================================== 
rem ==============================以下為其它檔案====================================== 
:disc_other
rem 2026.01.31 增加備份其它資料夾 
set backupDiscName=disc-other
call :initialBackupDisc

rem 2026.01.31 增加備份line設定檔 
set fileName=LINE
call util.bat "copyFile" "%backupPath%" "%LOCALAPPDATA%" "%fileName%"

rem 2026.01.31 增加備份notepad++設定檔 
set fileName=Notepad++
call util.bat "copyFile" "%backupPath%" "%APPDATA%" "%fileName%"
rem ==============================以上為其它檔案====================================== 
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
if not exist "%backupPath%" (
	mkdir "%backupPath%"
)
goto :eof