FROM ubuntu:14.04.4
MAINTAINER Andrea Manzi <manzolo@libero.it>

ENV DEBIAN_FRONTEND noninteractive

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

#Enviornment variables to configure php
ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

ARG DATABASE_PASSWORD=manzolo
ARG DATABASE_HOST=localhost
ENV DATABASE_PASSWORD $DATABASE_PASSWORD
ENV DATABASE_HOST $DATABASE_HOST

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive 

RUN apt-get update && \
apt-get -y upgrade
RUN apt-get -y install wget supervisor git \
  curl lynx-cur locate mc acl \
  apache2 libapache2-mod-php5 \
  php5-mysql php-apc php5-mcrypt php5-cli php5-pgsql php5-gd php5-curl php5-mcrypt \
  pwgen php-pear php5-dev phpmyadmin
  
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini && \
sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini && \
sed -i "s#;date.timezone =#\date.timezone = Europe/Rome#g" /etc/php5/apache2/php.ini && \
sed -i "s#;date.timezone =#\date.timezone = Europe/Rome#g" /etc/php5/cli/php.ini

# Copy site into place.
COPY www /var/www/site

#########################
#Configurazioni
COPY scripts/start-apache2.sh /opt/start-apache2.sh
COPY scripts/create_mysql_admin_user.sh /opt/create_mysql_admin_user.sh

COPY scripts/run-webserver.sh /opt/run-webserver.sh
RUN chmod 755 /opt/*.sh

# config to enable .htaccess
COPY apache.conf/apache_default /etc/apache2/sites-available/000-default.conf
COPY apache.conf/phpmyadmin.conf /etc/apache2/conf-available/phpmyadmin.conf

RUN sed -i "s#// \$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#\$cfg\['Servers'\]\[\$i\]\['AllowNoPassword'\] = TRUE;#g" /etc/phpmyadmin/config.inc.php


COPY mysql/create_tables.sql /tmp/create_tables.sql
# Remove pre-installed database
# RUN rm -rf /var/lib/mysql/*

# Enable apache mods.
RUN a2enmod php5
RUN a2enconf phpmyadmin.conf
RUN a2enmod rewrite
RUN php5enmod mcrypt

EXPOSE 80

# COPY volumes for MySQL
VOLUME  ["/etc/mysql", "/var/lib/mysql" ]

CMD ["/opt/run-webserver.sh"]

#docker build --build-arg DATABASE_PASSWORD=manzolo --build-arg DATABASE_HOST=aliasdblink -t manzolo/webserver:linked .
#docker run -d -P --name webserver --link linkedmysql:aliasdblink -p 8080:80 manzolo/webserver:linked
#docker exec -i -t webserver /bin/bash
#docker exec -i -t linkedmysql /bin/bash
#docker run -it manzolo/webserver:linked /bin/bash

#start database and webserver
#docker run -d -v /var/lib/mysql-linked-container:/var/lib/mysql --name linkedmysql -p 33060:3306 manzolo/mysql:linked && docker run -d -P --name webserver --link linkedmysql:aliasdblink -p 8080:80 manzolo/webserver:linked

#docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
