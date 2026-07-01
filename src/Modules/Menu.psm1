function New-FstSession {
    [CmdletBinding()]
    param()

    Clear-Host

    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " FIELD SERVICE TOOLKIT" -ForegroundColor Cyan
    Write-Host " Diagnóstico técnico para Field Service" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""

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
        -ErrorMessage "Use apenas letras, números, ponto, hífen ou underline."

    return [ordered]@{
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
        Write-Host ""
        Write-Host "================ MENU PRINCIPAL ================" -ForegroundColor Cyan
        Write-Host "1  - Diagnóstico completo"
        Write-Host "2  - Hardware"
        Write-Host "3  - SSD / NVMe / HD"
        Write-Host "4  - Bateria"
        Write-Host "5  - Rede"
        Write-Host "6  - BitLocker"
        Write-Host "7  - Windows Update"
        Write-Host "8  - Logs do Windows"
        Write-Host "9  - Energia"
        Write-Host "10 - Gerar relatório"
        Write-Host "0  - Sair"
        Write-Host "================================================"
        Write-Host ""

        $choice = Read-Host "Escolha uma opção"

        if ($choice -notmatch '^(0|[1-9]|10)$') {
            Write-Host "Opção inválida." -ForegroundColor Yellow
            continue
        }

        switch ($choice) {
            "1" {
                Write-Host "Executando diagnóstico completo..." -ForegroundColor Yellow
                $session.SystemInfo         = Get-FstSystemInfo
                $session.StorageInfo        = Get-FstStorageHealth
                $session.BatteryInfo        = Get-FstBatteryInfo
                $session.NetworkInfo        = Test-FstNetwork
                $session.BitLockerInfo      = Get-FstBitLockerStatus
                $session.WindowsUpdateInfo  = Get-FstWindowsUpdateStatus
                $session.WindowsErrors      = Get-FstRecentWindowsErrors
                Write-Host "Diagnóstico completo finalizado." -ForegroundColor Green
            }

            "2" {
                $session.SystemInfo = Get-FstSystemInfo
                $session.SystemInfo | Format-List
            }

            "3" {
                $session.StorageInfo = Get-FstStorageHealth
                $session.StorageInfo | Format-Table
            }

            "4" {
                $session.BatteryInfo = Get-FstBatteryInfo
                $session.BatteryInfo | Format-List
            }

            "5" {
                $session.NetworkInfo = Test-FstNetwork
                $session.NetworkInfo | Format-List
            }

            "6" {
                $session.BitLockerInfo = Get-FstBitLockerStatus
                $session.BitLockerInfo | Format-Table
            }

            "7" {
                $session.WindowsUpdateInfo = Get-FstWindowsUpdateStatus
                $session.WindowsUpdateInfo | Format-List
            }

            "8" {
                $session.WindowsErrors = Get-FstRecentWindowsErrors
                $session.WindowsErrors | Format-List
            }

            "9" {
                $session.PowerPolicyChanges += Show-FstPowerPolicyMenu
                $session.PowerPolicyChanges | Format-List
            }

            "10" {
                if (-not $session.SystemInfo) {
                    $session.SystemInfo = Get-FstSystemInfo
                }

                $reportPath = New-FstReport -Session $session

                Write-Host ""
                Write-Host "Relatório gerado com sucesso:" -ForegroundColor Green
                Write-Host $reportPath -ForegroundColor Green
            }

            "0" {
                Write-Host "Encerrando Field Service Toolkit." -ForegroundColor Cyan
                return
            }
        }
    } while ($true)
}

Export-ModuleMember -Function Show-FstMainMenu