function Get-FssHardwareInfo {
    try {
        $cs = Get-CimInstance Win32_ComputerSystem
        $bios = Get-CimInstance Win32_BIOS
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        $ramBytes = [double]$cs.TotalPhysicalMemory
        [pscustomobject]@{
            Hostname=$env:COMPUTERNAME; Fabricante=$cs.Manufacturer; Modelo=$cs.Model; Serial=$bios.SerialNumber
            SistemaOperacional=$os.Caption; Versao=$os.Version; Build=$os.BuildNumber
            BIOS=$bios.SMBIOSBIOSVersion; CPU=$cpu.Name; Nucleos=$cpu.NumberOfCores; Threads=$cpu.NumberOfLogicalProcessors
            RAM_GB=[math]::Round($ramBytes/1GB,2); Uptime=((Get-Date)-$os.LastBootUpTime).ToString('dd\.hh\:mm')
        }
    } catch { Write-FssLog "Hardware falhou: $_" 'ERROR'; [pscustomobject]@{Erro=$_.Exception.Message} }
}
function Get-FssPerformanceInfo {
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $total = [double]$os.TotalVisibleMemorySize; $free = [double]$os.FreePhysicalMemory
        $memUsage = if($total -gt 0){ [math]::Round((($total-$free)/$total)*100,2) } else { 0 }
        $cpuSample = Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor | Where-Object Name -eq '_Total'
        $top = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 ProcessName,Id,CPU,WorkingSet
        [pscustomobject]@{ CPU_UsagePercent=[int]$cpuSample.PercentProcessorTime; Memory_UsagePercent=$memUsage; TopProcesses=$top }
    } catch { Write-FssLog "Performance falhou: $_" 'ERROR'; [pscustomobject]@{Erro=$_.Exception.Message} }
}
Export-ModuleMember -Function *
