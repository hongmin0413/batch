@echo off
chcp 65001>nul

set svnExe=C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe
set updateRootFile=D:\SVN

setlocal enabledelayedexpansion
set updateFile=
for /f "delims=" %%i in ('dir %updateRootFile% /b') do (
	set file=%updateRootFile%\%%i
	rem 資料夾下存在.svn才更新
	if exist "!file!\.svn" (
		if "!updateFile!" equ "" (
			set updateFile=!file!
		)else (
			rem 多個資料夾要用"*"隔開
			set updateFile=!updateFile!^*!file!
		)
	)
)
if "!updateFile!" equ "" (
	echo "%updateRootFile%"下無需更新的資料夾，請按任意鍵退出...
	pause>nul
)else (
	echo 正在更新SVN...
	"%svnExe%" /command:update /path:"!updateFile!" /closeonend:2
)
endlocal