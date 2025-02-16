@echo off
chcp 65001>nul

rem 是否開啟應用程式的布林值 
set isOpenEclipse=true
set isOpenQ-dir=true
set isOpenBcompare=true
set isOpenChrome=true
set isOpenEdge=true
set isOpenNotepad=true
set isOpenTaskManager=true

setlocal enabledelayedexpansion

rem 開啟eclipse 
if %isOpenEclipse% equ true (
	rem 2024.08.22 調整為直接call另一個資料夾寫好的bat 
	set openEclipseBatDir=D:\workspace\開啟程式編輯器
	if exist "!openEclipseBatDir!" (
		rem 2024.09.16 直接進到資料夾call，因為bat的內容是用相對路徑執行的 
		rem 2024.10.15 修正參數使用錯誤的問題 
		rem 2024.12.16 修正無法切換到d槽的問題 
		rem 2025.02.07 增加機關 
		cd /d "!openEclipseBatDir!"
		call "農業部.bat" && timeout /t 10 /nobreak>nul
		call "智慧局.bat" && timeout /t 10 /nobreak>nul
		rem call "智慧局_111增修.bat" && timeout /t 10 /nobreak>nul
		call "國發會.bat" && timeout /t 10 /nobreak>nul
		rem call "國發會_111增修.bat" && timeout /t 10 /nobreak>nul
		rem call "農險基金.bat" && timeout /t 10 /nobreak>nul
		call "經濟部.bat" && timeout /t 10 /nobreak>nul
		rem call "個資處.bat" && timeout /t 10 /nobreak>nul
		rem call "經濟部OA.bat" && timeout /t 10 /nobreak>nul
		rem call "衛福部OA.bat" && timeout /t 10 /nobreak>nul
		cd "%~dp0"
	)
)

rem 開啟Q-dir 
if %isOpenQ-dir% equ true (
	start "" /min "D:\Tools\BC\Q-Dir\Q-Dir.exe" 
)

rem 開啟bcompare 
if %isOpenBcompare% equ true (
	set bcompareExe=D:\Tools\BC\Beyond Compare 4\BCompare.exe
	rem 先讀取程式設定檔的config.ini 
	rem 2024.05.15 調整程式設定檔config.ini的路徑 
	rem 2024.07.23 參考開啟eclipse方式，確保開啟順序且不會中途卡住 
	rem 2025.02.07 增加機關 
	for /f "delims=" %%i in ('type "C:\Project\JavaProject\更新機關設定檔指令\config.ini"^| find /i "="') do set %%i
	start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_農業部" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_智慧局" && timeout /t 3 /nobreak>nul
	rem start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_智慧局_111增修" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_國發會" && timeout /t 3 /nobreak>nul
	rem start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_國發會_111增修" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_農險基金" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_經濟部" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_個資處" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "OASystemEE <--> workspace_經濟部OA" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "OASystemEE <--> workspace_衛福部OA" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "!currentOrgName!\MOADoms_settings" && timeout /t 3 /nobreak>nul
	rem start "" /min "!bcompareExe!" "經濟部OA\OASystem_settings" && timeout /t 3 /nobreak>nul
	rem start "" /min "!bcompareExe!" "衛福部OA\OASystem_settings" && timeout /t 3 /nobreak>nul
)

rem 開啟chrome 
if %isOpenChrome% equ true (
	start "" /min "C:\Program Files\Google\Chrome\Application\chrome.exe" 
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

endlocal