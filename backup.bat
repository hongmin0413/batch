@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe
set zipExe=C:\Program Files\7-Zip\7z.exe

set usbBackupDisc=E:
set backupRoot1=C:\backup
set backupRoot2=D:\backup
set backupRoot3=%usbBackupDisc%\backup_computer
set backupBackup=history
set sqlServerBackupRoot=D:\DB\sqlServer2019\Backup
set mySqlBackupRoot=D:\DB\mySql8\Backup
rem 讀取config.ini並設為參數
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i

echo 即將備份重要資料，請插入隨身碟，若要完整備份，請先關閉相關應用程式 
echo 請按任意鍵繼續... 
pause>nul

rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot1%" (
	mkdir "%backupRoot1%"
)

rem ==============================以下為桌面的檔案===================================== 
set fileDisc=C:\Users\User\OneDrive\桌面
set backupDiscName=disc-desktop

rem 備份program 
set fileName=program
call :backupFile

rem ==============================以上為桌面的檔案===================================== 
rem ==============================以下為C槽的檔案===================================== 
set fileDisc=C:
set backupDiscName=disc-c

rem 備份checkDisc 
set fileName=checkDisc
call :backupFile

rem 備份JavaDoc 
set fileName=JavaDoc
call :backupFile

rem 備份JavaImage 
set fileName=JavaImage
call :backupFile

rem 備份javaWeb_setting 
set fileName=javaWeb_setting
call :backupFile
rem ==============================以上為C槽的檔案===================================== 
rem ==============================以下為D槽的檔案===================================== 
set fileDisc=D:
set backupDiscName=disc-d

rem 備份apache-tomcat-9.0.46 
set fileName=apache-tomcat-9.0.46
call :backupFile

rem 備份Beyond Compare 4 
set fileName=Beyond Compare 4
call :backupFile

rem 備份C#Workspace 
set fileName=C#Workspace
call :backupFile

rem 備份DB(先備份資料庫，再備份資料) 
set sqlServerInfo=%sqlServerInfo1%
set sqlServerDbName=ALMS、ATM
call :backupSqlServer 
set mySqlInfo=%mySqlInfo1%
set mySqlDbName=library
call :backupMySql
set mySqlInfo=%mySqlInfo2%
set mySqlDbName=xo219rlloiny8yk8
call :backupMySql 
set fileName=DB
call :backupFile

rem 備份eclipse-workspace 
set fileName=eclipse-workspace
call :backupFile

rem 備份eclipse-workspace_JavaWeb 
set fileName=eclipse-workspace_JavaWeb
call :backupFile

rem 備份githubWorkspace 
set fileName=githubWorkspace
call :backupFile

rem 備份html_css_javascript 
set fileName=html_css_javascript
call :backupFile

rem 備份incomeTax 
set fileName=incomeTax
call :backupFile

rem 備份jaspersoftstudio 
set fileName=jaspersoftstudio
call :backupFile

rem 備份JaspersoftWorkspace 
set fileName=JaspersoftWorkspace
call :backupFile

rem 備份Java 
set fileName=Java
call :backupFile

rem 備份pokemon 
set fileName=pokemon
call :backupFile

rem 備份programWork 
set fileName=programWork
call :backupFile

rem 備份pythonWorkspace 
set fileName=pythonWorkspace
call :backupFile

rem 備份Q-Dir 
set fileName=Q-Dir
call :backupFile
rem ==============================以上為D槽的檔案=====================================
echo ================================================================================ 
echo 開始備份到%backupRoot2%中...
rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot2%" (
	mkdir "%backupRoot2%"
)
xcopy /y /i /e "%backupRoot1%" "%backupRoot2%">nul

echo ================================================================================ 
rem 先檢查是否插入隨身碟
:checkUsbBackupDisc 
echo 開始備份到%backupRoot3%中...
if not exist %usbBackupDisc% (
	echo 請插入隨身碟，再按任意鍵繼續備份...
	pause>nul
	goto checkUsbBackupDisc
)
rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot3%" (
	mkdir "%backupRoot3%"
)
xcopy /y /i /e "%backupRoot1%" "%backupRoot3%">nul

set msg=備份完畢 
if exist "%msgExe%" (
	"%msgExe%" ^* "%msg%" 
)else (
	echo %msg% 
	echo 請按任意鍵退出...
	pause>nul
)
exit

