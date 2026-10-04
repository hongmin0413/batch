# 工作日誌

## 2026-10-03

- 新增 `.agents` 目錄、`AGENTS.md`、`.agents/memory/worklog.md`
- `backup_cloud.bat` 處理 TODO：備份後刪除雲端來源資料夾內所有檔案，保留目錄（新增 `:cleanCloud`，使用 `del /s /f /q`）
- `backup_phone.bat`：備份圖集後，寫死刪除圖集下 15 個指定目錄內的檔案，保留目錄（`:deletePhoneFile`）
- `backup_phone.bat`：`:deletePhoneFile` 改為單一目錄參數，移除 for，每個目錄各一行 call，方便增減
- 測試 `backup_cloud.bat`、`backup_phone.bat` 的刪除功能（抽出 subroutine 以暫存 bat 測試）：cloud 放測試檔（含子目錄）刪除後目錄保留；phone 15 個指定目錄檔案已刪除，目錄保留，其他目錄不受影響
- `backup_phone.bat`：`:deletePhoneFile` 增加刪除指定目錄下的子資料夾（指定目錄本身保留），並以測試資料驗證
- `backup_cloud.bat`、`backup_phone.bat`：刪除改為 `rd /s /q` 後 `mkdir` 重建同名空目錄（一次清掉檔案與子資料夾、保留目錄），cloud 同樣清空帳號目錄下所有內容；已以測試資料驗證
- `util.bat`：新增 action `executeMysql`（在 docker 的 mysql 容器執行 mysql、tidb 的 SQL，可指定輸出檔）、`restoreMysql`（把備份檔還原成不同名稱的 db，還原前先把備份檔內的 CREATE DATABASE、USE、帶 db 名稱的檢視資料表改成新名稱）。
- 新增 `swapTidbDb.bat`：切換 tidb 的 db（targetDb 備份成 oldDb，srcDb 變成 targetDb），先備份再還原，檢查資料表數量一致才刪除舊 db，設定變數在檔案上方；尚未執行。
- 測試 `swapTidbDb.bat`：用臨時 db（ZZSWAP_SRC、ZZSWAP_TARGET、ZZSWAP_OLD，不動 ALMS 相關 db）在 docker 的 tidb 完整跑過一次，結果正確（舊資料到 OLD、新資料到 TARGET、檢視重新指向新 db、中文資料正常、來源 db 刪除），測完已清除臨時 db、備份檔、臨時 bat。
- 測試中修正：`util.bat` 的 `executeMysql` 不再用參數傳 SQL（SQL 有括號放在參數會讓 `if/else if` 判斷式解析錯誤），改為呼叫前設定 `mysqlSql`；`restoreMysql` 的 PowerShell 指令不可有 `^`（延遲變數展開開啟時 cmd 會吃掉）；`rem` 註解在括號區塊內不可有括號。
- `README.md`：`swapTidbDb.bat` 的說明改放在 `svnUpdateToGit_com.bat` 之後、`util.bat` 之前，依檔名字母順序排列。
- `README.md`：`util.bat` 的說明依 if-else 的順序，在 `backupMysql` 之後、`checkIsHasDisk` 之前，補上 `executeMysql`、`restoreMysql` 的用法與參數。
- `README.md`：`util.bat` 說明中過期的 action 名稱 `moveFile` 更正為 `copyFile`。
- `util.bat` 的 `restoreMysql`：還原後的 db 已存在時直接中止（回傳 errorlevel 1），不再還原；用臨時 db 測試通過（不存在可還原、已存在被擋且資料不變、備份檔不存在被擋），測完已清除。`README.md` 同步更新說明。

## 2026-10-04

