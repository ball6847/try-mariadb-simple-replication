#!/bin/bash -e

MYSQL1="docker-compose exec mysql1 mysql -u root -prootpassword db"
MYSQL2="docker-compose exec mysql2 mysql -u root -prootpassword db"

printf "MYSQL1: DROPPING TABLE IF NECCESSARY ..."
$MYSQL1 -e "DROP TABLE IF EXISTS people;"
echo "DONE"
printf "MYSQL2: DROPPING TABLE IF NECCESSARY ..."
$MYSQL2 -e "DROP TABLE IF EXISTS people;"
echo "DONE"

# -------------------------------------------------

printf "MYSQL1: DUMPING INITIAL DATA ... "
$MYSQL1 -e "`cat ./people.sql`"
echo "DONE"

# -------------------------------------------------

printf "MYSQL1: EXPECT \"SELECT COUNT(*)\" RESULT TO BE 100 ... "
COUNT_RESULT=`$MYSQL1 -sN -e "SELECT COUNT(*) FROM people;" | tr -d '[:space:]'`
if [[ "$COUNT_RESULT" == "100" ]]; then
  echo "OK"
else
  echo "FAIL"
fi

# -------------------------------------------------

printf "MYSQL2: EXPECT \"SELECT COUNT(*)\" RESULT TO BE 100 ... "
COUNT_RESULT=`$MYSQL2 -sN -e "SELECT COUNT(*) FROM people;" | tr -d '[:space:]'`
if [[ "$COUNT_RESULT" == "100" ]]; then
  echo "OK"
else
  echo "FAIL"
fi

# -------------------------------------------------

printf "MYSQL2: ADDING MORE DATA ... "
$MYSQL2 -e "`cat ./people.sql`"
echo "DONE"

# -------------------------------------------------

printf "MYSQL1: EXPECT \"SELECT COUNT(*)\" RESULT TO BE 200 ... "
COUNT_RESULT=`$MYSQL1 -sN -e "SELECT COUNT(*) FROM people;" | tr -d '[:space:]'`
if [[ "$COUNT_RESULT" == "200" ]]; then
  echo "OK"
else
  echo "FAIL"
fi

# -------------------------------------------------

printf "MYSQL2: EXPECT \"SELECT COUNT(*)\" RESULT TO BE 200 ... "
COUNT_RESULT=`$MYSQL2 -sN -e "SELECT COUNT(*) FROM people;" | tr -d '[:space:]'`
if [[ "$COUNT_RESULT" == "200" ]]; then
  echo "OK"
else
  echo "FAIL"
fi

# -------------------------------------------------

printf "MYSQL1: STOPPING MYSQL ..."
docker-compose stop mysql1
echo "DONE"

# -------------------------------------------------

printf "MYSQL2: ADDING MORE DATA ... "
$MYSQL2 -e "`cat ./people.sql`"
echo "DONE"

# -------------------------------------------------

echo "MYSQL2: IT SHOULD STILL FUNCTIONING PROPERLY"
printf "MYSQL2: EXPECT \"SELECT COUNT(*)\" RESULT TO BE 300 ... "
COUNT_RESULT=`$MYSQL2 -sN -e "SELECT COUNT(*) FROM people;" | tr -d '[:space:]'`
if [[ "$COUNT_RESULT" == "300" ]]; then
  echo "OK"
else
  echo "FAIL"
fi

# -------------------------------------------------

printf "MYSQL1: STARTING MYSQL ..."
docker-compose start mysql1
sleep 10
echo "DONE"

# -------------------------------------------------

echo "MYSQL1: IT SHOULD KEEP UP WITH ANOTHER NODE"
printf "MYSQL1: EXPECT \"SELECT COUNT(*)\" RESULT TO BE 300 ... "
COUNT_RESULT=`$MYSQL1 -sN -e "SELECT COUNT(*) FROM people;" | tr -d '[:space:]'`
if [[ "$COUNT_RESULT" == "300" ]]; then
  echo "OK"
else
  echo "FAIL"
fi
