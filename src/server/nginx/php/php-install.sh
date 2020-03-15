#!/usr/bin/env bash

# Install PHP7.2-fpm and its extensions
function InstallPHP() {
  {

    Separator "Instalando PHP 7.2 FPM e as principais extensões utilizadas"

    apt-get -y install php7.2-fpm

    service nginx restart

    # extensions

    apt-get -y install php7.2-mbstring
    apt-get -y install php7.2-bcmath
    apt-get -y install php7.2-xml
    apt-get -y install php7.2-curl
    apt-get -y install php7.2-mysql
    apt-get -y install php7.2-gd

    # @bugfix failed restart because it wans't running
    service php7.2-fpm stop && service php7.2-fpm start
    service nginx restart

  } || {
    Count $1 'InstallPHP'
  }
}
