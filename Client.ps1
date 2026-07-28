Import-Module -Name .\IpAddressInfo.ps1 -Global

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