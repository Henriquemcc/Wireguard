Import-Module -Name .\IpAddressInfo.ps1 -Global

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