@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

setlocal enabledelayedexpansion
rem 取得是否為充電狀態(1=否，2=是)
set batteryStatus=1
for /f "tokens=1,* delims= " %%i in ('wmic Path Win32_Battery Get BatteryStatus^| findstr /r "[0-9]"') do (
	set batteryStatus=%%i
)
rem 取得電量
set batteryRemain=0
for /f "tokens=1,* delims= " %%i in ('wmic Path Win32_Battery Get EstimatedChargeRemaining^| findstr /r "[0-9]"') do (
	set batteryRemain=%%i
)

rem 顯示電池狀態，有msg.exe>用視窗顯示，無msg.exe>直接顯示在cmd上 
set msg=
rem 未充電
if !batteryStatus! equ 1 (
	rem 電量<=45
	if !batteryRemain! leq 45 (
		set msg=目前電量為!batteryRemain!%%%，請盡快充筆電 
	)
rem 充電中
)else if !batteryStatus! equ 2 (
	rem 電量=100 
	if !batteryRemain! equ 100 (
		set msg=筆電已充飽，請移除充電線 
	rem 電量>=95
	)else if !batteryRemain! geq 95 (
		set msg=目前電量為!batteryRemain!%%%，筆電即將充飽 
	)
)
if "!msg!" neq "" (
	if exist "%msgExe%" (
		"%msgExe%" ^* "!msg!"
	)else (
		echo !msg! 
		echo 請按任意鍵退出...
		pause>nul
	)
)
endlocal