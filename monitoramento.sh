#!/bin/bash
#
################################################################################
# Script para monitoramento de recursos de memória, processamento e conexões.
# Testado no sistema operacional: Debian da versão 8.8.0
#
# Escrito por: Henrique Lima Alves Braz
#
################################################################################

geraLog(){
  # coleta informacao de data e hora para log de execução do script
Data=$(date +%d/%m/%Y)
Hora=$(date +%H:%M)
TIMESTAMP="em $Data as $Thora"
echo "Usuário $USER acessou iniciou o Script de monitoramento $TIMESTAMP" >> logmonitoramento$Data.txt
}
#
#
verificaPermissao(){
# verificação de usuário através de stderr
  if [ "$USER" != "root" ]
  then
    echo "Usuário não possui permissão para executar este script"
    echo "Script será encerrado."
    wait 2
    exit 1
  else
  	echo "Permissão de execução verificada, você será direcionado ao menu principal"
    wait 2
    menuPincipal
  fi
menuPincipal
}
#
#
exibeConexao(){
  # Variaveis com arquivos auiliares.
  clear
    netstat -tnap | tee conexao.txt
    echo conexao.txt
    rm conexao.txt
    read -p "Deseja encerrar alguma conexão? [s/n] " Resposta
  case $Resposta in
    s) corteCoenexao;;
    n) menuPincipal;;
    *) echo "Opção não existente, tente novamente!"; exibeCoenexao;
esac
}
#
#
corteCoenexao(){
  echo "Informe o endereço IP que devera ter a conexão encerrada."
  read -p "Formato do IPv4 0.0.0.0 :" EndIP

  echo "Informe a porta utilizada nesta conexão"
  read -p "numero exibido após ':' " Porta


    cutter $EndIP $Porta
    echo "Conexão encerrada !"
    read -p "Precione qualquer tecla para retornar ao menu principal." selecao
    case $selecao in
      *) menuPincipal ;;
    esac

}
#
#
#
exibeMemoria(){
  # gera arquivo auxiliar com informação sobre a memória em uso.

    echo "Serão exibidos valores legiveis em linguagem humana."
    free -mh | tee memoria.txt
  # deleta arquivo auxiliar
    rm memoria.txt
    read -p "Precione qualquer tecla para retornar ao menu principal." selecao
    case $selecao in
      *) menuPincipal ;;
    esac
}
#
#
exibeProcessamento(){
  # Coloca o valor total do uso de cpu em arquivo auxiliar.
  echo "Porcentagem de capacidade de processamento em uso"
    top -bn 1 | grep Cpu | gawk '{print$$2+$4+$6}' | tee cputotal.txt
    CpuUso=$(cat cputotal.txt)
    echo "A utilização de processamento esta em $CpuUso por cento."
    rm cputotal.txt
    read -p "Precione qualquer tecla para retornar ao menu principal." selecao
    case $selecao in
      *) menuPincipal ;;
    esac
  # deleta arquivo auxiliar que foi gerado.

#
    menuPincipal
}
#
#
menuPincipal(){
  clear
echo "+++++++++++++++++++++++++++++++++++++++++++++"
echo "Menu Principal"
echo "1 Memória RAM em uso"
echo "2 Verificar conexões "
echo "3 Processamento "
echo "4 Sair do Script"
echo "+++++++++++++++++++++++++++++++++++++++++++++"
read -p "Por favor, forneça uma opção [1-4]" selecao
case $selecao in
  1)  exibeMemoria ;;
  2)  exibeConexao ;;
  3)  exibeProcessamento ;;
  4)  exit ;;
  *) echo "Opção inexistente, digite novamente. " ; menuPincipal;
esac

}
#
#
geraLog
verificaPermissao
#fim do Script de monitoramento.
