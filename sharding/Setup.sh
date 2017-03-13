#!/bin/bash

./cl_shutdown.sh
mongo --norc --port 40000 < shutdown.js
./clear_data.sh
./cl_run.sh

#mongo --norc --port 30001 --eval="rs.status()"
mongo --norc --port 30001 < j_conf.js
mongo --norc --port 30101 < j_sh1.js
mongo --norc --port 30201 < j_sh2.js
mongos --configdb conf/localhost:30001,localhost:30002,localhost:30003 --port 40000 --fork --logpath ./data/logs/mongos.log
#read -p "Press enter to continue"
mongo --norc --port 40000 < j_cluster.js
mongo --norc --port 40000
