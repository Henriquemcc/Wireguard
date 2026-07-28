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