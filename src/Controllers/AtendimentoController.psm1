function Invoke-FssAtendimentoController {
    Write-FssHeader 'Novo atendimento'
    $tecnico = Read-FssValidated 'Nome do técnico' "^[A-Za-zÀ-ÿ' -]{3,80}$"
    $cliente = Read-FssValidated 'Cliente' "^[A-Za-zÀ-ÿ0-9&().,' -]{3,120}$"
    $unidade = Read-FssValidated 'Unidade/local' "^[A-Za-zÀ-ÿ0-9&().,' -]{2,120}$"
    $cidade = Read-FssValidated 'Cidade' "^[A-Za-zÀ-ÿ' -]{2,80}$"
    $chamado = Read-FssValidated 'Número do chamado' "^(INC|SR|HD|CH)?[- ]?\d{5,12}$"
    $patrimonio = Read-FssValidated 'Patrimônio' "^[A-Za-z0-9_-]{3,40}$"
    $autoSerial = try { (Get-CimInstance Win32_BIOS -ErrorAction Stop).SerialNumber } catch { '' }
    if ([string]::IsNullOrWhiteSpace($autoSerial) -or $autoSerial -match 'Default|To be filled|System Serial') {
        $serial = Read-FssValidated 'Número de série' "^[A-Za-z0-9_-]{4,40}$"
    } else { $serial = $autoSerial.Trim(); Write-FssStatus "Serial detectado: $serial" OK }
    $defeito = Read-Host 'Defeito relatado'
    $obs = Read-Host 'Observação inicial'
    $folder = New-FssReportFolder -RootPath $global:FssState.RootPath -Chamado $chamado -Serial $serial
    $global:FssState.Atendimento = New-FssAtendimentoModel -Tecnico $tecnico -Cliente $cliente -Unidade $unidade -Cidade $cidade -Chamado $chamado -Patrimonio $patrimonio -Serial $serial -DefeitoRelatado $defeito -ObservacaoInicial $obs -ReportFolder $folder
    Write-FssStatus "Atendimento criado em $folder" OK
    Write-FssLog "Atendimento criado: $chamado" 'INFO'
    return $global:FssState.Atendimento
}
Export-ModuleMember -Function *
