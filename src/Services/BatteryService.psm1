function Get-FssBatteryInfo {
    try {
        $bat = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
        if (-not $bat) { return [pscustomobject]@{ Presente=$false; Status='Não coletado'; Detalhe='Equipamento sem bateria detectada' } }
        [pscustomobject]@{ Presente=$true; CargaPercent=$bat.EstimatedChargeRemaining; AutonomiaMin=$bat.EstimatedRunTime; Status=$bat.BatteryStatus }
    } catch { [pscustomobject]@{ Presente=$false; Erro=$_.Exception.Message } }
}
Export-ModuleMember -Function *
