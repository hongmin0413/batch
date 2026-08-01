@echo off
chcp 65001>nul

set isExitAfterSync=%~1

echo 正在同步本地svn變更至遠端git... 

rem 智慧局 
set remoteGitName=trunk_V2
set gitDirPath=D:\SVN\新世代公文行動簽核方案\程式\trunk_V2\MOADomsEE\MOADomsEE
call :syncFromSvn

if "%isExitAfterSync%" equ "true" (
	goto :eof
)else (
	echo 請按任意鍵退出...
	pause>nul
)

:syncFromSvn
setlocal enabledelayedexpansion
if "%remoteGitName%" neq "" (
	echo ================================================================================ 
	echo 遠端git名稱：%remoteGitName% 
	if not exist "%gitDirPath%\.git" (
		echo 請先初始化遠端git 
	)else (
		cd "%gitDirPath%"
		rem 先檢查本地svn是否有變更，有變更再同步 
		set isChanged=false
		for /f %%i in ('git status --porcelain') do set isChanged=true
		if "!isChanged!" equ "true" (
			git add .
			git commit -m "sync from svn"
			echo 同步本地svn變更成功 
		)else (
			echo 目前本地svn沒有變更 
		)
		cd "%~dp0"
	)
)
endlocal
rem 清空參數後返回 
set remoteGitName=
set gitDirPath=
goto :eof