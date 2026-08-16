@echo off
chcp 65001>nul

rem 是否開啟應用程式的布林值 
set isOpenCursor=true
set isOpenAntigravity=false
set isOpenQ-dir=true
set isOpenBcompare=true
set isOpenChrome=false
set isOpenEdge=true
set isOpenNotepad=true
set isOpenTaskManager=true
set isOpenVirtuaWin=true

setlocal enabledelayedexpansion

rem 開啟cursor 
if %isOpenCursor% equ true (
	rem 2026.02.07 調整為直接call另一個資料夾寫好的bat 
	set openCursorDir=D:\githubWorkspace\01_開啟程式編輯器
	if exist "!openCursorDir!" (
		rem 2025.06.20 調整開啟寫法，避免每次都拋錯 
		rem 2026.03.15 參考開啟Antigravity，不知道為什麼換成start "" /b cmd /c才開得了 
		rem 2026.08.16 調整bat名稱 
		cd /d "!openCursorDir!"
		rem start "" /b cmd /c "ai-produce-sql-hex.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "ai-tool-hex.bat" && timeout /t 5 /nobreak>nul
		start "" /b cmd /c "alms.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "batch.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "batch-dev.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "chat-talker-hex.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "check-national-id-number.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "linebot-guess-number.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "station-typing.bat" && timeout /t 5 /nobreak>nul
		cd "%~dp0"
	)
)

rem 2026.02.07 增加開啟Antigravity 
if %isOpenAntigravity% equ true (
	set openAntigravityDir=D:\githubWorkspace\01_開啟程式編輯器
	if exist "!openAntigravityDir!" (
		rem 2026.02.20 不知道為什麼換成start "" /b cmd /c才開得了 
		rem 2026.08.16 調整bat名稱 
		cd /d "!openAntigravityDir!"
		start "" /b cmd /c "alms_agy.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "check-national-id-number_agy.bat" && timeout /t 5 /nobreak>nul
		rem start "" /b cmd /c "linebot-guess-number_agy.bat" && timeout /t 5 /nobreak>nul
		cd "%~dp0"
	)
)

rem 開啟Q-dir 
if %isOpenQ-dir% equ true (
	start "" /min "D:\Q-Dir\Q-Dir.exe" 
)

rem 開啟bcompare 
if %isOpenBcompare% equ true (
    set bcompareExe=D:\Beyond Compare 4\BCompare.exe
	set cloudDir=H:\我的雲端硬碟\programWorkspace
	rem 2024.10.06 參考開啟eclipse方式，確保開啟順序且不會中途卡住 
	rem 2024.10.06 增加batch 
	rem 2025.01.18 更換alms目錄 
	rem 2025.04.20 增加cursorSetting 
	rem 2026.01.31 更換batch目錄 
	rem 2026.02.07 間隔時間調整為5秒 
	rem 2026.03.16 batch增加cloud，當有連接到雲端時 
	rem 2026.08.01 alms增加cloud，當有連接到雲端時 
	if exist "!cloudDir!" (
		start "" /min "!bcompareExe!" "cloud <--> alms" && timeout /t 5 /nobreak>nul
		start "" /min "!bcompareExe!" "cloud <--> batch" && timeout /t 5 /nobreak>nul
	)
	rem start "" /min "!bcompareExe!" "cloud <--> cursorSetting" && timeout /t 5 /nobreak>nul
	rem start "" /min "!bcompareExe!" "cloud <--> antigravitySetting" && timeout /t 5 /nobreak>nul
)

rem 開啟chrome 
if %isOpenChrome% equ true (
	start "" /min "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 
)

rem 開啟edge 
if %isOpenEdge% equ true (
	start "" /min "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" 
)

rem 開啟notepad++ 
if %isOpenNotepad% equ true (
	start "" /min "C:\Program Files\Notepad++\notepad++.exe"
)

rem 開啟工作管理員 
if %isOpenTaskManager% equ true (
	taskmgr
)

rem 開啟virtuaWin 
if %isOpenVirtuaWin% equ true (
	start "" /min "D:\VirtuaWin_portable_4.5\VirtuaWin.exe"
)

endlocal