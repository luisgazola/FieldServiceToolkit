function Invoke-FssTroubleshooting {
    Write-FssHeader 'Troubleshooting guiado'
    $flows = Get-Content (Join-Path (Split-Path $PSScriptRoot -Parent) 'Config\TroubleshootingFlows.json') -Raw | ConvertFrom-Json
    $defeito = if($script:FssSession.Atendimento){ $script:FssSession.Atendimento.DefeitoRelatado } else { Read-Host 'Defeito relatado' }
    $key = ($flows.PSObject.Properties.Name | Where-Object { $defeito.ToLower() -like "*$_*" } | Select-Object -First 1)
    if(-not $key){ $key = 'lento' }
    Write-Host "Defeito: $defeito" -ForegroundColor Cyan
    Write-Host 'Fluxo sugerido:' -ForegroundColor Yellow
    $steps = $flows.$key
    $n=1; foreach($s in $steps){ Write-Host "$n. $s"; $n++ }
    $script:FssSession.Troubleshooting = [pscustomobject]@{ Defeito=$defeito; Fluxo=$steps; Base=$key }
    return $script:FssSession.Troubleshooting
}
Export-ModuleMember -Function *
