FROM php:7.0-apache

ENV USER_ID=1000
ENV GROUP_ID=1000

RUN apt-get update \
    && apt-get install -y \
        libssl-dev \
        libicu-dev \
        libmcrypt-dev \
        libapache2-mod-rpaf \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        cron \
        sudo \
        acl \
        git \
        pkg-config \
        libpcre3-dev \
    && docker-php-ext-install \
        iconv \
        intl \
        mbstring \
        pdo_mysql \
        zip \
        opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && rm /tmp/* -rf \
    && rm -r /var/lib/apt/lists/*



RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && usermod -u $USER_ID www-data \
    && groupmod -g $GROUP_ID www-data \
    && mkdir -p /var/www/.composer \
    && chown -R www-data:www-data /var/www/.composer \
    && sudo -u www-data composer global require 'hirak/prestissimo:^0.3' \
    && sudo -u www-data composer global require phing/phing ~2.0 \
    && a2enmod rewrite




