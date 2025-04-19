@echo off
chcp 65001>nul

set msgExe=%~dp0%\msg.exe

set phoneFile=C:\backupPhoneAndCloud\phoneFile
set usbBackupDisc=E:
set backupRoot=%usbBackupDisc%\backup_phone

rem 先檢查是否插入隨身碟 
call util.bat "checkIsHasUsb" "%usbBackupDisc%"

rem 若備份root不存在，先建其資料夾 
if not exist "%backupRoot%" (
	mkdir "%backupRoot%"
)

rem 備份文件 
set fileName=文件
call util.bat "copyFile" "%backupRoot%" "%phoneFile%" "%fileName%"

rem 備份写真 
set fileName=写真
call util.bat "copyFile" "%backupRoot%" "%phoneFile%" "%fileName%"

rem 備份映画 
set fileName=映画
call util.bat "copyFile" "%backupRoot%" "%phoneFile%" "%fileName%"

rem 備份音樂 
set fileName=音樂
call util.bat "copyFile" "%backupRoot%" "%phoneFile%" "%fileName%"

set msg=備份完畢 
if exist "%msgExe%" (
	"%msgExe%" ^* "%msg%" 
)else (
	echo %msg% 
	echo 請按任意鍵退出... 
	pause>nul
)
exit