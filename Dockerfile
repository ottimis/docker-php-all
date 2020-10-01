FROM ottimis/php_mysql:latest
ENV ACCEPT_EULA=Y
RUN apt-get update -y \
    && apt-get install -y \
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
    && apt-get clean -y \
    && docker-php-ext-install dom \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-configure soap --enable-soap \
    && docker-php-ext-install soap

RUN docker-php-ext-install mbstring pdo pdo_mysql \
    && pecl install sqlsrv pdo_sqlsrv xdebug \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug