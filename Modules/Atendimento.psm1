function Test-FssRegex { param([string]$Value,[string]$Pattern) return [regex]::IsMatch(($Value ?? ''),$Pattern) }
function Read-FssValidated { param([string]$Label,[string]$Pattern,[bool]$Required=$true)
    do {
        $v = Read-Host $Label
        if (-not $Required -and [string]::IsNullOrWhiteSpace($v)) { return '' }
        if (Test-FssRegex $v $Pattern) { return $v.Trim() }
        Write-Host "Valor inválido para $Label" -ForegroundColor Yellow
    } while ($true)
}
function New-FssAtendimento {
    Write-FssHeader 'Novo atendimento'
    $data = [ordered]@{}
    $data.Tecnico = Read-FssValidated 'Nome do técnico' "^[A-Za-zÀ-ÿ' -]{3,80}$"
    $data.Cliente = Read-FssValidated 'Cliente' "^[A-Za-zÀ-ÿ0-9&().,' -]{3,120}$"
    $data.Unidade = Read-FssValidated 'Unidade/local' "^[A-Za-zÀ-ÿ0-9&().,' -]{2,120}$"
    $data.Cidade = Read-FssValidated 'Cidade' "^[A-Za-zÀ-ÿ' -]{2,80}$"
    $data.Chamado = Read-FssValidated 'Número do chamado' "^(INC|SR|HD|CH)?[- ]?\d{5,12}$"
    $data.Patrimonio = Read-FssValidated 'Patrimônio' "^[A-Za-z0-9_-]{3,40}$"
    $autoSerial = try { (Get-CimInstance Win32_BIOS -ErrorAction Stop).SerialNumber } catch { '' }
    if ([string]::IsNullOrWhiteSpace($autoSerial) -or $autoSerial -match 'Default|To be filled|System Serial') {
        $data.Serial = Read-FssValidated 'Número de série' "^[A-Za-z0-9_-]{4,40}$"
    } else { $data.Serial = $autoSerial.Trim(); Write-Host "Serial detectado: $($data.Serial)" -ForegroundColor Green }
    $data.DefeitoRelatado = Read-Host 'Defeito relatado'
    $data.ObservacaoInicial = Read-Host 'Observação inicial'
    $data.DataHoraInicio = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    $data.ReportFolder = New-FssReportFolder -Chamado $data.Chamado -Serial $data.Serial
    $script:FssSession.Atendimento = [pscustomobject]$data
    Write-FssStatus "Atendimento criado em $($data.ReportFolder)" OK
    return $script:FssSession.Atendimento
}
function New-FssReportFolder { param([string]$Chamado,[string]$Serial)
    $root = Split-Path $PSScriptRoot -Parent
    $safe = (($Chamado + '-' + $Serial) -replace '[^A-Za-z0-9_-]','_')
    $dir = Join-Path $root ("Reports\{0}\{1}\{2}\{3}" -f (Get-Date -Format yyyy),(Get-Date -Format MM),(Get-Date -Format dd),$safe)
    New-Item -Path $dir -ItemType Directory -Force | Out-Null
    return $dir
}
Export-ModuleMember -Function *
