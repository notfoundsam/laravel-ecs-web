FROM php:8.0.3-fpm-alpine3.13

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
    && pecl install xdebug-3.0.4 \
    && docker-php-ext-enable xdebug

RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

RUN mkdir /.config && chmod 777 /.config
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# Xdebug settings
RUN echo "xdebug.mode=debug" >> "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"
RUN echo "xdebug.start_with_request=yes" >> "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"
RUN echo "xdebug.output_dir=/app/storage/xdebug" >> "$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini"

WORKDIR /app
