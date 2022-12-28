FROM webdevops/php-nginx:8.1-alpine

LABEL maintainer="nimdasx@gmail.com"
LABEL description="nginx php-8.1 phalcon-5.1"

#set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime \
    && echo "Asia/Jakarta" > /etc/timezone

#config php
COPY php-nimdasx.ini /usr/local/etc/php/conf.d/php-nimdasx.ini

#apk
RUN apk add autoconf make g++

#phalcon 5 stable
RUN pecl install phalcon-5.1.3 \
    && docker-php-ext-enable phalcon

#sqlsrv
RUN curl -O https://download.microsoft.com/download/8/6/8/868e5fc4-7bfe-494d-8f9d-115cbcdb52ae/msodbcsql18_18.1.2.1-1_amd64.apk \
    && curl -O https://download.microsoft.com/download/8/6/8/868e5fc4-7bfe-494d-8f9d-115cbcdb52ae/mssql-tools18_18.1.1.1-1_amd64.apk \
    && apk add --allow-untrusted msodbcsql18_18.1.2.1-1_amd64.apk \
    && apk add --allow-untrusted mssql-tools18_18.1.1.1-1_amd64.apk \
    unixodbc-dev \
    && rm -rf /var/lib/apt/lists/* \
    && pecl install sqlsrv pdo_sqlsrv \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv \
    && sed -i 's/TLSv1.2/TLSv1.0/g' /etc/ssl/openssl.cnf