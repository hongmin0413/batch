@echo off
chcp 65001>nul

set bcompare="HKEY_CURRENT_USER\Software\Scooter Software\Beyond Compare 4"
set addTimeKey=CacheID

rem 檢查是否有addTimeKey
for /f "delims=" %%i in ('reg query %key% /v "*" ^| findstr /i "%addTimeKey%"') do (
	goto addTime
)
exit

rem 延長bcompare時間
:addTime
reg delete %bcompare% /v %addTimeKey% /f