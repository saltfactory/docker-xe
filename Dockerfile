FROM debian:jessie
MAINTAINER SungKwang Song <saltfactory@gmail.com>

LABEL Description="This image is used to start the xpressengine-1.8.3" Vendor="saltfactory.net" Version="1.8.3"

## replace debian mirror with ftp.daum.net in Korea
RUN cd /etc/apt && \
     sed -i 's/httpredir.debian.org/ftp.daum.net/g' sources.list

RUN apt-get update

## install tools package
RUN apt-get install -y vim git wget unzip curl imagemagick

RUN apt-get install -y apache2  apache2-utils \
    php5 php5-common libapache2-mod-php5 php5-mysql php5-gd php5-imagick php5-xmlrpc php5-cgi php5-curl php5-cli php5-mcrypt

## apache configurations
RUN a2enmod php5
RUN a2enmod rewrite
RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

## add file from host
ADD ./entrypoints /entrypoints
RUN chmod +x /entrypoints/bootstrap.sh
#ADD ./php/php.ini /etc/php5/apache2/php.ini
#ADD ./apache2/000-default.conf /etc/apache2/sites-available/000-default.conf
RUN mv /entrypoints/php/php.ini /etc/php5/apache2/php.ini
RUN mv /entrypoints/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf

## xpressengine configurations
RUN wget -O /var/www/html/xe.zip https://github.com/xpressengine/xe-core/releases/download/1.8.3/xe.1.8.3.zip
RUN cd /var/www/html; rm index.html; unzip xe.zip
RUN mkdir /var/www/files; chmod 707 /var/www/files
RUN chown -R www-data:www-data /var/www/html

## extra variables
ENV BEFORE_SCRIPT before.sh
ENV BUILD_TYPE "full"

VOLUME /var/www/sources
VOLUME /var/www/files
VOLUME /var/log/apache2

EXPOSE 80

WORKDIR /var/www/html

ENTRYPOINT ["/entrypoints/bootstrap.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]
