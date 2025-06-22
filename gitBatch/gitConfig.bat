@echo off
chcp 65001>nul

rem 讀取config.ini並設為參數 
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i

rem 更新username(與原先不同才更新) 
set configName=使用者名稱
set configNameForSet=user.name
set reviseValue=%username%
call :reviseConfig

rem 更新useremail(與原先不同才更新) 
set configName=使用者信箱
set configNameForSet=user.email
set reviseValue=%useremail%
call :reviseConfig

rem 修改safecrlf，避免出現LF would be replaced by CRLF(不是false才更新) 
set configName=safecrlf
set configNameForSet=core.safecrlf
set reviseValue=false
call :reviseConfig

rem 修改ignorecase，避免檔案或資料夾名稱沒更新到(不是false才更新) 
set configName=ignorecase
set configNameForSet=core.ignorecase
set reviseValue=false
call :reviseConfig

echo 請按任意鍵退出...
goto pauseAndExit

:reviseConfig
for /f "delims=" %%i in ('git config --global %configNameForSet%') do set configValue=%%i
if "%configValue%" neq "%reviseValue%" (
	git config --global %configNameForSet% %reviseValue%
	if %errorlevel% equ 0 (
		echo 更新git的%configName%為%reviseValue%成功
		goto :eof
	)else (
		echo 更新git的%configName%為%reviseValue%失敗，請按任意鍵退出...
		goto pauseAndExit
	)
)else (
	echo git的%configName%已為%reviseValue%，不更新
	goto :eof
)

:pauseAndExit
pause>nul
exit