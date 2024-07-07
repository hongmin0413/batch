@echo off
chcp 65001>nul

set zipExe=C:\Program Files\7-Zip\7z.exe
set sqlServerBackupRoot=D:\DB\sqlServer2019\Backup
set mySqlBackupRoot=D:\DB\mySql8\Backup

set action=%~1
rem 113.07.07 增加移動檔案 
if "%action%" equ "moveFile" (
	set destPath=%~2
	set filePath=%~3
	set fileName=%~4
	call :moveFile
)else if "%action%" equ "zipFile" (
	set zipPath=%~2
	set fileDisc=%~3
	set fileName=%~4
	call :zipFile
)else if "%action%" equ "backupSqlServer" (
	set sqlServerInfo=%~2
	rem 因為","是特殊符號，所以在這邊將port型式做轉換 
	set sqlServerInfo=%sqlServerInfo: -port =^^,%
	set sqlServerDbName=%~3
	call :backupSqlServer
) else if "%action%" equ "backupMySql" (
	set mySqlInfo=%~2
	set mySqlDbName=%~3
	call :backupMySql
rem 113.07.07 將backup.bat的檢查是否插入隨身碟放到這邊 
) else if "%action%" equ "checkIsHasUsb" (
	set usbDisc=%~2
	call :checkIsHasUsb
)
goto :eof

rem 移動檔案 
:moveFile
setlocal enabledelayedexpansion
rem fileName有值才移動 
if "%fileName%" neq "" (
	echo ================================================================================
	rem 要移動的file存在才移動 
	set file=%filePath%\%fileName%
	if exist "!file!" (
		echo 開始移動【!file!】... 
		robocopy /mir /mt:32 "!file!" "%destPath%\%fileName%">nul 
		echo 【!file!】移動完畢
	)else (
		echo 【!file!】不存在，不移動
	)
)
endlocal
goto :eof

rem 壓縮檔案 
:zipFile
setlocal enabledelayedexpansion
rem fileName有值才壓縮 
if "%fileName%" neq "" (
	echo ================================================================================
	rem 要壓縮的file存在才壓縮 
	set file=%fileDisc%\%fileName%
	if exist "!file!" (
		rem file壓縮檔若存在就刪除 
		set file7z=%zipPath%\%fileName%.7z
		if exist "!file7z!" (
			echo 有【!file!】壓縮檔，先刪除 
			del /f "!file7z!">nul
		)
		echo 開始壓縮【!file!】... 
		"%zipExe%" a -t7z "!file7z!" "!file!">nul 
		echo 【!file!】壓縮完畢
	)else (
		echo 【!file!】不存在，不壓縮
	)
)
endlocal
goto :eof

rem 備份sql server 
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
                echo 有sqlServer的db-!singleSqlServerDbName!備份檔，先刪除 
				del /f "!sqlServerdbBak!">nul
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
goto :eof

rem 備份mySql 
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
                echo 有mySql的db-!singleMySqlDbName!備份檔，先刪除 
				del /f "!mySqldbSql!">nul
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
goto :eof

rem 檢查是否插入隨身碟 
:checkIsHasUsb
if "%usbDisc%" equ "" (
	echo usb槽未設定，不備份 
	echo 請按任意鍵退出... 
	pause>nul
	exit
)else if not exist "%usbDisc%" (
	echo 請插入隨身碟^(%usbDisc%^)，再按任意鍵繼續備份... 
	pause>nul
	goto checkIsHasUsb
)
goto :eof