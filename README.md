# batch
* gitBat\gitConfig.bat：
	* 調整git config的程式

* gitBat\init.bat：
	* 初始化git時點擊的程式

* gitBat\update.bat：
	* 執行push or 執行pull or 看status時實際執行的程式

* backup_com.bat`(公司用)`：
	* 備份program、server、DB
	* 7-Zip程式位置不同時，zipExe要更新
	* 備份位置不同時，backupRoot、backupBackup、dbBackupRoot要更新
	* program位置不同時，programRoot、programName要更新
	* server位置不同時，serverRoot、serverName要更新
	* db移除或離線時，dbName要更新
	* 排程：每月最後一天的的17:00執行，錯過後會盡快執行

* `(尚未完成)`backup.bat：
	* 備份重要資料至隨身碟中
	* 7-Zip程式位置不同時，zipExe要更新
	* 備份位置不同時，backupRoot、backupBackup、dbBackupRoot要更新
	* 排程：每月最後一天的15:00執行，錯過後會盡快執行
	* `備份重要資料.xml`

* bcompareAddTime.bat：
	* 延長bcompare時間
	* 若版本更新，bcompare要更新
	* 本機排程：工作站解除鎖定時(輸入密碼登入時)背景執行
	* 公司排程：無
	* `延長bcompare時間.xml`

* checkBattery.bat：
	* 未充電且電量<=45時，提醒目前電量，請盡快充筆電
	* 充電中且電量>=95時，提醒目前電量，筆電即將充飽
	* 充電中且電量=100時，提醒筆電已充飽，請移除充電線
	* 本機排程：每天每10分鐘背景執行
	* 公司排程：平日09:00-19:00，每10分鐘背景執行
	* `提醒筆電充電狀態.xml`

* svnUpdate_com.bat`(公司用)`：
	* 更新SVN
	* SVN程式位置不同時，svnExe要更新
	* 要更新的資料夾位置不同時，updateRootFile要更新
	* 排程：平日09:00、14:30執行，錯過後會盡快執行

**不上傳至github：**
* msg.exe：
	* 訊息用視窗呈現
	* set msgExe=%~dp0%\msg.exe
	* 出現訊息後繼續執行："%msgExe%" ^*  "(訊息)"
	* 出現訊息後等使用者點確定後才繼續執行："%msgExe%" ^*  /w "(訊息)"