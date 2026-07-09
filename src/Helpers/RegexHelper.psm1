function Test-FssRegex { param([string]$Value,[string]$Pattern) return [regex]::IsMatch($Value,$Pattern) }
Export-ModuleMember -Function *
