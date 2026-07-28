class IpAddressInfo {
    [System.Net.IPAddress]$IpAddress
    [System.UInt16]$Prefix

    IpAddressInfo([System.Net.IPAddress]$IpAddress, [System.UInt16]$Prefix) {
        $this.IpAddress = $IpAddress
        $this.Prefix = $Prefix
    }

    IpAddressInfo([System.String]$IpAddress, [System.UInt16]$Prefix) {
        $this.IpAddress = [System.Net.IPAddress]::Parse($IpAddress)
        $this.Prefix = $Prefix
    }

    [System.String]ToString() {
        return "$($this.IpAddress)/$($this.Prefix)"
    }

    [IpAddressInfo] Clone() {
        $clonedIpAddress = [System.Net.IPAddress]::Parse($this.IpAddress.ToString())
        return [IpAddressInfo]::new($clonedIpAddress, $this.Prefix)
    }
}

class Server {
    [System.Collections.Generic.List[IpAddressInfo]]$Address
    [System.String]$Endpoint
    [System.UInt16]$Port
    [System.String]$OutputInterfaceName
    [System.String]$PrivateKey

    Server([System.Collections.Generic.List[IpAddressInfo]]$Address, [System.String]$Endpoint, [System.UInt16]$Port, [System.String]$OutputInterfaceName, [System.String]$PrivateKey) {
        $this.Address = $Address
        $this.Endpoint = $Endpoint
        $this.Port = $Port
        $this.OutputInterfaceName = $OutputInterfaceName
        $this.PrivateKey = $PrivateKey
    }

    Server([System.String]$Endpoint, [System.String]$OutputInterfaceName) {
        $this.Address = @([IpAddressInfo]::new("10.100.0.1", 24), [IpAddressInfo]::new("fd08:4711::1", 64))
        $this.Endpoint = $Endpoint
        $this.Port = 51820
        $this.OutputInterfaceName = $OutputInterfaceName
        $this.PrivateKey = GeneratePrivateKey
    }

    Server([System.String]$Endpoint, [System.UInt16]$Port, [System.String]$OutputInterfaceName) {
        $this.Address = @([IpAddressInfo]::new("10.100.0.1", 24), [IpAddressInfo]::new("fd08:4711::1", 64))
        $this.Endpoint = $Endpoint
        $this.Port = $Port
        $this.OutputInterfaceName = $OutputInterfaceName
        $this.PrivateKey = GeneratePrivateKey
    }

    [Server]Clone() {
        $clonedAddress = [System.Collections.ArrayList]::new()
        foreach ($address in $this.Address) {
            [void]$clonedAddress.Add($address.Clone())
        }
        return [Server]::new($clonedAddress, $this.Endpoint.Clone(), $this.Port, $this.OutputInterfaceName.Clone(), $this.PrivateKey.Clone())
    }

    [System.String] GetPublicKey() {
        return GeneratePublicKey -PrivateKey ($this.PrivateKey)
    }

}

class Client {
    [System.String]$Name
    [System.Collections.Generic.List[IpAddressInfo]]$Address
    [System.String]$PrivateKey
    [System.String]$PresharedKey
    [System.Collections.Generic.List[System.Net.IPAddress]]$DnsServers
    [System.Collections.Generic.List[IpAddressInfo]]$AllowedIps

    Client([System.String]$Name) {

        $this.PrivateKey = GeneratePrivateKey
        $this.PresharedKey = GeneratePresharedKey
        $this.DnsServers = @([System.Net.IPAddress]::Parse("9.9.9.9"), [System.Net.IPAddress]::Parse("149.112.112.112"),[System.Net.IPAddress]::Parse("2620:fe::fe"),[System.Net.IPAddress]::Parse("2620:fe::9"),[System.Net.IPAddress]::Parse("1.1.1.2"),[System.Net.IPAddress]::Parse("1.0.0.2"),[System.Net.IPAddress]::Parse("2606:4700:4700::1112"),[System.Net.IPAddress]::Parse("2606:4700:4700::1002"),[System.Net.IPAddress]::Parse("8.8.8.8"),[System.Net.IPAddress]::Parse("8.8.4.4"),[System.Net.IPAddress]::Parse("2001:4860:4860::8888"),[System.Net.IPAddress]::Parse("2001:4860:4860::8844"))
        $this.AllowedIps = @([IpAddressInfo]::new("0.0.0.0", 0), [IpAddressInfo]::new("::", 0))
        $this.Name = $Name
        $this.Address = $null
    }

