function Get-FssRecommendations {
    param([object[]]$Findings,[object]$Actions)
    $rec = New-Object System.Collections.Generic.List[string]
    foreach($f in $Findings){
        if($f.Status -in @('Atenção','Crítico')){
            switch -Wildcard ($f.Area) {
                'RAM' { $rec.Add($Actions.HighMemory) }
                'CPU' { $rec.Add($Actions.HighCpu) }
                'Disco*' { $rec.Add($Actions.DiskFull) }
                'Drivers' { $rec.Add($Actions.DriverError) }
                'Gateway' { $rec.Add($Actions.NetworkGateway) }
                'DNS' { $rec.Add($Actions.NetworkDns) }
            }
        }
    }
    return $rec | Select-Object -Unique
}
Export-ModuleMember -Function *
