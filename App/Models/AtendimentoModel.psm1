function New-FssAtendimentoModel {
    param($Tecnico,$Cliente,$Unidade,$Cidade,$Chamado,$Patrimonio,$Serial,$DefeitoRelatado,$ObservacaoInicial,$ReportFolder)
    [pscustomobject][ordered]@{
        Tecnico=$Tecnico; Cliente=$Cliente; Unidade=$Unidade; Cidade=$Cidade; Chamado=$Chamado
        Patrimonio=$Patrimonio; Serial=$Serial; DefeitoRelatado=$DefeitoRelatado
        ObservacaoInicial=$ObservacaoInicial; DataHoraInicio=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
        ReportFolder=$ReportFolder
    }
}
Export-ModuleMember -Function *
