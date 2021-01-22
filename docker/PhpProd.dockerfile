FROM php:7.4.12-fpm-alpine3.12

RUN docker-php-ext-install \
    bcmath \
    pdo_mysql \
    mysqli \
    opcache

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN sed -i 's,^expose_php =.*$,expose_php = Off,' "$PHP_INI_DIR/php.ini"

COPY --chown=www-data:www-data ./app /app/app
COPY --chown=www-data:www-data ./bootstrap /app/bootstrap
COPY --chown=www-data:www-data ./config /app/config
COPY --chown=www-data:www-data ./database /app/database
COPY --chown=www-data:www-data ./resources /app/resources
COPY --chown=www-data:www-data ./routes /app/routes
COPY --chown=www-data:www-data ./storage /app/storage
COPY --chown=www-data:www-data ./vendor /app/vendor
COPY --chown=www-data:www-data ./artisan /app/artisan
COPY --chown=www-data:www-data ./.env.default /app/.env

COPY --chown=www-data:www-data ./composer.json /app/composer.json
COPY --chown=www-data:www-data ./public/index.php /app/public/index.php
COPY --chown=www-data:www-data ./public/mix-manifest.json /app/public/mix-manifest.json

WORKDIR /app
