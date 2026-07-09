function Get-FssInventory {
    $hw = Get-FssHardwareInfo
    $storage = Get-FssStorageInfo
    $net = Get-FssNetworkInfo
    [pscustomobject]@{
        Hostname=$hw.Hostname; Fabricante=$hw.Fabricante; Modelo=$hw.Modelo; Serial=$hw.Serial
        SistemaOperacional=$hw.SistemaOperacional; BIOS=$hw.BIOS; CPU=$hw.CPU; RAM_GB=$hw.RAM_GB
        Discos=$storage.Disks; Rede=$net.AdaptadoresAtivos
    }
}
Export-ModuleMember -Function *
