# 測試守則

- 測試 db 相關 bat 時，只用臨時 db（例如 ZZ_A、ZZ_NEW、ZZ_BK），不動 ALMS 相關 db；測完清除臨時 db、備份檔、臨時 bat。
- `config.ini` 是隱藏檔、不上傳 git，主目錄才有完整設定；測試時不可複製、刪除它（曾誤刪，後從主目錄複製回來）。
- 要測 bat 內的 subroutine，抽出成暫存 bat 測試，不直接跑會刪資料的正式 bat。
