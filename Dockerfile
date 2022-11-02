FROM webdevops/php-nginx:8.1-alpine

LABEL maintainer="nimdasx@gmail.com"
LABEL description="nginx php-8.1 phalcon-5.0"

#set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
    && echo "Asia/Jakarta" > /etc/timezone

#config php
COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini

#apk
RUN apk add autoconf make g++

#phalcon 5 stable
RUN pecl install phalcon-5.1.0 \
    && docker-php-ext-enable phalcon
