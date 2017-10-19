#!/bin/bash -e

MYSQL="docker-compose exec mysql1 mysql -u root -prootpassword -e "

LOGBIN=`cat ./server2-binlog-file`
LOGPOS=`cat ./server2-binlog-position`

$MYSQL "STOP SLAVE; \
CHANGE MASTER TO \
MASTER_HOST = 'mysql2', \
MASTER_USER = 'user', \
MASTER_PASSWORD = 'password', \
MASTER_LOG_FILE = '$LOGBIN', \
MASTER_LOG_POS = $LOGPOS; \
START SLAVE;"
