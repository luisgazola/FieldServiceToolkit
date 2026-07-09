function Get-FssServiceMap {
    [ordered]@{
        Atendimento = 'AtendimentoService'
        Diagnostics = 'DiagnosticsService'
        Inventory = 'InventoryService'
        Reports = 'ReportService'
        Rules = 'RulesEngineService'
    }
}
