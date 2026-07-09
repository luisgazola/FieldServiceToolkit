function Invoke-FssQuickDiagnostic {
    Write-FssHeader 'Diagnóstico rápido'
    Write-FssStatus 'Coletando hardware...' INFO; $hw = Get-FssHardwareInfo
    Write-FssStatus 'Coletando desempenho...' INFO; $perf = Get-FssPerformanceInfo
    Write-FssStatus 'Coletando disco/SMART...' INFO; $storage = Get-FssStorageInfo
    Write-FssStatus 'Coletando bateria...' INFO; $battery = Get-FssBatteryInfo
    Write-FssStatus 'Testando rede...' INFO; $network = Get-FssNetworkInfo
    Write-FssStatus 'Verificando drivers...' INFO; $drivers = Get-FssDriverIssues
    $diag = [pscustomobject]@{ Hardware=$hw; Performance=$perf; Storage=$storage; Battery=$battery; Network=$network; Drivers=$drivers; CollectedAt=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss') }
    $ref = Get-Content (Join-Path (Split-Path $PSScriptRoot -Parent) 'Config\Reference.json') -Raw | ConvertFrom-Json
    $actions = Get-Content (Join-Path (Split-Path $PSScriptRoot -Parent) 'Config\RecommendedActions.json') -Raw | ConvertFrom-Json
    $findings = Invoke-FssRulesEngine -Diagnostic $diag -Reference $ref
    $recs = Get-FssRecommendations -Findings $findings -Actions $actions
    $script:FssSession.Diagnostic = $diag
    $script:FssSession.Findings = $findings
    $script:FssSession.Recommendations = $recs
    Write-FssStatus 'Diagnóstico concluído.' OK
    return $diag
}
Export-ModuleMember -Function *
