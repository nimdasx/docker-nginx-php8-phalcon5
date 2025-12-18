FROM webdevops/php-nginx:8.4

LABEL maintainer="nimdasx@gmail.com" \
    description="nginx php-8 phalcon-5 ioncube"

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

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
    /usr/local/bin/install-php-extensions

RUN chmod +x /usr/local/bin/install-php-extensions \
 && install-php-extensions \
    sqlsrv \
    pdo_sqlsrv \
    phalcon-5.9.3

# ionCube (PHP 8.3)
RUN curl -fsSL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 | tar -xz -C /tmp \
 && PHP_EXT_DIR="$(php -r 'echo ini_get("extension_dir");')" \
 && cp /tmp/ioncube/ioncube_loader_lin_8.3.so "$PHP_EXT_DIR" \
 && echo "zend_extension=$PHP_EXT_DIR/ioncube_loader_lin_8.4.so" \
    > /usr/local/etc/php/conf.d/00-ioncube.ini \
 && rm -rf /tmp/ioncube
