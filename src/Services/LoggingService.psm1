function Initialize-FssLogFolder {
    param([string]$RootPath)
    $dir = Join-Path $RootPath ("Logs\{0}\{1}" -f (Get-Date -Format yyyy),(Get-Date -Format MM))
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
    $global:FssLogFile = Join-Path $dir ("{0}.log" -f (Get-Date -Format 'yyyy-MM-dd'))
    return $global:FssLogFile
}
function Write-FssLog {
    param([string]$Message,[string]$Level='INFO')
    if (-not $global:FssLogFile) { return }
    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'),$Level,$Message
    Add-Content -Path $global:FssLogFile -Value $line -Encoding UTF8
}
Export-ModuleMember -Function *
