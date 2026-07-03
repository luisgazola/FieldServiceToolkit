function Write-FstHeader {
    param(
        [string]$Title = "FIELD SERVICE TOOLKIT",
        [string]$Subtitle = "Diagnóstico técnico para Field Service"
    )

    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║              $Title              ║" -ForegroundColor Cyan
    Write-Host "║      $Subtitle      ║" -ForegroundColor DarkCyan
    Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Write-FstSection {
    param([string]$Title)

    Write-Host ""
    Write-Host "────────────────────────────────────────────────────" -ForegroundColor DarkGray
    Write-Host " $Title" -ForegroundColor Cyan
    Write-Host "────────────────────────────────────────────────────" -ForegroundColor DarkGray
}

function Write-FstSuccess {
    param([string]$Message)

    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Write-FstWarning {
    param([string]$Message)

    Write-Host "[!] $Message" -ForegroundColor Yellow
}

function Write-FstError {
    param([string]$Message)

    Write-Host "[X] $Message" -ForegroundColor Red
}

function Write-FstInfo {
    param([string]$Message)

    Write-Host "[i] $Message" -ForegroundColor Cyan
}

function Write-FstStep {
    param([string]$Message)

    Write-Host "→ $Message" -ForegroundColor Gray
}

function Pause-FstScreen {
    Write-Host ""
    Read-Host "Pressione ENTER para continuar"
}

function Show-FstOption {
    param(
        [string]$Number,
        [string]$Title,
        [string]$Description
    )

    Write-Host " [$Number] " -NoNewline -ForegroundColor Cyan
    Write-Host $Title -NoNewline -ForegroundColor White
    Write-Host " - $Description" -ForegroundColor DarkGray
}

Export-ModuleMember -Function `
    Write-FstHeader, `
    Write-FstSection, `
    Write-FstSuccess, `
    Write-FstWarning, `
    Write-FstError, `
    Write-FstInfo, `
    Write-FstStep, `
    Pause-FstScreen, `
    Show-FstOption