@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe
set zipExe=C:\Program Files\7-Zip\7z.exe

set backupRoot=C:\backup
set backupBackup=history
set programRoot=D:\workspace
rem 2025.10.21 調整路徑 
set serverRoot=D:\APPS\wildfly
set mssqlBackupRoot=D:\DB\SQL2022\Backup
set sqlcmdPath=C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\SQLCMD.EXE
rem 2026.05.25 調整db容器化後的指令開頭寫法 
set dockerBackupRoot=D:\APPS\docker\DB\backup
set postgresInDocker=docker exec -i postgres-17.9-alpine3.23
set psqlPath=/usr/local/bin/psql
set pgDumpPath=/usr/local/bin/pg_dump
rem 讀取config.ini並設為參數
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i

echo 即將備份program、server、db、其它資料夾，若要完整備份，請先關閉相關應用程式 
echo 請按任意鍵繼續... 
pause>nul

rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot%" (
	mkdir "%backupRoot%"
)

rem 備份農業部 
rem 2024.07.23 增加備份MOADoms2501 
rem 2026.08.17 調整程式目錄 
set orgName=農業部 
set programName=MOADoms_MOA
set serverName=wildfly-21.0.0.Final_MOA
set mssqlDbName=MOADoms00、MOADoms25、eipdb、MOADoms2501
call :backup

rem 備份智慧局 
rem 2026.07.31 調整程式目錄 
rem 2026.08.05 智慧局_115增修的程式已增加至此程式目錄，因此會一起備份 
set orgName=智慧局 
set programName=MOADoms_TIPO
set serverName=wildfly-21.0.0.Final_TIPO
set mssqlDbName=signdoms30new
call :backup

rem 備份智慧局_111增修 
rem server、db與智慧局同，不備份 
set orgName=智慧局_111增修 
set programName=workspace_MOA_TIPO
call :backup

rem 備份國發會 
rem 2026.04.02 增加備份VANS_CI 
rem 2026.08.17 調整程式目錄 
rem 2026.08.17 增加備份signdoms27_many-features 
set orgName=國發會 
set programName=MOADoms_NDC
set serverName=wildfly-10.0.0.Final_NDC
set mssqlDbName=signdoms27、signdoms27_many-features、VANS_CI
call :backup

rem 備份國發會_111增修 
rem server、db與國發會同，不備份 
set orgName=國發會_111增修 
set programName=workspace_MOA_CI
call :backup

rem 備份農險基金 
rem 2026.08.18 調整程式目錄 
set orgName=農險基金 
set programName=MOADoms_TAIF
set serverName=wildfly-20.0.1.Final_TAIF
set mssqlDbName=signdoms32
call :backup

rem 備份經濟部 
rem 2026.08.17 調整程式目錄 
rem 2026.08.17 增加備份signdomsMOEANew_many-features 
set orgName=經濟部 
set programName=MOADoms_MOEA
set serverName=wildfly-21.0.0.Final_MOEA
set mssqlDbName=signdomsMOEANew、signdomsMOEANew_many-features、signdomsAOC
call :backup

rem 2024.10.07 增加備份個資處 
rem 2026.08.18 調整程式目錄 
set orgName=個資處 
set programName=MOADoms_PDPC
set serverName=wildfly-21.0.0.Final_PDPC
set mssqlDbName=signdomsPDPC
call :backup

rem 備份經濟部OA 
set orgName=經濟部OA 
set programName=workspace_OASystem_JDK17
set serverName=wildfly-28.0.1.Final_MOEA_OA
set mssqlDbName=moeaoa
call :backup

rem 2026.05.07 增加備份經濟部OA_docker 
rem 2026.08.03 調整程式目錄 
set orgName=經濟部OA_docker 
set programName=OASystem_MOEA_docker
set serverName=wildfly-28.0.1.Final_MOEA_OA_docker
set postgresDbName=moeaoa
call :backup

rem 2025.02.07 增加備份衛福部OA 
rem 2025.05.27 調整資料庫名稱 
rem 2026.01.23 調整資料庫名稱 
rem 2026.08.04 調整程式目錄 
set orgName=衛福部OA 
set programName=OASystem_MOHW
set serverName=wildfly-34.0.0.Final_MOHW_OA
set mssqlDbName=mohwoa
call :backup

