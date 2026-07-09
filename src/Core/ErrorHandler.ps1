function Invoke-FssSafe {
    param([scriptblock]$ScriptBlock,[string]$Context='Operação')
    try { & $ScriptBlock } catch {
        Write-FssLog -Message "$Context falhou: $($_.Exception.Message)" -Level 'ERROR'
        Write-FssStatus "$Context falhou. Consulte os logs." CRIT
    }
}
