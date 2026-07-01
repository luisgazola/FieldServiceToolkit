function ConvertTo-FstSafeName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Value
    )

    return $Value.Trim() `
        -replace '[\\/:*?"<>|]', '_' `
        -replace '\s+', '_' `
        -replace '_+', '_'
}

function Test-FstTicketNumber {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$TicketNumber
    )

    return $TicketNumber -match '^[A-Za-z0-9][A-Za-z0-9._-]{2,40}$'
}

function Read-FstRequiredInput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Label,

        [string]$RegexPattern = '.+',

        [string]$ErrorMessage = "Valor inválido."
    )

    do {
        $value = Read-Host $Label
        $value = $value.Trim()

        if ($value -match $RegexPattern) {
            return $value
        }

        Write-Host $ErrorMessage -ForegroundColor Yellow
    } while ($true)
}

Export-ModuleMember -Function `
    ConvertTo-FstSafeName, `
    Test-FstTicketNumber, `
    Read-FstRequiredInput