FROM php:8.1-rc-apache

# Install composer
RUN TEMPFILE=$(mktemp) && \
    curl -o "$TEMPFILE" "https://getcomposer.org/installer" && \
    php <"$TEMPFILE" && \
    mv composer.phar /usr/local/bin/composer

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install dependencies and php extensions
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd pdo_mysql intl
    
RUN apt-get update && apt-get install -y \
	libzip-dev \
	zip \
	libpng-dev \
	&& docker-php-ext-install zip gd pdo_mysql \
	&& docker-php-ext-enable gd pdo_mysql intl

ADD phpinfo.php /var/www/html/

RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
EXPOSE 8080
