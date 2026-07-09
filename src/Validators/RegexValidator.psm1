function Assert-FssRegexValue {
    param([string]$Label,[string]$Value,[string]$Pattern)
    if(-not [regex]::IsMatch($Value,$Pattern)){ throw "$Label inválido." }
    return $true
}
Export-ModuleMember -Function *
