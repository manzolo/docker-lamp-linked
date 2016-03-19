#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    CMD_STATUSDB='mysql -uroot -p'$DATABASE_PASSWORD' -h'$DATABASE_HOST' -e "status"' 
    eval $FULLCMD_CREATEDB > /dev/null 2>&1
    RET=$?
done

#echo "=> Creating MySQL "$DATABASE_USER" user with "$DATABASE_PASSWORD" password"

  #CMD_CREATEDB="CREATE DATABASE "$DATABASE_NAME";"
  #CMD_GRANT=" GRANT ALL PRIVILEGES ON *.* TO "$DATABASE_USER"@'%' IDENTIFIED BY '"$DATABASE_PASSWORD"' WITH GRANT OPTION; FLUSH PRIVILEGES"
  #FULLCMD_CREATEDB='mysql -uroot -proot -h'$DATABASE_HOST' mysql -e "'$CMD_CREATEDB'"'
  #FULLCMD_GRANT='mysql -uroot -proot -h'$DATABASE_HOST' mysql -e "'$CMD_GRANT'"'
  #eval $FULLCMD_CREATEDB >> /tmp/mysqldocker.log
  #eval $FULLCMD_GRANT >> /tmp/mysqldocker.log
  
# You can create a /mysql-setup.sh file to intialized the DB
#if [ -f /mysql-setup.sh ] ; then
#  . /mysql-setup.sh
#fi

echo "=> Done!"

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -u"$DATABASE_USER" -p"$DATABASE_PASSWORD" -h"$DATABASE_HOST" -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "========================================================================"

echo "=> Installing PhpMyAdmin tables ..."
#setup the phpmyadmin configuration
sed -i "s/\$dbuser=.*/\$dbuser='root';/g" /etc/phpmyadmin/config-db.php
sed -i "s/\$dbpass=.*/\$dbpass='"$DATABASE_PASSWORD"';/g" /etc/phpmyadmin/config-db.php
sed -i "s/\$dbserver=.*/\$dbserver='"$DATABASE_HOST"';/g" /etc/phpmyadmin/config-db.php
#sed -i "s/\$dbserver=.*/\$dbserver='${MYSQL_PORT_3306_TCP_ADDR}';/g" /etc/phpmyadmin/config-db.php
sed -i "s/pma__/pma_/g" /tmp/create_tables.sql
mysql -uroot -p$DATABASE_PASSWORD -h$DATABASE_HOST < /tmp/create_tables.sql
echo "=> Done!"  

mysqladmin -uroot -p$DATABASE_PASSWORD -h$DATABASE_HOST shutdown
