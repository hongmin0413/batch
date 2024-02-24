@echo off
chcp 65001>nul

rem 設定資料夾名稱
cd ..\
:inputDirName
set /p dirName=請輸入資料夾名稱：
if not exist "%dirName%" (
	if "%dirName%" equ "" (
		echo 資料夾名稱不可空白
	)else (
		echo %cd%\%dirName%不存在
	)
	rem 重新輸入資料夾名稱
	goto inputDirName
)
cd "%~dp0"
rem 設定git名稱
set isReInputGitName=false
:inputGitName
set gitName=
set /p gitName=請輸入git名稱(預設%dirName%)：
if "%gitName%" equ "" (
	set gitName=%dirName%
)
if %isReInputGitName% equ true (
	rem 若為重新輸入git名稱，直接跳到push
	goto push
)
rem 設定first commit的訊息 
set /p commitMsg=請輸入first commit %dirName%的訊息(預設first commit)：
if "%commitMsg%" equ "" (
	set commitMsg=first commit
)
rem 設定repository的branch
set /p branchName=請輸入repository的branch(預設main)：
if "%branchName%" equ "" (
	set branchName=main
)
rem 讀取config.ini並設為參數
for /f "delims=" %%i in ('type "config.ini"^| find /i "="') do set %%i

rem init、first commit
echo 開始init、first commit
cd "..\%dirName%"
git init
git add .
git commit -m "%commitMsg%"
git branch -M %branchName%
rem 先移除原有的remote
git remote remove origin
git remote add origin https://github.com/%username%/%gitName%.git
:push
git push https://%token%@github.com/%username%/%gitName%.git
if %errorlevel% neq 0 (
	echo 遠端repository不存在 
	rem 重新輸入git名稱，將isReInputGitName變為true
	set isReInputGitName=true
	goto inputGitName
)
echo init、first commit成功

rem 建立upd_XXX.bat(之後更新程式碼用)
echo 開始建立upd_%dirName%.bat
cd "%~dp0"
rem 先覆蓋，避免原本有檔案
echo ^@echo off>upd_%dirName%.bat
echo ^chcp 65001^>nul>>upd_%dirName%.bat
echo ^set dirName=%dirName%>>upd_%dirName%.bat
echo ^set gitName=%gitName%>>upd_%dirName%.bat
echo ^call ^update.bat %%dirName%% %%gitName%%>>upd_%dirName%.bat
echo 建立upd_%dirName%.bat成功

echo 初始化成功，請按任意鍵退出...
pause>nul
exit