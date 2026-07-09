function Invoke-FssMainController {
    do {
        Show-FssMenu
        $op = Read-FssOption
        try {
            switch ($op) {
                '1' { Invoke-FssAtendimentoController | Out-Null; Pause-Fss }
                '2' { Invoke-FssDiagnosticController | Out-Null; Pause-Fss }
                '3' { Invoke-FssTroubleshootingController | Out-Null; Pause-Fss }
                '4' { Write-FssHeader 'Inventário de hardware'; $global:FssState.Inventory = Get-FssInventory; $global:FssState.Inventory | Format-List; Pause-Fss }
                '5' { Write-FssHeader 'Rede'; Get-FssNetworkInfo | Format-List; Pause-Fss }
                '6' { Write-FssHeader 'Disco/SMART'; Get-FssStorageInfo | Format-List; Pause-Fss }
                '7' { Write-FssHeader 'Bateria'; Get-FssBatteryInfo | Format-List; Pause-Fss }
                '8' { Show-FssPowerMenu; Pause-Fss }
                '9' { Write-FssHeader 'Drivers'; Get-FssDriverIssues | Format-List; Pause-Fss }
                '10' { Invoke-FssChecklist | Out-Null; Pause-Fss }
                '11' { Show-FssDashboard; Pause-Fss }
                '12' { New-FssReport | Out-Null; Pause-Fss }
                '0' { Write-FssStatus 'Encerrando...' INFO }
                default { Write-FssStatus 'Opção inválida.' WARN; Pause-Fss }
            }
        } catch {
            Write-FssLog $_.Exception.Message 'ERROR'
            Write-FssStatus "Erro: $($_.Exception.Message)" CRIT
            Pause-Fss
        }
    } while ($op -ne '0')
}
Export-ModuleMember -Function *
