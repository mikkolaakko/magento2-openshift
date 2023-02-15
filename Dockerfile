# FROM php:8.1.16-apache
FROM php:7.4.33-apache

# Use the production configuration
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Accept connections on port 8080
RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
EXPOSE 8080

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

# Set the directory and file permissions
RUN mkdir -p /.composer
RUN chgrp -R 0 /.composer /var/www/html/ && \
    chmod -R g+rwX /.composer /var/www/html/

USER 1001

# Store access keys
RUN echo hello $PUBLIC_KEY $PRIVATE_KEY
RUN composer config --global http-basic.repo.magento.com $PUBLIC_KEY $PRIVATE_KEY

# find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
# find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
# chown -R :www-data . # Ubuntu
# chmod u+x bin/magento

# Get the metapackage
# RUN curl -LO https://github.com/magento/magento2/archive/refs/tags/2.4.5.zip && \
# 	unzip 2.4.5.zip && \
# 	rm 2.4.5.zip
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html/magento2
# composer create-project --repository-url=https://repo.magento.com/ magento/project-enterprise-edition=2.4.5 /var/www/html/magento2
