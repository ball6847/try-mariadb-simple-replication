#!/bin/bash -e

MYSQL="docker-compose exec mysql1 mysql -u root -prootpassword -e "

# TODO: grant specific db
$MYSQL "GRANT REPLICATION SLAVE ON *.* TO 'user'@'%';"
STATUS=$($MYSQL "SHOW MASTER STATUS;")

echo "$STATUS"

if [[ "$STATUS" =~ \|[[:space:]]+(mariadb-bin\.[0-9]+)[[:space:]]+\| ]]; then 
  echo "${BASH_REMATCH[1]}" > ./server1-binlog-file
else
  echo "error parsing log file"
fi

if [[ "$STATUS" =~ \|[[:space:]]+([0-9]+)[[:space:]]+\| ]]; then 
  echo "${BASH_REMATCH[1]}" > ./server1-binlog-position
else
  echo "error parsing log position"
fi
