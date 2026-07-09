function Get-FssDriverIssues {
    try {
        $items = Get-CimInstance Win32_PnPEntity | Where-Object { $_.ConfigManagerErrorCode -ne 0 } | Select-Object Name,PNPClass,DeviceID,ConfigManagerErrorCode
        [pscustomobject]@{ Count=($items | Measure-Object).Count; Items=$items }
    } catch { Write-FssLog "Drivers falhou: $_" 'ERROR'; [pscustomobject]@{Erro=$_.Exception.Message} }
}
Export-ModuleMember -Function *
