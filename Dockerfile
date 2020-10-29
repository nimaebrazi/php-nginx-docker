FROM php:7.4.9-fpm

LABEL maintainer="Nima Ebrazi <github.com/nimaebrazi>"


RUN set -eux; \
    apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y --no-install-recommends \
            apt-utils \
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
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c31c1e292ad7be5f49291169c0ac8f683499edddcfd4e42232982d0fd193004208a58ff6f353fde0012d35fdd72bc394') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --quiet --install-dir=/usr/bin --filename=composer && \
    rm composer-setup.php;

RUN pecl install -o -f redis;
