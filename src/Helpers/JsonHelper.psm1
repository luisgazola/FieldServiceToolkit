function Read-FssJsonFile { param([string]$Path) if(Test-Path $Path){ Get-Content $Path -Raw | ConvertFrom-Json } else { $null } }
function Write-FssJsonFile { param([string]$Path,$Data) $Data | ConvertTo-Json -Depth 10 | Set-Content $Path -Encoding UTF8 }
Export-ModuleMember -Function *
