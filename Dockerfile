# FROM php:8.1.16-apache
FROM php:7.4.33-apache

# Install dependencies and php extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd pdo_mysql intl zip opcache mysqli bcmath soap sockets xsl && \
	docker-php-ext-enable gd pdo_mysql intl zip opcache mysqli bcmath soap sockets xsl
    
RUN apt-get update && apt-get install -y \
 	libzip-dev \
	zip

ADD phpinfo.php /var/www/html/

# Install composer
RUN TEMPFILE=$(mktemp) && \
    curl -o "$TEMPFILE" "https://getcomposer.org/installer" && \
    php <"$TEMPFILE" && \
    mv composer.phar /usr/local/bin/composer

RUN mkdir -p /.composer

# Sets the directory and file permissions
RUN chgrp -R 0 /.composer && \
    chmod -R g+rwX /.composer

# Get the metapackage
# composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento2
# composer create-project --repository-url=https://repo.magento.com/ magento/project-enterprise-edition=2.4.5 /var/www/html/magento2

# Accept connections on port 8080
RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
EXPOSE 8080
