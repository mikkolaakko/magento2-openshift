FROM php:8.1.16-apache

# Install composer
RUN TEMPFILE=$(mktemp) && \
    curl -o "$TEMPFILE" "https://getcomposer.org/installer" && \
    php <"$TEMPFILE" && \
    mv composer.phar /usr/local/bin/composer

# Install dependencies and php extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd pdo_mysql intl zip opcache mysqli && \
	docker-php-ext-enable gd pdo_mysql intl zip opcache mysqli
    
RUN apt-get update && apt-get install -y \
 	libzip-dev \
	zip

ADD phpinfo.php /var/www/html/

# Get the metapackage
# composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento2
# composer create-project --repository-url=https://repo.magento.com/ magento/project-enterprise-edition=2.4.5 /var/www/html/magento2

# Accept connections on port 8080
RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
EXPOSE 8080
