function Get-FssHardwareInfo {
    try {
        $cs = Get-CimInstance Win32_ComputerSystem
        $bios = Get-CimInstance Win32_BIOS
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
        [pscustomobject]@{
            Fabricante=$cs.Manufacturer; Modelo=$cs.Model; Serial=$bios.SerialNumber
            Hostname=$env:COMPUTERNAME; SistemaOperacional=$os.Caption; Versao=$os.Version
            BIOS=$bios.SMBIOSBIOSVersion; CPU=$cpu.Name; Nucleos=$cpu.NumberOfCores
            RAM_GB=[math]::Round($cs.TotalPhysicalMemory/1GB,2)
        }
    } catch { Write-FssLog $_.Exception.Message 'ERROR'; [pscustomobject]@{Erro=$_.Exception.Message} }
}
function Get-FssPerformanceInfo {
    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $total = [double]$os.TotalVisibleMemorySize
        $free = [double]$os.FreePhysicalMemory
        $ramUse = if ($total -gt 0) { [math]::Round((($total-$free)/$total)*100,2) } else { 0 }
        $cpuLoad = (Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average
        $top = Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 ProcessName,Id,CPU,WorkingSet64
        [pscustomobject]@{ CpuUsoPercent=[math]::Round([double]$cpuLoad,2); RamUsoPercent=$ramUse; TopProcessos=$top }
    } catch { [pscustomobject]@{Erro=$_.Exception.Message} }
}
Export-ModuleMember -Function *
