FROM momoirospanner/php-fpm

LABEL maintainer="Hiroaki Tagawa<h.tagawa@momoirospanner.app>"

# Package Install
RUN set -ex \
    && apk update \
    && apk add --no-cache \
        autoconf \
        curl \
        gcc \
        make \
        g++ \
        libintl \
        php7-gd \
        php7-gettext \
        php7-json \
        php7-mbstring \
        php7-fileinfo \
        php7-pdo \
        php7-pdo_pgsql \
        libmcrypt \
        postgresql-dev \
    && apk add --no-cache --virtual .build-php \
        tzdata \
        libpng-dev \
        pcre-dev \
    && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && docker-php-ext-install \
        gd \
        pdo pdo_pgsql

# Composer
RUN set -ex \
    && cd ~ \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin \
    && mv /usr/local/bin/composer.phar /usr/local/bin/composer