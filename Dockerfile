# Base image for PHP with required extensions
FROM php:8.0-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libgmp-dev \
    libxml2-dev \
    libonig-dev \
    libzip-dev \
    zlib1g-dev \
    libpng-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libsqlite3-dev \
    libpq-dev \
    libsoap2-dev \
    libxslt1-dev \
    gnupg2 \
    software-properties-common \
    unzip \
    curl \
    git \
    nginx

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) gd gmp soap mbstring pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set up Nginx configuration
RUN rm /etc/nginx/sites-enabled/default
COPY ./nginx/default.conf /etc/nginx/conf.d/

COPY --chown=www-data:www-data . /var/www/html/public

# Expose web server port
EXPOSE 80

# Start PHP-FPM and Nginx
CMD service nginx start && php-fpm

