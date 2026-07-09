function Show-FssPowerMenu {
    Write-FssHeader 'Energia'
    Write-Host '1. Desativar suspensão'
    Write-Host '2. Desativar hibernação'
    Write-Host '3. Não desligar tela'
    Write-Host '4. Fechar tampa = desligar'
    Write-Host '0. Voltar'
    $op = Read-FssOption
    switch ($op) {
        '1' { powercfg /change standby-timeout-ac 0; powercfg /change standby-timeout-dc 0; Write-FssStatus 'Suspensão desativada.' OK }
        '2' { powercfg /hibernate off; Write-FssStatus 'Hibernação desativada.' OK }
        '3' { powercfg /change monitor-timeout-ac 0; powercfg /change monitor-timeout-dc 0; Write-FssStatus 'Tela configurada para não desligar.' OK }
        '4' { powercfg /setacvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 3; powercfg /setdcvalueindex SCHEME_CURRENT SUB_BUTTONS LIDACTION 3; powercfg /S SCHEME_CURRENT; Write-FssStatus 'Fechar tampa configurado para desligar.' OK }
    }
}
Export-ModuleMember -Function *