- `swapTidbDb.bat` 改名為 `swapMysqlDb.bat`：新增上方參數 `mysqlType`（mysql、tidb），連線資訊與備份路徑依 `mysqlType` 決定；上方註解精簡，參數說明移到 `README.md`。
- `README.md`：`swapMysqlDb.bat` 各參數分別列點說明，並補上「ALMS 切換成 ALMS_B」「再切回 ALMS_A」兩種情況的參數範例。
- `README.md`：補完 `util.bat` 的 `restoreMysql` 各參數說明（mysqlInfo、mysqlDbName、mysqlNewDbName、mysqlType）。
- `README.md`：`swapMysqlDb.bat` 兩種情況的範例 db 名稱改用 A、B、B_old。
- `README.md`：`swapMysqlDb.bat` 情況一標題最後的 B 加上刪除線（`~~B~~`），表示 dropSrcDb=Y 後 B 已刪除。
- `swapMysqlDb.bat`：參數 `oldDb` 依 README 改名為 `targetBackupDb`（含程式內所有用到的地方與訊息）；`README.md` 情況二的參數對應情況一改為 srcDb=A_backup、targetBackupDb=A_new。
- `swapMysqlDb.bat`：`targetBackupDb` 預設值改為 `A_backup`。
- `swapMysqlDb.bat`：targetDb 不存在時，不備份、不刪除，直接把 srcDb 還原成 targetDb（可把 A 一分為二）；targetDb 存在時流程不變。`README.md` 情況二改為 A->A、A_new（srcDb=A、targetDb=A_new、dropSrcDb=N）並補上 targetDb 的說明。
- 測試 `swapMysqlDb.bat`（暫時複製主目錄的 config.ini，用臨時 db ZZ_A、ZZ_NEW、ZZ_BK 與臨時 bat，不動 ALMS 相關 db）：tidb 一分為二、tidb 切換（targetDb 存在）、targetBackupDb 已存在被擋、mysql 一分為二，結果皆正確（資料、中文、檢視重新指向新 db）；測完已清除臨時 db、備份檔、臨時 bat、config.ini。
- 發現 `swapMysqlDb.bat` 變成 LF 換行（其他 bat 為 CRLF，cmd 讀中文會錯亂），已轉回 CRLF。
- `AGENTS.md`：新增規則 4，bat 的中文註解行尾要多空一格、不用 `----------` 裝飾線。
- `swapMysqlDb.bat`、`util.bat`（本次新增的註解）：依規則 4 調整，行尾補一個空格、移除裝飾線；`README.md` 的 `swapMysqlDb.bat` 說明經確認無誤。
- `swapMysqlDb.bat`：targetDb 存在但 targetBackupDb 空白時，直接中止並提示不可空白；targetDb 不存在時 targetBackupDb 可留空。用臨時 db（ZZ_A、ZZ_NEW）在 docker 的 tidb 測試：targetDb 不存在且 targetBackupDb 空白可一分為二、targetDb 存在且 targetBackupDb 空白被擋且資料不變；測完已清除臨時 db、備份檔、臨時 bat、config.ini。
- `AGENTS.md`：規則 4 擴充為 bat 的中文註解（`rem`）與中文訊息（`echo`）行尾都要多空一格；`swapMysqlDb.bat` 的中文 echo、`util.bat` 本次新增的中文 echo 已補上行尾空格。
- `swapMysqlDb.bat`：「即將切換」的說明從最上方移到存在檢查之後，依實際情況顯示（targetDb 存在：備份與切換兩步；不存在：只顯示 srcDb -> targetDb），避免 targetBackupDb 空白時出現 `A -> ` 的空白呈現。用臨時 db（ZZ_A、ZZ_NEW、ZZ_BK）在 docker 的 tidb 測試兩種情況皆正確，測完已清除臨時 db、備份檔、臨時 bat、config.ini。
- `AGENTS.md`：規則 4 改為 bat 的 `rem`、`echo` 不管有沒有中文，行尾都要多空一格；`swapMysqlDb.bat` 全部 `rem`、`echo` 已補上行尾空格（情況二下方的 `rem` 範例除外）。
- `swapMysqlDb.bat`：移除「確定要切換請輸入YES」的確認（執行時本來就會先備份），並拿掉多的一個空行。
- `swapMysqlDb.bat`：資料表數量的顯示與訊息、註解都拿掉（保留數量比對當作還原成功的檢查），比對不一致時改顯示「還原【xxx】失敗，【yyy】沒有被刪除」；補上被 Edit 吃掉的 `echo` 行尾空格。用臨時 db 在 docker 的 tidb 測試一分為二、切換、來源 db 不存在皆正確，測完已清除臨時 db、備份檔、臨時 bat、config.ini。
- 測試時誤刪 `batch-dev` 的 `config.ini`（隱藏檔，不上傳 git，原本只在主目錄有完整設定），已從主目錄複製回來（雜湊值一致）；之後測試不再複製、刪除 `config.ini`。
- `swapMysqlDb.bat`：`[1/4]` 顯示備份的資料庫，兩個用「、」區隔（例如 `[1/4] 備份 A、B`）；用臨時 db 在 docker 的 tidb 測試一分為二（顯示 ZZ_A）、切換（顯示 ZZ_A、ZZ_NEW）皆正確，測完已清除臨時 db、備份檔、臨時 bat（`config.ini` 保留不動）。
