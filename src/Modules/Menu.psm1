function Show-FstMainMenu {
    [CmdletBinding()]
    param()

    $session = New-FstSession

    do {
        Write-FstHeader
        Write-FstSection "Menu principal"

        Show-FstOption "1"  "Diagnóstico completo" "Executa todos os módulos principais"
        Show-FstOption "2"  "Hardware" "Placa-mãe, CPU, RAM e serial da BIOS"
        Show-FstOption "3"  "Armazenamento" "SSD, NVMe, HD e status SMART"
        Show-FstOption "4"  "Bateria" "Carga, estado e sugestão técnica"
        Show-FstOption "5"  "Rede" "Gateway, DNS e internet sem alterar configurações"
        Show-FstOption "6"  "BitLocker" "Status de criptografia dos volumes"
        Show-FstOption "7"  "Windows Update" "Atualizações pendentes"
        Show-FstOption "8"  "Logs do Windows" "Eventos críticos, erros e avisos"
        Show-FstOption "9"  "Energia" "Opções controladas de energia"
        Show-FstOption "10" "Gerar relatório" "Cria relatório TXT do atendimento"
        Show-FstOption "0"  "Sair" "Finaliza o toolkit"

        Write-Host ""
        $choice = Read-Host "Escolha uma opção"

        if ($choice -notmatch '^(0|[1-9]|10)$') {
            Write-FstWarning "Opção inválida."
            Pause-FstScreen
            continue
        }

        switch ($choice) {
            "1" {
                Write-FstSection "Diagnóstico completo"
                Write-FstStep "Coletando hardware..."
                $session.SystemInfo = Get-FstSystemInfo

                Write-FstStep "Verificando armazenamento..."
                $session.StorageInfo = Get-FstStorageHealth

                Write-FstStep "Verificando bateria..."
                $session.BatteryInfo = Get-FstBatteryInfo

                Write-FstStep "Testando rede..."
                $session.NetworkInfo = Test-FstNetwork

                Write-FstStep "Verificando BitLocker..."
                $session.BitLockerInfo = Get-FstBitLockerStatus

                Write-FstStep "Consultando Windows Update..."
                $session.WindowsUpdateInfo = Get-FstWindowsUpdateStatus

                Write-FstStep "Lendo logs do Windows..."
                $session.WindowsErrors = Get-FstRecentWindowsErrors

                Write-FstSuccess "Diagnóstico completo finalizado."
                Pause-FstScreen
            }

            "2" {
                Write-FstSection "Hardware"
                $session.SystemInfo = Get-FstSystemInfo
                $session.SystemInfo | Format-List
                Pause-FstScreen
            }

            "3" {
                Write-FstSection "Armazenamento"
                $session.StorageInfo = Get-FstStorageHealth
                $session.StorageInfo | Format-Table
                Pause-FstScreen
            }

            "4" {
                Write-FstSection "Bateria"
                $session.BatteryInfo = Get-FstBatteryInfo
                $session.BatteryInfo | Format-List
                Pause-FstScreen
            }

            "5" {
                Write-FstSection "Rede"
                $session.NetworkInfo = Test-FstNetwork
                $session.NetworkInfo | Format-List
                Pause-FstScreen
            }

            "6" {
                Write-FstSection "BitLocker"
                $session.BitLockerInfo = Get-FstBitLockerStatus
                $session.BitLockerInfo | Format-Table
                Pause-FstScreen
            }

            "7" {
                Write-FstSection "Windows Update"
                $session.WindowsUpdateInfo = Get-FstWindowsUpdateStatus
                $session.WindowsUpdateInfo | Format-List
                Pause-FstScreen
            }

            "8" {
                Write-FstSection "Logs do Windows"
                $session.WindowsErrors = Get-FstRecentWindowsErrors
                $session.WindowsErrors | Format-List
                Pause-FstScreen
            }

            "9" {
                $session.PowerPolicyChanges += Show-FstPowerPolicyMenu
                $session.PowerPolicyChanges | Format-List
                Pause-FstScreen
            }

            "10" {
                Write-FstSection "Relatório"

                if (-not $session.SystemInfo) {
                    Write-FstInfo "Coletando identificação mínima do equipamento..."
                    $session.SystemInfo = Get-FstSystemInfo
                }

                $reportPath = New-FstReport -Session $session

                Write-FstSuccess "Relatório gerado com sucesso."
                Write-Host $reportPath -ForegroundColor Green

                Pause-FstScreen
            }

            "0" {
                Write-FstSuccess "Encerrando Field Service Toolkit."
                return
            }
        }
    } while ($true)
}

Export-ModuleMember -Function Show-FstMainMenu