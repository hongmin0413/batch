# 工作日誌

## 2026-10-03

- 新增 `.agents` 目錄、`AGENTS.md`、`.agents/memory/worklog.md`
- `backup_cloud.bat` 處理 TODO：備份後刪除雲端來源資料夾內所有檔案，保留目錄（新增 `:cleanCloud`，使用 `del /s /f /q`）
- `backup_phone.bat`：備份圖集後，寫死刪除圖集下 15 個指定目錄內的檔案，保留目錄（`:deletePhoneFile`）
- `backup_phone.bat`：`:deletePhoneFile` 改為單一目錄參數，移除 for，每個目錄各一行 call，方便增減
- 測試 `backup_cloud.bat`、`backup_phone.bat` 的刪除功能（抽出 subroutine 以暫存 bat 測試）：cloud 放測試檔（含子目錄）刪除後目錄保留；phone 15 個指定目錄檔案已刪除，目錄保留，其他目錄不受影響
- `backup_phone.bat`：`:deletePhoneFile` 增加刪除指定目錄下的子資料夾（指定目錄本身保留），並以測試資料驗證
- `backup_cloud.bat`、`backup_phone.bat`：刪除改為 `rd /s /q` 後 `mkdir` 重建同名空目錄（一次清掉檔案與子資料夾、保留目錄），cloud 同樣清空帳號目錄下所有內容；已以測試資料驗證
