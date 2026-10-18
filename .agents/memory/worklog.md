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

## 2026-10-09

- `AGENTS.md`：新增規則 5，worklog 中重要的事要整理寫進 `.agents/memory/`，內容不重覆；已依此新增 `bat-pitfalls.md`（bat 踩坑）、`testing-rules.md`（測試守則）。
- `swapMysqlDb.bat`：情況一、情況二對調，預設啟用 A->A、A_new（srcDb=ALMS、targetDb=ALMS_dev_revise_setUpSpecialEntry、targetBackupDb 空、dropSrcDb=N），原情況一改為註解成情況二；`README.md` 同步對調。
- `swapMysqlDb.bat`：情況一、二改為執行時用 `choice` 選擇（也可帶第一個參數 1 或 2 直接指定），選單提示「若資料庫名稱錯誤，請先開啟修改」；兩組參數以結尾 1、2 區分並放在檔案上方；`README.md` 同步。用臨時名稱的暫存 bat 測試參數 3（被擋）、參數 1、2、選單輸入 2，皆正確，因 db 不存在而中止，未動任何資料；測完已刪暫存 bat。
- 在 docker 的 tidb 用 ALMS 複製出 testA、testB 實測 swapMysqlDb.bat：搬遷（情況二，testA 搬到 testB、舊 testB 備份成 testB_bk、刪除 testA）與複製（情況一，testB 複製成不存在的 testC、保留 testB）皆成功，資料表數量一致，ALMS 不受影響；測完已刪除 testA、testB、testB_bk、testC 與其備份檔，ALMS.sql 還原成測試前版本，暫存 bat 已清除。

## 2026-10-17

