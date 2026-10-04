# batch
* gitBatch/XXX.bat：
	* 參照gitBatch/README.md

* backup.bat：
	* 備份重要資料至硬碟中
	* 備份位置不同時，util.bat的mssqlBackupRoot、mysqlBackupRoot、tidbBackupRoot要更新
	* db容器變更時，檢查util.bat的mssqlBackupRootInDocker、mssqlInDocker、sqlcmdPath、mysqlInDocker、mysqlPath、mysqldumpPath是否要更新
	* file位置不同時，fileDisc、fileName要更新
	* db移除或離線時，mssqlInfo、mssqlDbName、mysqlInfo、mysqlDbName要更新
	* 確認config.ini的值是否正確
	* 排程：每月最後一天的15:00執行，錯過後會盡快執行
	* `備份重要資料.xml`

* backup_cloud.bat：
	* 備份雲端重要資料至硬碟中
	* 備份位置不同時，backupRoot要更新
	* file位置不同時，cloudFile、fileName要更新
	* 雲端名稱不同時，cloudName要更新
	* 先將雲端資料移動至C:\backupPhoneAndCloud\cloudFile中，再點擊此bat檔

* backup_com.bat`(公司用)`：
	* 備份重要資料至C槽
	* 7-Zip程式位置不同時，zipExe要更新
	* mssql程式位置不同時，sqlcmdPath要更新
	* 備份位置不同時，backupRoot、backupBackup、mssqlBackupRoot、dockerBackupRoot要更新
	* db容器變更時，postgresInDocker、psqlPath、pgDumpPath是否要更新
	* program位置不同時，programRoot、programName要更新
	* server位置不同時，serverRoot、serverName要更新
	* db移除或離線時，mssqlDbName、postgresDbName要更新
	* mssqlDbName若有多個db，請用"、"區隔
	* postgresDbName若有多個db，請用"、"區隔
	* 排程：每月最後一天的的18:00執行，錯過後會盡快執行
	* `備份重要資料_com.xml`

* backup_disk2PCloud.bat：
	* 備份+加密硬碟資料至pCloud中
	* 備份位置不同時，backupRoot要更新

* backup_phone.bat：
	* 備份手機重要資料至硬碟中
	* 備份位置不同時，backupRoot要更新
	* file位置不同時，phoneFile、fileName要更新
	* 先將手機資料移動至C:\backupPhoneAndCloud\phoneFile中，再點擊此bat檔

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
	* `提醒筆電充電狀態_com.xml`

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
	* `筆電開機後要先開啟的應用程式_com.xml`

* svnUpdate_com.bat`(公司用)`：
	* 更新本地svn、執行成功後會執行svnUpdateToGit_com.bat
	* 本地svn程式位置不同時，svnExe要更新
	* 要更新的資料夾位置不同時，updateRootFile要更新
	* 排程：平日09:00、14:30執行，錯過後會盡快執行
	* `更新SVN_com.xml`

* svnUpdateToGit_com.bat`(公司用)`：
	* 同步本地svn至git
	* 遠端git位置不同時，remoteGitDirPath要更新
	* 本地git位置不同時，localGitDirPath要更新

* swapMysqlDb.bat：
	* mysqlType：mysql、tidb
	* srcDb：要被切換成targetDb的資料庫名稱
	* targetDb：切換的資料庫名稱，存在時會先備份成targetBackupDb，不存在時不備份
	* targetBackupDb(targetDb不存在時不會用到)：原本targetDb的資料庫備份名稱，存在時會中止，請改名或移除
	* dropSrcDb：切換完後是否刪除srcDb，Y=刪除(搬移)、N=保留(複製)
	* 情況一：A->A_backup、A_new->A、~~A_new~~
		* mysqlType=tidb
		* srcDb=A_new
		* targetDb=A
		* targetBackupDb=A_backup
		* dropSrcDb=Y
	* 情況二：A->A、A_new
		* mysqlType=tidb
		* srcDb=A
		* targetDb=A_new
		* targetBackupDb=
		* dropSrcDb=N

* util.bat：
	* bat功能大集合
	* 7-Zip程式位置不同時，zipExe要更新
	* call util.bat "copyFile" "%destPath%" "%filePath%" "%fileName%"
	* call util.bat "zipFile" "%backupPath%" "%fileDisc%" "%fileName%"
	* call util.bat "backupMssql" "%mssqlInfo%" "%mssqlDbName%"
		* mssqlInfo型式：-S ${host},${port} -U ${user};${password}
		* mssqlDbName若有多個db，請用"、"區隔
	* call util.bat "backupMysql" "%mysqlInfo%" "%mysqlDbName%" "%mysqlType%"
		* mysqlInfo型式：-h ${host} -P ${port} -u ${user};${password}
		* mysqlDbName若有多個db，請用"、"區隔
		* mysqlType：mysql、tidb
	* set "mysqlSql=${SQL}"後，call util.bat "executeMysql" "%mysqlInfo%" "%mysqlOutFile%"
		* mysqlSql：要執行的SQL，要在呼叫前先設定(不放在參數，因為SQL有括號會讓判斷式解析錯誤)，SQL中不要有反引號
		* mssqlInfo型式：-S ${host},${port} -U ${user};${password}
		* mysqlOutFile：查詢結果的輸出檔，若沒有值("")就直接顯示在畫面上
	* call util.bat "restoreMysql" "%mysqlInfo%" "%mysqlDbName%" "%mysqlNewDbName%" "%mysqlType%"
		* mysqlInfo型式：-h ${host} -P ${port} -u ${user};${password}
		* mysqlDbName：要還原的備份檔名稱(${mysqlDbName}.sql)，備份檔要先用backupMysql備份好
		* mysqlNewDbName：還原後的db名稱，若已存在，會直接中止不還原，請先確認後手動刪除
		* mysqlType：mysql、tidb，決定備份檔的位置(mysqlBackupRoot、tidbBackupRoot)
	* call util.bat "checkIsHasDisk" "%diskDisc%" 

**不上傳至github：**
* msg.exe：
	* 訊息用視窗呈現
	* set msgExe=%~dp0%\msg.exe
	* 出現訊息後繼續執行："%msgExe%" ^*  "(訊息)"
	* 出現訊息後等使用者點確定後才繼續執行："%msgExe%" ^*  /w "(訊息)"