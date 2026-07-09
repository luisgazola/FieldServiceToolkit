function Test-FssAtendimentoData {
    param($Atendimento)
    if(-not $Atendimento){ return $false }
    return ($Atendimento.Tecnico -and $Atendimento.Chamado -and $Atendimento.Cliente -and $Atendimento.Serial)
}
Export-ModuleMember -Function *
