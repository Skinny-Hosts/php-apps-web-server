FROM php:7.4-fpm-alpine
LABEL maintainer="marcosfreitas@c4network.com.br"

ARG APP_ENVIROMENT

EXPOSE 9000

# Added script to easy install PHP extensions

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# @info fix permissions
# Use the default production configuration
RUN apk update && apk add --no-cache shadow bash composer &&\
    usermod -u 1000 www-data &&\
    mv "$PHP_INI_DIR/php.ini-$APP_ENVIROMENT" "$PHP_INI_DIR/php.ini" &&\
    install-php-extensions mysqli pdo_mysql bcmath gd &&\
    php-fpm -m

COPY /src/scripts/ /usr/share/.docker/src/scripts

RUN chmod +x /usr/share/.docker/src/scripts/*.sh &&\
    mkdir -p /var/www/html &&\
    bash /usr/share/.docker/src/scripts/set-right-permissions-by-path.sh /var/www/ &&\
    bash /usr/share/.docker/src/scripts/set-right-permissions-by-path.sh /var/www/html

WORKDIR /var/www/html

USER www-data

ENTRYPOINT [ "/usr/share/.docker/src/scripts/laravel-initial-configurations.sh" ]