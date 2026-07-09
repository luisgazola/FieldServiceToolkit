function Get-FssDriverIssues {
    try {
        Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 } | Select-Object Name,DeviceID,ConfigManagerErrorCode,Status
    } catch { @([pscustomobject]@{Erro=$_.Exception.Message}) }
}
Export-ModuleMember -Function *
