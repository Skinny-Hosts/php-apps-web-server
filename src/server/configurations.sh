#!/usr/bin/env bash

author="Marcos Freitas"
version="3.10.0"
manual_version="1.0.3"

# global variables

DIR="${BASH_SOURCE[0]}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# including helpers.sh file
source "$DIR/helpers.sh"

# Add necessary repos
function AddRepositories() {
  {
    AptUpdate 'upgrade'

    Separator "Ativando repositórios extras para o Ubuntu 16.04 64 Bits"

    apt-get install -y software-properties-common apt-transport-https gnupg2

    Separator "ativando os repositórios Universe e Multiverse" ${LIGHT_GREEN}

    add-apt-repository "deb http://archive.ubuntu.com/ubuntu/ bionic universe multiverse" &&
      echo -ne "\n" | add-apt-repository ppa:ondrej/php &&
      echo -ne "\n" | add-apt-repository ppa:ondrej/nginx &&
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C &&
      apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E5267A6C

    AptUpdate 'upgrade'

    apt-get -y auto-remove

  } || {

    Count $1 'AddRepositories'

  }
}

# Add and Enable virtual host files
# For each site hosted in this server, you should create a individual file for its virtual host
# - into the folder "/etc/nginx/sites-available", then enable the site creating a simbolic link into "/etc/nginx/site-enabled"
function AddVirtualHostFiles() {
  {

    Separator "Ajustando arquivo do VirtualHost do projeto:"

    cp $DIR/nginx/vhost-app.conf /etc/nginx/sites-available/app
    mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bkp
    cp $DIR/nginx/nginx.conf /etc/nginx/nginx.conf

    cp -r $DIR/nginx/snippets /etc/nginx

    ln -s /etc/nginx/sites-available/app /etc/nginx/sites-enabled/

  } || {
    Count $1 'AddVirtualHostFiles'
  }
}

# Configuring virtual host folders
# protect folders giving access only to the process of nginx
function AdjustVirtualHostFolders() {
  {
    Separator "Ajustando diretórios do VirtualHost do projeto:"

    # site
    mkdir -p /var/www/html &&
      chmod 755 /var/www &&
      chmod 2755 /var/www/html &&
      chown -R www-data:www-data /var/www

    # app
    mkdir -p /var/www/app &&
      chmod 755 /var/www &&
      chmod 2755 /var/www/app &&
      chown -R www-data:www-data /var/www

  } || {
    Count $1 'AdjustVirtualHostFolders'
  }
}

# Install some software dependencies packages
# @version 1.0.1
function InstallSoftwareDependencies() {
  {
    Separator "Instalando dependências de software comuns durante o desenvolvimento"

    apt-get -y install composer

    export COMPOSER_HOME="$HOME/.config/composer"

  } || {
    Count $1 'InstallSoftwareDependencies'
  }
}

Separator "For Ubuntu 18.04 64-Bit | Version $version based on 'Manual de Infraestrutura' $manual_version | Author: $author" ${CYAN}

# self running all the instalation processes

AptUpdate
AddExtraPackages 1

source "$DIR/nginx/nginx-install.sh"
source "$DIR/nginx/php/php-install.sh"

# Calling all methods passing 1 as a initial value to counter

InstallNginx 1
AddVirtualHostFiles 1
AdjustVirtualHostFolders 1
ProtectProjectDirectories 1

AddRepositories 1
InstallPHP 1

InstallSoftwareDependencies 1

Separator "Processo de configuração concluído aparentemente com sucesso ;)." ${CYAN}
