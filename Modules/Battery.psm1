function Get-FssBatteryInfo {
    try {
        $bat = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
        if(-not $bat){ return [pscustomobject]@{ Present=$false; Status='Não coletado'; Message='Bateria não detectada' } }
        $report = Join-Path $env:TEMP 'fss-battery-report.html'
        powercfg /batteryreport /output $report | Out-Null
        [pscustomobject]@{ Present=$true; Name=$bat.Name; EstimatedChargeRemaining=$bat.EstimatedChargeRemaining; BatteryStatus=$bat.BatteryStatus; ReportPath=$report }
    } catch { Write-FssLog "Battery falhou: $_" 'ERROR'; [pscustomobject]@{Erro=$_.Exception.Message} }
}
Export-ModuleMember -Function *
