FROM php:7.4-fpm-alpine

ARG APP_ENVIROMENT


# @info fix permissions
# Use the default production configuration
RUN apk add --no-cache shadow &&\
    usermod -u 1000 www-data &&\
    mv "$PHP_INI_DIR/php.ini-$APP_ENVIROMENT" "$PHP_INI_DIR/php.ini"


EXPOSE 9000

WORKDIR /var/www

USER www-data

ENTRYPOINT ["php-fpm"]