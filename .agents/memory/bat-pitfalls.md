# bat 踩坑紀錄

- 換行必須是 CRLF；變成 LF 時 cmd 讀中文會錯亂。編輯後用 `file xxx.bat` 確認。實際執行的副本也要檢查（2026-11-03 backup_com.bat 的執行副本是 LF，雙擊直接閃退、連第一行 echo 都沒出現）。判斷方式：`tr -cd '\r' < 檔案 | wc -c`，0 就是 LF（`grep -c $'\r'` 在 Git Bash 會誤判）。
- `rem`、`echo` 行尾多空一格（見 AGENTS.md 規則 4）；用 Edit 工具改檔可能吃掉行尾空格，改完要檢查。
- SQL 不要放在參數傳入（括號會讓 `if/else if` 判斷式解析錯誤），改為呼叫前 `set mysqlSql=...`。
- 括號區塊內的 `rem` 註解不可有括號。
- 延遲變數展開開啟時，PowerShell 指令不可有 `^`（cmd 會吃掉）。
- 環境的 python 是 Windows Store 假檔，不能用；批次改檔用 node 或 Edit 工具。
- Windows 11 新版(24H2 起 wmic 變隨選功能，26H2 已沒有)不能用 `wmic`；取硬體資訊改用 `powershell -NoProfile -Command "Get-CimInstance ..."`（家用版也可用）。for /f 裡的指令避免 `|`（要寫 `^|`），改在 PowerShell 內用 `@(...)[0]` 取第一筆。2026-11-03 因 checkBattery.bat 電量永遠 0% 才發現。
- robocopy 一定要加 `/r:1 /w:1`：預設遇到被鎖住的檔案（如開著的 SourceGit 的 `process.lock`）會重試 100 萬次、每次等 30 秒，看起來像卡死，關掉程式也不一定會繼續。
