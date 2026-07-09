function Initialize-FssLogFolder {
    $root = Split-Path $PSScriptRoot -Parent
    $logDir = Join-Path $root ("Logs\{0}\{1}" -f (Get-Date -Format yyyy),(Get-Date -Format MM))
    New-Item -Path $logDir -ItemType Directory -Force | Out-Null
    return Join-Path $logDir ("{0}.log" -f (Get-Date -Format yyyy-MM-dd))
}
function Write-FssLog { param([string]$Message,[string]$Level='INFO')
    $file = Initialize-FssLogFolder
    "[{0}] [{1}] {2}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'),$Level,$Message | Add-Content -Path $file -Encoding UTF8
}
Export-ModuleMember -Function *
