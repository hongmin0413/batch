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

## 2026-10-21
- fetch remote git(alt+g) 從 alms 移到編輯器全域設定：Zed 全域 tasks.json、Cursor 全域 tasks.json，腳本放 %APPDATA%\Zed\taskScript\fetchRemoteGit.ps1(git 改用完整路徑 C:\Program Files\Git\cmd\git.exe 呼叫)；alms 的 .zed/tasks.json、.vscode/tasks.json 移除該 task，刪除 taskScript/fetchRemoteGit.ps1。其他非 personal 專案的 fetchRemoteGit.ps1 內容一樣(alms 版多了「建立本地沒有、遠端有的分支」那段)，所以共用 alms 版；D:\SVN\svnUpdateToGit_com.bat 也改呼叫全域腳本
- 全域 Zed 腳本(放 `%APPDATA%\Zed\taskScript\`，所有專案共用，不在 alms 裡；SourceGit 自訂動作與 Zed task 共用)：
  - `fetchRemoteGit.ps1`：fetch 全部遠端並建立本地沒有、遠端有的分支(Zed alt+g、SourceGit「同步遠端git至本地git」、svn bat 都用它；Cursor 全域 taskScript 有一份相同的)。
  - `compareCurrentFile.ps1`：Zed F3，目前檔案與 git 版本比較(未暫存：index vs 檔案；已暫存：HEAD vs index，index 那份唯讀；新檔案、已刪除也處理)，開在目前專案視窗。
  - `resolveMergeConflicts.ps1`：SourceGit「解決合併衝突」，把衝突檔拆成左＝對方(`:3:`)、右＝自己(去掉衝突標記只留 ours)用 Zed 比對，原檔先備份到備份區(`index.tsv` 記錄，保留 30 天)；專案已在 Zed 開著就用同一個視窗，否則用該專案開新視窗。
  - `restoreMergeConflicts.ps1`：SourceGit「還原合併衝突」，列出目前專案的備份，勾選後還原成有衝突標記的樣子(已編輯過會標示)；失敗才跳訊息。
  - `skipWorktree.ps1`：SourceGit 檔案右鍵「skip-worktree」，失敗時用簡短視窗說明原因(已是 skip-worktree、已暫存的新檔案、未追蹤、被 .gitignore 忽略)；`skipWorktreePick.ps1`：SourceGit「取消 skip-worktree」，列出已 skip-worktree 的檔案勾選取消，🔍 可與目前檔案比較。
- 用 alms 實測 resolve merge conflict：對 `.vscode/settings_example.jsonc`(stash pop 衝突，`stash@{0}`「為了測試resolve merge confilct」保留)左邊顯示對方 `v2.0.0`、右邊只留自己 `v3.0.0`，備份再還原 byte 相同、重複備份只留一份；測完用 `git reset --merge` 還原衝突(stash pop 衝突沒有 MERGE_HEAD，`merge --abort` 不能用，SourceGit 也不會出現黃色提示)，工作目錄回到只剩未追蹤的 `.zed/`。SourceGit 另加自訂動作「放棄合併」(直接執行 `git.exe reset --merge`，沒有腳本)。
- SourceGit 自訂動作與腳本對照：同步遠端git至本地git→fetchRemoteGit.ps1；解決合併衝突→resolveMergeConflicts.ps1；還原合併衝突→restoreMergeConflicts.ps1；放棄合併→git reset --merge；skip-worktree(檔案範圍)→skipWorktree.ps1；取消 skip-worktree→skipWorktreePick.ps1；svnUpdate_com、svnUpdateToGit_com.bat→`D:\SVN` 的同名 bat。F3 的 compareCurrentFile.ps1 只有 Zed 用，SourceGit 沒有對應動作。

## 2026-10-22
- 全域 resolveMergeConflicts.ps1 改版（%APPDATA%\Zed\taskScript）：(1) 比較只看有衝突的地方：左＝衝突處放對方內容、右＝衝突處只留我方內容，沒衝突處(含自動合併成功)左右相同；有標記時兩邊都從工作檔的標記取出，沒標記時左邊用 git merge-file --theirs 從 :1:/:2:/:3: 重算，缺我方或對方版本、二進位檔退回用 :3: 完整版本。(2) 開啟哪些：有任何衝突檔還有標記(第一次)就直接開全部並改寫成只留我方內容；之後(都沒標記、還沒 git add)跳對話框勾選(預設都不勾、有「全選／取消全選」，按「開啟」)。(3) 拿掉備份機制與 restoreMergeConflicts.ps1(已刪)：要回到有標記用 git checkout -m -- 檔案，放棄合併用 git reset --merge(用暫存 git 專案實測：已暫存、未暫存、自動合併的檔案都會回到合併前，合併前就有的無關修改保留)。SourceGit 的「還原合併衝突」自訂動作由使用者自行刪除；備份資料夾 %LOCALAPPDATA%\Zed\MergeConflictBackups 仍在，可刪。實測：用暫存 git 專案(衝突、delete/modify、自動合併)的 -DryRun，第一次與第二次左邊內容相同，對話框能正常顯示；對話框內「全選」按鈕的實際點擊沒有自動化測試。
- resolveMergeConflicts.ps1 的對話框調整：「全選」改成標題列第一欄的核取方塊(蓋在標題儲存格上的 CheckBox，全部勾了自動勾起來；踩坑：點它之前要 EndEdit 並把 CurrentCell 設 null，不然目前選取的第一列會被舊值蓋回去而沒勾到)，拿掉底下的全選按鈕；新增「狀態」欄(目前檔案與 git merge-file --ours 的結果比較，拿掉  後不同＝已編輯，已編輯用橘色字)。用暫存 git 專案，視窗截圖＋模擬滑鼠點擊實測：全選／取消全選、逐列勾滿後標題自動勾起、A 未編輯／B(多加一行)已編輯都正確。實測時有一次視窗沒在最前面，模擬的點擊點到 Zed 編輯器(只移動游標，沒有改檔)，之後改成先設視窗置頂並確認點擊位置是該視窗才點。
- 對話框「已編輯」改成紅色，選取那一列時也維持紅色(DataGridView 選取時字色會被 SelectionForeColor 蓋成黑色，要對那個儲存格另外設 Style.SelectionForeColor)；截圖實測選取已編輯列仍是紅字。
- 兩個勾選對話框(resolveMergeConflicts.ps1、skipWorktreePick.ps1)新增「備註」欄與編號提示：(1) 解決合併衝突：目前檔案與 git merge-file --theirs 的結果完全一樣(拿掉  後比)就標綠色「與對方相同」(左右已沒有差異)，狀態欄仍有已編輯／未編輯；(2) 取消 skip-worktree：目前檔案與 index 版本(git show :./檔案)完全一樣就標綠色「與index相同」，比較按鈕欄往右移一欄；(3) 上方提示改成 1. 2. 3. 三行(標籤高度 84)。暫存 git 專案截圖實測：A 改成對方內容＝已編輯＋與對方相同、B 多一行＝已編輯、C 未動＝未編輯；skip-worktree 的 same.txt 標與index相同、changed.txt 不標。截圖時視窗要先設置頂並多等幾秒，不然 MainWindowHandle 抓不到會截到別的畫面。

## 2026-10-23

- `%APPDATA%\Zed\taskScript\fetchRemoteGit.ps1`：修正 `fatal: refusing to fetch into branch ... checked out at ...`。分支被其他 worktree checkout 時不能用 `fetch 遠端 分支:分支` 更新，改為先 fetch，再用 `git -C <worktree路徑> merge --ff-only` 快轉（以 `git worktree list --porcelain` 取得分支對應路徑）。
- 從 alms 分支 dev-change-to-zed 的 worklog 搬來 SourceGit、Zed 全域腳本相關紀錄（fetchRemoteGit、compareCurrentFile、resolveMergeConflicts、restoreMergeConflicts、skipWorktree 等），依原日期放在 2026-10-21、2026-10-22，並從 alms 的 worklog 刪除（alms 尚未 commit）。
- 新增 compare config：	askScript\compareConfig.ps1（從 alms 搬來，只留 Zed，比較 config.ini 與 config_example.ini）、.zed\tasks.json 的 compare config task（alt+c 用 Zed 全域 keymap）。只做語法檢查，尚未在 Zed 內按 alt+c 實測。
- 新增記憶 zed-task-pitfalls.md（Zed task 的 command＋args 會被接成一串交給 pwsh -C）；alms worklog 的原句保留。
- `computerPowerUp.bat`：bcompare 區塊在 cloud 判斷之外增加 6 個 `local <--> ...` 比對（gitSetting、ideSetting-cursor、ideSetting-zed、powershellSetting、openIde-openCursor.bat、openIde-openZed.bat），預設以 `rem` 註解；Beyond Compare 的工作階段需存在同名項目才能開。
- 修正 	askScript\compareConfig.ps1：只有一組比較檔案時，@(@(a, b)) 會被 PowerShell 展開成一維，oreach 取到的是字串，$pair[0] 變成第一個字元，導致誤報「略過(檔案不存在)：c / o」。改成 @(,@(a, b))（前面加逗號）。踩坑：從 alms（3 組）搬到只有 1 組的專案時要注意；config.ini 有隱藏屬性但 Test-Path 找得到，不是原因。
