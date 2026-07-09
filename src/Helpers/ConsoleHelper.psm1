function Write-FssDivider { Write-Host ('-' * 72) -ForegroundColor DarkGray }
function Write-FssSection { param([string]$Title) Write-FssDivider; Write-Host " $Title" -ForegroundColor Cyan; Write-FssDivider }
Export-ModuleMember -Function *
