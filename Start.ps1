<#
.SYNOPSIS
    FieldServiceSuite MVC - ferramenta prática para Field Service.
#>
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

. "$PSScriptRoot\App\Core\Bootstrap.ps1"
Start-FssApplication -RootPath $PSScriptRoot