rem 2025.10.21 增加備份經濟部EM 
rem 2026.08.04 調整程式目錄 
set orgName=經濟部EM 
set programName=EMSystem_MOEA
set serverName=wildfly-37.0.1.Final_MOEA_EM
set mssqlDbName=moeaem
call :backup

rem 2025.09.30 增加備份Q-dir資料 
set copyFilePath=D:\Tools\BC
set copyFileName=Q-Dir
call :copyFile

rem 2026.06.12 增加備份batch資料 
set copyFilePath=D:\Tools\BC
set copyFileName=batch
call :copyFile

rem 2026.08.19 增加備份cursorSetting資料 
set copyFilePath=D:\Tools\BC
set copyFileName=cursorSetting
call :copyFile

rem 2026.05.07 增加備份docker資料 
set copyFilePath=D:\APPS
set copyFileName=docker
call :copyFile

set msg=備份完畢 
if exist "%msgExe%" (
	"%msgExe%" ^* "%msg%"
)else (
	echo ================================================================================ 
	echo %msg% 
	echo 請按任意鍵退出...
	pause>nul
)
exit

:backup
set orgName=%orgName: =%
setlocal enabledelayedexpansion
rem 若備份路徑、備份的備份路徑不存在，先建其資料夾 
set backupPath=%backupRoot%\%orgName%
if not exist "!backupPath!" (
	mkdir "!backupPath!"
)
set backupBackupPath=%backupPath%\%backupBackup%\
if not exist "!backupBackupPath!" (
	mkdir "!backupBackupPath!"
)
rem programName有值才備份 
if "%programName%" neq "" (
	echo ================================================================================ 
	rem 要備份的program存在才備份 
	set program=%programRoot%\%orgName%\%programName%
	if exist "!program!" (
		rem program備份檔若存在就先移到備份的備份中 
		set program7z=!backupPath!\%programName%.7z
		if exist "!program7z!" (
			echo 有【%orgName%】版的program備份檔，先移到備份的備份中 
			move /y "!program7z!" !backupBackupPath!>nul
		)
		echo 開始備份【%orgName%】版的program... 
		"%zipExe%" a -t7z "!program7z!" "!program!">nul 
		echo 【%orgName%】版的program備份完畢
	)else (
		echo 【%orgName%】版的program不存在，不備份
	)
)
rem serverName有值才備份 
if "%serverName%" neq "" (
	echo ================================================================================ 
	rem 要備份的server存在才備份 
	set server=%serverRoot%\%serverName%
	if exist "!server!" (
		rem server備份檔若存在就先移到備份的備份中 
		set server7z=!backupPath!\%serverName%.7z
		if exist "!server7z!" (
			echo 有【%orgName%】版的server備份檔，先移到備份的備份中 
			move /y "!server7z!" !backupBackupPath!>nul
		)
		echo 開始備份【%orgName%】版的server... 
		"%zipExe%" a -t7z "!server7z!" "!server!">nul 
		echo 【%orgName%】版的server備份完畢
	)else (
		echo 【%orgName%】版的server不存在，不備份
	)
)
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
		for /f "delims=" %%i in ('""%sqlcmdPath%" !mssqlInfoNoPwd! -Q "!checkMssqlDbSQL!" -C -h -1 -W"') do (
			set singleMssqlDbNameCount=%%i
		)
		if !singleMssqlDbNameCount! equ 1 (
			rem c槽的db備份檔若存在就先移到備份的備份中 
			set mssqlDbBak=!backupPath!\!singleMssqlDbName!.bak
			if exist "!mssqlDbBak!" (
				echo 有【%orgName%】版的db-!singleMssqlDbName!備份檔，先移到備份的備份中 
				move /y "!mssqlDbBak!" !backupBackupPath!>nul
			)
			rem d槽的db備份檔若存在就先刪除 
			set mssqlDbBak2=%mssqlBackupRoot%\!singleMssqlDbName!.bak
			if exist "!mssqlDbBak2!" (
				del /f "!mssqlDbBak2!"
			)
			rem 先備份在c槽，再複製到d槽 
			echo 開始備份【%orgName%】版的db-!singleMssqlDbName!... 
			set "backupMssqlDbSQL=BACKUP DATABASE !singleMssqlDbName! TO DISK = '!mssqlDbBak!';"
			rem mssql-2022的sqlcmd預設強制加密，因此增加參數-C 
			"%sqlcmdPath%" !mssqlInfoNoPwd! -Q "!backupMssqlDbSQL!" -C>nul
			copy /y "!mssqlDbBak!" "!mssqlDbBak2!">nul 
			echo 【%orgName%】版的db-!singleMssqlDbName!備份完畢
		)else (
			echo 【%orgName%】版的db-!singleMssqlDbName!不存在，不備份 
		)
		set tempMssqlDbName=%%j
	)
	if "!tempMssqlDbName!" neq "" (
		goto splitMssqlDbName
	)
)
rem postgresDbName有值才備份 
if "%postgresDbName%" neq "" (
	echo ================================================================================ 
	for /f "tokens=1,2 delims=;" %%i in ("%postgresInfo%") do (
		set "postgresInfoNoPwd=%%i"
		set "PGPASSWORD=%%j"
	)
	rem 拆解postgresDbName做備份 
	set tempPostgresDbName=%postgresDbName%
	:splitPostgresDbName
	for /f "tokens=1,* delims=、" %%i in ("!tempPostgresDbName!") do (
		set singlePostgresDbName=%%i
		rem 要備份的postgresDb存在才備份 
		set singlePostgresDbNameCount=0
		rem 2026.05.25 -t用來去掉表頭及虛線；-A用來移除多餘空格 
		set "checkPostgresDbSQL=SELECT COUNT(1) FROM pg_database WHERE datallowconn = true AND datname = '!singlePostgresDbName!';"
		for /f "delims=" %%i in ('%postgresInDocker% sh -c "export PGPASSWORD=!PGPASSWORD!; ^\"%psqlPath%^\" !postgresInfoNoPwd! -c ^\"!checkPostgresDbSQL!^\" -t -A"') do (
			set singlePostgresDbNameCount=%%i
		)
		if !singlePostgresDbNameCount! equ 1 (
			rem c槽的db備份檔若存在就先移到備份的備份中 
			set postgresDbSql=!backupPath!\!singlePostgresDbName!.sql
			if exist "!postgresDbSql!" (
				echo 有【%orgName%】版的db-!singlePostgresDbName!備份檔，先移到備份的備份中 
				move /y "!postgresDbSql!" !backupBackupPath!>nul
			)
			rem d槽的db備份檔若存在就先刪除 
			set postgresDbSql2=%dockerBackupRoot%\!singlePostgresDbName!.sql
			if exist "!postgresDbSql2!" (
				del /f "!postgresDbSql2!"
			)
			rem 先備份在c槽，再複製到d槽 
			echo 開始備份【%orgName%】版的db-!singlePostgresDbName!... 
			set postgresBackupParam=--no-tablespaces
			%postgresInDocker% sh -c "export PGPASSWORD=!PGPASSWORD!; ^\"%pgDumpPath%^\" !postgresInfoNoPwd! -d ^\"!singlePostgresDbName!^\" !postgresBackupParam!" > "!postgresDbSql!"
			copy /y "!postgresDbSql!" "!postgresDbSql2!">nul 
			echo 【%orgName%】版的db-!singlePostgresDbName!備份完畢 
		)else (
			echo 【%orgName%】版的db-!singlePostgresDbName!不存在，不備份 
		)
		set tempPostgresDbName=%%j
	)
	if "!tempPostgresDbName!" neq "" (
		goto splitPostgresDbName
	)
)
endlocal
rem 清空參數後返回
set orgName=
set programName=
set serverName=
set mssqlDbName=
set postgresDbName=
goto :eof

rem 複製檔案 
:copyFile
setlocal enabledelayedexpansion
rem fileName有值才複製 
if "%copyFileName%" neq "" (
	echo ================================================================================
	rem 要複製的file存在才複製 
	set file=%copyFilePath%\%copyFileName%
	if exist "!file!" (
		echo 開始複製【!file!】... 
		robocopy /mir /mt:32 "!file!" "%backupRoot%\%copyFileName%">nul 
		echo 【!file!】複製完畢
	)else (
		echo 【!file!】不存在，不複製
	)
)
endlocal
rem 清空參數後返回
set copyFilePath=
set copyFileName=
goto :eof