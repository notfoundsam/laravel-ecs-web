FROM php:7.4.12-fpm-alpine3.12

RUN docker-php-ext-install \
    bcmath \
    pdo_mysql \
    mysqli \
    opcache

# Add development tools
RUN apk --no-cache add \
    vim \
    mysql-client \
    $PHPIZE_DEPS \
    && pecl install xdebug-2.9.8 \
    && docker-php-ext-enable xdebug

RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN mkdir /.config && chmod 777 /.config
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

WORKDIR /app
