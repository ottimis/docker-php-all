FROM php:7.4-apache
ENV ACCEPT_EULA=Y
ENV TZ=Europe/Rome
ENV APACHE_DOCUMENT_ROOT /var/www/html

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libgd-dev \
    gnupg2 zip \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/9/prod.list \
    > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get install -y --no-install-recommends \
    locales \
    apt-transport-https \
    && echo "it_IT.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && apt-get update \
    && apt-get -y --no-install-recommends install \
    unixodbc-dev \
    msodbcsql17 \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean -y \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install dom \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-install soap \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/bin --filename=composer \
    && printf '[PHP]\ndate.timezone = "Europe/Rome"\n' > /usr/local/etc/php/conf.d/tzone.ini \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && a2enmod rewrite \
    && sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN docker-php-ext-install pdo pdo_mysql \
    && pecl install sqlsrv pdo_sqlsrv xdebug \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug