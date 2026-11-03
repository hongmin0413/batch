@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

setlocal enabledelayedexpansion
rem 取得是否為充電狀態(1=否，2=是)及電量 
rem 2026.10.03 wmic已被Windows移除，改用PowerShell的CIM 
set batteryStatus=1
set batteryRemain=0
for /f "tokens=1,2" %%i in ('powershell -NoProfile -Command "$b=@(Get-CimInstance Win32_Battery)[0]; if($b){$b.BatteryStatus.ToString()+' '+$b.EstimatedChargeRemaining}"') do (
	set batteryStatus=%%i
	set batteryRemain=%%j
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