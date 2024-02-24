@echo off
chcp 65001>nul

rem 讀取config.ini並設為參數
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i

rem 更新username(與原先不同才更新)
:reviseUsername
for /f "delims=" %%i in ('git config --global user.name^| findstr /r "[^%username%]"') do (
	git config --global user.name "%username%"
	if %errorlevel% equ 0 (
		echo 更新git的使用者名稱為%username%成功
		goto reviseUseremail
	)else (
		echo 更新git的使用者名稱為%username%失敗，請按任意鍵退出...
		goto pauseAndExit
	)
)
echo git的使用者名稱已為%username%，不更新

rem 更新useremail(與原先不同才更新)
:reviseUseremail
for /f "delims=" %%i in ('git config --global user.email^| findstr /r "[^%useremail%]"') do (
	git config --global user.email %useremail%
	if %errorlevel% equ 0 (
		echo 更新git的使用者信箱為%useremail%成功
		goto reviseSafecrlf
	)else (
		echo 更新git的使用者信箱為%useremail%失敗，請按任意鍵退出...
		goto pauseAndExit
	)
)
echo git的使用者信箱已為%useremail%，不更新

rem 修改safecrlf，避免出現LF would be replaced by CRLF(不是false才更新)
:reviseSafecrlf
set safecrlf=false
for /f "delims=" %%i in ('git config --global core.safecrlf^| findstr /r "[^%safecrlf%]"') do (
	git config --global core.safecrlf %safecrlf%
	if %errorlevel% equ 0 (
		echo 修改git的safecrlf為%safecrlf%成功
		goto reviseSuccess
	)else (
		echo 修改git的safecrlf為%safecrlf%失敗，請按任意鍵退出...
		goto pauseAndExit
	)
)
echo git的safecrlf已為%safecrlf%，不更新

:reviseSuccess
echo 請按任意鍵退出...
goto pauseAndExit

:pauseAndExit
pause>nul
exit