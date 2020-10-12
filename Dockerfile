FROM php:7.4.9-fpm

LABEL maintainer="Nima Ebrazi <github.com/nimaebrazi>"


RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
            curl \
            libmemcached-dev \
            libz-dev \
            libpq-dev \
            libjpeg-dev \
            libpng-dev \
	    libsqlite3-dev \
            libfreetype6-dev \
            libssl-dev \
            libmcrypt-dev \
            libonig-dev \
            libicu-dev \
            libxslt-dev \
            libxml2-dev \
            libzip-dev; 

RUN rm -rf /var/lib/apt/lists/* ;

RUN set -eux; \
    docker-php-ext-install pdo_mysql; \
    docker-php-ext-install pdo_pgsql; \
    docker-php-ext-install pdo_pgsql; \
    docker-php-ext-install pdo_sqlite; \
    docker-php-ext-configure gd --prefix=/usr --with-jpeg --with-freetype; \
    docker-php-ext-install gd;

RUN apt-get update &&  apt-get install -y \ 
        git \
        nginx \
        wget \ 
        supervisor \
    	ca-certificates \
        python3-pip \       
        python3 \
        zip \
    	unzip; 


RUN docker-php-ext-install iconv exif intl xsl json soap dom zip opcache bcmath; 

RUN docker-php-ext-install -j$(nproc) gd;


RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --quiet --install-dir=/usr/bin --filename=composer && \
    rm composer-setup.php;

RUN pecl install -o -f redis;