- 新增 worktree `batch-dev-zed`（分支 `zed`，從 `dev` 建立）用來試用 Zed 編輯器；新增 `.zed/settings.json`：關閉存檔時刪除行尾空格（AGENTS.md 規則 4 需要）、關閉存檔時自動補結尾換行與格式化、換行符號用 `detect`（維持 bat 的 CRLF）。
- 寫入 Zed 全域設定（`%APPDATA%\Zed\settings.json`、`keymap.json`，不在專案內）：比照 Cursor 的版面、字體、autosave、快捷鍵，並加入 Java（jdtls）設定與自動安裝擴充；原設定備份在暫存目錄。其他專案（alms）只讀取參考，未修改。
- 整理 `D:\githubWorkspace\01_開啟程式編輯器\`：刪除 agy 相關 bat（`*_agy.bat`、`openAntigravity.bat`）；其餘 bat 移到 `cursor\`，並在 `zed\` 新增 `openZed.bat` 與各專案 bat（含 alms，之後再切換）。
- `computerPowerUp.bat`：拿掉 Antigravity，改成 `isOpenZed=true`（最上方），Zed 區塊內各專案先全部註解；cursor 區塊目錄改指向 `cursor\`；比對區塊移除 antigravity 那行。
- Zed 全域設定調整：keymap 註解照使用者原本寫法、移除 git 相關按鍵（改用 SourceGit）、新增 `f4`（Beyond Compare 比較）與全域 `tasks.json`；設定檔不再提到 Cursor、移除 `base_keymap`；關閉 `git.inline_blame`。
- SourceGit（`D:\SourceGit`）：在 exe 同層建立 `data` 資料夾（portable 模式）並放入 `preference.json`，同時把 `UseSystemWindowFrame` 改為 `true`（改善最大化時蓋住自動隱藏工作列）；`%APPDATA%\SourceGit` 原檔保留，另備份一份在暫存目錄；已執行 `ie4uinit.exe -show` 重整圖示快取。
- Zed 全域設定：`minimap.show` 改為 `never`（關閉右側縮圖）。SourceGit：`UseSystemWindowFrame` 在 Windows 上會被程式改回 `false`，改為把 `data\preference.json` 的視窗改成非最大化（`LauncherWindowState` 0、`LauncherHeight` 790、`LauncherPositionY` 0），讓螢幕下緣留空隙以便叫出自動隱藏的工作列；`data\` portable 模式確認有效。
- Zed 的 `f4`（Beyond Compare 比較）沒反應，改為 task 呼叫 `%APPDATA%\Zed\compareFile.bat`（避免路徑空格問題），task 失敗時不自動隱藏。
- Zed 的 `compare file with` task：`reveal` 設為 `never`、`hide` 設為 `always`，讓 powershell 終端機執行後自動關閉；選比較檔案只能在 Beyond Compare 內操作（Zed task 沒有輸入檔案的功能）。
- Zed 的 `compare file with` task 改為直接用 `Start-Process` 開 Beyond Compare（寫在 `tasks.json`），不再用 `compareFile.bat`，已刪除該 bat；實測可用。
- `backup.bat`：D 槽增加備份 `SourceGit`（設定已放在其 `data` 目錄下，一併備份）。
- Zed 全域設定：關閉 git panel 按鈕；keymap 加回 `f3`（git diff）、`alt+h`（git history），註解照使用者原本寫法（git 圖形操作仍交給 SourceGit）。
- Zed keymap：移除 `alt+h`（git history 改用 SourceGit）。
- SourceGit：`data\preference.json` 的 `UseSideBySideDiff` 改為 `true`（diff 改左右並排）。
- Zed keymap：移除 `f3`（git diff 改用 SourceGit），只保留 `f4`（Beyond Compare）。SourceGit：外部比對工具改為無（`ExternalMergeToolType` 0，路徑與參數清空），因已改用並排 diff。
- SourceGit：試將 `IsSidebarCollapsedInLocalChanges` 改為 `true`（嘗試隱藏左邊欄，效果待使用者確認；找不到官方的整個左邊欄隱藏開關）。
- SourceGit：`UseFullTextDiff` 改為 `true`（diff 顯示完整檔案）。

## 2026-10-18

- Zed 全域設定：新增 `ensure_final_newline_on_save: true`；專案 `.zed\settings.json` 的同名設定（false）移除，避免蓋掉全域。
- SourceGit：`data\preference.json` 的 `Workspaces.Repositories` 補滿 9 個 `D:/githubWorkspace` 下的 repo（SourceGit 執行中改檔，關閉時可能被覆蓋，需先關閉再改或改完重開）。
- 踩坑：用 PowerShell 改 SourceGit 的 `preference.json` 時，先讀檔失敗導致寫入空檔；已用 `%APPDATA%\SourceGit\preference.json` 重建並套回先前調整（視窗非最大化、並排 diff、完整 diff、無外部比對工具、側欄收合）。改設定檔前要先備份，且讀取失敗不可寫檔。
- SourceGit：9 個 repo 應寫在 `RepositoryNodes`（開新分頁時可選），`Workspaces.Repositories` 只放平常開著的 alms、batch、batch-dev（先前誤寫成 9 個，已更正）。SourceGit 關閉時會用記憶體內容覆蓋 `preference.json`，改檔前要確認程式已關閉。
- `computerPowerUp.bat`、`computerPowerUp_com.bat`：增加 `isOpenSourceGit` 開關與開啟 SourceGit（路徑對應 backup：本機 `D:\SourceGit`、公司 `D:\Tools\BC\SourceGit`）。
- 複製 `D:\SourceGit` 為 `D:\SourceGit_com`（排除 `process.lock`，SourceGit 當時執行中），其 `data\preference.json` 的 `RepositoryNodes` 依 `svnUpdateToGit_com.bat` 寫入 12 個 repo（不寫 CurrentBranch），`Workspaces` 依序為國發會（`MOADoms_NDC`）、MOADoms、OASystem、EMSystem 設定檔。
- `computerPowerUp.bat`、`computerPowerUp_com.bat`：`isOpenSourceGit` 變數與開啟區塊都移到 Zed 之後（過程中用 Edit 工具改 bat 會吃掉行尾空格且檔案為 CRLF，改完用 PowerShell 補回行尾空格、移除重複區塊）。
- 把 `D:\githubWorkspace\01_開啟程式編輯器` 的 `cursor`、`zed` 複製到專案 `開啟程式編輯器\`（非隱藏），README 補上使用說明。
- 改為只保留 `openIde\` 目錄：`openCursor.bat`、`openZed.bat`、`openIde_example.bat`（兩個 call 先註解），移除先前複製的 `開啟程式編輯器`，README 精簡。
- 新增 `openIde\README.md`（仿 gitBatch 的格式：檔案結構說明、操作流程），根目錄 README 的 openIde 段改為參照它。
- `openIde_example.bat`：移除說明註解（說明已在 `openIde\README.md`），只留兩個被註解的 call。
- `openIde\README.md`：新專案步驟補上「刪除不用的 call」。
