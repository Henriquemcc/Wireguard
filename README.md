# Scripts de Configuração do Wireguard

Este repositório contém os scripts em PowerShell de configuração do Wireguard que utilizo no meu servidor de Wireguard doméstico.

## Como utilizar

Na pasta deste projeto, abra o PowerShell e digite os seguintes comandos:

### 1. Importando Módulo

Para importar o módulo powershell, digite o seguinte comando:

```powershell
Import-Module -Name .\Wireguard.ps1
```

### 2. Criando Servidor

Para criar o servidor Wireguard, digite o seguinte comando, substituindo ```<VARIÁVEL-SERVIDOR>``` pelo nome da variável a armazenar o objeto servidor, ```<HOSTNAME-DO-SERVIDOR>``` pelo hostname (ou endereço IP) do servidor Wireguard, ```<PORTA-WIREGUARD>``` pelo número da porta UDP que deseja utilizar no wireguard e ```<INTERFACE-SAIDA>``` pelo nome da interface de rede de saída do Wireguard:

```powershell
$<VARIÁVEL-SERVIDOR> = [Server]::new("<HOSTNAME-DO-SERVIDOR>", <PORTA-WIREGUARD>, "<INTERFACE-SAIDA>")
```

Para informações de como identificar a interface de rede de saída, acesse: [Dúvidas: Identificando Interface de Rede de Saída](#identificando-interface-de-rede-de-saída).

Exemplo:

```powershell
$servidor = [Server]::new("meu-servidor-wireguard.example", 51820, "wlan0")
```

### 3. Criando lista de servidores DNS

Para criar a lista de servidores DNS, digite o seguinte comando, substituindo ```<VARIÁVEL-SERVIDORES-DNS>``` pelo nome da variável a guardar a lista dos servidores DNS, ```<MEU-SERVIDOR-DNS-1>``` pelo primeiro servidor DNS de sua preferência,  ```<MEU-SERVIDOR-DNS-2>``` pelo segundo servidor DNS de sua preferência, ```<MEU-SERVIDOR-DNS-1-IPV6>``` pelo endereço IPv6 do primeiro servidor DNS de sua preferência e ```<MEU-SERVIDOR-DNS-2-IPV6>``` pelo endereço IPv6 do segundo servidor DNS de sua preferência:

```powershell
$<VARIÁVEL-SERVIDORES-DNS> = @([System.Net.IPAddress]::Parse("<MEU-SERVIDOR-DNS-1>"), [System.Net.IPAddress]::Parse("<MEU-SERVIDOR-DNS-2>"), [System.Net.IPAddress]::Parse("<MEU-SERVIDOR-DNS-1-IPV6>"), [System.Net.IPAddress]::Parse("<MEU-SERVIDOR-DNS-2-IPV6>"))
```

Exemplo:

```powershell
$servidoresDns = @([System.Net.IPAddress]::Parse("9.9.9.9"), [System.Net.IPAddress]::Parse("149.112.112.112"), [System.Net.IPAddress]::Parse("2620:fe::fe"), [System.Net.IPAddress]::Parse("2620:fe::9"))
```

### 4. Criando Cliente

Para criar o primeiro cliente, digite o seguinte comando, substituindo ```<VARIÁVEL-CLIENTE>``` pelo nome da variável a armazenar o objeto cliente, ```<NOME-DO-CLIENTE>``` pelo nome que deseja adicionar ao cliente, o ```<ENDERECO-IPV4-CLIENTE>``` pelo endereço IPv4 privado desejado para o cliente, ```<MÁSCARA-ENDERECO-IPV4>``` pela máscara do endereço IPv4, ```<ENDERECO-IPV6-CLIENTE>``` pelo endereço IPv6 privado desejado para o cliente e ```<MÁSCARA-ENDERECO-IPV6>``` pela máscara do endereço IPv6:

```powershell
$<VARIÁVEL-CLIENTE> = [Client]::new("<NOME-DO-CLIENTE>", @([IpAddressInfo]::new("<ENDERECO-IPV4-CLIENTE>", <MÁSCARA-ENDERECO-IPV4>), [IpAddressInfo]::new("<ENDERECO-IPV6-CLIENTE>", <MÁSCARA-ENDERECO-IPV6>)))
```

Exemplo:

```powershell
$meupc = [Client]::new("MeuPC", @([IpAddressInfo]::new("10.100.0.2", 32), [IpAddressInfo]::new("fd08:4711::2", 128)))
```

### 5. Adicionando DNS ao Cliente

Com o cliente criado, agora é hora de adicionar o servidor DNS ao cliente. Para isso, basta adicionar a variável utilizada na criação da lista dos servidores DNS para o parâmetro ```DnsServers``` da instância de ```Client```.

Exemplo:

```powershell
$meupc.DnsServers = $servidoresDns
```

### 6. Gerando arquivo de configuração do Cliente

Após criar os objetos Servidor e Cliente, e adicinar ao cliente os servidores DNS, basta gerar os arquivo de configuração do Wireguard:

Para isso execute o seguinte comando, substituindo ```<VARIÁVEL-CLIENTE>``` pelo nome da variável que armazena o objeto cliente, ```<VARIÁVEL-SERVIDOR>``` pelo nome da variável que armazena o objeto servidor e ```<NOME-ARQUIVO-CONFIGURAÇÃO-CLIENTE>``` pelo nome do arquivo de configuração do cliente (terminando com a extensão '.conf').

```powershell
GenerateClientConfiguration -Server $<VARIÁVEL-SERVIDOR> -Client $<VARIÁVEL-CLIENTE> | Out-File -FilePath '<NOME-ARQUIVO-CONFIGURAÇÃO-CLIENTE>'
```

Exemplo:

```powershell
GenerateClientConfiguration -Server $servidor -Client $meupc | Out-File -FilePath 'meupc.conf'
```

### 7. Gerando arquivo de configuração do Servidor

E finalmente só falta gerar o arquivo de configuração do servidor. Para isso, execute o seguinte comando, substituindo ```<VARIÁVEL-SERVIDOR>``` pela variável que armazena o objeto servidor, ```<VARIÁVEL-CLIENTE>``` pela variável que armazena o objeto cliente e ```<NOME-ARQUIVO-CONFIGURAÇÃO-SERVIDOR>``` pelo nome do arquivo de configuração do servidor (terminando com a extensão '.conf').

```powershell
GenerateServerConfiguration -Server $<VARIÁVEL-SERVIDOR> -Clients @($<VARIÁVEL-CLIENTE>) | Out-File -FilePath '<NOME-ARQUIVO-CONFIGURAÇÃO-SERVIDOR>'
```

Exemplo:

```powershell
GenerateServerConfiguration -Server $servidor -Clients @($meupc) | Out-File -FilePath 'servidor.conf'
```

### 8. Adicionar arquivos ao servidor e ao cliente

Após os arquivos de configuração do cliente e do servidor serem gerados, resta apenas copiá-los para os seus respectivos lugares e configurar o Wireguard para utilizá-los.

#### Servidor

Copie o arquivo de configuração gerado para o servidor para dentro da pasta ```/etc/wireguard```.

Exemplo:

```shell
sudo cp ./servidor.conf /etc/wireguard/servidor.conf
```

#### Cliente

Copie o arquivo de configuração gerado para o cliente para dentro da pasta ```/etc/wireguard```.

Exemplo:

```shell
sudo cp ./meupc.conf /etc/wireguard/meupc.conf
```

### 9. Ative o Wireguard

#### Servidor

Execute o seguinte comando, substituindo ```<NOME-ARQUIVO-CONFIGURAÇÃO-SERVIDOR>``` pelo nome do arquivo de configuração do servidor gerado:

```shell
sudo wg-quick up /etc/wireguard/<NOME-ARQUIVO-CONFIGURAÇÃO-SERVIDOR>```
```

Exemplo:

```shell
sudo wg-quick up /etc/wireguard/servidor.conf```
```

#### Cliente

Execute o seguinte comando, substituindo ```<NOME-ARQUIVO-CONFIGURAÇÃO-CLIENTE>``` pelo nome do arquivo de configuração do cliente gerado:

```shell
sudo wg-quick up /etc/wireguard/<NOME-ARQUIVO-CONFIGURAÇÃO-CLIENTE>```
```

Exemplo:

```shell
sudo wg-quick up /etc/wireguard/meupc.conf```
```

### 10. Habilitando o encaminhamento de pacotes IP no Servidor

Para habilitar o encaminhamento de pacotes IP no servidor, no servidor, em um Terminal, como root, digite o seguinte comando:

```shell
if ! grep -q "net.ipv4.ip_forward=1" "/etc/sysctl.conf"; then
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
fi
if ! grep -q "net.ipv6.conf.all.forwarding=1" "/etc/sysctl.conf"; then
  echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
fi
sysctl -p
```

### Dúvidas Frequentes

#### Identificando Interface de Rede de Saída

Para saber a interface de saída, no Linux no terminal, digite o seguinte comando:

```shell
ip addr show
```

E serão mostrados os nomes das interfaces de rede de sua máquina em uma saída parecida com esta:

```
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp130s0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc fq_codel state DOWN group default qlen 1000
    link/ether <ENDEREÇO-MAC-OCULTADO> brd ff:ff:ff:ff:ff:ff
    altname enx10ffe0bd2776
3: wlp128s20f3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether <ENDEREÇO-MAC-OCULTADO> brd ff:ff:ff:ff:ff:ff permaddr <ENDEREÇO-MAC-OCULTADO>
    altname wlxe41fd550d0cf
    inet <ENDEREÇO-IPV4-OCULTADO> brd <ENDEREÇO-IPV4-OCULTADO> scope global dynamic noprefixroute wlp128s20f3
       valid_lft 5462sec preferred_lft 5462sec
    inet6 <ENDEREÇO-IPV6-OCULTADO> scope global dynamic noprefixroute 
       valid_lft 297sec preferred_lft 297sec
    inet6 <ENDEREÇO-IPV6-OCULTADO> scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: br-785bc2917166: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether <ENDEREÇO-MAC-OCULTADO> brd ff:ff:ff:ff:ff:ff
    inet <ENDEREÇO-IPV4-OCULTADO> brd <ENDEREÇO-IPV4-OCULTADO> scope global br-785bc2917166
       valid_lft forever preferred_lft forever
6: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether <ENDEREÇO-MAC-OCULTADO> brd ff:ff:ff:ff:ff:ff
    inet <ENDEREÇO-IPV4-OCULTADO> brd <ENDEREÇO-IPV4-OCULTADO> scope global docker0
       valid_lft forever preferred_lft foreve
```