#!/bin/bash
# startup_scripts/start_app.sh

# Verifica se o Hostname foi passado pelo Docker Compose (para robustez)
if [ -z "$ZABBIX_HOSTNAME" ]; then
    echo "ERRO: Variavel ZABBIX_HOSTNAME nao definida."
else
    # Configura o Hostname no arquivo de configuracao injetado
    sed -i "s/^Hostname=.*$/Hostname=$ZABBIX_HOSTNAME/" /etc/zabbix/zabbix_agentd.conf
    echo "Zabbix Hostname configurado como: $ZABBIX_HOSTNAME"
fi

# Inicia o Zabbix Agent em background
echo ">>> Iniciando Zabbix Agent..."
/usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf

# Inicia a aplicação principal e mantem o container vivo.
# **SUBSTITUA** o 'tail -f' pelo comando que inicia sua aplicacao real.
echo ">>> Iniciando Aplicação principal (mantendo container vivo)..."
exec tail -f /dev/null