#!/bin/bash

function_return_variable=

function obter_opcao() {
  _opcao_selecionada=-1
  re='^[0-9]+$'
  while ! [[ $_opcao_selecionada =~ $re ]] || [ $_opcao_selecionada -lt 0 ] || [ $_opcao_selecionada -gt 4 ]; do
    echo "O que deseja fazer?"
    echo "0 - Sair"
    echo "1 - Instalar Wireguard"
    echo "2 - Configurar servidor Wireguard"
    echo "3 - Gerar configuração do cliente Wireguard"
    echo "4 - Adicionar cliente ao servidor Wireguard"
    read -r _opcao_selecionada
  done

  function_return_variable="$_opcao_selecionada"
}

opcao_selecionada=-1
while [ $opcao_selecionada -ne 0 ]; do

  # Obtendo opção selecionada pelo usuário
  obter_opcao
  opcao_selecionada="$function_return_variable"

  if [ "$opcao_selecionada" -eq 1 ]; then
    bash ./Install-Wireguard.bash
  elif [ "$opcao_selecionada" -eq 2 ]; then
    bash ./Configure-Server.bash
  elif [ "$opcao_selecionada" -eq 3 ]; then
    bash ./Generate-ClientKeysAndConfiguration.bash
  elif [ "$opcao_selecionada" -eq 4 ]; then
    bash ./Add-Client.bash
  fi
done