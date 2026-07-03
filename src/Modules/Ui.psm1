function Show-FstHeader {
    [CmdletBinding()]
    param(
        [string]$Title = "FIELD SERVICE TOOLKIT",
        [string]$Subtitle = "Diagnóstico técnico para Field Service"
    )

    Clear-Host
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host " $Title" -ForegroundColor Cyan
    Write-Host " $Subtitle" -ForegroundColor DarkCyan
    Write-Host "============================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-FstSection {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Title)

    Write-Host ""
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host " $Title" -ForegroundColor Cyan
    Write-Host "------------------------------------------------------------" -ForegroundColor DarkGray
}

function Show-FstSuccess {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Message)

    Write-Host "[OK] $Message" -ForegroundColor Green
}

function Show-FstWarning {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Message)

    Write-Host "[!] $Message" -ForegroundColor Yellow
}

function Show-FstError {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Message)

    Write-Host "[X] $Message" -ForegroundColor Red
}

function Show-FstInfo {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Message)

    Write-Host "[i] $Message" -ForegroundColor Cyan
}

function Show-FstStep {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Message)

    Write-Host "-> $Message" -ForegroundColor Gray
}

function Show-FstOption {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Number,
        [Parameter(Mandatory)][string]$Title,
        [Parameter(Mandatory)][string]$Description
    )

    Write-Host " [$Number] " -NoNewline -ForegroundColor Cyan
    Write-Host $Title -NoNewline -ForegroundColor White
    Write-Host " - $Description" -ForegroundColor DarkGray
}

function Wait-FstInput {
    [CmdletBinding()]
    param()

    Write-Host ""
    Read-Host "Pressione ENTER para continuar"
}

Export-ModuleMember -Function `
    Show-FstHeader, `
    Show-FstSection, `
    Show-FstSuccess, `
    Show-FstWarning, `
    Show-FstError, `
    Show-FstInfo, `
    Show-FstStep, `
    Show-FstOption, `
    Wait-FstInput