function Get-FstBitLockerStatus {
    [CmdletBinding()]
    param()

    try {
        Get-BitLockerVolume | ForEach-Object {
            [pscustomobject]@{
                MountPoint       = $_.MountPoint
                VolumeStatus     = $_.VolumeStatus
                ProtectionStatus = $_.ProtectionStatus
                EncryptionMethod = $_.EncryptionMethod
                LockStatus       = $_.LockStatus
                Suggestion       = if ($_.ProtectionStatus -eq "On") {
                    "BitLocker ativo. Não alterar sem autorização."
                } else {
                    "BitLocker não protegido ou não ativo."
                }
            }
        }
    }
    catch {
        [pscustomobject]@{
            MountPoint       = "Indisponível"
            VolumeStatus     = "Não coletado"
            ProtectionStatus = "Não coletado"
            EncryptionMethod = "Não coletado"
            LockStatus       = "Não coletado"
            Suggestion       = "Verificar edição do Windows ou permissões."
        }
    }
}

function Get-FstWindowsUpdateStatus {
    [CmdletBinding()]
    param()

    try {
        $session = New-Object -ComObject Microsoft.Update.Session
        $searcher = $session.CreateUpdateSearcher()
        $result = $searcher.Search("IsInstalled=0 and Type='Software'")

        [pscustomobject]@{
            PendingUpdates = $result.Updates.Count
            Updates        = for ($i = 0; $i -lt $result.Updates.Count; $i++) {
                $result.Updates.Item($i).Title
            }
            Suggestion = if ($result.Updates.Count -gt 0) {
                "Há atualizações pendentes. Validar janela de manutenção."
            } else {
                "Nenhuma atualização pendente encontrada."
            }
        }
    }
    catch {
        [pscustomobject]@{
            PendingUpdates = "Não coletado"
            Updates        = $_.Exception.Message
            Suggestion     = "Não foi possível consultar Windows Update."
        }
    }
}

function Get-FstRecentWindowsErrors {
    [CmdletBinding()]
    param()

    $since = (Get-Date).AddDays(-7)

    try {
        Get-WinEvent -FilterHashtable @{
            LogName   = "System", "Application"
            Level     = 1, 2, 3
            StartTime = $since
        } -MaxEvents 30 -ErrorAction Stop |
        Select-Object TimeCreated, LogName, ProviderName, Id, LevelDisplayName, Message
    }
    catch {
        [pscustomobject]@{
            TimeCreated      = Get-Date
            LogName          = "Indisponível"
            ProviderName     = "Indisponível"
            Id               = "N/A"
            LevelDisplayName = "N/A"
            Message          = "Não foi possível coletar logs: $($_.Exception.Message)"
        }
    }
}

Export-ModuleMember -Function `
    Get-FstBitLockerStatus, `
    Get-FstWindowsUpdateStatus, `
    Get-FstRecentWindowsErrors