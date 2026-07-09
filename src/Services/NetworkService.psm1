function Test-FssPing { param([string]$Target) try { Test-Connection -ComputerName $Target -Count 2 -Quiet -ErrorAction Stop } catch { $false } }
function Get-FssNetworkInfo {
    try {
        $cfg = Get-NetIPConfiguration -ErrorAction Stop | Where-Object { $_.IPv4Address -and $_.NetAdapter.Status -eq 'Up' }
        $dnsOk = try { [bool](Resolve-DnsName 'microsoft.com' -ErrorAction Stop | Select-Object -First 1) } catch { $false }
        $gateway = ($cfg | Select-Object -First 1).IPv4DefaultGateway.NextHop
        [pscustomobject]@{
            AdaptadoresAtivos=$cfg | ForEach-Object { [pscustomobject]@{ Interface=$_.InterfaceAlias; IP=$_.IPv4Address.IPAddress; Gateway=$_.IPv4DefaultGateway.NextHop; DNS=($_.DNSServer.ServerAddresses -join ',') } }
            Gateway=$gateway; PingGateway=if($gateway){Test-FssPing $gateway}else{$false}; PingInternet=Test-FssPing '8.8.8.8'; DNS=$dnsOk
        }
    } catch { [pscustomobject]@{Erro=$_.Exception.Message} }
}
Export-ModuleMember -Function *
