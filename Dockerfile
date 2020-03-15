# @version 3.7.5
# Dockerfile para configuração geral do servidor. Ele vai executar alguns comandos iniciais e scripts de instalação do servidor web e php-fpm

FROM ubuntu:18.04
LABEL maintainer="marcosvsfreitas@gmail.com"

EXPOSE 80
EXPOSE 443

# Desativa modo interativo para não interromper o processo de build da imagem
ENV DEBIAN_FRONTEND noninteractive

# Ajsute de idioma para a imagem quando o container é executado
RUN apt-get update
RUN apt-get install -y locales locales-all sudo gnupg2

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Copiando scripts de configuração geral
ADD /src/ /docker/src

RUN chmod +x /docker/src/server/helpers.sh
RUN chmod +x /docker/src/server/configurations.sh
#RUN chmod +x /docker/src/src/laravel-initial-configurations.sh

RUN cd /docker/src/server/ && bash configurations.sh

#ENTRYPOINT ["/docker/src/laravel-initial-configurations.sh"]

WORKDIR /var/www/html

CMD service nginx start && service php7.2-fpm start && /bin/bash