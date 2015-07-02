#!/bin/bash
set -e

## if source files from volume, replace home with sources, files volume only used when it's not source build.
if [ -n "$(ls -A /var/www/sources)" ]; then
  rm -rf /var/www/html
  ln -s /var/www/sources /var/www/html
  chown -R www-data:www-data /var/www/html /var/www/sources
else
  ln -s /var/www/files /var/www/html/files
  chown www-data:www-data /var/www/html/files
  chmod 707 /var/www/html/files
fi

# ## if files is exists in home, this container will exit.
# if [ -d "/var/www/html/files" ]; then
#   echo "files is already exist!, check source directory or remove file volume option"
#   exit 0
# else
#   ln -s /var/www/files /var/www/html/files
#   chown www-data:www-data /var/www/html/files
#   chmod 707 /var/www/html/files
# fi

if [ -n "$BEFORE_SCRIPT" ]; then
  set +e
  echo "*** [RUN BEFORE_SCRIPT] ***"
  chmod +x /entrypoints/$BEFORE_SCRIPT
  /bin/bash /entrypoints/$BEFORE_SCRIPT
  echo "*** [DONE BEFORE_SCRIPT] ***"
  set -e
fi

echo "*** Straing container ... ***"
echo "$@"
exec "$@"