    Client([System.String]$Name, [System.Collections.Generic.List[IpAddressInfo]]$Address) {

        $this.PrivateKey = GeneratePrivateKey
        $this.PresharedKey = GeneratePresharedKey
        $this.DnsServers = @([System.Net.IPAddress]::Parse("9.9.9.9"), [System.Net.IPAddress]::Parse("149.112.112.112"),[System.Net.IPAddress]::Parse("2620:fe::fe"),[System.Net.IPAddress]::Parse("2620:fe::9"),[System.Net.IPAddress]::Parse("1.1.1.2"),[System.Net.IPAddress]::Parse("1.0.0.2"),[System.Net.IPAddress]::Parse("2606:4700:4700::1112"),[System.Net.IPAddress]::Parse("2606:4700:4700::1002"),[System.Net.IPAddress]::Parse("8.8.8.8"),[System.Net.IPAddress]::Parse("8.8.4.4"),[System.Net.IPAddress]::Parse("2001:4860:4860::8888"),[System.Net.IPAddress]::Parse("2001:4860:4860::8844"))
        $this.AllowedIps = @([IpAddressInfo]::new("0.0.0.0", 0), [IpAddressInfo]::new("::", 0))
        $this.Name = $Name
        $this.Address = $Address
    }

    Client(
        [System.String]$Name, [System.Collections.Generic.List[IpAddressInfo]]$Address, [System.String]$PrivateKey, [System.String]$PresharedKey, [System.Collections.Generic.List[System.Net.IPAddress]]$DnsServers, [System.Collections.Generic.List[IpAddressInfo]]$AllowedIps) {
        $this.Name = $Name
        $this.Address = $Address
        $this.PrivateKey = $PrivateKey
        $this.PresharedKey = $PresharedKey
        $this.DnsServers = $DnsServers
        $this.AllowedIps = $AllowedIps
    }

    [Client]Clone() {
        $clonedAddress = [System.Collections.Generic.List[IpAddressInfo]]::new()
        foreach ($address in $this.Address) {
            [void]$clonedAddress.Add($address.Clone())
        }

        $clonedDnsServers = [System.Collections.Generic.List[System.Net.IPAddress]]::new()
        foreach ($dnsServer in $this.DnsServers) {
            [void]$clonedDnsServers.Add([System.Net.IPAddress]::Parse($dnsServer.ToString()))
        }

        $clonedAllowedIps = [System.Collections.Generic.List[IpAddressInfo]]::new()
        foreach ($allowedIp in $this.AllowedIps) {
            [void]$clonedAllowedIps.Add($allowedIp.Clone())
        }

        return [Client]::new($this.Name.Clone(), $clonedAddress, $this.PrivateKey.Clone(), $this.PresharedKey.Clone(), $clonedDnsServers, $clonedAllowedIps)
    }

    [System.String] GetPublicKey() {
        return GeneratePublicKey -PrivateKey ($this.PrivateKey)
    }
}

function GeneratePrivateKey() {
    return $(wg genkey)
}

function GeneratePublicKey([System.String]$PrivateKey) {
    return $($PrivateKey | wg pubkey)
}

function GeneratePresharedKey() {
    return $(wg genpsk)
}

