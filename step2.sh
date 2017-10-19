#!/bin/bash -e

MYSQL="docker-compose exec mysql2 mysql -u root -prootpassword -e "

LOGBIN=`cat ./server1-binlog-file`
LOGPOS=`cat ./server1-binlog-position`

$MYSQL "GRANT REPLICATION SLAVE ON *.* TO 'user'@'%'; \
STOP SLAVE; \
CHANGE MASTER TO \
MASTER_HOST = 'mysql1', \
MASTER_USER = 'user', \
MASTER_PASSWORD = 'password', \
MASTER_LOG_FILE = '$LOGBIN', \
MASTER_LOG_POS = $LOGPOS; \
START SLAVE;"

STATUS=$($MYSQL "SHOW MASTER STATUS;")

echo "$STATUS"

if [[ "$STATUS" =~ \|[[:space:]]+(mariadb-bin\.[0-9]+)[[:space:]]+\| ]]; then 
  echo "${BASH_REMATCH[1]}" > ./server2-binlog-file
else
  echo "error parsing log file"
fi

if [[ "$STATUS" =~ \|[[:space:]]+([0-9]+)[[:space:]]+\| ]]; then 
  echo "${BASH_REMATCH[1]}" > ./server2-binlog-position
else
  echo "error parsing log position"
fi
