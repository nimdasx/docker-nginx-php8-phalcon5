ARG PHP_VERSION=8.5
ARG PHALCON_VERSION=5.23.0
ARG PHP_PATCH=false

FROM webdevops/php-nginx:${PHP_VERSION}

ARG PHP_VERSION=8.5
ARG PHALCON_VERSION=5.23.0
ARG PHP_PATCH=false

LABEL maintainer="nimdasx@gmail.com" \
    description="nginx php-${PHP_VERSION} phalcon-${PHALCON_VERSION} ioncube"

ENV TZ=Asia/Jakarta

RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
 && echo "$TZ" > /etc/timezone

COPY patches/ /tmp/patches/

# Apply core PHP patch & recompile if PHP_PATCH=true
RUN if [ "$PHP_PATCH" = "true" ] && [ -f /tmp/patches/php-${PHP_VERSION}-cve-2026-109618-109619.patch ]; then \
        echo "Applying CVE-2026-109618 & CVE-2026-109619 patch to PHP ${PHP_VERSION}..."; \
        apt-get update && \
        apt-get install -y --no-install-recommends \
            patch \
            libxml2-dev \
            libssl-dev \
            libsqlite3-dev \
            libcurl4-openssl-dev \
            libonig-dev \
            libargon2-dev \
            libsodium-dev \
            libreadline-dev \
            zlib1g-dev && \
        docker-php-source extract && \
        cd /usr/src/php && \
        patch -p1 < /tmp/patches/php-${PHP_VERSION}-cve-2026-109618-109619.patch && \
        eval ./configure $(php-config --configure-options) && \
        make -j$(nproc) cli fpm && \
        cp sapi/cli/php /usr/local/bin/php && \
        cp sapi/fpm/php-fpm /usr/local/sbin/php-fpm && \
        docker-php-source delete && \
        apt-get purge -y --auto-remove \
            patch \
            libxml2-dev \
            libssl-dev \
            libsqlite3-dev \
            libcurl4-openssl-dev \
            libonig-dev \
            libargon2-dev \
            libsodium-dev \
            libreadline-dev \
            zlib1g-dev && \
        rm -rf /var/lib/apt/lists/*; \
    fi && \
    rm -rf /tmp/patches

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
