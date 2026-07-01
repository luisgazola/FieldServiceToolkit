function Resolve-FstReportValue {
    [CmdletBinding()]
    param(
        [object]$Value,
        [string]$Fallback = "Módulo não executado."
    )

    if ($null -eq $Value) {
        return $Fallback
    }

    return $Value
}

function New-FstReport {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Session
    )

    $date = Get-Date -Format "yyyy-MM-dd"

    $systemInfo = Resolve-FstReportValue -Value $Session.SystemInfo
    $storageInfo = Resolve-FstReportValue -Value $Session.StorageInfo
    $batteryInfo = Resolve-FstReportValue -Value $Session.BatteryInfo
    $networkInfo = Resolve-FstReportValue -Value $Session.NetworkInfo
    $bitLockerInfo = Resolve-FstReportValue -Value $Session.BitLockerInfo
    $windowsUpdateInfo = Resolve-FstReportValue -Value $Session.WindowsUpdateInfo
    $windowsErrors = Resolve-FstReportValue -Value $Session.WindowsErrors
    $powerPolicyChanges = Resolve-FstReportValue -Value $Session.PowerPolicyChanges

    $serial = if ($Session.SystemInfo -and $Session.SystemInfo.SerialNumber) {
        $Session.SystemInfo.SerialNumber
    } else {
        "SEM_SERIAL"
    }

    $safeTicket = ConvertTo-FstSafeName -Value $Session.TicketNumber
    $safeSerial = ConvertTo-FstSafeName -Value $serial

    $rootPath = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $folder = Join-Path $rootPath "relatorio\$date\$safeTicket-$safeSerial"

    New-Item -ItemType Directory -Path $folder -Force | Out-Null

    $file = Join-Path $folder "relatorio.txt"

@"
FIELD SERVICE TOOLKIT - RELATÓRIO TÉCNICO

Técnico: $($Session.TechnicianName)
Cliente / Escola: $($Session.ClientName)
Chamado: $($Session.TicketNumber)
Data: $(Get-Date -Format "dd/MM/yyyy HH:mm:ss")

==================================================
IDENTIFICAÇÃO DO EQUIPAMENTO
==================================================
$($systemInfo | Format-List | Out-String)

==================================================
SAÚDE DO SSD / NVME / HD
==================================================
$($storageInfo | Format-Table | Out-String)

==================================================
BATERIA
==================================================
$($batteryInfo | Format-List | Out-String)

==================================================
REDE
==================================================
$($networkInfo | Format-List | Out-String)

==================================================
BITLOCKER
==================================================
$($bitLockerInfo | Format-Table | Out-String)

==================================================
WINDOWS UPDATE
==================================================
$($windowsUpdateInfo | Format-List | Out-String)

==================================================
ALTERAÇÕES OPCIONAIS DE ENERGIA
==================================================
$($powerPolicyChanges | Format-List | Out-String)

==================================================
LOGS RECENTES DO WINDOWS
Últimos 7 dias - System/Application - Crítico, Erro e Aviso
==================================================
$($windowsErrors | Format-List | Out-String)

==================================================
RECOMENDAÇÕES GERAIS
==================================================
- Não alterar rede corporativa sem autorização.
- Não alterar BitLocker sem autorização.
- Em falha de disco, orientar backup imediato.
- Em falhas recorrentes no log, registrar evidências no chamado.
- Em bateria crítica ou autonomia baixa, validar em uso real.
- Atualizações pendentes devem respeitar janela de manutenção.
- Alterações de energia devem ser aplicadas apenas quando fizerem sentido para o atendimento.

==================================================
ASSINATURA TÉCNICA
==================================================
Técnico responsável: $($Session.TechnicianName)
Chamado: $($Session.TicketNumber)
Data da análise: $(Get-Date -Format "dd/MM/yyyy")
Hora da análise: $(Get-Date -Format "HH:mm:ss")

Assinatura: ______________________________________
"@ | Set-Content -Path $file -Encoding UTF8

    return $file
}

Export-ModuleMember -Function New-FstReport