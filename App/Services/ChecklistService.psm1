function Invoke-FssChecklist {
    Write-FssHeader 'Checklist manual'
    $items = 'Equipamento liga','Carregador testado','Tela OK','Teclado OK','Touchpad/Mouse OK','Wi-Fi OK','Áudio OK','Webcam OK','Limpeza básica realizada'
    $result = foreach ($item in $items) {
        $ans = Read-Host "$item? (s/n/na)"
        [pscustomobject]@{Item=$item; Status=$ans}
    }
    $global:FssState.Checklist = $result
    Write-FssStatus 'Checklist salvo.' OK
    return $result
}
Export-ModuleMember -Function *
