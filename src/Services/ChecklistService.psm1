function Invoke-FssChecklist {
    <#
    .SYNOPSIS
        Executa o checklist manual de Field Service.

    .DESCRIPTION
        Exibe cada item que deve ser validado pelo técnico e aceita somente:
        S  = Sim / OK
        N  = Não / Falha
        NA = Não se aplica
    #>

    Write-FssHeader 'Checklist manual'
    Write-Host 'Responda cada item com: S = Sim/OK | N = Não/Falha | NA = Não se aplica' -ForegroundColor DarkCyan
    Write-Host ''

    $items = @(
        [pscustomobject]@{ Codigo = 'CHK-01'; Categoria = 'Energia';      Item = 'Equipamento liga normalmente';                         Orientacao = 'Validar se o equipamento inicializa sem falhas.' },
        [pscustomobject]@{ Codigo = 'CHK-02'; Categoria = 'Energia';      Item = 'Carregador/fonte testado';                              Orientacao = 'Confirmar alimentação, encaixe e funcionamento da fonte.' },
        [pscustomobject]@{ Codigo = 'CHK-03'; Categoria = 'Tela';         Item = 'Tela/imagem sem falhas visíveis';                       Orientacao = 'Verificar brilho, manchas, linhas, piscadas ou ausência de vídeo.' },
        [pscustomobject]@{ Codigo = 'CHK-04'; Categoria = 'Entrada';      Item = 'Teclado funcional';                                     Orientacao = 'Testar teclas principais, Enter, Espaço, setas e atalhos.' },
        [pscustomobject]@{ Codigo = 'CHK-05'; Categoria = 'Entrada';      Item = 'Touchpad ou mouse funcional';                           Orientacao = 'Validar clique, movimento e resposta.' },
        [pscustomobject]@{ Codigo = 'CHK-06'; Categoria = 'Rede';         Item = 'Wi-Fi ou rede cabeada funcional';                       Orientacao = 'Validar conexão local, gateway e internet quando disponível.' },
        [pscustomobject]@{ Codigo = 'CHK-07'; Categoria = 'Áudio';        Item = 'Áudio funcional';                                       Orientacao = 'Testar saída de som e dispositivo selecionado.' },
        [pscustomobject]@{ Codigo = 'CHK-08'; Categoria = 'Multimídia';   Item = 'Webcam funcional';                                      Orientacao = 'Validar detecção da câmera quando aplicável.' },
        [pscustomobject]@{ Codigo = 'CHK-09'; Categoria = 'Sistema';      Item = 'Sistema operacional inicializa e responde';             Orientacao = 'Verificar login, área de trabalho e travamentos aparentes.' },
        [pscustomobject]@{ Codigo = 'CHK-10'; Categoria = 'Finalização';  Item = 'Limpeza básica e organização realizadas';               Orientacao = 'Conferir cabos, periféricos e estado geral antes de encerrar.' }
    )

    $result = foreach ($check in $items) {
        Write-Host ('[{0}] {1}' -f $check.Codigo, $check.Item) -ForegroundColor Cyan
        Write-Host ('Categoria: {0}' -f $check.Categoria) -ForegroundColor Gray
        Write-Host ('Orientação: {0}' -f $check.Orientacao) -ForegroundColor DarkGray

        do {
            $answer = (Read-Host 'Resultado (S/N/NA)').Trim().ToUpperInvariant()
            if ($answer -notin @('S','N','NA')) {
                Write-FssStatus 'Resposta inválida. Use S, N ou NA.' WARNING
            }
        } until ($answer -in @('S','N','NA'))

        $status = switch ($answer) {
            'S'  { 'OK' }
            'N'  { 'Falha' }
            'NA' { 'Não se aplica' }
        }

        Write-Host ''
        [pscustomobject]@{
            Codigo     = $check.Codigo
            Categoria  = $check.Categoria
            Item       = $check.Item
            Orientacao = $check.Orientacao
            Status     = $status
        }
    }

    $global:FssState.Checklist = $result
    Write-FssStatus 'Checklist salvo.' OK
    return $result
}

Export-ModuleMember -Function *
