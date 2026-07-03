function ConvertTo-FstSafeName {
    [CmdletBinding()]
    param([Parameter(Mandatory)][string]$Value)

    return $Value.Trim() `
        -replace '[\\/:*?"<>|]', '_' `
        -replace '\s+', '_' `
        -replace '_+', '_'
}

function Read-FstRequiredInput {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Label,
        [string]$RegexPattern = '.+',
        [string]$ErrorMessage = "Valor inválido."
    )

    do {
        $value = Read-Host $Label
        $value = $value.Trim()

        if ($value -match $RegexPattern) {
            return $value
        }

        Show-FstWarning $ErrorMessage
    } while ($true)
}

Export-ModuleMember -Function ConvertTo-FstSafeName, Read-FstRequiredInput