# Dockerfile.app CORRIGIDO
# Baseado em Debian Bookworm (12 LTS)
FROM debian:bookworm

# Define a versão LTS do Zabbix
ARG ZABBIX_VERSION=6.0

# Instala Zabbix Agent e ferramentas básicas (wget e systemd)
RUN apt update && \
    apt install -y wget systemd && \
    # Adiciona o repositório Zabbix 6.0 para Debian 12
    # CORREÇÃO APLICADA AQUI: Mudança de -1+debian12 para -5+debian12 para corrigir 404
    wget https://repo.zabbix.com/zabbix/${ZABBIX_VERSION}/debian/pool/main/z/zabbix-release/zabbix-release_${ZABBIX_VERSION}-5+debian12_all.deb && \
    dpkg -i zabbix-release_${ZABBIX_VERSION}-5+debian12_all.deb && \
    apt update && \
    # Instala o Agent 
    apt install -y zabbix-agent && \
    # Limpeza
    rm zabbix-release_${ZABBIX_VERSION}-5+debian12_all.deb && \
    apt clean

# Cria diretórios necessários para o Zabbix Agent
RUN mkdir -p /var/log/zabbix /var/run/zabbix && \
    chown -R zabbix:zabbix /var/log/zabbix /var/run/zabbix

# Copia o script de inicialização
COPY startup_scripts/start_app.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start_app.sh

# Expondo a porta padrão do Zabbix Agent
EXPOSE 10050

# Define o script como o ponto de entrada principal
ENTRYPOINT ["/usr/local/bin/start_app.sh"]