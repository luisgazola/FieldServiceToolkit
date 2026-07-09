function New-FssDiagnosticModel {
    param($Inventory,$Hardware,$Storage,$Battery,$Network,$Drivers,$Performance,$Summary)
    [pscustomobject][ordered]@{
        DataHora=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        Inventory=$Inventory; Hardware=$Hardware; Storage=$Storage; Battery=$Battery
        Network=$Network; Drivers=$Drivers; Performance=$Performance; Summary=$Summary
    }
}
Export-ModuleMember -Function *
