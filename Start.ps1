<#
.SYNOPSIS
    FieldServiceSuite - ferramenta prática para Field Service.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'
$script:FssSession = [ordered]@{
    Atendimento=$null; Diagnostic=$null; Findings=$null; Recommendations=$null; Checklist=$null; Troubleshooting=$null; Inventory=$null
}
$modulePath = Join-Path $PSScriptRoot 'Modules'
Get-ChildItem $modulePath -Filter '*.psm1' | ForEach-Object { Import-Module $_.FullName -Force -Global }
Write-FssLog 'FieldServiceSuite iniciado.'
do {
    Show-FssMenu
    $op = Read-FssOption
    try {
        switch ($op) {
            '1' { New-FssAtendimento | Out-Null; Pause-Fss }
            '2' { Invoke-FssQuickDiagnostic | Out-Null; Pause-Fss }
            '3' { Invoke-FssTroubleshooting | Out-Null; Pause-Fss }
            '4' { Write-FssHeader 'Inventário de hardware'; $script:FssSession.Inventory = Get-FssInventory; $script:FssSession.Inventory | Format-List; Pause-Fss }
            '5' { Write-FssHeader 'Rede'; $script:FssSession.Network = Get-FssNetworkInfo; $script:FssSession.Network | Format-List; Pause-Fss }
            '6' { Write-FssHeader 'Disco/SMART'; $script:FssSession.Storage = Get-FssStorageInfo; $script:FssSession.Storage | Format-List; Pause-Fss }
            '7' { Write-FssHeader 'Bateria'; $script:FssSession.Battery = Get-FssBatteryInfo; $script:FssSession.Battery | Format-List; Pause-Fss }
            '8' { Show-FssPowerMenu; Pause-Fss }
            '9' { Write-FssHeader 'Drivers'; $script:FssSession.Drivers = Get-FssDriverIssues; $script:FssSession.Drivers | Format-List; Pause-Fss }
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
