function Invoke-FssTroubleshootingFlow {
    param([string]$Defeito)
    $flow = @('Coletar inventário','Verificar desempenho','Verificar disco/SMART','Verificar drivers','Verificar rede','Conferir eventos críticos','Gerar conclusão')
    if ($Defeito -match 'internet|rede|wifi|wi-fi') { $flow = @('Adaptador ativo','IP local','Gateway','DNS','Ping externo','Driver de rede','Conclusão') }
    elseif ($Defeito -match 'bateria|carreg') { $flow = @('Carga atual','Fonte/carregador','Capacidade','Autonomia','Configuração de energia','Conclusão') }
    elseif ($Defeito -match 'lento|trav') { $flow = @('RAM','CPU','Disco/SMART','Espaço livre','Inicialização','Drivers','Conclusão') }
    $global:FssState.Troubleshooting = [pscustomobject]@{ Defeito=$Defeito; Fluxo=$flow; DataHora=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss') }
    return $global:FssState.Troubleshooting
}
Export-ModuleMember -Function *
