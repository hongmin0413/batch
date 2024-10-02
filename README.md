# batch
* gitBatch\gitConfig.bat：
	* 調整git config的程式
	* 確認config.ini的值是否正確

* gitBatch\init.bat：
	* 初始化git時點擊的程式
	* 確認config.ini的值是否正確

* gitBatch\update.bat：
	* 執行push or 執行pull or 看status時實際執行的程式
	* 確認config.ini的值是否正確

* backup.bat：
	* 備份重要資料至C槽、D槽、隨身碟中
	* 7-Zip程式位置不同時，zipExe要更新
	* 備份位置不同時，backupRoot、otherBackupRoot1、otherBackupRoot2、otherBackupRoot3、backupBackup、sqlServerBackupRoot、mySqlBackupRoot要更新
	* file位置不同時，fileDisc、fileName要更新
	* db移除或離線時，sqlServerInfo、sqlServerDbName、mySqlInfo、mySqlDbName要更新
	* 確認config.ini的值是否正確
	* 排程：每月最後一天的15:00執行，錯過後會盡快執行
	* `備份重要資料.xml`

* backup_cloud.bat：
	* 備份雲端重要資料至隨身碟中
	* 備份位置不同時，backupRoot要更新
	* file位置不同時，cloudFile、fileName要更新
	* 雲端名稱不同時，cloudName要更新
	* 先將雲端資料移動至cloudFile中，再點擊此bat檔

* backup_com.bat`(公司用)`：
	* 備份program、server、DB
	* 7-Zip程式位置不同時，zipExe要更新
	* 備份位置不同時，backupRoot、backupBackup、dbBackupRoot要更新
	* program位置不同時，programRoot、programName要更新
	* server位置不同時，serverRoot、serverName要更新
	* db移除或離線時，dbName要更新
	* 排程：每月最後一天的的18:00執行，錯過後會盡快執行

* backup_phone.bat：
	* 備份手機重要資料至隨身碟中
	* 備份位置不同時，backupRoot要更新
	* file位置不同時，phoneFile、fileName要更新
	* 先將手機資料移動至phoneFile中，再點擊此bat檔

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
	
* computerPowerUp.bat：
	* 筆電開機後要先開啟的應用程式
	* 應用程式位置不同時，相關exe要更新
	* 應用程式預設開啟的專案不同時，相關專案名稱要更新
	* 排程：登入時(筆電剛開機登入時)延後1分鐘背景執行
	* `筆電開機後要先開啟的應用程式.xml`

* computerPowerUp_com.bat`(公司用)`：
	* 筆電開機後要先開啟的應用程式
	* 應用程式位置不同時，相關exe要更新
	* 應用程式預設開啟的專案不同時，相關專案名稱要更新
	* 排程：登入時(筆電剛開機登入時)延後1分鐘背景執行

* svnUpdate_com.bat`(公司用)`：
	* 更新SVN
	* SVN程式位置不同時，svnExe要更新
	* 要更新的資料夾位置不同時，updateRootFile要更新
	* 排程：平日09:00、14:30執行，錯過後會盡快執行
	
* util.bat：
	* bat功能大集合
	* call util.bat "moveFile" "%destPath%" "%filePath%" "%fileName%"
	* call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"
	* call util.bat "backupSqlServer" "%sqlServerInfo%" "%sqlServerDbName%"
		* sqlServerInfo型式：-S ${host} -port ${port} -U ${user} -P ${password}
		*sqlServerDbName若有多個db，請用"、"區隔
	* call util.bat "backupMySql" "%mySqlInfo%" "%mySqlDbName%"
		* mySqlInfo型式：host=${host} port=${port} user=${user}  password=${password}
		*mySqlDbName若有多個db，請用"、"區隔
	* call util.bat "checkIsHasUsb" "%usbDisc%" 

**不上傳至github：**
* msg.exe：
	* 訊息用視窗呈現
	* set msgExe=%~dp0%\msg.exe
	* 出現訊息後繼續執行："%msgExe%" ^*  "(訊息)"
	* 出現訊息後等使用者點確定後才繼續執行："%msgExe%" ^*  /w "(訊息)"