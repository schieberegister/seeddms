FROM php:7.4.33-apache
LABEL maintainer="Benjamin Hofmann<hb@beohof.de>"

# Update and install necessary packages
RUN apt-get update && apt-get install libpng-dev libpq-dev libzip-dev -y
RUN docker-php-ext-install gd mysqli pdo pdo_mysql zip
RUN pear channel-update pear.php.net
RUN pear install Log

# Get seeddms
RUN curl -fsSL https://downloads.sourceforge.net/project/seeddms/seeddms-6.0.20/seeddms-quickstart-6.0.20.tar.gz | tar -xzC /var/www
RUN mv /var/www/seeddms60x /var/www/seeddms && touch /var/www/seeddms/conf/ENABLE_INSTALL_TOOL

# Copy settings-files
COPY sources/php.ini /usr/local/etc/php/
COPY sources/000-default.conf /etc/apache2/sites-available/
COPY sources/settings.xml /var/www/seeddms/conf/settings.xml
RUN chown -R www-data:www-data /var/www/seeddms/

RUN a2enmod rewrite

# Volumes to mount
VOLUME [ "/var/www/seeddms/data", "/var/www/seeddms/conf", "/var/www/seeddms/www/ext" ]