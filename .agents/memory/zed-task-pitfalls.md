---
name: zed-task-pitfalls
description: Zed tasks.json 執行 pwsh 腳本的踩坑（command＋args 會被接成一串當程式碼執行）
metadata:
  type: reference
---

- Zed 會把 `command`＋`args` 用空白接成一串，交給 `pwsh -C` 當程式碼執行，args 裡的引號、括號會被外層吃掉。例如 `-Command "& (...) -Path 'x'"` 會 ParserError。
- 做法：腳本路徑直接寫在 `command`（如 `./taskScript/xxx.ps1`），不用 `pwsh -File` 多包一層（Zed 本來就用 pwsh，多包一層會多啟動一次 PowerShell，慢約 0.4 秒）；一定要用 `-File` 時，變數改用 `$env:變數` 傳。
- 不想顯示下方 terminal：task 加 `"reveal": "never"`，`"hide": "on_success"`（alms 用 `hide: always`）。

相關：[[zed-config-preferences]]
