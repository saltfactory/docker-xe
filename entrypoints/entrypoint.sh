#!/bin/bash

# if [ ! -d /var/www/html/files ]; then
#   mkdir /var/www/html/files
#   chmod 707 /var/www/html/xe
#   chmod 707 /var/www/html/xe/files
# fi
chown -R www-data:www-data /var/www/html/files
chmod 707 /var/www/files

apachectl -D FOREGROUND
