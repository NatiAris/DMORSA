#!/bin/bash

./cl_shutdown.sh
mongo --norc --port 40000 < shutdown.js
./cl_run.sh

#mongo --port 30001 --eval="quit()"
#mongo --port 30101 --eval="quit()"
#mongo --port 30201 --eval="quit()"
mongo --norc --port 30001 --eval="rs.isMaster()"
mongo --norc --port 30101 --eval="rs.isMaster()"
mongo --norc --port 30201 --eval="rs.isMaster()"
mongos --configdb conf/localhost:30001,localhost:30002,localhost:30003 --port 40000 --fork --logpath ./data/logs/mongos.log
#read -p "Press enter to continue"
mongo --norc --port 40000 --eval="sh.status()"
#read -p "Press enter just because"
