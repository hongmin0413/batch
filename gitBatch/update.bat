@echo off
chcp 65001>nul

rem 設定資料夾名稱
cd ..\
set dirName=%1
if not exist "%dirName%" (
	if "%dirName%" equ "" (
		echo dirName不可空白，請按任意鍵退出...
	)else (
		echo dirName設定錯誤，因為%cd%\%dirName%不存在，請按任意鍵退出...
	)
	goto pauseAndExit
)
rem 113.02.20 增加檢查本地是否有repository
if not exist "%dirName%\.git" (
    echo %cd%\%dirName%下無repository，請初始化git或確認dirName是否設定錯誤 
    echo 請按任意鍵退出...
	goto pauseAndExit
)
cd "%~dp0"
rem 設定git名稱
set gitName=%2
if "%gitName%" equ "" (
	set gitName=%dirName%
)
rem 讀取config.ini並設為參數
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i
echo 欲執行的專案：%gitName%

rem 詢問欲執行的動作
echo 1：執行push
echo 2：執行pull
echo 3：看status
set /p action=請輸入欲執行的動作(預設執行push)：
if "%action%" equ "" (
	set action=1
)
rem 執行動作前，先移動到專案的資料夾下
cd "..\%dirName%"
if %action% equ 2 (
	goto pull
)else if %action% equ 3 (
	goto seeStatus
)else (
	goto commitAndPush
)

:commitAndPush
rem 先檢查程式碼是否更新
call :seeStatus
rem 設定commit的訊息 
set /p commitMsg=請輸入commit %dirName% 的訊息(預設update %gitName%)：
if "%commitMsg%" equ "" (
	set commitMsg=update %gitName%
)
echo 開始commit
git add .
git commit -m "%commitMsg%"
echo commit成功
:push
echo 開始執行push
git push https://%token%@github.com/%username%/%gitName%.git
set pushError=%errorlevel%
if %pushError% neq 0 (
	if %pushError% equ 1 (
		echo github程式碼有更新過的檔案，請按任意鍵開始執行pull...
		pause>nul
		goto pull 
	rem errorlevel=128 
	)else (
		echo gitName設定錯誤，遠端repository不存在，退回commit前的版本 
		rem 113.02.20 增加退回commit前的版本
        git reset HEAD~1
		echo 請按任意鍵退出...
		goto pauseAndExit
	)
)
echo 執行push成功
echo 更新github程式碼成功，請按任意鍵退出...
goto pauseAndExit

:pull
rem 先檢查是否有修改過的檔案，排除開頭為UU的(尚未合併，本機、github程式碼均已修改)
setlocal enabledelayedexpansion
set changedFile=
for /f "delims=" %%i in ('git status --porcelain^| findstr /i /r /v "^UU"') do (
	set changedFile=!changedFile!、%%i
)
if "!changedFile!" neq "" (
	echo 下列檔案有修改過，先執行stash...
	set splitString=!changedFile!
	call :splitStringAndEcho
	git stash
)
echo 開始執行pull
git pull https://%token%@github.com/%username%/%gitName%.git
set pullError=%errorlevel%
if !pullError! neq 0 (
	rem 將之前stash的pop回來
	if "!changedFile!" neq "" (
		git stash pop
	)
	if !pullError! equ 128 (
		echo 有未合併的檔案^(UU^)，請先執行push
	)else (
		rem 單純執行pull造成的錯誤
		if %action% equ 2 (
			echo gitName設定錯誤，遠端repository不存在 
		rem 執行push失敗再執行pull造成的錯誤
		)else (
			rem 列出有conflict的檔案，只看開頭為UU的(尚未合併，本機、github程式碼均已修改)
			for /f "delims=" %%i in ('git status --porcelain^| findstr /i /r "^UU"') do (
				set file=%%i
				set conflictFile=!conflictFile!、!file:~2!
			)
            echo 執行pull成功，但下列檔案發生conflict，請解決後再繼續執行push
			set splitString=!conflictFile!
			call :splitStringAndEcho
		)
	)
	echo 請按任意鍵退出...
	goto pauseAndExit
)
echo 執行pull成功
rem 執行pull成功後將之前stash的pop回來
if "!changedFile!" neq "" (
	git stash pop
	rem 檢查是否有conflict的檔案，只看開頭為UU的(尚未合併，本機、github程式碼均已修改)
	for /f "delims=" %%i in ('git status --porcelain^| findstr /i /r "^UU"') do (
		set file=%%i
		set conflictFile=!conflictFile!、!file:~2!
	)
	if "!conflictFile!" neq "" (
		git stash clear
		echo 下列檔案發生conflict，請解決後再執行push
		set splitString=!conflictFile!
		call :splitStringAndEcho
	)
)
rem 從執行push來，執行pull成功後再繼續執行push
if %action% neq 2 (
	goto push
)
endlocal
echo 更新本地程式碼成功，請按任意鍵退出...
goto pauseAndExit

:seeStatus
for /f "delims=" %%i in ('git status --porcelain') do (
	rem 看status
	if %action% equ 3 (
		echo 本機程式碼更新列表如下：
		git status -s
		echo 請按任意鍵退出...
		goto pauseAndExit
	rem 執行push前的檢查，有更新就跳回繼續設定commit的訊息
	)else (
		goto :eof
	)
)
echo 本機程式碼無更新，請按任意鍵退出...
goto pauseAndExit

:splitStringAndEcho
rem 拆解字串並echo 
rem 113.02.23 修改區隔符號為"、" 
for /f "tokens=1,* delims=、" %%i in ("%splitString%") do (
	echo %%i
	set splitString=%%j
)
if "%splitString%" neq "" (
	goto splitStringAndEcho
)
goto :eof

:pauseAndExit
pause>nul
exit