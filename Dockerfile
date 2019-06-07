FROM php:7.2.18-fpm-alpine3.9

LABEL maintainer="momospnr"

# Package Install
RUN set -ex \
  && apk update \
  && apk add --no-cache \
  autoconf \
  bash \
  curl \
  make \
  libintl \
  freetype \
  freetype-dev \
  libjpeg-turbo \
  libjpeg-turbo-dev \
  libc-dev \
  jpeg-dev \
  libpng \
  libpng-dev \
  php7-gd \
  php7-gettext \
  php7-json \
  php7-mbstring \
  php7-fileinfo \
  php7-pdo \
  php7-pdo_mysql \
  php7-exif \
  libmcrypt \
  mysql-dev \
  sqlite-dev \
  ruby \
  ruby-dev \
  ruby-rdoc \
  redis \
  build-base \
  nodejs \
  yarn \
  git \
  unzip \
  openssl \
  && apk add --no-cache --virtual .build-php \
  tzdata \
  libpng-dev \
  pcre-dev \
  && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && pecl install xdebug apcu \
  && docker-php-ext-install \
  json mbstring pdo pdo_mysql exif\
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  && docker-php-ext-enable \
  xdebug

# Dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Composer
RUN set -ex \
  && cd ~ \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin \
  && mv /usr/local/bin/composer.phar /usr/local/bin/composer

# mailcatcher
RUN set -ex \
  && gem install mailcatcher etc

COPY php.ini-development /usr/local/etc/php/conf.d/php.ini

WORKDIR /src