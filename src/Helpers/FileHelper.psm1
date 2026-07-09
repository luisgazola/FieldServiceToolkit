function New-FssDirectory { param([string]$Path) if(-not(Test-Path $Path)){ New-Item -ItemType Directory -Path $Path -Force | Out-Null }; return $Path }
function ConvertTo-FssSafeName { param([string]$Value) return ($Value -replace '[^A-Za-z0-9._-]','_') }
Export-ModuleMember -Function *
