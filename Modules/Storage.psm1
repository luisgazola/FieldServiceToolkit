function Get-FssStorageInfo {
    try {
        $volumes = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
            $used = if($_.Size -gt 0){ [math]::Round((($_.Size-$_.FreeSpace)/$_.Size)*100,2) } else {0}
            [pscustomobject]@{ Drive=$_.DeviceID; SizeGB=[math]::Round($_.Size/1GB,2); FreeGB=[math]::Round($_.FreeSpace/1GB,2); UsedPercent=$used }
        }
        $physical = Get-PhysicalDisk -ErrorAction SilentlyContinue | Select-Object FriendlyName,MediaType,HealthStatus,OperationalStatus,Size
        $reliability = Get-PhysicalDisk -ErrorAction SilentlyContinue | Get-StorageReliabilityCounter -ErrorAction SilentlyContinue | Select-Object DeviceId,Temperature,PowerOnHours,PowerCycleCount,Wear
        [pscustomobject]@{ Volumes=$volumes; PhysicalDisks=$physical; Reliability=$reliability }
    } catch { Write-FssLog "Storage falhou: $_" 'ERROR'; [pscustomobject]@{Erro=$_.Exception.Message} }
}
Export-ModuleMember -Function *
