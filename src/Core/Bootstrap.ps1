function Import-FssLayer {
    param([string]$Path)
    if (Test-Path $Path) {
        Get-ChildItem -Path $Path -Filter '*.psm1' -Recurse | Sort-Object FullName | ForEach-Object {
            Import-Module $_.FullName -Force -Global
        }
    }
}

function Initialize-FssState {
    param([string]$RootPath)
    $global:FssState = [ordered]@{
        RootPath = $RootPath
        Config = Get-FssConfig -RootPath $RootPath
        Atendimento = $null
        Inventory = $null
        Diagnostic = $null
        Troubleshooting = $null
        Checklist = $null
        Recommendations = @()
        Findings = @()
        LastReportFolder = $null
    }
    Initialize-FssLogFolder -RootPath $RootPath | Out-Null
    Write-FssLog -Message 'Aplicação iniciada.' -Level 'INFO'
}

function Start-FssApplication {
    param([string]$RootPath)
    Import-FssLayer "$RootPath\src\Helpers"
    Import-FssLayer "$RootPath\src\Validators"
    Import-FssLayer "$RootPath\src\Models"
    Import-FssLayer "$RootPath\src\Views"
    Import-FssLayer "$RootPath\src\Services"
    Import-FssLayer "$RootPath\src\Controllers"
    Initialize-FssState -RootPath $RootPath
    Invoke-FssMainController
}
