ARG PHP_VERSION=8.5
ARG PHALCON_VERSION=5.23.0

FROM webdevops/php-nginx:${PHP_VERSION}

ARG PHP_VERSION=8.5
ARG PHALCON_VERSION=5.23.0

LABEL maintainer="nimdasx@gmail.com" \
    description="nginx php-${PHP_VERSION} phalcon-${PHALCON_VERSION} ioncube"

ENV TZ=Asia/Jakarta

RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo "$TZ" > /etc/timezone

# system deps
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    curl \
    nodejs \
    npm \
 && rm -rf /var/lib/apt/lists/*

COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini
COPY vhost.conf /opt/docker/etc/nginx/vhost.conf

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
    ioncube_loader \
    sqlsrv \
    pdo_sqlsrv \
    phalcon-${PHALCON_VERSION}
