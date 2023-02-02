FROM php:8.1-rc-apache

# Install composer
RUN TEMPFILE=$(mktemp) && \
    curl -o "$TEMPFILE" "https://getcomposer.org/installer" && \
    php <"$TEMPFILE" && \
    mv composer.phar /usr/local/bin/composer

# Install dependencies
RUN apt-get update && apt-get install -y \
		zip

ADD phpinfo.php /var/www/html/

RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
EXPOSE 8080
