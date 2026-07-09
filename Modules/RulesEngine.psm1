function Get-FssStatusByThreshold { param([double]$Value,[double]$OkMax,[double]$WarningMax)
    if($null -eq $Value){ return 'Não coletado' }
    if($Value -le $OkMax){ return 'OK' }
    if($Value -le $WarningMax){ return 'Atenção' }
    return 'Crítico'
}
function Invoke-FssRulesEngine {
    param([object]$Diagnostic,[object]$Reference)
    $t = $Reference.Thresholds
    $findings = @()
    if($Diagnostic.Performance){
        $findings += [pscustomobject]@{Area='CPU';Valor=$Diagnostic.Performance.CPU_UsagePercent;Status=(Get-FssStatusByThreshold $Diagnostic.Performance.CPU_UsagePercent $t.CpuUsagePercent.OkMax $t.CpuUsagePercent.WarningMax)}
        $findings += [pscustomobject]@{Area='RAM';Valor=$Diagnostic.Performance.Memory_UsagePercent;Status=(Get-FssStatusByThreshold $Diagnostic.Performance.Memory_UsagePercent $t.MemoryUsagePercent.OkMax $t.MemoryUsagePercent.WarningMax)}
    }
    if($Diagnostic.Storage.Volumes){ foreach($v in $Diagnostic.Storage.Volumes){ $findings += [pscustomobject]@{Area="Disco $($v.Drive)";Valor=$v.UsedPercent;Status=(Get-FssStatusByThreshold $v.UsedPercent $t.DiskUsagePercent.OkMax $t.DiskUsagePercent.WarningMax)} } }
    if($Diagnostic.Drivers){ $findings += [pscustomobject]@{Area='Drivers';Valor=$Diagnostic.Drivers.Count;Status=(Get-FssStatusByThreshold $Diagnostic.Drivers.Count $t.DriverErrors.OkMax $t.DriverErrors.WarningMax)} }
    if($Diagnostic.Network){
        $findings += [pscustomobject]@{Area='Gateway';Valor=$Diagnostic.Network.GatewayLatencyMs;Status=(Get-FssStatusByThreshold $Diagnostic.Network.GatewayLatencyMs $t.GatewayLatencyMs.OkMax $t.GatewayLatencyMs.WarningMax)}
        $findings += [pscustomobject]@{Area='Internet';Valor=$Diagnostic.Network.InternetLatencyMs;Status=(Get-FssStatusByThreshold $Diagnostic.Network.InternetLatencyMs $t.InternetLatencyMs.OkMax $t.InternetLatencyMs.WarningMax)}
        $findings += [pscustomobject]@{Area='DNS';Valor=$Diagnostic.Network.DnsOk;Status=$(if($Diagnostic.Network.DnsOk){'OK'}else{'Crítico'})}
    }
    return $findings
}
Export-ModuleMember -Function *
