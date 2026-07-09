function ConvertTo-FssHtmlSection { param([string]$Title,[object]$Data)
    $pre = ($Data | ConvertTo-Json -Depth 8 | Out-String)
    return "<section><h2>$Title</h2><pre>$([System.Web.HttpUtility]::HtmlEncode($pre))</pre></section>"
}
function New-FssReport {
    if(-not $script:FssSession.Atendimento){ Write-FssStatus 'Crie um atendimento antes de gerar relatório.' WARN; return }
    $folder = $script:FssSession.Atendimento.ReportFolder
    New-Item -Path $folder -ItemType Directory -Force | Out-Null
    $base = Join-Path $folder 'FieldServiceReport'
    $jsonPath = "$base.json"; $txtPath = "$base.txt"; $htmlPath = "$base.html"
    $payload = [ordered]@{
        Atendimento=$script:FssSession.Atendimento
        Inventario=$script:FssSession.Inventory
        Diagnostico=$script:FssSession.Diagnostic
        Findings=$script:FssSession.Findings
        Troubleshooting=$script:FssSession.Troubleshooting
        Checklist=$script:FssSession.Checklist
        Recomendacoes=$script:FssSession.Recommendations
        GeradoEm=(Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    }
    $payload | ConvertTo-Json -Depth 12 | Set-Content $jsonPath -Encoding UTF8
    $txt = @"
FIELDSERVICESUITE - RELATÓRIO TÉCNICO
Chamado: $($script:FssSession.Atendimento.Chamado)
Cliente: $($script:FssSession.Atendimento.Cliente)
Técnico: $($script:FssSession.Atendimento.Tecnico)
Serial: $($script:FssSession.Atendimento.Serial)
Defeito: $($script:FssSession.Atendimento.DefeitoRelatado)
Gerado em: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

=== ACHADOS ===
$($script:FssSession.Findings | Format-Table | Out-String)

=== RECOMENDAÇÕES ===
$($script:FssSession.Recommendations | ForEach-Object { '- ' + $_ } | Out-String)

=== CHECKLIST ===
$($script:FssSession.Checklist | Format-Table | Out-String)
"@
    $txt | Set-Content $txtPath -Encoding UTF8
    Add-Type -AssemblyName System.Web -ErrorAction SilentlyContinue
    $sections = ''
    foreach($k in $payload.Keys){ $sections += ConvertTo-FssHtmlSection $k $payload[$k] }
    $html = @"
<!DOCTYPE html><html lang="pt-BR"><head><meta charset="utf-8"><title>FieldServiceSuite</title>
<style>
body{font-family:Segoe UI,Arial,sans-serif;background:#0f172a;color:#e5e7eb;margin:0;padding:24px}.wrap{max-width:1100px;margin:auto}.hero{background:linear-gradient(135deg,#0ea5e9,#334155);padding:24px;border-radius:18px;margin-bottom:18px}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(210px,1fr));gap:12px}.card,section{background:#111827;border:1px solid #334155;border-radius:14px;padding:16px;margin:12px 0}h1,h2{margin-top:0}.muted{color:#cbd5e1}pre{white-space:pre-wrap;word-break:break-word;background:#020617;padding:12px;border-radius:10px}.ok{color:#22c55e}.warn{color:#facc15}.crit{color:#fb7185}
</style></head><body><div class="wrap"><div class="hero"><h1>FieldServiceSuite - Relatório Técnico</h1><p class="muted">Chamado $($script:FssSession.Atendimento.Chamado) • Serial $($script:FssSession.Atendimento.Serial)</p></div>
<div class="grid"><div class="card"><b>Cliente</b><br>$($script:FssSession.Atendimento.Cliente)</div><div class="card"><b>Técnico</b><br>$($script:FssSession.Atendimento.Tecnico)</div><div class="card"><b>Defeito</b><br>$($script:FssSession.Atendimento.DefeitoRelatado)</div></div>
$sections</div></body></html>
"@
    $html | Set-Content $htmlPath -Encoding UTF8
    Write-FssStatus "Relatórios gerados em $folder" OK
    return [pscustomobject]@{Html=$htmlPath;Txt=$txtPath;Json=$jsonPath}
}
Export-ModuleMember -Function *
