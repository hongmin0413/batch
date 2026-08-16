# Git 自動化腳本與狀況說明

## 檔案結構說明

*   **`config.ini` (隱藏)**：存取 `username` 及 `token`
*   **`gitConfig.bat`**：調整 `git config` 的程式
*   **`init.bat`**：初始化時點擊的程式
*   **`upd_XXX.bat`**：執行 `push`、執行 `pull` 或看 `status` 時點擊的程式
*   **`update.bat` (隱藏)**：執行 `push`、執行 `pull` 或看 `status` 時實際執行的程式

---

## 操作流程

### 1. 調整 Git Config 時
*   確認 `config.ini` 中的 `username` 及 `useremail` 是否正確。
*   點擊 `gitConfig.bat`。

### 2. 有新專案時
*   確認遠端 repository 已建立。
*   確認 `config.ini` 中的 `username` 及 `token` 是否正確。
*   點擊 `init.bat`。

### 3. 執行 Push 或 Pull 時
*   確認 `config.ini` 中的 `username` 及 `token` 是否正確。
*   確認 `upd_XXX.bat` 中的 `dirName` 及 `gitName` 是否正確。
*   點擊 `upd_XXX.bat`。

### 4. 看 Status 時
*   確認 `upd_XXX.bat` 中的 `dirName` 是否正確。
*   點擊 `upd_XXX.bat`。

---

## 狀況對照表

| 編號 | 情境與操作 | 執行結果與提示 |
| :---: | :--- | :--- |
| **1** | 都有修改，無 conflict，用 **push** | `commit` 成功 > `push` 失敗 > `pull` 成功 > `push` 成功 |
| **2** | 都有修改，無 conflict，用 **pull** | `pull` 成功 |
| **3** | 都有修改，有 conflict，用 **push** | `commit` 成功 > `push` 失敗 > `pull` 成功，但提示要解決 conflict 再繼續執行 push |
| **4** | 都有修改，有 conflict，用 **pull** | `pull` 成功，但提示要解決 conflict 並 push |
| **5** | 解決 conflict 後，又都有修改，無 conflict，用 **push** | `commit` 成功 > `push` 失敗 > `pull` 成功 > `push` 成功 |
| **6** | 解決 conflict 後，又都有修改，無 conflict，用 **pull** | `pull` 失敗，提示尚有未合併的檔案 (UU)，請先執行 push |
| **7** | 解決 conflict 後，又都有修改，有 conflict，用 **push** | `commit` 成功 > `push` 失敗 > `pull` 成功，但提示要解決 conflict 再繼續執行 push |
| **8** | 解決 conflict 後，又都有修改，有 conflict，用 **pull** | `pull` 失敗，提示尚有未合併的檔案 (UU)，請先執行 push |