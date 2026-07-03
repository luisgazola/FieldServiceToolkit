function New-FstSession {
    [CmdletBinding()]
    param()

    Show-FstHeader

    $technicianName = Read-FstRequiredInput `
        -Label "Nome do técnico" `
        -RegexPattern '^[\p{L}\s.-]{3,60}$' `
        -ErrorMessage "Informe um nome válido."

    $clientName = Read-FstRequiredInput `
        -Label "Cliente / Escola" `
        -RegexPattern '^[\p{L}\p{N}\s._-]{2,80}$' `
        -ErrorMessage "Informe um cliente válido."

    $ticketNumber = Read-FstRequiredInput `
        -Label "Número do chamado" `
        -RegexPattern '^[A-Za-z0-9][A-Za-z0-9._-]{2,40}$' `
        -ErrorMessage "Use letras, números, ponto, hífen ou underline."

    return @{
        TechnicianName     = $technicianName
        ClientName         = $clientName
        TicketNumber       = $ticketNumber
        SystemInfo         = $null
        StorageInfo        = $null
        BatteryInfo        = $null
        NetworkInfo        = $null
        BitLockerInfo      = $null
        WindowsUpdateInfo  = $null
        WindowsErrors      = $null
        PowerPolicyChanges = @()
    }
}

function Show-FstMainMenu {
    [CmdletBinding()]
    param()

    $session = New-FstSession

    do {
        Show-FstHeader
        Show-FstSection "Menu principal"

        Show-FstOption "1"  "Diagnóstico completo" "Executa todos os módulos"
        Show-FstOption "2"  "Hardware" "Placa-mãe, CPU, RAM e serial"
        Show-FstOption "3"  "Armazenamento" "SSD, NVMe, HD e saúde"
        Show-FstOption "4"  "Bateria" "Carga, estado e sugestão"
        Show-FstOption "5"  "Rede" "Gateway, DNS e internet"
        Show-FstOption "6"  "BitLocker" "Status de criptografia"
        Show-FstOption "7"  "Windows Update" "Atualizações pendentes"
        Show-FstOption "8"  "Logs do Windows" "Erros e avisos recentes"
        Show-FstOption "9"  "Energia" "Configurações opcionais"
        Show-FstOption "10" "Gerar relatório" "Cria relatório TXT"
        Show-FstOption "0"  "Sair" "Finaliza o toolkit"

        Write-Host ""
        $choice = Read-Host "Escolha uma opção"

        if ($choice -notmatch '^(0|[1-9]|10)$') {
            Show-FstWarning "Opção inválida."
            Wait-FstInput
            continue
        }

        switch ($choice) {
            "1" {
                Show-FstSection "Diagnóstico completo"

                Show-FstStep "Coletando hardware..."
                $session.SystemInfo = Get-FstSystemInfo

                Show-FstStep "Verificando armazenamento..."
                $session.StorageInfo = Get-FstStorageHealth

                Show-FstStep "Verificando bateria..."
                $session.BatteryInfo = Get-FstBatteryInfo

                Show-FstStep "Testando rede..."
                $session.NetworkInfo = Test-FstNetwork

                Show-FstStep "Verificando BitLocker..."
                $session.BitLockerInfo = Get-FstBitLockerStatus

                Show-FstStep "Consultando Windows Update..."
                $session.WindowsUpdateInfo = Get-FstWindowsUpdateStatus

                Show-FstStep "Lendo logs do Windows..."
                $session.WindowsErrors = Get-FstRecentWindowsErrors

                Show-FstSuccess "Diagnóstico completo finalizado."
                Wait-FstInput
            }

            "2" {
                Show-FstSection "Hardware"
                $session.SystemInfo = Get-FstSystemInfo
                $session.SystemInfo | Format-List
                Wait-FstInput
            }

            "3" {
                Show-FstSection "Armazenamento"
                $session.StorageInfo = Get-FstStorageHealth
                $session.StorageInfo | Format-Table
                Wait-FstInput
            }

            "4" {
                Show-FstSection "Bateria"
                $session.BatteryInfo = Get-FstBatteryInfo
                $session.BatteryInfo | Format-List
                Wait-FstInput
            }

            "5" {
                Show-FstSection "Rede"
                $session.NetworkInfo = Test-FstNetwork
                $session.NetworkInfo | Format-List
                Wait-FstInput
            }

            "6" {
                Show-FstSection "BitLocker"
                $session.BitLockerInfo = Get-FstBitLockerStatus
                $session.BitLockerInfo | Format-Table
                Wait-FstInput
            }

            "7" {
                Show-FstSection "Windows Update"
                $session.WindowsUpdateInfo = Get-FstWindowsUpdateStatus
                $session.WindowsUpdateInfo | Format-List
                Wait-FstInput
            }

            "8" {
                Show-FstSection "Logs do Windows"
                $session.WindowsErrors = Get-FstRecentWindowsErrors
                $session.WindowsErrors | Format-List
                Wait-FstInput
            }

            "9" {
                Show-FstSection "Energia"
                $session.PowerPolicyChanges += Show-FstPowerPolicyMenu
                $session.PowerPolicyChanges | Format-List
                Wait-FstInput
            }

            "10" {
                Show-FstSection "Relatório"

                if (-not $session.SystemInfo) {
                    Show-FstInfo "Coletando identificação mínima do equipamento..."
                    $session.SystemInfo = Get-FstSystemInfo
                }

                $reportPath = New-FstReport -Session $session

                Show-FstSuccess "Relatório gerado com sucesso."
                Write-Host $reportPath -ForegroundColor Green

                Wait-FstInput
            }

            "0" {
                Show-FstSuccess "Encerrando Field Service Toolkit."
                return
            }
        }
    } while ($true)
}

Export-ModuleMember -Function New-FstSession, Show-FstMainMenu