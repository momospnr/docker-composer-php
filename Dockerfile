FROM php:7.2.19-fpm-alpine3.9

LABEL maintainer="momospnr"

# Package Install
RUN set -ex \
  && apk update \
  && apk add --no-cache \
  autoconf \
  bash \
  curl \
  make \
  tar \
  libmcrypt \
  libpng \
  libjpeg-turbo \
  libxml2 \
  libedit \
  libxslt \
  freetype \
  jpeg \
  gettext \
  ruby \
  ruby-dev \
  ruby-rdoc \
  sqlite-dev \
  redis \
  nodejs \
  yarn \
  git \
  unzip \
  openssl

RUN set -ex \
  && apk add --no-cache --virtual build-dependencies \
  build-base \
  freetype-dev \
  libjpeg-turbo-dev \
  libpng-dev \
  gettext-dev \
  mysql-dev \
  pcre-dev \
  libc-dev \
  jpeg-dev \
  libpng-dev \
  libxml2-dev \
  libedit-dev \
  libxslt-dev \
  tzdata

RUN set -ex \
  && cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
  && pecl install xdebug apcu \
  && docker-php-source extract \
  && git clone -b 4.1.1 --depth 1 https://github.com/phpredis/phpredis.git /usr/src/php/ext/redis \
  && docker-php-ext-install \
  json \
  exif \
  xml \
  pdo \
  mbstring \
  mysqli \
  pdo_mysql \
  redis \
  opcache \
  calendar \
  ctype \
  dom \
  fileinfo \
  ftp \
  iconv \
  phar \
  posix \
  readline \
  shmop \
  simplexml \
  sockets \
  sysvmsg \
  sysvsem \
  sysvshm \
  tokenizer \
  wddx \
  xmlwriter \
  && CFLAGS="-I/usr/src/php" docker-php-ext-install xmlreader \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  && docker-php-ext-enable \
  xdebug apcu

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

RUN set -ex \
  && apk del --purge build-dependencies

COPY php.ini-development /usr/local/etc/php/php.ini

WORKDIR /srv