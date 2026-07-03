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

Export-ModuleMember -Function New-FstSession, Show-FstMainMenu