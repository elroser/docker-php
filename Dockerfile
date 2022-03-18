FROM php:7.4-apache

ARG USER_ID=1000
ARG GROUP_ID=1000
ENV DOCKERIZE_VERSION v0.6.1

RUN apt-get update \
	&& apt-get install -y \
	libssl-dev \
	libicu-dev \
	libapache2-mod-rpaf \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng-dev \
	libxml2-dev \
	libzip-dev \
	cron \
	sudo \
	acl \
	git \
	gnupg \
	pkg-config \
	libpcre3-dev \
	wget \
	&& docker-php-ext-install \
	iconv \
	intl \
	zip \
	opcache \
	bcmath \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
	&& docker-php-ext-install gd \
	&& pecl install xdebug \
	&& docker-php-ext-enable xdebug \
	&& wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
	&& tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
	&& rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
	&& rm /tmp/* -rf \
	&& rm -r /var/lib/apt/lists/* 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	&& usermod -u $USER_ID www-data \
	&& groupmod -g $GROUP_ID www-data \
	&& mkdir -p /var/www/.composer \
	&& chown -R www-data:www-data /var/www/.composer \
	&& a2enmod rewrite \
	&& a2enmod proxy \
	&& a2enmod proxy_http \
	&& a2enmod proxy_ajp \
	&& a2enmod rewrite \
	&& a2enmod deflate \
	&& a2enmod headers \
	&& a2enmod proxy_balancer \
	&& a2enmod proxy_connect \
	&& a2enmod proxy_html

CMD ["dockerize", "apache2-foreground"]