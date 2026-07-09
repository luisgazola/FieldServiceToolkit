function Show-FssDashboard {
    Write-FssHeader 'Dashboard do atendimento'
    $a = $script:FssSession.Atendimento
    if($a){
        Write-Host "Chamado : $($a.Chamado)" -ForegroundColor Cyan
        Write-Host "Cliente : $($a.Cliente)"
        Write-Host "Técnico : $($a.Tecnico)"
        Write-Host "Serial  : $($a.Serial)"
        Write-Host "Defeito : $($a.DefeitoRelatado)"
        Write-Host ''
    }
    if($script:FssSession.Findings){
        foreach($f in $script:FssSession.Findings){
            $level = switch($f.Status){ 'OK' {'OK'} 'Atenção' {'WARN'} 'Crítico' {'CRIT'} default {'INFO'} }
            Write-FssStatus ("{0}: {1} ({2})" -f $f.Area,$f.Status,$f.Valor) $level
        }
    } else { Write-FssStatus 'Nenhum diagnóstico executado ainda.' WARN }
    if($script:FssSession.Recommendations){
        Write-Host ''; Write-Host 'Recomendações principais:' -ForegroundColor Yellow
        $script:FssSession.Recommendations | ForEach-Object { Write-Host "- $_" }
    }
}
Export-ModuleMember -Function *
