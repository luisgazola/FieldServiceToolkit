function Invoke-FssChecklist {
    $items = 'Equipamento liga','Carregador/fonte testado','Tela ok','Teclado ok','Touchpad/mouse ok','Wi-Fi ok','USB ok','Áudio ok','Webcam ok','Limpeza básica realizada'
    $result = @()
    foreach($i in $items){ $ans = Read-Host "$i? (S/N/NA)"; $result += [pscustomobject]@{Item=$i; Status=$ans.ToUpper()} }
    $script:FssSession.Checklist = $result
    return $result
}
Export-ModuleMember -Function *
