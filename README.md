Follow this step to test this functional

```sh
# start up docker service
# this will create 2 instance of mysql, mysql1 & mysql2
docker-compose up -d

# wait until it bootstrap the instances
# see output from logs
docker-compose logs -f

# run step1.sh you should got 2 files in working directory
# - server1-binlog-file
# - server1-binlog-position
# note - this step simply getting replication info from mysql1
./step1.sh

# run step2.sh you should got another 2 files
# - server2-binlog-file
# - server2-binlog-position
# note - this step use data from step1, setup replication from mysql1 to mysql2
./step2.sh

# run step3.sh this will complete the setup
# note - this step use data from step2, setup replication link back to mysql2
./step3.sh

# run test
./test.sh

```

You should see output from `test.sh` like this one.

```
MYSQL1: DROPPING TABLE IF NECCESSARY ...DONE
MYSQL2: DROPPING TABLE IF NECCESSARY ...DONE
MYSQL1: DUMPING INITIAL DATA ... DONE
MYSQL1: EXPECT "SELECT COUNT(*)" RESULT TO BE 100 ... OK
MYSQL2: EXPECT "SELECT COUNT(*)" RESULT TO BE 100 ... OK
MYSQL2: ADDING MORE DATA ... DONE
MYSQL1: EXPECT "SELECT COUNT(*)" RESULT TO BE 200 ... OK
MYSQL2: EXPECT "SELECT COUNT(*)" RESULT TO BE 200 ... OK
Stopping testmariadbbinlog_mysql1_1 ... done
DONE
MYSQL2: ADDING MORE DATA ... DONE
MYSQL2: IT SHOULD STILL FUNCTIONING PROPERLY
MYSQL2: EXPECT "SELECT COUNT(*)" RESULT TO BE 300 ... OK
Starting mysql1 ... done
DONE
MYSQL1: IT SHOULD KEEP UP WITH ANOTHER NODE
MYSQL1: EXPECT "SELECT COUNT(*)" RESULT TO BE 300 ... OK
```
