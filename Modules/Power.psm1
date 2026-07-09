function Show-FssPowerMenu {
    Write-FssHeader 'Energia'
    Write-Host '1. Desativar suspensão'
    Write-Host '2. Desativar hibernação'
    Write-Host '3. Evitar desligamento de tela'
    Write-Host '4. Fechar tampa -> desligar'
    Write-Host '5. Restaurar padrão equilibrado'
    Write-Host '0. Voltar'
    $op = Read-FssOption
    switch($op){
        '1' { powercfg /change standby-timeout-ac 0; powercfg /change standby-timeout-dc 0; Write-FssStatus 'Suspensão desativada.' OK }
        '2' { powercfg /hibernate off; Write-FssStatus 'Hibernação desativada.' OK }
        '3' { powercfg /change monitor-timeout-ac 0; powercfg /change monitor-timeout-dc 0; Write-FssStatus 'Desligamento de tela desativado.' OK }
        '4' { powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 3; powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 3; powercfg /setactive SCHEME_CURRENT; Write-FssStatus 'Tampa configurada para desligar.' OK }
        '5' { powercfg /setactive SCHEME_BALANCED; Write-FssStatus 'Plano equilibrado restaurado.' OK }
    }
}
Export-ModuleMember -Function *
