# Importando módulo
Import-Module -Name .\Wireguard.ps1

# Criando servidor
$servidor = [Server]::new("meu-servidor-wireguard.example", 51820, "wlan0")

# Criando lista de servidores DNS
$servidoresDns = @([System.Net.IPAddress]::Parse("9.9.9.9"), [System.Net.IPAddress]::Parse("149.112.112.112"), [System.Net.IPAddress]::Parse("2620:fe::fe"), [System.Net.IPAddress]::Parse("2620:fe::9"))

# Criando cliente
$meupc = [Client]::new("MeuPC", @([IpAddressInfo]::new("10.100.0.2", 32), [IpAddressInfo]::new("fd08:4711::2", 128)))

# Adicionando DNS ao cliente
$meupc.DnsServers = $servidoresDns

# Gerando arquivos de configuração do cliente
GenerateClientConfiguration -Server $servidor -Client $meupc | Out-File -FilePath 'meupc.conf'

# Gerando arquivos de configuração do servidor
GenerateServerConfiguration -Server $servidor -Clients @($meupc) | Out-File -FilePath 'servidor.conf'