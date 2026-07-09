function New-FssSummaryItem { param($Categoria,$Status,$Detalhe) [pscustomobject]@{Categoria=$Categoria; Status=$Status; Detalhe=$Detalhe} }
function Invoke-FssRulesEngine {
    param($Diagnostic)
    $items = @()
    $perf = $Diagnostic.Performance
    if ($perf.CpuUsoPercent -ge 90) { $items += New-FssSummaryItem 'CPU' 'Crítico' "Uso em $($perf.CpuUsoPercent)%" }
    elseif ($perf.CpuUsoPercent -ge 75) { $items += New-FssSummaryItem 'CPU' 'Atenção' "Uso em $($perf.CpuUsoPercent)%" }
    else { $items += New-FssSummaryItem 'CPU' 'OK' "Uso em $($perf.CpuUsoPercent)%" }
    if ($perf.RamUsoPercent -ge 90) { $items += New-FssSummaryItem 'RAM' 'Crítico' "Uso em $($perf.RamUsoPercent)%" }
    elseif ($perf.RamUsoPercent -ge 75) { $items += New-FssSummaryItem 'RAM' 'Atenção' "Uso em $($perf.RamUsoPercent)%" }
    else { $items += New-FssSummaryItem 'RAM' 'OK' "Uso em $($perf.RamUsoPercent)%" }
    $driversCount = @($Diagnostic.Drivers).Count
    if ($driversCount -gt 0) { $items += New-FssSummaryItem 'Drivers' 'Atenção' "$driversCount dispositivo(s) com erro" } else { $items += New-FssSummaryItem 'Drivers' 'OK' 'Sem erro detectado' }
    $net = $Diagnostic.Network
    if ($net.PingGateway -and $net.PingInternet -and $net.DNS) { $items += New-FssSummaryItem 'Rede' 'OK' 'Gateway, internet e DNS responderam' } else { $items += New-FssSummaryItem 'Rede' 'Atenção' 'Falha em gateway, internet ou DNS' }
    $storageAlert = $false
    foreach ($d in @($Diagnostic.Storage.Disks)) { if ($d.Saude -and $d.Saude -ne 'Healthy') { $storageAlert = $true } }
    if ($storageAlert) { $items += New-FssSummaryItem 'Disco/SMART' 'Crítico' 'Saúde do disco diferente de Healthy' } else { $items += New-FssSummaryItem 'Disco/SMART' 'OK' 'Sem alerta físico detectado' }
    return $items
}
Export-ModuleMember -Function *
