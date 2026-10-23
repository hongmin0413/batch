[void](chcp 65001)

# 2026.10.23 用Zed開啟「設定檔」與「範例檔」的比較(左=設定檔、右=範例檔)，檢查範例檔有哪些新設定還沒補到自己的設定檔

$projectRoot = (Get-Location).path
# 要比較的檔案(設定檔, 範例檔)，其中一個不存在的就略過
# 只有一組時，要在前面加逗號，不然陣列會被展開成一維，變成每個元素被當成一組
$comparePairs = @(
	,@("config.ini", "config_example.ini")
)
$existPairs = @()
foreach($pair in $comparePairs) {
	$left = Join-Path $projectRoot $pair[0]
	$right = Join-Path $projectRoot $pair[1]
	if((Test-Path $left) -and (Test-Path $right)) {
		$existPairs += ,@($left, $right)
	}else {
		echo "略過(檔案不存在)：$($pair[0]) / $($pair[1])"
	}
}
if($existPairs.Count -eq 0) {
	echo "沒有可以比較的檔案"
	pause
	exit 1
}

# 檔案路徑加雙引號，避免路徑有空白時被拆開
$quote = [char]34

# Zed的--diff可以重複，一次帶多組檔案，都會開在同一個視窗；-a：加進目前使用中的視窗(從Zed的task執行時就是這個視窗)
$zed = Join-Path $env:LOCALAPPDATA "Programs\Zed\bin\zed.exe"
$zedArgs = @("-a")
foreach($pair in $existPairs) {
	$zedArgs += "--diff"
	$zedArgs += ($quote + $pair[0] + $quote)
	$zedArgs += ($quote + $pair[1] + $quote)
}
# zed.exe是console程式，用.NET啟動並隱藏視窗，避免閃一下黑色視窗(也比Start-Process快)
$zedInfo = New-Object System.Diagnostics.ProcessStartInfo
$zedInfo.FileName = $zed
$zedInfo.Arguments = ($zedArgs -join " ")
# UseShellExecute=true加Hidden：完全脫離目前的終端機(不然Zed冷啟動時終端機會一直不結束)，而且不會閃黑視窗
$zedInfo.UseShellExecute = $true
$zedInfo.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
[void][System.Diagnostics.Process]::Start($zedInfo)
