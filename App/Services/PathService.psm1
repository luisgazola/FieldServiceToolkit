function New-FssReportFolder {
    param([string]$RootPath,[string]$Chamado,[string]$Serial)
    $safe = (($Chamado + '-' + $Serial) -replace '[^A-Za-z0-9_-]','_')
    $dir = Join-Path $RootPath ("Reports\{0}\{1}\{2}\{3}" -f (Get-Date -Format yyyy),(Get-Date -Format MM),(Get-Date -Format dd),$safe)
    New-Item -Path $dir -ItemType Directory -Force | Out-Null
    return $dir
}
Export-ModuleMember -Function *
