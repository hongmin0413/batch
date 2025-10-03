@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe
set zipExe=C:\Program Files\7-Zip\7z.exe

set backupRoot=C:\backup
set backupBackup=history
set programRoot=D:\workspace
set serverRoot=D:\APPS
set dbBackupRoot=D:\DB\SQL2019\Backup

echo 即將備份program、server、DB、其它資料夾，若要完整備份，請先關閉eclipse及結束server 
echo 請按任意鍵繼續... 
pause>nul

rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot%" (
	mkdir "%backupRoot%"
)

rem 備份農業部 
rem 2024.07.23 增加備份MOADoms2501 
set orgName=農業部 
set programName=workspace_MOA_COA
set serverName=wildfly-21.0.0.Final_COA
set dbName=MOADoms00、MOADoms25、eipdb、MOADoms2501
call :backup

rem 備份智慧局 
set orgName=智慧局 
set programName=workspace_MOA_TIPO
set serverName=wildfly-21.0.0.Final_TIPO
set dbName=signdoms30new
call :backup

rem 備份智慧局_111增修 
set orgName=智慧局_111增修 
set programName=workspace_MOA_TIPO
rem set serverName=wildfly-21.0.0.Final_TIPO(與智慧局同，不備份) 
rem set dbName=signdoms30new(與智慧局同，不備份) 
call :backup

rem 備份國發會 
set orgName=國發會 
set programName=workspace_MOA_CI
set serverName=wildfly-10.0.0.Final_CI
set dbName=signdoms27
call :backup

rem 備份國發會_111增修 
set orgName=國發會_111增修 
set programName=workspace_MOA_CI
rem set serverName=wildfly-10.0.0.Final_CI(與國發會同，不備份) 
rem set dbName=signdoms27(與國發會同，不備份) 
call :backup

rem 備份農險基金 
set orgName=農險基金 
set programName=workspace_MOA_農保基金
set serverName=wildfly-20.0.1.Final_農水署
set dbName=signdoms32
call :backup

rem 備份經濟部 
set orgName=經濟部 
set programName=workspace_MOA_MOEA
set serverName=wildfly-21.0.0.Final_MOEA
set dbName=signdomsMOEANew、signdomsAOC
call :backup

rem 2024.10.07 增加備份個資處 
set orgName=個資處 
set programName=workspace_PDPC
set serverName=wildfly-21.0.0.Final_PDPC
set dbName=signdomsPDPC
call :backup

rem 備份經濟部OA 
set orgName=經濟部OA 
set programName=workspace_OASystem_JDK17
set serverName=wildfly-28.0.1.Final_moeaoa
set dbName=moeaoa
call :backup

rem 2025.02.07 增加備份衛福部OA 
rem 2025.05.27 調整資料庫名稱 
set orgName=衛福部OA 
set programName=workspace_OASystem_JDK21
set serverName=wildfly-34.0.0.Final_MOHW_OA
set dbName=moeaoaMOHW
call :backup

rem 2025.09.30 增加備份Q-dir資料 
set copyFilePath=D:\Tools\BC
set copyFileName=Q-Dir
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
rem dbName有值才備份 
if "%dbName%" neq "" (
	echo ================================================================================ 
	rem 拆解dbName做備份 
	set tempDbName=%dbName%
	:splitDbName
	for /f "tokens=1,* delims=、" %%i in ("!tempDbName!") do (
		set singleDbName=%%i
		rem 要備份的db存在且未離線才備份 
		set isDbExist=false
		set checkDbSQL=SELECT name FROM sys.databases where state = 0 and name = '!singleDbName!'
		for /f "delims=" %%i in ('sqlcmd -S localhost^,1433 -Q "!checkDbSQL!"^| findstr "!singleDbName!"') do (
			set isDbExist=true
		)
		if !isDbExist! equ true (
			rem c槽的db備份檔若存在就先移到備份的備份中 
			set dbBak=!backupPath!\!singleDbName!.bak
			if exist "!dbBak!" (
				echo 有【%orgName%】版的db-!singleDbName!備份檔，先移到備份的備份中 
				move /y "!dbBak!" !backupBackupPath!>nul
			)
			rem d槽的db備份檔若存在就先刪除 
			set dbBak2=%dbBackupRoot%\!singleDbName!.bak
			if exist "!dbBak2!" (
				del /f "!dbBak2!"
			)
			rem 先備份在c槽，再複製到d槽 
			echo 開始備份【%orgName%】版的db-!singleDbName!... 
			sqlcmd -S localhost^,1433 -Q "BACKUP DATABASE !singleDbName! TO DISK = '!dbBak!'">nul 
			copy /y "!dbBak!" "!dbBak2!">nul 
			echo 【%orgName%】版的db-!singleDbName!備份完畢
		)else (
			echo 【%orgName%】版的db-!singleDbName!不存在或已離線，不備份
		)
		set tempDbName=%%j
	)
	if "!tempDbName!" neq "" (
		goto splitDbName
	)
)
endlocal
rem 清空參數後返回
set orgName=
set programName=
set serverName=
set dbName=
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