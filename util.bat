@echo off
chcp 65001>nul

set zipExe=C:\Program Files\7-Zip\7z.exe
rem 2026.05.02 增加容器內的路徑 
set mssqlBackupRoot=D:\docker\DB\backup
set mssqlBackupRootInDocker=/var/backups
set mysqlBackupRoot=D:\docker\DB\backup
set tidbBackupRoot=D:\docker\TiDB\backup
rem 2026.05.02 調整db容器化後的指令開頭寫法 
set mssqlInDocker=docker exec -i mssql-2022-latest
set sqlcmdPath=/opt/mssql-tools18/bin/sqlcmd
set mysqlInDocker=docker exec -i mysql-8.0.46
set mysqlPath=/usr/bin/mysql
set mysqldumpPath=/usr/bin/mysqldump

set action=%~1
rem 2024.07.07 增加複製檔案 
if "%action%" equ "copyFile" (
	set destPath=%~2
	set filePath=%~3
	set fileName=%~4
	call :copyFile
)else if "%action%" equ "zipFile" (
	set zipPath=%~2
	set fileDisc=%~3
	set fileName=%~4
	call :zipFile
)else if "%action%" equ "backupMssql" (
	set "mssqlInfo=%~2"
	set mssqlDbName=%~3
	call :backupMssql
) else if "%action%" equ "backupMysql" (
	set "mysqlInfo=%~2"
	set mysqlDbName=%~3
	rem 2026.05.01 為了區分mysql、tidb，增加mysqlType 
	set mysqlType=%~4
	call :backupMysql
rem 2026.10.03 增加執行mysql、tidb的SQL、還原mysql、tidb的備份檔 
) else if "%action%" equ "executeMysql" (
	set "mysqlInfo=%~2"
	rem 查詢結果的輸出檔，省略就直接顯示在畫面上 
	set "mysqlOutFile=%~3"
	rem SQL不放在參數，改放在呼叫前設定的mysqlSql，因為SQL若有括號，放在參數會讓這個判斷式解析錯誤 
	call :executeMysql
) else if "%action%" equ "restoreMysql" (
	set "mysqlInfo=%~2"
	rem 備份檔的db名稱 
	set mysqlDbName=%~3
	rem 還原後的db名稱 
	set mysqlNewDbName=%~4
	set mysqlType=%~5
	call :restoreMysql
rem 2024.07.07 將backup.bat的檢查是否插入備份硬碟放到這邊 
) else if "%action%" equ "checkIsHasDisk" (
	set diskDisc=%~2
	call :checkIsHasDisk
)
goto :eof

