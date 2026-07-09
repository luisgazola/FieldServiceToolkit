function Invoke-FssTroubleshootingController {
    Write-FssHeader 'Troubleshooting guiado'
    $defeito = if ($global:FssState.Atendimento) { $global:FssState.Atendimento.DefeitoRelatado } else { Read-Host 'Defeito relatado' }
    $flow = Invoke-FssTroubleshootingFlow -Defeito $defeito
    Write-Host "Defeito: $($flow.Defeito)" -ForegroundColor White
    Write-Host ''
    $i = 1
    foreach ($step in $flow.Fluxo) { Write-Host "$i. $step"; $i++ }
    Write-Host ''
    Write-FssStatus 'Execute o diagnóstico rápido para cruzar evidências e gerar recomendações.' INFO
    return $flow
}
Export-ModuleMember -Function *
