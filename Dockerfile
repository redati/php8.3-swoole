#docker build -t misaelgomes/php8.3-swoole .

FROM php:8.3.11

LABEL maintainer="Misael Gomes"
LABEL description="PHP8.3 Swoole, mongodb, redis, cron, imagem base para criação de outros containers"

ARG WWWGROUP

WORKDIR /var/www/html

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/Sao_Paulo

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN usermod -u 1000 www-data

RUN apt-get update -y && apt-get upgrade --fix-missing -y && apt-get install -y webp libfreetype6-dev libwebp-dev jpegoptim libpng-dev  \
    curl ca-certificates zip unzip git supervisor cron libjpeg62-turbo-dev \
    openssl curl libonig-dev tzdata libxslt-dev tar zip unzip zlib1g-dev zlib1g libzip-dev libbz2-dev nano

RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp

RUN docker-php-ext-install gd soap pdo_mysql opcache mbstring \
        mysqli gettext calendar bz2 exif gettext \
        sockets sysvmsg sysvsem sysvshm xsl zip xml intl bcmath pcntl

RUN pecl channel-update pecl.php.net &&  echo yes | pecl install redis swoole zstd lzf mongodb

RUN docker-php-ext-enable redis lzf zstd swoole mongodb

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get -y autoremove && apt-get clean 
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*