rem 複製檔案 
:copyFile
setlocal enabledelayedexpansion
rem fileName有值才複製 
if "%fileName%" neq "" (
	echo ================================================================================
	rem 要複製的file存在才複製 
	set file=%filePath%\%fileName%
	if exist "!file!" (
		echo 開始複製【!file!】... 
		robocopy /mir /mt:32 "!file!" "%destPath%\%fileName%">nul 
		echo 【!file!】複製完畢
	)else (
		echo 【!file!】不存在，不複製
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

rem 備份mssql 
:backupMssql
setlocal enabledelayedexpansion
rem mssqlDbName有值才備份 
if "%mssqlDbName%" neq "" (
	echo ================================================================================ 
	rem 2026.05.02 拆解密碼與其它資訊 
	for /f "tokens=1,2 delims=;" %%i in ("%mssqlInfo%") do (
		set "mssqlInfoNoPwd=%%i"
		set "SQLCMDPASSWORD=%%j"
	)
	rem 拆解mssqlDbName做備份 
	set tempMssqlDbName=%mssqlDbName%
	:splitMssqlDbName
	for /f "tokens=1,* delims=、" %%i in ("!tempMssqlDbName!") do (
		set singleMssqlDbName=%%i
		rem 要備份的mssqlDb存在才備份 
		set singleMssqlDbNameCount=0
		rem 2026.05.02 SET NOCOUNT ON;用來去掉(1 rows affected) 
		set "checkMssqlDbSQL=SET NOCOUNT ON; SELECT COUNT(1) FROM sys.databases WHERE state = 0 AND name = '!singleMssqlDbName!';"
		rem 2026.05.02 mssql-2022的sqlcmd預設強制加密，因此增加參數-C 
		rem 2026.05.02 -h -1用來去掉表頭及虛線；-W用來移除多餘空格 
		for /f "delims=" %%i in ('%mssqlInDocker% sh -c "export SQLCMDPASSWORD=!SQLCMDPASSWORD!; ^\"%sqlcmdPath%^\" !mssqlInfoNoPwd! -Q ^\"!checkMssqlDbSQL!^\" -C -h -1 -W"') do (
			set singleMssqlDbNameCount=%%i
		)
		if !singleMssqlDbNameCount! equ 1 (
			set mssqlDbBak=%mssqlBackupRoot%\!singleMssqlDbName!.bak
			set mssqlDbBakInDocker=%mssqlBackupRootInDocker%/!singleMssqlDbName!.bak
			rem mssqlDb備份檔若存在就先刪除 
			if exist "!mssqlDbBak!" (
                echo 有mssql的db-!singleMssqlDbName!備份檔，先刪除 
				del /f "!mssqlDbBak!">nul
			)
			echo 開始備份mssql的db-!singleMssqlDbName!... 
			set "backupMssqlDbSQL=BACKUP DATABASE !singleMssqlDbName! TO DISK = '!mssqlDbBakInDocker!';"
			rem mssql-2022的sqlcmd預設強制加密，因此增加參數-C 
			%mssqlInDocker% sh -c "export SQLCMDPASSWORD=!SQLCMDPASSWORD!; ^\"%sqlcmdPath%^\" !mssqlInfoNoPwd! -Q ^\"!backupMssqlDbSQL!^\" -C">nul
			echo mssql的db-!singleMssqlDbName!備份完畢 
		)else (
			echo mssql的db-!singleMssqlDbName!不存在，不備份 
		)
		set tempMssqlDbName=%%j
	)
	if "!tempMssqlDbName!" neq "" (
		goto splitMssqlDbName
	)
)
endlocal
goto :eof

rem 備份mysql、tidb 
:backupMysql
setlocal enabledelayedexpansion
rem mysqlDbName有值才備份 
if "%mysqlDbName%" neq "" (
	echo ================================================================================ 
	for /f "tokens=1,2 delims=;" %%i in ("%mysqlInfo%") do (
		set "mysqlInfoNoPwd=%%i"
		set "MYSQL_PWD=%%j"
	)
	rem 拆解mysqlDbName做備份 
	set tempMysqlDbName=%mysqlDbName%
	:splitMysqlDbName
	for /f "tokens=1,* delims=、" %%i in ("!tempMysqlDbName!") do (
		set singleMysqlDbName=%%i
		rem 要備份的mysqlDb存在才備份 
		set singleMysqlDbNameCount=0
		set "checkMysqlDbSQL=SELECT COUNT(1) FROM information_schema.schemata WHERE schema_name = '!singleMysqlDbName!';"
		for /f "delims=" %%i in ('%mysqlInDocker% sh -c "export MYSQL_PWD=!MYSQL_PWD!; ^\"%mysqlPath%^\" !mysqlInfoNoPwd! -e ^\"!checkMysqlDbSQL!^\""') do (
			set singleMysqlDbNameCount=%%i
		)
		if !singleMysqlDbNameCount! equ 1 (
			rem 2026.04.24 調整備份語法 
			rem 2026.05.02 mysql、tidb的備份路徑、備份參數不同 
			if "%mysqlType%" equ "tidb" (
				set mysqlDbSql=%tidbBackupRoot%\!singleMysqlDbName!.sql
				set mysqlBackupParam=--lock-tables --routines --triggers --disable-keys --extended-insert --quick --no-tablespaces --set-gtid-purged=OFF
			)else (
				set mysqlDbSql=%mysqlBackupRoot%\!singleMysqlDbName!.sql
				set mysqlBackupParam=--single-transaction --routines --triggers --disable-keys --extended-insert --quick --no-tablespaces --set-gtid-purged=OFF
			)
			rem mysqlDb備份檔若存在就先刪除 
			if exist "!mysqlDbSql!" (
			echo 有%mysqlType%的db-!singleMysqlDbName!備份檔，先刪除 
				del /f "!mysqlDbSql!">nul
			)
			echo 開始備份%mysqlType%的db-!singleMysqlDbName!... 
			%mysqlInDocker% sh -c "export MYSQL_PWD=!MYSQL_PWD!; ^\"%mysqldumpPath%^\" !mysqlInfoNoPwd! --databases ^\"!singleMysqlDbName!^\" !mysqlBackupParam!" > "!mysqlDbSql!"
			echo %mysqlType%的db-!singleMysqlDbName!備份完畢 
		)else (
			echo %mysqlType%的db-!singleMysqlDbName!不存在，不備份 
		)
		set tempMysqlDbName=%%j
	)
	if "!tempMysqlDbName!" neq "" (
		goto splitMysqlDbName
	)
)
endlocal
goto :eof

rem 2026.10.03 執行mysql、tidb的SQL 
:executeMysql
setlocal enabledelayedexpansion
for /f "tokens=1,2 delims=;" %%i in ("%mysqlInfo%") do (
	set "mysqlInfoNoPwd=%%i"
	set "MYSQL_PWD=%%j"
)
set "executeSql=%mysqlSql%"
rem -N、-B用來去掉表頭，讓查詢結果只剩值 
if "%mysqlOutFile%" neq "" (
	%mysqlInDocker% sh -c "export MYSQL_PWD=!MYSQL_PWD!; ^\"%mysqlPath%^\" !mysqlInfoNoPwd! -N -B -e ^\"!executeSql!^\"" > "%mysqlOutFile%"
)else (
	%mysqlInDocker% sh -c "export MYSQL_PWD=!MYSQL_PWD!; ^\"%mysqlPath%^\" !mysqlInfoNoPwd! -e ^\"!executeSql!^\""
)
endlocal & exit /b %errorlevel%

rem 2026.10.03 還原mysql、tidb的備份檔(可還原成不同的資料庫名稱，備份檔內的資料庫名稱會先改成新的資料庫名稱) 
:restoreMysql
setlocal enabledelayedexpansion
for /f "tokens=1,2 delims=;" %%i in ("%mysqlInfo%") do (
	set "mysqlInfoNoPwd=%%i"
	set "MYSQL_PWD=%%j"
)
rem mysql、tidb的備份路徑不同 
if "%mysqlType%" equ "tidb" (
	set "mysqlDbSql=%tidbBackupRoot%\%mysqlDbName%.sql"
)else (
	set "mysqlDbSql=%mysqlBackupRoot%\%mysqlDbName%.sql"
)
if not exist "!mysqlDbSql!" (
	echo %mysqlType%的db-%mysqlDbName%備份檔不存在，不還原 
	endlocal & exit /b 1
)
rem 還原後的db若已存在就不還原，避免同名資料表被覆蓋 
set restoreDbCount=0
set "checkRestoreDbSQL=SELECT COUNT(1) FROM information_schema.schemata WHERE schema_name = '%mysqlNewDbName%';"
for /f "delims=" %%i in ('%mysqlInDocker% sh -c "export MYSQL_PWD=!MYSQL_PWD!; ^\"%mysqlPath%^\" !mysqlInfoNoPwd! -N -B -e ^\"!checkRestoreDbSQL!^\""') do (
	set restoreDbCount=%%i
)
if "!restoreDbCount!" neq "0" (
	echo %mysqlType%的db-%mysqlNewDbName%已存在，不還原，請先確認後手動刪除 
	endlocal & exit /b 1
)
set "mysqlRestoreSql=!mysqlDbSql!.restore.sql"
echo 開始還原%mysqlType%的db-%mysqlDbName%為db-%mysqlNewDbName%... 
rem 備份檔中的CREATE DATABASE、USE、檢視中帶資料庫名稱的資料表，都改成新的db名稱 
rem 這行PowerShell指令不能有脫字符號，因為開啟延遲變數展開時，cmd會把它吃掉 
powershell -NoProfile -Command "$s='%mysqlDbName%'; $d='%mysqlNewDbName%'; $t=[IO.File]::ReadAllText('!mysqlDbSql!',[Text.Encoding]::UTF8); $t=[regex]::Replace($t,'(CREATE DATABASE .*?)`'+$s+'`','${1}`'+$d+'`'); $t=[regex]::Replace($t,'USE `'+$s+'`;','USE `'+$d+'`;'); $t=$t.Replace('`'+$s+'`.','`'+$d+'`.'); [IO.File]::WriteAllText('!mysqlRestoreSql!',$t,(New-Object Text.UTF8Encoding($false)))"
if errorlevel 1 (
	echo 轉換備份檔的db名稱失敗 
	endlocal & exit /b 1
)
%mysqlInDocker% sh -c "export MYSQL_PWD=!MYSQL_PWD!; ^\"%mysqlPath%^\" !mysqlInfoNoPwd! --default-character-set=utf8mb4" < "!mysqlRestoreSql!"
if errorlevel 1 (
	echo %mysqlType%的db-%mysqlNewDbName%還原失敗 
	del /f "!mysqlRestoreSql!">nul
	endlocal & exit /b 1
)
del /f "!mysqlRestoreSql!">nul
echo %mysqlType%的db-%mysqlNewDbName%還原完畢 
endlocal & exit /b 0

rem 檢查是否插入備份硬碟 
:checkIsHasDisk
if "%diskDisc%" equ "" (
	echo 備份硬碟槽未設定，不檢查是否插入備份硬碟 
	echo 請按任意鍵退出... 
	pause>nul
	exit
)else if not exist "%diskDisc%" (
	echo 請插入備份硬碟^(%diskDisc%^)，再按任意鍵繼續... 
	pause>nul
	goto checkIsHasDisk
)
goto :eof