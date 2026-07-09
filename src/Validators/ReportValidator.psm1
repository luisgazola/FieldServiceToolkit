function Test-FssReportReady { return [bool]($global:FssState -and $global:FssState.Atendimento) }
Export-ModuleMember -Function *
