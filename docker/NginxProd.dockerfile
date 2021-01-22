FROM nginx:1.19.4-alpine

COPY ./docker/nginxProd.conf /etc/nginx/conf.d/default.conf

COPY ./public/css /app/public/css
COPY ./public/js /app/public/js
COPY ./public/images /app/public/images
COPY ./public/index.php /app/public/index.php
COPY ./public/favicon.png /app/public/favicon.png
COPY ./public/robots.txt /app/public/robots.txt

WORKDIR /app
