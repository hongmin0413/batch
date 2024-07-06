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
	set eclipseExe1=D:\APPS\eclipse-jee-2020-12-R\eclipse.exe
	set eclipseExe2=D:\APPS\eclipse-jee-2023-06-R\eclipse.exe
	start "" /min "!eclipseExe1!" -data "D:\workspace\農業部\workspace_MOA_COA" && timeout /t 10 /nobreak>nul
	start "" /min "!eclipseExe1!" -data "D:\workspace\智慧局\workspace_MOA_TIPO" && timeout /t 10 /nobreak>nul
	rem start "" /min "!eclipseExe1!" -data "D:\workspace\智慧局_111增修\workspace_MOA_TIPO" && timeout /t 10 /nobreak>nul
	start "" /min "!eclipseExe1!" -data "D:\workspace\國發會\workspace_MOA_CI" && timeout /t 10 /nobreak>nul
	rem start "" /min "!eclipseExe1!" -data "D:\workspace\國發會_111增修\workspace_MOA_CI" && timeout /t 10 /nobreak>nul
	rem start "" /min "!eclipseExe1!" -data "D:\workspace\農險基金\workspace_MOA_農保基金" && timeout /t 10 /nobreak>nul
	start "" /min "!eclipseExe1!" -data "D:\workspace\經濟部\workspace_MOA_MOEA" && timeout /t 10 /nobreak>nul
	rem start "" /min "!eclipseExe2!" -data "D:\workspace\經濟部OA\workspace_OASystem_JDK17" && timeout /t 10 /nobreak>nul
)

rem 開啟Q-dir 
if %isOpenQ-dir% equ true (
	start "" /min "D:\Tools\BC\Q-Dir\Q-Dir.exe" 
)

rem 開啟bcompare 
if %isOpenBcompare% equ true (
	set bcompareExe=D:\Tools\BC\Beyond Compare 4\BCompare.exe
	rem 先讀取程式設定檔的config.ini 
	rem 113.05.15 調整程式設定檔config.ini的路徑 
	for /f "delims=" %%i in ('type "C:\Project\JavaProject\更新機關設定檔指令\config.ini"^| find /i "="') do set %%i
	start "" /min "!bcompareExe!" "MOADomsEE <--> workspace_農業部"
	"!bcompareExe!" "MOADomsEE <--> workspace_智慧局"
	rem "!bcompareExe!" "MOADomsEE <--> workspace_智慧局_111增修"
	"!bcompareExe!" "MOADomsEE <--> workspace_國發會"
	rem "!bcompareExe!" "MOADomsEE <--> workspace_國發會_111增修"
	"!bcompareExe!" "MOADomsEE <--> workspace_農險基金"
	"!bcompareExe!" "MOADomsEE <--> workspace_經濟部"
	"!bcompareExe!" "OASystemEE <--> workspace_經濟部OA"
	start "" /min "!bcompareExe!" "!currentOrgName!\MOADoms_settings"
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