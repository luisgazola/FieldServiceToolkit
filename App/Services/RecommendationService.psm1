function Get-FssRecommendations {
    param($Diagnostic,$Atendimento)
    $r = New-Object System.Collections.Generic.List[string]
    foreach ($s in @($Diagnostic.Summary)) {
        if ($s.Categoria -eq 'RAM' -and $s.Status -in @('Atenção','Crítico')) { $r.Add('RAM alta: verificar processos de inicialização, navegador, antivírus e considerar upgrade quando aplicável.') }
        if ($s.Categoria -eq 'CPU' -and $s.Status -in @('Atenção','Crítico')) { $r.Add('CPU alta: identificar processo consumidor, validar temperatura e reiniciar serviços quando autorizado.') }
        if ($s.Categoria -eq 'Drivers' -and $s.Status -ne 'OK') { $r.Add('Drivers com erro: coletar Hardware ID e reinstalar driver pelo fabricante ou imagem corporativa.') }
        if ($s.Categoria -eq 'Rede' -and $s.Status -ne 'OK') { $r.Add('Rede com falha: validar IP, gateway, DNS, cabo/Wi-Fi e política local antes de alterar configuração.') }
        if ($s.Categoria -eq 'Disco/SMART' -and $s.Status -ne 'OK') { $r.Add('Disco com alerta: orientar backup, registrar evidência e recomendar substituição.') }
    }
    if ($Atendimento -and $Atendimento.DefeitoRelatado -match 'lento|trav') { $r.Add('Defeito relatado indica lentidão/travamento: priorizar RAM, CPU, disco, inicialização e eventos críticos.') }
    return $r.ToArray() | Select-Object -Unique
}
Export-ModuleMember -Function *
