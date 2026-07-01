function Test-FstNetwork {
    [CmdletBinding()]
    param()

    $ipConfig = Get-NetIPConfiguration | Where-Object IPv4Address
    $dns = Get-DnsClientServerAddress -AddressFamily IPv4 | Where-Object ServerAddresses

    $gatewayIp = $ipConfig |
        Where-Object IPv4DefaultGateway |
        Select-Object -First 1 -ExpandProperty IPv4DefaultGateway |
        Select-Object -ExpandProperty NextHop

    $dnsServer = $dns |
        Select-Object -First 1 -ExpandProperty ServerAddresses |
        Select-Object -First 1

    $gatewayTest = if ($gatewayIp -match '^\d{1,3}(\.\d{1,3}){3}$') {
        Test-Connection -ComputerName $gatewayIp -Count 2 -Quiet
    } else {
        $false
    }

    $dnsTest = if ($dnsServer -match '^\d{1,3}(\.\d{1,3}){3}$') {
        Test-Connection -ComputerName $dnsServer -Count 2 -Quiet
    } else {
        $false
    }

    $internetTest = Test-Connection -ComputerName "1.1.1.1" -Count 2 -Quiet

    [pscustomobject]@{
        ActiveAdapters = Get-NetAdapter | Where-Object Status -eq "Up" | ForEach-Object {
            "$($_.Name) - $($_.InterfaceDescription) - $($_.LinkSpeed)"
        }
        Gateway      = $gatewayIp
        DnsServer    = $dnsServer
        GatewayPing  = $gatewayTest
        DnsPing      = $dnsTest
        InternetPing = $internetTest
        Note         = "Teste informativo. Não altera IP, DNS, proxy, VPN, firewall ou políticas."
        Suggestion   = if (-not $gatewayTest) {
            "Verificar cabo, Wi-Fi, VLAN, DHCP ou política local."
        } elseif (-not $dnsTest) {
            "Gateway responde, mas DNS não respondeu. Validar DNS corporativo."
        } elseif (-not $internetTest) {
            "Rede local responde, mas internet não. Validar proxy, VPN ou firewall."
        } else {
            "Conectividade básica funcional."
        }
    }
}

Export-ModuleMember -Function Test-FstNetwork