:backupFile
setlocal enabledelayedexpansion
rem 若備份路徑、備份的備份路徑不存在，先建其資料夾 
set backupPath=%backupRoot1%\%backupDiscName%
if not exist "%backupPath%" (
	mkdir "%backupPath%"
)
set backupBackupPath=%backupPath%\%backupBackup%\
if not exist "!backupBackupPath!" (
	mkdir "!backupBackupPath!"
)
rem fileName有值才備份 
if "%fileName%" neq "" (
	echo ================================================================================ 
	rem 要備份的file存在才備份 
	set file=%fileDisc%\%fileName%
	if exist "!file!" (
		rem file備份檔若存在就先移到備份的備份中 
		set file7z=!backupPath!\%fileName%.7z
		if exist "!file7z!" (
			echo 有file備份檔，先移到備份的備份中 
			move /y "!file7z!" !backupBackupPath!>nul
		)
		echo 開始備份【!file!】... 
		"%zipExe%" a -t7z "!file7z!" "!file!">nul 
		echo 【!file!】備份完畢
	)else (
		echo 【!file!】不存在，不備份
	)
)
endlocal
rem 清空參數後返回
set fileName=
goto :eof

:backupSqlServer
setlocal enabledelayedexpansion
rem sqlServerDbName有值才備份 
if "%sqlServerDbName%" neq "" (
	echo ================================================================================ 
	rem 拆解sqlServerDbName做備份 
	set tempSqlServerDbName=%sqlServerDbName%
	:splitSqlServerDbName
	for /f "tokens=1,* delims=、" %%i in ("!tempSqlServerDbName!") do (
		set singleSqlServerDbName=%%i
		rem 要備份的sqlServerDb存在才備份 
		set isSqlServerDbExist=false
		set checkSqlServerDbSQL=SELECT name FROM sys.databases where state = 0 and name = '!singleSqlServerDbName!'
		for /f "delims=" %%i in ('sqlcmd %sqlServerInfo% -Q "!checkSqlServerDbSQL!"^| findstr "!singleSqlServerDbName!"') do (
			set isSqlServerDbExist=true
		)
		if !isSqlServerDbExist! equ true (
			rem sqlServerDb備份檔若存在就先刪除 
			set sqlServerdbBak=%sqlServerBackupRoot%\!singleSqlServerDbName!.bak
			if exist "!sqlServerdbBak!" (
				del /f "!sqlServerdbBak!"
			)
			echo 開始備份sqlServer的db-!singleSqlServerDbName!... 
			sqlcmd %sqlServerInfo% -Q "BACKUP DATABASE !singleSqlServerDbName! TO DISK = '!sqlServerdbBak!'">nul 
			echo sqlServer的db-!singleSqlServerDbName!備份完畢 
		)else (
			echo sqlServer的db-!singleSqlServerDbName!不存在，不備份 
		)
		set tempSqlServerDbName=%%j
	)
	if "!tempSqlServerDbName!" neq "" (
		goto splitSqlServerDbName
	)
)
endlocal
rem 清空參數後返回
set sqlServerInfo=
set sqlServerDbName=
goto :eof

:backupMySql
setlocal enabledelayedexpansion
set cnf=mysql.cnf
rem mySqlDbName有值才備份 
if "%mySqlDbName%" neq "" (
	echo ================================================================================ 
	rem 拆解mySqlInfo做設定mysql 
	set tempMySqlInfo=%mySqlInfo%
	echo [client]>!cnf!
	:splitMySqlInfo
	for /f "tokens=1,* delims= " %%i in ("!tempMySqlInfo!") do (
		echo %%i>>!cnf!
		set tempMySqlInfo=%%j
	)
	if "!tempMySqlInfo!" neq "" (
		goto splitMySqlInfo
	)
	rem 拆解mySqlDbName做備份 
	set tempMySqlDbName=%mySqlDbName%
	:splitMySqlDbName
	for /f "tokens=1,* delims=、" %%i in ("!tempMySqlDbName!") do (
		set singleMySqlDbName=%%i
		rem 要備份的mySqlDb存在才備份 
		set isMySqlDbExist=false
		for /f "delims=" %%i in ('mysql --defaults-extra-file^=!cnf! -e "show databases"^| findstr /x "!singleMySqlDbName!"') do (
			set isMySqlDbExist=true
		)
		if !isMySqlDbExist! equ true (
			rem mySqlDb備份檔若存在就先刪除 
			set mySqldbSql=%mySqlBackupRoot%\!singleMySqlDbName!.sql
			if exist "!mySqldbSql!" (
				del /f "!mySqldbSql!"
			)
			echo 開始備份mySql的db-!singleMySqlDbName!... 
			mysqldump --defaults-extra-file=!cnf! --no-tablespaces --set-gtid-purged=OFF "!singleMySqlDbName!" >"!mySqldbSql!" 
			echo mySql的db-!singleMySqlDbName!備份完畢 
		)else (
			echo mySql的db-!singleMySqlDbName!不存在，不備份 
		)
		set tempMySqlDbName=%%j
	)
	if "!tempMySqlDbName!" neq "" (
		goto splitMySqlDbName
	)
	del /f "mysql.cnf"
)
endlocal
rem 清空參數後返回
set mySqlInfo=
set mySqlDbName=
goto :eof