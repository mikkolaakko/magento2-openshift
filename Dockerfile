FROM php:8.1-rc-apache

ADD phpinfo.php /var/www/html/

RUN sed -i "s/Listen 80/Listen 8080/" /etc/apache2/ports.conf
EXPOSE 8080
