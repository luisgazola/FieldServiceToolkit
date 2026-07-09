function Invoke-FssDiagnosticController {
    Write-FssHeader 'Diagnóstico rápido'
    Write-FssStatus 'Coletando inventário...' INFO
    $inventory = Get-FssInventory
    Write-FssStatus 'Coletando hardware...' INFO
    $hardware = Get-FssHardwareInfo
    Write-FssStatus 'Coletando disco/SMART...' INFO
    $storage = Get-FssStorageInfo
    Write-FssStatus 'Coletando bateria...' INFO
    $battery = Get-FssBatteryInfo
    Write-FssStatus 'Testando rede...' INFO
    $network = Get-FssNetworkInfo
    Write-FssStatus 'Verificando drivers...' INFO
    $drivers = @(Get-FssDriverIssues)
    Write-FssStatus 'Coletando desempenho...' INFO
    $performance = Get-FssPerformanceInfo
    $diag = New-FssDiagnosticModel -Inventory $inventory -Hardware $hardware -Storage $storage -Battery $battery -Network $network -Drivers $drivers -Performance $performance -Summary @()
    $diag.Summary = Invoke-FssRulesEngine -Diagnostic $diag
    $global:FssState.Inventory = $inventory
    $global:FssState.Diagnostic = $diag
    $global:FssState.Recommendations = @(Get-FssRecommendations -Diagnostic $diag -Atendimento $global:FssState.Atendimento)
    Write-FssStatus 'Diagnóstico concluído.' OK
    $diag.Summary | Format-Table -AutoSize
    return $diag
}
Export-ModuleMember -Function *