function GenerateServerConfiguration([Server]$Server, [System.Collections.Generic.List[Client]]$Clients) {
    $stringBuilder = [System.Text.StringBuilder]::new()

    [void]$stringBuilder.AppendLine("[Interface]")

    if ($null -ne $Server.Address -and $Server.Address.Count -gt 0) {
        [void]$stringBuilder.AppendLine("Address = $($Server.Address -join ", ")")
    }
    
    if ($null -ne $Server.Port) {
        [void]$stringBuilder.AppendLine("ListenPort = $($Server.Port)")
    }
    
    if ($null -ne $Server.OutputInterfaceName -and $Server.OutputInterfaceName.Length -gt 0) {
        [void]$stringBuilder.AppendLine("PostUp = iptables -w -t nat -A POSTROUTING -o $($Server.OutputInterfaceName) -j MASQUERADE; ip6tables -w -t nat -A POSTROUTING -o $($Server.OutputInterfaceName) -j MASQUERADE")
        [void]$stringBuilder.AppendLine("PostDown = iptables -w -t nat -D POSTROUTING -o $($Server.OutputInterfaceName) -j MASQUERADE; ip6tables -w -t nat -D POSTROUTING -o $($Server.OutputInterfaceName) -j MASQUERADE")
    }

    if ($null -ne $Server.PrivateKey -and $Server.PrivateKey.Length -gt 0) {
        [void]$stringBuilder.AppendLine("PrivateKey = $($Server.PrivateKey.ToString())")    
    }
    
    [void]$stringBuilder.AppendLine()

    foreach ($client in $Clients) {
        [void]$stringBuilder.AppendLine("[Peer]")

        if ($null -ne $client.Name -and $client.Name.Length -gt 0) {
            [void]$stringBuilder.AppendLine("# Name = $($client.Name)")    
        }

        $publicKey = $client.GetPublicKey()
        if ($null -ne $publicKey -and $publicKey.Length -gt 0) {
            [void]$stringBuilder.AppendLine("PublicKey = $($publicKey)")
        }
        
        if ($null -ne $client.PresharedKey -and $client.PresharedKey.Length -gt 0) {
            [void]$stringBuilder.AppendLine("PresharedKey = $($client.PresharedKey)")
        }

        if ($null -ne $client.Address -and $client.Address.Count -gt 0) {
            [void]$stringBuilder.AppendLine("AllowedIPs = $($client.Address -join ", ")")    
        }

        [void]$stringBuilder.AppendLine()
    }

    return $stringBuilder.ToString()
}

function GenerateClientConfiguration([Server]$Server, [Client]$Client) {
    $stringBuilder = [System.Text.StringBuilder]::new()

    [void]$stringBuilder.AppendLine("[Interface]")
    
    if ($null -ne $Client.Name -and $Client.Name.Length -gt 0) {
        [void]$stringBuilder.AppendLine("# Name = $($Client.Name)")
    }

    if ($null -ne $Client.Address -and $Client.Address.Count -gt 0) {
        [void]$stringBuilder.AppendLine("Address = $($Client.Address -join ", ")")
    }

    if ($null -ne $Client.DnsServers -and $Client.DnsServers.Count -gt 0) {
        [void]$stringBuilder.AppendLine("DNS = $($Client.DnsServers -join ", ")")
    }

    if ($null -ne $Client.PrivateKey -and $Client.PrivateKey.Length -gt 0) {
        [void]$stringBuilder.AppendLine("PrivateKey = $($Client.PrivateKey)")
    }

    [void]$stringBuilder.AppendLine()


    [void]$stringBuilder.AppendLine("[Peer]")

    if ($null -ne $Client.AllowedIps -and $Client.AllowedIps.Count -gt 0) {
        [void]$stringBuilder.AppendLine("AllowedIPs = $($Client.AllowedIps -join ", ")")
    }

    if ($null -ne $Server.Port -and $null -ne $Server.Endpoint -and $Server.Endpoint.Length -gt 0) {
        [void]$stringBuilder.AppendLine("Endpoint = $($Server.Endpoint):$($Server.Port)")
    }

    $publicKey = $Server.GetPublicKey()
    if ($null -ne $publicKey -and $publicKey.Length -gt 0) {
        [void]$stringBuilder.AppendLine("PublicKey = $($publicKey)")
    }

    if ($null -ne $Client.PresharedKey -and $Client.PresharedKey.Length -gt 0) {
        [void]$stringBuilder.AppendLine("PresharedKey = $($Client.PresharedKey)")
    }

    return $stringBuilder.ToString()
}