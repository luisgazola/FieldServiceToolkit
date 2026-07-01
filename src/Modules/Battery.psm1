function Get-FstBatteryInfo {
    [CmdletBinding()]
    param()

    $battery = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue

    if (-not $battery) {
        return [pscustomobject]@{
            Present                  = $false
            Status                   = "Bateria não detectada"
            EstimatedChargeRemaining = "N/A"
            EstimatedRunTimeMinutes  = "N/A"
            Suggestion               = "Provável desktop ou bateria não exposta via WMI."
        }
    }

    $status = switch ($battery.BatteryStatus) {
        1 { "Em uso na bateria" }
        2 { "Conectado à energia elétrica" }
        3 { "Totalmente carregada" }
        4 { "Baixa" }
        5 { "Crítica" }
        default { "Status desconhecido" }
    }

    [pscustomobject]@{
        Present                  = $true
        Status                   = $status
        EstimatedChargeRemaining = "$($battery.EstimatedChargeRemaining)%"
        EstimatedRunTimeMinutes  = $battery.EstimatedRunTime
        Suggestion               = if ($battery.BatteryStatus -eq 5) {
            "Bateria crítica. Avaliar substituição."
        } elseif ($battery.EstimatedChargeRemaining -lt 40 -and $battery.BatteryStatus -eq 1) {
            "Carga baixa fora da tomada. Validar autonomia."
        } else {
            "Sem indício crítico pelo WMI básico."
        }
    }
}

Export-ModuleMember -Function Get-FstBatteryInfo