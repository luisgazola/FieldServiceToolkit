function Show-FssDashboard {
    Write-FssHeader 'Dashboard do atendimento'
    $a = $global:FssState.Atendimento
    if (-not $a) { Write-FssStatus 'Nenhum atendimento iniciado.' WARN; return }
    Write-Host "Chamado : $($a.Chamado)" -ForegroundColor White
    Write-Host "Cliente : $($a.Cliente)" -ForegroundColor White
    Write-Host "Técnico : $($a.Tecnico)" -ForegroundColor White
    Write-Host "Serial  : $($a.Serial)" -ForegroundColor White
    Write-Host "Defeito : $($a.DefeitoRelatado)" -ForegroundColor White
    Write-Host ''
    $diag = $global:FssState.Diagnostic
    if ($diag) {
        Write-Host 'Resumo técnico' -ForegroundColor Cyan
        $diag.Summary | Format-Table Categoria,Status,Detalhe -AutoSize
    } else { Write-FssStatus 'Diagnóstico ainda não executado.' WARN }
    if ($global:FssState.Recommendations.Count -gt 0) {
        Write-Host ''
        Write-Host 'Recomendações principais' -ForegroundColor Cyan
        $global:FssState.Recommendations | ForEach-Object { Write-Host "- $_" }
    }
}
Export-ModuleMember -Function *
