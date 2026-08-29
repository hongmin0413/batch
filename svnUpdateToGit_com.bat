@echo off
chcp 65001>nul

set isExitAfterSync=%~1

echo 正在同步本地svn至git... 

rem 農業部 
set gitName=MOADoms-trunk_V3
set localGitDirPath=D:\workspace\農業部\MOADoms_MOA
call :syncFromSvn

rem 智慧局、智慧局_115增修 
set gitName=MOADoms-trunk_V2、MOADoms-trunk_V2_115
set localGitDirPath=D:\workspace\智慧局\MOADoms_TIPO
call :syncFromSvn

rem 國發會 
set gitName=MOADoms-branches
set localGitDirPath=D:\workspace\國發會\MOADoms_NDC
call :syncFromSvn

rem 農險基金 
set gitName=MOADoms-trunk_V1.5
set localGitDirPath=D:\workspace\農險基金\MOADoms_TAIF
call :syncFromSvn

rem 經濟部 
set gitName=MOADoms-trunk_V4
set localGitDirPath=D:\workspace\經濟部\MOADoms_MOEA
call :syncFromSvn

rem 個資處 
set gitName=MOADoms-trunk_V3.5
set localGitDirPath=D:\workspace\個資處\MOADoms_PDPC
call :syncFromSvn

rem 經濟部OA_docker 
set gitName=OASystem-trunk_V3
set localGitDirPath=D:\workspace\經濟部OA_docker\OASystem_MOEA_docker
call :syncFromSvn

rem 衛福部OA 
set gitName=OASystem-trunk_V2
set localGitDirPath=D:\workspace\衛福部OA\OASystem_MOHW
call :syncFromSvn

rem 經濟部EM 
set gitName=EMSystem-trunk
set localGitDirPath=D:\workspace\經濟部EM\EMSystem_MOEA
call :syncFromSvn

rem MOADoms設定檔 
set gitName=MOADoms-setting
set localGitDirPath=C:\Project\JavaProject\MOADoms
call :syncFromSvn

rem OASystem設定檔 
set gitName=OASystem-setting
set localGitDirPath=C:\Project\JavaProject\OASystem
call :syncFromSvn

rem EMSystem設定檔 
set gitName=EMSystem-setting
set localGitDirPath=C:\Project\JavaProject\EMSystem
call :syncFromSvn

if "%isExitAfterSync%" equ "true" (
	goto :eof
)else (
	echo 請按任意鍵退出...
	pause>nul
)

:syncFromSvn
setlocal enabledelayedexpansion
if "%gitName%" neq "" (
	echo ================================================================================ 
	echo git名稱：%gitName% 
	if exist "%localGitDirPath%\.git" (
		cd /d "%localGitDirPath%"
		rem 遠端git是否有commit過 
		set "isHasCommit=false"
		rem 2026.08.04 因應可能有多個遠端git，改用pwsh取得所有remoteGitDirPath 
		for /f "delims=" %%i in ('pwsh -Command "git remote -v | Select-String '(fetch)' | ForEach-Object { ($_ -split '\s+')[1] -replace '\\\.git$', '' }"') do (
			set "remoteGitDirPath=%%i"
			echo 本地svn路徑 : !remoteGitDirPath! 
			if exist "!remoteGitDirPath!\.git" (
				cd /d "!remoteGitDirPath!"
				set "isChanged=false"
				for /f "delims=" %%a in ('git status --porcelain') do set "isChanged=true"
				if "!isChanged!" equ "true" (
					set "isHasCommit=true"
					git add .
					git commit -m "sync from svn"
					echo 同步本地svn至遠端git成功 
				)else (
					echo 目前本地svn沒有變更 
				)
			)else (
				echo 請先初始化遠端git 
			)
		)
		rem 2026.08.04 因應可能有多個遠端git，改為全部都commit過再執行同步至本地git 
		if "!isHasCommit!" equ "true" (
			cd /d "%localGitDirPath%"
			pwsh -File ".\.vscode\taskPowershell\fetchRemoteGit.ps1"
			rem 2026.08.06 若更新失敗，不要直接離開，這樣才能看錯誤訊息 
			if "!errorlevel!" neq "0" (
				set isExitAfterSync=false
			)
		)else (
			echo 本地svn皆無變更，不同步遠端git至本地git 
		)
		cd "%~dp0"
	)else (
		echo 請先初始化本地git 
	)
)
endlocal
rem 清空參數後返回 
set gitName=
set localGitDirPath=
goto :eof