function Test-FstAdministrator {
    [CmdletBinding()]
    param()

    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)

    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Test-FstNotebook {
    [CmdletBinding()]
    param()

    $battery = Get-CimInstance Win32_Battery -ErrorAction SilentlyContinue
    $chassis = Get-CimInstance Win32_SystemEnclosure -ErrorAction SilentlyContinue

    $notebookChassisTypes = @(8, 9, 10, 14, 30, 31, 32)

    return [bool](
        $battery -or
        ($chassis.ChassisTypes | Where-Object { $_ -in $notebookChassisTypes })
    )
}

function Set-FstLidCloseShutdown {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if (-not (Test-FstAdministrator)) {
        return [pscustomobject]@{
            Applied    = $false
            Setting    = "Fechar tampa/display"
            Result     = "Permissão insuficiente."
            Suggestion = "Executar PowerShell como administrador."
        }
    }

    if (-not (Test-FstNotebook)) {
        return [pscustomobject]@{
            Applied    = $false
            Setting    = "Fechar tampa/display"
            Result     = "Equipamento não identificado como notebook."
            Suggestion = "Ação ignorada."
        }
    }

    if ($PSCmdlet.ShouldProcess("Plano atual", "Fechar tampa e desligar")) {
        powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 3 | Out-Null
        powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 3 | Out-Null
        powercfg /setactive SCHEME_CURRENT | Out-Null
    }

    [pscustomobject]@{
        Applied    = $true
        Setting    = "Fechar tampa/display"
        Result     = "Configurado para desligar na tomada e na bateria."
        Suggestion = "Usar somente com autorização do cliente."
    }
}

function Set-FstPreventSleepAndDisplayOff {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    if (-not (Test-FstAdministrator)) {
        return [pscustomobject]@{
            Applied    = $false
            Setting    = "Energia por inatividade"
            Result     = "Permissão insuficiente."
            Suggestion = "Executar PowerShell como administrador."
        }
    }

    if ($PSCmdlet.ShouldProcess("Plano atual", "Desativar tela, suspensão e hibernação por inatividade")) {
        powercfg /change monitor-timeout-ac 0 | Out-Null
        powercfg /change monitor-timeout-dc 0 | Out-Null
        powercfg /change standby-timeout-ac 0 | Out-Null
        powercfg /change standby-timeout-dc 0 | Out-Null
        powercfg /change hibernate-timeout-ac 0 | Out-Null
        powercfg /change hibernate-timeout-dc 0 | Out-Null
        powercfg /setactive SCHEME_CURRENT | Out-Null
    }

    [pscustomobject]@{
        Applied    = $true
        Setting    = "Energia por inatividade"
        Result     = "Tela, suspensão e hibernação por tempo foram desativadas."
        Suggestion = "Em notebook, pode aumentar consumo de bateria."
    }
}

function Show-FstPowerPolicyMenu {
    [CmdletBinding()]
    param()

    Write-Host ""
    Write-Host "=========== ENERGIA ===========" -ForegroundColor Cyan
    Write-Host "1 - Fechar tampa/display e desligar notebook"
    Write-Host "2 - Não suspender, não hibernar e não desligar tela"
    Write-Host "3 - Aplicar as duas opções"
    Write-Host "0 - Voltar"
    Write-Host "==============================="
    Write-Host ""

    $choice = Read-Host "Escolha uma opção"

    if ($choice -notmatch '^[0-3]$') {
        return [pscustomobject]@{
            Applied    = $false
            Setting    = "Energia"
            Result     = "Opção inválida."
            Suggestion = "Nenhuma alteração aplicada."
        }
    }

    switch ($choice) {
        "1" { Set-FstLidCloseShutdown }
        "2" { Set-FstPreventSleepAndDisplayOff }
        "3" {
            @(
                Set-FstLidCloseShutdown
                Set-FstPreventSleepAndDisplayOff
            )
        }
        "0" {
            [pscustomobject]@{
                Applied    = $false
                Setting    = "Energia"
                Result     = "Nenhuma alteração aplicada."
                Suggestion = "Retorno ao menu principal."
            }
        }
    }
}

Export-ModuleMember -Function `
    Test-FstAdministrator, `
    Test-FstNotebook, `
    Set-FstLidCloseShutdown, `
    Set-FstPreventSleepAndDisplayOff, `
    Show-FstPowerPolicyMenu