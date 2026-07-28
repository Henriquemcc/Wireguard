Import-Module -Name .\Server.ps1 -Global
Import-Module -Name .\Client.ps1 -Global

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