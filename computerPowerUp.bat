@echo off
chcp 65001>nul

rem 是否開啟應用程式的布林值 
set isOpenEclipse=true
set isOpenVsCode=true
set isOpenQ-dir=true
set isOpenBcompare=true
set isOpenChrome=true
set isOpenEdge=true
set isOpenNotepad=true
set isOpenTaskManager=true

setlocal enabledelayedexpansion

rem 開啟eclipse 
if %isOpenEclipse% equ true (
    set eclipseExe=C:\Users\User\eclipse\jee-2021-12\eclipse\eclipse.exe
    start "" /min "!eclipseExe!" -data "D:\eclipse-workspace_JavaWeb" && timeout /t 10 /nobreak>nul
)

rem 開啟vs code 
if %isOpenVsCode% equ true (
    set vsCodeExe=C:\Users\User\AppData\Local\Programs\Microsoft VS Code\Code.exe
	start "" /min "!vsCodeExe!" "D:\eclipse-workspace_JavaWeb\ALMS_new"
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
	start "" /min "!bcompareExe!" "ALMS" && timeout /t 3 /nobreak>nul
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