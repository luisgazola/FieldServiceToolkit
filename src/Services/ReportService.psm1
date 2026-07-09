function ConvertTo-FssHtmlTable {
    param($Data)
    if (-not $Data) { return '<p>Não coletado.</p>' }
    return ($Data | ConvertTo-Html -Fragment | Out-String)
}
function New-FssReport {
    $a = $global:FssState.Atendimento
    if (-not $a) { Write-FssStatus 'Crie um atendimento antes de gerar relatório.' WARN; return }
    if (-not $global:FssState.Diagnostic) { Invoke-FssDiagnosticController | Out-Null }
    $folder = $a.ReportFolder
    $payload = [pscustomobject]@{
        Atendimento=$a; Inventario=$global:FssState.Inventory; Diagnostico=$global:FssState.Diagnostic
        Troubleshooting=$global:FssState.Troubleshooting; Checklist=$global:FssState.Checklist; Recomendacoes=$global:FssState.Recommendations
    }
    $json = Join-Path $folder 'relatorio.json'
    $txt = Join-Path $folder 'relatorio.txt'
    $html = Join-Path $folder 'relatorio.html'
    $payload | ConvertTo-Json -Depth 8 | Set-Content $json -Encoding UTF8
    $payload | Format-List * -Force | Out-String | Set-Content $txt -Encoding UTF8
    $style = '<style>body{font-family:Segoe UI,Arial;margin:30px;background:#f6f8fb;color:#1f2937}.card{background:white;border-radius:12px;padding:18px;margin:14px 0;box-shadow:0 2px 12px #0001}h1{color:#0f172a}.ok{color:#15803d}.warn{color:#a16207}.crit{color:#b91c1c}table{border-collapse:collapse;width:100%}td,th{border:1px solid #ddd;padding:8px}</style>'
    $summary = ConvertTo-FssHtmlTable $global:FssState.Diagnostic.Summary
    $recs = (($global:FssState.Recommendations | ForEach-Object { "<li>$_</li>" }) -join '')
    $htmlBody = @"
<html><head><meta charset='utf-8'><title>FieldServiceSuite - $($a.Chamado)</title>$style</head><body>
<h1>FieldServiceSuite - Relatório Técnico</h1>
<div class='card'><h2>Atendimento</h2><p><b>Chamado:</b> $($a.Chamado)<br><b>Cliente:</b> $($a.Cliente)<br><b>Técnico:</b> $($a.Tecnico)<br><b>Serial:</b> $($a.Serial)<br><b>Defeito:</b> $($a.DefeitoRelatado)</p></div>
<div class='card'><h2>Dashboard</h2>$summary</div>
<div class='card'><h2>Recomendações</h2><ul>$recs</ul></div>
<div class='card'><h2>Checklist</h2>$(ConvertTo-FssHtmlTable $global:FssState.Checklist)</div>
</body></html>
"@
    Set-Content $html -Value $htmlBody -Encoding UTF8
    $global:FssState.LastReportFolder = $folder
    Write-FssStatus "Relatórios gerados em $folder" OK
    return $folder
}
Export-ModuleMember -Function *
