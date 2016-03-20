#!/bin/bash

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    CMD_STATUSDB='mysql -uroot -p'$DATABASE_PASSWORD' -h'$DATABASE_HOST' -e "status"' 
    eval $CMD_STATUSDB > /dev/null 2>&1
    RET=$?
done

echo "=> Installing PhpMyAdmin tables ..."
#setup the phpmyadmin configuration
sed -i "s/\$dbuser=.*/\$dbuser='root';/g" /etc/phpmyadmin/config-db.php
sed -i "s/\$dbpass=.*/\$dbpass='"$DATABASE_PASSWORD"';/g" /etc/phpmyadmin/config-db.php
sed -i "s/\$dbserver=.*/\$dbserver='"$DATABASE_HOST"';/g" /etc/phpmyadmin/config-db.php
#sed -i "s/\$dbserver=.*/\$dbserver='${MYSQL_PORT_3306_TCP_ADDR}';/g" /etc/phpmyadmin/config-db.php
sed -i "s/pma__/pma_/g" /tmp/create_tables.sql
mysql -v -uroot -p$DATABASE_PASSWORD -h$DATABASE_HOST < /tmp/create_tables.sql 2>&1
    CMD_CREATEDB='mysql -uroot -p'$DATABASE_PASSWORD' -h'$DATABASE_HOST' < /tmp/create_tables.sql' 
    eval $CMD_CREATEDB > /dev/null 2>&1
echo "=> Done!"
