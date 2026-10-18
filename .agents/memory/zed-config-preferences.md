---
name: zed-config-preferences
description: 使用者對 Zed 設定檔的偏好
metadata:
  type: feedback
---

- Zed 設定檔（settings.json、keymap.json）不要提到 Cursor，沒有必要的設定就用 Zed 預設或不寫。
- keymap 的註解要照使用者原本在 Cursor keybindings.json 寫的文字，不要自己改寫。
- 不要改其他專案（如 alms）的設定，只能讀取參考；全域設定檔位於 `%APPDATA%\Zed\`。
- git 的圖形操作（graph、cherry-pick、merge）交給外部工具（SourceGit），Zed keymap 不放 git 相關按鍵。
