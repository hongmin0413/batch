@echo off
chcp 65001>nul

rem 是否開啟應用程式的布林值 
set isOpenCursor=true
set isOpenQ-dir=true
set isOpenBcompare=true
set isOpenChrome=false
set isOpenEdge=true
set isOpenNotepad=true
set isOpenTaskManager=true

setlocal enabledelayedexpansion

rem 開啟cursor 
if %isOpenCursor% equ true (
	set cursorExe=C:\Users\User\AppData\Local\Programs\cursor\Cursor.exe
	rem 2024.10.19 ALMS_new -> ALMS 
	rem 2025.01.18 更換目錄 
	start "" /min "!cursorExe!" "D:\javaWebWorkspace\ALMS"
)

rem 開啟Q-dir 
if %isOpenQ-dir% equ true (
	start "" /min "D:\Q-Dir\Q-Dir.exe" 
)

rem 開啟bcompare 
if %isOpenBcompare% equ true (
    set bcompareExe=D:\Beyond Compare 4\BCompare.exe
	rem 2024.10.06 參考開啟eclipse方式，確保開啟順序且不會中途卡住 
	rem 2024.10.06 增加batch 
	rem 2025.01.18 更換ALMS目錄 
	rem 2025.04.20 增加cursorSetting 
	start "" /min "!bcompareExe!" "github <--> localhost_ALMS" && timeout /t 3 /nobreak>nul
	rem start "" /min "!bcompareExe!" "company <--> localhost_ALMS" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "cursor <--> localhost_cursorSetting" && timeout /t 3 /nobreak>nul
	rem start "" /min "!bcompareExe!" "company <--> localhost_cursorSetting" && timeout /t 3 /nobreak>nul
	start "" /min "!bcompareExe!" "batch" && timeout /t 3 /nobreak>nul
	rem start "" /min "!bcompareExe!" "gitBatch" && timeout /t 3 /nobreak>nul
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

endlocal