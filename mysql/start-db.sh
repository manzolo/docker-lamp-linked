#!/bin/bash
if ! -f /var/lib/mysql/ibdata1
then
  mysql_install_db
  /usr/bin/mysqld_safe &
  sleep 5
  mysqladmin -uroot -h localhost password $DATABASE_PASSWORD
  #CMD_CREATEDB="CREATE DATABASE "$DATABASE_NAME";"
  #FULLCMD_CREATEDB='mysql -uroot -p'$DATABASE_PASSWORD' mysql -e "'$CMD_CREATEDB'"'
  #eval $FULLCMD_CREATEDB >> /tmp/mysqldocker.log
  CMD_GRANT=" GRANT ALL PRIVILEGES ON *.* TO root@'%' IDENTIFIED BY '"$DATABASE_PASSWORD"' WITH GRANT OPTION; FLUSH PRIVILEGES"
  FULLCMD_GRANT='mysql -uroot -p'$DATABASE_PASSWORD' mysql -e "'$CMD_GRANT'"'
  eval $FULLCMD_GRANT >> /tmp/mysqldocker.log
  killall mysqld && sleep 5
fi
/usr/bin/mysqld_safe
