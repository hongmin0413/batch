# bat 踩坑紀錄

- 換行必須是 CRLF；變成 LF 時 cmd 讀中文會錯亂。編輯後用 `file xxx.bat` 確認。
- `rem`、`echo` 行尾多空一格（見 AGENTS.md 規則 4）；用 Edit 工具改檔可能吃掉行尾空格，改完要檢查。
- SQL 不要放在參數傳入（括號會讓 `if/else if` 判斷式解析錯誤），改為呼叫前 `set mysqlSql=...`。
- 括號區塊內的 `rem` 註解不可有括號。
- 延遲變數展開開啟時，PowerShell 指令不可有 `^`（cmd 會吃掉）。
- 環境的 python 是 Windows Store 假檔，不能用；批次改檔用 node 或 Edit 工具。
