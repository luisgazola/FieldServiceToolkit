function Test-FssRegex {
    param([string]$Value,[string]$Pattern)
    return [regex]::IsMatch(($Value ?? ''),$Pattern)
}
function Read-FssValidated {
    param([string]$Label,[string]$Pattern,[bool]$Required=$true)
    do {
        $v = Read-Host $Label
        if (-not $Required -and [string]::IsNullOrWhiteSpace($v)) { return '' }
        if (Test-FssRegex -Value $v -Pattern $Pattern) { return $v.Trim() }
        Write-FssStatus "Valor inválido para $Label" WARN
    } while ($true)
}
Export-ModuleMember -Function *
