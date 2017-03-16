#!/bin/bash

./shutdown.sh
./run.sh

mongos --configdb conf/localhost:30001,localhost:30002,localhost:30003 --port 40000 --fork --logpath ./data/logs/mongos.log
#mongo --norc --port 40000 --eval="sh.status()"
