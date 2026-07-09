function Write-FssHeader {
    param([string]$Title = 'FieldServiceSuite')
    Clear-Host
    Write-Host '╔══════════════════════════════════════════════════════╗' -ForegroundColor DarkCyan
    Write-Host ('║ {0,-52} ║' -f $Title) -ForegroundColor Cyan
    Write-Host '╚══════════════════════════════════════════════════════╝' -ForegroundColor DarkCyan
}
function Write-FssStatus { param([string]$Message,[ValidateSet('OK','WARN','CRIT','INFO')]$Level='INFO')
    $color = @{OK='Green';WARN='Yellow';CRIT='Red';INFO='Cyan'}[$Level]
    $icon = @{OK='✓';WARN='!';CRIT='✖';INFO='•'}[$Level]
    Write-Host "[$icon] $Message" -ForegroundColor $color
}
function Read-FssOption { param([string]$Prompt='Escolha')
    Write-Host ''; Read-Host $Prompt
}
function Pause-Fss { Write-Host ''; Read-Host 'Pressione ENTER para continuar' | Out-Null }
function Show-FssMenu {
    Write-FssHeader 'FieldServiceSuite - Menu Principal'
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
}
Export-ModuleMember -Function *
