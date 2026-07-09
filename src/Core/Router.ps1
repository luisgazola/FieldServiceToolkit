function Invoke-FssRoute {
    param([Parameter(Mandatory)][string]$Route)
    switch ($Route) {
        'menu' { Invoke-FssMainController }
        'atendimento' { Invoke-FssAtendimentoController }
        'diagnostico' { Invoke-FssDiagnosticController }
        'troubleshooting' { Invoke-FssTroubleshootingController }
        'relatorio' { New-FssReport }
        default { Write-FssStatus "Rota não encontrada: $Route" WARN }
    }
}
