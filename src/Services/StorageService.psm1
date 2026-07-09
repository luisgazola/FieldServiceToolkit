function Get-FssStorageInfo {
    try {
        $logical = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
            [pscustomobject]@{ Unidade=$_.DeviceID; TamanhoGB=[math]::Round($_.Size/1GB,2); LivreGB=[math]::Round($_.FreeSpace/1GB,2); LivrePercent=if($_.Size){[math]::Round(($_.FreeSpace/$_.Size)*100,2)}else{0} }
        }
        $physical = Get-PhysicalDisk -ErrorAction SilentlyContinue | ForEach-Object {
            [pscustomobject]@{ Nome=$_.FriendlyName; Tipo=$_.MediaType; TamanhoGB=[math]::Round($_.Size/1GB,2); Saude=$_.HealthStatus; OperationalStatus=($_.OperationalStatus -join ',') }
        }
        [pscustomobject]@{ Disks=$physical; Volumes=$logical }
    } catch { [pscustomobject]@{Erro=$_.Exception.Message} }
}
Export-ModuleMember -Function *
