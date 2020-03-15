#!/usr/bin/env bash

# Install Nginx and enable it on UFW Firewall, also, protect with chmod its directory
# @version 1.1.0 - Added verification for existent NGINX installation
function InstallNginx() {
  {
    Separator "Instalando e Configurando o Servidor Nginx"

    if [[ -f /usr/sbin/nginx ]]; then
      Separator "O NGINX já está instalado" ${YELLOW}

      #if [[ $(PressKeyToContinue "Pressione 's' para reinstalar ou qualquer outra tecla para pular esta parte: " "s") -eq 1 ]]; then

        Separator "Removendo a instalação do NGINX..." ${RED}

        apt-get purge nginx && InstallNginx

     # else
     #   return 1
     # fi
    fi

    wget http://nginx.org/packages/keys/nginx_signing.key &&
      echo "deb http://nginx.org/packages/ubuntu/ bionic nginx" >>/etc/apt/sources.list &&
      echo "deb-src http://nginx.org/packages/ubuntu/ bionic nginx" >>/etc/apt/sources.list && apt-key add ./nginx_signing.key

    AptUpdate

    apt-get install -y nginx && systemctl enable nginx

    mkdir /etc/nginx/sites-available
    mkdir /etc/nginx/sites-enabled

    service nginx stop

    Separator "Protegendo os diretórios de configuração do Nginx" ${LIGHT_GREEN}
    chmod 0750 -R /etc/nginx/

  } || {
    Count $1 'InstallNginx'
  }
}
