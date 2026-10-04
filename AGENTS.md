# AGENTS.md

## 規則

1. **工作日誌**：每次做了什麼工作，都要記錄在 `.agents/memory/worklog.md`。
   - 標題為「工作日誌」。
   - 內容由上到下為舊到新。
   - 同一天的工作寫在一起，底下用列點呈現。
2. **機密資訊**：所有 md 檔（含 `AGENTS.md`、`.agents/memory/`）不可寫入機密資訊（密碼、token、金鑰等）。
3. **新 session 啟動**：每次開新 session 時，自動下指令 `/caveman 用中文回覆我`，目的是使用 caveman 這個 skill 並用中文回覆。
4. **bat 註解與訊息**：寫在 bat 的註解（`rem`）、訊息（`echo`），不管有沒有中文，行尾都要多空一格，因為 bat 的中文解讀有時候有問題；註解不要用 `----------` 這類裝飾線。

## 記憶目錄

- `.agents/memory/`：放各式各樣的記憶。
- `.agents/memory/worklog.md`：必備，工作日誌。
