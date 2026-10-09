@echo off
chcp 65001>nul

rem 情況一：A->A、A_new 
set mysqlType1=tidb
set srcDb1=ALMS
set targetDb1=ALMS_dev_revise_setUpSpecialEntry
set targetBackupDb1=
set dropSrcDb1=N

rem 情況二：A->A_backup、A_new->A、~~A_new~~ 
set mysqlType2=tidb
set srcDb2=ALMS_dev_revise_setUpSpecialEntry
set targetDb2=ALMS
set targetBackupDb2=ALMS_backup
set dropSrcDb2=Y

rem 第一個參數可直接指定情況，沒給就顯示選單 
set scene=%~1
if "%scene%" neq "" goto :setScene
echo 請選擇情況（若資料庫名稱錯誤，請先開啟修改）： 
echo   1. %srcDb1% -^> %targetDb1%（保留 %srcDb1%） 
echo   2. %targetDb2% -^> %targetBackupDb2%，%srcDb2% -^> %targetDb2%（刪除 %srcDb2%） 
choice /c 12 /n /m "請輸入 1 或 2： "
if errorlevel 2 (set scene=2) else (set scene=1)
:setScene
if "%scene%" neq "1" if "%scene%" neq "2" (
	echo 情況只能是 1 或 2 
	goto :fail
)
call set mysqlType=%%mysqlType%scene%%%
call set srcDb=%%srcDb%scene%%%
call set targetDb=%%targetDb%scene%%%
call set targetBackupDb=%%targetBackupDb%scene%%%
call set dropSrcDb=%%dropSrcDb%scene%%%

cd /d "%~dp0"
rem 讀取config.ini並設為參數 
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i
if "%mysqlType%" equ "tidb" (
	set "mysqlInfo=%tidbInfo1%"
) else (
	set "mysqlInfo=%mysqlInfo1%"
)
set tempOutFile=%TEMP%\swapMysqlDb_out.txt

rem 檢查資料庫是否存在 
call :getDbCount "%srcDb%"
if "%dbCount%" neq "1" (
	echo 【%srcDb%】不存在，不處理 
	goto :fail
)
rem targetDb不存在時，不備份、不刪除，直接把srcDb還原成targetDb 
call :getDbCount "%targetDb%"
set hasTarget=%dbCount%
call :getTableCount "%srcDb%"
set srcTableCount=%tableCount%
if "%hasTarget%" neq "1" (
	echo 【%targetDb%】不存在，不備份，直接把【%srcDb%】還原成【%targetDb%】 
	goto :checkDone
)
if "%targetBackupDb%" equ "" (
	echo 【%targetDb%】已存在，targetBackupDb不可空白 
	goto :fail
)
call :getDbCount "%targetBackupDb%"
if "%dbCount%" neq "0" (
	echo 【%targetBackupDb%】已存在，請修改targetBackupDb後再執行 
	goto :fail
)
call :getTableCount "%targetDb%"
set targetTableCount=%tableCount%
:checkDone
echo. 
echo 即將切換%mysqlType%的資料庫： 
if "%hasTarget%" equ "1" (
	echo   1. %targetDb% -^> %targetBackupDb%^(備份^) 
	echo   2. %srcDb% -^> %targetDb% 
)else (
	echo   %srcDb% -^> %targetDb% 
)
echo 請先停止連線到這些資料庫的應用程式 

rem 先備份資料庫(srcDb、targetDb，備份檔放在util.bat的mysqlBackupRoot、tidbBackupRoot) 
echo. 
set "backupDbNames=%srcDb%"
if "%hasTarget%" equ "1" set "backupDbNames=%targetDb%、%srcDb%"
echo [1/4] 備份 %backupDbNames% 
call util.bat "backupMysql" "%mysqlInfo%" "%backupDbNames%" "%mysqlType%"
rem 備份檔要存在且不是空的才繼續 
set "backupDir=%mysqlBackupRoot%"
if "%mysqlType%" equ "tidb" set "backupDir=%tidbBackupRoot%"
set backupFiles="%backupDir%\%srcDb%.sql"
if "%hasTarget%" equ "1" set backupFiles="%backupDir%\%targetDb%.sql" "%backupDir%\%srcDb%.sql"
for %%f in (%backupFiles%) do (
	if not exist "%%~f" (
		echo 備份檔【%%~f】不存在，中止 
		goto :fail
	)
	if %%~zf equ 0 (
		echo 備份檔【%%~f】是空的，中止 
		goto :fail
	)
)

