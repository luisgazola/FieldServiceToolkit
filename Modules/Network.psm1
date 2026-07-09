function Test-FssPing { param([string]$Target)
    try { $r=Test-Connection -ComputerName $Target -Count 2 -ErrorAction Stop; [math]::Round(($r | Measure-Object ResponseTime -Average).Average,2) } catch { $null }
}
function Get-FssNetworkInfo {
    try {
        $cfg = Get-NetIPConfiguration | Where-Object {$_.IPv4Address -and $_.NetAdapter.Status -eq 'Up'} | Select-Object -First 1
        $gw = $cfg.IPv4DefaultGateway.NextHop
        $gatewayMs = if($gw){ Test-FssPing $gw } else { $null }
        $internetMs = Test-FssPing '8.8.8.8'
        $dnsOk = try { Resolve-DnsName 'microsoft.com' -ErrorAction Stop | Out-Null; $true } catch { $false }
        [pscustomobject]@{ Adapter=$cfg.InterfaceAlias; IPv4=$cfg.IPv4Address.IPAddress; Gateway=$gw; DnsServers=($cfg.DNSServer.ServerAddresses -join ', '); GatewayLatencyMs=$gatewayMs; InternetLatencyMs=$internetMs; DnsOk=$dnsOk }
    } catch { Write-FssLog "Network falhou: $_" 'ERROR'; [pscustomobject]@{Erro=$_.Exception.Message} }
}
Export-ModuleMember -Function *
