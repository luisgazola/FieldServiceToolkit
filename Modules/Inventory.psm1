function Get-FssInventory {
    $hw = Get-FssHardwareInfo
    $st = Get-FssStorageInfo
    $net = Get-FssNetworkInfo
    $drivers = Get-FssDriverIssues
    [pscustomobject]@{ Hardware=$hw; Storage=$st; Network=$net; DriverIssues=$drivers.Count; CollectedAt=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss') }
}
Export-ModuleMember -Function *