rem targetDb -> targetBackupDb 
echo. 
if "%hasTarget%" neq "1" (
	echo [2/4] 【%targetDb%】不存在，略過 
	goto :restoreSrc
)
echo [2/4] %targetDb% -^> %targetBackupDb% 
call util.bat "restoreMysql" "%mysqlInfo%" "%targetDb%" "%targetBackupDb%" "%mysqlType%"
if errorlevel 1 (
	echo 還原【%targetBackupDb%】失敗，【%targetDb%】沒有被刪除，中止 
	goto :fail
)
rem 還原成功才刪除targetDb 
call :getTableCount "%targetBackupDb%"
if "%tableCount%" neq "%targetTableCount%" (
	echo 還原【%targetBackupDb%】失敗，【%targetDb%】沒有被刪除，中止 
	goto :fail
)
echo 刪除【%targetDb%】... 
set "mysqlSql=DROP DATABASE %targetDb%;"
call util.bat "executeMysql" "%mysqlInfo%" ""
if errorlevel 1 (
	echo 刪除【%targetDb%】失敗，中止 
	goto :fail
)

rem srcDb -> targetDb 
:restoreSrc
echo. 
echo [3/4] %srcDb% -^> %targetDb% 
call util.bat "restoreMysql" "%mysqlInfo%" "%srcDb%" "%targetDb%" "%mysqlType%"
if errorlevel 1 (
	if "%hasTarget%" equ "1" (
		echo 還原【%targetDb%】失敗！舊的資料已備份在【%targetBackupDb%】及備份檔%targetDb%.sql，請手動處理 
	)else (
		echo 還原【%targetDb%】失敗，請手動處理 
	)
	goto :fail
)
call :getTableCount "%targetDb%"
if "%tableCount%" neq "%srcTableCount%" (
	echo 還原【%targetDb%】失敗，【%srcDb%】沒有被刪除，請檢查 
	goto :fail
)

rem 刪除srcDb 
echo. 
echo [4/4] 刪除【%srcDb%】 
if /i "%dropSrcDb%" equ "Y" (
	set "mysqlSql=DROP DATABASE %srcDb%;"
	call util.bat "executeMysql" "%mysqlInfo%" ""
	if errorlevel 1 (
		echo 刪除【%srcDb%】失敗 
		goto :fail
	)
	echo 【%srcDb%】已刪除 
)else (
	echo dropSrcDb不是Y，不刪除【%srcDb%】 
)

echo. 
echo ================================================================================ 
if "%hasTarget%" equ "1" (
	echo 完成：【%targetBackupDb%】為舊的【%targetDb%】，【%targetDb%】為原本的【%srcDb%】 
)else (
	echo 完成：【%targetDb%】為原本的【%srcDb%】 
)
goto :end

rem 取得資料庫的數量(0或1)，結果放在dbCount 
:getDbCount
set dbCount=0
set "mysqlSql=SELECT COUNT(1) FROM information_schema.schemata WHERE schema_name = '%~1';"
call util.bat "executeMysql" "%mysqlInfo%" "%tempOutFile%"
set /p dbCount=<"%tempOutFile%"
goto :eof

rem 取得資料庫的資料表(含檢視)數量，結果放在tableCount 
:getTableCount
set tableCount=0
set "mysqlSql=SELECT COUNT(1) FROM information_schema.tables WHERE table_schema = '%~1';"
call util.bat "executeMysql" "%mysqlInfo%" "%tempOutFile%"
set /p tableCount=<"%tempOutFile%"
goto :eof

:fail
echo. 
echo 發生錯誤，已中止 
:end
set "mysqlInfo="
echo 請按任意鍵退出... 
pause>nul
exit /b