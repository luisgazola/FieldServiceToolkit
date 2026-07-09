function Write-FssHeader {
    param([string]$Title)
    Clear-Host
    Write-Host ''
    Write-Host '╔══════════════════════════════════════════════════════╗' -ForegroundColor DarkCyan
    Write-Host ("║ {0,-52} ║" -f $Title.ToUpper()) -ForegroundColor Cyan
    Write-Host '╚══════════════════════════════════════════════════════╝' -ForegroundColor DarkCyan
    Write-Host ''
}
function Write-FssStatus {
    param([string]$Message,[ValidateSet('OK','WARN','CRIT','INFO')]$Level='INFO')
    $map = @{ OK='Green'; WARN='Yellow'; CRIT='Red'; INFO='Cyan' }
    $icon = @{ OK='[OK]'; WARN='[!]'; CRIT='[X]'; INFO='[i]' }
    Write-Host ("{0} {1}" -f $icon[$Level],$Message) -ForegroundColor $map[$Level]
}
function Read-FssOption { param([string]$Prompt='Escolha') return (Read-Host $Prompt).Trim() }
function Pause-Fss { Write-Host ''; Read-Host 'Pressione ENTER para continuar' | Out-Null }
function Show-FssMenu {
    Write-FssHeader 'FieldServiceSuite MVC'
    Write-Host '1. Novo atendimento'
    Write-Host '2. Diagnóstico rápido'
    Write-Host '3. Troubleshooting guiado'
    Write-Host '4. Inventário de hardware'
    Write-Host '5. Rede'
    Write-Host '6. Disco/SMART'
    Write-Host '7. Bateria'
    Write-Host '8. Energia'
    Write-Host '9. Drivers'
    Write-Host '10. Checklist manual'
    Write-Host '11. Dashboard'
    Write-Host '12. Gerar relatório'
    Write-Host '0. Sair'
    Write-Host ''
}
Export-ModuleMember -Function *
