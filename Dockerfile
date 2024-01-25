# Used for prod build.
FROM php:8.1-fpm as php

# Set environment variables
ENV PHP_OPCACHE_ENABLE=1
ENV PHP_OPCACHE_ENABLE_CLI=0
ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS=0
ENV PHP_OPCACHE_REVALIDATE_FREQ=0

# Install dependencies.
RUN apt-get update && apt-get install -y unzip libpq-dev libcurl4-gnutls-dev nginx libonig-dev
    # libssl-dev libcurl4-openssl-dev

# Install PHP extensions.
RUN docker-php-ext-install mysqli pdo pdo_mysql bcmath curl opcache mbstring

# Install PHP MongoDB extension
RUN pecl install mongodb && docker-php-ext-enable mongodb

# Install PHP Redis extension
RUN pecl install redis && docker-php-ext-enable redis

# Install PHP MongoDB extension
#RUN pecl install mongodb
#RUN docker-php-ext-install mongodb
#RUN docker-php-ext-enable mongodb

# Install PHP Redis extension
#RUN pecl install redis
#RUN docker-php-ext-install redis
#RUN docker-php-ext-enable redis

# mongodb redis php-redis git nano
#RUN docker-php-ext-enable mongodb redis

#COPY ./docker/php/conf.d/mongodb.ini /usr/local/etc/php/conf.d/mongodb.ini
#COPY ./docker/php/conf.d/redis.ini /usr/local/etc/php/conf.d/redis.ini

# Copy composer executable.
COPY --from=composer:2.3.5 /usr/bin/composer /usr/bin/composer

# Copy configuration files.
COPY php.ini /usr/local/etc/php/php.ini
COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY nginx.conf /etc/nginx/nginx.conf

#RUN service php8.1-fpm restart

# Set working directory to /var/www.
WORKDIR /var/www

# Copy files from current folder to container current folder (set in workdir).
COPY --chown=www-data:www-data . .

# Create laravel caching folders.
RUN mkdir -p /var/www/storage/framework /var/www/storage/framework/{cache,testing,sessions,views}
RUN mkdir -p /var/www/storage /var/www/storage/logs /var/www/bootstrap

# Fix files ownership.
RUN chown -R www-data:www-data /var/www/storage

# Set correct permission.
RUN chmod -R 755 /var/www/storage /var/www/bootstrap

# Adjust user permission & group
RUN usermod --uid 1000 www-data
RUN groupmod --gid 1001 www-data

# Run the entrypoint file.
ENTRYPOINT [ "docker/entrypoint.sh" ]
