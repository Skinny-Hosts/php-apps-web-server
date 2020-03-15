#!/usr/bin/env bash

echo "-- Running composer install";

cd /var/www/html;
composer install;

CONTAINER_ALREADY_STARTED="CONTAINER_ALREADY_RAN_ONCE"

if [ ! -e $CONTAINER_ALREADY_STARTED ]; then
    touch $CONTAINER_ALREADY_STARTED

    echo "-- Container first time for its first time"

    chmod a+rw -R /var/www/;

    echo "-- Generating key";

    php artisan key:generate;
    php artisan config:cache;

    chmod a+rw -R /var/www/;

    composer dump-autoload;

    php artisan migrate
    #php artisan db:seed --class=UsersTableSeeder

    chmod a+rw -R /var/www/;

else
    echo "-- Container already run. No need to be reconfigured"
fi

service nginx start && service php7.2-fpm start && /bin/bash

echo "-- Services running";