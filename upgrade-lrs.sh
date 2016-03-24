#!/bin/sh
# Upgrade LRS code using git via github.

TAG=$1
ENV_STAGE=$2
DOMAINROOT="/var/www/html/lrs.50ten40.com"
PROJECTROOT="/var/www/html/lrs.50ten40.com/learninglocker"
STORAGE="$PROJECTROOT/app/storage"

echo "Backing up local config..."
LOCALCONFIGDIR="$PROJECTROOT//app/config/local"
LOCALENVFILE="$PROJECTROOT/.env.php"
cp -vR $LOCALCONFIGDIR $LOCALENVFILE $DOMAINROOT
echo "Done."


cd $PROJECTROOT
git fetch --tags; git checkout -b local; git add app/config/local; git commit -m 'Adds local config.'; git add -A; git commit -m 'Local changes.'
git merge $TAG
git rm --cached app/config/local -r; git add app/config/local; git commit -m 'Fixes local config.'; php -r "readfile('https://getcomposer.org/installer');" | php; php composer.phar install

php artisan migrate --env=$ENV_STAGE

chmod -R ug+w $STORAGE
