#requires -Version 7.0

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$modulePath = Join-Path $PSScriptRoot "Modules"

Import-Module "$modulePath\Validation.psm1" -Force
Import-Module "$modulePath\Hardware.psm1" -Force
Import-Module "$modulePath\Battery.psm1" -Force
Import-Module "$modulePath\Network.psm1" -Force
Import-Module "$modulePath\WindowsMaintenance.psm1" -Force
Import-Module "$modulePath\PowerPolicy.psm1" -Force
Import-Module "$modulePath\Report.psm1" -Force
Import-Module "$modulePath\Menu.psm1" -Force

Show-FstMainMenu