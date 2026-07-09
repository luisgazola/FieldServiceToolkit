function Get-FssConfig {
    param([string]$RootPath)
    $config = [ordered]@{}
    foreach ($file in @('Reference.json','TroubleshootingFlows.json','RecommendedActions.json')) {
        $path = Join-Path $RootPath "Config\$file"
        if (Test-Path $path) {
            $name = [IO.Path]::GetFileNameWithoutExtension($file)
            $config[$name] = Get-Content $path -Raw | ConvertFrom-Json
        }
    }
    return [pscustomobject]$config
}
Export-ModuleMember -Function *
